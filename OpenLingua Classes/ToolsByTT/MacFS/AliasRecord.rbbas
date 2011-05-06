#tag Class
Protected Class AliasRecord
	#tag Method, Flags = &h0
		Sub Constructor(data as String)
		  mAliasData = data
		  parse
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Data() As String
		  return mAliasData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FromHFSUniStr255BE(uniStr as MemoryBlock) As String
		  // This class needs it own function for HFSUniStr255 conversion because
		  // it must ensure that always Big Endian is used, while other MacFS functions
		  // that get such strings from the OS will get them passed in the native Endianness
		  uniStr.LittleEndian = false
		  return uniStr.StringValue(2,uniStr.Short(0)*2).DefineEncoding(Encodings.UTF16BE).ConvertEncoding(Encodings.UTF8)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsValid() As Boolean
		  return mValid
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ItemName(posix as Boolean) As String
		  return replaceChr1(mItemName, posix)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParentDirName(posix as Boolean) As String
		  return replaceChr1(mParDirName, posix)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub parse()
		  // See http://xhelmboyx.tripod.com/formats/alias-layout.txt
		  // There are 3 parts: The header, an array of records, and data past the former two parts ("tail")
		  
		  mValid = false
		  mTail = nil
		  mRecords = new Dictionary
		  redim mDirNames(-1)
		  redim mDirIDs(-1)
		  
		  mAliasData.LittleEndian = false // Alias data is always big endian
		  
		  mHead.StringValue(mAliasData.LittleEndian) = mAliasData.StringValue(0,mHead.Size)
		  
		  dim extraLen as Integer = mAliasData.Size - mHead.totalSize
		  if extraLen < 0 then
		    // not valid
		    break
		    return
		  end
		  
		  if extraLen > 0 then
		    break
		    mTail = mAliasData.StringValue(mHead.totalSize, extraLen)
		  end
		  
		  dim itemName, volName, parDirName, absPath, volumePath, posixPath as String
		  
		  // preset with values from Header
		  itemName = mHead.itemName.LeftB(mHead.itemNameLen).DefineEncoding(Encodings.SystemDefault).ReplaceAll("/",Chr(1))
		  volName = mHead.volName.LeftB(mHead.volNameLen).DefineEncoding(Encodings.SystemDefault).ReplaceAll(":","").ReplaceAll("/",Chr(1))
		  
		  dim ofs as Integer = mHead.Size
		  while (mHead.totalSize - ofs) >= 4
		    dim type as Int16 = mAliasData.UInt16Value(ofs)
		    if type = -1 then exit
		    dim dataLen as Integer = mAliasData.UInt16Value(ofs+2)
		    dim data as String = mAliasData.StringValue(ofs+4, dataLen)
		    if RecordType(type) = RecordType.DirIDs then
		      dim mb as MemoryBlock = data
		      mb.LittleEndian = false
		      for i as integer = 0 to mb.Size-4 step 4
		        mDirIDs.Append mb.UInt32Value(i)
		      next
		    elseif RecordType(type) = RecordType.DirName then
		      parDirName = data.DefineEncoding(Encodings.SystemDefault).ReplaceAll("/",Chr(1))
		    elseif RecordType(type) = RecordType.AbsPath then
		      absPath = data.DefineEncoding(Encodings.SystemDefault).ReplaceAll("/",Chr(1))
		    elseif RecordType(type) = RecordType.VolumePath then
		      volumePath = data.DefineEncoding(Encodings.UTF8).ReplaceAll(":",Chr(1))
		    elseif RecordType(type) = RecordType.HomePath then
		      posixPath = data.DefineEncoding(Encodings.UTF8).ReplaceAll(":",Chr(1))
		    elseif RecordType(type) = RecordType.ItemNameUnicode then
		      itemName = FromHFSUniStr255BE (data).ReplaceAll(":",Chr(1))
		    elseif RecordType(type) = RecordType.VolNameUnicode then
		      volName = FromHFSUniStr255BE (data).ReplaceAll(":",Chr(1))
		    else
		      dim mb as MemoryBlock = data
		      mRecords.Value(type) = mb
		    end
		    ofs = ofs + 4 + dataLen
		    if (ofs mod 2) = 1 then ofs = ofs + 1
		  wend
		  
		  if mHead.ParID = 2 then
		    parDirName = "" // there no parent dir name if item was in root dir (the vol name doesn't count here)
		  end
		  
		  if posixPath <> "" then
		    // build path from posixPath
		    mDirNames = posixPath.Split("/")
		    if mDirNames(0) = "" then
		      mDirNames.Remove 0 // remove the leading "/"
		    end if
		  else
		    // build path from older absPath (attn: this _could_ contain 31-char-shortened dirnames, which isn't helpful for locating the item!)
		    mDirNames = absPath.Split(":")
		    mDirNames.Remove 0 // remove the volume name
		  end if
		  
		  dim topName as String = mDirNames.Pop
		  if topName <> itemName then
		    break
		  end if
		  
		  if mDirNames.Ubound >= 0 then
		    mParDirName = mDirNames(mDirNames.Ubound)
		    if parDirName <> "" and mParDirName <> parDirName then
		      // that's odd
		      break
		    end
		  end
		  
		  mVolName = volName
		  mItemName = topName // rather than itemName in order to prefer the UTF-encoding
		  
		  mValid = true
		  
		exception exc as RuntimeException
		  if exc isA ThreadEndException then
		    // ok
		    raise exc
		  else
		    break
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PathWithoutVolumeAndItem(posix as Boolean) As String
		  dim s as String
		  if mDirNames.Ubound >= 0 then
		    if posix then
		      s = "/"
		    else
		      s = ":"
		    end
		    s = replaceChr1 (Join(mDirNames,s), posix)
		    if not posix then
		      s = ":" + s
		    end if
		  end
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function replaceChr1(s as String, posix as Boolean) As String
		  if posix then
		    return s.ReplaceAll(Chr(1),"/")
		  else
		    return s.ReplaceAll(Chr(1),":")
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VolumeName(posix as Boolean) As String
		  return replaceChr1(mVolName, posix)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAliasData As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDirIDs() As UInt32
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDirNames() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHead As Head
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mItemName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mParDirName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			Key: type as Int16 (signed)
		#tag EndNote
		Private mRecords As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTail As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mValid As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mVolName As String
	#tag EndProperty


	#tag Structure, Name = Head, Flags = &h21
		userType as OSType
		  totalSize as UInt16
		  version as UInt16
		  kind as UInt16
		  volNameLen as Byte
		  volName as String*27
		  volCrDate as UInt32
		  volSig as UInt16
		  driveType as UInt16
		  parID as UInt32
		  itemNameLen as Byte
		  itemName as String*63
		  itemID as UInt32
		  itemCrDate as UInt32
		  fileType as OSType
		  creatorCode as OSType
		  nlvlFrom as UInt16
		  nlvlTo as UInt16
		  volAttrs as UInt32
		  fsID as String*2
		resv as String*10
	#tag EndStructure

	#tag Structure, Name = Record, Flags = &h21
		type as UInt16
		length as UInt16
	#tag EndStructure


	#tag Enum, Name = RecordType, Type = Int16, Flags = &h0
		DirName
		  DirIDs
		  AbsPath
		  ZoneName
		  ServerName
		  UserName
		  DriverName
		  unknown7
		  unknown8
		  ASInfo
		  DialUpInfo
		  unknown11
		  unknown12
		  unknown13
		  ItemNameUnicode
		  VolNameUnicode
		  unknown16
		  unknown17
		  HomePath
		  VolumePath
		  unknown20
		UInt16_val
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

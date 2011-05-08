#tag Class
Protected Class LinguaTranslationPool
	#tag Method, Flags = &h0
		Sub Add(grp as LinguaRecordSet)
		  mRecords.Add new LinguaFileRecord ("enty", grp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub assert(cond as Boolean, msg as String, recPos as UInt64 = - 1, f as FolderItem = nil)
		  if not cond then
		    if f <> nil then
		      setError "Error during file read (name "+f.Name+", position: "+Format(recPos,"#")+"): "+msg
		    else
		      setError msg
		    end
		    raise new LinguaAssertionException
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearError()
		  mLastErrorMsg = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  me.Constructor ""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(lang as String)
		  mRecords = new LinguaRecordSet (me)
		  mLanguage = lang
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExportTabDelimited() As String()
		  dim result() as String
		  
		  dim platformNames() as String = tabFilePlatformNames()
		  dim TAB as String = chr(9)
		  
		  for each rec as LinguaFileRecord in mRecords.AllItems
		    if rec.Value.Type = Variant.TypeObject and rec.Value.ObjectValue isA LinguaRecordSet then
		      dim grp as LinguaRecordSet = rec.Value
		      result.Append _
		      grp.Identifier + TAB + _
		      platformNames(grp.Platform) + TAB + _
		      tabEscaped (grp.Original) + TAB + _
		      tabEscaped (grp.Translation)
		    end if
		  next
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FileRef() As FolderItem
		  return mFileRef
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function History() As LinguaTranslationPool()
		  return mHistory
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ImportKeyValuePairs(kvp as Dictionary, preferredPlatform as Integer)
		  // Go over all our records, building a dictionary with identifiers as keys
		  dim records as new Dictionary // Value: LinguaRecordSet
		  for each rec as LinguaFileRecord in mRecords.AllItems
		    if rec.Value.Type = Variant.TypeObject and rec.Value.ObjectValue isA LinguaRecordSet then
		      dim grp as LinguaRecordSet = rec.Value
		      if grp.Platform = 0 or grp.Platform = preferredPlatform then
		        if grp.Platform = preferredPlatform or not records.HasKey(grp.Identifier) then
		          records.Value(grp.Identifier) = grp
		        end
		      end
		    end if
		  next
		  
		  // Now assign the new values to our records
		  dim goodCount as Integer
		  dim unknownIdents() as String
		  for each ident as String in kvp.Keys
		    dim grp as LinguaRecordSet = records.Lookup(ident, nil)
		    if grp = nil then
		      unknownIdents.Append ident
		    else
		      goodCount = goodCount + 1
		      grp.SetTranslation kvp.Value(ident)
		    end if
		  next
		  
		  if unknownIdents.Ubound >= 0 then
		    const maxToShow = 10
		    dim n as String
		    if unknownIdents.Ubound >= maxToShow then
		      // name no more than 10, so that msgbox text won't overfill when there's 100s
		      while unknownIdents.Ubound >= maxToShow
		        call unknownIdents.Pop
		      wend
		      n = Str(unknownIdents.Ubound+1)+" or more"
		    else
		      n = Str(unknownIdents.Ubound+1)
		    end
		    MsgBox "There are "+n+" out of "+Str(kvp.Count)+" items that are unknown and therefore not imported:"+_
		    EndOfLine+EndOfLine+Join(unknownIdents,", ")+")"
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsRBLCurrent() As Boolean
		  // Returns false if the RBL file on disk has been changed,
		  // meaning that our date is not the same or newer as the one on disk.
		  
		  return mUTCFromSave = mFileRef.ModificationDate.UTCDateTime
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Language() As String
		  return mLanguage
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastErrorMessage() As String
		  return mLastErrorMsg
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LoadFromRBL(f as FolderItem) As Boolean
		  // Erases any existing records
		  
		  mFileRef = nil
		  
		  dim strm as BinaryStream
		  
		  try
		    strm = BinaryStream.Open (f, false)
		  catch
		  end try
		  
		  if strm = nil or strm.LastErrorCode <> 0 then
		    setFileError "open", strm, f
		    return false
		  end if
		  
		  if LoadFromStream (strm, f) then
		    mFileRef = f
		    MakeRBLCurrent
		    return true
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function LoadFromStream(strm as BinaryStream, f as FolderItem) As Boolean
		  resetBeforeLoad
		  
		  // make sure we read all values as Big Endian
		  strm.LittleEndian = false
		  
		  // verify file header
		  if strm.Read(8) <> "rblocale" then
		    setDataReadError "not an rbl file", f
		    return false
		  end
		  
		  // read all records
		  if not readGroup (f, strm, strm.Length-strm.Position, mRecords) then return false
		  
		  // verify file version
		  if mRecords.Value ("vers") <> 0 then
		    setDataReadError "missing or unsupported version", f
		    return false
		  end
		  
		  mLanguage = mRecords.Value("lang")
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeRBLCurrent()
		  mUTCFromLoad = mFileRef.ModificationDate.UTCDateTime
		  mUTCFromSave = mUTCFromLoad
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RawRecords() As LinguaRecordSet
		  return mRecords
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function readGroup(f as FolderItem, strm as BinaryStream, groupSize as UInt64, ByRef group as LinguaRecordSet) As Boolean
		  group = new LinguaRecordSet (me)
		  
		  dim endPos as UInt64 = strm.Position + groupSize
		  
		  while strm.Position < endPos
		    dim rec as LinguaFileRecord
		    dim pos as UInt64 = strm.Position
		    if not readRecord (f, strm, rec) then return false
		    if rec <> nil then
		      group.Add (rec)
		    end if
		  wend
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function readRecord(f as FolderItem, strm as BinaryStream, ByRef rec as LinguaFileRecord) As Boolean
		  dim strLen, dataLen as Integer, key, type as String
		  dim dataStart as UInt64
		  
		  key = strm.Read(4, Encodings.ASCII)
		  dataLen = strm.ReadInt32
		  dataStart = strm.Position
		  
		  rec = new LinguaFileRecord (key)
		  
		  if key = "enty" then
		    // a translation group
		    
		    dim group as LinguaRecordSet
		    if not readGroup (f, strm, dataLen, group) then return false
		    rec.Value = group
		    
		  else
		    // a generic entry
		    
		    type = strm.Read(4, Encodings.ASCII)
		    
		    select case type
		      
		    case "long"
		      dim l as Integer
		      l = strm.ReadInt32
		      select case l
		      case 4
		        rec.Value = strm.ReadInt32
		      else
		        assert false, "unknown 'long' type", dataStart-8, f
		      end
		      
		    case "strn"
		      strLen = strm.ReadInt32
		      dim skip as Integer = dataLen-8-strLen
		      assert skip >= 0, "invalid data length", dataStart-8, f
		      rec.Value = strm.Read (strLen, Encodings.UTF8)
		      if skip > 0 then
		        strm.Position = strm.Position + skip
		      end if
		      
		    case "bind" // binary data
		      dim l as Integer
		      l = strm.ReadInt32
		      dim s as String
		      s = strm.Read (l, nil)
		      
		      if key = "hist" then
		        dim histLTP as new LinguaTranslationPool
		        if histLTP.LoadFromStream(new BinaryStream(s),f) then
		          mHistory.Append histLTP
		          rec = nil
		        else
		          break
		        end if
		      else
		        dim mb as MemoryBlock = s
		        rec.Value = mb // needs to be stored as MemoryBlock so that it type remains "bind" on Save
		      end
		      
		    else
		      assert false, "unknown type: "+type, dataStart-8, f
		    end
		    
		  end
		  
		  assert dataStart + dataLen = strm.Position, "inconsistent data length", dataStart-8, f
		  
		  return true
		  
		exception exc as LinguaAssertionException
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RecordsBackup() As MemoryBlock
		  // saves just the current records, no history etc.
		  dim mb as new MemoryBlock (4)
		  dim strm as new BinaryStream(mb)
		  strm.LittleEndian = false
		  if not writeGroup (nil, strm, mRecords) then return nil
		  mb.Size = strm.Position
		  return mb
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RecordsRestore(mb as MemoryBlock)
		  if mb <> nil and mb.Size > 0 then
		    dim strm as new BinaryStream(mb)
		    strm.LittleEndian = false
		    if not readGroup (nil, strm, strm.Length, mRecords) then
		      break
		    end
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReloadFromRBL() As Boolean
		  // Keeps current version if load fails
		  
		  dim f as FolderItem = mFileRef
		  dim strm as BinaryStream
		  try
		    strm = BinaryStream.Open (f, false)
		  catch
		  end try
		  if strm = nil or strm.LastErrorCode <> 0 then
		    setFileError "open", strm, f
		    return false
		  end if
		  
		  if LoadFromStream (strm, f) then
		    MakeRBLCurrent
		    return true
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub resetBeforeLoad()
		  ClearError
		  mRecords = nil
		  redim mHistory(-1)
		  mLanguage = ""
		  mDirty = false
		  mUTCFromLoad = ""
		  mUTCFromSave = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SaveToRBL() As Boolean
		  dim f as FolderItem = mFileRef
		  
		  dim mb as new MemoryBlock (200 * mRecords.AllItems.Ubound * (1+mHistory.Ubound))
		  dim strm as new BinaryStream(mb)
		  
		  if not SaveToStream (strm, f) then
		    return false
		  end
		  
		  mb.Size = strm.Length
		  
		  dim withBackup as Boolean
		  if mUTCFromLoad = f.ModificationDate.UTCDateTime then
		    // We perform a backup only for the first save after having loaded the RBL
		    // file, not for further saves. This ensures we keep a backup of the previous
		    // version that might have been created by RS' Lingua or the RS IDE.
		    withBackup = true
		  end
		  
		  if f.Save (mb, withBackup) then
		    f.MacType = DropFileTypes.LinguaFile.MacType
		    f.MacCreator = DropFileTypes.LinguaFile.MacCreator
		    mUTCFromSave = f.ModificationDate.UTCDateTime
		    me.IsDirty = false
		    return true
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SaveToStream(strm as BinaryStream, f as FolderItem) As Boolean
		  // make sure we write all values as Big Endian
		  strm.LittleEndian = false
		  
		  // write file header
		  strm.Write "rblocale"
		  
		  // write all records
		  if not writeGroup (f, strm, mRecords) then return false
		  
		  // write history
		  for each ltp as LinguaTranslationPool in mHistory
		    dim mb as new MemoryBlock(0)
		    dim outStream as new BinaryStream(mb)
		    if not ltp.SaveToStream(outStream, f) then return false
		    mb.Size = outStream.Length
		    dim rec as new LinguaFileRecord ("hist", mb)
		    if not writeRecord (f, strm, rec) then return false
		  next
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setDataReadError(msg as String, f as FolderItem)
		  setError "Error during file read (name "+f.Name+"): "+msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setError(msg as String)
		  me.mLastErrorMsg = msg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setFileError(where as String, strm as BinaryStream, f as FolderItem)
		  dim msg as String = "Error during file "+where+" on "+f.AbsolutePath
		  if strm <> nil then
		    msg = msg+" (code: "+Str(strm.LastErrorCode)+")"
		  end
		  setError msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function tabEscaped(s as String) As String
		  dim TAB as String = chr(9)
		  dim EOL as String = chr(13)
		  
		  s = ReplaceLineEndings(s,EOL)
		  return s.ReplaceAll (TAB,"\t").ReplaceAll (EOL,"\r")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function tabFilePlatformNames() As String()
		  static names() as String
		  if names.Ubound < 0 then
		    names = Array ("Any", "Mac OS", "Windows", "Linux")
		  end if
		  return names
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function writeGroup(f as FolderItem, strm as BinaryStream, group as LinguaRecordSet) As Boolean
		  for each rec as LinguaFileRecord in group.AllItems
		    if not writeRecord (f, strm, rec) then return false
		  next
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function writeRecord(f as FolderItem, strm as BinaryStream, rec as LinguaFileRecord) As Boolean
		  dim pos, dataStart as UInt64
		  
		  assert rec.Key.LenB = 4, "illegal key length"
		  
		  strm.Write rec.Key
		  dataStart = strm.Position
		  
		  strm.WriteInt32 0 // will be updated below
		  
		  if rec.Value.ObjectValue isA LinguaRecordSet then
		    if not writeGroup (f, strm, rec.Value) then return false
		  else
		    select case rec.Value.Type
		    case Variant.TypeInteger
		      strm.Write "long"
		      strm.WriteInt32 4
		      strm.WriteInt32 rec.Value.IntegerValue
		    case Variant.TypeString
		      dim s as String = rec.Value
		      if s.Encoding <> nil then
		        s = s.ConvertEncoding(Encodings.UTF8)
		      end if
		      strm.Write "strn"
		      strm.WriteInt32 s.LenB
		      strm.Write s
		    case Variant.TypeObject
		      if rec.Value.ObjectValue isA MemoryBlock then
		        dim mb as MemoryBlock = rec.Value
		        strm.Write "bind"
		        strm.WriteInt32 mb.Size
		        strm.Write mb
		      else
		        raise new UnsupportedFormatException
		      end
		    else
		      raise new UnsupportedFormatException
		    end
		  end
		  
		  // finally update the size info right after the key we wrote earlier
		  pos = strm.Position
		  strm.Position = dataStart
		  strm.WriteInt32 pos - dataStart - 4
		  strm.Position = pos // seek back
		  
		  return true
		  
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Written 2009, 2011 by Thomas Tempelmann
		For the Public Domain
		Project Home: https://github.com/tempelmann/OpenLingua
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mDirty
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mDirty = value
			End Set
		#tag EndSetter
		IsDirty As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mDirty As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFileRef As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHistory() As LinguaTranslationPool
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLanguage As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastErrorMsg As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRecords As LinguaRecordSet
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUTCFromLoad As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUTCFromSave As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsDirty"
			Group="Behavior"
			Type="Boolean"
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

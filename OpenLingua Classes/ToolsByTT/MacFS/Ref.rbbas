#tag Class
Protected Class Ref
Inherits MemoryBlock
	#tag Method, Flags = &h21
		Private Function allowNULL(mb as MemoryBlock) As Ptr
		  if mb <> nil then
		    return mb
		  end
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  #if RBVersion > 2008.01
		    super.Constructor(80)
		  #else
		    super.MemoryBlock(80)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor(f as FolderItem)
		  // we don't want to offer this here because it might fail if f.Exists=false.
		  // better to call MacRef which can return nil in such as case
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(mb as MemoryBlock)
		  if mb.Size <> 80 then raise new RuntimeException
		  super.Constructor(80)
		  me.StringValue(0,80) = mb.StringValue(0,80)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equals(ref2 as Ref) As Boolean
		  #if TargetMacOS
		    declare function FSCompareFSRefs lib CarbonFramework (ref1 as Ptr, ref2 as Ptr) as Integer
		    
		    return FSCompareFSRefs (me, ref2) = 0
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function FromPOSIXPath(posixPath as String) As Ref
		  #if targetMacOS
		    const kCFURLPOSIXPathStyle = 0
		    declare function CFURLCreateWithFileSystemPath lib CarbonLib (allocator as ptr, filePath as CFStringRef, pathStyle as Integer, isDirectory as Boolean) as Ptr
		    declare function CFURLGetFSRef lib CarbonLib (CFURLRef as Ptr, newRefOut as Ptr) as Boolean
		    declare sub CFRelease lib CarbonLib (cf as Ptr)
		    
		    dim url as Ptr = CFURLCreateWithFileSystemPath (nil, posixPath, kCFURLPOSIXPathStyle, false)
		    if url <> nil then
		      dim fsRef as new Ref
		      dim ok as Boolean = CFURLGetFSRef (url, fsRef)
		      CFRelease (url)
		      if ok then
		        return fsRef
		      end
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCatalogInfo(wants as Integer, whichInfo as Integer, ByRef info as CatalogBulkInfo, ByRef parentRef as Ref) As Integer
		  #if TargetMacOS
		    
		    dim err as Integer
		    
		    declare Function FSGetCatalogInfo Lib CarbonFramework ( _
		    ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
		    
		    info = new CatalogBulkInfo(1, wants)
		    parentRef = new Ref
		    
		    err = FSGetCatalogInfo (me, whichInfo, allowNULL(info.mInfos), allowNULL(info.mNames), allowNULL(info.mSpecs), parentRef)
		    
		    return err
		    
		  #else
		    
		    return -1
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCatInfo_unused(ByRef name as String) As Integer
		  // replaced by GetCatalogInfo
		  '#if TargetMacOS
		  '
		  'Dim pb, mb, info as MemoryBlock, err, i as Integer, s, s2 as String
		  'Dim dbl as Double
		  '
		  'Declare Function PBGetCatalogInfoSync Lib CarbonFramework (paramBlock as Ptr) as Short Inline68K("205F7076A2603E80")
		  '
		  'if not initedMacFS then
		  'Init()
		  'end
		  '
		  'info = NewMemoryBlock(144) // FSCatalogInfo
		  'mb = NewMemoryBlock(512) // HFSUniStr255
		  '
		  'pb = NewMemoryBlock(72) // FSRefParam
		  'pb.Ptr(28) = me
		  'pb.long(32) = &H4000 + &H8000 // FSCatalogInfoBitmap: dataSize + rsrcSize
		  'pb.Ptr(36) = info
		  'pb.Ptr(68) = mb
		  '
		  'err = PBGetCatalogInfoSync(pb)
		  '
		  'if err = 0 then
		  ''dataLen = info.UInt64Value(104)
		  ''rsrcLen = info.UInt64Value(120)
		  'name = mb.StringValue(2,mb.Short(0)*2).DefineEncoding(hfsEncoding)
		  'else
		  ''dataLen = 0
		  ''rsrcLen = 0
		  'name = ""
		  'end
		  'return err
		  '
		  '#else
		  '
		  'return -1
		  '
		  '#endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetKindText() As String
		  declare function LSCopyKindStringForRef Lib CarbonFramework (ref as Ptr, ByRef outStr as CFStringRef) as Integer
		  
		  dim s as CFStringRef
		  if LSCopyKindStringForRef (me, s) = 0 then
		    return s
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLaunchServicesInfo(whichInfo as UInt32, ByRef info as LSItemInfoRecord) As Integer
		  #if TargetMacOS
		    
		    dim err as Integer
		    
		    declare Function LSCopyItemInfoForRef Lib CarbonFramework ( _
		    ref as Ptr, whichInfo as UInt32, ByRef info as LSItemInfoRecord) as Integer
		    
		    err = LSCopyItemInfoForRef (me, whichInfo, info)
		    
		    return err
		    
		  #else
		    
		    return -1
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAliasFile() As Boolean
		  #if TargetMacOS
		    declare function FSIsAliasFile lib CarbonFramework (ref as Ptr, ByRef isAlias as Boolean, ByRef isFolder as Boolean) as Integer
		    dim err as Integer, isAlias, isFolder as Boolean
		    err = FSIsAliasFile (me, isAlias, isFolder)
		    return isAlias
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function IsAliasFile(lsInfo as LSItemInfoRecord) As Boolean
		  return (lsInfo.flags and UInt32(LSItemInfoFlags.kLSItemInfoIsAliasFile)) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function IsBundle(lsInfo as LSItemInfoRecord) As Boolean
		  return (lsInfo.flags and UInt32(LSItemInfoFlags.kLSItemInfoIsPackage)) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsFolder() As Boolean
		  #if TargetMacOS
		    declare Function FSGetCatalogInfo Lib CarbonFramework ( _
		    ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
		    
		    dim info as new MemoryBlock(144)
		    dim err as Integer
		    
		    err = FSGetCatalogInfo (me, kFSCatInfoNodeFlags, info, nil, nil, nil)
		    if err = 0 then
		      return (info.UInt16Value(0) and kFSNodeIsDirectoryMask) <> 0
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function IsInvisible(lsInfo as LSItemInfoRecord) As Boolean
		  return (lsInfo.flags and UInt32(LSItemInfoFlags.kLSItemInfoIsInvisible)) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function IsSymlink(lsInfo as LSItemInfoRecord) As Boolean
		  return (lsInfo.flags and UInt32(LSItemInfoFlags.kLSItemInfoIsSymlink)) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ItemID() As Integer
		  #if TargetMacOS
		    declare Function FSGetCatalogInfo Lib CarbonFramework ( _
		    ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
		    
		    dim info as new MemoryBlock(144)
		    dim err as Integer
		    
		    err = FSGetCatalogInfo (me, kFSCatInfoNodeID, info, nil, nil, nil)
		    if err = 0 then
		      return info.Long(8)
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MakeFSSpec_unused_here() As Spec
		  #if TargetMacOS
		    
		    dim err as Integer
		    
		    declare Function FSGetCatalogInfo Lib CarbonFramework ( _
		    ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
		    
		    dim spec as new Spec
		    
		    err = FSGetCatalogInfo (me, 0, nil, nil, spec, nil)
		    
		    if err = 0 then
		      return spec
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MakePath() As String
		  #if TargetMacOS
		    declare function FSRefMakePath lib CarbonFramework (ref as Ptr, path as Ptr, maxSize as Integer) as Integer
		    
		    dim mb as new MemoryBlock(PATH_MAX)
		    dim err as Integer
		    
		    err = FSRefMakePath (me, mb, mb.Size)
		    if err = 0 then
		      return mb.CString(0).DefineEncoding(Encodings.UTF8)
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MakeURL() As String
		  #if TargetMacOS
		    
		    declare function CFURLCreateFromFSRef lib CarbonFramework (allocator as Ptr, refIn as Ptr) as Ptr
		    declare function CFURLGetString lib "CoreFoundation" (refIn as Ptr) as Ptr
		    declare function CFStringGetCString lib "CoreFoundation" (strRef as Ptr, buf as Ptr, bufSize as Integer, encoding as UInt32) as Boolean
		    declare function CFStringGetCStringPtr lib "CoreFoundation" (strRef as Ptr, encoding as UInt32) as Ptr
		    declare sub CFRelease lib "CoreFoundation" (ref as Ptr)
		    
		    dim urlRef, strRef as MemoryBlock
		    dim urlStr as String
		    
		    urlRef = CFURLCreateFromFSRef (nil, me)
		    if urlRef = nil then
		      'break
		    else
		      strRef = CFURLGetString(urlRef)
		      dim buf as MemoryBlock
		      buf = CFStringGetCStringPtr (strRef, Encodings.UTF8.Code)
		      if buf = nil then
		        buf = new MemoryBlock(PATH_MAX)
		        call CFStringGetCString (strRef, buf, buf.Size, Encodings.UTF8.Code)
		      end
		      urlStr = buf.CString(0)
		      
		      'this was a work-around for a bug in RB2008r5a3-a4:
		      'if urlStr.LeftB(17) = "file://localhost/" then
		      'urlStr = "file:///"+urlStr.MidB(18)
		      'end if
		      
		      CFRelease (urlRef)
		    end
		    
		    return urlStr.DefineEncoding(Encodings.UTF8)
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewIterator(entireSubTree as Boolean) As Iterator
		  #if TargetMacOS
		    
		    dim flags as Integer
		    if entireSubTree then
		      flags = Iterator.kFSIterateSubtree
		    else
		      // just this one directory
		      flags = Iterator.kFSIterateFlat
		    end
		    try
		      return new Iterator(me, flags)
		    catch
		      return nil
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Parent() As Ref
		  declare Function FSGetCatalogInfo Lib CarbonFramework ( _
		  ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
		  
		  dim parRef as new Ref
		  dim info as new MemoryBlock(144)
		  dim err as Integer
		  
		  err = FSGetCatalogInfo (me, kFSCatInfoNodeID, info, nil, nil, parRef)
		  if err = 0 then
		    dim nodeID as Integer
		    nodeID = info.Long(8)
		    if nodeID = 2 then
		      // for root dirs, parRef is not valid
		    else
		      return parRef
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParentID() As Integer
		  declare Function FSGetCatalogInfo Lib CarbonFramework ( _
		  ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
		  
		  dim info as new MemoryBlock(144)
		  dim err as Integer
		  
		  err = FSGetCatalogInfo (me, kFSCatInfoParentDirID, info, nil, nil, nil)
		  if err = 0 then
		    return info.Long(4)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function POSIXPath() As String
		  return me.MakePath()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Rename(newName as String) As Boolean
		  declare function FSRenameUnicode lib CarbonLib (ref as Ptr, nlen as Integer, name as Ptr, tehint as Integer, newRef as Ptr) as Integer
		  
		  dim newRef as new Ref
		  dim err as Integer
		  
		  dim name as MemoryBlock = newName.ConvertEncoding(hfsEncoding)
		  
		  err = FSRenameUnicode (me, name.Size\2, name, 0, newRef)
		  if err = 0 then
		    // update this Ref
		    me.StringValue(0,me.Size) = newRef.StringValue(0,me.Size)
		    return true
		  else
		    if err = -43 then
		      // oddly, sometimes the rename works but returned -43 (e.g. on a NTFS volume). A retry deals with it, but sometimes a few more retries are needed :(
		      break
		    elseif err <> -37 then // -37 is "locked"
		      System.DebugLog "Renaming error: "+Str(err)
		      break // what's the problem?
		    end if
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VRefNum() As Integer
		  declare Function FSGetCatalogInfo Lib CarbonFramework ( _
		  ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
		  
		  dim info as new MemoryBlock(144)
		  dim err as Integer
		  
		  err = FSGetCatalogInfo (me, kFSCatInfoVolume, info, nil, nil, nil)
		  if err = 0 then
		    return info.Int16Value(2)
		  end if
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetMacOS
			    
			    #if RBVersion >= 2010.05
			      return FolderItem.CreateFromMacFSRef (me)
			    #else
			      // use the "lib hack"
			      
			      declare function REALFolderItemFromParentFSRef lib "" (parentRef as Ptr, name as Ptr) as FolderItem
			      declare Function FSGetCatalogInfo Lib CarbonFramework ( _
			      ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
			      
			      dim info as new MemoryBlock(144)
			      dim itemName as new MemoryBlock(512)
			      dim parRef as new Ref
			      dim err as Integer
			      
			      err = FSGetCatalogInfo (me, kFSCatInfoNodeID, info, itemName, nil, parRef)
			      if err <> 0 then
			        'break
			        return nil
			      elseif info.Long(8) = 2 then
			        // this is a root dir - we cannot use REALFolderItemFromParentFSRef there
			        // hence we let it fall thru to the URL solution below
			      else
			        dim f as FolderItem = REALFolderItemFromParentFSRef (parRef, itemName)
			        if f = nil then break
			        return f
			      end if
			    #endif
			    
			    dim s as String = MakeURL()
			    if s.LenB > 0 then
			      if s.CountFields(":") > 2 then
			        break // at least til 2010r4.1 calling GetTrueFolderItem with ":" in the path (past the "file:" scheme) will crash the app!
			        return nil
			      end
			      dim f as FolderItem = GetTrueFolderItem(s, FolderItem.PathTypeURL)
			      if f = nil then break
			      return f
			    end
			    
			  #endif
			End Get
		#tag EndGetter
		FolderItem As FolderItem
	#tag EndComputedProperty


	#tag Constant, Name = CarbonLib, Type = String, Dynamic = False, Default = \"Carbon", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFInfoFlagsIsInvisible, Type = Double, Dynamic = False, Default = \"&H4000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSCatInfoAllButValence, Type = Double, Dynamic = False, Default = \"&H3DFFF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSCatInfoNodeFlags, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSCatInfoNodeID, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSCatInfoParentDirID, Type = Double, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSCatInfoVolume, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSNodeIsDirectoryMask, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant


	#tag Structure, Name = LSItemInfoRecord, Flags = &h0
		flags as UInt32
		  filetype as OSType
		  creator as OSType
		  extensionCFStringRef as Integer
		  iconFileNameCFStringRef as Integer
		kindID as UInt32
	#tag EndStructure


	#tag Enum, Name = LSItemInfoFlags, Type = UInt32, Flags = &h0
		kLSItemInfoIsPlainFile = &h00000001
		  kLSItemInfoIsPackage = &h00000002
		  kLSItemInfoIsApplication = &h00000004
		  kLSItemInfoIsContainer = &h00000008
		  kLSItemInfoIsAliasFile = &h00000010
		  kLSItemInfoIsSymlink = &h00000020
		  kLSItemInfoIsInvisible = &h00000040
		  kLSItemInfoIsNativeApp = &h00000080
		  kLSItemInfoIsClassicApp = &h00000100
		  kLSItemInfoAppPrefersNative = &h00000200
		  kLSItemInfoAppPrefersClassic = &h00000400
		  kLSItemInfoAppIsScriptable = &h00000800
		  kLSItemInfoIsVolume = &h00001000
		kLSItemInfoExtensionIsHidden = &h00100000
	#tag EndEnum

	#tag Enum, Name = LSRequestedInfo, Type = UInt32, Flags = &h0
		kLSRequestExtension = &h00000001
		  kLSRequestTypeCreator = &h00000002
		  kLSRequestBasicFlagsOnly = &h00000004
		  kLSRequestAppTypeFlags = &h00000008
		  kLSRequestAllFlags = &h00000010
		  kLSRequestIconAndKind = &h00000020
		  kLSRequestExtensionFlagsOnly = &h00000040
		kLSRequestAllInfo = &hFFFFFFFF
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
			Name="LittleEndian"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="MemoryBlock"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Size"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MemoryBlock"
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

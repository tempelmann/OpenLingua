#tag Module
Protected Module MacFS
	#tag Method, Flags = &h21
		Private Function allowNULL(mb as MemoryBlock) As Ptr
		  if mb <> nil then
		    return mb
		  end
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DateFromUTC(dateTime as UTCDateTime) As Date
		  dim v as UInt64 = Bitwise.ShiftLeft(dateTime.highSeconds,32) + dateTime.lowSeconds
		  dim d as new Date
		  d.TotalSeconds = v
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FromHFSUniStr255(uniStr as MemoryBlock) As String
		  uniStr.LittleEndian = TargetLittleEndian
		  return uniStr.StringValue(2,uniStr.Short(0)*2).DefineEncoding(hfsEncoding).ConvertEncoding(Encodings.UTF8)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetAliasInfo(aliasData as MemoryBlock, relativeTo as FolderItem, ByRef itemName as String, ByRef volName as String, ByRef completePath as String) As Boolean
		  // This code isn't so great because it tends to fail with some kinds of Aliases.
		  // Instead, use the AliasFile and AliasRecord classes which read the data directly.
		  
		  #if TargetMacOS
		    
		    declare sub CFRelease Lib CarbonFramework (p as CFStringRef)
		    declare function GetAliasInfo Lib CarbonFramework (aliasHdl as Ptr, infoType as short, str63 as Ptr) as Integer // infoType: -1 -> volume name; 0 -> file name; 1..x -> path component
		    declare function NewHandle Lib CarbonFramework (size as Integer) as Ptr // do not return a struct here as it'll fail on PPC!
		    declare sub DisposeHandle Lib CarbonFramework (hdl as Ptr)
		    declare function FSCopyAliasInfo Lib CarbonFramework (aliasHdl as Ptr, fileName as Ptr, volName as Ptr, byref pathString as CFStringRef, byref whichInfo as UInt32, info as Ptr) as Integer
		    
		    itemName = ""
		    volName = ""
		    completePath = ""
		    
		    if aliasData.Size >= 4 then
		      
		      aliasData.LittleEndian = false
		      if aliasData.UInt32Value(0) = &h00F1D173 then
		        // it's a RB-created Alias with an extra 12-byte header -> remove that now
		        aliasData = MidB (aliasData, 13)
		      end
		      
		      dim err as Integer
		      
		      dim aliasHdl as Ptr = NewHandle (LenB(aliasData))
		      dim mb as MemoryBlock = aliasHdl
		      mb = mb.Ptr(0)
		      mb.StringValue (0, LenB(aliasData)) = aliasData
		      
		      dim fn as new MemoryBlock(512)
		      dim vn as new MemoryBlock(512)
		      dim posixPath as CFStringRef, bitmap as UInt32
		      err = FSCopyAliasInfo (aliasHdl, fn, vn, posixPath, bitmap, nil)
		      if err = 0 then
		        itemName = FromHFSUniStr255(fn)
		        volName = FromHFSUniStr255(vn)
		      else
		        'break
		      end
		      
		      // 'posixPath' can be empty if the item has been created in old times when posix paths weren't used yet!
		      
		      dim pathElems() as String = posixPath.ReplaceAll(":",chr(1)).Split("/")
		      
		      if pathElems.Ubound < 0 then
		        // Happens with old alias files that do not contain newer PosixPaths
		        dim mb2 as MemoryBlock
		        mb2 = NewMemoryBlock (256) // holds the returned strings
		        if volName = "" then
		          err = GetAliasInfo (aliasHdl, -1, mb2)
		          if err = 0 then
		            volName = mb2.PString(0).DefineEncoding (Encodings.SystemDefault)
		          end if
		        end if
		        dim idx as Integer, path() as String
		        do
		          err = GetAliasInfo (aliasHdl, idx, mb2)
		          if err <> 0 then exit
		          dim result as String
		          result = mb2.PString(0).DefineEncoding (Encodings.SystemDefault)
		          if result = "" then exit
		          if idx = 0 and itemName = "" then
		            itemName = result
		          end
		          path.Insert 0, result
		          idx = idx + 1
		        loop
		        if path.Ubound < 0 then
		          break // even this sometimes happens with older Alias files, which are intact but point to nonexisting paths
		          completePath = ""
		        elseif relativeTo <> nil then
		          dim start as String = relativeTo.Parent.AbsolutePath
		          if relativeTo.Name <> path(0) then
		            // then i need to figure out how to merge these two parts better
		            break
		          end if
		          path.Remove 0
		          completePath = start + Join(path,":")
		        else
		          completePath = Join(path,":")
		        end if
		      else
		        pathElems.Remove 0 // this is because the posixPath always starts with "/", creating an empty path at index 0
		        if pathElems(0) = "Volumes" then
		          pathElems.Remove 0
		        else
		          pathElems.Insert 0, Volume(0).Name
		        end if
		        completePath = Join(pathElems,":").ReplaceAll(chr(1),"/")
		      end
		      
		      DisposeHandle (aliasHdl)
		    end
		    
		    return itemName.LenB > 0
		    
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetVolAttr(vr as Integer, ByRef attr as Integer, ByRef extAttr as Integer, ByRef isRemote as Boolean) As Integer
		  #if TargetMacOS
		    soft declare function FSGetVolumeParms lib CarbonFramework (volRefNum as Int16, buf as Ptr, bufSize as Integer) as Integer
		    declare Function PBHGetVolParmsSync Lib CarbonFramework (paramBlock as Ptr) as Short Inline68K("205F7030A2603E80")
		    
		    static useNew as Boolean = true
		    
		    dim infoBuf as MemoryBlock, err as Integer
		    infoBuf = NewMemoryBlock(32)
		    
		    if useNew then
		      try
		        err = FSGetVolumeParms (vr, infoBuf, infoBuf.Size)
		      catch FunctionNotFoundException
		        // ignore
		        useNew = false
		      end
		    end
		    
		    if not useNew then
		      dim pb as MemoryBlock
		      pb = NewMemoryBlock(64)
		      pb.short(22) = vr
		      pb.Ptr(32) = infoBuf
		      pb.long(36) = infoBuf.size
		      err = PBHGetVolParmsSync(pb)
		    end
		    
		    attr = infoBuf.long(2) ' vMAttrib
		    extAttr = infoBuf.long(20) ' vMExtendedAttributes
		    isRemote = infoBuf.long(10) <> 0 ' vMServerAdr
		    return err
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function hfsEncoding() As TextEncoding
		  static initedMacFS as Boolean
		  
		  static hfsEncoding0 as TextEncoding
		  
		  if not initedMacFS then
		    initedMacFS = true
		    
		    #if false
		      // This defines UTF-16 with HFSPlus decomposition rules as needed for some HFS API calls
		      // Unfortunately, it doesn't work (RB 2008r4)
		      const kTextEncodingUnicodeV2_0 = &h0103
		      const kUnicodeHFSPlusDecompVariant = 8
		      const kUnicodeUTF16Format = 0
		      hfsEncoding0 = GetTextEncoding(kTextEncodingUnicodeV2_0, kUnicodeHFSPlusDecompVariant, kUnicodeUTF16Format)
		    #else
		      hfsEncoding0 = Encodings.UTF16
		    #endif
		    
		  end
		  
		  return hfsEncoding0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HFSPlusFullName(extends f as FolderItem) As String
		  dim ref, parRef as Ref, s as String, rl, dl as Double
		  ref = f.MacRef()
		  if ref <> nil then
		    dim bi as CatalogBulkInfo
		    if ref.GetCatalogInfo(CatalogBulkInfo.kWantsNames, 0, bi, parRef) = 0 then
		      return bi.Name(0)
		    end
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsBundle(extends f as FolderItem) As Boolean
		  #if TargetMacOS
		    
		    if f.Directory then
		      dim lsInfo as Ref.LSItemInfoRecord
		      dim flags as UInt32 = UInt32(Ref.LSRequestedInfo.kLSRequestBasicFlagsOnly)
		      if f.MacRef.GetLaunchServicesInfo (flags, lsInfo) = 0 then
		        return Ref.IsBundle (lsInfo)
		      end
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsOnRemoteVolume(extends f as FolderItem) As Boolean
		  return VolIsRemote (f.MacVRefNum)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MacItemID(extends f as FolderItem) As Integer
		  #if TargetMacOS
		    
		    dim err as Integer
		    
		    declare Function FSGetCatalogInfo Lib CarbonFramework ( _
		    ref as Ptr, whichInfo as Integer, catInfo as Ptr, name as Ptr, spec as Ptr, parent as Ptr) as Integer
		    
		    dim catInfo as new MemoryBlock(144)
		    dim r as Ref = f.MacRef
		    if r <> nil then
		      err = FSGetCatalogInfo (r, Ref.kFSCatInfoNodeID, catInfo, nil, nil, nil)
		      if err = 0 then
		        return catInfo.Long(8)
		      end if
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MacPOSIXPath(extends f as FolderItem) As String
		  #if TargetMacOS
		    
		    dim p as String = f.MacRef.POSIXPath
		    
		    if p.LenB = 0 then
		      // file doesn't exist - let's append the name ourselves
		      dim par as FolderItem = f.Parent
		      if par <> nil then
		        p = par.MacPOSIXPath
		      end if
		      p = p + "/" + f.Name
		    end if
		    
		    return p
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MacRef(extends f as FolderItem) As Ref
		  #if TargetMacOS
		    
		    dim theFSRef as Ref
		    dim err as Integer
		    
		    if f <> nil then
		      #if RBVersion >= 2010.05
		        dim r as MemoryBlock = f.MacFSRef
		        theFSRef = new Ref(r)
		      #else
		        if f.Parent is nil then
		          theFSRef = RootFSRef (f.MacVRefNum)
		        else
		          theFSRef = new Ref // without this we'll get a NilObjectException
		          // use the "lib hack" - works before 2010r5
		          declare function REALFSRefFromFolderItem lib "" (f as Object, refOut as Ptr, nameOut as Ptr) as Boolean
		          if not REALFSRefFromFolderItem (f, theFSRef, nil) then
		            theFSRef = nil
		          end
		        end
		      #endif
		    end
		    
		    return theFSRef
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RenameVolume(ByRef v as FolderItem, name as String) As Boolean
		  // Using FolderItem.Name to rename volumes seems to be buggy, see <feedback://showreport?report_id=15500>
		  // Therefore, we do it differently here
		  
		  if v.Parent = nil then
		    // we're dealing with a volume
		    dim vref as Ref = v.MacRef
		    if vref.Rename (name) then
		      v = vref.FolderItem
		      return true
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ResolveAlias(aliasData as MemoryBlock, relativeTo as FolderItem) As FolderItem
		  #if TargetMacOS
		    
		    declare function FSResolveAliasWithMountFlags Lib CarbonFramework (fsrefIn as Ptr, aliasHdl as Integer, fsrefOut as Ptr, ByRef changed as Boolean, flags as UInt32) as Integer
		    declare function NewHandle Lib CarbonFramework (size as Integer) as Integer
		    declare sub DisposeHandle Lib CarbonFramework (hdl as Integer)
		    
		    const kResolveAliasFileNoUI = 1
		    const kResolveAliasTryFileIDFirst = 2
		    
		    dim mb1 as new MemoryBlock(4) // holds just the handle for the alias data
		    mb1.Long(0) = NewHandle (LenB(aliasData))
		    mb1.Ptr(0).Ptr(0).StringValue (0, LenB(aliasData)) = aliasData
		    
		    dim result as Integer
		    dim mb2 as MemoryBlock
		    if relativeTo <> nil then
		      mb2 = relativeTo.MacRef
		    end
		    dim outRef as new Ref
		    dim changed as Boolean
		    result = FSResolveAliasWithMountFlags (allowNULL(mb2), mb1.Long(0), outRef, changed, kResolveAliasFileNoUI)
		    DisposeHandle (mb1.Long(0))
		    if result = 0 then
		      return outRef.FolderItem
		    else
		      return nil
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RootFSRef(extends f as FolderItem) As Ref
		  return RootFSRef (f.MacVRefNum)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function RootFSRef(vr as Integer) As Ref
		  #if TargetMacOS
		    
		    dim pb as MemoryBlock, err as Integer
		    dim ref as new Ref
		    
		    declare Function PBGetVolumeInfoSync Lib CarbonFramework (paramBlock as Ptr) as Short Inline68K("205F7030A2603E80")
		    
		    pb = NewMemoryBlock(44)
		    pb.Short(22) = vr // ioVRefNum
		    pb.Long(28) = 0 // whichInfo
		    pb.Ptr(40) = ref
		    
		    err = PBGetVolumeInfoSync(pb)
		    
		    if err = 0 then
		      return ref
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TrueChildWithPartialName(extends f as FolderItem, name as String) As FolderItem
		  for i as Integer = 1 to f.Count
		    dim c as FolderItem = f.TrueItem(i)
		    if c.Name.InStr(name) > 0 then
		      return c
		    end if
		  next
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function VolIsRemote(vr as Integer) As Boolean
		  dim a1, a2, err as Integer, isRemote as Boolean
		  err = GetVolAttr(vr, a1, a2, isRemote)
		  return err = 0 and isRemote
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function VolSupportsCatalogSearch(vr as Integer) As Boolean
		  dim a1, a2, err as Integer, isRemote as Boolean
		  err = GetVolAttr(vr, a1, a2, isRemote)
		  return err = 0 and Bitwise.BitAnd(a2,4) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function VolSupportsHFSPlus(vr as Integer) As Boolean
		  dim a1, a2, err as Integer, isRemote as Boolean
		  err = GetVolAttr(vr, a1, a2, isRemote)
		  return err = 0 and Bitwise.BitAnd(a2,2) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function VolSupportsLargeFiles(vr as Integer) As Boolean
		  dim a1, a2, err as Integer, isRemote as Boolean
		  err = GetVolAttr(vr, a1, a2, isRemote)
		  return err = 0 and Bitwise.BitAnd(a2,16) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function VolSupportsLongNames(vr as Integer) As Boolean
		  dim a1, a2, err as Integer, isRemote as Boolean
		  err = GetVolAttr(vr, a1, a2, isRemote)
		  return err = 0 and Bitwise.BitAnd(a2,32) <> 0
		End Function
	#tag EndMethod


	#tag Note, Name = About
		MacFS module and included classes written mostly by Thomas Tempelmann (www.tempel.org/rb/)
		Given to the public domain, i.e. do with it what you like
	#tag EndNote


	#tag Constant, Name = CarbonFramework, Type = String, Dynamic = False, Default = \"Carbon.framework", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = JokeRidgeFSID, Type = Double, Dynamic = False, Default = \"19013", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = PATH_MAX, Type = Double, Dynamic = False, Default = \"2048", Scope = Protected
	#tag EndConstant


	#tag Structure, Name = BSDInfo, Flags = &h1
		ownerID as UInt32
		  groupID as UInt32
		  adminFlags as UInt8
		  ownerFlags as UInt8
		  fileMode as UInt16
		special as UInt32
	#tag EndStructure

	#tag Structure, Name = FInfo, Flags = &h1
		fdType as OSType
		  fdCreator as OSType
		  fdFlags as UInt16
		  fdLocation as UInt32
		fdFldr as UInt16
	#tag EndStructure

	#tag Structure, Name = FSCatalogInfo, Flags = &h1
		nodeFlags as UInt16
		  vRefNum as UInt16
		  parDirID as UInt32
		  nodeID as UInt32
		  sharingFlags as UInt8
		  userPrivs as UInt8
		  res1 as UInt8
		  res2 as UInt8
		  createDate as UTCDateTime
		  contentModDate as UTCDateTime
		  attribModDate as UTCDateTime
		  accessDate as UTCDateTime
		  backupDate as UTCDateTime
		  permissions as BSDInfo
		  finderInfo as FInfo
		  extFinderInfo as FXInfo
		  dataLogicalSize as UInt64
		  dataPhysicalSize as UInt64
		  rsrcLogicalSize as UInt64
		  rsrcPhysicalSize as UInt64
		  valence as UInt32
		textEncodingHint as UInt32
	#tag EndStructure

	#tag Structure, Name = FSSearchParams, Flags = &h1
		searchTime as Int32
		  searchBits as UInt32
		  searchNameLength as UInt32
		  searchName as Ptr
		  searchInfo1 as Ptr
		searchInfo2 as Ptr
	#tag EndStructure

	#tag Structure, Name = FXInfo, Flags = &h1
		fdIconID as UInt16
		  fdRes(2) as UInt16
		  fdScript as UInt8
		  fdXFlags as UInt8
		  fdComment as UInt16
		fdPutAway as UInt32
	#tag EndStructure

	#tag Structure, Name = GetVolParmsInfoBuffer, Flags = &h1
		vMVersion as Int16
		  vMAttrib as Int32
		  vMlocalHand as Ptr
		  vMServerAddr as Int32
		  vMVolumeGrade as Int32
		  vMForeignPrivID as Int16
		  vMExtendedAttributes as Int32
		  vMDeviceID as Ptr
		vMMaxNameLength as UInt32
	#tag EndStructure

	#tag Structure, Name = UTCDateTime, Flags = &h1
		highSeconds as UInt16
		  lowSeconds as UInt32
		fraction as UInt16
	#tag EndStructure


	#tag Enum, Name = CatalogInformationBitmapConstants, Type = UInt32, Flags = &h21
		kFSCatInfoNone = 0
		  kFSCatInfoTextEncoding = &h00000001
		  kFSCatInfoNodeFlags = &h00000002
		  kFSCatInfoVolume = &h00000004
		  kFSCatInfoParentDirID = &h00000008
		  kFSCatInfoNodeID = &h00000010
		  kFSCatInfoCreateDate = &h00000020
		  kFSCatInfoContentMod = &h00000040
		  kFSCatInfoAttrMod = &h00000080
		  kFSCatInfoAccessDate = &h00000100
		  kFSCatInfoBackupDate = &h00000200
		  kFSCatInfoPermissions = &h00000400
		  kFSCatInfoFinderInfo = &h00000800
		  kFSCatInfoFinderXInfo = &h00001000
		  kFSCatInfoValence = &h00002000
		  kFSCatInfoDataSizes = &h00004000
		  kFSCatInfoRsrcSizes = &h00008000
		  kFSCatInfoSharingFlags = &h00010000
		  kFSCatInfoUserPrivs = &h00020000
		  kFSCatInfoUserAccess = &h00080000
		  kFSCatInfoSetOwnership = &h00100000
		  kFSCatInfoAllDates = &h000003E0
		  kFSCatInfoGettableInfo = &h0003FFFF
		  kFSCatInfoSettableInfo = &h00001FE3
		kFSCatInfoReserved = &hFFFC0000
	#tag EndEnum

	#tag Enum, Name = CatalogSearchConstants, Type = UInt32, Flags = &h21
		fsSBNodeID = &h00008000
		  fsSBAttributeModDate = &h00010000
		  fsSBAccessDate = &h00020000
		  fsSBPermissions = &h00040000
		  fsSBNodeIDBit = 15
		  fsSBAttributeModDateBit = 16
		  fsSBAccessDateBit = 17
		fsSBPermissionsBit = 18
	#tag EndEnum

	#tag Enum, Name = CatalogSearchMasks, Type = UInt32, Flags = &h21
		fsSBPartialName = 1
		  fsSBFullName    = 2
		  fsSBFlAttrib    = 4
		  fsSBFlFndrInfo  = 8
		  fsSBFlLgLen     = 32
		  fsSBFlPyLen     = 64
		  fsSBFlRLgLen    = 128
		  fsSBFlRPyLen    = 256
		  fsSBFlCrDat     = 512
		  fsSBFlMdDat     = 1024
		  fsSBFlBkDat     = 2048
		  fsSBFlXFndrInfo = 4096
		  fsSBFlParID     = 8192
		  fsSBNegate      = 16384
		  fsSBDrUsrWds    = 8
		  fsSBDrNmFls     = 16
		  fsSBDrCrDat     = 512
		  fsSBDrMdDat     = 1024
		  fsSBDrBkDat     = 2048
		  fsSBDrFndrInfo  = 4096
		fsSBDrParID     = 8192
	#tag EndEnum

	#tag Enum, Name = CatInfoNodeFlags, Type = integer, Flags = &h21
		kFSNodeLockedBit = 0
		  kFSNodeLockedMask = 1
		  kFSNodeResOpenBit = 2
		  kFSNodeResOpenMask = 4
		  kFSNodeDataOpenBit = 3
		  kFSNodeDataOpenMask = 8
		  kFSNodeIsDirectoryBit = 4
		  kFSNodeIsDirectoryMask = 16
		  kFSNodeCopyProtectBit = 6
		  kFSNodeCopyProtectMask = 64
		  kFSNodeForkOpenBit = 7
		  kFSNodeForkOpenMask = 128
		  kFSNodeHardLinkBit = 8
		kFSNodeHardLinkMask = 256
	#tag EndEnum

	#tag Enum, Name = FinderFlags, Type = Integer, Flags = &h21
		kIsOnDesk = &h0001
		  kColor = &h000E
		  kIsShared = &h0040
		  kHasNoINITs = &h0080
		  kHasBeenInited = &h0100
		  kHasCustomIcon = &h0400
		  kIsStationery = &h0800
		  kNameLocked = &h1000
		  kHasBundle = &h2000
		  kIsInvisible = &h4000
		kIsAlias = &h8000
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
End Module
#tag EndModule

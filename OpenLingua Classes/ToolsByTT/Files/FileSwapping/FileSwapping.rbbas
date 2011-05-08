#tag Module
Protected Module FileSwapping
	#tag Method, Flags = &h1
		Protected Function Exchange(f as FolderItem, g as FolderItem) As Boolean
		  #if TargetMacOS
		    If f.MacVRefNum <> g.MacVRefNum then
		      return false
		    End if
		    If VolumeSupportsFSExchangeObjects(f) then
		      if ExchangeObjects (f, g) then
		        return true
		      end if
		    end
		  #endif
		  
		  return Swap (f, g)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ExchangeObjects(f as FolderItem, g as FolderItem) As Boolean
		  #if TargetMacOS
		    Declare Function FSExchangeObjects Lib InterfaceLib (f1 as Ptr, f2 as Ptr) as Integer
		    dim OSError as Integer = FSExchangeObjects(f.MacFSRef, g.MacFSRef)
		    return OSError = 0
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Swap(f as FolderItem, g as FolderItem) As Boolean
		  #if TargetMacOS
		    Declare Function FSGetCatalogInfo Lib InterfaceLib (ref as Ptr, whichInfo as Integer, catalogInfo as Ptr, outName as Ptr, fsSpec as Ptr, parentRef as Ptr) as Short
		    Declare Function FSSetCatalogInfo Lib InterfaceLib (ref as Ptr, whichInfo as Integer, catalogInfo as Ptr) as Short
		    
		    Const kFSCatInfoContentMod = &h00000040
		    Const kFSCatInfoAttrMod = &h00000080
		    Const kFSCatInfoSettableInfo = &h00001FE3
		    
		    //get catalog info for each file for later use
		    dim catalogInfoFlags as Integer = Bitwise.BitAnd(kFSCatInfoSettableInfo, Bitwise.OnesComplement(Bitwise.BitOr(kFSCatInfoAttrMod, kFSCatInfoContentMod)))
		    dim fCatalogInfo as new FSCatalogInfo
		    dim gCatalogInfo as new FSCatalogInfo
		    dim OSError as Integer
		    OSError = FSGetCatalogInfo(f.MacFSRef, catalogInfoFlags, fCatalogInfo, Nil, Nil, Nil)
		    OSError = FSGetCatalogInfo(g.MacFSRef, catalogInfoFlags, gCatalogInfo, Nil, Nil, Nil)
		  #endif
		  
		  dim temp as FolderItem = GetTemporaryFolderItem
		  f.MoveFileTo temp
		  If f.LastErrorCode <> 0 or f.Exists or NOT temp.Exists then
		    return false
		  End if
		  g.MoveFileTo f
		  If g.LastErrorCode <> 0 or g.Exists or NOT f.Exists then
		    return false
		  End if
		  temp.MoveFileTo g
		  If temp.LastErrorCode <> 0 or temp.Exists or NOT g.Exists then
		    return false
		  End if
		  
		  #if TargetMacOS
		    //reset catalog information; note that f and g now point to the swapped files
		    OSError = FSSetCatalogInfo(f.MacFSRef, catalogInfoFlags , fCatalogInfo)
		    OSError = FSSetCatalogInfo(g.MacFSRef, catalogInfoFlags , gCatalogInfo)
		  #endif
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VolumeSupportsFSExchangeObjects(f as FolderItem) As Boolean
		  If f Is Nil then
		    Raise new InvalidParameterException("FileManager", "VolumeSupportsFSExchangeObjects", "f Is Nil")
		  End if
		  
		  Soft Declare Function PBHGetVolParmsSync Lib InterfaceLib (paramBlock as Ptr) as Short
		  
		  dim paramBlock as new HIOParam
		  paramBlock.Short(22) = f.MacVRefNum
		  dim infoBuffer as new GetVolParmsInfoBuffer
		  paramBlock.Ptr(32) = infoBuffer
		  paramBlock.Long(36) = infoBuffer.Size
		  dim OSError as Integer = PBHGetVolParmsSync(paramBlock)
		  If OSError <> 0 then
		    Return False //?
		  End if
		  Const bSupportsFSExchangeObjects = 8
		  Return Bitwise.BitAnd(infoBuffer.Long(20), bSupportsFSExchangeObjects) <> 0
		  
		End Function
	#tag EndMethod


	#tag Constant, Name = CoreServices, Type = String, Dynamic = False, Default = \"Carbon", Scope = Private
	#tag EndConstant

	#tag Constant, Name = InterfaceLib, Type = String, Dynamic = False, Default = \"Carbon", Scope = Private
	#tag EndConstant


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

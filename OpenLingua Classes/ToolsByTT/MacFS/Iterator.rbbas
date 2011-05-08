#tag Class
Protected Class Iterator
	#tag Method, Flags = &h21
		Private Function allowNULL(mb as MemoryBlock) As Ptr
		  if mb <> nil then
		    return mb
		  end
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CatalogSearch(maxItems as Integer, searchParm as SearchParams, wants as Integer, whichInfo as Integer, ByRef changed as Boolean, ByRef finished as Boolean) As CatalogBulkInfo
		  #if TargetMacOS
		    
		    if searchParm = nil then
		      searchParm = new SearchParams // no criteria - find all
		    end
		    
		    declare Function PBCatalogSearchAsync Lib CarbonFramework (paramBlock as Ptr) as Integer
		    declare Function PBCatalogSearchSync Lib CarbonFramework (paramBlock as Ptr) as Integer
		    
		    dim bi as new CatalogBulkInfo(maxItems, wants)
		    
		    dim pb as MemoryBlock
		    pb = new MemoryBlock(64)
		    pb.Long(24) = mHandle
		    pb.Long(32) = maxItems
		    pb.Long(40) = whichInfo
		    pb.Ptr(60) = searchParm
		    pb.Ptr(44) = allowNULL(bi.mInfos)
		    pb.Ptr(48) = allowNULL(bi.mRefs)
		    pb.Ptr(56) = allowNULL(bi.mNames)
		    pb.Ptr(52) = allowNULL(bi.mSpecs)
		    
		    // +++ could try using Async here to make UI feel more fluid
		    mLastError = PBCatalogSearchSync(pb)
		    
		    changed = pb.Byte(18) <> 0
		    finished = mLastError <> 0
		    
		    if mLastError = 0 or mLastError = errFSNoMoreItems then
		      bi.SetCount pb.Long(36)
		      return bi
		    end
		    
		    if mLastError <> errFSOperationNotSupported then
		      System.DebugLog "CatalogSearch error: "+Str(mLastError)
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(dir as Ref, flags as Integer)
		  #if TargetMacOS
		    
		    declare Function FSOpenIterator Lib CarbonFramework (container as Ptr, flags as Integer, ByRef iterOut as UInt32) as Integer
		    
		    dim res as Integer = FSOpenIterator (dir, flags, mHandle)
		    if res <> 0 then
		      mHandle = 0
		      #pragma BreakOnExceptions off
		      raise new NilObjectException
		    end
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Destructor()
		  #if TargetMacOS
		    
		    declare Function FSCloseIterator Lib CarbonFramework (iter as UInt32) as Integer
		    
		    if mHandle <> 0 then
		      call FSCloseIterator (mHandle)
		      mHandle = 0
		    end
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCatalogInfo(maxItems as Integer, wants as Integer, whichInfo as Integer, ByRef changed as Boolean, ByRef finished as Boolean) As CatalogBulkInfo
		  #if TargetMacOS
		    
		    dim found as Integer
		    dim bi as new CatalogBulkInfo(maxItems, wants)
		    
		    declare Function FSGetCatalogInfoBulk Lib CarbonFramework ( _
		    iter as Integer, maxCnt as Integer, ByRef actCnt as Integer, ByRef changed as Boolean, _
		    whichInfo as Integer, catInfos as Ptr, refs as Ptr, specs as Ptr, names as Ptr) as Integer
		    
		    mLastError = FSGetCatalogInfoBulk (mHandle, maxItems, found, changed, whichInfo, _
		    allowNULL(bi.mInfos), allowNULL(bi.mRefs), allowNULL(bi.mSpecs), allowNULL(bi.mNames))
		    
		    finished = mLastError <> 0
		    
		    if mLastError = 0 or (mLastError = errFSNoMoreItems) then
		      bi.SetCount found
		      return bi
		    else
		      'break // what's this? maybe a permissions error
		    end
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastErrorCode() As Integer
		  return mLastError
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mHandle As UInt32
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastError As Integer
	#tag EndProperty


	#tag Constant, Name = afpAccessDeniedError, Type = Double, Dynamic = False, Default = \"-5000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = catChangedErr, Type = Double, Dynamic = False, Default = \"-1304", Scope = Public
	#tag EndConstant

	#tag Constant, Name = errFSNoMoreItems, Type = Double, Dynamic = False, Default = \"-1417", Scope = Public
	#tag EndConstant

	#tag Constant, Name = errFSOperationNotSupported, Type = Double, Dynamic = False, Default = \"-1426", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSCatInfoNodeFlags, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSCatInfoNodeID, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSIterateDelete, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSIterateFlat, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFSIterateSubtree, Type = Double, Dynamic = False, Default = \"1", Scope = Public
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
End Class
#tag EndClass

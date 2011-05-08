#tag Class
Protected Class CatalogBulkInfo
	#tag Method, Flags = &h0
		Function Capacity() As Integer
		  return mItems
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CatInfo(idx1 as Integer) As FSCatalogInfo
		  dim ci as FSCatalogInfo
		  ci.StringValue(mInfos.LittleEndian) = mInfos.StringValue((idx1-1)*FSCatalogInfo.Size, FSCatalogInfo.Size)
		  return ci
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(items as Integer, wants as Integer)
		  if (wants and kWantsInfos) <> 0 then mInfos = new MemoryBlock(144*items)
		  if (wants and kWantsRefs) <> 0 then mRefs = new MemoryBlock(80*items)
		  if (wants and kWantsNames) <> 0 then mNames = new MemoryBlock(512*items)
		  if (wants and kWantsSpecs) <> 0 then mSpecs = new MemoryBlock(70*items)
		  mItems = items
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  return mCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InodeID(idx1 as Integer) As UInt32
		  return mInfos.UInt32Value((idx1-1)*144+68)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDirectory(idx1 as Integer) As Boolean
		  return Bitwise.BitAnd( mInfos.UInt16Value((idx1-1)*144), 16 ) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsHardLink(idx1 as Integer) As Boolean
		  return Bitwise.BitAnd( mInfos.UInt16Value((idx1-1)*144), 256 ) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsLocked(idx1 as Integer) As Boolean
		  return Bitwise.BitAnd( mInfos.UInt16Value((idx1-1)*144), 1 ) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name(idx1 as Integer) As String
		  dim n as Integer = mNames.UInt16Value((idx1-1)*512)
		  return mNames.StringValue((idx1-1)*512+2,n*2).DefineEncoding(hfsEncoding)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NodeID(idx1 as Integer) As UInt32
		  return mInfos.UInt32Value((idx1-1)*144+8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Ref(idx1 as Integer) As Ref
		  dim r as new Ref
		  r.StringValue(0, 80) = mRefs.StringValue((idx1-1)*80,80)
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCount(n as Integer)
		  mCount = n
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Spec(idx1 as Integer) As MemoryBlock
		  return mSpecs.StringValue((idx1-1)*70,70)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		mInfos As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mItems As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		mNames As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		mRefs As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		mSpecs As MemoryBlock
	#tag EndProperty


	#tag Constant, Name = kWantsInfos, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kWantsNames, Type = Double, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kWantsRefs, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kWantsSpecs, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="2147483648"
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

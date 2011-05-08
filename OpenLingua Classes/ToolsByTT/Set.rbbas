#tag Class
Protected Class Set
	#tag Method, Flags = &h0
		Sub Add(key as Variant)
		  mDict.Value(key) = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Clear()
		  mDict.Clear
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mDict = new Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Contains(key as Variant) As Boolean
		  return mDict.HasKey(key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  return mDict.Count
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mDict As Dictionary
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

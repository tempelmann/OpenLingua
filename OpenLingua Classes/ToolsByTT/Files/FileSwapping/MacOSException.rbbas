#tag Class
Protected Class MacOSException
Inherits RuntimeException
	#tag Method, Flags = &h0
		Sub Constructor(theFunction as String, theError as Integer)
		  me.pFunctionName = theFunction
		  me.pOSError = theError
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ErrorCode() As Integer
		  Return me.pOSError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FunctionName() As String
		  Return me.pFunctionName
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private pFunctionName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pOSError As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorNumber"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="RuntimeException"
		#tag EndViewProperty
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
			Name="Message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="RuntimeException"
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

#tag Module
Protected Module DateExtensions
	#tag Method, Flags = &h0
		Function UTCDateTime(extends d as Date) As String
		  // Returns a UTC value, i.e. a time independent of the current time zone
		  
		  dim d2 as new Date(d)
		  d2.Hour = d.Hour - d.GMTOffset
		  return d2.SQLDateTime.Replace(" ","T")+"Z"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UTCDateTime(extends d as Date, assigns value as String)
		  // Assigns a UTC value, i.e. a time independent of the current time zone
		  
		  if value.Right(1) = "Z" then
		    d.SQLDateTime = value.Replace("T", " ").Left(value.Len-1)
		    d.Hour = d.Hour + d.GMTOffset
		  else
		    raise new UnsupportedFormatException
		  end
		End Sub
	#tag EndMethod


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

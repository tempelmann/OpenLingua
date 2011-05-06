#tag Class
Protected Class AliasFile
	#tag Method, Flags = &h0
		Function Alias() As AliasRecord
		  return mAliasRecord
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  mRsrcFork.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(f as FolderItem)
		  mAliasFile = f
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Destructor()
		  me.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Open() As Boolean
		  mRsrcFork = mAliasFile.OpenResourceFork
		  if mRsrcFork = nil then return false
		  
		  dim alisRsrc as String
		  mAlisID = 0
		  alisRsrc = mRsrcFork.GetResource("alis", mAlisID)
		  if alisRsrc = "" then
		    mRsrcFork = nil
		    return false
		  end if
		  
		  mAliasRecord = new AliasRecord (alisRsrc)
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RawData() As String
		  return mAliasRecord.Data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(alisRsrc as String)
		  // get the name of the resource
		  dim s as string = ""
		  for i as integer = 0 to mRsrcFork.ResourceCount("alis")
		    if mRsrcFork.ResourceID("alis", i) = mAlisID then
		      s = mRsrcFork.ResourceName("alis", i)
		      exit
		    end
		  next
		  
		  // update it
		  if false then
		    mRsrcFork.AddResource alisRsrc, "alis", mAlisID, s
		  end
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAliasFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAliasRecord As MacFS.AliasRecord
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAlisID As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRsrcFork As ResourceFork
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

#tag Class
Protected Class TransListBoxNode
	#tag Method, Flags = &h0
		Sub Assign(grp as LinguaRecordSet)
		  mItems(grp.Platform) = grp
		  if mIdentifier = "" then
		    mIdentifier = grp.Identifier
		  elseif mIdentifier <> grp.Identifier then
		    raise new LinguaAssertionException // this must not happen
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AssignedEntries() As LinguaRecordSet()
		  dim grps() as LinguaRecordSet
		  for i as Integer = 0 to mItems.Ubound
		    if mItems(i) <> nil then
		      grps.Append mItems(i)
		    end
		  next
		  return grps
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Default() As LinguaRecordSet
		  return ForPlatformCode(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ForPlatformCode(platform as Integer, returnNilIfMissing as Boolean = false) As LinguaRecordSet
		  if mItems(platform) <> nil then
		    return mItems(platform)
		  elseif not returnNilIfMissing then
		    dim anyEntries() as LinguaRecordSet = me.AssignedEntries()
		    return new LinguaRecordSet (anyEntries(0).Owner, mIdentifier, "", "", platform)
		  end
		End Function
	#tag EndMethod


	#tag Note, Name = About
		This class holds just references to the items of a LinguaTranslationPool.
		I.e., it does not maintain any objects on its own.
	#tag EndNote


	#tag Property, Flags = &h21
		Private mIdentifier As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			Holds an item for every platform, with the index identical the Platform code
		#tag EndNote
		Private mItems(MaxPlatform) As LinguaRecordSet
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

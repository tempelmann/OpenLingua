#tag Class
Protected Class ListBoxState
	#tag Method, Flags = &h0
		Sub ClearState()
		  mSelected.Clear
		  mExpanded.Clear
		  mScrollPos = 0
		  mWasHierarchical = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(lb as PersistentListBox)
		  mListBox = lb
		  mSelected = new Set
		  mExpanded = new Set
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RestoreState()
		  dim lb as PersistentListBox = mListBox
		  dim selCount as Integer = mSelected.Count
		  
		  for i as integer = 0 to lb.ListCount-1 // attention: ListCount may change during loop!
		    dim id as Variant
		    id = lb.RowID(i)
		    if mWasHierarchical then
		      if mExpanded.Contains(id) then
		        lb.Expanded(i) = true
		      end
		    end if
		    if mSelected.Contains(id) then
		      lb.Selected(i) = true
		      selCount = selCount - 1
		    end
		    if not mWasHierarchical and selCount <= 0 then
		      // no need to look further
		      exit
		    end
		  next
		  lb.ScrollPosition = mScrollPos
		  
		  me.ClearState
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveState(isHierarchical as Boolean)
		  dim lb as PersistentListBox = mListBox
		  dim listCountM1 as Integer = lb.ListCount-1
		  dim selCount as Integer = lb.SelCount
		  dim allIDs as new Set
		  
		  me.ClearState
		  
		  mWasHierarchical = isHierarchical
		  
		  if lb.ListCount > 0 then
		    // preserve scroll position, selected items and opened folders
		    mScrollPos = lb.ScrollPosition
		    for i as integer = 0 to listCountM1
		      dim id as Variant
		      dim isSelected as Boolean = lb.Selected(i)
		      if isSelected or isHierarchical then
		        id = lb.RowID(i)
		        if allIDs.Contains(id) then
		          break // error: IDs not unique
		        else
		          allIDs.Add id
		          if isSelected then
		            mSelected.Add id
		            selCount = selCount - 1
		          end
		          if isHierarchical and lb.Expanded(i) then
		            mExpanded.Add id
		          end if
		        end if
		        if not isHierarchical and selCount <= 0 then
		          // no need to look further
		          exit
		        end
		      end
		    next
		  end
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mExpanded As Set
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mListBox As PersistentListBox
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollPos As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelected As Set
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWasHierarchical As Boolean
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

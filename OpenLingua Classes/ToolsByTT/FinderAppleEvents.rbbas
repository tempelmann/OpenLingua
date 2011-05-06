#tag Module
Protected Module FinderAppleEvents
	#tag Method, Flags = &h1
		Protected Sub BringFinderToFront()
		  #if TargetMacOS
		    Dim ok as Boolean
		    Dim ae as AppleEvent
		    ae = NewAppleEvent ("misc", "actv", "MACS") // kAEActivate
		    if ae <> nil then
		      ae.Timeout = 0
		      ok = ae.Send
		    end
		    if not ok then
		      'MsgBox "Oops, Activate failed unexpectedly"
		    end
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DragFolderItem(d as DragItem, f as FolderItem) As Boolean
		  d.FolderItem = f
		  d.drag
		  if d.Destination <> nil and d.Destination isA FolderItem then
		    if f.Exists and FolderItem(d.Destination).IsTrashFolder then
		      // move to trash via Dock icon - we have to perform the move ourselves
		      FinderAppleEvents.MoveToTrash f
		    else
		      // move worked
		    end if
		    return true
		  else
		    // no move took place (but may a drop onto an app which then got launched to open it)
		    return false
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub MoveToTrash(f as FolderItem)
		  #if TargetMacOS
		    if ( f <> Nil ) then
		      dim ok as Boolean
		      dim ae as AppleEvent
		      ae = NewAppleEvent( "core", "move", "MACS" )
		      dim list as new AppleEventDescList
		      list.AppendFolderItem (f)
		      ae.DescListParam("----") = list
		      ae.ObjectSpecifierParam( "insh" ) = GetPropertyObjectDescriptor( Nil, "trsh" )
		      ae.SetNullParam( "alrp" ) // keyAEReplacing
		      ok = ae.send
		      if not ok then
		        break
		      end
		    end if
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RevealItemInFinder(f as FolderItem, bringToFront as Boolean = false)
		  #if TargetMacOS
		    dim ok as Boolean
		    if not f.Visible then
		      // !!! what shall we do here?
		      // After all, the Finder could be in a mode where it can view even invisible files
		      'MsgBox "Can't show this item because it is invisible"
		    end
		    ok = sendItemAE ("misc", "mvis", "MACS", f) // kAEMakeItemVisible
		    if not ok then
		      'MsgBox "Oops, Reveal failed unexpectedly"
		    elseif bringToFront then
		      BringFinderToFront
		    end
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function sendItemAE(s1 as String, s2 as String, s3 as String, f as FolderItem) As Boolean
		  #if TargetMacOS
		    Dim ae as AppleEvent
		    Dim list as AppleEventDescList
		    ae = NewAppleEvent (s1, s2, s3)
		    if ae <> nil then
		      list = New AppleEventDescList
		      list.AppendFolderItem (f)
		      ae.DescListParam("----") = list
		      ae.Timeout = 1 // must not be 0 or ae.Send will return FALSE even though the Finder received the AE
		      return ae.Send
		    end
		    return false
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub UpdateItemInFinder(f as FolderItem)
		  #if TargetMacOS
		    dim err as Integer
		    dim ok as Boolean
		    
		    ok = sendItemAE ("fndr", "fupd", "MACS", f.Parent) // kAESync
		    if ok then
		      ok = sendItemAE ("fndr", "fupd", "MACS", f) // kAESync
		    end
		    if not ok then
		      'MsgBox "Oops, Update failed unexpectedly"
		    end
		  #endif
		End Sub
	#tag EndMethod


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
End Module
#tag EndModule

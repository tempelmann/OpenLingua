#tag Window
Begin Window RawDataWindow
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   422073685
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Untitled"
   Visible         =   True
   Width           =   600
   Begin Listbox itemList
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   ""
      Border          =   True
      ColumnCount     =   2
      ColumnsResizable=   ""
      ColumnWidths    =   80,
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   ""
      EnableDragReorder=   ""
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   ""
      HeadingIndex    =   -1
      Height          =   366
      HelpTag         =   ""
      Hierarchical    =   True
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
      _ScrollWidth    =   -1
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub DropObject(obj As DragItem, action As Integer)
		  do
		    if not obj.FolderItemAvailable then
		      // oops, what's this?!
		      beep
		      break
		    else
		      dim w as RawDataWindow
		      if self.itemList.ListCount = 0 then
		        // use this window as it's still empty
		        w = self
		      else
		        // use new window
		        w = new RawDataWindow
		      end
		      w.LoadAndShow obj.FolderItem
		    end
		  loop until not obj.NextItem
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  doOpen
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function FileClose() As Boolean Handles FileClose.Action
			self.Close
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h21
		Private Sub doOpen()
		  // allow Drop of .rbl files
		  
		  AcceptFileDrop DropFileTypes.LinguaFile
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub itemListAdd(group as LinguaRecordSet)
		  dim items() as LinguaFileRecord
		  items = group.AllItems
		  for each rec as LinguaFileRecord in items
		    if rec.Value.Type = Variant.TypeObject and rec.Value.ObjectValue isA LinguaRecordSet then
		      itemList.AddFolder rec.Key
		      dim grp as LinguaRecordSet = rec.Value
		      itemList.Cell (itemList.LastIndex, 1) = grp.Identifier
		    else
		      itemList.AddRow rec.Key
		      dim value as String = rec.Value
		      if rec.Key = "oval" or rec.Key = "tval" then
		        #if allowEditing
		          itemList.CellType(itemList.LastIndex, 1) = ListBox.TypeEditable
		        #endif
		      elseif rec.Key = "appl" then
		        // value is a "SaveInfo"
		        dim f as FolderItem = mFileRef.GetRelative(value)
		        if f <> nil then
		          value = f.AbsolutePath
		          #if TargetMacOS
		            // oddly, RB appends a ":" to the path
		            if value.Right(1) = ":" then value = value.Left(value.Len-1)
		          #endif
		        end if
		      end if
		      itemList.Cell (itemList.LastIndex, 1) = value
		    end if
		    itemList.RowTag (itemList.LastIndex) = rec
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadAndShow(f as FolderItem)
		  mFileRef = f
		  
		  itemList.DeleteAllRows
		  
		  dim ltp as new LinguaTranslationPool
		  if not ltp.LoadFromRBL (f) then
		    MsgBox ltp.LastErrorMessage
		    return
		  end
		  
		  itemListAdd ltp.RawRecords
		  
		  self.Title = f.Name
		  
		  showHistory ltp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Show(ltp as LinguaTranslationPool, title as String, origin as FolderItem)
		  mFileRef = origin
		  
		  itemList.DeleteAllRows
		  
		  itemListAdd ltp.RawRecords
		  
		  self.Title = title
		  
		  showHistory ltp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub showHistory(ltp as LinguaTranslationPool)
		  for each ltp in ltp.History
		    dim w as new RawDataWindow
		    w.Show ltp, "History of "+self.Title, mFileRef
		  next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mFileRef As FolderItem
	#tag EndProperty


	#tag Constant, Name = allowEditing, Type = Boolean, Dynamic = False, Default = \"false", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events itemList
	#tag Event
		Sub ExpandRow(row As Integer)
		  dim rec as LinguaFileRecord = itemList.RowTag (row)
		  itemListAdd rec.Value
		End Sub
	#tag EndEvent
	#tag Event
		Sub CellAction(row As Integer, column As Integer)
		  #if allowEditing
		    // this would allow editing - would need ways to save it then, though
		    dim rec as LinguaFileRecord = me.RowTag(row)
		    if StrComp (rec.Value, me.Cell(row, column), 0) <> 0 then
		      rec.Value = me.Cell(row, column)
		    end if
		  #endif
		End Sub
	#tag EndEvent
#tag EndEvents

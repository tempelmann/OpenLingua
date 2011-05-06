#tag Window
Begin Window LinguaWarningsWindow
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   False
   Composite       =   False
   Frame           =   1
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   False
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   False
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Conflicts"
   Visible         =   True
   Width           =   600
   Begin Listbox theList
      AutoDeactivate  =   True
      AutoHideScrollbars=   False
      Bold            =   ""
      Border          =   True
      ColumnCount     =   3
      ColumnsResizable=   True
      ColumnWidths    =   ""
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   ""
      EnableDragReorder=   ""
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   273
      HelpTag         =   ""
      Hierarchical    =   ""
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
      Top             =   76
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   567
      _ScrollWidth    =   -1
   End
   Begin PushButton okBut
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "OK"
      Default         =   True
      Enabled         =   False
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   507
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   361
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin PushButton cancelBut
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   True
      Caption         =   "Cancel"
      Default         =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   415
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   361
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin Label introTxt
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   50
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   True
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "The following items have mismatched ..."
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   567
   End
End
#tag EndWindow

#tag WindowCode
	#tag Property, Flags = &h0
		mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		mChosenLeft As Boolean
	#tag EndProperty


#tag EndWindowCode

#tag Events theList
	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  if me.ColumnType(column) = ListBox.TypeCheckbox then
		    // check entire column
		    dim other as Integer = (me.ColumnCount-2)*2+1-column
		    for i as integer = 0 to me.ListCount-1
		      me.CellCheck(i, other) = false
		      me.CellCheck(i, column) = true
		    next
		    mChosenLeft = (column = (me.ColumnCount-2))
		    okBut.Enabled = true
		  else
		    // show the texts in detail
		    dim w as new LinguaDetailedConflictWindow
		    w.TextArea1(0).Text = me.Cell(row, me.ColumnCount-2)
		    w.TextArea1(1).Text = me.Cell(row, me.ColumnCount-1)
		    w.ShowModal
		  end
		  return true
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events okBut
	#tag Event
		Sub Action()
		  self.Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events cancelBut
	#tag Event
		Sub Action()
		  mCancelled = true
		  self.Hide
		End Sub
	#tag EndEvent
#tag EndEvents

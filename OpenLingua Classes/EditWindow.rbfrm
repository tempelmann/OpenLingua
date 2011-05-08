#tag Window
Begin Window EditWindow Implements Undoable
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   True
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   3.18e+2
   ImplicitInstance=   False
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   422073685
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "editor"
   Visible         =   True
   Width           =   5.19e+2
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Filter:"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   46
   End
   Begin FilterTextField filterEdit
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   72
      LimitText       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   13
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   172
      Begin ClearPushButton filterClearBut
         AcceptFocus     =   False
         AcceptTabs      =   ""
         AutoDeactivate  =   True
         Backdrop        =   ""
         DoubleBuffer    =   False
         Enabled         =   False
         EraseBackground =   False
         Height          =   18
         HelpTag         =   "Clears the Filter"
         Index           =   -2147483648
         InitialParent   =   "filterEdit"
         Left            =   224
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   False
         Top             =   15
         UseFocusRing    =   False
         Visible         =   True
         Width           =   18
      End
   End
   Begin MarsSplitter splitter1
      AcceptFocus     =   ""
      AcceptTabs      =   ""
      AutoDeactivate  =   True
      Backdrop        =   ""
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   True
      Height          =   285
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   244
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   True
      MinBottomRight  =   100
      MinTopLeft      =   100
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   13
      UseFocusRing    =   False
      Visible         =   True
      Width           =   16
   End
   Begin PopupMenu versionPop
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   False
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Latest Version"
      Italic          =   ""
      Left            =   20
      ListIndex       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   46
      Underline       =   ""
      Visible         =   True
      Width           =   224
   End
   Begin TransListBox itemList
      AutoDeactivate  =   True
      AutoHideScrollbars=   False
      Bold            =   ""
      Border          =   True
      ColumnCount     =   1
      ColumnsResizable=   ""
      ColumnWidths    =   ""
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
      Height          =   174
      HelpTag         =   ""
      HideEmptyPlatformValues=   ""
      Hierarchical    =   True
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      RequiresSelection=   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollBarVertical=   True
      SelectionType   =   0
      ShowOnlyUntranslated=   ""
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   72
      TripleStateSorting=   0
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   224
      _ScrollWidth    =   -1
   End
   Begin Label Label2
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   260
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Name:"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   50
   End
   Begin Label itemNameLbl
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   310
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "..."
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   189
   End
   Begin Label origLbl
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   260
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Original:"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   46
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   239
   End
   Begin TextArea origEdit
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   False
      Format          =   ""
      Height          =   87
      HelpTag         =   ""
      HideSelection   =   False
      Index           =   0
      Italic          =   ""
      Left            =   260
      LimitText       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   0
      ScrollbarHorizontal=   True
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   72
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   239
      Begin TextArea origEdit
         AcceptTabs      =   ""
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   16777215
         Bold            =   ""
         Border          =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   False
         Format          =   ""
         Height          =   87
         HelpTag         =   ""
         HideSelection   =   False
         Index           =   1
         InitialParent   =   "origEdit$0"
         Italic          =   ""
         Left            =   260
         LimitText       =   0
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   True
         Scope           =   0
         ScrollbarHorizontal=   False
         ScrollbarVertical=   True
         Styled          =   True
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   72
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   239
      End
   End
   Begin MarsSplitter splitter2
      AcceptFocus     =   ""
      AcceptTabs      =   ""
      AutoDeactivate  =   True
      Backdrop        =   ""
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   True
      Height          =   16
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   260
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      MinBottomRight  =   70
      MinTopLeft      =   100
      Scope           =   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   159
      UseFocusRing    =   False
      Visible         =   True
      Width           =   239
   End
   Begin TextArea transEdit
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   False
      Format          =   ""
      Height          =   98
      HelpTag         =   ""
      HideSelection   =   False
      Index           =   0
      InitialParent   =   ""
      Italic          =   ""
      Left            =   260
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   0
      ScrollbarHorizontal=   True
      ScrollbarVertical=   True
      Styled          =   False
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   200
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   239
      Begin TextArea transEdit
         AcceptTabs      =   ""
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   True
         BackColor       =   16777215
         Bold            =   ""
         Border          =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   False
         Format          =   ""
         Height          =   98
         HelpTag         =   ""
         HideSelection   =   False
         Index           =   1
         InitialParent   =   "transEdit$0"
         Italic          =   ""
         Left            =   260
         LimitText       =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   True
         Scope           =   0
         ScrollbarHorizontal=   False
         ScrollbarVertical=   True
         Styled          =   False
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   200
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   239
      End
   End
   Begin Label transLbl
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   260
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   """^0"" translation:"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   176
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   239
   End
   Begin PushButton movePrevBut
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Previous"
      Default         =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   False
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   278
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin PushButton moveNextBut
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Next"
      Default         =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   112
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   False
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   278
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin Label listInfo
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlign       =   0
      TextColor       =   &h000000
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   246
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   224
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Activate()
		  // Check if file on disk got updated by another program
		  
		  if RBLPool <> nil and not RBLPool.IsRBLCurrent then
		    dim isDirty as Boolean = RBLPool.IsDirty
		    RBLPool.MakeRBLCurrent // Need to reset it before showing the dialog because otherwise we'll get into a recursion here
		    dim choice as Integer
		    if isDirty then
		      // If user made modifications to both the file on disk and to the translation here, he'll have to decide
		      // which version to keep in the long run. We could offer a "Keep" and "Revert" buttons here, but I think
		      // it's less confusing if the user has to go thru the familiar Close & Don't Save routine to discard his changes.
		      choice = TTsUITools.ShowMessageDialog (self, "stop", "*", "", "", "File on disk is out of sync", _
		      "The .rbl file for the translations in this window got modified by another program."+EndOfLine+EndOfLine+ _
		      "You must decide whether to keep your current work and save that eventually, or discard it by closing this window.")
		    else
		      // User made no modifications since his last open or save, so we offer simply to update
		      // this data with the file on disk.
		      choice = TTsUITools.ShowMessageDialog (self, "stop", "Load Update", "*", "", "File on disk got updated", _
		      "The .rbl file for the translations in this window got modified by another program."+EndOfLine+EndOfLine+ _
		      "You can now load the new version (Load Update) or keep working with this outdated version (Cancel).")
		      if choice = 1 then
		        // Update from disk
		        loadRBL nil
		      else
		        // Mark this dirty so that a Save is possible, overwriting the one on disk
		        RBLPool.IsDirty = true
		        updateStatus // called because dirty state might have changed. Ideally, though, LinguaTranslationPool would send a notification out that would make this window notice the dirtyness
		      end
		    end
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Function CancelClose(appQuitting as Boolean) As Boolean
		  ClearFocus
		  
		  if RBLPool.IsDirty then
		    dim choice as Integer
		    choice = TTsUITools.ShowMessageDialog (self, "ask", "Save", "*", "&Don't Save", "Save Changes?", "If you don't save, your changes will be lost")
		    if choice = 1 then
		      // Save
		      if not save() then
		        return true
		      end
		    elseif choice = 2 then
		      // Cancel
		      return true
		    else
		      // Don't Save
		    end
		  end if
		End Function
	#tag EndEvent

	#tag Event
		Sub Close()
		  saveStateToPrefs
		End Sub
	#tag EndEvent

	#tag Event
		Sub EnableMenuItems()
		  if RBLPool <> nil and RBLPool.IsDirty then
		    FileSave.Enable
		  end
		  
		  ExportTabDelimited.Enable
		  ImportLocalizablestringsfile.Enable
		  
		  if mUndoer <> nil then
		    EditUndo.Enabled = mUndoer.CanUndo
		    EditRedo.Enabled = mUndoer.CanRedo
		  end if
		  
		  EditMoveToNext.Enable
		  EditMoveToPrevious.Enable
		  
		  ViewNames.Checked = itemList.DisplayChoice = TransListBox.DisplayChoices.Identifier
		  ViewOriginals.Checked = itemList.DisplayChoice = TransListBox.DisplayChoices.Original
		  ViewTranslations.Checked = itemList.DisplayChoice = TransListBox.DisplayChoices.Translation
		  ViewSmart.Checked = itemList.DisplayChoice = TransListBox.DisplayChoices.TranslationOrOriginal
		  
		  ViewWrapLines.Enable
		  ViewWrapLines.Checked = mLineWrapEnabled
		  
		  ViewHideEmpties.Enable
		  ViewHideEmpties.Checked = itemList.HideEmptyPlatformValues
		  
		  ViewOnlyUntranslated.Enable
		  ViewOnlyUntranslated.Checked = itemList.ShowOnlyUntranslated
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  mUndoer = new UndoEngine
		  resizeWindow true
		  selectRecord nil, true
		  
		  updateLineWrap()
		  
		  itemList.HideEmptyPlatformValues = true
		  itemList.InfoLbl = listInfo
		  itemList.SetFocus
		  
		  // re-position window
		  if not Keyboard.AsyncOptionKey and not Keyboard.AsyncOptionKey and not Keyboard.AsyncCommandKey then
		    // The modifier checks make it possible to get the window back on screen should it be off-screen after
		    // switching screen resolution.
		    dim p as SmartPreferences = App.Prefs
		    self.Left = p.Value("EditWindow.Left", self.Left)
		    self.Top = p.Value("EditWindow.Top", self.Top)
		    self.Width = p.Value("EditWindow.Width", self.Width)
		    self.Height = p.Value("EditWindow.Height", self.Height)
		  end
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  resizeWindow true
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  resizeWindow false
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function EditGoToFilter() As Boolean Handles EditGoToFilter.Action
			filterEdit.SetFocus
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditMoveToNext() As Boolean Handles EditMoveToNext.Action
			listMove true
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditMoveToPrevious() As Boolean Handles EditMoveToPrevious.Action
			listMove false
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditRedo() As Boolean Handles EditRedo.Action
			if mUndoer.CanRedo then
			mUndoer.Redo
			Return True
			end if
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditUndo() As Boolean Handles EditUndo.Action
			if mUndoer.CanUndo then
			mUndoer.Undo
			Return True
			end if
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ExportTabDelimited() As Boolean Handles ExportTabDelimited.Action
			do
			dim f as FolderItem = GetSaveFolderItem (DropFileTypes.TextFile, RBLPool.FileRef.Name+DropFileTypes.TextFile.Extensions)
			if f = nil then exit
			dim lines() as String = RBLPool.ExportTabDelimited()
			const withBackup = false
			if f.Save (Join (lines, EndOfLine), withBackup) then exit
			MsgBox "Export failed: File could not be written."+EndOfLine+EndOfLine+"Try again."
			loop
			
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileClose() As Boolean Handles FileClose.Action
			self.Close
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileRevealonDisk() As Boolean Handles FileRevealonDisk.Action
			DocumentFileRef.Reveal
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSave() As Boolean Handles FileSave.Action
			call self.save()
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ImportLocalizablestringsfile() As Boolean Handles ImportLocalizablestringsfile.Action
			dim f as FolderItem
			f = GetOpenFolderItem (DropFileTypes.LocalizableStrings)
			if f <> nil then
			EditWindow.Open f
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewHideEmpties() As Boolean Handles ViewHideEmpties.Action
			itemList.HideEmptyPlatformValues = not itemList.HideEmptyPlatformValues
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewNames() As Boolean Handles ViewNames.Action
			itemList.DisplayChoice = TransListBox.DisplayChoices.Identifier
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewOnlyUntranslated() As Boolean Handles ViewOnlyUntranslated.Action
			itemList.ShowOnlyUntranslated = not itemList.ShowOnlyUntranslated
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewOriginals() As Boolean Handles ViewOriginals.Action
			itemList.DisplayChoice = TransListBox.DisplayChoices.Original
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewSmart() As Boolean Handles ViewSmart.Action
			itemList.DisplayChoice = TransListBox.DisplayChoices.TranslationOrOriginal
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewTranslations() As Boolean Handles ViewTranslations.Action
			itemList.DisplayChoice = TransListBox.DisplayChoices.Translation
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewWrapLines() As Boolean Handles ViewWrapLines.Action
			mLineWrapEnabled = not mLineWrapEnabled
			updateLineWrap
			Return True
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h21
		Private Sub applyChanges(fromTextChange as Boolean = false)
		  // Call this to accept the changes to the translation field
		  
		  if mCurrentRecord = nil then
		    // should not happen
		    break
		    beep
		    return
		  end
		  
		  dim newTrans as String = transEdit(editIdx).Text
		  if StrComp (newTrans, mCurrentRecord.Translation, 0) <> 0 then
		    // Text got changed -> update it
		    if mTransEditFresh or not fromTextChange then
		      mTransEditFresh = false
		      mUndoer.Backup "Translation Update", self, mCurrentRecord
		    end
		    mCurrentRecord.SetTranslation (newTrans)
		    if not fromTextChange then
		      mCheckSpacesPending = false
		      checkSpacing mCurrentRecord
		    else
		      mCheckSpacesPending = true
		    end
		  end if
		  
		  updateStatus // called because dirty state might have changed. Ideally, though, LinguaTranslationPool would send a notification out that would make this window notice the dirtyness
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Backup(ByRef hint as Variant, forRestore as Boolean) As Variant
		  // Part of the Undoable interface.
		  
		  dim grp as LinguaRecordSet = hint
		  if grp <> nil then
		    return grp : grp.State
		  else
		    // backup all translations
		    return RBLPool.RecordsBackup : RBLPool.IsDirty
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub checkSpacing(grp as LinguaRecordSet)
		  dim oval as String = grp.Original
		  dim tval as String = grp.Translation
		  if tval <> "" then
		    dim oprefix, osuffix, tprefix, tsuffix as String
		    extractBoundingWhiteSpace oval, oprefix, osuffix
		    extractBoundingWhiteSpace tval, tprefix, tsuffix
		    if oprefix <> tprefix or osuffix <> tsuffix then
		      dim s as String
		      s = "The translation has mismatched whitespace at its "
		      if oprefix <> tprefix then
		        if osuffix <> tsuffix then
		          s = s + "start and end."
		        else
		          s = s + "start."
		        end
		      else
		        s = s + "end."
		      end if
		      dim choice as Integer = TTsUITools.ShowMessageDialog (self, "ask", "Fix", "Keep", "", s, "White space at the start and end of the translation should always match that of the original.")
		      if choice = 1 then
		        // Fix
		        tval = oprefix + tval + osuffix
		        mUndoer.Backup "Translation Whitespace Fix", self, grp
		        grp.SetTranslation tval
		        transEdit(editIdx).Text = tval
		        updateStatus // called because dirty state might have changed. Ideally, though, LinguaTranslationPool would send a notification out that would make this window notice the dirtyness
		      end if
		    end
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DocumentFileRef() As FolderItem
		  return RBLPool.FileRef
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function editIdx() As Integer
		  if mLineWrapEnabled then return 1
		  return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub extractBoundingWhiteSpace(ByRef s as String, ByRef prefix as String, ByRef suffix as String)
		  dim s2 as String = s.Trim
		  dim p as Integer = s.InStr(s2)
		  prefix = s.Left(p-1)
		  suffix = s.Mid(p+s2.Len)
		  s = s2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ImportStringsFile(f as FolderItem) As Boolean
		  dim txt as String
		  try
		    txt = TextInputStream.Open(f).ReadAll
		  catch exc1 as IOException
		    MsgBox "Reading of .strings file failed: "+exc1.Message
		    return false
		  end try
		  
		  // To scan a "Localizable.strings" file correctly, we need to observe a few things:
		  // - Each item consists of a quoted key string, "=", a quoted value string and a semi-colon (";"),
		  //    with optional white space around it.
		  // - It may contain comments, enclosed in "/* ... */", in places where white space is allowed.
		  // - Strings may also contain line delimiters, which are valid part of the string then.
		  // - For encodings, UTF-8 and UTF-16 (BE, LE) may be used (maybe even UTF-32, not sure).
		  
		  // Determine the encoding
		  if txt.LeftB(3) = ChrB(&hEF)+ChrB(&hBB)+ChrB(&hBF) then
		    txt = txt.MidB(4).DefineEncoding (Encodings.UTF8)
		  elseif txt.LeftB(2) = ChrB(&hFE)+ChrB(&hFF) then
		    txt = txt.MidB(3).DefineEncoding (Encodings.UTF16BE)
		  elseif txt.LeftB(2) = ChrB(&hFF)+ChrB(&hFE) then
		    txt = txt.MidB(3).DefineEncoding (Encodings.UTF16LE)
		  elseif txt.LTrim.LeftB(1) = "/" or txt.LTrim.LeftB(1) = """" then
		    // plain text without BOM, it appears
		    txt = txt.DefineEncoding (Encodings.UTF8)
		  else
		    break
		    MsgBox "File is not a valid text file or has unsupported encoding"
		    return false
		  end if
		  
		  #if DebugBuild
		    // need to convert to UTF-8, at least for debugging, or the darn debugger will crash on me (OSX, RB 2011r1)
		    txt = txt.ConvertEncoding (Encodings.UTF8)
		  #endif
		  
		  // Now parse the text.
		  // This might be faster by using RegEx, but I'm not so good with Regex to get this right easily.
		  //
		  dim items as new Dictionary // holds the collected key-value pairs
		  dim key as String //  holds the key while waiting for the value
		  dim state as Integer // 0: awaiting key, 1: awaiting "=", 2: awaiting value, 3: awaiting ";"
		  dim pos as Integer = 1
		  while pos < txt.Len
		    dim ch as String = txt.Mid(pos,1)
		    pos = pos + 1
		    if ch.Trim = "" then
		      // ignore white space
		    elseif ch = "/" and txt.Mid(pos,1) = "*" then
		      // Start of comment -> skip to the end of it
		      // I make the assumption that the next "*/" ends the comment.
		      // Not sure if that's alwayss correct, though (what if it's in quotes?)
		      pos = txt.InStr(pos+1, "*/") + 2
		    elseif ch = """" and (state = 0 or state = 2) then
		      // Start of a string -> find end of it
		      dim s as String
		      while pos < txt.Len
		        ch = txt.Mid(pos,1)
		        pos = pos + 1
		        if ch = "\" then
		          // escaped char
		          ch = txt.Mid(pos,1)
		          pos = pos + 1
		          if ch = "r" then
		            ch = Chr(13)
		          elseif ch = "n" then
		            ch = Chr(10)
		          elseif ch = "t" then
		            ch = Chr(9)
		          end
		          s = s + ch
		        elseif ch = """" then
		          // end of string
		          exit
		        else
		          s = s + ch
		        end if
		      wend
		      if state = 0 then
		        if items.HasKey(key) then
		          break
		          beep
		          MsgBox "Duplicate Key used (keys must be case-insentive) for use with REALbasic"
		          return false
		        end
		        key = s
		        state = 1
		      else
		        items.Value(key) = s
		        key = ""
		        state = 3
		      end if
		    elseif ch = "=" and state = 1 then
		      state = 2
		    elseif ch = ";" and state = 3 then
		      state = 0
		    else
		      break
		      beep
		      MsgBox "Syntax error at pos "+Str(pos)+": "+txt.Mid(pos-1,10)
		      return false
		    end
		  wend
		  
		  // Finally, assign the keys and values to the currently loaded
		  mUndoer.Backup "Import of Localizable.strings", self, nil
		  RBLPool.ImportKeyValuePairs (items, PlatformOSX)
		  itemList.Rebuild
		  updateStatus
		  verifySpaces RBLPool, false
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub listMove(forward as Boolean)
		  itemList.MoveSelection forward
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub loadRBL(f as FolderItem)
		  // f = nil means reload (revert)
		  
		  dim ltp as LinguaTranslationPool
		  dim ok as Boolean
		  
		  if f = nil then
		    // Reload
		    ltp = RBLPool
		    f = ltp.FileRef
		    dim oldLang as String = ltp.Language
		    ok = ltp.ReloadFromRBL ()
		    if ok and oldLang <> ltp.Language then
		      MsgBox "Oops - The newly loaded .rbl file is for a different language than what it was before. You should close this window and start over."
		    end
		  else
		    // Fresh Load
		    if RBLPool <> nil then
		      // a new load should only happen with a fresh window, or we'd have to reset quite a few states for the window
		      raise new LinguaAssertionException
		    end if
		    itemList.Clear
		    ltp = new LinguaTranslationPool
		    ok = ltp.LoadFromRBL (f)
		  end
		  
		  if not ok then
		    MsgBox "Error during loading of "+f.AbsolutePath+": "+ltp.LastErrorMessage
		  else
		    #if TargetMacOS
		      // Set Proxy Icon
		      self.DocumentFile = f
		    #endif
		    itemList.SetTranslationGroup ltp
		    self.Title = f.Name
		    transLbl.Text = transLbl.Text.Replace("^0", ltp.Language)
		    verifySpaces ltp, false
		  end
		  
		  mUndoer.Reset
		  
		  updateStatus
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Open(f as FolderItem)
		  dim ftype as String = f.Type
		  
		  if ftype = DropFileTypes.LocalizableStrings.Name then
		    // show be opened in frontmost edit window
		    for i as Integer = 0 to WindowCount-1
		      if Window(i) isA EditWindow then
		        dim ew as EditWindow = EditWindow(Window(i))
		        call ew.ImportStringsFile (f)
		        return
		      end if
		    next
		    beep
		    MsgBox "There is no Lingua file opened into which this file can be imported"
		  elseif ftype = DropFileTypes.LinguaFile.Name then
		    for i as Integer = 0 to WindowCount-1
		      if Window(i) isA EditWindow then
		        dim ew as EditWindow = EditWindow(Window(i))
		        if ew.RBLPool.FileRef.SameAs (f) then
		          // this file is already open
		          ew.Show
		          return
		        end
		      end if
		    next
		    // File not open yet - open a new window for it
		    dim w as new EditWindow
		    w.loadRBL f
		  else
		    beep
		    MsgBox "Don't know what to do with this file type"
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RBLPool() As LinguaTranslationPool
		  return itemList.TransPool
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub resizeWindow(finished as Boolean)
		  // Moves splitters, keeping their dividing ratio
		  
		  splitter1.ResizingWindow self, finished
		  splitter2.ResizingWindow self, finished
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ResolveWarnings(storableItems() as LinguaRecordSet, defaultsMismatches as Dictionary, localizationConflicts as Dictionary) As Boolean
		  // Gets called between first and second pass of LinguaTranslationPool.StoreInDB
		  // Is allowed to modify storableItems in order to remove items that shall not be stored in the DB
		  
		  if defaultsMismatches.Count > 0 then
		    dim intro as String = _
		    "The following items have mismatched Default Texts."+EndOfLine+_
		    "This should never happen."+EndOfLine+_
		    "Choose which side shall be used for all items, or Cancel"
		    if not showWarning (intro, 0, defaultsMismatches, storableItems) then
		      return false
		    end
		  end
		  
		  if localizationConflicts.Count > 0 then
		    dim intro as String = _
		    "The following items have conflicting translations."+EndOfLine+_
		    "Choose which side shall be used for all items, or Cancel"
		    if not showWarning (intro, 1, localizationConflicts, storableItems) then
		      return false
		    end
		  end
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RestoreFromBackup(data as Variant)
		  // Part of the Undoable interface.
		  
		  dim p as Pair = data
		  if p.Left.ObjectValue isA LinguaRecordSet then
		    // Restore single translation
		    dim grp as LinguaRecordSet = p.Left
		    grp.State = p.Right
		    itemList.Reveal grp
		    selectRecord grp, true
		  else
		    // Restore all translations
		    RBLPool.RecordsRestore p.Left
		    RBLPool.IsDirty = p.Right
		    itemList.Rebuild
		  end if
		  
		  updateStatus
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function save() As Boolean
		  ClearFocus
		  if RBLPool.SaveToRBL () then
		    updateStatus
		    return true
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub saveStateToPrefs()
		  dim p as SmartPreferences = App.Prefs
		  p.Value("EditWindow.Left") = self.Left
		  p.Value("EditWindow.Top") = self.Top
		  p.Value("EditWindow.Width") = self.Width
		  p.Value("EditWindow.Height") = self.Height
		  p.Sync
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub selectRecord(grp as LinguaRecordSet, forced as Boolean = false)
		  if forced or mCurrentRecord <> grp then
		    
		    if not forced and mCheckSpacesPending then
		      // we didn't call checkSpacing earlier, so do it now
		      checkSpacing mCurrentRecord
		    end
		    
		    if grp = nil then
		      origEdit(editIdx).Enabled = false
		      transEdit(editIdx).Enabled = false
		      transEdit(editIdx).ReadOnly = true
		      itemNameLbl.Text = ""
		      origEdit(editIdx).Text = ""
		      transEdit(editIdx).Text = ""
		    else
		      itemNameLbl.Text = grp.Identifier
		      
		      origEdit(editIdx).Text = grp.Original
		      origEdit(0).Enabled = true
		      origEdit(1).Enabled = true
		      
		      transEdit(0).ReadOnly = false
		      transEdit(1).ReadOnly = false
		      transEdit(editIdx).Text = grp.Translation
		      transEdit(0).Enabled = true
		      transEdit(1).Enabled = true
		      
		      mTransEditFresh = true
		    end if
		    mCheckSpacesPending = false
		    mCurrentRecord = grp
		    
		    if RBLPool <> nil then
		      itemList.Rebuild()
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function showWarning(intro as String, mode as Integer, items as Dictionary, storableItems() as LinguaRecordSet) As Boolean
		  // This is old code, with leftovers from now-removed functionality.
		  // Should maybe be moved into LinguaWarningsWindow...
		  
		  dim w as new LinguaWarningsWindow
		  dim l as ListBox = w.theList
		  dim col as Integer
		  dim hdrs() as String
		  
		  w.introTxt.Text = intro
		  
		  if mode = 0 then
		    col = 1
		    hdrs = Array("ConstName","Lingua-File","Database")
		  elseif mode = 1 then
		    l.ColumnCount = 4
		    col = 2
		    hdrs = Array("ConstName","Default","Lingua-File","Database")
		  elseif mode = 2 then
		    // orig vs. translated value
		    col = 1
		    hdrs = Array("ConstName","Original","Translated")
		  end
		  
		  for i as integer = 0 to l.ColumnCount-1
		    l.Heading(i) = hdrs(i)
		  next
		  
		  if mode = 2 then
		    w.cancelBut.Visible = false
		    w.okBut.Enabled = true
		    #if not TargetCocoa
		      // Cocoa doesn't seem to like it if both Cancel and Default are enabled
		      w.okBut.Cancel = true
		    #endif
		  else
		    l.ColumnType(col) = ListBox.TypeCheckbox
		    l.ColumnType(col+1) = ListBox.TypeCheckbox
		  end if
		  
		  for each linguaItem as LinguaRecordSet in items.Keys
		    dim dbItem as LinguaRecordSet = items.Value(linguaItem)
		    dim t1, t2 as String
		    if mode = 0 then
		      t1 = linguaItem.Original
		      t2 = dbItem.Original
		    elseif mode = 1 then
		      t1 = linguaItem.Translation
		      t2 = dbItem.Translation
		    elseif mode = 2 then
		      t1 = linguaItem.Original
		      t2 = linguaItem.Translation
		    end
		    l.AddRow linguaItem.Identifier
		    l.Cell (l.LastIndex, col) = t1
		    l.Cell (l.LastIndex, col+1) = t2
		    if mode = 1 then
		      l.Cell (l.LastIndex, 1) = linguaItem.Original
		    end
		  next
		  
		  w.ShowModal
		  
		  if w.mCancelled or mode = 2 then
		    mCancelled = true
		    return false
		  end
		  
		  if w.mChosenLeft then
		    // User chooses Lingua versions
		    // This means that we just keep all items because then they're be inserted into the DB
		  else
		    // User chooses Database versions
		    // This means that we remove the conflicts so that they won't get updated in the DB
		    for each item as LinguaRecordSet in items.Keys
		      storableItems.Remove storableItems.IndexOf(item)
		    next
		  end
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub switchVisibility(ctrl as RectControl, visible as Boolean)
		  if ctrl.Visible <> visible then
		    ctrl.Visible = visible
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub updateLineWrap()
		  // We can't change the ScrollBarHorizontal at runtime (Cocoa, Carbon),
		  // so we're instead switching between two controls one of which gets hidden
		  
		  // copy variable properties from visible to new control
		  dim a, b as Integer
		  if origEdit(0).Visible then
		    a = 1
		  else
		    b = 1
		  end if
		  origEdit(a).Text = origEdit(b).Text
		  transEdit(a).Text = transEdit(b).Text
		  
		  // now switch their visibility
		  switchVisibility origEdit(0), not mLineWrapEnabled
		  switchVisibility origEdit(1), mLineWrapEnabled
		  switchVisibility transEdit(0), not mLineWrapEnabled
		  switchVisibility transEdit(1), mLineWrapEnabled
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub updateStatus()
		  if RBLPool <> nil then
		    TTsUITools.SetWindowModified self, RBLPool.IsDirty()
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub verifySpaces(ltp as LinguaTranslationPool, verbose as Boolean)
		  dim items() as LinguaFileRecord = ltp.RawRecords.AllItems
		  
		  dim badItems as new Dictionary
		  
		  for each rec as LinguaFileRecord in items
		    if rec.Value.Type = Variant.TypeObject and rec.Value.ObjectValue isA LinguaRecordSet then
		      dim grp as LinguaRecordSet = rec.Value
		      dim oval as String = grp.Original
		      dim tval as String = grp.Translation
		      if tval <> "" then
		        dim oprefix, osuffix, tprefix, tsuffix as String
		        extractBoundingWhiteSpace oval, oprefix, osuffix
		        extractBoundingWhiteSpace tval, tprefix, tsuffix
		        if oprefix <> tprefix or osuffix <> tsuffix then
		          badItems.Value(grp) = grp
		        end
		      end if
		    end if
		  next
		  
		  if badItems.Count = 0 then
		    if verbose then
		      MsgBox "Found no mismatched whitespace at text boundaries"
		    end if
		  else
		    dim intro as String = "The following items have mismatched whitespace at their start or end."
		    call showWarning (intro, 2, badItems, nil)
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCheckSpacesPending As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentRecord As LinguaRecordSet
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineWrapEnabled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSplitter1Ratio As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSplitter2Ratio As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTransEditFresh As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUndoer As UndoEngine
	#tag EndProperty


	#tag Constant, Name = CocoaDoesNotCallLostFocus, Type = Boolean, Dynamic = False, Default = \"true", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events filterEdit
	#tag Event
		Sub TextChange()
		  itemList.Filter = me.Text
		  filterClearBut.Enabled = me.Text <> ""
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events filterClearBut
	#tag Event
		Sub Action()
		  filterEdit.Text = ""
		  filterClearBut.Enabled = false
		  #if TargetCocoa
		    // Bug in 2011r1: doesn't invoke the TextChange event
		    itemList.Filter = ""
		  #endif
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.Parent = nil
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events splitter1
	#tag Event
		Sub Open()
		  me.Attach filterClearBut, true
		  me.Attach filterEdit
		  me.Attach versionPop
		  me.Attach itemList
		  me.Attach listInfo
		  me.Attach Label2, true
		  me.Attach itemNameLbl
		  me.Attach origLbl
		  me.Attach origEdit(0)
		  me.Attach origEdit(1)
		  me.Attach splitter2
		  me.Attach transLbl
		  me.Attach transEdit(0)
		  me.Attach transEdit(1)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events itemList
	#tag Event
		Sub SelectedRecord(grp as LinguaRecordSet)
		  selectRecord (grp)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events origEdit
	#tag Event
		Sub Open(index as Integer)
		  me.Parent = nil
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events splitter2
	#tag Event
		Sub Open()
		  me.Attach origEdit(0)
		  me.Attach origEdit(1)
		  me.Attach transLbl, true
		  me.Attach transEdit(0)
		  me.Attach transEdit(1)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events transEdit
	#tag Event
		Function KeyDown(index as Integer, Key As String) As Boolean
		  if not me.Enabled then
		    beep
		    return false
		  elseif key = Chr(3) then
		    // Enter key
		    self.applyChanges()
		  end if
		End Function
	#tag EndEvent
	#tag Event
		Sub LostFocus(index as Integer)
		  // Note: This doesn't get invoked on OS X Cocoa with RB 2011r1
		  self.applyChanges()
		End Sub
	#tag EndEvent
	#tag Event
		Sub TextChange(index as Integer)
		  #if TargetCocoa and CocoaDoesNotCallLostFocus
		    // This needs to be done here for Cocoa because:
		    // 1. If user performs "Undo", this would change the text even if the field doesn't have the focus
		    // 2. We currently (RB 2011r1) do not even get the GotFocus event, so this is the only way
		    //     to apply changes.
		    
		    self.applyChanges(true)
		  #endif
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open(index as Integer)
		  me.Parent = nil
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events movePrevBut
	#tag Event
		Sub Action()
		  listMove false
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events moveNextBut
	#tag Event
		Sub Action()
		  listMove true
		End Sub
	#tag EndEvent
#tag EndEvents

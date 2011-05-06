#tag Window
Begin Window MainWindow
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   182
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Main"
   Visible         =   True
   Width           =   447
   Begin PushButton loadRBLBut
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Load from .rbl file"
      Default         =   False
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
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Underline       =   ""
      Visible         =   True
      Width           =   174
   End
   Begin PushButton saveToRBLBut
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Save to .rbl file"
      Default         =   False
      Enabled         =   False
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
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   142
      Underline       =   ""
      Visible         =   True
      Width           =   174
   End
   Begin PopupMenu langPop
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   False
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   ""
      Left            =   311
      ListIndex       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   109
      Underline       =   ""
      Visible         =   True
      Width           =   116
   End
   Begin Label StaticText1
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
      Left            =   206
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Choose Lang:"
      TextAlign       =   2
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   110
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   100
   End
   Begin PushButton showRecsBut
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Show loaded records"
      Default         =   True
      Enabled         =   False
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   253
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Underline       =   ""
      Visible         =   True
      Width           =   174
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  updateButtons
		  
		  #if DebugBuild
		    dim f as FolderItem = GetFolderItem("testfile.rbl")
		    if f.Exists then
		      loadRBL f
		    end
		  #endif
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function FileClose() As Boolean Handles FileClose.Action
			self.Close
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h21
		Private Sub loadRBL(f as FolderItem)
		  mTransPool = nil
		  
		  dim ltp as new LinguaTranslationPool
		  if not ltp.LoadFromRBL (f) then
		    MsgBox ltp.LastErrorMessage
		    mFileRef = nil
		  else
		    mTransPool = ltp
		    mFileRef = f
		  end
		  
		  updateButtons
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub showRawData(ltp as LinguaTranslationPool, title as String)
		  dim w as new RawDataWindow
		  w.Show ltp, title, mFileRef
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub updateButtons()
		  dim ready as Boolean
		  ready = mTransPool <> nil
		  
		  saveToRBLBut.Enabled = ready
		  showRecsBut.Enabled = ready
		  
		  langPop.Enabled = langPop.ListCount > 0
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFileRef As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTransPool As LinguaTranslationPool
	#tag EndProperty


#tag EndWindowCode

#tag Events loadRBLBut
	#tag Event
		Sub Action()
		  //
		  // Load from RBL file
		  //
		  
		  dim f as FolderItem = GetOpenFolderItem (DropFileTypes.LinguaFile)
		  if f <> nil then
		    loadRBL f
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events saveToRBLBut
	#tag Event
		Sub Action()
		  //
		  // Save records to RBL file
		  //
		  dim f as FolderItem = GetSaveFolderItem (DropFileTypes.LinguaFile, "output.rbl")
		  if f <> nil then
		    if not mTransPool.SaveToRBL () then
		      MsgBox "RBL save failed"
		    end
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events showRecsBut
	#tag Event
		Sub Action()
		  showRawData mTransPool, "Currently loaded items"
		  
		End Sub
	#tag EndEvent
#tag EndEvents

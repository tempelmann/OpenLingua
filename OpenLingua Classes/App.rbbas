#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub NewDocument()
		  dim f as FolderItem
		  
		  #if DebugBuild
		    f = GetFolderItem("testfile.rbl")
		    if f.Exists then
		      EditWindow.Open f
		      f = GetFolderItem("testfile.strings")
		      if f.Exists then
		        EditWindow.Open f
		      end if
		      return
		    end
		  #endif
		  
		  f = GetOpenFolderItem(DropFileTypes.LinguaFile)
		  if f <> nil then
		    EditWindow.Open f
		  end if
		  
		  if WindowCount = 0 then
		    quit
		  end
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  #if TargetWin32
		    call WindowsOS.AssociateExtension DropFileTypes.LinguaFile.Extensions, me.Name+"_tempel_org"
		  #endif
		  
		  me.AutoQuit = true
		End Sub
	#tag EndEvent

	#tag Event
		Sub OpenDocument(item As FolderItem)
		  EditWindow.Open item
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  return Exceptions.HandleUnhandledException(error)
		End Function
	#tag EndEvent


	#tag MenuHandler
		Function FileOpen() As Boolean Handles FileOpen.Action
			dim f as FolderItem
			f = GetOpenFolderItem (DropFileTypes.LinguaFile)
			if f <> nil then
			EditWindow.Open f
			end if
			Return True
			
		End Function
	#tag EndMenuHandler


	#tag Note, Name = About
		Written 2009, 2011 by Thomas Tempelmann
		For the Public Domain
		Project Home: https://github.com/tempelmann/OpenLingua
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  static sPrefs as SmartPreferences
			  if sPrefs = nil then
			    sPrefs = new SmartPreferences (Name)
			  end if
			  return sPrefs
			End Get
		#tag EndGetter
		Prefs As SmartPreferences
	#tag EndComputedProperty


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"Clear", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Clear"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Clear"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant

	#tag Constant, Name = Name, Type = String, Dynamic = False, Default = \"OpenLingua", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass

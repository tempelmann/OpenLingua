#tag Module
Protected Module WindowsOS
	#tag Method, Flags = &h1
		Protected Function AssociateExtension(theExtension as String, theAppID as String = "") As Boolean
		  #if TargetWin32
		    
		    // Taken from WFS 2.5 and cleaned up a little
		    
		    if theExtension.Left(1) <> "." then
		      theExtension = "." + theExtension
		    end if
		    
		    if theAppID = "" then
		      theAppID = App.ExecutableFile.Name.NthField(".",1) + "_app"
		    end
		    
		    dim root as new RegistryItem("HKEY_CLASSES_ROOT")
		    dim didRetryWithHKCU as Boolean
		    
		    #pragma BreakOnExceptions off
		    do
		      try
		        dim exten as RegistryItem
		        
		        #if true
		          // Add the ext to the registry
		          
		          try
		            exten = root.Child( theExtension )
		          catch
		            exten = root.AddFolder( theExtension )
		          end
		          if exten.DefaultValue <> theAppID then
		            exten.DefaultValue = theAppID
		          end if
		          
		          try
		            exten = root.Child( theAppID )
		          catch
		            exten = root.AddFolder( theAppID )
		          end
		          
		          try
		            exten = exten.Child( "Shell" )
		          catch
		            exten = exten.AddFolder( "Shell" )
		          end
		          
		          try
		            exten = exten.Child( "open" )
		          catch
		            exten = exten.AddFolder( "open" )
		          end
		          
		          try
		            exten = exten.Child( "command" )
		          catch
		            exten = exten.AddFolder( "command" )
		          end
		          
		          dim s as String = """" + App.ExecutableFile.AbsolutePath + """" + " ""%1"""
		          if exten.DefaultValue <> s then
		            exten.DefaultValue = s
		          end if
		          
		          return true
		          
		        #else
		          
		          // Remove the extension from the registry
		          exten.Delete( theExtension )
		          return true
		          
		        #endif
		        
		      catch RegistryAccessErrorException
		        // Win7 doesn't let me mess with the root registry unless I'm run as admin
		        if didRetryWithHKCU then
		          return false
		        end if
		        
		        // try again with local user scope
		        didRetryWithHKCU = true
		        root = new RegistryItem("HKEY_CURRENT_USER")
		        try
		          root = root.Child("SOFTWARE")
		          root = root.Child("Classes")
		        catch
		          return false
		        end
		        
		      end
		      
		    loop
		    
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RevealInExplorer(f as FolderItem)
		  #if TargetWin32
		    dim param as String = "/select, """ + f.AbsolutePath + """"
		    
		    Soft Declare Sub ShellExecuteA Lib "Shell32" ( hwnd as Integer, op as CString, file as CString, _
		    params as CString, directory as Integer, cmd as Integer )
		    Soft Declare Sub ShellExecuteW Lib "Shell32" ( hwnd as Integer, op as WString, file as WString, _
		    params as WString, directory as Integer, cmd as Integer )
		    
		    Const SW_SHOW = 5
		    
		    if System.IsFunctionAvailable( "ShellExecuteW", "Shell32" ) then
		      ShellExecuteW( 0, "open", "explorer", param, 0, SW_SHOW )
		    else
		      ShellExecuteA( 0, "open", "explorer", param, 0, SW_SHOW )
		    end if
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

#tag Module
Protected Module Exceptions
	#tag Method, Flags = &h0
		Sub Assert(condition as Boolean, failureMessage as String)
		  if not condition then
		    // We failed. Ask the user what to do
		    
		    dim stackTrace() as String = StackTrace(false)
		    
		    dim msg as String = "Assertion error ("+failureMessage+")"
		    
		    System.Log System.LogLevelError, msg + ". Stack trace: " + Join (stackTrace, "; ")
		    
		    if ignoredAsserts <> nil and ignoredAsserts.HasKey(failureMessage+stackTrace(0)) then
		      // ignore this one
		      return
		    end
		    
		    if mIsQuitting then
		      // no need to report further errors during quit
		      return
		    end
		    
		    writeErrorToFile msg, stackTrace
		    
		    // Show the error dialog
		    dim md as new MessageDialog
		    md.Message = "Internal Error (failed assertion)"
		    md.Explanation = failureMessage + EndOfLine + EndOfLine + textFileInfo
		    md.ActionButton.Caption = "&Quit" // was: "&Fail". But better to quit FAF in this case
		    md.CancelButton.Caption = "&Ignore"
		    md.CancelButton.Visible = true
		    md.CancelButton.Cancel = false
		    dim but as MessageDialogButton = md.ShowModal()
		    if but = md.ActionButton then
		      // Fail
		      mIsQuitting = true
		      quit
		      // we must really quit now - if we'd let the Assert return here, it might cause more trouble
		      dim exc as new RuntimeException // this assumes a supporting handler in App.UnhandledException
		      exc.Message = failureMessage
		      raise exc
		    else
		      // Ignore All of this type
		      if ignoredAsserts = nil then ignoredAsserts = new Dictionary
		      ignoredAsserts.Value(failureMessage+stackTrace(0)) = true
		    end if
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Description(exc as RuntimeException) As String
		  dim s as String
		  if exc = nil then
		    s = "<null>"
		  elseif exc isa IllegalCastException then
		    s="Illegal Cast"
		  elseif exc isa KeyNotFoundException then
		    s="Key Not Found"
		  elseif exc isa NilObjectException then
		    s="Nil Object"
		  elseif exc isa OutOfBoundsException then
		    s="Out Of Bounds"
		  elseif exc isa OutOfMemoryException then
		    s="Out Of Memory"
		  elseif exc isa StackOverflowException then
		    s="Stack Overflow"
		  elseif exc isa TypeMismatchException then
		    s="Type Mismatch"
		  elseif exc isa UnsupportedFormatException then
		    s="Unsupported Format"
		  elseif exc isa InvalidParentException then
		    s="Invalid Parent"
		  elseif exc isa EndException then
		    s="End (quit)"
		  else
		    // use reflection to get the name
		    dim t as Introspection.TypeInfo = Introspection.GetType(exc)
		    dim s2 as String = t.FullName
		    if s2.Right(9) = "Exception" then s2 = s2.Left(s2.Len-9)
		    if s2 <> "" then
		      s = s2
		    else
		      s = "Unknown exc type"
		    end
		  end
		  if exc <> nil and Len(exc.Message) > 0 then
		    s = s + " ("+exc.Message+")"
		  end
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HandleUnhandledException(error As RuntimeException) As Boolean
		  // Original code provided by Jonathan Johnson (http://www.nilobject.com/?p=245)
		  
		  if mIsQuitting then
		    if Ticks > mQuitTime+60*5 then // 5 seconds
		      mIsQuitting = false // reset
		      System.Log System.LogLevelError, "exc after quit -> reset"
		    else
		      System.Log System.LogLevelError, "exc while quit -> ignored"
		      return true
		    end
		  end
		  
		  dim stackTrace() as String
		  stackTrace = error.Stack
		  
		  dim wasAssert as Boolean
		  if Ubound(stackTrace) >= 0 then
		    dim top as String = stackTrace(0)
		    if InStr (top, "Exceptions.Assert") = 1 then
		      stackTrace.Remove 0
		      wasAssert = true
		    end if
		  end if
		  
		  // Prepare the error msg
		  dim errorMsg, msg as String
		  if wasAssert then
		    msg = "Internal Error (failed assertion)"
		    errorMsg = error.Message
		  else
		    msg = "Internal Error (exception)"
		    errorMsg = Description (error)
		  end
		  System.Log System.LogLevelError, msg + ". " + errorMsg + ". " + Join (stackTrace, "; ")
		  
		  break
		  
		  writeErrorToFile msg+EndOfLine+errorMsg, stackTrace
		  
		  // Show the error dialog
		  try
		    dim md as new MessageDialog
		    md.Message = msg
		    md.Explanation = errorMsg + EndOfLine + EndOfLine + textFileInfo
		    md.ActionButton.Caption = "&Quit"
		    md.CancelButton.Caption = "&Ignore"
		    md.CancelButton.Visible = true
		    if md.ShowModal = md.ActionButton then
		      mQuitTime = Ticks
		      mIsQuitting = true
		      quit
		    end if
		  catch exc2 as RuntimeException
		    if exc2 isA EndException then
		      // ignore (pass on)
		      raise exc2
		    else
		      // oh, well, what can we do...
		      System.Log System.LogLevelError, "Exc again!" + ". " + Join (exc2.Stack, "; ")
		    end
		  end
		  
		  // "The program may have become unstable. Restart ASAP"
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function StackTrace(trimmed as Boolean) As String()
		  try
		    #pragma BreakOnExceptions off
		    raise new RuntimeException
		  catch exc as RuntimeException
		    dim st() as String = exc.Stack
		    if Ubound(st) >= 0 then
		      while InStr (st(0), "Exceptions.") = 1
		        st.Remove 0
		      wend
		      if trimmed then TrimStackTrace st
		    end if
		    return st
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub TrimStackTrace(ByRef stackTrace() as String)
		  // clean out some nonsense from the stack, such as internal functions, and remove the parms
		  
		  dim prev as String
		  for i as Integer = 0 to Ubound(stackTrace)
		    dim s as String = stackTrace(i).DefineEncoding(Encodings.UTF8)
		    if s.Left(1) = "_" and prev.Left(1) = "_" or prev = s then
		      stackTrace.Remove i
		      i = i - 1
		    else
		      dim j as Integer = s.InStr("%")
		      s = s.Left(j-1) + s.Mid(s.InStr(j+1,"%")+1) // removes the "%...%" (contains the return type)
		      s = s.Replace("o<"," (").ReplaceAll(">o<",",").ReplaceAll(">",")")
		    end
		    stackTrace(i) = s
		    prev = s
		  next
		  
		  if Ubound(stackTrace) >= 0 and Left (stackTrace(Ubound(stackTrace)), 1) = "%" then
		    stackTrace.Remove Ubound(stackTrace)
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub writeErrorToFile(msg as String, stackTrace() as String)
		  // write the information to a text file on the Desktop
		  try
		    dim now as new Date
		    dim f as FolderItem
		    f = SpecialFolder.Desktop.Child("Crash Report for "+App.Name+" ("+now.SQLDateTime.ReplaceAll(":","-")+").txt")
		    TextOutputStream.Create(f).WriteLine msg + EndOfLine + EndOfLine + "Stack trace:" + EndOfLine + Join (stackTrace, EndOfLine)
		    System.DebugLog "Wrote crash report to: "+f.AbsolutePath
		  catch
		    System.DebugLog "Failed to write crash report."
		  end
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private ignoredAsserts As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsQuitting As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mQuitTime As Double
	#tag EndProperty


	#tag Constant, Name = textFileInfo, Type = String, Dynamic = False, Default = \"A text file with the crash details has been created on your desktop. You may send the file to the developer of this program.\r\rYou have the following choices now:\r\r\xE2\x80\xA2 Ignore \xE2\x80\x94 ignore this error and continue using the application.\r\xE2\x80\xA2 Quit \xE2\x80\x94 quit this application. Upon relaunch\x2C you will be given the option to reset all custom settings to see if that avoids the error in the future.", Scope = Private
	#tag EndConstant


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

#tag Module
Protected Module TTsUITools
	#tag Method, Flags = &h0
		Function CtrlBottom(extends ctrl as Object) As Integer
		  return ctrl.CtrlTop + ctrl.CtrlHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CtrlHeight(extends ctrl as Object) As Integer
		  if ctrl isA RectControl then
		    return RectControl(ctrl).Height
		  elseif ctrl isA Window then
		    return Window(ctrl).Height
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CtrlLeft(extends ctrl as Object) As Integer
		  if ctrl isA RectControl then
		    return RectControl(ctrl).Left
		  elseif ctrl isA Window then
		    return Window(ctrl).Left
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CtrlLockBottom(extends ctrl as Object) As Boolean
		  if ctrl isA RectControl then
		    return RectControl(ctrl).LockBottom
		  elseif ctrl isA ContainerControl then
		    return ContainerControl(ctrl).LockBottom
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CtrlLockTop(extends ctrl as Object) As Boolean
		  if ctrl isA RectControl then
		    return RectControl(ctrl).LockTop
		  elseif ctrl isA ContainerControl then
		    return ContainerControl(ctrl).LockTop
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CtrlParent(extends ctrl as Object) As Object
		  if ctrl isA RectControl then
		    return RectControl(ctrl).Parent
		  elseif ctrl isA ContainerControl then
		    return ContainerControl(ctrl).Parent
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CtrlRight(extends ctrl as Object) As Integer
		  return ctrl.CtrlLeft + ctrl.CtrlWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CtrlSetLeft(extends ctrl as Object, v as Integer)
		  if ctrl isA RectControl then
		    RectControl(ctrl).Left = v
		  elseif ctrl isA Window then
		    Window(ctrl).Left = v
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CtrlSetTop(extends ctrl as Object, v as Integer)
		  if ctrl isA RectControl then
		    RectControl(ctrl).Top = v
		  elseif ctrl isA Window then
		    Window(ctrl).Top = v
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CtrlTop(extends ctrl as Object) As Integer
		  if ctrl isA RectControl then
		    return RectControl(ctrl).Top
		  elseif ctrl isA Window then
		    return Window(ctrl).Top
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CtrlWidth(extends ctrl as Object) As Integer
		  if ctrl isA RectControl then
		    return RectControl(ctrl).Width
		  elseif ctrl isA Window then
		    return Window(ctrl).Width
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DocumentFile(extends w as Window, assigns f as FolderItem)
		  // Taken from MacOSLib's WindowManager
		  
		  if w.Handle = 0 then
		    return
		  end if
		  
		  #if targetCarbon
		    if f is nil then
		      declare function RemoveWindowProxy lib CarbonLib (inWindow as WindowPtr) as Integer
		      
		      dim OSError as Integer = RemoveWindowProxy(w)
		    else
		      declare function FSNewAlias lib CarbonLib (fromFile as Ptr, fsRef as Ptr, ByRef inAlias as Ptr) as Short
		      
		      dim aliasHandle as Ptr
		      dim fileRef as MacFS.Ref = f.MacRef
		      dim OSError as Integer = FSNewAlias(nil, fileRef, aliasHandle)
		      if OSError <> 0 then
		        return
		      end if
		      
		      declare function SetWindowProxyAlias lib CarbonLib (inWindow as WindowPtr, inAlias as Ptr) as Integer
		      
		      OSError = SetWindowProxyAlias(w, aliasHandle)
		      if aliasHandle <> nil then
		        soft declare sub DisposeHandle lib CarbonLib (h as Ptr)
		        DisposeHandle aliasHandle
		        aliasHandle = nil
		      end if
		    end if
		  #endif
		  
		  #if targetCocoa
		    declare sub setTitleWithRepresentedFilename lib "Cocoa" selector "setTitleWithRepresentedFilename:" (id as Ptr, filePath as CFStringRef)
		    
		    setTitleWithRepresentedFilename Ptr(w.Handle), f.MacPOSIXPath
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnsureSheetIsResizable(extends w as Window)
		  #if TargetMacOS
		    soft declare function ChangeWindowAttributes lib "Carbon" (window as WindowPtr, setTheseAttributes as Uint32, clearTheseAttributes as Uint32) as Integer
		    
		    const kWindowResizableAttribute = &h10 // (1L << 4)
		    const kWindowLiveResizeAttribute = &h10000000 // (1L << 28),
		    
		    if System.IsFunctionAvailable("ChangeWindowAttributes", "Carbon") then
		      dim attrs as Uint32
		      if w.Resizeable then attrs = attrs + kWindowResizableAttribute
		      if w.LiveResize then attrs = attrs + kWindowLiveResizeAttribute
		      if attrs <> 0 then
		        dim result as integer = ChangeWindowAttributes(w, attrs, 0)
		      end if
		    end if
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasFocus(c as ContainerControl) As Boolean
		  // finds out if any of the directly owned controls has the focus
		  // unfortunately, I can't make it search embedded containers as well - those have to be checked explicitly
		  
		  for idx as Integer = 0 to c.ControlCount-1
		    dim ctrl as Object = c.Control(idx)
		    if c.Focus = ctrl then
		      return true
		    end
		  next
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Resize(extends container as ContainerControl, width as Integer, height as Integer)
		  dim dW, dH as Integer
		  dW = width - container.Width
		  dH = height - container.Height
		  
		  if container isA PagePanel then
		    // resizes the children automatically
		  else
		    for i as Integer = 0 to container.Window.ControlCount-1
		      dim ctrl0 as Control = container.Window.Control(i)
		      dim s as String = ctrl0.Name
		      if ctrl0 isA RectControl then
		        dim ctrl as RectControl = RectControl(ctrl0)
		        if ctrl.Parent = container then
		          dim dW2, dH2, newT, newL as Integer
		          newT = ctrl.Top
		          newL = ctrl.Left
		          if ctrl.LockRight then
		            if ctrl.LockLeft then
		              dW2 = dW
		            else
		              newL = ctrl.Left + dW
		            end
		          end
		          if ctrl.LockBottom then
		            if ctrl.LockTop then
		              dH2 = dH
		            else
		              newT = ctrl.Top + dH
		            end
		          end
		          if dW2 <> 0 or dH2 <> 0 then
		            ctrl.Resize ctrl.Width + dW2, ctrl.Height + dH2
		          end
		          ctrl.Top = newT
		          ctrl.Left = newL
		        end
		      end
		    next
		  end
		  
		  container.Width = width
		  container.Height = height
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Resize(extends container as RectControl, width as Integer, height as Integer)
		  dim dW, dH as Integer
		  dW = width - container.Width
		  dH = height - container.Height
		  
		  if container isA PagePanel then
		    // resizes the children automatically
		  else
		    for i as Integer = 0 to container.Window.ControlCount-1
		      dim ctrl0 as Control = container.Window.Control(i)
		      dim s as String = ctrl0.Name
		      if ctrl0 isA RectControl then
		        dim ctrl as RectControl = RectControl(ctrl0)
		        if ctrl.Parent = container then
		          dim dW2, dH2, newT, newL as Integer
		          newT = ctrl.Top
		          newL = ctrl.Left
		          if ctrl.LockRight then
		            if ctrl.LockLeft then
		              dW2 = dW
		            else
		              newL = ctrl.Left + dW
		            end
		          end
		          if ctrl.LockBottom then
		            if ctrl.LockTop then
		              dH2 = dH
		            else
		              newT = ctrl.Top + dH
		            end
		          end
		          if dW2 <> 0 or dH2 <> 0 then
		            ctrl.Resize ctrl.Width + dW2, ctrl.Height + dH2
		          end
		          ctrl.Top = newT
		          ctrl.Left = newL
		        end
		      end
		    next
		  end
		  
		  container.Width = width
		  container.Height = height
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetWindowModified(theWindow as Window, isModified as Boolean)
		  #if TargetMacOS
		    #if TargetCocoa
		      declare sub setDocumentEdited lib "Cocoa" selector "setDocumentEdited:" (w as WindowPtr, documentEdited as Boolean)
		      setDocumentEdited theWindow, isModified
		    #else
		      declare function SetWindowModified lib "Carbon" (w as WindowPtr, modified as Integer) as Integer
		      dim v as Variant
		      v = isModified
		      call SetWindowModified(theWindow, v.IntegerValue)
		    #endif
		  #else
		    dim s as String = theWindow.Title
		    if s.Right(2) = " *" then
		      if not isModified then
		        s = s.Left(s.Len - 2)
		      end
		    elseif isModified then
		      s = s + " *"
		    end
		    theWindow.Title = s
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ShowMessageDialog(w as Window, icon as String, actionTxt as String, cancelTxt as String, altTxt as String, msg as String, explanation as String) As Integer
		  System.DebugLog "UITools.ShowMessageDialog "+msg+" -- "+explanation
		  
		  dim d as new MessageDialog
		  dim b as MessageDialogButton
		  
		  if icon = "ask" then
		    d.Icon = MessageDialog.GraphicQuestion
		  elseif icon = "note" then
		    d.Icon = MessageDialog.GraphicNote
		  elseif icon = "stop" then
		    d.Icon = MessageDialog.GraphicStop
		  end
		  
		  if Len(actionTxt) > 1 then
		    d.ActionButton.Caption = actionTxt
		  end
		  if cancelTxt <> "" then
		    d.CancelButton.Visible = true
		    if TargetCocoa and Len(cancelTxt) = 1 then
		      // Bug in 2011r1: doesn't set the text as it should
		      cancelTxt = "Cancel"
		    end
		    if Len(cancelTxt) > 1 then
		      d.CancelButton.Caption = cancelTxt
		    end
		  end if
		  d.AlternateActionButton.Visible = altTxt <> ""
		  if Len(altTxt) > 1 then
		    d.AlternateActionButton.Caption = altTxt
		  end
		  d.Message = msg
		  d.Explanation = explanation
		  
		  if w <> nil then
		    w.Show // bring parent to front
		  end
		  
		  if TargetMacOS and w <> nil then
		    b = d.ShowModalWithin (w)
		  else
		    b = d.ShowModal () // Windows has problems with the Within() function when the win is not frontmost
		  end
		  
		  select case b
		  case d.ActionButton
		    return 1
		  case d.CancelButton
		    return 2
		  case d.AlternateActionButton
		    return 3
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ShowMsg(w as Window, msg as String, more as String = "")
		  call ShowMessageDialog (w, "note", "*", "", "", msg, more)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function StringWidth(txt as String, fontName as String, fontSize as Integer) As Double
		  static p as Picture
		  if p = nil then
		    p = NewPicture (32, 32, 32)
		  end if
		  p.Graphics.TextFont = fontName
		  p.Graphics.TextSize = fontSize
		  return p.Graphics.StringWidth (txt)
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Written mostly by Thomas Tempelmann, for the public domain
	#tag EndNote


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

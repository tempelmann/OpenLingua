#tag Class
Protected Class UndoEngine
	#tag Method, Flags = &h0
		Sub Backup(editLabel as string, obj as Undoable, hint as Variant = nil)
		  if busy then
		    mNewBackup = obj.Backup (hint, false)
		    return
		  end
		  
		  busy = true
		  
		  if obj = nil then break // must not be nil
		  
		  positionp=positionp+1 // need to increment this value first so that invoked Backup can tell dirty state by calling CanUndo
		  dim data as Variant
		  data = obj.Backup (hint, false)
		  positionp=positionp-1
		  
		  redim me.editLabel(positionp)
		  redim me.objp(positionp)
		  redim me.bakp(positionp)
		  redim me.hint(positionp)
		  me.hint.Append hint
		  me.editLabel.append editLabel
		  me.objp.append obj
		  me.bakp.append data
		  
		  positionp=positionp+1
		  
		  if maxundoP > 0 and positionp >= maxundoP then
		    me.editLabel.remove 0
		    me.hint.remove 0
		    me.objp.remove 0
		    me.bakp.remove 0
		    positionp = positionp-1
		  end
		  
		  busy = false
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function backupAndRestore(p as Integer) As Boolean
		  busy = true
		  dim op as Undoable = objp(p)
		  dim v as Variant = hint(p)
		  try
		    mNewBackup = op.Backup (v, true)
		  catch
		    busy = false
		    return false
		  end
		  hint(p) = v
		  try
		    op.RestoreFromBackup (bakp(p))
		    bakp(p) = mNewBackup // may have been overwritten by a new call to Backup() from within the RestoreFromBackup() call
		    busy = false
		    return true
		  catch exc
		    bakp(p) = mNewBackup
		    busy = false
		    return false
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanRedo() As Boolean
		  return positionp < ubound(editLabel)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanUndo() As Boolean
		  return positionp >= 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(max as integer = 0)
		  maxundoP = max
		  positionp = -1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Pop()
		  if positionp >= 0 then
		    positionp = positionp-1
		    redim editLabel(positionp)
		    redim objp(positionp)
		    redim bakp(positionp)
		    redim hint(positionp)
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Redo()
		  if positionp < ubound(editLabel) then
		    positionp = positionp+1
		    if not backupAndRestore (positionp) then
		      break
		      beep
		    end
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RedoLabel() As string
		  if positionp < ubound(editLabel) then
		    return editLabel(positionp+1)
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(obj as Undoable)
		  // Removes all recordings of the obj from the undo stack
		  // Necessary when the stack controls separate UI elements of which one only gets reset
		  
		  for p as Integer = Ubound(objp) downTo 0
		    if objp(p) = obj then
		      // remove this one
		      objP.Remove p
		      editLabel.Remove p
		      bakP.Remove p
		      hint.Remove p
		      if positionP >= p then
		        positionP = positionP - 1
		      end
		    end
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveByHint(hint as Variant)
		  // Removes all recordings with the given label from the undo stack
		  // Necessary when the stack controls separate UI elements of which one only gets reset
		  
		  for p as Integer = Ubound(objp) downTo 0
		    if me.hint(p) = hint then
		      // remove this one
		      me.objP.Remove p
		      me.editLabel.Remove p
		      me.bakP.Remove p
		      me.hint.Remove p
		      if positionP >= p then
		        positionP = positionP - 1
		      end
		    end
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  redim bakp(-1)
		  redim objp(-1)
		  redim editLabel(-1)
		  redim hint(-1)
		  positionp = -1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Undo(allowRedo as Boolean = true)
		  if mUndoing then
		    // oops!
		    break
		  end
		  if positionp >= 0 then
		    dim p as Integer = positionp
		    positionp = positionp-1 // need to decrement this value first so that invoked Backup can tell dirty state by calling CanUndo
		    mUndoing = true
		    if not backupAndRestore (p) then
		      positionp = positionp+1
		      allowRedo = true
		      break
		      beep
		    end
		    mUndoing = false
		    if not allowRedo then
		      // This is used for cases where an attempted change went bad and now it shall be undone
		      // In this case, the entire recording shall be forgotten, but other outstanding redos shall remain available
		      // Therefore, we only remove this one redo recording from all arrays
		      bakP.Remove p
		      editLabel.Remove p
		      hint.Remove p
		      objP.Remove p
		    end
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UndoLabel() As string
		  if positionp >= 0 then
		    return editLabel(positionp)
		  end
		End Function
	#tag EndMethod


	#tag Note, Name = About
		UndoEngine © Matthias Buercher 2000 http://www.belle-nuit.com, some modifications by Thomas Tempelmann 2002
		
		From the website:
		
		© Belle Nuit Montage / Matthias Bürcher April 2000. All rights reserved. Written in Switzerland.
		
		This library is free software; you can redistribute it and/or modify it under the terms of the
		GNU Lesser General Public License as published by the Free Software Foundation; either version
		2.1 of the License, or (at your option) any later version.
	#tag EndNote

	#tag Note, Name = Changes
		Based von v1.0.0
		1.0.1: Thomas Tempelmann, May 8, 02: added "busy" flag, changed RAMstream into Variant
		1.0.2: Thomas Tempelmann, Feb 19, 08: added Pop() method to remove the topmost entry
		1.0.3: Thomas Tempelmann, Feb 19, 08: cleanup by finally using redim(-1), added Remove() methods
	#tag EndNote

	#tag Note, Name = How Undo works
		A general explanation:
		
		User asks a UI controller, e.g. a Window, to make a modification to the data.
		The controller tells the Undo Manager that it modifies something and wants
		to be called back if user says "Undo".
		The Undo Manager maintains a stack of these controller's actions along with
		data the controller give it to remember.
		If user asks for Undo, the Undo Manager takes the top item from its stack,
		and passes the remembered data to the respective controller, telling it to
		perform a "restore" operation.
		Controller uses the remembered data to restore the state.
		
		For Redo to work, it's necessary that the Controller also saves the state
		at the time it's asked to perform a "restore", and gives that state to
		the Undo Manager, just as if it were doing a normal User-requested
		modification. Again, the Undo Manager will remember this on its stack,
		so that a Redo work almost exactly like an Undo.
		
		How it works with UndoEngine:
		
		User modification:
		- Controller calls UndoEngine.Backup() to report a modification, usually before
		the modification is performed. A hint can be included.
		- UndoEngine calls back the Controller's Backup method which is supposed
		to return the data it wants to save for a restore. The above hint is passed in
		so that different types of states can be saved easily this way.
		
		Undo:
		- UndoEngine calls the Controller's Backup method with the previous hint
		value, and the Controller is supposed to return the current state again.
		- UndoEngine calls the Controller's RestoreFromBackup method with the previously saved
		data, and the Controller uses it to restore the previous state.
		
		Redo:
		Same happens as with Undo. I.e, the Controller is not aware of the difference.
	#tag EndNote


	#tag Property, Flags = &h1
		Protected bakP() As Variant
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected busy As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected editLabel() As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected hint() As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAwaitingBackupCallP As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected maxundoP As integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNewBackup As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUndoing As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected objP() As Undoable
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected PositionP As integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected typeLabel As Variant
	#tag EndProperty


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
End Class
#tag EndClass

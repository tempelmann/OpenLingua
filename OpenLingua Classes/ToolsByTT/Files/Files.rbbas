#tag Module
Protected Module Files
	#tag Method, Flags = &h0
		Function DeleteFolderWithContents(extends theFolder as FolderItem, continueIfErrors as Boolean = false) As Integer
		  // Returns an error code if it fails, or zero if the folder was deleted successfully
		  
		  dim returnCode, lastErr, itemCount as integer
		  dim files(), dirs() as FolderItem
		  
		  if theFolder = nil or not theFolder.Exists() then
		    return 0
		  end
		  
		  // Collect the folder‘s contents first.
		  // This can be faster than collecting them in reverse order and deleting them right away
		  // (this is the case with certain file systems that are optimized for forward iteration)
		  itemCount = theFolder.Count
		  for i as integer = 1 to itemCount
		    dim f as FolderItem
		    f = theFolder.TrueItem( i )
		    if f <> nil then
		      if f.Directory then
		        dirs.Append f
		      else
		        files.Append f
		      end
		    end
		  next
		  
		  // Now delete the files
		  for each f as FolderItem in files
		    f.Delete
		    lastErr = f.LastErrorCode   // Check if an error occurred
		    if lastErr <> 0 then
		      if continueIfErrors then
		        if returnCode = 0 then returnCode = lastErr
		      else
		        // Return the error code if any. This will cancel the deletion.
		        return lastErr
		      end
		    end if
		  next
		  
		  redim files(-1) // free the memory used by the files array before we enter recursion
		  
		  // Now delete the directories
		  for each f as FolderItem in dirs
		    lastErr = f.DeleteFolderWithContents (continueIfErrors)
		    if lastErr <> 0 then
		      if continueIfErrors then
		        if returnCode = 0 then returnCode = lastErr
		      else
		        // Return the error code if any. This will cancel the deletion.
		        return lastErr
		      end
		    end if
		  next
		  
		  if returnCode = 0 then
		    // We‘re done without error, so the folder should be empty and we can delete it.
		    theFolder.Delete
		    returnCode = theFolder.LastErrorCode
		    if returnCode = 0 and theFolder.Exists then
		      // some unknown reason prevented the folder from being deleted
		      returnCode = -1
		    end
		  end
		  
		  return returnCode
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Extension(extends f as FolderItem) As string
		  // Returns the extension, always including the period (e.g ".app")
		  // If the returned string is empty, it means that the file name has no extension
		  // If the returned string equals ".", it means that the file name ended in a period
		  
		  dim components() as string
		  dim ext as string
		  
		  components = Split( f.Name, "." )
		  
		  if Ubound( components ) = 0 then
		    // There is no extension
		    return ""
		  end if
		  
		  if Ubound( components ) = 1 and LenB( components( 0 ) ) = 0 then
		    // The file name begins with a period and has no extension
		    return ""
		  end if
		  
		  // There is an extension, return it with the "." to indicate this
		  return "." + components.Pop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FollowAlias(extends f as FolderItem) As FolderItem
		  if f <> nil and f.Alias then
		    // do NOT use a while loop here unless we check for looping back to the
		    // same folderItem, because when the resolve fails, that's what happens
		    f = f.Parent.Child(f.Name)
		  end
		  return f
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsInside(extends f as FolderItem, container as FolderItem) As Boolean
		  while f.Parent <> nil and f.Parent <> f
		    f = f.Parent
		    if SameFolderItem(f, container) then
		      return true
		    end
		  wend
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsInsideTrash(extends f as FolderItem) As Boolean
		  while f.Parent <> nil and f.Parent <> f
		    f = f.Parent
		    if SameFolderItem(f, f.TrashFolder) then
		      return true
		    end
		  wend
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsTrashFolder(extends f as FolderItem) As Boolean
		  return SameFolderItem(f, f.TrashFolder) or SameFolderItem(f, SpecialFolder.Trash)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Items(extends dir as FolderItem) As FolderItem()
		  dim result() as FolderItem
		  if dir.Directory then
		    dim n as Integer = dir.Count
		    for i as Integer = 1 to n
		      dim f as FolderItem = dir.Item(i)
		      if f <> nil then
		        result.Append f
		      end if
		    next
		  end
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LoadBinary(extends f as FolderItem) As String
		  if f.Exists and f.Directory then
		    System.DebugLog "Error in "+CurrentMethodName+": File is a Folder: "+f.AbsolutePath
		  else
		    dim tf as BinaryStream
		    tf = f.OpenAsBinaryFile(false)
		    if tf <> nil then
		      dim s as String = tf.Read(tf.Length)
		      tf.Close
		      return s
		    end if
		  end
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LoadText(extends f as FolderItem) As String
		  if f.Exists and f.Directory then
		    System.DebugLog "Error in "+CurrentMethodName+": File is a Folder: "+f.AbsolutePath
		  else
		    dim tf as TextInputStream
		    tf = f.OpenAsTextFile
		    if tf <> nil then
		      dim s as String = tf.ReadAll
		      tf.Close
		      return s
		    end if
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveToTrashOrDelete(extends f as FolderItem)
		  if f <> nil and f.Exists then
		    #if TargetMacOS
		      // Let's prefer to use FinderAppleEvents.MoveToTrash, which takes care of duplicates and provides Undo in Finder
		      FinderAppleEvents.MoveToTrash f
		    #endif
		    if f.Exists then
		      dim tf as FolderItem = f.TrashFolder
		      if tf = nil then
		        tf = SpecialFolder.Trash
		      end
		      if tf <> nil then
		        dim f2 as new FolderItem(f)
		        f2.MoveFileTo tf
		      end
		      if f.Exists then
		        // MoveFileTo didn't work - delete it immediately
		        if f.Directory then
		          call f.DeleteFolderWithContents()
		        else
		          f.Delete
		        end
		      end
		    end
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NameWithoutExtension(extends f as FolderItem) As string
		  // Complements the Extension() function
		  
		  dim components() as string
		  dim name as String
		  
		  name = f.Name
		  components = Split( name, "." )
		  
		  if Ubound( components ) = 0 then
		    // There is no extension
		    return name
		  end if
		  
		  if Ubound( components ) = 1 and LenB( components( 0 ) ) = 0 then
		    // The file name begins with a period and has no extension
		    return name
		  end if
		  
		  // If we get here, it means that the file has an extension, whether or not it begins with a period
		  // Remove the last component (i.e. the extension)
		  call components.Pop
		  
		  // Re-join the name components without the last one
		  return Join( components, "." )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NativePath(extends f as FolderItem) As String
		  // This gives a path that fits what the OS likes - i.e. a POSIX Path on Mac and Linux
		  
		  #if TargetMacOS
		    return f.MacPOSIXPath
		  #else
		    return f.AbsolutePath
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PathElements(extends item as FolderItem) As String()
		  dim e() as String
		  dim f as FolderItem = item
		  while f <> nil
		    e.Insert 0, f.Name
		    f = f.Parent
		  wend
		  return e
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reveal(extends f as FolderItem)
		  #if TargetMacOS
		    FinderAppleEvents.RevealItemInFinder f, true
		  #elseif TargetWin32
		    WindowsOS.RevealInExplorer f
		  #elseif TargetLinux
		    LinuxOS.RevealOnDesktop f
		  #else
		    oops?
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SameAs(extends f1 as FolderItem, f2 as FolderItem) As Boolean
		  return SameFolderItem (f1, f2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SameFolderItem(f1 as FolderItem, f2 as FolderItem) As Boolean
		  // Note: the ConvertEncoding calls are necessary to deal with the possible mix of decomposed
		  // and composed non-ASCII chars
		  if f1 = f2 then
		    return true
		  elseif (f1 = nil) or (f2 = nil) then
		    return false
		  end
		  
		  #if TargetMacOS
		    return (f1.MacVRefNum = f2.MacVRefNum) and (f1.MacDirID = f2.MacDirID) and (f1.name.ConvertEncoding(encodings.SystemDefault) = f2.name.ConvertEncoding(encodings.SystemDefault))
		  #else
		    return f1.URLPath.ConvertEncoding(encodings.SystemDefault) = f2.URLPath.ConvertEncoding(encodings.SystemDefault)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Save(extends f as FolderItem, data as String, withBackup as Boolean) As Boolean
		  #if TargetWin32
		    const BackupSuffix = "-bak"
		  #else
		    const BackupSuffix = "~"
		  #endif
		  
		  dim backupFile as FolderItem
		  dim bs as BinaryStream
		  dim swapAfterwards as Boolean
		  
		  //
		  // There are 2 cases to consider:
		  // a) file does not exist or no backup wanted -> Write to file
		  // b) file exists and backup wanted -> Write to backup, Swap
		  //
		  
		  if f.Exists then
		    // We are about to replace an existing file. Do this smartly, optionally keeping a backup of the previous version
		    
		    // Some sanity checks first
		    if f.Directory then
		      System.DebugLog "Error in "+CurrentMethodName+": File is a Folder: "+f.AbsolutePath
		      return false
		    end
		    if f.Alias then
		      // Overwriting an Alias file with a non-Alias is usually not desired. If desired, delete it before making this call
		      System.DebugLog "Error in "+CurrentMethodName+": File is an Alias: "+f.AbsolutePath
		      return false
		    end
		    
		    if withBackup then
		      // Case (b)
		      backupFile = f.Parent.Child (f.NameWithoutExtension+BackupSuffix+f.Extension)
		      try
		        bs = BinaryStream.Create (backupFile, true)
		      catch exc as IOException
		        // An existing backup file can't be written to -> we'll ignore this, reverting to a non-backup save
		        System.DebugLog "Warning in "+CurrentMethodName+": Backup file ("+backupFile.AbsolutePath+") can't be written to: "+exc.Message
		      end try
		    end
		  end if
		  
		  if bs = nil then
		    // Case (a) or unwritable backup file
		    try
		      bs = BinaryStream.Create (f, true)
		    catch exc as IOException
		      System.DebugLog "Error in "+CurrentMethodName+": File ("+f.AbsolutePath+") can't be written to: "+exc.Message
		      return false
		    end
		  else
		    // Case (b)
		    swapAfterwards = true
		  end
		  
		  bs.Write data
		  bs.Close
		  
		  if swapAfterwards then
		    if not Files.FileSwapping.Exchange (f, backupFile) then
		      return false
		    end
		  end
		  
		  return f.Length = data.LenB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TrueItems(extends dir as FolderItem) As FolderItem()
		  dim result() as FolderItem
		  if dir.Directory then
		    dim n as Integer = dir.Count
		    for i as Integer = 1 to n
		      dim f as FolderItem = dir.TrueItem(i)
		      if f <> nil then
		        result.Append f
		      end if
		    next
		  end
		  return result
		End Function
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

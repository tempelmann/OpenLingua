#tag Class
Protected Class SmartPreferences
	#tag Method, Flags = &h0
		Function AppSupportFolder(createIfMissing as Boolean = true) As FolderItem
		  // Return:
		  // nil -> app folder invalid or can't be created
		  // otherwise -> test for .Exists if createIfMissing=false was passed
		  
		  dim f as FolderItem = SpecialFolder.ApplicationData
		  if f = nil or not f.Exists then
		    break
		    System.DebugLog "Can't locate app data folder"
		    return nil
		  end if
		  
		  f = f.Child(mAppName)
		  if not f.Exists then
		    
		    if not createIfMissing then
		      return f
		    end
		    
		    f.CreateAsFolder
		    if not f.Exists then
		      break
		      System.DebugLog "Can't create App data folder at: "+f.AbsolutePath
		      return nil
		    end if
		  end if
		  
		  if not f.Directory then
		    break
		    System.DebugLog "App data folder not a dir at: "+f.AbsolutePath
		    return nil
		  end if
		  
		  
		  return f
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function arrayFromBoolean(a() as Boolean) As Variant()
		  dim var() as Variant
		  for each v as Variant in a
		    var.Append v
		  next
		  return var
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function arrayFromDate(a() as Date) As Variant()
		  dim var() as Variant
		  for each v as Variant in a
		    var.Append v
		  next
		  return var
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function arrayFromDouble(a() as Double) As Variant()
		  dim var() as Variant
		  for each v as Variant in a
		    var.Append v
		  next
		  return var
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function arrayFromInteger(a() as Integer) As Variant()
		  dim var() as Variant
		  for each v as Variant in a
		    var.Append v
		  next
		  return var
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function arrayFromLong(a() as Int64) As Variant()
		  dim var() as Variant
		  for each v as Variant in a
		    var.Append v
		  next
		  return var
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function arrayFromObject(a() as Object) As Variant()
		  dim var() as Variant
		  for each v as Variant in a
		    var.Append v
		  next
		  return var
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function arrayFromSingle(a() as Single) As Variant()
		  dim var() as Variant
		  for each v as Variant in a
		    var.Append v
		  next
		  return var
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function arrayFromString(a() as String) As Variant()
		  dim var() as Variant
		  for each v as Variant in a
		    var.Append v
		  next
		  return var
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(applicationName as String, alwaysUseAppSupportFolder as Boolean = false)
		  if applicationName = "" then
		    // App Name must be specified
		    raise new RuntimeException
		  end
		  
		  mUseAppSupportFolder = not TargetMacOS or alwaysUseAppSupportFolder
		  mAppName = applicationName
		  if mUseAppSupportFolder then
		    mPrefsDict = new Dictionary
		    syncPrefsFile()
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  if me.IsDirty then
		    me.Sync
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key as String)
		  if mUseAppSupportFolder then
		    if mPrefsDict.HasKey (key) then
		      mPrefsDict.Remove (key)
		      mIsDirty = true
		    end if
		  else
		    #if TargetMacOS
		      CFPreferences.Value(key) = nil
		    #endif
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sync(forced as Boolean = false)
		  if forced or me.IsDirty then
		    if mUseAppSupportFolder then
		      syncPrefsFile()
		    else
		      #if TargetMacOS
		        call CFPreferences.Sync()
		      #endif
		    end if
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub syncPrefsFile()
		  // This gets used only when mUseAppSupportFolder=true
		  
		  dim f as FolderItem = AppSupportFolder(me.IsDirty)
		  if f = nil or not f.Exists then return
		  
		  f = f.Child("Preferences.plist")
		  
		  if me.IsDirty then
		    // write changes to disk
		    if not mPrefsDict.SaveXML (f, true) then
		      break
		      System.DebugLog "Can't save prefs at: "+f.AbsolutePath
		      return
		    else
		      mIsDirty = false
		    end
		  else
		    // read latest state from disk
		    if f.Exists and not mPrefsDict.LoadXML (f) then
		      break
		      System.DebugLog "Can't read prefs at: "+f.AbsolutePath
		      return
		    end
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function toCFType(v as Variant) As CFType
		  // Throws an UnsupportedFormatException if it contains objects it can't convert
		  
		  dim newv as CFType
		  select case v.Type
		    
		  case v.TypeBoolean
		    newv = CFBoolean(v.BooleanValue)
		  case v.TypeInteger
		    newv = CFNumber(v.Int64Value)
		  case v.TypeDouble, v.TypeSingle
		    newv = CFNumber(v.DoubleValue)
		  case v.TypeString, v.TypeCFStringRef
		    newv = CFString(v.StringValue)
		  case v.TypeObject
		    if v.ObjectValue isA Dictionary then
		      dim d as Dictionary = v
		      dim cfd as new CFMutableDictionary
		      for each key as String in d.Keys
		        dim value as Variant = d.Value(key)
		        cfd.Value(CFString(key)) = toCFType(value)
		      next
		      newv = cfd
		    elseif v.ObjectValue isA CFType then
		      newv = CFType(v.ObjectValue)
		    else
		      raise new UnsupportedFormatException
		    end if
		  else
		    if v.IsArray then
		      
		      // this is ugly - we have to do an individual loop for each possible type of the elems in the array
		      dim ar() as Variant
		      select case v.ArrayElementType
		      case Variant.TypeBoolean
		        ar = arrayFromBoolean (v)
		      case Variant.TypeString
		        ar = arrayFromString (v)
		      case Variant.TypeDate
		        ar = arrayFromDate (v)
		      case Variant.TypeDouble
		        ar = arrayFromDouble (v)
		      case Variant.TypeInteger
		        ar = arrayFromInteger (v)
		      case Variant.TypeLong
		        ar = arrayFromLong (v)
		      case Variant.TypeSingle
		        ar = arrayFromSingle (v)
		      case Variant.TypeObject
		        ar = arrayFromObject (v)
		      end select
		      
		      dim cfa as new CFMutableArray(ar.Ubound+1)
		      for each value as Variant in ar
		        cfa.Append toCFType (value)
		      next
		      newv = cfa
		      
		    else
		      // not supported yet
		      raise new UnsupportedFormatException
		    end if
		    
		  end select
		  
		  return newv
		  
		Exception exc as RuntimeException
		  break
		  raise new UnsupportedFormatException
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(key as String, assigns v as Variant)
		  if mUseAppSupportFolder then
		    if not mPrefsDict.HasKey (key) or mPrefsDict.Value (key) <> v then
		      mPrefsDict.Value (key) = v
		      mIsDirty = true
		    end if
		  else
		    #if TargetMacOS
		      dim oldv as CFType = CFPreferences.Value (key)
		      
		      dim newv as CFType
		      newv = toCFType (v)
		      
		      if oldv = nil then
		        // value not in prefs yet
		        CFPreferences.Value(key) = CFPropertyList(newv)
		      elseif not (newv.Equals(oldv)) then
		        CFPreferences.Value(key) = CFPropertyList(newv)
		      else
		        // not changed
		        return
		      end if
		    #endif
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(key as String, default as Variant) As Variant
		  if mUseAppSupportFolder then
		    return mPrefsDict.Lookup (key, default)
		  else
		    #if TargetMacOS
		      return CFPreferences.Value (key, default)
		    #endif
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValueAsArray(name as String) As Variant()
		  dim result() as Variant
		  dim v as Variant = me.Value(name, nil)
		  if v = nil then
		    return result
		  elseif v.IsArray then
		    return v
		  else
		    break // wrong type - what now?
		    // let's return nil - the caller must check this!
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValueAsDict(name as String) As Dictionary
		  dim v as Variant = me.Value(name, nil)
		  if v = nil then
		    return new Dictionary
		  elseif v.Type = Variant.TypeObject and v.ObjectValue isA Dictionary then
		    return v
		  else
		    break // wrong type - what now?
		    // let's return nil - the caller must check this!
		  end if
		End Function
	#tag EndMethod


	#tag Note, Name = About
		This is "smart" because it only writes to CFPreferences if the set value is
		actually different from the current prefs value, hence avoiding dirtying
		the prefs unnecessarily.
	#tag EndNote

	#tag Note, Name = Requirements
		For Mac OS, the entire "CoreFoundation" module with contained classes needs to be added, available here: 
		http://code.google.com/p/macoslib/
		
		Also, Keven Ballard's "XMLDictionary" is needed (should be included)
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mUseAppSupportFolder then
			    return mIsDirty
			  else
			    #if TargetMacOS
			      return CFPreferences.Dirty
			    #endif
			  end
			End Get
		#tag EndGetter
		IsDirty As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		#tag Note
			This is unused on OSX when using CFPreferences, i.e. when mUseAppSupportFolder=false
		#tag EndNote
		Private mAppName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			This is unused on OSX when using CFPreferences, i.e. when mUseAppSupportFolder=false
		#tag EndNote
		Private mIsDirty As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			This is unused on OSX when using CFPreferences, i.e. when mUseAppSupportFolder=false
		#tag EndNote
		Private mPrefsDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseAppSupportFolder As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsDirty"
			Group="Behavior"
			Type="Boolean"
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

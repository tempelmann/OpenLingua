#tag Class
Class CFPreferences
	#tag Method, Flags = &h21
		Private Shared Function AnyHost() As Ptr
		  static v as Ptr = GetAnyHost // the app's host can't change while running this app, can it?
		  return v
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CurrentApplication() As Ptr
		  static v as Ptr = GetCurrentApplication
		  return v
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CurrentUser() As Ptr
		  static v as Ptr  = GetCurrentUser// the app's user can't change while running this app, can he?
		  return v
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetAnyHost() As Ptr
		  dim p as Ptr = CFBundle.CarbonFramework.DataPointerNotRetained("kCFPreferencesAnyHost")
		  if p <> nil then
		    return p.Ptr(0)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetCurrentApplication() As Ptr
		  dim p as Ptr = CFBundle.CarbonFramework.DataPointerNotRetained("kCFPreferencesCurrentApplication")
		  if p <> nil then
		    return p.Ptr(0)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetCurrentUser() As Ptr
		  dim p as Ptr = CFBundle.CarbonFramework.DataPointerNotRetained("kCFPreferencesCurrentUser")
		  if p <> nil then
		    return p.Ptr(0)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Keys() As String()
		  dim theList() as String
		  
		  #if targetMacOS
		    
		    dim appID as Ptr = CurrentApplication
		    dim user as Ptr = CurrentUser
		    dim host as Ptr = AnyHost
		    if appID = nil or user = nil or host = nil then
		      return theList
		    end if
		    
		    soft declare function CFPreferencesCopyKeyList lib CarbonLib (applicationID as Ptr, userName as Ptr, hostName as Ptr) as Ptr
		    
		    dim p as Ptr = CFPreferencesCopyKeyList(appID, user, host)
		    dim keyArray as new CFArray(p, true) // CFArray can deal with p=nil, so there's no need to check for it here
		    for i as Integer = 0 to keyArray.Count - 1
		      dim theValue as CFType = keyArray.Value(i)
		      theList.Append CFString(theValue)
		    next
		    
		  #endif
		  
		  return theList
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Sync() As Boolean
		  #if targetMacOS
		    soft declare function CFPreferencesAppSynchronize lib CarbonLib (applicationID as Ptr) as Boolean
		    
		    dim appID as Ptr = CurrentApplication
		    if appID <> nil then
		      if CFPreferencesAppSynchronize(appID) then
		        mDirty = false
		        return true
		      end
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Value(key as String) As CFType
		  // Note: this function may actually return nil - that's if the key does not exist in the prefs
		  
		  #if targetMacOS
		    declare function CFPreferencesCopyAppValue lib CarbonLib (key as CFStringRef, applicationID as Ptr) as Ptr
		    
		    dim appID as Ptr = CurrentApplication
		    if appID <> nil then
		      dim p as Ptr = CFPreferencesCopyAppValue(key, appID)
		      if p <> nil then
		        dim theValue as CFType = CFType.NewObject(p, true, kCFPropertyListImmutable)
		        if not (theValue isA CFPropertyList) then
		          break // oops, this is unexpected
		        end if
		        return theValue
		      end if
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Value(key as String, assigns theValue as CFPropertyList)
		  #if targetMacOS
		    dim ref as Ptr
		    if theValue is nil then
		      // we'll pass nil so that the preference entry gets deleted
		    else
		      ref = theValue.Reference
		    end
		    declare sub CFPreferencesSetAppValue lib CarbonLib (key as CFStringRef, value as Ptr, applicationID as Ptr)
		    dim appID as Ptr = CurrentApplication
		    if appID <> nil then
		      CFPreferencesSetAppValue key, ref, appID
		      mDirty = true
		    end if
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Value(key as String, default as Variant) As Variant
		  // "smart" version that returns a fitting type as a variant or returns the default if no such key exists in the prefs
		  
		  dim v as CFType = Value(key)
		  if v = nil then
		    return default
		  end if
		  
		  return v.VariantValue
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mDirty
			End Get
		#tag EndGetter
		Shared Dirty As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shared mDirty As Boolean
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

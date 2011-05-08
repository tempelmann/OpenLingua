#tag Class
Class CFNotificationCenter
Inherits CFType
	#tag Event
		Function ClassID() As CFTypeID
		  return me.ClassID
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddObserver()
		  'void CFNotificationCenterAddObserver (
		  'CFNotificationCenterRef center,
		  'const void *observer,
		  'CFNotificationCallback callBack,
		  'CFStringRef name,
		  'const void *object,
		  'CFNotificationSuspensionBehavior suspensionBehavior
		  ');
		  
		  
		  'enum CFNotificationSuspensionBehavior {
		  'CFNotificationSuspensionBehaviorDrop = 1,
		  'CFNotificationSuspensionBehaviorCoalesce = 2,
		  'CFNotificationSuspensionBehaviorHold = 3,
		  'CFNotificationSuspensionBehaviorDeliverImmediately = 4
		  '};
		  'typedef enum CFNotificationSuspensionBehavior CFNotificationSuspensionBehavior;
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ClassID() As CFTypeID
		  #if targetMacOS
		    
		    declare function TypeID lib CarbonLib alias "CFNotificationCenterGetTypeID" () as UInt32
		    
		    static id as CFTypeID = CFTypeID(TypeID)
		    return id
		  #endif
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function LocalCenter() As CFNotificationCenter
		  #if targetMacOS
		    soft declare function CFNotificationCenterGetLocalCenter lib CarbonLib () as Ptr
		    try
		      dim theCenter as new CFNotificationCenter(CFNotificationCenterGetLocalCenter, false)
		      return theCenter
		    catch FunctionNotFoundException
		      // function requires 10.4 or later
		      return nil
		    end try
		  #endif
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Description"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="CFType"
		#tag EndViewProperty
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

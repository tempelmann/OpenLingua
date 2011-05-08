#tag Class
Class CFArray
Inherits CFType
Implements CFPropertyList
	#tag Event
		Function ClassID() As CFTypeID
		  return me.ClassID
		End Function
	#tag EndEvent

	#tag Event
		Function VariantValue() As Variant
		  dim up as Integer = me.Count - 1
		  
		  dim result() as Variant
		  
		  for i as Integer = 0 to up
		    result.Append me.Value(i).VariantValue
		  next
		  
		  return result
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		 Shared Function ClassID() As CFTypeID
		  #if targetMacOS
		    declare function TypeID lib CarbonLib alias "CFArrayGetTypeID" () as UInt32
		    static id as CFTypeID = CFTypeID(TypeID)
		    return id
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Clone() As CFArray
		  #if TargetMacOS
		    declare function CFArrayCreateCopy lib CarbonLib (allocator as Ptr, theArray as Ptr) as Ptr
		    
		    dim p as Ptr = CFArrayCreateCopy(nil, me.Reference)
		    // Note - since this obj (me) exists, the Clone shall also exist, even if the ref is nil.
		    // therefore, do not test for p=nil here
		    return new CFArray(p, true)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theList() as CFType)
		  #if targetMacOS
		    declare function CFArrayCreate lib CarbonLib (allocator as Ptr, values as Ptr, numValues as Integer, callbacks as Ptr) as Ptr
		    
		    if theList.Ubound >= 0 then
		      super.Constructor CFArrayCreate(nil, me.GetValuesAsCArray(theList), UBound(theList) + 1, me.DefaultCallbacks), true
		    else
		      // create empty array
		      super.Constructor CFArrayCreate(nil, nil, 0, me.DefaultCallbacks), true
		    end if
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DefaultCallbacks() As Ptr
		  const kCFTypeArrayCallBacks = "kCFTypeArrayCallBacks"
		  return CFBundle.CarbonFramework.DataPointerNotRetained(kCFTypeArrayCallBacks)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetValuesAsCArray(theList() as CFType) As MemoryBlock
		  if UBound(theList) = -1 then
		    return nil
		  end if
		  
		  const sizeOfPtr = 4
		  dim theValues as new MemoryBlock(sizeOfPtr*(1 + UBound(theList)))
		  dim offset as Integer = 0
		  for index as Integer = 0 to UBound(theList)
		    theValues.Ptr(offset) = theList(index).Reference
		    offset = offset + sizeOfPtr
		  next
		  return theValues
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(index as Integer) As CFType
		  #if TargetMacOS
		    declare function CFArrayGetCount lib CarbonLib (theArray as Ptr) as Integer
		    declare function CFArrayGetValueAtIndex lib CarbonLib (theArray as Ptr, idx as Integer) as Ptr
		    
		    if index < 0 or index >= me.Count() then
		      raise new OutOfBoundsException
		    end if
		    
		    return CFType.NewObject(CFArrayGetValueAtIndex(me.Reference, index), false, kCFPropertyListImmutable)
		  #endif
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if targetMacOS
			    declare function CFArrayGetCount lib CarbonLib (theArray as Ptr) as Integer
			    
			    dim p as Ptr = me.Reference
			    if p <> nil then
			      return CFArrayGetCount(p)
			    end if
			  #endif
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
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

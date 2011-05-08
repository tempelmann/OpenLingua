#tag Class
Protected Class GetVolParmsInfoBuffer
Inherits MemoryBlock
	#tag Method, Flags = &h0
		Sub Constructor()
		  #if TargetMacOS
		    Const sizeOfGetVolParmsInfoBuffer = 32
		    Super.MemoryBlock(sizeOfGetVolParmsInfoBuffer)
		  #endif
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = struct
		
		//Carbon
		struct GetVolParmsInfoBuffer {
		   short vMVersion;
		   long vMAttrib;
		   Handle vMLocalHand;
		   long vMServerAdr;
		   long vMVolumeGrade;
		   short vMForeignPrivID;
		   long vMExtendedAttributes;
		   void * vMDeviceID;
		   UniCharCount vMMaxNameLength;
		};
		
		
		//Classic
		struct GetVolParmsInfoBuffer {
		   short vMVersion;
		   long vMAttrib;
		   Handle vMLocalHand;
		   long vMServerAdr;
		   long vMVolumeGrade;
		   short vMForeignPrivID;
		};
	#tag EndNote


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
			Name="LittleEndian"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="MemoryBlock"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Size"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MemoryBlock"
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

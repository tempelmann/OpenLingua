#tag Class
Protected Class HIOParam
Inherits MemoryBlock
	#tag Method, Flags = &h0
		Sub Constructor()
		  Const sizeOfHIOParam = 50
		  
		  Super.MemoryBlock(sizeOfHIOParam)
		End Sub
	#tag EndMethod


	#tag Note, Name = struct
		struct HIOParam {
		   QElemPtr qLink;
		   short qType;
		   short ioTrap;
		   Ptr ioCmdAddr;
		   IOCompletionUPP ioCompletion;
		   volatile OSErr ioResult;
		   StringPtr ioNamePtr;
		   short ioVRefNum;
		   short ioRefNum;
		   SInt8 ioVersNum;
		   SInt8 ioPermssn;
		   Ptr ioMisc;
		   Ptr ioBuffer;
		   long ioReqCount;
		   long ioActCount;
		   short ioPosMode;
		   long ioPosOffset;
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

#tag Class
Protected Class FSVolumeInfo
Inherits MemoryBlock
	#tag Method, Flags = &h0
		Sub Constructor()
		  Const sizeOfFSVolumeInfo = 126
		  
		  Super.MemoryBlock sizeOfFSVolumeInfo
		End Sub
	#tag EndMethod


	#tag Note, Name = struct
		struct FSVolumeInfo {
		   UTCDateTime createDate;
		   UTCDateTime modifyDate;
		   UTCDateTime backupDate;
		   UTCDateTime checkedDate;
		   UInt32 fileCount;
		   UInt32 folderCount; 40
		   UInt64 totalBytes;
		   UInt64 freeBytes;
		   UInt32 blockSize;
		   UInt32 totalBlocks;
		   UInt32 freeBlocks;
		   UInt32 nextAllocation;
		   UInt32 rsrcClumpSize;
		   UInt32 dataClumpSize;
		   UInt32 nextCatalogID; 84
		   UInt8 finderInfo[32];
		   UInt16 flags;
		   UInt16 filesystemID;
		   UInt16 signature;
		   UInt16 driveNumber;
		   short driverRefNum; 126
		};
		
		
		struct UTCDateTime {
		  UInt16              highSeconds;
		  UInt32              lowSeconds;
		  UInt16              fraction;
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

#tag Class
Protected Class SearchParams
Inherits MemoryBlock
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.Constructor(24)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getDate(ofs as Integer, mask as Integer, isFrom as Boolean) As Date
		  if (me.UInt32Value(4) and mask) <> 0 then
		    dim mb as MemoryBlock
		    if isFrom then
		      mb = mInfo1
		    else
		      mb = mInfo2
		    end if
		    if mb <> nil then
		      return getDate (ofs, mb, isFrom)
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getDate(ofs as Integer, info as MemoryBlock, isFrom as Boolean) As Date
		  dim v as UInt64 = Bitwise.ShiftLeft(info.UInt16Value(ofs),32) + info.UInt32Value(ofs+2)
		  dim d as Date
		  if isFrom and v = 0 then
		    // d = nil
		  elseif not isFrom and v = &hFFFFFFFFFFFFFFFF then
		    // d = nil
		  else
		    d = new Date
		    d.TotalSeconds = v
		  end
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getOSType(ofs as Integer) As UInt32
		  if EnableSearchOnFInfo and mInfo2.UInt32Value(72+ofs) = &hFFFFFFFF then
		    return mInfo1.UInt32Value(72+ofs)
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getUInt64(ofs as Integer, mask as Integer, isLower as Boolean) As UInt64
		  if (me.UInt32Value(4) and mask) <> 0 then
		    dim mb as MemoryBlock
		    if isLower then
		      mb = mInfo1
		    else
		      mb = mInfo2
		    end if
		    if mb <> nil then
		      return mb.UInt64Value (ofs)
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasSizeRange() As Boolean
		  dim mask as UInt32 = Pow(2,5)
		  return (me.UInt32Value(4) and mask) <> 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub requiresInfoBlocks()
		  if mInfo1 = nil then
		    mInfo1 = new MemoryBlock(144) // FSCatalogInfo
		    mInfo2 = new MemoryBlock(144) // FSCatalogInfo
		    me.Ptr(16) = mInfo1
		    me.Ptr(20) = mInfo2
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCreationDateRange(lower as Date, upper as Date)
		  setDateRange 16+8*0, Pow(2,9), lower, upper
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setDate(ofs as Integer, info as MemoryBlock, d as Date, isFrom as Boolean)
		  dim v as UInt64
		  if d = nil then
		    if isFrom then
		      v = 0
		    else
		      v = &hFFFFFFFFFFFFFFFF
		    end
		  else
		    v = d.TotalSeconds - d.GMTOffset * 3600
		  end
		  if isFrom then
		    info.UInt16Value(ofs+6) = 0
		  else
		    v = v - 1
		    info.UInt16Value(ofs+6) = &hFFFF
		  end
		  info.UInt16Value(ofs) = Bitwise.ShiftRight(v, 32)
		  info.UInt32Value(ofs+2) = v
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setDateRange(ofs as Integer, mask as Integer, from as Date, upto as Date)
		  requiresInfoBlocks()
		  
		  if from = nil and upto = nil then
		    // disable
		    me.UInt32Value(4) = me.UInt32Value(4) and (not mask)
		    mInfo1.UInt64Value(ofs) = 0
		    mInfo2.UInt64Value(ofs) = 0
		  else
		    me.UInt32Value(4) = me.UInt32Value(4) or mask
		    setDate ofs, mInfo1, from, true
		    setDate ofs, mInfo2, upto, false
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetGID(id as UInt32)
		  setUInt32Range 56+4, &h40000, id, &hFFFFFFFF
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetModificationDateRange(lower as Date, upper as Date)
		  setDateRange 16+8*1, Pow(2,10), lower, upper
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetName(name as String, partial as Boolean)
		  if name.LenB > 0 then
		    mNameBuf = name.ConvertEncoding(hfsEncoding)
		    me.UInt32Value(8) = mNameBuf.Size \ 2
		    me.Ptr(12) = mNameBuf
		    dim flag as UInt32
		    if partial then
		      flag = 1 // set bit 0 (partial name)
		    else
		      flag = 2 // set bit 1 (entire name)
		    end
		    me.UInt32Value(4) = me.UInt32Value(4) or flag
		  else
		    mNameBuf = nil
		    me.UInt32Value(8) = 0
		    me.Ptr(12) = nil
		    me.UInt32Value(4) = me.UInt32Value(4) and &hFFFFFFFC // clear bit 0 and 1
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setOSType(ofs as Integer, value as UInt32, clear as Boolean)
		  requiresInfoBlocks()
		  
		  EnableSearchOnFInfo = true
		  
		  if not clear then
		    mInfo1.UInt32Value(72+ofs) = value
		    mInfo2.UInt32Value(72+ofs) = &hFFFFFFFF
		  else
		    mInfo1.UInt32Value(72+ofs) = 0
		    mInfo2.UInt32Value(72+ofs) = 0
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetSizeRange(lower as UInt64, upper as UInt64)
		  setUInt64Range 104, Pow(2,5), lower, upper
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetUID(id as UInt32)
		  setUInt32Range 56+0, &h40000, id, &hFFFFFFFF
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setUInt32Range(ofs as Integer, mask as Integer, from as UInt32, upto as UInt32)
		  requiresInfoBlocks()
		  
		  if from > upto then
		    // disable
		    me.UInt32Value(4) = me.UInt32Value(4) and (not mask)
		    mInfo1.UInt32Value(ofs) = 0
		    mInfo2.UInt32Value(ofs) = 0
		  else
		    me.UInt32Value(4) = me.UInt32Value(4) or mask
		    mInfo1.UInt32Value(ofs) = from
		    mInfo2.UInt32Value(ofs) = upto
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setUInt64Range(ofs as Integer, mask as Integer, from as UInt64, upto as UInt64)
		  requiresInfoBlocks()
		  
		  if from > upto then
		    // disable
		    me.UInt32Value(4) = me.UInt32Value(4) and (not mask)
		    mInfo1.UInt64Value(ofs) = 0
		    mInfo2.UInt64Value(ofs) = 0
		  else
		    me.UInt32Value(4) = me.UInt32Value(4) or mask
		    mInfo1.UInt64Value(ofs) = from
		    mInfo2.UInt64Value(ofs) = upto
		  end if
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return getDate(16+8*0, Pow(2,9), true)
			End Get
		#tag EndGetter
		CreationDateLower As Date
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return getDate(16+8*0, Pow(2,9), false)
			End Get
		#tag EndGetter
		CreationDateUpper As Date
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return getOSType(4)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  setOSType 4, value, false
			End Set
		#tag EndSetter
		CreatorCode As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return (me.UInt32Value(4) and 4) <> 0 and mInfo1 <> nil
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value then
			    requiresInfoBlocks()
			    me.UInt32Value(4) = me.UInt32Value(4) or 4
			  else
			    me.UInt32Value(4) = me.UInt32Value(4) and (not 4)
			  end
			End Set
		#tag EndSetter
		EnableSearchOnDirMask As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return (me.UInt32Value(4) and 8) <> 0 and mInfo1 <> nil
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value then
			    requiresInfoBlocks()
			    me.UInt32Value(4) = me.UInt32Value(4) or 8 // set bit 3 (Finder Info)
			  else
			    me.UInt32Value(4) = me.UInt32Value(4) and (not 8)
			  end
			End Set
		#tag EndSetter
		EnableSearchOnFInfo As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return getOSType(0)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  setOSType 0, value, false
			End Set
		#tag EndSetter
		FileTypeCode As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if EnableSearchOnFInfo then
			    const ofs = 80 // 72+8
			    return (mInfo1.UInt16Value(ofs) and mInfo2.UInt16Value(ofs) and &h2000) <> 0
			  end if
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  EnableSearchOnFInfo = true
			  
			  const mask = &h8000 // kIsAlias
			  const ofs = 80 // 72+8
			  
			  dim v as UInt16
			  if value then v = mask
			  
			  mInfo1.UInt16Value(ofs) = (mInfo1.UInt16Value(ofs) and (not mask)) or v
			  mInfo2.UInt16Value(ofs) = mInfo2.UInt16Value(ofs) or mask
			  
			End Set
		#tag EndSetter
		FindAlias As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if EnableSearchOnDirMask then
			    return (mInfo1.UInt16Value(0) and mInfo2.UInt16Value(0) and 16) <> 0
			  end if
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if not HasSizeRange or value = false then
			    EnableSearchOnDirMask = true
			    dim v as UInt16
			    if value then v = 16
			    mInfo1.UInt16Value(0) = (mInfo1.UInt16Value(0) and (not 16)) or v
			    mInfo2.UInt16Value(0) = mInfo2.UInt16Value(0) or 16 // mask
			  end if
			End Set
		#tag EndSetter
		FindFolder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if me.Ptr(12) <> nil then
			    return (me.UInt32Value(4) and 1) <> 0 // check bit 0 (partial name)
			  end
			End Get
		#tag EndGetter
		IsPartialName As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mInfo1 As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInfo2 As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNameBuf As MemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return getDate(16+8*1, Pow(2,10), true)
			End Get
		#tag EndGetter
		ModificationDateLower As Date
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return getDate(16+8*1, Pow(2,10), false)
			End Get
		#tag EndGetter
		ModificationDateUpper As Date
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if me.Ptr(12) <> nil then
			    return me.Ptr(12).StringValue(0, me.UInt32Value(8)*2).DefineEncoding(Encodings.UTF16BE)
			  end if
			End Get
		#tag EndGetter
		Name As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return (me.UInt32Value(4) and &h4000) <> 0
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value then
			    me.UInt32Value(4) = me.UInt32Value(4) or &h4000
			  else
			    me.UInt32Value(4) = me.UInt32Value(4) and (not &h4000)
			  end
			End Set
		#tag EndSetter
		NegatedSearch As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return getUInt64 (104, Pow(2,5), true)
			End Get
		#tag EndGetter
		SizeLower As UInt64
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return getUInt64 (104, Pow(2,5), false)
			End Get
		#tag EndGetter
		SizeUpper As UInt64
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return me.Long(0)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  me.Long(0) = value
			End Set
		#tag EndSetter
		Timeout As Integer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="EnableSearchOnDirMask"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnableSearchOnFInfo"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FindAlias"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FindFolder"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsPartialName"
			Group="Behavior"
			InitialValue="0"
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
			Name="NegatedSearch"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="Timeout"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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

#tag Class
Protected Class LinguaRecordSet
	#tag Method, Flags = &h0
		Sub Add(rec as LinguaFileRecord)
		  if mDict.HasKey (rec.Key) then
		    // we have multiple items with this key
		    mDict.Value (rec.Key) = -1 // this indicates a key which has multiple items
		  else
		    mDict.Value (rec.Key) = rec
		  end
		  
		  mList.Append rec
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AllItems() As LinguaFileRecord()
		  return mList
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(owner as LinguaTranslationPool)
		  mDict = new Dictionary
		  if owner <> nil then
		    mOwnerRef = new WeakRef (owner)
		  else
		    break
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(owner as LinguaTranslationPool, ident as String, orig as String, trans as String, platform as Integer)
		  // Creates a temporary entry!
		  me.Constructor (owner)
		  me.Add new LinguaFileRecord("idnt", ident)
		  me.Add new LinguaFileRecord("oval", orig)
		  me.Add new LinguaFileRecord("tval", trans)
		  me.Add new LinguaFileRecord("plat", platform)
		  mTemporary = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Identifier() As String
		  return me.Value("idnt")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Original() As String
		  return me.Value("oval")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Owner() As LinguaTranslationPool
		  return LinguaTranslationPool(mOwnerRef.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Platform() As Integer
		  return me.Value("plat")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetTranslation(txt as String)
		  dim rec as LinguaFileRecord
		  rec = mDict.Lookup ("tval", nil)
		  if rec = nil then
		    // this is wrong - we're asked to update a record that has no translation field
		    break
		  else
		    rec.Value = txt
		    me.IsDirty = true
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Translation() As String
		  return me.Value("tval")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(key as String) As Variant
		  dim rec as LinguaFileRecord
		  rec = mDict.Lookup (key, nil)
		  if rec <> nil then
		    return rec.Value
		  end
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Written 2009, 2011 by Thomas Tempelmann
		For the Public Domain
		Project Home: https://github.com/tempelmann/OpenLingua
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mDirty
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value <> mDirty then
			    mDirty = value
			    if value then
			      if mTemporary then
			        Owner.Add me
			        mTemporary = false
			      end
			      Owner.IsDirty = true
			    else
			      // we do not support resetting the owner here as we can only do that
			      // right if we'd check all other of its children as well
			    end if
			  end if
			End Set
		#tag EndSetter
		IsDirty As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		#tag Note
			key: Key from LinguaFileRecord
			value: LinguaFileRecord
		#tag EndNote
		Private mDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDirty As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mList() As LinguaFileRecord
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			LinguaTranslationPool
		#tag EndNote
		Private mOwnerRef As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTemporary As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Used for UndoEngine's Backup and RestoreFromBackup
		#tag EndNote
		#tag Getter
			Get
			  return me.Translation : (me.IsDirty : Owner.IsDirty)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim p as Pair = value
			  me.SetTranslation p.Left
			  me.IsDirty = Pair(p.Right).Left
			  Owner.IsDirty = Pair(p.Right).Right
			End Set
		#tag EndSetter
		State As Variant
	#tag EndComputedProperty


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

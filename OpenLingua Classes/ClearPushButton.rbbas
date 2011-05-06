#tag Class
Protected Class ClearPushButton
Inherits Canvas
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  if me.Enabled and me.Visible then
		    updateDrawState x, y
		    return true
		  end if
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  updateDrawState x, y
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  if me.Enabled then
		    mDrawAttentive = true
		    self.Refresh
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  mDrawAttentive = false
		  self.Refresh
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  if withInMe (x,y) then
		    RaiseEvent Action
		  end if
		  
		  mDrawAttentive = false
		  mDrawPushed = false
		  self.Refresh
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics)
		  redraw g
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub redraw(g as Graphics)
		  if me.Visible and me.Enabled then
		    const circleRadius = 6
		    const crossRadius = 3
		    
		    dim cx as Integer = me.Width \ 2
		    dim cy as Integer = me.Height \ 2
		    
		    // draw circle
		    if mDrawAttentive or mDrawPushed then
		      g.ForeColor = &c888888
		    else
		      g.ForeColor = &ccccccc
		    end
		    g.FillOval cx - circleRadius, cy - circleRadius, circleRadius*2+1, circleRadius*2+1
		    
		    // draw X in center
		    if mDrawPushed then
		      g.ForeColor = &c000000
		    elseif mDrawAttentive then
		      g.ForeColor = &cffffff
		    else
		      g.ForeColor = &c888888
		    end if
		    g.DrawLine cx - crossRadius, cy - crossRadius, cx + crossRadius, cy + crossRadius
		    g.DrawLine cx + crossRadius, cy - crossRadius, cx - crossRadius, cy + crossRadius
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub updateDrawState(x as Integer, y as Integer)
		  dim inside as Boolean = withInMe (x,y)
		  if mDrawPushed <> inside then
		    mDrawPushed = inside
		    self.Refresh
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function withInMe(x as Integer, y as Integer) As Boolean
		  return x >= 0 and x < me.Width and y >= 0 and y < me.Height
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Action()
	#tag EndHook


	#tag Property, Flags = &h21
		Private mDrawAttentive As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDrawPushed As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Visible=true
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Visible=true
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

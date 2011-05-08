#tag Menu
Begin Menu MenuBar1
   Begin MenuItem FileMenu
      SpecialMenu = 0
      Text = "&File"
      Index = -2147483648
      AutoEnable = True
      Begin MenuItem FileOpen
         SpecialMenu = 0
         Text = "Open…"
         Index = -2147483648
         ShortcutKey = "O"
         Shortcut = "Cmd+O"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem FileClose
         SpecialMenu = 0
         Text = "Close"
         Index = -2147483648
         ShortcutKey = "W"
         Shortcut = "Cmd+W"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem UntitledSeparator2
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem FileSave
         SpecialMenu = 0
         Text = "Save"
         Index = -2147483648
         ShortcutKey = "S"
         Shortcut = "Cmd+S"
         MenuModifier = True
         AutoEnable = False
      End
      Begin MenuItem UntitledSeparator6
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem FileImport
         SpecialMenu = 0
         Text = "Import"
         Index = -2147483648
         AutoEnable = False
         SubMenu = True
         Begin MenuItem ImportLocalizablestringsfile
            SpecialMenu = 0
            Text = ""Localizable.strings" file..."
            Index = -2147483648
            AutoEnable = False
         End
      End
      Begin MenuItem FileExport
         SpecialMenu = 0
         Text = "Export"
         Index = -2147483648
         AutoEnable = True
         SubMenu = True
         Begin MenuItem ExportTabDelimited
            SpecialMenu = 0
            Text = "Tab Delimited…"
            Index = -2147483648
            AutoEnable = False
         End
      End
      Begin MenuItem UntitledSeparator0
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem FileRevealonDisk
         SpecialMenu = 0
         Text = "Reveal on Disk"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem UntitledSeparator
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin QuitMenuItem FileQuit
         SpecialMenu = 0
         Text = "#App.kFileQuit"
         Index = -2147483648
         ShortcutKey = "#App.kFileQuitShortcut"
         Shortcut = "#App.kFileQuitShortcut"
         AutoEnable = True
      End
   End
   Begin MenuItem EditMenu
      SpecialMenu = 0
      Text = "&Edit"
      Index = -2147483648
      AutoEnable = True
      Begin MenuItem EditUndo
         SpecialMenu = 0
         Text = "&Undo"
         Index = -2147483648
         ShortcutKey = "Z"
         Shortcut = "Cmd+Z"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem EditRedo
         SpecialMenu = 0
         Text = "Redo"
         Index = -2147483648
         ShortcutKey = "Z"
         Shortcut = "Cmd+Shift+Z"
         MenuModifier = True
         AltMenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem UntitledMenu1
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem EditCut
         SpecialMenu = 0
         Text = "Cu&t"
         Index = -2147483648
         ShortcutKey = "X"
         Shortcut = "Cmd+X"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem EditCopy
         SpecialMenu = 0
         Text = "&Copy"
         Index = -2147483648
         ShortcutKey = "C"
         Shortcut = "Cmd+C"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem EditPaste
         SpecialMenu = 0
         Text = "&Paste"
         Index = -2147483648
         ShortcutKey = "V"
         Shortcut = "Cmd+V"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem EditClear
         SpecialMenu = 0
         Text = "#App.kEditClear"
         Index = -2147483648
         AutoEnable = False
      End
      Begin MenuItem UntitledMenu0
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem EditSelectAll
         SpecialMenu = 0
         Text = "Select &All"
         Index = -2147483648
         ShortcutKey = "A"
         Shortcut = "Cmd+A"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem UntitledSeparator4
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem EditMoveToPrevious
         SpecialMenu = 0
         Text = "Move To Previous"
         Index = -2147483648
         ShortcutKey = "["
         Shortcut = "Cmd+["
         MenuModifier = True
         AutoEnable = False
      End
      Begin MenuItem EditMoveToNext
         SpecialMenu = 0
         Text = "Move To Next"
         Index = -2147483648
         ShortcutKey = "]"
         Shortcut = "Cmd+]"
         MenuModifier = True
         AutoEnable = False
      End
      Begin MenuItem UntitledSeparator5
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem EditGoToFilter
         SpecialMenu = 0
         Text = "Go To Filter"
         Index = -2147483648
         ShortcutKey = "F"
         Shortcut = "Cmd+F"
         MenuModifier = True
         AutoEnable = True
      End
   End
   Begin MenuItem ViewMenu
      SpecialMenu = 0
      Text = "View"
      Index = -2147483648
      AutoEnable = True
      Begin MenuItem ViewHideEmpties
         SpecialMenu = 0
         Text = "Hide Empties"
         Index = -2147483648
         ShortcutKey = "J"
         Shortcut = "Cmd+J"
         MenuModifier = True
         AutoEnable = False
      End
      Begin MenuItem ViewOnlyUntranslated
         SpecialMenu = 0
         Text = "Only Untranslated"
         Index = -2147483648
         ShortcutKey = "K"
         Shortcut = "Cmd+K"
         MenuModifier = True
         AutoEnable = False
      End
      Begin MenuItem UntitledSeparator3
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem ViewList
         SpecialMenu = 0
         Text = "List…"
         Index = -2147483648
         AutoEnable = False
      End
      Begin MenuItem ViewNames
         SpecialMenu = 0
         Text = "  Names"
         Index = -2147483648
         ShortcutKey = "1"
         Shortcut = "Cmd+1"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem ViewOriginals
         SpecialMenu = 0
         Text = "  Originals"
         Index = -2147483648
         ShortcutKey = "2"
         Shortcut = "Cmd+2"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem ViewTranslations
         SpecialMenu = 0
         Text = "  Translations"
         Index = -2147483648
         ShortcutKey = "3"
         Shortcut = "Cmd+3"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem ViewSmart
         SpecialMenu = 0
         Text = "  Smart"
         Index = -2147483648
         ShortcutKey = "4"
         Shortcut = "Cmd+4"
         MenuModifier = True
         AutoEnable = True
      End
      Begin MenuItem UntitledSeparator1
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
      End
      Begin MenuItem ViewWrapLines
         SpecialMenu = 0
         Text = "Wrap Lines"
         Index = -2147483648
         ShortcutKey = "L"
         Shortcut = "Cmd+L"
         MenuModifier = True
         AutoEnable = False
      End
   End
End
#tag EndMenu

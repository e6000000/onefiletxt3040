Func Events_Handle($msgID)
    Switch $msgID
        Case $idButton1
            Settings_Load() ; cross-ref
        Case $GUI_EVENT_CLOSE
            Exit
        ; ... 45 Cases ? hier einfügen (suche "Case " in Main)






    EndSwitch
EndFunc
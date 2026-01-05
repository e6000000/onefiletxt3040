Global $gidBtnMod0
Global $gidBtnMod1
Global $gidEditIdx
Global $gidBtnINI

Func CreateMainGUI()
    $ghGUI = GUICreate("OneFileTxt v" & $version, 620, 600)

    $gidBtnINI = GUICtrlCreateButton("INI", 10, 10, 80, 30)

    GUICtrlCreateLabel("extIncl", 10, 50, 60, 20)
    GUICtrlCreateInput(Settings_Get("ExtIncl"), 70, 48, 200, 22)

    GUICtrlCreateLabel("extExcl", 280, 50, 60, 20)
    GUICtrlCreateInput(Settings_Get("ExtExcl"), 340, 48, 200, 22)

    GUICtrlCreateLabel("extUse", 10, 80, 60, 20)
    GUICtrlCreateInput(Settings_Get("ExtUse"), 70, 78, 470, 22)

    GUICtrlCreateLabel("Index", 10, 110, 50, 20)
    $gidEditIdx = GUICtrlCreateInput(Settings_Get("Index"), 60, 108, 80, 25)
    GUICtrlCreateButton("+1", 145, 108, 40, 25)

    Local $y = 140
    For $i = 0 To 2
        If $gaSetActive[$i] Then
            GUICtrlCreateLabel("Set" & $i, 10, $y, 40, 20)
            $y += 25

            GUICtrlCreateButton("Parent" & $i, 10, $y, 100, 25)
            $y += 30

            GUICtrlCreateButton("SubDir" & $i, 10, $y, 100, 25)
            $y += 30

            GUICtrlCreateButton("File" & $i, 10, $y, 100, 25)
            $y += 40
        EndIf
    Next

    $gidBtnMod0 = GUICtrlCreateButton("MOD0 Pack", 10, $y, 180, 40)
    $gidBtnMod1 = GUICtrlCreateButton("MOD1 Unpack", 200, $y, 180, 40)
    GUICtrlCreateButton("MOD2 Save", 390, $y, 180, 40)

    GUICtrlCreateButton("CLOSE", 10, $y + 50, 560, 40)

    GUISetState(@SW_SHOW, $ghGUI)
EndFunc

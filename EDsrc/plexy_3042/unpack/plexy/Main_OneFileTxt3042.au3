Global $version = 3042

#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>

#include "SettingsManager.au3"
#include "GuiCore.au3"
#include "FileFolderPack.au3"

Global $ghGUI
Global $gaSetActive[3] = [1, 1, 0]

Init()
While 1
    GameLoop()
    Sleep(11)
WEnd

Func Init()
    Settings_Init(@ScriptDir & "\config.ini")
    CreateMainGUI()
EndFunc

Func GameLoop()
    Local $iMsg = GUIGetMsg()
    Switch $iMsg
        Case $GUI_EVENT_CLOSE
            Close()
        Case $gidBtnMod0
            FileFolderPack_Mod0()
        Case $gidBtnMod1
            FileFolderPack_Mod1()
    EndSwitch
EndFunc

Func Close()
    Settings_SaveAll()
    GUIDelete($ghGUI)
    Exit
EndFunc

Global $version = 3044

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
    Settings_LoadPreset("Session")
    CreateMainGUI()
EndFunc

Func GameLoop()
    GuiCore_EventLoop()
EndFunc

Func Close()
    Settings_SaveAll()
    GUIDelete($ghGUI)
    Exit
EndFunc




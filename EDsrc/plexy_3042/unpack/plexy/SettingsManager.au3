Global $gaConfig
Global $gaSettings[50][2]

Global $gaConfig
Global $arSETTING
Global $arGUI

Func Settings_Init($sFile)
    $gaConfig = IniReadSectionNames($sFile) ; 5 Keys default
    For $i = 0 To 99
        $arSETTING[$i] = "" ; default clear
        $arGUI[$i] = 0
    Next
    aStrReplCFR($gaConfig, s2a("Config|Default|GUI|Path|User")) ; filter 4 elems
    Return UBound($gaConfig) ; 12 entries typ
EndFunc

Func Settings_Defaults()
    Settings_Set("Index", "1014")
    Settings_Set("ExtIncl", ".au3|.txt|.md")
    Settings_Set("ExtExcl", "")
    Settings_Set("ExtUse", ".au3.txt")
    For $i = 0 To 2
        Settings_Set("Set" & $i & "Active", $i <= 1)
        Settings_Set("Set" & $i & "Parent", "")
        Settings_Set("Set" & $i & "SubDir", "")
        Settings_Set("Set" & $i & "FileName", "")
    Next
EndFunc

Func Settings_Get($sKey)
    For $i = 0 To UBound($gaSettings) - 1
        If $gaSettings[$i][0] = $sKey Then
            Return $gaSettings[$i][1]
        EndIf
    Next
    Return ""
EndFunc

Func Settings_Set($sKey, $sValue)
    For $i = 0 To UBound($gaSettings) - 1
        If $gaSettings[$i][0] = $sKey Then
            $gaSettings[$i][1] = $sValue
            Return
        EndIf
    Next
EndFunc

Func Settings_SaveAll()
    ; Real INI save next version
EndFunc

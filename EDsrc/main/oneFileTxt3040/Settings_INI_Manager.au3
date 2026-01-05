;///////////////////////////////////////////////////////////////////////////////
; MODULE 1: Settings_INI_Manager.au3
; Version: 3000
; Purpose: Reusable INI file and preset management module
; Features:
;   - Load/Save settings from/to INI file
;   - Preset management (Save As, Load, List)
;   - Settings array handling
;   - INI file editing
;///////////////////////////////////////////////////////////////////////////////

#include-once
#include <MsgBoxConstants.au3>
#include <Array.au3>

;///////////////////////////////////////////////////////////////////////////////
; INITIALIZATION FUNCTION - Call this first!
;///////////////////////////////////////////////////////////////////////////////

Func SettingsINI_Init($sIniFilePath)
	; Initialize the INI Manager module
	; Parameters:
	;   $sIniFilePath - Full path to the INI file
	; Returns:
	;   Array with module configuration

	Local $aConfig[4]
	$aConfig[0] = "SettingsINI_Config"
	$aConfig[1] = $sIniFilePath
	$aConfig[2] = "Session"            ; Default session section name
	$aConfig[3] = "Metadata"           ; Metadata section name

	; Create INI file if it doesn't exist
	If Not FileExists($sIniFilePath) Then
		IniWrite($sIniFilePath, "Session", "Initialized", "1")
		IniWrite($sIniFilePath, "Metadata", "NextPresetNumber", "1")
	EndIf

	Return $aConfig
EndFunc   ;==>SettingsINI_Init

;///////////////////////////////////////////////////////////////////////////////
; SETTINGS ARRAY MANAGEMENT
;///////////////////////////////////////////////////////////////////////////////
Func settingsArrayTest()
	Local $q, $u
	Local $aSettings[33][2] = [[1, 2], [5, 6]]
	; all time autoit create UBOUND at [0] ?
	; exit
	For $u = 0 To UBound($aSettings) - 1
		$aSettings[$u][0] = $u
		$aSettings[$u][1] = $u + 100
	Next
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & _
			') : all time autoit create UBOUND at $aSettings[0],[0]  0,1  1,0   ?   = ' & _
			@CRLF & $aSettings[0][0] & @CRLF & $aSettings[0][1] & @CRLF & $aSettings[1][0] & @CRLF & _
			'>Error code: ' & @error & @CRLF) ;### Debug Console
	_ArrayDisplay($aSettings, '$aSettings')
	Exit
EndFunc   ;==>settingsArrayTest

Func SettingsINI_CreateArray()
	; Create empty settings array with NEW field names
	; Returns: Settings array with default structure

	Local $aSettings[30][2]

	$aSettings[0][0] = "SettingsArray"
	$aSettings[0][1] = 20    ; Count of settings

	; Module ON/OFF Switches (3x)
	$aSettings[1][0] = "Set0Active"
	$aSettings[1][1] = "1"

	$aSettings[2][0] = "Set1Active"
	$aSettings[2][1] = "1"

	$aSettings[3][0] = "Set2Active"
	$aSettings[3][1] = "0"

	; Set0 - MOD0 Pack (3 fields)
	$aSettings[4][0] = "Set0_Folder"
	$aSettings[4][1] = ""

	$aSettings[5][0] = "Set0_SubDir"
	$aSettings[5][1] = ""

	$aSettings[6][0] = "Set0_File"
	$aSettings[6][1] = ""

	; Set1 - MOD1 Unpack (3 fields)
	$aSettings[7][0] = "Set1_Folder"
	$aSettings[7][1] = ""

	$aSettings[8][0] = "Set1_SubDir"
	$aSettings[8][1] = ""

	$aSettings[9][0] = "Set1_File"
	$aSettings[9][1] = ""

	; Set2 - MOD2-UNI Universal (3 fields)
	$aSettings[10][0] = "Set2_Folder"
	$aSettings[10][1] = ""

	$aSettings[11][0] = "Set2_SubDir"
	$aSettings[11][1] = ""

	$aSettings[12][0] = "Set2_File"
	$aSettings[12][1] = ""

	; Extensions (3x)
	$aSettings[13][0] = "ExtInclude"
	$aSettings[13][1] = ""

	$aSettings[14][0] = "ExtExclude"
	$aSettings[14][1] = ""

	$aSettings[15][0] = "ExtFilter"
	$aSettings[15][1] = ""

	; Index (1x)
	$aSettings[16][0] = "Index"
	$aSettings[16][1] = "1001"

	; Other
	$aSettings[17][0] = "Mode"
	$aSettings[17][1] = "0"

	$aSettings[18][0] = "AddMarkerComments"
	$aSettings[18][1] = "0"

	$aSettings[19][0] = "MarkerUseTyp1json"
	$aSettings[19][1] = "0"

	Return $aSettings
EndFunc   ;==>SettingsINI_CreateArray

Func SettingsINI_GetValue($aSettings, $sKey)
	; Get value from settings array
	; Parameters:
	;   $aSettings - Settings array
	;   $sKey - Key name (e.g. "InParent")
	; Returns: Value or empty string if not found

	If Not IsArray($aSettings) Then Return ""

	For $i = 1 To UBound($aSettings) - 1
		If $aSettings[$i][0] = $sKey Then
			Return $aSettings[$i][1]
		EndIf
	Next

	Return ""
EndFunc   ;==>SettingsINI_GetValue

Func SettingsINI_SetValue(ByRef $aSettings, $sKey, $vValue)
	; Set value in settings array
	; Parameters:
	;   $aSettings - Settings array (ByRef)
	;   $sKey - Key name
	;   $vValue - Value to set
	; Returns: True on success, False on failure

	If Not IsArray($aSettings) Then Return False

	For $i = 1 To UBound($aSettings) - 1
		If $aSettings[$i][0] = $sKey Then
			$aSettings[$i][1] = $vValue
			Return True
		EndIf
	Next

	Return False
EndFunc   ;==>SettingsINI_SetValue

;///////////////////////////////////////////////////////////////////////////////
; INI FILE OPERATIONS
;///////////////////////////////////////////////////////////////////////////////

Func SettingsINI_LoadFromINI($aConfig, $sSectionName = "")
	; Load settings from INI file into array with NEW field names
	; Parameters:
	;   $aConfig - Module config array (from SettingsINI_Init)
	;   $sSectionName - Section name (default: "Session")
	; Returns: Settings array

	Local $sIniPath = $aConfig[1]
	If $sSectionName = "" Then $sSectionName = $aConfig[2]

	Local $aSettings = SettingsINI_CreateArray()

	; Module ON/OFF Switches (3x)
	SettingsINI_SetValue($aSettings, "Set0Active", IniRead($sIniPath, $sSectionName, "Set0Active", "1"))
	SettingsINI_SetValue($aSettings, "Set1Active", IniRead($sIniPath, $sSectionName, "Set1Active", "1"))
	SettingsINI_SetValue($aSettings, "Set2Active", IniRead($sIniPath, $sSectionName, "Set2Active", "0"))

	; Set0 - MOD0 Pack (3 fields)
	SettingsINI_SetValue($aSettings, "Set0_Folder", IniRead($sIniPath, $sSectionName, "Set0_Folder", ""))
	SettingsINI_SetValue($aSettings, "Set0_SubDir", IniRead($sIniPath, $sSectionName, "Set0_SubDir", ""))
	SettingsINI_SetValue($aSettings, "Set0_File", IniRead($sIniPath, $sSectionName, "Set0_File", ""))

	; Set1 - MOD1 Unpack (3 fields)
	SettingsINI_SetValue($aSettings, "Set1_Folder", IniRead($sIniPath, $sSectionName, "Set1_Folder", ""))
	SettingsINI_SetValue($aSettings, "Set1_SubDir", IniRead($sIniPath, $sSectionName, "Set1_SubDir", ""))
	SettingsINI_SetValue($aSettings, "Set1_File", IniRead($sIniPath, $sSectionName, "Set1_File", ""))

	; Set2 - MOD2-UNI Universal (3 fields)
	SettingsINI_SetValue($aSettings, "Set2_Folder", IniRead($sIniPath, $sSectionName, "Set2_Folder", ""))
	SettingsINI_SetValue($aSettings, "Set2_SubDir", IniRead($sIniPath, $sSectionName, "Set2_SubDir", ""))
	SettingsINI_SetValue($aSettings, "Set2_File", IniRead($sIniPath, $sSectionName, "Set2_File", ""))

	; Extensions (3x)
	SettingsINI_SetValue($aSettings, "ExtInclude", IniRead($sIniPath, $sSectionName, "ExtInclude", ""))
	SettingsINI_SetValue($aSettings, "ExtExclude", IniRead($sIniPath, $sSectionName, "ExtExclude", ""))
	SettingsINI_SetValue($aSettings, "ExtFilter", IniRead($sIniPath, $sSectionName, "ExtFilter", ""))

	; Index (1x)
	SettingsINI_SetValue($aSettings, "Index", IniRead($sIniPath, $sSectionName, "Index", "1000"))

	; Other
	SettingsINI_SetValue($aSettings, "Mode", IniRead($sIniPath, $sSectionName, "Mode", "0"))
	SettingsINI_SetValue($aSettings, "AddMarkerComments", IniRead($sIniPath, $sSectionName, "AddMarkerComments", "0"))
	SettingsINI_SetValue($aSettings, "MarkerUseTyp1json", IniRead($sIniPath, $sSectionName, "MarkerUseTyp1json", "0"))

	Return $aSettings
EndFunc   ;==>SettingsINI_LoadFromINI

Func SettingsINI_SaveToINI($aConfig, $aSettings, $sSectionName = "")
	; Save settings array to INI file with NEW field names
	; Parameters:
	;   $aConfig - Module config array
	;   $aSettings - Settings array
	;   $sSectionName - Section name (default: "Session")
	; Returns: True on success

	Local $sIniPath = $aConfig[1]
	If $sSectionName = "" Then $sSectionName = $aConfig[2]

	; Module ON/OFF Switches (3x)
	IniWrite($sIniPath, $sSectionName, "Set0Active", SettingsINI_GetValue($aSettings, "Set0Active"))
	IniWrite($sIniPath, $sSectionName, "Set1Active", SettingsINI_GetValue($aSettings, "Set1Active"))
	IniWrite($sIniPath, $sSectionName, "Set2Active", SettingsINI_GetValue($aSettings, "Set2Active"))

	; Set0 - MOD0 Pack (3 fields)
	IniWrite($sIniPath, $sSectionName, "Set0_Folder", SettingsINI_GetValue($aSettings, "Set0_Folder"))
	IniWrite($sIniPath, $sSectionName, "Set0_SubDir", SettingsINI_GetValue($aSettings, "Set0_SubDir"))
	IniWrite($sIniPath, $sSectionName, "Set0_File", SettingsINI_GetValue($aSettings, "Set0_File"))

	; Set1 - MOD1 Unpack (3 fields)
	IniWrite($sIniPath, $sSectionName, "Set1_Folder", SettingsINI_GetValue($aSettings, "Set1_Folder"))
	IniWrite($sIniPath, $sSectionName, "Set1_SubDir", SettingsINI_GetValue($aSettings, "Set1_SubDir"))
	IniWrite($sIniPath, $sSectionName, "Set1_File", SettingsINI_GetValue($aSettings, "Set1_File"))

	; Set2 - MOD2-UNI Universal (3 fields)
	IniWrite($sIniPath, $sSectionName, "Set2_Folder", SettingsINI_GetValue($aSettings, "Set2_Folder"))
	IniWrite($sIniPath, $sSectionName, "Set2_SubDir", SettingsINI_GetValue($aSettings, "Set2_SubDir"))
	IniWrite($sIniPath, $sSectionName, "Set2_File", SettingsINI_GetValue($aSettings, "Set2_File"))

	; Extensions (3x)
	IniWrite($sIniPath, $sSectionName, "ExtInclude", SettingsINI_GetValue($aSettings, "ExtInclude"))
	IniWrite($sIniPath, $sSectionName, "ExtExclude", SettingsINI_GetValue($aSettings, "ExtExclude"))
	IniWrite($sIniPath, $sSectionName, "ExtFilter", SettingsINI_GetValue($aSettings, "ExtFilter"))

	; Index (1x)
	IniWrite($sIniPath, $sSectionName, "Index", SettingsINI_GetValue($aSettings, "Index"))

	; Other
	IniWrite($sIniPath, $sSectionName, "Mode", SettingsINI_GetValue($aSettings, "Mode"))
	IniWrite($sIniPath, $sSectionName, "AddMarkerComments", SettingsINI_GetValue($aSettings, "AddMarkerComments"))
	IniWrite($sIniPath, $sSectionName, "MarkerUseTyp1json", SettingsINI_GetValue($aSettings, "MarkerUseTyp1json"))

	Return True
EndFunc   ;==>SettingsINI_SaveToINI

Func SettingsINI_OpenINIEditor($aConfig)
	; Open INI file in text editor
	; Parameters:
	;   $aConfig - Module config array
	; Returns: True if opened successfully

	Local $sIniPath = $aConfig[1]

	; Try Notepad++ first (common locations)
	Local $aNotepadPaths[4] = [ _
			"C:\Program Files\Notepad++\notepad++.exe", _
			"C:\Program Files (x86)\Notepad++\notepad++.exe", _
			@ProgramFilesDir & "\Notepad++\notepad++.exe", _
			@ProgramFilesDir & " (x86)\Notepad++\notepad++.exe" _
			]

	For $i = 0 To UBound($aNotepadPaths) - 1
		If FileExists($aNotepadPaths[$i]) Then
			ShellExecute($aNotepadPaths[$i], '"' & $sIniPath & '"')
			Return True
		EndIf
	Next

	; Fallback to default program
	ShellExecute($sIniPath)
	Return True
EndFunc   ;==>SettingsINI_OpenINIEditor

;///////////////////////////////////////////////////////////////////////////////
; PRESET MANAGEMENT
;///////////////////////////////////////////////////////////////////////////////

Func SettingsINI_GetNextPresetNumber($aConfig)
	; Get next available preset number
	; Parameters:
	;   $aConfig - Module config array
	; Returns: Next preset number (minimum 1)

	Local $sIniPath = $aConfig[1]
	Local $sMetaSection = $aConfig[3]

	Local $iNext = Int(IniRead($sIniPath, $sMetaSection, "NextPresetNumber", "1"))
	If $iNext < 1 Then $iNext = 1

	Return $iNext
EndFunc   ;==>SettingsINI_GetNextPresetNumber

Func SettingsINI_SetNextPresetNumber($aConfig, $iNum)
	; Set next preset number
	; Parameters:
	;   $aConfig - Module config array
	;   $iNum - Next preset number
	; Returns: True

	Local $sIniPath = $aConfig[1]
	Local $sMetaSection = $aConfig[3]

	IniWrite($sIniPath, $sMetaSection, "NextPresetNumber", String($iNum))
	Return True
EndFunc   ;==>SettingsINI_SetNextPresetNumber

Func SettingsINI_GetPresetList($aConfig)
	; Get list of existing preset numbers
	; Parameters:
	;   $aConfig - Module config array
	; Returns: Array of preset numbers (sorted)

	Local $sIniPath = $aConfig[1]
	Local $aSections = IniReadSectionNames($sIniPath)

	If @error Then
		Local $aEmpty[1] = [0]
		Return $aEmpty
	EndIf

	; Filter numeric sections (presets)
	Local $aPresets[100]
	Local $iCount = 0

	For $i = 1 To $aSections[0]
		If StringIsDigit($aSections[$i]) Then
			$aPresets[$iCount] = Int($aSections[$i])
			$iCount += 1
		EndIf
	Next

	; Resize and sort
	If $iCount = 0 Then
		Local $aEmpty[1] = [0]
		Return $aEmpty
	EndIf

	ReDim $aPresets[$iCount + 1]
	$aPresets[0] = $iCount
	_ArraySort($aPresets, 0, 1)

	Return $aPresets
EndFunc   ;==>SettingsINI_GetPresetList

Func SettingsINI_SavePreset($aConfig, $aSettings, $iPresetNum)
	; Save settings as preset
	; Parameters:
	;   $aConfig - Module config array
	;   $aSettings - Settings array to save
	;   $iPresetNum - Preset number
	; Returns: True on success

	Local $sSectionName = String($iPresetNum)
	Return SettingsINI_SaveToINI($aConfig, $aSettings, $sSectionName)
EndFunc   ;==>SettingsINI_SavePreset

Func SettingsINI_LoadPreset($aConfig, $iPresetNum)
	; Load preset by number
	; Parameters:
	;   $aConfig - Module config array
	;   $iPresetNum - Preset number to load
	; Returns: Settings array

	Local $sSectionName = String($iPresetNum)
	Return SettingsINI_LoadFromINI($aConfig, $sSectionName)
EndFunc   ;==>SettingsINI_LoadPreset

Func SettingsINI_SavePresetAsNew($aConfig, $aSettings)
	; Save current settings as new preset
	; Parameters:
	;   $aConfig - Module config array
	;   $aSettings - Current settings
	; Returns: Array [PresetNumber, Success]

	Local $iNextNum = SettingsINI_GetNextPresetNumber($aConfig)
	Local $bSuccess = SettingsINI_SavePreset($aConfig, $aSettings, $iNextNum)

	If $bSuccess Then
		SettingsINI_SetNextPresetNumber($aConfig, $iNextNum + 1)
	EndIf

	Local $aResult[2]
	$aResult[0] = $iNextNum
	$aResult[1] = $bSuccess

	Return $aResult
EndFunc   ;==>SettingsINI_SavePresetAsNew

Func SettingsINI_LoadPresetDialog($aConfig)
	; Show dialog to select and load preset
	; Parameters:
	;   $aConfig - Module config array
	; Returns: Array [PresetNumber, SettingsArray] or False if cancelled

	Local $aPresets = SettingsINI_GetPresetList($aConfig)

	If $aPresets[0] = 0 Then
		MsgBox($MB_ICONWARNING, "No Presets", "No presets found. Save a preset first.")
		Return False
	EndIf

	; Build preset list string
	Local $sPresetList = ""
	For $i = 1 To $aPresets[0]
		$sPresetList &= $aPresets[$i]
		If $i < $aPresets[0] Then $sPresetList &= ", "
	Next

	; Show input dialog
	Local $sInput = InputBox("Load Preset", "Available Presets: " & $sPresetList & @CRLF & "Enter preset number:", $aPresets[1])

	If @error Then Return False

	Local $iPresetNum = Int($sInput)
	If $iPresetNum < 1 Then Return False

	; Load the preset
	Local $aSettings = SettingsINI_LoadPreset($aConfig, $iPresetNum)

	Local $aResult[2]
	$aResult[0] = $iPresetNum
	$aResult[1] = $aSettings

	Return $aResult
EndFunc   ;==>SettingsINI_LoadPresetDialog

;///////////////////////////////////////////////////////////////////////////////
; END OF MODULE
;///////////////////////////////////////////////////////////////////////////////

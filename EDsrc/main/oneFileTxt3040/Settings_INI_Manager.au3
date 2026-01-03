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
	; Create empty settings array
	; Returns: Settings array with default structure

	Local $aSettings[33][2] = [[1, 2], [5, 6]]

	$aSettings[0][0] = "SettingsArray"
	$aSettings[0][1] = 21    ; Count of settings

	; Initialize with empty values
	$aSettings[1][0] = "InParent"
	$aSettings[1][1] = ""

	$aSettings[2][0] = "InSub"
	$aSettings[2][1] = ""

	$aSettings[3][0] = "OutParent"
	$aSettings[3][1] = ""

	$aSettings[4][0] = "OutSub"
	$aSettings[4][1] = ""

	$aSettings[5][0] = "AllCodeFile"
	$aSettings[5][1] = ""

	$aSettings[6][0] = "ExtInclude"
	$aSettings[6][1] = ""

	$aSettings[7][0] = "ExtExclude"
	$aSettings[7][1] = ""

	$aSettings[8][0] = "ExtFilter"
	$aSettings[8][1] = ""

	$aSettings[9][0] = "AddMarkerComments"
	$aSettings[9][1] = "0"

	$aSettings[10][0] = "Mode"
	$aSettings[10][1] = "0"

	$aSettings[11][0] = "Index"
	$aSettings[11][1] = "1001"

	$aSettings[12][0] = "FolderIn"
	$aSettings[12][1] = ""

	$aSettings[13][0] = "FolderOut"
	$aSettings[13][1] = ""

	$aSettings[14][0] = "ResultList"
	$aSettings[14][1] = ""

	$aSettings[15][0] = "MarkerUseTyp1json"
	$aSettings[15][1] = "0"

	$aSettings[16][0] = "MarkerBegin"
	$aSettings[16][1] = "////marker_begin"

	$aSettings[17][0] = "MarkerEnd"
	$aSettings[17][1] = "////marker_end"

	$aSettings[18][0] = "MarkerSeparator"
	$aSettings[18][1] = " "

	$aSettings[20][0] = "SUBdefault"
	$aSettings[20][1] = "sub"

	$aSettings[21][0] = "Reserved1"
	$aSettings[21][1] = ""

	$aSettings[22][0] = "Reserved2"
	$aSettings[22][1] = ""

	$aSettings[23][0] = "Reserved3"
	$aSettings[23][1] = ""

	$aSettings[24][0] = "Reserved4"
	$aSettings[24][1] = ""

	$aSettings[25][0] = "Reserved5"
	$aSettings[25][1] = ""

	$aSettings[26][0] = "Reserved6"
	$aSettings[26][1] = ""

	$aSettings[27][0] = "Reserved7"
	$aSettings[27][1] = ""



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
	; Load settings from INI file into array
	; Parameters:
	;   $aConfig - Module config array (from SettingsINI_Init)
	;   $sSectionName - Section name (default: "Session")
	; Returns: Settings array

	Local $sIniPath = $aConfig[1]
	If $sSectionName = "" Then $sSectionName = $aConfig[2]

	Local $aSettings = SettingsINI_CreateArray()

	; Read all keys from section
	SettingsINI_SetValue($aSettings, "InParent", IniRead($sIniPath, $sSectionName, "InParent", ""))
	SettingsINI_SetValue($aSettings, "InSub", IniRead($sIniPath, $sSectionName, "InSub", ""))
	SettingsINI_SetValue($aSettings, "OutParent", IniRead($sIniPath, $sSectionName, "OutParent", ""))
	SettingsINI_SetValue($aSettings, "OutSub", IniRead($sIniPath, $sSectionName, "OutSub", ""))
	SettingsINI_SetValue($aSettings, "AllCodeFile", IniRead($sIniPath, $sSectionName, "AllCodeFile", ""))
	SettingsINI_SetValue($aSettings, "ExtInclude", IniRead($sIniPath, $sSectionName, "ExtInclude", ""))
	SettingsINI_SetValue($aSettings, "ExtExclude", IniRead($sIniPath, $sSectionName, "ExtExclude", ""))
	SettingsINI_SetValue($aSettings, "ExtFilter", IniRead($sIniPath, $sSectionName, "ExtFilter", ""))
	SettingsINI_SetValue($aSettings, "AddMarkerComments", IniRead($sIniPath, $sSectionName, "AddMarkerComments", "0"))
	SettingsINI_SetValue($aSettings, "Mode", IniRead($sIniPath, $sSectionName, "Mode", "0"))
	SettingsINI_SetValue($aSettings, "Index", IniRead($sIniPath, $sSectionName, "Index", "1000"))
	SettingsINI_SetValue($aSettings, "MarkerUseTyp1json", IniRead($sIniPath, $sSectionName, "MarkerUseTyp1json", "0"))

	Return $aSettings
EndFunc   ;==>SettingsINI_LoadFromINI

Func SettingsINI_SaveToINI($aConfig, $aSettings, $sSectionName = "")
	; Save settings array to INI file
	; Parameters:
	;   $aConfig - Module config array
	;   $aSettings - Settings array
	;   $sSectionName - Section name (default: "Session")
	; Returns: True on success

	Local $sIniPath = $aConfig[1]
	If $sSectionName = "" Then $sSectionName = $aConfig[2]

	; Write all keys to section
	IniWrite($sIniPath, $sSectionName, "InParent", SettingsINI_GetValue($aSettings, "InParent"))
	IniWrite($sIniPath, $sSectionName, "InSub", SettingsINI_GetValue($aSettings, "InSub"))
	IniWrite($sIniPath, $sSectionName, "OutParent", SettingsINI_GetValue($aSettings, "OutParent"))
	IniWrite($sIniPath, $sSectionName, "OutSub", SettingsINI_GetValue($aSettings, "OutSub"))
	IniWrite($sIniPath, $sSectionName, "AllCodeFile", SettingsINI_GetValue($aSettings, "AllCodeFile"))
	;my add 1codeline different AllCodeFile for mod1 to read AllCodeFileRead
	;newcode;
	IniWrite($sIniPath, $sSectionName, "AllCodeFileRead", SettingsINI_GetValue($aSettings, "AllCodeFileRead"))

	IniWrite($sIniPath, $sSectionName, "ExtInclude", SettingsINI_GetValue($aSettings, "ExtInclude"))
	IniWrite($sIniPath, $sSectionName, "ExtExclude", SettingsINI_GetValue($aSettings, "ExtExclude"))
	IniWrite($sIniPath, $sSectionName, "ExtFilter", SettingsINI_GetValue($aSettings, "ExtFilter"))
	IniWrite($sIniPath, $sSectionName, "AddMarkerComments", SettingsINI_GetValue($aSettings, "AddMarkerComments"))
	IniWrite($sIniPath, $sSectionName, "Mode", SettingsINI_GetValue($aSettings, "Mode"))
	IniWrite($sIniPath, $sSectionName, "Index", SettingsINI_GetValue($aSettings, "Index"))
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

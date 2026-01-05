#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\icon\Screenshot3verlaufALL.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Main_1FileTxt_3040.au3
; simplified file logic with logging // idxq number: ini index=
;===============================================================================
; Changelog 3040:
;~
;~
;~
;~
;===============================================================================
GUISetIcon("D:\icon\all.ico")
Global $g_hGUI
Global $g_aConfig, $g_aSettings
Global $g_aSetActive[3] = [True, True, False]  ; Default: Set0=ON, Set1=ON, Set2=OFF
Global $g_aInputSets[3][6]

; GUI Controls
Global $g_idBtnINI, $g_idBtnSave, $g_idBtnLoad
Global $g_idEditExtInc, $g_idEditExtExc, $g_idEditExtFlt
Global $g_idBtnUpdInc, $g_idBtnUpdExc
Global $g_idEditIdx, $g_idBtnIdxPlus
Global $g_idBtnMod0, $g_idBtnMod1, $g_idBtnMod2Uni, $g_idBtnExit
Global $g_iMode = 0
Global $dbgg   ;;//  DEBUGG
$dbgg=1
Global $ccc ,$ClickLineConsoleWrite="If $dbgg then Local " & _
",$w=ConsoleWrite(@CRLF&'---'&@ScriptFullPath&'---'&@CRLF)" & _
"$w=ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :')" & _
",$w=ConsoleWrite",$ccc=$ClickLineConsoleWrite
;ToDo on sam points - please add clickable line numbers  and script file name - ;;//  damit syntax ```ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ....')``` sind alle folgenden line number clickbar :-)

;===============================================================================
; INCLUDES
;===============================================================================
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <Array.au3>
#include "Settings_INI_Manager.au3"
#include "PathUtils.au3"
#include "FileMarker.au3"
#include "FolderFileLogic.au3"
#include "INI2Globals.au3"
#include "VerifyFiles.au3"

;===============================================================================
; MAIN
;===============================================================================





Init()
CreateGUI()
GUILoop()

;===============================================================================
; INIT
;===============================================================================
Func Init()
	Local $i, $sActive


	; tst  click line number **************************************************************************
	If $dbgg then Local              $w=ConsoleWrite(@CRLF&'---'&@ScriptFullPath&'---'&@CRLF)      ,     $w=ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :')          ,          $w=ConsoleWrite        ('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
	ConsoleWrite(@CRLF&@CRLF&'>---' & @ScriptFullPath &    @CRLF& @CRLF &'-===-START-===-' & @CRLF)
	If $dbgg then Local              $w=ConsoleWrite(@CRLF&'---'&@ScriptFullPath&'---'&@CRLF)      ,     $w=ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :')          ,          $w=ConsoleWrite        ('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
	ConsoleWrite(@CRLF & @CRLF & @CRLF & @CRLF)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  Init: Start   ' & @CRLF)
	; tst  click line number end **************************************************************************


	$g_aConfig = SettingsINI_Init(@ScriptDir & "\settings.ini")
	$g_aSettings = SettingsINI_LoadFromINI($g_aConfig, "Session")

	; Defaults
	If SettingsINI_GetValue($g_aSettings, "Index") = "" Then
		SettingsINI_SetValue($g_aSettings, "Index", "1014")
	EndIf
	If SettingsINI_GetValue($g_aSettings, "ExtInclude") = "" Then
		SettingsINI_SetValue($g_aSettings, "ExtInclude", ".au3.txt.md")
	EndIf

	; Load SetActive flags with defaults: Set0=1, Set1=1, Set2=0
	For $i = 0 To 2
		$sActive = SettingsINI_GetValue($g_aSettings, "Set" & $i & "Active")
		If $sActive <> "" Then
			$g_aSetActive[$i] = ($sActive = "1")
		Else
			; Default: Set0 and Set1 active, Set2 inactive
			$g_aSetActive[$i] = ($i = 0 Or $i = 1)
			SettingsINI_SetValue($g_aSettings, "Set" & $i & "Active", $g_aSetActive[$i] ? "1" : "0")
		EndIf
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Set' & $i & 'Active: ' & $g_aSetActive[$i] & @CRLF)
	Next

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Init: Complete' & @CRLF)
	Return True
EndFunc

;===============================================================================
; CREATE GUI
;===============================================================================
Func CreateGUI()
	Local $iX, $iY, $i, $iNextPreset

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CreateGUI: Start' & @CRLF)

	$iX = 10
	$iY = 10

	$g_hGUI = GUICreate("Universal Debug GUI v3040", 620, 850)  ;; was v 3032
	GUISetFont(9, 400, 0, "Arial")

	; Settings Buttons
	$g_idBtnINI = GUICtrlCreateButton("INI Edit", $iX, $iY, 100, 25)
	$g_idBtnSave = GUICtrlCreateButton("Save As [?]", $iX + 110, $iY, 100, 25)
	$g_idBtnLoad = GUICtrlCreateButton("Load Preset", $iX + 220, $iY, 100, 25)

	$iNextPreset = SettingsINI_GetNextPresetNumber($g_aConfig)
	GUICtrlSetData($g_idBtnSave, "Save As [" & $iNextPreset & "]")
GUISetIcon("D:\icon\all.ico")
	; Extension Filters
	$iY += 40
	GUICtrlCreateLabel("extInclude:", $iX, $iY, 400, 20)
	$iY += 18
	$g_idEditExtInc = GUICtrlCreateInput(SettingsINI_GetValue($g_aSettings, "ExtInclude"), $iX, $iY, 450, 22)
	$g_idBtnUpdInc = GUICtrlCreateButton("Update", $iX + 455, $iY, 60, 22)

	$iY += 30
	GUICtrlCreateLabel("extExclude:", $iX, $iY, 400, 20)
	$iY += 18
	$g_idEditExtExc = GUICtrlCreateInput(SettingsINI_GetValue($g_aSettings, "ExtExclude"), $iX, $iY, 450, 22)
	$g_idBtnUpdExc = GUICtrlCreateButton("Update", $iX + 455, $iY, 60, 22)

	$iY += 30
	GUICtrlCreateLabel("extFilter:", $iX, $iY, 400, 20)
	$iY += 18
	$g_idEditExtFlt = GUICtrlCreateInput(SettingsINI_GetValue($g_aSettings, "ExtFilter"), $iX, $iY, 515, 22)
	GUICtrlSetState($g_idEditExtFlt, $GUI_DISABLE)

	; 3x3 Grid - Conditional
	$iY += 35
	For $i = 0 To 2
		If $g_aSetActive[$i] Then
			$iY = CreateInputSet($i, $iX, $iY)
		EndIf
	Next

	; Index
	GUICtrlCreateLabel("Index:", $iX, $iY, 200, 20)
	$iY += 18
	$g_idEditIdx = GUICtrlCreateInput(SettingsINI_GetValue($g_aSettings, "Index"), $iX, $iY, 100, 25)
	$g_idBtnIdxPlus = GUICtrlCreateButton("+1", $iX + 110, $iY, 50, 25)

	; Mode Buttons
	$iY += 45
	$g_idBtnMod0 = GUICtrlCreateButton("MOD0: Pack", $iX, $iY, 180, 35)
	GUICtrlSetFont($g_idBtnMod0, 10, 600)
	GUICtrlSetBkColor($g_idBtnMod0, 0xFFA500)

	$g_idBtnMod1 = GUICtrlCreateButton("MOD1: Unpack", $iX + 190, $iY, 180, 35)
	GUICtrlSetFont($g_idBtnMod1, 10, 600)
	GUICtrlSetBkColor($g_idBtnMod1, 0xD0D0D0)

	$g_idBtnMod2Uni = GUICtrlCreateButton("MOD2-UNI", $iX + 380, $iY, 180, 35)
	GUICtrlSetFont($g_idBtnMod2Uni, 10, 600)
	GUICtrlSetBkColor($g_idBtnMod2Uni, 0xD0D0D0)

	$iY += 45
	$g_idBtnExit = GUICtrlCreateButton("EXIT", $iX, $iY, 570, 25)
	GUICtrlSetBkColor($g_idBtnExit, 0xFF6666)

	GUISetState(@SW_SHOW, $g_hGUI)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CreateGUI: Complete' & @CRLF)
EndFunc

;-------------------------------------------------------------------------------
; Create Input Set with named buttons
;-------------------------------------------------------------------------------
Func CreateInputSet($iSetIdx, $iX, $iY)
	Local $sFolder, $sSubDir, $sFile

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CreateInputSet: Set' & $iSetIdx & @CRLF)

	; Header
	GUICtrlCreateLabel("=== Set " & $iSetIdx & " ===", $iX, $iY, 400, 20)
	GUICtrlSetFont(-1, 9, 600)
	$iY += 22

	; Get values from settings
	$sFolder = SettingsINI_GetValue($g_aSettings, "Set" & $iSetIdx & "_Folder")
	$sSubDir = SettingsINI_GetValue($g_aSettings, "Set" & $iSetIdx & "_SubDir")
	$sFile = SettingsINI_GetValue($g_aSettings, "Set" & $iSetIdx & "_File")

	; Add trailing slash for folder display
	If $sFolder <> "" And Not StringRight($sFolder, 1) = "/" Then
		$sFolder &= "/"
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CreateInputSet Set' & $iSetIdx & ': Folder=' & $sFolder & ', SubDir=' & $sSubDir & ', File=' & $sFile & @CRLF)

	; Folder Input
	GUICtrlCreateLabel("Folder" & $iSetIdx & ":", $iX, $iY, 80, 18)
	$g_aInputSets[$iSetIdx][0] = GUICtrlCreateInput($sFolder, $iX, $iY + 18, 380, 22)
	$g_aInputSets[$iSetIdx][1] = GUICtrlCreateButton("Folder" & $iSetIdx, $iX + 385, $iY + 18, 110, 22)
	$iY += 45

	; SubDir Input
	GUICtrlCreateLabel("SubDir" & $iSetIdx & ":", $iX, $iY, 80, 18)
	$g_aInputSets[$iSetIdx][2] = GUICtrlCreateInput($sSubDir, $iX, $iY + 18, 380, 22)
	$g_aInputSets[$iSetIdx][3] = GUICtrlCreateButton("SubDir" & $iSetIdx, $iX + 385, $iY + 18, 110, 22)
	$iY += 45

	; File Input
	GUICtrlCreateLabel("File" & $iSetIdx & ":", $iX, $iY, 80, 18)
	$g_aInputSets[$iSetIdx][4] = GUICtrlCreateInput($sFile, $iX, $iY + 18, 380, 22)
	$g_aInputSets[$iSetIdx][5] = GUICtrlCreateButton("File" & $iSetIdx, $iX + 385, $iY + 18, 110, 22)
	$iY += 50

	Return $iY
EndFunc

;===============================================================================
; GUI EVENT LOOP
;===============================================================================
Func GUILoop()
	Local $iMsg, $aResult, $iCurrent, $iNext

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' GUILoop: Start' & @CRLF)

	While 1
		$iMsg = GUIGetMsg()

		Switch $iMsg
			Case $GUI_EVENT_CLOSE, $g_idBtnExit
				ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' GUILoop: Exit' & @CRLF)
				SaveAll()
				Exit

			Case $g_idBtnINI
				SettingsINI_OpenINIEditor($g_aConfig)

			Case $g_idBtnSave
				SaveAll()
				$aResult = SettingsINI_SavePresetAsNew($g_aConfig, $g_aSettings)
				ShowTooltip1("Preset #" & $aResult[0] & " saved!")
				$iNext = SettingsINI_GetNextPresetNumber($g_aConfig)
				GUICtrlSetData($g_idBtnSave, "Save As [" & $iNext & "]")

			Case $g_idBtnLoad
				$aResult = SettingsINI_LoadPresetDialog($g_aConfig)
				If IsArray($aResult) Then
					$g_aSettings = $aResult[1]
					LoadAll()
					ShowTooltip1("Preset #" & $aResult[0] & " loaded!")
				EndIf

			Case $g_idBtnUpdInc, $g_idBtnUpdExc
				CalcExtFilter()
				UpdateAllFields()
				CreateCalculatedFolders()
				SaveAll()
				ShowTooltip1("Filter updated! Folders created!")

			Case $g_idBtnIdxPlus
				$iCurrent = Int(GUICtrlRead($g_idEditIdx))
				$iCurrent += 1
				GUICtrlSetData($g_idEditIdx, String($iCurrent))
				UpdateAllFields()
				SaveAll()

			Case $g_idBtnMod0
				SetMode(0)
				ExecuteMod0()

			Case $g_idBtnMod1
				SetMode(1)
				ExecuteMod1()

			Case $g_idBtnMod2Uni
				SetMode(2)
				ExecuteMod2Uni()

			Case Else
				HandleInputSetButtons($iMsg)
		EndSwitch

		Sleep(22)
	WEnd
EndFunc

;===============================================================================
; INPUT SET BUTTON HANDLER
;===============================================================================
Func HandleInputSetButtons($iMsg)
	Local $i, $j, $sFolder, $sFile, $sInitDir, $sFull

	For $i = 0 To 2
		If Not $g_aSetActive[$i] Then ContinueLoop

		For $j = 0 To 5 Step 2
			If $iMsg = $g_aInputSets[$i][$j + 1] Then
				ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & @TAB   &' Button pressed: Set' & $i & ' Field' & $j & @CRLF)

				$sInitDir = @WorkingDir

				If $j = 4 Then
					; File button
					$sFile = FileOpenDialog("Select File", $sInitDir, "All Files (*.*)")
					If $sFile <> "" Then
						$sFull = PathToInternal($sFile)
						GUICtrlSetData($g_aInputSets[$i][$j], $sFull)
						SettingsINI_SetValue($g_aSettings, "Set" & $i & "_File", $sFull)
						ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Set' & $i & ' File: ' & $sFull & @CRLF)
						ShellExecute($sFile)
					EndIf
				Else
					; Folder/SubDir button
					Local $sCurrent = GUICtrlRead($g_aInputSets[$i][$j])

					; Remove trailing slash and convert to OS path
					If $sCurrent <> "" Then
						$sCurrent = StringRegExpReplace($sCurrent, "[/\\]+$", "")
						Local $sCheckPath = PathToOS($sCurrent)
						If FileExists($sCheckPath) Then
							$sInitDir = $sCheckPath
							; Add trailing backslash for FileSelectFolder
							If Not StringRight($sInitDir, 1) = "\" Then
								$sInitDir &= "\"
							EndIf
						EndIf
					EndIf

					$sFolder = FileSelectFolder("Select Folder", $sInitDir, 0, $sInitDir)
					If $sFolder <> "" Then
						$sFull = PathToInternal($sFolder)

						; Add trailing slash for display in folder fields
						Local $sDisplay = $sFull
						If Not StringRight($sDisplay, 1) = "/" Then
							$sDisplay &= "/"
						EndIf

						GUICtrlSetData($g_aInputSets[$i][$j], $sDisplay)

						If $j = 0 Then
							; Folder button - auto-calculate SubDir
							SettingsINI_SetValue($g_aSettings, "Set" & $i & "_Folder", $sFull)
							UpdateAllFields()
						Else
							; SubDir button
							SettingsINI_SetValue($g_aSettings, "Set" & $i & "_SubDir", ExtractFolderName($sFull))
						EndIf

						ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Set' & $i & ' Folder: ' & $sFull & @CRLF)
						OpenFolderExplorer($sFull)
					EndIf
				EndIf

				SaveAll()
				Return
			EndIf
		Next
	Next
EndFunc

;===============================================================================
; UPDATE ALL FIELDS (idx, folder calculations)
;===============================================================================
Func UpdateAllFields()
	Local $iIdx

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' UpdateAllFields: Start' & @CRLF)

	; Get current idx
	$iIdx = Int(GUICtrlRead($g_idEditIdx))
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' idx: ' & $iIdx & @CRLF)

	; Update MOD0 calculations
	UpdateSet0Fields($iIdx)

	; Update MOD1 calculations
	UpdateSet1Fields($iIdx)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' UpdateAllFields: Complete' & @CRLF)
EndFunc

Func UpdateSet0Fields($iIdx)
	Local $sFolder0, $sParent, $sSub, $sFile0

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' UpdateSet0Fields: Start' & @CRLF)

	$sFolder0 = GUICtrlRead($g_aInputSets[0][0])
	; Remove trailing slash for logic
	$sFolder0 = StringRegExpReplace($sFolder0, "[/\\]+$", "")

	If $sFolder0 = "" Then Return

	$sParent = CalcParent($sFolder0)
	$sSub = CalcSub($sFolder0)
	$sFile0 = Calc1FilePath($sParent, $sSub, $iIdx)

	; Update SubDir0
	GUICtrlSetData($g_aInputSets[0][2], $sSub)
	SettingsINI_SetValue($g_aSettings, "Set0_SubDir", $sSub)

	; Update File0
	GUICtrlSetData($g_aInputSets[0][4], $sFile0)
	SettingsINI_SetValue($g_aSettings, "Set0_File", $sFile0)

	; Copy to File1 with new idx
	If $g_aSetActive[1] Then
		GUICtrlSetData($g_aInputSets[1][4], $sFile0)
		SettingsINI_SetValue($g_aSettings, "Set1_File", $sFile0)
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' MOD0 idx: ' & $iIdx & ' sub: ' & $sSub & ' file0: ' & $sFile0 & @CRLF)
EndFunc

Func UpdateSet1Fields($iIdx)
	Local $s1File, $sExtractFolder, $sDisplay

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' UpdateSet1Fields: Start' & @CRLF)

	$s1File = GUICtrlRead($g_aInputSets[1][4])

	If $s1File = "" Then Return

	$sExtractFolder = CalcExtractFolder($s1File)

	; Add trailing slash for display
	$sDisplay = $sExtractFolder
	If Not StringRight($sDisplay, 1) = "/" Then
		$sDisplay &= "/"
	EndIf

	; Update Folder1
	GUICtrlSetData($g_aInputSets[1][0], $sDisplay)
	SettingsINI_SetValue($g_aSettings, "Set1_Folder", $sExtractFolder)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' MOD1 idx: ' & $iIdx & ' folder1: ' & $sExtractFolder & @CRLF)
EndFunc

;-------------------------------------------------------------------------------
; Create calculated pack and unpack folders
;-------------------------------------------------------------------------------
Func CreateCalculatedFolders()
	Local $sFile0, $sFile1, $sPackDir, $sUnpackDir

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CreateCalculatedFolders: Start' & @CRLF)

	; Create pack folder for Set0 (MOD0)
	If $g_aSetActive[0] Then
		$sFile0 = GUICtrlRead($g_aInputSets[0][4])
		If $sFile0 <> "" Then
			$sPackDir = PathToOS(ExtractDirectory($sFile0))
			If Not FileExists($sPackDir) Then
				DirCreate($sPackDir)
				ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Created pack folder: ' & $sPackDir & @CRLF)
			EndIf
		EndIf
	EndIf

	; Create unpack folder for Set1 (MOD1)
	If $g_aSetActive[1] Then
		$sFile1 = GUICtrlRead($g_aInputSets[1][4])
		If $sFile1 <> "" Then
			; Get unpack folder from File1
			Local $sExtractFolder = CalcExtractFolder($sFile1)
			$sUnpackDir = PathToOS($sExtractFolder)
			If Not FileExists($sUnpackDir) Then
				DirCreate($sUnpackDir)
				ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Created unpack folder: ' & $sUnpackDir & @CRLF)
			EndIf
		EndIf
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CreateCalculatedFolders: Complete' & @CRLF)
EndFunc

;===============================================================================
; MOD0: PACK
;===============================================================================
Func ExecuteMod0()
	Local $sFolder0, $sParent, $sSub, $iIdx, $sFullPath, $sOutFolder, $s1File, $aFiles, $sFlt, $sExtractFolder

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' === MOD0 START ===' & @CRLF)

	SaveAll()

	$sFolder0 = GUICtrlRead($g_aInputSets[0][0])
	$iIdx = Int(GUICtrlRead($g_idEditIdx))
	$sFlt = GUICtrlRead($g_idEditExtFlt)

	If $sFolder0 = "" Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: Folder0 empty' & @CRLF)
		MsgBox($MB_ICONERROR, "Error", "Set Folder0!")
		Return False
	EndIf

	$sParent = CalcParent($sFolder0)
	$sSub = CalcSub($sFolder0)
	$s1File = Calc1FilePath($sParent, $sSub, $iIdx)

	$sFullPath = PathToOS($sFolder0)

	If Not FileExists($sFullPath) Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: Folder not found: ' & $sFullPath & @CRLF)
		MsgBox($MB_ICONERROR, "Error", "Folder not found!")
		Return False
	EndIf

	; Create output folder
	$sOutFolder = PathToOS(ExtractDirectory($s1File))
	If Not FileExists($sOutFolder) Then DirCreate($sOutFolder)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' OutFolder created: ' & $sOutFolder & @CRLF)

	; Scan & Pack
	$aFiles = ScanFolder($sFullPath, $sFlt)

	If UBound($aFiles) = 0 Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' WARNING: No files found' & @CRLF)
		MsgBox($MB_ICONWARNING, "Warning", "No files found!")
		Return False
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Files found: ' & UBound($aFiles) & @CRLF)

	If Not PackFiles($aFiles, PathToOS($s1File), PathToOS($sParent), $sSub) Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: Pack failed' & @CRLF)
		MsgBox($MB_ICONERROR, "Error", "Pack failed!")
		Return False
	EndIf

	; Increment index
	$iIdx += 1
	GUICtrlSetData($g_idEditIdx, String($iIdx))
	SettingsINI_SetValue($g_aSettings, "Index", String($iIdx))
	SaveAll()

	; Update Set0 File display
	GUICtrlSetData($g_aInputSets[0][4], $s1File)
	SettingsINI_SetValue($g_aSettings, "Set0_File", $s1File)

	; Copy to Set1
	If $g_aSetActive[1] Then
		GUICtrlSetData($g_aInputSets[1][4], $s1File)
		SettingsINI_SetValue($g_aSettings, "Set1_File", $s1File)
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Copied to Set1: ' & $s1File & @CRLF)
	EndIf

	ShellExecute(PathToOS($s1File))
	ShowTooltip1("mod0 ok", 3000)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' === MOD0 COMPLETE ===' & @CRLF)

	; Auto MOD1 Verify
	$sExtractFolder = CalcExtractFolder($s1File)

	; Update Set1 Folder1 with trailing slash for display
	If $g_aSetActive[1] Then
		Local $sDisplay = $sExtractFolder
		If Not StringRight($sDisplay, 1) = "/" Then
			$sDisplay &= "/"
		EndIf
		GUICtrlSetData($g_aInputSets[1][0], $sDisplay)
		SettingsINI_SetValue($g_aSettings, "Set1_Folder", $sExtractFolder)
	EndIf

	ExecuteMod1Verify()

	Return True
EndFunc

;===============================================================================
; MOD1: UNPACK
;===============================================================================
Func ExecuteMod1()
	SaveAll()
	ExecuteMod1Verify()
EndFunc

Func ExecuteMod1Verify()
	Local $s1File, $sExtractFolder, $iCount, $sFolder0, $bVerifyOK

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' === MOD1 START ===' & @CRLF)

	$s1File = GUICtrlRead($g_aInputSets[1][4])

	If $s1File = "" Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: File1 empty' & @CRLF)
		MsgBox($MB_ICONERROR, "Error", "Set File1!")
		Return False
	EndIf

	If Not FileExists(PathToOS($s1File)) Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: File not found: ' & $s1File & @CRLF)
		MsgBox($MB_ICONERROR, "Error", "File not found!")
		Return False
	EndIf

	; Calculate extraction folder
	$sExtractFolder = CalcExtractFolder($s1File)

	; Update Set1 Folder1 display with trailing slash
	If $g_aSetActive[1] Then
		Local $sDisplay = $sExtractFolder
		If Not StringRight($sDisplay, 1) = "/" Then
			$sDisplay &= "/"
		EndIf
		GUICtrlSetData($g_aInputSets[1][0], $sDisplay)
		SettingsINI_SetValue($g_aSettings, "Set1_Folder", $sExtractFolder)
		SaveAll()
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ExtractFolder: ' & $sExtractFolder & @CRLF)

	$iCount = UnpackFiles(PathToOS($s1File), PathToOS($sExtractFolder), "")

	If $iCount > 0 Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Files extracted: ' & $iCount & @CRLF)

		; Verify: Compare original Folder0 with extracted folder
		$sFolder0 = GUICtrlRead($g_aInputSets[0][0])

		If $sFolder0 <> "" And FileExists(PathToOS($sFolder0)) Then
			$bVerifyOK = CompareFolders(PathToOS($sFolder0), PathToOS($sExtractFolder))

			If $bVerifyOK Then
				ShowTooltip2("mod1 ok check ok", 9000)
			Else
				ShowTooltip2("mod1 ok check FAIL", 9000)
			EndIf
		Else
			ShowTooltip2("mod1 ok", 9000)
		EndIf

		; Open explorer
		OpenFolderExplorer($sExtractFolder)

		ShellExecute(PathToOS($s1File))
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' === MOD1 COMPLETE ===' & @CRLF)
		Return True
	Else
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: Unpack failed' & @CRLF)
		MsgBox($MB_ICONERROR, "Error", "Unpack failed!")
		Return False
	EndIf
EndFunc

;===============================================================================
; MOD2-UNI
;===============================================================================
Func ExecuteMod2Uni()
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' === MOD2-UNI ===' & @CRLF)
	SaveAll()
	ShowTooltip1("MOD2-UNI: Saved!")
	MsgBox($MB_ICONINFORMATION, "MOD2-UNI", "Settings saved!")
EndFunc

;===============================================================================
; HELPERS
;===============================================================================
Func SetMode($iNewMode)
	$g_iMode = $iNewMode
	GUICtrlSetBkColor($g_idBtnMod0, ($iNewMode = 0) ? 0xFFA500 : 0xD0D0D0)
	GUICtrlSetBkColor($g_idBtnMod1, ($iNewMode = 1) ? 0xFFA500 : 0xD0D0D0)
	GUICtrlSetBkColor($g_idBtnMod2Uni, ($iNewMode = 2) ? 0xFFA500 : 0xD0D0D0)
	SaveAll()
EndFunc

Func ShowTooltip1($sText, $iDuration = 3000)
	ToolTip($sText, 22, 22)
	AdlibRegister("ClearTooltip1", $iDuration)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Tooltip1: ' & $sText & @CRLF)
EndFunc

Func ClearTooltip1()
	ToolTip("", 22, 22)
	AdlibUnRegister("ClearTooltip1")
EndFunc

Func ShowTooltip2($sText, $iDuration = 9000)
	ToolTip($sText, 22, 55)
	AdlibRegister("ClearTooltip2", $iDuration)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Tooltip2: ' & $sText & @CRLF)
EndFunc

Func ClearTooltip2()
	ToolTip("", 22, 55)
	AdlibUnRegister("ClearTooltip2")
EndFunc

Func OpenFolderExplorer($sFolder)
	Local $sFolderOS

	$sFolderOS = PathToOS($sFolder)

	; Add trailing slash if missing
	If Not StringRight($sFolderOS, 1) = "\" Then
		$sFolderOS &= "\"
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' OpenFolderExplorer: ' & $sFolderOS & @CRLF)
	ShellExecute($sFolderOS)
EndFunc

Func CalcExtFilter()
	Local $sInc, $sExc, $sFlt

	$sInc = GUICtrlRead($g_idEditExtInc)
	$sExc = GUICtrlRead($g_idEditExtExc)
	$sFlt = ($sExc <> "") ? sSub($sInc, $sExc) : $sInc
	GUICtrlSetData($g_idEditExtFlt, $sFlt)
EndFunc

Func SaveAll()
	Local $i, $sFolder, $sSubDir, $sFile

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' SaveAll: Start' & @CRLF)

	SettingsINI_SetValue($g_aSettings, "ExtInclude", GUICtrlRead($g_idEditExtInc))
	SettingsINI_SetValue($g_aSettings, "ExtExclude", GUICtrlRead($g_idEditExtExc))
	SettingsINI_SetValue($g_aSettings, "ExtFilter", GUICtrlRead($g_idEditExtFlt))
	SettingsINI_SetValue($g_aSettings, "Index", GUICtrlRead($g_idEditIdx))
	SettingsINI_SetValue($g_aSettings, "Mode", String($g_iMode))

	; Save all 9 fields (3 sets × 3 fields)
	For $i = 0 To 2
		SettingsINI_SetValue($g_aSettings, "Set" & $i & "Active", $g_aSetActive[$i] ? "1" : "0")

		If $g_aSetActive[$i] Then
			; Active set: Read from GUI controls
			$sFolder = GUICtrlRead($g_aInputSets[$i][0])
			$sSubDir = GUICtrlRead($g_aInputSets[$i][2])
			$sFile = GUICtrlRead($g_aInputSets[$i][4])

			; Remove trailing slash from folder before saving
			$sFolder = StringRegExpReplace($sFolder, "[/\\]+$", "")

			SettingsINI_SetValue($g_aSettings, "Set" & $i & "_Folder", $sFolder)
			SettingsINI_SetValue($g_aSettings, "Set" & $i & "_SubDir", $sSubDir)
			SettingsINI_SetValue($g_aSettings, "Set" & $i & "_File", $sFile)

			ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' SaveAll Set' & $i & ': Folder=' & $sFolder & ', SubDir=' & $sSubDir & ', File=' & $sFile & @CRLF)
		Else
			; Inactive set: Values remain in $g_aSettings (not overwritten)
			ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' SaveAll Set' & $i & ': Inactive (preserved)' & @CRLF)
		EndIf
	Next

	SettingsINI_SaveToINI($g_aConfig, $g_aSettings, "Session")
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' SaveAll: Complete' & @CRLF)
EndFunc

Func LoadAll()
	Local $i, $sFolder, $sSubDir, $sFile

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' LoadAll: Start' & @CRLF)

	GUICtrlSetData($g_idEditExtInc, SettingsINI_GetValue($g_aSettings, "ExtInclude"))
	GUICtrlSetData($g_idEditExtExc, SettingsINI_GetValue($g_aSettings, "ExtExclude"))
	GUICtrlSetData($g_idEditExtFlt, SettingsINI_GetValue($g_aSettings, "ExtFilter"))
	GUICtrlSetData($g_idEditIdx, SettingsINI_GetValue($g_aSettings, "Index"))
	CalcExtFilter()

	; Load all 9 fields (3 sets × 3 fields) into GUI for active sets
	For $i = 0 To 2
		If $g_aSetActive[$i] Then
			$sFolder = SettingsINI_GetValue($g_aSettings, "Set" & $i & "_Folder")
			$sSubDir = SettingsINI_GetValue($g_aSettings, "Set" & $i & "_SubDir")
			$sFile = SettingsINI_GetValue($g_aSettings, "Set" & $i & "_File")

			; Add trailing slash for folder display
			If $sFolder <> "" And Not StringRight($sFolder, 1) = "/" Then
				$sFolder &= "/"
			EndIf

			GUICtrlSetData($g_aInputSets[$i][0], $sFolder)
			GUICtrlSetData($g_aInputSets[$i][2], $sSubDir)
			GUICtrlSetData($g_aInputSets[$i][4], $sFile)

			ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' LoadAll Set' & $i & ': Folder=' & $sFolder & ', SubDir=' & $sSubDir & ', File=' & $sFile & @CRLF)
		Else
			ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' LoadAll Set' & $i & ': Inactive (not displayed)' & @CRLF)
		EndIf
	Next

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' LoadAll: Complete' & @CRLF)
EndFunc

Func aSub(ByRef $aSource, ByRef $aExclude)
	Local $i, $j

	If Not IsArray($aSource) Or Not IsArray($aExclude) Then Return SetError(1, 0, $aSource)

	For $i = UBound($aSource) - 1 To 0 Step -1
		For $j = 0 To UBound($aExclude) - 1
			If $aSource[$i] = $aExclude[$j] Then
				_ArrayDelete($aSource, $i)
				ExitLoop
			EndIf
		Next
	Next

	Return $aSource
EndFunc

Func sSub($sSource, $sExclude)
	Local $sSourceN, $sExcludeN, $aSource, $aExclude, $aResult

	$sSourceN = StringReplace(StringReplace($sSource, ",", " "), ".", " ")
	$sExcludeN = StringReplace(StringReplace($sExclude, ",", " "), ".", " ")

	$aSource = StringSplit($sSourceN, " ", $STR_ENTIRESPLIT)
	$aExclude = StringSplit($sExcludeN, " ", $STR_ENTIRESPLIT)

	$aSource[0] = ''
	$aExclude[0] = ''

	$aResult = aSub($aSource, $aExclude)
	Return _ArrayToString($aResult, ".")
EndFunc



;~
;~ 				   ; old version with  GUICtrlCreateInput(   _GetSetting($aSettings, 'InParent')    ,  x  y  x  y  )
;~ 					; Input Folder Parent ---
;~ 					GUICtrlCreateLabel("Input Folder Parent (Mode 0):", $iLeft, $iTop, 300, 20)
;~ 					$idInputInParent = GUICtrlCreateInput(_GetSetting($aSettings, 'InParent'), $iLeft, $iTop + 20, $iWidthInput, 25)
;~ 					$idBtnSelInParent = GUICtrlCreateButton("Dir", $iBtnX, $iTop + 20, $iWidthBtn, 25)
;~ 					$iTop += 50
;~ 					; old version end
;~
;~
;~
;~ 					; Folder Input
;~ 					GUICtrlCreateLabel("Folder" & $iSetIdx & ":", $iX, $iY, 80, 18)
;~ 					$g_aInputSets[$iSetIdx][0] = GUICtrlCreateInput($sFolder, $iX, $iY + 18, 380, 22)
;~ 					$g_aInputSets[$iSetIdx][1] = GUICtrlCreateButton("Folder" & $iSetIdx, $iX + 385, $iY + 18, 110, 22)
;~ 					$iY += 45
;~
;~
;~
;~
;~   old ok   _GetSetting($aSettings, 'InParent')
;~   new
;~
;~
;~



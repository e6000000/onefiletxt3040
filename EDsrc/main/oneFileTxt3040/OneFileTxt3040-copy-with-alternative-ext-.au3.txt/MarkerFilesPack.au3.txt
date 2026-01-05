;this #include "getMarker.au3"
#include <File.au3>
#include <Array.au3> 

;===============================================================================
; MOD0: Pack to 1file.txt
;===============================================================================
Func ExecuteMod0()
	Local $sF1 = SettingsINI_GetValue($g_aSettings, "Set0_Folder1_Full")
	Local $sF2 = SettingsINI_GetValue($g_aSettings, "Set0_Folder2_Full")
	Local $sFlt = SettingsINI_GetValue($g_aSettings, "ExtFilter")
	Local $iIdx = Int(SettingsINI_GetValue($g_aSettings, "Index"))

	If $sF1 = "" Or $sF2 = "" Then
		MsgBox($MB_ICONERROR, "Error", "Set0: Select Folder1 and Folder2!")
		Return False
	EndIf

	Local $sParent = PathToOS($sF1)
	Local $sSub = ExtractFolderName($sF2)
	Local $sFullPath = $sParent & "\" & $sSub

	If Not FileExists($sFullPath) Then
		MsgBox($MB_ICONERROR, "Error", "Folder not found: " & $sFullPath)
		Return False
	EndIf

	Local $sOutFolder = $sParent & "\" & $iIdx & "_" & $sSub
	If Not FileExists($sOutFolder) Then DirCreate($sOutFolder)

	Local $s1File = $sOutFolder & "\1file.txt"

	ShowTooltip("Scanning: " & $sFullPath)
	Local $aFiles = ScanFolder($sFullPath, $sFlt)

	If UBound($aFiles) = 0 Then
		MsgBox($MB_ICONWARNING, "Warning", "No files found!")
		Return False
	EndIf

	ShowTooltip("Packing " & UBound($aFiles) & " files...")
	If Not PackFiles($aFiles, $s1File, $sParent, $sSub) Then
		MsgBox($MB_ICONERROR, "Error", "Pack failed!")
		Return False
	EndIf

	; Increment index
	$iIdx += 1
	SettingsINI_SetValue($g_aSettings, "Index", String($iIdx))
	GUICtrlSetData($g_idEditIdx, String($iIdx))
	SaveAll()

	ShellExecute($s1File)
	ShowTooltip("MOD0 Complete! Packed: " & UBound($aFiles))

	; Auto-verify
	SettingsINI_SetValue($g_aSettings, "Set1_File_Full", PathToInternal($s1File))
	Local $sMode = SettingsINI_GetValue($g_aSettings, "Set1_FileMode")
	If $sMode = "" Then $sMode = "file"
	If $g_aSetActive[1] Then
		GUICtrlSetData($g_aInputSets[1][4], ApplyDisplayMode($s1File, $sMode))
	EndIf

	Return ExecuteMod1Verify($s1File, $sOutFolder, $sSub)
EndFunc

;===============================================================================
; MOD1: Unpack from 1file.txt
;===============================================================================
Func ExecuteMod1()
	Local $sFile = SettingsINI_GetValue($g_aSettings, "Set1_File_Full")
	Local $sF1 = SettingsINI_GetValue($g_aSettings, "Set1_Folder1_Full")
	Local $sF2 = SettingsINI_GetValue($g_aSettings, "Set1_Folder2_Full")
	Local $iIdx = Int(SettingsINI_GetValue($g_aSettings, "Index"))

	If $sFile = "" Then
		MsgBox($MB_ICONERROR, "Error", "Set1: Select File!")
		Return False
	EndIf

	Local $s1File = PathToOS($sFile)
	If Not FileExists($s1File) Then
		MsgBox($MB_ICONERROR, "Error", "File not found!")
		Return False
	EndIf

	Local $sParent = PathToOS($sF1)
	Local $sSub = ExtractFolderName($sF2)
	Local $sOutFolder = $sParent & "\" & $iIdx & "_" & $sSub

	ShellExecute($s1File)
	Return ExecuteMod1Verify($s1File, $sOutFolder, $sSub)
EndFunc

Func ExecuteMod1Verify($s1File, $sOutFolder, $sSub)
	ShowTooltip("Unpacking...")
	Local $iCount = UnpackFiles($s1File, $sOutFolder, $sSub)

	If $iCount > 0 Then
		ShowTooltip("MOD1 Complete! Extracted: " & $iCount)
		Return True
	Else
		MsgBox($MB_ICONERROR, "Error", "Unpack failed!")
		Return False
	EndIf
EndFunc

;===============================================================================
; MOD2-UNI: Universal (no marker logic, just settings)
;===============================================================================
Func ExecuteMod2Uni()
	SaveAll()
	ShowTooltip("MOD2-UNI: Settings saved!")
	MsgBox($MB_ICONINFORMATION, "MOD2-UNI", "Universal mode activated!" & @CRLF & "All settings saved to INI." & @CRLF & @CRLF & "Use Set2 inputs for your custom projects.")
EndFunc

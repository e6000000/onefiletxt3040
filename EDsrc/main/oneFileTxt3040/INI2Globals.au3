;===============================================================================
; INI2Globals.au3
; Read INI file section and generate iniGlobals.au3 with Global declarations
;===============================================================================

#include <Array.au3> 

;-------------------------------------------------------------------------------
; Read INI section and create iniGlobals.au3
; $sINIFile: Path to INI file
; $vSection: Section name or section index (1-based)
;-------------------------------------------------------------------------------
Func ini2Globals($sINIFile, $vSection)
	Local $aSections, $aKeys, $sSection, $sKey, $sValue, $sOutput, $i
	Local $hOut

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ini2Globals: Start' & @CRLF)

	; Check if file exists
	If Not FileExists($sINIFile) Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: INI file not found: ' & $sINIFile & @CRLF)
		Return False
	EndIf

	; Get section name if index provided
	If IsInt($vSection) Then
		$aSections = IniReadSectionNames($sINIFile)
		If @error Or $vSection < 1 Or $vSection > $aSections[0] Then
			ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: Invalid section index: ' & $vSection & @CRLF)
			Return False
		EndIf
		$sSection = $aSections[$vSection]
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Section index ' & $vSection & ' = ' & $sSection & @CRLF)
	Else
		$sSection = $vSection
	EndIf

	; Read section
	$aKeys = IniReadSection($sINIFile, $sSection)
	If @error Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: Cannot read section: ' & $sSection & @CRLF)
		Return False
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Found ' & $aKeys[0][0] & ' keys in section [' & $sSection & ']' & @CRLF)

	; Build output
	$sOutput = ';===============================================================================' & @CRLF
	$sOutput &= '; iniGlobals.au3' & @CRLF
	$sOutput &= '; Auto-generated from: ' & $sINIFile & @CRLF
	$sOutput &= '; Section: [' & $sSection & ']' & @CRLF
	$sOutput &= ';===============================================================================' & @CRLF & @CRLF

	For $i = 1 To $aKeys[0][0]
		$sKey = $aKeys[$i][0]
		$sValue = $aKeys[$i][1]

		; Generate Global declaration
		$sOutput &= 'Global $' & $sKey & ' = "' & $sValue & '"' & @CRLF

		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Global $' & $sKey & ' = "' & $sValue & '"' & @CRLF)
	Next

	; Write to file
	Local $sOutFile = @ScriptDir & '\iniGlobals.au3'
	$hOut = FileOpen($sOutFile, 2)
	If $hOut = -1 Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ERROR: Cannot create iniGlobals.au3' & @CRLF)
		Return False
	EndIf

	FileWrite($hOut, $sOutput)
	FileClose($hOut)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' iniGlobals.au3 created: ' & $sOutFile & @CRLF)

	Return True
EndFunc

;===============================================================================
; FolderFileLogic.au3
; Simplified folder/file calculation logic with ConsoleWrite logging
; parent/sub structure
;===============================================================================

;-------------------------------------------------------------------------------
; Calculate Sub folder name from full path
; Input: "D:/1p/su" -> Output: "su" 
;-------------------------------------------------------------------------------
Func CalcSub($sFullPath)
	Local $sSub
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcSub Input: ' & $sFullPath & @CRLF)

	$sSub = ExtractFolderName($sFullPath)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcSub Output: ' & $sSub & @CRLF)
	Return $sSub
EndFunc

;-------------------------------------------------------------------------------
; Calculate Parent folder from full path
; Input: "D:/1p/su" -> Output: "D:/1p"
;-------------------------------------------------------------------------------
Func CalcParent($sFullPath)
	Local $sParent
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcParent Input: ' & $sFullPath & @CRLF)

	$sParent = ExtractDirectory($sFullPath)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcParent Output: ' & $sParent & @CRLF)
	Return $sParent
EndFunc

;-------------------------------------------------------------------------------
; Calculate 1file.txt path for MOD0
; Input: parent, sub, idx
; Output: "parent/sub_idx/1file.txt"
;-------------------------------------------------------------------------------
Func Calc1FilePath($sParent, $sSub, $iIdx)
	Local $sOutFolder, $s1File
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Calc1FilePath Input: Parent=' & $sParent & ', Sub=' & $sSub & ', Idx=' & $iIdx & @CRLF)

	$sOutFolder = $sParent & '/' & $sSub & '_' & $iIdx
	$s1File = $sOutFolder & '/1file.txt'

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Calc1FilePath OutFolder: ' & $sOutFolder & @CRLF)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Calc1FilePath Output: ' & $s1File & @CRLF)

	Return $s1File
EndFunc

;-------------------------------------------------------------------------------
; Calculate extraction folder for MOD1
; Input: "D:/1p/su_1014/1file.txt"
; Output: "D:/1p/su_1014/su/"
;-------------------------------------------------------------------------------
Func CalcExtractFolder($s1File)
	Local $sDir, $sFolderName, $sSub, $sExtractFolder
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcExtractFolder Input: ' & $s1File & @CRLF)

	; Extract directory: "D:/1p/su_1014"
	$sDir = ExtractDirectory($s1File)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcExtractFolder Dir: ' & $sDir & @CRLF)

	; Extract folder name: "su_1014"
	$sFolderName = ExtractFolderName($sDir)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcExtractFolder FolderName: ' & $sFolderName & @CRLF)

	; Extract sub from "su_1014" -> "su"
	Local $iPos = StringInStr($sFolderName, '_')
	If $iPos > 0 Then
		$sSub = StringLeft($sFolderName, $iPos - 1)
	Else
		$sSub = $sFolderName
	EndIf
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcExtractFolder Sub: ' & $sSub & @CRLF)

	; Build extraction folder: "D:/1p/su_1014/su"
	$sExtractFolder = $sDir & '/' & $sSub

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcExtractFolder Output: ' & $sExtractFolder & @CRLF)

	Return $sExtractFolder
EndFunc

;-------------------------------------------------------------------------------
; Parse 1file.txt path to get parent, sub, idx
; Input: "D:/1p/su_1014/1file.txt"
; Output: [$sParent, $sSub, $iIdx]
;-------------------------------------------------------------------------------
Func Parse1FilePath($s1File)
	Local $sDir, $sFolderName, $sParent, $sSub, $iIdx, $iPos
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Parse1FilePath Input: ' & $s1File & @CRLF)

	; Extract directory: "D:/1p/su_1014"
	$sDir = ExtractDirectory($s1File)

	; Extract parent: "D:/1p"
	$sParent = ExtractDirectory($sDir)

	; Extract folder name: "su_1014"
	$sFolderName = ExtractFolderName($sDir)

	; Parse sub and idx from "su_1014"
	$iPos = StringInStr($sFolderName, '_')
	If $iPos > 0 Then
		$sSub = StringLeft($sFolderName, $iPos - 1)
		$iIdx = Int(StringMid($sFolderName, $iPos + 1))
	Else
		$iIdx = 0
		$sSub = $sFolderName
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Parse1FilePath Parent: ' & $sParent & @CRLF)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Parse1FilePath Sub: ' & $sSub & @CRLF)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Parse1FilePath Idx: ' & $iIdx & @CRLF)

	Local $aResult[3] = [$sParent, $sSub, $iIdx]
	Return $aResult
EndFunc

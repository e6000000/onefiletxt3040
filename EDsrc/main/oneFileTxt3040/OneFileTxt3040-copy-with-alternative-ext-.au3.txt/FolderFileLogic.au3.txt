;===============================================================================
; FolderFileLogic.au3
; NEW CLEARER folder logic with pack/unpack separate directories
; Structure: p/s_idx/pack/1file.txt and p/s_idx/unpack/s
;===============================================================================
;
; USAGE EXAMPLE:
; --------------
; Input:    D:/myprojects/sourcecode
;   p = getp("D:/myprojects/sourcecode")     => "D:/myprojects"
;   s = gets("D:/myprojects/sourcecode")     => "sourcecode"
;   idx = 152 (from c:/dat/idxq.txt or GUI)
;
; Folder Structure Created:
;   D:/myprojects/sourcecode                          - Original source (codeFolder)
;   D:/myprojects/sourcecode_152/pack/1file.txt       - Packed file (packDir)
;   D:/myprojects/sourcecode_152/unpack/sourcecode    - Extracted files (unpackDir)
;
; Functions:
;   CalcPackPath(p, s, idx)           => "D:/myprojects/sourcecode_152/pack/1file.txt"
;   CalcUnpackPath(p, s, idx)         => "D:/myprojects/sourcecode_152/unpack/sourcecode"
;   ParsePackPath(packPath)           => [p, s, idx]
;   CalcUnpackPathFromPack(packPath)  => "D:/myprojects/sourcecode_152/unpack/sourcecode"
;
;===============================================================================

;-------------------------------------------------------------------------------
; getp - Get parent folder from full path
; Input: "D:/p/s" -> Output: "D:/p"
;-------------------------------------------------------------------------------
Func getp($sFullPath)
	Local $sParent
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' getp Input: ' & $sFullPath & @CRLF)

	$sParent = ExtractDirectory($sFullPath)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' getp Output: ' & $sParent & @CRLF)
	Return $sParent
EndFunc

;-------------------------------------------------------------------------------
; gets - Get subfolder name from full path
; Input: "D:/p/s" -> Output: "s"
;-------------------------------------------------------------------------------
Func gets($sFullPath)
	Local $sSub
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' gets Input: ' & $sFullPath & @CRLF)

	$sSub = ExtractFolderName($sFullPath)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' gets Output: ' & $sSub & @CRLF)
	Return $sSub
EndFunc

;-------------------------------------------------------------------------------
; CalcPackPath - Calculate pack file path
; Input: parent, sub, idx
; Output: "p/s_idx/pack/1file.txt"
;-------------------------------------------------------------------------------
Func CalcPackPath($sParent, $sSub, $iIdx)
	Local $sPackPath
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcPackPath Input: Parent=' & $sParent & ', Sub=' & $sSub & ', Idx=' & $iIdx & @CRLF)

	; Build: p/s_idx/pack/1file.txt
	$sPackPath = $sParent & '/' & $sSub & '_' & $iIdx & '/pack/1file.txt'

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcPackPath Output: ' & $sPackPath & @CRLF)
	Return $sPackPath
EndFunc

;-------------------------------------------------------------------------------
; CalcUnpackPath - Calculate unpack folder path
; Input: parent, sub, idx
; Output: "p/s_idx/unpack/s"
;-------------------------------------------------------------------------------
Func CalcUnpackPath($sParent, $sSub, $iIdx)
	Local $sUnpackPath
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcUnpackPath Input: Parent=' & $sParent & ', Sub=' & $sSub & ', Idx=' & $iIdx & @CRLF)

	; Build: p/s_idx/unpack/s
	$sUnpackPath = $sParent & '/' & $sSub & '_' & $iIdx & '/unpack/' & $sSub

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcUnpackPath Output: ' & $sUnpackPath & @CRLF)
	Return $sUnpackPath
EndFunc

;-------------------------------------------------------------------------------
; ParsePackPath - Parse pack file path to get parent, sub, idx
; Input: "D:/p/s_152/pack/1file.txt"
; Output: [$sParent, $sSub, $iIdx] = ["D:/p", "s", 152]
;-------------------------------------------------------------------------------
Func ParsePackPath($sPackPath)
	Local $sDir, $sFolderWithIdx, $sParent, $sSub, $iIdx, $iPos
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ParsePackPath Input: ' & $sPackPath & @CRLF)

	; Extract directory: "D:/p/s_152/pack"
	$sDir = ExtractDirectory($sPackPath)

	; Extract parent: "D:/p/s_152"
	$sDir = ExtractDirectory($sDir)

	; Extract parent of s_152: "D:/p"
	$sParent = ExtractDirectory($sDir)

	; Extract folder name: "s_152"
	$sFolderWithIdx = ExtractFolderName($sDir)

	; Parse sub and idx from "s_152"
	$iPos = StringInStr($sFolderWithIdx, '_', 0, -1)  ; Find last underscore
	If $iPos > 0 Then
		$sSub = StringLeft($sFolderWithIdx, $iPos - 1)
		$iIdx = Int(StringMid($sFolderWithIdx, $iPos + 1))
	Else
		$sSub = $sFolderWithIdx
		$iIdx = 0
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ParsePackPath Parent: ' & $sParent & @CRLF)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ParsePackPath Sub: ' & $sSub & @CRLF)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' ParsePackPath Idx: ' & $iIdx & @CRLF)

	Local $aResult[3] = [$sParent, $sSub, $iIdx]
	Return $aResult
EndFunc

;-------------------------------------------------------------------------------
; CalcUnpackPathFromPack - Calculate unpack path from pack file path
; Input: "D:/p/s_152/pack/1file.txt"
; Output: "D:/p/s_152/unpack/s"
;-------------------------------------------------------------------------------
Func CalcUnpackPathFromPack($sPackPath)
	Local $aResult, $sParent, $sSub, $iIdx, $sUnpackPath
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcUnpackPathFromPack Input: ' & $sPackPath & @CRLF)

	$aResult = ParsePackPath($sPackPath)
	$sParent = $aResult[0]
	$sSub = $aResult[1]
	$iIdx = $aResult[2]

	$sUnpackPath = CalcUnpackPath($sParent, $sSub, $iIdx)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcUnpackPathFromPack Output: ' & $sUnpackPath & @CRLF)
	Return $sUnpackPath
EndFunc

;===============================================================================
; LEGACY COMPATIBILITY FUNCTIONS (for backward compatibility with old code)
;===============================================================================

;-------------------------------------------------------------------------------
; CalcSub - LEGACY: Use gets() instead
;-------------------------------------------------------------------------------
Func CalcSub($sFullPath)
	Return gets($sFullPath)
EndFunc

;-------------------------------------------------------------------------------
; CalcParent - LEGACY: Use getp() instead
;-------------------------------------------------------------------------------
Func CalcParent($sFullPath)
	Return getp($sFullPath)
EndFunc

;-------------------------------------------------------------------------------
; Calc1FilePath - LEGACY: Use CalcPackPath() instead
; OLD: "parent/sub_idx/1file.txt"
; NEW: "parent/sub_idx/pack/1file.txt"
;-------------------------------------------------------------------------------
Func Calc1FilePath($sParent, $sSub, $iIdx)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' LEGACY Calc1FilePath -> CalcPackPath' & @CRLF)
	Return CalcPackPath($sParent, $sSub, $iIdx)
EndFunc

;-------------------------------------------------------------------------------
; CalcExtractFolder - LEGACY: Use CalcUnpackPathFromPack() instead
; OLD: "D:/p/su_1014/su/"
; NEW: "D:/p/su_1014/unpack/su/"
;-------------------------------------------------------------------------------
Func CalcExtractFolder($s1File)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' LEGACY CalcExtractFolder -> CalcUnpackPathFromPack' & @CRLF)
	Return CalcUnpackPathFromPack($s1File)
EndFunc

;-------------------------------------------------------------------------------
; Parse1FilePath - LEGACY: Use ParsePackPath() instead
;-------------------------------------------------------------------------------
Func Parse1FilePath($s1File)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' LEGACY Parse1FilePath -> ParsePackPath' & @CRLF)
	Return ParsePackPath($s1File)
EndFunc

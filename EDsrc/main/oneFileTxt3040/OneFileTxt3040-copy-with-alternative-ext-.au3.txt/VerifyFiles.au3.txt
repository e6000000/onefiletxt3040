;===============================================================================
; VerifyFiles.au3
; Verify file count and total size
;===============================================================================
 
#include <File.au3>

;-------------------------------------------------------------------------------
; Count files recursively
;-------------------------------------------------------------------------------
Func CountFiles($sPath)
	Local $iCount, $aFiles

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CountFiles: ' & $sPath & @CRLF)

	$iCount = 0
	$aFiles = _FileListToArrayRec($sPath, "*", 1, 1, 0, 2)

	If IsArray($aFiles) Then
		$iCount = $aFiles[0]
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CountFiles Result: ' & $iCount & @CRLF)
	Return $iCount
EndFunc

;-------------------------------------------------------------------------------
; Calculate total size of all files in folder
;-------------------------------------------------------------------------------
Func CalcTotalSize($sPath)
	Local $iTotalSize, $aFiles, $i

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcTotalSize: ' & $sPath & @CRLF)

	$iTotalSize = 0
	$aFiles = _FileListToArrayRec($sPath, "*", 1, 1, 0, 2)

	If IsArray($aFiles) Then
		For $i = 1 To $aFiles[0]
			$iTotalSize += FileGetSize($aFiles[$i])
		Next
	EndIf

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CalcTotalSize Result: ' & $iTotalSize & ' bytes' & @CRLF)
	Return $iTotalSize
EndFunc

;-------------------------------------------------------------------------------
; Verify folder stats (count + size)
; Returns: [iCount, iTotalSize]
;-------------------------------------------------------------------------------
Func GetFolderStats($sPath)
	Local $iCount, $iTotalSize

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' GetFolderStats: ' & $sPath & @CRLF)

	$iCount = CountFiles($sPath)
	$iTotalSize = CalcTotalSize($sPath)

	Local $aStats[2] = [$iCount, $iTotalSize]
	Return $aStats
EndFunc

;-------------------------------------------------------------------------------
; Compare two folders
; Returns: True if same, False if different
; Allows 1 byte difference per file (for text mode differences like CRLF/LF)
;-------------------------------------------------------------------------------
Func CompareFolders($sFolder1, $sFolder2)
	Local $aStats1, $aStats2, $iCount1, $iSize1, $iCount2, $iSize2, $iSizeDiff, $iTolerance

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CompareFolders: ' & $sFolder1 & ' vs ' & $sFolder2 & @CRLF)

	$aStats1 = GetFolderStats($sFolder1)
	$aStats2 = GetFolderStats($sFolder2)

	$iCount1 = $aStats1[0]
	$iSize1 = $aStats1[1]
	$iCount2 = $aStats2[0]
	$iSize2 = $aStats2[1]

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Folder1: Count=' & $iCount1 & ' Size=' & $iSize1 & @CRLF)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Folder2: Count=' & $iCount2 & ' Size=' & $iSize2 & @CRLF)

	; File count must be exactly the same
	If $iCount1 <> $iCount2 Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CompareFolders: DIFFERENT (file count mismatch)' & @CRLF)
		Return False
	EndIf

	; Size can differ by up to 1 byte per file (for text mode, CRLF vs LF, BOM, etc.)
	$iSizeDiff = Abs($iSize1 - $iSize2)
	$iTolerance = $iCount1  ; 1 byte per file

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Size difference: ' & $iSizeDiff & ' bytes, Tolerance: ' & $iTolerance & ' bytes' & @CRLF)

	If $iSizeDiff <= $iTolerance Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CompareFolders: MATCH (within tolerance)' & @CRLF)
		Return True
	Else
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CompareFolders: DIFFERENT (size diff too large)' & @CRLF)
		Return False
	EndIf
EndFunc

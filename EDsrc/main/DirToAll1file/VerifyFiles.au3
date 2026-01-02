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
;-------------------------------------------------------------------------------
Func CompareFolders($sFolder1, $sFolder2)
	Local $aStats1, $aStats2

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CompareFolders: ' & $sFolder1 & ' vs ' & $sFolder2 & @CRLF)

	$aStats1 = GetFolderStats($sFolder1)
	$aStats2 = GetFolderStats($sFolder2)

	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Folder1: Count=' & $aStats1[0] & ' Size=' & $aStats1[1] & @CRLF)
	ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' Folder2: Count=' & $aStats2[0] & ' Size=' & $aStats2[1] & @CRLF)

	If $aStats1[0] = $aStats2[0] And $aStats1[1] = $aStats2[1] Then
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CompareFolders: MATCH' & @CRLF)
		Return True
	Else
		ConsoleWrite(@ScriptFullPath & ' ' & @ScriptLineNumber & ' CompareFolders: DIFFERENT' & @CRLF)
		Return False
	EndIf
EndFunc

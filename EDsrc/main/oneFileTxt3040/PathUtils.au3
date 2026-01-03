;===============================================================================
; PathUtils.au3
; Path normalization and conversion utilities
; All paths stored internally with forward slashes (/)
;===============================================================================

;-------------------------------------------------------------------------------
; Convert path to internal format (forward slashes)
;-------------------------------------------------------------------------------
Func PathToInternal($sPath)
	Return StringReplace($sPath, "\", "/")
EndFunc

;-------------------------------------------------------------------------------
; Convert path for display (forward or backward slashes)
;-------------------------------------------------------------------------------
Func PathToDisplay($sPath, $bUseSlash = True)
	If $bUseSlash Then
		Return StringReplace($sPath, "\", "/")
	Else
		Return StringReplace($sPath, "/", "\")
	EndIf
EndFunc

;-------------------------------------------------------------------------------
; Convert path to OS format (Windows = backslash)
;-------------------------------------------------------------------------------
Func PathToOS($sPath)
	Return StringReplace($sPath, "/", "\")
EndFunc

;-------------------------------------------------------------------------------
; Extract last folder name from path
; Example: "Q:/claude/DirToAll1file" -> "DirToAll1file"
;-------------------------------------------------------------------------------
Func ExtractFolderName($sPath)
	Local $sNormalized = StringReplace($sPath, "\", "/")
	$sNormalized = StringRegExpReplace($sNormalized, "/$", "")
	Local $aMatch = StringRegExp($sNormalized, "([^/]+)$", 1)
	If IsArray($aMatch) Then Return $aMatch[0]
	Return ""
EndFunc

;-------------------------------------------------------------------------------
; Extract filename from path
; Example: "Q:/claude/file.txt" -> "file.txt"
;-------------------------------------------------------------------------------
Func ExtractFileName($sPath)
	Local $sNormalized = StringReplace($sPath, "\", "/")
	Local $aMatch = StringRegExp($sNormalized, "([^/]+)$", 1)
	If IsArray($aMatch) Then Return $aMatch[0]
	Return ""
EndFunc

;-------------------------------------------------------------------------------
; Extract directory from full path
; Example: "Q:/claude/file.txt" -> "Q:/claude"
;-------------------------------------------------------------------------------
Func ExtractDirectory($sPath)
	Local $sNormalized = PathToInternal($sPath)
	Local $iLastSlash = StringInStr($sNormalized, "/", 0, -1)
	If $iLastSlash > 0 Then
		Return StringLeft($sNormalized, $iLastSlash - 1)
	EndIf
	Return ""
EndFunc

;-------------------------------------------------------------------------------
; Apply display mode to path
; Modes: "full" = full path, "folder" = folder name, "file" = filename
;-------------------------------------------------------------------------------
Func ApplyDisplayMode($sFullPath, $sMode)
	Switch $sMode
		Case "folder"
			Return ExtractFolderName($sFullPath)
		Case "file"
			Return ExtractFileName($sFullPath)
		Case Else
			Return PathToDisplay($sFullPath, True)
	EndSwitch
EndFunc

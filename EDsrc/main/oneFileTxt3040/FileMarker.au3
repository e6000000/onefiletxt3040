;===============================================================================
; FileMarker.au3
; File scanning, packing and unpacking with markers
; Business logic independent from GUI
;===============================================================================

#include <File.au3>
#include <Array.au3>
#include "getMarker.au3"
;-------------------------------------------------------------------------------
; Scan folder recursively with extension filter
; Returns: Array of full file paths 
;-------------------------------------------------------------------------------
Func ScanFolder($sPath, $sFilter)
	Local $aFiles[1000], $iCount = 0
	Local $hSearch, $sFile, $aExts, $sFullPath, $aSubFiles, $i, $bMatch, $sExt

	$aExts = StringSplit($sFilter, ".", 1)
	$hSearch = FileFindFirstFile($sPath & "\*.*")

	If $hSearch = -1 Then
		Local $aEmpty[0]
		Return $aEmpty
	EndIf

	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop

		$sFullPath = $sPath & "\" & $sFile

		If @extended Then
			; Directory - recurse
			$aSubFiles = ScanFolder($sFullPath, $sFilter)
			For $i = 0 To UBound($aSubFiles) - 1
				$aFiles[$iCount] = $aSubFiles[$i]
				$iCount += 1
			Next
		Else
			; File - check extension filter
			$bMatch = ($sFilter = "")

			For $i = 1 To $aExts[0]
				$sExt = StringStripWS($aExts[$i], 3)
				If $sExt <> "" And StringRight($sFile, StringLen($sExt)) = $sExt Then
					$bMatch = True
					ExitLoop
				EndIf
			Next

			If $bMatch Then
				$aFiles[$iCount] = $sFullPath
				$iCount += 1
			EndIf
	EndIf
	sleep(6)
	WEnd

	FileClose($hSearch)
	ReDim $aFiles[$iCount]
	Return $aFiles
EndFunc


;-------------------------------------------------------------------------------
; Pack files into single file with markers
; $aFiles: Array of file paths, $s1File: Output file
; $sParent: Parent path (for relative path calculation)
;-------------------------------------------------------------------------------
Func PackFiles($aFiles, $s1File, $sParent, $sSub)
	; $markerbegin =  '////marke' & 'r_begin file '   ;;// a version of many
	Local $markerbegin = getMarkerBegin()
	Local $markerend = getMarkerEnd()

	Local $hOut = FileOpen($s1File, 2)
	If $hOut = -1 Then Return False

	Local $i, $sFilePath, $sContent, $sRelPath
	For $i = 0 To UBound($aFiles) - 1
		$sFilePath = $aFiles[$i]
		$sContent = FileRead($sFilePath)
		; Remove parent/sub from path to get relative path within sub folder
		$sRelPath = StringReplace($sFilePath, $sParent & "\" & $sSub & "\", "")

		FileWrite($hOut, $markerbegin & $sRelPath & @CRLF)
		FileWrite($hOut, $sContent)
		FileWrite($hOut, @CRLF & $markerend & $sRelPath & @CRLF & @CRLF)
	Next

	FileClose($hOut)
	Return True
EndFunc

;-------------------------------------------------------------------------------
; Unpack files from single marker file
; Returns: Number of files extracted
;-------------------------------------------------------------------------------
Func UnpackFiles($s1File, $sOutFolder, $sSub)
	; $markerbegin =  '////marke' & 'r_begin file '   ;;// a version of many
	Local $markerbegin = getMarkerBegin()
	Local $markerend = getMarkerEnd()
	Local $sContent = FileRead($s1File)
	Local $iCount = 0
	Local $aParts = StringSplit($sContent, $markerbegin, 1)

	Local $i, $sPart, $iLineEnd, $sRelPath, $sRest
	Local $iMarkerEnd, $sFileContent, $sOutPath, $sOutDir, $hFile

	For $i = 2 To $aParts[0]
		$sPart = $aParts[$i]

		; Extract filename
		$iLineEnd = StringInStr($sPart, @CRLF)
		If $iLineEnd = 0 Then ContinueLoop

		$sRelPath = StringStripWS(StringLeft($sPart, $iLineEnd - 1), 3)
		$sRest = StringMid($sPart, $iLineEnd + 2)

		; Extract content
		$iMarkerEnd = StringInStr($sRest, $markerend & $sRelPath)
		If $iMarkerEnd = 0 Then ContinueLoop

		$sFileContent = StringLeft($sRest, $iMarkerEnd - 1)

		; Write file
		$sOutPath = $sOutFolder & "\" & $sRelPath
		$sOutDir = StringLeft($sOutPath, StringInStr($sOutPath, "\", 0, -1) - 1)
		If Not FileExists($sOutDir) Then DirCreate($sOutDir)

		If FileExists($sOutPath) Then FileDelete($sOutPath)
		$hFile = FileOpen($sOutPath, 2)
		If $hFile <> -1 Then
			FileWrite($hFile, $sFileContent)
			FileClose($hFile)
			$iCount += 1
		EndIf
	Next

	Return $iCount
EndFunc

;this #include "getMarker.au3"
#include <File.au3>
#include <Array.au3>
Func getMarkerBegin() 
	; $markerbegin & $sRelPath
	$markerbegin =  '////marke' & 'r_begin file '
	Return $markerbegin
EndFunc
Func getMarkerEnd()
	; $markerend & $sRelPath
	$markerEnd = '////marke' & 'r_end file '
	Return $markerEnd
EndFunc
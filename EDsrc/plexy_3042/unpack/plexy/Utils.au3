;Utils.au3
Func s2a($s, $delim = "|")
    Return StringSplit($s, $delim, 3) ; 1 Variant bleibt
EndFunc
Func a2s($a, $delim = "|")
    Return _ArrayToString($a, $delim) ; str2ar etc. delete
EndFunc
Func sSub($s, $filter, $delim = ".")
    Local $a = s2a($s, $delim)
    ; filter logic ? 20 Z
    Return a2s($a)
EndFunc

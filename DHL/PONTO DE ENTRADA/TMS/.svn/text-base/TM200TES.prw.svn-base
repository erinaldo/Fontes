
User Function TM200TES

If IsInCallStack("U_DTMS004") .OR. IsInCallStack("U_GCTE01THR")
	_xTes := iif(Empty(X8_XTES),ParamIxb[4],X8_XTES)
Else
	_xTes := ParamIxb[4]
EndIf

Return(_xTes)
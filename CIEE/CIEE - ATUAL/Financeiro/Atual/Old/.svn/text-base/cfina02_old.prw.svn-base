#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA02   º Autor ³ Felipe Raposo      º Data ³  27/05/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Alteracao do historico do cheque para a quebra de linha    º±±
±±º          ³ antes da impressao do cheque especial.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE - Financeiro                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CFINA02()
Local _cHist
dbSelectArea("SEF")
Set Filter To empty(EF_IMPRESS)
SEF->(dbGoTop())
Do While SEF->(!eof())
	_cHist := CFINA02a()
	RecLock("SEF", .F.)
	SEF->EF_HIST := _cHist
	SEF->(msUnLock())
	SEF->(dbSkip())
EndDo
FINR460()  // Cheques especiais (padrao do sistema).
Set Filter To
Return

// Quebra a linha do historico.
Static Function CFINA02a()
Local _nTamLin, _nIniLin2, _cHist, _cRet
_nTamLin  := 76  // Tamanho da primeira linha.
_nIniLin2 := 83  // Posicao do primeiro caractere que sera impresso na segunda linha.
_cHist    := SEF->EF_HIST
_nAux1 := rat(" ", SubStr(_cHist, 1, _nTamLin))
_cRet := SubStr(_cHist, 1, _nAux1 - 1)
_cRet += Space(_nIniLin2 - _nAux1)
_cRet += AllTrim(SubStr(_cHist, _nAux1 + 1, _nTamLin))
Return (_cRet)
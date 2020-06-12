#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA02   � Autor � Felipe Raposo      � Data �  27/05/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Alteracao do historico do cheque para a quebra de linha    ���
���          � antes da impressao do cheque especial.                     ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE - Financeiro                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
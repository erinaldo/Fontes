
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Microsiga           � Data �  05/28/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para tratar linhas do CNAB onde a expressao nao     ���
���          � coube na configuracao do SISPAG                            ���
�������������������������������������������������������������������������͹��
���Uso       � ES  - Estapar                                              ���
���Uso       � FIN - Financeiro                                           ���
���Uso       � E   - Execblock                                            ���
���Uso       � 01  - Sequencia                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ESFINE01(_nPos)

Private _cRet	:= ""

If _nPos == "1"
	//Detalhe Segmento A posicao 024-028
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), STRZERO(VAL(SA2->A2_AGENCIA),5), U_RETINTERM(2,"001") )
ElseIf _nPos == "2"
	//Detalhe Segmento A posicao 030-041
	_cRet := IIF(EMPTY(SA2->A2_XRELINT),STRZERO(VAL(SA2->A2_NUMCON),12), U_RETINTERM(3,"001"))
ElseIf _nPos == "3"
	//Detalhe Segmento B posicao 018-018
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), IIF(SA2->A2_TIPO=="F","1","2"), U_RETINTERM(6))
ElseIf _nPos == "4"
	//Detalhe Segmento B posicao 019-032
	_cRet := IIF(EMPTY(SA2->A2_XRELINT),STRZERO(VAL(SA2->A2_CGC),14), U_RETINTERM(5))
ElseIf _nPos == "5"
	//Detalhe Segmento B posicao 033-062
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), SUBSTR(SA2->A2_END,1,30), U_RETINTERM(7))
ElseIf _nPos == "6"
	//Detalhe Segmento B posicao 063-067
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), STRZERO(VAL(SA2->A2_NR_END),5), U_RETINTERM(12))
ElseIf _nPos == "7"
	//Detalhe Segmento B posicao 068-082
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), SUBSTR(SA2->A2_ENDCOMP,1,15), U_RETINTERM(13))
ElseIf _nPos == "8"
	//Detalhe Segmento B posicao 083-097
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), SUBSTR(SA2->A2_BAIRRO,1,15), U_RETINTERM(8))
ElseIf _nPos == "9"
	//Detalhe Segmento B posicao 098-117
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), SUBSTR(SA2->A2_MUN,1,20), U_RETINTERM(9))
ElseIf _nPos == "10"
	//Detalhe Segmento B posicao 118-125
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), SUBSTR(SA2->A2_CEP,1,8), U_RETINTERM(10))
ElseIf _nPos == "11"
	//Detalhe Segmento B posicao 126-127
	_cRet := IIF(EMPTY(SA2->A2_XRELINT), SA2->A2_EST, U_RETINTERM(11))
ElseIf _nPos == "12"
	//Detalhe Segmento B posicao 128-135
	_cRet := SUBSTR(GRAVADATA(SE2->E2_VENCREA,.F.),1,4) + STR(YEAR(SE2->E2_VENCREA),4)
ElseIf _nPos == "13"
	//Detalhe Segmento B posicao 136-150
	_cRet := STRZERO(INT(NOROUND((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE)*100)),15)
EndIf

Return(_cRet)
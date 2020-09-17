#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINEBBS  ºAutor  ³Anderson C. P. Coelho º Data ³  20/12/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Execblock de cálculo do Nosso Número para o Banco do Brasilº±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus12                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFINEBBS(NOSSONUM,_cDVNN,_lContin,_cRotina)

Local _aSavArea  := GetArea()
Local _aSeq      := {9,8,7,6,5,4,3,2}
Local _nSeq      := 0
Local _nRegCont  := 0
Local _nSomaDg   := 0
Local _nResto    := ""
Local _x         := 0
Default NOSSONUM := ""
Default _cDVNN   := ""
Default _lContin := .T.
Default _cRotina := "RFINEBBS"

dbSelectArea("SEE")
_aSavSEE := SEE->(GetArea())
dbSelectArea("SE1")
_aSavSE1 := SE1->(GetArea())
If !Empty(SE1->E1_NUMBCO)
	NOSSONUM := Alltrim(SEE->EE_CODEMP)+AllTrim(SE1->E1_NUMBCO)		//Por hora, sem o dígito verificador, que ainda será calculado
Else
	If Empty(SEE->EE_FAXATU)
		If Empty(SEE->EE_FAXINI)
			MsgAlert("Atenção! A faixa atual e inicial não estão preenchidas nos parâmetros de Bancos. Não será possível definir o Nosso Número para o título " + SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA + ". Solicite a correção da informação neste cadastro de parâmetros de Bancos, antes de prosseguir!",_cRotina+"_008")
			_lContin := .F.
		Else
			dbSelectArea("SEE")
			RecLock("SEE",.F.)
			SEE->EE_FAXATU := SEE->EE_FAXINI
			SEE->(MSUNLOCK())
		EndIf
	EndIf
	If _lContin
		_nQtPos := Len(AllTrim(SEE->EE_FAXATU))
		_cNewSq := StrZero(VAL(SEE->EE_FAXATU)+1,_nQtPos)
		If Val(_cNewSq) > Val(SEE->EE_FAXFIM)
			MsgStop("A sequência do Nosso Número irá atingir a faixa máxima permitida. Portanto, ela será reiniciada para " + SEE->EE_FAXINI + "!",_cRotina+"_009")
			If Empty(SEE->EE_FAXINI)
				MsgAlert("Atenção! A faixa inicial não estão preenchidas nos parâmetros de Bancos. Não será possível definir o Nosso Número para o título " + SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA + ". Portanto, este não será impresso. Solicite a correção da informação neste cadastro de parâmetros de Bancos, antes de prosseguir!",_cRotina+"_010")
				_lContin := .F.
			Else
				_cNewSq := SEE->EE_FAXINI
			EndIf
		EndIf
		If _lContin
			RecLock("SEE",.F.)
			SEE->EE_FAXATU := _cNewSq
			SEE->(MsUnLock())
			NOSSONUM := Alltrim(SEE->EE_CODEMP)+AllTrim(_cNewSq)			//Por hora, sem o dígito verificador, que ainda será calculado
		EndIf
	EndIf
EndIf
If Empty(NOSSONUM)
	MsgAlert("Atenção! Não foi possível calcular o Nosso Número para o título " + SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA + ". Portanto, este não será impresso!",_cRotina+"_011")
	_lContin  := .F.
ElseIf _lContin .AND. Len(Alltrim(SEE->EE_CODEMP)) > 6		//Só calculo o dígito verificador para Números de Convênio com menos de 7 dígitos
	If VAL(SubStr(NOSSONUM,Len(Alltrim(SEE->EE_CODEMP))+1)) <= 1000000
		_nRegCont := Len(AllTrim(NOSSONUM))
		For _x := 1 To _nRegCont
			If _nSeq==Len(_aSeq)
				_nSeq := 0
			EndIf
			_nSeq++
			_nSomaDg += VAL(SubStr(AllTrim(NOSSONUM),((_nRegCont-_x)+1),1))*_aSeq[_nSeq]
		Next
		_nCont1   := INT(_nSomaDg/11)
		_nCont2   := _nCont1 * 11
		_nResto   := _nSomaDg - _nCont2
		If _nResto == 10
			_nResto := "X"
		ElseIf _nResto == 11
			_nResto := "0"
		Else
			_nResto := StrZero(_nResto,1)
		EndIf
	EndIf
	NOSSONUM  := AllTrim(NOSSONUM)
	_cDVNN    := _nResto
EndIf

RestArea(_aSavSE1)
RestArea(_aSavSEE)
RestArea(_aSavArea)

Return(NOSSONUM,_cDVNN,_lContin)
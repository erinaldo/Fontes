#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTB350EF  º Autor ³ Claudio Barros     º Data ³  16/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para liberacao dos titulos do             º±±
±±º          ³ contas a pagar na efetivacao dos lancamentos               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE - CTB                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CTB350EF()

Local _cAlias1 := GetArea()
Local _lRet    := .T.
Local _cChave  := SPACE(23)
Local _cDocKey  := " "

_cDtEmiss 	:= ""
_cFilial 	:= ""
_cPrefixo 	:= ""
_cNumero 	:= ""
_cParcela 	:= ""
_cTipo 		:= ""
_cFornece 	:= ""
_cLOja 		:= ""

Private cString := "CT2"

Pergunte("CTB350    ",.F.)
dbSelectArea("CT2")
dbSetOrder(1)

If  Alltrim(CT2->CT2_KEY)<> _cDocKey
	_cDocKey := Alltrim(CT2->CT2_KEY)
	//XFILIAL("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	If Alltrim(CT2_ROTINA) == "FINA050"  .AND. !EMPTY(CT2->CT2_KEY)  // Contas a Pagar Inclusao Titulos
		DbSelectArea("SE2")
//		SE2->(DbSetOrder(16)) //EMISSAO + FORNECEDOR + LOJA + PREFIXO + NUMERO
		SE2->(DbSetOrder(6)) //FORNECEDOR + LOJA + PREFIXO + NUMERO + PARCELA + TIPO
		SE2->(DbGoTop())

		_cDtEmiss := CT2->CT2_DATA
		_cFilial 	:= SUBS(CT2->CT2_KEY,01,2)
		_cPrefixo 	:= SUBS(CT2->CT2_KEY,03,3)
		If Len(Alltrim(CT2->CT2_KEY)) == 23 // Titulos Antigos 6 posicoes E2_NUM
			_cNumero 	:= SUBS(CT2->CT2_KEY,06,6)
			_cParcela 	:= SUBS(CT2->CT2_KEY,12,1)
			_cTipo 		:= SUBS(CT2->CT2_KEY,13,3)
			_cFornece 	:= SUBS(CT2->CT2_KEY,16,6)
			_cLOja 		:= SUBS(CT2->CT2_KEY,22,2)
		ElseIf Len(Alltrim(CT2->CT2_KEY)) == 26 // Titulos Novos 9 posicoes E2_NUM
			_cNumero 	:= SUBS(CT2->CT2_KEY,06,9)
			_cParcela 	:= SUBS(CT2->CT2_KEY,15,1)
			_cTipo 		:= SUBS(CT2->CT2_KEY,16,3)
			_cFornece 	:= SUBS(CT2->CT2_KEY,19,6)
			_cLOja 		:= SUBS(CT2->CT2_KEY,25,2)
		EndIf

//		_cChave := DTOS(_cDtEmiss)+_cFornece+_cLOja+_cPrefixo+_cNumero 
		_cNumero := iif(Len(_cNumero)<9, _cNumero+Space(3), _cNumero)
		_cChave  := _cFornece+_cLOja+_cPrefixo+_cNumero+_cParcela+_cTipo

		If SE2->(DbSeek(xFilial("SE2")+_cChave))
			While SE2->E2_FILIAL == xFilial("SE2")  ;
				.and. SE2->E2_FORNECE 	== _cFornece  ;
				.and. SE2->E2_LOJA 		== _cLOja  ;
				.and. SE2->E2_PREFIXO 	== _cPrefixo  ;
                .and. SE2->E2_TIPO 		== _cTipo  ;
				.and. SE2->E2_PARCELA 	== _cParcela  ;
				.and. SE2->E2_NUM     	== _cNumero
//		Tirado o campo Emissao pois no caso do Financeiro nao podemos utilizar este campo			
//				.and. SE2->E2_EMISSAO == _cDtEmiss  ;

				IF EMPTY(SE2->E2_DATALIB)
					Reclock("SE2",.F.)
					SE2->E2_DATALIB := dDATABASE
					SE2->E2_USUALIB := SUBS(CUSUARIO,7,15)
					SE2->(MsUnlock())
				ENDIF
				SE2->(DBSKIP())
			EndDo
		EndIf
	EndIf

	If Alltrim(CT2->CT2_ROTINA) == "MATA103" .AND. !EMPTY(CT2->CT2_KEY)  // Nota Fiscal de Entrada
		//XFILIAL("SD1")+D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA
		_cFilial 	:= SUBS(CT2->CT2_KEY,01,2)
		_cPrefixo 	:= SUBS(CT2->CT2_KEY,03,3) //Serie
		If Len(Alltrim(CT2->CT2_KEY)) == 19 // Titulos Antigos 6 posicoes E2_NUM
			_cNumero 	:= SUBS(CT2->CT2_KEY,06,6) //Doc
			_cFornece 	:= SUBS(CT2->CT2_KEY,12,6)
			_cLOja 		:= SUBS(CT2->CT2_KEY,18,2)
		ElseIf Len(Alltrim(CT2->CT2_KEY)) == 22 // Titulos Novos 9 posicoes E2_NUM
			_cNumero 	:= SUBS(CT2->CT2_KEY,06,9) //Doc
			_cFornece 	:= SUBS(CT2->CT2_KEY,15,6)
			_cLOja 		:= SUBS(CT2->CT2_KEY,21,2)
		EndIf

        DbSelectArea("SF1")
        SF1->(DbSetorder(1)) //FILIAL + DOCUMENTO + SERIE + FORNECEDOR + LOJA
        SF1->(DbGotop())
		_cNumero := iif(Len(_cNumero)<9, _cNumero+Space(3), _cNumero)
        SF1->(DbSeek(xFilial("SF1")+_cNumero+_cPrefixo+_cFornece+_cLOja))

        _cDtEmiss := SF1->F1_EMISSAO 

		_cChave := DTOS(_cDtEmiss)+_cFornece+_cLOja+_cPrefixo+_cNumero 
		
		DbSelectArea("SE2")
		SE2->(DbSetOrder(16)) //EMISSAO + FORNECEDOR + LOJA + PREFIXO + NUMERO
		SE2->(DbGoTop())
		
		If SE2->(DbSeek(xFilial("SE2")+_cChave))

			While SE2->E2_FILIAL == xFilial("SE2")  ;
				.and. SE2->E2_EMISSAO == _cDtEmiss  ;
				.and. SE2->E2_FORNECE == _cFornece  ;
				.and. SE2->E2_PREFIXO == _cPrefixo  ;
				.and. SE2->E2_NUM     == _cNumero
				
				IF EMPTY(SE2->E2_DATALIB)
					Reclock("SE2",.F.)
					SE2->E2_DATALIB := dDATABASE
					SE2->E2_USUALIB := SUBS(CUSUARIO,7,15)
					SE2->(MsUnlock())
				ENDIF
				SE2->(DBSKIP())
			End
		ENDIF
	ENDIF
EndIf

Restarea(_cAlias1)

Return
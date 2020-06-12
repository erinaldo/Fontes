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

Private cString := "CT2"

Pergunte("CTB350",.F.)

_cReg := CT2->(Recno())
DbSelectArea("TST")
If !(DbSeek(alltrim(strzero(_cReg,6))+CT2->CT2_LOTE+CT2->CT2_DOC))
	CT2->(DbSkip())
EndIf 

dbSelectArea("CT2")
dbSetOrder(1)

If  Alltrim(CT2->CT2_KEY)<> _cDocKey
	_cDocKey := Alltrim(CT2->CT2_KEY)
	If Alltrim(CT2_ROTINA) == "FINA050"  .AND. !EMPTY(CT2->CT2_KEY)  // Contas a Pagar Inclusao Titulos
		_cChave := SUBS(CT2->CT2_KEY,3,21)
		DbSelectArea("SE2")
		SE2->(DbSetOrder(1))
		SE2->(DbGoTop())
		If SE2->(DbSeek(xFilial("SE2")+_cChave))
			IF EMPTY(SE2->E2_DATALIB)
				Reclock("SE2",.F.)
				SE2->E2_DATALIB := dDATABASE
				SE2->E2_USUALIB := SUBS(CUSUARIO,7,15)
				SE2->(MsUnlock())
			ENDIF
		ENDIF
	Endif
	
	If Alltrim(CT2->CT2_ROTINA) == "MATA103" .AND. !EMPTY(CT2->CT2_KEY)  // Contas a Pagar Inclusao Titulos
        _cChave := SUBS(CT2->CT2_KEY,3,3)+SUBS(CT2->CT2_KEY,6,6)+SUBS(CT2->CT2_KEY,12,6)+SUBS(CT2->CT2_KEY,18,2) 

        DbSelectArea("SF1")
        SF1->(DbSetorder(1))
        SF1->(DbGotop())
        SF1->(DbSeek(xFilial("SF1")+SUBS(CT2->CT2_KEY,6,6)+SUBS(CT2->CT2_KEY,3,3)+SUBS(CT2->CT2_KEY,12,6)+SUBS(CT2->CT2_KEY,18,2)))

        _cChave := DTOS(SF1->F1_EMISSAO)+SUBS(CT2->CT2_KEY,12,6)+SUBS(CT2->CT2_KEY,18,2)+SUBS(CT2->CT2_KEY,3,3)+SUBS(CT2->CT2_KEY,6,6) 
		
		DbSelectArea("SE2")
		SE2->(DbSetOrder(16))
		SE2->(DbGoTop())
		
		If SE2->(DbSeek(xFilial("SE2")+_cChave))
			
			_dDataTos := SUBS(CT2->CT2_KEY,3,8)
            _cDtEmiss := SF1->F1_EMISSAO 
			_cFornece := SUBS(CT2->CT2_KEY,12,6)
			_cLOja    := SUBS(CT2->CT2_KEY,18,2)
			_cPrefixo := SUBS(CT2->CT2_KEY,3,3)
			_cNumero  := SUBS(CT2->CT2_KEY,6,6)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso o titulo possua outras paracelas, a rotina fara a liberacao apenas do primeiro titulo sem data de liberacao. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
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
					EXIT
				ENDIF
				SE2->(DBSKIP())
			End
		ENDIF
	ENDIF
EndIf

Restarea(_cAlias1)

Return
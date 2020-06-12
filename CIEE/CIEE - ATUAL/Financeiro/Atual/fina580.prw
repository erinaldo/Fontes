#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA580   ºAutor  ³Felipe Raposo       º Data ³  05/07/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para a liberacao dos titulos a pagar por  º±±
±±º          ³ dois usuarios.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FINA580()
Local _cUserCod, _cMsg, _aAreaZ2
_aAreaZ2 := SZ2->(GetArea())
_cUserCod := RetCodUsr()  // USRRETNAME(RETCODUSR())
SZ2->(dbSetOrder(1))  // Z2_FILIAL+Z2_CODUSR
If SZ2->(dbSeek(xFilial("SZ2") + _cUserCod,.F.))
	LibTit()
Else
	_cMsg := "Esse usuario nao esta cadastrado na tabela de liberadores."
	MsgBox(_cMsg, "Atencao", "ALERT")
Endif
VerLib()
SZ2->(RestArea(_aAreaZ2))
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que executa a liberacao do titulo pelo usuario cor-  ³
//³ rente.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function LibTit()
Local _cMsg

If upper(AllTrim(SE2->E2_USUALIB)) $ upper(AllTrim(SE2->(E2_USRLIB1 + E2_USRLIB2)))
	_cMsg := "Titulo ja liberado por esse usuario!"
	MsgBox(_cMsg, "Titulo " + SE2->(E2_TIPO + E2_NUM), "ALERT")
Else
	RecLock("SE2", .F.)
	If empty(SE2->E2_DTLIB1) .and. NivelOK(SE2->E2_NIVUSR2)
		SE2->E2_DTLIB1  := SE2->E2_DATALIB
		SE2->E2_USRLIB1 := SE2->E2_USUALIB
		SE2->E2_NIVUSR1 := SZ2->Z2_NIVEL
	ElseIf empty(SE2->E2_DTLIB2) .and. NivelOK(SE2->E2_NIVUSR1)
		SE2->E2_DTLIB2  := SE2->E2_DATALIB
		SE2->E2_USRLIB2 := SE2->E2_USUALIB
		SE2->E2_NIVUSR2 := SZ2->Z2_NIVEL
	Endif
	SE2->(msUnLock())
Endif
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario pode fazer a liberacao do pedido.     ³
//³                                                             ³
//³ Retorna .T. caso ele seja o primeiro liberador ou ele tenha ³
//³ o nivel que lhe de o privilegio para fazer a liberacao ou   ³
//³ .F. para bloquear a liberacao.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function NivelOK(_cNivAtu)
Local _lRet, _cMsg
If !(_lRet := ((empty(_cNivAtu) .or. "A" $ (_cNivAtu + SZ2->Z2_NIVEL))))
	_cMsg := "Esse titulo ja se encontra liberado por um usuario nivel B."
	MsgBox(_cMsg, "Titulo " + SE2->(E2_TIPO + E2_NUM), "ALERT")
Endif
Return (_lRet)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que verifica se o titulo deve ou nao estar libera-  ³
//³ do para o sistema, levando em consideracao a customizacao  ³
//³ de estar liberado por dois usuarios.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function VerLib()
If (empty(SE2->E2_DTLIB1) .or. empty(SE2->E2_DTLIB2)) .or.;
	!("A" $ SE2->(E2_NIVUSR1 + E2_NIVUSR2))
	RecLock("SE2", .F.)
	SE2->E2_DATALIB := ctod("  /  /  ")
	//SE2->E2_USUALIB := ""
	SE2->(msUnLock())
Endif
Return
#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT110Blo  บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para alinhar a aprovacao via menu com a   บฑฑ
ฑฑบ          ณ do Workflow.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT110Blo()

Local aAreaAnt := GetArea()
Local aAreaSC1 := SC1->( GetArea() )
Local aRegs    := {}, _aReturn
Local cPerg    := "mt110b", cTxtBlq, _cPar01 := ''
Local cBkIDAp  := __cUSerID
Local _lReturn := .t.

If __cUSerID # SC1->C1_XAPROV
   Aviso('Acesso Negado','Voce nใo ้ o aprovador desta Solicita็ใo.',{'Voltar'})
   Return(.f.)
EndIf

aAdd(aRegs,{cPerg,"01","Observacao.........:","","","mv_ch2","C",40,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aRegs )

Pergunte( cPerg,.t. )

DbSelectArea('SCR')
DbSetOrder(2) // CR_FILIAL+CR_TIPO+CR_NUM+CR_USER
If DbSeek( xFilial('SCR')+'SC'+PadR(SC1->C1_NUM,TamSX3("CR_NUM")[1]," ")+__cUserId )
	
	If ParamIxb[1] == 1 // Aprovacao
		cStatus := "03"
	Else             // Bloquear ou Rejeitar
		cStatus := "04"
	EndIf
	
	If ParamIxb[1] == 1 // Aprovacao
		
		// Sergio em Ago/2007: Caso a rotina automatica retorne algum erro, o procedimento 
		// de aprovacao devera ser revertido:
		_cPar01  := MV_PAR01
		_aReturn := U_PedCom(SC1->C1_NUM)
		If _aReturn[1][1] == 'F'
		
		    _lReturn := .f.

			cExec := " UPDATE "+RetSqlName('SC1')+" SET C1_CONAPRO = 'B', C1_APROV = 'B' "
			cExec += " WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
			cExec += " AND   C1_NUM = '"+SC1->C1_NUM+"' "
			cExec += " AND   D_E_L_E_T_ = ' ' "
			TcSqlExec( cExec )

			SCR->( RecLock('SCR',.f.) )
			SCR->CR_X_OBS   := "Problema na Rotina Automatica"
			SCR->CR_STATUS  := "02"
			SCR->CR_DATALIB := Ctod('')
			SCR->( MsUnLock() )
			
			cTxtBlq := "Houve um problema na tentativa de gera็ใo automแtica do Pedido de Compras  "
			cTxtBlq += "referente a esta Solicita็ใo. Esta solicita็ใo de compras permanecerแ "
			cTxtBlq += "bloqueada at้ que a situa็ใo seja normalizada. Entre em contato com a "
			cTxtBlq += "แrea responsแvel pela normaliza็ใo desta situa็ใo."
			
			While .t.
				If Aviso("Gera็ใo de Pedidos Automแticos",cTxtBlq,;
					{"Ver Erro","&Fechar"},3,"Problemas na Gera็ใo",,;
					"PCOLOCK") == 1
					_cDsc := MemoRead( _aReturn[1][2] )
					ExibLog( _cDsc )
				Else
				    Exit
				EndIf
			EndDo

		Else
		
		    _lReturn := .t.

			RecLock('SCR',.f.)
			SCR->CR_X_OBS   := "(Aprovador) "+_cPar01
			SCR->CR_STATUS  := cStatus
			SCR->CR_DATALIB := Date()
			MsUnLock()
	
			cExec := " UPDATE "+RetSqlName('SC1')+" SET C1_CONAPRO = 'L', C1_APROV = 'L' "
			cExec += " WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
			cExec += " AND   C1_NUM = '"+SC1->C1_NUM+"' "
			cExec += " AND   D_E_L_E_T_ = ' ' "
		
			TcSqlExec( cExec )
		EndIf
		
	Else // Bloquear ou Rejeitar
		cExec := " UPDATE "+RetSqlName('SC1')+" SET C1_CONAPRO = 'B', C1_APROV = 'B' "
		cExec += " WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
		cExec += " AND   C1_NUM = '"+SC1->C1_NUM+"' "
		cExec += " AND   D_E_L_E_T_ = ' ' "
		
		TcSqlExec( cExec )

	    _lReturn := .f.
		
		SCR->( RecLock('SCR',.f.) )
		SCR->CR_X_OBS   := "(Aprovador) "+MV_PAR01
		SCR->CR_STATUS  := cStatus
		SCR->CR_DATALIB := Date()
		SCR->( MsUnLock() )
	EndIf
	
EndIf

__cUserId := cBkIDAp

Pergunte('MTA110',.f.)

SC1->( RestArea( aAreaSC1 ) )

RestArea( aAreaAnt )

Return(_lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหอออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ExibLog  บAutor  ณ Sergio Oliveira     บData ณ Ago/2006    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibir a ocorrencia do problema r alguma informacao.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ponto de Entrada M110Tok.prw                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExibLog(pcDscLog)

Private cTitulo := "Houve problema na tentativa de geracao do Pedido de Compras"

@ 065,025 To 516,691 Dialog mkwdlg Title cTitulo
@ 007,008 To 207,272 Title "Descricao do Problema"
@ 023,019 Get pcDscLog MEMO Size 242,177 When .t.
@ 100,280 Button OemToAnsi("_Sair")     Size 43,16 Action(Close(MkwDlg))

Activate Dialog mkwdlg Centered

Return
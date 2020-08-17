#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

// Funcoes - para Workflow
//
// WFAlcDoc(ExpA1,ExpD1,ExpN1)
// Ped01(_aParam) - _aParam -> cFilial , nOper
/*
USER FUNCTION WF()
U_SC({'99',1})
*/
USER FUNCTION WF0()
U_sc({'99',2})    // resposta

USER FUNCTION WF1()
U_sc({'99',3})    // resposta

USER FUNCTION WF2()
U_sc({'99',5})    // PC REPROVADOS

USER FUNCTION WF3()
U_PC({'99',1})    // resposta

USER FUNCTION WF4()
U_PC({'99',2})  // Sergio - Retirar p/ colocar na Vastera

USER FUNCTION WF6()
U_PC({'99',3})  // Sergio - Retirar p/ colocar na Vastera

USER FUNCTION WF7()
U_SENDMAIL({'01'})

//------------------------------------------------------------------------
// ENVIO DE EMAIL
//------------------------------------------------------------------------

USER FUNCTION SENDMAIL(aParam)
If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_CONSOLE("Parametros nao recebidos => SENDMAIL(cEmp)" )
	RETURN
EndIf

U_CONSOLE('SENDMAIL() /' + aParam[1] )

WFSENDMAIL({aParam[1],"01"})
RETURN

//------------------------------------------------------------------------
// RETORNO DO WORKFLOW
//------------------------------------------------------------------------

USER FUNCTION RECMAIL( aParam )
IF aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_CONSOLE("Parametros nao recebidos => RECMAIL()")
	RETURN
EndIf

U_CONSOLE('RECMAIL() /' + aParam[1] )

WFReturn({aParam[1],"01"})
RETURN


//------------------------------------------------------------------------
// SEMAFORO
//------------------------------------------------------------------------

USER FUNCTION SEMAFORO(cArq, nOpc)
Local nHdl
Local cDataTime := Space(30)

IF cArq == Nil .OR. nOpc == Nil
	U_CONSOLE("SEMAFORO - Sem parametros")
	RETURN
ENDIF

IF nOpc == 1	// CRIA
	While .T.
		
		IF !FILE(cArq)
			nHdl:=MSFCREATE(cArq,0)
			cDataTime := DTOC(DATE()) + " " + TIME()
			fWRITE(nHdl,cDataTime,Len(cDataTime))
			FCLOSE(nHdl)
			EXIT
		ENDIF
		
		For _nCtd := 1 TO 1000000
		Next
	END
ENDIF
IF nOpc == 2	// REMOVE
	IF File(cArq)
		fErase(cArq)
	ENDIF
ENDIF
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PG       บAutor  ณMicrosiga           บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WORKFLOW Solicitacao de Compras                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PG( aParam )

If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_CONSOLE("Parametros nao recebidos => PG()" )
	RETURN
EndIf

WfPrepEnv( aParam[1], "01" )

CHKFILE("SM0")

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(aParam[1],.F.)

U_CONSOLE('PG() /' + aParam[1] )

WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1]
	cFilAnt	:= SM0->M0_CODFIL
	
	U_CONSOLE('PG() /' + aParam[1] + cFilAnt)
	
	U_Rfinw01(aParam[2])
	SM0->(DBSkip())
END

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SC       บAutor  ณMicrosiga           บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WORKFLOW Solicitacao de Compras                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SC( aParam )

If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_CONSOLE("Parametros nao recebidos => SC()" )
	RETURN
EndIf

WfPrepEnv( aParam[1], "01" )

CHKFILE("SM0")

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(aParam[1],.F.)

U_CONSOLE('SC() /' + aParam[1] )

WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1]
	cFilAnt	:= SM0->M0_CODFIL
	
	U_CONSOLE('SC() /' + aParam[1] + cFilAnt)
	
	U_Rcomw04(aParam[2])
	SM0->(DBSkip())
END

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PC       บAutor  ณMicrosiga           บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WORKFLOW Pedidos de Compras                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PC( aParam )

If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_CONSOLE("Parametros nao recebidos => PC()" )
	RETURN
EndIf

WfPrepEnv( aParam[1], "01" )

CHKFILE("SM0")

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(aParam[1],.F.)

U_CONSOLE('PC() /' + aParam[1] )

WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1]
	cFilAnt	:= SM0->M0_CODFIL
	
	U_CONSOLE('PC() /' + aParam[1] + cFilAnt)
	
	U_Rcomw01(aParam[2])
	SM0->(DBSkip())
END

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MAAlcDoc Autor ณ Aline Correa do Vale   ณ  Data ณ07.08.2001ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ WFAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1)                     	  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpA1 = Array com informacoes do documento                 ณฑฑ
ฑฑณ          ณ       [1] Numero do documento                              ณฑฑ
ฑฑณ          ณ       [2] Tipo de Documento                                ณฑฑ
ฑฑณ          ณ       [3] Valor do Documento                               ณฑฑ
ฑฑณ          ณ       [4] Codigo do Aprovador                              ณฑฑ
ฑฑณ          ณ       [5] Codigo do Usuario                                ณฑฑ
ฑฑณ          ณ       [6] Grupo do Aprovador                               ณฑฑ
ฑฑณ          ณ       [7] Aprovador Superior                               ณฑฑ
ฑฑณ          ณ       [8] Moeda do Documento                               ณฑฑ
ฑฑณ          ณ       [9] Taxa da Moeda                                    ณฑฑ
ฑฑณ          ณ      [10] Data de Emissao do Documento                     ณฑฑ
ฑฑณ          ณ      [11] Grupo de Compras                                 ณฑฑ
ฑฑณ          ณ ExpD1 = Data de referencia para o saldo                    ณฑฑ
ฑฑณ          ณ ExpN1 = Operacao a ser executada                           ณฑฑ
ฑฑณ          ณ       1 = Inclusao do documento                            ณฑฑ
ฑฑณ          ณ       2 = Estorno do documento                             ณฑฑ
ฑฑณ          ณ       3 = Exclusao do documento                            ณฑฑ
ฑฑณ          ณ       4 = Aprovacao do documento                           ณฑฑ
ฑฑณ          ณ       5 = Estorno da Aprovacao                             ณฑฑ
ฑฑณ          ณ       6 = Bloqueio Manual da Aprovacao                     ณฑฑ
ฑฑณ          ณ ExpC1 = Respondido a 1 Vez ou a 2						  ณฑฑ
ฑฑณ          ณ ExpB1 = Chamado via Menu do Sistema .T. or .F.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MAAlcDoc(aDocto,dDataRef,nOper, cWF, lMENU)

Local cDocto	:= aDocto[1]
Local cTipoDoc	:= aDocto[2]
Local nValDcto	:= aDocto[3]
Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
Local aArea		:= GetArea()
Local aAreaSCS  := SCS->(GetArea())
Local aAreaSCR  := SCR->(GetArea())
Local nSaldo	:= 0
Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
Local lFirstNiv:= .T.
Local cAuxNivel:= ""
Local cNextNiv := ""
Local lAchou	:= .F.
Local nRec		:= 0
Local lRetorno	:= .T.
Local aSaldo	:= {}
dDataRef := dDataBase
cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
cWF	   := IIF(cWF==Nil,  "", cWF)
lMENU  := IIF(lMENU==Nil, .F., lMENU)  // SE .T. UTILIZADA VIA MENU DO SISTEMA

IF !lMENU
	CHKFile("SAK")
	CHKFile("SC7")
	CHKFile("SCR")
	CHKFile("SCS")
	CHKFile("SAL")
ENDIF

ConOut('AlcDoc aDocto[11]: '+aDocto[11])

If nOper == 6 // Reprovacao do Documento
	
	U_CONSOLE(" 6 -Reprovacao - CR STATUS = 04")
	
	Reclock("SCR",.F.)
	CR_STATUS   := "04"
	If SCR->(FieldPos("CR_X_OBS")) > 0
		CR_X_OBS    := Trim(CR_X_OBS)+If(Len(aDocto)>10,'. (Aprovador) - '+aDocto[11],"Reprova็ao manual")
	Else
		CR_OBS    := If(Len(aDocto)>10,aDocto[11],"Reprova็ao manual")
	EndIf
	CR_DATALIB  := dDataBase
	CR_USERLIB	:= SCR->CR_USER
	CR_LIBAPRO	:= SCR->CR_USER
	MsUnlock()
	
	lRetorno := .F.
	
EndIf

If nOper == 5 // Reprovacao Justificada. Preparar para uma nova Aprovacao do Documento
	
	U_CONSOLE(" 5 - Reaprovacao - CR STATUS = 02")
	
	Reclock("SCR",.F.)
	CR_STATUS   := "02"
	If SCR->(FieldPos("CR_X_OBS")) > 0
		CR_X_OBS    := Trim(CR_X_OBS)+'. (Solicitante) - '+aDocto[11]
	Else
		CR_OBS    := aDocto[11]
	EndIf
	CR_DATALIB  := dDataBase
	CR_USERLIB	:= SCR->CR_USER
	CR_LIBAPRO	:= SCR->CR_USER
	MsUnlock()
	
EndIf

If nOper == 4 //Aprovacao do documento
	U_CONSOLE(" 4 -Aprovacao ")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza o saldo do aprovador.                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SAK")
	dbSetOrder(1)
	dbSeek(xFilial()+cAprov)
	ConOut( 'AlcDoc -> Achou o SAK: '+cAprov )
	
	dbSelectArea("SAL")
	dbSetOrder(3)
	dbSeek(xFilial()+cGrupo+cAprov)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Libera o pedido pelo aprovador.                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SCR")
	cAuxNivel := CR_NIVEL
	
	// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
	IF !EMPTY(SCR->CR_WFID) .AND. lMENU
		WFKillProcess(SCR->CR_WFID)
	ENDIF
	
	U_CONSOLE(" 4 -Aprovacao - CR STATUS = 03")
	
	Reclock("SCR",.F.)
	CR_STATUS	:= "03"
	If SCR->(FieldPos("CR_X_OBS")) > 0
		CR_X_OBS:= Trim(CR_X_OBS)+ If(Len(aDocto)>10,'. (Aprovador) - '+aDocto[11],"")
	Else
		CR_OBS	:= If(Len(aDocto)>10,aDocto[11],"")
	EndIf
	CR_DATALIB	:= dDataBase
	CR_USERLIB	:= SAK->AK_USER
	CR_LIBAPRO	:= SAK->AK_COD
	CR_VALLIB	:= nValDcto
	CR_TIPOLIM	:= SAK->AK_TIPO
	MsUnlock()
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
	
	nRec := RecNo()
	While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
		U_CONSOLE(" 4 -Aprovacao - LOOP SCR " + CR_FILIAL+CR_NUM+CR_TIPO + CR_NIVEL + CR_STATUS )
		
		If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U "
			Exit
		EndIf
		If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP"
			ConOut('AlcDoc -> Liberando nivel ')
			Reclock("SCR",.F.)
			CR_STATUS	:= "05"
			CR_DATALIB	:= dDataBase
			CR_USERLIB	:= SAK->AK_USER
			CR_APROV	:= cAprov
			MsUnlock()
		EndIf
		If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
			lAchou := .T.
			cNextNiv := CR_NIVEL
		EndIf
		If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
			ConOut('AlcDoc -> Ajustando o proximo nivel nivel ')
			Reclock("SCR",.F.)
			CR_STATUS := If(SAL->AL_TPLIBER=="P","05","02")
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Reposiciona e verifica se ja esta totalmente liberado.       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	U_CONSOLE(" 4 -Aprovacao - Reposiciona e verifica se ja esta totalmente liberado. ")
	
	dbSelectArea("SCR")
	dbGoto(nRec)
	While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
		If CR_STATUS != "03" .And. CR_STATUS != "05"
			lRetorno := .F.
		EndIf
		dbSkip()
	EndDo
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Reposiciona e verifica se ja esta totalmente liberado.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
U_CONSOLE(" 4 -Aprovacao - Reposiciona e verifica se ja esta totalmente liberado. ")

DbSelectArea("SCR")
RestArea(aAreaSCR)

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTOD  บAutor  ณMicrosiga           บ Data ณ  Ago/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ
ฑฑบ          ณ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STOD(_cData)
local _dData

_dData := ctod(substr(_cData,7,2) + "/" + substr(_cData,5,2) + "/" + substr(_cData,1,4))

return(_dData)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONSOLE   บAutor  ณMicrosiga           บ Data ณ  Ago/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ
ฑฑบ          ณ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Console(_ctxt)
local _ctxt

if _ctxt == NIL
	_ctxt := 'nulo'
endif

CONOUT(_cTXT)

nHdl2:= FOPEN("conout.log",2)
IIF(nHdl2 > 0,,nHdl2:=MSFCREATE("conout.log",0))
fseek(nHdl2,0,2)

_cLogBody := ''
_cLogBody += DTOC(DATE()) +" @ "+ TIME() +" "+ _cTxt + chr(13) + chr(10)
Fwrite(nHdl2,_cLogBody,len(_cLogBody))

_cLogBody := replicate('-',80) + chr(13) + chr(10)
Fwrite(nHdl2,_cLogBody,len(_cLogBody))

FCLOSE(nHdl2)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaLink บAutor ณ Sergio Oliveira       บ Data ณ  Ago/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFc que envia um link com o processo de workflow a ser respondiบฑฑ
ฑฑบ          ณdo.                                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCSU.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EnviaLink(cHtmlFile,cOldTo,cOldCC,cOldBCC,cSubject, pcFilial, pcTipo, pcNumDoc, pcDescProc, pcNomAprov )

Local oP
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Sergio em Mai/2010: Atendimento a OS 1069/10 para o envio do arquivo no formato PDF anexado a totos os  ณ
ณ                     Pedidos de Compras enviados aos fornecedores:                                       ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

oP := TWFProcess():New( "000010", "Link de Processos de Workflow" )
oP:NewTask("Link de Processos Workflow", "\workflow\html\link_.htm")  // Html com link para envio

oP:ohtml:valbyname("cnomeprocesso", GetMV("MV_WFDHTTP")+alltrim(cHtmlFile))
oP:ohtml:valbyname("DESCPROC", pcDescProc )
oP:ohtml:valbyname("cNomAprov", pcNomaprov )

oP:cTo  := cOldTo
oP:cCC  := cOldCC
oP:cBCC := cOldBCC
oP:csubject := cSubject

If IsInCallStack("U_RCOMW03")
	If !File( AllTrim( GetNewPar('MV_X_DOCWF','\workflow\documentos\CONDICOES_GERAIS_DE_FORNECIMENTO.pdf') ) )
		cAssunto := "Problema no Arquivo - Workflow"
		cTitulo  := "Problema no Arquivo - Workflow"
		cDetalhe := 'O arquivo contendo as condicoes gerais de fornecimento nใo foi encontrado. '
		cDetalhe += 'Analise o conteudo do parametro MV_X_DOCWF.'
		U_Rcomw06( cAssunto, cTitulo, cDetalhe, GetMV("MV_WFADMIN") )
	Else
		oP:AttachFile( AllTrim( GetNewPar('MV_X_DOCWF','\workflow\documentos\CONDICOES_GERAIS_DE_FORNECIMENTO.pdf') ) )
	EndIf
EndIf

oP:start()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMontaWiew บAutor  ณSergio Oliveira     บ Data ณ  Jan/2005   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta funcao cria a area de trabalho e faz a contagem de    บฑฑ
ฑฑบ          ณ registros.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ<ExpC1>    : Instrucao que sera montada a query.            บฑฑ
ฑฑบ          ณ<ExpC2>    : Alias para uso no programa da area de trabalho.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ<ExpN1> : Nro de Registros no arquivo de trabalho.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MontaView( cSql, cAliasTRB )

Local nCnt := 0
Local cSql := ChangeQuery( cSql )

If Select(cAliasTRB) > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea(cAliasTRB)        // Se estiver, devera ser fechado.
	DbCloseArea(cAliasTRB)
EndIf

DbUseArea( .T., "TOPCONN", TcGenQry(,,cSql), cAliasTRB, .T., .F. )
DbSelectArea(cAliasTRB)
DbGoTop()

DbEval( {|| nCnt++ })              // Conta quantos sao os registros retornados pelo Select.

Return( nCnt )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณValidPerg ณ Autor ณ                       ณ Data ณ 11/08/97 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica as perguntas incluกndo-as caso no existam        ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             U_ValidPerg(cPerg, aMatriz)                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpC1: Nome do Grupo de Perguntas.                          บฑฑ
ฑฑบ          ณExpA1: Matriz contendo as perguntas.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ValidPerg(cPerg, aMatriz)

Local _sAlias := Alias()
Local _j      := 0
Local _i      := 0
Local _cPerg  := PadR(cPerg,Len(SX1->X1_GRUPO))
Local _aRegs  := aMatriz

DbSelectArea("SX1")
DbSetOrder(1)

For _i := 1 to Len(_aRegs)
	
	If !DbSeek( _cPerg + _aRegs[_i,2] )
		RecLock("SX1",.t.)
		For _j := 1 to FCount()
			FieldPut( _j, _aRegs[_i,_j] )
		Next
		MsUnlock()
	Endif
	
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณDadosadv  ณ Autor ณ Sergio Oliveira       ณ Data ณ 01/2003  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Operacoes.                                                  ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             U_Dadosadv()                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DadosAdv()

Processa( { || OkProc() }, 'Manutencao...' )

Return

Static Function OkProc()

aStructure2 := {}

AADD( aStructure2, {'ORIGEM'    ,'C',70,0} )
AADD( aStructure2, {'DESTINO'   ,'C',70,0} )
AADD( aStructure2, {'USUARIO'   ,'C',15,0} )
AADD( aStructure2, {'COMPUTADOR','C',35,0} )
AADD( aStructure2, {'HORA'      ,'C',08,0} )
AADD( aStructure2, {'QUANDO'    ,'D',08,0} )

xApaga := U_CriaTMP( aStructure2, "WORK" )
/*
If !File('\Dadosadv\Dadosadv.dbf')
MSCreate('\Dadosadv\Dadosadv.dbf',aStructure2,"CTREECDX")
//DbCreate('\Tabelas\Dadosadv.dbf', aStructure2)
U_UsarDbf( '\Dadosadv\Dadosadv.dbf', 'WORK' )
Else
U_UsarDbf( '\Dadosadv\Dadosadv.dbf', 'WORK' )
EndIf
*/

aStructure := {}

AADD( aStructure, {'TROK'   ,'C',02,0} )
AADD( aStructure, {'ARQUIVO','C',100,0} )
AADD( aStructure, {'TAMANHO','N',15,0} )
AADD( aStructure, {'_DATA'  ,'D',08,0} )
AADD( aStructure, {'HORA'   ,'C',08,0} )
AADD( aStructure, {'ATRIBUT','C',01,0} )

_aCampos  := {}
AADD(_aCampos,{"TROK"      ,"","  "         ,""})
AADD(_aCampos,{"ARQUIVO"   ,"","Arquivo"    ,""})
AADD(_aCampos,{"TAMANHO"   ,"","Tamanho"    ,"@E 999,999,999"})
AADD(_aCampos,{"_DATA"     ,"","Data"       ,""})
AADD(_aCampos,{"HORA"      ,"","Hora"       ,""})
AADD(_aCampos,{"ATRIBUT"   ,"","Atributo"   ,"@!"})

xApaga := U_CriaTMP( aStructure, "TRB" )

aRotina   := { { "Pesquisar "   ,'U_Pesquisar()' , 0 , 1},;
{ "Deletar   "   ,'U_Deletar()'   , 0 , 2},;
{ "Parametros"   ,'U_AjuPar()'    , 0 , 3},;
{ "Mark/Desmk"   ,'U_MarkDes()'  , 0 , 4},;
{ "Copiar"       ,'U_MultiCopia()', 0 , 5} }
lInvert   := .f.
cCadastro := "Conteudo da pasta: "+AllTrim(MV_PAR01)+AllTrim(MV_PAR02)
aStr      := {}
_cMarca   := GetMark()
MarkBrow("TRB","TROK",,_aCampos,.F.,_cMarca)

Return

User Function Deletar()

If !MsgBox('Confirme para prosseguir com o processo de Delecao.','Cuidado!!!','YesNo')
	Return
EndIf

aOp  	 := {"Marcados","Atual","Cancelar"}
cTit 	 := "Deletar Arquivos"
cMsg 	 := 'Para Deletar os Arquivos Marcados'+Chr(13)
cMsg     += 'Escolha uma das Opcoes abaixo:'
nOp      := Aviso(cTit,cMsg,aOp)
_nDelete := 0

DbSelectArea('TRB')
Procregua(1)
IncProc('Estabelecendo Selecao...')
If nOp == 1      // Todos
	DbGoTop()
	While !Eof()
		If !Empty(TRB->TROK)  // Esta Marcado. Deletar.
			RecLock('TRB',.f.)
			While .t.
				If Ferase(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO)) == -1
					_xArquivo := AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO)
					If MsgBox('Nao esta sendo possivel deletar o arquivo '+_xArquivo+Chr(13);
						+'Tenta Novamente?','Erro no Delete','YesNo')
						Loop
					Else
						Exit
					EndIf
				Else
					_nDelete ++
					DbDelete()
					Exit
				EndIf
			EndDo
			MsUnLock()
		EndIf
		DbSkip()
	EndDo
ElseIf nOp == 2  // Deletar somente o Atual
	If !Empty(TRB->TROK)  // Esta Marcado. Deletar.
		RecLock('TRB',.f.)
		While .t.
			If Ferase(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO)) == -1
				_xArquivo := AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO)
				If MsgBox('Nao esta sendo possivel deletar o arquivo '+_xArquivo+Chr(13);
					+'Tenta Novamente?','Erro no Delete','YesNo')
					Loop
				Else
					Exit
				EndIf
			Else
				_nDelete ++
				DbDelete()
				Exit
			EndIf
		EndDo
		MsUnLock()
	EndIf
Else             // Cancelar
	Return
EndIf

MsgBox('Nro. de Arquivos Deletados: '+AllTrim(Str(_nDelete)),'Arquivos Deletados','Info')

If _nDelete > 0
	MarkBRefresh()
EndIf

Return

User Function Pesquisar()

_xCopia := Space(50)

@ 355,302 To 444,722 Dialog oDglCopia Title OemToAnsi("Copia de Arquivos")
@ 004,005 To 39,202  Title OemToAnsi("Digite o arquivo a pesquisar")
@ 019,010 Get _xCopia Size 131,010
@ 014,155 BmpButton Type 1 Action(xPesq())

Activate Dialog oDglCopia Centered

Return

Static Function xPesq()

DbSelectArea('TRB')
DbSeek(AllTrim(_xCopia))

Close(oDglCopia)

MarkBRefresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AjuPar   ณ Autor ณ Sergio Oliveira       ณ Data ณ Abr/2003 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Reconfiguracao dos parametros de Visualizacao.             ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             AjuPar()                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ U_Dadosadv.prw                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AjuPar()

cPerg := PADR("_DaDSD",LEN(SX1->X1_GRUPO))
aRegs := {}

aAdd(aRegs,{cPerg,"01","Path p/ Visualizar.:","","","mv_ch1","C",70,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Visualizar Extensao:","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Copiar Para........:","","","mv_ch3","C",70,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Arquivos(Branco=All)","","","mv_ch4","C",80,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","A partir da Data...:","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate a Data.........:","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Hora De............:","","","mv_ch7","C",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Hora Ate...........:","","","mv_ch8","C",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg(cPerg,aRegs)    //--> Cria as perguntas. Funcao na Biblioteca YpfxFun.prw

If !Pergunte(cPerg,.t.)
	Return
EndIf

_xzArquivos := AllTrim(IIF( Empty(MV_PAR04),'*', MV_PAR04))

aDirectory := Directory(AllTrim(MV_PAR01)+_xzArquivos+'.'+AllTrim(MV_PAR02))

xApaga := U_CriaTMP( aStructure, "TRB" )

_xArqInd := Left(xApaga, 7) + 'A'

IndRegua("TRB",_xArqInd,"ARQUIVO",,,"Selecionando Registros...")

DbSelectArea("TRB")
Procregua(1)
IncProc("Selecionando registros")

For xi := 1 To Len(aDirectory)
	
	If Dtos(aDirectory[xi][3]) >= Dtos(MV_PAR05) .And. Dtos(aDirectory[xi][3]) <= Dtos(MV_PAR06) .And.; // Faixa de dias
		aDirectory[xi][4] >= mv_par07 .And. aDirectory[xi][4] <= mv_par08
		
		RecLock("TRB",.t.)
		TRB->ARQUIVO := aDirectory[xi][1]
		TRB->TAMANHO := aDirectory[xi][2]
		TRB->_DATA   := aDirectory[xi][3]
		TRB->HORA    := aDirectory[xi][4]
		TRB->ATRIBUT := aDirectory[xi][5]
		MsUnLock()
		
	EndIf
	
Next

DbSelectArea('TRB')
DbGoTop()

MarkBRefresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณMulticopiaณ Autor ณ Sergio Oliveira       ณ Data ณ Abr/2003 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Copia de forma multipla os arquivos selecionados.          ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             Multicopia()                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ U_Dadosadv.prw                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MultiCopia()

If !MsgBox('Deseja realmente efetuar a(s) copia(s)?','Cuidado!!!','YesNo')
	Return
EndIf

If !MsgBox('Confirme para prosseguir com o processo de Copia.','Cuidado!!!','YesNo')
	Return
EndIf

_nCopias := 0
_lMens   := .f.
//              1       2       3
aOp  := {"Sobrepor","Todos","Ignorar"}
cTit := "Sobreposicao de Arquivos"

DbSelectArea('TRB')
DbGoTop()
ProcRegua(1)
IncProc('Efetuando Copia...')
While !Eof()
	If !Empty(TRB->TROK)  // Registro Selecionado.
		If _lMens     // Sobrepor Todos
			If (__CopyFile(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO),AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO))) == .f.
				MsgBox("Nao Foi possivel efetuar a copia. Verifique o Destino.","Problema","Info")
			Else
				_nCopias ++
			EndIf
		Else
			If File(AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO)) // Arquivo ja Existe
				cMsg := 'O arquivo de destino '+AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO)+' Ja existe.'+Chr(13);
				+'O que deseja Fazer?'
				nOp  := Aviso(cTit,cMsg,aOp)
				If nOp == 1      // Sobrepor Atual
					If (__CopyFile(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO),AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO))) == .f.
						MsgBox("Nao Foi possivel efetuar a copia. Verifique o Destino.","Problema","Info")
					Else
						_nCopias ++
					EndIf
				ElseIf nOp == 2  // Sobrepor Todos
					_lMens := .t.
					If (__CopyFile(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO),AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO))) == .f.
						MsgBox("Nao Foi possivel efetuar a copia. Verifique o Destino.","Problema","Info")
					Else
						_nCopias ++
					EndIf
				Else             // Nao Sobrepor
					DbSelectArea('TRB')
					DbSkip()
					Loop
				EndIf
			Else
				If (__CopyFile(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO),AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO))) == .f.
					MsgBox("Nao Foi possivel efetuar a copia. Verifique o Destino.","Problema","Info")
				Else
					_nCopias ++
				EndIf
			EndIf
		EndIf
		
	EndIf
	DbSkip()
EndDo

MsgBox('Nro. de Arquivos Copiados: '+AllTrim(Str(_nCopias)),'Copia Multipla','Info')

Return

User Function MarkDes()

aOp  := {"Todos","Atual","Cancelar"}
cTit := "Marcacao x Remarcacao"
cMsg := 'Escolha uma das Opcoes abaixo:'
nOp  := Aviso(cTit,cMsg,aOp)

DbSelectArea('TRB')
Procregua(1)
IncProc('Estabelecendo Selecao...')
If nOp == 1      // Marcar/Desmarcar todos
	DbGoTop()
	While !Eof()
		RecLock('TRB',.f.)
		If !Empty(TRB->TROK)  // Esta Marcado. Desmarcar.
			Field->TROK := '  '
		Else                  // Nao esta Marcado. Marcar.
			Field->TROK := _cMarca
		EndIf
		MsUnLock()
		DbSkip()
	EndDo
ElseIf nOp == 2  // Marcar/Desmarcar somente o Atual
	RecLock('TRB',.f.)
	If !Empty(TRB->TROK)  // Esta Marcado. Desmarcar.
		Field->TROK := '  '
	Else                  // Nao esta Marcado. Marcar.
		Field->TROK := _cMarca
	EndIf
	MsUnLock()
Else             // Cancelar
	Return
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCriaTmp   ณ Autor ณ Sergio Oliveira.      ณ Data ณ 09/2002  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Criar arquivos de trabalho(Dbf).                           ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             U_CriaTmp( <ExpA1>, <ExpC1> )                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpA1: Matriz com a estrutura do Dbf a ser criado.          บฑฑ
ฑฑบ          ณExpC1: Alias a ser criado.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CriaTMP( Estrutura, NovoAlias )

Local _cArq := Criatrab(Estrutura,.t.)

If Select(NovoAlias) > 0
	DbSelectArea(NovoAlias)
	DbCloseArea(NovoAlias)
EndIf

DbUseArea(.t.,,_cArq,NovoAlias,.f.,.f.)

Return(_cArq + GetDbExtension() )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณUsarDbf   ณ Autor ณ Sergio Oliveira.      ณ Data ณ 10/2002  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Colocar em uso algum arquivo DBF.                          ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             U_UsarDbf( <ExpC1>, <ExpC2> )                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpC1: Path + Nome do arquivo DBF.                          บฑฑ
ฑฑบ          ณExpC2: Alias a ser criado.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function UsarDbf( PatheArq, NovoAlias )

Local _lOk := .f.

If Select(NovoAlias) > 0
	DbSelectArea(NovoAlias)
	DbCloseArea(NovoAlias)
EndIf

If File(PatheArq)
	DbUseArea(.t.,,PatheArq,NovoAlias,.t.,.f.)
	_lOk := .t.
Else
	MsgBox('O arquivo '+PatheArq+' nao existe.','Atencao','Alert')
EndIf

Return(_lOk)

User Function CopiaHtm()

WaitRunSrv("D:\CSU_R3\Protheus_Data\sigaadvhom\wfbat.bat",.t.,"D:\CSU_R3\Protheus_Data\sigaadvhom\")

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณBaixaTab  ณ Autor ณ Sergio Oliveira       ณ Data ณ 12/2003  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BaixaTab()

aRegs := {}
cPerg := PADR('Bxtab_',LEN(SX1->X1_GRUPO))

aAdd(aRegs,{cPerg,"01","Informe a Tabela...:","","","mv_cha","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Informe o Path.....:","","","mv_chb","C",40,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg(cPerg, aRegs)

If !Pergunte(cPerg,.t.)
	Return
EndIf

If TcCanOpen(MV_PAR01)
	If Select(MV_PAR01) == 0
		Dbusearea(.T.,"TOPCONN",MV_PAR01,MV_PAR01,.T.)
		DbSelectArea(MV_PAR01)
	Else
		DbSelectArea(MV_PAR01)
	EndIf
	DbGoTop()
	_cPath :=GetSrvProfString('StartPath','')+MV_PAR01
	Copy To &_cPath
Else
	MsgBox('A Tabela nao Existe no Banco!','Erro-Arquivo','Info')
	Return
EndIf

If (__CopyFile( _cPath + '.Dbf', AllTrim(MV_PAR02)+MV_PAR01+'.Dbf' )) == .f.
	MsgBox('Nao foi possivel copiar para este Path!','Erro-Path','Info')
Else
	MsgBox('Copia efetuada com sucesso!','Copia','Info')
EndIf

If File(_cPath+'.Fpt')
	If (__CopyFile( _cPath + '.Fpt', AllTrim(MV_PAR02)+MV_PAR01+'.Fpt' )) == .f.
		MsgBox('Nao foi possivel copiar para este Path!','Erro-Path','Info')
	Else
		MsgBox('Copia efetuada com sucesso!','Copia','Info')
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ UPSA1    บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Testes Genericos                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ YpfxFun.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UpSA1()

Private _xSqlExec := ""
Private cTitulo := "Testes de Rotinas Genericas"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao da Interface                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 065,025 To 516,691 Dialog mkwdlg Title cTitulo
@ 007,008 To 207,272 Title "Entre com o comando"
@ 023,019 Get _xSqlExec MEMO Size 242,177
@ 072,280 Button OemToAnsi("_Executar") Size 44,16 Action(__Vai())
@ 100,280 Button OemToAnsi("_Sair")     Size 43,16 Action(Close(MkwDlg))

Activate Dialog mkwdlg

Return

Static Function __Vai()

If Empty(_xSqlExec)
	Return
EndIf

_nRet = TCSQLEXEC(_xSqlExec)
If _nRet#0
	_cRet = TCSQLERROR()
	APMsgAlert(AllTrim(_cRet),cTitulo)
	Return
EndIf

TcSqlExec( _xSqlExec )

Alert('Instrucao Processada')

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rftpa01  บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o Upload de um arquivo conforme parametros.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Shark                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UPLFtp(pcArqUpload,_lMenu1)

Local cFtpSrv := GetNewPar( "MV_X_FTP"  ,"10.1.0.199" ) // IP ou endere็o do FTP
Local cFtpPrt := GetNewPar( "MV_X_FTPPO",21 )           // Porta
Local cFtpUsr := GetNewPar( "MV_X_FTPUS","serginho" )   // Usuario
Local cFtpPsw := GetNewPar( "MV_X_FTPSW","nenhumaa1" )  // Senha
Local aRetDir := {}
Local cArqUpload

If ! FTPCONNECT( cFtpSrv , cFtpPrt , cFtpUsr , cFtpPsw )
	IF _lMenu1
		Aviso("UPLOAD-FTP","Nao foi possivel se conectar no FTP. Contate o administrador do sistema.",;
		{"&Voltar"},3,"Grava็ใo do FTP",,"PCOLOCK")
		Return( .f. )
	ENDIF
EndIf

aRetDir := FTPDIRECTORY( "*.*", )

For xp := Len( AllTrim( pcArqUpload ) ) To 1 Step -1
	
	If '\' == SubStr( pcArqUpload, xp, 1 )
		
		cArqUpload := SubStr( pcArqUpload, xp + 1, Len( AllTrim( pcArqUpload ) ) )
		
		Exit
		
	EndIf
	
Next

/*
==>> Modelo:

If ! FTPUPLOAD('\workflow\entradas.txt', aRetDir[1][1]+'entradas.txt' )
*/

If ! FTPUPLOAD( pcArqUpload, cArqUpload )
	IF _lMenu1
		Aviso("UPLOAD-FTP","Nao foi possivel realizar o UPLOAD ["+cArqUpload+"]. Contate o administrador do sistema.",;
		{"&Voltar"},3,"Grava็ใo do FTP",,"PCOLOCK")
		Return( .f. )
	ENDIF
Else
	IF _lMenu1
		Aviso("UPLOAD-FTP","Upload realizado ==> "+cArqUpload,;
		{"&Voltar"},3,"Grava็ใo do FTP",,"PMSAPONT")
	EndIf
EndIf

FTPDISCONNECT()

Return( .t. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_Gpem410  บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o Upload de um arquivo conforme parametros.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gpem410                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _Gpem410()

Local nOpc := 0

SetFunName( "GPEM410" )

GPEM410()

FormBatch(OemToAnsi("FTP - Envio de CNAB"),;
{OemToAnsi("Esta rotina tem como ojbetivo processar o envio automatico do CNAB da Folha via "),;
OemToAnsi("FTP")},;
{ { 1,.T.,{|o| nOpc:=1,o:oWnd:End()}},;
{ 2,.T.,{|o| o:oWnd:End()}}})

If nOpc == 1
	ConfSeg()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณConfSeg   บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar se o codigo de seguranca foi digitado corretamente.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ _Gpem410()                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConfSeg()

Local cArqDest := AllTrim( MV_PAR22 )
Local cArqUpload

For xp := Len( cArqDest ) To 1 Step -1
	
	If '\' == SubStr( cArqDest, xp, 1 )
		
		cArqUpload := SubStr( cArqDest, xp + 1, Len( cArqDest ) )
		
		Exit
		
	EndIf
	
Next

__CopyFile( AllTrim(MV_PAR22), MsDocPath()+"\"+cArqUpload )

U_UPLFtp(  MsDocPath()+"\"+cArqUpload ) // Envia por FTP o arquivo com os dados de pagamentos.

Ferase( MV_PAR22 )
Ferase(  MsDocPath()+"\"+cArqUpload )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ GetUsrPc บAutor  ณ Sergio Oliveira    บ Data ณ  Jan/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retornar os usuarios que possuem acesso a visualizar os    บฑฑ
ฑฑบ          ณ pedidos de compras.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico - CSU                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GetUsrPc()

Local _cString := ''

SX5->( DbsetOrder(1) )
SX5->( DbSeek( xFilial('SX5')+"ZA" ) )
While !SX5->( Eof() ) .And. SX5->(X5_FILIAL+X5_TABELA) == xFilial('SX5')+"ZA"
	
	_cString += AllTrim( SX5->X5_DESCRI )
	
	SX5->( DbSkip() )
	
EndDo

Return( _cString )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ GetProc  บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ *** GESTAO DE MENSAGENS CUSTOMIZADAS E USUARIOS DESTINATA- บฑฑ
ฑฑบ          ณ *** RIOS DE EMAILS                                         บฑฑ
ฑฑบDesc.     ณ Retornar os usuarios destinatarios e ou mensagem conforme  บฑฑ
ฑฑบ          ณ o codigo do processo.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno  ณ Retorna uma matriz com duas dimensoes. A primeira traz a   บฑฑ
ฑฑบ          ณ lista de e-mails. A segunda traz a mensagem a ser exibida. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico - CSU                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GetProc(pcCodProc, pcItemProc)

Local aRetProc := {}
Local aAreaAnt := GetArea()
Local cSeek    := pcCodProc+IIF( pcItemProc <> Nil, pcItemProc,"" )
Local cChave

ChkFile('ZA0')

If pcItemProc == Nil
	cChave := "ZA0->(ZA0_FILIAL+ZA0_CODIGO)"
Else
	cChave := "ZA0->(ZA0_FILIAL+ZA0_CODIGO+ZA0_ITEM)"
EndIf

ZA0->( DbSetOrder(1), DbSeek( xFilial('ZA0')+cSeek ) )

While !ZA0->( Eof() ) .And. &( cChave ) == xFilial('ZA0')+cSeek
	
	Aadd( aRetProc, { ZA0->ZA0_LIST1, ZA0->ZA0_EXIBE } )
	
	ZA0->( DbSkip() )
	
EndDo

RestArea( aAreaAnt )

Return( aRetProc )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ VerCapex บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Inicializador do browse do campo CR_X_CAPEX. Busca a Soli- บฑฑ
ฑฑบ          ณ citacao de Compras e verifica se existe CAPEX para a mesma.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno  ณ Retorna "S" caso exista ou " " se nao existir.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico - CSU                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VerCapex(pcAlias)

Local aArea    := GetArea()
Local aAreaSC7 := SC7->( GetArea() ), aAreaSC1 := SC1->( GetArea() )
Local cCapex   := " "

If Select("ZA8") == 0
	ChkFile("ZA8")
EndIf

If pcAlias == 'SCR'
	If SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+AllTrim(SCR->CR_NUM) ) )
		If SC1->( DbSetOrder(1), DbSeek( xFilial('SC1')+SC7->C7_NUMSC ) )
			If ZA8->( DbSetOrder(1), DbSeek( xFilial('SC1')+"SC"+SC7->C7_NUMSC ) )
				cCapex := "CAPEX"
				//ElseIf ZA8->( DbSetOrder(1), DbSeek( xFilial('SC1')+"PR"+SC7->C7_NUMSC ) )
				//   cCapex := "PROJETO"
			EndIf
		EndIf
	EndIf
	If !Empty( SC7->C7_CONTRA )
		cCapex := "CONTRATO"
	Else
		If Empty( SC7->C7_NUMSC ) .Or. ( !Empty( SC7->C7_NUMSC ) .And. Empty(cCapex) )
			If SB1->( DbSetOrder(1), DbSeek( xFilial('SB1')+SC7->C7_PRODUTO ) ) .And.;
				SB1->B1_XDTFNEG >= SC7->C7_EMISSAO .And. SB1->B1_XPRVNEG > 0
				cCapex := "SPOT @"
			Else
				cCapex := "SPOT"
			EndIf
		EndIf
	EndIf
	//If !Empty( SC7->C7_X_PRJ ) // Controle de Projetos sobrescreve todos os status anteriores
	//    cCapex := "PROJETO"
	//EndIf
ElseIf pcAlias == 'SC1'
	If ZA8->( DbSetOrder(1), DbSeek( xFilial('SC1')+'SC'+SC1->C1_NUM ) )
		cCapex := "CAPEX"
		//ElseIf ZA8->( DbSetOrder(1), DbSeek( xFilial('SC1')+'PR'+SC1->C1_NUM ) )
		//   cCapex := "PROJETO"
	EndIf
ElseIf pcAlias == 'SC7'
	If SC1->( DbSetOrder(1), DbSeek( xFilial('SC1')+SC7->C7_NUMSC ) )
		If ZA8->( DbSetOrder(1), DbSeek( xFilial('SC1')+"SC"+SC7->C7_NUMSC ) )
			cCapex := "CAPEX"
			//ElseIf ZA8->( DbSetOrder(1), DbSeek( xFilial('SC1')+"PR"+SC7->C7_NUMSC ) )
			//  cCapex := "PROJETO"
		EndIf
	EndIf
	If !Empty( SC7->C7_CONTRA )
		cCapex := "CONTRATO"
	Else
		If Empty( SC7->C7_NUMSC ) .Or. ( !Empty( SC7->C7_NUMSC ) .And. Empty(cCapex) )
			If SB1->( DbSetOrder(1), DbSeek( xFilial('SB1')+SC7->C7_PRODUTO ) ) .And.;
				SB1->B1_XDTFNEG >= SC7->C7_EMISSAO .And. SB1->B1_XPRVNEG > 0
				cCapex := "SPOT @"
			Else
				cCapex := "SPOT"
			EndIf
		EndIf
	EndIf
EndIf

SC1->( RestArea( aAreaSC1 ) )
SC7->( RestArea( aAreaSC7 ) )

RestArea( aArea )

Return( cCapex )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPEGADUPLI บAutor  ณ Sergio  Oliveira   บ Data ณ  Dez/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se o arq tem duplicidade.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Guara - Migracao P10.                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PegaDupli()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local imprime      := .T.
Local aOrd := {}
Private titulo       := "a"
Private Cabec1       := Padc("Relatorio de Duplicidades",132)
Private Cabec2       := ""
Private nLin         := 80
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "PEGADUPLI" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "PEGADUPLI" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := ""
Private cPerg   := Padr("PegADU", Len(SX1->X1_GRUPO))
Private aRegs := {}

aAdd(aRegs,{cPerg,"01","Arquivo ...........:","","","mv_ch1","C",60,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Extensao...........:","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","RDD................:","","","mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Chave Unica........:","","","mv_ch4","C",60,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Select(B.Dados) I..:","","","mv_ch5","C",60,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Select(B.Dados) II.:","","","mv_ch6","C",60,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Select(B.Dados) III:","","","mv_ch7","C",60,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ch.Unica(Laco)  I..:","","","mv_ch8","C",60,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Ch.Unica(Laco)  II.:","","","mv_ch9","C",60,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Ch.Unica(Laco)  III:","","","mv_cha","C",60,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Empresa De.........:","","","mv_chb","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Empresa Ate........:","","","mv_chc","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Opera็ใo...........:","","","mv_chc","N",01,0,0,"C","","mv_par13","Listar","","","","","Corrigir","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg( "PegADU", aRegs )

Pergunte( "PegADU", .f. )

wnrel := SetPrint(cString,NomeProg,"PegADU",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa( { || OkProc2() }, 'Efetuando a verificacao...' )

Return

Static Function OkProc2()

SM0->( DbSeek( MV_PAR11,.t. ) )

While !SM0->( Eof() ) .And. SM0->M0_CODIGO <= MV_PAR12
	
	If Select('Work') > 0
		DbSelectArea('Work')
		DbCloseArea('Work')
	EndIf
	
	If !('TOPCONN' $ MV_PAR03)
		
		If !File(AllTrim(MV_PAR01)+SM0->M0_CODIGO+'0.'+AllTrim(MV_PAR02))
			//MsgBox('O arquivo nao existe: '+AllTrim(MV_PAR01)+'.'+AllTrim(MV_PAR02),'Sem Arquivo','Info')
			//Return
			SM0->( DbSkip() )
			Loop
		EndIf
		
		// DbUseArea(.T.,AllTrim(MV_PAR03),AllTrim(MV_PAR01)+SM0->M0_CODIGO+'0.'+AllTrim(MV_PAR02),"Work",.T.,.F.)
		MsOpenDbf( .T. ,AllTrim(MV_PAR03),AllTrim(MV_PAR01)+SM0->M0_CODIGO+'0.'+AllTrim(MV_PAR02), "Work",.T., .F.,.T. )
		
		cArqInd  := CriaTrab(,.f.)
		cCondF1T := AllTrim(MV_PAR04)
		
		IndRegua("WORK",cArqInd,cCondF1T,,,"Selecionando Registros...")
		
	Else
		
		If !TcCanOpen( AllTrim(MV_PAR01)+SM0->M0_CODIGO+'0' )
			//MsgBox('A Tabela nao existe: '+AllTrim(MV_PAR01)+SM0->M0_CODIGO+'0','Sem Arquivo','Info')
			//Return
			SM0->( DbSkip() )
			Loop
		EndIf
		
		cSelect := " SELECT "+AllTrim(MV_PAR05)+AllTrim(MV_PAR06)+AllTrim(MV_PAR07)
		cSelect += " FROM "+AllTrim(MV_PAR01)+SM0->M0_CODIGO+'0'
		cSelect += " WHERE "+AllTrim( MV_PAR04 )+" IN"
		cSelect += " ( SELECT "+AllTrim(MV_PAR04)
		cSelect += "   FROM "+AllTrim(MV_PAR01)+SM0->M0_CODIGO+'0'
		cSelect += "   GROUP BY "+StrTran( AllTrim(MV_PAR04),"+","," )
		cSelect += "   HAVING COUNT(*) > 1 ) "
		cSelect += " ORDER BY "+StrTran( AllTrim(MV_PAR04),"+","," )
		
		U_MontaView( cSelect, 'Work' )
		
	EndIf
	
	DbSelectArea('Work')
	DbGoTop()
	ProcRegua(LastRec())
	While !Eof()
		
		cChave := &(AllTrim(MV_PAR08)+AllTrim(MV_PAR09)+AllTrim(MV_PAR10))
		_lDupli := .f.
		_nOcorr := 0
		
		DbSelectArea('Work')
		DbSkip()
		IncProc(Trim(SM0->M0_NOME)+'/'+Trim(SM0->M0_FILIAL))
		
		While !Eof() .And. &(AllTrim(MV_PAR08)+AllTrim(MV_PAR09)+AllTrim(MV_PAR10)) == cChave
			
			// Imprimir a Duplicidade
			
			_lDupli := .t.
			_nOcorr ++
			
			If MV_PAR13 == 2 // Corrigir
				If !('TOPCONN' $ MV_PAR03)
					RecLock('Work',.f.)
					DbDelete()
					MsUnLock()
				Else
					TcSqlExec( "DELETE FROM "+AllTrim(MV_PAR01)+SM0->M0_CODIGO+'0'+" WHERE R_E_C_N_O_ = "+Str( Work->REG ) )
					If 'ORACLE' $ TcGeTDb()
						TcSqlExec( 'COMMIT' )
					EndIf
				EndIf
			EndIf
			
			DbSkip()
			IncProc(Trim(SM0->M0_NOME)+'/'+Trim(SM0->M0_FILIAL))
			
		EndDo
		
		If _lDupli
			If nLin > 58
				nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
				nLin++
			Endif
			
			@ nLin,001 PSAY cChave
			@ nLin, PCol() + 2 Psay 'Empresa: '+SM0->M0_CODIGO+'/'+Trim(SM0->M0_NOME)+' - Chave: '+Trim(cChave)+' - Ocorrencias: '+Str(_nOcorr)
			nLin ++
		EndIf
		
	EndDo
	
	DbSelectArea('Work')
	DbCloseArea('Work')
	
	SM0->( DbSkip() )
	
EndDo

SM0->( DbSeek( cEmpAnt+cFilAnt ) )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aReturn[5]==1
	DBCommitAll()
	SET PRINTER TO
	OurSpool(wNrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg(_cPerg, _aPerg )

DbSelectArea("SX1")

For _nI:=1 to Len(_aPerg)
	If !DbSeek( _cPerg+StrZero(_nI,2) )
		RecLock("SX1",.t.)
		For _nJ:=1 to FCount()
			FieldPut(_nJ,_aPerg[_nI,_nJ])
		Next
		MsUnLock()
	EndIf
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ CodSegur บAutor  ณ Sergio Oliveira    บ Data ณ  Abr/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Solicitar a digitacao do codigo de seguranca para confirmarบฑฑ
ฑฑบ          ณ uma determinada operacao.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ U_CodSegur( ExpC1, ExpC2 ) , onde:                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ 1. ExpC1: Titulo da caixa de mensagem;                     บฑฑ
ฑฑบ          ณ 2. ExpC2: Breve texto explicativo(51 posicoes)             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CodSegur(pcMens, pcPriLin)

Local cCodSeg  := Right( CriaTrab( Nil,.f. ),6 )
Local cConfSeg := Space(6)
Local cTxtMens := pcMens
Local oMens1
Local oFont    := TFont():New("Tahoma",8,,,.T.,,,,,.F.) // Com Negrito
Private _xlVai   := .f.

Define MsDialog MkwDlg Title "" From 173,165 To 380,565 Of oMainWnd Pixel
@ 000,001 To 104,194
@ 000,001 To 023,194
@ 057,010 To 099,134 Title "Confirme o Codigo de Seguran็a Abaixo:"
@ 020,141 To 104,194
@ 027,147 To 098,190 Title "Op็๕es"
@ 009,013 Say cTxtMens Color 8388608 Object oMens1 Size 174,8
@ 028,008 Say Left( pcPriLin, 51 ) Size 130,8
@ 035,008 Say "redigite no quadro abaixo o codigo de seguranca que" Size 130,8
@ 042,008 Say "esta sendo exibido ao lado:" Size 69,8
@ 044,082 Get cCodSeg  Picture "@!" Size 45,10 When .f.
@ 073,034 Get cConfSeg Picture "@!" Size 45,10
@ 044,150 Button "_Confirmar" Size 36,16 Action( CodSegurA(Mkwdlg, cCodSeg, cConfSeg) )
@ 066,150 Button "_Abandonar" Size 36,16 Action( Mkwdlg:End() )

oMens1:ofont:=ofont

Activate MsDialog Mkwdlg Centered

Return( _xlVai )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCodSegurA บAutor  ณ Sergio Oliveira    บ Data ณ  Abr/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar se o codigo de seguranca foi digitado corretamente.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CodSegur()                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CodSegurA( poDlg, pcCodSeg, pcConfSeg )

Local cTxtBlq := "Codigo de seguranca invalido. Verifique a sua digitacao."
Local cExec

If pcCodSeg # pcConfSeg
	Aviso("Codigo de Seguranca",cTxtBlq,{"&Fechar"},3,"Confirma็ใo Invแlida",,"PCOLOCK")
Else
	If MsgBox('Codigo confirmado. Deseja prosseguir?','Confirmado','YesNo')
		_xlVai := .t.
	EndIf
	poDlg:End()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ReplCpo  บAutor  ณ Sergio Oliveira    บ Data ณ  Set/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Replicador de campo em aCols. O campo que esta sendo digi- บฑฑ
ฑฑบDesc.     ณ tado sera replicado para todas as linhas de um acols caso  บฑฑ
ฑฑบ          ณ as demais linhas ainda nao tenha a informacao ou a informa-บฑฑ
ฑฑบ          ณ for diferente da digitada atualmente.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ReplCPO()

Local wxV
Local cCont    := &( ReadVar() )
Local cProcura := SubStr( ReadVar(),4,10 )

For wxV := 1 To Len( aCols )
	If aCols[wxV][GdFieldPos(cProcura)] # cCont
		aCols[wxV][GdFieldPos(cProcura)] := cCont
	EndIf
Next

Return( cCont )

// Efetua a carga nos dados historicos em funcao da troca do contexto dos campos de real para virtual:
// PARA O DIA 08/SET -> TESTAR ESTA ROTINA DE CARGA. JA TEM ERROR.LOG PARA PUXAR
//                   -> TESTAR TODOS OS OUTROS PONTOS DE ENTRADA

User Function CargaOri()

If MsgBox('Deseja realmente executar o ajuste?','Ajuste','YesNo')
	
	Processa( { || CargaOriP() }, "Atualizando o historico dos dados..." )
	
EndIf

Return

Static Function CargaOriP()

Private cArquivo  := 'LogOri-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log'
Private nPididu   := FCreate( '\workflow\'+cArquivo,1 )
Private cEol      := Chr(13)+Chr(10)

FWrite( nPididu, "Inicio da execucao da carga historica"+cEol )

SC1->( DbSetOrder(1) )
SB1->( DbSetOrder(1) )

ProcRegua(4)

IncProc("Etapa 1 de 4")
/*
cExec := " UPDATE "+RetSqlName('SC1')+" SET C1_X_CAPEX = '  ' WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
cExec += " AND D_E_L_E_T_ ' ' "

TcSqlExec( cExec )

IncProc("Etapa 2 de 4")

ZA8->( DbGoTop() )

FWrite( nPididu, "Inicio da etapa 2 de 4"+cEol )

While !ZA8->( Eof() )

If ZA8->ZA8_TIPO == "SC"
cExec := " UPDATE "+RetSqlName('SC1')+" SET C1_X_CAPEX = 'CAPEX' WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
cExec += " AND C1_NUM = '"+ZA8->ZA8_DOC+"' "
cExec += " AND D_E_L_E_T_ ' ' "
FWrite( nPididu, "SC "+ZA8->ZA8_DOC+" = > "+cExec+cEol )
TcSqlExec( cExec )
EndIf

ZA8->( DbSkip() )

EndDo
*/

IncProc("Zerando cadastro de funcionarios, aguarde...")

cSql := " SELECT R_E_C_N_O_ AS REGS, C1_NUM, C1_PRODUTO, C1_EMISSAO FROM "+RetSqlName('SC1')
cSql += " WHERE C1_FILIAL  = '"+xFilial('SC1')+"' "
cSql += " AND   C1_X_CAPEX = 'SPOT' "
cSql += " AND   C1_EMISSAO > '20090101' "
cSql += " AND   D_E_L_E_T_ = ' ' "

nCntView := U_MontaView( cSql, 'Work' )

Work->( DbGoTop() )

ProcRegua( nCntView )

FWrite( nPididu, "Inicio da etapa 3 de 4"+cEol )

While !Work->( Eof() )
	
	IncProc("Deletando as tabelas SRA, SRC, SRD e SP8...")
	
	If SB1->( DbSeek( xFilial('SB1')+Work->C1_PRODUTO ) ) .And.;
		Work->C1_EMISSAO >= Dtos(SB1->B1_XDTINEG) .And. Dtos(SB1->B1_XDTFNEG) >= Work->C1_EMISSAO .And.;
		SB1->B1_XPRVNEG > 0	//.And. !Empty(SB1->B1_PROC) .And. !Empty(SB1->B1_LOJPROC)
		
		cExec := " UPDATE "+RetSqlName('SC1')+" SET C1_X_CAPEX = 'SPOT@' WHERE R_E_C_N_O_ = "+Str( Work->REGS )
		
		FWrite( nPididu, "Produto Vigente "+Trim(Work->C1_PRODUTO)+" - SC: "+Work->C1_NUM+" - Gravando: "+cExec+cEol )
		
		TcSqlExec( cExec )
		
	EndIf
	
	Work->( DbSkip() )
	
EndDo

IncProc("Deletando as tabelas SF1, SE2 e SF1...")

cSql := " SELECT R_E_C_N_O_ AS REGS, C7_NUM, C7_NUMSC, C7_ITEMSC, C7_EMISSAO, C7_PRODUTO, C7_X_PRJ, "
cSql += " C7_CONTRA FROM "+RetSqlName('SC7')
cSql += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
cSql += " AND   C7_X_CAPEX = 'SPOT' "
cSql += " AND   C7_EMISSAO > '20090101' "
cSql += " AND   D_E_L_E_T_ = ' ' "

nCntView := U_MontaView( cSql, 'Work' )

Work->( DbGoTop() )

ProcRegua( nCntView )

FWrite( nPididu, "Inicio da etapa 4 de 4"+cEol )

While !Work->( Eof() )
	
	IncProc("Deletando o backup das tabelas dropadas...")
	
	FWrite( nPididu, "Pedido "+Work->C7_NUM+cEol )
	
	If SC1->( DbSetOrder(1), DbSeek( xFilial('SC1')+Work->(C7_NUMSC+C7_ITEMSC) ) )
		
		FWrite( nPididu, "Localizei a SC "+cEol )
		
		cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_X_CAPEX = 'SPOT@' WHERE R_E_C_N_O_ = "+Str( Work->REGS )
		
		FWrite( nPididu, "Gravando => "+cExec+cEol )
		
		TcSqlExec( cExec )
		
	EndIf
	
	Work->( DbSkip() )
	
EndDo

Fclose( nPididu )

__CopyFile( '\workflow\'+cArquivo, 'd:\transfer\'+cArquivo )

Alert("Mais alguma coisa senhor?")

Return
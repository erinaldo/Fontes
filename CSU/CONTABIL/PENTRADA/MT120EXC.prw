#Include "RwMake.ch"
#include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120EXC  �Autor  �Daniel G.Jr.TI1239  � Data �  21/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada da rotina MATA120-PCs, depois da exclus�o ���
���          � do PC e antes da contabiliza��o.                           ���
�������������������������������������������������������������������������͹��
���Uso       �CSU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120EXC()

// Executa fun��o de estorno de Provis�o Cont�bil, no caso do PC exclu�do compor alguma Provis�o

//ProvEstorD() - INIBIDA A CONTABILIZA��O AUTOM�TICA DO ESTORNO DA PROVI�O LOGO EM SEGUIDA A EXCLUS�O DO pc
//               tudo conforme defini��es do projeto 0856/09
//               por Wagner Gomes Costa  
//               O PONTO DE ENTRADA DEVERA SE EXCLUIDO DO PROJETO
ProvPCExc()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProvPCExc �Autor  �Wagner Gomes        � Data �  10/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento das Provisoes Contabeis                       ���
���          �Altera a Situa��o da PROVIS�O para Provis�o com PC Excluido ���
���          �Altera o campo ZB1_SITPC para E=EXCLUIDO                    ���
�������������������������������������������������������������������������͹��
���Uso       �CSU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProvPCExc()

Local _cQuery
Local _aArea	:= GetArea()
Local _aAreaSC7 := SC7->(GetArea())
Local cProvisAnt:= ""

Private cAlias  :="WORK"

_cQuery := "SELECT ZB1_PROVIS, ZB1.R_E_C_N_O_ RECZB1, ZB2.R_E_C_N_O_ RECZB2 "
_cQuery +=   "FROM "+RetSqlName("ZB1")+" ZB1, "+RetSqlName("ZB2")+" ZB2 "
_cQuery +=  "WHERE ZB1_FILIAL='"+xFilial("ZB1")+"' AND ZB1.D_E_L_E_T_ <> '*' "
_cQuery +=    "AND ZB2_FILIAL='"+xFilial("ZB2")+"' AND ZB2.D_E_L_E_T_ <> '*' "
_cQuery +=    "AND ZB2_FORNEC+ZB2_LOJA='"+SC7->(C7_FORNECE+C7_LOJA)+"' "
_cQuery +=    "AND ZB2_PEDCOM='"+SC7->C7_NUM+"' "
_cQuery +=    "AND ZB1_PROVIS=ZB2_PROVIS "
_cQuery += "ORDER BY RECZB1, RECZB2 "
_cQuery:= ChangeQuery( _cQuery )

If Select (cAlias) > 0
	WORK->(dbCloseArea())
EndIf

TcQuery _cQuery New Alias "WORK"

dbSelectArea("WORK")
dbGoTop()

If WORK->(Eof().And.Bof())
//	ApMSgStop('N�o Existem Registros para Serem Processados Nesta Empresa!','Aviso')
	WORK->(dbCloseArea())
	Return
EndIf

While WORK->(!Eof())
	
	If WORK->ZB1_PROVIS!=cProvisAnt
		                    
		cProvisAnt := WORK->ZB1_PROVIS
		
		dbSelectArea("ZB1")
		ZB1->(dbGoTo(WORK->RECZB1))
		RecLock("ZB1",.F.)
		ZB1->ZB1_PCEXC := "S"
		MsUnLock()

    EndIf

	dbSelectArea("WORK")
	dbSkip()
	
EndDo
/*
dbSelectArea("SC7")
SC7->(dbSetOrder(3)) 		// FILIAL+FORNECE+LOJA+PC
If SC7->(dbSeek(cChavSC7))
	While SC7->(!Eof()).And.SC7->(C7_FILIAL+C7_FORNECE+C7_LOJA+C7_NUM)==cChavSC7
		RecLock("SC7",.F.)
		SC7->C7_X_PROV := ' '
		MsUnLock()
		SC7->(dbSkip())
	End
EndIf
*/
WORK->(dbCloseArea())
RestArea(_aAreaSC7)
RestArea(_aArea)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProvEstor �Autor  �Daniel G.Jr.TI1239  � Data �  10/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento das Provisoes Contabeis                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �CSU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProvEstorD()

Local _cQuery
Local nHdlPrv
Local cArquivo	:= ""
Local cPadrao	:= "220"
Local lPadrao220:= .F.
Local lPadrao225:= .F.
Local nTotal	:= 0
Local nZB1Rec	:= 0
Local nTotSld   := 0
Local cChavSC7	:= ""
Local _cData	:= DDATABASE
Local _aArea	:= GetArea()
Local _aAreaSC7 := SC7->(GetArea())
Local _aAreaSA2 := SA2->(GetArea())
Local cProvis	:= ""
Local cTipo		:= "2"
Local dData		:= DDATABASE
Local cOrigem 	:= "Pedido de Compras"
Local nValor 	:= 0
Local cHistor 	:= "Cancelamento de Pedido de Compras"
Local cNomUsu 	:= UsrFullName(__CUserID)
Private cLote	:= LoteCont('COM')
Private cAlias  :="WORK"
Private cRotina := "MATA120"

lPadrao220 := VerPadrao(cPadrao)
lPadrao225 := VerPadrao("225")

If !lPadrao220 .Or. !lPadrao225
	cMsg:="Lan�amento Padr�o 220 e/ou 225 n�o est�(�o) configurado(s)!"+cEnter+"Falar com a Contabilidade!"
	Aviso("Verifique as inconsist�ncias",cMsg,{"Fechar"},3)
	Return()
EndIf

_cQuery := "SELECT ZB1_PROVIS, ZB1.R_E_C_N_O_ RECZB1, ZB2.R_E_C_N_O_ RECZB2 "
_cQuery +=   "FROM "+RetSqlName("ZB1")+" ZB1, "+RetSqlName("ZB2")+" ZB2 "
_cQuery +=  "WHERE ZB1_FILIAL='"+xFilial("ZB1")+"' AND ZB1.D_E_L_E_T_ <> '*' "
_cQuery +=    "AND ZB2_FILIAL='"+xFilial("ZB2")+"' AND ZB2.D_E_L_E_T_ <> '*' "
_cQuery +=    "AND ZB2_FORNEC+ZB2_LOJA='"+SC7->(C7_FORNECE+C7_LOJA)+"' "
_cQuery +=    "AND ZB2_PEDCOM='"+SC7->C7_NUM+"' "
_cQuery +=    "AND ZB1_PROVIS=ZB2_PROVIS "
_cQuery += "ORDER BY RECZB1, RECZB2 "
_cQuery:= ChangeQuery( _cQuery )

MemoWrite("C:\MT120EXC_ESTPROV.sql",_cQuery)

If Select (cAlias) > 0
	WORK->(dbCloseArea())
EndIf

TcQuery _cQuery New Alias "WORK"

dbSelectArea("WORK")
WORK->(dbGoTop())

If WORK->(Eof().And.Bof())
//	ApMSgStop('N�o Existem Registros para Serem Processados Nesta Empresa!','Aviso')
	WORK->(dbCloseArea())
	Return
EndIf

cLote    := "090050"		// LoteCont('COM')
nHdlPrv  := HeadProva(cLote,cRotina,Substr(cUsuario,7,6),@cArquivo)

cProvisAnt := ""

While WORK->(!Eof())
	
	If WORK->ZB1_PROVIS!=cProvisAnt
		                    
		cProvisAnt := WORK->ZB1_PROVIS
		
		dbSelectArea("ZB1")
		ZB1->(dbGoTo(WORK->RECZB1))
		nZB1Rec  := WORK->RECZB1
		ZB2->(dbGoTo(WORK->RECZB2))
		cChavSC7 := xFilial("SC7")+ZB1->(ZB1_FORNECE+ZB1_LOJA)+ZB2->ZB2_PEDCOM
		cProvis := WORK->ZB1_PROVIS
		
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+ZB1->(ZB1_FORNEC+ZB1_LOJA)))
		
		nTotSld := 0
		While WORK->(!Eof()).And.WORK->ZB1_PROVIS=cProvis
			dbSelectArea("ZB2")
			ZB2->(dbGoTo(WORK->RECZB2))
			nTotal := 0
			nTotal += DetProva(nHdlPrv,cPadrao,cRotina,cLote)
			RecLock("ZB2",.F.)
			ZB2->ZB2_SALDO	-= nTotal
			ZB2->ZB2_SLDEST	+= nTotal
			If ZB2->ZB2_SALDO<1.00
				ZB2->ZB2_SALDO:=0
				ZB2->ZB2_SLDEST:=ZB2->ZB2_VALOR
			EndIf
			ZB2->(MsUnlock())
			nTotSld += nTotal
			WORK->(dbSkip())
		End
		
		ZB1->(dbGoTo(nZB1Rec))
		RecLock("ZB1",.F.)
		ZB1->ZB1_DTESTO := _cData
		ZB1->ZB1_SALDO	-= nTotSld
		ZB1->ZB1_SLDEST	+= nTotSld
		ZB1->ZB1_VLESTO := nTotSld
		If ZB1->ZB1_SALDO<1.00
			ZB1->ZB1_SALDO:=0
			ZB1->ZB1_SLDEST:=ZB1->ZB1_VALDOC
		EndIf
		MsUnLock()

		nTotal += DetProva(nHdlPrv,"225",cRotina,cLote)
		
		dbSelectArea("SC7")
		SC7->(dbSetOrder(3)) 		// FILIAL+CLIENTE+LOJA+PC
		If SC7->(dbSeek(cChavSC7))
			While SC7->(!Eof()).And.SC7->(C7_FILIAL+C7_FORNECE+C7_LOJA+C7_NUM)==cChavSC7
				RecLock("SC7",.F.)
				SC7->C7_X_PROV := ' '
				MsUnLock()
				SC7->(dbSkip())
			End
		EndIf
		
	Else
		WORK->(dbSkip())
	EndIf
End

RodaProva(nHdlPrv,nTotal)
cA100Incl(cArquivo,nHdlPrv,3,cLote,.F.,.F.,,_cData)
       
lOcor := U_GrvOcorPrv(cProvis,cTipo,dData,nTotal,cOrigem,cHistor,cNomUsu)	

WORK->(dbCloseArea())

RestArea(_aAreaSA2)
RestArea(_aAreaSC7)
RestArea(_aArea)

Return

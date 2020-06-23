# Include "protheus.ch"
# include "TOTVS.CH"

User Function PROFA010()

Local oDlg
Local oGet   // para criacao do campo no dialog
Local dDataBloq := SE2->E2_XDTCADI
Local dDataDesb := SE2->E2_XDT1CAD
Local cMotBloqu := SE2->E2_XMOTBLQ
Local cboItens      := {"1-Cadin","2-Saldo"}
Local oGroupDot
Local oGroupUsr
Local oBut
Local cTit:= "Bloq./Desbl. Título"

	Define MSDIALOG oDlg TITLE cTit From 0,0 to 250,700 Pixel     
	oGroupUsr:= tGroup():New(10,10,70,340,"Bloqueio/Desbloqueio do Título N."+ SE2->E2_NUM,oDlg,,,.T.)
	

	
	@30,20  SAY "Data Bloqueio" OF oGroupUsr PIXEL
	@30,65  MSGET oGet  VAR dDataBloq size 70,06			   		OF oGroupUsr PIXEL
	@30,145 SAY "Data Desbloqueio" OF oGroupUsr PIXEL
	@30,190 MSGET oGet  VAR dDataDesb size 70,06			   		OF oGroupUsr PIXEL
	@50,20 SAY "Motivo" OF oGroupUsr PIXEL
	@50,65 ComboBox ccb_teste Items cboItens Size 072,010	 PIXEL  		OF oGroupUsr PIXEL
	
	
	@90,150 BUTTON oBut PROMPT "OK" action( GRVTIT(dDataBloq, dDataDesb, ccb_teste ), oDlg:End())  OF oDlg PIXEL  
	@90,180 BUTTON oBut PROMPT "CANCELAR" action(oDlg:End())  OF oDlg PIXEL  
	//-----------------------------------------------------------------------------
	ACTIVATE MSDIALOG oDlg CENTERED



Return

Static Function GRVTIT(dDataBloq, dDataDesb, ccb_teste)
Local cMotBloqu := SUBSTR(ccb_teste,1,1)
Local lRet := .T.

IF !EMPTY(dDataBloq) .or. !EMPTY(dDataDesb)

	If dDataBloq > SE2->E2_VENCREA //DATA DE BLOQUEIO NÃO PODE SER MAIOR QUE VENCIMENTO REAL
		MSGINFO('ATENÇÃO: Data de Bloqueio não poderá ser superior ao vencimento real do título')
		lRet := .F.
		Return
	EndIf
	
	If dDataBloq > dDataDesb .and. !EMPTY(dDataDesb)  //DATA DE BLOQUEIO NÃO PODE SER MAIOR QUE O DESBLOQUEIO
		MSGINFO('ATENÇÃO: Data de Bloqueio não poderá ser superior ao desbloqueio')
		lRet := .F.
		Return
	EndIf
	
	If lRet 
		If !Empty(dDataBloq) .and. Empty(dDataDesb)
			If cMotBloqu = "1" //MOTIVO CADIN
				IF MsgYesNo("Atenção, essa ação fará o bloqueio do título na ordem cronológica por motivo CADIN e deverá ser liberado novamente para pgto. Deseja continuar? ","Bloqueio ordem cronologica")
					RECLOCK("SE2",.F.)
					SE2->E2_XORDLIB := "BLC"
					SE2->E2_DATALIB := CTOD("")
					MSUNLOCK() 
				EndIf
			ElseIf cMotBloqu = "2" //BLOQUEIO SALDO
				IF MsgYesNo("Atenção, essa ação fará o bloqueio do título na ordem cronológica por motivo SALDO. Deseja continuar? ","Bloqueio ordem cronologica")
					RECLOCK("SE2",.F.)
					SE2->E2_XORDLIB := "BLS"
					MSUNLOCK() 	
				EndIf
			EndIf
		Else
			If Empty(SE2->E2_DATALIB) //CASO ESTEJA LIBERADO PARA PAGAMENTO PORÉM MOTIVO DE BLOQ. POR CADIN
				RECLOCK("SE2",.F.)
				SE2->E2_XORDLIB := "LIS"	
				MSUNLOCK()	
			Else
				RECLOCK("SE2",.F.)
				SE2->E2_XORDLIB := "LIC"	
				MSUNLOCK()	
			EndIf
		Endif 
		
	EndIf

Else
	MsgInfo("Nenhum dado foi alterado, favor retorne e efetue ação de Bloqueio ou Desbloqueio")
	Return
EndIf

Return
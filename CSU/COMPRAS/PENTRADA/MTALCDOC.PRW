#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTALCDOC ºAutor  ³ Sergio Oliveira    º Data ³  Set/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Ponto de entrada executado apos confirmar a liberacao/estorº±±
±±º          ³ no/exclusao/inclusao dos Pedidos de Vendas.                º±±
±±ºDescricao ³ Esta sendo utilizado para que o recurso de aprovacao do mesº±±
±±º          ³ mo nivel possa ser utilizado mesmo que o controle de geracaº±±
±±º          ³ o de alcadas seja customizado como eh o caso da CSU.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU - Aprovacoes de Pedidos de Compras                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTALCDOC()

Local lBloq, _lElimRes := .F., _RecLib, _TpLib := .F.
Local aAreaSCR := SCR->( GetArea() )
Local cVerifik := '', cXtatus := "", cNxtAlias := GetNextAlias()
Local cQryPC := '', cDescStat := '', cEol := Chr(13)+Chr(10)
Local cVar1 := '', cVar2 := '', cVar3 := '', cVar4 := '', cVar5 := '', cTplib := '' //1940/17 - Atribuição as variaveis

/*  ParamIxb => {aDocto,dDataRef,nOper}

paramIxb[3]    // Tp. de Operacao (Inclusao/Aprovacao/Estorno/Exclusao/Rejeicao)
paramIxb[1][1] // Documento
paramIxb[1][2] // Tipo do Documento
paramIxb[1][4] // Aprovador Atual
paramIxb[1][5] // Usuario Referente ao Aprovador Atual  */

If "RPC"$FunName() 
	Return(.t.)
EndIf

If ParamIxb[1][2] $ "PC" .And.; // Somente para pedidos de compras
	( ParamIxb[3] == 4 .Or. ParamIxb[3] == 6 )// Executar somente quando for Aprovacao(4) ou Rejeicao(6)
	
	cXtatus  := IIF( ParamIxb[3] == 4, "05", "04" ) // Nivel liberado ou rejeitado
	
	// Posicionar no SCR e obter o nivel atual:
	
	cVerifik := " SELECT CR_NIVEL "
	cVerifik += " FROM "+RetSqlName('SCR')
	cVerifik += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
	cVerifik += " AND   CR_TIPO    = '"+ParamIxb[1][2]+"' "
	cVerifik += " AND   CR_NUM     = '"+ParamIxb[1][1]+"' "
	cVerifik += " AND   CR_APROV   = '"+ParamIxb[1][4]+"' "
	//cVerifik += " AND   CR_USER    = '"+ParamIxb[1][5]+"' "
	cVerifik += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( cVerifik, cNxtAlias )
	
	(cNxtAlias)->( DbGoTop() )
	
	// Prever a ocorrencia de erro e solicitar o contato com a area de sistemas:
	
	If Empty( (cNxtAlias)->CR_NIVEL )
		Aviso("PROBLEMA","O aprovador atual nao possui nivel preenchido. Entre em contato com a area de sistemas.",;
		{"&Fechar"},3,"Nivel Inválido",,;
		"PCOLOCK")
		Return
	EndIf
	
	cNvAux := (cNxtAlias)->CR_NIVEL
	
	(cNxtAlias)->( DbCloseArea() )
	
	// Verificar se ha mais de um nivel:
	
	cVerifik := " SELECT R_E_C_N_O_ AS REGS, CR_USER "
	cVerifik += " FROM "+RetSqlName('SCR')
	cVerifik += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
	cVerifik += " AND   CR_TIPO    = '"+ParamIxb[1][2]+"' "
	cVerifik += " AND   CR_NUM     = '"+ParamIxb[1][1]+"' "
	cVerifik += " AND   CR_APROV  <> '"+ParamIxb[1][4]+"' "
	//cVerifik += " AND   CR_USER   <> '"+ParamIxb[1][5]+"' "
	cVerifik += " AND   CR_NIVEL   = '"+cNvAux+"' "
	cVerifik += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( cVerifik, cNxtAlias )
	
	(cNxtAlias)->( DbGoTop() )
	
	While !(cNxtAlias)->( Eof() ) // Se entrar no While, existe mais de um aprovador no mesmo nivel
		
		cExec := " UPDATE "+RetSqlName('SCR')+" SET CR_STATUS = '"+cXtatus+"', CR_USERLIB = '"+(cNxtAlias)->CR_USER+"', "
		cExec += "        CR_LIBAPRO = '"+ParamIxb[1][4]+"', CR_DATALIB = '"+Dtos( Date() )+"', "
		cExec += "        CR_VALLIB  = CR_TOTAL, CR_OBS = 'APROVACAO POR NIVEL' "
		cExec += " WHERE R_E_C_N_O_ = "+Str((cNxtAlias)->REGS)
		
		nExec := TcSqlExec( cExec )
		
		If nExec # 0
			cMsgTXT := "Houve um problema durante a atualizacao do banco de dados. "
			cMsgTXT += "Entre em contato com a area de Sistemas informando a mensagem abaixo: "+cEol
			cMsgTxt += TcSqlError()
			Aviso("PROBLEMA",cMsgTxt,;
			{"&Fechar"},3,"SQL Server",,;
			"PCOLOCK")
		EndIf
		
		(cNxtAlias)->( DbSkip() )
		
	EndDo
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Checar se o pedido ja foi completamente liberado:                          ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	cVerifik := " SELECT COUNT(*) AS REGS "
	cVerifik += " FROM "+RetSqlName('SCR')
	cVerifik += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
	cVerifik += " AND   CR_TIPO    = '"+ParamIxb[1][2]+"' "
	cVerifik += " AND   CR_NUM     = '"+ParamIxb[1][1]+"' "
	cVerifik += " AND   CR_STATUS IN('01','02','04') " //-> 12/Abr/2010 - Sergio: OS 0890/10
	cVerifik += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( cVerifik, cNxtAlias )
	
	(cNxtAlias)->( DbGoTop() )
	
	If (cNxtAlias)->REGS == 0
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Caso o Pedido tenha sido liberado, executar a baixa do PCO:                ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		cVerifik := " SELECT R_E_C_N_O_ AS REGS "
		cVerifik += " FROM "+RetSqlName('SC7')
		cVerifik += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
		cVerifik += " AND   C7_NUM     = '"+AllTrim(ParamIxb[1][1])+"' "
		cVerifik += " AND   D_E_L_E_T_ = ' ' "
		
		U_MontaView( cVerifik, cNxtAlias )
		
		(cNxtAlias)->( DbGoTop() )
		
		PcoIniLan("000055")                // Abertura do Processo
		PcoDetLan("000055","02","MATA097") // Antes dos Itens
		
		While !(cNxtAlias)->( Eof() )
			
			SC7->( DbGoTo( (cNxtAlias)->REGS ) )
			
			cExec := " UPDATE "+RetSqlName('SC7')
			cExec += " SET C7_CONAPRO = 'L' "
			cExec += " WHERE R_E_C_N_O_ = "+Str( (cNxtAlias)->REGS )
			
			TcSqlExec( cExec )

			PcoDetLan("000055","01","MATA097") // Cada Item
			
			(cNxtAlias)->( DbSkip() )
			
		EndDo
		
		PcoFinLan("000055")                // Fecha Gravacao
		PcoFreeBlq("000055")               // Finalizacao do Processo
		
	Else
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Checar se o proximo nivel esta com o status correto:                       ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		cQryPC := " SELECT ZERUDOIS.REGS AS ZERODOIS, ZERUUM.REGS AS ZEROUM, ZERUUM.CR_NIVEL AS NIVEU "
		cQryPC += " FROM "
		cQryPC += " ( SELECT R_E_C_N_O_ AS REGS, CR_NIVEL, CR_NUM "
		cQryPC += " FROM "+RetSqlName('SCR')
		cQryPC += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
		cQryPC += " AND   CR_TIPO    = 'PC' "
		cQryPC += " AND   CR_NUM     = '"+ParamIxb[1][1]+"' "
		cQryPC += " AND   CR_STATUS IN('02') "
		cQryPC += " AND   D_E_L_E_T_ = ' ' ) AS ZERUDOIS, "
		cQryPC += " ( SELECT R_E_C_N_O_ AS REGS, CR_NIVEL, CR_NUM "
		cQryPC += " FROM "+RetSqlName('SCR')
		cQryPC += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
		cQryPC += " AND   CR_TIPO    = 'PC' "
		cQryPC += " AND   CR_NUM     = '"+ParamIxb[1][1]+"' "
		cQryPC += " AND   CR_STATUS IN('01') "
		cQryPC += " AND   D_E_L_E_T_ = ' ' ) AS ZERUUM "
		cQryPC += " WHERE ZERUUM.CR_NUM *= ZERUDOIS.CR_NUM "
		
		U_MontaView( cQryPC, cNxtAlias )
		
		(cNxtAlias)->( DbGoTop() )
		
		If (cNxtAlias)->ZERODOIS == 0 .And. cXtatus $ '05'
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Neste caso, setar o que estiver como 01 para 02:                           ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			cChave := (cNxtAlias)->NIVEU
			While !(cNxtAlias)->( Eof() ) .And. (cNxtAlias)->NIVEU == cChave
				
				cExec := " UPDATE "+RetSqlName('SCR')
				cExec += " SET CR_STATUS = '02' "
				cExec += " WHERE R_E_C_N_O_ = "+Str( (cNxtAlias)->ZEROUM )
				
				TcSqlExec( cExec )
				
				(cNxtAlias)->( DbSkip() )
			EndDo
		EndIf
		
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ OS 2453-11 - Verifica se está eliminado por residuo na transferencia de ausencia temporaria.|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// - Inicio

If ParamIxb[1][2] $ "PC*SC" .And.; // Somente para pedidos de compras e solicitações
	( ParamIxb[3] == 2 )// Executar somente quando for Transferencia)

	cVerifik := " SELECT R_E_C_N_O_ AS REGS"
	cVerifik += " FROM "+RetSqlName('SCR')
	cVerifik += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
	cVerifik += " AND   CR_TIPO    = '"+ParamIxb[1][2]+"' "
	cVerifik += " AND   CR_NUM     = '"+ParamIxb[1][1]+"' "
	cVerifik += " AND D_E_L_E_T_ = ' ' "  // Eduardo Dias - O.S 2897/16
    
	U_MontaView( cVerifik, cNxtAlias )
	
	(cNxtAlias)->( DbGoTop() )
	
	While !(cNxtAlias)->( Eof() )
			
		SCR->( DbGoTo( (cNxtAlias)->REGS ) )
		
		If SCR->CR_X_TPLIB $ 'A/C'
			_TpLib := .T.
			cTplib := SCR->CR_X_TPLIB
			cVar1 :=  SCR->CR_XDESCPR
			cVar2 :=  SCR->CR_XNOMFOR
			cVar3 :=  SCR->CR_XNOMSOL
			cVar4 :=  SCR->CR_XCC
			cVar5 :=  SCR->CR_XCCDESC
		EndIf
		
		If !Empty(SCR->CR_USERORI)
			_RecLib := (cNxtAlias)->REGS 
		EndIf
		
		// RETIRADO PARA OS 1940/17 
		//If SCR->CR_X_RES == 'S'
		//	_lElimRes := .T.
		//	//Exit	 
		//EndIf
		
		(cNxtAlias)->( DbSkip() )
	EndDo
    
    (cNxtAlias)->( DbGoTop() )
    
    
    If !Empty(_RecLib)
    	
    	cExec := " UPDATE "+RetSqlName('SCR')
		cExec += " SET CR_XDESCPR = '"+cVar1+"', "
		If _TpLib
			cExec += " 	   CR_X_TPLIB = '"+Alltrim(cTplib)+"', "
		EndIf
		cExec += " 	   CR_XNOMFOR = '"+cVar2+"', "
		cExec += " 	   CR_XNOMSOL = '"+cVar3+"', "
		cExec += " 	   CR_XCC     = '"+cVar4+"', "
		cExec += " 	   CR_XCCDESC = '"+cVar5+"' "
		cExec += " WHERE R_E_C_N_O_ = "+Str( _RecLib )
		
		TcSqlExec( cExec )
    	
    	
    EndIf
    
    (cNxtAlias)->( DbGoTop() )
    
    If _lElimRes
	    //While !(cNxtAlias)->( Eof() )     
				
				//SCR->( DbGoTo( (cNxtAlias)->REGS ) )
				SCR->( DbGoTo( _RecLib ) )
				
				cExec := " UPDATE "+RetSqlName('SCR')
				cExec += " SET CR_X_RES = 'S' "
				cExec += " WHERE R_E_C_N_O_ = "+Str( _RecLib )
				//cExec += " WHERE R_E_C_N_O_ = "+Str( (cNxtAlias)->REGS )
				
				TcSqlExec( cExec )
								
				//(cNxtAlias)->( DbSkip() )
				
			//EndDo
	 EndIf

EndIf

// - Fim

SCR->( RestArea( aAreaSCR ) )

Return
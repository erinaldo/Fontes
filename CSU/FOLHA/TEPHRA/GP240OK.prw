#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  Gp240Ok	º Autor ³ Romay Oliveira     º Data ³  01/2015       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada no final do cadastro de afastamentos	    º±±
±±º			  Criacao da tabela ZP2 de integracao com o Tephra			    º±±
±±º																		           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico CSU		                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs		  ³Inova Solution											           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Gp240Ok()
Local x	  		:= Len(aCols)
Local nPSeq 	:= ""
Local aArea 	:= GetArea()
Local nxPSeq	:= 0
Local dxData 	:= aCols[x][1]
Local cxSeq		:= aCols[x][12]
Local cxTipo	:= aCols[x][2]
Local dxDtini	:= aCols[x][3]
Local dxDtfim	:= aCols[x][4]
Local cxNome	:= SRA->RA_NOME
Local cxMat		:= SRA->RA_MAT
Local cxDelet	:= aCols[x][41] // OS 3488/15 By Isamu K.
Local nCont		:= 0

//incluso pela OS 2816/16 - Isamu K.
If cEmpAnt == "06"
   RestArea(aArea)
   Return(.T.)
Endif

If cxDelet == .T.  //se for deletado
	
	nCont := nCont+1
	
	cQuery := "	SELECT 	* 												"
	cQuery += " FROM   	"+retsqlname("ZP2")+" ZP2				   		"
	cQuery += " WHERE 	ZP2.ZP2_FILIAL 	= '"+xFilial("ZP2")+"'			"
	cQuery += " AND 	ZP2.ZP2_MAT 	= '"+cxMat+"'  					"
	//cQuery += " AND 	ZP2.ZP2_STATUS 	= '0' 							"
	cQuery += " AND 	ZP2.ZP2_AFINI 	= '"+DtoS(dxDtini)+"'			"
	cQuery += " AND 	ZP2.ZP2_AFFIM 	= '"+DtoS(dxDtfim)+"'			"
	cQuery += " AND 	ZP2.ZP2_SITFOL 	= '"+cxTipo+"'					"
	cQuery += " AND 	ZP2.ZP2_SEQ 	= '"+cxSeq+"'               	"
	cQuery += " AND 	ZP2.D_E_L_E_T_ 	= ''							"
	
	TCQUERY cQuery NEW ALIAS "TMPZP2"
	
	dbSelectArea("TMPZP2")
	TMPZP2->(dbGoTop())
	
	If TMPZP2->(!EOF()) .AND. nCont = 1
		
		DbSelectArea("ZP2")
		DbSetOrder(1)
		dbgotop()
		
		Begin Transaction
		
		cUpdate1 := "	UPDATE 	"+RetSQLName("ZP2")+"					"
		cUpdate1 += "	SET 	ZP2_STATUS 	= '1' 					,	"//	cUpdate += "	SET 	ZP2_STATUS 	= '1' 					,	"
		cUpdate1 += "			D_E_L_E_T_	= '*' 						"
		cUpdate1 += "	WHERE 	ZP2_FILIAL 	= '"+xFilial("ZP2")+"'	    "
		cUpdate1 += "	AND 	ZP2_MAT 	= '"+cxMat+"'				"
		//						cUpdate1 += "	AND		ZP2_STATUS 	= '0' 						"
		cUpdate1 += "	AND		ZP2_AFINI 	= '"+DtoS(dxDtini)+"'		"
		cUpdate1 += "	AND 	ZP2_AFFIM 	= '"+DtoS(dxDtfim)+"'		"
		cUpdate1 += "	AND 	ZP2_SITFOL 	= '"+cxTipo+"'				"
		cUpdate1 += "	AND 	ZP2_SEQ 	= '"+cxSeq+"'               "
		cUpdate1 += "	AND 	D_E_L_E_T_ 	= ''						"
		
		
		TCSQLEXEC(cUpdate1)
		
		Reclock("ZP2",.T.)
		ZP2->ZP2_FILIAL	:= xFilial("ZP2")
		ZP2->ZP2_STATUS	:= "0"
		ZP2->ZP2_DATA	:= dDataBase
		ZP2->ZP2_HORA	:= Time()
		ZP2->ZP2_MAT	:= cxMat
		ZP2->ZP2_NOME	:= cxNome
		ZP2->ZP2_SITFOL	:= cxTipo
		ZP2->ZP2_AFINI	:= dxDtini
		ZP2->ZP2_AFFIM	:= dxDtfim
		ZP2->ZP2_SEQ	:= cxSeq//StrZero(nxPSeq,3)
		ZP2->ZP2_CIC	:= SRA->RA_CIC // adicionado campo cpf
		//						ZP2->ZP2_DESC	:= cxDesc
		MsUnlock()
		
		
		cUpdate := "	UPDATE 	"+RetSQLName("ZP2")+"					"
		cUpdate += "	SET 	ZP2_STATUS 	= '0' 					,	"//	cUpdate += "	SET 	ZP2_STATUS 	= '1' 					,	"
		cUpdate += "			D_E_L_E_T_	= '*' 						"
		cUpdate += "	WHERE 	ZP2_FILIAL 	= '"+xFilial("ZP2")+"'	    "
		cUpdate += "	AND 	ZP2_MAT 	= '"+cxMat+"'				"
		cUpdate += "	AND		ZP2_STATUS 	= '0' 						"
		cUpdate += "	AND		ZP2_AFINI 	= '"+DtoS(dxDtini)+"'		"
		cUpdate += "	AND 	ZP2_AFFIM 	= '"+DtoS(dxDtfim)+"'		"
		cUpdate += "	AND 	ZP2_SITFOL 	= '"+cxTipo+"'				"
		cUpdate += "	AND 	ZP2_SEQ 	= '"+cxSeq+"'               "
		cUpdate += "	AND 	D_E_L_E_T_ 	= ''						"
		
		
		TCSQLEXEC(cUpdate)
		
		End Transaction
		
		
	EndIf
	
	TMPZP2->(DbCloseArea())
	
Else
	/*
	For nx:=1 To x
	
	cxDelAnt := aCols[nx][25]
	
	If cxDelAnt == .T.
	
	cQuery := "	SELECT 	* 												"
	cQuery += " FROM   	"+retsqlname("ZP2")+" ZP2				   		"
	cQuery += " WHERE 	ZP2.ZP2_FILIAL 	= '"+xFilial("ZP2")+"'			"
	cQuery += " AND 	ZP2.ZP2_MAT 	= '"+cxMat+"'  					"
	cQuery += " AND 	ZP2.ZP2_STATUS 	= '0' 							"
	cQuery += "	AND 	ZP2_SEQ    		= '"+cxSeq+"'  		            "
	cQuery += " AND 	ZP2.D_E_L_E_T_ 	= ''							"
	
	TCQUERY cQuery NEW ALIAS "TMPZP23"
	
	dbSelectArea("TMPZP23")
	TMPZP23->(dbGoTop())
	
	If TMPZP23->(!EOF())
	
	Begin Transaction
	
	cUpdate := "	UPDATE 	"+RetSQLName("ZP2")+"					"
	cUpdate += "	SET 	ZP2_STATUS 	= '1' 					,	"
	cUpdate += "			D_E_L_E_T_	= '*' 						"
	cUpdate += "	WHERE 	ZP2_FILIAL 	= '"+xFilial("ZP2")+"'	    "
	cUpdate += "	AND 	ZP2_MAT 	= '"+cxMat+"'				"
	cUpdate += "	AND		ZP2_STATUS 	= '0' 						"
	cUpdate += "	AND 	D_E_L_E_T_ 	= ''						"
	
	TCSQLEXEC(cUpdate)
	
	End Transaction
	
	EndIf
	TMPZP23->(DbCloseArea())
	
	EndIf
	
	Next nx
	*/
	DbSelectArea("SX5")
	DbSetOrder(1)
	dbgotop()
	
	If 	DbSeek( xFilial("SX5") + "30" + cxTipo )
		cxDesc	:= SX5->X5_DESCRI
	Else
		cxDesc	:= ""
	EndIf
	
	cQuery := "	SELECT 	*											"
	cQuery += " FROM   	"+retsqlname("ZP2")+" 				   		"
	cQuery += " WHERE 	ZP2_FILIAL 	= '"+xFilial("ZP2")+"'			"
	cQuery += " AND 	ZP2_MAT 	= '"+cxMat+"'  					"
	cQuery += " AND 	ZP2_SITFOL 	= '"+cxTipo+"'  				"
	cQuery += " AND 	ZP2_AFINI	= '"+DtoS(dxDtini)+"'			"
	cQuery += " AND 	ZP2_AFFIM	= '"+DtoS(dxDtfim)+"'			"
	cQuery += " AND 	ZP2_STATUS	= '0'							"
	cQuery += " AND 	D_E_L_E_T_ 	= ''							"
	
	TCQUERY cQuery NEW ALIAS "TMPZP22"
	
	dbSelectArea("TMPZP22")
	TMPZP22->(dbGoTop())
	
	If TMPZP22->(!EOF())
		lxGrava	:= .F.
	Else
		lxGrava	:= .T.
	EndIf
	
	TMPZP22->(DbCloseArea())
	
	
	If lxGrava
		
		DbSelectArea("ZP2")
		DbSetOrder(1)
		dbgotop()
		
		Begin Transaction
		
		Reclock("ZP2",.T.)
		ZP2->ZP2_FILIAL	:= xFilial("ZP2")
		ZP2->ZP2_STATUS	:= "0"
		ZP2->ZP2_DATA	:= dDataBase
		ZP2->ZP2_HORA	:= Time()
		ZP2->ZP2_MAT	:= cxMat
		ZP2->ZP2_NOME	:= cxNome
		ZP2->ZP2_SITFOL	:= cxTipo
		ZP2->ZP2_AFINI	:= dxDtini
		ZP2->ZP2_AFFIM	:= dxDtfim
		ZP2->ZP2_SEQ	:= cxSeq//StrZero(nxPSeq,3)
		ZP2->ZP2_DESC	:= cxDesc
		ZP2->ZP2_CIC	:= SRA->RA_CIC // adicionado campo cpf
		MsUnlock()
		
		End Transaction
		
	EndIf
	
EndIf

RestArea(aArea)

Return(.T.)

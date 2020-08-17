#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  GPM030EX º Autor ³ Romay Oliveira     º Data ³  01/2015 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada ao excluir o calculo de ferias			  º±±
±±º			 Criacao da tabela ZP2 de integracao com o Tephra			  º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico CSU		                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs		 ³Inova Solution											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GPM030EX()
Local cTipo := "F"

//incluso pela OS 2816/16 - Isamu K.
If cEmpAnt == "06"
	Return
Endif

cQuery := "	SELECT 	* 												"
cQuery += " FROM   	"+retsqlname("ZP2")+" ZP2				   		"
cQuery += " WHERE 	ZP2.ZP2_FILIAL 	= '"+xFilial("ZP2")+"'			"
cQuery += " AND 	ZP2.ZP2_MAT 	= '"+SRA->RA_MAT+"'				"
cQuery += " AND 	ZP2.ZP2_STATUS 	= '0' 							"
cQuery += " AND 	ZP2.ZP2_SITFOL	= 'F'							"
cQuery += " AND		ZP2.ZP2_AFINI	= '"+DtoS(SRH->RH_DATAINI)+"'	"
cQuery += " AND		ZP2.ZP2_AFFIM	= '"+DtoS(SRH->RH_DATAFIM)+"'	"
cQuery += " AND 	ZP2.D_E_L_E_T_ 	= ''							"

TCQUERY cQuery NEW ALIAS "TMPZP2"

dbSelectArea("TMPZP2")
TMPZP2->(dbGoTop())

If TMPZP2->(!EOF())
	
	Begin Transaction
	
	cUpdate := "	UPDATE 	"+RetSQLName("ZP2")+"							"
	cUpdate += "	SET 	ZP2_STATUS 		= '1' ,							"
	cUpdate += "		 	D_E_L_E_T_ 		= '*' 							"
	cUpdate += "	WHERE 	ZP2_FILIAL 		= '"+xFilial("ZP2")+"' 			"
	cUpdate += "	AND  	ZP2_MAT    		= '"+SRA->RA_MAT+"'		 		"
	cUpdate += "	AND 	ZP2_STATUS		= '0'							"
	cUpdate += " 	AND		ZP2_AFINI  		= '"+DtoS(SRH->RH_DATAINI)+"'	"
	cUpdate += " 	AND		ZP2_AFFIM		= '"+DtoS(SRH->RH_DATAFIM)+"'	"
	cUpdate += "	AND 	D_E_L_E_T_ 		= ''							"
	
	TCSQLEXEC(cUpdate)
	
	End Transaction
	
Else
	
	cQuery := "	SELECT 	MAX(R8_SEQ)+1 SEQUENC						"
	cQuery += " FROM   	"+retsqlname("SR8")+" 				   		"
	cQuery += " WHERE 	R8_FILIAL 	= '"+xFilial("SR8")+"'			"
	cQuery += " AND 	R8_MAT 	= '"+SRA->RA_MAT+"'  			"
	cQuery += " AND 	D_E_L_E_T_ 	= ''							"
	
	TCQUERY cQuery NEW ALIAS "TMPSR8"
	
	dbSelectArea("TMPSR8")
	TMPSR8->(dbGoTop())
	
	If TMPSR8->(!EOF())
		nPSeq	:= TMPSR8->SEQUENC
	Else
		nPSeq	:=	1
	EndIf
	
	TMPSR8->(DbCloseArea())
	
	DbSelectArea("SX5")
	DbSetOrder(1)
	dbgotop()
	
	If 	DbSeek( xFilial("SX5") + "30" + cTipo )
		cDesc	:= SX5->X5_DESCRI
	Else
		cDesc	:= ""
	EndIf
	
	DbSelectArea("ZP2")
	DbSetOrder(1)
	dbgotop()
	
	Begin Transaction
	
	Reclock("ZP2",.T.)
	ZP2->ZP2_FILIAL	:= xFilial("ZP2")
	ZP2->ZP2_STATUS	:= "0"
	ZP2->ZP2_DATA	:= dDataBase
	ZP2->ZP2_HORA	:= Time()
	ZP2->ZP2_MAT	:= SRA->RA_MAT
	ZP2->ZP2_NOME	:= SRA->RA_NOME
	ZP2->ZP2_SITFOL	:= cTipo
	ZP2->ZP2_CIC	:= SRA->RA_CIC // adicionado campo cpf
	//	ZP2->ZP2_SEQ	:= StrZero(nPSeq,3)
	ZP2->ZP2_DESC	:= cDesc
	ZP2->ZP2_AFINI	:= SRH->RH_DATAINI
	ZP2->ZP2_AFFIM	:= SRH->RH_DATAFIM
	MsUnlock()
	
	cUpdate1 := "	UPDATE 	"+RetSQLName("ZP2")+"							"
	cUpdate1 += "	SET 	ZP2_STATUS 		= '0' ,							"
	cUpdate1 += "		 	D_E_L_E_T_ 		= '*' 							"
	cUpdate1 += "	WHERE 	ZP2_FILIAL 		= '"+xFilial("ZP2")+"' 			"
	cUpdate1 += "	AND  	ZP2_MAT    		= '"+SRA->RA_MAT+"'		 		"
	cUpdate1 += "	AND 	ZP2_STATUS		= '0'							"
	cUpdate1 += " 	AND		ZP2_AFINI  		= '"+DtoS(SRH->RH_DATAINI)+"'	"
	cUpdate1 += " 	AND		ZP2_AFFIM		= '"+DtoS(SRH->RH_DATAFIM)+"'	"
	cUpdate1 += "	AND 	D_E_L_E_T_ 		= ''							"
	
	TCSQLEXEC(cUpdate1)
	
	End Transaction
	
EndIf

TMPZP2->(DbCloseArea())


Return()

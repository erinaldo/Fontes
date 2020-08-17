#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  GP030FER º Autor ³ Romay Oliveira     º Data ³  01/2015      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada no calculo de ferias						  º±±
±±º			 Criacao da tabela ZP2 de integracao com o Tephra			  º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico CSU		                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs		 ³Inova Solution											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GP030FER()

//incluso pela OS 2816/16 - Isamu K.
If cEmpAnt == "06"
	Return
Endif


cQuery := "	SELECT 	MAX(R8_SEQ)+1 SEQUENC							"
cQuery += " FROM   	"+retsqlname("SR8")+" SR8				   		"
cQuery += " WHERE 	SR8.R8_FILIAL 	= '"+xFilial("SR8")+"'			"
cQuery += " AND 	SR8.R8_MAT 	= '"+SRA->RA_MAT+"'  			"
cQuery += " AND 	SR8.D_E_L_E_T_ 	= ''							"

TCQUERY cQuery NEW ALIAS "TMPSR8"

dbSelectArea("TMPSR8")
TMPSR8->(dbGoTop())

If TMPSR8->(!EOF())
	nPSeq	:= TMPSR8->SEQUENC
Else
	nPSeq	:=	1
EndIf

TMPSR8->(DbCloseArea())

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
ZP2->ZP2_CIC	:= SRA->RA_CIC // adicionado campo cpf
ZP2->ZP2_SITFOL	:= "F"
ZP2->ZP2_AFINI	:= SRH->RH_DATAINI
ZP2->ZP2_AFFIM	:= SRH->RH_DATAFIM
ZP2->ZP2_SEQ	:= StrZero(nPSeq,3)
ZP2->ZP2_DESC	:= "FERIAS"
MsUnlock()

End Transaction


Return()

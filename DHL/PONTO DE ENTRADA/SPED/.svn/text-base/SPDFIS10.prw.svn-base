#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  10/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SPDFIS10()

Local aReg1600 	:= {}
Local xaArea	:= GetArea()
Local xDataDe	:= DTOS(PARAMIXB[1]) //Data De
Local xDataAte	:= DTOS(PARAMIXB[2]) //Data Ate

aWizard:={}

If File("SPEDFIS"+cempant+cfilant+".CFP")
	xMagLeWiz ("SPEDFIS"+cempant+cfilant, @aWizard, .T.)
ElseIf File("SPEDFIS"+cfilant+".CFP")
	xMagLeWiz ("SPEDFIS"+cfilant, @aWizard, .T.)
EndIf

If Empty(Len(aWizard))
	Return()
EndIf

Private cReg1600   :=	aWizard[5][7] //Gerar Registro 1600 (1 - Sim / 2 - Não)

If cReg1600 == "1 - Sim"
	
	//--Verifica a situacao atual do documento da viagem
	cAliasQry := GetNextAlias()
	cQuery := " SELECT * "
	cQuery += " FROM " + RetSqlTab("SZ1")
	cQuery += " WHERE Z1_DATA BETWEEN '"+xDataDe+"' AND '"+xDataAte+"' "
	cQuery += " AND Z1_FILIAL = '"+xFilial("SZ1")+"' "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliasQry, .F., .T. )
	
	DbSelectArea("SZ1")
	DbSetOrder(1)
	DbGotop()
	
	Do While !(cAliasQry)->(EOF())
	
	//                   FILIAL                    ,COD_PART                                           ,DESCRICAO DA ADMINISTRADORA ,TOT_CREDITO              , TOT_DEBITO 
		aAdd (aReg1600, {(cAliasQry)->(Z1_FILIAL),"SA1"+(cAliasQry)->(Z1_FILIAL+Z1_CODCLI+Z1_LOJCLI) ,(cAliasQry)->(Z1_NOME)      ,(cAliasQry)->(Z1_VALCRD) , (cAliasQry)->(Z1_VALDEB)})
	
	//  OBS: COD_PART: O valor informado deve existir no campo COD_PART do registro 0150.                                			
		(cAliasQry)->(DbSkip())
	EndDo
	
	(cAliasQry)->( DbCloseArea() )

EndIf

RestArea(xaArea)

Return aReg1600
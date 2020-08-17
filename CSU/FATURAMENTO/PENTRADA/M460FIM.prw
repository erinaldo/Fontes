#INCLUDE "Protheus.ch"    
#INCLUDE "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³     M460FIM   ºAutor  ³  Eduardo Dias   º Data ³  27/08/15º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E utilizado para chamar a rotina de contabilização do    º±±
±±º          ³ INSS sobre o faturamento OS 1698/15                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460FIM()     

             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama rotina de Calculo de INSS sobre o Faturamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ              

Processa({|| AutoINSS() }, "Aguarde...", "Calculando o INSS sobre o Faturamento...")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  ProcINSS  ºAutor  ³  Eduardo Dias    º Data ³  27/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento da rotina de Contabilização do INSS           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoINSS()
Local cQuery		:= ""
Local nSoma			:= 0
Local cAliasQry 	:= ""                      
Local lRet	   		:= .F.
Local cEmissao		:= SD2->D2_EMISSAO
Local nNota			:= SD2->D2_DOC
Local nSerie		:= SD2->D2_SERIE     
Local aArea 		:= GetArea()

dbSelectArea("SD2")
dbSelectArea("SB5")
dbSelectArea("CG1")     

cAliasQry := GetNextAlias()

cQuery := "SELECT D2_COD AS [PRODUTO], SB5.B5_CODATIV AS [ATIVIDADE], CG1.CG1_ALIQ AS [TAXA], SD2.D2_DOC [NOTA], SD2.D2_SERIE [SERIE], SD2.D2_EMISSAO [EMISSAO], SD2.D2_TOTAL [VLRITEM_NF] "
cQuery += "FROM " + RetSqlName("SD2") + " SD2 "
cQuery += "INNER JOIN " + RetSqlName("SB5") + " AS SB5 "
cQuery += "ON SD2.D2_COD = SB5.B5_COD "
cQuery += "INNER JOIN " + RetSqlName("CG1") + " AS CG1 "
cQuery += "ON SB5.B5_CODATIV = CG1.CG1_CODIGO "
cQuery += "WHERE "
cQuery += "D2_FILIAL = '" + SD2->(xFilial("SD2")) + "' AND " 
cQuery += "B5_FILIAL = '" + SB5->(xFilial("SB5")) + "' AND " 
cQuery += "B5_INSPAT = '1' AND " 
cQuery += "CG1_FILIAL = '" + CG1->(xFilial("CG1")) + "' AND " 
cQuery += "D2_EMISSAO = '" + Dtos(cEmissao) + "' AND "	
cQuery += "D2_DOC = '" + nNota + "' AND "
cQuery += "D2_SERIE = '" + nSerie + "' AND "
cQuery += "CG1_DTFIM >= '" + Dtos(dDataBase) + "' AND "
cQuery += "SD2.D_E_L_E_T_ = ' ' AND "                  
cQuery += "SB5.D_E_L_E_T_ = ' ' AND "
cQuery += "CG1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY D2_DOC"     

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cAliasQry , .F., .T.)
                            
ProcRegua(Len(cAliasQry))

While !(cAliasQry)->(Eof())
    
	dbSelectArea("ZV2") //ZV2_FILIAL+ZV2_NOTA+ZV2_SERIE
	DbSetOrder(1)                   
	
	nFlag := Posicione("ZV2",1,xFilial("ZV2")+(cAliasQry)->NOTA+(cAliasQry)->SERIE, "ZV2_FLAG")
    
    If nFlag == '1'      
    	MsgAlert("Calculo do INSS sobre a Nota Fiscal  "+(cAliasQry)->NOTA+" já processada!")
    	(cAliasQry)->(dbSkip())       	
    Else                          
 
       	IncProc("Aguarde Processando a gravação do calculo da Nota: "+(cAliasQry)->NOTA)
        
		If ZV2->(dbSeek(xFilial("ZV2")+(cAliasQry)->NOTA+(cAliasQry)->SERIE)) .And. ZV2_FLAG != "2"
			nSoma	:=	ZV2->ZV2_TOTINS
		EndIf                         

		RECLOCK("ZV2", .T.)	 
		ZV2->ZV2_FILIAL		:= xFilial("ZV2")  
		ZV2->ZV2_NOTA		:= (cAliasQry)->NOTA
		ZV2->ZV2_SERIE		:= (cAliasQry)->SERIE
		ZV2->ZV2_DATA		:= STOD((cAliasQry)->EMISSAO)
		ZV2->ZV2_VLRUNI		:= (cAliasQry)->VLRITEM_NF 
	    ZV2->ZV2_TOTINS		:= (cAliasQry)->VLRITEM_NF * ((cAliasQry)->TAXA / 100)
	    ZV2->ZV2_FLAG 		:= "1"
		MSUNLOCK()			
		
	EndIf                 
	
(cAliasQry)->(dbSkip())  
 		
EndDo

(cAliasQry)->(dbCloseArea())               

ZV2->(dbCloseArea())        

RestArea(aArea)

Return      

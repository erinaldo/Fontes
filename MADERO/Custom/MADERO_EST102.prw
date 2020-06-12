#Include "Protheus.ch"
#Include "TopConn.CH"
#Include "TryException.CH"
#Include "rwmake.ch"
#Include "TBICONN.CH"

/*-----------------+---------------------------------------------------------+
!Nome              ! AEST102 - Cliente: Madero                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Geração de demanda para a Fabrica                       !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 23/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function AEST102(paramixb)
Local _cEmpresa  := paramixb[1] // Empresa destino (da fábrica)
Local _cFilial   := paramixb[2] // Filial destino (da fábrica)
Local cGrupoEmp  := paramixb[3] // Grupo de Empresas originais (de onde buscar as SCs - obtido a partir do cEmpAnt) 
Local nQtdeDias  := paramixb[4] // Numero de dias totais de estoque 
Local cFilOrig   := paramixb[6] // Filial de origem
Local nQtdeDiasF := paramixb[7] // Numero de dias para "firmar" o estoque
Local dDataIni   := paramixb[8] // Data do sistema
Local cAliTmp0   := GetNextAlias()
Local cAliTmp1   := GetNextAlias()
Local cQuery     := ""
Local cCleanDem  := ""
Local lErro      := .F.
Local _xaEventL  := {}
Local aDados     := {}
Local aDadosSA5  := {}
Local cPathTmp   := "\temp\"
Local cAuxLog    := ""
Private lMsErroAuto:=.F.
		
	// Composicao do nome das tabelas dos restaurantes	
	if len(cGrupoEmp) = 2
		cGrupoEmp += "0"
	Endif
	RpcClearEnv()
	RPcSetType(3)
    Prepare Environment Empresa _cEmpresa filial _cFilial Tables "SA2","SB1","SB2","SC2","SC3","SC4","SC6","SX5","SBM","ADK","Z25" Modulo "FAT"
    	    
    dDataBase:=dDataIni	    
    	    
    Begin Transaction
	        	
    	// -> Apagar as demandas para a fábrica
		cAuxLog:=': Excluindo demandas...' 
		ConOut(cAuxLog)                              
		
		SX2->(dbSetOrder(1))
		cCleanDem := "DELETE FROM "+RetSQLName("SC4")         + "       "
		cCleanDem += "WHERE C4_FILIAL  = '" + xFilial("SC4")  + "'  AND "
		cCleanDem += "      C4_DATA   >= '" + DtoS(dDataBase) + "   AND "
		cCleanDem += "      C4_XFILERP = '" + cFilOrig        + "'      "       
		TCSqlExec(cCleanDem)

    	// -> Incluir as novas demandas para a fábrica
    	DbSelectArea("SA2")
    	SA2->(dbSetOrder(3))
    	SA2->(dbSeek(xFilial("SA2")+SM0->M0_CGC))
		
		cAuxLog:=': Verificando cadastro de produtos na industria...' 
		ConOut(cAuxLog)                              
		cQuery:="SELECT DISTINCT B1_FILIAL, B1_COD, B1_DESC, A5_CODPRF "
		cQuery+="FROM Z25"+cGrupoEmp+" Z25, SA5"+cGrupoEmp+" SA5, SB1"+cGrupoEmp+" SB1  " 
		cQuery+="WHERE  Z25.Z25_FILIAL   = '" + cFilOrig                        + "' AND " 
		cQuery+="       Z25.Z25_DTNECE  >= '" + DtoS(dDataBase)                 + "' AND " 
		cQuery+="       Z25.Z25_DTNECE  <= '" + DToS(dDataBase+nQtdeDias)       + "' AND "
		cQuery+="       Z25.Z25_CODFOR   = '" + SA2->A2_COD                     + "' AND "
		cQuery+="       Z25.Z25_CODLOJ   = '" + SA2->A2_LOJA                    + "' AND "
		cQuery+="       Z25.D_E_L_E_T_   = ' '             AND "
		cQuery+="       SA5.A5_FILIAL    = Z25.Z25_FILIAL  AND "
		cQuery+="       SA5.A5_PRODUTO   = Z25.Z25_PRODUT  AND "
		cQuery+="       SA5.D_E_L_E_T_   = ' '             AND "
		cQuery+="       SB1.B1_FILIAL    = Z25.Z25_FILIAL  AND "
		cQuery+="       SB1.B1_COD       = Z25.Z25_PRODUT  AND "
		cQuery+="       SB1.D_E_L_E_T_  = ' '              AND "
		cQuery+="       SA5.A5_CODPRF NOT IN (SELECT B1_COD FROM " + RetSqlName("SB1") + " WHERE D_E_L_E_T_ = ' ' AND B1_FILIAL = '"+_cFilial+"')"
		cQuery+="ORDER BY  B1_FILIAL, B1_COD, A5_CODPRF "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliTmp1,.T.,.T.)				
		(cAliTmp1)->(dbGoTop())
		_xaEventL:={}
		While !(cAliTmp1)->(eof())
			lErro:=.F.
			aadd(_xaEventL,"Produturo "+AllTrim((cAliTmp1)->B1_COD)+"-"+AllTrim((cAliTmp1)->B1_DESC)+" nao cadastrado na industria. [B1_COD = " +AllTrim((cAliTmp1)->A5_CODPRF)+"]")
			(cAliTmp1)->(DbSkip())
		EndDo
		(cAliTmp1)->(dbCloseArea())
		
		If !lErro	
			cAuxLog:=': Agrupando demandas das unidades de negocio...' 
			ConOut(cAuxLog)                              			
			cQuery  := "SELECT Z25_FILIAL, Z25_PRODUT, A5_CODPRF, A5_FORNECE, A5_LOJA, Z25_DTNECE, SUM(Z25_QUANT) SMQTD " 
			cQuery  += "FROM Z25" + cGrupoEmp + " Z25 INNER JOIN SB1" + cGrupoEmp + " SB1 " 
			cQuery  += "ON Z25.Z25_FILIAL   = SB1.B1_FILIAL  AND " 
			cQuery  += "   Z25.Z25_PRODUT   = SB1.B1_COD     AND " 
			cQuery  += "   SB1.D_E_L_E_T_   = ' '                "
			cQuery  += "INNER JOIN "+RetSqlName("ADK") + " ADK   "
			cQuery  += "ON ADK.ADK_XFILI    =  Z25.Z25_FILIAL  AND  "  
			cQuery  += "   ADK.D_E_L_E_T_   = ' '                   "
			cQuery  += "INNER JOIN SA5" + cGrupoEmp + " SA5         "
			cQuery  += "ON    SA5.A5_FILIAL    = ADK.ADK_XFILI  AND "  
			cQuery  += "      SA5.A5_FORNECE   = Z25.Z25_CODFOR AND "  
			cQuery  += "      SA5.A5_LOJA      = Z25.Z25_CODLOJ AND " 
			cQuery  += "      SA5.A5_PRODUTO   = Z25.Z25_PRODUT AND " 
			cQuery  += "      SA5.D_E_L_E_T_   = ' '                "
			cQuery  += "WHERE Z25.Z25_DTNECE  >= '" + dtos(dDataBase)           + "' AND " 
			cQuery  += "      Z25.Z25_DTNECE  <= '" + dtos(dDataBase+nQtdeDias) + "' AND " 
			cQuery  += "      Z25.Z25_CODFOR   = '" + SA2->A2_COD  + "'              AND "
			cQuery  += "      Z25.Z25_CODLOJ   = '" + SA2->A2_LOJA + "'              AND "
			cQuery  += "      Z25.D_E_L_E_T_   = ' '                                     "
			cQuery  += "GROUP BY Z25_FILIAL, Z25_PRODUT, A5_CODPRF, A5_FORNECE, A5_LOJA, Z25_DTNECE  "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliTmp0,.T.,.T.)				
			
			(cAliTmp0)->(dbGoTop())
			While !(cAliTmp0)->(eof())
				aDados:={}
				SB1->(DbSetOrder(1))
        		If SB1->(MsSeek(xFilial("SB1")+(cAliTmp0)->A5_CODPRF))
					cAuxLog:='Demanda em ' + DtoC(StoD((cAliTmp0)->Z25_DTNECE)) + ' para o produto ' + AllTrim(SB1->B1_COD) + ' - ' + ALLTrim(SB1->B1_DESC) 
					ConOut(cAuxLog)                              			
					// -> Calcula dados do fornecedor (industria)
					aDadosSA5:=u_C104PRF((cAliTmp0)->SMQTD,(cAliTmp0)->A5_FORNECE,(cAliTmp0)->A5_LOJA,SB1->B1_COD,.F.)
					aadd(aDados,{"C4_FILIAL" ,xFilial("SC4")         									,Nil})
					aadd(aDados,{"C4_PRODUTO",SB1->B1_COD            									,Nil})
		            aadd(aDados,{"C4_LOCAL"  ,SB1->B1_LOCPAD									        ,Nil})
        		    aadd(aDados,{"C4_DOC"    ,StrZero(Year(dDataBase),4,0)+StrZero(Month(dDataBase),2,0),Nil})
		            aadd(aDados,{"C4_QUANT"  ,aDadosSA5[1]												,Nil})
		            aadd(aDados,{"C4_DATA"   ,stod((cAliTmp0)->Z25_DTNECE)								,Nil})
		            aadd(aDados,{"C4_OBS"    ,"Demanda restaurantes."									,Nil})
		            aadd(aDados,{"C4_XFILERP",(cAliTmp0)->Z25_FILIAL								    ,Nil})
					// -> Executa inclusão
					MATA700(aDados,3)
					If lMsErroAuto
						lErro   := .T.
						cAuxLog := "dm_"+cFilAnt+"_"+SB1->B1_COD+"_"+strtran(time(),":","")
						MostraErro(cPathTmp, cAuxLog)
						aadd(_xaEventL,"Erro na inclusao da demanda: Ver log em "+cPathTmp+cAuxLog+"]")
						DisarmTransaction()
						Exit
					EndIf					
				Else
					conout("Produto nao encontrado no cadastro da industria: "+(cAliTmp0)->A5_CODPRF)
				EndIf   
				(cAliTmp0)->(dbSkip())
			EndDo 			
			(cAliTmp0)->(dbCloseArea())		
		EndIf			
		
	End Transaction
		
    RESET ENVIRONMENT
        
Return(_xaEventL)
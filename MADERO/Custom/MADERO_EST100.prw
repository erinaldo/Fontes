#Include "Protheus.ch"                                    
#Include "TopConn.CH"
#Include "rwmake.ch"
#Include "TBICONN.CH"
#Include "TryException.CH"

/*----------------+----------------------------------------------------------+
!Nome              ! EST100 - Cliente: Madero                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Execucao do MRP - unidades de negócio                   !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 30/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function EST100(lxBatch)
Local cEmpresa := AllTrim(GetSrvProfString('Empresa',''))
Local cEmpAux  := AllTrim(GetSrvProfString('Filiais',''))
Local aEmp     := {}
Local na       := 0
Local aParam   := {}
Local nRecL    := 0
Local lLock    := .F.
Local cAuxLog  := ""
Local nDiasMx  := 0
Local nDiasMxF := 0
Local cUndMad  := ""
Local lRet	   := .T.
Local cUserProc:= ""
Private oEventL  
Default lxBatch :=.T.


	// -> Verifica parâmetros da empresa
	If lxBatch
	   If SubStr(cEmpAux,11,1) == "-"
	      // -> Seleciona as empresas informadas no parâmetro
	      aEmp := StrToKarr(cEmpAux,'-')
	      For na:=1 to Len(aEmp)
	   	     Aadd(aParam,{cEmpresa,aEmp[na]})
	      Next na  
	   Else
	      aParam := {{cEmpresa, SubStr(cEmpAux,1,10)}}
		  RpcClearEnv()
		  RPcSetType(3)
    	  RpcSetEnv( aParam[1,1],aParam[1,2], , ,'PCP' , GetEnvServer() )
    	  OpenSm0(aParam[1,1], .f.)
		  nModulo := 10
		  SM0->(dbSetOrder(1))
		  SM0->(dbSeek(aParam[1,1]+aParam[1,2]))
		  cEmpAnt := SM0->M0_CODIGO
		  cFilAnt := SM0->M0_CODFIL
		  // -> Busca todas as unidades de negócio
		  DbSelectArea("ADK")
		  ADK->(DbGoTop())
		  aParam:={}
		  While !ADK->(Eof())
		     If ADK->ADK_XFILI <> ""
	   	        Aadd(aParam,{cEmpresa,ADK->ADK_XFILI})
	   	     EndIf   
		     ADK->(DbSkip())
		  EndDo
		  RpcClearEnv()		 
	   Endif
	Else
	   aParam := {{cEmpAnt, cFilAnt}}
	Endif

	// -> Executa processo para todas as empresas
	For na:=1 to Len(aParam)

		If lxBatch
			RpcClearEnv()
			RPcSetType(3)
    		RpcSetEnv( aParam[na,1],aParam[na,2], , ,'PCP' , GetEnvServer() )
    		OpenSm0(aParam[na,1], .f.)
			nModulo := 10
			SM0->(dbSetOrder(1))
			SM0->(dbSeek(aParam[na,1]+aParam[na,2]))
			cEmpAnt  := SM0->M0_CODIGO
			cFilAnt  := SM0->M0_CODFIL
	    EndIf
	    		   	
	   	// -> Posiciona nas eunidades de negócio : Unidade de negócio
	   	DbSelectArea("ADK")
	   	ADK->(DbOrderNickName("ADKXFILI"))
	   	ADK->(ADK->(DbSeek(xFilial("ADK")+cFilAnt)))
	   	
	   	If !Empty(ADK->ADK_XNMPR)
	   		dDataBase:=ADK->ADK_XNMPR
	   	
		   	// -> inicializa o Log do Processo de MRP das unidades de negócio
		   	oEventL   :=EventLog():start("MRP - UNIDADES", dDataBase, "Iniciando processo de MRP das unidadades de negocio...","DEMPROJ", "SC4")
	   		nRecL     :=oEventL:GetRecno()
		   	cFunNamAnt:= FunName()
			SetFunName("EST100")

			cAuxLog:=": Executando processo de MRP..." 
			ConOut(cAuxLog)                              
			oEventL:SetAddInfo(cAuxLog,"")
	
			oEventL:setCountOk()
	
			// -> Verifica se pode executar o processo
			If  (Date() < ADK->ADK_XNMPR .or. Empty(ADK->ADK_XNMPR))
				cAuxLog:="Ok: Aguardando proxima execucao: Data: " + DtoC(ADK->ADK_XNMPR)
				ConOut(cAuxLog)                              
				oEventL:SetAddInfo(cAuxLog,"")
				oEventL:Finish()
				SetFunName(cFunNamAnt)
				If lxBatch		
					RpcClearEnv()
				EndIf					                         					
				Loop	
			EndIf 

			If ADK->ADK_XINVEN <> "S"
				cAuxLog:="Ok: Aguardando inventario"
				ConOut(cAuxLog)                              
				oEventL:SetAddInfo(cAuxLog,"")
				oEventL:Finish()
				SetFunName(cFunNamAnt)
				If lxBatch		
					RpcClearEnv()
				EndIf					                          					
				Loop	
			EndIf

			// -> Verifica o usuário utilizdo no processo
			PswOrder(2)
			If !PswSeek("ressuprimento", .T. ) 
				cAuxLog:="Usuario 'ressuprimento' nao encontrado. Favor criar usuario pelo configurador."
				ConOut(cAuxLog)                              
				oEventL:SetAddInfo(cAuxLog,"")
				oEventL:Finish()
				SetFunName(cFunNamAnt)
				If lxBatch		
					RpcClearEnv()
				EndIf					                          					
				Loop	
			Else
				cUserProc:=PswID()
			EndIf

			If ADK->ADK_XINVEN <> "S"
				cAuxLog:="Ok: Aguardando inventario"
				ConOut(cAuxLog)                              
				oEventL:SetAddInfo(cAuxLog,"")
				oEventL:Finish()
				SetFunName(cFunNamAnt)
				If lxBatch		
					RpcClearEnv()
				EndIf					                          					
				Loop	
			EndIf





			nDiasMx := ADK->ADK_XNDES
			nDiasMxF:= ADK->ADK_XNDESF
			cUndMad := ADK->ADK_XFILI
			
			lLock := LockByName("AEST_"+cUndMad)
			If !lLock
				lErro1  :=.T.
				cAuxLog:="Rotina já sendo executada, execução cancelada..."+cUndMad+" ("+dtoc(dDataBase)+" "+time()+")"
				oEventL:broken("Na execucao.", cAuxLog, .T.)
				Conout(cAuxLog) 
				oEventL:Finish()               
				SetFunName(cFunNamAnt)
				If lxBatch		
					RpcClearEnv()
				EndIf					                         					
				Loop	
			Endif

			If lLock 
		
				// -> Executa o procsso de importacao da previsão de vendas do Prophix
				lRet   :=.T.
				cAuxLog:=": Etapa 01 - Importacao das previsoes de vendas..." 
				ConOut(cAuxLog)                              
				oEventL:SetAddInfo(cAuxLog,"")
				lRet  :=U_EST100PV(oEventL)
				lErro1:=!lRet	   	

				// -> Processa o MRP
				If !lErro1
					cAuxLog:=": Etapa 02 - Calculo das necessidades..." 
					ConOut(cAuxLog)                              
					oEventL:SetAddInfo(cAuxLog,"")
					lRet  :=u_xRunMRP(cUndMad, nDiasMx, oEventL, nDiasMxF)
					lErro1:=!lRet
				EndIf
			
				// -> Firma demandas
				If lRet
					cAuxLog:=': Etapa 03 - Firmando necessidades de compras...'
					ConOut(cAuxLog)                              
					oEventL:SetAddInfo(cAuxLog,"")			
					// -> Aglutinacao de Solicitacoes de Compras
					lRet:=U_AESTFIR(cUndMad, oEventL, nDiasMxF)								
					// -> Se deu tudo ok
					If lRet
						oEventL:SetStep("03")
					EndIf
				Endif

				// -> Gera pedidos de compras
				If !lErro1
					cAuxLog:=": Etapa 04 - Geracao de pedidos..." 
					ConOut(cAuxLog)                              
					oEventL:SetAddInfo(cAuxLog,"")
					lRet  :=PutSC7(oEventL)		
					lErro1:=!lRet
					// -> Se deu tudo ok
					If lRet
						oEventL:SetStep("04")
					EndIf
				EndIf

				// -> Atualiza dados do procsso para a unidade
				If !lErro1 .and. AllTrim(oEventL:GetStep()) == "04"
					cAuxLog:=": Etapa 05 - Preparando o proximo calculo..." 
					ConOut(cAuxLog)                              
					// -> Atualizar a data da execucao 
					If RecLock("ADK",.f.)
						ADK->ADK_XBMPR :=ADK->ADK_XNMPR
						ADK->ADK_XNMPR :=ADK->ADK_XNMPR+7 
						ADK->ADK_XINVEN:="N"
						ADK->(MsUnlock())
						oEventL:SetStep("05")
					EndIf
					cAuxLog:="Ok." 
					ConOut(cAuxLog)                              
				EndIf	

			EndIf

	   		// -> Executa processo de MRP - Restaurantes
	   		//U_AEST100E(oEventL)

			SetFunName(cFunNamAnt)
			
			// -> Destava execucao da rotina
			If lLock
				UnLockByName("AEST_"+cUndMad)
			EndIf
		
		EndIf	
		
		If lxBatch		
			RpcClearEnv()
		EndIf					                         	
	
   	Next na

Return("")




/*-----------------+---------------------------------------------------------+
!Nome              ! RunMRP - Cliente: Madero                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Execucao do MRP                                         !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 22/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function xRunMRP(cUndMad, nDiasMx, oEventLog, nDiasMxF)
Local cMsgErr     := ""
Local cErrLinha   := "" 
Local cAliTmp0    := GetNextAlias()
Local cAliTmp2    := GetNextAlias()
Local cAliTmp3    := GetNextAlias()
Local lMRP        := .t.
Local nx, nk      := 0 
Local aParmMRP    := {}
Local lRet        := .T.
Local aArea       := GetArea()
Local cAuxF       := cFilAnt
Local cAuxE       := cEmpAnt
Local _xaEventLog := {} 
Local lFound      := .T.
Local lFoundInd   := .F.
Local aDatasMRP	  := {}
Local dDataNec    := CtoD("  /  /  ")
Local cZ25GRPCOM  := ""
Local cZ25GRPPRO  := ""
Local nZ25XDIAES  := 0
Local cZ25CODFOR  := ""
Local cZ25CODLOJ  := ""
Local cZ25CODTAB  := ""
Local nZ25VALOR   := 0
Local cZ25CC      := ""
Local cZ25OP      := ""
Local cZ25TES     := ""
Local lErroZ25    := .F.
Local aErroZ25    := {}
Local cQuery      := "" 
Local aPerg711    := {}
Local aParEmpFil // Parametro de Empresa;Filial da Fabrica
Local cParEmpF   // Codigo da empresa da Fabrica
Local cParFilF   // Codigo da filial da Fabrica
Local aTmpQry
Local cDtCalc
Local dDtCalc   
Local oError
Private aHeader   :={} 
Private aCols     :={}
Private n    	  :=1
	
	cAuxLog:=': Verificando demandas calculadas...' 
	ConOut(cAuxLog)                              
	oEventLog :SetAddInfo(cAuxLog,"")
	aParEmpFil:=separa(GetMV("MV_XFILIND"), ";")			
	dDtCalc   := dDataBase+nDiasMxF
	cDtCalc   := dtos(dDtCalc)
	sDataBase := DtoS(dDataBase)
	
	BEGINSQL ALIAS cAliTmp0
		SELECT Z25_DATA, Z25_DTNECE
		FROM %table:Z25% Z25
		JOIN %table:SB1% SB1
			ON Z25.Z25_FILIAL  = SB1.B1_FILIAL AND 
			   Z25.Z25_PRODUT  = SB1.B1_COD    AND 
			   SB1.%notDel%
		WHERE Z25.Z25_FILIAL  = %exp:cUndMad%   AND 
		      Z25.Z25_DATA    = %exp:sDataBase% AND
		      Z25.Z25_PEDIDO <> ' '             AND 
		      Z25.%notDel% 
	ENDSQL 
	aTmpQry := GetLastQuery()
	lMRP    := (cAliTmp0)->(eof())      
	(cAliTmp0)->(dbCloseArea())
		
	If lMRP
	
		If AllTrim(oEventLog:GetStep()) $ "01"
	
			cAuxLog:=': Excluindo demandas já calculadas...' 
			ConOut(cAuxLog)                              
			oEventLog:SetAddInfo(cAuxLog,"")			

			cQuery := " DELETE FROM "+RetSQLName("Z25")            "
			cQuery += " WHERE Z25_FILIAL = '" + xFilial("Z25")+ "' "
			cQuery += " AND Z25_DATA >= '" + DtoS(dDataBase)  + "' "
			TCSqlExec(cQuery)
	
			cAuxLog:='Ok.' 
			ConOut(cAuxLog)                              
			oEventLog:SetAddInfo(cAuxLog,"")			
	
			cAuxLog:=': Executando calculo do MRP...' 
			ConOut(cAuxLog)                              
			oEventLog:SetAddInfo(cAuxLog,"")			
			aParmMRP := {cEmpAnt, cFilAnt, cUndMad, nDiasMx,  oEventLog, cFilAnt, nDiasMxF, dDataBase}
			lRet     := U_AESTMRP(aParmMRP,@aPerg711)			
			If lRet
				cAuxLog:='Ok.' 
				ConOut(cAuxLog)                              
				oEventLog:SetAddInfo(cAuxLog,"")			
			EndIf			
				
			// -> Valida os produtos das solicitações de compras geradas com o cadastro de produtos x fornecedores
			If lRet
		
				cAuxLog:=': Validando parametros da industria...' 
				ConOut(cAuxLog)                              
				oEventLog:SetAddInfo(cAuxLog,"")					
		
				// -> Verifica se os dados da filial 'indústria' estão ok.
				If (len(aParEmpFil) < 2 .or. empty(aParEmpFil[1]) .or. empty(aParEmpFil[2]))
					cParEmpF := GetMV("MV_XFILIND")
					cAuxLog  := "Parametro MV_XFILIND [" + trim(cParEmpF) + "] incorreto. Esperado no formato EE;FFFFFFFFF (EE - Empresa, FFFFFFFFF - Unidade)"
					lRet     := .F.
					ConOut(cAuxLog)                              
					oEventLog:SetAddInfo(cAuxLog,"")
				Else
					// -> Captura o CNPJ da filial da indústria		   	
					cAux:=cEmpAnt+cFilAnt
					SM0->(DbSetOrder(1))
					If !SM0->(DbSeek(aParEmpFil[1]+aParEmpFil[2]))
						cAuxLog  := "Empresa e fiial nao encontrado no cadastro de empresas [M0_CODIGO = " + aParEmpFil[1] + " / M0_CODFIL = " + aParEmpFil[2] + "]"
						lRet     := .F.
						ConOut(cAuxLog)                              
						oEventLog:SetAddInfo(cAuxLog,"")
					Else
						aadd(aParEmpFil,SM0->M0_CGC)
					EndIf
					// -> Reposiciona na filial atual
					SM0->(DbSetOrder(1))
					SM0->(DbSeek(cAux))
				EndIf			
			Else
				cAuxLog:='Erro.' 
				ConOut(cAuxLog)                              
				oEventLog:SetAddInfo(cAuxLog,"")					
			EndIf	

			// -> Valida os produtos das solicitações de compras geradas com o cadastro de produtos x fornecedores
			If lRet

				// -> Conforme chamado 3597482, que trata o problema de performance, não será mais gerado as SCs e OPs e a necessidade
				//    será gravada em tabela temporária
		
				cAuxLog:=': Salvando demandas calculadas...' 
				ConOut(cAuxLog)                              
				oEventLog:SetAddInfo(cAuxLog,"")
			
				BEGINSQL Alias cAliTmp3
				SELECT CZJ.CZJ_PROD, 
				   	SB1.B1_DESC,
				   	SB1.B1_XDIAES,
				   	SB1.B1_GRUPO,
				   	SB1.B1_GRUPCOM,				
				   	CZK.CZK_PERMRP, 
				   	CZK.CZK_QTNECE, 
				   	CZI.CZI_NRRGAL,                
				   	CZI.CZI_DTOG,                  
				   	CZI.CZI_QUANT   
				FROM %Table:CZJ% CZJ JOIN %Table:CZK% CZK ON CZK.%NotDel% AND
					CZK.CZK_FILIAL = %xFilial:CZK%  AND
					CZK.CZK_RGCZJ  = CZJ.R_E_C_N_O_ AND
					CZK.CZK_QTNECE > 0
				JOIN %Table:CZI% CZI ON CZI.%NotDel% AND
					CZI.CZI_FILIAL = %xFilial:CZI% AND
					CZI.CZI_NRMRP  = CZJ.CZJ_NRMRP AND
					CZI.CZI_ALIAS  = 'PAR'
				JOIN %Table:SB1% SB1 ON SB1.%NotDel% AND
					SB1.B1_FILIAL = %xFilial:SB1%  AND
					SB1.B1_COD    = CZJ.CZJ_PROD
				WHERE CZJ.%NotDel% AND
					CZJ.CZJ_FILIAL = %xFilial:CZJ% AND
					NOT EXISTS (SELECT 1 FROM %Table:SG1% SG1 
								WHERE SG1.%NotDel%                  AND 
									  SG1.G1_FILIAL = %xFilial:SG1% AND 
					                  SG1.G1_COD    = CZJ.CZJ_PROD)
				ORDER BY CZJ.CZJ_NRLV, CZJ.CZJ_FILIAL, CZJ.CZJ_PROD, CZK.CZK_PERMRP                 
				ENDSQL
                            
				If (cAliTmp3)->(Eof())
					lRet:=.F.
					cAuxLog:=': Nao ha necessidades de compras para o peíodo...' 
					ConOut(cAuxLog)                              
					oEventLog:SetAddInfo(cAuxLog,"")        	
				EndIf

				BEGIN TRANSACTION

					// -> Grava necessidades calculadas
                	If lRet
                		DbSelectArea("Z25")
                		Z25->(DbSetorder(1))	
                		aDatasMRP := GetMRPPer((cAliTmp3)->CZI_NRRGAL,StoD((cAliTmp3)->CZI_DTOG),(cAliTmp3)->CZI_QUANT,aPerg711)
                		cZ25GRPCOM:= ""
                		cZ25GRPPRO:= ""
                		nZ25XDIAES:= 0
                		cZ25CODFOR:= ""
                		cZ25CODLOJ:= ""
                		cZ25CODTAB:= ""
                		nZ25VALOR := 0
                		cZ25CC    := ""
                		cZ25OP    := ""
                		cZ25TES   := ""
                		lFound    := .T.
                		lFoundInd := .F.
                		lErroZ25  := .F. 
                		aErroZ25  := {}           

                		While !(cAliTmp3)->(Eof())

							dDataNec := aDatasMRP[Val((cAliTmp3)->CZK_PERMRP)]
                			lFound   :=.T.
                			lFoundInd:=.F.
                			cAuxLog:='Demanda em '+Dtoc(dDataNec)+' para o produto ' + AllTrim((cAliTmp3)->CZJ_PROD) +" - " + AllTrim((cAliTmp3)->B1_DESC) 
                			ConOut(cAuxLog)                              
                			oEventLog:SetAddInfo(cAuxLog,"")        	

                			// -> Verifica se existe a necessidade para a data e produto e, caso exista apenas soma a quantidade
                			If !Z25->(DbSeek(xFilial("Z25")+Dtos(dDataBase)+DtoS(dDataNec)+(cAliTmp3)->CZJ_PROD))                              

                				// Variável utiliza em u_xSB1SC1
                				aHeader   :={{,"C1_PRODUTO"       }} 
                				aCols     :={{(cAliTmp3)->CZJ_PROD}}
                				n    	  :=1
                				cZ25GRPCOM:=(cAliTmp3)->B1_GRUPCOM
                				cZ25GRPPRO:=(cAliTmp3)->B1_GRUPO
                				nZ25XDIAES:=(cAliTmp3)->B1_XDIAES
        			
                				// -> Verifica grupo de compra e comprador
                				If Empty(cZ25GRPCOM)  
            				
                					// -> Verifica o grupo de compras e comprador
                					SAJ->(DbSetOrder(1))
                					If !SAJ->(DbSeek(xFilial("SAJ")+cZ25GRPCOM))
                						cAuxLog:=': Grupo de compras nao cadastrado. [B1_GRUPCOM='+cZ25GRPCOM+']' 
                						lFound :=.F.
                						ConOut(cAuxLog)                              
                						AADD(aErroZ25,cAuxLog)
                					Else
                						If Empty(SAJ->AJ_USER) 
                							cAuxLog:=': Sem comprador para o grupo de compras ' + SB1->B1_GRUPCOM + '. [AJ_USER = Vazio] 
                							lFound :=.F.
                							ConOut(cAuxLog)                              
                							AADD(aErroZ25,cAuxLog)
                						EndIf						
                					EndIf
                				EndIf
		
                				// -> Verifica se existe no cadastro de produtos x fornecedor
                				If !u_xSB1SC1("C1_PRODUTO", "F") 			
                					cAuxLog:='Produto nao encontrado no cadastro de produtos x fornecedor.[B1_COD='+(cAliTmp3)->CZJ_PROD+']' 
                					lFound :=.F.
                					ConOut(cAuxLog)                              
                					AADD(aErroZ25,cAuxLog)
                					(cAliTmp3)->(DbSkip())
                					Loop
                				Else
                					cZ25CODFOR:=SA5->A5_FORNECE
                					cZ25CODLOJ:=SA5->A5_LOJA
                					cZ25CODTAB:=SA5->A5_CODTAB
                					nZ25VALOR :=u_xSB1SC1("C1_VUNIT"  , "G")
                					cZ25CC    :=u_xSB1SC1("C1_CC"     , "G")
                					cZ25OP    :=SA5->A5_XOPER
                					// -> Posiciona no cadastro de produto
                					SB1->(DbSetOrder(1))
                					If !SB1->(DbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
                						cAuxLog:='Produto nao encontrado na tabela SB1.[B1_COD='+(cAliTmp3)->CZJ_PROD+']' 
                						lFound :=.F.
                						ConOut(cAuxLog)                              
                						AADD(aErroZ25,cAuxLog)
                						(cAliTmp3)->(DbSkip())
                						Loop
                					EndIf                				
                				EndIf

                				// -> Verifica dados do fornecedor, se o produto foi encontrado no cadastro de produtos x fornecedor
                				If lFound
                					If Empty(cZ25CODFOR) .or. Empty(cZ25CODLOJ)
                						cAuxLog:='Erro: Sem codigo do fornecedor e loja para o produto x fornecedor. [B1_COD='+(cAliTmp3)->CZJ_PROD+']' 
                						lFound :=.F.
                						ConOut(cAuxLog)
                						AADD(aErroZ25,cAuxLog)
                					Else
                						// -> Verifica se o Fornecedor é relacionado a indústria e valida o cadastro do produto na industria
                						SA2->(DbSetOrder(1))
                						If !SA2->(DbSeek(xFilial("SA2")+cZ25CODFOR+cZ25CODLOJ))
                							cAuxLog:='Erro: O fornecedor informado no cadastro de produtos x fornecedor nao foi encontrado. [A5_FORNECE = '+SA5->A5_FORNECE+" / A5_LOJA = "+ SA5->A5_LOJA+"]" 
                							lFound :=.F.
                							ConOut(cAuxLog)                              
                							AADD(aErroZ25,cAuxLog)
                						Else
                							// -> Verifica operação fiscal
                							If Empty(cZ25OP)
                								lFound :=.F.
                								cAuxLog:= "Sem informacao da operacao fiscal no cadastro de Produto x Fornecedor [A5_FORNECE = " + SA5->A5_FORNECE + " /  A5_LOJA = " + SA5->A5_LOJA + " / A5_PRODUTO = " + SA5->A5_PRODUTO + "]"
                								ConOut(cAuxLog)
                								AADD(aErroZ25,cAuxLog)
                							Else
                								cZ25TES:=MaTESInt(1, SA5->A5_XOPER, SA2->A2_COD, SA2->A2_LOJA, "F", SA5->A5_PRODUTO)
                								SF4->(dbSetOrder(1))
                								If !SF4->(dbSeek(xFilial("SF4")+cZ25TES))
                									lFound :=.F.
                									cAuxLog:="TES nao encontrada para a operacao fiscal informada no cadastro de Produtos x Fornecedor [A5_FORNECE = " + SA2->A2_COD + " /  A5_LOJA = " + SA2->A2_LOJA + " / A5_PRODUTO = " + SA5->A5_PRODUTO + "]"
                									ConOut(cAuxLog)
                									AADD(aErroZ25,cAuxLog)                								
                								Else
                									If SF4->F4_DUPLIC = "S" .and. Empty(SA2->A2_COND)
                										lFound :=.F.
                										cAuxLog:="Condicao de pagamento invalida no cadastro do fornecedor [A5_FORNECE = " + SA2->A2_COD + " /  A5_LOJA = " + SA2->A2_LOJA + "]"
                										ConOut(cAuxLog)
                										AADD(aErroZ25,cAuxLog)                								
                									Else
                										// -> Verifica se é indústria
                										If AllTrim(SA2->A2_CGC) == AllTrim(aParEmpFil) .and. Alltrim(aParEmpFil) <> ""
                											cQuery:="SELECT B1_COD "
                											cQuery+="FROM SB1"+aParEmpFil[1]+" SB1                         " 
                											cQuery+="WHERE SB1.B1_FILIAL   = '" + aParEmpFil[2]   + "' AND " 
                											cQuery+="      SB1.B1_COD      = '" + SA5->A5_CODPRF  + "'     " 
                											cQuery+="      D_E_L_E_T_  <> '*'                              "
                											dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliTmp2,.T.,.T.)				
                											(cAliTmp2)->(dbGoTop())
                											lFoundInd:=.F.
                											While !(cAliTmp2)->(Eof())
                												lFoundInd:=.T.
                												Exit
                												(cAliTmp2)->(DbSkip())
                											EndDo
                											(cAliTmp2)->(DbCloseArea())
						
                											If !lFoundInd
                												cAuxLog:='Erro: Produto nao cadastrado na industria. [A5_PRODUTO = ' + SA5->A5_PRODUTO + ']' 
                												lFound :=.F.
                												ConOut(cAuxLog)                              
                												AADD(aErroZ25,cAuxLog)
                											EndIf													
                										EndIf
                									EndIf						
                								EndIf
                							Endif
                						EndIf
                					EndIf
		
                					// -> Verifica fator de conversão no fornecedor
                					If SA5->A5_XCVUNF <= 0
                						lFound:=.F.
                						cAuxLog:='Erro: Sem fator de conversao no cadastro de produtos x fornecedor. [A5_XCVUNF <= 0]' 
                						ConOut(cAuxLog)                              
                						AADD(aErroZ25,cAuxLog)
                					EndIf
		
                					// -> Verifica tipo do fator de conversão no fornecedor
                					If Empty(SA5->A5_XTPCUNF)
                						lFound:=.F.
                						cAuxLog:='Erro: Sem tipo do fator de conversao no cadastro de produtos x fornecedor. [A5_XTPCUNF = Vazio]' 
                						ConOut(cAuxLog)                              
                						AADD(aErroZ25,cAuxLog)
                					EndIf
		
                					// -> Verifica operação fiscal no cadastro de produtos x fornecedor
                					If Empty(SA5->A5_XOPER)
                						lFound:=.F.
                						cAuxLog:='Erro: Sem operacao fiscal no cadastro de produtos x fornecedor. [A5_XOPER = Vazio]' 
                						ConOut(cAuxLog)                              
                						AADD(aErroZ25,cAuxLog)
                					EndIf
			
                					// -> Verifica tabela de preço (AIA / AIB)
                					If Empty(cZ25CODTAB) .or. nZ25VALOR <= 0
                						lFound:=.F.
                						cAuxLog:='Erro: Sem tabela de preco no cadastro de produtos x fornecedor ou sem preco decompra. [A5_CODTAB = Vazio]' 
                						ConOut(cAuxLog)                              
                						AADD(aErroZ25,cAuxLog)
                					EndIf	
                			
                					// -> Valida calendário de entrega
                					Z22->(DbSetOrder(1))
                					If !Z22->(DbSeek(xFilial("Z22")+cFilAnt+SA2->A2_COD+SA2->A2_LOJA+cZ25GRPCOM))
                						cAuxLog:='Erro: Nao encotrado no calendario de entrega o grupo de compras relacionado ao produto. [A2_COD='+SA2->A2_COD+', A2_LOAJ='+SA2->A2_LOJA+' e B1_GRUPCOM = ' + cZ25GRPCOM + ']' 
                						lFound :=.F.
                						ConOut(cAuxLog)                              
                						AADD(aErroZ25,cAuxLog)														
                					Else
                						// -> Verifica se existe data para próxima entrega
                						If Empty(Z22->Z22_DTNXEN)
                							cAuxLog:="Erro: Data da proxima entrega nao encontrada da para a unidade, fornecedor e grupo de compras. [Z22_CODUN="+cFilAnt+", Z22_FON="+SA2->A2_COD+", Z22_LOJA="+SA2->A2_LOJA+" e Z22_GRUPO="+cZ25GRPCOM+"]" 
                							lFound :=.F.
                							ConOut(cAuxLog)                              
                							AADD(aErroZ25,cAuxLog)
                						EndIf															
                					EndIf
                				EndIf	
            			
                				// -> Grava as necessidades calculadas, se não ocorreu nenhum erro
                				If lFound
                					If RecLock("Z25",.T.)
                						Z25->Z25_FILIAL := xFilial("Z25")
                						Z25->Z25_DATA   := dDataBase
                						Z25->Z25_DTNECE := dDataNec
                						Z25->Z25_PRODUT := (cAliTmp3)->CZJ_PROD
                						Z25->Z25_DESCPR := (cAliTmp3)->B1_DESC
                						Z25->Z25_GRPCOM := (cAliTmp3)->B1_GRUPCOM
                						Z25->Z25_GRPPRO := (cAliTmp3)->B1_GRUPO
                						Z25->Z25_XDIAES := (cAliTmp3)->B1_XDIAES
                						Z25->Z25_CODFOR := SA2->A2_COD
                						Z25->Z25_CODLOJ := SA2->A2_LOJA
                						Z25->Z25_DESCFO := SA2->A2_NOME
                						Z25->Z25_QUANT  := (cAliTmp3)->CZK_QTNECE  
                						Z25->Z25_CODTAB := cZ25CODTAB
                						Z25->Z25_VALOR  := nZ25VALOR
                						Z25->Z25_CC     := cZ25CC
                						Z25->Z25_OP     := cZ25OP
                						Z25->Z25_TES    := cZ25TES
                						Z25->(MsUnlock())        			
                						cAuxLog :="Ok, incluido."	    
                						oEventLog:SetAddInfo(cAuxLog,"")
                						ConOut(cAuxLog)					
                					Else
                						cAuxLog :="Erro na inclusao."	    
                						AADD(aErroZ25,cAuxLog)
                						ConOut(cAuxLog)					
                						lErroZ25 :=.T.	
                					EndIf
                				Else
                					lErroZ25 :=.T.
                				EndIf	            		
                			Else
                				If RecLock("Z25",.F.)
                					Z25->Z25_QUANT += (cAliTmp3)->CZK_QTNECE  
                					Z25->(MsUnlock())
                					cAuxLog :="Ok, alterado."	    
                					oEventLog:SetAddInfo(cAuxLog,"")
                					ConOut(cAuxLog)					
                				Else
                					cAuxLog :="Erro na alteracao."	    
                					AADD(aErroZ25,cAuxLog)
                					ConOut(cAuxLog)					
                					lErroZ25 :=.T.	
                				EndIf
                			EndIf
                			(cAliTmp3)->(dbSkip())
                		EndDo
                		(cAliTmp3)->(DbCloseArea())
                	        	
                		// -> Verifica se houve problemas no cadastro e, se houver, aborta o processo
                		If lErroZ25
                			ConOut("Desarmou transacao...")
                			DISARMTRANSACTION()
                		EndIf

                	EndIf	

                	END TRANSACTION
                
                	// -> Verifica se houve problemas no cadastro e, se houver, grava dados no log
                	If lErroZ25
                		cAuxLog:=': Gravando log...' 
                		ConOut(cAuxLog)                              
                		oEventLog:SetAddInfo(cAuxLog,"")
                		For nk:=1 to Len(aErroZ25)
                		oEventLog:SetAddInfo(aErroZ25[nk],"")
                	Next nk
                	cAuxLog:='Ok.' 
                	ConOut(cAuxLog)                              
                	oEventLog:SetAddInfo(cAuxLog,"")
                	cAuxLog  :="Corrija os erros de cadastro para que o processo continue."
                	oEventLog:broken("Na execucao.", cAuxLog, .T.)
                	lRet     :=.F.
                EndIf
        
            Else        
            
            	cAuxLog  :="Erro."
            	oEventLog:SetAddInfo(cAuxLog,"")
            	lRet     :=.F.
        
            EndIf   

            cAuxF:=cFilAnt
            cAuxE:=cEmpAnt
            aArea:=GetArea()
			
            // -> Gera demandas para indústria
            If lRet 
				
            	cAuxLog:=': Executando calculo da demanda para industria...' 
            	ConOut(cAuxLog)                              
            	oEventLog:SetAddInfo(cAuxLog,"")

            	_xaEventLog:={}			
            	cParEmpF   := trim(aParEmpFil[1])
            	cParFilF   := trim(aParEmpFil[2])
            	aParmMRP   := {cParEmpF, cParFilF, cEmpAnt+"0", nDiasMx, oEventLog, cFilAnt, nDiasMxF, dDataBase}
										
            	TRYEXCEPTION
					
            		_xaEventLog:=startJob("U_AEST102", GetEnvServer(), .T., aParmMRP)

            	CATCHEXCEPTION USING oError
		
            		lRet   := .F.
            		cAuxLog:=procname()+"("+cValToChar(procline())+")" + oError:Description 
            		Conout(cAuxLog + Chr(13) + Chr(10) + 'Detalhamento :'+varinfo('oError',oError))
            		oEventLog:broken("Na execucao.", cAuxLog , .T.)
	
            	ENDEXCEPTION
					
            	// -> Verifica se ocorreu erros na geração dos dados para a industria 
            	For nx:=1 to Len(_xaEventLog)
            		If nx <= 1
            			lRet:=.F.
            			cAuxLog:="Erro: Produtos nao encontrados na industria."	    
            			oEventLog:SetAddInfo(cAuxLog,"")
            			ConOut(cAuxLog)
            		EndIf
            		cAuxLog:=_xaEventLog[nx]	    
            		oEventLog:SetAddInfo(cAuxLog,"")
            		ConOut(cAuxLog)
            	Next nx	

            	// -> Se nao ocorreu erro na inclusao dos dados na industria
            	If lRet
            		cAuxLog:='Ok.' 
            		ConOut(cAuxLog)                              
            		oEventLog:SetAddInfo(cAuxLog,"")
            	EndIf
		
            Else													

            	cAuxLog:='Erro.' 
            	ConOut(cAuxLog)                              
            	oEventLog:SetAddInfo(cAuxLog,"")
		
            Endif
			
            RestArea(aArea)
            SM0->(dbSetOrder(1))
            SM0->(dbSeek(cAuxE+cAuxF))
            cEmpAnt := SM0->M0_CODIGO
            cFilAnt := SM0->M0_CODFIL
		
            // -> Se ocorreu tudo ok, libera para o passo seguinte
            If lRet
            	oEventLog:SetStep("02")
            EndIf
            
        Else

            cAuxLog:='Ok.' 
            ConOut(cAuxLog)                              
            oEventLog:SetAddInfo(cAuxLog,"")        
        
        EndIf

	Else
		
		cAuxLog:='Ok. Ja existem pedidos de venda firmados para esta data.' 
		ConOut(cAuxLog)                              
		oEventLog:SetAddInfo(cAuxLog,"")
		
	EndIf
						
return(lRet)




/*-----------------+---------------------------------------------------------+
!Nome              ! AESTMRP - Cliente: Madero                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Execução do processo de MRP                             !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 22/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function AESTMRP(paramixb,aPerg711)
Local cErrLinha := ""
Local oError
Local cCapital
Local PARAMIXB1 := .T.          //-- .T. se a rotina roda em batch, senão .F.
Local PARAMIXB2 := {}
Local cUndMad   := paramixb[3]
Local nxDiasEMx := paramixb[4]
Local oEventLog := paramixb[5]
Local nxDiasEMxF:= paramixb[6]
Local aMRP      := GetArea()
Local cAuxLog   := ""
Local lErro     := .F.
Private lMsErroAuto := .F.

	cAuxLog:=': Atualizando parametros do processo.....' 
	ConOut(cAuxLog)                              
	oEventLog:SetAddInfo(cAuxLog,"")

    aAdd(PARAMIXB2, 1)                            //-- Tipo de período 1=Diário; 2=Semanal; 3=Quinzenal; 4=Mensal; 5=Trimestral; 6=Semestral
    aAdd(PARAMIXB2, nxDiasEMx)                    //-- Quantidade de períodos
    aAdd(PARAMIXB2, .F.)                          //-- Considera Pedidos em Carteira
    aAdd(PARAMIXB2, {})                           //-- Array contendo Tipos de produtos a serem considerados (se Nil, assume padrão)
    aAdd(PARAMIXB2, {})                           //-- Array contendo Grupos de produtos a serem considerados (se Nil, assume padrão)
    aAdd(PARAMIXB2, .F.)                          //-- Gera/Nao Gera OPs e SCs depois do calculo da necessidade.
    aAdd(PARAMIXB2, .F.)                          //-- Indica se monta log do MRPaAdd(PARAMIXB2,"000001")
    aAdd(PARAMIXB2, Space(TamSx3("C2_NUM")[1]))   //-- numero inicial da op - conforme solicitado através do chamado 3034556
            
    // ****************************
    // * Monta a Tabela de Tipos  *
    // ****************************
    dbSelectArea("SX5")
    SX5->(dbSetOrder(1))
    SX5->(dbSeek(xFilial("SX5")+"ZC"))
    Do While (SX5->X5_FILIAL == xFilial("SX5")) .AND. (SX5->X5_TABELA == "ZC") .and. !SX5->(Eof())
        cCapital := OemToAnsi(Capital(X5Descri()))        
        AADD(PARAMIXB2[4],{.T.,SubStr(SX5->X5_chave,1,2)+" - "+cCapital})
        SX5->(dbSkip())
    EndDo
        
    // ****************************
    // * Monta a Tabela de Grupos *
    // ****************************
    dbSelectArea("SBM")
    SBM->(dbSetOrder(1))
    SBM->(dbSeek(xFilial("SBM")))
    AADD(PARAMIXB2[5],{.T.,Criavar("B1_GRUPO",.F.)+" - "+"Grupo em Branco"})
    Do While (SBM->BM_FILIAL == xFilial("SBM")) .AND. !SBM->(Eof())
        cCapital := OemToAnsi(Capital(SBM->BM_DESC))        
        AADD(PARAMIXB2[5],{.T.,SubStr(SBM->BM_GRUPO,1,4)+" - "+cCapital})
        SBM->(dbSkip())
    EndDo
    
    Pergunte("MTA712",.F.)
    u_zAtuPerg("MTA712", "MV_PAR04", 2)
    u_zAtuPerg("MTA712", "MV_PAR05", dDataBase)
    u_zAtuPerg("MTA712", "MV_PAR06", dDataBase + nxDiasEMx)
    u_zAtuPerg("MTA712", "MV_PAR08", "  ")
    u_zAtuPerg("MTA712", "MV_PAR09", "ZZ")
    u_zAtuPerg("MTA712", "MV_PAR10", 2)
    
    MV_PAR01 := 1  // Executa o MRP considerando a previsão de vendas
	MV_PAR02 := 1  // Gera SCs pela necessidade 
	MV_PAR03 := 1  // Gera OPs dos produtos intermediários por necessidade
	MV_PAR04 := 2  // Gera OPs e SCs utilizando o mesmo período (1 = Junto)
	MV_PAR05 := dDataBase // Data inicial da previsão de vendas 
	MV_PAR06 := dDataBase + nxDiasEMx  // Data final da previsão de vendas 
	MV_PAR07 := 2  // Incrementa OPs por número 
	MV_PAR08 := "  " // Armazém inicial 
	MV_PAR09 := "ZZ" // Armazém Final
	MV_PAR10 := 2  // Tipo da OP a ser gerada  (2 = Prevista)
	MV_PAR11 := 1  // Apaga ordens de produção previstas (1 = Sim)
	MV_PAR12 := 1  // Considera sábados e domingos(1 = Sim)
	MV_PAR13 := 1  // Considera OPs suspensas(1 = Sim) 
	MV_PAR14 := 1  // Considera OPs sacramentadas (1 = Sim)
	MV_PAR15 := 1  // Recalcula níveis das estruturas (1 = Sim)
	MV_PAR16 := 2  // Trata o produto intermediário normalmente (2 = Nao)
	MV_PAR17 := 2  // Não exclui pedidos de venda  (2 = Nao Subtrai)
	MV_PAR18 := 1  // Considera o saldo atual em estoque (1 = Saldo Atual) 
	MV_PAR19 := 1  // Se atingir o estoque máximo, considera a quantidade original(1 = Qtde Original)
	MV_PAR20 := 2  // Não considera saldo em poder de terceiros (2 = Ignora)
	MV_PAR21 := 2  // Não considera saldo de terceiros em nosso poder (2 = Ignora)
	MV_PAR22 := 2  // Não subtrai saldos rejeitados pelo CQ  (2 = Nao Subtrai Rej)
	MV_PAR23 := "         "   // Documento inicial 
	MV_PAR24 := "ZZZZZZZZZ"   // Documento Final
	MV_PAR25 := 2  //  Não subtrai saldos bloqueados por lote ("2" = Nao Subtrai )
	MV_PAR26 := 1  //  Considera estoque de segurança                        ( 1 = Sim )
	MV_PAR27 := 2  //  Não considera pedidos de vendas boleados por crédito  ( 2 = Não )
	MV_PAR28 := 2  //  Não resume dados                                      ( 2 = Não )
	MV_PAR29 := 2  //  Não detalha lotes vencidos                            ( 2 = Não )
	MV_PAR30 := 1  //  Pedidos de Venda  faturados ?                 ( 2 = Nao Subtrai  )
	MV_PAR31 := 1  //  Considera Ponto de Pedido ?                            ( 1 = Sim )
	MV_PAR32 := 1  //  Gera base de dados com o cálculo da necessidade       ( 1 = Sim )
	MV_PAR33 := ""
	MV_PAR34 := ""
	MV_PAR35 := 1  // Exibe resultados em lista
	
	AADD(aPerg711,MV_PAR01)
	AADD(aPerg711,MV_PAR02)
	AADD(aPerg711,MV_PAR03)
	AADD(aPerg711,MV_PAR04)
	AADD(aPerg711,MV_PAR05)
	AADD(aPerg711,MV_PAR06)
	AADD(aPerg711,MV_PAR07)
	AADD(aPerg711,MV_PAR08)
	AADD(aPerg711,MV_PAR09)
	AADD(aPerg711,MV_PAR10)
	AADD(aPerg711,MV_PAR11)
	AADD(aPerg711,MV_PAR12)
	AADD(aPerg711,MV_PAR13)
	AADD(aPerg711,MV_PAR14)
	AADD(aPerg711,MV_PAR15)
	AADD(aPerg711,MV_PAR16)
	AADD(aPerg711,MV_PAR17)
	AADD(aPerg711,MV_PAR18)
	AADD(aPerg711,MV_PAR19)
	AADD(aPerg711,MV_PAR20)
	AADD(aPerg711,MV_PAR21)
	AADD(aPerg711,MV_PAR22)
	AADD(aPerg711,MV_PAR23)
	AADD(aPerg711,MV_PAR24)
	AADD(aPerg711,MV_PAR25)
	AADD(aPerg711,MV_PAR26)
	AADD(aPerg711,MV_PAR27)
	AADD(aPerg711,MV_PAR28)
	AADD(aPerg711,MV_PAR29)
	AADD(aPerg711,MV_PAR30)
	AADD(aPerg711,MV_PAR31)
	AADD(aPerg711,MV_PAR32)
	AADD(aPerg711,MV_PAR33)
	AADD(aPerg711,MV_PAR34)
	AADD(aPerg711,MV_PAR35)

	cAuxLog:=': Executando MATA712...' 
	ConOut(cAuxLog)                              
	oEventLog:SetAddInfo(cAuxLog,"")
	
	TRYEXCEPTION

		MATA712(PARAMIXB1,PARAMIXB2)  
	
	CATCHEXCEPTION USING oError
	    lErro  :=.T.
		if valtype(oError) = 'O'
			cAuxLog:=procname()+"("+cValToChar(procline())+")" + oError:Description
			Conout(cAuxLog)     
		Else
			cAuxLog:=procname()+"("+cValToChar(procline())+")" 
			Conout(cAuxLog)     		
		EndIf	           
	
	ENDEXCEPTION
	
	If lErro		
		oEventLog:broken("Na execucao da rotina MATA712.", cAuxLog , .T.)
	Else	
		cAuxLog:=IIF(lErro,"Erro.","Ok.") 
		ConOut(cAuxLog)
		oEventLog:SetAddInfo(cAuxLog,"")
	Endif
		                              
	RestArea(aMRP)

Return(!lErro)




/*-----------------+---------------------------------------------------------+
!Nome              ! AESTFIR - Cliente: Madero                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Firma SCs                                               !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 22/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function AESTFIR(cUndMad, oEventLog, nDiasMxF)
Local cAliTmp0  := GetNextAlias()
Local cAuxLog   := ""
Local lErro     := .F.                     
Local cDtCalcI  := DtoS(dDataBase)
Local cDtCalcF  := DtoS(dDataBase+nDiasMxF)
Local cQuery    := ""
Local aCalendar := {}
Local nu        := 0
Local nAux      := 0
Local aAuxDias  := {}
Local aAuxLog   := {}
Local dAuxIni   := dDataBase
Local dAux      := dDataBase
Local dDataNova := CtoD("  /  /  ")
Local dDataProx := CtoD("  /  /  ")
Local nAuxDia   := 0
Local aTmpQry
Local oError

	// -> Verifica se o processo de MRP (passo 02) foi executado, caso contrário, retorna erro
	If AllTrim(oEventLog:GetStep()) <> "02"
		cAuxLog:="Ok."
		ConOut(cAuxLog)                         
		oEventLog:SetAddInfo(cAuxLog,"")
		Return(.F.)
	EndIf
	
	// -> Verificando datas de entregas, conforme calendário
	Z22->(dbSetOrder(1))
	Z22->(dbSeek(xFilial("Z22")+cUndMad))	
	While !Z22->(Eof()) .and. AllTrim(Z22->Z22_FILIAL) == AllTrim(xFilial("Z22")) .and. AllTrim(Z22->Z22_CODUN) == AllTrim(cUndMad)	
		aAuxDias:=StrToKarr(Z22->Z22_DIA,",")
		For nu:=1 to Len(aAuxDias)
			// -> Semanal
			If Z22->Z22_TIPO == "S"
				nAux   :=aScan(aCalendar,{|xbc| xbc[1] == Z22->Z22_FILIAL+Z22->Z22_FORN+Z22->Z22_LOJA+Z22->Z22_GRUPO,Z22->Z22_TIPO})
				dAuxIni:=IIF(nAux<=0,Z22->Z22_DTULEN,aCalendar[Len(aCalendar),5])
				// -> Calcula nova data de entrega - quando houver uma entrega por semana
				If Len(aAuxDias) <= 1
					dDataNova:=dAuxIni  +7
					dDataProx:=dDataNova+7
				Else  // -> Quando houver várias entregas
					// -> Data de Entrega
					dAux:=dAuxIni
					While StrZero(Dow(dAux),2) <> StrZero(Val(aAuxDias[nu]),2)
						dAux:=dAux+1
					EndDo
					dDataNova:=dAux
					// -> Proxima data de entrega
					dAux:=dDataNova
					nAux:=nu
					If nu < Len(aAuxDias)
						nAux:=nAux+1
						nAux:=Val(aAuxDias[nAux])
					ElseIf nu == Len(aAuxDias)
						nAux:=1
						nAux:=Val(aAuxDias[nAux])
					Else
						nAux:=Val(aAuxDias[nAux])
					EndIf 
					While StrZero(Dow(dAux),2) <> StrZero(nAux,2)
						dAux:=dAux+1
					EndDo
					dDataProx:=dAux				
				EndIf					
				AADD(aCalendar,{Z22->Z22_FILIAL+Z22->Z22_FORN+Z22->Z22_LOJA+Z22->Z22_GRUPO,Z22->Z22_TIPO,aAuxDias[nu],dAuxIni,dDataNova,Z22->(Recno()),dDataProx})
				//ConOut(Z22->Z22_GRUPO+":"+DtoC(dAuxIni)+":"+DtoC(dDataNova)+":"+DtoC(dDataProx))
			EndIf
			// -> Quinzenal 
			If Z22->Z22_TIPO == "Q"
				// -> Calcula nova data - Entrega Atual
				If Day(dAuxIni) = 14
					dDataNova:=CtoD("28/"+StrZero(Month(dAuxIni),2)+"/"+StrZero(Year(dAuxIni),4))
				Else
					dDataNova:=CtoD("14/"+StrZero(IIF(Month(dAuxIni)=12,1,Month(dAuxIni)+1),2)+"/"+StrZero(IIF(Month(dAuxIni)=12,Year(dAuxIni)+1,Year(dAuxIni)),4))
				EndIf	 
				// -> Calcula nova data - Entrega Proxima
				If Day(dDataNova) = 14
					dDataProx:=CtoD("28/"+StrZero(Month(dDataNova),2)+"/"+StrZero(Year(dDataNova),4))
				Else
					dDataProx:=CtoD("14/"+StrZero(IIF(Month(dDataNova)=12,1,Month(dDataNova)+1),2)+"/"+StrZero(IIF(Month(dDataNova)=12,Year(dDataNova)+1,Year(dDataNova)),4))
				EndIf	 
				If dDataNova - dAuxIni <= 7 
					AADD(aCalendar,{Z22->Z22_FILIAL+Z22->Z22_FORN+Z22->Z22_LOJA+Z22->Z22_GRUPO,Z22->Z22_TIPO,aAuxDias[nu],dAuxIni,dDataNova,Z22->(Recno(),dDataProx)})
				EndIf	
			EndIf
			// -> Mensal
			If Z22->Z22_TIPO == "M"
				// -> Calcula nova data - Entrega Atual
				dDataNova:=CtoD("01/"+StrZero(IIF(Month(dAuxIni)=12,1,Month(dAuxIni)),2)+"/"+StrZero(IIF(Month(dAuxIni)=12,Year(dAuxIni)+1,Year(dAuxIni))),4)
				nDia     :=IIF(LastDay(dDataNova) < Val(aDiasSem[1]),LastDay(dDataNova),Val(aDiasSem[1]))
				dDataNova:=CtoD(StrZero(nDia,2)+"/"+StrZero(Month(dDataNova),2)+"/"+StrZero(Year(dDataNova),4))
				// -> Calcula nova data - Entrega Proxima
				dDataProx:=CtoD("01/"+StrZero(IIF(Month(dDataNova)=12,1,Month(dDataNova)),2)+"/"+StrZero(IIF(Month(dDataNova)=12,Year(dDataNova)+1,Year(dDataNova))),4)
				nDia     :=IIF(LastDay(dDataProx) < Val(aDiasSem[1]),LastDay(dDataProx),Val(aDiasSem[1]))
				dDataProx:=CtoD(StrZero(nDia,2)+"/"+StrZero(Month(dDataProx),2)+"/"+StrZero(Year(dDataProx),4))
				If dDataNova - dAuxIni <= 7 
					AADD(aCalendar,{Z22->Z22_FILIAL+Z22->Z22_FORN+Z22->Z22_LOJA+Z22->Z22_GRUPO,Z22->Z22_TIPO,aAuxDias[nu],dAuxIni,dDataNova,Z22->(Recno(),dDataProx)})
				EndIf	
			EndIf
		Next nu	
		Z22->(DbSkip())
	EndDo

	// -> Firma as necessidades calculadas conforme calendário de entregas
	BEGIN TRANSACTION
		
		cMsgErr:=""
		aAuxLog:={}
		For nu:=1 to Len(aCalendar)
	
			DbSelectArea("Z22")
			Z22->(DbGoTo(aCalendar[nu,6]))
				
			cDtCalcI:=DtoS(aCalendar[nu,4]+1)
			cDtCalcF:=DtoS(aCalendar[nu,5])

			cAuxLog:=":"+Z22->Z22_FORN+Z22->Z22_LOJA+":"+Z22->Z22_GRUPO+":De "+DtoC(aCalendar[nu,4]+1)+" a "+DtoC(aCalendar[nu,5])+": Firmando necessidades de compras..."
			ConOut(cAuxLog)                         
			AADD(aAuxLog,cAuxLog)

			cQuery:="SELECT Z25.R_E_C_N_O_ REC "
			cQuery+="FROM " + RetSQLName("Z25") + " Z25 "
			cQuery+="WHERE Z25.Z25_FILIAL    = '" + xFilial("Z25")  + "' AND "   
			cQuery+="	   Z25.Z25_CODFOR    = '" + Z22->Z22_FORN   + "' AND "
			cQuery+="	   Z25.Z25_CODLOJ    = '" + Z22->Z22_LOJA   + "' AND "
			cQuery+="	   Z25.Z25_GRPCOM    = '" + Z22->Z22_GRUPO  + "' AND " 
			cQuery+="      Z25.Z25_DTNECE   >= '" + cDtCalcI        + "' AND " 
			cQuery+="      Z25.Z25_DTNECE   <= TO_CHAR(TO_DATE("+cDtCalcF+", 'RRRRMMDD') + Z25.Z25_XDIAES,'RRRRMMDD') AND " 
			cQuery+="      Z25.D_E_L_E_T_ <> '*'                                                                          "
			cQuery+="ORDER BY Z25_FILIAL, Z25_CODFOR, Z25_CODLOJ, Z25_GRPCOM, Z25_PRODUT                                  "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliTmp0,.T.,.T.)				

	    	(cAliTmp0)->(dbGoTop())
	    	While !(cAliTmp0)->(eof())
	    	
	    		Z25->(DbGoTo((cAliTmp0)->REC))
	    	
	    		cAuxLog:=" ->"+DtoC(Z25->Z25_DTNECE)+": "+Z25->Z25_GRPCOM+": "+AllTrim(Z25->Z25_PRODUT)+" - "+Z25->Z25_DESCPR
	    		ConOut(cAuxLog)                         
	    		AADD(aAuxLog,cAuxLog)

	    		If RecLock("Z25",.F.)
	    			Z25->Z25_DTENTR:=aCalendar[nu,5]
	    			Z22->(MsUnlock())
	    			cAuxLog:="Ok."
	    			ConOut(cAuxLog)                         
	    			AADD(aAuxLog,cAuxLog)
	    		Else
	    			cMsgErr:="Erro na gravacao dos dados."
	    			AADD(aAuxLog,cMsgErr)	    			
	    		EndIf	

	    		(cAliTmp0)->(dbSkip())
	    	EndDo 
	    	
	    	(cAliTmp0)->(DbCloseArea())
	    
	    Next nu
	    
		// -> Se ocorreu erro, desarma transação
		If AllTrim(cMsgErr) <> ""		
			DisarmTransaction()
			Break
		EndIf
	    
	END TRANSACTION
	    
	// -> Grava dados no log
	For nu:=1 to Len(aAuxLog)
		cAuxLog:=aAuxLog[nu] 
		ConOut(cAuxLog)                              
		oEventLog:SetAddInfo(cAuxLog,"")
	Next nu
		    
	// -> Atualiza log
	If AllTrim(cMsgErr) <> ""		
		oEventLog:broken("Na execucao.", cMsgErr, .T.)
		lErro:=.T.
	Else
		cAuxLog:="Ok." 
		ConOut(cAuxLog)                              
		oEventLog:SetAddInfo(cAuxLog,"")
	EndIf	

Return(!lErro)







//Função que atualiza o conteúdo de uma pergunta no X1_CNT01 / SXK / Profile
User Function zAtuPerg(cPergAux, cParAux, xConteud)
    Local aArea      := GetArea()
    Local nPosPar    := 14
    Local nLinEncont := 0
    Local aPergAux   := {}
    Default xConteud := ''
     
    //Se não tiver pergunta, ou não tiver ordem
    If Empty(cPergAux) .Or. Empty(cParAux)
        Return
    EndIf
     
    //Chama a pergunta em memória
    Pergunte(cPergAux, .F., /*cTitle*/, /*lOnlyView*/, /*oDlg*/, /*lUseProf*/, @aPergAux)
     
    //Procura a posição do MV_PAR
    nLinEncont := aScan(aPergAux, {|x| Upper(Alltrim(x[nPosPar])) == Upper(cParAux) })
     
    //Se encontrou o parâmetro
    If nLinEncont > 0
        //Caracter
        If ValType(xConteud) == 'C'
            &(cParAux+" := '"+xConteud+"'")
         
        //Data
        ElseIf ValType(xConteud) == 'D'
            &(cParAux+" := sToD('"+dToS(xConteud)+"')")
             
        //Numérico ou Lógico
        ElseIf ValType(xConteud) == 'N' .Or. ValType(xConteud) == 'L'
            &(cParAux+" := "+cValToChar(xConteud))
         
        EndIf
         
        //Chama a rotina para salvar os parâmetros
        __SaveParam(cPergAux, aPergAux)
    EndIf
     
    RestArea(aArea)
Return




/*-----------------+---------------------------------------------------------+
!Nome              ! GetMRPPer                                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Retornr os perídos conforme cálculo do MRP (MATA712)    !
+------------------+---------------------------------------------------------+
!Autor             ! TOTVS SP - Chamado 3597482                              !
+------------------+---------------------------------------------------------!
!Data              ! 31/08/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function GetMRPPer(nTipo,dInicio,nPeriodos,aPerg711)
Local aRetorno  := {}
Local cForAno 	:= ""
Local nPosAno 	:= 0
Local nTamAno 	:= 0
Local i 	:= 0
Local nY2T	:= If(__SetCentury(),2,0)

	If __SetCentury()
		nPosAno := 1
		nTamAno := 4
		cForAno := "ddmmyyyy"
	Else
		nPosAno := 3
		nTamAno := 2
		cForAno := "ddmmyy"
	Endif

	//Monta a data de inicio de acordo com os parametros                   
	If (nTipo == 2)                         // Semanal
		While Dow(dInicio)!=2
			dInicio--
		EndDo
	ElseIf (nTipo == 3) .or. (nTipo == 4)   // Quinzenal ou Mensal
		dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6,3+nY2T),cForAno)
	ElseIf (nTipo == 5)                     // Trimestral
		If Month(dInicio) < 4
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
			dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		ElseIf (Month(dInicio) >=10)
			dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		EndIf
	ElseIf (nTipo == 6)                     // Semestral
		If Month(dInicio) <= 6
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		Else
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		EndIf
	EndIf

	//Monta as datas de acordo com os parametros                   
	If nTipo != 7
		For i := 1 to nPeriodos
			dInicio := A712NextUtil(dInicio,aPerg711)
			AADD(aRetorno,dInicio)
			If nTipo == 1
				dInicio ++
			ElseIf nTipo == 2
				dInicio += 7
			ElseIf nTipo == 3
				dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
								If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
								Str(Year(dInicio)+1,4)+"0101")),cForAno)
			ElseIf nTipo == 4
				dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
								"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			ElseIf nTipo == 5
				dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
								"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			ElseIf nTipo == 6
				dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
								"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			EndIf
		Next i
	ElseIf nTipo == 7
		For i:=1 to Len(aDiversos)
			AADD(aRetorno, StoD(DtoS(CtoD(aDiversos[i])),cForAno) )
		Next
	Endif

	//Ponto de entrada customizacoes na atualizacoes de periodos   
	If ExistBlock("A710PERI")
		aRetorno := ExecBlock("A710PERI", .F., .F., aRetorno )
	EndIf

Return aRetorno                




/*-----------------+---------------------------------------------------------+
!Nome              ! EST100PV                                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Importação das demandas restaurantes                    !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 21/05/2018                                              !
+------------------+--------------------------------------------------------*/
// Espera-se que arquivos estejam na pasta \import\prophix do servidor
//   Nome do arquivo SC4_UUUUUUUUUU.csv onde UUUUUUUUUU -> identificador da unidade 
//   Campos do arquivo
//   02MDBG0003;20403905001800;01;868;705;683.0232449;20180630
//        |            |       |   |   |        |         +-> data da necessidade do produto no formato AAAAMMDD
//        |            |       |   |   |        +-> valor unitario do produto com separador decimal .   
//        |            |       |   |   +-> quantidade necessari   
//        |            |       |   +-> numero do documento???   
//        |            |       +-> local do produto   
//        |            +-> codigo do produto   
//        +-> codigo da unidade (igual ao que consta no nome do arquivo)   
User Function EST100PV(oEventL)
Local aFiles      := {}
Local nX	      := 0
Local cDirBase    := "\import\prophix\"
Local nArquivo    := 0
Local lErro       := .f.
Local cStartPath  := ""
Local c2StartPath := "\import\prophix\imp\'
Local cAuxLog     := ""      
Local cFile
Local cUndMad
Local lLock
Local oError

	cAuxLog:=": Importando arquivos..." 
	ConOut(cAuxLog)                              
	oEventL:SetAddInfo(cAuxLog,"")

	// -> Verifica se pode executar o processo
	If AllTrim(oEventL:GetStep()) <> ""
		cAuxLog:="Ok: Aguardando proxima execucao: " + oEventL:GetStep() 
		ConOut(cAuxLog)                              
		oEventL:SetAddInfo(cAuxLog,"")
		Return(.T.)	
	EndIf 

	cStartPath 	:= cDirBase 
	c2StartPath	:= cDirBase+"imp\"

	//CRIA DIRETORIOS
    MkFullDir(cDirBase)
	MakeDir(Trim(cStartPath)) //CRIA DIRETORIO ENTRADA
	MakeDir(c2StartPath) //CRIA DIRETORIO ANO

	aFiles := Directory(cStartPath +"SC4"+cFilAnt+"*.CSV")
	nArquivo := 0
	dbSelectArea("ZWS")
	ZWS->(dbSetOrder(1))
	For nX := 1 To Len(aFiles)
		
		cAuxLog:=": Lendo arquivo " +AllTrim(aFiles[nX,1]) + "..." 
		ConOut(cAuxLog)                              
		oEventL:SetAddInfo(cAuxLog,"")
				
		nArquivo++
		cFile   := aFiles[nX,1]
		cUndMad := substr(cFile, 5, at(".", cFile)-5)
		TRYEXCEPTION
	 		//Processa Arquivo
		  	xReadArq(cFile, cUndMad, cStartPath, c2StartPath, oEventL)
		CATCHEXCEPTION USING oError
		  	lErro  :=.T.
			cAuxLog:=procname()+"("+cValToChar(procline())+")" + oError:Description 
            oEventL:broken("Na execucao.", cAuxLog, .T.)
            Conout(cAuxLog + Chr(13) + Chr(10) + 'Detalhamento :'+varinfo('oError',oError))
		ENDEXCEPTION
		
	Next nX
	
	cAuxLog:=": "+ AllTrim(Str(Len(aFiles))) + " arquivo(s) importando(s)." 
	ConOut(cAuxLog)                              
	oEventL:SetAddInfo(cAuxLog,"")

	cAuxLog:=IIF(lErro,"Erro.","Ok.") 
	ConOut(cAuxLog)                              
	oEventL:SetAddInfo(cAuxLog,"")
	
	// -> Atualiza etapa no log
	If !lErro .and. Len(aFiles) > 0
		oEventL:SetStep("01")
	Else
		oEventL:SetStep("  ")	
	EndIf
		
Return(!lErro)





/*-----------------+---------------------------------------------------------+
!Nome              ! ReadArq - Cliente: Madero                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Leitura do arquivo de demanda do Prophix                !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 21/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function xReadArq(cFile , cUndMad, cStartPath, c2StartPath, oEventL)
Local nHdl      := 0
Local nRecs     := 0
Local nRecsImp  := 0
Local lProces   := .t.
Local lErro     := .f.
Local nValor    := 0  
Local cDataPr   := 0
Local dDataPr   := 0
Local aSB1      := SB1->(GetArea())
Local aADK      := ADK->(GetArea())
Local nOpcao    := 3
Local cPathTmp  := "\temp\"
Local cAuxLog   := ""
Local dAuxData  := dDataBase
Local lExcluiu  := .F.
Local cLine
Local aLinha
Local cProd   
Local cLocal  
Local cDoc    
Local nQuant  
Local cArqTXT
Local cNomNovArq
Local oError
Local cQuery
Private lMsErroAuto:=.F.

	// -> Abre o arquivo
	nHdl := FT_FUSE(cStartPath+cFile)  //cStartPath //D:\TOTVS\microsiga\protheus12\ambientes\qa\import\prophix
	if nHdl < 0
		
		lErro  :=.T.
		cAuxLog:="Erro ao abrir o arquivo." 
        oEventL:broken("No arquivo.", cAuxLog, .T.)
        Conout(cAuxLog)
	
	Else
		
		cAuxLog :=": excluindo demandas anteriores..." 
		ConOut(cAuxLog)                              
		oEventL:setCountInc()
    	oEventL:SetAddInfo(cAuxLog)    						

	    Begin Transaction
	        	
    		// -> Exclui as demandas atuais
			If !lExcluiu
				cQuery := " DELETE FROM "+RetSQLName("SC4")           "
				cQuery += " WHERE C4_FILIAL = '" + xFilial("SC4")+ "' "
				cQuery += " AND C4_DATA >= '" + dtos(dDataBase)  + "' "
				TCSqlExec(cQuery)
				lExcluiu:=.T.
			EndIf	
			
			cAuxLog :="Ok." 
			ConOut(cAuxLog)                              
			oEventL:setCountInc()
    		oEventL:SetAddInfo(cAuxLog)    						

			cAuxLog :=": Iniciando leitura do arquivo..." 
			ConOut(cAuxLog)                              
			oEventL:setCountInc()
    		oEventL:SetAddInfo(cAuxLog)    						

			// -> Processa arquivo de demanda
			nRecs := FT_FLastRec()
			FT_FGoTop()
			While !FT_FEOF()		   

				oEventL:setCountOk()
				lErro := .F.
				cLine := FT_FReadLN()
				aLinha:= Separa( cLine, ";" )

				if len(aLinha) >= 6
					cProd   := aLinha[2]
					cLocal  := aLinha[3]
					cDoc    := aLinha[4]
					nQuant  := val(aLinha[5])
					//nValor  := val(aLinha[6])
					cDataPr := aLinha[6]
					nRecsImp++

					cAuxLog :=": importando linha " + AllTrim(Str(nRecsImp))
					ConOut(cAuxLog)                              
					oEventL:setCountInc()
    				oEventL:SetAddInfo(cAuxLog)    						

					// -> Pula a primeira linha
					If nRecsImp <=1 
						FT_FSkip()
						Loop				
					EndIf								
					
					DbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					if !SB1->(dbSeek(xFilial("SB1")+cProd))
						cAuxLog := "Erro: Produto "+cProd+" não encontrado no Protheus."
						ConOut(cAuxLog)                              
						oEventL:SetAddInfo(cAuxLog,"")
						lErro := .T.
					EndIf
					
					DbSelectArea("NNR")
					NNR->(dbSetOrder(1))
					if !NNR->(dbSeek(xFilial("NNR")+cLocal))
						cAuxLog := "Erro: Local de estoque "+cLocal+" não encontrado no Protheus."
						ConOut(cAuxLog)                              
						oEventL:SetAddInfo(cAuxLog,"")
						lErro := .T.
					EndIf
								
					// -> Se não ocorreu erro, continua...
					If !lErro .and. nQuant > 0 .and. AllTrim(SB1->B1_COD) <> ""
	
						TRYEXCEPTION
							dDataPr := stod(cDataPr)
						CATCHEXCEPTION USING oError
							lErro    := .T.
							dDataBase:=dAuxData
							cAuxLog  := "Erro: Data "+cDataPr+" inválida: " + cLine
							ConOut(cAuxLog)                              
							oEventL:SetAddInfo(cAuxLog,"")
							lProces:=.f.
						ENDEXCEPTION

						aDados   :={}
						cAuxLog  :=""
						dDataBase:=dDataPr
						aadd(aDados,{"C4_FILIAL" ,xFilial("SC4")         									,Nil})
						aadd(aDados,{"C4_PRODUTO",SB1->B1_COD            									,Nil})
		            	aadd(aDados,{"C4_LOCAL"  ,cLocal													,Nil})
	        		    aadd(aDados,{"C4_DOC"    ,cDoc														,Nil})
			            aadd(aDados,{"C4_QUANT"  ,nQuant													,Nil})
			            aadd(aDados,{"C4_VALOR"	 ,nValor													,Nil})
		    	        aadd(aDados,{"C4_DATA"   ,dDataBase													,Nil})
		        	    aadd(aDados,{"C4_OBS"    ,"Demanda restaurantes."									,Nil})
						// -> Executa inclusão / alteração
						DbSelectArea("SC4")
						MATA700(aDados,nOpcao)
						If lMsErroAuto
							lErro   := .T.
							cAuxLog := "dmun_"+cFilAnt+"_"+SB1->B1_COD+"_"+strtran(time(),":","")
							MostraErro(cPathTmp, cAuxLog)
							cAuxLog:="Erro na geracao da denada: Verifique o log em " + cPathTmp + cAuxLog
							ConOut(cAuxLog)                              
							oEventL:setCountInc()
    						oEventL:SetAddInfo(cAuxLog)
    						lProces  :=.f.    							
						Else
							cAuxLog := "Ok."
							ConOut(cAuxLog)                              
							oEventL:setCountInc()
    						oEventL:SetAddInfo(cAuxLog)    						
						EndIf					
					EndIf   

				EndIf

				FT_FSkip()
				
			Enddo
	
		End Transaction
					
	EndIF
	FT_FUSE()
			
	// Se não ocorreu erro no procesamento, atualiza o arquivo
	If lProces
    	
    	// -> Move Arquivo Lido
	    cArqTXT := cStartPath+cFile
		cNomNovArq  := UPPER(c2StartPath+strtran(cFile,".","_"+dtos(date())+"."))
		
		// - > copia o arquivo antes da transacao
	    fErase(cNomNovArq)
		If __CopyFile(cArqTXT,cNomNovArq)
		   FErase(cStartPath+cFile)
        EndIf
	
	EndIf
	
	dDataBase:=dAuxData
	
    SB1->(RestArea(aSB1))
    ADK->(RestArea(aADK))

Return lProces




/*-----------------+---------------------------------------------------------+
!Nome              ! MkFullDir - Cliente: Madero                             !
+------------------+---------------------------------------------------------+
!Descrição         ! Criacao de estrutura completa de diretorio              !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 21/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function MkFullDir(cDir)
    local cBase := ""
    cDir := trim(cDir)
    if (left(cDir, 2) != "\\")
        while (!empty(cDir))
            if ("\" $ cDir)
                cBase += substr(cDir, 1, at("\", cDir)-1)
            Else
                cBase += cDir
            EndIf
            if !empty(cBase)
                MakeDir(cBase)
            Endif
            cBase += "\"
            if ("\" $ cDir)
                cDir := substr(cDir, at("\", cDir)+1)
            Else
                exit
            EndIf
        enddo
    EndIf
Return nil       





/*-----------------+---------------------------------------------------------+
!Nome              ! COM104 - Cliente: Madero                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Geração de pedidos de compras                           !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 23/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function PutSC7(oEventLog)
Local lErro104A:= .F.
Local lErro104 := .F.
Local cAuxLog  := ""
Local aErros   := {}
Local aAuxRet  := {}
Local aArea104 := GetArea()
Local aCOM105  := {}
Local oError
Local nx     
		
	If AllTrim(oEventLog:GetStep()) <> "03"
		cAuxLog:="Ok: Aguardando proxima execucao: " + oEventLog:GetStep() 
		ConOut(cAuxLog)                              
		oEventLog:SetAddInfo(cAuxLog,"")
		Return(.f.)	
	EndIf 
		
	// -> Gera os pedidos de compra
	AADD(aCOM105,dDataBase)
	AADD(aCOM105,cEmpAnt)
	AADD(aCOM105,cFilAnt)
	aAuxRet  :=startJob("U_COM105", GetEnvServer(), .T., aCOM105)
	aErros   :=aAuxRet[1]
	lErro104A:=aAuxRet[2]
					
	// -> Se ocorreu erro, exibe e registra no log
	If lErro104A
		For nx:=1 to Len(aErros)
			// -> Verifica se teve erros
			If AllTrim(aErros[nx,2]) <> "" .or. AllTrim(aErros[nx,3]) <> "" .or. AllTrim(aErros[nx,4]) <> "" .or. AllTrim(aErros[nx,5]) <> ""     
				lErro104:=.T.			
				If nx <= 1
					cAuxLog := "Erro: " + aErros[nx,1]
					ConOut(cAuxLog)
					oEventLog:SetAddInfo(cAuxLog,"")
				EndIf
				// -> Exibe erro 1
				If AllTrim(aErros[nx,2]) <> "" 
					cAuxLog := aErros[nx,2]
					ConOut(cAuxLog)
					oEventLog:SetAddInfo(cAuxLog,"")
				EndIf
				// -> Exibe erro 2
				If AllTrim(aErros[nx,3]) <> "" 
					cAuxLog := aErros[nx,3]
					ConOut(cAuxLog)
					oEventLog:SetAddInfo(cAuxLog,"")
				EndIf
				// -> Exibe erro 3
				If AllTrim(aErros[nx,4]) <> "" 
					cAuxLog := aErros[nx,4]
					ConOut(cAuxLog)
					oEventLog:SetAddInfo(cAuxLog,"")
				EndIf
				// -> Exibe erro 4
				If AllTrim(aErros[nx,5]) <> ""	
					cAuxLog := aErros[nx,5]
					ConOut(cAuxLog)
					oEventLog:SetAddInfo(cAuxLog,"")
				EndIf					
			EndIf	
		Next nx
	Else
		cAuxLog:="Ok."
		ConOut(cAuxLog)                              
		oEventLog:SetAddInfo(cAuxLog,"")	
	EndIf	
	
	// -> Verifica se ocorreu erro
	If lErro104 		
		oEventLog:broken("Na geracao do pedido de compra.",IIF(Len(aErros)<=0,cAuxLog,""),.T.)
	Else	
		cAuxLog:=IIF(lErro104,"Erro.","Ok.") 
		ConOut(cAuxLog)
		oEventLog:SetAddInfo(cAuxLog,"")
		oEventLog:SetStep("04")		
	Endif              

	RestArea(aArea104)
	
Return(!lErro104)
#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} EST551
//TODO Rotina para processar contagens
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
/*/
User Function EST551()
Local cQuery	:= ""
Local cQueryEmp	:= ""
Local cAlQry	:= ""
Local cPath		:= ""
Local cArqCSV	:= ""
Local aArquivos	:= {}
Local aLinha	:= {}
Local cFilTek	:= ""
Local oEventLog
Local cAuxLog   := "" 
Local aDados    := {}
Local nAux      := 0
Local nCount    := 0
Local lAuxRet   := .T.
Local lProc     := .F.
Local aAuxRt    := {}
Local aAuxFile  := {}
Local cEmpresa := AllTrim(GetSrvProfString('Empresa',''))
Local cEmpAux  := AllTrim(GetSrvProfString('Filiais',''))
Local aParam   := {}
Local aEmp   	:= {}
Local nx 		:= 0
Private nPosCod :=1
Private nPosQtd :=10	

	// aParam := {{cEmpresa, SubStr(cEmpAux,1,10)}}
	// RpcClearEnv()
	// 	RPcSetType(3)
	// 	RpcSetEnv( aParam[1,1],aParam[1,2], , ,'FAT' , GetEnvServer() )
	//     OpenSm0(aParam[1,1], .f.)
    // 	nModulo := 5
	//     SM0->(dbSetOrder(1))
    // 	SM0->(dbSeek(aParam[1,1]+aParam[1,2]))
	//     cEmpAnt := SM0->M0_CODIGO
	//     cFilAnt := SM0->M0_CODFIL

	// -> Seleciona empresa corrente
    If SubStr(GetSrvProfString('Filiais',''),11,1) == "*"

	    // -> Seleciona as empresas informadas no parï¿½metro
		aEmp:=StrToKarr(GetSrvProfString('Filiais',''),'*')

	    // -> Inicia o ambiente
    	    RpcClearEnv()        
        	RpcSetType(3) 
	        RpcSetEnv(cEmpresa,aEmp[1],,,'FAT',GetEnvServer())                           
    	    OpenSm0(cEmpresa,.f.)
	    	nModulo:=5                                  
	    	
            // -> Seleciona as filiais
			cQueryEmp := "SELECT * FROM ADK010        	"
			cQueryEmp += "WHERE D_E_L_E_T_ <> '*'     	"
			cQueryEmp += "AND ADK_XFILI != '          '"
			cQueryEmp += "AND ADK_XEMP != '01'			"
			cQueryEmp += "AND ADK_XEMP != '06'			"
			cQueryEmp += "ORDER BY ADK_XFILI, ADK_XEMP, ADK_XFIL "
	        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryEmp),"TMPADKI",.T.,.T.)	
	        
	        aEmp:={}	        
    	    TMPADKI->(DbGoTop())
        	While !TMPADKI->(Eof())
				aadd(aEmp,TMPADKI->ADK_XFILI)   
				TMPADKI->(DbSkip())
	        EndDo
	        DbSelectArea("TMPADKI")
	        DbCloseArea()

		Else

		    // -> Seleciona as empresas informadas no parï¿½metro
			aEmp:=StrToKarr(GetSrvProfString('Filiais',''),'-')

	        // -> Inicia o ambiente
    	    RpcClearEnv()        
        	RpcSetType(3) 
	        RpcSetEnv(cEmpresa,aEmp[1],,,'FAT',GetEnvServer())                           
    	    OpenSm0(cEmpresa,.f.)
	    	nModulo:=5                                  

        EndIf

	    // -> Executa o porcesso para todas as empresas selecionadas
	    For nx:=1 to Len(aEmp)

	    	// -> Posiciona na empresa / filial
	    	DbSelectArea("SM0")
	    	SM0->(DbSetOrder(1))
	    	SM0->(DbSeek(cEmpresa+aEmp[nx]))
	    	cEmpAnt:=SM0->M0_CODIGO
	    	cFilAnt:=SM0->M0_CODFIL

			oEventLog := EventLog():Start("Inventario - Contagem", Date(), "Inicio do processo de Contagem: ", "", "")
	
			cAuxLog:=": Selecionando inventarios..."
			oEventLog:setAddInfo(cAuxLog, "Selecionado dados.")
			ConOut(cAuxLog)
			cQuery := "	SELECT R_E_C_N_O_ Z23_REGNO " + CRLF 
			cQuery += "	FROM " + RetSqlName("Z23") + " Z23 " + CRLF 
			cQuery += "	WHERE " + CRLF 
			cQuery += "	        Z23_FILIAL = '" + xFilial("Z23") + "' " + CRLF 
			cQuery += "	    AND Z23_DTINV != ' ' " + CRLF 
			cQuery += "	    AND Z23_DTCONF = ' ' " + CRLF 
			cQuery += "	    AND D_E_L_E_T_ = ' ' " + CRLF 
			cQuery := ChangeQuery(cQuery)
			cAlQry := MPSysOpenQuery(cQuery)
			While !(cAlQry)->(Eof())
				nCount:=nCount+1
				(cAlQry)->(DbSkip())
			EndDo

			cAuxLog:=": "+AllTrim(Str(nCount))+" registro(s) selecionando(s)..."
			oEventLog:setAddInfo(cAuxLog, "Selecionado dados.")
			ConOut(cAuxLog)
			
			dbSelectArea("Z23")
			(cAlQry)->(DbGoTop())	
			While !(cAlQry)->(Eof())
			
				Z23->(dbGoTo((cAlQry)->Z23_REGNO))
				
				dbSelectArea("ADK")
				ADK->( dbOrderNickName("ADKXFILI") )    
				ADK->( dbGoTop() )
				If ADK->( dbSeek(xFilial("ADK") + cFilAnt) )
					cFilTek := ADK->ADK_XFIL
				EndIf
				
				cPath := U_EST550PT(cFilTek)
				cArqCSV := AllTrim(Z23->Z23_ARQINV)
				
				aArquivos := Directory(cPath + cArqCSV)

				cAuxLog:=": Processando arquivo " + cPath + cArqCSV
				oEventLog:setAddInfo(cAuxLog, "Processando arquivo.")
				ConOut(cAuxLog)

				If Len(aArquivos) > 0
				
					aAuxFile:=StrToKarr(cArqCSV,".")
				
					Begin Transaction
					
						FT_FUSE(cPath+cArqCSV)
						FT_FGOTOP()
				
						cLinha := FT_FREADLN()
						aLinha := StrTokArr(cLinha,";")
						lProc  := .F.

						//Verifica se o arquivo possui a coluna b7quant (Arquivo de retorno)
						If aScan(aLinha,"b7quant") != 0
					
							FT_FSKIP()				
							aDados:={}
							nAux  :=0
							lProc :=.T.
							oEventLog:setCountOk()
				
							While !FT_FEOF()
						
								cLinha := FT_FREADLN()
								
								While At( ";;", cLinha ) != 0
									cLinha := Replace(cLinha, ";;", "; ;")
								EndDo
								
								aLinha:= StrTokArr(cLinha,";")
								nAux  :=aScan(aDados,{|kb| AllTrim(kb[1]) == AllTrim(aLinha[nPosCod])})
								If nAux <= 0
									aadd(aDados,{aLinha[nPosCod],aLinha[nPosQtd]})
								Else
									aDados[nAux,02]:=aDados[nAux,02]+aLinha[nPosQtd]
								EndIf
											
								FT_FSKIP()
						
							EndDo

							dDataBase:=Z23->Z23_DTINV
											
							aAuxRet:=GeraSB7(aDados,oEventLog)
							lAuxRet:=aAuxRet[1]
							If !lAuxRet					
								DisarmTransaction()
							Else
								aAuxRet:=GeraZ23(cArqCSV,oEventLog)
								lAuxRet:=aAuxRet[1]
								If !lAuxRet					
									DisarmTransaction()
								EndIf	
							EndIf
							
						EndIf

						FT_FUSE()		

						// -> Se o processamento ocorreu corretamente, renomeia arquivo como processado
						If lAuxRet .and. lProc
							// -> Se ocorreu erro ao renomear o arquivo, desfaz a transacao 
							If FRename(cPath+cArqCSV,cPath+aAuxFile[1]+"_ok"+".CSV") == -1
							aAuxRet:={.F.,"Erro ao renomear o arquivo " + cPath+cArqCSV}
							DisarmTransaction()
							Else
								cAuxLog:=": Arquivo processado e renomeado para " + cPath+aAuxFile[1]+"_ok"+".CSV"
								oEventLog:setAddInfo(cAuxLog, "Renomeando arquivo.")
								ConOut(cAuxLog)
							EndIf
						EndIf	

					End Transaction						

					// -> Se ocorreu erro, gera log
					If lProc
						If !lAuxRet
							cAuxLog:=aAuxRet[2]
							oEventLog:broken("Erro na gravacao dos dados."+cAuxLog,cAuxLog,.T.)
						Else
							oEventLog:setCountInc()
							cAuxLog:="Ok"
							oEventLog:setAddInfo(cAuxLog,"")
							ConOut(cAuxLog)
						EndIf
					Else
					
						oEventLog:setCountInc()
						cAuxLog:=": Aguardando contagem do inventario."
						oEventLog:setAddInfo(cAuxLog,"Aguardando contagem.")
						ConOut(cAuxLog)			
					
					EndIf	
				Else
				
					cAux := "Não encontrado arquivo " + cArqCSV +  " não encontrado no diretório " + cPath
					oEventLog:broken(cAux, cAux, .T.)
				
				EndIf			
				
				(cAlQry)->(dbSkip())
			
			EndDo
			
			(cAlQry)->(dbCloseArea())
			
			oEventLog:Finish()

	    	

		Next nx   
		             		
		// -> Finaiza o ambiente
		RpcClearEnv()

Return


/*/{Protheus.doc} GeraSB7
//TODO Função para gerar SB7
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
@return ${return}, ${return_description}
@param aLinha, array, Dados parta inserir registron
/*/
Static Function GeraSB7(aDados,oEventLog)
Local lRet 		:= .T.
Local cErro		:= ""
Local aArea		:= GetArea()
Local nModAux	:= nModulo
Local cFilAux	:= cFilAnt
Local aMata270	:= {}
Local cPergunta := "MTA270"
Local nx		:= 0
Local cAuxLog   := ""
Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile	:= .T.
	
	nModulo		:= 4
	dDataBase	:= Z23->Z23_DATA
	cFilAnt		:= Z23->Z23_FILIAL

	Pergunte(cPergunta,.F.)
	mv_par01 := 1
	mv_par02 := 1
	mv_par03 := 1
	mv_par04 := 1
	mv_par05 := 1
	mv_par06 := "001"
	mv_par07 := dDataBase

	DbSelectArea("SB1")	
	SB1->(DbSetOrder(1))
	For nx:=1 to Len(aDados)
		
		cAuxLog:=": "+aDados[nx][1]+": Gerando contagem para o produto..."
		oEventLog:setAddInfo(cAuxLog, "")
		ConOut(cAuxLog)				
			
		If SB1->(DbSeek(xFilial("SB1")+aDados[nx,01]))
		
			aMata270 := {}
			aAdd( aMata270, { "B7_FILIAL"	, xFilial("SB1")	    , Nil })
			aAdd( aMata270, { "B7_COD"		, SB1->B1_COD		    , Nil })
			aAdd( aMata270, { "B7_LOCAL"	, SB1->B1_LOCPAD	    , Nil })
			aAdd( aMata270, { "B7_DOC"		, "INV" + Z23->Z23_ID	, Nil })
			aAdd( aMata270, { "B7_QUANT"	, Val(aDados[nx,02])	, Nil })
			aAdd( aMata270, { "B7_ORIGEM"	, "TEKNISA"				, Nil }) 
			aAdd( aMata270, { "B7_DATA"		, dDataBase				, Nil })  

			MSExecAuto({|x,y,z| Mata270(x,y,z)},aMata270,.T.,3)
	
			If lMsErroAuto
				lRet 	:= .F.	
				cAuxLog := MostraErro()			
				cAuxLog := RetErro()
				cErro	+= cAuxLog
				cAuxLog := "Erro execauto (MATA270):  " + cAuxLog 
				oEventLog:broken("Geracao de contagem.",cAuxLog,.T.)
			Else
				cAuxLog:="Ok."
				oEventLog:setAddInfo(cAuxLog, "")
				ConOut(cAuxLog)						
			EndIf		
		
		Else
			lRet   := .F.
			cAuxLog:=": Produto nao encontrado."
			oEventLog:broken("Geracao de contagem.",cAuxLog,.T.)
			ConOut(cAuxLog)								
					
		EndIf	

	Next nx		

	RestArea(aArea)
	cFilAnt := cFilAux
	nModulo := nModAux

Return({lRet,cErro})

/*/{Protheus.doc} GeraZ23
//TODO Função para atualizar Z23
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
@return cRet, characters, mensagen de retorno
@param cArqCSV, characters, Nome do arquivo CSV
/*/
Static Function GeraZ23(cArqCSV,oEventLog)
Local nX		:= 0
Local cGrpInv	:= ""
Local cRet		:= ""
Local lRet		:= .T.
Local dDtaInv	:= ""
Local oModel	:= FWLoadModel("MADERO_EST550")
Local cAuxLog   := ""

	cAuxLog:=": "+Z23->Z23_ID+": Atualizando registro de inventário."
	oEventLog:setAddInfo(cAuxLog, "")
	ConOut(cAuxLog)						
	
	oModel:SetOperation(4)
	oModel:Activate()
	
	oModel:SetValue("MODEL_Z23", "Z23_DTCONF"	, dDataBase)
	oModel:SetValue("MODEL_Z23", "Z23_HRCONF"	, Time())		

	If oModel:VldData()
		oModel:CommitData()		
		cAuxLog:="Ok"
		oEventLog:setAddInfo(cAuxLog, "")
		ConOut(cAuxLog)						
	Else
	
		aErro := oModel:GetErrorMessage()
		lRet  := .F.
		
		AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
		AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
		AutoGrLog( "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
		AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
		AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
		AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
		AutoGrLog( "Mensagem da solução: " + ' [' + AllToChar( aErro[7] ) + ']' )
		AutoGrLog( "Valor atribuído: " + ' [' + AllToChar( aErro[8] ) + ']' )
		AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
		
		cRet   :=RetErro()
		cAuxLog:=cRet
		oEventLog:broken("Erro na atualização do inventario.",cAuxLog,.T.)
		oEventLog:setAddInfo(cAuxLog, "")

	EndIf
	
	oModel:DeActivate()

Return({lRet,cRet})



/*/{Protheus.doc} RetErro
//TODO Formata erro
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return cErro, caracter, descrição do erro
/*/
Static Function RetErro()

	Local nX     := 0
	Local cErro  := ""
	Local aLog	 := GetAutoGRLog()

	For nX := 1 To Len(aLog)
		cErro += aLog[nX] + CRLF
	Next nX

Return cErro
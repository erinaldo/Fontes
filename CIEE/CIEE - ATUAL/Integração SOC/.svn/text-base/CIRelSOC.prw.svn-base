#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_CIRelSOC  | Autor     | Fabio Zanchim  | Data |    09/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Relatorio NFS-e                                        		|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function CIRelSOC()

Local aParambox :={}
Local aCombo	:={"1=Sem filtro","2=Autorizadas","3=Não Autorizadas","4=Transmitidas","5=Não Transmitidas","6=Canceladas"}

If !ApMsgYesNo('O relatório de status das notas de serviço (RPS) deve ser gerado somente após o processamento do retorno da Prefeitura. Proseguir?')
	Return
EndIf
Aadd(aParambox,{1,'Serie',Space(3),"","","","",0,.F.})
Aadd(aParambox,{1,'Nota De',Space(9),"","","","",0,.F.})
Aadd(aParambox,{1,'Nota Ate',Space(9),"","","","",0,.T.})
Aadd(aParambox,{1,'Emissao De',dDataBase,"","","","",0,.T.})
Aadd(aParambox,{1,'Emissao Ate',dDataBase,"","","","",0,.T.})
Aadd(aParambox,{1,'Cliente De',Space(6),"","","SA1","",0,.F.})
Aadd(aParambox,{1,'Cliente Ate',Space(6),"","","SA1","",0,.T.})
Aadd(aParambox,{1,'Estado',Space(2),"","","12","",0,.F.})
Aadd(aParambox,{2,'Filtro',1,aCombo,80,"",.T.})

If Parambox(aParambox,'Relatorio NFS-e')
	oReport	:=	ReportDef()
	
	oReport:SetLandscape(.T.)
	oReport:PrintDialog()
EndIf

//Processa( {|| lProc:=CIRelProc()}, "Aguarde...","Imprimindo NFS-e...", .F. )

Return

Static Function ReportDef()

oReport:= TReport():New('CIRELNF','Posição NF-e/NFS',,{|oReport| ReportPrint(oReport)},'Posição NF-e/NFS')   
//oReport:nFontBody:=08
oSection:=TRSection():New(oReport,'NFS')

TRCell():New(oSection,"NFSAI","","Serie/Nota","",14,.F.,{|| aNotas[_nLin,1] })
TRCell():New(oSection,"NFELE","","NF Eletr.","",12,.F.,{|| aNotas[_nLin,2] })
TRCell():New(oSection,"EMIS","","Emissao","",12,.F.,{|| aNotas[_nLin,3] })
TRCell():New(oSection,"CLIE","","Cliente","",55,.F.,{|| aNotas[_nLin,4] })
TRCell():New(oSection,"UF","","Estado","",8,.F.,{|| aNotas[_nLin,5] })
TRCell():New(oSection,"CNPJ","","CNPJ","",21,.F.,{|| aNotas[_nLin,6] })   
TRCell():New(oSection,"VLR","","Valor NF","@e 99,999,999.99",17,.F.,{|| aNotas[_nLin,7] })
TRCell():New(oSection,"ESP","","","",3,.F.,{|| Space(3) })
TRCell():New(oSection,"STS","","Posição","",55,.F.,{|| aNotas[_nLin,8] })

oSection:Cell("VLR"):SetHeaderAlign("RIGHT")

Return(oReport)
       	
Static Function ReportPrint(oReport)

Local cQuery	:=""
Local cAlias	:=""
Local cAlsCan	:=""
Local aParam	:={}      
Local aMonitor	:={}
Local cDbType	:= Upper(TCGetDB())
Local oSection	:= oReport:Section(1)
Local lLoop		:=.F.
Local lSeek		:=.F.
Local lOnlyCanc	:=.F.
Local nFiltro	:= Iif(TYPE("MV_PAR09")=="N",MV_PAR09,Val(MV_PAR09))
Local cTabD2	:=RetSqlName('SD2')
Local cTabA1	:=RetSqlName('SA1')
Local cTabC5	:=RetSqlName('SC5')
Private aNotas	:= {}
Private _nLin	:= 0
Private cEntSai:="1"//FIS022MNT1

//Pega ID do TSS
cIdEnt:=StaticCall(FISA022,GetIdEnt)

If Empty(cIdEnt)
	Alert('Nao foi possível comunicar com o servidor da NFS-e.')
	Return(.F.)
EndIf

Do Case
	Case cDbType $ "DB2/POSTGRES"
		cFunc := "COALESCE"
		cSoma := "||"		
	Case "ORACLE" $ cDbType
		cFunc := "NVL"	
		cSoma := "||"
	Otherwise
		cFunc := "ISNULL"
		cSoma := "+"
EndCase
                  
cQuery:=" Select Distinct F3_CLIEFOR, F3_LOJA, F3_ESPECIE, F3_NFISCAL, F3_SERIE, F3_NFELETR , F3_CODNFE, F3_DTCANC, F3_EMISSAO,F3_ESTADO, F3_VALCONT FROM "+RetSqlName('SF3')
cQuery+=" Where F3_FILIAL='"+xFilial('SF3')+"'"
cQuery+=" AND F3_SERIE='"+MV_PAR01+"'"
cQuery+=" And F3_NFISCAL Between '"+MV_PAR02+"' And '"+MV_PAR03+"'"
cQuery+=" And F3_EMISSAO Between '"+DToS(MV_PAR04)+"' And '"+DToS(MV_PAR05)+"'"
cQuery+=" And F3_CLIEFOR Between '"+MV_PAR06+"' And '"+MV_PAR07+"'"
If !Empty(MV_PAR08)
	cQuery+=" AND F3_ESTADO='"+MV_PAR08+"'"
endIf
If nFiltro==6//Canceladas  
	lOnlyCanc:=.T.
	cQuery+="and F3_DTCANC<>' '"
EndIf     
//{"1=Sem filtro","2=Autorizadas","3=Não Autorizadas","4=Transmitidas","5=Não Transmitidas","6=Canceladas"}
If nFiltro<>1 .And. nFiltro<>6//Há filtro e não é de canceladas
	If MV_PAR01=="RPS" .And. nFiltro<>3//Nao autorizada = Para RPS: nao gerou na prefeitura e excluiu no Protheus
		cQuery+="and F3_DTCANC=' '" 
	EndIf
EndIf
cQuery+=" And F3_CFO >='5'"
cQuery+=" And D_E_L_E_T_ = ' '"
cQuery+=" order by F3_NFISCAL"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

oReport:SetMsgPrint("Imprimindo...")
oReport:SetMeter((cAlias)->(RecCount()))

While (cAlias)->(!Eof())

	oReport:IncMeter()  
	
	cQuery:=" SELECT Distinct A1_COD, A1_LOJA, A1_EST,A1_NOME, A1_CGC, A1_PESSOA, D2_DOC, D2_SERIE, D2_PEDIDO,F2_NFELETR, C5_NUM, C5_XRPSSOC FROM "+cTabD2
	cQuery+=" INNER JOIN "+RetSqlName('SF2')
	cQuery+="  ON D2_FILIAL"+cSoma+"D2_DOC"+cSoma+"D2_SERIE"+cSoma+"D2_CLIENTE"+cSoma+"D2_LOJA=F2_FILIAL"+cSoma+"F2_DOC"+cSoma+"F2_SERIE"+cSoma+"F2_CLIENTE"+cSoma+"F2_LOJA"
	cQuery+=" INNER JOIN "+cTabC5
	cQuery+="  ON C5_FILIAL"+cSoma+"C5_NUM=D2_FILIAL"+cSoma+"D2_PEDIDO"
	cQuery+=" 	INNER JOIN "+cTabA1
	cQuery+=" 		ON A1_COD"+cSoma+"A1_LOJA=D2_CLIENTE"+cSoma+"D2_LOJA"
	cQuery+=" 		AND "+cTabA1+".D_E_L_E_T_=''"	
	cQuery+=" WHERE D2_FILIAL='"+xFilial('SD2')+"'"
	cQuery+=" AND D2_DOC='"+(cAlias)->F3_NFISCAL+"'"
	If !Empty((cAlias)->F3_DTCANC)
		cQuery+=" AND "+cTabD2+".D_E_L_E_T_='*'"
	Else
		cQuery+=" AND "+cTabD2+".D_E_L_E_T_=' '"
	EndIf
	TcQuery cQuery New Alias (cAlsCan:=GetNextAlias())

	lSeek:=.F.        
	lLoop:=.F.
	dbSelectArea('SF2')
	dbSetOrder(1)
	If dbSeek(xFilial('SF2')+(cAlias)->F3_NFISCAL+(cAlias)->F3_SERIE+(cAlias)->F3_CLIEFOR+(cAlias)->F3_LOJA)
		lSeek:=.T.      
		
		//NF-e e NFS Cancelada - Pois solicitou assim no parametro
		If lOnlyCanc .And. !Empty((cAlias)->F3_DTCANC) .And. Iif((cAlias)->F3_SERIE=="RPS",!Empty((cAlias)->F3_NFELETR),.T.)
		
			Aadd(aNotas,{(cAlias)->F3_SERIE+'/'+(cAlias)->F3_NFISCAL,;
						Iif((cAlias)->F3_SERIE=="RPS",(cAlias)->F3_NFELETR,(cAlias)->F3_NFISCAL),;
						Substr((cAlias)->F3_EMISSAO,7,2)+'/'+Substr((cAlias)->F3_EMISSAO,5,2)+'/'+Substr((cAlias)->F3_EMISSAO,3,2),;
						(cAlsCan)->A1_COD+'-'+(cAlsCan)->A1_NOME,;
						(cAlias)->F3_ESTADO,;
						Iif((cAlsCan)->A1_PESSOA=="J",Transform((cAlsCan)->A1_CGC,"@R 99.999.999/9999-99"),Transform((cAlsCan)->A1_CGC,"@R 999.999.999-99")),;
						(cAlias)->F3_VALCONT,;						
						'NF CANCELADA'	})
			lLoop:=.T.
		EndIf
		//nFiltro -> {"1=Sem filtro","2=Autorizadas","3=Não Autorizadas","4=Transmitidas","5=Não Transmitidas","6=Canceladas"}
		If !lLoop                                
			If SF2->F2_FIMP=='S'//Autorizada
				If nFiltro==1 .Or. nFiltro==2 
	
				Aadd(aNotas,{(cAlias)->F3_SERIE+'/'+(cAlias)->F3_NFISCAL,;
							Iif((cAlias)->F3_SERIE=="RPS",(cAlias)->F3_NFELETR,(cAlias)->F3_NFISCAL),;
							Substr((cAlias)->F3_EMISSAO,7,2)+'/'+Substr((cAlias)->F3_EMISSAO,5,2)+'/'+Substr((cAlias)->F3_EMISSAO,3,2),;
							(cAlsCan)->A1_COD+'-'+(cAlsCan)->A1_NOME,;
							(cAlias)->F3_ESTADO,;
							Iif((cAlsCan)->A1_PESSOA=="J",Transform((cAlsCan)->A1_CGC,"@R 99.999.999/9999-99"),Transform((cAlsCan)->A1_CGC,"@R 999.999.999-99")),;
							(cAlias)->F3_VALCONT,;
							'NF AUTORIZADA'	})
				EndIf
				lLoop:=.T.
			EndIf
			If SF2->F2_FIMP=='T'//Transmitida - Quando o usuario acessar o monitor o status ficara Autorizada ou Nao autorizada
				If nFiltro==1 .Or. nFiltro==4 
					If Alltrim((cAlias)->F3_ESPECIE)=='RPS' //Para NF-e pode estar Emissao de DANFE autorizada, mas o status é Transmitida

						Aadd(aNotas,{(cAlias)->F3_SERIE+'/'+(cAlias)->F3_NFISCAL,;
									Iif((cAlias)->F3_SERIE=="RPS",(cAlias)->F3_NFELETR,(cAlias)->F3_NFISCAL),;
									Substr((cAlias)->F3_EMISSAO,7,2)+'/'+Substr((cAlias)->F3_EMISSAO,5,2)+'/'+Substr((cAlias)->F3_EMISSAO,3,2),;
									(cAlsCan)->A1_COD+'-'+(cAlsCan)->A1_NOME,;
									(cAlias)->F3_ESTADO,;
									Iif((cAlsCan)->A1_PESSOA=="J",Transform((cAlsCan)->A1_CGC,"@R 99.999.999/9999-99"),Transform((cAlsCan)->A1_CGC,"@R 999.999.999-99")),;
									(cAlias)->F3_VALCONT,;	
									'NF TRANSMITIDA'	})
						lLoop:=.T.
					EndIf
				EndIf
				
			EndIf
			If SF2->F2_FIMP==' '//Nao transmitida
				If nFiltro==1 .Or. nFiltro==5

					Aadd(aNotas,{(cAlias)->F3_SERIE+'/'+(cAlias)->F3_NFISCAL,;
								Iif((cAlias)->F3_SERIE=="RPS",(cAlias)->F3_NFELETR,(cAlias)->F3_NFISCAL),;
								Substr((cAlias)->F3_EMISSAO,7,2)+'/'+Substr((cAlias)->F3_EMISSAO,5,2)+'/'+Substr((cAlias)->F3_EMISSAO,3,2),;
								(cAlsCan)->A1_COD+'-'+(cAlsCan)->A1_NOME,;
								(cAlias)->F3_ESTADO,;
								Iif((cAlsCan)->A1_PESSOA=="J",Transform((cAlsCan)->A1_CGC,"@R 99.999.999/9999-99"),Transform((cAlsCan)->A1_CGC,"@R 999.999.999-99")),;
								(cAlias)->F3_VALCONT,;
								'NF NAO TRANSMITIDA'	})
				EndIf
				lLoop:=.T.
			EndIf         
			If SF2->F2_FIMP=='N'//Nao autorizada - Verirfica a ocorrencia
				If nFiltro<>1 .And. nFiltro<>3
					lLoop:=.T.
				EndIf
			EndIf
		EndIf
	EndIf
	
	If lLoop
		(cAlsCan)->(dbcloseArea())
		(cAlias)->(dbSkip())
		Loop
	EndIf   
	
	//Verifica as notas NAO AUTORIZADAS e canceladas
	cMsg:=""
	If !Empty((cAlsCan)->C5_XRPSSOC)//NFS-e 
		
		If !Empty((cAlias)->F3_DTCANC)//NF cancelada
			If lSeek .And. Empty(SF2->F2_NFELETR)
				cMsg:='NF NAUTORIZADA'//NAO AUTORIZADA
			Else
				If Empty((cAlsCan)->F2_NFELETR)
					cMsg:='NF NAUTORIZADA'//NAO AUTORIZADA
				Else
					If nFiltro==1 .Or. nFiltro==6 
						cMsg:='NF CANCELADA'   
					EndIf
				EndIf
			EndIf
		Else
			//Os MV_PARs serao utilizados na FIS022MNT1
			MV_PAR01:='RPS'
			MV_PAR02:=(cAlias)->F3_NFISCAL
			MV_PAR03:=(cAlias)->F3_NFISCAL
			
			aMonitor:={}
			Fis022Mnt1(.T.,@aMonitor)//Verifica o retorno da prefeitura
			
			cMsg:=Iif(Len(aMonitor)>0,Alltrim(aMonitor[1,6]),'')
		
		EndIf
		
		If Len(aNotas)>0
			If (nPos:=aScan(aNotas, {|x| x[1] == (cAlias)->F3_SERIE+"/"+(cAlias)->F3_NFISCAL})) > 0//Achou mesmo RPS
				//Verifica se o RPS que estava no array é algum deletado antes da transmissao
				If Empty(aNotas[nPos,2])//Nao tem numero de NF Eletronica
					Adel(aNotas,nPos)
					aSize(aNotas,Len(aNotas)-1)
				EndIf
			EndIF
		EndIf
		
		If !Empty(cMsg)
			Aadd(aNotas,{(cAlias)->F3_SERIE+'/'+(cAlias)->F3_NFISCAL,;
						Iif((cAlias)->F3_SERIE=="RPS",(cAlias)->F3_NFELETR,(cAlias)->F3_NFISCAL),;
						Substr((cAlias)->F3_EMISSAO,7,2)+'/'+Substr((cAlias)->F3_EMISSAO,5,2)+'/'+Substr((cAlias)->F3_EMISSAO,3,2),;
						(cAlsCan)->A1_COD+'-'+(cAlsCan)->A1_NOME,;
						(cAlias)->F3_ESTADO,;
						Iif((cAlsCan)->A1_PESSOA=="J",Transform((cAlsCan)->A1_CGC,"@R 99.999.999/9999-99"),Transform((cAlsCan)->A1_CGC,"@R 999.999.999-99")),;
						(cAlias)->F3_VALCONT,;
						cMsg				})
		EndIf					
	Else	//NF-e		
		If Alltrim((cAlias)->F3_ESPECIE)=='SPED'
			If !Empty((cAlias)->F3_DTCANC)//NF cancelada
				cMsg:='NF CANCELADA'
			Else                                                                      
			
				aParam:={(cAlias)->F3_SERIE,(cAlias)->F3_NFISCAL,(cAlias)->F3_NFISCAL}
				aRet:=StaticCall(SPEDNFE,WsNFeMnt,cIdent,1,aParam,.F.)
				cMsg:=Iif(Len(aRet)>0,Alltrim(aRet[1,6]),'')

			EndIf
			Aadd(aNotas,{(cAlias)->F3_SERIE+'/'+(cAlias)->F3_NFISCAL,;
						Iif((cAlias)->F3_SERIE=="RPS",(cAlias)->F3_NFELETR,(cAlias)->F3_NFISCAL),;
						Substr((cAlias)->F3_EMISSAO,7,2)+'/'+Substr((cAlias)->F3_EMISSAO,5,2)+'/'+Substr((cAlias)->F3_EMISSAO,3,2),;
						(cAlsCan)->A1_COD+'-'+(cAlsCan)->A1_NOME,;
						(cAlias)->F3_ESTADO,;
						Iif((cAlsCan)->A1_PESSOA=="J",Transform((cAlsCan)->A1_CGC,"@R 99.999.999/9999-99"),Transform((cAlsCan)->A1_CGC,"@R 999.999.999-99")),;
						(cAlias)->F3_VALCONT,;
						cMsg				})			
		EndIf
	EndIf
	(cAlsCan)->(dbCloseArea())

	(cAlias)->(dbSkip())
End
(cAlias)->(dbCloseArea())

oReport:SetMsgPrint("Finalizando...")
oReport:IncMeter()

oSection:Init()
For nX:=1 to Len(aNotas)
	_nLin:=nX
	oSection:PrintLine()
Next nX
oSection:Finish()

Return
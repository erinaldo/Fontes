#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_CIExpSOC  | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Integração SOC x Protheus  - Retorno das NFS-e transmitidas	|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function CIExpSOC()

Local lProc			:=.F.
Local aParambox 	:={}
Local cPathTransf	:=''
Local cPathArq		:=''
Local cArq 			:='' 

Aadd(aParambox,{1,'Nota De',Space(9),"","","","",0,.F.})
Aadd(aParambox,{1,'Nota Ate',Space(9),"","","","",0,.T.})
Aadd(aParambox,{1,'Emissao De',dDataBase,"","","","",0,.T.})
Aadd(aParambox,{1,'Emissao Ate',dDataBase,"","","","",0,.T.})

If !Parambox(aParambox,'Exporta NFS-e p/ SOC')
	Return
EndIf

Processa( {|| lProc:=CIExpProc()}, "Aguarde...","Exportando NFS-e...", .F. )

If lProc
	MsgInfo('Arquivo gerado com sucesso.')
	__CopyFile(cPathArq+cArq , cPathTransf+cArq)
	FErase(cPathArq+cArq)
Else
	Alert('Nenhum registro foi gerado.')
	FErase(cArq)
EndIf  

//If __CopyFile(cPathArq+cArq , cPathTransf+cArq)
//	FErase(cPathArq+cArq)
//EndIf

Return

Static Function CIExpProc()

Local lProc		:=.F.
Local cQuery	:=''
Local cAlias	:=''
Local cAlsCan	:=''
Local cMsg		:=''
Local cDtHora	:=''  
Local cPathTransf	:='\arq_txt\fiscal\exportacao\'
Local cPathArq		:='\arq_txt\fiscal\transferencia\'
Local cArq		:=cPathArq+'RPSSOC_'+DTos(Date())+StrTran(Time(),':','')+'.txt'
Local nHdl		:=0
Local aMonitor	:={}
Local aNotas:={}
Private cEntSai:="1"//FIS022MNT1
Private cIdEnt:=''

cIdEnt:=StaticCall(FISA022,GetIdEnt)

If Empty(cIdEnt)
	Alert('Nao foi possível comunicar com o servidor da NFS-e.')
	Return(.F.)
EndIf

nHdl:=FCreate(cArq)

//Pega do F3 para abranger as notas canceladas.
cQuery:=" Select Distinct F3_NFISCAL, F3_SERIE, F3_NFELETR , F3_CODNFE, F3_DTCANC FROM "+RetSqlName('SF3')
cQuery+=" Where F3_FILIAL='"+xFilial('SF3')+"' AND F3_SERIE='RPS'"
cQuery+=" And F3_NFISCAL Between '"+MV_PAR01+"' And '"+MV_PAR02+"'"
cQuery+=" And F3_EMISSAO Between '"+DToS(MV_PAR03)+"' And '"+DToS(MV_PAR04)+"'"
cQuery+=" And D_E_L_E_T_ = ' '"
cQuery+=" order by F3_NFISCAL"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

ProcRegua((cAlias)->(RecCount()))
(cAlias)->(dbGoTop())
While (cAlias)->(!Eof())
	
	IncProc()
	
	//Os MV_PARs serao utilizados na FIS022MNT1
	MV_PAR01:='RPS'
	MV_PAR02:=(cAlias)->F3_NFISCAL
	MV_PAR03:=(cAlias)->F3_NFISCAL
	
	cQuery:=" SELECT D2_DOC, D2_SERIE, D2_PEDIDO, C5_NUM, C5_XRPSSOC FROM "+RetSqlName('SD2')+" INNER JOIN "+RetSqlName('SC5')
	cQuery+=" ON C5_FILIAL+C5_NUM=D2_FILIAL+D2_PEDIDO"
	cQuery+=" WHERE D2_FILIAL='"+xFilial('SD2')+"'"
	cQuery+=" AND D2_DOC='"+(cAlias)->F3_NFISCAL+"'"
	If !Empty((cAlias)->F3_DTCANC)
		cQuery+=" AND "+RetSqlName('SD2')+".D_E_L_E_T_='*'"
	Else
		cQuery+=" AND "+RetSqlName('SD2')+".D_E_L_E_T_=' '"
	EndIf
	TcQuery cQuery New Alias (cAlsCan:=GetNextAlias())
	
	If !Empty((cAlsCan)->C5_XRPSSOC)
	
		lEnviar:=.T.
		lSeek:=.F.
		dbSelectArea('SF2')
		dbSetOrder(1)
		If dbSeek(xFilial('SF2')+(cAlsCan)->D2_DOC+(cAlsCan)->D2_SERIE)
			lSeek:=.T.
		EndIf
		lProc:=.T.                   
		
		If !Empty((cAlias)->F3_DTCANC)//NF cancelada
			If lSeek .And. Empty(SF2->F2_NFELETR)
				//cMsg:='NF NAO GERADA'
				//cDtHora:=''
				lEnviar:=.F.
			Else
				cMsg:='NF CANCELADA'
				cDtHora:=(cAlias)->F3_DTCANC
			EndIf
		Else
			If Empty(SF2->F2_NFELETR)
				//cMsg:='NF NAO GERADA'
				//cDtHora:=''
				lEnviar:=.F.
			Else
				
				cDtHora:=DToS(SF2->F2_EMINFE)+StrTran(SF2->F2_HORNFE,':','')
				
				aMonitor:={}
				Fis022Mnt1(.T.,@aMonitor)//Verifica o retorno da prefeitura
				
				cMsg:=Iif(Len(aMonitor)>0,Alltrim(aMonitor[1,6]),'')
			EndIf
			
		EndIf
		
		If lEnviar
			If Len(aNotas)>0
				If (nPos:=aScan(aNotas, {|x| x[1] == (cAlsCan)->C5_XRPSSOC})) > 0//Achou mesmo RPS
					//Verifica se o RPS que estava no array é algum deletado antes da transmissao
					If Empty(aNotas[nPos,4])//Nao tem numero de NF Eletronica
						Adel(aNotas,nPos)
						aSize(aNotas,Len(aNotas)-1)
					EndIf
				EndIF
			EndIf
			
			Aadd(aNotas,{(cAlsCan)->C5_XRPSSOC,;
						(cAlsCan)->C5_NUM	,;
						(cAlias)->F3_NFISCAL,;
						(cAlias)->F3_NFELETR,;
						cDtHora	  			,;
						(cAlias)->F3_CODNFE	,;
						cMsg				})
		EndIf
					
	EndIf
	(cAlsCan)->(dbCloseArea())
	
	(cAlias)->(dbSkip())
End
(cAlias)->(dbCloseArea())

For nX:=1 to Len(aNotas)
	FWrite(nHdl,aNotas[nX,1]+'|'+;//RPS SOC
	aNotas[nX,2]+'|'+;//Pedido Protheus
	aNotas[nX,3]+'|'+;//RPS Protheus
	aNotas[nX,4]+'|'+;//NFS-e
	aNotas[nX,5]+'|'+;//Dt/Hr Emissao NFS-e (Cancelamento)
	aNotas[nX,6]+'|'+;//Cod autorização
	aNotas[nX,7]+'|'+;//Msg do TSS
	CRLF)
Next nX

FClose(nHdl)

If !lProc
	FErase(cArq)
EndIf

Return(lProc)
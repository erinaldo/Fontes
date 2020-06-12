#INCLUDE 'Protheus.ch'
#INCLUDE 'TopConn.ch'

/*------------------------------------------------------------------------
*
* AtuProtNfs()
* Ajusta o numero do protocolo na tabela do TSS.
* Protocolo fica sem informação na SPED051, mesmo com a NF ja autorizada.
*
------------------------------------------------------------------------*/
User Function AtuProtNfs()

Local cQuery:=''
Local cAlias:=''

If !("SIGA"$Upper(cUserName))
	Return
EndIf

iF !ApMsgYesNo('Certifique-se de que o sistema nao esta em uso. Confirma atualização?')
	Return
EndIf

cQuery:=" Select F2_SERIE, F2_DOC,F2_CODNFE From "+RetSqlName('SF2')
cQuery+=" Where F2_FILIAL='"+xFilial('SF2')+"' AND F2_SERIE='RPS' AND F2_FIMP='N' AND F2_NFELETR<>' ' AND F2_CODNFE<>' ' AND D_E_L_E_T_=' '"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

While (cAlias)->(!Eof())
	                 
	cQuery:="UPDATE "+RetSqlName('SF2')+" SET F2_FIMP='S'"
	cQuery+=" WHERE F2_FILIAL='"+xFilial('SF2')+"' AND F2_SERIE='RPS' AND F2_DOC='"+(cAlias)->F2_DOC+"' AND D_E_L_E_T_=' '"
	TcSqlExec(cQuery)
		
	cQuery:="UPDATE TITAN.TSS.dbo.SPED051 SET NFSE_PROT='"+(cAlias)->F2_CODNFE+"' WHERE NFSE_ID='"+(cAlias)->F2_SERIE+(cAlias)->F2_DOC+"'" 
	TcSqlExec(cQuery)
	(cAlias)->(dbSkip())
End
(cAlias)->(dbCloseArea())

Return

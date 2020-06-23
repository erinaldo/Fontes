#Include 'Protheus.ch'

/*/{Protheus.doc} TABSQL
Função criada para ser utilizada exclusivamente durante o processo de migração de versão do Protheus 11 para 12 
Executa a contagem de linhas das tabelas no banco de dados.
@author lorenzetti
@since 02/11/2017
@version 12.1.017
@return ${return}, ${return_description}
/*/
User Function TABSQL()
	Local cArqNew		:= ""
	Local cPath 		:= cGetFile("","Local para gravação...",1,,.F.,GETF_LOCALHARD + GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY )
	Private nHandle
	
	If !Empty(cPath)
	
	cArqNew := AllTrim(cPath)+"TABSQL_"+DTOS(DATE())+"_"+Substr(Time(),1,2)+Substr(Time(),4,2)+".LOG"

	nHandle := MsfCreate(cArqNew,0)
	IF nHandle < 0
		MsgAlert( "Falha na criação do arquivo de LOG." )
	EndIf
	
	If ApMsgYesNo("Confirma o processamento ?")
		Processa({|| ProcTAB()})
		ApMsgInfo("Fim do processo ")
	EndIf
	EndIf
Return




Static Function ProcTAB()
	Local aEmps 		:= {}
	Local cQry1		:= ""
	Local cQry2		:= ""
	Local aTabs		:= {}
	Local a			:= 0
	Local cAliasTrb 	:= GetNextAlias()
	Local nCount		:= 0
	Local nCount2		:= 0
	Local cTXT			:= ""
	
	aEmps := fEmpresas()
	
	//------------------------------------------------------------------------------------------------
	cQry1		:= "select name as TABELA from sysobjects where xtype = 'U' and len(name)= 6 order by name"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),cAliasTrb,.T.,.T.)
	dbSelectArea(cAliasTrb)
	dbGotop()
	
	Do While (cAliasTrb)->(!Eof())
		cTabela := (cAliasTrb)->TABELA
		If aScan(aEmps,Substr(cTabela,4,2))>0 .and. !(SUBSTR(cTabela,1,2) $ "SI|SX|XX")
			//IF SUBSTR(cTabela,4,3) = "020"
			AADD(aTabs,cTabela)
			//EndIf
		EndIf
		dbskip()
	EndDo
	
	If Select(cAliasTrb) > 0
		dbSelectArea(cAliasTrb)
		dbCloseArea()
	Endif
	
	//------------------------------------------------------------------------------------------------
	
	If Len(aTabs)>0
		ProcRegua(Len(aTabs))
		For a:=1 to Len(aTabs)
			cTabela := aTabs[a]
			INCPROC("TABSQL - Analisando tabela " + cTabela )
			cQry2 := " Select Count(*) as REGS from " + cTabela + " where D_E_L_E_T_ = ' ' "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry2),cAliasTrb,.T.,.T.)
			dbSelectArea(cAliasTrb)
			dbGotop()
			nREGS := 0
			Do While (cAliasTrb)->(!Eof())
				nREGS	:= (cAliasTrb)->REGS
				dbskip()
			EndDo
			If Select(cAliasTrb) > 0
				dbSelectArea(cAliasTrb)
				dbCloseArea()
			Endif
			//Verifica se tem registros
			If nREGS > 0
				nCount += 1
				cTXT := Substr(AllTrim(cTabela),1,3) 
				cTXT += ";"
				cTXT += Substr(AllTrim(cTabela),4,2) 
				cTXT += ";"
				cTXT += AllTrim(cTabela) 
				cTXT += ";"
				cTXT += Alltrim(str(nREGS))
				cTXT += CHR(13)+CHR(10)
				fWrite(nHandle, cTXT)
			Else
				nCount2 += 1
			EndIf
		Next
	EndIf
	
	fClose(nHandle)
	//------------------------------------------------------------------------------------------------
	
Return




Static Function fEmpresas()
	Local aRet := {}
	
	AADD(aRet,'99')
	AADD(aRet,'01')
	AADD(aRet,'03')
	AADD(aRet,'05')
	
Return(aRet)



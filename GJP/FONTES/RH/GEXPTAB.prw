/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ GEXPTAB	บ Autor ณ Claudinei Ferreira บ Data ณ  26/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de exporta็ใo de arquivo .CSV                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP                                                    		บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GEXPTAB()
Local aParam  := {}
Local aRetQry := {}
Local cTit1   := ""
Local _cQuery := ""
Local cObserv := ""
Local lRet    := .F.

Local oDlg
Local aRet       := {.T.,""}
Local cTexto     := ""
Local oMemo
Local cFile      := ""
Local oFont
Local cFileLog   := ""
//Local cMask      := "Arquivos Texto (*.CSV) |*.csv|"
Local cMask      := "Arquivos (*.CSV) |*.csv| Todos os Arquivos|*.*"
Local cCCusto 	 := ""
Local cConta   	 := ""

//Array com o retorno do parambox
AAdd(aRetQry,criavar("CT2_DATA"))
AAdd(aRetQry,criavar("CT2_DATA"))

//Array com a configuracao do parambox
AAdd(aParam,{1,"Data de :" ,aRetQry[1]  ,"@D","","","",50,.T.})
AAdd(aParam,{1,"Data Ate:" ,aRetQry[2]  ,"@D","","","",50,.T.})

//Define titulo, indicando o item
cTit1:= "Rotina para exportar registros CT2"

//Chamada da funcao parambox()
lRet := ParamBox(aParam,cTit1,@aRetQry,{||.T.},,.T.,80,3)

If lRet
	_cQuery := "SELECT CT2_FILIAL,CT2_DATA,CT2_DEBITO CT2_CONTA,CT2_CCD CT2_CUSTO,"
	_cQuery += "CT2_HP,CT2_HIST,CT2_VALOR CT2_VALORD,0 CT2_VALORC,CT2_DOC,CT2_LINHA FROM " + RetSqlName("CT2") + " CT2 WHERE "
	_cQuery += "CT2.CT2_FILIAL = '" + xFilial("CT2") + "' AND "
	_cQuery += "CT2.CT2_DATA BETWEEN '" + dtos(aRetQry[1]) + "' AND '" + dtos(aRetQry[2]) + "' AND "
	_cQuery += "CT2.D_E_L_E_T_ = '' AND CT2_DC <> '4' AND CT2_DEBITO <> '' AND "
	_cQuery += "CT2.CT2_LOTE = '008890' "
	_cQuery += "UNION ALL "
	_cQuery += "SELECT CT2_FILIAL,CT2_DATA,CT2_CREDIT CT2_CONTA,CT2_CCC CT2_CUSTO,"
	_cQuery += "CT2_HP,CT2_HIST,0 CT2_VALORD,CT2_VALOR CT2_VALORC,CT2_DOC,CT2_LINHA FROM " + RetSqlName("CT2") + " CT2 WHERE "
	_cQuery += "CT2.CT2_FILIAL = '" + xFilial("CT2") + "' AND "
	_cQuery += "CT2.CT2_DATA BETWEEN '" + dtos(aRetQry[1]) + "' AND '" + dtos(aRetQry[2]) + "' AND "
	_cQuery += "CT2.D_E_L_E_T_ = '' AND CT2_DC <> '4' AND CT2_CREDIT <> '' AND " 
	_cQuery += "CT2.CT2_LOTE = '008890' "
	_cQuery += "ORDER BY CT2_LINHA"
	
	
	_cQuery	:= ChangeQuery( _cQuery )
	dbUseArea( .T., 'TOPCONN', TcGenQry( ,, _cQuery ), "EXPCT2", .F., .T. )
	
	cObserv := "Filial;Data Lancamento;Conta;Centro de Custo;CM;Cod.Historico;Historico;Valor Debito;Valor Credito;Projeto;Documento"+chr(13)+chr(10)
	
	If EXPCT2->(!EOF())
        //Posiciona Cadastro de Conta Contabil
		dbSelectArea("CT1")                
		dbSetOrder(1)
        
		//Posiciona Cadastro de Centro de Custo
		dbSelectArea("CTT")
		dbSetOrder(1)

		While EXPCT2->(!EOF())  

			cData		:= 	SubString(EXPCT2->CT2_DATA,7,2)+"/"+SubString(EXPCT2->CT2_DATA,5,2)+"/"+SubString(EXPCT2->CT2_DATA,1,4)
			
			//CONTA
			If CT1->(MsSeek(xFilial("CT1")+AllTrim(EXPCT2->CT2_CONTA)))
				If !Empty(AllTrim(CT1->CT1_XCTACM))
				  cConta	:= CT1->CT1_XCTACM
				Else
				  cConta	:= EXPCT2->CT2_CONTA 
				Endif
			EndIf
			
			//CENTRO DE CUSTO
			If CTT->(MsSeek(xFilial("CTT")+AllTrim(EXPCT2->CT2_CUSTO)))
				If !Empty(AllTrim(CTT->CTT_XCCCM))
				  cCCusto 	:= CTT->CTT_XCCCM
				Else
				  cCCusto	:=	EXPCT2->CT2_CUSTO
				Endif
             Endif
             
			cCodHist:= 	EXPCT2->CT2_HP
			cHist		:=	AllTrim(EXPCT2->CT2_HIST)
			nVlDeb	:=	Transform(EXPCT2->CT2_VALORD,'@E 999999999.99') //alltrim(str(EXPCT2->CT2_VALOR)
			nVlCre	:= 	Transform(EXPCT2->CT2_VALORC,'@E 999999999.99')  
			
			cObserv += ""+EXPCT2->CT2_FILIAL+";"
			cObserv += ""+cData+";"
			cObserv += ""+cConta+";"+cCCusto+";;"+cCodHist+";"+cHist+";"
			cObserv += ""+nVlDeb+";"+nVlCre+";"
			cObserv += ""+"-1;"+EXPCT2->CT2_DOC+" "+chr(13)+chr(10)
			EXPCT2->(dbskip())
		EndDo
	EndIf
	
	
If Len(alltrim(cObserv))> 100
	If msgyesno("Confirma a exporta็ใo do arquivo para .csv?")
		cTexto += cObserv
		cFileLog := MemoWrite( CriaTrab( , .F. ) + ".csv", cTexto )
		cFile := cGetFile( cMask, "O arquivo serแ salvo como '.csv'",0,"SERVIDOR\",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
		If !empty(cFile)
			MemoWrite( cFile+".csv", cTexto )
			msginfo("Arquivo salvo com sucesso no caminho "+alltrim(cFile)+".csv")
		EndIf
	EndIf
Else
	Msginfo("Nใo houve registros para processamento!")
EndIf
	
	EXPCT2->(DbCloseArea())
	
EndIf

Return .T.

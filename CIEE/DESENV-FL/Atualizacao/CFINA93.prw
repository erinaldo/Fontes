#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CFINA93
//Processamento do Arquivo de Retorno Bancario atualizando a tabela ZAG e Baixando o SE2
@author emerson.natali
@since 03/08/2017
@version undefined

@type function
/*/
user function CFINA93(_cModelo, _cArqConf, _cArqEnt)

Local cStartPath  := GetSrvProfString("Startpath","")
Local _lRet		:= .T.
Local _cArqConf := cStartPath+"237SP.CPR" //Arquivo de Configuração Bancaria
Local _cArqEnt  := "C:\TEMP\TESTE.RET"
Local _cModelo  := _cModelo
Local lHeader 	:= .F.

Local cPosNum
Local cPosData
Local cPosDesp
Local cPosDesc
Local cPosAbat
Local cPosPrin
Local cPosJuro
Local cPosMult
Local cPosForne
Local cPosOcor
Local cPosTipo
Local cPosCgc
Local cPosDebito
Local cPosRejei
Local cRejeicao

Local lPosNum    := .f., lPosData := .f.
Local lPosDesp   := .f., lPosDesc := .f., lPosAbat := .f.
Local lPosPrin   := .f., lPosJuro := .f., lPosMult := .f.
Local lPosOcor   := .f., lPosTipo := .f.
Local lPosNsNum  := .f., lPosForne:= .f., lPosRejei:= .f.
Local lPosCgc    := .f., lPosdebito:= .f.

Default _cModelo	:= Nil
Default _cArqConf	:= Nil
Default _cArqEnt	:= Nil
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo de configuracao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !FILE(_cArqConf)
	_lRet:= .F. 
ElseIf ( _cModelo == 1 ) //Modelo 1
	nHdlConf:=FOPEN(_cArqConf,0+64)
/*
//Para o processo de Modelo2
//os campos desse modelo são pre-definidos no Fonte Padrão da TOTVS e por isso não podemos usar esse Modelo
//
ElseIf ( _cModelo == 2 ) //Modelo 2
	_cArqConf := Directory(_cArqConf)
*/
EndIF

If _lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos:=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)
	While nLidos <= nTamArq
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o tipo de qual registro foi lido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)                          

		IF SubStr(xBuffer,1,1) == CHR(1)
			nLidos+=85
			Loop
		EndIF
		IF SubStr(xBuffer,1,1) == CHR(3)
			Exit
		EndIF
		IF !lPosNum
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosData
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosDesp
			cPosDesp:=Substr(xBuffer,17,10)
			nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesp:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosDesc
			cPosDesc:=Substr(xBuffer,17,10)
			nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesc:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosAbat
			cPosAbat:=Substr(xBuffer,17,10)
			nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAbat:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosPrin
			cPosPrin:=Substr(xBuffer,17,10)
			nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosPrin:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosJuro
			cPosJuro:=Substr(xBuffer,17,10)
			nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosJuro:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosMult
			cPosMult:=Substr(xBuffer,17,10)
			nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMult:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOcor
			cPosOcor:=Substr(xBuffer,17,10)
			nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosTipo
			cPosTipo:=Substr(xBuffer,17,10)
			nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosTipo:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosNsNum
			cPosNsNum := Substr(xBuffer,17,10)
			nLenNsNum := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNsNum := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosRejei
      	cPosRejei := Substr(xBuffer,17,10)
			nLenRejei := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosRejei := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosForne
      	cPosForne := Substr(xBuffer,17,10)
			nLenForne := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosForne := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosCgc
	      	cPosCgc   := Substr(xBuffer,17,10)
			nLenCgc   := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosCgc   := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosDebito
			cPosDebito:=Substr(xBuffer,17,10)
			nLenDebito:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDebito:=.t.
			nLidos+=85
			Loop
		EndIF
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Fclose(nHdlConf)

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	If !FILE(_cArqEnt)
		lRet:= .F.
	Else
		nHdlBco:=FOPEN(_cArqEnt,0+64)
	EndIF
EndIf

/*
************************************************************
** PROCESSAMENTO DO ARQUIVO DE RETORNO ENVIADO P/ BANCO  ***
************************************************************
*/
If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le arquivo enviado pelo banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)

	Begin Transaction

	While nLidos <= nTamArq
	
		Do Case
			Case (_cModelo == 1 )
				xBuffer:=Space(nBloco)
				FREAD(nHdlBco,@xBuffer,nBloco)

				IF !lHeader
					lHeader := .T.
					nLidos	+=nBloco
					cCGCFilHeader := Substr(xBuffer, 12,14)
					Loop
				EndIF

				If SubStr(xBuffer,1,1) == "1"

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica codigo da ocorrencia ³
			 		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SEB")
					dbSetOrder(1)
					If !(dbSeek(xFilial("SEB")+mv_par05+cOcorr+"P"))
		
					Endif

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Le os valores do arquivo Retorno ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
					cData   :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
					cData   :=CTOD("") //ChangDate(cData,SEE->EE_TIPODAT)
					dBaixa  :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
					dDebito :=dBaixa		// se nao for preenchido, usa dBaixa
					cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
					cNsNum  := " "
	
					If !Empty(cPosDesp)
						nDespes:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100,2)
					EndIf
					If !Empty(cPosDesc)
						nDescont:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100,2)
					EndIf
					If !Empty(cPosAbat)
						nAbatim:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100,2)
					EndIf
					If !Empty(cPosPrin)
						nValPgto :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100,2)
					EndIF
					If !Empty(cPosJuro)
						nJuros  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100,2)
					EndIf
					If !Empty(cPosMult)
						nMulta  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100,2)
					EndIf
					If !Empty(cPosNsNum)
						cNsNum  :=Substr(xBuffer,Int(Val(Substr(cPosNsNum,1,3))),nLenNsNum)
					EndIf
					IF !Empty(cPosRejei)
						cRejeicao  :=Substr(xBuffer,Int(Val(Substr(cPosRejei,1,3))),nLenRejei)
					End
					IF !Empty(cPosForne)
						cForne  :=Substr(xBuffer,Int(Val(Substr(cPosForne,1,3))),nLenForne)
					End
			
					nTamEEOcor := If(SEE->(FieldPos("EE_TAMOCOR")) > 0,SEE->EE_TAMOCOR,2) // Tamanho da Ocorrencia Bancaria retornada pelo banco.
					cOcorr := Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
					cOcorr := PadR( Left(Alltrim(cOcorr),nTamEEOcor) , nTamOcor)
	
					If !Empty(cPosCgc)
						cCgc  :=Substr(xBuffer,Int(Val(Substr(cPosCgc,1,3))),nLenCgc)
					Endif
					If !Empty(cPosDebito)
						cDebito :=Substr(xBuffer,Int(Val(Substr(cPosDebito,1,3))),nLenDebito)
						cDebito :=ChangDate(cDebito,SEE->EE_TIPODAT)
						If !Empty(cDebito)
							dDebito :=Ctod(Substr(cDebito,1,2)+"/"+Substr(cDebito,3,2)+"/"+Substr(cDebito,5),"ddmm"+Replicate("y",Len(Substr(cDebito,5))))
						Endif
					Endif
					nCM     := 0
				Else
					nLidos += nBloco
					Loop
				EndIf
			Case (_cModelo == 2 ) //não podemo utilizar o Modelo2. A função ReadCnab2 (dentro do MATXFUNB) possue os campos FIXOS para tratar TITULOS SE2. Neste fonte os registros estão na ZAG. 
				msgalert("Não é permitido a execução do MODELO2 para esse processo customizado", "INVALIDO")
				_lRet := .F.
		End Case
		
	Enddo
	
	End Transaction
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha os Arquivos ASCII ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlBco > 0
	FCLOSE(nHdlBco)
Endif	           

If nHdlConf > 0
	FCLOSE(nHdlConf)
Endif	

Return(_lRet)
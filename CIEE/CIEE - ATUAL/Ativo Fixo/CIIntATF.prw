#INCLUDE 'Protheus.ch'

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  |CIIntATF     | Autor     | Fabio Zanchim  | Data |    10/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Geracao dos lançamentos de rateio dos condominios.    	    |
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function CIIntATF()

Local aRet:={}
Local aParam:={}
Aadd(aParam,{6,"Arquivo?",Space(70),"","File(MV_PAR01)","",70,.T.,"Arquivo .TXT |*.TXT"})

If Parambox(aParam,"Rateio C.Custo Condominios",aRet)
	IF ApMsgYesNo('Confirma contabilização do rateio de C.Custo de condomínios?')
		Processa( {|| CIAtfProc(MV_PAR01)}, "Aguarde...","Processando...", .F. )
	EndIf
EndIf

Return

Static Function CIAtfProc(cArquivo)

Local nX		:=0
Local cCustoBem	:=''
Local nDecs		:=TamSX3('CT2_VALOR')[2]
Local nTamLin	:=TamSx3("CT2_LINHA")[1]
Local nLenCC	:=TamSx3("CT2_CCC")[1]
Local nLenCT1	:=TamSx3("CT1_CONTA")[1]
Local nLenIt	:=TamSx3("CT2_ITEMD")[1]
Local nLen		:=0
Local nVlLcto	:=0
Local nVlDeb	:=0
Local nTotDeb	:=0
Local dComp		:=Ctod('')
Local cComp		:=''
Local aLog		:={}
Local aLinhas	:={}
Local aCab		:={}
Local aTotItem	:={}
Local cDoc		:='000001'
Local lVerifica	:=.T.
Private lMsErroAuto:=.F.
Private lMsHelpAuto:=.T.

Private nLenVlr := 0
         
Ft_FUse(cArquivo)
While !FT_FEof()
	Aadd(aLinhas,FT_FReadLn())
	FT_FSkip()
End
Ft_FUse()

nLen:=Len(aLinhas)
ProcRegua(nLen)

For nX:=1 to nLen
	
	IncProc('C.Custo '+Alltrim(cCustoBem)+' ...')
	If Empty(aLinhas[nX])
		Loop
	EndIf
	
	//Ultimo dia da competencia
	cComp:=RetCpo(aLinhas[nX],3)
	dComp:=cComp
	dComp:=LastDay(CtoD('01/'+dComp))//Ultimo dia do mes
	While dComp<>DataValida(dComp)//Ultimo dia util do mes
		dComp--
	End
    
	If lVerifica
		dbSelectArea('CT2')
		dbSetORder(1)//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC
		If dbSeek(xFilial('CT2')+DtoS(dComp)+'009950'+'001')
			Aadd(aLog,'Rateio ja processado na competencia '+cComp )
			Exit
		EndIf
		lVerifica:=.F.
	EndIf
	
	cCustoBem:=Padr(RetCpo(aLinhas[nX],1),nLenCC)
	dbSelectArea('PAG')
	dbSetOrder(2)//Filial + C.Custo do Bem
	If !dbSeek(xFilial('PAG')+cCustoBem)
		Aadd(aLog,'Centro de Custo '+cCustoBem+ ': Não localizado vinculo Ativo / Rateio.')
		Loop
	EndIf
		
	///Valor Credito
	//nVlLcto:=fStrToVal(RetCpo(aLinhas[nX],2),6,2)
    nVlLcto:=fStrToVal(RetCpo(aLinhas[nX],2),nLenVlr,2)
	nVlLcto:=Round(nVlLcto,nDecs)
	
	dbSelectArea('CT1')
	dbSetOrder(2)//Conta reduzida
	dbSeek(xFilial('CT1')+Padr('32034',nLenCT1))
	
	//-------------------------------	
	// Lançamentos Debito (Rateio)
	//-------------------------------
	nLin:=1
	nTotDeb:=0
	nPercTot:=0
	aTotItem:={}
	dbSelectArea('PAG')
	While !Eof() .And. cCustoBem==PAG_CUSBEM
		If PAG_STATUS=="2"//Inativo
			dbSkip()
			Loop
		EndIf
		
		nPercTot+=PAG_PERC
		nVlDeb:=nVlLcto*(PAG_PERC/100)
		nVlDeb:=Round(nVlDeb,nDecs)
		nTotDeb+=nVlDeb
		
		Aadd(aTotItem, {{"CT2_FILIAL"	,xFilial('CT2')					, NIL},;
						{"CT2_LINHA"	,StrZero(nLin,nTamLin)			, NIL},;
						{"CT2_MOEDLC"	,"01"							, NIL},;
						{"CT2_DC"		,"1"							, NIL},;
						{"CT2_DEBITO"	,CT1->CT1_CONTA					, NIL},;
						{"CT2_CREDIT"	,Padr('',nLenCT1)				, NIL},;
						{"CT2_VALOR"	,nVlDeb							, NIL},;
						{"CT2_CCD"		,PAG_CUSTO						, NIL},;
						{"CT2_CCC"		,Padr('',nLenCC)				, NIL},;
						{"CT2_ITEMD"	,Padr('32034',nLenIt)			, NIL},;
						{"CT2_ITEMC"	,Padr('',nLenIt)				, NIL},;
						{"CT2_ORIGEM"	,'731 RATEIO ATF'				, NIL},;
						{"CT2_TPSALD"	,'9'							, NIL},;
						{"CT2_HIST"		,'Rateio despesas condominio - '+cComp, NIL}}	)

		dbSkip()
		nLin++
	End                      
	
	
	If nPercTot<100
		//Percentual nao utilizado no CR joga em um centro de custo fixo.
		nVlDeb:=nVlLcto*((100-nPercTot)/100)
		nVlDeb:=Round(nVlDeb,nDecs)
		nTotDeb+=nVlDeb
		
		Aadd(aTotItem, {{"CT2_FILIAL"	,xFilial('CT2')					, NIL},;
						{"CT2_LINHA"	,StrZero(nLin,nTamLin)			, NIL},;
						{"CT2_MOEDLC"	,"01"							, NIL},;
						{"CT2_DC"		,"1"							, NIL},;
						{"CT2_DEBITO"	,CT1->CT1_CONTA					, NIL},;
						{"CT2_CREDIT"	,Padr('',nLenCT1)				, NIL},;
						{"CT2_VALOR"	,nVlDeb							, NIL},;
						{"CT2_CCD"		,Padr('00998',nLenCC)			, NIL},;
						{"CT2_CCC"		,Padr('',nLenCC)				, NIL},;
						{"CT2_ITEMD"	,Padr('32034',nLenIt)			, NIL},;
						{"CT2_ITEMC"	,Padr('',nLenIt)				, NIL},;
						{"CT2_ORIGEM"	,'731 RATEIO ATF'				, NIL},;
						{"CT2_TPSALD"	,'9'							, NIL},;
						{"CT2_HIST"		,'Rateio despesas condominio - '+cComp, NIL}}	)
						
		nLin++
	EndIf
	
	//Ajusta a ultima linha em funcao do arredondamento
	If nTotDeb>0
		If nTotDeb>nVlLcto
			nVlDeb:=nVlDeb - (nTotDeb-nVlLcto)
		Else
			If nTotDeb<nVlLcto
				nVlDeb:=nVlDeb + (nVlLcto-nTotDeb)
			EndIf
		EndIf
		aTotItem[Len(aTotItem),7,2]:=nVlDeb
	EndIf	

	//-------------------------------	
	// Lançamento Credito (Arquivo)
	//-------------------------------	
	Aadd(aTotItem, {{"CT2_FILIAL"	,xFilial('CT2')					, NIL},;
					{"CT2_LINHA"	,StrZero(nLin,nTamLin)			, NIL},;
					{"CT2_MOEDLC"	,"01"							, NIL},;
					{"CT2_DC"		,"2"							, NIL},;
					{"CT2_DEBITO"	,Padr('',nLenCT1)				, NIL},;
					{"CT2_CREDIT"	,CT1->CT1_CONTA					, NIL},;
					{"CT2_VALOR"	,nVlLcto						, NIL},;
					{"CT2_CCD"		,Padr('',nLenCC)				, NIL},;
					{"CT2_CCC"		,cCustoBem						, NIL},;
					{"CT2_ITEMD"	,Padr('',nLenIt)				, NIL},;
					{"CT2_ITEMC"	,Padr('32034',nLenIt)			, NIL},;
					{"CT2_ORIGEM"	,'731 RATEIO ATF'				, NIL},;
					{"CT2_TPSALD"	,'9'							, NIL},;
					{"CT2_HIST"		,'Rateio despesas condominio - '+cComp, NIL}}	)
	
	aCab := {{"dDataLanc"	,dComp		,NIL},;
			{"cLote"		,'009950'	,NIL},;
			{"cSubLote"		,'001'		,NIL},;
			{"cDoc"			,cDoc		,NIL},;
			{"cPadrao"		,""			,NIL},;
			{"nTotInf"		,0			,NIL},;
			{"nTotInfLote"	,0			,NIL}}
		
	lMsErroAuto:=.F.
	MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aTotItem,3)
		
	If lMsErroAuto
		Aadd(aLog,'Centro de Custo '+cCustoBem+ ': Inconsistência na inclusão do lançamento.')
		MostraErro()
	Else
		Aadd(aLog,'Centro de Custo '+cCustoBem+ ': Lançamento incluído com sucesso.')
		cDoc:=Soma1(cDoc,Len(cDoc))
	Endif

Next nX

MostraText(aLog)

Return

/*------------------------------------------------------------------------
* Retorna campo de determinada linha na posição desejada
------------------------------------------------------------------------*/
Static Function RetCpo(cString,nPos)

Local nX:=0
Local nPosAnt:=0
Local nContPos:=0
Local cCpo:=""

For nX:=1 to Len(cString)
	
	If Substr(cString,nX,1)=='|' .Or. nX==(Len(cString))
		nContPos++
		If nContPos==nPos-1
			nPosAnt:=nX//Posicao inicial da posicao a ser pega
		EndIf
		If nContPos==nPos
			If nX==(Len(cString))//Esta pegando ultimo campo da linha
				cCpo:=Substr(cString,nPosAnt+1,nX-nPosAnt)
				Exit
			Else
				cCpo:=Substr(cString,nPosAnt+1,nX-nPosAnt-1) 
				/*Alterado por André*/ 
				
				If nPosAnt == 6
				   nLenVlr := len(cCpo)-2
				EndIF
				
				Exit
			EndIf
		EndIf
	EndIf
	
Next nX

Return(cCpo)

/*--------------------------------------------------------------------------
* Transforma em numerico a string
--------------------------------------------------------------------------*/
Static Function fStrToVal(cVal,nInt,nDec)
cVal:=Substr(cVal,1,nInt)+'.'+Substr(cVal,nInt+1,nDec)
Return(Val(cVal))


/*--------------------------------------------------------------------------
* Mostra o logo do processamento
--------------------------------------------------------------------------*/
Static Function MostraText(aLog)

Local oDlg, oMemo
Local cTexto:=''
Local nX:=0

cTexto := "Rateio Despesas Condominio"+CRLF
cTexto +=Repl("-",30)+CRLF+CRLF
For nX:=1 to Len(aLog)
	cTexto +=aLog[nX]+CRLF
Next nX

__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE '' From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga

ACTIVATE MSDIALOG oDlg CENTER
Return

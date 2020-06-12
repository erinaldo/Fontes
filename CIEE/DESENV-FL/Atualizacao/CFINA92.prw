#Include 'Protheus.ch'
#Include 'topconn.ch'

/*/{Protheus.doc} CFINA92
//Geração do arquivo CNAB modelo Folha de Pagamento com base no arquivo ZAG - FL (APDATA).
@author emerson.natali
@since 31/07/2017
@version undefined

@type function
/*/

User Function CFINA92()

Local nOpca := 0

Private cCadastro 	:= OemToAnsi("Geracao arquivo CNAB - FL")
Private cPerg   	:= "CFINA92   "
Private aSays 		:= {}
Private aButtons	:= {}

//Cria as Perguntas
CFin92SX1(cPerg)

pergunte(cPerg,.F.)

AADD(aSays,OemToAnsi(" Este programa tem o objetivo de gerar o arquivo CNAB") )
AADD(aSays,OemToAnsi("                                                     ") )
AADD(aSays,OemToAnsi("                                                     ") )

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) 	}} )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() 			}} )

FormBatch( cCadastro, aSays, aButtons )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpca == 1
    Processa({|lEnd| CFin92Proc(),"Processando arquivo de Envio CNAB"})
Endif

Return

/*/{Protheus.doc} CFin92Proc
//TODO Descrição auto-gerada.
@author emerson.natali
@since 07/08/2017
@version undefined
@param _cCodigo, , descricao
@param _cBanco, , descricao
@param _cProPgt, , descricao
@param _cArquivo, , descricao
@param _cCaminho, , descricao
@param _cModelo, , descricao
@param _cExtensao, , descricao
@type function
/*/

/*
//Parametros da Rotina
//mv_par01 - Bordero de
//mv_par02 - Bordero ate
//mv_par03 - Arq de Configuracao
//mv_par04 - Arq de Saida
//mv_par05 - Cod Banco
//mv_par06 - Cod Agencia 
//mv_par07 - Cod Conta
//mv_par08 - Modelo (1/2)
*/
Static Function CFin92Proc(_cCodigo, _cBanco, _cProPgt, _cArquivo, _cCaminho, _cModelo, _cExtensao)
Local cStartPath  := GetSrvProfString("Startpath","")
Local nLidos	  := 0
Local nTamArq	  := 0
Local xBuffer	  := ""
Local lFirst	  := .F.
Local lHeader	  := .F.
Local lGrava	  := .F.
Local nTam		  := 0
Local nDec		  := 0                               
Local cConteudo	  := ""                              
Local _cArqTrab   := "" //Arquivo de Trabalho - query
Local _cQuery	  := ""
Local _cCodigo	  := '000001' // Campo chave no processamento do ESB para controle da VIEW
Local _lGerouCNAB := .T.

Default _cBanco  	:= If(mv_par05 == Nil, Nil, mv_par05          )
Default _cArquivo 	:= If(mv_par03 == Nil, Nil, alltrim(mv_par03) )
Default _cCaminho 	:= If(mv_par04 == Nil, Nil, alltrim(mv_par04) )
Default _cModelo 	:= If(mv_par08 == Nil, Nil, mv_par08) 
Default _cExtensao 	:= If(mv_par09 == Nil, Nil, mv_par09)


Private nSeq	  := 0
Private nModelo	  := _cModelo //Parametro Modelo - vem da tabela SZL  
Private cArqEnt   := cStartPath+_cArquivo // Nome do layout de remessa
Private cArqSaida := alltrim(_cCaminho) // Diretorio onde sera criado os arquivo de Remessa.
Private cArqExtc  := _cExtensao 			//".REM"
Private nHdlBco   := 0
Private nHdlSaida := 0
Private xConteudo := Nil
Private fArquivo  := Nil   
Private nTotal    := 0   

Default _cCodigo := Nil
Default _cProPgt := Nil

If _cCodigo == Nil
	Return
EndIf

fArquivo  := C6E01ABR("FL_"+Dtos(Date())+"_"+ STRTRAN(Time(),":",""))
IF !fArquivo[1]
	Return
ENDIF

_cArqTrab:= GetNextAlias()

/*
BeginSQL Alias _cArqTrab
	SELECT * 
	FROM %Table:ZAG% ZAG 
	WHERE ZAG.%NotDel% 
	AND ZAG.ZAG_CODIGO = %Exp:_cCodigo%
	AND ZAG.ZAG_BANCO = %Exp:_cBanco%
	AND ZAG_PROPGT = %Exp:_cProPgt%
	AND ZAG_TITSE2 <> ''
EndSQL
*/

/*
BeginSQL Alias _cArqTrab
	SELECT * 
	FROM %Table:ZAG% ZAG , %Table:SEA% SEA, %Table:SE2% SE2
	WHERE ZAG.%NotDel% AND SEA.%NotDel% AND SE2.%NotDel%
	AND SEA.EA_NUMBOR = SE2.E2_NUMBOR
	AND SEA.EA_NUMBOR BETWEEN %Exp:_cBanco% AND %Exp:_cBanco%
	AND SE2.E2_PREFIXO+SE2.E2_NUM+SE2.E2_PARCELA+SE2.E2_TIPO+SE2.E2_FORNECE+SE2.E2_LOJA = ZAG.ZAG_TITSE2
EndSQL
*/
_cQuery := "SELECT * " 
_cQuery += "FROM "+RetSqlName('ZAG')+" ZAG, "+RetSqlName('SEA')+" SEA,"+RetSqlName('SE2')+" SE2 "
_cQuery += "WHERE ZAG.D_E_L_E_T_ = '' AND SEA.D_E_L_E_T_ = '' AND SE2.D_E_L_E_T_ = '' "
_cQuery += "AND SEA.EA_NUMBOR = SE2.E2_NUMBOR "
_cQuery += "AND SEA.EA_NUMBOR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery += "AND SE2.E2_PREFIXO+SE2.E2_NUM+SE2.E2_PARCELA+SE2.E2_TIPO+SE2.E2_FORNECE+SE2.E2_LOJA = ZAG.ZAG_TITSE2  "

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),_cArqTrab,.f.,.t.)

While (_cArqTrab)->(!Eof()) 
	
			nSeq++
			
			If ( nModelo == 1 )
				//*************************************
				//Le Arquivo de Parametrizacao
				//*************************************
				nLidos := 0
				fSeek(nHdlBco,0,0)
				nTamArq:=FSEEK(nHdlBco,0,2)
				fSeek(nHdlBco,0,0)
				
				While nLidos <= nTamArq
					//*************************************
					//Verifica o tipo qual registro foi lido
					//*************************************
					xBuffer := Space(85)
					FREAD(nHdlBco,@xBuffer,85)
					
					Do case
						Case SubStr(xBuffer,1,1) == CHR(1) //CABEÇALHO - CHR(1) = SOH (start of heading)
							IF lHeader
								nLidos+=85
								Loop
							EndIF
						Case SubStr(xBuffer,1,1) == CHR(2) //DETALHE - CHR(2) = STX (start of text)
							IF !lFirst
								lFirst := .T.
								FWRITE(nHdlSaida,CHR(13)+CHR(10))
							EndIF
						Case SubStr(xBuffer,1,1) == CHR(3) //RODAPE - CHR(3) = ETX (end of text)
							nLidos+=85
							Loop
						Otherwise
							nLidos+=85
							Loop
					EndCase
					
					nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
					nDec := Val(SubStr(xBuffer,23,1))
					cConteudo := SubStr(xBuffer,24,60)
					lGrava := C6E01GRV(nTam,nDec,cConteudo)
					IF !lGrava
						Exit
					End
					nLidos+=85
				EndDO
				IF !lGrava
					Exit
				End
				
			Else
				lGrava := C6E01GRV(,,,)
			EndIf
			
			If lGrava
				If ( nModelo == 1 )
					fWrite(nHdlSaida,CHR(13)+CHR(10)) //[ENTER] ---> CHR(13)=CR (carriage return) - CHR(10)=LF (NL line feed, new line)
					IF !lHeader
						lHeader := .T.
					EndIF
				EndIf         
			EndIf
(_cArqTrab)->(DbSkip())
End 

If nSeq > 0 
	If ( nModelo == 1 )
		//*************************************
		//Monta Registro Trailler
		//*************************************
		nSeq++
		nLidos := 0
		FSEEK(nHdlBco,0,0)
		nTamArq:=FSEEK(nHdlBco,0,2)
		FSEEK(nHdlBco,0,0)
		
		While nLidos <= nTamArq
			
			IF !lGrava
				Exit
			End
			
			//*************************************
			//Tipo qual registro foi lido
			//*************************************
			xBuffer:=Space(85)
			FREAD(nHdlBco,@xBuffer,85)
			
			IF SubStr(xBuffer,1,1) == CHR(3)
				nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
				nDec := Val(SubStr(xBuffer,23,1))
				cConteudo := SubStr(xBuffer,24,60)
				lGrava := C6E01GRV( nTam,nDec,cConteudo )
				IF !lGrava
					Exit
				End
			EndIF
			nLidos+=85
		EndDO
		If lGrava
			fWrite(nHdlSaida,CHR(13)+CHR(10))
		EndIf
	Else
		RodaCnab2(nHdlSaida,cArqent,.t.)
	EndIf    
EndIf    

fClose(nHdlSaida)

Return(_lGerouCNAB)

/*/{Protheus.doc} C6E01GRV
//Grava arquivo
@author emerson.natali
@since 04/08/2017
@version undefined
@param nTam, numeric, descricao
@param nDec, numeric, descricao
@param cConteudo, characters, descricao
@type function
/*/
Static Function C6E01GRV( nTam,nDec,cConteudo )
Local lConteudo := .T.

While .T.
	If ( nModelo == 1 )
		//*************************************
		//Analisa conteudo
		//*************************************
		IF Empty(cConteudo)
			cCampo:=Space(nTam)
		Else
			lConteudo := C6E01MCRO( cConteudo )
			IF !lConteudo
				Exit
			Else
				IF ValType(xConteudo)="D"
					cCampo := GravaData(xConteudo,.F.)
				Elseif ValType(xConteudo)="N"
					cCampo := Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
				Else
					cCampo := Substr(xConteudo,1,nTam)
				End
			End
		End
		IF Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
			cCampo := cCampo+Space(nTam-Len(cCampo))
		End
		Fwrite( nHdlSaida,cCampo,nTam )
	Else
		DetCnab2(nHdlSaida,cArqent)
	EndIf
	Exit
End

Return lConteudo

/*/{Protheus.doc} C6E01ABR
//Abre arquivo
@author emerson.natali
@since 04/08/2017
@version undefined
@param cNumCnab, characters, descricao
@type function
/*/
Static Function C6E01ABR(cNumCnab)

IF !FILE(cArqEnt)
	ConOut("Arquivo "+cArqEnt+" nao encotrado!")
	Return .F.
Else
	If ( nModelo == 1 )
		nHdlBco := FOPEN(cArqEnt,0+64)
	EndIf
EndIF

//*************************************
//Cria Arquivo Saida
//*************************************
If ( nModelo == 1 )
	nHdlSaida := MSFCREATE(cArqSaida+cNumCnab+cArqExtc,0)
Else
	nHdlSaida := HeadCnab2(cArqSaida+cNumCnab+cArqExtc,cArqent)
EndIf

Return {.T.,cArqSaida+cNumCnab+cArqExtc}

/*/{Protheus.doc} C6E01MCRO
//Executa macro
@author emerson.natali
@since 04/08/2017
@version undefined
@param cForm, characters, descricao
@type function
/*/
Static Function C6E01MCRO( cForm )
Local bBlock := ErrorBlock(),bErro := ErrorBlock( { |e| ChecErr260(e,cForm) } )
Private lRet := .T.

BEGIN SEQUENCE
xConteudo := &cForm
END SEQUENCE
ErrorBlock(bBlock)

Return lRet

/*/{Protheus.doc} CFin92SX1
//Parametros para a seleção e geração do arquivo CNAB
@author emerson.natali
@since 09/08/2017
@version undefined
@param cPerg, characters, descricao
@type function
/*/
Static Function CFin92SX1(cPerg)
Local aArea    := GetArea()
Local aAreaDic := SX1->( GetArea() )
Local aEstrut  := {}
Local aStruDic := SX1->( dbStruct() )
Local aDados   := {}
Local nI       := 0
Local nJ       := 0
Local nTam1    := Len( SX1->X1_GRUPO )
Local nTam2    := Len( SX1->X1_ORDEM )

aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
             "X1_IDFIL"  }

aAdd( aDados, {cPerg,'01','Bordero de    ?','','','mv_ch1','C',06,0,0,'G','','mv_par01',''        ,'','','' ,'',''        ,'','','','','','','','','','','','','','','','','','','BOR_FL','','','','',''} )
aAdd( aDados, {cPerg,'02','Bordero ate   ?','','','mv_ch2','C',06,0,1,'G','','mv_par02',''        ,'','','' ,'',''        ,'','','','','','','','','','','','','','','','','','','BOR_FL','','','','',''} )
aAdd( aDados, {cPerg,'03','Arq de Config ?','','','mv_ch3','C',12,0,1,'G','','mv_par03',''        ,'','','' ,'',''        ,'','','','','','','','','','','','','','','','','','','SZL_FL','','','','',''} )
aAdd( aDados, {cPerg,'04','Arq de Saida  ?','','','mv_ch4','C',50,0,1,'G','','mv_par04',''        ,'','','' ,'',''        ,'','','','','','','','','','','','','','','','','','',''      ,'','','','',''} )
aAdd( aDados, {cPerg,'05','Cod Banco     ?','','','mv_ch5','C',3 ,0,1,'G','','mv_par05',''        ,'','','' ,'',''        ,'','','','','','','','','','','','','','','','','','',''      ,'','','','',''} )
aAdd( aDados, {cPerg,'06','Cod Agencia   ?','','','mv_ch6','C',5 ,0,1,'G','','mv_par06',''        ,'','','' ,'',''        ,'','','','','','','','','','','','','','','','','','',''      ,'','','','',''} )
aAdd( aDados, {cPerg,'07','Cod Conta     ?','','','mv_ch7','C',10,0,1,'G','','mv_par07',''        ,'','','' ,'',''        ,'','','','','','','','','','','','','','','','','','',''      ,'','','','',''} )
aAdd( aDados, {cPerg,'08','Modelo        ?','','','mv_ch8','N',1 ,0,1,'C','','mv_par08','Modelo1' ,'','','' ,'','Modelo2' ,'','','','','','','','','','','','','','','','','','',''      ,'','','','',''} )
aAdd( aDados, {cPerg,'09','Extensao      ?','','','mv_ch9','C',4 ,0,1,'G','','mv_par09',''        ,'','','' ,'',''        ,'','','','','','','','','','','','','','','','','','',''      ,'','','','',''} )

//
// Atualizando dicionario
//
dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )

For nI := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nI][1], nTam1 ) + PadR( aDados[nI][2], nTam2 ) ) )
		RecLock( "SX1", .T. )
		For nJ := 1 To Len( aDados[nI] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aDados[nI][nJ] ) )
			EndIf
		Next nJ
		MsUnLock()
	EndIf
Next nI

RestArea( aAreaDic )
RestArea( aArea )
Return NIL
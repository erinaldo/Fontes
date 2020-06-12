#include "Protheus.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA07
Integração de pedidos e faturamento - EAI
@author   	Totvs
@since     	01/08/2014
@version  	P.11      
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
			|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CEAIA07(cXML)
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
Local cFunXml		:= "CEAIA07"
Local cDescXml 	:= "Pedido de Venda"
Local aMsgCab		:= {"","0",""}
Local aCab			:= {}
Local aItens		:= {}
Local aLinha		:= {}
Local nTotIt		:= 0 
Local nCnt			:= 0
Local cCodId		:= ""
Local xValor   	:= ""
Local cCmpX3   	:= ""
Local cCliSoe		:= ""
Local cSerNF 		:= ""
Local cNotaInc	:= ""
Local cProdSoc	:= AllTrim(GetNewPar("MV_XPRDSOC"," "))
Local cTESSoc		:= AllTrim(GetNewPar("MV_XTESSOC"," "))
Local cCondPg		:= AllTrim(GetNewPar("MV_XCONSOC"," "))
Local cErroBlk  	:= ""
Local oLastError	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack , BREAK(e) })
Private lMsErroAuto:=.F.
Private lAutoErrNoFile:= .T.
Default cXML    := ""   

oXml := XmlParser(cXML, cDelimit, @cError, @cWarning)

if !(Empty(cError) .and. Empty(cWarning))
    
	if !Empty(cError)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - Erro na estrutura do xml"+CRLF
    endif

	if !Empty(cWarning)    
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - "+cWarning+CRLF	
	endif 
		
	CCA07RXML(cFunXml,cDescXml,aMsgCab)
	Return
endif 

// Valida se o xml é de pedidos
if Type('oXml:_'+cFunXml+':_SC5MASTER') == "U" 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+CRLF
	CCA07RXML(cFunXml,cDescXml,aMsgCab)
	Return
endif 

// Valida se o xml possui cliente
if Type('oXml:_'+cFunXml+':_SC5MASTER:_SA1MASTER') != "U" 

	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek("SA1"))
	
	// Carrega vetor com os campos
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "SA1"

		IF SX3->X3_CONTEXT == "V"
			SX3->(dbSkip())
			Loop
		ENDIF		
	
		IF Type("oXml:_"+cFunXml+":_SC5MASTER:_SA1MASTER:_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
			// Carrega conteudo do variavel
			xValor := &("oXml:_"+cFunXml+":_SC5MASTER:_SA1MASTER:_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
			cCmpX3 := Alltrim(SX3->X3_CAMPO)
			
			// Faz tratamento do dado
			IF SX3->X3_TIPO == "C"
				xValor := PadR(xValor,SX3->X3_TAMANHO)
			ELSEIF SX3->X3_TIPO == "N"
				xValor := Val(xValor)
			ELSEIF SX3->X3_TIPO == "D"
				xValor := Stod(xValor)
			ENDIF 
			
			if cCmpX3 == "A1_XCODSOE"  
				cCliSoe:= xValor
			endif 		
	
			aAdd( aCab, {Alltrim(SX3->X3_CAMPO),xValor, NIL } )
		ENDIF
		SX3->(dbSkip())
	Enddo
	
	IF Len(aCab) == 0  
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "Os campos do cliente não foram localizados no dicionário de dados."+CRLF
		CCA07RXML(cFunXml,cDescXml,aMsgCab)
		Return
	ELSE 	
		nOpcXml:= 3
		DBSELECTAREA("SA1")
		DbOrderNickName("CODCLISOE")
		IF DBSEEK(XFILIAL("SA1")+cCliSoe)   
			nOpcXml:= 4
		ENDIF
	ENDIF
	
	Begin Transaction
		
		MSExecAuto( { | x, y | Mata030( x, y ) }, aCab, nOpcXml )
		
		If lMsErroAuto
			
			If (__lSX8)
				RollBackSX8()
			EndIf     
			
			aMsgCab[2]:= "1"
			aMsgCab[3]+= U_CESBTRA(GetAutoGRLog())
			DisarmTransaction()
			CCA07RXML(cFunXml,cDescXml,aMsgCab)
			Return							
		Else		
			If (__lSX8)
				ConfirmSX8()
			EndIf		
		EndIf
	End Transaction
	
	aCab:= {}	
	lMsErroAuto	:= .F.
	lAutoErrNoFile:= .T.
ELSE
	//-- Codigo do cliente SOE
	IF Type("oXml:_CEAIA07:_SC5MASTER:_A1_XCODSOE:REALNAME") <> "U"
		cCliSoe:= oXml:_CEAIA07:_SC5MASTER:_A1_XCODSOE:_VALUE:TEXT
	else
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - Tag A1_XCODSOE não localizada"+CRLF
		CCA07RXML(cFunXml,cDescXml,aMsgCab)
		Return	
	Endif		
Endif
      
dbSelectArea('SX3')
dbSetOrder(1)
dbSeek('SC5')
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == 'SC5'                         
		
	IF SX3->X3_CONTEXT == "V"
		SX3->(dbSkip())
		Loop
	ENDIF	
	
	IF Type("oXml:_CEAIA07:_SC5MASTER:_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"   
	
		//-- Carrega conteudo do variavel
		xValor := &("oXml:_CEAIA07:_SC5MASTER:_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
		cCmpX3 := Alltrim(SX3->X3_CAMPO)
		
		//-- Tratamento do dado 
		IF SX3->X3_TIPO == "C"
			xValor := PadR(xValor,SX3->X3_TAMANHO)
		ELSEIF SX3->X3_TIPO == "N"
			xValor := Val(xValor)
		ELSEIF SX3->X3_TIPO == "D"
			xValor := Stod(xValor)
		ENDIF   
				
		//-- Array do Execauto
		aAdd( aCab, {Alltrim(SX3->X3_CAMPO),xValor, NIL } )

		//--Identificação do processo
		If cCmpX3 == "C5_XRPSSOC"
			cCodId:= xValor
		EndIf   
		
	ENDIF
	SX3->(dbSkip())
Enddo             

aMsgCab[1]:= cCodId

//Verifica se existe um pedido com a mesma RPS
DBSELECTAREA("SC5")
DbOrderNickName("CODRPSSOE")
IF !DBSEEK(XFILIAL("SC5")+cCodId)	 
	IF !EMPTY(cCliSoe)   		
		//Verifica existencia do Cliente
		DBSELECTAREA("SA1")
		DbOrderNickName("CODCLISOE")
		IF DBSEEK(XFILIAL("SA1")+cCliSoe)   
				
			Aadd(aCab,{"C5_TIPO"   ,"N"       		,Nil})
			Aadd(aCab,{"C5_CLIENTE",SA1->A1_COD 	,Nil})
			Aadd(aCab,{"C5_LOJACLI",SA1->A1_LOJA  	,Nil})
			Aadd(aCab,{"C5_EMISSAO",Date()			,Nil})
			Aadd(aCab,{"C5_PESOL"  ,1				,Nil})
			Aadd(aCab,{"C5_PBRUTO" ,1				,Nil})
			Aadd(aCab,{"C5_INCISS" ,"N"    	   		,Nil})
			Aadd(aCab,{"C5_MOEDA"  ,1        	 	,Nil})
			Aadd(aCab,{"C5_CONDPAG", cCondPg		,Nil})
			Aadd(aCab,{"C5_PARC1"  , 100			,Nil})
			
		Else              
			aMsgCab[2]:= "1"
			aMsgCab[3]+= "Cliente SOE "+ cCliSoe +", não localizado."+CRLF
			CCA07RXML(cFunXml,cDescXml,aMsgCab)
			Return		
		ENDIF 
		
	ELSE
		aMsgCab[2]:= "1"
		aMsgCab[3]+= cCmpX3+" (Campo obrigatório não preenchido)" +CRLF
		CCA07RXML(cFunXml,cDescXml,aMsgCab)
		Return
	ENDIF
	
	nTotIt := IIF(Type("oXml:_CEAIA07:_SC5MASTER:_SC6DETAIL:_ITEMS:_ITEM") == "A",Len(oXml:_CEAIA07:_SC5MASTER:_SC6DETAIL:_ITEMS:_ITEM),1)
	
	For nCnt := 1 to nTotIt
		
		aLinha:= {}
		
		SX3->(dbSetOrder(1))
		SX3->(dbGoTop())
		SX3->(dbSeek("SC6"))
		While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "SC6"
		
			IF SX3->X3_CONTEXT == "V"
				SX3->(dbSkip())
				Loop
			ENDIF	
		
			If Alltrim(SX3->X3_CAMPO)=='C6_ITEM'
				Aadd(aLinha,{"C6_ITEM"	,StrZero(nCnt,Len(SC6->C6_ITEM)),NIL} )
				SX3->(dbSkip())
				Loop
			EndIf    
			
			If Alltrim(SX3->X3_CAMPO)=='C6_PRODUTO'
				Aadd(aLinha,{"C6_PRODUTO",cProdSoc ,NIL} )	
				SX3->(dbSkip())
				Loop
			EndIF	                              
			
			If Alltrim(SX3->X3_CAMPO)=='C6_TES'
				Aadd(aLinha,{"C6_TES",cTESSoc ,NIL} )	
				SX3->(dbSkip())
				Loop
			EndIF			
			
			IF Type("oXml:_CEAIA07:_SC5MASTER:_SC6DETAIL:_ITEMS:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnt))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
				
				xValor := &("oXml:_CEAIA07:_SC5MASTER:_SC6DETAIL:_ITEMS:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnt))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
				cCmpX3 := Alltrim(SX3->X3_CAMPO)			
				
				//-- Tratamento do dado 
				IF SX3->X3_TIPO == "C"
					xValor := PadR(xValor,SX3->X3_TAMANHO)
				ELSEIF SX3->X3_TIPO == "N"			
					IF cCmpX3$"C6_QTDVEN,C6_QTDLIB" 
						xValor := CCA07VAL(xValor,7,2)
					ELSEIF cCmpX3$"C6_PRUNIT,C6_PRCVEN,C6_VALOR" 
						xValor := CCA07VAL(xValor,10,4)							
					ELSE	
						xValor := Val(xValor)
					ENDIF	
				ELSEIF SX3->X3_TIPO == "D"
					xValor := Stod(xValor)
				ENDIF  
				
				aAdd(aLinha,{cCmpX3,xValor,NIL})			
				
			ENDIF
			SX3->(dbSkip())
		Enddo	
		
		Aadd(aItens, aLinha )
	Next nCnt 
	
		
	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItens,3)
	
	If lMsErroAuto
		aMsgCab[2]:= "1"
		aMsgCab[3]+= U_CESBTRA(GetAutoGRLog())	
		DisarmTransaction()
		CCA07RXML(cFunXml,cDescXml,aMsgCab)
		RETURN
	endif
endif

// Verifica-se a nota já foi gerada
IF EMPTY(SC5->C5_NOTA)
	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))
	SC6->( DbSeek( xFilial('SC6')+SC5->C5_NUM ) )
	dbSelectArea('SC9')
	SC9->(dbSetOrder(1))
	If SC9->( DbSeek( xFilial('SC9')+SC5->C5_NUM + SC6->C6_ITEM ) )
		While SC9->(!Eof()) .And. SC9->C9_FILIAL == xFilial('SC9') .And. SC9->C9_PEDIDO == SC5->C5_NUM
			nRecSc9 := SC9->(Recno())
			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .Or.;
				(SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .Or. SC9->C9_BLCRED=="09" )
				a450Grava(1,.T.,.T.,.F.)//Libera
			EndIf
			SC9->(MsGoto(nRecSc9))
			SC9->(dbskip())
		EndDo
	EndIf
	
	// Preparacao do array com itens a serem faturados
	SB1->(DbSetOrder(1))
	SB2->(DbSetOrder(1))
	SF4->(DbSetOrder(1))
	SC5->(DbSetOrder(1))
	SC5->(DbSeek( xFilial('SC5')+SC5->C5_NUM ))
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial('SE4')+SC5->C5_CONDPAG) )
	SC6->(DbSetOrder(1) )
	SC6->(DbSeek( xFilial('SC6')+SC5->C5_NUM ) )
	
	aPvlNfs:={}
	While SC6->( !Eof() ) .And. SC6->( C6_FILIAL + C6_NUM ) = xFilial('SC5')+SC5->C5_NUM
		If SC9->( DbSeek( xFilial('SC9')+SC5->C5_NUM + SC6->C6_ITEM ) )  //FILIAL+NUMERO+ITEM
			SB1->(DbSeek(xFilial('SB1')+SC9->C9_PRODUTO) )               //FILIAL+PRODUTO
			SB2->(DbSeek(xFilial('SB2')+SC9->(C9_PRODUTO+C9_LOCAL)) )    //FILIAL+PRODUTO+LOCAL
			SF4->(DbSeek(xFilial('SF4')+SC6->C6_TES) )                //FILIAL+CODIGO
			
			aAdd(aPvlNfs,{ SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_SEQUEN,SC9->C9_QTDLIB,;
			SC9->C9_PRCVEN,SC9->C9_PRODUTO,SF4->F4_ISS=='S',SC9->(RecNo()),;
			SC5->(RecNo()),SC6->(RecNo()),SE4->(RecNo()),SB1->(RecNo()),;
			SB2->(RecNo()),SF4->(RecNo()),SB2->B2_LOCAL,0,SC9->C9_QTDLIB2})
		EndIf
		SC6->( dbSkip() )
	EndDo
	
	IF !EMPTY(aPvlNfs)
		cSerNF :=PadR("RPS",Len(SF2->F2_SERIE))	
		//-- Inclui a nota
		cNotaInc	:= MaPvlNfs(aPvlNfs,cSerNF, .F., .F., .F., .F., .F., 0, 0, .F., .F.,,,)
		If Empty(cNotaInc)	
			aMsgCab[2]:= "1"
			aMsgCab[3]+= "Erro na geração da Nota."
			CCA07RXML(cFunXml,cDescXml,aMsgCab)	
		EndIf
	ELSE
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "Erro na geração da Nota."
		CCA07RXML(cFunXml,cDescXml,aMsgCab)	 
	EndIf
ENDIF

Return	
/*------------------------------------------------------------------------
*
* CCA07SEND()
* Faz a transmissão da Nota para a prefeitura.
*
------------------------------------------------------------------------*/
Static function CCA07SEND(_cSerie, _cNota)
Local cNotasOk	:=""
Local cCodMun	:=""
Local cParTrans	:=""
Local aPerg		:={}
Local aParam2	:={}

//Variaveis 'padrao'
Private MV_PAR01:=""
Private MV_PAR02:=""
Private MV_PAR03:=""
Private MV_PAR05:=""
Private MV_PAR06:=""
Private MV_PAR07:=""
Private MV_PAR08:=""

Private cEntSai	:="1"
Private cIdEnt	:=""
Private cURL  	:=""

cParTrans	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022Rem"
aParam2	:= {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),"",1,Date(),Date(),""}

//Variaveis 'padrao'
MV_PAR01:= 	aParam2[01] := PadR(ParamLoad(cParTrans,aPerg,1,aParam2[01]),Len(SF2->F2_SERIE))
MV_PAR02:=	aParam2[02] := PadR(ParamLoad(cParTrans,aPerg,2,aParam2[02]),Len(SF2->F2_DOC))
MV_PAR03:=	aParam2[03] := PadR(ParamLoad(cParTrans,aPerg,3,aParam2[03]),Len(SF2->F2_DOC))
MV_PAR05:=	""
MV_PAR06:= 	Date()
MV_PAR07:= 	Date()
MV_PAR08:= 	aParam2[08] := PadR(ParamLoad(cParTrans,aPerg,8,aParam2[08]),100)

//Nota a ser transmistida
MV_PAR01 := _cSerie
MV_PAR02 := cNotaInc
MV_PAR03 := cNotaInc

cEntSai	:="1"
cIdEnt	:=StaticCall(FISA022,GetIdEnt)
cURL   	:=PadR(GetNewPar("MV_SPEDURL","http://"),250)

If Empty(cIdEnt)
	Return(.F.)
EndIf

cCodMun	:=Alltrim(SM0->M0_CODMUN)
Fisa022Trs(cCodMun,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,"SF2",@cNotasOk,Space(10),1,'',MV_PAR06,MV_PAR07,.T.,,'')

Return(.T.)


/*------------------------------------------------------------------------
*
* CEAI07WF()
* Envia WF de inclusao da Nota
*
------------------------------------------------------------------------*/
Static function CEAI07WF(cNotaInc,lRet)
             
Local cTo:=GetMv("MV_XMSGSOC",,"") 
Local cSit:=Iif(lRet,'Transmitida','Não transmitida')

oProcess:= TWFProcess():New( "NFISCAL", "Inclusao de Nota Fiscal" )
oProcess:NewTask( "Inclusao de Nota Fiscal", "\WORKFLOW\Notific_NF.HTM" )
oProcess:cSubject:= "Nota Fiscal incluída."
oProcess:cTo      	:= cTo
//oProcess:UserSiga	:= cCodUsr
oProcess:NewVersion(.T.)
oProcess:bReturn	:= NIL
oProcess:cBody  	:= OemToAnsi("Nota Fiscal incluída!") +CRLF
oProcess:cBody 		+= OemToAnsi("Esta é uma mensagem automática. Por favor, não responda.")
oHtml     			:= oProcess:oHTML

AAdd( (oHtml:ValByName( "t.1"    ))	, cNotaInc)
AAdd( (oHtml:ValByName( "t.2"    ))	, cSit)
AAdd( (oHtml:ValByName( "t.3"    ))	, '')

oProcess:Start()

Return 
/*------------------------------------------------------------------------
*
* CCA07RXML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA07RXML(cFunXml,cDescXml,aMsgCab)
local cData	:= Dtos(Date())
local cHora	:= Time()   
local nCnt	:= 0
local cXml	:= ""                         

cXml+= '<TOTVSIntegrator>'+CRLF
cXml+= '	<DATA>'+cData+'</DATA>'+CRLF
cXml+= '	<HORA>'+cHora+'</HORA>'+CRLF
cXml+= '	<ID>'+aMsgCab[1]+'</ID>'+CRLF
cXml+= '	<RETORNO>'+aMsgCab[2]+'</RETORNO>'+CRLF
cXml+= '	<MOTIVO>'+aMsgCab[3]+'</MOTIVO>'+CRLF
cXml+= '	<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'+CRLF
cXml+= '	<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>'+CRLF
cXml+= '</TOTVSIntegrator>'+CRLF

// Envia xml para funcão de retorno
u_CESBENV(cFunXml,cDescXml,cXml)

RETURN
/*------------------------------------------------------------------------
*
* CCA07VAL()
* Transforma em numerico a string.
*
------------------------------------------------------------------------*/
Static Function CCA07VAL(cVal,nInt,nDec)
cVal:=Substr(cVal,1,nInt)+'.'+Substr(cVal,nInt+1,nDec)
Return(Val(cVal))
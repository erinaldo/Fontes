#INCLUDE "rwMake.ch"                                          

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ BOLITAU   ≥ Autor ≥                     ≥ Data ≥ 25/06/2015 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO BANCARIO COM CODIGO DE BARRAS          ≥±±                       
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function BOLITAU()

Local	aPergs     := {}
Private lExec      := .F.
Private cIndexName := ''
Private cIndexKey  := ''
Private cFilter    := ''

Tamanho            := "M"
titulo             := "Impressao de Boleto com Codigo de Barras"
cDesc1             := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2             := ""
cDesc3             := ""
cString            := "SE1"
wnrel              := "BOLITAU"
cPerg              := "FINR03BSL"
aReturn            := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey           := 00     													
lEnd               := .F.

dbSelectArea("SE1")

ValidPerg()
If Pergunte(cPerg,.T.)
/*
Wnrel := SetPrint( cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,, )

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif
*/

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR11 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR10 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
cFilter		+= "!(E1_TIPO$MVABATIM).And."
cFilter		+= "E1_PORTADO=='" + MV_PAR19 + "'.And."
cFilter		+= "E1_PORTADO<>'   '"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
dbSelectArea("SE1")
dbGoTop()

@ 001,001 TO 400,700 DIALOG oDlg TITLE "SeleÁ„o de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
//MARKBROWSER ("SE1","E1_OK",,,.F.,GetMark,("SE1","E1_OK"))
@ 180,310 BMPBUTTON TYPE 01 ACTION( lExec := .T.,Close( oDlg ) )
@ 180,280 BMPBUTTON TYPE 02 ACTION( lExec := .F.,Close( oDlg ) )

ACTIVATE DIALOG oDlg CENTERED

dbGoTop()
If lExec
	Processa({|lEnd| U_RFINR062()})
Endif

RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

EndIF

Return Nil

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ RFINR062 ≥ Autor ≥ Cadubitski            ≥ Data ≥ 29/11/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DE BOLETO LASER                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

//Desta forma posso chamar direto da nota por exemplo, passando os parametros
User Function RFINR062(xBanco,xAgencia,xConta,xSubCt,lSetup,cNotIni,cNotFim,cSerie)

Local oPrint
Local nX := 0
Local cNroDoc 	   :=  " "
Local aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)						  										,;	//	[1]	Nome da Empresa
SM0->M0_ENDCOB																,;	//	[2]	EndereÁo
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB	,;	//	[3]	Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)				,;	//	[4]	CEP
"PABX/FAX: "+SM0->M0_TEL													,;	//	[5]	Telefones
"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+				 ;	//	[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+					 	 ;	//	[6]
Subs(SM0->M0_CGC,13,2)														,;	//	[6]	CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+			 ;	//	[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)							 }	//	[7]	I.E
Local aDadosTit
Local aDadosBanco
Local aDatSacado

Local aBolText := {;
"*** VALORES EXPRESSOS EM REAIS ***", ;
"ApÛs o vencimento mora ao dia R$ ", ;
"CobranÁa escritural.", ;
"CrÈdito dado em garantia ao Banco Ita˙ S.A., pagar somente em banco.", ;
"IntruÁıes de responsabilidade do " + Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio") + ". Qualquer d˙vida sobre este boleto contate o " + Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio") + "." ;
}

/*
Local aBolText     := { "*** VALORES EXPRESSOS EM REAIS *** " ,; //[1] TEXTO 1
"ApÛs o vencimento mora ao dia R$ "                           }  //[2] TEXTO 2
*/

Local nI           := 1
Local aCB_RN_NN    := {}
Local nVlrAbat	   := 0
Local xSetup       := iif(lSetup==nil,.f.,lSetup)
//Local nDvnn 	   := 0                          
Local cParcel     := ""

Private cBanco    := ""
Private cAgencia  := ""
Private cConta    := ""
Private cSubCt    := ""
Private cContra   := ""
Private cCartBras := ""
Private aCabec    := {}

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova p·gina

If xSetup
	
	cIndexName := ''
	cIndexKey  := ''
	cFilter    := ''
	
	Tamanho            := "M"
	titulo             := "Impressao de Boleto com Codigo de Barras"
	cDesc1             := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	cDesc2             := ""
	cDesc3             := ""
	cString            := "SE1"
	//wnrel              := "RFINR03"
	//cPerg              := "FINR03    "
	wnrel              := "BOLITAU"
    cPerg              := "FINR03BSL"
	aReturn            := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey           := 00
	lEnd               := .F.
	
	Wnrel := SetPrint( cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,, )
	
	SetDefault(aReturn,cString)
	
	cIndexName	:= Criatrab(Nil,.F.)
	//cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
	cIndexKey	:= "E1_PREFIXO+E1_NUM"
	cFilter		+= "E1_FILIAL =='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
	cFilter		+= "E1_PREFIXO =='" + cSerie + "'.And."
	cFilter		+= "E1_NUM>='" + cNotIni + "'.And.E1_NUM<='" + cNotFim + "'.And."
	cFilter		+= "!(E1_TIPO$MVABATIM) .and."
	cFilter		+= "!(E1_TIPO$'FIC/FID')"
	
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	dbSelectArea("SE1")
EndIf

dbGoTop()

ProcRegua(RecCount())

While !EOF()
	
	/*
	cBanco   := iif(xBanco	==nil,SEA->EA_PORTADOR,xBanco)
	cAgencia := iif(xAgencia	==nil,SEA->EA_AGEDEP,xAgencia)
	cConta   := iif(xConta	==nil,SEA->EA_NUMCON,xConta)
	cSubct   := iif(xSubCt	==nil,MV_PAR20,xSubCt)
	*/
	cBanco   := SE1->E1_PORTADO
	cAgencia := SE1->E1_AGEDEP
	cConta   := SE1->E1_CONTA
	cSubct   := iif(xSubCt	==nil,MV_PAR20,xSubCt)
	
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Posiciona o SA6 (Bancos)    ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	DbSelectArea("SA6")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta)
		Aviso(OemToAnsi("ATEN«√O"),OemToAnsi("Banco n„o localizado"),{"OK"})
		DbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Posiciona na Arq de Parametros CNAB   ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	DbSelectArea("SEE")
	DbSetOrder(1)
	If !DbSeek(xFilial("SEE")+cBanco+cAgencia+cConta)
		Aviso(OemToAnsi("ATEN«√O"),OemToAnsi("N„o localizado banco no cadastro de par‚metros para envio"),{"OK"})
		DbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf

/*Especifco Descarpack	
	If !Empty(SEE->EE_CONVENI)
		cContra   := ALLTRIM(SEE->EE_CONVENI) //Numero de Contrato do Cliente junto ao Banco
	EndIf
	If !Empty(SEE->EE_YCART)
		cCartBras := ALLTRIM(SEE->EE_YCART) //Carteira do Cliente junto ao Banco
	EndIf
*/	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Posiciona o SA1 (Cliente)             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")
	
	aDadosBanco  := {SEE->EE_CODIGO  										    ,;	//	[1]	Numero do Banco
	SUBSTR(SA6->A6_NOME,1,14)									,;	//	[2]	Nome do Banco
	SUBSTR(SEE->EE_AGENCIA, 1, 4)								,;	//	[3]	AgÍncia
	SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)	,;	//	[4]	Conta Corrente
	SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)	  	,;	//	[5]	DÌgito da conta corrente
	SUBSTR(SEE->EE_SUBCTA,1,3)									,;  //	[6]	Codigo da Carteira
	SUBSTR(SEE->EE_AGENCIA,5,1)                                 }   //	[7]	Digito da Agencia
	
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)				,;	//	[1]	Raz„o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA				,;	//	[2]	CÛdigo
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;	//	[3]	EndereÁo
		AllTrim(SA1->A1_MUN )								,;	//	[4]	Cidade
		SA1->A1_EST											,;	//	[5]	Estado
		SA1->A1_CEP											,;	//	[6]	CEP
		SA1->A1_CGC											,;	//	[7]	CGC
		SA1->A1_PESSOA										}	//	[8]	PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)				,;	//	[1]	Raz„o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA				,;	//	[2]	CÛdigo
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;	//	[3]	EndereÁo
		AllTrim(SA1->A1_MUNC)										,;	//	[4]	Cidade
		SA1->A1_ESTC										,;	//	[5]	Estado
		SA1->A1_CEPC										,;	//	[6]	CEP
		SA1->A1_CGC											,;	//	[7]	CGC
		SA1->A1_PESSOA										}	//	[8]	PESSOA
	Endif
	
	nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	cParcel  := If(Empty(SE1->E1_PARCELA),"00",SE1->E1_PARCELA)
	
	
	If !Empty(SE1->E1_NUMBCO)
	   If SE1->E1_PORTADOR == "033"           
			cNroDoc	:= SUBSTR(SE1->E1_NUMBCO,1,5)  + cParcel
			cNumBco := SUBSTR(SE1->E1_NUMBCO,1,5)  + cParcel
        EndIf
	Else
		If SE1->E1_PORTADOR == "399"
			cNroDoc	:= STRZERO(VAL(SE1->E1_NUM),9) + STRZERO(VAL(cParcel),2)
			cNumBco := STRZERO(VAL(SE1->E1_NUM),9) + STRZERO(VAL(cParcel),2)
		ElseIf SE1->E1_PORTADOR == "001"
			cNroDoc	:= STRZERO(VAL(SE1->E1_NUM),8) 
			cNumBco := STRZERO(VAL(SE1->E1_NUM),8) 
		ElseIf SE1->E1_PORTADOR == "033"           
			cNroDoc	:= STRZERO(VAL(SUBSTR(SE1->E1_NUM,2,5)),5) + cParcel
			cNumBco := STRZERO(VAL(SUBSTR(SE1->E1_NUM,2,5)),5) + cParcel
		EndIf                               
		cNroDoc	:= alltrim(SE1->E1_NUM) + alltrim(cParcel)
		cNumBco := alltrim(SE1->E1_NUM) + alltrim(cParcel)
	EndIf
	
	//Monta codigo de barras
	aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9"    	,; //Banco
	Subs(aDadosBanco[3],1,4)				,;//Agencia
	aDadosBanco[4]						,;//Conta
	aDadosBanco[5]						,;//Digito da Conta
	aDadosBanco[6]						,;//Carteira
	AllTrim(SE1->E1_NUM)+AllTrim(cParcel)	,;//Documento
	(SE1->E1_SALDO - nVlrAbat)			,;//Valor do Titulo
	SE1->E1_VENCREA						,;//Vencimento
	SEE->EE_CODEMP						,;//Convenio
	cNroDoc  							,;//Sequencial
	Iif(SE1->E1_DECRESC > 0,.t.,.f.)    ,;//Se tem desconto
	cParcel								,;//Parcela
	aDadosBanco[3]  					,;//Agencia Completa  
	cContra                             ,;//Numero Contrato 
	cCartBras                           ,;
	SUBSTR(SEE->EE_CONTA,3,7)            ) //Numero da Carteira

/*	SE1->E1_VENCTO						,;  Vencimento  - ZEMA 08/05/14 - MIT006 - ITEM 138 - Solicitado pela Adriana para considerar o vencimento real*/
	
	
	aDadosTit := {AllTrim(SE1->E1_NUM)+AllTrim(cParcel)	,;  //	[1]	N˙mero do tÌtulo
	SE1->E1_EMISSAO						,;  //	[2]	Data da emiss„o do tÌtulo
	dDataBase						,;  //	[3]	Data da emiss„o do boleto
	SE1->E1_VENCREA						,;  //	[4]	Data do vencimento
	(SE1->E1_SALDO - nVlrAbat)			,;  //	[5]	Valor do tÌtulo
	aCB_RN_NN[3]					,;  //	[6]	Nosso n˙mero (Ver fÛrmula para calculo)
	SE1->E1_PREFIXO						,;  //	[7]	Prefixo da NF
	SE1->E1_TIPO							,;  //	[8]	Tipo do Titulo
	SE1->E1_DESCFIN                      }   //  [9] Percentual de Desconto

//	SE1->E1_VENCTO						,;  //	[4]	Data do vencimento - ZEMA 08/05/14 - MIT006 - ITEM 138 - Solicitado pela Adriana para considerar o vencimento real
	
	If xBanco == nil
		If Marked("E1_OK")
			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
			nX := nX + 1
		EndIf
	Else
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		nX := nX + 1
	EndIf
	
	DbSelectArea("SE1")
	dbSkip()
	IncProc()
	nI := nI + 1
	
EndDo

oPrint:EndPage()     // Finaliza a p·gina
oPrint:SETUP()
oPrint:Preview()// Visualiza antes de imprimir



Return nil

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥  Impress ≥ Autor ≥ Cadubitski            ≥ Data ≥ 29/11/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASER                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)

Local nLinha := 0
Local lLin1 := GetNewPar("AB_BOLTXT1", .T.)
Local lLin2 := GetNewPar("AB_BOLTXT2", .T.)
Local lLin3 := GetNewPar("AB_BOLTXT3", .T.)
Local lLin4 := GetNewPar("AB_BOLTXT4", .T.)
Local lLin5 := GetNewPar("AB_BOLTXT5", .T.)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont11                            
LOCAL oFont10
LOCAL oFont13
LOCAL oFont16n
LOCAL oFont16 
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI        := 0
LOCAL aLogo     := "logohsbc.bmp"
LOCAL aLogore   := "logoreal.bmp"
Local aLogosa   := "logosant.bmp"
Local aLogobr   := "logobra.bmp"
//Local alogobrs  := "logobrs.bmp"
Local alogoitau  := "logoitau.bmp"
//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16  := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova p·gina

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 0

oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

If aDadosBanco[1] == "001"
//	oPrint:SayBitmap(nRow1+0039,100,aLogoBrs,600,600 )			// Logotipo Banco do Brasil
	oPrint:Say (nRow1+0080,100,"BANCO DO BRASIL",oFont11 )			// Logotipo Banco do Brasil
Elseif aDadosBanco[1] == "399"
	oPrint:SayBitmap(nRow1+0039,100,aLogo,370,100 )			// Logotipo HSBC
Elseif aDadosBanco[1] == "356"
	//	oPrint:SayBitmap(nRow1+0039,100,aLogore,380,110 )		// 	Logotipo Banco Real --Funcionando
	oPrint:SayBitmap(nRow1+0039,100,aLogore,190,110 )      // Logotipo Banco Real
//	oPrint:SayBitmap(nRow1+0057,300,aLogosa,185,077 )         // Logotipo Banco Santander
Elseif aDadosBanco[1] == "033"
	oPrint:SayBitmap(nRow1+0039,100,alogosa,370,100 )         // Logotipo Banco Santander
//	oPrint:Say (nRow1+0080,100,"BANCO SANTANDER",oFont11 )
ElseIf aDadosBanco[1] == "237"
	oPrint:SayBitmap(nRow1+0039,100,aLogobr, 310, 107 )         // Logotipo Banco Bradesco
ElseIf aDadosBanco[1] == "341"
	oPrint:SayBitmap(nRow1+0039,100,aLogoitau, 310, 107 )         // Logotipo Banco Itau
Else
	oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont13 )			// [2]Nome do Banco
EndIf

If aDadosBanco[1] == "341"
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
ElseIf aDadosBanco[1] == "409"
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-0",oFont21 )		// [1]Numero do Banco
ElseIf aDadosBanco[1] == "237"
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "356"
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-5",oFont21 )		// [1]Numero do Banco
ElseIf aDadosBanco[1] == "033"
	 oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-?",oFont21 )		// [1]Numero do Banco
Else
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-9",oFont21 )		// [1]Numero do Banco
Endif

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0150,100 , Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio"),oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1] + " - " + aDadosEmp[4],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"AgÍncia/CÛdigo " + Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio") + "",oFont8)
If aDadosBanco[1] == "399"
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
Elseif aDadosBanco[1] == "356"
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4])
Elseif aDadosBanco[1] == "033"
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+aDadosBanco[5]) // alterado por wellington mendes em 26-05-11
	//	oPrint:Say  (nRow1+0200,1060,"4611/13000501-0",oFont10)    // unica conta utilizada para o santander.
ElseIf aDadosBanco[1] == "001"
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
Else
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
endif
oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0250,100 ,Iif(AllTrim(GetNewPar("AB_SACPAG", "S")) == "S", "Sacador", "Pagador"),oFont8)
oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)				//Nome

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/tÌtulo"	,oFont10 )
oPrint:Say  (nRow1+0450,0100,"com as caracterÌsticas acima."	,oFont10 )
oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 )
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 )
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
oPrint:Say  ( nRow1+0245,1910,"(  )N„o existe n∫ indicado"		,oFont8 )
oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
oPrint:Say  ( nRow1+0325,1910,"(  )N„o procurado"				,oFont8 )
oPrint:Say  ( nRow1+0365,1910,"(  )EndereÁo insuficiente"		,oFont8 )
oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )


/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 130

//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI

oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

If aDadosBanco[1] == "001"
//	oPrint:SayBitmap(nRow2+0604,100,aLogoBrs,600,600 )		// Logotipo Banco do Brasil
	oPrint:Say (nRow2+0645,100,"BANCO DO BRASIL",oFont11 )		
Elseif aDadosBanco[1] == "399"
	oPrint:SayBitmap(nRow2+0604,100,aLogo,370,100 )	    	// Logotipo HSBC
Elseif aDadosBanco[1] == "356"
	oPrint:SayBitmap(nRow2+0594,100,aLogore,190,110 )		// Logotipo Banco Real
Elseif aDadosBanco[1] == "033"
	oPrint:SayBitmap(nRow2+0594,100,alogosa,370,100 )      // Logotipo Banco Santander
//	oPrint:Say (nRow2+0645,100,"BANCO SANTANDER",oFont11 )
ElseIf aDadosBanco[1] == "237"
	oPrint:SayBitmap(nRow2+0594,100,aLogobr, 310, 107 )         // Logotipo Banco Bradesco
ElseIf aDadosBanco[1] == "341"
	oPrint:SayBitmap(nRow2+0594,100,aLogoitau, 310, 107 )         // Logotipo Banco Itau
Else
	oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont13 )		// [2]Nome do Banco
EndIf

If aDadosBanco[1] == "341"
   oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
ElseIf aDadosBanco[1] == "409"
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-0",oFont21 )	// [1]Numero do Banco
ElseIf aDadosBanco[1] == "237"
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "356"
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-5",oFont21 )	// [1]Numero do Banco
ElseIf aDadosBanco[1] == "033"
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco                // INCLUIDO DIGITO POR WELLINGTON MENDES EM 26-05-11
Else
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-9",oFont21 )	// [1]Numero do Banco
EndIf

oPrint:Say  (nRow2+0644,1800,"Recibo do " + Iif(AllTrim(GetNewPar("AB_SACPAG", "S")) == "S", "Sacador", "Pagador") + "",oFont10)

oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
If aDadosBanco[1] == "399"
	oPrint:Say  (nRow2+0725,400 ,"Pagavel em Qualquer Banco atÈ o Data de Vencimento",oFont10)
Elseif aDadosBanco[1] == "341"
	oPrint:Say  (nRow2+0725,400 ,"AtÈ o vencimento pague preferencialmente no Ita˙",oFont10)
	oPrint:Say  (nRow2+0760,400 ,"ApÛs o vencimento pague somente no Ita˙",oFont10)
Elseif aDadosBanco[1] == "237"
	oPrint:Say  (nRow2+0725,400 ,"Pag·vel preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10)
Else
	oPrint:Say  (nRow2+0725,400 ,"PagavÈl em qualquer Banco atÈ o vencimento",oFont10)
Endif
oPrint:Say  (nRow2+0765,400 ," ",oFont10)

oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio"),oFont8)
oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1] + " - " + aDadosEmp[4]+"                  - "+aDadosEmp[6],oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0810,1810,"AgÍncia/CÛdigo " + Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio") + "",oFont8)
If aDadosBanco[1] == "399"
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
Elseif aDadosBanco[1] == "356"
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"/"+aDadosTit[5])    //Digitao faltando
Elseif aDadosBanco[1] == "033"
	cString := Alltrim(aDadosBanco[3]+" / "+aDadosBanco[4]+aDadosBanco[5])    //Digitao faltando
	//cString := Alltrim("4611/13000501-0")      // alterado por wellington mendes
ElseIf aDadosBanco[1] == "001" 
	cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
Else
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
Endif
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0910,100 ,"Data do Documento",oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0910,505 ,"Nro.Documento",oFont8)
oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0910,1005,"EspÈcie Doc.",oFont8)
If aDadosBanco[1] == "399"
	oPrint:Say  (nRow2+0940,1050,"PD",oFont10) //Tipo do Titulo
Elseif aDadosBanco[1] == "341"
	oPrint:Say  (nRow2+0940,1050,AllTrim(GetNewPar("AB_ESPITAU", "DM")),oFont10) //Tipo do Titulo
Elseif aDadosBanco[1] == "356"
	oPrint:Say  (nRow2+0940,1050,"RC",oFont10) //Tipo do Titulo
Elseif aDadosBanco[1] == "033"
	oPrint:Say  (nRow2+0940,1050,"DM",oFont10) //Tipo do Titulo
Elseif aDadosBanco[1] == "237"
	oPrint:Say (nRow2+0940,1050,"DM",oFont10) //Tipo do Titulo
Else
	oPrint:Say  (nRow2+0940,1050,aDadosTit[8],oFont10) //Tipo do Titulo
endif

oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
If aDadosBanco[1] == "356"
	oPrint:Say  (nRow2+0940,1400,"A",oFont10)
ElseIf aDadosBanco[1] == "033"
	oPrint:Say  (nRow2+0940,1400,"N",oFont10)
Else
	oPrint:Say  (nRow2+0940,1400,"N",oFont10)
endif

oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0910,1810,"Nosso N˙mero",oFont8)
If aDadosBanco[1] == "409"
	cString := aDadosTit[6]
Elseif aDadosBanco[1] == "399"
	cString := Alltrim(substr(aDadosTit[6],1,11))
ElseIF aDadosBanco[1] == "341"
	cString := AllTrim(GetNewPar("AB_CARITAU", "109"))+"/"+(substr(aDadosTit[6],1,8)) + "-" + (substr(aDadosTit[6],9,1))
ElseIF aDadosBanco[1] == "033"
	cString := Alltrim(substr(aDadosTit[6],1,9))
ElseIf aDadosBanco[1] == "237"
	cString := Alltrim(substr(aDadosTit[6],1,2)) +"/"+ Alltrim(substr(aDadosTit[6],3,11)) + "-" + (substr(aDadosTit[6],14,1))
ElseIf aDadosBanco[1] == "001" 
	cString := Alltrim(substr(aDadosTit[6],1,16)) +"-"+ Alltrim(substr(aDadosTit[6],17,1))
Else
	cString := Alltrim(substr(aDadosTit[6],1,7))
	//cString := Alltrim(Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],7))
EndIf                   
If aDadosBanco[1] == "001"
	nCol := 1865+(374-(len(cString)*22))
Else
	nCol := 1810+(374-(len(cString)*22))
EndIf
oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)
                           
If aDadosBanco[1] <> "033" 
	oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)
EndIf

If aDadosBanco[1] <> "033" 
	oPrint:Say  (nRow2+0980,555 ,"Carteira",oFont8)  
Else
	oPrint:Say  (nRow2+0980,100 ,"Carteira",oFont8)  
EndIf

If aDadosBanco[1] == "399"
	oPrint:Say  (nRow2+1010,555 ,"CSB",oFont10)
Elseif aDadosBanco[1] == "341"
	//oPrint:Say  (nRow2+1010,555 ,'',oFont10)
	oPrint:Say  (nRow2+1010,555 , AllTrim(GetNewPar("AB_CARITAU", "")),oFont10)
Elseif aDadosBanco[1] == "356"
	oPrint:Say  (nRow2+1010,555 ,"20",oFont10)
Elseif aDadosBanco[1] == "033"
	oPrint:Say  (nRow2+1010,100 ,"101 - Rapido Com Registro",oFont10)
Elseif aDadosBanco[1] == "237"
	oPrint:Say  (nRow2+1010,555 , AllTrim(GetNewPar("AB_CARTBRA", "09")) ,ofont10)
Elseif aDadosBanco[1] == "001"
	oPrint:Say  (nRow2+1010,555 , "17-019" ,ofont10)
Else
	oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6],oFont10)
endif

oPrint:Say  (nRow2+0980,755 ,"EspÈcie",oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$",oFont10)

oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1050,100 ,"InstruÁıes (Todas informaÁıes deste bloqueto s„o de exclusiva responsabilidade do " + Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio") + ")",oFont8)

nLinha := nRow2 + 1100
If (lLin1) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[1], oFont10)
Endif

If (lLin2) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[2] + AllTrim(Transform(SE1->E1_VALOR * GETNEWPAR("AB_MORA",0.00,xFilial("SX6")),"@E 9,999.99")), oFont10)
Endif

If (lLin3) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[3], oFont10)
Endif

If (lLin4) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[4], oFont10)
Endif

If (lLin5) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[5], oFont10)
Endif

/*
oPrint:Say  (nRow2+1150,100 ,aBolText[1],oFont10)
oPrint:Say  (nRow2+1200,100 ,aBolText[2] + AllTrim(Transform(SE1->E1_VALOR * GETNEWPAR("AB_MORA",0.00,xFilial("SX6")),"@E 9,999.99")),oFont10) 
*/

//oPrint:Say  (nRow2+1200,100 ,aBolText[2] + AllTrim(Transform(SE1->E1_VALOR * GETNEWPAR("AB_MORA",0.00,xFilial("SX6"))/30,"@E 9,999.99")),oFont10) 
//Foi removido da linha a divis„o por 30 do valor do titulo * parametros AB_MORA 12/02/2014 - Analista Ronaldo Bicudo
//oPrint:Say  (nRow2+1250,100 ,aBolText[3],oFont10)
//oPrint:Say  (nRow2+1300,100 ,aBolText[4],oFont10)
//oPrint:Say  (nRow2+1250,530 ,aBolText[5]+" "+StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4) ,oFont10)
//oPrint:Say  (nRow3+1250,100 ,aBolText[3]+" "+AllTrim(Transform((aDadosTit[5]*(_nDesc/100),"@E 99,999.99"))
//oPrint:Say  (nRow2+1300,100 ,aBolText[6],oFont10)

oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
oPrint:Say  (nRow2+1120,1810,"(-)Outras DeduÁıes"    ,oFont8)
oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"         ,oFont8)
oPrint:Say  (nRow2+1260,1810,"(+)Outros AcrÈscimos"  ,oFont8)
oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

oPrint:Say  (nRow2+1400,100 ,Iif(AllTrim(GetNewPar("AB_SACPAG", "S")) == "S", "Sacador", "Pagador"),oFont8)
oPrint:Say  (nRow2+1430,400 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
oPrint:Say  (nRow2+1483,400 ,aDatSacado[3],oFont10)
oPrint:Say  (nRow2+1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1589,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1589,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

If aDadosBanco[1] == "409"
	oPrint:Say  (nRow2+1589,1850,aDadosTit[6],oFont10)
ElseIf aDadosBanco[1] == "399"
	oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,11),oFont10)
Else
	oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,9),oFont10)
	//oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],4)  ,oFont10)
EndIf

oPrint:Say  (nRow2+1605,100 ,"" + Iif(AllTrim(GetNewPar("AB_SACPAG", "S")) == "S", "Sacador", "Pagador") + "/Avalista",oFont8)
oPrint:Say  (nRow2+1645,1500,"AutenticaÁ„o Mec‚nica",oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 130

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

If aDadosBanco[1] == "001"
//	oPrint:SayBitmap(nRow3+1894,100,aLogoBrs,600,600 )		// 	Logotipo Banco do Brasil
	oPrint:Say (nRow2+1935,100,"BANCO DO BRASIL",oFont11 )
Elseif aDadosBanco[1] == "399"
	oPrint:SayBitmap(nRow2+1894,100,aLogo,370,100 ) 		// 	Logotipo HSBC
Elseif aDadosBanco[1] == "356"
	oPrint:SayBitmap(nRow2+1884,100,aLogore,190,110 )			// Logotipo Banco Real
//	oPrint:SayBitmap(nRow2+1907,300,aLogosa,185,077 )      // Logotipo Banco Santander
Elseif aDadosBanco[1] == "033"
	oPrint:SayBitmap(nRow2+1884,100,aLogosa,370,100 )      // Logotipo Banco Santander
//	oPrint:Say (nRow2+1935,100,"BANCO DO SANTANDER",oFont11 )
ElseIf aDadosBanco[1] == "237"
	oPrint:SayBitmap(nRow2+1884,100,aLogobr, 310, 107 )         // Logotipo Banco Bradesco
ElseIf aDadosBanco[1] == "341"
	oPrint:SayBitmap(nRow2+1884,100,aLogoitau, 310, 107 )         // Logotipo Banco Itau
Else
	oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont13 )		// 	[2]Nome do Banco
EndIf

If aDadosBanco[1] == "341"
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "409"
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-0",oFont21 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "237"
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "356"
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-5",oFont21 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "033"
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco                // INCLUIDO DIGITO POR WELLINGTON MENDES EM 26-05-11
Else
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-9",oFont21 )	// 	[1]Numero do Banco
EndIf


oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
If aDadosBanco[1] == "399"
	oPrint:Say  (nRow3+2015,400 ,"Pagavel em Qualquer Banco atÈ Data de Vencimento",oFont10)
Elseif aDadosBanco[1] == "341"
	oPrint:Say  (nRow3+2015,400 ,"AtÈ o vencimento pague preferencialmente no Ita˙",oFont10)
	oPrint:Say  (nRow3+2050,400 ,"ApÛs o vencimento pague somente no Ita˙",oFont10)
ElseIf aDadosBanco[1] == "237"
	oPrint:Say  (nRow3+2015,400 ,"Pag·vel preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10)
Else
	oPrint:Say  (nRow3+2015,400 ,"PagavÈl em qualquer Banco atÈ o vencimento",oFont10)
Endif
oPrint:Say  (nRow3+2055,400 ," ",oFont10)

oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio"),oFont8)
oPrint:Say  (nRow3+2130,100 ,aDadosEmp[1] + "                  - "+aDadosEmp[6]	,oFont8) //Nome + CNPJ
oPrint:Say  (nRow3+2170,100 ,AllTrim(aDadosEmp[2]) + " - " + AllTrim(aDadosEmp[3]) + " - " + AllTrim(aDadosEmp[4]),oFont8) //Nome + CNPJ

oPrint:Say  (nRow3+2100,1810,"AgÍncia/CÛdigo " + Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio") + "",oFont8)
If aDadosBanco[1] == "399"
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
Elseif aDadosBanco[1] == "356"
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"/"+Substr(aDadosTit[6],8,1))       //Digitao faltando
Elseif aDadosBanco[1] == "033"
	cString := Alltrim(aDadosBanco[3]+" / "+aDadosBanco[4]+aDadosBanco[5])       //Digitao faltando
//	cString := Alltrim("4611/13000501-0")      // alterado por wellington mendes
Else
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
Endif
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+2200,100 ,"Data do Documento",oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+2200,505 ,"Nro.Documento",oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"EspÈcie Doc.",oFont8)
If aDadosBanco[1] == "399"
	oPrint:Say  (nRow3+2230,1050,"PD",oFont10) //Tipo do Titulo
Elseif aDadosBanco[1] == "341"
	oPrint:Say  (nRow3+2230,1050,AllTrim(GetNewPar("AB_ESPITAU", "DM")),oFont10) //Tipo do Titulo
ElseIf aDadosBanco[1] == "356"
	oPrint:Say  (nRow3+2230,1050,"RC",oFont10) //Tipo do Titulo
ElseIf aDadosBanco[1] == "033"
	oPrint:Say  (nRow3+2230,1050,"DM",oFont10) //Tipo do Titulo
ElseIf aDadosBanco[1] == "237"
	oPrint:Say  (nRow3+2230,1050,"DM",oFont10) //Tipo do Titulo
Else
	//oPrint:Say  (nRow3+2230,1050,aDadosTit[8],oFont10) //Tipo do Titulo
endif

oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
If aDadosBanco[1] == "356"
	oPrint:Say  (nRow3+2230,1400,"A",oFont10)
ElseIf aDadosBanco[1] == "033"
	oPrint:Say  (nRow3+2230,1400,"N",oFont10)
Else
	oPrint:Say  (nRow3+2230,1400,"N",oFont10)
endif

oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+2200,1810,"Nosso N˙mero",oFont8)

If aDadosBanco[1] == "409"
	cString := aDadosTit[6]
Elseif aDadosBanco[1] == "399"
	cString := Alltrim(Substr(aDadosTit[6],1,11))
Elseif aDadosBanco[1] == "341"
	cString := AllTrim(GetNewPar("AB_CARITAU", "109"))+"/"+(substr(aDadosTit[6],1,8)) + "-" + (substr(aDadosTit[6],9,1))
ElseIf aDadosBanco[1] == "033"
	cString := Alltrim(Substr(aDadosTit[6],1,9))
ElseIf aDadosBanco[1] == "237"
	cString := Alltrim(substr(aDadosTit[6],1,2)) +"/"+ Alltrim(substr(aDadosTit[6],3,11)) + "-" + (substr(aDadosTit[6],14,1))
ElseIf aDadosBanco[1] == "001"
	cString := Alltrim(substr(aDadosTit[6],1,16)) +"-"+ Alltrim(substr(aDadosTit[6],17,1))
Else
	cString := Alltrim(Substr(aDadosTit[6],1,7))
	//	cString := Alltrim(Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],7))
EndIf
                   
If aDadosBanco[1] == "001"
	nCol := 1865+(374-(len(cString)*22))
Else
	nCol := 1810+(374-(len(cString)*22))
EndIf

oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)


If aDadosBanco[1] <> "033" 
	oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)
EndIf

If aDadosBanco[1] <> "033" 
	oPrint:Say  (nRow3+2270,555 ,"Carteira",oFont8)  
Else
	oPrint:Say  (nRow3+2270,100 ,"Carteira",oFont8)  
EndIf

If aDadosBanco[1] == "399"
	oPrint:Say  (nRow3+2300,555 ,"CSB" ,oFont10)
Elseif aDadosBanco[1] == "341"
	oPrint:Say  (nRow3+2300,555, AllTrim(GetNewPar("AB_CARITAU", "")),oFont10)
Elseif aDadosBanco[1] == "356"
	oPrint:Say  (nRow3+2300,555, "20",oFont10)
Elseif aDadosBanco[1] == "033"
	oPrint:Say  (nRow3+2300,100,"101 - Rapido Com Registro",oFont10)
Elseif aDadosBanco[1] == "237"
	oPrint:Say  (nRow3+2300,555, AllTrim(GetNewPar("AB_CARTBRA", "09")),oFont10)
Elseif aDadosBanco[1] == "001"
	oPrint:Say  (nRow2+2300,555 , "17-019" ,ofont10)
Else
	oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6],oFont10)
Endif

oPrint:Say  (nRow3+2270,755 ,"EspÈcie",oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow2+2340,100 ,"InstruÁıes (Todas informaÁıes deste bloqueto s„o de exclusiva responsabilidade do " + Iif(AllTrim(GetNewPar("AB_CEDBEN", "C")) == "C", "Cedente", "Benefici·rio") + ")",oFont8)

nLinha := nRow2 + 2390
If (lLin1) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[1], oFont10)
Endif

If (lLin2) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[2] + AllTrim(Transform(SE1->E1_VALOR * GETNEWPAR("AB_MORA",0.00,xFilial("SX6")),"@E 9,999.99")), oFont10)
Endif

If (lLin3) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[3], oFont10)
Endif

If (lLin4) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[4], oFont10)
Endif

If (lLin5) .And. (aDadosBanco[1] == "341")
	nLinha += 50
	oPrint:Say(nLinha, 100, aBolText[5], oFont10)
Endif

/*
oPrint:Say  (nRow2+2440,100 ,aBolText[1],oFont10)
oPrint:Say  (nRow2+2490,100 ,aBolText[2] + AllTrim(Transform(SE1->E1_VALOR * GETNEWPAR("AB_MORA",0.00,xFilial("SX6")),"@E 9,999.99")),oFont10)
*/

//oPrint:Say  (nRow2+2490,100 ,aBolText[2] + AllTrim(Transform(SE1->E1_VALOR * GETNEWPAR("AB_MORA",0.00,xFilial("SX6"))/30,"@E 9,999.99")),oFont10)
//Foi removido da linha a divis„o por 30 do valor do titulo * parametros AB_MORA 12/02/2014 - Analista Ronaldo Bicudo
//oPrint:Say  (nRow2+2540,100 ,aBolText[3],oFont10)
//oPrint:Say  (nRow2+2590,100 ,aBolText[4],oFont10)
//oPrint:Say  (nRow2+2540,530 ,aBolText[5]+" "+StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4) ,oFont10)
//oPrint:Say  (nRow3+1250,100 ,aBolText[3]+" "+AllTrim(Transform((aDadosTit[5]*(_nDesc/100),"@E 99,999.99"))
//oPrint:Say  (nRow2+2590,100 ,aBolText[6],oFont10)

oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Outras DeduÁıes"    ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"         ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros AcrÈscimos"  ,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

oPrint:Say  (nRow3+2690,100 ,Iif(AllTrim(GetNewPar("AB_SACPAG", "S")) == "S", "Sacador", "Pagador"),oFont8)
oPrint:Say  (nRow3+2700,400 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2753,400 ,aDatSacado[3],oFont10)
oPrint:Say  (nRow3+2806,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

If aDadosBanco[1] == "409"
	oPrint:Say  (nRow3+2806,1750,aDadosTit[6] ,oFont10)
ElseIf aDadosBanco[1] == "399"
	oPrint:Say  (nRow3+2806,1750,Substr(aDadosTit[6],1,11) ,oFont10)
Else
	oPrint:Say  (nRow3+2806,1750,Substr(aDadosTit[6],1,9) ,oFont10)
	//	oPrint:Say  (nRow3+2806,1850,Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],4)  ,oFont10)
EndIf

oPrint:Say  (nRow3+2815,100 ,"" + Iif(AllTrim(GetNewPar("AB_SACPAG", "S")) == "S", "Sacador", "Pagador") + "/Avalista",oFont8)
oPrint:Say  (nRow3+2855,1500,"AutenticaÁ„o Mec‚nica - Ficha de CompensaÁ„o",oFont8)


oPrint:Line (nRow3+2000,1800,nRow3+2690,1800)
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300)
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300)
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300)
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300)
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300)
oPrint:Line (nRow3+2850,100 ,nRow3+2850,2300)

//MSBAR("INT25",27.1,0.8,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.1,Nil,Nil,"A",.F.)				// CÛdigo de Barras
If aDadosBanco[1] == "399"
	MSBAR("INT25",26,8.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
ElseIf aDadosBanco[1] == "001"
	//	MSBAR("INT25",26.2,8.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	MSBAR("INT25",26,8.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
ElseIf aDadosBanco[1] == "033"
	MSBAR("INT25",26,8.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
Else
	MSBAR("INT25",26,0.8,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.1,Nil,Nil,"A",.F.)
Endif

//If aDadosBanco[1] <> "033" // candisani - 06/07/11 - nao atualizar dados dos boletos santander

DbSelectArea("SEE")
RecLock("SEE",.f.)
SEE->EE_FAXATU := StrZero(Val(SEE->EE_FAXATU) + 1)  //INCREMENTA P/ TODOS OS BANCOS
DbUnlock()

DbSelectArea("SE1")

RecLock("SE1",.f.)
If Empty(SE1->E1_NUMBCO)
	If SE1->E1_PORTADOR == "237"
		SE1->E1_NUMBCO 	:= Substr(aCB_RN_NN[3],3,12)
	Else
		SE1->E1_NUMBCO 	:= aCB_RN_NN[3]   //GRAVA NOSSO NUMERO NO TITULO
	Endif
EndIf
//SE1->E1_BCOBOL	:= aDadosBanco[1]//Banco do boleto, utilizado com o ponto de entrada FA060Fil para tiltrar os titulos
SE1->E1_PORTADO := aDadosBanco[1]//Banco
SE1->E1_AGEDEP  := cAgencia			//Agencia
SE1->E1_CONTA   := cConta		  //Conta
DbUnlock()

//Elseif  aDadosBanco[1] == "033"

//	DbSelectArea("SE1")
//	RecLock("SE1",.f.)
//	SE1->E1_NUMBCO 	:= aCB_RN_NN[3]   //GRAVA NOSSO NUMERO NO TITULO
//SE1->E1_BCOBOL	:= aDadosBanco[1]//Banco do boleto, utilizado com o ponto de entrada FA060Fil para tiltrar os titulos
//	SE1->E1_PORTADO := aDadosBanco[1]//Banco
//	SE1->E1_AGEDEP  := cAgencia			//Agencia
//	SE1->E1_CONTA   := cConta		  //Conta
//	DbUnlock()

//Endif

oPrint:EndPage() // Finaliza a p·gina

Return Nil

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ Modulo10 ≥ Autor ≥ JONATAS C ALMEIDA     ≥ Data ≥ 13/10/03 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Especifico Del Valle                                       ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function Modulo10(cData)
Local L,D,P := 0
Local B     := .F.

L := Len(cData)  //TAMANHO DE BYTES DO CARACTER
B := .T.
D := 0     //DIGITO VERIFICADOR
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P >= 10
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End

Return(D)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ Modulo11 ≥ Autor ≥ Cadubitski            ≥ Data ≥ 29/11/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASER                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Modulo11(cData,cBanco)
Local L, D, P := 0

If SE1->E1_PORTADOR == "001"  // Banco do brasil
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := mod(D,11)
	If D == 11 .or. D == 10 .or. D == 0
		D := 1
	End
	D := AllTrim(Str(D))
	//ElseIf cBanco == "237" .or. cBanco == "341" .Or. cBanco == "453" .Or. cBanco == "399" .or. cBanco == "422" // Bradesco/Itau/Mercantil/Rural/HSBC/Safra
ElseIf SE1->E1_PORTADOR == "341" .Or. SE1->E1_PORTADOR == "453" .Or. SE1->E1_PORTADOR == "422" // Itau/Mercantil/Rural/Safra
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	
	If (D == 10 .Or. D == 11) .and. (SE1->E1_PORTADOR == "341" .or. SE1->E1_PORTADOR == "422")
		D := 1              
	End
	//   If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanco == "289" .Or. cBanco == "453" .Or. cBanco == "399")
	If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (SE1->E1_PORTADOR == "289" .Or. SE1->E1_PORTADOR == "453")
		D := 0
	End
	D := AllTrim(Str(D))
	
	//ElseIf cBanco == "399" // HSBC
ElseIf SE1->E1_PORTADOR == "399" // HSBC
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11)
		D := 1
	End
	D := AllTrim(Str(D))
	
ElseIf SE1->E1_PORTADOR == "237" //Bradesco
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - mod(D,11)
	If (D == 1 .or. D == 0 .or. D > 9)
		D := 1
	EndIf
	
	D := AllTrim(Str(D))

ElseIf SE1->E1_PORTADOR == "389" //Mercantil
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := mod(D,11)
	If D == 1 .Or. D == 0
		D := 0
	Else
		D := 11 - D
	End
	D := AllTrim(Str(D))
ElseIf SE1->E1_PORTADOR == "479"  //BOSTON
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := Mod(D*10,11)
	If D == 10
		D := 0
	End
	D := AllTrim(Str(D))
ElseIf SE1->E1_PORTADOR == "409"  //UNIBANCO
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := Mod(D*10,11)
	If D == 10 .or. D == 0
		D := 0
	End
	D := AllTrim(Str(D))
ElseIf SE1->E1_PORTADOR == "356"  //Real
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := Mod(D*10,11)
	If D == 10 .or. D == 0
		D := 0
	End
	D := AllTrim(Str(D))

ElseIf SE1->E1_PORTADOR == "033"  //Santander
	L := Len(cdata)
	D := 0
	P := 1
   //	R := 0
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	     
	D := D*10
	
	D := mod(D,11)
	
	If (D == 10 .or. D == 0 .or. D == 1)
		D := 1
	End              
	
	D := AllTrim(Str(D))
	
Else
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 10 .Or. D == 11)
		D := 1
	End
	D := AllTrim(Str(D))
Endif

Return(D)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ Modulo11A ≥ Autor ≥ Ronaldo Bicudo       ≥ Data ≥ 05/10/11 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASER                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Modulo11A(cData,cBanco)
Local L, D, P, R := 0

If SE1->E1_PORTADOR == "033" //Santander
	L := Len(cdata)
	D := 0
	P := 1
	R := 0
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	
	R := mod(D,11)
	If (R == 10)
		D := 1
	ElseIf (R == 0 .or. R == 1)
    	D := 0
	Else
    	D := (11 - R)
	End              
	
	D := AllTrim(Str(D))
	

/*L := Len(cdata)   analista
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData,L,1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

R := mod(D,11)
If (R == 10)
	D := 1
ElseIf (R == 0 .or. R == 1)
    D := 0
Else
    D := (11 - R)
End              

D := AllTrim(Str(D))*/
	
ElseIf SE1->E1_PORTADOR == "237"
	L := Len(cdata)    //ficou faltando a carteira
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 7
			P := 1
		End
		L := L - 1
	End
	
	If (mod(D,11)) == 0
		D:= 0
	Else
		D := 11 - (mod(D,11))
		
		If (D == 10)
			D2 := ''
			D2 := 'P'
			Return(D2)
		endif
	Endif
	D := AllTrim(Str(D))
	
ElseIf SE1->E1_PORTADOR == "001"  // Banco do brasil
	L := Len(cdata)
	D := 0
	P := 10
	While L > 0
		P := P - 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 2
			P := 10
		End
		L := L - 1
	End
	D := mod(D,11)
	If D == 10
		D := "X"
	End
	D := AllTrim(Str(D))
	
ElseIf SE1->E1_PORTADOR == "399" // HSBC
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 7
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11)
		D := 0
	End
	D := AllTrim(Str(D))
	
Else
	L := Len(cdata)
	D := 0
	P := 1
	
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11)
		D := 1
	End
	D := AllTrim(Str(D))
endif

Return(D)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥Ret_cBarra≥ Autor ≥ Cadubitski            ≥ Data ≥ 29/11/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASER                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta,cContra,cCartBras,_cCedente)
//Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta)

Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,6)),6)
Local cNumSeq := strzero(val(cSequencial),5)
Local bldocnufinal := ''
//Local blvalorfinal := strzero(int(nValor*100),10)//Comentado 05/09/2103 - Ronaldo Bicudo /Totvs
Local blvalorfinal := strzero((nValor*100),10)
Local cNNumSDig := cCpoLivre := cCBSemDig := cCodBarra := cNNum := cFatVenc := ''
Local cNossoNum
Local _cDigito := ""
Local _cSuperDig := ""
Local _cCartIta  := AllTrim(GetNewPar("AB_CARITAU", "109"))//"109"      //numero do banco Ita˙                                                                                  
Local _cCartBra  := AllTrim(GetNewPar("AB_CARTBRA", "09"))//"09"       //numero do banco Bradesco
//Local _cRangeHS  := "03952"    // Range padr„o do Banco HSBC para composiÁ„o do nosso numero e codigo de barras
Local _cRangeHS  := "82196"    // Range padr„o do Banco HSBC para composiÁ„o do nosso numero e codigo de barras Especfico Descarpak 82196
Local _cParcel  := NumParcela(_cParcela)

IF Substr(cBanco,1,3) == "399"
	//   bldocnufinal := strzero( right (alltrim(cNroDoc),5),5)
	bldocnufinal :=	Substr(cNroDoc,(len(alltrim(cNroDoc))-4),len(alltrim(cNroDoc)))
	//bldocnufinal := Substr(cNroDoc,(len(cNroDoc)-5),len(cNroDoc))
	//bldocnufinal := strzero(val(cNroDoc),10)
Elseif Substr(cBanco,1,3) == "341"
	//	bldocnufinal := strzero( rigth (alltrim(cNroDoc),6),6)
	bldocnufinal := StrZero(Val(right(cNroDoc,8)), 8) //+ strzero(val(_cParcel),2)
	//	bldocnufinal :=	Substr(cNroDoc,(len(alltrim(cNroDoc))-7),len(alltrim(cNroDoc)))
	//	bldocnufinal := strzero(val(cNroDoc),6) + strzero(val(_cParcela),2)
Elseif Substr(cBanco,1,3) == "356"
	bldocnufinal :=	Substr(cNroDoc,(len(alltrim(cNroDoc))-5),len(alltrim(cNroDoc)))
Elseif Substr(cBanco,1,3) == "033"
	//bldocnufinal :=	Substr(cNroDoc,(len(alltrim(cNroDoc))-5),len(alltrim(cNroDoc)))
	//bldocnufinal :=	strzero(val(cNroDoc),8)
	bldocnufinal :=	substr(cNumBco,2,5) + strzero(val(_cParcel),2) // candisani - 06/07/2011  /  Ronaldo 26/06/2012
ElseIf Substr(cBanco,1,3) == "001"
	bldocnufinal := strzero(val(cNroDoc),8) + strzero(val(_cParcel),2)
Else
	bldocnufinal := strzero(val(cNroDoc),8)
endif

//Fator Vencimento - POSICAO DE 06 A 09
If Substr(cBanco,1,3) == "356"
	cFatVenc := strzero(dvencimento - ctod("03/07/00")+1000,4)
	//	cFatVenc := strzero(dvencimento - ctod("05/07/00")+1000,4)
ElseIf Substr(cBanco,1,3) == "033"
	cFatVenc := strzero(dvencimento - ctod("07/10/97"),4)
	//	cFatVenc := strzero(dvencimento - ctod("05/07/00")+1000,4)
ElseIf Substr(cBanco,1,3) == "399"
	cFatVenc := strzero(dvencimento - ctod("03/07/00")+1000,4)
Else
	cFatVenc := STRZERO(dvencimento - CtoD("07/10/97"),4)
endif

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

//Campo Livre (Definir campo livre com cada banco)

If Substr(cBanco,1,3) == "001"  // Banco do brasil
	//Nosso Numero sem digito
	cNNumSDig := cContra+bldocnufinal
	//Nosso Numero com digito
	//cNNum := cNNumSDig + Modulo11A(cNNumSDig)
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig //+"-"+ Modulo11A(cNNumSDig)
	//Campo livre
	//cCpoLivre := cNNumSDig+cAgencia + StrZero(Val(cConta),8) + cCartBras
	
Elseif Substr(cBanco,1,3) == "389" // Banco mercantil
	//Nosso Numero sem digito
	cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)
	//Nosso Numero
	cNNum := "09"+cCarteira+ strzero(val(cSequencial),6) + modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
	
	cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")
	/*
	Elseif Substr(cBanco,1,3) == "237" // Banco bradesco
	//Nosso Numero sem digito
	cNNumSDig := cCarteira + bldocnufinal
	//Nosso Numero
	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
	
	cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"
	*/
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Composicao do Campo Livre (25 posiÁıes)                              ≥
	//≥                                                                     ≥
	//≥20 a 23 - (04) - Agencia cedente (sem o digito), completar com zeros ≥
	//≥                 a esquerda se necessario	                        ≥
	//≥24 a 25 - (02) - Carteira                                            ≥
	//≥26 a 36 - (11) - Nosso Numero (sem o digito verificador)             ≥
	//≥37 a 43 - (07) - Conta do cedente, sem o digito verificador, complete≥
	//≥                 com zeros a esquerda, se necessario                 ≥
	//≥44 a 44 - (01) - Fixo "0"                                            ≥
	//≥                                                                     ≥
	//≥Composicao do Nosso N˙mero                                           ≥
	//≥01 a 02 - (02) - N˙mero da Carteira (SEE->EE_SUBCTA)                 ≥
	//≥                 06 para Sem Registro 19 para Com Registro           ≥
	//≥03 a 13 - (11) - Nosso N˙mero (SEE->EE_FAXATU)                       ≥
	//≥04 a 14 - (01) - DÌgito do Nosso N˙mero (Modulo 11)                  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
Elseif Substr(cBanco,1,3) == "237" // Banco bradesco
	
	cNrDoc := strzero(val(Right(cNroDoc,11)),11)
	//Nosso Numero sem digito
	cNNumSDig := Right(_cCartBra,2) + cNrDoc
	//Carteira + Nosso Numero sem o digito
	//cNNum := cNNumSDig + AllTrim( Str( modulo11( cNNumSDig ) ) )
	cNNum := AllTrim( modulo11A( cNNumSDig ) )
	//Digito do nosso numero
	//cNossoNum := cCarteira + '/' + Substr(cNrDoc,1,2)+"/"+Substr(cNrDoc,3,9) + '-' + AllTrim( Str( modulo11( cNNumSDig ) ) )
	cNossoNum := Right(_cCartBra,2) + Right(cNrDoc,11) + AllTrim( cNNum )
	
	cCpoLivre := cAgencia + Right(_cCartBra,2) + cNrDoc + StrZero(Val(cConta),7) + "0"
	
Elseif Substr(cBanco,1,3)$("341")  // Banco Itau
	//Nosso Numero sem o digito
	nCalcNrBanc  := StrZero(Val(cAgencia),4) +  StrZero(Val(cConta),5) + _cCartIta + Alltrim(bldocnufinal)
	//Digito do Nosso numero
	cDVNrBanc	:= AllTrim(Str(Modulo10(nCalcNrBanc)))
	//Nosso Numero
	cNossoNum 	:= Alltrim(bldocnufinal) + Alltrim(cDVNrBanc)
	cCpoLivre    := _cCartIta + cNossoNum + StrZero(Val(cAgencia),4) +  StrZero(Val(cConta),5)+ cDacCC +"000"
	
Elseif Substr(cBanco,1,3) == "453"  // Banco rural
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),7)
	//Nosso Numero
	cNNum := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )
	
	cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"
	
Elseif Substr(cBanco,1,3) == "399"  // Banco HSBC
	//Nosso Numero sem digito
	nCalcNrBanc  := Alltrim(_cRangeHS)     + Alltrim(bldocnufinal)
	//Digiro Nosso Numero
	cDVNrBanc	:= Modulo11A(Alltrim(nCalcNrBanc))
	//Nosso Numero
	cNossoNum 	:= Alltrim(nCalcNrBanc) + Alltrim(cDVNrBanc)
	
	cCpoLivre    := cNossoNum            + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),6) + cDacCC + "001"
	
Elseif Substr(cBanco,1,3) == "422"  // Banco Safra
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	//Nosso Numero
	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))
	
	cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10)+cNNum+"2"
	
Elseif Substr(cBanco,1,3) == "479" // Banco Boston
	cNumSeq := strzero(val(cSequencial),8)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	//Nosso Numero
	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))
	
	cCpoLivre := cCodEmp+"000000"+cNNum+"8"
	
Elseif Substr(cBanco,1,3) == "409" // Banco UNIBANCO
	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)
	//Nosso Numero
	_cDigito := modulo11(cNNumSDig,SubStr(cBanco,1,3))
	//Calculo do super digito
	_cSuperDig := modulo11("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
	cNNum := "1"+cNNumSDig + _cDigito + _cSuperDig
	//Nosso Numero para impressao
	cNossoNum := "1/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig
	// O codigo fixo "04" e para a combranco som registro
	cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig
	
Elseif Substr(cBanco,1,3) == "356" // Banco REAL
	//Nosso Numero sem digito
	nCalcNrBanc  := Alltrim(bldocnufinal)
	//Digito do Nosso Numero
	cDVNrBanc	:= Modulo11(Alltrim(nCalcNrBanc))
	//Nosso Numero
	cNossoNum 	:= Alltrim(bldocnufinal) + Alltrim(cDVNrBanc)
	//Digit„o de CobranÁa
	cDigiTao     := Strzero(Val(cNossoNum),13) + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)
	cCalDgTao    := AllTrim(Str(Modulo10(cDigiTao)))
	
	cCpoLivre    := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + cCalDgTao + strzero(val(cNossoNum),13)
	
	cNossoNum 	:= Alltrim(bldocnufinal) + Alltrim(cDVNrBanc) + cCalDgTao
Elseif Substr(cBanco,1,3) == "033" // Banco Santander
	//Convenio Banco Santander
	//cConvenio := "4588010"    //Incluido por Ronaldo 05/09/2011
	cConvenio := cContra
	//Nosso Numero sem digito
	nCalcNrBanc  := Alltrim(bldocnufinal)
	//Digito do Nosso Numero
	cDVNrBanc	:= Modulo11A(Alltrim(nCalcNrBanc))//,Substr(cBanco,1,3))

	cNossoNum 	:= Alltrim(nCalcNrBanc)+ Alltrim(cDVNrBanc)
	//cNossoNum 	:= Alltrim(bldocnufinal)+Strz(Val(_cParcela),1)
	//Digit„o de CobranÁa
	//cDigiTao     := Strzero(Val(cNossoNum),13) + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),8)
	//cCalDgTao    := AllTrim(Str(Modulo10(cDigiTao)))
	
	cCpoLivre    := "9" + Strzero(Val(_cCedente),7) + strzero(val(cNossoNum),13)+ "0101"      //+cCarteira  - com registro - candisani 07/07/11
	
Endif

If Substr(cBanco,1,3) == "399" // Banco HSBC
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	//Codigo de Barras Completo
	cCodBarra := cBanco + Modulo11A(cCBSemDig) + cFatVenc + blvalorfinal + Substr(cCpoLivre,1,25)
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCpoLivre,1,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCpoLivre,6,10)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCpoLivre,16,10)
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,6) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo
	
Elseif Substr(cBanco,1,3) == "341" // Banco Itau
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	//Codigo de Barras Completo
	cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCpoLivre,1,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
	//Dac   da     Agencia/Conta             /Carteira               /Nosso Numero
	cAccNos := SubStr(cCpoLivre,13,9) + SubStr(cCpoLivre,1,3) + SubStr(cCpoLivre,4,8)  //RONALDO
	cDacCon := AllTrim(Str(Modulo10(cAccNos)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCpoLivre,6,6)+ cDacCon + SubStr(cCpoLivre,13,3)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCpoLivre,16,10)
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5)  + "." + SubStr(cPrCpo,6,4) + cDvPrCpo           + " "                                    //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5)  + "." + SubStr(cSgCpo,6,1) + cDacCon            + SubStr(cSgCpo,8,3) + cDvSgCpo  + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5)  + "." + SubStr(cTrCpo,6,2) + SubStr(cTrCpo,8,3) + cDvTrCpo           + " "               //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
Elseif Substr(cBanco,1,3) == "356" // Banco Real
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	//Codigo de Barras Completo
	cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := (Str(Modulo10(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo
Elseif Substr(cBanco,1,3) == "033" // Banco Santander
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	//Codigo de Barras Completo
	cCodBarra := cBanco + Modulo11(Alltrim(cCBSemDig)) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + Substr(cCodBarra,5,1) + SubStr(cCodBarra,21,4)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo
	
ElseIf Substr(cBanco,1,3) == "237" // Banco Bradesco
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	//Codigo de Barras Completo
	cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo
	
ElseIf Substr(cBanco,1,3) == "001"
	//Dados para Calcular o Dig Verificador Geral
		cCBSemDig := cBanco + cFatVenc + blvalorfinal + "000000" + Substr(cNNumSDig,1,17) + Substr(cCartBras,1,2)
	//Codigo de Barras Completo
	cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + "000000" + Substr(cNNumSDig,1,17) + Substr(cCartBras,1,2)
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,6) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo
	
Else
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	//Codigo de Barras Completo
	cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,11)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,37,10)
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,6) + "." + SubStr(cSgCpo,8,4) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,7) + "." + SubStr(cTrCpo,8,2)+'1' + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo
endif

Return({cCodBarra,cLinDig,cNossoNum})

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥NumParcela∫ Autor ≥ Cadubitski         ∫ Data ≥  30/11/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Ajusta a parcela.                                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Generico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function NumParcela(_cParcel)
Local _cRet := ""
If ASC(_cParcel) >= 65 .or. ASC(_cParcel) <= 90
	_cRet := StrZero(Val(Chr(ASC(_cParcel)-16)),2)
Else
	_cRet := StrZero(Val(_cParcel),2)
Endif
Return(_cRet)


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥VALIDPERG ∫ Autor ≥ AP5 IDE            ∫ Data ≥  03/05/00   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Verifica a existencia das perguntas criando-as caso seja   ∫±±
±±∫          ≥ necessario (caso nao existam).                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ValidPerg()


Local _sAlias := Alias()  
Local aRegs := {}
Local i,j

cPerg   := PADR(cPerg,10)    // Passar para 10 no Protheus 10

dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","De Prefixo     ?","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","",""        ,"","","","","","","","","","","","","","","","","","","","","",""  ,"","",""})
aAdd(aRegs,{cPerg,"02","Ate Prefixo    ?","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ"     ,"","","","","","","","","","","","","","","","","","","","","",""  ,"","",""})
aAdd(aRegs,{cPerg,"03","De Numero      ?","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","",""        ,"","","","","","","","","","","","","","","","","","","","","",""  ,"","",""})
aAdd(aRegs,{cPerg,"04","Ate Numero     ?","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ"  ,"","","","","","","","","","","","","","","","","","","","","",""  ,"","",""})
aAdd(aRegs,{cPerg,"05","De Parcela     ?","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","",""        ,"","","","","","","","","","","","","","","","","","","","","",""  ,"","",""})
aAdd(aRegs,{cPerg,"06","Ate Parcela    ?","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","ZZ"      ,"","","","","","","","","","","","","","","","","","","","","",""  ,"","",""})
aAdd(aRegs,{cPerg,"07","De Portador    ?","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","",""        ,"","","","","","","","","","","","","","","","","","","","","SA6_0","","","",""})
aAdd(aRegs,{cPerg,"08","Ate Portador   ?","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ"     ,"","","","","","","","","","","","","","","","","","","","","SA6_0","","","",""})
aAdd(aRegs,{cPerg,"09","De Cliente     ?","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","",""        ,"","","","","","","","","","","","","","","","","","","","","SA1"  ,"","","",""})
aAdd(aRegs,{cPerg,"10","De Loja        ?","","","mv_chA","C",2,0,0,"G","","MV_PAR10","","","",""        ,"","","","","","","","","","","","","","","","","","","","",""     ,"","","",""})
aAdd(aRegs,{cPerg,"11","Ate Cliente    ?","","","mv_chB","C",6,0,0,"G","","MV_PAR11","","","","ZZZZZZ"  ,"","","","","","","","","","","","","","","","","","","","","SA1"  ,"","","",""})
aAdd(aRegs,{cPerg,"12","Ate Loja       ?","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ"      ,"","","","","","","","","","","","","","","","","","","","",""     ,"","","",""})
aAdd(aRegs,{cPerg,"13","De Emissao     ?","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","",""     ,"","","",""})
aAdd(aRegs,{cPerg,"14","Ate Emissao    ?","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","",""     ,"","","",""})
aAdd(aRegs,{cPerg,"15","De Vencimento  ?","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","",""     ,"","","",""})
aAdd(aRegs,{cPerg,"16","Ate Vencimento ?","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","",""     ,"","","",""})
aAdd(aRegs,{cPerg,"17","Do Bordero     ?","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","",""        ,"","","","","","","","","","","","","","","","","","","","",""     ,"","","",""})
aAdd(aRegs,{cPerg,"18","Ate Bordero    ?","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ"  ,"","","","","","","","","","","","","","","","","","","","",""     ,"","","",""})
aAdd(aRegs,{cPerg,"19","Banco          ?","","","mv_chj","C",3,0,1,"G","","MV_PAR19","","","",""        ,"","","","","","","","","","","","","","","","","","","","","SA6_0","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)


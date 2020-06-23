#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFINR06  ³ Autor ³ Cadubitski            ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCARIO COM CODIGO DE BARRAS          ³±±
±±³          ³ COBRANÇA NÃO REGISTRADA                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINR06()

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
wnrel              := "RFINR06"
cPerg              := "FINR06    "
aReturn            := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey           := 00
lEnd               := .F.

dbSelectArea( "SE1" )

ValidPerg()
Pergunte(cPerg,.F.)

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
cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PORTADO=='" + MV_PAR07 + "'.And.E1_AGEDEP=='" + MV_PAR08 + "'.And."
cFilter		+= "E1_CONTA=='" + MV_PAR09 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR11 + "'.And.E1_CLIENTE<='" + MV_PAR12 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR13 + "'.And.E1_LOJA<='" + MV_PAR14 + "'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par15)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par16)+"'.And."
cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par17)+"'.and.DTOS(E1_VENCREA)<='"+DTOS(mv_par18)+"'.And."
cFilter		+= "E1_NUMBOR>='" + MV_PAR19 + "'.And.E1_NUMBOR<='" + MV_PAR20 + "'.And."
cFilter		+= "!(E1_TIPO$MVABATIM)"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
dbSelectArea("SE1")
dbGoTop()

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION( lExec := .T.,Close( oDlg ) )
@ 180,280 BMPBUTTON TYPE 02 ACTION( lExec := .F.,Close( oDlg ) )

ACTIVATE DIALOG oDlg CENTERED

dbGoTop()
If lExec
	Processa({|lEnd| U_RFINR062()})
Endif

RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFINR062 ³ Autor ³ Cadubitski            ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DE BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINR062(xBanco,xAgencia,xConta,xSubCt,lSetup)//Desta forma posso chamar direto da nota por exemplo, passando os parametros

Local oPrint
Local nX := 0
Local cNroDoc 	   :=  " "
Local aDadosEmp    := {	SM0->M0_NOMECOM																,;	//	[1]	Nome da Empresa
						SM0->M0_ENDCOB																,;	//	[2]	Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB	,;	//	[3]	Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)				,;	//	[4]	CEP
						"PABX/FAX: "+SM0->M0_TEL													,;	//	[5]	Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+				 ;	//	[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+					 	 ;	//	[6]
						Subs(SM0->M0_CGC,13,2)														,;	//	[6]	CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+			 	 ;	//	[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)							 }	//	[7]	I.E
Local aDadosTit
Local aDadosBanco
Local aDatSacado
Local aBolText     := { "Multa de 2,00% após dia"               ,; //[1] TEXTO 1
"Mora Diaria de ....R$"                                  ,; //[2] TEXTO 1
"Sujeito a Protesto após 15 (quinze) dias do vencimento se não pago",; //[3] TEXTO 1
""}                       //[4] TEXTO 1
Local nI           := 1
Local aCB_RN_NN    := {}
Local nVlrAbat	   := 0
Local xSetup       := iif(lSetup==nil,.f.,lSetup)
Local nDvnn 	   := 0

Private cBanco   := ""
Private cAgencia := ""
Private cConta   := ""
Private cSubCt   := ""
Private aCabec  := {}

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

DbSetOrder(1)
dbGoTop()

ProcRegua(RecCount())

While !EOF()
	
	cBanco   := iif(xBanco	==nil,SE1->E1_PORTADO,xBanco)
	cAgencia := iif(xAgencia	==nil,SE1->E1_AGEDEP,xAgencia)
	cConta   := iif(xConta	==nil,SE1->E1_CONTA,xConta)
	cSubct   := iif(xSubCt	==nil,MV_PAR10,xSubCt)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA6 (Bancos)    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SA6")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta)
		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Banco não localizado"),{"OK"})
		DbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona na Arq de Parametros CNAB   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SEE")
	DbSetOrder(1)
	//   	If !DbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCt)
	//If !DbSeek(cFilant+cBanco+cAgencia+cConta+cSubCt)  	//Comentado por Célio Oliveira
	If !DbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCt)	//incluida esta linha por célio oliveira
		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Não localizado banco no cadastro de parâmetros para envio"),{"OK"})
		DbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	If Empty(SEE->EE_CODEMP)
		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Banco nao Liberado para Emissao de Boleto Favor Informar TI"),{"OK"})
		DbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA1 (Cliente)             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")
	nBanco := ""
	BmpBanco:=""
	If SEE->EE_CODIGO == "001"
		nBanco := "Banco do Brasil"
		if file("Brasil.Bmp")
			BmpBanco :="Brasil.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "399"
		nBanco := "Banco HSBC"
		if file("Hsbc.Bmp")
			BmpBanco :="Hsbc.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "341"
		nBanco := "Banco ITAU"
		if file("Itau.Bmp")
			BmpBanco :="Itau.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "422"
		nBanco := "Banco SAFRA"
		if file("Safra.Bmp")
			BmpBanco :="Safra.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "356"
		nBanco := "Banco Real"
		if file("Real.Bmp")
			BmpBanco :="Real.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "237"
		nBanco := "Bradesco"
		if file("Bradesco.Bmp")
			BmpBanco :="Bradesco.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "104"
		nBanco   := "Caixa E.Federal"
		if file("Caixa.Bmp")
			BmpBanco :="Caixa.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "353"
		nBanco := "Santander"
		if file("Santander.Bmp")
			BmpBanco :="Santander.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "033"
		nBanco := "Santander"
		if file("Santander.Bmp")
			BmpBanco :="Santander.Bmp"
		Endif
	ElseIf SEE->EE_CODIGO == "409"
		nBanco := "Unibanco"
		if file("Unibanco.Bmp")
			BmpBanco :="Unibanco.Bmp"
		Endif
	Else
		nBanco := SUBSTR(SA6->A6_NREDUZ,1,15)
	Endif
	/*  O Bloco abaixo é original do antigo fonte da versão 10
	aDadosBanco  := {SEE->EE_CODIGO 					    				,;	//[1]	Numero do Banco
	nBanco													,;	//[2]	Nome do Banco
	SUBSTR(SEE->EE_AGENCIA, 1, 4)							,;	//[3]	Agência
	SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON)))	,;	//[4]	Conta Corrente
	SUBSTR(SA6->A6_DVCONT,Len(AllTrim(SA6->A6_DVCONT)),2)	,;	//[5]	Dígito da conta corrente
	Alltrim(SEE->EE_SUBCTA)	  							,;	//[6]	Dígito da conta corrente
	BmpBanco }												   	//[7]	Loggotipo Banco
	//SUBSTR(SEE->EE_SUBCTA,1,3)							}   //[6]	Codigo da Carteira
	*/
	
	// O bloco abaixo foi incluído por Célio Oliveira em 12/09/12  ///////////////////////
	aDadosBanco  := {allTrim(SEE->EE_CODIGO) 			,;	//[1]	Numero do Banco
	allTrim(nBanco)						,;	//[2]	Nome do Banco
	allTrim(SEE->EE_AGENCIA)			,;	//[3]	Agência
	allTrim(SA6->A6_NUMCON)				,;	//[4]	Conta Corrente
	allTrim(SA6->A6_DVCTA)				,;	//[5]	Dígito da conta corrente
	Alltrim(SEE->EE_SUBCTA)	,;	//[6]	Dígito da conta corrente
	BmpBanco}					   	//[7]	Loggotipo Banco
	//////////////////////////////////////////////////////////////////////////////////////
	
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)				,;	//	[1]	Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA				,;	//	[2]	Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;	//	[3]	Endereço
		AllTrim(SA1->A1_MUN )								,;	//	[4]	Cidade
		SA1->A1_EST											,;	//	[5]	Estado
		SA1->A1_CEP											,;	//	[6]	CEP
		SA1->A1_CGC											,;	//	[7]	CGC
		SA1->A1_PESSOA										}	//	[8]	PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)				,;	//	[1]	Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA				,;	//	[2]	Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;	//	[3]	Endereço
		AllTrim(SA1->A1_MUNC)								,;	//	[4]	Cidade
		SA1->A1_ESTC										,;	//	[5]	Estado
		SA1->A1_CEPC										,;	//	[6]	CEP
		SA1->A1_CGC											,;	//	[7]	CGC
		SA1->A1_PESSOA										}	//	[8]	PESSOA
	Endif
	
	nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA) + SE1->E1_DECRESC - SE1->E1_ACRESC
	cParcel  := If(Empty(SE1->E1_PARCELA),"0",SE1->E1_PARCELA)
	
	//	If  !Empty(SE1->E1_NUMBCO)
	//  		cNroDoc := Substr(SE1->E1_NUMBCO,1,8)
	//  ElseIf !Empty(SEE->EE_FAXATU)
	//    	cNroDoc	:= SEE->EE_FAXATU
	//	Else
	//		cNroDoc	:= SE1->E1_NUM+cParcel
	//	EndIf
	If  !Empty(SE1->E1_NUMBCO)
		//cNroDoc := IIF (SEE->EE_CODIGO=="399",Left(AllTrim(SE1->E1_NUMBCO),8),SE1->E1_NUMBCO)
		//cNroDoc := Left(AllTrim(SE1->E1_NUMBCO),IIF(SEE->EE_CODIGO=="399",8,Iif(SEE->EE_CODIGO=="033",10,Len(AllTrim(SE1->E1_NUMBCO)))))
		If SEE->EE_CODIGO$"422|399"
			cNroDoc := Substr(SE1->E1_NUMBCO,1,8)
		ElseIf  SEE->EE_CODIGO=="341"
			cNroDoc := Substr(SE1->E1_NUMBCO,4,8)
		ElseIf  SEE->EE_CODIGO=="237"
			cNroDoc := SubStr(AllTrim(SE1->E1_NUMBCO),3,11)
		Else					
			cNroDoc := Substr(SE1->E1_NUMBCO,1,10)
		EndIf
	ElseIf !Empty(SE1->E1_IDCNAB)
		cNroDoc	:= SE1->E1_IDCNAB
	Else
		// So gera outro identificador, caso o titulo
		// ainda nao o tenha, pois pode ser um re-envio do arquivo
		// Gera identificador do registro CNAB no titulo enviado
		cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt)
		dbSelectArea("SE1")
		aOrdSE1 := SE1->(GetArea())
		dbSetOrder(16)
		While SE1->(dbSeek(xFilial("SE1")+cIdCnab))
			If ( __lSx8 )
				ConfirmSX8()
			EndIf
			cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt)
		EndDo
		SE1->(RestArea(aOrdSE1))
		Reclock("SE1")
		SE1->E1_IDCNAB := cIdCnab
		cNroDoc	:= SE1->E1_IDCNAB
		MsUnlock()
		ConfirmSx8()
	EndIf
	
	//Monta codigo de barras
	aCB_RN_NN    := Ret_cBarra(	Subs(aDadosBanco[1],1,3)+"9"			,;	//Banco
								Subs(aDadosBanco[3],1,4)				,;	//Agencia
								aDadosBanco[4]							,;	//Conta
								aDadosBanco[5]							,;	//Digito da Conta
								aDadosBanco[6]							,;	//Carteira
								AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;	//Documento
								(E1_SALDO-nVlrAbat)						,;	//Valor do Titulo
								Iif(Left(aDadosBanco[1],3)=="399",SE1->E1_VENCTO,SE1->E1_VENCREA),;//Vencimento
								SEE->EE_CODEMP							,;	//Convenio
								cNroDoc  								,;	//Sequencial
								Iif(SE1->E1_DECRESC > 0,.t.,.f.)		,;	//Se tem desconto
								SE1->E1_PARCELA							,;	//Parcela
								aDadosBanco[3]							,;	//Agencia Completa
								SEE->EE_SUBCTA)								//Cod Sub.Conta (identificação de c/registro ou s/registro
	
	aDadosTit := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	,;  //	[1]	Número do título
	E1_EMISSAO						,;  //	[2]	Data da emissão do título
	dDataBase						,;  //	[3]	Data da emissão do boleto
	E1_VENCREA						,;  //	[4]	Data do vencimento
	(E1_SALDO - nVlrAbat)			,;  //	[5]	Valor do título
	aCB_RN_NN[3]					,;  //	[6]	Nosso número (Ver fórmula para calculo)
	E1_PREFIXO						,;  //	[7]	Prefixo da NF
	E1_TIPO							}   //	[8]	Tipo do Titulo
	
	If xBanco == nil
		If Marked("E1_OK")
			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
			nX := nX + 1
		EndIf
	Else
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		nX := nX + 1
	EndIf
	
	dbSkip()
	IncProc()
	nI := nI + 1
	
EndDo

oPrint:EndPage()     // Finaliza a página
If xBanco == nil
	oPrint:Preview()// Visualiza antes de imprimir
ElseIf xSetup
	oPrint:SETUP()
EndIf

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Cadubitski            ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)

LOCAL oFont8
LOCAL oFont11c
LOCAL oFont11
LOCAL oFont10
LOCAL oFont13
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

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
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/////////////////////
// PRIMEIRA PARTE  //
/////////////////////

nRow1 := 0

oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

if !Empty(aDadosBanco[7])
	oPrint:SayBitmap(nRow1+0075,100,aDadosBanco[7],400,053)
Else
	oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont13 )			// [2]Nome do Banco
Endif

oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-"+U_Modulo11CNR(aDadosBanco[1],aDadosBanco[1]),oFont21 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0150,100 ,"Cedente",oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)

if aDadosBanco[1] == "399"
	oPrint:Say  (nRow1+0200,1060,SEE->EE_CODEMP,oFont10)
elseif aDadosBanco[1] == "237"
//	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"-"+U_Modulo11CNR(aDadosBanco[3],"237")+"/0"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	oPrint:Say  (nRow1+0200,1060,AllTrim(aDadosBanco[3])+"-"+U_Modulo11CNR(aDadosBanco[3],"237")+"/0"+AllTrim(aDadosBanco[4])+"-"+aDadosBanco[5],oFont10)
elseif aDadosBanco[1] == "104" .or. aDadosBanco[1] == "033" .or. aDadosBanco[1] == "353"
	oPrint:Say  (nRow1+0200,1060,aCB_RN_NN[4],oFont10)
else
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
endif

oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0250,100 ,"Sacado",oFont8)
oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)				//Nome

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
oPrint:Say  (nRow1+0450,0100,"com as características acima."	,oFont10 )
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
oPrint:Say  ( nRow1+0245,1910,"(  )Não existe nº indicado"		,oFont8 )
oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
oPrint:Say  ( nRow1+0365,1910,"(  )Endereço insuficiente"		,oFont8 )
oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

////////////////////
// SEGUNDA PARTE  //
////////////////////

nRow2 := 140//230

//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI

oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

if !Empty(aDadosBanco[7])
	oPrint:SayBitmap(nRow2+0635,100,aDadosBanco[7],400,053)
Else
	oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont13 )		// [2]Nome do Banco
Endif

oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-"+U_Modulo11CNR(aDadosBanco[1],aDadosBanco[1]),oFont21 )	// [1]Numero do Banco

oPrint:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)

oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)


/*
oPrint:Say  (nRow2+0725,400 ,"Pagavél em qualquer Banco até o vencimento",oFont10)
oPrint:Say  (nRow2+0765,400 ," ",oFont10)
*/
// Alex - inicio inclusão para o banco Bradesco solicitação Felipe dia 21.01.13 
oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
If adadosbanco[1] =="237"
	oPrint:Say  (nRow2+0725,400 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10)
elseif adadosbanco[1] <> "237"
	oPrint:Say  (nRow2+0725,400 ,"Pagavél em qualquer Banco até o vencimento",oFont10)
	oPrint:Say  (nRow2+0765,400 ," ",oFont10)
endif
// Alex - fim inclusão para o banco Bradesco solicitação Felipe dia 21.01.13 


oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,"Cedente",oFont8)

If aDatsacado[2] == "048312-00" .or. aDatsacado[2] == "000777-00"
	oPrint:Say  (nRow2+0815,200 ,aDadosEmp[1]+"             - ",oFont10) //Nome + CNPJ
else
	oPrint:Say  (nRow2+0815,200 ,aDadosEmp[1]+"             - "+aDadosEmp[6],oFont10) //Nome + CNPJ
endif
// Endereço do Cedente - solicitação de Fevereiro/2013 - Daniel G.Jr.
oPrint:Say  (nRow2+0855,120 ,AllTrim(aDadosEmp[2])+" "+aDadosEmp[3]+" "+aDadosEmp[4],oFont10) //Nome + CNPJ


oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente",oFont8)

if aDadosBanco[1] == "399"
	cString := SEE->EE_CODEMP
elseif aDadosBanco[1] == "237"
	cString := Alltrim(aDadosBanco[3]+"-"+U_Modulo11CNR(aDadosBanco[3],"237")+"/0"+aDadosBanco[4]+"-"+aDadosBanco[5])
elseif aDadosBanco[1] == "104" .or. aDadosBanco[1] == "033" .or. aDadosBanco[1] == "353"
	cString := aCB_RN_NN[4]
else
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
endif

if aDadosBanco[1]=="104"
	nCol := 1812+(410- IIf((len(cString)*22) > 410,(len(cString)*22),0)  )
else
	nCol := 1810+(374-(len(cString)*22))
Endif
oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0910,100 ,"Data do Documento",oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0910,505 ,"Nro.Documento",oFont8)
oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0910,1005,"Espécie Doc.",oFont8)
oPrint:Say  (nRow2+0940,1050,aDadosTit[8],oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
oPrint:Say  (nRow2+0940,1400,"N",oFont10)

oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)
//If aDadosBanco[1] == "409" .or. aDadosBanco[1] == "399"
//	cString := aDadosTit[6]
//Else
	//	cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	cString := Iif(aDadosBanco[1]=="033",Left(aDadosTit[6],Len(AllTrim(aDadosTit[6]))-1)+"-"+Right(AllTrim(aDadosTit[6]),1),aDadosTit[6])
//EndIf
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)

oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)
oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6],oFont10)

oPrint:Say  (nRow2+0980,755 ,"Espécie",oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$",oFont10)

oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)

//oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))       ,oFont10)
//oPrint:Say  (nRow2+1200,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  ,oFont10)
//oPrint:Say  (nRow2+1150,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01603125)/30),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (nRow2+1150,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01603125)/30),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (nRow2+1200,100 ,aBolText[1]+" "+StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)
oPrint:Say  (nRow2+1250,100 ,aBolText[3],oFont10)
oPrint:Say  (nRow2+1300,100 ,aBolText[4],oFont10)

oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"    ,oFont8)
oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"         ,oFont8)
oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

oPrint:Say  (nRow2+1400,100 ,"Sacado",oFont8)
oPrint:Say  (nRow2+1430,400 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
oPrint:Say  (nRow2+1483,400 ,aDatSacado[3],oFont10)
oPrint:Say  (nRow2+1536,400 ,"CEP: "+Subs(aDatSacado[6],1,5)+"-"+Subs(aDatSacado[6],6,3)+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1589,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1589,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

If aDadosBanco[1] == "409" .or. aDadosBanco[1] == "399"
	oPrint:Say  (nRow2+1589,1850,aDadosTit[6],oFont10)
Else
	//	oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4)  ,oFont10)
	oPrint:Say  (nRow2+1589,1850,aDadosTit[6],oFont10)
EndIf

oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+1645,1500,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )


/////////////////////
// TERCEIRA PARTE  //
/////////////////////

nRow3 := 140  //230

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

if !Empty(aDadosBanco[7])
	oPrint:SayBitmap(nRow3+1925,100,aDadosBanco[7],400,053)
Else
	oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont13 )		// 	[2]Nome do Banco
Endif

oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-"+U_Modulo11CNR(aDadosBanco[1],aDadosBanco[1]),oFont21 )	// 	[1]Numero do Banco


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
// Alex - inicio inclusão para o banco Bradesco solicitação Felipe dia 21.01.13 
If adadosbanco[1] =="237"
	oPrint:Say  (nRow3+2015,400 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10)
elseif adadosbanco[1] <> "237"
	oPrint:Say  (nRow3+2015,400 ,"Pagavél em qualquer Banco até o vencimento",oFont10)
	oPrint:Say  (nRow3+2055,400 ," ",oFont10)
endif                                                              TOTVS
// Alex - fim inclusão para o banco Bradesco solicitação Felipe dia 21.01.13 

oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)

If aDatsacado[2] == "048312-00" .or. aDatsacado[2] =="000777-00"
	oPrint:Say  (nRow3+2130,100 ,aDadosEmp[1]+"                  - ",oFont10) //Nome + CNPJ
else
	oPrint:Say  (nRow3+2130,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6],oFont10) //Nome + CNPJ
endif

oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
if aDadosBanco[1] == "399"
	cString := SEE->EE_CODEMP
elseif aDadosBanco[1] == "237"
	cString := Alltrim(aDadosBanco[3]+"-"+U_Modulo11CNR(aDadosBanco[3],"237")+"/0"+aDadosBanco[4]+"-"+aDadosBanco[5])
elseif aDadosBanco[1] == "104" .or. aDadosBanco[1] == "033" .or. aDadosBanco[1] == "353"
	cString := aCB_RN_NN[4]
else
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
endif

if aDadosBanco[1]=="104"
	nCol := 1812+(410- IIf((len(cString)*22) > 410,(len(cString)*22),0)  )
else
	nCol := 1810+(374-(len(cString)*22))
Endif
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+2200,100 ,"Data do Documento",oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+2200,505 ,"Nro.Documento",oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"Espécie Doc.",oFont8)
oPrint:Say  (nRow3+2230,1050,aDadosTit[8],oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
oPrint:Say  (nRow3+2230,1400,"N"     ,oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)

If aDadosBanco[1] == "409" .or. aDadosBanco[1] == "399"
	cString := aDadosTit[6]
Else
	//	cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	//  cString := aDadosTit[6]
	cString := Iif(aDadosBanco[1]=="033",Left(aDadosTit[6],Len(AllTrim(aDadosTit[6]))-1)+"-"+Right(AllTrim(aDadosTit[6]),1),aDadosTit[6])
EndIf

nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)


oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)

oPrint:Say  (nRow3+2270,505 ,"Carteira",oFont8)
oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6],oFont10)

oPrint:Say  (nRow3+2270,755 ,"Espécie",oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
//oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))      ,oFont10)
//oPrint:Say  (nRow3+2490,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (nRow3+2440,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01603125)/30),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (nRow3+2490,100 ,aBolText[1]+" "+StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)
oPrint:Say  (nRow3+2540,100 ,aBolText[3],oFont10)
oPrint:Say  (nRow3+2590,100 ,aBolText[4],oFont10)

oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"    ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"         ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

oPrint:Say  (nRow3+2690,100 ,"Sacado",oFont8)
oPrint:Say  (nRow3+2700,400 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2753,400 ,aDatSacado[3],oFont10)
oPrint:Say  (nRow3+2806,400 ,"CEP: "+Subs(aDatSacado[6],1,5)+"-"+Subs(aDatSacado[6],6,3)+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

If aDadosBanco[1] == "409" .or. aDadosBanco[1] == "399"
	oPrint:Say  (nRow3+2806,1750,aDadosTit[6] ,oFont10)
Else
	//	oPrint:Say  (nRow3+2806,1750,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4)  ,oFont10)
	oPrint:Say  (nRow3+2806,1750,aDadosTit[6] ,oFont10)
EndIf

oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow3+2855,1500,"Autenticação Mecânica - Ficha de Compensação",oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800)
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300)
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300)
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300)
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300)
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300)
oPrint:Line (nRow3+2850,100 ,nRow3+2850,2300)

//MSBAR("INT25",14,1.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1,Nil,Nil,"A",.F.)
MSBAR  ("INT25", 26 , 1.5 , aCB_RN_NN[1], oPrint,.F.,Nil,Nil, 0.025, 1.8  ,Nil,Nil,"A",.F.)
//MSBAR("INT25",27.5,1.5  ,aCB_RN_NN[1] ,oPrint ,.F.,Nil,Nil, 0.025, 1.5  ,Nil,Nil,"A",.F.)


IF Empty(SE1->E1_NUMBCO).Or.aDadosBanco[1]=="399"
	//   DbSelectArea("SEE")
	//   RecLock("SEE",.f.)
	//   SEE->EE_FAXATU := StrZero(Val(SEE->EE_FAXATU) + 1,10)  //INCREMENTA P/ TODOS OS BANCOS
	//   DbUnlock()
	
	DbSelectArea("SE1")
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO := iif(aDadosBanco[1] $ "399|104|033",aCB_RN_NN[3],aCB_RN_NN[4])   //GRAVA NOSSO NUMERO NO TITULO
	DbUnlock()
Endif
oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ JONATAS C ALMEIDA     ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Del Valle                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		If P > 9
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo12cnr ³ Autor ³                    ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ modulo 11 com base 7                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
Static Function Modulo12CNR(cData,cBanc)
Local L, D, P := 0
Local D1 := ""
If cBanc == "237"  // Bradesco
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 7
			P := 1
		Endif
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 11)
		D1 := "0"
	ElseIf (D == 10)
		D1 := "P"
	Else
		D1 := str(D)
	Endif
Endif

Return(D1)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Cadubitski            ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta,_cSbCta)

Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,7)),7)
Local cNumSeq := strzero(val(cSequencial),13)
Local cNumSeqw := strzero(val(cSequencial),11)
//Local bldocnufinal := strzero(val(cNroDoc),9)
Local bldocnufinal := strzero(val(cSequencial),9)
Local blvalorfinal := strzero(nValor*100,10)
Local cNNumSDig := cCpoLivre := cCBSemDig := cCodBarra := cNNum := cFatVenc := ''
Local cNossoNum
Local _cDigito := ""
Local _cSuperDig := ""

cNrodoc := cSequencial

_cParcela := NumParcela(_cParcela)

//Fator Vencimento - POSICAO DE 06 A 09
cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)


//Campo Livre (Definir campo livre com cada banco)

If Substr(cBanco,1,3) == "001"  // Banco do brasil
	If Len(AllTrim(cConvenio)) == 7
		//Nosso Numero sem digito
		cNNumSDig := AllTrim(cConvenio)+strzero(val(cSequencial),10)
		//Nosso Numero com digito
		cNNum := cNNumSDig
		
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig
		
		//		cCpoLivre := "000000"+cNNumSDig+AllTrim(cConvenio)+strzero(val(cSequencial),10)+ cCarteira
		cCpoLivre := "000000"+cNNumSDig+cCarteira
	Else
		//Nosso Numero sem digito
		cNNumSDig := cCodEmp+cNumSeq
		//Nosso Numero com digito
		cNNum := cNNumSDig + Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
		
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
		
		cCpoLivre := cNNumSDig+cAgencia + StrZero(Val(cConta),8) + cCarteira
	Endif
Elseif Substr(cBanco,1,3) == "389" // Banco mercantil
	//Nosso Numero sem digito
	cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)
	//Nosso Numero
	cNNum := "09"+cCarteira+ strzero(val(cSequencial),6) + U_Modulo11CNR(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ U_Modulo11CNR(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
	
	cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")
	
Elseif Substr(cBanco,1,3) == "237" // Banco bradesco     Fabio 01/09/10
	//Nosso Numero sem digito
	cNNumSDig := Alltrim(cCarteira) + cNumSeqw
	//Nosso Numero
	cNNum := Alltrim(cCarteira) + cNumSeqw +  Alltrim(modulo12CNR( cNNumSDig,SubStr(cBanco,1,3) )  )
	//Nosso Numero para impressao
//	cNossoNum := Alltrim(cCarteira) + '/' + Substr(cNumSeqw,2,11) + '-' + Alltrim(modulo12CNR( cNNumSDig,SubStr(cBanco,1,3) ) )
	cNossoNum := Alltrim(cCarteira) + '/' + cNumSeqw + '-' + Alltrim(modulo12CNR( cNNumSDig,SubStr(cBanco,1,3) ) )
	
	cCpoLivre := cAgencia + Alltrim(cCarteira) + cNumSeqw + StrZero(Val(cConta),7) + "0"
	
Elseif Substr(cBanco,1,3) == "453"  // Banco rural
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),7)
	//Nosso Numero
	cNNum := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )
	
	cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"
	
Elseif Substr(cBanco,1,3) == "341"  // Banco Itau
	
	/*
	//Nosso Numero sem digito
	cNNumSDig := cCarteira+strzero(val(cNroDoc),6)+ _cParcela
	//Nosso Numero
	cNNum := cCarteira+strzero(val(cNroDoc),6) + _cParcela + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cCarteira+"/"+strzero(val(cNroDoc),6)+ _cParcela +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
	
	cCpoLivre := cNNumSDig+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) ) ) )+"000"
	*/
	
	
	//Nosso Numero sem digito
	cNNumSDig := cCarteira+strzero(val(cNroDoc),8)
	//Nosso Numero
	cNNum := cCarteira+strzero(val(cNroDoc),8) + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cCarteira+"/"+strzero(val(cNroDoc),8)+ '-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
	
	cCpoLivre := cNNumSDig+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) ) ) )+"000"
	
	
	
Elseif Substr(cBanco,1,3) == "399"  // Banco HSBC
	
	//Nosso Numero                                
	cDtVencto := DtoC(dVencimento)
	cSeqzero  := strzero(val(cSequencial),8)
	cNNumSDig := cSeqzero + U_Modulo11CNR(cSeqzero,SubStr(cBanco,1,3),2) + "4"
	cNNum := Val(cNNumSDig) + Val(cConvenio) + VAL(SUBSTR(cDtVencto,1,2)+SUBSTR(cDtVencto,4,2)+SUBSTR(cDtVencto,9,2))
	cNNum := U_Modulo11CNR(strzero(cNNum,13),SubStr(cBanco,1,3),2)
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig + cNNum
//	cCpoLivre := StrZero(Val(SubStr(cConvenio,1,7)),7)+strzero(val(cSequencial),13)+data_juliana(dVencimento)+"2"		// retirado em 14/03/2013
	cCpoLivre := StrZero(Val(SubStr(cConvenio,1,7)),7)+strzero(val(cSequencial),13)+u_data_juliana(dVencimento)+"2"		// alterado em 14/03/2013 para chamar user function
	
Elseif Substr(cBanco,1,3) == "422"  // Banco Safra
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	//Nosso Numero
	cNNum := cNNumSDig + U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	
	cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10)+cNNum+"2"
	
Elseif Substr(cBanco,1,3) == "479" // Banco Boston
	cNumSeq := strzero(val(cSequencial),8)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	//Nosso Numero
	cNNum := cNNumSDig + U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	
	cCpoLivre := cCodEmp+"000000"+cNNum+"8"
	
Elseif Substr(cBanco,1,3) == "409" // Banco UNIBANCO
	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)
	//Nosso Numero
	_cDigito := U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	//Calculo do super digito
	_cSuperDig := U_Modulo11CNR("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
	cNNum := "1"+cNNumSDig + _cDigito + _cSuperDig
	//Nosso Numero para impressao
	cNossoNum := "1/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig
	// O codigo fixo "04" e para a combranco som registro
	cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig
	
Elseif Substr(cBanco,1,3) == "104" // Banco Caixa
	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(cConvenio),12)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	//Nosso Numero
	_cDigito := U_Modulo11CNR("82"+cNNumSDig,SubStr(cBanco,1,3))
	//Calculo do super digito
	//	_cSuperDig := U_Modulo11CNR("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
	cNNum := cAgencia + "." + Substr(cCodEmp,1,3) + "." + Substr(cCodEmp,4,8) + "-" + Substr(cCodEmp,12,1)
	//Nosso Numero para impressao
	cNossoNum := "82" + cNNumSDig + "-" + _cDigito
	// O codigo fixo "04" e para a combranco som registro
	cCpoLivre := "82" + cNNumSDig + cAgencia + Substr(cCodEmp,1,11)
	
Elseif Substr(cBanco,1,3) == "353" // Banco Santander
	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),7)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)
	//Nosso Numero
	_cDigito := U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	cNossoNum := cNNumSDig + _cDigito
	//Calculo do super digito
	//	_cSuperDig := U_Modulo11CNR("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
	cNNum := cAgencia + "/" + cCodEmp
	//Nosso Numero para impressao
	// O codigo fixo "04" e para a combranco som registro
	cCpoLivre := "9" + cCodEmp + "00" + cNNumSDig + _cDigito + "0101" // ALTERACAO CARTEIRA DE 0102 PARA 0101 SOLICITACAO FELIPE 21.01.13  ALEX REIS
	
Elseif Substr(cBanco,1,3) == "033" // Banco Santander
	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),7)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)
	//Nosso Numero
	_cDigito := U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	cNossoNum := cNNumSDig + _cDigito
	//Calculo do super digito
	//	_cSuperDig := U_Modulo11CNR("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
	cNNum := cAgencia + "/" + cCodEmp
	//Nosso Numero para impressao
	// O codigo fixo "04" e para a combranco som registro

	//acrescentado o IF abaixo no dia 31/05/2013 para tratar a seleção dos Parametros do Banco
	//quando sub-conta RCR (101 - Cobrança Simples Rápida Com Registro - Sub Conta RCR)
	If alltrim(_cSbCta) == "RCR"
		cCpoLivre := "9" + cCodEmp + "00" + cNNumSDig + _cDigito + "0101" // ALTERACAO CARTEIRA DE 0102 PARA 0101 SOLICITACAO FELIPE 21.01.13  ALEX REIS
	//quando sub-conta CSR (102 - Cobrança Simples Sem Registro - Sub Conta CSR)
	ElseIf alltrim(_cSbCta) == "CSR"
		cCpoLivre := "9" + cCodEmp + "00" + cNNumSDig + _cDigito + "0102" // ALTERACAO CARTEIRA DE 0102 PARA 0101 SOLICITACAO FELIPE 21.01.13  ALEX REIS
	Else
		cCpoLivre := "9" + cCodEmp + "00" + cNNumSDig + _cDigito + "0102" // ALTERACAO CARTEIRA DE 0102 PARA 0101 SOLICITACAO FELIPE 21.01.13  ALEX REIS	
	EndIf	

Elseif Substr(cBanco,1,3) == "356" // Banco REAL
	cNumSeq := strzero(val(cNumSeq),13)
	//Nosso Numero sem digito
	cNNumSDig := cNumSeq
	//Nosso Numero
	cNNum := cNumSeq
	//Nosso Numero para impressao
	cNossoNum := cNNum
	cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+cNNumSDig ) ) ) + cNNumSDig
	
Endif

//Dados para Calcular o Dig Verificador Geral
cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
//Codigo de Barras Completo
cCodBarra := cBanco + U_Modulo11CNR(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre

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

Return({cCodBarra,cLinDig,cNossoNum,cNNum})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³NumParcelaº Autor ³ Cadubitski         º Data ³  30/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ajusta a parcela.                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function NumParcela(_cParcela)
Local _cRet := ""
If ASC(_cParcela) >= 65 .or. ASC(_cParcela) <= 90
	_cRet := StrZero(Val(Chr(ASC(_cParcela)-16)),2)
Else
	_cRet := StrZero(Val(_cParcela),2)
Endif
Return(_cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  03/05/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","De Prefixo     ?","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Prefixo    ?","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","De Numero      ?","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate Numero     ?","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","De Parcela     ?","","","mv_ch5","C",3,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate Parcela    ?","","","mv_ch6","C",3,0,0,"G","","MV_PAR06","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Banco          ?","","","mv_ch7","C",3,0,1,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SEE1","","","",""})
aAdd(aRegs,{cPerg,"08","Agencia        ?","","","mv_ch8","C",5,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Conta          ?","","","mv_ch9","C",10,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Carteira       ?","","","mv_cha","C",3,0,1,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","De Cliente     ?","","","mv_chb","C",6,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"12","Ate Cliente    ?","","","mv_chc","C",6,0,0,"G","","MV_PAR12","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"13","De Loja        ?","","","mv_chd","C",2,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Ate Loja       ?","","","mv_che","C",2,0,0,"G","","MV_PAR14","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","De Emissao     ?","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Ate Emissao    ?","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","De Vencimento  ?","","","mv_chh","D",8,0,0,"G","","MV_PAR17","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"18","Ate Vencimento ?","","","mv_chi","D",8,0,0,"G","","MV_PAR18","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"19","Do Bordero     ?","","","mv_chj","C",6,0,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"20","Ate Bordero    ?","","","mv_chk","C",6,0,0,"G","","MV_PAR20","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11CNR ³ Autor ³ Cadubitski            ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Modulo11CNR(cData,cBanc,cTipo)
Local L, D, P := 0

DEFAULT cData := "000"
DEFAULT cBanc := "xxx"
DEFAULT cTipo := 1

If cBanc == "001"  // Banco do brasil
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
	Else
		D := AllTrim(Str(D))
	End
//ElseIf cBanc == "237" .or. cBanc == "341" .Or. cBanc == "453" .or. cBanc == "422" .or. cBanc == "399"  .or. cBanc == "104" // Bradesco/Itau/Mercantil/Rural/Safra/HSBC
ElseIf cBanc == "237" .or. cBanc == "341" .Or. cBanc == "453" .or. cBanc == "422" .or. cBanc == "104" .or. (cBanc=="399".and.cTipo<>2)// Bradesco/Itau/Mercantil/Rural/Safra
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
	L := 0
	D := 11 - (mod(D,11))
	
	If (D == 10 .Or. D == 11) .and. cBanc == "237"
		D := 1
	End
	If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422")
		D := 1
	End
	If (D == 0 .Or. D == 10) .and. (cBanc == "399")
		D := 0
	End
	If D > 9 .and. (cBanc == "104" )
		D := 0
	End
	If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453")
		D := 0
	End
	D := AllTrim(Str(D))
ElseIf cBanc == "389" .or. cBanc == "353" .or. cBanc == "033"//Mercantil
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
ElseIf cBanc == "479"  //BOSTON
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
ElseIf cBanc == "409"  //UNIBANCO
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
ElseIf cBanc == "356"  //Real
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
ElseIf cBanc == "399" .And. cTipo==2 // HSBC
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
//	D := 11 - (mod(D,11))
	D := mod(D,11)
	If (D == 10 .Or. D == 0)
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
	If (D == 10 .Or. D == 11 .or. D == 0 .Or. D == 1)
		D := 1
	End
	D := AllTrim(Str(D))
Endif

Return(D) 

//Static Function data_juliana(vencimento) 		// retirado em 14/03/2013
User Function data_juliana(vencimento) 		// incluido em 14/03/2013 alterado para user function
local fim_ano, cdias 
local ano       := year(vencimento) 
local ano_ant := ano - 1 
set century on 
fim_ano := ctod("31/12/" + str(ano_ant,4)) 
cdias   := vencimento - fim_ano 
cdias   := strzero(cdias,3,0) 
cdias   += substr(str(ano,4),4,1) 
return (cdias) 

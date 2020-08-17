#INCLUDE "RWMAKE.CH"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINR01()

Tela para preenchimento dos parametros de impressão.
Impressão do boleto do bradesco com codigo de barras

@param		Nenhum
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINR01()

LOCAL   aCampos := {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
{"E1_PARCELA","Parcela","@!"},{"E1_VALOR","Valor","@E 9,999,999.99"},{"E1_VENCTO","Vencimento"}}
LOCAL   nOpc       := 0
LOCAL   aMarked    := {}
LOCAL   aDesc      := {"Este programa imprime os boletos de","cobranca bancaria de acordo com","os parametros informados"}

PRIVATE Exec       := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
Private cPerg    :="ASFINR01"

Tamanho  := "M"
titulo   := "Impressao de Boleto Bradesco"
cDesc1   := "Este programa destina-se a impressao do Boleto Bradesco."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "ASFINR01"
lEnd     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   //"Zebrado"###"Administracao"
nLastKey := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
Pergunte (cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")

/*
Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

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
nOpc := 1

If nOpc == 1
	cIndexName := Criatrab(Nil,.F.)
	cIndexKey  := 	"E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
	cFilter    := 	"E1_PREFIXO >= '" + MV_PAR01 + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. " + ;
	"E1_NUM     >= '" + MV_PAR03 + "' .And. E1_NUM     <= '" + MV_PAR04 + "' .And. " + ;
	"E1_PARCELA >= '" + MV_PAR05 + "' .And. E1_PARCELA <= '" + MV_PAR06 + "' .And. " + ;
	"E1_PORTADO >= '" + MV_PAR07 + "' .And. E1_PORTADO <= '" + MV_PAR08 + "' .And. " + ;
	"E1_CLIENTE >= '" + MV_PAR09 + "' .And. E1_CLIENTE <= '" + MV_PAR10 + "' .And. " + ;
	"E1_EMISSAO >= CTOD('" + DTOC(MV_PAR15) + "') .And. E1_EMISSAO <= CTOD('" + DTOC(MV_PAR16) + "') .And. " + ;
	"E1_VENCTO  >= CTOD('" + DTOC(MV_PAR13) + "') .And. E1_VENCTO <= CTOD('" + DTOC(MV_PAR14) + "') .And. "+ ;
	"E1_LOJA    >= '"+MV_PAR11+"' .And. E1_LOJA <= '"+MV_PAR12+"' .And. "+;
	"E1_FILIAL   = '"+xFilial()+"' .And. E1_SALDO > 0 .And. " + ;
	"SubsTring(E1_TIPO,3,1) != '-' .And. "+;
	"E1_PORTADO != '   '"
	
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	dbSelectArea("SE1")
	
	#IFNDEF TOP
		DbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	dbGoTop()
	
	If mv_par17 = 1
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
		@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
		@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
		@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
		ACTIVATE DIALOG oDlg CENTERED
	EndIf
	
	dbGoTop()
	
	Do While !Eof()
		If Marked("E1_OK")
			AADD(aMarked,.T.)
		Else
			AADD(aMarked,.F.)
		EndIf
		dbSkip()
	EndDo
	
	dbGoTop()
	
	If Exec
		Processa({|lEnd|MontaRel(aMarked)})
	Endif
	
	RetIndex("SE1")
	FErase(cIndexName+OrdBagExt())
	
EndIf

Return Nil

//-----------------------------------------------------------------------
/*/{Protheus.doc} MontaRel()

Função para montar o relatorio
Impresão do boleto lase do bradesco com código de barras.

@param		aMarked - Identificador de seleção
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function MontaRel(aMarked)

Local oPrint
Local n := 0
Local cBitmap      := "\SYSTEM\LGRL" + SM0->M0_CODIGO + SM0->M0_CODFIL + ".BMP" // Logo da empresa
Local aDadosEmp    := {SM0->M0_NOMECOM                                    ,;    //[1]Nome da Empresa
SM0->M0_ENDCOB                                                            ,;    //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,;    //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,;    //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,;    //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ;    //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ;    //[6]
Subs(SM0->M0_CGC,13,2)                                                    ,;    //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ;    //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }    //[7]I.E

Local aDadosTit
Local aDadosBanco
Local aDatSacado
Local aBolText
Local i         := 1
Local CB_RN_NN  := {}
Local nRec      := 0
Local _nVlrAbat := 0
Local _nTotEnc  := 0
Local cFatura := ""

Private _cNossoNum := "0000000"

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

dbGoTop()
Do While !EOF()
	nRec := nRec + 1
	dbSkip()
EndDo

dbGoTop()
ProcRegua(nRec)

Do While !EOF()
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	If aMarked[i]
		If Empty(SE1->E1_NUMBCO)
			_cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,7)
			RecLock("SEE",.f.)
			SEE->EE_FAXATU :=	_cNossoNum
			MsUnlock()
		Else
			_cNossoNum := Substr(SE1->E1_NUMBCO,5,7)
		Endif
	Endif
	
	//Posiciona o SA1 (Cliente)
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	dbSelectArea("SE1")
	aDadosBanco  := {"237-2"                                  ,; // [1]Numero do Banco (SA6->A6_NUMBCO)
	SA6->A6_NOME    	            	                      ,; // [2]Nome do Banco
	SUBSTR(Alltrim(SA6->A6_AGENCIA), 1, 4)                    ,; // [3]Agência
	StrZero(Val(ALLTRIM(SA6->A6_NUMCON)),7)                   ,; // [4]Conta Corrente
	ALLTRIM(SA6->A6_DVCTA)                                    ,; // [5]Dígito da conta corrente
	SUBSTR(Alltrim(SEE->EE_XCART), 3, 2)                      ,; // [6]Codigo da Carteira
	Alltrim(SA6->A6_DVAGE)                                    } // [7]Digito da Agência
	
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)                ,; // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA                ,; // [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)     ,; // [3]Endereço
		AllTrim(SA1->A1_MUN )                                 ,; // [4]Cidade
		SA1->A1_EST                                           ,; // [5]Estado
		SA1->A1_CEP                                            } // [6]CEP
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)                ,; // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA                ,; // [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC)  ,; // [3]Endereço
		AllTrim(SA1->A1_MUNC)	                              ,; // [4]Cidade
		SA1->A1_ESTC	                                      ,; // [5]Estado
		SA1->A1_CEPC                                           } // [6]CEP
	Endif
		_nTotEnc	:= 	SE1->(E1_IRRF+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL+((E1_DESCFIN * E1_SALDO)/100))		 && Bop's 110407 - Inclusao do E1_DESCFIN
    	_nVlrAbat   := 0
	
	//									Codigo Banco           Agencia			C.Corrente     Digito C/C
CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],;
	                           aDadosBanco[5],aDadosBanco[6],_cNossoNum,CalcBra() )

	aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] Número do título
	E1_EMISSAO                              					,;  // [2] Data da emissão do título
	Date()                                  					,;  // [3] Data da emissão do boleto
	E1_VENCTO													,;  // [4] Data do vencimento
        CalcBra()                     			  				,;  // [5] Valor do título
	CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
	E1_PREFIXO                               					,;  // [7] Prefixo da NF
	E1_TIPO	                               						,;  // [8] Tipo do Titulo
	E1_IRRF		                               					,;  // [9] IRRF
	E1_ISS	                             						,;  // [10] ISS
	E1_INSS 	                               					,;  // [11] INSS
	E1_PIS                                  					,;  // [12] PIS
	E1_COFINS                               					,;  // [13] COFINS
	E1_CSLL                               						,;  // [14] CSLL
	_nVlrAbat                               					}   // [15] Abatimentos
	
	cFatura := " "
	If SE1->E1_TIPO == "FT "
		cFatura  := BuscaNF(SE1->E1_PREFIXO,SE1->E1_NUM)
	Endif
	
	aBolText	:= 	{"Multa de "+ALLTRIM(MV_PAR19)+"%" +" "+"Após o Vencimento",;
	"PROTESTO AUTOMATICO APÓS QUINTO DIA DO VENCIMENTO"	,; //[2]
	" " ,; // [3]
    "APÓS VENCIMENTO MORA DIA R$ "+Alltrim(Transform(((SE1->(E1_VALOR+E1_ACRESC-E1_DECRESC))*(MV_PAR20/100))/30,"@E 99,999,999.99"))	,;//[4]
    Substr(cFatura,106,105) }// [5]
	
	
	If aMarked[i]
		ImpBrad(oPrint,cBitMap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		n := n + 1
	EndIf
	
	dbSelectArea("SE1")
	dbSkip()
	IncProc()
	i := i + 1
	
EndDo

oPrint:EndPage()     // Finaliza a página
oPrint:Setup()       // Seta a Impressora
oPrint:Preview()     // Visualiza antes de imprimir

Return nil

//-----------------------------------------------------------------------
/*/{Protheus.doc} ImpBrad()

Função para impresão do boleto lase do bradesco com código de barras.

@param		oPrint        - Parametro para impressão
			cBitmap       - Caminho do logo do bradesco
			aDadosEmp     - Dados da Empresa recebedora
			aDadosTit     - Dados do(s) títulos para impressão
			aDadosBanco   - Dados do banco de recebimento
			aDatSacado    - Dados do Sacado
			aBolText      - Texto do corpo do bordo
			CB_RN_NN      - Nosso número
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function ImpBrad(oPrint,cBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

LOCAL oFont8
LOCAL oFont10
LOCAL oFont14n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont24
LOCAL i := 0
LOCAL cImpData := " "

LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2000,1900,2100,2300}
LOCAL aCoords7 := {2270,1900,2340,2300}
LOCAL aCoords8 := {2620,1900,2690,2300}

LOCAL oBrush

Local cStartPath	:= GetSrvProfString("StartPath","")
Local cBmp			:= ""

cStartPath	:= AllTrim(cStartPath)
If SubStr(cStartPath,Len(cStartPath),1) <> "\"
	cStartPath	+= "\"
EndIf
cBmp	:= cStartPath+"BRADESCO.bmp"


//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)                                      

oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página

//Pinta os campos de cinza
//oPrint:FillRect(aCoords1,oBrush)
//oPrint:FillRect(aCoords2,oBrush)
//oPrint:FillRect(aCoords3,oBrush)
//oPrint:FillRect(aCoords4,oBrush)
//oPrint:FillRect(aCoords5,oBrush)
//oPrint:FillRect(aCoords6,oBrush)
//oPrint:FillRect(aCoords7,oBrush)
//oPrint:FillRect(aCoords8,oBrush)

// Inicia aqui
oPrint:Line (0150,550,0050, 550)
oPrint:Line (0150,800,0050, 800)

oPrint:SayBitMap(0084,100,cBitMap,0184,050)		// Logo da Empresa
//oPrint:Say  (0084,100,aDadosBanco[2],oFont14n)	// [2]Nome do Banco

oPrint:Say  (0062,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont10) //Nome + CNPJ
oPrint:Say  (0150,1060,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0200,1060,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0200,1510,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (0250,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (0300,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)	//Nome + Codigo

oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
cImpData := Strzero(Day(aDadosTit[4]),2)+"/"+Strzero(Month(aDadosTit[4]),2)+"/"+Strzero(Year(aDadosTit[4]),4)
oPrint:Say  (0300,1060,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",cImpData),oFont10)
//oPrint:Say  (0300,1060,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)

oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
oPrint:Say  (0450,0100,"com as características acima."             		,oFont10)
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)

oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 ) //---
oPrint:Line (0550, 100,0550,2300 )

oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 ) //--
oPrint:Line (0550,1900,0150,1900 )

oPrint:Say  (0160,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (0200,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (0240,1910,"(  )Não existe nº indicado"                  	,oFont8)
oPrint:Say  (0280,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (0320,1910,"(  )Não procurado"                              ,oFont8)
oPrint:Say  (0360,1910,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (0400,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (0440,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (0480,1910,"(  )Outros(anotar no verso)"                  	,oFont8)

For i := 100 to 2300 step 50
	oPrint:Line( 0600, i, 0600, i+30)
Next i

oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)

//oPrint:Say  (0644,100,aDadosBanco[2],oFont14n)	// [2]Nome do Banco
oPrint:SayBitMap(0624,100,cBmp,0400,070)		// Logo da Empresa

oPrint:Say  (0622,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (0644,1900,"Recibo do Sacado",oFont10)

oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )

oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)

oPrint:Say  (0710,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0750,100 ,"Pagável preferencialmente na rede Bradesco ou bradesco expresso"      ,oFont10)

oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
cImpData := Strzero(Day(aDadosTit[4]),2)+"/"+Strzero(Month(aDadosTit[4]),2)+"/"+Strzero(Year(aDadosTit[4]),4)
oPrint:Say  (0750,2010,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",cImpData),oFont10)
//oPrint:Say  (0750,2010,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)

oPrint:Say  (0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0810,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0850,2010,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
cImpData := Strzero(Day(aDadosTit[2]),2)+"/"+Strzero(Month(aDadosTit[2]),2)+"/"+Strzero(Year(aDadosTit[2]),4)
oPrint:Say  (0940,100 ,cImpData                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//oPrint:Say  (0940,100 ,DTOC(aDadosTit[2],"ddmmyyyy")                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,If(aDadosTit[8]$"NF |NFF","DM",aDadosTit[8])		,oFont10) //Tipo do Titulo

oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"N"                                             ,oFont10)

oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
cImpData := Strzero(Day(aDadosTit[3]),2)+"/"+Strzero(Month(aDadosTit[3]),2)+"/"+Strzero(Year(aDadosTit[3]),4)
oPrint:Say  (0940,1655,cImpData                             ,oFont10) // Data impressao
//oPrint:Say  (0940,1655,DTOC(aDadosTit[3],"ddmmyyyy")                               ,oFont10) // Data impressao

oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,2010,aDadosTit[6]                                     ,oFont10)

oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)

oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (1050,100 ,"Instruções (Texto de responsabilidade do cedente)  *** Valores expressos em R$ ***",oFont8)
oPrint:Say  (1100,100 ,aBolText[4]							            ,oFont10)
oPrint:Say  (1150,100 ,if (VAL(MV_PAR19) > 0,aBolText[1],"")            ,oFont10)
oPrint:Say  (1200,100 ,"" /*aBolText[2]*/                               ,oFont10)
oPrint:Say  (1250,100 ,aBolText[3]            		                    ,oFont10)
oPrint:Say  (1300,100 ,aBolText[5]                                      ,oFont10)

oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)
If aDadosTit[15] > 0
	oPrint:Say  (1080,2010,AllTrim(Transform(aDadosTit[15],"@E 999,999,999.99")),oFont10)
Endif
oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (1605,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)

oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )

For i := 100 to 2300 step 50
	oPrint:Line( 1850, i, 1850, i+30)
Next i

oPrint:Line (2000,100,2000,2300)
oPrint:Line (2000,550,1900, 550)
oPrint:Line (2000,800,1900, 800)

oPrint:SayBitMap(1914,100,cBmp,0400,070)		// Logo da Empresa
//oPrint:Say  (1934,100,aDadosBanco[2],oFont14n)	// [2]Nome do Banco

oPrint:Say  (1912,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (1934,820,CB_RN_NN[2],oFont14n)	//Linha Digitavel do Codigo de Barras

oPrint:Line (2100,100,2100,2300 )
oPrint:Line (2200,100,2200,2300 )
oPrint:Line (2270,100,2270,2300 )
oPrint:Line (2340,100,2340,2300 )

oPrint:Line (2200,500,2340,500)
oPrint:Line (2270,750,2340,750)
oPrint:Line (2200,1000,2340,1000)
oPrint:Line (2200,1350,2270,1350)
oPrint:Line (2200,1550,2340,1550)

oPrint:Say  (2000,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (2040,100 ,"Pagável preferencialmente na rede Bradesco ou bradesco expresso" ,oFont10)

oPrint:Say  (2000,1910,"Vencimento"                                     ,oFont8)
cImpData := Strzero(Day(aDadosTit[4]),2)+"/"+Strzero(Month(aDadosTit[4]),2)+"/"+Strzero(Year(aDadosTit[4]),4)
oPrint:Say  (2040,2010,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",cImpData),oFont10)
//oPrint:Say  (2040,2010,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)

oPrint:Say  (2100,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (2100,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (2140,2010,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (2200,100 ,"Data do Documento"                              ,oFont8)
cImpData := Strzero(Day(aDadosTit[2]),2)+"/"+Strzero(Month(aDadosTit[2]),2)+"/"+Strzero(Year(aDadosTit[2]),4)
oPrint:Say  (2230,100 , cImpData       ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//oPrint:Say  (2230,100 ,DTOC(aDadosTit[2],"ddmmyyyy")                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (2200,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (2230,1050,If(aDadosTit[8]$"NF |NFF","DM",aDadosTit[8])		,oFont10) //Tipo do Titulo

oPrint:Say  (2200,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (2230,1455,"N"                                             ,oFont10)

oPrint:Say  (2200,1555,"Data do Processamento"                          ,oFont8)
cImpData := Strzero(Day(aDadosTit[3]),2)+"/"+Strzero(Month(aDadosTit[3]),2)+"/"+Strzero(Year(aDadosTit[3]),4)
oPrint:Say  (2230,1655, cImpData             ,oFont10) // Data impressao
//oPrint:Say  (2230,1655,DTOC(aDadosTit[3],"ddmmyyyy")                   ,oFont10) // Data impressao


oPrint:Say  (2200,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (2230,2010,aDadosTit[6]                                     ,oFont10)

oPrint:Say  (2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (2300,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (2270,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (2270,1555,"Valor"                                          ,oFont8)

oPrint:Say  (2270,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (2300,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (2340,100 ,"Instruções (Texto de responsabilidade do cedente)  *** Valores expressos em R$ ***",oFont8)
oPrint:Say  (2390,100 ,aBolText[4]                                      ,oFont10)
oPrint:Say  (2440,100 ,if (VAL(MV_PAR19) > 0,aBolText[1],"")			,oFont10)
oPrint:Say  (2490,100 ,"" /*aBolText[2]*/                               ,oFont10)
oPrint:Say  (2540,100 ,aBolText[3]                                      ,oFont10)
oPrint:Say  (2590,100 ,aBolText[5]                                      ,oFont10)

oPrint:Say  (2340,1910,"(-)Desconto/Abatimento"                         ,oFont8)
If aDadosTit[15] > 0
	oPrint:Say  (2370,2010,AllTrim(Transform(aDadosTit[15],"@E 999,999,999.99")),oFont10)
Endif
oPrint:Say  (2410,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (2480,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (2550,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (2620,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (2690,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (2720,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (2773,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (2826,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (2895,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (2935,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (2935,1850,"Ficha de Compensação"                           ,oFont10)

oPrint:Line (2000,1900,2690,1900 )
oPrint:Line (2410,1900,2410,2300 )
oPrint:Line (2480,1900,2480,2300 )
oPrint:Line (2550,1900,2550,2300 )
oPrint:Line (2620,1900,2620,2300 )
oPrint:Line (2690,100 ,2690,2300 )

oPrint:Line (2930,100,2930,2300  )

IF MV_PAR18 == 2   //Fazenda Via Acesso Remoto
	MSBAR3("INT25",25.2,1.5,CB_RN_NN[1],oPrint,.F.,,,,1.2,,,,.F.)
Else	//Acesso Local
	//MSBAR3("INT25",12.7,1.0,CB_RN_NN[1],oPrint,.F.,,,,1.2,,,,.F.)
	MSBAR3("INT25",25.2,1.0,CB_RN_NN[1],oPrint,.F.,,,,1.2,,,,.F.)
Endif

For i := 100 to 2300 step 50
	oPrint:Line( 3220, i, 3220, i+30)
Next i

DbSelectArea("SE1")
RecLock("SE1",.f.)
SE1->E1_NUMBCO :=	Substr(CB_RN_NN[3],4)
MsUnlock()

oPrint:EndPage() // Finaliza a página

Return Nil



//-----------------------------------------------------------------------
/*/{Protheus.doc} Modulo10()

Modulo10 para geração do código de barras.

@param		cData
@return		D
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function Modulo10(cData)

LOCAL L,D,P := 0
LOCAL B     := .F.

L := Len(cData)
B := .T.
D := 0

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


//-----------------------------------------------------------------------
/*/{Protheus.doc} Modulo11()

Modulo11 para geração do código de barras.

@param		cData
@return		DV
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function Modulo11(cData) //Modulo 11 com base 7

LOCAL L, D, P := 0

L := Len(cdata)
D := 0
P := 1
DV:= " "

While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 7   //Volta para o inicio, ou seja comeca a multiplicar por 2,3,4...
		P := 1
	End
	L := L - 1
End

_nResto := mod(D,11)  //Resto da Divisao
D := 11 - _nResto
DV:=STR(D)

If _nResto == 0
	DV := "0"
End
If _nResto == 1
	DV := "P"
End

Return(DV)

//-----------------------------------------------------------------------
/*/{Protheus.doc} Mod11CB()

Modulo11 para geração do código de barras.

@param		cData
@return	    CBD - Retorna os strings para inpressão do Boleto
                  String para o cód.barras, RN = String com o número 
                  digitável
                  Cobrança não identificada, número do boleto = Título 
                  + Parcela

@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function Mod11CB(cData) // Modulo 11 com base 9

LOCAL CBL, CBD, CBP := 0

CBL := Len(cdata)
CBD := 0
CBP := 1

While CBL > 0
	CBP := CBP + 1
	CBD := CBD + (Val(SubStr(cData, CBL, 1)) * CBP)
	If CBP = 9
		CBP := 1
	End
	CBL := CBL - 1
End

_nCBResto := mod(CBD,11)  //Resto da Divisao
CBD := 11 - _nCBResto

If (CBD == 0 .Or. CBD == 1 .Or. CBD > 9)
	CBD := 1
End

Return(CBD)


//-----------------------------------------------------------------------
/*/{Protheus.doc} Ret_cBarra()

Função para gerar código de barras.

@param		cBanco     - Banco
			cAgencia   - Agencia
			cConta     - Conta
			cDacCC     - Digito da Conta Corrente
			cCarteira  - Carteira
			cNroDoc    - Numero do título
			nValor     - Valor do Título
@return	    CB,RN,NN
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)

//LOCAL BlDocNuFinal := cAgencia + Strzero(val(cNroDoc),7) DESABILITADO OSMIL
LOCAL BlDocNuFinal := "1112" + Strzero(val(cNroDoc),7)
LOCAL blvalorfinal := Strzero(nValor*100,10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL cMoeda       := "9"
Local cFator := Strzero(SE1->E1_VENCTO - ctod("07/10/97"),4)

//Montagem no NOSSO NUMERO
//   s :=  cAgencia + cConta + cCarteira + bldocnufinal
snn := bldocnufinal     // Agencia + Numero (pref+num+parc)
// RAI
//dvnn := modulo10(s)  //Digito verificador no Nosso Numero
dvnn := modulo11(cCarteira+snn)  //Digito verificador no Nosso Numero

//[RAI] NN := '/' + bldocnufinal + '-' + AllTrim(Str(dvnn))
NN := cCarteira +"/"+ bldocnufinal +'-'+ AllTrim(dvnn)


_cLivre := cAgencia+cCarteira+bldocnufinal+cConta+'0'


scb := cBanco + cMoeda+ cFator + blvalorfinal	+ _cLivre
dvcb := mod11CB(scb)	//digito verificador do codigo de barras

CB := SubStr(scb,1,4)+AllTrim(Str(dvcb))+SubStr(scb,5,39)



//MONTAGEM DA LINHA DIGITAVEL
srn := cBanco + cMoeda + Substr(_cLivre,1,5) //Codigo Banco + Codigo Moeda + 5 primeiros digitos do campo livre
dv := modulo10(srn,1,5)
RN := SubStr(srn,1,5) + '.' + SubStr(srn,6,4) + Alltrim(Str(DV)) + '  '

srn := SubStr(_cLivre,6,10)	// posicao 6 a 15 do campo livre
dv := modulo10(srn)
RN := RN + SubStr(srn,1,5)+'.'+SubStr(srn,6,5)+AllTrim(Str(dv))+'  '

srn := SubStr(_cLivre,16,10)	// posicao 6 a 15 do campo livre
dv := modulo10(srn)
RN := RN + SubStr(srn,1,5)+'.'+SubStr(srn,6,5)+AllTrim(Str(dv)) + '  '

RN := RN + AllTrim(Str(dvcb))+'  '
RN := RN + cFator
RN := RN + Strzero(nValor * 100,10)

Return({CB,RN,NN})

//-----------------------------------------------------------------------
/*/{Protheus.doc} BuscaNF()

Função para buscar todos os títulos para impressão do boleto.

@param		cPrefFat   - Prefixo do Título
			cNumFat    - Numero do título
@return	    cRet       - Numero dos títulos da fatura
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function BUSCANF(cPrefFat,cNumFat)

Local cRet := " "
Local cQuery := ""

cQuery	:= " SELECT * FROM " + RetSqlName("SE1") "
cQuery	+= " WHERE E1_FILIAL = '"+ xFilial("SE1") + "' AND "
cQuery	+= " E1_FATURA  = '"+ cNumFat + "' AND "
cQuery	+= " E1_FATPREF = '"+ cPrefFat + "' AND "
cQuery	+= " D_E_L_E_T_ <> '*' "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QUERY",.T.,.T.)

dbSelectArea("QUERY")
dbGotop()

While !Eof()
	cRet += QUERY->E1_NUM + "/"
	dbSelectArea("QUERY")
	dbSkip()
End

dbSelectArea("QUERY")
dbCloseArea("QUERY")

Return(cRet)


//-----------------------------------------------------------------------
/*/{Protheus.doc} ValidPerg()

Verifica as perguntas e inclui caso nao existam

@param		Nenhum
@return	    Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function ValidPerg()

Local cLAlias := Alias()
Local aRegs   := {}

Aadd(aRegs,{PADR(cPerg,10),"01","Do Prefixo           ?","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{PADR(cPerg,10),"02","Ate o Prefixo        ?","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{PADR(cPerg,10),"03","Do Titulo            ?","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"04","Ate o Titulo         ?","","","mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"05","Da Parcela           ?","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"06","Ate a Parcela        ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"07","Do Portador          ?","","","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"08","Ate o Portador       ?","","","mv_ch8","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"09","Do Cliente           ?","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"10","Ate o Cliente        ?","","","mv_chA","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"11","Da Loja              ?","","","mv_chB","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"12","Ate a Loja           ?","","","mv_chC","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"13","Do Vencimento        ?","","","mv_chD","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"14","Ate o Vencimento     ?","","","mv_chE","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"15","Da Emissao           ?","","","mv_chF","D",08,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"16","Ate a Emissao        ?","","","mv_chG","D",08,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"17","Seleciona Titulos    ?","","","mv_chH","N",01,0,0,"C","","mv_par17","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"18","Codigo de Barras     ?","","","mv_chI","N",01,0,0,"C","","mv_par18","Laser","","","","","Jato de Tinta","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"19","Valor Multa          ?","","","mv_chJ","C",10,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,10),"20","Juros Mensal         ?","","","mv_chK","N",11,2,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualizacao do SX1 com os parametros criados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX1")
dbSetorder(1)
For nLoop1 := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[nLoop1,2])
		RecLock("SX1",.T.)
		For nLoop2 := 1 to FCount()
			FieldPut(nLoop2,aRegs[nLoop1,nLoop2])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna ambiente original³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cLAlias)

Return
                                                                                   

//-----------------------------------------------------------------------
/*/{Protheus.doc} CalcBra()

Funcao para tratamento do Valor com Acrescimo e Decrescimos

@param		Nenhum
@return	    nValorT - Valor Total
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

Static Function CalcBra()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     Declaração de Variaveis Locais       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea	:= SE1->(GetArea())	
	Local nVlrAbat	:= 0
	Local nAcresc	:= 0
   	Local nDecres	:= 0
	Local nValorT	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     Atribuição de Valores                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValor	:= SE1->E1_VALOR 	
	nVlrAbat:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	nAcresc	:= SE1->E1_ACRESC
   	nDecres := SE1->E1_DECRESC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     Processamento                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValorT := nValor - nVlrAbat + nAcresc - nDecres

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     Restaura Area                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(aArea)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     Retorno da Função                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Return (nValorT)
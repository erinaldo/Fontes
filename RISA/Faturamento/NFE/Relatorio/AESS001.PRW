#INCLUDE "RWMAKE.CH"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ AESS001 ³ Autor ³ Ismael Junior          ³ Data ³ 24/11/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Orcamento grafico buscando da SC5 e SC6					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para TROVATTO 								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alteração ³ Toni Aguiar em 29/03/2016								  ³±±
±±³          ³ Não agregar IPI no total do pedidos de vendas, das TES     ³±±
±±³          ³ que possuam CFOPs 6109/6915/6916                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function AESS001()

LOCAL aMarked := {}
PRIVATE Exec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
PRIVATE cNumOrc    := ''
PRIVATE cPerg      := "PEDVED"
lEnd     := .F.

If Funname() == 'MATA410'
	Pergunte(cPerg,.F.)
	cNumOrc		:= SC5->C5_NUM
Else
	If !Pergunte(cPerg,.T.)
	   Return
	Endif
	cNumOrc		:= MV_PAR01
Endif

RptStatus({ |lend| MontaRel()})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel ³Autor ³ Ismael Junior         ³ Data ³ 24/11/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO PEDIDO DE VENDA MERCANTIL                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel()

//LOCAL oPrint
LOCAL n := 0
LOCAL aDadosEmp
LOCAL aDadosCli
LOCAL aDadosOrc
LOCAL i         := 1
LOCAL nRec      := 0
LOCAL _nVlrAbat := 0
LOCAL _nTotEnc  := 0
Local nVlAtraso := 0

Private _oFont       := TFont():New('Arial',,15,,.T.,,,,.F.,.F.)
Private oPrint

DO CASE
CASE LEN(ALLTRIM(SM0->M0_INSC)) == 8
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"-"+Subs(SM0->M0_INSC,7,2)
CASE LEN(ALLTRIM(SM0->M0_INSC)) == 9
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)
CASE LEN(ALLTRIM(SM0->M0_INSC)) == 12
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)+"."+Subs(SM0->M0_INSC,10,3)
CASE LEN(ALLTRIM(SM0->M0_INSC)) == 14
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)+"."+Subs(SM0->M0_INSC,10,3)+"-"+Subs(SM0->M0_INSC,13,2)
OTHERWISE
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)
ENDCASE

aDadosEmp  := {SM0->M0_NOMECOM 															  ,; //[1]Nome da Empresa
				SM0->M0_ENDCOB                                           				  ,; //[2]Endereço
				AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
				"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
				"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
				"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+              ; //[6]
				Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
				Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
				"IE: "+_Cie 															   } //[7]I.E

oPrint:= TMSPrinter():New( "Orçamento de Venda" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página
oPrint:SetpaperSize(9) // <==== AJUSTE PARA PAPEL a4

//Posiciona a SL1 (Orcamento)
//cNumOrc := '000003'//SC5->C5_NUM
//Alert(cNumOrc)

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial("SC5")+cNumOrc,.T.)

aDadosOrc    := {AllTrim(C5_NUM)		            	,;  // [1] Número do orcamento
		   		C5_EMISSAO                              ,;  // [2] Data da emissão do orcamento
   				C5_VEND1   		                        ,;  // [3] Vendedor
				C5_CLIENTE                              ,;  // [4] cliente
				C5_LOJACLI                              ,;  // [5] loja do cliente
			    C5_DESCONT                              ,;  // [6] total desconto
			    C5_NOTA                                 ,;  // [7] num documento
			    C5_SERIE                                ,;  // [8] serie documento
			    C5_FRETE								,;  // [9] valor do frete
			    C5_MENNOTA                              ,;	// [10] Observações
			    C5_PEDCLI                                }	// [11] Observações

//Posiciona o SA1 (Cliente)
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.T.)

aDadosCli   := {SUBSTR(SA1->A1_NOME,1,40)      		 																				,;  // [1]Razão Social
				   AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA           																	,;  // [2]Código
				   Iif(Len(AllTrim(SA1->A1_ENDCOB))<5,AllTrim(SA1->A1_END) + " " + AllTrim(SA1->A1_BAIRRO),AllTrim(SA1->A1_ENDCOB)) ,;  // [3]Endereço
				   AllTrim(SA1->A1_MUN )                            																,;  // [4]Cidade
				   SA1->A1_EST                                      																,;  // [5]Estado
				   SA1->A1_CEP                                      																,;  // [6]CEP
				   SA1->A1_CGC                                      																,;  // [7]CGC
				   SA1->A1_TEL                              																		,;  // [8]FONE
				   SA1->A1_EMAIL                             																		,;  // [9]EMAIL
				   SA1->A1_INSCR                             																		}   // [10]IE

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+SC5->C5_VEND1)
If Found()
   cNomVen  := A3_NREDUZ
Else
   cNomVen  := "  "
Endif

//   cNomArq  := " "

Impress(oPrint,aDadosEmp,aDadosOrc,aDadosCli)

oPrint:Preview()     // Visualiza antes de imprimir
//oPrint:setup()     // Escolher a impressora
//   oPrint:Print()   // Imprime direto na impressora default do APx

oPrint:End()     // Finaliza Objeto
ms_flush() // desativar impressora

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  IMPRESS ³ Autor ³ Alisson Alessandro    ³ Data ³ 14/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO ORCAMENTO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosOrc,aDadosCli)

LOCAL cCGC := IIF(SA1->A1_PESSOA == "J",substr(SA1->A1_CGC,1,2) +"."+substr(SA1->A1_CGC,3,3) +"."+ substr(SA1->A1_CGC,6,3) +"/"+ substr(SA1->A1_CGC,9,4) +"-"+substr(SA1->A1_CGC,13,2),substr(SA1->A1_CGC,1,3) +"."+substr(SA1->A1_CGC,4,3) +"."+ substr(SA1->A1_CGC,7,3) +"-"+ substr(SA1->A1_CGC,10,2))
Local nVlTotal := 0
Local nValIpi  := 0
Local nQuante  := 0
//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

Private oBrush      := TBrush():New("",4),;
		oPen     	:= TPen():New(0,5,),;
		oFont05     := TFont():New('Arial',,5,,.F.,,,,,.F. ),;
      	oFont07     := TFont():New('Arial',07,07,,.F.,,,,.T.,.F.),;
      	oFont08     := TFont():New('Arial',08,08,,.F.,,,,.T.,.F.),;
      	oFont08n    := TFont():New('Arial',08,08,,.T.,,,,.T.,.F.),;
      	oFont09     := TFont():New('Arial',09,09,,.T.,,,,.T.,.F.),;
      	oFont10     := TFont():New('Arial',10,10,,.F.,,,,.T.,.F.),;
      	oFont10n    := TFont():New('Arial',10,10,,.T.,,,,.T.,.F.),;
      	oFont10a    := TFont():New('Arial',,10,,.t.,,,,,.f. ),;
      	oFont11     := TFont():New('Arial',11,11,,.F.,,,,.T.,.F.),;
      	oFont11n    := TFont():New('Arial',11,11,,.T.,,,,.T.,.F.),;
      	oFont12     := TFont():New('Arial',12,12,,.T.,,,,.T.,.F.),;
      	oFont12n    := TFont():New('Arial',12,12,,.F.,,,,.T.,.F.),;
      	oFont12a    := TFont():New('Arial',12,12,,.T.,,,,.T.,.F.),;
      	oFont13     := TFont():New('Arial',13,13,,.T.,,,,.T.,.F.),;
      	oFont14     := TFont():New('Arial',14,14,,.T.,,,,.T.,.F.),;
      	oFont15     := TFont():New('Arial',15,15,,.T.,,,,.T.,.F.),;
      	oFont18     := TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
      	oFont16     := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
      	oFont20     := TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
      	oFont22     := TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

nLinha      := 50   		// Controla a linha por extenso
lPrintDesTab:= .f. 			// Imprime a Descricao da tabela (a cada nova pagina)
Private  _nQtdReg := 0      // Numero de registros para intruir a regua
Private _cNomecomp := ""
lCabec := .T.

_nomeuser := substr(cUsuario,7,15)
PswOrder(2)
If PswSeek(_nomeuser,.T.)
   aRetUser := PswRet(1)
   _cNomecomp := aRetUser[1,04]
Endif

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+cNumOrc,.T.)
//Alert(nLinha)

While SC6->C6_NUM == cNumOrc

If lCabec
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o cabecalho da empresa. !³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   oPrint:Box(nLinha,0050,nLinha+220,2300)
   cBitMap := GetSrvProfString("Startpath","")+"DANFE01.bmp"
   oPrint:SayBitmap(nLinha+10,070,cBitMap,500,200)			// Imprime logo da Empresa: comprimento X altura

   oPrint:Say(nLinha+10,600,AllTrim(Upper(aDadosEmp[1])),oFont12)
   oPrint:Say(nLinha+50,600,AllTrim(aDadosEmp[2]),oFont11)
   oPrint:Say(nLinha+90,600,AllTrim(aDadosEmp[3]),oFont11)
   oPrint:Say(nLinha+130,600,aDadosEmp[6]+" "+aDadosEmp[7],oFont11)
   oPrint:Say(nLinha+170,600,AllTrim(aDadosEmp[5]),oFont12)

   // imprime dados vendedor e orcamento no cabeçalho
   oPrint:Say(nLinha+010,1620,"Emissão: ",oFont10a)
   oPrint:Say(nLinha+010,1900,DTOC(aDadosOrc[2]),oFont10a)
   oPrint:Say(nLinha+050,1620,"Vendedor: ",oFont10a)
   oPrint:Say(nLinha+050,1900,cNomVen,oFont10a)
   oPrint:Say(nLinha+090,1620,"Orçamento: ",oFont10a)
   oPrint:Say(nLinha+090,1900,aDadosOrc[1],oFont10a)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If SC6->C6_TES == '506'
   oPrint:Say(nLinha+250,800,OemToAnsi('PEDIDO DE ASSITÊNCIA: ')+ aDadosOrc[11],oFont22)
   Elseif SC6->C6_TES $ "507/508"
   oPrint:Say(nLinha+250,800,OemToAnsi('PEDIDO DE BONIFICAÇÃO: ')+ aDadosOrc[11],oFont22)
   Else
   oPrint:Say(nLinha+250,800,OemToAnsi('PEDIDO DE VENDA: ')+ aDadosOrc[11],oFont22)
   Endif
//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³Cliente   ³
//ÀÄÄÄÄÄÄÄÄÄÄÙ

   nLinha += 345 // 395

   oPrint:Box(nLinha,050,nLinha+220,2300)
   oPrint:Say(nLinha+15,0070,OemToAnsi('Cliente   :'),oFont12)
   oPrint:Say(nLinha+15,0450,AllTrim(aDadosCli[1]) + ' - ('+AllTrim(aDadosCli[2])+') - '+cCGC,oFont13)
   oPrint:Say(nLinha+065,0070,OemToAnsi('Endereço:'),oFont12)
   oPrint:Say(nLinha+065,0450,Alltrim(aDadosCli[3]),oFont11)
   oPrint:Say(nLinha+065,1500,OemToAnsi(' - IE:'),oFont12)
   oPrint:Say(nLinha+065,1600,aDadosCli[10],oFont11)
   oPrint:Say(nLinha+115,0070,OemToAnsi('Município/U.F.:'),oFont12)
   oPrint:Say(nLinha+115,0450,AllTrim(aDadosCli[4])+'/'+AllTrim(aDadosCli[5]),oFont11)
   oPrint:Say(nLinha+115,1150,OemToAnsi('Cep:'),oFont12)
   oPrint:Say(nLinha+115,1320,TransForm(aDadosCli[6],'@R 99.999-999'),oFont11)
   oPrint:Say(nLinha+165,0070,OemToAnsi('Fone:'),oFont12)
   oPrint:Say(nLinha+165,0450,ALLTRIM(aDadosCli[8]),oFont11)
   oPrint:Say(nLinha+165,1150,OemToAnsi('Email:'),oFont12)
   oPrint:Say(nLinha+165,1320,ALLTRIM(aDadosCli[9]),oFont11)

 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³PRODUTOS      ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   nLinha += 250  // 645

   // box do titulo
    oPrint:Box(nLinha,050,nLinha+65,2300)
    oPrint:Say(nLinha+5,0900,OemToAnsi('ITENS DO PEDIDO'),oFont16)

   //sem os descontos
    oPrint:Say(nLinha+75,0070,'Item',oFont10a)
 	oPrint:Say(nLinha+75,0170,'Descrição',oFont10a)
	oPrint:Say(nLinha+75,1450,'NCM',oFont10a)
    oPrint:Say(nLinha+75,1700,'Qtde',oFont10a)
	oPrint:Say(nLinha+75,1840,'Vlr.Unit.',oFont10a)
	oPrint:Say(nLinha+75,2100,'Vlr.Total',oFont10a)

    nLinha += 125

lCabec := .F.
Endif
    cUn := POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_UM")
    nTotBru := nTotDesc := nTotLiq := 0
   		//sem os descontos
	    oPrint:Say(nLinha,0070,SC6->C6_ITEM,oFont10)
	    oPrint:Say(nLinha,0170,alltrim(SC6->C6_PRODUTO)+"-"+alltrim(SC6->C6_DESCRI),oFont10)
	    oPrint:Say(nLinha,1450,POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_POSIPI"),oFont10)
	    oPrint:Say(nLinha,1700,TransForm(SC6->C6_QTDVEN,'@E 9999'),oFont10)
	    oPrint:Say(nLinha,1840,TransForm(SC6->C6_PRCVEN,'@E 999,999.99'),oFont10)
	    oPrint:Say(nLinha,2100,TransForm(SC6->C6_VALOR,'@E 999,999.99'),oFont10)

 	    nLinha += 050
 	    nVlTotal += SC6->C6_VALOR
 	    nTotDesc += SC6->C6_VALDESC
 	    nIpi := POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_IPI")

 	    //-- Toni Aguiar - TOTVS SIGA SERVICE em 29/03/2016
 	    //-- Só desstaca o IPI, caso não seja uma venda de serviço ou venda para zona franca - CF 6109
 	    //-- If Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_ISS")<>"N" .And. Alltrim(Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_CF"))<>"6109"
 	    If !Alltrim(Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_CF"))$"6109/6915/6916"
 	       nValIpi += SC6->C6_VALOR * nIpi /100
 	    Endif
 	    nQuante += SC6->C6_QTDVEN


	If nLinha >= 3100
 	    nLinha += 050
	    oPrint:Say(nLinha,0100,"Continua...",oFont12)
		oPrint:EndPage()
		oPrint:StartPage()
	    nLinha := 050
		lCabec := .T.
	EndIf

DbSkip()
Enddo

	//linha com o valor do frete - incluido 27/11/2012
    nLinha += 030
    oPrint:Say(nLinha+125,0100,"VALOR DO FRETE",oFont12a)
    oPrint:Say(nLinha+125,0670,TransForm(aDadosOrc[9],'@E 999,999.99'),oFont10)
    oPrint:Say(nLinha+125,1000,"TOTAL QUANTIDADES",oFont12a)
    oPrint:Say(nLinha+125,1660,TransForm(nQuante,'@E 999,999.99'),oFont10)
    nLinha += 045

    // box fechando os produtos depois da impressao de todos
    oPrint:Box(710,050,nLinha+125,2300)

 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³TOTAIS      ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nLinha += 125
 // box dos totais
    oPrint:Box(nLinha,050,nLinha+65,2300)
//    oPrint:Say(nLinha+5,0250,'TOTAIS',oFont12a)
    oPrint:Say(nLinha+5,0070,"Sub.Total: "+TransForm(nVlTotal,'@E 999,999.99'),oFont12a)
    oPrint:Say(nLinha+5,0650,"Val IPI: "+TransForm(nValIpi,'@E 999,999.99'),oFont12a)
    oPrint:Say(nLinha+5,1270,"Desconto: "+TransForm(aDadosOrc[6]+nTotDesc,'@E 999,999.99'),oFont12a)
    oPrint:Say(nLinha+5,1870,"TOTAL: "+TransForm(aDadosOrc[9]+nValIpi+nVlTotal,'@E 999,999.99'),oFont12a)

	_vlrBruto := nVlTotal+aDadosOrc[9]

 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³COND. DE PAGAMENTO ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nLinha += 95
    nLinha2 := nLinha
 // box da cond. pgto
    oPrint:Box(nLinha,0050,nLinha+65,2300)
    oPrint:Say(nLinha+5,0900,OemToAnsi('COND. DE PAGAMENTO'),oFont16)

    oPrint:Say(nLinha+100,1800,'Num. Doc.: '+aDadosOrc[7]+" "+aDadosOrc[8],oFont12a)

// Buscando as formas de pagamento informadas no orçamento
	dbSelectArea("SE4")
 	DbSetOrder(1)
 	DbSeek(xFilial("SE4")+SC5->C5_CONDPAG,.T.)
		oPrint:Say(nLinha+100,0090,SC5->C5_CONDPAG,oFont10)
		oPrint:Say(nLinha+100,0390,SE4->E4_DESCRI,oFont10)
		oPrint:Say(nLinha+100,0690,SE4->E4_FORMA,oFont10)
	    nLinha += 50

 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³ASSINATURA    ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nLinha += 250
    oPrint:Say(nLinha,0070,OemToAnsi('ASS. Cliente:'),oFont12)
    oPrint:Say(nLinha,0350,'__________________________________',oFont12n)

    oPrint:Say(nLinha,1170,OemToAnsi('ASS. Representante:'),oFont12)
    oPrint:Say(nLinha,1550,'_______________________________',oFont12n)
    oPrint:Say(nLinha+50,1550,AllTrim(aDadosEmp[1]),oFont08)

    // box fechando cond. pgto com assinaturas
    oPrint:Box(nLinha2+65,050,nLinha+100,2300)

    // box RODAPÉ
    nLinha += 150
	oPrint:Say(nLinha,0100,"OBS: ",oFont12)
			nCol := Len(Alltrim(aDadosOrc[10]))
           If nCol > 140
			oPrint:Say(nLinha+050,0100,Substr(aDadosOrc[10],1,140),oFont10)
			nLinha+=50
	     	oPrint:Say(nLinha+050,0100,Substr(aDadosOrc[10],141),oFont10)
	       Else
			oPrint:Say(nLinha+050,0100,aDadosOrc[10],oFont10)
		   Endif
	oPrint:Say(nLinha+100,0100,"Data de Solicitação: "+DTOC(SC5->C5_DTSOLIC),oFont10)
   //	oPrint:Say(nLinha+100,0100,aDadosOrc[13]                              ,oFont10)
  //	oPrint:Say(nLinha+150,0100,aDadosOrc[14]                              ,oFont10)

    _i:=0
    _i+=If(!Empty(aDadosOrc[10]), 50, 0)

    nLinha += 100+_i
	oPrint:Say(nLinha,0100," NÃO É  VALIDO COMO DOCUMENTO FISCAL   " 	    	,oFont12)
	oPrint:Say(nLinha,1350,"ORÇAMENTO VALIDO ATÉ :"    							,oFont12)
	oPrint:Say(nLinha,1950, DTOC(aDadosOrc[2] + 3) 	  	         				,oFont15)
	oPrint:Say(nLinha+050,0100," EXIJA SEMPRE  O DOCUMENTO FISCAL	   " 	    ,oFont10)

oPrint:EndPage() // Finaliza a página

Return Nil

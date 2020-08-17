#include "Protheus.ch"
#include "pmsr170.ch"
#define CHRCOMP If(aReturn[4]==1,15,18)

//---------------------------------RELEASE 4--------------------------------------//
User Function PMSCSU2()

If PMSBLKINT()
	Return Nil                  
EndIf

If FindFunction("TRepInUse") .And. TRepInUse()
	U_PMSCSUR4()  ////OS  0699/16 e 1047/16
Else
	MsgAlert("Relatório especifico CSU - deverá ser impresso na versão tReport")
	Return(.F.) //OS  0699/16 e 1047/16
EndIf          

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMSR170R4 ºAutor  ³Paulo Carnelossi    º Data ³  16/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡…o ³Impressao dos quantitativos previstos x realizados do proj. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMSCSUR4()
Local aArea := GetArea()

AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PARAMETROS                                                                   ³
//³ MV_PAR01 : Projeto de ?                                                      ³
//³ MV_PAR02 : Ate?                                                              ³
//³ MV_PAR03 : Data projeto de ?                                                 ³
//³ MV_PAR04 : Data projeto ate ?                                                ³
//³ MV_PAR05 : Versao ?       Branco = Atual                                     ³
//³ MV_PAR06 : Relatorio ?    Analitico / Sintetico                              ³
//³ MV_PAR07 : Periodo de ?                                                      ³
//³ MV_PAR08 : Periodo ate ?                                                     ³
//³ MV_PAR09 : Produto de ?                                                      ³
//³ MV_PAR10 : Produto Ate ?                                                     ³
//³ MV_PAR11 : Custo ?        Atual(valor standard no SB1)/Previsto(valor no AFA)³
//³ MV_PAR12 : Aglutina tarefas? Sim / Nao                                       ³
//³ MV_PAR13 : Previstos? Recursos / Produtos                                    ³
//³ MV_PAR14 : Realizados? Recursos / Produtos                                   ³
//³ MV_PAR15 : Imprimir em Moeda?                                                ³
//³ MV_PAR16 : Insumo?                                                   		³
//³ MV_PAR17 : Taxa?                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()

If !Empty(oReport:uParam)
	Pergunte(oReport:uParam,.F.)
EndIf

oReport:PrintDialog()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Paulo Carnelossi    º Data ³  16/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Release 4                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()
Local cPerg  := "PMR170"
Local cDesc1 := STR0001 //"Este relatorio ira imprimir os quantitativos previstos x realizados para a execucao do projeto de acordo com parametros solicitados. O folder 'Filtro' permite a criacao de um filtro especifico do usuario para os produtos a serem considerados no processamento do relatorio."
Local cDesc2 := ""
Local cDesc3 := ""

Local oReport
Local oProjeto
Local oEdt
Local oGrupoProd, oTarefaRec, oTarefaAFN, oTarefaAFS, oTarefaSD3, oTarefaAFR, oTarefaSE5, oTarefaAFU, oTarefaAFB, oTarefa
Local oEvento

Local aOrdem := { STR0016,; //"PROJETO+PRODUTO+DESPESA"
                  STR0017,; //"TAREFA+PRODUTO+DESPESA"
                  STR0058 } //"PROJETO+GRUPO+PRODUTO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport := TReport():New("PMSR170",STR0002, cPerg, ;
			{|oReport| ReportPrint(oReport)},;
			cDesc1 )

oReport:SetLandScape()

oProjeto := TRSection():New(oReport, STR0050, {"AF8", "SA1"}, aOrdem, .F., .F.) //"Projeto"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oProjeto,	"AF8_PROJET","AF8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oProjeto,	"AF8_DESCRI","AF8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oProjeto,	"AF8_REVISA","AF8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRPosition():New(oProjeto, "SA1", 1, {|| xFilial("SA1") + AF8->AF8_CLIENT})

//-------------------------------------------------------------
oGrupoProd := TRSection():New(oReport, STR0059, {"SBM"}, /*{aOrdem}*/, .F., .F.) //"Grupo de Produto"
TRCell():New(oGrupoProd, "BM_GRUPO","SBM",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oGrupoProd, "BM_DESC", "SBM",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

//-------------------------------------------------------------
oTarefaRec := TRSection():New(oReport, STR0051, {"AE8", "SB1"}, /*{aOrdem}*/, .F., .F.) //"Recurso alocado"
TRCell():New(oTarefaRec, "AFA_TP_REC","","Tp."/*Titulo*/,/*Picture*/,3/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaRec, "B1_COD","SB1",/*Titulo*/,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaRec, "B1_DESC","SB1",/*Titulo*/,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaRec, "B1_UM","SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaRec, "AF9_TAREFA","AF9",/*Titulo*/,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaRec, "AF9_DESCRI","AF9",/*Titulo*/,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaRec, "AFA_QUANT","AFA",STR0040+CRLF+STR0042/*Titulo*/,X3Picture("AFA_QUANT")/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Previsto"###"Quantidade"
TRCell():New(oTarefaRec, "AFA_CUSTD","",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")
oTarefaRec:Cell("AFA_CUSTD"):SetTitle(STR0040+CRLF+STR0043)  //"Previsto"###"Valor"
TRCell():New(oTarefaRec, "AFA_PERC1","",STR0040+CRLF+STR0044/*Titulo*/,"@E 999.99%"/*Picture*/,8/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Previsto"###"%Proj."
TRCell():New(oTarefaRec, "AFA_PERC2","",STR0040+CRLF+STR0045/*Titulo*/,"@E 999.99%"/*Picture*/,8/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Previsto"###"%Acum."
TRCell():New(oTarefaRec, "AFA_QUANT2","",STR0041+CRLF+STR0046/*Titulo*/,X3Picture("AFA_QUANT")/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Realizado"###"Qtde Empenhada"
TRCell():New(oTarefaRec, "AFA_QUANT3","",STR0041+CRLF+STR0047/*Titulo*/,X3Picture("AFA_QUANT")/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Realizado"###"Qtde Atual"
TRCell():New(oTarefaRec, "AFA_CUSTD2","",STR0041+CRLF+STR0043/*Titulo*/,X3Picture("AFA_CUSTD")/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Realizado"###"Valor"
TRCell():New(oTarefaRec, "AFA_PERC3","",STR0041+CRLF+STR0044/*Titulo*/,"@E 999.99%"/*Picture*/,8/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Realizado"###"%Proj."
TRCell():New(oTarefaRec, "AFA_PERC4","",STR0041+CRLF+STR0045/*Titulo*/,"@E 999.99%"/*Picture*/,8/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Realizado"###"%Acum."
TRCell():New(oTarefaRec, "AFA_QUANT5","",STR0048+CRLF+STR0042/*Titulo*/,X3Picture("AFA_QUANT")/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Saldo"###"Quantidade"
TRCell():New(oTarefaRec, "AFA_QUANT6","",STR0048+CRLF+STR0049/*Titulo*/,X3Picture("AFA_CUSTD")/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Saldo"###"Custo "

TRCell():New(oTarefaRec, "C1_PEDIDO","","Num PC"/*Titulo*/,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaRec, "C7_QUANT","SC7","Qtde Empenho"/*Titulo*/,X3Picture("C7_QUANT")/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Previsto"###"Quantidade"
TRCell():New(oTarefaRec, "C7_TOTAL","SC7","Valor Empenho"/*Titulo*/,X3Picture("C7_TOTAL")/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")

TRCell():New(oTarefaRec, "C7_QUJE", "SC7","Qtde Realizado"/*Titulo*/,X3Picture("C7_QUJE")/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")  //"Previsto"###"Quantidade"
TRCell():New(oTarefaRec, "D1_VUNIT","SD1","Vlr Realizado"/*Titulo*/,X3Picture("D1_VUNIT")/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT")




oTarefaRec:SetLeftMargin(5)

//-------------------------------------------------------------
oTarefaAFN := TRSection():New(oReport, STR0052, { "AFN", "SA2","SD1","SB1" }, /*{aOrdem}*/, .F., .F.) //"Nota Fiscal de Entrada"
TRCell():New(oTarefaAFN, "A2_COD","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "A2_LOJA","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "AFN_DOC","AFN",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "AFN_SERIE","AFN",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "AFN_TIPONF","AFN",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "D1_EMISSAO","SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "AFN_QUANT","AFN",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "D1_CUSTO"	,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFN, "AFN_PERC","",Left(STR0041,6)+". "+STR0044/*Titulo*/,"@E 999.99%"/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)  //"Realizado"###"%Proj."
oTarefaAFN:SetLinesBefore(0)
oTarefaAFN:SetLeftMargin(10)
TRPosition():New(oTarefaAFN, "SA2", 1, {|| xFilial("SA2") + AFN->AFN_FORNEC + AFN->AFN_LOJA})
TRPosition():New(oTarefaAFN, "SB1", 1, {|| xFilial("SB1") + SD1->D1_COD})

//-------------------------------------------------------------
oTarefaAFS := TRSection():New(oReport, STR0061, { "AFS","SA1","SD2","SB1" }, /*{aOrdem}*/, .F., .F.) //"Nota Fiscal de Saida"
TRCell():New(oTarefaAFS, "A1_COD","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "A1_LOJA","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "A1_NOME","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "AFS_DOC","AFS",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "AFS_SERIE","AFS",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "D2_TIPO","SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "D2_EMISSAO","SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "AFS_QUANT","AFS",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "D2_CUSTO1","SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFS, "AFS_PERC","",Left(STR0041,6)+". "+STR0044/*Titulo*/,"@E 999.99%"/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)  //"Realizado"###"%Proj."
oTarefaAFS:SetLinesBefore(0)
oTarefaAFS:SetLeftMargin(10)
TRPosition():New(oTarefaAFS, "SA1", 1, {|| xFilial("SA1") + SD2->(D2_CLIENTE+D2_LOJA) })
TRPosition():New(oTarefaAFS, "SB1", 1, {|| xFilial("SB1") + SD2->D2_COD })

//-------------------------------------------------------------
oTarefaSD3 := TRSection():New(oReport, STR0053, {"SD3","SB1"}, /*{aOrdem}*/, .F., .F.) //"Movimento Interno"
TRCell():New(oTarefaSD3, "D3_EMISSAO","SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSD3, "D3_DOC","SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSD3, "D3_NUMSERI","SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSD3, "D3_TM","SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSD3, "D3_QUANT","SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSD3, "D3_CUSTO1","SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSD3, "D3_PERCPRJ","",Left(STR0041,6)+". "+STR0044/*Titulo*/,"@E 999.99%"/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/) //"Realizado" "%Proj."
oTarefaSD3:SetLinesBefore(0)
oTarefaSD3:SetLeftMargin(10)
TRPosition():New(oTarefaAFN, "SB1", 1, {|| xFilial("SB1") + SD3->D3_COD})

//-------------------------------------------------------------
oTarefaAFR := TRSection():New(oReport, STR0054, {"AFR", "SA2","SE2"}, /*{aOrdem}*/, .F., .F.) //"Despesa Financeira"
TRCell():New(oTarefaAFR, "AFR_FORNEC","AFR",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFR, "A2_LOJA","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFR, "A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFR, "AFR_DATA","AFR",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFR, "AFR_VALOR1","AFR",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFR, "AFR_PERCPRJ","",Left(STR0041,6)+". "+STR0044/*Titulo*/,"@E 999.99%"/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)  //"Realizado"###"%Proj."
oTarefaAFR:SetLinesBefore(0)
oTarefaAFR:SetLeftMargin(10)
TRPosition():New(oTarefaAFR, "SA2", 1, {|| xFilial("SA2") + AFR->AFR_FORNEC + AFR->AFR_LOJA})

//-------------------------------------------------------------
oTarefaSE5 := TRSection():New(oReport, STR0055, {"SE5","SA6"}, /*{aOrdem}*/, .F., .F.) //"Movimentação Bancária"
TRCell():New(oTarefaSE5, "A6_NOME","SA6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSE5, "E5_AGENCIA","SE5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSE5, "E5_CONTA","SE5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSE5, "E5_NUMERO","SE5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSE5, "E5_VENCTO","SE5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSE5, "E5_VALOR","SE5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaSE5, "E5_PERCPRJ","",Left(STR0041,6)+". "+STR0044/*Titulo*/,"@E 999.99%"/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)  //"Realizado"###"%Proj."
oTarefaSE5:SetLinesBefore(0)
oTarefaSE5:SetLeftMargin(10)
TrPosition():New(oTarefaSE5,"SA6",1,{|| xFilial("SA6") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA})

//-------------------------------------------------------------
oTarefaAFU := TRSection():New(oReport, STR0056, { "AFU", "AE8"}, /*{aOrdem}*/, .F., .F.) //"Apontamento de Recurso"
TRCell():New(oTarefaAFU, "AFU_RECURS","AFU",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFU, "AE8_DESCRI","AE8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFU, "AFU_TAREFA","AFU",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFU, "AF9_DESCRI","AF9",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefaAFU, "AFU_HQUANT","AFU",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
oTarefaAFU:SetLinesBefore(0)
oTarefaAFU:SetLeftMargin(10)
TRPosition():New(oTarefaAFU, "AE8", 1, {|| xFilial("AE8") + AFU->AFU_RECURS})

//-------------------------------------------------------------
oTarefaAFB := TRSection():New(oReport, STR0061, { "AFB" }, /*{aOrdem}*/, .F., .F.) //"Despesas"
TRCell():New(oTarefaAFB, "AFB_TAREFA","AFB",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| AFB->AFB_TAREFA })
TRCell():New(oTarefaAFB, "AFB_ITEM"  ,"AFB",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| AFB->AFB_ITEM })
TRCell():New(oTarefaAFB, "AFB_DESCRI","AFB",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| AFB->AFB_DESCRI })
TRCell():New(oTarefaAFB, "AFB_VALOR" ,"AFB",Left(STR0040,6)+". "+STR0043,/*Picture*/,/*Tamanho*/,/*lPixel*/, ) //"Previs"###"Valor"
TRCell():New(oTarefaAFB, "AFB_PERC",,Left(STR0040,6)+". "+STR0044/*Titulo*/,"@E 999.99%"/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)  //"Previs"###"%Proj."
TRCell():New(oTarefaAFB, "AFB_DATPRF","AFB",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| AFB->AFB_DATPRF})
oTarefaAFB:SetLinesBefore(0)
oTarefaAFB:SetLeftMargin(10)

//Eduardo                                                          
oTarefaSC1 := TRSection():New(oReport, STR0056, {"SC1"}, /*{aOrdem}*/, .F., .F.) 
TRCell():New(oTarefaSC1, "C1_PEDIDO","SC1",/*Titulo*/,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
oTarefaSC1:SetLinesBefore(0)
oTarefaSC1:SetLeftMargin(10)          
TRPosition():New(oTarefaSC1, "SC1", 12, {|| xFilial("SC1") + AF9->AF9_PROJET})

//-------------------------------------------------------------         

oTarefa := TRSection():New(oReport, STR0057, { "AF9" }, /*{aOrdem}*/, .F., .F.) //"Tarefa"
TRCell():New(oTarefa, "AF9_TAREFA","AF9",/*Titulo*/,/*Picture*/,3/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTarefa, "AF9_DESCRI","AF9",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³Paulo Carnelossi   º Data ³  16/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Release 4                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)
Local oProjeto   := oReport:Section(1)
Local oGrupoProd := oReport:Section(2)
Local oTarefaRec := oReport:Section(3)
Local oTarefaAFN := oReport:Section(4)
Local oTarefaAFS := oReport:Section(5)
Local oTarefaSD3 := oReport:Section(6)
Local oTarefaAFR := oReport:Section(7)
Local oTarefaSE5 := oReport:Section(8)
Local oTarefaAFU := oReport:Section(9)
Local oTarefaAFB := oReport:Section(10)
Local oTarefa    := oReport:Section(11)
Local nOrder     := oReport:Section(1):GetOrder()
Local aArea      := GetArea()
Local aArrayABC  := {}
Local nCustoReal := 0
Local nPercAcm   := 0
Local nPercAcm2  := 0
Local nQuantAFA  := 0
Local nValorAFB  := 0
Local nTotEmp    := 0
Local nTotRepo   := 0
Local nCusRealRe := 0
Local nTotDsp    := 0
Local nFaz       := 0
Local nQtdeRepo  := 0
Local nQtdEmp    := 0
Local nDecCst    := TamSX3("AF9_CUSTO")[2]
Local cVersao    := mv_par05
Local aItemInfo  := {}
Local nx         := 0
Local ny         := 0
Local nPrvPer    := 0
Local nRealPer   := 0
Local cTrunca    := "1"
Local cGrupoAnt  := ""
Local cGrupo     := Space( TamSX3("B1_GRUPO")[1] )
Local dDataMov
Local nVal       := 0
Local cCodigo    := ""
Local cTipo      := ""
Local nValSB1    := 0
Local lUsaAJT	 := .F.
Local lRecProd	 := .F.  // caso o RECURSO nao tenha PRODUTO.
Local nCnt

Private nMoedaPMS 	:= IIF( HasTemplate("CCT") , MV_PAR17 , MV_PAR16 )

If nMoedaPMS < 1
	nMoedaPMS := 1
Endif

TRPosition():New(oGrupoProd, "SBM", 1, {|| xFilial("SBM") + aArrayABC[nx ,14] })
TRPosition():New(oTarefaAFB, "AFB", 1, {|| aArrayABC[nx, 9, ny, 3] })

If nOrder == 2 .Or. mv_par12 == 1 // Aglutina tarefas? Sim / Nao
	oTarefaRec:Cell("AF9_TAREFA"):Disable()
	oTarefaRec:Cell("AF9_DESCRI"):Disable()
Else
	oTarefaRec:Cell("AF9_TAREFA"):SetBlock( {|| AF9->AF9_TAREFA } )
	oTarefaRec:Cell("AF9_DESCRI"):SetBlock( {|| AF9->AF9_DESCRI } )
	TRPosition():New(oTarefaRec,"AF9", 1, {|| xFilial("AF9")+aArrayABC[nx,11]+aArrayABC[nx,12]+aArrayABC[nx,13]	}, .T. )
EndIf

// este bloco eh comum para as 3 ordens
oTarefaRec:Cell("AFA_TP_REC"):SetBlock({|| If(Left(aArrayABC[nx,1],3)=="SB1", ;
															"PRD", ;
																aArrayABC[nx,1])})
																

// Para atender as necessidades infoprmadas nas OSs 0699/16 e 1047/16              
oTarefaRec:Cell("C1_PEDIDO"):SetBlock({|| aArrayABC[nx,16] })   

oTarefaRec:Cell("C7_QUANT"):SetBlock({|| aArrayABC[nx,20] })   
oTarefaRec:Cell("C7_TOTAL"):SetBlock({|| aArrayABC[nx,21] })   
																
oTarefaRec:Cell("C7_QUJE" ):SetBlock({|| aArrayABC[nx,22] })   
oTarefaRec:Cell("D1_VUNIT"):SetBlock({|| aArrayABC[nx,23] })   
																
oTarefaRec:Cell("B1_COD"):SetBlock( {|| If(Left(aArrayABC[nx,1],3) == "SB1", ;
												SB1->B1_COD, ;
												If(Left(aArrayABC[nx,1],3) == "DSP",;
													Substr(aArrayABC[nx,2],1,20),;
													If(Left(aArrayABC[nx,1],3) == "MOV",;
															"",;
															AE8->AE8_RECURS);
													);
											) } )
oTarefaRec:Cell("B1_DESC"):SetBlock({||If(Left(aArrayABC[nx,1],3) == "SB1", ;
														SB1->B1_DESC, ;
														If(Left(aArrayABC[nx,1],3) == "DSP",;
															Substr(X5Descri(), 1, 30),;
															If(Left(aArrayABC[nx,1],3)=="MOV",;
																STR0011, ;
																If(Left(aArrayABC[nx,1],3) == "REC",;
																	AE8->AE8_DESCRI,;
																	"");
																);
														);
											) } ) //"Movimentos bancarios"
oTarefaRec:Cell("B1_UM"):SetBlock({||If(Left(aArrayABC[nx,1],3)=="SB1", ;
																SB1->B1_UM, ;
														If(Left(aArrayABC[nx,1],3)=="REC",;
															 "HR",;
															 "");
										) } )
oTarefaRec:Cell("AFA_QUANT" ):SetBlock({|| aArrayABC[nx,3]})
oTarefaRec:Cell("AFA_CUSTD"):SetBlock({|| aArrayABC[nx,4] })
oTarefaRec:Cell("AFA_PERC1" ):SetBlock({|| aArrayABC[nx,4]/nCustoPrj*100 })
oTarefaRec:Cell("AFA_PERC2" ):SetBlock({|| nPercAcm })

oTarefaAFN:Cell("A2_COD")     :SetBlock({|| aArrayABC[nx, 9, ny, 2] })
oTarefaAFN:Cell("A2_LOJA")    :SetBlock({|| "  " } )
oTarefaAFN:Cell("A2_NOME")    :SetBlock({|| Substr(aArrayABC[nx, 9, ny, 3], 1, 30) } )
oTarefaAFN:Cell("AFN_DOC")    :SetBlock({|| aArrayABC[nx, 9, ny, 4] } )
oTarefaAFN:Cell("AFN_SERIE")  :SetBlock({|| aArrayABC[nx, 9, ny, 5] } )
oTarefaAFN:Cell("AFN_TIPONF") :SetBlock({|| aArrayABC[nx, 9, ny, 6] } )
oTarefaAFN:Cell("D1_EMISSAO") :SetBlock({|| aArrayABC[nx, 9, ny, 9] } )
oTarefaAFN:Cell("AFN_QUANT")  :SetBlock({|| aArrayABC[nx, 9, ny, 7] } )
oTarefaAFN:Cell("D1_CUSTO")   :SetBlock({|| aArrayABC[nx, 9, ny, 8] } )
oTarefaAFN:Cell("AFN_PERC")   :SetBlock({|| Round(aArrayABC[nx, 9, ny, 8] / nCustoReal * 100, 2) } )

oTarefaAFS:Cell("A1_COD")     :SetBlock({|| aArrayABC[nx, 9, ny, 2] })
oTarefaAFS:Cell("A1_LOJA")    :SetBlock({|| "  " } )
oTarefaAFS:Cell("A1_NOME")    :SetBlock({|| Substr(aArrayABC[nx, 9, ny, 3], 1, 30) } )
oTarefaAFS:Cell("AFS_DOC")    :SetBlock({|| aArrayABC[nx, 9, ny, 4] } )
oTarefaAFS:Cell("AFS_SERIE")  :SetBlock({|| aArrayABC[nx, 9, ny, 5] } )
oTarefaAFS:Cell("D2_TIPO")    :SetBlock({|| aArrayABC[nx, 9, ny, 6] } )
oTarefaAFS:Cell("D2_EMISSAO") :SetBlock({|| aArrayABC[nx, 9, ny, 9] } )
oTarefaAFS:Cell("AFS_QUANT")  :SetBlock({|| aArrayABC[nx, 9, ny, 7] } )
oTarefaAFS:Cell("D2_CUSTO1")  :SetBlock({|| aArrayABC[nx, 9, ny, 8] } )
oTarefaAFS:Cell("AFS_PERC")   :SetBlock({|| Round(aArrayABC[nx, 9, ny, 8] / nCustoReal * 100, 2) } )

oTarefaSD3:Cell("D3_EMISSAO") :SetBlock({|| aArrayABC[nx, 9, ny, 2] } )
oTarefaSD3:Cell("D3_DOC")     :SetBlock({|| aArrayABC[nx, 9, ny, 3] } )
oTarefaSD3:Cell("D3_NUMSERI") :SetBlock({|| aArrayABC[nx, 9, ny, 4] } )
oTarefaSD3:Cell("D3_TM")      :SetBlock({|| aArrayABC[nx, 9, ny, 7] } )
oTarefaSD3:Cell("D3_QUANT")   :SetBlock({|| aArrayABC[nx, 9, ny, 8] } )
oTarefaSD3:Cell("D3_CUSTO1")  :SetBlock({|| aArrayABC[nx, 9, ny, 9] } )
oTarefaSD3:Cell("D3_PERCPRJ") :SetBlock({|| Round(aArrayABC[nx, 9, ny, 9] / nCustoReal * 100, 2) } )

oTarefaAFR:Cell("AFR_FORNEC") :SetBlock({|| aArrayABC[nx, 9, ny, 2] } )
oTarefaAFR:Cell("A2_LOJA")    :SetBlock({|| "  " } )
oTarefaAFR:Cell("A2_NOME")    :SetBlock({|| Substr(aArrayABC[nx, 9, ny, 3], 1, 30) } )
oTarefaAFR:Cell("AFR_DATA")   :SetBlock({|| aArrayABC[nx, 9, ny, 5] } )
oTarefaAFR:Cell("AFR_VALOR1") :SetBlock({|| aArrayABC[nx, 9, ny, 7] } )
oTarefaAFR:Cell("AFR_PERCPRJ"):SetBlock({|| Round(aArrayABC[nx, 9, ny, 7]/nCustoReal*100, 2) } )

oTarefaSE5:Cell("E5_AGENCIA") :SetBlock({|| aArrayABC[nx, 9, ny, 2] } )
oTarefaSE5:Cell("E5_CONTA")   :SetBlock({|| aArrayABC[nx, 9, ny, 3] } )
oTarefaSE5:Cell("E5_NUMERO")  :SetBlock({|| aArrayABC[nx, 9, ny, 5] } )
oTarefaSE5:Cell("E5_VENCTO")  :SetBlock({|| aArrayABC[nx, 9, ny, 6] } )
oTarefaSE5:Cell("E5_VALOR")   :SetBlock({|| aArrayABC[nx, 9, ny, 4] } )
oTarefaSE5:Cell("E5_PERCPRJ") :SetBlock({|| Round(aArrayABC[nx, 9, ny, 4]/nCustoReal*100, 2) } )

oTarefaAFU:Cell("AFU_RECURS") :SetBlock({|| aArrayABC[nx, 9, ny, 02] } )
oTarefaAFU:Cell("AE8_DESCRI") :SetBlock({|| Substr(aArrayABC[nx, 9, ny, 03], 1, 30) } )
oTarefaAFU:Cell("AFU_HQUANT") :SetBlock({|| aArrayABC[nx, 9, ny, 11] } )

oTarefaAFB:Cell("AFB_VALOR")  :SetBlock({|| aArrayABC[nx, 9, ny, 2] } )
oTarefaAFB:Cell("AFB_PERC")   :SetBlock({|| Round(aArrayABC[nx, 9, ny, 2] / nCustoPrj * 100, 2) } )

Do Case
Case (nOrder == 1 .Or. nOrder == 3)
	// Aglutina tarefas? 1-Sim/2-Nao
	If mv_par12 == 2
		oTarefaAFU:Cell("AFU_TAREFA"):Disable()
		oTarefaAFU:Cell("AF9_DESCRI"):Disable()
	Else
		oTarefaAFU:Cell("AFU_TAREFA"):SetBlock({|| aArrayABC[nx, 9, ny, 06] } )
		oTarefaAFU:Cell("AF9_DESCRI"):SetBlock({|| Substr(aArrayABC[nx, 9, ny, 07], 1, 30) } )
	EndIf

	oTarefaRec:Cell("AFA_QUANT2"):SetBlock({|| If(aArrayABC[nx,1] != "SB1" .Or. aArrayABC[nx,7] < 0, ;
																0, ;
																aArrayABC[nx,7]) } )
	oTarefaRec:Cell("AFA_QUANT3"):SetBlock({|| aArrayABC[nx,5] })
	oTarefaRec:Cell("AFA_CUSTD2"):SetBlock({|| aArrayABC[nx,6] })
	oTarefaRec:Cell("AFA_PERC3" ):SetBlock({|| aArrayABC[nx,6]/nCustoReal*100 })
	oTarefaRec:Cell("AFA_QUANT6"):SetBlock({|| If( (aArrayABC[nx,1]$"SB1|REC" .And. ;
																	 mv_par11 == 1 .And. ;
																	 aArrayABC[nx,10] > 0) , ;
														  					aArrayABC[nx,10]*nQtdeRepo, ;
														  					aArrayABC[nx,4]-aArrayABC[nx,6] ) })

	If nOrder == 3 
		TRFunction():New(oTarefaRec:Cell("AFA_CUSTD") ,"VAL_PREVI","SUM",,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	//	TRFunction():New(oTarefaRec:Cell("AFA_CUSTD2"),"REAL_VAL" ,"SUM",,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
		TRFunction():New(oTarefaRec:Cell("AFA_QUANT6"),"SLD_CUSTO","SUM",,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
  
		oTarefaRec:SetTotalInLine(.F.)
		oTarefaRec:SetTotalText(STR0062) //"Total do Grupo de Produto"
	EndIf

Case nOrder == 2

	oTarefaAFU:Cell("AFU_TAREFA"):Disable()
	oTarefaAFU:Cell("AF9_DESCRI"):Disable()

	oTarefaRec:Cell("AFA_QUANT2"):SetBlock({|| If(aArrayABC[nx,1] != "SB1" .Or. aArrayABC[nx,8] < 0, ;
																0, ;
																aArrayABC[nx,8]) } )
	oTarefaRec:Cell("AFA_QUANT3"):SetBlock({|| aArrayABC[nx,6] })
	oTarefaRec:Cell("AFA_CUSTD2"):SetBlock({|| aArrayABC[nx,7] })
	oTarefaRec:Cell("AFA_PERC3" ):SetBlock({|| aArrayABC[nx,7]/nCustoReal*100 })
	oTarefaRec:Cell("AFA_QUANT6"):SetBlock({|| If( (Substr(aArrayABC[nx,1],1,3)$"SB1|REC" .And. ;
																	 mv_par11 == 1 .And. ;
																	 aArrayABC[nx,10] > 0 ), ;
																	 		aArrayABC[nx,10]*nQtdeRepo, ;
																	 		aArrayABC[nx,4]-aArrayABC[nx,7] ) })

	oTarefa:SetLeftMargin(5)
	oTarefaRec:SetLeftMargin(10)
	oTarefaAFN:SetLeftMargin(15)
	oTarefaAFS:SetLeftMargin(15)
	oTarefaSD3:SetLeftMargin(15)
	oTarefaAFR:SetLeftMargin(15)
	oTarefaSE5:SetLeftMargin(15)
	oTarefaAFU:SetLeftMargin(15)
	oTarefaAFB:SetLeftMargin(15)

	TRFunction():New(oTarefaRec:Cell("AFA_CUSTD") ,"VAL_PREVI","SUM"    ,,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oTarefaRec:Cell("AFA_PERC1") ,"PREVI_PRJ","SUM"    ,,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oTarefaRec:Cell("AFA_PERC2") ,"PREV_ACUM","ONPRINT",,/*cTitle*/,/*cPicture*/,{||nPercAcm}/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oTarefaRec:Cell("AFA_CUSTD2"),"REAL_VAL" ,"SUM"    ,,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oTarefaRec:Cell("AFA_PERC3") ,"REAL_PROJ","SUM"    ,,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oTarefaRec:Cell("AFA_PERC4") ,"REAL_ACUM","ONPRINT",,/*cTitle*/,/*cPicture*/,{||nPercAcm2}/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oTarefaRec:Cell("AFA_QUANT6"),"SLD_CUSTO","SUM"    ,,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)

	oTarefaRec:SetTotalInLine(.F.)
	oTarefaRec:SetTotalText(STR0014) //"Total da Tarefa....."

EndCase
oTarefaRec:Cell("AFA_PERC4" ):SetBlock({|| nPercAcm2 })
oTarefaRec:Cell("AFA_QUANT5"):SetBlock({|| nQtdeRepo })
If mv_par11 == 1 //Custo Atual
	oTarefaRec:Cell("AFA_QUANT6"):SetTitle(oTarefaRec:Cell("AFA_QUANT6"):Title()+STR0036)
Else
	oTarefaRec:Cell("AFA_QUANT6"):SetTitle(oTarefaRec:Cell("AFA_QUANT6"):Title()+STR0037)
EndIf

dbSelectArea("AF8")
dbSetOrder(1)

oProjeto:Cell("AF8_REVISA"):SetBlock({||cVersao})
oReport:SetMeter(RecCount())
oProjeto:Init()

dbSeek(xFilial("AF8") + mv_par01,.T.)

While !Eof() .And. xFilial("AF8") == AF8->AF8_FILIAL ;
			 .And. AF8->AF8_PROJET <= mv_par02

	oReport:IncMeter()

	If FieldPos("AF8_TRUNCA") > 0
		cTrunca:=AF8->AF8_TRUNCA
	Else
		cTrunca:="1"
	EndIf

	// se a versao nao informada
	If Empty(mv_par05)
		// utiliza a ultima versao para o projeto
		cVersao := PmsAF8Ver(AF8->AF8_PROJET)
	Else
		// utiliza a versao informada
		cVersao := mv_par05
	EndIf
	If AF8->AF8_DATA > mv_par04 .Or. AF8->AF8_DATA < mv_par03
		dbSelectArea("AF8")
		dbSkip()
		Loop
	EndIf

	nTotal    := 0
	aArrayABC := {}
	aItemInfo := {}
	nPercAcm  := 0
	nPercAcm2 := 0
	nTotRepo  := 0
	nPrvPer   := 0
	nRealPer  := 0
	aAuxHand  := PmsIniCOTP(AF8->AF8_PROJET,cVersao,CTOD("31/12/2040"))
	nCustoPrj := PmsTrunca(cTrunca,PmsRetCOTP(aAuxHand,2,Padr(AF8->AF8_PROJET,Len(AFC->AFC_EDT)))[nMoedaPMS],nDecCst,)
	aAuxHand  := PmsIniCRTE(AF8->AF8_PROJET,AF8->AF8_REVISA,CTOD("31/12/2040"))
	nCustoReal:= PmsTrunca(cTrunca,PmsRetCRTE(aAuxHand,2,AF8->AF8_PROJET+SPACE(2))[nMoedaPMS],nDecCst,)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica se o projeto usa composicoes aux   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lUsaAJT := AF8ComAJT( AF8->AF8_PROJET )

	If oReport:Cancel()
		Exit
	EndIf

	Do Case
		Case (nOrder == 1 .Or. nOrder == 3)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³tratamento para projetos que usam composicao aux  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaAJT
				dbSelectArea( "AF9" )
				AF9->( DbSetOrder( 1 ) )
				If AF9->( DbSeek( xFilial( "AF9" ) + AF8->AF8_PROJET + AF8->AF8_REVISA ) )
					While AF9->( !Eof() ) .And. xFilial( "AF9" ) + AF8->AF8_PROJET + AF8->AF8_REVISA == AF9->AF9_FILIAL + AF9->AF9_PROJET + AF9->AF9_REVISA
						DbSelectArea( "AEL" )
						AEL->( DbSetOrder( 1 ) )
						If AEL->( DbSeek( xFilial( "AEL" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_TAREFA ) ) )
							While AEL->( !Eof() ) .AND. xFilial( "AEL" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_TAREFA ) == AEL->( AEL_FILIAL + AEL_PROJET + AEL_REVISA + AEL_TAREFA )

								DbSelectArea( "AJY" )
								AJY->( DbSetOrder( 1 ) )
								If AJY->( DbSeek( xFilial( "AJY" ) + AEL->( AEL_PROJET + AEL_REVISA + AEL_INSUMO ) ) )
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³filtra o produto conforme os parametros³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If AJY->AJY_PRODUT < mv_par09 .OR. AJY->AJY_PRODUT > mv_par10
										AEL->( DbSkip() )
										Loop
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Filtra os insumos conforme os parametros³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If AJY->AJY_INSUMO < MV_PAR15 .AND. AJY->AJY_INSUMO > MV_PAR16
										AEL->( DbSkip() )
										Loop
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³verifica o empenho do produto³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
									AFJ->(MsSeek(xFilial("AFJ") + AEL->AJU_PROJET + AJY->AJY_PRODUT))
									While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AEL->AJU_PROJET .AND.;
									       AFJ->AFJ_COD == AJY->AJY_PRODUT
										nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
										AFJ->(DbSkip())
									EndDo

									nValSB1 := xMoedaPMS(AJY->AJY_CUSTD,Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,)

									DbSelectArea( "SB1" )
									SB1->( DbSetOrder( 1 ) )
									If SB1->( DbSeek( xFilial( "SB1" ) + AJY->AJY_PRODUT ) )
										If AF9->AF9_HUTEIS > 0
											nPerc		:= (PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR08)-PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR07-1))/AF9->AF9_HDURAC
										Else
											If mv_par06 <= AF9->AF9_START .And. mv_par07 >= AF9->AF9_FINISH
												nPerc	:= 1
											Else
												nPerc	:= 0
											EndIf
										EndIf

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Verifica a quantidade da tarefa.³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										// Obtem a quantidade
										If ExistTemplate( "CCTAF3QUANT" ) .AND. ( GetMV( "MV_PMSCCT" ) == "2" )
											nQuantAFA := ExecTemplate( "CCTAFAQUANT",.F.,.F.,{AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,AJY->AJY_PRODUT,AF9->AF9_QUANT,AEL->AEL_QUANT}) * nPerc
										Else
											nQuantAFA := IIf( GetMV( "MV_PMSCCT" ) == "1", AEL->AEL_QUANT, AEL->AEL_QUANT * AF9->AF9_QUANT ) * nPerc
										EndIf

										// Aglutina tarefas? Sim / Nao
										// se aglutina, verifica se jah existe no aArrayABC
										If mv_par12 == 1 .AND. (nPosABC := aScan(aArrayABC ,{|x| x[1] == "SB1" .And. x[2] == SB1->B1_COD } ))>0
											aArrayABC[nPosABC ,03] += nQuantAFA
											aArrayABC[nPosABC ,04] += xMoedaPMS(nQuantAFA * AJY->AJY_CUSTD,Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,)
										Else
											// Aglutina tarefas? Sim / Nao
											// se não aglutina, verifica se jah existe tipo, produto/recurso, projeto, revisao e tarefa no aArrayABC
											If mv_par12 == 2 .AND. (nPosABC := aScan(aArrayABC ,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD .And. x[11]==AF9->AF9_PROJET .AND. x[12]==AF9->AF9_REVISA .AND. x[13]==AF9->AF9_TAREFA }))>0
												aArrayABC[nPosABC ,03] += nQuantAFA
												aArrayABC[nPosABC ,04] += xMoedaPMS(nQuantAFA * AJY->AJY_CUSTD,Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,)
											Else
												aAdd(aArrayABC ,{ "SB1",;
															SB1->B1_COD,;
															nQuantAFA,;
															xMoedaPMS(nQuantAFA * AJY->AJY_CUSTD,Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,),;
															0,;
															0,;
															nQtdEmp,;
															0,;
															{},;
															nValSB1,;
															AF9->AF9_PROJET,;
												 			AF9->AF9_REVISA,;
												 			AF9->AF9_TAREFA,;
												 			SB1->B1_GRUPO } )

												nQtdEmp := 0
											EndIf
										EndIf
									EndIf
								EndIf

								AEL->( DbSkip() )
							End
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica as despesas.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea( "AJV" )
						AJV->( DbSetOrder( 2 ) )
						If AJV->( DbSeek( xFilial( "AJV" ) + AF9->AF9_PROJET + AF9->AF9_REVISA + AF9->AF9_COMPUN ) )
							While AJV->( !Eof() ) .And. ( xFilial( "AJV" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_COMPUN ) == AJV->( AJV_FILIAL + AJV_PROJET + AJV_REVISA + AJV_COMPUN ) )
								If AF9->AF9_HUTEIS > 0
									nPerc		:= (PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR08)-PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR07-1))/AF9->AF9_HDURAC
								Else
									If dDataDe <= AF9->AF9_START .And. dDataAte >= AF9->AF9_FINISH
										nPerc	:= 1
									Else
										nPerc	:= 0
									EndIf
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica o valor da despesa.³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If ExistTemplate("CCTAFBVLR") .And. (GetMV("MV_PMSCCT") == "2")
									nValorAFB := ExecTemplate("CCTAFBVLR",.F.,.F.,{AF9->AF9_QUANT,AJV->AJV_VALOR,.F.}) * nPerc
								Else
									nValorAFB := IIf( GetMV("MV_PMSCUST") == "1", AJV->AJV_VALOR, AF9->AF9_QUANT * AJV->AJV_VALOR ) * nPerc
								EndIf

								nVal      := PmsTrunca(cTrunca,xMoeda(nValorAFB,AJV->AJV_MOEDA,nMoedaPMS),nDecCst,AF9->AF9_QUANT)
								nVal      := xMoedaPMS(nValorAFB,AJV->AJV_MOEDA,nMoedaPMS,"",,,,,,cTrunca,,"AJV")
								// adiciona informacoes sobre a despesa
								aItemInfo := {}
								aAdd(aItemInfo, "AFB")
								aAdd(aItemInfo, nVal )
								aAdd(aItemInfo, AJV->(AJV_FILIAL+AJV_PROJET+AJV_REVISA+AJV_TAREFA+AJV_ITEM))

								If mv_par12 == 1 // Aglutina tarefas? Sim / Nao
									nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And. x[2]==AJV->AJV_TIPOD})
								Else
									nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And. x[2]==AJV->AJV_TIPOD .And. x[11]+x[12]+x[13]==AJV->(AJV_PROJET+AJV_REVISA+AJV_TAREFA) })
								EndIf

								If nPosABC > 0
									aArrayABC[nPosABC ,04] += nVal
									aAdd(aArrayABC[nPosABC ,09], aItemInfo)
								Else
									aAdd(aArrayABC,{"DSP",AJV->AJV_TIPOD,0,nVal,;
													0,0,0,0,{aItemInfo},0, AJV->AJV_PROJET,AJV->AJV_REVISA,AJV->AJV_TAREFA,cGrupo } )
								EndIf

								AJV->( DbSkip() )
								IncProc()
							End
						EndIf

						AF9->( DbSkip() )
						IncProc()
					End
			    EndIf
			Else
				dbSelectArea("AFA")
				dbSetOrder(1)
				dbSeek(xFilial("AFA") + AF8->AF8_PROJET + cVersao )
				While !Eof() .And. xFilial("AFA") + AF8->AF8_PROJET + cVersao  == AFA->AFA_FILIAL + AFA->AFA_PROJET + AFA->AFA_REVISA
					lRecProd := .F.
					aItemInfo := {}
					oReport:IncMeter()
					If !Empty(AFA->AFA_PRODUT)
						If (AFA->AFA_PRODUT < mv_par09 .Or. AFA->AFA_PRODUT > mv_par10)
							dbSelectArea("AFA")
							dbSkip()
							Loop
						Else
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial()+AFA->AFA_PRODUT))
							//filtro de usuario
							IF SB1->(dbSeek(xFilial()+AFA->AFA_PRODUT))
						   	dbSelectArea("AF8")
								If !Empty(oProjeto:GetAdvplExp()) .And. AF8->(!&(oProjeto:GetAdvplExp()))
									dbSelectArea("AFA")
									dbSkip()
									Loop
								EndIf
							EndIf
							nValSB1 := xMoedaPMS(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
						EndIf
					ElseIf MV_PAR13 == 2 .and. Empty(AFA->AFA_PRODUT)
						dbSelectArea("AE8")
						DbSetOrder(1)
						If dbseek(xFilial("AE8")+AFA->AFA_RECURS)
							If !EMPTY(AE8->AE8_PRODUT)
								If (AE8->AE8_PRODUT < mv_par09 .Or. AE8->AE8_PRODUT > mv_par10)
									dbSelectArea("AFA")
									dbSkip()
									Loop
								Else
									SB1->(dbSetOrder(1))
									SB1->(dbSeek(xFilial("SB1")+AE8->AE8_PRODUT))
									//filtro de usuario
									If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
										dbSelectArea("AFA")
										dbSkip()
										Loop
									EndIf
									lRecProd := .T.
									nValSB1 := xMoedaPMS(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
								EndIf
							ENDIF
						Endif
					EndIf

					// verifica o empenho do produto
					AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
					AFJ->(MsSeek(xFilial("AFJ") + AFA->AFA_PROJET + AFA->AFA_PRODUT))
					While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AFA->AFA_PROJET .AND.;
					       AFJ->AFJ_COD == AFA->AFA_PRODUT
						nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
						AFJ->(DbSkip())
					EndDo

					// verifica a quantidade do produto
					AF9->(dbSetOrder(1))
					AF9->(MsSeek(xFilial("AF9") + AFA->AFA_PROJET + AFA->AFA_REVISA + AFA->AFA_TAREFA))
					nQuantAFA := PmsPrvAFA(AFA->(RecNo()),mv_par07,mv_par08,AF9->(RecNo()))

					// Visualizar Custo Previsto por Produto
					If MV_PAR13 == 2 .and. !Empty(AFA->AFA_PRODUT)
					  cCodigo := AFA->AFA_PRODUT
					  cTipo   := "SB1"
					ElseIf lRecProd
						cCodigo := SB1->B1_COD
						cTipo   := "SB1"
					ElseIf !Empty(AFA->AFA_RECURS)
						cCodigo := AFA->AFA_RECURS
						cTipo   := "REC"
					Else
						cCodigo := AFA->AFA_PRODUT
						cTipo   := "SB1"
					EndIf

					// Aglutina tarefas? Sim / Nao
					// se aglutina, verifica se jah existe no aArrayABC
					If mv_par12 == 1 .AND. (nPosABC := aScan(aArrayABC ,{|x| x[1]==cTipo .And. x[2]==cCodigo }))>0
						aArrayABC[nPosABC ,03] += nQuantAFA
						aArrayABC[nPosABC ,04] += xMoedaPMS(nQuantAFA * AFA->AFA_CUSTD,AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)
					Else
						// Aglutina tarefas? Sim / Nao
						// se não aglutina, verifica se jah existe tipo, produto/recurso, projeto, revisao e tarefa no aArrayABC
						If mv_par12 == 2 .AND. (nPosABC := aScan(aArrayABC ,{|x| x[1]==cTipo .And. x[2]==cCodigo .And. x[11]==AFA->AFA_PROJET .AND. x[12]==AFA->AFA_REVISA .AND. x[13]==AFA->AFA_TAREFA }))>0
							aArrayABC[nPosABC ,03] += nQuantAFA
							aArrayABC[nPosABC ,04] += xMoedaPMS(nQuantAFA * AFA->AFA_CUSTD,AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)
						Else
							If cTipo == "REC"
								nCusRealRe:=CalcCusRec(AFA->AFA_RECURS)
								If nCusRealRe=0
									nCusRealRe:= xMoedaPMS(AFA->AFA_CUSTD,AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)
								EndIf

								aAdd(aArrayABC ,{ cTipo,;
											AFA->AFA_RECURS,;
											nQuantAFA,;
											xMoedaPMS(nQuantAFA * AFA->AFA_CUSTD,AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),;
											0,;
											0,;
											0,;
											0,;
											{},;
								 			nCusRealRe,;
								 			AFA->AFA_PROJET,;
								 			AFA->AFA_REVISA,;
								 			AFA->AFA_TAREFA,;
								 			cGrupo })
							Else
								aAdd(aArrayABC ,{ cTipo,;
											SB1->B1_COD,;
											nQuantAFA,;
											xMoedaPMS(nQuantAFA * AFA->AFA_CUSTD,AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),;
											0,;
											0,;
											nQtdEmp,;
											0,;
											{},;
											nValSB1,;
											AFA->AFA_PROJET,;
								 			AFA->AFA_REVISA,;
								 			AFA->AFA_TAREFA,;
								 			SB1->B1_GRUPO } )
								nQtdEmp := 0
							EndIf
						EndIf
					EndIf
					dbSelectArea("AFA")
					dbSkip()
				EndDo

				dbSelectArea("AFB")
				dbSetOrder(1)
				dbSeek(xFilial("AFB") + AF8->AF8_PROJET + cVersao )
				While !Eof() .And. xFilial("AFB") + AF8->AF8_PROJET + cVersao  == AFB->AFB_FILIAL + AFB->AFB_PROJET + AFB->AFB_REVISA
					oReport:IncMeter()

					// verifica a despesa do produto
					AF9->(dbSetOrder(1))
					AF9->(MsSeek(xFilial("AF9") + AFB->AFB_PROJET + AFB->AFB_REVISA + AFB->AFB_TAREFA))

					nValorAFB := PmsPrvAFB(AFB->(RecNo()),mv_par07,mv_par08,AF9->(RecNo()))[1]
					nVal      := xMoedaPMS(nValorAFB,AFB->AFB_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)

					// adiciona informacoes sobre a despesa
					aItemInfo := {}
					aAdd(aItemInfo, "AFB")
					aAdd(aItemInfo, nVal )
					aAdd(aItemInfo, AFB->(AFB_FILIAL+AFB_PROJET+AFB_REVISA+AFB_TAREFA+AFB_ITEM))

					If mv_par12 == 1 // Aglutina tarefas? Sim / Nao
						nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And. x[2]==AFB->AFB_TIPOD})
					Else
						nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And. x[2]==AFB->AFB_TIPOD .And. x[11]+x[12]+x[13]==AFB->(AFB_PROJET+AFB_REVISA+AFB_TAREFA) })
					EndIf

					If nPosABC > 0
						aArrayABC[nPosABC ,04] += nVal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"DSP",AFB->AFB_TIPOD,0,nVal,;
										0,0,0,0,{aItemInfo},0, AFB->AFB_PROJET,AFB->AFB_REVISA,AFB->AFB_TAREFA,cGrupo } )
					EndIf

					dbSelectArea("AFB")
					dbSkip()
				EndDo
			EndIf

			dbSelectArea("AFN")
			dbSetOrder(1)
			dbSeek(xFilial("AFN") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While !Eof() .And. xFilial("AFN") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFN->AFN_FILIAL + AFN->AFN_PROJET + AFN->AFN_REVISA
			    If AFN->(FieldPos("AFN_ESTOQU") > 0) .and. AFN->AFN_ESTOQU == "1"
					oReport:IncMeter()
					SD1->(dbSetOrder(1))
					SD1->(dbSeek(PmsFilial("SD1","AFN")+AFN->AFN_DOC+AFN->AFN_SERIE+AFN->AFN_FORNECE+AFN->AFN_LOJA+AFN->AFN_COD+AFN->AFN_ITEM))
					If (SD1->D1_COD < mv_par09 .Or. SD1->D1_COD > mv_par10)
						dbSelectArea("AFN")
						dbSkip()
						Loop
					Else
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
						If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
							dbSelectArea("AFN")
							dbSkip()
							Loop
						EndIf
						nValSB1 := xMoedaPMS(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
					EndIf

					If SD1->(FieldPos("D1_DTDIGIT")) > 0
						dDataMov	:=	SD1->D1_DTDIGIT
					Else
						dDataMov	:=	SD1->D1_EMISSAO
					Endif

					If dDataMov >= mv_par07 .And. dDataMov <= mv_par08
	            	nValConv := xMoedaPMS(SD1->D1_CUSTO,1,nMoedaPMS,"",,,,,,cTrunca,,"SD1")

						// adiciona informacoes sobre o produto
						aItemInfo := {}
						aAdd(aItemInfo, "AFN")
						aAdd(aItemInfo, AFN->AFN_FORNEC)
						aAdd(aItemInfo, Posicione("SA2", 1, xFilial("SA2") + AFN->AFN_FORNECE + AFN->AFN_LOJA, "A2_NOME"))
						aAdd(aItemInfo, AFN->AFN_DOC)
						aAdd(aItemInfo, AFN->AFN_SERIE)
						aAdd(aItemInfo, AFN->AFN_TIPONF)
						aAdd(aItemInfo, AFN->AFN_QUANT)
						aAdd(aItemInfo, PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT()))
						aAdd(aItemInfo, SD1->D1_EMISSAO)
						aAdd(aItemInfo, AFN->(Recno()))
						aAdd(aItemInfo, SD1->(Recno()))

						If mv_par12 == 1 // Aglutina tarefas? Sim / Nao
							nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD})
						Else
							nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD .And. x[11]+x[12]+x[13]==AFN->(AFN_PROJET+AFN_REVISA+AFN_TAREFA) })
						EndIf

						If nPosABC > 0
							aArrayABC[nPosABC ,05] += Iif(aItemInfo[6]=="C",0,PmsAFNQUANT("QUANT"))
							aArrayABC[nPosABC ,06] += PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT())
							aAdd(aArrayABC[nPosABC ,09], aItemInfo)
						Else
							aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,Iif(aItemInfo[6]=="C",0,PmsAFNQUANT("QUANT"));
												, PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT()),;
												0,0,{aItemInfo},nValSB1,;
												AFN->AFN_PROJET, AFN->AFN_REVISA, AFN->AFN_TAREFA,cGrupo })
						EndIf

					EndIf
				EndIf
				AFN->(dbSkip())
			EndDo

			dbSelectArea("AFS")
			dbSetOrder(1)
			dbSeek(xFilial("AFS") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While AFS->(!Eof()) .And. xFilial("AFS") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFS->AFS_FILIAL + AFS->AFS_PROJET + AFS->AFS_REVISA
				oReport:IncMeter()
				SD2->(dbSetOrder(4))
				SD2->(dbSeek(PmsFilial("SD2","AFS")+AFS->AFS_NUMSEQ))
				If (SD2->D2_COD < mv_par09 .Or. SD2->D2_COD > mv_par10)
					dbSelectArea("AFS")
					dbSkip()
					Loop
				Else
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial()+SD2->D2_COD))
					If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
						dbSelectArea("AFS")
						dbSkip()
						Loop
					EndIf
					nValSB1 := xMoeda(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS)
					nValSB1 := xMoedaPMS(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
				EndIf

				If SD2->(FieldPos("D2_DTDIGIT") ) > 0 .and. !Empty(SD2->D2_DTDIGIT)
					dDataMov	:=	SD2->D2_DTDIGIT
				Else
					dDataMov	:=	SD2->D2_EMISSAO
				Endif
				If dDataMov >= mv_par07 .And. dDataMov <= mv_par08

					nSinal	:=	iIf(AFS->AFS_MOVPRJ $ '25',1,-1)
					
					nValConv := xMoedaPMS(SD2->D2_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD2")

					// adiciona informacoes sobre o produto
					aItemInfo := {}
					aAdd(aItemInfo, "AFS")
					aAdd(aItemInfo, SD2->D2_CLIENTE)
					aAdd(aItemInfo, Posicione("SA1", 1, xFilial("SA1") + SD2->(D2_CLIENTE+D2_LOJA), "A1_NOME"))
					aAdd(aItemInfo, AFS->AFS_DOC)
					aAdd(aItemInfo, AFS->AFS_SERIE)
					aAdd(aItemInfo, SD2->D2_TIPO)
					aAdd(aItemInfo, AFS->AFS_QUANT)
					aAdd(aItemInfo, nValConv*(PmsAFSQUANT()/SD2->D2_QUANT)*nSinal)
					aAdd(aItemInfo, dDataMov)
					aAdd(aItemInfo, AFS->(Recno()))
					aAdd(aItemInfo, SD2->(Recno()))

					If mv_par12 == 1 // Aglutina tarefas? Sim / Nao
						nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD})
					Else
						nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD .And. x[11]+x[12]+x[13]==AFS->(AFS_PROJET+AFS_REVISA+AFS_TAREFA) })
					EndIf

					If nPosABC > 0
						aArrayABC[nPosABC ,05] += AFS->AFS_QUANT
						aArrayABC[nPosABC ,06] += nValConv*(PmsAFSQUANT()/SD2->D2_QUANT)*nSinal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"SB1",SB1->B1_COD,;
												0,;
												0,;
												AFS->AFS_QUANT,;
												nValConv*(PmsAFSQUANT()/SD2->D2_QUANT)*nSinal,;
												0,;
												0,;
												{aItemInfo},;
												nValSB1,;
									 			AFS->AFS_PROJET, AFS->AFS_REVISA, AFS->AFS_TAREFA,cGrupo })
					EndIf

				EndIf
				AFS->(dbSkip())
			EndDo

			dbSelectArea("AFI")
			dbSetOrder(1)
			MsSeek(xFilial()+AF8->AF8_PROJET+AF8->AF8_REVISA)
			While !Eof().And.AFI_FILIAL+AFI_PROJET+AFI_REVISA==;
				xFilial("AFI")+AF8->AF8_PROJET+AF8->AF8_REVISA

				oReport:IncMeter()
				SD3->(dbSetOrder(7))
				If SD3->(dbSeek(PmsFilial("SD3","AFI")+AFI->AFI_COD+AFI->AFI_LOCAL+DTOS(AFI->AFI_EMISSA)+AFI->AFI_NUMSEQ)) ;
					.And. !(SD3->D3_ESTORNO == "S") .And. !(SD3->D3_CF == "RE5")

					If SD3->D3_EMISSAO >= mv_par07 .And. SD3->D3_EMISSAO <= mv_par08

						If (SD3->D3_COD < mv_par09 .Or. SD3->D3_COD > mv_par10)
							dbSelectArea("AFI")
							dbSkip()
							Loop
						Endif

						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial()+SD3->D3_COD))
						//filtro de usuario em cima da tabela SB1
						If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
							dbSelectArea("AFI")
							dbSkip()
							Loop
						EndIf
						nValSB1 := xMoedaPMS(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,,"SB1")

						// adiciona informacao sobre o produto
						aItemInfo := {}
						aAdd(aItemInfo, "SD3")
						aAdd(aItemInfo, SD3->D3_EMISSAO)
						aAdd(aItemInfo, SD3->D3_DOC)
						aAdd(aItemInfo, SD3->D3_NUMSERI)
						aAdd(aItemInfo, SD3->D3_OP)
						aAdd(aItemInfo, SD3->D3_TIPO)
						aAdd(aItemInfo, SD3->D3_TM)
						If SD3->D3_TM > "500"
							aAdd(aItemInfo, SD3->D3_QUANT)
							If AF8->AF8_TPCUS=="2"
								aAdd(aItemInfo, xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3") )
							Else
								aAdd(aItemInfo, xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3") )
							EndIf
						Else
							aAdd(aItemInfo, SD3->D3_QUANT*-1)
							If AF8->AF8_TPCUS=="2"
								aAdd(aItemInfo, xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,) )
							Else
								aAdd(aItemInfo, xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,) )
							EndIf
						EndIf
						aAdd(aItemInfo, SD3->(Recno()))

						If mv_par12 == 1 // Aglutina tarefas? Sim / Nao
							nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD})
						Else
							nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD .And. x[11]+x[12]+x[13]==AFI->(AFI_PROJET+AFI_REVISA+AFI_TAREFA) })
						EndIf

						If nPosABC > 0
							If SD3->D3_TM > "500"
								aArrayABC[nPosABC ,05] += SD3->D3_QUANT
								If AF8->AF8_TPCUS=="2"
									aArrayABC[nPosABC ,06] += xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")
								Else
									aArrayABC[nPosABC ,06] += xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")
								EndIf
							Else
								aArrayABC[nPosABC ,05] += SD3->D3_QUANT*-1
								If AF8->AF8_TPCUS=="2"
									aArrayABC[nPosABC ,06] += xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")*-1
								Else
									aArrayABC[nPosABC ,06] += xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3") *-1
								EndIf
							EndIf
							aAdd(aArrayABC[nPosABC ,09], aItemInfo)
						Else
							If SD3->D3_TM > "500"
								If AF8->AF8_TPCUS=="2"
									aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,SD3->D3_QUANT,xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,);
									,0,0,{aItemInfo},nValSB1,;
															AFI->AFI_PROJET, AFI->AFI_REVISA, AFI->AFI_TAREFA,SB1->B1_GRUPO })
								Else
									aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,SD3->D3_QUANT,xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3"),0,0,{aItemInfo},nValSB1,;
															AFI->AFI_PROJET, AFI->AFI_REVISA, AFI->AFI_TAREFA,SB1->B1_GRUPO })
								EndIf
							Else
								If AF8->AF8_TPCUS=="2"
									aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,SD3->D3_QUANT*-1,xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")*-1,0,0,{aItemInfo},nValSB1,;
															AFI->AFI_PROJET, AFI->AFI_REVISA, AFI->AFI_TAREFA,SB1->B1_GRUPO })
								Else
									aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,SD3->D3_QUANT*-1,xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")*-1,0,0,{aItemInfo},nValSB1,;
															AFI->AFI_PROJET, AFI->AFI_REVISA, AFI->AFI_TAREFA,SB1->B1_GRUPO })
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				dbSelectArea("AFI")
				dbSkip()
			EndDo

			dbSelectArea("AFU")
			dbSetOrder(1)
			dbSeek(xFilial("AFU")+"1"+AF8->(AF8_PROJET+AF8_REVISA))
			While !Eof().And.AFU->(AFU_FILIAL+AFU_CTRRVS+AFU_PROJET+AFU_REVISA)==;
								xFilial("AFU")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA
				oReport:IncMeter()
				lRecProd := .F.
				If AFU->AFU_DATA >= mv_par07 .And. AFU->AFU_DATA <= mv_par08
					If !Empty(AFU->AFU_COD)
						If (AFU->AFU_COD < mv_par09 .Or. AFU->AFU_COD > mv_par10)
							dbSelectArea("AFU")
							dbSkip()
							Loop
						Else
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial("SB1")+AFU->AFU_COD))
							If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
								dbSelectArea("AFU")
								dbSkip()
								Loop
							EndIf
						Endif
					ElseIf MV_PAR14 == 2 .and. Empty(AFU->AFU_COD)
						dbSelectArea("AE8")
						DbSetOrder(1)
						If dbseek(xFilial("AE8")+AFU->AFU_RECURS)
							If !EMPTY(AE8->AE8_PRODUT)
								If (AE8->AE8_PRODUT < mv_par09 .Or. AE8->AE8_PRODUT > mv_par10)
									dbSelectArea("AFU")
									dbSkip()
									Loop
								Else
									SB1->(dbSetOrder(1))
							      SB1->(dbSeek(xFilial("SB1")+AE8->AE8_PRODUT))
							      If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
								     dbSelectArea("AFU")
								     dbSkip()
								     Loop
							      EndIf
								EndIf
								lRecProd := .T.
							ENDIF
					 	Endif
					EndIf

					aItemInfo := {}
					aAdd(aItemInfo, "AFU")
					aAdd(aItemInfo, AFU->AFU_RECURS)
					aAdd(aItemInfo, Posicione("AE8", 1, xFilial() + AFU->AFU_RECURS, "AE8_DESCRI"))
					aAdd(aItemInfo, Posicione("AE8", 1, xFilial() + AFU->AFU_RECURS, "AE8_EQUIP"))
					aAdd(aItemInfo, Posicione("AED", 1, xFilial() + AFU->AFU_RECURS, "AED_DESCRI"))
					aAdd(aItemInfo, AFU->AFU_TAREFA)
					aAdd(aItemInfo, Posicione("AF9", 1, xFilial() + AFU->AFU_PROJET + AFU->AFU_REVISA + AFU->AFU_TAREFA, "AF9_DESCRI"))
					aAdd(aItemInfo, AFU->AFU_DATA)
					aAdd(aItemInfo, AFU->AFU_HORAI)
					aAdd(aItemInfo, AFU->AFU_HORAF)
					aAdd(aItemInfo, AFU->AFU_HQUANT)
					aAdd(aItemInfo, AFU->(Recno()))

					// Visualizar Custo Realizado por Produto
					If MV_PAR14 == 2 .and. !Empty(AFU->AFU_COD)
					  cCodigo := AFU->AFU_COD
					  cTipo   := "SB1"
					ElseIf lRecProd
						cCodigo := SB1->B1_COD
						cTipo   := "SB1"
					ElseIf !Empty(AFU->AFU_RECURS)
						cCodigo := AFU->AFU_RECURS
						cTipo   := "REC"
					Else
						cCodigo := AFU->AFU_COD
						cTipo   := "SB1"
					EndIf

					// Aglutina tarefas? Sim / Nao
					// se aglutina, verifica se jah existe no aArrayABC
					nValConv := xMoedaPMS(AFU->AFU_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFU")
					If mv_par12 == 1 .AND. (nPosABC := aScan(aArrayABC,{|x| x[1]==cTipo .And. x[2]==cCodigo}))>0
						aArrayABC[nPosABC ,05] += AFU->AFU_HQUANT
						aArrayABC[nPosABC ,06] += nValConv
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						// Aglutina tarefas? Sim / Nao
						// se não aglutina, verifica se jah existe tipo, produto/recurso, projeto, revisao e tarefa no aArrayABC
						If mv_par12 == 2 .AND. (nPosABC := aScan(aArrayABC ,{|x| x[1]==cTipo .And. x[2]==cCodigo .And. x[11]==AFU->AFU_PROJET .AND. x[12]==AFU->AFU_REVISA .AND. x[13]==AFU->AFU_TAREFA }))>0
							aArrayABC[nPosABC ,05] += AFU->AFU_HQUANT
							aArrayABC[nPosABC ,06] += nValConv
							aAdd(aArrayABC[nPosABC ,09], aItemInfo)
						Else
							If cTipo == "REC"
								aAdd(aArrayABC,{"REC",AFU->AFU_RECURS,0,0,AFU->AFU_HQUANT,nValConv,0,0,{aItemInfo},0,;
														AFU->AFU_PROJET, AFU->AFU_REVISA, AFU->AFU_TAREFA,cGrupo })
							Else
								aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,AFU->AFU_HQUANT,nValConv,0,0,{aItemInfo},0,;
														AFU->AFU_PROJET, AFU->AFU_REVISA, AFU->AFU_TAREFA,cGrupo })
							EndIf
						EndIf

					EndIf
				EndIf
			    dbSelectArea("AFU")
				dbSkip()
			EndDo

			If PmsCHkAJC(.F.)
				dbSelectArea("AJC")
				dbSetOrder(1)
				dbSeek(xFilial()+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA)
				While !Eof().And.AJC->AJC_FILIAL+AJC->AJC_CTRRVS+AJC->AJC_PROJET+AJC->AJC_REVISA==;
									xFilial("AJC")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA
					oReport:IncMeter()
					If AJC->AJC_DATA >= mv_par07 .And. AJC->AJC_DATA <= mv_par08
						If AJC->AJC_TIPO=="1"
							If (AJC->AJC_COD < mv_par09 .Or. AJC->AJC_COD > mv_par10)
								dbSelectArea("AJC")
								dbSkip()
								Loop
							Else
								SB1->(dbSetOrder(1))
								SB1->(dbSeek(xFilial()+AJC->AJC_COD))
								If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
									dbSelectArea("AJC")
									dbSkip()
									Loop
								EndIf
								nValSB1 := xMoedaPMS(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
							EndIf
						EndIf

						nValConv := xMoedaPMS(AJC->AJC_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"AJC")

						aItemInfo := {}
						aAdd(aItemInfo, "AJC")
						aAdd(aItemInfo, AJC->AJC_TIPO)
						aAdd(aItemInfo, If(AJC->AJC_TIPO=="1",AJC->AJC_COD,AJC->AJC_TIPOD))
						aAdd(aItemInfo, If(AJC->AJC_TIPO=="1",Posicione("SB1", 1, xFilial() + AJC->AJC_COD, "B1_DESC"),AJC->AJC_DESCRI))
						aAdd(aItemInfo, AJC->AJC_TAREFA)
						aAdd(aItemInfo, Posicione("AF9", 1, xFilial() + AJC->AJC_PROJET + AJC->AJC_REVISA + AJC->AJC_TAREFA, "AF9_DESCRI"))
						aAdd(aItemInfo, nValConv )  // &("AJC->AJC_CUSTO"+Str(nMoedaPMS,1))) // xMoedaPMS(AJC->AJC_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,) )
						aAdd(aItemInfo, AJC->AJC_QUANT)
						aAdd(aItemInfo, AJC->(Recno()))

                  lAdic := .T.
                  If mv_par12 == 1 // Aglutina tarefas? Sim / Nao
							If AJC->AJC_TIPO=="1"
								nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1".And.x[2]==SB1->B1_COD})
							Else
								nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And.x[2]==AJC->AJC_TIPOD})
							EndIf
							If nPosABC > 0
								aArrayABC[nPosABC ,05] += AJC->AJC_QUANT
								aArrayABC[nPosABC ,06] += nValConv // &("AJC->AJC_CUSTO"+Str(nMoedaPMS,1)) // xMoedaPMS(AJC->AJC_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,)
								aAdd(aArrayABC[nPosABC ,09],aItemInfo)
								lAdic := .F.
							EndIf
						EndIf

						If lAdic
							If AJC->AJC_TIPO=="1"
								aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,AJC->AJC_QUANT,nValConv,0,0,{aItemInfo},nValSB1,;
														AJC->AJC_PROJET, AJC->AJC_REVISA, AJC->AJC_TAREFA,SB1->B1_GRUPO })
							Else
								aAdd(aArrayABC,{"DSP",AJC->AJC_TIPOD,0,0,AJC->AJC_QUANT,nValConv,0,0,{aItemInfo},0,;
														AJC->AJC_PROJET, AJC->AJC_REVISA, AJC->AJC_TAREFA,cGrupo })
							EndIf
						EndIf
					Endif
					dbSelectArea("AJC")
					dbSkip()
				EndDo
			EndIf

			dbSelectArea("AFR")
			dbSetOrder(1)
			dbSeek(xFilial("AFR") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While !Eof() .And. xFilial("AFR") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFR->AFR_FILIAL + AFR->AFR_PROJET + AFR->AFR_REVISA
				oReport:IncMeter()
				If 	SE2->(dbSeek(PmsFilial("SE2","AFR")+AFR->AFR_PREFIXO+AFR->AFR_NUM+AFR->AFR_PARCELA+AFR->AFR_TIPO+AFR->AFR_FORNEC+AFR->AFR_LOJA)) .And.;
					SE2->E2_EMIS1 >= mv_par07 .And. SE2->E2_EMIS1 <= mv_par08
					aItemInfo := {}
					If (SE2->E2_TIPO $ MVABATIM+"/"+MV_CPNEG)		 // Se nao for abatimento
						nSinal :=	-1
					Else
						nSinal :=	1
					EndIf
					aAdd(aItemInfo, "AFR")
					aAdd(aItemInfo, AFR->AFR_FORNEC)
					aAdd(aItemInfo, Posicione("SA2", 1, xFilial("SA2") + AFR->AFR_FORNEC, "A2_NOME"))
					aAdd(aItemInfo, AFR->AFR_NUM)
					aAdd(aItemInfo, AFR->AFR_DATA)
					aAdd(aItemInfo, AFR->AFR_VENREA)
					aAdd(aItemInfo, xMoedaPMS(AFR->AFR_VALOR1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFR") *nSinal)
					aAdd(aItemInfo, AFR->(Recno()))
					aAdd(aItemInfo, SE2->(Recno()))

					// Aglutina tarefas? Sim / Nao

					If mv_par12 == 1 .AND. (nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And. x[2]==AFR->AFR_TIPOD}))>0
						aArrayABC[nPosABC ,06] += xMoedaPMS(AFR->AFR_VALOR1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFR") * nSinal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						SX5->(dbSetOrder(1))
						SX5->(dbSeek(xFilial()+"FD"+AFR->AFR_TIPOD))
						aAdd(aArrayABC,{"DSP",AFR_TIPOD,0,0,0,;
						xMoedaPMS(AFR->AFR_VALOR1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFR")*nSinal,;
						0,0, {aItemInfo},0,;
												AFR->AFR_PROJET, AFR->AFR_REVISA, AFR->AFR_TAREFA,cGrupo })
					EndIf
				EndIf
				dbSelectArea("AFR")
				dbSkip()
			EndDo

			SE5->(dbSetOrder(9))
			dbSelectArea("AJE")
			dbSetOrder(1)
			MsSeek(xFilial()+AF8->AF8_PROJET + AF8->AF8_REVISA ,.T.)
			While !Eof().And.AJE_FILIAL+AJE_PROJET+AJE_REVISA==;
							xFilial("AJE")+AF8->AF8_PROJET + AF8->AF8_REVISA
				oReport:IncMeter()
				If SE5->(dbSeek(xFilial()+AJE->AJE_ID)) .And.!(SE5->E5_SITUACA == "C") .And. (SE5->E5_RECPAG == "P") .And.;
				   SE5->E5_DATA >= mv_par07 .And. SE5->E5_DATA <= mv_par08

					nValConv := xMoedaPMS(AJE->AJE_VALOR,1,nMoedaPMS,"",,,,,,cTrunca,,"AJE")

					aItemInfo := {}
					aAdd(aItemInfo, "SE5")
					aAdd(aItemInfo, SE5->E5_AGENCIA)
					aAdd(aItemInfo, SE5->E5_CONTA)
					aAdd(aItemInfo, nValConv )
					aAdd(aItemInfo, SE5->E5_NUMERO)
					aAdd(aItemInfo, SE5->E5_VENCTO)
					aAdd(aItemInfo, SE5->E5_NUMCHEQ)
					aAdd(aItemInfo, /*SA6->A6_NOME*/)
					aAdd(aItemInfo, AJE->(Recno()))
					aAdd(aItemInfo, SE5->(Recno()))

					// Aglutina tarefas? Sim / Nao
					If mv_par12 == 1 .AND. (nPosABC := aScan(aArrayABC,{|x| x[1]=="MOV"}))>0
						aArrayABC[nPosABC ,06] += nValConv
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"MOV","",0,0,0,nValConv,0,0, {aItemInfo},0,;
												AJE->AJE_PROJET, AJE->AJE_REVISA, AJE->AJE_TAREFA,cGrupo })
					EndIf
				EndIf
				dbSelectArea("AJE")
				dbSkip()
			EndDo

			If Len(aArrayABC) > 0
                         
				aArrayABC := u_ScanSCPC2(aArrayABC)
				
				oProjeto:PrintLine()
				oReport:SkipLine()

				If nOrder == 3
					aArrayABC := aSort(aArrayABC,,,{|x,y| x[14]+x[2] < y[14]+y[2] })
				Else
					aArrayABC := aSort(aArrayABC,,,{|x,y| x[2] < y[2]})
				EndIf

				oTarefaRec:Init()

				For nx := 1 to Len(aArrayABC)

					If nOrder == 3 .And. cGrupoAnt != aArrayABC[nx ,14]
						oGrupoProd:Init()
						oGrupoProd:PrintLine()
						cGrupoAnt := aArrayABC[nx ,14]
						oGrupoProd:Finish()
					EndIf

					Do Case
						Case aArrayABC[nx,1]=="SB1"
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial("SB1")+aArrayABC[nx,2]))
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							If aArrayABC[nx,7] > 0
								nTotEmp += aArrayABC[nx,7]
							EndIf
							nPercAcm2 += aArrayABC[nx,6]/nCustoReal*100
							nQtdeRepo:= (aArrayABC[nx,3]-aArrayABC[nx,5])
							// Saldo com o calculo do Custo Previsto
							If mv_par11 == 1 //Custo Atual
								If aArrayABC[nx,10]>0
									nValRepo := aArrayABC[nx,10]
									nTotRepo += nValRepo*nQtdeRepo
								Else
									nValRepo := aArrayABC[nx,4]-aArrayABC[nx,6]
									nTotRepo += nValRepo
								EndIf
							EndIf

							oTarefaRec:PrintLine()

							// impressao dos detalhes do apontamento

							// os detalhes do apontamento sao armazenados no elemento
							// de indice 9 do aArrayABC
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								oTarefaAFN:Init()
								oTarefaAFS:Init()
								oTarefaSD3:Init()
								oTarefaAFU:Init()
								For nY := 1 To Len(aArrayABC[nX, 9])
									Do Case
										Case aArrayABC[nx, 9, ny, 1] == "AFN"
											AFN->(MsGoTo(aArrayABC[nx, 9, ny, 10]))
											SD1->(MsGoTo(aArrayABC[nx, 9, ny, 11]))
											oTarefaAFN:PrintLine()
										Case aArrayABC[nx, 9, ny, 1] == "AFS"
											AFS->(MsGoTo(aArrayABC[nx, 9, ny, 10]))
											SD2->(MsGoTo(aArrayABC[nx, 9, ny, 11]))
											oTarefaAFS:PrintLine()
										// Movimentacoes Internas
										Case aArrayABC[nx, 9, ny, 1] == "SD3"
											SD3->(MsGoTo(aArrayABC[nx, 9, ny, 10]))
											oTarefaSD3:PrintLine()
										// Apontamento de Recursos
										Case aArrayABC[nx, 9, ny, 1] == "AFU"
											AFU->(MsGoTo(aArrayABC[nx, 9, ny, 12]))
											oTarefaAFU:PrintLine()
									EndCase
								Next nY
								oTarefaAFU:Finish()
								oTarefaAFN:Finish()
								oTarefaAFS:Finish()
								oTarefaSD3:Finish()
							EndIf

						Case aArrayABC[nx,1]=="DSP"
							SX5->(dbSetOrder(1))
							SX5->(dbSeek(xFilial()+"FD"+aArrayABC[nx,2]))

							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							nPercAcm2 += aArrayABC[nx,6]/nCustoReal*100

							oTarefaRec:PrintLine()

							// Saldo com o calculo do Custo Atual
							If mv_par11 == 1
								nTotRepo += aArrayABC[nx,4]
							EndIf

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								oTarefaAFR:Init()
								oTarefaAFB:Init()
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Despesas Financeiras
										Case aArrayABC[nx, 9, ny, 1] == "AFR"
											AFR->(MsGoTo(aArrayABC[nx, 9, ny, 8]))
											SE2->(MsGoTo(aArrayABC[nx, 9, ny, 9]))
											oTarefaAFR:PrintLine()
										// Despesas da Tarefa
										Case aArrayABC[nx, 9, ny, 1] == "AFB"
											oTarefaAFB:PrintLine()
									EndCase
								Next
								oTarefaAFR:Finish()
								oTarefaAFB:Finish()
							EndIf

						Case aArrayABC[nx,1]=="MOV"

							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							nPercAcm2 += aArrayABC[nx,6]/nCustoReal*100

							oTarefaRec:PrintLine()

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								oTarefaSE5:Init()
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// movimento bancario
										Case aArrayABC[nx, 9, ny, 1] == "SE5"
											AJE->(MsGoTo(aArrayABC[nx, 9, ny, 9]))
											SE5->(MsGoTo(aArrayABC[nx, 9, ny, 10]))
											oTarefaSE5:PrintLine()
									EndCase
								Next nY
								oTarefaSE5:Finish()
							EndIf

						Case aArrayABC[nx,1]=="REC"
							AE8->(dbSetOrder(1))
							AE8->(dbSeek(xFilial()+aArrayABC[nx,2]))
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							nPercAcm2 += aArrayABC[nx,6]/nCustoReal*100
							nQtdeRepo := (aArrayABC[nx,3]-aArrayABC[nx,5])
							If mv_par11 == 1 //Custo Atual
								If aArrayABC[nx,10]>0
									nValRepo:=aArrayABC[nx,10]
									nTotRepo += nValRepo*nQtdeRepo
								Else
									nValRepo:=aArrayABC[nx,4]-aArrayABC[nx,6]
									nTotRepo += nValRepo
								EndIf
							EndIf

							oTarefaRec:PrintLine()

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								oTarefaAFU:Init()
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Apontamento de Recursos
										Case aArrayABC[nx, 9, ny, 1] == "AFU"
											AFU->(MsGoTo(aArrayABC[nx, 9, ny, 12]))
											oTarefaAFU:PrintLine()
									EndCase
								Next nY
								oTarefaAFU:Finish()
							EndIf

					EndCase
					nPrvPer += aArrayABC[nx,4]
					nRealPer+= aArrayABC[nx,6]

					If nOrder == 3 .And. nX < Len(aArrayABC) .And. aArrayABC[nx+1,14] != cGrupoAnt
						oTarefaRec:Finish()
						oTarefaRec:Init()
					EndIf

				Next nX

				oTarefaRec:Finish()
				If nOrder == 3
					oGrupoProd:Finish()
				EndIf

				oReport:SkipLine(2)
				oReport:ThinLine()
				oReport:PrintText(STR0038, oReport:Row(), 0) // "Totais por Periodo"
				oReport:PrintText(Transform( nPrvPer,  "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_CUSTD"):ColPos() )
				oReport:PrintText(Transform( nRealPer, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_CUSTD2"):ColPos() )

				// Saldo com o calculo do Custo Previsto
				If mv_par11 == 2
					oReport:PrintText(Transform( nPrvPer-nRealPer, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_QUANT6"):ColPos() )
				// Saldo com o calculo do Custo Atual
				Else
					nTotDsp	:=0
					For nFaz:=1 to Len(aArrayABC)
						If aArrayABC[nFaz ,01]=="DSP"
							nTotDsp+=aArrayABC[nFaz ,06]
						EndIf
					Next nFaz
					oReport:PrintText(Transform( nTotRepo-nTotDsp, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_QUANT6"):ColPos() )
				EndIf

				oReport:SkipLine()
				oReport:ThinLine()
				oReport:PrintText(STR0039, oReport:Row(), 0) //"Totais por Projeto"
				oReport:PrintText(Transform( nCustoPrj, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_CUSTD"):ColPos() )
				oReport:PrintText(Transform( nCustoReal, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_CUSTD2"):ColPos() )

				// Saldo com o calculo do Custo Previsto
				If mv_par11 == 2
					oReport:PrintText(Transform( nCustoPrj-nCustoReal, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_QUANT6"):ColPos() )
				EndIf
				oReport:SkipLine()
				oReport:ThinLine()

			EndIf

		Case nOrder == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³tratamento para projetos que usam composicao aux  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaAJT
				dbSelectArea( "AF9" )
				AF9->( DbSetOrder( 1 ) )
				If AF9->( DbSeek( xFilial( "AF9" ) + AF8->AF8_PROJET + AF8->AF8_REVISA ) )
					While AF9->( !Eof() ) .And. xFilial( "AF9" ) + AF8->AF8_PROJET + AF8->AF8_REVISA == AF9->AF9_FILIAL + AF9->AF9_PROJET + AF9->AF9_REVISA
						DbSelectArea( "AEL" )
						AEL->( DbSetOrder( 1 ) )
						If AEL->( DbSeek( xFilial( "AEL" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_TAREFA ) ) )
							While AEL->( !Eof() ) .AND. xFilial( "AEL" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_TAREFA ) == AEL->( AEL_FILIAL + AEL_PROJET + AEL_REVISA + AEL_TAREFA )

								DbSelectArea( "AJY" )
								AJY->( DbSetOrder( 1 ) )
								If AJY->( DbSeek( xFilial( "AJY" ) + AEL->( AEL_PROJET + AEL_REVISA + AEL_INSUMO ) ) )
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³filtra o produto conforme os parametros³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If AJY->AJY_PRODUT < mv_par09 .OR. AJY->AJY_PRODUT > mv_par10
										AEL->( DbSkip() )
										Loop
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Filtra os insumos conforme os parametros³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If AJY->AJY_INSUMO < MV_PAR15 .AND. AJY->AJY_INSUMO > MV_PAR16
										AEL->( DbSkip() )
										Loop
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³verifica o empenho do produto³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
									AFJ->(MsSeek(xFilial("AFJ") + AF9->AF9_PROJET + AJY->AJY_PRODUT))
									While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AF9->AF9_PROJET .AND.;
									       AFJ->AFJ_COD == AJY->AJY_PRODUT
										nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
										AFJ->(DbSkip())
									EndDo

									nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,AJY->AJY_CUSTD,nDecCst,),Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,)

									DbSelectArea( "SB1" )
									SB1->( DbSetOrder( 1 ) )
									If SB1->( DbSeek( xFilial( "SB1" ) + AJY->AJY_PRODUT ) )
										If AF9->AF9_HUTEIS > 0
											nPerc		:= (PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR08)-PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR07-1))/AF9->AF9_HDURAC
										Else
											If mv_par06 <= AF9->AF9_START .And. mv_par07 >= AF9->AF9_FINISH
												nPerc	:= 1
											Else
												nPerc	:= 0
											EndIf
										EndIf

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Verifica a quantidade da tarefa.³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										// Obtem a quantidade
										If ExistTemplate( "CCTAF3QUANT" ) .AND. ( GetMV( "MV_PMSCCT" ) == "2" )
											nQuantAFA := ExecTemplate( "CCTAFAQUANT",.F.,.F.,{AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,AJY->AJY_PRODUT,AF9->AF9_QUANT,AEL->AEL_QUANT}) * nPerc
										Else
											nQuantAFA := IIf( GetMV( "MV_PMSCCT" ) == "1", AEL->AEL_QUANT, AEL->AEL_QUANT * AF9->AF9_QUANT ) * nPerc
										EndIf

										nPosABC := aScan(aArrayABC ,{|x| x[1] == "SB1" + AF9->AF9_TAREFA .And. x[2] == SB1->B1_COD } )
										nValConv := xMoedaPMS(nQuantAFA * AJY->AJY_CUSTD,Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,)
										If nPosABC > 0
											aArrayABC[nPosABC ,03] += nQuantAFA
// ALDO AQUI											aArrayABC[nPosABC ,04] += PmsTrunca(cTrunca,nQuantAFA * AJY->AJY_CUSTD,nDecCst,AF9->AF9_QUANT)
											aArrayABC[nPosABC ,04] += nValConv
										Else
											aAdd(aArrayABC,{"SB1"+AF9->AF9_TAREFA,;
															SB1->B1_COD,;
															nQuantAFA,;
															nValConv,; // PmsTrunca(cTrunca,nQuantAFA * AJY->AJY_CUSTD,nDecCst,AF9->AF9_QUANT),;
															AF9->AF9_TAREFA,;
															0,;
															0,;
															nQtdEmp,;
															{},;
															nValSB1 })

											nQtdEmp := 0
										EndIf
									EndIf
								EndIf

								AEL->( DbSkip() )
							End
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica as despesas.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea( "AJV" )
						AJV->( DbSetOrder( 2 ) )
						If AJV->( DbSeek( xFilial( "AJV" ) + AF9->AF9_PROJET + AF9->AF9_REVISA + AF9->AF9_COMPUN ) )
							While AJV->( !Eof() ) .And. ( xFilial( "AJV" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_COMPUN ) == AJV->( AJV_FILIAL + AJV_PROJET + AJV_REVISA + AJV_COMPUN ) )
								If AF9->AF9_HUTEIS > 0
									nPerc		:= (PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR08)-PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR07-1))/AF9->AF9_HDURAC
								Else
									If dDataDe <= AF9->AF9_START .And. dDataAte >= AF9->AF9_FINISH
										nPerc	:= 1
									Else
										nPerc	:= 0
									EndIf
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica o valor da despesa.³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If ExistTemplate("CCTAFBVLR") .And. (GetMV("MV_PMSCCT") == "2")
									nValorAFB := ExecTemplate("CCTAFBVLR",.F.,.F.,{AF9->AF9_QUANT,AJV->AJV_VALOR,.F.}) * nPerc
								Else
									nValorAFB := IIf( GetMV("MV_PMSCUST") == "1", AJV->AJV_VALOR, AF9->AF9_QUANT * AJV->AJV_VALOR ) * nPerc
								EndIf

								nVal      := PmsTrunca(cTrunca,xMoedaPMS(nValorAFB,AJV->AJV_MOEDA,nMoedaPMS,"",,,,,,cTrunca,) ,nDecCst,AF9->AF9_QUANT)

								// adiciona informacoes sobre a despesa
								aItemInfo := {}
								aAdd(aItemInfo, "AFB")
								aAdd(aItemInfo, nVal)
								aAdd(aItemInfo, AJV->(AJV_FILIAL+AJV_PROJET+AJV_REVISA+AJV_TAREFA+AJV_ITEM))

								nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" + AF9->AF9_TAREFA .And. x[2]==AJV->AJV_TIPOD})
								If nPosABC > 0
									aArrayABC[nPosABC ,04] += nVal
									aAdd(aArrayABC[nPosABC ,09], aItemInfo)
								Else
									aAdd(aArrayABC,{"DSP"+AF9->AF9_TAREFA,;
													AJV->AJV_TIPOD,;
													0,;
													nVal ,;
													AF9->AF9_TAREFA,;
													0,;
													0,;
													0,;
													{aItemInfo},;
													0 })
								EndIf

								AJV->( DbSkip() )
								IncProc()
							End
						EndIf

						AF9->( DbSkip() )
						IncProc()
					End
			    EndIf
			Else
				dbSelectArea("AFA")
				dbSetOrder(1)
				dbSeek(xFilial("AFA") + AF8->AF8_PROJET + cVersao )
				While !Eof() .And. xFilial("AFA") + AF8->AF8_PROJET + cVersao  == AFA->AFA_FILIAL + AFA->AFA_PROJET + AFA->AFA_REVISA
					aItemInfo := {}
					oReport:IncMeter()
	   				If !Empty(AFA->AFA_PRODUT)
						If (AFA->AFA_PRODUT < mv_par09 .Or. AFA->AFA_PRODUT > mv_par10)
							dbSelectArea("AFA")
							dbSkip()
							Loop
						Else
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial()+AFA->AFA_PRODUT))
							If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
								dbSelectArea("AFA")
								dbSkip()
								Loop
							EndIf
							nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
						EndIf
					EndIf

					// verifica o empenho do produto
					AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
					AFJ->(MsSeek(xFilial("AFJ") + AFA->AFA_PROJET + AFA->AFA_PRODUT))
					While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AFA->AFA_PROJET .AND.;
					       AFJ->AFJ_COD == AFA->AFA_PRODUT
						nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
						AFJ->(DbSkip())
					EndDo

					// verifica a quantidade do produto
					AF9->(dbSetOrder(1))
					AF9->(MsSeek(xFilial("AF9") + AFA->AFA_PROJET + AFA->AFA_REVISA + AFA->AFA_TAREFA))
					nQuantAFA := PmsPrvAFA(AFA->(RecNo()),mv_par07,mv_par08,AF9->(RecNo()))

					// Visualizar Custo Previsto por Recurso
					If MV_PAR13 == 1 .AND. !Empty(AFA->AFA_RECURS)
						cCodigo := AFA->AFA_RECURS
						cTipo   := "REC"
					Else
						cCodigo := AFA->AFA_PRODUT
						cTipo   := "SB1"
					EndIf

					nPosABC := aScan(aArrayABC,{|x| x[1]==cTipo+AFA->AFA_TAREFA .And. x[2]==cCodigo})
					If nPosABC > 0
						aArrayABC[nPosABC ,03] += nQuantAFA
						aArrayABC[nPosABC ,04] += xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)
					Else
		    			If cTipo == "REC"
							// Calcula o Custo Real do recurso
							nCusRealRe:=CalcCusRec(AFA->AFA_RECURS)
							If nCusRealRe == 0
								nCusRealRe := AFA->AFA_CUSTD
							EndIf

							aAdd(aArrayABC, {"REC"+AFA->AFA_TAREFA,;
							                 AFA->AFA_RECURS, ;
							                 nQuantAFA,;
							                 xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),;
							                 AFA->AFA_TAREFA,;
							                 0,;
							                 0,;
							                 0,;
							                 {},;
							                 nCusRealRe })
		    			Else
							aAdd(aArrayABC,{"SB1"+AFA->AFA_TAREFA,;
											SB1->B1_COD,;
											nQuantAFA,;
											xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),;
											AFA->AFA_TAREFA,;
											0,;
											0,;
											nQtdEmp,;
											{},;
											nValSB1 })
							nQtdEmp := 0
						EndIf
					EndIf
					dbSelectArea("AFA")
					dbSkip()
				EndDo

				dbSelectArea("AFB")
				dbSetOrder(1)
				dbSeek(xFilial("AFB") + AF8->AF8_PROJET + cVersao )
				While !Eof() .And. xFilial("AFB") + AF8->AF8_PROJET + cVersao  == AFB->AFB_FILIAL + AFB->AFB_PROJET + AFB->AFB_REVISA
					oReport:IncMeter()

					AF9->(dbSetOrder(1))
					AF9->(MsSeek(xFilial("AF9") + AFB->AFB_PROJET + AFB->AFB_REVISA + AFB->AFB_TAREFA))
					nValorAFB := PmsPrvAFB(AFB->(RecNo()),mv_par07,mv_par08,AF9->(RecNo()))[1]
					nVal      := PmsTrunca(cTrunca,xMoedaPMS(nValorAFB,AFB->AFB_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),nDecCst,AF9->AF9_QUANT)


					// adiciona informacoes sobre a despesa
					aItemInfo := {}
					aAdd(aItemInfo, "AFB")
					aAdd(aItemInfo, nVal)
					aAdd(aItemInfo, AFB->(AFB_FILIAL+AFB_PROJET+AFB_REVISA+AFB_TAREFA+AFB_ITEM))

					nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP"+AFB->AFB_TAREFA .And. x[2]==AFB->AFB_TIPOD})
					If nPosABC > 0
						aArrayABC[nPosABC ,04] += nVal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"DSP"+AFB->AFB_TAREFA,;
										AFB->AFB_TIPOD,;
										0,;
										nVal ,;
										AFB->AFB_TAREFA,;
										0,;
										0,;
										0,;
										{aItemInfo},;
										0 })
					EndIf
					dbSelectArea("AFB")
					dbSkip()
				EndDo
			EndIf

			dbSelectArea("AFN")
			dbSetOrder(1)
			dbSeek(xFilial("AFN") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While !Eof() .And. xFilial("AFN") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFN->AFN_FILIAL + AFN->AFN_PROJET + AFN->AFN_REVISA
				If AFN->(FieldPos("AFN_ESTOQU") > 0) .and. AFN->AFN_ESTOQU == "1"
					oReport:IncMeter()
					SD1->(dbSetOrder(1))
					SD1->(dbSeek(PmsFilial("SD1","AFN")+AFN->AFN_DOC+AFN->AFN_SERIE+AFN->AFN_FORNECE+AFN->AFN_LOJA+AFN->AFN_COD+AFN->AFN_ITEM))
					If (SD1->D1_COD < mv_par09 .Or. SD1->D1_COD > mv_par10)
						dbSelectArea("AFN")
						dbSkip()
						Loop
					Else
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial()+SD1->D1_COD))
						If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
							dbSelectArea("AFN")
							dbSkip()
							Loop
						EndIf
						nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
					EndIf

					If SD1->(FieldPos("D1_DTDIGIT")) > 0
						dDataMov	:=	SD1->D1_DTDIGIT
					Else
						dDataMov	:=	SD1->D1_EMISSAO
					Endif

					If dDataMov >= mv_par07 .And. dDataMov <= mv_par08
						nValConv := xMoedaPMS(SD1->D1_CUSTO,1,nMoedaPMS,"",,,,,,cTrunca,,"SD1")

						// adiciona informacoes sobre o produto
						aItemInfo := {}
						aAdd(aItemInfo, "AFN")
						aAdd(aItemInfo, AFN->AFN_FORNEC)
						aAdd(aItemInfo, Posicione("SA2", 1, xFilial("SA2") + AFN->AFN_FORNECE + AFN->AFN_LOJA, "A2_NOME"))
						aAdd(aItemInfo, AFN->AFN_DOC)
						aAdd(aItemInfo, AFN->AFN_SERIE)
						aAdd(aItemInfo, AFN->AFN_TIPONF)
						aAdd(aItemInfo, AFN->AFN_QUANT)
						aAdd(aItemInfo, PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT()))
						aAdd(aItemInfo, SD1->D1_EMISSAO)
						aAdd(aItemInfo, AFN->(Recno()))
						aAdd(aItemInfo, SD1->(Recno()))

						nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1"+AFN->AFN_TAREFA .And. x[2]==SB1->B1_COD})
						If nPosABC > 0
							aArrayABC[nPosABC ,06] += PmsAFNQUANT("QUANT")
							//aArrayABC[nPosABC ,07] += nValConv*(SD1->D1_CUSTO/PmsSD1QUANT())
							aArrayABC[nPosABC ,07] += PmsSD1QUANT()*(nValConv/PmsSD1QUANT())    
							aAdd(aArrayABC[nPosABC ,09], aItemInfo)
						Else
							aAdd(aArrayABC,{"SB1"+AFN->AFN_TAREFA,;
											SB1->B1_COD,;
											0,;
											0,;
											AFN->AFN_TAREFA,;
											PmsAFNQUANT("QUANT"),;
											nValConv*(SD1->D1_CUSTO/PmsSD1QUANT()),;
											0,;
											{aItemInfo},;
											nValSB1 })
						EndIf
					EndIf
				EndIf
				AFN->(dbSkip())
			EndDo

			dbSelectArea("AFS")
			dbSetOrder(1)
			dbSeek(xFilial("AFS") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While AFS->(!Eof()) .And. xFilial("AFS") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFS->AFS_FILIAL + AFS->AFS_PROJET + AFS->AFS_REVISA
				oReport:IncMeter()
				SD2->(dbSetOrder(4))
				SD2->(dbSeek(PmsFilial("SD2","AFS")+AFS->AFS_NUMSEQ))
				If (SD2->D2_COD < mv_par09 .Or. SD2->D2_COD > mv_par10)
					dbSelectArea("AFS")
					dbSkip()
					Loop
				Else
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial()+SD2->D2_COD))
					If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
						dbSelectArea("AFS")
						dbSkip()
						Loop
					EndIf
					nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
				EndIf

				If SD2->(FieldPos("D2_DTDIGIT") ) > 0 .and. !Empty(SD2->D2_DTDIGIT)
					dDataMov	:=	SD2->D2_DTDIGIT
				Else
					dDataMov	:=	SD2->D2_EMISSAO
				Endif
				If dDataMov >= mv_par07 .And. dDataMov <= mv_par08
				
					nSinal	:=	iIf(AFS->AFS_MOVPRJ $ '25',1,-1)
				
					nValConv := xMoedaPMS(SD2->D2_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD2")

					// adiciona informacoes sobre o produto
					aItemInfo := {}
					aAdd(aItemInfo, "AFS")
					aAdd(aItemInfo, SD2->D2_CLIENTE)
					aAdd(aItemInfo, Posicione("SA1", 1, xFilial("SA1") + SD2->(D2_CLIENTE+D2_LOJA), "A1_NOME"))
					aAdd(aItemInfo, AFS->AFS_DOC)
					aAdd(aItemInfo, AFS->AFS_SERIE)
					aAdd(aItemInfo, SD2->D2_TIPO)
					aAdd(aItemInfo, AFS->AFS_QUANT)
					aAdd(aItemInfo, nValConv*(AFS->AFS_QUANT/SD2->D2_QUANT)*nSinal)
					aAdd(aItemInfo, dDataMov)
					aAdd(aItemInfo, AFS->(Recno()))
					aAdd(aItemInfo, SD2->(Recno()))

					nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1"+AFN->AFN_TAREFA .And. x[2]==SB1->B1_COD})
					If nPosABC > 0
						aArrayABC[nPosABC ,06] += AFS->AFS_QUANT
						aArrayABC[nPosABC ,07] += nValConv * ( PmsAFSQUANT()/SD2->D2_QUANT )*nSinal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"SB1"+AFS->AFS_TAREFA,;
										SB1->B1_COD,;
										0,;
										0,;
										AFS->AFS_TAREFA,;
										AFS->AFS_QUANT,;
										nValConv*(PmsAFSQUANT()/SD2->D2_QUANT)*nSinal,;
										0,;
										{aItemInfo},;
										nValSB1 })
					EndIf
				EndIf
				AFS->(dbSkip())
			EndDo

			dbSelectArea("AFI")
			dbSetOrder(1)
			MsSeek(xFilial()+AF8->AF8_PROJET+AF8->AF8_REVISA)
			While !Eof().And.AFI_FILIAL+AFI_PROJET+AFI_REVISA==;
				xFilial("AFI")+AF8->AF8_PROJET+AF8->AF8_REVISA

				oReport:IncMeter()
				SD3->(dbSetOrder(7))
				If SD3->(dbSeek(PmsFilial("SD3","AFI")+AFI->AFI_COD+AFI->AFI_LOCAL+DTOS(AFI->AFI_EMISSA)+AFI->AFI_NUMSEQ)) ;
					.And. !(SD3->D3_ESTORNO == "S") .And. !(SD3->D3_CF == "RE5") .And. SD3->D3_EMISSAO >= mv_par07 .And. SD3->D3_EMISSAO <= mv_par08
					If (SD3->D3_COD < mv_par09 .Or. SD3->D3_COD > mv_par10)
						dbSelectArea("SD3")
						dbSkip()
						Loop
					Endif
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial()+SD3->D3_COD))
					If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
						dbSelectArea("SD3")
						dbSkip()
						Loop
					EndIf
					nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
					nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1"+SD3->D3_TASKPMS .And. x[2]==SB1->B1_COD})

					// adiciona informacao sobre o produto
					nValConv := xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")

					aItemInfo := {}
					aAdd(aItemInfo, "SD3")
					aAdd(aItemInfo, SD3->D3_EMISSAO)
					aAdd(aItemInfo, SD3->D3_DOC)
					aAdd(aItemInfo, SD3->D3_NUMSERI)
					aAdd(aItemInfo, SD3->D3_OP)
					aAdd(aItemInfo, SD3->D3_TIPO)
					aAdd(aItemInfo, SD3->D3_TM)

					If SD3->D3_TM > "500"
						aAdd(aItemInfo, SD3->D3_QUANT)
						If AF8->AF8_TPCUS=="2"
							aAdd(aItemInfo, SD3->D3_CUSFF1)
						Else
							aAdd(aItemInfo, nValConv)
						EndIf
					Else
						aAdd(aItemInfo, SD3->D3_QUANT*-1)
						If AF8->AF8_TPCUS=="2"
							aAdd(aItemInfo, SD3->D3_CUSFF1*-1)
						Else
							aAdd(aItemInfo, nValConv*-1)
						EndIf
					EndIf
					aAdd(aItemInfo, SD3->(Recno()))
					If nPosABC > 0
						If SD3->D3_TM > "500"
							aArrayABC[nPosABC ,06] += SD3->D3_QUANT
							If AF8->AF8_TPCUS=="2"
								aArrayABC[nPosABC ,07] += xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,)
							Else
								aArrayABC[nPosABC ,07] += nValConv
							EndIf
						Else
							aArrayABC[nPosABC ,06] += SD3->D3_QUANT*-1
							If AF8->AF8_TPCUS=="2"
								aArrayABC[nPosABC ,07] += xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,)*-1
							Else
								aArrayABC[nPosABC ,07] += nValConv*-1
							EndIf
						EndIf
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						If SD3->D3_TM > "500"
							If AF8->AF8_TPCUS=="2"
								aAdd(aArrayABC,{"SB1"+SD3->D3_TASKPMS,SB1->B1_COD,0,0,SD3->D3_TASKPMS,SD3->D3_QUANT,;
								xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,),;
								0, {aItemInfo},nValSB1 })
							Else
								aAdd(aArrayABC,{"SB1"+SD3->D3_TASKPMS,SB1->B1_COD,0,0,SD3->D3_TASKPMS,SD3->D3_QUANT,;
										nValConv,0, {aItemInfo},nValSB1 })
							EndIf
						Else
							If AF8->AF8_TPCUS=="2"
								aAdd(aArrayABC,{"SB1"+SD3->D3_TASKPMS,SB1->B1_COD,0,0,SD3->D3_TASKPMS,SD3->D3_QUANT*-1,;
										xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,)*-1,;
										0, {aItemInfo},nValSB1 })
							Else
								aAdd(aArrayABC,{"SB1"+SD3->D3_TASKPMS,SB1->B1_COD,0,0,SD3->D3_TASKPMS,SD3->D3_QUANT*-1,;
										nValConv*-1,0, {aItemInfo},nValSB1 })
							EndIf
						EndIf
					EndIf
				EndIf
				dbSelectArea("AFI")
				dbSkip()
			EndDO

			dbSelectArea("AFU")
			dbSetOrder(1)
			dbSeek(xFilial()+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA)
			While !Eof().And.AFU->AFU_FILIAL+AFU->AFU_CTRRVS+AFU->AFU_PROJET+AFU->AFU_REVISA==;
								xFilial("AFU")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA

				lRecProd := .F.
				If AFU->AFU_DATA >= mv_par07 .And. AFU->AFU_DATA <= mv_par08
					If !Empty(AFU->AFU_COD)
						If (AFU->AFU_COD < mv_par09 .Or. AFU->AFU_COD > mv_par10)
							dbSelectArea("AFU")
							dbSkip()
							Loop
						Else
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial()+AFU->AFU_COD))
							If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
								dbSelectArea("AFU")
								dbSkip()
								Loop
							EndIf
							nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
						EndIf
					ElseIf MV_PAR14 == 2 .and. Empty(AFU->AFU_COD)
						dbSelectArea("AE8")
						DbSetOrder(1)
						If dbseek(xFilial("AE8")+AFU->AFU_RECURS)
							If !EMPTY(AE8->AE8_PRODUT)
								If (AE8->AE8_PRODUT < mv_par09 .Or. AE8->AE8_PRODUT > mv_par10)
									dbSelectArea("AFU")
									dbSkip()
									Loop
								Else
									SB1->(dbSetOrder(1))
									SB1->(dbSeek(xFilial()+AE8->AE8_PRODUT))
									If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
										dbSelectArea("AFU")
										dbSkip()
										Loop
									EndIf
									nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
								EndIf
								lRecProd := .T.
							ENDIF
						Endif
					EndIf

					aItemInfo := {}
					aAdd(aItemInfo, "AFU")
					aAdd(aItemInfo, AFU->AFU_RECURS)
					aAdd(aItemInfo, Posicione("AE8", 1, xFilial() + AFU->AFU_RECURS, "AE8_DESCRI"))
					aAdd(aItemInfo, Posicione("AE8", 1, xFilial() + AFU->AFU_RECURS, "AE8_EQUIP"))
					aAdd(aItemInfo, Posicione("AED", 1, xFilial() + AFU->AFU_RECURS, "AED_DESCRI"))
					aAdd(aItemInfo, AFU->AFU_TAREFA)
					aAdd(aItemInfo, Posicione("AF9", 1, xFilial() + AFU->AFU_PROJET + AFU->AFU_REVISA + AFU->AFU_TAREFA, "AF9_DESCRI"))
					aAdd(aItemInfo, AFU->AFU_DATA)
					aAdd(aItemInfo, AFU->AFU_HORAI)
					aAdd(aItemInfo, AFU->AFU_HORAF)
					aAdd(aItemInfo, AFU->AFU_HQUANT)
					aAdd(aItemInfo, AFU->(Recno()))

					// Visualizar Custo Realizado por Produto
					If MV_PAR14 == 2 .and. !Empty(AFU->AFU_COD)
					  cCodigo := AFU->AFU_COD
					  cTipo   := "SB1"
					ElseIf lRecProd
						cCodigo := SB1->B1_COD
						cTipo   := "SB1"
					ElseIf !Empty(AFU->AFU_RECURS)
						cCodigo := AFU->AFU_RECURS
						cTipo   := "REC"
					Else
						cCodigo := AFU->AFU_COD
						cTipo   := "SB1"
					EndIf

					nPosABC := aScan(aArrayABC,{|x| x[1]==cTipo+AFU->AFU_TAREFA .And. x[2]==cCodigo})
					nValConv := xMoedaPMS(AFU->AFU_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFU")
					If nPosABC > 0
						aArrayABC[nPosABC ,06] += AFU->AFU_HQUANT
						aArrayABC[nPosABC ,07] += nValConv
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						If cTipo == "REC"
							aAdd(aArrayABC,{"REC"+AFU->AFU_TAREFA,AFU->AFU_RECURS,0,0,AFU->AFU_TAREFA,AFU->AFU_HQUANT,nValConv,0, {aItemInfo},0 })
						Else
							aAdd(aArrayABC,{"SB1"+AFU->AFU_TAREFA,SB1->B1_COD,0,0,AFU->AFU_TAREFA,AFU->AFU_HQUANT,nValConv,0, {aItemInfo},nValSB1 })
						EndIf
					EndIf
				EndIf
			    dbSelectArea("AFU")
				dbSkip()
			EndDo
			If PmsChkAJC(.F.)
				dbSelectArea("AJC")
				dbSetOrder(1)
				dbSeek(xFilial()+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA)
				While !Eof().And.AJC->AJC_FILIAL+AJC->AJC_CTRRVS+AJC->AJC_PROJET+AJC->AJC_REVISA==;
									xFilial("AJC")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA
					If AJC->AJC_DATA >= mv_par07 .And. AJC->AJC_DATA <= mv_par08
						If AJC->AJC_TIPO=="1"
							If (AJC->AJC_COD < mv_par09 .Or. AJC->AJC_COD > mv_par10)
								dbSelectArea("AJC")
								dbSkip()
								Loop
							Else
								SB1->(dbSetOrder(1))
								SB1->(dbSeek(xFilial()+AJC->AJC_COD))
								If !Empty(oProjeto:GetAdvplExp()) .And. SB1->(!&(oProjeto:GetAdvplExp()))
									dbSelectArea("AJC")
									dbSkip()
									Loop
								EndIf
								nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,,"SB1")
								nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1"+AJC->AJC_TAREFA .And. x[2]==SB1->B1_COD})
							EndIf
						Else
							nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP"+AJC->AJC_TAREFA .And. x[2]==AJC->AJC_TIPOD})
						EndIf

						nValConv := xMoedaPMS(AJC->AJC_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"AJC")

						If nPosABC > 0
							aArrayABC[nPosABC ,06] += AJC->AJC_QUANT
							aArrayABC[nPosABC ,07] += nValConv
						Else
							If AJC->AJC_TIPO=="1"
								aAdd(aArrayABC,{"SB1"+AJC->AJC_TAREFA,SB1->B1_COD,0,0,AJC->AJC_TAREFA,AJC->AJC_QUANT,nValConv,0,{},nValSB1 })
							Else
								aAdd(aArrayABC,{"DSP"+AJC->AJC_TAREFA,AJC->AJC_TIPOD,0,0,AJC->AJC_TAREFA,AJC->AJC_QUANT,nValConv,0,{},0 })
							EndIf
						EndIf
					EndIf
					dbSelectArea("AJC")
					dbSkip()
				EndDo
			EndIf

			dbSelectArea("AFR")
			dbSetOrder(1)
			dbSeek(xFilial("AFR") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While !Eof() .And. xFilial("AFR") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFR->AFR_FILIAL + AFR->AFR_PROJET + AFR->AFR_REVISA
				oReport:IncMeter()
				If SE2->(dbSeek(PmsFilial("SE2","AFR")+AFR->AFR_PREFIXO+AFR->AFR_NUM+AFR->AFR_PARCELA+AFR->AFR_TIPO+AFR->AFR_FORNEC+AFR->AFR_LOJA)) .And.;
					SE2->E2_EMIS1 >= mv_par07 .And. SE2->E2_EMIS1 <= mv_par08
					aItemInfo := {}
					If (SE2->E2_TIPO $ MVABATIM+"/"+MV_CPNEG)		 // Se nao for abatimento
						nSinal :=	-1
					Else
						nSinal :=	1
					EndIf

					nValConv := xMoedaPMS(AFR->AFR_VALOR1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFR")

					aAdd(aItemInfo, "AFR")
					aAdd(aItemInfo, AFR->AFR_FORNEC)
					aAdd(aItemInfo, Posicione("SA2", 1, xFilial("SA2") + AFR->AFR_FORNEC, "A2_NOME"))
					aAdd(aItemInfo, AFR->AFR_NUM)
					aAdd(aItemInfo, AFR->AFR_DATA)
					aAdd(aItemInfo, AFR->AFR_VENREA)
					aAdd(aItemInfo, nValConv*nSinal)
					aAdd(aItemInfo, AFR->(Recno()))
					aAdd(aItemInfo, SE2->(Recno()))

					nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP"+AFR_TAREFA .And. x[2]==AFR->AFR_TIPOD})
					If nPosABC > 0
						aArrayABC[nPosABC ,07] += nValConv * nSinal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						SX5->(dbSetOrder(1))
						SX5->(dbSeek(xFilial()+"FD"+AFR->AFR_TIPOD))
						aAdd(aArrayABC,{"DSP"+AFR->AFR_TAREFA,AFR_TIPOD,0,0,AFR->AFR_TAREFA,0,AFR->AFR_VALOR1*nSinal,0, {aItemInfo},0 })
					EndIf
				EndIf
				dbSelectArea("AFR")
				dbSkip()
			EndDo

			SE5->(dbSetOrder(9))
			dbSelectArea("AJE")
			dbSetOrder(1)
			MsSeek(xFilial()+AF8->AF8_PROJET + AF8->AF8_REVISA ,.T.)
			While !Eof().And.AJE_FILIAL+AJE_PROJET+AJE_REVISA==;
							xFilial("AJE")+AF8->AF8_PROJET + AF8->AF8_REVISA
				oReport:IncMeter()
				If SE5->(dbSeek(xFilial()+AJE->AJE_ID)) .And.!(SE5->E5_SITUACA == "C") .And. (SE5->E5_RECPAG == "P") .And.;
						SE5->E5_DATA >= mv_par07 .And. SE5->E5_DATA <= mv_par08

					nValConv := xMoedaPMS(AJE->AJE_VALOR,1,nMoedaPMS,"",,,,,,cTrunca,,"AJE")

					aItemInfo := {}
					aAdd(aItemInfo, "SE5")
					aAdd(aItemInfo, SE5->E5_AGENCIA)
					aAdd(aItemInfo, SE5->E5_CONTA)
					aAdd(aItemInfo, AJE->AJE_VALOR)
					aAdd(aItemInfo, SE5->E5_NUMERO)
					aAdd(aItemInfo, SE5->E5_VENCTO)
					aAdd(aItemInfo, SE5->E5_NUMCHEQ)
					aAdd(aItemInfo, /*SA6->A6_NOME*/)
					aAdd(aItemInfo, AJE->(Recno()))
					aAdd(aItemInfo, SE5->(Recno()))

					nPosABC := aScan(aArrayABC,{|x| x[1]=="MOV"+SE5->E5_TASKPMS})
					If nPosABC > 0
						aArrayABC[nPosABC ,07] += nValConv
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"MOV"+SE5->E5_TASKPMS,"",0,0,SE5->E5_TASKPMS,0,nValConv,0, {aItemInfo},0 })
					EndIf
				EndIf
				dbSelectArea("AJE")
				dbSkip()
			EndDo

			If Len(aArrayABC) > 0

				oProjeto:PrintLine()
				oReport:SkipLine()

				aArrayABC := aSort(aArrayABC,,,{|x,y|x[5]+x[2] < y[5]+y[2]})
				If Len(aArrayABC) > 0
					cTrfAtu	:= aArrayABC[1,5]
				EndIf
				oTarefaRec:Init()
				For nx := 1 to Len(aArrayABC)
					AF9->(dbSetOrder(1))
					AF9->(dbSeek(xFilial()+AF8->AF8_PROJET+AF8->AF8_REVISA+aArrayABC[nx,5]))
					Do Case
						Case Substr(aArrayABC[nx,1],1,3)=="SB1"
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial()+aArrayABC[nx,2]))

							If nx == 1 .Or. aArrayABC[nx-1,5]!= cTrfAtu
								oTarefa:Init()
								oTarefa:PrintLine()
								oTarefa:Finish()
							EndIf

							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
			            	If aArrayABC[nx,8] > 0
				               nTotEmp += aArrayABC[nx,8]
				            EndIf
							nPercAcm2 += aArrayABC[nx,7]/nCustoReal*100
							nQtdeRepo:= (aArrayABC[nx,3]-aArrayABC[nx,6])
							If mv_par11 == 1 //Custo Atual
								If aArrayABC[nx,10]>0
									nValRepo := aArrayABC[nx,10]
									nTotRepo += nValRepo*nQtdeRepo
								Else
									nValRepo := aArrayABC[nx,4]-aArrayABC[nx,7]
									nTotRepo += nValRepo
								EndIf
							EndIf

							oTarefaRec:PrintLine()


							// impressao dos detalhes do apontamento

							// os detalhes do apontamento sao armazenados no elemento
							// de indice 9 do aArrayABC
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								oTarefaAFN:Init()
								oTarefaAFS:Init()
								oTarefaSD3:Init()
								oTarefaAFU:Init()
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Nota Fiscal de Entrada
										Case aArrayABC[nx, 9, ny, 1] == "AFN"
											AFN->(MsGoTo(aArrayABC[nx, 9, ny, 10]))
											SD1->(MsGoTo(aArrayABC[nx, 9, ny, 11]))
											oTarefaAFN:PrintLine()
										// Nota Fiscal de Saida
										Case aArrayABC[nx, 9, ny, 1] == "AFS"
											AFN->(MsGoTo(aArrayABC[nx, 9, ny, 10]))
											SD1->(MsGoTo(aArrayABC[nx, 9, ny, 11]))
											oTarefaAFS:PrintLine()
										// Movimentacoes Internas
										Case aArrayABC[nx, 9, ny, 1] == "SD3"
											SD3->(MsGoTo(aArrayABC[nx, 9, ny, 10]))
											oTarefaSD3:PrintLine()
										// Apontamento de Recursos
										Case aArrayABC[nx, 9, ny, 1] == "AFU"
											AFU->(MsGoTo(aArrayABC[nx, 9, ny, 12]))
											oTarefaAFU:PrintLine()
									EndCase
								Next nY
								oTarefaAFN:Finish()
								oTarefaAFS:Finish()
								oTarefaSD3:Finish()
								oTarefaAFU:Finish()
							EndIf

						Case Substr(aArrayABC[nx,1],1,3)=="DSP"
							SX5->(dbSetOrder(1))
							SX5->(dbSeek(xFilial()+"FD"+aArrayABC[nx,2]))
							If nx == 1 .Or. aArrayABC[nx-1,5]!= cTrfAtu
								oTarefa:Init()
								oTarefa:PrintLine()
								oTarefa:Finish()
							EndIf

							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							nPercAcm2 += aArrayABC[nx,7]/nCustoReal*100

							oTarefaRec:Cell("AFA_QUANT" ):Hide()
							oTarefaRec:Cell("AFA_QUANT2" ):Hide()
							oTarefaRec:Cell("AFA_QUANT5" ):Hide()
							oTarefaRec:PrintLine()

							oTarefaRec:Cell("AFA_QUANT" ):Show()
							oTarefaRec:Cell("AFA_QUANT2" ):Show()
							oTarefaRec:Cell("AFA_QUANT5" ):Show()

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								oTarefaAFR:Init()
								oTarefaAFB:Init()
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Despesas Financeiras
										Case aArrayABC[nx, 9, ny, 1] == "AFR"
											AFR->(MsGoTo(aArrayABC[nx, 9, ny, 8]))
											SE2->(MsGoTo(aArrayABC[nx, 9, ny, 9]))
											oTarefaAFR:PrintLine()
										// Despesas da Tarefa
										Case aArrayABC[nx, 9, ny, 1] == "AFB"
											oTarefaAFB:PrintLine()
									EndCase
								Next nY
								oTarefaAFR:Finish()
								oTarefaAFB:Finish()
							EndIf

							nTotRepo += aArrayABC[nx,4]

						Case Substr(aArrayABC[nx,1],1,3)=="MOV"
							If nx == 1 .Or. aArrayABC[nx-1,5]!= cTrfAtu
								oTarefa:Init()
								oTarefa:PrintLine()
								oTarefa:Finish()
							EndIf
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							nPercAcm2 += aArrayABC[nx,7]/nCustoReal*100

							oTarefaRec:Cell("AFA_QUANT" ):Hide()
							oTarefaRec:Cell("AFA_QUANT5" ):Hide()
							oTarefaRec:Cell("AFA_QUANT6" ):Hide()

							oTarefaRec:PrintLine()

							oTarefaRec:Cell("AFA_QUANT" ):Show()
							oTarefaRec:Cell("AFA_QUANT5" ):Show()
							oTarefaRec:Cell("AFA_QUANT6" ):Show()

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								oTarefaSE5:Init()
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// movimento bancario
										Case aArrayABC[nx, 9, ny, 1] == "SE5"
											AJE->(MsGoTo(aArrayABC[nx, 9, ny, 9]))
											SE5->(MsGoTo(aArrayABC[nx, 9, ny, 10]))
											oTarefaSE5:PrintLine()

									EndCase
								Next
								oTarefaSE5:Finish()
							EndIf

						Case Substr(aArrayABC[nx,1],1,3)=="REC"
							AE8->(dbSetOrder(1))
							AE8->(dbSeek(xFilial()+aArrayABC[nx,2]))
							If nx == 1 .Or. aArrayABC[nx-1,5]!= cTrfAtu
								oTarefa:Init()
								oTarefa:PrintLine()
								oTarefa:Finish()
							EndIf

							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							nPercAcm2 += aArrayABC[nx,7]/nCustoReal*100
							nQtdeRepo:= (aArrayABC[nx,3]-aArrayABC[nx,6])

							If mv_par11 == 1 //Custo Atual
								// saldo com o cálculo do Custo Atual
								If aArrayABC[nx,10]>0
									nValRepo := aArrayABC[nx,10]
									nTotRepo += nValRepo*nQtdeRepo
								Else
									nValRepo := aArrayABC[nx,4]-aArrayABC[nx,7]
									nTotRepo += nValRepo
								EndIf
							EndIf

							oTarefaRec:PrintLine()

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								oTarefaAFU:Init()
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Apontamento de Recursos
										Case aArrayABC[nx, 9, ny, 1] == "AFU"
										   AFU->(MsGoTo(aArrayABC[nx, 9, ny, 12]))
											oTarefaAFU:PrintLine()
									EndCase
								Next nY
								oTarefaAFU:Finish()
							EndIf

					EndCase

					nPrvPer  += aArrayABC[nx,4]
					nRealPer += aArrayABC[nx,7]

					If nX < Len(aArrayABC) .And. aArrayABC[nx+1,5] != cTrfAtu
						cTrfAtu := aArrayABC[nx+1,5]
						oTarefaRec:Finish()
						oTarefaRec:Init()
					EndIf
				Next nX

				oTarefaRec:Finish()

				oReport:SkipLine(2)
				oReport:ThinLine()
				oReport:PrintText(STR0038, oReport:Row(), 0) // "Totais do Periodo"
				oReport:PrintText(Transform( nPrvPer,  "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_CUSTD"):ColPos() )
				oReport:PrintText("",oReport:Row(), oTarefaRec:Cell("AFA_QUANT3"):ColPos() ) // Ajuste para posicionar corretamente a coluna quando exportado para excel
				oReport:PrintText(Transform( nRealPer, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_CUSTD2"):ColPos() )

				// Saldo com o calculo do Custo Previsto
				If mv_par11 == 2
					oReport:PrintText(Transform( nPrvPer-nRealPer, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_QUANT6"):ColPos() )
				// Saldo com o calculo do Custo Atual
				Else
					nTotDsp	:=0
					For nFaz:=1 to Len(aArrayABC)
						If Substr(aArrayABC[nFaz ,01],1,3)=="DSP"
							nTotDsp+=aArrayABC[nFaz ,07]
						EndIf
					next nFaz
					oReport:PrintText(Transform( nTotRepo-nTotDsp, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_QUANT6"):ColPos() )
				EndIf

				oReport:SkipLine()
				oReport:ThinLine()
				oReport:PrintText(STR0039, oReport:Row(), 0) //"Totais por Projeto"
				oReport:PrintText(Transform( nCustoPrj, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_CUSTD"):ColPos() )

				If nTotEmp < 0
					oReport:PrintText(Transform( 0, "@E 9,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_QUANT3"):ColPos() )
				Else
					oReport:PrintText(Transform( nTotEmp, "@E 9,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_QUANT3"):ColPos() )
				EndIf
				oReport:PrintText(Transform( nCustoReal, "@E 999,999,999,999.99"),oReport:Row(), oTarefaRec:Cell("AFA_CUSTD2"):ColPos() )

				// Saldo com o calculo do Custo Previsto
				If mv_par11 == 2
					oReport:PrintText(Transform( nCustoPrj-nRealPer, "@E 999,999,999,999.99"), oReport:Row(), oTarefaRec:Cell("AFA_QUANT6"):ColPos() )
				EndIf
				oReport:SkipLine()
				oReport:ThinLine()
				nTotEmp := 0

			EndIf
	EndCase
	dbSelectArea("AF8")
	dbSkip()
	If oReport:Cancel()
		oReport:SkipLine()
		oReport:PrintText(STR0063) //"*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	//saltar pagina a cada projeto
	oReport:EndPage()
End

RestArea(aArea)

Return




//---------------------------------RELEASE 3--------------------------------------//

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PMSR170R3³ Autor ³ Edson Maricate        ³ Rev. ³ 02.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao dos quantitativos previstos x realizados do proj. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMSR170R3()
Local cDesc1   := STR0001 //"Este relatorio ira imprimir os quantitativos previstos x realizados para a execucao do projeto de acordo com parametros solicitados. O folder 'Filtro' permite a criacao de um filtro especifico do usuario para os produtos a serem considerados no processamento do relatorio."
Local cDesc2   := ""
Local cDesc3   := ""
Local cString  := "SB1"
Local lDic     := .F.
Local lComp    := .T.
Local lFiltro  := .T.
Local wnrel    := "PMSR170"

Private NomeProg:= "PMSR170"
Private Titulo  := STR0002 //"Quantitativos previstos x realizado"
Private Tamanho := "G"   // P/M/G
Private Limite  := 220   // 80/132/220
Private nLi     := 100 // Contador de Linhas
Private aOrdem  := {STR0016,STR0017} //"PROJETO+PRODUTO+DESPESA"###"TAREFA+PRODUTO+DESPESA"
Private cPerg   := "PMR170"  // Pergunta do Relatorio
Private aReturn := { STR0003, 1, STR0004, 1, 2, 1, "",1 }   //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PARAMETROS                                           ³
//³ MV_PAR01 : Projeto de ?                              ³
//³ MV_PAR02 : Ate?                                      ³
//³ MV_PAR03 : Data projeto de                           ³
//³ MV_PAR04 : Data projeto ate                          ³
//³ MV_PAR05 : Versao ?	Branco = Atual                   ³
//³ MV_PAR06 : Relatorio ? Analitico / Sintetico         ³
//³ MV_PAR07 : Periodo de                                ³
//³ MV_PAR08 : Periodo ate                               ³
//³ MV_PAR09 : Produto de                                ³
//³ MV_PAR10 : Produto Ate                               ³
//³ MV_PAR11 : Custo ? Atual(valor standard no SB1)/Previsto(valor no AFA)³
//³ MV_PAR12 : Aglutina tarefas? Sim / Não               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	//Set Filter to
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

RptStatus( {|lEnd| PMR170Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Set Device To Screen

If ( aReturn[5] = 1 )
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif


MS_FLUSH()

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PMR170IMP³ Autor ³ Edson Maricate                ³ Data ³19.06.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a impressao do detalhe do relatorio                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Pmr170Imp()

Local aArea      := GetArea()
Local aArrayABC  := {}
Local nCustoTrf  := 0
Local nRealTrf   := 0
Local nCustoReal := 0
Local nPercAcm   := 0
Local nPercAcm2  := 0
Local nQuantAFA  := 0
Local nValorAFB  := 0
Local nTotEmp    := 0
Local nTotRepo   := 0
Local nTotTarefa := 0
Local nCusRealRe := 0
Local nTotDsp    := 0
Local nFaz       := 0
Local nQtdeRepo  := 0
Local nQtdEmp    := 0
Local nDecCst    := TamSX3("AF9_CUSTO")[2]
Local cVersao    := mv_par05
Local aItemInfo  := {}
Local nx         := 0
Local ny         := 0
Local nPrvPer    := 0
Local nRealPer   := 0
Local cTrunca    := "1"
Local dDataMov
Local nAux       := 1
Local cCodigo    := ""
Local cTipo      := ""
Local nValSB1    := 0
Local lImpCabec  := .T.
Local lUsaAJT	 := .F.
Local lRecProd	  := .F.  // caso o RECURSO nao tenha PRODUTO.

Private nMoedaPMS := IIF( HasTemplate("CCT") , MV_PAR17 , MV_PAR16 )
Private Cabec1
Private Cabec2

If nMoedaPMS < 1
	nMoedaPMS := 1
Endif

Do Case
	Case aReturn[8] == 1
		Cabec1	:= STR0005 					 			//"                                                                    |                      PREVISTO                     |                             REALIZADO                      |                 Saldo                |"
		// Saldo com o calculo do Custo Atual
		If mv_par11 == 1
			Cabec2	:= STR0006+STR0036+" |" //"Tp.       Codigo                Descricao                       UM  |     Quantidade              Valor  %Proj.  %Acum. |   Qtde Empenhada   Qtde Atual      Valor   %Proj.   %Acum. |  Quantidade           Custo "+"(Atual)"+" |"
		// Saldo com o calculo do Custo Previsto
		ElseIf mv_par11 == 2
			Cabec2	:= STR0006+STR0037+" |" //"Tp.       Codigo                Descricao                       UM  |     Quantidade              Valor  %Proj.  %Acum. |   Qtde Empenhada   Qtde Atual      Valor   %Proj.   %Acum. |  Quantidade           Custo "+"(Prev.)"+" |"
		EndIf

	Case aReturn[8] == 2
		Cabec1	:= STR0007 							 //"                                                                                          |                     PREVISTO                     |                          REALIZADO                      |      Saldo         |"
		// Saldo com o calculo do Custo Atual
		If mv_par11 == 1
			Cabec2	:= STR0008+STR0036+"|" //"Tarefa       Descricao                      Tp.     Codigo           Descricao         UM |    Quantidade              Valor  %Proj.  %Acum. | Qtde Empenhada  Qtde Atual      Valor   %Proj.   %Acum. | Qtde   Custo"+"(Atual)+"|"
		// Saldo com o calculo do Custo Previsto
		ElseIf mv_par11 == 2
			Cabec2	:= STR0008+STR0037+"|" //"Tarefa       Descricao                      Tp.     Codigo           Descricao         UM |    Quantidade              Valor  %Proj.  %Acum. | Qtde Empenhada  Qtde Atual      Valor   %Proj.   %Acum. | Qtde   Custo"+"(Prev.)+"|"
		EndIf

EndCase

//PmsNewProc()

dbSelectArea("AF8")
dbSetOrder(1)
dbSeek(xFilial("AF8") + mv_par01,.T.)
While !Eof() .And. xFilial("AF8") == AF8->AF8_FILIAL ;
			 .And. AF8->AF8_PROJET <= mv_par02
//	PmsIncProc()

	If FieldPos("AF8_TRUNCA") > 0
		cTrunca:=AF8->AF8_TRUNCA
	Else
		cTrunca:="1"
	EndIf

	// se a versao nao informada
	If Empty(mv_par05)
		// utiliza a ultima versao para o projeto
		cVersao := PmsAF8Ver(AF8->AF8_PROJET)
	Else
		// utiliza a versao informada
		cVersao := mv_par05
	EndIf
	If AF8->AF8_DATA > mv_par04 .Or. AF8->AF8_DATA < mv_par03
		dbSelectArea("AF8")
		dbSkip()
		Loop
	EndIf

	If lImpCabec
		lImpCabec := .F.
		nLi := 0
		nLi := Cabec(Titulo,Cabec1,Cabec2,nomeprog,Tamanho,CHRCOMP)
		nLi++
	EndIf

	nTotal	  := 0
	aArrayABC := {}
	aItemInfo := {}
	nPercAcm  := 0
	nPercAcm2 := 0
	nTotRepo	:= 0
	nPrvPer		:= 0
	nRealPer	:= 0
	aAuxHand  := PmsIniCOTP(AF8->AF8_PROJET,cVersao,CTOD("31/12/2040"))
	nCustoPrj := PmsTrunca(cTrunca,PmsRetCOTP(aAuxHand,2,Padr(AF8->AF8_PROJET,Len(AFC->AFC_EDT)))[nMoedaPMS],nDecCst,)
	aAuxHand  := PmsIniCRTE(AF8->AF8_PROJET,AF8->AF8_REVISA,CTOD("31/12/2040"))
	nCustoReal:= PmsTrunca(cTrunca,PmsRetCRTE(aAuxHand,2,AF8->AF8_PROJET+SPACE(2))[nMoedaPMS],nDecCst,)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica se o projeto usa composicoes aux   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lUsaAJT := AF8ComAJT( AF8->AF8_PROJET )

	Do Case
		Case aReturn[8] == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³tratamento para projetos que usam composicao aux  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaAJT
				dbSelectArea( "AF9" )
				AF9->( DbSetOrder( 1 ) )
				If AF9->( DbSeek( xFilial( "AF9" ) + AF8->AF8_PROJET + AF8->AF8_REVISA ) )
					While AF9->( !Eof() ) .And. xFilial( "AF9" ) + AF8->AF8_PROJET + AF8->AF8_REVISA == AF9->AF9_FILIAL + AF9->AF9_PROJET + AF9->AF9_REVISA
						DbSelectArea( "AEL" )
						AEL->( DbSetOrder( 1 ) )
						If AEL->( DbSeek( xFilial( "AEL" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_TAREFA ) ) )
							While AEL->( !Eof() ) .AND. xFilial( "AEL" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_TAREFA ) == AEL->( AEL_FILIAL + AEL_PROJET + AEL_REVISA + AEL_TAREFA )
								DbSelectArea( "AJY" )
								AJY->( DbSetOrder( 1 ) )
								If AJY->( DbSeek( xFilial( "AJY" ) + AEL->( AEL_PROJET + AEL_REVISA + AEL_INSUMO ) ) )
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³filtra o produto conforme os parametros³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If AJY->AJY_PRODUT < mv_par09 .OR. AJY->AJY_PRODUT > mv_par10
										AEL->( DbSkip() )
										Loop
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Filtra os insumos conforme os parametros³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If AJY->AJY_INSUMO < MV_PAR15 .AND. AJY->AJY_INSUMO > MV_PAR16
										AEL->( DbSkip() )
										Loop
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³verifica o empenho do produto³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
									AFJ->(MsSeek(xFilial("AFJ") + AF9->AF9_PROJET + AJY->AJY_PRODUT))
									While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AF9->AF9_PROJET .AND.;
									       AFJ->AFJ_COD == AJY->AJY_PRODUT
										nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
										AFJ->(DbSkip())
									EndDo

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³verifica o empenho do produto³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
									AFJ->(MsSeek(xFilial("AFJ") + AEL->AEL_PROJET + AJY->AJY_PRODUT))
									While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AEL->AEL_PROJET .AND.;
									       AFJ->AFJ_COD == AJY->AJY_PRODUT
										nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
										AFJ->(DbSkip())
									EndDo

									nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,AJY->AJY_CUSTD,nDecCst,),Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,)

									DbSelectArea( "SB1" )
									SB1->( DbSetOrder( 1 ) )
									If SB1->( DbSeek( xFilial( "SB1" ) + AJY->AJY_PRODUT ) )
										If AF9->AF9_HUTEIS > 0
											nPerc		:= (PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR08)-PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR07-1))/AF9->AF9_HDURAC
										Else
											If mv_par06 <= AF9->AF9_START .And. mv_par07 >= AF9->AF9_FINISH
												nPerc	:= 1
											Else
												nPerc	:= 0
											EndIf
										EndIf

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Verifica a quantidade da tarefa.³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										// Obtem a quantidade
										If ExistTemplate( "CCTAF3QUANT" ) .AND. ( GetMV( "MV_PMSCCT" ) == "2" )
											nQuantAFA := ExecTemplate( "CCTAFAQUANT",.F.,.F.,{AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,AJY->AJY_PRODUT,AF9->AF9_QUANT,AEL->AEL_QUANT}) * nPerc
										Else
											nQuantAFA := IIf( GetMV( "MV_PMSCCT" ) == "1", AEL->AEL_QUANT, AEL->AEL_QUANT * AF9->AF9_QUANT ) * nPerc
										EndIf

										nPosABC := aScan(aArrayABC ,{|x| x[1] == "SB1" .And. x[2] == SB1->B1_COD } )
										If nPosABC > 0
											aArrayABC[nPosABC ,03] += nQuantAFA
											aArrayABC[nPosABC ,04] += xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AJY->AJY_CUSTD,nDecCst,AF9->AF9_QUANT) , Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,)
										Else
											aAdd(aArrayABC,{"SB1",;
														SB1->B1_COD,;
														nQuantAFA,;
														xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AJY->AJY_CUSTD,nDecCst,AF9->AF9_QUANT) , Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,) ,;
														0,;
														0,;
														nQtdEmp,;
														0,;
														{},;
														nValSB1 } )

											nQtdEmp := 0
										EndIf
									EndIf
								EndIf

								AEL->( DbSkip() )
							End
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica as despesas.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea( "AJV" )
						AJV->( DbSetOrder( 2 ) )
						If AJV->( DbSeek( xFilial( "AJV" ) + AF9->AF9_PROJET + AF9->AF9_REVISA + AF9->AF9_COMPUN ) )
							While AJV->( !Eof() ) .And. ( xFilial( "AJV" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_COMPUN ) == AJV->( AJV_FILIAL + AJV_PROJET + AJV_REVISA + AJV_COMPUN ) )
								If AF9->AF9_HUTEIS > 0
									nPerc		:= (PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR08)-PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR07-1))/AF9->AF9_HDURAC
								Else
									If dDataDe <= AF9->AF9_START .And. dDataAte >= AF9->AF9_FINISH
										nPerc	:= 1
									Else
										nPerc	:= 0
									EndIf
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica o valor da despesa.³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nValorAJV := xMoedaPMS(AJV->AJV_VALOR,1,nMoedaPMS,"",,,,,,cTrunca,,"AJV")

								If ExistTemplate("CCTAFBVLR") .And. (GetMV("MV_PMSCCT") == "2")
									nValorAFB := ExecTemplate("CCTAFBVLR",.F.,.F.,{AF9->AF9_QUANT,nValorAJV,.F.}) * nPerc
								Else
									nValorAFB := IIf( GetMV("MV_PMSCUST") == "1", nValorAJV, AF9->AF9_QUANT * nValorAJV ) * nPerc
								EndIf

								nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And. x[2]==AJV->AJV_TIPOD})
								If nPosABC > 0
									aArrayABC[nPosABC][4] += PmsTrunca(cTrunca,nValorAFB,nDecCst,AF9->AF9_QUANT)
								Else
									aAdd(aArrayABC,{"DSP",AJV->AJV_TIPOD,0,PmsTrunca(cTrunca,nValorAFB,nDecCst,AF9->AF9_QUANT ),0,0,0,0,{},0})
								EndIf

								AJV->( DbSkip() )
								IncProc()
							End
						EndIf

						AF9->( DbSkip() )
						IncProc()
					End
			    EndIf
			Else
				dbSelectArea("AFA")
				dbSetOrder(1)
				dbSeek(xFilial("AFA") + AF8->AF8_PROJET + cVersao )
				While !Eof() .And. xFilial("AFA") + AF8->AF8_PROJET + cVersao  == AFA->AFA_FILIAL + AFA->AFA_PROJET + AFA->AFA_REVISA
					aItemInfo := {}
	//				PmsIncProc()
	            lRecProd := .F.
					If !Empty(AFA->AFA_PRODUT)
						If (AFA->AFA_PRODUT < mv_par09 .Or. AFA->AFA_PRODUT > mv_par10)
							dbSelectArea("AFA")
							dbSkip()
							Loop
						Else
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial()+AFA->AFA_PRODUT))
							If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
								dbSelectArea("AFA")
								dbSkip()
								Loop
							EndIf
							nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
						EndIf
					ElseIf MV_PAR13 == 2 .and. Empty(AFA->AFA_PRODUT)
						dbSelectArea("AE8")
						DbSetOrder(1)
						If dbseek(xFilial("AE8")+AFA->AFA_RECURS)
							If !EMPTY(AE8->AE8_PRODUT)
								If (AE8->AE8_PRODUT < mv_par09 .Or. AE8->AE8_PRODUT > mv_par10)
									dbSelectArea("AFA")
									dbSkip()
									Loop
								Else
									SB1->(dbSetOrder(1))
									SB1->(dbSeek(xFilial("SB1")+AE8->AE8_PRODUT))
									//filtro de usuario
									If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
										dbSelectArea("AFA")
										dbSkip()
										Loop
									EndIf
									nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
									lRecProd := .T.
								EndIf
							ENDIF
						Endif
					EndIf

					// verifica o empenho do produto
					AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
					AFJ->(MsSeek(xFilial("AFJ") + AFA->AFA_PROJET + AFA->AFA_PRODUT))
					While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AFA->AFA_PROJET .AND.;
					       AFJ->AFJ_COD == AFA->AFA_PRODUT
						nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
						AFJ->(DbSkip())
					EndDo

					// verifica a quantidade do produto
					AF9->(dbSetOrder(1))
					AF9->(MsSeek(xFilial("AF9") + AFA->AFA_PROJET + AFA->AFA_REVISA + AFA->AFA_TAREFA))
					nQuantAFA:= PmsPrvAFA(AFA->(RecNo()),mv_par07,mv_par08,AF9->(RecNo()))

					// Visualizar Custo Previsto por Produto
					If MV_PAR13 == 2 .and. !Empty(AFA->AFA_PRODUT)
					  cCodigo := AFA->AFA_PRODUT
					  cTipo   := "SB1"
					ElseIf lRecProd
						cCodigo := SB1->B1_COD
						cTipo   := "SB1"
					ElseIf !Empty(AFA->AFA_RECURS)
						cCodigo := AFA->AFA_RECURS
						cTipo   := "REC"
					Else
						cCodigo := AFA->AFA_PRODUT
						cTipo   := "SB1"
					EndIf

					nPosABC := aScan(aArrayABC ,{|x| x[1]==cTipo .And. x[2]==cCodigo})
					If nPosABC > 0
						aArrayABC[nPosABC ,03] += nQuantAFA
						aArrayABC[nPosABC ,04] += xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)
					Else

						If cTipo == "REC"

							nCusRealRe:=CalcCusRec(AFA->AFA_RECURS)
							If nCusRealRe=0
								nCusRealRe:= xMoedaPMS(AFA->AFA_CUSTD , AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)
								xMoedaPMS(CUSTO,1,nMoedaPMS,"",,,,,,cTrunca,)
							EndIf

							aAdd(aArrayABC,	{ "REC",;
										AFA->AFA_RECURS,;
										nQuantAFA,;
										xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),;
										0,;
										0,;
										0,;
										0,;
										{},;
							 			nCusRealRe })
						Else
							aAdd(aArrayABC,{"SB1",;
										SB1->B1_COD,;
										nQuantAFA,;
										xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),;
										0,;
										0,;
										nQtdEmp,;
										0,;
										{},;
										nValSB1 } )
							nQtdEmp := 0
						EndIf
					EndIf
					dbSelectArea("AFA")
					dbSkip()
				End

				dbSelectArea("AFB")
				dbSetOrder(1)
				dbSeek(xFilial("AFB") + AF8->AF8_PROJET + cVersao )
				While !Eof() .And. xFilial("AFB") + AF8->AF8_PROJET + cVersao  == AFB->AFB_FILIAL + AFB->AFB_PROJET + AFB->AFB_REVISA
	//				PmsIncProc()

					// verifica a despesa do produto
					AF9->(dbSetOrder(1))
					AF9->(MsSeek(xFilial("AF9") + AFB->AFB_PROJET + AFB->AFB_REVISA + AFB->AFB_TAREFA))
					nValorAFB:= PmsPrvAFB(AFB->(RecNo()),mv_par07,mv_par08,AF9->(RecNo()))[1]
					nValorAFB:= xMoedaPMS(nValorAFB , AFB->AFB_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)
					nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And. x[2]==AFB->AFB_TIPOD})
					If nPosABC > 0
						aArrayABC[nPosABC ,04] += PmsTrunca(cTrunca,xMoedaPMS(nValorAFB,AFB->AFB_MOEDA,nMoedaPMS,"",,,,,,cTrunca,) ,nDecCst,AF9->AF9_QUANT)
					Else
						aAdd(aArrayABC,{"DSP",AFB->AFB_TIPOD,0,;
										PmsTrunca(cTrunca,xMoedaPMS(nValorAFB,AFB->AFB_MOEDA,nMoedaPMS,"",,,,,,cTrunca,) ,nDecCst,AF9->AF9_QUANT),;
										0,0,0,0,{},0})
					EndIf
					dbSelectArea("AFB")
					dbSkip()
				End
			EndIf

			dbSelectArea("AFN")
			dbSetOrder(1)
			dbSeek(xFilial("AFN") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While !Eof() .And. xFilial("AFN") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFN->AFN_FILIAL + AFN->AFN_PROJET + AFN->AFN_REVISA
//				PmsIncProc()
				If AFN->(FieldPos("AFN_ESTOQU") > 0) .and. AFN->AFN_ESTOQU == "1"
					SD1->(dbSetOrder(1))
					SD1->(dbSeek(PmsFilial("SD1","AFN")+AFN->AFN_DOC+AFN->AFN_SERIE+AFN->AFN_FORNECE+AFN->AFN_LOJA+AFN->AFN_COD+AFN->AFN_ITEM))
					If (SD1->D1_COD < mv_par09 .Or. SD1->D1_COD > mv_par10)
						dbSelectArea("AFN")
						dbSkip()
						Loop
					Else
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial()+SD1->D1_COD))
						If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
							dbSelectArea("AFN")
							dbSkip()
							Loop
						EndIf
						nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
					EndIf

					If SD1->(FieldPos("D1_DTDIGIT")) > 0
						dDataMov	:=	SD1->D1_DTDIGIT
					Else
						dDataMov	:=	SD1->D1_EMISSAO
					Endif

					If dDataMov >= mv_par07 .And. dDataMov <= mv_par08

						nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD})
						
	            	nValConv := xMoedaPMS(SD1->D1_CUSTO,1,nMoedaPMS,"",,,,,,cTrunca,,"SD1")

						// adiciona informacoes sobre o produto
						aItemInfo := {}
						aAdd(aItemInfo, "AFN")
						aAdd(aItemInfo, AFN->AFN_FORNEC)
						aAdd(aItemInfo, Posicione("SA2", 1, xFilial("SA2") + AFN->AFN_FORNECE + AFN->AFN_LOJA, "A2_NOME"))
						aAdd(aItemInfo, AFN->AFN_DOC)
						aAdd(aItemInfo, AFN->AFN_SERIE)
						aAdd(aItemInfo, AFN->AFN_TIPONF)
						aAdd(aItemInfo, AFN->AFN_QUANT)
						aAdd(aItemInfo, PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT()))
						aAdd(aItemInfo, SD1->D1_EMISSAO)

						If nPosABC > 0
							aArrayABC[nPosABC ,05] += PmsAFNQUANT("QUANT")
							aArrayABC[nPosABC ,06] += PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT())
							aAdd(aArrayABC[nPosABC ,09], aItemInfo)
						Else
							aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,pmsAFNQUANT("QUANT");
							               ,PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT()),0,0,{aItemInfo},nValSB1})
						EndIf
					EndIf
				EndIf
				AFN->(dbSkip())
			End

			dbSelectArea("AFS")
			dbSetOrder(1)
			dbSeek(xFilial("AFS") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While AFS->(!Eof()) .And. xFilial("AFS") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFS->AFS_FILIAL + AFS->AFS_PROJET + AFS->AFS_REVISA
//				PmsIncProc()
				SD2->(dbSetOrder(4))
				SD2->(dbSeek(PmsFilial("SD2","AFS")+AFS->AFS_NUMSEQ))
				If (SD2->D2_COD < mv_par09 .Or. SD2->D2_COD > mv_par10)
					dbSelectArea("AFS")
					dbSkip()
					Loop
				Else
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial()+SD2->D2_COD))
					If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
						dbSelectArea("AFS")
						dbSkip()
						Loop
					EndIf
					nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
				EndIf

				If SD2->(FieldPos("D2_DTDIGIT") ) > 0 .and. !Empty(SD2->D2_DTDIGIT)
					dDataMov	:=	SD2->D2_DTDIGIT
				Else
					dDataMov	:=	SD2->D2_EMISSAO
				Endif
				If dDataMov >= mv_par07 .And. dDataMov <= mv_par08
				
					nSinal	:=	iIf(AFS->AFS_MOVPRJ $ '25',1,-1)

					// adiciona informacoes sobre o produto
					aItemInfo := {}
					aAdd(aItemInfo, "AFS")
					aAdd(aItemInfo, SD2->D2_CLIENTE)
					aAdd(aItemInfo, Posicione("SA1", 1, xFilial("SA1") + SD2->(D2_CLIENTE+D2_LOJA), "A1_NOME"))
					aAdd(aItemInfo, AFS->AFS_DOC)
					aAdd(aItemInfo, AFS->AFS_SERIE)
					aAdd(aItemInfo, SD2->D2_TIPO)
					aAdd(aItemInfo, AFS->AFS_QUANT)
					aAdd(aItemInfo, PmsTrunca(cTrunca,xMoedaPMS(SD2->D2_CUSTO1*(AFS->AFS_QUANT/SD2->D2_QUANT))*nSinal,1,nMoedaPMS,"",,,,,,cTrunca,,"SD2"))
					aAdd(aItemInfo, dDataMov)
					aAdd(aItemInfo, AFS->(Recno()))
					aAdd(aItemInfo, SD2->(Recno()))

					nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD})

					If nPosABC > 0
						aArrayABC[nPosABC ,05] += AFS->AFS_QUANT
						aArrayABC[nPosABC ,06] += xMoedaPMS(SD2->D2_CUSTO1 * ( PmsAFSQUANT()/SD2->D2_QUANT )*nSinal,1,nMoedaPMS,"",,,,,,cTrunca,,"SD2")
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,AFS->AFS_QUANT,;
						xMoedaPMS(SD2->D2_CUSTO1*(PmsAFSQUANT()/SD2->D2_QUANT)*nSinal,1,nMoedaPMS,"",,,,,,cTrunca,,"SD2"),;
						0,0,{},nValSB1})
						aAdd(aArrayABC[Len(aArrayABC) ,09], aItemInfo)
					EndIf

				EndIf
				dbSkip()
			End

			dbSelectArea("AFI")
			dbSetOrder(1)
			MsSeek(xFilial()+AF8->AF8_PROJET+AF8->AF8_REVISA)
			While !Eof().And.AFI_FILIAL+AFI_PROJET+AFI_REVISA==;
				xFilial("AFI")+AF8->AF8_PROJET+AF8->AF8_REVISA

//				PmsIncProc()
				SD3->(dbSetOrder(7))
				If SD3->(dbSeek(PmsFilial("SD3","AFI")+AFI->AFI_COD+AFI->AFI_LOCAL+DTOS(AFI->AFI_EMISSA)+AFI->AFI_NUMSEQ)) ;
					.And. !(SD3->D3_ESTORNO == "S") .And. !(SD3->D3_CF == "RE5")
					If SD3->D3_EMISSAO >= mv_par07 .And. SD3->D3_EMISSAO <= mv_par08
						If (SD3->D3_COD < mv_par09 .Or. SD3->D3_COD > mv_par10)
							dbSelectArea("AFI")
							dbSkip()
							Loop
						Endif
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial()+SD3->D3_COD))
						If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
							dbSelectArea("AFI")
							dbSkip()
							Loop
						EndIf
						nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
						nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1" .And. x[2]==SB1->B1_COD})

						// adiciona informacao sobre o produto
						aItemInfo := {}
						aAdd(aItemInfo, "SD3")
						aAdd(aItemInfo, SD3->D3_EMISSAO)
						aAdd(aItemInfo, SD3->D3_DOC)
						aAdd(aItemInfo, SD3->D3_NUMSERI)
						aAdd(aItemInfo, SD3->D3_OP)
						aAdd(aItemInfo, SD3->D3_TIPO)
						aAdd(aItemInfo, SD3->D3_TM)
						If SD3->D3_TM > "500"
							aAdd(aItemInfo, SD3->D3_QUANT)
							If AF8->AF8_TPCUS=="2"
								aAdd(aItemInfo, xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,) )
							Else
								aAdd(aItemInfo, xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3") )
							EndIf
						Else
							aAdd(aItemInfo, SD3->D3_QUANT*-1)
							If AF8->AF8_TPCUS=="2"
								aAdd(aItemInfo, xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,)*-1)
							Else
								aAdd(aItemInfo, xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")*-1)
							EndIf
						EndIf
						If nPosABC > 0
							If SD3->D3_TM > "500"
								aArrayABC[nPosABC ,05] += SD3->D3_QUANT
								If AF8->AF8_TPCUS=="2"
									aArrayABC[nPosABC ,06] += xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,)
								Else
									aArrayABC[nPosABC ,06] += xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")
								EndIf
							Else
								aArrayABC[nPosABC ,05] += SD3->D3_QUANT*-1
								If AF8->AF8_TPCUS=="2"
									aArrayABC[nPosABC ,06] += xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,)*-1
								Else
									aArrayABC[nPosABC ,06] += xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")*-1
								EndIf
							EndIf
							aAdd(aArrayABC[nPosABC ,09], aItemInfo)
						Else
							If SD3->D3_TM > "500"
								If AF8->AF8_TPCUS=="2"
									aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,SD3->D3_QUANT,;
									xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,),;
									0,0,{},nValSB1})
								Else
									aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,SD3->D3_QUANT,;
									xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3"),;
									0,0,{},nValSB1})
								EndIf
							Else
								If AF8->AF8_TPCUS=="2"
									aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,SD3->D3_QUANT*-1,;
									xMoedaPMS(SD3->D3_CUSFF1,1,nMoedaPMS,"",,,,,,cTrunca,)*-1,;
									0,0,{},nValSB1})
								Else
									aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,SD3->D3_QUANT*-1,;
									xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")*-1,;
									0,0,{},nValSB1})
								EndIf
							EndIf
							aAdd(aArrayABC[Len(aArrayABC) ,09], aItemInfo)
						EndIf
					EndIf
				EndIf
				dbSelectArea("AFI")
				dbSkip()
			End

			dbSelectArea("AFU")
			dbSetOrder(1)
			dbSeek(xFilial()+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA)
			While !Eof().And.AFU->AFU_FILIAL+AFU->AFU_CTRRVS+AFU->AFU_PROJET+AFU->AFU_REVISA==;
								xFilial("AFU")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA
//				PmsIncProc()

				If AFU->AFU_DATA >= mv_par07 .And. AFU->AFU_DATA <= mv_par08
					If !Empty(AFU->AFU_COD)
						If (AFU->AFU_COD < mv_par09 .Or. AFU->AFU_COD > mv_par10)
							dbSelectArea("AFU")
							dbSkip()
							Loop
						Else
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial()+AFU->AFU_COD))
							If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
								dbSelectArea("AFU")
								dbSkip()
								Loop
							EndIf
						Endif
					ElseIf MV_PAR14 == 2 .and. Empty(AFU->AFU_COD)
						dbSelectArea("AE8")
						DbSetOrder(1)
						If dbseek(xFilial("AE8")+AFU->AFU_RECURS)
							If !EMPTY(AE8->AE8_PRODUT)
								If (AE8->AE8_PRODUT < mv_par09 .Or. AE8->AE8_PRODUT > mv_par10)
									dbSelectArea("AFU")
									dbSkip()
									Loop
								Else
									SB1->(dbSetOrder(1))
							      SB1->(dbSeek(xFilial()+AE8->AE8_PRODUT))
							      If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
								     dbSelectArea("AFU")
								     dbSkip()
								     Loop
							      EndIf
								EndIf
								lRecProd := .T.
							ENDIF
						Endif
					EndIf

					aItemInfo := {}
					aAdd(aItemInfo, "AFU")
					aAdd(aItemInfo, AFU->AFU_RECURS)
					aAdd(aItemInfo, Posicione("AE8", 1, xFilial() + AFU->AFU_RECURS, "AE8_DESCRI"))
					aAdd(aItemInfo, Posicione("AE8", 1, xFilial() + AFU->AFU_RECURS, "AE8_EQUIP"))
					aAdd(aItemInfo, Posicione("AED", 1, xFilial() + AFU->AFU_RECURS, "AED_DESCRI"))
					aAdd(aItemInfo, AFU->AFU_TAREFA)
					aAdd(aItemInfo, Posicione("AF9", 1, xFilial() + AFU->AFU_PROJET + AFU->AFU_REVISA + AFU->AFU_TAREFA, "AF9_DESCRI"))
					aAdd(aItemInfo, AFU->AFU_DATA)
					aAdd(aItemInfo, AFU->AFU_HORAI)
					aAdd(aItemInfo, AFU->AFU_HORAF)
					aAdd(aItemInfo, AFU->AFU_HQUANT)

					// Visualizar Custo Realizado por Produto
					If MV_PAR14 == 2 .and. !Empty(AFU->AFU_COD)
					  cCodigo := AFU->AFU_COD
					  cTipo   := "SB1"
					ElseIf lRecProd
						cCodigo := SB1->B1_COD
						cTipo   := "SB1"
					ElseIf !Empty(AFU->AFU_RECURS)
						cCodigo := AFU->AFU_RECURS
						cTipo   := "REC"
					Else
						cCodigo := AFU->AFU_COD
						cTipo   := "SB1"
					EndIf

					nPosABC := aScan(aArrayABC,{|x| x[1]==cTipo .And. x[2]==cCodigo})
					nValConv := xMoedaPMS(AFU->AFU_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFU")
					If nPosABC > 0
						aArrayABC[nPosABC ,05] += AFU->AFU_HQUANT
						aArrayABC[nPosABC ,06] += nValConv
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						If cTipo == "REC"
							aAdd(aArrayABC,{"REC",AFU->AFU_RECURS,0,0,AFU->AFU_HQUANT,	nValConv,0,0,{aItemInfo},0})
						Else
							aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,AFU->AFU_HQUANT,nValConv,0,0,{aItemInfo},0})
						EndIf
					EndIf
				EndIf
			    dbSelectArea("AFU")
				dbSkip()
			End

			If PmsCHkAJC(.F.)
				dbSelectArea("AJC")
				dbSetOrder(1)
				dbSeek(xFilial()+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA)
				While !Eof().And.AJC->AJC_FILIAL+AJC->AJC_CTRRVS+AJC->AJC_PROJET+AJC->AJC_REVISA==;
									xFilial("AJC")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA
//					PmsIncProc()
					If AJC->AJC_DATA >= mv_par07 .And. AJC->AJC_DATA <= mv_par08
						If AJC->AJC_TIPO=="1"
							If (AJC->AJC_COD < mv_par09 .Or. AJC->AJC_COD > mv_par10)
								dbSelectArea("AJC")
								dbSkip()
								Loop
							Else
								SB1->(dbSetOrder(1))
								SB1->(dbSeek(xFilial()+AJC->AJC_COD))
								If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
									dbSelectArea("AJC")
									dbSkip()
									Loop
								EndIf
								nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)

								nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1".And.x[2]==SB1->B1_COD})
							EndIf
						Else
							nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And.x[2]==AJC->AJC_TIPOD})
						EndIf

						nValConv := xMoedaPMS(AJC->AJC_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"AJC")

						aItemInfo := {}
						aAdd(aItemInfo, "AJC")
						aAdd(aItemInfo, AJC_TIPO)
						aAdd(aItemInfo, If(AJC->AJC_TIPO=="1",AJC->AJC_COD,AJC->AJC_TIPOD))
						aAdd(aItemInfo, If(AJC->AJC_TIPO=="1",Posicione("SB1", 1, xFilial() + AJC->AJC_COD, "B1_DESC"),AJC->AJC_DESCRI))
						aAdd(aItemInfo, AJC->AJC_TAREFA)
						aAdd(aItemInfo, Posicione("AF9", 1, xFilial() + AJC->AJC_PROJET + AJC->AJC_REVISA + AJC->AJC_TAREFA, "AF9_DESCRI"))
						aAdd(aItemInfo, nValConv)
						aAdd(aItemInfo, AJC->AJC_QUANT)

						If nPosABC > 0
							aArrayABC[nPosABC ,05] += AJC->AJC_QUANT
							aArrayABC[nPosABC ,06] += nValConv
							aAdd(aArrayABC[nPosABC ,09],aItemInfo)
						Else
							If AJC->AJC_TIPO=="1"
								aAdd(aArrayABC,{"SB1",SB1->B1_COD,0,0,AJC->AJC_QUANT,nValConv,0,0,{aItemInfo},nValSB1})
							Else
								aAdd(aArrayABC,{"DSP",AJC->AJC_TIPOD,0,0,AJC->AJC_QUANT,nValConv,0,0,{aItemInfo},0})
							EndIf
						EndIf
					Endif
					dbSelectArea("AJC")
					dbSkip()
				End
			EndIf

			dbSelectArea("AFR")
			dbSetOrder(1)
			dbSeek(xFilial("AFR") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While !Eof() .And. xFilial("AFR") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFR->AFR_FILIAL + AFR->AFR_PROJET + AFR->AFR_REVISA
//				PmsIncProc()
				If 	SE2->(dbSeek(PmsFilial("SE2","AFR")+AFR->AFR_PREFIXO+AFR->AFR_NUM+AFR->AFR_PARCELA+AFR->AFR_TIPO+AFR->AFR_FORNEC+AFR->AFR_LOJA)) .And.;
					SE2->E2_EMIS1 >= mv_par07 .And. SE2->E2_EMIS1 <= mv_par08
					aItemInfo := {}
					If (SE2->E2_TIPO $ MVABATIM+"/"+MV_CPNEG)		 // Se nao for abatimento
						nSinal :=	-1
					Else
						nSinal :=	1
					EndIf

					nValConv := xMoedaPMS(AFR->AFR_VALOR1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFR")

					aAdd(aItemInfo, "AFR")
					aAdd(aItemInfo, AFR->AFR_FORNEC)
					aAdd(aItemInfo, Posicione("SA2", 1, xFilial("SA2") + AFR->AFR_FORNEC, "A2_NOME"))
					aAdd(aItemInfo, AFR->AFR_NUM)
					aAdd(aItemInfo, AFR->AFR_DATA)
					aAdd(aItemInfo, AFR->AFR_VENREA)
					aAdd(aItemInfo, nValConv*nSinal)

					nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" .And. x[2]==AFR->AFR_TIPOD})
					If nPosABC > 0
						aArrayABC[nPosABC ,06] += nValConv * nSinal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						SX5->(dbSetOrder(1))
						SX5->(dbSeek(xFilial()+"FD"+AFR->AFR_TIPOD))
						aAdd(aArrayABC,{"DSP",AFR_TIPOD,0,0,0,nValConv*nSinal,0,0, {aItemInfo},0})
					EndIf
				EndIf
				dbSelectArea("AFR")
				dbSkip()
			End

			SE5->(dbSetOrder(9))
			dbSelectArea("AJE")
			dbSetOrder(1)
			MsSeek(xFilial()+AF8->AF8_PROJET + AF8->AF8_REVISA ,.T.)
			While !Eof().And.AJE_FILIAL+AJE_PROJET+AJE_REVISA==;
							xFilial("AJE")+AF8->AF8_PROJET + AF8->AF8_REVISA
				If SE5->(dbSeek(xFilial()+AJE->AJE_ID)) .And.!(SE5->E5_SITUACA == "C") .And. (SE5->E5_RECPAG == "P") .And.;
				   SE5->E5_DATA >= mv_par07 .And. SE5->E5_DATA <= mv_par08

 					nValConv := xMoedaPMS(AJE->AJE_VALOR,1,nMoedaPMS,"",,,,,,cTrunca,,"AJE")

					aItemInfo := {}
					aAdd(aItemInfo, "SE5")
					aAdd(aItemInfo, SE5->E5_AGENCIA)
					aAdd(aItemInfo, SE5->E5_CONTA)
					aAdd(aItemInfo, nValConv)
					aAdd(aItemInfo, SE5->E5_NUMERO)
					aAdd(aItemInfo, SE5->E5_VENCTO)
					aAdd(aItemInfo, SE5->E5_NUMCHEQ)

					dbSelectArea("SA6")
					SA6->(dbSetOrder(1))
					SA6->(MSSeek(xFilial() + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA))
					aAdd(aItemInfo, SA6->A6_NOME)

					nPosABC := aScan(aArrayABC,{|x| x[1]=="MOV"})
					If nPosABC > 0
						aArrayABC[nPosABC ,06] += nValConv
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"MOV","",0,0,0,nValConv,0,0, {aItemInfo},0})
					EndIf
				EndIf
				dbSelectArea("AJE")
				dbSkip()
			End

			If Len(aArrayABC) > 0

				lImpCabec := .T.
				@ nLi,000 PSAY STR0009 + AF8->AF8_PROJET + " - " + AF8->AF8_DESCRI  //"Projeto :"
				nLi++
				@ nLi,000 PSAY STR0010 + cVersao //"Versao  :"
				nLi++
				nLi++

				aArrayABC := aSort(aArrayABC,,,{|x,y|x[2] < y[2]})
				SetRegua(Len(aArrayABC))
				For nx := 1 to Len(aArrayABC)
					IncRegua()

					QuebrPag()//Verifica o tamanho da pag. e quebra se necessario

					//                                                                    |                      PREVISTO                     |                             REALIZADO                      |                 SALDO                |
					//Tp.       Codigo                Descricao                       UM  |     Quantidade              Valor  %Proj.  %Acum. |   Qtde Empenhada   Qtde Atual      Valor   %Proj.   %Acum. |  Quantidade            Custo (Atual) |
					//XXX  123456789012345  1234567890123456789012345678901234567890  12   999999999999.99 999,999,999,999.99 999.99% 999.99%          999999999999.99   999999999999.99  999,999,999,999.99  999.99%  999.99%  999,999,999,999.99
					//00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111222222222222222222222
					//00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112
					//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

					Do Case
						Case aArrayABC[nx,1]=="SB1"

							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial()+aArrayABC[nx,2]))
							@ nLi,000 PSAY "PRD"
							@ nLi,005 PSAY SB1->B1_COD
							@ nLi,022 PSAY SUBSTR(SB1->B1_DESC,1,30)
							@ nLi,064 PSAY SB1->B1_UM
							@ nLi,069 PSAY PadL(Transform(aArrayABC[nx,3], X3Picture("AFA_QUANT")), 15)
							@ nLi,085 PSAY aArrayABC[nx,4] Picture "@E 999,999,999,999.99"
							@ nLi,104 PSAY aArrayABC[nx,4]/nCustoPrj*100 Picture "@E 999.99%"
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							@ nLi,112 PSAY nPercAcm Picture "@E 999.99%"

				            If aArrayABC[nx,7] < 0
				               @ nLi,123 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 12)
				            Else
				               @ nLi,123 PSAY PadL(Transform(aArrayABC[nx,7], X3Picture("AFA_QUANT")), 12)
				               nTotEmp += aArrayABC[nx,7]
				            EndIf

							@ nLi,135 PSAY PadL(lTrim(Transform(aArrayABC[nx,5], X3Picture("AFA_QUANT"))), 10)
							@ nLi,145 PSAY aArrayABC[nx,6] Picture "@E 999,999,999,999.99"
							@ nLi,165 PSAY aArrayABC[nx,6]/nCustoReal*100 Picture "@E 999.99%"
							nPercAcm2 += aArrayABC[nx,6]/nCustoReal*100
							@ nLi,174 PSAY nPercAcm2 Picture "@E 999.99%"
							nQtdeRepo:= (aArrayABC[nx,3]-aArrayABC[nx,5])
							@ nLi,184 PSAY nQtdeRepo Picture X3Picture("AFA_QUANT")

							// Saldo com o calculo do Custo Atual
							If mv_par11 == 1
								If aArrayABC[nx,10]>0
									nValRepo :=aArrayABC[nx,10]
									@ nLi,202 PSAY nValRepo*nQtdeRepo Picture "@E 999,999,999,999.99"
									nTotRepo += nValRepo*nQtdeRepo
								Else
									nValRepo :=aArrayABC[nx,4]-aArrayABC[nx,6]
									@ nLi,202 PSAY nValRepo Picture "@E 999,999,999,999.99"
									nTotRepo += nValRepo
								EndIf
							// Saldo com o calculo do Custo Previsto
							Else
								@ nLi,202 PSAY aArrayABC[nx,4]-aArrayABC[nx,6] Picture "@E 999,999,999,999.99"
							EndIf
							nLi++

							// impressao dos detalhes do apontamento

							// os detalhes do apontamento sao armazenados no elemento
							// de indice 9 do aArrayABC
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico

								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										Case aArrayABC[nx, 9, ny, 1] == "AFN"
											QuebrPag()
											@ nLi, 022 PSAY STR0019 //"Fornecedor: "
											@ nLi, 034 PSAY aArrayABC[nx, 9, ny, 2]
											@ nLi, 041 PSAY "-"
											@ nLi, 043 PSAY Substr(aArrayABC[nx, 9, ny, 3], 1, 30) Picture PesqPict("SA2", "A2_NOME")

											@ nLi, 075 PSAY STR0020 //"NF:"
											@ nLi, 079 PSAY aArrayABC[nx, 9, ny, 4] Picture PesqPict("AFN", "AFN_DOC")
											@ nLi, 092 PSAY STR0021 //"Serie:"
											@ nLi, 099 PSAY aArrayABC[nx, 9, ny, 5] Picture PesqPict("AFN", "AFN_SERIE")
											@ nLi, 104 PSAY STR0022 //"Tipo:"
											@ nLi, 110 PSAY aArrayABC[nx, 9, ny, 6] Picture PesqPict("AFN", "AFN_TIPONF")
											@ nLi, 113 PSAY STR0023 //"Dt. Emis.:"
											@ nLi, 124 PSAY aArrayABC[nx, 9, ny, 9] Picture PesqPict("SD1", "D1_EMISSAO")

											@ nLi, 135 PSAY PadL(ALLTRIM(Transform(aArrayABC[nx, 9, ny, 7] , X3Picture("AFN_QUANT"))), 10)
											@ nLi, 145 PSAY aArrayABC[nx, 9, ny, 8] Picture "@E 999,999,999,999.99"
											@ nLi, 165 PSAY Round(aArrayABC[nx, 9, ny, 8] / nCustoReal * 100, 2) Picture "@E 999.99%"
											nLi++
										Case aArrayABC[nx, 9, ny, 1] == "AFS"
											QuebrPag()
											@ nLi, 022 PSAY STR0060+": " //"Cliente"
											@ nLi, 034 PSAY aArrayABC[nx, 9, ny, 2]
											@ nLi, 041 PSAY "-"
											@ nLi, 043 PSAY Substr(aArrayABC[nx, 9, ny, 3], 1, 30) Picture PesqPict("SA1", "A1_NOME")

											@ nLi, 075 PSAY STR0020 //"NF:"
											@ nLi, 079 PSAY aArrayABC[nx, 9, ny, 4] Picture PesqPict("AFS", "AFS_DOC")
											@ nLi, 092 PSAY STR0021 //"Serie:"
											@ nLi, 099 PSAY aArrayABC[nx, 9, ny, 5] Picture PesqPict("AFS", "AFS_SERIE")
											@ nLi, 104 PSAY STR0022 //"Tipo:"
											@ nLi, 110 PSAY aArrayABC[nx, 9, ny, 6] Picture PesqPict("SD2", "D2_TIPO")
											@ nLi, 113 PSAY STR0023 //"Dt. Emis.:"
											@ nLi, 124 PSAY aArrayABC[nx, 9, ny, 9] Picture PesqPict("SD2", "D2_EMISSAO")

											@ nLi, 135 PSAY PadL(ALLTRIM(Transform(aArrayABC[nx, 9, ny, 7] , X3Picture("AFS_QUANT"))), 10)
											@ nLi, 145 PSAY aArrayABC[nx, 9, ny, 8] Picture "@E 999,999,999,999.99"
											@ nLi, 165 PSAY Round(aArrayABC[nx, 9, ny, 8] / nCustoReal * 100, 2) Picture "@E 999.99%"
											nLi++
										// Movimentacoes Internas
										Case aArrayABC[nx, 9, ny, 1] == "SD3"
											QuebrPag()
											@ nLi, 022 PSAY STR0024 //"Movimentacao Interna"
											@ nLi, 045 PSAY STR0023 //"Dt. Emis.:"
											@ nLi, 056 PSAY aArrayABC[nx, 9, ny, 2] Picture PesqPict("SD3", "D3_EMISSAO")
											@ nLi, 066 PSAY STR0025 //"Doc.:"
											@ nLi, 072 PSAY aArrayABC[nx, 9, ny, 3] Picture PesqPict("SD3", "D3_DOC")
											@ nLi, 086 PSAY STR0026 //"Num. Ser.:"
											@ nLi, 097 PSAY aArrayABC[nx, 9, ny, 4] Picture PesqPict("SD3", "D3_NUMSERI")
											@ nLi, 120 PSAY STR0027 //"Tp. Mov.:"
											@ nLi, 130 PSAY aArrayABC[nx, 9, ny, 7] Picture PesqPict("SD3", "D3_TM")
											@ nLi, 135 PSAY PadL(ALLTRIM(Transform(aArrayABC[nx, 9, ny, 8] , X3Picture("SD3_QUANT"))), 10)
											@ nLi, 145 PSAY aArrayABC[nx, 9, ny, 9] Picture "@E 999,999,999,999.99"
											@ nLi, 165 PSAY Round(aArrayABC[nx, 9, ny, 9] / nCustoReal * 100, 2) Picture "@E 999.99%"
											nLi++
									EndCase
								Next
							EndIf

							If mv_par06 == 1 // relatorio analitico
								@ nLi, 000 PSAY __PrtThinLine()
								nLi++
							EndIf
						Case aArrayABC[nx,1]=="DSP"
							SX5->(dbSetOrder(1))
							SX5->(dbSeek(xFilial()+"FD"+aArrayABC[nx,2]))
							QuebrPag()
							@ nLi,000 PSAY "DSP"
							@ nLi,005 PSAY aArrayABC[nx,2]

							If Len(aArrayABC[nx]) > 8
								@ nLi,022 PSAY Substr(X5Descri(), 1, 35)
							EndIf

							@ nLi,069 PSAY PadL(Transform(aArrayABC[nx,3], X3Picture("AFA_QUANT")), 15)

							@ nLi,085 PSAY aArrayABC[nx,4] Picture "@E 999,999,999,999.99"
							@ nLi,104 PSAY aArrayABC[nx,4]/nCustoPrj*100 Picture "@E 999.99%"
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							@ nLi,112 PSAY nPercAcm Picture "@E 999.99%"
							@ nLi,123 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 15)
							@ nLi,135 PSAY PadL(lTrim(Transform(aArrayABC[nx,5], X3Picture("AFA_QUANT"))), 10)
							@ nLi,145 PSAY aArrayABC[nx,6] Picture "@E 999,999,999,999.99"
							@ nLi,165 PSAY aArrayABC[nx,6]/nCustoReal*100 Picture "@E 999.99%"
							nPercAcm2 += aArrayABC[nx,6]/nCustoReal*100
							@ nLi,174 PSAY nPercAcm2 Picture "@E 999.99%"
							@ nLi,202 PSAY aArrayABC[nx,4]-aArrayABC[nx,6] Picture "@E 999,999,999,999.99"
							nLi++

							// Saldo com o calculo do Custo Atual
							If mv_par11 == 1
								nTotRepo += aArrayABC[nx,4]
							EndIf

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Despesas Financeiras
										Case aArrayABC[nx, 9, ny, 1] == "AFR"
											QuebrPag()
											@ nLi, 022 PSAY aArrayABC[nx, 9, ny, 2]
											@ nLi, 029 PSAY "-"
											@ nLi, 031 PSAY Substr(aArrayABC[nx, 9, ny, 3], 1, 30) Picture PesqPict("SA2", "A2_NOME")

											@ nLi, 066 PSAY STR0028 //"Data:"
											@ nLi, 072 PSAY aArrayABC[nx, 9, ny, 5] Picture PesqPict("AFR", "AFR_DATA")
											@ nLi, 145 PSAY aArrayABC[nx, 9, ny, 7] Picture PesqPict("AFR", "AFR_VALOR1")
											@ nLi, 164 PSAY Round(aArrayABC[nx, 9, ny, 7]/nCustoReal*100, 2) Picture "@E 999.99%"
											nLi++
									EndCase
								Next
							EndIf

							If mv_par06 == 1 // relatorio analitico
								@ nLi, 000 PSAY __PrtThinLine()
								nLi++
							End If
						Case aArrayABC[nx,1]=="MOV"
							QuebrPag()
							@ nLi,000 PSAY "MOV"
							@ nLi,022 PSAY STR0011 //"Movimentos bancarios"
							@ nLi,069 PSAY PadL(Transform(aArrayABC[nx,3], X3Picture("AFA_QUANT")), 15)
							@ nLi,085 PSAY aArrayABC[nx,4] Picture "@E 999,999,999,999.99"
							@ nLi,104 PSAY aArrayABC[nx,4]/nCustoPrj*100 Picture "@E 999.99%"
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							@ nLi,112 PSAY nPercAcm Picture "@E 999.99%"
							@ nLi,123 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 15)
							@ nLi,135 PSAY PadL(lTrim(Transform(aArrayABC[nx,5], X3Picture("AFA_QUANT"))), 10)
							@ nLi,145 PSAY aArrayABC[nx,6] Picture "@E 999,999,999,999.99"
							@ nLi,165 PSAY aArrayABC[nx,6]/nCustoReal*100 Picture "@E 999.99%"
							nPercAcm2 += aArrayABC[nx,6]/nCustoReal*100
							@ nLi,174 PSAY nPercAcm2 Picture "@E 999.99%"
							@ nLi,202 PSAY aArrayABC[nx,4]-aArrayABC[nx,6] Picture "@E 999,999,999,999.99"
							nLi++

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// movimento bancario
										Case aArrayABC[nx, 9, ny, 1] == "SE5"
											QuebrPag()
											@ nLi, 022 PSAY STR0013 //"Movimento bancario"

											@ nLi, 045 PSAY STR0029 //"Banco:"
											@ nLi, 052 PSAY Substr(aArrayABC[nx, 9, ny, 8], 1, 30) Picture PesqPict("SA6", "A6_NOME")

											@ nLi, 086 PSAY STR0030 //"Agencia:"
											@ nLi, 095 PSAY aArrayABC[nx, 9, ny, 2] Picture PesqPict("SE5", "E5_AGENCIA")

											@ nLi, 103 PSAY STR0031 //"Conta:"
											@ nLi, 110 PSAY aArrayABC[nx, 9, ny, 3] Picture PesqPict("SE5", "E5_CONTA")

											@ nLi, 123 PSAY STR0032 //"Num. Tit.:"
											@ nLi, 134 PSAY aArrayABC[nx, 9, ny, 5] Picture PesqPict("SE5", "E5_NUMERO")

											@ nLi, 143 PSAY STR0033 //"Dt. Venc.:"
											@ nLi, 154 PSAY aArrayABC[nx, 9, ny, 6] Picture PesqPict("SE5", "E5_VENCTO")

											@ nLi, 164 PSAY aArrayABC[nx, 9, ny, 4] Picture PesqPict("SE5", "E5_VALOR")
											@ nLi, 184 PSAY Round(aArrayABC[nx, 9, ny, 4]/nCustoReal*100, 2) Picture "@E 999.99%"
											nLi++
									EndCase
								Next nY
							EndIf

							If mv_par06 == 1 // relatorio analitico
								@ nLi, 000 PSAY __PrtThinLine()
								nLi++
							EndIf
						Case aArrayABC[nx,1]=="REC"
							AE8->(dbSetOrder(1))
							AE8->(dbSeek(xFilial()+aArrayABC[nx,2]))
							@ nLi,000 PSAY "REC"
							@ nLi,005 PSAY AE8->AE8_RECURS
							@ nLi,022 PSAY SubStr(AE8->AE8_DESCRI,1,30) //"Apontamento de Recursos"
							@ nLi,064 PSAY "HR"
							@ nLi,069 PSAY PadL(Transform(aArrayABC[nx,3], X3Picture("AFA_QUANT")), 15)
							@ nLi,085 PSAY aArrayABC[nx,4] Picture "@E 999,999,999,999.99"
							@ nLi,104 PSAY aArrayABC[nx,4]/nCustoPrj*100 Picture "@E 999.99%"
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							@ nLi,112 PSAY nPercAcm Picture "@E 999.99%"
							@ nLi,123 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 12)
							@ nLi,135 PSAY PadL(LTrim(Transform(aArrayABC[nx,5], X3Picture("AFA_QUANT"))), 10)
							@ nLi,145 PSAY aArrayABC[nx,6] Picture "@E 999,999,999,999.99"
							@ nLi,165 PSAY aArrayABC[nx,6]/nCustoReal*100 Picture "@E 999.99%"
							nPercAcm2 += aArrayABC[nx,6]/nCustoReal*100
							@ nLi,174 PSAY nPercAcm2 Picture "@E 999.99%"

							nQtdeRepo := (aArrayABC[nx,3]-aArrayABC[nx,5])
							@ nLi,184 PSAY nQtdeRepo Picture X3Picture("AFA_QUANT")

							// saldo com o cálculo do Custo Previsto
							If mv_par11 == 2
								@ nLi,202 PSAY aArrayABC[nx,4]-aArrayABC[nx,6] Picture "@E 999,999,999,999.99"
							// saldo com o cálculo do Custo Atual
							Else
								If aArrayABC[nx,10]>0
									nValRepo:=aArrayABC[nx,10]
									@ nLi,202 PSAY nValRepo*nQtdeRepo Picture "@E 999,999,999,999.99"
									nTotRepo += nValRepo*nQtdeRepo
								Else
									nValRepo:=aArrayABC[nx,4]-aArrayABC[nx,6]
									@ nLi,202 PSAY nValRepo Picture "@E 999,999,999,999.99"
									nTotRepo += nValRepo
								EndIf
							EndIf
							nLi++

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Apontamento de Recursos
										Case aArrayABC[nx, 9, ny, 1] == "AFU"
											QuebrPag()
											@ nLi, 022 PSAY STR0034 //"Rec.:"
											@ nLi, 028 PSAY aArrayABC[nx, 9, ny, 02] Picture PesqPict("AFU", "AFU_RECURS")
											@ nLi, 044 PSAY "-"
											@ nLi, 046 PSAY Substr(aArrayABC[nx, 9, ny, 03], 1, 30) Picture PesqPict("AE8", "AE8_DESCRI")
											@ nLi, 079 PSAY STR0035 //"Tarefa:"
											@ nLi, 087 PSAY aArrayABC[nx, 9, ny, 06] Picture PesqPict("AFU", "AFU_TAREFA")
											If Len(aArrayABC[nx, 9, ny, 06]) > 12
												nLi++
											EndIf
											@ nLi, 100 PSAY "-"
											@ nLi, 102 PSAY Substr(aArrayABC[nx, 9, ny, 07], 1, 30) Picture PesqPict("AF9", "AF9_DESCRI")

											@ nLi, 135 PSAY PadL(Transform(aArrayABC[nx, 9, ny, 11], X3Picture("AFA_QUANT")), 15)
											nLi++
									EndCase
								Next nY
							EndIf

							If mv_par06 == 1 // relatorio analitico
								@ nLi, 000 PSAY __PrtThinLine()
								nLi++
							EndIf
					EndCase
					nPrvPer += aArrayABC[nx,4]
					nRealPer+= aArrayABC[nx,6]

					If lAbortPrint
						Exit
					EndIf

				Next nX
				nLi++

				@ nLi,065 PSAY STR0038 // "Totais do Periodo"
				@ nLi,085 PSAY nPrvPer  Picture "@E 999,999,999,999.99"
				@ nLi,145 PSAY nRealPer Picture "@E 999,999,999,999.99"
				// Saldo com o calculo do Custo Previsto
				If mv_par11 == 2
					@ nLi,202 PSAY nPrvPer-nRealPer		Picture "@E 999,999,999,999.99"
				// Saldo com o calculo do Custo Atual
				Else

					nTotDsp	:=0
					For nFaz:=1 to Len(aArrayABC)
						If aArrayABC[nFaz ,01]=="DSP"
							nTotDsp+=aArrayABC[nFaz ,06]
						EndIf
					Next nFaz

					@ nLi,202 PSAY nTotRepo-nTotDsp		Picture "@E 999,999,999,999.99"
				EndIf
				nLi++
				@ nLi,065 PSAY STR0039 // "Totais do Projeto"
				@ nLi,085 PSAY nCustoPrj  Picture "@E 999,999,999,999.99"
				@ nLi,145 PSAY nCustoReal Picture "@E 999,999,999,999.99"
				// Saldo com o calculo do Custo Previsto
				If mv_par11 == 2
					@ nLi,202 PSAY nCustoPrj-nCustoReal Picture "@E 999,999,999,999.99"
				EndIf
				nLi++

			EndIf
		Case aReturn[8] == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³tratamento para projetos que usam composicao aux  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaAJT
				dbSelectArea( "AF9" )
				AF9->( DbSetOrder( 1 ) )
				If AF9->( DbSeek( xFilial( "AF9" ) + AF8->AF8_PROJET + AF8->AF8_REVISA ) )
					While AF9->( !Eof() ) .And. xFilial( "AF9" ) + AF8->AF8_PROJET + AF8->AF8_REVISA == AF9->AF9_FILIAL + AF9->AF9_PROJET + AF9->AF9_REVISA
						DbSelectArea( "AEL" )
						AEL->( DbSetOrder( 1 ) )
						If AEL->( DbSeek( xFilial( "AEL" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_TAREFA ) ) )
							While AEL->( !Eof() ) .AND. xFilial( "AEL" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_TAREFA ) == AEL->( AEL_FILIAL + AEL_PROJET + AEL_REVISA + AEL_TAREFA )
								DbSelectArea( "AJY" )
								AJY->( DbSetOrder( 1 ) )
								If AJY->( DbSeek( xFilial( "AJY" ) + AEL->( AEL_PROJET + AEL_REVISA + AEL_INSUMO ) ) )
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³filtra o produto conforme os parametros³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If AJY->AJY_PRODUT < mv_par09 .OR. AJY->AJY_PRODUT > mv_par10
										AEL->( DbSkip() )
										Loop
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Filtra os insumos conforme os parametros³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If AJY->AJY_INSUMO < MV_PAR15 .AND. AJY->AJY_INSUMO > MV_PAR16
										AEL->( DbSkip() )
										Loop
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³verifica o empenho do produto³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
									AFJ->(MsSeek(xFilial("AFJ") + AF9->AF9_PROJET + AJY->AJY_PRODUT))
									While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AF9->AF9_PROJET .AND.;
									       AFJ->AFJ_COD == AJY->AJY_PRODUT
										nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
										AFJ->(DbSkip())
									EndDo

									nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,AJY->AJY_CUSTD,nDecCst,),Val(AJY->AJY_MCUSTD),nMoedaPMS,"",,,,,,cTrunca,)

									DbSelectArea( "SB1" )
									SB1->( DbSetOrder( 1 ) )
									If SB1->( DbSeek( xFilial( "SB1" ) + AJY->AJY_PRODUT ) )
										If AF9->AF9_HUTEIS > 0
											nPerc		:= (PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR08)-PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR07-1))/AF9->AF9_HDURAC
										Else
											If mv_par06 <= AF9->AF9_START .And. mv_par07 >= AF9->AF9_FINISH
												nPerc	:= 1
											Else
												nPerc	:= 0
											EndIf
										EndIf

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Verifica a quantidade da tarefa.³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										// Obtem a quantidade
										If ExistTemplate( "CCTAF3QUANT" ) .AND. ( GetMV( "MV_PMSCCT" ) == "2" )
											nQuantAFA := ExecTemplate( "CCTAFAQUANT",.F.,.F.,{AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,AJY->AJY_PRODUT,AF9->AF9_QUANT,AEL->AEL_QUANT}) * nPerc
										Else
											nQuantAFA := IIf( GetMV( "MV_PMSCCT" ) == "1", AEL->AEL_QUANT, AEL->AEL_QUANT * AF9->AF9_QUANT ) * nPerc
										EndIf

										nPosABC := aScan(aArrayABC ,{|x| x[1] == "SB1" + AF9->AF9_TAREFA .And. x[2] == SB1->B1_COD } )
										If nPosABC > 0
											aArrayABC[nPosABC ,03] += nQuantAFA
											aArrayABC[nPosABC ,04] += PmsTrunca(cTrunca,nQuantAFA * AJY->AJY_CUSTD,nDecCst,AF9->AF9_QUANT)
										Else
											aAdd(aArrayABC,{"SB1" + AF9->AF9_TAREFA ,;
														SB1->B1_COD,;
														nQuantAFA,;
														PmsTrunca(cTrunca,nQuantAFA * AJY->AJY_CUSTD,nDecCst,AF9->AF9_QUANT),;
														AF9->AF9_TAREFA,;
														0,;
														nQtdEmp,;
														0,;
														{},;
														nValSB1 } )

											nQtdEmp := 0
										EndIf
									EndIf
								EndIf

								AEL->( DbSkip() )
							End
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica as despesas.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea( "AJV" )
						AJV->( DbSetOrder( 2 ) )
						If AJV->( DbSeek( xFilial( "AJV" ) + AF9->AF9_PROJET + AF9->AF9_REVISA + AF9->AF9_COMPUN ) )
							While AJV->( !Eof() ) .And. ( xFilial( "AJV" ) + AF9->( AF9_PROJET + AF9_REVISA + AF9_COMPUN ) == AJV->( AJV_FILIAL + AJV_PROJET + AJV_REVISA + AJV_COMPUN ) )
								If AF9->AF9_HUTEIS > 0
									nPerc		:= (PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR08)-PMSPrvAF9(AF9->AF9_PROJET,AF9->AF9_REVISA,AF9->AF9_TAREFA,MV_PAR07-1))/AF9->AF9_HDURAC
								Else
									If dDataDe <= AF9->AF9_START .And. dDataAte >= AF9->AF9_FINISH
										nPerc	:= 1
									Else
										nPerc	:= 0
									EndIf
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica o valor da despesa.³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nValorAFB := xMoedaPMS(AJV->AJV_VALOR,1,nMoedaPMS,"",,,,,,cTrunca,,"AJV")
								If ExistTemplate("CCTAFBVLR") .And. (GetMV("MV_PMSCCT") == "2")
									nValorAFB := ExecTemplate("CCTAFBVLR",.F.,.F.,{AF9->AF9_QUANT,nValorAFB,.F.}) * nPerc
								Else
									nValorAFB := IIf( GetMV("MV_PMSCUST") == "1", nValorAJV, AF9->AF9_QUANT * nValorAFB ) * nPerc
								EndIf

								nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP" + AJV->AJV_TAREFA .And. x[2]==AJV->AJV_TIPOD})
								If nPosABC > 0
									aArrayABC[nPosABC][4] += PmsTrunca(cTrunca,nValorAFB,nDecCst,AF9->AF9_QUANT)
								Else
									aAdd(aArrayABC,{"DSP"+AJV->AJV_TAREFA,AJV->AJV_TIPOD,0,;
										PmsTrunca(cTrunca,nValorAFB,nDecCst,AF9->AF9_QUANT ),;
										AJV->AJV_TAREFA,0,0,0,{},0})
								EndIf

								AJV->( DbSkip() )
								IncProc()
							End
						EndIf

						AF9->( DbSkip() )
						IncProc()
					End
			    EndIf
			Else
				dbSelectArea("AFA")
				dbSetOrder(1)
				dbSeek(xFilial("AFA") + AF8->AF8_PROJET + cVersao )
				While !Eof() .And. xFilial("AFA") + AF8->AF8_PROJET + cVersao  == AFA->AFA_FILIAL + AFA->AFA_PROJET + AFA->AFA_REVISA
					aItemInfo := {}
	//				PmsIncProc()

	   				If !Empty(AFA->AFA_PRODUT)
						  If (AFA->AFA_PRODUT < mv_par09 .Or. AFA->AFA_PRODUT > mv_par10)
							dbSelectArea("AFA")
							dbSkip()
							Loop
						  Else
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial()+AFA->AFA_PRODUT))
							If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
								dbSelectArea("AFA")
								dbSkip()
								Loop
							EndIf
							nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
						  EndIf

					  ElseIf MV_PAR13 == 2 .and. Empty(AFA->AFA_PRODUT)
						 dbSelectArea("AE8")
						 DbSetOrder(1)
						 If dbseek(xFilial("AE8")+AFA->AFA_RECURS)
							If !EMPTY(AE8->AE8_PRODUT)
								If (AE8->AE8_PRODUT < mv_par09 .Or. AE8->AE8_PRODUT > mv_par10)
									dbSelectArea("AFA")
									dbSkip()
									Loop
								Else
									SB1->(dbSetOrder(1))
									SB1->(dbSeek(xFilial("SB1")+AE8->AE8_PRODUT))
									//filtro de usuario
									If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
								     dbSelectArea("AFA")
								     dbSkip()
								     Loop
							      EndIf
							      nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
							      lRecProd := .T.
								EndIf
							ENDIF
						 Endif
					  EndIf

					// verifica o empenho do produto
					AFJ->(dbSetOrder(5))  //AFJ_FILIAL+AFJ_PROJECT+AFJ_COD+AFJ_LOCAL
					AFJ->(MsSeek(xFilial("AFJ") + AFA->AFA_PROJET + AFA->AFA_PRODUT))
					While !AFJ->(EOF()) .AND. AFJ->AFJ_FILIAL == xFilial("AFJ") .AND. AFJ->AFJ_PROJET == AFA->AFA_PROJET .AND.;
					       AFJ->AFJ_COD == AFA->AFA_PRODUT
						nQtdEmp += (AFJ->AFJ_QEMP - AFJ->AFJ_QATU)
						AFJ->(DbSkip())
					EndDo

					// verifica a quantidade do produto
					AF9->(dbSetOrder(1))
					AF9->(MsSeek(xFilial("AF9") + AFA->AFA_PROJET + AFA->AFA_REVISA + AFA->AFA_TAREFA))
					nQuantAFA := PmsPrvAFA(AFA->(RecNo()),mv_par07,mv_par08,AF9->(RecNo()))

					// Visualizar Custo Previsto por Produto
					If MV_PAR13 == 2 .and. !Empty(AFA->AFA_PRODUT)
					  cCodigo := AFA->AFA_PRODUT
					  cTipo   := "SB1"
					ElseIf lRecProd
						cCodigo := SB1->B1_COD
						cTipo   := "SB1"
					ElseIf !Empty(AFA->AFA_RECURS)
						cCodigo := AFA->AFA_RECURS
						cTipo   := "REC"
					Else
						cCodigo := AFA->AFA_PRODUT
						cTipo   := "SB1"
					EndIf

					nPosABC := aScan(aArrayABC,{|x| x[1]==cTipo+AFA->AFA_TAREFA .And. x[2]==cCodigo})
					If nPosABC > 0
						aArrayABC[nPosABC ,03] += nQuantAFA
						aArrayABC[nPosABC ,04] += xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,)
					Else
		    			If cTipo == "REC"
	                        // Calcula o Custo Real do recurso
							nCusRealRe:=CalcCusRec(AFA->AFA_RECURS)
							If nCusRealRe == 0
								nCusRealRe := AFA->AFA_CUSTD
							EndIf

							aAdd(aArrayABC, {"REC"+AFA->AFA_TAREFA,;
							                 AFA->AFA_RECURS, ;
							                 nQuantAFA,;
							                 xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),;
							                 AFA->AFA_TAREFA,;
							                 0,;
							                 0,;
							                 0,;
							                 {},;
							                 nCusRealRe})
		    			Else
							aAdd(aArrayABC,{"SB1"+AFA->AFA_TAREFA,;
											SB1->B1_COD,;
											nQuantAFA,;
											xMoedaPMS(PmsTrunca(cTrunca,nQuantAFA * AFA->AFA_CUSTD,nDecCst,AF9->AF9_QUANT),AFA->AFA_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),;
											AFA->AFA_TAREFA,;
											0,;
											0,;
											nQtdEmp,;
											{},;
											nValSB1})
							nQtdEmp := 0
						EndIf
					EndIf
					dbSelectArea("AFA")
					dbSkip()
				End

				dbSelectArea("AFB")
				dbSetOrder(1)
				dbSeek(xFilial("AFB") + AF8->AF8_PROJET + cVersao )
				While !Eof() .And. xFilial("AFB") + AF8->AF8_PROJET + cVersao  == AFB->AFB_FILIAL + AFB->AFB_PROJET + AFB->AFB_REVISA
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica a despesa do produto.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AF9->(dbSetOrder(1))
					AF9->(MsSeek(xFilial("AF9") + AFB->AFB_PROJET + AFB->AFB_REVISA + AFB->AFB_TAREFA))
					nValorAFB := PmsPrvAFB(AFB->(RecNo()),mv_par07,mv_par08,AF9->(RecNo()))[1]

					nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP"+AFB->AFB_TAREFA .And. x[2]==AFB->AFB_TIPOD})
					If nPosABC > 0
						aArrayABC[nPosABC ,04] += PmsTrunca(cTrunca,xMoedaPMS(nValorAFB,AFB->AFB_MOEDA,nMoedaPMS,"",,,,,,cTrunca,),nDecCst,AF9->AF9_QUANT)
					Else
						aAdd(aArrayABC,{"DSP"+AFB->AFB_TAREFA,;
										AFB->AFB_TIPOD,;
										0,;
										xMoedaPMS(nValorAFB,AFB->AFB_MOEDA,nMoedaPMS,"",,,,,,cTrunca,) ,;
										AFB->AFB_TAREFA,;
										0,;
										0,;
										0,;
										{},;
										0 })
					EndIf
					dbSelectArea("AFB")
					dbSkip()
				End
			EndIf

			dbSelectArea("AFN")
			dbSetOrder(1)
			dbSeek(xFilial("AFN") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While !Eof() .And. xFilial("AFN") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFN->AFN_FILIAL + AFN->AFN_PROJET + AFN->AFN_REVISA

				If AFN->(FieldPos("AFN_ESTOQU") > 0) .and. AFN->AFN_ESTOQU == "1"
					SD1->(dbSetOrder(1))
					SD1->(dbSeek(PmsFilial("SD1","AFN")+AFN->AFN_DOC+AFN->AFN_SERIE+AFN->AFN_FORNECE+AFN->AFN_LOJA+AFN->AFN_COD+AFN->AFN_ITEM))
					If (SD1->D1_COD < mv_par09 .Or. SD1->D1_COD > mv_par10)
						dbSelectArea("AFN")
						dbSkip()
						Loop
					Else
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial()+SD1->D1_COD))
						If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
							dbSelectArea("AFN")
							dbSkip()
							Loop
						EndIf
						nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
					EndIf

					If SD1->(FieldPos("D1_DTDIGIT")) > 0
						dDataMov	:=	SD1->D1_DTDIGIT
					Else
						dDataMov	:=	SD1->D1_EMISSAO
					Endif

					If dDataMov >= mv_par07 .And. dDataMov <= mv_par08
						nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1"+AFN->AFN_TAREFA .And. x[2]==SB1->B1_COD})

	            	nValConv := xMoedaPMS(SD1->D1_CUSTO,1,nMoedaPMS,"",,,,,,cTrunca,,"SD1")

						// adiciona informacoes sobre o produto
						aItemInfo := {}
						aAdd(aItemInfo, "AFN")
						aAdd(aItemInfo, AFN->AFN_FORNEC)
						aAdd(aItemInfo, Posicione("SA2", 1, xFilial("SA2") + AFN->AFN_FORNECE + AFN->AFN_LOJA, "A2_NOME"))
						aAdd(aItemInfo, AFN->AFN_DOC)
						aAdd(aItemInfo, AFN->AFN_SERIE)
						aAdd(aItemInfo, AFN->AFN_TIPONF)
						aAdd(aItemInfo, AFN->AFN_QUANT)
						aAdd(aItemInfo, PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT()))
						aAdd(aItemInfo, SD1->D1_EMISSAO)

						If nPosABC > 0
							aArrayABC[nPosABC ,06] += PmsAFNQUANT("QUANT")
							aArrayABC[nPosABC ,07] += PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT())
							aAdd(aArrayABC[nPosABC ,09], aItemInfo)
						Else
							aAdd(aArrayABC,{"SB1"+AFN->AFN_TAREFA,;
											SB1->B1_COD,;
											0,;
											0,;
											AFN->AFN_TAREFA,;
											PmsAFNQUANT("QUANT"),;
											PmsAFNQUANT("VALOR")*(nValConv/PmsSD1QUANT()),;
											0,;
											{aItemInfo},;
											nValSB1 })
						EndIf
					EndIf
				EndIf
				AFN->(dbSkip())
			End

			dbSelectArea("AFS")
			dbSetOrder(1)
			dbSeek(xFilial("AFS") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While AFS->(!Eof()) .And. xFilial("AFS") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFS->AFS_FILIAL + AFS->AFS_PROJET + AFS->AFS_REVISA
//				PmsIncProc()
				SD2->(dbSetOrder(4))
				SD2->(dbSeek(PmsFilial("SD2","AFS")+AFS->AFS_NUMSEQ))
				If (SD2->D2_COD < mv_par09 .Or. SD2->D2_COD > mv_par10)
					dbSelectArea("AFS")
					dbSkip()
					Loop
				Else
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial()+SD2->D2_COD))
					If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
						dbSelectArea("AFS")
						dbSkip()
						Loop
					EndIf
					nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
				EndIf

				If SD2->(FieldPos("D2_DTDIGIT") ) > 0 .and. !Empty(SD2->D2_DTDIGIT)
					dDataMov	:=	SD2->D2_DTDIGIT
				Else
					dDataMov	:=	SD2->D2_EMISSAO
				Endif
				If dDataMov >= mv_par07 .And. dDataMov <= mv_par08
					nSinal	:=	iIf(AFS->AFS_MOVPRJ $ '25',1,-1)
					nValConv := xMoedaPMS(SD2->D2_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD2")

					// adiciona informacoes sobre o produto
					aItemInfo := {}
					aAdd(aItemInfo, "AFS")
					aAdd(aItemInfo, SD2->D2_CLIENTE)
					aAdd(aItemInfo, Posicione("SA1", 1, xFilial("SA1") + SD2->(D2_CLIENTE+D2_LOJA), "A1_NOME"))
					aAdd(aItemInfo, AFS->AFS_DOC)
					aAdd(aItemInfo, AFS->AFS_SERIE)
					aAdd(aItemInfo, SD2->D2_TIPO)
					aAdd(aItemInfo, AFS->AFS_QUANT)
					aAdd(aItemInfo, nValConv*(AFS->AFS_QUANT/SD2->D2_QUANT)*nSinal)
					aAdd(aItemInfo, dDataMov)

					nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1"+AFN->AFN_TAREFA .And. x[2]==SB1->B1_COD})

					If nPosABC > 0
						aArrayABC[nPosABC ,06] += AFS->AFS_QUANT
						aArrayABC[nPosABC ,07] += nValConv * ( PmsAFSQUANT()/SD2->D2_QUANT )*nSinal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"SB1"+AFS->AFS_TAREFA,;
										SB1->B1_COD,;
										0,;
										0,;
										AFS->AFS_TAREFA,;
										AFS->AFS_QUANT,;
										nValConv*(PmsAFSQUANT()/SD2->D2_QUANT)*nSinal,;
										0,;
										{aItemInfo},;
										nValSB1 })
					EndIf

				EndIf
				AFS->(dbSkip())
			End

			dbSelectArea("AFI")
			dbSetOrder(1)
			MsSeek(xFilial("AFI")+AF8->AF8_PROJET+AF8->AF8_REVISA)
			While AFI->(!Eof()) .And. AFI_FILIAL+AFI_PROJET+AFI_REVISA==;
					xFilial("AFI")+AF8->AF8_PROJET+AF8->AF8_REVISA

//				PmsIncProc()
				SD3->(dbSetOrder(7))
				If SD3->(dbSeek(PmsFilial("SD3","AFI")+AFI->AFI_COD+AFI->AFI_LOCAL+DTOS(AFI->AFI_EMISSA)+AFI->AFI_NUMSEQ)) ;
					.And. !(SD3->D3_ESTORNO == "S") .And. !(SD3->D3_CF == "RE5") .And. SD3->D3_EMISSAO >= mv_par07 .And. SD3->D3_EMISSAO <= mv_par08
					If (SD3->D3_COD < mv_par09 .Or. SD3->D3_COD > mv_par10)
						dbSelectArea("SD3")
						dbSkip()
						Loop
					Endif
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial()+SD3->D3_COD))
					If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
						dbSelectArea("SD3")
						dbSkip()
						Loop
					EndIf
					nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
					nValConv := xMoedaPMS(SD3->D3_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"SD3")

					// adiciona informacao sobre o produto
					aItemInfo := {}
					aAdd(aItemInfo, "SD3")
					aAdd(aItemInfo, SD3->D3_EMISSAO)
					aAdd(aItemInfo, SD3->D3_DOC)
					aAdd(aItemInfo, SD3->D3_NUMSERI)
					aAdd(aItemInfo, SD3->D3_OP)
					aAdd(aItemInfo, SD3->D3_TIPO)
					aAdd(aItemInfo, SD3->D3_TM)

					If SD3->D3_TM > "500"
						aAdd(aItemInfo, SD3->D3_QUANT)
						If AF8->AF8_TPCUS=="2"
							aAdd(aItemInfo, SD3->D3_CUSFF1)
						Else
							aAdd(aItemInfo, nValConv)
						EndIf
					Else
						aAdd(aItemInfo, SD3->D3_QUANT*-1)
						If AF8->AF8_TPCUS=="2"
							aAdd(aItemInfo, SD3->D3_CUSFF1*-1)
						Else
							aAdd(aItemInfo, nValConv*-1)
						EndIf
					EndIf

					nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1"+SD3->D3_TASKPMS .And. x[2]==SB1->B1_COD})
					If nPosABC > 0
						If SD3->D3_TM > "500"
							aArrayABC[nPosABC ,06] += SD3->D3_QUANT
							If AF8->AF8_TPCUS=="2"
								aArrayABC[nPosABC ,07] += SD3->D3_CUSFF1
							Else
								aArrayABC[nPosABC ,07] += nValConv
							EndIf
						Else
							aArrayABC[nPosABC ,06] += SD3->D3_QUANT*-1
							If AF8->AF8_TPCUS=="2"
								aArrayABC[nPosABC ,07] += SD3->D3_CUSFF1*-1
							Else
								aArrayABC[nPosABC ,07] += nValConv*-1
							EndIf
						EndIf
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						If SD3->D3_TM > "500"
							If AF8->AF8_TPCUS=="2"
								aAdd(aArrayABC,{"SB1"+SD3->D3_TASKPMS,SB1->B1_COD,0,0,SD3->D3_TASKPMS,SD3->D3_QUANT,SD3->D3_CUSFF1,0, {aItemInfo},nValSB1})
							Else
								aAdd(aArrayABC,{"SB1"+SD3->D3_TASKPMS,SB1->B1_COD,0,0,SD3->D3_TASKPMS,SD3->D3_QUANT,nValConv,0, {aItemInfo},nValSB1})
							EndIf
						Else
							If AF8->AF8_TPCUS=="2"
								aAdd(aArrayABC,{"SB1"+SD3->D3_TASKPMS,SB1->B1_COD,0,0,SD3->D3_TASKPMS,SD3->D3_QUANT*-1,SD3->D3_CUSFF1*-1,0, {aItemInfo},nValSB1})
							Else
								aAdd(aArrayABC,{"SB1"+SD3->D3_TASKPMS,SB1->B1_COD,0,0,SD3->D3_TASKPMS,SD3->D3_QUANT*-1,nValConv*-1,0, {aItemInfo},nValSB1})
							EndIf
						EndIf
					EndIf
				EndIf
				dbSelectArea("AFI")
				dbSkip()
			End

			dbSelectArea("AFU")
			dbSetOrder(1)
			dbSeek(xFilial("AFU")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA)
			While AFU->(!Eof()) .And. AFU->AFU_FILIAL+AFU->AFU_CTRRVS+AFU->AFU_PROJET+AFU->AFU_REVISA==;
								xFilial("AFU")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA
				lRecProd := .F.
				If AFU->AFU_DATA >= mv_par07 .And. AFU->AFU_DATA <= mv_par08
					If !Empty(AFU->AFU_COD)
						If (AFU->AFU_COD < mv_par09 .Or. AFU->AFU_COD > mv_par10)
							dbSelectArea("AFU")
							dbSkip()
							Loop
						Else
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial("SB1")+AFU->AFU_COD))
							If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
								dbSelectArea("AFU")
								dbSkip()
								Loop
							EndIf
							nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
						EndIf
					ElseIf MV_PAR14 == 2 .and. Empty(AFU->AFU_COD)
						dbSelectArea("AE8")
						DbSetOrder(1)
						If dbseek(xFilial("AE8")+AFU->AFU_RECURS)
							If !EMPTY(AE8->AE8_PRODUT)
								If (AE8->AE8_PRODUT < mv_par09 .Or. AE8->AE8_PRODUT > mv_par10)
									dbSelectArea("AFU")
									dbSkip()
									Loop
								Else
									SB1->(dbSetOrder(1))
									SB1->(dbSeek(xFilial("SB1")+AE8->AE8_PRODUT))
									If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
										dbSelectArea("AFU")
										dbSkip()
										Loop
									EndIf
									nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
								EndIf
								lRecProd := .T.
							ENDIF
						Endif
					EndIf

					aItemInfo := {}
					aAdd(aItemInfo, "AFU")
					aAdd(aItemInfo, AFU->AFU_RECURS)
					aAdd(aItemInfo, Posicione("AE8", 1, xFilial() + AFU->AFU_RECURS, "AE8_DESCRI"))
					aAdd(aItemInfo, Posicione("AE8", 1, xFilial() + AFU->AFU_RECURS, "AE8_EQUIP"))
					aAdd(aItemInfo, Posicione("AED", 1, xFilial() + AFU->AFU_RECURS, "AED_DESCRI"))
					aAdd(aItemInfo, AFU->AFU_TAREFA)
					aAdd(aItemInfo, Posicione("AF9", 1, xFilial() + AFU->AFU_PROJET + AFU->AFU_REVISA + AFU->AFU_TAREFA, "AF9_DESCRI"))
					aAdd(aItemInfo, AFU->AFU_DATA)
					aAdd(aItemInfo, AFU->AFU_HORAI)
					aAdd(aItemInfo, AFU->AFU_HORAF)
					aAdd(aItemInfo, AFU->AFU_HQUANT)

					// Visualizar Custo Realizado por Produto
					If MV_PAR14 == 2 .and. !Empty(AFU->AFU_COD)
					  cCodigo := AFU->AFU_COD
					  cTipo   := "SB1"
					ElseIf lRecProd
						cCodigo := SB1->B1_COD
						cTipo   := "SB1"
					ElseIf !Empty(AFU->AFU_RECURS)
						cCodigo := AFU->AFU_RECURS
						cTipo   := "REC"
					Else
						cCodigo := AFU->AFU_COD
						cTipo   := "SB1"
					EndIf

					nPosABC := aScan(aArrayABC ,{|x| x[1]==cTipo+AFU->AFU_TAREFA .And. x[2]==cCodigo})
					nValConv := xMoedaPMS(AFU->AFU_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFU")
					If nPosABC > 0
						aArrayABC[nPosABC ,06] += AFU->AFU_HQUANT
						aArrayABC[nPosABC ,07] += nValConv
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						If cTipo = "REC"
							aAdd(aArrayABC,{"REC"+AFU->AFU_TAREFA,AFU->AFU_RECURS,0,0,AFU->AFU_TAREFA,AFU->AFU_HQUANT,nValConv,0, {aItemInfo},0})
						Else
							aAdd(aArrayABC,{"SB1"+AFU->AFU_TAREFA,SB1->B1_COD,0,0,AFU->AFU_TAREFA,AFU->AFU_HQUANT,nValConv,0, {aItemInfo},nValSB1})
						EndIf
					EndIf
				EndIf
				dbSelectArea("AFU")
				dbSkip()
			End

			If PmsChkAJC(.F.)
				dbSelectArea("AJC")
				dbSetOrder(1)
				dbSeek(xFilial("AJC")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA)
				While AJC->(!Eof()) .And. AJC->AJC_FILIAL+AJC->AJC_CTRRVS+AJC->AJC_PROJET+AJC->AJC_REVISA==;
									xFilial("AJC")+"1"+AF8->AF8_PROJET+AF8->AF8_REVISA
					If AJC->AJC_DATA >= mv_par07 .And. AJC->AJC_DATA <= mv_par08
						If AJC->AJC_TIPO=="1"
							If (AJC->AJC_COD < mv_par09 .Or. AJC->AJC_COD > mv_par10)
								dbSelectArea("AJC")
								dbSkip()
								Loop
							Else
								SB1->(dbSetOrder(1))
								SB1->(dbSeek(xFilial("SB1")+AJC->AJC_COD))
								If !Empty(aReturn[7]) .And. SB1->(!&(aReturn[7]))
									dbSelectArea("AJC")
									dbSkip()
									Loop
								EndIf
								nValSB1 := xMoedaPMS(PmsTrunca(cTrunca,RetFldProd(SB1->B1_COD,"B1_CUSTD"),nDecCst,),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")),nMoedaPMS,"",,,,,,cTrunca,)
								nPosABC := aScan(aArrayABC,{|x| x[1]=="SB1"+AJC->AJC_TAREFA .And. x[2]==SB1->B1_COD})
							EndIf
						Else
							nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP"+AJC->AJC_TAREFA .And. x[2]==AJC->AJC_TIPOD})
						EndIf

						nValConv := xMoedaPMS(AJC->AJC_CUSTO1,1,nMoedaPMS,"",,,,,,cTrunca,,"AJC")

						If nPosABC > 0
							aArrayABC[nPosABC ,06] += AJC->AJC_QUANT
							aArrayABC[nPosABC ,07] += nValConv
						Else
							If AJC->AJC_TIPO=="1"
								aAdd(aArrayABC,{"SB1"+AJC->AJC_TAREFA,SB1->B1_COD,0,0,AJC->AJC_TAREFA,AJC->AJC_QUANT,nValConv,0,{},nValSB1 })
							Else
								aAdd(aArrayABC,{"DSP"+AJC->AJC_TAREFA,AJC->AJC_TIPOD,0,0,AJC->AJC_TAREFA,AJC->AJC_QUANT,nValConv,0,{},0 })
							EndIf
						EndIf
					EndIf
					dbSelectArea("AJC")
					dbSkip()
				End
			EndIf

			dbSelectArea("AFR")
			dbSetOrder(1)
			dbSeek(xFilial("AFR") + AF8->AF8_PROJET + AF8->AF8_REVISA )
			While AFR->(!Eof()) .And. xFilial("AFR") + AF8->AF8_PROJET + AF8->AF8_REVISA  == AFR->AFR_FILIAL + AFR->AFR_PROJET + AFR->AFR_REVISA
//				PmsIncProc()
				If SE2->(dbSeek(PmsFilial("SE2","AFR")+AFR->AFR_PREFIXO+AFR->AFR_NUM+AFR->AFR_PARCELA+AFR->AFR_TIPO+AFR->AFR_FORNEC+AFR->AFR_LOJA)) .And.;
					SE2->E2_EMIS1 >= mv_par07 .And. SE2->E2_EMIS1 <= mv_par08
					aItemInfo := {}
					If (SE2->E2_TIPO $ MVABATIM+"/"+MV_CPNEG)		 // Se nao for abatimento
						nSinal :=	-1
					Else
						nSinal :=	1
					EndIf

					nValConv := xMoedaPMS(AFR->AFR_VALOR1,1,nMoedaPMS,"",,,,,,cTrunca,,"AFR")

					aAdd(aItemInfo, "AFR")
					aAdd(aItemInfo, AFR->AFR_FORNEC)
					aAdd(aItemInfo, Posicione("SA2", 1, xFilial("SA2") + AFR->AFR_FORNEC, "A2_NOME"))
					aAdd(aItemInfo, AFR->AFR_NUM)
					aAdd(aItemInfo, AFR->AFR_DATA)
					aAdd(aItemInfo, AFR->AFR_VENREA)
					aAdd(aItemInfo, nValConv*nSinal)

					nPosABC := aScan(aArrayABC,{|x| x[1]=="DSP"+AFR_TAREFA .And. x[2]==AFR->AFR_TIPOD})
					If nPosABC > 0
						aArrayABC[nPosABC ,07] += nValConv * nSinal
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						SX5->(dbSetOrder(1))
						SX5->(dbSeek(xFilial()+"FD"+AFR->AFR_TIPOD))
						aAdd(aArrayABC,{"DSP"+AFR->AFR_TAREFA,AFR_TIPOD,0,0,AFR->AFR_TAREFA,0,nValConv*nSinal,0, {aItemInfo},0})
					EndIf
				EndIf
				dbSelectArea("AFR")
				dbSkip()
			End

			SE5->(dbSetOrder(9))
			dbSelectArea("AJE")
			dbSetOrder(1)
			MsSeek(xFilial("AJE")+AF8->AF8_PROJET + AF8->AF8_REVISA ,.T.)
			While AJE->(!Eof()) .And. AJE_FILIAL+AJE_PROJET+AJE_REVISA==;
							xFilial("AJE")+AF8->AF8_PROJET + AF8->AF8_REVISA
//				PmsIncProc()
				If SE5->(dbSeek(xFilial("SE5")+AJE->AJE_ID)) .And.!(SE5->E5_SITUACA == "C") .And. (SE5->E5_RECPAG == "P") .And.;
						SE5->E5_DATA >= mv_par07 .And. SE5->E5_DATA <= mv_par08

					nValConv := xMoedaPMS(AJE->AJE_VALOR,1,nMoedaPMS,"",,,,,,cTrunca,,"AJE")

					aItemInfo := {}
					aAdd(aItemInfo, "SE5")
					aAdd(aItemInfo, SE5->E5_AGENCIA)
					aAdd(aItemInfo, SE5->E5_CONTA)
					aAdd(aItemInfo, nValConv)
					aAdd(aItemInfo, SE5->E5_NUMERO)
					aAdd(aItemInfo, SE5->E5_VENCTO)
					aAdd(aItemInfo, SE5->E5_NUMCHEQ)
					dbSelectArea("SA6")
					SA6->(dbSetOrder(1))
					SA6->(MSSeek(xFilial() + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA))
					aAdd(aItemInfo, SA6->A6_NOME)

					nPosABC := aScan(aArrayABC,{|x| x[1]=="MOV"+SE5->E5_TASKPMS})
					If nPosABC > 0
						aArrayABC[nPosABC ,07] += nValConv
						aAdd(aArrayABC[nPosABC ,09], aItemInfo)
					Else
						aAdd(aArrayABC,{"MOV"+SE5->E5_TASKPMS,"",0,0,SE5->E5_TASKPMS,0,nValConv,0, {aItemInfo},0})
					EndIf
				EndIf
				dbSelectArea("AJE")
				dbSkip()
			End

			If Len(aArrayABC) > 0

				lImpCabec := .T.
				@ nLi,000 PSAY STR0009 + AF8->AF8_PROJET + " - " + AF8->AF8_DESCRI  //"Projeto :"
				nLi++
				@ nLi,000 PSAY STR0010 + cVersao //"Versao  :"
				nLi++
				nLi++

				aArrayABC := aSort(aArrayABC,,,{|x,y|x[5]+x[2] < y[5]+y[2]})
				If Len(aArrayABC) > 0
					cTrfAtu	:= aArrayABC[1,5]
				EndIf
				SetRegua(Len(aArrayABC))
				For nx := 1 to Len(aArrayABC)
					IncRegua()

               QuebrPag()//Verifica o tamanho da pag. e quebra se necessario
					AF9->(dbSetOrder(1))
					AF9->(dbSeek(xFilial("AF9")+AF8->AF8_PROJET+AF8->AF8_REVISA+aArrayABC[nx,5]))
					Do Case
	           		//                                                                                          |                     PREVISTO                     |                          REALIZADO                      |      Saldo         |
	           		//Tarefa       Descricao                      Tp.     Codigo           Descricao         UM |    Quantidade              Valor  %Proj.  %Acum. | Qtde Empenhada  Qtde Atual      Valor   %Proj.   %Acum. | Qtde   Custo(Atual)|
	           		//123456789012 123456789012345678901234567890 XXX 123456789012345 1234567890123456789012 12 999999999999.99 999,999,999,999.99 999.99% 999.99%        999999999999.99   999999999999.99  999,999,999,999.99  999.99%  999.99%
				   //0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111122222222222222222222222222
				   //0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222
				   //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
						Case Substr(aArrayABC[nx,1],1,3)=="SB1"
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial("SB1")+aArrayABC[nx,2]))
							If nx == 1 .Or. aArrayABC[nx-1,5]!= cTrfAtu
								@ nLi,000 PSAY AF9->AF9_TAREFA

								If Len(AF9->AF9_TAREFA) > 12
									nLi++
								EndIf
								@ nLi,013 PSAY Substr(AF9->AF9_DESCRI,1,29)
							EndIf
							@ nLi,044 PSAY "PRD"
							@ nLi,048 PSAY SB1->B1_COD
							@ nLi,064 PSAY Substr(SB1->B1_DESC,1,20)
							@ nLi,087 PSAY SB1->B1_UM
							@ nLi,090 PSAY PadL(Transform(aArrayABC[nx,3], X3Picture("AFA_QUANT")), 15)
							@ nLi,106 PSAY aArrayABC[nx,4] Picture "@E 999,999,999,999.99"
							@ nLi,125 PSAY aArrayABC[nx,4]/nCustoPrj*100 Picture "@E 999.99%"
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							@ nLi,133 PSAY nPercAcm Picture "@E 999.99%"

				            If aArrayABC[nx,8] < 0
				               @ nLi,142 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 13)
				            Else
				               @ nLi,142 PSAY PadL(Transform(aArrayABC[nx,8], X3Picture("AFA_QUANT")), 13)
				               nTotEmp += aArrayABC[nx,8]
				            EndIf

							@ nLi,155 PSAY Transform(aArrayABC[nx,6], X3Picture("AFA_QUANT"))
							@ nLi,163 PSAY aArrayABC[nx,7] Picture "@E 999,999,999,999.99"
							@ nLi,184 PSAY aArrayABC[nx,7]/nCustoReal*100 Picture "@E 999.99%"
							nPercAcm2 += aArrayABC[nx,7]/nCustoReal*100
							@ nLi,193 PSAY nPercAcm2 Picture "@E 999.99%"

							nQtdeRepo:= (aArrayABC[nx,3]-aArrayABC[nx,6])
							@ nLi,195 PSAY nQtdeRepo Picture "@E 99,999,999.99"

							// Saldo com o calculo do Custo Previsto
							If mv_par11 == 2
								@ nLi,202 PSAY aArrayABC[nx,4]-aArrayABC[nx,7] Picture "@E 999,999,999,999.99"
							// Saldo com o calculo do Custo Atual
							Else
								If aArrayABC[nx,10]>0
									nValRepo:=aArrayABC[nx,10]
									@ nLi,202 PSAY nValRepo*nQtdeRepo Picture "@E 999,999,999,999.99"
									nTotTarefa+= nValRepo*nQtdeRepo
								Else
									nValRepo:=aArrayABC[nx,4]-aArrayABC[nx,7]
									@ nLi,202 PSAY nValRepo Picture "@E 999,999,999,999.99"
									nTotTarefa+= nValRepo
								EndIf
							EndIf
							nLi++

							// impressao dos detalhes do apontamento

							// os detalhes do apontamento sao armazenados no elemento
							// de indice 9 do aArrayABC
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Nota Fiscal de Entrada
										Case aArrayABC[nx, 9, ny, 1] == "AFN"
											QuebrPag()
											@ nLi, 013 PSAY STR0019 //"Fornecedor: "
											@ nLi, 025 PSAY aArrayABC[nx, 9, ny, 2]
											@ nLi, 043 PSAY "-"
											@ nLi, 045 PSAY Substr(aArrayABC[nx, 9, ny, 3], 1, 30) Picture PesqPict("SA2", "A2_NOME")

											@ nLi, 076 PSAY STR0020 //"NF:"
											@ nLi, 080 PSAY aArrayABC[nx, 9, ny, 4] Picture PesqPict("AFN", "AFN_DOC")
											@ nLi, 089 PSAY STR0021 //"Serie:"
											@ nLi, 096 PSAY aArrayABC[nx, 9, ny, 5] Picture PesqPict("AFN", "AFN_SERIE")
											@ nLi, 102 PSAY STR0022 //"Tipo:"
											@ nLi, 108 PSAY aArrayABC[nx, 9, ny, 6] Picture PesqPict("AFN", "AFN_TIPONF")
											@ nLi, 112 PSAY STR0023 //"Dt. Emis.:"
											@ nLi, 123 PSAY aArrayABC[nx, 9, ny, 9] Picture PesqPict("SD1", "D1_EMISSAO")

											@ nLi, 155 PSAY Transform(aArrayABC[nx, 9, ny, 7], X3Picture("AFN_QUANT"))
											@ nLi, 163 PSAY aArrayABC[nx, 9, ny, 8] Picture "@E 999,999,999,999.99"
											@ nLi, 184 PSAY Round(aArrayABC[nx, 9, ny, 8] / nCustoReal * 100, 2) Picture "@E 999.99%"
											nLi++

										// Nota Fiscal de Saida
										Case aArrayABC[nx, 9, ny, 1] == "AFS"
											QuebrPag()
											@ nLi, 013 PSAY STR0060+": " //"Cliente"
											@ nLi, 025 PSAY aArrayABC[nx, 9, ny, 2]
											@ nLi, 043 PSAY "-"
											@ nLi, 045 PSAY Substr(aArrayABC[nx, 9, ny, 3], 1, 30) Picture PesqPict("SA1", "A1_NOME")

											@ nLi, 076 PSAY STR0020 //"NF:"
											@ nLi, 080 PSAY aArrayABC[nx, 9, ny, 4] Picture PesqPict("AFS", "AFS_DOC")
											@ nLi, 089 PSAY STR0021 //"Serie:"
											@ nLi, 096 PSAY aArrayABC[nx, 9, ny, 5] Picture PesqPict("AFS", "AFS_SERIE")
											@ nLi, 102 PSAY STR0022 //"Tipo:"
											@ nLi, 108 PSAY aArrayABC[nx, 9, ny, 6] Picture PesqPict("SD2", "D2_TIPO")
											@ nLi, 112 PSAY STR0023 //"Dt. Emis.:"
											@ nLi, 123 PSAY aArrayABC[nx, 9, ny, 9] Picture PesqPict("SD2", "D2_EMISSAO")

											@ nLi, 155 PSAY AllTrim(Transform(aArrayABC[nx, 9, ny, 7], X3Picture("AFS_QUANT")))
											@ nLi, 163 PSAY aArrayABC[nx, 9, ny, 8] Picture "@E 999,999,999,999.99"
											@ nLi, 184 PSAY Round(aArrayABC[nx, 9, ny, 8] / nCustoReal * 100, 2) Picture "@E 999.99%"
											nLi++

										// Movimentacoes Internas
										Case aArrayABC[nx, 9, ny, 1] == "SD3"
											QuebrPag()
											@ nLi, 013 PSAY STR0024 //"Movimentacao Interna"
											@ nLi, 045 PSAY STR0023 //"Dt. Emis.:"
											@ nLi, 056 PSAY aArrayABC[nx, 9, ny, 2] Picture PesqPict("SD3", "D3_EMISSAO")
											@ nLi, 066 PSAY STR0025 //"Doc.:"
											@ nLi, 072 PSAY aArrayABC[nx, 9, ny, 3] Picture PesqPict("SD3", "D3_DOC")
											@ nLi, 081 PSAY STR0026 //"Num. Ser.:"
											@ nLi, 092 PSAY aArrayABC[nx, 9, ny, 4] Picture PesqPict("SD3", "D3_NUMSERI")
											@ nLi, 115 PSAY STR0027 //"Tp. Mov.:"
											@ nLi, 155 PSAY AllTrim(Transform(aArrayABC[nx, 9, ny, 7], X3Picture("D3_TM")))
											@ nLi, 155 PSAY aArrayABC[nx, 9, ny, 8] Picture PesqPict("SD3", "D3_QUANT")
											@ nLi, 163 PSAY aArrayABC[nx, 9, ny, 9] Picture "@E 999,999,999,999.99"
											@ nLi, 184 PSAY Round(aArrayABC[nx, 9, ny, 9] / nCustoReal * 100, 2) Picture "@E 999.99%"
											nLi++

										// Apontamento de Recursos
										Case aArrayABC[nx, 9, ny, 1] == "AFU"
											QuebrPag()
											@ nLi, 022 PSAY STR0034 //"Rec.:"
											@ nLi, 028 PSAY aArrayABC[nx, 9, ny, 02] Picture PesqPict("AFU", "AFU_RECURS")
											@ nLi, 044 PSAY "-"
											@ nLi, 046 PSAY Substr(aArrayABC[nx, 9, ny, 03], 1, 30) Picture PesqPict("AE8", "AE8_DESCRI")
											@ nLi, 079 PSAY STR0035 //"Tarefa:"
											@ nLi, 087 PSAY aArrayABC[nx, 9, ny, 06] Picture PesqPict("AFU", "AFU_TAREFA")
											If Len(aArrayABC[nx, 9, ny, 06]) > 12
												nLi++
											EndIf
											@ nLi, 100 PSAY "-"
											@ nLi, 102 PSAY Substr(aArrayABC[nx, 9, ny, 07], 1, 30) Picture PesqPict("AF9", "AF9_DESCRI")

											@ nLi, 135 PSAY PadL(Transform(aArrayABC[nx, 9, ny, 11], X3Picture("AFA_QUANT")), 15)
											nLi++
									EndCase
								Next nY
							EndIf

							If mv_par06 == 1 // relatorio analitico
								@ nLi, 000 PSAY __PrtThinLine()
								nLi++
							Else
								nLi++
							EndIf

							nCustoTrf += aArrayABC[nx,4]
						Case Substr(aArrayABC[nx,1],1,3)=="DSP"
							SX5->(dbSetOrder(1))
							SX5->(dbSeek(xFilial()+"FD"+aArrayABC[nx,2]))
							If nx == 1 .Or. aArrayABC[nx-1,5]!= cTrfAtu
								@ nLi,000 PSAY AF9->AF9_TAREFA

								If Len(AF9->AF9_TAREFA) > 12
									nLi++
								EndIf

								@ nLi,013 PSAY Substr(AF9->AF9_DESCRI,1,29)
							EndIf
							@ nLi,044 PSAY "DSP"
							@ nLi,048 PSAY Substr(aArrayABC[nx,2],1,20)
							@ nLi,064 PSAY Substr(X5Descri(), 1, 20)
							@ nLi,106 PSAY aArrayABC[nx,4] Picture "@E 999,999,999,999.99"
							@ nLi,125 PSAY aArrayABC[nx,4]/nCustoPrj*100 Picture "@E 999.99%"
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							@ nLi,133 PSAY nPercAcm Picture "@E 999.99%"
							@ nLi,142 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 15)
							@ nLi,155 PSAY Transform(aArrayABC[nx,6], X3Picture("AFA_QUANT"))
							@ nLi,163 PSAY aArrayABC[nx,7] Picture "@E 999,999,999,999.99"
							@ nLi,184 PSAY aArrayABC[nx,7]/nCustoReal*100 Picture "@E 999.99%"
							nPercAcm2 += aArrayABC[nx,7]/nCustoReal*100
							@ nLi,193 PSAY nPercAcm2 Picture "@E 999.99%"
							@ nLi,202 PSAY aArrayABC[nx,4]-aArrayABC[nx,7] Picture "@E 999,999,999,999.99"
							nLi++

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Despesas Financeiras
										Case aArrayABC[nx, 9, ny, 1] == "AFR"
										// Caso ultrapassar o tamanho da pagina "58", passa imprimir em nova pg
											QuebrPag()
											@ nLi, 013 PSAY aArrayABC[nx, 9, ny, 2]
											@ nLi, 020 PSAY "-"
											@ nLi, 022 PSAY Substr(aArrayABC[nx, 9, ny, 3], 1, 30) Picture PesqPict("SA2", "A2_NOME")

											@ nLi, 066 PSAY STR0028 //"Data:"
											@ nLi, 072 PSAY aArrayABC[nx, 9, ny, 5] Picture PesqPict("AFR", "AFR_DATA")
											@ nLi, 163 PSAY aArrayABC[nx, 9, ny, 7] Picture PesqPict("AFR", "AFR_VALOR1")
											@ nLi, 183 PSAY Round(aArrayABC[nx, 9, ny, 7]/nCustoReal*100, 2) Picture "@E 999.99%"
											nLi++
									EndCase
								Next nY
							EndIf

							If mv_par06 == 1 // relatorio analitico
								@ nLi, 000 PSAY __PrtThinLine()
								nLi++
							Else
								nLi++
							EndIf
							nTotTarefa += aArrayABC[nx,4]
							nCustoTrf  += aArrayABC[nx,4]
						Case Substr(aArrayABC[nx,1],1,3)=="MOV"
							If nx == 1 .Or. aArrayABC[nx-1,5]!= cTrfAtu
								@ nLi,000 PSAY AF9->AF9_TAREFA

								If Len(AF9->AF9_TAREFA) > 12
									nLi++
								EndIf

								@ nLi,013 PSAY Substr(AF9->AF9_DESCRI,1,29)
							EndIf
							QuebrPag()
							@ nLi,044 PSAY "MOV"
							@ nLi,064 PSAY STR0013 //"MOVIMENTO BANCARIO"
							@ nLi,106 PSAY aArrayABC[nx,4] Picture "@E 999,999,999,999.99"
							@ nLi,125 PSAY aArrayABC[nx,4]/nCustoPrj*100 Picture "@E 999.99%"
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							@ nLi,133 PSAY nPercAcm Picture "@E 999.99%"
							@ nLi,142 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 15)
							@ nLi,155 PSAY Transform(aArrayABC[nx,6], X3Picture("AFA_QUANT"))
							@ nLi,163 PSAY aArrayABC[nx,7] Picture "@E 999,999,999,999.99"
							@ nLi,184 PSAY aArrayABC[nx,7]/nCustoReal*100 Picture "@E 999.99%"
							nPercAcm2 += aArrayABC[nx,7]/nCustoReal*100
							@ nLi,193 PSAY nPercAcm2 Picture "@E 999.99%"
							nLi++

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// movimento bancario
										Case aArrayABC[nx, 9, ny, 1] == "SE5"
											QuebrPag()
											@ nLi, 013 PSAY STR0013 //"Movimento bancario"

											@ nLi, 045 PSAY STR0029 //"Banco:"
											@ nLi, 052 PSAY Substr(aArrayABC[nx, 9, ny, 8], 1, 30) Picture PesqPict("SA6", "A6_NOME")

											@ nLi, 086 PSAY STR0030 //"Agencia:"
											@ nLi, 095 PSAY aArrayABC[nx, 9, ny, 2] Picture PesqPict("SE5", "E5_AGENCIA")

											@ nLi, 103 PSAY STR0031 //"Conta:"
											@ nLi, 110 PSAY aArrayABC[nx, 9, ny, 3] Picture PesqPict("SE5", "E5_CONTA")

											@ nLi, 123 PSAY STR0032 //"Num. Tit.:"
											@ nLi, 134 PSAY aArrayABC[nx, 9, ny, 5] Picture PesqPict("SE5", "E5_NUMERO")

											@ nLi, 143 PSAY STR0033 //"Dt. Venc.:"
											@ nLi, 155 PSAY aArrayABC[nx, 9, ny, 6] Picture PesqPict("SE5", "E5_VENCTO")

											@ nLi, 171 PSAY aArrayABC[nx, 9, ny, 4] Picture PesqPict("SE5", "E5_VALOR")
											@ nLi, 180 PSAY Round(aArrayABC[nx, 9, ny, 4]/nCustoReal*100, 2) Picture "@E 999.99%"
											nLi++
									EndCase
								Next
							EndIf

							If mv_par06 == 1 // relatorio analitico
								@ nLi, 000 PSAY __PrtThinLine()
								nLi++
							Else
								nLi++
							EndIf

							nCustoTrf += aArrayABC[nx,4]
						Case Substr(aArrayABC[nx,1],1,3)=="REC"
							AE8->(dbSetOrder(1))
							AE8->(dbSeek(xFilial()+aArrayABC[nx,2]))
							If nx == 1 .Or. aArrayABC[nx-1,5]!= cTrfAtu
								@ nLi,000 PSAY AF9->AF9_TAREFA

								If Len(AF9->AF9_TAREFA) > 12
									nLi++
								EndIf

								@ nLi,013 PSAY Substr(AF9->AF9_DESCRI,1,29)
							EndIf
							@ nLi,044 PSAY "REC"
							@ nLi,048 PSAY AE8->AE8_RECURS
							@ nLi,064 PSAY Substr(AE8->AE8_DESCRI,1,20)
							@ nLi,087 PSAY "HR"
							@ nLi,090 PSAY PadL(Transform(aArrayABC[nx,3], X3Picture("AFA_QUANT")), 15)
							@ nLi,106 PSAY aArrayABC[nx,4] Picture "@E 999,999,999,999.99"
							@ nLi,125 PSAY aArrayABC[nx,4]/nCustoPrj*100 Picture "@E 999.99%"
							nPercAcm += aArrayABC[nx,4]/nCustoPrj*100
							@ nLi,133 PSAY nPercAcm Picture "@E 999.99%"
							@ nLi,142 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 15)
							@ nLi,155 PSAY Transform(aArrayABC[nx,6], X3Picture("AFA_QUANT"))
							@ nLi,163 PSAY aArrayABC[nx,7] Picture "@E 999,999,999,999.99"
							@ nLi,184 PSAY aArrayABC[nx,7]/nCustoReal*100 Picture "@E 999.99%"
							nPercAcm2 += aArrayABC[nx,7]/nCustoReal*100
							@ nLi,193 PSAY nPercAcm2 Picture "@E 999.99%"

							nQtdeRepo:= (aArrayABC[nx,3]-aArrayABC[nx,6])
							@ nLi,195 PSAY nQtdeRepo Picture "@E 99,999,999.99"

							// saldo com o cálculo do Custo Previsto
							If mv_par11==2
								@ nLi,202 PSAY aArrayABC[nx,4]-aArrayABC[nx,7] Picture "@E 999,999,999,999.99"

							// saldo com o cálculo do Custo Atual
							Else
								If aArrayABC[nx,10]>0
									nValRepo:=aArrayABC[nx,10]
									@ nLi,202 PSAY nValRepo*nQtdeRepo Picture "@E 999,999,999,999.99"
									nTotTarefa+= nValRepo*nQtdeRepo
								Else
									nValRepo:=aArrayABC[nx,4]-aArrayABC[nx,7]
									@ nLi,202 PSAY nValRepo Picture "@E 999,999,999,999.99"
									nTotTarefa+= nValRepo
								EndIf
							EndIf
							nLi++

							// impressao dos detalhes do apontamento
							If !Empty(aArrayABC[nx, 9]) .And. mv_par06 == 1 // relatorio analitico
								For ny := 1 To Len(aArrayABC[nx, 9])
									Do Case
										// Apontamento de Recursos
										Case aArrayABC[nx, 9, ny, 1] == "AFU"
											QuebrPag()
											@ nLi, 013 PSAY STR0034 //"Rec.:"
											@ nLi, 019 PSAY aArrayABC[nx, 9, ny, 02] Picture PesqPict("AFU", "AFU_RECURS")
											@ nLi, 035 PSAY "-"
											@ nLi, 037 PSAY Substr(aArrayABC[nx, 9, ny, 03], 1, 30) Picture PesqPict("AE8", "AE8_DESCRI")
											@ nLi, 079 PSAY STR0035 //"Tarefa:"
											@ nLi, 087 PSAY aArrayABC[nx, 9, ny, 06] Picture PesqPict("AFU", "AFU_TAREFA")

											If Len(aArrayABC[nx, 9, ny, 06]) > 12
												nLi++
											EndIf

											@ nLi, 100 PSAY "-"
											@ nLi, 102 PSAY Substr(aArrayABC[nx, 9, ny, 07], 1, 30) Picture PesqPict("AF9", "AF9_DESCRI")
											@ nLi, 160 PSAY PadL(Transform(aArrayABC[nx, 9, ny, 11], X3Picture("AFA_QUANT")), 15)
											nLi++
									EndCase
								Next nY
							EndIf

							If mv_par06 == 1 // relatorio analitico
								@ nLi, 000 PSAY __PrtThinLine()
								nLi++
							Else
								nLi++
							EndIf

							nCustoTrf += aArrayABC[nx,4]
					EndCase

					nRealTrf += aArrayABC[nx,7]
					nPrvPer += aArrayABC[nx,4]
					nRealPer+= aArrayABC[nx,7]

					If nx==Len(aArrayABC) .Or. aArrayABC[nx+1,5]!= cTrfAtu
						@ nLi,086 PSAY STR0014 //"Total da Tarefa....."
						@ nLi,106 PSAY nCustoTrf  Picture "@E 999,999,999,999.99"
						@ nLi,125 PSAY nCustoTrf /nCustoPrj*100 Picture "@E 999.99%"
						@ nLi,133 PSAY nPercAcm Picture "@E 999.99%"
						@ nLi,163 PSAY nRealTrf  Picture "@E 999,999,999,999.99"
						@ nLi,184 PSAY nRealTrf /nCustoReal*100 Picture "@E 999.99%"
						@ nLi,193 PSAY nPercAcm2 Picture "@E 999.99%"
						// Saldo com o calculo do Custo Atual
						If mv_par11 == 1
							nTotDsp	:= 0
							For nFaz:=nAux to nX
								If Substr(aArrayABC[nFaz ,01],1,3)=="DSP"
									If nx == 1 .Or. aArrayABC[nx-1,5] == cTrfAtu
										nTotDsp += aArrayABC[nFaz ,07]
									EndIf
								EndIf
							Next nFaz
							nAux += nX

							@ nLi,202 PSAY nTotTarefa-nTotDsp Picture "@E 999,999,999,999.99"
							nTotRepo   += nTotTarefa
							nTotDsp    := 0
							nTotTarefa := 0
						// Saldo com o calculo do Custo Previsto
						Else
							@ nLi,202 PSAY nCustoTrf-nRealTrf Picture "@E 999,999,999,999.99"
						EndIf
						nCustoTrf := 0
						nRealTrf  := 0
						nLi++
						nLi++
						If nx!=Len(aArrayABC)
							cTrfAtu := aArrayABC[nx+1,5]
						EndIf
					EndIf
					If lAbortPrint
						Exit
					EndIf

				Next nX
				nLi++
				@ nLi,086 PSAY STR0038 // "Totais do Periodo"
				@ nLi,106 PSAY nPrvPer   Picture "@E 999,999,999,999.99"
				@ nLi,163 PSAY nRealPer  Picture "@E 999,999,999,999.99"

				// Saldo com o calculo do Custo Previsto
				If mv_par11 == 2
					@ nLi,202 PSAY nPrvPer-nRealPer		Picture "@E 999,999,999,999.99"
				// Saldo com o calculo do Custo Atual
				Else
					nTotDsp	:=0
					For nFaz:=1 to Len(aArrayABC)
						If Substr(aArrayABC[nFaz ,01],1,3)=="DSP"
							nTotDsp+=aArrayABC[nFaz ,07]
						EndIf
					next nFaz
					@ nLi,202 PSAY nTotRepo-nTotDsp		Picture "@E 999,999,999,999.99"
				EndIf

				nLi++
				@ nLi,086 PSAY STR0039 //"Totais do Projeto"
				@ nLi,106 PSAY nCustoPrj   Picture "@E 999,999,999,999.99"
				If nTotEmp < 0
				   @ nLi,142 PSAY PadL(Transform(0, X3Picture("AFA_QUANT")), 15)
				Else
				   @ nLi,142 PSAY PadL(Transform(nTotEmp, X3Picture("AFA_QUANT")), 15)
				EndIf
				@ nLi,163 PSAY nCustoReal  Picture "@E 999,999,999,999.99"
				// Saldo com o calculo do Custo Previsto
				If mv_par11 == 2
					@ nLi,202 PSAY nCustoPrj-nRealPer Picture "@E 999,999,999,999.99"
				EndIf
				nTotEmp := 0
				nLi++
			EndIf
	EndCase
	If lAbortPrint
		@nLi,01 PSAY STR0063   //"*** Cancelado pelo Usuario ***"
		Exit
	EndIf
	dbSelectArea("AF8")
	dbSkip()
End

Roda(0,"",Tamanho)

RestArea(aArea)
Return

Static Function QuebrPag()//Verifica se a quantid. de linha estoura o tam. da pag, pulando para a proxima.
If nLi > 58
	nLi := 0
	nLi := Cabec(Titulo,Cabec1,Cabec2,nomeprog,Tamanho,CHRCOMP)
	nLi++
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcCusRecºAutor  ³                    º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMSR170 MP8                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CalcCusRec(cRecurso)
Local aArea     := GetArea()
Local nCustReal := 0

	dbSelectArea("AE8")
	dbSetOrder(1)
	If dbSeek(xFilial("AE8")+cRecurso)
		nValConv := xMoedaPMS(AE8->AE8_VALOR,1,nMoedaPMS,"",,,,,,,,"AE8")

		If AE8->AE8_TPREAL $"1"
			nCustReal	:= nValConv  // AE8_VALOR
		ElseIf AE8->AE8_TPREAL $"23"
			nCustReal	:= AE8->AE8_CUSFIX
		ElseIf AE8->AE8_TPREAL $"4"
			nCustReal	:= 0
		ElseIf AE8->AE8_TPREAL $ "5"

			If AE8->AE8_VALOR == 0
				nCustReal	:= AE8->AE8_CUSFIX
			Else
				nCustReal := nValConv // AE8->AE8_VALOR
			EndIf
		EndIf
	Else
		nCustReal := 0
	EndIf

	RestArea(aArea)

Return nCustReal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Edson Maricate      º Data ³  06/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMSR150 AP7                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}

PutSx1( "PMR170", "13","Previstos por      ?","Previstos por      ?","Previstos por      ?","mv_chD","N",1,0,2,"C","","","","",;
	"mv_par13","Recursos","Recursos","Resources","1","Produtos","Producto","Product","","","","","","","","","",/*help portugues*/,/*help ingles*/,/*help espanhol*/)

PutSx1( "PMR170", "14","Realizados por     ?","Realizados por     ?","Realizados por     ?","mv_chE","N",1,0,2,"C","","","","",;
	"mv_par14","Recursos","Recursos","Resources","1","Produtos","Producto","Product","","","","","","","","","",/*help portugues*/,/*help ingles*/,/*help espanhol*/)

If HasTemplate("CCT")
	aHelpSpa	:= {}
	aHelpEng	:= {}
	aHelpPor	:= { "Codigo inicial do insumo onde o filtro ", "deve considerar para efetuar a impressao" }
	PutSx1( "PMR170", "15","Insumo de?","Insumo de?","Insumo de?","mv_chF","C",15,0,2,"G","","","","",;
		"mv_par15","","","","","","","","","","","","","","","","",/*help portugues*/,/*help ingles*/,/*help espanhol*/)

	aHelpSpa	:= {}
	aHelpEng	:= {}
	aHelpPor	:= { "Codigo final do insumo onde o filtro ", "deve considerar para efetuar a impressao" }
	PutSx1( "PMR170", "16","Insumo ate?","Insumo ate?","Insumo ate?","mv_chG","C",15,0,2,"G","","","","",;
		"mv_par16","","","","","","","","","","","","","","","","",/*help portugues*/,/*help ingles*/,/*help espanhol*/)

	aHelpSpa	:= { "Moneda que se impreso no informe.", "Convertir de acuerdo database." }
	aHelpEng	:= { "Currency to be printed in report.  ", "Convert to agreement with database.      " }
	aHelpPor	:= { "Moeda a ser impressa no relatório.     ", "Conversao de acordo com data base.      " }
	PutSx1( "PMR170", "17","Imprimir em Moeda?","¿Que Moneda ?","Which Currency ?","mv_chH","N",1,0,2,"G","","","","",;
		"mv_par17","","","","1","","","","","","","","","","","","",aHelpPor,/*help ingles*/,/*help espanhol*/)


	aHelpSpa	:= { "Moneda que se impreso no informe.", "Convertir de acuerdo database." }
	aHelpEng	:= { "Currency to be printed in report.  ", "Convert to agreement with database.      " }
	aHelpPor	:= { "Moeda a ser impressa no relatório.     ", "Conversao de acordo com data base.      " }

	PutSx1( "PMR170", "18","Imprimir em Moeda?","¿Que Moneda ?","Which Currency ?","mv_chF","N",1,0,2,"G","","","","",;
		"mv_par15","","","","1","","","","","","","","","","","","",aHelpPor,/*help ingles*/,/*help espanhol*/)
Else

	aHelpSpa	:= { "Moneda que se impreso no informe.", "Convertir de acuerdo database." }
	aHelpEng	:= { "Currency to be printed in report.  ", "Convert to agreement with database.      " }
	aHelpPor	:= { "Moeda a ser impressa no relatório.     ", "Conversao de acordo com data base.      " }

	PutSx1( "PMR170", "16","Imprimir em Moeda?","¿Que Moneda ?","Which Currency ?","mv_chF","N",1,0,2,"G","","","","",;
		"mv_par15","","","","1","","","","","","","","","","","","",aHelpPor,/*help ingles*/,/*help espanhol*/)


EndIf

Return
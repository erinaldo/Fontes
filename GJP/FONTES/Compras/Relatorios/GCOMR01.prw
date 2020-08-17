#INCLUDE "RWMAKE.CH"
#INCLUDE "Protheus.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GCOMR01  º Autor ³ Carlos A. Queiroz  º Data ³  19/12/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de Pedido de Compras.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resorts                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GCOMR01()

Private _nVez  := 0
Private _nAA   := 0
Private aPerg  := {}
Private nQTDSC := 0
Private _cProd := ''
Private _nPAG  := 01

RptStatus({|| RunRepo2() }, 'Aguarde, processando relatório...')
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RunRepo2 º Autor ³ Carlos A. Queiroz  º Data ³  19/12/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de Pedido de Compras.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resorts                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunRepo2(Cabec1,Cabec2,Titulo, _nOrdem)
oPrn := TMSPrinter():New()
oPrn:SetLandscap()
oPrn:SetPaperSize(9) // A4
oPrn:Setup()
oPrn:EndPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Definicao de fontes a serem utilizadas na impressao do relatorio                   	//
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oFont06  := TFont():New( "Arial",,06,,.F.,,,,,.F. )
//oFont08  := TFont():New( "Arial",,08,,.F.,,,,,.F. )
//oFont08B := TFont():New( "Arial",,08,,.T.,,,,,.F. )
//oFont10  := TFont():New( "Arial",,10,,.F.,,,,,.F. )// Titulo Negrito com Sublinhado
//oFont10B := TFont():New( "Arial",,10,,.T.,,,,,.F. )// Titulo Negrito com Sublinhado
oFont08  := TFont():New( "Arial",,07,,.F.,,,,,.F. )
oFont08B := TFont():New( "Arial",,07,,.T.,,,,,.F. )
oFont10  := TFont():New( "Arial",,08,,.F.,,,,,.F. )// Titulo Negrito com Sublinhado
oFont10B := TFont():New( "Arial",,08,,.T.,,,,,.F. )// Titulo Negrito com Sublinhado

oFont11  := TFont():New( "Arial",,11,,.T.,,,,,.F. )
oFont11B := TFont():New( "Arial",,09,,.F.,,,,,.F. )// Titulo Negrito com Sublinhado
oFont13  := TFont():New( "Arial",,09,,.T.,,,,,.F. )
oFont13B := TFont():New( "Arial",,09,,.T.,,,,,.F. )// Titulo Negrito com Sublinhado

//oFont12  := TFont():New( "Arial",,12,,.F.,,,,,.F. )// Corpo do texto
oFont12B := TFont():New( "Arial",,12,,.T.,,,,,.F. )// Corpo do texto negrito
oFont12  := TFont():New( "Arial",,10,,.F.,,,,,.F. )// Corpo do texto
//oFont12B := TFont():New( "Arial",,10,,.T.,,,,,.F. )// Corpo do texto negrito
oFont14  := TFont():New( "Arial",,14,,.T.,,,,,.F. )
oFont14B := TFont():New( "Arial",,14,,.T.,,,,,.F. )
oFont16  := TFont():New( "Arial",,16,,.T.,,,,,.F. )
oFont16B := TFont():New( "Arial",,16,,.T.,,,,,.F. )
oFont18B := TFont():New( "Arial",,16,,.T.,,,,,.F. )
oFont20B := TFont():New( "Arial",,20,,.T.,,,,,.F. )
oFont24  := TFont():New( "Arial",,24,,.F.,,,,.T.,.F. )
oFont24BI:= TFont():New( "Arial",,24,,.T.,,,,.T.,.F. )
oFont24B := TFont():New( "Arial",,24,,.T.,,,,.F.,.F. )
oFont26BI:= TFont():New( "Arial",,26,,.T.,,,,.T.,.F. )
oFont26B := TFont():New( "Arial",,26,,.T.,,,,.F.,.F. )
oFont30B := TFont():New( "Arial",,30,,.T.,,,,.F.,.F. )
oFont32B := TFont():New( "Arial",,32,,.T.,,,,.F.,.F. )
oFont82B := TFont():New( "Arial",,82,,.T.,,,,.F.,.F. )
//oFont10I := TFont():New( "Arial",,10,,.F.,,,,,.F. )
oFont10I := TFont():New( "Arial",,09,,.T.,,,,,.F. )
oFont10I:Italic := .T.

nLinha    := 100
nColuna   := 010

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da impressao do relatorio                                                   	  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:StartPage()

//Monta Cabeçalhos primeira folha
If _nAA = 0
	mt2Cabec()
Endif

QryItens()

MontaDados()

If Select("TRB") > 0
	TRB->(dBCloseArea())
EndIf

oPrn:Preview()
ms_flush()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ mt2Cabec º Autor ³ Carlos A. Queiroz  º Data ³  19/12/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabecalho do Pedido de Compras.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resorts                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function mt2Cabec()
Local _cDataLib := ""

//Quadro da Pagina
oPrn:Box(350,070,1100,1301)
oPrn:Box(350,1301,1100,2400)
oPrn:Line(500,3260,500,3260)

oPrn:Line(720, 1301 ,720, 2400)//Linha

oPrn:Say(nLinha+0035,  nColuna+350 ,alltrim(SM0->M0_NOMECOM), oFont18B, 100)
oPrn:Say(nLinha+0035,  nColuna+1560 ,'- '+alltrim(SM0->M0_FILIAL), oFont18B, 100)
oPrn:Say(nLinha+0035,  nColuna+2350 ,'Pag. '+ alltrim(cValTochar(_nPAG)), oFont08B, 100)
oPrn:Say(nLinha+0140,  nColuna+100  ,'Ordem de Compra Nº '+alltrim(SC7->C7_NUM), oFont14B, 100)
//oPrn:Say(nLinha+0140,  nColuna+1450 ,'Fatura para '+alltrim(SM0->M0_NOMECOM), oFont10B, 100)
oPrn:Say(nLinha+0140,  nColuna+1000 ,'Fatura para '+alltrim(SM0->M0_NOMECOM), oFont14B, 100)
//oPrn:Say(nLinha+0140,  nColuna+2000 ,'- '+alltrim(SM0->M0_FILIAL), oFont14B, 100)

dbselectarea("SA2")
dbsetorder(1)
if dbseek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
	
	oPrn:Say(nLinha+0290,  nColuna+100 ,'Fornecedor', oFont11, 100)
	oPrn:Say(nLinha+0390,  nColuna+100 ,alltrim(SA2->A2_NOME), oFont11B, 100)
	oPrn:Say(nLinha+0450,  nColuna+100 ,alltrim(SA2->A2_END), oFont11B, 100)
	oPrn:Say(nLinha+0510,  nColuna+100 ,alltrim(SA2->A2_BAIRRO), oFont11B, 100)
	oPrn:Say(nLinha+0570,  nColuna+100 ,alltrim(SA2->A2_MUN), oFont11B, 100)
	oPrn:Say(nLinha+0630,  nColuna+100 ,alltrim(SA2->A2_CEP), oFont11B, 100)
	oPrn:Say(nLinha+0630,  nColuna+350 ,alltrim(SA2->A2_EST), oFont11B, 100)
	oPrn:Say(nLinha+0630,  nColuna+550 ,'CNPJ: '+alltrim(SA2->A2_CGC), oFont11B, 100)
	oPrn:Say(nLinha+0700,  nColuna+100 ,'Telefone: '+alltrim(SA2->A2_TEL), oFont11B, 100)
	oPrn:Say(nLinha+0760,  nColuna+100 ,'FAX:      '+alltrim(SA2->A2_FAX), oFont11B, 100)
	oPrn:Say(nLinha+0820,  nColuna+100 ,'Contato: '+alltrim(SA2->A2_CONTATO), oFont11B, 100)
	oPrn:Say(nLinha+0880,  nColuna+100 ,'Inscr. Estadual: '+alltrim(SA2->A2_INSCR), oFont11B, 100)
	oPrn:Say(nLinha+0880,  nColuna+650 ,'Inscr.Municipal: '+alltrim(SA2->A2_INSCRM), oFont11B, 100)
	
EndIf

oPrn:Say(nLinha+0290,  nColuna+1350 ,'Endereço de Entrega', oFont11, 100)
oPrn:Say(nLinha+0380,  nColuna+1350 ,alltrim(SM0->M0_ENDENT), oFont11B, 100)
oPrn:Say(nLinha+0440,  nColuna+1900 ,alltrim(SM0->M0_BAIRENT), oFont11B, 100)
oPrn:Say(nLinha+0500,  nColuna+1350 ,alltrim(SM0->M0_CIDENT), oFont11B, 100)
oPrn:Say(nLinha+0500,  nColuna+2200 ,alltrim(SM0->M0_ESTENT), oFont11B, 100)
oPrn:Say(nLinha+0560,  nColuna+1350 ,"CEP: "+alltrim(SM0->M0_CEPENT), oFont11B, 100)
oPrn:Say(nLinha+0560,  nColuna+1900 ,"CNPJ: "+alltrim(SM0->M0_CGC), oFont11B, 100)

oPrn:Say(nLinha+0670,  nColuna+1350 ,'Endereço de Cobrança', oFont11, 100)
oPrn:Say(nLinha+0760,  nColuna+1350 ,alltrim(SM0->M0_ENDCOB), oFont11B, 100)
oPrn:Say(nLinha+0820,  nColuna+1900 ,alltrim(SM0->M0_BAIRCOB), oFont11B, 100)
oPrn:Say(nLinha+0880,  nColuna+1350 ,alltrim(SM0->M0_CIDCOB), oFont11B, 100)
oPrn:Say(nLinha+0880,  nColuna+2200 ,alltrim(SM0->M0_ESTCOB), oFont11B, 100)
oPrn:Say(nLinha+0940,  nColuna+1350 ,"CEP: "+alltrim(SM0->M0_CEPCOB), oFont11B, 100)
oPrn:Say(nLinha+0940,  nColuna+1900 ,"CNPJ: "+alltrim(SM0->M0_CGC), oFont11B, 100)

oPrn:Say(nLinha+1040,  nColuna+100  ,'Data da Ordem de Compra: ', oFont11, 100)
oPrn:Say(nLinha+1041,  nColuna+630  ,alltrim(substr(DTOS(SC7->C7_EMISSAO),7,2)+"/"+substr(DTOS(SC7->C7_EMISSAO),5,2)+"/"+substr(DTOS(SC7->C7_EMISSAO),1,4)), oFont11B, 100)

oPrn:Say(nLinha+1040,  nColuna+1300 ,'Inscr. Estadual: ', oFont11, 100)
oPrn:Say(nLinha+1041,  nColuna+1600 ,alltrim(SM0->M0_INSC), oFont11B, 100)
oPrn:Say(nLinha+1040,  nColuna+1810 ,'Inscr. Municipal: ', oFont11, 100)
oPrn:Say(nLinha+1041,  nColuna+2120 ,alltrim(SM0->M0_INSCM), oFont11B, 100)

If SC7->C7_CONAPRO == "B" .And. SC7->C7_QUJE < SC7->C7_QUANT
	oPrn:Say(nLinha+1110,  nColuna+1810 ,'Ordem de Compra Bloqueada', oFont11, 100)
Else
	dbselectarea("SCR")
	dbsetorder(1)
	If dbseek(SC7->C7_FILIAL+"PC"+SC7->C7_NUM)
		While SCR->(!EOF()) .and. (SC7->C7_FILIAL+"PC"+SC7->C7_NUM == SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM)
			_cDataLib := SCR->CR_DATALIB
			SCR->(dbskip())
		EndDo
//		If !Empty(_cDataLib)
			oPrn:Say(nLinha+1110,  nColuna+1810 ,'O.C. Aprovada Eletronicamente', oFont11, 100)
			oPrn:Say(nLinha+1170,  nColuna+1810 ,'em: ', oFont11, 100)
			oPrn:Say(nLinha+1170,  nColuna+1900 ,alltrim(substr(DTOS(SCR->CR_DATALIB),7,2)+"/"+substr(DTOS(SCR->CR_DATALIB),5,2)+"/"+substr(DTOS(SCR->CR_DATALIB),1,4)), oFont11B, 100)
//		EndIf
	EndIf
EndIf

If !Empty(SC7->C7_CC)
	oPrn:Say(nLinha+1170,  nColuna+100  ,'Centro de Custo: ', oFont11, 100)
	oPrn:Say(nLinha+1170,  nColuna+450  ,alltrim(SC7->C7_CC), oFont11B, 100)
	oPrn:Say(nLinha+1170,  nColuna+670  ,alltrim(CTT->CTT_DESC01), oFont11B, 100)	
Else
	oPrn:Say(nLinha+1170,  nColuna+100  ,'Centro de Custo: ', oFont11, 100)
EndIf

If !Empty(SC7->C7_CLVL)
	oPrn:Say(nLinha+1270,  nColuna+100  ,'Atividade / Projeto: ', oFont11, 100)
	oPrn:Say(nLinha+1270,  nColuna+470  ,alltrim(SC7->C7_CLVL), oFont11B, 100)
	oPrn:Say(nLinha+1270,  nColuna+590  ,alltrim(CTH->CTH_DESC01), oFont11B, 100)	
Else
	oPrn:Say(nLinha+1270,  nColuna+100  ,'Atividade / Projeto: ', oFont11, 100)
EndIf

oPrn:Say(nLinha+1390,  nColuna+100  ,'HORÁRIO DE ENTREGA: 08:00h às 11:30 e 13:00h às 16:30h (Exceto finais de semana, sendo recebimento por ordem de chegada).', oFont13B, 100)
oPrn:Say(nLinha+1450,  nColuna+100  ,'NÃO será aceito pedido com divergência superior a 20% da quantidade pedida; NÃO será recebido pedido com diferença de custo unitário, sendo', oFont10I, 100)
oPrn:Say(nLinha+1510,  nColuna+100  ,' devolvido o item na hora do recebimento;', oFont10I, 100)
oPrn:Say(nLinha+1570,  nColuna+100  ,'ATENTAR PARA A QUANTIDADE PROGRAMADA NAS ENTREGAS. FAVOR MENCIONAR NA NF O NÚMERO DA ORDEM DE COMPRA. ', oFont13B, 100,CLR_HRED)
oPrn:Say(nLinha+1630,  nColuna+100  ,'ATENTAR PARA O CNPJ CORRETO DE FATURAMENTO.', oFont13B, 100,CLR_HRED)

oPrn:Say(nLinha+1750,  nColuna+100  ,'Prezados Senhores, ', oFont13B, 100)
oPrn:Say(nLinha+1810,  nColuna+100  ,'Solicitamos fornecer o material abaixo discriminado, faturado em nome e por conta de ', oFont13B, 100)
oPrn:Say(nLinha+1870,  nColuna+100  ,alltrim(SM0->M0_NOMECOM), oFont13B, 100)
oPrn:Say(nLinha+1870,  nColuna+800 ,'-'+alltrim(SM0->M0_FILIAL), oFont13B, 100)

nLinha += 20

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QryItens º Autor ³ Carlos A. Queiroz  º Data ³  19/12/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtro do Pedido de Compras.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resorts                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QryItens()
Local cQuery := ""

cQuery := "SELECT * "
cQuery += "FROM "+RetSqlName("SC7")+" SC7, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM"
cQuery += "WHERE SC7.C7_FILIAL = '"+SC7->C7_FILIAL+"' "
cQuery += "AND SC7.C7_NUM  = '"+SC7->C7_NUM+"' "
cQuery += "AND SC7.D_E_L_E_T_ <> '*' "

//cQuery += "AND SUBSTRING(SC7.C7_FILIAL,1,2) = SB1.B1_FILIAL "     //Alterado por Carlos Queiroz em 28/05/15 decorrente da versão 12
cQuery += "AND SC7.C7_PRODUTO  = SB1.B1_COD "
cQuery += "AND SB1.D_E_L_E_T_ <> '*' "

//cQuery += "AND SB1.B1_FILIAL = SUBSTRING(SBM.BM_FILIAL,1,2) "    //Alterado por Carlos Queiroz em 28/05/15 decorrente da versão 12
cQuery += "AND SB1.B1_GRUPO  = SBM.BM_GRUPO "
cQuery += "AND SBM.D_E_L_E_T_ <> '*' "

cQuery += "ORDER BY SC7.C7_FILIAL, SB1.B1_GRUPO, SB1.B1_COD, SC7.C7_NUM,SC7.C7_ITEM "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaDadosº Autor ³ Carlos A. Queiroz  º Data ³  17/12/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Itens e rodape ref. ao Pedido de Compras.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resorts                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaDados()

Local _cNomFil := ''
Local _cEmpresa := SM0->M0_CODIGO
Local _cEmpCorr := _cEmpresa
Local _cCorrente:= SM0->M0_CODFIL
Local _cGrupo   := ""
Local i := 0
Local nTotParcial := 0
Local nTotDescont := 0
Local nTotIPI := 0
Local nTotIcms    := 0
Local nTotFrete   := 0
Local cTotTpFrt   := ""
Local nTotGeral   := 0
Local cCondPg     := ""
Local cComprador  := ""
Local cObserv     := ""
Local cObserv2    := ""
Local aObserv     := {}
Local nTotDespesa := 0
DbSelectarea("SM0")
Dbsetorder(1)
Dbgotop()
Dbseek(_cEmpCorr+TRB->C7_FILIAL)
_cNomFil := SM0->M0_FILIAL

dbSelectArea("TRB")
dbGoTop()

If TRB->(Eof())
	TRB->(dBCloseArea())
	Return .T.
EndIf

While !TRB->(Eof())
	i++
	TRB->(dbskip())
EndDo

dbSelectArea("TRB")
dbGoTop()
SetRegua(i)

While !TRB->(Eof())
	IncRegua()
	
//	nLinha <= 120 .or. nLinha > 7000
	If nLinha <= 120 .or. nLinha > 2900
		
		If nLinha > 2900
			
			oPrn:EndPage()
			oPrn:StartPage()
			nLinha    := 100
			nColuna   := 010
			_nPAG++
			oPrn:Say(nLinha-50,  nColuna+2350 ,'Pag. '+ alltrim(cValTochar(_nPAG)), oFont08B, 100)
			
		Else
			nLinha := nLinha+1930
		EndIf

//		oPrn:Say(nLinha,  nColuna+100  ,'- Itens __________________________________________ Unit. ___ Quant.______ Vlr.Unit. ____ Vlr.Total ______ Dt.Entrega______C.Custo__________________ Num.SC', oFont10B, 100)		
		oPrn:Say(nLinha,  nColuna+100  ,'- Itens ______________________________________ Unit. ___ Quant.______ Vlr.Unit. ___ Vlr.Total _ Dt.Entrega____C.Custo________________ Num.SC', oFont13B, 100)
		If nLinha == 100
			nLinha := nLinha+30
		EndIf
	EndIf
	
	If _cGrupo <> TRB->BM_GRUPO
//		nLinha := nLinha+80
		nLinha := nLinha+60
		oPrn:Say(nLinha,  nColuna+100  ,ALLTRIM(TRB->BM_GRUPO)+SPACE(10)+ALLTRIM(TRB->BM_DESC), oFont10B, 100)
//		nLinha := nLinha+40
		nLinha := nLinha+20
//		oPrn:Say(nLinha,  nColuna+100  ,'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------', oFont10B, 100)
		oPrn:Say(nLinha,  nColuna+100  ,'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------', oFont10B, 100)
	EndIf
	
	nLinha := nLinha+60
	oPrn:Say(nLinha,  nColuna+0100  ,alltrim(TRB->C7_PRODUTO), oFont08, 100)
	oPrn:Say(nLinha,  nColuna+0280  ,alltrim(TRB->B1_DESC), oFont08, 100)

	If !EMPTY(TRB->C7_SEGUM)	
		oPrn:Say(nLinha,  nColuna+0890  ,alltrim(TRB->C7_SEGUM), oFont08, 100)
		oPrn:Say(nLinha,  nColuna+1000  ,TransForm(TRB->C7_QTSEGUM,PesqPict("SC7","C7_QTSEGUM")), oFont08B, 100)
		oPrn:Say(nLinha,  nColuna+1150  ,"  "+TransForm((TRB->C7_TOTAL/TRB->C7_QTSEGUM),PesqPict("SC7","C7_PRECO")), oFont08B, 100)
		oPrn:Say(nLinha,  nColuna+1360  ,"  "+TransForm(TRB->C7_TOTAL,PesqPict("SC7","C7_TOTAL")), oFont08B, 100)
	Else
		oPrn:Say(nLinha,  nColuna+0890  ,alltrim(TRB->C7_UM), oFont08, 100)
		oPrn:Say(nLinha,  nColuna+1000  ,TransForm(TRB->C7_QUANT,PesqPict("SC7","C7_QUANT")), oFont08B, 100)
		oPrn:Say(nLinha,  nColuna+1150  ,"  "+TransForm(TRB->C7_PRECO,PesqPict("SC7","C7_PRECO")), oFont08B, 100)
		oPrn:Say(nLinha,  nColuna+1360  ,"  "+TransForm(TRB->C7_TOTAL,PesqPict("SC7","C7_TOTAL")), oFont08B, 100)
	EndIf		
	
//	dbselectarea("SC1")
//	dbsetorder(1)
//	If dbseek(TRB->C7_FILIAL+TRB->C7_NUMSC+TRB->C7_ITEMSC)
//		oPrn:Say(nLinha,  nColuna+1610  ,substr(dtos(SC1->C1_DATPRF),7,2)+"/"+substr(dtos(SC1->C1_DATPRF),5,2)+"/"+substr(dtos(SC1->C1_DATPRF),1,4), oFont08B, 100)
//	EndIf
	
	oPrn:Say(nLinha,  nColuna+1620  ,substr(TRB->C7_DATPRF,7,2)+"/"+substr(TRB->C7_DATPRF,5,2)+"/"+substr(TRB->C7_DATPRF,1,4), oFont08, 100)
//	oPrn:Say(nLinha,  nColuna+1900  ,alltrim(TRB->C7_CC), oFont08B, 100)
		dbSelectArea("CTT")
		dbSetOrder(1)
		If dbSeek(xFilial("CTT")+TRB->C7_CC)
			oPrn:Say(nLinha,  nColuna+1850  ,alltrim(CTT->CTT_DESC01), oFont08, 100)
        EndIf
//	oPrn:Say(nLinha,  nColuna+2320  ,alltrim(TRB->C7_NUMSC), oFont08B, 100)
	oPrn:Say(nLinha,  nColuna+2290  ,alltrim(TRB->C7_NUMSC), oFont08, 100)
	
	If !EMPTY(TRB->C7_OBS)
		nLinha := nLinha + 60
		oPrn:Say(nLinha,  nColuna+100  ,alltrim(TRB->C7_OBS), oFont08, 100)
	EndIf
	
	_cGrupo := TRB->BM_GRUPO
	
	TRB->(dbskip())
EndDo

If nLinha > 2900
	
	oPrn:EndPage()
	oPrn:StartPage()
	
	nLinha    := 100
	nColuna   := 010
	_nPAG++
	oPrn:Say(nLinha-50,  nColuna+2350 ,'Pag. '+ alltrim(cValTochar(_nPAG)), oFont08B, 100)
	
EndIf

// nLinha := nLinha + 200
nLinha := nLinha + 100
//oPrn:Say(nLinha,  nColuna+100  ,'_____________________________________________________________________________________________________Totais_____________________________________', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+100  ,'______________________________________________________________________________________________Totais____________________________', oFont13B, 100)

TRB->(dbgotop())

dbselectarea("SE4")
dbsetorder(1)
If dbseek(xFilial("SE4")+TRB->C7_COND)
	cCondPg    := SE4->E4_DESCRI 		//Posicione("SE4",1,xFilial("SE4")+TRB->C7_COND,"E4_DESCRI")
EndIf
cComprador := Posicione("SY1",3,xFilial("SY1")+TRB->C7_USER,"Y1_NOME")

dbSelectArea("SC7")
dbSetOrder(1)
If dbSeek(TRB->C7_FILIAL+TRB->C7_NUM)
	cObserv  := substr(SC7->C7_XOBS,1,150)
EndIf

For i:=1 to Len(cObserv)
	if !isalpha(substr(cObserv,i,1)) .and. !isdigit(substr(cObserv,i,1)) .and. (!substr(cObserv,i,1) $ '~!@#$%^&*()_-+={}[]|\:;""<>,.?/º')
		if substr(cObserv,i,2)  == chr(13)+chr(10) .or. (empty(substr(cObserv,i,1)) .and. len(cObserv2) > 210)
			aadd(aObserv,alltrim(cObserv2))
			cObserv2 := ""
		elseif  empty(substr(cObserv,i,1))
			cObserv2 += substr(cObserv,i,1)
		endif
	else
		cObserv2 += substr(alltrim(cObserv),i,1)
	endif
Next i

If !empty(cObserv2)
	aadd(aObserv,cObserv2)
EndIf

dbselectarea("SCR")
dbsetorder(1)
If dbseek(TRB->C7_FILIAL+"PC"+TRB->C7_NUM)
	aadd(aObserv,"Aprovadores:")
	While SCR->(!EOF()) .and. alltrim(TRB->C7_FILIAL+"PC"+TRB->C7_NUM) == alltrim(SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM)
		aadd(aObserv,ALLTRIM(SCR->CR_USER)+" - "+ALLTRIM(FWGetUserName(SCR->CR_USER)))
		SCR->(dbskip())
	EndDo
EndIf

cTotTpFrt   := IIf(TRB->C7_TPFRETE=="C","CIF",IIf(TRB->C7_TPFRETE=="F","FOB"," - "))

While TRB->(!eof())
	nTotParcial += TRB->C7_TOTAL
	nTotIPI     += TRB->C7_VALIPI
	nTotIcms    += TRB->C7_VALSOL
	nTotFrete   += TRB->C7_VALFRE
	nTotDescont += TRB->C7_VLDESC
	nTotDespesa += TRB->C7_DESPESA
	TRB->(dbskip())
EndDo

nTotGeral  := (nTotParcial + nTotIPI + nTotIcms + nTotFrete + nTotDespesa) - nTotDescont

nLinha := nLinha + 60
oPrn:Say(nLinha,  nColuna+100  ,'Condições de Pagamento: '+alltrim(cCondPg), oFont13B, 100)
oPrn:Say(nLinha,  nColuna+1800 ,'Total Parcial:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+2010 ,'R$ '+TransForm(nTotParcial,PesqPict("SC7","C7_TOTAL")), oFont08, 100)

nLinha := nLinha + 60
oPrn:Say(nLinha,  nColuna+100  ,'Comprador:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+300  ,alltrim(cComprador), oFont08, 100)
oPrn:Say(nLinha,  nColuna+1800 ,'IPI:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+2010 ,'R$ '+TransForm(nTotIPI,PesqPict("SC7","C7_VALIPI")), oFont08, 100)

nLinha := nLinha + 60
oPrn:Say(nLinha,  nColuna+100 ,'Total por Extenso:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+400 ,Extenso(nTotGeral), oFont08, 100)

If !Empty(SC7->C7_CONTRA)
	nLinha := nLinha + 60
	oPrn:Say(nLinha,  nColuna+100  ,'Pedido de Compras proveniente do Contrato: ', oFont13B, 100)
	oPrn:Say(nLinha,  nColuna+850  ,alltrim(SC7->C7_CONTRA), oFont08, 100)
EndIf

nLinha := nLinha + 10
oPrn:Say(nLinha,  nColuna+1800 ,'ICMS ST:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+2010 ,'R$ '+TransForm(nTotIcms,PesqPict("SC7","C7_VALSOL")), oFont08, 100)

nLinha := nLinha + 60
oPrn:Say(nLinha,  nColuna+1800 ,'Frete:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+2010 ,'R$ '+TransForm(nTotFrete,PesqPict("SC7","C7_VALFRE")), oFont08, 100)

nLinha := nLinha + 60
oPrn:Say(nLinha,  nColuna+1800 ,'Tipo Frete:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+2010 ,alltrim(cTotTpFrt), oFont08, 100)

nLinha := nLinha + 60
oPrn:Say(nLinha,  nColuna+1800 ,'Desconto:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+2010 ,'R$ '+TransForm(nTotDescont,PesqPict("SC7","C7_VLDESC")), oFont08, 100)

nLinha := nLinha + 60
oPrn:Say(nLinha,  nColuna+1800 ,'Despesas:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+2010 ,'R$ '+TransForm(nTotDespesa,PesqPict("SC7","C7_DESPESA")), oFont08, 100)

nLinha := nLinha + 60
oPrn:Say(nLinha,  nColuna+1800 ,'Total Geral:', oFont13B, 100)
oPrn:Say(nLinha,  nColuna+2010 ,'R$ '+TransForm(nTotGeral,PesqPict("SC7","C7_TOTAL")), oFont08, 100)

//nLinha := nLinha + 60
//oPrn:Say(nLinha,  nColuna+100 ,'Total por Extenso:', oFont13B, 100)
//oPrn:Say(nLinha,  nColuna+400 ,Extenso(nTotGeral), oFont08, 100)

If nLinha > 2900
	oPrn:EndPage()
	oPrn:StartPage()
	nLinha    := 100
	nColuna   := 010
	_nPAG++
	oPrn:Say(nLinha-50,  nColuna+2350 ,'Pag. '+ alltrim(cValTochar(_nPAG)), oFont08B, 100)
EndIf

If !Empty(aObserv)
//nLinha := nLinha + 200
nLinha := nLinha + 100
oPrn:Say(nLinha,  nColuna+100  ,'____Observações da Ordem de Compras___________________________________________________________________________________________', oFont13B, 100)
nLinha := nLinha + 100

For i:=1 to Len(aObserv)
	If !empty(aObserv[i])
		oPrn:Say(nLinha,  nColuna+100  ,alltrim(aObserv[i]), oFont08, 100)
		nLinha := nLinha + 60
	EndIf
	If nLinha > 3000 .and. ((i+1) <= Len(aObserv))
		oPrn:EndPage()
		oPrn:StartPage()
		nLinha    := 300
		nColuna   := 010
		_nPAG++
		oPrn:Say(nLinha-50,  nColuna+2350 ,'Pag. '+ alltrim(cValTochar(_nPAG)), oFont08B, 100)
	EndIf
Next i

//nLinha := nLinha + 300
nLinha := nLinha + 150  
//oPrn:Say(nLinha, nColuna+100 ,'________________________________________________________________________________________________________________________________', oFont13B, 100)
EndIf

/*

nLinha := nLinha + 300
oPrn:Say(nLinha,  nColuna+0100  ,'_________________________________', oFont10B, 100)

oPrn:Say(nLinha,  nColuna+1000  ,'_________________________________', oFont10B, 100)

oPrn:Say(nLinha,  nColuna+1900  ,'_________________________________', oFont10B, 100)

nLinha := nLinha + 100
oPrn:Say(nLinha,  nColuna+0100  ,alltrim(upper(cComprador)), oFont10B, 100)

oPrn:Say(nLinha,  nColuna+1000  ,'GERENCIA', oFont10B, 100)

oPrn:Say(nLinha,  nColuna+1900  ,'DIRETORIA', oFont10B, 100)

nLinha := nLinha + 10 
oPrn:Say(nLinha, nColuna+0100 ,'___________________________________________________________________________________________________________________________________', oFont13B, 100)
  
*/

Return()
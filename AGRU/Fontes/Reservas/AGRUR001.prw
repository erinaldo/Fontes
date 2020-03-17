/*
oReport:SetTotalInLine(.F.)
oReport:SetTitle('Protheus Report Utility')
oReport:SetLineHeight(30)
oReport:SetColSpace(1)
oReport:SetLeftMargin(0)
oReport:oPage:SetPageNumber(1)
oReport:cFontBody := 'Courier New'
oReport:nFontBody := 6
oReport:lBold := .F.
oReport:lUnderLine := .F.
oReport:lHeaderVisible := .T.
oReport:lFooterVisible := .T.
oReport:lParamPage := .F.

oReport:ThinLine()
*/

#INCLUDE "Protheus.CH"

User Function xTReport()

Local oReport
Private cPerg := "AGRUR001"

Pergunte(cPerg,.F.) //

oReport := ReportDef()
oReport:PrintDialog()

Return

/*
******************************************************************
Objeto
******************************************************************
*/

Static Function ReportDef()

Local oReport, oBreak

fCriaSX1() //Cria Parametros

oReport := TReport():New('AGRUR001',"Controle de Reserva AGRU",cPerg,{|oReport| PrintReport(oReport)},"Este programa ira emitir a relacao de Produtos Reservados",,,,,,,)
oReport:NoUserFilter()
oReport:SetEdit(.F.)

//Seção 1 - Filtro por Produto
oTREPORT01:= TRSection():New(oReport,'Produto',{"SB1","SB2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/,,,,,,,,,,,,,,,)
TRCell():New(oTREPORT01,'B1_COD'    ,'SB1',RetTitle("B1_COD")  ,PesqPict("SB1","B1_COD")  ,TamSX3("B1_COD")[1]  ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT01,'B1_DESC'   ,'SB1',RetTitle("B1_DESC") ,PesqPict("SB1","B1_DESC") ,TamSX3("B1_DESC")[1] ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT01,'B2_QATU'   ,'SB2',RetTitle("B2_QATU") ,PesqPict("SB2","B2_QATU") ,TamSX3("B2_QATU")[1] ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT01,'DISPON'    ,'SB2',"Disponivel"        ,PesqPict("SB2","B2_QATU") ,TamSX3("B2_QATU")[1] ,/*lPixel*/,/*codeblock*/,,,,,,,,)

//Seção 2 - Filtro por Pedido de Vendas e por Produto
oTREPORT02:= TRSection():New(oTREPORT01,'Pedido de Vendas',{"SC6","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/,,,,,,,,,,,,,,,)
TRCell():New(oTREPORT02,'C6_ITEM'    ,'SC6'     ,/*RetTitle("C6_ITEM")*/   ,PesqPict("SC6","C6_ITEM")    ,TamSX3("C6_ITEM")[1]    ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT02,'C6_NUM'     ,'SC6'     ,RetTitle("C6_NUM")    ,PesqPict("SC6","C6_NUM")     ,TamSX3("C6_NUM")[1]     ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT02,'A1_NOME'    ,'SA1'     ,RetTitle("A1_NOME")   ,PesqPict("SA1","A1_NOME")    ,TamSX3("A1_NOME")[1]    ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT02,'C6_QTDVEN'  ,'SC6'     ,RetTitle("C6_QTDVEN") ,PesqPict("SC6","C6_QTDVEN")  ,TamSX3("C6_QTDVEN")[1]  ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT02,'C6_QTDENT'  ,'SC6'     ,RetTitle("C6_QTDENT") ,PesqPict("SC6","C6_QTDENT")  ,TamSX3("C6_QTDENT")[1]  ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT02,'C6_QTDRESE' ,'SC6'     ,RetTitle("C6_QTDRESE"),PesqPict("SC6","C6_QTDRESE") ,TamSX3("C6_QTDRESE")[1] ,/*lPixel*/,/*codeblock*/,,,,,,,,)

//Seção 3 - Filtro por Pedido de Compras e por Produto
oTREPORT03:= TRSection():New(oTREPORT01,'Pedido de Vendas',{"ZP1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/,,,,,,,,,,,,,,,)
TRCell():New(oTREPORT03,'ZP1_ITEMPV' ,'ZP1'     ,RetTitle("ZP1_ITEMPV"),PesqPict("ZP1","ZP1_ITEMPV") ,TamSX3("ZP1_ITEMPV")[1] ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT03,'ZP1_NUMPV'  ,'ZP1'     ,RetTitle("ZP1_NUMPV") ,PesqPict("ZP1","ZP1_NUMPV")  ,TamSX3("ZP1_NUMPV")[1]  ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT03,'ZP1_ITEMPC' ,'ZP1'     ,RetTitle("ZP1_ITEMPC"),PesqPict("ZP1","ZP1_ITEMPC") ,TamSX3("ZP1_ITEMPC")[1] ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT03,'ZP1_NUMPC'  ,'ZP1'     ,RetTitle("ZP1_NUMPC") ,PesqPict("ZP1","ZP1_NUMPC")  ,TamSX3("ZP1_NUMPC")[1]  ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT03,'ZP1_QTDE'   ,'ZP1'     ,RetTitle("ZP1_QTDE")  ,PesqPict("ZP1","ZP1_QTDE")   ,TamSX3("ZP1_QTDE")[1]   ,/*lPixel*/,/*codeblock*/,,,,,,,,)
TRCell():New(oTREPORT03,'ZP1_DENTPC' ,'ZP1'     ,RetTitle("ZP1_DENTPC"),PesqPict("ZP1","ZP1_DENTPC") ,TamSX3("ZP1_DENTPC")[1] ,/*lPixel*/,/*codeblock*/,,,,,,,,)

Return(oReport)

/*
******************************************************************
Impressao
******************************************************************
*/

Static Function PrintReport(oReport)

Local oQuebra:= oReport:Section(1)

Pergunte(cPerg,.F.)

//******************************************************************
//Query Secao 1
cAliasSB1 := "QRYSB1"
oReport:Section(1):BeginQuery()
BeginSql Alias cAliasSB1
    SELECT SB2.B2_QATU-SB2.B2_QEMP-SB2.B2_RESERVA AS DISPON, *
    FROM %Table:SB1% SB1
    	JOIN %Table:SB2% SB2 ON SB2.%notdel% AND SB2.B2_COD = SB1.B1_COD AND SB2.B2_LOCAL = 'G1'
    WHERE B1_FILIAL = %xFilial:SB1%
       AND SB1.%notdel%
       AND SB1.B1_COD BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
     ORDER BY SB1.B1_COD
EndSql
oReport:Section(1):EndQuery()

//******************************************************************
//Query Secao 2
cAliasSC6 := "QRYSC6"
oReport:Section(1):Section(1):BeginQuery()
BeginSql Alias cAliasSC6
    SELECT *
    FROM %Table:SC6% SC6
    	JOIN %Table:SA1% SA1 ON SA1.%notdel% AND SA1.A1_COD = SC6.C6_CLI
    WHERE C6_FILIAL = %xFilial:SC6%
       AND SC6.%notdel%
       AND SC6.C6_PRODUTO BETWEEN  %Exp:mv_par01% AND %Exp:mv_par02%
       AND SC6.C6_BLQ = ''
       AND SC6.C6_QTDVEN > SC6.C6_QTDENT
     ORDER BY SC6.C6_NUM
EndSql
oReport:Section(1):Section(1):EndQuery()
oReport:Section(1):Section(1):SetParentFilter( { |cParam| QRYSC6->C6_PRODUTO == cParam },{ || QRYSB1->B1_COD })

//******************************************************************
//Query Secao 3
cAliasZP1 := "QRYZP1"
oReport:Section(1):Section(2):BeginQuery()
BeginSql Alias cAliasZP1
	SELECT SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_NUM, 
	ZP1.ZP1_ITEMPV,ZP1.ZP1_NUMPV, ZP1.ZP1_ITEMPC, ZP1.ZP1_NUMPC, ZP1.ZP1_QTDE, ZP1.ZP1_DENTPC
	FROM %Table:SC6% SC6
		JOIN %Table:SA1% SA1 ON SA1.%notdel% AND SA1.A1_COD = SC6.C6_CLI
		JOIN %Table:ZP1% ZP1 ON ZP1.%notdel% AND ZP1.ZP1_NUMPV = SC6.C6_NUM AND ZP1.ZP1_ITEMPV = SC6.C6_ITEM AND ZP1.ZP1_FLAGEF = 'T'
		AND ZP1.ZP1_NUMPC <> ''
	WHERE C6_FILIAL = %xFilial:SC6%
		AND SC6.%notdel% 
		AND SC6.C6_PRODUTO BETWEEN  %Exp:mv_par01% AND %Exp:mv_par02%
		AND SC6.C6_BLQ = ''
	ORDER BY SC6.C6_NUM, SC6.C6_ITEM
EndSql
oReport:Section(1):Section(2):EndQuery()
oReport:Section(1):Section(2):SetParentFilter( { |cParam| QRYZP1->C6_PRODUTO == cParam },{ || QRYSB1->B1_COD })

oBreak := TRBreak():New(oQuebra,{|| QRYSB1->B1_COD},/*Titulo da quebra*/,/*totalizadores serão impressos em linha*/,/*Nome e identificador da quebra/,/*Se verdadeiro, aponta salto de página após a quebra*/)
oBreak:SetPageBreak(.T.)

oReport:Section(1):Init()
oReport:Section(1):Section(1):Init()
oReport:Section(1):Section(2):Init()


oReport:Section(1):Print()
oReport:Section(1):Section(1):Print()
oReport:Section(1):Section(2):Print()

Return(oReport)

/*
******************************************************************
Parametros do Relatorio
******************************************************************
*/
Static Function fCriaSX1()

Local nX, nY
aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Padr(cPerg,10)

/*
             grupo ,ordem,pergunt        ,perg spa       ,perg eng        , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01    ,defspa01 ,defeng01 ,cnt01,var02,def02      ,defspa02  ,defeng02  ,cnt02,var03,def03        ,defspa03     ,defeng03     ,cnt03 ,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3  ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Produto De" ,"Produto De" ,"Produto De"  ,"mv_ch1","C" ,15 ,00 ,0  ,"G" ,""   ,"mv_par01",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""     ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1","","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Produto Ate","Produto Ate","Produto Ate" ,"mv_ch2","C" ,15 ,00 ,0  ,"G" ,""   ,"mv_par02",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""     ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1","","","",""  })

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return
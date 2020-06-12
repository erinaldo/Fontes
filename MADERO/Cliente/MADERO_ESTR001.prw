#include "totvs.ch"
#include "rwmake.ch"
#include "topconn.ch"
/*
+----------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatório                                               !
+------------------+---------------------------------------------------------+
!Módulo            ! Estoque / Custos                                        !
+------------------+---------------------------------------------------------+
!Nome              ! ESTR001                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Relatório de Inventario (MATR285) - customizado         !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Andrade                                		     !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 22/10/2018                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACÕES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descrição detalhada da atualização      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
! ALTERAR FUNCAO PARA PEGAR SALDO NA DATA DO INVENTARIO - CALCEST() !        !
+-------------------------------------------+-----------+-----------+--------+
*/

User Function ESTR001()

Local oReport
Private cPerg := PadR("ESTR001",10)
Pergunte(cPerg,.F.)

CriaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSessao

oReport := TReport():New("ESTR001", "Relatório de Itens Inventariados", cPerg, {|oReport| ReportPrint(oReport)}, "Relatório de Itens Inventariados")
oReport:SetLandScape(.T.)
oSessao := TRSection():New(oReport, "Relatório de Itens Inventariados" )

// Colunas padrão


TRCell():New( oSessao, "B7_DATA" 	, "", "Dt.Invent." 	, PesqPict("SB7","B7_DATA"), TamSx3("B7_DATA")[1])
TRCell():New( oSessao, "B7_COD" 	, "", "Produto" 	, "", 15)
TRCell():New( oSessao, "B1_DESC" 	, "", "Descrição" 	, "", 40)
TRCell():New( oSessao, "B1_GRUPO" 	, "", "Tp.Grupo"    , "", 04)
TRCell():New( oSessao, "B1_UM" 		, "", "UM" 			, "", 02)
TRCell():New( oSessao, "B7_LOCAL" 	, "", "AMZ" 		, "", 02)
TRCell():New( oSessao, "B7_DOC" 	, "", "Documento" 	, "", 09)
TRCell():New( oSessao, "B7_QUANT" 	, "", "Saldo"   	, PesqPict("SB7","B7_QUANT"), TamSx3("B7_QUANT")[1])
TRCell():New( oSessao, "nQtdAnt" 	, "", "Qtd.Anterior", PesqPict("SB7","B7_QUANT"), TamSx3("B7_QUANT")[1])
TRCell():New( oSessao, "DIFQUANT" 	, "", "Diferença"	, PesqPict("SB7","B7_QUANT"), TamSx3("B7_QUANT")[1])
TRCell():New( oSessao, "nVlrUnit" 	, "", "Vlr.Unitario", PesqPict("SB2","B2_CM1"), TamSx3("B2_CM1")[1])
TRCell():New( oSessao, "nVlrTotal"  , "", "Vlr.Total" 	, PesqPict("SB7","B7_QUANT"), TamSx3("B7_QUANT")[1])
TRCell():New( oSessao, "STATUS"     , "", "Status" 		, "", 15)

//	Totalizacao
// Somatórios de quantidade, volume
oBreak := TRBreak():New(oSessao,oSessao:Cell("B7_DATA"),"SubTotal por Data")
TRFunction():New(oSessao:Cell("B7_QUANT"),"B7_QUANT","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(oSessao:Cell("nVlrUnit"),"nVlrUnit","ONPRINT",oBreak,,,,.F.,.F.)
//TRFunction():New(oSessao:Cell("nVlrTotal"),,"ONPRINT",oBreak,,,{ || oSessao:GetFunction("B7_QUANT"):GetLastValue() * oSessao:GetFunction("nVlrUnit"):GetLastValue()},.F.,.F.)

oReport:HideParamPage()

Return (oReport)

Static Function ReportPrint(oReport)

Local oBreak
Local oSessao 	:= oReport:Section(1)
Local cWhere	:= '%%'
Local nCont		:= 0
Local nSaldoB7 := 0
Local nVlrUni := 0
Local nQtdAnt 	:= 0
Local nQtdRE1 := 0
Local nQtdDE0 := 0  
Local nDifQdt := 0
Local aRetorno :={}
Local cAl 		:= GetNextAlias()

// Seleciona todas as ordens de carregamento e seus tickets associados de acordo com os parâmetros informados
oSessao:BeginQuery()

BeginSQL alias cAl
	
	SELECT 	SB7.B7_DATA,SB7.B7_COD, SB1.B1_DESC,SB1.B1_GRUPO,SB1.B1_UM,SB7.B7_LOCAL,SB7.B7_QUANT,SD3.D3_DOC,SD3.D3_QUANT,SD3.D3_CUSTO1,
	(SD3.D3_CUSTO1 / SD3.D3_QUANT) AS VLRUNIT,
	(SB7.B7_QUANT-SD3.D3_QUANT)  AS NQTDANT,
	SB7.B7_STATUS
	FROM %table:SB7% SB7
	INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xFilial:SB1%
	AND SB1.B1_COD = SB7.B7_COD
	AND SB1.B1_COD BETWEEN %Exp:MV_PAR01%	AND %Exp:MV_PAR02%
	AND SB1.B1_TIPO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND SB1.B1_GRUPO BETWEEN %Exp:MV_PAR07%	AND %Exp:MV_PAR08%
	AND SB1.%NotDel%
	LEFT OUTER JOIN %table:SD3% SD3 ON SD3.D3_FILIAL = %xFilial:SD3%
	AND SD3.D3_COD = SB7.B7_COD
	AND SD3.D3_DOC = 'INVENT'
	AND SD3.D3_EMISSAO = SB7.B7_DATA
	AND SD3.%NotDel%
	WHERE
	SB7.B7_FILIAL =  %xFilial:SB7%
	AND SB7.B7_LOCAL BETWEEN %Exp:MV_PAR05%	AND %Exp:MV_PAR06%
	AND SB7.B7_DATA BETWEEN %Exp:DTOS(MV_PAR09)%	AND %Exp:DTOS(MV_PAR10)%
	AND SB7.%NotDel%
	GROUP BY SB7.B7_DATA,SB7.B7_COD, SB1.B1_DESC,SB1.B1_GRUPO,SB1.B1_UM,SB7.B7_LOCAL,B7_QUANT,SD3.D3_DOC,SD3.D3_QUANT,SD3.D3_CUSTO1, SB7.B7_STATUS
	ORDER BY SB7.B7_DATA,SB7.B7_COD
	//AND %Exp:cWhere%
	
EndSQL
//Memowrite("c:\temp\ESTR001.TXT",getLastQuery()[2])
oSessao:EndQuery()

DbSelectArea(cAl)

(cAl)->(DbGoTop())

ProcRegua(Reccount())

oReport:SetMeter((cAl)->(RecCount()))

oSessao:Init()
Do While (!(cAl)->(Eof()))
	
	If oReport:Cancel()
		Exit
	EndIf
	
	If Empty((cAl)->NQTDANT)
		nQtdAnt := Posicione("SB9", 01, xFilial("SB9") + (cAl)->B7_COD + (cAl)->B7_LOCAL, "B9_QINI")  //saldo inicial
		//calculo total gasto até data D3_CF=RE1
		nQtdRE1 := CalcGSD3((cAl)->B7_COD,(cAl)->B7_DATA,"RE1")
		//calculo total credito até data D3_CF=DE0
		nQtdDE0 :=CalcGSD3((cAl)->B7_COD,(cAl)->B7_DATA,"DE0")
		nQtdAnt :=nQtdAnt - nQtdRE1
		nQtdAnt :=nQtdAnt + nQtdDE0    
		nDifQdt := (cAl)->B7_QUANT-nQtdAnt
	Else
		nQtdAnt := (cAl)->NQTDANT 
		nDifQdt := (cAl)->D3_QUANT
	EndIf
	
	oSessao:Cell("B7_DATA"):SetValue(DTOC((cAl)->B7_DATA))
	oSessao:Cell("B7_COD"):SetValue((cAl)->B7_COD)
	oSessao:Cell("B1_DESC"):SetValue((cAl)->B1_DESC)
	oSessao:Cell("B1_GRUPO"):SetValue((cAl)->B1_GRUPO)
	oSessao:Cell("B1_UM"):SetValue((cAl)->B1_UM)
	oSessao:Cell("B7_LOCAL"):SetValue((cAl)->B7_LOCAL)
	oSessao:Cell("B7_DOC"):SetValue((cAl)->D3_DOC)
	oSessao:Cell("B7_QUANT"):SetValue((cAl)->B7_QUANT )
	oSessao:Cell("nQtdAnt"):SetValue(nQtdAnt)
	oSessao:Cell("DIFQUANT"):SetValue(nDifQdt)
	oSessao:Cell("nVlrUnit"):SetValue((cAl)->VLRUNIT)
	oSessao:Cell("nVlrTotal"):SetValue((cAl)->D3_CUSTO1)
	oSessao:Cell("STATUS"):SetValue(Iif((cAl)->B7_STATUS=="1","Não processado", "Processado"))
	
	oSessao:PrintLine()
	(cAl)->(dbSkip())
Enddo

oSessao:Finish()

Return
//---------------------------------------------------------------------
/*/{Protheus.doc} CriaSX1
Função para criação das perguntas na SX1

@author Jair  Matos
@since 30/10/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
Static Function CriaSX1(cPerg)
cValid   := ""
cF3      := ""
cPicture := ""
cDef01   := ""
cDef02   := ""
cDef03   := ""
cDef04   := ""
cDef05   := ""

U_XPutSX1(cPerg, "01", "Produto De?"	,"MV_PAR01", "MV_CH1", "C", 15,	0, "G", cValid,     "SB1",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o produto inicial")
U_XPutSX1(cPerg, "02", "Produto Até?"	,"MV_PAR02", "MV_CH2", "C", 15, 0, "G", cValid,     "SB1",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o produto final")
U_XPutSX1(cPerg, "03", "Do Tipo?"	    ,"MV_PAR03", "MV_CH3", "C", 02, 0, "G", cValid,      "02",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o tipo inicial a ser considerado")
U_XPutSX1(cPerg, "04", "Até Tipo?" 		,"MV_PAR04", "MV_CH4", "C", 02, 0, "G", cValid,      "02",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o tipo final a ser considerado")
U_XPutSX1(cPerg, "05", "Armazem De?"	,"MV_PAR05", "MV_CH5", "C", 02,	0, "G", cValid,       cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o armazem inicial")
U_XPutSX1(cPerg, "06", "Armazem Até?"	,"MV_PAR06", "MV_CH6", "C", 02, 0, "G", cValid,       cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o armazem final")
U_XPutSX1(cPerg, "07", "Grupo De?"		,"MV_PAR07", "MV_CH7", "C", 04, 0, "G", cValid,     "SBM",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o grupo inicial")
U_XPutSX1(cPerg, "08", "Grupo Até?"		,"MV_PAR08", "MV_CH8", "C", 04, 0, "G", cValid,     "SBM",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o grupo final")
U_XPutSX1(cPerg, "09", "Data De?"		,"MV_PAR09", "MV_CH9", "D", 08,	0, "G", cValid,     cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a Data inicial")
U_XPutSX1(cPerg, "10", "Data Até?"		,"MV_PAR10", "MV_CH10", "D", 08, 0, "G", cValid,     cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a Data final")

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} AndEstOC
Calculos gastos sd3

@author Jair  Matos
@since 20/06/2018
@version P11
@return Nil
/*/
//---------------------------------------------------------------------
Static Function CalcGSD3(cCodigo,dEmis,cTipo)
Local cQuery
Local lRet := .T.
Local cQuant := 0

If select("TRBSD3")<>0
	TRBSD3->(dbclosearea())
EndIf
cQuery := " SELECT SUM(D3_QUANT) AS NTOTAL "
cQuery += " FROM "+RetSQLName("SD3") + " SD3 "
cQuery += " WHERE D3_FILIAL  = '" +xFilial("SD3")+ "' "
cQuery += " AND D3_COD  = '" +cCodigo+ "' "
cQuery += " AND D3_EMISSAO  <= '" +dtos(dEmis)+ "' "
cQuery += " AND D3_CF  = '" +cTipo+ "' "
cQuery += " AND SD3.D_E_L_E_T_= ' ' "

TcQuery cQuery new Alias "TRBSD3"

DbSelectArea("TRBSD3")
TRBSD3->(DbGoTop())
If !TRBSD3->(Eof())
	cQuant := TRBSD3->NTOTAL
EndIf

Return cQuant

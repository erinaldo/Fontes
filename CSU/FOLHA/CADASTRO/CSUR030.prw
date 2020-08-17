#INCLUDE "protheus.ch"      
#Include "rwmake.ch"
#INCLUDE "REPORT.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSUR030  � Autor � Tania Bronzeri     � Data � 16/01/2009  ���
�������������������������������������������������������������������������͹��
���Descricao � Pre-Admissoes Nao Integradas.                              ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Pre-Admissoes                                   ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUR030()
Local	oReport   
Local	aArea 		:= GetArea()
Private	cString		:= "PA6"				// alias do arquivo principal (Base)
Private cPerg		:= "CSU30R"
Private aOrd    	:= {"Matricula", "Nome", "Centro de Custo + Matricula"}	
Private cTitulo		:= OemToAnsi("Pr�-Admiss�es N�o Integradas")
Private cAliasQry	:= ""

//������������������������������������������Ŀ
//� Ajusta SX1 para trabalhar com range.     �
//��������������������������������������������
AjustaCSU30RSx1()

//������������������������������������������Ŀ
//� Verifica as perguntas selecionadas       �
//��������������������������������������������
pergunte(cPerg,.F.) 

oReport := ReportDef()
oReport:PrintDialog()

RestArea( aArea )

Return


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � ReportDef  � Autor � Tania Bronzeri        � Data �16/01/2009���
���������������������������������������������������������������������������Ĵ��
���Descri�ao � Pre-Admissoes nao Integradas                                 ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � CSUR030                                                      ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � CSUR030 - Especifico - Rotina Pre-Admissao                   ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
Static Function ReportDef()
Local oReport 
Local oSection1 
Local cDesc1	:=	OemToAnsi("Pr�-Admiss�es N�o Integradas ") + ;
					OemToAnsi(" Ser� impresso de acordo com os parametros solicitados pelo usu�rio.")	

//������������������������������������������������������������������������Ŀ
//�Criacao dos componentes de impressao                                    �
//��������������������������������������������������������������������������
DEFINE REPORT oReport NAME "CSUR030" TITLE cTitulo PARAMETER cPerg ACTION {|oReport| CSU30Imp(oReport)} ;
		DESCRIPTION OemtoAnsi("Este programa emite a Rela��o das Pr�-Admiss�es ainda n�o Integradas.") TOTAL IN COLUMN	 

	DEFINE SECTION oSection1 OF oReport TITLE OemToAnsi("Pr�-Admiss�es") TABLES "PA6", "CTT", "SRJ" TOTAL IN COLUMN ORDERS aOrd

		DEFINE CELL NAME "PA6_FILIAL"	OF oSection1 ALIAS "PA6" TITLE "Fil."    SIZE 6
		DEFINE CELL NAME "PA6_MAT"		OF oSection1 ALIAS "PA6" TITLE "MATR."   SIZE 10
		DEFINE CELL NAME "PA6_NOME" 	OF oSection1 ALIAS "PA6"                 SIZE 30
		DEFINE CELL NAME "PA6_CC"		OF oSection1 ALIAS "PA6" TITLE "C.Custo" SIZE 10
		DEFINE CELL NAME "CTT_DESC01"	OF oSection1 ALIAS "CTT" TITLE ""		BLOCK {||(cAliasQry)->CTT_DESC01}
		DEFINE CELL NAME "PA6_CODFUN"	OF oSection1 ALIAS "PA6" TITLE "FUNCAO"  SIZE 10
		DEFINE CELL NAME "RJ_DESC"		OF oSection1 ALIAS "SRJ" TITLE "" 	BLOCK {||(cAliasQry)->RJ_DESC}
		DEFINE CELL NAME "PA6_ITEMD"	OF oSection1 ALIAS "PA6" TITLE "Un.Neg." SIZE 10
		DEFINE CELL NAME "PA6_CLVLDB"	OF oSection1 ALIAS "PA6"                 SIZE 18
		DEFINE CELL NAME "PA6_CPF"		OF oSection1 ALIAS "PA6"                 SIZE 30
		DEFINE CELL NAME "PA6_ADMISS"	OF oSection1 ALIAS "PA6"                 SIZE 20
		DEFINE CELL NAME "PA6_INTEGR"	OF oSection1 ALIAS "PA6"
		DEFINE CELL NAME "PA6_DESIST"	OF oSection1 ALIAS "PA6"
		DEFINE CELL NAME "PA6_MOTIVO"	OF oSection1 ALIAS "PA6"
	
Return(oReport)


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � CSU30Imp   � Autor � Tania Bronzeri        � Data �16/01/2009���
���������������������������������������������������������������������������Ĵ��
���Descri�ao � Impressao do Relatorio Pre-Admissoes nao Integradas          ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � CSU30Imp                                                     ���
���������������������������������������������������������������������������Ĵ��
���Parametros� oReport                                                      ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � CSUR030 - Especifico - Rotina Pre-Admissao                   ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
Static Function CSU30Imp(oReport)
Local aArea		:= GetArea()
Local oSection  := oReport:Section(1)
Local cFiltro 	:= "" 

Private nOrdem	:= oSection:GetOrder()

//--MUDAR ANO PARA 4 DIGITOS
SET CENTURY ON

If oReport:Cancel()
	If nTdata > 8
		SET CENTURY ON
	Else
		SET CENTURY OFF
	Endif
	Return
EndIf               

cAliasQry := GetNextAlias()

//Transforma parametros do tipo Range em expressao SQL para ser utilizada no filtro
MakeSqlExpr(cPerg)
	
BEGIN REPORT QUERY oSection

If nOrdem == 1
	cOrdem := "%PA6.PA6_FILIAL,PA6.PA6_MAT%"
ElseIf nOrdem == 2
	cOrdem := "%PA6.PA6_FILIAL,PA6.PA6_NOME%"
ElseIf nOrdem == 3
	cOrdem := "%PA6.PA6_FILIAL,PA6.PA6_CC,PA6.PA6_CODFUNC%"
Endif

BeginSql alias cAliasQry
	Column PA6_ADMISS as Date

	SELECT	PA6.PA6_FILIAL, PA6.PA6_MAT,    PA6.PA6_NOME,   PA6.PA6_CC,     PA6.PA6_CODFUN, PA6.PA6_ITEMD,  PA6.PA6_CLVLDB, 
			PA6.PA6_CPF,    PA6.PA6_ADMISS, PA6.PA6_INTEGR, PA6.PA6_DESIST, PA6.PA6_MOTIVO, CTT.CTT_CUSTO,  CTT.CTT_DESC01, 
			SRJ.RJ_FUNCAO,  SRJ.RJ_DESC
	FROM %table:PA6% PA6
	LEFT JOIN %table:CTT% CTT ON PA6.PA6_CC = CTT.CTT_CUSTO
	LEFT JOIN %table:SRJ% SRJ ON PA6.PA6_CODFUN = SRJ.RJ_FUNCAO
	WHERE 	PA6.PA6_INTEGR <> 'I' And
			PA6.%notDel% AND CTT.%notDel% AND SRJ.%notDel%   
	ORDER BY %exp:cOrdem%
EndSql
	
END REPORT QUERY oSection PARAM mv_par01, mv_par02, mv_par03, mv_par04

//-- Define o total da regua da tela de processamento do relatorio
oReport:SetMeter( 100 )  

oSection:Print()	 //Imprimir

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AjustaCSU30RSx1� Autor � Tania Bronzeri   � Data �16/01/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta SX1 para Trabalhar com Range                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Rotina Pre-Admissoes.                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AjustaCSU30RSx1()

Local aRegs		:= {}
Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cHelp		:= ""

aHelp := {	"Informe intervalo de filiais que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de sucursales que ",;
			"desea considerar para impresion del ",;
			"informe" }
aHelpI:= {	"Enter branch range to be considered ",;
			"to print report." }
cHelp := ".RHFILIAL."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo   Ordem Pergunta Portugues   Pergunta Espanhol    Pergunta Ingles  Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01 DefSPA1  DefEng1 Cnt01         Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp      �
���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg ,"01" ,"Filial ?"          ,"�Sucursal ?"       ,"Branch?"       ,"MV_CH1","C" ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR01",""    ,""      ,""    ,"PA6_FILIAL",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"XM0",""    ,"S"  ,""      ,""     ,""      ,cHelp})


aHelp := {	"Informe intervalo de Centros de Custo ",;
			"que deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de centros de costo ",;
			"que desea considerar para impresion ",;
			"del informe." }
aHelpI:= {	"Enter the cost center range to be ",;
			"considered for printing the report." }
cHelp := ".RHCCUSTO."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
�����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo   Ordem Pergunta Portugues  Pergunta Espanhol    Pergunta Ingles Variavel Tipo Tamanho  Decimal Presel  GSC   Valid   Var01      Def01 DefSPA1  DefEng1  Cnt01    Var02 Def02  DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05  Def05 DefSpa5 DefEng5 Cnt05 XF3   GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp     �
�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg ,"02" ,"Centro de Custo ?","�Centro de Costo ?","Cost Center?" ,"MV_CH2","C" ,99      ,0      ,0     ,"R"  ,""     ,"MV_PAR02",""    ,""      ,""    ,"PA6_CC",""   ,""   ,""      ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""  ,""   ,""     ,""     ,""   ,""    ,""   ,""    ,""     ,""   ,"CTT","004"  ,"S"  ,""      ,""      ,""     ,cHelp})


aHelp := {	"Informe intervalo de matriculas que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de matriculas que ",;
			"desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter registration range to be ",;
			"considered for printing the report." }
cHelp := ".RHMATRIC."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  Ordem Pergunta Portugues  Pergunta Espanhol   Pergunta Ingles    Variavel  Tipo  Tamanho Decimal Presel GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01     Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05  Def05  DefSpa5 DefEng5 Cnt05 XF3   GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp      �
����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg,"03" ,"Matricula ?"      ,"�Matricula ?"     ,"Registration?"   ,"MV_CH3" ,"C"  ,99     ,0     ,0     ,"R"  ,""     ,"MV_PAR03",""   ,""      ,""     ,"PA6_MAT",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""  ,""     ,""     ,""   ,""    ,""    ,""     ,""    ,""   ,"PA6",""    ,"S"  ,""      ,""      ,""     ,cHelp})


aHelp := {	"Informe intervalo de nomes que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de nombres ",;
			"que desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter range of names to be ",;
			"considered for printing the report." }
cHelp := ".CSU30R04."
/*
��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  Ordem Pergunta Portugues  Pergunta Espanhol  Pergunta Ingles  Variavel  Tipo Tamanho Decimal Presel GSC   Valid   Var01      Def01  DefSPA1  DefEng1  Cnt01      Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05  Def05 DefSpa5 DefEng5 Cnt05 XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp     �
����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg,"04" ,"Nome ?"           ,"�Nombre?"        ,"Name?"         ,"MV_CH4" ,"C" ,99    ,0      ,0     ,"R"  ,""     ,"MV_PAR04",""    ,""      ,""     ,"PA6_NOME",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""  ,""   ,""     ,""     ,""   ,""    ,""   ,""    ,""     ,""   ,"" ,""    ,"S"  ,""     ,""      ,""      ,cHelp})



ValidPerg(aRegs,cPerg,.T.)








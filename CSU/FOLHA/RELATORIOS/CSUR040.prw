#INCLUDE "protheus.ch"      
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSUR050  º Autor ³ Tania Bronzeri     º Data ³ 19/01/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Head Count.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Processo Head Count.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³            ³                ³                              º±±                 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSUR040()
Local aArea 		:= GetArea()
Local cAliasAtivo	:= ""
Local cAliasAdmit	:= ""
Local cAliasDemit	:= "" 
Local cAliasEmFer	:= ""
Local cAliasIniFe	:= ""
Local cAliasFimFe	:= ""
Local cAliasAfast	:= ""
Local cAliasIniAf	:= ""
Local cAliasFimAf	:= ""
Local cAliasEvent	:= ""
Local cAliasCateg	:= ""    
Local cAliasCtt		:= ""  
Local cAlsFiEvent	:= ""
Local cAlsEmAtivo	:= ""
Local cAlsEmEvent	:= ""       
Local cCCustoReal	:= ""
Local cCcDescReal	:= ""
Local cFilialReal	:= ""
Local nPos			:= 0
Local dDataReal		:= CtoD("  /  /  ")
Local aStru			:= {} 
Local aCpos			:= {}
Private aTam			:= TamSX3("CTT_DESC01")
Private aTam8			:= TamSx3("PA8_DESCR")
Private cPerg		:= "CSU50R"
Private cArqTemp	:= GetNextAlias() 
Private cArqEven	:= GetNextAlias()
Private cArqFiTp	:= GetNextAlias()
Private cArqFiEv	:= GetNextAlias()
Private cArqEmTp	:= GetNextAlias()
Private cArqEmEv	:= GetNextAlias()
Private cCcDe		:= ""
Private cCcAte		:= "" 
Private cNomeDir	:= ""   
Private cNomeArq	:= ""
Private nTipRel		:= 0
Private nDias		:= 0
Private dDataDe		:= CtoD("  /  /  ")
Private dDataAte	:= CtoD("  /  /  ")
Private aCtt		:= {}
Private aFil		:= {}
Private aCategoria	:= {} 
Private aInfo		:= {}
Private aTransf		:= {}

//--MUDAR ANO PARA 4 DIGITOS
SET CENTURY ON

AjustaCSU50RSx1()

Pergunte(cPerg,.T.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
nTipRel		:= mv_par01		//Tipo do Relatório: 1=Filial / 2=Empresa / 3=Ambos / 4=Nenhum
cCcDe		:= mv_par02		//Centro de Custo De  
cCcAte		:= mv_par03		//Centro de Custo Ate 
dDataDe		:= mv_par04		//Periodo Inicial do Relatorio
dDataAte	:= mv_par05		//Periodo Final do Relatorio
cNomeDir	:= Iif(!Empty(mv_par06), AllTrim(mv_par06), AllTrim(GetSrvProfString('ROOTPATH', '') + GetSrvProfString('STARTPATH', '')))
cNomeArq	:= Iif(!Empty(mv_par07), AllTrim(mv_par07), AllTrim("HC_CSU_" + DtoS(dDataBase)))
                         
aInfo	:= {}
fInfo(@aInfo,xFilial("SRA"))


CursorWait()
MsAguarde({||CSUQUERYS()},OemToAnsi("Efetuando as Consultas de Dados."))
CursorArrow()
                         

CursorWait()
MsAguarde({||CSURHCXM()},OemToAnsi("Gerando Relatório Head Count."))
CursorArrow()
                         
Aviso(OemToAnsi("Atenção!"), OemToAnsi("Relatório Head Count Gerado com Sucesso!"), { "OK" } ) 
                       


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTdata > 8
	SET CENTURY ON
Else
	SET CENTURY OFF
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Eliminando os arquivos temporarios.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cArqTemp)
(cArqTemp)->(dbCloseArea())
fErase(cArqTemp)

dbSelectArea(cArqEven)
(cArqEven)->(dbCloseArea())
fErase(cArqEven)

If nTipRel == 1 .Or. nTipRel == 3
	dbSelectArea(cArqFiTp)
	(cArqFiTp)->(dbCloseArea())
	fErase(cArqFiTp)
	
	dbSelectArea(cArqFiEv)
	(cArqFiEv)->(dbCloseArea())
	fErase(cArqFiEv)
EndIf

If nTipRel == 2 .Or. nTipRel == 3
	dbSelectArea(cArqEmTp)
	(cArqEmTp)->(dbCloseArea())
	fErase(cArqEmTp)
	
	dbSelectArea(cArqEmEv)
	(cArqEmEv)->(dbCloseArea())
	fErase(cArqEmEv)
EndIf

RestArea(aArea)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaCSU50RSx1³ Autor ³ Tania Bronzeri   ³ Data ³26/01/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta SX1                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Relatório Head-Count                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaCSU50RSx1()

Local aRegs		:= {}
Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cHelp		:= ""

aHelp := {	"Selecione o tipo do relatório: 1-Filial, ",;
			"2-Empresa, 3-Ambas, 4-Nenhum, onde: ",;
			"1-Filial = Gerará uma planilha adicional ",;
			"com o mesmo layout, mas com totalização ",;
			"da filial sem considerar o CC. ",;
			"2-Empresa = Gerará uma planilha adicional ",;
			"com o mesmo layout, mas com a totalização ",;
			"da empresa. ",;
			"3-Ambas = Gerará duas planilhas adicionais ",;
			"com o mesmo layout, mas com totalização da ",;
			"filial e da empresa sem considerar o CC. ",;
			"4-Nenhum = Só serão gerados os arquivos ",;
			"conforme escolha do CC. " }
aHelpE:= {	"Selecione o tipo do relatório: 1-Filial, ",;
			"2-Empresa, 3-Ambas, 4-Nenhum, onde: ",;
			"1-Filial = Gerará uma planilha adicional ",;
			"com o mesmo layout, mas com totalização ",;
			"da filial sem considerar o CC. ",;
			"2-Empresa = Gerará uma planilha adicional ",;
			"com o mesmo layout, mas com a totalização ",;
			"da empresa. ",;
			"3-Ambas = Gerará duas planilhas adicionais ",;
			"com o mesmo layout, mas com totalização da ",;
			"filial e da empresa sem considerar o CC. ",;
			"4-Nenhum = Só serão gerados os arquivos ",;
			"conforme escolha do CC. " }
aHelpI:= {	"Selecione o tipo do relatório: 1-Filial, ",;
			"2-Empresa, 3-Ambas, 4-Nenhum, onde: ",;
			"1-Filial = Gerará uma planilha adicional ",;
			"com o mesmo layout, mas com totalização ",;
			"da filial sem considerar o CC. ",;
			"2-Empresa = Gerará uma planilha adicional ",;
			"com o mesmo layout, mas com a totalização ",;
			"da empresa. ",;
			"3-Ambas = Gerará duas planilhas adicionais ",;
			"com o mesmo layout, mas com totalização da ",;
			"filial e da empresa sem considerar o CC. ",;
			"4-Nenhum = Só serão gerados os arquivos ",;
			"conforme escolha do CC. " }
cHelp := ".CSU50R01."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues   Pergunta Espanhol      Pergunta Ingles  Variavel Tipo Tamanho Decimal Presel GSC   Valid        Var01      Def01      DefSPA1    DefEng1     Cnt01 Var02  Def02       DefSpa2     DefEng2     Cnt02 Var03 Def03     DefSpa3   DefEng3   Cnt03 Var04 Def04     DefSpa4     DefEng4    Cnt04 Var05  Def05  DefSpa5 DefEng5 Cnt05 XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"CSU50R","01","Tipo do Relatório ?","¿Tipo do Relatório ?","Branch?"       ,"MV_CH1","N" ,01    ,0      ,4     ,"C"  ,"NaoVazio()","MV_PAR01","1-Filial","1-Filial","1-Filial",""   ,""    ,"2-Empresa","2-Empresa","2-Empresa",""  ,""   ,"3-Ambas","3-Ambas","3-Ambas",""   ,""  ,"4-Nenhum","4-Nenhum","4-Nenhum",""   ,""    ,""    ,""    ,""     ,""   ,"" ,""    ,""   ,aHelp   ,aHelpI  ,aHelpE ,cHelp})


aHelp := {	"Informe Centro de Custo Inicial ",;
			"Emissao do Relatorio. " } 
aHelpE:= {	"Informe Centro de Custo Inicial ",;
			"Emissao do Relatorio. " } 
aHelpI:= {	"Informe Centro de Custo Inicial ",;
			"Emissao do Relatorio. " } 
cHelp := ".CSU50R02."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo     Ordem Pergunta Portugues     Pergunta Espanhol       Pergunta Ingles      Variavel Tipo Tamanho  Decimal Presel GSC   Valid   Var01      Def01 DefSPA1  DefEng1  Cnt01 Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"CSU50R","02" ,"Centro de Custo De ?","¿De Centro de Costo ?","From Cost Center ?","MV_CH2","C" ,20     ,0      ,0     ,"G"  ,""     ,"MV_PAR02",""    ,""      ,""    ,""   ,""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"CTT","004"  ,""   ,aHelp   ,aHelpI ,aHelpE  ,cHelp})


aHelp := {	"Informe Centro de Custo Final ",;
			"Emissao do Relatorio. " } 
aHelpE:= {	"Informe Centro de Custo Final ",;
			"Emissao do Relatorio. " } 
aHelpI:= {	"Informe Centro de Custo Final ",;
			"Emissao do Relatorio. " } 
cHelp := ".CSU50R03."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo     Ordem Pergunta Portugues      Pergunta Espanhol      Pergunta Ingles    Variavel Tipo Tamanho  Decimal Presel GSC   Valid   Var01      Def01 DefSPA1  DefEng1 Cnt01 Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"CSU50R","03" ,"Centro de Custo Até ?","¿A Centro de Costo ?","To Cost Center ?","MV_CH3","C" ,20     ,0      ,0     ,"G"  ,""     ,"MV_PAR03",""   ,""      ,""    ,""   ,""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"CTT","004"  ,""   ,aHelp   ,aHelpI ,aHelpE  ,cHelp})


aHelp := {	"Informe Data Inicial para Emissao do ",;
			"Relatorio. O intervalo máximo aceito é ",;
			"de 35 dias." } 
aHelpE:= {	"Informe Data Inicial para Emissao do ",;
			"Relatorio. O intervalo máximo aceito é ",;
			"de 35 dias." } 
aHelpI:= {	"Informe Data Inicial para Emissao do ",;
			"Relatorio. O intervalo máximo aceito é ",;
			"de 35 dias." } 
cHelp := ".CSU50R04."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo     Ordem Pergunta Portugues Pergunta Espanhol Pergunta Ingles Variavel  Tipo Tamanho Decimal Presel GSC Valid Var01      Def01 DefSPA1 DefEng1 Cnt01             Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03 DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05 XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"CSU50R","04" ,"Data De ?"       ,"¿De Fecha ?"    ,"From Date  ?" ,"MV_CH4","D"  ,08     ,0     ,0     ,"G",""   ,"MV_PAR04",""   ,""     ,""     ,"  /  /  "     ,""  ,""   ,""     ,""     ,""   ,""   ,""  ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""  ,""   ,""     ,""     ,""   ,"",""    ,""   ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})


aHelp := {	"Informe Data Final para Emissao do ",;
			"Relatorio. O intervalo máximo aceito é ",;
			"de 35 dias."} 
aHelpE:= {	"Informe Data Final para Emissao do ",;
			"Relatorio. O intervalo máximo aceito é ",;
			"de 35 dias."} 
aHelpI:= {	"Informe Data Final para Emissao do ",;
			"Relatorio. O intervalo máximo aceito é ",;
			"de 35 dias."} 
cHelp := ".CSU50R05."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³            Grupo    Ordem Pergunta Portugues Pergunta Espanhol Pergunta Ingles Variavel  Tipo Tamanho Decimal Presel GSC Valid                             Var01      Def01 DefSPA1 DefEng1 Cnt01             Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03 DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05 XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"CSU50R","05" ,"Data Até ?"      ,"¿A Fecha ?"     ,"To Date  ?"   ,"MV_CH5","D"  ,08     ,0     ,0     ,"G","U_fDifData35(mv_par04,mv_par05)","MV_PAR05",""   ,""     ,""     ,"  /  /  "      ,""   ,""   ,""     ,""     ,""   ,""  ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""  ,""   ,""     ,""     ,""  ,"" ,""    ,""   ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})


aHelp := {	"Informe o diretório no qual deseja que ",;
			"seja gerado o relatório no formato '.XML'. ",;
			"Se deixado em branco, assumirá o diretório ",;
			"do RootPath + StartPath do arquivo de ",;
			"inicialização do Protheus ('.INI')." } 
aHelpE:= {	"Informe o diretório no qual deseja que ",;
			"seja gerado o relatório no formato '.XML'. ",;
			"Se deixado em branco, assumirá o diretório ",;
			"do RootPath + StartPath do arquivo de ",;
			"inicialização do Protheus ('.INI')." } 
aHelpI:= {	"Informe o diretório no qual deseja que ",;
			"seja gerado o relatório no formato '.XML'. ",;
			"Se deixado em branco, assumirá o diretório ",;
			"do RootPath + StartPath do arquivo de ",;
			"inicialização do Protheus ('.INI')." } 
cHelp := ".CSU50R06."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³            Grupo    Ordem Pergunta Portugues          Pergunta Espanhol        Pergunta Ingles         Variavel  Tipo Tamanho Decimal Presel GSC Valid          Var01      Def01 DefSPA1 DefEng1 Cnt01 Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03 DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05 XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"CSU50R","06" ,"Diretório para Gravação ?","¿Diretorio Gravacao  ?","Diretorio Gravacao  ?","MV_CH6","C"  ,30     ,0     ,0     ,"G","U_Csu50Dir()","MV_PAR06",""   ,""     ,""     ,""  ,""   ,""   ,""     ,""     ,""   ,""  ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""  ,""   ,""     ,""     ,""  ,"" ,""    ,""   ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})


aHelp := {	"Informe o nome do arquivo que deseja gerar, ",;
			"sem informar o path, nem a extensão. Caso ",;
			"esta informação seja deixada em branco, será ",;
			"assumido o nome 'HC_CSU' + Data do dia, no ",;
			"formato 'yyyymmdd'." } 
aHelpE:= {	"Informe o nome do arquivo que deseja gerar, ",;
			"sem informar o path, nem a extensão. Caso ",;
			"esta informação seja deixada em branco, será ",;
			"assumido o nome 'HC_CSU' + Data do dia, no ",;
			"formato 'yyyymmdd'." } 
aHelpI:= {	"Informe o nome do arquivo que deseja gerar, ",;
			"sem informar o path, nem a extensão. Caso ",;
			"esta informação seja deixada em branco, será ",;
			"assumido o nome 'HC_CSU' + Data do dia, no ",;
			"formato 'yyyymmdd'." } 
cHelp := ".CSU50R07."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³            Grupo    Ordem Pergunta Portugues        Pergunta Espanhol          Pergunta Ingles           Variavel  Tipo Tamanho Decimal Presel GSC Valid Var01      Def01 DefSPA1 DefEng1 Cnt01 Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03 DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05 XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"CSU50R","07" ,"Nome do Arquivo Excel ?","¿Nome do Arquivo Excel ?","Nome do Arquivo Excel ?","MV_CH7","C"  ,30     ,0     ,0     ,"G",""   ,"MV_PAR07",""   ,""     ,""     ,""  ,""   ,""   ,""     ,""     ,""   ,""  ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""  ,""   ,""     ,""     ,""  ,"" ,""    ,""   ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})


ValidPerg(aRegs,cPerg,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fDifData35    ³ Autor ³ Tania Bronzeri   ³ Data ³27/01/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consiste Intervalo de Datas para o Relatório.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Relatório Head-Count                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fDifData35(dDataIni,dDataFim)
Local aArea35	:= GetArea()
Local lRet		:= Iif((dDataFim - dDataIni) <= 35, .T., .F.)
 
RestArea(aArea35)

Return lRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Csu50Dir     ³ Autor ³ Tania Bronzeri   ³ Data ³07/02/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica o diretorio em que sera gravado o arquivo XLS.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Csu50Dir(cDirPesq)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Head Count                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Csu50Dir()
Local _mvRet  := Alltrim(ReadVar())
Local _cPath  := mv_par06

_oWnd := GetWndDefault()

_cPath:=cGetFile(OemToAnsi("Relatório Head Count"),OemToAnsi("Selecione Diretório"),0,,.F.,GETF_RETDIRECTORY) 

&_mvRet := Iif(!Empty(mv_par06),mv_par06,_cPath)

If _oWnd != Nil
	GetdRefresh()
EndIf

Return .T.   
                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CSURHCXM      ³ Autor ³ Tania Bronzeri   ³ Data ³02/02/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Relatorio Head Count em Planilha Excel.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Relatório Head-Count                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CSURHCXM()
Local aAreaXml	:= GetArea()
Local nI 		:= 0
Local nY		:= 0
Local nD		:= 0
Local nJ		:= 0
Local nTotDia	:= 0
Local cCcAnt	:= ""
Local cFiAnt	:= ""
Local cEvAnt	:= "" 
Local cQuery	:= "%" + cArqTemp + "%"
Local cAlsTmp	:= GetNextAlias()
Local dDatatu	:= CtoD("  /  /  ")
Local dDatant	:= CtoD("  /  /  ")
Local lSaltalin	:= .T.

AutoGrLog('<?xml version="1.0"?>')
AutoGrLog('<?mso-application progid="Excel.Sheet"?>')
AutoGrLog('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"')
AutoGrLog(' xmlns:o="urn:schemas-microsoft-com:office:office"')
AutoGrLog(' xmlns:x="urn:schemas-microsoft-com:office:excel"')
AutoGrLog(' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"')
AutoGrLog(' xmlns:html="http://www.w3.org/TR/REC-html40">')
AutoGrLog(' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">')
AutoGrLog('  <Author>TaniaBronzeri</Author>')
AutoGrLog('  <LastAuthor>TOTVS </LastAuthor>')
AutoGrLog('  <Created>2009-09-02T17:18:35Z</Created>')
AutoGrLog('  <LastSaved>2009-02-07T16:35:46Z</LastSaved>')
AutoGrLog('  <Company>CsuCardSystem S/A</Company>')
AutoGrLog('  <Version>11.9999</Version>')
AutoGrLog(' </DocumentProperties>')
AutoGrLog(' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">')
AutoGrLog('  <WindowHeight>8190</WindowHeight>')
AutoGrLog('  <WindowWidth>14955</WindowWidth>')
AutoGrLog('  <WindowTopX>-30</WindowTopX>')
AutoGrLog('  <WindowTopY>60</WindowTopY>')
AutoGrLog('  <TabRatio>166</TabRatio>')
AutoGrLog('  <DoNotCalculateBeforeSave/>')
AutoGrLog('  <ProtectStructure>False</ProtectStructure>')
AutoGrLog('  <ProtectWindows>False</ProtectWindows>')
AutoGrLog(' </ExcelWorkbook>')
AutoGrLog(' <Styles>')
AutoGrLog('  <Style ss:ID="Default" ss:Name="Normal">')
AutoGrLog('   <Alignment ss:Vertical="Bottom"/>')
AutoGrLog('   <Borders/>')
AutoGrLog('   <Font/>')
AutoGrLog('   <Interior/>')
AutoGrLog('   <NumberFormat/>')
AutoGrLog('   <Protection/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s23">')
AutoGrLog('   <Font x:Family="Swiss" ss:Bold="1"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s24">')
AutoGrLog('   <Interior/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s25">')
AutoGrLog('   <Font x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
AutoGrLog('   <Interior ss:Color="#333399" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s26">')
AutoGrLog('   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s27">')
AutoGrLog('   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
AutoGrLog('   <Font x:Family="Swiss" ss:Bold="1"/>')
AutoGrLog('   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
AutoGrLog('   <NumberFormat ss:Format="Short Date"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s28">')
AutoGrLog('   <Font x:Family="Swiss" ss:Bold="1"/>')
AutoGrLog('   <Interior/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s29">')
AutoGrLog('   <Borders>')
AutoGrLog('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('   </Borders>')
AutoGrLog('   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s30">')
AutoGrLog('   <Borders>')
AutoGrLog('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('   </Borders>')
AutoGrLog('   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s31">')
AutoGrLog('   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:Indent="2"/>')
AutoGrLog('   <Font x:Family="Swiss" ss:Bold="1"/>')
AutoGrLog('   <Interior/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s32">')
AutoGrLog('   <Borders>')
AutoGrLog('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('   </Borders>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s33">')
AutoGrLog('   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:Indent="4"/>')
AutoGrLog('   <Font x:Family="Swiss" ss:Bold="1"/>')
AutoGrLog('   <Interior/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s34">')
AutoGrLog('   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:Indent="6"/>')
AutoGrLog('   <Font x:Family="Swiss" ss:Bold="1"/>')
AutoGrLog('   <Interior/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s35">')
AutoGrLog('   <Borders>')
AutoGrLog('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('   </Borders>')
AutoGrLog('   <Interior ss:Color="#FF0000" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s36">')
AutoGrLog('   <Borders>')
AutoGrLog('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
AutoGrLog('   </Borders>')
AutoGrLog('   <Interior ss:Color="#FF0000" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s37">')
AutoGrLog('   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
AutoGrLog('   <Font x:Family="Swiss" ss:Bold="1"/>')
AutoGrLog('   <Interior/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s38">')
AutoGrLog('   <Font x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
AutoGrLog('   <Interior ss:Color="#000000" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s39">')
AutoGrLog('   <Borders>')
AutoGrLog('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"')
AutoGrLog('     ss:Color="#FFFFFF"/>')
AutoGrLog('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"')
AutoGrLog('     ss:Color="#FFFFFF"/>')
AutoGrLog('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"')
AutoGrLog('     ss:Color="#FFFFFF"/>')
AutoGrLog('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"')
AutoGrLog('     ss:Color="#FFFFFF"/>')
AutoGrLog('   </Borders>')
AutoGrLog('   <Font x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
AutoGrLog('   <Interior ss:Color="#000000" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s40">')
AutoGrLog('   <Font x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
AutoGrLog('   <Interior/>')
AutoGrLog('  </Style>')
AutoGrLog('  <Style ss:ID="s41">')
AutoGrLog('   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:Indent="2"/>')
AutoGrLog('   <Font x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
AutoGrLog('   <Interior ss:Color="#000000" ss:Pattern="Solid"/>')
AutoGrLog('  </Style>')
AutoGrLog(' </Styles>')

DbSelectArea(cArqEven)
	
For nY := 1 to Len(aCtt)

	cCcAnt	:= 	aCtt[nY]
	AutoGrLog(' <Worksheet ss:Name="' + AllTrim(Str(nY) + "-" + Left(AllTrim(aCtt[nY]),10)) + '">')
	AutoGrLog('  <Table x:FullColumns="1"')
	AutoGrLog('   x:FullRows="1" ss:StyleID="s24">')
	AutoGrLog('   <Column ss:AutoFitWidth="0" ss:Width="267.75"/>')
	AutoGrLog('   <Row>')
	AutoGrLog('    <Cell ss:StyleID="s23"><Data ss:Type="String">' + "Planilha de Controle " + AllTrim(aCtt[nY]) + " dia a dia" + '</Data></Cell>')
	AutoGrLog('   </Row>')
	
	AutoGrLog('   <Row ss:Index="3">')
	AutoGrLog('    <Cell ss:StyleID="s25"><Data ss:Type="String">' + "NOME_EMPRESA" + aInfo[3] + '</Data></Cell>')
	AutoGrLog('   </Row>')
	
	AutoGrLog('   <Row>')
	AutoGrLog('    <Cell ss:StyleID="s26"><Data ss:Type="String">' + AllTrim(MesExtenso(Month(dDataBase))) + '</Data></Cell>')
	For nI	:= 0 to nDias   
		AutoGrLog('    <Cell ss:StyleID="s27"><Data ss:Type="String">' + DtoC(dDataDe + nI) + '</Data></Cell>')
	Next nI
	AutoGrLog('  </Row>')
	
	//Head Count Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Headcount Total</Data></Cell>')    
	If Select(cAlsTmp) > 0
		dbSelectArea(cAlsTmp)
		dbCloseArea()
	endif
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(ATIVOS)TOTDIA, SUM(ADMITIDOS) ADMDIA, SUM(DEMITIDOS) DEMDIA, 
				SUM(TRANSSAI) SAIDIA, SUM(TRANSENT) ENTDIA
		From %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV
		Order By DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	nTotDia	:= (cAlsTmp)->TOTDIA
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
		nTotDia	+=	(cAlsTmp)->ADMDIA
		nTotDia	-=	(cAlsTmp)->DEMDIA		
		nTotDia	+=	(cAlsTmp)->ENTDIA
		nTotDia	-=	(cAlsTmp)->SAIDIA		
	EndDo
	AutoGrLog('  </Row>')
	
	//Head Count por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, Sum(ATIVOS)TOTDIA, SUM(ADMITIDOS) ADMDIA, SUM(DEMITIDOS) DEMDIA, 
				SUM(TRANSSAI) SAIDIA, SUM(TRANSENT) ENTDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
			nTotDia	+=	(cAlsTmp)->ENTDIA
			nTotDia	-=	(cAlsTmp)->SAIDIA		
		EndDo
		AutoGrLog('  </Row>')
	Next nI
		
	//Admitidos Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Admitidos</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(ADMITIDOS) ADMDIA
		From   %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Admitidos por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(ADMITIDOS) ADMDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
      
	//Demitidos Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Demitidos</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(DEMITIDOS) DEMDIA
		From   %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Demitidos por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(DEMITIDOS) DEMDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI


	//Estoque de Férias
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Estoque de Ferias</Data></Cell>')    
	If Select(cAlsTmp) > 0
		dbSelectArea(cAlsTmp)
		dbCloseArea()
	endif
	BeginSql alias cAlsTmp
		Select DATAMOV, Sum(EMFERIAS)TOTDIA, SUM(INIFERIAS) ADMDIA, SUM(FIMFERIAS) DEMDIA 
		From %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV
		Order By DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	nTotDia	:= (cAlsTmp)->TOTDIA
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
		nTotDia	+=	(cAlsTmp)->ADMDIA
		nTotDia	-=	(cAlsTmp)->DEMDIA		
	EndDo
	AutoGrLog('  </Row>')
	
	//Ferias por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, Sum(EMFERIAS)TOTDIA, SUM(INIFERIAS) ADMDIA, SUM(FIMFERIAS) DEMDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
		EndDo
		AutoGrLog('  </Row>')
	Next nI
		
	//Inicio de Ferias Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Inicio de Ferias</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(INIFERIAS) ADMDIA
		From   %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Inicio de Ferias por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(INIFERIAS) ADMDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
         
		
	//Retorno de Ferias Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Retorno de Ferias</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(FIMFERIAS) DEMDIA
		From   %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Retorno de Ferias por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(FIMFERIAS) DEMDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI

	//Estoque de Afastamentos
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Estoque de Afastamentos</Data></Cell>')    
	If Select(cAlsTmp) > 0
		dbSelectArea(cAlsTmp)
		dbCloseArea()
	endif
	BeginSql alias cAlsTmp
		Select DATAMOV, Sum(AFASTADOS)TOTDIA, SUM(INIAFAST) ADMDIA, SUM(FIMAFAST) DEMDIA 
		From %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV
		Order By DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	nTotDia	:= (cAlsTmp)->TOTDIA
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
		nTotDia	+=	(cAlsTmp)->ADMDIA
		nTotDia	-=	(cAlsTmp)->DEMDIA		
	EndDo
	AutoGrLog('  </Row>')
	
	//Afastamentos por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, Sum(AFASTADOS)TOTDIA, SUM(INIAFAST) ADMDIA, SUM(FIMAFAST) DEMDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
		EndDo
		AutoGrLog('  </Row>')
	Next nI
		
	//Inicio de Afastamento Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Inicio de Afastamento</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(INIAFAST) ADMDIA
		From   %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Inicio de Afastamento por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(INIAFAST) ADMDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
      
	//Retorno de Afastamento Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Retorno de Afastamento</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(FIMAFAST) DEMDIA
		From   %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Retorno de Afastamento por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(FIMAFAST) DEMDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
	
      
	//Transferidos para outro C.Custo Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Transferencia para Outro Centro de Custo</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(TRANSSAI) SAIDIA
		From   %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->SAIDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Transferidos para outro C.Custo por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(TRANSSAI) SAIDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->SAIDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
               
		
	//Transferidos de outro C.Custo Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Transferencia de Outro Centro de Custo</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(TRANSENT) ENTDIA
		From   %exp:cQuery%
		Where CCUSTO = %exp:cCcAnt%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ENTDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Transferidos de outro C.Custo por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(TRANSENT) ENTDIA
		From   %exp:cQuery% 
		Where CCUSTO = %exp:cCcAnt%
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ENTDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI


	//Eventos do Ponto
	DbSelectArea(cArqEven)
	If (cArqEven)->(DbSeek(cCcAnt))
		lSaltalin	:= .T.
		cEvAnt		:= (cArqEven)->EVENTO
		While (cArqEven)->(!EOF()) .And. (cArqEven)->CCUSTO == cCcAnt
			If lSaltalin
				AutoGrLog('     <Row>')
				AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">'+(cArqEven)->CODIGO+'-'+(cArqEven)->EVENTO+'</Data></Cell>')    
				lSaltalin	:= .F.
				nD			:= 0  
				nJ			:= 0
			EndIf
			For nI	:= 0 to nDias   
				dDatatu := dDataDe + nI
				If ((cArqEven)->DATAMOV == DtoS(dDatatu))
					AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(fConvHr((cArqEven)->CREDITOS+(cArqEven)->DEBITOS,"H")) + '</Data></Cell>')
					nD	+= 1 
					nJ	+= 1
				ElseIf (cArqEven)->DATAMOV > DtoS(dDatatu)
					If nD <= nI .Or. nJ == 0
						AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(0) + '</Data></Cell>')
						nJ	+= 1   
						nD	+= 1
					EndIf
				EndIf  
				dDatant	:= StoD((cArqEven)->DATAMOV)
			Next nI
			(cArqEven)->(DbSkip()) 
			If (cArqEven)->EVENTO <> cEvAnt .Or. (cArqEven)->CCUSTO <> cCcAnt
				If dDatant < dDatatu
					For nI	:= dDatant to (dDatatu-1)
						AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(0) + '</Data></Cell>')
						nJ	+= 1
					Next nI
				EndIf
				lSaltalin	:= .T.
				cEvAnt		:= (cArqEven)->EVENTO
			EndIf
			If lSaltalin
				AutoGrLog('  </Row>')
			EndIf
    	EndDo
    EndIf

	AutoGrLog('  </Table>')
	AutoGrLog('  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
	AutoGrLog('   <PageSetup>')
	AutoGrLog('    <Header x:Margin="0.49212598499999999"/>')
	AutoGrLog('    <Footer x:Margin="0.49212598499999999"/>')
	AutoGrLog('    <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"')
	AutoGrLog('     x:Right="0.78740157499999996" x:Top="0.984251969"/>')
	AutoGrLog('   </PageSetup>')
	AutoGrLog('   <Print>')
	AutoGrLog('    <ValidPrinterInfo/>')
	AutoGrLog('    <HorizontalResolution>600</HorizontalResolution>')
	AutoGrLog('    <VerticalResolution>600</VerticalResolution>')
	AutoGrLog('   </Print>')
	AutoGrLog('   <Selected/>')
	AutoGrLog('   <FreezePanes/>')
	AutoGrLog('   <FrozenNoSplit/>')
	AutoGrLog('   <SplitHorizontal>1</SplitHorizontal>')
	AutoGrLog('   <TopRowBottomPane>33</TopRowBottomPane>')
	AutoGrLog('   <ActivePane>2</ActivePane>')
	AutoGrLog('   <Panes>')
	AutoGrLog('    <Pane>')
	AutoGrLog('     <Number>3</Number>')
	AutoGrLog('     <ActiveRow>37</ActiveRow>')
	AutoGrLog('     <ActiveCol>32</ActiveCol>')
	AutoGrLog('    </Pane>')
	AutoGrLog('    <Pane>')
	AutoGrLog('     <Number>2</Number>')
	AutoGrLog('     <ActiveCol>6</ActiveCol>')
	AutoGrLog('    </Pane>')
	AutoGrLog('   </Panes>')
	AutoGrLog('   <ProtectObjects>False</ProtectObjects>')
	AutoGrLog('   <ProtectScenarios>False</ProtectScenarios>')
	AutoGrLog('  </WorksheetOptions>')
	AutoGrLog(' </Worksheet>')

Next nY	

If nTipRel == 1	 .Or. nTipRel == 3	//Imprime Filiais
	
	cQuery	:= "%" + cArqFiTp + "%"
	DbSelectArea(cArqFiEv)
		
	For nY := 1 to Len(aFil)
	
		cFiAnt	:= 	aFil[nY]
		AutoGrLog(' <Worksheet ss:Name="Filial ' + Left(AllTrim(aFil[nY]),2) + '">')
		AutoGrLog('  <Table x:FullColumns="1"')
		AutoGrLog('   x:FullRows="1" ss:StyleID="s24">')
		AutoGrLog('   <Column ss:AutoFitWidth="0" ss:Width="267.75"/>')
		AutoGrLog('   <Row>')
		AutoGrLog('    <Cell ss:StyleID="s23"><Data ss:Type="String">' + "Planilha de Controle Filial " + AllTrim(aFil[nY]) + " dia a dia" + '</Data></Cell>')
		AutoGrLog('   </Row>')
		
		AutoGrLog('   <Row ss:Index="3">')
		AutoGrLog('    <Cell ss:StyleID="s25"><Data ss:Type="String">' + "NOME_EMPRESA" + aInfo[3] + '</Data></Cell>')
		AutoGrLog('   </Row>')
		
		AutoGrLog('   <Row>')
		AutoGrLog('    <Cell ss:StyleID="s26"><Data ss:Type="String">' + AllTrim(MesExtenso(Month(dDataBase))) + '</Data></Cell>')
		For nI	:= 0 to nDias   
			AutoGrLog('    <Cell ss:StyleID="s27"><Data ss:Type="String">' + DtoC(dDataDe + nI) + '</Data></Cell>')
		Next nI
		AutoGrLog('  </Row>')
		
		//Head Count Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Headcount Total</Data></Cell>')    
		If Select(cAlsTmp) > 0
			dbSelectArea(cAlsTmp)
			dbCloseArea()
		endif
		BeginSql alias cAlsTmp
			Select DATAMOV, Sum(ATIVOS)TOTDIA, SUM(ADMITIDOS) ADMDIA, SUM(DEMITIDOS) DEMDIA, 
				SUM(TRANSSAI) SAIDIA, SUM(TRANSENT) ENTDIA 
			From %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV
			Order By DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
			nTotDia	+=	(cAlsTmp)->ENTDIA
			nTotDia	-=	(cAlsTmp)->SAIDIA		
		EndDo
		AutoGrLog('  </Row>')
		
		//Head Count por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, Sum(ATIVOS)TOTDIA, SUM(ADMITIDOS) ADMDIA, SUM(DEMITIDOS) DEMDIA, 
				SUM(TRANSSAI) SAIDIA, SUM(TRANSENT) ENTDIA 
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			nTotDia	:= (cAlsTmp)->TOTDIA
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
				nTotDia	+=	(cAlsTmp)->ADMDIA
				nTotDia	-=	(cAlsTmp)->DEMDIA		
				nTotDia	+=	(cAlsTmp)->ENTDIA
				nTotDia	-=	(cAlsTmp)->SAIDIA		
			EndDo
			AutoGrLog('  </Row>')
		Next nI
			
		//Admitidos Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Admitidos</Data></Cell>')    
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select DATAMOV, SUM(ADMITIDOS) ADMDIA
			From   %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV 
			Order By DATAMOV 
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
		
		//Admitidos por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, SUM(ADMITIDOS) ADMDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
			EndDo
			AutoGrLog('  </Row>')
		Next nI
	      
		//Demitidos Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Demitidos</Data></Cell>')    
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select DATAMOV, SUM(DEMITIDOS) DEMDIA
			From   %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV 
			Order By DATAMOV 
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
		
		//Demitidos por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, SUM(DEMITIDOS) DEMDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
			EndDo
			AutoGrLog('  </Row>')
		Next nI


		//Estoque de Férias
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Estoque de Ferias</Data></Cell>')    
		If Select(cAlsTmp) > 0
			dbSelectArea(cAlsTmp)
			dbCloseArea()
		endif
		BeginSql alias cAlsTmp
			Select DATAMOV, Sum(EMFERIAS)TOTDIA, SUM(INIFERIAS) ADMDIA, SUM(FIMFERIAS) DEMDIA 
			From %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV
			Order By DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
		EndDo
		AutoGrLog('  </Row>')
		
		//Ferias por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, Sum(EMFERIAS)TOTDIA, SUM(INIFERIAS) ADMDIA, SUM(FIMFERIAS) DEMDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			nTotDia	:= (cAlsTmp)->TOTDIA
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
				nTotDia	+=	(cAlsTmp)->ADMDIA
				nTotDia	-=	(cAlsTmp)->DEMDIA		
			EndDo
			AutoGrLog('  </Row>')
		Next nI
			
		//Inicio de Ferias Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Inicio de Ferias</Data></Cell>')    
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select DATAMOV, SUM(INIFERIAS) ADMDIA
			From   %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV 
			Order By DATAMOV 
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
		
		//Inicio de Ferias por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, SUM(INIFERIAS) ADMDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
			EndDo
			AutoGrLog('  </Row>')
		Next nI
	         
			
		//Retorno de Ferias Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Retorno de Ferias</Data></Cell>')    
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select DATAMOV, SUM(FIMFERIAS) DEMDIA
			From   %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV 
			Order By DATAMOV 
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
		
		//Retorno de Ferias por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, SUM(FIMFERIAS) DEMDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
			EndDo
			AutoGrLog('  </Row>')
		Next nI
	
	
		//Estoque de Afastamentos
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Estoque de Afastamentos</Data></Cell>')    
		If Select(cAlsTmp) > 0
			dbSelectArea(cAlsTmp)
			dbCloseArea()
		endif
		BeginSql alias cAlsTmp
			Select DATAMOV, Sum(AFASTADOS)TOTDIA, SUM(INIAFAST) ADMDIA, SUM(FIMAFAST) DEMDIA 
			From %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV
			Order By DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
		EndDo
		AutoGrLog('  </Row>')
		
		//Afastamentos por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, Sum(AFASTADOS)TOTDIA, SUM(INIAFAST) ADMDIA, SUM(FIMAFAST) DEMDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			nTotDia	:= (cAlsTmp)->TOTDIA
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
				nTotDia	+=	(cAlsTmp)->ADMDIA
				nTotDia	-=	(cAlsTmp)->DEMDIA		
			EndDo
			AutoGrLog('  </Row>')
		Next nI
			
		//Inicio de Afastamento Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Inicio de Afastamento</Data></Cell>')    
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select DATAMOV, SUM(INIAFAST) ADMDIA
			From   %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV 
			Order By DATAMOV 
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
		
		//Inicio de Afastamento por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, SUM(INIAFAST) ADMDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
			EndDo
			AutoGrLog('  </Row>')
		Next nI
	         
			
		//Retorno de Afastamento Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Retorno de Afastamento</Data></Cell>')    
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select DATAMOV, SUM(FIMAFAST) DEMDIA
			From   %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV 
			Order By DATAMOV 
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
		
		//Retorno de Afastamento por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, SUM(FIMAFAST) DEMDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
			EndDo
			AutoGrLog('  </Row>')
		Next nI    
		
	      
		//Transferidos para outra Filial Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Transferencia para Outro Centro de Custo</Data></Cell>')    
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select DATAMOV, SUM(TRANSSAI) SAIDIA
			From   %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV 
			Order By DATAMOV 
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->SAIDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
		
		//Transferidos para outra Filial por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, SUM(TRANSSAI) SAIDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->SAIDIA) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
			EndDo
			AutoGrLog('  </Row>')
		Next nI
	               
			
		//Transferidos de outra Filial Total
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Transferencia de Outro Centro de Custo</Data></Cell>')    
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select DATAMOV, SUM(TRANSENT) ENTDIA
			From   %exp:cQuery%
			Where FILIAL = %exp:cFiAnt%
			Group By DATAMOV 
			Order By DATAMOV 
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		While (cAlsTmp)->(!EOF())
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ENTDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
		
		//Transferidos de outra Filial por Categoria
		DbCloseArea(cAlsTmp)
		BeginSql alias cAlsTmp
			Select CATEGORIA, DATAMOV, SUM(TRANSENT) ENTDIA
			From   %exp:cQuery% 
			Where FILIAL = %exp:cFiAnt%
			Group By CATEGORIA, DATAMOV 
			Order By CATEGORIA, DATAMOV
		EndSql
		DbSelectArea(cAlsTmp)
		(cAlsTmp)->(DbGoTop())
		For nI := 1 to Len(aCategoria)
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
			While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
				AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ENTDIA) + '</Data></Cell>')
				(cAlsTmp)->(DbSkip())
			EndDo
			AutoGrLog('  </Row>')
		Next nI
			
		
		
		//Eventos do Ponto
		DbSelectArea(cArqFiEv)
		If (cArqFiEv)->(DbSeek(cFiAnt))
			lSaltalin	:= .T.
			cEvAnt		:= (cArqFiEv)->EVENTO
			While (cArqFiEv)->(!EOF()) .And. (cArqFiEv)->FILIAL == cFiAnt
				If lSaltalin
					AutoGrLog('     <Row>')
					AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">'+(cArqFiEv)->CODIGO+'-'+(cArqFiEv)->EVENTO+'</Data></Cell>')    
					lSaltalin	:= .F.
					nD			:= 0   
					nJ			:= 0
				EndIf
				For nI	:= 0 to nDias   
					dDatatu := dDataDe + nI
					If ((cArqFiEv)->DATAMOV == DtoS(dDatatu))
						AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(fConvHr((cArqFiEv)->CREDITOS+(cArqFiEv)->DEBITOS,"H")) + '</Data></Cell>')
						nD	+= 1  
						nJ	+= 1
					ElseIf (cArqFiEv)->DATAMOV > DtoS(dDatatu)
						If nD < nI .Or. nJ == 0
							AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(0) + '</Data></Cell>')
							nJ	+= 1
							nD	+= 1
						EndIf
					EndIf  
					dDatant	:= StoD((cArqFiEv)->DATAMOV)
				Next nI
				(cArqFiEv)->(DbSkip()) 
				If (cArqFiEv)->EVENTO <> cEvAnt .Or. (cArqFiEv)->FILIAL <> cFiAnt
					If dDatant < dDatatu
						For nI	:= dDatant to (dDatatu-1)
							AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(0) + '</Data></Cell>')
							nJ	+= 1
						Next nI
					EndIf
					lSaltalin	:= .T.
					cEvAnt		:= (cArqFiEv)->EVENTO
				EndIf
				If lSaltalin
					AutoGrLog('  </Row>')
				EndIf
	    	EndDo
	    EndIf
	
		AutoGrLog('  </Table>')
		AutoGrLog('  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
		AutoGrLog('   <PageSetup>')
		AutoGrLog('    <Header x:Margin="0.49212598499999999"/>')
		AutoGrLog('    <Footer x:Margin="0.49212598499999999"/>')
		AutoGrLog('    <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"')
		AutoGrLog('     x:Right="0.78740157499999996" x:Top="0.984251969"/>')
		AutoGrLog('   </PageSetup>')
		AutoGrLog('   <Print>')
		AutoGrLog('    <ValidPrinterInfo/>')
		AutoGrLog('    <HorizontalResolution>600</HorizontalResolution>')
		AutoGrLog('    <VerticalResolution>600</VerticalResolution>')
		AutoGrLog('   </Print>')
		AutoGrLog('   <Selected/>')
		AutoGrLog('   <FreezePanes/>')
		AutoGrLog('   <FrozenNoSplit/>')
		AutoGrLog('   <SplitHorizontal>1</SplitHorizontal>')
		AutoGrLog('   <TopRowBottomPane>33</TopRowBottomPane>')
		AutoGrLog('   <ActivePane>2</ActivePane>')
		AutoGrLog('   <Panes>')
		AutoGrLog('    <Pane>')
		AutoGrLog('     <Number>3</Number>')
		AutoGrLog('     <ActiveRow>37</ActiveRow>')
		AutoGrLog('     <ActiveCol>32</ActiveCol>')
		AutoGrLog('    </Pane>')
		AutoGrLog('    <Pane>')
		AutoGrLog('     <Number>2</Number>')
		AutoGrLog('     <ActiveCol>6</ActiveCol>')
		AutoGrLog('    </Pane>')
		AutoGrLog('   </Panes>')
		AutoGrLog('   <ProtectObjects>False</ProtectObjects>')
		AutoGrLog('   <ProtectScenarios>False</ProtectScenarios>')
		AutoGrLog('  </WorksheetOptions>')
		AutoGrLog(' </Worksheet>')
	
	Next nY	
EndIf

If nTipRel == 2	 .Or. nTipRel == 3	//Imprime Empresa
	
	cQuery	:= "%" + cArqEmTp + "%"
	DbSelectArea(cArqEmEv)
		
	AutoGrLog(' <Worksheet ss:Name="Empresa">')
	AutoGrLog('  <Table x:FullColumns="1"')
	AutoGrLog('   x:FullRows="1" ss:StyleID="s24">')
	AutoGrLog('   <Column ss:AutoFitWidth="0" ss:Width="267.75"/>')
	AutoGrLog('   <Row>')
	AutoGrLog('    <Cell ss:StyleID="s23"><Data ss:Type="String">' + "Planilha de Controle Empresa dia a dia" + '</Data></Cell>')
	AutoGrLog('   </Row>')
	
	AutoGrLog('   <Row ss:Index="3">')
	AutoGrLog('    <Cell ss:StyleID="s25"><Data ss:Type="String">' + "NOME_EMPRESA" + '</Data></Cell>')
	AutoGrLog('   </Row>')
	
	AutoGrLog('   <Row>')
	AutoGrLog('    <Cell ss:StyleID="s26"><Data ss:Type="String">' + AllTrim(MesExtenso(Month(dDataBase))) + '</Data></Cell>')
	For nI	:= 0 to nDias   
		AutoGrLog('    <Cell ss:StyleID="s27"><Data ss:Type="String">' + DtoC(dDataDe + nI) + '</Data></Cell>')
	Next nI
	AutoGrLog('  </Row>')
	
	//Head Count Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Headcount Total</Data></Cell>')    
	If Select(cAlsTmp) > 0
		dbSelectArea(cAlsTmp)
		dbCloseArea()
	endif
	BeginSql alias cAlsTmp
		Select DATAMOV, Sum(ATIVOS)TOTDIA, SUM(ADMITIDOS) ADMDIA, SUM(DEMITIDOS) DEMDIA
		From %exp:cQuery%
		Group By DATAMOV
		Order By DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	nTotDia	:= (cAlsTmp)->TOTDIA
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
		nTotDia	+=	(cAlsTmp)->ADMDIA
		nTotDia	-=	(cAlsTmp)->DEMDIA		
	EndDo
	AutoGrLog('  </Row>')
	
	//Head Count por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, Sum(ATIVOS)TOTDIA, SUM(ADMITIDOS) ADMDIA, SUM(DEMITIDOS) DEMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
		EndDo
		AutoGrLog('  </Row>')
	Next nI
		
	//Admitidos Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Admitidos</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(ADMITIDOS) ADMDIA
		From   %exp:cQuery%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Admitidos por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(ADMITIDOS) ADMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
      
	//Demitidos Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Demitidos</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(DEMITIDOS) DEMDIA
		From   %exp:cQuery%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Demitidos por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(DEMITIDOS) DEMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
                                               

	//Estoque de Férias
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Estoque de Ferias</Data></Cell>')    
	If Select(cAlsTmp) > 0
		dbSelectArea(cAlsTmp)
		dbCloseArea()
	endif
	BeginSql alias cAlsTmp
		Select DATAMOV, Sum(EMFERIAS)TOTDIA, SUM(INIFERIAS) ADMDIA, SUM(FIMFERIAS) DEMDIA 
		From %exp:cQuery%
		Group By DATAMOV
		Order By DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	nTotDia	:= (cAlsTmp)->TOTDIA
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
		nTotDia	+=	(cAlsTmp)->ADMDIA
		nTotDia	-=	(cAlsTmp)->DEMDIA		
	EndDo
	AutoGrLog('  </Row>')
	
	//Ferias por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, Sum(EMFERIAS)TOTDIA, SUM(INIFERIAS) ADMDIA, SUM(FIMFERIAS) DEMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
		EndDo
		AutoGrLog('  </Row>')
	Next nI
		
	//Inicio de Ferias Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Inicio de Ferias</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(INIFERIAS) ADMDIA
		From   %exp:cQuery%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Inicio de Ferias por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(INIFERIAS) ADMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
      
	//Retorno de Ferias Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Retorno de Ferias</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(FIMFERIAS) DEMDIA
		From   %exp:cQuery%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Retorno de Ferias por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(FIMFERIAS) DEMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI

	//Estoque de Afastamentos
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">Estoque de Afastamentos</Data></Cell>')    
	If Select(cAlsTmp) > 0
		dbSelectArea(cAlsTmp)
		dbCloseArea()
	endif
	BeginSql alias cAlsTmp
		Select DATAMOV, Sum(AFASTADOS)TOTDIA, SUM(INIAFAST) ADMDIA, SUM(FIMAFAST) DEMDIA 
		From %exp:cQuery%
		Group By DATAMOV
		Order By DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	nTotDia	:= (cAlsTmp)->TOTDIA
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
		nTotDia	+=	(cAlsTmp)->ADMDIA
		nTotDia	-=	(cAlsTmp)->DEMDIA		
	EndDo
	AutoGrLog('  </Row>')

	
	//Afastamentos por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, Sum(AFASTADOS)TOTDIA, SUM(INIAFAST) ADMDIA, SUM(FIMAFAST) DEMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		nTotDia	:= (cAlsTmp)->TOTDIA
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str(nTotDia) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
			nTotDia	+=	(cAlsTmp)->ADMDIA
			nTotDia	-=	(cAlsTmp)->DEMDIA		
		EndDo
		AutoGrLog('  </Row>')
	Next nI
		
	//Inicio de Afastamento Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Inicio de Afastamento</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(INIAFAST) ADMDIA
		From   %exp:cQuery%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Inicio de Afastamento por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(INIAFAST) ADMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->ADMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
      
	//Retorno de Afastamento Total
	AutoGrLog('     <Row>')
	AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">Retorno de Afastamento</Data></Cell>')    
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select DATAMOV, SUM(FIMAFAST) DEMDIA
		From   %exp:cQuery%
		Group By DATAMOV 
		Order By DATAMOV 
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	While (cAlsTmp)->(!EOF())
		AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
		(cAlsTmp)->(DbSkip())
	EndDo
	AutoGrLog('  </Row>')
	
	//Retorno de Afastamento por Categoria
	DbCloseArea(cAlsTmp)
	BeginSql alias cAlsTmp
		Select CATEGORIA, DATAMOV, SUM(FIMAFAST) DEMDIA
		From   %exp:cQuery% 
		Group By CATEGORIA, DATAMOV 
		Order By CATEGORIA, DATAMOV
	EndSql
	DbSelectArea(cAlsTmp)
	(cAlsTmp)->(DbGoTop())
	For nI := 1 to Len(aCategoria)
		AutoGrLog('     <Row>')
		AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">   ' + aCategoria[nI] + '</Data></Cell>')    
		While (cAlsTmp)->(!EOF()) .And. (cAlsTmp)->CATEGORIA == aCategoria[nI]
			AutoGrLog('      <Cell ss:StyleID="s29"><Data ss:Type="String">' + Str((cAlsTmp)->DEMDIA) + '</Data></Cell>')
			(cAlsTmp)->(DbSkip())
		EndDo
		AutoGrLog('  </Row>')
	Next nI
	
	//Eventos do Ponto
	DbSelectArea(cArqEmEv) 
	(cArqEmEv)->(DbGoTop())
	lSaltalin	:= .T.
	cEvAnt		:= (cArqEmEv)->EVENTO
	While (cArqEmEv)->(!EOF()) 
		If lSaltalin
			AutoGrLog('     <Row>')
			AutoGrLog('      <Cell ss:StyleID="s30"><Data ss:Type="String">'+(cArqEmEv)->CODIGO+'-'+(cArqEmEv)->EVENTO+'</Data></Cell>')    
			lSaltalin	:= .F.
			nD			:= 0 
			nJ			:= 0
		EndIf
		For nI	:= 0 to nDias   
			dDatatu := dDataDe + nI
			If ((cArqEmEv)->DATAMOV == DtoS(dDatatu))
				AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(fConvHr((cArqEmEv)->CREDITOS+(cArqEmEv)->DEBITOS,"H")) + '</Data></Cell>')
				nD	+= 1 
				nJ	+= 1
			ElseIf (cArqEmEv)->DATAMOV > DtoS(dDatatu)
				If nD < nI .Or. nJ == 0
					AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(0) + '</Data></Cell>')
					nJ	+= 1
					nD	+= 1
				EndIf
			EndIf  
			dDatant	:= StoD((cArqEmEv)->DATAMOV)
		Next nI
		(cArqEmEv)->(DbSkip()) 
		If (cArqEmEv)->EVENTO <> cEvAnt 
			If dDatant < dDatatu
				For nI	:= dDatant to (dDatatu-1)
					AutoGrLog('    <Cell ss:StyleID="s30"><Data ss:Type="String">' + Str(0) + '</Data></Cell>')
					nJ	+= 1
				Next nI
			EndIf
			lSaltalin	:= .T.
			cEvAnt		:= (cArqEmEv)->EVENTO
		EndIf
		If lSaltalin
			AutoGrLog('  </Row>')
		EndIf
   	EndDo

	AutoGrLog('  </Table>')
	AutoGrLog('  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
	AutoGrLog('   <PageSetup>')
	AutoGrLog('    <Header x:Margin="0.49212598499999999"/>')
	AutoGrLog('    <Footer x:Margin="0.49212598499999999"/>')
	AutoGrLog('    <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"')
	AutoGrLog('     x:Right="0.78740157499999996" x:Top="0.984251969"/>')
	AutoGrLog('   </PageSetup>')
	AutoGrLog('   <Print>')
	AutoGrLog('    <ValidPrinterInfo/>')
	AutoGrLog('    <HorizontalResolution>600</HorizontalResolution>')
	AutoGrLog('    <VerticalResolution>600</VerticalResolution>')
	AutoGrLog('   </Print>')
	AutoGrLog('   <Selected/>')
	AutoGrLog('   <FreezePanes/>')
	AutoGrLog('   <FrozenNoSplit/>')
	AutoGrLog('   <SplitHorizontal>1</SplitHorizontal>')
	AutoGrLog('   <TopRowBottomPane>33</TopRowBottomPane>')
	AutoGrLog('   <ActivePane>2</ActivePane>')
	AutoGrLog('   <Panes>')
	AutoGrLog('    <Pane>')
	AutoGrLog('     <Number>3</Number>')
	AutoGrLog('     <ActiveRow>37</ActiveRow>')
	AutoGrLog('     <ActiveCol>32</ActiveCol>')
	AutoGrLog('    </Pane>')
	AutoGrLog('    <Pane>')
	AutoGrLog('     <Number>2</Number>')
	AutoGrLog('     <ActiveCol>6</ActiveCol>')
	AutoGrLog('    </Pane>')
	AutoGrLog('   </Panes>')
	AutoGrLog('   <ProtectObjects>False</ProtectObjects>')
	AutoGrLog('   <ProtectScenarios>False</ProtectScenarios>')
	AutoGrLog('  </WorksheetOptions>')
	AutoGrLog(' </Worksheet>')

EndIf

AutoGrLog('</Workbook>')

                       
__Copyfile(NomeAutoLog(),cNomeDir+cNomeArq+".xls")
Winexec("Excel " + cNomeDir + cNomeArq + ".xls")

RestArea(aAreaXml)

Return Nil
       
                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CSUQUERYS     ³ Autor ³ Tania Bronzeri   ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Querys e tabelas temporárias.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Relatório Head-Count                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CSUQUERYS()
Local aArea			:= GetArea()
Local cAtivos		:= "Ativos   "
Local cAdmitidos	:= "Admitidos"
Local cDemitidos	:= "Demitidos"
Local cEmFerias		:= "Em Ferias"
Local cIniFerias	:= "IniFerias"
Local cFimFerias	:= "FimFerias"
Local cAfastados	:= "Afastados"
Local cIniAfast		:= "IniAfast"
Local cFimAfast		:= "FimAfast" 
Local cEventos		:= "Eventos"
Local nX			:= 0 
Local nI			:= 0
Local nY			:= 0          

cAliasCtt	:= GetNextAlias()

BeginSql alias cAliasCtt
	Select distinct(CTT_DESC01) From %table:CTT% CTT
	Where CTT_CUSTO >= %exp:cCcDe% And CTT_CUSTO <= %exp:cCcAte%
		And CTT.%notDel%
	Order by CTT_DESC01
EndSql   

DbSelectArea(cAliasCtt)
(cAliasCtt)->(DbGoTop())

Begin Transaction 
	While (cAliasCtt)->(!EOF())
		aAdd(aCtt,(cAliasCtt)->CTT_DESC01)
		(cAliasCtt)->(dbSkip())
	EndDo              
End Transaction


If nTipRel == 1 .Or. nTipRel == 3
	cAliasFil	:= GetNextAlias()

	BeginSql alias cAliasFil
		Select distinct(RA_FILIAL) From %table:SRA% SRA
		Where RA_CC >= %exp:cCcDe% And RA_CC <= %exp:cCcAte%
			And SRA.%notDel%
		Order by RA_FILIAL
	EndSql   
	
	DbSelectArea(cAliasFil)
	(cAliasFil)->(DbGoTop())
	
	Begin Transaction 
		While (cAliasFil)->(!EOF())
			aAdd(aFil,(cAliasFil)->RA_FILIAL)
			(cAliasFil)->(dbSkip())
		EndDo              
	End Transaction
	
EndIf


cAliasCateg	:= GetNextAlias()

BeginSql alias cAliasCateg
	Select distinct(PA8_DESCR) From %table:PA8% PA8
	Where PA8.%notDel% 
	Order by PA8_DESCR
EndSql

DbSelectArea(cAliasCateg) 
(cAliasCateg)->(DbGoTop())

Begin Transaction 
	While (cAliasCateg)->(!EOF())
		aAdd(aCategoria,(cAliasCateg)->PA8_DESCR)
		(cAliasCateg)->(dbSkip())
	EndDo              
End Transaction
                  
nDias	:= dDataAte - dDataDe
                                 
//Cria tabela temporária para Head Count propriamente dito
aStru	:= {{	"CCUSTO" 	,"C"	,aTam[1]	,0 	} ,;	// Centro de Custo
		   {	"CATEGORIA"	,"C"	,aTam8[1]	,0 	} ,;	// Categoria da Funcao
		   {	"DATAMOV"  	,"C"	,08			,0 	} ,;	// Data do Evento (Admissao / Demissao)
		   {	"ATIVOS"    ,"N"	,06			,0  } ,;	// Quantidade de Ativos no Dia
		   {	"ADMITIDOS" ,"N"	,06			,0  } ,;	// Quantidade de Admitidos no Dia
		   {	"DEMITIDOS" ,"N"	,06			,0  } ,; 	// Quantidade de Demitidos no Dia
		   {	"EMFERIAS"  ,"N"	,06			,0  } ,;	// Quantidade em Ferias no Dia
		   {	"INIFERIAS" ,"N"	,06			,0  } ,;	// Quantidade Iniciando Ferias no Dia
		   {	"FIMFERIAS" ,"N"	,06			,0  } ,; 	// Quantidade Retornando das Ferias no Dia
		   {	"AFASTADOS" ,"N"	,06			,0  } ,;	// Quantidade Afastados no Dia
		   {	"INIAFAST"  ,"N"	,06			,0  } ,;	// Quantidade Iniciando Afastamento no Dia
		   {	"FIMAFAST"  ,"N"	,06			,0  } ,; 	// Quantidade Retornando de Afastamento no Dia
		   {	"TRANSSAI"	,"N"	,06			,0	} ,;	// Quantidade de Transferidos Saida
		   {	"TRANSENT"	,"N"	,06			,0	} ,;	// Quantidade de Transferidos Entrada
		   {	"FILIAL"    ,"C"	,02			,0  } }	 	// Filial

If ( Select ("cArqTemp") <> 0 )
	dbSelectArea ("cArqTemp")
	dbCloseArea ()
End

MsErase(cArqTemp)
MsCreate(cArqTemp, aStru, 'TOPCONN' ) 
dbUseArea( .T., 'TOPCONN', cArqTemp, cArqTemp, .T., .F. ) 
(cArqTemp)->( dbClearIndex() ) 
Index On CCUSTO+DATAMOV+CATEGORIA To (cArqTemp)+"02"
Index On CCUSTO+CATEGORIA+DATAMOV To (cArqTemp)+"01"

If nTipRel == 1 .Or. nTipRel == 3
	If ( Select ("cArqFiTp") <> 0 )
		dbSelectArea ("cArqFiTp")
		dbCloseArea ()
	End
	
	MsErase(cArqFiTp)
	MsCreate(cArqFiTp, aStru, 'TOPCONN' ) 
	dbUseArea( .T., 'TOPCONN', cArqFiTp, cArqFiTp, .T., .F. ) 
	(cArqFiTp)->( dbClearIndex() ) 
	Index On FILIAL+DATAMOV+CATEGORIA To (cArqFiTp)+"02"
	Index On FILIAL+CATEGORIA+DATAMOV To (cArqFiTp)+"01"
EndIf

If nTipRel == 2 .Or. nTipRel == 3
	If ( Select ("cArqEmTp") <> 0 )
		dbSelectArea ("cArqEmTp")
		dbCloseArea ()
	End
	
	MsErase(cArqEmTp)
	MsCreate(cArqEmTp, aStru, 'TOPCONN' ) 
	dbUseArea( .T., 'TOPCONN', cArqEmTp, cArqEmTp, .T., .F. ) 
	(cArqEmTp)->( dbClearIndex() ) 
	Index On DATAMOV+CATEGORIA To (cArqEmTp)+"02"
	Index On CATEGORIA+DATAMOV To (cArqEmTp)+"01"
EndIf

dbGoTop()

ProcRegua(Len(aCtt)*nDias*Len(aCategoria))

For nY := 1 to Len(aCtt)
	For nI	:= 0 to nDias   
		For nX := 1 to Len(aCategoria)
			RecLock(cArqTemp,.T.)
			Replace (cArqTemp)->CCUSTO    With aCtt[nY]
			Replace (cArqTemp)->CATEGORIA With aCategoria[nX]
			Replace (cArqTemp)->DATAMOV   With DtoS(dDataDe + nI)
			Replace (cArqTemp)->ATIVOS    With 0
			Replace (cArqTemp)->ADMITIDOS With 0
			Replace (cArqTemp)->DEMITIDOS With 0
			Replace (cArqTemp)->EMFERIAS  With 0
			Replace (cArqTemp)->INIFERIAS With 0
			Replace (cArqTemp)->FIMFERIAS With 0
			Replace (cArqTemp)->AFASTADOS With 0
			Replace (cArqTemp)->INIAFAST  With 0
			Replace (cArqTemp)->FIMAFAST  With 0
			Replace (cArqTemp)->TRANSSAI  With 0
			Replace (cArqTemp)->TRANSENT  With 0 
			Replace (cArqTemp)->FILIAL    With ""
			MsUnLock()
			IncProc(OemToAnsi("Gerando Arquivo de Trabalho") + ": " + ;
					aCtt[nY] + "/" + aCategoria[nX] + "/" +  DtoS(dDataDe + nI))
		Next nX
	Next nI
Next nY                                                   

If nTipRel == 1 .Or. nTipRel == 3
	For nY := 1 to Len(aFil)
		For nI	:= 0 to nDias   
			For nX := 1 to Len(aCategoria)
				RecLock(cArqFiTp,.T.)
				Replace (cArqFiTp)->FILIAL    With aFil[nY]
				Replace (cArqFiTp)->CATEGORIA With aCategoria[nX]
				Replace (cArqFiTp)->DATAMOV   With DtoS(dDataDe + nI)
				Replace (cArqFiTp)->ATIVOS    With 0
				Replace (cArqFiTp)->ADMITIDOS With 0
				Replace (cArqFiTp)->DEMITIDOS With 0
				Replace (cArqFiTp)->EMFERIAS  With 0
				Replace (cArqFiTp)->INIFERIAS With 0
				Replace (cArqFiTp)->FIMFERIAS With 0
				Replace (cArqFiTp)->AFASTADOS With 0
				Replace (cArqFiTp)->INIAFAST  With 0
				Replace (cArqFiTp)->FIMAFAST  With 0
				Replace (cArqFiTp)->TRANSSAI  With 0
				Replace (cArqFiTp)->TRANSENT  With 0 
				Replace (cArqFiTp)->CCUSTO    With ""
				MsUnLock()
				IncProc(OemToAnsi("Gerando Informações de Filiais") + ": " + ;
						aFil[nY] + "/" + aCategoria[nX] + "/" +  DtoS(dDataDe + nI))
			Next nX
		Next nI
	Next nY  
EndIf                                                

If nTipRel == 2 .Or. nTipRel == 3
	For nI	:= 0 to nDias   
		For nX := 1 to Len(aCategoria)
			RecLock(cArqEmTp,.T.)
			Replace (cArqEmTp)->CATEGORIA With aCategoria[nX]
			Replace (cArqEmTp)->DATAMOV   With DtoS(dDataDe + nI)
			Replace (cArqEmTp)->ATIVOS    With 0
			Replace (cArqEmTp)->ADMITIDOS With 0
			Replace (cArqEmTp)->DEMITIDOS With 0
			Replace (cArqEmTp)->EMFERIAS  With 0
			Replace (cArqEmTp)->INIFERIAS With 0
			Replace (cArqEmTp)->FIMFERIAS With 0
			Replace (cArqEmTp)->AFASTADOS With 0
			Replace (cArqEmTp)->INIAFAST  With 0
			Replace (cArqEmTp)->FIMAFAST  With 0
			Replace (cArqEmTp)->TRANSSAI  With 0
			Replace (cArqEmTp)->TRANSENT  With 0 
			Replace (cArqEmTp)->CCUSTO    With ""
			Replace (cArqEmTp)->FILIAL    With ""
			MsUnLock()
			IncProc(OemToAnsi("Gerando Informações da Empresa") + " " + ;
					aCategoria[nX] + "/" +  DtoS(dDataDe + nI))
		Next nX
	Next nI
EndIf                                                


//Cria tabela temporária para controle dos eventos de ponto
aCpos	:= {{	"CCUSTO" 	,"C"	,aTam[1]	,0 	} ,;	// Centro de Custo
		   {	"CODIGO"	,"C"	,03			,0 	} ,;	// Codigo do Evento a imprimir
		   {	"EVENTO"	,"C"	,20			,0 	} ,;	// Descricao do Evento a imprimir
		   {	"DATAMOV"  	,"C"	,08			,0 	} ,;	// Data do Evento
		   {	"CREDITOS"  ,"N"	,06			,0  } ,;	// Horas a Credito
		   {	"DEBITOS"	,"N"	,06			,0  } ,;	// Horas a Debito
		   {	"FILIAL"	,"C"	,02			,0  } } 	// Filial

If ( Select ("cArqEven") <> 0 )
	dbSelectArea ("cArqEven")
	dbCloseArea ()
End

MsErase(cArqEven)
MsCreate(cArqEven, aCpos, 'TOPCONN' ) 
dbUseArea( .T., 'TOPCONN', cArqEven, cArqEven, .T., .F. ) 
(cArqEven)->( dbClearIndex() ) 
Index On CCUSTO+CODIGO+DATAMOV To (cArqEven)+"01"

If nTipRel == 1 .Or. nTipRel == 3
	If ( Select ("cArqFiEv") <> 0 )
		dbSelectArea ("cArqFiEv")
		dbCloseArea ()
	End
	
	MsErase(cArqFiEv)
	MsCreate(cArqFiEv, aCpos, 'TOPCONN' ) 
	dbUseArea( .T., 'TOPCONN', cArqFiEv, cArqFiEv, .T., .F. ) 
	(cArqFiEv)->( dbClearIndex() ) 
	Index On FILIAL+CODIGO+DATAMOV To (cArqFiEv)+"01"
EndIf

If nTipRel == 2 .Or. nTipRel == 3
	If ( Select ("cArqEmEv") <> 0 )
		dbSelectArea ("cArqEmEv")
		dbCloseArea ()
	End
	
	MsErase(cArqEmEv)
	MsCreate(cArqEmEv, aCpos, 'TOPCONN' ) 
	dbUseArea( .T., 'TOPCONN', cArqEmEv, cArqEmEv, .T., .F. ) 
	(cArqEmEv)->( dbClearIndex() ) 
	Index On CODIGO+DATAMOV To (cArqEmEv)+"01"
EndIf

cAliasAtivo	:= GetNextAlias()
cAliasAdmit	:= GetNextAlias()
cAliasDemit	:= GetNextAlias()
cAliasEmFer	:= GetNextAlias()
cAliasIniFe	:= GetNextAlias()
cAliasFimFe	:= GetNextAlias()
cAliasAfast	:= GetNextAlias()
cAliasIniAf	:= GetNextAlias()
cAliasFimAf	:= GetNextAlias()
cAliasEvent	:= GetNextAlias()

If nTipRel == 1 .Or. nTipRel == 3
	cAlsFiEvent	:= GetNextAlias()
EndIf

If nTipRel == 2 .Or. nTipRel == 3
	cAlsEmEvent	:= GetNextAlias()
EndIf

MakeSqlExpr(cPerg)     
                       
                  
BeginSql alias cAliasAtivo

	Column RA_ADMISSA as Date
	Column RA_DEMISSA as Date
	Column PA6_ADMISS as Date 
	
	Select %exp:cAtivos% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, RA_FILIAL Filial, RA_MAT Matricula, 
			CTT_CUSTO CodCCusto, PA8_DESCR Categoria
		From %table:CTT% CTT 
			Left Join %table:SRA% SRA On RA_CC = CTT_CUSTO 
				And RA_ADMISSA <= %exp:dDataDe% 
				And (RA_DEMISSA = ' ' Or RA_DEMISSA >= %exp:dDataDe%)
				And SRA.%notDel% And CTT.%notDel%
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel%  
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO 
				And PA8.%notDel%
	Union All
	Select %exp:cAtivos% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, PA6_FILIAL Filial, PA6_MAT Matricula, 
			CTT_CUSTO CodCCusto, PA8_DESCR Categoria
	    From %table:CTT% CTT  
	    	Left Join %table:PA6% PA6 On PA6_CC = CTT_CUSTO
	    		And PA6_ADMISS <= %exp:dDataDe% And PA6_INTEGR <>'I' And PA6_DESIST <> 'S'
    			And PA6.%notDel% And CTT.%notDel%
	    	Inner Join %table:SRJ% SRJ On PA6_CODFUN = RJ_FUNCAO 
	    		And SRJ.%notDel%
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
	Union All
	Select %exp:cAtivos% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, PA7_FILIAL Filial, PA7_MAT Matricula, 
			CTT_CUSTO CodCCusto, PA8_DESCR Categoria 
	    From %table:CTT% CTT 
			Left Join %table:PA7% PA7 On PA7_CC = CTT_CUSTO
				And PA7_DEMISS <= %exp:dDataDe%
				And CTT.%notDel% And PA7.%notDel%
	    	Inner Join %table:SRJ% SRJ On PA7_CODFUN = RJ_FUNCAO
	    		And SRJ.%notDel% 
			Inner Join %table:SRA% SRA On PA7_FILIAL = RA_MAT And PA7_MAT = RA_MAT 
				And (RA_DEMISSA = ' ' Or RA_DEMISSA >= %exp:dDataDe%)
				And SRA.%notDel%
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
	Order by CCusto, Categoria
EndSql


BeginSql alias cAliasAdmit
	Column RA_ADMISSA as Date
	Column PA6_ADMISS as Date

	Select %exp:cAdmitidos% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, RA_ADMISSA Admiss, RA_FILIAL Filial, 
			CTT_CUSTO CodCCusto, RA_MAT Matricula, PA8_DESCR Categoria 
		From %table:SRA% SRA 
			Inner Join %table:CTT% CTT On RA_CC = CTT_CUSTO   
				And RA_ADMISSA >= %exp:dDataDe% And RA_ADMISSA <= %exp:dDataAte%
				And CTT.%notDel% And SRA.%notDel%
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel% 
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
	Union All
	Select %exp:cAdmitidos% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, PA6_ADMISS Admiss, PA6_FILIAL Filial, 
			CTT_CUSTO CodCCusto, PA6_MAT Matricula, PA8_DESCR Categoria 
		From %table:PA6% PA6 
			Inner Join %table:CTT% CTT On PA6_CC = CTT_CUSTO
				And PA6_ADMISS >= %exp:dDataDe% And PA6_ADMISS <= %exp:dDataAte%
				And PA6_INTEGR <> 'I' And PA6_DESIST <> 'S'
				And PA6.%notDel% And CTT.%notDel%
			Inner Join %table:SRJ% SRJ On PA6_CODFUN = RJ_FUNCAO 
				And SRJ.%notDel% 
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
	Order by CCusto, Categoria, Admiss
EndSql

BeginSql alias cAliasDemit
	Column RA_DEMISSA as Date
	Column PA7_DEMISS as Date

	Select %exp:cDemitidos% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, RA_DEMISSA Demiss, RA_FILIAL Filial, 
			CTT_CUSTO CodCCusto, RA_MAT Matricula, PA8_DESCR Categoria 
		From %table:SRA% SRA 
			Inner Join %table:CTT% CTT On RA_CC = CTT_CUSTO   
				And RA_DEMISSA >= %exp:dDataDe% And RA_DEMISSA <= %exp:dDataAte%
				And CTT.%notDel% And SRA.%notDel%
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel% 
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
	Union All
	Select %exp:cDemitidos% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, PA7_DEMISS Demiss, PA7_FILIAL Filial, 
			CTT_CUSTO CodCCusto, PA7_MAT Matricula, PA8_DESCR Categoria 
		From %table:PA7% PA7 
			Inner Join %table:CTT% CTT On PA7_CC = CTT_CUSTO
				And PA7_DEMISS >= %exp:dDataDe% And PA7_DEMISS <= %exp:dDataAte%
				And PA7.%notDel% And CTT.%notDel%
			Inner Join %table:SRJ% SRJ On PA7_CODFUN = RJ_FUNCAO 
				And SRJ.%notDel% 
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
	Order by CCusto, Categoria, Demiss
EndSql


BeginSql alias cAliasEmFer
	Column R8_DATAINI as Date
	Column R8_DATAFIM as Date
	
	Select %exp:cEmFerias% Acao, CTT_DESC01 CCusto, PA8_DESCR Categoria, R8_FILIAL Filial, 	CTT_CUSTO CodCCusto, 
			RJ_X_CATEG Categ, R8_MAT Matricula 
		From %table:CTT% CTT 
			Left Join %table:SRA% SRA On RA_CC = CTT_CUSTO 
				And SRA.%notDel% And CTT.%notDel% 
			Inner Join %table:SR8% SR8 On RA_FILIAL = R8_FILIAL And RA_MAT = R8_MAT
				And R8_DATAINI >= %exp:dDataDe% And R8_DATAFIM <= %exp:dDataAte% 
				And R8_TIPO = 'F' And SR8.%notDel%
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel% 
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
		Order by CCusto, Categoria
EndSql


BeginSql alias cAliasInife
	Column R8_DATAINI as Date
	
	Select %exp:cIniFerias% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, PA8_DESCR Categoria, R8_DATAINI IniFerias, 
			RA_FILIAL Filial, R8_MAT Matricula, CTT_CUSTO CodCCusto 
		From %table:SRA% SRA 
			Inner Join %table:SR8% SR8 On RA_FILIAL = R8_FILIAL And RA_MAT = R8_MAT
				And R8_DATAINI >= %exp:dDataDe% And R8_DATAINI <= %exp:dDataAte%
				And R8_TIPO = 'F' And SR8.%notDel% 	And SRA.%notDel% 
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel% 
			Inner Join %table:CTT% CTT On RA_CC = CTT_CUSTO 
				And CTT.%notDel%
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
		Order by CCusto, Categoria, IniFerias
EndSql


BeginSql alias cAliasFimFe
	Column R8_DATAFIM as Date

	Select %exp:cFimFerias% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, PA8_DESCR Categoria, R8_DATAFIM FimFerias, 
			RA_FILIAL Filial, R8_MAT Matricula, CTT_CUSTO CodCCusto 
		From %table:SRA% SRA 
			Inner Join %table:SR8% SR8 On RA_FILIAL = R8_FILIAL And RA_MAT = R8_MAT
				And R8_TIPO = 'F' And SR8.%notDel% And SRA.%notDel% 
			Inner Join %table:CTT% CTT On RA_CC = CTT_CUSTO
				And R8_DATAFIM >= %exp:dDataDe% And R8_DATAFIM <= %exp:dDataAte%
			And CTT.%notDel%
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel%
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
		Order by CCusto, Categoria, FimFerias
EndSql


BeginSql alias cAliasAfast
	Column R8_DATAINI as Date
	Column R8_DATAFIM as Date
	
	Select %exp:cAfastados% Acao, CTT_DESC01 CCusto, PA8_DESCR Categoria,  RA_FILIAL Filial, R8_MAT Matricula, 
			CTT_CUSTO CodCCusto, RJ_X_CATEG Categ
		From %table:CTT% CTT 
			Left Join %table:SRA% SRA On RA_CC = CTT_CUSTO 
				And SRA.%notDel% And CTT.%notDel% 
			Inner Join %table:SR8% SR8 On RA_FILIAL = R8_FILIAL And RA_MAT = R8_MAT
				And R8_DATAINI >= %exp:dDataDe% And R8_DATAFIM <= %exp:dDataAte% 
				And R8_TIPO <> 'F' And SR8.%notDel%
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel% 
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
		Order by CCusto, Categoria
EndSql


BeginSql alias cAliasIniAf
	Column R8_DATAINI as Date
	
	Select %exp:cIniAfast% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, PA8_DESCR Categoria, R8_DATAINI IniAfast, 
			RA_FILIAL Filial, R8_MAT Matricula, CTT_CUSTO CodCCusto 
		From %table:SRA% SRA 
			Inner Join %table:SR8% SR8 On RA_FILIAL = R8_FILIAL And RA_MAT = R8_MAT
				And R8_DATAINI >= %exp:dDataDe% And R8_DATAINI <= %exp:dDataAte%
				And R8_TIPO <> 'F' And SR8.%notDel% 	And SRA.%notDel% 
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel% 
			Inner Join %table:CTT% CTT On RA_CC = CTT_CUSTO 
				And CTT.%notDel%
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
		Order by CCusto, Categoria, IniAfast
EndSql


BeginSql alias cAliasFimAf
	Column R8_DATAFIM as Date

	Select %exp:cFimAfast% Acao, CTT_DESC01 CCusto, RJ_X_CATEG Categ, PA8_DESCR Categoria, R8_DATAFIM FimAfast, 
			RA_FILIAL Filial, R8_MAT Matricula, CTT_CUSTO CodCCusto
		From %table:SRA% SRA 
			Inner Join %table:SR8% SR8 On RA_FILIAL = R8_FILIAL And RA_MAT = R8_MAT
				And R8_TIPO <> 'F' And SR8.%notDel% And SRA.%notDel% 
			Inner Join %table:CTT% CTT On RA_CC = CTT_CUSTO
				And R8_DATAFIM >= %exp:dDataDe% And R8_DATAFIM <= %exp:dDataAte%
			And CTT.%notDel%
			Inner Join %table:SRJ% SRJ On RA_CODFUNC = RJ_FUNCAO 
				And SRJ.%notDel%
			Inner Join %table:PA8% PA8 On RJ_X_CATEG = PA8_CODIGO
				And PA8.%notDel%
		Order by CCusto, Categoria, FimAfast
EndSql


BeginSql alias cAliasEvent
	Column PC_DATA as Date
	Column PH_DATA as Date
	
	Select CTT_DESC01 CCusto, PC_DATA DataMov, PC_PD Codigo, P9_DESC Evento, P9_TIPOCOD, PC_QUANTC QuantHrs, 
			RA_FILIAL Filial, CTT_CUSTO CodCCusto 
		From %table:SPC% SPC 
			Inner Join %table:CTT% CTT On PC_CC = CTT_CUSTO 
				And PC_DATA >= %exp:dDataDe% And PC_DATA <= %exp:dDataAte% 
				And CTT_CUSTO >= %exp:cCcDe% And CTT_CUSTO <= %exp:cCcAte% 
				And SPC.%notDel% And CTT.%notDel%  
			Inner Join %table:SRA% SRA On RA_FILIAL = PC_FILIAL And RA_MAT = PC_MAT 
				And SRA.%notDel%
			Inner Join %table:SP9% SP9 On PC_PD = P9_CODIGO 
				And SP9.%notDel% 
	Union All 
	(Select CTT_DESC01 CCUSTO, PH_DATA DataMov, PH_PD Codigo, P9_DESC Evento, P9_TIPOCOD, PH_QUANTC QuantHrs, 
			RA_FILIAL Filial, CTT_CUSTO CodCCusto 
		From %table:SPH% SPH  
			Inner Join %table:CTT% CTT On PH_CC = CTT_CUSTO 
				And PH_DATA >= %exp:dDataDe% And PH_DATA <= %exp:dDataAte% 
				And CTT_CUSTO >= %exp:cCcDe% And CTT_CUSTO <= %exp:cCcAte% 
				And SPH.%notDel% And CTT.%notDel%  
			Inner Join %table:SRA% SRA On RA_FILIAL = PH_FILIAL And RA_MAT = PH_MAT 
				And SRA.%notDel%
			Inner Join %table:SP9% SP9 On PH_PD = P9_CODIGO 
				And SP9.%notDel%)
	Order by CCusto, P9_TIPOCOD, DataMov, Codigo, Evento
EndSql          

If nTipRel == 1 .Or. nTipRel == 3
	BeginSql alias cAlsFiEvent
		Column PC_DATA as Date
		Column PH_DATA as Date
		
		Select PC_DATA DataMov, PC_PD Codigo, P9_DESC Evento, P9_TIPOCOD, PC_QUANTC QuantHrs, RA_FILIAL Filial, 
				CTT_CUSTO CodCCusto
			From %table:SPC% SPC  
				Inner Join %table:CTT% CTT On PC_CC = CTT_CUSTO
					And CTT_CUSTO >= %exp:cCcDe% And CTT_CUSTO <= %exp:cCcAte%
					And PC_DATA >= %exp:dDataDe% And PC_DATA <= %exp:dDataAte%
					And CTT.%notDel% And SPC.%notDel%
				Inner Join %table:SRA% SRA On RA_FILIAL = PC_FILIAL And RA_MAT = PC_MAT
					And SRA.%notDel%
				Inner Join %table:SP9% SP9 On PC_PD = P9_CODIGO
					And SP9.%notDel%
		Union All
		(Select PH_DATA DataMov, PH_PD Codigo, P9_DESC Evento, P9_TIPOCOD, PH_QUANTC QuantHrs, RA_FILIAL Filial, 
				CTT_CUSTO CodCCusto
			From %table:SPH% SPH  
				Inner Join %table:CTT% CTT On PH_CC = CTT_CUSTO
					And CTT_CUSTO >= %exp:cCcDe% And CTT_CUSTO <= %exp:cCcAte%
					And CTT.%notDel% And SPH.%notDel% 
				Inner Join %table:SRA% SRA On RA_FILIAL = PH_FILIAL And RA_MAT = PH_MAT  
					And PH_DATA >= %exp:dDataDe% And PH_DATA <= %exp:dDataAte%
					And SRA.%notDel% 
				Inner Join %table:SP9% SP9 On PH_PD = P9_CODIGO
					And SP9.%notDel%)
		Order by Filial, P9_TIPOCOD, DataMov, Codigo, Evento
	EndSql          
EndIf

If nTipRel == 2 .Or. nTipRel == 3
	BeginSql alias cAlsEmEvent
		Column PC_DATA as Date
		Column PH_DATA as Date
		
		Select PC_DATA DataMov, PC_PD Codigo, P9_DESC Evento, P9_TIPOCOD, PC_QUANTC QuantHrs, CTT_CUSTO CodCCusto
			From %table:SPC% SPC  
				Inner Join %table:CTT% CTT On PC_CC = CTT_CUSTO
					And CTT_CUSTO >= %exp:cCcDe% And CTT_CUSTO <= %exp:cCcAte%
					And PC_DATA >= %exp:dDataDe% And PC_DATA <= %exp:dDataAte%
					And CTT.%notDel% And SPC.%notDel% 
				Inner Join %table:SRA% SRA On RA_FILIAL = PC_FILIAL And RA_MAT = PC_MAT
					And SRA.%notDel%
				Inner Join %table:SP9% SP9 On PC_PD = P9_CODIGO
					And SP9.%notDel%
		Union All
		(Select PH_DATA DataMov, PH_PD Codigo, P9_DESC Evento, P9_TIPOCOD, PH_QUANTC QuantHrs, CTT_CUSTO CodCCusto
			From %table:SPH% SPH  
				Inner Join %table:CTT% CTT On PH_CC = CTT_CUSTO
					And CTT_CUSTO >= %exp:cCcDe% And CTT_CUSTO <= %exp:cCcAte%
					And PH_DATA >= %exp:dDataDe% And PH_DATA <= %exp:dDataAte%
					And CTT.%notDel% And SPH.%notDel%
				Inner Join %table:SRA% SRA On RA_FILIAL = PH_FILIAL And RA_MAT = PH_MAT  
					And SRA.%notDel% 
				Inner Join %table:SP9% SP9 On PH_PD = P9_CODIGO
					And SP9.%notDel%)
		Order by P9_TIPOCOD, DataMov, Codigo, Evento
	EndSql          
EndIf

       
//Atualiza Ativos
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1)) 
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1)) 
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1)) 
	EndIf
	DbSelectArea(cAliasAtivo)
	(cAliasAtivo)->(DbGoTop())
	While (cAliasAtivo)->(!EOF())
		dDataReal	:= dDataDe 
		cCCustoReal	:= (cAliasAtivo)->CodCCusto
		cCcDescReal	:= (cAliasAtivo)->CCusto
		cFilialReal	:= (cAliasAtivo)->Filial
		If SRA->(DbSeek((cAliasAtivo)->Filial+(cAliasAtivo)->Matricula))
			aTransf	:= {}
			fTransf(@aTransf,.T.)
			IF Len(aTransf) > 0
				For nX	:= 1 to Len(aTransf)  
					If aTransf[nX][7] <= dDataDe
						dDataReal	:= aTransf[nX][7]
						cCCustoReal	:= aTransf[nX][3]
						cFilialReal	:= aTransf[nX][8]
					Else
						nX	:= Len(aTransf)
					EndIf
					If (cArqTemp)->(DbSeek(aTransf[nX][3]+(cAliasAtivo)->Categoria+DtoS(aTransf[nX][7])))
						RecLock(cArqTemp,.F.)                           
						Replace (cArqTemp)->TRANSSAI With ((cArqTemp)->TRANSSAI + 1)
						MsUnLock()
					EndIf
					If (cArqTemp)->(DbSeek(aTransf[nX][6]+(cAliasAtivo)->Categoria+DtoS(aTransf[nX][7])))
						RecLock(cArqTemp,.F.)                           
						Replace (cArqTemp)->TRANSENT With ((cArqTemp)->TRANSENT + 1)
						MsUnLock()
					EndIf
					If nTipRel == 1 .Or. nTipRel == 3
						If (cArqFiTp)->(DbSeek(aTransf[nX][8]+(cAliasAtivo)->Categoria+DtoS(aTransf[nX][7])))
							RecLock(cArqFiTp,.F.)                           
							Replace (cArqFiTp)->TRANSSAI With ((cArqFiTp)->TRANSSAI + 1)
							MsUnLock()
						EndIf
						If (cArqFiTp)->(DbSeek(aTransf[nX][10]+(cAliasAtivo)->Categoria+DtoS(aTransf[nX][7])))
							RecLock(cArqFiTp,.F.)                           
							Replace (cArqFiTp)->TRANSENT With ((cArqFiTp)->TRANSENT + 1)
							MsUnLock()
						EndIf
					EndIf
					//Não está sendo tratada a transferência entre empresas
//					If nTipRel == 2 .Or. nTipRel == 3
//						If (cArqEmTp)->(DbSeek((cAliasAtivo)->Categoria+DtoS(aTransf[nX][7])))
//							RecLock(cArqEmTp,.F.)                           
//							Replace (cArqEmTp)->TRANSSAI With ((cArqEmTp)->TRANSSAI + 1)
//							MsUnLock()
//						EndIf
//						If (cArqEmTp)->(DbSeek((cAliasAtivo)->Categoria+DtoS(aTransf[nX][7])))
//							RecLock(cArqEmTp,.F.)                           
//							Replace (cArqEmTp)->TRANSENT With ((cArqEmTp)->TRANSENT + 1)
//							MsUnLock()
//						EndIf
//					EndIf
				Next nX  
				cCcDescReal	:= fDesc("CTT",cFilialReal+cCCustoReal,"CTT_DESC01")
			EndIf
		EndIf
		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasAtivo)->Categoria+DtoS(dDataDe)))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->ATIVOS With ((cArqTemp)->ATIVOS + 1)
			Replace (cArqTemp)->FILIAL With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasAtivo)->Categoria+DtoS(dDataDe)))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->ATIVOS With ((cArqFiTp)->ATIVOS + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasAtivo)->Categoria+DtoS(dDataDe)))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->ATIVOS With ((cArqEmTp)->ATIVOS + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasAtivo)->(DbSkip())
	EndDo
End Transaction
		
//Atualiza Admitidos
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1)) 
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1)) 
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1)) 
	EndIf
	DbSelectArea(cAliasAdmit)
	(cAliasAdmit)->(DbGoTop())
	While (cAliasAdmit)->(!EOF())
		dDataReal	:= (cAliasAdmit)->Admiss 
		cCCustoReal	:= (cAliasAdmit)->CodCCusto
		cCcDescReal	:= (cAliasAdmit)->CCusto
		cFilialReal	:= (cAliasAdmit)->Filial
		If SRA->(DbSeek((cAliasAdmit)->Filial+(cAliasAdmit)->Matricula))
			aTransf	:= {}
			fTransf(@aTransf,.T.)
			IF Len(aTransf) > 0
				For nX	:= 1 to Len(aTransf)  
					If aTransf[nX][7] <= dDataDe
						dDataReal	:= aTransf[nX][7]
						cCCustoReal	:= aTransf[nX][3]
						cFilialReal	:= aTransf[nX][8]
					Else
						nX	:= Len(aTransf)
					EndIf						                    
				Next nX  
				cCcDescReal	:= fDesc("CTT",cFilialReal+cCCustoReal,"CTT_DESC01")
			EndIf
		EndIf
		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasAdmit)->Categoria+(cAliasAdmit)->Admiss))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->ADMITIDOS With ((cArqTemp)->ADMITIDOS + 1)
			Replace (cArqTemp)->FILIAL    With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasAdmit)->Categoria+(cAliasAdmit)->Admiss))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->ADMITIDOS With ((cArqFiTp)->ADMITIDOS + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasAdmit)->Categoria+(cAliasAdmit)->Admiss))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->ADMITIDOS With ((cArqEmTp)->ADMITIDOS + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasAdmit)->(DbSkip())
	EndDo
End Transaction
		
//Atualiza Demitidos
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1))  
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1))
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1))
	EndIf
	DbSelectArea(cAliasDemit)
	(cAliasDemit)->(DbGoTop())


	While (cAliasDemit)->(!EOF())
		dDataReal	:= (cAliasDemit)->Demiss 
		cCCustoReal	:= (cAliasDemit)->CodCCusto
		cCcDescReal	:= (cAliasDemit)->CCusto
		cFilialReal	:= (cAliasDemit)->Filial

		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasDemit)->Categoria+(cAliasDemit)->Demiss))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->DEMITIDOS With ((cArqTemp)->DEMITIDOS + 1)
			Replace (cArqTemp)->FILIAL    With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasDemit)->Categoria+(cAliasDemit)->Demiss))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->DEMITIDOS With ((cArqFiTp)->DEMITIDOS + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasDemit)->Categoria+(cAliasDemit)->Demiss))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->ADMITIDOS With ((cArqEmTp)->DEMITIDOS + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasDemit)->(DbSkip())
	EndDo
End Transaction


//Atualiza Em Ferias
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1)) 
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1)) 
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1)) 
	EndIf
	DbSelectArea(cAliasEmFer)
	(cAliasEmFer)->(DbGoTop())  
	While (cAliasEmFer)->(!EOF())
		dDataReal	:= dDataDe 
		cCCustoReal	:= (cAliasEmFer)->CodCCusto
		cCcDescReal	:= (cAliasEmFer)->CCusto
		cFilialReal	:= (cAliasEmFer)->Filial
		If SRA->(DbSeek((cAliasEmFer)->Filial+(cAliasEmFer)->Matricula))
			aTransf	:= {}
			fTransf(@aTransf,.T.)
			IF Len(aTransf) > 0
				For nX	:= 1 to Len(aTransf)  
					If aTransf[nX][7] <= dDataDe
						dDataReal	:= aTransf[nX][7]
						cCCustoReal	:= aTransf[nX][3]
						cFilialReal	:= aTransf[nX][8]
					Else
						nX	:= Len(aTransf)
					EndIf						                    
				Next nX  
				cCcDescReal	:= fDesc("CTT",cFilialReal+cCCustoReal,"CTT_DESC01")
			EndIf
		EndIf
		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasEmFer)->Categoria+DtoS(dDataDe)))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->EMFERIAS With ((cArqTemp)->EMFERIAS + 1)
			Replace (cArqTemp)->FILIAL   With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasEmFer)->Categoria+DtoS(dDataDe)))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->EMFERIAS With ((cArqFiTp)->EMFERIAS + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasEmFer)->Categoria+DtoS(dDataDe)))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->EMFERIAS With ((cArqEmTp)->EMFERIAS + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasEmFer)->(DbSkip())
	EndDo
End Transaction
	

//Atualiza Inicio de Ferias
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1)) 
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1)) 
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1)) 
	EndIf
	DbSelectArea(cAliasIniFe)
	(cAliasIniFe)->(DbGoTop())

	While (cAliasIniFe)->(!EOF())
		dDataReal	:= (cAliasIniFe)->IniFerias 
		cCCustoReal	:= (cAliasIniFe)->CodCCusto
		cCcDescReal	:= (cAliasIniFe)->CCusto
		cFilialReal	:= (cAliasIniFe)->Filial
		If SRA->(DbSeek((cAliasIniFe)->Filial+(cAliasIniFe)->Matricula))
			aTransf	:= {}
			fTransf(@aTransf,.T.)
			IF Len(aTransf) > 0
				For nX	:= 1 to Len(aTransf)  
					If aTransf[nX][7] <= dDataDe
						dDataReal	:= aTransf[nX][7]
						cCCustoReal	:= aTransf[nX][3]
						cFilialReal	:= aTransf[nX][8]
					Else
						nX	:= Len(aTransf)
					EndIf						                    
				Next nX  
				cCcDescReal	:= fDesc("CTT",cFilialReal+cCCustoReal,"CTT_DESC01")
			EndIf
		EndIf
		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasIniFe)->Categoria+(cAliasIniFe)->IniFerias))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->INIFERIAS With ((cArqTemp)->INIFERIAS + 1)
			Replace (cArqTemp)->FILIAL    With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasIniFe)->Categoria+(cAliasIniFe)->IniFerias))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->INIFERIAS With ((cArqFiTp)->INIFERIAS + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasIniFe)->Categoria+(cAliasIniFe)->IniFerias))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->INIFERIAS With ((cArqEmTp)->INIFERIAS + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasIniFe)->(DbSkip())
	EndDo
End Transaction
	

//Atualiza Fim de Ferias
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1)) 
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1)) 
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1)) 
	EndIf
	DbSelectArea(cAliasFimFe)
	(cAliasFimFe)->(DbGoTop())
	While (cAliasFimFe)->(!EOF())
		dDataReal	:= (cAliasFimFe)->FimFerias 
		cCCustoReal	:= (cAliasFimFe)->CodCCusto
		cCcDescReal	:= (cAliasFimFe)->CCusto
		cFilialReal	:= (cAliasFimFe)->Filial
		If SRA->(DbSeek((cAliasFimFe)->Filial+(cAliasFimFe)->Matricula))
			aTransf	:= {}
			fTransf(@aTransf,.T.)
			IF Len(aTransf) > 0
				For nX	:= 1 to Len(aTransf)  
					If aTransf[nX][7] <= dDataDe
						dDataReal	:= aTransf[nX][7]
						cCCustoReal	:= aTransf[nX][3]
						cFilialReal	:= aTransf[nX][8]
					Else
						nX	:= Len(aTransf)
					EndIf						                    
				Next nX  
				cCcDescReal	:= fDesc("CTT",cFilialReal+cCCustoReal,"CTT_DESC01")
			EndIf
		EndIf
	
		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasFimFe)->Categoria+(cAliasFimFe)->FimFerias))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->FIMFERIAS With ((cArqTemp)->FIMFERIAS + 1)
			Replace (cArqTemp)->FILIAL    With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasFimFe)->Categoria+(cAliasFimFe)->FimFerias))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->FIMFERIAS With ((cArqFiTp)->FIMFERIAS + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasFimFe)->Categoria+(cAliasFimFe)->FimFerias))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->FIMFERIAS With ((cArqEmTp)->FIMFERIAS + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasFimFe)->(DbSkip())
	EndDo
End Transaction


//Atualiza Afastados
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1)) 
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1)) 
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1)) 
	EndIf
	DbSelectArea(cAliasAfast)
	(cAliasAfast)->(DbGoTop())
	While (cAliasAfast)->(!EOF())
		dDataReal	:= dDataDe 
		cCCustoReal	:= (cAliasAfast)->CodCCusto
		cCcDescReal	:= (cAliasAfast)->CCusto
		cFilialReal	:= (cAliasAfast)->Filial
		If SRA->(DbSeek((cAliasAfast)->Filial+(cAliasAfast)->Matricula))
			aTransf	:= {}
			fTransf(@aTransf,.T.)
			IF Len(aTransf) > 0
				For nX	:= 1 to Len(aTransf)  
					If aTransf[nX][7] <= dDataDe
						dDataReal	:= aTransf[nX][7]
						cCCustoReal	:= aTransf[nX][3]
						cFilialReal	:= aTransf[nX][8]
					Else
						nX	:= Len(aTransf)
					EndIf						                    
				Next nX  
				cCcDescReal	:= fDesc("CTT",cFilialReal+cCCustoReal,"CTT_DESC01")
			EndIf
		EndIf
		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasAfast)->Categoria+DtoS(dDataDe)))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->AFASTADOS With ((cArqTemp)->AFASTADOS + 1)
			Replace (cArqTemp)->FILIAL   With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasAfast)->Categoria+DtoS(dDataDe)))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->AFASTADOS With ((cArqFiTp)->AFASTADOS + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasAfast)->Categoria+DtoS(dDataDe)))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->AFASTADOS With ((cArqEmTp)->AFASTADOS + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasAfast)->(DbSkip())
	EndDo
End Transaction

		
//Atualiza Inicio de Afastamento
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1)) 
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1)) 
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1)) 
	EndIf
	DbSelectArea(cAliasIniAf)
	(cAliasIniAf)->(DbGoTop())

	While (cAliasIniAf)->(!EOF())
		dDataReal	:= (cAliasIniAf)->IniAfast 
		cCCustoReal	:= (cAliasIniAf)->CodCCusto
		cCcDescReal	:= (cAliasIniAf)->CCusto
		cFilialReal	:= (cAliasIniAf)->Filial
		If SRA->(DbSeek((cAliasIniAf)->Filial+(cAliasIniAf)->Matricula))
			aTransf	:= {}
			fTransf(@aTransf,.T.)
			IF Len(aTransf) > 0
				For nX	:= 1 to Len(aTransf)  
					If aTransf[nX][7] <= dDataDe
						dDataReal	:= aTransf[nX][7]
						cCCustoReal	:= aTransf[nX][3]
						cFilialReal	:= aTransf[nX][8]
					Else
						nX	:= Len(aTransf)
					EndIf						                    
				Next nX  
				cCcDescReal	:= fDesc("CTT",cFilialReal+cCCustoReal,"CTT_DESC01")
			EndIf
		EndIf
		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasIniAf)->Categoria+(cAliasIniAf)->IniAfast))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->INIAFAST With ((cArqTemp)->INIAFAST + 1)
			Replace (cArqTemp)->FILIAL    With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasIniAf)->Categoria+(cAliasIniAf)->IniAfast))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->INIAFAST With ((cArqFiTp)->INIAFAST + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasIniAf)->Categoria+(cAliasIniAf)->IniAfast))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->INIAFAST With ((cArqEmTp)->INIAFAST + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasIniAf)->(DbSkip())
	EndDo
End Transaction

		
//Atualiza Fim de Afastamento
Begin Transaction
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1)) 
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiTp)
		(cArqFiTp)->(dbSetOrder(1)) 
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmTp)
		(cArqEmTp)->(dbSetOrder(1)) 
	EndIf
	DbSelectArea(cAliasFimAf)
	(cAliasFimAf)->(DbGoTop())

	While (cAliasFimAf)->(!EOF())
		dDataReal	:= (cAliasFimAf)->FimAfast 
		cCCustoReal	:= (cAliasFimAf)->CodCCusto
		cCcDescReal	:= (cAliasFimAf)->CCusto
		cFilialReal	:= (cAliasFimAf)->Filial
		If SRA->(DbSeek((cAliasFimAf)->Filial+(cAliasFimAf)->Matricula))
			aTransf	:= {}
			fTransf(@aTransf,.T.)
			IF Len(aTransf) > 0
				For nX	:= 1 to Len(aTransf)  
					If aTransf[nX][7] <= dDataDe
						dDataReal	:= aTransf[nX][7]
						cCCustoReal	:= aTransf[nX][3]
						cFilialReal	:= aTransf[nX][8]
					Else
						nX	:= Len(aTransf)
					EndIf						                    
				Next nX  
				cCcDescReal	:= fDesc("CTT",cFilialReal+cCCustoReal,"CTT_DESC01")
			EndIf
		EndIf
		If (cArqTemp)->(DbSeek(cCcDescReal+(cAliasFimAf)->Categoria+(cAliasFimAf)->FimAfast))
			RecLock(cArqTemp,.F.)                           
			Replace (cArqTemp)->FIMAFAST With ((cArqTemp)->FIMAFAST + 1)
			Replace (cArqTemp)->FILIAL   With cFilialReal
			MsUnLock()
		EndIf
		If nTipRel == 1 .Or. nTipRel == 3
			If (cArqFiTp)->(DbSeek(cFilialReal+(cAliasFimAf)->Categoria+(cAliasFimAf)->FimAfast))
				RecLock(cArqFiTp,.F.)                           
				Replace (cArqFiTp)->FIMAFAST With ((cArqFiTp)->FIMAFAST + 1)
				MsUnLock()
			EndIf
		EndIf
		If nTipRel == 2 .Or. nTipRel == 3
			If (cArqEmTp)->(DbSeek((cAliasFimAf)->Categoria+(cAliasFimAf)->FimAfast))
				RecLock(cArqEmTp,.F.)                           
				Replace (cArqEmTp)->FIMAFAST With ((cArqEmTp)->FIMAFAST + 1)
				MsUnLock()
			EndIf
		EndIf
		(cAliasFimAf)->(DbSkip())
	EndDo
End Transaction
                   

	
//Atualiza Eventos do Ponto
Begin Transaction
	DbSelectArea(cArqEven)
	(cArqEven)->(dbSetIndex((cArqEven)+"01"))
	(cArqEven)->(DbSetOrder(1)) 
	DbSelectArea(cAliasEvent)
	(cAliasEvent)->(DbGoTop())
	While (cAliasEvent)->(!EOF())
		If (cArqEven)->(DbSeek((cAliasEvent)->CCusto+(cAliasEvent)->Codigo+(cAliasEvent)->DataMov))
			RecLock(cArqEven,.F.)                           
		Else
			RecLock(cArqEven,.T.)                           
			Replace (cArqEven)->CCUSTO    With (cAliasEvent)->CCusto
			Replace (cArqEven)->CODIGO    With (cAliasEvent)->Codigo
			Replace (cArqEven)->EVENTO    With (cAliasEvent)->Evento
			Replace (cArqEven)->DATAMOV   With (cAliasEvent)->DataMov
			Replace (cArqEven)->FILIAL    With (cAliasEvent)->Filial
			Replace (cArqEven)->CREDITOS  With 0
			Replace (cArqEven)->DEBITOS   With 0
		EndIf
		If (cAliasEvent)->P9_TIPOCOD == "1"
			Replace (cArqEven)->CREDITOS With (cArqEven)->CREDITOS + fConvHr((cAliasEvent)->QuantHrs,"D")
		Else
			Replace (cArqEven)->DEBITOS  With (cArqEven)->DEBITOS  + fConvHr((cAliasEvent)->QuantHrs,"D")
		EndIf
		MsUnLock()
		(cAliasEvent)->(DbSkip())
	EndDo
	If nTipRel == 1 .Or. nTipRel == 3
		DbSelectArea(cArqFiEv)
		(cArqFiEv)->(dbSetIndex((cArqFiEv)+"01"))
		(cArqFiEv)->(DbSetOrder(1)) 
		DbSelectArea(cAlsFiEvent)
		(cAlsFiEvent)->(DbGoTop())
		While (cAlsFiEvent)->(!EOF())
			If (cArqFiEv)->(DbSeek((cAlsFiEvent)->Filial+(cAlsFiEvent)->Codigo+(cAlsFiEvent)->DataMov))
				RecLock(cArqFiEv,.F.)                           
			Else
				RecLock(cArqFiEv,.T.)                           
				Replace (cArqFiEv)->CODIGO    With (cAlsFiEvent)->Codigo
				Replace (cArqFiEv)->EVENTO    With (cAlsFiEvent)->Evento
				Replace (cArqFiEv)->DATAMOV   With (cAlsFiEvent)->DataMov
				Replace (cArqFiEv)->FILIAL    With (cAlsFiEvent)->Filial
				Replace (cArqFiEv)->CREDITOS  With 0
				Replace (cArqFiEv)->DEBITOS   With 0
			EndIf
			If (cAlsFiEvent)->P9_TIPOCOD == "1"
				Replace (cArqFiEv)->CREDITOS With (cArqFiEv)->CREDITOS + fConvHr((cAlsFiEvent)->QuantHrs,"D")
			Else
				Replace (cArqFiEv)->DEBITOS  With (cArqFiEv)->DEBITOS  + fConvHr((cAlsFiEvent)->QuantHrs,"D")
			EndIf
			MsUnLock()
			(cAlsFiEvent)->(DbSkip())
		EndDo
	EndIf
	If nTipRel == 2 .Or. nTipRel == 3
		DbSelectArea(cArqEmEv)
		(cArqEmEv)->(dbSetIndex((cArqEmEv)+"01"))
		(cArqEmEv)->(DbSetOrder(1)) 
		DbSelectArea(cAlsEmEvent)
		(cAlsEmEvent)->(DbGoTop())
		While (cAlsEmEvent)->(!EOF())
			If (cArqEmEv)->(DbSeek((cAlsEmEvent)->Codigo+(cAlsEmEvent)->DataMov))
				RecLock(cArqEmEv,.F.)                           
			Else
				RecLock(cArqEmEv,.T.)                           
				Replace (cArqEmEv)->CODIGO    With (cAlsEmEvent)->Codigo
				Replace (cArqEmEv)->EVENTO    With (cAlsEmEvent)->Evento
				Replace (cArqEmEv)->DATAMOV   With (cAlsEmEvent)->DataMov
				Replace (cArqEmEv)->CREDITOS  With 0
				Replace (cArqEmEv)->DEBITOS   With 0
			EndIf
			If (cAlsEmEvent)->P9_TIPOCOD == "1"
				Replace (cArqEmEv)->CREDITOS With (cArqEmEv)->CREDITOS + fConvHr((cAlsEmEvent)->QuantHrs,"D")
			Else
				Replace (cArqEmEv)->DEBITOS  With (cArqEmEv)->DEBITOS  + fConvHr((cAlsEmEvent)->QuantHrs,"D")
			EndIf
			MsUnLock()
			(cAlsEmEvent)->(DbSkip())
		EndDo
	EndIf
End Transaction

RestArea(aArea)
	
Return Nil

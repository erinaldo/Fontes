#Include "RwMake.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFINA04  º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tela para controle de conferencias.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±± 
±±ºAlteracoes³ OS 2014/17 º Correções e ajustes na função de Conferência   º±±
±±º 		  ³	    		10/07/17 -  Douglas David 		           	   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFina04()

////////////
//DECLARA VARIAVEL
////////////
Local 	aPERGUN	  := {}
Private	cPERGUN	  := PADR("XFIN04",LEN(SX1->X1_GRUPO))
Private	cALIAS	  := ""
Private	aROTINA   := menudef()
Private aBUTTON   := {}
Private cCADASTRO := "Conferencia NF Entrada/Titulos a Pagar"
Private cFILTRO	  := ""


////////////
//PERGUNTAS INICIAIS
////////////
//............01...02.....................03.....................04.....................05.......06..07.08.09.10..11.12.........13.........14.........15.........16.17.18......19......20......21.22.23.24.25.26.27.28.29.30.31.32.33.34.35.36.37.38..39.40.41
AAdd(aPERGUN,{'01','Origem ?            ','Origem ?            ','Origem ?            ','mv_ch1','C',01,00,00,'C','','mv_par01','Nf Entrada','Nf Entrada','Nf Entrada','','','Titulo a Pagar','Titulo a Pagar','Titulo a Pagar','','','','','','','','','','','','','','','','','','S','','',''})
AAdd(aPERGUN,{'02','Status ?            ','Status ?            ','Status ?            ','mv_ch2','C',01,00,00,'C','','mv_par02','A Conferir','A Conferir','A Conferir','','','Conferido','Conferido','Conferido','','','Ambos','Ambos','Ambos','','','','','','','','','','','','','S','','',''})
AAdd(aPERGUN,{'03','Emissao De ?        ','Emissao De ?        ','Emissao De ?        ','mv_ch3','D',08,00,00,'G','','mv_par03','','','','','','','','','','','','','','','','','','','','','','','','','','S','','',''})
AAdd(aPERGUN,{'04','Emissao Ate ?       ','Emissao Ate ?       ','Emissao Ate ?       ','mv_ch4','D',08,00,00,'G','NaoVazio() .And. mv_par04 >= mv_par03','mv_par04','','','','','','','','','','','','','','','','','','','','','','','','','','S','','',''})
AAdd(aPERGUN,{'05','Forncecedor De ?    ','Forncecedor De ?    ','Forncecedor De ?    ','mv_ch5','C',06,00,00,'G','','mv_par05','','','','','','','','','','','','','','','','','','','','','','','','','SA2','S','','',''})
AAdd(aPERGUN,{'06','Forncecedor Ate ?   ','Forncecedor Ate ?   ','Forncecedor Ate ?   ','mv_ch6','C',06,00,00,'G','NaoVazio() .And. mv_par06 >= mv_par05','mv_par06','','','','','','','','','','','','','','','','','','','','','','','','','SA2','S','','',''})
AAdd(aPERGUN,{'07','Vencimento De?      ','Vencimento De?      ','Vencimento De?      ','mv_ch7','D',08,00,00,'G','','mv_par07','','','','','','','','','','','','','','','','','','','','','','','','','','S','','',''})
AAdd(aPERGUN,{'08','Vencimento Ate?     ','Vencimento Ate?     ','Vencomento Ate?     ','mv_ch8','D',08,00,00,'G','NaoVazio() .And. mv_par08 >= mv_par07','mv_par08','','','','','','','','','','','','','','','','','','','','','','','','','','S','','',''})
AAdd(aPERGUN,{'09','Dt. Digitação De?   ','Dt. Digitação De?   ','Dt. Digitação De?   ','mv_ch9','D',08,00,00,'G','','mv_par09','','','','','','','','','','','','','','','','','','','','','','','','','','S','','',''})
AAdd(aPERGUN,{'10','Dt. Digitação Ate?  ','Dt. Digitação Ate?  ','Dt. Digitação Ate?  ','mv_cha','D',08,00,00,'G','NaoVazio() .And. mv_par10 >= mv_par09','mv_par10','','','','','','','','','','','','','','','','','','','','','','','','','','S','','',''})
AAdd(aPERGUN,{'11','Exibe Contabilização?','Exibe Contabilização?','Exibe Contabilização?','mv_chb','C',01,00,02,'C','','mv_par11','Sim','Sim','Sim','','','Não','Não','Não','','','','','','','','','','','','','','','','','','S','','',''})
A91PERGU(cPERGUN,aPERGUN)
If !Pergunte(cPERGUN,.T.)
	Return
EndIf

//////mv_par01 := 2
nPar01 := MV_PAR01
nPar02 := MV_PAR02
xPar03 := MV_PAR03
xPar04 := MV_PAR04
cPar05 := MV_PAR05
//_cPar06 := MV_PAR06
xPar07 := MV_PAR07
xPar08 := MV_PAR08
xPar09 := MV_PAR09
xPar10 := MV_PAR10

////////////

//INICIALIZA VARIAVEL DE FILTRO
////////////
If mv_par01 == 1																//NOTA FISCAL DE ENTRADA
	cALIAS := "SF1"
	cFILTRO += Iif(nPar02==1,"SF1->F1_XLIBNIV <= '1' .And. ",Iif(nPar02==2,"SF1->F1_XLIBNIV > '1' .And. ",""))
	cFILTRO += "SF1->F1_EMISSAO >= xPar03 .And. SF1->F1_EMISSAO <= xPar04 .And. "
	cFILTRO += "SF1->F1_FORNECE >= cPar05 .And. SF1->F1_FORNECE <= mv_par06 .And. "
	cFILTRO += "((SF1->F1_XVENCTO >= xpar07 .And. SF1->F1_XVENCTO <= xpar08) .OR. Empty(SF1->F1_XVENCTO) ) .And. "
	cFILTRO += "SF1->F1_DTDIGIT >= xpar09 .And. SF1->F1_DTDIGIT <= xpar10 .And. "
	cFILTRO += "!(Upper(SF1->F1_STATUS) $ ' /B') .And. !Empty( SF1->F1_DUPL )" // OS 1194/09
	
Else																			//TITULO A PAGAR
	
	cALIAS := "SE2"
	cFILTRO += Iif(mv_par02==1,"SE2->E2_XLIBNIV <= '1' .And. ",Iif(mv_par02==2,"SE2->E2_XLIBNIV > '1' .And. ",""))
	cFILTRO += "SE2->E2_EMISSAO >= mv_par03 .And. SE2->E2_EMISSAO <= mv_par04 .And. "
	cFILTRO += "SE2->E2_FORNECE >= mv_par05 .And. SE2->E2_FORNECE <= mv_par06 .And. "
	
	cFILTRO += "SE2->E2_VENCTO >= mv_par07 .And. SE2->E2_VENCTO <= mv_par08 .And. "
	cFILTRO += "SE2->E2_EMIS1 >= mv_par09 .And. SE2->E2_EMIS1 <= mv_par10 .And. "
	
	cFILTRO += "Upper(AllTrim(SE2->E2_ORIGEM)) <> 'MATA100' .And. Left(SE2->E2_XCONF01,3) <> 'CP:'"
	
EndIf

////////////
//EFETUA CARGA DO ARRAY DOS BOTOES
////////////
/*AAdd(aROTINA,{"&Pesquisar ","AxPesqui",0,1})							 		//BOTAO TELA PRINCIPAL
AAdd(aROTINA,{"&Visualizar","U_A91VISUA",0,2})
AAdd(aROTINA,{"&Legenda"   ,"U_A91LEGEN",0,2})
AAdd(aROTINA,{"&Status"    ,"U_A91STATU",0,2})
AAdd(aROTINA,{"&Rateio"    ,"U_A91RATEI",0,2})
AAdd(aROTINA,{"&Fiscal"    ,"U_A91CONFE",0,2})
//AAdd(aROTINA,{"C&ustos"    ,"U_A91CONFE",0,2})
AAdd(aROTINA,{"Ctas &Pagar","U_A91CONFE",0,2})
AAdd(aROTINA,{"&P.A."      ,"U_A91PA",0,2})
*/
/*
ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
º Sergio em Out/2008: Quando for necessario incluir uma opcao no aRotina º
º                     devera ser incluido ao final e nao intercalado.    º
º                     A construcao deste aRotina leva em conta a posicao º
º                     dos campos no SF1...                               º
ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
*/

////////////
//EXECUTA FILTRO
////////////
DbSelectArea(cALIAS)															//SELECIONA TABELA
DbSetOrder(1)
Set Filter To &cFILTRO
(cAlias)->( DbGoTop() )

////////////
//MONTA TELA PRINCIPAL
////////////
///// mBrowse(,,,,cALIAS,,,,,,U_A91LEGEN(cALIAS))

lInverte := .F.

If Select('MaxMar') <> 0
	dbSelectArea("MaxMar")
	MaxMar->(DbCloseArea())
EndIf

_LEGEN  := {}
aLEGEN	:= {}

AAdd(aLEGEN,{"BR_VERMELHO","Aguardando inicio de conferência."})
AAdd(aLEGEN,{"BR_AMARELO" ,"Conferência em andamento."})
AAdd(aLEGEN,{"BR_AZUL"    ,"Conferência finalizada."})          //Alterado em 19/10/2006 Cesar Moura

if mv_par01 = 1
	cMaxMar := " SELECT MAX(F1_OK) CMAXMARCA FROM "+RetSqlName('SF1')
	cMaxMar += " WHERE D_E_L_E_T_ = ' ' "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cMaxMar),"MaxMar", .F., .T.)
	
	MaxMar->( DbGoTop() )
	
	_cMarca   :=  soma1(MaxMar->CMAXMARCA,2)
	
else
	
	cMaxMar := " SELECT MAX(E2_OK2) CMAXMARCA FROM "+RetSqlName('SE2')
	cMaxMar += " WHERE  D_E_L_E_T_ = ' '  "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cMaxMar),"MaxMar", .F., .T.)
	
	MaxMar->( DbGoTop() )
	
	_cMarca   :=  soma1(MaxMar->CMAXMARCA,2)
	
endif


Aadd(_LEGEN,{Iif(mv_par01==1,"F1","E2") + "_XLIBNIV $ ' /0/1'",aLEGEN[1,1]})
AAdd(_LEGEN,{Iif(mv_par01==1,"F1","E2") + "_XLIBNIV $ ' /0/1'",aLEGEN[2,1]})
AAdd(_LEGEN,{Iif(mv_par01==1,"F1","E2") + "_XLIBNIV $ '2/3'"  ,aLEGEN[3,1]})

///AAdd(_LEGEN,{"E2" + "_XLIBNIV $ ' /0'",aLEGEN[1,1]})
///AAdd(_LEGEN,{"E2" + "_XLIBNIV $ '1'",aLEGEN[2,1]})
///AAdd(_LEGEN,{"E2" + "_XLIBNIV $ '2/3'"  ,aLEGEN[3,1]})


IF MV_PAR01 = 1
	MarkBrow("SF1","F1_OK",.T.,,,_cMarca,,,,,,,,,_LEGEN)
ELSE
	MarkBrow("SE2","E2_OK2",.T.,,,_cMarca,,,,,,,,,_LEGEN)
ENDIF

Set Filter To																	//DESATIVA FILTRO


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A91VISUA º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Visualiza movimento.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A91VISUA()

////////////
//DECLARA VARIAVEIS
////////////
Local aAREATU := GetArea()
Local nModBkp := nModulo

////////////
//EXECUTA ROTINA DE VISUALIZACAO CONFORME ORIGEM
////////////
If mv_par01 == 1																//NOTA FISCAL DE ENTRADA
	nModulo := 2
	A103NFiscal(cALIAS,RecNo(),2)
Else																			//TITULO A PAGAR
	AxVisual(cALIAS,RecNo(),2)
EndIf

nModulo := nModBkp

////////////
//RETORNA AREA ORIGINAL
////////////
RestArea(aAREATU)																//RETORNA AREA ORIGINAL
Pergunte(cPERGUN,.F.)															//RETORNA PERGUNTAS ORIGINAIS

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A91LEGEN º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta tela com as legendas/Define legenda do registro.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A91LEGEN(cALIAS,nRECNO,cOPCAO)

////////////
//DECLARA VARIAVEL
////////////
Local aLEGEN	:= {}
Local uLEGEN	:= .T.

////////////
//EFETUA CARGA DO ARRAY
////////////
AAdd(aLEGEN,{"BR_VERMELHO","Aguardando inicio de conferência."})
AAdd(aLEGEN,{"BR_AMARELO" ,"Conferência em andamento."})
AAdd(aLEGEN,{"BR_AZUL"    ,"Conferência finalizada."})          //Alterado em 19/10/2006 Cesar Moura

////////////
//MONTA LEGENDA
////////////

If nRECNO = Nil
	uLEGEN := {}
	AAdd(uLEGEN,{Iif(mv_par01==1,"F1","E2") + "_XLIBNIV $ ' /0'",aLEGEN[1,1]})
	AAdd(uLEGEN,{Iif(mv_par01==1,"F1","E2") + "_XLIBNIV $ '1'",aLEGEN[2,1]})
	AAdd(uLEGEN,{Iif(mv_par01==1,"F1","E2") + "_XLIBNIV $ '2/3'"  ,aLEGEN[3,1]})
Else
	BrwLegenda(cCADASTRO,OemToAnsi("Legendas"),aLEGEN)
EndIf

Return(uLEGEN)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A91STATU º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta tela com status do registro selecionado.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A91STATU()

////////////
//DECLARA VARIAVEL
////////////
Local oTELA01
Local cTEXTO1 := "Aguardando conferência."
Local cLINHA1 := Iif(mv_par01==1,F1_XCONF01,E2_XCONF01)
//Local cLINHA2 := Iif(mv_par01==1,F1_XCONF02,E2_XCONF02)
Local cLINHA3 := Iif(mv_par01==1,F1_XCONF03,E2_XCONF03)

////////////
//PREPARA LINHAS DE STATUS
////////////
cLINHA1 := Left(cLINHA1,8) + Space(5) + SubStr(cLINHA1,9,8) + Space(5) + UsrFullName(Right(cLINHA1,6))
//cLINHA2 := Left(cLINHA2,8) + Space(5) + SubStr(cLINHA2,9,8) + Space(5) + UsrFullName(Right(cLINHA2,6))
cLINHA3 := Left(cLINHA3,8) + Space(5) + SubStr(cLINHA3,9,8) + Space(5) + UsrFullName(Right(cLINHA3,6))

////////////
//MONTA TELA DE STATUS
////////////
@000,000 To 140,350 Dialog oTELA01 Title "Status"
@008,010 Say "Conferência" + Space(08) + "Data" + Space(13) + "Hora" + Space(10) + "Usuário"
@010,010 Say Replicate("_",52)
@018,010 Say "Fiscal      :"  + Space(10) + Iif(Empty(cLINHA1),cTEXTO1,cLINHA1)
//@028,010 Say "Custos    :"  + Space(10) + Iif(Empty(cLINHA2),cTEXTO1,cLINHA2)
@038,010 Say "Pagtos    :"  + Space(10) + Iif(Empty(cLINHA3),cTEXTO1,cLINHA3)
@041,010 Say Replicate("_",52)
@053,137 BmpButton Type 1 Action Close(oTELA01)
Activate Dialog oTELA01 Centered

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A91RATEI º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Visualiza rateio.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A91RATEI()

////////////
//DECLARA VARIAVEL
////////////
Local oTELA01
Local nVALTIT := 0
Local aAREATU := GetArea()
Local cPERGUN := PADR("XFIN04",LEN(SX1->X1_GRUPO))
Local aStru := SE2->(dbStruct())

////////////
//POSICONA NO TITULO CASO SEJA NOTA FISCAL DE ENTRADA
////////////

_cQuery := " SELECT * "
_cQuery += " FROM "+RetSqlName("SE2")
_cQuery += " WHERE E2_PREFIXO = '"+SF1->F1_PREFIXO+"' AND "
_cQuery += " E2_NUM = '"+SF1->F1_DOC+"' AND "
_cQuery += " E2_FORNECE = '"+SF1->F1_FORNECE+"' AND E2_LOJA = '"+SF1->F1_LOJA+"' AND "
_cQuery += " E2_TIPO = 'NF ' AND E2_ORIGEM = 'MATA100' AND "
_cQuery += " D_E_L_E_T_  <> '*' "

_cQuery := ChangeQuery(_cQuery)

If Select('TRB') <> 0
	dbSelectArea("TRB")
	TRB->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"TRB", .F., .T.)

For nX := 1 To Len(aStru)
	If aStru[nX][2]<>"C"
		TcSetField("TRB",aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX


dbSelectArea("TRB")
dbGotop()

If Eof()
	MsgInfo("O rateio não pode ser visualizado, pois o titulo a pagar não foi localizado.","Atenção")
	Return()
EndIf

////////////
//EXECUTA ROTINA DE RATEIO
////////////
nVALTIT := TRB->(E2_VALOR + E2_ISS + E2_IRRF + E2_INSS + E2_VRETPIS + E2_VRETCOF + E2_VRETCSL)
If TRB->E2_RATESP == "1"
	U_RFINA06(TRB->E2_PREFIXO,TRB->E2_NUM,TRB->E2_PARCELA,TRB->E2_TIPO,TRB->E2_FORNECE,TRB->E2_LOJA,nVALTIT,2)
Else
	Aviso( "Atenção !" , "Esse Titulo a Pagar não possui Rateio " , {"Ok"} , 1 , "Titulo não Rateado" )
Endif

////////////
//RETORNA AREA ORIGINAL
////////////
RestArea(aAREATU)																//RETORNA AREA ORIGINAL
Pergunte(cPERGUN,.F.)															//RETORNA PERGUNTAS ORIGINAIS

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A91PA º Autor ³ Alecsandro Amaro       º Data ³ 17/07/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta tela com status dos PA´s                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A91PA()

////////////
//DECLARA VARIAVEL
////////////
Local oTELA01
Local aAREATU := GetArea()
Local cPERGUN	  := PADR("XFIN04",LEN(SX1->X1_GRUPO))
Local aStru := SE2->(dbStruct())

////////////
//POSICONA NO TITULO CASO SEJA NOTA FISCAL DE ENTRADA
////////////

_cQuery := " SELECT * "
_cQuery += " FROM "+RetSqlName("SE2")
_cQuery += " WHERE E2_PREFIXO = '"+SF1->F1_PREFIXO+"' AND "
_cQuery += " E2_NUM = '"+SF1->F1_DOC+"' AND "
_cQuery += " E2_FORNECE = '"+SF1->F1_FORNECE+"' AND E2_LOJA = '"+SF1->F1_LOJA+"' AND "
_cQuery += " E2_TIPO = 'NF ' AND E2_ORIGEM = 'MATA100' AND "
_cQuery += " D_E_L_E_T_  <> '*' "

_cQuery := ChangeQuery(_cQuery)

If Select('TRC') <> 0
	dbSelectArea("TRC")
	TRC->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"TRC", .F., .T.)

dbSelectArea("TRC")
dbGotop()

If Eof()
	MsgInfo("O titulo a pagar não foi localizado.","Atenção")
	Return()
EndIf

If TRC->E2_TIPOPA == "1"
	Aviso( "Atenção !" , "Informado no momento da entrada da NF." , {"Ok"} , 1 , "Título: " +TRC->E2_NUM+" Possui PA." )
Else
	Aviso( "Atenção !" , "Este Título não possui PA " , {"Ok"} , 1 , "Título: " +TRC->E2_NUM+"." )
EndIf

////////////
//RETORNA AREA ORIGINAL
////////////
RestArea(aAREATU)																//RETORNA AREA ORIGINAL
Pergunte(cPERGUN,.F.)															//RETORNA PERGUNTAS ORIGINAIS

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A91CONFE º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa conferencia do registro selecionado.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A91CONFE(cALIAS,nRECNO,nOPCAO)

////////////
//DECLARA VARIAVEL
////////////
Local cTITULO := "Conferência"
Local cTEXTOS := "Deseja confirma a conferência do movimento?"
Local cCPOINI := IIf(mv_par01==1,"SF1->F1_","SE2->E2_")
/////Local cCPOFIM := IIf(nOPCAO==6,"1","3")
Local cCPOFIM := "3"
Local cData   := DtoS(Date())
Local cSTATUS := ""
Local aAREATU := GetArea()
Local lEXISTE := .F.

Private cArq := 'Conferencia'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log'
Private nHdl := FCreate( '\workflow\'+cArq,1 )
Private cEol := Chr(13)+Chr(10)
Private cOpcao := ""
cData   := Substr(cData,7,2)+"/"+substr(cData,5,2)+"/"+substr(cData,3,2)
cSTATUS := cData + Time() + __cUserID

If nOpcao == 6
	cOpcao := "     "
	nOpcao == 6
ElseIf nOpcao == 8
	cOpcao := "Custos"
ElseIf nOpcao == 7
	cOpcao := "Contas a Pagar"
EndIf

FWrite( nHdl, "Conferencia => "+cOpcao+cEol )

Private lCancel	:= .F.
Private nRazao	:= Iif(lCancel,-1,1)

cRETNIV := ""

////////////
//VERIFICA SE TITULOS ESTAO BAIXADOS OU EM BORDERO
////////////

////////////
//EXIBE TELA DE CONFIRMACAO
////////////
nOPCAOK := Aviso("Conferência NF Entrada/Titulos a Pagar " ,cTEXTOS,{"Ok","Cancelar"},2,cTITULO)

FWrite( nHdl, cTEXTOS+cEol )

If nOPCAOK == 1																	//CASO A TELA SEJA CONFIRMADA
	
    Dbselectarea(cAlias)
	cIndex := criatrab(nil,.f.)
	cChave := indexkey()
	_cFiltro:= IIF(MV_PAR01 = 1, 'F1_OK == "'+_cMarca+'"','E2_OK2 == "'+_cMarca+'"')
	/////	_cFiltro:= 'E2_OK2 == "'+_cMarca+'"'
	indregua(cAlias,cIndex, cChave,,_CFILTRO,"Gerando Registro")
	nIndex := Retindex(cAlias)
	
	While !eof()
	
		cRETSTA := &(cCPOINI + "XCONF0" + cCPOFIM)
		cRETNIV := "3"             /////////////   Soma1(&(cCPOINI + "XLIBNIV"))
		
		////////////
		//AJUSTA VARIAVEIS CASO SEJA CANCELAMENTO E EFETUA BLOQUEIOS CASO NECESSARIO
		////////////
		
		If Substr(cRETSTA,19,4) == substr(__cUserID,1,4) .Or. ( !Empty(Right(cRETSTA,6)) .And. Upper(AllTrim(cUserName)) $ Upper( GetNewPar("MV_X_ADCNF","ADMINISTRADOR") ) ) //CASO SEJA CANCELAMENTO COM USUARIO IGUAL...
			cTITULO := "Cancelamento de " + cTITULO
			cTEXTOS := "Deseja cancelar a conferência do movimento?"
			lCancel := .t.//cRETNIV=="4"
			nRazao	:= Iif(lCancel,-1,1)
			//cRETNIV := AllTrim(Str(Val(cRETNIV)-2))  
			cRETNIV := "1" // OS 2058/16 By Douglas
			cSTATUS := ""
			
		ElseIf !Empty(Right(cRETSTA,6))													//CASO SEJA CANCELAMENTO COM USUARIO DIFERENTE...
			MsgInfo("O cancelamento da conferência do titutlo "+cTitulo+" somente pode executado pelo usuário " + AllTrim(UsrFullName(Right(cRETSTA,6))) + ".","Atenção")
			Dbselectarea(cAlias)
			dbskip()
			///			Return()
		EndIf
		
		
		IF !( EMPTY(ALLTRIM(cStatus)))
			if (&(cCPOINI + "XLIBNIV") > "1"  .and. nOpcao = 6)    /////  Ja validou pelo Fiscal e contas a pagar e foi solicitado a opcao fiscal
				Dbselectarea(cAlias)
				dbskip()
				loop
			endif
			
			if (&(cCPOINI + "XLIBNIV") = " "  .and. nOpcao = 7)    /////  NAO validou pelo Fiscal e chamou a opcao de contas a pagar
				Dbselectarea(cAlias)
				dbskip()
				loop
			endif
		endif
		
		IF mv_par01 == 1
			IF !(SF1->F1_OK == ThisMark())
				
				Dbselectarea(cAlias)
				dBskip()
				loop
				
			endif
		else
			
			IF !(SE2->E2_OK2 == ThisMark())
				
				Dbselectarea(cAlias)
				dBskip()
				loop
			endif
		endif
		
		If mv_par01 == 1                                                                //CASO SEJA DOCUMENTO DE ENTRADA  TIRADO
			cNUMSF1 := xFilial("SF1") + SF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC)
			DbSelectArea("SE2")															//SELECIONA TABELA DE CONTAS A PAGAR
			DbSetOrder(6)																//SELECIONA INDICE
			If DbSeek(cNUMSF1)															//PROCURA TITULO A PAGAR, CASO ENCONTRE...
				Do While cNUMSF1 == SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
					If (SE2->E2_TIPO == "NF" + Space(1)) .And. (SE2->E2_VALLIQ > 0 .Or. !Empty(SE2->E2_NUMBOR))
						lEXISTE := .T.
					EndIf
					SE2->(DbSkip())														//AVANCA PARA PROXIMO REGISTRO
				EndDo
			EndIf
			If lEXISTE				              										//CASO O TITULO POSSUA BAIXA...
				FWrite( nHdl, "A nota fiscal possui titulos baixados/borderô, portanto o cancelamento da conferência não pode ser executado."+cEol )
				Fclose( nHdl )
				MsgInfo("A nota fiscal possui titulos baixados/borderô, portanto o cancelamento da conferência não pode ser executado.","Atenção")
				
				Dbselectarea(cAlias)
				dbskip()
				LOOP
				
				///		Return()
			EndIf
			////		RestArea(aAREATU)
		Else																			//CASO SEJA CONTAS A PAGAR
			
			If SE2->E2_VALLIQ > 0														//CASO O TITULO POSSUA BAIXA...
				MsgInfo("O titulo "+SE2->(E2_PREFIXO+"/"+E2_NUM+"-"+E2_PARCELA)+" possui baixa, portanto o cancelamento da conferência não pode ser executado.","Atenção")
				FWrite( nHdl, "O titulo "+SE2->(E2_PREFIXO+"/"+E2_NUM+"-"+E2_PARCELA)+" possui baixa, portanto o cancelamento da conferência não pode ser executado."+cEol )
				Fclose( nHdl )
				Dbselectarea(cAlias)
				dbskip()
				LOOP
				///		Return()
			ElseIf !Empty(SE2->E2_NUMBOR)												//CASO O TITULO POSSUA BORDERO...
				MsgInfo("O titulo "+SE2->(E2_PREFIXO+"/"+E2_NUM+"-"+E2_PARCELA)+" esta em borderô, portanto o cancelamento da conferência não pode ser executado.","Atenção")
				FWrite( nHdl, "O titulo "+SE2->(E2_PREFIXO+"/"+E2_NUM+"-"+E2_PARCELA)+" esta em borderô, portanto o cancelamento da conferência não pode ser executado."+cEol )
				Fclose( nHdl )
				Dbselectarea(cAlias)
				dbskip()
				LOOP
				////		Return()
			EndIf
		EndIf
		
		////////////
		//ATUALIZA CONFERENCIA
		////////////
		//// Set Filter To																	//DESATIVA FILTRO
		
		FWrite( nHdl, "Opcao confirmada. Inicio da gravacao."+cEol )
		
		Begin Transaction											 				//INICIA TRANSACAO
		
		DbSelectArea(cALIAS)									 					//SELECIONA TABELA
		RecLock(cALIAS,.F.,.T.)								 						//INICIA GRAVACAO DO REGISTRO
				If ALLTRIM(cAlias) == 'SF1'
		/*
		&(cCPOINI + "XLIBNIV") 			:= cRETNIV									//GRAVA NIVEL
		////		&(cCPOINI + "XCONF0" + cCPOFIM)	:= cSTATUS									//GRAVA STATUS
		&(cCPOINI + "XCONF01")	:= cSTATUS									//GRAVA STATUS
		&(cCPOINI + "XCONF03")	:= cSTATUS									//GRAVA STATUS
		*/
		SF1->F1_XLIBNIV := cRETNIV
		SF1->F1_XCONF01 := cSTATUS
		SF1->F1_XCONF03 := cSTATUS
			
		ENDIF
				IF ALLTRIM(cAlias) == 'SE2' //OS 2342/17 - Alexandre Eduardo
		
					SE2->E2_OK2     := "    "
			
					If ALLTRIM(SE2->E2_TIPO) == "PA"
						SE2->E2_XLIBNIV  := cRETNIV
						SE2->E2_XCONF01  := cSTATUS
						SE2->E2_XCONF03  := cSTATUS
					EndIf
                        
				ENDIF
		
		MsUnlock()												  					//FINALIZA GRAVACAO DO REGISTRO
		
		FWrite( nHdl, "Gravando: "+(cCPOINI + "XLIBNIV")+" => "+cRETNIV+cEol )
		FWrite( nHdl, "Gravando: "+(cCPOINI + "XCONF0" + cCPOFIM)+" => "+cSTATUS+cEol )
		
		
		If mv_par01 == 1															//CASO SEJA NOTA FISCAL DE ENTRADA
			cNUMSF1 := xFilial("SE2") + SF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC)
			DbSelectArea("SE2")														//SELECIONA TABELA DE CONTAS A PAGAR
			DbSetOrder(6)															//SELECIONA INDICE
			If DbSeek(cNUMSF1)														//PROCURA TITULO A PAGAR, CASO ENCONTRE...
				Do While SE2->(!Eof()).And.cNUMSF1 == SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
					If SE2->E2_TIPO == "NF" + Space(1)								//VERIFICA SE TIPO E NOTA FISCAL
						RecLock("SE2",.F.)
						SE2->E2_XLIBNIV := cRETNIV
						//					SE2->E2_XCONF01 := "NF:" + cNUMSF1
						////						SE2->&("E2_XCONF0" + cCPOFIM) := "NF:" + cNUMSF1  // Rosana
						//SE2->&("E2_XCONF01") := "NF:" + cNUMSF1
						//SE2->&("E2_XCONF03") := "NF:" + cNUMSF1
						If cRETNIV == "3"
							SE2->E2_XCONF01  :="NF:" + cNUMSF1
							SE2->E2_XCONF03  :="NF:" + cNUMSF1
						Else
							SE2->E2_XCONF01  := cSTATUS
							SE2->E2_XCONF03  := cSTATUS
						Endif
						If !Empty(SE2->E2_DATALIB) .And. Empty(cSTATUS)				//CASO EXISTA LIBERACAO PADRAO E ALGUMA CONFERENCIA SEJA CANCELADA...
							SE2->E2_DATALIB := CtoD("  /  /  ")						//LIMPA DATA DE CONFERENCIA PADRAO
							SE2->E2_USUALIB := SubStr(cUSUARIO,7,15)				//REGISTRA USUARIO
							SE2->E2_OK2     := "    "
						EndIf
						SE2->(MsUnLock())
						U_A91REPLI(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM),cRETNIV,.F.)	//EXECUTA FUNCAO DE REPLICA
						//SE2->(DbSkip())	Excluido por Flavio Novaes em 23/05/07.
					EndIf
					SE2->(DbSkip())	// Incluido por Flavio Novaes em 23/05/07.
				EndDo
			EndIf
			
		Else																		//CASO SEJA CONTAS A PAGAR
			
			If !Empty(SE2->E2_DATALIB) .And. Empty(cSTATUS)						//CASO EXISTA LIBERACAO PADRAO E ALGUMA CONFERENCIA SEJA CANCELADA...
				RecLock("SE2",.F.)
				SE2->E2_DATALIB := CtoD("  /  /  ")									//LIMPA DATA DE CONFERENCIA PADRAO
				SE2->E2_USUALIB := SubStr(cUSUARIO,7,15)							//REGISTRA USUARIO
				SE2->E2_OK2     := "    "
				SE2->(MsUnLock())
			EndIf
			U_A91REPLI(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM),cRETNIV,.F.)				//EXECUTA FUNCAO DE REPLICA
		EndIf
		End Transaction
		
		//	If mv_par01==1 .And. cAlias=="SF1" .And. (SF1->F1_XLIBNIV $ "2/3" .Or. lCancel) // OS 2626/14 By Douglas David
		If mv_par01==1 .And. cAlias=="SF1" .And. (SF1->F1_XCONF01 <> " " .Or. lCancel)
			FWrite( nHdl, "Inicio de atualização do saldo da Provisão!"+cOpcao+cEol )
			// executa atualizacao de saldos de Provisao
			AtuProvis()
		EndIf
		
		////End Transaction 	//Após contabilização da Provisão	//FINALIZA TRANSACAO
		
		/////		EndIf
		
		Dbselectarea(cAlias)
		dbskip()
	Enddo
	
	////	next
	
	
	MarkDes()
	
	If !lCancel		
		MsgInfo("Processo Finalizado!")
	Else
		MsgInfo("Estorno da Conferência, realizado com sucesso!")
	Endif
Endif

If nOPCAOK == 2
	MsgStop("Processo Abortado!")
Endif

DbSelectArea(cALIAS)															//SELECIONA TABELA
Set Filter To &cFILTRO															//REATIVA FILTRO

FWrite( nHdl, "Término de execução."+cOpcao+cEol )

Fclose( nHdl )

__CopyFile('\Workflow\'+cArq,'c:\transfer\'+cArq)

MarkbRefresh()


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A91REPLI º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa replica dos status para movimento de impostos.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A91REPLI(cNUMSE2,cLIBNIV)

////////////
//DECLARA VARIAVEIS
////////////
Local aAREATU := GetArea()
Local aAREAE2 := SE2->(GetArea())
Local aIMPOST := {}
Local cCOMISS := "ISS" + Left(StrTran(GetMV("MV_MUNIC"),'"') + Space(6),6) + "00"
Local cCOMINS := "INS" + Left(StrTran(GetMV("MV_FORINSS"),'"') + Space(6),6) + "00"
Local cCOMIRR := "TX" + Space(1) + Left(StrTran(GetMV("MV_UNIAO"),'"') + Space(6),6) + "00"
Local cChave   := ""
Local cRSocial := ""

Local _cCcCRepl := ""
Local _cCcDRepl := ""
Local _cItDRepl := ""
Local _cCcLRepl := ""
Local _cLaRepl  := ""

Private  lClose 	:= .F.
Private  cPrefixo   := SF1->F1_PREFIXO
Private  cNum		:= SF1->F1_DUPL
Private  cEspecie   := SF1->F1_ESPECIE
Private  cParcela	:= SuperGetMV("MV_1DUP")
Private  cTipo	    := MVNOTAFIS
Private  cFornece	:= SF1->F1_FORNECE
Private  cLoja	    := SF1->F1_LOJA
Private  cRazao     := Alltrim( Posicione( "SA2" , 1 , xFilial("SA2") + cFornece + cLoja ,"A2_NOME" ) )
Private  cContFor   := Posicione("SA2", 1 , xFilial("SA2") + cFornece + cLoja , "A2_CONTA" )
Private  dEmissao   := SF1->F1_EMISSAO
Private  cHist      := Space(Len(SF1->F1_DADADIC))
Private  cPict      := PesqPict("SE2" , "E2_VALOR" , 19 )
Private  nDescCsu   := 0
Private  nMultCsu   := 0

Private	 aButton    := {}
Private  nReg 	    := 0
Private  nOpcE 	    := 4
Private  nOpcG 	    := 3
Private  ni 	    := 0
Private  cUniao     := GETMV("MV_UNIAO")
Private  cCofins    := GETMV("MV_COFINS")
Private  cPis       := GETMV("MV_PISNAT")
Private  cCSLL      := GETMV("MV_CSLL")
Private  cIrrf      := Substr( GetMv("MV_IRF")  , 2 , 9 )
Private  cAliasEnchoice := "SE2"
Private  cAliasGetd     := "SE2"
Private  cLinOk         := ""
Private  cTudOk         := ""
Private  cFieldOk       := "AllwaysTrue()"
Private  nOpca          := 0
Private _lTemPa		:= .F.
Private  cQuery 	:= ""


////////////
//EFETUA CARGA DO ARRAY
////////////
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCIR  + cCOMIRR,SE2->E2_IRRF  })
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCISS + cCOMISS,SE2->E2_ISS   })
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCINS + cCOMINS,SE2->E2_INSS  })
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCCOF + cCOMIRR,SE2->E2_COFINS})
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCPIS + cCOMIRR,SE2->E2_PIS   })
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCSLL + cCOMIRR,SE2->E2_CSLL  })


//-- Salva informações do título principal para utilização na replica
_cCcCRepl := SE2->E2_CCUSTO
_cCcDRepl := SE2->E2_CCD
_cItDRepl := SE2->E2_ITEMD
_cCcLRepl := SE2->E2_CLVLDB
_cLaRepl  := SE2->E2_LA

////////////
//EXECUTA GRAVACAO DO CAMPO DE CONTROLE PARA MOVIMENTOS RELACIONADOS
////////////
DbSelectArea("SE2")
DbSetOrder(1)
For nI := 1 To Len(aIMPOST)
	If aIMPOST[nI,2] > 0 .And. DbSeek(aIMPOST[nI,1])							//CASO LOCALIZE O MOVIMENTO RELACIONADO...
		RecLock("SE2",.F.)
		SE2->E2_XLIBNIV := cLIBNIV
		SE2->E2_XCONF01 := "CP:" + cNUMSE2
		SE2->(MsUnLock())
	EndIf
Next

// Replica OS 1334/13

If Upper( AllTrim(SE2->E2_CCUSTO) ) == "" .And. Upper( AllTrim(SE2->E2_ITEMD) ) == "" .And. Upper( AllTrim(SE2->E2_CLVLDB) ) == ""
	
	////////////
	//EXECUTA GRAVACAO DO CAMPO DE CONTROLE PARA MOVIMENTOS RELACIONADOS
	////////////
	DbSelectArea("SE2")
	DbSetOrder(1)
	For nI := 1 To Len(aIMPOST)
		If aIMPOST[nI,2] > 0 .And. DbSeek(aIMPOST[nI,1])							//CASO LOCALIZE O MOVIMENTO RELACIONADO...
			RecLock("SE2",.F.)
			
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³                  Atualiza o Historico do Titulo a Pagar                    ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			cChave   :=  SE2->E2_TIPO   + " / " + SE2->E2_NUM + " - " + cRSocial
			cRSocial := cRazao
			
			
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³                  Calcula o Historico dependendo do Tipo                    ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			If SE2->E2_TIPO == "INS"
				cHist := "INSS - " + cChave
			ElseIf SE2->E2_TIPO == "ISS"
				cHist := "ISS - "  + cChave
			ElseIf SE2->E2_TIPO == "TX " .And. Alltrim(SE2->E2_FORNECE) == cUniao
				
				If Alltrim(SE2->E2_NATUREZ) == Alltrim(cIrrf)
					cHist    := "IRRF - " + cChave
				ElseIf Alltrim(SE2->E2_NATUREZ) == cCofins
					cHist    := "LEI 10.833 - Cofins - "  + cChave
				ElseIf Alltrim(SE2->E2_NATUREZ) == cPis
					cHist    := "LEI 10.833 - Pis - "  + cChave
				ElseIf  Alltrim(SE2->E2_NATUREZ) == cCsll
					cHist    := "LEI 10.833 - Csll - "  + cChave
				Endif
				
			Endif
			
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³              Grava os Dados Complementares nos Titulos a Pagar             ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			
			Reclock("SE2" , .F. )
			SE2->E2_HIST   := cHist
			SE2->E2_NOMFOR := Posicione("SA2", 1 , xFilial("SA2") + cFornece + cLoja , "A2_NREDUZ" )
			SE2->E2_CCUSTO := _cCcCRepl
			SE2->E2_CCD    := _cCcDRepl
			SE2->E2_ITEMD  := _cItDRepl
			SE2->E2_CLVLDB := _cCcLRepl
			SE2->E2_LA     := _cLaRepl
			SE2->E2_RSOCIAL:= cRSocial
			SE2->E2_CSUKEY := SE2->E2_FILIAL + cPrefixo + cNum + cParcela + cTipo + cFornece + cLoja
			
			SE2->(MsUnLock())
		EndIf
	Next
EndIf

////////////
//RETORNA AREA ORIGINAL
////////////
RestArea(aAREAE2)
RestArea(aAREATU)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A91PERGU º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria grupo de pergunta se necessario.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU								                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A91PERGU(cPERGUN,aPERGUN)

////////////
//DECLARA VARIAVEIS
////////////
Local nX      := 0
Local nY      := 0
Local aAREATU := GetArea()
Local aAREASX := SX1->(GetArea())
Local aCPOPER := {}

////////////
//MONTA ARRAY COM CAMPOS DA PERGUNTA
////////////
AAdd(aCPOPER,'X1_ORDEM'  ) //01
AAdd(aCPOPER,'X1_PERGUNT') //02
AAdd(aCPOPER,'X1_PERSPA' ) //03
AAdd(aCPOPER,'X1_PERENG' ) //04
AAdd(aCPOPER,'X1_VARIAVL') //05
AAdd(aCPOPER,'X1_TIPO'   ) //06
AAdd(aCPOPER,'X1_TAMANHO') //07
AAdd(aCPOPER,'X1_DECIMAL') //08
AAdd(aCPOPER,'X1_PRESEL' ) //09
AAdd(aCPOPER,'X1_GSC'    ) //10
AAdd(aCPOPER,'X1_VALID'  ) //11
AAdd(aCPOPER,'X1_VAR01'  ) //12
AAdd(aCPOPER,'X1_DEF01'  ) //13
AAdd(aCPOPER,'X1_DEFSPA1') //14
AAdd(aCPOPER,'X1_DEFENG1') //15
AAdd(aCPOPER,'X1_CNT01'  ) //16
AAdd(aCPOPER,'X1_VAR02'  ) //17
AAdd(aCPOPER,'X1_DEF02'  ) //18
AAdd(aCPOPER,'X1_DEFSPA2') //19
AAdd(aCPOPER,'X1_DEFENG2') //20
AAdd(aCPOPER,'X1_CNT02'  ) //21
AAdd(aCPOPER,'X1_VAR03'  ) //22
AAdd(aCPOPER,'X1_DEF03'  ) //23
AAdd(aCPOPER,'X1_DEFSPA3') //24
AAdd(aCPOPER,'X1_DEFENG3') //25
AAdd(aCPOPER,'X1_CNT03'  ) //26
AAdd(aCPOPER,'X1_VAR04'  ) //27
AAdd(aCPOPER,'X1_DEF04'  ) //28
AAdd(aCPOPER,'X1_DEFSPA4') //29
AAdd(aCPOPER,'X1_DEFENG4') //30
AAdd(aCPOPER,'X1_CNT04'  ) //31
AAdd(aCPOPER,'X1_VAR05'  ) //32
AAdd(aCPOPER,'X1_DEF05'  ) //33
AAdd(aCPOPER,'X1_DEFSPA5') //34
AAdd(aCPOPER,'X1_DEFENG5') //35
AAdd(aCPOPER,'X1_CNT05'  ) //36
AAdd(aCPOPER,'X1_F3'     ) //37
AAdd(aCPOPER,'X1_PYME'   ) //38
AAdd(aCPOPER,'X1_GRPSXG' ) //39
AAdd(aCPOPER,'X1_HELP'   ) //40
AAdd(aCPOPER,'X1_PICTURE') //41

////////////
//EXECUTA ATUALIZACAO CASO NECESSARIO
////////////
DbSelectArea("SX1")
DbSetOrder(1)
For nX := 1 To Len(aPERGUN)
	If !DbSeek(cPERGUN + aPERGUN[nX][1])
		RecLock("SX1",.T.)
		For nY := 1 To Len(aCPOPER)
			SX1->(&(aCPOPER[nY])) := aPERGUN[nX][nY]
		Next
		SX1->X1_GRUPO := cPERGUN
		SX1->(MsUnlock())
	EndIf
Next

////////////
//RETORNA AREA ORIGINAL
////////////
RestArea(aAREASX)
RestArea(aAREATU)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuProvisº Autor ³ Daniel G.Jr.TI1239  º Data ³ 17/10/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza saldos de Provisao                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU								                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuProvis()

////////////
//VARIAVEIS UTILIZADAS NA CONTABILIZAÇÃO DO ESTORNO DA PROVISAO
////////////
Local nHdlPrv
Local cArquivo	:= ""
Local cPadrao	:= "230"
Local lPadrao230:= .F.
Local lPadrao235:= .F.
Local lPadrao240:= .F.
Local lPadrao245:= .F.
Local nValor 	:= 0
Local nTotal	:= 0
Local nValLcto  := 0
Local cPedProv	:= ""
Local cNroProv	:= ""
Local cNomUsu 	:= UsrFullName(__CUserID)
Local cOrigem 	:= "CONFERENCIA DOCTOS."
Local dData		:= DDATABASE
Local cHistor 	:= Iif(lCancel,"CANCELAMENTO DA CONFERENCIA","FINALIZACAO DA CONFERENCIA")
Local cTipo		:= Iif(lCancel,"1","2")
Local cProvis	:= ""
Local _FilialPr := SF1->F1_FILIAL
Private lFirst	:= .T.
Private nRazao	:= Iif( Type('lCancel') # 'U'.And.lCancel ,-1,1 )

cQuery := "SELECT DISTINCT ZB2_PROVIS PROVIS, ZB2_PEDCOM PEDIDO, "
cQuery +=        "D1_FORNECE FORNECE, D1_LOJA LOJA "
cQuery +=   "FROM "
cQuery +=    RetSqlName("ZB2")+" XZB2, "
cQuery +=    RetSqlName("SD1")+" XSD1 "
cQuery +=  "WHERE "
cQuery +=        "XZB2.D_E_L_E_T_<>'*' AND ZB2_FILIAL='"+xFilial("ZB2")+"' "
cQuery +=    "AND XSD1.D_E_L_E_T_<>'*' AND  D1_FILIAL='"+_FilialPr+"' "
cQuery +=    "AND RTRIM(D1_DOC)+D1_FORNECE+D1_LOJA='"+SF1->(ALLTRIM(F1_DOC)+F1_FORNECE+F1_LOJA)+"' "
cQuery +=    "AND ZB2_PEDCOM+ZB2_FORNEC+ZB2_LOJA=D1_PEDIDO+D1_FORNECE+D1_LOJA "
cQuery +=    "AND Round("+Iif(lCancel,"ZB2_SLDEST","ZB2_SALDO")+",2)>0 "
cQuery += "ORDER BY PROVIS, PEDIDO, FORNECE, LOJA "
cQuery := ChangeQuery(cQuery)
//MemoWrite("C:\RFINA04a.sql",cQuery)

// verifica se o alias esta aberto e o fecha
If Select("AUXI")>0
	AUXI->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AUXI",.F.,.T.)
dbSelectArea("AUXI")
AUXI->(dbGoTop())

cPedProv := ""
cNroProv := ""
While AUXI->(!Eof().And.!Bof())		// se houver saldo
	cPedProv += If(Empty(cPedProv),"('",",'")+AUXI->(PEDIDO+FORNECE+LOJA)+"'"
	cNroProv += If(Empty(cNroProv),"('",",'")+AUXI->PROVIS+"'"
	AUXI->(dbSkip())
End
cPedProv += Iif(Empty(cPedProv),"",")")
cNroProv += Iif(Empty(cNroProv),"",")")

If !Empty(cPedProv)
	
	lPadrao230 := VerPadrao("230")
	lPadrao235 := VerPadrao("235")
	lPadrao240 := VerPadrao("240")
	lPadrao245 := VerPadrao("245")
	
	If !lCancel .And. (!lPadrao230 .Or. !lPadrao235)
		cMsg:="Lançamento Padrão 230 e/ou 235 não está(ão) configurado(s)! Falar com a Contabilidade!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		FWrite( nHdl, "Lançamento Padrão 230 e/ou 235 não está(ão) configurado(s)! Falar com a Contabilidade!"+cOpcao+cEol )
		Return()
	EndIf
	
	If lCancel .And. (!lPadrao240 .Or. !lPadrao245)
		cMsg:="Lançamento Padrão 240 e/ou 245 não está(ão) configurado(s)! Falar com a Contabilidade!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		FWrite( nHdl, "Lançamento Padrão 240 e/ou 245 não está(ão) configurado(s)! Falar com a Contabilidade!"+cOpcao+cEol )
		Return()
	EndIf
	
	cQuery := "SELECT D1_PEDIDO NUMPED, SUM(ROUND(D1_TOTAL,2)) TOTAL "
	cQuery +=   "FROM "
	cQuery +=    RetSqlName("SD1")+" SD1, "
	cQuery +=	 RetSqlName("ZB1")+" ZB1, "
	cQuery +=	 RetSqlName("ZB2")+" ZB2 "
	cQuery +=  "WHERE SD1.D_E_L_E_T_<>'*' AND D1_FILIAL='"+_FilialPr+"' "
	cQuery +=    "AND ZB1.D_E_L_E_T_<>'*' AND ZB1_FILIAL='"+xFilial("ZB1")+"' "
	cQuery +=    "AND ZB2.D_E_L_E_T_<>'*' AND ZB2_FILIAL='"+xFilial("ZB2")+"' "
	cQuery +=    "AND D1_PEDIDO+D1_FORNECE+D1_LOJA IN "+cPedProv+" "
	cQuery +=    "AND D1_DOC='"+SF1->F1_DOC+"' "
	cQuery +=	 "AND ZB2_PEDCOM+ZB2_FORNEC+ZB2_LOJA=D1_PEDIDO+D1_FORNECE+D1_LOJA "
	cQuery +=    "AND ZB2_PROVIS IN "+cNroProv+" "
	cQuery +=	 "AND ZB1_PROVIS=ZB2_PROVIS "
	cQuery += "GROUP BY D1_PEDIDO "
	cQuery += "ORDER BY D1_PEDIDO "
	cQuery := ChangeQuery(cQuery)
	//	MemoWrite("C:\RFINA04b.sql",cQuery)
	
	// verifica se o alias esta aberto e o fecha
	If Select("AUX2")>0
		AUX2->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AUX2",.F.,.T.)
	TcSetField("AUX2","TOTAL","N",14,2)
	
	AUX2->(dbGoTop())
	
	While AUX2->(!Eof())
		
		nValLcto := Round(AUX2->TOTAL,2)
		nSldDig  := nValLcto
		nValPC	 := 0
		
		// verifica saldo de provisao do pedido
		cQuery := "SELECT Sum(Round("+Iif(lCancel,"ZB2_SLDEST","ZB2_SALDO")+",2)) ZSALDO "
		cQuery +=   "FROM "
		cQuery +=    RetSqlName("ZB2")+" ZB2 "
		cQuery +=  "WHERE ZB2.D_E_L_E_T_<>'*' AND ZB2_FILIAL='"+xFilial("ZB2")+"' "
		cQuery +=    "AND ZB2_PEDCOM+ZB2_FORNEC+ZB2_LOJA='"+AUX2->NUMPED+SF1->(F1_FORNECE+F1_LOJA)+"' "
		cQuery +=    "AND ZB2_PROVIS IN "+cNroProv+" "
		cQuery := ChangeQuery(cQuery)
		If Select("AUX3")>0
			AUX3->(dbCloseArea())
		EndIf
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AUX3",.F.,.T.)
		TcSetField("AUX3","ZSALDO","N",14,2)
		nSaldoPC := Iif(AUX3->(!Eof().And.!Bof()),AUX3->ZSALDO,0)
		AUX3->(dbCloseArea())
		
		If nSaldoPC>0
			FWrite( nHdl, "Saldo da Provisão, maior que zero!"+cOpcao+cEol)
			
			lSldMaior := nSaldoPc> nValLcto
			lSldMenor := nSaldoPc<=nValLcto
			nSldRazao := Iif( lSldMaior, 1, Round((nSaldoPc/nValLcto-1)*0.01,4) )
			
			cQuery := "SELECT Round("+Iif(lCancel,"ZB2_SLDEST","ZB2_SALDO")+",2) SALDOZ, ZB2_PROVIS PROVIS, "
			cQuery +=        "ZB2.R_E_C_N_O_ ZB2REC, ZB1.R_E_C_N_O_ ZB1REC, SA2.R_E_C_N_O_ SA2REC "
			cQuery +=   "FROM "
			cQuery +=    RetSqlName("ZB1")+" ZB1, "
			cQuery +=    RetSqlName("ZB2")+" ZB2, "
			cQuery +=    RetSqlName("SA2")+" SA2 "
			cQuery +=  "WHERE ZB2.D_E_L_E_T_<>'*' AND ZB2_FILIAL='"+xFilial("ZB2")+"' "
			cQuery +=    "AND ZB1.D_E_L_E_T_<>'*' AND ZB1_FILIAL='"+xFilial("ZB1")+"' "
			cQuery +=    "AND SA2.D_E_L_E_T_<>'*' AND  A2_FILIAL='"+xFilial("SA2")+"' "
			cQuery +=    "AND ZB2_PEDCOM+ZB2_FORNEC+ZB2_LOJA='"+AUX2->NUMPED+SF1->(F1_FORNECE+F1_LOJA)+"' "
			cQuery +=	 "AND ZB2_PROVIS IN "+cNroProv+" "
			cQuery +=    "AND Round("+Iif(lCancel,"ZB2_SLDEST","ZB2_SALDO")+",2)>0 "
			cQuery +=    "AND A2_COD=ZB2_FORNEC AND A2_LOJA=ZB2_LOJA "
			cQuery +=    "AND ZB1_PROVIS=ZB2_PROVIS "
			cQuery += "ORDER BY ZB2_PROVIS "
			cQuery := ChangeQuery(cQuery)
			
			// verifica se o alias esta aberto e o fecha
			If Select("AUX3")>0
				AUX3->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AUX3",.F.,.T.)
			TcSetField("AUX3","SALDOZ","N",14,2)
			AUX3->(dbGoTop())
			
			SA2->(dbGoTo(AUX3->SA2REC))
			cProvAnt:= AUX3->PROVIS
			
			While AUX3->(!Eof()) .And. nSldDig>0
				
				nRecZB1 := AUX3->ZB1REC
				ZB2->(dbGoTo(AUX3->ZB2REC))
				RecLock("ZB2",.F.)
				
				
				If lSldMenor
					nValor := AUX3->SALDOZ
					ZB2->ZB2_VLESTO :=   nValor
					ZB2->ZB2_SLDEST += Round( nValor * nRazao , 2 )
					ZB2->ZB2_SALDO  -= Round( nValor * nRazao , 2 )
					FWrite( nHdl, "Atualizando saldo a menor!"+cOpcao+cEol)
				Else
					nValor := Round(AUX3->SALDOZ * nSldRazao , 2 )
					ZB2->ZB2_VLESTO :=   nValor
					ZB2->ZB2_SLDEST += Round( nValor * nRazao , 2 )
					ZB2->ZB2_SALDO  -= Round( nValor * nRazao , 2 )
					If lCancel.And.((ZB2->ZB2_SLDEST>0.00.And.ZB2->ZB2_SLDEST<1.00).Or.ZB2_SLDEST<0.00)
						ZB2->ZB2_SLDEST	:= 0
						ZB2->ZB2_SALDO	:= ZB2_VALOR
					ElseIf !lCancel.And.((ZB2->ZB2_SALDO>0.00.And.ZB2->ZB2_SALDO<1.00).Or.ZB2_SALDO<0.00)
						ZB2->ZB2_SALDO:=0
						ZB2->ZB2_SLDEST:=ZB2_VALOR
					EndIf
				EndIf
				nSldDig -= nValor
				nValPC	+= nValor
				ZB2->(MsUnLock())
				ZB1->(dbGoTo(nRecZB1))
				
				If lFirst
					cLote    := Iif(lCancel,"090030","090040")	//LoteCont('COM')
					cRotina  := "RFINA04"
					nHdlPrv  := HeadProva(cLote,cRotina,Substr(cUsuario,7,6),@cArquivo)
					cPadrao	 := Iif(lCancel,"240","230")
					lFirst	 := .F.
					cProvis	 := ZB2->ZB2_PROVIS
				EndIf
				
				nTotal 	 += DetProva(nHdlPrv,cPadrao,cRotina,cLote)
				
				AUX3->(dbSkip())
				
				If cProvAnt!=AUX3->PROVIS .Or. AUX3->(Eof()) .Or. nSldDig<=0
					ZB1->(dbGoTo(nRecZB1))
					RecLock("ZB1",.F.)
					FWrite( nHdl, "Atualizando Tabela ZB1!"+cOpcao+cEol)
					ZB1->ZB1_VLESTO :=   nValPC
					ZB1->ZB1_SLDEST += Round( nValPC * nRazao , 2 )
					ZB1->ZB1_SALDO  -= Round( nValPC * nRazao , 2 )
					If ZB1->ZB1_SALDO<1.00
						ZB1->ZB1_SALDO:=0
						ZB1->ZB1_SLDEST:=ZB1_VALDOC
					EndIf
					If lCancel.And.((ZB1->ZB1_SLDEST>0.00.And.ZB1->ZB1_SLDEST<1.00).Or.ZB1_SLDEST<0.00)
						ZB1->ZB1_SLDEST	:= 0
						ZB1->ZB1_SALDO	:= ZB1_VALDOC
					ElseIf !lCancel.And.((ZB1->ZB1_SALDO>0.00.And.ZB1->ZB1_SALDO<1.00).Or.ZB1_SALDO<0.00)
						ZB1->ZB1_SALDO:=0
						ZB1->ZB1_SLDEST:=ZB1_VALDOC
					EndIf
					ZB1->ZB1_DTESTO := Iif(ZB1->ZB1_SLDEST==0,CtoD(" "),SF1->F1_DTDIGIT)
					ZB1->(MsUnLock())
					nTotal 	 += DetProva(nHdlPrv,Iif(lCancel,"245","235"),cRotina,cLote)
					nValPC   := 0
				EndIf
				
			End
			If Select("AUX3")>0
				AUX3->(dbCloseArea())
			EndIf
			
		EndIf
		
		AUX2->(dbSkip())
		
	End
	
	If Select("AUX2")>0
		AUX2->(dbCloseArea())
	EndIf
	
	If Select("AUXI")>0
		AUXI->(dbCloseArea())
	EndIf
	
	If !lFirst
		RodaProva(nHdlPrv,nTotal)
		cA100Incl(cArquivo,nHdlPrv,3,cLote,Iif(mv_par11==1,.T.,.F.),.F.,,SF1->F1_DTDIGIT)
		
		// Gravação da ocorrência da Provisao
		lOcor := U_GrvOcorPrv(cProvis,cTipo,dData,nTotal,cOrigem,cHistor,cNomUsu)
		FWrite( nHdl, "Gravação da ocorrência da Provisao - Tabela ZB3"+cOpcao+cEol)
		
	EndIf
	
Else
	
	If Select("AUXI")>0
		AUXI->(dbCloseArea())
	EndIf
	
EndIf
FWrite( nHdl, "Provisão estornada com sucesso!"+cOpcao+cEol )

RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDEF  º Autor ³Eduardo de Souza    º Data ³12/Jan/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Implementa menu funcional                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menus                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//³    3 - Duplica o registro corrente do Banco de Dados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MenuDef()
Local aRotina :=	{{ "Pesquisar", "AxPesqui" , 0, 1},;		//"Pesquisar"
{"&Visualizar","U_A91VISUA",0,2},; 		//"Visualizar"
{"&Legenda"   ,"U_A91LEGEN",0,2},; 	//"Incluir"
{"&Status"    ,"U_A91STATU",0,2},; 	//"Alterar"
{"&Rateio"    ,"U_A91RATEI",0,2},;	//"Excluir"
{"&Conferir",  "U_A91CONFE",0,2},;	//"Excluir"
{"&P.A."      ,"U_A91PA",0,2}}		//"Duplicar"

////{"&Fiscal"    ,"U_A91CONFE",0,2},;	//"Excluir"

Return aRotina

////////////   FUNCAO DESMARCAR FLAG


Static Function MarkDes()

IF mv_par01 == 1
	
	DbSelectArea('SF1')
	Procregua(1)
	
	IncProc('Limpando  Selecao...')
	
	Dbselectarea("SF1")
	Dbgotop()
	While !Eof()
		
		RecLock('SF1',.f.)
		SF1->F1_OK := '  '
		MsUnLock()
		
		DbSkip()
	EndDo
ELSE
	
	DbSelectArea('SE2')
	Procregua(1)
	
	IncProc('Limpando  Selecao...')
	
	Dbselectarea("SE2")
	Dbgotop()
	While !Eof()
		
		if empty(alltrim(SE2->E2_OK2)		)
			RecLock('SE2',.f.)
			SE2->E2_OK2 := '  '
			MsUnLock()
		endif
		
		DbSkip()
	EndDo
	
	
EndIf

Return

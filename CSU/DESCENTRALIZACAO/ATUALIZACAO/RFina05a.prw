#Include "RwMake.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ RFINA05A  º Autor ³ Eduardo Dias       º Data ³ 13/03/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao³Tela para controle de conferencias para processamento OffLine º±±
±±º          OS 3770/15                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFina05a()

////////////
//DECLARA VARIAVEL
////////////
Local aPERGUN	  := {} 
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

AtuProvis()

Return


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
User Function ContProv1()

////////////
//VARIAVEIS UTILIZADAS NA CONTABILIZAÇÃO DO ESTORNO DA PROVISAO
////////////
Local nHdlPrv
Local aArea		  := GetArea()
Local aAreaZB1    := ZB1->(GetArea())
Local aAreaZB2    := ZB2->(GetArea())
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
Local cTITULO := "Conferência Off-Line"
Local cOrigem 	:= "CONFERENCIA DOCTOS."
Local cTEXTOS	:= "Deseja confirma a conferência do movimento Off-Line?"
Local dData		:= DDATABASE
Local cHistor 	:= Iif(lCancel,"CANCELAMENTO DA CONFERENCIA","FINALIZACAO DA CONFERENCIA")
Local cTipo		:= Iif(lCancel,"1","2")
Local cProvis	:= ""
//Local _FilialPr := SF1->F1_FILIAL
Private lFirst	:= .T.
Private nRazao	:= Iif( Type('lCancel') # 'U'.And.lCancel ,-1,1 ) 
Private cArq := 'Conferencia_OffLine'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log'
Private nHdl := FCreate( '\workflow\'+cArq,1 )
Private cEol := Chr(13)+Chr(10)
Private cOpcao := ""

FWrite( nHdl, "Processamento Off-Line => "+cOpcao+cEol )
                    
////////////
//EXIBE TELA DE CONFIRMACAO
////////////
nOPCAOK := Aviso("Conferência " + "3",cTEXTOS,{"Ok","Cancelar"},2,cTITULO)

FWrite( nHdl, cTEXTOS+cEol )

If nOPCAOK == 1																	//CASO A TELA SEJA CONFIRMADA
	
	
	// posiciona ZB2
	nProviZB2 := POSICIONE("ZB2",2,xFilial("ZB2")+ZB1->ZB1_FORNEC+ZB1->ZB1_LOJA+ZB1->ZB1_COMPET, "ZB2_PROVIS")    //ZB2_FILIAL+ZB2_FORNEC+ZB2_LOJA+ZB2_COMPET
	
	//Dados SD1
	cNumNF := POSICIONE("SD1", 13, xFilial("SD1")+ZB2->ZB2_FORNEC+ZB2->ZB2_LOJA+ZB2->ZB2_PEDCOM,"D1_DOC") //D1_FILIAL+D1_FORNECE+D1_LOJA+D1_PEDIDO
	cSerieNF := POSICIONE("SD1", 13, xFilial("SD1")+ZB2->ZB2_FORNEC+ZB2->ZB2_LOJA+ZB2->ZB2_PEDCOM,"D1_SERIE") //D1_FILIAL+D1_FORNECE+D1_LOJA+D1_PEDIDO
	
	//Dados SF1
	cFornec := POSICIONE("SF1",1, xFilial("SF1")+cNumNF+cSerieNF+ZB2->ZB2_FORNEC+ZB2->ZB2_LOJA,"F1_FORNECE") //DOC+SERIRE+FORNECEDOR+LOJA
	cLoja := POSICIONE("SF1",1, xFilial("SF1")+cNumNF+cSerieNF+ZB2->ZB2_FORNEC+ZB2->ZB2_LOJA,"F1_LOJA") //DOC+SERIRE+FORNECEDOR+LOJA
	cfilial := POSICIONE("SF1",1, xFilial("SF1")+cNumNF+cSerieNF+ZB2->ZB2_FORNEC+ZB2->ZB2_LOJA,"F1_FILIAL") //DOC+SERIRE+FORNECEDOR+LOJA
	
	cQuery := "SELECT DISTINCT ZB2_PROVIS PROVIS, ZB2_PEDCOM PEDIDO, "
	cQuery +=        "D1_FORNECE FORNECE, D1_LOJA LOJA "
	cQuery +=   "FROM "
	cQuery +=    RetSqlName("ZB2")+" XZB2, "
	cQuery +=    RetSqlName("SD1")+" XSD1 "
	cQuery +=  "WHERE "
	cQuery +=        "XZB2.D_E_L_E_T_<>'*' AND ZB2_FILIAL='"+xFilial("ZB2")+"' "
	cQuery +=    "AND XSD1.D_E_L_E_T_<>'*' AND  D1_FILIAL='"+cfilial+"' "
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
		cQuery +=  "WHERE SD1.D_E_L_E_T_<>'*' AND D1_FILIAL='"+cfilial+"' "
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
					
					ZB2->ZB2_CONFER := ""
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
						ZB1->ZB1_CONFER := ""
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
		
		/*
		If !lFirst
			RodaProva(nHdlPrv,nTotal)
			cA100Incl(cArquivo,nHdlPrv,3,cLote,Iif(mv_par11==1,.T.,.F.),.F.,,SF1->F1_DTDIGIT)
			
			// Gravação da ocorrência da Provisao
			lOcor := U_GrvOcorPrv(cProvis,cTipo,dData,nTotal,cOrigem,cHistor,cNomUsu)
			FWrite( nHdl, "Gravação da ocorrência da Provisao - Tabela ZB3"+cOpcao+cEol)
			
		EndIf
		*/
	Else
		
		If Select("AUXI")>0
			AUXI->(dbCloseArea())
		EndIf
		
	EndIf
	FWrite( nHdl, "Provisão estornada com sucesso!"+cOpcao+cEol )
EndIf
	
RestArea(aArea)                                     
RestArea(aAreaZB1)
RestArea(aAreaZB2)


RETURN

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

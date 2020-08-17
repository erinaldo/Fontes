#INCLUDE "PROTHEUS.CH"
#DEFINE CRLF Chr(13)+Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ GFINR01  ∫ Autor ≥ Carlos A. Queiroz  ∫ Data ≥  14/06/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Relatorio de Fluxo de Caixa - GJP                          ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GJP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function GFINR01()

Local aArea:=GetArea()
Local cQuery, cAno
Local aAno:={}
Private oDlg  
/*                    
cQuery :="SELECT DISTINCT Substring(PC0_ANOMES, 1,4) AS ANO "
cQuery +="FROM  " +RetSqlName("PC0")+ " PC0 "
cQuery +="WHERE PC0.D_E_L_E_T_ <> '*' AND PC0_UEN<>'' "
cQuery +="UNION "
cQuery +="SELECT DISTINCT Substring(PCD_ANOMES,1,4) AS ANO "
cQuery +="FROM " +RetSqlName("PCD")+ " PCD "
cQuery +="WHERE PCD.D_E_L_E_T_ <> '*' AND PCD_UEN<>'' "
cQuery +="UNION "
cQuery +="SELECT DISTINCT Substring(PCH_ANOMES,1,4) AS ANO "
cQuery +="FROM  " +RetSqlName("PCH")+ " PCH "
cQuery +="WHERE PCH.D_E_L_E_T_ <> '*' AND PCH_UEN<>'' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "CMBANO", .F., .T.)
DBSelectArea("CMBANO")
dbgotop()
While !Eof()
aAdd(aAno, CMBANO->ANO)
DbSkip()
EndDo
DBCloseArea()
RestArea(aArea)
*/
/*
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
//≥Verifica se existem dados para criar o relatÛrio≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
*/
/*If Len(aAno)<1
MsgAlert("N„o existem dados para criar a planilha.")
Return
EndIf
*/
DEFINE MSDIALOG oDlg TITLE "Fluxo de Caixa - GJP Hotels & Resorts" FROM 020,250 TO 200,600 PIXEL

@ 15,20 Say "Esta rotina tem a finalidade de gerar o Fluxo de Caixa " SIZE 170,9 OF oDlg PIXEL
@ 30,20 Say "nos nÌveis SintÈtico e AnalÌtico (detalhando as Naturezas).  "     SIZE 170,9 OF oDlg PIXEL
//@ 45,20 Say "Selecione a opÁ„o  " SIZE 170,9 OF oDlg PIXEL
//@ 45,65 COMBOBOX oCombo VAR cAno ITEMS aAno SIZE 30,9 PIXEL OF oDlg

//@ 50,57  Button "ExportaÁ„o Excel"  Size 60,15 PIXEL  Action( oDlg:End(), U_GR01Proc() ) OF oDlg
@ 50,57  Button "ExportaÁ„o Excel"  Size 60,15 PIXEL  Action( oDlg:End(), U_GJPFLUXOCX() ) OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

Return



/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ GR01Proc  ∫ Autor ≥ Carlos A. Queiroz  ∫ Data ≥  14/06/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processamento                                               ∫±±
±±∫          ≥                                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GJP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function GR01Proc(aPeriodos,aSelFil2,cAliasTRB,aHeader)
Private oProcess
Private _aPeriodos := aClone(aPeriodos)
Private _aHeader := aClone(aHeader)
Private aFiliais := aClone(aSelFil2)
Private aHeadUse := {}
Private cAlias := cAliasTRB

//Default cAno  := "1900"

oProcess := MsNewProcess():New({|lEnd| U_FSXMLFlxCx()},"RelatÛrio Fluxo de Caixa GJP ")
oProcess:Activate()

Return .T.

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥FSXMLAGMAN∫Autor  ≥ Carlos A. Queiroz  ∫ Data ≥  14/06/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processamento no formato mhtml armazenando em um arquivo   ∫±±
±±∫          ≥ texto que sera convertido em mht(excel).                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Orteng                                                     ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function FSXMLFlxCx(nAno)

Local cPath   	  := ""				   			// Parametro que indica qual o diretorio de gravacao sera exportado.
Local lRet		  := .F.							// Retorno da funcao
Local lOk		  := .F.							// Retorno da funcao
Local cArqPesq 	  := ""							// Nome do arquivo que foi gerado
Local nHandle	  := 0							// Indicador de arquivo de exportacao aberto
Local cPerSX1     := "GFINR01"
//Local aFiliais	  :=	{}
Local lContinua	  := .F.
Local cTime       := substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)
Local nHeigth     := 0
Local aNatRec     := {}
Local nVlrNat     := 0
Local _nVlrNat  := 0
Local cNatureza   := ""
Local _nDiaBco    := 0
Local _cNomeBanco := ""
Local _nPrev := 0
Local _nReal := 0
Local j := 0

Private aTotNat := {}
Private aRegs	:= {}
Private cTabela	:= ""							// Tabela dos indicadores AGM
Private aNatSE5R:= {}
Private aNatSE1A:= {}
Private dDataNat:= CTOD("")
Private aNatSE5P:= {}
Private aNatSE2P:= {}
Private aNatSE8 := {}
Private cBanco  := ""
Private aNatSC5 := {}
Private aNatSC7 := {}
Private aNatSE3 := {}

Private dDataRetro := CTOD("")
Private dDataAvanc := CTOD("")
Private aDataImp   := {}
Private dDataPlan  := CTOD("")
Private nSaldoIni  := 0
Private _dDataRef  := CTOD("")
Private _nReceb    := 0
Private _nPagto    := 0
Private _nBcoFil   := 0
Private aAux       := {}

Private aSaldoInicial   := {}
Private	aRecebimentos   := {}
Private	aPagamentos     := {}
Private	aRecPag         := {}
Private	aSaldoOperFinal := {}
Private	aSaldoFinal     := {}
Private	aBancos         := {}
Private	aBancosFinal    := {}
Private	aBcoFilial      := {}
Private	aAuxBancos      := {}

cPath := cGetFile("","Local para gravac‰o...",1,,.F.,GETF_LOCALHARD+GETF_RETDIRECTORY ) //"Local para gravaÁ„o..."
If cPath==""
	Return
EndIf

cArqPesq := cPath +"GJP_Fluxo_de_Caixa_"+DTOS(ddatabase)+"_"+alltrim(cTime)+ ".xls"	// Exemplo: PQ123456.xls
//cArqPesq := cPath +"agm_anual.txt"	// Exemplo: PQ123456.xls

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Cria um arquivo do tipo *.xls	                                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
nHandle := FCREATE(cArqPesq, 0)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifica se o arquivo pode ser criado, caso contrario um alerta sera exibido      ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If FERROR() != 0
	Alert("N„o foi possÌvel abrir ou criar o arquivo: " + cArqPesq)
Else
	
	//	If !msgyesno("Deseja gerar todas as UEN¥s ?"+ CRLF + CRLF + "SIM = Filtra todas as UEN¥s" + CRLF + CRLF + "NAO = Permite selecionar uma ˙nica UEN.")
//	GR01juSX1(cPerSX1)
//	If Pergunte(cPerSX1, .T.)
//		aFiliais	:=	aClone(aSelFil2)
		/*
		While !lContinua
			If MV_PAR09 == 1
				aFiliais	:=	AdmGetFil()
				lContinua	:= Len(aFiliais) > 0
				If !lContinua
					if !msgyesno("Filiais n„o informadas. Escolha 'SIM' para informar as filiais ou 'NAO' para sair da interface.")
						Return .T.
					EndIf
				EndIf
			Else
				aFiliais 	:= {cFilAnt}
				lContinua	:= .T.
			EndIf
		EndDo
		*/
//	Else
//		Return .T.
//	EndIf
	//	Else
	//		MV_PAR01 := ""
	//	EndIf
	
	//retroceder ou avancar
/*	dDataRetro := DATAVALIDA(DDATABASE-MV_PAR04-1,.F.)
	dDataAvanc := DATAVALIDA(DDATABASE+MV_PAR05,.T.)
	
	
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Recebimento com data a retroceder≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cQuery :=" SELECT * "
	cQuery +=" FROM  " +RetSqlName("SE5")+ " SE5 "
	cQuery +=" Where ("
	
	For i:=1 to len(aFiliais)
		If len(aFiliais) == 1 .or. i == len(aFiliais)
			cQuery +=" SE5.E5_FILIAL =  '"+alltrim(aFiliais[i])+"' ) AND
		Else
			cQuery +=" SE5.E5_FILIAL =  '"+alltrim(aFiliais[i])+"' or
		EndIf
	Next i
	
	cQuery +=" SE5.E5_DATA BETWEEN '"+DTOS(dDataRetro)+"' AND '"+DTOS(dDataBase-1)+"' AND "
	
	cQuery +=" SE5.E5_RECPAG = 'R' AND "
	
	cQuery +=" SE5.E5_NATUREZ BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	
	//cQuery +=" SE1.E1_SALDO <> 0 "
	
	cQuery +=" ORDER BY SE5.E5_DATA, SE5.E5_NATUREZ
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSE5R", .F., .T.)
	DBSelectArea("QRYSE5R")
	
	///
	cNatureza := QRYSE5R->E5_NATUREZ
	dDataNat  := QRYSE5R->E5_DATA
	nVlrNat   := 0
	
	While QRYSE5R->(!EOF())  
		If !empty(QRYSE5R->E5_NATUREZ)
		
		If QRYSE5R->E5_NATUREZ == cNatureza .and. dDataNat == QRYSE5R->E5_DATA
			nVlrNat += QRYSE5R->E5_VALOR
		Else
			aAdd(aNatSE5R,{dDataNat,cNatureza,nVlrNat})
			dDataNat  := QRYSE5R->E5_DATA
			nVlrNat   := QRYSE5R->E5_VALOR
			cNatureza := QRYSE5R->E5_NATUREZ
		EndIf

		EndIf
		QRYSE5R->(dbskip())
	EndDo
	
	If !empty(cNatureza)
		aAdd(aNatSE5R,{dDataNat,cNatureza,nVlrNat}) 
	EndIf
	*/
	///
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Recebimento com data a avancar≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
/*	cQuery :=" SELECT * "
	cQuery +=" FROM  " +RetSqlName("SE1")+ " SE1 "
	cQuery +=" Where ("
	
	For i:=1 to len(aFiliais)
		If len(aFiliais) == 1 .or. i == len(aFiliais)
			cQuery +=" SE1.E1_FILIAL =  '"+alltrim(aFiliais[i])+"' ) AND
		Else
			cQuery +=" SE1.E1_FILIAL =  '"+alltrim(aFiliais[i])+"' or
		EndIf
	Next i
	
	cQuery +=" SE1.E1_VENCREA BETWEEN '"+DTOS(dDatabase)+"' AND '"+DTOS(dDataAvanc)+"' AND "
	
	//cQuery +=" SE1.E1_VENCREA >= '"+DTOS(DDATABASE-MV_PAR06)+"' AND "
	
	cQuery +=" SE1.E1_NATUREZ BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'  "
	
	//cQuery +=" SE1.E1_SALDO <> 0 "
	
	cQuery +=" ORDER BY SE1.E1_VENCREA, SE1.E1_NATUREZ
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSE1A", .F., .T.)
	DBSelectArea("QRYSE1A")
	
	///
	cNatureza := QRYSE1A->E1_NATUREZ
	dDataNat  := QRYSE1A->E1_VENCREA
	nVlrNat   := 0
	
	While QRYSE1A->(!EOF())
		If !empty(QRYSE1A->E1_NATUREZ)

		If QRYSE1A->E1_NATUREZ == cNatureza .and. dDataNat == QRYSE1A->E1_VENCREA
			nVlrNat += QRYSE1A->E1_SALDO
		Else
			aAdd(aNatSE1A,{dDataNat,cNatureza,nVlrNat})
			dDataNat  := QRYSE1A->E1_VENCREA
			nVlrNat   := QRYSE1A->E1_SALDO
			cNatureza := QRYSE1A->E1_NATUREZ
		EndIf
		
		EndIf
		QRYSE1A->(dbskip())
	EndDo
	
	If !empty(cNatureza)
		aAdd(aNatSE1A,{dDataNat,cNatureza,nVlrNat})
	EndIf   */
	///
	
	////////////////////////////////////////////////////////////////////////////
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Pagamentos com data a retroceder≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
/*	cQuery :=" SELECT * "
	cQuery +=" FROM  " +RetSqlName("SE5")+ " SE5 "
	cQuery +=" Where ("
	
	For i:=1 to len(aFiliais)
		If len(aFiliais) == 1 .or. i == len(aFiliais)
			cQuery +=" SE5.E5_FILIAL =  '"+alltrim(aFiliais[i])+"' ) AND
		Else
			cQuery +=" SE5.E5_FILIAL =  '"+alltrim(aFiliais[i])+"' or
		EndIf
	Next i
	
	cQuery +=" SE5.E5_DATA BETWEEN '"+DTOS(dDataRetro)+"' AND '"+DTOS(dDataBase-1)+"' AND "
	
	cQuery +=" SE5.E5_RECPAG = 'P' AND "
	
	cQuery +=" SE5.E5_NATUREZ BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	
	//cQuery +=" SE1.E1_SALDO <> 0 "
	
	cQuery +=" ORDER BY SE5.E5_DATA, SE5.E5_NATUREZ
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSE5P", .F., .T.)
	DBSelectArea("QRYSE5P")
	
	///
	cNatureza := QRYSE5P->E5_NATUREZ
	dDataNat  := QRYSE5P->E5_DATA
	nVlrNat   := 0
	
	While QRYSE5P->(!EOF())   
		If !empty(QRYSE5P->E5_NATUREZ)
		
		If QRYSE5P->E5_NATUREZ == cNatureza .and. dDataNat == QRYSE5P->E5_DATA
			nVlrNat += QRYSE5P->E5_VALOR
		Else
			aAdd(aNatSE5P,{dDataNat,cNatureza,nVlrNat})
			dDataNat  := QRYSE5P->E5_DATA
			nVlrNat   := QRYSE5P->E5_VALOR
			cNatureza := QRYSE5P->E5_NATUREZ
		EndIf
		
		EndIf
		QRYSE5P->(dbskip())
	EndDo
	
	If !empty(cNatureza)
		aAdd(aNatSE5P,{dDataNat,cNatureza,nVlrNat})
	EndIf	*/
	///
	
	
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Pagamentos com data a avancar≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
/*	cQuery :=" SELECT * "
	cQuery +=" FROM  " +RetSqlName("SE2")+ " SE2 "
	cQuery +=" Where ("
	
	For i:=1 to len(aFiliais)
		If len(aFiliais) == 1 .or. i == len(aFiliais)
			cQuery +=" SE2.E2_FILIAL =  '"+alltrim(aFiliais[i])+"' ) AND
		Else
			cQuery +=" SE2.E2_FILIAL =  '"+alltrim(aFiliais[i])+"' or
		EndIf
	Next i
	
	cQuery +=" SE2.E2_VENCREA BETWEEN '"+DTOS(dDatabase)+"' AND '"+DTOS(dDataAvanc)+"' AND "
	
	//cQuery +=" SE1.E1_VENCREA >= '"+DTOS(DDATABASE-MV_PAR06)+"' AND "
	
	cQuery +=" SE2.E2_NATUREZ BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	
	//cQuery +=" SE1.E1_SALDO <> 0 "
	
	cQuery +=" ORDER BY SE2.E2_VENCREA, SE2.E2_NATUREZ
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSE2P", .F., .T.)
	DBSelectArea("QRYSE2P")
	
	///
	cNatureza := QRYSE2P->E2_NATUREZ
	dDataNat  := QRYSE2P->E2_VENCREA
	nVlrNat   := 0
	
	While QRYSE2P->(!EOF())          
		
		If !empty(QRYSE2P->E2_NATUREZ)
			
		If QRYSE2P->E2_NATUREZ == cNatureza .and. dDataNat == QRYSE2P->E2_VENCREA
			nVlrNat += QRYSE1A->E1_SALDO
		Else
			aAdd(aNatSE2P,{dDataNat,cNatureza,nVlrNat})
			dDataNat  := QRYSE2P->E2_VENCREA
			nVlrNat   := QRYSE2P->E2_SALDO
			cNatureza := QRYSE2P->E2_NATUREZ
		EndIf
		
		EndIf
		QRYSE2P->(dbskip())
	EndDo
	
	If !empty(cNatureza)
		aAdd(aNatSE2P,{dDataNat,cNatureza,nVlrNat})
	EndIf	*/
	///
	
	
	////////////////////////////////////////////////////////////////////////////
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Bancos com datas a retroceder e a avancar≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cQuery :=" SELECT * "
	cQuery +=" FROM  " +RetSqlName("SE8")+ " SE8 "
	cQuery +=" Where ("
	
	For i:=1 to len(aFiliais)
		If len(aFiliais) == 1 .or. i == len(aFiliais)
			cQuery +=" SE8.E8_FILIAL =  '"+alltrim(aFiliais[i])+"' ) AND
		Else
			cQuery +=" SE8.E8_FILIAL =  '"+alltrim(aFiliais[i])+"' or
		EndIf
	Next i
	
	cQuery +=" SE8.E8_DTSALAT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	
	//cQuery +=" SE1.E1_VENCREA >= '"+DTOS(DDATABASE-MV_PAR06)+"' AND "
	
	//cQuery +=" SE5.E5_NATUREZ BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' AND "
	
	//cQuery +=" SE1.E1_SALDO <> 0 "
	if lfluxsint
		cQuery +=" ORDER BY SE8.E8_FILIAL, SE8.E8_DTSALAT, SE8.E8_BANCO
	else
		cQuery +=" ORDER BY SE8.E8_FILIAL, SE8.E8_DTSALAT, SE8.E8_BANCO, SE8.E8_AGENCIA, SE8.E8_CONTA
	endif
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSE8", .F., .T.)
	DBSelectArea("QRYSE8")
	
if lfluxsint
	_cFilial  := QRYSE8->E8_FILIAL
	cBanco    := QRYSE8->E8_BANCO
	dDataNat  := QRYSE8->E8_DTSALAT
	nVlrNat   := 0
	
	While QRYSE8->(!EOF())  
		
		If !empty(QRYSE8->E8_BANCO)
		
		If QRYSE8->E8_BANCO == cBanco .and. dDataNat == QRYSE8->E8_DTSALAT  .and. 	_cFilial == QRYSE8->E8_FILIAL
			nVlrNat += QRYSE8->E8_SALATUA
		Else
			aAdd(aNatSE8,{dDataNat,_cFilial,cBanco,nVlrNat})
			dDataNat  := QRYSE8->E8_DTSALAT
			nVlrNat   := QRYSE8->E8_SALATUA
			cBanco    := QRYSE8->E8_BANCO
			_cFilial  := QRYSE8->E8_FILIAL
		EndIf                     
		
		EndIf
		QRYSE8->(dbskip())
	EndDo  
	QRYSE8->(dbclosearea())  
	If !empty(cBanco)
		aAdd(aNatSE8,{dDataNat,_cFilial, cBanco,nVlrNat})
	EndIf
else
	_cFilial  := QRYSE8->E8_FILIAL
	cBanco    := QRYSE8->E8_BANCO+QRYSE8->E8_AGENCIA+QRYSE8->E8_CONTA
	dDataNat  := QRYSE8->E8_DTSALAT
	nVlrNat   := 0
	
	While QRYSE8->(!EOF())  
		
		If !empty(QRYSE8->E8_BANCO)
		
		If QRYSE8->E8_BANCO+QRYSE8->E8_AGENCIA+QRYSE8->E8_CONTA == cBanco .and. dDataNat == QRYSE8->E8_DTSALAT  .and. 	_cFilial == QRYSE8->E8_FILIAL
			nVlrNat += QRYSE8->E8_SALATUA
		Else
			aAdd(aNatSE8,{dDataNat,_cFilial,cBanco,nVlrNat})
			dDataNat  := QRYSE8->E8_DTSALAT
			nVlrNat   := QRYSE8->E8_SALATUA
			cBanco    := QRYSE8->E8_BANCO+QRYSE8->E8_AGENCIA+QRYSE8->E8_CONTA
			_cFilial  := QRYSE8->E8_FILIAL
		EndIf                     
		
		EndIf
		QRYSE8->(dbskip())
	EndDo  
	QRYSE8->(dbclosearea())  
	If !empty(cBanco)
		aAdd(aNatSE8,{dDataNat,_cFilial, cBanco,nVlrNat})
	EndIf
endif
	///
	
	
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Considera Pedido de Venda≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
/*	If MV_PAR06 == 1
		cQuery :=" SELECT * "
		cQuery +=" FROM  " +RetSqlName("SC5")+ " SC5, "+RetSqlName("SA1")+ " SA1 "
		cQuery +=" Where ("
		
		For i:=1 to len(aFiliais)
			If len(aFiliais) == 1 .or. i == len(aFiliais)
				cQuery +=" SC5.C5_FILIAL =  '"+alltrim(aFiliais[i])+"' ) AND ( "
			Else
				cQuery +=" SC5.C5_FILIAL =  '"+alltrim(aFiliais[i])+"' or
			EndIf
		Next i
		
		For i:=1 to len(aFiliais)
			If len(aFiliais) == 1 .or. i == len(aFiliais)
				cQuery +=" SA1.A1_FILIAL =  '"+substr(alltrim(aFiliais[i]),1,2)+"' ) AND
			Else
				cQuery +=" SA1.A1_FILIAL =  '"+substr(alltrim(aFiliais[i]),1,2)+"' or
			EndIf
		Next i
		
		cQuery +=" SUBSTRING(SC5.C5_FILIAL,1,2) = SA1.A1_FILIAL AND SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND
		
		cQuery +=" SA1.A1_NATUREZ <> '' "
		
		cQuery +=" ORDER BY SA1.A1_NATUREZ
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC5", .F., .T.)
		DBSelectArea("QRYSC5")
		
		// Tratar o realizados filtrando SC9 a partir da SC6 considerando a data de faturamento
		// Tratar o previsto considerando o saldo
		////////////////////////////////////////////////////////////////////////////
		///
		
		While QRYSC5->(!EOF())
			//Realizado
			cQuery :=" SELECT * "
			cQuery +=" FROM   "+RetSqlName("SC9")+ " SC9 "
			cQuery +=" Where "
			
			
			cQuery += " SC9.C9_FILIAL = '"+QRYSC5->C5_FILIAL+"' AND SC9.C9_PEDIDO = '"+QRYSC5->C5_NUM+"' AND
			
			cQuery +=" SC9.C9_DATALIB BETWEEN '"+DTOS(dDataRetro)+"' AND '"+DTOS(dDataBase)+"'  "
			
			cQuery +=" ORDER BY SC9.C9_DATALIB
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC9", .F., .T.)
			DBSelectArea("QRYSC9")
			
			///
			cNatureza := QRYSC5->A1_NATUREZ
			dDataNat  := QRYSC9->C9_DATALIB
			nVlrNat   := 0
			
			While QRYSC9->(!EOF())
			    If !empty(cNatureza)
			
				If  dDataNat == QRYSC9->C9_DATALIB
					nVlrNat  += QRYSC9->C9_PRCVEN
				Else
					aAdd(aNatSC5,{dDataNat,cNatureza,nVlrNat})
					dDataNat  := QRYSC9->C9_DATALIB
					nVlrNat   := QRYSC9->C9_PRCVEN
					cNatureza := QRYSC5->A1_NATUREZ
				EndIf  
				
				EndIf
				QRYSC9->(dbskip())
			EndDo

			If !empty(cNatureza)
				aAdd(aNatSC5,{dDataNat,cNatureza,nVlrNat})
			EndIf
			///
			QRYSC9->(dbclosearea())
			
			QRYSC5->(dbskip())
		EndDo
		
	eNDiF
	*/
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Considera Pedido de Compra≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
/*	If MV_PAR07 == 1
		cQuery :=" SELECT * "
		cQuery +=" FROM  " +RetSqlName("SC7")+ " SC7, "+RetSqlName("SA2")+ " SA2 "
		cQuery +=" Where ("
		
		For i:=1 to len(aFiliais)
			If len(aFiliais) == 1 .or. i == len(aFiliais)
				cQuery +=" SC7.C7_FILIAL =  '"+alltrim(aFiliais[i])+"' ) AND ( "
			Else
				cQuery +=" SC7.C7_FILIAL =  '"+alltrim(aFiliais[i])+"' or
			EndIf
		Next i
		
		For i:=1 to len(aFiliais)
			If len(aFiliais) == 1 .or. i == len(aFiliais)
				cQuery +=" SA2.A2_FILIAL =  '"+substr(alltrim(aFiliais[i]),1,2)+"' ) AND
			Else
				cQuery +=" SA2.A2_FILIAL =  '"+substr(alltrim(aFiliais[i]),1,2)+"' or
			EndIf
		Next i
		
		cQuery +=" SUBSTRING(SC7.C7_FILIAL,1,2) = SA2.A2_FILIAL AND SC7.C7_FORNECE = SA2.A2_COD AND SC7.C7_LOJA = SA2.A2_LOJA AND
		
		cQuery +=" SA2.A2_NATUREZ <> '' AND"
		
		cQuery +=" SC7.C7_EMISSAO BETWEEN '"+DTOS(dDataRetro)+"' AND '"+DTOS(dDataBase)+"' "
		
		cQuery +=" ORDER BY SA2.A2_NATUREZ, SC7.C7_EMISSAO
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC7", .F., .T.)
		DBSelectArea("QRYSC7")
		
		///
		cNatureza := QRYSC7->A2_NATUREZ
		dDataNat  := QRYSC7->C7_EMISSAO
		nVlrNat   := 0
		
		While QRYSC7->(!EOF()) 
		
		    If !empty(QRYSC7->A2_NATUREZ)

			If  QRYSC7->A2_NATUREZ == cNatureza .and. dDataNat == QRYSC7->C7_EMISSAO
				nVlrNat  += QRYSC7->C7_TOTAL
			Else
				aAdd(aNatSC7,{dDataNat,cNatureza,nVlrNat})
				dDataNat  := QRYSC7->C7_EMISSAO
				nVlrNat   := QRYSC7->C7_TOTAL
				cNatureza := QRYSC7->A2_NATUREZ
			EndIf   
			
			EndIf
			
			QRYSC7->(dbskip())
		EndDo  

		If !empty(cNatureza)
			aAdd(aNatSC7,{dDataNat,cNatureza,nVlrNat})
		EndIf	
		///
	EndIf
	
	*/
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Considera Comissoes≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
/*	If MV_PAR08 == 1
		cQuery :=" SELECT * "
		cQuery +=" FROM  " +RetSqlName("SE3")+ " SE3, "+RetSqlName("SA1")+ " SA1 "
		cQuery +=" Where ("
		
		For i:=1 to len(aFiliais)
			If len(aFiliais) == 1 .or. i == len(aFiliais)
				cQuery +=" SE3.E3_FILIAL =  '"+alltrim(aFiliais[i])+"' ) AND ( "
			Else
				cQuery +=" SE3.E3_FILIAL =  '"+alltrim(aFiliais[i])+"' or
			EndIf
		Next i
		
		For i:=1 to len(aFiliais)
			If len(aFiliais) == 1 .or. i == len(aFiliais)
				cQuery +=" SA1.A1_FILIAL =  '"+substr(alltrim(aFiliais[i]),1,2)+"' ) AND
			Else
				cQuery +=" SA1.A1_FILIAL =  '"+substr(alltrim(aFiliais[i]),1,2)+"' or
			EndIf
		Next i
		
		cQuery +=" SUBSTRING(SE3.E3_FILIAL,1,2) = SA1.A1_FILIAL AND SE3.E3_CODCLI = SA1.A1_COD AND SE3.E3_LOJA = SA1.A1_LOJA AND
		
		cQuery +=" SE3.E3_EMISSAO BETWEEN '"+DTOS(dDataRetro)+"' AND '"+DTOS(dDataBase)+"' AND "
		
		cQuery +=" SA1.A1_NATUREZ <> '' "
		
		cQuery +=" ORDER BY SA1.A1_NATUREZ, SE3.E3_EMISSAO
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSE3", .F., .T.)
		DBSelectArea("QRYSE3")
		
		///
		cNatureza := QRYSE3->A1_NATUREZ
		dDataNat  := QRYSE3->E3_EMISSAO
		nVlrNat   := 0
		
		While QRYSE3->(!EOF())   
		
			If !empty(QRYSE3->A1_NATUREZ)
				    
			If  QRYSE3->A1_NATUREZ == cNatureza .and. dDataNat == QRYSE3->E3_EMISSAO
				nVlrNat  += QRYSE3->E3_COMIS
			Else
				aAdd(aNatSE3,{dDataNat,cNatureza,nVlrNat})
				dDataNat  := QRYSE3->E3_EMISSAO
				nVlrNat   := QRYSE3->E3_COMIS
				cNatureza := QRYSE3->A1_NATUREZ
			EndIf   
			
			EndIf
			QRYSE3->(dbskip())
		EndDo 

		If !empty(cNatureza)
			aAdd(aNatSE3,{dDataNat,cNatureza,nVlrNat})
		EndIf
		///
		
	EndIf
	*/
		
//QRYSE1->(dbgotop())
/*dDataPlan := DataValida(dDataRetro+1,.T.)

While dDataPlan <= dDataAvanc
	aadd(aDataImp,dDataPlan)
	dDataPlan := DataValida(dDataPlan+1,.T.)
EndDo


//Imprimir Saldo Inicial

For i:=1 to Len(aNatSE5R)
	If aNatSE5R[i][1] == DTOS(dDataRetro)
		nSaldoIni += aNatSE5R[i][3]
	EndIf
Next i

For i:=1 to Len(aNatSE1A)
	If aNatSE1A[i][1] == DTOS(dDataRetro)
		nSaldoIni += aNatSE1A[i][3]
	EndIf
Next i

For i:=1 to Len(aNatSC5)
	If aNatSC5[i][1] == DTOS(dDataRetro)
		nSaldoIni += aNatSC5[i][3]
	EndIf
Next i

For i:=1 to Len(aNatSC5)
	If aNatSC5[i][1] == DTOS(dDataRetro)
		nSaldoIni += aNatSC5[i][3]
	EndIf
Next i

For i:=1 to Len(aNatSE5P)
	If aNatSE5P[i][1] == DTOS(dDataRetro)
		nSaldoIni -= aNatSE5P[i][3]
	EndIf
Next i

For i:=1 to Len(aNatSE2P)
	If aNatSE2P[i][1] == DTOS(dDataRetro)
		nSaldoIni -= aNatSE2P[i][3]
	EndIf
Next i

For i:=1 to Len(aNatSC7)
	If aNatSC7[i][1] == DTOS(dDataRetro)
		nSaldoIni -= aNatSC7[i][3]
	EndIf
Next i

For i:=1 to Len(aNatSE3)
	If aNatSE3[i][1] == DTOS(dDataRetro)
		nSaldoIni -= aNatSE3[i][3]
	EndIf
Next i
*/
//aAdd(aSaldoInicial,{DTOS(dDataRetro),nSaldoIni})

/*
For i:=1 to len(aDataImp)
	
	_dDataRef := DTOS(aDataImp[i])
	
	If i <> 1
//		aAdd(aSaldoInicial,{_dDataRef,(nSaldoIni+_nReceb-_nPagto)})
		
		nSaldoIni := nSaldoIni+_nReceb-_nPagto
		_nReceb   := 0
		_nPagto   := 0
		_nBcoFil  := 0 
		aAux      := {}
	EndIf
	
	// Recebimentos
	For j:=1 to Len(aNatSE5R)
		If _dDataRef == aNatSE5R[j][1]
			aAdd(aAux,{aNatSE5R[j][2],aNatSE5R[j][3]})
		EndIf
	Next j
	
	For j:=1 to Len(aNatSE1A)
		If _dDataRef == aNatSE1A[j][1]
			aAdd(aAux,{aNatSE1A[j][2],aNatSE1A[j][3]})
		EndIf
	Next j
	
	For j:=1 to Len(aNatSC5)
		If _dDataRef == aNatSC5[j][1]
			aAdd(aAux,{aNatSC5[j][2],aNatSC5[j][3]})
		EndIf
	Next j
	
	aSort( aAux,,,{|x,y| x[1] < y[1] })
	
	If !empty(aAux)
		cNatureza := aAux[1][1]
		
		For k:=1 to len(aAux)
			If cNatureza  == aAux[k][1]
				_nVlrNat  += aAux[k][2]
				_nReceb   += aAux[k][2]
			Else
				aAdd(aRecebimentos,{STOD(_dDataRef),cNatureza,_nVlrNat})
				cNatureza  := aAux[k][1]
				_nVlrNat   += aAux[k][2]
				_nReceb    += aAux[k][2]
			EndIf
		Next k
		aAdd(aRecebimentos,{STOD(_dDataRef),cNatureza,_nVlrNat})
	EndIf
	
	
	// Pagamentos
	aAux := {}
	
	For j:=1 to Len(aNatSE5P)
		If _dDataRef == aNatSE5P[j][1]
			aAdd(aAux,{aNatSE5P[j][2],aNatSE5P[j][3]})
		EndIf
	Next j
	
	For j:=1 to Len(aNatSE2P)
		If _dDataRef == aNatSE2P[j][1]
			aAdd(aAux,{aNatSE2P[j][2],aNatSE2P[j][3]})
		EndIf
	Next j
	
	For j:=1 to Len(aNatSC7)
		If _dDataRef == aNatSC7[j][1]
			aAdd(aAux,{aNatSC7[j][2],aNatSC7[j][3]})
		EndIf
	Next j
	
	For j:=1 to Len(aNatSE3)
		If _dDataRef == aNatSE3[j][1]
			aAdd(aAux,{aNatSE3[j][2],aNatSE3[j][3]})
		EndIf
	Next j
	
	aSort( aAux,,,{|x,y| x[1] < y[1] })
	
	If !empty(aAux)
		cNatureza := aAux[1][1]
		
		For k:=1 to len(aAux)
			If cNatureza  == aAux[k][1]
				_nVlrNat += aAux[k][2]
				_nPagto  += aAux[k][2]
			Else
				aAdd(aPagamentos,{STOD(_dDataRef),cNatureza,_nVlrNat})
				cNatureza  := aAux[k][1]
				_nVlrNat   := aAux[k][2]
				_nPagto    += aAux[k][2]
			EndIf
		Next k
		aAdd(aPagamentos,{STOD(_dDataRef),cNatureza,_nVlrNat})
	EndIf
	
	aAdd(aRecPag,{_dDataRef,_nReceb,_nPagto})
	
	///	aSaldoOperFinal ?????
	
	aAdd(aSaldoFinal,{_dDataRef,(nSaldoIni+_nReceb-_nPagto)})
	
	aAux := {}
	_nBcoFil := 0
	_nVlrNat := 0
	
	For j:=1 to Len(aNatSE8)
		If _dDataRef == aNatSE8[j][1]
			aAdd(aAux,{aNatSE8[j][2],aNatSE8[j][3],aNatSE8[j][4]})
		EndIf
	Next j
	aSort( aAux,,,{|x,y| x[1] < y[1] })
	If !empty(aAux)
		_cFilial  := aAux[1][1]
		cBanco    := aAux[1][2]
		_nVlrNat  := 0
		
		For k:=1 to len(aAux)
			If _cFilial  == aAux[k][1] .and. cBanco  == aAux[k][2]
				_nVlrNat += aAux[k][3]
				_nBcoFil += aAux[k][3]
			Else
				aAdd(aBancos,{STOD(_dDataRef),_cFilial,cBanco,_nVlrNat})
				_cFilial  := aAux[k][1]
				cBanco    := aAux[k][2]
				_nVlrNat  := aAux[k][3]
				_nBcoFil  += aAux[k][3]
			EndIf
		Next k
		
		aAdd(aBancos,{STOD(_dDataRef),_cFilial,cBanco,_nVlrNat})
	EndIf
	
	aAdd(aBancosFinal,{_dDataRef,_nBcoFil})
	
Next i
*/
//dDataPlan := DataValida(MV_PAR03,.T.)
//dDataAvanc := DataValida(MV_PAR4,.T.)
dDataPlan := MV_PAR03
dDataAvanc := MV_PAR4

While dDataPlan <= dDataAvanc
	aadd(aDataImp,dDataPlan)
	dDataPlan := dDataPlan+1
EndDo

For i:=1 to Len(aDataImp)
	_dDataRef := DTOS(aDataImp[i])
	aAux := {}
	_nBcoFil := 0
	_nVlrNat := 0
	
	For j:=1 to Len(aNatSE8)
		If _dDataRef == aNatSE8[j][1]
			dbselectarea("SA6")
			dbsetorder(1)
			If dbseek(aNatSE8[j][2]+aNatSE8[j][3])
				If SA6->A6_FLUXCAI <> 'N'
					aAdd(aAux,{aNatSE8[j][2],aNatSE8[j][3],aNatSE8[j][4]})
				EndIf
			EndIf
		EndIf
	Next j
	
	aSort( aAux,,,{|x,y| x[1] < y[1] })
	
	If !empty(aAux)
		_cFilial  := aAux[1][1]
		cBanco    := aAux[1][2]
		_nVlrNat  := 0
		
		For k:=1 to len(aAux)
			If _cFilial  == aAux[k][1] .and. cBanco  == aAux[k][2]
				_nVlrNat += aAux[k][3]
				_nBcoFil += aAux[k][3]
			Else
				aAdd(aBancos,{STOD(_dDataRef),_cFilial,cBanco,_nVlrNat})
				_cFilial  := aAux[k][1]
				cBanco    := aAux[k][2]
				_nVlrNat  := aAux[k][3]
				_nBcoFil  += aAux[k][3]
			EndIf
		Next k
		
		aAdd(aBancos,{STOD(_dDataRef),_cFilial,cBanco,_nVlrNat})
	EndIf
	
	aAdd(aBancosFinal,{_dDataRef,_nBcoFil})
Next i	

	/*
	- recebimentos
		natse5r
		natse1a
		natsc5
		
	- pagamentos
		natse5p
		natse2p
		natsc7
		natse3
	
	- bancos
		natse8
	*/

	oProcess:SetRegua1(2)
	oProcess:SetRegua2(3)
	
	oProcess:IncRegua1("Fluxo de Caixa - GJP")
	oProcess:IncRegua2("Filtrando dados...")
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥PARTE FIXA DO ARQUIVO				                                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	//Monta tabelas e graficos de maneira dinamica
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//cTabela += ""   + CRLF
	
	cTabela += 'MIME-Version: 1.0
	cTabela += ""+CRLF+'X-Document-Type: Workbook
	cTabela += ""+CRLF+'Content-Type: multipart/related; boundary="----=_NextPart_01D01EA8.0A093920"
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'Este documento È uma P·gina da Web de Arquivo ⁄nico, tambÈm conhecido como Arquivo da Web. Se vocÍ estiver lendo esta mensagem, o seu navegador ou editor n„o oferecem suporte a Arquivos da Web. Baixe um navegador que ofereÁa suporte a Arquivos da Web, como o WindowsÆ Internet ExplorerÆ.
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'------=_NextPart_01D01EA8.0A093920
	cTabela += ""+CRLF+'Content-Location: file:///C:/0505DE0C/GJP_Fluxo_Caixa_mhtml.htm
	cTabela += ""+CRLF+'Content-Transfer-Encoding: quoted-printable
	cTabela += ""+CRLF+'Content-Type: text/html; charset="us-ascii"
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<html xmlns:v=3D"urn:schemas-microsoft-com:vml"
	cTabela += ""+CRLF+'xmlns:o=3D"urn:schemas-microsoft-com:office:office"
	cTabela += ""+CRLF+'xmlns:x=3D"urn:schemas-microsoft-com:office:excel"
	cTabela += ""+CRLF+'xmlns=3D"http://www.w3.org/TR/REC-html40">
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<head>
	cTabela += ""+CRLF+'<meta name=3D"Excel Workbook Frameset">
	cTabela += ""+CRLF+'<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
	cTabela += ""+CRLF+'<meta name=3DProgId content=3DExcel.Sheet>
	cTabela += ""+CRLF+'<meta name=3DGenerator content=3D"Microsoft Excel 12">
	cTabela += ""+CRLF+'<link rel=3DFile-List href=3D"GJP_Fluxo_Caixa_mhtml_arquivos/filelist.xml">
	cTabela += ""+CRLF+'<![if !supportTabStrip]>
	cTabela += ""+CRLF+'<link id=3D"shLink" href=3D"GJP_Fluxo_Caixa_mhtml_arquivos/sheet001.htm">
	cTabela += ""+CRLF+'<link id=3D"shLink" href=3D"GJP_Fluxo_Caixa_mhtml_arquivos/sheet002.htm">
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<link id=3D"shLink">
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<script language=3D"JavaScript">
	cTabela += ""+CRLF+'<!--
	cTabela += ""+CRLF+' var c_lTabs=3D2;
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' var c_rgszSh=3Dnew Array(c_lTabs);
	cTabela += ""+CRLF+' c_rgszSh[0] =3D "Par&acirc;metros";
	cTabela += ""+CRLF+' c_rgszSh[1] =3D "Fluxo&nbsp;de&nbsp;Caixa";
	cTabela += ""+CRLF
	cTabela += ""+CRLF
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' var c_rgszClr=3Dnew Array(8);
	cTabela += ""+CRLF+' c_rgszClr[0]=3D"window";
	cTabela += ""+CRLF+' c_rgszClr[1]=3D"buttonface";
	cTabela += ""+CRLF+' c_rgszClr[2]=3D"windowframe";
	cTabela += ""+CRLF+' c_rgszClr[3]=3D"windowtext";
	cTabela += ""+CRLF+' c_rgszClr[4]=3D"threedlightshadow";
	cTabela += ""+CRLF+' c_rgszClr[5]=3D"threedhighlight";
	cTabela += ""+CRLF+' c_rgszClr[6]=3D"threeddarkshadow";
	cTabela += ""+CRLF+' c_rgszClr[7]=3D"threedshadow";
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' var g_iShCur;
	cTabela += ""+CRLF+' var g_rglTabX=3Dnew Array(c_lTabs);
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnGetIEVer()
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' var ua=3Dwindow.navigator.userAgent
	cTabela += ""+CRLF+' var msie=3Dua.indexOf("MSIE")
	cTabela += ""+CRLF+' if (msie>0 && window.navigator.platform=3D=3D"Win32")
	cTabela += ""+CRLF+'  return parseInt(ua.substring(msie+5,ua.indexOf(".", msie)));
	cTabela += ""+CRLF+' else
	cTabela += ""+CRLF+'  return 0;
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnBuildFrameset()
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' var szHTML=3D"<frameset rows=3D\"*,18\" border=3D0 width=3D0 frameborder=
	cTabela += ""+CRLF+'=3Dno framespacing=3D0>"+
	cTabela += ""+CRLF+'  "<frame src=3D\""+document.all.item("shLink")[1].href+"\" name=3D\"frShee=
	cTabela += ""+CRLF+'t\" noresize>"+
	cTabela += ""+CRLF+'  "<frameset cols=3D\"54,*\" border=3D0 width=3D0 frameborder=3Dno framespa=
	cTabela += ""+CRLF+'cing=3D0>"+
	cTabela += ""+CRLF+'  "<frame src=3D\"\" name=3D\"frScroll\" marginwidth=3D0 marginheight=3D0 s=
	cTabela += ""+CRLF+'crolling=3Dno>"+
	cTabela += ""+CRLF+'  "<frame src=3D\"\" name=3D\"frTabs\" marginwidth=3D0 marginheight=3D0 scr=
	cTabela += ""+CRLF+'olling=3Dno>"+
	cTabela += ""+CRLF+'  "</frameset></frameset><plaintext>";
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' with (document) {
	cTabela += ""+CRLF+'  open("text/html","replace");
	cTabela += ""+CRLF+'  write(szHTML);
	cTabela += ""+CRLF+'  close();
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' fnBuildTabStrip();
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnBuildTabStrip()
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' var szHTML=3D
	cTabela += ""+CRLF+'  "<html><head><style>.clScroll {font:8pt Courier New;color:"+c_rgszClr[6]+=
	cTabela += ""+CRLF+'";cursor:default;line-height:10pt;}"+
	cTabela += ""+CRLF+'  ".clScroll2 {font:10pt Arial;color:"+c_rgszClr[6]+";cursor:default;line-h=
	cTabela += ""+CRLF+'eight:11pt;}</style></head>"+
	cTabela += ""+CRLF+'  "<body onclick=3D\"event.returnValue=3Dfalse;\" ondragstart=3D\"event.ret=
	cTabela += ""+CRLF+'urnValue=3Dfalse;\" onselectstart=3D\"event.returnValue=3Dfalse;\" bgcolor=
	cTabela += ""+CRLF+'=3D"+c_rgszClr[4]+" topmargin=3D0 leftmargin=3D0><table cellpadding=3D0 cel=
	cTabela += ""+CRLF+'lspacing=3D0 width=3D100%>"+
	cTabela += ""+CRLF+'  "<tr><td colspan=3D6 height=3D1 bgcolor=3D"+c_rgszClr[2]+"></td></tr>"+
	cTabela += ""+CRLF+'  "<tr><td style=3D\"font:1pt\">&nbsp;<td>"+
	cTabela += ""+CRLF+'  "<td valign=3Dtop id=3DtdScroll class=3D\"clScroll\" onclick=3D\"parent.f=
	cTabela += ""+CRLF+'nFastScrollTabs(0);\" onmouseover=3D\"parent.fnMouseOverScroll(0);\" onmous=
	cTabela += ""+CRLF+'eout=3D\"parent.fnMouseOutScroll(0);\"><a>&#171;</a></td>"+
	cTabela += ""+CRLF+'  "<td valign=3Dtop id=3DtdScroll class=3D\"clScroll2\" onclick=3D\"parent.=
	cTabela += ""+CRLF+'fnScrollTabs(0);\" ondblclick=3D\"parent.fnScrollTabs(0);\" onmouseover=3D\=
	cTabela += ""+CRLF+'"parent.fnMouseOverScroll(1);\" onmouseout=3D\"parent.fnMouseOutScroll(1);\=
	cTabela += ""+CRLF+'"><a>&lt</a></td>"+
	cTabela += ""+CRLF+'  "<td valign=3Dtop id=3DtdScroll class=3D\"clScroll2\" onclick=3D\"parent.=
	cTabela += ""+CRLF+'fnScrollTabs(1);\" ondblclick=3D\"parent.fnScrollTabs(1);\" onmouseover=3D\=
	cTabela += ""+CRLF+'"parent.fnMouseOverScroll(2);\" onmouseout=3D\"parent.fnMouseOutScroll(2);\=
	cTabela += ""+CRLF+'"><a>&gt</a></td>"+
	cTabela += ""+CRLF+'  "<td valign=3Dtop id=3DtdScroll class=3D\"clScroll\" onclick=3D\"parent.f=
	cTabela += ""+CRLF+'nFastScrollTabs(1);\" onmouseover=3D\"parent.fnMouseOverScroll(3);\" onmous=
	cTabela += ""+CRLF+'eout=3D\"parent.fnMouseOutScroll(3);\"><a>&#187;</a></td>"+
	cTabela += ""+CRLF+'  "<td style=3D\"font:1pt\">&nbsp;<td></tr></table></body></html>";
	cTabela += ""+CRLF
	cTabela += ""+CRLF+" with (frames['frScroll'].document) {
	cTabela += ""+CRLF+'  open("text/html","replace");
	cTabela += ""+CRLF+'  write(szHTML);
	cTabela += ""+CRLF+'  close();
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' szHTML =3D
	cTabela += ""+CRLF+'  "<html><head>"+
	cTabela += ""+CRLF+'  "<style>A:link,A:visited,A:active {text-decoration:none;"+"color:"+c_rgsz=
	cTabela += ""+CRLF+'Clr[3]+";}"+
	cTabela += ""+CRLF+'  ".clTab {cursor:hand;background:"+c_rgszClr[1]+";font:9pt Arial;padding-l=
	cTabela += ""+CRLF+'eft:3px;padding-right:3px;text-align:center;}"+
	cTabela += ""+CRLF+'  ".clBorder {background:"+c_rgszClr[2]+";font:1pt;}"+
	cTabela += ""+CRLF+'  "</style></head><body onload=3D\"parent.fnInit();\" onselectstart=3D\"eve=
	cTabela += ""+CRLF+'nt.returnValue=3Dfalse;\" ondragstart=3D\"event.returnValue=3Dfalse;\" bgco=
	cTabela += ""+CRLF+'lor=3D"+c_rgszClr[4]+
	cTabela += ""+CRLF+'  " topmargin=3D0 leftmargin=3D0><table id=3DtbTabs cellpadding=3D0 cellspa=
	cTabela += ""+CRLF+'cing=3D0>";
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' var iCellCount=3D(c_lTabs+1)*2;
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' var i;
	cTabela += ""+CRLF+' for (i=3D0;i<iCellCount;i+=3D2)
	cTabela += ""+CRLF+'  szHTML+=3D"<col width=3D1><col>";
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' var iRow;
	cTabela += ""+CRLF+' for (iRow=3D0;iRow<6;iRow++) {
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'  szHTML+=3D"<tr>";
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'  if (iRow=3D=3D5)
	cTabela += ""+CRLF+'   szHTML+=3D"<td colspan=3D"+iCellCount+"></td>";
	cTabela += ""+CRLF+'  else {
	cTabela += ""+CRLF+'   if (iRow=3D=3D0) {
	cTabela += ""+CRLF+'    for(i=3D0;i<iCellCount;i++)
	cTabela += ""+CRLF+'     szHTML+=3D"<td height=3D1 class=3D\"clBorder\"></td>";
	cTabela += ""+CRLF+'   } else if (iRow=3D=3D1) {
	cTabela += ""+CRLF+'    for(i=3D0;i<c_lTabs;i++) {
	cTabela += ""+CRLF+'     szHTML+=3D"<td height=3D1 nowrap class=3D\"clBorder\">&nbsp;</td>";
	cTabela += ""+CRLF+'     szHTML+=3D
	cTabela += ""+CRLF+'      "<td id=3DtdTab height=3D1 nowrap class=3D\"clTab\" onmouseover=3D\"p=
	cTabela += ""+CRLF+'arent.fnMouseOverTab("+i+");\" onmouseout=3D\"parent.fnMouseOutTab("+i+");\=
	cTabela += ""+CRLF+'">"+
	cTabela += ""+CRLF+'      "<a href=3D\""+document.all.item("shLink")[i].href+"\" target=3D\"frS=
	cTabela += ""+CRLF+'heet\" id=3DaTab>&nbsp;"+c_rgszSh[i]+"&nbsp;</a></td>";
	cTabela += ""+CRLF+'    }
	cTabela += ""+CRLF+'    szHTML+=3D"<td id=3DtdTab height=3D1 nowrap class=3D\"clBorder\"><a id=
	cTabela += ""+CRLF+'=3DaTab>&nbsp;</a></td><td width=3D100%></td>";
	cTabela += ""+CRLF+'   } else if (iRow=3D=3D2) {
	cTabela += ""+CRLF+'    for (i=3D0;i<c_lTabs;i++)
	cTabela += ""+CRLF+'     szHTML+=3D"<td height=3D1></td><td height=3D1 class=3D\"clBorder\"></t=
	cTabela += ""+CRLF+'d>";
	cTabela += ""+CRLF+'    szHTML+=3D"<td height=3D1></td><td height=3D1></td>";
	cTabela += ""+CRLF+'   } else if (iRow=3D=3D3) {
	cTabela += ""+CRLF+'    for (i=3D0;i<iCellCount;i++)
	cTabela += ""+CRLF+'     szHTML+=3D"<td height=3D1></td>";
	cTabela += ""+CRLF+'   } else if (iRow=3D=3D4) {
	cTabela += ""+CRLF+'    for (i=3D0;i<c_lTabs;i++)
	cTabela += ""+CRLF+'     szHTML+=3D"<td height=3D1 width=3D1></td><td height=3D1></td>";
	cTabela += ""+CRLF+'    szHTML+=3D"<td height=3D1 width=3D1></td><td></td>";
	cTabela += ""+CRLF+'   }
	cTabela += ""+CRLF+'  }
	cTabela += ""+CRLF+'  szHTML+=3D"</tr>";
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' szHTML+=3D"</table></body></html>";
	cTabela += ""+CRLF+" with (frames['frTabs'].document) {
	cTabela += ""+CRLF+'  open("text/html","replace");
	cTabela += ""+CRLF+'  charset=3Ddocument.charset;
	cTabela += ""+CRLF+'  write(szHTML);
	cTabela += ""+CRLF+'  close();
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnInit()
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' g_rglTabX[0]=3D0;
	cTabela += ""+CRLF+' var i;
	cTabela += ""+CRLF+' for (i=3D1;i<=3Dc_lTabs;i++)
	cTabela += ""+CRLF+"  with (frames['frTabs'].document.all.tbTabs.rows[1].cells[fnTabToCol(i-1)])
	cTabela += ""+CRLF+'   g_rglTabX[i]=3DoffsetLeft+offsetWidth-6;
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnTabToCol(iTab)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' return 2*iTab+1;
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnNextTab(fDir)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' var iNextTab=3D-1;
	cTabela += ""+CRLF+' var i;
	cTabela += ""+CRLF
	cTabela += ""+CRLF+" with (frames['frTabs'].document.body) {
	cTabela += ""+CRLF+'  if (fDir=3D=3D0) {
	cTabela += ""+CRLF+'   if (scrollLeft>0) {
	cTabela += ""+CRLF+'    for (i=3D0;i<c_lTabs&&g_rglTabX[i]<scrollLeft;i++);
	cTabela += ""+CRLF+'    if (i<c_lTabs)
	cTabela += ""+CRLF+'     iNextTab=3Di-1;
	cTabela += ""+CRLF+'   }
	cTabela += ""+CRLF+'  } else {
	cTabela += ""+CRLF+'   if (g_rglTabX[c_lTabs]+6>offsetWidth+scrollLeft) {
	cTabela += ""+CRLF+'    for (i=3D0;i<c_lTabs&&g_rglTabX[i]<=3DscrollLeft;i++);
	cTabela += ""+CRLF+'    if (i<c_lTabs)
	cTabela += ""+CRLF+'     iNextTab=3Di;
	cTabela += ""+CRLF+'   }
	cTabela += ""+CRLF+'  }
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF+' return iNextTab;
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnScrollTabs(fDir)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' var iNextTab=3DfnNextTab(fDir);
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' if (iNextTab>=3D0) {
	cTabela += ""+CRLF+"  frames['frTabs'].scroll(g_rglTabX[iNextTab],0);
	cTabela += ""+CRLF+'  return true;
	cTabela += ""+CRLF+' } else
	cTabela += ""+CRLF+'  return false;
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnFastScrollTabs(fDir)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' if (c_lTabs>16)
	cTabela += ""+CRLF+"  frames['frTabs'].scroll(g_rglTabX[fDir?c_lTabs-1:0],0);
	cTabela += ""+CRLF+' else
	cTabela += ""+CRLF+'  if (fnScrollTabs(fDir)>0) window.setTimeout("fnFastScrollTabs("+fDir+");"=
	cTabela += ""+CRLF+',5);
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnSetTabProps(iTab,fActive)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' var iCol=3DfnTabToCol(iTab);
	cTabela += ""+CRLF+' var i;
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' if (iTab>=3D0) {
	cTabela += ""+CRLF+"  with (frames['frTabs'].document.all) {
	cTabela += ""+CRLF+'   with (tbTabs) {
	cTabela += ""+CRLF+'    for (i=3D0;i<=3D4;i++) {
	cTabela += ""+CRLF+'     with (rows[i]) {
	cTabela += ""+CRLF+'      if (i=3D=3D0)
	cTabela += ""+CRLF+'       cells[iCol].style.background=3Dc_rgszClr[fActive?0:2];
	cTabela += ""+CRLF+'      else if (i>0 && i<4) {
	cTabela += ""+CRLF+'       if (fActive) {
	cTabela += ""+CRLF+'        cells[iCol-1].style.background=3Dc_rgszClr[2];
	cTabela += ""+CRLF+'        cells[iCol].style.background=3Dc_rgszClr[0];
	cTabela += ""+CRLF+'        cells[iCol+1].style.background=3Dc_rgszClr[2];
	cTabela += ""+CRLF+'       } else {
	cTabela += ""+CRLF+'        if (i=3D=3D1) {
	cTabela += ""+CRLF+'         cells[iCol-1].style.background=3Dc_rgszClr[2];
	cTabela += ""+CRLF+'         cells[iCol].style.background=3Dc_rgszClr[1];
	cTabela += ""+CRLF+'         cells[iCol+1].style.background=3Dc_rgszClr[2];
	cTabela += ""+CRLF+'        } else {
	cTabela += ""+CRLF+'         cells[iCol-1].style.background=3Dc_rgszClr[4];
	cTabela += ""+CRLF+'         cells[iCol].style.background=3Dc_rgszClr[(i=3D=3D2)?2:4];
	cTabela += ""+CRLF+'         cells[iCol+1].style.background=3Dc_rgszClr[4];
	cTabela += ""+CRLF+'        }
	cTabela += ""+CRLF+'       }
	cTabela += ""+CRLF+'      } else
	cTabela += ""+CRLF+'       cells[iCol].style.background=3Dc_rgszClr[fActive?2:4];
	cTabela += ""+CRLF+'     }
	cTabela += ""+CRLF+'    }
	cTabela += ""+CRLF+'   }
	cTabela += ""+CRLF+'   with (aTab[iTab].style) {
	cTabela += ""+CRLF+'    cursor=3D(fActive?"default":"hand");
	cTabela += ""+CRLF+'    color=3Dc_rgszClr[3];
	cTabela += ""+CRLF+'   }
	cTabela += ""+CRLF+'  }
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnMouseOverScroll(iCtl)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+" frames['frScroll'].document.all.tdScroll[iCtl].style.color=3Dc_rgszClr[7];
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnMouseOutScroll(iCtl)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+" frames['frScroll'].document.all.tdScroll[iCtl].style.color=3Dc_rgszClr[6];
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnMouseOverTab(iTab)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' if (iTab!=3Dg_iShCur) {
	cTabela += ""+CRLF+'  var iCol=3DfnTabToCol(iTab);
	cTabela += ""+CRLF+"  with (frames['frTabs'].document.all) {
	cTabela += ""+CRLF+'   tdTab[iTab].style.background=3Dc_rgszClr[5];
	cTabela += ""+CRLF+'  }
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnMouseOutTab(iTab)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' if (iTab>=3D0) {
	cTabela += ""+CRLF+"  var elFrom=3Dframes['frTabs'].event.srcElement;
	cTabela += ""+CRLF+"  var elTo=3Dframes['frTabs'].event.toElement;
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'  if ((!elTo) ||
	cTabela += ""+CRLF+'   (elFrom.tagName=3D=3DelTo.tagName) ||
	cTabela += ""+CRLF+'   (elTo.tagName=3D=3D"A" && elTo.parentElement!=3DelFrom) ||
	cTabela += ""+CRLF+'   (elFrom.tagName=3D=3D"A" && elFrom.parentElement!=3DelTo)) {
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'   if (iTab!=3Dg_iShCur) {
	cTabela += ""+CRLF+"    with (frames['frTabs'].document.all) {
	cTabela += ""+CRLF+'     tdTab[iTab].style.background=3Dc_rgszClr[1];
	cTabela += ""+CRLF+'    }
	cTabela += ""+CRLF+'   }
	cTabela += ""+CRLF+'  }
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'function fnSetActiveSheet(iSh)
	cTabela += ""+CRLF+'{
	cTabela += ""+CRLF+' if (iSh!=3Dg_iShCur) {
	cTabela += ""+CRLF+'  fnSetTabProps(g_iShCur,false);
	cTabela += ""+CRLF+'  fnSetTabProps(iSh,true);
	cTabela += ""+CRLF+'  g_iShCur=3DiSh;
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' window.g_iIEVer=3DfnGetIEVer();
	cTabela += ""+CRLF+' if (window.g_iIEVer>=3D4)
	cTabela += ""+CRLF+'  fnBuildFrameset();
	cTabela += ""+CRLF+'//-->
	cTabela += ""+CRLF+'</script>
	cTabela += ""+CRLF+'<![endif]><!--[if gte mso 9]><xml>
	cTabela += ""+CRLF+' <x:ExcelWorkbook>
	cTabela += ""+CRLF+'  <x:ExcelWorksheets>
	cTabela += ""+CRLF+'   <x:ExcelWorksheet>
	cTabela += ""+CRLF+'    <x:Name>Par&#226;metros</x:Name>
	cTabela += ""+CRLF+'    <x:WorksheetSource HRef=3D"GJP_Fluxo_Caixa_mhtml_arquivos/sheet001.htm"=
	cTabela += ""+CRLF+'/>
	cTabela += ""+CRLF+'   </x:ExcelWorksheet>
	cTabela += ""+CRLF+'   <x:ExcelWorksheet>
	cTabela += ""+CRLF+'    <x:Name>Fluxo de Caixa</x:Name>
	cTabela += ""+CRLF+'    <x:WorksheetSource HRef=3D"GJP_Fluxo_Caixa_mhtml_arquivos/sheet002.htm"=
	cTabela += ""+CRLF+'/>
	cTabela += ""+CRLF+'   </x:ExcelWorksheet>
	cTabela += ""+CRLF+'  </x:ExcelWorksheets>
	cTabela += ""+CRLF+'  <x:Stylesheet HRef=3D"GJP_Fluxo_Caixa_mhtml_arquivos/stylesheet.css"/>
	cTabela += ""+CRLF+'  <x:WindowHeight>7935</x:WindowHeight>
	cTabela += ""+CRLF+'  <x:WindowWidth>19995</x:WindowWidth>
	cTabela += ""+CRLF+'  <x:WindowTopX>240</x:WindowTopX>
	cTabela += ""+CRLF+'  <x:WindowTopY>105</x:WindowTopY>
	cTabela += ""+CRLF+'  <x:ActiveSheet>1</x:ActiveSheet>
	cTabela += ""+CRLF+'  <x:ProtectStructure>False</x:ProtectStructure>
	cTabela += ""+CRLF+'  <x:ProtectWindows>False</x:ProtectWindows>
	cTabela += ""+CRLF+' </x:ExcelWorkbook>
	cTabela += ""+CRLF+'</xml><![endif]-->
	cTabela += ""+CRLF+'</head>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<frameset rows=3D"*,39" border=3D0 width=3D0 frameborder=3Dno framespacing=
	cTabela += ""+CRLF+'=3D0>
	cTabela += ""+CRLF+' <frame src=3D"GJP_Fluxo_Caixa_mhtml_arquivos/sheet002.htm" name=3D"frSheet=
	cTabela += ""+CRLF+'">
	cTabela += ""+CRLF+' <frame src=3D"GJP_Fluxo_Caixa_mhtml_arquivos/tabstrip.htm" name=3D"frTabs"=
	cTabela += ""+CRLF+' marginwidth=3D0 marginheight=3D0>
	cTabela += ""+CRLF+' <noframes>
	cTabela += ""+CRLF+'  <body>
	cTabela += ""+CRLF+'   <p>Esta p&aacute;gina usa quadros, mas o seu navegador n&atilde;o d&aacu=
	cTabela += ""+CRLF+'te; suporte para eles.</p>
	cTabela += ""+CRLF+'  </body>
	cTabela += ""+CRLF+' </noframes>
	cTabela += ""+CRLF+'</frameset>
	cTabela += ""+CRLF+'</html>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'------=_NextPart_01D01EA8.0A093920
	cTabela += ""+CRLF+'Content-Location: file:///C:/0505DE0C/GJP_Fluxo_Caixa_mhtml_arquivos/stylesheet.css
	cTabela += ""+CRLF+'Content-Transfer-Encoding: quoted-printable
	cTabela += ""+CRLF+'Content-Type: text/css; charset="us-ascii"
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'tr
	cTabela += ""+CRLF+'	{mso-height-source:auto;}
	cTabela += ""+CRLF+'col
	cTabela += ""+CRLF+'	{mso-width-source:auto;}
	cTabela += ""+CRLF+'br
	cTabela += ""+CRLF+'	{mso-data-placement:same-cell;}
	cTabela += ""+CRLF+'.style0
	cTabela += ""+CRLF+'	{mso-number-format:General;
	cTabela += ""+CRLF+'	text-align:general;
	cTabela += ""+CRLF+'	vertical-align:bottom;
	cTabela += ""+CRLF+'	white-space:nowrap;
	cTabela += ""+CRLF+'	mso-rotate:0;
	cTabela += ""+CRLF+'	mso-background-source:auto;
	cTabela += ""+CRLF+'	mso-pattern:auto;
	cTabela += ""+CRLF+'	color:black;
	cTabela += ""+CRLF+'	font-size:11.0pt;
	cTabela += ""+CRLF+'	font-weight:400;
	cTabela += ""+CRLF+'	font-style:normal;
	cTabela += ""+CRLF+'	text-decoration:none;
	cTabela += ""+CRLF+'	font-family:Calibri, sans-serif;
	cTabela += ""+CRLF+'	mso-font-charset:0;
	cTabela += ""+CRLF+'	border:none;
	cTabela += ""+CRLF+'	mso-protection:locked visible;
	cTabela += ""+CRLF+'	mso-style-name:Normal;
	cTabela += ""+CRLF+'	mso-style-id:0;}
	cTabela += ""+CRLF+'.style57
	cTabela += ""+CRLF+'	{color:windowtext;
	cTabela += ""+CRLF+'	font-size:8.0pt;
	cTabela += ""+CRLF+'	font-weight:400;
	cTabela += ""+CRLF+'	font-style:normal;
	cTabela += ""+CRLF+'	text-decoration:none;
	cTabela += ""+CRLF+'	font-family:"Courier New";
	cTabela += ""+CRLF+'	mso-generic-font-family:auto;
	cTabela += ""+CRLF+'	mso-font-charset:0;
	cTabela += ""+CRLF+'	mso-style-name:"Normal 2";}
	cTabela += ""+CRLF+'td
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	padding-top:1px;
	cTabela += ""+CRLF+'	padding-right:1px;
	cTabela += ""+CRLF+'	padding-left:1px;
	cTabela += ""+CRLF+'	mso-ignore:padding;
	cTabela += ""+CRLF+'	color:black;
	cTabela += ""+CRLF+'	font-size:11.0pt;
	cTabela += ""+CRLF+'	font-weight:400;
	cTabela += ""+CRLF+'	font-style:normal;
	cTabela += ""+CRLF+'	text-decoration:none;
	cTabela += ""+CRLF+'	font-family:Calibri, sans-serif;
	cTabela += ""+CRLF+'	mso-font-charset:0;
	cTabela += ""+CRLF+'	mso-number-format:General;
	cTabela += ""+CRLF+'	text-align:general;
	cTabela += ""+CRLF+'	vertical-align:bottom;
	cTabela += ""+CRLF+'	border:none;
	cTabela += ""+CRLF+'	mso-background-source:auto;
	cTabela += ""+CRLF+'	mso-pattern:auto;
	cTabela += ""+CRLF+'	mso-protection:locked visible;
	cTabela += ""+CRLF+'	white-space:nowrap;
	cTabela += ""+CRLF+'	mso-rotate:0;}
	cTabela += ""+CRLF+'.xl66
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	mso-number-format:"dd\/mm\/yy\;\@";}
	cTabela += ""+CRLF+'.xl67
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	mso-number-format:"\#\,\#\#0\.00\;\[Red\]\#\,\#\#0\.00";}
	cTabela += ""+CRLF+'.xl68
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	font-weight:700;
	cTabela += ""+CRLF+'	mso-number-format:"dd\/mm\/yy\;\@";
	cTabela += ""+CRLF+'	border:.5pt solid windowtext;
	cTabela += ""+CRLF+'	background:#C5D9F1;
	cTabela += ""+CRLF+'	mso-pattern:black none;}
	cTabela += ""+CRLF+'.xl69
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	border:.5pt solid windowtext;}
	cTabela += ""+CRLF+'.xl70
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	mso-number-format:"\#\,\#\#0\.00\;\[Red\]\#\,\#\#0\.00";
	cTabela += ""+CRLF+'	border:.5pt solid windowtext;}
	cTabela += ""+CRLF+'.xl71
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	font-weight:700;
	cTabela += ""+CRLF+'	border:.5pt solid windowtext;}
	cTabela += ""+CRLF+'.xl72
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	border-top:none;
	cTabela += ""+CRLF+'	border-right:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-bottom:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-left:.5pt solid windowtext;}
	cTabela += ""+CRLF+'.xl73
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	mso-number-format:"\#\,\#\#0\.00\;\[Red\]\#\,\#\#0\.00";
	cTabela += ""+CRLF+'	border-top:none;
	cTabela += ""+CRLF+'	border-right:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-bottom:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-left:.5pt solid windowtext;}
	cTabela += ""+CRLF+'.xl74
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	font-weight:700;
	cTabela += ""+CRLF+'	border-top:1.0pt solid windowtext;
	cTabela += ""+CRLF+'	border-right:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-bottom:1.0pt solid windowtext;
	cTabela += ""+CRLF+'	border-left:1.0pt solid windowtext;}
	cTabela += ""+CRLF+'.xl75
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	mso-number-format:"\#\,\#\#0\.00\;\[Red\]\#\,\#\#0\.00";
	cTabela += ""+CRLF+'	border-top:1.0pt solid windowtext;
	cTabela += ""+CRLF+'	border-right:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-bottom:1.0pt solid windowtext;
	cTabela += ""+CRLF+'	border-left:.5pt solid windowtext;}
	cTabela += ""+CRLF+'.xl76
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	mso-number-format:"\#\,\#\#0\.00\;\[Red\]\#\,\#\#0\.00";
	cTabela += ""+CRLF+'	border-top:1.0pt solid windowtext;
	cTabela += ""+CRLF+'	border-right:1.0pt solid windowtext;
	cTabela += ""+CRLF+'	border-bottom:1.0pt solid windowtext;
	cTabela += ""+CRLF+'	border-left:.5pt solid windowtext;}
	cTabela += ""+CRLF+'.xl77
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	font-weight:700;
	cTabela += ""+CRLF+'	border-top:none;
	cTabela += ""+CRLF+'	border-right:none;
	cTabela += ""+CRLF+'	border-bottom:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-left:none;}
	cTabela += ""+CRLF+'.xl78
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	mso-number-format:"\#\,\#\#0\.00\;\[Red\]\#\,\#\#0\.00";
	cTabela += ""+CRLF+'	border-top:none;
	cTabela += ""+CRLF+'	border-right:none;
	cTabela += ""+CRLF+'	border-bottom:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-left:none;}
	cTabela += ""+CRLF+'.xl79
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	font-weight:700;
	cTabela += ""+CRLF+'	font-style:italic;}
	cTabela += ""+CRLF+'.xl80
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	font-weight:700;
	cTabela += ""+CRLF+'	border-top:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-right:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-bottom:none;
	cTabela += ""+CRLF+'	border-left:.5pt solid windowtext;}
	/*
	cTabela += ""+CRLF+'.xl81
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	border-top:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-right:none;
	cTabela += ""+CRLF+'	border-bottom:none;
	cTabela += ""+CRLF+'	border-left:none;}    
	*/
	cTabela += ""+CRLF+'	.xl81
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'		font-weight:700;
	cTabela += ""+CRLF+'	mso-number-format:"dd\/mm\/yy\;\@";
	cTabela += ""+CRLF+'		text-align:center;
	cTabela += ""+CRLF+'		vertical-align:middle;
	cTabela += ""+CRLF+'		border-top:.5pt solid windowtext;
	cTabela += ""+CRLF+'		border-right:.5pt solid windowtext;
	cTabela += ""+CRLF+'		border-bottom:.5pt solid windowtext;
	cTabela += ""+CRLF+'		border-left:none;
	cTabela += ""+CRLF+'		background:#C5D9F1;
	cTabela += ""+CRLF+'		mso-pattern:black none;}
	
	cTabela += ""+CRLF+'.xl82
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	font-weight:700;
	cTabela += ""+CRLF+'	border:.5pt solid windowtext;
	cTabela += ""+CRLF+'	background:#C5D9F1;
	cTabela += ""+CRLF+'	mso-pattern:black none;
	cTabela += ""+CRLF+'	white-space:normal;}
	cTabela += ""+CRLF+'.xl83
	cTabela += ""+CRLF+'	{mso-style-parent:style57;
	cTabela += ""+CRLF+'	color:windowtext;
	cTabela += ""+CRLF+'	font-family:Arial;
	cTabela += ""+CRLF+'	mso-generic-font-family:auto;
	cTabela += ""+CRLF+'	mso-font-charset:0;
	cTabela += ""+CRLF+'	text-align:center;}
	cTabela += ""+CRLF+'.xl84
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	text-align:center;}
	cTabela += ""+CRLF+'.xl85
	cTabela += ""+CRLF+'	{mso-style-parent:style57;
	cTabela += ""+CRLF+'	color:windowtext;
	cTabela += ""+CRLF+'	font-size:8.0pt;
	cTabela += ""+CRLF+'	font-family:"Courier New";
	cTabela += ""+CRLF+'	mso-generic-font-family:auto;
	cTabela += ""+CRLF+'	mso-font-charset:0;
	cTabela += ""+CRLF+'	text-align:center;}
	cTabela += ""+CRLF+'.xl86
	cTabela += ""+CRLF+'	{mso-style-parent:style57;
	cTabela += ""+CRLF+'	color:windowtext;
	cTabela += ""+CRLF+'	font-family:Arial;
	cTabela += ""+CRLF+'	mso-generic-font-family:auto;
	cTabela += ""+CRLF+'	mso-font-charset:0;}
	cTabela += ""+CRLF+'.xl87
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	font-weight:700;
	cTabela += ""+CRLF+'	text-align:center;
	cTabela += ""+CRLF+'	vertical-align:middle;
	cTabela += ""+CRLF+'	border-top:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-right:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-bottom:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-left:none;
	cTabela += ""+CRLF+'	background:#C5D9F1;
	cTabela += ""+CRLF+'	mso-pattern:black none;
	cTabela += ""+CRLF+'	white-space:normal;}  
	cTabela += ""+CRLF+'.xl88
	cTabela += ""+CRLF+'	{mso-style-parent:style0;
	cTabela += ""+CRLF+'	border-top:.5pt solid windowtext;
	cTabela += ""+CRLF+'	border-right:none;
	cTabela += ""+CRLF+'	border-bottom:none;
	cTabela += ""+CRLF+'	border-left:none;}    
	
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'------=_NextPart_01D01EA8.0A093920
	cTabela += ""+CRLF+'Content-Location: file:///C:/0505DE0C/GJP_Fluxo_Caixa_mhtml_arquivos/tabstrip.htm
	cTabela += ""+CRLF+'Content-Transfer-Encoding: quoted-printable
	cTabela += ""+CRLF+'Content-Type: text/html; charset="us-ascii"
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<html>
	cTabela += ""+CRLF+'<head>
	cTabela += ""+CRLF+'<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
	cTabela += ""+CRLF+'<meta name=3DProgId content=3DExcel.Sheet>
	cTabela += ""+CRLF+'<meta name=3DGenerator content=3D"Microsoft Excel 12">
	cTabela += ""+CRLF+'<link id=3DMain-File rel=3DMain-File href=3D"../GJP_Fluxo_Caixa_mhtml.htm">
	cTabela += ""+CRLF+'<![if IE]>
	cTabela += ""+CRLF+'<base href=3D"file:///C:\0505DE0C\GJP_Fluxo_Caixa_mhtml_arquivos\tabstrip.h=
	cTabela += ""+CRLF+'tm"
	cTabela += ""+CRLF+'id=3D"webarch_temp_base_tag">
	cTabela += ""+CRLF+'<![endif]>
	cTabela += ""+CRLF+'<script language=3D"JavaScript">
	cTabela += ""+CRLF+'<!--
	cTabela += ""+CRLF+'if (window.name!=3D"frTabs")
	cTabela += ""+CRLF+' window.location.replace(document.all.item("Main-File").href);
	cTabela += ""+CRLF+'//-->
	cTabela += ""+CRLF+'</script>
	cTabela += ""+CRLF+'<style>
	cTabela += ""+CRLF+'<!--
	cTabela += ""+CRLF+'A {
	cTabela += ""+CRLF+'    text-decoration:none;
	cTabela += ""+CRLF+'    color:#000000;
	cTabela += ""+CRLF+'    font-size:9pt;
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF+'-->
	cTabela += ""+CRLF+'</style>
	cTabela += ""+CRLF+'</head>
	cTabela += ""+CRLF+'<body topmargin=3D0 leftmargin=3D0 bgcolor=3D"#808080">
	cTabela += ""+CRLF+'<table border=3D0 cellspacing=3D1>
	cTabela += ""+CRLF+' <tr>
	cTabela += ""+CRLF+' <td bgcolor=3D"#FFFFFF" nowrap><b><small><small>&nbsp;<a href=3D"sheet001.=
	cTabela += ""+CRLF+'htm" target=3D"frSheet"><font face=3D"Arial" color=3D"#000000">Par&acirc;me=
	cTabela += ""+CRLF+'tros</font></a>&nbsp;</small></small></b></td>
	cTabela += ""+CRLF+' <td bgcolor=3D"#FFFFFF" nowrap><b><small><small>&nbsp;<a href=3D"sheet002.=
	cTabela += ""+CRLF+'htm" target=3D"frSheet"><font face=3D"Arial" color=3D"#000000">Fluxo de Cai=
	cTabela += ""+CRLF+'xa</font></a>&nbsp;</small></small></b></td>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+'</table>
	cTabela += ""+CRLF+'</body>
	cTabela += ""+CRLF+'</html>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'------=_NextPart_01D01EA8.0A093920
	cTabela += ""+CRLF+'Content-Location: file:///C:/0505DE0C/GJP_Fluxo_Caixa_mhtml_arquivos/sheet001.htm
	cTabela += ""+CRLF+'Content-Transfer-Encoding: quoted-printable
	cTabela += ""+CRLF+'Content-Type: text/html; charset="us-ascii"
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<html xmlns:o=3D"urn:schemas-microsoft-com:office:office"
	cTabela += ""+CRLF+'xmlns:x=3D"urn:schemas-microsoft-com:office:excel"
	cTabela += ""+CRLF+'xmlns=3D"http://www.w3.org/TR/REC-html40">
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<head>
	cTabela += ""+CRLF+'<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
	cTabela += ""+CRLF+'<meta name=3DProgId content=3DExcel.Sheet>
	cTabela += ""+CRLF+'<meta name=3DGenerator content=3D"Microsoft Excel 12">
	cTabela += ""+CRLF+'<link id=3DMain-File rel=3DMain-File href=3D"../GJP_Fluxo_Caixa_mhtml.htm">
	cTabela += ""+CRLF+'<link rel=3DFile-List href=3Dfilelist.xml>
	cTabela += ""+CRLF+'<![if IE]>
	cTabela += ""+CRLF+'<base href=3D"file:///C:\0505DE0C\GJP_Fluxo_Caixa_mhtml_arquivos\sheet001.h=
	cTabela += ""+CRLF+'tm"
	cTabela += ""+CRLF+'id=3D"webarch_temp_base_tag">
	cTabela += ""+CRLF+'<![endif]>
	cTabela += ""+CRLF+'<link rel=3DStylesheet href=3Dstylesheet.css>
	cTabela += ""+CRLF+'<style>
	cTabela += ""+CRLF+'<!--table
	cTabela += ""+CRLF+'	{mso-displayed-decimal-separator:"\.";
	cTabela += ""+CRLF+'	mso-displayed-thousand-separator:"\,";}
	cTabela += ""+CRLF+'@page
	cTabela += ""+CRLF+'	{margin:.79in .51in .79in .51in;
	cTabela += ""+CRLF+'	mso-header-margin:.31in;
	cTabela += ""+CRLF+'	mso-footer-margin:.31in;}
	cTabela += ""+CRLF+'-->
	cTabela += ""+CRLF+'</style>
	cTabela += ""+CRLF+'<![if !supportTabStrip]><script language=3D"JavaScript">
	cTabela += ""+CRLF+'<!--
	cTabela += ""+CRLF+'function fnUpdateTabs()
	cTabela += ""+CRLF+' {
	cTabela += ""+CRLF+'  if (parent.window.g_iIEVer>=3D4) {
	cTabela += ""+CRLF+'   if (parent.document.readyState=3D=3D"complete"
	cTabela += ""+CRLF+"    && parent.frames['frTabs']"+'.document.readyState=3D=3D"complete")
	cTabela += ""+CRLF+'   parent.fnSetActiveSheet(0);
	cTabela += ""+CRLF+'  else
	cTabela += ""+CRLF+'   window.setTimeout("fnUpdateTabs();",150);
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'if (window.name!=3D"frSheet")
	cTabela += ""+CRLF+' window.location.replace("../GJP_Fluxo_Caixa_mhtml.htm");
	cTabela += ""+CRLF+'else
	cTabela += ""+CRLF+' fnUpdateTabs();
	cTabela += ""+CRLF+'//-->
	cTabela += ""+CRLF+'</script>
	cTabela += ""+CRLF+'<![endif]>
	cTabela += ""+CRLF+'</head>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<body link=3Dblue vlink=3Dpurple>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+"<table border=3D0 cellpadding=3D0 cellspacing=3D0 width=3D507 style=3D'bord=
	cTabela += ""+CRLF+'er-collapse:
	cTabela += ""+CRLF+" collapse;table-layout:fixed;width:381pt'>
	cTabela += ""+CRLF+" <col width=3D326 style=3D'mso-width-source:userset;mso-width-alt:11922;wid=
	cTabela += ""+CRLF+"th:245pt'>
	cTabela += ""+CRLF+" <col class=3Dxl84 width=3D181 style=3D'mso-width-source:userset;mso-width-=
	cTabela += ""+CRLF+'alt:6619;
	cTabela += ""+CRLF+" width:136pt'>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 width=3D326 style=3D'height:15.0pt;width:245=
	cTabela += ""+CRLF+"pt'>Dt.Ref:
	cTabela += ""+CRLF+'  '+substr(DTOS(ddatabase),7,2)+"/"+substr(DTOS(ddatabase),5,2)+"/"+substr(DTOS(ddatabase),1,4)+'</td>
	cTabela += ""+CRLF+"  <td class=3Dxl85 width=3D181 style=3D'width:136pt'></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+'  <td class=3Dxl84></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Hora: "+time()+"</td>
	cTabela += ""+CRLF+'  <td class=3Dxl85></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+'  <td class=3Dxl84></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Parametros<=
	cTabela += ""+CRLF+'/td>
	cTabela += ""+CRLF+'  <td class=3Dxl85></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+'  <td class=3Dxl84></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+'  <td class=3Dxl84></td>
	cTabela += ""+CRLF+' </tr>
	
	//Perguntas
  /*	For i:= 1 to Len(aRegs)
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta "+strzero(i,2)+": "+alltrim(aRegs[i][3])+"</td>
		If valtype(&("MV_PAR"+strzero(i,2))) == "N"
			
			If i == 1
				cTabela += ""+CRLF+"  <td class=3Dxl83>"+iif( (&("MV_PAR"+strzero(i,2))) == 1, "Sintetico","Analitico")  +"</td>"
			ElseIf (i == 8 .or. i == 9 .or. i == 10 .or. i == 11)
				cTabela += ""+CRLF+"  <td class=3Dxl83>"+iif( (&("MV_PAR"+strzero(i,2))) == 1, "Sim","N„o")+"</td>"
			Else
				cTabela += ""+CRLF+"  <td class=3Dxl83>"+str(&("MV_PAR"+strzero(i,2)))+"</td>"
			EndIf
			
		ElseIf valtype(&("MV_PAR"+strzero(i,2))) == "D"
			cTabela += ""+CRLF+"  <td class=3Dxl83>"+substr( DTOS(&("MV_PAR"+strzero(i,2))) ,7,2)+"/"+substr( DTOS(&("MV_PAR"+strzero(i,2))) ,5,2)+"/"+substr( DTOS(&("MV_PAR"+strzero(i,2))) ,1,4)+"</td>"
		Else
			cTabela += ""+CRLF+"  <td class=3Dxl83>"+&("MV_PAR"+strzero(i,2))+"</td>"
		EndIf
		
		cTabela += ""+CRLF+' </tr>
	Next i
   */
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 01: Sintetico   / Analitico    </td>
		cTabela += ""+CRLF+"  <td class=3Dxl83>"+iif(lfluxSint,"Sintetico","Analitico")+"</td>"
		cTabela += ""+CRLF+' </tr>                                   
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 02: Data de     / Data ate     </td>
		cTabela += ""+CRLF+"  <td class=3Dxl83>"+substr(DTOS(MV_PAR03),7,2)+"/"+substr(DTOS(MV_PAR03),5,2)+"/"+substr(DTOS(MV_PAR03),1,4)+" a "+substr(DTOS(MV_PAR04),7,2)+"/"+substr(DTOS(MV_PAR04),5,2)+"/"+substr(DTOS(MV_PAR04),1,4)+"</td>"
		cTabela += ""+CRLF+' </tr>                                   
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>

		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 03: Natureza de / Natureza ate </td>
		cTabela += ""+CRLF+"  <td class=3Dxl83>'"+MV_PAR01+"' a '"+MV_PAR02+"'</td>"		
		cTabela += ""+CRLF+' </tr>                                   
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>

		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 04: Considera Pedido de Venda  </td>
		cTabela += ""+CRLF+"  <td class=3Dxl83>"+iif(MV_PAR06,"Sim","Nao")+"</td>"		
		cTabela += ""+CRLF+' </tr>                                   
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>

		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 05: Considera Pedido de Compra </td>
		cTabela += ""+CRLF+"  <td class=3Dxl83>"+iif(MV_PAR07,"Sim","Nao")+"</td>"	
		cTabela += ""+CRLF+' </tr>                                   
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>

		if !lfluxSint	
		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 06: Considera Comissoes        </td>
		cTabela += ""+CRLF+"  <td class=3Dxl83>"+iif(MV_PAR16,"Sim","Nao")+"</td>"	
		cTabela += ""+CRLF+' </tr>                                   
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>

		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 07: Seleciona Filiais          </td>
		else
		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 06: Seleciona Filiais          </td>
		EndIf		
		cTabela += ""+CRLF+"  <td class=3Dxl83>"+iif(MV_PAR12,"Sim","Nao")+"</td>"	     
		cTabela += ""+CRLF+' </tr>                                   


	/*
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 02 : At&eac=
	cTabela += ""+CRLF+'ute; o
	cTabela += ""+CRLF+'  N&uacute;mero ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>999999</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 03 : Imprim=
	cTabela += ""+CRLF+'e ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>Todos</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 04 : A part=
	cTabela += ""+CRLF+'ir de ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>01/01/2013</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 05 : At&eac=
	cTabela += ""+CRLF+'ute; a
	cTabela += ""+CRLF+'  data ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>31/12/2013</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 06 : A part=
	cTabela += ""+CRLF+'ir do Item
	cTabela += ""+CRLF+'  ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>0001</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 07 : At&eac=
	cTabela += ""+CRLF+'ute; o
	cTabela += ""+CRLF+'  Item ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>9999</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 08 : Descri=
	cTabela += ""+CRLF+'cao
	cTabela += ""+CRLF+'  Produto ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>C1_DESCRI</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 09 : Imprim=
	cTabela += ""+CRLF+'e Empenhos
	cTabela += ""+CRLF+'  ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>Nao</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 10 : Utiliza
	cTabela += ""+CRLF+'  Amarracao ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>Produto</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 11 : Impr.Q=
	cTabela += ""+CRLF+'tos
	cTabela += ""+CRLF+'  Ped.Compr ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>5</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 12 : Impr.Q=
	cTabela += ""+CRLF+'tos
	cTabela += ""+CRLF+'  Forneced. ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>3</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl86 style=3D'height:15.0pt'>Pergunta 13 : Consid=
	cTabela += ""+CRLF+'era SCs ?</td>
	cTabela += ""+CRLF+'  <td class=3Dxl83>Firmes</td>
	cTabela += ""+CRLF+' </tr>
	*/
	
	cTabela += ""+CRLF+' <![if supportMisalignedColumns]>
	cTabela += ""+CRLF+" <tr height=3D0 style=3D'display:none'>
	cTabela += ""+CRLF+"  <td width=3D326 style=3D'width:245pt'></td>
	cTabela += ""+CRLF+"  <td width=3D181 style=3D'width:136pt'></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+' <![endif]>
	cTabela += ""+CRLF+'</table>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'</body>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'</html>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'------=_NextPart_01D01EA8.0A093920
	cTabela += ""+CRLF+'Content-Location: file:///C:/0505DE0C/GJP_Fluxo_Caixa_mhtml_arquivos/sheet002.htm
	cTabela += ""+CRLF+'Content-Transfer-Encoding: quoted-printable
	cTabela += ""+CRLF+'Content-Type: text/html; charset="us-ascii"
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<html xmlns:v=3D"urn:schemas-microsoft-com:vml"
	cTabela += ""+CRLF+'xmlns:o=3D"urn:schemas-microsoft-com:office:office"
	cTabela += ""+CRLF+'xmlns:x=3D"urn:schemas-microsoft-com:office:excel"
	cTabela += ""+CRLF+'xmlns=3D"http://www.w3.org/TR/REC-html40">
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<head>
	cTabela += ""+CRLF+'<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
	cTabela += ""+CRLF+'<meta name=3DProgId content=3DExcel.Sheet>
	cTabela += ""+CRLF+'<meta name=3DGenerator content=3D"Microsoft Excel 12">
	cTabela += ""+CRLF+'<link id=3DMain-File rel=3DMain-File href=3D"../GJP_Fluxo_Caixa_mhtml.htm">
	cTabela += ""+CRLF+'<link rel=3DFile-List href=3Dfilelist.xml>
	cTabela += ""+CRLF+'<![if IE]>
	cTabela += ""+CRLF+'<base href=3D"file:///C:\0505DE0C\GJP_Fluxo_Caixa_mhtml_arquivos\sheet002.h=
	cTabela += ""+CRLF+'tm"
	cTabela += ""+CRLF+'id=3D"webarch_temp_base_tag">
	cTabela += ""+CRLF+'<![endif]>
	cTabela += ""+CRLF+'<link rel=3DStylesheet href=3Dstylesheet.css>
	cTabela += ""+CRLF+'<style>
	cTabela += ""+CRLF+'<!--table
	cTabela += ""+CRLF+'	{mso-displayed-decimal-separator:"\.";
	cTabela += ""+CRLF+'	mso-displayed-thousand-separator:"\,";}
	cTabela += ""+CRLF+'@page
	cTabela += ""+CRLF+'	{margin:.79in .51in .79in .51in;
	cTabela += ""+CRLF+'	mso-header-margin:.31in;
	cTabela += ""+CRLF+'	mso-footer-margin:.31in;
	cTabela += ""+CRLF+'	mso-page-orientation:landscape;}
	cTabela += ""+CRLF+'-->
	cTabela += ""+CRLF+'</style>
	cTabela += ""+CRLF+'<![if !supportTabStrip]><script language=3D"JavaScript">
	cTabela += ""+CRLF+'<!--
	cTabela += ""+CRLF+'function fnUpdateTabs()
	cTabela += ""+CRLF+' {
	cTabela += ""+CRLF+'  if (parent.window.g_iIEVer>=3D4) {
	cTabela += ""+CRLF+'   if (parent.document.readyState=3D=3D"complete"
	cTabela += ""+CRLF+"    && parent.frames['frTabs']"+'.document.readyState=3D=3D"complete")
	cTabela += ""+CRLF+'   parent.fnSetActiveSheet(1);
	cTabela += ""+CRLF+'  else
	cTabela += ""+CRLF+'   window.setTimeout("fnUpdateTabs();",150);
	cTabela += ""+CRLF+' }
	cTabela += ""+CRLF+'}
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'if (window.name!=3D"frSheet")
	cTabela += ""+CRLF+' window.location.replace("../GJP_Fluxo_Caixa_mhtml.htm");
	cTabela += ""+CRLF+'else
	cTabela += ""+CRLF+' fnUpdateTabs();
	cTabela += ""+CRLF+'//-->
	cTabela += ""+CRLF+'</script>
	cTabela += ""+CRLF+'<![endif]>
	cTabela += ""+CRLF+'</head>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<body link=3Dblue vlink=3Dpurple>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+"<table border=3D0 cellpadding=3D0 cellspacing=3D0 width=3D690 style=3D'bord=
	cTabela += ""+CRLF+'er-collapse:
	cTabela += ""+CRLF+" collapse;table-layout:fixed;width:518pt'>
	cTabela += ""+CRLF+" <col width=3D242 style=3D'mso-width-source:userset;mso-width-alt:8850;widt=
	cTabela += ""+CRLF+"h:182pt'>
	cTabela += ""+CRLF+" <col class=3Dxl66 width=3D64 span=3D7 style=3D'width:48pt'>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl79 width=3D242 style=3D'height:15.0pt;width:182=
	cTabela += ""+CRLF+"pt'>Fluxo de
	cTabela += ""+CRLF+'  Caixa - Previsto x Realizado</td>
	cTabela += ""+CRLF+"  <td class=3Dxl79 width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td class=3Dxl79 width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td class=3Dxl66 width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td class=3Dxl66 width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td class=3Dxl66 width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td class=3Dxl66 width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td class=3Dxl66 width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl66 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D46 style=3D'mso-height-source:userset;height:34.5pt'>
	
	//Filiais
	///cTabela += ""+CRLF+"  <td height=3D46 class=3Dxl82 width=3D242 style=3D'height:34.5pt;width:182=
	///cTabela += ""+CRLF+"pt'>Filial01<span
	///cTabela += ""+CRLF+"  style=3D'mso-spacerun:yes'>&nbsp; </span>Filial02<br>
	///cTabela += ""+CRLF+'    Filial 03 Filial 04</td>
	If Len(aFiliais) <= 2
		nHeigth := 15
	ElseIf Len(aFiliais) <= 4
		nHeigth := 15*3
	ElseIf Len(aFiliais) <= 6
		nHeigth := 15*4
	ElseIf Len(aFiliais) <= 8
		nHeigth := 15*5
	ElseIf Len(aFiliais) <= 10
		nHeigth := 15*6
	ElseIf Len(aFiliais) <= 12
		nHeigth := 15*7
	ElseIf Len(aFiliais) <= 14
		nHeigth := 15*8
	ElseIf Len(aFiliais) <= 16
		nHeigth := 15*9
	ElseIf Len(aFiliais) <= 18
		nHeigth := 15*10
	ElseIf Len(aFiliais) <= 20
		nHeigth := 15*11
	EndIf
	
//	cTabela += ""+CRLF+"  <td height=3D46 class=3Dxl82 width=3D242 style=3D'height:"+alltrim(str(nHeigth))+"pt;width:182pt'>"
	cTabela += ""+CRLF+"  <td height=3D46 class=3Dxl87 width=3D242 style=3D'height:"+alltrim(str(nHeigth))+"pt;width:182pt'>"
	//cTabela += ""+CRLF+' '
	For i:=1 to Len(aFiliais)
		dbselectarea("SM0")
		dbsetorder(1)
		If dbseek(cEmpAnt+aFiliais[i])
			if i % 2 <> 0
				cTabela += PadR(SM0->M0_FILIAL,15)
			else
				cTabela += " / "+PadR(SM0->M0_FILIAL,15)+"<br>"
			endif
		EndIf
	Next i
	
	cTabela += "</td>
	
	//Datas
/*	For i:=1 to len(aDataImp)
//		cTabela += ""+CRLF+"  <td class=3Dxl68 align=3Dright style=3D'border-left:none'>"+substr(dtos(aDataImp[i]),7,2)+"/"+substr(dtos(aDataImp[i]),5,2)+"/"+substr(dtos(aDataImp[i]),1,4)+"</td>
		cTabela += ""+CRLF+"  <td class=3Dxl81 width:182pt style=3D'border-left:none'>"+substr(dtos(aDataImp[i]),7,2)+"/"+substr(dtos(aDataImp[i]),5,2)+"/"+substr(dtos(aDataImp[i]),1,4)+"</td>
	Next i */
	For i:=3 to len(_aHeader)
	    If !(substr(_aHeader[i],1,2) == "Or")
			cTabela += ""+CRLF+"  <td class=3Dxl81 width:182pt style=3D'border-left:none'>"+_aHeader[i]+"</td>
			aadd(aHeadUse,_aHeader[i])
		EndIf
	Next i 

	oProcess:IncRegua2("Filtrando dados...")

	//cTabela += ""+CRLF+"  <td class=3Dxl68 align=3Dright style=3D'border-left:none'>07/05/14</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl68 align=3Dright style=3D'border-left:none'>08/05/14</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl68 align=3Dright style=3D'border-left:none'>09/05/14</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl68 align=3Dright style=3D'border-left:none'>10/05/14</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl68 align=3Dright style=3D'border-left:none'>11/05/14</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl68 align=3Dright style=3D'border-left:none'>12/05/14</td>
	cTabela += ""+CRLF+"  </tr>
	
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
	
	//Saldo Inicial
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl80 style=3D'height:15.0pt'>Saldo Inicial</td>
	
	//Valores do Saldo Inicial
//	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aSaldoInicial[1][2])+"</td>
	
	_nPrev := 0
	_nReal := 0
         j := 0
	For i:=1 to len(aHeadUse)
	j++
	(cAlias)->(dbgotop())
	While (cAlias)->(!EOF())
	    If alltrim((cAlias)->NAT) == "Saldos iniciais"
	      _nPrev += &("(cAlias)->PREV0"+STRZERO(j,2))
	      _nReal += &("(cAlias)->REAL0"+STRZERO(j,2))
	    EndIf
		(cAlias)->(dbskip()) 
	EndDo
	aAdd(aSaldoInicial,{aHeadUse[i],_nPrev})	
    i++
	aAdd(aSaldoInicial,{aHeadUse[i],_nReal})	
	_nPrev := 0
	_nReal := 0
    Next i
	
	For j:=1 to len(aSaldoInicial)
		cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aSaldoInicial[j][2])+"</td>
	Next j
	

//	If aNatSE1A[i][1] == DTOS(dDataRetro)
//		nSaldoIni += aNatSE1A[i][3]
//	EndIf
//  aAdd(aSaldoInicial,{_dDataRef,(nSaldoIni+_nReceb-_nPagto)})	
	
/*	For i:=1 to len(aDataImp)
		lRet := .T.
		For j:=1 to len(aSaldoInicial)
			If aDataImp[i] == STOD(aSaldoInicial[j][1]) .and. i <> len(aDataImp)
				cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aSaldoInicial[j][2])+"</td>
				lRet := .F.
				j := len(aSaldoInicial)
			EndIf
		Next j
		If lRet  .and. i <> len(aDataImp)
			cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
		EndIf
	Next i      
	                       */
//	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>200.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>300.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>400.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>500.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>600.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>700.00</td>
	cTabela += ""+CRLF+' </tr>
	
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
//	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl81 style=3D'height:15.0pt'>&nbsp;</td>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl88 style=3D'height:15.0pt'>&nbsp;</td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
	
	//Recebimentos
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl71 style=3D'height:15.0pt'>Recebimentos</td>
	//cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	//Totais Recebimentos
	aRecPag := {}
	_nPrev := 0
	_nReal := 0
         j := 0
	For i:=1 to len(aHeadUse)
	j++
	(cAlias)->(dbgotop())
	While (cAlias)->(!EOF())
	    If alltrim((cAlias)->NAT) == "Totais de Entradas"
	      _nPrev += &("(cAlias)->PREV0"+STRZERO(j,2))
	      _nReal += &("(cAlias)->REAL0"+STRZERO(j,2))
	    EndIf
		(cAlias)->(dbskip()) 
	EndDo
	aAdd(aRecPag,{aHeadUse[i],_nPrev})	
    i++
	aAdd(aRecPag,{aHeadUse[i],_nReal})	
	_nPrev := 0
	_nReal := 0
    Next i
  
	For j:=1 to len(aRecPag)
		cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aRecPag[j][2])+"</td>
	Next j
					
/*	For i:=1 to len(aDataImp)
		lRet := .T.
		For j:=1 to len(aRecPag)
			If aDataImp[i] == STOD(aRecPag[j][1])
				cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aRecPag[j][2])+"</td>
				lRet := .F.
				j := len(aRecPag)
			EndIf
		Next j
		If lRet  
			cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
		EndIf
	Next i      
*/
		
//	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>100.00</td>
	/*cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>200.00</td>
	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>300.00</td>
	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>400.00</td>
	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>500.00</td>
	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>600.00</td>
	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>700.00</td>
	*/

aRecebimentos := {}
_nPrev := 0
_nReal := 0
j := 0
(cAlias)->(dbgotop())
While (cAlias)->(!EOF())
	If alltrim((cAlias)->SEQ) == "001" .and. alltrim((cAlias)->NAT) <> "Totais de Entradas"
		For i:=1 to len(aHeadUse)
			j++
			
			_nPrev += &("(cAlias)->PREV0"+STRZERO(j,2))
			_nReal += &("(cAlias)->REAL0"+STRZERO(j,2))
			
			aAdd(aRecebimentos,{aHeadUse[i],(cAlias)->NAT,_nPrev})
			i++
			aAdd(aRecebimentos,{aHeadUse[i],(cAlias)->NAT,_nReal})
			_nPrev := 0
			_nReal := 0
		Next i
	EndIf
	j := 0
	(cAlias)->(dbskip())
EndDo

	
	cTabela += ""+CRLF+' </tr>
	// Informa as naturezas na Situacao Analitico
    
    
///	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>Natureza A</td>
	
	// Valores ref. as Naturezas
///	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>20.00</td>

//	aSort(aRecebimentos,,,{|x,y| x[2] < y[2] })
If !lfluxSint
For x:=1 to len(aRecebimentos)
	cNatureza := aRecebimentos[x][2]
	
	If !empty(cNatureza)
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
		
		//    If substr(cNatureza,1,1) == "0"
		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>'"+cNatureza+"'</td>
		//	Else
		//		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>"+cNatureza+"</td>
		//    EndIf
		//	For i:=1 to len(aDataImp)
		//		lRet := .T.
		//		lOk := .T.
		For j:=1 to len(aRecebimentos)
			If  alltrim(cNatureza) == alltrim(aRecebimentos[j][2])
				//				cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+transform(aRecebimentos[j][3],"@E 999,999,999.99")+"</td>
				cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aRecebimentos[j][3])+"</td>
				//				lRet := .F.
				//				x := j-1
				//				j := len(aPagamentos)
			x:=j
			EndIf
		Next j 
		
		//		If lRet
		//			    cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+transform(0,"@E 999,999,999.99")+"</td>
		//			    cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
		//			If cNatureza <> aRecebimentos[j][2]
		//				x := j-1
		//			EndIf
		//		EndIf
		//	Next i
	EndIf
	/*
	While x <= len(aRecebimentos) .and. lOk
	If cNatureza == aRecebimentos[x][2]
	x++
	lOk := .T.
	Else
	lOk := .F.
	x--
	EndIf
	EndDo
	*/
	cTabela += ""+CRLF+' </tr>
Next x
EndIf   
 
//	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>30.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>40.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>50.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>60.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>70.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>80.00</td>
//	cTabela += ""+CRLF+' </tr>
	
	//Natureza B
///	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
///	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl69 style=3D'height:15.0pt;border-top:none'>Natu=
///	cTabela += ""+CRLF+'reza B</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
///	cTabela += ""+CRLF+'>20.00</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
///	cTabela += ""+CRLF+'>30.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>40.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>50.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>60.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>70.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>80.00</td>
///	cTabela += ""+CRLF+' </tr>
	
	//Natureza C
///	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
///	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl69 style=3D'height:15.0pt;border-top:none'>Natu=
///	cTabela += ""+CRLF+'reza C</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
///	cTabela += ""+CRLF+'>20.00</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
///	cTabela += ""+CRLF+'>30.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>40.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>50.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>60.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>70.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>80.00</td>
///	cTabela += ""+CRLF+' </tr>
	
	//Pagamentos
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl71 style=3D'height:15.0pt'>Pagamentos</td>

	aRecPag := {}
	_nPrev := 0
	_nReal := 0
         j := 0
	For i:=1 to len(aHeadUse)
	j++
	(cAlias)->(dbgotop())
	While (cAlias)->(!EOF())
	    If alltrim((cAlias)->NAT) == "Totais de SaÌdas"
	      _nPrev += &("(cAlias)->PREV0"+STRZERO(j,2))
	      _nReal += &("(cAlias)->REAL0"+STRZERO(j,2))
	    EndIf
		(cAlias)->(dbskip()) 
	EndDo
	aAdd(aRecPag,{aHeadUse[i],_nPrev})	
    i++
	aAdd(aRecPag,{aHeadUse[i],_nReal})	
	_nPrev := 0
	_nReal := 0
    Next i

	For j:=1 to len(aRecPag)
		cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aRecPag[j][2])+"</td>
	Next j

/*	For i:=1 to len(aDataImp)
		lRet := .T.
		For j:=1 to len(aRecPag)
			If aDataImp[i] == STOD(aRecPag[j][1])
				cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aRecPag[j][3])+"</td>
				lRet := .F.
				j := len(aRecPag)
			EndIf
		Next j
		If lRet  
			cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
		EndIf
	Next i      
*/	
//	cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
//	cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	cTabela += ""+CRLF+' </tr>

aPagamentos := {}
_nPrev := 0
_nReal := 0
j := 0
(cAlias)->(dbgotop())
While (cAlias)->(!EOF())
	If alltrim((cAlias)->SEQ) == "002"  .and. alltrim((cAlias)->NAT) <> "Totais de SaÌdas"
		For i:=1 to len(aHeadUse)
			j++
			_nPrev += &("(cAlias)->PREV0"+STRZERO(j,2))
			_nReal += &("(cAlias)->REAL0"+STRZERO(j,2))
			
			aAdd(aPagamentos,{aHeadUse[i],(cAlias)->NAT,_nPrev})
			i++
			aAdd(aPagamentos,{aHeadUse[i],(cAlias)->NAT,_nReal})
			_nPrev := 0
			_nReal := 0
		Next i
	EndIf
	j := 0
	(cAlias)->(dbskip())
EndDo

cTabela += ""+CRLF+' </tr>

If !lfluxSint
For x:=1 to len(aPagamentos)
	cNatureza := aPagamentos[x][2]
	
	If !empty(cNatureza)
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
		
		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>'"+cNatureza+"'</td>
		For j:=1 to len(aPagamentos)
			If  alltrim(cNatureza) == alltrim(aPagamentos[j][2])
				cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aPagamentos[j][3])+"</td>
				x:=j
			EndIf
		Next j
		
	EndIf
	cTabela += ""+CRLF+' </tr>
Next x
EndIf   


/*
aSort( aPagamentos,,,{|x,y| x[2] < y[2] })
For x:=1 to len(aPagamentos)
	cNatureza := aPagamentos[x][2]
	
	If !empty(cNatureza)
		cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
		
		If substr(cNatureza,1,1) == "0"
			cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>'"+cNatureza+"'</td>
		Else
			cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>"+cNatureza+"</td>
		EndIf
		For i:=1 to len(aDataImp)
			lRet := .T.
			lOk := .T.
			For j:=1 to len(aPagamentos)
				If aDataImp[i] == aPagamentos[j][1]  .and. alltrim(cNatureza) == alltrim(aPagamentos[j][2])
					
					cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aPagamentos[j][3])+"</td>
					lRet := .F.
					
					j := len(aPagamentos)
				EndIf
			Next j
			If lRet
				
				cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
			EndIf
		Next i
	EndIf
	
	While x <= len(aPagamentos) .and. lOk
		If cNatureza == aPagamentos[x][2]
			x++
			lOk := .T.
		Else
			lOk := .F.
			x--
		EndIf
	EndDo
	
	cTabela += ""+CRLF+' </tr>
Next x
*/
	
	//Natureza D
///	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
///	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>Natureza D</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>20.00</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>30.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>40.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>50.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>60.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>70.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>80.00</td>
///	cTabela += ""+CRLF+' </tr>
	
	//Natureza E
///	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
///	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl69 style=3D'height:15.0pt;border-top:none'>Natu=
///	cTabela += ""+CRLF+'reza E</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
///	cTabela += ""+CRLF+'>20.00</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
///	cTabela += ""+CRLF+'>30.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>40.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>50.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>60.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>70.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>80.00</td>
///	cTabela += ""+CRLF+' </tr>
	
	
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
	
	//Saldo Operacional
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl71 style=3D'height:15.0pt'>Saldo Operacional Fi=
	cTabela += ""+CRLF+'nal</td>   
	
	aSaldoOperFinal := {}
	_nPrev := 0
	_nReal := 0
         j := 0
	For i:=1 to len(aHeadUse)
	j++
	(cAlias)->(dbgotop())
	While (cAlias)->(!EOF())
	    If alltrim((cAlias)->NAT) == "Saldo Operacional"
	      _nPrev += &("(cAlias)->PREV0"+STRZERO(j,2))
	      _nReal += &("(cAlias)->REAL0"+STRZERO(j,2))
	    EndIf
		(cAlias)->(dbskip()) 
	EndDo
	aAdd(aSaldoOperFinal,{aHeadUse[i],_nPrev})	
    i++
	aAdd(aSaldoOperFinal,{aHeadUse[i],_nReal})	
	_nPrev := 0
	_nReal := 0
    Next i

	For j:=1 to len(aSaldoOperFinal)
		cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aSaldoOperFinal[j][2])+"</td>
	Next j
	
	
//	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>20.00</td>
//	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>30.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>40.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>50.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>60.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>70.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>80.00</td>
	cTabela += ""+CRLF+' </tr>
	
	cTabela += ""+CRLF+" <tr height=3D21 style=3D'height:15.75pt'>
	cTabela += ""+CRLF+"  <td height=3D21 style=3D'height:15.75pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
	
	//Saldo Final
	cTabela += ""+CRLF+" <tr height=3D21 style=3D'height:15.75pt'>
	cTabela += ""+CRLF+"  <td height=3D21 class=3Dxl74 style=3D'height:15.75pt'>Saldo Final</td>    

	aSaldoFinal := {}
	_nPrev := 0
	_nReal := 0
         j := 0
	For i:=1 to len(aHeadUse)
	j++
	(cAlias)->(dbgotop())
	While (cAlias)->(!EOF())
	    If alltrim((cAlias)->NAT) == "Saldo Final"
	      _nPrev += &("(cAlias)->PREV0"+STRZERO(j,2))
	      _nReal += &("(cAlias)->REAL0"+STRZERO(j,2))
	    EndIf
		(cAlias)->(dbskip()) 
	EndDo
	aAdd(aSaldoFinal,{aHeadUse[i],_nPrev})	
    i++
	aAdd(aSaldoFinal,{aHeadUse[i],_nReal})	
	_nPrev := 0
	_nReal := 0
    Next i

	
//	For i:=1 to len(aDataImp)
//		lRet := .T.
		For j:=1 to len(aSaldoFinal)
 //			If aDataImp[i] == STOD(aSaldoFinal[j][1]) //.and. i <> len(aDataImp)
				cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>"+STR(aSaldoFinal[j][2])+"</td>
 //				lRet := .F.
 //				j := len(aSaldoFinal)
 //			EndIf
		Next j
//		If lRet  .and. i <> len(aDataImp)
//			cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
//		EndIf
//	Next i      
	
///	cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>80.00</td>
///	cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>90.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>100.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>110.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>120.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>130.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl76 align=3Dright style=3D'border-left:none'>140.00</td>
	cTabela += ""+CRLF+' </tr>
	
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
	
	//Total dos bancos por filial
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'> 

aSort( aBancos,,,{|x,y| x[2] < y[2] })

For j:=1 to len(aBancos)
	lRet := .T.
	For k:=1 to len(aAuxBancos)
		If aBancos[j][2]+aBancos[j][3] == aAuxBancos[k][1]+aAuxBancos[k][2]
			lRet := .F.
		EndIf
	Next k
	If lRet
		aAdd(aAuxBancos,{aBancos[j][2],aBancos[j][3]})
	EndIf
Next j

For i:=1 to Len(aFiliais)
	For x:=1 to len(aDataImp)
	_nDiaBco := 0

		For j:=1 to len(aBancos)
			If aDataImp[x] == aBancos[j][1] .and. aBancos[j][2] == aFiliais[i]
				_nDiaBco += aBancos[j][4]
			EndIf
		Next j  
		
		aAdd(aBcoFilial,{aFiliais[i],aDataImp[x],_nDiaBco})
		
	Next x
Next i
_nDiaBco := 0

		
For i:=1 to Len(aFiliais)
	dbselectarea("SM0")
	dbsetorder(1)
	If dbseek(cEmpAnt+aFiliais[i])
		cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl71 style=3D'height:15.0pt'>"+alltrim(PadR(SM0->M0_FILIAL,15))+"</td>
		
		For x:=1 to len(aBcoFilial)
			If aFiliais[i] == aBcoFilial[x][1]
				For y:=1 to len(aDataImp)
			 		If aDataImp[y] == aBcoFilial[x][2]
				 		cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+"-----"+"</td>
				 		cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(aBcoFilial[x][3])+"</td>
			 		EndIf
				Next y
			EndIf
		Next x
		
		For k:=1 to len(aAuxBancos)
			
			If aFiliais[i] == aAuxBancos[k][1]
				dbselectarea("SA6")
				dbsetorder(1)
				If dbseek(aFiliais[i]+substr(aAuxBancos[k][2],1,TamSX3("E8_BANCO")[1]))
					if lfluxsint
						_cNomeBanco := alltrim(SA6->A6_NREDUZ)
					else                         
						_cNomeBanco := alltrim(SA6->A6_NREDUZ)+" - Bco.: "+substr(aAuxBancos[k][2],1,TamSX3("E8_BANCO")[1])+;
						" Ag.: "+substr(aAuxBancos[k][2],TamSX3("E8_BANCO")[1]+1,TamSX3("E8_AGENCIA")[1])+;
						" Conta: "+substr(aAuxBancos[k][2],TamSX3("E8_BANCO")[1]+TamSX3("E8_AGENCIA")[1]+1,TamSX3("E8_CONTA")[1])
					endif
				Else
					_cNomeBanco := "Nome n„o cadastrado"
				EndIf

				cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
				cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>"+_cNomeBanco+"</td>
				
				For x:=1 to len(aDataImp)
					lRet := .T.
					
					
					For j:=1 to len(aBancos)
						If aDataImp[x] == aBancos[j][1] .and. (x <> len(aDataImp) .or. len(aDataImp) == 1) .and. aBancos[j][2]+aBancos[j][3] == aAuxBancos[k][1]+aAuxBancos[k][2]
							_nDiaBco += aBancos[j][4]
						EndIf
					Next j
					
					If _nDiaBco <> 0
//						cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>"+STR(_nDiaBco)+"</td>
						cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+"-----"+"</td>
						cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(_nDiaBco)+"</td>
					Else
//						cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
						cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+"-----"+"</td>
						cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
					EndIf
					_nDiaBco := 0
					
					
				Next x
					cTabela += ""+CRLF+' </tr>
			Else 
				cTabela += ""+CRLF+' </tr>
 /*				
				cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>                                       
				cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'></td>
				
				For x:=1 to len(aDataImp)
//						cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
						cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
                Next x                        
*/
//                	cTabela += ""+CRLF+' </tr>
			EndIf
			
		Next k
		
	EndIf

	cTabela += ""+CRLF+" <tr height=3D21 style=3D'height:15.75pt'>
	cTabela += ""+CRLF+"  <td height=3D21 style=3D'height:15.75pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>

Next i



//			cTabela += PadR(SM0->M0_FILIAL,15)
//		EndIf
//	Next i
////		aAdd(aBancos,{STOD(_dDataRef),_cFilial,cBanco,_nVlrNat})
  //	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl71 style=3D'height:15.0pt'>GJP Matriz</td>

//	cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
//	cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
//	cTabela += ""+CRLF+' </tr>
 /*	
	//Banco
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>Bradesco</td>
	cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>150.00</td>
	cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>170.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>190.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>210.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>230.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>250.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>270.00</td>
	cTabela += ""+CRLF+' </tr>
	
	//Valores ref. a bancos
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl69 style=3D'height:15.0pt;border-top:none'>Ita&=
	cTabela += ""+CRLF+'uacute;</td>
	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	cTabela += ""+CRLF+'>160.00</td>
	cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	cTabela += ""+CRLF+'>180.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>200.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>220.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>240.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>260.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl70 align=3Dright style=3D'border-top:none;border-left:none'=
	//cTabela += ""+CRLF+'>280.00</td>
//	cTabela += ""+CRLF+' </tr>

//		EndIf
//	Next i
	
	//Filial
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 style=3D'height:15.0pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl71 style=3D'height:15.0pt'>Serrano Resort</td>
	cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	//cTabela += ""+CRLF+'  <td class=3Dxl78>&nbsp;</td>
	cTabela += ""+CRLF+' </tr>
	
	//Banco
	cTabela += ""+CRLF+" <tr height=3D20 style=3D'height:15.0pt'>
	cTabela += ""+CRLF+"  <td height=3D20 class=3Dxl72 style=3D'height:15.0pt'>Banrisul</td>
	cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>290.00</td>
	cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>300.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>400.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>500.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>600.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>700.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl73 align=3Dright style=3D'border-left:none'>800.00</td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+" <tr height=3D21 style=3D'height:15.75pt'>
	cTabela += ""+CRLF+"  <td height=3D21 style=3D'height:15.75pt'></td>
	cTabela += ""+CRLF+"  <td colspan=3D7 class=3Dxl67 style=3D'mso-ignore:colspan'></td>
	cTabela += ""+CRLF+' </tr>
*/	
	//Saldo final ref. aos bancos
	cTabela += ""+CRLF+" <tr height=3D21 style=3D'height:15.75pt'>
	cTabela += ""+CRLF+"  <td height=3D21 class=3Dxl74 style=3D'height:15.75pt'>Saldo Final Bancos<=
	cTabela += ""+CRLF+'/td>


//	aAdd(aBancosFinal,{_dDataRef,_nBcoFil})
	
	For i:=1 to len(aDataImp)
		lRet := .T.
		For j:=1 to len(aBancosFinal)
			If aDataImp[i] == STOD(aBancosFinal[j][1]) //.and. i <> len(aDataImp)
				cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
				cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>"+STR(aBancosFinal[j][2])+"</td>
				lRet := .F.
				j := len(aBancosFinal)
			EndIf
		Next j
		If lRet  .and. i <> len(aDataImp)
			cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
			cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>"+STR(0)+"</td>
		EndIf
	Next i      

	oProcess:IncRegua1("Fluxo de Caixa - GJP")
	oProcess:IncRegua2("Filtrando dados...")

 //	cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>1,000.00</td>
 //	cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>2,000.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>3,000.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>4,000.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>5,000.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl75 align=3Dright style=3D'border-left:none'>6,000.00</td>
	//cTabela += ""+CRLF+"  <td class=3Dxl76 align=3Dright style=3D'border-left:none'>7,000.00</td>
	cTabela += ""+CRLF+' </tr>
	
	cTabela += ""+CRLF+' <![if supportMisalignedColumns]>
	cTabela += ""+CRLF+" <tr height=3D0 style=3D'display:none'>
	cTabela += ""+CRLF+"  <td width=3D242 style=3D'width:182pt'></td>
	cTabela += ""+CRLF+"  <td width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+"  <td width=3D64 style=3D'width:48pt'></td>
	cTabela += ""+CRLF+' </tr>
	cTabela += ""+CRLF+' <![endif]>
	cTabela += ""+CRLF+'</table>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'</body>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'</html>
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'------=_NextPart_01D01EA8.0A093920
	cTabela += ""+CRLF+'Content-Location: file:///C:/0505DE0C/GJP_Fluxo_Caixa_mhtml_arquivos/filelist.xml
	cTabela += ""+CRLF+'Content-Transfer-Encoding: quoted-printable
	cTabela += ""+CRLF+'Content-Type: text/xml; charset="utf-8"
	cTabela += ""+CRLF
	cTabela += ""+CRLF+'<xml xmlns:o=3D"urn:schemas-microsoft-com:office:office">
	cTabela += ""+CRLF+' <o:MainFile HRef=3D"../GJP_Fluxo_Caixa_mhtml.htm"/>
	cTabela += ""+CRLF+' <o:File HRef=3D"stylesheet.css"/>
	cTabela += ""+CRLF+' <o:File HRef=3D"tabstrip.htm"/>
	cTabela += ""+CRLF+' <o:File HRef=3D"sheet001.htm"/>
	cTabela += ""+CRLF+' <o:File HRef=3D"sheet002.htm"/>
	cTabela += ""+CRLF+' <o:File HRef=3D"filelist.xml"/>
	cTabela += ""+CRLF+'</xml>
	cTabela += ""+CRLF+'------=_NextPart_01D01EA8.0A093920--
	cTabela += ""+CRLF
	
	
	
	/*
	
	oProcess:IncRegua2("Recebimentos - Tabelas e Gr·ficos")
	
	GrfReceb(nAno)
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//Monta tabelas e graficos de maneira dinamica
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oProcess:IncRegua1("AGM - "+cValToChar(nAno))
	
	oProcess:IncRegua2("Eventos - Tabelas e Gr·ficos")
	
	GrfEventos(nAno)
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//Monta tabelas e graficos de maneira dinamica
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	oProcess:IncRegua2("RESOF - Tabelas e Gr·ficos")
	
	GrfResof(nAno)
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oProcess:IncRegua1("AGM - "+cValToChar(nAno))
	oProcess:IncRegua2("Processamento concluÌdo.")
	
	*/
	cTabela += ""   + CRLF
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Verifica se foi possivel gravar o arquivo, caso nao seja possivel um mensagem     ≥
	//≥de alerta ser· exibida na tela   			                                     ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If(FWRITE(nHandle, cTabela) == 0)
		Alert("N„o foi possÌvel gravar o arquivo!")  //"N„o foi possÌvel gravar o arquivo!"
	EndIf
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Fecha o arquivo gravado                                                           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	FCLOSE(nHandle)
//	QRYSE1A->(dbclosearea())

	MsgInfo("O arquivo foi gerado no diretÛrio "+ CRLF +""+alltrim(cArqPesq)+"") //"O arquivo foi gerado no diretÛrio "
	lRet := .T.
	
	GR01Excel()
	
	If GR01Excel() > 0
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open( cArqPesq )
		oExcelApp:SetVisible(.T.)
		WinExec("excel.exe "+cArqPesq)
	Endif
	
	
Endif

Return( lRet )

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ GR01Excel ∫ Autor ≥ Carlos A. Queiroz  ∫ Data ≥  14/06/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Funcao para avaliar se existe o software de edicao da        ∫±±
±±∫          ≥pesquisa exportada esta instalada na maquina do usuario.     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥Microsiga                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function GR01Excel()

Local oExcel						// Objeto
Local cEditor:= "Excel"			// Software para edicao
Local nRet   := 0				// Retorno da funcao

CursorWait()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifica via API se o software de edicao esta instalado na maquina≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oExcel := OLE_CreateLink(cEditor)
If oExcel <> "-1"
	nRet := 1 // Existe Excel
Endif
oExcel := OLE_CloseLink(oExcel)

CursorArrow()

Return( nRet )





//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FSFlxAjuSX1
Cria perguntas (SX1) em tempo de execuÁao

@protected
@author        Carlos A. Queiroz
@since         04/11/2012
@version       P11
/*/
//---------------------------------------------------------------------------------------
Static Function GR01juSX1(cPerSX1)

Local aArea			:= GetArea()
//Local aRegs       := {}
Local cHelp			:= ""
Local aHelpPor		:= {}
Local aHelpSpa		:= {}
Local aHelpEng		:= {}
Local lUpDate     := .T.

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0
//Local aRegs		:= {}
Local aTamSX3   := {}
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis utilizadas para parametros                         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
// Monta array com as perguntas
aAdd(aRegs,{cPerSX1,"01","Sintetico/Analitico","","","mv_ch1","N",01,0,0,"C","","MV_PAR01","SintÈtico",	"",		"",		"",			"",         "AnalÌtico",  "",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})

//aAdd(aRegs,{cPerSX1,"02","Data de?	   	","","","mv_ch2","D",08		  ,0,0,"G","","MV_PAR02","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","",""	 ,"","","",""})
//aAdd(aRegs,{cPerSX1,"03","Data ate?	   	","","","mv_ch3","D",08		  ,0,0,"G","","MV_PAR03","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","",""	 ,"","","",""})
aTamSX3	:= TAMSX3("E1_NATUREZ")

aAdd(aRegs,{cPerSX1,"02","Natureza de?","","","mv_ch2","C",aTamSx3[1],0,0,"G","","MV_PAR02","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","SED","","","",""})
aAdd(aRegs,{cPerSX1,"03","Natureza ate?","","","mv_ch3","C",aTamSx3[1],0,0,"G","","MV_PAR03","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","SED","","","",""})

aAdd(aRegs,{cPerSX1,"04","Dias p/ Retroceder","","","mv_ch4","N",3,0,0,"G","","MV_PAR04","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerSX1,"05","Dias p/ Avancar","","","mv_ch5","N",3,0,0,"G","","MV_PAR05","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","","","","",""})

aAdd(aRegs,{cPerSX1,"06","Considera Ped.Vendas","","","mv_ch6","N",01,0,0,"C","","MV_PAR06","Sim",	"",		"",		"",			"",         "N„o",  "",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerSX1,"07","Considera Ped.Compra","","","mv_ch7","N",01,0,0,"C","","MV_PAR07","Sim",	"",		"",		"",			"",         "N„o",  "",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerSX1,"08","Considera Comissoes","","","mv_ch8","N",01,0,0,"C","","MV_PAR08","Sim",	"",		"",		"",			"",         "N„o",  "",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerSX1,"09","Seleciona outras Filiais","","","mv_ch9","N",01,0,0,"C","","MV_PAR09","Sim",	"",		"",		"",			"",         "N„o",  "",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})

dbSelectArea("SX1")
SX1->(dbSetOrder(1))

For nY := 1 To Len(aRegs)
	If !MsSeek(PADR(aRegs[nY,1],10)+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)

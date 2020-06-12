#include "rwmake.ch"
#include "TOPCONN.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  06/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo CT-e (TMS) funcao TMSIMPDOC                     บฑฑ
ฑฑ           ณaCabDTC   DTC                                               บฑฑ
ฑฑ           ณaItem     DTC (pode haver mais de 1 registro do Cliente)    บฑฑ
ฑฑ           ณ                                                            บฑฑ
ฑฑ           ณaVetDoc   DT6                                               บฑฑ
ฑฑ           ณaVetVlr   DT8 (2 registros)                                 บฑฑ
ฑฑ           ณaVetNFc   DTC                                               บฑฑ
ฑฑ           ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DTMS004()
//Local aParam	:= ParamIxb // Paramentro vindo do MILE

Private _lRet 	:= .T.

Private _aArea	:= GetArea()

Private LTM500CON	:= .f.

Private aVetDoc  := {}
Private aVetVlr  := {}
Private aVetNFc  := {}

Private aDocOri	 := {}
Private aDocAnul := {}

Private aCabDTC  := {}
Private aItemDTC := {}
Private aItem    := {}
Private lCont    := .F.
Private cLotNfc  := ''

Private aErrMsg  := {}
Private oDlg     := NIL
Private nQtdDtc  := 1

Private cMask    := "Todos os arquivos (*.*) |*.*|"

Private lMsErroAuto := .F.

Private cAnexo   := Space(200)
Private xDocOri  := ""
Private xSerOri  := ""

Private XC_DEVFRE := ""
Private XC_NFEID  := ""
Private X8_XALIQ  := 0
Private X8_XTES   := ""
Private X8_XCFOP  := ""
Private X6_CHVCTE := ""
Private X6_CODNFE := ""
Private _lCTeComp := .F.
Private _lCTeAnul := .F.
Private nOpc      := 2

If !MsgYesNo("Processa Importa็ใo CT-e??. Deseja continuar?")
	Return
Else
	DEFINE MSDIALOG oDlg TITLE "Importa็ใo CT-e" FROM 0,0 TO 350,570 OF oDlg PIXEL
	
	@ 051,003 SAY "Arquivo"    SIZE 30,7 PIXEL OF oDlg
	
	@ 050,035 MSGET cAnexo   PICTURE "@" SIZE 233, 8 PIXEL OF oDlg
	@ 049,269 BUTTON "..." SIZE 13,11 PIXEL OF oDlg ACTION cAnexo:=AllTrim(cGetFile(cMask,"Inserir anexo"))
	
	@ 100,060 BUTTON "&OK" SIZE 36,13 PIXEL ACTION (nOpc:=1,oDlg:End())
	@ 100,180 BUTTON "&Cancelar" SIZE 36,13 PIXEL ACTION (nOpc:=2,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
EndIf

If nOpc == 2 //Cancelar
	Return
Else
	Processa( {|| RunTxt() }, "Processando Arquivos..." ) //ExecAuto e TMSImpDoc
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  07/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunTxt()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abre o arquivo a ser importado                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MV_PAR01 := cAnexo
If (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	Help(" ",1,"NOFILE")
	Return
EndIf

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

_cDtIni  := Date()
_cHrIni  := TIME()
_nLi	 := 1 //Linhas processadas

//Inicio Processamento arquivo
Do While !FT_FEOF()
	_cBuffer := FT_FREADLN()

	If Substr(_cBuffer,032,004) <> cFilAnt
		MsgBox("Filial selecionada Invalida!!! Arquivo pertence a Filial::"+Substr(_cBuffer,032,004))
		FT_FUSE()
		RestArea(_aArea)
		Return
	EndIf

	IncProc("Numero de Linhas "+ alltrim(strzero(_nLi,6)))

//	If nQtdDtc > 999
//		CriaLote()
//		nQtdDtc	:= 0
//	EndIf

	If Substr(_cBuffer,1,1) == "A"
		If nQtdDtc == 1
			cLotNfc  := ''
			CriaLote()
		EndIf
		Ler_A()
		nQtdDtc++ //Controla Numera็ใo de registros DTC para o mesmo Lote
	ElseIf Substr(_cBuffer,1,1) == "B"
		nQtdDtc  := 1
		Ler_B()
	ElseIf Substr(_cBuffer,1,1) == "C"
		Ler_C()
		lCont := .T.
	EndIf
	
	If lCont //Leu CANAL A , B e C entao pode processar
		Begin Transaction
		//MsgRun( "Gerando Registros", "Aguarde...", {|| Exec_Proc() }) //ExecAuto e TMSImpDoc
		Exec_Proc()
		END TRANSACTION

//		If nQtdDtc > 999 .and. Empty(aErrMsg)
//			DbSelectArea("DTP")
//			DbSetOrder(1)
//			If DbSeek(xFilial("DTP")+cLotNfc)
//				RecLock("DTP",.F.)
//				DTP_QTDLOT := nQtdDtc
//				MsUnLock()
//			EndIf
//		EndIf

	EndIf
	
	_nLi++
	FT_FSKIP()

EndDo

GeraLog()

FT_FUSE()

MsgAlert("Processamento Iniciado em :"+dtoc(_cDtIni)+"Finalizado em: "+dtoc(Date())+" "+ELAPTIME(_cHrIni,TIME()))

RestArea(_aArea)

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  06/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Exec_Proc

//Local lMsErroAuto := .F.

If !_lCTeComp //Se for CT-e Normal
	MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)
	
	If lMsErroAuto
		AutoGrLog("DTMSA004"+":: Ocorreram erros no Processamento - Empresa/Filial: "+cEmpAnt+"/"+cFilAnt)
		AutoGrLog("DTMSA004"+"::")
		AutoGrLog("DTMSA004"+":: TMSA050 - CANAL A - DTC - DOCUMENTO DO CLIENTE")
		AutoGrLog("DTMSA004"+"::"+TIME()+" "+DTOC(DDATABASE))
		AutoGrLog("DTMSA004"+"::"+"Chave CT-e: " + XC_NFEID)
		AutoGrLog("FIM        :: ---------------------------------------------------------------------------")
		
//		MostraErro()
		DisarmTransaction()
		lCont := .F.
		lMsErroAuto := .F.

	EndIf
EndIf


//DHL - TOTVS (especifico)
//*********************************************************************
If _lCTeAnul
	LTM500CON := .F.
	dbSelectArea("DT6")
	dbSetorder(1)
	If dbseek(xFilial("DT6")+aDocAnul[2]+aDocAnul[3]+aDocAnul[4])
		Reclock("DT6",.F.)
		DT6->DT6_STATUS := "7"
		MsUnLock() //EndIf
		U_TmsA_500Anu()
	EndIf
EndIf
//*********************************************************************

If lCont
//  Executa o Calculo do Frete para gera็ใo da Nota Fiscal (SF2,SD2,SF3,SFT)
//	aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,cLotNfc,.F.,val(X8_XALIQ),1,.T.,.T.,.T.,.T.,aDocOri) //as condi็๕es .T. sใo para mostrar o erro na tela
	aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,cLotNfc,.F.,val(X8_XALIQ),1,.F.,.F.,.F.,.F.,aDocOri) //alterado para .F. pois as msg estao sendo gravas em um LOG.
	If !Empty(aErrMsg)
		DisarmTransaction()

		AutoGrLog("DTMSA004"+"::")
		AutoGrLog("DTMSA004"+"::")
		AutoGrLog("DTMSA004"+":: TMSImpDoc - CANAL B e C - GERACAO DO DOCUMENTO CT-E")
		AutoGrLog("DTMSA004"+":: "+aErrMsg[1,1])
		If !Empty(aCabDTC)
			_nPosDevFre := ascan(aCabDTC, {|x| x[1] == "DTC_DEVFRE"})
			_nPosCliDes := ascan(aCabDTC, {|x| x[1] == "DTC_CLIDES"})
			_nPosLojDes := ascan(aCabDTC, {|x| x[1] == "DTC_LOJDES"})
			_nPosCliCon := ascan(aCabDTC, {|x| x[1] == "DTC_CLICON"})
			_nPosLojCon := ascan(aCabDTC, {|x| x[1] == "DTC_LOJCON"})
			_cCteTpDev  := aCabDTC[_nPosDevFre,2]
			_cCteCliDev := aCabDTC[_nPosCliDes,2]
			_cCteLojDev := aCabDTC[_nPosLojDes,2]
			_cCteCliCon := aCabDTC[_nPosCliCon,2]
			_cCteLojCon := aCabDTC[_nPosLojCon,2]
			If _cCteTpDev == "2"
				_cCteTpDev := _cCteTpDev + " Destinatario "+_cCteCliDev+"-"+_cCteLojDev
			ElseIf _cCteTpDev == "3"
				_cCteTpDev := _cCteTpDev + " Consignatario "+_cCteCliCon+"-"+_cCteLojCon
			EndIf
			AutoGrLog("DTMSA004"+":: Devedor do Frete: "+_cCteTpDev)
		EndIf
		If !Empty(aVetDoc)
			_nPosDoc := ascan(aVetDoc, {|x| x[1] == "DT6_DOC"})
			_cCteDHL := aVetDoc[_nPosDoc,2]
			AutoGrLog("DTMSA004"+":: Documento CT-e (DHL): "+_cCteDHL)
		EndIf
		AutoGrLog("FIM        :: ---------------------------------------------------------------------------")
	Else
		_xAreaDT6 := GetArea()
		dbSelectArea("DT6")
		dbSetorder(1) //FILIAL + FILDOC + DOC + SERIE
		_nPosFil := ascan(aVetDoc, {|x| x[1] == "DT6_FILDOC"})
		_nPosDoc := ascan(aVetDoc, {|x| x[1] == "DT6_DOC"})
		_nPosSer := ascan(aVetDoc, {|x| x[1] == "DT6_SERIE"})
		If DT6->(dbseek(xFilial("DT6")+ aVetDoc[_nPosFil,2]+aVetDoc[_nPosDoc,2]+aVetDoc[_nPosSer,2]))
			_nPosNfe := ascan(aVetDoc, {|x| x[1] == "DT6_NFELET"}) 
			_nPosEmi := ascan(aVetDoc, {|x| x[1] == "DT6_EMINFE"}) 
			_nPosCod := ascan(aVetDoc, {|x| x[1] == "DT6_CODNFE"}) 
			_nPosID  := ascan(aVetDoc, {|x| x[1] == "DT6_IDRCTE"}) 
			_nPosPro := ascan(aVetDoc, {|x| x[1] == "DT6_PROCTE"}) 
			_nPosChv := ascan(aVetDoc, {|x| x[1] == "DT6_CHVCTE"}) 
			_nPosSit := ascan(aVetDoc, {|x| x[1] == "DT6_SITCTE"}) 
			Reclock("DT6",.F.)
			DT6->DT6_NFELET  := aVetDoc[_nPosNfe,2]
			DT6->DT6_EMINFE  := aVetDoc[_nPosEmi,2]
			DT6->DT6_CODNFE  := aVetDoc[_nPosCod,2]
			DT6->DT6_IDRCTE  := aVetDoc[_nPosID,2]
			DT6->DT6_PROCTE  := aVetDoc[_nPosPro,2]
			DT6->DT6_CHVCTE  := aVetDoc[_nPosChv,2]
			DT6->DT6_SITCTE  := aVetDoc[_nPosSit,2]
			MsUnLock()
		EndIf


		If substr(alltrim(DT6->DT6_CODNFE),1,3) $ "101|102" //Cancelado e Inutilizado
			u_DelCTRC() //Efetua a Exclusใo dos Registros no sistema
		EndIf

		RestArea(_xAreaDT6)
	EndIf
EndIf

aVetDoc   := {}
aVetVlr   := {}
aVetNFc   := {}
X8_XALIQ  := 0
X8_XTES   := ""
X8_XCFOP  := ""
X6_CHVCTE  := ""
X6_CODNFE  := ""

_lCTeComp := .F.
_lCTeAnul := .F.
lCont     := .F.
aDocOri	  := {}

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  06/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria regitro de Numero de Lote                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaLote()

Local aCab     := {}
Local cRet     := ''
//Local lMsErroAuto := .F.

//AAdd(aCab,{'DTP_QTDLOT',999,NIL})
AAdd(aCab,{'DTP_QTDLOT',1,NIL})
AAdd(aCab,{'DTP_QTDDIG',0,NIL})
AAdd(aCab,{'DTP_STATUS','1',NIL})	//-- Em aberto
MsExecAuto({|x,y|cRet := TmsA170(x,y)},aCab,3)
If lMsErroAuto
//	MostraErro()
	DisarmTransaction()
	lMsErroAuto := .F.
Else
	cLotNfc     := cRet
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  06/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ LER_A                                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ler_A()

aItemDTC := {}
aItem := {}

XC_FILIAL := Substr(_cBuffer,032,004) //32	 35 = 4
XC_DATENT := Substr(_cBuffer,036,008) //36	 43 = 8
XC_NUMNFC := Substr(_cBuffer,044,009) //44	 52 = 9
XC_SERNFC := "   "
XC_MOENFC := Substr(_cBuffer,053,001) //53	 53 = 1
XC_CODPRO := Substr(_cBuffer,054,018) //54	 68 = 15
XC_CODEMB := Substr(_cBuffer,072,003) //69	 71 = 3
XC_EMINFC := Substr(_cBuffer,075,008) //72	 79 = 8
XC_QTDVOL := Substr(_cBuffer,083,005) //80	 84 = 5
XC_PESO   := Substr(_cBuffer,088,010) //85	 94 = 10
XC_VALOR  := Substr(_cBuffer,099,013) //96	108 = 13
XC_CLIREM := Substr(_cBuffer,113,014) //110	119 = 14 //alterado a partir daqui
XC_CLIDES := Substr(_cBuffer,127,014) //120	129 = 10
XC_DEVFRE := Substr(_cBuffer,141,001) //130	130 = 1
XC_CLIDEV := Substr(_cBuffer,142,014) //131	140 = 10
XC_LOJDEV := Substr(_cBuffer,156,004) //141	142 = 2
XC_CLICAL := Substr(_cBuffer,160,014) //143	152 = 10
XC_LOJCAL := Substr(_cBuffer,174,004) //153	154 = 2
XC_TIPFRE := Substr(_cBuffer,178,001) //155	155 = 1
XC_SERTMS := Substr(_cBuffer,179,001) //156	156 = 1
XC_TIPTRA := Substr(_cBuffer,180,001) //157	157 = 1
XC_SERVIC := Substr(_cBuffer,181,003) //158	160 = 3
XC_TIPNFC := Substr(_cBuffer,184,001) //161	161 = 1
XC_SELORI := Substr(_cBuffer,185,001) //162	162 = 1
XC_CDRORI := Substr(_cBuffer,186,006) //163	168 = 6
XC_REGORI := Substr(_cBuffer,192,030) //169	198 = 30
XC_CDRDES := Substr(_cBuffer,222,006) //199	204 = 6
XC_REGDES := Substr(_cBuffer,228,030) //205	234 = 30
XC_CDRCAL := Substr(_cBuffer,258,006) //235	240 = 6
XC_REGCAL := Substr(_cBuffer,264,030) //241	270 = 30
XC_FILDOC := Substr(_cBuffer,294,004) //271	274 = 4
XC_DOC 	  := Substr(_cBuffer,298,009) //275	283 = 9
XC_SERIE  := Substr(_cBuffer,307,003) //284	286 = 3
XC_MOEDA  := Substr(_cBuffer,310,002) //287	288 = 2
XC_NFEID  := Substr(_cBuffer,312,044) //289	332 = 44
XC_LOJREM := Substr(_cBuffer,356,004) //289	332 = 
XC_LOJDES := Substr(_cBuffer,360,004) //289	332 = 
XC_CLICON := ""
XC_LOJCON := ""

If XC_DEVFRE == "3" //Quando o Devedor for o Consignatario
	XC_CLICON	:= XC_CLIDEV
	XC_LOJCON	:= XC_LOJDEV
EndIf

XC_SELORI := "1" 			//transportadora (Selecio.Origem) a op็ใo 3 ้ Local Coleta que nใo cabe na DHL
//XC_CDRCAL := XC_CDRDES		//para a DHL o destino ้ igual ao calculo, pois nao tem Local de Entrega

If XC_TIPNFC == "3" //Documento NรO FISCAL
	XC_NUMNFC := cLotNfc+substr(alltrim(str(int(SECONDS()))),3,3)//cLotNfc+"   " //ou RIGHT(TIME(),2)
	XC_EMINFC := XC_DATENT
Else //Documento FISCAL
	//TRATAR NOTAS SEM O NUMNFC E PREENCHER DO NFEID (SUBSTRING)
	If Empty(XC_NUMNFC) .and. !Empty(XC_NFEID)
		XC_NUMNFC := Substr(XC_NFEID,26,9) //NUMERO DA NOTA
		XC_SERNFC := Substr(XC_NFEID,23,3) //SERIE
		XC_EMINFC := DTOS(CTOD("01/"+Substr(XC_NFEID,5,2)+"/"+Substr(XC_NFEID,3,2))) //AAMM - CONSIDERAMOS SEMPRE DIA 01
	EndIF
EndIf

aCabDTC := {{"DTC_FILIAL" ,xFilial("DTC")	, Nil},;
{"DTC_FILORI" ,XC_FILIAL  		, Nil},;
{"DTC_LOTNFC" ,cLotNfc 			, Nil},;
{"DTC_CLIREM" ,XC_CLIREM 		, Nil},;
{"DTC_LOJREM" ,XC_LOJREM		, Nil},;
{"DTC_DATENT" ,STOD(XC_DATENT)  , Nil},;
{"DTC_CLIDES" ,XC_CLIDES 		, Nil},;
{"DTC_LOJDES" ,XC_LOJDES	    , Nil},;
{"DTC_CLICON" ,XC_CLICON 		, Nil},;
{"DTC_LOJCON" ,XC_LOJCON 		, Nil},;
{"DTC_DEVFRE" ,XC_DEVFRE		, Nil},;
{"DTC_CLIDEV" ,XC_CLIDEV 		, Nil},;
{"DTC_LOJDEV" ,XC_LOJDEV 		, Nil},;
{"DTC_CLICAL" ,XC_CLICAL	 	, Nil},;
{"DTC_LOJCAL" ,XC_LOJCAL		, Nil},;
{"DTC_TIPFRE" ,XC_TIPFRE		, Nil},;
{"DTC_SERTMS" ,XC_SERTMS		, Nil},;
{"DTC_TIPTRA" ,XC_TIPTRA		, Nil},;
{"DTC_SERVIC" ,XC_SERVIC		, Nil},;
{"DTC_TIPNFC" ,XC_TIPNFC		, Nil},;
{"DTC_SELORI" ,XC_SELORI		, Nil},;
{"DTC_CDRORI" ,XC_CDRORI 		, Nil},;
{"DTC_CDRDES" ,XC_CDRDES 		, Nil},;
{"DTC_CDRCAL" ,XC_CDRCAL 		, Nil}}

aItem := {	{"DTC_NUMNFC" ,XC_NUMNFC 		, Nil},;
{"DTC_SERNFC" ,XC_SERNFC		, Nil},;
{"DTC_CODPRO" ,XC_CODPRO 		, Nil},;
{"DTC_CODEMB" ,XC_CODEMB		, Nil},;
{"DTC_EMINFC" ,STOD(XC_EMINFC)  , Nil},;
{"DTC_QTDVOL" ,VAL(XC_QTDVOL)		, Nil},;
{"DTC_PESO"   ,VAL(XC_PESO)		, Nil},;
{"DTC_PESOM3" ,0 				, Nil},;
{"DTC_VALOR"  ,VAL(XC_VALOR)		, Nil},;
{"DTC_BASSEG" ,0 				, Nil},;
{"DTC_QTDUNI" ,0 				, Nil},;
{"DTC_EDI"    ,"2" 				, Nil}}

AAdd(aVetNFc,{	{"DTC_FILIAL",xFilial("DTC")	},;
{"DTC_NUMNFC",XC_NUMNFC			},;
{"DTC_SERNFC",XC_SERNFC			},;
{"DTC_CODPRO",XC_CODPRO	},;
{"DTC_CLIREM",XC_CLIREM	},;
{"DTC_LOJREM",XC_LOJREM		},;
{"DTC_QTDVOL",VAL(XC_QTDVOL)	},;
{"DTC_PESO"  ,VAL(XC_PESO)		},;
{"DTC_PESOM3", 0			},;
{"DTC_METRO3", 0			},;
{"DTC_VALOR" ,VAL(XC_VALOR)	}})


AAdd(aItemDTC,aClone(aItem))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  06/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ler_B()
//Se este campo estiver preenchido ้ CT-e Complementar ou Substitui็ใo
If !Empty(Substr(_cBuffer,537,044)) .and. (Substr(_cBuffer,293,001) == "8" .or. Substr(_cBuffer,293,001) == "P")
	_lCTeComp	:= .T.
	//Se CT-e Complementar (8-Complementar)
	xDocOri    := Substr(Substr(_cBuffer,537,044),26,9) //NUMERO DA NOTA
	xSerOri    := Substr(Substr(_cBuffer,537,044),23,3) //SERIE
Else
	_lCTeComp	:= .F.
EndIf

//Se este campo estiver preenchido ้ CT-e Anula็ใo
If !Empty(Substr(_cBuffer,537,044)) .and. Substr(_cBuffer,293,001) == "M"
	_lCTeAnul	:= .T.
	//Se CT-e Anula็ใo (M-Anula็ใo)
	xDocOri    := Substr(Substr(_cBuffer,537,044),26,9) //NUMERO DA NOTA
	xSerOri    := Substr(Substr(_cBuffer,537,044),23,3) //SERIE
Else
	_lCTeAnul	:= .F.
EndIf

X6_FILIAL  := Substr(_cBuffer,032,004) //32	     35 = 4
X6_AMBIEN  := Substr(_cBuffer,036,001) //36	     36 = 1
X6_RETCTE  := Substr(_cBuffer,037,150) //37	    186 = 150
X6_FILDOC  := Substr(_cBuffer,187,004) //187	190 = 4
X6_DOC 	   := Substr(_cBuffer,191,009) //191	199 = 9
X6_SERIE   := Substr(_cBuffer,200,003) //200	202 = 3
X6_DATEMI  := Substr(_cBuffer,203,008) //203	210 = 8
X6_HOREMI  := Substr(_cBuffer,211,004) //211	214 = 4
X6_VOLORI  := Substr(_cBuffer,215,005) //215	219 = 5
X6_QTDVOL  := Substr(_cBuffer,220,005) //220	224 = 5
X6_PESO    := Substr(_cBuffer,225,009) //225	234 = 10
X6_VALMER  := Substr(_cBuffer,235,013) //236	248 = 13
X6_VALFRE  := Substr(_cBuffer,249,013) //250	262 = 13
X6_VALIMP  := Substr(_cBuffer,263,013) //264	276 = 13
X6_VALTOT  := Substr(_cBuffer,277,013) //278	290 = 13
X6_SERTMS  := Substr(_cBuffer,291,001) //292	292 = 1
X6_TIPTRA  := Substr(_cBuffer,292,001) //293	293 = 1
X6_DOCTMS  := Substr(_cBuffer,293,001) //294	294 = 1
X6_CDRORI  := Substr(_cBuffer,294,006) //295	300 = 6
X6_CDRDES  := Substr(_cBuffer,300,006) //301	306 = 6
X6_CDRCAL  := Substr(_cBuffer,306,006) //307	312 = 6
X6_TABFRE  := Substr(_cBuffer,312,004) //313	316 = 4
X6_TIPTAB  := Substr(_cBuffer,316,002) //317	318 = 2
X6_TIPFRE  := Substr(_cBuffer,318,001) //319	319 = 1
X6_NCONTR  := Substr(_cBuffer,319,015) //320	334 = 15
X6_PRZENT  := Substr(_cBuffer,334,008) //335	342 = 8
X6_FILORI  := Substr(_cBuffer,342,004) //343	346 = 4
X6_FILDES  := Substr(_cBuffer,346,004) //347	350 = 4
X6_FIMP	   := Substr(_cBuffer,350,001) //351	351 = 1
X6_BLQDOC  := Substr(_cBuffer,351,001) //352	352 = 1
X6_PRIPER  := Substr(_cBuffer,352,001) //353	353 = 1
X6_CLIREM  := Substr(_cBuffer,353,014) //354	363 = 10 //Alterado aqui
X6_LOJREM  := Substr(_cBuffer,367,004) //364	365 = 2
X6_CLIDES  := Substr(_cBuffer,371,014) //366	375 = 10
X6_LOJDES  := Substr(_cBuffer,385,004) //376	377 = 2
X6_CLIDEV  := Substr(_cBuffer,389,014) //378	387 = 10
X6_LOJDEV  := Substr(_cBuffer,403,004) //388	389 = 2
X6_CLICAL  := Substr(_cBuffer,407,014) //390	399 = 10
X6_LOJCAL  := Substr(_cBuffer,421,004) //400	401 = 2
X6_DEVFRE  := Substr(_cBuffer,425,001) //402	402 = 1
X6_SERVIC  := Substr(_cBuffer,426,003) //403	405 = 3
X6_CODMSG  := Substr(_cBuffer,429,006) //406	411 = 6
X6_STATUS  := Substr(_cBuffer,435,001) //412	412 = 1
X6_FILDEB  := Substr(_cBuffer,436,004) //413	416 = 4
X6_PESLIQ  := Substr(_cBuffer,440,009) //417	426 = 10
X6_NFELET  := Substr(_cBuffer,450,008) //428	435 = 8
X6_EMINFE  := Substr(_cBuffer,458,008) //436	443 = 8
X6_CODNFE  := Substr(_cBuffer,466,008) //444	451 = 8
X6_IDRCTE  := Substr(_cBuffer,474,003) //452	454 = 3
X6_PROCTE  := Substr(_cBuffer,477,015) //455	469 = 15
X6_CHVCTE  := Substr(_cBuffer,492,044) //470	513 = 44
X6_SITCTE  := Substr(_cBuffer,536,001) //514	514 = 1
X6_XCNORI  := Substr(_cBuffer,537,044) //CAMPO ESPECIFICO
X6_CLICON  := ""
X6_LOJCON  := ""

If empty(alltrim(X6_PRZENT))
	X6_PRZENT := X6_DATEMI
EndIf

//X6_CDRCAL  := X6_CDRDES
X6_TABFRE := "0002" 			//tiram em Produ็ใo. Somente para HOMOLOGACAO
X6_NCONTR := "000000000000002"  //tiram em Produ็ใo. Somente para HOMOLOGACAO

If !_lCTeComp //Se for CT-e Normal
	If XC_DEVFRE == "3" //Quando o Devedor for o Consignatario
		X6_CLICON	:= X6_CLIDEV
		X6_LOJCON	:= X6_LOJDEV
	EndIf
EndIf

AAdd(aVetDoc,{"DT6_FILIAL",xFilial("DT6")})
AAdd(aVetDoc,{"DT6_FILORI",X6_FILORI	})
AAdd(aVetDoc,{"DT6_LOTNFC",cLotNfc		})
AAdd(aVetDoc,{"DT6_FILDOC",X6_FILDOC	})
AAdd(aVetDoc,{"DT6_DOC"   ,X6_DOC		})
AAdd(aVetDoc,{"DT6_SERIE" ,X6_SERIE	})
AAdd(aVetDoc,{"DT6_DATEMI",STOD(X6_DATEMI)	})
AAdd(aVetDoc,{"DT6_HOREMI",X6_HOREMI	})
AAdd(aVetDoc,{"DT6_VOLORI",VAL(X6_VOLORI)})
AAdd(aVetDoc,{"DT6_QTDVOL",VAL(X6_QTDVOL)})
AAdd(aVetDoc,{"DT6_PESO"  ,VAL(X6_PESO)	})
AAdd(aVetDoc,{"DT6_PESOM3", 0			})
AAdd(aVetDoc,{"DT6_PESCOB", 0			})
AAdd(aVetDoc,{"DT6_METRO3", 0			})
AAdd(aVetDoc,{"DT6_VALMER",VAL(X6_VALMER)	})
AAdd(aVetDoc,{"DT6_QTDUNI", 0			})
AAdd(aVetDoc,{"DT6_VALFRE",VAL(X6_VALFRE)	})		//VALOR MERCADORIA
AAdd(aVetDoc,{"DT6_VALIMP",VAL(X6_VALIMP)	})		//VALOR ICMS
AAdd(aVetDoc,{"DT6_VALTOT",VAL(X6_VALTOT)	})		//VALOR DA NOTA FISCAL
AAdd(aVetDoc,{"DT6_BASSEG", 0.00		})
AAdd(aVetDoc,{"DT6_SERTMS",X6_SERTMS	})
AAdd(aVetDoc,{"DT6_TIPTRA",X6_TIPTRA	})
AAdd(aVetDoc,{"DT6_DOCTMS",X6_DOCTMS	})
AAdd(aVetDoc,{"DT6_CDRORI",X6_CDRORI	})
AAdd(aVetDoc,{"DT6_CDRDES",X6_CDRDES	})
AAdd(aVetDoc,{"DT6_CDRCAL",X6_CDRCAL	})
AAdd(aVetDoc,{"DT6_TABFRE",X6_TABFRE	})
AAdd(aVetDoc,{"DT6_TIPTAB",X6_TIPTAB	})
AAdd(aVetDoc,{"DT6_SEQTAB","00"			})
AAdd(aVetDoc,{"DT6_TIPFRE",X6_TIPFRE	})
AAdd(aVetDoc,{"DT6_FILDES",X6_FILDES	})
AAdd(aVetDoc,{"DT6_BLQDOC",X6_BLQDOC	})
AAdd(aVetDoc,{"DT6_PRIPER",X6_PRIPER	})
AAdd(aVetDoc,{"DT6_PERDCO", 0.00000		})
AAdd(aVetDoc,{"DT6_FILDCO",""			})
AAdd(aVetDoc,{"DT6_DOCDCO",""			})
AAdd(aVetDoc,{"DT6_SERDCO",""			})
AAdd(aVetDoc,{"DT6_CLIREM",X6_CLIREM	})
AAdd(aVetDoc,{"DT6_LOJREM",X6_LOJREM	})
AAdd(aVetDoc,{"DT6_CLIDES",X6_CLIDES	})
AAdd(aVetDoc,{"DT6_LOJDES",X6_LOJDES	})
AAdd(aVetDoc,{"DT6_CLIDEV",X6_CLIDEV	})
AAdd(aVetDoc,{"DT6_LOJDEV",X6_LOJDEV	})
AAdd(aVetDoc,{"DT6_CLICAL",X6_CLICAL	})
AAdd(aVetDoc,{"DT6_LOJCAL",X6_LOJCAL	})
AAdd(aVetDoc,{"DT6_DEVFRE",X6_DEVFRE	})
AAdd(aVetDoc,{"DT6_FATURA",""			})
AAdd(aVetDoc,{"DT6_SERVIC",X6_SERVIC	})
AAdd(aVetDoc,{"DT6_CODMSG",X6_CODMSG	})
AAdd(aVetDoc,{"DT6_STATUS",X6_STATUS	})
AAdd(aVetDoc,{"DT6_DATEDI",CToD("//")	})
AAdd(aVetDoc,{"DT6_NUMSOL",""			})
AAdd(aVetDoc,{"DT6_VENCTO",CToD("//")	})
AAdd(aVetDoc,{"DT6_FILDEB",X6_FILDEB	})
AAdd(aVetDoc,{"DT6_PREFIX",""			})
AAdd(aVetDoc,{"DT6_NUM"   ,""			})
AAdd(aVetDoc,{"DT6_TIPO"  ,""			})
AAdd(aVetDoc,{"DT6_MOEDA" , 1			})
AAdd(aVetDoc,{"DT6_BAIXA" ,CToD("//")	})
AAdd(aVetDoc,{"DT6_FILNEG",""			})
AAdd(aVetDoc,{"DT6_ALIANC",""			})
AAdd(aVetDoc,{"DT6_REENTR", 0			})
AAdd(aVetDoc,{"DT6_TIPMAN",""			})
AAdd(aVetDoc,{"DT6_PRZENT",STOD(X6_PRZENT)	})
AAdd(aVetDoc,{"DT6_FIMP"  ,X6_FIMP	})
AAdd(aVetDoc,{"DT6_CHVCTE" ,X6_CHVCTE	})
AAdd(aVetDoc,{"DT6_CLICON" ,X6_CLICON	})
AAdd(aVetDoc,{"DT6_LOJCON" ,X6_LOJCON	})
AAdd(aVetDoc,{"DT6_NFELET" ,X6_NFELET	})
AAdd(aVetDoc,{"DT6_EMINFE" ,STOD(X6_EMINFE)	})
AAdd(aVetDoc,{"DT6_CODNFE" ,X6_CODNFE	})
AAdd(aVetDoc,{"DT6_IDRCTE" ,X6_IDRCTE	})
AAdd(aVetDoc,{"DT6_PROCTE" ,X6_PROCTE	})
AAdd(aVetDoc,{"DT6_SITCTE" ,X6_SITCTE	})

If _lCTeComp
	//-- Array aDocOri                                         ณฑฑ
	//-- [1] - Filial Docto Original  (caracter)               ณฑฑ
	//-- [2] - No. Docto Original     (caracter)               ณฑฑ
	//-- [3] - Serie Docto Original   (caracter)               ณฑฑ
	//-- [4] - % Docto. Orignal       (numerico)               ณฑฑ
	//-- [5] - Complemento de Imposto (l๓gico)                 ณฑฑ
	//
	//TMSA500 - MANUTENCAO
	//DT6 - FILDCO
	//    - DOCDCO
	//    - SERDCO
	
	AAdd(aDocOri,X6_FILIAL)
//	AAdd(aDocOri,alltrim(str(xDocOri))+space(9-len(alltrim(str(xDocOri)))))
	AAdd(aDocOri,alltrim(xDocOri) )
//	AAdd(aDocOri,alltrim(str(xSerOri))+space(3-len(alltrim(str(xSerOri)))))
	AAdd(aDocOri,alltrim(xSerOri) )
	AAdd(aDocOri,100)
	AAdd(aDocOri,.F.) //.F. Complemento de Valor ; .T. Complemento de Imposto
ElseIf _lCTeAnul
	AADD(aDocAnul,X6_DOC)				//DOC
	AADD(aDocAnul,X6_FILIAL)			//FILDOC
	AADD(aDocAnul,alltrim(xDocOri))		//DOC ORI
	AADD(aDocAnul,alltrim(xSerOri))		//SERIE ORI
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  06/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Canal C                                                    บฑฑ
ฑฑบ          ณ Tabela DT8                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ler_C()

X8_FILIAL  := Substr(_cBuffer,032,004) //32	 35 = 4
X8_CODPAS  := Substr(_cBuffer,036,002) //36	 37 = 2
X8_VALPAS  := Substr(_cBuffer,038,013) //38	 50 = 13
X8_VALIMP  := Substr(_cBuffer,052,013) //52	 64 = 13
X8_VALTOT  := Substr(_cBuffer,066,013) //66	 78 = 13
X8_FILDOC  := Substr(_cBuffer,080,004) //80	 83 = 4
X8_DOC     := Substr(_cBuffer,084,009) //84	 92 = 9
X8_SERIE   := Substr(_cBuffer,093,003) //93	 95 = 3
X8_ITEMD2  := Substr(_cBuffer,096,002) //96	 97 = 2
X8_FILORI  := Substr(_cBuffer,098,004) //98	101 = 4
X8_CDRORI  := Substr(_cBuffer,102,006) //102	107 = 6
X8_CDRDES  := Substr(_cBuffer,108,006) //108	113 = 6
X8_CODPRO  := Substr(_cBuffer,114,018) //114	128 = 15
X8_TABFRE  := Substr(_cBuffer,132,004) //129	132 = 4
X8_TIPTAB  := Substr(_cBuffer,136,002) //133	134 = 2

X8_XALIQ   := Substr(_cBuffer,138,005) //
X8_XTES    := Substr(_cBuffer,143,003) //
X8_XCFOP   := Substr(_cBuffer,146,004) //

X8_TABFRE := "0002" //tiram em Produ็ใo. Somente para HOMOLOGACAO
X8_FILORI := "    "

AAdd(aVetVlr,{	{"DT8_FILIAL",xFilial("DT8")},;
{"DT8_CODPAS",X8_CODPAS	},;
{"DT8_VALPAS",VAL(X8_VALPAS)	},;
{"DT8_VALIMP",VAL(X8_VALIMP)	},;
{"DT8_VALTOT",VAL(X8_VALTOT)	},;
{"DT8_FILORI",X8_FILORI	},;
{"DT8_TABFRE",X8_TABFRE	},;
{"DT8_TIPTAB",X8_TIPTAB	},;
{"DT8_FILDOC",X8_FILDOC	},;
{"DT8_CODPRO",X8_CODPRO	},;
{"DT8_DOC"   ,X8_DOC		},;
{"DT8_SERIE" ,X8_SERIE	},;
{"VLR_ICMSOL",0}})

AAdd(aVetVlr,{	{"DT8_FILIAL",xFilial("DT8")},;
{"DT8_CODPAS","TF"			},;
{"DT8_VALPAS",VAL(X8_VALPAS)	},;
{"DT8_VALIMP",VAL(X8_VALIMP)	},;
{"DT8_VALTOT",VAL(X8_VALTOT)	},;
{"DT8_FILORI",X8_FILORI	},;
{"DT8_TABFRE",X8_TABFRE	},;
{"DT8_TIPTAB",X8_TIPTAB	},;
{"DT8_FILDOC",X8_FILDOC	},;
{"DT8_CODPRO",X8_CODPRO	},;
{"DT8_DOC"   ,X8_DOC		},;
{"DT8_SERIE" ,X8_SERIE	},;
{"VLR_ICMSOL",0}})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  06/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function SelArq(aItens)

Local aDir
Local cImg
Local nPosIni

cDir	:= cGetFile("Diretorio |*.*","Txt",1,"SERVIDOR",.F., GETF_LOCALHARD)
cImg	:= "TXT"
aDir	:= Directory(cDir+"*."+cImg)
aItens	:= {}

For n := 1 to len(aDir)
	nPosIni	:= At(".", aDir[n,1]) + 1
	If Substr( aDir[n,1], nPosIni, 3) $ cImg
		Aadd(aItens, cDir + aDir[n,1] )
	EndIf
Next

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSA004  บAutor  ณMicrosiga           บ Data ณ  07/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraLog()

_cFileog := NomeAutoLOg()
If _cFileog <> nil
	If File(dtos(ddatabase)+".txt")
		ferase("\1-MILE\log-cte\"+dtos(ddatabase)+".txt")
	EndIf
	__CopyFile("\system\"+_cFileog,"\1-MILE\log-cte\"+dtos(ddatabase)+".txt")
	
	ferase("\system\"+_cFileog)
Else
	If File(dtos(ddatabase)+".txt")
		ferase("\1-MILE\log-cte\"+dtos(ddatabase)+".txt")
	EndIf
EndIf

Return
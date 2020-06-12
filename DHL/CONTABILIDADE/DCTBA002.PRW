#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDCTBA002  บAutor  ณMicrosiga           บ Data ณ  05/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DCTBA002()

aPerguntas := {}
aRetorno   := {}

//Perguntas
AAdd(aPerguntas,{ 6,"Arquivo"		  ,Padr("",150),"",,"", 90 ,.T.,"","",GETF_LOCALHARD+GETF_NETWORKDRIVE})
Aadd(aPerguntas,{ 1,"N๚mero do Lote"  ,Space(TamSx3('CT2_LOTE')[1]),"@!","","","",0,	.T.})
Aadd(aPerguntas,{ 1,"Tamanho da Linha","0304","9999","","","",0,	.T.})

If !ParamBox(aPerguntas,"Importa็ใo Contแbil",@aRetorno)
	Return(Nil)
EndIf

Processa({|lEnd| DCTBATxt(aRetorno) })
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDCTBA002  บAutor  ณMicrosiga           บ Data ณ  05/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DCTBATxt(_aPar)
Local nHdlPrv	:=0
Local nBytes	:=0
Local nHdlImp
Local nTamArq
Local nTamLinha := Iif(Empty(mv_par03),512,Val(mv_par03))

PRIVATE xBuffer	:=Space(nTamLinha)
Private _lErro := .F.

If Empty(mv_par01)
	Help(" ",1,"NOFLEIMPOR")
	Return
End

nHdlImp:=FT_FUse(AllTrim(Mv_Par01))

If nHdlImp == -1
	Help(" ",1,"NOFILE")
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica o Nฃmero do Lote                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLote := mv_par02
If Empty(cLote)
	Help(" ",1,"NOCT210LOT")
	Return
EndIf

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

Private _lHistComp	:= .F.
_cHistComp	:= ""

_cOrigem := ""
_cDoc    := "000001"
_cLinha  := "001"
_nLi	 := 1 //Linhas processadas
_cHrIni  := TIME()
_lFirst	:= .T.

//Begin Transaction 
_cArq	:= alltrim(mv_par01)
For _nI := 1 to len(_cArq)
	_nPosBar := AT("\",_cArq)
	_cArq := substr(_cArq,_nPosBar+1,len(_cArq))
	If _nPosBar == 0
		exit
	EndIf
Next _nI
_nPosPnt := AT(".",_cArq)
_cArquivo:= SUBSTR(_cArq,1,_nPosPnt-1)+".txt"

While !FT_FEOF()
	
	IncProc("Arq."+_cArquivo+" Numero de Linhas "+ alltrim(strzero(_nLi,6))+ Chr(13) + Chr(10)+" Hora inicial:"+_cHrIni + " tempo:"+ ELAPTIME(_cHrIni,TIME()))
	
	xBuffer	:= Space(nTamLinha)
	xBuffer := FT_FREADLN()
	
	cPadrao	:= SubStr(xBuffer,1,3)
	lPadrao	:= VerPadrao(cPadrao)
	
	IF !lPadrao
		nBytes+=nTamLinha
		Loop
	ENDIF
	
	IF !Empty(_cOrigem) .and. _cOrigem <> &(CT5->CT5_ORIGEM)
		_cDoc := Soma1(_cDoc)
		_cLinha := "001"
	ENDIF

	If Len(alltrim(&(CT5->CT5_HIST))) > 40
		_lHistComp	:= .T.
		_cHistComp	:= Substr(alltrim(&(CT5->CT5_HIST)),41,20)
	EndIf

	If _lFirst
		_lFirst := .F.
		//Verifica a existencia de Calendario Contabil
		_cData	:= SUBSTR(xBuffer,120,08)
		_dData	:= ctod(SUBSTR(_cData,1,2)+"/"+SUBSTR(_cData,3,2)+"/"+SUBSTR(_cData,5,4))
		nOpc	:= 3
		_lOK := CtbValiDt(nOpc,_dData)
		
		If !_lOK //Calendแrio nใo cadastrado
			Exit
		EndIf
	EndIf
	
	//Verifica se ja existe lancamento na mesma Data e Lote
	CHKFILE("CT2")
	DbSelectArea("CT2")
	DbGotop()
	If CT2->(DbSeek(xFilial("CT2")+DTOS(_dData)+cLote+"001"+_cDoc+_cLinha))
		//Ct102VlDoc(_dData,cLote,"001",_cDoc,"CTBA102")
		//Exit
		FT_FSKIP()
		Loop
	EndIf

	_cData	:= SUBSTR(xBuffer,120,08)
	_dData	:= ctod(SUBSTR(_cData,1,2)+"/"+SUBSTR(_cData,3,2)+"/"+SUBSTR(_cData,5,4))

	RecLock("CT2",.T.)
	CT2->CT2_FILIAL	:= xFilial("CT2")
	CT2->CT2_DATA		:= _dData
	CT2->CT2_DC		:= CT5->CT5_DC	
	CT2->CT2_LOTE		:= cLote
	CT2->CT2_SBLOTE	:= "001"
	CT2->CT2_DOC		:= _cDoc
	CT2->CT2_LINHA	:= _cLinha
	CT2->CT2_MOEDLC	:= "01"
	CT2->CT2_DEBITO	:= IIF(Empty(CT5->CT5_DEBITO),"",&(CT5->CT5_DEBITO))
	CT2->CT2_CREDIT	:= IIF(Empty(CT5->CT5_CREDIT),"",&(CT5->CT5_CREDIT))
	CT2->CT2_VALOR	:= &(CT5->CT5_VLR01)
	CT2->CT2_HIST		:= &(CT5->CT5_HIST)
	CT2->CT2_CCD		:= IIF(Empty(CT5->CT5_CCD),"",&(CT5->CT5_CCD))
	CT2->CT2_CCC		:= IIF(Empty(CT5->CT5_CCC),"",&(CT5->CT5_CCC))
	CT2->CT2_ITEMD	:= IIF(Empty(CT5->CT5_ITEMD),"",&(CT5->CT5_ITEMD))
	CT2->CT2_ITEMC	:= IIF(Empty(CT5->CT5_ITEMC),"",&(CT5->CT5_ITEMC))
	CT2->CT2_CLVLDB	:= IIF(Empty(CT5->CT5_CLVLDB),"",&(CT5->CT5_CLVLDB))
	CT2->CT2_CLVLCR	:= IIF(Empty(CT5->CT5_CLVLCR),"",&(CT5->CT5_CLVLCR))
	
	CT2->CT2_EMPORI	:= cEmpAnt
	CT2->CT2_FILORI	:= cFilAnt
	CT2->CT2_TPSALD	:= CT5->CT5_TPSALD
	CT2->CT2_MANUAL	:= "1"
	CT2->CT2_ORIGEM	:= &(CT5->CT5_ORIGEM)
	CT2->CT2_ROTINA	:= "CTBA102"
	CT2->CT2_AGLUT	:= "2"
	CT2->CT2_LP		:= cPadrao
	CT2->CT2_SEQHIS	:= "001"
	CT2->CT2_SEQLAN	:= _cLinha
	CT2->CT2_CRCONV	:= "1"
	CT2->CT2_DTCONF	:= dDataBase
	
	CT2->CT2_ZPART	:= IIF(Empty(CT5->CT5_ZPART),"",&(CT5->CT5_ZPART))
	CT2->CT2_ZDATA	:= IIF(Empty(CT5->CT5_ZDATA),"",&(CT5->CT5_ZDATA))
	CT2->CT2_ZDOC		:= IIF(Empty(CT5->CT5_ZDOC),"",&(CT5->CT5_ZDOC))
	CT2->CT2_ZUSER	:= IIF(Empty(CT5->CT5_ZUSER),"",&(CT5->CT5_ZUSER))
	CT2->CT2_ZHIST	:= IIF(Empty(CT5->CT5_ZHIST),"",&(CT5->CT5_ZHIST))
	
	CT2->CT2_XDATA	:= DATE()
	CT2->CT2_XTIME	:= TIME()
	
	MsUnLock()

	_cLinha := Soma1(_cLinha)
	_cOrigem := CT2->CT2_ORIGEM

	If _lHistComp
		DCTBAHis(_cHistComp, _cLinha, _dData)
	EndIf

	nBytes+=nTamLinha
	_nLi++
	FT_FSKIP()
EndDo

FT_FUSE()

MsgAlert("Processamento Finalizado")

//End Transaction

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDCTBA002  บAutor  ณMicrosiga           บ Data ณ  05/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DCTBAHis(_cHistComp, _nLinAnt, _dData)

	_lHistComp	:= .T.

	RecLock("CT2",.T.)
	CT2->CT2_FILIAL	:= xFilial("CT2")
	CT2->CT2_DATA		:= _dData
	CT2->CT2_DC		:= "4"
	CT2->CT2_LOTE		:= cLote
	CT2->CT2_SBLOTE	:= "001"
	CT2->CT2_DOC		:= _cDoc
	CT2->CT2_LINHA	:= _cLinha
	CT2->CT2_MOEDLC	:= "01"
	CT2->CT2_HIST		:= _cHistComp
	CT2->CT2_EMPORI	:= cEmpAnt
	CT2->CT2_FILORI	:= cFilAnt
	CT2->CT2_TPSALD	:= CT5->CT5_TPSALD
	CT2->CT2_MANUAL	:= "1"
	CT2->CT2_ORIGEM	:= &(CT5->CT5_ORIGEM)
	CT2->CT2_ROTINA	:= "CTBA102"
	CT2->CT2_AGLUT	:= "2"
	CT2->CT2_LP		:= cPadrao
	CT2->CT2_SEQHIS	:= "002"
	CT2->CT2_SEQLAN	:= _nLinAnt
	CT2->CT2_CRCONV	:= "1"
	CT2->CT2_DTCONF	:= dDataBase
	CT2->CT2_XDATA	:= DATE()
	CT2->CT2_XTIME	:= TIME()
	
	MsUnLock()
	_cLinha := Soma1(_cLinha)
Return()
#include "rwmake.ch"
#include "protheus.ch"

User Function DCTBA001()

Private _nLin	:= 0
Private _aErro	:= {}
Private _cErro	:= ""

aPerguntas := {}
aRetorno   := {}

//Perguntas
AAdd(aPerguntas,{ 6,"Arquivo"		  ,Padr("",150),"",,"", 90 ,.T.,"","",GETF_LOCALHARD+GETF_NETWORKDRIVE})
Aadd(aPerguntas,{ 1,"Tamanho da Linha","0304","9999","","","",0,	.T.})

If !ParamBox(aPerguntas,"Importa็ใo Contแbil",@aRetorno)
	Return(Nil)
EndIf

Processa( {|| Analisa() }, "Processando Arquivos..." )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณANALTXT   บAutor  ณMicrosiga           บ Data ณ  04/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Analisa()

nHandle := FT_FUSE(mv_par01)
if nHandle = -1
	ALERT("Arquivo nใo encontrado")  
	return
endif

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

AutoGrLog("Inicio Log "+alltrim(mv_par01))
AutoGrLog("hr "+TIME()+" "+DTOC(DDATABASE))

aadd(_aErro,{"Tam","Linha     ","Cta Debito          ","Cta Credito         ","CC Debito ","CC Credito","IT Debito ","IT Credito","CL Debito ","CL Credito"})

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

Do While !FT_FEOF()
	IncProc("Processando Leitura do Arquivo "+_cArquivo+"..."+ alltrim(str(_nLin)))
	_nLin++
	xBuffer 	:=	FT_FREADLN()
	if len(xBuffer+" ") <> VAL(mv_par02)
		aadd(_aErro,{"XXX",strzero(_nLin,10),Space(20),Space(20),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10)})
	EndIf

	cPadrao	:= SubStr(xBuffer,1,3)
	lPadrao	:= VerPadrao(cPadrao)

	_cDebito	:= IIF(Empty(CT5->CT5_DEBITO),"",&(CT5->CT5_DEBITO))
	_cCredito	:= IIF(Empty(CT5->CT5_CREDIT),"",&(CT5->CT5_CREDIT))
	_cCCDebit	:= IIF(Empty(CT5->CT5_CCD),"",&(CT5->CT5_CCD))
	_cCCCredi	:= IIF(Empty(CT5->CT5_CCC),"",&(CT5->CT5_CCC))
	_cITDebit	:= IIF(Empty(CT5->CT5_ITEMD),"",&(CT5->CT5_ITEMD))
	_cITCredi	:= IIF(Empty(CT5->CT5_ITEMC),"",&(CT5->CT5_ITEMC))
	_cCLDebit	:= IIF(Empty(CT5->CT5_CLVLDB),"",&(CT5->CT5_CLVLDB))
	_cCLCredi	:= IIF(Empty(CT5->CT5_CLVLCR),"",&(CT5->CT5_CLVLCR))

	If !CT1->(DbSeek(xFilial("CT1")+_cDebito)) .and. !Empty(_cDebito)
		_nPos := ascan(_aErro, {|x| x[2] == strzero(_nLin,10) })
		If _nPos>0
			_aErro[_nPos,3] := _cDebito
		Else
			aadd(_aErro,{"   ",strzero(_nLin,10),_cDebito,space(20),space(10),space(10),space(10),space(10),space(10),space(10)})
		EndIf
	EndIf
	If !CT1->(DbSeek(xFilial("CT1")+_cCredito)) .and. !Empty(_cCredito)
		_nPos := ascan(_aErro, {|x| x[2] == strzero(_nLin,10) })
		If _nPos>0
			_aErro[_nPos,4] := _cCredito
		Else
			aadd(_aErro,{"   ",strzero(_nLin,10),space(20),_cCredito,space(10),space(10),space(10),space(10),space(10),space(10)})
		EndIf
	EndIf
	If !CTT->(DbSeek(xFilial("CTT")+_cCCDebit)) .and. !Empty(_cCCDebit)
		_nPos := ascan(_aErro, {|x| x[2] == strzero(_nLin,10) })
		If _nPos>0
			_aErro[_nPos,5] := _cCCDebit
		Else
			aadd(_aErro,{"   ",strzero(_nLin,10),space(20),space(20),_cCCDebit,space(10),space(10),space(10),space(10),space(10)})
		EndIf
	EndIf
	If !CTT->(DbSeek(xFilial("CTT")+_cCCCredi)) .and. !Empty(_cCCCredi)
		_nPos := ascan(_aErro, {|x| x[2] == strzero(_nLin,10) })
		If _nPos>0
			_aErro[_nPos,6] := _cCCCredi
		Else
			aadd(_aErro,{"   ",strzero(_nLin,10),space(20),space(20),space(10),_cCCCredi,space(10),space(10),space(10),space(10)})
		EndIf
	EndIf
	If !CTD->(DbSeek(xFilial("CTD")+_cITDebit)) .and. !Empty(_cITDebit)
		_nPos := ascan(_aErro, {|x| x[2] == strzero(_nLin,10) })
		If _nPos>0
			_aErro[_nPos,7] := _cITDebit
		Else
			aadd(_aErro,{"   ",strzero(_nLin,10),space(20),space(20),space(10),space(10),_cITDebit,space(10),space(10),space(10)})
		EndIf
	EndIf
	If !CTD->(DbSeek(xFilial("CTD")+_cITCredi)) .and. !Empty(_cITCredi)
		_nPos := ascan(_aErro, {|x| x[2] == strzero(_nLin,10) })
		If _nPos>0
			_aErro[_nPos,8] := _cITCredi
		Else
			aadd(_aErro,{"   ",strzero(_nLin,10),space(20),space(20),space(10),space(10),space(10),_cITCredi,space(10),space(10)})
		EndIf
	EndIf
	If !CTH->(DbSeek(xFilial("CTH")+_cCLDebit)) .and. !Empty(_cCLDebit)
		_nPos := ascan(_aErro, {|x| x[2] == strzero(_nLin,10) })
		If _nPos>0
			_aErro[_nPos,9] := _cCLDebit
		Else
			aadd(_aErro,{"   ",strzero(_nLin,10),space(20),space(20),space(10),space(10),space(10),space(10),_cCLDebit,space(10)})
		EndIf
	EndIf
	If !CTH->(DbSeek(xFilial("CTH")+_cCLCredi)) .and. !Empty(_cCLCredi)
		_nPos := ascan(_aErro, {|x| x[2] == strzero(_nLin,10) })
		If _nPos>0
			_aErro[_nPos,10] := _cCLCredi
		Else
			aadd(_aErro,{"   ",strzero(_nLin,10),space(20),space(20),space(10),space(10),space(10),space(10),space(10),_cCLCredi})
		EndIf
	EndIf

	FT_FSKIP()
EndDo

For _nXX := 1 to Len(_aErro)
	_cTxt	:= _aErro[_nXX,1]+";"+_aErro[_nXX,2]+";"+_aErro[_nXX,3]+";"+_aErro[_nXX,4]+";"+_aErro[_nXX,5]+";"+_aErro[_nXX,6]+";"+_aErro[_nXX,7]+";"+_aErro[_nXX,8]+";"+_aErro[_nXX,9]+";"+_aErro[_nXX,10]
	AutoGrLog(_cTxt)
Next _nXX
AutoGrLog("hr "+TIME()+" "+DTOC(DDATABASE))
AutoGrLog("Fim Log "+alltrim(mv_par01))

//mostraerro()
_cFileog := NomeAutoLOg()
If _cFileog <> nil
	__CopyFile("\system\"+_cFileog,"\system\log_"+_cArquivo)
//	ferase("\system\"+_cFileog)

	aPerguntas := {}
	aRetorno   := {}

	//Perguntas
	AAdd(aPerguntas,{ 6,"Salvar arquivo LOG"		  ,Padr(_cArquivo,150),"",,"", 90 ,.T.,"","",GETF_LOCALHARD+GETF_NETWORKDRIVE})
	
	If !ParamBox(aPerguntas,"Importa็ใo Contแbil",@aRetorno)
		Return(Nil)
	Else
		__CopyFile("\system\"+_cFileog,alltrim(mv_par01)+".TXT")

	EndIf

EndIf

Return
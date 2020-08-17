#include "rwmake.ch"
#include "topconn.ch"

USER FUNCTION QSQL()

Private _nRet
Private _nCount

If Select("SM0") > 0
	
	Alert(" Esta rotina deve ser inicializada diretamente pelo Remote")
	Return
	
EndIf


cIP := "                              "
cCon := "TOPSQL"
cTip := "TCPIP"
cBanc := "MSSQL7"

@ 200,1 TO 370,400 DIALOG _oDlg2 TITLE "IP TopConnet"
@ 010,016 Say "IP TopConnect: "
@ 010,060 Get cIP
@ 020,016 Say "Nome Conexao: "
@ 020,060 Get cCon
@ 030,016 Say "Tipo Conexao: "
@ 030,060 Get cTip
@ 040,016 Say "Tipo Banco: "
@ 040,060 Get cBanc


@ 5,08 TO 55,180
@ 060,100 BmpButton Type 01 Action (_Proc(cIP,cCon,cTip,cBanc),Close(_oDlg2))
@ 060,150 BmpButton Type 02 Action Close(_oDlg2)
ACTIVATE DIALOG _oDlg2 CENTERED

Return

Static Function _Proc(cIP,cCon,cTip,cBanc)

//Close(_oDlg2)
processa({|| _Conect(cIP,cCon,cTip,cBanc)})

_FExec()

Return



Static Function _Conect(cIP,cCon,cTip,cBanc)


ProcRegua(3)

IncProc("Conectando...")
TCConType(cTip)
IncProc("Conectando...")
nCon := TCLink(cBanc+"/"+cCon,cIP)

if nCon < 0
	Alert("Falha conectando")
	Return
endif

IncProc("Conectando...")
TCSetConn(nCon)

Return

Static Function _FExec(_cText)


Private oMemo , cfOpen

Private Courier6:= TFont():New( "Courier",,6,,.t.,,,,,.f. )

_cTexto := ""


Private _lEntra:=.T.
Private cTitulo:="APQuery"
Private _aStruct
cArqTab := ""
lQuery := .T.
_cTT := 1

If _cText == nil
	_cQueryTxt := ""
Else
	_cQueryTxt := _cText
EndIf


DEFINE MSDIALOG oDlg1 TITLE cTitulo From 001,001 To 32,100

@ 180,010 Say OemToAnsi("Arquivo: <SEM NOME>"+Space(100)) Object oNome
@ 180,120 Say OemToAnsi("Result: 0 Linhas ") Object oRes
@ 180,190 Say OemToAnsi("Status: "+Space(40)) Object oStat
@ 180,330 BmpButton Type 14 Action FRABRE()
@ 180,360 BmpButton Type 13 Action FRSalva()
@ 200,360 BmpButton Type 13 Action FRSalvaComo()
@ 200,330 BmpButton Type 4  Action FRSalvaRes()

@ 190,010 Get _cQueryTxt   Size 300,040  MEMO Object oMemo
@ 210,330 BmpButton Type 15 Action (EXECUTA(),Close(oDlg1))
@ 210,360 BmpButton Type 2 Action (FIM(),Close(oDlg1))



Activate Dialog oDlg1 centered

Return


Static Function Fim()

//close(oDlg1)
TCQuit()

Return

STATIC FUNCTION EXECUTA()

Private lEnd := .F.

_nCount := 0
_cTexto := ""

_cTemp := ALLTRIM("TM"+ALLTRIM(STR(_cTT)))

If Select(_cTemp) > 0
	
	DbSelectArea(_cTemp)
	DBCloseArea()
	
EndIf

oMemo:= tMultiget():New(001,010,{|u|if(Pcount()>0,_cTexto:=u,_cTexto)},oDlg1,380,180,Courier6,.T.,,,,.T.)
oMemo:lWordWrap := .F.
oMemo:EnableHScroll( .T. )

processa({|lEnd| _RodaQ(@lEnd)}, 'Carregando Dados...')   

//RptStatus({|lEnd| GR200Imp(@lEnd,wnRel,cString)},Titulo)

If _nRet#0
	Return
EndIf


//@ 180,120 Say OemToAnsi("Result: 0 Linhas ") Object oRes
oMemo:Refresh()

ObjectMethod(oRes,"SetText('Result: '+ALLTRIM(STR(_nCount))+' Linhas')")
ObjectMethod(oStat,"SetText('Status: Concluido')")



RETURN()


Static Function FRAbre()

ObjectMethod(oStat,"SetText('Status: Abrindo Arq')")
cFOpen := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",OemToAnsi("Abrir Arquivo..."))
If !Empty(cFOpen)
	_cQueryTxt := MemoRead(cFOpen)
	ObjectMethod(oMemo,"Refresh()")
	ObjectMethod(oNome,"SetText('Arquivo: '+cFOpen)")
	ObjectMethod(oStat,"SetText('Status: Concluido')")
Endif

Return


Static Function FRSalva()
If !Empty(cFOpen)
	ObjectMethod(oStat,"SetText('Status: Salvando Arq')")
	MemoWrit(cFOpen,_cQueryTxt)
	ObjectMethod(oStat,"SetText('Status: Concluido')")
Endif
Return

Static Function FRSalvaComo()
cAux   := cFOpen
cFOpen := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",OemToAnsi("Salvar Arquivo Como..."))
If !Empty(cFOpen)
	ObjectMethod(oStat,"SetText('Status: Salvando Arq')")
	MemoWrit(cFOpen,_cQueryTxt)
	ObjectMethod(oNome,"SetText('Arquivo: '+cFOpen)")
	ObjectMethod(oStat,"SetText('Status: Concluido')")
Else
	cFOpen := cAux
Endif
Return

Static Function FRSalvaRes()

cFOpen2 := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",OemToAnsi("Salvar Resultado Como..."))
If !Empty(cFOpen2)
	MemoWrit(cFOpen2,_cTexto)
	ObjectMethod(oNome,"SetText('Arquivo: '+cFOpen2)")
Endif
Return





Static Function _RodaQ(lEnd)

ProcRegua(3)

// Analisa a query quanto a possibilidade de alteracao de dados. Nao permite execucao.
_cOper:={"DROP","TRUNCATE","DELETE","UPDATE","INSERT"}
For _i:=1 to Len(_cOper)
	If AT(_cOper[_i],_cQueryTxt)>0
		APMsgAlert("Alteracao de dados NAO permitida!",cTitulo)
		Return()
	Endif
Next

IncProc("Verificando Erros")
ObjectMethod(oStat,"SetText('Status: Verificando Erros')")
// Verifica se tem erros na Query. A Query e executada. Caso isso nao seja feito e houver erro na Query, o programa eh abortado.

_nRet = TCSQLEXEC("set parseonly on"+CHR(13)+_cQueryTxt+CHR(13)+"set parseonly off")

//_nRet = TCSQLEXEC(_cQueryTxt)

//TCSQLEXEC("set parseonly off")


If _nRet#0
	_cRet = TCSQLERROR()
	Do While !Empty(_cRet)
		APMsgAlert(AllTrim(_cRet),cTitulo)
		_cRet = TCSQLERROR()
	EndDo
	Return()
EndIf
//****************************************************************************

DBCLOSEAREA()

ObjectMethod(oStat,"SetText('Status: Pesquisando Dados')")

IncProc("Executando Query")
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQueryTxt), _cTemp, .F., .T.)

IncProc("Query OK")


DBSELECTAREA(_cTemp)
DBGOTOP()

_aStruct:=DbStruct()	// Pega a estrutura do RecordSet

DbSelectArea(_cTemp)
DBGotop()
_cTexto := ""
_nTam := 1023
_nCam := 0


For _i := 1 to Len(_aStruct)
	
	If _aStruct[_i,2] != "C"
		
		_cCampo := ALLTRIM(_aStruct[_i,1])
		
		If 	LEN(_cCampo) > 17
			_Tam := 0
		Else
			_Tam := LEN(_cCampo) - 17
			_Tam := _Tam * -1
		EndIf
	Else
		_cCampo := ALLTRIM(_aStruct[_i,1])
		
		If 	LEN(_cCampo) > _aStruct[_i,3]
			_Tam := 0
		Else
			_Tam := LEN(_cCampo) - _aStruct[_i,3]
			_Tam := _Tam * -1
		EndIf
		
	EndIf
	
	If Len(_cTexto) + Len(_cCampo) > _nTam
		
		If _nCam == 0
			_nCam := _i
		EndIf
		
	Else
		_nCam := _i
		_cTexto += _cCampo
		_cTexto += Space(_Tam+3)
	EndIf
	
Next

_cTexto += CHR(10)+CHR(13)
_nCount := 0
_nDiv := 5
ObjectMethod(oStat,"SetText('Status: Preparando Arq de Saida')")
While !EOF()
	For _i := 1 to _nCam
		If _aStruct[_i,2] != "C"
			
			_cCampo := "ALLTRIM(STR("+ALLTRIM(_cTemp)+"->"+ALLTRIM(_aStruct[_i,1])+"))"
			
			_Tam := LEN(&_cCampo) - 17
			_Tam := _Tam * -1
			
			_cTexto += &_cCampo
			_cTexto += Space(_Tam+3)
		Else
			
			_cCampo := "ALLTRIM("+ALLTRIM(_cTemp)+"->"+ALLTRIM(_aStruct[_i,1])+")"
			
			
			If 	LEN(ALLTRIM(_aStruct[_i,1])) > LEN(&_cCampo)
				
				If 	LEN(ALLTRIM(_aStruct[_i,1])) > _aStruct[_i,3]
					
					_Tam := LEN(ALLTRIM(_aStruct[_i,1])) - LEN(&_cCampo)
					
				Else
					
					_Tam := LEN(&_cCampo) - _aStruct[_i,3]
					_Tam := _Tam * -1
				EndIf
			Else
				_Tam := LEN(&_cCampo) - _aStruct[_i,3]
				_Tam := _Tam * -1
			EndIf
			
			_cTexto += &_cCampo
			_cTexto += Space(_Tam+3)
			
			
		Endif
	Next
	_cTexto += CHR(13)
	DBSkip()
	IncProc("Carregando Resultado na Memoria" + ALLTRIM(STR(_nCount)))
	
	If _nCount ==  (_nDiv * 5 )
		
		_nDiv := _nDiv * 5
		
	EndIf
	
	If mod(_nCount,_nDiv) == 0
		oMemo:Refresh()
		ObjectMethod(oRes,"SetText('Result: '+ALLTRIM(STR(_nCount))+' Linhas')")
	EndIf
	
	_nCount++
	If lEnd
		_cTexto += CHR(13)
		_cTexto += CHR(13)
		_cTexto += CHR(13)
		
		_ctexto += 	" Processo abortado !!!!!"
		
		Return
		
	EndIf
EndDo

If _nCam <> len(_aStruct)
	_cTexto += CHR(13)
	_cTexto += CHR(13)
	_cTexto += CHR(13)
	_cTexto += CHR(13)
	_cTexto += CHR(13)
	
	_ctexto += 	" Apos o campo "+ALLTRIM(_aStruct[_i-1,1])+" a Tab sera truncada"
	
EndIf



Return

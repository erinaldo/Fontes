#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA26   บ Autor ณ Andy               บ Data ณ  21/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Antecipa็ใo do Movimento Bancario para Fluxo de Caixa      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINA26()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cArq,cInd,cPerg
Local cString := "SE5"
Local aStru

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private aPags := {}
Private _dPar01, _dPar02
Private _lRet

dbSelectArea("SE5")
dbSetOrder(1)

// AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3)
// AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk)
// AxDeleta(cAlias,nReg,nOpc,aAcho,cFunc)


cCadastro := "Antecipacao Contas a Pagar - Movimentacao Bancaria"
aCores    := {}
aRotina   := { 	{"Pesquisar" ,"AxPesqui"    , 0 , 1},;
{"Visualizar"   ,"AxVisual"   , 0 , 2},;
{"Antecipar"    ,"U_ANTECIPA" , 0 , 3},;
{"Legenda"      ,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","Nao Antecipado"},{"BR_VERMELHO","Antecipado"},{"BR_AMARELO","Reconciliado"},{"BR_AZUL","Cancelado"}})',0 , 4 }}

Aadd( aCores, { "  Empty(E5_FLUXO) .And.  Empty(E5_RECONC) .And. E5_SITUACA<>'C' "  , "BR_VERDE" 	} )
Aadd( aCores, { " !Empty(E5_FLUXO) .And.  E5_SITUACA<>'C' "                         , "BR_VERMELHO"	} )
Aadd( aCores, { "  Empty(E5_FLUXO) .And. !Empty(E5_RECONC) .And. E5_SITUACA<>'C' "  , "BR_AMARELO" 	} )
Aadd( aCores, { "                         E5_SITUACA=='C' "                         , "BR_AZUL"	    } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a Filtragem                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SE5")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SE5",,,,,2, aCores)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Antecipa บ Autor ณ Andy               บ Data ณ  21/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Preenche E5_FLUXO                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ANTECIPA()
Private cPerg  := "FIC470    "

If !Pergunte(cPerg, .T.)
	Return
EndIf

While .T.
	U_FluxoSE5()
	If !_lRet
		Exit
	EndIf
EndDo
Return

User Function FluxoSE5()

Local aArea    := GetArea() //, aPags := {}
Local oOk      := LoadBitmap( GetResources(), "LBOK" )
Local oNo      := LoadBitmap( GetResources(), "LBNO" )
aPags          := {}

dbSelectArea("SA6")
dbSetOrder(1)
IF !(dbSeek(cFilial+mv_par01+mv_par02+mv_par03))
	Help(" ",1,"BCONAOEXIST")
	Return
EndIF

_cBanco		:= A6_COD
_cAgencia	:= A6_AGENCIA
_cConta		:= A6_NUMCON

DbSelectArea("SE5")
DbSetOrder(1)
cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_DOCUMEN+E5_NUMCHEQ"

cOrder := SqlOrder(cChave)
cQuery := "SELECT *, "+ RetSqlName("SE5") +".R_E_C_N_O_ REGSE5 "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par04) + "'"
cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par05) + "'"
cQuery += " AND E5_BANCO = '"   + _cBanco   + "'"
cQuery += " AND E5_AGENCIA = '" + _cAgencia + "'"
cQuery += " AND E5_CONTA = '"   + _cConta   + "'"
cQuery += " AND E5_SITUACA <> 'C' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
cQuery += " AND E5_VENCTO <= '" + DTOS(mv_par05)  + "'"
cQuery += " AND E5_VENCTO <= E5_DATA "
cQuery += " AND E5_RECONC = ' ' "
cQuery += " AND E5_FLUXO  = ' ' "
cQuery += " AND ( (E5_TIPODOC IN ('VL','CH') AND E5_MOEDA IN ('  ')                                             ) OR  "
cQuery += "       (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','NI')) OR  "
cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO  IN ('FL ')                                       ) OR  "
cQuery += "       (E5_TIPODOC IN ('TR','TE') AND E5_MOEDA IN ('TR','TE')                                        )    )"
cQuery += " AND E5_PREFIXO NOT IN ('SEC','SBA','FCB')"
cQuery += " ORDER BY " + cOrder
cQuery := ChangeQuery(cQuery)

dbSelectAre("SE5")

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5TMP', .T., .T.)

dbSelectArea("SE5TMP")
dbGoTop()

_nConta      := 1

While !Eof()
	
	_dE5_DTDISPO := SE5TMP->E5_DTDISPO
	_cE5_DOCUMEN := SE5TMP->E5_DOCUMEN
	_cE5_NUMCHEQ := SE5TMP->E5_NUMCHEQ
	_nTotal      := 0
	_cE5_NUMERO  := SE5TMP->E5_NUMERO
	
	While !Eof() .And. _cE5_DOCUMEN == SE5TMP->E5_DOCUMEN .And. _cE5_NUMCHEQ == SE5TMP->E5_NUMCHEQ
		
		_cOpera:=" "
		
		If SE5TMP->E5_MOEDA $ "BA;TB;FL;AP;CD;TR;ES;GE;DD;RG;NI;TE" .Or. (SE5TMP->E5_TIPODOC =='BA' .And. SE5TMP->E5_TIPO =='FL ' )
			Do Case
				Case SE5TMP->E5_MOEDA $ "BA" ; _cOpera := "Pagamento Bolsa Auxilio"
				Case SE5TMP->E5_MOEDA $ "TB" ; _cOpera := "Despesa Bancaria"
				Case SE5TMP->E5_MOEDA $ "TR" ; _cOpera := "Transferencia" 
				Case SE5TMP->E5_MOEDA $ "TE" ; _cOpera := "Transferencia"				
				OtherWise
					_cOpera := AllTrim(SE5TMP->E5_BENEF)
			EndCase
		Else
			If !EMPTY(SE5TMP->E5_DOCUMEN)
				_cOpera := "Bordero para pgto."
			ElseIf !EMPTY(SE5TMP->E5_NUMCHEQ)
				_cOpera := AllTrim(SE5TMP->E5_BENEF)
			EndIf
		EndIf
		
		_cOpera := SubStr(_cOpera,1,23)
		
		_cDocumento := " "
		If SE5TMP->E5_MOEDA $ "BA;TB;FL;AP;CD;TR;ES;GE;DD;RG;NI;TE"  .Or. (SE5TMP->E5_TIPODOC =='BA' .And. SE5TMP->E5_TIPO =='FL ' )
			
			Do Case
				Case SE5TMP->E5_MOEDA $ "BA" ; _cDocumento := "BA "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "TB" ; _cDocumento := "Tarifa"
				Case SE5TMP->E5_MOEDA $ "TR" ; _cDocumento := "TB "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "TE" ; _cDocumento := "TB "+AllTrim(SE5TMP->E5_DOCUMEN)			
				Case SE5TMP->E5_MOEDA $ "FL" ; _cDocumento := "FL "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "AP" ; _cDocumento := "AP "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "CD" ; _cDocumento := "CD "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "ES" ; _cDocumento := "ES "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "GE" ; _cDocumento := "GE "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "NI" ; _cDocumento := "NI "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "DD" ; _cDocumento := "DD "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_MOEDA $ "RG" ; _cDocumento := "RG "+AllTrim(SE5TMP->E5_DOCUMEN)
				Case SE5TMP->E5_TIPO == "FL "; _cDocumento := "FL "+AllTrim(SE5TMP->E5_NUMERO)
					
				OtherWise
					_cDocumento := AllTrim(SE5TMP->E5_DOCUMEN)
					
			EndCase
		Else
			If !EMPTY(SE5TMP->E5_DOCUMEN)
				_cDocumento := "BD "+AllTrim(SE5TMP->E5_DOCUMEN)
			ElseIf !EMPTY(SE5TMP->E5_NUMCHEQ)
				_cDocumento := "CH "+AllTrim(SE5TMP->E5_NUMCHEQ)
			EndIf
		EndIf
		
		
		_nTotal := _nTotal + SE5TMP->E5_VALOR
		
		aAdd(aPags,{ .F., STOD(SE5TMP->E5_DTDISPO), _cOpera, _cDocumento, SE5TMP->E5_VALOR,0,SE5TMP->REGSE5})
		
		dbSelectArea("SE5TMP")
		DbSkip()
	EndDo
	If _nTotal <> 0
		For _nI:=_nConta to Len(aPags)
			aPags[_nI,6] := _nTotal
		Next _nI
		
		_nConta := Len(aPags) + 1
	EndIf
	
Enddo

//                             "Data"            ,"Operacao/Beneficiario"        ,"Documento"       ,"Valor"                                           ,"Valor Bordero"
// 1                           2                  3                               4                  5                                                  6
// .F.                        ,SE5TMP->E5_DTDISPO,_cOpera                        ,_cDocumento       ,SE5TMP->E5_VALOR                                  , _nTotal
// aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3]             ,aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99")

dbSelectArea("SE5TMP")
DbCloseArea()

If Len(aPags) > 0
	
	If Len(aPags)>=2  // Refazer os acumulados                                                 
	    _cAntes := ""
		For _nI:=1 to Len(aPags)-1 
			If aPags[_nI,4] <> aPags[_nI+1,4] .And. _cAntes <> aPags[_nI,4]
				aPags[_nI,6] := aPags[_nI,5]                               
			EndIf
			_cAntes := aPags[_nI,4]
		Next _nI
		If aPags[Len(aPags)-1,4] <> aPags[Len(aPags),4]
			aPags[Len(aPags),6] := aPags[Len(aPags),5]
		EndIf
	EndIf
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 360,695 TITLE "Escolha Movimentacao Contas a Pagar a Antecipar " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Data","Operacao/Beneficiario","Documento","Valor","Valor Bordero" SIZE 310, 130 OF oDlg PIXEL ;
	ON DBLCLICK (U_MARKSE5())
	
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3],aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,6],"@EZ 999,999,999.99") } }
	oLbx1:nFreeze  := 1
	
	DEFINE SBUTTON FROM 140, 228 TYPE 17 ENABLE OF oDlg ACTION U_MarcaSE5()
	DEFINE SBUTTON FROM 140, 258 TYPE 1  ENABLE OF oDlg ACTION (U_AnteSE5(),_lRet :=.T.,oDlg:End())
	DEFINE SBUTTON FROM 140, 288 TYPE 2  ENABLE OF oDlg ACTION (_lRet :=.F.,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	_lRet := .F.
	MsgInfo("Jแ Antecipados!","Aten็ใo")
Endif

RestArea(aArea)



Return(_lRet)

/*
User Function MARKSE5()
_lFlag := aPags[oLbx1:nAt,1]
If Left(aPags[oLbx1:nAt,4],2) $ "BD"
	For _nI:=1 to Len(aPags)
		If aPags[oLbx1:nAt,4] == aPags[_nI,4]
			If _lFlag
				aPags[_nI,1] := .F.
			Else
				aPags[_nI,1] := .T.
			EndIf
		EndIf
	Next _nI
Else
	If _lFlag
		aPags[oLbx1:nAt,1] := .F.
	Else
		aPags[oLbx1:nAt,1] := .T.
	EndIf
EndIf
oLbx1:Refresh(.T.)
Return

User Function MarcaSE5
For _nI:=1 to Len(aPags)
	If aPags[_nI,1]
		aPags[_nI,1] := .F.
	Else
		aPags[_nI,1] := .T.
	EndIf
Next _nI
oLbx1:Refresh(.T.)
Return
*/

User Function ANTESE5
Local  _aArea := GetArea()
DbSelectarea("SE5")
For _nI:=1 to Len(aPags)
	If aPags[_nI,1]
		dbGoto(aPags[_nI,7])
		RecLock("SE5", .F.)
//		SE5->E5_DTDISPO:=dDataBase
		SE5->E5_FLUXO := "S"
		msUnLock()
	EndIf
Next _nI
RestArea(_aArea)
oLbx1:Refresh(.T.)
Return


#INCLUDE "rwmake.ch"
//#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บ Autor ณ Andy               บ Data ณ  26/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Apicacoes                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINA24()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cArq,cInd,cPerg
Local cString := "SZG"
Local aStru
Local cVldAlt := ".T."
Local cVldExc := ".T."

Private aPags := {}
Private _dPar01, _dPar02
Private _cSZGBan, _cSZGAge, _cSZGCon

_cSZGBan:=Space(03)
_cSZGAge:=Space(05)
_cSZGCon:=Space(10)

dbSelectArea("SZG")
dbSetOrder(1)

//AxCadastro(cString, "Contas de Consumo", cVldAlt, cVldExc)

cCadastro := "Aplicacoes Financeiras"
aCores    := {}

cDelFunc  := "U_VERSZG()"
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"												, 0 , 1},;
				{"Visualizar" ,"AxVisual"    											, 0 , 2},;
				{"Incluir"    ,'AxInclui("SZG",Recno(),3,,"U_SZGIni",,"U_SZGTudOK()")'	, 0 , 3},;
				{"Alterar"    ,'AxAltera("SZG",Recno(),4,,,,,"U_VERSZG()")'				, 0 , 4},;
				{"Excluir"    ,'U_SZGCTB("SZG",Recno(),5,,,,,)'							, 0 , 5},;
				{"Imprimir"	  ,"U_CFINR018"												, 0 , 6},;
				{"Fluxo"      ,"U_SZG_FLUXO"											, 0 , 7},;
				{"Legenda"    ,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","Sem Fluxo"},{"BR_VERMELHO","Com Fluxo"}})',0 , 8 }}

Aadd( aCores, { " Empty(ZG_FLUXO) " 	, "BR_VERDE" 	 	} )
Aadd( aCores, { "!Empty(ZG_FLUXO) " 	, "BR_VERMELHO"		} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a Filtragem                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SZG")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZG",,,,,2, aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณMicrosiga           บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VERSZG()
Local  _aArea := GetArea()
_cRet := If(Empty(SZG->ZG_FLUXO),.T.,.F.)
If !_cRet
	_cMsg := "Fluxo de Caixa gerado sobre o registro, Nใo podera ser Alterado, ou Excluido!!!"
	MsgAlert(_cMsg, "Aten็ใo")
EndIf
RestArea(_aArea)
Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณMicrosiga           บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZG_FLUXO()
Local aArea := GetArea()

Private cPerg	:= "FIN124    "
lRet        	:= .F.
aPags       	:= {}
_aPerg 			:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 - Conta de                                    ณ
//ณ mv_par02 - Conta ate                                   ณ
//ณ mv_par03 - Emissao de                                  ณ
//ณ mv_par04 - Emissao ate                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nSX1Order := SX1->(IndexOrd())
SX1->(dbSetOrder(1))

AADD(_aPerg,{cPerg,"01","Conta de           ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"02","Conta ate          ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"03","Data de            ?","","","mv_ch3","D",08,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Data ate           ?","","","mv_ch4","D",08,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//AjustaSX1(_aPerg)

For nX := 1 to Len(_aPerg)
	If !SX1->(dbSeek(cPerg+_aPerg[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(_aPerg[nX])
				SX1->(FieldPut(nY,_aPerg[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

If !Pergunte(cPerg, .T.)
	Return
EndIf

_xFilSZG:= xFilial("SZG")
_cOrdem := " ZG_FILIAL, ZG_CONTA, ZG_EMISSAO"

_cQuery := " SELECT * , SZG.R_E_C_N_O_ REGSZG"
_cQuery += " FROM "
_cQuery += RetSqlName("SZG")+" SZG"
_cQuery += " WHERE '"+ _xFilSZG +"' = ZG_FILIAL"
_cQuery += " AND    ZG_CONTA   >= '"+mv_par01+"'"
_cQuery += " AND    ZG_CONTA   <= '"+mv_par02+"'"
_cQuery += " AND    ZG_EMISSAO >= '"+DTOS(mv_par03)+"'"
_cQuery += " AND    ZG_EMISSAO <= '"+DTOS(mv_par04)+"'"

U_EndQuery( @_cQuery,_cOrdem, "SZGTMP", {"SZG" },,,.T. )

dbSelectArea("SZGTMP")
dbGoTop()

_cDocumento := "APL"+DTOS(MV_PAR04)
_cNatureza  := SZGTMP->ZG_NATREC
_nTotal     := 0
_cBanco     := SZGTMP->ZG_BANCO
_cAgencia   := SZGTMP->ZG_AGENCIA
_cConta     := SZGTMP->ZG_CONTA

While !Eof()
	dbSelectArea("SE5")
	dbSetOrder(1)
	If !dbSeek(xFilial("SE5")+DTOS(MV_PAR04)+SZGTMP->ZG_BANCO+SZGTMP->ZG_AGENCIA+SZGTMP->ZG_CONTA+_cDocumento, .F.)
		_cConta := SZGTMP->ZG_CONTA
		Begin Transaction
		dbSelectArea("SZGTMP")
		While !Eof() .And. _cConta == SZGTMP->ZG_CONTA
			dbSelectArea("SZG")
			dbGoTo(SZGTMP->REGSZG)
			RecLock("SZG", .F.)
			SZG->ZG_FLUXO := _cDocumento
			msUnLock()
			dbSelectArea("SZGTMP")
			_nTotal:=_nTotal+SZGTMP->ZG_VALREC
			DbSkip()
		EndDo
		dbSelectArea("SE5")
		RecLock("SE5", .T.)
		SE5->E5_FILIAL  := xFilial("SE5")
		SE5->E5_BANCO   := _cBanco
		SE5->E5_AGENCIA := _cAgencia
		SE5->E5_CONTA   := _cConta
		SE5->E5_NUMCHEQ := _cDocumento
		SE5->E5_MOEDA   := "PL"
		SE5->E5_TIPODOC := "PL"
		SE5->E5_RECPAG  := "R"
		SE5->E5_DATA    := MV_PAR04
		SE5->E5_VENCTO  := MV_PAR04
		SE5->E5_NUMERO  := ""
		SE5->E5_PREFIXO := ""
		SE5->E5_TIPO    := ""
		SE5->E5_VALOR   := _nTotal
		SE5->E5_NATUREZ := _cNatureza
		SE5->E5_HISTOR  := _cDocumento
		SE5->E5_LA      := "N"
		SE5->E5_CLIFOR  :=	"DEBAUT"
		SE5->E5_DTDIGIT := MV_PAR04
		SE5->E5_MOTBX   := "NOR"
		SE5->E5_RECONC  := "x"
		SE5->E5_SEQ     := "01"
		SE5->E5_DTDISPO := MV_PAR04
		SE5->E5_DOCUMEN := _cDocumento
		SE5->E5_BENEF   := "CIEE"
		SE5->(msUnLock())
		End Transaction
		dbSelectArea("SZGTMP")
	Else    
		msgstop("Jแ Existe Movimenta็ใo Bancแria para o Fluxo nesta Data, para esta Conta!")
		_cConta := SZGTMP->ZG_CONTA
		While !Eof() .And. _cConta == SZGTMP->ZG_CONTA
			dbSelectArea("SZGTMP")
			DbSkip()
		EndDo
		dbSelectArea("SZGTMP")
	EndIf
Enddo

dbSelectArea("SZGTMP")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณMicrosiga           บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZGIni()

Local  _aArea := GetArea()

M->ZG_BANCO    := _cSZGBan
M->ZG_AGENCIA  := _cSZGAge
M->ZG_CONTA    := _cSZGCon
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณMicrosiga           บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZGTudOK()

Local _aArea 	:= GetArea()
//Local cConta 	:= "114011"

Private _cLoteCie 	:= "009600"
Private _cDocCie  	:= 0
Private  dEmissao 	:= M->ZG_EMISSAO
Private _cSZGBan  	:= M->ZG_BANCO
Private _cSZGAge  	:= M->ZG_AGENCIA
Private _cSZGCon  	:= M->ZG_CONTA
Private _cSZGIOF  	:= M->ZG_IOF
Private nValor 		:= 0
Private _cCustoC 	:= ""
Private _cCustoD 	:= ""
Private cContaC		:= ""
Private cContaD		:= ""
Private cDC			:= ""
Private _cSubLCie 	:= "001"

DBSELECTAREA("SA6")
SA6->(DBSETORDER(1))
SA6->(DBSEEK(xFilial("SA6")+_cSZGBan+_cSZGAge+_cSZGCon))

//_cDocCie  :=  VAL(CTGERDOC(_cLoteCie,dEmissao))
//_cDocCie+=1

IF !EMPTY(M->ZG_VALREC)
	nValor 		:= M->ZG_VALREC
	cContaD		:= "1140111"
	_cCustoD 	:= ""
	cContaC 	:= "49113"
	If cEmpant == '01'  // CIEE SP
		_cCustoC 	:= "00026"
	ElseIf cEmpant == '03'  // CIEE RJ
		_cCustoC 	:= "00516"		
	EndIf
	cHistEs 	:= ALLTRIM(SA6->A6_NREDUZ)+" RENDIMENTO CURTO PRAZO "
	
	_fGeraCTB(nValor,cContaD,cContaC,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)

ENDIF

If !EMPTY(M->ZG_IOF)  // IOF
	nValor 		:= M->ZG_IOF
	cContaD  	:= "49113"
	If cEmpant == '01'  // CIEE SP
		_cCustoC 	:= "00026"
	ElseIf cEmpant == '03'  // CIEE RJ
		_cCustoC 	:= "00516"		
	EndIf
	cContaC		:= "1140111"
	_cCustoC 	:= ""
	cHistEs 	:= ALLTRIM(SA6->A6_NREDUZ)+" IOF APLIC CURTO PRAZO  "

	_fGeraCTB(nValor,cContaD,cContaC,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)	
	
ENDIF

RestArea(_aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINASLD  บAutor  ณ Claudio Barros     บ Data ณ  07/01/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Utilizado para trazer o ultimo saldo do banco, conta e     บฑฑ
ฑฑบ          ณ agencia selecionado, para popular o campo ZG_VALINI        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFIN - Rotina CFINA24                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINASLD(pBANCO,pAGENCIA,pCONTA,pEMISSAO,pXTIPO)

Local _nCt := 0
Local _lRet := 0
Local _cRecno := SZG->(RECNO())

While .T.
	SZG->(DBSETORDER(3))
	IF SZG->(DbSeek(xFilial("SZG")+pBANCO+pAGENCIA+pCONTA+DTOS(pEMISSAO-_nCt)+pXTIPO))
		_lRet := SZG->ZG_VALFIN
		EXIT
	ELSE
		IF _nCt > 5
			_lRet := 0
			EXIT
		ENDIF
	ENDIF
	_nCt++
END

SZG->(DBGOTO(_cRecno))

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณMicrosiga           บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cfina24C(pValor,pConta,pHist,pDC,pEmissao,pDoc,pLote,pCustoC,pCustoD)

Private _cSubLCie := "001"
Private _cLinCie  := 0
Private nLanSeq   := 0
Private pDtEmis   := pEmissao
Private _cLoteCie :=pLote
Private _cDocCie  := pDoc

dbSelectArea("CT2")
dbSetOrder(1)

_cLinCie  :=  VAL(CTGERLAN(_cLoteCie,_cSubLCie,pDtEmis,STRZERO(_cDocCie,6)))

RecLock("CT2",.T.)
CT2->CT2_FILIAL 	:= xFILIAL("CT2")
CT2->CT2_DATA   	:= pDtEmis
CT2->CT2_LOTE   	:= pLote
CT2->CT2_SBLOTE 	:= _cSubLCie
_cLinCie 			:= _cLinCie + 1
CT2->CT2_LINHA  	:= StrZero(_cLinCie,3)
CT2->CT2_DOC    	:= StrZero(_cDocCie,6)
DBSELECTAREA("CT1")
CT1->(DBSETORDER(2))
CT1->(DBSEEK(xFILIAL("CT1")+pConta))
IF pDC == "1"
	CT2->CT2_DC  := "1"
	CT2->CT2_DEBITO := CT1->CT1_CONTA
ELSE
	CT2->CT2_DC  := "2"
	CT2->CT2_CREDIT := CT1->CT1_CONTA
ENDIF
CT2->CT2_DCD:= ""
CT2->CT2_DCC:= ""
CT2->CT2_MOEDLC:="01"
CT2->CT2_VALOR:= pValor
CT2->CT2_MOEDAS:="1"
CT2->CT2_HP:= ""
CT2->CT2_HIST:= pHist
CT2->CT2_CRITER:="1"
CT2->CT2_CCD:= pCustoD
CT2->CT2_CCC:= pCustoC

IF pDC == "1"
	CT2->CT2_ITEMD  := pConta
ELSE
	CT2->CT2_ITEMC  := pConta
ENDIF
CT2->CT2_CLVLDB:= ""
CT2->CT2_CLVLCR:= ""
CT2->CT2_VLR02:= 0
CT2->CT2_VLR03:= 0
CT2->CT2_VLR04:= 0
CT2->CT2_VLR05:= 0
CT2->CT2_ATIVDE:= ""
CT2->CT2_ATIVCR:= ""
CT2->CT2_EMPORI:=Substr(cNumEmp,1,2)
CT2->CT2_FILORI:=xFilial("CT2")
CT2->CT2_INTERC:="2"
CT2->CT2_IDENTC:= ""
CT2->CT2_TPSALD:= "9"
CT2->CT2_SEQUEN:=StrZero(_cLinCie,3)
CT2->CT2_MANUAL:="1"
CT2->CT2_ORIGEM:="210 CFINA24"
CT2->CT2_ROTINA:="CFINA24"
CT2->CT2_AGLUT:= "2"
CT2->CT2_LP:=""
CT2->CT2_KEY := ""
CT2->CT2_SEQHIS:=StrZero(_cLinCie,3)
nLanSeq := (VAL(CTGERLAN(_cLoteCie,_cSubLCie,pDtEmis,STRZERO(_cDocCie,6)))+1)
CT2->CT2_SEQLAN:=  StrZero(nLanSeq,3)
CT2->CT2_DTVENC:= Ctod("//")
CT2->(MSUNLOCK())


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณMicrosiga           บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static  Function CTGERLAN(pLote,pSbLote,pData,pDoc)


Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := 0

_cQuery := " SELECT MAX(CT2_SEQLAN) AS SEQMOV FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  AND CT2_LOTE = '"+pLote+"'  "+_cFl
_cQuery += " AND CT2_SBLOTE = '"+pSbLote+"' "+_cFl
_cQuery += " AND CT2_DATA = '"+Dtos(pData)+"' AND CT2_DOC = '"+pDoc+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRT',.T.,.T.)

_lRet := TRT->SEQMOV

If Select("TRT") > 0
	TRT->(DBCLOSEAREA())
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณMicrosiga           บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static  Function CTGERDOC(pLote,pData)


Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := 0


_cQuery := " SELECT MAX(CT2_DOC) AS SEQDOC FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  AND CT2_LOTE = '"+pLote+"'  "+_cFl
_cQuery += " AND CT2_DATA = '"+Dtos(pData)+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRT',.T.,.T.)

_lRet := TRT->SEQDOC

If Select("TRT") > 0
	TRT->(DBCLOSEAREA())
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณMicrosiga           บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZGCTB(cAlias,nReg,nOpc,cTransact,aCpos,aButtons)


Local   _aArea := GetArea()
Local   cConta := "1140111"
Local nOpcA,oDlg, lDel := .t., aPosEnch,lX

Private _cLoteCie := "009600"
Private _cDocCie  := 0
Private  dEmissao
Private _cSZGBan
Private _cSZGAge
Private _cSZGCon
Private nValor := 0
Private _cCustoD := ""
Private _cCustoC := ""
Private cDC			:= ""   
Private _cSubLCie 	:= "001"
Private aTELA[0][0],aGETS[0]

*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*ณ Envia para processamento dos Gets			 ณ
*ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nOpcA:=0

DbSelectArea(cAlias)
SoftLock( cAlias )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 9,0 TO TranslateBottom(.F.,28),80 OF oMainWnd

aPosEnch := {,,(oDlg:nClientHeight - 4)/2,}  // ocupa todo o  espa็o da janela


nOpcA:=EnChoice( cAlias, nReg, nOpc,,,,aCpos,aPosEnch)

nOpca := 1
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 2,oDlg:End()},{|| nOpca := 1,oDlg:End()},,aButtons)

DbSelectArea(cAlias)

dEmissao :=  SZG->ZG_EMISSAO
_cSZGBan  := SZG->ZG_BANCO
_cSZGAge  := SZG->ZG_AGENCIA
_cSZGCon  := SZG->ZG_CONTA
_cSZGIOF  := SZG->ZG_IOF

If nOpcA == 2
	DBSELECTAREA("SA6")                                                                            
	SA6->(DBSETORDER(1))
	SA6->(DBSEEK(xFilial("SA6")+_cSZGBan+_cSZGAge+_cSZGCon))
	
	_cDocCie  :=  VAL(CTGERDOC(_cLoteCie,dEmissao))
	_cDocCie+=1
	
	IF !EMPTY(SZG->ZG_VALREC)
		nValor 		:= SZG->ZG_VALREC
		cContaD  	:= "49113"
		If cEmpant == '01'  // CIEE SP
			_cCustoD 	:= "00026"
		ElseIf cEmpant == '03'  // CIEE RJ
			_cCustoD 	:= "00516"		
		EndIf
		cContaC		:= "1140111"
		_cCustoC 	:= ""
		cHistEs 	:= "ESTORNO "+ALLTRIM(SA6->A6_NREDUZ)+" RENDIMENTO CURTO PRAZO "

		_fGeraCTB(nValor,cContaD,cContaC,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	ENDIF
	
	If !EMPTY(SZG->ZG_IOF)  // IOF
		nValor 		:= SZG->ZG_IOF
		cContaD		:= "1140111"
		_cCustoD 	:= ""
		cContaC  	:= "49113"
		If cEmpant == '01'  // CIEE SP
			_cCustoC 	:= "00026"
		ElseIf cEmpant == '03'  // CIEE RJ
			_cCustoC 	:= "00516"		
		EndIf
		cHistEs 	:= "ESTORNO "+ALLTRIM(SA6->A6_NREDUZ)+" IOF APLIC CURTO PRAZO  "

		_fGeraCTB(nValor,cContaD,cContaC,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	ENDIF
	
	DbSelectArea(cAlias)
	
	If Type("cDelFunc") != "U" .and. cDelFunc != nil
		If !&(cDelFunc)
			lDel := .f.
		EndIf
	EndIf
	If lDel
		If Type("aMemos")=="A"
			For i := 1 To Len(aMemos)
				MSMM(&(aMemos[i][1]),,,,2)
			Next i
		EndIf
		Begin Transaction
		DbSelectArea( cAlias )
		If cTransact != Nil .And. ValType(cTransact) == "C"
			If !("("$cTransact)
				cTransact+="()"
			EndIf
			lX := &cTransact
		EndIf
		DbSelectArea( cAlias )
		RecLock(cAlias,.F.,.T.)
		dbDelete( )
		WriteSx2( cAlias )
		End Transaction
	EndIf
	DbSelectArea(cAlias)
	MsUnlock()
Else
	MsUnlock( )
End
DbSelectArea(cAlias)

RestArea(_aArea)

Return(nOpcA)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA24   บAutor  ณEmerson Natali      บ Data ณ  07/18/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera Lancamento Contabil                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fGeraCTB(nValor,cContaD,cContaC,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)

Local nDecs		:=	TamSX3('CT2_VALOR')[2]
Local aCab		:= {}
Local aItem		:= {}
Local aTotItem 	:= {}

Private lMsErroAuto := .F.

	aCab := {;
			{"dDataLanc", dEmissao ,NIL},;
			{"cLote"	, _cLoteCie,NIL},;
			{"cSubLote"	, _cSubLCie,NIL}}

	AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")		, NIL},;
					{"CT2_LINHA"	, "001"					, NIL},;
					{"CT2_DC"		, "3"	 				, NIL},;
					{"CT2_ITEMD"	, cContaD				, NIL},;
					{"CT2_ITEMC"	, cContaC				, NIL},;
					{"CT2_CCD"		, _cCustoD				, NIL},;
					{"CT2_CCC"		, _cCustoC 				, NIL},;
					{"CT2_VALOR"	, Round(nValor,nDecs)	, NIL},;
					{"CT2_HP"		, ""					, NIL},;
					{"CT2_HIST"		, cHistEs				, NIL},;
					{"CT2_TPSALD"	, "9"					, NIL},;
					{"CT2_ORIGEM"	, "210 CFINA24"			, NIL},;
					{"CT2_EMPORI"	, Substr(cNumEmp,1,2)	, NIL},;
					{"CT2_ROTINA"	, "CFINA24"				, NIL},;
					{"CT2_LP"		, ""					, NIL},;
					{"CT2_KEY"		, ""					, NIL}})
	aadd(aTotItem,aItem)
	MSExecAuto({|a,b,C| Ctba102(a,b,C)},aCab,aItem,3)
	aTotItem	:=	{}

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		Return .F.
	Endif
			
	aCab	:= {}
	aItem	:= {}

Return()
#INCLUDE "rwmake.ch"
#include "TOPCONN.CH"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA06   บ Autor ณ Andy               บ Data ณ  28/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Contas de Consumo                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINA06()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private aPags := {}
Private _dPar01, _dPar02
Private _cSZ5Ban, _cSZ5Age, _cSZ5Con
Private cPerg

_cSZ5Ban:=Space(03)
_cSZ5Age:=Space(05)
_cSZ5Con:=Space(10)

cPerg := "FINA06    "

_fCriaSX1a() // Verifica as perguntas e cria caso seja necessario

// Se o usuario nao confirmar, nao processar.
If !Pergunte(cPerg, .T.)
	Return
EndIf

_dPar01:=mv_par01
_dPar02:=mv_par02

dbSelectArea("SZ5")
dbSetOrder(1)

cCadastro := "Contas de Consumo"
aCores    := {}
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"    , 0 , 1},;
				{"Visualizar" ,"AxVisual"    , 0 , 2},;
				{"Incluir"     ,'AxInclui("SZ5",Recno(),3,,"U_SZ5Ini",,"U_SZUOK()")' , 0 , 3},;
				{"Alterar"     ,'AxAltera("SZ5",Recno(),4,,,,,"U_SZUTudOK()")', 0 , 4},;
				{"Excluir"    ,"U_SZ5DEL"    , 0 , 5},;
				{"Baixar"     ,"U_BAIXA_SZ5" , 0 , 6},;
				{"Importar"   ,"Processa({||  U_IMP_SZ5() },'Processando Registros...')" , 0 , 7},;
				{"Legenda"    ,'BrwLegenda(cCadastro,"Legenda",{{"BR_AMARELO","Baixado sem Conta"},{"BR_VERDE","Aberto"},{"BR_VERMELHO","Baixado"}})',0 , 8}}

Aadd( aCores, { "Empty(Z5_BAIXA) .AND. Z5_CONTA == 'S' "	, "BR_AMARELO"  	} )
Aadd( aCores, { "Empty(Z5_BAIXA) .AND. Empty(Z5_FL)    " 	, "BR_VERDE" 	 	} )
Aadd( aCores, { "!Empty(Z5_BAIXA) " 	, "BR_VERMELHO"		} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a Filtragem                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SZ5")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZ5",,,,,2, aCores)

Return


User Function SZ5DEL()

	If Empty(SZ5->Z5_FL)
		_lRet	:= AxDeleta("SZ5",Recno(),5) //cAlias,nReg,nOpc,aAcho,cFunc
	Else
		MsgBox(OemToAnsi("Nใo pode excluir pois este registro possue DM Gerada!!!"))
		_lRet	:= .F.
	EndIf
Return(_lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  MESREF  บ Autor ณ Andy               บ Data ณ  28/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Inicializa campo Z5_MES, conforme mv_par01 do              บฑฑ
ฑฑบ          ณ Programa CFINA06                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ativado em X3_RELACAO do Campo Z5_MES                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MESREF(_dDataRef)

_aMes := {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
_nPos := Val(SUBS(DTOS(_dDataRef),5,2))
_nPos := _nPos - IIf(Val(SUBS(DTOS(_dDataRef),7,2))>=01,1,0) // dia de refer๊ncia

If _nPos <= 0
	_nPos:=12
EndIf

_cMes := _aMes[_nPos]

Return(_cMes)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALMESREF บ Autor ณ Andy               บ Data ณ  28/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Consiste campo Z5_MES, no Programa CFINA06                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ativado em X3_VALID do Campo Z5_MES                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VALMESREF(_cMesRef)

If AllTrim(_cMesRef) $ "JANEIRO,FEVEREIRO,MARCO,ABRIL,MAIO,JUNHO,JULHO,AGOSTO,SETEMBRO,OUTUBRO,NOVEMBRO,DEZEMBRO"
	_cRet:=.T.
Else
	_cRet:=.F.
EndIf

Return(_cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBaixa_SZ5 บ Autor ณ Andy               บ Data ณ  28/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Preenche Z5_BAIXA, no Programa CFINA06                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BAIXA_SZ5()

Local aArea := GetArea() //, aPags := {}
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )

Private _cPerg  := "FINAA6    "
Private _lRetp

lRet        := .F.
aPags       := {}

_fCriaSX1b() // Verifica as perguntas e cria caso seja necessario

If !Pergunte(_cPerg, .T.)
	Return
EndIf               

_xFilSZ5:=xFilial("SZ5")
_xFilSZ7:=xFilial("SZ7")

_cOrdem := " Z5_FILIAL, Z5_VALOR"
_cQuery := " SELECT Z5_LANC, Z5_DOC, Z7_GRUPO, Z5_PRESTA, Z5_TEL, Z5_MES, Z5_VALOR, Z5_BAIXA, Z5_CONTA ,Z5_UNIDADE, Z5_CR, Z5_FL, SZ5.R_E_C_N_O_ REGSZ5"
_cQuery += " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_LANC    >= '"+DTOS(mv_par01)+"'"
_cQuery += " AND    Z5_LANC    <= '"+DTOS(mv_par02)+"'"
_cQuery += " AND    Z5_PRESTA  >= '"+mv_par03+"'"
_cQuery += " AND    Z5_PRESTA  <= '"+mv_par04+"'"
_cQuery += " AND    Z5_UNIDADE >= '"+mv_par05+"'"
_cQuery += " AND    Z5_UNIDADE <= '"+mv_par06+"'"
_cQuery += " AND    Z5_MES     >= '"+mv_par07+"'"
_cQuery += " AND    Z5_MES     <= '"+mv_par08+"'"
_cQuery += " AND    Z7_GRUPO   >= '"+mv_par09+"'"
_cQuery += " AND    Z7_GRUPO   <= '"+mv_par10+"'"

If mv_par12 == 1
	_cQuery += " AND (Z5_BAIXA = '' AND Z5_CONTA <> 'S')"
ElseIf mv_par12 == 2
	_cQuery += " AND  Z5_CONTA = 'S' "
EndIf

U_EndQuery( @_cQuery,_cOrdem, "SZ5TMP", {"SZ5","SZ7" },,,.T. )

dbSelectArea("SZ5TMP")
dbGoTop()

While !Eof()
	//	            1   2               3              4                 5              6              7                8                9                10                 11            12            13
	aAdd(aPags,{.F.,SZ5TMP->Z5_LANC,SZ5TMP->Z5_DOC,SZ5TMP->Z5_PRESTA,SZ5TMP->Z5_TEL,SZ5TMP->Z5_MES,SZ5TMP->Z5_VALOR,SZ5TMP->Z5_BAIXA,SZ5TMP->Z5_CONTA,SZ5TMP->Z5_UNIDADE,SZ5TMP->Z5_CR,SZ5TMP->Z5_FL,SZ5TMP->REGSZ5})
	DbSkip()
Enddo

dbSelectArea("SZ5TMP")
DbCloseArea()

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 300,778 TITLE "Escolha de qual movimento quer conciliar " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Lancamento","Documento","Prestadora","Telefone","Referencia","Valor","Baixa","Conta","Unidade","CR","DM" SIZE 345, 85 OF oDlg PIXEL ;
	ON DBLCLICK (U_MARK1())
	//	ON DBLCLICK (aEval(aPags,{|ax,nPos| aPags[nPos,1] := If(nPos=oLbx1:nAt,.T.,.F.) }) ,oLbx1:Refresh(.F.))
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3],aPags[oLbx1:nAt,4],aPags[oLbx1:nAt,5],aPags[oLbx1:nAt,6],Transform(aPags[oLbx1:nAt,7],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9],aPags[oLbx1:nAt,10],aPags[oLbx1:nAt,11],aPags[oLbx1:nAt,12]  } }
	oLbx1:nFreeze  := 1
	
	If mv_par12 == 2	
		DEFINE SBUTTON FROM 104, 264 TYPE 17 ENABLE OF oDlg ACTION U_MarcaSZ5() // BOTAO FILTRO
		DEFINE SBUTTON FROM 104, 292 TYPE 1  ENABLE OF oDlg ACTION (lRet :=.T.,oDlg:End()) // BOTAO OK
		DEFINE SBUTTON FROM 104, 320 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End()) // BOTAO CANCELAR
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		DEFINE SBUTTON FROM 104, 236 TYPE 17 ENABLE OF oDlg ACTION U_MarcaSZ5() // BOTAO FILTRO
		DEFINE SBUTTON FROM 104, 264 TYPE 1  ENABLE OF oDlg ACTION (lRet :=.T.,oDlg:End()) // BOTAO OK
		DEFINE SBUTTON FROM 104, 292 TYPE 11 ENABLE OF oDlg ACTION U_MUDA() // BOTAO EDITA
		DEFINE SBUTTON FROM 104, 320 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End()) // BOTAO CANCELAR
		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf
	
	If lRet .and. mv_par12 == 2
		For nInd := 1 To Len(aPags)
			If aPags[nInd,1]
				DbSelectarea("SZ5")
				DbGoto(aPags[nInd,13])
				RecLock("SZ5",.F.)
//				SZ5->Z5_BAIXA:=Iif(Empty(_dPar02),dDataBase,_dPar02)
				SZ5->Z5_BAIXA:= dDataBase
				SZ5->Z5_CONTA:="N"
				msUnLock()
			Endif
		Next
	Else
		For nInd := 1 To Len(aPags)
			If aPags[nInd,1]
				DbSelectarea("SZ5")
				DbGoto(aPags[nInd,13])
				RecLock("SZ5",.F.)
				SZ5->Z5_CONTA:="S"
				msUnLock()
			Endif
		Next		
	Endif
Else
	MsgInfo("Nใo foi localizado o Lancamento !","Aten็ใo")
Endif

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMARK1     บAutor  ณMicrosiga           บ Data ณ  04/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para os itens marcados no mark browse               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MARK1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInverte a marca do ListBox.                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Alltrim(aPags[oLbx1:nAt,3]) == "9999999999"
	MSGINFO("Regularize os Documentos","9999999999")
Else
	If  aPags[oLbx1:nAt,1]
		aPags[oLbx1:nAt,1] := .F.
		aPags[oLbx1:nAt,8] := ctod("  /  /  ")
	Else
		aPags[oLbx1:nAt,1] := .T.
		aPags[oLbx1:nAt,8] := Iif(Empty(_dPar02),dDataBase,_dPar02)
	EndIf
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza os objetos.                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oLbx1:Refresh(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMUDA      บAutor  ณMicrosiga           บ Data ณ  04/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar os registros no array para altercao     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MUDA()

Local   aArea := GetArea()

Private aAcho := {}
Private aCpos := {}
Private _lSair := .T.

aMemos := {}
AADD(aCpos,"Z5_MES")

DbSelectarea("SZ5")

_nTam   := len(aPags)
_nCont  := 1
_lLanc  := .F.
_cConta := SZ5->Z5_CONTA

While _nCont <= _nTam
	If aPags[_nCont,1]
		_lSair :=.T.
		_lLanc := .T.
		dbGoto(aPags[_nCont,13])
		RecLock("SZ5", .F.)
		SZ5->Z5_CONTA := _cConta
		msUnLock()
		AxAltera("SZ5",Recno(),4,aAcho,aCpos,,,'ExecBlock("SairSZ5",.F.,.F.)')
		_cConta         := SZ5->Z5_CONTA
		aPags[_nCont,6] := SZ5->Z5_MES
		aPags[_nCont,9] := SZ5->Z5_CONTA
		If _lSair
			RecLock("SZ5", .F.)
			SZ5->Z5_CONTA := Space(1)
			msUnLock()
			_cMsg := "Processo de Edicao Interrompido!!!"
			MsgAlert(_cMsg, "Aten็ใo")
			Exit
		EndIf
	EndIf
	_nCont:=_nCont+1
EndDo

RestArea(aArea)
oLbx1:Refresh(.T.)

If !_lLanc
	_cMsg := "Nใo Hแ Lan็amentos Selecionados para Edicao!!!"
	MsgAlert(_cMsg, "Aten็ใo")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ5Ini    บAutor  ณMicrosiga           บ Data ณ  04/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para carregar banco/agencia/conta para cada novos   บฑฑ
ฑฑบ          ณ registros incluidos                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZ5Ini()

Local  _aArea := GetArea()

M->Z5_BANCO    := _cSZ5Ban
M->Z5_AGENCIA  := _cSZ5Age
M->Z5_CCONTA   := _cSZ5Con
RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZUTudOK  บAutor  ณMicrosiga           บ Data ณ  04/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar o botao OK                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZUTudOK()

Local _aArea := GetArea()
Local _cRet  := .T.

If Empty(M->Z5_DOC)
	MsgAlert("Favor preencher campo Documento!", OemToAnsi("Aten็ใo"))
	_cRet:=.F.
Else
	If SZ5->Z5_DOC <> "9999999999"  
		IF !EMPTY(M->Z5_NCR)                                                                            
			DBSELECTAREA("SZ6")
			DBSETORDER(1)
			DBGOTOP()
			IF DBSEEK(xFilial("SZ6")+ M->Z5_DOC + M->Z5_PRESTA)
				RECLOCK("SZ6",.F.)
				SZ6->Z6_NCR	:= M->Z5_NCR
				MSUNLOCK()
			ENDIF	  
		Else		
			MsgAlert("Somente Documento Nao Identicado pode ser alterado!", OemToAnsi("Aten็ใo"))
			_cRet:=.F.   
		Endif
	Else
		dbSelectArea("SZ5")
		dbSetOrder(5)
		If dbSeek(xFilial("SZ5")+M->Z5_DOC+M->Z5_MES, .F.)
			_cMes:=M->Z5_MES
			While _cMes==SZ5->Z5_MES .And. !Eof()
				If YEAR(M->Z5_LANC)==YEAR(SZ5->Z5_LANC)
					MsgAlert("Documento: "+AllTrim(M->Z5_DOC)+" com Mes de Referencia "+AllTrim(M->Z5_MES)+" jแ Lancado!", OemToAnsi("Aten็ใo"))
					_cRet:=.F.
					Exit
				EndIf
				dbSkip()
			EndDo
		Else
			_cSZ5Ban := M->Z5_BANCO
			_cSZ5Age := M->Z5_AGENCIA
			_cSZ5Con := M->Z5_CCONTA
		EndIf
	EndIf
EndIf 


RestArea(_aArea)

Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZUOK     บAutor  ณMicrosiga           บ Data ณ  04/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar o botao OK                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZUOK()

Local _aArea := GetArea()
Local _cRet  := .T.

If Empty(M->Z5_DOC)
	MsgAlert("Favor preencher campo Documento!", OemToAnsi("Aten็ใo"))
	_cRet:=.F.
Else
	If M->Z5_DOC <> "9999999999"
		dbSelectArea("SZ5")
		dbSetOrder(5)
		If dbSeek(xFilial("SZ5")+M->Z5_DOC+M->Z5_MES, .F.)
			_cMes:=M->Z5_MES
			While _cMes==SZ5->Z5_MES .And. !Eof()
				If YEAR(M->Z5_LANC)==YEAR(SZ5->Z5_LANC)
					MsgAlert("Documento: "+AllTrim(M->Z5_DOC)+" com Mes de Referencia "+AllTrim(M->Z5_MES)+" jแ Lancado!", OemToAnsi("Aten็ใo"))
					_cRet:=.F.
					Exit
				EndIf
				dbSkip()
			EndDo
		EndIf
	EndIf
	
	_cSZ5Ban := M->Z5_BANCO
	_cSZ5Age := M->Z5_AGENCIA
	_cSZ5Con := M->Z5_CCONTA
	
EndIf   

IF !EMPTY(M->Z5_NCR) 
	//M->Z5_NCR	:= PADL(SZ5->Z5_NCR,LEN(SZ5->Z5_NCR),"0")                                                                                                  
	DBSELECTAREA("SZ6")
	DBSETORDER(1)
	DBGOTOP()
	IF DBSEEK(xFilial("SZ6")+ M->Z5_DOC + M->Z5_PRESTA)
		RECLOCK("SZ6",.F.)
		SZ6->Z6_NCR	:= M->Z5_NCR
		MSUNLOCK()
	ENDIF	
ENDIF
RestArea(_aArea)

Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSAIRSZ5   บAutor  ณMicrosiga           บ Data ณ  04/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar o botao cancelar na alteracao          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SAIRSZ5()

_lSair := .F.

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarcaSZ5  บAutor  ณMicrosiga           บ Data ณ  04/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar a selecao no mark browse               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MarcaSZ5

For _nI:=1 to Len(aPags)
    If Alltrim(aPags[_nI,3]) == "9999999999"
    	MSGINFO("Regularize os Documentos","9999999999")
  	Endif
	If Alltrim(aPags[_nI,3]) <> "9999999999"
		If aPags[_nI,1]
			aPags[_nI,1] := .F.
			aPags[_nI,8] := ctod("  /  /  ")
		Else
			aPags[_nI,1] := .T.
			aPags[_nI,8] := Iif(Empty(_dPar02),dDataBase,_dPar02)
		EndIf
	EndIf
Next _nI

oLbx1:Refresh(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA06   บAutor  ณMicrosiga           บ Data ณ  04/15/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMP_SZ5()

If cEmpant == '01' //SP
	cDirect    := "\arq_txt\tesouraria\Importacao\Bradesco\Debito\"
	cDirectImp := "\arq_txt\tesouraria\Importacao\Bradesco\Backup\"
ElseIf cEmpant == '03' //RJ
	cDirect    := "\arq_txtrj\tesouraria\Importacao\Bradesco\Debito\"
	cDirectImp := "\arq_txtrj\tesouraria\Importacao\Bradesco\Backup\"
EndIf

aDirect    := Directory(cDirect+"*.RET")

If Empty(adirect)
	MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
	Return
EndIf

For _nI := 1 to Len(adirect)
	FT_FUSE(cDirect+adirect[_nI,1])
	FT_FGOTOP()
	cBuffer 	:=	Alltrim(FT_FREADLN())
	If Substr(cBuffer,77,3) <> "237"
		alert("Arquivo nao Pertence ao Banco Bradesco!")
		Return
	EndIf
	If Len(cBuffer)< 200 .or. Len(cBuffer)> 200
		alert("Formato do arquivo Invalido!")
		Return
	EndIf
	/*|-----------------------------------------------|
	| Pula o primeiro registro                      |
	| Cabecalho                                     |
	|-----------------------------------------------|*/
	FT_FSKIP()
	ProcRegua(FT_FLASTREC())
	_lFirst := .T.
	
	Do While !FT_FEOF()
		IncProc("Processando Leitura do Arquivo Texto...")
		cBuffer 	:=	Alltrim(FT_FREADLN())
		_cID	    := Substr(cBuffer,001,1) // 0-Cabecalho; 1-Detalhes; 9-Rodape
		_cTpSaldo   := Substr(cBuffer,042,1) // 0-Saldo Anterior; 2-Saldo Atual
		_cCategoria := Substr(cBuffer,043,1) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 102 Encargos
		_cTipo   	:= Substr(cBuffer,043,3) // Pula todos os Tipo diferentes de 102 - Encargos 
		_cTpBlq		:= Substr(cBuffer,046,04) // Utilizado para detectar codigo dos Debitos (0920-GAS/ 0916 E 0932-TELEFONE/ 0937-AGUA/ 0935-LUZ/ 0953-TV POR ASSINATURA)
		_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco
		/*|--------------------------------------------------------------------|
		| Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
		|                      Rodape - 9 (_cID)                             |
		| registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
		|--------------------------------------------------------------------|*/

		If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "2" .or. !(_cTipo$"102|105|104") .or. !(_cTpBlq$"0920|0916|0932|0937|0935|0953|0036|1071|0726|0933|0239|0213|0403|1954|1901|1220|1219|0777|0968")
			FT_FSKIP()
			Loop
		EndIf
		
		_cAgencia	:=	Substr(cBuffer,018,04)
		_cConta  	:=	Substr(cBuffer,030,11)  //Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,30,12)
		_cDocument	:=	Substr(cBuffer,151,07) // Numero do Documento
		_cEmissao	:=	Substr(cBuffer,081,06)
		_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
		_cValor  	:=	Substr(cBuffer,087,18)
		_dAntServ	:= DATE() - 1
								
		If _cData < DataValida(_dAntServ,.F.)
			FT_FSKIP()
			Loop
		EndIf  
/*
INICIO BLOCOS 
LANCAMENTOS DEBITO SZ5
REGRA (0920|0916|0932|0937|0935)
E
MOVIMENTO BANCARIO SE5
REGRA (0036|1071|0726|0933|0239|0213|0403|1954|1901|1220|1219|0777|0968)
*/
		If _cTpBlq $ "0920|0916|0932|0937|0935|0953"
			//GERACAO DO SZ5
			DbSelectArea("SZ6")
			DbSetOrder(1)
				If DbSeek(xFilial("SZ6")+_cDocument)
				_cPrest	:= SZ6->Z6_PRESTA
				_cTel	:= SZ6->Z6_TEL
				_cUnid	:= SZ6->Z6_UNIDADE
				_cCR	:= SZ6->Z6_CR
			Else
				_cDocument	:= "9999999999"
				_cPrest		:= "CONTA"
				_cTel		:= "9999-9999"
				_cUnid		:= "NAO CADASTRADA"
				_cCR		:= "999"
			EndIf

			/*	|--------------------------------------------------------------------------------|
				| Pesquisa registros do arquivo TXT na base SZ5 com a chave                      |
				| EMISSAO+DOCUMENTO+VALOR se achou nao importa o registro novamente              |
				|--------------------------------------------------------------------------------|*/
			cQuery 		:= " SELECT COUNT(*) AS NREG"
			cQuery 		+= " FROM "+RetSQLname('SZ5')+" "
			cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
			cQuery 		+= " AND Z5_LANC = '"+DTOS(_cData)+"' "
			cQuery 		+= " AND Z5_DOC  = '"+_cDocument+"' "
			cQuery 		+= " AND Z5_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
			TcQuery cQuery New Alias "SZ5PESQ"
		
			If SZ5PESQ->NREG > 0
				FT_FSKIP()
				SZ5PESQ->(DbCloseArea())
				Loop
			Else
				SZ5PESQ->(DbCloseArea())
			EndIf

			DbSelectArea("SA6")
			DbSetOrder(5) // FILIAL+CONTA
			If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
				If SA6->A6_COD == "237"
					RecLock("SZ5",.T.)
					SZ5->Z5_FILIAL 		:= xFilial("SZ5")
					SZ5->Z5_BANCO 		:= "237"
					SZ5->Z5_AGENCIA 	:= SA6->A6_AGENCIA
					SZ5->Z5_CCONTA 		:= SA6->A6_NUMCON
					SZ5->Z5_LANC 		:= _cData
					SZ5->Z5_DOC 		:= _cDocument
					SZ5->Z5_PRESTA		:= _cPrest
					SZ5->Z5_TEL 		:= _cTel
					SZ5->Z5_MES 		:= U_MESREF(_cData)
					SZ5->Z5_VALOR 		:= VAL(_cValor)/100
					SZ5->Z5_CONTA		:= "N"
					SZ5->Z5_UNIDADE		:= _cUnid
					SZ5->Z5_CR			:= _cCR
					MsUnLock()
				EndIf
			EndIf
		ElseIf _cTpBlq $ "0036|1071|0726|0933|0239|0213|0403|1954|1901|1220|1219|0777|0968"
			//GERACAO DO SE5

			cQuery := "SELECT COUNT(*) AS NREG "
			cQuery += "FROM "+RetSQLname('SE5')+" "
			cQuery += "WHERE D_E_L_E_T_ <> '*' "
			cQuery += "AND E5_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
			cQuery += "AND E5_DOCUMEN = '"+_cDocument+"' "
			cQuery += "AND E5_DATA = '"+DTOS(_cData)+"' "
			TcQuery cQuery New Alias "SE5PESQ"

			If SE5PESQ->NREG > 0
				FT_FSKIP()
				SE5PESQ->(DbCloseArea())
				Loop
			Else
				SE5PESQ->(DbCloseArea())
			EndIf

			cQuery 		:= " SELECT * "
			cQuery 		+= " FROM "+RetSQLname('SZM')+" "
			cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
			cQuery 		+= " AND ZM_TIPOIMP LIKE '%"+_cTpBlq+"%' "
			TcQuery cQuery New Alias "SZMTRB"

			If SZMTRB->(!EOF())
				_cCod		:= SZMTRB->ZM_COD
				_cMoeda		:= SZMTRB->ZM_MOEDA
				_cNaturez	:= SZMTRB->ZM_NATUREZ
				_cBenef		:= SZMTRB->ZM_BENEF
				_cHist		:= SZMTRB->ZM_HISTOR
				_cItemD		:= SZMTRB->ZM_ITEMD
				_cDebito	:= SZMTRB->ZM_DEBITO
				_cCCD		:= SZMTRB->ZM_CCD
				SZMTRB->(DbCloseArea())
			Else
				_cCod		:= ""
				_cMoeda		:= ""
				_cNaturez	:= ""
				_cBenef		:= ""
				_cHist		:= ""
				_cItemD		:= ""
				_cDebito	:= ""
				_cCCD		:= ""
				FT_FSKIP()
				SZMTRB->(DbCloseArea())
				Loop
			EndIf

			DbSelectArea("SA6")
			DbSetOrder(5) // FILIAL+CONTA
			If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
				If SA6->A6_COD == "237"
					RecLock("SE5",.T.)
					SE5->E5_FILIAL 		:= xFilial("SE5")
					SE5->E5_DATA 		:= _cData
					SE5->E5_XTIPO 		:= _cCod
					SE5->E5_MOEDA 		:= _cMoeda
					SE5->E5_VALOR 		:= VAL(_cValor)/100
					SE5->E5_NATUREZ		:= _cNaturez
					SE5->E5_BANCO		:= "237"
					SE5->E5_AGENCIA		:= SA6->A6_AGENCIA
					SE5->E5_CONTA		:= SA6->A6_NUMCON
					SE5->E5_DOCUMEN		:= _cDocument
					SE5->E5_BENEF		:= _cBenef
					SE5->E5_HISTOR		:= _cHist
					SE5->E5_ITEMD		:= _cItemD
					SE5->E5_DEBITO		:= _cDebito
					SE5->E5_CCD			:= _cCCD
					SE5->E5_RECPAG		:= "P"
					SE5->E5_DTDISPO		:= _cData
					//acrescentado campos abaixo dia 09/10/12 pelo analista Emerson Natali.
					//os campos foram acrescentados pois como esta sendo gravado o registro noa estava contabilizando o Cancelamento do Mov.Bancario
					SE5->E5_VENCTO		:= _cData
					SE5->E5_LA			:= "S"
					SE5->E5_DTDIGIT		:= _cData
					SE5->E5_RATEIO		:= "N"
					SE5->E5_FILORIG		:= xFilial("SE5")
					SE5->E5_MODSPB		:= "1"
					SE5->E5_CODORCA		:= "PADRAOPR"
					MsUnLock()
				EndIf
			EndIf

			//*************************************************
			//Contabiliza Lancamento Cartao
			//*************************************************
			aCab		:= {}
			aItem		:= {}
			aTotItem	:=	{}
			lMsErroAuto := .f.

			aCab := {	{"dDataLanc", _cData	,NIL},;
						{"cLote"	, "008850"	,NIL},;
						{"cSubLote"	, "001"		,NIL}}

			AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")											, NIL},;
							{"CT2_LINHA"	, "001"														, NIL},;
							{"CT2_DC"		, "3"	 													, NIL},;
							{"CT2_ITEMD"	, _cItemD													, NIL},;
							{"CT2_CCD"		, _cCCD														, NIL},;
							{"CT2_ITEMC"	, SA6->A6_CONTABI											, NIL},;
							{"CT2_VALOR"	, val(_cValor)/100											, NIL},;
							{"CT2_HP"		, ""														, NIL},;
							{"CT2_HIST"		, _cHist													, NIL},;
							{"CT2_TPSALD"	, "9"														, NIL},;
							{"CT2_ORIGEM"	, "210"+"                                  "+"LP 562/001"	, NIL},;
							{"CT2_MOEDLC"	, "01"														, NIL},;
							{"CT2_EMPORI"	, ""														, NIL},;
							{"CT2_ROTINA"	, ""														, NIL},;
							{"CT2_LP"		, ""														, NIL},;
							{"CT2_KEY"		, ""														, NIL}})

            U_fContab(aCab,aItem)

		EndIf
	
		FT_FSKIP()
	EndDo
	FT_FUSE()
Next

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
	ferase(cDirect+adirect[_nI,1])
Next

MsgInfo("Importacao Finalizada com Sucesso!!!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfContab   บAutor  ณMicrosiga           บ Data ณ  04/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para gerar os lancamentos contabeis pela rotina     บฑฑ
ฑฑบ          ณ MSExecAuto dos debitos importados                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fContab(aCab,aItem)

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
			//*************************************************
			//FIM Contabiliza Lancamento Cartao
			//*************************************************
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX1       บAutor  ณMicrosiga           บ Data ณ  08/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSX1a()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)
/*
             grupo ,ordem,pergunt                ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01,defspa01,defeng01,cnt01,var02,def02,defspa02,defeng02,cnt02,var03,def03,defspa03,defeng03,cnt03,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data de Lancamento ? ","      ","       ","mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_par01",""   ,""      ,""      ,"dDatabase"   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Data de Baixa      ? ","      ","       ","mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_par02",""   ,""      ,""      ,"dDatabase"   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX1       บAutor  ณMicrosiga           บ Data ณ  08/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSX1b()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

_cPerg := Left(_cPerg,10)
/*
             grupo ,ordem,pergunt           ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01        ,def01   ,defspa01,defeng01,cnt01,var02,def02       ,defspa02,defeng02,cnt02,var03,def03  ,defspa03,defeng03,cnt03,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{_cPerg  ,"01" ,"Data Lanca. de  ? ","      ","       ","mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_par01",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"02" ,"Data Lanca. ate ? ","      ","       ","mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_par02",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"03" ,"Prestadora de   ? ","      ","       ","mv_ch3","C" ,15 ,00 ,0  ,"G",""   ,"mv_par03",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"BZ7","","","",""})
aAdd(aRegs,{_cPerg  ,"04" ,"Prestadora ate  ? ","      ","       ","mv_ch4","C" ,15 ,00 ,0  ,"G",""   ,"mv_par04",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"BZ7","","","",""})
aAdd(aRegs,{_cPerg  ,"05" ,"Unidade de      ? ","      ","       ","mv_ch5","C" ,15 ,00 ,0  ,"G",""   ,"mv_par05",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"06" ,"Unidade ate     ? ","      ","       ","mv_ch6","C" ,15 ,00 ,0  ,"G",""   ,"mv_par06",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"07" ,"Referencia de   ? ","      ","       ","mv_ch7","C" ,15 ,00 ,0  ,"G",""   ,"mv_par07",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"08" ,"Referencia ate  ? ","      ","       ","mv_ch8","C" ,15 ,00 ,0  ,"G",""   ,"mv_par08",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"09" ,"Grupo de        ? ","      ","       ","mv_ch9","C" ,01 ,00 ,0  ,"G",""   ,"mv_par09",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"10" ,"Grupo ate       ? ","      ","       ","mv_cha","C" ,01 ,00 ,0  ,"G",""   ,"mv_par10",""      ,""      ,""      ,""   ,""   ,""         ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"11" ,"SP/Outros/Todos ? ","      ","       ","mv_chb","N" ,01 ,00 ,0  ,"C",""   ,"mv_par11","SP"    ,""      ,""      ,""   ,""   ,"Outros"   ,""      ,""      ,""   ,""   ,"Todos",""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{_cPerg  ,"12" ,"Status          ? ","      ","       ","mv_chc","N" ,01 ,00 ,0  ,"C",""   ,"mv_par12","Aberto",""      ,""      ,""   ,""   ,"Sem Conta",""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(_cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return

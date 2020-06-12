#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA06   º Autor ³ Andy               º Data ³  28/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Contas de Consumo                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINA06()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArq,cInd,cPerg
Local cString := "SZ5"
Local aStru

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private aPags := {}
Private _dPar01, _dPar02
Private _cSZ5Ban, _cSZ5Age, _cSZ5Con

_cSZ5Ban:=Space(03)
_cSZ5Age:=Space(05)
_cSZ5Con:=Space(10)


cPerg := "FINA06"
_aSX1 := {;
{cPerg,"01","Data de Lancamento ?"," "," ","mv_ch1","D",8,0,0,"G","","mv_par01","","","","dDatabase","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"02","Data de Baixa      ?"," "," ","mv_ch2","D",8,0,0,"G","","mv_par02","","","","dDatabase","","","","","","","","","","","","","","","","","","","","","","",""}}
AjustaSX1(_aSX1) // _FixSX.ch


// Se o usuario nao confirmar, nao processar.
If !Pergunte(cPerg, .T.)
	Return
EndIf

_dPar01:=mv_par01
_dPar02:=mv_par02

dbSelectArea("SZ5")
dbSetOrder(1)

//AxCadastro(cString, "Contas de Consumo", cVldAlt, cVldExc)

cCadastro := "Contas de Consumo"
aCores    := {}
//{"Incluir"    ,"AxInclui"    , 0 , 3},;
//{"Alterar"    ,"AxAltera"    , 0 , 4},;
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"    , 0 , 1},;
{"Visualizar" ,"AxVisual"    , 0 , 2},;
{"Incluir"     ,'AxInclui("SZ5",Recno(),3,,"U_SZ5Ini",,"U_SZUOK()")' , 0 , 3},;
{"Alterar"     ,'AxAltera("SZ5",Recno(),4,,,,,"U_SZUTudOK()")', 0 , 4},;
{"Excluir"    ,"AxDeleta"    , 0 , 5},;
{"Baixar"     ,"U_BAIXA_SZ5" , 0 , 6},;
{"Legenda"    ,'BrwLegenda(cCadastro,"Legenda",{{"BR_AMARELO","Baixado sem Conta"},{"BR_VERDE","Aberto"},{"BR_VERMELHO","Baixado"}})',0 , 7 }}

Aadd( aCores, { "Empty(Z5_BAIXA) .AND. Z5_CONTA == 'S' "	, "BR_AMARELO"  	} )
Aadd( aCores, { "Empty(Z5_BAIXA) .AND. Empty(Z5_FL)    " 	, "BR_VERDE" 	 	} )
Aadd( aCores, { "!Empty(Z5_BAIXA) " 	, "BR_VERMELHO"		} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ5")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZ5",,,,,2, aCores)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  MESREF  º Autor ³ Andy               º Data ³  28/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inicializa campo Z5_MES, conforme mv_par01 do              º±±
±±º          ³ Programa CFINA06                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ativado em X3_RELACAO do Campo Z5_MES                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MESREF(_dDataRef)
_aMes := {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
_nPos := Val(SUBS(DTOS(_dDataRef),5,2))
_nPos := _nPos - IIf(Val(SUBS(DTOS(_dDataRef),7,2))>=01,1,0) // dia de referência
If _nPos <= 0
	_nPos:=12
EndIf
_cMes := _aMes[_nPos]
Return(_cMes)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALMESREF º Autor ³ Andy               º Data ³  28/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consiste campo Z5_MES, no Programa CFINA06                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ativado em X3_VALID do Campo Z5_MES                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Baixa_SZ5 º Autor ³ Andy               º Data ³  28/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Preenche Z5_BAIXA, no Programa CFINA06                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BAIXA_SZ5()
//MSGSTOP("Favor Baixar pela Alteracao! ")
//Return
Local aArea := GetArea() //, aPags := {}
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )
Private cPerg  := "FINAA6"
//Private _cUseBaix := Alltrim(GetMv("CI_USEBAIX"))
Private _lRetp
lRet        := .F.
aPags       := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Data de                                     ³
//³ mv_par02 - Data de ate                                 ³
//³ mv_par03 - Prestadora de                               ³
//³ mv_par04 - Prestadora ate                              ³
//³ mv_par05 - Unidade de                                  ³
//³ mv_par06 - Unidade ate                                 ³
//³ mv_par07 - Referencia de                               ³
//³ mv_par08 - Referencia ate                              ³
//³ mv_par09 - Grupo de                                    ³
//³ mv_par10 - Grupo ate                                   ³
//³ mv_par11 - SP/Outros/Todos                             ³
//³ mv_par12 - Status                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
AADD(_aPerg,{cPerg,"01","Data Lanca. de     ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","Data Lanca. ate    ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"03","Prestadora de      ?","","","mv_ch3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","BZ7","",""})
AADD(_aPerg,{cPerg,"04","Prestadora ate     ?","","","mv_ch4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","BZ7","",""})
AADD(_aPerg,{cPerg,"05","Unidade de         ?","","","mv_ch5","C",15,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"06","Unidade ate        ?","","","mv_ch6","C",15,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"07","Referencia de      ?","","","mv_ch7","C",15,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"08","Referencia ate     ?","","","mv_ch8","C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"09","Grupo de           ?","","","mv_ch9","C",01,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"10","Grupo ate          ?","","","mv_cha","C",01,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"11","SP/Outros/Todos    ?","","","mv_chb","N",01,0,0,"C","","mv_par11","SP","","","","","Outros","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"12","Status             ?","","","mv_chc","N",01,0,0,"C","","mv_par12","Aberto","","","","","Sem Conta","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)


If !Pergunte(cPerg, .T.)
	Return
EndIf               

/*
_lRetp := Pergunte(cPerg, .T.)

If _lRetp == .F.
	Return
EndIf               

If mv_par12 == 2 .and. AllTrim(SubStr(cUsuario,7,15)) $ _cUseBaix
	MsgAlert("Usuário "+AllTrim(SubStr(cUsuario,7,15))+" sem Permissão para Baixa!!!"+CHR(13)+CHR(13)+"Rever Parametro Status!!!")
	Return //u_BAIXA_SZ5()    
EndIf
*/

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
//ElseIf mv_par12 == 3
//	_cQuery += " AND (Z5_BAIXA = '' OR Z5_CONTA = 'S')"
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
				SZ5->Z5_BAIXA:=Iif(Empty(_dPar02),dDataBase,_dPar02)
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
	MsgInfo("Não foi localizado o Lancamento !","Atenção")
Endif

RestArea(aArea)

Return


User Function MARK1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inverte a marca do ListBox.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza os objetos.                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oLbx1:Refresh(.T.)
Return

User Function MUDA()
Local   aArea := GetArea()
Private aAcho := {}
Private aCpos := {}
Private _lSair := .T.

aMemos := {}
AADD(aCpos,"Z5_MES")
//AADD(aCpos,"Z5_CONTA")
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
			MsgAlert(_cMsg, "Atenção")
			Exit
		EndIf
	EndIf
	_nCont:=_nCont+1
EndDo

RestArea(aArea)
oLbx1:Refresh(.T.)

If !_lLanc
	_cMsg := "Não Há Lançamentos Selecionados para Edicao!!!"
	MsgAlert(_cMsg, "Atenção")
EndIf
Return

User Function SZ5Ini()
Local  _aArea := GetArea()
M->Z5_BANCO    := _cSZ5Ban
M->Z5_AGENCIA  := _cSZ5Age
M->Z5_CCONTA   := _cSZ5Con
RestArea(_aArea)
Return

User Function SZUTudOK()
Local _aArea := GetArea()
Local _cRet  := .T.

If Empty(M->Z5_DOC)
	MsgAlert("Favor preencher campo Documento!", OemToAnsi("Atenção"))
	_cRet:=.F.
Else
	If SZ5->Z5_DOC <> "9999999999"
		MsgAlert("Somente Documento Nao Identicado pode ser alterado!", OemToAnsi("Atenção"))
		_cRet:=.F.
	Else
		dbSelectArea("SZ5")
		dbSetOrder(5)
		If dbSeek(xFilial("SZ5")+M->Z5_DOC+M->Z5_MES, .F.)
			_cMes:=M->Z5_MES
			While _cMes==SZ5->Z5_MES .And. !Eof()
				If YEAR(M->Z5_LANC)==YEAR(SZ5->Z5_LANC)
					MsgAlert("Documento: "+AllTrim(M->Z5_DOC)+" com Mes de Referencia "+AllTrim(M->Z5_MES)+" já Lancado!", OemToAnsi("Atenção"))
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

User Function SZUOK()
Local _aArea := GetArea()
Local _cRet  := .T.

If Empty(M->Z5_DOC)
	MsgAlert("Favor preencher campo Documento!", OemToAnsi("Atenção"))
	_cRet:=.F.
Else
	
	If M->Z5_DOC <> "9999999999"
		dbSelectArea("SZ5")
		dbSetOrder(5)
		If dbSeek(xFilial("SZ5")+M->Z5_DOC+M->Z5_MES, .F.)
			_cMes:=M->Z5_MES
			While _cMes==SZ5->Z5_MES .And. !Eof()
				If YEAR(M->Z5_LANC)==YEAR(SZ5->Z5_LANC)
					MsgAlert("Documento: "+AllTrim(M->Z5_DOC)+" com Mes de Referencia "+AllTrim(M->Z5_MES)+" já Lancado!", OemToAnsi("Atenção"))
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
RestArea(_aArea)
Return(_cRet)


User Function SAIRSZ5()
_lSair := .F.
Return(.T.)

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

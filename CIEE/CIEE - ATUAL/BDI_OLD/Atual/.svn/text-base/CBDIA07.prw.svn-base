#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณEMERSON NATALI      บ Data ณ  03/08/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CONSULTA GERAL (CONTATOS, ENTIDADE, CONTATOS BDI)          บฑฑ
ฑฑบ          ณ ESTE PROGRAMA CONTEM TODAS AS ROTINA NECESSARIA PARA A     บฑฑ
ฑฑบ          ณ INCLUSAO/ ALTERACA/ EXCLUSAO (MANUTENCAO)                  บฑฑ
ฑฑบ          ณ E OS VINCULOS ENTRE:                                       บฑฑ
ฑฑบ          ณ CONTATOS X CONTATOS BDI                                    บฑฑ
ฑฑบ          ณ CONTATOS X ENTIDADE                                        บฑฑ
ฑฑบ          ณ CONTATOS X ENTIDADE X PERFIL (TRATAMENTO)                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
// TELA INICIAL PARA PARAMETROS
User Function CBDIA07()

Local aSays    := {}
Local aButtons := {}
Local nOpca    := 0

Private n
Private _fPrograma

cPerg := "CBDI07"

AADD(aSays, " Este Programa tem o objetivo de Pesquisar um nome dentro do     ")
AADD(aSays, " cadastro Contatos / Entidades / Contatos BDI conforme parametro ")
AADD(aSays, " definidos pelo usuario ")

AADD(aButtons,{1,.T.,{|o| nOpca:=1,o:oWnd:End()	}})
AADD(aButtons,{2,.T.,{|o| nOpca:=0,o:oWnd:End()	}})
AADD(aButtons,{5,.T.,{|| _fCriaSX1()}})

FormBatch("Consulta Contatos/ Entidade/ Contatos BDI",aSays,aButtons)

pergunte(cperg,.F.)

Do Case
	Case nOpca == 1
//		MsgRun("Aguarde Selecionando Registros", "Montando Consulta",{|| u_CBDIA07b()}) // Tela de Consulta
		u_CBDIA07b()
EndCase

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07b  บAutor  ณMicrosiga           บ Data ณ  08/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Consulta a partir dos parametros                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07b()

Private nCont

Do Case
	Case mv_par01 == 1
		// Filtra Cadastro de Contatos conforme parametros definido pelo usuario
			cQuery  := "SELECT * "
			cQuery  += " FROM "+RetSQLname('SU5') "
			cQuery  += " WHERE D_E_L_E_T_ <> '*' "
			cQuery  += " AND U5_CONTAT LIKE '%"+Alltrim(mv_par02)+"%' "
			cQuery  += " ORDER BY U5_CONTAT"
			TcQuery cQuery New Alias "TMP"
	Case  mv_par01 == 2
		// Filtra Cadastro de Entidade conforme parametros definido pelo usuario
			cQuery  := "SELECT * "
			cQuery  += " FROM "+RetSQLname('SZM') "
			cQuery  += " WHERE D_E_L_E_T_ <> '*' "
			cQuery  += " AND ZM_NOME LIKE '%"+Alltrim(mv_par02)+"%' "
			cQuery  += " ORDER BY ZM_NOME"
			TcQuery cQuery New Alias "TMP"
	Case  mv_par01 == 3
		// Filtra Cadastro de Contatos BDI conforme parametros definido pelo usuario
			cQuery  := "SELECT * "
			cQuery  += " FROM "+RetSQLname('SA2') "
			cQuery  += " WHERE D_E_L_E_T_ <> '*' "
			cQuery  += " AND A2_NOME LIKE '%"+Alltrim(mv_par02)+"%' "
			cQuery  += " ORDER BY A2_NOME"
			TcQuery cQuery New Alias "TMP"		
EndCase

dbSelectArea("TMP")
dbGotop()

nCont := 0
Do While !Eof()
	nCont++
	TMP->(DbSkip())
EndDo

dbSelectArea("TMP")
dbGotop()

Do Case 
	Case mv_par01 == 1
		// Filtra Cadastro de Contatos conforme parametros definido pelo usuario
			u_CBDIA07e()
	Case mv_par01 == 2
		// Filtra Cadastro de Entidade conforme parametros definido pelo usuario
			u_CBDIA07f()
	Case  mv_par01 == 3
		// Filtra Cadastro de Contatos BDI conforme parametros definido pelo usuario
			u_CBDIA07i()
EndCase

/*
DbSelectArea("TMP")
DbCloseArea()
*/
Return
/*
-----------------------------------------------------------------------
------------------------- C O N T A T O S -----------------------------
-----------------------------------------------------------------------
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07e  บAutor  ณMicrosiga           บ Data ณ  16/08/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ TELA INICIAL: CONSULTA CONTATOS                            บฑฑ
ฑฑบ          ณ VISUALIZACAO DOS CONTATOS                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07e()

Local oDlg       := Nil

Private oGet     := Nil
Private aHeader  := {}
Private cCabec   := "aHeader"
Private aCOLS    := {}
Private _lINCLUI := .F.
Private _fPrg    := PROCNAME()

cCadastro := "Consulta Contatos"

//Se nao encontrar nenhum registro, nao mostra a tela
//If nCont > 0
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("U5_CODCONT") // Codigo Contatos
	_fCabec(cCabec)      // Cria o aHeader com os campos do SX3
	dbSeek("U5_CONTAT")  // Nome Contatos
	_fCabec(cCabec)
	dbSeek("U5_DGRUPO")  // Grupo
	_fCabec(cCabec)
	dbSeek("U5_DESC")    // Cargo
	_fCabec(cCabec)
	dbSeek("U5_DNIVEL")  // Tratamento
	_fCabec(cCabec)
	dbSeek("U5_EMAIL")   // E-mail
	_fCabec(cCabec)	
//EndIf
                   
dbSelectArea("TMP")
If nCont >0
	While !EOF()
	                                                    // Grupo        // Cargo       // Tratamento
		AADD( aCOLS,{TMP->U5_CODCONT, TMP->U5_CONTAT, TMP->U5_DGRUPO, TMP->U5_DESC, TMP->U5_DNIVEL, TMP->U5_EMAIL, .F.})
		dbSelectArea("TMP")
		dbSkip()
	End
Else
	AADD( aCOLS,{"", "", "", "", "", .F.})
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

oGet    := MsNewGetDados():New(41,2,250,500,,,,,,,,,,,oDlg,aheader,acols)

// Se nao tiver nenhum registro nao mostra o botao
//If Len(aCols) > 0 
// Rotina de Inclusao da Categoria da Pessoa Fisica
	@ 270, 150 BUTTON "Categoria" ACTION u_CBDIA07L() SIZE 40,15 PIXEL OF oDlg

// Rotina de Inclusao de Endereco
	@ 270, 200 BUTTON "Enderecos" ACTION u_CBDIA07a() SIZE 40,15 PIXEL OF oDlg

// Esta chamada traz a tela de Contatos X Contatos BDI
	@ 270, 250 BUTTON "Contato BDI"  ACTION u_CBDIA07c() SIZE 40,15 PIXEL OF oDlg
//EndIf

// Rotina de Inclusao de Contato
	@ 270, 300 BUTTON "Novo Contato" ACTION u_CBDIA07d() SIZE 40,15 PIXEL OF oDlg

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

DbSelectArea("TMP")
DbCloseArea()

u_CBDIA07()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07L  บAutor  ณEmerson Natali      บ Data ณ  11/08/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAmarracao Contatos X Categoria                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07L()

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg2    := Nil

Private cCodigo
Private cNome
Private lRet     := .T.
Private nUsado   := 0

Private oGet2    := Nil
Private aHeader2 := {}
Private cCabec   := "aHeader2"
Private aCOLS2   := {}

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n:=oGet:obrowse:nAt // Posicao do Contato tela inicial

_nPos2  := ascan( aHeader, { |x| x[2] = "U5_CODCONT"}) // CONTATOS
cCodigo := aCols[n,_nPos2]
_nPos3  := ascan( aHeader, { |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
cNome   := aCols[n,_nPos3]

cCadastro := "Manutencao Contatos X Categorias"

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZY")
While !EOF() .And. X3_ARQUIVO == "SZY"
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		_fCabec(cCabec) // Cria aHeader com base no SX3
	Endif
	dbSkip()
End

dbSelectArea("SZY")
dbSetOrder(2) //Cod Contato
dbSeek( xFilial("SZY") + cCodigo ,.t. )
                                  
While !EOF() .And. SZY->ZY_FILIAL + SZY->ZY_CODCONT == xFilial("SZY") + cCodigo
	
	aAdd( aCOLS2, Array(Len(aHeader2)+1))
	
	nCnt++
	nUsado:=0
	dbSelectArea("SX3")
	dbSetOrder(1)	
	dbSeek("SZY") 
	While !EOF() .And. X3_ARQUIVO == "SZY"
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := "SZY"+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS2[nCnt][nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS2[nCnt][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS2[nCnt][nUsado+1] := .F.
	dbSelectArea("SZY")
	dbSkip()
End

aSort(aCOLS2,,, { |x, y| x[1] < y[1] })

DEFINE MSDIALOG oDlg2 TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg2 PIXEL

@ 24, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg2
@ 24, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg2

@ 23, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oDlg2
@ 23, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oDlg2

aCampos := {}
AADD(aCampos,"ZY_COD")

nGetd   := GD_INSERT+GD_UPDATE+GD_DELETE

oget2   := MsNewGetDados():New(41,2,160,372,nGetd,"u_CatLinOK","u_CatTudOK","+ZY_ITEM",aCampos,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg2,aheader2,acols2)

ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpcA:=1,Iif(u_CatTudOK(),oDlg2:End(),nOpcA:=0)},{||oDlg2:End()})

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07a  บAutor  ณMicrosiga           บ Data ณ  09/08/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Amarracao Contatos X Enderecos  (SU5 X SZS)                บฑฑ
ฑฑบ          ณ tela de manutencao do cadastro de vinculo                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07a()

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg2    := Nil

Private _cTipo   := ""
Private _cCampo  := ""
Private cCodigo
Private cNome

Private _cProg   := PROCNAME()

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n:=oGet:obrowse:nAt // Posicao do Contato tela inicial

Do Case
	Case _fPrg == "U_CBDIA07E" // Contato
		_nPos2  := ascan( aHeader, { |x| x[2] = "U5_CODCONT"}) // CONTATOS
		cCodigo := aCols[n,_nPos2]
		_nPos3  := ascan( aHeader, { |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
		cNome   := aCols[n,_nPos3]
		_cTipo  := "F"
		_cCampo := "ZS_CODCONT"
	Case _fPrg == "U_CBDIA07F" // Entidade
		_nPos2  := ascan( aHeader, { |x| x[2] = "ZM_CODENT"}) // ENTIDADE
		cCodigo := aCols[n,_nPos2]
		_nPos3  := ascan( aHeader, { |x| x[2] = "ZM_NOME"})   // NOME DA ENTIDADE
		cNome   := aCols[n,_nPos3]
		_cTipo  := "J"
		_cCampo := "ZS_CODENT"
	Case _fPrg == "U_CBDIA07I" // Contatos BDI
		n       :=oGet2:obrowse:nAt // Posicao do Contato tela inicial
		_nPos2  := ascan( aHeader2, { |x| x[2] = "AC8_CODCON"}) // CONTATOS
		cCodigo := aCols2[n,_nPos2]
		_nPos3  := ascan( aHeader2, { |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
		cNome   := aCols2[n,_nPos3]
		_cTipo  := "F"
		_cCampo := "ZS_CODCONT"
EndCase

Private lRet     := .T.
Private nUsado   := 0
If _fPrg == "U_CBDIA07I" // Contatos BDI
	Private oGet3    := Nil
	Private aHeader3 := {}
	Private cCabec   := "aHeader3"
	Private aCOLS3   := {}
Else
	Private oGet2    := Nil
	Private aHeader2 := {}
	Private cCabec   := "aHeader2"
	Private aCOLS2   := {}
EndIf

Do Case
	Case _fPrg == "U_CBDIA07E" .or. _fPrg == "U_CBDIA07I" // Contato // Contatos BDI
		cCadastro := "Manutencao Contatos X Enderecos"
	Case _fPrg == "U_CBDIA07F" // Entidade
		cCadastro := "Manutencao Entidade X Enderecos"
EndCase

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("ZS_ITEM")
_fCabec(cCabec) // Cria aHeader com base no SX3
dbSeek("ZS_TIPOEND")
_fCabec(cCabec)
dbSeek("ZS_END")
_fCabec(cCabec)
dbSeek("ZS_ENDPAD")
_fCabec(cCabec)

dbSelectArea("SZS")

If _fPrg == "U_CBDIA07E" .or. _fPrg == "U_CBDIA07I"
	dbSetOrder(1)
Else
	dbSetOrder(2)
EndIf

dbSeek( xFilial("SZS") + _cTipo + cCodigo ,.t. ) //Pessoa Fisica
                                   
While !EOF() .And. SZS->ZS_FILIAL + SZS->&_cCampo == "01" + cCodigo
	If _fPrg == "U_CBDIA07I"
		aAdd( aCOLS3,{ SZS->ZS_ITEM,SZS->ZS_TIPOEND,SZS->ZS_END,SZS->ZS_ENDPAD, .F.})
	Else
		aAdd( aCOLS2,{ SZS->ZS_ITEM,SZS->ZS_TIPOEND,SZS->ZS_END,SZS->ZS_ENDPAD, .F.})
	EndIf
	dbSelectArea("SZS")
	dbSkip()
End

DEFINE MSDIALOG oDlg2 TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg2 PIXEL

@ 24, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg2
@ 24, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg2

@ 23, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oDlg2
@ 23, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oDlg2

If _fPrg == "U_CBDIA07I" // Contatos BDI

	oGet3 := MsNewGetDados():New(41,2,160,372,,,,,/*aCampos*/,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg2,aheader3,acols3)

	@ 175, 300 BUTTON "Visualizar" ACTION fVisual() SIZE 40,15 PIXEL OF oDlg2
	
	ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||oDlg2:End()},{||oDlg2:End()})

Else
//	nGetd   := GD_DELETE
//	oget2   := MsNewGetDados():New(41,2,160,372,nGetd,"u_EndLinOK","u_EndTudOK",,/*aCampos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg2,aheader2,acols2)
	oget2   := MsNewGetDados():New(41,2,160,372,,"u_EndLinOK","u_EndTudOK",,/*aCampos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg2,aheader2,acols2)

	@ 175, 200 BUTTON "Incluir"    ACTION fInclui() SIZE 40,15 PIXEL OF oDlg2
	@ 175, 250 BUTTON "Alterar"    ACTION fAltera() SIZE 40,15 PIXEL OF oDlg2
	@ 175, 300 BUTTON "Visualizar" ACTION fVisual() SIZE 40,15 PIXEL OF oDlg2

	ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpcA:=1,Iif(u_EndTudOK(),oDlg2:End(),nOpcA:=0)},{||oDlg2:End()})

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fInclui()

INCLUI  := .T.

_opcao := AxInclui("SZS",0,3,,,,)

If _opcao == 1 // botao <OK> da Tela de Inclusao
	aCOLS2   := {}
	dbSelectArea("SZS")
	If _fPrg == "U_CBDIA07E" .or. _fPrg == "U_CBDIA07I"
		dbSetOrder(1)
	Else
		dbSetOrder(2)
	EndIf
	dbSeek( xFilial("SZS") + _cTipo + cCodigo ,.t. ) //Pessoa Fisica

	While !EOF() .And. SZS->ZS_FILIAL + SZS->&_cCampo == "01" + cCodigo
		aAdd( aCOLS2,{ SZS->ZS_ITEM,SZS->ZS_TIPOEND,SZS->ZS_END,SZS->ZS_ENDPAD, .F.})
		dbSelectArea("SZS")
		dbSkip()
	End

	oget2:acols := acols2

	fInclui()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAltera()

Local nOpcA    := 0

Private INCLUI := .F.
Private aSize := MsAdvSize()

aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aObjects:= {}
aCampos := {}

n:=oGet2:obrowse:nAt

If Empty(acols2)
	msgbox("Nao e permitido alterar linha em Branco")
	Return
EndIf

acols2 := oget2:acols
             
AADD( aObjects,{315,120,.T.,.T.})
AADD( aObjects,{100,400,.T.,.T.})

dbSelectArea("SZS")
If _fPrg == "U_CBDIA07E" .or. _fPrg == "U_CBDIA07I"
	dbSetOrder(1)
Else
	dbSetOrder(2)
EndIf
dbSeek( xFilial("SZS") + _cTipo + cCodigo + aCols2[n,1] ,.t. ) //Pessoa Fisica

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZS")
While !EOF() .And. X3_ARQUIVO == "SZS"
	IF X3USO(X3_USADO)
		cCampo := X3_CAMPO
		If INCLUI
			M->&(cCampo) := CriaVar(cCampo,.T.)
		Else
			M->&(cCampo) := SZS->(FieldGet(FieldPos(cCampo)))
		EndIf
	Endif
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE "Cadastro de Endereco - Alterar" FROM aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

Enchoice("SZS",n,4,,,,,,,3,,,,,,.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})

If nOpcA == 1
	dbSelectArea("SZS")
	If _fPrg == "U_CBDIA07E" .or. _fPrg == "U_CBDIA07I"
		dbSetOrder(1)
	Else
		dbSetOrder(2)
	EndIf
	DbSeek(xFilial("SZS")+_cTipo+CCODIGO+aCols2[n,1])
	RecLock("SZS",,.F.)
	SZS->ZS_ENDPAD  := M->ZS_ENDPAD
	SZS->ZS_TIPOEND := M->ZS_TIPOEND
	SZS->ZS_END     := M->ZS_END
 	SZS->ZS_BAIRRO  := M->ZS_BAIRRO
 	SZS->ZS_MUN     := M->ZS_MUN
 	SZS->ZS_EST     := M->ZS_EST
 	SZS->ZS_CEP     := M->ZS_CEP
 	SZS->ZS_CODPAIS := M->ZS_CODPAIS
 	SZS->ZS_DDD     := M->ZS_DDD
 	SZS->ZS_FONE    := M->ZS_FONE
 	SZS->ZS_FCOM1   := M->ZS_FCOM1
 	SZS->ZS_FAX     := M->ZS_FAX
	MsUnLock("SZS")

	aCOLS_2   := {}
	dbSelectArea("SZS")
	If _fPrg == "U_CBDIA07E" .or. _fPrg == "U_CBDIA07I"
		dbSetOrder(1)
	Else
		dbSetOrder(2)
	EndIf
	dbSeek( xFilial("SZS") + _cTipo + cCodigo ,.t. ) //Pessoa Fisica

	While !EOF() .And. SZS->ZS_FILIAL + SZS->&_cCampo == "01" + cCodigo
		aAdd( aCOLS_2,{ SZS->ZS_ITEM,SZS->ZS_TIPOEND,SZS->ZS_END,SZS->ZS_ENDPAD, .F.})
		dbSelectArea("SZS")
		dbSkip()
	End
	oget2:acols := acols_2
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fVisual()

Private INCLUI := .F.
Private aSize := MsAdvSize()

aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aObjects:= {}
aCampos := {}

n:=oGet2:obrowse:nAt

If Empty(acols2)
	msgbox("Nao e permitido visualizar linha em Branco")
	Return
EndIf
acols2:=oGet2:acols
             
AADD( aObjects,{315,120,.T.,.T.})
AADD( aObjects,{100,400,.T.,.T.})

dbSelectArea("SZS")
If _fPrg == "U_CBDIA07E" .or. _fPrg == "U_CBDIA07I"
	dbSetOrder(1)
Else
	dbSetOrder(2)
EndIf
dbSeek( xFilial("SZS") + _cTipo + cCodigo + aCols2[n,1] ,.t. ) //Pessoa Fisica

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZS")
While !EOF() .And. X3_ARQUIVO == "SZS"
	IF X3USO(X3_USADO)
		cCampo := X3_CAMPO
		If INCLUI
			M->&(cCampo) := CriaVar(cCampo,.T.)
		Else
			M->&(cCampo) := SZS->(FieldGet(FieldPos(cCampo)))
		EndIf
	Endif
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE "Cadastro de Endereco - Visualizar" FROM aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

Enchoice("SZS",n,2,,,,,,,3,,,,,,.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07c  บAutor  ณMicrosiga           บ Data ณ  09/08/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Amarracao Contatos X Contatos BDI  (SU5 X AC8)             บฑฑ
ฑฑบ          ณ tela de manutencao do cadastro de vinculo                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07c()

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg2    := Nil

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n:=oGet:obrowse:nAt // Posicao do Contato tela inicial

If !_lINCLUI
//	cCodigo := SU5->U5_CODCONT
//	cNome   := SU5->U5_CONTAT
//Else
	_nPos2  := ascan( aHeader, { |x| x[2] = "U5_CODCONT"}) // CONTATOS
	cCodigo := aCols[n,_nPos2]
	_nPos3  := ascan( aHeader, { |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
	cNome   := aCols[n,_nPos3]
EndIf

Private lRet     := .T.
Private nUsado   := 0
Private oGet2    := Nil
Private aHeader2 := {}
Private cCabec   := "aHeader2"
Private aCOLS2   := {}

cCadastro := "Manutencao Contatos X Contatos BDI"

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("AC8")
While !EOF() .And. X3_ARQUIVO == "AC8"
	IF X3USO(X3_USADO) .AND. X3_NIVEL == 2
		nUsado++
		_fCabec(cCabec) // Cria aHeader com base no SX3
	Endif
	dbSkip()
End

dbSelectArea("AC8")
dbSetOrder(3)
dbSeek( xFilial("AC8") + cCodigo ,.t. )
                                   
While !EOF() .And. AC8->AC8_FILIAL + AC8->AC8_CODCON == xFilial("SU5") + cCodigo
	
	aAdd( aCOLS2, Array(Len(aHeader2)+1))
	
	nCnt++
	nUsado:=0
	dbSelectArea("SX3")
	dbSetOrder(1)	
	dbSeek("AC8")
	While !EOF() .And. X3_ARQUIVO == "AC8"
		IF X3USO(X3_USADO) .AND. X3_NIVEL == 2
			nUsado++
			cVarTemp := "AC8"+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS2[nCnt][nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS2[nCnt][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS2[nCnt][nUsado+1] := .F.
	dbSelectArea("AC8")
	dbSkip()
End

DEFINE MSDIALOG oDlg_a TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg2 PIXEL

@ 24, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg_a
@ 24, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg_a

@ 23, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oDlg_a
@ 23, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oDlg_a

nGetd   := GD_INSERT+GD_UPDATE+GD_DELETE

aCampos := {}
AADD(aCampos,"AC8_COD")

oget2   := MsNewGetDados():New(41,2,160,372,nGetd,"u_fLinOk()","u_fTudOk()","+AC8_ITEM",aCampos,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg_a,aheader2,acols2)

// Esta chamada traz a tela de Contatos X Entidade
@ 175, 250 BUTTON "Entidade"   ACTION u_CBDIA03Alt() SIZE 40,15 PIXEL OF oDlg_a

ACTIVATE MSDIALOG oDlg_a ON INIT EnchoiceBar(oDlg_a,{||nOpcA:=1,Iif(u_fTudOk(),oDlg_a:End(),nOpcA:=0)},{|| Iif(u_fCanc(),oDlg_a:End(),nOpcA:=0)})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Contatos X Entidade                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA03Alt()

/*
Este programa e utilizado tambem no processo de consulta CONTATO X BDI funcao CBDIA07J
1-Para visualizar as Entidades Amarradas aos Contatos
2-Para visualizar os Enderecos das Entidades especificas por Contato
*/

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil

n        := oGet2:obrowse:nAt
aHeader2 := oget2:aHeader
aCols2   := oget2:acols

Private	cCodigo2
Private	cNome2

If Empty(aCols2)
	cMsg := "Nao sera permitido linhas sem o Codigo."
	msgbox(cMsg)
	Return
ElseIf _fPrograma == "U_CBDIA07J"
	If Empty(aCols2)
		cMsg := "Nao sera permitido linhas sem o Codigo."
		msgbox(cMsg)
		Return
	Else
		nPos := 0
		nPos := aScan(aHeader2,{|x|AllTrim(Upper(x[2]))=="AC8_CODCON"})
		If Empty(aCols2[n,nPos])
			cMsg := "Nao sera permitido linhas sem o Codigo."
			msgbox(cMsg)
			Return
		Endif
	EndIf
Else
	nPos := 0
	nPos := aScan(aHeader2,{|x|AllTrim(Upper(x[2]))=="AC8_COD"})

	If !aCols2[n][nUsado+1]
		If Empty(aCols2[n,nPos])
			cMsg := "Nao sera permitido linhas sem o Codigo."
			msgbox(cMsg)
			Return
		Endif
	Else
		cMsg := "Nao e possivel deixar Contato sem vinculo com Contato BDI "
		msgbox(cMsg)
		Return
	Endif

EndIf

n:=oGet:obrowse:nAt // Posicao do Contato tela inicial

If _lINCLUI
//	cCodigo2 := SU5->U5_CODCONT
//	cNome2   := SU5->U5_CONTAT

	cCodigo2 := cCodigo
	cNome2   := cNome

ElseIf  _fPrograma == "U_CBDIA07J"
	n:=oGet2:obrowse:nAt
	_nPos2   := ascan( aHeader2,{ |x| x[2] = "AC8_CODCON"}) // CONTATOS
	cCodigo2 := aCols2[n,_nPos2]
	_nPos3   := ascan( aHeader2,{ |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
	cNome2   := aCols2[n,_nPos3]
Else
	_nPos2   := ascan( aHeader, { |x| x[2] = "U5_CODCONT"}) // CONTATOS
	cCodigo2 := aCols[n,_nPos2]
	_nPos3   := ascan( aHeader, { |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
	cNome2   := aCols[n,_nPos3]
EndIf

Private oGet3    := Nil
Private aHeader3 := {}
Private cCabec   := "aHeader3"
Private aCOLS3   := {}
Private nUsado   := 0

cCadastro := "Manutencao Contatos x Entidade"

dbSelectArea("SZQ")
dbSetOrder(2)
dbSeek( xFilial("SZQ") + cCodigo2 ,.t.)

While !EOF() .And. SZQ->ZQ_FILIAL + SZQ->ZQ_CODCONT == xFilial("SZQ") + cCodigo2
	nCnt++
	dbSkip()
End

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZQ")
While !EOF() .And. X3_ARQUIVO == "SZQ"
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		_fCabec(cCabec) // Cria aHeader com base no SX3
	Endif
	dbSkip()
End

dbSelectArea("SZQ")
dbSetOrder(2)
dbSeek( xFilial("SZQ") + cCodigo2 ,.t. )

nCnt := 0

While !EOF() .And. SZQ->ZQ_FILIAL + SZQ->ZQ_CODCONT == xFilial("SZQ") + cCodigo2
	
	aAdd( aCOLS3, Array(Len(aHeader3)+1))
	
	nCnt++
	nUsado:=0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZQ")
	While !EOF() .And. X3_ARQUIVO == "SZQ"
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := "SZQ"+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS3[nCnt][nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS3[nCnt][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS3[nCnt][nUsado+1] := .F.
	dbSelectArea("SZQ")
	dbSkip()
End

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg1 PIXEL

@ 24, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg1
@ 24, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg1

@ 23, 026 MSGET cCodigo2 When .F. SIZE 30,7 PIXEL OF oDlg1
@ 23, 080 MSGET cNome2   When .F. SIZE 90,7 PIXEL OF oDlg1

aCampos := {}
AADD(aCampos,"ZQ_CODENT")
AADD(aCampos,"ZQ_GRUPO")

If _fPrograma == "U_CBDIA07J"

	oGet3 := MsNewGetDados():New(41,2,160,372,,,,,aCampos,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg1,aheader3,acols3)

//	If Len(aCols)>0
		@ 175, 200 BUTTON "Enderecos" ACTION u_CBDIA07k() SIZE 40,15 PIXEL OF oDlg1
		@ 175, 250 BUTTON "Perfil"    ACTION u_CBDIA03Man() SIZE 40,15 PIXEL OF oDlg1
//	EndIf

	ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| oDlg1:End()},{|| oDlg1:End()})

Else
	nGetd   := GD_INSERT+GD_UPDATE+GD_DELETE

	oGet3 := MsNewGetDados():New(41,2,160,372,nGetd,"u_Mod2LinOk()","u_Mod2TudOK()","+ZQ_ITEM",aCampos,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg1,aheader3,acols3)

//	If Len(aCols)>0
		@ 175, 200 BUTTON "Enderecos" ACTION u_CBDIA07k() SIZE 40,15 PIXEL OF oDlg1
		@ 175, 250 BUTTON "Perfil"    ACTION u_CBDIA03Man() SIZE 40,15 PIXEL OF oDlg1
//	EndIf

	ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| Iif(u_Mod2TudOk(),oDlg1:End(),nOpcA:=0)},{|| Iif(u_Mod2Canc(),oDlg1:End(),nOpcA:=0)})

EndIf

If nOpcA == 1

	//Grava e Fecha a tela de Contato X Entidade
	nUsado := 0
	For _nI := 1 to Len(aHeader2)
		nUsado++
	Next
	u_fTudOk()
	oDlg_a:End()

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07k  บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Contatos X Enderencos Entidades (tab. SZT)       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07k()

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil

Private _fPrgX := PROCNAME()
Private _cProg := PROCNAME()

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n        := oGet3:obrowse:nAt
aHeader3 := oget3:aHeader
aCols3   := oget3:acols

If Empty(aCols3)
	cMsg := "Nao sera permitido linhas sem o Codigo da Entidade."
	msgbox(cMsg)
	Return
ElseIf _fPrograma == "U_CBDIA07J"
	If Empty(aCols3)
		cMsg := "Nao sera permitido linhas sem o Codigo."
		msgbox(cMsg)
		Return
	Else
		nPos := 0
		nPos := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_CODENT"})

		If Empty(aCols3[n,nPos])
			cMsg := "Nao sera permitido linhas sem o Cod. Entidade."
			msgbox(cMsg)
			Return
		Endif
	EndIf
Else
	nPos := 0
	nPos := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_CODENT"})

	If !Empty(aCols3)
		If !aCols3[n][nUsado+1]
			If Empty(aCols3[n,nPos])
				cMsg := "Nao sera permitido linhas sem o Cod. Entidade."
				msgbox(cMsg)
				Return
			Endif

		Else
			cMsg := "Nao e possivel cadastrar Endereco pois Entidade esta deletada "
			msgbox(cMsg)
			aCols3[n][nUsado+1] := .F.
			Return		
		Endif
	EndIf
EndIf

Private cCodigo1
Private _cEntid

If  _fPrograma == "U_CBDIA07J"
	n        := oGet2:obrowse:nAt  // Posicao do Contato tela inicial
	_nPos2   := ascan( aHeader2,{ |x| x[2] = "AC8_CODCON"}) // CONTATOS
	cCodigo1 := aCols2[n,_nPos2]
	_nPos3   := ascan( aHeader2,{ |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
	_cNome   := aCols2[n,_nPos3]
Else
	n        := oGet:obrowse:nAt  // Posicao do Contato tela inicial
	_nPos2   := ascan( aHeader, { |x| x[2] = "U5_CODCONT"}) // CONTATOS
	cCodigo1 := aCols[n,_nPos2]
	_nPos3   := ascan( aHeader, { |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
	_cNome   := aCols[n,_nPos3]
EndIf

If _lINCLUI
//	cCodigo1 :=	cCodigo2
//	_cNome   :=	cNome2
	cCodigo1 :=	cCodigo
	_cNome   :=	cNome
EndIf

n1      := oGet3:obrowse:nAt // Posicao da Entidade na tela de Contatos X Entidade
_nPos   := ascan( aHeader3, { |x| x[2] = "ZQ_CODENT"})
_cEntid := aCols3[n1,_nPos]
_nPos1  := ascan( aHeader3, { |x| x[2] = "ZQ_NOME"})   // NOME DA ENTIDADE
_cDesc  := aCols3[n1,_nPos1]
//alteracao 06/09/06
_nPos2  := ascan( aHeader3, { |x| x[2] = "ZQ_GRUPO"})   // GRUPO
_cGrupo := aCols3[n1,_nPos2]

Private oGet4    := Nil
Private aHeader4 := {}
Private cCabec   := "aHeader4"
Private aCOLS4   := {}
Private nUsado   := 0

cCadastro := "Contato X End. Entidade"

dbSelectArea("SZT")
dbSetOrder(1) //Filial + Contatos + Entidade
dbSeek( xFilial("SZT") + cCodigo1 + _cEntid ,.t.)

While !EOF() .And. SZT->ZT_FILIAL + SZT->ZT_CODCONT + SZT->ZT_CODENT == xFilial("SZT") + cCodigo1 + _cEntid
	nCnt++
	dbSkip()
End

dbSelectArea("SX3")
dbSetOrder(2)

dbSeek("ZT_ITEM")
_fCabec(cCabec) // Cria aHeader com base no SX3
dbSeek("ZT_CODEND")
_fCabec(cCabec)
dbSeek("ZT_END")
_fCabec(cCabec)
dbSeek("ZT_ENDPAD")
_fCabec(cCabec)
dbSeek("ZT_BAIRRO")
_fCabec(cCabec)
dbSeek("ZT_MUN")
_fCabec(cCabec)
dbSeek("ZT_EST")
_fCabec(cCabec)
dbSeek("ZT_CEP")
_fCabec(cCabec)

dbSelectArea("SZT")
dbSetOrder(1) //Filial + Contatos + Entidade
dbSeek( xFilial("SZT") + cCodigo1 + _cEntid,.t.)

nCnt := 0

While !EOF() .And. SZT->ZT_FILIAL + SZT->ZT_CODCONT + SZT->ZT_CODENT == xFilial("SZT") + cCodigo1 + _cEntid

	AADD(aCols4,{SZT->ZT_ITEM, SZT->ZT_CODEND, SZT->ZT_END, ZT_ENDPAD,;
				SZT->ZT_BAIRRO,SZT->ZT_MUN,SZT->ZT_EST,SZT->ZT_CEP, .F.})
	
	dbSelectArea("SZT")
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg PIXEL

@ 24, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg
@ 24, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg

@ 23, 030 MSGET cCodigo1 When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 080 MSGET _cNome   When .F. SIZE 90,7 PIXEL OF oDlg

@ 24, 186 SAY "Entidade:" SIZE 70,7 PIXEL OF oDlg
@ 24, 250 SAY "Nome:"     SIZE 70,7 PIXEL OF oDlg

@ 23, 210 MSGET _cEntid When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 270 MSGET _cDesc  When .F. SIZE 90,7 PIXEL OF oDlg

aCampos := {}
AADD(aCampos,"ZT_CODEND")
AADD(aCampos,"ZT_ENDPAD")

If _fPrograma == "U_CBDIA07J"

	oGet4 := MsNewGetDados():New(41,2,160,372,,,,,aCampos,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aheader4,acols4)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

Else
	nGetd   := GD_INSERT+GD_UPDATE+GD_DELETE
	
	oGet4 := MsNewGetDados():New(41,2,160,372,nGetd,"u_TraLinOK()","u_TraTudOK()","+ZT_ITEM",aCampos,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aheader4,acols4)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_TraTudOK(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

EndIf

Return

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Contatos X Entidade X Perfil (Tratamento)        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA03Man()

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil

Private _fPrgX := PROCNAME()

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n        := oGet3:obrowse:nAt
aHeader3 := oget3:aHeader
aCols3   := oget3:acols

If Empty(aCols3)
	cMsg := "Nao sera permitido linhas sem o Codigo da Entidade."
	msgbox(cMsg)
	Return
ElseIf _fPrograma == "U_CBDIA07J"
	If Empty(aCols3)
		cMsg := "Nao sera permitido linhas sem o Codigo."
		msgbox(cMsg)
		Return
	Else
		nPos := 0
		nPos := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_CODENT"})

		nPos1 := 0
		nPos1 := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_GRUPO"})

		If Empty(aCols3[n,nPos])
			cMsg := "Nao sera permitido linhas sem o Cod. Entidade."
			msgbox(cMsg)
			Return
		Endif

		If Empty(aCols3[n,nPos1])
			cMsg := "Nao sera permitido linhas sem o Cod. Grupo."
			msgbox(cMsg)
			Return
		Endif
	EndIf
Else
	nPos := 0
	nPos := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_CODENT"})

	nPos1 := 0
	nPos1 := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_GRUPO"})

	If !Empty(aCols3)
		If !aCols3[n][nUsado+1]
			If Empty(aCols3[n,nPos])
				cMsg := "Nao sera permitido linhas sem o Cod. Entidade."
				msgbox(cMsg)
				Return
			Endif

			If Empty(aCols3[n,nPos1])
				cMsg := "Nao sera permitido linhas sem o Cod. Grupo."
				msgbox(cMsg)
				Return
			Endif
		Else
			cMsg := "Nao e possivel cadastrar Tratamento pois Entidade esta deletada "
			msgbox(cMsg)
			aCols3[n][nUsado+1] := .F.
			Return		
		Endif
	EndIf
EndIf

Private cCodigo1
Private _cEntid

If  _fPrograma == "U_CBDIA07J"
	n        := oGet2:obrowse:nAt  // Posicao do Contato tela inicial
	_nPos2   := ascan( aHeader2,{ |x| x[2] = "AC8_CODCON"}) // CONTATOS
	cCodigo1 := aCols2[n,_nPos2]
	_nPos3   := ascan( aHeader2,{ |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
	_cNome   := aCols2[n,_nPos3]
Else
	n        := oGet:obrowse:nAt  // Posicao do Contato tela inicial
	_nPos2   := ascan( aHeader, { |x| x[2] = "U5_CODCONT"}) // CONTATOS
	cCodigo1 := aCols[n,_nPos2]
	_nPos3   := ascan( aHeader, { |x| x[2] = "U5_CONTAT"})   // NOME DO CONTATOS
	_cNome   := aCols[n,_nPos3]
EndIf

If _lINCLUI
//	cCodigo1 :=	cCodigo2
//	_cNome   :=	cNome2
	cCodigo1 :=	cCodigo
	_cNome   :=	cNome
EndIf

n1      := oGet3:obrowse:nAt // Posicao da Entidade na tela de Contatos X Entidade
_nPos   := ascan( aHeader3, { |x| x[2] = "ZQ_CODENT"})
_cEntid := aCols3[n1,_nPos]
_nPos1  := ascan( aHeader3, { |x| x[2] = "ZQ_NOME"})   // NOME DA ENTIDADE
_cDesc  := aCols3[n1,_nPos1]
//alteracao 06/09/06
_nPos2  := ascan( aHeader3, { |x| x[2] = "ZQ_GRUPO"})   // GRUPO
_cGrupo := aCols3[n1,_nPos2]

Private oGet4    := Nil
Private aHeader4 := {}
Private cCabec   := "aHeader4"
Private aCOLS4   := {}
Private nUsado   := 0

cCadastro := "Perfil"

dbSelectArea("SZR")
dbSetOrder(2) //Filial + Contatos + Entidade + Grupo
dbSeek( xFilial("SZR") + cCodigo1 + _cEntid + _cGrupo,.t.)

While !EOF() .And. SZR->ZR_FILIAL + SZR->ZR_CODCONT + SZR->ZR_CODENT + SZR->ZR_GRUPO == xFilial("SZR") + cCodigo1 + _cEntid + _cGrupo
	nCnt++
	dbSkip()
End

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZR")
While !EOF() .And. X3_ARQUIVO == "SZR"
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		_fCabec(cCabec) // Cria aHeader com base no SX3
	Endif
	dbSkip()
End

dbSelectArea("SZR")
dbSetOrder(2) //Filial + Contatos + Entidade + Grupo
dbSeek( xFilial("SZR") + cCodigo1 + _cEntid + _cGrupo,.t.)

nCnt := 0

While !EOF() .And. SZR->ZR_FILIAL + SZR->ZR_CODCONT + SZR->ZR_CODENT + SZR->ZR_GRUPO == xFilial("SZR") + cCodigo1 + _cEntid + _cGrupo
	
	aAdd( aCOLS4, Array(Len(aHeader4)+1))
	
	nCnt++
	nUsado:=0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZR")
	While !EOF() .And. X3_ARQUIVO == "SZR"
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := "SZR"+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS4[nCnt][nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS4[nCnt][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS4[nCnt][nUsado+1] := .F.
	dbSelectArea("SZR")
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg PIXEL

@ 24, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg
@ 24, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg

@ 23, 030 MSGET cCodigo1 When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 080 MSGET _cNome   When .F. SIZE 90,7 PIXEL OF oDlg

@ 24, 186 SAY "Entidade:" SIZE 70,7 PIXEL OF oDlg
@ 24, 250 SAY "Nome:"     SIZE 70,7 PIXEL OF oDlg

@ 23, 210 MSGET _cEntid When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 270 MSGET _cDesc  When .F. SIZE 90,7 PIXEL OF oDlg


aCampos := {}
AADD(aCampos,"ZR_CARGO")
AADD(aCampos,"ZR_CODTRAT")
AADD(aCampos,"ZR_TRAT")

If _fPrograma == "U_CBDIA07J"

	oGet4 := MsNewGetDados():New(41,2,160,372,,,,,aCampos,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aheader4,acols4)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

Else
	nGetd   := GD_INSERT+GD_UPDATE+GD_DELETE
	
	oGet4 := MsNewGetDados():New(41,2,160,372,nGetd,"u_TraLinOK()","u_TraTudOK()","+ZR_ITEM",aCampos,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aheader4,acols4)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_TraTudOK(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

EndIf

If nOpcA == 1
	//Grava e Fecha a tela de Contato X Entidade
	If _fPrograma == "U_CBDIA07J"
		oDlg1:End()
	Else
		nUsado := 0
		_lSemErro := .T.
		For _nI := 1 to Len(aHeader3)
			nUsado++
		Next
		u_Mod2TudOk()
		If _lSemErro
			oDlg1:End()
		EndIf
	EndIf

	//Grava e Fecha a tela de Contato X Entidade
	nUsado := 0
	For _nI := 1 to Len(aHeader2)
		nUsado++
	Next
	u_fTudOk()
	oDlg_a:End()

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07d  บAutor  ณMicrosiga           บ Data ณ  08/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Inclusao do Novo Contato                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07d()

Private _lINCLUI := .F.
Private	cCodigo  := ""
Private	cNome    := ""

INCLUI := .T.
ALTERA := .F.

DbSelectArea("SU5")

_opcao := AxInclui("SU5",0,3,,,,)

If _opcao == 1 // botao <OK> da Tela de Inclusao
	_lINCLUI := .T.
	cCodigo  := SU5->U5_CODCONT
	cNome    := SU5->U5_CONTAT

	//Grava o Endereco do Contato na tabela de Enderecos Alternativos
	If !Empty(SU5->U5_END)
		DbSelectArea("SZS")
		DbSetOrder(1)
		RecLock("SZS",.T.)
		SZS->ZS_FILIAL  := xFilial("SZS")
		SZS->ZS_ITEM    := "0001"
		SZS->ZS_CODCONT := SU5->U5_CODCONT
		SZS->ZS_NOMCONT := SU5->U5_CONTAT
		SZS->ZS_CODENT  := ""
		SZS->ZS_NOMENT  := ""
		SZS->ZS_TIPO    := "F"
		SZS->ZS_ENDPAD  := "1"
		SZS->ZS_TIPOEND := SU5->U5_TIPOEND
		SZS->ZS_END     := SU5->U5_END
	 	SZS->ZS_BAIRRO  := SU5->U5_BAIRRO
	 	SZS->ZS_MUN     := SU5->U5_MUN
	 	SZS->ZS_EST     := SU5->U5_EST
	 	SZS->ZS_CEP     := SU5->U5_CEP
	 	SZS->ZS_CODPAIS := SU5->U5_CODPAIS
	 	SZS->ZS_DDD     := SU5->U5_DDD
	 	SZS->ZS_FONE    := SU5->U5_FONE
	 	SZS->ZS_FCOM1   := SU5->U5_FCOM1
	 	SZS->ZS_FAX     := SU5->U5_FAX
		MsUnlock()
	EndIf

/*
--------------------------------------------------------------------------------
                        T  E  S  T  E
*/
	DbSelectArea("TMP")
	DbCloseArea()

	aCOLS := {}

	// Filtra Cadastro de Contatos conforme parametros definido pelo usuario
		cQuery  := "SELECT * "
		cQuery  += " FROM "+RetSQLname('SU5') "
		cQuery  += " WHERE D_E_L_E_T_ <> '*' "
		cQuery  += " AND U5_CONTAT LIKE '%"+Alltrim(mv_par02)+"%' "
		cQuery  += " ORDER BY U5_CONTAT"
		TcQuery cQuery New Alias "TMP"

		dbSelectArea("TMP")

	While !EOF()

		dbSelectArea("SU5")
		dbSetOrder(1)
		dbSeek(xFilial("SU5")+TMP->U5_CODCONT)  // Codigo Contatos Filtrado na Consulta
	    _cCodGr   := SU5->U5_GRUPO // Grupo
	    _cCodCar  := SU5->U5_CARGO // Cargo
	    _cCodTrat := SU5->U5_NIVEL // Tratamento
	
		DbSelectArea("SQ0")
		dbSetOrder(1)
		dbSeek(xFilial("SQ0")+_cCodGr)
		_cDGRUPO := SQ0->Q0_DESCRIC // Grupo
	
		DbSelectArea("SUM")
		dbSetOrder(1)
		dbSeek(xFilial("SUM")+_cCodCar)
		_cDESC   := SUM->UM_DESC   // Cargo
	
		DbSelectArea("SZN")
		dbSetOrder(1)
		dbSeek(xFilial("SZN")+_cCodTrat)
		_cDNIVEL := SZN->ZN_DESCRI // Tratamento
	
		AADD( aCols,{TMP->U5_CODCONT,;
					  TMP->U5_CONTAT,;
					  _cDGRUPO,;
					  _cDESC  ,;
					  _cDNIVEL,;
					  .F.})
		dbSelectArea("TMP")
		dbSkip()
	End
	oGet:aCols := aCols

	u_CBDIA07c()   // Manutencao Contatos X Contatos BDI
/*
--------------------------------------------------------------------------------
                        T  E  S  T  E
*/

EndIf

Return(.t.)

/*
---------------------------------------------------------------------------------
------------------------- F I M   C O N T A T O S -------------------------------
---------------------------------------------------------------------------------
*/

/*
--------------------------------------------------------------------------------
---------------------------- E N T I D A D E -----------------------------------
--------------------------------------------------------------------------------
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07f  บAutor  ณMicrosiga           บ Data ณ  16/08/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ TELA INICIAL : CONSULTA ENTIDADES                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07f()

Local oDlg     := Nil

Private oGet     := Nil
Private aHeader  := {}
Private cCabec   := "aHeader"
Private aCOLS    := {}
Private _fPrg    := PROCNAME()

cCadastro := "Consulta Entidade"

//If nCont > 0
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZM_CODENT")
	_fCabec(cCabec) // Cria aHeader com base no SX3
	dbSeek("ZM_NOME")
	_fCabec(cCabec)
	dbSelectArea("TMP")
//EndIf

If nCont > 0
	While !EOF()
		AADD( aCOLS,{TMP->ZM_CODENT ,TMP->ZM_NOME,.F.})
		dbSelectArea("TMP")
		dbSkip()
	End
Else
	AADD( aCOLS,{"", "",.F.})
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

// Somente Visualizacao
oGet := MsNewGetDados():New(41,2,250,500,,,,,,,,,,,oDlg,aheader,acols)

// Se nao tiver nenhum registro nao mostra o botao
//If nCont > 0
// Cadastro de Endereco
	@ 270, 200 BUTTON "Enderecos"  ACTION u_CBDIA07a() SIZE 40,15 PIXEL OF oDlg
// Consulta Entidade X Contatos	
	@ 270, 250 BUTTON "Contato"    ACTION u_CBDIA07g() SIZE 40,15 PIXEL OF oDlg
//EndIf

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

DbSelectArea("TMP")
DbCloseArea()

u_CBDIA07()

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta Amarracao Entidade X Contatos                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07g()
Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n       :=oGet:obrowse:nAt
_nPos2  := ascan( aHeader, { |x| x[2] = "ZM_CODENT"}) // CONTATOS ENTIDADE
cCodigo := aCols[n,_nPos2]
_nPos3  := ascan( aHeader, { |x| x[2] = "ZM_NOME"})   // NOME DA ENTIDADE
cNome   := aCols[n,_nPos3]

Private oGet2   := Nil
Private aHeader := {}
Private cCabec  := "aHeader"
Private aCOLS   := {}
Private nUsado  := 0

cCadastro := "Manutencao Entidade X Contatos"

// Filtra Cadastro de Contatos por Entidade
cQuery  := "SELECT SU5.U5_CODCONT, SU5.U5_CONTAT "
cQuery  += " FROM "+RetSQLname('SZQ')+" SZQ, "+RetSQLname('SU5')+" SU5 "
cQuery  += " WHERE SZQ.D_E_L_E_T_ <> '*' AND SU5.D_E_L_E_T_ <> '*' "
cQuery  += " AND SZQ.ZQ_CODCONT = SU5.U5_CODCONT "
cQuery  += " AND ZQ_CODENT = '"+cCodigo+"' "
cQuery  += " GROUP BY SU5.U5_CODCONT, SU5.U5_CONTAT "
cQuery  += " ORDER BY SU5.U5_CONTAT"
TcQuery cQuery New Alias "TMP1"

dbSelectArea("TMP1")
dbGotop()

nCont := 0
Do While !Eof()
	nCont++
	TMP1->(DbSkip())
EndDo

dbSelectArea("TMP1")
dbGotop()

//Se nao encontrar nenhum registro nao mostra a tela
//If nCont > 0
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("U5_CODCONT")
	_fCabec(cCabec) // Cria aHeader com base no SX3
	dbSeek("U5_CONTAT")
	_fCabec(cCabec)
//EndIf
                   
dbSelectArea("TMP1")

If nCont > 0
	While !EOF()
		AADD( aCOLS,{TMP1->U5_CODCONT ,TMP1->U5_CONTAT,.F.})
		dbSelectArea("TMP1")
		dbSkip()
	End
Else
	AADD( aCOLS,{"" ,"",.F.})
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg PIXEL

@ 24, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg
@ 24, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg

@ 23, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oDlg

// Somente visualizacao
oGet2 := MsNewGetDados():New(41,2,160,372,,,,,,,,,,,oDlg,aheader,acols)

// Se nao tiver registro nao mostra o botao
//If Len(aCols)>0
// Tela de Perfil
	@ 175, 200 BUTTON "Enderecos" ACTION u_CBDIA07m() SIZE 40,15 PIXEL OF oDlg
	@ 175, 250 BUTTON "Perfil" ACTION u_CBDIA07h() SIZE 40,15 PIXEL OF oDlg
//EndIf

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

DbSelectArea("TMP1")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07m  บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Contatos X End. Entidade                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07m()

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n        := oGet2:obrowse:nAt
aCols    := oGet2:acols
_nPos2   := ascan( aHeader, { |x| x[2] = "U5_CODCONT"})
cCodigo1 := aCols[n,_nPos2]
_nPos3   := ascan( aHeader, { |x| x[2] = "U5_CONTAT"})
_cNome   := aCols[n,_nPos3]

n1       := oGet:obrowse:nAt
aHeader2 := oGet:aHeader
aCols2   := oGet:acols
_nPos    := ascan( aHeader2, { |x| x[2] = "ZM_CODENT"})
_cEntid  := aCols2[n1,_nPos]
_nPos1   := ascan( aHeader2, { |x| x[2] = "ZM_NOME"})   // NOME DA ENTIDADE
_cDesc   := aCols2[n1,_nPos1]

Private oGet3    := Nil
Private aHeader2 := {}
Private cCabec   := "aHeader2"
Private aCOLS2   := {}
Private nUsado   := 0

dbSelectArea("SZT")
dbSetOrder(3) //Filial + Entidade + Contatos
dbSeek( xFilial("SZT") +_cEntid + cCodigo1 ,.t.)

While !EOF() .And. SZT->ZT_FILIAL + SZT->ZT_CODENT + SZT->ZT_CODCONT  == xFilial("SZT") + _cEntid +cCodigo
	nCnt++
	dbSkip()
End

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("ZT_ITEM")
_fCabec(cCabec) // Cria aHeader com base no SX3
dbSeek("ZT_CODEND")
_fCabec(cCabec)
dbSeek("ZT_END")
_fCabec(cCabec)
dbSeek("ZT_ENDPAD")
_fCabec(cCabec)

dbSelectArea("SZT")
dbSetOrder(3) //Filial + Entidade + Contatos
dbSeek( xFilial("SZT") +_cEntid + cCodigo1 ,.t.)

nCnt := 0

While !EOF() .And. SZT->ZT_FILIAL + SZT->ZT_CODENT + SZT->ZT_CODCONT  == xFilial("SZT") + _cEntid +cCodigo1

	AADD(aCols2,{SZT->ZT_ITEM, SZT->ZT_CODEND, SZT->ZT_END, ZT_ENDPAD, .F.})
	
	dbSelectArea("SZT")
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg PIXEL

@ 24, 006 SAY "Entidade:" SIZE 70,7 PIXEL OF oDlg
@ 24, 062 SAY "Nome:"     SIZE 70,7 PIXEL OF oDlg

@ 23, 030 MSGET _cEntid When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 080 MSGET _cDesc  When .F. SIZE 90,7 PIXEL OF oDlg

@ 24, 186 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg
@ 24, 250 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg

@ 23, 210 MSGET cCodigo1 When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 270 MSGET _cNome   When .F. SIZE 90,7 PIXEL OF oDlg


aCampos := {}
AADD(aCampos,"ZT_CODEND")
AADD(aCampos,"ZT_ENDPAD")

oGet3 := MsNewGetDados():New(41,2,160,372,,,,,aCampos,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aheader2,acols2)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

Return

/*
-----------------------------------------------------------------------------
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Contatos X Entidade x Perfil (Tratamento)        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07h()

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n        := oGet2:obrowse:nAt
aCols    := oGet2:acols
_nPos2   := ascan( aHeader, { |x| x[2] = "U5_CODCONT"})
cCodigo1 := aCols[n,_nPos2]
_nPos3   := ascan( aHeader, { |x| x[2] = "U5_CONTAT"})
_cNome   := aCols[n,_nPos3]

n1       := oGet:obrowse:nAt
aHeader2 := oGet:aHeader
aCols2   := oGet:acols
_nPos    := ascan( aHeader2, { |x| x[2] = "ZM_CODENT"})
_cEntid  := aCols2[n1,_nPos]
_nPos1   := ascan( aHeader2, { |x| x[2] = "ZM_NOME"})   // NOME DA ENTIDADE
_cDesc   := aCols2[n1,_nPos1]

Private oGet3    := Nil
Private aHeader2 := {}
Private cCabec   := "aHeader2"
Private aCOLS2   := {}
Private nUsado   := 0

dbSelectArea("SZR")
dbSetOrder(2) //Filial + Contatos + Entidade
dbSeek( xFilial("SZR") + cCodigo1 + _cEntid ,.t.)

While !EOF() .And. SZR->ZR_FILIAL + SZR->ZR_CODCONT + SZR->ZR_CODENT == xFilial("SZR") + cCodigo1 + _cEntid 
	nCnt++
	dbSkip()
End

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZR")
While !EOF() .And. X3_ARQUIVO == "SZR"
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		_fCabec(cCabec) // Cria aHeader com base no SX3
	Endif
	dbSkip()
End

dbSelectArea("SZR")
dbSetOrder(2) //Filial + Contatos + Entidade + Grupo
dbSeek( xFilial("SZR") + cCodigo1 + _cEntid ,.t.)

nCnt := 0

While !EOF() .And. SZR->ZR_FILIAL + SZR->ZR_CODCONT + SZR->ZR_CODENT == xFilial("SZR") + cCodigo1 + _cEntid 
	
	aAdd( aCOLS2, Array(Len(aHeader2)+1))
	
	nCnt++
	nUsado:=0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZR")
	While !EOF() .And. X3_ARQUIVO == "SZR"
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := "SZR"+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS2[nCnt][nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS2[nCnt][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS2[nCnt][nUsado+1] := .F.
	dbSelectArea("SZR")
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE "Perfil" From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg PIXEL

@ 24, 006 SAY "Entidade:"  SIZE 70,7 PIXEL OF oDlg
@ 24, 062 SAY "Nome:"      SIZE 70,7 PIXEL OF oDlg

@ 23, 030 MSGET _cEntid When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 080 MSGET _cDesc  When .F. SIZE 78,7 PIXEL OF oDlg

@ 24, 190 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg
@ 24, 250 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg

@ 23, 210 MSGET cCodigo1 When .F. SIZE 30,7 PIXEL OF oDlg
@ 23, 270 MSGET _cNome   When .F. SIZE 78,7 PIXEL OF oDlg

// Somente Visualizacao
oGet3 := MsNewGetDados():New(41,2,160,372,,,,,,,,,,,oDlg,aheader2,acols2)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

Return

/*
-----------------------------------------------------------------------------------
--------------------------- F I M   E N T I D A D E -------------------------------
-----------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------
---------------------------   C O N T A T O S   B D I  ----------------------------
-----------------------------------------------------------------------------------
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07i  บAutor  ณMicrosiga           บ Data ณ  08/16/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07i()

Local oDlg     := Nil

Private oGet     := Nil
Private aHeader  := {}
Private cCabec   := "aHeader"
Private aCOLS    := {}
Private _lINCLUI := .F.
Private _fPrg    := PROCNAME()

cCadastro := "Consulta Contatos BDI"

//Se nao encontrar nenhum registro nao mostra a tela
//If nCont > 0
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("A2_COD")   // Codigo Contatos BDI
	_fCabec(cCabec) // Cria o aHeader com os campos do SX3
	dbSeek("A2_NOME")  // Nome Contatos BDI
	_fCabec(cCabec)
//EndIf
                   
dbSelectArea("TMP")
If nCont > 0
	While !EOF()
		AADD( aCOLS,{TMP->A2_COD, TMP->A2_NOME, .F.})
		dbSelectArea("TMP")
		dbSkip()
	End
Else
	AADD( aCOLS,{"", "", .F.})
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

oGet := MsNewGetDados():New(41,2,250,500,,,,,,,,,,,oDlg,aheader,acols)

//If nCont > 0
	@ 270, 250 BUTTON "Contato"    ACTION u_CBDIA07j() SIZE 40,15 PIXEL OF oDlg
//EndIf

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

DbSelectArea("TMP")
DbCloseArea()

u_CBDIA07()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07j  บAutor  ณMicrosiga           บ Data ณ  08/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Amarracao Contatos BDI X Contatos (SA2 X AC8)              บฑฑ
ฑฑบ          ณ tela de manutencao do cadastro de amarracao                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA07j()

Local nCnt     := 0
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg2    := Nil

Private oGet2      := Nil
Private _fPrograma := PROCNAME()

If empty(acols[1,1])
	MsgBox("Sem Registro")
	Return()
EndIf

n:=oGet:obrowse:nAt

_nPos2  := ascan( aHeader, { |x| x[2] = "A2_COD"}) // CONTATOS BDI
cCodigo := aCols[n,_nPos2]
_nPos3  := ascan( aHeader, { |x| x[2] = "A2_NOME"})   // NOME DO CONTATOS BDI
cNome   := aCols[n,_nPos3]

Private lRet     := .T.
Private nUsado   := 0
Private aHeader2 := {}
Private cCabec   := "aHeader2"
Private aCOLS2   := {}

cCadastro := "Manutencao Contatos BDI X Contatos"

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("AC8_CODCON")
_fCabec(cCabec) // Cria aHeader com base no SX3
dbSeek("U5_CONTAT")
_fCabec(cCabec)

dbSelectArea("AC8")
dbSetOrder(2) // FILIAL + ENTIDADE + FILENT + CODENT(SA2)
dbSeek( xFilial("AC8") +"SA2"+"  "+ cCodigo ,.t. )
                                   
While !EOF() .And. AC8->AC8_FILIAL + AC8->AC8_COD == xFilial("SA2") + cCodigo

	dbSelectArea("SU5")
	DbSetOrder(1)
	_cNomCont := ""
	If DbSeek(xFilial("SU5")+AC8->AC8_CODCON)
		_cNomCont := SU5->U5_CONTAT
	EndIf
	aAdd( aCOLS2,{AC8->AC8_CODCON,_cNomCont,.F.})
	dbSelectArea("AC8")
	dbSkip()
End

DEFINE MSDIALOG oDlg2 TITLE cCadastro From 8,0 To 34,97 OF oMainWnd

@ 15, 2 TO 42,373 LABEL "" OF oDlg2 PIXEL

@ 24, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oDlg2
@ 24, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oDlg2

@ 23, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oDlg2
@ 23, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oDlg2

oget2   := MsNewGetDados():New(41,2,160,372,,,,,/*aCampos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg2,aheader2,acols2)

@ 175, 200 BUTTON "Enderecos" ACTION u_CBDIA07a() SIZE 40,15 PIXEL OF oDlg2
@ 175, 250 BUTTON "Entidade"  ACTION u_CBDIA03Alt() SIZE 40,15 PIXEL OF oDlg2

ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||oDlg2:End()},{||oDlg2:End()})

Return

/*
-----------------------------------------------------------------------------------
-------------------   F I M   C O N T A T O S   B D I  ----------------------------
-----------------------------------------------------------------------------------
*/

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

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,6)

/*
             grupo ,ordem,pergunt        ,perg spa       ,perg eng        , variav ,tipo ,tam,dec,pres,gsc,valid,var01     ,def01    ,defspa01 ,defeng01 ,cnt01,var02,def02      ,defspa02  ,defeng02  ,cnt02,var03,def03        ,defspa03     ,defeng03     ,cnt03 ,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Tipo Consulta","Tipo Consulta","Tipo Consulta ","mv_ch1","C" ,01 ,00 ,0  ,"C",""   ,"mv_par01","Contato","Contato","Contato",""   ,""   ,"Entidade","Entidade","Entidade",""   ,""   ,"Contato BDI","Contato BDI","Contato BDI",""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Nome         ","Nome         ","Nome          ","mv_ch2","C" ,50 ,00 ,0  ,"G",""   ,"mv_par02",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","","@!"})

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

pergunte(cperg,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  08/23/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria aHeader com base no SX3                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCabec(cCabec)

// Cria aHeader com base no SX3
AADD(&cCabec,{ TRIM(X3Titulo()) ,;
				X3_CAMPO         ,;
				X3_PICTURE       ,;
				X3_TAMANHO       ,;
				X3_DECIMAL       ,;
				X3_VALID         ,;
				X3_USADO         ,;
				X3_TIPO          ,;
				X3_F3            ,;
				X3_CONTEXT       ,;
				X3_CBOX			 ,;
				X3_RELACAO       ,;
				X3_WHEN          ,;
				X3_VISUAL        ,;
				X3_VLDUSER       ,;
				X3_PICTVAR       ,;
				X3_OBRIGAT       })
Return

/*
-----------------------------------------------------------------------------
                 FUNCOES DE GRAVACOES E VALIDACOES DE LINHA/TUDO
-----------------------------------------------------------------------------
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validacao da Linha no modelo 2                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fLinOk()

Local nY := 0
Local nI := 0
Local cMsg := ""

Private lRet     := .T.

n        := oGet2:obrowse:nAt
aHeader2 := oget2:aHeader
aCols2   := oget2:acols

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.

nPos := 0
nPos := aScan(aHeader2,{|x|AllTrim(Upper(x[2]))=="AC8_COD"})

If !aCols2[n][nUsado+1]
	If Empty(aCols2[n,nPos])
		cMsg := "Nao sera permitido linhas sem o Codigo."
		msgbox(cMsg)
		lRet := .F.
	Endif
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar a confirmacao do Modelo 2              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fTudOk()

Private lRet     := .T.

lRet := u_fLinOk()

If lRet
	Begin Transaction
	Grava()
	End Transaction
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/14/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fCanc()

Private lRet     := .F.

npos:=oget2:obrowse:nat
aTeste:= oget2:acols

DBSELECTAREA("AC8")
DBSETORDER(3)
If DBSEEK(XFILIAL("AC8")+CCODIGO) .and. !aTeste[npos,4]
	lRet := .T.
Else
	lRet := .F.
	cMsg := "Nao e permitido Deletar e Cancelar ao mesmo tempo!!!"
	msgbox(cMsg)
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validacao da Linha no modelo 2                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Mod2LinOk()

Local nY := 0
Local nI := 0
Local cMsg := ""

Private lRet     := .T.

n        := oGet3:obrowse:nAt
aHeader3 := oget3:aHeader
aCols3   := oget3:acols

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.

nPos := 0
nPos := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_CODENT"})

nPos1 := 0
nPos1 := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_GRUPO"})

If !Empty(aCols3)
	If !aCols3[n][nUsado+1]
		If Empty(aCols3[n,nPos])
			cMsg := "Nao sera permitido linhas sem o Cod. Entidade."
			msgbox(cMsg)
			lRet := .F.
		Endif

		If Empty(aCols3[n,nPos1])
			cMsg := "Nao sera permitido linhas sem o Cod. Grupo."
			msgbox(cMsg)
			lRet := .F.
		Endif


	Endif
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar a confirmacao do Modelo 2              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Mod2TudOk()

Private lRet     := .T.

lRet := u_Mod2LinOk()

If lRet
	Begin Transaction
	Mod2Grava("SZQ")
	End Transaction
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  08/31/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao no Cancelamento da Tela de Contatos X Entidade   บฑฑ
ฑฑบ          ณ Nao deixa cancelar itens que possuem amarracao e ainda nao บฑฑ
ฑฑบ          ณ foram cadastrados na tabela                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Mod2Canc()

Local lRet := .T.
Local nI 	:= 0
Local nY 	:= 0
Local cVar 	:= ""
Local lOk 	:= .F.
Local nDel 	:= 0
Local cMsg 	:= ""
                 
n        := oGet3:obrowse:nAt
aHeader3 := oget3:aHeader
aCols3   := oget3:acols

dbSelectArea("SZQ")
dbSetOrder(1)

nPos := 0
nPos := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_ITEM"})

For nI := 1 To Len(aCols3)
	If dbSeek( xFilial("SZQ") + aCols3[nI,nPos] + cCodigo)
		_lFound := .T.
	Else
		_lFound := .F.
	EndIf
	If !_lFound
		//Fazer pesquisa para saber se o item poderar ser deletado e
		dbSelectArea("SZR")
		dbSetOrder(2) //Filial + Contatos + Entidade + Grupo
		If dbSeek( xFilial("SZR") + cCodigo + aCols3[nI,2]+ aCols3[nI,4] ,.t.)
			lOk := .T.
		EndIf
		If lOk
			cMsg := "O item "+aCols3[nI,1]+", possui amarracao"
			msgbox(cMsg)
			lRet := .F.
			Return(lRet)
		Endif
	EndIf

Next nI

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validacao da Linha no modelo 2                 บฑฑ
ฑฑบ          ณ TRATAMENTO                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TraLinOK()

Local nY := 0
Local nI := 0
Local cMsg := ""

Private  lRet := .T.

n        := oGet4:obrowse:nAt
aHeader4 := oGet4:aHeader
aCols4   := oGet4:acols

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.

If _fPrgX == "U_CBDIA03MAN"
	nPos   := 0
	nPos   := aScan(aHeader4,{|x|AllTrim(Upper(x[2]))=="ZR_CODTRAT"})
	nPos1  := 0
	nPos1  := aScan(aHeader4,{|x|AllTrim(Upper(x[2]))=="ZR_CARGO"})
	cMsg1   := "Nao sera permitido linhas sem o Tratamento."
	cMsg2   := "Nao sera permitido linhas sem o Cargo."
Else
	nPos   := 0
	nPos   := aScan(aHeader4,{|x|AllTrim(Upper(x[2]))=="ZT_CODEND"})
	nUsado := 8
	cMsg1  := "Nao sera permitido linhas sem o Cod de Endereco."
EndIf

If !Empty(aCols4)
	If !aCols4[n][nUsado+1]
		If Empty(aCols4[n,nPos])
			msgbox(cMsg1)
			lRet := .F.
		Endif
		If _fPrgX == "U_CBDIA03MAN"
			If Empty(aCols4[n,nPos1])
				msgbox(cMsg2)
				lRet := .F.
			Endif
		EndIf
	Endif
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar a confirmacao do Modelo 2              บฑฑ
ฑฑบ          ณ TRATAMENTO                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TraTudOK()

Private  lRet := .T.

lRet := u_TraLinOK()

If lRet
	Begin Transaction
	If _fPrgX == "U_CBDIA03MAN"
		Mod2GrvTr("SZR")
	Else
		Mod2GrvEnd("SZT")
	EndIf
	End Transaction
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validacao da Linha no modelo 2                 บฑฑ
ฑฑบ          ณ ENDERECO                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EndLinOK()

Local nY := 0
Local nI := 0
Local cMsg := ""

Private  lRet := .T.

n        := oGet2:obrowse:nAt
aHeader2 := oGet2:aHeader
aCols2   := oGet2:acols

nPos := 0
nPos := aScan(aHeader2,{|x|AllTrim(Upper(x[2]))=="ZS_END"})

If !Empty(aCols2)
	If !aCols2[n][5]
		If Empty(aCols2[n,nPos])
			cMsg := "Nao sera permitido linhas sem o Endereco."
			msgbox(cMsg)
			lRet := .F.
		Endif
	Endif
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar a confirmacao do Modelo 2              บฑฑ
ฑฑบ          ณ ENDERECOS                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EndTudOK()

Private  lRet := .T.

lRet := u_EndLinOK()

If lRet
	Begin Transaction
	EndGrv("SZS")
	End Transaction
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validacao da Linha no modelo 2                 บฑฑ
ฑฑบ          ณ CATEGORIA                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CatLinOK()

Local nY := 0
Local nI := 0
Local cMsg := ""

Private  lRet := .T.

n        := oGet2:obrowse:nAt
aHeader2 := oGet2:aHeader
aCols2   := oGet2:acols

nPos := 0
nPos := aScan(aHeader2,{|x|AllTrim(Upper(x[2]))=="ZY_COD"})

If !Empty(aCols2)
	If Empty(aCols2[n,nPos])
		cMsg := "Nao sera permitido linhas sem o Codigo."
		msgbox(cMsg)
		lRet := .F.
	Endif
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar a confirmacao do Modelo 2              บฑฑ
ฑฑบ          ณ CATEGORIAS                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CatTudOK()

Private  lRet := .T.

lRet := u_CatLinOK()

If lRet
	Begin Transaction
	CatGrv("SZY")
	End Transaction
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para gravacao dos Registros na relacao              บฑฑ
ฑฑบ          ณ CONTATOS X ENTIDADE                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mod2Grava()

Local nI 	:= 0
Local nY 	:= 0
Local cVar 	:= ""
Local lOk 	:= .T.
Local nDel 	:= 0
Local cMsg 	:= ""

dbSelectArea("SZQ")
dbSetOrder(1)

nPos := 0
nPos := aScan(aHeader3,{|x|AllTrim(Upper(x[2]))=="ZQ_ITEM"})

For nI := 1 To Len(aCols3)
	If dbSeek( xFilial("SZQ") + aCols3[nI,nPos] + cCodigo)
		_lFound := .T.
	Else
		_lFound := .F.
	EndIf
	
	If !aCols3[nI][nUsado+1]
		dbSelectArea("SZR")
		dbSetOrder(2) //Filial + Contatos + Entidade + Grupo
		If !dbSeek( xFilial("SZR") + cCodigo + aCols3[nI,2]+ aCols3[nI,4] ,.t.)
			cMsg := "Para a Entidade "+aCols3[nI,2]+", cadastrar Perfil"
			msgbox(cMsg)
			lRet := .F.
			_lSemErro := .F.
			Return(lRet)
		EndIf
		If _lFound
			RecLock("SZQ",.F.)
		Else
			RecLock("SZQ",.T.)
		Endif
		
		SZQ->ZQ_FILIAL  := xFilial("SZQ")
		SZQ->ZQ_CODCONT := cCodigo
		SZQ->ZQ_NOME    := cNome
		
		For nY = 1 to Len(aHeader3)
			If aHeader3[nY][10] # "V"
				cVar := Trim(aHeader3[nY][2])
				Replace &cVar. With aCols3[nI][nY]
			Endif
		Next nY
		MsUnLock("SZQ")
	Else
		//Fazer pesquisa para saber se o item poderar ser deletado e
		dbSelectArea("SZR")
		dbSetOrder(2) //Filial + Contatos + Entidade + Grupo
		If dbSeek( xFilial("SZR") + cCodigo + aCols3[nI,2]+ aCols3[nI,4] ,.t.)
			lOk := .F.
		EndIf
		If _lFound
			If lOk
				RecLock("SZQ",.F.)
				dbDelete()
				MsUnLock("SZQ")
				nDel ++
			Else
				cMsg := "Nao foi possivel deletar o item "+aCols3[nI,1]+", o mesmo possui amarracao"
				msgbox(cMsg)
				lRet := .F.
				Return(lRet)
			Endif
		Else
			If !lOk
				cMsg := "Nao foi possivel deletar o item "+aCols3[nI,1]+", o mesmo possui amarracao"
				msgbox(cMsg)
				lRet := .F.
				Return(lRet)
			EndIf
		EndIf
//------------------------------------------------------------------------------------------------------
		//Fazer pesquisa para saber se o item poderar ser deletado e
		dbSelectArea("SZT")
		dbSetOrder(1) //Filial + Contatos + Entidade
		If dbSeek( xFilial("SZT") + cCodigo + aCols3[nI,2],.t.)
			lOk := .F.
		EndIf
		If _lFound
			If lOk
				RecLock("SZQ",.F.)
				dbDelete()
				MsUnLock("SZQ")
				nDel ++
			Else
				cMsg := "Nao foi possivel deletar o item "+aCols3[nI,1]+", o mesmo possui amarracao"
				msgbox(cMsg)
				lRet := .F.
				Return(lRet)
			Endif
		Else
			If !lOk
				cMsg := "Nao foi possivel deletar o item "+aCols3[nI,1]+", o mesmo possui amarracao"
				msgbox(cMsg)
				lRet := .F.
				Return(lRet)
			EndIf
		EndIf
//------------------------------------------------------------------------------------------------------

	Endif
Next nI

If nDel > 0
	aArea := GetArea()
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("SZQ")
	RecLock("SX2",.F.)
	SX2->X2_DELET += nDel
	MsUnLock("SX2")
	RestArea( aArea )
Endif

//Verifica itens para Gravar Enderecos
DbSelectArea("SZS")
DbSetOrder(3) //FILIAL + ENTIDADE
For nI := 1 To Len(aCols3)
	If dbSeek( xFilial("SZS") + aCols3[nI,2]) 
		_lFound := .T.
	Else
		_lFound := .F.
	EndIf
	
	If !_lFound
		If !aCols3[nI][nUsado+1]
			RecLock("SZS",.T.)
			SZS->ZS_FILIAL  := xFilial("SZQ")
			SZS->ZS_CODCONT := "" //cCodigo
			SZS->ZS_ITEM    := "0001"
			SZS->ZS_CODENT  := aCols3[nI,2]
			SZS->ZS_TIPO    := "J"
			DbSelectArea("SZM")
			DbSetOrder(2)
			If DbSeek(xFilial("SZM")+aCols3[nI,2])
				_cNomEnti := SZM->ZM_NOME
				_cEnd     := SZM->ZM_END
				_cTpEnd   := SZM->ZM_TIPOEND
				_cEndPad  := SZM->ZM_ENDPAD
			 	_cBairro  := SZM->ZM_BAIRRO
			 	_cMun     := SZM->ZM_MUN
		 		_cEst     := SZM->ZM_EST
			 	_cCEP     := SZM->ZM_CEP
			 	_cCodPais := SZM->ZM_CODPAIS
			 	_cDDD     := SZM->ZM_DDD
		 		_cFone    := SZM->ZM_FONE
			 	_cFCom1   := SZM->ZM_FCOM1
			 	_cFAX     := SZM->ZM_FAX
			Else
				_cNomEnti := ""
				_cEnd     := ""
				_cTpEnd   := ""
				_cEndPad  := ""
			 	_cBairro  := ""
			 	_cMun     := ""
		 		_cEst     := ""
			 	_cCEP     := ""
			 	_cCodPais := ""
			 	_cDDD     := ""
		 		_cFone    := ""
			 	_cFCom1   := ""
			 	_cFAX     := ""
			EndIf
			SZS->ZS_NOMENT  := _cNomEnti
			SZS->ZS_END     := _cEnd
			SZS->ZS_ENDPAD  := "2"
			SZS->ZS_TIPOEND := _cTpEnd
		 	SZS->ZS_BAIRRO  := _cBairro
		 	SZS->ZS_MUN     := _cMun
		 	SZS->ZS_EST     := _cEst
		 	SZS->ZS_CEP     := _cCEP
		 	SZS->ZS_CODPAIS := _cCodPais
		 	SZS->ZS_DDD     := _cDDD
		 	SZS->ZS_FONE    := _cFone
		 	SZS->ZS_FCOM1   := _cFCom1
		 	SZS->ZS_FAX     := _cFAX
			MsUnLock("SZQ")
		EndIf
	Endif
Next nI

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para gravacao dos Registros no Tratamento           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mod2GrvTr()

Local nI 	:= 0
Local nY 	:= 0
Local cVar 	:= ""
Local lOk 	:= .T.
Local nDel 	:= 0
Local cMsg 	:= ""


dbSelectArea("SZR")
dbSetOrder(1)

nPos := 0
nPos := aScan(aHeader4,{|x|AllTrim(Upper(x[2]))=="ZR_ITEM"})

For nI := 1 To Len(aCols4)
	dbSeek( xFilial("SZR") + aCols4[nI,nPos] + cCodigo + _cEntid + _cGrupo)
	
	If !aCols4[nI][nUsado+1]
		If Found()
			RecLock("SZR",.F.)
		Else
			RecLock("SZR",.T.)
		Endif
		
		SZR->ZR_FILIAL  := xFilial("SZR")
		SZR->ZR_ITEM    := aCols4[nI,nPos]
		SZR->ZR_CODCONT := cCodigo
		SZR->ZR_CODENT  := _cEntid
		
		For nY = 1 to Len(aHeader4)
			If aHeader4[nY][10] # "V"
				cVar := Trim(aHeader4[nY][2])
				Replace &cVar. With aCols4[nI][nY]
			Endif
		Next nY

		SZR->ZR_GRUPO   := _cGrupo

		MsUnLock("SZR")
	Else
		If !Found()
			Loop
		Endif
		//Fazer pesquisa para saber se o item poderar ser deletado e
		If lOk
			RecLock("SZR",.F.)
			dbDelete()
			MsUnLock("SZR")
			nDel ++
		Else
			cMsg := "Nao foi possivel deletar o item "+aCols4[nI,1]+", o mesmo possui amarracao"
			msgbox(cMsg)
			lRet := .F.
			Return(lRet)
			
		Endif
	Endif
Next nI

If nDel > 0
	aArea := GetArea()
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("SZR")
	RecLock("SX2",.F.)
	SX2->X2_DELET += nDel
	MsUnLock("SX2")
	RestArea( aArea )
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  Mod2GrvEnd บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para gravacao das Amarracao Contatos X End. Entidadeบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mod2GrvEnd()

Local nI 	:= 0
Local nY 	:= 0
Local cVar 	:= ""
Local lOk 	:= .T.
Local nDel 	:= 0
Local cMsg 	:= ""

dbSelectArea("SZT")
dbSetOrder(2)

nPos := 0
nPos := aScan(aHeader4,{|x|AllTrim(Upper(x[2]))=="ZT_ITEM"})

For nI := 1 To Len(aCols4)
	dbSeek( xFilial("SZT") + aCols4[nI,nPos] + cCodigo + _cEntid )
	
	If !aCols4[nI][nUsado+1]
		If Found()
			RecLock("SZT",.F.)
		Else
			RecLock("SZT",.T.)
		Endif
		
		SZT->ZT_FILIAL  := xFilial("SZT")
		SZT->ZT_ITEM    := aCols4[nI,nPos]
		SZT->ZT_CODCONT := cCodigo
		SZT->ZT_CODENT  := _cEntid
		
		For nY = 1 to Len(aHeader4)
			If aHeader4[nY][10] # "V"
				cVar := Trim(aHeader4[nY][2])
				Replace &cVar. With aCols4[nI][nY]
			Endif
		Next nY

		MsUnLock("SZR")
	Else
		If !Found()
			Loop
		Endif
		//Fazer pesquisa para saber se o item poderar ser deletado e
		If lOk
			RecLock("SZT",.F.)
			dbDelete()
			MsUnLock("SZT")
			nDel ++
		Else
			cMsg := "Nao foi possivel deletar o item "+aCols4[nI,1]+", o mesmo possui amarracao"
			msgbox(cMsg)
			lRet := .F.
			Return(lRet)
		Endif
	Endif
Next nI

If nDel > 0
	aArea := GetArea()
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("SZR")
	RecLock("SX2",.F.)
	SX2->X2_DELET += nDel
	MsUnLock("SX2")
	RestArea( aArea )
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrava     บAutor  ณMicrosiga           บ Data ณ  08/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Grava()

Local nI 	:= 0
Local nY 	:= 0
Local cVar 	:= ""
Local lOk 	:= .T.
Local nDel 	:= 0
Local cMsg 	:= ""

dbSelectArea("AC8")
dbSetOrder(3)

_nCountDel := 0
For nI := 1 To Len(aCols2)
	If aCols2[nI][nUsado+1]
		_nCountDel++
	EndIf
Next

If _nCountDel  <> Len(aCols2)
	For nI := 1 To Len(aCols2)
		dbSeek( xFilial("AC8") + cCodigo + aCols2[nI,1])

		If !aCols2[nI][nUsado+1]
			If Found()
				RecLock("AC8",.F.)
			Else
				RecLock("AC8",.T.)
			Endif

			AC8->AC8_FILIAL := xFilial("AC8")
			AC8->AC8_FILENT := xFilial("AC8")
			AC8->AC8_ENTIDA := "SA2"
			AC8->AC8_CODCON := cCodigo
			AC8->AC8_CODENT := aCols2[nI,2]+"01"
			AC8->AC8_LOJA   := "01"

			For nY := 1 to Len(aHeader2)
				If aHeader2[nY][10] # "V"
					cVar := Trim(aHeader2[nY][2])
					Replace &cVar. With aCols2[nI][nY]
				Endif
			Next nY
			MsUnLock("AC8")
		Else
			If !Found()
				Loop
			Endif
			//Fazer pesquisa para saber se o item poderar ser deletado e
			If lOk
				RecLock("AC8",.F.)
				dbDelete()
				MsUnLock("AC8")
				nDel ++
			Else
				cMsg := "Nao foi possivel deletar o item "+aCols2[nI,1]+", o mesmo possui amarracao"
				msgbox(cMsg)
				lRet := .F.
				Return(lRet)
			Endif
		Endif
	Next nI
Else
	cMsg := "Nao e possivel deixar Contato sem vinculo com Contato BDI "
	msgbox(cMsg)
	lRet := .F.
	Return(lRet)
EndIf

If nDel > 0
	aArea := GetArea()
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("AC8")
	RecLock("SX2",.F.)
	SX2->X2_DELET += nDel
	MsUnLock("SX2")
	RestArea( aArea )
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao no Botao OK   dos Enderecos                         บฑฑ
ฑฑบ          ณ Somente para Deletar os Itens                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EndGrv()

Local nI 	:= 0
Local nY 	:= 0
Local cVar 	:= ""
Local lOk 	:= .T.
Local nDel 	:= 0
Local cMsg 	:= ""

dbSelectArea("SZS")
If _fPrg == "U_CBDIA07E"
	dbSetOrder(1)
Else
	dbSetOrder(2)
EndIf

aCols2 := oGet2:aCols

If Empty(acols2[n,3])
	msgbox("Nao e permitido deletar linha em Branco")
	acols2[n,3] := .F.
	lRet:= .F.
Else
	For nI := 1 To Len(aCols2)
		If aCols2[nI][5]
			DbSeek(xFilial("SZS")+_cTipo+CCODIGO+aCols2[nI,1])
			RecLock("SZS",,.F.)
			dbDelete()
			MsUnLock("SZS")
			nDel ++
		Endif
	Next nI

	If nDel > 0
		aArea := GetArea()
		dbSelectArea("SX2")
		dbSetOrder(1)
		dbSeek("SZS")
		RecLock("SX2",.F.)
		SX2->X2_DELET += nDel
		MsUnLock("SX2")
		RestArea( aArea )
	Endif
EndIf	

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrava     บAutor  ณMicrosiga           บ Data ณ  08/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CatGrv()

Local nI 	:= 0
Local nY 	:= 0
Local cVar 	:= ""
Local lOk 	:= .T.
Local nDel 	:= 0
Local cMsg 	:= ""

dbSelectArea("SZY")
dbSetOrder(3)

For nI := 1 To Len(aCols2)
	dbSeek( xFilial("SZY") + cCodigo + aCols2[nI,1])
	If !aCols2[nI][nUsado+1]
		If Found()
			RecLock("SZY",.F.)
		Else
			RecLock("SZY",.T.)
		Endif
		SZY->ZY_FILIAL  := xFilial("SZY")
		SZY->ZY_CODCONT := cCodigo

		For nY := 1 to Len(aHeader2)
			If aHeader2[nY][10] # "V"
				cVar := Trim(aHeader2[nY][2])
				Replace &cVar. With aCols2[nI][nY]
			Endif
		Next nY
		MsUnLock("SZY")
	Else
		If !Found()
			Loop
		Endif
		//Fazer pesquisa para saber se o item poderar ser deletado e
		If lOk
			RecLock("SZY",.F.)
			dbDelete()
			MsUnLock("SZY")
			nDel ++
		Endif
	Endif
Next nI

If nDel > 0
	aArea := GetArea()
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("SZY")
	RecLock("SX2",.F.)
	SX2->X2_DELET += nDel
	MsUnLock("SX2")
	RestArea( aArea )
Endif

Return( lRet )

/*
------------------------------------------------------------------------------
------------------------V A L I D A C A O   D E   C A M P O S-----------------
------------------------------------------------------------------------------
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  08/30/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao no campo AC8_COD dentro do SX3 para verificar    บฑฑ
ฑฑบ          ณ duplicidade de registros                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValAC8()

_ret := IIF(INCLUI:=.T.,ExistChav("AC8",cCodigo+M->AC8_COD,4),)

If _ret
	nPos := 0
	nPos := aScan(aCols2,{|x| x[2]==M->AC8_COD})
	If nPos >0
		_ret := .F.
		Help("",1,"JAGRAVADO")
	EndIf
EndIf

Return(_ret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  08/30/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao no campo AC8_COD dentro do SX3 para verificar    บฑฑ
ฑฑบ          ณ duplicidade de registros                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZY()

_ret := IIF(INCLUI:=.T.,ExistChav("SZY",cCodigo+M->ZY_COD,2),)

If _ret
	nPos := 0
	nPos := aScan(aCols2,{|x| x[2]==M->ZY_COD})
	If nPos >0
		_ret := .F.
		Help("",1,"JAGRAVADO")
	EndIf
EndIf

Return(_ret)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  08/30/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao no campo ZQ_CODENT dentro do SX3 para verificar  บฑฑ
ฑฑบ          ณ duplicidade de registros                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZQ1()

_ret := IIF(INCLUI:=.T.,ExistChav("SZQ",cCodigo+M->ZQ_CODENT+aCols[n,4],4),)

If _ret
	nPos := 0
	nPos := aScan(aCols3,{|x| x[2]==M->ZQ_CODENT})

	nPos1 := 0
	If Empty(aCols[n,4])
		nPos1 := 0
	Else
		nPos1 := aScan(aCols3,{|x| x[4]==aCols[n,4]})
	EndIf

	If nPos >0 .and. nPos1 >0
		_ret := .F.
		Help("",1,"JAGRAVADO")
	EndIf
EndIf

Return(_ret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  08/30/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao no campo ZQ_GRUPO  dentro do SX3 para verificar  บฑฑ
ฑฑบ          ณ duplicidade de registros                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZQ2()

lEncontrou := .F.

_ret := IIF(INCLUI:=.T.,ExistChav("SZQ",cCodigo+aCols[n,2]+M->ZQ_GRUPO,4),)

If _ret
	nPos := 0
	If Empty(aCols[n,2])
		nPos := 0
	Else
		nPos := aScan(aCols3,{|x| x[2]==aCols[n,2]})
	EndIf

	If nPos > 0
		_cEntAnt := ACOLS[nPos,2]
		aSort(aCols,,, {|x, y| x[2]+x[4] < y[2]})
		For i:= nPos to len(aCols)
			If ACOLS[i,2] == _cEntAnt
				If ACOLS[i,4] == M->ZQ_GRUPO
					lEncontrou := .T.
					Exit
				EndIf
			Else
				Exit
			EndIf
		Next
	EndIf
	
	If nPos >0 .and. lEncontrou
		_ret := .F.
		Help("",1,"JAGRAVADO")
	EndIf
EndIf

aSort(aCols,,, {|x, y| x[1] < y[1]})

Return(_ret)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  08/30/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao no campo ZR_CARGO  dentro do SX3 para verificar  บฑฑ
ฑฑบ          ณ duplicidade de registros                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZR1()

_ret := IIF(INCLUI:=.T.,ExistChav("SZR",cCodigo1+_cEntid+M->ZR_CARGO+aCols[n,4],3),)

If _ret
	nPos := 0
	nPos := aScan(aCols4,{|x| x[2]==M->ZR_CARGO})

	nPos1 := 0
	If Empty(aCols[n,4])
		nPos1 := 0
	Else
		nPos1 := aScan(aCols4,{|x| x[4]==aCols[n,4]})
	EndIf

	If nPos >0 .and. nPos1 >0
		_ret := .F.
		Help("",1,"JAGRAVADO")
	EndIf
EndIf

// Pesquisar para saber se o tratamento esta coerente com o Sexo do Contato
_lAcho := .F.
DbSelectArea("SUM")
DbSetOrder(1)
If DbSeek(xFilial("SUM")+M->ZR_CARGO)
	_lAcho := .T.
	_cSexo := SUM->UM_SEXO
EndIf

If _lAcho .and. _cSexo <> "3"
	DbSelectArea("SU5")
	DbSetOrder(1)
	If DbSeek(xFilial("SU5")+cCodigo1)
		If SU5->U5_SEXO <> _cSexo
			_ret := .F.
			msgbox("Cargo incompativel com o Sexo do Contato")
		EndIf
	EndIf
EndIf


Return(_ret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  08/30/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao no campo ZR_CODTRAT dentro do SX3 para verificar บฑฑ
ฑฑบ          ณ duplicidade de registros                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZR2()

lEncontrou := .F.

_ret := IIF(INCLUI:=.T.,ExistChav("SZR",cCodigo1+_cEntid+aCols[n,2]+M->ZR_CODTRAT,3),)

If _ret
	nPos := 0
	If Empty(aCols[n,2])
		nPos := 0
	Else
		nPos := aScan(aCols4,{|x| x[2]==aCols[n,2]})
	EndIf

	If nPos > 0
		_cCargAnt := ACOLS[nPos,2]
		aSort(aCols,,, {|x, y| x[2]+x[4] < y[2]})		
		For i:= nPos to len(aCols)
			If ACOLS[i,2] == _cCargAnt
				If ACOLS[i,4] == M->ZR_CODTRAT
					lEncontrou := .T.
					Exit
				EndIf
			Else
				Exit
			EndIf
		Next
	EndIf

	If nPos >0 .and. lEncontrou
		_ret := .F.
		Help("",1,"JAGRAVADO")
	EndIf
EndIf

aSort(aCols,,, {|x, y| x[1] < y[1]})

// Pesquisar para saber se o tratamento esta coerente com o Sexo do Contato
_lAcho := .F.
DbSelectArea("SZN")
DbSetOrder(1)
If DbSeek(xFilial("SZN")+M->ZR_CODTRAT)
	_lAcho := .T.
	_cSexo := SZN->ZN_SEXO
EndIf

If _lAcho
	DbSelectArea("SU5")
	DbSetOrder(1)
	If DbSeek(xFilial("SU5")+cCodigo1)
		If SU5->U5_SEXO <> _cSexo
			_ret := .F.
			msgbox("Tratamento incompativel com o Sexo do Contato")
		EndIf
	EndIf
EndIf

Return(_ret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inicializador padrao no Campo ZS_ITEM                      บฑฑ
ฑฑบ          ณ Preenchimento automatico do Item                           บฑฑ
ฑฑบ          ณ Sequencial com relacao ao Contato                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZS1() // ITEM
If _fPrg == "U_CBDIA07E" // Contato
	_cTipo  := "F"
Else
	_cTipo  := "J"
EndIf

If !Empty(aCols2)
	_cQtd  := Len(aCols2)
	_cItem := Strzero(Val(aCols2[_cQtd,1]) + 1,4)
Else
	dbSelectArea("SZS")
	If _fPrg == "U_CBDIA07E"
		dbSetOrder(1)
	Else
		dbSetOrder(2)
	EndIf

	If dbSeek( xFilial("SZS") + _cTipo + cCodigo ,.t. ) //Pessoa Fisica
		While !EOF() .And. SZS->ZS_FILIAL + SZS->&_cCampo == "01" + cCodigo
			_cItem := SZS->ZS_ITEM
			dbSelectArea("SZS")
			dbSkip()
		End
		_cItem := Strzero(Val(_cItem) + 1,4)
	Else
		_cItem := "0001"
	EndIf
EndIf

Return(_cItem)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inicializador padrao no Campo ZS_CODCONT                   บฑฑ
ฑฑบ          ณ Preenche com o Contato posicionado na Tela                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZS2() // CONTATO
If _fPrg == "U_CBDIA07E" // Contato
	cCod := cCodigo
Else
	cCod := ""
EndIf
Return(cCod)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inicializador padrao no Campo ZS_CODENT                    บฑฑ
ฑฑบ          ณ Preenche com a Entidade posicionado na Tela                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZS3() //ENTIDADE
If _fPrg == "U_CBDIA07E" // Contato
	cCod := ""
Else
	cCod := cCodigo
EndIf
Return(cCod)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inicializador padrao no Campo ZS_TIPO                      บฑฑ
ฑฑบ          ณ Preenche o Tipo com Fisico ou Juridico                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZS4() //TIPO
If _fPrg == "U_CBDIA07E" // Contato
	_cTipo  := "F"
Else
	_cTipo  := "J"
EndIf
Return(_cTipo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inicializador padrao no Campo ZS_TIPO                      บฑฑ
ฑฑบ          ณ Preenche o Tipo com Fisico ou Juridico                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZS5() //TIPO
If _fPrg == "U_CBDIA07E" // Contato
	_cNome  := cNome
Else
	_cNome  := ""
EndIf
Return(_cNome)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inicializador padrao no Campo ZS_TIPO                      บฑฑ
ฑฑบ          ณ Preenche o Tipo com Fisico ou Juridico                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValSZS6() //TIPO
If _fPrg == "U_CBDIA07E" // Contato
	_cNome  := ""
Else
	_cNome  := cNome
EndIf
Return(_cNome)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA07   บAutor  ณMicrosiga           บ Data ณ  09/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro na Consulta Padrao da Tabela SZS trazendo apenas    บฑฑ
ฑฑบ          ณ os Enderecos da Entidade selecionada                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fFiltroSZS()

_lRet := _cEntid + " == VAL(SZS->ZS_CODENT)"

Return(&_lRet)
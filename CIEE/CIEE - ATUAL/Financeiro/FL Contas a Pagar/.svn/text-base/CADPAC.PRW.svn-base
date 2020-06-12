#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADPAC  º Autor ³ Patricia Fontaneziº Data ³  31/07/12      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Tela de Historico de Titulos a Pagar Parcial - tabela PAC º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER FUNCTION CADPAC()  

Local lRet
Local nOpca := 0
Local cSaveMenuh
Local nReg
Local oDlg
Local nDlgHeight
Local nGDHeight
Local aSize := {}

Private aTELA:=Array(0,0)
Private aGets:=Array(0)

Private oGetDados0
Private oGetDados1
Private oEnchoice
Private lEnd

Private _nRetorno := 0

Private _nTotPgto := 0 //Valor Pago (Tabelas SE5 registros reconciliados)

If SetMDIChild()
	oMainWnd:ReadClientCoors()
	nDlgHeight := 500
	nGDHeight  := oMainWnd:nBottom
Else
	nDlgHeight := 420
	nGDHeight  := 70
EndIf

aCordW := {135,000,nDlgHeight,632}
nSizeHeader := 210 //Tamanho do Cabecalho Enchoice

Aadd(aSize,nSizeHeader)

/*If alltrim(PA9->PA9_PREFIX) == "FLI"
   	_nRetorno := titFLI()

	If _nRetorno == 0
		Return
	EndIf

EndIf   */

cTitulo		:= "Historico Titulo FL"
//nReg		:=(cAlias1)->(Recno()) 	// Usado na enchoice
//aMyEncho	:= {}					// Campos da Enchoice.
//nOpcE		:= 3            	    // Opcao da Enchoice.
//lVirtual	:= .T.	            	// Exibe os campos virtuais na Enchoice.

cAlias1		:= "PAB"         	// Alias da GetDados0.
cAlias2		:= "PAC"            // Alias da GetDados1.

cFieldOk	:= "AllwaysTrue()"  // Valida cada campo da GetDados.
cLinOk		:= "AllwaysTrue()"  // Valida a linha.
cTudoOk		:= "AllwaysTrue()"  // Valida toda a GetDados.

nLinhas		:= 999              // Numero maximo de linhas na GetDados.

//aAltEnch	:= nil              // Campos alteraveis na Enchoice (nil = todos).
//aAltEnch	:= {}				// Campos alteraveis na Enchoice
// Cabeçalho
//AADD(aAltEnch,"PAC_TITULO")	// Campos alteraveis na Enchoice

//nOpcE 	:= If(nOpcE==Nil,3,nOpcE)				// Opcao da Enchoice.
//lVirtual 	:= Iif(lVirtual==Nil,.F.,lVirtual) 		// Exibe os campos virtuais na Enchoice.

nLinhas		:=Iif(nLinhas==Nil,999,nLinhas)			// Numero maximo de linhas na GetDados.
nFreeze		:=nil									// GetDados

DbSelectArea(cAlias1)   

//Cria variaveis M->????? da Enchoice.
RegToMemory(cAlias1, .T.)
RegToMemory(cAlias2, .T.)

//Monta a aHeader.
aHeader0 	:= {}
aHeader1 	:= {}  
aHeader2 	:= {}

_aArea := SX3->(GetArea())
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias1)
/*
******************** Primeiro aHeader
*/
_xCampos := "PAB_NATURE|PAB_VALOR|PAB_SALDO"

Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == cAlias1) //PAB
	If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL)
		If alltrim(SX3->X3_CAMPO) $ _xCampos
			aAdd(aHeader0,	 {	TRIM(SX3->X3_TITULO)	,;
								SX3->X3_CAMPO			,;
								SX3->X3_PICTURE			,;
								SX3->X3_TAMANHO			,;
								SX3->X3_DECIMAL			,;
								SX3->X3_VALID			,;
								SX3->X3_USADO			,;
								SX3->X3_TIPO			,;
								SX3->X3_F3				,;
								SX3->X3_CONTEXT			,;
								SX3->X3_CBOX			,;
								SX3->X3_RELACAO			,;
								SX3->X3_WHEN			,;
								SX3->X3_VISUAL			,;
								SX3->X3_VLDUSER			,;
								SX3->X3_PICTVAR			,;
								SX3->X3_OBRIGAT			})
		Endif
	Endif
	SX3->(dbSkip())
EndDo
SX3->(RestArea(_aArea))

_aArea := SX3->(GetArea())
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias2)
/*
******************** Segundo aHeader
*/
//Uma FLI pode ter ORIGEM e/ou DESTINO
//A Origem da FLI sao as FL´s que foram utilizadas nela
//O Destino do FLI e para onde ela foi enviado

//Uma FL sempre tem somente DESTINO, que seria a FLI gerada para o saldo desta FL

_xCampos := "PAC_TPORI|PAC_PRFORI|PAC_NUMORI|PAC_NOMORI|PAC_FORORI|PAC_VECORI|PAC_NATORI|PAC_VALORI"

  //	_xCampos := "PAC_TPFLI|PAC_PRFFLI|PAC_NUMFLI|PAC_NOMFLI|PAC_FORFLI|PAC_VECFLI|PAC_NATORI|PAC_VALORI"

Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == cAlias2) //PAC
	If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL)
		If alltrim(SX3->X3_CAMPO) $ _xCampos
			aAdd(aHeader1,	 {	TRIM(SX3->X3_TITULO)	,;
								SX3->X3_CAMPO			,;
								SX3->X3_PICTURE			,;
								SX3->X3_TAMANHO			,;
								SX3->X3_DECIMAL			,;
								SX3->X3_VALID			,;
								SX3->X3_USADO			,;
								SX3->X3_TIPO			,;
								SX3->X3_F3				,;
								SX3->X3_CONTEXT			,;
								SX3->X3_CBOX			,;
								SX3->X3_RELACAO			,;
								SX3->X3_WHEN			,;
								SX3->X3_VISUAL			,;
								SX3->X3_VLDUSER			,;
								SX3->X3_PICTVAR			,;
								SX3->X3_OBRIGAT			})
		Endif
	Endif
	SX3->(dbSkip())
EndDo
SX3->(RestArea(_aArea))

_aArea := SX3->(GetArea())
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias2)

_xCampos := "PAC_TPFLI|PAC_PRFFLI|PAC_NUMFLI|PAC_NOMFLI|PAC_FORFLI|PAC_VECFLI|PAC_NATORI|PAC_VALORI"   

Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == cAlias2) //PAC
	If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL)
		If alltrim(SX3->X3_CAMPO) $ _xCampos
			aAdd(aHeader2,	 {	TRIM(SX3->X3_TITULO)	,;
								SX3->X3_CAMPO			,;
								SX3->X3_PICTURE			,;
								SX3->X3_TAMANHO			,;
								SX3->X3_DECIMAL			,;
								SX3->X3_VALID			,;
								SX3->X3_USADO			,;
								SX3->X3_TIPO			,;
								SX3->X3_F3				,;
								SX3->X3_CONTEXT			,;
								SX3->X3_CBOX			,;
								SX3->X3_RELACAO			,;
								SX3->X3_WHEN			,;
								SX3->X3_VISUAL			,;
								SX3->X3_VLDUSER			,;
								SX3->X3_PICTVAR			,;
								SX3->X3_OBRIGAT			})
		Endif
	Endif
	SX3->(dbSkip())
EndDo
SX3->(RestArea(_aArea))
//Monta a aCols
aCols0 	:= {}
aCols1 	:= {}
aCols2 	:= {}
/*
******************** Primeiro aCols
*/
_aAreaX3 := SX3->(GetArea())
DbSelectArea("SX3")
SX3->(dbSetOrder(2))

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('PAB')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND PAB_NUM = '"+ALLTRIM(PA9->PA9_NUM)+"' "
cQuery += "ORDER BY PAB_NATURE "
TcQuery cQuery New Alias "PABTMP"

DbSelectArea("PABTMP")
Do While !EOF()
	_aAux1 := {}
	For _nAux1 := 1 to len(aHeader0)
		SX3->(dbSeek(aHeader0[_nAux1, 2]))
		If SX3->X3_CONTEXT == "V"
			aAdd(_aAux1, &(SX3->X3_RELACAO))
		Else
			aAdd(_aAux1, PABTMP->(&(aHeader0[_nAux1, 2])))
		Endif
	Next _nAux1
	aAdd(_aAux1, .F.)
	aAdd(aCols0, _aAux1)
	PABTMP->(dbSkip())
EndDo

PABTMP->(DbCloseArea())

SX3->(RestArea(_aAreaX3))

/*
******************** Segundo aCols
*/
_aAreaX3 := SX3->(GetArea())
DbSelectArea("SX3")
SX3->(dbSetOrder(2))

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('PAC')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND PAC_NUMFLI = '"+ALLTRIM(PA9->PA9_NUM)+"' "
cQuery += "ORDER BY PAC_NUMORI "
TcQuery cQuery New Alias "PACTMP"
TcSetField("PACTMP","PAC_VECFLI","D",8, 0 )

DbSelectArea("PACTMP")
Do While !EOF()
	_aAux1 := {}
	For _nAux1 := 1 to len(aHeader1)
		SX3->(dbSeek(aHeader1[_nAux1, 2]))
		If SX3->X3_CONTEXT == "V"
			aAdd(_aAux1, &(SX3->X3_RELACAO))
		Else
			aAdd(_aAux1, PACTMP->(&(aHeader1[_nAux1, 2])))
		Endif
	Next _nAux1
	aAdd(_aAux1, .F.)
	aAdd(aCols1, _aAux1)
	PACTMP->(dbSkip())
EndDo

PACTMP->(DbCloseArea())

SX3->(RestArea(_aAreaX3))


/*
******************** Terceiro aCols
*/
_aAreaX3 := SX3->(GetArea())
DbSelectArea("SX3")
SX3->(dbSetOrder(2))

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('PAC')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND PAC_NUMORI = '"+ALLTRIM(PA9->PA9_NUM)+"' "
cQuery += "ORDER BY PAC_NUMORI "
TcQuery cQuery New Alias "PACTMP"
TcSetField("PACTMP","PAC_VECFLI","D",8, 0 )

DbSelectArea("PACTMP")
Do While !EOF()
	_aAux1 := {}
	For _nAux1 := 1 to len(aHeader2)
		SX3->(dbSeek(aHeader2[_nAux1, 2]))
		If SX3->X3_CONTEXT == "V"
			aAdd(_aAux1, &(SX3->X3_RELACAO))
		Else
			aAdd(_aAux1, PACTMP->(&(aHeader2[_nAux1, 2])))
		Endif
	Next _nAux1
	aAdd(_aAux1, .F.)
	aAdd(aCols2, _aAux1)
	PACTMP->(dbSkip())
EndDo

PACTMP->(DbCloseArea())

SX3->(RestArea(_aAreaX3))


/*INICIO ------------- TAMANHO DA TELA*/
_aSize := MsAdvSize()
aObjects:= {}
aPosObj :={}

aInfo   := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3}

AADD(aObjects,{100,030,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo, aObjects)
/*FIM ------------- TAMANHO DA TELA*/

//Somatoria dos registros de Inconsistencia
_nTotInco 	:= 0  
_nTotI2		:= 0
_nTotI0		:= 0
For _nY :=1 to Len(acols1)
	_nTotInco += acols1[_nY,8]
Next _nY 
//Patricia Fontanezi
For _nY :=1 to Len(acols2)
	_nTotI2 += acols2[_nY,8]
Next _nY

For _nY :=1 to Len(acols0)
	_nTotI0 += acols0[_nY,3]
Next _nY

_nValPgto := TOTINCO()

aButtons	:= {}

Aadd( aButtons, { "ALTERA", { || _fConsulta()   },"Consulta Pgto","Consulta Pgto"})

DEFINE FONT oBold		NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oBold_New	NAME "Courier" SIZE 0, -14 BOLD
DEFINE MSDIALOG oDlg TITLE cTitulo From _aSize[7],0 TO _aSize[6],_aSize[5] Pixel of oMainWnd

//oEnchoice	:= Msmget():New(cAlias1,nReg,nOpcE,,,,aMyEncho,{10,1,120,aPosObj[2,4]+2},aAltEnch,3,,,,,,lVirtual,,,,,,,,.T.)

@ 005,005 Say OemToAnsi("Numero: ")+PA9->PA9_NUM OF oDlg PIXEL FONT oBold 
@ 018,005 Say OemToAnsi("Fornecedor: ")+PA9->PA9_NOMFOR OF oDlg PIXEL FONT oBold
@ 005,100 Say OemToAnsi("Valor Original: ")+ Transform(PA9->PA9_VALOR, "@E 99,999,999.99")  OF oDlg PIXEL FONT oBold
@ 018,200 Say OemToAnsi("Vencto: ")+DTOC(PA9->PA9_VENCRE) OF oDlg PIXEL FONT oBold
@ 005,200 Say OemToAnsi("Saldo a Pagar: ")+ Transform(PA9->PA9_SALDO, "@E 99,999,999.99")  OF oDlg PIXEL FONT oBold
@ 005,300 Say OemToAnsi("Valor Pago:")+ Transform(_nValPgto, "@E 99,999,999.99")  OF oDlg PIXEL FONT oBold   

@ 005,400 Say OemToAnsi("Valor Inconsitencia:")+ Transform(PA9->PA9_VLINCO, "@E 99,999,999.99")  OF oDlg PIXEL FONT oBold   
@ 005,500 Say OemToAnsi("Valor Residuo:")+ Transform(PA9->PA9_VLRESI, "@E 99,999,999.99")  OF oDlg PIXEL FONT oBold   

aCampos0	:= {}
//AADD(aCampos0,"PAB_VLPGT") 	//campos alteraveis no GetDados2// VALOR EDITAVEL
nGetd0		:= GD_UPDATE //GD_INSERT+GD_UPDATE+GD_DELETE
oGetDados0	:= MsNewGetDados():New(30,1,120,600,nGetd0,cLinOk,cTudoOk,"",aCampos0,nFreeze,nLinhas,cFieldOk,/*superdel*/,/*delok*/,/*oFolder:aDialogs[2]*/,aheader0 ,acols0 )
oGetDados0:oBrowse:Default()	
oGetDados0:oBrowse:Refresh() 
	
//DESTINO
aCampos2	:= {}

nGetd2		:= GD_UPDATE //GD_INSERT+GD_UPDATE+GD_DELETE
oGetDados2	:= MsNewGetDados():New(146,1,220,600,nGetd2,cLinOk,cTudoOk,"",aCampos2,nFreeze,nLinhas,cFieldOk,/*superdel*/,/*delok*/,/*oFolder:aDialogs[2]*/,aheader2 ,acols2 )
oGetDados2:oBrowse:Default()	
oGetDados2:oBrowse:Refresh()	

//ORIGEM
aCampos1	:= {}

nGetd1		:= GD_UPDATE //GD_INSERT+GD_UPDATE+GD_DELETE
oGetDados1	:= MsNewGetDados():New(236,1,320,600,nGetd1,cLinOk,cTudoOk,"",aCampos1,nFreeze,nLinhas,cFieldOk,/*superdel*/,/*delok*/,/*oFolder:aDialogs[2]*/,aheader1 ,acols1 )
oGetDados1:oBrowse:Default()	
oGetDados1:oBrowse:Refresh()	

@ 130,010 Say OemToAnsi("Re-emissões                    	") OF oDlg PIXEL FONT oBold
//@ 130,480 Say OemToAnsi("Valor Total:                     	")+ Transform(_nTotI0, "@E 99,999,999.99")  OF oDlg PIXEL FONT oBold   
@ 221,010 Say OemToAnsi("Origem FL                     		") OF oDlg PIXEL FONT oBold     
@ 221,480 Say OemToAnsi("Valor Total das Re-Emissões:   ")+ Transform(_nTotI2  , "@E 99,999,999.99")  OF oDlg PIXEL FONT oBold   
@ 325,480 Say OemToAnsi("Valor Total FL Origem: 	")+ Transform(_nTotInco, "@E 99,999,999.99")  OF oDlg PIXEL FONT oBold

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,;
											{||iif(U_INC_OK(), (nOpca:=1,oDlg:End()), nOpca:=0 )},;
											{||iif(U_CAN_OK(), (nOpca:=0,oDlg:End()), nOpca:=0 )},;
											,;
											aButtons),;
											)
lRet:=(nOpca==1)

If lRet

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XTELAFL   ºAutor  ³Microsiga           º Data ³  07/31/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao de Linha acols PAB                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Linhaok1()
_lRet	:= .T.
ALERT("Em desenvolvimento")
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XTELAFL   ºAutor  ³Microsiga           º Data ³  07/24/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao OK tela                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function INC_OK()
_lRet	:= .T.
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XTELAFL   ºAutor  ³Microsiga           º Data ³  07/24/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao Cancelar Tela                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CAN_OK()
_lRet	:= .T.
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADPAC    ºAutor  ³Microsiga           º Data ³  09/13/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*Static Function titFLI()

Local oDlg

DEFINE MSDIALOG oDlg TITLE "Historio FL - Inconsistencia" From 200, 001 to 255, 388 Pixel
@ 001,010 BUTTON "Origem" 	SIZE 55,15 ACTION (_nRetorno := 01,oDlg:End())
@ 001,030 BUTTON "Destino" 	SIZE 55,15 ACTION (_nRetorno := 99,oDlg:End())

ACTIVATE MSDIALOG oDlg

Return(_nRetorno)  */

Static Function _fConsulta()

//finc050()
//----------------------------------------------------------------------------------------------------------------------------------------------------//
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
LOCAL nAlias, nValor, nSaldo
Local nAcres  := 0
Local nDecres := 0
LOCAL oDlg,nOpca,oBrw,oCol,aBrowse:={},ni,aCpos
Local aAreaSe2 := SE2->(GetArea())
Local aArea := GetArea()
Local nAbatim := 0
Local	cBcoPa := CRIAVAR("EF_BANCO",.F.)
Local	cAgePa := CRIAVAR("EF_AGENCIA",.F.)
Local	cCtaPa := CRIAVAR("EF_CONTA",.F.)
Local	cChqPa := CRIAVAR("EF_NUM",.F.)
Local aCores 	:= {}
Local aBut050 := {}

Private cNomearq, cSe2
Private nJuros 	:= 0
Private dBaixa 	:= dDataBase
Private nCasas := GetMv("MV_CENT")

Private _nTotPgto := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada para montar array com botoes a      ³
//³ serem apresentados na tela da Consulta                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("F050BOT"))
	aBut050 := ExecBlock("F050BOT",.F.,.F.)
	If ValType(aBut050) # "A"
		aBut050 := {}     
	EndIf
Endif

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³Verifica se ‚ um registro Principal												³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SE2->E2_TIPO $ MVABATIM
	Help(" ",1,"TITNAOPR")
	Return
EndIF

Aadd(aCores,"BR_VERDE")
Aadd(aCores,"DISABLE" )

SaveInter()

MsgMeter({| oMeter, oText, oDlg, lFim | ;
			cNomeArq := Fn050Cria(oMeter, oText, oDlg, @lFim,@aCpos)},;
			 "Criando Arquivo Tempor rio...",;  //
			 "Consulta de T¡tulos a Pagar")	//
			
If SE2->E2_SALDO = 0
   dBaixa := SE2->E2_BAIXA
   nSaldo := SE2->E2_VALOR
Else
   nSaldo := SaldoTit(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA,;
                      SE2->E2_TIPO, SE2->E2_NATUREZ, "P", SE2->E2_FORNECE, 1,;
                      ,,SE2->E2_LOJA,,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))
Endif

//Desconto Financeiro e Abatimento
IF !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG)
	//Abatimento
	nAbatim	 := SomaAbat(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA,"P", 1 ,,SE2->E2_FORNECE,SE2->E2_LOJA)
	fa080Juros(1, nSaldo)
Else
	aArea := GetArea()
	dbSelectArea("SEF")
	dbSetOrder(3)
	//PA com cheque
	If MsSeek(xFilial("SEF")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO))
		While !Eof() .AND. SEF->(EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO) == ;
								xFilial("SEF")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
			If SEF->(EF_FORNECE+EF_LOJA) == SE2->(E2_FORNECE+E2_LOJA)
				cBcoPa := EF_BANCO
				cAgePa := EF_AGENCIA
				cCtaPa := EF_CONTA
				cChqPa := EF_NUM
				Exit
			Endif		
			dbSkip()
		Enddo
	Else	//PA sem cheque
		dbSelectArea("SE5")
		dbSetOrder(7)
		If MsSeek(xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
			While !Eof() .AND. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == ;
									xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
				If SE5->E5_TIPODOC == "PA"  //Registro inicial do PA
					cBcoPa := E5_BANCO
					cAgePa := E5_AGENCIA
					cCtaPa := E5_CONTA
					cChqPa := E5_NUMCHEQ
					Exit
				Endif		
				dbSkip()
			Enddo
		Endif	
	Endif		
	RestArea(aArea)
Endif

nValor := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava as movimentacoes no arquivo de trabalho					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("cNomeArq")
If File(cNomearq+GetDBExtension())
	nAlias := Select("cNomeArq")
/*
	aBrowse := {{"  ","OK"},;				//Led de ativo, cancelado ou estornado
					{"Data","DATAX"},;			//  
					{"Juros","JUROS"},;			//  
						{"Multa","MULTA"},;      // 
						{"Corre‡„o","CORRECAO"},;   // 
						{"Descontos","DESCONTOS"},;  // 
						{"Pis","PIS"},;        //
						{"Cofins","COFINS"},;     //
						{"Csll","CSLL"},;       //
						{"Valor Pago","VALORPAGO"},;  // 
						{"Motivo","MOTIVO"},;     // 
						{"Hist¢rico","HISTORICO"},;  // 
						{"Data Contabiliza‡„o","DATACONT"},;   // 
						{"Data Disponibilidade","DATADISP"},;   //
						{"Lote","LOTE"},;       // 
						{"Banco","BANCO"},;      // 
						{"Agˆncia","AGENCIA"},;    // 
						{"Conta","CONTA"},;      // 
						{"N.Cheque","NROCHEQUE"},;  // 
						{"Documento","DOCUMENTO"},;  // 
						{"Filial Movto.","FILIAL"},; //
						{"Reconciliado","RECONC"}}		 //
*/

	aBrowse := 		{	{"  ","OK"},;				//Led de ativo, cancelado ou estornado
						{"Data","DATAX"},;			//  
						{"Conciliado","RECONC"},;
						{"Valor Pago","VALORPAGO"},;  // 
						{"Motivo","MOTIVO"},;     // 
						{"Hist¢rico","HISTORICO"},;  // 
						{"Data Contabiliza‡„o","DATACONT"},;   // 
						{"Data Disponibilidade","DATADISP"},;   //
						{"Banco","BANCO"},;      // 
						{"Agˆncia","AGENCIA"},;    // 
						{"Conta","CONTA"},;      // 
						{"N.Cheque","NROCHEQUE"},;  // 
						{"Documento","DOCUMENTO"}}		 //


		DEFINE MSDIALOG oDlg FROM	08,0 TO 38,80 TITLE "Consulta - T¡tulos a Pagar" OF oMainWnd  //
		oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT    

		@ 14, 003 SAY  	"Prf"							SIZE 16, 07							OF oPanel PIXEL
		@ 21, 003 MSGET SE2->E2_PREFIXO				SIZE 16, 09 When .F. 			OF oPanel PIXEL 
		@ 14, 023 SAY  	"T¡tulo"    					SIZE 21, 07							OF oPanel PIXEL  //
		@ 21, 023 MSGET SE2->E2_NUM 					SIZE 46, 09 When .F. 			OF oPanel PIXEL
		@ 14, 073 SAY  	"Parc"    					SIZE 16, 07							OF oPanel PIXEL  //
		@ 21, 073 MSGET SE2->E2_PARCELA	  			SIZE 11, 09 When .F. 			OF oPanel PIXEL
		@ 14, 087 SAY  	"Tipo"    					SIZE 16, 07							OF oPanel PIXEL  //
		@ 21, 087 MSGET SE2->E2_TIPO					SIZE 13, 09 When .F. 			OF oPanel PIXEL
		@ 14, 103 SAY  	"Natureza" 						SIZE 30, 07							OF oPanel PIXEL  //
		@ 21, 103 MSGET oGet VAR SE2->E2_NATUREZ 	SIZE 34, 09	F3 "SED" READONLY	OF oPanel PIXEL Hasbutton
		@ 14, 141 SAY  	"Hist¢rico" 						SIZE 30, 07							OF oPanel PIXEL  //
		@ 21, 141 MSGET	SE2->E2_HIST				SIZE 70, 09 When .F.  			OF oPanel PIXEL

		@ 34, 003 SAY   "Fornec."							SIZE 021, 07 						OF oPanel PIXEL  //
		@ 41, 003 MSGET oGet VAR SE2->E2_FORNECE	SIZE 070, 09 F3 "SA2" READONLY	OF oPanel PIXEL Hasbutton
		@ 34, 078 SAY   "Loja"							SIZE 016, 07 						OF oPanel PIXEL  //
		@ 41, 078 MSGET SE2->E2_LOJA					SIZE 021, 09 When .F. 			OF oPanel PIXEL
		@ 34, 108 SAY   "Nome"							SIZE 030, 07 						OF oPanel PIXEL  //
		@ 41, 108 MSGET SE2->E2_NOMFOR				SIZE 103, 09 When .F. 			OF oPanel PIXEL

		@ 55, 003 SAY  "Valor Original" 		SIZE 42, 07														OF oPanel PIXEL  //
		@ 62, 003 MSGET nValor		SIZE 68, 09 PICTURE Tm(nValor,15,nCasas)  When .F.	OF oPanel PIXEL
//		@ 55, 073 SAY  "Juros Devidos" 		SIZE 45, 07														OF oPanel PIXEL  //
 //		@ 62, 073 MSGET nJuros		SIZE 68, 09 PICTURE Tm(nJuros,15,nCasas)  When .F.	OF oPanel PIXEL
//		@ 55, 143 SAY "Abatimentos"		SIZE 45, 07														OF oPanel PIXEL //
//		@ 62, 143 MSGET nAbatim		SIZE 68, 09 PICTURE Tm(nAbatim,15,nCasas) When .F.	OF oPanel PIXEL

		nAcres  := SE2->E2_SDACRES
		nDecres := SE2->E2_SDDECRE
		@ 55, 073 SAY	"Acrescimo"						SIZE 45, 07 							  						OF oPanel PIXEL // 
		@ 62, 073 MSGET	nAcres					SIZE 68, 09 PICTURE Tm(nAcres,15,nCasas)  When .F.	OF oPanel PIXEL
		@ 55, 143 SAY	"Decrescimo"						SIZE 45, 07 													OF oPanel PIXEL // 
		@ 62, 143 MSGET	nDecres					SIZE 68, 09 PICTURE Tm(nDecres,15,nCasas) When .F.	OF oPanel PIXEL

		@ 14, 228 SAY  	"Emiss„o"  		 		SIZE 30, 07				OF oPanel PIXEL  //
		@ 14, 274 MSGET	SE2->E2_EMISSAO		SIZE 37, 09 When .F. OF oPanel PIXEL
		@ 26, 228 SAY  	"Vencto"   				SIZE 30, 07				OF oPanel PIXEL  //
		@ 26, 274 MSGET SE2->E2_VENCTO			SIZE 37, 09 When .F. OF oPanel PIXEL
		@ 38, 228 SAY  	"Vencto Real" 					SIZE 45, 07				OF oPanel PIXEL  //
		@ 38, 274 MSGET SE2->E2_VENCREA			SIZE 37, 09 When .F.	OF oPanel PIXEL
		@ 50, 228 SAY  	"Contabiliza‡„o" 					SIZE 47, 07				OF oPanel PIXEL  //
		@ 50, 274 MSGET SE2->E2_EMIS1				SIZE 37, 09 When .F. OF oPanel PIXEL
		@ 62, 228 SAY  	"Valor Pago"  				SIZE 30, 07				OF oPanel PIXEL  //
		@ 69, 228 MSGET _nTotPgto			SIZE 72, 09 PICTURE Tm(_nTotPgto,15,nCasas) When .F.	OF oPanel PIXEL
		                      
	
		If SE2->E2_TIPO $ MVPAGANT
			@ 095, 003 SAY 		"Banco"	 		SIZE 30, 07							OF oPanel PIXEL	//
			@ 102, 003 MSGET	cBcoPa				SIZE 50, 09 F3 "SA6" READONLY	OF oPanel PIXEL hasbutton
			@ 095, 053 SAY 		"Agência"			SIZE 30, 07							OF oPanel PIXEL	//
			@ 102, 053 MSGET 	cAgePa				SIZE 50, 09 When .F.  			OF oPanel PIXEL
			@ 095, 103 SAY 		"Conta" 			SIZE 30, 07							OF oPanel PIXEL	//
			@ 102, 103 MSGET 	cCtaPa				SIZE 55, 09 When .F.  			OF oPanel PIXEL
			@ 095, 158 SAY 		"Documento" 			SIZE 30, 07							OF oPanel PIXEL	//
			@ 102, 158 MSGET 	cChqPa 				SIZE 53, 09 When .F.	 			OF oPanel PIXEL
			oBrw := TCBrowse():New( 115, 3, 310, 65,,,, oPanel,,,,,,,,,,,, .F.,, .T.,, .F., )
		Else
			oBrw := TCBrowse():New( 095, 3, 310, 85,,,, oPanel,,,,,,,,,,,, .F.,, .T.,, .F., )		
		Endif

		For ni := 1 to Len(aBrowse)
			If ni == 1  //Identificador de cancelamento
				oCol := TCColumn():New(aBrowse[ni][1],{|| aCores[cNomeArq->OK]},"@BMP",,,,1,.T.,.F.) 
			ElseIf aCpos[ni][2] != "N"
				oCol := TCColumn():New( If(.F.,  ( (aBrowse[ni][1])),  (aBrowse[ni][1])), If( ValType(FieldWBlock(aCpos[ni][1],nalias))=="B", FieldWBlock(aCpos[ni][1],nalias), {|| FieldWBlock(aCpos[ni][1],nalias)} ),,,, If(!.F.,"LEFT", Upper()), CalcFieldSize(aCpos[ni][2],aCpos[ni][3],aCpos[ni][4],"", (aBrowse[ni][1])), .F., .F.,,,, .F., )
			Else
				oCol := TCColumn():New( If(.F.,  ( (aBrowse[ni][1])),  (aBrowse[ni][1])), If( ValType(FieldWBlock(aCpos[ni][1],nalias))=="B", FieldWBlock(aCpos[ni][1],nalias), {|| FieldWBlock(aCpos[ni][1],nalias)} ),Tm(aCpos[ni][1],15,nCasas),,, If(!.T.,"LEFT", Upper("RIGHT")), CalcFieldSize(aCpos[ni][2],aCpos[ni][3],aCpos[ni][4],Tm(aCpos[ni][4],15,nCasas), (aBrowse[ni][1])), .F., .F.,,,, .F., )
			Endif
			oBrw:ADDCOLUMN(oCol)
		Next ni
		
		@ 13.0, 20 BITMAP oBmp  RESNAME "BR_VERDE" SIZE 16,16 NOBORDER OF oPanel 
		@ 13.8, 20 BITMAP oBmp1 RESNAME "DISABLE"  SIZE 16,16 NOBORDER OF oPanel 
	
		@ 14.1, 22 SAY "Movimento de Baixa" OF oPanel  //
		@ 14.8, 22 SAY "Movimento Cancelado ou de Estorno" OF oPanel  //

		@ 14.0, .8 Say "Saldo do T¡tulo :" + Trans(SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE,Tm(SE2->E2_SALDO,15,nCasas)) OF oPanel  //

		@ 14.8, .8 Say "Saldo a Pagar  :" + Trans(If(SE2->E2_SALDO > 0,SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE+; //
										            nJuros - IIf(SE2->E2_SALDO > 0,nAbatim,0),SE2->E2_SALDO),tm(SE2->E2_SALDO,15,ncasas)) OF oPanel 

		If lPanelFin  //Chamado pelo Painel Financeiro									   	
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,{||nopca:=1,oDlg:End()},{||oDlg:End()},aBut050) CENTER
	   Else		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nopca:=1,oDlg:End()},{||oDlg:End()},,aBut050) CENTER
		Endif
	// Apaga arquivos temporarios
	IF Select("cNomeArq") > 0
		dbSelectArea("cNomeArq")
		Use
		FERASE(cNomearq+GetDBExtension())
		Ferase(cNomeArq+OrdBagExt())
	ENDIF
Else
	 Help("",1,"Fc050NOARQ")
Endif
RestInter()
SE2->(RestArea(aAreaSe2))
RestArea(aArea)
Return

Static Function Fn050Cria(oMeter,oText,oDlg,lFim,aCampos)

Local cNomeArq := ""
Local aTamSX3  := {}
Local aTamSX3a := {}
Local aTamSX3b := {}

Private nCont := 1
oMeter:nTotal := SE2->(RecCount())

aTamSx3  := TamSX3("E5_DOCUMEN")
aTamSx3a := TamSX3("E5_HISTOR")
aTamSx3b := TamSX3("E5_LOTE")
/*
aCampos	:= {{"OK","N",1,0},;
				 {"DATAX", "D", 08, 0 }, ;
				 { "JUROS     ", "N", 16, 2 }, ;
				 { "MULTA     ", "N", 16, 2 }, ;
				 { "CORRECAO  ", "N", 16, 2 }, ;
				 { "DESCONTOS ", "N", 16, 2 }, ;
				 { "PIS       ", "N", 16, 2 }, ;
 				 { "COFINS    ", "N", 16, 2 }, ;
 				 { "CSLL      ", "N", 16, 2 }, ;
				 { "VALORPAGO ", "N", 16, 2 }, ;
				 { "MOTIVO    ", "C", 03, 0 }, ;
				 { "HISTORICO ", "C", aTamSx3a[1]+1,aTamSx3a[2]}, ;
				 { "DATACONT  ", "D", 08, 0 }, ;
				 { "DATADISP  ", "D", 08, 0 }, ;
				 { "LOTE      ", "C", aTamSx3b[1], aTamSx3b[2]}, ;
				 { "BANCO     ", "C", 03, 0 }, ;
				 { "AGENCIA   ", "C", 05, 0 }, ;
				 { "CONTA     ", "C", 10, 0 }, ;
				 { "NROCHEQUE ", "C", 15, 0 }, ;
				 { "DOCUMENTO ", "C", aTamSx3[1],aTamSx3[2]},;
				 { "FILIAL    ", "C", FWGETTAMFILIAL, 0 }, ;
				 { "RECONC    ", "C", 01, 0 } }
*/
aCampos	:= 	{	 {"OK","N",1,0},;
				 {"DATAX", "D", 08, 0 }, ;
				 { "RECONC    ", "C", 01, 0 } ,;
				 { "VALORPAGO ", "N", 16, 2 }, ;
				 { "MOTIVO    ", "C", 03, 0 }, ;
				 { "HISTORICO ", "C", aTamSx3a[1]+1,aTamSx3a[2]}, ;
				 { "DATACONT  ", "D", 08, 0 }, ;
				 { "DATADISP  ", "D", 08, 0 }, ;
				 { "BANCO     ", "C", 03, 0 }, ;
				 { "AGENCIA   ", "C", 05, 0 }, ;
				 { "CONTA     ", "C", 10, 0 }, ;
				 { "NROCHEQUE ", "C", 15, 0 }, ;
				 { "DOCUMENTO ", "C", aTamSx3[1],aTamSx3[2]}}


If (Select("cNomeArq")<>0)
	dbSelectArea ("cNomeArq")
	dbCloseArea()
Endif
cNomeArq := CriaTrab(aCampos)
dbUseArea (.T.,, cNomeArq, "cNomeArq", NIL, .F.)


PacTemp(oMeter,oText,oDlg,lFim)

dbSelectArea("cNomeArq")
dbGotop()

Return cNomeArq

Static lFWCodFil := FindFunction("FWCodFil")

Static Function PacTemp(oMeter,oText,oDlg,lFim)

Local cMoeda
Local cSeq, nCorrec, nMulta, nDescont, nValPag, cMotivo, nJuros:=0
Local cFilOrig  // Filial de Origem do Titulo
Local aTamSX3	:= TamSX3("E5_NUMERO")
Local aFiliais := {}
Local nRegEmp	:= SM0->(Recno())
Local nRegAtu	:= SM0->(Recno())
Local lExclusivo := !Empty(xFilial("SE5"))
Local cEmpAnt	:= SM0->M0_CODIGO
Local nI
Local nSituaca := 1   
Local nPis := 0
Local nCofins := 0
Local nCsll := 0

//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )


*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³Salva ordem atual																		³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(1)


DbSeek(xFilial("SE2")+PA9->(PA9_PREFIX+PA9_NUM+" "+PA9_TIPO+PA9_FORNEC+PA9_LOJA ))


bBlock:={|| oMeter:Set(nCont), SysRefresh(), !lFim}
EVAL(bBlock)
nCont++

cMoeda	:= IIF(Empty(SE2->E2_MOEDA),"1",StrZero(SE2->E2_MOEDA,1))

dbSelectArea("SM0")
dbSeek(cEmpAnt,.T.)
nRegAtu := SM0->(RECNO())
While !Eof() .and. SM0->M0_CODIGO == cEmpAnt
	AADD(aFiliais, IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) )
	DbSkip()
Enddo
SM0->(dbGoto(nRegAtu))

For nI := 1 to Len(aFiliais)

   cFilAtu := aFiliais[nI]
	cEmpAnt := SM0->M0_CODIGO
	While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) == cFilAtu
	
		dbSelectArea("SE2")
		cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	
		dbSelectArea("SE5")
		dbSetOrder(7)
	
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³Grava as baixas do titulo															³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If dbSeek(xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
			While !SE5->(Eof()) .and. ;
				SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == ;
				xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		

				If	(SE5->E5_RECPAG == "P" .AND. SE5->E5_TIPODOC == "ES") .OR. ;
					(SE5->E5_RECPAG 	== "R" .and. SE5->E5_TIPODOC != "ES" .AND. ;
					 !(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
					SE5->(dbSkip())
					Loop
				EndIF
		
				If !Empty(xFilial("SE5")) .and. !Empty(xFilial("SE2"))
					//Busca movimento de compensacao em outra filial
					cFilOrig := SE5->E5_FILIAL
					If SE5->E5_MOTBX == "CMP" .and. Empty(SE5->E5_LOTE)
						If Empty(SE5->E5_FILORIG)
							nRecSe5 := Recno()
							dbGoto(nRecSE5-1)
							cFilOrig := SE5->E5_FILORIG
							dbGoto(nRecSe5)
						Else
							cFilOrig := SE5->E5_FILORIG
						Endif			
					Endif
					//Verifico se o movimento pertence ao titulo pois posso, quando os arquivos 
					// forem exclusivos, ter titulos com mesma chave nas diferentes filiais
					If cFilOrig != SE2->E2_FILIAL
						SE5->(dbSkip())
						Loop
					Endif		
				Endif

				cSeq	  := SE5->E5_SEQ
		
				While !SE5->(Eof()) .and. ;
					SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) == ;
					xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+cSeq
		
			      //Movimento de inclusão do PA
					If SE5->E5_TIPODOC == "PA"
						SE5->(dbSkip())
						Loop
					EndIF
			
					IF SE5->E5_SITUACAO == "C" .or. ;
						SE5->E5_TIPODOC == "ES"
						nSituaca := 2
					Else
						nSituaca := 1
					Endif

					nCorrec := 0
					nJuros  := 0
					nMulta  := 0
					nDescont:= 0
					nValPag := 0
					cMotivo := ""
					nPis    := 0
					nCofins := 0
					nCsll   := 0
								
					If ( SE5->E5_TIPODOC $"VL#BA#V2#ES#CP" )
						nValPag	:= SE5->E5_VALOR
						cMotivo	:= SE5->E5_MOTBX 
						If SE5->E5_MOTBX == "CMP"
							nJuros := SE5->E5_VLJUROS
							nDescont := SE5->E5_VLDESCO
							nCorrec := SE5->E5_VLCORREC
						Endif
                  //Impostos Lei 10925
						If lPccBaixa .and. Empty(E5_PRETPIS) .and. !(E5_MOTBX == "PCC")
							nPis    := SE5->E5_VRETPIS
							nCofins := SE5->E5_VRETCOF
							nCsll   := SE5->E5_VRETCSLL
						Endif			

					Endif
			
					IF SE5->E5_TIPODOC$"CMüC2/CX/VM"
						nCorrec := SE5->E5_VALOR
					Endif
					If SE5->E5_TIPODOC$"DCüC2"
						nDescont := SE5->E5_VALOR
					Endif
			
					IF SE5->E5_TIPODOC$"MTüM2"
						nMulta  := SE5->E5_VALOR
					Endif
			
					If SE5->E5_TIPODOC$"JRüJ2"
						nJuros  := SE5->E5_VALOR
					Endif
			
					Reclock("cNomeArq",.T.)
					cNomeArq->OK			:=	nSituaca
					cNomeArq->DATAX		:= SE5->E5_DATA
//					cNomeArq->JUROS		:= nJuros
//					cNomeArq->MULTA		:= nMulta
//					cNomeArq->CORRECAO	:= nCorrec
//					cNomeArq->DESCONTOS  := nDescont
//					cNomeArq->PIS        := nPis
//					cNomeArq->COFINS     := nCofins
//					cNomeArq->CSLL       := nCsll
					cNomeArq->VALORPAGO  := nValPag
					cNomeArq->MOTIVO 	 	:= cMotivo
					cNomeArq->DATACONT	:= SE5->E5_DTDIGIT
					cNomeArq->DATADISP	:= SE5->E5_DTDISPO
//					cNomeArq->LOTE		 	:= SE5->E5_LOTE
					cNomeArq->HISTORICO  := SE5->E5_HISTOR
					cNomeArq->BANCO		:= SE5->E5_BANCO
					cNomeArq->AGENCIA	 	:= SE5->E5_AGENCIA
					cNomeArq->CONTA		:= SE5->E5_CONTA
					cNomeArq->NROCHEQUE	:= SE5->E5_NUMCHEQUE
					If Empty(SE5->E5_IDENTEE)
						cNomeArq->DOCUMENTO  := Substr(SE5->E5_DOCUMEN,1,3)+"-"+;
														Substr(SE5->E5_DOCUMEN,4,aTamSX3[1])+"-"+;
														Substr(SE5->E5_DOCUMEN,aTamSX3[1]+4,1)
					Else
						cNomeArq->DOCUMENTO := SE5->E5_IDENTEE
					EndIf
//					cNomeArq->FILIAL  	:= SE5->E5_FILIAL
					cNomeArq->RECONC		:= SE5->E5_RECONC
			
					If !Empty(SE5->E5_RECONC)
						_nTotPgto +=nValPag
					EndIf

					MsUnlock()
					dbSelectArea("SE5")
					SE5->( dbSkip() )
				Enddo
			Enddo
		Endif
		dbSelectArea("SM0")
		dbSkip()
	Enddo
	//Se o SE5 for compartilhado eu leio apenas uma vez.
	If !lExclusivo
		Exit
	Endif
Next
SM0->(dbGoTo(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

dbSelectArea("SE5")
dbSetOrder(1)
dbSeek(xFilial("SE5"))
Return()

Static Function TOTINCO

_nTotPgto := 0

dbSelectArea("SE2")
dbSetOrder(1)
DbSeek(xFilial("SE2")+PA9->(PA9_PREFIX+PA9_NUM+" "+PA9_TIPO+PA9_FORNEC+PA9_LOJA ))

dbSelectArea("SE5")
dbSetOrder(7)
If dbSeek(xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
	While !SE5->(Eof()) .and. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) ==	xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		If	(SE5->E5_RECPAG == "P" .AND. SE5->E5_TIPODOC == "ES") .OR. ;
			(SE5->E5_RECPAG 	== "R" .and. SE5->E5_TIPODOC != "ES" .AND. ;
			!(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
			SE5->(dbSkip())
			Loop
		EndIF
		
		If !Empty(xFilial("SE5")) .and. !Empty(xFilial("SE2"))
			//Busca movimento de compensacao em outra filial
			cFilOrig := SE5->E5_FILIAL
			If SE5->E5_MOTBX == "CMP" .and. Empty(SE5->E5_LOTE)
				If Empty(SE5->E5_FILORIG)
					nRecSe5 := Recno()
					dbGoto(nRecSE5-1)
					cFilOrig := SE5->E5_FILORIG
					dbGoto(nRecSe5)
				Else
					cFilOrig := SE5->E5_FILORIG
				Endif			
			Endif
			If cFilOrig != SE2->E2_FILIAL
				SE5->(dbSkip())
				Loop
			Endif		
		Endif

		cSeq	  := SE5->E5_SEQ
	
		While !SE5->(Eof()) .and. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) == xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+cSeq

		      //Movimento de inclusão do PA
				If SE5->E5_TIPODOC == "PA"
					SE5->(dbSkip())
					Loop
				EndIF
			
				IF SE5->E5_SITUACAO == "C" .or. ;
					SE5->E5_TIPODOC == "ES"
					nSituaca := 2
				Else
					nSituaca := 1
				Endif

				nCorrec := 0
				nJuros  := 0
				nMulta  := 0
				nDescont:= 0
				nValPag := 0
				cMotivo := ""
				nPis    := 0
				nCofins := 0
				nCsll   := 0
								
				If ( SE5->E5_TIPODOC $"VL#BA#V2#ES#CP" )
					nValPag	:= SE5->E5_VALOR
					cMotivo	:= SE5->E5_MOTBX 
					If SE5->E5_MOTBX == "CMP"
						nJuros := SE5->E5_VLJUROS
						nDescont := SE5->E5_VLDESCO
						nCorrec := SE5->E5_VLCORREC
					Endif
                  //Impostos Lei 10925
					If Empty(E5_PRETPIS) .and. !(E5_MOTBX == "PCC")
						nPis    := SE5->E5_VRETPIS
						nCofins := SE5->E5_VRETCOF
						nCsll   := SE5->E5_VRETCSLL
					Endif			
				Endif
			
				IF SE5->E5_TIPODOC$"CMüC2/CX/VM"
					nCorrec := SE5->E5_VALOR
				Endif
				If SE5->E5_TIPODOC$"DCüC2"
					nDescont := SE5->E5_VALOR
				Endif
				IF SE5->E5_TIPODOC$"MTüM2"
					nMulta  := SE5->E5_VALOR
				Endif
				If SE5->E5_TIPODOC$"JRüJ2"
					nJuros  := SE5->E5_VALOR
				Endif
		
				If !Empty(SE5->E5_RECONC)
					_nTotPgto +=nValPag
				EndIf

				dbSelectArea("SE5")
				SE5->( dbSkip() )
			Enddo
		Enddo
EndIf
Return(_nTotPgto)
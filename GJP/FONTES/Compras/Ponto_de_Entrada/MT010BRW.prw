#INCLUDE 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT010BRW  ºAutor  ³Lucas Riva Tsuda    º Data ³  12/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Disponibiliza os acessos para amarração de Produto x Filial º±±
±±º          ³na tela de browse do cadastro de produto.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico GJP                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010BRW

Local aRotUser := {}   
Local aOpcoes  := {{ 'Amarração', 'U_ProdXFil()', 0, 2}, { 'Cadastro', "AxCadastro('SZ1','Produto x Filial', 'U_VldExcZ1()', 'U_VldOKZ1()')", 0, 3}}

AAdd( aRotUser, { 'Produto x Filial', aOpcoes , 0, 2 } )

Return aRotUser                                              

  
User Function AxGJPPRD()

AxCadastro('SZ1','Produto x Filial', 'U_VldExcZ1()', 'U_VldOKZ1()')

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProdXFil  ºAutor  ³Lucas Riva Tsuda    º Data ³  12/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza a tabela SZ1 (Produto x Filial)                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico GJP                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ProdXFil()

Local aFil := U_MatFilCalc( .T. )    

For nX := 1 To Len(aFil)
	If aFil[nX][1]
	    dbselectarea("SZ1")
	    SZ1->(dbsetorder(2))
		If !SZ1->(MsSeek(aFil[nX][2]+aFil[nX][3]+SB1->B1_COD))
			
			RecLock("SZ1",.T.)
			SZ1->Z1_PRODUTO := SB1->B1_COD
			SZ1->Z1_XEMP    := aFil[nX][2]
			SZ1->Z1_XFILIAL := aFil[nX][3]
			SZ1->Z1_DESCFIL := aFil[nX][4]//Posicione("SM0",1,aFil[nX][2]+aFil[nX][3],"M0_FILIAL")
			SZ1->(MsUnlock())
			
		EndIf
	EndIf
Next

Return                                                                                               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldExcZ1  ºAutor  ³Lucas Riva Tsuda    º Data ³  12/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida exclusão de registro da SZ1 no AxCadastro            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico GJP                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VldExcZ1    

Local lRet := .T.

SBZ->(DbSetOrder(1))
If SBZ->(MsSeek(SZ1->(Z1_XFILIAL+Z1_PRODUTO)))

	MsgAlert("Este produto já possui Indicador cadastrado para esta filial. Exclua o Indicador para depois remover a amarração." )
	lRet := .F.

EndIf

Return lRet                   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldOKZ1   ºAutor  ³Lucas Riva Tsuda    º Data ³  12/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação TudoOk no AxCadastro                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico GJP                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VldOKZ1            

Local lRet := .T.   

//Sem validações pois não é permitida alteração nos registros (X3_WHEN)
SZ1->(DbSetOrder(2))
If SZ1->(MsSeek(M->Z1_XEMP+M->Z1_XFILIAL+M->Z1_PRODUTO))

	MsgAlert("Este produto já consta cadastrado para esta empresa/filial" )
	lRet := .F.

EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ MatFilCalc (Original MA330FCalc)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Microsiga Software S/A                   ³ Data ³ 22/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Funcao para selecao das filiais para calculo por empresa   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1 = Indica se apresenta tela para selecao              ³±±
±±³           ³ ExpA2 = Lista com as filiais a serem consideradas (Batch)  ³±±
±±³           ³ ExpN6 = 0=Legado/1=CNPJ iguais/2=CNPJ+IE iguais/3=CNPJ Pai ³±±
±±³ÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Retorno    ³ Array: aFilsCalc[3][n]                                     ³±±
±±³           ³ aFilsCalc[1][n]:           - Logico                        ³±±
±±³           ³ aFilsCalc[2][n]: Filial    - Caracter                      ³±±
±±³           ³ aFilsCalc[3][n]: Descricao - Caracter                      ³±±
±±³           ³ aFilsCalc[4][n]: CNPJ      - Caracter                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MatFilCalc(lMostratela,aListaFil,lChkUser,lConsolida,nOpca,nValida,lContEmp)
Local aFilsCalc	:= {}
// Variaveis utilizadas na selecao de categorias
Local oChkQual,lQual,oQual,cVarQ
// Carrega bitmaps
Local oOk       := LoadBitmap(GetResources(),"LBOK")
Local oNo       := LoadBitmap(GetResources(),"LBNO")
// Variaveis utilizadas para lista de filiais
Local nx        := 0
Local nAchou    := 0
Local lMtFilcal	:= ExistBlock('MTFILCAL')
Local aRetPE	:= {}           
Local lIsBlind  := IsBlind()

Local aAreaSM0	:= SM0->(GetArea())
Local aSM0      := FWLoadSM0(.T.,,.T.) 

Local cSelCNPJIE:=""
Local nSelCNPJIE:=0
Local _xEmpAux := ""
Local _xFilAux := ""
Local _aEmpSM0 := {}

Default nValida	:= 0 //0=Legado Seleção Livre
Default lMostraTela	:= .F.
Default aListaFil	:= {{.T., cFilAnt}}  
Default lchkUser	:= .T.
Default lConsolida	:= .F.
Default lContEmp 	:= .F.
Default nOpca		:= 1

//-- Carrega filiais da empresa corrente 
lChkUser := !GetAPOInfo("FWFILIAL.PRW")[4] < CTOD("10/01/2013") 

_xEmpAux := cEmpAnt
_xFilAux := cFilAnt

/*
dbselectarea("SM0")
SM0->(dbgotop())
While SM0->(!EOF())
	If !(aScan(_aEmpSM0,{|x| AllTrim(x[1]) == SM0->M0_CODIGO}) > 0)
		aAdd(_aEmpSM0,{SM0->M0_CODIGO})
	EndIf
	SM0->(dbskip())
EndDo

aSort(_aEmpSM0,,,{|x,y| x[1] < y[1]})

For i:=1 to Len(_aEmpSM0)
	
	cEmpAnt := _aEmpSM0[i][1]
*/	
//	RpcSetType( 3 )
//	RpcSetEnv( cEmpAnt)
/*
	If SM0->(dbseek(cEmpAnt))
	aEval(aSM0,{|x| If(x[SM0_GRPEMP] == cEmpAnt .And.; 
		              Iif (!lContEmp ,x[SM0_EMPRESA] == FWCompany(),.T.) .And.; 
		              (!lChkUser .Or. x[SM0_USEROK].Or. lIsBlind) .And.; 
		              (x[SM0_EMPOK] .Or. lIsBlind),;
			          aAdd(aFilsCalc,{.F.,x[SM0_GRPEMP],x[SM0_CODFIL],x[SM0_NOMRED],x[SM0_CGC],Posicione("SM0",1,x[SM0_GRPEMP]+x[SM0_CODFIL],"M0_INSC"), ;
			               Posicione("SM0",1,x[SM0_GRPEMP]+x[SM0_CODFIL],"M0_INSCM")}),;
				      NIL)})
*/
aSort(aSM0,,,{|x,y| x[1]+x[2] < y[1]+y[2]})

For i:=1 to len(aSM0)
    dbselectarea("SZ1")
    dbsetorder(2)
    If dbseek(aSM0[i][1]+aSM0[i][2]+SB1->B1_COD)
		aAdd(aFilsCalc,{.T.,aSM0[i][1],aSM0[i][2],aSM0[i][7],aSM0[i][18],Posicione("SM0",1,aSM0[i][1]+aSM0[i][2],"M0_INSC"), Posicione("SM0",1,aSM0[i][1]+aSM0[i][2],"M0_INSCM")})
	Else
		aAdd(aFilsCalc,{.F.,aSM0[i][1],aSM0[i][2],aSM0[i][7],aSM0[i][18],Posicione("SM0",1,aSM0[i][1]+aSM0[i][2],"M0_INSC"), Posicione("SM0",1,aSM0[i][1]+aSM0[i][2],"M0_INSCM")})
	EndIf
Next i
//	EndIf
//	RpcClearEnv()
//Next i

//cEmpAnt := _xEmpAux
//cFilAnt := _xFilAux

//SM0->(dbseek(cEmpAnt+cFilAnt))

If lConsolida
	aSort(aFilsCalc,,,{|x,y| x[4]+x[5]+x[6]+x[2] < y[4]+y[5]+x[6]+y[2]}) //-- Ordena por CNPJ, IE, Insc.Municipal e Codigo de Filial para facilitar a quebra de rotinas consolidadas
EndIf

//-- Monta tela para selecao de filiais
If lMostraTela
	If lMtFilCal
		//-- Ponto de entrada para montagem de tela alternativa p/ selecao de filiais
		aFilsCalc := If(ValType(aRetPE := ExecBlock('MTFILCAL',.F.,.F.,{aFilsCalc})) == "A",aRetPE,aFilsCalc)
	Else
		DEFINE MSDIALOG oDlg TITLE "Seleção de Filiais" STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
		oDlg:lEscClose := .F.
		@ 05,15 TO 125,300 LABEL "Marque as filiais a serem consideradas no processamento" OF oDlg  PIXEL
//		If lConsolida
//			@ 15,20 LISTBOX oQual VAR cVarQ Fields HEADER "",OemToAnsi(STR0035),OemToAnsi(STR0039),OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0070) SIZE 273,105 ON DBLCLICK (aFilsCalc:=MtFClTroca(oQual:nAt,aFilsCalc,nValida,@nSelCNPJIE,@cSelCNPJIE),oQual:Refresh()) NoScroll OF oDlg PIXEL
//			bLine := {|| {If(aFilsCalc[oQual:nAt,1],oOk,oNo),aFilsCalc[oQual:nAt,2],aFilsCalc[oQual:nAt,3],Transform(aFilsCalc[oQual:nAt,4],"@R 99.999.999/9999-99"),aFilsCalc[oQual:nAt,5],aFilsCalc[oQual:nAt,6]}}
//		Else
			@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Inverte Seleção" SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aFilsCalc, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.))
			@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Empresa","Filial","Descrição","CNPJ" SIZE 273,090 ON DBLCLICK (aFilsCalc:= StaticCall(SIGACUS,MtFClTroca,oQual:nAt,aFilsCalc),oQual:Refresh()) NoScroll OF oDlg PIXEL
			bLine := {|| {If(aFilsCalc[oQual:nAt,1],oOk,oNo),aFilsCalc[oQual:nAt,2],aFilsCalc[oQual:nAt,3],aFilsCalc[oQual:nAt,4],Transform(aFilsCalc[oQual:nAt,5],"@R 99.999.999/9999-99")}}
//		EndIf
		oQual:SetArray(aFilsCalc)
		oQual:bLine := bLine
		DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION If(StaticCall(SIGACUS,MtFCalOk,@aFilsCalc,.T.,.T.,lConsolida,nValida,@nOpca),oDlg:End(),) ENABLE OF oDlg
		DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION If(StaticCall(SIGACUS,MtFCalOk,@aFilsCalc,.F.,.T.,lConsolida,nValida,@nOpca),oDlg:End(),) ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf
//-- Valida lista de filiais passada como parametro
Else
	//-- Checa parametros enviados
	For nX := 1 to Len(aListaFil)
		If (nAchou := aScan(aFilsCalc,{|x| x[2] == aListaFil[nX,2]})) > 0
			aFilsCalc[nAchou,1] := .T.
		EndIf
	Next nX
	//-- Valida e assume somente filial corrente em caso de problema
	If !(StaticCall(SIGACUS,MtFCalOk,@aFilsCalc,.T.,.F.,lConsolida,nValida,@nOpca))
		For nX := 1 To Len(aFilsCalc)
			//--  Adiciona filial corrente
			aFilsCalc[nX,1] := aFilsCalc[nX,2] == cFilAnt
		Next nX
	EndIf
EndIf
SM0->(RestArea(aAreaSM0))
Return aFilsCalc    

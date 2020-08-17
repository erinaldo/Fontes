#Include "Protheus.ch"
#Include "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Rcomr06  º Autor ³ Sergio Oliveira    º Data ³  Jan/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Pedidos de Compras pendentes de aprovacao.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Rcomr06()

Private Titulo      := "Pedidos Pendentes de Aprovacao"
Private cDesc1      := "Pedidos Pendentes de Aprovacao"
Private cDesc2      := ""
Private cDesc3      := "Pedidos Pendentes de Aprovacao"
Private tamanho   := "G"
Private limite    := 220
Private cString   := "SC7"
Private lEnd      := .F.
Private lContinua := .T.
Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nomeprog  := "Rcomr06"
Private nLastKey  := 0
Private nomeprog  := "Rcomr06"
Private cPerg     := PADR("RcomR6",LEN(SX1->X1_GRUPO))
Private lAbortPrint := .f.
Private cbtxt   := ""
Private cbcont  := 00
Private nlin    := 80
Private m_pag   := 01
Private aOrd        := {}
Private Cabec1      := "  Pedido |  Emissao  | Fornecedor                               | Vencimento |     Valor      | -------------------------------- Memo do Pedido -------------------------------- | Nivel |       Aprovador    | Aprov. Atual"
Private Cabec2      := ""
Private aRegs     := {}

AADD(aRegs,{cPerg,"01","Dt. Emissao PC de  :","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Dt. Emissao PC ate :","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Ref. Aprovadores...:","","","mv_ch3","N",01,0,0,"C","","mv_par03","Todos","","","","","Selecionar","","","","","Presid.Fora/Vez","","","","","Presid.Vez/Atu.","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Pedidos Reprovados.:","","","mv_ch4","N",01,0,0,"C","","mv_par04","Nao Listar","","","","","Listar","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aRegs )

aHelpP01 := { "Periodo inicial de emissao dos Pedidos " }
aHelpP02 := { "Periodo final de emissao dos Pedidos.  " }
aHelpP03 := { "Selecionar: Busca por partes do nome; " ,"Presid.Fora/Vez: Listar pedidos onde e" ,"xiste a necessidade de aprovacao da pr","esidencia fora da vez de aprovacao.   ","Presid.Vez/Atu: Listar Pedidos cuja ve","z atual de aprovasao seja a da Presid." }
aHelpP04 := { "Se desejar listar pedidos reprovados, " ,"basta selecionar a opcao LISTAR.      " }

For wXP := 1 To Len( aRegs )
	PutHelp("P."+cPerg+StrZero(wXP,2)+".",&("aHelpP"+StrZero(wXP,2)),{},{},.T.)
Next

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa( { || Rcomr06a(Cabec1,Cabec2,Titulo,nLin) }, Titulo )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ Rcomr06a º Autor ³ Sergio Oliveira    º Data ³  Jan/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Processamento do programa.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr06.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Rcomr06a(Cabec1,Cabec2,Titulo,nLin)

Local cQuery, cStrAprovs, nCntView
Local cEol      := Chr(13)+Chr(10)
Local nLineSize := 80, nTabSize  := 2, nTamSCR := TamSX3('CR_NUM')[1], nTotPeds := 0, nTtPed := 0
Local lWrap     := .t., l1Loop := .t., l2Loop := .t.
Local cAnd      := "", cStrApr := ""
Private aListBox := {}

SCR->( DbSetOrder(2) ) // CR_FILIAL+CR_TIPO+CR_NUM+CR_USER

//    *** Original ***
//cQuery := " SELECT C7_EMISSAO, C7_NUM, A2_NOME, C7_COND, "+cEol
//cQuery += " SUM( ( C7_TOTAL+C7_VALIPI+C7_SEGURO+C7_DESPESA+C7_VALFRE ) - C7_VLDESC ) AS TOTPED, "+cEol
//cQuery += " CR_USER, CR_NIVEL "+cEol

cQuery := " SELECT C7_EMISSAO, C7_NUM, A2_NOME, C7_COND, "+cEol
cQuery += " SUM( ( C7_TOTAL+C7_VALIPI+C7_SEGURO+C7_DESPESA+C7_VALFRE ) - C7_VLDESC ) AS TOTPED "+cEol
cQuery += " FROM "+RetSqlName('SC7')+" SC7, "+RetSqlName('SCR')+" SCR, "+RetSqlName('SA2')+" SA2, "+RetSqlName('SAK')+" SAK "+cEol
cQuery += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "+cEol
cQuery += " AND   C7_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+cEol
cQuery += " AND   C7_CONAPRO = 'B' "+cEol
cQuery += " AND   SC7.D_E_L_E_T_ = ' ' "+cEol
cQuery += " AND   A2_FILIAL  = '"+xFilial('SA2')+"' "+cEol
cQuery += " AND   A2_COD     = C7_FORNECE "+cEol
cQuery += " AND   A2_LOJA    = C7_LOJA "+cEol
cQuery += " AND   SA2.D_E_L_E_T_ = ' ' "+cEol
cQuery += " AND   CR_FILIAL  = '"+xFilial('SCR')+"' "+cEol
cQuery += " AND   CR_TIPO    = 'PC' "+cEol
cQuery += " AND   CR_NUM     = C7_NUM "+cEol
cQuery += " AND   SCR.D_E_L_E_T_ = ' ' "  +cEol
cQuery += " AND   AK_FILIAL  = '"+xFilial('SAK')+"' " +cEol
cQuery += " AND   AK_USER    = CR_USER " +cEol
cQuery += " AND   SAK.D_E_L_E_T_ = ' ' " +cEol
If MV_PAR04 == 1
	If MV_PAR03 == 1 // Todos os Aprovadores
		cQuery += " AND   CR_STATUS IN('02','01') "+cEol
	EndIf
	If MV_PAR03 == 2 // Especificar filtro segmentado
		cOpcVez := AllTrim( U_PegAprovs() )
		If Len( aListBox ) == 0 .Or. Ascan( aListBox, { |h| h[1] == .t. } ) == 0 // Nenhum aprovador selecionado
			cQuery += " AND  AK_USER IN('') " +cEol
		Else
			For wXP := 1 To Len( aListBox )
				If aListBox[wXP][1]        // <- Selecionado .t.
					cStrApr += IIF( !Empty(cStrApr),",","" )+"'"+aListBox[wXP][2]+"'"
				EndIf
			Next
			cQuery += " AND  AK_USER IN("+cStrApr+") " +cEol
		EndIf
		If cOpcVez == "3" //-- Todos
			cQuery += " AND   CR_STATUS IN('02','01') "+cEol
		ElseIf cOpcVez == "2" //-- Fora da Vez
			cQuery += " AND   CR_STATUS = '01' "+cEol
		ElseIf cOpcVez == "1" //-- Na da Vez
			cQuery += " AND   CR_STATUS = '02' "+cEol
		Else
			cQuery += " AND   CR_STATUS IN('02','01') "+cEol
		EndIf
	EndIf
	If MV_PAR03 == 4 // Vez da Precisencia
		cQuery += " AND   AK_X_PRESI = 'S' " +cEol
		cQuery += " AND   CR_STATUS = '02' "+cEol
	EndIf
	If MV_PAR03 == 3 // Presidencia Fora da Vez
		cQuery += " AND   C7_NUM IN( SELECT C7_NUM " +cEol
		cQuery += "                  FROM "+RetSqlName('SCR')+" SCR, "+RetSqlName('SAK')+" SAK " +cEol
		cQuery += "                  WHERE CR_FILIAL  = '"+xFilial('SC7')+"' " +cEol
		cQuery += "                  AND   CR_TIPO    = 'PC' " +cEol
		cQuery += "                  AND   CR_NUM     = C7_NUM " +cEol
		cQuery += "                  AND   CR_STATUS IN('01') " +cEol
		cQuery += "                  AND   SCR.D_E_L_E_T_ = ' ' "+cEol
		cQuery += "                  AND   AK_FILIAL  = '"+xFilial('SAK')+"' " +cEol
		cQuery += "                  AND   AK_USER    = CR_USER " +cEol
		cQuery += "                  AND   AK_X_PRESI = 'S' " +cEol
		cQuery += "                  AND   SAK.D_E_L_E_T_ = ' ' ) "+cEol
		cQuery += "                  AND   CR_STATUS <> '02' "+cEol
	EndIf
Else
	cQuery += " AND   CR_STATUS IN('04') "+cEol
EndIf
//      *** Original
//cQuery += " GROUP BY C7_EMISSAO, C7_NUM, A2_NOME, C7_COND, CR_USER, CR_NIVEL "+cEol
//cQuery += " ORDER BY C7_NUM, CR_NIVEL "

cQuery += " GROUP BY C7_EMISSAO, C7_NUM, A2_NOME, C7_COND "+cEol

nCntView := U_MontaView( cQuery, "Work" )

Work->( DbGoTop() )

ProcRegua( nCntView )

While l1Loop .And. !Work->( Eof() )
	
	IncProc()
	
	If nLin > 60
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin ++
	EndIf
	
	//          10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
	//           |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
	//  123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
	//         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
	//  Pedido |  Emissao  | Fornecedor                               | Vencimento |     Valor      | -------------------------------- Memo do Pedido -------------------------------- | Nivel |       Aprovador    | Aprov. Atual
	//  999999   99/99/9999  XXXXXXXXXXXXXXXX - 40 - XXXXXXXXXXXXXXXX  99/99/9999    999,999,999.99   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 80 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    99    xxxxxxxx 20 xxxxxxxx    <---
	//
	
	l2Loop  := .t.
	cChave  := Work->C7_NUM
	
	SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+Work->C7_NUM ) )
	
	@ nLin, 001 Psay Work->C7_NUM
	@ nLin, 010 Psay Stod(Work->C7_EMISSAO)
	@ nLin, 022 Psay Left( Work->A2_NOME, 40 )
	dDtVenc := Condicao(Work->TOTPED, Work->C7_COND,,Stod(Work->C7_EMISSAO))
	If Type('dDtVenc[1][1]') $ "U"
		dDtVenc := Ctod('')
	Else
		dDtVenc := dDtVenc[1][1]
	EndIf
	nTtPed := CalcPed()
	@ nLin, 064 Psay dDtVenc
	@ nLin, 078 Psay Transform( nTtPed,"@E 999,999,999.99" )
	
	nTotPeds += nTtPed
	
	BuscaProv()
	
	While l2Loop // Work->C7_PEDIDO == cChave
		
		// Impressao do memo dos pedidos:
		
		nLines := MlCount( SC7->C7_XJUSTIF, nLineSize, nTabSize, lWrap )
		
		For nCurrLine := 1 To nLines // A partir da dois por causa da primeira linha
			
			If nLin > 60
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin += 2
			Endif
			@ nLin, 095 Psay MemoLine( SC7->C7_XJUSTIF, nLineSize, nCurrLine, nTabSize, lWrap )
			
			If !WorkW->( Eof() ) .And. Left(WorkW->PEDIDO,6) == SC7->C7_NUM
				If nLin > 60
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin += 2
				Endif
				@ nLin, 179 Psay WorkW->CR_NIVEL
				@ nLin, 185 Psay Left( UsrFullName( WorkW->CR_USER ),20 )
				
				If WorkW->CR_STATUS$'02/04'
					@ nLin, 209 Psay "<---"
				EndIf
				WorkW->( DbSkip() )
			EndIf
			
			nLin ++
			
		Next
		
		If !WorkW->( Eof() ) .And. Left(WorkW->PEDIDO,6) == SC7->C7_NUM
			If nLin > 60
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin += 2
			Endif
			@ nLin, 179 Psay WorkW->CR_NIVEL
			@ nLin, 185 Psay Left( UsrFullName( WorkW->CR_USER ), 20 )
			If WorkW->CR_STATUS$'02/04'
				@ nLin, 209 Psay "<---"
			EndIf
			
			nLin ++
			WorkW->( DbSkip() )
		Else
			l2Loop := .f.
		EndIf
		
	EndDo
	
	@ nLin, 001 Psay __PrtThinLine()
	nLin++
	Work->( DbSkip() )
	
	If Work->( Eof() )
		l1Loop := .f.
	EndIf
	
EndDo

//          10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
//           |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
//  123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
//         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
//  Pedido |  Emissao  | Fornecedor                               | Vencimento |     Valor      | -------------------------------- Memo do Pedido -------------------------------- | Nivel |       Aprovador    | Aprov. Atual
//  999999   99/99/9999  XXXXXXXXXXXXXXXX - 40 - XXXXXXXXXXXXXXXX  99/99/9999    999,999,999.99   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 80 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    99    xxxxxxxx 20 xxxxxxxx    <---
//                                                                             9,999,999,999.99

@ nLin, 076 Psay Transform( nTotPeds,"@E 9,999,999,999.99" )

Work->( DbCloseArea() )

Set Device To Screen

If aReturn[5]==1
	DbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

Ms_Flush()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ PegAprovsº Autor ³ Sergio Oliveira    º Data ³  Jan/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna uma string no formato sql contendo os codigos dos  º±±
±±º          ³ aprovadores selecionados.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PegAprovs()

Local   aArea   := GetArea()
Local  aCombo1	:= {"1=Sim (Na Vez)","2=Não (Fora da Vez)","3=Todos"}
Local  cCombo1  := "3"              

Private cString := ''
Private oOk     := Loadbitmap( GetResources(), 'LBOK')
Private oNo     := Loadbitmap( GetResources(), 'LBNO')
Private lOpcoes := .F.
Private nConta  := 0
Private oMens1
Private oFont   := TFont():New("Tahoma",9,,,.T.,,,,,.F.) // Com Negrito

SAK->( DbGotop() )
IncProc("Montando Aprovadores")
While !SAK->( Eof() )
	
	If Ascan( aListBox, { |x| x[2] == SAK->AK_USER } ) == 0
		AADD(aListBox,{.f.,SAK->AK_USER,Upper(SAK->AK_NOME),SAK->AK_X_PRESI } )
	EndIf
	
	SAK->( DbSkip() )
	
EndDo

If Len(aListBox) > 0
	
	Asort( aListBox ,,,{ |x,y| x[3] < y[3] } )
	
	DEFINE MSDIALOG oDlg1 TITLE "Selecao de Aprovadores" FROM  175,059 TO 458,741 PIXEL OF oMainWnd
	@ 010,030 Say "Selecao dos Aprovadores para o Relatorio" Color 8388608 Object oMens1 SIZE 300,10
	
	@ 025,030 Say "Aprovador na Vez" Color 8388608 Object oMens1 SIZE 100,10
	@ 025,140 ComboBox cCombo1 Items aCombo1 Size 150 , 10 PIXEL of oDlg1
	
	@ 040,004 LISTBOX oListBox VAR cVar FIELDS HEADER	" "			,;
	"Usuario"  ,;
	"Nome"    ,;
	"Presid?"  SIZE 330,080 PIXEL of oDlg1 ;
	ON dblClick (aListBox:=DesTroca(oListBox:nAt,aListBox),oListBox:Refresh())
	oListBox:SetArray(aListBox)
	oListBox:bLine:={|| {If(aListBox[oListBox:nAt,1],oOk,oNo)  ,;
	aListBox[oListBox:nAt,2],;
	aListBox[oListBox:nAt,3],;
	aListBox[oListBox:nAt,4] }}
	
	@ 125,060 BUTTON "_Localizar"   SIZE 40,15 ACTION Localiz(oListBox)
	@ 125,130 BUTTON "_Desmarcar" 	SIZE 40,15 ACTION DesMarkAll()
	@ 125,180 BUTTON "_Marcar" 		SIZE 40,15 ACTION MarkAll()
	@ 125,230 BUTTON "_Confirmar"   SIZE 40,15 ACTION Confirmar(oDlg1)
	@ 125,280 BUTTON "_Sair" 		SIZE 40,15 ACTION Close(oDlg1)
	
	oMens1:ofont:=ofont
	Activate MsDialog oDlg1 Centered
	
Else
	Aviso("Sem Aprovadores","Nao ha aprovadores cadastrados.",{"Voltar"},3,"APROVADORES",,"PCOLOCK")
EndIf

RestArea(aArea)
Return cCombo1

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Localiz  ³ Autor ³ Sergio Oliviera       ³ Data ³ Jan/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Premitir a pesquisa do aprovador.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Localiz(oListBox)

Local o_Djialog
Local cNomApr := Space(Len(UsrFullName(__cUserId)))

@ 085,024 To 175,552 Dialog o_Djialog Title "Busca de Aprovadores"
@ 001,002 To 043,216
@ 001,217 To 043,257 Title "Opções"
@ 011,031 Say "Digite o nome ou parte do nome do aprovador" Size 114,08
@ 024,009 Get cNomApr Picture "@!" Size 171,10
@ 017,219 Button "_Buscar" Size 36,16 Action( MenIgSP(oListBox, cNomApr, o_Djialog) )

Activate Dialog o_Djialog Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MenIgSP  ³ Autor ³ Sergio Oliviera       ³ Data ³ Jan/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consistencia dos valores digitados pelo usuario.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenIgSP(oListBox, cNomApr,o_Djialog)

Local lAxou := .f.

For wXP := 1 To Len( aListBox )
	If AllTrim(cNomApr) $ aListBox[wXP][3]
		lAxou := .t.
		oListBox:nat := wXP
	EndIf
Next

If !lAxou
	Aviso( 'Nao Encontrado','Nao foi encontrada nenhuma referencia!',{'Ok'} )
EndIf

o_Djialog:End()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Destroca ³ Autor ³ Sergio Oliviera       ³ Data ³ Jan/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ No clique duplo marcar ou desmarcar o item desejado.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function DesTroca(nIt,aVetor)

aVetor[nIt,1] := !aVetor[nIt,1]

Return(aVetor)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Atutroca ³ Autor ³ Sergio Oliviera       ³ Data ³ Jan/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Compatibilizacao.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AtuTroca(nIt,aVetor)

aVetor[nIt,1] := aVetor[nIt,1]

Return(aVetor)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MarkAll  ³ Autor ³ Sergio Oliviera       ³ Data ³ Jan/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marcar todos os itens.                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MarkAll()

For x:=1 To Len(aListBox)
	aListBox[x,1]	:= .T.
Next x

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DesMarkAll³ Autor ³ Sergio Oliviera       ³ Data ³ Jan/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Desmarcar todos os itens.                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function DesMarkAll()

For x:=1 To Len(aListBox)
	aListBox[x,1]	:= .F.
Next x

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Confirmar³ Autor ³ Sergio Oliviera       ³ Data ³ Jan/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Confirma a utilizacao dos aprovadores.                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Confirmar(pcDialogo)

If Ascan( aListbox, { |e| e[1] == .t. } ) == 0
	Aviso("Sem Selecao","Nao ha aprovadores selecionados.",{"Voltar"},3,"APROVADORES",,"PCOLOCK")
EndIf

pcDialogo:End()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³BuscaProv º Autor ³ Sergio Oliveira    º Data ³  Mar/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Cria a Query com o SCR de cada pedido de compras.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr06.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function BuscaProv()

Local cWorkW := ''

cWorkW += " SELECT CR_NUM AS PEDIDO, CR_NIVEL, CR_STATUS, CR_USER "
cWorkW += " FROM "+RetSqlName('SCR')
cWorkW += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
cWorkW += " AND   CR_TIPO    = 'PC' "
cWorkW += " AND   CR_NUM     = '"+SC7->C7_NUM+"' "
cWorkW += " AND   D_E_L_E_T_ = ' ' "
cWorkW += " ORDER BY CR_NIVEL "

U_MontaView( cWorkW, "WORKW" )

WorkW->( DbGoTop() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CalcPed  ºAutor  ³ Sergio Oliveira    º Data ³  Mar/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Obtem o total do pedido de compras posicionado.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomm97.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CalcPed()

Local cQryPC := ''

cQryPC += " SELECT SUM(C7_QUANT*C7_PRECO) AS TOTPED, "
cQryPC += " SUM(C7_QUJE*C7_PRECO) AS TOTENT "
cQryPC += " FROM "+RetSqlName('SC7')
cQryPC += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
cQryPC += " AND   C7_NUM     = '"+SC7->C7_NUM+"'
cQryPC += " AND   D_E_L_E_T_ = ' '

U_MontaView( cQryPC, 'TotalPed' )

TotalPed->( DbGoTop() )

Return( TotalPed->TOTPED )
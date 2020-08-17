#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GravaFF  ³ Autor ³ Daniel G.Jr. TI1239   ³ Data ³ 19/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava campos nos PVs FullFilment                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico CSU                  							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GravaFF()

@ 200,1 TO 380,380 DIALOG o_dlg TITLE OemToAnsi("Gravação Campos PVs FullFilment")
@ 02,10 TO 080,180
@ 10,018 Say OemToAnsi("Esta rotina grava os campos especificos do Pedido de Vendas ")
@ 18,018 Say OemToAnsi("importados pelo FullFilment.")
@ 26,018 Say OemToAnsi("")
@ 34,018 Say OemToAnsi("")
@ 65,068 BMPBUTTON TYPE 01 ACTION OkProc()
@ 65,098 BMPBUTTON TYPE 02 ACTION Close(o_dlg)
Activate Dialog o_dlg Centered

if Select( "TRB" ) > 0
	dbSelectArea( "TRB" )
	dbCloseArea()
endif

Return

Static Function OkProc()

Private bProcessa, cTitulo, cMsg, lAborta, cQuery

cQuery := "SELECT SC6.R_E_C_N_O_ NREC "
cQuery += "FROM "
cQuery += RetSQLName("SC6")+ " SC6, "
cQuery += RetSQLName("SC5")+ " SC5 "
cQuery += "WHERE "
cQuery += "C6_FILIAL='"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_<>'*' "
cQuery += "AND C5_FILIAL='"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_<>'*' "
cQuery += "AND C5_CSNFF<>'"+Space(TamSX3("C5_CSNFF")[1])+"' AND C5_FILIAL='03' AND C5_EMISSAO>='20070523' "
cQuery += "AND C6_NUM = C5_NUM "

cQuery := ChangeQuery(cQuery)

MemoWrite("C:\GravaFF.sql",cQuery)

If Select("TMP")<>0
	dbSelectArea("TMP" )
	dbCloseArea()
Endif				
	  
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP")
                             
bProcessa := { |lFim| Grava(@lFim) }
cTitulo   := "Grava Campos"
cMsg      := "Gravando campos específicos... Aguarde..."
lAborta   := .T.
Processa( bProcessa, cTitulo, cMsg, lAborta )

Return


Static Function Grava(lFim)

dbSelectArea("TMP")

ProcRegua(100)

If TMP->(!Eof().And.!Bof())

	TMP->(dbGoTop())

	While TMP->(!Eof())

		IncProc()

		dbSelectArea("SC6")
		SC6->(dbGoTo(TMP->NREC))
		
		RecLock("SC6",.F.)
		SC6->C6_CCUSTO 	:= '0701010000'
		SC6->C6_ITEMD	:= '0902'
		SC6->C6_CLVLDB	:= '999999999'
		SC6->(MsUnLock())

		dbSelectArea("TMP")
		TMP->(dbSkip())

	End

EndIf

Return

#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function AJCT2LIN()
MsAguarde({|lEnd| AJCT2LINA()}, "Atualizando...", "Aguarde", .F.)
Return


STATIC Function AJCT2LINA()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Private cString := "CT2"
Private cPerg := "VLDUNQ"

CriaSx1()
If !Pergunte(cPerg,.T.)
	Return(Nil)
Endif


dbSelectArea("CT2")
dbSetOrder(1)

nReg := RECCOUNT("CT2")
ProcRegua(nReg)

CT2->(DBSEEK(xFilial("CT2")+DTOS(MV_PAR01)+MV_PAR03,.T.))


While !CT2->(EOF())
	
	
	IncProc("Processando...")
	
	
	IF CT2->CT2_DATA > MV_PAR02 .OR. CT2->CT2_DATA < MV_PAR01
		CT2->(DBSKIP())
		LOOP
	ENDIF
	IF CT2->CT2_LOTE > MV_PAR04 .OR. CT2->CT2_LOTE < MV_PAR03
		CT2->(DBSKIP())
		LOOP
	ENDIF
	IF CT2->CT2_SBLOTE > MV_PAR06 .OR. CT2->CT2_SBLOTE < MV_PAR05
		CT2->(DBSKIP())
		LOOP
	ENDIF
	IF CT2->CT2_DOC > MV_PAR08 .OR. CT2->CT2_DOC < MV_PAR07
		CT2->(DBSKIP())
		LOOP
	ENDIF
	
	
	cDATA   := CT2->CT2_DATA
	cLote   := CT2->CT2_LOTE
	cSbLote := CT2->CT2_SBLOTE
	cDoc    := CT2->CT2_DOC
	nSeqLan := 0
	
	cDTNr  := CT2->CT2_DATA
	
	
	//.AND. CT2->CT2_DATA == cDATA .AND. ;
	While !CT2->(EOF()) .AND. CT2->CT2_FILIAL == xFILIAL("CT2") //.AND. CT2->CT2_LOTE == cLote .AND. CT2->CT2_SBLOTE == cSbLote  .AND. ;	CT2->CT2_DOC == cDoc
		



		IF CT2->CT2_DATA > MV_PAR02 
		   EXIT
		ENDIF   

		IF CT2->CT2_DATA > MV_PAR02 .OR. CT2->CT2_DATA < MV_PAR01
			CT2->(DBSKIP())
			LOOP
		ENDIF
		IF CT2->CT2_LOTE > MV_PAR04 .OR. CT2->CT2_LOTE < MV_PAR03
			CT2->(DBSKIP())
			LOOP
		ENDIF
		IF CT2->CT2_SBLOTE > MV_PAR06 .OR. CT2->CT2_SBLOTE < MV_PAR05
			CT2->(DBSKIP())
			LOOP
		ENDIF
		IF CT2->CT2_DOC > MV_PAR08 .OR. CT2->CT2_DOC < MV_PAR07
			CT2->(DBSKIP())
			LOOP
		ENDIF
		
		IF CT2->CT2_DATA <> cDTNr
			nSeqLan := 0
			cDTNr := CT2->CT2_DATA
		endif
		MsProcTXT("Data Processada..  "+dtoc(CT2->CT2_DATA))
		
		nSeqLan := nSeqLan + 1
		RecLock("CT2",.F.)
		CT2->CT2_IDENTC := STRZERO(nSeqLan,3)
		CT2->(MsUnlock())
		CT2->(DBSKIP())
	End
	EXIT
	
	
End


MsgInfo("Fim do Processamento..... OK")

AJCT2LINA()


Return




Static Function CriaSx1()

Local j  := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

cPerg := PADR(cPerg,6)

AADD(aReg,{cPerg,"01","Data Contabil De  ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"02","Data Contabil Ate ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"03","Lote De           ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"04","Lote Ate          ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"05","SubLote De        ?","","","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"06","SubLote Ate       ?","","","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"07","Doc De            ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"08","Doc Ate           ?","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil

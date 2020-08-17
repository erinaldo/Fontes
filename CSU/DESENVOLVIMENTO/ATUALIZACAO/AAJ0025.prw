#include "topconn.ch"
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAAJ0025   บ Autor ณ ADALBERTO ALTHOFF  บ Data ณ  24/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado para atender a OS ????/05 (dep PLR)          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AAJ0025

Processa({|lEnd| AAJ0025Processa(),"(SR4) Processando a altera็ใo dos valores..."})

STATIC FUNCTION AAJ0025Processa()

Private cArqTxt := "C:\ARQUIV.TXT"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

_cQuery := " SELECT RD_FILIAL, RD_MAT FROM SRD050 WHERE RD_DATARQ = '200401' "
_cQuery += " AND RD_PD = '313' AND D_E_L_E_T_ <> '*' "

If Select("TR0025") >0
	DBSelectArea("TR0025")
	DBCloseArea()
EndIf

dbSelectArea("SR4")
dbSetOrder(1)

TCQUERY _cQuery NEW ALIAS "TR0025"
dbSelectArea("TR0025")



ProcRegua(2469)

dbGoTop()


do while !eof()
	
	IncProc("(SR4) Processando a altera็ใo dos valores...")
	
	dbSelectArea("SR4")
	//Indice do SR4: R4_FILIAL+R4_MAT+R4_CPFCGC+R4_CODRET+R4_MES+R4_TIPOREN
	cKey0025 := TR0025->RD_FILIAL+TR0025->RD_MAT
	
	dbseek(cKey0025)
	cKey0025 +=	R4_CPFCGC+R4_CODRET + "01T"
	dbseek(cKey0025)
	
	
	if found()
		

		cLin := TR0025->RD_FILIAL+TR0025->RD_MAT+str(r4_valor*100)+cEOL
		
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Exit
			Endif
		Endif
		
		RecLock( "SR4" , .F. )
		r4_valor += r4_valor
		MsUnLock()
	endif
	
	dbSelectArea("TR0025")
	dbSkip()
	
enddo

fClose(nHdl)

Return

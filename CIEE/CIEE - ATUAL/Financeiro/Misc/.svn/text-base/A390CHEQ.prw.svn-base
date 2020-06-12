#INCLUDE "rwmake.ch"


User Function A390CHEQ()  

/*Local xArea		:= GetArea()

Local xAreaSE2 	:= SE2->(GetArea())

cDocto := GetMv("MV_NUMCOP")
//Local cDocto	:= StrZero(Val(Getmv("MV_NUMCOP")) + 1, 6)   

dbSelectArea("SEF")
Reclock ("SEF", .F.)
Replace SEF->EF_NUMAP With cDocto
MsUnlock()

dbskip(-1)

dbSelectArea("SE2")
SE2->(DBCLOSEAREA())
CHKFILE("SE2")
dbSelectArea("SE2")
SE2->(dbSetOrder(1))
If DbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA,.F.)
	Reclock ("SE2", .F.)
	SE2->E2_SALDO   := 0
	SE2->E2_BAIXA   := dDataBase
	SE2->E2_VALLIQ  := (SE2->E2_VALOR-SE2->E2_DECRESC+SE2->E2_ACRESC)
	MsUnlock()

	dbSelectArea("SE5")
	SE5->(dbOrderNickName("E5NUMCHEQ"))
	SE5->(dbGotop())
	If SE5->(dbSeek(xFilial("SE5")+ SEF->(EF_NUM+EF_FORNECE+EF_BANCO+EF_AGENCIA+EF_CONTA)  ))
		Reclock ("SE5", .F.)
		SE5->E5_DTDISPO := SE2->E2_VENCREA
		SE5->E5_NUMAP   := cDocto
		SE5->E5_PREFIXO := SEF->EF_PREFIXO
		SE5->E5_NUMERO  := SEF->EF_TITULO
		SE5->E5_TIPO    := SEF->EF_TIPO
		SE5->E5_CLIFOR  := SEF->EF_FORNECE
		SE5->E5_LOJA    := SEF->EF_LOJA
		SE5->E5_XCOMPET := SE2->E2_XCOMPET
		MsUnlock()
	EndIf						
EndIf						

RestArea(xAreaSE2)

RestArea(xArea)*/

Local cBanco	
Local cAgencia
Local cConta
Local cNum
Local cParc
Local cTipo
Local cPrefi
Local cForne
Local cLoja  
Local xArea		:= GetArea()
Local xAreaSE2 	:= SE2->(GetArea())
Local cDocto	:= StrZero(Val(Getmv("MV_NUMCOP")) + 1, 6) 
Local _nSEF		:= 0  
Local _dVencRea	:= ctod(" / / ")
Local _cxCompet	:= ""

//Fecha SE2 para tirar o FILTRO que a rotina padrao preenche
dbSelectArea("SE2")
SE2->(DBCLOSEAREA())
//Reabre o SE2 sem nem filtro
CHKFILE("SE2")

dbSelectArea("SX6")   
GetMv("MV_NUMCOP")
RecLock("SX6",.F.)
Replace X6_CONTEUD With cDocto
MsUnlock() 

//ALTERACAO FEITA PARA QUE FOSSE GERADO APENAS UM NUMERO DE APROVACAO POR AGLUTINACAO DE TITULO - PATRICIA FONTANEZI
dbSelectArea("SEF")
DbSetOrder(1)
If DbSeek(xFilial("SEF")+ SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM)
	cBanco		:= SEF->EF_BANCO
	cAgencia	:= SEF->EF_AGENCIA
	cConta		:= SEF->EF_CONTA
	cNum		:= SEF->EF_NUM  
	cParc		:= SEF->EF_PARCELA
	cTipo		:= SEF->EF_TIPO
	cForne		:= SEF->EF_FORNECE
	cLoja		:= SEF->EF_LOJA
	cPrefi		:= SEF->EF_PREFIXO
	While !EOF() .AND. SEF->(EF_BANCO + EF_AGENCIA + EF_CONTA + EF_NUM) == cBanco + cAgencia + cConta + cNum   
	    Reclock ("SEF", .F.)
		Replace SEF->EF_NUMAP With cDocto
		MsUnlock()  				
	   
		dbSelectArea("SE2")
		SE2->(dbSetOrder(1))
		SE2->(DbGotop())
		If DbSeek(xFilial("SE2")+SEF->EF_PREFIXO +SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO + SEF->EF_FORNECE + SEF->EF_LOJA)
			Reclock ("SE2", .F.)
			SE2->E2_SALDO   := 0
			SE2->E2_BAIXA   := dDataBase
			SE2->E2_VALLIQ  := (SE2->E2_VALOR-SE2->E2_DECRESC+SE2->E2_ACRESC)  
			SE2->E2_NUMAP   := cDocto          //GRAVAR NO SE2 O NUMERO DE APROVACAO GERADO NESSE FONTE - PATRCIA FONTANEZI
			MsUnlock() 
			_dVencRea := SE2->E2_VENCREA
			_cxCompet := SE2->E2_XCOMPET
			_nSEF++						
		EndIf				
		SEF->(DBSKIP())
	Enddo 
   
	dbSelectArea("SEF")
	DbSetOrder(1)
	If DbSeek(xFilial("SEF")+ cBanco + cAgencia + cConta + cNum)
		dbSelectArea("SE5")
		SE5->(dbSetOrder(11))
		SE5->(dbGotop())
		If SE5->(dbSeek(xFilial("SE5")+ cBanco + cAgencia + cConta + cNum))  
			While !EOF() .AND. ALLTRIM(cBanco + cAgencia + cConta + cNum) == ALLTRIM(SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA + SE5->E5_NUMCHEQ)   
				If SE5->E5_SITUACA <> 'C'
					If _nSEF <= 1
						Reclock ("SE5", .F.)
						SE5->E5_DTDISPO := _dVencRea
						SE5->E5_PREFIXO := SEF->EF_PREFIXO
						SE5->E5_NUMERO  := SEF->EF_TITULO
						SE5->E5_TIPO    := SEF->EF_TIPO
						SE5->E5_CLIFOR  := SEF->EF_FORNECE
						SE5->E5_LOJA    := SEF->EF_LOJA
						SE5->E5_XCOMPET := _cxCompet  
						SE5->E5_NUMAP	:= cDocto		//GRAVAR NO SE5 O NUMERO DE APROVACAO GERADO NESSE FONTE -PATRICIA FONTANEZI
						MsUnlock()   
					Else
				   		Reclock ("SE5", .F.)
						SE5->E5_DTDISPO := _dVencRea
						SE5->E5_NUMAP   := cDocto
						SE5->E5_PREFIXO := " "
						SE5->E5_NUMERO  := " "
						SE5->E5_TIPO    := " "
						SE5->E5_CLIFOR  := " "
						SE5->E5_LOJA    := " "
						SE5->E5_PARCELA	:= " "
						SE5->E5_XCOMPET := _cxCompet  
						SE5->E5_NUMAP	:= cDocto		//GRAVAR NO SE5 O NUMERO DE APROVACAO GERADO NESSE FONTE -PATRICIA FONTANEZI
						MsUnlock()  
					Endif
				Endif
				DBSKIP()
			Enddo
		EndIf  
	Endif
Endif

dbskip(-1)


RestArea(xAreaSE2)

RestArea(xArea) 

 

Return()
#Include 'Protheus.ch'
#include "TopConn.ch"
#include "Ap5Mail.ch"
                                                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJPJOB04  บAutor  ณMicrosiga           บ Data ณ  10/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consumo Interno                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _xSF2

_cQuery := "SELECT SL1.L1_DOC, SL1.L1_SERIE, SL1.L1_CLIENTE, SL1.L1_LOJA, SL1.L1_NUM "
_cQuery += "FROM SL4040 SL4, SL1040 SL1 "
_cQuery += "WHERE SL4.D_E_L_E_T_ = '' AND SL1.D_E_L_E_T_ = '' "
_cQuery += "AND SL4.L4_FORMA = 'CI' "
_cQuery += "AND SL4.L4_NUM = SL1.L1_NUM "
_cQuery += "AND SL4.L4_VALOR <> SL1.L1_VLRTOT "
_cQuery += "ORDER BY SL1.L1_DOC "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"SF2TRB",.T.,.T.)

Do While SF2TRB->(!EOF())

    _nValDesc := 0
    _nValBrut := 0

	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(xFilial("SD2")+SF2TRB->(L1_DOC+L1_SERIE+L1_CLIENTE+L1_LOJA))
		Do While !EOF() .and. SF2TRB->(L1_DOC+L1_SERIE+L1_CLIENTE+L1_LOJA) == SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
		
		    _nValDesc += SD2->D2_TOTAL - (SD2->D2_QUANT/100)
		    _nValBrut += (SD2->D2_QUANT/100)
	
			_nDesSD2	:= SD2->D2_TOTAL - (SD2->D2_QUANT/100)
			_nTotSD2	:= (SD2->D2_QUANT/100)
			_nVlrSD2	:= (SD2->D2_QUANT/100) / SD2->D2_QUANT 

			RecLock("SD2",.F.)
			SD2->D2_DESCON	:= _nDesSD2
			SD2->D2_VALBRUT	:= _nTotSD2
			SD2->D2_TOTAL	:= _nTotSD2
			SD2->D2_PRCVEN	:= _nVlrSD2
			MsUnLock()
			
			SD2->(DbSkip())
		EndDo
	EndIf

	DbSelectArea("SL1")
	DbSetOrder(1)
	If DbSeek(xFilial("SL1")+SF2TRB->(L1_NUM))
		Do While !EOF() .and. SF2TRB->(L1_NUM) == SL1->L1_NUM
			RecLock("SL1",.F.)
			SL1->L1_VLRTOT	:= _nValBrut
			SL1->L1_VLRLIQ	:= _nValBrut
			SL1->L1_VALBRUT	:= _nValBrut
			SL1->L1_VALMERC	:= _nValBrut
			MsUnLock()
			SL1->(DbSkip())
		EndDo
	EndIf

	DbSelectArea("SL2")
	DbSetOrder(1)
	If DbSeek(xFilial("SL2")+SF2TRB->(L1_NUM))
		Do While !EOF() .and. SF2TRB->(L1_NUM) == SL2->L2_NUM
			RecLock("SL2",.F.)

			_nDesSL2	:= SL2->L2_VLRITEM - (SL2->L2_QUANT/100)
			_nTotSL2	:= (SL2->L2_QUANT/100)
			_nVlrSL2	:= (SL2->L2_QUANT/100) / SL2->L2_QUANT 

			SL2->L2_VALDESC	:= _nDesSL2
			SL2->L2_VLRITEM	:= _nTotSL2
			SL2->L2_VRUNIT	:= _nVlrSL2
			MsUnLock()
			SL2->(DbSkip())
		EndDo
	EndIf

	DbSelectArea("SF2")
	DbSetOrder(1)
	If DbSeek(xFilial("SF2")+SF2TRB->(L1_DOC+L1_SERIE+L1_CLIENTE+L1_LOJA))
		Do While !EOF() .and. SF2TRB->(L1_DOC+L1_SERIE+L1_CLIENTE+L1_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

			RecLock("SF2",.F.)
			SF2->F2_VALMERC	:= _nValBrut
			SF2->F2_DESCONT	:= _nValDesc
			SF2->F2_VALFAT	:= _nValBrut
			SF2->F2_DESCONT := _nValDesc
			SF2->F2_VALBRUT := _nValBrut
			MsUnLock()
			
			SF2->(DbSkip())
		EndDo
	EndIf
				
	_aSft := {}

	DbSelectArea("SFT")
	DbSetOrder(1)
	If DbSeek(xFilial("SFT")+"S"+SF2TRB->(L1_SERIE+L1_DOC+L1_CLIENTE+L1_LOJA))
		Do While !EOF() .and. SF2TRB->(L1_SERIE+L1_DOC+L1_CLIENTE+L1_LOJA) == SFT->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)

			_nPosCFOP := ascan(_aSft, { |x| x[1] == SFT->FT_CFOP } ) 
			
			If _nPosCFOP > 0
				_aSft[_nPosCFOP,2] += SFT->FT_TOTAL - (SFT->FT_QUANT/100)
				_aSft[_nPosCFOP,3] += (SFT->FT_QUANT/100)
			Else
				aadd(_aSft,{SFT->FT_CFOP,SFT->FT_TOTAL - (SFT->FT_QUANT/100), (SFT->FT_QUANT/100)})				
			EndIf

			_nDesSFT	:= SFT->FT_TOTAL - (SFT->FT_QUANT/100)
			_nTotSFT	:= (SFT->FT_QUANT/100)
			_nVlrSFT	:= (SFT->FT_QUANT/100) / SFT->FT_QUANT 

			RecLock("SFT",.F.)	
			SFT->FT_PRCUNIT	:= _nVlrSFT
			SFT->FT_TOTAL	:= _nTotSFT
			SFT->FT_DESCONT := _nDesSFT
			SFT->FT_VALCONT := _nTotSFT
			MsUnLock()

			SFT->(DbSkip())
		EndDo
	EndIf


	DbSelectArea("SF3")
	DbSetOrder(5)
	If DbSeek(xFilial("SF3")+SF2TRB->(L1_SERIE+L1_DOC+L1_CLIENTE+L1_LOJA))
		Do While !EOF() .and. SF2TRB->(L1_SERIE+L1_DOC+L1_CLIENTE+L1_LOJA) == SF3->(F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA)
		

			_nPosCFOP := ascan(_aSft, { |x| x[1] == SF3->F3_CFO } ) 

			If _nPosCFOP > 0
				If SF3->F3_CFO == _aSft[_nPosCFOP,1]
					RecLock("SF3",.F.)
					SF3->F3_VALOBSE := _aSft[_nPosCFOP,2]
					SF3->F3_VALCONT := _aSft[_nPosCFOP,3]
					MsUnLock()
				EndIf
			EndIf
			
			SF3->(DbSkip())
		EndDo
	EndIf			

	SF2TRB->(DbSkip())

EndDo

SF2TRB->(dbCloseArea())

alert("fim")

Return
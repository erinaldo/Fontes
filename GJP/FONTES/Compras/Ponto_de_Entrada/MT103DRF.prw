
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT103DRF  บAutor  ณMicrosiga           บ Data ณ  10/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Coloca os codigos de Reten็ใo dos impostos e marca a opcao บฑฑ
ฑฑบ          ณ GERA DIRF                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function MT103DRF()

Local nCombo  := PARAMIXB[1] 
Local cCodRet := PARAMIXB[2] 
Local oCombo  := PARAMIXB[3] 
Local oCodRet := PARAMIXB[4] 
Local aImpRet := {}

//nCombo  := 1
//cCodRet := "1700"
//aadd(aImpRet,{"IRR",nCombo,cCodRet})
//nCombo  := 2
//cCodRet := "1708"
//aadd(aImpRet,{"ISS",nCombo,cCodRet})
nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"PIS",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"COF",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"CSL",nCombo,cCodRet})
                                   
nCombo  := 1
cCodRet := "1708"
aadd(aImpRet,{"IRR",nCombo,cCodRet}) 

nCombo  := 1
cCodRet := "2631"
aadd(aImpRet,{"INS",nCombo,cCodRet})

Return aImpRet
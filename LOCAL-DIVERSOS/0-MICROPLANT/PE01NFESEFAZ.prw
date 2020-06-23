#include "protheus.ch"
#include "Topconn.ch"

/*/{Protheus.doc} PE01NFESEFAZ
//TODO Ponto de entrada SEFAZ para imprimir o lote do produto.
@author Eugenio Arcanjo
@since 29/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function PE01NFESEFAZ()
Local aProd     := PARAMIXB[1]
Local cMensCli  := PARAMIXB[2]
Local cMensFis  := PARAMIXB[3]
Local aDest     := PARAMIXB[4]
Local aNota     := PARAMIXB[5]
Local aInfoItem := PARAMIXB[6]
Local aDupl     := PARAMIXB[7]
Local aTransp   := PARAMIXB[8]
Local aEntrega  := PARAMIXB[9]
Local aRetirada := PARAMIXB[10]
Local aVeiculo  := PARAMIXB[11]
Local aReboque  := PARAMIXB[12]
Local aNfVincRur:= PARAMIXB[13]
Local aEspVol   := PARAMIXB[14]
Local aNfVinc   := PARAMIXB[15]
Local _cCodCli       := " "
Local _cLoja         := " "

//Local AdetPag   := PARAMIXB[16]
//Local aObsCont  := PARAMIXB[17]
//Local aProcRef  := PARAMIXB[18]
Local aRetorno      := {}
//Local cMsg          := ""
//cMsg := 'Produto: '+aProd[1][4] + CRLF
//nota de sa�da

	For _xI:= 1 to Len(aProd)		
		DbSelectArea("SB8")
		DbSetOrder(5)
		If DbSeek(xFilial("SB8")+ aProd[_xI][2]+aProd[_xI,19])
			aProd[_xI,4] := alltrim(aProd[_xI,4])
			aProd[_xI,4] += " Lote: "+alltrim(aProd[_xI,19])+iif(!Empty(alltrim(SB8->B8_LOTEFOR))," Lote Forn :"+alltrim(SB8->B8_LOTEFOR),"" )
		EndIf	
	Next _xI

/*
If aNota[5] $"N/B" .And. Alltrim(aNota[4]) == "1" 
	_cCodCli       := Iif(aNota[04] == "0", SA2->A2_COD	, SA1->A1_COD) 
	_cLoja         := Iif(aNota[04] == "0", SA2->A2_LOJA	, SA1->A1_LOJA) 

	For _xI:= 1 to Len(aProd)
		if Select("TRBLOTE") > 0
			TRBLOTE->(DBCLOSEAREA())
		Endif                                                  
	
		cQry  := " select D2_LOTECTL LOTECTL  "
		cQry  += " FROM "+RetSqlName("SD2")+" SD2 "
		cQry  += " WHERE SD2.D_E_L_E_T_=''  "
		cQry  += " AND SD2.D2_COD='"+aProd[_xI][2]+"'"
		cQry  += " AND SD2.D2_DOC='"+aNota[2]+"'"	
		cQry  += " AND SD2.D2_SERIE='"+aNota[1]+"'"	
		cQry  += " AND SD2.D2_CLIENTE='"+_cCodCli+"'"	
		cQry  += " AND SD2.D2_LOJA='"+_cLoja+"'"	

		cQry  := ChangeQuery(cQry)
							
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRBLOTE",.F.,.t.) 
		
		DbSelectArea("SB8")
		DbSetOrder(5)
		If DbSeek(xFilial("SB8")+ aProd[_xI][2]+TRBLOTE->LOTECTL)
			aProd[_xI,4] := alltrim(aProd[_xI,4])
			aProd[_xI,4] += " Lote: "+alltrim(TRBLOTE->LOTECTL)+" Lote Forn :"+alltrim(SB8->B8_LOTEFOR)
		Else
			aProd[_xI,4] := alltrim(aProd[_xI,4])
			aProd[_xI,4] += " Lote: "+alltrim(TRBLOTE->LOTECTL) 
		EndIf	
	Next 
Else
	_cCodCli       := Iif(aNota[04] == "0" .and. aNota[5] $ "B", SA1->A1_COD , SA2->A2_COD) 
	_cLoja         := Iif(aNota[04] == "0" .and. aNota[5] $ "B", SA1->A1_LOJA, SA2->A2_LOJA) 

	For _xI:= 1 to Len(aProd)

		if Select("TRBLOTE") > 0
			TRBLOTE->(DBCLOSEAREA())
		Endif                                                  
	
		cQry  := " select D1_LOTECTL LOTECTL, D1_LOTEFOR LOTEFOR  "
		cQry  += " FROM "+RetSqlName("SD1")+" SD1 "
		cQry  += " WHERE SD1.D_E_L_E_T_=''  "
		cQry  += " AND SD1.D1_COD='"+aProd[_xI][2]+"'"
		cQry  += " AND SD1.D1_DOC='"+aNota[2]+"'"	
		cQry  += " AND SD1.D1_SERIE='"+aNota[1]+"'"	
		cQry  += " AND SD1.D1_FORNECE ='"+_cCodCli+"'"	
		cQry  += " AND SD1.D1_LOJA='"+_cLoja+"'"	

		cQry  := ChangeQuery(cQry)
							
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRBLOTE",.F.,.t.) 

		If Empty(alltrim(TRBLOTE->LOTEFOR))
			aProd[_xI][4] := alltrim(aProd[_xI,4])
			aProd[_xI][4] +=  " Lote: "+alltrim(TRBLOTE->LOTECTL)
		Else
			aProd[_xI][4] := alltrim(aProd[_xI,4])
			aProd[_xI][4] +=  " Lote: "+alltrim(TRBLOTE->LOTECTL) + " Lote Forn :"+alltrim(TRBLOTE->LOTEFOR)
		EndIf

		If Empty(alltrim(TRBLOTE->LOTEFOR))
			aProd[_xI][4] := alltrim(aProd[_xI,4])
			aProd[_xI][4] +=  " Lote: "+alltrim(TRBLOTE->LOTECTL)
		Else
			aProd[_xI][4] := alltrim(aProd[_xI,4])
			aProd[_xI][4] +=  " Lote: "+alltrim(TRBLOTE->LOTECTL) + " Lote Forn :"+alltrim(TRBLOTE->LOTEFOR)
		EndIf
		
	Next
Endif	 
*/
 
aadd(aRetorno,aProd)
aadd(aRetorno,cMensCli)
aadd(aRetorno,cMensFis)
aadd(aRetorno,aDest)
aadd(aRetorno,aNota)
aadd(aRetorno,aInfoItem)
aadd(aRetorno,aDupl)
aadd(aRetorno,aTransp)
aadd(aRetorno,aEntrega)
aadd(aRetorno,aRetirada)
aadd(aRetorno,aVeiculo)
aadd(aRetorno,aReboque)
aadd(aRetorno,aNfVincRur)
aadd(aRetorno,aEspVol)
aadd(aRetorno,aNfVinc)
//aadd(aRetorno,AdetPag)
//aadd(aRetorno,aObsCont)
//aadd(aRetorno,aProcRef)
 
RETURN aRetorno
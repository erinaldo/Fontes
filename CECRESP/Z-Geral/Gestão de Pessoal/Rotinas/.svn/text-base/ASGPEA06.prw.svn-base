//-----------------------------------------------------------------------
/*/{Protheus.doc} FBONUSFOL()

Gera as verbas 095-Bonus e 625-Bonus no cálculo da Folha a fim de     
recolher os impostos

@param		Nenhum
@return		Nenhum                                           
@author 	Isamu Kawakami
@since 		05/10/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function fBonusFol                                 


Local cCodBonus := "095"
Local cQr                   
Local cMesAno   := cPeriodo                            
Local nVal095   := 0

cQr := " SELECT RD_VALOR AS VAL095 "
cQr += " FROM "+RetSqlName("SRD")+ " "
cQr += " WHERE RD_DATARQ = '"+cMesAno+"' AND " 
cQr += " RD_PD = '"+cCodBonus+"' AND "        
cQr += " RD_FILIAL = '"+Sra->Ra_Filial+"' AND "
cQr += " RD_MAT = '"+Sra->Ra_Mat+"' "
cQr += " AND "+RETSQLNAME("SRD")+".D_E_L_E_T_ <> '*' "
                              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha alias caso esteja aberto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TMD") > 0
	DBSelectArea("TMD")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQr),"TMD",.F.,.T.)
                   
nVal095 := Tmd->Val095

If nVal095 > 0
   fGeraVerba(cCodBonus,nVal095,,,,,,,,,.T.)
   fGeraVerba("625",nVal095,,,,,,,,,.T.)
Endif


Return   
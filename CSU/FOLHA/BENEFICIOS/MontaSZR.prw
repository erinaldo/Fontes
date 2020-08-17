User Function MontaSZR()

  Processa({|| SZR() },"Montando SZR - Vale Refeição")

Return
  

Static Function SZR()
 DbSelectArea("SRX")                          
 DbsetOrder(2)    
 
 DbSelectArea("SRA")     
 DbsetOrder(1)                                 
 DBGOTOP()     
 
 While !Eof()
   IncProc()
 
    DBSELECTAREA("SZR")   
      RECLOCK("SZR",.T.)
	   SZR->ZR_CODIGO := SRA->RA_VALEREF 
   
       DBSELECTAREA("SRX") 
	   IF Dbseek('26'+"  "+SRA->RA_VALEREF) 
		   SZR->ZR_DESC	  := ALLTRIM(SUBS(RX_TXT,1,20))
	   Endif
	   SZR->ZR_FILIAL := SRA->RA_FILIAL
	   SZR->ZR_MAT    := SRA->RA_MAT
      MSUNLOCK()

   
   DBSELECTAREA("SRA")
   DBSKIP()

 ENDDO
                           
 DBSELECTAREA("SZR")
 DBCLOSEAREA()


Return
 
 

User Function CONVSRR()

  Processa({|| AJRC() },"Convertendo o Arq. SRR")

Return
 
 

Static Function AJRC()

 dbUseArea(.T.,, "\CONV\AC_DEMI.DBF","ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="RD_FILIAL + RD_MAT + RD_DATARQ"
 IndRegua("ZZ1",cArqNtx,cIndCond,,,"Selecionando registros...")	
 
 DBSELECTAREA("SRG")
 DBSEEK(SRG->RG_FILIAL+SRG->RG_MAT + "2003"+SUBS(DTOC(SRG->RG_DATADEM),4,2)) 
 
 ProcRegua(RecCount())                                       
 DBGOTOP()                              

  DBSELECTAREA("ZZ1")
  do While !Eof()
  IncProc()

   
      DBSELECTAREA("SRR")     
      RECLOCK("SRR",.T.)             
   	   	    SRR->RR_FILIAL := ZZ1->RD_FILIAL 
		    SRR->RR_MAT    := ZZ1->RD_MAT 
		    SRR->RR_PD     := ZZ1->RD_PD
    		SRR->RR_HORAS  := ZZ1->RD_HORAS 
    		SRR->RR_VALOR  := ZZ1->RD_VALOR 
            SRR->RR_TIPO1  := ZZ1->RD_TIPO1 		    
            SRR->RR_TIPO2  := "I"
            SRR->RR_AUXIL  := 0.00
            SRR->RR_TIPO3  := "R"
            SRR->RR_DATAPAG:= ZZ1->RD_DATPGT 
            SRR->RR_USERLGA:= "IMPORTACAO"
      MSUNLOCK()
//   ENDIF

     DBSELECTAREA("SRA")
     cArqNtx  := CriaTrab(NIL,.f.)
     cIndCond :="RA_FILIAL + RA_MAT "
     IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando registros...")	
 
     If Dbseek(SRR->RR_FILIAL+SRR->RR_MAT)
   
    	DBSELECTAREA("SRR")       
        	RECLOCK("SRR",.F.)
          	   	SRR->RR_CC 	 := SRA->RA_CC 
	   	        SRR->RR_DATA := SRA->RA_DEMISSA 
       		MSUNLOCK() 
        DBSELECTAREA("SRA")       		
        DBSKIP()

     Endif          
   
   DBSELECTAREA("ZZ1")
   DBSKIP()

 ENDDO
                           
   DBSELECTAREA("ZZ1")
   DBCLOSEAREA()

Return

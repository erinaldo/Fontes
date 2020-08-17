User Function ALT_SAL()

  Processa({|| AJRC() },"Ajustando o SRA - Escala")

Return
 
 

Static Function AJRC()

 dbUseArea(.T.,, "\CONV\SRA010.DBF","ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="RA_FILIAL + RA_MAT"
 IndRegua("ZZ1",cArqNtx,cIndCond,,,"Selecionando registros...")	
 
 DBSELECTAREA("SRA")
 DBSETORDER(1)
          
 ProcRegua(RecCount())                                       
 DBGOTOP()                              
 
 While !Eof()
   IncProc()
 
   DBSELECTAREA("ZZ1") 
   IF DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT)
    DBSELECTAREA("SRA")   
      RECLOCK("SRA",.F.)
//  SRA->RA_ESCALA := ZZ1->RA_ESCALA 
	   SRA->RA_SALARIO := ZZ1->RA_SALARIO
	   SRA->RA_CODFUNC := ZZ1->RA_CODFUNC
      MSUNLOCK()
   ENDIF
   
   DBSELECTAREA("SRA")
   DBSKIP()

 ENDDO
                           
 DBSELECTAREA("ZZ1")
 DBCLOSEAREA()


Return
 
 

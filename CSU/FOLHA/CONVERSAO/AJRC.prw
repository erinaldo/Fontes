User Function AJUSTARC

  Processa({|| AJRC() },"Montando o RC050703")

Return
 
 

Static Function AJRC()

//DBUseArea(.T.,	"TOPCONN","ODPREV","ZZ3",.F.)
 dbUseArea(.T.,"TOPCONN","RC050307","ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")

          
 ProcRegua(RecCount())                                       
 DBGOTOP()                              
 
 While !Eof()
   IncProc()
 
   DBSELECTAREA("SRA") 
   IF DBSEEK(ZZ1->RC_FILIAL+ZZ1->RC_MAT)
      DBSELECTAREA("ZZ1")
      RECLOCK("ZZ1",.F.)
	   ZZ1->RC_CC      := SRA->RA_CC
      MSUNLOCK()
   ENDIF
   
   DBSELECTAREA("ZZ1")
   DBSKIP()

 ENDDO
                           
 DBSELECTAREA("ZZ1")
 DBCLOSEAREA()


Return
 
 

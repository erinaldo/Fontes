User Function MontaRC

  Processa({|| ConverteRC() },"Montando o RC050703")

Return
 
 

Static Function ConverteRC()

 
 dbUseArea(.T.,,"\CONV\SRC.DBF","ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")


 DbselectArea("SRD")
 cArq := CriaTrab(Nil,.F.)
 IndRegua("SRD",cArq,"RD_DATARQ","Selecionando Registros...")
          
 ProcRegua(RecCount())                                       
 
 dbSeek( "200307" )
 
 While !Eof() .And. RD_DATARQ == "200307"
   IncProc()
 
//   If SRD->RD_DATARQ # "200307"
//      Dbskip()
//      Loop
//   Endif
    
   DbSelectArea("ZZ1")
   RECLOCK("ZZ1",.T.)
               
	   ZZ1->RC_FILIAL  := SRD->RD_FILIAL
	   ZZ1->RC_MAT     := SRD->RD_MAT
	   ZZ1->RC_PD      := SRD->RD_PD
	   ZZ1->RC_TIPO1   := SRD->RD_TIPO1
	   ZZ1->RC_HORAS   := SRD->RD_HORAS
	   ZZ1->RC_VALOR   := SRD->RD_VALOR
	   ZZ1->RC_DATA    := SRD->RD_DATPGT
	   ZZ1->RC_SEMANA  := SRD->RD_SEMANA
	   ZZ1->RC_CC      := SRD->RD_CC
	   ZZ1->RC_PARCELA := 0
	   ZZ1->RC_TIPO2   := "I"
	   ZZ1->RC_SEQ     := SRD->RD_SEQ
   
    MSUNLOCK()
   DBSELECTAREA("SRD")

   DBSKIP()

 ENDDO
 dbSelectArea("SRD")
 RetIndex()
                           
 DBSELECTAREA("ZZ1")
 DBCLOSEAREA()


Return
 
 

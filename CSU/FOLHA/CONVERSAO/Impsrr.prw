#include "rwmake.ch"

User Function IMPSRR()

 Local	oDlg	:= NIL


 Private cPerg	:= PADR("IMPSRC",LEN(SX1->X1_GRUPO))
 Private aInfo	    := {}
 Private aDepende   := {}
 Private nDepen  	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("ImportaГЦo dos Vlrs. De Rescisao - SRR")
 @ 008,010 TO 084,222
 @ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")						 												
 @ 030,020 SAY OemToAnsi("Selecao dos Parametros")																		
 @ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )	
 @ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSrd() }  )      
 @ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 ACTIVATE DIALOG oDlg CENTERED

Return( NIL )



Static function MigraSrd()

 Private cArqOrig := MV_PAR01
 Private cEmpOrig := MV_PAR02
// Private cFilDest := MV_PAR03

//ARQUIVO 
 
 dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")
                     
 dbUseArea(.T.,,"\CONV\FUN0603.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ2")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="(STR(CODCOLIG,1))+(CHAPA)" 
 IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."

 dbUseArea(.T.,,"\CONV\LIXO.DBF","ZZ3",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ3")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="CODIGO"
 IndRegua("ZZ3",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."


 #IFDEF WINDOWS
   Processa({|| ImpSrd() },"Importando SRR")

 #ENDIF        

Return
  

Static Function Impsrd()


 ProcRegua(RecCount())                                       
 
 DBSELECTAREA("ZZ1")
 
 DO WHILE !EOF()  
   
   If VAL(cEmpOrig) # (ZZ1->CODCOLIGAD)
      DbSkip()
      Incproc()
      Loop
   Endif
      
   DBSELECTAREA("ZZ2")

   cPesq := (STR(ZZ1->CODCOLIGAD,1))+ZZ1->CHAPA

   IF Dbseek(cPesq) 
      
	   If ZZ2->CODCOLIG = 3 .AND. ZZ2->CODFILIAL = 1
    	  cFilDest := "08"
	   Elseif ZZ2->CODCOLIG = 3 .AND. ZZ2->CODFILIAL = 2   
	      cFilDest := "06"
	   Elseif ZZ2->CODCOLIG = 3 .AND. ZZ2->CODFILIAL = 4   
	      cFilDest := "04" 
	   Elseif ZZ2->CODCOLIG = 3 .AND. ZZ2->CODFILIAL = 5   
	      cFilDest := "05"
	   Elseif ZZ2->CODCOLIG = 3 .AND. ZZ2->CODFILIAL = 6   
	      cFilDest := "03"
	   Elseif ZZ2->CODCOLIG = 4 .AND. ZZ2->CODFILIAL = 1   
	      cFilDest := "07"
	   Elseif ZZ2->CODCOLIG = 5 .AND. ZZ2->CODFILIAL = 1   
	      cFilDest := "02"
	   Elseif ZZ2->CODCOLIG = 5 .AND. ZZ2->CODFILIAL = 2   
	      cFilDest := "09"
	   Elseif ZZ2->CODCOLIG = 5 .AND. ZZ2->CODFILIAL = 3   
	      cFilDest := "01"
	   Endif
                                  
   Else
   
      DBSELECTAREA("ZZ1")
      Dbskip()
      Loop
      
   Endif   

   If SUBS(ZZ1->CHAPA,6,1)="B" 
      _MAT := "5" + SUBS(ZZ1->CHAPA,1,5)
   ElseIf SUBS(ZZ1->CHAPA,6,1)="R"                    
      _MAT := "6"+SUBS(ZZ1->CHAPA,1,5)
   ElseIf SUBS(ZZ1->CHAPA,6,1)=" "                    
      _MAT := "0"+SUBS(ZZ1->CHAPA,1,5)      
   Else    
      _MAT := SUBS(ZZ1->CHAPA,1,6)
   Endif      
          

 DBSELECTAREA("SRV")  
 
 If Val(cEmpOrig) = 3
   cArqNtx  := CriaTrab(NIL,.f.)
   cIndCond :="RV_FILIAL + RV_COD1"
 ElseIf Val(cEmpOrig) = 4 
    cArqNtx  := CriaTrab(NIL,.f.)
    cIndCond :="RV_FILIAL + RV_COD2"
 ElseIf Val(cEmpOrig) = 5 
    cArqNtx  := CriaTrab(NIL,.f.)
    cIndCond :="RV_FILIAL + RV_COD3"    
 Endif    
 IndRegua("SRV",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."

   
//criar o campo RV_CODE, C, 3
//criar o indice FILIAL+CODANT
                
    //CHAVE := "  "+STRZERO(ZZ1->CODEVENTO,4)
                                             
    CHAVE := "  "+ ZZ1->CODEVENTO
 
    IF !DBSEEK(CHAVE)
      DBSELECTAREA("ZZ3")
       IF DBSEEK(ZZ1->CODEVENTO)
          RECLOCK("ZZ3",.F.)
          ZZ3->QTDE += 1
       Else   
          RECLOCK("ZZ3",.T.)
          ZZ3->QTDE := 1
          ZZ3->CODIGO := ZZ1->CODEVENTO
       Endif   
          MSUNLOCK()

      DBSELECTAREA("ZZ1")           
      DbSkip()
      Incproc()
      Loop
    ENDIF       

 cPARA:= SRV->RV_COD
      
   DBSELECTAREA("SRR")           
   
   IF STR(ZZ1->ANOCOMP) # " "  
      DbSkip()
      Incproc()
      Loop
  
    ELSE           
     	    RECLOCK("SRR",.T.)
   	   	    SRR->RR_FILIAL := cFilDest
		    SRR->RR_MAT    := _MAT
		    SRR->RR_PD     := cPara 
    		SRR->RR_HORAS  := ZZ1->REF
    		SRR->RR_VALOR  := ZZ1->VALOR
            SRR->RR_TIPO1  :=  Iif(SRV->RV_TIPO=" ","V",SRV->RV_TIPO)    		    
            SRR->RR_TIPO2  := "I"
            SRR->RR_AUXIL  := 0.00
            SRR->RR_DATA   := ZZ2->DTPAGTORE
            SRR->RR_TIPO3  := "R"
            SRR->RR_DATAPAG:= ZZ2->DTPAGTORE 
            SRR->RR_USERLGA:= "IMPORTACAO"
  	        
        MSUNLOCK()
        
     DBSELECTAREA("SRA")
     cArqNtx  := CriaTrab(NIL,.f.)
     cIndCond :="RA_FILIAL + RA_MAT "
     IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando registros...")	
 
     If Dbseek(SRR->RR_FILIAL+SRR->RR_MAT)
   
    	DBSELECTAREA("SRR")       
        	RECLOCK("SRR",.F.)
          	   	SRR->RR_CC := SRA->RA_CC 
       		MSUNLOCK() 
        DBSELECTAREA("SRA")       		
        DBSKIP()

     Endif          

            
    ENDIF         
          
 
   DBSELECTAREA("ZZ1")

   DBSKIP()
   INCPROC()

 ENDDO

 DBSELECTAREA("ZZ1")
 DBCLOSEAREA()

 DBSELECTAREA("ZZ2")
 DBCLOSEAREA()
 
 DBSELECTAREA("ZZ3")
 DBCLOSEAREA()
              
 DBSELECTAREA("SRA")
 DBCLOSEAREA()

 #IFDEF WINDOWS
    MsgAlert ("Importacao Finalizada")
 #ELSE
    Alert("Importacao Finalizada")
 #ENDIF        

RETURN


*/

Static Function fPergConv()

Local aRegs     := {}

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aAdd(aRegs,{cPerg,'01' ,'Arquivo Origem     ?',''				 ,''			 ,'mv_ch1','C'  ,30     ,0      ,0     ,'G','U_fOpen_Conv()                         ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'02' ,'Empresa Origem     ?',''				 ,''			 ,'mv_ch2','C'  ,04     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'',''})
//aAdd(aRegs,{cPerg,'03' ,'Filial Destino     ?',''				 ,''			 ,'mv_ch3','C'  ,02     ,0      ,0     ,'G','                                ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SMO',''})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Carrega as Perguntas no SX1                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ValidPerg(aRegs,cPerg)


Return NIL


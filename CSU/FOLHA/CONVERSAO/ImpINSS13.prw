#include "rwmake.ch"

User Function IMPINSS13()

 Local	oDlg	:= NIL


 Private cPerg	:= PADR("IMPSRI",LEN(SX1->X1_GRUPO))
 Private aInfo	    := {}
 Private aDepende   := {}
 Private nDepen  	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("ImportaГЦo dos Vlrs. VariАveis 13o SALARIO (SRI) - 12/2003")
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
                     

 #IFDEF WINDOWS
   Processa({|| ImpSrd() },"Importando SRI")

 #ENDIF        

Return
  

Static Function Impsrd()


 ProcRegua(RecCount())                                       
 
 DBSELECTAREA("ZZ1")
 
 DO WHILE !EOF()  
   

     	    RECLOCK("SRI",.T.)
   	   	    SRI->RI_FILIAL := ZZ1->RI_FILIAL
		    SRI->RI_MAT    := ZZ1->RI_MAT_
		    SRI->RI_PD     := ZZ1->RI_PD 
    		SRI->RI_HORAS  := 0.00 
    		SRI->RI_VALOR  := ZZ1->RI_VALOR
            SRI->RI_TIPO1  :=  "V" 
            SRI->RI_TIPO2  := "I"
   			SRI->RI_DATA    := CTOD("19/12/2003")  
			SRI->RI_USERLGA:= "IMPORTACAO"	  		    

  		    
  	        
        MSUNLOCK()
        
     DBSELECTAREA("SRA")
     cArqNtx  := CriaTrab(NIL,.f.)
     cIndCond :="RA_FILIAL + RA_MAT "
     IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando registros...")	
 
     If Dbseek(SRI->RI_FILIAL+SRI->RI_MAT)
   
    	DBSELECTAREA("SRI")       
        	RECLOCK("SRI",.F.)
          	   	SRI->RI_CC := SRA->RA_CC 
       		MSUNLOCK() 
        DBSELECTAREA("SRA")       		
        DBSKIP()

     Endif          

            

   DBSELECTAREA("ZZ1")

   DBSKIP()
   INCPROC()

 ENDDO

 DBSELECTAREA("ZZ1")
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


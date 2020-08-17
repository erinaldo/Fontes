#include "rwmake.ch"

User Function Conb722()

 Local	oDlg	:= NIL


 Private cPerg	:= PADR("CONAAS",LEN(SX1->X1_GRUPO))
 Private aInfo	    := {}
 Private aDepende   := {}
 Private nDepen  	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao da Base de INSS")
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
 
 dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")
                     
 dbUseArea(.T.,,"\CONV\DBO_PFUN.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ2")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="(STR(CODCOLIG,1))+(CHAPA)"
 IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."



 #IFDEF WINDOWS
   Processa({|| ImpSrd() },"Importando BASE SAL. CONTRIB. - SRD")

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

   cPesq := (STR(ZZ1->CODCOLIGAD,1))+(ZZ1->CHAPA)

   IF Dbseek(cPesq) 
      
      cMat := Strzero(ZZ2->CODPESSOA,6)    
      
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
          

/*/ DBSELECTAREA("SRV")  
 
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
                
//    CHAVE := "  "+ZZ1->CODEVENTO
 
//  IF !DBSEEK(CHAVE)
//      DBSELECTAREA("ZZ1")           
//      DbSkip()
//      Incproc()
//      Loop
//    ENDIF        

// cPARA:= SRV->RV_COD /*/
      
   DBSELECTAREA("SRD")           
   
   IF STR(ZZ1->ANOCOMP) # " "  
      DbSkip()
      Incproc()
      Loop

   ELSE           
   
   
// 		DATARQ := IIF(SUBS(MV_PAR01,13,1)="9","19"+SUBS(MV_PAR01,13,2),"20"+SUBS(MV_PAR01,13,2))+ "01"
	   
  	 	    RECLOCK("SRD",.T.)
   	   	    SRD->RD_FILIAL := cFilDest
		    SRD->RD_MAT    := _MAT
		    SRD->RD_PD     := "722"
                                                          
		IF SRD->RD_FILIAL <> "07"                                                  
			IF ZZ1->MESCOMP + 1 == 13
			   _MPgto := "01" 
			   _Apgto := ALLTRIM(STR((ZZ1->ANOCOMP+1)))
			Else              
			   _MPgto := STRZERO((ZZ1->MESCOMP+1),2) 
			   _Apgto := ALLTRIM(STR(ZZ1->ANOCOMP))
			Endif   
	      _DTPGTO := CTOD("05/"+ _MPgto + "/" + _Apgto)
        Else    
            _MPgto := STRZERO((ZZ1->MESCOMP),2) 
		    _Apgto := ALLTRIM(STR((ZZ1->ANOCOMP)))
            _DTPGTO := CTOD("30/"+ _MPgto + "/" + _Apgto)
        Endif 
        
  	        SRD->RD_DATPGT := _DTPGTO 
		    SRD->RD_MES    := STRZERO(ZZ1->MESCOMP,2)             
		    SRD->RD_TIPO1  := "V"
		    SRD->RD_TIPO2  := "I"
		    SRD->RD_HORAS  := 0 
   	   	    SRD->RD_DATARQ := ALLTRIM(STR(ZZ1->ANOCOMP)) + STRZERO(ZZ1->MESCOMP,2)
		    
		    If SRD->RD_DATARQ >= "199003" .AND. SRD->RD_DATARQ <= "199504"
		       _nTeto := 582.86
			ElseIf SRD->RD_DATARQ >= "199505" .AND. SRD->RD_DATARQ <= "199604"
		       _nTeto := 832.66  		       		       
			ElseIf SRD->RD_DATARQ >= "199605" .AND. SRD->RD_DATARQ <= "199705"
		       _nTeto := 957.56  		       		       
			ElseIf SRD->RD_DATARQ >= "199706" .AND. SRD->RD_DATARQ <= "199805"
		       _nTeto := 1031.87  		       		       
			ElseIf SRD->RD_DATARQ >= "199806" .AND. SRD->RD_DATARQ <= "199811"
		       _nTeto := 1081.50  		       		       
			ElseIf SRD->RD_DATARQ >= "199812" .AND. SRD->RD_DATARQ <= "199905"
		       _nTeto := 1200.00  		       		       
			ElseIf SRD->RD_DATARQ >= "199906" .AND. SRD->RD_DATARQ <= "200004"
		       _nTeto := 1255.32  		       		       
			ElseIf SRD->RD_DATARQ >= "200005" .AND. SRD->RD_DATARQ <= "200105"
		       _nTeto := 1328.25  		       		       
			ElseIf SRD->RD_DATARQ >= "200106" .AND. SRD->RD_DATARQ <= "200205"
		       _nTeto := 1430.00  		       
		    ElseIf SRD->RD_DATARQ >= "200206" .AND. SRD->RD_DATARQ <= "200305"
		       _nTeto := 1561.56 
	        ElseIf SRD->RD_DATARQ >= "200306" 
		       _nTeto := 1869.34     		       
		    Endif 
	        
 			If ZZ1->BASEINSS > _nTeto	        
 			   _nVal := ZZ1->BASEINSS - _nTeto
 			Else 
			   _nVal := 0 	 			   
	        Endif 
	    
		    SRD->RD_VALOR  := _nVal
       		SRD->RD_STATUS := "I"
	    	SRD->RD_FGTS   := Iif(SRV->RV_FGTS=" ","N",SRV->RV_FGTS)
    	    SRD->RD_INSS   := Iif(SRV->RV_INSS=" ","N",SRV->RV_INSS)
        	SRD->RD_IR     := Iif(SRV->RV_IR  =" ","N",SRV->RV_IR)
        
        MSUNLOCK()

            
   ENDIF         
          
 
   DBSELECTAREA("ZZ1")

   DBSKIP()
   INCPROC()

 ENDDO

 DBSELECTAREA("ZZ1")
 DBCLOSEAREA()


 DBSELECTAREA("ZZ2")
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


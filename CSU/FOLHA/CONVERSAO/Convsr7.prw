#include "rwmake.ch"

User Function ConvSR7()

 Local	oDlg	:= NIL


 Private cPerg	:= PADR("CONSR7",LEN(SX1->X1_GRUPO))
 Private aInfo	:= {}
 Private aDepende:= {}
 Private nDepen	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao do HistСrico Salarial")
 @ 008,010 TO 084,222
 @ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")						 												
 @ 030,020 SAY OemToAnsi("Selecao dos Parametros")																		
 @ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )	
 @ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSr7() }  )      
 @ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSr7()

 cArqOrig := MV_PAR01
 cEmpOrig := MV_PAR02
// cFilDest := MV_PAR03

 
// ARQUIVO DBO_HSTS.DBF

 dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")          
 
 dbUseArea(.T.,,"\CONV\DBO_PFUN.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ2")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="(STR(CODCOLIG,1))+(CHAPA)"
 IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."  
 
 dbUseArea(.T.,,"\CONV\PFHSTFCO.DBF","ZZ3",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ3")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="(STR(CODCOLIGAD,1))+(CHAPA)+ DTOC(DTMUDANCA)+ (MOTIVO)" 
 IndRegua("ZZ3",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."  
 /*
 dbUseArea(.T.,,"\CONV\PFHSTFCO1.DBF","ZZ4",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ4")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="(STR(CODCOLIGAD,1))+(CHAPA)" 
 IndRegua("ZZ4",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."  
 */                                        

 #IFDEF WINDOWS
   Processa({|| ImpSr7() },"Importando SR7")
 #ENDIF        

//return
  
Static Function Impsr7()

 ProcRegua(RecCount())                                       
                  
 DBSELECTAREA("ZZ1")
 
 DO WHILE !EOF()
   
   If Val(cEmpOrig) # ZZ1->CODCOLIGAD
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
   
   If ZZ2->CODTIPO == "A"
      _CATFUNC := "A" 
   ELSEIF ZZ2->CODTIPO $ "C*D*E"                
      _CATFUNC := "P" 
   ElseIf ZZ2->CODTIPO $ "F*O"
      _CATFUNC := "C"
   ELSEIF ZZ2->CODTIPO $ "B*M*N*P*R*S*U*X*Z"                
      _CATFUNC := "M"      
   ELSEIF ZZ2->CODTIPO == "T"                
      _CATFUNC := "G"       
   ENDIF    

/*/                            
   DBSELECTAREA("ZZ3") 
     IF Dbseek(STR(ZZ1->CODCOLIGAD,1)+ZZ1->CHAPA+DTOC(ZZ1->DTMUDANCA)+ZZ1->MOTIVO)
        _CodFunc := STRZERO(VAL(ZZ3->CODFUNCAO),4)
     Else  
        _CodFunc := STRZERO(VAL(ZZ2->CODFUNCA),4)
     ENDIF 
/*/                                    

    DBSELECTAREA("ZZ3") 
     IF Dbseek(STR(ZZ1->CODCOLIGAD,1)+ZZ1->CHAPA+DTOC(ZZ1->DTMUDANCA)+ZZ1->MOTIVO)
        _CodFunc := STRZERO(VAL(ZZ3->CODFUNCAO),4)  
//     ELSEIF DBSELECTAREA("ZZ4") 
//        IF Dbseek(STR(ZZ1->CODCOLIGAD,1)+ZZ1->CHAPA) 
//          IF DTOC(ZZ1->DTMUDANCA)< DTOC(ZZ4->DTMUDANCA)
//             _CodFunc := STRZERO(VAL(ZZ4->CODFUNCAO),4)  
//          ENDIF                                          
 //       Endif                                            
      ELSE
         _CodFunc := STRZERO(VAL(ZZ2->CODFUNCA),4)        
     ENDIF 


        If ZZ1->CODCOLIGAD == 5 
           If _CodFunc = "0507" 
              _CodFunc := "0281"
	       Elseif _CodFunc = "0506" 
               _CodFunc := "0279"
           Elseif _CodFunc = "0044" 
               _CodFunc := "0037"
           Elseif _CodFunc = "0042" 
               _CodFunc := "0040"
           Elseif _CodFunc = "0503" 
               _CodFunc := "0285"
           Elseif _CodFunc = "0502" 
               _CodFunc := "0286"
           Elseif _CodFunc = "0501" 
               _CodFunc := "0290"
           Elseif _CodFunc = "0130" 
               _CodFunc := "0060"
           Elseif _CodFunc = "0514" 
               _CodFunc := "0292"
           Elseif _CodFunc = "0508" 
               _CodFunc := "0276"
           Elseif _CodFunc = "0298" 
               _CodFunc := "0283"
           ENDIF		  

        ElseIf ZZ1->CODCOLIGAD == 3
           If _CodFunc = "0270" 
               _CodFunc := "0281"
	       Elseif _CodFunc = "0271" 
               _CodFunc := "0270"
	       Elseif _CodFunc = "0332" 
               _CodFunc := "0322"        
           Endif                    
        Endif
        
   
    DBSELECTAREA("SRJ")
    cArqNtx  := CriaTrab(NIL,.f.)
    cIndCond :="RJ_FILIAL + RJ_COL4"
    IndRegua("SRJ",cArqNtx,cIndCond,,,"Selecionando registros...")	
 
    If Dbseek("  " +_CodFunc)
//       If cFilDest = "07" 
		 If ZZ1->CODCOLIGAD = 4 
     	  _CodFunc := SRJ->RJ_FUNCAO
       Endif
    Endif   

    DBSELECTAREA("SRJ")
    cArqNtx  := CriaTrab(NIL,.f.)
    cIndCond :="RJ_FILIAL + RJ_FUNCAO"
    IndRegua("SRJ",cArqNtx,cIndCond,,,"Selecionando registros...")	
                             
    If Dbseek("  " +_CodFunc)
       _DESCFUN := SRJ->RJ_DESC
    Endif    
    
        DBSELECTAREA("SR7")
        RECLOCK("SR7",.T.)
        SR7->R7_FILIAL := cFilDest
        SR7->R7_MAT    := _Mat
        SR7->R7_DATA   := ZZ1->DTMUDANCA
        SR7->R7_CATFUNC:=_CATFUNC
     	SR7->R7_FUNCAO := _CodFunc 
//       	SR7->R7_DESCFUN:= fDesc('SRJ',_CodFunc,'RJ_DESC')
		SR7->R7_DESCFUN:= _DESCFUN

        SR7->R7_USUARIO:= "CONV.SIGA"    
        SR7->R7_TIPOPGT:="M" 
	If ZZ1->MOTIVO $ "TI*M *00*01*02*03*04*05*06*07*08*11*12*13*14*15*16*17*18*19*20*21*  "
	   SR7->R7_TIPO := "013"
	ElseIf ZZ1->MOTIVO $ "10*ME*me"
	   SR7->R7_TIPO := "004"      
   	ElseIf ZZ1->MOTIVO $ "A *a "
	   SR7->R7_TIPO := "002"     
	ElseIf ZZ1->MOTIVO == "AA"
	   SR7->R7_TIPO := "001"
	ElseIf ZZ1->MOTIVO == "aa"
	   SR7->R7_TIPO := "001"	   
	ElseIf ZZ1->MOTIVO $ "AC*ac"
	   SR7->R7_TIPO := "005"
	ElseIf ZZ1->MOTIVO $ "AP*ap"
	   SR7->R7_TIPO := "006"
	ElseIf ZZ1->MOTIVO $ "CH*ch"
	   SR7->R7_TIPO := "007" 
	ElseIf ZZ1->MOTIVO $ "DC*DI*di*dc"
	   SR7->R7_TIPO := "003"      
   	ElseIf ZZ1->MOTIVO $ "EQ*eq"
	   SR7->R7_TIPO := "008"      
   	ElseIf ZZ1->MOTIVO $ "MA*ma"
	   SR7->R7_TIPO := "009"      
	ElseIf ZZ1->MOTIVO $ "OT*ot"
	   SR7->R7_TIPO := "010"      
   	ElseIf ZZ1->MOTIVO $ "PI*pi"
	   SR7->R7_TIPO := "011"      
	ElseIf ZZ1->MOTIVO $ "PR*pr*Pr"
	   SR7->R7_TIPO := "012"      
    ENDIF
    
   MSUNLOCK()
   

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
 
 DBSELECTAREA("SRJ")
 DBCLOSEAREA()

 #IFDEF WINDOWS
    MsgAlert ("Importacao Finalizada")
 #ELSE
    Alert("Importacao Finalizada")
 #ENDIF        

RETURN

Static Function fPergConv()

Local aRegs     := {}

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aAdd(aRegs,{cPerg,'01' ,'Arquivo Origem     ?',''				 ,''			 ,'mv_ch1','C'  ,30     ,0      ,0     ,'G','U_fOpen_Conv()                         ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'02' ,'Empresa Origem     ?',''				 ,''			 ,'mv_ch2','C'  ,04     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'',''})
//aAdd(aRegs,{cPerg,'03' ,'Filial Destino     ?',''				 ,''			 ,'mv_ch3','C'  ,02     ,0      ,0     ,'G','                                ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SM0',''})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Carrega as Perguntas no SX1                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ValidPerg(aRegs,cPerg)


Return NIL


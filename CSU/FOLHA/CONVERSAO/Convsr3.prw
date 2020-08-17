#include "rwmake.ch"

User Function ConvSR3()

 Local	oDlg	:= NIL


 Private cPerg	:= PADR("CONSR3",LEN(SX1->X1_GRUPO))
 Private aInfo	:= {}
 Private aDepende:= {}
 Private nDepen	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao do Cadastro de Valores Salariais")
 @ 008,010 TO 084,222
 @ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")						 												
 @ 030,020 SAY OemToAnsi("Selecao dos Parametros")																		
 @ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )	
 @ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSr3() }  )      
 @ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSr3()

 cArqOrig := MV_PAR01
 cEmpOrig := MV_PAR02
// cFilDest := MV_PAR03
 

// ARQUIVO PFHSTSAL.DBF
 
 dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")          
 
 dbUseArea(.T.,,"\CONV\DBO_PFUN.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ2")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="(STR(CODCOLIG,1))+(CHAPA)"
 IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."  




 #IFDEF WINDOWS
   Processa({|| ImpSr3() },"Importando SR3")

 #ENDIF        

//return
  
Static Function Impsr3()


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
   
        DBSELECTAREA("SR3")
     
        RECLOCK("SR3",.T.)
        SR3->R3_FILIAL := cFilDest
        SR3->R3_MAT    := _Mat
        SR3->R3_DATA   := ZZ1->DTMUDANCA
        SR3->R3_PD	   := "000"
        SR3->R3_DESCPD := "SALARIO BASE"
        SR3->R3_VALOR  := ZZ1->SALARIO
	If ZZ1->MOTIVO $ "TI*M *00*01*02*03*04*05*06*07*08*11*12*13*14*15*16*17*18*19*20*21*  "
	   SR3->R3_TIPO := "013"
	ElseIf ZZ1->MOTIVO $ "10*ME*me"
	   SR3->R3_TIPO := "004"      
   	ElseIf ZZ1->MOTIVO $ "A *a "
	   SR3->R3_TIPO := "002"     
	ElseIf ZZ1->MOTIVO == "AA"
	   SR3->R3_TIPO := "001"
	ElseIf ZZ1->MOTIVO == "aa"
	   SR3->R3_TIPO := "001"	   
	ElseIf ZZ1->MOTIVO $ "AC*ac"
	   SR3->R3_TIPO := "005"
	ElseIf ZZ1->MOTIVO $ "AP*ap"
	   SR3->R3_TIPO := "006"
	ElseIf ZZ1->MOTIVO $ "CH*ch"
	   SR3->R3_TIPO := "007" 
	ElseIf ZZ1->MOTIVO $ "DC*DI*di*dc"
	   SR3->R3_TIPO := "003"      
   	ElseIf ZZ1->MOTIVO $ "EQ*eq"
	   SR3->R3_TIPO := "008"      
   	ElseIf ZZ1->MOTIVO $ "MA*ma"
	   SR3->R3_TIPO := "009"      
	ElseIf ZZ1->MOTIVO $ "OT*ot"
	   SR3->R3_TIPO := "010"      
   	ElseIf ZZ1->MOTIVO $ "PI*pi"
	   SR3->R3_TIPO := "011"      
	ElseIf ZZ1->MOTIVO $ "PR*pr*Pr"
	   SR3->R3_TIPO := "012"      
   
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


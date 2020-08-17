#include "rwmake.ch"

User Function ConvSRB()

 Local	oDlg	:= NIL


 Private	cPerg	:= PADR("CONSRB",LEN(SX1->X1_GRUPO))
 Private aInfo	:= {}
 Private aDepende:= {}
 Private nDepen	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao do Cadastro de Dependentes")
 @ 008,010 TO 084,222
 @ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")						 												
 @ 030,020 SAY OemToAnsi("Selecao dos Parametros")																		
 @ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )	
 @ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSrb() }  )      
 @ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSrb()

 cArqOrig := MV_PAR01
 cEmpOrig := MV_PAR02
// cFilDest := MV_PAR03
    
//ARQUIVO DBO_PFDE.DBF

 dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")          
 
 dbUseArea(.T.,,"\CONV\DEZEMBRO\DBO_PFUN.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ2")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="STR(CODCOLIG,1)+(CHAPA)"
 IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."  
 
 //dbUseArea(.T.,,"\CONV\ODPREV.DBF","ZZ3",.F.)  // Abrir exclusivo no Sigaadv
/*/ dbUseArea(.T.,	"TOPCONN","ODPREV","ZZ3",.F.)
 DBSELECTAREA("ZZ3")
 cArqNtx  := CriaTrab(NIL,.f.)
// cIndCond :="CPF1+DTOC(DATA_NASCI)"
 cIndCond :="CPF1+DATA_NASCI"
 IndRegua("ZZ3",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."  
 
 dbUseArea(.T.,,"\CONV\OD_LIXO.DBF","ZZ4",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ4")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="CPF"
 IndRegua("ZZ4",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."
 /*/

 #IFDEF WINDOWS
   Processa({|| ImpSrb() },"Importando SRB")
 #ENDIF        

 Static Function Impsrb()

 ProcRegua(RecCount())                                       
                    
 DBSELECTAREA("ZZ1")
 
 DO WHILE !EOF()
   
   If Val(cEmpOrig) # ZZ1->CODCOLIGAD
      DbSkip()
      Incproc()
      Loop
   Endif
     
     DBSELECTAREA("ZZ2")

     cPesq := STR(ZZ1->CODCOLIGAD,1)+(ZZ1->CHAPA)
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
/*/
     DBSELECTAREA("SRA")
     DBSETORDER(1)
       If Dbseek(cFilDest + _MAT)
		     DBSELECTAREA("ZZ3")
        		 IF Dbseek(SRA->RA_CIC + DTOS(ZZ1->DTNASCIMEN))
		            CODONTO := "S"  
		              Reclock("ZZ3",.F.)
		                ZZ3->FILIAL    := cFildest
		                ZZ3->MATRICULA := _Mat
		              MSUNLOCK()
        		 Else 
		            CODONTO := "N"
        		 Endif 
        Else 		 
            CODONTO := "N"        		 
     	Endif 
/*/     	
      DBSELECTAREA("SRB")
      DBSETORDER(1)
   
/*     IF DBSEEK(CFILDEST+_MAT)
        dbSelectArea("ZZ1")
        DbSkip()
        IncProc()
        Loop
     ELSE*/
        RECLOCK("SRB",.T.)                
//     ENDIF
     
        SRB->RB_FILIAL := cFilDest
        SRB->RB_MAT    := _Mat
        SRB->RB_COD    := strzero(ZZ1->NRODEPEND,2)
        SRB->RB_NOME   := ZZ1->NOME
        SRB->RB_DTNASC := ZZ1->DTNASCIMEN
        SRB->RB_SEXO   := SUBS(ZZ1->SEXO,1,1)
        SRB->RB_LOCNASC:= ZZ1->LOCALNASCI
        SRB->RB_CARTORI:= ZZ1->CARTORIO
        SRB->RB_NREGCAR:= ZZ1->NROREGISTR
        SRB->RB_NUMLIVR:= ZZ1->NROLIVRO
        SRB->RB_NUMFOLH:= ZZ1->NROFOLHA
        SRB->RB_DTENTRA:= ZZ1->DATAENTREG
        SRB->RB_ASSIMED:= IIF(ZZ1->INCASSISTM=1,"S","N")
//        SRB->RB_ODONTO := 
        
   IF ZZ1->GRAUPARENT = "1" 
      SRB->RB_GRAUPAR:= "F"        
      SRB->RB_TIPIR  := "3"
      SRB->RB_TIPSF  := "2"
   ELSEIF ZZ1->GRAUPARENT = "3" 
      SRB->RB_GRAUPAR:= "F"        
      SRB->RB_TIPIR  :=  "1"
      SRB->RB_TIPSF  :=  "1"
   ELSEIF ZZ1->GRAUPARENT = "5" 
      SRB->RB_GRAUPAR:= "C"      
      SRB->RB_TIPIR  :=  "1"
      SRB->RB_TIPSF  :=  "3"
   ELSE 
      SRB->RB_GRAUPAR:= "O"      
	  SRB->RB_TIPSF  :=  "3"      
      IF ZZ1->INCIRRF = 1 
	     SRB->RB_TIPIR  :=  "1"
	  ELSE 
	        SRB->RB_TIPIR  :=  "4"
	  ENDIF    
   ENDIF
    
      SRB->RB_FILIAC := ALLTRIM(ZZ1->GRAUPARENT)

   MSUNLOCK()
   DBSELECTAREA("ZZ1")

   DBSKIP()
   INCPROC()

 ENDDO     
                    
 DBSELECTAREA("ZZ1")
 DBCLOSEAREA()
                    
 DBSELECTAREA("ZZ2")
 DBCLOSEAREA()
 
// DBSELECTAREA("ZZ3")
// DBCLOSEAREA()
 
// DBSELECTAREA("ZZ4")
// DBCLOSEAREA()    
 
// DBSELECTAREA("SRA")
// DBCLOSEAREA()

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


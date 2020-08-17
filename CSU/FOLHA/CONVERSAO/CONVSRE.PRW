#include "rwmake.ch"

User Function ConvSRE()

 Local	oDlg	:= NIL


 Private cPerg	:= PADR("CONSRA",LEN(SX1->X1_GRUPO))
 Private aInfo	:= {}
 Private aDepende:= {}
 Private nDepen	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao do Cadastro de Transferencias")
 @ 008,010 TO 084,222
 @ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")						 												
 @ 030,020 SAY OemToAnsi("Selecao dos Parametros")																		
 @ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )	
 @ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSre() }  )      
 @ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSre()

 cArqOrig := MV_PAR01
 cEmpOrig := MV_PAR02
 cFilDest := MV_PAR03

// ARQUIVO DBO_PFUN.DBF 
//*** O CPO. TIPOADMI, DESTE ARQUIVO DEVERA SER EFETUADO UM "REPLACE" COM 'T', CASO O MESMO 
// SEJA IGUAL A 'E', PARA QUE O INDICE SEJA CORRETO.

 dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="STRZERO(CODPESSOA,6)+DTOS(DATAADMI)+TIPOADMI+DTOS(DTTRANSF)"
 IndRegua("ZZ1",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."


//  SET FILTER TO CODPESSOA = 2715


 #IFDEF WINDOWS
//   Processa({|| Execute( ImpSra() )},"Importando SRA")
   Processa({|| ImpSre() },"Montando o SRE")
  //static Function Impsra()

 #ENDIF        

//return
  
Static Function Impsre()

dbSelectArea("ZZ1")
dbGoTop()
ProcRegua(RecCount())                                       
 
 DO WHILE !EOF()
   
   
   If !ZZ1->TIPODEMI $"5-6"
      DbSkip()
      IncProc()
      Loop
   Endif     

   dDTTransf := ZZ1->DATADEMI
   
   If ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 1
      cFilOri := "08"
   Elseif ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 2   
      cFilOri := "06"
   Elseif ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 4   
      cFilOri := "04" 
   Elseif ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 5   
      cFilOri := "05"
   Elseif ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 6   
      cFilOri := "03"
   Elseif ZZ1->CODCOLIG = 4 .AND. ZZ1->CODFILIAL = 1   
      cFilOri := "07"
   Elseif ZZ1->CODCOLIG = 5 .AND. ZZ1->CODFILIAL = 1   
      cFilOri := "02"
   Elseif ZZ1->CODCOLIG = 5 .AND. ZZ1->CODFILIAL = 2   
      cFilOri := "09"
   Elseif ZZ1->CODCOLIG = 5 .AND. ZZ1->CODFILIAL = 3   
      cFilOri := "01"
   Endif
                     
   If Subs(ZZ1->CHAPA,6,1) = "B"
      cMatOri := "5" + SUBS(ZZ1->CHAPA,1,5)   
   ElseIf Subs(ZZ1->CHAPA,6,1) = "R"
      cMatOri := "6" + SUBS(ZZ1->CHAPA,1,5)   
   Else
      cMatOri := "0" + SUBS(ZZ1->CHAPA,1,5)   
   Endif                                        
   
   cCCOri := IIF(SUBS(ZZ1->CODSECAO,3,1)="R",SUBS(ZZ1->CODSECAO,1,1)+SUBS(ZZ1->CODSECAO,3,8),SUBS(ZZ1->CODSECAO,1,1)+SUBS(ZZ1->CODSECAO,3,2)+SUBS(ZZ1->CODSECAO,6,2)+SUBS(ZZ1->CODSECAO,9,2))

   dbskip()
           
   If ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 1
      cFilDest := "08"
   Elseif ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 2   
      cFilDest := "06"
   Elseif ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 4   
      cFilDest := "04" 
   Elseif ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 5   
      cFilDest := "05"
   Elseif ZZ1->CODCOLIG = 3 .AND. ZZ1->CODFILIAL = 6   
      cFilDest := "03"
   Elseif ZZ1->CODCOLIG = 4 .AND. ZZ1->CODFILIAL = 1   
      cFilDest := "07"
   Elseif ZZ1->CODCOLIG = 5 .AND. ZZ1->CODFILIAL = 1   
      cFilDest := "02"
   Elseif ZZ1->CODCOLIG = 5 .AND. ZZ1->CODFILIAL = 2   
      cFilDest := "09"
   Elseif ZZ1->CODCOLIG = 5 .AND. ZZ1->CODFILIAL = 3   
      cFilDest := "01"
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
   
   cMatDest := _MAT
   cCCDest := IIF(SUBS(ZZ1->CODSECAO,3,1)="R",SUBS(ZZ1->CODSECAO,1,1)+SUBS(ZZ1->CODSECAO,3,8),SUBS(ZZ1->CODSECAO,1,1)+SUBS(ZZ1->CODSECAO,3,2)+SUBS(ZZ1->CODSECAO,6,2)+SUBS(ZZ1->CODSECAO,9,2))


   DBSELECTAREA("SRE")
   RECLOCK("SRE",.T.)                


    SRE->RE_DATA    := dDtTransf
    SRE->RE_EMPD    := "05"
    SRE->RE_FILIALD := cFilOri
    SRE->RE_MATD    := cMatOri
    SRE->RE_CCD     := cCCOri
    SRE->RE_EMPP    := "05"
    SRE->RE_FILIALP := cFilDest
    SRE->RE_MATP    := cMatDest
    SRE->RE_CCP     := cCCDest

   MSUNLOCK()                                                          
   
    DBSELECTAREA("CTT")
     cArqNtx  := CriaTrab(NIL,.f.)
     cIndCond :="CTT_FILIAL + CTT_CCANT"
     IndRegua("CTT",cArqNtx,cIndCond,,,"Selecionando registros...")	
 
   If Dbseek("  " +SRE->RE_CCD)
   
    	DBSELECTAREA("SRE")       
       	  RECLOCK("SRE",.F.)              
        	SRE->RE_CCD := CTT->CTT_CUSTO
          MSUNLOCK()
    Endif

    DBSELECTAREA("CTT")     
    If Dbseek("  " +SRE->RE_CCP)
   
    	DBSELECTAREA("SRE")       
       	  RECLOCK("SRE",.F.)              
        	SRE->RE_CCP := CTT->CTT_CUSTO
          MSUNLOCK()
    Endif	
        	

   
   DBSELECTAREA("ZZ1")

//   DBSKIP()
   INCPROC()

 ENDDO

 DBSELECTAREA("ZZ1")
 DBCLOSEAREA()
              
 DBSELECTAREA("CTT")
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


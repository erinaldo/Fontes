#include "rwmake.ch"

User Function GERAREG()

 Local	oDlg	:= NIL


 Private cPerg	:= PADR("GERAREG",LEN(SX1->X1_GRUPO))
 Private aInfo	:= {}
 Private aDepende:= {}
 Private nDepen	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("GERA NRO. DE FICHA REGISTRO")
 @ 008,010 TO 084,222
 @ 018,020 SAY OemToAnsi(" A geracao da numeracao serА realizada de acordo com o nro. de Filial ")						 												
 @ 030,020 SAY OemToAnsi("e Data de Admissao do funcionario")																		
 @ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )	
 @ 095,072 BUTTON OemToAnsi(" Gerar Numeracao " ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , GeraReg() }  )      
 @ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function GeraRegI()

 cFilial := MV_PAR01
   
 DBSELECTAREA("SRA")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="SRA->RA_FILIAL + DTOS(SRA->RA_ADMISSA)"
 IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."  


 #IFDEF WINDOWS
   Processa({|| GeraRegi2() },"Gerando Numeracao")

 #ENDIF        

  
Static Function GeraRegi2()

 ProcRegua(RecCount())                                       
 
 DO WHILE !EOF()
   
   If cFilial # SRA->RA_FILIAL 
      DbSkip()
      Incproc()
      Loop
   Endif
          
   DBSELECTAREA("SRA")

       If SRA->RA_FILIAL $ "01*13" 
          _CodReg := " "
       ElseIf SRA->RA_FILIAL = "02" 
          _CodReg := " "            
       ElseIf SRA->RA_FILIAL = "03" 
          _CodReg := " "             
       ElseIf SRA->RA_FILIAL = "04" 
          _CodReg := " "                  
       ElseIf SRA->RA_FILIAL = "05" 
          _CodReg := " "                                                       
       ElseIf SRA->RA_FILIAL = "06" 
          _CodReg := " "             
       ElseIf SRA->RA_FILIAL = "07"
          _CodReg := " "
       ElseIf SRA->RA_FILIAL = "08"
          _CodReg := " "         
       ElseIf SRA->RA_FILIAL = "09"
          _CodReg := " "         
	   Endif
                                  
     
      DBSELECTAREA("SRA")
      Dbskip()
      Loop
      
 //   Endif   
 
       DBSELECTAREA("SRA")
     
        RECLOCK("SRA",.T.)
        SRA->RA_FILIAL := cFilial 
                                             
    
   MSUNLOCK()

   DBSKIP()
   INCPROC()

 ENDDO

 DBSELECTAREA("SRA")
 DBCLOSEAREA()

 #IFDEF WINDOWS
    MsgAlert ("Geracao Finalizada")
 #ELSE
    Alert("Geracao Finalizada")
 #ENDIF        

RETURN

Static Function fPergConv()

Local aRegs     := {}

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aAdd(aRegs,{cPerg,'01' ,'Filial     ?',''				 ,''			 ,'mv_ch1','C'  ,02     ,0      ,0     ,'G','                                ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SM0',''})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Carrega as Perguntas no SX1                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ValidPerg(aRegs,cPerg)


Return NIL


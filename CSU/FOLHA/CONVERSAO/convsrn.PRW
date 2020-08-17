#include "rwmake.ch"

User Function ConvSRN()

 Local	oDlg	:= NIL

 Private cPerg	:= PADR("CONSRN",LEN(SX1->X1_GRUPO))
 Private aInfo	:= {}

 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao do Cadastro de Meios de Transportes")
 @ 008,010 TO 084,222
 @ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")						 												
 @ 030,020 SAY OemToAnsi("Selecao dos Parametros")																		
 @ 095,042 BMPBUTTON TYPE 5   ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )	
 @ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSrN() }  )      
 @ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSrn()

 cArqOrig := MV_PAR01    
 cEmpOrig := MV_PAR02
// cFil     := MV_PAR03


// ARQUIVO .DBF PVALETR.DBF => ZZ1
// ARQUIBO .DBF PTARIFA.DBF => ZZ2

 dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")   
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="STRZERO(CODCOLIGAD,2)+CODIGO"
 IndRegua("ZZ1",cArqNtx,cIndCond,,,"Selecionando registros...")	 

 dbUseArea(.T.,,"\CONV\PTARIFA.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ2")   
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="STRZERO(CODCOLIGAD,2)+CODIGO"
 IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")	

 #IFDEF WINDOWS
   Processa({|| ImpSrn() },"Importando SRN")
 #ENDIF        
 
Static Function Impsrn()

dbSelectArea("ZZ2")
dbGoTop()

dbSelectArea("ZZ1")
dbGoTop()
ProcRegua(RecCount())                                    
 
 DO WHILE !EOF()
   
   If Val(cEmpOrig) # ZZ1->CODCOLIGAD
      DbSkip()
      IncProc()
      Loop
   Endif               
   
    dbSelectArea("ZZ2")        
	IF DBSEEK(STRZERO(ZZ1->CODCOLIGAD,2)+ZZ1->CODTARIFA)
              
	   	DBSELECTAREA("SRN")
   		RECLOCK("SRN",.T.)                
		SRN->RN_FILIAL := ""
		SRN->RN_COD	   := SUBSTR(ZZ1->CODIGO,2,2)
		SRN->RN_DESC   := ZZ2->DESCRICAO
		SRN->RN_VUNIATU:= ZZ2->VALOR
   		SRN->RN_ITEMPED:= ZZ1->NOMELINHA   
   		SRN->RN_DATVIGE:= ZZ2->INICIOVIGE
   		SRN->RN_DESCTT := ZZ1->CODITINERA	
   		SRN->RN_CODRM  := ZZ1->CODIGO	
   		MSUNLOCK()
   			
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


#include "rwmake.ch"

User Function ConvSRG()

 Local	oDlg	:= NIL


 Private cPerg	:= PADR("CONSRG",LEN(SX1->X1_GRUPO))
 Private aInfo	:= {}
 Private aDepende:= {}
 Private nDepen	:= 0


 @ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao do Cadastro de Cabec Rescisao")
 @ 008,010 TO 084,222
 @ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")						 												
 @ 030,020 SAY OemToAnsi("Selecao dos Parametros")																		
 @ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )	
 @ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSrg() }  )      
 @ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSrg()

 cArqOrig := MV_PAR01
 cEmpOrig := MV_PAR02
// cFilDest := MV_PAR03
 

// ARQUIVO PFUNC.DBF
 
 dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ1")          
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="(STR(CODCOLIG,1))+(CHAPA)"
 IndRegua("ZZ1",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."
/*/
 dbUseArea(.T.,,"\CONV\DBO_PFUN.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
 DBSELECTAREA("ZZ2")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond :="(STR(CODCOLIG,1))+(CHAPA)"
 IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")		//"Selecionando Registros..."  
/*/


 #IFDEF WINDOWS
   Processa({|| ImpSrg() },"Importando SRG")

 #ENDIF        

//return
  
Static Function ImpsrG()


 ProcRegua(RecCount())                                       
                    
 
 DO WHILE !EOF()
   
   If Val(cEmpOrig) # ZZ1->CODCOLIG
      DbSkip()
      Incproc()
      Loop
   Endif
  
        
   DBSELECTAREA("ZZ1")

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
                     
                                   
/*/   Else
   
      DBSELECTAREA("ZZ1")
      Dbskip()
      Loop
      
   Endif   
/*/  
   If SUBS(ZZ1->CHAPA,6,1)="B" 
      _MAT := "5" + SUBS(ZZ1->CHAPA,1,5)
   ElseIf SUBS(ZZ1->CHAPA,6,1)="R"                    
      _MAT := "6"+SUBS(ZZ1->CHAPA,1,5)
   ElseIf SUBS(ZZ1->CHAPA,6,1)=" "                    
      _MAT := "0"+SUBS(ZZ1->CHAPA,1,5)      
   Else    
      _MAT := SUBS(ZZ1->CHAPA,1,6)
   Endif      
   
        DBSELECTAREA("SRG")
        RECLOCK("SRG",.T.)
        SRG->RG_FILIAL := cFilDest
        SRG->RG_MAT    := _Mat
        SRG->RG_SALMES := ZZ1->SALARIO
        SRG->RG_SALDIA := (ZZ1->SALARIO)/30
        SRG->RG_SALHORA:= (ZZ1->SALARIO)/(ZZ1->JORNADAM/60)
        SRG->RG_DATADEM:= ZZ1->DTDESLIGA
        SRG->RG_DATAHOM:= ZZ1->DTPAGTORE
        SRG->RG_DAVISO := ZZ1->NRODIASAV
        SRG->RG_DTAVISO:= ZZ1->DTAVISOP
        SRG->RG_DFERVEN:= IIf(ZZ1->SALDOFER > 0,ZZ1->SALDOFER,0) 
        SRG->RG_DFERPRO:= 0
        SRG->RG_DTGERAR:= ZZ1->DTDESLIGA
        SRG->RG_MEDATU := "S"
        SRG->RG_EFETIVA:= "S"
		SRG->RG_USERLGA:= "IMPORTACAO"
        _TCasa := INT((ZZ1->DTDESLIGA - ZZ1->DATAADMI)/364)
        
        If ZZ1->TIPODEMI == "1" // Justa Causa 
           _TIPODEM := "03"
        ElseIf ZZ1->TIPODEMI == "2" .AND. ZZ1->NRODIASAV > 0 //A.P. Inden.
           _TIPODEM := "01"
        ElseIf ZZ1->TIPODEMI == "2" .AND. ZZ1->NRODIASAV = 0 //A.P. Trab.
           _TIPODEM := "02"         
        ElseIf ZZ1->TIPODEMI == "4" .AND. _TCasa >= 1 //Pedido Demissao + 1 ano    
           _TIPODEM := "04"                
        ElseIf ZZ1->TIPODEMI == "4" .AND. _TCasa < 1 //Pedido Demissao - 1 ano    
           _TIPODEM := "05"                
        ElseIf ZZ1->TIPODEMI == "9" //Rescisao de Estagiarios
           _TIPODEM := "12"                     
        ElseIf ZZ1->TIPODEMI == "T" .AND. ZZ1->FIMPRAZO == ZZ1->DTDESLIGA //Termino de Contrato 
           _TIPODEM := "06"                                                                       
        ElseIf ZZ1->TIPODEMI == "T" .AND. ZZ1->FIMPRAZO > ZZ1->DTDESLIGA //Termino de Contrato Antecipado
           _TIPODEM := "14"                                                                       
        Endif    
      
        SRG->RG_TIPORES := _TIPODEM
    
   MSUNLOCK()
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


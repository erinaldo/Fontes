#include "rwmake.ch"

User Function ConvSR0()

Local	oDlg	:= NIL

Private cPerg	:= PADR("CONSR0",LEN(SX1->X1_GRUPO))
Private aInfo	:= {}

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao do Cadastro de Itens de Transportes")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")
@ 030,020 SAY OemToAnsi("Selecao dos Parametros")
@ 095,042 BMPBUTTON TYPE 5   ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )
@ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSr0() }  )
@ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSr0()

cArqOrig := MV_PAR01
cEmpOrig := MV_PAR02
// cFil     := MV_PAR03


// ARQUIVO .DBF PFVALETR.DBF => ZZ1
// ARQUIBO .DBF PFUNC.DBF => ZZ2

dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
DBSELECTAREA("ZZ1")
cArqNtx  := CriaTrab(NIL,.f.)
cIndCond :="STRZERO(CODCOLIGAD,2)+CHAPA"
IndRegua("ZZ1",cArqNtx,cIndCond,,,"Selecionando registros...")

dbUseArea(.T.,,"\CONV\DEZEMBRO\DBO_PFUN.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
DBSELECTAREA("ZZ2")
cArqNtx  := CriaTrab(NIL,.f.)
cIndCond :="STRZERO(CODCOLIG,2)+CHAPA"
IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")
 
DBSELECTAREA("SRN")
cArqNtx  := CriaTrab(NIL,.f.)
cIndCond :="RN_CODRM"
IndRegua("SRN",cArqNtx,cIndCond,,,"Selecionando registros...")


#IFDEF WINDOWS
	Processa({|| ImpSr0() },"Importando SR0")
#ENDIF

Static Function Impsr0()

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
	IF DBSEEK(STRZERO(ZZ1->CODCOLIGAD,2)+ZZ1->CHAPA)
		
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
		
		If SUBS(ZZ2->CHAPA,6,1)="B"
			_MAT := "5" + SUBS(ZZ2->CHAPA,1,5)
		ElseIf SUBS(ZZ2->CHAPA,6,1)="R"
			_MAT := "6"+SUBS(ZZ2->CHAPA,1,5)
		ElseIf SUBS(ZZ2->CHAPA,6,1)=" "
			_MAT := "0"+SUBS(ZZ2->CHAPA,1,5)
		Else
			_MAT := SUBS(ZZ2->CHAPA,1,6)
		Endif
		    D:=ZZ1->CODLINHA
		   	DBSELECTAREA("SRN")
			If Dbseek(ALLTRIM(ZZ1->CODLINHA))
		
				DBSELECTAREA("SR0")
			     IF DBSEEK(CFILDEST+_MAT+SRN->RN_COD)
			        dbSelectArea("ZZ1")
			        DbSkip()
			        IncProc()
			        Loop
			     ELSE
			        RECLOCK("SR0",.T.)                
			     ENDIF

				SR0->R0_FILIAL	:= cFilDest
				SR0->R0_MAT		:= _MAT
				SR0->R0_MEIO	:= SRN->RN_COD
				SR0->R0_QDIAINF := ZZ1->NROVIAGENS
				MSUNLOCK()                  
		
			Else 
				alert('Codigo nЦo encontrado',D)
			Endif
			
	Endif
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


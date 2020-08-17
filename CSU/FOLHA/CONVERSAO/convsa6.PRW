#include "rwmake.ch"

User Function ConvSA6()

Local	oDlg	:= NIL

Private cPerg	:= PADR("CONSA6",LEN(SX1->X1_GRUPO))
Private aInfo	:= {}

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Conversao do Cadastro de Bancos")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(" A conversao dos arquivos serЦo realizados de acordo com a ")
@ 030,020 SAY OemToAnsi("Selecao dos Parametros")
@ 095,042 BMPBUTTON TYPE 5   ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )
@ 095,072 BUTTON OemToAnsi(" Converte Dados" ) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , MigraSA6() }  )
@ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSA6()

cArqOrig := MV_PAR01
//cEmpOrig := MV_PAR02
// cFil     := MV_PAR03


// ARQUIVO .DBF GBANCO.DBF => ZZ1
// ARQUIBO .DBF GAGENCIA.DBF => ZZ2

dbUseArea(.T.,,cArqOrig,"ZZ1",.F.)  // Abrir exclusivo no Sigaadv
DBSELECTAREA("ZZ1")
cArqNtx  := CriaTrab(NIL,.f.)
cIndCond :="NUMBANCO"
IndRegua("ZZ1",cArqNtx,cIndCond,,,"Selecionando registros...")

dbUseArea(.T.,,"\CONV\GAGENCIA.DBF","ZZ2",.F.)  // Abrir exclusivo no Sigaadv
DBSELECTAREA("ZZ2")
cArqNtx  := CriaTrab(NIL,.f.)
cIndCond :="NUMBANCO"
IndRegua("ZZ2",cArqNtx,cIndCond,,,"Selecionando registros...")

#IFDEF WINDOWS
	Processa({|| ImpSA6() },"Importando SA6")
#ENDIF

Static Function ImpsA6()

DBSELECTAREA("ZZ2")
dbGoTop()

dbSelectArea("ZZ1")
dbGoTop()
ProcRegua(RecCount())

DO WHILE !EOF()
	
	DBSELECTAREA("ZZ2")
	IF DBSEEK(ZZ1->NUMBANCO)
		
		DO WHILE ZZ1->NUMBANCO=ZZ2->NUMBANCO
		
			DBSELECTAREA("SA6")
			RECLOCK("SA6",.T.)
			SA6->A6_FILIAL := ""
			SA6->A6_COD	   := ZZ1->NUMBANCO
			SA6->A6_AGENCIA:= STRZERO(VAL(STRTRAN(ALLTRIM(ZZ2->NUMAGENCIA)+ALLTRIM(ZZ2->DIGAG),"-","")),5)
			SA6->A6_NUMCON := "0"
			SA6->A6_NOMEAGE:= ZZ2->NOME
			SA6->A6_NUMCON := ""
			SA6->A6_NOME   := ZZ1->NOME
			SA6->A6_NREDUZ := ZZ1->NOMEREDUZI
			SA6->A6_END    := ALLTRIM(ZZ2->RUA)+', '+ALLTRIM(ZZ2->NUMERO)
			SA6->A6_BAIRRO := ZZ2->BAIRRO
			SA6->A6_MUN    := ZZ2->CIDADE
			SA6->A6_CEP    := ZZ2->CEP
			SA6->A6_EST    := ZZ2->ESTADO
			MSUNLOCK()
		
			DBSELECTAREA("ZZ2")
			DBSKIP()
				
		ENDDO
		
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
//aAdd(aRegs,{cPerg,'02' ,'Empresa Origem     ?',''				 ,''			 ,'mv_ch2','C'  ,04     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'',''})
//aAdd(aRegs,{cPerg,'03' ,'Filial Destino     ?',''				 ,''			 ,'mv_ch3','C'  ,02     ,0      ,0     ,'G','                                ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SM0',''})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Carrega as Perguntas no SX1                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ValidPerg(aRegs,cPerg)


Return NIL


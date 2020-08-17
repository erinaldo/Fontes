#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RATFM01  ³ Autor ³ Marcos Eduardo Rocha   ³ Data ³ 01/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importa Arquivos de Ativo Fixo                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico CSU                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RATFM01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis da Rotina                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSays     	:= {}
Local aAreaAtu		:= GetArea()
Local aRegs			:= {}
Local aButtons  	:= {}
Local nOpca     	:= 0
Local cPerg			:= PADR("ATFM1C",LEN(SX1->X1_GRUPO))
Private cPathImp	:= ""
Private cCadastro := "Importa Arquivos de Ativo Fixo"
Private lEnd		:= .F.
Private cDirImp	:= ""
Private cDirBac
Private aArquivos := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros utilizados                            ³
//³ mv_par01 - Pasta de Arquivos a Importar          ³
//³ mv_par02 - Pasta de Arquivos Processados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Aadd(aRegs,{cPerg,"01","Contrato Inicial"		,"","",           "mv_ch1" ,"C", 06,0,1  ,"G","",	  "MV_PAR03","","","","","","",	"","","","","","","","","","","","","","","","","","","",	"","","",""})
aAdd(aRegs,{cPerg,"01","Abertura de Leasing - AL ?" , "", "", "mv_ch1", "N", 01, 0, 0, "C", "", "mv_par01","Importa","","","","","Ignora",	"","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"02","Baixa de Contrato - BC ?"   ,	 "", "", "mv_ch2", "N", 01, 0, 0, "C", "", "mv_par02","Importa","","","","","Ignora","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"03","Nao Objeto - NO ?"          ,	 "", "", "mv_ch3", "N", 01, 0, 0, "C", "", "mv_par03","Importa","","","","","Ignora","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"04","Sobra de Leasing - SL ?"    ,	 "", "", "mv_ch4", "N", 01, 0, 0, "C", "", "mv_par04","Importa","","","","","Ignora","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"05","Sobra de Nao Objeto- SNO ?" ,	 "", "", "mv_ch5", "N", 01, 0, 0, "C", "", "mv_par05","Importa","","","","","Ignora","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"06","Data Baixa ?" 					  , "", "", "mv_ch6", "D", 08, 0, 0, "G", "", "mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
//aAdd(aRegs,{cPerg,"07","Operacao ?" 					  , "", "", "mv_ch7", "N", 01, 0, 0, "C", "", "mv_par07","Inclusão","","","","","Transferencia","","","","","Baixa","","","","","Nenhuma","","","","","Todas","","","","","","","","" })
aAdd(aRegs,{cPerg,"07","Operacao ?" 					  , "", "", "mv_ch7", "N", 01, 0, 0, "C", "", "mv_par07","Inclusão","","","","","Transferencia","","","","","Baixa","","","","","Nenhuma","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"08","Qtd Operacoes ?" 				  , "", "", "mv_ch8", "N", 15, 0, 0, "G", "", "mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"09","Contabiliza ?" 				  , "", "", "mv_ch9", "N", 01, 0, 0, "C", "", "mv_par09","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","" })
CriaSX1(aRegs)
If !Pergunte(cPerg,.T.)
	Return
EndIf

nOpca   := 0

aAdd(aSays,"Este programa tem como objetivo importar os arquivos de Ativo Fixo" )
aAdd(aSays,"conforme os parâmetros definidos pelo usuário."	)
aAdd(aSays,""																)
aAdd(aSays,"Defina os parâmetros da rotina."						)
Aadd(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() }} )
Aadd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
Aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1      
	If MV_PAR07 <> 4
		cPathImp	:= Alltrim(cGetFile("Arquivos DBF|*.DBF|Todos os Arquivos|*.*", OemToAnsi("Informe o diretório onde encontram-se os arquivos DBFs a serem importados"),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY))
		If Right(cPathImp,1) <> "\"
			cPathImp := cPathImp + "\"
		Endif
		If Empty(cPathImp)
			Aviso("Inconsistência","Diretório dos arquivos DBFs inválido..",{"Ok"},,"Atenção:",,"NOCHECKED")
			Return
		Endif    
	Endif
	
   Processa({|lEnd| RunProc()},cCadastro)
	Aviso(OemToAnsi("Processamento Finalizado"),OemToAnsi("Importacao Finalizada !"), {"Ok"},1,OemToAnsi("Proc.Finalizado"))

EndIf
RestArea(aAreaAtu)

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RunProc  ³ Autor ³                       ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis da Rotina                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLoopCont	:= 0
Local cArquivo		:= ""
Local nLoop			:= 0
Local nHdlArq		:= Nil
Local cArqErro		:= ""
Local cArqBX		:= ""
Local cPath	 		:= Iif(MV_PAR07 <> 4,Alltrim(cGetFile("Arquivos TXT|*.TXT|Todos os Arquivos|*.*", OemToAnsi("Informe o diretório para gravacao da copia dos arquivos de Log"),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY)),"")
Private aContabBX	:= {}
Private aContabInc:= {}
Private aContabTrf:= {}
Private aErrosBX	:= {}
Private aMsgBX		:= {}
Private aErrosInc	:= {}
Private aMsgInc	:= {}
Private aErrosTrf	:= {}
Private aMsgTrf	:= {}
Private cPadrao	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida o diretorio de copia dos arquivos de log                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR07 <> 4
	If Right(cPath,1) <> "\"
		cPath := cPath + "\"
	Endif
	If Empty(cPath)
		Aviso("Inconsistência","Diretório de gravação dos arquivos inválido.",{"Ok"},,"Atenção:",,"NOCHECKED")
		Return
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo Arquivo, Nome do Arquivo, Qtd Reg, Qtd.Reg.c/Erro, Status, Flag, Tipo e Chave. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 1
	Aadd(aArquivos,{"AL"  , "ABERTURA DE LEASING" ,0 ,0 ,"",.F.,{}})
EndIf
If mv_par02 == 1
	Aadd(aArquivos,{"BC"  , "BAIXA DE CONTRATO"   ,0 ,0 ,"" ,.F.,{}})
EndIf
If mv_par03 == 1
	Aadd(aArquivos,{"NO"  , "NAO OBJETO"          ,0 ,0 ,"" ,.F.,{}})
EndIf
If mv_par04 == 1
	Aadd(aArquivos,{"SL"  , "SOBRA DE LEASING"    ,0 ,0 ,"" ,.F.,{}})
EndIf
If mv_par05 == 1
	Aadd(aArquivos,{"SNO" , "SOBRA DE NAO OBJETO" ,0 ,0 ,"" ,.F.,{}})
EndIf
aArqATF := {{"SN1","N1_CBASE+N1_ITEM+N1_CHAPA"},{"SN2","N2_CBASE+N2_ITEM"},{"SN3","N3_CBASE+N3_ITEM"}}

If MV_PAR07 <> 4
	If Len(aArquivos) == 0
		Aviso(OemToAnsi("Aviso"),OemToAnsi("Nenhum arquivo selecionado !"), {"Ok"},1,OemToAnsi("Proc.Cancelado"))
		Return
	EndIf
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o diretorio temporario                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDirImp := "\ArqAtivo"
nRetDir := makeDir(cDirImp)
if nRetDir != 0 .and. nRetDir != 5
	Aviso(OemToAnsi("Aviso"),OemToAnsi("Não foi possivel criar o diretorio temporario "+cDirImp+" no servidor"), {"Ok"},1,OemToAnsi("Proc.Cancelado"))
	Return
endIf
cDirImp := "\ArqAtivo\"+CriaTrab(,.F.)
nRetDir := makeDir(cDirImp)
if nRetDir != 0 .and. nRetDir != 5
	Aviso(OemToAnsi("Aviso"),OemToAnsi("Não foi possivel criar o diretorio temporario "+cDirImp+" no servidor"), {"Ok"},1,OemToAnsi("Proc.Cancelado"))
	Return
endIf
If Right(cDirImp,1) <> "\"
	cDirImp := cDirImp + "\"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copia os arquivos para o servidor              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR07 <> 4
	For nImp := 1 To Len(aArquivos)
		For nImp2 := 1 To Len(aArqATF)                                  
			If File(cPathImp+aArqATF[nImp2,1]+aArquivos[nImp,1]+".dbf")
				COPY FILE (cPathImp+aArqATF[nImp2,1]+aArquivos[nImp,1]+".dbf") TO (cDirImp+aArqATF[nImp2,1]+aArquivos[nImp,1]+".dbf")
			Endif
		Next nImp2
	Next nImp
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida de todos os arquivos foram localizados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lContinua := .T.
If MV_PAR07 <> 4
	For nImp := 1 To Len(aArquivos)
		For nImp2 := 1 To Len(aArqATF)
			If Alltrim(aArquivos[nImp,1]) $ "BC/SNO/SL" .and. nImp2 == 2
				Loop
			Endif
			cArq := cDirImp+aArqATF[nImp2,1]+aArquivos[nImp,1]+".dbf"
			If !File(cArq)
				lContinua := .F.
				Aviso(OemToAnsi("Aviso"),OemToAnsi("Arquivo não localizado : "+cArq), {"Ok"},1,OemToAnsi("Proc.Cancelado"))
			EndIf
		Next
	Next
Endif
	
If !lContinua
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os arquivos de contab Inclusao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
Aadd(aCampos, {"RECSN1"		,"N",12,00})
Aadd(aCampos, {"RECSN3"		,"N",12,00})
Aadd(aCampos, {"NCPADRAO"	,"C",10,00})
Aadd(aCampos, {"DTCTB"		,"D",08,00})
Aadd(aCampos, {"HRCTB"		,"C",05,00})
Aadd(aCampos, {"USRCTB"		,"C",15,00})
If !File("ATCTBINC.DBF")
	DbCreate("ATCTBINC.DBF",aCampos,"DBFCDX")
Endif
If !File("ATCTBINC.DBF")
	Aviso(OemToAnsi("Aviso"),OemToAnsi("Arquivo de contabilizacao não localizado : ATCTBINC.DBF"), {"Ok"},1,OemToAnsi("Proc.Cancelado"))
	Return
Endif	                                       
If Select("CTBINC") > 0
	DbSelectArea("CTBINC")
	DbCloseArea()
Endif
dbUseArea(.T.,"DBFCDX","ATCTBINC.DBF","CTBINC",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os arquivos de contab Baixa     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
Aadd(aCampos, {"RECSN1"		,"N",12,00})
Aadd(aCampos, {"RECSN3"		,"N",12,00})
Aadd(aCampos, {"NCPADRAO"	,"C",10,00})
Aadd(aCampos, {"DTCTB"		,"D",08,00})
Aadd(aCampos, {"HRCTB"		,"C",05,00})
Aadd(aCampos, {"USRCTB"		,"C",15,00})
If !File("ATCTBBX.DBF")
	DbCreate("ATCTBBX.DBF",aCampos,"DBFCDX")
Endif
If !File("ATCTBBX.DBF")
	Aviso(OemToAnsi("Aviso"),OemToAnsi("Arquivo de contabilizacao não localizado : ATCTBBX.DBF"), {"Ok"},1,OemToAnsi("Proc.Cancelado"))
	Return
Endif	
If Select("CTBBX") > 0
	DbSelectArea("CTBBX")
	DbCloseArea()
Endif
dbUseArea(.T.,"DBFCDX","ATCTBBX.DBF","CTBBX",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os arquivos de contab Transf    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
Aadd(aCampos, {"NCPADRAO"	,"C",10,00})
Aadd(aCampos, {"NCTABEM"		,"C",30,00})
Aadd(aCampos, {"NDESPDEPR"	,"C",30,00})
Aadd(aCampos, {"NDEPREACUM"	,"C",30,00})
Aadd(aCampos, {"NCORREDEPR"	,"C",30,00})
Aadd(aCampos, {"NCORREBEM"	,"C",30,00})
Aadd(aCampos, {"NCUSTO"		,"C",30,00})
Aadd(aCampos, {"NVALORIG"	,"N",20,04})
Aadd(aCampos, {"N3_SUBCCON"	,"C",30,00})
Aadd(aCampos, {"N3_CLVLCON"	,"C",30,00})
Aadd(aCampos, {"RECSN3"		,"N",12,00})
Aadd(aCampos, {"RECSN1"		,"N",12,00})
Aadd(aCampos, {"DTCTB"		,"D",08,00})
Aadd(aCampos, {"HRCTB"		,"C",05,00})
Aadd(aCampos, {"USRCTB"		,"C",15,00})
If !File("ATCTBTRF.DBF")
	DbCreate("ATCTBTRF.DBF",aCampos,"DBFCDX")
Endif
If !File("ATCTBTRF.DBF")
	Aviso(OemToAnsi("Aviso"),OemToAnsi("Arquivo de contabilizacao não localizado : ATCTBTRF.DBF"), {"Ok"},1,OemToAnsi("Proc.Cancelado"))
	Return
Endif	
If Select("CTBTRF") > 0
	DbSelectArea("CTBTRF")
	DbCloseArea()
Endif
dbUseArea(.T.,"DBFCDX","ATCTBTRF.DBF","CTBTRF",.T.)

ProcRegua(Len(aArquivos))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa primeiro a inclusao dos bens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR07 == 1 .or. MV_PAR07 == 5
	For nImp := 1 To Len(aArquivos)
		If Alltrim(aArquivos[nImp,1]) $ "BC/SNO/SL" .and. Alltrim(aArquivos[nImp,1]) <> "NO"
			Loop
		Endif
	
		IncProc(aArquivos[nImp,2])
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre os arquivos a serem importados. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nImp2 := 1 To Len(aArqATF)
			If Alltrim(aArquivos[nImp,1]) $ "BC/SNO/SL" .and. Alltrim(aArquivos[nImp,1]) <> "NO"
				Loop
			Endif
			cArq 			:= cDirImp+aArqATF[nImp2,1]+aArquivos[nImp,1]+".dbf"
			cAliasArq 	:= aArqATF[nImp2,1]+"IMP"
			dbUseArea( .T.,,cArq,cAliasArq, .F., .F. )
			
			cChave := Right(aArqATF[nImp2,1],2)+"_FILIAL+"+aArqATF[nImp2,2]
			IndRegua(cAliasArq,cAliasArq,cChave,,,"Selecionando Registros...")
		
		Next
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclusao do bem                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RATFM01Imp(aArquivos[nImp,1])
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha os arquivos a serem importados.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nImp2 := 1 To Len(aArqATF)
			cAliasArq 	:= aArqATF[nImp2,1]+"IMP"
		  	If Select(cAliasArq) > 0
				DbSelectArea(cAliasArq)
				DbCloseArea()
			Endif
		Next nImp2	
	Next
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a transferencia do bem      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR07 == 2 .or. MV_PAR07 == 5
	For nImp := 1 To Len(aArquivos)
		If Alltrim(aArquivos[nImp,1]) $ "BC/SNO/SL"  .and. Alltrim(aArquivos[nImp,1]) <> "NO"
			Loop
		Endif
	
		IncProc(aArquivos[nImp,2])
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre os arquivos a serem importados. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nImp2 := 1 To Len(aArqATF)
			If Alltrim(aArquivos[nImp,1]) $ "BC/SNO/SL" .and. nImp2 == 2
				Loop
			Endif
			cArq 			:= cDirImp+aArqATF[nImp2,1]+aArquivos[nImp,1]+".dbf"
			cAliasArq 	:= aArqATF[nImp2,1]+"IMP"
			dbUseArea( .T.,,cArq,cAliasArq, .F., .F. )
			
			cChave := Right(aArqATF[nImp2,1],2)+"_FILIAL+"+aArqATF[nImp2,2]
			IndRegua(cAliasArq,cAliasArq,cChave,,,"Selecionando Registros...")
		
		Next
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Transferencia do Bem                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RATFM01Trf(aArquivos[nImp,1])
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha os arquivos a serem importados.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nImp2 := 1 To Len(aArqATF)
			cAliasArq 	:= aArqATF[nImp2,1]+"IMP"
		  	If Select(cAliasArq) > 0
				DbSelectArea(cAliasArq)
				DbCloseArea()
			Endif
		Next nImp2	
	Next
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a baixa dos bens            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR07 == 3 .or. MV_PAR07 == 5
	For nImp := 1 To Len(aArquivos)
		If !Alltrim(aArquivos[nImp,1]) $ "BC/SNO/SL"
			Loop
		Endif                                        
		If Alltrim(aArquivos[nImp,1]) == "NO"
			Loop
		Endif                                        
	
		IncProc(aArquivos[nImp,2])
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre os arquivos a serem importados. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nImp2 := 1 To Len(aArqATF)
			If Alltrim(aArquivos[nImp,1]) $ "BC/SNO/SL" .and. nImp2 == 2
				Loop
			Endif
			If Alltrim(aArquivos[nImp,1]) == "NO"
				Loop
			Endif                                        
			cArq 			:= cDirImp+aArqATF[nImp2,1]+aArquivos[nImp,1]+".dbf"
			cAliasArq 	:= aArqATF[nImp2,1]+"IMP"
			dbUseArea( .T.,,cArq,cAliasArq, .F., .F. )
			
			cChave := Right(aArqATF[nImp2,1],2)+"_FILIAL+"+aArqATF[nImp2,2]
			IndRegua(cAliasArq,cAliasArq,cChave,,,"Selecionando Registros...")
		Next
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Baixa do bem                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RATFM01BX(aArquivos[nImp,1])
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha os arquivos a serem importados.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nImp2 := 1 To Len(aArqATF)
			cAliasArq 	:= aArqATF[nImp2,1]+"IMP"
		  	If Select(cAliasArq) > 0
				DbSelectArea(cAliasArq)
				DbCloseArea()
			Endif
		Next nImp2	
	
	Next
Endif

	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a contabilizacao da inclusao                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR09 == 1
	ProcRegua(CTBINC->(RECCOUNT()))
	lCtb			:= .F.
	dBaseOri 	:= dDataBase
	dDataBase 	:= MV_PAR06
//	cLoteAtf 	:= "8860"
	cLoteAtf 	:= "500000"
	DbSelectArea("CTBINC")
	DbGoTop()
	While !EOF()
	
		IncProc("Gerando contabilizacao da Inclusao...")
		If !Empty(CTBINC->DTCTB)
			DbSelectarea("CTBINC")
			DbSkip()
			Loop
		Endif
	
		If !lCtb
			nHdlPrv 	:= HeadProva(cLoteAtf,"ATFA010",Substr(cUsuario,7,6),@cArquivo)
			nTotal	:= 0
			lCtb		:= .T.
		Endif
							
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona as tabelas SN1 e SN3                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SN1")
		DbGoTo(CTBINC->RECSN1)
		DbSelectArea("SN3")
		DbGoTo(CTBINC->RECSN3)
		
		cPadrao	:= Alltrim(CTBINC->NCPADRAO)
		lPadrao 	:= VerPadrao(cPadrao)
		IF lPadrao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para lan‡amento cont bil, desde que exista lan‡amento padro-	³
			//³ nizado para o ativo cadastrado. 												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotal += DetProva(nHdlPrv,cPadrao,"ATFA010",cLoteAtf)
		EndIf
	                
		Reclock("CTBINC",.F.)
		CTBINC->DTCTB		:= dDataBase
		CTBINC->HRCTB		:= Left(Time(),5)
		CTBINC->USRCTB		:= Substr(cUsuario,7,15)
		MsUnlock()
	
		DbSelectarea("CTBINC")
		DbSkip()
	Enddo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lancamento Contabil							  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCtb .and. nHdlPrv > 0
		RodaProva(nHdlPrv,nTotal)
		cA100Incl(cArquivo,nHdlPrv,3,cLoteAtf,.f.,.F.)
	Endif       
	dDataBase := dBaseOri
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a contabilizacao das transferencias                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR09 == 1
	ProcRegua(CTBTRF->(RECCOUNT()))
	lCtb			:= .F.
	dBaseOri 	:= dDataBase
	dDataBase 	:= MV_PAR06
	cLoteAtf 	:= "500000"
	DbSelectArea("CTBTRF")
	DbGoTop()
	While !EOF()
		IncProc("Gerando contabilizacao da transferencia...")
		If !Empty(CTBTRF->DTCTB)
			DbSelectarea("CTBTRF")
			DbSkip()
			Loop
		Endif
	
		If !lCtb
			nHdlPrv 		:= HeadProva(cLoteAtf,"ATFA060",Substr(cUsuario,7,6),@cArquivo)
			nTotal		:= 0
			lCtb			:= .T.
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona as tabelas SN1 e SN3                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SN1")
		DbGoTo(CTBTRF->RECSN1)
		DbSelectArea("SN3")
		DbGoTo(CTBTRF->RECSN3)
		
		cPadrao		:= Alltrim(CTBTRF->NCPADRAO)
		lPadrao 		:= VerPadrao(cPadrao)
		CTABEM		:= Alltrim(CTBTRF->NCTABEM)
		DESPDEPR		:= Alltrim(CTBTRF->NDESPDEPR)
		DEPREACUM	:= Alltrim(CTBTRF->NDEPREACUM)
		CORREDEPR	:= Alltrim(CTBTRF->NCORREDEPR)
		CORREBEM		:= Alltrim(CTBTRF->NCORREBEM)
		Custo 		:= Alltrim(CTBTRF->NCUSTO)
		VALORIG		:= CTBTRF->NVALORIG
		SUBCONCTB	:= Alltrim(CTBTRF->N3_SUBCCON)
		CLVLCONCTB	:= Alltrim(CTBTRF->N3_CLVLCON)
	
		IF lPadrao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para lan‡amento cont bil, desde que exista lan‡amento padro-	³
			//³ nizado para o ativo cadastrado. 												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotal += DetProva(nHdlPrv,cPadrao,"ATFA060",cLoteAtf)
		EndIf
	
		Reclock("CTBTRF",.F.)
		CTBTRF->DTCTB		:= dDataBase
		CTBTRF->HRCTB		:= Left(Time(),5)
		CTBTRF->USRCTB		:= Substr(cUsuario,7,15)
		MsUnlock()
	
		DbSelectarea("CTBTRF")
		DbSkip()
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lancamento Contabil							  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCtb .and. nHdlPrv > 0
		RodaProva(nHdlPrv,nTotal)
		cA100Incl(cArquivo,nHdlPrv,3,cLoteAtf,.F.,.F.)
	Endif
	dDataBase := dBaseOri
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a contabilizacao da baixa                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR09 == 1
	ProcRegua(CTBBX->(RECCOUNT()))
	lCtb			:= .F.
	dBaseOri 	:= dDataBase
	dDataBase 	:= MV_PAR06
	cLoteAtf 	:= "500000"
	DbSelectArea("CTBBX")
	DbGoTop()
	While !EOF()
		IncProc("Gerando contabilizacao da baixa...")
		If !Empty(CTBBX->DTCTB)
			DbSelectarea("CTBBX")
			DbSkip()
			Loop
		Endif
		
		If !lCtb
			nHdlPrv 		:= HeadProva(cLoteAtf,"ATFA030",Substr(cUsuario,7,6),@cArquivo)
			nTotal		:= 0
			lCtb			:= .t.
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona as tabelas SN1 e SN3                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SN1")
		DbGoTo(CTBBX->RECSN1)
		DbSelectArea("SN3")
		DbGoTo(CTBBX->RECSN3)
		
		cPadrao	:= Alltrim(CTBBX->NCPADRAO)
		lPadrao 	:= VerPadrao(cPadrao)
		IF lPadrao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para lan‡amento cont bil, desde que exista lan‡amento padro-	³
			//³ nizado para o ativo cadastrado. 												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotal += DetProva(nHdlPrv,cPadrao,"ATFA030",cLoteAtf)
		EndIf
	
		Reclock("CTBBX",.F.)
		CTBBX->DTCTB		:= dDataBase
		CTBBX->HRCTB		:= Left(Time(),5)
		CTBBX->USRCTB		:= Substr(cUsuario,7,15)
		MsUnlock()
	
		DbSelectarea("CTBBX")
		DbSkip()
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lancamento Contabil							  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCtb .and. nHdlPrv > 0
		RodaProva(nHdlPrv,nTotal)
		cA100Incl(cArquivo,nHdlPrv,3,cLoteAtf,.f.,.F.)
	Endif
	dDataBase := dBaseOri
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Log de erros da baixa   							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aErrosBX) > 0   
	cArqErro	:= "ERROBX_"+Dtos(dDataBase)+"_"+StrTran(Left(Time(),5),":","")+".TXT"
	nHdlArq 	:= fCreate(cDirImp+cArqErro)   
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	cLinha	:= "Arquivo         Fil Bem        Item  Recno SN1  Recno SN3 Ocorrencia"
				  //XXXXXXXXXXXXXXX 99  XXXXXXXXXX 9999 9999999999 9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	           //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	           //         1          2         3         4         5         6         7         8         9        10        11        12        13
	fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))

	ProcRegua(Len(aErrosBX))
	For nLoopArq := 1 to Len(aErrosBX)
		IncProc("Gerando arquivo de erros de baixas...")
		cLinha := Padr(aErrosBX[nLoopArq,1],15)+" "
		cLinha += Padr(aErrosBX[nLoopArq,2],2)+"  "
		cLinha += Padr(aErrosBX[nLoopArq,3],10)+" "
		cLinha += Padr(aErrosBX[nLoopArq,4],4)+" "
		cLinha += Padr(Alltrim(Str(aErrosBX[nLoopArq,5])),10)+" "
		cLinha += Padr(Alltrim(Str(aErrosBX[nLoopArq,6])),10)+" "
		cLinha += aErrosBX[nLoopArq,7]
		fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	Next nLoopArq
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	fClose(nHdlArq)
	COPY FILE (cDirImp+cArqErro) TO (cPath+cArqErro)
	ShellExecute( "Open", cArqErro,"",cPath, 1 )
	Aviso("Aviso","Ocorrências de erro de Baixas encontradas. Verifique o arquivo "+cArqErro+" gerado.",{"Continuar"},,"Atenção:",,"BMPPERG")
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Log de bens baixados    							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aMsgBX) > 0   
	cArqErro	:= "BAIXAS_"+Dtos(dDataBase)+"_"+StrTran(Left(Time(),5),":","")+".TXT"
	nHdlArq 	:= fCreate(cDirImp+cArqErro)   
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	cLinha	:= "Arquivo         Fil Bem        Item  Recno SN1  Recno SN3 Ocorrencia"
				  //XXXXXXXXXXXXXXX 99  XXXXXXXXXX 9999 9999999999 9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	           //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	           //         1          2         3         4         5         6         7         8         9        10        11        12        13
	fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))

	ProcRegua(Len(aMsgBX))
	For nLoopArq := 1 to Len(aMsgBX)
		IncProc("Gerando arquivo de baixas realizadas...")
		cLinha := Padr(aMsgBX[nLoopArq,1],15)+" "
		cLinha += Padr(aMsgBX[nLoopArq,2],2)+"  "
		cLinha += Padr(aMsgBX[nLoopArq,3],10)+" "
		cLinha += Padr(aMsgBX[nLoopArq,4],4)+" "
		cLinha += Padr(Alltrim(Str(aMsgBX[nLoopArq,5])),10)+" "
		cLinha += Padr(Alltrim(Str(aMsgBX[nLoopArq,6])),10)+" "
		cLinha += aMsgBX[nLoopArq,7]
		fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	Next nLoopArq
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	fClose(nHdlArq)
	COPY FILE (cDirImp+cArqErro) TO (cPath+cArqErro)
	ShellExecute( "Open", cArqErro,"",cPath, 1 )
	Aviso("Aviso","Baixas Realizadas. Verifique o arquivo "+cArqErro+" gerado.",{"Continuar"},,"Atenção:",,"BMPPERG")
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Log de erros da inclusao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aErrosInc) > 0   
	cArqErro	:= "ERROINC_"+Dtos(dDataBase)+"_"+StrTran(Left(Time(),5),":","")+".TXT"
	nHdlArq 	:= fCreate(cDirImp+cArqErro)   
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	cLinha	:= "Arquivo         Fil Bem        Item  Recno SN1  Recno SN3 Ocorrencia"
				  //XXXXXXXXXXXXXXX 99  XXXXXXXXXX 9999 9999999999 9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	           //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	           //         1          2         3         4         5         6         7         8         9        10        11        12        13
	fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))

	ProcRegua(Len(aErrosInc))
	For nLoopArq := 1 to Len(aErrosInc)
		IncProc("Gerando arquivo de erros de baixas...")
		cLinha := Padr(aErrosInc[nLoopArq,1],15)+" "
		cLinha += Padr(aErrosInc[nLoopArq,2],2)+"  "
		cLinha += Padr(aErrosInc[nLoopArq,3],10)+" "
		cLinha += Padr(aErrosInc[nLoopArq,4],4)+" "
		cLinha += Padr(Alltrim(Str(aErrosInc[nLoopArq,5])),10)+" "
		cLinha += Padr(Alltrim(Str(aErrosInc[nLoopArq,6])),10)+" "
		cLinha += aErrosInc[nLoopArq,7]
		fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	Next nLoopArq
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	fClose(nHdlArq)
	COPY FILE (cDirImp+cArqErro) TO (cPath+cArqErro)
	ShellExecute( "Open", cArqErro,"",cPath, 1 )
	Aviso("Aviso","Ocorrências de erro de inclusao encontradas. Verifique o arquivo "+cArqErro+" gerado.",{"Continuar"},,"Atenção:",,"BMPPERG")
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Log de bens incluidos com sucesso				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aMsgInc) > 0   
	cArqErro	:= "INCLUSOES_"+Dtos(dDataBase)+"_"+StrTran(Left(Time(),5),":","")+".TXT"
	nHdlArq 	:= fCreate(cDirImp+cArqErro)   
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	cLinha	:= "Arquivo         Fil Bem        Item  Recno SN1  Recno SN3 Ocorrencia"
				  //XXXXXXXXXXXXXXX 99  XXXXXXXXXX 9999 9999999999 9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	           //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	           //         1          2         3         4         5         6         7         8         9        10        11        12        13
	fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))

	ProcRegua(Len(aMsgInc))
	For nLoopArq := 1 to Len(aMsgInc)
		IncProc("Gerando arquivo de baixas realizadas...")
		cLinha := Padr(aMsgInc[nLoopArq,1],15)+" "
		cLinha += Padr(aMsgInc[nLoopArq,2],2)+"  "
		cLinha += Padr(aMsgInc[nLoopArq,3],10)+" "
		cLinha += Padr(aMsgInc[nLoopArq,4],4)+" "
		cLinha += Padr(Alltrim(Str(aMsgInc[nLoopArq,5])),10)+" "
		cLinha += Padr(Alltrim(Str(aMsgInc[nLoopArq,6])),10)+" "
		cLinha += aMsgInc[nLoopArq,7]
		fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	Next nLoopArq
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	fClose(nHdlArq)
	COPY FILE (cDirImp+cArqErro) TO (cPath+cArqErro)
	ShellExecute( "Open", cArqErro,"",cPath, 1 )
	Aviso("Aviso","Inclusoes Realizadas. Verifique o arquivo "+cArqErro+" gerado.",{"Continuar"},,"Atenção:",,"BMPPERG")
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Log de erros de transferencia					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aErrosTrf) > 0   
	cArqErro	:= "ERROTRF_"+Dtos(dDataBase)+"_"+StrTran(Left(Time(),5),":","")+".TXT"
	nHdlArq 	:= fCreate(cDirImp+cArqErro)   
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	cLinha	:= "Arquivo         Fil Bem        Item  Recno SN1  Recno SN3 Ocorrencia"
				  //XXXXXXXXXXXXXXX 99  XXXXXXXXXX 9999 9999999999 9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	           //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	           //         1          2         3         4         5         6         7         8         9        10        11        12        13
	fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))

	ProcRegua(Len(aErrosTrf))
	For nLoopArq := 1 to Len(aErrosTrf)
		IncProc("Gerando arquivo de erros de transferencias...")
		cLinha := Padr(aErrosTrf[nLoopArq,1],15)+" "
		cLinha += Padr(aErrosTrf[nLoopArq,2],2)+"  "
		cLinha += Padr(aErrosTrf[nLoopArq,3],10)+" "
		cLinha += Padr(aErrosTrf[nLoopArq,4],4)+" "
		cLinha += Padr(Alltrim(Str(aErrosTrf[nLoopArq,5])),10)+" "
		cLinha += Padr(Alltrim(Str(aErrosTrf[nLoopArq,6])),10)+" "
		cLinha += aErrosTrf[nLoopArq,7]
		fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))

		fWrite(nHdlArq,"          ====================================================================================="+Chr(13)+Chr(10))
		cLinha	:= "          Variavel                   Origem               Destino"
					  //          XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX
		           //          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		           //                    1          2         3         4         5         6         7         8         9        10        11        12        13
		fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
		fWrite(nHdlArq,"          ====================================================================================="+Chr(13)+Chr(10))
		For nLoopVar := 1 to Len(aErrosTrf[nLoopArq,8])
			If aErrosTrf[nLoopArq,8,nLoopVar,2] <> aErrosTrf[nLoopArq,8,nLoopVar,3]
				cLinha := Space(10)+Padr(aErrosTrf[nLoopArq,8,nLoopVar,1],25)+"  "
				cLinha += Padr(aErrosTrf[nLoopArq,8,nLoopVar,2],20)+" "
				cLinha += Padr(aErrosTrf[nLoopArq,8,nLoopVar,3],20)
				fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
			Endif
		Next nLoopVar
		fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	Next nLoopArq
	fClose(nHdlArq)
	COPY FILE (cDirImp+cArqErro) TO (cPath+cArqErro)
	ShellExecute( "Open", cArqErro,"",cPath, 1 )
	Aviso("Aviso","Ocorrências de erro de transferencias encontradas. Verifique o arquivo "+cArqErro+" gerado.",{"Continuar"},,"Atenção:",,"BMPPERG")
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Log de transferencias realizadas				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aMsgTrf) > 0   
	cArqErro	:= "TRANSF_"+Dtos(dDataBase)+"_"+StrTran(Left(Time(),5),":","")+".TXT"
	nHdlArq 	:= fCreate(cDirImp+cArqErro)   
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	cLinha	:= "Arquivo         Fil Bem        Item  Recno SN1  Recno SN3 Ocorrencia"
				  //XXXXXXXXXXXXXXX 99  XXXXXXXXXX 9999 9999999999 9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	           //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	           //         1          2         3         4         5         6         7         8         9        10        11        12        13
	fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
	fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))

	ProcRegua(Len(aMsgTrf))
	For nLoopArq := 1 to Len(aMsgTrf)
		IncProc("Gerando arquivo de transferencias...")
		cLinha := Padr(aMsgTrf[nLoopArq,1],15)+" "
		cLinha += Padr(aMsgTrf[nLoopArq,2],2)+"  "
		cLinha += Padr(aMsgTrf[nLoopArq,3],10)+" "
		cLinha += Padr(aMsgTrf[nLoopArq,4],4)+" "
		cLinha += Padr(Alltrim(Str(aMsgTrf[nLoopArq,5])),10)+" "
		cLinha += Padr(Alltrim(Str(aMsgTrf[nLoopArq,6])),10)+" "
		cLinha += aMsgTrf[nLoopArq,7]
		fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))

		fWrite(nHdlArq,"          ====================================================================================="+Chr(13)+Chr(10))
		cLinha	:= "          Variavel                   Origem               Destino"
					  //          XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX
		           //          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		           //                    1          2         3         4         5         6         7         8         9        10        11        12        13
		fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
		fWrite(nHdlArq,"          ====================================================================================="+Chr(13)+Chr(10))
		For nLoopVar := 1 to Len(aMsgTrf[nLoopArq,8])   
			If aMsgTrf[nLoopArq,8,nLoopVar,2] <> aMsgTrf[nLoopArq,8,nLoopVar,3]
				cLinha := Space(10)+Padr(aMsgTrf[nLoopArq,8,nLoopVar,1],25)+"  "
				cLinha += Padr(aMsgTrf[nLoopArq,8,nLoopVar,2],20)+" "
				cLinha += Padr(aMsgTrf[nLoopArq,8,nLoopVar,3],20)
				fWrite(nHdlArq,cLinha+Chr(13)+Chr(10))
			Endif
		Next nLoopVar
		fWrite(nHdlArq,"======================================================================================================================================================================================================="+Chr(13)+Chr(10))
	Next nLoopArq
	fClose(nHdlArq)
	COPY FILE (cDirImp+cArqErro) TO (cPath+cArqErro)
	ShellExecute( "Open", cArqErro,"",cPath, 1 )
	Aviso("Aviso","Transferencias Realizadas. Verifique o arquivo "+cArqErro+" gerado.",{"Continuar"},,"Atenção:",,"BMPPERG")
Endif	


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RATFM01BX ³ Autor ³ Marcos Eduardo Rocha   ³ Data ³ 01/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza a baixa do ativo fixo                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RATFM01BX(cArquivo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCab				:= {}
Local dDtBx				:= MV_PAR06
Local aParams			:= {MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10,MV_PAR11}
Local nLooPar			:= 0
Local aPosSM0			:= {cEmpAnt,cFilAnt,SM0->(GetArea())}
Local aRegs				:= {0,0}
Local nQtdOper			:= 0
Private nTotal 		:= 0
Private nHdlPrv		:= 0
Private cPadrao		:= ""
Private lMSErroAuto	:= .F.
Private lMSHelpAuto	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa o arquivo para baixar o ativo                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SN1IMP")
aRegs[2] := RecCount()
ProcRegua(0)
DbGoTop()           
While !EOF() 
	If nQtdOper >= MV_PAR08
		Exit
	Endif
	
	aRegs[1]++
   IncProc("Processando reg "+Alltrim(Str(aRegs[1]))+"/"+Alltrim(Str(aRegs[2]))+" - "+Alltrim(cArquivo)+" de baixa...")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no SN1                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea("SN1")
	DbSetOrder(1)
	If !DbSeek(SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM,.f.)
		Aadd(aErrosBX,{	cArquivo,;
							SN1IMP->N1_FILIAL,;
							SN1IMP->N1_CBASE,;       
							SN1IMP->N1_ITEM,;
							SN1IMP->(Recno()),;
							0,;
							"Bem nao localizado no arquivo SN1 do sistema"})
		DbSelectArea("SN1IMP")
		DbSkip()
		Loop
	Endif                                       
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no SN3IMP                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SN3IMP")
	If !DbSeek(SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM,.f.)
		Aadd(aErrosBX,{	cArquivo,;
							SN1IMP->N1_FILIAL,;
							SN1IMP->N1_CBASE,;       
							SN1IMP->N1_ITEM,;
							SN1IMP->(Recno()),;
							0,;
							"Bem nao localizado no arquivo SN3 de importacao"})
		DbSelectArea("SN1IMP")
		DbSkip()
		Loop
	Endif                                       
	While !EOF() .and. SN3IMP->(N3_FILIAL+N3_CBASE+N3_ITEM) == SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona no SN3                                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbselectArea("SN3")
		DbSetOrder(1)
		If !DbSeek(SN3IMP->N3_FILIAL+SN3IMP->N3_CBASE+SN3IMP->N3_ITEM+SN3IMP->N3_TIPO,.f.)
			Aadd(aErrosBX,{	cArquivo,;
								SN1IMP->N1_FILIAL,;
								SN1IMP->N1_CBASE,;       
								SN1IMP->N1_ITEM,;
								SN1IMP->(Recno()),;
								SN3IMP->(Recno()),;
								"Bem nao localizado no arquivo SN3 do sistema (Chave "+SN3IMP->N3_FILIAL+SN3IMP->N3_CBASE+SN3IMP->N3_ITEM+SN3IMP->N3_TIPO+")"})
			DbSelectArea("SN3IMP")
			DbSkip()
			Loop
		Endif                                       
		IF Val( SN3->N3_BAIXA ) # 0 
			Aadd(aErrosBX,{	cArquivo,;
								SN1IMP->N1_FILIAL,;
								SN1IMP->N1_CBASE,;       
								SN1IMP->N1_ITEM,;
								SN1IMP->(Recno()),;
								SN3IMP->(Recno()),;
								"Bem já baixado"})
			DbSelectArea("SN3IMP")
			DbSkip()
			Loop
		Endif                                       

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o cabecalho da baixa                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCab := {}
		Aadd(aCab,{	"N3_FILIAL",		SN3->N3_FILIAL,		Nil})
		Aadd(aCab,{	"N3_CBASE",			SN3->N3_CBASE,			Nil})
		Aadd(aCab,{	"N3_ITEM"	,		SN3->N3_ITEM,			Nil})
		Aadd(aCab,{	"AUTQUANT",			IIF(SN1->N1_QUANTD == 0,1,SN1->N1_QUANTD),		Nil})
		Aadd(aCab,{	"AUTDTBX",			dDtBx, 					Nil})
		Aadd(aCab,{	"AUTMOTBX",			"08",	  					Nil})
		Aadd(aCab,{	"AUTPERCBX",		100,						Nil})
		Aadd(aCab,{	"AUTNOTA",			"      ",				Nil})
		Aadd(aCab,{	"AUTSERIE",			"   ",					Nil})
		Aadd(aCab,{	"AUTBXFILHOS",		.F.,						Nil})
		Aadd(aCab,{	"RECNO",				SN3->(Recno()),		Nil})
		//Aadd(aCab,{	"AUTVLRVENDA",		0,				Nil})

		mv_par01 	:= 3						
		DbSelectArea("SX1")
		DbSetOrder(1)
		If SX1->(DbSeek("AFA03001"))
			RecLock("SX1",.F.)
			SX1->X1_PRESEL := 3
			MsUnlock()		
		Endif
		lMSErroAuto	:= .F.
		lMSHelpAuto	:= .T.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona o SM0                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SM0")
		DbSeek(cEmpAnt+SN1IMP->N1_FILIAL,.F.)
		cFilAnt := SN1IMP->N1_FILIAL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama a rotina automática                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MSExecAuto({|x,y,z| ATFA030(x,y)},aCab,4)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Reposiciona o ambiente                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lMSHelpAuto	:= .F.
		cEmpAnt	:= aPosSM0[1]
		cFilAnt	:= aPosSM0[2]
		RestArea(aPosSM0[3])

		If lMSErroAuto
			Aadd(aErrosBX,{	cArquivo,;
									SN1IMP->N1_FILIAL,;
									SN1IMP->N1_CBASE,;       
									SN1IMP->N1_ITEM,;
									SN1IMP->(Recno()),;
									0,;
									"Erro na rotina automatica na baixa do bem. Veja o arquivo "+NomeAutoLog()})
		Else
			Aadd(aMsgBX,{		cArquivo,;
									SN1IMP->N1_FILIAL,;
									SN1IMP->N1_CBASE,;       
									SN1IMP->N1_ITEM,;
									SN1IMP->(Recno()),;
									SN3IMP->(Recno()),;
									"Bem Baixado com Sucesso"})
			nQtdOper++
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica qual o lancamento padronizado que devera ser utilizado			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SN3")
			If Alltrim(cArquivo) == "BC"
				cPadrao := "910"
			ElseIf SN3->N3_TIPO == "01"    // Aquisi‡„o
				cPadrao := "810"
			ElseIf SN3->N3_TIPO $ "02,05"    // Reavalia‡„o
				cPadrao := "811"
			ElseIf SN3->N3_TIPO == "03"      // Adiantamento
				cPadrao := "812"
			ElseIf SN3->N3_TIPO == "04"      // Lei 8200 (Dif. BTN/IPC)
				cPadrao := "813"
			EndIf

			RecLock("CTBBX",.T.)
			CTBBX->RECSN1		:= SN1->(Recno())
			CTBBX->RECSN3		:= SN3->(Recno())
			CTBBX->NCPADRAO		:= cPadrao
			MsUnlock()
			/*
			Aadd(aContabBX,{	SN1->(Recno()),;			
							  		SN3->(Recno()),;			
									cPadrao})
			*/
		Endif
				
		DbSelectArea("SN3IMP")
		DbSkip()
	Enddo
	
	DbSelectArea("SN1IMP")
	DbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura os parametros                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoopPar := 1 to Len(aParams)
	&("MV_PAR"+StrZero(nLoopPar,2)) := aParams[nLoopPar]
Next nLoopPar
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RATFM01Imp³ Autor ³ Marcos Eduardo Rocha   ³ Data ³ 01/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importa Arquivos de Ativo Fixo                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RATFM01Imp(cArquivo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cIndSN1 			:= ""
Local cKey    			:= ""
Local nIndSN1 			:= ""
Local aMeses			:= {}
Local nLoopDia			:= 0
Local aParams			:= {MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10,MV_PAR11}
Local nLooPar			:= 0
Local aPosSM0			:= {cEmpAnt,cFilAnt,SM0->(GetArea())}
Local cQuery			:= ""
Local aRegs				:= {0,0}
Local nContInc			:= 0
Local nQtdOper			:= 0
Private lMSErroAuto	:= .F.
Private lMSHelpAuto	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice do SN1 sem filial. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SN1")
cIndSN1 := Criatrab(Nil,.F.)
cKey    := 'N1_FILIAL+N1_CBASE+N1_ITEM+N1_CHAPA'
IndRegua("SN1",cIndSN1,cKey,,," Criando Indice SN1...")
nIndSN1 := RetIndex("SN1")+1
DbSetOrder(nIndSN1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa os registros para inclusao do bem                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SN1IMP")
aRegs[2] := RecCount()
ProcRegua(0)
dbGotop()
While !Eof()        
	If nQtdOper >= MV_PAR08
		Exit
	Endif

	aRegs[1]++
   IncProc("Processando reg "+Alltrim(Str(aRegs[1]))+"/"+Alltrim(Str(aRegs[2]))+" - "+Alltrim(cArquivo)+" de inclusao...")

	DbSelectArea("SN1")  //  Usar Indice sem Filial
	DbSetOrder(nIndSN1)
	If DbSeek(SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM,.f.)
		Aadd(aErrosInc,{	cArquivo,;
								SN1IMP->N1_FILIAL,;
								SN1IMP->N1_CBASE,;       
								SN1IMP->N1_ITEM,;
								SN1IMP->(Recno()),;
								0,;
								"Bem "+SN1IMP->N1_CBASE+" ja existente na filial."})
		DbSelectArea("SN1IMP")
		DbSkip()
		Loop
	Endif                                       
    
    If !Empty(SN1IMP->N1_NURESPO)
    	DbSelectArea("SZ7")  //  Usar Indice sem Filial
		DbSetOrder(2)
		If !DbSeek(xFilial("SZ7")+SN1IMP->N1_NURESPO,.f.)
			Aadd(aErrosInc,{	cArquivo,;
									SN1IMP->N1_FILIAL,;
									SN1IMP->N1_CBASE,;       
									SN1IMP->N1_ITEM,;
									SN1IMP->(Recno()),;
									0,;
									"Nucleo responsavel "+SN1IMP->N1_NURESPO+" nao localizado no cadastro."})
			DbSelectArea("SN1IMP")
			DbSkip()
			Loop
		Endif                                       
     EndIf
     
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida se a plaqueta existe             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lEncChapa := .F.                             
	If !Empty(SN1IMP->N1_CHAPA)
		cQuery	:= " SELECT COUNT(*) AS TOTREGS"
		cQuery	+= " FROM SN1050 SN1 (NOLOCK)
		cQuery	+= " WHERE N1_FILIAL = '"+SN1IMP->N1_FILIAL+"' AND N1_CHAPA = '"+SN1IMP->N1_CHAPA+"' AND N1_CBASE = '"+SN1IMP->N1_CBASE+"' AND N1_ITEM = '"+SN1IMP->N1_ITEM+"'"
		//cQuery	+= " WHERE N1_CHAPA = '"+SN1IMP->N1_CHAPA+"'"
		cQuery	+= " AND D_E_L_E_T_ <> '*'"
		If Select("SN1TMP") > 0
			DbSelectArea("SN1TMP")
			DbCloseArea()
		Endif
		TcQuery cQuery New Alias "SN1TMP"
		DbSelectArea("SN1TMP")
		DbGoTop()
		If !EOF()
			If SN1TMP->TOTREGS > 0
				lEncChapa := .T.
			Endif
		Endif
		If Select("SN1TMP") > 0
			DbSelectArea("SN1TMP")
			DbCloseArea()
		Endif
		If lEncChapa
			Aadd(aErrosInc,{	cArquivo,;
									SN1IMP->N1_FILIAL,;
									SN1IMP->N1_CBASE,;       
									SN1IMP->N1_ITEM,;
									SN1IMP->(Recno()),;
									0,;
									"Chapa "+SN1IMP->N1_CHAPA+" ja existente."})
			DbSelectArea("SN1IMP")
			DbSkip()
			Loop
		Endif
	Endif
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	If Empty(SN1IMP->N1_FORNEC) .or. Empty(SN1IMP->N1_LOJA) .or. !DbSeek(xFilial("SA2")+SN1IMP->N1_FORNEC+SN1IMP->N1_LOJA,.f.)
			Aadd(aErrosInc,{	cArquivo,;
									SN1IMP->N1_FILIAL,;
									SN1IMP->N1_CBASE,;       
									SN1IMP->N1_ITEM,;
									SN1IMP->(Recno()),;
									0,;
									"Fornecedor "+SN1IMP->N1_FORNEC+", Loja "+SN1IMP->N1_LOJA+" nao informado ou nao localizado."})
		DbSelectArea("SN1IMP")
		DbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui Ativo. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCab   := {}
	aItens := {}
	M->N1_CBASE 	:= SN1IMP->N1_CBASE
	M->N1_ITEM 		:= SN1IMP->N1_ITEM
	
	Aadd(aCab,{"N1_FILIAL"  ,SN1IMP->N1_FILIAL	,Nil})
	Aadd(aCab,{"N1_CBASE"   ,SN1IMP->N1_CBASE   ,".t."})
	Aadd(aCab,{"N1_ITEM"    ,SN1IMP->N1_ITEM    ,".t."})
	Aadd(aCab,{"N1_AQUISIC" ,SN1IMP->N1_AQUISIC ,Nil})
	Aadd(aCab,{"N1_DESCRIC" ,SN1IMP->N1_DESCRIC ,Nil})
	Aadd(aCab,{"N1_QUANTD"  ,SN1IMP->N1_QUANTD  ,Nil})
	Aadd(aCab,{"N1_CHAPA"   ,SN1IMP->N1_CHAPA   ,".t."})
	If !Empty(SN1IMP->N1_GRUPO)
		Aadd(aCab,{"N1_GRUPO"   ,SN1IMP->N1_GRUPO   ,Nil})
	EndIf
	If !Empty(SN1IMP->N1_CSEGURO)
		Aadd(aCab,{"N1_CSEGURO"   ,SN1IMP->N1_CSEGURO ,Nil})
	EndIf
	If !Empty(SN1IMP->N1_APOLICE)
		Aadd(aCab,{"N1_APOLICE"   ,SN1IMP->N1_APOLICE  ,Nil})
	EndIf
	If !Empty(SN1IMP->N1_DTVENC)
		Aadd(aCab,{"N1_DTVENC"   ,SN1IMP->N1_DTVENC ,Nil})
	EndIf
	If !Empty(SN1IMP->N1_TIPOSEG)
		Aadd(aCab,{"N1_TIPOSEG"   ,SN1IMP->N1_TIPOSEG ,Nil})
	EndIf
	Aadd(aCab,{"N1_FORNEC"  ,SN1IMP->N1_FORNEC  ,Nil})
	Aadd(aCab,{"N1_LOJA"    ,SN1IMP->N1_LOJA    ,Nil})
	Aadd(aCab,{"N1_LOCAL"   ,SN1IMP->N1_LOCAL   ,Nil})
	Aadd(aCab,{"N1_NOMFORN" ,SN1IMP->N1_NOMFORN ,Nil})
	Aadd(aCab,{"N1_NSERIE"  ,SN1IMP->N1_NSERIE  ,Nil})
	Aadd(aCab,{"N1_NFISCAL" ,SN1IMP->N1_NFISCAL ,Nil})
	If !Empty(SN1IMP->N1_PROJETO)
		Aadd(aCab,{"N1_PROJETO" ,SN1IMP->N1_PROJETO ,Nil})
	EndIf
	If !Empty(SN1IMP->N1_CHASSIS)
		Aadd(aCab,{"N1_CHASSIS" ,SN1IMP->N1_CHASSIS ,Nil})
	EndIf
	If !Empty(SN1IMP->N1_PLACA)
		Aadd(aCab,{"N1_PLACA"   ,SN1IMP->N1_PLACA   ,".T."})
	EndIf
	//Aadd(aCab,{"N1_STATUS"  ,SN1IMP->N1_STATUS  ,Nil})  // ?? Ver
	Aadd(aCab,{"N1_PATRIM"  ,SN1IMP->N1_PATRIM  ,Nil})
	Aadd(aCab,{"N1_CODCIAP" ,SN1IMP->N1_CODCIAP ,Nil})
	Aadd(aCab,{"N1_CODCLI"  ,SN1IMP->N1_CODCLI  ,Nil})
	Aadd(aCab,{"N1_LOJA1"   ,SN1IMP->N1_LOJA1   ,Nil})
	Aadd(aCab,{"N1_DESCCLI" ,SN1IMP->N1_DESCCLI ,Nil})
	Aadd(aCab,{"N1_UNIDNEG" ,SN1IMP->N1_UNIDNEG ,".T."})
	Aadd(aCab,{"N1_DESCCLI" ,SN1IMP->N1_DESCCLI ,Nil})
	Aadd(aCab,{"N1_CODEPTO" ,SN1IMP->N1_CODEPTO ,".T."})
	Aadd(aCab,{"N1_DPARTO"  ,SN1IMP->N1_DPARTO  ,Nil})
	Aadd(aCab,{"N1_CONSAB"  ,SN1IMP->N1_CONSAB  ,Nil})
	Aadd(aCab,{"N1_PREDIO"  ,SN1IMP->N1_PREDIO  ,".T."})
	Aadd(aCab,{"N1_AREARIS" ,SN1IMP->N1_AREARIS ,".T."})
	Aadd(aCab,{"N1_CODBAR"  ,SN1IMP->N1_CODBAR  ,Nil})
	Aadd(aCab,{"N1_CODBEM"  ,SN1IMP->N1_CODBEM  ,Nil})
	Aadd(aCab,{"N1_NURESPO" ,SN1IMP->N1_NURESPO ,Nil})
	Aadd(aCab,{"N1_NOMERES" ,SN1IMP->N1_NOMERES ,Nil})
	Aadd(aCab,{"N1_DEPTO"   ,SN1IMP->N1_DEPTO  ,Nil})

	lErroSN3 := .F.
	DbSelectArea("SN3IMP")
	DbSeek(SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM)
	While !Eof() .And. SN3IMP->N3_FILIAL+SN3IMP->N3_CBASE+SN3IMP->N3_ITEM  == SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM
	   If SN3IMP->N3_BAIXA == "1"
			DbSelectArea("SN3IMP")
			DbSkip()
			Loop
		Endif                                       
		If Alltrim(cArquivo) == "NO" .and. !Alltrim(SN3IMP->N3_CSUTIPO) $ "F"
			DbSelectArea("SN3IMP")
			DbSkip()
			Loop
		Endif
		If Alltrim(cArquivo) == "AL" .and. !Alltrim(SN3IMP->N3_CSUTIPO) $ "C"
			DbSelectArea("SN3IMP")
			DbSkip()
			Loop
		Endif

		If !U_VldCTBg( SN3IMP->N3_SUBCTA, SN3IMP->N3_CCUSTO, SN3IMP->N3_CLVL,,,.f. )
			Aadd(aErrosInc,{	cArquivo,;
									SN1IMP->N1_FILIAL,;
									SN1IMP->N1_CBASE,;       
									SN1IMP->N1_ITEM,;
									SN1IMP->(Recno()),;
									SN3IMP->(Recno()),;
									"Erro na amarracao entre as entidades Unidade de Negocio x Centro de Custo x Operacao"})
			lErroSN3 := .T.				
		Endif		                                      
		
		If !Empty(SN3IMP->N3_CLVL)
			DbSelectArea("CTH")
			DbSetORder(1)
			If !DbSeek(xFilial("CTH")+SN3IMP->N3_CLVL,.F.)
				Aadd(aErrosInc,{	cArquivo,;
										SN1IMP->N1_FILIAL,;
										SN1IMP->N1_CBASE,;       
										SN1IMP->N1_ITEM,;
										SN1IMP->(Recno()),;
										SN3IMP->(Recno()),;
										"Classe de Valor "+SN3IMP->N3_CLVL+" não cadastrado"})
				
				lErroSN3 := .T.				
			Endif
		Endif
		If !Empty(SN3IMP->N3_SUBCTA)
			DbSelectArea("CTD")
			DbSetORder(1)
			If !DbSeek(xFilial("CTD")+SN3IMP->N3_SUBCTA,.F.)
				Aadd(aErrosInc,{	cArquivo,;
										SN1IMP->N1_FILIAL,;
										SN1IMP->N1_CBASE,;       
										SN1IMP->N1_ITEM,;
										SN1IMP->(Recno()),;
										SN3IMP->(Recno()),;
										"Item COntabil "+SN3IMP->N3_SUBCTA+" não cadastrado"})
				
				lErroSN3 := .T.				
			Endif
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valores do Bem                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nValor   	:= SN3IMP->N3_VORIG1
		nTxDepre 	:= SN3IMP->N3_TXDEPR1
		nVlrDepMes 	:= nValor / ((12 / nTxDepre) * 100)
		nVlrDepDia 	:= nVlrDepMes / 30
		dFimDepr		:= Ctod("")
		
		If SN3IMP->N3_DINDEPR > MV_PAR06			
			nDepBal   := 0
			nDepMes   := 0
			nDepAcum  := 0
		Else	
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula os valores da depreciacao acumulada ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aMeses 	:= {}   
			//dDataIni := LastDay(SN1IMP->N1_AQUISIC)+1   //SN3IMP->N3_DINDEPR  ??
			dDataIni := LastDay(SN3IMP->N3_DINDEPR)+1 
			dDataFim := FirstDay(MV_PAR06)-1
			
			For nLoopDia := dDataIni to dDataFim
				If aScan(aMeses, Left(Dtos(nLoopDia),6)) == 0
					Aadd(aMeses, Left(Dtos(nLoopDia),6))
				Endif
			Next nLoopDia                             
			//nDias    	:= (30 - Day(SN1IMP->N1_AQUISIC))+1
			nDias    	:= (30 - Day(SN3IMP->N3_DINDEPR))+1
			
			If Len(aMeses) >= ((12 / nTxDepre) * 100)
				nMeses 	:= ((12 / nTxDepre) * 100)
				For nLoopMes := 1 to Len(aMeses)
					If nLoopMes <= ((12 / nTxDepre) * 100)
						//dFimDepr := Stod(aMeses[nLoopMes]+StrZero(Day(SN1IMP->N1_AQUISIC),2))
						dFimDepr := Stod(aMeses[nLoopMes]+StrZero(Day(SN3IMP->N3_DINDEPR),2))
					Endif
				Next nLoopNes
			   nDepAcum 	:= SN3IMP->N3_VORIG1
			Else
				nMeses   	:= Len(aMeses)
		   	nDepAcum 	:= (nVlrDepMes * nMeses) + (nVlrDepDia * nDias)
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula os valores da depreciacao do balanco³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(dFimDepr) .or. dFimDepr <= Ctod("31/12/08")
				nDepBal	:= 0
			Else
				aMeses 	:= {}                 
				//If Year(SN1IMP->N1_AQUISIC) < Year(MV_PAR06)
				If Year(SN3IMP->N3_DINDEPR) < Year(MV_PAR06)
					dDataIni := Stod(StrZero(Year(MV_PAR06),4)+"0101")
				Else
					//dDataIni := SN1IMP->N1_AQUISIC
					dDataIni := SN3IMP->N3_DINDEPR
				Endif
					                          
				If dFimDepr <= FirstDay(MV_PAR06)-1
					dDataFim := dFimDepr
				Else
					dDataFim := FirstDay(MV_PAR06)-1
				Endif
				For nLoopDia := dDataIni to dDataFim
					If aScan(aMeses, Left(Dtos(nLoopDia),6)) == 0
						Aadd(aMeses, Left(Dtos(nLoopDia),6))
					Endif
				Next nLoopDia
				nDias    	:= (30 - Day(dDataIni))+1
				nMeses   	:= Len(aMeses)
			   nDepBal 		:= (nVlrDepMes * nMeses) + (nVlrDepDia * nDias)
			Endif
				   
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Determina a depreciacao do mes              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If dDataIni < Ctod("01/06/09")                          
				nDepMes  	:= nVlrDepMes
			Else
				//nDias    	:= (30 - Day(SN1IMP->N1_AQUISIC))+1
				nDias    	:= (30 - Day(SN3IMP->N3_DINDEPR))+1
			    nDepMes  	:= nVlrDepDia * nDias
			Endif
	    
		EndIf
		
		Aadd(aItens, {})
		Aadd(aItens[Len(aItens)], {"N3_CBASE" ,SN3IMP->N3_CBASE 	,NIL})
		Aadd(aItens[Len(aItens)], {"N3_ITEM"  ,SN3IMP->N3_ITEM   	,NIL})
		Aadd(aItens[Len(aItens)], {"N3_TIPO"  ,SN3IMP->N3_TIPO   	,NIL})
		Aadd(aItens[Len(aItens)], {"N3_SEQ"   ,"001"  				 	,NIL})
		If !Empty(SN3IMP->N3_BAIXA)
			Aadd(aItens[Len(aItens)], {"N3_BAIXA"  ,SN3IMP->N3_BAIXA  ,NIL})
		EndIf
		If !Empty(SN3IMP->N3_GRUPO)
			Aadd(aItens[Len(aItens)], {"N3_GRUPO"  ,SN3IMP->N3_GRUPO ,NIL})
		EndIf
		Aadd(aItens[Len(aItens)], {"N3_HISTOR"  ,SN3IMP->N3_HISTOR  ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_SUBCTA"  ,SN3IMP->N3_SUBCTA  ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_CLVL"    ,SN3IMP->N3_CLVL    ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_CCONTAB" ,SN3IMP->N3_CCONTAB ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_CUSTBEM" ,SN3IMP->N3_CUSTBEM ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_CDEPREC" ,SN3IMP->N3_CDEPREC ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_CCUSTO"  ,SN3IMP->N3_CCUSTO  ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_CCDEPR"  ,SN3IMP->N3_CCDEPR  ,NIL})

         // Colocar outros campo
		Aadd(aItens[Len(aItens)], {"N3_DINDEPR" ,SN3IMP->N3_DINDEPR ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_VORIG1"  ,SN3IMP->N3_VORIG1  ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_TXDEPR1" ,SN3IMP->N3_TXDEPR1 ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_TXDEPR2" ,SN3IMP->N3_TXDEPR2 ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_TXDEPR3" ,SN3IMP->N3_TXDEPR3 ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_TXDEPR4" ,SN3IMP->N3_TXDEPR4 ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_TXDEPR5" ,SN3IMP->N3_TXDEPR5 ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_VRDBAL1" ,nDepBal   ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_VRDMES1" ,nDepMes   ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_VRDACM1" ,nDepAcum  ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_AQUISIC" ,SN3IMP->N3_AQUISIC ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_FILORIG" ,SN3IMP->N3_FILORIG ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_LOCAL"   ,SN3IMP->N3_LOCAL ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_QUANTD" ,SN3IMP->N3_QUANTD ,NIL})
		Aadd(aItens[Len(aItens)], {"N3_CSUTIPO" ,SN3IMP->N3_CSUTIPO ,NIL})                                         
		If !Empty(dFimDepr)
			Aadd(aItens[Len(aItens)], {"N3_FIMDEPR" ,dFimDepr ,NIL})                                         
		Endif
		
		If SN3->( FieldPos("N3_CODCTR") ) > 0 .And. SN3IMP->( FieldPos("N3_CODCTR") ) > 0
			Aadd(aItens[Len(aItens)], {"N3_CODCTR"  ,SN3IMP->N3_CODCTR ,NIL})
		EndIf              

		DbSelectArea("SN3IMP")
		dbSkip()
	EndDo
	If lErroSN3
		DbSelectArea("SN1IMP")
		DbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o SM0                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SM0")
	DbSeek(cEmpAnt+SN1IMP->N1_FILIAL,.F.)
	cFilAnt := SN1IMP->N1_FILIAL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chama a rotina automática                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lMSErroAuto	:= .F.
	lMSHelpAuto	:= .T.
	mv_par01 	:= 2						
	mv_par02 	:= 1						
	mv_par03 	:= 2						
	DbSelectArea("SX1")
	DbSetOrder(1)
	If SX1->(DbSeek("AFA01001"))
		RecLock("SX1",.F.)
		SX1->X1_PRESEL := 2
		MsUnlock()		
	Endif
	If SX1->(DbSeek("AFA01002"))
		RecLock("SX1",.F.)
		SX1->X1_PRESEL := 1
		MsUnlock()		
	Endif
	If SX1->(DbSeek("AFA01003"))
		RecLock("SX1",.F.)
		SX1->X1_PRESEL := 2
		MsUnlock()		
	Endif
	If Len(aCab) == 0 .or. Len(aItens) == 0
		Aadd(aErrosInc,{	cArquivo,;
								SN1IMP->N1_FILIAL,;
								SN1IMP->N1_CBASE,;       
								SN1IMP->N1_ITEM,;
								SN1IMP->(Recno()),;
								0,;
								"Nao foram localizados os itens (SN3) do Bem"})
		DbSelectArea("SN1IMP")
		DbSkip()
		Loop
	Else
		MSExecAuto({|x,y,z| ATFA010(x,y,z)},aCab,aItens,3)
		ConfirmSX8()
		MsUnLockAll()
		FreeUsedCode()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Reposiciona o ambiente                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lMSHelpAuto	:= .F.
	cEmpAnt	:= aPosSM0[1]
	cFilAnt	:= aPosSM0[2]
	RestArea(aPosSM0[3])

	If lMSErroAuto
		Aadd(aErrosInc,{	cArquivo,;
								SN1IMP->N1_FILIAL,;
								SN1IMP->N1_CBASE,;       
								SN1IMP->N1_ITEM,;
								SN1IMP->(Recno()),;
								0,;
								"Erro na rotina automatica na inclusao do bem. Veja o arquivo "+NomeAutoLog()})
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inclui a descricao estendida do bem                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SN2IMP")
		DbSeek(SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM)
		While !Eof() .And. SN2IMP->N2_FILIAL+SN2IMP->N2_CBASE+SN2IMP->N2_ITEM  == SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM
      	RecLock("SN2",.T.)
			SN2->N2_FILIAL		:= SN2IMP->N2_FILIAL
			SN2->N2_CBASE		:= SN2IMP->N2_CBASE
			SN2->N2_ITEM		:= SN2IMP->N2_ITEM
			SN2->N2_SEQUENC	:= SN2IMP->N2_SEQUENC
			SN2->N2_HISTOR		:= SN2IMP->N2_HISTOR
			SN2->N2_TIPO		:= SN2IMP->N2_TIPO
			SN2->N2_SEQ      	:= SN2IMP->N2_SEQ
      	MsUnlock()
      	
			DbSelectArea("SN2IMP")
   		DbSkip()
   	Enddo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica qual o lancamento padronizado que devera ser utilizado			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SN1")       
		DbSetOrder(1)
		DbSeek(SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM,.f.)

		DbSelectArea("SN3")       
		DbSetOrder(1)
		DbSeek(SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM,.f.)
		While !EOF() .and. SN3->(N3_FILIAL+N3_CBASE+N3_ITEM) == SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM
			If Alltrim(cArquivo) == "NO" .and. !Alltrim(SN3->N3_CSUTIPO) $ "F"
				DbSelectArea("SN3")
				DbSkip()
				Loop
			Endif
			If Alltrim(cArquivo) == "AL" .and. !Alltrim(SN3->N3_CSUTIPO) $ "C"
				DbSelectArea("SN3")
				DbSkip()
				Loop
			Endif
			cPadrao := ""
			If SN3->N3_TIPO  $ "01"
				cPadrao := "801"
			ElseIf SN3->N3_TIPO  $ "02,05"
				cPadrao := "802"
			ElseIf SN3->N3_TIPO  $ "03"
				cPadrao := "803"
			Else
				cPadrao := "804"
			Endif
			
			RecLock("CTBINC",.T.)
			CTBINC->RECSN1		:= SN1->(Recno())
			CTBINC->RECSN3		:= SN3->(Recno())
			CTBINC->NCPADRAO	:= cPadrao
			MsUnlock()
			/*
			Aadd(aContabInc,{	SN1->(Recno()),;			
							  		SN3->(Recno()),;			
									cPadrao})
         */
			DbSelectArea("SN3")       
			DbSkip()
		Enddo
	   	
		Aadd(aMsgInc,{		cArquivo,;
								SN1IMP->N1_FILIAL,;
								SN1IMP->N1_CBASE,;       
								SN1IMP->N1_ITEM,;
								SN1IMP->(Recno()),;
								0,;
								"Bem Incluido com Sucesso"})
		nQtdOper++
	Endif
  	
	DbSelectArea("SN1IMP")
	DbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura os parametros                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoopPar := 1 to Len(aParams)
	&("MV_PAR"+StrZero(nLoopPar,2)) := aParams[nLoopPar]
Next nLoopPar

dbSelectArea("SN1")
RetIndex("SN1")
FErase(cIndSN1+OrdBagExt())
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RATFM01Trf³ Autor ³ Jaime Wikanski         ³ Data ³ 01/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza a transferencia do ativo fixo                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RATFM01Trf(cArquivo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cIndSN1 			:= ""
Local cKey    			:= ""
Local nIndSN1 			:= ""
Local aMeses			:= {}
Local nLoopDia			:= 0
Local aParams			:= {MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10,MV_PAR11}
Local nLooPar			:= 0
Local aPosSM0			:= {cEmpAnt,cFilAnt,SM0->(GetArea())}
Local cQuery			:= ""
Local ParFilDest		:= Nil
Local ParCCDest		:= Nil
Local ParEndDest		:= Nil
Local ParCtBemDest	:= Nil
Local ParCtCMDest		:= Nil
Local ParCtDspDest	:= Nil
Local ParCtDeprDest	:= Nil
Local ParCtCMDDest	:= Nil
Local ParCcBemDest	:= Nil
Local ParCcCMDest		:= Nil
Local ParCcDspDest	:= Nil
Local ParCcDeprDest	:= Nil
Local ParCcCMDDest	:= Nil
Local ParTxDepr		:= Nil
Local ParSUBCCON		:= Nil
Local ParSUBCCOR		:= Nil
Local ParSUBCDEP		:= Nil
Local ParSUBCCDE		:= Nil
Local ParSUBCDES		:= Nil
Local ParCLVLCON		:= Nil
Local ParCLVLCOR		:= Nil
Local ParCLVLDEP		:= Nil
Local ParCLVLCDE		:= Nil
Local ParCLVLDES		:= Nil
Local ParCLVL			:= Nil
Local ParSubCTA		:= Nil
Local aDadosTrf		:= {}
Local aRegs				:= {0,0}
Local nQtdOper			:= 0
Private lMSErroAuto	:= .F.
Private lMSHelpAuto	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice do SN1 sem filial. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SN1")
cIndSN1 := Criatrab(Nil,.F.)
cKey    := 'N1_FILIAL+N1_CBASE+N1_ITEM+N1_CHAPA'
IndRegua("SN1",cIndSN1,cKey,,," Criando Indice SN1...")
nIndSN1 := RetIndex("SN1")+1
DbSetOrder(nIndSN1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa os registros para inclusao do bem                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SN1IMP")
aRegs[2] := RecCount()
ProcRegua(0)
dbGotop()
While !Eof()
	If nQtdOper >= MV_PAR08
		Exit
	Endif

	aRegs[1]++
   IncProc("Processando reg "+Alltrim(Str(aRegs[1]))+"/"+Alltrim(Str(aRegs[2]))+" - "+Alltrim(cArquivo)+" de transferencia...")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localiza o registro no SN1                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SN1")  //  Usar Indice sem Filial
	DbSetOrder(nIndSN1)
	If !DbSeek(SN1IMP->N1_XFILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM+SN1IMP->N1_CHAPA)
		DbSelectArea("SN1IMP")
		DbSkip()
		Loop
	Endif                                       

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pesquisa no SN3                                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SN3IMP")
	DbSeek(SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM)
	While !Eof() .And. SN3IMP->N3_FILIAL+SN3IMP->N3_CBASE+SN3IMP->N3_ITEM  == SN1IMP->N1_FILIAL+SN1IMP->N1_CBASE+SN1IMP->N1_ITEM
	   If SN3IMP->N3_BAIXA == "1"
			DbSelectArea("SN3IMP")
			DbSkip()
			Loop
		Endif                                       

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Localiza o registro no SN3                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SN3")       
		DbSetOrder(1)
		If !DbSeek(SN1->N1_FILIAL+SN1->N1_CBASE+SN1->N1_ITEM+SN3IMP->N3_TIPO,.f.)
			DbSelectArea("SN3IMP")
			DbSkip()
			Loop
		Endif                                       
	   If SN3->N3_BAIXA == "1"
			DbSelectArea("SN3IMP")
			DbSkip()
			Loop
		Endif                                       
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa as variaveis                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ParDtTrans		:= MV_PAR06
		ParFilDest		:= Nil
		ParTxDepr		:= Nil
		ParCCDest		:= Nil
		ParEndDest		:= Nil
		ParCtBemDest	:= Nil
		ParCtCMDest		:= Nil
		ParCtDspDest	:= Nil
		ParCtDeprDest	:= Nil
		ParCtCMDDest	:= Nil
		ParCcBemDest	:= Nil
		ParCcCMDest		:= Nil
		ParCcDspDest	:= Nil
		ParCcDeprDest	:= Nil
		ParCcCMDDest	:= Nil
		ParSUBCCON		:= Nil
		ParSUBCCOR		:= Nil
		ParSUBCDEP		:= Nil
		ParSUBCCDE		:= Nil
		ParSUBCDES		:= Nil
		ParCLVLCON		:= Nil
		ParCLVLCOR		:= Nil
		ParCLVLDEP		:= Nil
		ParCLVLCDE		:= Nil
		ParCLVLDES		:= Nil
		ParCLVL			:= Nil
		ParSubCTA		:= Nil
		aDadosTrf		:= {}
							
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica o que deve transferir                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SN3->N3_CLVL <> SN3IMP->N3_CLVL .and. !Empty(SN3IMP->N3_CLVL)
			ParCLVL		:= SN3IMP->N3_CLVL
			Aadd(aDadosTrf,{	"Operacao", SN3->N3_CLVL, SN3IMP->N3_CLVL})
		Endif                                                                           
		If SN3->N3_SUBCTA <> SN3IMP->N3_SUBCTA .and. !Empty(SN3IMP->N3_SUBCTA)
			ParSubCTA		:= SN3IMP->N3_SUBCTA
			Aadd(aDadosTrf,{	"Un Negocio", SN3->N3_SUBCTA, SN3IMP->N3_SUBCTA})
		Endif                                                                           
		If SN3->N3_FILIAL <> SN3IMP->N3_FILIAL .and. !Empty(SN3IMP->N3_FILIAL)
			ParFilDest		:= SN3IMP->N3_FILIAL
			Aadd(aDadosTrf,{	"Filial", SN3->N3_FILIAL, SN3IMP->N3_FILIAL})
		Endif                                                                           
		If SN3->N3_CCUSTO <> SN3IMP->N3_CCUSTO .and. !Empty(SN3->N3_CCUSTO) .and. !Empty(SN3IMP->N3_CCUSTO)
			ParCCDest		:= SN3IMP->N3_CCUSTO
			Aadd(aDadosTrf,{	"C. Custo", SN3->N3_CCUSTO, SN3IMP->N3_CCUSTO})
		Endif
		If SN1->N1_LOCAL <> SN1IMP->N1_LOCAL .and. !Empty(SN1->N1_LOCAL) .and. !Empty(SN1IMP->N1_LOCAL)
			ParEndDest		:= SN1IMP->N1_LOCAL
			Aadd(aDadosTrf,{	"Endereco", SN1->N1_LOCAL, SN1IMP->N1_LOCAL})
		Endif
		If SN3->N3_TXDEPR1 <> SN3IMP->N3_TXDEPR1 .and. !Empty(SN3->N3_TXDEPR1) .and. !Empty(SN3IMP->N3_TXDEPR1)
			ParTxDepr		:= SN3IMP->N3_TXDEPR1
			Aadd(aDadosTrf,{	"Tx Deprec.", SN3->N3_TXDEPR1, SN3IMP->N3_TXDEPR1})
		Endif
		If SN3->N3_CCONTAB <> SN3IMP->N3_CCONTAB .and. !Empty(SN3->N3_CCONTAB) .and. !Empty(SN3IMP->N3_CCONTAB)
			ParCtBemDest		:= SN3IMP->N3_CCONTAB
			Aadd(aDadosTrf,{	"Cta Bem", SN3->N3_CCONTAB, SN3IMP->N3_CCONTAB})
		Endif
		If SN3->N3_CCORREC <> SN3IMP->N3_CCORREC .and. !Empty(SN3->N3_CCORREC) .and. !Empty(SN3IMP->N3_CCORREC)
			ParCtCMDest		:= SN3IMP->N3_CCORREC
			Aadd(aDadosTrf,{	"Cta CM", SN3->N3_CCORREC, SN3IMP->N3_CCORREC})
		Endif
		If SN3->N3_CDEPREC <> SN3IMP->N3_CDEPREC .and. !Empty(SN3->N3_CDEPREC) .and. !Empty(SN3IMP->N3_CDEPREC)
			ParCtDspDest		:= SN3IMP->N3_CDEPREC
			Aadd(aDadosTrf,{	"Cta Dsp Depr", SN3->N3_CDEPREC, SN3IMP->N3_CDEPREC})
		Endif
		If SN3->N3_CCDEPR <> SN3IMP->N3_CCDEPR .and. !Empty(SN3->N3_CCDEPR) .and. !Empty(SN3IMP->N3_CCDEPR)
			ParCtDeprDest		:= SN3IMP->N3_CCDEPR
			Aadd(aDadosTrf,{	"Cta Depr Acum", SN3->N3_CCDEPR, SN3IMP->N3_CCDEPR})
		Endif
		If SN3->N3_CDESP <> SN3IMP->N3_CDESP .and. !Empty(SN3->N3_CDESP) .and. !Empty(SN3IMP->N3_CDESP)
			ParCtCMDDest		:= SN3IMP->N3_CDESP
			Aadd(aDadosTrf,{	"Cta CM Depr", SN3->N3_CDESP, SN3IMP->N3_CDESP})
		Endif
		If SN3->N3_CUSTBEM <> SN3IMP->N3_CUSTBEM .and. !Empty(SN3->N3_CUSTBEM) .and. !Empty(SN3IMP->N3_CUSTBEM)
			ParCcBemDest		:= SN3IMP->N3_CUSTBEM
			Aadd(aDadosTrf,{	"CC Bem", SN3->N3_CUSTBEM, SN3IMP->N3_CUSTBEM})
		Endif
		If SN3->N3_CCCORR <> SN3IMP->N3_CCCORR .and. !Empty(SN3->N3_CCCORR) .and. !Empty(SN3IMP->N3_CCCORR)
			ParCcCMDest			:= SN3IMP->N3_CCCORR
			Aadd(aDadosTrf,{	"CC CM", SN3->N3_CCCORR, SN3IMP->N3_CCCORR})
		Endif
		If SN3->N3_CCDESP <> SN3IMP->N3_CCDESP .and. !Empty(SN3->N3_CCDESP) .and. !Empty(SN3IMP->N3_CCDESP)
			ParCcDspDest		:= SN3IMP->N3_CCDESP
			Aadd(aDadosTrf,{	"CC Dsp Depr", SN3->N3_CCDESP, SN3IMP->N3_CCDESP})
		Endif
		If SN3->N3_CCCDEP <> SN3IMP->N3_CCCDEP .and. !Empty(SN3->N3_CCCDEP) .and. !Empty(SN3IMP->N3_CCCDEP)
			ParCcDeprDest		:= SN3IMP->N3_CCCDEP
			Aadd(aDadosTrf,{	"CC Depr Acum", SN3->N3_CCCDEP, SN3IMP->N3_CCCDEP})
		Endif
		If SN3->N3_CCCDES <> SN3IMP->N3_CCCDES .and. !Empty(SN3->N3_CCCDES) .and. !Empty(SN3IMP->N3_CCCDES)
			ParCcCMDDest		:= SN3IMP->N3_CCCDES
			Aadd(aDadosTrf,{	"CC CM Depr", SN3->N3_CCCDES, SN3IMP->N3_CCCDES})
		Endif
		If SN3->N3_SUBCCON <> SN3IMP->N3_SUBCCON .and. !Empty(SN3->N3_SUBCCON) .and. !Empty(SN3IMP->N3_SUBCCON)
			ParSUBCCON		:= SN3IMP->N3_SUBCCON
			Aadd(aDadosTrf,{	"Item Bem", SN3->N3_SUBCCON, SN3IMP->N3_SUBCCON})
		Endif
		If SN3->N3_SUBCCOR <> SN3IMP->N3_SUBCCOR .and. !Empty(SN3->N3_SUBCCOR) .and. !Empty(SN3IMP->N3_SUBCCOR)
			ParSUBCCOR		:= SN3IMP->N3_SUBCCOR
			Aadd(aDadosTrf,{	"Item CM", SN3->N3_SUBCCOR, SN3IMP->N3_SUBCCOR})
		Endif
		If SN3->N3_SUBCDEP <> SN3IMP->N3_SUBCDEP .and. !Empty(SN3->N3_SUBCDEP) .and. !Empty(SN3IMP->N3_SUBCDEP)
			ParSUBCDEP		:= SN3IMP->N3_SUBCDEP
			Aadd(aDadosTrf,{	"Item Dsp Depr", SN3->N3_SUBCDEP, SN3IMP->N3_SUBCDEP})
		Endif
		If SN3->N3_SUBCCDE <> SN3IMP->N3_SUBCCDE .and. !Empty(SN3->N3_SUBCCDE) .and. !Empty(SN3IMP->N3_SUBCCDE)
			ParSUBCCDE		:= SN3IMP->N3_SUBCCDE
			Aadd(aDadosTrf,{	"Item Depr Acum", SN3->N3_SUBCCDE, SN3IMP->N3_SUBCCDE})
		Endif
		If SN3->N3_SUBCDES <> SN3IMP->N3_SUBCDES .and. !Empty(SN3->N3_SUBCDES) .and. !Empty(SN3IMP->N3_SUBCDES)
			ParSUBCDES		:= SN3IMP->N3_SUBCDES
			Aadd(aDadosTrf,{	"Item CM Depr", SN3->N3_SUBCDES, SN3IMP->N3_SUBCDES})
		Endif
		If SN3->N3_CLVLCON <> SN3IMP->N3_CLVLCON .and. !Empty(SN3->N3_CLVLCON) .and. !Empty(SN3IMP->N3_CLVLCON)
			ParCLVLCON		:= SN3IMP->N3_CLVLCON
			Aadd(aDadosTrf,{	"CLVL Bem", SN3->N3_CLVLCON, SN3IMP->N3_CLVLCON})
		Endif
		If SN3->N3_CLVLCOR <> SN3IMP->N3_CLVLCOR .and. !Empty(SN3->N3_CLVLCOR) .and. !Empty(SN3IMP->N3_CLVLCOR)
			ParCLVLCOR		:= SN3IMP->N3_CLVLCOR
			Aadd(aDadosTrf,{	"CLVL CM", SN3->N3_CLVLCOR, SN3IMP->N3_CLVLCOR})
		Endif
		If SN3->N3_CLVLDEP <> SN3IMP->N3_CLVLDEP .and. !Empty(SN3->N3_CLVLDEP) .and. !Empty(SN3IMP->N3_CLVLDEP)
			ParCLVLDEP		:= SN3IMP->N3_CLVLDEP
			Aadd(aDadosTrf,{	"CLVL Dsp Depr", SN3->N3_CLVLDEP, SN3IMP->N3_CLVLDEP})
		Endif
		If SN3->N3_CLVLCDE <> SN3IMP->N3_CLVLCDE .and. !Empty(SN3->N3_CLVLCDE) .and. !Empty(SN3IMP->N3_CLVLCDE)
			ParCLVLCDE		:= SN3IMP->N3_CLVLCDE
			Aadd(aDadosTrf,{	"CLVL Depr Acum", SN3->N3_CLVLCDE, SN3IMP->N3_CLVLCDE})
		Endif
		If SN3->N3_CLVLDES <> SN3IMP->N3_CLVLDES .and. !Empty(SN3->N3_CLVLDES) .and. !Empty(SN3IMP->N3_CLVLDES)
			ParCLVLDES		:= SN3IMP->N3_CLVLDES
			Aadd(aDadosTrf,{	"CLVL CM Depr", SN3->N3_CLVLDES, SN3IMP->N3_CLVLDES})
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa a transferencia se ocorreu mudancas                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ParFilDest <> Nil .or. ParCCDest <> Nil .or. ParEndDest <> Nil .or. ParTxDepr <> Nil .or. ParCtBemDest <> Nil .or. ParCtCMDest <> Nil .or. ParCtDspDest	 <> Nil .or. ParCtDeprDest	 <> Nil .or. ParCtCMDDest <> Nil .or. ParCcBemDest <> Nil .or. ParCcCMDest <> Nil .or. ParCcDspDest <> Nil .or. ParCcDeprDest <> Nil .or. ParCcCMDDest <> Nil .or.;
			ParSUBCCON <> Nil .or. ParSUBCCOR <> Nil .or. ParSUBCDEP <> Nil .or. ParSUBCCDE <> Nil .or. ParSUBCDES <> Nil .or.;
			ParCLVLCON <> Nil .or. ParCLVLCOR <> Nil .or. ParCLVLDEP <> Nil .or. ParCLVLCDE <> Nil .or. ParCLVLDES <> Nil .or. ParCLVL <> Nil .or. ParSubCTA <> Nil
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona o SM0                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SM0")
			DbSeek(cEmpAnt+SN1->N1_FILIAL,.F.)
			cFilAnt := SN1->N1_FILIAL

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chama a funcao de transferencia                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If U_AF060Esp(	"SN3",SN3->(Recno()),3,,ParDtTrans,ParTxDepr,ParFilDest,ParCCDest,ParEndDest,ParCtBemDest,ParCtCMDest,ParCtDspDest,ParCtDeprDest,ParCtCMDDest,ParCcBemDest,ParCcCMDest,ParCcDspDest,ParCcDeprDest,ParCcCMDDest,;
								ParSUBCCON,ParSUBCCOR,ParSUBCDEP,ParSUBCCDE,ParSUBCDES,ParCLVLCON,ParCLVLCOR,ParCLVLDEP,ParCLVLCDE,ParCLVLDES,ParCLVL,ParSubCTA)
				Aadd(aMsgTrf,{		cArquivo,;
										SN1IMP->N1_FILIAL,;
										SN1IMP->N1_CBASE,;       
										SN1IMP->N1_ITEM,;
										SN1IMP->(Recno()),;
										0,;
										"Transferencia do Bem realizada com Sucesso",;
						  				aDadosTrf})
				nQtdOper++		
			Else
				Aadd(aErrosTrf,{	cArquivo,;
										SN1IMP->N1_FILIAL,;
										SN1IMP->N1_CBASE,;       
										SN1IMP->N1_ITEM,;
										SN1IMP->(Recno()),;
										0,;
										"Erro na rotina automatica na transferencia do bem (1).",;
										aDadosTrf})
         Endif
         
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Reposiciona o ambiente                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cEmpAnt	:= aPosSM0[1]
			cFilAnt	:= aPosSM0[2]
			RestArea(aPosSM0[3])
		Endif
				
		DbSelectArea("SN3IMP")
		DbSkip()
	Enddo

	DbSelectArea("SN1IMP")
	DbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura os parametros                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoopPar := 1 to Len(aParams)
	&("MV_PAR"+StrZero(nLoopPar,2)) := aParams[nLoopPar]
Next nLoopPar

dbSelectArea("SN1")
RetIndex("SN1")
FErase(cIndSN1+OrdBagExt())
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
±±º             ³          ³ parâmetros fornecidos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 23.05.05 ³ Modelagem de Dados                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 28.04.04 ³ TI0607 - Almir Bandina                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpA1 = array com o conteúdo do grupo de perguntas (SX1)                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)


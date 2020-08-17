#INCLUDE "PROTHEUS.CH"

User Function ACB0010()
Local cQuery
Local aAreaAnt := GetArea()
Local aStru := {}
Local cTrab := "" 
Local cProxNum := ""
Local nHdl := 0
Local lOk := .F. 
Local lEnd  := .F.

lOk := copiaArq()

If lOk
	Processa( {|lEnd| pegaId(@lEnd)}, "Aguarde...","Gerando o Arquivo.", .T. )
	lOk2 := TrazArq()
	if !lOk2
		ApmsgAlert("Falha na copia do arquivo para o computador Local...")
	Else
		ApmsgAlert("Processo concluido com sucesso...")
	Endif
Else
	ApMsgAlert("Não foi possivel processar falha durante a copia do arquivo Original...")
Endif 


RestArea(aAreaAnt)
Return nil


Static Function PegaId(lEnd)
Local cTrab := "DUPLIC"
Local cIndTemp := CriaTrab(,.f.)
Local nIndSRA := 0
Local aStru := {}

dbSelectArea("SRA")
dbSetOrder(1)

dbUseArea( .T. , 'DBFCDX' , cTrab, 'TEMP1' , .T. , .F. )
ProcRegua(TEMP1->(RecCount()))

DbSelectArea("TEMP1")
dbGotop()
aStru := dbStruct()

While !eof()
	IncProc("Processando...")
	dbSelectArea("SRA")
    if dbSeek(TEMP1->(RA_FILIAL+padl(alltrim(RA_MAT),6,"0")))
		dbSelectArea("TEMP1")
		RecLock("TEMP1", .F.)
		TEMP1->RA_MAT := padl(alltrim(TEMP1->RA_MAT),6,"0")
		TEMP1->NOVOID := SRA->RA_MEDMAT
		TEMP1->numreg := sra->(recno())
		MsUnlock()
	Else
		dbSelectArea("TEMP1")
		RecLock("TEMP1", .F.)
		TEMP1->RA_MAT := padl(alltrim(TEMP1->RA_MAT),6,"0")
		TEMP1->NOVOID := space(14)
		TEMP1->numreg := 0
		MsUnlock()
	Endif
	DbSelectArea("TEMP1")
	dbSkip()
End

dbSelectArea("TEMP1")
ProcRegua(TEMP1->(RecCount()))

dbGotop()

nHdl := AbreHTML()
PutHtml({"Filial","Matricula","Nome","ID Unico","Registro","Novo ID"}, 1, 1, nHdl)

dbSelectArea("TEMP1")
While !eof()
	IncProc("Gerando Excel...")

	PutHtml({Temp1->RA_FILIAL,TEMP1->RA_MAT,TEMP1->RA_NOME,TEMP1->RA_MEDMAT,StrZero(TEMP1->NUMREG,10),TEMP1->NOVOID}, 2, 0, nHdl)

	dbSelectArea("TEMP1")
	dbSkip()   
End

PutHtml({" "," "," "," "," "," "}, 3, 0, nHdl)
FecHtml(nHdl) 
dbselectArea("TEMP1")
dbCloseArea()

Return nil




Static Function AbreHtml()
Local cCabHtml 		:= ""
Local cFileCont 	:= ""
Local cDir := "c:\TEMP\"
Local cBaseArq := "Processo1"
Local nHdl1 := 0

MakeDir( cDir )
nhdl1 := fCreate(cdir+cBaseArq+".XLS",0)

If nHdl1 == -1
	ApMsgAlert("O arquivo "+cBaseArq+".XLS nao pode ser executado! Verifique os parametros.","Atencao!")
	Return(nHdl1)
Endif


//monta cabeçalho de pagina HTML para posterior utilização
cCabHtml := "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> " + CRLF
cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
cCabHtml += "<html>" + CRLF
cCabHtml += "<head>" + CRLF
cCabHtml += "  <title>teste</title>" + CRLF
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml += "</head>" + CRLF
cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF
cCabHtml += "" + CRLF
cFileCont := cCabHtml

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif
Return(nHdl1)

Static Function fecHtml(nHdl1)
Local cRodHtml 	:= ""
Local cFileCont	:= ""
// Monta Rodape Html para posterior utilizaçao
cRodHtml := "</body>" + CRLF
cRodHtml += "</html>" + CRLF
cFileCont := cRodHtml

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif
fClose(nHdl1)

Return nil

Static Function PutHtml(aConteudo, nTipo, nBold, nHdl1)
Local cLinFile 	:= ""
Local cFileCont := ""
Local nXb 		:= 0
Default nBold 	:= 0
Default nTipo	:= 2

//Aqui começa a montagem da pagina html propriamente dita
// acrescenta o cabeçalho
If nTipo == 1
	cLinFile += "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='2' cellspacing='2'>"
EndIf

cLinFile += "<TR>"

For nXb := 1 to Len(aConteudo)
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"
	if nBold == 1
		cLinFile += "<b>"
	Endif
	cLinFile += Alltrim(aConteudo[nXb])
	if nBold == 1
		cLinFile += "<b>"
	Endif
	cLinFile += "</TD>"
next nXb
cLinFile += "</TR>" + CRLF

If nTipo == 3
	cLinFile += "</Table>"
EndIf

cFileCont := cLinFile

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif

Return nil


Static Function CopiaArq()
Local lRet := .F.
Local cLocal := "c:\temp\duplic.dbf"
Local cDirServer := AllTrim( GetSrvProfString( "StartPath", "\" ) )
Local cRootPath := AllTrim( GetSrvProfString( "RootPath", "\" ) )
cRemoto := StrTran(Lower(cDirServer),Lower(cRootPath),"")
if Right(cRemoto,1) <> "\"
	cRemoto += "\"
endif

if !lIsDir(cRemoto)
	makeDir(cRemoto)
endif

if !empty(cLocal)
	Processa( { || lRet := CpyT2S( cLocal, cRemoto, .T. ) }, "Transferindo objeto","Aguarde...",.F.)
else
	lRet := .F.
endif
Return(lRet)


Static Function TrazArq()
Local lRet := .F.
Local cLocal := "c:\temp\"
Local cDirServer := AllTrim( GetSrvProfString( "StartPath", "\" ) )
Local cRootPath := AllTrim( GetSrvProfString( "RootPath", "\" ) )
cRemoto := StrTran(Lower(cDirServer),Lower(cRootPath),"")
if Right(cRemoto,1) <> "\"
	cRemoto += "\"
endif

if !lIsDir(cRemoto)
	makeDir(cRemoto)
endif

cRemoto := cRemoto + "duplic.dbf"

if !empty(cLocal)
	Processa( { || lRet := CpyS2T( cRemoto, cLocal, .T. ) }, "Transferindo objeto","Aguarde...",.F.)
else
	lRet := .F.
endif
Return(lRet)

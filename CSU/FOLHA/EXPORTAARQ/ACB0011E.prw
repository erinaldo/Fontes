#INCLUDE "PROTHEUS.CH"

User Function ACB0011E()
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
	Processa( {|lEnd| AcertaId(@lEnd)}, "Aguarde...","Gerando o Arquivo.", .T. )
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


Static Function AcertaId(lEnd)
Local cTrab     := "DUPLIC"
Local cTrab1    := "CSU"
Local cTrab2    := "DUPDEP"
Local cIndTemp1 := CriaTrab(,.f.)
Local nIndTMP1  := 0
Local cIndTemp2 := CriaTrab(,.f.)
Local nIndTMP2  := 0
Local lOk3 := .F.

dbSelectArea("SRA")
dbSetOrder(14)

dbSelectArea("SRB")
dbSetOrder(1)

dbUseArea( .T. , 'DBFCDX' , cTrab, 'TEMP1' , .T. , .F. )

IndRegua("TEMP1",cIndTemp1,"RA_MEDMAT",,,"Indexando arquivo....")
nIndTmp1 := 1
dbSetIndex(cIndTemp1+OrdBagExt())
dbSetorder(nIndTMP1)

dbUseArea( .T. , 'DBFCDX' , cTrab2, 'TEMP3' , .T. , .F. )

IndRegua("TEMP3",cIndTemp2,"RA_MEDMAT",,,"Indexando arquivo....")
nIndTMP2 := 1
dbSetIndex(cIndTemp2+OrdBagExt())
dbSetorder(nIndTMP2)


dbUseArea( .T. , 'DBFCDX' , cTrab1, 'TEMP2' , .T. , .F. )

ProcRegua(TEMP2->(RecCount()))

DbSelectArea("TEMP2")
dbGotop()     

While !eof()
	IncProc("Processando...")
	If Len(Alltrim(TEMP2->MEDMAT)) == 14
		if Alltrim(UPPER(TEMP2->TIPO)) == "TIT"
			dbSelectArea("TEMP1")
	    	if dbSeek(TEMP2->MEDMAT)
	    		if Alltrim(Upper(TEMP2->NOMASSOC)) == Alltrim(Upper(TEMP1->RA_NOME)) 
					dbSelectArea("TEMP2")
					RecLock("TEMP2", .F.)
					TEMP2->NOVOID := AJUSTA(TEMP2->MEDMAT, TEMP1->NOVOID)
					MsUnlock()
	
					dbSelectArea("TEMP1")
					RecLock("TEMP1", .F.)
					TEMP1->NUMREG := 9999999999
					MsUnlock()
					
				Else
					dbSelectArea("TEMP2")
					RecLock("TEMP2", .F.)
					TEMP2->NOVOID := TEMP2->MEDMAT
					MsUnlock()
				Endif
			Else
				dbSelectArea("TEMP2")
				RecLock("TEMP2", .F.)
				TEMP2->NOVOID := TEMP2->MEDMAT
				MsUnlock()
			Endif
		Else
			dbSelectArea("TEMP3")
	    	if dbSeek(TEMP2->MEDMAT)
	    		if Alltrim(Upper(TEMP2->NOMASSOC)) == Alltrim(Upper(TEMP3->RA_NOME)) 
					dbSelectArea("TEMP2")
					RecLock("TEMP2", .F.)
					TEMP2->NOVOID := AJUSTA(TEMP2->MEDMAT, TEMP3->NOVOID)
					MsUnlock()
	
					dbSelectArea("TEMP3")
					RecLock("TEMP3", .F.)
					TEMP3->NUMREG := 9999999999
					MsUnlock()
					
				Else
					dbSelectArea("TEMP2")
					RecLock("TEMP2", .F.)
					TEMP2->NOVOID := TEMP2->MEDMAT
					MsUnlock()
				Endif
			Else
				dbSelectArea("TEMP2")
				RecLock("TEMP2", .F.)
				TEMP2->NOVOID := TEMP2->MEDMAT
				MsUnlock()
			Endif
		EndIf
	Else
		dbSelectArea("SRA")	
		if dbSeek(temp2->TITULAR)
			IF Alltrim(Upper(TEMP2->TIPO)) == "TIT"
				IF !EMPTY(SRA->RA_MEDMAT)
					dbSelectArea("TEMP2")
					RecLock("TEMP2", .F.)
					TEMP2->NOVOID := AJUSTA(TEMP2->MEDMAT, SRA->RA_MEDMAT)
					MsUnlock()
				eLSE
					dbSelectArea("TEMP2")
					RecLock("TEMP2", .F.)
					TEMP2->NOVOID := Replicate("Z",14)
					MsUnlock()
				ENDIF				
			Else
				lOk3 := .F.
			    dbSelectArea("SRB")
			    dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			    While !eof() .and. SRB->(RB_FILIAL+RB_MAT) == SRA->(RA_FILIAL+RA_MAT)
			    	IF aLLTRIM(UPPER(TEMP2->SEQ)) == ALLTRIM(UPPER(SRB->RB_COD))
   						If !Empty(ALLTRIM(SRB->RB_MEDMAT))
							dbSelectArea("TEMP2")
							RecLock("TEMP2", .F.)
							TEMP2->NOVOID := AJUSTA(temp2->medmat, SRB->RB_MEDMAT)
							MsUnlock()
                        Else
							dbSelectArea("TEMP2")
							RecLock("TEMP2", .F.)
							TEMP2->NOVOID := Replicate("Z",14)
							MsUnlock()
                        Endif
						lOk3 := .T.
						Exit
					Endif
					dbSelectArea("SRB")
					dbSkip()
				End
				IF !lOk3
					dbSelectArea("TEMP2")
					RecLock("TEMP2", .F.)
					TEMP2->NOVOID := TEMP2->MEDMAT
					MsUnlock()
				Endif												
			Endif
		Else
			dbSelectArea("TEMP2")
			RecLock("TEMP2", .F.)
			TEMP2->NOVOID := TEMP2->MEDMAT
			MsUnlock()
		Endif
	Endif	
	DbSelectArea("TEMP2")
	dbSkip()
End

dbSelectArea("TEMP1")
ProcRegua(TEMP1->(RecCount()))

dbGotop()

nHdl := AbreHTML()
PutHtml({"Origem","STATUS","Filial","Matricula","Nome","ID Unico","Registro","Novo ID"}, 1, 1, nHdl)

dbSelectArea("TEMP1")
While !eof()
	IncProc("Gerando Excel 1...")
    if Temp1->NUMREG == 9999999999
		PutHtml({"TIT","OK",Temp1->RA_FILIAL,TEMP1->RA_MAT,TEMP1->RA_NOME,TEMP1->RA_MEDMAT,StrZero(TEMP1->NUMREG,10),TEMP1->NOVOID}, 2, 0, nHdl)
    Else
		PutHtml({"TIT","N/A",Temp1->RA_FILIAL,TEMP1->RA_MAT,TEMP1->RA_NOME,TEMP1->RA_MEDMAT,StrZero(TEMP1->NUMREG,10),TEMP1->NOVOID}, 2, 0, nHdl)
	Endif
    	
	dbSelectArea("TEMP1")
	dbSkip()   
End

ProcRegua(TEMP1->(RecCount()))

dbSelectArea("TEMP3")
While !eof()
	IncProc("Gerando Excel 2...")
    if Temp1->NUMREG == 9999999999
		PutHtml({"DEP","OK",Temp3->RA_FILIAL,TEMP3->RA_MAT,TEMP3->RA_NOME,TEMP3->RA_MEDMAT,StrZero(TEMP3->NUMREG,10),TEMP3->NOVOID}, 2, 0, nHdl)
    Else
		PutHtml({"DEP","N/A",Temp3->RA_FILIAL,TEMP3->RA_MAT,TEMP3->RA_NOME,TEMP3->RA_MEDMAT,StrZero(TEMP3->NUMREG,10),TEMP3->NOVOID}, 2, 0, nHdl)
	Endif
    	
	dbSelectArea("TEMP3")
	dbSkip()   
End

PutHtml({" "," "," "," "," "," "," "," "}, 3, 0, nHdl)
FecHtml(nHdl) 

dbSelectArea("TEMP2")
ProcRegua(TEMP2->(RecCount()))

dbGotop()

nHdl := AbreHTML("CSUPLAN")
PutHtml({"Cliente","Associado","Tipo","Sequencia","Titular","Dependente","Data Nascto","CPF","Matricula","Local","ID Anterior","Novo ID"}, 1, 1, nHdl)

dbSelectArea("TEMP2")
While !eof()
	IncProc("Gerando Excel 3...")
    if Temp2->MEDMAT <> TEMP2->NOVOID
		PutHtml({TEMP2->CLIENTE,TEMP2->ASSOCIADO,TEMP2->TIPO,TEMP2->SEQ,TEMP2->Titular,TEMP2->NOMASSOC,DTOC(TEMP2->dtnasc),TEMP2->CPF,TEMP2->Matricula,TEMP2->Local,TEMP2->MEDMAT,TEMP2->NOVOID}, 2, 0, nHdl)
	Endif
    	
	dbSelectArea("TEMP2")
	dbSkip()   
End

PutHtml({" "," "," "," "," "," "," "," "," "," "," "," "}, 3, 0, nHdl)
FecHtml(nHdl) 



dbselectArea("TEMP3")
dbCloseArea()
dbselectArea("TEMP2")
dbCloseArea()
dbselectArea("TEMP1")
dbCloseArea()

If File(cIndTemp1+OrdBagExt())
	fErase(cIndTemp1+OrdBagExt())
Endif

If File(cIndTemp2+OrdBagExt())
	fErase(cIndTemp2+OrdBagExt())
Endif

Return nil




Static Function AbreHtml(cBaseArq)
Local cCabHtml 		:= ""
Local cFileCont 	:= ""
Local cDir := "c:\TEMP\"
Local nHdl1 := 0
Default cBaseArq := "Processo2"

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

cLocal := "c:\temp\CSU.dbf"
if !empty(cLocal)
	Processa( { || lRet := CpyT2S( cLocal, cRemoto, .T. ) }, "Transferindo objeto","Aguarde...",.F.)
else
	lRet := .F.
endif

cLocal := "c:\temp\DUPDEP.dbf"
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
Local cArqRem := ""
cRemoto := StrTran(Lower(cDirServer),Lower(cRootPath),"")
if Right(cRemoto,1) <> "\"
	cRemoto += "\"
endif

if !lIsDir(cRemoto)
	makeDir(cRemoto)
endif

if !lIsDir(cLocal)
	makeDir(cLocal)
endif

cArqRem := cRemoto + "duplic.dbf"

if !empty(cLocal)
	Processa( { || lRet := CpyS2T( cArqRem, cLocal, .T. ) }, "Transferindo objeto","Aguarde...",.F.)
else
	lRet := .F.
endif

cArqRem := cRemoto + "CSU.dbf"

if !empty(cLocal)
	Processa( { || lRet := CpyS2T( cArqRem, cLocal, .T. ) }, "Transferindo objeto","Aguarde...",.F.)
else
	lRet := .F.
endif

cArqRem := cRemoto + "Dupdep.dbf"

if !empty(cLocal)
	Processa( { || lRet := CpyS2T( cArqRem, cLocal, .T. ) }, "Transferindo objeto","Aguarde...",.F.)
else
	lRet := .F.
endif

Return(lRet)


Static Function Ajusta(Origem, Destino)
Local cRet := ""
IF LEFT(dESTINO,4) <> "7261" .OR. !empty(Origem)
	iF !EMPTY(oRIGEM)
		cRet := left(Origem,4) + padl(right(Destino,10),10,"0")
	eLSE
		cRet := "7261" + padl(right(Destino,10),10,"0")
	Endif
Else
	cRet := Destino
Endif
Return(cRet)
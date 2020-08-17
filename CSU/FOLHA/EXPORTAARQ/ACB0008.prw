#INCLUDE "PROTHEUS.CH"

User Function ACB0008()
Local cQuery
Local aAreaAnt := GetArea()
Local aStru := {}
Local cTrab := "" 
Local cProxNum := ""
Local nHdl := 0

aadd(aStru, {"RA_FILIAL","C",02,00} )
aadd(aStru, {"RA_MAT",   "C",06,00} )
aadd(aStru, {"RA_NOME",  "C",40,00} )
aadd(aStru, {"RA_MEDMAT","C",14,00} )
aadd(aStru, {"NUMREG",   "N",10,00} )
aadd(aStru, {"NOVOMED",  "C",14,00} )

cTrab := "ProvDup"

IF fILE(CtRAB+".dbf")
	fErase(CtRAB+".dbf")
Endif

dbCreate( cTrab, aStru, "DBFCDX" )

dbUseArea( .T. , 'DBFCDX' , cTrab, 'TEMP1' , .T. , .F. )
DbGotop()

cQuery := "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_MEDMAT, R_E_C_N_O_ as NUMREG "
cQuery += "From " + retSqlName("SRA") + " "
cQuery += "WHERE R_E_C_N_O_ IN ( "
cQuery += "SELECT MAX(R_E_C_N_O_) AS Recno FROM " + retSqlName("SRA") + " "
cQuery += "WHERE RA_MEDMAT <> ' ' AND D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY RA_MEDMAT "
cQuery += "HAVING COUNT(RA_MEDMAT) > 1 ) "


cQuery := ChangeQuery(cQuery)

dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), 'TRAB' , .T. , .F. )

cFields := ""
aEval(TRAB->(dbStruct()), {|z| cFields += z[1] + ";"})

aEval(SRA->(dbStruct()), {|z| If(z[2] # "C" .And. z[1] $ cFields, TcSetField("TRAB",z[1],z[2],z[3],z[4]), Nil)}) 

dbSelectArea("TRAB")
dbGotop()
While !Eof()
	dbSelectArea("TEMP1")
	RecLock("TEMP1",.T.)
	For nXa := 1 to TRAB->(fCount())
		FieldPut( TEMP1->( FieldPos(TRAB->(Fieldname(nXA))) ),TRAB->(FieldGet(nXA)) )
	Next nXa
	MSUNLOCK()
	dbSelectArea("TRAB")
	dbSkip()
End
dbSelectArea("TRAB")
dbCloseArea()
dbSelectArea("TEMP1")
dbCloseArea()
RestArea(aAreaAnt)

/*
cQuery := "UPDATE " + retSqlName("SRA") + " "
cQuery += "SET RA_MEDMAT = ' ' "
cQuery += "WHERE R_E_C_N_O_ IN ( "
cQuery += "SELECT MAX(R_E_C_N_O_) AS Recno FROM SRA050 "
cQuery += "WHERE RA_MEDMAT <> ' ' AND D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY RA_MEDMAT "
cQuery += "HAVING COUNT(RA_MEDMAT) > 1 ) "

tcSqlExec(cQuery)
*/

cProxNum := u_nextNum(1)
cProxNum := padl(Right(alltrim(cProxNUM),10),10,"0")

dbUseArea( .T. , 'DBFCDX' , cTrab, 'TEMP1' , .T. , .F. )

dbSelectArea("TEMP1")
DbGotop()

While !eof()
	cProxNum := u_nextNum(1)
	cProxNum := padl(Right(alltrim(cProxNUM),10),10,"0")
	RecLock("TEMP1", .F.)
	TEMP1->NOVOMED := left(TEMP1->RA_MEDMAT,4) + cProxNum
	MsUnlock()
	
	dbSelectArea("SRA")
	dbGoto(Temp1->NUMREG)
	RecLock("SRA",.F.)
	SRA->RA_MEDMAT := TEMP1->NOVOMED
	MsUnlock()
	
	DbSelectArea("TEMP1")
	dbSkip()
End

dbSelectArea("TEMP1")
dbGotop()

nHdl := AbreHTML()
PutHtml({"Filial","Matricula","Nome","ID Unico","Registro","Novo ID"}, 1, 1, nHdl)

dbSelectArea("TEMP1")
While !eof()
	PutHtml({Temp1->RA_FILIAL,TEMP1->RA_MAT,TEMP1->RA_NOME,TEMP1->RA_MEDMAT,StrZero(TEMP1->NUMREG,10),TEMP1->NOVOMED}, 2, 0, nHdl)

	dbSelectArea("TEMP1")
	dbSkip()   
End

PutHtml({" "," "," "," "," "," "}, 3, 0, nHdl)
FecHtml(nHdl) 
dbselectArea("TEMP1")
dbCloseArea()


RestArea(aAreaAnt)
Return nil




Static Function AbreHtml()
Local cCabHtml 		:= ""
Local cFileCont 	:= ""
Local cDir := "c:\TEMP\"
Local cBaseArq := "duplicados"
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

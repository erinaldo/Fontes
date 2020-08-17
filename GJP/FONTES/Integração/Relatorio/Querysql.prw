#Include 'RwMake.ch'
#Include 'TopConn.ch'
#Include 'TbiConn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QuerySQL บAutor  ณCarlos G. Berganton บ Data ณ  14/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa query como o Query Analyser.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function QuerySQL()

Private cQuery  := ""
Private aCols   := {}
Private aHeader := {}
Private cTmp    := Space(02)
Private lTstQry := .t.
cTexto  := ""
cFOpen  := ""

//IF !(__cUserID $ "000000")//Administrador 
//	MsgStop("Voc๊ nใo tem Acesso a essa Rotina !!!")
//	Return
//Endif

aHeader := {{"   ","cTmp"  ,""  ,2 , 0,"","","C","",""}}
aCols   := {{"  ",.f.}}

@ 110,000 To 555,798 Dialog oDlgQuery Title "Query Analyser Para Protheus v2.0 ... Valor utilize XN_"
@ 002,005 Say OemToAnsi("Arquivo: <SEM NOME>"+Space(100)) Object oNome
@ 010,005 Get cQuery Size 390,190 MEMO Object oMemo
@ 200,005 CHECKBOX "Testa Query Antes de Executar." VAR lTstQry
@ 207,005 Button OemToAnsi("_Consultar...")   Size 36,16 Action fExecQuery("Cons")
IF Alltrim(Substr(cUsuario,7,15))== "Administrador"
	@ 207,055 Button OemToAnsi("_Executar...")    Size 36,16 Action fExecQuery("Exec")
ENDIF
@ 207,105 Button OemToAnsi("_Abrir...")       Size 36,16 Action FRAbre()
@ 207,155 Button OemToAnsi("_Fechar")         Size 36,16 Action FRFecha()
@ 207,205 Button OemToAnsi("_Salvar")         Size 36,16 Action FRSalva()
@ 207,255 Button OemToAnsi("_Salvar Como...") Size 36,16 Action FRSalvaComo()
@ 207,350 BmpButton Type 2 Action Close(oDlgQuery)

Activate Dialog oDlgQuery

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExecQueryบAutor  ณCarlos G. Berganton บ Data ณ  15/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta a Query e monta o MultiLine com o Resultado         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fExecquery(cModo)

Local aStru    := {}
Local aColsTmp := {}
Local cQryAtu
Local i

IF LEN(cQuery) == 0
	ALERT("Precisa digitar alguma instru็ใo !!!")
	RETURN
ENDIF

cQryAtu := ChangeQuery(cQuery)

If cModo = "Cons"
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Testa Query antes de Executar ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lTstQry
		nRet := TcSqlExec(cQryAtu)
		If nRet#0
			cRet := TCSQLError()
			APMsgAlert(AllTrim(cRet),"Erro do SQL")
			Return
		Endif
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Zera Variaveis do Browse ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCols   := {}
	aHeader := {}
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha Alias se estiver em Uso ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select("TRB"))
		dbSelectArea("TRB")
		dbCloseArea()
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta Area de Trabalho executando a Query ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TCQUERY cQryAtu New Alias "TRB"
	MemoWrit("c:\siga\querysql.sql",cQryAtu)
	
	dbSelectArea("TRB")
	aStru := dbStruct()
	For i:=1 to Len(aStru)
		_cCampo := aStru[i][1]
		If SUBS(aStru[i][1],1,3)=="XN_"
			TcSetField("TRB",_cCampo,"N",14,3)
		Endif
		SX3->(DBGOTOP())
		SX3->( dbSetOrder( 2 ) )
		If SX3->(dbSeek(aStru[i][1]))
			If SX3->X3_TIPO == "N"
				TcSetField("TRB",_cCampo,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL)
			Endif
		Endif
	Next I
	
	dbGoTop()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta aHeader ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//aStru := dbStruct()
	aAdd(aStru,{"","C",1,0})
	
	For i:=1 to Len(aStru)
		If "USERLGI" $ aStru[i][1]
			aStru[i][3]:= 27
		Endif
		
		If "USERLGA" $ aStru[i][1]
			aStru[i][3]:= 30
		Endif
		If SUBS(aStru[i][1],1,3) == "XN_"
			aStru[i][2]:= "N"
			aStru[i][3]:= 14
			aStru[i][4]:= 3
		Endif
	Next
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declara Variaveis do aHeader ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For i:=1 to Len(aStru)
		cVar  := "Var"+AllTrim(Str(i))+" := "+fGetResult(aStru,i)
		(&(cVar))
	Next
	
	For i:=1 to Len(aStru)
		aAdd(aHeader,{aStru[i][1],"Var"+AllTrim(Str(i)),"",aStru[i][3],aStru[i][4],"","",aStru[i][2],"",""})
	Next
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta aCols ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbGoTop()
	While !EOF()
		aColsTmp := Array(Len(aStru)+1)
		For i:=1 to Len(aStru)
			If "USERLG"$aStru[i][1]
				cUser  := Embaralha(&(aStru[i][1]),1)
				aColsTmp[i]:= Substr(cUser,1,15)+"-"+IIF(!Empty(cUser),DTOC(CTOD("01/01/96") + Load2in4(Substr(cUser,16))),DTOC(CTOD("//")))
			Else
				aColsTmp[i]:=FieldGet(i)
			Endif
		Next
		aColsTmp[Len(aStru)+1] := .f.
		
		aAdd(aCols,aColsTmp)
		dbSkip()
	End
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta outra janela para o resultado da Query ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ 000,000 TO 550,795 DIALOG oResultQry TITLE "Resultado da Query..."
	//	@ 005,005 TO 270,395 MULTILINE FREEZE 1
	@ 005,005 TO 250,395 MULTILINE FREEZE 1
	@ 260,350 BmpButton Type 2 Action FRFECHA()
	ACTIVATE DIALOG oResultQry
	
Elseif cModo = "Exec"
	If MsgBox("Deseja realmente executar os comandos acima???","SQL Query","YESNO")
		nRet := TcSqlExec(cQuery)
		If nRet#0
			cRet = TCSQLError()
			APMsgAlert(AllTrim(cRet),"Erro do SQL")
		Else
			Alert("Comando Executado...")
		Endif
	Endif
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGetResultบAutor  ณCarlos G. Berganton บ Data ณ  19/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca Texto para Final da Declaracao das variaveis do       บฑฑ
ฑฑบ          ณaHeader.                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FRFECHA()
//Vai Gravar dentro do AP_DATA
IF APMSGYESNO("Deseja exportar a query para Excell ?","ESCOLHA")
	//	cArqExcel := "\QUERYSQL.XLS"
	//	Copy To &cArqExcel
	
	cPatSRV :=ALLTRIM(GETMV("MV_RELT"))
	cPatREM := "C:\SIGA\"
	If !lIsDir(cPatREM)
		Msginfo("Diretorio na Esta็ใo: "+cPatREM+" nao existe, serแ criado","ATENวรO")
		MakeDir(cPatREM)
	ENDIF
	
	cArqExcel := cPatSRV+"QUERYSQL.XLS"
	Copy To &cArqExcel VIA "DBFCDXADS"
	CpyS2T(cArqExcel,cPatREM)//COPIA SERVER P/ REMOTE
	
	aFiles := Directory(cPatREM+"*.TMP")
	
	If Len(aFiles) > 0
		For nCont:=1 To Len(aFiles)
			fErase(cPatREM+aFiles[nCont][1])
		Next
	Endif

ENDIF

Close(oResultQry)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGetResultบAutor  ณCarlos G. Berganton บ Data ณ  19/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca Texto para Final da Declaracao das variaveis do       บฑฑ
ฑฑบ          ณaHeader.                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGetResult(aStru,i)
Local cRet

If aStru[i][2]=="C"
	cRet := "Space("+AllTrim(Str(aStru[i][3]))+")"
Elseif aStru[i][2]=="N"
	cRet := "0"
Elseif aStru[i][2]=="D"
	cRet := 'CTOD("//")'
Else
	Alert("Tipo de dado nao Tratado aStru[i][2] = "+aStru[i][2])
	cRet := ""
Endif

Return(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fRAbre   บ Autor ณCarlos G. Berganton บ Data ณ  15/08/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Rotina para a abertura do arquivo texto na FunMEMO         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fRAbre()

cFOpen := cGetFile("Sql Query|*.SQL|Arquivos Texto|*.TXT|Todos os Arquivos|*.*",OemToAnsi("Abrir Arquivo..."))
If !Empty(cFOpen)
	cQuery := MemoRead(cFOpen)
	ObjectMethod(oMemo,"Refresh()")
	ObjectMethod(oNome,"SetText('Arquivo: '+cFOpen)")
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fRFecha  บ Autor ณCarlos G. Berganton บ Data ณ  15/08/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Rotina para fechamento do arquivo texto em FunMEMO         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fRFecha()
cQuery := ""
cFOpen := ""
ObjectMethod(oMemo,"Refresh()")
ObjectMethod(oNome,"SetText('Arquivo: <SEM NOME>')")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fRSalva  บ Autor ณCarlos G. Berganton บ Data ณ 15/08/2003  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Rotina para salvar o arquivo texto em FunMEMO              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fRSalva()
If !Empty(cFOpen)
	MemoWrit(cFOpen,cQuery)
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno   ณfRSalvaComoบ Autor ณCarlos G. Berganton บ Data ณ 15/08/2003  บฑฑ
ฑฑฬอออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrioณ Rotina para salvar arquivo texto com outro nome em FunMEMO  บฑฑ
ฑฑศอออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fRSalvaComo()
cAux   := cFOpen
cFOpen := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",OemToAnsi("Salvar Arquivo Como..."))
If !Empty(cFOpen)
	MemoWrit(cFOpen,cQuery)
	ObjectMethod(oNome,"SetText('Arquivo: '+cFOpen)")
Else
	cFOpen := cAux
Endif
Return

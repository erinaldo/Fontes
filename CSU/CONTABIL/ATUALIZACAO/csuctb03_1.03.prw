#INCLUDE "rwmake.ch"

// *** Rotina de importação via arquivo TXT que possui os lançamentos
// *** contábeis referentes a folha de pagamento.
// *** Data: 14/02/2002

User Function CSUCTB03()

// *** Verifica se esta rotina já está sendo executada neste momento. Sem sim,
// *** finaliza este processamento. Caso a tabela de controle (Semaforo) não
// *** exista, será criada.

DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial()+"Z1CSUFOL")

If Found() .and. !Empty(SX5->X5_DESCRI)
	MsgAlert("Esta rotina somente deve ser executada por uma única estação. No momento a mesma já encontra-se em uso. Tente novamente mais tarde !","Atencao!")
	Return
EndIf

If Eof()
	RecLock("SX5",.T.)
	SX5->X5_FILIAL := xFilial()
	SX5->X5_TABELA := "Z1"
	SX5->X5_CHAVE  := "CSUFOL"
	SX5->X5_DESCRI := "*"
	MsUnLock()
EndIf

// *** Verifica existencia de pergunta no SX1 ref. a esta rotina.
// *** Caso não exista será criada.
// *** mv_par01

_cPerg := PADR("ZZ0003",LEN(SX1->X1_GRUPO))

validperg()

Pergunte(_cPerg,.F.)


// *** Declaracao de variaveis padroes

aVerba := {}
aAdd(aVerba,{"DATALAN","C",08,0})
aAdd(aVerba,{"DEBITO", "C",20,0})
aAdd(aVerba,{"CREDITO","C",20,0})
aAdd(aVerba,{"VALOR",  "N",15,2})
aAdd(aVerba,{"HP",     "C",03,0})
aAdd(aVerba,{"HIST",   "C",200,0})

// *** Montagem da tela de Inicial de apresentação da rotina.

@ 200,1 TO 380,450 DIALOG oLeTxt TITLE OemToAnsi("Imp. De Lançamentos Contábeis Ref. Folha De Pagamento")
@ 02,10 TO 060,215
@ 10,018 Say " Esta rotina tem como objetivo a importação dos lançamentos contábeis ref. "	SIZE 196,0
@ 18,018 Say " a folha de pagamento. Esta importação será efetuada através de arquivo TXT"	SIZE 196,0
@ 26,018 Say " gerado pelo sistema RM. "							                 		SIZE 196,0
@ 34,018 Say " IMPORTANTE: Após o término da importação em questão, é de suma            "	SIZE 196,0
@ 42,018 Say " importância a execução do REPROCESSAMENTO CONTÁBIL.             		     "	SIZE 196,0

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 01 ACTION (Proctit(),Close(oLeTxt))
@ 70,188 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

// *** Seta semáforo com status de liberado.
LimpSema()

Return

Static Function Proctit()
Processa({ ||OkLeTxt() } )
Return

// **********************************************************
// *** Funcao chamada pelo botao OK na tela inicial de processamento

Static Function OkLeTxt()

// *** Verifica variável utilizada na pergunta.

cFile:= "C:\AP6IMPOR\RH\"+Alltrim(Mv_Par01)+".TXT"

If 	Empty(Mv_Par01)
	MsgAlert("Parametros nao preenchidos !!! Verifique !","Atencao!")
	Return
EndIf


If 	Subs(Alltrim(Mv_Par01),1,2) <> SM0->M0_CODIGO
	MsgAlert("Arquivo a importar não corresponde a esta empresa !!! Verifique !","Atencao!")
	Return
EndIf

IF !ConvTxt(@cFile)
	
	IF alltrim(cFile)==ALLTRIM("C:\AP6IMPOR\RH\"+Alltrim(Mv_Par01)+".TXT")
		MsgAlert("Arquivo "+cFile+" não encontrado!","Atencao!")
		RETURN
	Else
		MsgAlert("Arquivo "+cFile+" já processado !","Atencao!")
		RETURN
	Endif
Endif

// *** Cria arquivo temporario

cArqVerba := CriaTrab(aVerba)
dbUseArea( .T.,,cArqVerba,"TMP",.F. )

Append From (cFile) Delimited With ","
dbGoTop()

// *** Inicializa processamento

dbSelectArea("TMP")
DbGoTop()

// *** Verifica se o arquivo a ser importado é referente a esta rotina, ou seja,
// *** IMPORTAÇÃO DE LANÇAMENTOS DE FOLHA DE PAGAMENTO.
// *** Caso não seja, será encerrada a rotina.
// *** Obs.: a identificação é efetuada através do código do Histórico vindo do TXT,
// *** neste caso, o código deve ser diferente de "72" (setenta e dois).

IF Alltrim(TMP->HP) <> "72"
	MsgAlert("Arquivo a ser importado está incorreto !!!")
	DBCLOSEAREA("TMP")
	Return
EndIf

// Busca o primeiro número de Documento a ser utilizado.
cLote := "009920"
cSbLote := "001"
dDataLan := CTOD(SUBSTR(TMP->DATALAN,1,2)+'/'+SUBSTR(TMP->DATALAN,3,2)+'/'+SUBSTR(TMP->DATALAN,5,4))
// cMes := Subs(TMP->DATALAN,3,2)

// Busca numero de documento a ser utilizado.
DbSelectArea("CT2")
DbSetOrder(1)
DbSeek( xFilial()+DTOS(dDataLan)+cLote+cSbLote+"999999",.T. )

DbSkip(-1)

If CT2->CT2_DATA == dDataLan .and. CT2->CT2_LOTE == cLote .and. CT2->CT2_SBLOTE == cSbLote
	cDOC := StrZero(Val(CT2->CT2_DOC) + 1,6)
Else
	cDoc := "000001"
EndIf

nLin := 1

// Inicia processamento.
dbSelectArea("TMP")
DbGoTop()

ProcRegua(TMP->(Reccount()))

aLanc := {}
// aLanc := { "",0.0,"","","" }
// { DC,Valor,CCCred,CCDeb,CCusto }

nLin := 1
_aRelCust := {}  
errolin:=0

While !Eof()   // pois o RH quer a lista completa de CC errados.
	
	If ALLTRIM(TMP->CREDITO) <> ""
		_nval := TMP->VALOR
	EndIf
	
	errolin:=errolin+1
	
	If ALLTRIM(TMP->CREDITO) == ""
		If _ValidCC(TMP->DATALAN)
			AADD( _aRelCust,{ TMP->DATALAN,_nval,errolin})
		EndIf
	EndIf
	
	dbSelectArea("TMP")
	DBSkip()
EndDo

_ccInc := ""

If len(_aRelCust) > 0
	For _i:= 1 to len(_aRelCust)
		_cText := ALLTRIM(Transform(_aRelCust[_i,2], "R$ 99999999.99"))		
		_ccInc := _ccInc + "Centro de Custo invalido - "+_aRelCust[_i,1]+" Linha: "+Alltrim(STR(_aRelCust[_i,3]));
		+"   "+_cText+CHR(10)+CHR(13)
		
	Next
	
	MsgBox (_ccInc," CC Incorretos","INFO")
	dbSelectArea("TMP")
	TMP->(DBCloseArea())
	
	Return()
EndIf

dbSelectArea("TMP")
DbGoTop()

ProcRegua(TMP->(Reccount()))

While !Eof()
	
	IncProc("Efetuando importação...")
	
	IF !Empty(TMP->CREDITO)
		
		dDataLan := CTOD(SUBSTR(TMP->DATALAN,1,2)+'/'+SUBSTR(TMP->DATALAN,3,2)+'/'+SUBSTR(TMP->DATALAN,5,4))
		// cMesAno  := SUBSTR(TMP->DATALAN,3,2)+SUBSTR(TMP->DATALAN,5,4)
		
		// *** Verifica o tamanho do histórico e quantidade de linhas de
		// *** lançamento por consequencia.
		cHist := ALLTRIM(TMP->HIST)
		nNum := 0.0
		nNum := Round(Len(cHist)/40,1)
		
		// *** Caso o numero de linhas encontrado seja quebrado, aumenta para o próximo
		// *** número inteiro.
		If Int(nNum) < nNum
			nNum := Int(nNum) + 1
		EndIf
		
		// Prepara variavel de informaçao sobre o lancamento
		// 1 - Partida dobrada sem C.Custo
		// 2 - Partida dobrada com C.Custo
		// 3 - Mais de uma linha (Debitos e Credito) - RATEIO.
		cSitLan := 0
		
		// Verifica se o lancamento em questao tem C.Custo.
		DbSkip()
		
		If !Empty(TMP->CREDITO) .or. TMP->(Eof())
			cSitLan := "1"
			DbSkip(-1)
		Else
			
			DbSkip(-1)
			
			// Verifica agora se será partida dobrada com C.Custo ou RATEIO.
			Dbskip(2)
			If !Empty(TMP->CREDITO)
				cSitLan := "2"
			Else
				cSitLan := "3"
			EndIf
			DbSkip(-2)
			
		EndIf
		
		If cSitLan == "1"
			aAdd( aLanc,{"3",TMP->VALOR,AllTrim(TMP->CREDITO),TMP->DEBITO,""} )
		ElseIf cSitLan == "2"
			// Se for Situaçao 2, vai buscar no registro de baixo o C.Custo.
			DbSkip()
			cCC := TMP->DATALAN
			DbSkip(-1)
			aAdd( aLanc,{"3",TMP->VALOR,AllTrim(TMP->CREDITO),TMP->DEBITO,cCC} )
			DbSkip()
		ElseIf cSitLan == "3"
			
			cCDeb := AllTrim(TMP->DEBITO)
			nRegCre := Recno()
		EndIf
		
	Else
		
		aAdd( aLanc,{"1",Val(TMP->DEBITO),"",cCDeb,TMP->DATALAN} )
		
	EndIf
	
	dbSelectArea("TMP")
	DBSKIP()
	
	// Verifica se encontrou uma outra linha de credito. Se sim, deverá gravar o
	// lancamento anterior.
	IF !Empty(TMP->CREDITO) .or. Eof()
		
		If cSitLan == "3"
			
			// Monta linha de credito a ser lancada.
			nRegAtu := Recno()
			Go nRegCre
			aAdd( aLanc,{"2",TMP->VALOR,AllTrim(TMP->CREDITO),"",""} )
			Go nRegAtu
			
		EndIf
		
		//If nLin + (nNum*Len(aLanc)) >= 999
		//	cDoc := strzero(val(cDoc) + 1,6)
		//	nLin := 1
		//EndIf
		
		DBSELECTAREA("CT2")
		
		For x := 1 to Len(aLanc)
			
			RecLock("CT2",.T.)
			CT2->CT2_FILIAL := XFILIAL()
			CT2->CT2_LOTE   := cLote
			CT2->CT2_SBLOTE := cSbLote
			CT2->CT2_DOC    := cDoc
			CT2->CT2_DATA   := dDataLan
			CT2->CT2_DC     := aLanc[x][1]
			CT2->CT2_VALOR  := aLanc[x][2] //mtdo
			CT2->CT2_VLR01  := aLanc[x][2]
			
			dbSelectArea("CT1")
			
			//Substítui lancto reduzido pela conta contábil
			If !Empty(aLanc[x][3])
				DbSetOrder(2)
				Dbseek (xfilial()+(aLanc[x][3]))
				aLanc[x][3]:=CT1->CT1_CONTA
			Endif
			//Substítui lancto reduzido pela conta contábil
			If !Empty(aLanc[x][4])
				DbSetOrder(2)
				Dbseek (xfilial()+(aLanc[x][4]))
				aLanc[x][4]:=CT1->CT1_CONTA
			Endif
			
			dbSelectArea("CT2")
			
			CT2->CT2_CREDIT := IF(aLanc[x][1]$"32",IF(!Empty(aLanc[x][3]),aLanc[x][3],"INFORMAR CONTA"),"")
			CT2->CT2_DEBITO := IF(aLanc[x][1]$"31",IF(!Empty(aLanc[x][4]),aLanc[x][4],"INFORMAR CONTA"),"")
			
			IF SUBSTR(CT2->CT2_CREDIT,1,1)="3"
				CT2->CT2_CCC    := aLanc[x][5]
			ELSE
				CT2->CT2_CCD    := aLanc[x][5]
			ENDIF
			                                    //24       //26                                                 
			hist:= "FOLHA DE PAGAMENTO REF. "+SUBSTR(cHist,1,40)			                                    
			
			// se historico for menor que 40
			if len(hist)<=40
				CT2->CT2_HIST:= hist
			Else      
				CT2->CT2_HIST:= hist
				nNum:=2
			Endif
		
			CT2->CT2_MOEDLC := "01"
			CT2->CT2_MOEDAS := "11111"
			CT2->CT2_EMPORI := Substr(cNumEmp,1,2)
			CT2->CT2_FILORI := XFILIAL()
			CT2->CT2_TPSALD := "1"
			CT2->CT2_MANUAL := "1"
			CT2->CT2_AGLUT  := "2"
			CT2->CT2_LINHA  := STRZERO(nLin,3)
			CT2->CT2_ROTINA := "CSUCTB03"
			CT2->CT2_SEQHIS := "001"
			// CT2->CT2_MES    := cMes
			MsUnLock()
			
			nLin := nLin + 1
			
			// Grava históricos complementares, caso seja necessário.
			If  nNum > 1
				
				// nNum    := nNum - 1 // desconsidera a a 1a. linha de lançamento.
				nPos    := 41
				nSqHist := 2
				
				For y := 1 to (nNum-1)
					
					RecLock("CT2",.T.)
					CT2->CT2_FILIAL := XFILIAL()
					CT2->CT2_DATA   := dDataLan
					CT2->CT2_DC     := "4"
					CT2->CT2_LOTE   := cLote
					CT2->CT2_DOC    := cDoc
					CT2->CT2_SBLOTE := cSbLote
					CT2->CT2_HIST   := SUBSTR(Hist,npos,40)
					CT2->CT2_LINHA  := STRZERO(nLIN,3)
					CT2->CT2_MOEDLC := "01"
					CT2->CT2_EMPORI := Substr(cNumEmp,1,2)
					CT2->CT2_FILORI := XFILIAL()
					CT2->CT2_TPSALD := "1"
					CT2->CT2_MANUAL := "1"
					CT2->CT2_AGLUT  := "2"
					CT2->CT2_SEQHIS := STRZERO(nSqHist,3)
					CT2->CT2_ROTINA := "CSUCTB03"
					// CT2->CT2_MES := cMes
					MsUnlock()
					
					nPos   := nPos + 40
					nSqHist := nSqHist + 1
					nLin := nLin + 1
					
				Next
				
			EndIf
			
		Next
		
		// Apos gravacao, limpa variaveis de controle.
		aLanc := {}
		
		// Busca numero de documento a ser utilizado.
		DbSelectArea("CT2")
		DbSetOrder(1)
		DbSeek( xFilial()+DTOS(dDataLan)+cLote+cSbLote+"999999",.T. )
		
		DbSkip(-1)
		
		If CT2->CT2_DATA == dDataLan .and. CT2->CT2_LOTE == cLote .and. CT2->CT2_SBLOTE == cSbLote
			cDOC := StrZero(Val(CT2->CT2_DOC) + 1,6)
		Else
			cDoc := "000001"
		EndIf
		
		nLin := 1
		
	EndIf
	
	DBSELECTAREA("TMP")
	
ENDDO

DBCLOSEAREA("TMP")

ALERT("TERMINO DA IMPORTACAO")

//Close(oLeTxt)

Return

// **********************************************************
// *** Função de ajuste do TXT a ser importado.

Static Function ConvTxt(cTextName)
PRIVATE lnHandle := 0
lnHandle :=FOPEN(cTextName)

IF lnHandle < 1
	RETURN .F.
ENDIF

PRIVATE nTamArq := 0
nTamArq := fSeek(lnHandle,0,2)

fSeek(lnHandle,0)

PRIVATE lnRead := 0
PRIVATE lnHndNew := 0
PRIVATE lcString := ""
PRIVATE lcWord 	 := ""
PRIVATE llEnd 	 := .F.
PRIVATE lcNewString := ""
PRIVATE lnHandleOK :=0

lnHandleOK := FOPEN(cTextName + ".OK")

If lnHandleOK > 1
	cTextName := cTextName + ".OK"
	FCLOSE(lnHandle)
	FCLOSE(lnHandleOK)
	Return .F.
Else
	
	lnHndNew := FCREATE(cTextName + ".OK")
	cTextName := cTextName + ".OK"
	
Endif

DO WHILE lnRead < nTamArq
	
	lcNewString := ""
	
	lcString := FREADSTR(lnHandle,1024)
	
	FOR i = 1 TO LEN(lcString)
		lcWord = SUBSTR(lcString,i,1)
		
		IF lcWord = '"'
			llEnd := !llEnd
		ENDIF
		
		IF lcWord = ',' .AND. llEnd
			lcWord := " "
		ENDIF
		
		lcNewString := lcNewString + lcWord
	NEXT
	
	// lcNewString := lcNewString
	lnRead := lnRead + LEN(lcNewString)
	
	FWRITE(lnHndNew,lcNewString)
ENDDO

FCLOSE(lnHandle)
FCLOSE(lnHndNew)
FCLOSE(lnHandleOK)

RETURN .T.

// **********************************************************
// *** Função de ajuste do TXT a ser importado.
Static Function LimpSema()

cAlias := Alias()

DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial()+"Z1CSUFOL")

If Found() .and. !Empty(SX5->X5_DESCRI)
	RecLock("SX5",.f.)
	SX5->X5_DESCRI := " "
	MsUnLock()
EndIf

DbSelectArea(cAlias)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VALIDPERG ³ Autor ³  Luiz Carlos Vieira   ³ Data ³ 18/11/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espec¡fico para clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 07/06/00 ==> Function ValidPerg

Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(_cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{_cPerg,"01","Arquivo de Leitura?","","","mv_ch1","C",16,0,0,"G","","mv_par01","","DEFAULT.TXT","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return





Static Function _ValidCC(_cc)

_bOk := .F.
DBSelectArea("CTT")
DBSetOrder(1)

If DBseek(xFilial("CTT")+ALLTRIM(_cc),.F.)
	
	If ALLTRIM(CTT->CTT_EMPRES) <> ALLTRIM(SM0->M0_CODIGO)
		
		_bOk := .T.
		
	EndIf
	
EndIf

Return(_bOk)




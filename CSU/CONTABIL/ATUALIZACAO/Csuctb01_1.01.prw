#INCLUDE "rwmake.ch"

// *** Rotina de importa��o via arquivo TXT que possui os lan�amentos 
// *** cont�beis referentes as provisoes de titulos a pagar da CSU.
// *** Data: 29/01/2001

User Function CSUCTB01()
              
// *** Verifica se esta rotina j� est� sendo executada neste momento. Sem sim, 
// *** finaliza este processamento. Caso a tabela de controle (Semaforo) n�o 
// *** exista, ser� criada. 

DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial()+"Z1CSUFIN")

If Found() .and. !Empty(SX5->X5_DESCRI)
	MsgAlert("Esta rotina somente deve ser executada por uma �nica esta��o. No momento a mesma j� encontra-se em uso. Tente novamente mais tarde !","Atencao!")
	Return
EndIf	
	
If Eof()
	RecLock("SX5",.T.)
	SX5->X5_FILIAL := xFilial()
	SX5->X5_TABELA := "Z1"
	SX5->X5_CHAVE  := "CSUFIN"
	SX5->X5_DESCRI := "*"
	MsUnLock()
EndIf	
	
// *** Verifica existencia de pergunta no SX1 ref. a esta rotina.
// *** Caso n�o exista ser� criada.
// *** mv_par01

_cPerg := PADR("ZZ0001" ,LEN(SX1->X1_GRUPO))

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek( _cPerg+"01" )

If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := _cPerg
	SX1->X1_ORDEM    := "01"
	SX1->X1_PERGUNT  := "Arquivo a importar?"
	SX1->X1_VARIAVL  := "mv_ch1"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 8
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "mv_par01"
	MsUnlock()
EndIf

Pergunte(_cPerg,.F.)

// *** Declaracao de variaveis padroes  

aVerba := {}
aAdd(aVerba,{"DATALAN","C",08,0})
aAdd(aVerba,{"DEBITO", "C",20,0})
aAdd(aVerba,{"CREDITO","C",20,0})
aAdd(aVerba,{"VALOR",  "N",15,2})
aAdd(aVerba,{"HP",     "C",03,0})
aAdd(aVerba,{"HIST",   "C",200,0})

// *** Montagem da tela de Inicial de apresenta��o da rotina.

@ 200,1 TO 380,450 DIALOG oLeTxt TITLE OemToAnsi("Imp. de Lan�amentos Cont�beis ref. as Provis�es de Contas a Pagar")
@ 02,10 TO 060,215
@ 10,018 Say " Esta rotina tem como objetivo a importa��o dos lan�amentos cont�beis ref."	SIZE 196,0
@ 18,018 Say " as provis�es de Contas a Pagar. Esta importa��o ser� efetuada atrav�s de "	SIZE 196,0
@ 26,018 Say " arquivo TXT gerado pelo sistema M�XIMO. "									SIZE 196,0
@ 34,018 Say " IMPORTANTE: Ap�s o t�rmino da importa��o em quest�o, � de suma       "	SIZE 196,0
@ 42,018 Say " import�ncia a execu��o do REPROCESSAMENTO CONT�BIL.             			"	SIZE 196,0


@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 01 ACTION (Proctit(),close(oLeTxt))
@ 70,188 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

// *** Seta sem�foro com status de liberado.
LimpSema()

Return

Static Function Proctit()
Processa({ ||OkLeTxt() } )
Return
       
// **********************************************************
// *** Funcao chamada pelo botao OK na tela inicial de processamento

Static Function OkLeTxt()

// *** Verifica vari�vel utilizada na pergunta.

cFile:= "c:\AP6IMPOR\FINPROV\"+Alltrim(Mv_Par01)+".TXT"

If 	Empty(Mv_Par01)
	MsgAlert("Parametros nao preenchidos !!! Verifique !","Atencao!")
	Return
EndIf

If 	Subs(Alltrim(Mv_Par01),1,2) <> SM0->M0_CODIGO
	MsgAlert("Arquivo a importar n�o corresponde a esta empresa !!! Verifique !","Atencao!")
	Return
EndIf

IF !ConvTxt(@cFile)
	MsgAlert("Arquivo "+cFile+" n�o encontrado !","Atencao!")
	RETURN
ENDIF

// *** Cria arquivo temporario

cArqVerba := CriaTrab(aVerba) 
dbUseArea( .T.,,cArqVerba,"TMP",.F. )

Append From (cFile) Delimited With ","
dbGoTop()

// *** Inicializa processamento

dbSelectArea("TMP")
DbGoTop()

// *** Verifica se o arquivo a ser importado � referente a esta rotina, ou seja,
// *** IMPORTA��O DE LAN�AMENTOS DE PROVISOES DE TITULOS A PAGAR.
// *** Caso n�o seja, ser� encerrada a rotina. 
// *** Obs.: a identifica��o � efetuada atrav�s do c�digo do Hist�rico vindo do TXT, 
// *** neste caso, o c�digo deve ser diferente de "0" (zero).

IF Alltrim(TMP->HP) == "0"
	MsgAlert("Arquivo a ser importado est� incorreto !!!")
	DBCLOSEAREA("TMP")
	Return
EndIf

// Busca o primeiro n�mero de Documento a ser utilizado.
cLote   := "009900"
cSbLote := "001"
nLin := 1
dDataLan := CTOD(SUBSTR(TMP->DATALAN,1,2)+'/'+SUBSTR(TMP->DATALAN,3,2)+'/'+SUBSTR(TMP->DATALAN,5,4))

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

// Inicia processamento.

dbSelectArea("TMP")
DbGoTop() 

ProcRegua(TMP->(Reccount()))
   
aLanc := {}
// aLanc := { "",0.0,"","","" }
// { DC,Valor,CCCred,CCDeb,CCusto }
  
While !Eof()

	IncProc("Efetuando importa��o...")
			
  	IF !Empty(TMP->CREDITO)

		dDataLan := CTOD(SUBSTR(TMP->DATALAN,1,2)+'/'+SUBSTR(TMP->DATALAN,3,2)+'/'+SUBSTR(TMP->DATALAN,5,4))
		// cMesAno  := SUBSTR(TMP->DATALAN,3,2)+SUBSTR(TMP->DATALAN,5,4)	
		
		// *** Verifica o tamanho do hist�rico e quantidade de linhas de
		// *** lan�amento por consequencia.
		cHist := ALLTRIM(TMP->HIST)        
		nNum := 0.0
		nNum := Round(Len(cHist)/40,1)
				             
		// *** Caso o numero de linhas encontrado seja quebrado, aumenta para o pr�ximo
		// *** n�mero inteiro.  	
		If Int(nNum) < nNum
			nNum := Int(nNum) + 1
		EndIf  

		// Prepara variavel de informa�ao sobre o lancamento
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
		
			// Verifica agora se ser� partida dobrada com C.Custo ou RATEIO.
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
			// Se for Situa�ao 2, vai buscar no registro de baixo o C.Custo.	   
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
    
    // Verifica se encontrou uma outra linha de credito. Se sim, dever� gravar o 
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
			CT2->CT2_VLR01  := aLanc[x][2]
			
			dbSelectArea("CT1")  

			//Subst�tui lancto reduzido pela conta cont�bil
			If !Empty(aLanc[x][3])
				DbSetOrder(2)
				Dbseek (xfilial()+(aLanc[x][3]))
				aLanc[x][3]:=CT1->CT1_CONTA     
			Endif
			//Subst�tui lancto reduzido pela conta cont�bil
			If !Empty(aLanc[x][4])
				DbSetOrder(2)
				Dbseek (xfilial()+(aLanc[x][4]))
				aLanc[x][4]:=CT1->CT1_CONTA 
			Endif
			
			dbSelectArea("CT2")  
			
			CT2->CT2_CREDIT := IF(aLanc[x][1]$"32",IF(!Empty(aLanc[x][3]),aLanc[x][3],"INFORMAR CONTA"),"")
			CT2->CT2_DEBITO := IF(aLanc[x][1]$"31",IF(!Empty(aLanc[x][4]),aLanc[x][4],"INFORMAR CONTA"),"")
			CT2->CT2_CCD    := aLanc[x][5]
   			CT2->CT2_HIST   := SUBSTR(cHist,1,40)       
			CT2->CT2_MOEDLC := "01"
			CT2->CT2_MOEDAS := "11111"        
			CT2->CT2_EMPORI := Substr(cNumEmp,1,2)
			CT2->CT2_FILORI := XFILIAL()
			CT2->CT2_TPSALD := "1"
			CT2->CT2_MANUAL := "1"
			CT2->CT2_AGLUT  := "2"
			CT2->CT2_LINHA  := STRZERO(nLin,3)
			CT2->CT2_ROTINA := "CSUCTB01"
			CT2->CT2_SEQHIS := "001"
			// CT2->CT2_MES := cMes
			MsUnLock()
						
			nLin := nLin + 1 

			// Grava hist�ricos complementares, caso seja necess�rio.			
			If  nNum > 1 
  		                  
		        // nNum    := nNum - 1 // desconsidera a a 1a. linha de lan�amento.              
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
					CT2->CT2_HIST   := SUBSTR(cHist,nPos,40)
					CT2->CT2_LINHA  := STRZERO(nLIN,3)
					CT2->CT2_MOEDLC := "01"            
					CT2->CT2_EMPORI := Substr(cNumEmp,1,2)
					CT2->CT2_FILORI := XFILIAL()
					CT2->CT2_TPSALD := "1"
					CT2->CT2_MANUAL := "1"
					CT2->CT2_AGLUT  := "2"
					CT2->CT2_SEQHIS := STRZERO(nSqHist,3) 
					CT2->CT2_ROTINA := "CSUCTB01"
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
// *** Fun��o de ajuste do TXT a ser importado.

Static Function ConvTxt(cTextName)
	PRIVATE lnHandle := 0
	lnHandle := FOPEN(cTextName)
	
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
	PRIVATE llEnd := .F.
	PRIVATE lcNewString := ""
	
	lnHndNew := FCREATE(cTextName + ".OK")
	
	cTextName := cTextName + ".OK"
	
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

RETURN .T.

// **********************************************************
// *** Fun��o de ajuste do TXT a ser importado.
Static Function LimpSema()
                   
cAlias := Alias()

DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial()+"Z1CSUFIN")

If Found() .and. !Empty(SX5->X5_DESCRI)
	RecLock("SX5",.f.)
	SX5->X5_DESCRI := " "
	MsUnLock()
EndIf

DbSelectArea(cAlias)

Return
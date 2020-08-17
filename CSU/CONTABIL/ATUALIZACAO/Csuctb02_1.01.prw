#INCLUDE "rwmake.ch"

// *** Rotina de importação via arquivo TXT que possui os lançamentos 
// *** contábeis referentes as baixas de titulos a pagar da CSU.

User Function CSUCTB02()
              
// *** Verifica se esta rotina já está sendo executada neste momento. Sem sim, 
// *** finaliza este processamento. Caso a tabela de controle (Semaforo) não 
// *** exista, será criada. 

DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial()+"Z1CSUFIN")

If Found() .and. !Empty(SX5->X5_DESCRI)
	MsgAlert("Esta rotina somente deve ser executada por uma única estação. No momento a mesma já encontra-se em uso. Tente novamente mais tarde !","Atencao!")
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
// *** Caso não exista será criada.
// *** mv_par01

_cPerg := PADR("ZZ0002" ,LEN(SX1->X1_GRUPO))

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

// *** Montagem da tela de Inicial de apresentação da rotina.

@ 200,1 TO 380,450 DIALOG oLeTxt TITLE OemToAnsi("Imp. de Lançamentos Contábeis ref. as Baixas de Contas a Pagar")
@ 02,10 TO 060,215
@ 10,018 Say " Esta rotina tem como objetivo a importação dos lançamentos contábeis ref."	SIZE 196,0
@ 18,018 Say " as baixas de Contas a Pagar. Esta importação será efetuada através de    "	SIZE 196,0
@ 26,018 Say " arquivo TXT gerado pelo sistema MÁXIMO. "									SIZE 196,0
@ 34,018 Say " IMPORTANTE: Após o término da importação em questão, é de suma           "	SIZE 196,0
@ 42,018 Say " importância a execução do REPROCESSAMENTO CONTÁBIL.             			"	SIZE 196,0

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 01 ACTION (Proctit(),close(oBase))
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

cFile:= "c:\AP6IMPOR\FINBX\"+Alltrim(Mv_Par01)+".TXT"

If 	Empty(Mv_Par01)
	MsgAlert("Parametros nao preenchidos !!! Verifique !","Atencao!")
	Return
EndIf

If 	Subs(Alltrim(Mv_Par01),1,2) <> SM0->M0_CODIGO
	MsgAlert("Arquivo a importar não corresponde a esta empresa !!! Verifique !","Atencao!")
	Return
EndIf

IF !ConvTxt(@cFile)
	MsgAlert("Arquivo "+cFile+" não encontrado !","Atencao!")
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

// *** Verifica se o arquivo a ser importado é referente a esta rotina, ou seja,
// *** IMPORTAÇÃO DE LANÇAMENTOS DE BAIXAS DE TITULOS A PAGAR.
// *** Caso não seja, será encerrada a rotina. 
// *** Obs.: a identificação é efetuada através do código do Histórico vindo do TXT, 
// *** neste caso, o código deve ser "0" (zero).

IF Alltrim(TMP->HP) == "001"
	MsgAlert("Arquivo a ser importado está incorreto !!!")   
	DBCLOSEAREA("TMP")
	Return
EndIf

// Busca o primeiro número de Documento a ser utilizado.
cLote := "009900"
cSbLote := "002"
dDataLan := CTOD(SUBSTR(TMP->DATALAN,1,2)+'/'+SUBSTR(TMP->DATALAN,3,2)+'/'+SUBSTR(TMP->DATALAN,5,2))
// cMes := Subs(TMP->DATALAN,3,2) 

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
   
While !Eof()

	IncProc("Efetuando importação...")
	           
	// *** Verifica o tamanho do histórico e quantidade de linhas de
	// *** lançamento por consequencia. 

	nNum := 0.0
	nNum := Round(Len(Alltrim(TMP->HIST)) / 40,1)
			             
	// *** Caso o numero de linhas encontrado seja quebrado, aumenta para o próximo
	// *** número inteiro.  	
	If Int(nNum) < nNum
		nNum := Int(nNum) + 1
	EndIf
	
	//If (nLin + nNum) >= 999
	
	//	cDoc := strzero(val(cDoc) + 1,6)
	//	nLin := 1

	//EndIf		

	DBSELECTAREA("CT2")
	RecLock("CT2",.T.)                 
     
	// cMesAno  := SUBSTR(TMP->DATALAN,3,2)+SUBSTR(TMP->DATALAN,5,4)	     
	dDataLan := CTOD(SUBSTR(TMP->DATALAN,1,2)+'/'+SUBSTR(TMP->DATALAN,3,2)+'/'+SUBSTR(TMP->DATALAN,5,2))
        
	CT2->CT2_FILIAL := XFILIAL()
	CT2->CT2_LOTE   := cLote
	CT2->CT2_DOC    := cDoc
	CT2->CT2_SBLOTE := cSbLote	
	CT2->CT2_DATA   := dDataLan

 	IF RTRIM(TMP->DEBITO) # "0" .AND. RTRIM(TMP->CREDITO) # "0"
		cDC:= "3"   // PARTIDA DOBRADA
	ELSEIF  RTRIM(TMP->DEBITO) # "0" .AND. RTRIM(TMP->CREDITO) == "0"          
		cDC := "1"   // DEBITO       
	ELSEIF RTRIM(TMP->DEBITO) == "0" .AND. RTRIM(TMP->CREDITO) # "0"          
		cDC := "2"   // CREDITO       
	ENDIF    
        
	CT2->CT2_DC := cDC

	IF TMP->DEBITO # "0"
		DBSELECTAREA("CT1")
		DBSETORDER(2)        
		DBSEEK(XFILIAL()+ALLTRIM(TMP->DEBITO),.T.)     
		CTADEB := CT1->CT1_CONTA
	ELSE                 
		CTADEB := SPACE(20)
	ENDIF
      
	IF TMP->CREDITO # "0"
		DBSELECTAREA("CT1")
		DBSETORDER(2)       
		DBSEEK(XFILIAL()+ALLTRIM(TMP->CREDITO),.T.)
		CTACRE := CT1->CT1_CONTA
	ELSE
		CTACRE:= SPACE(20)
	ENDIF
	
	CT2->CT2_DEBITO := IF(cDC$"31",IF(!Empty(CTADEB),CTADEB,"INFORMAR CONTA"),"")
	CT2->CT2_CREDIT := IF(cDC$"32",IF(!Empty(CTACRE),CTACRE,"INFORMAR CONTA"),"")
	CT2->CT2_VLR01  := TMP->VALOR       
	CT2->CT2_HP := ""
	CT2->CT2_MOEDLC := "01"
	CT2->CT2_MOEDAS := "11111"        
	CT2->CT2_EMPORI := Substr(cNumEmp,1,2)
	CT2->CT2_FILORI := XFILIAL()
	CT2->CT2_TPSALD := "1"
	CT2->CT2_MANUAL := "1"
	CT2->CT2_AGLUT  := "2"
	CT2->CT2_LINHA  := STRZERO(nLIN,3)
	CT2->CT2_ROTINA := "CSUCTB02"
	CT2->CT2_HIST   := SUBSTR(TMP->HIST,1,40)
	CT2->CT2_SEQHIS := "001"  
	//CT2->CT2_MES := cMes
	MsUnLock()
	
	nLin := nLin + 1               
    
	If  nNum > 1 
  		                  
        nNum := nNum - 1 // desconsidera a a 1a. linha de lançamento.              
		nPos := 41
		nSqHist := 2
	
		For x := 1 to nNum
		
			RecLock("CT2",.T.)                         
			CT2->CT2_FILIAL := XFILIAL()
			CT2->CT2_DATA   := dDataLan
			CT2->CT2_DC     := "4"     
			CT2->CT2_LOTE   := cLote
			CT2->CT2_DOC    := cDoc
			CT2->CT2_SBLOTE := cSbLote  
			CT2->CT2_HIST   := SUBSTR(TMP->HIST,nPos,40)
			CT2->CT2_LINHA  := STRZERO(nLIN,3)
			CT2->CT2_MOEDLC := "01"            
			CT2->CT2_EMPORI := Substr(cNumEmp,1,2)
			CT2->CT2_FILORI := XFILIAL()
			CT2->CT2_TPSALD := "1"
			CT2->CT2_MANUAL := "1"
			CT2->CT2_AGLUT  := "2"
			CT2->CT2_SEQHIS := STRZERO(nSqHist,3) 
			CT2->CT2_ROTINA := "CSUCTB02"
			//CT2->CT2_MES := cMes
			MsUnlock()      
	
			nPos   := nPos + 40
			nSqHist := nSqHist + 1
			nLin := nLin + 1 
		
		Next      
	
	EndIf                         
	
	// Após gravar lançamento anterior, busca o próximo numero de documento.
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
   
	dbSelectArea("TMP")
	dbSkip()                                    
		         
End                   

DBCLOSEAREA("TMP")

ALERT("TERMINO DA IMPORTACAO")

//Close(oLeTxt)

Return

// **********************************************************
// *** Função de ajuste do TXT a ser importado.

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
		
		// lcNewString := ALLTRIM(lcNewString)
		lnRead := lnRead + LEN(lcNewString)
		
		FWRITE(lnHndNew,lcNewString)
	ENDDO
	
	FCLOSE(lnHandle)
	FCLOSE(lnHndNew)

RETURN .T.

// **********************************************************
// *** Função de ajuste do TXT a ser importado.
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
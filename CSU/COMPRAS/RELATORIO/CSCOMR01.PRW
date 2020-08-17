#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSCOMR01 º Autor ³ Leonardo Soncin    º Data ³  24/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Aprovacao Diretoria                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CSU                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSCOMR01


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório para Aprovação da Presidencia e Diretoria Financeira"
Local cPict          := ""
Local titulo       := "Relatório para Aprovação da Presidencia e Diretoria Financeira"
Local nLin         := 80

Local Cabec1       := "Numero PC  DT Emissao         Vlr. Total    Contr.  Nome Fornecedor"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "CSCOMR01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := PADR("COMR01",LEN(SX1->X1_GRUPO))
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel      := "CSCOMR01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC7"

dbSelectArea("SC7")
dbSetOrder(1)

CriaSx1()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  24/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem     
Local aStru := dbStruct("SCR")
Local _cContr := Iif(MV_PAR05==1,"S","N")   
Local _cAprov := ""
Local _cAprov2 := ""
Local _nCount := 0    
Local _cPedido := ""
Local _cGrupoC := ""         
Local _nTotal := 0    
Local cMemoDesc := ""
Local cDescricao := ""     
Local lVolta := .T.

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

/*
_cQuery := " SELECT * "
_cQuery += " FROM "+RetSqlName("SC7")
_cQuery += " WHERE C7_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
_cQuery += " C7_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' AND "
_cQuery += " C7_TOTAL BETWEEN "+Str(MV_PAR06)+" AND "+Str(MV_PAR07)+" AND "
_cQuery += " C7_FORNECE BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' AND "
If MV_PAR05 <>  3
	_cQuery += " C7_NUMSC+C7_ITEMSC IN (SELECT C1_NUM+C1_ITEM FROM "+RetSqlName("SC1")+" WHERE C1_XCONT = '"+_cContr+"' AND D_E_L_E_T_ <> '*' ) AND "
Endif
_cQuery += " C7_APROV IN (SELECT AL_COD FROM "+RetSqlName("SAL")+" WHERE AL_APROV BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND D_E_L_E_T_ <> '*' ) AND "
_cQuery += " C7_CONAPRO = 'B' AND "                                         
_cQuery += " C7_NUM BETWEEN "+MV_PAR12+" AND "+MV_PAR13+" AND "
_cQuery += " D_E_L_E_T_  <> '*' "  
_cQuery += " ORDER BY C7_NUM, C7_ITEM "  
*/

_cQuery := " SELECT * "
_cQuery += " FROM "+RetSqlName("SCR")
_cQuery += " WHERE CR_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' AND "
_cQuery += " CR_TOTAL BETWEEN "+Str(MV_PAR06)+" AND "+Str(MV_PAR07)+" AND "
_cQuery += " CR_APROV BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND "      
_cQuery += " CR_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
_cQuery += " CR_TIPO = 'PC' AND "   
_cQuery += " CR_STATUS IN ('01','02') AND "                                                            
If MV_PAR05 <> 3
	_cQuery += " CR_NUM IN (SELECT C7_NUM FROM "+RetSqlName("SC7")+" WHERE C7_NUM = CR_NUM AND C7_XCONT = '"+_cContr+"' AND D_E_L_E_T_ <> '*') AND "     
Endif
_cQuery += " D_E_L_E_T_  <> '*' "  
_cQuery += " ORDER BY CR_NUM "  

_cQuery := ChangeQuery(_cQuery)

If Select('TRB') <> 0
	dbSelectArea("TRB")
	TRB->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"TRB", .F., .T.)  

For nX := 1 To Len(aStru)
	If aStru[nX][2]<>"C"
		TcSetField("TRB",aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX

dbGoTop()
While !EOF()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	         
	IncProc()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif     
	              
	        
	_cQuery := " SELECT SUM(C7_TOTAL) TOTAL "
	_cQuery += " FROM "+RetSqlName("SC7")
	_cQuery += " WHERE C7_NUM =  '"+Alltrim(TRB->CR_NUM)+"'  AND "
	_cQuery += " D_E_L_E_T_  <> '*' "  
	_cQuery := ChangeQuery(_cQuery)

	If Select('XC7') <> 0
		dbSelectArea("XC7")
		XC7->(DbCloseArea())
	EndIf

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"XC7", .F., .T.)         
	        
	dbSelectArea("SC7")	        
	
	_nTotal := XC7->TOTAL  
	
	// Posiciona no Pedido
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+Alltrim(TRB->CR_NUM))
	
	_cGrupoC := C7_APROV
		
	// Posiciona no Grupo de Aprovacao
	_cAprov := ""    
	_cAprov2 := ""
	_nCount := 0
	dbSelectArea("SAL")
	dbSetOrder(1)
	dbSeek(xFilial("SAL")+_cGrupoC) 
	While !Eof() .and. AL_FILIAL == xFilial("SAL") .AND. AL_COD == _cGrupoC  
		
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial("SAK")+SAL->AL_APROV)

    	If _nTotal >= SAK->AK_LIMMIN .AND. _nTotal <= AK_LIMMAX
    		_nCount += 1                                                   
    	
    		If _nCount > 4
	    		_cAprov2 += Alltrim(SAL->AL_NOME)+" / "    	       			
			Else
				_cAprov += Alltrim(SAL->AL_NOME)+" / "    	       			
    		Endif       
    		
    	Endif	
	              
		dbSelectArea("SAL")
		dbSkip()	
	Enddo       

	@nLin,00 PSAY SC7->C7_NUM
	@nLin,12 PSAY Dtoc(SC7->C7_EMISSAO)
//	@nLin,25 PSAY SC7->C7_DESCRI
	@nLin,25 PSAY _nTotal PICTURE PesqPict("SC7","C7_TOTAL")
	@nLin,45 PSAY Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_XCONT")
	@nLin,52 PSAY Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")	
	nLin := nLin + 2 // Avanca a linha de impressao	
	@nLin,000 PSAY "Aprovadores: "+Alltrim(_cAprov)    // Tratar  Substr e quebra de linha		
	If Len(_cAprov2) > 0                                                                       
		nLin := nLin + 1 // Avanca a linha de impressao			
		@nLin,000 PSAY Alltrim(_cAprov2)    // Tratar  Substr e quebra de linha			
	Endif
	nLin := nLin + 2 // Avanca a linha de impressao	
//	@nLin,000 PSAY "OBS.: "+Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_XJUSTIF")  
	
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pegar e imprimir campo Memo (Descricao).                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	  
	
	cMemoDesc := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_XJUSTIF")     //MSMM(ICG->ICG_CODOBJ)
	nTotalLin := MLCount(cMemoDesc)
	For nI := 1 To nTotalLin
	   	cDescricao := MemoLine(cMemoDesc,125,nI)
	   	If nI == 1
	       	@ nLin,000 PSAY "OBS.: "+AllTrim(cDescricao	)
		Else
			nLin++	
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			EndIf
	   	  	@ nLin,000 PSAY AllTrim(cDescricao	)
		EndIf							        	        
	Next nI
		
	nLin := nLin + 1  // Avanca a linha de impressao
 	@nLin,000 PSAY __PrtThinLine()                 
 	nLin := nLin + 1  // Avanca a linha de impressao
 	
	dbSelectArea("TRB")	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CriaSx1  º Autor ³ Leonardo Soncin    º Data ³  12/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria as perguntas no SX1 caso nao existam.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico - Greca Asfaltos                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaSx1()
Local nX := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Data emissao de:      ","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"02","Data emissao ate:     ","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"03","Pedido de:            ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SC7"})
aAdd(aReg,{cPerg,"04","Pedido ate:           ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SC7"})
aAdd(aReg,{cPerg,"05","Tem Contrato(S/N) de: ","mv_ch5","N", 1,0,0,"C","","mv_par05","Sim","","","Não","","","Ambos","","","","","","","",""})
aAdd(aReg,{cPerg,"06","Valor de:             ","mv_ch6","N",14,2,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"07","Valor ate:            ","mv_ch7","N",14,2,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"08","Aprovador de:         ","mv_ch8","C", 6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","SAK"})
aAdd(aReg,{cPerg,"09","Aprovador ate:        ","mv_ch9","C", 6,0,0,"G","","mv_par09","","","","","","","","","","","","","","","SAK"})
aAdd(aReg,{cPerg,"10","Fornecedor de:        ","mv_cha","C", 6,0,0,"G","","mv_par10","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"11","Fornecedor ate:       ","mv_chb","C", 6,0,0,"G","","mv_par11","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil

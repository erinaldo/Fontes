#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±  Funcao: RFINA13		Autor: Tatiana A. Barbosa	Data: 10/2011	       ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: 	Relatório de Movimento Diário c/ Rateio 	 			   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Uso:  CSU CardSystem S.A		- OS 1811/11		 				   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                                                	

User Function RFINA13

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informad§os pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Movimento Diário c/ Rateio"
Local nLin         := 80
Local Cabec1       := "  Data  	  DOC            Parc.	     Beneficiário	       Histórico                     	   		    Rateio	    Natureza	Desc. Natureza			Vr.Pago"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}                                     
Local cAliasSE5 := "TMP13"

Private aDbOrd       := {} 
Private aReg         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFINA13" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFINA13" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString
Private aIndexSE2	:= {}
Private cCondicao 	:= ""
PRIVATE bFiltraBrw 	:= {|| Nil}
Private cPerg 		:= PADR("RFIN13",LEN(SX1->X1_GRUPO))

dbSelectArea("SE5")
dbSetOrder(1)

//dbSelectArea(cString)
                                                                  
//+----------------------------------------------------------------------------
//| Apresenta o perguntas para o usuario
//+----------------------------------------------------------------------------

CriaSX1()

//+----------------------------------------------------------------------------
//| Monta tela de paramentos para usuario, se cancelar sair
//+----------------------------------------------------------------------------
If !Pergunte(cPerg,.T.)
	Return Nil
Endif

cString := "SELECT SE5.E5_DATA,SE5.E5_DOCUMEN,SE5.E5_BENEF,SE5.E5_NUMCHEQ,SE5.E5_RECPAG,SE5.E5_VALOR,SE5.E5_NATUREZ,SE5.E5_PREFIXO,SE5.E5_NUMERO,SE5.E5_PARCELA,SE5.E5_TIPO,SE5.E5_CLIFOR,SE5.E5_LOJA "
cString += " FROM "+RetSqlName('SE5')+" SE5 "
cString += " WHERE E5_FILIAL= '"+xFilial('SE5')+"' AND SE5.D_E_L_E_T_= ' ' "
cString += " AND SE5.E5_DATA>='"+DTOS(mv_par01)+"' AND SE5.E5_DATA<='"+DTOS(mv_par02)+"' "
cString += " AND SE5.E5_SITUACA<>'C' AND (SE5.E5_DOCUMEN<>'' OR SE5.E5_NUMCHEQ<>'')"
cString += " GROUP BY SE5.E5_DATA,SE5.E5_DOCUMEN,SE5.E5_BENEF,SE5.E5_NUMCHEQ,SE5.E5_RECPAG,SE5.E5_VALOR,SE5.E5_NATUREZ,SE5.E5_PREFIXO,SE5.E5_NUMERO,SE5.E5_PARCELA,SE5.E5_TIPO,SE5.E5_CLIFOR,SE5.E5_LOJA "  
cString += " ORDER BY SE5.E5_DATA,SE5.E5_DOCUMEN"  
cString := ChangeQuery(cString)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cString),cAliasSE5)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aOrd := RetOrd('SE5')

dbSelectArea("SE5")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cAliasSE5,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cAliasSE5)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)        

TMP13->( DbCloseArea() )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  22/02/07   º±±
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
Local nTotal := 0
Local lLock:=.F.
Local cAliasSEV := "TMPEV"   

DbSelectArea('SE5')

SE5->( DbSetOrder( aDbOrd[aReturn[8]][2] ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

TMP13->( dbGoTop() )
While !TMP13->( EOF() )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8       
			
		Endif

	If TMP13->E5_RECPAG == "P"
		dbSelectArea("SE2")
		dbSetOrder(1)    
		If SE2->(dbSeek(xFilial("SE2")+TMP13->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
			If SE2->E2_MULTNAT == "1"  
           	
				cString := "SELECT EV_PREFIXO,EV_NUM,EV_TIPO,EV_NATUREZ,EV_VALOR "
				cString += " FROM "+RetSqlName('SEV')+" SEV "
				cString += " WHERE EV_FILIAL= '"+xFilial('SEV')+"' AND D_E_L_E_T_= ' ' "
				cString += " AND EV_PREFIXO = '"+TMP13->E5_PREFIXO+ "' AND EV_NUM = '"+TMP13->E5_NUMERO+ "' AND EV_TIPO = '"+TMP13->E5_TIPO+ "' "
				cString := ChangeQuery(cString)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cString),cAliasSEV)


				TMPEV->( dbGoTop() )
				While !TMPEV->( EOF() )		
					@nLin,001 PSAY STOD(TMP13->E5_DATA)
					If TMP13->E5_NUMCHEQ <> '               '
						@nLin,011 PSAY "CH-" + SUBSTR(TMP13->E5_NUMCHEQ,1,14)
					Else
						@nLin,011 PSAY "BO-" + TMP13->E5_DOCUMEN
					EndIf                                                  
					@nLin,028 PSAY TMP13->E5_PARCELA
					@nLin,040 PSAY Substr(TMP13->E5_BENEF,1,23)
					@nLin,065 PSAY Substr(SE2->E2_HIST,1,60)
					@nLin,133 PSAY "S"
					@nLin,143 PSAY TMPEV->EV_NATUREZ  
					@nLin,160 PSAY POSICIONE("SED",1,xFilial('SEV')+TMPEV->EV_NATUREZ,"ED_DESCRIC")  
					@nLin,200 PSAY (-1)*(TMPEV->EV_VALOR) Picture PesqPict("SE5","E5_VALOR")   
					nLin := nLin + 1 // Avanca a linha de impressao
					
					TMPEV->( dbSkip() )
				EndDo   
				TMPEV->(dbCloseArea())
			Else
				@nLin,001 PSAY STOD(TMP13->E5_DATA)
				If TMP13->E5_NUMCHEQ <> '               '
					@nLin,011 PSAY "CH-" + SUBSTR(TMP13->E5_NUMCHEQ,1,14)
				Else
					@nLin,011 PSAY "BO-" + TMP13->E5_DOCUMEN
				EndIf                        
				@nLin,028 PSAY TMP13->E5_PARCELA				                          
				@nLin,040 PSAY Substr(TMP13->E5_BENEF,1,23)
				@nLin,065 PSAY Substr(SE2->E2_HIST,1,60)		
				@nLin,133 PSAY "N"
				@nLin,143 PSAY TMP13->E5_NATUREZ             
				@nLin,160 PSAY POSICIONE("SED",1,xFilial('SEV')+TMP13->E5_NATUREZ,"ED_DESCRIC")  
				@nLin,200 PSAY (-1)*(TMP13->E5_VALOR) Picture PesqPict("SE5","E5_VALOR")   
				nLin := nLin + 1 // Avanca a linha de impressao	  
			EndIf
			nTotal -= TMP13->E5_VALOR 
		Else
			@nLin,001 PSAY STOD(TMP13->E5_DATA)
			If TMP13->E5_NUMCHEQ <> '               '
				@nLin,011 PSAY "CH-" + SUBSTR(TMP13->E5_NUMCHEQ,1,14)
			Else
				@nLin,011 PSAY "BO-" + TMP13->E5_DOCUMEN
			EndIf                                                  
			@nLin,028 PSAY TMP13->E5_PARCELA
			@nLin,040 PSAY Substr(TMP13->E5_BENEF,1,23)
			@nLin,065 PSAY Substr(SE2->E2_HIST,1,60)
			@nLin,133 PSAY "N"			
			@nLin,143 PSAY TMP13->E5_NATUREZ                                                     
			@nLin,160 PSAY POSICIONE("SED",1,xFilial('SEV')+TMP13->E5_NATUREZ,"ED_DESCRIC")  
			@nLin,200 PSAY (-1)*(TMP13->E5_VALOR) Picture PesqPict("SE5","E5_VALOR")
			nTotal -= TMP13->E5_VALOR
			nLin := nLin + 1 // Avanca a linha de impressao
		EndIf		
	Else
		dbSelectArea("SE1")
		dbSetOrder(1)    
		If SE1->(dbSeek(xFilial("SE1")+TMP13->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)))		//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			@nLin,001 PSAY STOD(TMP13->E5_DATA)
			If TMP13->E5_NUMCHEQ <> ''
				@nLin,011 PSAY "CH-" + SUBSTR(TMP13->E5_NUMCHEQ,1,14)
			Else
				@nLin,011 PSAY "BO-" + TMP13->E5_DOCUMEN
			EndIf                                                  
			@nLin,028 PSAY TMP13->E5_PARCELA
			@nLin,040 PSAY Substr(TMP13->E5_BENEF,1,23)
			@nLin,065 PSAY Substr(SE1->E1_HIST,1,60)
			@nLin,133 PSAY "N"			
			@nLin,143 PSAY TMP13->E5_NATUREZ                                                 
			@nLin,160 PSAY POSICIONE("SED",1,xFilial('SEV')+TMP13->E5_NATUREZ,"ED_DESCRIC")  
			@nLin,200 PSAY TMP13->E5_VALOR Picture PesqPict("SE5","E5_VALOR")
			nTotal += TMP13->E5_VALOR
			nLin := nLin + 1 // Avanca a linha de impressao
		Else
			@nLin,001 PSAY STOD(TMP13->E5_DATA)
			If TMP13->E5_NUMCHEQ <> '               '
				@nLin,011 PSAY "CH-" + SUBSTR(TMP13->E5_NUMCHEQ,1,14)
			Else
				@nLin,011 PSAY "BO-" + TMP13->E5_DOCUMEN
			EndIf                                                  
			@nLin,028 PSAY TMP13->E5_PARCELA
			@nLin,040 PSAY Substr(TMP13->E5_BENEF,1,23)
			@nLin,065 PSAY Substr(SE2->E2_HIST,1,60)
			@nLin,133 PSAY "N"			
			@nLin,143 PSAY TMP13->E5_NATUREZ
			@nLin,160 PSAY POSICIONE("SED",1,xFilial('SEV')+TMP13->E5_NATUREZ,"ED_DESCRIC")  
			@nLin,200 PSAY TMP13->E5_VALOR Picture PesqPict("SE5","E5_VALOR")
			nTotal += TMP13->E5_VALOR
			nLin := nLin + 1 // Avanca a linha de impressao
		EndIf	
	EndIf
				
	TMP13->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
    
EndDo                                                  
              
nLin := nLin + 1 // Avanca a linha de impressao
@nLin,001 PSAY "T O T A L    G E R A L :"
@nLin,200 PSAY nTotal Picture PesqPict("SE5","E5_VALOR")		

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
±±ºPrograma  ³ CriaSX1  º Autor ³ Leonardo S. Soncin º Data ³  05/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta de Titulos Liberados.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico - CSU                                           º±±
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

aAdd(aReg,{cPerg,"01","Data Inic.:  	     ","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""}) 
aAdd(aReg,{cPerg,"02","Data Fim:	         ","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})	
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

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ RetORd   º Autor ³ Sergio Oliveira    º Data ³  Fev/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Reetorna a descricao das ordens selecionadas.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rfina13.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetOrd( pcAlias )

Local aOrdem := {}

SIX->( DbSetOrder(1) )
SIX->( DbSeek("SE21") )  // Titulo

Aadd( aOrdem, SIX->DESCRICAO )
Aadd( aDbOrd, { 1,1 } )

SIX->( DbSeek("SE26") )  // Fornecedor

Aadd( aOrdem, SIX->DESCRICAO )
Aadd( aDbOrd, { 2,6 } )

SIX->( DbSeek("SE23") )  // Vencimento

Aadd( aOrdem, SIX->DESCRICAO )
Aadd( aDbOrd, { 3,3 } )

SIX->( DbSeek("SE25") )  // Emissao

Aadd( aOrdem, SIX->DESCRICAO )
Aadd( aDbOrd, { 4,5 } )

Return( aOrdem )

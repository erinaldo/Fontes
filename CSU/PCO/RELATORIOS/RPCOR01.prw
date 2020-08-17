#INCLUDE "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCOR01     º Autor ³ AP6 IDE            º Data ³  28/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RPCOR01
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Aprovacoes pendentes"
Local cPict          := ""
Local titulo       := "Aprovacoes pendentes"
Local nLin         := 80

Local	Cabec1       := "Status                   Codigo Data      Hora      Detalhe  "
Local Cabec2       := "                         Cntg.  Solic.    Solic.             "
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RPCOR01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PADR("RPCO01",LEN(SX1->X1_GRUPO))
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RPCOR01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "ZU1"

dbSelectArea("ZU1")
AjustaSx1()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/03/06   º±±
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

Local nOrdem,i
Local aSx3Box     := RetSx3Box( Posicione("SX3", 2, "ZU1_STATUS", "X3CBox()" ),,, 1 )
Local cUserCNTG	:=	""

dbSelectArea(cString)

                               
cQuery	:=	" SELECT R_E_C_N_O_ RECNO FROM "+RetSqlName("ZU1")+" ZU1 "
cQuery	+=	" WHERE ZU1_FILIAL = '"+xFilial("ZU1")+"' AND "
cQuery	+=	" ZU1_USER BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
Do Case
Case mv_par03 == 1
	cQuery += " ZU1_STATUS = '02' AND "
Case mv_par03 == 2
	cQuery +=  " (ZU1_STATUS ='03' OR ZU1_STATUS='05') AND  "
Case mv_par03 == 3
	cQuery +=  " (ZU1_STATUS ='01' OR ZU1_STATUS='04') AND "
OtherWise
	cQuery +=  " ZU1_STATUS <> '01' AND "
EndCase
cQuery	+=	" D_E_L_E_T_ <>'*' "

cQuery	:=	ChangeQuery(cQuery)
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery),"QRYTRB", .F., .F. )
DbSelectArea("QRYTRB")
DbGoTop()
While !EOF()                 
	DbSelectArea('ZU1')
	DbGoTo(QRYTRB->RECNO)
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

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin	:=	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   Endif    

   If cUserCntg <> ZU1_USER
		nLin++
		If !Empty(cUserCntg)
			__PrtThinLine()
			nLin++
		Endif  
		PswOrder(1)
		PswSeek(ZU1_USER)          
	  	@nLin,001 PSAY 'Usuario :'+PswRet()[1][4]
 		cUserCntg := ZU1_USER
	
	   nLin++
   Endif                                                       
//   cDescStat  := Upper(AllTrim( aSx3Box[Ascan( aSx3Box, { |aBox| aBox[2] = ZU1_STATUS } )][3] ))
   Do Case
   	Case ZU1_STATUS=="01" 	
   		cDescStat:= "Bloq. p/ sist(nivel ant)" 
   	Case ZU1_STATUS=="03" 	
   		cDescStat:= "Aguardando Lib.do usuario"
   	Case ZU1_STATUS=="03" 	
   		cDescStat:= "Liberado pelo usuario"  
   	Case ZU1_STATUS=="04" 	
   		cDescStat:= "Cancelado"				 	
   	Case ZU1_STATUS=="05" 	
   		cDescStat:= "Liberado por outro usuario"
   	Case ZU1_STATUS=="06" 	
   		cDescStat:=  "Remanejada"               
   	OtherWise
		 	cDescStat :="Desconhecido" 
	EndCase
					//	 0123456789012345678901234567890123456789012345678901234567890123456789
//Cabec1       := "                         Codigo Data      Hora      Detalhe  "
//Cabec2       := "                         Cntg.  Solic.    Solic.             "
   @nLin,000 PSAY cDescStat
   @nLin,026 PSAY ZU1_CDCNTG
   @nLin,032 PSAY ZU1_DTSOLI
   @nLin,042 PSAY ZU1_HORA
   nLinhas	:=	MlCount(ZU1_MEMO,78)
   For i:= 1 To nLinhas              
		cLine	:=	MemoLine(ZU1_MEMO,78,i)
	   @nLin,52 PSAY cLine  	
		If !Empty(cLine)
	   	nLin++
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     		 	nLin	:=	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   		Endif    
      Endif 
	Next   
   nLin++
	DbSelectArea("QRYTRB")
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("QRYTRB")
DbCloseArea()
DbSelectArea("ZU1")


Return


Static Function AjustaSX1()
Local aHelpP01	:= {}
Local aHelpE01	:= {}
Local aHelpS01	:= {}                                                                      
DbSelectArea('SX1')
	

PutSx1('RPCO01','01','De Usuario?','De Usuario?','De Usuario?','mv_ch1','C'   , 06, 0, 0,'G','','USR'   ,'','','mv_par01','','','','','','','','','','','','','','','','',aHelpP01,aHelpE01,aHelpS01)
PutSx1('RPCO01','02','Ate Usuario?','Ate Usuario?','Ate Usuario?','mv_ch2','C', 06, 0, 0,'G','','USR'   ,'','','mv_par02','','','','','','','','','','','','','','','','',aHelpP01,aHelpE01,aHelpS01)

Aadd( aHelpP01, "Filtro para as contingencias            " )
Aadd( aHelpE01, "Filtro para as contingencias            " )
Aadd( aHelpS01, "Filtro para las contingencias           " )

PutSx1('RPCO01','03','Mostrar ?','Mostrar?','Show?','mv_ch3','N', 1, 0, 0,'C','',''   ,'','','mv_par03','Pendentes','Pendentes','Pendentes','','Aprovados','Aprovados','Aprovados','Bloqueados','Bloqueados','Bloqueados','Todos','Todos','Todos','','','',aHelpP01,aHelpE01,aHelpS01)



Return .T.

#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFINA12  � Autor � Leonardo S. Soncin � Data �  05/02/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Consulta de Titulos Liberados.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico - CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RFINA12

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "T�tulos Enviados p/ Pagamento"
Local nLin         := 80
Local Cabec1       := "Prf  Numero     Tp   Fornecedor                     Dt.Emissao   Dt.vencto.          Valor     Hist�rico                                                                                  Num. Relatorio      Dt. Relatorio"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}                                     
Local cAliasSE2 := "TMP12"

Private aDbOrd       := {} 
Private aReg         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFINA12" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFINA12" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString
Private aIndexSE2	:= {}
Private cCondicao 	:= ""
PRIVATE bFiltraBrw 	:= {|| Nil}
Private cPerg 		:= PADR("RFIN12",LEN(SX1->X1_GRUPO))


dbSelectArea("SE2")
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

cString := "SELECT E2_PREFIXO,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA,E2_EMISSAO,E2_VENCREA,E2_SALDO,E2_HIST,E2_XNUMREL,E2_XDATREL"
cString += " FROM "+RetSqlName('SE2')+" "
cString += " WHERE E2_FILIAL= '"+xFilial('SE2')+"' AND D_E_L_E_T_= ' ' "
cString += " AND E2_FORNECE>='"+mv_par03+"' AND E2_FORNECE<='"+mv_par04+"'"
cString += " AND E2_VENCREA>='"+DtoS(mv_par05)+"' AND E2_VENCREA<='"+DtoS(mv_par06)+"'"
cString += " AND E2_XDATREL>='"+DtoS(mv_par07)+"' AND E2_XDATREL<='"+DtoS(mv_par08)+"'"
cString += " AND E2_XNUMREL>='"+mv_par01+"' AND E2_XNUMREL<='"+mv_par02+"'"  
//cCondicao += '.And.E2_XCONF01<>"".AND.E2_XCONF03<>"" '
//cCondicao += '.And.E2_SALDO> 0 '
//cCondicao += '.And.Empty(E2_XDATREL) ' // CAMPO FLAG                       
cString += " ORDER BY E2_XNUMREL,E2_FILIAL,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA"
cString := ChangeQuery(cString)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cString),cAliasSE2)


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

aOrd := RetOrd('SE2')

dbSelectArea("SE2")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cAliasSE2,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cAliasSE2)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

TMP12->( DbCloseArea() )

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  22/02/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local nTotal := 0
Local lLock:=.F.
Local _cNumRel

DbSelectArea('SE2')

SE2->( DbSetOrder( aDbOrd[aReturn[8]][2] ) )

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

TMP12->( dbGoTop() )
While !TMP12->( EOF() )
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
			
	@nLin,001 PSAY TMP12->E2_PREFIXO                   
	@nLin,005 PSAY TMP12->E2_NUM                    
	@nLin,017 PSAY TMP12->E2_TIPO         //12           
	@nLin,021 PSAY TMP12->E2_FORNECE+" - "+Posicione("SA2",1,xFilial("SA2")+TMP12->E2_FORNECE+TMP12->E2_LOJA,"A2_NREDUZ")
	@nLin,055 PSAY StoD(TMP12->E2_EMISSAO)
	@nLin,065 PSAY StoD(TMP12->E2_VENCREA)
	@nLin,075 PSAY TMP12->E2_SALDO Picture PesqPict("SE2","E2_SALDO")		
	@nLin,100 PSAY Alltrim(TMP12->E2_HIST)
	@nLin,190 PSAY TMP12->E2_XNUMREL
	@nLin,210 PSAY StoD(TMP12->E2_XDATREL)
	nTotal += TMP12->E2_SALDO
	nLin := nLin + 1 // Avanca a linha de impressao
		
	TMP12->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo                                                  
              
nLin := nLin + 1 // Avanca a linha de impressao
@nLin,001 PSAY "Total Geral:"
@nLin,070 PSAY nTotal Picture PesqPict("SE2","E2_SALDO")		

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CriaSX1  � Autor � Leonardo S. Soncin � Data �  05/02/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Consulta de Titulos Liberados.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico - CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CriaSx1()

Local nX := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Relatorio de:          ","mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})   //Tatiana Barbosa - OS 3273/10
aAdd(aReg,{cPerg,"02","Relatorio ate:         ","mv_ch2","C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})	//Tatiana Barbosa - OS 3273/10
aAdd(aReg,{cPerg,"03","Fornecedor de:	      ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"04","Fornecedor ate:  	  ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"05","Dt. Vencimento de:  	  ","mv_ch5","D", 8,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"06","Dt. Vencimento ate:	  ","mv_ch6","D", 8,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"07","Dt. Relatorio de:      ","mv_ch7","D", 8,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"08","Dt. Relatorio at�:     ","mv_ch8","D", 8,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""})
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � RetORd   � Autor � Sergio Oliveira    � Data �  Fev/2008   ���
�������������������������������������������������������������������������͹��
���Descricao � Reetorna a descricao das ordens selecionadas.              ���
�������������������������������������������������������������������������͹��
���Uso       � Rfina12.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSCOMR10  � Autor � Renato Carlos      � Data �  03/07/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatroio de Pedidos Provados sem NF                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSCOMR10


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de pedidos aprovados sem nf."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Aprovados Sem NF"
Local nLin         := 80

Local Cabec1       := "Numero PC  DT Emissao  Vlr Total    Fornecedor                                 Cod. Usu�rio     Cod Solicitante         Nome Solicitante"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "CSCOMR10" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CSCOMR10" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC7"

dbSelectArea("SC7")
dbSetOrder(1)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  03/07/09   ���
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
Local c_Query

//dbSelectArea(cString)
//dbSetOrder(1) 

SetRegua(RecCount())

c_Query := ""
c_Query += "SELECT "
c_Query += "SC7.C7_NUM AS PEDIDO, "
c_Query += "SC7.C7_EMISSAO AS EMISSAO, "
c_Query += "SC7.C7_TOTAL AS TOTAL,  "
c_Query += "SA2.A2_NOME AS RAZAO, "
c_Query += "SC1.C1_USER AS USRSOLIC,"
c_Query += "SC1.C1_SOLICIT AS CODSOLICT, "
c_Query += "CASE WHEN SC7.C7_NUMSC = '' THEN "
c_Query +=	"	SC7.C7_USER                   "
c_Query += "ELSE "
c_Query += " SC1.C1_USER END AS SOLICITANTE "
c_Query += "FROM "+RetSqlName("SC7")+" AS SC7, "+RetSqlName("SA2")+" AS SA2, "+RetSqlName("SC1")+" AS SC1 "

c_Query += "WHERE SC7.C7_FORNECE = SA2.A2_COD "
c_Query += "AND SC7.C7_NUMSC *= SC1.C1_NUM "
c_Query += "AND SC7.C7_ITEMSC *= SC1.C1_ITEM "
c_Query += "AND	SC7.C7_ENCER <> 'E' "
c_Query += "AND SC7.C7_CONAPRO = 'L' "
c_Query += "AND SC7.C7_RESIDUO = ''  "
c_Query += "AND SC7.D_E_L_E_T_ = '' "
c_Query += "AND SC1.D_E_L_E_T_ = '' "
c_Query += "AND SA2.D_E_L_E_T_ = '' "

c_Query += "ORDER BY  SC7.C7_NUM  " 

If Select("TMP") > 0
	DBSelectArea("TMP")
	DBCloseArea()
EndIf

//���������������������������������������Ŀ
//� Cria alias conforme query de consulta �
//�����������������������������������������

//c_Query := ChangeQuery(c_Query)
dbUseArea(.T., "TOPCONN", TCGenQry(,,c_Query),"TMP", .F., .T.)

//dbSelectArea("TMP")
dbGoTop()

While !EOF()

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
   
	@ nLin,001 PSAY TMP->PEDIDO
	@ nLin,011 PSAY DTOC(STOD(TMP->EMISSAO)) 
	@ nLin,019 PSAY TMP->TOTAL PICTURE PesqPict(cString,"C7_TOTAL")
	@ nLin,036 PSAY LEFT(Alltrim(TMP->RAZAO),40)
	@ nLin,082 PSAY PADR(Alltrim(TMP->USRSOLIC),6)
	@ nLin,100 PSAY PADR(Alltrim(TMP->CODSOLICT),6)
	@ nLin,120 PSAY UsrFullName(TMP->SOLICITANTE)	

   	nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

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
TMP->(dbCloseArea())
Return

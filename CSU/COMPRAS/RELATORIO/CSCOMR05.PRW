#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSCOMR05  � Autor � Leonardo Soncin    � Data �  23/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Processos de Pagamentos Liberados                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CSU                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSCOMR05


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Protocolo de Processo de Pagamento"
Local cPict          := ""
Local titulo       	 := "Protocolo de Processo de Pagamento"
Local nLin         := 80

Local Cabec1       := "St  Prf Numero    Fornecedor            Valor         Dt Digita��o        Vencto"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "CSCOMR05" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PADR("COMR05",LEN(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CSCOMR05" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF1"

dbSelectArea("SF1")
dbSetOrder(1)

CriaSx1()
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  08/01/07   ���
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
Local _cQuery
Local aStru := SF1->(dbStruct())
Local cUsu	:= ""
Local cCodigo := "" 
Local cNome := "" 


dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

_cQuery := " SELECT * "
_cQuery += " FROM "+RetSqlName("SF1")
_cQuery += " WHERE F1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' AND "
_cQuery += " F1_FORNECE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
_cQuery += " F1_XVENCTO BETWEEN '"+Dtos(MV_PAR07)+"' AND '"+Dtos(MV_PAR08)+"' AND "
_cQuery += " F1_EMISSAO BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' AND "
_cQuery += " F1_DOC BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND "
_cQuery += " F1_SERIE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' AND "
_cQuery += " (F1_XCONF01 <> '' AND F1_XCONF02 <> '' AND F1_XCONF03 <> '') AND "
_cQuery += " D_E_L_E_T_  <> '*' "
_cQuery += " ORDER BY F1_FILIAL, F1_DOC, F1_SERIE "

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
	
	If nLin > 60 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
		
	// Filtra Usu�rio de Inclusao
	
	@nLin,000 PSAY TRB->F1_FILIAL
	@nLin,004 PSAY TRB->F1_SERIE
	@nLin,008 PSAY TRB->F1_DOC 
	@nLin,018 PSAY Substr(Posicione("SA2",1,xFilial("SA1")+TRB->F1_FORNECE+TRB->F1_LOJA,"A2_NOME"),1,15) 
	@nLin,035 PSAY TRB->F1_VALBRUT Picture PesqPict("SF1","F1_VALBRUT",14)
	@nLin,055 PSAY TRB->F1_DTDIGIT
	@nLin,070 PSAY TRB->F1_XVENCTO
		
	nLin := nLin + 1 // Avanca a linha de impressao
	
	dbSelectArea("TRB")
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

Return      

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xRetCUsr � Autor � Leonardo Soncin    � Data �  09/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna Codigo do Usuario                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico - CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
  
// Retorna Codigo de Usuario
Static Function xRetCUsr(cCodigo)
Local cAlias := Alias()
Local cSavOrd := IndexOrd()
Local cCodUser := CriaVar("AN_USER")

PswOrder(2)
If PswSeek(cCodigo)
	cCodUser := PswRet(1)[1][1]
EndIf
          
cCodUser := cCodUser            

dbSelectArea(cAlias)
dbSetOrder(cSavOrd)

Return cCodUser

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CriaSx1  � Autor � Leonardo Soncin    � Data �  12/04/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Cria as perguntas no SX1 caso nao existam.                 ���
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

aAdd(aReg,{cPerg,"01","Data digita��o de:    ","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"02","Data digita��o at�    ","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"03","Fornecedor de:        ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"04","Forncedor at�:        ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"05","Emissao de:           ","mv_ch5","D", 8,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"06","Emissao at�:          ","mv_ch6","D", 8,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"07","Vencimento de:        ","mv_ch7","D", 8,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"08","Vencimento at�:       ","mv_ch8","D", 8,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"09","Documento de:         ","mv_ch9","C", 6,0,0,"G","","mv_par09","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"10","Documento at�:        ","mv_chA","C", 6,0,0,"G","","mv_par10","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"11","Serie de:             ","mv_chB","C", 3,0,0,"G","","mv_par11","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"12","Serie at�:            ","mv_chC","C", 3,0,0,"G","","mv_par12","","","","","","","","","","","","","","",""})

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

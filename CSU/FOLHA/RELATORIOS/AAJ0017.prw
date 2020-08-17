#INCLUDE "rwmake.ch"
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AAJ0017  � Autor � Adalberto Althoff  � Data �  23/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de funcionarios afastados.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AAJ0017

//�������������������������Ŀ
//� Declaracao de Variaveis �
//���������������������������

Local cDesc1         := "Este programa ira gerar relat�rio onde ser� poss�vel"
Local cDesc2         := "visualizar e conferir os dados de afastamentos. �        "
Local cDesc3         := "baseado na data base do sistema.  "
Local cPict          := ""
Local titulo       := "Relat�rio de Afastados"
Local nLin         := 80

Local Cabec1       := "Fil  Matr    Nome                             C.Custo               Area                   Tipo Dt Afas   Dt Admissao    Insuf Deb"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {"Matr�cula","C.Custo","Admiss�o","Dt Afastamento","Tipo Afast"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "M"
Private nomeprog         := "AAJ0017"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PADR("AJ0017",LEN(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "AAJ0017"
Private TotFunc    := 0

Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)


ValidPerg(cPerg)

//������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...�
//��������������������������������������������

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  05/10/04   ���
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

//��������������������Ŀ
//� Query de consulta. �
//����������������������      

_cQuery := " SELECT	A.RA_FILIAL AS FILIAL, "        
_cQuery += " A.RA_MAT AS MATRICULA, " 
_cQuery += " Substring(A.RA_NOME,1,31) AS NOME,  "
_cQuery += " A.RA_CC AS CCUSTO,  "
_cQuery += " Substring(A.CTT_DESC01,1,23) AS AREA,  "
_cQuery += " A.R8_TIPO AS TIPO_AFAS,  "
_cQuery += " A.R8_DATAINI AS DT_AFAS,  "
_cQuery += " A.RA_ADMISSA AS DT_ADM,  "
_cQuery += " B.RC_VALOR AS INSUF_DEB  "               
_cQuery += " FROM ( "                            

_cQuery += " SELECT 	RA_FILIAL,  "
_cQuery += " RA_MAT,  "
_cQuery += " RA_NOME,  "
_cQuery += " RA_CC,  "
_cQuery += " CTT_DESC01,  "
_cQuery += " R8_TIPO,  "
_cQuery += " R8_DATAINI,  "
_cQuery += " RA_ADMISSA  "
_cQuery += " FROM "+RETSQLNAME("SRA")+","+RETSQLNAME("CTT")+","+RETSQLNAME("SR8")+" "
_cQuery += " WHERE RA_FILIAL between '" + MV_PAR01 + "' and '" + MV_PAR02 + "'  "
_cQuery += " and RA_MAT between '" + MV_PAR05 + "' and '" + MV_PAR06 + "' "
_cQuery += " and RA_CC between '" + MV_PAR03 + "' and '" + MV_PAR04 + "'  "
_cQuery += " and RA_SITFOLH <> 'D'  "
_cQuery += " and RA_CC = CTT_CUSTO "
_cQuery += " AND R8_DATAINI <= '" + dtos(dDataBase) +"'  "
_cQuery += " AND (R8_DATAFIM >= '" + dtos(dDataBase) +"' OR R8_DATAFIM='' ) "
_cQuery += " AND R8_FILIAL = RA_FILIAL  "
_cQuery += " AND R8_MAT = RA_MAT  "
_cQuery += " AND R8_TIPO <> 'F' "
_cQuery += " and "+RETSQLNAME("SRA")+".D_E_L_E_T_ <> '*' "
_cQuery += " and "+RETSQLNAME("SR8")+".D_E_L_E_T_ <> '*' "
_cQuery += " and "+RETSQLNAME("CTT")+".D_E_L_E_T_ <> '*' "

_cQuery += " ) AS A LEFT JOIN  "
_cQuery += " ( 	SELECT 	RC_FILIAL,  "
_cQuery += " RC_MAT,  "
_cQuery += " RC_VALOR  "
_cQuery += " FROM "+RETSQLNAME("SRC")+" WHERE RC_PD = '571'  "
_cQuery += " and D_E_L_E_T_ <> '*' "
_cQuery += " ) AS B "

_cQuery += " ON ( A.RA_FILIAL = B.RC_FILIAL AND A.RA_MAT = B.RC_MAT ) "

//������������������������������������������Ŀ
//� Define a ordem de impressao do relatorio.�
//��������������������������������������������

do case
	case aReturn[8] == 1
		_cQuery += " order by FILIAL,MATRICULA  "
	case aReturn[8] == 2
		_cQuery += " order by FILIAL,CCUSTO "
	case aReturn[8] == 3
		_cQuery += " order by FILIAL,DT_ADM "
	case aReturn[8] == 4
		_cQuery += " order by FILIAL,DT_AFAS "
	case aReturn[8] == 5
		_cQuery += " order by FILIAL,TIPO_AFAS "
EndCase
                       
//�������������������������������������Ŀ
//� Verifica se nao esta aberto o alias �
//���������������������������������������


If Select("TR0017") >0
	DBSelectArea("TR0017")
	DBCloseArea()
EndIf

//���������������������������������������Ŀ
//� Cria alias conforme query de consulta �
//�����������������������������������������

_cquery := changequery(_cquery)
TCQUERY _cQuery  NEW ALIAS "TR0017"

dbSelectArea("TR0017")

DO WHILE !EOF()
	
	//�����������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario... �
	//�������������������������������������������
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//��������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .   �
	//����������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	//������������������Ŀ
	//� Linha de detalhe �
	//��������������������
	@ nlin,001 psay FILIAL + "  " + MATRICULA + "  " + NOME + "  " + CCUSTO + "  " + AREA + "  " + TIPO_AFAS + "  " + dtoc(stod(DT_AFAS)) + "  " + dtoc(stod(DT_ADM))
	@ nlin,120 psay TRANSFORM(INSUF_DEB,"@E 999,999.99")
	nLin := nLin + 1 // Avanca a linha de impressao     
	
	TotFunc++
	
	DBSKIP()
	
ENDDO

@ nlin+2,001 psay TRANSFORM(totfunc,"@E 999,999") + " Funcionarios afastados em " +dtoc(dDataBase)


//�������������������������������������Ŀ
//� Finaliza a execucao do relatorio... �
//���������������������������������������

SET DEVICE TO SCREEN

//������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao... �
//��������������������������������������������������������������

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
���Fun��o    � VALIDPERG� Autor � Adalberto Althoff  � Data �  05/10/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar, VALIDADA PARA AP7                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Filial De       ","","","mv_ch1","C",02,0,0,"G","            ","mv_par01","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"02","Filial Ate      ","","","mv_ch2","C",02,0,0,"G","            ","mv_par02","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"03","C Custo De      ","","","mv_ch3","C",20,0,0,"G","            ","mv_par03","         ","","","","","         ","","","","","","","","","","","","","","","","","","","CTT","","","          "})
aAdd(aRegs,{_cPerg,"04","C Custo Ate     ","","","mv_ch4","C",20,0,0,"G","            ","mv_par04","         ","","","","","         ","","","","","","","","","","","","","","","","","","","CTT","","","          "})
aAdd(aRegs,{_cPerg,"05","Matricula De    ","","","mv_ch5","C",06,0,0,"G","            ","mv_par05","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SRA","","","          "})
aAdd(aRegs,{_cPerg,"06","Matricula Ate   ","","","mv_ch6","C",06,0,0,"G","            ","mv_par06","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SRA","","","          "})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)     //RESERVA DENTRO DO BANCO DE PERGUNTAS
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()    //SALVA O CONTEUDO DO ARRAY NO BANCO
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return

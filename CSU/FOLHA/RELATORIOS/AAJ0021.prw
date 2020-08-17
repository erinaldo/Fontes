#INCLUDE "rwmake.ch"
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AAJ0021  � Autor � Adalberto Althoff  � Data �  24/01/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Protocolo de consulta de CPF no sistema                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AAJ0021

//�������������������������Ŀ
//� Declaracao de Variaveis �
//���������������������������

Local cDesc1         := "Este programa ira gerar um protocolo de consulta de "
Local cDesc2         := "CPF no cadastro de funcion�rios.                  "
Local cDesc3         := "                                  "
Local cPict          := ""
Local titulo         := "Protocolo de CPF"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {"CPF"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "AAJ0021"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := PADR("AJ0021",LEN(SX1->X1_GRUPO))
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "AAJ0021"

Private cString      := "SRA"

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  24/01/05   ���
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

_cQuery := " select RA_FILIAL,RA_MAT,RA_NOME "
_cQuery += " from "+RETSQLNAME("SRA")+" "
_cQuery += " WHERE RA_CIC = '" + MV_PAR01 + "'"


If Select("TR0021") >0
	DBSelectArea("TR0021")
	DBCloseArea()
EndIf

//���������������������������������������Ŀ
//� Cria alias conforme query de consulta �
//�����������������������������������������

TCQUERY _cQuery NEW ALIAS "TR0021"
dbSelectArea("TR0021")

dbgotop()

//��������������������������������������������Ŀ
//� Impressao do cabecalho do relatorio. . .   �
//����������������������������������������������
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 18
Endif

if eof()
	@ nlin  ,1 psay padc("CPF Pesquisado: " + subs(mv_par01,1,3)+"."+subs(mv_par01,4,3)+"."+subs(mv_par01,7,3)+"-"+subs(mv_par01,10,2),78)
	@ nlin+3,1 psay padc("O CPF foi pesquisado na base de dados e nao foi encontrado.",78)
	@ nlin+5,1 psay padc("Candidato PODE ser contratado normalmente.",78)	
else
	@ nlin-7,1 psay padc("*******************************************************",78)
	@ nlin-6,1 psay padc("*** * ***  CANDIDATO NAO DEVE SER CONTRATADO  *** * ***",78)
	@ nlin-5,1 psay padc("*******************************************************",78)
	@ nlin  ,1 psay padc("CPF Pesquisado: " + subs(mv_par01,1,3)+"."+subs(mv_par01,4,3)+"."+subs(mv_par01,7,3)+"-"+subs(mv_par01,10,2),78)
	@ nlin+3,1 psay padc("O CPF foi pesquisado na base de dados e foi encontrado:",78)
	
	nlin+=5
	
	do while !eof()
		@ nlin,1 psay padc("Filial: " + ra_filial + " Matricula: " +ra_mat + " Nome: " +alltrim(ra_nome),78)
		nlin++
		dbskip()
	enddo
	
	@ nlin+5,1 psay padc("CANDIDATO NAO DEVE SER CONTRATADO",78)
endif	

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
���Fun��o    � VALIDPERG� Autor � Adalberto Althoff  � Data �  24/01/05   ���
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
aRegs  :={}

aAdd(aRegs,{_cPerg,"01","CPF a consultar ","","","mv_ch1","C",11,0,0,"G","CHKCPF(MV_PAR01)","mv_par01","            ","","","","","             ","","","","","     ","","","","","","","","","","","","","","   ","","","          "})

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



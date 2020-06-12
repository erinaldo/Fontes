#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBDIR03   �Autor  �Emerson Natali      � Data �  09/21/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relacao dos Contatos Selecionados na Validacao             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CBDIR03()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local titulo  := "Relacao dos Contatos Selecionados na Validacao"
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := ""
Local nLin    := 80
Local Cabec1  := " Contator   Nome                            Endereco                        Entidade   Nome                            Grupo                           Cargo                           Tratamento"
Local Cabec2  := ""

Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "CBDIR03"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CBDIR03"
Private cString     := "SZ0"
Private cPerg       := "CBDIR3"

dbSelectArea("SZ0")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

pergunte(cperg,.F.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  21/09/06   ���
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

dbSelectArea("SZ0") 
dbGotop()

Do While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @ nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 58 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
/*       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
 Contator   Nome                            Endereco                        Entidade   Nome                            Grupo                           Cargo                           Tratamento
 xxxxxx     xxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxx     xxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*/

	Do Case
		Case marked(SZ0->Z0_OK)
			If Empty(SZ0->Z0_OK)
				@ nLin, 002 PSAY SZ0->Z0_CONTAT
				@ nLin, 013 PSAY SZ0->Z0_NOME
				@ nLin, 045 PSAY SZ0->Z0_END
				@ nLin, 077 PSAY SZ0->Z0_ENTID
				@ nLin, 088 PSAY SZ0->Z0_NOME1
				@ nLin, 120 PSAY SZ0->Z0_DESCR
				@ nLin, 152 PSAY SZ0->Z0_CARGO
				@ nLin, 184 PSAY SZ0->Z0_TRATAME
				nLin++
		    EndIf
		Case SZ0->Z0_OK == cMarca
				@ nLin, 002 PSAY SZ0->Z0_CONTAT
				@ nLin, 013 PSAY SZ0->Z0_NOME
				@ nLin, 045 PSAY SZ0->Z0_END
				@ nLin, 077 PSAY SZ0->Z0_ENTID
				@ nLin, 088 PSAY SZ0->Z0_NOME1
				@ nLin, 120 PSAY SZ0->Z0_DESCR
				@ nLin, 152 PSAY SZ0->Z0_CARGO
				@ nLin, 184 PSAY SZ0->Z0_TRATAMEN
				nLin++
	EndCase

	SZ0->(dbSKip())

EndDo

dbSelectArea("SZ0")
dbGotop()
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
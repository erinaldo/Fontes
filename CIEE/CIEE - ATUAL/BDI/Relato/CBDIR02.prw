#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBDIR02   �Autor  �Emerson Natali      � Data �  09/21/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relacao de Enderecos de um Contato                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CBDIR02()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local titulo  := ""
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := ""
Local nLin    := 80
Local Cabec1  := ""
Local Cabec2  := ""

Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "CBDIR02"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CBDIR02"
Private cString     := "SU5"
Private cPerg       := "CBDIR2"

//_fCriaSX1() // Verifica as perguntas e cria caso seja necessario

dbSelectArea("SU5")
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

Local nOrdem

cQuery  := "SELECT ZS_ITEM AS ITEM ,ZS_CODCONT AS CONTATO ,ZS_CODENT AS ENTIDADE "
cQuery  += " FROM "+RetSQLname('SZS')+" SZS "
cQuery  += " WHERE SZS.D_E_L_E_T_ <> '*' "
cQuery  += " AND ZS_CODCONT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery  += " AND ZS_CODCONT <> ''"
cQuery  += " UNION
cQuery  += " SELECT ZT_ITEM AS ITEM ,ZT_CODCONT AS CONTATO ,ZT_CODENT AS ENTIDADE "
cQuery  += " FROM "+RetSQLname('SZT')+" SZT "
cQuery  += " WHERE SZT.D_E_L_E_T_ <> '*' "
cQuery  += " AND ZT_CODCONT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery  += " AND ZT_CODENT  BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery  += " ORDER BY CONTATO, ENTIDADE, ITEM "
TcQuery cQuery New Alias "TMP"

dbSelectArea("TMP")
dbGotop()

_cContato  := TMP-> CONTATO
lFirst     := .T.

While !EOF()

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
 Tp Endereco  Endereco                                                     Bairro                         Municipio                      Est   CEP      Fone      Fone2      Fax    Entidade
 xxxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx  99999999 9999-9999 9999-9999 9999-9999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

*/
	DbSelectArea("SU5")
	DbSetOrder(1)
	If DbSeek(xFilial("SU5")+TMP->CONTATO)
		_cNome := SU5->U5_CONTAT
	Else
		_cNome := ""
	EndIf
	
	If _cContato <> TMP->CONTATO
		nLin++
		@ nLin, 000 PSAY __PrtThinLine()
		nLin++
		nLin++
		@ nLin, 002 PSAY "Nome: " + _cNome
		nLin++
		nLin++
		_cContato  := TMP->CONTATO
	EndIf

	DbSelectArea("SZS")
	If EMPTY(TMP->ENTIDADE)
		DbSetOrder(1)
		DbSeek(xFilial("SZS")+"F"+TMP->CONTATO+TMP->ITEM)
	Else
		DbSetOrder(2)
		DbSeek(xFilial("SZS")+"J"+TMP->ENTIDADE+TMP->ITEM)
	EndIf	

	If lFirst
		lFirst     := .F.
		@ nLin, 002 PSAY "Nome: " + _cNome
		nLin++
		nLin++
	EndIf

	@ nLin, 002 PSAY IIf(SZS->ZS_TIPOEND=="1","Residencial","Comercial")
	@ nLin, 015 PSAY SZS->ZS_END
	@ nLin, 076 PSAY SZS->ZS_BAIRRO
	@ nLin, 107 PSAY SZS->ZS_MUN
	@ nLin, 138 PSAY SZS->ZS_EST
	@ nLin, 142 PSAY SZS->ZS_CEP     picture "@E 99999999"
	@ nLin, 151 PSAY SZS->ZS_FONE    picture "@E 99999999"
	@ nLin, 161 PSAY SZS->ZS_FCOM1   picture "@E 99999999"
	@ nLin, 171 PSAY SZS->ZS_FAX     picture "@E 99999999"
	@ nLin, 181 PSAY SUBSTR(SZS->ZS_NOMENT,1,35)

	nLin++
	
	DbSelectArea("TMP")
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SX1       �Autor  �Microsiga           � Data �  08/03/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Parametros da rotina                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,6)

/*
             grupo ,ordem,pergunt       ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01,defspa01,defeng01,cnt01,var02,def02,defspa02,defeng02,cnt02,var03,def03,defspa03,defeng03,cnt03,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Contato De  ","      ","       ","mv_ch1","C" ,06 ,00 ,0  ,"G",""   ,"mv_par01",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SU5","","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Contato Ate ","      ","       ","mv_ch2","C" ,06 ,00 ,0  ,"G",""   ,"mv_par02",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SU5","","","","@!"})
aAdd(aRegs,{cPerg  ,"03" ,"Entidade De ","      ","       ","mv_ch3","C" ,06 ,00 ,0  ,"G",""   ,"mv_par03",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SZM","","","","@!"})
aAdd(aRegs,{cPerg  ,"04" ,"Entidade Ate","      ","       ","mv_ch4","C" ,06 ,00 ,0  ,"G",""   ,"mv_par04",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SZM","","","","@!"})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return
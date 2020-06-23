#INCLUDE "rwmake.ch"

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������



USER FUNCTION CFINR019()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle de Saldos das Irregularidades Apuradas no RDR"
Local cPict          := ""
Local titulo       := "Controle de Saldos das Irregularidades Apuradas no RDR"
Local Cabec1       := "Data Orig. Data Reg. Convenio         Empresa                               Valor BA        Valor CI    Documento            Total"
//    99/99/99   99/99/99  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999.999.999,99  999.999.999,99   XXXXXXXXXX   999.999.999,99
//             1         2         3         4         5         6         7         8         9         0         1         2         3         4
//    12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "CFINR19" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CFIN27    "
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CFINR19" // Coloque aqui o nome do arquivo usado para impressao em disco
Private nLin         := 80
Private cString := "SZC"

dbSelectArea("SZC")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.T.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

QZC->(DBCLOSEAREA())

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/09/04   ���
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
Local _cFL := CHR(13)+CHR(10)

Private	_nTotBA  :=0
Private	_nTotCI  :=0
Private	_nTotMov :=0
Private _nTotRB := 0
Private	_nTotRC:=0
Private	_nTotRT:=0



dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

_cQuery:= " SELECT * FROM "+RetSqlName("SZC")+"  "+_cFL
_cQuery+= " WHERE D_E_L_E_T_ <> '*' AND ZC_CONV BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+_cFL
_cQuery+= " AND ZC_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' "+_cFL
_cQuery+= " AND '"+Dtos(MV_PAR02)+"' "+_cFL
_cQuery+= " AND ZC_PREFIXO IN ('SBA','SEC','IRR')  "+_cFL
_cQuery+= " AND ZC_REGULAR = 'N'  "+_cFL
Do Case
	Case MV_PAR06 == 2 //   Abertos
		_cQuery+= " AND ZC_BAIXA = ' ' AND ZC_NUM = ' ' "+_cFL
	Case MV_PAR06 == 3  // Parciais
		_cQuery+= " AND ZC_BAIXA = ' ' AND ZC_NUM <> ' ' "+_cFL
	Case MV_PAR06 == 4  // Regularizados
		_cQuery+= " AND ZC_BAIXA <> ' ' AND ZC_NUM <> ' ' "+_cFL
EndCase
_cQuery+= " ORDER BY ZC_FILIAL,ZC_CONV,ZC_EMISSAO "+_cFL
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'QZC',.T.,.T.)


QZC->(dbGoTop())
While !QZC->(EOF())
	
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
	_nTotBA  :=0
	_nTotCI  :=0
	_nTotMov :=0
	_nTotRB := 0
	_nTotRC:=0
	_nTotRT:=0
	_cConv := QZC->ZC_CONV
	
	While xFILIAL("SZC")+_cConv == QZC->ZC_FILIAL+QZC->ZC_CONV
		_cNum := QZC->ZC_NUM
		
		//   "Data Orig. Data Reg. Convenio         Empresa                               Valor BA        Valor CI    Documento            Total"
		//    99/99/99   99/99/99  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999.999.999,99  999.999.999,99   XXXXXXXXXX   999.999.999,99
		//              1         2         3         4         5         6         7         8         9         0         1         2         3         4
		//     12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		
		@nLin,001 PSAY CTOD(SUBS(QZC->ZC_EMISSAO,7,2)+"/"+SUBS(QZC->ZC_EMISSAO,5,2)+"/"+SUBS(QZC->ZC_EMISSAO,1,4))
		@nLin,022 PSAY QZC->ZC_CONV
		@nLin,039 PSAY QZC->ZC_EMPRESA
		@nLin,071 PSAY QZC->ZC_VALORB  Picture "@EZ 999,999,999.99"
		@nLin,087 PSAY QZC->ZC_VALORC  Picture "@EZ 999,999,999.99"
		@nLin,117 PSAY QZC->ZC_VALORT  Picture "@EZ 999,999,999.99"
		nLin := nLin + 1 // Avanca a linha de impressao
		DbSelectArea("SZJ")
		SZJ->(DbSetOrder(3))
		SZJ->(DbSeek(xFilial("SZJ")+QZC->ZC_NUM))
		While (xFilial("SZJ")+_cNum) ==  (SZJ->ZJ_FILIAL+SZJ->ZJ_NUM)
			If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			//   "Data Orig. Data Reg. Convenio         Empresa                               Valor BA        Valor CI    Documento            Total"
			//    99/99/99   99/99/99  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999.999.999,99  999.999.999,99   XXXXXXXXXX   999.999.999,99
			//              1         2         3         4         5         6         7         8         9         0         1         2         3         4
			//     12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			
			@nLin,001 PSAY CTOD(SUBS(QZC->ZC_EMISSAO,7,2)+"/"+SUBS(QZC->ZC_EMISSAO,5,2)+"/"+SUBS(QZC->ZC_EMISSAO,1,4))
			@nLin,012 PSAY SZJ->ZJ_DATAMOV
			@nLin,022 PSAY QZC->ZC_CONV
			@nLin,039 PSAY QZC->ZC_EMPRESA
			@nLin,071 PSAY SZJ->ZJ_VALORBA  Picture "@EZ 999,999,999.99"
			@nLin,087 PSAY SZJ->ZJ_VALORCI  Picture "@EZ 999,999,999.99"
			@nLin,104 PSAY SZJ->ZJ_DOCMOV
			@nLin,117 PSAY SZJ->ZJ_TOTMOV   Picture "@EZ 999,999,999.99"
			//        Detalhes() // Chamada dos Detalhes dos Itens
			nLin := nLin + 1 // Avanca a linha de impressao
			_nTotBA  +=SZJ->ZJ_VALORBA
			_nTotCI  +=SZJ->ZJ_VALORCI
			_nTotMov +=SZJ->ZJ_TOTMOV
			SZJ->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		End
		_nTotRB +=QZC->ZC_VALORB
		_nTotRC +=QZC->ZC_VALORC
		_nTotRT +=QZC->ZC_VALORT
		QZC->(DbSkip())
	End
	nLin=nLin + 1
	@nLin,020 PSAY "Total  ------->"
	@nLin,071 PSAY ((_nTotRB)+(_nTotBA))  Picture "@EZ 999,999,999.99"
	@nLin,087 PSAY ((_nTotRC)+(_nTotCI))  Picture "@EZ 999,999,999.99"
	@nLin,117 PSAY ((_nTotRT)+(_nTotMov)) Picture "@EZ 999,999,999.99"
	nLin=nLin + 1
	@nLin,001 PSAY Replicate("-",132)
	nLin=nLin + 1
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
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  11/05/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


Static Function Detalhes()



//   "          Data Mov    Documento          Valor Ba         Valor  CI               Total                                                                  "
//              99/99/99   XXXXXXXXXX    999.999.999,99    999.999.999,99      999.999.999,99
//
//             1         2         3         4         5         6         7         8         9         0
//     12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567



@nLin,010 PSAY SZJ->ZJ_DATAMOV
@nLin,022 PSAY SZJ->ZJ_DOCMOV
@nLin,036 PSAY SZJ->ZJ_VALORBA  Picture "@EZ 999,999,999.99"
@nLin,054 PSAY SZJ->ZJ_VALORCI  Picture "@EZ 999,999,999.99"
@nLin,074 PSAY SZJ->ZJ_TOTMOV   Picture "@EZ 999,999,999.99"


Return



Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//          Grupo/Ordem/Pergunta             /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data de    ?","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data ate   ?","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Convenio De  ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Convenio Ate ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Tipo       ?","","","mv_ch5","C",1,0,0,"C","","mv_par05","Analitico","Sintetico","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Diferencas ?","","","mv_ch5","C",1,0,0,"C","","mv_par06","Todos","Abertos","Parciais","Regularizados","","","","","","","","","","",""})



For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
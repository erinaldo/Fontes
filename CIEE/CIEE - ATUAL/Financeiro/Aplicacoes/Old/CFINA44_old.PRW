#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA44   � Autor � Emerson Natali     � Data �  28/05/2008 ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Rendimentos da Reserva Financeira             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFINA44()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= "Rendimento da Reserva Financeira"
Local cPict 	:= ""
Local titulo 	:= "Rendimento da Reserva Financeira " + Str(Year(dDataBase),4)
Local nLin 		:= 80
Local Cabec1 	:= OemToAnsi("Mes          Rendimentos       (Resgate)       Aplica��o     Saldo Final")
Local Cabec2 	:= ""

Private lAbortPrint 	:= .F.
Private limite 			:= 80
Private tamanho 		:= "P"
Private nomeprog 		:= "CFINA44"
Private nTipo 			:= 18
Private aReturn 		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 		:= 0
Private m_pag 			:= 01
Private wnrel 			:= "CFINA44"

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint("SE5",NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"SE5")

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  28/05/08   ���
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

_aMeses	:=	{	{01, "Janeiro"		,0,0,0,0},;
				{02, "Fevereiro"	,0,0,0,0},;
				{03, "Marco"		,0,0,0,0},;
				{04, "Abril"		,0,0,0,0},;
				{05, "Maio"			,0,0,0,0},;
				{06, "Junho"		,0,0,0,0},;
				{07, "Julho"		,0,0,0,0},;
				{08, "Agosto"		,0,0,0,0},;
				{09, "Setembro"		,0,0,0,0},;
				{10, "Outubro"		,0,0,0,0},;
				{11, "Novembro"		,0,0,0,0},;
				{12, "Dezembro"		,0,0,0,0}}

/*
------------------------------------------------------------------------------------------------------------------------
MONTA QUERY PARA PEGAR VALOR DO RENDIMENTO (SE5)
------------------------------------------------------------------------------------------------------------------------
*/

_cQuery := "SELECT SUM(E5_VALOR) AS VALREND , MONTH(E5_DATA) AS MES "
_cQuery	+= "FROM " + RetSqlName("SE5")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND E5_MOEDA = 'RE' "
_cQuery += "AND E5_NATUREZ = '3.01.02' "
_cQuery += "AND E5_SITUACA = '' "
_cQuery += "AND YEAR(E5_DATA) = "+Str(Year(dDataBase),4)+" "
_cQuery += "GROUP BY MONTH(E5_DATA) "
_cQuery += "ORDER BY MONTH(E5_DATA) "
TCQUERY _cQuery ALIAS "TMPSE5" NEW

dbSelectArea("TMPSE5")
dbGoTop()
SetRegua(RecCount())

_nTotRend	:= 0

While !EOF()

   _nPos := ascan(_aMeses, {|x| x[1] == TMPSE5->MES})

   If _nPos > 0
      _aMeses[_nPos, 3] += TMPSE5->VALREND 		// Rendimento
   EndIf

   _nTotRend += TMPSE5->VALREND

   dbSkip()
EndDo

DbSelectArea("TMPSE5")
TMPSE5->(DbCloseArea())

/*
------------------------------------------------------------------------------------------------------------------------
MONTA QUERY PARA PEGAR SALDO FINAL (SZX)
------------------------------------------------------------------------------------------------------------------------
*/
_cQuery := "SELECT SUM(ZX_VLATU) AS VALREND , MONTH(ZX_DTFECH) AS MES "
_cQuery	+= "FROM " + RetSqlName("SZX")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND YEAR(ZX_DTFECH) = "+Str(Year(dDataBase),4)+" "
_cQuery += "GROUP BY MONTH(ZX_DTFECH) "
_cQuery += "ORDER BY MONTH(ZX_DTFECH) "
TCQUERY _cQuery ALIAS "TMPSZX" NEW

dbSelectArea("TMPSZX")
dbGoTop()
SetRegua(RecCount())

While !EOF()

   _nPos := ascan(_aMeses, {|x| x[1] == TMPSZX->MES})

   If _nPos > 0
      _aMeses[_nPos, 6] += TMPSZX->VALREND					// Saldo Final
   EndIf

   dbSkip()
EndDo

DbSelectArea("TMPSZX")
TMPSZX->(DbCloseArea())

/*
------------------------------------------------------------------------------------------------------------------------
MONTA SALDO ANO ANTERIOR
------------------------------------------------------------------------------------------------------------------------
*/
_cQuery	:= "SELECT MAX(ZX_DTFECH) ULT_DATA " //Ultima data do fechamento no mes
_cQuery	+= "FROM " + RetSqlName("SZX")+" "
_cQuery	+= "WHERE D_E_L_E_T_ = '' "
_cQuery	+= "AND ZX_DTFECH LIKE '"+Str(Year(dDataBase)-1,4)+"12%' "
TCQUERY _cQuery ALIAS "TMPDTATU" NEW

DbSelectArea("TMPDTATU")
If !EOF()
	_xDtUlt := TMPDTATU->ULT_DATA
Else
	_xDtUlt := ""
EndIf   

DbSelectArea("TMPDTATU")
TMPDTATU->(DbCloseArea())

_cQuery := "SELECT SUM(ZX_VLATU) AS VALREND , MONTH(ZX_DTFECH) AS MES "
_cQuery	+= "FROM " + RetSqlName("SZX")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND YEAR(ZX_DTFECH) = "+Str(Year(dDataBase)-1,4)+" "
_cQuery += "AND MONTH(ZX_DTFECH) = 12 "
_cQuery += "AND ZX_DTFECH = '"+_xDtUlt+"' "
_cQuery += "GROUP BY MONTH(ZX_DTFECH) "
_cQuery += "ORDER BY MONTH(ZX_DTFECH) "
TCQUERY _cQuery ALIAS "TMPSLD" NEW

dbSelectArea("TMPSLD")

If TMPSLD->VALREND > 0
	_nSalAnt	:= TMPSLD->VALREND
Else
	_nSalAnt	:= 0
EndIf

/*
------------------------------------------------------------------------------------------------------------------------
MONTA QUERY PARA PEGAR VALOR DE RESGATE OU APLICACAO (SE5)
------------------------------------------------------------------------------------------------------------------------
*/

_cQuery := "SELECT SUM(E5_VALOR) AS VALREND , MONTH(E5_DATA) AS MES, E5_RECPAG "
_cQuery	+= "FROM " + RetSqlName("SE5")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND (E5_MOEDA = 'RS' OR E5_MOEDA = 'RF') "
_cQuery += "AND (E5_NATUREZ = '5.01.01' OR E5_NATUREZ = '5.01.02')"
_cQuery += "AND (E5_TIPODOC <> 'TE' AND E5_TIPODOC <> 'CA')"
_cQuery += "AND E5_SITUACA = '' "
_cQuery += "AND YEAR(E5_DATA) = "+Str(Year(dDataBase),4)+" "
_cQuery += "GROUP BY MONTH(E5_DATA), E5_RECPAG "
_cQuery += "ORDER BY MONTH(E5_DATA) "
TCQUERY _cQuery ALIAS "TMPRP" NEW

dbSelectArea("TMPRP")
dbGoTop()
SetRegua(RecCount())

_nTotResg	:= 0
_nTotApli	:= 0

While !EOF()

   _nPos := ascan(_aMeses, {|x| x[1] == TMPRP->MES})

   If _nPos > 0
      _aMeses[_nPos, 4] += Iif(TMPRP->E5_RECPAG=="R",TMPRP->VALREND,0) 		// Resgate
      _aMeses[_nPos, 5] += Iif(TMPRP->E5_RECPAG=="P",TMPRP->VALREND,0) 		// Aplicacao
   EndIf

   _nTotResg += Iif(TMPRP->E5_RECPAG=="R",TMPRP->VALREND,0)
   _nTotApli += Iif(TMPRP->E5_RECPAG=="P",TMPRP->VALREND,0)

   dbSkip()
EndDo

DbSelectArea("TMPRP")
TMPRP->(DbCloseArea())

/*
------------------------------------------------------------------------------------------------------------------------
INICIO DA IMPRESSAO
------------------------------------------------------------------------------------------------------------------------
*/

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8

@nLin,00 PSAY "SALDO ANTERIOR"
@nLin,60 PSAY _nSalAnt Picture "@E 99,999,999.99"		//Saldo Incial
nLin++

_nSalDia := _nSalAnt

For _nI := 1 to Len(_aMeses)
   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   @nLin,00 PSAY __PrtThinLine()
   nLin++
   @nLin,00 PSAY _aMeses[_nI, 2]								//Meses
   @nLin,12 PSAY _aMeses[_nI, 3] Picture "@E 99,999,999.99"		//Rendimento
   @nLin,28 PSAY _aMeses[_nI, 4] Picture "@E 99,999,999.99"		//Resgate
   @nLin,44 PSAY _aMeses[_nI, 5] Picture "@E 99,999,999.99"		//Aplicacao
	_nSalDia+=_aMeses[_nI, 3]-_aMeses[_nI, 4]+_aMeses[_nI, 5]

   @nLin,60 PSAY _nSalDia 		  Picture "@E 99,999,999.99"		//Saldo Final
   
/*
   @nLin,60 PSAY _aMeses[_nI, 6] Picture "@E 99,999,999.99"		//Saldo Final
*/

   nLin++

Next

@nLin,00 PSAY __PrtThinLine()
nLin++
nLin++
@nLin,00 PSAY "TOTAL"
@nLin,12 PSAY _nTotRend Picture "@E 99,999,999.99"		//Rendimento
@nLin,28 PSAY _nTotResg Picture "@E 99,999,999.99"		//Resgate
@nLin,44 PSAY _nTotApli Picture "@E 99,999,999.99"		//Aplicacao
nLin++

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
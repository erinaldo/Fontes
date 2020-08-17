#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AAJ0015  � Autor � Adalberto Althoff  � Data �  13/10/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera arquivo xls com dados de desconto da odontoprev       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AFD0001
//�������������������������Ŀ
//� Declaracao de Variaveis �
//���������������������������

Private cPerg       := PADR("ADF001",LEN(SX1->X1_GRUPO))
Private oGeraXls


ValidPerg(cPerg)

//������������������������������������Ŀ
//� Montagem da tela de processamento. �
//��������������������������������������

@ 200,1 TO 380,400 DIALOG oGeraXls TITLE OemToAnsi("Arquivo Excel Pedidos X NF's inclusas")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo no Excel conforme os para-     "
@ 18,018 Say " metros  definidos  pelo  usuario.                                 "
@ 26,018 Say "                                                                   "
@ 34,018 Say " .                                                                 "

@ 60,098 BMPBUTTON TYPE 01 ACTION OkGeraXls()
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oGeraXls)
@ 60,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraXls Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERAXLS� Autor � AP5 IDE            � Data �  13/10/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo XLS.                      ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraXls
//�������������������������������������Ŀ
//� Inicializa a regua de processamento �
//���������������������������������������

Local _cSelect  := ""

_cSelect += " SELECT SD1.D1_DOC AS DOCUMENTO, SD1.D1_COD AS PRODUTO, SD1.D1_UM AS UNID, SD1.D1_QUANT AS QTDE, SD1.D1_VUNIT AS VL_UNIT, SD1.D1_TOTAL AS VL_TOTAL, SD1.D1_NATFULL AS NATUREZA, SD1.D1_CC AS CCUSTO, SD1.D1_ITEMCTA AS UNIDNEG, SD1.D1_CLVL AS OPERAC, SD1.D1_XDTAQUI AS COMPET, SD1.D1_FORNECE AS FORNEC,SD1.D1_LOJA AS LOJA, SA2.A2_NOME AS NOME," 
_cSelect += " SUBSTRING(SD1.D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1.D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1.D1_EMISSAO,1,4) AS EMISSAO, SUBSTRING(SD1.D1_DTDIGIT,7,2)+'/'+SUBSTRING(SD1.D1_DTDIGIT,5,2)+'/'+SUBSTRING(SD1.D1_DTDIGIT,1,4) AS DTDIGIT, "
_cSelect += " SUBSTRING(SE2.E2_VENCREA,7,2)+'/'+SUBSTRING(SE2.E2_VENCREA,5,2)+'/'+SUBSTRING(SE2.E2_VENCREA,1,4) AS VENCREAL, SD1.D1_PEDIDO AS PEDIDO, SD1.D1_ITEMPC AS ITEMPC, SF1.F1_DADADIC AS HISTORICO " 
_cSelect += " FROM "+RetSqlName("SD1")+" SD1 ,"+RetSqlName("SE2")+" SE2 ,"+RetSqlName("SA2")+" SA2 ,"+RetSqlName("SF1")+" SF1 "
_cSelect +=  " WHERE SD1.D1_COD     BETWEEN '" +   MV_PAR01   +"' AND '"+   MV_PAR02   +"'"
_cSelect +=  " AND SD1.D1_NATFULL  BETWEEN  '"+   MV_PAR03   +"' AND '"+   MV_PAR04   +"'"
_cSelect +=  " AND SD1.D1_FORNECE   BETWEEN  '"+   MV_PAR05   +"' AND '"+   MV_PAR06   +"'"
_cSelect +=  " AND SD1.D1_EMISSAO   BETWEEN  '"+   DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08) +"'"
_cSelect +=  " AND SD1.D1_DTDIGIT   BETWEEN  '"+   DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10) +"'"
_cSelect +=  " AND SD1.D1_TIPO        <> 'D' "
_cSelect +=  " AND SD1.D_E_L_E_T_ = ' '  "
_cSelect +=  " AND SE2.E2_FILIAL  = '  '     "
_cSelect +=  " AND SE2.E2_FORNECE = SD1.D1_FORNECE "
_cSelect +=  " AND SE2.E2_LOJA    = SD1.D1_LOJA    "
_cSelect +=  " AND SE2.E2_NUM     = SD1.D1_DOC     "
_cSelect +=  " AND SE2.E2_ORIGEM  = 'MATA100'  "
_cSelect +=  " AND SE2.D_E_L_E_T_ = ' '    "
_cSelect +=  " AND SA2.A2_FILIAL  = '  '       "
_cSelect +=  " AND SA2.A2_COD     = SE2.E2_FORNECE "
_cSelect +=  " AND SA2.A2_LOJA    = SE2.E2_LOJA    "
_cSelect +=  " AND SA2.D_E_L_E_T_ = ' '    "
_cSelect +=  " AND SF1.F1_FILIAL  = SD1.D1_FILIAL  "
_cSelect +=  " AND SF1.F1_DOC     = SD1.D1_DOC     "
_cSelect +=  " AND SF1.F1_SERIE   = SD1.D1_SERIE   "
_cSelect +=  " AND SF1.F1_FORNECE = SD1.D1_FORNECE "
_cSelect +=  " AND SF1.F1_LOJA    = SD1.D1_LOJA    "
//_cSelect +=  " AND SF1.F1_ESPECIE = SE2.E2_PREFIXO " // OS 0500/14 - Mauricio Barros alterado para tratar por prefixo do Titulo.
_cSelect +=  " AND SF1.F1_PREFIXO = SE2.E2_PREFIXO "
_cSelect +=  " AND SF1.D_E_L_E_T_ = ' '    "      


//�������������������������������Ŀ
//�Fecha alias caso esteja aberto �
//���������������������������������
If Select("TRBAAJ") > 0
	DBSelectArea("TRBAAJ")
	DBCloseArea()
EndIf

//���������������Ŀ
//�Executa a Query�
//�����������������
TCQUERY _cSelect NEW ALIAS "TRBAAJ"
TCSETFIELD ("TRBAAJ","VL_UNIT","N",15,3) // Tratamento para o erro no campo Valor Unit�rio - ADS ERRO no COPY TO
TCSETFIELD ("TRBAAJ","VL_TOTAL","N",17,2) // Tratamento para o erro no campo Valor Total - ADS ERRO no COPY TO


IncProc("Selecionando Registros...")

DBSelectArea("TRBAAJ")                   

//���������������������Ŀ
//�Copia alias para DBF �
//�����������������������
_cNomeArq 	:= CriaTrab(NIL,.F.)

copy to &(_cNomeArq)
Dbusearea(.T.,,_cNomeArq,"TRBEXL",.F.,.F.)

DbSelectArea("TRBEXL")

DBGOTOP()

TRBEXL->(dbCloseArea())

//������������������Ŀ
//�Abre DBF no Excel �
//��������������������
OpExcel(_cNomeArq)          

//���������������������Ŀ
//�Apaga DBF do Sigaadv �
//�����������������������
fErase(_cNomeArq+".dbf")

//Close(oGeraXls)                      
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � OpExcel  � Autor � Adilson Gomes      � Data �  08/12/03   ���
�������������������������������������������������������������������������͹��
���Descricao � OLE para uso do excel com o microsiga.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OpExcel(cArqTRC)
Local cDirDocs	:= MsDocPath()
Local cPath		:= AllTrim(GetTempPath())

//������������������������������������������������������������Ŀ
//�Copia DBF para pasta TEMP do sistema operacional da estacao �
//��������������������������������������������������������������
If FILE(cArqTRC+".DBF")
	COPY FILE (cArqTRC+".DBF") TO (cPath+cArqTRC+".DBF")
EndIf

If !ApOleClient("MsExcel")
	MsgStop("MsExcel nao instalado.")
	Return
EndIf

//���������������������Ŀ
//�Cria link com o excel�
//�����������������������
oExcelApp := MsExcel():New()

//�����������������Ŀ
//�Abre uma planilha�
//�������������������
oExcelApp:WorkBooks:Open(cPath+cArqTRC+".DBF")
oExcelApp:SetVisible(.T.)
Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � VALIDPERG� Autor � Adalberto Althoff  � Data �  15/09/04   ���
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

aAdd(aRegs,{_cPerg,"01","Produto de       ","","","mv_ch1","C",15,0,0,"G","            ","mv_par01","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SB1","","","          "})
aAdd(aRegs,{_cPerg,"02","Produto ate      ","","","mv_ch2","C",15,0,0,"G","            ","mv_par02","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SB1","","","          "})
aAdd(aRegs,{_cPerg,"03","Natureza de      ","","","mv_ch3","C",10,0,0,"G","            ","mv_par03","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SZH","","","          "})
aAdd(aRegs,{_cPerg,"04","Natureza ate     ","","","mv_ch4","C",10,0,0,"G","            ","mv_par04","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SZH","","","          "})
aAdd(aRegs,{_cPerg,"05","Fornecedor de    ","","","mv_ch5","C",06,0,0,"G","            ","mv_par05","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SA2","","","          "})
aAdd(aRegs,{_cPerg,"06","Fornecedor ate   ","","","mv_ch6","C",06,0,0,"G","            ","mv_par06","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SA2","","","          "})
aAdd(aRegs,{_cPerg,"07","Emissao de       ","","","mv_ch7","D",08,0,0,"G","            ","mv_par07","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"08","Emissao ate      ","","","mv_ch8","D",08,0,0,"G","            ","mv_par08","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"09","DT Digitacao de  ","","","mv_ch9","D",08,0,0,"G","            ","mv_par09","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"10","DT Digitacao ate ","","","mv_ch10","D",08,0,0,"G","           ","mv_par10","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})


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
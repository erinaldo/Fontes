#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AFD0002  � Autor � Adriano Dias       � Data �  03/01/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera arquivo xls com dados de desconto da odontoprev       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AFD0002
//�������������������������Ŀ
//� Declaracao de Variaveis �
//���������������������������

Private cPerg       := "AFD002"
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

//������������������������������������������������������������������������������
//� Query com os dados a serem impressos: com informacoes de todas as filiais. �
//������������������������������������������������������������������������������       

_cSelect += " SELECT C7_NUMSC,C7_ITEMSC, C1_EMISSAO, C1_SOLICIT, CR_XNOMSOL,C7_NUM, C7_EMISSAO,AK_NOME,CR_USER, "
_cSelect += " CR_APROV, CR_TIPO, D1_FORNECE, D1_LOJA, D1_DOC, D1_EMISSAO, D1_DTDIGIT, F1_VALBRUT,F1_XCONF01, "
_cSelect += " F1_XCONF02,F1_XCONF03,F1_COND,D1_COD, SUBSTRING(B1_DESC,1,50), F1_FILIAL "

_cSelect += " FROM "+RetSqlName('SD1')+" D1, "+RetSqlName('SC7')+" C7,"+RetSqlName('SC1')+" C1,"+RetSqlName('SF1')+" F1, "
_cSelect += " "+RetSqlName('SB1')+" B1,"+RetSqlName('SAK')+" AK, "+RetSqlName('SCR')+" CR "

_cSelect += " WHERE D1_PEDIDO=C7_NUM AND D1_ITEMPC=C7_ITEM AND F1_DOC=D1_DOC AND F1_FORNECE=D1_FORNECE "
_cSelect += " AND D1_LOJA=F1_LOJA AND D1_FILIAL=F1_FILIAL AND C7_NUM=CR_NUM AND AK_USER=CR_USER "
_cSelect += " AND C1_NUM=C7_NUMSC AND C1_ITEM=C7_ITEMSC AND C7_PRODUTO=B1_COD "

_cSelect += " AND D1.D_E_L_E_T_='' AND C7.D_E_L_E_T_='' AND F1.D_E_L_E_T_=''  AND C1.D_E_L_E_T_='' "
_cSelect += " AND AK.D_E_L_E_T_='' AND CR.D_E_L_E_T_='' AND B1.D_E_L_E_T_='' "  

_cSelect += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cSelect += " AND D1_FORNECE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"' "
_cSelect += " AND D1_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"' " 
_cSelect += " AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
_cSelect += " AND D1_DOC BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
_cSelect += " AND D1_PEDIDO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
_cSelect += " AND C7_TIPO=1 "

_cSelect += " GROUP BY C7_NUMSC,C7_ITEMSC, C1_EMISSAO, C1_SOLICIT, CR_XNOMSOL,C7_NUM, C7_EMISSAO,AK_NOME,CR_USER, "
_cSelect += " CR_APROV, CR_TIPO, D1_FORNECE, D1_LOJA, D1_DOC, D1_EMISSAO, D1_DTDIGIT, F1_VALBRUT,F1_XCONF01, "  
_cSelect += " F1_XCONF02, F1_XCONF03, F1_COND,D1_COD, SUBSTRING(B1_DESC,1,50), F1_FILIAL " 

_cSelect += " ORDER BY D1_DTDIGIT, D1_DOC, D1_FORNECE, D1_LOJA "  

Memowrit("c:\adriano.sql",_cSelect)

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
IncProc("Selecionando Registros...")

TcSetField( "TRBAAJ", "F1_VALBRUT","N",14,2 )

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
_cPerg := PADR(Pg,6)
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Digita��o de     ","","","mv_ch1","D",15,0,0,"G","            ","mv_par01","         ","","","","","         ","","","","","","","","","","","","","","","","","","","  ","","","          "})
aAdd(aRegs,{_cPerg,"02","Digita��o ate    ","","","mv_ch2","D",15,0,0,"G","            ","mv_par02","         ","","","","","         ","","","","","","","","","","","","","","","","","","","  ","","","          "})
aAdd(aRegs,{_cPerg,"03","Fornecedor de    ","","","mv_ch3","C",06,0,0,"G","            ","mv_par03","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SA2","","","         "})
aAdd(aRegs,{_cPerg,"04","Loja de          ","","","mv_ch4","C",02,0,0,"G","            ","mv_par04","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","         "})
aAdd(aRegs,{_cPerg,"05","Fornecedor ate   ","","","mv_ch5","C",06,0,0,"G","            ","mv_par05","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SA2","","","         "})
aAdd(aRegs,{_cPerg,"06","Loja ate         ","","","mv_ch6","C",02,0,0,"G","            ","mv_par06","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","         "})
aAdd(aRegs,{_cPerg,"07","Emissao de       ","","","mv_ch7","D",08,0,0,"G","            ","mv_par07","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","         "})
aAdd(aRegs,{_cPerg,"08","Emissao ate      ","","","mv_ch8","D",08,0,0,"G","            ","mv_par08","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","         "})
aAdd(aRegs,{_cPerg,"09","Nota de          ","","","mv_ch9","C",06,0,0,"G","            ","mv_par09","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SF1","","","         "})
aAdd(aRegs,{_cPerg,"10","Nota ate         ","","","mv_ch10","C",06,0,0,"G","           ","mv_par10","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SF1","","","         "})
aAdd(aRegs,{_cPerg,"11","Pedido de        ","","","mv_ch11","C",06,0,0,"G","            ","mv_par11","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SC7","","","        "})
aAdd(aRegs,{_cPerg,"12","Pedido ate       ","","","mv_ch12","C",06,0,0,"G","            ","mv_par12","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SC7","","","        "})


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
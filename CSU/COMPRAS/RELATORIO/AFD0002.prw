#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AFD0002  บ Autor ณ Adriano Dias       บ Data ณ  03/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo xls com dados de desconto da odontoprev       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AFD0002
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cPerg       := "AFD002"
Private oGeraXls


ValidPerg(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERAXLSบ Autor ณ AP5 IDE            บ Data ณ  13/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo XLS.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraXls
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local _cSelect  := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Query com os dados a serem impressos: com informacoes de todas as filiais. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู       

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha alias caso esteja aberto ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TRBAAJ") > 0
	DBSelectArea("TRBAAJ")
	DBCloseArea()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a Queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TCQUERY _cSelect NEW ALIAS "TRBAAJ"
IncProc("Selecionando Registros...")

TcSetField( "TRBAAJ", "F1_VALBRUT","N",14,2 )

DBSelectArea("TRBAAJ")                   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCopia alias para DBF ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cNomeArq 	:= CriaTrab(NIL,.F.)

copy to &(_cNomeArq)
Dbusearea(.T.,,_cNomeArq,"TRBEXL",.F.,.F.)

DbSelectArea("TRBEXL")

DBGOTOP()

TRBEXL->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre DBF no Excel ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
OpExcel(_cNomeArq)          

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณApaga DBF do Sigaadv ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fErase(_cNomeArq+".dbf")

//Close(oGeraXls)                      
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ OpExcel  บ Autor ณ Adilson Gomes      บ Data ณ  08/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ OLE para uso do excel com o microsiga.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function OpExcel(cArqTRC)
Local cDirDocs	:= MsDocPath()
Local cPath		:= AllTrim(GetTempPath())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCopia DBF para pasta TEMP do sistema operacional da estacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If FILE(cArqTRC+".DBF")
	COPY FILE (cArqTRC+".DBF") TO (cPath+cArqTRC+".DBF")
EndIf

If !ApOleClient("MsExcel")
	MsgStop("MsExcel nao instalado.")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria link com o excelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oExcelApp := MsExcel():New()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre uma planilhaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oExcelApp:WorkBooks:Open(cPath+cArqTRC+".DBF")
oExcelApp:SetVisible(.T.)
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ VALIDPERGบ Autor ณ Adalberto Althoff  บ Data ณ  15/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar, VALIDADA PARA AP7                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,6)
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Digita็ใo de     ","","","mv_ch1","D",15,0,0,"G","            ","mv_par01","         ","","","","","         ","","","","","","","","","","","","","","","","","","","  ","","","          "})
aAdd(aRegs,{_cPerg,"02","Digita็ใo ate    ","","","mv_ch2","D",15,0,0,"G","            ","mv_par02","         ","","","","","         ","","","","","","","","","","","","","","","","","","","  ","","","          "})
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
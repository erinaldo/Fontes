#INCLUDE "rwmake.ch"
#DEFINE _cEOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Cesta05  บ Autor ณ Felipe Raposo      บ Data ณ  30/09/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza os campos B1_PE (Prazo de Entraga) e B1_ESTSEGD   บฑฑ
ฑฑบ          ณ (Estoque de Seguranca em Dias) no SB1 (Cad. de Produtos).  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function Cesta05()
Local _cMsg
MATA035()  // Cadastro de Grupo de Produtos.
_cMsg := "Deseja atualizar o cadastro de produtos de acordo com os " + _cEOL +;
"valores informados no cadastro de grupos?"
If MsgYesNo(_cMsg)
	MsAguarde({|lEnd| AtuSB1(.T.)}, "Atualizando o cadastro de produtos...", "Aguarde", .F.)
Endif
Return

                                                             
Static Function AtuSB1()
Local _cQry, _cB1Name, _cBMName, _nRetQry, _cMsg
MsProcTxt("Processando produtos...")
_cB1Name := RetSQLName("SB1")
_cB3Name := RetSQLName("SB3")
_cBMName := RetSQLName("SBM")

/*
// Versao oficial
_cQry :=;
"UPDATE " + _cB1Name + _cEOL +;
"SET " + _cEOL +;
"B1_PE      = BM_PE, " + _cEOL +;
"B1_ESTSEGD = BM_ESTSEGD " + _cEOL +;
"FROM " + _cB1Name + " B1, " + _cBMName + " BM " + _cEOL +;
"WHERE " + _cEOL +;
"BM_FILIAL   = '" + xFilial("SBM") + "' AND " + _cEOL +;
"BM.BM_GRUPO = B1.B1_GRUPO AND " + _cEOL +;
"BM.D_E_L_E_T_ <> '*' AND " + _cEOL +;
"B1.D_E_L_E_T_ <> '*'"
*/

// Atualiza os outros campos a partir dos dois atualizados nesse programa.
// "	B1_EMIN    = ((BM.BM_ESTSEGD + BM.BM_PE) * B3.B3_MEDIA / 30) " + _cEOL +;  

_cQry :=;
"UPDATE " + _cB1Name + _cEOL +;
"SET " + _cEOL +;
"	B1_PE      = BM.BM_PE, " + _cEOL +;
"	B1_PEQ     = (BM.BM_PE * B3.B3_MEDIA / 30), " + _cEOL +;
"	B1_ESTSEGD = BM.BM_ESTSEGD, " + _cEOL +;
"	B1_ESTSEG  = (BM.BM_ESTSEGD * B3.B3_MEDIA / 30), " + _cEOL +;
"	B1_EMIND   = (BM.BM_ESTSEGD + BM.BM_PE), " + _cEOL +;
"   B1_EMIN    = CASE WHEN((BM.BM_ESTSEGD + BM.BM_PE) * B3.B3_MEDIA / 30) < 1 THEN 1 ELSE ((BM.BM_ESTSEGD + BM.BM_PE) * B3.B3_MEDIA / 30) END" + _cEOL +;
"FROM " + _cB1Name + " B1, " + _cB3Name + " B3, " + _cBMName + " BM " + _cEOL +;
"WHERE " + _cEOL +;
"	B3_FILIAL   = '" + xFilial("SB3") + "' AND " + _cEOL +;
"	B3_COD      = B1_COD AND " + _cEOL +;
"	BM_FILIAL   = '" + xFilial("SBM") + "' AND " + _cEOL +;
"	BM.BM_GRUPO = B1.B1_GRUPO AND " + _cEOL +;
"	B3.D_E_L_E_T_ <> '*' AND " + _cEOL +;
"	BM.D_E_L_E_T_ <> '*' AND " + _cEOL +;
"	B1.D_E_L_E_T_ <> '*'"

// Verifica se a query esta correta.
_nRetQry = TcSqlExec(_cQry)
If _nRetQry != 0
	_cMsg := "Nใo foi possํvel atualizar o cadastro de produtos (SB1)." + _cEOL +;
	"Informe o erro abaixo ao administrador do sistema." + _cEOL + _cEOL +;
	TcSQLError()
	APMsgAlert(OemToAnsi(_cMsg), OemToAnsi("Aten็ใo"))
EndIf
Return
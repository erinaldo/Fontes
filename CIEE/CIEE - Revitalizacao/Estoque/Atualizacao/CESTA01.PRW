#INCLUDE "rwmake.ch"
#DEFINE _cEOL CHR(13) + CHR(10)     
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTA01
Atualiza os campos B1_PE (Prazo de Entraga) e B1_XDIASEG (Estoque de Seguranca em Dias) no SB1 (Cad. de Produtos).
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/                             
//---------------------------------------------------------------------------------------
User Function CESTA01()    
Private aRotina := STATICCALL(MATA035,MenuDef)
       
MATA035()  // Cadastro de Grupo de Produtos.

If MsgYesNo("Deseja atualizar o cadastro de produtos de acordo com os " + _cEOL +;
"valores informados no cadastro de grupos?")
	MsAguarde({|| C4A01ATU() }, "Atualizando o cadastro de produtos...", "Aguarde", .F.)
Endif

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C4A01ATU   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza cadastro de produto         		              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/                                                              
Static Function C4A01ATU()
Local _cQry, _nRetQry, _cMsg

MsProcTxt("Processando produtos...")

_cQry :=;
"UPDATE " + RetSQLName("SB1") + _cEOL +;
"SET " + _cEOL +;
"	B1_PE      = BM.BM_XPE, " + _cEOL +;
"	B1_XPEQ     = (BM.BM_XPE * B3.B3_MEDIA / 30), " + _cEOL +;
"	B1_XDIASEG = BM.BM_XDIASEG, " + _cEOL +;
"	B1_ESTSEG  = (BM.BM_XDIASEG * B3.B3_MEDIA / 30), " + _cEOL +;
"	B1_XEMIND   = (BM.BM_XDIASEG + BM.BM_XPE), " + _cEOL +;
"   B1_EMIN    = CASE WHEN((BM.BM_XDIASEG + BM.BM_XPE) * B3.B3_MEDIA / 30) < 1 THEN 1 ELSE ((BM.BM_XDIASEG + BM.BM_XPE) * B3.B3_MEDIA / 30) END" + _cEOL +;
"FROM " + RetSQLName("SB1") + " B1, " + RetSQLName("SB3") + " B3, " + RetSQLName("SBM") + " BM " + _cEOL +;
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
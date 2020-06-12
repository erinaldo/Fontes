#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³cesta02   º Autor ³ Felipe Raposo      º Data ³  17/05/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gatilho que gera o codigo do produto automaticamente a par-º±±
±±º          ³ tir do grupo digitado.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function cesta02()
Local _lNew, _cCod, _aAreaSB1
_aAreaSB1 := SB1->(GetArea())
SB1->(dbSetOrder(1))  // B1_FILIAL+B1_COD.
_lNew := SB1->(!dbSeek(xFilial("SB1") + M->B1_COD, .F.))
_cCod := If (_lNew, GetB1_COD(), M->B1_COD)
SB1->(RestArea(_aAreaSB1))

Return (_cCod)

Static Function GetB1_CODa()
Local _nTamCod := 3
Local _cMsg, _cOpc, _cChave, _cSeq
Local _aAreaX5 := SX5->(GetArea())

// Pergunta se o produto controla estoque, para gravar o codigo.
_cMsg := "Esse produto tem controle de estoque?"
_cOpc := If (MsgBox (_cMsg, "PRODUTO", "YESNO"), "0", "1")

// Busca o codigo no SX5.
_cChave := AllTrim(M->B1_GRUPO) + If (_cOpc == "1", "N", "S")

SX5->(dbSetOrder(1))  // X5_FILIAL + X5_TABELA + X5_CHAVE
If !SX5->(dbSeek(xFilial("SX5") + "Z1" + _cChave, .F.))
	RecLock("SX5", .T.)
	SX5->X5_TABELA1  := "Z1"
	SX5->X5_CHAVE   := _cChave
	SX5->X5_DESCRI  := "1"
	SX5->X5_DESCSPA := "1"
	SX5->X5_DESCENG := "1"
	SX5->(msUnLock())
Endif

// Condicao para evitar que o campo sequencial estoure.
If val(SX5->X5_DESCRI) <= val(Replicate("9",_nTamCod))
	_cSeq := StrZero(val(SX5->X5_DESCRI), _nTamCod)
Else
	_cSeq := SubStr(AllTrim(SX5->X5_DESCRI), 1, 2)
	Do Case
		Case _cSeq == "10"; _cSeq := "A"
		Case _cSeq == "11"; _cSeq := "B"
		Case _cSeq == "12"; _cSeq := "C"
		Case _cSeq == "13"; _cSeq := "D"
		Case _cSeq == "14"; _cSeq := "E"
		Case _cSeq == "15"; _cSeq := "F"
	EndCase
	_cSeq += SubStr(AllTrim(SX5->X5_DESCRI), 3, _nTamCod - 1)
Endif

// Monta o codigo que vai retornar.
_cCod := AllTrim(M->B1_GRUPO) + "." + _cOpc + "." + AllTrim(_cSeq)
SX5->(RestArea(_aAreaX5))



Return (_cCod)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT010Inc  º Autor ³ Felipe Raposo      º Data ³  17/05/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada no momento da inclusao de um produto.     º±±
±±º          ³ - Confirma a entrada do produto e atualiza a tabela Z1 (se-º±±
±±º          ³ quencia de codigo do produto) que fica no SX5.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT010Inc()

// Variaveis locais, auxiliares do processamento.
Local _cCod, _nAux, _nSeq, _cOpc, _cChave

// Armazena as condicoes das tabelas antes do processamento.
Local _aAreaB1 := SB1->(GetArea())
Local _aAreaX5 := SX5->(GetArea())

// Desmembra o codigo do produto para processamento.
_cCod := SB1->B1_COD
_nAux := rat(".", _cCod)
_cOpc   := AllTrim(SubStr(_cCod, _nAux - 1, 1))
_cChave := AllTrim(SubStr(_cCod, 1, _nAux - 3) + If (_cOpc == "1", "N", "S"))

// Incrementa um na tabela Z1 do SX5.
//_cChave := AllTrim(SB1->B1_GRUPO) + "." + _cOpc
SX5->(dbSelectArea(1))  // X5_FILIAL + X5_TABELA + X5_CHAVE
If SX5->(dbSeek(xFilial("SX5") + "Z1" + _cChave, .F.))
	RecLock("SX5", .F.)
Else
	RecLock("SX5", .T.)
	SX5->X5_TABELA := "Z1"
	SX5->X5_CHAVE  := _cChave
Endif
_nSeq := val(SX5->X5_DESCRI) + 1
SX5->X5_DESCRI  := AllTrim(str(_nSeq))
SX5->X5_DESCSPA := AllTrim(str(_nSeq))
SX5->X5_DESCENG := AllTrim(str(_nSeq))
SX5->(msUnLock())

// Restaura as condicoes anteriores das tabelas utilizadas.
SX5->(RestArea(_aAreaX5))
SB1->(RestArea(_aAreaB1))
Return



//28/08/02
Static Function GetB1_COD()

Local _cGrp, _cMsg, _lUsrProd, _cOpc, _cEOL, _cRet
     
_cQry     := " "
_cGrp     := AllTrim(M->B1_GRUPO)
_cEOL     := CHR(13) + CHR(10)
//_lUsrProd := upper(AllTrim(UsrRetName(RetCodUsr()))) $ upper(GetMv("MV_USRPROD"))

If Alltrim(cUserName) $ GetMV("MV_USRPROD")
	_lUsrProd:=cUserName
Else
	_lUsrProd:=""
EndIf

// Pergunta se o produto controla estoque, para gravar o codigo.
_cMsg := "Esse produto tem controle de estoque?"
//_cOpc := If (_lUsrProd .and. MsgYesNo(_cMsg, "PRODUTO"), "0", "1")

_cOpc := If (MsgYesNo(_cMsg, "PRODUTO"), "0", "1")

If _cOpc == "0" .and. Empty(_lUsrProd)
	_cMsg := OemToAnsi("Usuário não autorizado a cadastrar itens de estoque!!!")
	MsgAlert(_cMsg, OemToAnsi("Atenção"))   
	u_cesta02()
EndIf

_cQry := " SELECT MAX(B1_COD) TRB_ULTCOD FROM " + RetSQLName("SB1") + " B1 WHERE " + _cEOL 
_cQry += "(" + _cEOL 
_cQry += "	SUBSTRING(B1_COD, 1, " + str(len(_cGrp)) + ") = '" + _cGrp + "' "  + _cEOL

IF _cOpc == "1"
   _cQry += " AND SUBSTRING(B1_COD, " + str(len(_cGrp)) + " + 2, 1) >= '" + _cOpc + "' " + _cEOL
ELSE
   _cQry += " AND SUBSTRING(B1_COD, " + str(len(_cGrp)) + " + 2, 1) = '" + _cOpc + "' " + _cEOL 
ENDIF

//_cQry += " AND SUBSTRING(B1_COD, " + str(len(_cGrp)) + " + 2, 1) = '" + _cOpc + "' " + _cEOL 
_cQry += ") AND B1.D_E_L_E_T_ <> '*'"+ _cEOL 

//MemoWrit(StrTran(FunName(), "#", "") + ".SQL", _cQry)
//TCQuery _cQry NEW ALIAS "TRB"

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),'TRB',.T.,.T.)

_cRet := TRB->TRB_ULTCOD

If empty(_cRet)
	_cRet  := AllTrim(_cGrp) + "." + AllTrim(_cOpc) + "." + "001"
Else	
	/*
	_nAux1 := rat(".", _cRet)
	_cAux1 := SubStr(_cRet, _nAux1 + 1, len(_cRet) - _nAux1)
	_cAux1 := StrZero(val(_cAux1) + 1, 3)
	_cRet  := SubStr(_cRet, 1, _nAux1) + _cAux1
	*/
	
	_nAux1 := rat(".", _cRet)
	_cAux1 := SubStr(_cRet, _nAux1 + 1, len(_cRet) - _nAux1)
	
	IF val(_cAux1) >= 999
		
		_cAux2 := alltrim(Str(Val(Subs(_cRet,4,1)) +1))
		
		_cRet  :=  subs(_cRet,1,3)+_cAux2+"."+subs(_cRet,6,len(_cRet) - _nAux1)
		_cAux1 := "000"
		
	Endif
	_cAux1 := StrZero(val(_cAux1) + 1, 3)
	
	_cRet  := SubStr(_cRet, 1, _nAux1) + _cAux1
	
Endif

If _cOpc == "1"
	If MsgYesNo(OemToAnsi("É Ativo Imobilizado?"), "ATIVO IMOBILIZADO")
		M->B1_XATIVO := "1"
	Else
		M->B1_XATIVO := "2"
	EndIf
ElseIf _cOpc == "0"
	M->B1_XATIVO := " "
EndIf

TRB->(dbCloseArea())
Return(_cRet)  

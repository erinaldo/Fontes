#INCLUDE "PROTHEUS.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT010INC
Ponto de Entrada para complementar a inclusão no cadastro do Produto
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT010INC()

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
#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT241TOK
Ponto de entrada - valida o movimento  (mod. 2) (MATA241).
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function MT241TOK()
Local _lRetorno, _nPsProd, _nPsCCusto, _nPsQuant, _iAux, _nQuant
Local _cProd, _cCCusto, _nLinhas := 0
Local _cB1Local, _cI1Local
Local _cMsg := ""

_lRetorno  := .T.
_nPsProd   := aScan (aHeader, {|x| AllTrim(x[2]) == "D3_COD"})
_nPsQuant  := aScan (aHeader, {|x| AllTrim(x[2]) == "D3_QUANT"})
_nPsCCusto := aScan (aHeader, {|x| AllTrim(x[2]) == "D3_CC"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz as consistencias de localizacao do centro de ³
//³ custo e o produto.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Busca a localizacao do centro de custo.
// 1 - Sede.
// 2 - Unidade.
// 3 - Nao gera.
_cI1Local := POSICIONE("CTT",1, xFilial("SB1") + CCC,"CTT_LOCALI") 

// Varre todos os itens da aCols e testa produto por produto.
For _iAux := 1 to len(aCols)
	If !aCols [_iAux, len(aHeader) + 1]
		
		// Pesquisa o produto do item corrente.
		_cProd   := aCols [_iAux, _nPsProd]
		
		// Busca o destino do produto.
		// U - Unidade.
		// S - Sede.
		// A - Ambos.
		_cB1Local := POSICIONE("SB1",1, xFilial("SB1") + _cProd,"B1_XLOCAL")
		
		// Testa se houve algum erro na digitacao da requisicao.
		If (_cB1Local == "S" .and. _cI1Local != "1")
			_cMsg := "O produto da linha " + StrZero(_iAux, 2) + " é destinado somente para a sede."
		ElseIf (_cB1Local == "U" .and. _cI1Local != "2")
			_cMsg := "O produto da linha " + StrZero(_iAux, 2) + " é destinado somente para as unidades."
		Endif
		
		// Se houve algum erro na digitacao da requisicao,
		// exibir a mensagem e retornar falso.
		If !empty(_cMsg)
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
	Endif
Next _iAux

// Caso os itens tenham passado pelas consistencias.
For _iAux := 1 to len(aCols)
	If !aCols [_iAux, len(aHeader) + 1]
		_cProd  := aCols [_iAux, _nPsProd]
		_nQuant := aCols [_iAux, _nPsQuant]
		Cmata170(_cProd, _nQuant, .F.)  // Gera SC por ponto de pedido.
	Endif
Next _iAux    

Return (_lRetorno)
#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT103IPC
Ponto de Entrada com objetivo de atualizar os campos customizados no Documento de Entrada e na Pré Nota
@author     Totvs
@since     	01/01/2015
@version  	P.11      
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
User Function MT103IPC()
Local _nPsDescr 	:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDESPRO"})
Local _nPsProduto	:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_COD"})
Local _nAux1		:= 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o campo de descricao do produto (especifico).              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _nPsDescr > 0 .and. _nPsProduto > 0
	// Processa todos os itens da aCols.
	For _nAux1 := 1 to len(aCols)
		aCols[_nAux1, _nPsDescr] := POSICIONE("SB1",1,xFilial("SB1") + aCols[_nAux1, _nPsProduto] ,"B1_DESC")
	Next _nAux1
Endif

Return(nil)
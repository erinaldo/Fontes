#INCLUDE "rwmake.ch"      
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE07
Gatilho para acertar os campos de estoque de seguranca, prazo de entrega e o ponto 
de pedido, de acordo com a digitacao de algum dado novo manualmente.
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera寤es Realizadas desde a Estrutura豫o Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/                             
//---------------------------------------------------------------------------------------
USER FUNCTION CESTE07(_cOpc)
// Declaracao das variaveis utilizadas no programa.
Local _lRetorno := .T., _nMedia

_cOpc := If (_cOpc == nil, "", AllTrim(upper(_cOpc)))
_nMedia := POSICIONE("SB3",1,XFILIAL("SB3")+M->B1_COD ,"B3_MEDIA")  //U_GetConsMed(M->B1_COD)

M->B1_XCONMED := _nMedia //Acrescentado pelo analista Emerson dia 02/03/10

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Estoque de seguranca em qtde.             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
M->B1_ESTSEG := (M->B1_XDIASEG * (_nMedia / 30))

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Prazo de entrega em qtde.                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
M->B1_XPEQ := (M->B1_PE * (_nMedia / 30))

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Calcula o ponto de pedido em dias e quantidade.  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
M->B1_XEMIND := M->B1_XDIASEG + M->B1_PE  // Em dias.
M->B1_EMIN  := IIF((M->B1_XEMIND * (_nMedia / 30))<1,1,(M->B1_XEMIND * (_nMedia / 30)))  // Em qtde.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Lote economico.                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If _cOpc == "B1_XLED"
	M->B1_LE := (M->B1_XLED * (_nMedia / 30))
Else
	M->B1_XLED := (M->B1_LE / (_nMedia / 30))
Endif     

Return _lRetorno
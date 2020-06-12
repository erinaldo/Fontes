#Include 'Protheus.ch'

//Chamado atraves do Ponto de Entrada CTA030TOK()

User Function CCTBE04()

Local _nOK 		:= .F.
Local aButtons 	:= {}

Private _cCusto 	:= ""
Private _cDesc	:= ""

If INCLUI
	_cCusto	:= M->CTT_CUSTO
	_cDesc		:= M->CTT_DESC01
	
	_nOK		:= AxInclui("CV0",       , , ,"U_CCTB4INI", , , , , aButtons, , ,.T.)
	          
EndIf

Return(_nOK)

User Function CCTB4INI()

Local  _aArea := GetArea()

M->CV0_PLANO    	:= "05"
M->CV0_CODIGO		:= _cCusto
M->CV0_DESC		:= _cDesc

RestArea(_aArea)

Return
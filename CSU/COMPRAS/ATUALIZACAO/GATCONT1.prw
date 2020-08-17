#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: GATCONT1 Autor: Fernando José		Data: 15/05/14	           ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: Gatilho para preenchimento do campo CNB_X_GTEC              ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±				Uso:  CSU 	                                               ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                      
User Function GATCONT1 ()       

Local nPosget	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "CNB_X_GTEC"  }) // Ver a Posicao do Campo no aHeader
_Retorno        :=  ""

IF N > 1  

	_Retorno  :=  aCols[1][nPosget]   /////   retorna sempre o conteudo da primeira linha

ENDIF


return(_Retorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: GATCONT1 Autor: Fernando José  		Data: 15/05/14	           ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: Validacao do Centro de custo na solicitacao de compras para  ±± 
±±				validar o centro de custo e usuario no SZI                 ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±				Uso:  CSU 	                                               ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function VALC1CC()


///u_UsrCCVldLin( M->C1_USERSOL , M->C1_CC ) .And. u_VldCCusto( M->C1_CC )  validacao anterior do campo C1__CC


Local nPoscc	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "C1_CC"  }) // Ver a Posicao do Campo no aHeader
_cc     :=   M->C1_CC
_Codusu :=   PSWID()


PswOrder(2) // Ordem de nome do usuario
PswSeek( ca110SOL )

lRet := .T.
Dbselectarea("SZI")
Dbsetorder(1)
If !DbSeek( xFilial("SZI") + _Codusu + _CC )
	Aviso( "Atenção !" , "Você está utilizando um Centro de Custo que não está amarrado ao usuário ! Realize a amarração usuário x centro de custo ou selecione outro centro de custo." , {"Ok"} , 1 , "Usuario x Centro de Custo" )
	lRet := .F.
Else
	
	IF ! (SZI->ZI_FLGCOM == '1')  //////// SE A AMARRACAO NO SZI NAO ESTIVER FLEGADO PARA COMPRAS NAO DEIXA PASSAR 
	Aviso( "Atenção !" , "Você está utilizando um Centro de Custo Amarrado ao usuário mas não esta flegado para compras! Verifique o flag de compras no Cadastro usuário x centro." , {"Ok"} , 1 , "Usuario x Centro de Custo" )
	lRet := .F.
	ENDIF

endif

Return(lRet)   

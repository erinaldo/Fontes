#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} F050ALT
//TODO Descrição auto-gerada.
// M-> 	 - Esta com o conteudo antes  da alteração
// SE2-> - Esta com o conteudo depois da alteração
@author emerson.natali
@since 09/04/2018
@version undefined

@type function
/*/
USER FUNCTION F050ALT()

lRet 		:= .T.
_aCampos 	:= StrTokArr( SuperGetMv("AS_CPOFIN",.T.,"E2_VENCTO|E2_VENCREA") , "|" ) //"E2_VENCREA|E2_HIST"
_aLogAlt 	:= {}
_aCpoAlt 	:= {}

//Monta um array com o LOG de todos os campos usados antes da alteração
DBSELECTAREA("SX3")        
SX3->(DBSETORDER(1))
SX3->(DBSEEK("SE2"))
Do While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SE2"
	IF X3USO(SX3->X3_USADO)
		aadd(_aLogAlt, {TRIM(SX3->X3_CAMPO),&("M->"+SX3->X3_CAMPO) })
	EndIf
	SX3->(dbSkip())		
EndDo

_nCont := 0 //alteração nos campos padroes
_nAlt  := 0 //alteração nos campo do parametros não enviando novamente para o workflow
For _nY := 1 to len(_aLogAlt)
	If _aLogAlt[_nY, 2] <> &("SE2->"+_aLogAlt[_nY, 1])
		aadd(_aCpoAlt,_aLogAlt[_nY, 1])
		If (ascan(_aCampos, _aLogAlt[_nY, 1])) > 0
			_nAlt++
		Else
			_nCont++
		EndIf
	EndIf
Next _nY

//Se não teve nenhum campo diferente dos parametro e teve alteração nos campos do parametro
//não manda a solicitação para o fluig novamente.
If _nCont = 0
	If _nAlt > 0
		lRet := .F.
	EndIf
EndIf

RETURN(lRet)
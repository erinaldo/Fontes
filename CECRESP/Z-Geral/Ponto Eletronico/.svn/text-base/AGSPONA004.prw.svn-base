#INCLUDE "rwmake.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} AGSPONA004()

Utilizado no Potnto de entrada PONAPO4

@param		nenhum
@return		nenhum
@author 	Isamu K.   
@since 		20/10/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function AGSPONA004

Local nX
Local cRegraApon := ""
Local aTabCalen  := aClone( ParamIxb[2])
Local nTolHex    := 0
Local nTolAtr    := 0

For nX := 1 To Len(aEventos)
	
    If ( nPos := Ascan(aTabCalen,{|x| x[1] == aEventos[nX,1] .and. x[4] == "1E" }) ) > 0
		cRegraApon := aTabCalen[nPos,23]
	Endif

    If Spa->(dbSeek(xFilial("SPA")+cRegraApon))
       nTolHex := Spa->Pa_TolHePe
       nTolAtr := Spa->Pa_TolAtra
    Endif   

    If aEventos[nX,2] $ "999*012*014*020"	
       If aEventos[nX,3] <= nTolHex .or. aEventos[nX,3] <= nTolAtr 
          aEventos[nX,3] := 0
       Endif   
	Endif
	
Next

Return

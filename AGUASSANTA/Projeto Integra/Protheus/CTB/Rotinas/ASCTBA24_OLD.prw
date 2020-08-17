#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA24()
Complementa a tabela SZ9 com as informações do reajuste

@param		
@return		nValJur -> Valor do Juros de Parcelamento
@author 	Fabiano Albuquerque
@since 		01/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra

/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCTBA24()
Local aAreaAnt	:= GetArea()
Local aAreaSE1  := SE1->(GetArea())
Local cVenda	:= SE1->E1_XCONTRA
Local aInfVen	:= U_ASFINA77(cVenda,"ASTIN007")
Local lRet		:= .F.  
Local cAlias	:= "SZ9" 
Local aSZ9		:= {}

DbSelectArea("SZ9")
SZ9->(DbSetOrder(1))
IF MsSeek(xFilial("SZ9")+cVenda)
	IF(Len(aInfVen)>0)
		RECLOCK( "SZ9", .F. )
		
			DbSelectArea("SX3")
			SX3->(DbSetOrder(1))
			SX3->(DbSeek(cAlias))	

			While SX3->X3_Arquivo == cAlias .And. !SX3->(EOF())
			     IF X3Uso(SX3->X3_Usado)
			     	Aadd(aSZ9, { SX3->X3_CAMPO, SX3->X3_TIPO } )
			     EndIF
			   SX3->(DbSkip())
			EndDo			
		
			For x=1 To Len(aSZ9)
				For y=1 To Len(aInfVen)
					IF Alltrim(aSZ9[x][1]) == Alltrim(aInfVen[y][1])
						IF Alltrim(aSZ9[x][2]) == 'D'
   							IF Alltrim(aSZ9[x][1]) == "Z9_DTREAJU"
						   		SZ9->Z9_DTREAJU := cToD(Substr(aInfVen[y][2],9,2)+"/"+Substr(aInfVen[y][2],6,2)+"/"+Substr(aInfVen[y][2],1,4)) 
						   ElseIF Alltrim(aSZ9[x][1]) == "Z9_DTCHAVE"
						   		SZ9->Z9_DTCHAVE := cToD(Substr(aInfVen[y][2],9,2)+"/"+Substr(aInfVen[y][2],6,2)+"/"+Substr(aInfVen[y][2],1,4)) 
						   EndIF
						EndIF
					EndIF
				Next
			Next
		MSUNLOCK()
	ENDIF
	lRet := .T.
ENDIF

RestArea(aAreaSE1)
RestArea(aAreaAnt)

RETURN lRet
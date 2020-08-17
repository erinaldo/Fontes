#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'

//--------------------------------------------------------------------------------------------
/*{Protheus.doc} ASFINA76
Grava informações complementares da venda na tabela SZ9
Chamado pelo PE F055IT

@param		cValExt, cHist, cTitE1E2
@return		
@author 	Fabiano Albuquerque
@since 		01/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//--------------------------------------------------------------------------------------------
USER FUNCTION ASFINA76 (cValExt, cHist, cTitE1E2)
Local aAreaAnt	:= GetArea()
Local aAreaSE1  := SE1->(GetArea())
Local cVenda	:= SUBSTR(cHist,At("VENDA:",cHist)+6,4)  //MENSAL - VENDA:2110 EMPR:17 QUADRA:2 LOT
Local aInfVen
Local cConsTIN  := "ASTIN006"
Local cAlias    := "SZ9"
Local aSZ9		:={}
Local x			
Local y			

DbSelectArea("SZ9")
SZ9->(DbSetOrder(1)) // Z9_FILIAL + Z9_NUNVENDA
IF MsSeek(xFilial("SZ9")+cVenda)
	Return
Else

	aInfVen := U_ASFINA77( cVenda, cConsTIN )
	
	IF(Len(aInfVen)>0)
	
		SZ9->(RECLOCK( "SZ9", .T. ))
			
			SZ9->Z9_FILIAL := xFilial("SZ9")
			
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

						   IF Alltrim(aSZ9[x][1]) == "Z9_DTVENDA"
						   		SZ9->Z9_DTVENDA := cToD(Substr(aInfVen[y][2],9,2)+"/"+Substr(aInfVen[y][2],6,2)+"/"+Substr(aInfVen[y][2],1,4)) 
						   ElseIF Alltrim(aSZ9[x][1]) == "Z9_DTCHAVE"
						   		SZ9->Z9_DTCHAVE := cToD(Substr(aInfVen[y][2],9,2)+"/"+Substr(aInfVen[y][2],6,2)+"/"+Substr(aInfVen[y][2],1,4)) 

						   EndIF						   
						Else

						   IF Alltrim(aSZ9[x][1]) == "Z9_EMPR"
						   		SZ9->Z9_EMPR	:= aInfVen[y][2]
						   ElseIF Alltrim(aSZ9[x][1]) == "Z9_NUNVEND"
						   		SZ9->Z9_NUNVEND	:= aInfVen[y][2]
						   ElseIF Alltrim(aSZ9[x][1]) == "Z9_TIPOVEN"
						   		SZ9->Z9_TIPOVEN	:= aInfVen[y][2]
						   ElseIF Alltrim(aSZ9[x][1]) == "Z9_TXFIN"
						   		SZ9->Z9_TXFIN	:= Val(aInfVen[y][2])
						   EndIF

						EndIF

					EndIF

				Next

			Next

		MSUNLOCK()
	
	EndIF
	
EndIF

RestArea(aAreaSE1)
RestArea(aAreaAnt)

Return
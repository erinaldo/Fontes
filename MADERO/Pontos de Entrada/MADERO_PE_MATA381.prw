#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT381LOK
//TODO Ponto de Entrada, localizado na validação da linha no Ajuste Empenho Mod. 2, 
	   Utilizado para confirmar inclusão na linha do produto no Ajuste Empenho Modelo 2. 
@author Mario L. B. Faria
@since 25/06/2018
@version 1.0
@return lRet, lógico, continua a ou não o processo
/*/
User Function MT381LOK()

	Local lRet	:= .T.

	Local nPosPrd := aScan(aHeader,{|X|Alltrim(X[2])=="D4_COD"})
	Local nPosLot := aScan(aHeader,{|X|Alltrim(X[2])=="D4_LOTECTL"})
	Local nPosQtd := aScan(aHeader,{|X|Alltrim(X[2])=="D4_QUANT"})

	If Altera
		//Chama rotina para verificar se possui separação
		lRet := U_APCP01SP(SD4->D4_OP,;
						   aCols[n,aScan(aHeader,{|X|Alltrim(X[2])=="D4_COD"})],;
						   aCols[n,aScan(aHeader,{|X|Alltrim(X[2])=="D4_LOTECTL"})],;
						   aCols[n,aScan(aHeader,{|X|Alltrim(X[2])=="D4_QUANT"})])
	EndIf
	
Return lRet

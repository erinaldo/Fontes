#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噮o    � xNfeEmiss� Autor � Leonardo Soncin       � Data �28/11/2006 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北�          矱sta rotina valida a data de emissao do documento de entrada 潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpD1: Data de Emissao                                       潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   矱xpL1: Indica se a data eh valida                            潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北矰escri噭o 矱sta rotina tem como objetivo validar a data de emissao do   潮�
北�          砫ocumento de entrada.                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矱specifico CSU                                               潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

User Function xNfeCpt()
Local lRet	:= .T.

Local dDtCpt  := &(ReadVar())
Local cMesFec := GetNewPar("MV_XMESNFE","")
Local nMesAb := Iif(Val(Substr(cMesFec,1,2))>=12,01,Val(Substr(cMesFec,1,2))+1)

If !Empty(dDtCpt)
		
	If MONTH(dDtCpt) <> MONTH(dDemissao) .and. Year(dDtCpt) <> Year(dDemissao)
		
		If Month(dDtCpt) >  Val(Substr(cMesFec,1,2)) .or.  Year(dDtCpt) > Val(Substr(cMesFec,3,4))
			If Month(dDtCpt) < Month(dDataBase) .or. Year(dDtCpt) < Year(dDataBase) // Tratar o ano.
				lRet := .F.
			Endif
		Else
			If Month(dDataBase) <> nMesAb
				lRet := .F.
			Endif
		Endif
		
	Endif
	
Endif

Return lRet
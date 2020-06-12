#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA12
Valor à ser contabilizado

@param		cBX, cOp
@return		Valor à ser contabilizado
@author 	Fabiano Albuquerque
@since 		23/06/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User function ASCTBA12(cBX,cOp)

Local aArea		:= GetArea()
Local nTotVal	:=	0
Local cChaveFRU := ""
Local cChaveXXF := "RM             "+"SE1010"+"SE1"+"E1_NUM    "
Local cBaixa	:= cBX 
Local cOper		:= cOp
Local nX		:= 0
Local nY		:= 0
Local nZ		:= 0
Local aInterID	:= {}
Local aExterID	:= {}
Local cQuery	:= ""
Local aTit		:= {}
Local cPar 		:= PADR("",TAMSX3("FRU_PARCEL")[1],"")

IF cBaixa == 'N'

	IF ValType(OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL) == "A"
		For nY:=1 TO Len(OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL)
			aAdd(aExterID, OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL[nY]:_INTERNALID:TEXT)
		Next
	
	ElseIF ValType(OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL) == "O"
		aAdd(aExterID, OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL:_INTERNALID:TEXT)
	EndIF
	
	DbSelectArea("XXF")
	XXF->(DbSetOrder(1))
	XXF->(MsSeek(cChaveXXF+aExterID[1]))
	
	For nZ:=1 To Len(aExterID)
		While !XXF->( EOF() ) .And. Alltrim(XXF->XXF_EXTVAL) == aExterID[nZ]
			
			aAdd(aInterID, aTit:= STRTOKARR(XXF->XXF_INTVAL,"|") )

		XXF->(DbSkip())
		EndDO	
	Next

	FRU->(DbSetOrder(3)) // FRU_FILIAL+FRU_PREFIX+FRU_NUM+FRU_PARCEL+FRU_TIPO+FRU_FORNEC+FRU_LOJA+FRU_COD
	FRU->(DbGoTOP())
	IF FRU->(MsSeek( Padr(aInterID[1][2],TAMSX3("FRU_FILIAL")[1],"") + Padr(aInterID[1][3],TAMSX3("FRU_PREFIX")[1],"") + Padr(aInterID[1][4],TAMSX3("FRU_NUM")[1],"") + cPar + Padr(Alltrim(aInterID[1][5]),TAMSX3("FRU_TIPO")[1],"") ) )
		For nX:=1 To Len(aInterID)
			WHILE !FRU->( EOF() ) .And. FRU->FRU_NUM == aInterID[nX][4] .And. xFilial("FRU") == Padr(aInterID[1][2],TAMSX3("FRU_FILIAL")[1],"")
				IF Alltrim(FRU->FRU_COD)==cOper
					nTotVal += FRU->FRU_VALOR
				EndIF
				FRU->(DbSkip())
			EndDO		
		Next
	
	ElseIF SE1->( MsSeek(Padr(aInterID[1][2],TAMSX3("FRU_FILIAL")[1],"") + Padr(aInterID[1][3],TAMSX3("FRU_PREFIX")[1],"") + Padr(aInterID[1][4],TAMSX3("FRU_NUM")[1],"") + cPar + Padr(Alltrim(aInterID[1][5]),TAMSX3("FRU_TIPO")[1],"") ) ) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		nTotVal += SE1->E1_VLCRUZ
	EndIF

ElseIF cBaixa == 'S'
	
	IF ValType(OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL) == "A"
		For nY:=1 TO Len(OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL)
			aAdd(aExterID, OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL[nY]:_INTERNALID:TEXT)
		Next
	
	ElseIF ValType(OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL) == "O"
		aAdd(aExterID, OXMLFIN:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL:_INTERNALID:TEXT)
	EndIF

	cQuery += " SELECT * FROM XXF"
	cQuery += " WHERE XXF_EXTVAL IN (";
	
	For nZ:=1 To Len(aExterID)
		cQuery += "'" + aExterID[nZ] + "'"
		IF nZ < Len(aExterID)
			cQuery += ","
		EndIF
	Next
	cQuery += ")"
	
	IF SELECT("TRBXXF") > 0
		TRBXXF->( dbCloseArea() )
	ENDIF 
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBXXF",.F.,.T.)
	
	DbSelectArea("TRBXXF")
	TRBXXF->( DbGoTop() )
		 		
	While !TRBXXF->( EOF() )
		aAdd(aInterID, aTit:= STRTOKARR(TRBXXF->XXF_INTVAL,"|") )
	
		TRBXXF->(DbSkip())
	EndDO
	
	FRU->(DbSetOrder(3)) // FRU_FILIAL+FRU_PREFIX+FRU_NUM+FRU_PARCEL+FRU_TIPO+FRU_FORNEC+FRU_LOJA+FRU_COD
	FRU->(DbGoTOP())
	IF FRU->(MsSeek( Padr(aInterID[1][2],TAMSX3("FRU_FILIAL")[1],"") + Padr(aInterID[1][3],TAMSX3("FRU_PREFIX")[1],"") + Padr(aInterID[1][4],TAMSX3("FRU_NUM")[1],"") + cPar + Padr(Alltrim(aInterID[1][5]),TAMSX3("FRU_TIPO")[1],"") ) )
		For nX:=1 To Len(aInterID)
			WHILE !FRU->( EOF() ) .And. FRU->FRU_NUM == aInterID[nX][4]
				IF Alltrim(FRU->FRU_COD)==cOper
					nTotVal += FRU->FRU_VALOR
				EndIF
				FRU->(DbSkip())
			EndDO		
		Next 
	
	ElseIF SE1->( MsSeek(Padr(aInterID[1][2],TAMSX3("FRU_FILIAL")[1],"") + Padr(aInterID[1][3],TAMSX3("FRU_PREFIX")[1],"") + Padr(aInterID[1][4],TAMSX3("FRU_NUM")[1],"") + cPar + Padr(Alltrim(aInterID[1][5]),TAMSX3("FRU_TIPO")[1],"") ) ) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		nTotVal += SE1->E1_VLCRUZ
	EndIF
			
EndIF
	
RestArea(aArea)
	
Return nTotVal
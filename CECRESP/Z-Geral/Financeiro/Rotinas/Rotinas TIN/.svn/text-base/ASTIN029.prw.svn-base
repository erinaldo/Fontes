#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN029
@return		Nenhum			
@author		Totvs
@since		13/04/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN029() //F0102009()
Local lRet		:= .F.
Local cAliasSE1 := getNextAlias()
Local cQuery	:= ''

	IF	!Empty(SE1->E1_XTITAGL) .Or. !Empty(SE1->E1_XAGLUT) .Or. !Empty(SE1->E1_XVINCP)
		cQuery := "SELECT E1_VENCTO,E1_EMISSAO,E1_CLIENTE,E1_NUM,E1_XVINCP,E1_XAGLUT "
   		cQuery += " FROM "
   		cQuery += RetSqlName("SE1")+ " SE1 " 
   		cQuery += " WHERE "
		cQuery += " SE1.E1_FILIAL = '"+FWXFILIAL("SE1") +"'"
		IF	Empty(SE1->E1_XTITAGL) //SE1->E1_XAGLUT == '1'
			cQuery += " And E1_NUM ='" + SE1->E1_NUM +"'"
		Else	
			cQuery += " And E1_NUM ='" + SE1->E1_XTITAGL +"'"
		EndIf	
		cQuery += " And E1_CLIENTE='" + SE1->E1_CLIENTE +"'"
		cQuery += " And E1_LOJA='" + SE1->E1_LOJA +"'"
		cQuery += " And E1_PREFIXO='" + SE1->E1_PREFIXO +"'"
		cQuery += " And E1_TIPO='" + SE1->E1_TIPO +"'"
		cQuery += " And E1_XAGLUT = '1' "
		cQuery += " And SE1.D_E_L_E_T_ = ' '" 
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSE1,.F.,.T.)

		IF	(cAliasSE1)->( EOF() )
			(cAliasSE1)->(DbCloseArea())
		
			cQuery := "SELECT E1_VENCTO,E1_EMISSAO,E1_CLIENTE,E1_NUM,E1_XVINCP,E1_XAGLUT "
   			cQuery += " FROM "
   			cQuery += RetSqlName("SE1")+ " SE1 " 
   			cQuery += " WHERE "
			cQuery += " SE1.E1_FILIAL = '"+FWXFILIAL("SE1") +"'"
			cQuery += " And E1_XVINCP ='" + SE1->E1_XVINCP +"'"
			cQuery += " And E1_CLIENTE='" + SE1->E1_CLIENTE +"'"
			cQuery += " And E1_LOJA='" + SE1->E1_LOJA +"'"
			cQuery += " And E1_PREFIXO='" + SE1->E1_PREFIXO +"'"
			cQuery += " And E1_TIPO='" + SE1->E1_TIPO +"'"
			cQuery += " And E1_NUMBOR= ''" 
			cQuery += " And SE1.D_E_L_E_T_ = ' '" 
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSE1,.F.,.T.)
		EndIf
	                                                           
		IF	!(cAliasSE1)->( EOF() ) 
			dVencIni	:=	STOD((cAliasSE1)->E1_VENCTO)
			dVencFim	:=	STOD((cAliasSE1)->E1_VENCTO)

			dEmisDe		:= STOD((cAliasSE1)->E1_EMISSAO)
			dEmisAte	:= STOD((cAliasSE1)->E1_EMISSAO)

			cCliDe		:= (cAliasSE1)->E1_CLIENTE
			cCliAte		:= (cAliasSE1)->E1_CLIENTE

			cNumDe		:= (cAliasSE1)->E1_NUM
			cNumAte		:= (cAliasSE1)->E1_NUM
		EndIf	
		(cAliasSE1)->(DbCloseArea())
	EndIf

Return(lRet)



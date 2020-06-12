#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch" 

/*/{Protheus.doc} MATA540
Ponto de entrada para rotina de Excecoes Fiscais

@author Mario Faria
@since 02/03/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function MATA540() 

	//Objeto do formulário ou do modelo, conforme o caso.
	Local oModel  //ParamIXB[1]
	//ID do local de execução do ponto de entrada
	Local cIdPonto //ParamIXB[2]
	//ID do formulário
	Local cIdModel //ParamIXB[3]

	Local xRetorno := .T.
	
	Local lOpcao	:= .T.
	Local cXEmp		:= ""
	Local cXFil		:= ""

	IF ! Empty(ParamIXB)

		oModel   := ParamIXB[1]
		cIdPonto := ParamIXB[2]
		cIdModel := ParamIXB[3]

		do case

			//na validação total do formulario
			case cIdPonto == "FORMPOS" 
				If cIdModel == 'SF7MASTER'
					INTTEK(oModel:GetOperation())
				EndIf
				
			case cIdPonto == "MODELCOMMITTTS"
				INTTEK(oModel:GetOperation())
				
			Case cIdPonto == "MODELPOS"
			
				//Verifica se o grupo de tributação esta em algum produto
				//*******************************************************
				If oModel:GetOperation() == 5
					xRetorno := MT540VLEXC(M->F7_GRTRIB)
				EndIf
				//*******************************************************
			
			case cIdPonto == "BUTTONBAR"

				xRetorno := {}

		endcase

	EndIF

return xRetorno




Static Function INTTEK(nOpera)
Local lOpcao	:= .T.
Local cXEmp		:= ""
Local cXFil		:= ""
Local cAlZ16	:= ""
Local cQuery	:= ""   
Local aAreaSF7  := GetArea()  
Local cFilADK   := Space(TamSx3("ADK_FILIAL")[1])
	
	// -> Apenas executar o processo a baixo, se a filial 'é um restaurante'
	If !u_IsBusiness()  
		RestArea(aAreaSF7)
		Return
	Endif

	// -> Apenas executar o processo a baixo, se a filial 'é um restaurante'
	dbSelectArea("ADK")
	ADK->( dbOrderNickName("ADKXFILI") )
	ADK->(dbGoTop())
	ADK->(dbseek(cFilADK+cFilAnt)) 

	cXEmp := ADK->ADK_XEMP  
	cXFil := ADK->ADK_XFIL 

	If nOpera == 3 .Or. nOpera == 4
	
			//Busca Produtos relacionados ao Grupo
			//************************************
			cQuery := "	SELECT B1_COD, Z16.R_E_C_N_O_ REGNO  "          + CRLF
			cQuery += "	FROM " + RetSqlName("SB1") + " SB1 "            + CRLF
			cQuery += "	INNER JOIN " + RetSqlName("Z13") + " Z13 ON "   + CRLF
			cQuery += "	        Z13_FILIAL = '" + xFilial("Z13") + "' " + CRLF
			cQuery += "	    AND Z13_COD    = B1_COD "                   + CRLF
			cQuery += "	    AND Z13.D_E_L_E_T_ = ' ' "                  + CRLF
			cQuery += "	INNER JOIN " + RetSqlName("Z16") + "  Z16 ON "  + CRLF
			cQuery += "			Z16_FILIAL     = B1_FILIAL "            + CRLF
			cQuery += "		AND Z16_GRPTRI     = B1_GRTRIB "            + CRLF
			cQuery += "		AND Z16_COD        = B1_COD "               + CRLF
			cQuery += "	    AND Z16_XATIVO     = 'S' "                  + CRLF
			cQuery += "		AND Z16.D_E_L_E_T_ = ' ' "                  + CRLF
			cQuery += "	WHERE "                                         + CRLF
			cQuery += "	        B1_FILIAL = '" + xFilial("SB1") + "' "  + CRLF
			cQuery += "	    AND B1_GRTRIB = '" + M->F7_GRTRIB + "' "    + CRLF
			cQuery += "	    AND B1_TIPO  IN ('PA','PI','ME')       "    + CRLF   // Conforme item 122 da MIT006
			cQuery += "	    AND SB1.D_E_L_E_T_ = ' ' "                  + CRLF
	
			cQuery := ChangeQuery(cQuery)
			cAlZ16 := MPSysOpenQuery(cQuery)		
			
			While !(cAlZ16)->(Eof())	
			
				Z16->(dbGoTo((cAlZ16)->REGNO))
	
				Reclock("Z16",.F.)
				Z16->Z16_XSTINT		:= "P"
				Z16->Z16_XEMP		:= cXEmp
				Z16->Z16_XFIL		:= cXFil
				Z16->(MsUnlock())
			
				(cAlZ16)->(dbSkip())
			
			EndDo
		
			(cAlZ16)->(dbCloseArea())
			
	ElseIf nOpera == 5
	
		//Busca Produtos relacionados ao Grupo
		cQuery := "	SELECT Z16.R_E_C_N_O_ REGNO " + CRLF  
		cQuery += "	FROM " + RetSqlName("Z16") + " Z16 " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "			Z16_FILIAL = '" + xFilial("Z16") + "' " + CRLF 
		cQuery += "		AND Z16_GRPTRI = '" + M->F7_GRTRIB + "' " + CRLF 
		cQuery += "		AND Z16.D_E_L_E_T_ = ' ' " + CRLF 

		cQuery := ChangeQuery(cQuery)
		cAlZ16 := MPSysOpenQuery(cQuery)		
		
		While !(cAlZ16)->(Eof())	
	
		Z16->(dbGoTo((cAlZ16)->REGNO))
	
			Reclock("Z16",.F.)
			Z16->(dbDelete())
			Z16->(MsUnlock())
	
			(cAlZ16)->(dbSkip())
		
		EndDo
			
	EndIf
    
	RestArea(aAreaSF7)

Return

/*/{Protheus.doc} MT540EXC
//TODO Função para validar exclusão
@author Mario L. B. Faria
@since 09/05/2018
@version 1.0
@return lRet, .T. ou .F.
@param cGrpTrib, characters, Grupode Tributação
@type function
/*/
Static Function MT540VLEXC(cGrpTrib)

	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cAlSB1	:= ""
	
	cQuery += "	SELECT R_E_C_N_O_ REGNO " + CRLF
	cQuery += "	FROM " + RetSqlName("Z16") + " " + CRLF
	cQuery += "	WHERE " + CRLF
	cQuery += "	        Z16_FILIAL = '" + xFilial("SB1") + "' " + CRLF
	cQuery += "	    AND Z16_GRPTRI = '" + cGrpTrib + "' " + CRLF
	cQuery += "	    AND Z16_XATIVO != 'N' " + CRLF
	cQuery += "	    AND D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "	    AND ROWNUM <= 1 " + CRLF	
	
	cQuery := ChangeQuery(cQuery)
	cAlSB1 := MPSysOpenQuery(cQuery)
	
	If !(cAlSB1)->(Eof())
		Help("",1,"Produtos",,"Este Grupo de Tributação esta sendo utilizado na integração com Teknisa. Não é possivel excluir.",4,1)
		lRet := .F.
	EndIf
	
	(cAlSB1)->(dbCloseArea())
		
Return lRet
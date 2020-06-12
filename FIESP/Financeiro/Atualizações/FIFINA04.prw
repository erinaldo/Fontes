/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºFuncao    ³FIFINA04		 ºAutor  ³Ligia Sarnauskas	  º Data ³ 06/01/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa utilizado na Consulta Padrao FILSET (especifico)        º±±
±±º          ³ utilizado para filtrar os caixinhas que o usuário pode          º±±
±±º          ³ acessar para digitar as despesas.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³																   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³															       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FIFINA04()

Local aArea	     := GetArea()
	Local clFilt	:= ""
	Local clQuery	:= ""
	Local clCodCx	:= ""
	_cUsuario:=__CUSERID
	
   Dbselectarea("SZF")
   Dbsetorder(1)
   If Dbseek(xFilial("SZF")+_cUsuario)
      _cCusto:=SZF->ZF_CPRINCI
   Endif


	clQuery	:= "SELECT ET_CODIGO FROM "+ RetSqlName("SET")+" WHERE ET_CC = '" + _cCusto + "' AND ET_SITUAC <> '1' "	
	clQuery := ChangeQuery(clQuery)
	
	If Select("QRYSET") >0 
		QRYSET->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,clQuery),"QRYSET",.T.,.T.)
	
	While QRYSET->(!EOF())
		If Empty(clCodCx)
			clCodCx := AllTrim(QRYSET->ET_CODIGO)
		Else
			clCodCx += "|"+AllTrim(QRYSET->ET_CODIGO)
		EndIf     
		QRYSET->(DbSkip())
	EndDo
	QRYSET->(DbCloseArea())
	
	clFilt := " AllTrim(SET->ET_CODIGO) $ '"+clCodCx+ "' " 
	
	
RestArea(aArea)
	
Return clFilt
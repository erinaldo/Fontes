/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
���Funcao    �FT560FIL		 �Autor  �Ligia Sarnauskas	  � Data � 06/01/14    ���
������������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada de filtro do browse de movimentos de caixinha   ���
������������������������������������������������������������������������������͹��
���Uso       �			                                                       ���
������������������������������������������������������������������������������͹��
���Parametros�																   ���
������������������������������������������������������������������������������͹��
���Retorno   �															       ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
User Function FT560FIL()

	Local clFilt	:= ""
	Local clQuery	:= ""
	Local clCodCx	:= ""
	_cUsuario:=__CUSERID
	_cUsuCx:=GetMv("FI_USUCX",,.F.)
   
 If _cUsuario $ _cUsuCx
 clFilt	:= ""
 Else
   Dbselectarea("SZF")
   Dbsetorder(1)
   If Dbseek(xFilial("SZF")+_cUsuario)
      _cCusto:=SZF->ZF_CPRINCI
   Endif


	clQuery	:= "SELECT ET_CODIGO FROM "+ RetSqlName("SET")+" WHERE ET_CC = '" + _cCusto + "' "	
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
	
	clFilt := " AllTrim(SEU->EU_CAIXA) $ '"+clCodCx+ "' " 
	Endif
Return clFilt
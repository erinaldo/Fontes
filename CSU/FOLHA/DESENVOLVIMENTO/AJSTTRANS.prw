# Include "protheus.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Funcao   � AJSTTRANS� Autor � Silvano Franca     � Data �04/02/2010   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta a data de transferencia do funcionario.             ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function AjstTrans()

Processa({|a| AjstTrans1()},"Aguarde","Atualizando data da transfer�ncia...")      

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Funcao   �AJSTTRANS1� Autor � Silvano Franca     � Data �04/02/2010   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta a data de transferencia do funcionario.             ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

Static Function AjstTrans1()
Local dDtTrans 
Local nCount := 0

DbSelectArea("SRA")
DbSetOrder(1)
DbGoTop()     
ProcRegua(SRA->(RecCount()))
   
While SRA->(!EOF())
	IncProc(SRA->RA_MAT + " - "+ SRA->RA_NOME)            
	cQuery := " SELECT TOP 1 RA.RA_FILIAL, RA.RA_MAT, RA.RA_NOME,		"
	cQuery += " RA.RA_DTTRANS, RE.RE_FILIAL, RE.RE_MATP, RE.RE_DATA		"
	cQuery += " FROM "+RetSQLName("SRA")+" RA, "+RetSQLName("SRE")+" RE"
	cQuery += " WHERE RA.RA_FILIAL 		= '"+SRA->RA_FILIAL+"' 			"  
	cQuery += "    AND RA.RA_MAT 		= '"+SRA->RA_MAT+"' 			"
	cQuery += "    AND RE.RE_MATP 		=* RA.RA_MAT 					"
	cQuery += "    AND RE.RE_FILIALD <> RE.RE_FILIALP 					"
	cQuery += "    AND RA.D_E_L_E_T_ 	= '' 							"
	cQuery += "    AND RE.D_E_L_E_T_ 	= '' 							"
	cQuery += " ORDER BY RE.RE_DATA DESC 								"   
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRB", .T., .F. )
	
	cQuery := ''
	
	DbSelectArea("TRB")
    if !Empty(TRB->RE_DATA)
		Reclock("SRA",.F.)
			SRA->RA_DTTRANS := StoD(TRB->RE_DATA)
		msunlock()
    Endif
	TRB->(DbCloseArea())    
	SRA->(DbSkip())
EndDo
	
Return()

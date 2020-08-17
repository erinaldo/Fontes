#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSGCTG01  �Autor  � Renato Carlos      � Data �  Abr/2012   ���
�������������������������������������������������������������������������͹��
���Desc.     �Execblock acionado atraves do campo X2_ROTINA da tabela CN9 ���
���          �no momento da inicializa��o da rotina de contratos.         ���
���          �Serve para alterar a situa��o dos contratos com data final  ���
���          �+30 dias, menor que a data do sistema.                      ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSGCTG01()

Local _aArea   := GetArea()
Local _dtAtu   := Date()
Local _cQuery  := ""
Local _cAlias  := "TMPCN9"

_cQuery	:= " SELECT CN9_FILIAL,CN9_NUMERO,CN9_REVISA,CN9_SITUAC,CN9_DTINIC,CN9_DTFIM,CN9_DTENCE "
_cQuery	+= " FROM "+RetSqlName("CN9")+" "
_cQuery	+= " WHERE CN9_SITUAC = '05' "
_cQuery	+= " AND CN9_DTFIM < '"+DTOS(_dtAtu)+"' "
_cQuery	+= " AND CN9_DTENCE = ''"
_cQuery	+= " AND D_E_L_E_T_ <> '*'"

U_MontaView( _cQuery, _cAlias )

DbSelectArea("CN9")
DbSetOrder(1) //CN9_FILIAL,CN9_NUMERO,CN9_REVISA
DbGotop()

DbSelectArea(_cAlias)
DbGotop()

Begin Transaction

	While (_cAlias)->(!Eof())
	 	
	 	If CN9->(DbSeek((_cAlias)->CN9_FILIAL+(_cAlias)->CN9_NUMERO+(_cAlias)->CN9_REVISA))
			If (CN9->CN9_DTFIM + 15) < _dtAtu     // Alterado conforme solicita��o da Sabrina Araujo Jarrouj OS 0253/14
				CN9->(RecLock("CN9",.F.))
					CN9->CN9_SITUAC := '08' // Finalizado
					CN9->CN9_DTENCE := Date()// Data Server			
				CN9->(MsUnlock())
			EndIf	       
	    EndIf

		(_cAlias)->(DbSkip())
	EndDo

End Transaction

RestArea(_aArea)

Return()
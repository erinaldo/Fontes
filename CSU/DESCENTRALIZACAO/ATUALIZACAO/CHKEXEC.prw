#INCLUDE "TOTVS.CH"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CHKEXEC	�Autor  �Douglas David       � Data �  06/23/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloquear acesso com build diferente de				        ���
���          � 7.00.131227A-20171124                                      ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CHKEXEC()

Local Build := cValtoChar( GetBuild(.T.))
Local cTPRMT:= U_tstGetRmtT()

If cTPRMT <> 5
	
	If Build <> "7.00.131227A-20171124"
		
		MsgInfo("Por favor, entrar em contato com o suporte local para atualiza��o" +;
		" do Atalho Sistema Totvs Microsiga Protheus" , 'Incompatibilidade de Vers�o!' )
		
		Return (.F.)
	Endif
	
Endif

Return


USER FUNCTION tstGetRmtT()
Local cLib

cLib := GetRemoteType(@cLib)

RETURN(cLib)                 

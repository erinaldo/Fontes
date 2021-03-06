#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |PMA220PL  �Autor  �Douglas David      � Data �  12/06/15    ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validar a linha digitada no          ���
���          � planejamento.                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Modulo PMS                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PMA220PL()

Local cTxtBlq
Local _xJust    := M->AFK_XJUSTI
Local lContinua := U_VldCTBg( M->AFK_ITEMCT, M->AFK_CC, M->AFK_CLVL, Nil )

If lContinua .And. Len(AllTrim(_xJust)) < GetNewPar('MV_X_MEMSC',15)
	cTxtBlq := "O tamanho m�nimo do MEMO dever� ser "+AllTrim(Str(GetNewPar('MV_X_MEMSC',15)))+" caracteres."
	Aviso("MEMO",cTxtBlq,;
	{"&Fechar"},3,"Tamanho M�nimo do MEMO",,;
	"PCOLOCK")
	lContinua := .f.
EndIf

Return( lContinua )

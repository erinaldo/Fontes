
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CN110CPG  �Autor  �TOTVS               � Data �  08/23/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para pegar a Cond.Pgto escolhida na rotina���
���          � Cronograma Financeiro.                                     ���
���          � Tratamos atraves de arquivo LOG para usarmos no ponto      ���
���          � Entrada CN110PAC                                           ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CN110CPG()

_aCpg := ACLONE(PARAMIXB) //{nVlCompet,nTotPlan,cCondPg,dPrevista,dComp,nVgContrato}

AutoGrLog(__CUSERID+";"+_aCpg[3])
_cFileog := NomeAutoLOg()
If _cFileog <> nil
	__CopyFile("\system\"+_cFileog,"\system\"+__CUSERID+".log")
	ferase("\system\"+_cFileog)
EndIf

Return
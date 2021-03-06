#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �P530EWF   �Autor  �Microsiga           � Data �  23/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para envio de e-mail de aprovacao/reprovacao de conting.���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function P530EWF()
Local _aDados  := ParamIXB[1]
Local _aEmail  := ParamIXB[2]

IF Len(_aDados) == 0
	Return()
ENDIF

_cFilial := _aDados[1,2]
_cCodCTG := _aDados[1,3]
_cCodUSR := _aDados[1,8]
_cDtTime := Dtoc(_aDados[1,10])+" - Hora: "+_aDados[1,11]

For i := 1 to Len(_aEmail)
	_cBody := "Prezado Colaborador,"+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Foi gerada na empresa/filial "+_cFilial+" a conting�ncia Nr. "+_cCodCTG+" para sua aprova��o."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Data da Solicita��o : "+_cDtTime+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Solicitante : ("+_cCodUSR+") "+Alltrim(UsrRetName(_cCodUSR))+" - "+UsrFullName(_cCodUSR)
	ACSendMail( ,,,,_aEmail[i],"Aviso de Contingencia",_cBody)
Next

Return()

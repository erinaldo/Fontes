#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SZKDATA � Autor � Patricia Fontanezi� Data �  05/03/13      ���
�������������������������������������������������������������������������͹��
���Descricao �  Validacao na digitacao de meses e ano no campo ZK_VENCTO  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/


USER FUNCTION SZKDATA()    

Local _cRet		:= .T.  
Local _aArea	:= GetArea()   
Local _cMes		:= SUBSTR(M->ZK_VENCTO,1,2)
Local _cAno		:= SUBSTR(M->ZK_VENCTO,4,4)

IF M->ZK_VENCTO <> "  /    " 
	IF VAL(_cMes) < 01 .OR. VAL(_cMes) > 12
		MSGINFO("M�s Incorreto. Digite novamente !") 
		_cRet	:= .F.
	ELSE
		IF VAL(_cAno) < 2012 .OR. VAL(_cAno) > 2100
			MSGINFO("Ano Incorreto. Digite novamente !")
			_cRet	:= .F.
		ENDIF
	ENDIF
ENDIF

RestArea(_aArea)

RETURN(_cRet)      



/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � POSCONTC  � Autor � Bruno Massareli  � Data � 23/08 /2006   ���
��������������������������������������������������������������������������͹��
���Descricao � Buscar a conta cont�bil referente ao seu grupo de centro de ���
���            custo tomando com referencia uma natureza cadastrada. 	   ��� 
��������������������������������������������������������������������������͹��
���Uso       � CSU - CardSystem S.A                                        ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function POSCONTC()


_cArea    := getarea()
_cConta   := " "
_cNaturez := " "
_cCcusto  := " "
_cGrupo   := " " 

If SE2->E2_MULTNAT <> "1"
 	If SE2->E2_TIPOPA<>"1"
 		_cNaturez := SE2->E2_NATUREZ
	Else
 		_cNaturez := SE2->E2_NATURPA	
	Endif
	
	_cCcusto  := SE2->E2_CCUSTO
   	    	   	
Else                           
	_cNaturez := SEZ->EZ_NATUREZ
	_cCcusto  := SEZ->EZ_CCUSTO
  
Endif 

DbSelectArea("CTT")
Dbsetorder(1)
DbSeek(xFilial()+_cCcusto,.f. ) 

If Found()
    _cGrupo := CTT->CTT_GRUPO
Else
	Alert("Centro de Custo "+ALLTRIM(_cCcusto)+" nao cadastrado")
EndIf


DbSelectArea("SED")
Dbsetorder(1)
DbSeek(xFilial()+_cNaturez,.f. ) 

If Found()
	
	Do Case
		
		Case _cGrupo == "01"
			_cConta := SED->ED_CCDESP
	
		Case _cGrupo == "02"
			_cConta := SED->ED_CCCUST

		Case _cGrupo == "00"
			_cConta := SED->ED_CSCONTA

		Otherwise
			MsgAlert("A Conta Contabil "+Alltrim(_cConta)+" n�o pertence a um Grupo de Centro de Custo.")
			
	EndCase

Else
    MsgAlert("Natureza n�o encontrada.")

Endif

restarea(_cArea)	

Return _cConta
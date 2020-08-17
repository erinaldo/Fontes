
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � POSCONSE5  � Autor � Bruno Massareli  � Data � 23/08 /2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Buscar a conta cont�bil referente ao seu grupo de centro de ���
���            custo para movimenta��o banc�ria tomando como referencia uma��� 
���            natureza cadastrada.                                        ���  
���            Ponto de Disparo: Lan�amento Padr�o 508/510Importacao de    ���           
���            Solicitacao de Compras Geradas no Sistema.     		  	   ���
���          � 								                               ���
��������������������������������������������������������������������������͹��
���Uso       � CSU - CardSystem S.A                                        ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function POSCONSE5()


_cArea    := getarea()
_cConta   := " "
_cNaturez := " "
_cCcustod := " "
_cCcustoc := " "
_cGrupo   := " " 
_cRecSE5 := " "

_cRecSE5   := SE5->E5_RECPAG 
_cNaturez  := SE5->E5_NATUREZ
_cCcustod  := SE5->E5_CCD
_cCcustoc  := SE5->E5_CCC

DbSelectArea("CTT")
Dbsetorder(1)

If _cRecSE5== "P"

	DbSeek(xFilial()+_cCcustod,.f. ) 

Else

	DbSeek(xFilial()+_cCcustoc,.f. ) 

Endif

If Found()
	_cGrupo := CTT->CTT_GRUPO

Else
	Alert("Centro de Custo "+ALLTRIM(_cCcustod)+" nao cadastrado ou n�o preenchido.")

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

		Case _cConta == " "
			MsgAlert("Conta para lan�amento n�o cadastrada no Cadastro de Naturezas")
		
		Otherwise
			MsgAlert("A conta " +ALLTRIM(_cConta)+" n�o pertence a um Grupo de Centro de Custos.")
    		_cConta := " "
	
	EndCase
         
Endif

restarea(_cArea)	
	
Return _cConta
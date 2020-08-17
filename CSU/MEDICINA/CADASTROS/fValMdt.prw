#Include 'Protheus.ch'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FVALMDT   � Autor � Isamu K.           � Data � 30/10/2017  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o dos lan�amento de Atestado M�dico no m�dulo de   ���
���          � Medicina e Seguran�a  do Trabalho                          ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU                                           ���
�������������������������������������������������������������������������ͼ��                 3
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function fValMdt()

Local cQry                  
Local cMatAtu := M->TNY_NUMFIC
Local cCidAtu := M->TNY_CID 
Local dDataRef:= M->TNY_DTINIC             
Local nDiasAf_:= M->TNY_QTDIAS
Local lExec_  := .T. 

dDataRef -= 59                     

cQry := " SELECT SUM(TNY_QTDIAS) AS NATEST "
cQry += " FROM "+RetSqlName("TNY")+ " "
cQry += " WHERE TNY_NUMFIC ='"+cMatAtu+"' AND "
cQry += " TNY_CID = '"+cCidAtu+"' AND "
cQry += " TNY_DTFIM  >= '"+DTOS(dDataRef)+"' "
cQry += " AND "+RETSQLNAME("TNY")+".D_E_L_E_T_ <> '*' "

//�������������������������������Ŀ
//�Fecha alias caso esteja aberto �
//���������������������������������
If Select("TMY") > 0
	DBSelectArea("TMY")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQrY),"TMY",.F.,.T.)

If Tmy->nAtest+nDiasAf_ > 15
   lExec_ := MsgNoYes("J� existem outros Atestados com o mesmo CID, dentro do prazo de 60 dias. Deseja continuar ? ")     
   If !lExec_
      Alert("Clique na op��o 'FECHAR' e saia da rotina")
   Endif    
Endif   


Return(lExec_)



Return


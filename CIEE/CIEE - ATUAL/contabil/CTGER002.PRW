#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTBGER002 � Autor � CLAUDIO BARROS     � Data �  14/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina desenvolvida para gravar os numeros de lotes conta- ���
���          � beis conforme usuario cadastrado nas senhas de usuarios    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CTGER002()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cCargo:= ""
Local cRet	:= ""
Local aArea := GetArea()

cCargo := PswRet()

If !Empty(cCargo[1][13])
   cRet := cCargo[1][13]
Else

   IF ALLTRIM(FUNNAME()) == "MATA103"
     cRet := "8810"
   ELSE
      cRet := "8850"
   ENDIF

Endif      
                        
RestArea(aArea)
Return(cRet)


User Function LOTECONT()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cCargo:= ""
Local cRet	:= ""
Local aArea := GetArea()

cCargo := PswRet()

If !Empty(cCargo[1][13])
   cRet := cCargo[1][13]
Else
   cRet := "008810"
Endif      

RestArea(aArea)
Return(cRet)


User Function IICS(cPar1)
Local lRet := IsInCallStack(cPar1)
Return lRet

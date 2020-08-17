#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GATINTER  � Autor � Isamu Kawakami     � Data �  08/10/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para preencher campo RA_MDDTIN (Dt.Inclusao no Plano��
���          � Intermedica, conf. a funcao: Operacionais 90 dias)          ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function GatInter

Local aArea   := GetArea()
Local dMdDtin := Ctod("//")
Local cPlanos := Alltrim(GetMv("MV_PLAINT",,"27/35/36"))	

If M->Ra_AsMedic $ cPlanos
	If AllTrim(Posicione("SRJ",1,xFilial("SRJ")+M->Ra_CodFunc,"RJ_NIVEL")) == "O"
	   dMdDtin :=STOD(ANOMES(M->RA_ADMISSA+120)+"01")
	Else
	   dMdDtin := M->Ra_Admissa
	Endif
Endif

RestArea(aArea)

Return(dMdDtin)	                       

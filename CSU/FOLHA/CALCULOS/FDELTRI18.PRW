#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FDELTRI18 � Autor �Isamu Kawakami      � Data �  14/08/2013 ���
�������������������������������������������������������������������������͹��
���Descricao � Deleta eventos de Trienio da filial 18, para funcionarios  ���
���          � sem direito ap�s 10/2012.                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fDelTri18


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cEve    := aCodFol[003,1] //evento 367
Local cMesAdm := StrZero(Month(Sra->Ra_Admissa),2)
Local cAnoAdm := StrZero(Year(Sra->Ra_Admissa)+3,4)

//incluso pela OS 4035-14  By Isamu Kawakami 
If Sra->Ra_Filial <> "18"
   Return
Endif

If fBuscaPd(cEve) > 0
	
	If Stod(cAnoAdm+cMesAdm+"01") <= Stod("20121001")
		Return
	Else
		
		fDelPD(cEve)
		
	Endif
	
Endif


Return

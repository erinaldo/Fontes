#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ASSIS_RE � Autor � Alexandre Souza       � Data � 05.09.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula Assistencial em Dias - Para uso em Porto Alegre    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RDMake ( DOS e Windows )                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para CSU                                        ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   �chamad�  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Alexandre  � 5/9/07 � 2720 � Criado a partir do Fonte ASSIS_RE, desen-���
���            �        �      � volvido inicialmente pelo Analista Isamu ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function Assis_DIA()

//Montando Variaveis de Trabalho
Local _MesDesc  := Space(6)
Local _DiasDesc := 0
Local _FatorDiv := 0
Local _VerbaInf	:= 0
Local _MesBase  := Space(6)

//Localiza Parametros  
dBSelectArea("RCC") 
dBSetOrder(1)
RCC->(dbSeek(Space(2) + "U009" + Sra->Ra_Filial)) 
  
While !Eof() .and. Rcc->Rcc_Fil == Sra->Ra_Filial

 _MesDesc := Subs(RCC->RCC_Conteu,1,6)
 _DiasDesc:= Val(Subs(RCC->RCC_Conteu,7,2))
 _FatorDiv:= Val(Subs(RCC->RCC_Conteu,9,2))
 _VerbaInf:= Subs(RCC->RCC_Conteu,13,3)

If C__Roteiro == "FOL"
  _MesBase := MesAno(dDataBase)
ElseIf C__Roteiro == "RES"
  _MesBase := MesAno(dDataDem)
Endif       

If  Subs(_MesDesc,3,4)+subs(_MesDesc,1,2) == _MesBase                    
	If Sra->Ra_Sitfolh # "D" .and. Sra->Ra_Assist_ =="1"
    FgeraVerba(_VerbaInf,SalDia*(_DiasDesc/_FatorDiv),,,,,,,,,.T.)
	Endif     
Endif     	   

dbSkip()

EndDo
  
Return("")
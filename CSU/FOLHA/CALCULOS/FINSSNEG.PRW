#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � fInssNeg � Autor � Silvano Franca        � Data � 19.08.10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria Verba de Base de INSS Negativo                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RDMake ( DOS e Windows )                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Protheus 10 - CSU                                          ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function fInssNeg()


//Montando Variaveis de Trabalho
Private nValBInss_		:= 0
Private nValBInss13_	:= 0
Private nBinss_			:= 0   
Private nBinss13_		:= 0   

//Processamento  
If c__Roteiro $ "131-132" 
    //Apura INSS 13o Salario
	aEval(aPd,{|X| SomaInc(X,4,@nBinss13_,12,"S",,,,,aCodFol)})
Else
    //Apura INSS Salario
	aEval(aPd,{|X| SomaInc(X,4,@nBinss_,12,"N",,,,,aCodFol)})
Endif

//Calculo
If nBinss13_ < 0 
   nValBInss13_ := (nBinss13_ * (-1))
ElseIf nBInss_ < 0 
   nValBInss_ := (nBinss_ * (-1))
Endif 


If nValBInss13_ > 0 
   fGeraVerba('701',nValBInss13_,,,,,,,,,.T.)
Endif 
      
If nValBInss_ > 0 
   fGeraVerba('700',nValBInss_,,,,,,,,,.T.)
Endif       

Return(0)
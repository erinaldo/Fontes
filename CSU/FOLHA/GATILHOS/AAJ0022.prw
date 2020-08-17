/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Fun��o    � GPM040CO � Autor � Adalberto Althoff          � Data � 14/02/05 ���
������������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao do inicio do calculo de rescisao                      ���
������������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico CSU                                                  ���
������������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.                  ���
������������������������������������������������������������������������������Ĵ��
���Programador      � Data   �  OS  �  Motivo da Alteracao                     ���
������������������������������������������������������������������������������Ĵ��
��� Isamu           �27/04/05�095005� idade do Funcion�rio                     ���
���                 �        �      � Caso tenha 40 anos ou mais, ter� mensagem���
��� Isamu           �26/06/06�160606� Verifica se o funcion�rio � portador de  ���
���                 �        �      � deficiencia fisica                       ���                                       
��� Sandra          �24/07/06�160606� Verifica se funcionario tem estabilidade ���                                       
���                 �        �      � e o motivo.                              ���                                       
��� Alexandre Souza �18/07/07�      � Verifica se funcionario tem os dois per�-���                                       
���                 �        �      � odos                                     ���                                       
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/

User Function GPM040CO


_aArea    := GetArea()
_Valida   := .T.
_DataDem  := dDataDem1    
_DataEst  := SRA->RA_DTVTEST 
_motivo   := ' '


IF SRA->RA_VCTOEXP >= DDATADEM1 .AND. !(CTIPRES$"08,14")
	_Valida := MSGYESNO("Confirma rescis�o de funcion�rio em experi�ncia com c�d "+ctipres+" ?")
endif

IF SRA->RA_VCTEXP2 >= DDATADEM1 .AND. !(CTIPRES$"08,14")
	_Valida := MSGYESNO("Confirma rescis�o de funcion�rio em experi�ncia com c�d "+ctipres+" ?")
endif


If (_DataDem - Sra->Ra_Nasc)  > 14610            
	_Valida := MsgYesNo("O Funcion�rio tem mais de 40 anos !!!. Deseja continuar ??? ")
Endif     

If Sra->Ra_DefiFis == "1"
	_Valida := MsgYesNo("O Funcion�rio � portador de Deficiencia Fisica !!!. Deseja continuar ??? ")
Endif

//OS 1606/06 - SRP 
If _DataEst >= _Datadem 
   If SRA->RA_MOTESTB = "1"
      _motivo := "Ferias" 
   Elseif SRA->RA_MOTESTB = "2"
	  _motivo := "Maternidade" 
   Elseif SRA->RA_MOTESTB = "3"
	  _motivo := "CIPA" 
   Elseif SRA->RA_MOTESTB = "4"
	  _motivo := "Ac. Trabalho" 
   Elseif SRA->RA_MOTESTB = "5"
	  _motivo := "Doenca" 
   Elseif SRA->RA_MOTESTB = "6"
	  _motivo := "Aposentadoria"    
   Elseif SRA->RA_MOTESTB = "7"
	  _motivo := "Outros Motivos"
   Elseif SRA->RA_MOTESTB = "9"
	  _motivo := "CityHall" 	  
   Else 
      _motivo := "N�o Informado"
   Endif 	                             

   _msg := "Funcionario com data de Estabilidade at�: " + dtoc(SRA->RA_DTVTEST)+ ". Motivo Cadastro: " + _motivo +". Verifique!!! "
   _Valida := MsgYesNo(_msg + "Deseja continuar ?")

Endif   

RestArea(_aArea) //Retorna o ambiente inicial

Return(_Valida) 
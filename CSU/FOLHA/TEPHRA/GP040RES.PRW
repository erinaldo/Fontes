#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GP040RES � Autor � 	Isamu Kawakami      � Data � 05/02/13 ���
���Programa  GP040RES � Autor � Romay Oliveira     � Data �  01/2015 	  ���
�������������������������������������������������������������������������͹��
���Descri��o � P.E. para incluir dados no campo RA_XULTDIA                ���
���Descricao �Ponto de Entrada ao realizar o calculo de rescisao		  ���
���			 Criacao da tabela ZP1 de integracao com o Tephra			  ���
���																		  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico CSU		                                      ���
�������������������������������������������������������������������������͹��
���Obs		 �Inova Solution											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 

User Function GP040RES() 

// copia de PE antigo para manter funcionalidade   
// adicionado funcionalidade de integracao com tephra   

//incluso pela OS 2816/16 Isamu K.
If cEmpAnt == "06"
   Return
Endif

       
If Empty(SRA->RA_XULTDIA)//se for calculo e o campo n�o estiver preenchido
	
	SRA->( RecLock( "SRA" , .F.  ) )
	   SRA->RA_XULTDIA  := dDataDem  
	SRA->( MsUnLock() )
	
Endif  

	DbSelectArea("SR6")
	DbSetOrder(1)
	dbgotop()
	 
	If 	DbSeek( xFilial("SR6") + SRA->RA_TNOTRAB )

		cDescTurno := SR6->R6_DESC                                                                      

	EndIf         

Begin Transaction

  	RecLock( "ZP1", .T. )
		
		ZP1->ZP1_FILIAL := xFilial( "ZP1" )
		ZP1->ZP1_NOME 	:= SRA->RA_NOME
		
		ZP1->ZP1_SEXO   := SRA->RA_SEXO
		ZP1->ZP1_ESTCIV := SRA->RA_ESTCIVI
		ZP1->ZP1_NATURA := SRA->RA_NATURAL
		ZP1->ZP1_NACION := SRA->RA_NACIONA
        
        ZP1->ZP1_MAT    := SRA->RA_MAT
		ZP1->ZP1_SITFOL := SRA->RA_SITFOLH
		ZP1->ZP1_CATFUN := SRA->RA_CATFUNC
		ZP1->ZP1_CC 	:= SRA->RA_CC
		ZP1->ZP1_CODFUN := SRA->RA_CODFUNC
		ZP1->ZP1_ADMISS := SRA->RA_ADMISSA
		ZP1->ZP1_DEMISS := SRA->RA_DEMISSA
		ZP1->ZP1_TEL  	:= SRA->RA_TELEFON
		ZP1->ZP1_CIC    := SRA->RA_CIC

		ZP1->ZP1_RG     := SRA->RA_RG

		ZP1->ZP1_TTRAB  := SRA->RA_TNOTRAB
		ZP1->ZP1_DESCTT := cDescTurno
		ZP1->ZP1_HRSMES := SRA->RA_HRSMES 
		ZP1->ZP1_HRSSEM := SRA->RA_HRSEMAN
		ZP1->ZP1_STATUS := "0" 
		ZP1->ZP1_SEQTAB	:= ZP1->(Recno())
		ZP1->ZP1_DATA	:= dDatabase
		ZP1->ZP1_HORA	:= Time()
		ZP1->ZP1_NASC   := SRA->RA_NASC
		ZP1->ZP1_EQUIPE := SRA->RA_EQUIPE
		ZP1->ZP1_ENDERE := SRA->RA_ENDEREC

		ZP1->ZP1_NUMEND := SRA->RA_NUMENDE

		ZP1->ZP1_COMPLE := SRA->RA_COMPLEM
		ZP1->ZP1_MUNICI := SRA->RA_MUNICIP
		ZP1->ZP1_CEP    := SRA->RA_CEP
		ZP1->ZP1_BAIRRO := SRA->RA_BAIRRO

		ZP1->ZP1_ESTADO := SRA->RA_ESTADO  
		ZP1->ZP1_PAISOR := "BR   "

	MsUnlock() 
	
End Transaction	

Return()
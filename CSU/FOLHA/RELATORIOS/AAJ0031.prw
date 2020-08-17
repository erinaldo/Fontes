#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AAJ0031   � Autor � ADALBERTO ALTHOFF  � Data �  18/10/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado para atender a OS 3260/05 (cod vr)           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AAJ0031
Processa({|lEnd| AAJ0031Processa(),"(SRA) Processando a altera��o dos c�digos VR..."})

STATIC FUNCTION AAJ0031Processa()
ProcRegua( 2100 )
dbSelectArea("SRA")
dbSetOrder(1)
dbGoTop()

do while RA_FILIAL $ '01*13'
	
	IncProc("(SRA) "+SRA->RA_MAT)
	            
	DO CASE  
		CASE RA_SITFOLH=='D'
			dbSkip()
			LOOP		
		CASE RA_VALEREF=='01' .AND. (RA_HRSMES=180.OR.RA_HRSMES=150.OR.RA_HRSMES=125)
			RecLock( "SRA" , .F. )
			RA_VALEREF := "17"
			MsUnLock()
			dbSkip()
			LOOP
		CASE ( RA_VALEREF=='01' .AND. RA_HRSMES=220 ) .or. RA_VALEREF=='03'
			RecLock( "SRA" , .F. )
			RA_VALEREF := "08"
			MsUnLock()
			dbSkip()
			LOOP             
		CASE RA_VALEREF=='02' .AND. (RA_HRSMES=180.OR.RA_HRSMES=150.OR.RA_HRSMES=125)
			RecLock( "SRA" , .F. )
			RA_VALEREF := "03"
			MsUnLock()
			dbSkip()
			LOOP	         
		CASE RA_VALEREF=='02' .AND. RA_HRSMES=220
			RecLock( "SRA" , .F. )
			RA_VALEREF := "09"
			MsUnLock()
			dbSkip()
			LOOP	
		OTHERWISE
			dbSkip()
	ENDCASE

enddo

Return

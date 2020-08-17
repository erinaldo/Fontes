#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AAJ0031   º Autor ³ ADALBERTO ALTHOFF  º Data ³  18/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado para atender a OS 3260/05 (cod vr)           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AAJ0031
Processa({|lEnd| AAJ0031Processa(),"(SRA) Processando a alteração dos códigos VR..."})

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

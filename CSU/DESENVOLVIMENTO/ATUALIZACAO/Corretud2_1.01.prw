#include "topconn.ch"
#include "rwmake.ch"

User Function Corret2()

Processa({ ||Prep_Infor() } )


Static Function Prep_Infor()
PRIVATE NUM:=0
//SE1

DBSelectArea("SF2")
DBGOTOP()
ProcRegua (Reccount())

WHILE !EOF()
	
	IncProc("Analisando")
	DBSelectArea("SE1")
	DBSetOrder(1)
	If DBSeek(XFILIAL("SE1")+SM0->M0_CODIGO+" "+SF2->F2_DOC,.F.)
		
		While SM0->M0_CODIGO+" "+SF2->F2_DOC == SE1->E1_PREFIXO+SE1->E1_NUM
			
			DBSelectArea("SE1")
			IncProc("Atualisando")
			
			IF DTOS(SF2->F2_EMISSAO)<='20021129'
				
				IF ALLTRIM(SF2->F2_SERIE)=="BA"
					Reclock("SE1",.F.)
					SE1->E1_PREFIXO	:= SM0->M0_CODIGO+"A"
					MsUnlock()
				Endif
				
				IF  ALLTRIM(SF2->F2_SERIE)=="BAR"
					Reclock("SE1",.F.)
					SE1->E1_PREFIXO	:= SM0->M0_CODIGO+"B"
					MsUnlock()
				Endif
				
				IF  ALLTRIM(SF2->F2_SERIE)=="MG"
					Reclock("SE1",.F.)
					SE1->E1_PREFIXO	:= SM0->M0_CODIGO+"C"
					MsUnlock()
				Endif
				
				IF  ALLTRIM(SF2->F2_SERIE)=="PE"
					Reclock("SE1",.F.)
					SE1->E1_PREFIXO	:= SM0->M0_CODIGO+"D"
					MsUnlock()
				Endif
				
				IF  ALLTRIM(SF2->F2_SERIE)=="SP"
					Reclock("SE1",.F.)
					SE1->E1_PREFIXO	:= SM0->M0_CODIGO+"E"
					MsUnlock()
				Endif
				
				IF  ALLTRIM(SF2->F2_SERIE)=="RJ"
					Reclock("SE1",.F.)
					SE1->E1_PREFIXO	:= SM0->M0_CODIGO+"F"
					MsUnlock()
				Endif
			Endif
			num:=num+1
			DBSelectArea("SE1")
			DBSkip()
		Enddo
	Endif
	DBSelectArea("SF2")
	DBSkip()
Enddo


//SE5
PRIVATE NUM1:=0
DBSelectArea("SF2")
DBGOTOP()
ProcRegua (Reccount())

WHILE !EOF()
	
	DBSelectArea("SE5")
	IncProc("Atualisando")
	DBSetOrder(7)
	
	IF DBSeek(xfilial("SE5")+SM0->M0_CODIGO+" "+SF2->F2_DOC,.F.)
		
		While SM0->M0_CODIGO+" "+SF2->F2_DOC==SE5->E5_PREFIXO+SE5->E5_NUMERO
			
			IF SE5->E5_RECPAG=='R'
				IF DTOS(SF2->F2_EMISSAO)<='20021129'
					IF ALLTRIM(SF2->F2_SERIE)=="BA"
						Reclock("SE5",.F.)
						SE5->E5_PREFIXO	:= SM0->M0_CODIGO+"A"
						MsUnlock()
					Endif
					
					IF ALLTRIM(SF2->F2_SERIE)=="BAR"
						Reclock("SE5",.F.)
						SE5->E5_PREFIXO	:= SM0->M0_CODIGO+"B"
						MsUnlock()
					Endif
					
					IF ALLTRIM(SF2->F2_SERIE)=="MG"
						Reclock("SE5",.F.)
						SE5->E5_PREFIXO	:= SM0->M0_CODIGO+"C"
						MsUnlock()
					Endif
					
					IF ALLTRIM(SF2->F2_SERIE)=="PE"
						Reclock("SE5",.F.)
						SE5->E5_PREFIXO	:= SM0->M0_CODIGO+"D"
						MsUnlock()
					Endif
					
					IF ALLTRIM(SF2->F2_SERIE)=="SP"
						Reclock("SE5",.F.)
						SE5->E5_PREFIXO	:= SM0->M0_CODIGO+"E"
						MsUnlock()
					Endif
					
					IF ALLTRIM(SF2->F2_SERIE)=="RJ"
						Reclock("SE5",.F.)
						SE5->E5_PREFIXO	:= SM0->M0_CODIGO+"F"
						MsUnlock()
					Endif
					num1:=num1+1
					
				Endif
			Endif
			DBSelectArea("SE5")
			DBSkip()
		ENDDO
	Endif
	
	DBSelectArea("SF2")
	DBSkip()
EndDo

Alert("SE1..."+STR(NUM))
Alert("SE5..."+STR(NUM1))

Return

#Include 'Protheus.ch'

User Function TSTGEST()

//Gestao
Local lGestao   := ( FWSizeFilial() > 2 ) 	// Indica se usa Gestao Corporativa
Local lQuery 	:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
Local aSelFil 	:= {}
Local aSm0		:= {}
Local nLenFil	:= 0 
Local nRegSM0	:= SM0->(Recno())
Local cFilSm0	:= "" 
Local nInc		:= 0

Private lContrRet	:= .T.

//Gestao
If lQuery
	If lGestao
		aSelFil := FwSelectGC()
	Else
		aSelFil := AdmGetFil(.F.,.F.,"SE2")	
	Endif

	If Empty(aSelFil)
		aSelFil := {cFilAnt}
	Endif

	SM0->(DbGoTo(nRegSM0))

	aSM0 := FR865AbreSM0(aSelFil)
Else
	aSM0 := AdmAbreSM0()
Endif

Return

User Function ADMSELFIL

	aSelFil := AdmGetFil(.F.,.F.,"SE2")

Return(aSelFil)
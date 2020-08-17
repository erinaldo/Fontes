User Function CT1RES()

// ExecBlock CT1RES.
// Data            : 04/03/2004
// Objetivo        : Gerar numeração automatica para O cod reduzido
// Cliente         : CSU Cardsystem.    
	Set Filter to CT1->CT1_CLASSE='2'
	
	_cArea := Alias()
	_nNum  := "00001"
	
	DbSelectArea("CT1")
	
	_nReCT1  := Recno()
	
	DbSetOrder(2)
	DbSeek( xFilial()+"99999")
	
	DbSkip(-1)
	
	_CRES := "99999"
	
	
	If _CRES > CT1->CT1_RES .And. CT1->CT1_RES <> " "
		_nNum1 := CT1->CT1_RES
		_nNum2 := Strzero(Val(_nNum1)+1,5)
		_nNum  := _nNum2
	EndIf
	
	If _nNum == _CRES
		MsgAlert(" Númeração ultrapassou o limite permitido entre em contado com o Administrador do Sistema","Atencao!")
	EndIf
	
	DbSetOrder(2)
	Go _nReCT1
	
	DbSelectArea(_cArea)
	

Return _nNum

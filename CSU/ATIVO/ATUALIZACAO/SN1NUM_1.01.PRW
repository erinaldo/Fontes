User Function SN1NUM()

// ExecBlock SN1NUM.
// Data            : 03/06/2002
// Objetivo        : Gerar numeração automatica para os Bens Incluidos no Ativo Fixo
// Cliente         : CSU Cardsystem.

_cArea := Alias()
_nNum  := SM0->M0_CODIGO +  "00000001"

DbSelectArea("SN1")              

_nRecN1  := Recno()       

DbSetOrder(1)
DbSeek( xFilial()+ SM0->M0_CODIGO + "99999999") 

DbSkip(-1)

_CBASE := SM0->M0_CODIGO +  "99999999"


If _CBASE > SN1->N1_CBASE .And. SN1->N1_CBASE <> " "
	_nNum1 := Subs(SN1->N1_CBASE,3,10)
	_nNum2 := Strzero(Val(_nNum1)+1,8)
	_nNum  := SM0->M0_CODIGO + _nNum2
EndIf 

If _nNum == _CBASE
MsgAlert(" Númeração ultrapassou o limite permitido entre em contado com o Administrador do Sistema","Atencao!") 
EndIf
       
DbSetOrder(1)
Go _nRecN1

DbSelectArea(_cArea)

Return _nNum
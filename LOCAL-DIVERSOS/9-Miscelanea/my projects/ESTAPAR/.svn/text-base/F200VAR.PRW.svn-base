#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200VAR   ºAutor  ³Osmil Squarcine     º Data ³  08/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA PARA TRATAR COBRANCA SEM REGISTRO         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ARK FOODS                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F200VAR()

Local _aValores := ParamIxb[01]
Local _nTamParc := TAMSX3( "E1_PARCELA" )[1]
Local _nTamBco  := TAMSX3( "E1_NUMBCO"  )[1]
Local aRecno    := SE1->( GetArea() )
Local cTabela 	:= "17"
Local cNTitAnt	:= cNumTit

cNumTit := Padl(cNumTit,TamSx3("E1_IDCNAB")[1],"0")	//Corrige o tamanho do campo recebido do arquivo  // Incluido em 14/03/13 do mesmo PE que estava duplicado no projeto

SE1->( DbSetOrder( 1 ) )
If SE1->( DbSeek( xFilial("SE1") + _aValores[1] + Space(_nTamParc-1) + _aValores[3] ) )
	If SE1->E1_SALDO == 0
		nDespes := nDescont := nAbatim := nValRec := nJuros := nMulta := nOutrDesp := nValCc := 0
	EndIf
Else
	SE1->( dbSetOrder( 22 ) )
	If SE1->( DbSeek( xFilial("SE1") + _aValores[4] + Space(_nTamBco-Len(_aValores[4]) ) ) )
		cNumTit := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
		cTipo   := Tabela( cTabela, SE1->E1_TIPO, 1, 2 )
	Else
		RestArea( aRecno )
		cNumTit := cNTitAnt
	EndIf
EndIf


Return

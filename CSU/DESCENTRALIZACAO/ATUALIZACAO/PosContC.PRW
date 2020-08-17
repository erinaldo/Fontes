/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ POSCONTC  º Autor ³ Bruno Massareli  º Data ³ 23/08 /2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Buscar a conta contábil referente ao seu grupo de centro de º±±
±±º            custo tomando com referencia uma natureza cadastrada. 	   º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU - CardSystem S.A                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function POSCONTC()


_cArea    := getarea()
_cConta   := " "
_cNaturez := " "
_cCcusto  := " "
_cGrupo   := " " 

If SE2->E2_MULTNAT <> "1"
 	If SE2->E2_TIPOPA<>"1"
 		_cNaturez := SE2->E2_NATUREZ
	Else
 		_cNaturez := SE2->E2_NATURPA	
	Endif
	
	_cCcusto  := SE2->E2_CCUSTO
   	    	   	
Else                           
	_cNaturez := SEZ->EZ_NATUREZ
	_cCcusto  := SEZ->EZ_CCUSTO
  
Endif 

DbSelectArea("CTT")
Dbsetorder(1)
DbSeek(xFilial()+_cCcusto,.f. ) 

If Found()
    _cGrupo := CTT->CTT_GRUPO
Else
	Alert("Centro de Custo "+ALLTRIM(_cCcusto)+" nao cadastrado")
EndIf


DbSelectArea("SED")
Dbsetorder(1)
DbSeek(xFilial()+_cNaturez,.f. ) 

If Found()
	
	Do Case
		
		Case _cGrupo == "01"
			_cConta := SED->ED_CCDESP
	
		Case _cGrupo == "02"
			_cConta := SED->ED_CCCUST

		Case _cGrupo == "00"
			_cConta := SED->ED_CSCONTA

		Otherwise
			MsgAlert("A Conta Contabil "+Alltrim(_cConta)+" não pertence a um Grupo de Centro de Custo.")
			
	EndCase

Else
    MsgAlert("Natureza não encontrada.")

Endif

restarea(_cArea)	

Return _cConta
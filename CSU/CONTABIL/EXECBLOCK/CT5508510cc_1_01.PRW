User Function CT5CC()

// ExecBlock CT5508510cc
// Data: Nov./2004  - SEA
// Objetivo: Buscar o centro de custo conforme estabelecido na pesquisa da tabela 
//  natureza do título X centro de custo a pagar no arquivo SZ1. Caso a natureza seja 
//  Patrimonial leva c.custo em branco
// Ponto de Disparo: Lançamento Padrão 508/510  
// Cliente: CSU

_cArea    := Alias()
//_cConta   := "INFORMAR CTA CONTAB."
_cNaturez := " "
_cCcusto  := " "
_cGrupo   := " "

  IF SE2->E2_MULTNAT <> "1"
     _cNaturez := SE2->E2_NATUREZ
   	 _cCcusto  := SE2->E2_CCUSTO   	   	
  ELSE                           
     _cNaturez := SEZ->EZ_NATUREZ
   	 _cCcusto  := SEZ->EZ_CCUSTO
  ENDIF 

DbSelectArea("CTT")
Dbsetorder(1)
DbSeek(xFilial()+_cCcusto,.f. ) 

If Found()
    _cGrupo := CTT->CTT_GRUPO
Else
	Alert("Centro de Custo "+ALLTRIM(_cCcusto)+" nao cadastrado")
EndIf


DbSelectArea("SZ1")
Dbsetorder(1)
DbSeek(xFilial()+_cNaturez+_cGrupo,.f. ) 

If Found()
	_cCusto :=_cCcusto
Else
	DbSeek(xFilial()+_cNaturez+'00',.f. ) 
	If Found()
	    _cConta := SZ1->Z1_CCONTAB
		IF left(_cConta,1)=='3'
			_cCusto :=_cCcusto
        Else
			_cCusto :=' '            
		EndIf
	Else
		_cCusto :=_cCcusto
	EndIf
EndIf
DbSelectArea(_cArea)

Return _cCusto
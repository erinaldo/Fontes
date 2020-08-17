User Function CT5508510()

// ExecBlock CT5508510
// Data: SET./2004  - SEA
// Objetivo: Buscar a conta contabil DÉBITO referente a natureza do título X centro de custo a pagar no arquivo SZ1.
// Ponto de Disparo: Lançamento Padrão 508/510  
// Cliente: CSU

_cArea    := Alias()
_cConta   := "INFORMAR CTA CONTAB."
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

If Found().OR.DbSeek(xFilial()+_cNaturez+'00',.f. ) 
    _cConta := SZ1->Z1_CCONTAB
Else
	Alert("E Necessario Cadastrar Conta Contabil para a Natureza/Grupo C.Custo "+ALLTRIM(_cNaturez)+"/"+ALLTRIM(_cGrupo))
EndIf

DbSelectArea(_cArea)

Return _cConta
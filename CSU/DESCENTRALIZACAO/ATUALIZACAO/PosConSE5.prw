
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ POSCONSE5  º Autor ³ Bruno Massareli  º Data ³ 23/08 /2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Buscar a conta contábil referente ao seu grupo de centro de º±±
±±º            custo para movimentação bancária tomando como referencia umaº±± 
±±º            natureza cadastrada.                                        º±±  
±±º            Ponto de Disparo: Lançamento Padrão 508/510Importacao de    º±±           
±±º            Solicitacao de Compras Geradas no Sistema.     		  	   º±±
±±º          ³ 								                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU - CardSystem S.A                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function POSCONSE5()


_cArea    := getarea()
_cConta   := " "
_cNaturez := " "
_cCcustod := " "
_cCcustoc := " "
_cGrupo   := " " 
_cRecSE5 := " "

_cRecSE5   := SE5->E5_RECPAG 
_cNaturez  := SE5->E5_NATUREZ
_cCcustod  := SE5->E5_CCD
_cCcustoc  := SE5->E5_CCC

DbSelectArea("CTT")
Dbsetorder(1)

If _cRecSE5== "P"

	DbSeek(xFilial()+_cCcustod,.f. ) 

Else

	DbSeek(xFilial()+_cCcustoc,.f. ) 

Endif

If Found()
	_cGrupo := CTT->CTT_GRUPO

Else
	Alert("Centro de Custo "+ALLTRIM(_cCcustod)+" nao cadastrado ou não preenchido.")

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

		Case _cConta == " "
			MsgAlert("Conta para lançamento não cadastrada no Cadastro de Naturezas")
		
		Otherwise
			MsgAlert("A conta " +ALLTRIM(_cConta)+" não pertence a um Grupo de Centro de Custos.")
    		_cConta := " "
	
	EndCase
         
Endif

restarea(_cArea)	
	
Return _cConta
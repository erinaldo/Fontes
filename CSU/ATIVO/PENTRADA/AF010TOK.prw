#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF010TOK  ºAutor  ³ Sergio Oliveira    º Data ³  Jul/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no momento da confirmacao da INCLUSAO do  º±±
±±º          ³ bem no Ativo Fixo.   Esta sendo utilizado para validar os  º±±
±±º          ³ 2 prims.  digitos das entidades Unidade de Negocio x Centroº±±
±±º          ³ de Custo x Operacao e tambem a contra regra do CC x Operac.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AF010TOK()

Local aAreaAnt := GetArea()
Local _xk, lContin := .t.

For _xk := 1 To Len( aCols )

    _cUnNeg    := aCols[_xk][GdFieldPos('N3_SUBCCON')]
    _cCusto    := aCols[_xk][GdFieldPos('N3_CCUSTO')]
    _cCustoBem := aCols[_xk][GdFieldPos('N3_CUSTBEM')]
    _cOperac   := aCols[_xk][GdFieldPos('N3_CLVLCON')]
	
	lContin := U_VldCTBg( _cUnNeg, _cCusto, _cOperac, AllTrim(Str(_xk)) )
	
	If !lContin
		Exit
	EndIf
	
Next

// OS 1235/09

If M->N1_AQUISIC < dDataBase .And. Inclui
    lContin := .f.
	cTxtBlq := "Não é possível incluir bens cuja data de aquisição seja inferior à data base do sistema."
	Aviso("DATA DE AQUISICAO",cTxtBlq,;
	{"&Fechar"},3,"Data do Dia",,;
	"PCOLOCK")
EndIf

DbSelectArea("CTG")
dbsetorder(4)

If Inclui
	If dbSeek("  "+(Substr(DtoS(M->N1_AQUISIC),1,4))+(Substr(DtoS(M->N1_AQUISIC),5,2)))
		If CTG->CTG_STATUS <> "1"   
		    lContin := .f.
			cTxtBlq := "Não é possível incluir bens cujo período do calendário contábil não esteja aberto."
			cTxtBlq += CHR(13)+CHR(10)+" Entre em contato com o departamento contábil."
			Aviso("DATA DE AQUISICAO",cTxtBlq,;
			{"&Fechar"},3,"Calendário Contábil",,;
			"PCOLOCK")	
		EndIf         
	Else
	    lContin := .f.
		cTxtBlq := "O calendário contábil do período informado na data de aquisição do bem não foi localizado."
		cTxtBlq += CHR(13)+CHR(10)+" Entre em contato com o departamento contábil."
		Aviso("DATA DE AQUISICAO",cTxtBlq,;
		{"&Fechar"},3,"Calendário Contábil",,;
		"PCOLOCK")
	EndIf    
EndIf
RestArea( aAreaAnt )

Return( lContin )

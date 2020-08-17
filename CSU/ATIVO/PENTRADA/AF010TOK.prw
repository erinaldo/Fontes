#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF010TOK  �Autor  � Sergio Oliveira    � Data �  Jul/2007   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no momento da confirmacao da INCLUSAO do  ���
���          � bem no Ativo Fixo.   Esta sendo utilizado para validar os  ���
���          � 2 prims.  digitos das entidades Unidade de Negocio x Centro���
���          � de Custo x Operacao e tambem a contra regra do CC x Operac.���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	cTxtBlq := "N�o � poss�vel incluir bens cuja data de aquisi��o seja inferior � data base do sistema."
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
			cTxtBlq := "N�o � poss�vel incluir bens cujo per�odo do calend�rio cont�bil n�o esteja aberto."
			cTxtBlq += CHR(13)+CHR(10)+" Entre em contato com o departamento cont�bil."
			Aviso("DATA DE AQUISICAO",cTxtBlq,;
			{"&Fechar"},3,"Calend�rio Cont�bil",,;
			"PCOLOCK")	
		EndIf         
	Else
	    lContin := .f.
		cTxtBlq := "O calend�rio cont�bil do per�odo informado na data de aquisi��o do bem n�o foi localizado."
		cTxtBlq += CHR(13)+CHR(10)+" Entre em contato com o departamento cont�bil."
		Aviso("DATA DE AQUISICAO",cTxtBlq,;
		{"&Fechar"},3,"Calend�rio Cont�bil",,;
		"PCOLOCK")
	EndIf    
EndIf
RestArea( aAreaAnt )

Return( lContin )

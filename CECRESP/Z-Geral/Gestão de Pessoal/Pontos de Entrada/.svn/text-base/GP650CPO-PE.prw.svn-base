//-----------------------------------------------------------------------
/*/{Protheus.doc} GP650CPO()

Ponto de entrada para alterar campos no RC1.

@param		nenhum
@return		nenhum
@author 	Ana Barizon   
@since 		01/11/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function GP650CPO

_aArea := GetArea()


If cGeraBen = "1" .and. cAgrupa = "4"
   If Srq->(dbSeek(RC1->RC1_FILTIT+RC1->RC1_MAT))
		RecLock("RC1",.F.,.F.)
		RC1->RC1_FORNEC := SRQ->RQ_FORNEC
		RC1->RC1_LOJA := "01"
		RC1->RC1_DESCRI := Substr(cDescri,1,15)+"-"+ SRQ->RQ_NOME   //Atualiza Historico
		MsUnLock() 
   Endif
ElseIf cGeraBen <> "1" .and. cAgrupa = "4"                    
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbSeek(RC1->RC1_FILTIT+RC1->RC1_MAT)//Posiciona no funcionario      
	If SRA->RA_XCODFOR <> Space(6)         //Se o fornecedor preenchido no Cadastro 
		RecLock("RC1",.F.,.F.)
		RC1->RC1_FORNEC := SRA->RA_XCODFOR
		RC1->RC1_LOJA := "01"
		RC1->RC1_DESCRI := Substr(cDescri,1,15)+"-"+ SRA->RA_NOME   //Atualiza Historico
		MsUnLock() 
	Else
		RecLock("RC1",.F.,.F.)
		RC1->RC1_DESCRI := Substr(cDescri,1,15)+"-"+ SRA->RA_NOME   //Atualiza Historico
		MsUnLock() 
	Endif	
EndIf

RestArea( _aArea )
                  
Return
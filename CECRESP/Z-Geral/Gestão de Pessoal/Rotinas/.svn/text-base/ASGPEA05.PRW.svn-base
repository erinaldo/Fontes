//-----------------------------------------------------------------------
/*/{Protheus.doc} FGERAGRAT()

Gera a verba de Gratificação no cálculo da Folha     

@param		Nenhum
@return		Nenhum                                           
@author 	Isamu Kawakami
@since 		05/10/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function fGeraGrat         

	
Local aTabGrt   := {}
Local nValGrat_ := 0     
Local nPos
Local cVerba_

//CARREGA TABELA ESPECIFICA DE EMPRESAS
fCarrTab(@aTabGrt,"U002",dDataBase)

If ( nPos := Ascan( aTabGrt,{ |x| x[1] == "U002" .and. Alltrim(x[5]) == Sra->Ra_Gratif_ } ) ) > 0
	nValGrat_  := aTabGrt[nPos,6]
	cVerba_    := aTabGrt[nPos,7]   
EndIf
                     
If DiasTrab >= 30
   fGeraVerba(cVerba_,nValGrat_,DiasTrab,,,,,,,,.T.)
Else
   fGeraVerba(cVerba_,(nValGrat_/30)*DiasTrab,DiasTrab,,,,,,,,.T.)
Endif

   
Return
#include 'protheus.ch'
#include 'parmtype.ch'

//---------------------------------------------------------------------------------------------------//
//Ashitani,Hugo. - FUNCAO UTILIZADA PARA CONVERTER A LINHA DIGITAVEL EM CODIGO DE BARRA              //
//  03/06/2019 - PARA QUE SEJA POSSIVEL GERAR CNAB DE TITULOS COM LINHA DIGITAL SEM CODIG DE BARRAS  //	
//---------------------------------------------------------------------------------------------------//

user function xConvLdig(cLindig)

cLin  := Alltrim(cLindig)   
nTamh := Len(cLin)
//cLin  := Subst(cLin,1,nTamh-1)                
cLin  := Subst(cLin,1,nTamh) //alterado dia 03/10/2019 - Emerson Natali - com o comando assima estava cortando o ultimo digito do valor do documento
   
  // Converter Linha Digitavel em Codigo de Barras
    cLinToBar := ""
	cLinToBar := cLinToBar + Subst(cLin,1,3)     // Banco 
	cLinToBar := cLinToBar + Subst(cLin,4,1)     // Moeda
	cLinToBar := cLinToBar + Subst(cLin,33,1)    // Digito Verificador
	cLinToBar := cLinToBar + Subst(cLin,34,4)    // Fator de Vencimento
	cLinToBar := cLinToBar + Subst(cLin,38,10)   // Valor
	cLinToBar := cLinToBar + Subst(cLin,05,05)   // Campo Livre 1 
	cLinToBar := cLinToBar + Subst(cLin,11,10)   // Campo Livre 2
	cLinToBar := cLinToBar + Subst(cLin,22,10)   // Campo Livre 3

	cLin := cLinToBar
  
Return(cLin) 
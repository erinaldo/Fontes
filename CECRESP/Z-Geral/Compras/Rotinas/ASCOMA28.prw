#INCLUDE "Protheus.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA28()

Ponto de entrada acionado apos a "analise da cotacao": irá
disparar um e-mail de agradecimento aos fornecedores que 
nao venceram a cotacao.

Chamado pelo PE AVALCOPC

@param		cPedido		= Número do pedido
@return		Nenhum	
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASCOMA28(cPedido)
	Local _aAreaSC7  := GetArea("SC7")
	Local _aAreaSC8  := GetArea("SC8")
	Local _cNumPC    := cPedido
//	Local _cNumCot   := SC7->C7_NUMCOT
	Local _cNumCot   := ""
	Local i          := 1
	
	Private _aParticip := {}
	
	DbSelectArea("SC7")
	SC7->(DbSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
	SC7->(DbSeek(xFilial("SC7") + _cNumPC + cValToChar(PADL(1,TamSX3('C7_ITEM')[01],'0')) ))
	_cNumCot   := SC7->C7_NUMCOT
	
	dbSelectArea("SC8")
	SC8->(dbSetOrder(1))
	SC8->(dbSeek(xFilial("SC8")+_cNumCot))
	
	While SC8->C8_FILIAL = xFilial("SC8") .and. SC8->C8_NUM = _cNumCot .and. !SC8->(Eof())
	    If SC8->C8_NUMPED <> _cNumPC //perdedores 
			nPos := aScan( _aParticip, { |x| x[1]+x[2]+x[3] == SC8->C8_NUM + SC8->C8_FORNECE + SC8->C8_lOJA } )
			If nPos == 0 
				aAdd(_aParticip,{SC8->C8_NUM, SC8->C8_FORNECE, SC8->C8_lOJA})		
			EndIf
		Endif	
		SC8->(DbSkip())
	Enddo	
	
	//Envia notificacao de agradecimento //
	
	If Len(_aParticip) > 0
		For i = 1 to Len(_aParticip)
			U_EnviaAG(_aParticip[i][1],_aParticip[i][2],_aParticip[i][3]) // elementos do array: 	C8_NUM, C8_FORNECE, C8_LOJA
		Next i
	Endif
	
	
	SC7->(RestArea(_aAreaSC7))
	SC8->(RestArea(_aAreaSC8))

Return .T.
	                                                                   

//-----------------------------------------------------------------------
/*/{Protheus.doc} EnviaAG()

Rotina de envio de e-mail de agradecimento aos fornecedores que
nao venceram a cotacao.

@param		_cNum	    	= Número do pedido
@param		_cFornece		= Código do Fornecedor
@param		_cFornece		= Loja do Fornecedor
@return		Nenhum	
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function EnviaAG(_cNum, _cFornece, _cLoja)

   	DbSelectArea("SA2")
   	DbSetOrder(1)
   	DbSeek(xFilial("SA2") + _cFornece + _cLoja)

	oProcess:= TWFProcess():New( "000001", "Agradecimento" )
	oProcess:NewTask( "Agradecimento - Cotacao de Precos", "\WORKFLOW\HTML\AGFORN.HTM" )
	oProcess:nEncodeMime 	:= 0
	oProcess:cSubject 		:= "Agradecimento - Cotação Eletrônica de Precos No." + _cNum
	oProcess:cTo      		:= SA2->A2_EMAIL
	oProcess:NewVersion(.T.)            
	
 	oHtml     				:= oProcess:oHTML
    // Preencher os campos do convite : CVFORN_SITEL.HTM //
 
	oHtml:ValByName( "A2_NOME"		, SA2->A2_NOME )
 	oHtml:ValByName( "C8_NUM"		, _cNum )
	oHtml:ValByName( "C8_FORNECE"   , SA2->A2_COD )
	oHtml:ValByName( "C8_LOJA"		, SA2->A2_LOJA )  
	oHtml:ValByName( "datetime"     , DTOC(MSDATE()) + " às " + left(time(),5) )
    
	oProcess:Start()

Return                                                

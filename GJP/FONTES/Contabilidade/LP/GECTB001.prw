#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GECTB001  ºAutor  ³TOTVS               º Data ³  05/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funçao executada nos LP 610 e 620                          º±±
±±º          ³ Tratamento para contabilização com Formas de pagamento     º±±
±±º          ³ diferentes                                                 º±±
±±º          ³ G   - GJP                                                  º±±
±±º          ³ E   - Execblock                                            º±±
±±º          ³ CTB - CONTABILIDADE                                        º±±
±±º          ³ 999 - Sequencia                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GECTB001(_nVar, _cTipo, _cLP, _lCli, _cCli, _cRT, _cAdt)

//Parametros enviados pelos LP
//_nVar
//	1-para conta contabil (cliente) SE1
//	2-para valor do lancamento contabil
//	3-para valor da Taxa do Cartao (despesa)
//	4-para item contabil (cliente) SE1
//  5-para pegar o valor de CQ (soma o campo do SE1 e depois diminui do total da Nota)
Default _nVar  := 0

//_cTipo
//	"R$|CH" - dinheiro e/ou cheque
//	"CC" 	- cartao de credito
//	"CD" 	- cartao de debito
//	"CC|CD" - taxas (credito + debito) Despesas
//  "CQ" - Credito ao Quarto
Default _cTipo := ""

Default _cLP := "" 

Default _cCli := ""
Default _lCli := .T.
Default _cRT  := ""  
Default _cAdt := ""  

_aArea	:= GetArea()
_nValor := 0
_nValTx := 0

//variaveis para CQ
_nValCQ := 0
_nValReal := 0
_nValNF := 0

_cConta	:= ""
_cItemC	:= ""

//Busca informações no Contas a Receber e faz enquanto for o mesmo Documento
//tratamento exclusivo para Conta contabil, Valor das Receitas e Item Contabil
DbSelectArea("SE1")
DbSetOrder(1)	
If DbSeek(xFilial("SE1")+SD2->(D2_SERIE+D2_DOC))
	_cChave := SD2->(D2_SERIE+D2_DOC)
	If _cLP == "1" //Inclusão
		Do While SE1->(!EOF()) .and. _cChave == SE1->(E1_PREFIXO+E1_NUM)
		
			If _lCli 
				If Alltrim(_cCli) <> alltrim(SE1->(E1_CLIENTE+E1_LOJA))
					SE1->(DbSkip())
					Loop
				Endif
			Else
				If Alltrim(_cCli) == alltrim(SE1->(E1_CLIENTE+E1_LOJA))
					SE1->(DbSkip())
					Loop
				Endif
			Endif					
			
			If _cAdt == "S" // 610-019
				If alltrim(SE1->E1_HIST) <> "ADIANT. CLIENTE HOTEL"
					SE1->(DbSkip())
					Loop
				EndIf
			EndIf

			If _cTipo == "FA" // 610-028
				If alltrim(SE1->E1_TIPO) == "FA" .and. alltrim(SE1->E1_ORIGEM) == "FINI791" //Faturamento em Nota somente de PRODUTOS (NFCE)
					SE1->(DbSkip())
					Loop
				EndIf
			EndIf

			If (alltrim(SE1->E1_TIPO) $ _cTipo .or. _cTipo == "RT") .and. (Empty(Alltrim(SE1->E1_LA)) .or. iif(!empty(_cRT),GeCTBChk(_cRT),.F.)  )
				If _nVar == 1
					_cConta := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CONTA")
				ElseIf _nVar == 2 .and. _cTipo == "RT"  
				    _nValor += GeCTBTerc(_cRT)
				ElseIf _nVar == 2 .and. _cTipo <> "RT"
					_nValor += SE1->E1_VALOR
				ElseIf _nVar == 4
					_cItemC := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_XITEMCC")
					
					//Atualiza o titulo financeiro para não executar novamente a Contabilização
					RecLock("SE1",.F.)
					SE1->E1_LA := "S"
					MsUnLock()
					GeCTBGrv("000001")
					If _cTipo == "RT"  
						GeCTBGrv(_cRT)
					EndIf
				EndIf
			EndIf
			SE1->(DbSkip())
		EndDo
	ElseIf _cLP == "2" //Cancelamento
			Do While !EOF() .and. _cChave == SE1->(E1_PREFIXO+E1_NUM)
			If (alltrim(SE1->E1_TIPO) $ _cTipo .or. _cTipo == "RT") .and. Empty(Alltrim(SE1->E1_XLA))
				If _nVar == 1
					_cConta := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CONTA")
				ElseIf _nVar == 2 .and. _cTipo == "RT"  
				    _nValor += GeCTBTerc(_cRT)       
				ElseIf _nVar == 2 .and. _cTipo <> "RT"
					_nValor += SE1->E1_VALOR
				ElseIf _nVar == 4
					_cItemC := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_XITEMCC")
					
					//Atualiza o titulo financeiro para não executar novamente a Contabilização
					RecLock("SE1",.F.)
					SE1->E1_XLA := "S"
					MsUnLock()
				EndIf
			EndIf
			SE1->(DbSkip())
		EndDo
	EndIf
EndIf

//tratamento exclusivo para Valor das Despesas com Taxa do Cartao
If DbSeek(xFilial("SE1")+SD2->(D2_SERIE+D2_DOC))
	_cChave := SD2->(D2_SERIE+D2_DOC)
	Do While !EOF() .and. _cChave == SE1->(E1_PREFIXO+E1_NUM)
		If alltrim(SE1->E1_TIPO) $ _cTipo
			If _nVar == 3
				_nValTx += SE1->E1_VLRREAL-SE1->E1_VLCRUZ
			ElseIf _nVar == 5 //CQ
				//If alltrim(SE1->E1_HIST) <> "ADIANT. CLIENTE HOTEL"

//					_nValReal += IIF(alltrim(SE1->E1_TIPO)$"CC|CD",SE1->E1_VLRREAL,SE1->E1_VALOR)  
					_nValReal += GeCTBTerc("000001")
					//------Loop para gravar o total da Nota
					_xAreaSD2 := GetArea()
					DbSelectArea("SD2")
					DbSetOrder(3) //FILIAL + DOC + SERIE
					DbGotop()
					_cChSD2 := substr(_cChave,(tamsx3("D2_SERIE") [1])+1, len(_cChave)) + substr(_cChave,1, (tamsx3("D2_SERIE") [1])) //D2_DOC + D2_SERIE
					If DbSeek(xFilial("SD2")+_cChSD2)
						_nValNF := 0
						Do While !EOF() .and. _cChSD2 == SD2->(D2_DOC+D2_SERIE)
							_nValNF   += SD2->D2_TOTAL
							SD2->(DbSkip())
						EndDo
					EndIf
					RestArea(_xAreaSD2)
					//------Fim do Loop para gravar o total da Nota
				//EndIf
			EndIf
		EndIf
		SE1->(DbSkip())
	EndDo
	If _nVar == 5 //CQ
		_nValCQ   := _nValReal - _nValNF
	EndIf

EndIf

//Retorno dos valores ao LP
If _nVar == 1
	RestArea(_aArea)
	Return(_cConta)
ElseIf _nVar == 2
	RestArea(_aArea)
	Return(_nValor)
ElseIf _nVar == 3
	RestArea(_aArea)
	Return(_nValTx)
ElseIf _nVar == 4
	RestArea(_aArea)
	Return(_cItemC)
ElseIf _nVar == 5
	RestArea(_aArea)
	Return(_nValCQ)
EndIf

RestArea(_aArea)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GECTB001  ºAutor  ³Microsiga           º Data ³  09/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeCTBTerc(_cRT)
Local   _nVlrSEZ := 0 
Default _cRT := ""

dbselectarea("SEZ")
SEZ->(dbsetorder(1))
If SEZ->(dbseek(xFilial("SEZ")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
	While SEZ->(!EOF()) .and. xFilial("SEZ")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO == SEZ->EZ_FILIAL+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO
		If alltrim(SEZ->EZ_EC05DB) == alltrim(_cRT)
			_nVlrSEZ += iif(alltrim(SEZ->EZ_TIPO)$"CC|CD",Posicione("SE1",1,(xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO),"E1_VLRREAL"),SEZ->EZ_VALOR)
		EndIf
		SEZ->(dbskip())
	EndDo
EndIf

Return _nVlrSEZ

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GECTB001  ºAutor  ³Microsiga           º Data ³  09/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeCTBGrv(_cRT)
Default _cRT := ""

dbselectarea("SEZ")
SEZ->(dbsetorder(1))
If SEZ->(dbseek(xFilial("SEZ")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
	While SEZ->(!EOF()) .and. xFilial("SEZ")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO == SEZ->EZ_FILIAL+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO
		If alltrim(SEZ->EZ_EC05DB) == alltrim(_cRT)
			RecLock("SEZ",.F.)
		   		SEZ->EZ_LA := "S"
			SEZ->(msunlock())
		EndIf
		SEZ->(dbskip())
	EndDo
EndIf

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GECTB001  ºAutor  ³Microsiga           º Data ³  09/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeCTBChk(_cRT)
Local   lRet := .F. 
Default _cRT := ""

dbselectarea("SEZ")
SEZ->(dbsetorder(1))
If SEZ->(dbseek(xFilial("SEZ")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
	While SEZ->(!EOF()) .and. xFilial("SEZ")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO == SEZ->EZ_FILIAL+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO
		If alltrim(SEZ->EZ_EC05DB) == alltrim(_cRT) .and. SEZ->EZ_LA == " "
			lRet := .T.
			exit 
		EndIf
		SEZ->(dbskip())
	EndDo
EndIf

Return lRet
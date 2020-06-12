#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetCpoVal º Autor ³ Felipe Raposo      º Data ³  06/09/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esse programa recebe quatro parametros (descritos abaixo)  º±±
±±º          ³ e retorna o valor do primeiro campo passado como parametro.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 1 - Campo que sera retornado.                              º±±
±±º          ³ 2 - Numero do indice para pesquisa.                        º±±
±±º          ³ 3 - Chave de pesquisa.                                     º±±
±±º          ³ 4 - SoftSeek (.T. ou .F.)                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ O valor do campo passado no primeiro parametro da funcao.  º±±
±±ºesperado  ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GetCpoVal(_cCpo, _nInd, _cCh, _lSoftSeek)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _uCpoVal, _cAls, _cAlsAnt, _aAreaX3, _aAreaAls, _cMsg

// Salva as condicoes do dicionario de dados
// antes do processamento.
_aAreaX3 := SX3->(GetArea())
// Se encontrar o campo no dicionario de dados, prossegue o
// processamento, senao exibe uma mensagem de erro.
SX3->(dbSetOrder(2)) // X3_CAMPO
If SX3->(dbSeek(_cCpo))
	// Salva o alias que estava ativo antes
	// do processamento.
	_cAlsAnt := Alias()
	
	_cAls := SX3->X3_ARQUIVO
	dbSelectArea(_cAls)
	// Salva as condicoes do alias que sera manipulado.
	_aAreaAls := GetArea()
	// Posiciona no registro desejado...
	dbSetOrder(_nInd); dbSeek(_cCh, _lSoftSeek)
	// ... e pega o valor do campo desejado.
	_uCpoVal := &(_cCpo)
	// Retorna as condicoes do alias que foi manipulado.
	RestArea(_aAreaAls)
	
	// Retorna a selecao do alias que estava ativo
	// antes do processamento.
	dbSelectArea(_cAlsAnt)
Else
	_cMsg := "Campo não cadastrado no dicionário de dados!"
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
Endif
// Retorna as condicoes do dicionario de dados.
SX3->(RestArea(_aAreaX3))
Return(_uCpoVal)
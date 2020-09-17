#include 'rwmake.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BRAD002  ³ Autor ³ Leandro Gomes         ³ Data ³ 05/09/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ExecBlock disparado do Bradesco MultiPag para retornar     ³±±
±±³          ³ lay-out da forma de pagamento.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNAB                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BRAD002()
Local _cRetorno :=""

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-  ¿
//³********************************************************************³
//³	SEGMENTO A,B - Pgto Atraves de Credito em Conta, Cheque, OP, DOC,  ³ 045 Layout do Lote
//³				   TED ou Pgto com Autenticacao 	                   ³
//³********************************************************************³
//|Tab  Cod     Descrição											   |
//³58	01    	CREDITO EM CONTA CORRENTE                              ³
//³58	02    	CHEQUE PAGAMENTO/ADMINISTRATIVO                        ³
//³58	03    	DOC                                                    ³
//³58	04    	OP A DISPOSICAO COM AVISO PARA O FAVORECIDO            ³
//³58	05    	CREDITO EM CONTA POUPANCA                              ³
//³58	07    	TED CIP                                                ³
//³58	08    	TED STR                                                ³
//³58	10    	OP `A DISPOSICAO SEM AVISO PARA O FAVORECIDO           ³
//³58	41    	TED - Outro Titular                                    ³
//³58	43    	TED - Mesmo titular                                    ³
//³58	44    	TED P/ TRANSF DE CTA INVESTIMENTO                      ³
//³********************************************************************³
//|			SEGMENTO J - Pagamento de Titulos de Cobranca			   | 040 Layout do Lote
//³********************************************************************³
//³58	30    	LIQUIDACAO DE TITULOS EM COBRANCA NO ITAU              ³
//³58	31    	PAGAMENTO DE TITULOS EM OUTRO BANCO                    ³
//³********************************************************************³
//|	SEGMENTO O - Pagamento de Contas e Tributos com Codigo de Barras   | 012 Layout do Lote 
//³********************************************************************³
//³58	11    	PGTO DE CTAS E TRIBUTOS C/ CODIGO DE BARRAS            ³
//³58	13    	PAGAMENTO A CONCESSIONARIAS                            ³
//³58	91    	GNRE                                                   ³
//³********************************************************************³
//|		SEGMENTO N - Pagamento de Tributos sem Codigo de Barras   	   | 012 Layout do Lote 
//³********************************************************************³
//³58	16    	PAGAMENTO DE TRIBUTOS - DARF NORMAL                    ³
//³58	17    	PAGAMENTO DE TRIBUTOS - GPS                            ³
//³58	18    	PAGAMENTO DE TRIBUTOS - DARF SIMPLES                   ³
//³58	21    	PAGAMENTO DE TRIBUTOS - DARJ                           ³
//³58	22    	PAGAMENTO DE TRIBUTOS - GARE-SP ICMS                   ³
//³58	23    	PAGAMENTO DE TRIBUTOS - GARE-SP DR                     ³
//³58	24    	PAGAMENTO DE TRIBUTOS - GARE-SP ITCMD                  ³
//³58	25    	PAGAMENTO DE TRIBUTOS - IPVA                           ³
//³58	26    	PAGAMENTO DE TRIBUTOS - LICENCIAMENTO                  ³
//³58	27    	PAGAMENTO DE TRIBUTOS - DPVAT                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  Ù
*/

IF 	SEA->EA_MODELO = '01' .OR.	SEA->EA_MODELO = '02' .OR. SEA->EA_MODELO = '03' .OR. SEA->EA_MODELO = '04' .OR. SEA->EA_MODELO = '05' .OR. SEA->EA_MODELO = '07' .OR. SEA->EA_MODELO = '08' .OR. SEA->EA_MODELO = '41' .OR. SEA->EA_MODELO = '43' .OR. SEA->EA_MODELO = '44'
		_cRetorno := '045'
ELSEIF SEA->EA_MODELO = '30' .OR. SEA->EA_MODELO = '31'
		_cRetorno := '040'
ELSEIF SEA->EA_MODELO = '16' .OR. SEA->EA_MODELO = '17' .OR. SEA->EA_MODELO = '18' .OR. SEA->EA_MODELO = '21' .OR. SEA->EA_MODELO = '22' .OR. SEA->EA_MODELO = '23' .OR. SEA->EA_MODELO = '24' .OR. SEA->EA_MODELO = '25' .OR. SEA->EA_MODELO = '26' .OR. SEA->EA_MODELO = '27' .OR. SEA->EA_MODELO = '91' .OR. SEA->EA_MODELO = '11' .OR. SEA->EA_MODELO = '13'
			_cRetorno := '012'
//	ELSEIF SEA->EA_MODELO = ''
//		_cRetorno := '022'	//Bloqueto Eletronico - (Captura de Titulos em Cobrança)
//	ELSEIF SEA->EA_MODELO = ''
//		_cRetorno := '010'	//Alegação do Sacado
	ENDIF

Return(_cRetorno)


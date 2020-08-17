#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT103IPC()

Atualiza campos customizados no Documento de Entrada

Este Ponto de Entrada tem por objetivo atualizar os campos customizados no 
Documento de Entrada e na Pré Nota de Entrada após a importação dos itens 
do Pedido de Compras (SC7).

O ponto de entrada MT103IPC é chamado nas funções: NFePC2Acol() e 
LxA103SC7ToaCols()  (MATA103X.PRX e LOCXNF2.PRW), após a carga de dados do 
pedido de compras.

@param		ExpN1	= 	Contém o número do item do aCols do Documento de 
						Entrada e da Pré Nota de Entrada.	
						 
@return		lRet	= 	O parâmetro lRet, somente é tratado na rotina Localizada. "LocxNF2".
						Em outros ambientes, este parâmetro não possui aplicação.
						.T. = Indica que a TES carregada no Acols, será mantida.
						Se não for passado TES no Acols, será substituída pela TEs do Pedido de Compras / Cadastro de Produtos.
						.F. = Indica que a TES do aCols, poderá ser substituída pela TEs do Pedido de Compras / Cadastro de Produtos. 
						(Este é o funcionamento padrão mesmo quando não existe o Ponto de Entrada)

@author 	Fabio Cazarini
@since 		25/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT103IPC()
	LOCAL nLinha	:= PARAMIXB[1]
	LOCAL lRet 		:= .F.

	lRet := U_ASCOMA16(nLinha, lRet)

RETURN lRet
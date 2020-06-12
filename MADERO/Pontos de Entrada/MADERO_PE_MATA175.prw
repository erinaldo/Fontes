#include 'protheus.ch'


/*/{Protheus.doc} MTA175MNU
Manutenção das opções do menu

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0

@type function
/*/
user function  MTA175MNU()

	//peocura pela função de estornar
	Local nPos := aScan(aRotina, {|rotina| "A175ESTORNA" $ upper(rotina[2]) })

	//pre inspeção ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()
		//se não foi chamada pela nova função de estornar
		IF ! IsInCallStack("u_MDR175Estorna") .And. nPos > 0
			//altera a opção de estorna
			aRotina[nPos][2] := "u_MDR175Estorna"
		EndIF
	EndIF

return


/*/{Protheus.doc} MDR175Estorna
Nova opção de estorno, caso tenha transferencias amarradas, estornar tudo automaticamente.

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0
@param cAlias, characters, Nome do alias
@param nReg, numeric, Recno
@param nOpc, numeric, Opcao
@type function
/*/
user function MDR175Estorna(cAlias,nReg,nOpc)

	Local nRec7 := SD7->( Recno() )

	Local lContinua := .T.
	Local cSeek := SD7->(D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL)

	Local aMata175 := {}

	//pre inspeção ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()

		//se controla LOTE e foi transferido
		IF Rastro(SD7->D7_PRODUTO) .And. SD7->(transferido( D7_NUMERO, D7_PRODUTO, D7_LOCAL ))

			//pergunta se deseja estornar tudo
			IF Aviso('Estorno','Está baixa foi feita automaticamente na classificação na PRENOTA, e possui transferencias amarradas. Deseja estornar as transferencias e a baixa total?',{'Estornar','Sair'},2) == 2
				return
			EndIF

			SD7->( dbSetOrder(1) )
			SD7->( dbGoTop() )
			SD7->( dbSeek( cSeek ) )

			begin transaction

				//percorre todos os itens
				While ! SD7->( Eof() ) .And. SD7->(D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL) == cSeek .And. lContinua

					//se para liberado / rejeitado que ainda não foram estornados
					IF (SD7->D7_TIPO == 1 .Or. SD7->D7_TIPO == 2) .And. Empty(SD7->D7_ESTORNO)

						//monta o execauto de estorno
						aAdd(aMata175, {})
						aAdd( aTail(aMata175), { "D7_SEQ"    , SD7->D7_SEQ     , nil})
						aAdd( aTail(aMata175), { "D7_ESTORNO", "X"             , nil})
						aAdd( aTail(aMata175), { "D7_DATA"   , SD7->D7_DATA    , nil})
						aAdd( aTail(aMata175), { "D7_TIPO"   , SD7->D7_TIPO    , nil})
		                aAdd( aTail(aMata175), { "D7_QTDE"   , SD7->D7_QTDE    , nil })

		                //se para os transferidos com numero de pallet
						IF ! Empty(SD7->D7_DOCTRF) .And.  ! Empty(SD7->D7_PALLET)

							//busca a movimentação
							SD3->( dbSetOrder(4) )
							SD3->( dbSeek( xFilial("SD3") + SD7->D7_DOCTRF ) )

							//se existir e não tiver sido estornada
							IF SD3->( Found() ) .And. empty(SD3->D3_ESTORNO)
								//estorna a transferencia
								lContinua := u_MDREstor2Lote()
							EndIF
						EndIF
					EndIF

					SD7->( dbSkip() )
				EndDO

				SD7->( dbGoTo(nRec7) )

				IF lContinua
					//controle de erro
					Private lMsErroAuto := .F.

					//executa a baixa
					MSExecAuto({|x,y| mata175(x,y)}, aMata175, 6 )

					IF lMsErroAuto
						MostraErro()
					EndIF

					lContinua := ! lMsErroAuto
				EndIF

				IF ! lContinua
					DisarmTransaction()
				EndIF

			end transaction

			IF lContinua
				Aviso('Sucesso','Baixas estornadas com sucesso!',{'Sair'},1)
			EndIF
		Else
			//chama função padrão que estava no menu
			A175Estorna(cAlias,nReg,nOpc)
		EndIF
	EndIF

return


/*/{Protheus.doc} A175GRV
Ponto de entrada após a gravação da liberação

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0

@type function
/*/
user function A175GRV()

	Local nRec7 := SD7->( Recno() )
	Local cSeek

	//pre inspeção ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()
		//se controla lote
		IF Rastro(cA175Prod)

			SD7->( dbSetOrder(1) )
			SD7->( dbGoTop() )
			SD7->( dbSeek( cSeek := xFilial('SD7') + cA175Num + cA175Prod + cA175Loc ) )

			While ! SD7->( Eof() ) .And. SD7->(D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL) == cSeek

				IF (SD7->D7_TIPO == 1 .Or. SD7->D7_TIPO == 2) .And. Empty(SD7->D7_DOCTRF) .And. Empty(SD7->D7_ESTORNO) .And. ! Empty(SD7->D7_PALLET)
					u_MDRTransf2Lote()
				EndIF

				SD7->( dbSkip() )
			EndDO

		EndIF

		SD7->( dbGoTo(nRec7) )
	EndIF

return


/*/{Protheus.doc} transferido
Função para verificar se a baixa foi transferida

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0
@return logical, se foi transferida
@param cA175Num, characters, Numero
@param cA175Prod, characters, Produto
@param cA175Loc, characters, Local
@type function
/*/
static function transferido(cA175Num, cA175Prod, cA175Loc)

	Local nRec7 := SD7->( Recno() )
	Local cSeek

	SD7->( dbSetOrder(1) )
	SD7->( dbGoTop() )
	SD7->( dbSeek( cSeek := xFilial('SD7') + cA175Num + cA175Prod + cA175Loc ) )

	While ! SD7->( Eof() ) .And. SD7->(D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL) == cSeek

		IF (SD7->D7_TIPO == 1 .Or. SD7->D7_TIPO == 2) .And. ! Empty(SD7->D7_DOCTRF) .And. Empty(SD7->D7_ESTORNO) .And. ! Empty(SD7->D7_PALLET)

			SD3->( dbSetOrder(4) )
			SD3->( dbSeek( xFilial("SD3") + SD7->D7_DOCTRF ) )

			IF SD3->( Found() ) .And. empty(SD3->D3_ESTORNO)
				SD7->( dbGoTo(nRec7) )
				return .T.
			EndIF
		EndIF

		SD7->( dbSkip() )
	EndDO

	SD7->( dbGoTo(nRec7) )

return .F.
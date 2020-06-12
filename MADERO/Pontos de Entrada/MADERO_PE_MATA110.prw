#Include 'Protheus.ch'

/*-----------------+---------------------------------------------------------+
!Nome              ! MT110GRV - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE apos gravacao da SC para preencher campos que nao    !
!                  !    estao sendo gravado no MRP.                          !
!                  ! - Depende de ACOLS, AHEADER e deve estar posicionado no !
!                  !   item do SC1                                           !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 19/06/2018                                              !
+------------------+--------------------------------------------------------*/
user function _MT110GRV()
Local aArea110GRV:=GetArea()
Private aCols   := {{SC1->C1_PRODUTO}}
Private aHeader := {{,"C1_PRODUTO"}}
Private n       := 1
	RecLock("SC1", .f.)
	SC1->C1_XGRUPO  := u_xSB1SC1("C1_XGRUPO","G")
	SC1->C1_XCODTAB := u_xSB1SC1("C1_XCODTAB","G")
	SC1->C1_CODCOMP := IIF(Empty(SC1->C1_CODCOMP),u_xSB1SC1("C1_CODCOMP","G"),SC1->C1_CODCOMP)
	SC1->C1_XORIGEM := FunName()
	SC1->C1_PRECO   := SC1->C1_VUNIT
	SC1->C1_TOTAL   :=NoRound(SC1->C1_PRECO*SC1->C1_QUANT,TamSX3("C1_TOTAL")[2])
	SC1->(MsUnLock())
	RestArea(aArea110GRV)

return nil


/*/{Protheus.doc} M110STTS
Após a gravação da solicitação, dentro da transação

@author Rafael Ricardo Vieceli
@since 24/09/2018
@version 1.0

@type function
/*/
user function M110STTS()

	Local cA110Num := ParamIXB[1]
	Local nOpcao   := ParamIXB[2]
	Local lCopia   := ParamIXB[3]

	Local nValorLiberacao
	Local cGrupo

	IF u_MDRAvDcAtive()

		IF ! SuperGetMv("MV_APRSCEC",.F.,.F.)
			//valor da liberação
			nValorLiberacao := getValorLib(cA110Num)

			//alterando ou excluindo
			IF nOpcao == 2 .Or. nOpcao == 3
				SCR->( dbSetOrder(1) )
				SCR->( dbSeek( xFilial('SCR') + 'SC' + cA110Num ) )

				IF SCR->( Found() )
					//exclui a alçada
					MaAlcDoc({cA110Num,"SC",nValorLiberacao,,,SCR->CR_GRUPO,,,,SC1->C1_EMISSAO},,3)
				EndIF
			EndIF

			//incluindo ou alterando
			cGrupo := u_MDRGetAprov( retCodUsr(), "SC" )
			IF  nOpcao == 1 .Or. nOpcao == 2 .And. ! Empty( cGrupo )
				//inclui a alçada
				MaAlcDoc({cA110Num,"SC",nValorLiberacao,,,cGrupo,,,,SC1->C1_EMISSAO},,1)
				//marca a solicitação como bloqueada
				a110Lib('B')
			EndIF

		EndIF

		//incluindo ou alterando
		IF nOpcao == 1 .Or. nOpcao == 2
			//se não bloqueou, bloqueia
			IF SC1->C1_APROV $ "L "
				a110Lib('B')
			EndIF
		EndIF
	EndIF

return


/*/{Protheus.doc} getValorLib
consulta o valor total da solicitação para Liberação

@author Rafael Ricardo Vieceli
@since 24/09/2018
@version 1.0
@return numeric, valor da solicitação
@param cSolicitacao, characters, Numero da solicitação
@type function
/*/
static function getValorLib(cSolicitacao)

	Local nAreaSC1 := SC1->( Recno() )

	Local nTotal := 0

	SC1->( dbSetOrder(1) )
	SC1->( dbSeek( xFilial('SC1') + cSolicitacao ) )

	While ! SC1->( Eof() ) .And. SC1->(C1_FILIAL+C1_NUM) ==  xFilial('SC1')+cSolicitacao
		nTotal += SC1->C1_QUANT * Iif(SC1->C1_VUNIT > 0,SC1->C1_VUNIT,MTGetVProd(SC1->C1_PRODUTO))

		SC1->(dbSkip())
	EndDO


	SC1->( dbGoTo( nAreaSC1 ) )

return nTotal
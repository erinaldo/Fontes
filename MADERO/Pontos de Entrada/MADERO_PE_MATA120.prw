#include 'protheus.ch'

static pedidoSemGrupoDeAprovacao := .F.


/*/{Protheus.doc} MT120APV
Para selecionar o grupo de aprova��o

@author Rafael Ricardo Vieceli
@since 20/09/2018
@version 1.0
@return character, codigo do grupo de aprova��o

@type function
/*/
user function MT120APV()
Local cCodUsr := IIF(Type("cxUserSC7")  == "C",cxUserSC7,retCodUsr())


	//se o controle customizado estiver ativo
	IF u_MDRAvDcAtive()

		//e for por entidade contabil
		IF SuperGetMv("MV_APRPCEC",.F.,.F.)
			//deixa sem grupo e bloqueia o pedido no PE WFW120P
			return ''
		EndIF

		//pega o grupo conforme o codigo do usuario
		return u_MDRGetAprov( cCodUsr, "PC" )

	EndIF

return


/*/{Protheus.doc} WFW120P
Ap�s gravar o controle de al�adas

@author Rafael Ricardo Vieceli
@since 20/09/2018
@version 1.0

@type function
/*/
user function WFW120P()

	Local nSave := SC7->( recno() )

	//al�ada customizada
	IF u_MDRAvDcAtive()

		//IF SuperGetMv("MV_APRPCEC",.F.,.F.)

			SC7->( dbSetOrder(1) )
			SC7->( dbSeek( ParamIXB ) )

			While ! SC7->( Eof() ) .And. SC7->(C7_FILIAL+C7_NUM) == ParamIXB

				//se n�o tiver grupo aprovador e n�o estiver bloqueado
				IF empty( SC7->C7_APROV ) .And. SC7->C7_CONAPRO != "B"
					//bloqueia
					Reclock("SC7",.F.)
					SC7->C7_CONAPRO := "B"
					SC7->( MsUnlock() )

					//controle para avisar ao usuario fora da transa��o
					pedidoSemGrupoDeAprovacao := .T.
				EndIF

				SC7->(dbSkip())
			EndDO

			SC7->( dbGoTo( nSave ))

		//EndIF
	EndIF

return


/*/{Protheus.doc} MT120GOK
Ap�s a grava��o fora da transa��o

@author Rafael Ricardo Vieceli
@since 20/09/2018
@version 1.0

@type function
/*/
user function MT120GOK()

	IF pedidoSemGrupoDeAprovacao
		//avisa ao usuairo que o pedido esta bloqueado sem grupo de aprova��o
		Aviso('Bloqueio', "O pedido est� bloqueado sem grupo de aprova��o,pois usu�rio n�o possiu configura��o que posibilite encontrar grupo de aprova��o.", {"Ok"}, 2)
	EndIF

	pedidoSemGrupoDeAprovacao := .F.

return


/*-----------------+---------------------------------------------------------+
!Nome              ! MT120CPE                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! PE para lterar vari�veis do cabecalho do pedido         !
+------------------+---------------------------------------------------------+
!Autor             ! M�rcio Zaguetti                                         !
+------------------+---------------------------------------------------------!
!Data              ! 21/11/2018                                              !
+------------------+--------------------------------------------------------*/
User Function MT120CPE
Local cCodUsr:= IIF(Type("cxUserSC7")  == "C",cxUserSC7,"")

cA120User:=cCodUsr

Return()



/*-----------------+---------------------------------------------------------+
!Nome              ! MT120LOK                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! PE Respons�vel pela valida��o de cada linha da GetDados !
!                  ! do Pedido de Compras                                    ! 
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos                                              !
+------------------+---------------------------------------------------------!
!Data              ! 14/11/2018                                              !
+------------------+--------------------------------------------------------*/
User Function MT120LOK()
Local lRet := .T.
Local nPosTES    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_TES'})

IF FunName() == "MATA121"
	If (INCLUI .OR. ALTERA) .and. Empty(aCols[n][nPosTES])
		ApMsgAlert("Informe a TES no campo Tip.Operacao para continuar o processo!", "Aten��o!")
		lRet := .F.
	EndIf
EndIf

Return  lRet
#include 'protheus.ch'
#include 'parmtype.ch'

//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA22

Fun��o para iniciar o JOB para alimentar a tabela de contabiliza��o

@param		C�digo do LP da Chamada
@return		nRet = 0
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------

User Function ASCTBA22(cCodLP)

LOCAL aAreaAnt	:= GETAREA()
Local nRet 		:= 0
Local aPar		:= {}
Local dDtOper   := dDataBase
Local cTipOper
Local cEvent	:= oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSEVENT:_EVENT:TEXT
Local cCC


DbSelectArea("SEZ")
SEZ->(DbSetOrder(1))//EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
IF MsSeek( xFilial("SEZ") + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA+E1_NATUREZ) )
	cCC := SEZ->EZ_CCUSTO
EndIF 

// cTipOper = 0 Inclus�o / Exclus�o Venda
// cTipOper = 1 Inclus�o / Exclus�o Reajuste
// cTipOper = 2 Inclus�o Aditivos
// cTipOper = 3 Inclus�o Distrato


IF Type("oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL[1]:_SOURCE:TEXT") == "U"
cTipOper := oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL:_SOURCE:TEXT

ElseIF Type("oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL:_SOURCE:TEXT") == "U"
cTipOper := oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL[1]:_SOURCE:TEXT
ENDIF

IF cTipOper == '2'
	IF !Type("oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL:_LISTOFCOMPONENT:_COMPONENT[1]:_CODE:TEXT") == "U"
		For nX:= 1 To Len( oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL:_LISTOFCOMPONENT:_COMPONENT )
			IF oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL:_LISTOFCOMPONENT:_COMPONENT[nX]:_CODE:TEXT$'93|27'
				cTipOper := 'AV'
			EndIF
		Next
	
	ElseIF !Type("oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL[1]:_LISTOFCOMPONENT:_COMPONENT[1]:_CODE:TEXT") == "U"
		For nX:= 1 To Len( oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL[1]:_LISTOFCOMPONENT:_COMPONENT )
			IF oXmlFin:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_LISTOFCONTRACTPARCEL:_CONTRACTPARCEL[1]:_LISTOFCOMPONENT:_COMPONENT[nX]:_CODE:TEXT$'93|27'
				cTipOper := 'AV'
			EndIF
		Next
	EndIF

EndIF

IF cTipOper == '0' .Or. cTipOper == '2'
	IF cEvent == "upsert"
		dDtOper := SE1->E1_EMISSAO
	Else
		dDtOper := SE1->E1_BAIXA
	EndIF
ElseIF cTipOper == '3'
	dDtOper := SE1->E1_BAIXA
EndIF

AadD(aPar, cEmpAnt)
AadD(aPar, cFilAnt)
AadD(aPar, SE1->E1_CLIENTE )
AadD(aPar, SE1->E1_LOJA )
AadD(aPar, SE1->E1_NATUREZ )
AadD(aPar, Alltrim(SE1->E1_XEMPRE) )
AadD(aPar, Alltrim(SE1->E1_XCONTRA) )
AadD(aPar, cTipOper)
AadD(aPar, cCodLP)
AadD(aPar, cEvent)
AadD(aPar, dDtOper)
AadD(aPar, __nTINVCTB)
AadD(aPar, __cTINHCTB)
AadD(aPar, cCC)
AadD(aPar, oXmlFin)

//Chamada para star do JOB
//Utilizado para Contabiliza��o Off-Line e envio de boleto bradesco parceiro
StartJob('U_ASCTBA23', GetEnvServer(), .F., aPar)
//U_ASCTBA23(aPar)

RestArea(aAreaAnt)

Return nRet

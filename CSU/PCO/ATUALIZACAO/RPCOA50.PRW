
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCOA50   ºAutor  ³Fernando Garrigos   º Data ³  12/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Utilizado no Lanc. de Bloqueio de Liberacao de Pedidos de   º±±
±±º          ³Compras. Verifica se ultima liberacao.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Anhembi Morumbi.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCOA50()

Local cQuery	:= ""
Local cPedido	:= ""
Local nRet		:= 0
Local cAprov 	:= RTRIM(LEFT(GETMV("MV_PCOLIB"),6))
// ALTERADO POR RODNEY EM 16/02, POIS __aDadosBlq nao existe neste momento   Local cConta 	:= SUBSTR(__aDadosBlq[4],1,12)
Local cConta 	:= POSICIONE("SB1",1,"  "+SC7->C7_PRODUTO,"B1_CTAPCO")         // CONFORME REGRA DO LANCTO DE BLOQUEIO

IF !EMPTY (ALLTRIM(SCR->CR_NUM))
	
	cPedido	:= ALLTRIM(SCR->CR_NUM)

If !Empty(cAprov) // Se não estiver vazio, realizar a validação do bloqueio conforme usuário incluído.
	
	cQuery	:=	" SELECT COUNT (*) AS CONT FROM "+RetSqlName("SCR")+ " SCR "
	cQuery	+=	" WHERE CR_FILIAL = '"+xFilial('SCR')+"' AND "
	cQuery	+=	" CR_NUM ='"+cPedido+"' AND "
	cQuery	+=	" CR_APROV ='"+cAprov+"' AND "
	cQuery	+=	" CR_STATUS IN ('02','04') AND "	
	cQuery	+=	" SCR.D_E_L_E_T_<> '*' "
	cQuery	:=	ChangeQuery(cQuery)

Else // Se cAprov estiver vazio, validação de bloqueio será no primeiro aprovador.

	cQuery	:=	" SELECT COUNT (*) AS CONT FROM "+RetSqlName("SCR")+ " SCR "
	cQuery	+=	" WHERE CR_FILIAL = '"+xFilial('SCR')+"' AND "
	cQuery	+=	" CR_NUM ='"+cPedido+"' AND "
	cQuery	+=	" CR_NIVEL = '01' AND "
	cQuery	+=	" CR_STATUS IN ('02','04') AND "	
	cQuery	+=	" SCR.D_E_L_E_T_<> '*' "
	cQuery	:=	ChangeQuery(cQuery)

Endif
	
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery),"TRB", .F., .F. )
	
	DbSelectArea("TRB")
	
	IF TRB->CONT == 1
		nRet := SCR->CR_TOTAL
	ELSE
		nRet := 0
	ENDIF
	
	DbCloseArea("TRB")
	
Endif

Return (nRet)

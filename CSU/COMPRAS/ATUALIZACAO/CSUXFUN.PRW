#Include 'Rwmake.ch'
#INCLUDE "PROTHEUS.CH"

User Function NOMESC(cSolic)

Local _lRet 		:= .F.
Local _aAreaSZI 	:= GetArea("SZI")
Local _cSolAnt		:= cSolic

Public ca110SOL	:= cSolic

SZI->(DbSetOrder(1))
If SZI->( DbSeek( xFilial("SZI")+__cUserId ) )
	While !SZI->(EOF()) .AND. SZI->ZI_USUARIO == __cUserId
		
		If SZI->ZI_FLGCOM == "1"
			If SZI->ZI_ALTSC == "1" //.AND. SZI->ZI_NMUSER == cSolic  // 1=Sim;2=Nao
				_lRet := .T.
				Exit
			EndIf
			
			If SZI->ZI_NMUSER == cSolic
				_lRet := .T.
				Exit
			EndIf
		EndIf
		
		SZI->(DbSkip())
	EndDo
EndIf

RestArea(_aAreaSZI)

If !_lRet
	cTxtBlq := "O usuแrio DIGITADO NA SOLICITACAO DE COMPRAS nao possui acesso ภs inclus๕es "
	cTxtBlq += "de Solicita็๕es de Compras. Entre em contato com a แrea responsแvel."
	Aviso("SOLICITANTE NA SOLICITAวรO",cTxtBlq,;
	{"&Fechar"},3,"Solicitante sem Acesso",,;
	"PCOLOCK")
EndIf

Return _lRet



User Function VALCC(cSolic)

Local _cCC	:= ""

// 05/Jun/2007: Ajuste na forma de se obter o ID do usuario:

PswOrder(2) // Ordem de nome do usuario
PswSeek( ca110SOL )

SZI->(DbSetOrder(1))
//If SZI->(DbSeek( xFilial("SZI")+RetCodUsr(ca110SOL) ))
If SZI->(DbSeek( xFilial("SZI")+PswId() ))
	
	
	While !SZI->(EOF()) .AND. SZI->ZI_USUARIO == PswId()
		
		If SZI->ZI_FLGCOM == "1"
			_cCC := SZI->ZI_CCUSTO
			Exit
		EndIf
		
		SZI->(DbSkip())
	EndDo
	
EndIf

Return(_cCC)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   | VldCTBg  บAutor  ณ Sergio Oliveira    บ Data ณ  25/Abr/2007บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Funcao para efetuar a validacao contabil de acordo com as  บฑฑ
ฑฑบDescricao ณ regras definidas.                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldCTBg(pcUnNeg, pcCCusto, pcOperacao, pcLinha, pcConta, plReupi)

Local aArea   := GetArea()
Local lExistAcols := Type('aCols') == 'A', lDel := .f., lEntrou := .f.
Local cLinha  := IIF( ValType(pcLinha) == 'C', ' na linha '+pcLinha, '' )
Local cTxtBlq := "A amarracao entre as entidades Unidade de Negocio x Centro de Custo x Opera็ใo"
cTxtBlq += " em questใo nใo ้ permitida."+cLinha
Default pcConta := " ", plReupi := .t.
Private lEnd    := !Empty(pcCCusto) .And. !Empty(pcOperacao) .And. !Empty(pcUnNeg)

If !Empty(pcConta)
	lEnd := lEnd .And. !( Left( pcConta,1 ) $ '1/2' )
EndIf

// Caso a matriz aCols nao exista, nao deve ser avaliada a delecao da linha:

If lExistAcols
	
	If n <= Len( aCols )
		lDel := aCols[n][Len(aCols[n])]
	Else
	    lDel := .f.
	EndIf
	
EndIf

// Primeira regra de valida็ใo: Verificar se os dois primeiros digitos entre as tr๊s entidades
//                              estใo identicos, exceto quando a operacao(Classe de Valor) for
//                              igual a 999999999:

If !lDel .And. lEnd
	
	lEntrou := .t.
	lEnd    := Left( pcCCusto,2 ) == Left( pcUnNeg,2 )
	
	If pcOperacao # Replicate("9",TamSX3("C1_CLVL")[1]) .Or. Left(pcUnNeg,2)$'03/04'
		lEnd := lEnd .And. Left( pcOperacao,2 ) == Left( pcUnNeg,2 )		
	
	EndIf
	
	If !lEnd .And. plReupi
		
		Aviso("REGRA CONTABIL",cTxtBlq,;
		{"&Fechar"},3,"Combina็ใo Invแlida",,;
		"PCOLOCK")
	EndIf
	
EndIf

// Segunda regra de valida็ใo: Verificar a regra de amarra็ใo entre o Centro de Custo e Opera็ใo(Classe
//                             de Valor) de acordo com a Regra e Contra-regra informada no CTT e CTH:

If lEnd
	lEntrou := .t.
	
	lEnd    := CtbAmarra( '', pcCCusto, pcUnNeg, pcOperacao,.T., plReupi)
	
    If !lEnd .And. plReupi
		Aviso("LINHA DA REGRA CONTABIL",cTxtBlq,;
		{"&Fechar"},3,"Combina็ใo Invแlida",,;
		"PCOLOCK")
    EndIf
EndIf

If !lEntrou // Se nao passou pelas validacoes, deve-se retornar True
	lEnd := .t.
EndIf

RestArea( aArea )

Return(lEnd)

User Function ExibCont()

Local _cContr := Space(15)

_cContr := SC7->C7_CONTRA

Return _cContr

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSVALAPROVบAutor  ณ Renato Carlos      บ Data ณ  Set/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se o pedido estแ em aprova็ใo ou bloqueado.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

User Function CSVLDAPROV( c_NumPed,c_ConApro )

Local a_AreaAnt := GetArea()
Local c_Query := ""
Local c_Status := ""

If c_ConApro == 'L'
	c_Status := "APROVADO"
Else
	c_Query     := ""
	c_Query     += " SELECT CR_NUM, CR_STATUS, CR_DATALIB, CR_NIVEL"
	c_Query     += " FROM "+RetSqlName("SCR")+"  " 
	c_Query     += " WHERE CR_NUM = '"+Alltrim(c_NumPed)+"' "
	c_Query     += " AND D_E_L_E_T_ = ''                   "
	c_Query     += " ORDER BY CR_NIVEL                   "

	
	nCntQuery := U_MontaView( c_Query, 'TMPSCR' )
	
	DbSelectArea('TMPSCR')		
	TMPSCR->( DbGoTop() )

	While !TMPSCR->(EOF())

		If	TMPSCR->CR_STATUS == "04"
			c_Status := "BLOQUEADO"
			Exit
		Else
			c_Status := "EM APROVACAO"
		EndIf
		TMPSCR->( DbSkip() )						
	EndDo

	TMPSCR->( DbCloseArea() )

EndIf

RestArea(a_AreaAnt)

Return(c_Status)

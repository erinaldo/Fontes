#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT120ALT  บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Informar ao usuario qual a situacao atual do pedido confor-บฑฑ
ฑฑบ          ณ me as regras estabelecidas. (ponto de entrada Ped. Compras)บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ 1) Alterado por Flavio Novaes em 02/05/07, para proibir a  บฑฑ
ฑฑบ          ณ    Inclusao caso o usuario tenha alterado a Data Base do   บฑฑ
ฑฑบ          ณ    Sistema, conforme chamado 1458.                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120ALT()

Local lRet    := .t.
Local cMsg2   := ""
Local _lCopia := IsInCallStack("A120COPIA")
Local cProvpc := Alltrim(GetMv("MV_PROVPC" ))


If "CNTA120"$FunName() // Sergio em Jul/2008: A exclusao via modulo GCT devera ser permitida.
	Return(.t.)
EndIf

If "RPC"$FunName() 
	Return(.t.)
EndIf

// Sergio Oliveira em Jul/2007: Atendimento ao chamado 002111 - Criacao da variavel _cUsrGst
//                              para que a mesma seja controlada no ponto de entrada MT120gok.prw

Public _cUsrGst := SC7->C7_USER

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ OS 0915/11 - Os para que na chamada da fun็ใo Copia de pedido, seja gravado o usuแrio corrente e nao  ณ
ณ o usuแrio do pedido original                                   ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

If _lCopia
	_cUsrGst := __cUserId
EndIf



/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Sergio em Ago/2007: De acordo com o VFP-Manutencao_de_PC.doc algumas consi-ณ
ณ deracoes sao agora necessarias:                                            ณ
ณ                                                                            ณ
ณ I- Permitir que somente os usuarios que criaram o Pedido ou o usuario mas- ณ
ณ    ter realizem a manutencao dos mesmos (Alteracao e Exclusao)             ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

// Estrutura da ParamIxb: 03-Incluir/04-Alterar/05-Excluir

If lRet
	
	IF StrZero(ParamIxb[1],2) $ '03/04/05' .Or. _lCopia
		IF dDataBase <> DATE()
			lRet  := .F.
			cMsg2 := 'A Data Base do Sistema foi Alterada, favor voltar '
			cMsg2 += 'a Data Base para a Data de Hoje: '+DTOC(DATE())+'!'
			Aviso('Data',cMsg2,{'Voltar'},3,"Manutencao do PC",,"PCOLOCK")
		ENDIF
	ENDIF
	
EndIf

If ( SC7->C7_USER # __cUserId .And. StrZero(ParamIxb[1],2) $ '04/05' ) .And.;
	( StrZero(ParamIxb[1],2) $ '04/05' .And. !AllTrim(cUserName) $ GetMV( 'MV_X_MASTR' ) ) .And. !_lCopia
	
	Aviso("Usuario Gestor","Voce nใo ้ o gestor deste pedido.",;
	{"Voltar"},3,"Gestor do Pedido",,;
	"PCOLOCK")
	
	lRet := .f.
	
EndIf



/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Sergio em Ago/2007: De acordo com o VFP-Manutencao_de_PC.doc               ณ
ณ II- Nao permitir a manutencao do PC apos ter sido enviado ao fornecedor.   ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

If lRet .And. StrZero(ParamIxb[1],2) $ '04/05' .And. !_lCopia
	If !Empty(SC7->C7_X_ENVFR)
		
		If !Empty(SC7->C7_X_DTACT)
			cMsg2 := " e inclusive o fornecedor ja o aceitou em "+Dtoc(SC7->C7_X_DTACT)+". "
		EndIf
		
		cMsg := "Este pedido ja foi enviado ao fornecedor"+cMsg2
		
		If StrZero(ParamIxb[1],2) $ '04'
			cMsg += "Somente a op็ใo de exclusao serแ permitida."
			Aviso('Fornecedor',cMsg,{'Voltar'},3,"Gestor do Pedido",,"PCOLOCK")
			lRet := .f.
		Else
			_cUsuario := Posicione('SA2',1,xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),"A2_EMAIL")
			cMsg += "Caso voce prossiga, uma notifica็ใo avulsa (sem processo de retorno) de "
			cMsg += "cancelamento do Pedido serแ enviada ao fornecedor para o e-mail: "+Trim(_cUsuario)+" ."
			Aviso('Fornecedor',cMsg,{'Ok'},3,"Gestor do Pedido",,"PCOLOCK")
		EndIf
		
	EndIf
	If lRet
		If VerItens() // Caso ja tenha quantidade entregue, nao permitir a alteracao:
			cMsg := "Ja existe nota fiscal relacionada a este Pedido de Compras. Esta opera็ใo "
			cMsg += "nใo poderแ ser concluํda.."
			Aviso('Pedido Atendido',cMsg,{'Ok'},3,"Pedido Atendido",,"PCOLOCK")
			
			lRet := .f.
		EndIf
		If VerPA() // Caso ja tenha PA, nao permitir a alteracao. OS 1670/15
			cMsg := "Ja existe Pagamento Antecipado (PA) relacionada a este Pedido de Compra. "
			cMsg += "Esta opera็ใo nใo poderแ ser concluํda.."
			Aviso('Pedido vinculado a uma PA',cMsg,{'Ok'},3,"Pedido vinculado a uma PA",,"PCOLOCK")
			
			lRet := .f.
		EndIf
		If ExistProv() .and. cProvpc == "Bloqueado" // Caso tenha PROVISรO, nใo permitir a alteracao e exclusใo. OS 3417/15 e 0602/16
			cMsg := "Jแ existe Provisใo, vinculada a este pedido de compra."+CHR(10)+CHR(13)
			cMsg += "Esta opera็ใo nใo poderแ ser concluํda! "
			cMsg += "Favor entrar em contato com a Contabilidade!"
			Aviso("Pedido de compra X Provisใo",cMsg,{'Ok'},3,"Pedido de compra X Provisใo",,"PCOLOCK")
			
			lRet := .f.
		EndIf		
	EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ VerItens บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verificar se algum item do PC possui nota fiscal relaciona-บฑฑ
ฑฑบ          ณ da. Caso tenha, deve retornar verdadeiro.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerItens()

Local aAreaAnt := GetArea()
Local cNextAli := GetNextAlias()
Local lRetorna := .t.
Local cQry

cQry := " SELECT COUNT(*) AS QTOS "
cQry += " FROM "+RetSqlName('SC7')
cQry += " WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
cQry += " AND   C7_NUM    = '"+SC7->C7_NUM+"' "
cQry += " AND   C7_TIPO   = 1 "
cQry += " AND   C7_QUJE > 0 "
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNextAli )

(cNextAli)->( DbGotop() )

lRetorna := (cNextAli)->QTOS > 0

(cNextAli)->( DbCloseArea() )

RestArea( aAreaAnt )

Return( lRetorna )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ VerItens บAutor  ณ Douglas David      บ Data ณ Maio/2015   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verificar se algum item do PC possui nota fiscal relaciona-บฑฑ
ฑฑบ          ณ da. Caso tenha, deve retornar verdadeiro. OS 1670/15       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerPA()

Local aAreaAnt := GetArea()
Local cNextAli := GetNextAlias()
Local lRetorna := .t.
Local cQry

cQry := " SELECT COUNT(*) AS QTOS "
cQry += " FROM "+RetSqlName('SE2')
cQry += " WHERE E2_NUMPC  = '"+SC7->C7_NUM+"' "
cQry += " AND E2_TIPO = 'PA'"
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNextAli )

(cNextAli)->( DbGotop() )

lRetorna := (cNextAli)->QTOS > 0

(cNextAli)->( DbCloseArea() )

RestArea( aAreaAnt )

Return( lRetorna )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ExistProvบAutor  ณ Douglas David  บ Data ณ Novembro/2015   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verificar se o PC  estแ vinculado em algum provisใo.       บฑฑ
ฑฑบ          ณ OS 3417/15                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExistProv()

Local aAreaAnt := GetArea()
Local cNextAli := GetNextAlias()
Local lRetorna := .t.
Local cQry

cQry := " SELECT COUNT(*) AS QTOS "
cQry += " FROM "+RetSqlName('ZB2')
cQry += " WHERE ZB2_PEDCOM  = '"+SC7->C7_NUM+"' "
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNextAli )

(cNextAli)->( DbGotop() )

lRetorna := (cNextAli)->QTOS > 0

(cNextAli)->( DbCloseArea() )

RestArea( aAreaAnt )

Return( lRetorna )


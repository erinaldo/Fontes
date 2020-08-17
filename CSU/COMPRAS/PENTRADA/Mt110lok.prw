#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |MT110LOK  บAutor  ณCristian Werneck    บ Data ณ  15/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para validar a linha digitada da solicita_บฑฑ
ฑฑบ          ณ cao de compras                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Modulo de Compras                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT110LOK()
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Sergio em Abr/2007: Atendimento ao chamado 001214 - Incluir o campo C1_CLVL na validacao              ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
Local cTxtBlq
Local cEol      := Chr(13)+Chr(10)
Local lContinua := U_VldCTBg( BuscaCols('C1_ITEMCTA'), BuscaCols('C1_CC'), BuscaCols('C1_CLVL'), Nil )

lContinua := lContinua .And. ParamIxb[1]
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Sergio em Dez/2008: Atendimento a OS 3353/08 - Nao permitir o preenchimento do campo memo inferior aos ณ
ณ                     "n" caracteres definidos no parametro. Os testes de desenvolvimento realizados com ณ
ณ                     build atual foram suficientes para garantir que nao ha necessidade de combinar es- ณ
ณ                     te ponto de entrada com o MT110Tok.prw                                             ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
If lContinua .And. Len( AllTrim(BuscAcols('C1_XJUSTIF')) ) < GetNewPar('MV_X_MEMSC',15) .And. !GdDeleted(n)
	cTxtBlq := "O tamanho mํnimo do MEMO deverแ ser "+AllTrim(Str(GetNewPar('MV_X_MEMSC',15)))+" caracteres."
	Aviso("MEMO",cTxtBlq,;
	{"&Fechar"},3,"Tamanho Mํnimo do MEMO",,;
	"PCOLOCK")
	lContinua := .f.
EndIf
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Sergio em Jun/2010: A OS 0344/10 solicita nao permitir alterar itens pendentes de uma SC ja aprovada  ณ
ณ                     se pelo menos um dos itens ja estiver relacionado a algum Pedido de Compra. Para  ณ
ณ                     estes itens, permitir apenas "Deletar". Quando o usuario confirmar este tipo de   ณ
ณ                     alteracao, o sistema nao devera gerar um novo processo de aprovacao da SC.        ณ
ณ                         Para alcancar o objetivo, o ponto de entrada M110Stts.prw teve de ser alteradoณ
ณ                     em conjunto com este ponto de entrada.                                            ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
If lContinua .And. Altera
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Verificar se existe PC colocado para pelo menos um dos itens da SC.                                   ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	If U_ChkPCSC()
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Em caso afirmativo, verificar se algum campo do item posicionado foi alterado.                        ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
		If U_ChkCPAlt()
			cTxtBlq := "Nใo ้ permitido efetuar altera็๕es em itens jแ existentes nas Solicita็๕es de Compras "
			cTxtBlq += "jแ aprovada e com Pedido Colocado."+cEol+cEol
			cTxtBlq += "Dica: ษ possํvel apenas DELETAR itens qua ainda nใo foram baixados atrav้s de Pedidos."
			Aviso("SC x PC Colocado",cTxtBlq,{"&Fechar"},3,"Pedido de Compra jแ Colocado",,"PCOLOCK")
			lContinua := .f.
		EndIf
	EndIf
EndIf             

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Tatiana A. Barbosa em Jun/2011: Atendimento a OS 1262/11 								                 ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
If (!Empty(BuscaCols('C1_X_PRJ')) .And. Empty(BuscaCols('C1_X_ITPRJ')) .Or. Empty(BuscaCols('C1_X_PRJ')) .And. !Empty(BuscaCols('C1_X_ITPRJ')));
   .And. ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+"SC"+cA110Num ) )
	Alert("Quando existir C๓digo de Projeto o campo It.Cod.Proj. deverแ estar preenchido")
	lContinua := .F.
EndIf                                    

If BuscaCols('C1_X_ITPRJ')=="0000"
	Alert("O campo It.Cod.Proj. deve ser maior que zero.")
	lContinua := .F.
EndIf                                    
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Tatiana A. Barbosa em Jun/2011: Atendimento a OS 1263/11 								                 ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
If Empty(BuscaCols('C1_X_PRJ')) .And. ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+"SC"+cA110Num ) )
	Alert("ษ obrigat๓ria a digita็ใo do C๓digo de Projeto na Solicita็ใo de Compra")
	lContinua := .F.
EndIf                                    

If BuscaCols('C1_XVLCAPE') <= 0 .And. ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+"SC"+cA110Num ) )
	Alert("Obrigat๓rio informar o Valor do Capex.")
	lContinua := .F.
EndIf                                    

Return( lContinua )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    | ChkPCSC  บAutor  ณ Sergio Oliveira    บ Data ณ  Jun/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Checar se dentre os itens nao posicionados (diferente do   บฑฑ
ฑฑบ          ณ "n" atual do aCols) se ha Pedido de Compra relacionado.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Validacao da OS 0344/10                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ChkPCSC()

Local cChkPC, lTemPC

cChkPC := " SELECT COUNT(*) AS QTDES "
cChkPC += " FROM "+RetSqlName('SC1')
cChkPC += " WHERE C1_FILIAL =  '"+xFilial('SC1')+"' "
cChkPC += " AND   C1_NUM    =  '"+cA110Num+"' "
cChkPC += " AND   C1_PEDIDO <> '      ' "
cChkPC += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cChkPC, "cChkPC" )

cChkPC->( DbGoTop() )

lTemPC := cChkPC->QTDES > 0

cChkPC->( DbCloseArea() )

Return( lTemPC )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    | ChkCPAlt บAutor  ณ Sergio Oliveira    บ Data ณ  Jun/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Verificar algum campo foi alterado, ou seja, se esta funcaoบฑฑ
ฑฑบDescricao ณ tiver sido chamada significa que devera ser os campos lis- บฑฑ
ฑฑบ          ณ tados na matriz _aNPdMudar. Caso algum destes campos esti- บฑฑ
ฑฑบ          ณ ver diferente da base de dados, retornar False.            บฑฑ
ฑฑบ          ณ Esta funcao somente podera ser acionada atraves dos pontos บฑฑ
ฑฑบ          ณ de entrada MT110Tok e MT110Lok.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Validacao da OS 0344/10                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ChkCPAlt()

Local _aNPdMudar := {'C1_PRODUTO','C1_X_PRJ','C1_QUANT','C1_CC','C1_ITEMCTA','C1_CLVL','C1_SOLICIT'}
Local cVerifik, cNxtAlias := GetNextAlias()
Local lAlterou   := .f.
Local nTamC1QT   := TamSX3('C1_QUANT')[2]

cVerifik := " SELECT C1_PRODUTO "
For wXP := 2 To Len(_aNPdMudar)
	cVerifik += ", "+_aNPdMudar[wXP]
Next
cVerifik += " FROM "+RetSqlName('SC1')
cVerifik += " WHERE C1_FILIAL  =  '"+xFilial('SC1')+"' "
cVerifik += " AND   C1_NUM     =  '"+cA110Num+"' "
cVerifik += " AND   C1_ITEM    =  '"+GdFieldGet("C1_ITEM")+"' "
cVerifik += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cVerifik, cNxtAlias )

(cNxtAlias)->( DbGoTop() )

For wXP := 1 To Len(_aNPdMudar)
    If 'C1_QUANT' $ _aNPdMudar[wXP]
		If Round( GdFieldGet(_aNPdMudar[wXP]), nTamC1QT ) # Round( (cNxtAlias)->&(_aNPdMudar[wXP]), nTamC1QT )
		   lAlterou := .t.
		EndIf
    ElseIf 'C1_SOLICIT' $ _aNPdMudar[wXP]
		If (cNxtAlias)->&(_aNPdMudar[wXP]) # cA110Sol
		   lAlterou := .t.
		EndIf
    Else
		If GdFieldGet(_aNPdMudar[wXP]) # (cNxtAlias)->&(_aNPdMudar[wXP])
		   lAlterou := .t.
		EndIf
	EndIf
Next

Return( lAlterou )
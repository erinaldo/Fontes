#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA110BAR  ºAutor  ³ Sergio Oliveira    º Data ³  Out/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para Incluir botoes de usuario na visua-  º±±
±±º          ³lizacao da Solicitacao de Compras.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA110BAR()

Local _aButt := {}
Public l_TemCtr := .F. // OS 3239/09 - DEFINIR SE TEM CONTRATO OU NÃO.

If Select('ZA8') == 0
   ChkFile('ZA8')
EndIf

AAdd(_aButt,{ "VENDEDOR", {|| Conaprov() }, 'Consulta Aprovadores' } )
AAdd(_aButt,{ "USER", {|| ConSolic() }, 'Solicitante' } )    
AAdd(_aButt,{ "HISTORIC", {|| U_HistDev() }, 'Devoluções' } )    

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ # Chamado 004163: Gerar o controle de  CAPEX.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
AAdd(_aButt,{ "PRECO" , {|| Capex(1)   }, 'CAPEX' } )
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ # Chamado 004603: Gerar o controle de PROJETOS.                            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
//AAdd(_aButt,{ "PRECO"   , {|| Capex(2)   }, 'PROJETO' } )

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ # Chamado 3239/09: Gerar o controle de CONTRATOS.                            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
AAdd(_aButt,{ "BMPSDOC"   , {|| Contrato(1)   }, 'Contrato' } )

Return(_aButt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ConAprov  ³ Autor ³ Sergio Oliveira       ³ Data ³ Out/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta os aprovadores do Documento.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ma110bar.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ConAprov()

Local cPag   := cA110Num, cSituaca := ''
Local aCampos:= {}, _aStru := {}, _aAreaAnt := GetArea()
Local oFont  := TFont():New("Tahoma",9,,,.T.,,,,,.F.) // Com Negrito
Local cNtAlias := GetNextAlias()
Local oMens, cSelect

// Sergio em 23/Set/2009: Tratar as situacoes quando esta rotina nao tiver sido 
//                        chamada pelo MATA110:

cSelect := " SELECT CR_STATUS, CR_USER, CR_DATALIB, CR_X_TPLIB, CR_FILIAL, CR_TIPO, CR_NUM "
cSelect += " FROM "+RetSqlName('SCR')
cSelect += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
cSelect += " AND   CR_TIPO    = 'SC' "
cSelect += " AND   CR_NUM     = '"+cPag+"' "
cSelect += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cSelect, cNtAlias )

(cNtAlias)->( DbGoTop() )

// Obter os dados para exibicao:

AADD(aCampos,{"APROVADOR" ,"Aprovador"  ,"@!"})
AADD(aCampos,{"SITUACAO"  ,"Situacao"   ,"@!"})
AADD(aCampos,{"_DATA"     ,"Atualizacao","@!"})

AAdd( _aStru, {"APROVADOR" , 'C', 30,0} )
AAdd( _aStru, {"SITUACAO"  , 'C', 20,0} )
AAdd( _aStru, {"_DATA"     , 'D', 08,0} )

_cTmp := CriaTrab(_aStru,.t. )

If Select(_cTmp) > 0
	(_cTmp)->(DbCloseArea())
EndIf

DbUseArea(.t.,,_cTmp,_cTmp,.f.)

While !(cNtAlias)->(Eof())
	
	(_cTmp)->( RecLock(_cTmp,.t.) )
	(_cTmp)->APROVADOR := UsrFullName((cNtAlias)->CR_USER)
	Do Case
		Case (cNtAlias)->CR_STATUS == "01"
			IIF((cNtAlias)->CR_X_TPLIB == 'A', cSituaca := 'Aguardando Aprovacao', cSituaca := 'Aguardando Visto' )
		Case (cNtAlias)->CR_STATUS == "02"
			IIF((cNtAlias)->CR_X_TPLIB == 'A', cSituaca := 'Em Aprovacao', cSituaca := 'Vistando' )
		Case (cNtAlias)->CR_STATUS == "03"
			IIF((cNtAlias)->CR_X_TPLIB == 'A', cSituaca := 'Aprovado', cSituaca := 'Vistado' )
		Case (cNtAlias)->CR_STATUS == "04"
			cSituaca := 'Bloqueado'
		Case (cNtAlias)->CR_STATUS == "05"
			cSituaca := 'Nivel Liberado'
	EndCase
	(_cTmp)->SITUACAO := cSituaca
	(_cTmp)->_DATA    := Stod( (cNtAlias)->CR_DATALIB )
	(_cTmp)->( MsUnLock() )

	(cNtAlias)->( DbSkip() )
	
EndDo

(cNtAlias)->(DbCloseArea())
(_cTmp)->(DbGoTop())

If (_cTmp)->(Eof())
	Aviso("Atencao","Esta Solicitacao de Compras nao possui controle de aprovacao.",{"Voltar"})
	RestArea(_aAreaAnt)
	Return
EndIf

@ 273,193 To 535,748 Dialog Mkwdlg
@ 004,004 To 130,233 Title "Consulta aos Aprovadores da Solicitacao de Compras"
@ 037,236 To 085,271  // "Area do Botao Ok"
@ 031,004 To 130,233 Browse _cTmp Fields aCampos  // "Area do Browse"
@ 017,010 Say "Nro. da SC" Size 62,08
@ 017,076 Say cA110Num Color 8388608 Object oMens SIZE 96,12
@ 054,240 Button "_Ok" Size 27,16 Action(Close(Mkwdlg))

oMens:ofont:=ofont

Activate Dialog Mkwdlg

DbSelectArea(_cTmp)
DbCloseArea(_cTmp)

RestArea(_aAreaAnt)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ConSolic ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta o usuario que efetuou a inclusao.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ma110bar.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ConSolic()

Local cUsu	:= SC1->C1_USER
Local cNome := ""
           
cNome := Alltrim(UsrFullName(cUsu))

Aviso("Nome do Solicitante",cNome,{'OK'})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Capex    ³ Autor ³ Sergio Oliveira       ³ Data ³ Mai/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informar se a Solicitacao de Compras possui CAPEX.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ma110bar.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Capex(nOpcB)

Local oMens1
Local cTpZA8       := IIF( nOpcB == 1, "SC", "PR" )
Local cTitJan      := IIF( nOpcB == 1, "Capex", "Projeto" )
Local lTemCapex    := ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+cTpZA8+cA110Num ) )
Local nColMsg      := 82
Local nRegZA8      := ZA8->( Recno() )
Private oFont      := TFont():New("Tahoma",12,,,.T.,,,,,.F.) // Com Negrito
Private cMemoDaObs := "", cTxtTopo := "", cMsgBlq := ""

// Antes de mais nada, nao permitir a utilizacao de um tipo quando existir outro:
//OS 3239/09 - Controle de contratos
If l_TemCtr
   	If MsgBox('Já foi definida a opção Contrato para essa solicitação. Deseja retirar essa opção?.','Atenção!!!','YesNo')
   		l_TemCtr := .F.
	Else
		Return	
	EndIf
EndIf

If "SC" $ cTpZA8 .And. ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+"PR"+cA110Num ) )
   cMsgBlq := "Tentativa de utilização de Capex com Projeto já relacionado à esta Solicitação."+Chr(13)+Chr(10)
   cMsgBlq += "Operação não permitida."
ElseIf "PR" $ cTpZA8 .And. ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+"SC"+cA110Num ) )
   cMsgBlq := "Tentativa de utilização de Projeto com Capex já relacionado à esta Solicitação."+Chr(13)+Chr(10)
   cMsgBlq += "Operação não permitida."
EndIf

If !Empty( cMsgBlq )
	Aviso(" NA SOLICITAÇÃO",cMsgBlq,;
		{"Voltar"},3,"Atualização de "+cTitJan,,;
		"PCOLOCK")
	Return
EndIf

ZA8->( DbGoTo( nRegZA8 ) )

// Verificar se ja existe a referencia. Caso exista, exibi-la juntamente com o possivel
// comentario:

If lTemCapex
   cMemoDaObs := ZA8->ZA8_OBS
   If nOpcB == 1
	   cTxtTopo   := " (Solicitação com Capex)"
   Else
	   cTxtTopo   := " (Solicitação com Projeto)"
   EndIf
   nColMsg    := 20
EndIf

Define MsDialog oDlg_ Title cTitJan From 185,281 to 512,718 of oMainWnd Pixel
@ 002,004 To 159,212
@ 040,004 To 159,212
@ 045,008 To 155,160 Title "Observações"
@ 064,163 To 130,209 Title OemToAnsi("Opções")
@ 021,nColMsg Say cTitJan+cTxtTopo Color 8388608 Object oMens1 Size 182,070 
@ 054,011 Get cMemoDaObs Memo Size 145,87 When .t.
@ 079,167 Button "_Gravar "+cTitJan  Size 40,16 Action( AtuCapex(1, cTitJan, cTpZA8), oDlg_:End() ) 
@ 100,167 Button "_Excluir "+cTitJan Size 40,16 Action( AtuCapex(2, cTitJan, cTpZA8), oDlg_:End() )

oMens1:ofont:=ofont

Activate MsDialog oDlg_ Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AtuCapex ³ Autor ³ Sergio Oliveira       ³ Data ³ Mai/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Proceder com a atualizacao da base.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ma110bar.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtuCapex( pnOpcao, cTitJan, cTpZA8 )

Local cMsg := "Deseja confirmar "
Local cOperacao
Local lTemCaPex := ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+cTpZA8+cA110Num ) )

If pnOpcao == 1 .And. lTemCapex
   cOperacao := "Já existe "+cTitJan+" para esta Solicitação de Compras. Deseja proceder com a alteração da observação?"
ElseIf pnOpcao == 1 .And. !lTemCaPex
   cOperacao := "Deseja confirmar que existe "+cTitJan+" para esta Solicitação de Compras?"
ElseIf pnOpcao == 2   
   cOperacao := "Deseja confirmar a exclusão deste "+cTitJan+" para esta Solicitação de Compras?"
EndIf   

If Aviso(cTitJan+" NA SOLICITAÇÃO",cOperacao,;
		{"Não Confirmar","Confirmar"},3,"Atualização de "+cTitJan,,;
		"PCOLOCK") == 1
   MsgBox('Operação não confirmada','Nao Confirmada','INFO')
   Return
EndIf

If lTemCapex
   ZA8->( RecLock('ZA8',.f.) )
Else
   ZA8->( RecLock('ZA8',.t.) )
EndIf

If pnOpcao == 2
   ZA8->ZA8_COMPUT := GetComputerName()
   ZA8->( DbDelete() )
Else
   ZA8->ZA8_FILIAL := xFilial('ZA8')
   ZA8->ZA8_TIPO   := cTpZA8
   ZA8->ZA8_DOC    := cA110Num  
   ZA8->ZA8_OBS    := cMemoDaObs
   ZA8->ZA8_COMPUT := GetComputerName()
EndIf
ZA8->( MsUnLock() )

Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Contrato    ³ Autor ³ Renato Carlos       ³ Data ³ Dez/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informar se a Solicitacao de Compras possui Contrato       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ma110bar.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Contrato(nOpcB)


Local cTpZA8       := IIF( nOpcB == 1, "SC", "PR" )
Local cTitJan      := IIF( nOpcB == 1, "Capex", "Projeto" )
Local lTemCapex    := ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+cTpZA8+cA110Num ) )
//Local nColMsg      := 82
Local nRegZA8      := ZA8->( Recno() )
Private oFont      := TFont():New("Tahoma",12,,,.T.,,,,,.F.) // Com Negrito
Private cMemoDaObs := "", cTxtTopo := "", cMsgBlq := ""

If l_TemCtr
   	If MsgBox('Já foi definida a opção Contrato para essa solicitação. Deseja retirar essa opção?.','Atenção!!!','YesNo')
   		l_TemCtr := .F.
		Return
	Else
		Return	
	EndIf
EndIf

// Antes de mais nada, nao permitir a utilizacao de um tipo quando existir outro:
If lTemCapex
   cMsgBlq := "Já existe um Capex relacionado à esta Solicitação."+Chr(13)+Chr(10)
   cMsgBlq += "Operação não permitida."
EndIf

If !Empty( cMsgBlq )
	Aviso(" NA SOLICITAÇÃO",cMsgBlq,;
		{"Voltar"},3,"Atualização de "+cTitJan,,;
		"PCOLOCK")
	Return
EndIf

If !MsgBox('Deseja definir solicitação como Contrato?.','Atenção!!!','YesNo')
	Return	
EndIf

l_TemCtr := .T.

Return
       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ HistDev  ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta o historico de devolucoes/justificativas da SC.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ma110Bar.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HistDev()

Local cJustific := "", cQry := '', cNxtAlias := CriaTrab(Nil,.f.), cCombo := ""
Local oMens2
Local oFont   := TFont():New("Tahoma",11,,,.T.,,,,,.F.) // Com Negrito
Local aListBox := {}

If Select('ZAB') == 0
	ChkFile('ZAB')
EndIf

cQry := " SELECT R_E_C_N_O_ AS REGS "
cQry += " FROM "+RetSqlName('ZAB')
cQry += " WHERE ZAB_FILIAL = '"+xFilial('ZAB')+"' "
cQry += " AND   ZAB_NUM    = '"+SC1->C1_NUM+"' "
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNxtAlias )

(cNxtAlias)->( DbGoTop() )

While !(cNxtAlias)->( Eof() )
	
	ZAB->( DbGoTo((cNxtAlias)->REGS) )
	
	AADD(aListBox,{ZAB->ZAB_NUM,ZAB->ZAB_SEQ,ZAB->ZAB_JUSTIF,ZAB->ZAB_RESPON,ZAB->ZAB_NOME,ZAB->ZAB_MAKINA,ZAB->ZAB_DATA_,ZAB->ZAB_HORA } )
	
	(cNxtAlias)->( DbSkip() )
	
EndDo

If Len( aListBox ) == 0
	Aadd( aListBox, { '','','','','','',Ctod(''),'' } )
EndIf

Define MsDialog MkwODlg Title "Devolucoes/Justificativas" From 128,059 To 559,787 Of oMainWnd Pixel

@ 004,001 To 212,293
@ 080,001 LISTBOX oListBox VAR cVar FIELDS HEADER "Numero"  ,;
"Seq",;
"Justificativa"  	,;
"Responsavel"  	,;
"Nome"  	,;
"Terminal" ,;
"Data"    ,;
"Hora" SIZE 292,125 PIXEL of mkwOdlg
oListBox:SetArray(aListBox)

oListBox:bLine:={ || { aListBox[oListBox:nAt,01],;
aListBox[oListBox:nAt,02],;
aListBox[oListBox:nAt,03],;
aListBox[oListBox:nAt,04],;
aListBox[oListBox:nAt,05],;
aListBox[oListBox:nAt,06],;
aListBox[oListBox:nAt,07],;
aListBox[oListBox:nAt,08] }}

@ 027,297 To 184,355
@ 040,069 Say "Histórico das Justificativas" Color 8388608 Object oMens3 Size 179,19
@ 050,308 Button "_Vis. Just." Size 41,19 Action( MostraMemo(oListBox, aListBox) )
@ 110,308 Button "_Abandonar"  Size 41,16 Action( MkwODlg:End() )

oMens3:ofont:=ofont

Activate MsDialog mkwOdlg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³MostraMemoºAutor  ³ Sergio Oliveira    º Data ³  Ago/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exibe a justificativa gravada.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MA110Bar.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MostraMemo(oListBox, aListBox)

If Len( aListBox ) > 0
	
	Aviso("JUSTIFICATIVA - SEQ "+aListBox[oListBox:nat][2],aListBox[oListBox:nat][3],;
	{"&Fechar"},3,"Justificativa",,;
	"PMSAPONT")
	
EndIf

Return
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Ponto de  ³MT110TOK  ³Autor  ³Leonardo Soncin        ³Data  ³20/10/2006³±±
±±³Entrada   ³          ³       ³                       ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Ponto de Entrada para validar exclusao e alteracao da       ³±±
±±³          ³solicitacao de compras.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico CSU                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sergio      |Out/2006  | Ajuste na validacao do workflow.              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT110TOK()

Local aAreaAnt := GetArea()
Local lRet     := .t., cEol := Chr(13)+Chr(10), cLaudo := ''
Private _k     := 1

If !Inclui .And. !U_SeEhCopia()
	/*
	DbSelectArea('SCR')
	DbSetOrder(1)
	If DbSeek(xFilial('SCR')+"SC"+SC1->C1_NUM)
	If GetNewPar('MV_X_WFSC',.f.) == .f.
	If !SCR->CR_WF # ' '
	cMsg := "Esta solicitação de compras não pode"
	cMsg += "ser Alterada ou Excluida pois já enviada pelo Workflow."
	cLaudo := cMsg+cEol
	lRet := .f.
	EndIf
	Else
	If SCR->CR_STATUS $ '03/05'
	cMsg := "Esta solicitação de compras não pode"
	cMsg += "ser Alterada ou Excluida pois já foi Aprovada."
	cLaudo := cMsg+cEol
	lRet := .f.
	EndIf
	EndIf
	EndIf
	*/
EndIf
If lRet

    If Select('SAK') == 0
       ChkFile('SAK')
       SAK->( DbSetOrder(1) )
    EndIf
	If Select('SZI') == 0
		ChkFile('SZI')
	EndIf
	If Select('ZA6') == 0
		ChkFile('ZA6')
	EndIf
                                       
	SZI->( DbSetOrder(5) ) // ZI_NMUSER+ZI_FLGCOM
	If SZI->( DbSeek( xFilial("SZI")+ca110SOL+'1' ) )
		ZA6->( DbSetOrder(1) )
		If ZA6->( DbSeek( xFilial("ZA6")+SZI->ZI_CCUSTO ) )
		
			If Empty(ZA6->ZA6_CAPSC1)
				cMsg := "Centro de custo sem aprovador de solicitacao informado."
				cMsg += "Entre em contato com o responsavel."
				cLaudo := cMsg+cEol
				lRet := .f.	
			Else
				If !SAK->( DbSeek( xFilial("SAK")+ZA6->ZA6_CAPSC1 ) )
					cMsg := "Aprovador de solicitacao do centro de custo inexistente."
					cMsg += "Entre em contato com o responsavel."
					cLaudo := cMsg+cEol
					lRet := .f.
				Else
					If Empty(UsrRetMail( SAK->AK_USER ))	//If Empty(UsrRetMail( SAK->AK_COD ))
						cMsg := "Aprovador de solicitacao de compra sem e-mail cadastrado."
						cMsg += "Entre em contato com o responsavel."
						cLaudo := cMsg+cEol
						lRet := .f.
					EndIf
				EndIf
			EndIf
			
		Else
			cMsg := "Centro de custo sem amarracao com aprovador de solicitacao."
			cMsg += "Entre em contato com o responsavel."
			cLaudo := cMsg+cEol
			lRet := .f.
		EndIf
	Else
		cMsg := "Solicitante sem nenhum centro de custo autorizado."
		cMsg += "Entre em contato com o responsavel."
		cLaudo := cMsg+cEol
		lRet := .f.
	EndIf

	// ->Verificar se o usuario + aprovador tem email;
	If Empty(UsrRetMail( __cUserId ))
		cMsg := "Voce nao tem e-mail preenchido no seu usuario do sistema."
		cMsg += "Entre em contato com o responsavel."
		cLaudo := cMsg+cEol
		lRet := .f.
	EndIf



   /* Comentado por Jadao em 30/01/2007 - Inicio
	// ->Verificar se o usuario logado tem aprovador;
	DbSelectArea('SAI')
	DbSetOrder(2)  // AI_FILIAL+AI_USER
	If !DbSeek( xFilial('SAI')+__cUserId )
		cMsg := "Voce nao esta cadastado como usuario Solicitante."
		cMsg += "Entre em contato com o responsavel."
		cLaudo := cMsg+cEol
		lRet := .f.
	Else
		If Empty(SAI->AI_XAPROV)
			cMsg := "Nao existe aprovador relacionado ao seu codigo de Solicitante."
			cMsg += "Entre em contato com o responsavel."
			cLaudo := cMsg+cEol
			lRet := .f.
		EndIf
	EndIf
	// ->Verificar se o usuario + aprovador tem email;
	If Empty(UsrRetMail( __cUserId ))
		cMsg := "Voce nao tem e-mail preenchido no seu usuario do sistema."
		cMsg += "Entre em contato com o responsavel."
		cLaudo := cMsg+cEol
		lRet := .f.
	EndIf*/
	If lRet
		/*DbSelectArea('SAK')
		DbSetOrder(1)
		If !DbSeek(xFilial('SAK')+SAI->AI_XAPROV)
			cMsg := "Existe um erro no aprovador relacionado ao seu codigo de usuario."
			cMsg += "Entre em contato com o responsavel."
			cLaudo := cMsg+cEol
			lRet := .f.
		Else
			If Empty(UsrRetMail( SAK->AK_USER ))
				cMsg := "O aprovador relacionado ao seu codigo de usuario nao possui e-mail preenchido."
				cMsg += "Entre em contato com o responsavel."
				cLaudo := cMsg+cEol
				lRet := .f.
			EndIf
		EndIf */ // Final do comentario Jadao - 31/01/2007
		// ->Verificar se o produto tem grupo de compras;
		// ->Verificar se os compradores e se os aprovadores do PC tem email;
		// ->Verificar se o grupo de compra tem grupo de aprovação;
		// ->Verificar se o produto possui amarracao Produto x Fornecedor;
		DbSelectArea('SY1')
		DbSetOrder(3)  // Y1_FILIAL+Y1_USER
		
		DbSelectArea('SAL')
		DbSetOrder(1)  // AL_FILIAL+AL_COD+AL_ITEM
		
		DbSelectArea('SA5')
		DbSetOrder(2)  // A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
		
		DbSelectArea('SAJ')
		DbSetOrder(1)  // AJ_FILIAL+AJ_GRCOM+AJ_ITEM (AJ_XGRAPRO)
		
		DbSelectarea('SB1')
		DbSetOrder(1)
		For _k := 1 To Len(aCols)
			If aCols[_k][Len(aCols[_k])] // Linha Deletada
				Loop
			EndIf
			
			// verificar unidade de negocio x centro de custo
			/*
			If SubStr(aCols[_k][GdFieldPos('C1_CC')],1,2) <> SubStr(aCols[_k][GdFieldPos('C1_ITEMCTA')],1,2)  // unidade de negocio deve ser a mesma do centro de custo
				lRet := .f.
				cLaudo += "Unidade de negocio nao e a mesma do Centro de Custo."
			EndIf
			*/
			
			DbSelectArea('SB1')
			DbSeek( xFilial('SB1')+aCols[_k][GdFieldPos('C1_PRODUTO')] )

			DbSelectArea('SA5')
			DbSeek( xFilial('SA5')+aCols[_k][GdFieldPos('C1_PRODUTO')] )
			If !Found() //.And. !VerCont()
				cLaudo += "Produto: "+Trim(SB1->B1_COD)+" / "+Trim(SB1->B1_DESC)+" -> Nao possui amarracao Produto x Fornecedor."+cEol	
				lRet := .f.
			EndIf
			If Empty( SB1->B1_GRUPCOM )
				cLaudo += "Produto: "+Trim(SB1->B1_COD)+" / "+Trim(SB1->B1_DESC)+" -> Nao possui Grupo de Compras Relacionado."+cEol
				lRet := .f.
			Else
				// Primeira rodada do SAJ: Verificar somente os compradores
				DbSelectArea('SAJ')
				DbSeek( xFilial('SAJ')+SB1->B1_GRUPCOM )
				While !Eof() .And. SAJ->(AJ_FILIAL+AJ_GRCOM) == xFilial('SAJ')+SB1->B1_GRUPCOM
					
					DbSelectArea('SY1')
					DbSeek(xFilial('SY1')+SAJ->AJ_USER)
					If Empty(UsrRetMail(SAJ->AJ_USER))
						cLaudo += "O comprador: "+Trim(UsrFullName(SAJ->AJ_USER))+" -> Nao possui e-mail preenchido."+cEol
						lRet := .f.
					EndIf
					
					DbSelectArea('SAJ')
					DbSkip()
					
				EndDo

				

				/*
				// Verificar se existe e se as informacoes do grupo de aprovacao esta ok.
				DbSelectArea('SAJ')
				DbSeek( xFilial('SAJ')+SB1->B1_GRUPCOM )
				
				DbSelectArea('SAL')
				If DbSeek( xFilial('SAL')+SAJ->AJ_XGRAPRO )
					While !Eof() .And. SAL->(AL_FILIAL+AL_COD) == xFilial('SAL')+SAJ->AJ_XGRAPRO
						
						If Empty(UsrRetMail(SAL->AL_USER))
							cLaudo += "O aprovador: "+Trim(UsrFullName(SAL->AL_USER))+" -> Nao possui e-mail preenchido."+cEol
							lRet := .f.
						EndIf
						
						DbSelectArea('SAL')
						DbSkip()
						
					EndDo
				Else
					cLaudo += "Nao existe grupo de aprovacao relacionado ao grupo de compras: "+SB1->B1_GRUPCOM+cEol
					lRet := .f.
				EndIf
				*/

			EndIf
		Next
	EndIf
	
Endif

If !lRet
	ExibLog(cLaudo)
EndIf

lRet := lRet .And. ParamIxb[1] 

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³SeEhCopia ºAutor  ³ Sergio Oliveira     ºData ³ Out/2006    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se a funcao chamada e a de Copiar.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada M110Tok.prw                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SeEhCopia()

Local _lFunc := .f.

For _i := 1 To 15
	
	If 'A110COPIA' $ ProcName(_i)
		_lFunc := .t.
		Exit
	EndIf
	
Next

Return(_lFunc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ ExibLog  ºAutor  ³ Sergio Oliveira     ºData ³ Nov/2006    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibir as ocorrencias caso faltar alguma informacao.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada M110Tok.prw                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExibLog(pcDscLog)

Private cTitulo := "Houve problema na atualizacao da Solicitacao de Compras"

@ 065,025 To 516,691 Dialog mkwdlg Title cTitulo
@ 007,008 To 207,272 Title "Descricao do Problema"
@ 023,019 Get pcDscLog MEMO Size 242,177 When .f.
@ 100,280 Button OemToAnsi("_Sair")     Size 43,16 Action(Close(MkwDlg))

Activate Dialog mkwdlg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ VerCont  ºAutor  ³ Sergio Oliveira     ºData ³ Nov/2006    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verificar se os itens possuem contrato vigente de acordo   º±±
±±º          ³ com a data de necessidade da SC.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada M110Tok.prw                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VerCont()

Local lRet := .t.

DbSelectarea('SA2')
DbSetOrder(1)

SB1->( DbSeek(xFilial("SB1")+aCols[_k][GdFieldPos('C1_PRODUTO')]) )

If !Empty(SB1->B1_PROC) .And. !Empty(SB1->B1_LOJPROC) .And. SB1->B1_XPRVNEG > 0 .And.;
	Dtos(aCols[_k][GdFieldPos('C1_DATPRF')]) >= Dtos(SB1->B1_XDTINEG) .And. Dtos(aCols[_k][GdFieldPos('C1_DATPRF')]) <= Dtos(SB1->B1_XDTFNEG)
	If SA2->( DbSeek( xFilial('SA2')+SB1->(B1_PROC+B1_LOJPROC) ) ) .And. Empty( SA2->A2_COND )
		lRet := .f.
	EndIf
Else
	lRet := .f.
EndIf

Return( lRet )
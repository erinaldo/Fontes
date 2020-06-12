#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  FA100TRF º Autor ³ Andy               º Data ³  24/03/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada executado no Estorno de Transferencia     º±±
±±º          ³ Bancaria - FINA100, o status da movimentacoes originais    º±±
±±º          ³ fiquem como status de cancelados e não se gere as          º±±
±±º          ³ movimentacoes de estorno                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA100TRF(pBlock,lLog1,lLog2,pCampos)          

// cBcoOrig, cAgenOrig, cCtaOrig,
// cBcoDest, cAgenDest, cCtaDest,
// cTipoTran, cDocTran, nValorTran,
// cHist100, cBenef100, cNaturOri,
// cNaturDes,cModSpb,lEstorno

Local _aAreaSE5
Local _cChave
Local _lRet := .T.


MSGINFO("Campos ",AllTrim(ParamIXB[8]))


aTam := TamSx3("E5_PREFIXO")
nTamTit := aTam[1]
aTam := TamSx3("E5_NUMERO")
nTamTit += aTam[1]
aTam := TamSx3("E5_PARCELA")
nTamTit += aTam[1]
aTam := TamSx3("E5_TIPO")
nTamTit += aTam[1]

lGrava := .T.


If SE5->( dbSeek(xFilial("SE5")+"TR"))
	While ( SE5->E5_FILIAL == xFilial("SE5")) .And. ;
		( SE5->E5_TIPODOC == "TR" )
		IF SE5->E5_DOCUMEN <> ALLTRIM(MV_PAR01)
			SE5->(DBSKIP())
			LOOP
		ENDIF
		IF (SE5->E5_DATA <> MV_PAR02)
			SE5->(DBSKIP())
			LOOP
		ENDIF
		Reclock("SE5",.F.)
		SE5->E5_TIPODOC := "CA"
		SE5->(MsUnlock())
		SE5->(DBSKIP())
	End
ENDIF


/*
IF lGrava
   fa100grava(cBcoOrig,cAgenOrig,cCtaOrig,cNatOrig,;
	   cBcoDest,cAgenDest,cCtaDest,cNatDest,;
	   cMoedaTran,cDoc,nVlrEstorno, cHist100,cBenef100,lEstorno, cModSpb)
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava tipodoc com TE indicando o estorno da transfe-³
//³ rencia. 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
/*
dbSelectArea("SE5")
If nRegOrigem > 0
	dbGoto(nRegOrigem)
	Reclock("SE5")
	Replace E5_TIPODOC With "TE"     // Transf estornada
	MsUnlock()
Endif

If nRegDestino > 0
	dbGoto(nRegDestino)
	Reclock("SE5")
	Replace E5_TIPODOC With "TE"     // Transf estornada
	MsUnlock()
Endif

dbSetOrder( nOldOrdSE5 )
dbGoTo( nOldRecSE5 )
If cPaisLoc <> "BRA" .And. Type("bFiltraBrw") == "B"
	Eval( bFiltraBrw )
Endif	

*/


_aAreaSE5 := SE5->(GetArea())
If ParamIXB[15]
	SE5->(dbSetOrder(2))
	If SE5->( dbSeek(xFilial("SE5")+"TR"))
		While ! Eof()      					    .And. ;
			( SE5->E5_FILIAL == xFilial("SE5")) .And. ;
			( SE5->E5_TIPODOC == "TR" )
			
			If Alltrim(SE5->E5_NUMCHEQ)	== 	Alltrim(ParamIXB[8]) .And.	 ;
				SE5->E5_BANCO		== 	ParamIXB[4]              .And.	 ;
				SE5->E5_AGENCIA	    == 	ParamIXB[5]              .And.	 ;
				SE5->E5_CONTA		== 	ParamIXB[6]              .And.	 ;
				SE5->E5_RECPAG 	    == 	"P"
				Reclock("SE5",.F.)
				dbDelete()
				MsUnlock()                                   
				_lRet := .F.
			EndIf
			If AllTrim(SE5->E5_DOCUMEN) == AllTrim(ParamIXB[8]) .And. ;
			SE5->E5_BANCO		== 	ParamIXB[1]              .And.	 ;
			SE5->E5_AGENCIA	    == 	ParamIXB[2]              .And.	 ;
			SE5->E5_CONTA		== 	ParamIXB[3]              .And.	 ;
			SE5->E5_RECPAG 	    == "R"               
				Reclock("SE5",.F.)
				dbDelete()
				MsUnlock()
			    _lRet := .F.
			    Exit
			EndIf          
			SE5->(dbSkip())
		EndDo
	Endif
EndIf

SE5->(RestArea(_aAreaSE5))

Return(_lRet)


#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA050ALT º Autor ³ Emerson / Cristiano             º Data ³  10/01/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada disparado na alteracao dos titulos a pagar. Dispara o  º±±
±±º          ³ Rateio ( quando necessario ) e executa validacoes diversas.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Csu CardSystem                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FA050ALT()

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³               Declara as Variaveis Utilizadas na Rotina                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Local nValTit := 0
Local lRet 	  := .T.
Local aArea   := GetArea()
Local cRetNiv := "0"
Local aColAnt := AClone(aCols) // 0899-12 - error log na alteração do titulo com rateio


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ OS 1573/09: Inclusao da verificacao das entidades contabeis.               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

aCols := Nil 

If !U_VldCTBg( M->E2_ITEMD, M->E2_CCUSTO, M->E2_CLVLDB, Nil )
   RestArea( aArea )
   Return( .f. )
EndIf

aCols := aColAnt //0899-12 - error log na alteração do titulo com rateio

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             Chama a Funcao que exibe a Tela de Rateio                      ³
³   Caso o Campo de Rateio tenha sofrido alteracao de 1 = Sim para 2 = Nao   ³
³         Apaga todas as Movimentacoes do Rateio para esse Titulo            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
 
If SE2->E2_RATESP == "1" .And. M->E2_RATESP == "2"
	nValTit := SE2->E2_VALOR + SE2->E2_ISS + SE2->E2_IRRF + SE2->E2_INSS + SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL
	u_RFinA06( SE2->E2_PREFIXO ,  SE2->E2_NUM ,  SE2->E2_PARCELA,  SE2->E2_TIPO ,  SE2->E2_FORNECE ,  SE2->E2_LOJA ,  nValTit , 5 )
Endif
  
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³  Caso o Campo de Rateio esteja igual a 1 = Sim , Chama a Rotina de Rateio  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
 
If M->E2_RATESP == "1"
	nValTit := M->E2_VALOR + M->E2_ISS + M->E2_IRRF + M->E2_INSS + M->E2_VRETPIS + M->E2_VRETCOF + M->E2_VRETCSL
	u_RFinA06( SE2->E2_PREFIXO ,  SE2->E2_NUM ,  SE2->E2_PARCELA,  SE2->E2_TIPO ,  SE2->E2_FORNECE ,  SE2->E2_LOJA ,  nValTit , 4 )
Endif
 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³     Caso seja alteracao estorna as liberacoes efetuadas anteriormente      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If Upper( AllTrim(SE2->E2_ORIGEM) ) <> "MATA100" .And. Left( SE2->E2_XCONF01 , 3 ) <> 'CP:'
	Aviso("A T E N C A O","Você alterou o título e será necessária nova conferência!",{'Ok'})
	M->E2_XLIBNIV := cRetNiv
	M->E2_XCONF01 := ""
	M->E2_XCONF02 := ""                                                     
	M->E2_XCONF03 := ""
	M->E2_DATALIB := Ctod('  /  /  ')
	u_A91Repli( SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM  , cRetNiv )
EndIf
  

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³          Restaura as areas originais antes da execucao da rotina           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F050REPLI º Autor ³ Emerson Custodio    º Data ³ 10/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa replica dos status para movimento de impostos.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU					                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F050REPLI(cNUMSE2,cLIBNIV)

////////////
//DECLARA VARIAVEIS
////////////
Local aAREATU := GetArea()
Local aAREAE2 := SE2->(GetArea())
Local aIMPOST := {}
Local cCOMISS := "ISS" + Left(StrTran(GetMV("MV_MUNIC"),'"') + Space(6),6) + "00"
Local cCOMINS := "INS" + Left(StrTran(GetMV("MV_FORINSS"),'"') + Space(6),6) + "00"
Local cCOMIRR := "TX" + Space(1) + Left(StrTran(GetMV("MV_UNIAO"),'"') + Space(6),6) + "00"

////////////
//EFETUA CARGA DO ARRAY
////////////
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCIR  + cCOMIRR,SE2->E2_IRRF  })
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCISS + cCOMISS,SE2->E2_ISS   })
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCINS + cCOMINS,SE2->E2_INSS  })
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCCOF + cCOMIRR,SE2->E2_COFINS})
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCPIS + cCOMIRR,SE2->E2_PIS   })
AAdd(aIMPOST,{cNUMSE2 + SE2->E2_PARCSLL + cCOMIRR,SE2->E2_CSLL  })

////////////
//EXECUTA GRAVACAO DO CAMPO DE CONTROLE PARA MOVIMENTOS RELACIONADOS
////////////
DbSelectArea("SE2")
DbSetOrder(1)
For nI := 1 To Len(aIMPOST)
	If aIMPOST[nI,2] > 0 .And. DbSeek(aIMPOST[nI,1])							//CASO LOCALIZE O MOVIMENTO RELACIONADO...
		RecLock("SE2",.F.)
		SE2->E2_XLIBNIV := cLIBNIV
	  	SE2->E2_XCONF01 := ""
	    SE2->E2_XCONF02 := ""                                                     
	    SE2->E2_XCONF03 := ""
	    SE2->E2_USUALIB := ""
	    SE2->E2_DATALIB := Ctod('  /  /  ')
	 		 	
	 	SE2->(MsUnLock())
	EndIf
Next

////////////
//RETORNA AREA ORIGINAL
////////////
RestArea(aAREAE2)
RestArea(aAREATU)

Return()


#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  F390GRV º Autor ³ Andy               º Data ³  17/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±       	
±±ºDescricao ³ Ponto de Entrada executado para devolver Status do Titulo  º±±
±±º          ³ Contas a Pagar, quando tem o cheque cancelado,  voltar a   º±±
±±º          ³ ser aberto e ter o processo executado no CFINR001 revertidoº±±
±±º          ³ Pto de Entrada Executado pela funcao FA390VER residente em º±±
±±º          ³ FIXFUN.PRX  e chamado pelo FINA390                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F390GRV()

Local _aAreaSE2, _aAreaSE5
Private _cNumAp
Private _dDtVcrea
_aAreaSE2 := SE2->(GetArea())
_aAreaSE5 := SE5->(GetArea())

SE2->(dbSetOrder(1))
If	SE2->(dbSeek(xFilial("SE2")+SEF->EF_PREFIXO	+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA, .F.))
    _cNumAp   := SE2->E2_NUMAP
    _dDtVcrea := SE2->E2_VENCREA
	RecLock( "SE2",.F.)
	SE2->E2_SALDO := SE2->E2_VALOR
	SE2->E2_BAIXA := CTOD("  /  /  ")
	SE2->E2_NUMAP := Space(06)
	SE2->E2_IMPCHEQ	:= " "
	SE2->E2_NUMBCO 	:= Space(15)
	MsUnlock()
EndIf

//_cChave   := "CH"+SPACE(13)+DTOS(SE2->E2_EMISSAO)+SE2->E2_FORNECE

_cChave     := SEF->EF_NUM
_dDataCh    := DTOS(SEF->EF_DATA)
_cBancoCh   := SEF->EF_BANCO
_cAgencCh   := SEF->EF_AGENCIA
_cConta     := SEF->EF_CONTA 
_cNumCH     := ALLTRIM(SEF->EF_NUM)


SE5->(dbSetOrder(1))  //  Alterado por CFB  02/08/04   

IF SE5->(DbSeek(xFILIAL("SE5")+DTOS(SEF->EF_DATA)+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_NUM))
        While xFILIAL("SE5")== SE5->E5_FILIAL .and. ;
               _dDataCh      == DTOS(SE5->E5_DATA) .and.; 
               _cBancoCh     == SE5->E5_BANCO      .and.;
               _cAgencCh   == SE5->E5_AGENCIA    .and.;
               _cConta     == SE5->E5_CONTA      .and.;
               _cNumCH     == ALLTRIM(SE5->E5_NUMCHEQ)
               
               IF SE5->E5_RECPAG == "R"
               Reclock("SE5",.F.)
			   SE5->(DbDelete())
			   SE5->(MsUnlock())      
			   ELSE
			   Reclock("SE5",.F.)
			   SE5->E5_DOCUMEN := _cNumAp
			   SE5->E5_VENCTO   := _dDtVcrea
			   SE5->E5_SITUACA := "C"

			   SE5->(MsUnlock())      
               ENDIF
               SE5->(DBSKIP())
       
        END

Endif


/*
WHILE xFILIAL("SEF") == SEF->EF_FILIAL .AND._cNumCH == SEF->EF_NUM

   RecLock("SEF",.f.)
   dbDelete()
   sef->(MsUnlock())
   SEF->(DbSeek(xFilial("SEF")+_cNumCH))
END
*/

SE2->(RestArea(_aAreaSE2))
SE5->(RestArea(_aAreaSE5))

Return


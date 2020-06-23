#Include 'Protheus.ch'

// Ponto de entrada na Alteração do Titulo a Pagar
// Validação do processo de CRONOLOGIA
User Function FA050ALT()

Local lRet:=.T.
Local cOrdemCro := M->E2_XORDLIB //ORDEM CRONOLOGICA
Local cMotBloqu := M->E2_XMOTBLQ //1-CADIN; 2-SALDO
Local dDataBloq := M->E2_XDTCADI //DT BLOQUEIO CADIN
Local dDataDesb := M->E2_XDT1CAD //DT DESBLOQUEIO CADIN

IF !EMPTY(dDataBloq) .or. !EMPTY(dDataDesb)

	If dDataBloq > M->E2_VENCREA //DATA DE BLOQUEIO NÃO PODE SER MAIOR QUE VENCIMENTO REAL
		MSGINFO('ATENÇÃO: Data de Bloqueio não poderá ser superior ao vencimento real do título')
		lRet := .F.
		Return
	EndIf
	
	If dDataBloq > dDataDesb .and. !EMPTY(dDataDesb)  //DATA DE BLOQUEIO NÃO PODE SER MAIOR QUE O DESBLOQUEIO
		MSGINFO('ATENÇÃO: Data de Bloqueio não poderá ser superior ao desbloqueio')
		lRet := .F.
		Return
	EndIf
	
	If lRet 
		If !Empty(dDataBloq) .and. Empty(dDataDesb)
			If cMotBloqu = "1" //MOTIVO CADIN
				IF MsgYesNo("Atenção, essa ação fará o bloqueio do título na ordem cronológica por motivo CADIN e deverá ser liberado novamente para pgto. Deseja continuar? ","Bloqueio ordem cronologica")
					RECLOCK("SE2",.F.)
					M->E2_XORDLIB := "BLC"
					M->E2_DATALIB := CTOD("")
					MSUNLOCK() 
				EndIf
			ElseIf cMotBloqu = "2" //BLOQUEIO SALDO
				IF MsgYesNo("Atenção, essa ação fará o bloqueio do título na ordem cronológica por motivo SALDO. Deseja continuar? ","Bloqueio ordem cronologica")
					RECLOCK("SE2",.F.)
					M->E2_XORDLIB := "BLS"
					MSUNLOCK() 	
				EndIf
			EndIf
		Else
			If Empty(SE2->E2_DATALIB) //CASO ESTEJA LIBERADO PARA PAGAMENTO PORÉM MOTIVO DE BLOQ. POR CADIN
				RECLOCK("SE2",.F.)
				M->E2_XORDLIB := "LIS"	
				MSUNLOCK()	
			Else
				RECLOCK("SE2",.F.)
				M->E2_XORDLIB := "LIC"	
				MSUNLOCK()	
			EndIf
		Endif 
		
	EndIf

Else
	MsgInfo("Nenhum dado foi alterado, favor retorne e efetue ação de Bloqueio ou Desbloqueio")
	Return
EndIf


Return(lRet)


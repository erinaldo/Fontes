#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA09()

Exclusão: 	Se aprovado, aviso que a aprovação foi concluída e 
			solicitação de confirmação
Alteração:	Não será permitido alteração título que:
			I = a primeira aprovação já foi efetuada
			A = título aprovado
			R = título reprovado

Chamado pelo PE FA050UPD

@param		Nenhum
@return		lRet	=	.T./.F. - Se retornar .F. o t¡tulo não será exclu¡do.
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA09()
	LOCAL lRet		:= .T.
	LOCAL cFINALTI	:= "N"
	LOCAL cSFLUIG	:= ""

	IF ALTERA
		//-----------------------------------------------------------------------
		// Não será permitido efetuar alteração neste título, já que:
		// I = a primeira aprovação já foi efetuada (AS_FINALTI == "N")
		// A = título aprovado
		// R = título reprovado
		//-----------------------------------------------------------------------
		cFINALTI := SUPERGETMV("AS_FINALTI", .T., "N") 
		
		IF cFINALTI == "S" // Título com aprovação iniciada poderá ter dados alterados
			cSFLUIG := "X"		// permite alterar título em qualquer status no Fluig		
		ELSE
			cSFLUIG := "I|A|R"	// título com aprovação iniciada, aprovado ou reprovado reprovado
		ENDIF
		
		IF SE2->E2_XSFLUIG $ cSFLUIG // título com aprovação iniciada, aprovado ou reprovado reprovado
			lRet := .F.
			Help('',1,'Inconsistência - ' + PROCNAME(),,'Este título não pode ser alterado pois '+  IIF(SE2->E2_XSFLUIG $ 'I|A','já teve aprovação iniciada','foi reprovado') + ' no Fluig',4,1)
		ENDIF
		
	ELSEIF !INCLUI
		//-----------------------------------------------------------------------
		// Aviso que a aprovação foi concluída e solicitação de confirmação
		//-----------------------------------------------------------------------	
		IF SE2->E2_XSFLUIG == 'A'
			IF !IsBlind() // a conexão efetuada com o Protheus não possui interface com o usuário
				IF !MsgNoYes("Este título já está aprovado. Deseja realmente excluí-lo?","Confirme")
					lRet := .F.
				ENDIF
			ENDIF
		ENDIF
		
	ENDIF
	
RETURN lRet
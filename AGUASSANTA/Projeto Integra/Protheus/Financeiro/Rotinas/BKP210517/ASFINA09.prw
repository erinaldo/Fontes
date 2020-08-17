#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA09()

Exclus�o: 	Se aprovado, aviso que a aprova��o foi conclu�da e 
			solicita��o de confirma��o
Altera��o:	N�o ser� permitido altera��o t�tulo que:
			I = a primeira aprova��o j� foi efetuada
			A = t�tulo aprovado
			R = t�tulo reprovado

Chamado pelo PE FA050UPD

@param		Nenhum
@return		lRet	=	.T./.F. - Se retornar .F. o t�tulo n�o ser� exclu�do.
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
		// N�o ser� permitido efetuar altera��o neste t�tulo, j� que:
		// I = a primeira aprova��o j� foi efetuada (AS_FINALTI == "N")
		// A = t�tulo aprovado
		// R = t�tulo reprovado
		//-----------------------------------------------------------------------
		cFINALTI := SUPERGETMV("AS_FINALTI", .T., "N") 
		
		IF cFINALTI == "S" // T�tulo com aprova��o iniciada poder� ter dados alterados
			cSFLUIG := "X"		// permite alterar t�tulo em qualquer status no Fluig		
		ELSE
			cSFLUIG := "I|A|R"	// t�tulo com aprova��o iniciada, aprovado ou reprovado reprovado
		ENDIF
		
		IF SE2->E2_XSFLUIG $ cSFLUIG // t�tulo com aprova��o iniciada, aprovado ou reprovado reprovado
			lRet := .F.
			Help('',1,'Inconsist�ncia - ' + PROCNAME(),,'Este t�tulo n�o pode ser alterado pois '+  IIF(SE2->E2_XSFLUIG $ 'I|A','j� teve aprova��o iniciada','foi reprovado') + ' no Fluig',4,1)
		ENDIF
		
	ELSEIF !INCLUI
		//-----------------------------------------------------------------------
		// Aviso que a aprova��o foi conclu�da e solicita��o de confirma��o
		//-----------------------------------------------------------------------	
		IF SE2->E2_XSFLUIG == 'A'
			IF !IsBlind() // a conex�o efetuada com o Protheus n�o possui interface com o usu�rio
				IF !MsgNoYes("Este t�tulo j� est� aprovado. Deseja realmente exclu�-lo?","Confirme")
					lRet := .F.
				ENDIF
			ENDIF
		ENDIF
		
	ENDIF
	
RETURN lRet
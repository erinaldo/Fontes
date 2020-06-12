#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} xGetAces
//TODO Rotina para Validar e retornar acssos ao Protheus
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return aRet, Array:
					[01] - Usuário Ativo e Permissões de horarios
					[02] - ID do Usuário
					[03] - Código do Usuário
					[04] - Nome do Usuário
					[05] - E-mail do Usuário
					[06] - Quantidade de dias permitida para retroceder a bada base
					[07,01] -  Acesso a opção pesquisar (.T. OU .F.)
					[07,02] -  Acesso a opção consultar (.T. OU .F.)
					[07,03] -  Acesso a opção incluir (.T. OU .F.)
					[07,04] -  Acesso a opção alterar (.T. OU .F.)
					[07,05] -  Acesso a opção excluir (.T. OU .F.)
@param cCodEmp, characters, Código da Empresa
@param cCodFil, characters, Código da Filial
@param cCodMod, characters, Módulo do Protheus
@param cNomeUsr, characters, Usuário
@param cRotina, characters, Nome da Rotina
/*/
User Function xGetAces(cCodEmp, cCodFil, nCodMod, cNomeUsr, cRotina, oEventLog)

	Local aRet		:= {}
	Local aUsers	:= AllUsers(.F.,.T.) 
	Local nX		:= 0
	Local aAcessos	:= Nil
	
	For nX := 1 to Len(aUsers)
	
		If Lower(cNomeUsr) == Lower(aUsers[nX,01,02])
		
			

				aAcessos := ValAce(aUsers[nX,01,01], nCodMod, cRotina, oEventLog)
				
				If Len(aAcessos) > 1
	
					aAdd(aRet,ValUsr(aUsers[nX]))	//[01] - Usuário Ativo e Permissões de horarios
					aAdd(aRet,aUsers[nX,01,02])		//[02] - ID do Usuário
					aAdd(aRet,aUsers[nX,01,01])		//[03] - Código do Usuário
					aAdd(aRet,aUsers[nX,01,04])		//[04] - Nome do Usuário
					aAdd(aRet,aUsers[nX,01,14])		//[05] - E-mail do Usuário
					aAdd(aRet,aUsers[nX,01,23,02])	//[06] - Quantidade de dias permitida para retroceder a bada base
					aAdd(aRet,aAcessos)				//[07] - Acesso a rotina solicitada
	
				Else
					aAdd(aRet,aAcessos[01])
				EndIf

			Exit
		
		EndIf
		
	Next nx
	
	//Não encontrou o usuario recebido no Protheus
	If Len(aRet) == 0
		aAdd(aRet,"Usuario invalido. [" + cNomeUsr + "]")
	EndIf
	
Return aRet

/*/{Protheus.doc} ValUsr
//TODO Função para validar Usuário
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return $lRet, lógico, .T. OU .F.
@param aUser, array, Dados do usuário
/*/
Static Function ValUsr(aUser)

	Local lRet := .T.
	Local cHoras := aUser[02,01,Dow(Date())]

	If aUser[01,17] //Usuário Bloqueado
		lRet := .F.
	ElseIf !(Time() >= SubStr(cHoras,1,5) .And. Time() <= SubStr(cHoras,7,5)) //Dias da semana e horarios de acessos
		lRet := .F.
	EndIf

Return lRet

/*/{Protheus.doc} ValAce
//TODO Função para validar acessos
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return aRet, array, contem os acessos da rotina ou uma mensagem de erro
@param cCodUsr, characters, Código do uauário
@param cRotina, characters, Nome da Rotina
/*/
Static Function ValAce(cCodUsr, nCodMod, cRotina,oEventLog)

	Local aMnuAce	:= {}
	Local aRet		:= {}
	
	Local nPosRot	:= 0
	Local nPosPes	:= 0
	Local nPosVis	:= 0
	Local nPosInc	:= 0
	Local nPosAlt	:= 0
	Local nPosExc	:= 0

	Local aMenu		:= FWGetMnuAccess(cCodUsr,nCodMod)
	Local aMnuRot	:= {}
	Local nx		:= 0
	Local nY		:= 0
	
//	VarInfo("aMenu",aMenu)

	If Len(aMenu[04]) > 0

		oEventLog:setInfo("--> Consultando usuários...", "")
		
		If ValType(aMenu[04,01,02,01,02]) == "A"	
		
			//Seleciona somente o array com as informaçõe de acesso da rotina e do menu
			aMnuRot	:= aMenu[04,01,02,01,02]	
	
			//Verifica a rotina 

			For nX := 1 to Len(aMnuRot)
				If ValType(aMnuRot[nX][2]) == "A"
					nPosRot := aScan(aMnuRot[nX][2],{ |X| Upper(Alltrim(X[2])) == Upper(cRotina)})
					If nPosRot > 0
						aMnuAce := aMnuRot[nX,02,nPosRot,04]
						Exit
					EndIf
				Else
					If Upper(aMnuRot[nX][2]) == Upper(cRotina)
						aMnuAce := aMnuRot[nX,04]
						Exit
					Else
						nPosRot := 0
					EndIf
				EndIf
			Next
			
			If !Empty(aMnuAce)//nPosRot != 0
			
				//Verifica o menu
				//aMnuAce := aMnuRot[nPosRot,04]	//aMenu[04,01,02,01,02,01,04]
				
				nPosPes := aScan(aMnuAce,{ |X| Upper(Alltrim(X[1])) == "PESQUISAR"})
				nPosVis := aScan(aMnuAce,{ |X| Upper(Alltrim(X[1])) == "VISUALIZAR"})
				nPosInc := aScan(aMnuAce,{ |X| Upper(Alltrim(X[1])) == "INCLUIR"})
				nPosAlt := aScan(aMnuAce,{ |X| Upper(Alltrim(X[1])) == "ALTERAR"})
				nPosExc := aScan(aMnuAce,{ |X| Upper(Alltrim(X[1])) == "EXCLUIR"})
				
				If nPosAlt == 0
					nPosAlt := aScan(aMnuAce,{ |X| Upper(Alltrim(X[1])) == "CLASSIFICAR"})
				EndIF
				
				//Monta array de acessos 
				//Caso não encontre a opção, preenche com .F.
				aRet := 	{;
								If (nPosPes != 0,aMnuAce[nPosPes,3],.F.),;
								If (nPosPes != 0,aMnuAce[nPosVis,3],.F.),;
								If (nPosPes != 0,aMnuAce[nPosInc,3],.F.),;
								If (nPosPes != 0,aMnuAce[nPosAlt,3],.F.),;
								If (nPosPes != 0,aMnuAce[nPosExc,3],.F.);
							}
							
			Else
				aAdd(aRet,"Rotina nao esta disponivel para este usuario. [" + cRotina + "]")
			EndIf
	
		Else
			aAdd(aRet,"Estrutura do menu Invalida.")
		EndIf			

	Else
		aAdd(aRet,"Modulo nao cadastrado para o usuario. Usuario [" + UsrRetName(cCodUsr) + "] - Modulo [" + cValToChar(nCodMod) + "]")
	EndIf
	
Return aRet


//RetModName()
//GetAccessList()
//FWSFAllRules()
//FWSFLdRelRule("000068")
//FWSFLdPsqRule()
//FWSFALLUSERS({"000068"})
//FWGetMnuAccess (cUserId, nModulo )
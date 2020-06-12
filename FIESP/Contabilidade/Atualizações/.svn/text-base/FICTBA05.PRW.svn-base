#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "colors.ch"                                                                                                        
                              
#DEFINE _EOL chr(13) + chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA05  บAutor  ณMicrosiga           บ Data ณ  02/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Usuario X Centro de Custos                     บฑฑ
ฑฑบ          ณ Rotina de Projeto                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑ Revisao: NOV/2013 - Lํgia Sarnauskas - Revisado filtro que estava dando ฑฑ
ฑฑ erro e alterada a consulta padrใo que chama o filtro                    ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICTBA05

//Declaracao de variaveis.
Private _cString := "SZF"
Private aRotina
Private cCadastro
Private aLegenda
Private _cUser
Public _cAprov
Public _cNome
Private aNaoSZF

&(_cString)->(dbSetOrder(1))

//Monta um aRotina proprio.
aRotina := {	{"Pesquisar"	, "AxPesqui"	,  0, 1},;
				{"Visualizar"	, "u_FICTBA51"	,  0, 2},;
				{"Incluir"		, "u_FICTBA51"	,  0, 3},;
				{"Alterar"		, "u_FICTBA51"	,  0, 4},;
				{"Excluir"		, "u_FICTBA51"	,  0, 5}}


//Exibe a tela de cadastro.
cCadastro := "Usuario X Centro de Custos"

mBrowse(06, 01, 22, 75, _cString,,,,,,aLegenda)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA05  บAutor  ณMicrosiga           บ Data ณ  06/18/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FICTBA51(cAlias,nReg,nOpc)
Local lRet
Local nOpca := 0
Local oDlg
Local cTitulo		:= "Usuario X Centro de Custos"
Local cAlias		:= _cString         // Alias da enchoice.
Local cFieldOk		:= "AllwaysTrue()"  // Valida cada campo da GetDados.
Local cLinOk		:= "AllwaysTrue()"  // Valida a linha.
Local cTudoOk		:= "AllwaysTrue()"  // Valida toda a GetDados.
Local nLinhas
Local nLinhas		:= Iif(nLinhas  ==Nil,99 ,nLinhas ) // Numero maximo de linhas na GetDados.
Local nFreeze		:= nil

Private aHeader 	:= {}
Private aCols 	:= {}

//Botoes dentro da Tela de Inclusao (Acoes Relacionadas
aButtons	:= {}


// Montagem da grade da distribuicao
aNaoSZF  := {"ZF_USERID","ZF_NOME","ZF_CPRINCI"}
IF nOpc == 3
	_cUser := Space(TamSx3("ZF_USERID")[1])
	_cNome := Space(TamSx3("ZF_NOME")[1])
	_cAprov:= Space(TamSx3("ZF_APROV")[1])
	_cNomAp:= Space(TamSx3("ZF_NOMAPRO")[1])  
	_cCCPri:= Space(TamSx3("ZF_CPRINCI")[1])  
	
	cSeek := ""//SZF->(ZF_FILIAL+ZF_USERID+ZF_CUSTO)
	cWhile := ""//"SZF->(ZF_FILIAL+ZF_USERID+ZF_CUSTO)"
ELSE
	_cUser := SZF->ZF_USERID
	_cNome := SZF->ZF_NOME
   	_cAprov:= SZF->ZF_APROV
	_cNomAp:= SZF->ZF_NOMAPRO
	_cCCPri:= SZF->ZF_CPRINCI

	cSeek := SZF->(ZF_FILIAL+ZF_USERID)
	cWhile := "SZF->(ZF_FILIAL+ZF_USERID)"
ENDIF

FillGetDados(nOpc,cAlias,1,cSeek,{|| &cWhile },{|| .T. },aNaoSZF,/*aSimCpo*/,,,,,aHeader,aCols)
If Empty(GdFieldGet("ZF_ITEM",1,,aHeader,aCols))
	GDFieldPut("ZF_ITEM",StrZero(1,TamSX3("ZG_ITEM")[1]),1,aHeader,aCols) //Acrescenta sequencial no aCols
EndIf

aSizeAut := MsAdvSize()

DEFINE FONT oBold NAME "Arial" SIZE 0, -11 BOLD
oDlg := MSDIALOG():New(aSizeAut[7],000, aSizeAut[6],aSizeAut[5], cTitulo,,,,,,,,,.T.)

oPanel  := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,50,50,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_TOP

oPanel1 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,220,220,.T.,.T. )
oPanel1:Align := CONTROL_ALIGN_TOP

//Cria variaveis M->????? da Enchoice.
RegToMemory(cAlias, If(nOpc==3,.T.,.F.))

@ 05, 003 TO 045,600 LABEL "" OF oPanel PIXEL
@ 15, 015 SAY "Usuario" 	SIZE 045, 07 OF oPanel FONT oBold PIXEL //Color CLR_RED
@ 15, 040 SAY "*" 			SIZE 045, 07 OF oPanel FONT oBold Color CLR_HRED PIXEL
@ 25, 015 MSGET _cUser		SIZE 068, 09 Picture "@!" F3 "US2" Valid(FIVALUSER(aHeader,aCols,nOpc)) When iif(nOpc == 3,.T.,.F.)	OF oPanel PIXEL


@ 15, 100 SAY "Nome"		SIZE 045, 07 OF oPanel PIXEL
@ 25, 100 MSGET _cNome		SIZE 180, 09 When .F. OF oPanel PIXEL

@ 15, 300 SAY "CC Principal." 	SIZE 045, 07 OF oPanel FONT oBold PIXEL //Color CLR_RED
@ 15, 340 SAY "*" 			SIZE 045, 07 OF oPanel FONT oBold Color CLR_HRED PIXEL
@ 25, 300 MSGET _cCCPri		SIZE 068, 09 Picture "@!" F3 "CTT" Valid(FIVALAPR(aHeader,aCols,nOpc)) When iif(nOpc == 3,.T.,.F.)	OF oPanel PIXEL

/*@ 15, 385 SAY "Nome Aprov."		SIZE 045, 07 OF oPanel PIXEL
@ 25, 385 MSGET _cNomAp		SIZE 180, 09 When .F. OF oPanel PIXEL*/

aCampos1	:= {"ZF_CUSTO","ZF_DESC01","ZF_APROV","ZF_NOMAPRO"}

If nOpc == 3 .or. nOpc == 4
	nGetd1		:= GD_INSERT+GD_UPDATE+GD_DELETE
Else
	nGetd1		:= 0
EndIf
//                                                                  coluna            linha
oGetDados1	:= MsNewGetDados():New(1,1,1,1,nGetd1,"U_FICTBA52",cTudoOk,"+ZF_ITEM",aCampos1,nFreeze,nLinhas,cFieldOk,/*superdel*/,"U_FICTBA53",oPanel1,aheader,acols)
oGetDados1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetDados1:oBrowse:Default()
oGetDados1:oBrowse:Refresh()

oDlg:bInit	:= {|| EnchoiceBar(oDlg,{||iif(FICTBTOK(aHeader,aCols,nOpc),(nOpca:=1,oDlg:End()),nOpca:=0 )},{||nOpca:=0,oDlg:End()},,aButtons)}
oDlg:lCentered := .T.
oDlg:Activate()

lRet:=(nOpca==1)

If lRet
	FICTBGRV(aHeader,aCols,nOpc)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBF02  บAutor  ณMicrosiga           บ Data ณ  07/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FICTBGRV(aHeader,aCols,nOpc)

Local bCampo := {|nCPO| Field(nCPO) }

// Backup do TTS
lSavTTsInUse := __TTSInUse

// Ativa TTS
__TTSInUse := .T.

Begin Transaction

If !nOpc == 5 //Diferente de Exclusao
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava os itens -                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	For nX := 1 To Len(oGetDados1:aCols)
		
		_lDelete := IIF(GDDeleted(nX,aHeader,oGetDados1:aCols),.t.,.f.)
		SZF->(dbSetOrder(1))
		IF !SZF->(MsSeek(xFilial("SZF")+_CUSER+oGetDados1:aCols[nX,2]))
			IF _lDelete
				Loop
			ENDIF  
			//valida para saber se existe o registro na tabela
			RecLock("SZF",.T.)
			SZF->ZF_FILIAL 	:= xFilial("SZF")
			SZF->ZF_USERID 	:= _cUser
			SZF->ZF_NOME 	:= _cNome		 
			SZF->ZF_APROV   := _cAprov
		   	SZF->ZF_NOMAPRO := _cNomAp
		   	SZF->ZF_CPRINCI := _cCCPri
		ELSE
			If nOpc <> 3 .and. SZF->(dbSeek(xFilial("SZF")+(_cUser+oGetDados1:aCols[nX,2])))
				RecLock("SZF",.F.)
				IF _lDelete
					SZF->(dbDelete())
					SZF->(msUnlock())
					Loop
				ENDIF
			EndIf
		ENDIF
		
		For nY := 1 to Len(aHeader)
			If aHeader[nY][10] <> "V"
				SZF->(FieldPut(FieldPos(aHeader[nY][2]),oGetDados1:aCols[nX][nY]))
			EndIf
		Next nY
		
		SZF->(MsUnLock())
	Next nX
	
Else
	
	// Exclui linhas
	SZF->(dbSetOrder(1))
	SZF->(MsSeek(xFilial("SZF")+M->(ZF_USERID+ZF_CUSTO)))
	While SZF->(!Eof()) .and. SZF->(ZF_FILIAL+ZF_USERID) == XFilial("SZF")+(_cUser)
		Eval({|| RecLock("SZF",.f.), SZF->(dbDelete()), SZF->(MsUnLock()) })
		SZF->(dbSkip())
	EndDo
	
Endif

End Transaction

// Restaura TTS
__TTSInUse := lSavTTsInUse

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBBA05  บAutor  ณMicrosiga           บ Data ณ  07/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FIVALUSER(cAlias,nReg,nOpc)

lRet := .T.
If nOpc == 3 //Inclui
	lRet := ExistChav("SZF",_cUser)
	_cNome:= UsrRetName(_cUser)
EndIf

Return(lRet)                                                                 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIVALAPR  บAutor  ณMicrosiga           บ Data ณ  NOV/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FIVALAPR(cAlias,nReg,nOpc)

lRet := .T.
If nOpc == 3 //Inclui
	lRet := ExistChav("SZF",_cAprov)
	_cNomAp:= UsrRetName(_cAprov)
EndIf

Return(lRet)                                                                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICTBTOK(aHeader,aCols,nOpc)

Local lRet := .T.
Local _nPosITEM := GDFieldPos("ZF_CUSTO")
Local _cITEM    := GDFieldGet("ZF_CUSTO",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)

//Validacao na Inclusao para nao permitir que o Usuario grave em Branco
If !nOpc == 5 //Diferente de Exclusao
	If Empty(_cUser)
		lRet := .F.
		msgbox("Preencher o Usuแrio!!!", "Alert")
		Return(lRet) 
	EndIf
	//Registro Nao Excluido
	If !(oGetDados1:aCols[oGetDados1:oBrowse:nAt,len(oGetDados1:aHeader)+1])
	
		//Validacao para nao permitir linha no aCols em Branco
		For _nY := 1 to Len(oGetDados1:aCols)
			If Empty(oGetDados1:aCols[_nY,_nPosITEM])
				lRet := .F.
				Exit
			EndIf
		Next
		If !(lRet)
			msgbox("Centro de Custos em Branco!!!", "Alert")
			Return(lRet) 
		EndIf
	
		//Validacao para nao gravar Duplicidade de registros no aCols
		For _nI := 1 to Len(oGetDados1:aCols)
			If _nI <> oGetDados1:oBrowse:nAt
				If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1])
					If (oGetDados1:aCols[_nI,_nPosITEM] == _cITEM)
						_cMens := "Centro de Custos ja cadastrado>>"   +Chr(9)+Chr(9)+_cITEM + Chr(13)+Chr(10)
						Aviso("Duplicidade Item: "+_cITEM,_cMens,{"Voltar"})
						lRet := .F.
						Return(lRet)
					EndIf
				EndIf
			EndIf
		Next _nI
	EndIf
EndIf

Return(lRet) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICTBA52()

Local lRet := .T.
Local _nPosITEM := GDFieldPos("ZF_CUSTO")
Local _cITEM    := GDFieldGet("ZF_CUSTO",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)

For _nI := 1 to Len(oGetDados1:aCols)
	If _nI <> oGetDados1:oBrowse:nAt
		If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1]) .and. (oGetDados1:aCols[_nI,_nPosITEM] == _cITEM)
			_cMens := "Centro de Custos ja cadastrado>>"   +Chr(9)+Chr(9)+_cITEM + Chr(13)+Chr(10)
			Aviso("Duplicidade Item: "+_cITEM,_cMens,{"Voltar"})
			lRet := .F.
			Return(lRet)
		EndIf
	EndIf
Next _nI
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA02  บAutor  ณMicrosiga           บ Data ณ  07/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICTBA53()

Local lRet := .T.

Local _nPosITEM := GDFieldPos("ZF_CUSTO")
Local _cITEM    := GDFieldGet("ZF_CUSTO",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)

If !(oGetDados1:aCols[oGetDados1:oBrowse:nAt,len(oGetDados1:aHeader)+1])
//	alert("Deletado")
	lRet := .T.
Else
//	alert("NAO Deletado")
	lRet := .T.
	For _nI := 1 to Len(oGetDados1:aCols)
		If _nI <> oGetDados1:oBrowse:nAt
			If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1]) .and. (oGetDados1:aCols[_nI,_nPosITEM] == _cITEM)
				_cMens := "Centro de Custos ja cadastrado>>"   +Chr(9)+Chr(9)+_cITEM + Chr(13)+Chr(10)
				Aviso("Duplicidade Item: "+_cITEM,_cMens,{"Voltar"})
				lRet := .F.
				Return(lRet)
			EndIf
		EndIf
	Next _nI
EndIf	
Return(lRet)

#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINA01  บAutor  ณMicrosiga           บ Data ณ  06/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Requisicao de Numerario                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINA01()
//Declaracao de variaveis.
Private _cString := "SZL"
Private _bFiltraBrw, _aIndex := {}, _cFiltro
Private aRotina
Private cCadastro
Private _cUserLib	:= GetMv("FI_XLIBERN",,.F.) //Parametro que define o codigo de usuario que pode Liberar o Numerario (entrega do dinheiro)

&(_cString)->(dbSetOrder(1))

//Monta um aRotina proprio.
aRotina := {	{"Pesquisar"		, 'AxPesqui'  ,  0, 1},;
				{"Visualizar"		, 'AxVisual'  ,  0, 2},;
				{"Incluir"      	, 'U_FIFINA14',  0, 3},;
				{"Alterar"			, 'U_FIFINA15',  0, 4},;
				{"Excluir"			, 'u_FIFINA10',  0, 5},;
				{"Enviar p/Aprov"	, 'U_FIFINA11',  0, 4},;
				{"Liber.Numerario"	, 'U_FIFINA13',  0, 4},;
				{"Imprime Recibo"	, 'U_FIFINA12',  0, 4},;
				{"Legenda"			, 'U_FIFINL10',  0, 6}}

//Exibe a tela de cadastro.
cCadastro := "Requisicao de Numerario"

aLegenda	:= {{'ZL_STATUS=="1"'	, 'BR_VERDE'	},; //"Em Aberto"
				{'ZL_STATUS=="2"'	, 'BR_AMARELO'	},; //"Enviado para Aprova็ใo"
				{'ZL_STATUS=="3"'	, 'BR_AZUL'		},; //"Requisi็ใo Aprovada"
				{'ZL_STATUS=="4"'	, 'BR_PRETO'	},; //"Requisi็ใo Reprovada"
				{'ZL_STATUS=="5"'	, 'BR_VERMELHO'	},; //"Processo Encerrado"
				{'ZL_STATUS=="6"'	, 'BR_CANCEL'	}}  //"Cancelada"

// Efetua o filtro por usuario Solicitante
If alltrim(__CUSERID) $ alltrim(_cUserLib) //Se o usuario Logado for um Aprovador ele visualiza as suas requisicoes e as Requisi็oes Aprovadas dos outros Usuarios
	_cFiltro := "ZL_USER = '"+__CUSERID+"' .or. (ZL_STATUS=='3' .or. ZL_STATUS=='5')"
Else
	_cFiltro := "ZL_USER = '"+__CUSERID+"'"
EndIf

_bFiltraBrw := {|| FilBrowse(_cString, @_aIndex, @_cFiltro)}
Eval(_bFiltraBrw)

mBrowse(06, 01, 22, 75, _cString,,,,,,aLegenda,,,,,,,,,,,,,)

// Limpa o filtro.
EndFilBrw(_cString, _aIndex)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINA01  บAutor  ณMicrosiga           บ Data ณ  09/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FIFINA14

AxInclui("SZL", , , , , ,"U_FIFINA16(3)")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINA01  บAutor  ณMicrosiga           บ Data ณ  09/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alteracao                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FIFINA15()

IF SZL->ZL_STATUS == "1" // Em Aberto    
	AxAltera('SZL',SZL->(Recno()),4,,,,,"U_FIFINA16(4)")
ELSE
	Aviso(cCadastro, "Somente solicita็๕es em aberto podem ser alteradas!", {"Sair"} )
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINA01  บAutor  ณMicrosiga           บ Data ณ  09/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINA16(_nOpc)

Local _lRet     := .T.
Local _cAreaCTT := CTT->(GetArea())

IF _nOpc == 3 .or. _nOpc == 4 // Inclusao ou Alteracao
	CTT->(dbSetOrder(1))
	IF CTT->(dbSeek(XFilial("CTT")+M->ZL_CC))
		IF Empty(CTT->CTT_XAPROV)
			Aviso(cCadastro, "O centro de custo informado nใo possui Grupo de Aprova็ใo!", {"Sair"} )
			_lRet := .F.
		ENDIF
	ENDIF
ENDIF

If _nOpc == 3
	If Empty(M->ZL_NATUREZ)
		Aviso(cCadastro, "O campo Natureza ้ obrigatorio o preenchimento!", {"Sair"} )
		_lRet := .F.
	EndIf
EndIf

RestArea(_cAreaCTT)
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINA01  บAutor  ณMicrosiga           บ Data ณ  08/28/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Enviado para Aprova็ใo                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINA11()
Local _cAreaCTT := CTT->(GetArea())

SCR->(dbSetOrder(1))

CTT->(dbSetOrder(1))
CTT->(dbSeek(XFilial("CTT")+SZL->ZL_CC))

IF !Empty(CTT->CTT_XAPROV) .AND. SZL->ZL_STATUS == "1" //Em Aberto

	RecLock("SZL",.F.)
	SZL->ZL_STATUS := "2" //"Enviado para Aprova็ใo"
	MsUnLock()

	// Gravar Alcada SCR
	IF !SCR->(dbSeek(xFilial("SCR")+"RN"+SZL->ZL_NUM))
		MaAlcDoc({SZL->ZL_NUM,"RN",SZL->ZL_VALOR,,,CTT->CTT_XAPROV,,1,1,dDataBase},,1)
	Endif
ELSE
	Aviso(cCadastro, "Somente solicita็๕es em aberto podem ser Enviadas para Aprovacao!", {"Sair"} )
ENDIF
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINA01  บAutor  ณMicrosiga           บ Data ณ  08/28/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Requisi็ใo Aprovada/Reprovada                              บฑฑ
ฑฑบ          ณ Liber.Documento                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINA12()

IF SZL->ZL_STATUS <> "5" // Encerrado    
	Aviso(cCadastro, "Somente Requisicoes Encerradas podem ter Recibo Impresso!", {"Sair"} )
	Return
ENDIF

If !(alltrim(__CUSERID) $ alltrim(_cUserLib))
	MsgBox("Usuario nao autorizado a Emitir Recibo!!","Aten็ใo")
	Return
EndIf

If SZL->ZL_IMPRESS == "S"
	If ApMsgYesNo("Recibo ja Impresso! Deseja Re-Imprimir?", "Confirmar" )
		U_FIFINR04()
	EndIf
Else
	If ApMsgYesNo("Confirma impressao do Recibo Requisi็ใo?","Confirmar")
		U_FIFINR04()
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINA01  บAutor  ณMicrosiga           บ Data ณ  08/28/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Liber.Numerario                                            บฑฑ
ฑฑบ          ณ Processo Encerrado                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINA13()

Local lMsErroAuto 	:= .F.
Local xTipoForn		:= Posicione("SA2",1,xFilial("SA2")+SZL->(ZL_FORNECE+ZL_LOJA),"A2_XTIPO")
Local lGerou		:= .F.
Local _cBanco		:= Space(TamSx3("A6_COD")[1])
Local _cAgencia 	:= Space(TamSx3("A6_AGENCIA")[1])
Local _cConta 		:=Space(TamSx3("A6_NUMCON")[1])

If !(alltrim(__CUSERID) $ alltrim(_cUserLib))
	MsgBox("Usuario nao autorizado a efetuar a Liberacao de Numerario!!","Aten็ใo")
	Return
EndIf

If SZL->ZL_STATUS<>"3" //Aprovada
	MsgBox("Para efetuar a Libera็ใo do Numerแrio a solicita็ใo deve estar APROVADA!!","Aten็ใo")
	Return
EndIf

If xTipoForn == "2" //Fornecedor

	DEFINE MSDIALOG oDlgA FROM  51,58 TO 200,460 TITLE "Selecione o Banco para Pagamento Antecipado" PIXEL
	
	@ 005, 060 SAY "Informe os Dados do Banco.:" SIZE 100, 007 OF oDlgA COLORS 0, 16777215 PIXEL
	@ 012, 005 SAY Replicate("-",90) SIZE 200, 007 OF oDlgA COLORS 0, 16777215 PIXEL
	@ 028, 005 SAY oSay4 PROMPT "Banco" SIZE 030, 007 OF oDlgA COLORS 0, 16777215 PIXEL
	@ 028, 025 MSGET oGet2 VAR _cBanco F3 "SA6" WHEN .T. SIZE 005, 010 OF oDlgA COLORS 0, 16777215 PIXEL// VALID BANCOCP()   
	@ 028, 065 SAY oSay4 PROMPT "Ag๊ncia" SIZE 030, 007 OF oDlgA COLORS 0, 16777215 PIXEL
	@ 026, 090 MSGET oGet1 VAR _cAgencia When .F.  SIZE 007, 010 OF oDlgA COLORS 0, 16777215 PIXEL 
	@ 028, 130 SAY oSay4 PROMPT "Conta" SIZE 030, 007 OF oDlgA COLORS 0, 16777215 PIXEL
	@ 028, 150 MSGET oGet1 VAR _cConta When .F.  SIZE 040, 010 OF oDlgA COLORS 0, 16777215 PIXEL 
	
	DEFINE SBUTTON FROM 058, 075 TYPE 1 ENABLE OF oDlgA ACTION (_lRet1 :=.T.,oDlgA:End())
	DEFINE SBUTTON FROM 058, 105 TYPE 2 ENABLE OF oDlgA ACTION (_lRet1 :=.F.,oDlgA:End())
	
	ACTIVATE MSDIALOG oDlgA CENTERED  
	
	IF _lRet1 //Confirmou a escolha do banco

		_aTitulo := {	{"E2_PREFIXO", SPACE(3)			, NIL},;
						{"E2_NUM"    , SZL->ZL_NUM		, NIL},;
						{"E2_PARCELA", "01"				, NIL},;
						{"E2_TIPO"   , "PA "			, NIL},;
	   					{"E2_HIST"   , SZL->ZL_OBS		, NIL},;
	   					{"E2_NATUREZ", SZL->ZL_NATUREZ	, NIL},;
						{"E2_FORNECE", SZL->ZL_FORNECE	, NIL},;
						{"E2_LOJA"   , SZL->ZL_LOJA		, NIL},;
	   					{"E2_EMISSAO", dDataBase		, NIL},;
						{"E2_VENCTO" , dDataBase		, NIL},;
	   					{"E2_VENCREA", dDataBase		, NIL},;
						{"E2_VALOR"  , SZL->ZL_VALOR	, NIL},;
						{"AUTBANCO"	 ,_cBanco			, Nil},;
						{"AUTAGENCIA",_cAgencia			, Nil},;
	   					{"AUTCONTA"	 ,_cConta			, Nil}}
		Begin Transaction
			
		MsExecAuto({|x,y,z| FINA050(x,y,z)},_aTitulo,,3)   	//MSEXECAUTO DE INCLUSAO DE TITULO
		
		If lMsErroAuto
			RollBackSX8()
			MostraErro()
			DisarmTransaction()
			break
		Else
			lGerou		:= .T.
			Aviso(cCadastro, "Titulo PA gerado com sucesso", {"Sair"} )
		EndIf
	
		End Transaction
		ConfirmSx8()
	EndIf
	
ElseIf xTipoForn == "1" //Funcionario

	_xBcoFF		:= GetMv("FI_XBCOFF",,.F.)
	_cBanco		:= Substr(_xBcoFF,1,AT("/",_xBcoFF)-1)

	_xBcoFF		:= Substr(_xBcoFF,AT("/",_xBcoFF)+1,500)
	_cAgencia	:= Substr(_xBcoFF,1,AT("/",_xBcoFF)-1)

	_xBcoFF		:= Substr(_xBcoFF,AT("/",_xBcoFF)+1,500)
	_cCC		:= Substr(_xBcoFF,1,20)

	If RecLock("SET",.T.)
		SET->ET_FILIAL 		:= xFilial("SET")
		SET->ET_CODIGO 		:= GetSxeNum("SET","ET_CODIGO")
		ConfirmSx8()
		SET->ET_NOME 		:= SZL->ZL_SOLICIT
		SET->ET_VALOR 		:= SZL->ZL_VALOR
		SET->ET_TPREP 		:= "0"
		SET->ET_LIMREP 		:= SZL->ZL_VALOR
		SET->ET_BANCO 		:= _cBanco
		SET->ET_AGEBCO 		:= _cAgencia
		SET->ET_CTABCO 		:= _cCC
		SET->ET_SITUAC 		:= "0"
		SET->ET_NATUREZ		:= SZL->ZL_NATUREZ
		SET->ET_CC     		:= SZL->ZL_CC
		SET->ET_CONTA  		:= SZL->ZL_CONTAB 
		SET->ET_DTCRIA 		:= dDataBase
		SET->ET_SALDO  		:= 0
		SET->ET_ULTREP 		:= CTOD("  /  /   ")
		SET->ET_SEQCXA 		:= "000001"
		SET->ET_FORNECE		:= SZL->ZL_FORNECE
		SET->ET_LOJA   		:= SZL->ZL_LOJA
		SET->ET_NRREND 		:= "0000000001"
		MsUnLock()
		lGerou		:= .T.
	EndIf
	Aviso(cCadastro, "Caixinha "+SET->ET_CODIGO+" gerado com sucesso", {"Sair"} )
EndIf

If lGerou
	RecLock("SZL",.F.)
	SZL->ZL_STATUS := "5" //"Processo Encerrado"
	MsUnLock()
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA01  บAutor  ณMicrosiga           บ Data ณ  07/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINA10(cAlias,nReg,nOpc)

Local _lRet := .F.

If nOpc == 5	//Exclusao
	If SZL->ZL_STATUS <> '1'
		msgBox("Nใo pode excluir Requisi็ใo de Numerario, processo em Andamento","Alert")
		_lRet := .F.
		Return(_lRet)
	Else
		SZL->(RecLock("SZL",.F.))
		SZL->(AxDeleta("SZL",Recno(),nOpc))
		SZL->(MsUnLock())
		_lRet := .T.
	EndIf
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINL10  บAutor  ณMicrosiga           บ Data ณ  06/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FIFINL10()

_aLeg := {	{"BR_VERDE"		, "Em Aberto"  				},;
			{"BR_AMARELO"	, "Enviado para Aprova็ใo"	},;
			{"BR_AZUL"		, "Requisi็ใo Aprovada"		},;
			{"BR_PRETO"		, "Requisi็ใo Reprovada"	},;
			{"BR_VERMELHO"	, "Processo Encerrado"		},;
			{"BR_CANCEL"	, "Cancelada"				}}

BrwLegenda(cCadastro, "Legenda", _aLeg)

Return
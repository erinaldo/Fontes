#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "colors.ch"
//TODO Verificar lançamentos contábeis e validações de campos na tela
#DEFINE _EOL chr(13) + chr(10)
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINA10
Tela de Consulta a Movimentacao do Cartoes ITAU
@author  	Emerson Natali
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CFINA10()
//Declaracao de variaveis.
Private _cString := "SZK"
Private aRotina
Private cCadastro
Private _cAntCon 	:=space(10)
Private _cAntNat 	:=space(10)
Private _cAntRMU 	:=space(01)
Private aIndexSZK	:= {}
//Private _cFilSZK	:= 'ZK_TIPO == "4" .AND. (ZK_XTPINAT <> "1") '//Mostra somente Cartao e Status A=Ativo
Private _cFilSZK	:= 'ZK_TIPO == "4" .AND. ZK_STATUS == "A" ' //Mostra Cartao e Status A=Ativo
Private _aAux2		:= {}

Private onSaldoD, _nValTotDeb := 0
Private onSaldoC, _nValTotCre := 0
Private onSaldoR, _nValTotRea := 0

Private _nPosCart := 0
Private _aCartaoInativo := {}

Private _nCtaImp	:= GetMV("CI_CTAFFC")

DEFINE FONT oFnt     NAME "ARIAL" SIZE 08,23 BOLD

SZK->(dbSetOrder(1))

//Monta um aRotina proprio.
aRotina := {	{"Pesquisar"		, "AxPesqui"       ,  0, 1},;
{"Consul/Prest.Ctas", "U_C6A10MAT(1)"  ,  0, 2},;
{"Receber Mov."		, "U_C6A10MAT(2)"  ,  0, 3},;
{"Legenda"			, "U_C6A10MAT(999)",  0, 4}}

//Exibe a tela de cadastro.
cCadastro := "Consulta x Prestação de Contas"

bFiltraBrw := {|| FilBrowse("SZK", @aIndexSZK, @_cFilSZK)}
Eval(bFiltraBrw)

mBrowse(06, 01, 22, 75, _cString,,,,,, C6A10LEG(0))

Return
/*------------------------------------------------------------------------
*
* C6A10MAT()
* Rotina de manutenção 
*
------------------------------------------------------------------------*/
User Function C6A10MAT(_nOpc)
// _nOpc
// 1 - Pesquisar
// 2 - Visual
// 3 - Incluir
// 4 - Alterar
// 5 - Excluir
// 6 - Legenda
// O campo X3_PROPRI=="L" sairao no Acols
//Declaracao de variaveis.
Local _lRet := .T.
Local _aArea
Local _aAreaZK
Local _aAreaX3
Local _aAreaZF
Local _aAux1
Local _nAux1
LOCAL cDirArq	:= GETMV("CI_ITAUARQ",.T.,"C:\arq_txt\tesouraria\Importacao\Itau\") 
LOCAL cDirBak	:= GETMV("CI_ITAUBKP",.T.,"C:\arq_txt\tesouraria\Importacao\Itau\backup\") 
Private aCols
Private aHeader
Private aHeader2
Private aCols2
Private LVISUAL := (_nOpc == 2)
Private LINCLUI := (_nOpc == 3)
Private LALTERA := (_nOpc == 4)
Private LEXCLUI := (_nOpc == 5)

/*
// Trecho incluido em 29/08/2013 SI.13/0160 - A EXECUÇÃO DA OPÇÃO 1=Consul/Prest.Ctas SÓ PODE SER FEITA DAS 00:00H ATÉ AS 16:00H
If _nOpc == 1 .And. !( _HoraExec >= _cVerIni .And. _HoraExec <= _cVerFim )
	MsgBox("Em virtude da transmissão de arquivos para os Bancos, NÃO pode haver movimentação após as "+_cHoraFim+"h!"+CRLF+CRLF+;
	"Só será permitida movimentação a partir das "+_cHoraIni+"h de amanhã!","HORÁRIO DE MOVIMENTAÇÃO")
	Return(_lRet)
EndIf
*/
// O Tratamento da Hora de Execução será contemplado no campo de gravação do campo ZY_DTVLD conforme S.I. 13/0160 solicitação Cristiano em 12/09/2013


// Armazena o posicionamento do alias SE2 antes de processa-lo.
_aAreaZK := SZK->(GetArea())

Do Case
	Case _nOpc == 1  // Prestacao de Contas 		----------------- Modelo 3 manual
		If SZK->ZK_STATUS == "I"
			msgBox("Cartao Inativo!!!","Alerta")
		Else
			If RecLock("SZK",.F.) //Esta posicionado e Trava o registro para dois usuarios nao acessarem o mesmo registro
				MsUnLock()
				C6A10MOD3()
			EndIf
		EndIf
	Case _nOpc == 2  // Receber Mov. 				----------------- Leitura do Arq_txt e importacao do Mesmo.
	
		IF !C6A10DIR(cDirArq)
			return
		Endif
		
		IF !C6A10DIR(cDirBak)
			return
		Endif		
		
		Processa({||  C6A10IMP(cDirArq,cDirBak) },"Processando Registros...")
		
		If Len(_aCartaoInativo) > 0
			_cMens	:= "Cartao(oes) Inativo(s), Movimento Nao Importado!!!"+CHR(13)+CHR(10)
			_cMens += _aCartaoInativo[1]
			For _nI := 2 to Len(_aCartaoInativo)
				_cMens +=  ", "+_aCartaoInativo[_nI]
				If len(_cMens) >= 32
					_cMens += CHR(13)+CHR(10)
				EndIf
			Next
			MsgBox(_cMens, "Alerta")
		EndIf
		
	Case _nOpc == 999
		C6A10LEG()
	OtherWise
EndCase

SZK->(RestArea(_aAreaZK))
Return(_lRet)
/*------------------------------------------------------------------------
*
* C6A10DIR()
* Verifica a existencia do diretório na unidade. 
*
------------------------------------------------------------------------*/
static function C6A10DIR(cDirArq)
Local lRet		:= .t.
local cUnid	:= left(cDirArq,2)
Local aPst 	:= StrTokArr(RIGHT(cDirArq,len(cDirArq)-2),"\",.T.)
Local nCnta	:= 0		

For nCnta:=1 to len(aPst)
	if !Empty(aPst[nCnta])
		cUnid:= cUnid+"\"+aPst[nCnta]
		If !ExistDir(cUnid)
		  if MakeDir(cUnid) != 0
		    lRet:= .f.
		    msgalert( "Não foi possível criar o diretório: "+cUnid+"."+CRLF+"Erro: " + cValToChar( FError() ) )
		    exit
		  endIf
		Endif
	Endif
next nCnta 
		
return lRet
/*------------------------------------------------------------------------
*
* C6A10LEG()
* Exibe legenda
*
------------------------------------------------------------------------*/
Static Function C6A10LEG(_uPar)

//Declaracao de variaveis.
Local _uRet, _aFlag

_aLeg := {	{"BR_VERDE"   	,  "Sem Movimentacao"		},;
{"BR_AMARELO" 	,  "Com Movimentacao"		},;
{"BR_MARRON" 	,  "Digitado Contabil"		},;
{"BR_PRETO"   	,  "Limite Bloqueado"		},;
{"BR_AZUL"  	,  "Ferias"        			},;
{"BR_BRANCO"	,  "Subs.Ferias"			},;
{"BR_VERMELHO"	,  "Afastado"				},;
{"BR_LARANJA"	,  "Demitido"				},;
{"BR_PINK"		,  "Alt.Responsabilidade"	}}


If ValType(_uPar) != "U" .and. _uPar == 0
	/*
	_aFlag := {	{'Empty(ZK_E_SLDPR) .and. Empty(ZK_E_DTBLQ) .and. ZK_STATUS <> "I" ', _aLeg[1][1]},;  // Verde
	{'!Empty(ZK_E_SLDPR) .and. Empty(ZK_E_DTBLQ).and. ZK_STATUS <> "I" ', _aLeg[2][1]},;  // Amarelo
	{'!Empty(ZK_E_DTBLQ).and. ZK_STATUS <> "I"'							, _aLeg[3][1]},;  // Preto
	{'ZK_STATUS == "I" .AND. ZK_XTPINAT == "2" '						, _aLeg[4][1]},;  // Ferias
	{'ZK_STATUS == "I" .AND. ZK_XTPINAT == "3" '						, _aLeg[5][1]},;  // Subs.Ferias
	{'ZK_STATUS == "I" .AND. ZK_XTPINAT == "4" '						, _aLeg[6][1]}}	   // Afastado
	*/
	
	_aFlag := {	{'Empty(ZK_E_SLDPR) .and. Empty(ZK_E_DTBLQ) .and. !(ZK_XTPINAT$"12345")  .and. ZK_DIGCONT == "N" '	, _aLeg[1][1]},;  // Verde
	{'!Empty(ZK_E_SLDPR) .and. Empty(ZK_E_DTBLQ) .and. !(ZK_XTPINAT$"12345") .and. ZK_DIGCONT == "N" '	, _aLeg[2][1]},;  // Amarelo
	{'!Empty(ZK_E_SLDPR) .and. Empty(ZK_E_DTBLQ) .and. !(ZK_XTPINAT$"12345") .and. ZK_DIGCONT == "S" '	, _aLeg[3][1]},;  // Amarelo
	{'!Empty(ZK_E_DTBLQ) .and. !(ZK_XTPINAT$"12345") .and. ZK_DIGCONT == "N" '							, _aLeg[4][1]},;  // Preto
	{'ZK_STATUS == "A" .AND. ZK_XTPINAT == "2" .and. ZK_DIGCONT == "N" '								, _aLeg[5][1]},;  // Ferias
	{'ZK_STATUS == "A" .AND. ZK_XTPINAT == "3" .and. ZK_DIGCONT == "N" '								, _aLeg[6][1]},;  // Subs.Ferias
	{'ZK_STATUS == "A" .AND. ZK_XTPINAT == "4" .and. ZK_DIGCONT == "N" '								, _aLeg[7][1]},;  // Afastado
	{'ZK_STATUS == "A" .AND. ZK_XTPINAT == "1" .and. ZK_DIGCONT == "N" '								, _aLeg[8][1]},;  // Demiti
	{'ZK_STATUS == "A" .AND. ZK_XTPINAT == "5" .and. ZK_DIGCONT == "N" '								, _aLeg[9][1]}}	   // Alt.Resp.
	
	
	_uRet := _aFlag
Else
	BrwLegenda(cCadastro, "Legenda", _aLeg)
Endif
Return (_uRet)
/*------------------------------------------------------------------------
*
* C6A10MOD3()
* Monta tela de manutenção
*
------------------------------------------------------------------------*/
STATIC Function C6A10MOD3()
Local lRet
Local nOpca := 0
Local cSaveMenuh
Local nReg
Local oDlg
Local oEnchoice
Local nDlgHeight
Local nGDHeight
Local aSize := {}

Local _HoraExec	:= StrTran(Time(),":","")			// incluido em 29/08/2013 SI.13/0160
Local _cHoraIni := SuperGetMV("CI_HRCTINI",.T.,"00:00:01")
Local _cHoraFim := SuperGetMV("CI_HRCTFIM",.T.,"16:00:00")
Local _cVerIni  := StrTran(_cHoraIni,":","")
Local _cVerFim  := StrTran(_cHoraFim,":","")        

local cDataSE5 := ""
local aMovPag	 := {}
Private aTELA:=Array(0,0)
Private aGets:=Array(0)
Private _nRecSZK:=0
_nValTotDeb := 0
_nValTotCre := 0
_nValTotRea := 0

If SetMDIChild()
	oMainWnd:ReadClientCoors()
	nDlgHeight := 500
	nGDHeight  := oMainWnd:nBottom
Else
	nDlgHeight := 420
	nGDHeight  := 70
EndIf

aCordW := {135,000,nDlgHeight,632}
nSizeHeader := 210 //Tamanho do Cabecalho Enchoice

Aadd(aSize,nSizeHeader)

cTitulo		:= "Consulta x Prestação de Contas"
cAlias1		:= _cString         // Alias da enchoice.
nReg		:=(cAlias1)->(Recno())
cAlias2		:= "SE5"            // Alias da GetDados.
cAlias3		:= "SZY"            // Alias da GetDados2.
aMyEncho	:= {}				// Campos da Enchoice.
cFieldOk	:= "AllwaysTrue()"  // Valida cada campo da GetDados.
cLinOk		:= "AllwaysTrue()"  // Valida a linha.
cTudoOk		:= "AllwaysTrue()"  // Valida toda a GetDados.
nOpcE		:= 2                // Opcao da Enchoice.
lVirtual	:= .T.	            // Exibe os campos virtuais na GetDados.
nLinhas		:= 99               // Numero maximo de linhas na GetDados.
aAltEnch	:= nil              // Campos alteraveis na Enchoice (nil = todos).

nOpcE 		:= If(nOpcE==Nil,3,nOpcE)
lVirtual 	:= Iif(lVirtual==Nil,.F.,lVirtual)
nLinhas		:=Iif(nLinhas==Nil,99,nLinhas)

nFreeze		:=nil

//Cria variaveis M->????? da Enchoice.
RegToMemory(cAlias1, .F.)
RegToMemory("SZY", .T.)

//Monta a aHeader.
aHeader 	:= {}
aHeader2 	:= {}
_aArea := SX3->(GetArea())
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias2)
/*
******************** Primeiro aHeader
*/
Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == cAlias2) //SE5
	If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL)
		aAdd(aHeader,	 {	TRIM(SX3->X3_TITULO)	,;
		SX3->X3_CAMPO			,;
		SX3->X3_PICTURE			,;
		SX3->X3_TAMANHO			,;
		SX3->X3_DECIMAL			,;
		SX3->X3_VALID			,;
		SX3->X3_USADO			,;
		SX3->X3_TIPO			,;
		SX3->X3_F3				,;
		SX3->X3_CONTEXT			,;
		SX3->X3_CBOX			,;
		SX3->X3_RELACAO			,;
		SX3->X3_WHEN			,;
		SX3->X3_VISUAL			,;
		SX3->X3_VLDUSER			,;
		SX3->X3_PICTVAR			,;
		SX3->X3_OBRIGAT			})
	Endif
	SX3->(dbSkip())
EndDo

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias3)
/*
******************** Segundo aHeader2
*/
Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == cAlias3) //SZY
	If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL)
		aAdd(aHeader2, {	TRIM(SX3->X3_TITULO)	,;
		SX3->X3_CAMPO			,;
		SX3->X3_PICTURE			,;
		SX3->X3_TAMANHO			,;
		SX3->X3_DECIMAL			,;
		SX3->X3_VALID			,;
		SX3->X3_USADO			,;
		SX3->X3_TIPO			,;
		SX3->X3_F3				,;
		SX3->X3_CONTEXT			,;
		SX3->X3_CBOX			,;
		SX3->X3_RELACAO			,;
		SX3->X3_WHEN			,;
		SX3->X3_VISUAL			,;
		SX3->X3_VLDUSER			,;
		SX3->X3_PICTVAR			,;
		SX3->X3_OBRIGAT			})
	Endif
	SX3->(dbSkip())
EndDo
SX3->(RestArea(_aArea))

//Monta a aCols
aCols 	:= {}
aCols2 	:= {}

/*
******************** Primeiro aCols
*/
_aAreaX3 := SX3->(GetArea())
DbSelectArea("SX3")
SX3->(dbSetOrder(2))

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SE5')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND E5_MOEDA = 'DE' "
cQuery += "AND SUBSTRING(E5_XCARTAO,1,6) = '"+ALLTRIM(SZK->ZK_NROCRT)+"' "
cQuery += "AND MONTH(E5_DATA) = "+STR(MONTH(DDATABASE),2)+" "
cQuery += "ORDER BY E5_DATA "
TcQuery cQuery New Alias "SE5TMP"
TcSetField("SE5TMP","E5_DATA","D",8, 0 )

DbSelectArea("SE5TMP")
Do While !EOF()
	_aAux1 := {}
	For _nAux1 := 1 to len(aHeader)
		SX3->(dbSeek(aHeader[_nAux1, 2]))
		If SX3->X3_CONTEXT == "V"
			aAdd(_aAux1, &(SX3->X3_RELACAO))
		Else
			aAdd(_aAux1, SE5TMP->(&(aHeader[_nAux1, 2])))
		Endif
	Next _nAux1
	aAdd(_aAux1, .F.)
	aAdd(aCols, _aAux1)
	SE5TMP->(dbSkip())
EndDo

SE5TMP->(DbCloseArea())

SX3->(RestArea(_aAreaX3))

/*
******************** Segundo aCols2
*/
_aAreaZY := SZY->(GetArea())
_aAreaX3 := SX3->(GetArea())
DbSelectArea("SX3")
SX3->(dbSetOrder(2))
DbSelectArea("SZY")
DbSetOrder(1)
DbSeek(xFilial("SZY")+alltrim(SZK->ZK_NROCRT),.F.)
If EOF()
	_aAux1 := {}
	_aAux2 := {}
	For _nAux1 := 1 to len(aHeader2)
		If (alltrim(SZY->((aHeader2[_nAux1, 2])))) == "ZY_DATA"
			aAdd(_aAux1, DDATABASE )
		Else
			aAdd(_aAux1, SZY->(&(aHeader2[_nAux1, 2])))
		EndIf
	Next _nAux1
	aAdd(_aAux1, .F.)
	aAdd(aCols2, _aAux1)
EndIf
//Verifica os movimentos de Prestacao de Contas que ainda nao foram validados pelo Financeiro
//e que esta dentro do mes atual - DDATABASE
cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SZY')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZY_VLDFIN = '2' "
cQuery += "AND SUBSTRING(ZY_CARTAO,1,6) = '"+ALLTRIM(SZK->ZK_NROCRT)+"' "
cQuery += "ORDER BY ZY_CARTAO, ZY_DATA "
TcQuery cQuery New Alias "SZYTMP"
TcSetField("SZYTMP","ZY_DATA","D",8, 0 )

_nSaldo			:= SZK->ZK_E_SLDPR

DbSelectArea("SZYTMP")
Do While !EOF()
	_aAux1 := {}
	_aAux2 := {}
	For _nAux1 := 1 to len(aHeader2)
		SX3->(dbSeek(aHeader2[_nAux1, 2]))
		If SX3->X3_CONTEXT == "V"
			aAdd(_aAux1, &(SX3->X3_RELACAO))
		Else
			aAdd(_aAux1, SZYTMP->(&(aHeader2[_nAux1, 2])))
		Endif
		aAdd(_aAux2, recno())
		
		If (alltrim(SZY->((aHeader2[_nAux1, 2])))) == "ZY_VALOR"
			_nValTotDeb += IIF(!Empty(SZYTMP->ZY_ITEM) , SZYTMP->(&(aHeader2[_nAux1, 2])),0)
			/*
			If _nValTotDeb > _nSaldo
			_nValTotDeb -= IIF(!Empty(SZYTMP->ZY_ITEM) , SZYTMP->(&(aHeader2[8, 2])) ,0)
			EndIf
			*/
			_nValTotCre += IIF(!Empty(SZYTMP->ZY_ITEMC), SZYTMP->(&(aHeader2[_nAux1, 2])),0)
			
			//			_nValTotRea += IIF(!Empty(SZYTMP->ZY_ITEM) , IIF(ALLTRIM(SZYTMP->ZY_ITEM)$_nCtaImp , SZYTMP->(&(aHeader2[_nAux1, 2])) , 0 ) , 0 )
			_nValTotRea += IIF(!Empty(SZYTMP->ZY_ITEMC), IIF(ALLTRIM(SZYTMP->ZY_ITEMC)$_nCtaImp, SZYTMP->(&(aHeader2[_nAux1, 2])) , 0 ) , 0 )
		EndIf
		
	Next _nAux1
	
	aAdd(_aAux1, .F.)
	aAdd(aCols2, _aAux1)
	SZYTMP->(dbSkip())
EndDo

_nValTotRea := iif(_nValTotDeb == _nValTotCre, (_nValTotCred-(_nValTotRea)), 0)
//_nValTotRea := iif(_nValTotDeb == _nValTotCre, (_nValTotDeb-(_nValTotRea/2)), 0)

SZYTMP->(DbCloseArea())

SX3->(RestArea(_aAreaX3))
SZY->(RestArea(_aAreaZY))

aButtons	:= {}

//Aadd( aButtons, { "Entrada", { || A103NFiscal("SF1",SF1->(RecNo()),3)   },"Documento Entrada","Documento Entrada"}) // A103NFiscal("SF1",0,3)   },"Documento Entrada","Documento Entrada"})
Aadd( aButtons, { "Entrada", { || U_C6A10DOC()  },"Documento Entrada","Documento Entrada"}) // A103NFiscal("SF1",0,3)   },"Documento Entrada","Documento Entrada"})
aFolder		:= {"Prestação de Contas", "Movimentação Cartão"}

_nSFld1		:= 122 //Linha Inicial
_nSFld2		:= 630 //Coluna Final
_nSFld3		:= 290 //Linha Final

/*INICIO ------------- TAMANHO DA TELA*/
_aSize := MsAdvSize()
aObjects:= {}
aPosObj :={}

aInfo   := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3}

AADD(aObjects,{100,030,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo, aObjects)
/*FIM ------------- TAMANHO DA TELA*/

DEFINE FONT oBold		NAME "Arial" SIZE 0, -18 BOLD
DEFINE FONT oBold_New	NAME "Courier" SIZE 0, -14 BOLD
//DEFINE MSDIALOG oDlg TITLE cTitulo From aCordW[1],aCordW[2] to aCordW[3],aCordW[4] Pixel of oMainWnd
DEFINE MSDIALOG oDlg TITLE cTitulo From _aSize[7],0 TO _aSize[6],_aSize[5] Pixel of oMainWnd

oEnchoice	:= Msmget():New(cAlias1,nReg,nOpcE,,,,aMyEncho,{15,1,120,315},aAltEnch,3,,,,,,lVirtual,,,,,,,,.T.)

//oFolder		:= TFolder():New(_nSFld1,1,aFolder,{},oDlg,,,, .T., .F.,_nSFld2,_nSFld3,)
oFolder		:= TFolder():New(_nSFld1,1,aFolder,{},oDlg,,,, .T., .F.,aPosObj[2,4]-5,aPosObj[2,3]-120,)

aCampos		:= {}
aCampos2	:= {}

AADD(aCampos2,"ZY_ITEM") 	//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_ITEMC") 	//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_CC")		//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_CCC")		//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_NATUREZ")	//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_HIST")	//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_VALOR")	//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_ENCARGO")	//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_DATA")	//campos alteraveis no GetDados2
AADD(aCampos2,"ZY_XCOMPET") //campos alteraveis no GetDados2
nGetd		:= nil
//oGetDados1	:= MsNewGetDados():New(_nSFld1,1,_nSFld2,_nSFld3,nGetd ,cLinOk,cTudoOk,"",aCampos ,nFreeze,nLinhas,cFieldOk,/*superdel*/,/*delok*/,oFolder:aDialogs[2],aheader ,acols )
//                                                                  coluna            linha
oGetDados1	:= MsNewGetDados():New(aPosObj[2,1]-38,aPosObj[2,2]-2,aPosObj[2,3]-140,aPosObj[2,4]-7,nGetd ,cLinOk,cTudoOk,"",aCampos ,nFreeze,nLinhas,cFieldOk,/*superdel*/,/*delok*/,oFolder:aDialogs[2],aheader ,acols )
oGetDados1:oBrowse:bGotFocus 	:={|| Fd_Entra(2)}
oGetDados1:oBrowse:bLostFocus	:={|| Fd_Sai(2)}
oGetDados1:oBrowse:Default()
oGetDados1:oBrowse:Refresh()
oFolder:aDialogs[2]:Refresh()

nGetd2		:= GD_INSERT+GD_UPDATE+GD_DELETE

_nLin1	:= 1	//linha
_nLin2	:= 1	//coluna
_nLin3	:= 210	//linha
_nLin4	:= 630	//coluna

//oGetDados2	:= MsNewGetDados():New(_nLin1,_nLin2,_nLin3,_nLin4,nGetd2,"u_CFINALOK()",cTudoOk,"",aCampos2,nFreeze,nLinhas,cFieldOk,/*superdel*/,"u_C6A10DEL()",oFolder:aDialogs[1],aheader2,acols2)
//oGetDados2	:= MsNewGetDados():New(aPosObj[2,1]-38,aPosObj[2,2]-2,aPosObj[2,3]-160,aPosObj[2,4]-7,nGetd2,"u_CFINALOK()",cTudoOk,"ZY_HIST",aCampos2,nFreeze,nLinhas,cFieldOk,/*superdel*/,"u_C6A10DEL()",oFolder:aDialogs[1],aheader2,acols2)
//                                                                  linha             coluna
oGetDados2	:= MsNewGetDados():New(aPosObj[2,1]-38,aPosObj[2,2]-2,aPosObj[2,3]-160,aPosObj[2,4]-7,nGetd2,"u_CFINALOK()",cTudoOk,"ZY_HIST",aCampos2,nFreeze,nLinhas,"u_CFINAFOK()",/*superdel*/,"u_C6A10DEL()",oFolder:aDialogs[1],aheader2,acols2)
If oGetDados2:aCols[1, 6] == "0000000000000000000000000000000000000000"
	oGetDados2:aCols[1, 6] := Space(40)
End
oGetDados2:oBrowse:bGotFocus 	:={|| Fd_Entra(1)}
oGetDados2:oBrowse:bLostFocus	:={|| Fd_Sai(1)}
oGetDados2:oBrowse:Default()
oGetDados2:oBrowse:Refresh()
oFolder:aDialogs[1]:Refresh()
oFolder:SetOption(1)

oGetDados2:oBrowse:SetFocus()

@ 025,325 SAY OemToAnsi("Limite Cartão ") OF oDlg PIXEL FONT oBold COLOR CLR_BLUE
@ 025,415 SAY TRANSFORM(SZK->ZK_E_LIMIT,'@E 9,999,999.99') OF oDlg PIXEL FONT oBold COLOR CLR_BLUE
@ 045,325 SAY OemToAnsi("Sld. Disp. ") OF oDlg PIXEL FONT oBold COLOR CLR_BLUE
@ 045,415 SAY TRANSFORM(SZK->ZK_E_SLDAT,'@E 9,999,999.99')	OF oDlg PIXEL FONT oBold COLOR CLR_BLUE
@ 065,325 SAY OemToAnsi("Sld. Prest. Conta ") OF oDlg PIXEL FONT oBold COLOR CLR_BLUE
@ 065,415 SAY TRANSFORM(SZK->ZK_E_SLDPR,'@E 9,999,999.99') 	OF oDlg PIXEL FONT oBold COLOR CLR_BLUE
@ 085,325 SAY OemToAnsi("Percentual ") OF oDlg PIXEL FONT oBold COLOR CLR_BLUE
@ 085,425 SAY Str((SZK->ZK_E_SLDPR/SZK->ZK_E_LIMITE)*100,6,2)+"%" 	OF oDlg PIXEL FONT oBold COLOR CLR_BLUE

@ aPosObj[2,3]-150,030 SAY "Total Debito : " of oFolder:aDialogs[1] PIXEL FONT oFnt COLOR CLR_BLUE
@ aPosObj[2,3]-150,090 SAY onSALDOD VAR _nValTotDeb of oFolder:aDialogs[1]  Picture "@E 99,999,999.99" SIZE 60,40 PIXEL FONT oFnt COLOR CLR_BLUE

@ aPosObj[2,3]-150,150 SAY "Total Credito : " of oFolder:aDialogs[1] PIXEL FONT oFnt COLOR CLR_BLUE
@ aPosObj[2,3]-150,210 SAY onSALDOC VAR _nValTotCre of oFolder:aDialogs[1]  Picture "@E 99,999,999.99" SIZE 60,40 PIXEL FONT oFnt COLOR CLR_BLUE

@ aPosObj[2,3]-150,350 SAY "Valor Prestado Contas : " of oFolder:aDialogs[1] PIXEL FONT oFnt COLOR CLR_BLUE
@ aPosObj[2,3]-150,450 SAY onSALDOR VAR _nValTotRea of oFolder:aDialogs[1]  Picture "@E 99,999,999.99" SIZE 60,40 PIXEL FONT oFnt COLOR CLR_BLUE

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,;
{||iif(U_CFINATOK(), (nOpca:=1,Iif(MsgYesNo("Confirma Validação dos dados?", "Gera Atualizacao Saldo"),oDlg:End(),nOpca:=0)), nOpca:=0 )},;
{||nOpca:=0,oDlg:End()},;
,;
aButtons),;
)
//											AlignObject(oDlg,{oEnchoice:oBox,oGetDados1:oBrowse},1,,aSize))

lRet:=(nOpca==1)

If lRet

	MsAguarde(, "Aguarde...", OemToAnsi("Processando Prestação de Contas...Aguarde.."),.F.)

	// INICIO
	// If !(Alltrim(cUserName) $ GetMV("CI_USEPRES"))             	// comentado em 29/08/2013 - SSI.13/0160
	_nRecSZK	:= SZK->(Recno())
	_cCartao 	:= alltrim(SZK->ZK_NROCRT)
	_dDtRat		:= oGetDados2:aCols[1, 10]
	_cHist		:= Alltrim(oGetDados2:aCols[1, 6])
	_cColabor 	:= Substr(Posicione("SZK",4,xFilial("SZK")+alltrim(_cCartao),"SZK->ZK_NOME"),1,30)
	If SZK->(Recno())<>_nRecSZK ; SZK->(dbGoTo(_nRecSZK)) ; EndIf
	
	cQuery := "SELECT COUNT(*) NUMREG "
	cQuery += "FROM "+RetSQLname('CT2')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND CT2_DATA = '"+DTOS(_dDtRat)+"' "
	cQuery += "AND CT2_ORIGEM = 'FFC "+_cCartao+" "+_cColabor+"' "
	cQuery += "AND CT2_HIST = '"+Substr(_cHist+" "+_cColabor,1,40)+"' " //Alterado pelo analista Emerson - 20/05/09. Apos o mov. efetivado e passado ao Financeiro que valida. O Contabil com esta alteracao pode efetuar novo lancamento.
	cQuery += "AND CT2_TPSALD = '1' "
	TcQuery cQuery New Alias "CT2TMP"
	
	If CT2TMP->NUMREG > 0
		msgbox("Lancamentos Efetivados, Nao Podem Ser Alterados","Alerta")
		CT2TMP->(DbCloseArea())
		For _nII :=1 to Len(oGetDados2:aCols)
			oGetDados2:aCols[_nII, 11] := .F.      //PATRICIA FONTANEZI
		Next
		Return(.F.)
	Else
		CT2TMP->(DbCloseArea())
	EndIf
	// EndIf			// Comentado em 29/08/2013 - SSI.13/0160   */
	// FIM
	
	//deletar todos os registros da tabela SZY para o Cartao posicionado que ainda nao foram validados pelo Financeiro
	_cQuery := "DELETE FROM "+RetSqlName("SZY")+" "
	_cQuery += "WHERE ZY_CARTAO ='"+alltrim(SZK->ZK_NROCRT)+"' "
	_cQuery += "AND ZY_VLDFIN = '2' " //1=Sim / 2=Nao
	TCSQLEXEC(_cQuery)
	
	_nTotRat	:= 0
	_nTotDep	:= 0 // Valor Deposito
	For _nI :=1 to Len(oGetDados2:aCols)
		If !Empty(oGetDados2:aCols[_nI, 1]) .or. !Empty(oGetDados2:aCols[_nI, 3]) //Se o registro estiver em branco
			If !oGetDados2:aCols[_nI, 11] //Se nao estiver deletado   PATRICIA FONTANEZI
				
				//Lancamento digitado pela Contabilidade
				_xGetArea	:= GetArea()
				RecLock("SZK",.F.)
				SZK->ZK_DIGCONT := "S"
				MsUnLock()
				RestArea(_xGetArea)
				
				RecLock("SZY",.T.)
				SZY->ZY_FILIAL	:= xFilial("SZY")
				SZY->ZY_CARTAO	:= alltrim(SZK->ZK_NROCRT)
				SZY->ZY_ITEM	:= oGetDados2:aCols[_nI, 1]
				SZY->ZY_CONTA	:= Posicione("CT1",2,xFilial("CT1")+oGetDados2:aCols[_nI, 1],"CT1_CONTA")
				SZY->ZY_CC		:= oGetDados2:aCols[_nI, 2]
				SZY->ZY_ITEMC	:= oGetDados2:aCols[_nI, 3]
				SZY->ZY_CONTAC	:= Posicione("CT1",2,xFilial("CT1")+oGetDados2:aCols[_nI, 3],"CT1_CONTA")
				SZY->ZY_CCC		:= oGetDados2:aCols[_nI, 4]
				SZY->ZY_NATUREZ	:= oGetDados2:aCols[_nI, 5]
				SZY->ZY_HIST	:= oGetDados2:aCols[_nI, 6]
				SZY->ZY_VALOR	:= oGetDados2:aCols[_nI, 7]
				SZY->ZY_ENCARGO	:= oGetDados2:aCols[_nI, 8]
				SZY->ZY_DATA	:= oGetDados2:aCols[_nI, 10]
				SZY->ZY_VLDFIN	:= "2"
				SZY->ZY_XCOMPET	:= oGetDados2:aCols[_nI, 9]
				MsUnLock()
				If !Empty(alltrim(oGetDados2:aCols[_nI, 3])) // Pego apenas a coluna Credito pois o total do Movimento Debito/Credito e sempre igual
					If !alltrim(oGetDados2:aCols[_nI, 3]) $ _nCtaImp
						If alltrim(oGetDados2:aCols[_nI, 5]) == "33080104" // "6.08.04"
						//If alltrim(oGetDados2:aCols[_nI, 5]) == "6.08.04"
							_nTotDep+=oGetDados2:aCols[_nI, 7] // Total do Rateio
						Else
							_nTotRat+=oGetDados2:aCols[_nI, 7] // Total do Rateio
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	
	//*************************************************
	//Contabiliza Lancamento Cartao por Rateio
	//*************************************************
	
	//Pesquisa Numero do Cartao e Conta Cartao
	DbSelectArea("SZY")
	DbSetOrder(1)
	DbSeek(xFilial("SZY")+alltrim(SZK->ZK_NROCRT), .F.) //Localiza o Cartao Posicionado e atualiza as informacoes
	_aAreaSZY 		:= GetArea()
	_cCartao 		:= alltrim(SZK->ZK_NROCRT)
	
	_dDtRat		:= oGetDados2:aCols[1, 10]
	_cHist		:= Alltrim(oGetDados2:aCols[1, 6])
	_cColabor 	:= Substr(Posicione("SZK",4,xFilial("SZK")+alltrim(_cCartao),"SZK->ZK_NOME"),1,30)
	If SZK->(Recno())<>_nRecSZK ; SZK->(dbGoTo(_nRecSZK)) ; EndIf
	
	// If !(Alltrim(cUserName) $ GetMV("CI_USEPRES"))			// COMENTADO EM 29/08/13 SI.13/0160
	//If MsgYesNo("Confirma Validação dos dados?", "Gera Atualizacao Saldo")		// INCLUÍDO EM 29/08/13 SI.13/0160
	
	/* ----- LINHA -  cQuery += "AND CT2_HIST = '"+Substr(_cHist+" "+_cColabor,1,40)+"' "   ----
	Alterado dia 20/05/09 pelo analista Emerson
	Apos o mov. efetivado e passado ao Financeiro que valida. O Contabil com esta alteracao pode
	efetuar novo lancamento.
	Alterado dia 23/09/09 pelo analista Emerson.
	Nao devemos pesquisar pelo Historico pois cada linha da tela do cartao e um hist. diferente.
	Alterado dia 28/09/09 pelo analista Emerson.
	Voltamos a linha da query pois ela estava impedindo o lancamento de mais de um documento no mesmo dia.
	Esta linha pesquisa o historico (onde o usuario informa o documento) e identifica o lancamento.
	*/
	cQuery := "SELECT COUNT(*) NUMREG "
	cQuery += "FROM "+RetSQLname('CT2')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND CT2_LOTE = '009800' "
	cQuery += "AND CT2_DATA = '"+DTOS(_dDtRat)+"' "
	cQuery += "AND CT2_ORIGEM = 'FFC "+_cCartao+" "+_cColabor+"' "
	cQuery += "AND CT2_HIST = '"+Substr(_cHist+" "+_cColabor,1,40)+"' "
	cQuery += "AND CT2_TPSALD = '1' "
	TcQuery cQuery New Alias "CT2TMP"
	
	If CT2TMP->NUMREG > 0
		msgbox("Lancamentos Efetivados, Nao Podem Ser Alterados","Alerta")
		CT2TMP->(DbCloseArea())
		Return(.F.)
	Else
		CT2TMP->(DbCloseArea())
	EndIf
	
	cQuery := "SELECT COUNT(*) NUMREG "
	cQuery += "FROM "+RetSQLname('CT2')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND CT2_LOTE = '009800' "
	cQuery += "AND CT2_DATA = '"+DTOS(_dDtRat)+"' "
	cQuery += "AND CT2_ORIGEM = 'FFC "+_cCartao+" "+_cColabor+"' "
	//		cQuery += "AND CT2_HIST = '"+Substr(_cHist+" "+_cColabor,1,40)+"' " //Alterado dia 23/09/09 pelo analista Emerson. Nao devemos pesquisar pelo Historico pois cada linha da tela do cartao e um hist. diferente.//Alterado pelo analista Emerson - 20/05/09. Apos o mov. efetivado e passado ao Financeiro que valida. O Contabil com esta alteracao pode efetuar novo lancamento.
	cQuery += "AND CT2_TPSALD = '9' "
	TcQuery cQuery New Alias "CT2TMP"
	TcSetField("CT2TMP","CT2_DATA","D",8, 0 )
	
	DbSelectArea("CT2TMP")
	If CT2TMP->NUMREG > 0
		_cQuery := "DELETE FROM "+RetSqlName('CT2')+" "
		_cQuery += "WHERE CT2_LOTE = '009800' "
		_cQuery += "AND CT2_DATA = '"+DTOS(_dDtRat)+"' "
		_cQuery += "AND CT2_ORIGEM = 'FFC "+_cCartao+" "+_cColabor+"' "
		//			_cQuery += "AND CT2_HIST = '"+Substr(_cHist+" "+_cColabor,1,40)+"' " //Alterado dia 23/09/09 pelo analista Emerson. Nao devemos pesquisar pelo Historico pois cada linha da tela do cartao e um hist. diferente.//Alterado pelo analista Emerson - 20/05/09. Apos o mov. efetivado e passado ao Financeiro que valida. O Contabil com esta alteracao pode efetuar novo lancamento.
		_cQuery += "AND CT2_TPSALD = '9' "
		TCSQLEXEC(_cQuery)
		CT2TMP->(DbCloseArea())
	Else
		CT2TMP->(DbCloseArea())
	EndIf
	
	aCab		:= {}
	aItem		:= {}
	aTotItem	:=	{}
	lMsErroAuto := .f.
	_nLin		:= 1
	
	aCab := {	{"dDataLanc", _dDtRat	,NIL},;
	{"cLote"	, "009800"	,NIL},;
	{"cSubLote"	, "001"		,NIL}}
	
	For _nIx :=1 to Len(oGetDados2:aCols)
		If !Empty(oGetDados2:aCols[_nIx, 1]) .or. !Empty(oGetDados2:aCols[_nIx, 3]) //Se o registro estiver em branco
			If !oGetDados2:aCols[_nIx, 11] //Se nao estiver deletado       //PATRICIA FONTANEZI
				_cDC	:= IIF(!Empty(oGetDados2:aCols[_nIx, 1]),"1","2")
				//Debitos - Creditos
				
				//Alterado dia 18/05/09 - analista Emerson Natali
				//Acrescentado nome do colaborador
				_cColabor    := Substr(Posicione("SZK",4,xFilial("SZK")+alltrim(_cCartao),"SZK->ZK_NOME"),1,30)
				_cCodFor     := Posicione("SZK",4,xFilial("SZK")+alltrim(_cHist),"SZK->ZK_FORNECE")
				If SZK->(Recno())<>_nRecSZK ; SZK->(dbGoTo(_nRecSZK)) ; EndIf
				
				AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")									, NIL},;
				{"CT2_LINHA"	, StrZero(_nLin,3)									, NIL},;
				{"CT2_DC"		, _cDC	 											, NIL},;	//Debito
				{"CT2_ITEMD"	, ALLTRIM(oGetDados2:aCols[_nIx, 1])				, NIL},;	//DEBITO  Item Contabil
				{"CT2_CCD"		, ALLTRIM(oGetDados2:aCols[_nIx, 2])				, NIL},;	//DEBITO  Centro de Custo
				{"CT2_ITEMC"	, ALLTRIM(oGetDados2:aCols[_nIx, 3])				, NIL},;	//CREDITO Item Contabil
				{"CT2_CCC"		, ALLTRIM(oGetDados2:aCols[_nIx, 4])				, NIL},;	//CREDITO Centro de Custo
				{"CT2_VALOR"	, oGetDados2:aCols[_nIx, 7]							, NIL},;
				{"CT2_HP"		, ""												, NIL},;
				{"CT2_HIST"		, Alltrim(oGetDados2:aCols[_nIx, 6])+" "+_cColabor	, NIL},;
				{"CT2_TPSALD"	, "9"												, NIL},;
				{"CT2_ORIGEM"	, "FFC "+_cCartao+" "+_cColabor						, NIL},;
				{"CT2_MOEDLC"	, "01"												, NIL},;
				{"CT2_EMPORI"	, ""												, NIL},;
				{"CT2_ROTINA"	, ""												, NIL},;
				{"CT2_LP"		, ""												, NIL},;
				{"CT2_XKEY"		, "BC"+_cCodFor+DTOS(_dDtRat)+_cCartao+_cColabor	, NIL},;
				{"CT2_KEY"		, ""												, NIL}})
				_nLin++
			EndIf
		EndIf
	Next
	
	aadd(aTotItem,aItem)
	MSExecAuto({|a,b,C| Ctba102(a,b,C)},aCab,aItem,3)
	aTotItem	:=	{}
	
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		Return .F.
	Endif
	
	aCab	:= {}
	aItem	:= {}
	
	//*************************************************
	//FIM Contabiliza Lancamento Cartao
	//*************************************************
	// EndIf				// COMENTADO EM 29/08/13 SI.13/0160
	
	RestArea(_aAreaSZY)
	dbSelectArea("SZY")			// INCLUIDO EM 29/08/13 SI.13/0160
	//Verifica regra de usuarios, pois somente o pessoal autorizado podem validar os lancamentos
	If !SZY->(EOF())
		// If Alltrim(cUserName) $ GetMV("CI_USEPRES")				// COMENTADO EM 29/08/2013 SSI.13/0160
		//	If MsgYesNo("Confirma Validação dos dados?", "Gera Atualizacao Saldo")
		Do While SZY->(!EOF()) .and. _cCartao == alltrim(SZY->ZY_CARTAO)
			If SZY->ZY_VLDFIN == "1"
				SZY->(DbSkip())
				Loop
			EndIf
			
			If dDataBase < SZY->ZY_DATA
				Msgbox("Data de Validacao ("+DtoC(dDataBase)+"), Nao Pode Ser Inferior ao Lancamento ("+DtoC(SZY->ZY_DATA)+")!!!","Alerta")
				Return(.F.)
			EndIf

			// Trecho incluido em 12/09/2013 SI.13/0160 - SZY->ZY_DTVLD assume data conforme a seguinte regra: 
			// 00:00 hs ATÉ AS 16:00 hs -> DataBase
			// Após 16:00 hs Até 00:00 hs -> DataBase + 1 
						
			RecLock("SZY",.F.)
			SZY->ZY_VLDFIN	:= "1" //Validacao do Financeiro
			//Alteracao dia 18/05/09 analista Emerson Natali
			//Criado campo abaixo para registrar quando foi validado registro pelo responsavel
//			SZY->ZY_DTVLD	:= Iif(_HoraExec >= _cVerIni .And. _HoraExec <= _cVerFim, DDataBase , DDataBase + 1)
			SZY->ZY_DTVLD	:= Iif(_HoraExec >= _cVerIni .And. _HoraExec <= _cVerFim, Date() , Date() + 1)
			cDataSE5 := SZY->ZY_DTVLD
			MsUnLock()
			
			If !Empty(SZY->ZY_ITEM)
				SZY->(DbSkip())
				Loop
			EndIf
			
			If alltrim(SZY->ZY_ITEMC) $ _nCtaImp
				SZY->(DbSkip())
				Loop
			EndIf
			
			//Atualiza os campos de controle para Saldo
			_xArea	:= GetArea()
			DbSelectArea("SZK")
			DbSetOrder(4) // Nr Cartao
			If DbSeek(xFilial("SZK")+alltrim(SZK->ZK_NROCRT),.F.)
				RecLock("SZK",.F.)
				SZK->ZK_E_SLDPR -= SZY->ZY_VALOR //Saldo Prestacao de Contas, estou diminuindo para baixar o valor a prest.conta
				MsUnLock()
			EndIf
			
			//Volta Flag para Processo antes da Digitacao
			RecLock("SZK",.F.)
			SZK->ZK_DIGCONT := "N"
			MsUnLock()
			
			RestArea(_xArea)
			
			DbSelectArea("SZY")
			SZY->(DbSkip())
		EndDo
		
		//Gera SE5 Movimento a Receber
		//Estorno Financeiro
		
		If _nTotRat > 0
			
			Aadd(aMovPag,{"E5_DATA"		, cDataSE5					, Nil})
			Aadd(aMovPag,{"E5_MOEDA"		, "BC"						, Nil})
			Aadd(aMovPag,{"E5_VALOR"		,_nTotRat					, Nil})
			Aadd(aMovPag,{"E5_NATUREZ"	, "02090608"				, Nil})
			Aadd(aMovPag,{"E5_BANCO"		, "341"					, Nil})
			Aadd(aMovPag,{"E5_AGENCIA"	, "0350"					, Nil})
			Aadd(aMovPag,{"E5_CONTA"		, "74043-7"				, Nil})
			Aadd(aMovPag,{"E5_DOCUMEN"	, SZK->ZK_NROCRT 			, Nil})
			Aadd(aMovPag,{"E5_HISTOR	"	, "Prestacao de Contas" 	, Nil})
			Aadd(aMovPag,{"E5_XCARTAO"	, SZK->ZK_NROCRT			, Nil})
			Aadd(aMovPag,{"E5_RECPAG"	, "R"						, Nil})
			Aadd(aMovPag,{"E5_VENCTO"	, cDataSE5					, Nil})
			Aadd(aMovPag,{"E5_DTDIGIT"	, cDataSE5					, Nil})
			Aadd(aMovPag,{"E5_DTDISPO"	, cDataSE5					, Nil})
			Aadd(aMovPag,{"E5_TIPOLAN"	, "X"						, Nil})
			Aadd(aMovPag,{"E5_RECONC"	, "x"						, Nil})		
					
			C6A10SE5(aMovPag,4)
			
			/*
			RecLock("SE5",.T.)
			SE5->E5_FILIAL	:= xFilial("SE5")
			SE5->E5_DATA 	:= cDataSE5//DDataBase
			SE5->E5_MOEDA	:= "BC"
			SE5->E5_VALOR	:= _nTotRat
			SE5->E5_NATUREZ	:= "02090608" // "2.21.08"
			SE5->E5_BANCO	:= "341"
			SE5->E5_AGENCIA	:= "0350"
			SE5->E5_CONTA	:= "74043-7"
			SE5->E5_DOCUMEN	:= SZK->ZK_NROCRT
			SE5->E5_HISTOR	:= "Prestacao de Contas" //"Estorno Adiantamento Cartao"
			SE5->E5_XCARTAO	:= SZK->ZK_NROCRT
			SE5->E5_RECPAG	:= "R"
			SE5->E5_VENCTO	:= cDataSE5//DDataBase
			SE5->E5_DTDIGIT	:= cDataSE5//DDataBase
			SE5->E5_DTDISPO	:= cDataSE5//DDataBase
			SE5->E5_TIPOLAN	:= "X"
			SE5->E5_RECONC	:= "x"
			//	SE5->E5_XCOMPET	:= 	SZY->ZY_XCOMPET //PATRICIA 04/12/12
			MsUnLock()
			*/
		EndIf
		//Gera SE5 Movimento a Receber
		//Deposito
		
		If _nTotDep > 0
			Aadd(aMovPag,{"E5_DATA"		, cDataSE5					, Nil})
			Aadd(aMovPag,{"E5_MOEDA"		, "BC"						, Nil})
			Aadd(aMovPag,{"E5_VALOR"		,_nTotDep					, Nil})
			Aadd(aMovPag,{"E5_NATUREZ"	, "33080104"				, Nil})
			Aadd(aMovPag,{"E5_BANCO"		, "341"					, Nil})
			Aadd(aMovPag,{"E5_AGENCIA"	, "0350"					, Nil})
			Aadd(aMovPag,{"E5_CONTA"		, "74043-7"				, Nil})
			Aadd(aMovPag,{"E5_DOCUMEN"	, SZK->ZK_NROCRT 			, Nil})
			Aadd(aMovPag,{"E5_HISTOR	"	, "ACERTO MODULO CARTAO ITAU" 	, Nil})
			Aadd(aMovPag,{"E5_XCARTAO"	, SZK->ZK_NROCRT			, Nil})
			Aadd(aMovPag,{"E5_RECPAG"	, "R"						, Nil})
			Aadd(aMovPag,{"E5_VENCTO"	, cDataSE5					, Nil})
			Aadd(aMovPag,{"E5_DTDIGIT"	, cDataSE5					, Nil})
			Aadd(aMovPag,{"E5_DTDISPO"	, cDataSE5					, Nil})
			Aadd(aMovPag,{"E5_TIPOLAN"	, "X"						, Nil})
			Aadd(aMovPag,{"E5_RECONC"	, "x"						, Nil})		
					
			C6A10SE5(aMovPag,4)		
		
			/*
			RecLock("SE5",.T.)
			SE5->E5_FILIAL	:= xFilial("SE5")
			SE5->E5_DATA 	:= cDataSE5//DDataBase
			SE5->E5_MOEDA	:= "BC"
			SE5->E5_VALOR	:= _nTotDep
			SE5->E5_NATUREZ	:= "33080104" // "6.08.04"
			
			SE5->E5_BANCO	:= "341"
			SE5->E5_AGENCIA	:= "0350"
			SE5->E5_CONTA	:= "74043-7"
			SE5->E5_DOCUMEN	:= SZK->ZK_NROCRT
			SE5->E5_HISTOR	:= "ACERTO MODULO CARTAO ITAU"
			SE5->E5_XCARTAO	:= SZK->ZK_NROCRT
			SE5->E5_RECPAG	:= "R"
			SE5->E5_VENCTO	:= cDataSE5//DDataBase
			SE5->E5_DTDIGIT	:= cDataSE5//DDataBase
			SE5->E5_DTDISPO	:= cDataSE5//DDataBase
			SE5->E5_TIPOLAN	:= "X"
			SE5->E5_RECONC	:= "x"
			//	SE5->E5_XCOMPET	:= 	SZY->ZY_XCOMPET //PATRICIA 04/12/12
			MsUnLock()
			*/
		EndIf
		
		//*************************************************
		//Gera SE5 Movimento a Pagar
		//*************************************************
		For _nIx :=1 to Len(oGetDados2:aCols)
			If !Empty(oGetDados2:aCols[_nIx, 1]) //Se o registro estiver em branco
				If !oGetDados2:aCols[_nIx, 11] //Se nao estiver deletado               PATRICIA FONTANEZI
					Aadd(aMovPag,{"E5_DATA"		, cDataSE5					, Nil})
					Aadd(aMovPag,{"E5_MOEDA"		, "BC"						, Nil})
					Aadd(aMovPag,{"E5_VALOR"		,oGetDados2:aCols[_nIx, 7] - oGetDados2:aCols[_nIx, 8] , Nil})
					Aadd(aMovPag,{"E5_NATUREZ"	, oGetDados2:aCols[_nIx, 5]	, Nil})
					Aadd(aMovPag,{"E5_BANCO"		, "341"					, Nil})
					Aadd(aMovPag,{"E5_AGENCIA"	, "0350"					, Nil})
					Aadd(aMovPag,{"E5_CONTA"		, "74043-7"				, Nil})
					Aadd(aMovPag,{"E5_DOCUMEN"	, SZK->ZK_NROCRT 			, Nil})
					Aadd(aMovPag,{"E5_HISTOR	"	, oGetDados2:aCols[_nIx, 6]	, Nil})
					Aadd(aMovPag,{"E5_XCARTAO"	, SZK->ZK_NROCRT			, Nil})
					Aadd(aMovPag,{"E5_RECPAG"	, "P"						, Nil})
					Aadd(aMovPag,{"E5_VENCTO"	, cDataSE5					, Nil})
					Aadd(aMovPag,{"E5_DTDIGIT"	, cDataSE5					, Nil})
					Aadd(aMovPag,{"E5_DTDISPO"	, cDataSE5					, Nil})
					Aadd(aMovPag,{"E5_TIPOLAN"	, "X"						, Nil})
					Aadd(aMovPag,{"E5_RECONC"	, "x"						, Nil})
					Aadd(aMovPag,{"E5_XCOMPET"	, oGetDados2:aCols[_nIx, 9]	, Nil})	
							
					C6A10SE5(aMovPag,3)				
					
					/*
					RecLock("SE5",.T.)
					SE5->E5_FILIAL	:= xFilial("SE5")
					SE5->E5_DATA 	:= cDataSE5//DDataBase
					SE5->E5_MOEDA	:= "BC"
					SE5->E5_VALOR	:= oGetDados2:aCols[_nIx, 7] - oGetDados2:aCols[_nIx, 8]
					SE5->E5_NATUREZ	:= oGetDados2:aCols[_nIx, 5]
					SE5->E5_BANCO	:= "341"
					SE5->E5_AGENCIA	:= "0350"
					SE5->E5_CONTA	:= "74043-7"
					SE5->E5_DOCUMEN	:= SZK->ZK_NROCRT
					SE5->E5_HISTOR	:= oGetDados2:aCols[_nIx, 6]
					SE5->E5_XCARTAO	:= SZK->ZK_NROCRT
					SE5->E5_RECPAG	:= "P"
					SE5->E5_VENCTO	:= cDataSE5//DDataBase
					SE5->E5_DTDIGIT	:= cDataSE5//DDataBase
					SE5->E5_DTDISPO	:= cDataSE5//DDataBase
					SE5->E5_TIPOLAN	:= "X"
					SE5->E5_RECONC	:= "x"
					SE5->E5_XCOMPET	:= 	oGetDados2:aCols[_nIx, 9] //PATRICIA 04/12/12
					MsUnLock()
					*/
				EndIf
			EndIf
		Next
		//EndIf
		// EndIf			// COMENTADO EM 29/08/2013 SSI.13/0160
	EndIf
	
	//EndIf
	
EndIf

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fd_Entra   ³Autor ³ Eduardo Motta         ³ Data ³ 12.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna aCols e aHeader quando se foca a GETDADOS          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nE - Numero da GetDados.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fd_Entra(nE)
oFolder:SetOption(nE)
oFolder:Refresh()
return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fd_Sai     ³Autor ³ Eduardo Motta         ³ Data ³ 12.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Guarda aCols e aHeader quando se sai da GETDADOS           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nE - Numero da GetDados.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fd_Sai(nE)
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA11   ºAutor  ³Microsiga           º Data ³  06/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importacao de Extrato Bancario                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function C6A10IMP(cDirect,cDirectImp)
Local _cContabi	:= ""
Local aMovPag		:= {}

aDirect    := Directory(cDirect+"*.RET")

If Empty(adirect)
	MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
	Return
EndIf

For _nI := 1 to Len(adirect)
	FT_FUSE(cDirect+adirect[_nI,1])
	FT_FGOTOP()
	cBuffer 	:=	Alltrim(FT_FREADLN())
	
	If Substr(cBuffer,77,3) <> "341"
		alert("Arquivo nao Pertence ao Banco Itau!")
		Return
	EndIf
	
	If Len(cBuffer)< 200 .or. Len(cBuffer)> 200
		alert("Formato do arquivo Invalido!")
		Return
	EndIf
	/*|-----------------------------------------------|
	| Pula o primeiro registro                      |
	| Cabecalho                                     |
	|-----------------------------------------------|*/
	FT_FSKIP()
	ProcRegua(FT_FLASTREC())
	_lFirst := .T.
	
	Do While !FT_FEOF()
		IncProc("Processando Leitura do Arquivo Texto...")
		cBuffer 	:=	Alltrim(FT_FREADLN())
		_cID	    := Substr(cBuffer,001,1) // 0-Cabecalho; 1-Detalhes; 9-Rodape
		_cTpSaldo   := Substr(cBuffer,042,1) // 0-Saldo Anterior; 2-Saldo Atual
		_cCategoria := Substr(cBuffer,107,1) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 201 Deposito
		_cTipo   	:= Substr(cBuffer,107,3) // Utilizado para detectar codigo 114 para lancamentos dos cartoes
		_cHist		:= Right(Alltrim(Substr(cBuffer,050,25)),6) // Posicao para identificar o numero do cartao. 6 ultimas posicoes.
		/*		|--------------------------------------------------------------------|
		| Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
		|                      Rodape - 9 (_cID)                             |
		| registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
		|--------------------------------------------------------------------|*/
		
		If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "2" .or. _cTipo $ "213"   //"209"
			FT_FSKIP()
			Loop
			//		ElseIf _cTipo <> "114"
			//			FT_FSKIP()
			//			Loop
		EndIf
		
		_cAgencia	:=	Substr(cBuffer,018,04)
		_cConta  	:=	Substr(cBuffer,036,05)  //Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,36,06)
		_cDocument	:=	Substr(cBuffer,075,06) // Numero do Documento
		_cEmissao	:=	Substr(cBuffer,081,06)
		_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
		_cValor  	:=	Substr(cBuffer,087,18)
		
		_cSE5Histor	:= Substr(cBuffer,050,17)
		
		/*-------------------------------------------------------------------------------|
		| Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
		| EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
		|--------------------------------------------------------------------------------|*/
		cQuery := "SELECT COUNT(*) AS NREG "
		cQuery += "FROM "+RetSQLname('SE5')+" "
		cQuery += "WHERE D_E_L_E_T_ <> '*' "
		cQuery += "AND E5_XCARTAO = '"+_cHist+"' "
		cQuery += "AND E5_DOCUMEN = '"+_cDocument+"' "
		cQuery += "AND E5_DATA = '"+DTOS(_cData)+"' "
		cQuery += "AND E5_VALOR = "+Str(Val(_cValor)/100,12,2)+" "
		TcQuery cQuery New Alias "SE5PESQ"
		
		If SE5PESQ->NREG > 0
			FT_FSKIP()
			SE5PESQ->(DbCloseArea())
			Loop
		Else
			SE5PESQ->(DbCloseArea())
		EndIf
		
		If _cHist <> "000000"
			
			_aArea			:= GetArea()
			DbSelectArea("SA6")
			SA6->(DbSetOrder(1))
			If DbSeek(xFilial("SA6")+"3410350 74043-7")
				_cContabi	:= SA6->A6_CONTABI
				If Empty(_cContabi)
					msgbox("Conta Contabil Nao Preenchida No Cadastro De Bancos!!!","Aviso")
					Return(.F.)
				EndIf
			EndIf
			
			DbSelectArea("SZK")
			SZK->(DbSetOrder(4))
			If DbSeek(xFilial("SZK")+_cHist) //Procura por Cartao
				If SZK->ZK_STATUS =="I" //Inativo
					_nPosCart	:= ascan(_aCartaoInativo,_cHist )
					If _nPosCart == 0
						aadd(_aCartaoInativo,_cHist)
					EndIf
					FT_FSKIP()		//Se Cartao Inativo passa para o proximo registro
					Loop
				EndIf
				_cReduz		:= SZK->ZK_REDUZ
				_cContaC	:= Posicione("CT1",2,xFilial("CT1")+SZK->ZK_REDUZ,"CT1_CONTA")
				If Empty(_cReduz)
					msgbox("Conta Contabil Nao Preenchida No Cadastro De Contas Correntes!!!","Aviso")
					Return(.F.)
				EndIf
			Else
				FT_FSKIP()		//Se nao Encontrar o Cartao passa para o proximo registro
				Loop
			EndIf
			RestArea(_aArea)
					
			/*
			RecLock("SE5",.T.)
			SE5->E5_FILIAL	:= xFilial("SE5")
			SE5->E5_DATA 	:= _cData
			SE5->E5_MOEDA	:= "DE"
			SE5->E5_VALOR	:= val(_cValor)/100
		    SE5->E5_NATUREZ	:= "02090607" // "2.21.07"
			SE5->E5_BANCO	:= "341"
			SE5->E5_AGENCIA	:= "0350"
			SE5->E5_CONTA	:= "74043-7"
			SE5->E5_DOCUMEN	:= _cDocument
			SE5->E5_ITEMD	:= _cReduz		//Item Contabil		-	CTD
			SE5->E5_DEBITO	:= _cContaC		//Conta Contabil	- 	CT1
			SE5->E5_XCARTAO	:= _cHist
			
			SE5->E5_HISTOR	:= _cSE5Histor
			
			SE5->E5_RECPAG	:= "P"
			SE5->E5_VENCTO	:= _cData
			SE5->E5_DTDIGIT	:= _cData
			SE5->E5_DTDISPO	:= _cData
			SE5->E5_TIPOLAN	:= "X"
			SE5->E5_RECONC	:= "x"
			MsUnLock()
			*/
			
			Aadd(aMovPag,{"E5_DATA"		, _cData					, Nil})
			Aadd(aMovPag,{"E5_MOEDA"		, "DE"						, Nil})
			Aadd(aMovPag,{"E5_VALOR"		, val(_cValor)/100	   	, Nil})
			Aadd(aMovPag,{"E5_NATUREZ"	, "02090607"				, Nil})
			Aadd(aMovPag,{"E5_BANCO"		, "341"					, Nil})
			Aadd(aMovPag,{"E5_AGENCIA"	, "0350"					, Nil})
			Aadd(aMovPag,{"E5_CONTA"		, "74043-7"				, Nil})
			Aadd(aMovPag,{"E5_DOCUMEN"	, _cDocument 				, Nil})
			Aadd(aMovPag,{"E5_ITEMD"		, _cReduz					, Nil})
			Aadd(aMovPag,{"E5_DEBITO"	, _cContaC					, Nil})			
			Aadd(aMovPag,{"E5_HISTOR	"	, _cSE5Histor				, Nil})
			Aadd(aMovPag,{"E5_XCARTAO"	, _cHist					, Nil})
			Aadd(aMovPag,{"E5_RECPAG"	, "P"						, Nil})
			Aadd(aMovPag,{"E5_VENCTO"	, _cData					, Nil})
			Aadd(aMovPag,{"E5_DTDIGIT"	, _cData					, Nil})
			Aadd(aMovPag,{"E5_DTDISPO"	, _cData					, Nil})
			Aadd(aMovPag,{"E5_TIPOLAN"	, "X"						, Nil})
			Aadd(aMovPag,{"E5_RECONC"	, "x"						, Nil})	
					
			IF C6A10SE5(aMovPag,3)			
				DbSelectArea("SZK")
				DbSetOrder(4) // N Cartao
				If DbSeek(xFilial("SZK")+_cHist,.F.)
					RecLock("SZK",.F.)
					SZK->ZK_E_SLDPR += val(_cValor)/100 //Saldo Prestacao de Contas
					SZK->ZK_E_SLDAT -= val(_cValor)/100 //Disponivel para Saque
					MsUnLock()
				EndIf
			EndIf
			
			// Alterado para lançamento padrão de movimento bancário
			/*
			//*************************************************
			//Contabiliza Lancamento Cartao
			//*************************************************			
			aCab		:= {}
			aItem		:= {}
			aTotItem	:=	{}
			lMsErroAuto := .f.
			
			aCab := {	{"dDataLanc", _cData	,NIL},;
			{"cLote"	, "009800"	,NIL},;
			{"cSubLote"	, "001"		,NIL}}
			
			//Alterado dia 18/05/09 - analista Emerson Natali
			//Acrescentado nome do colaborador
			_cColabor    := Substr(Posicione("SZK",4,xFilial("SZK")+alltrim(_cHist),"SZK->ZK_NOME"),1,30)
			_cCodFor     := Posicione("SZK",4,xFilial("SZK")+alltrim(_cHist),"SZK->ZK_FORNECE")

			AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")													, NIL},;
			{"CT2_LINHA"	, "001"																, NIL},;
			{"CT2_DC"		, "3"	 															, NIL},;	//Partida Dobrada
			{"CT2_ITEMD"	, _cReduz															, NIL},;	//SE5
			{"CT2_ITEMC"	, _cContabi															, NIL},;	//SA6-BANCO
			{"CT2_VALOR"	, val(_cValor)/100													, NIL},;
			{"CT2_HP"		, ""																, NIL},;
			{"CT2_HIST"		, "Movimento Cartao Empresa - "+Alltrim(_cHist)+" "+_cColabor		, NIL},;
			{"CT2_TPSALD"	, "9"																, NIL},;
			{"CT2_ORIGEM"	, "FFC SAQUE "+_cHist+" "+_cColabor									, NIL},;
			{"CT2_MOEDLC"	, "01"																, NIL},;
			{"CT2_EMPORI"	, ""																, NIL},;
			{"CT2_ROTINA"	, ""																, NIL},;
			{"CT2_LP"		, ""																, NIL},;
			{"CT2_XKEY"		, "DE"+_cCodFor+DTOS(_cData)+_cHist+_cColabor						, NIL},;
			{"CT2_KEY"		, ""																, NIL}})
			
			aadd(aTotItem,aItem)
			MSExecAuto({|a,b,C| Ctba102(a,b,C)},aCab,aItem,3)
			aTotItem	:=	{}
			
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				Return .F.
			Endif
			
			aCab	:= {}
			aItem	:= {}
			
			//*************************************************
			//FIM Contabiliza Lancamento Cartao
			//*************************************************
			*/			
		EndIf
		
		FT_FSKIP()
	EndDo
	FT_FUSE()
Next

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
	ferase(cDirect+adirect[_nI,1])
Next

MsgInfo("Importacao Finalizada com Sucesso!!!")

Return
/*------------------------------------------------------------------------
*
* C6A10SE5()
* Gera movimento bancário. 
*
------------------------------------------------------------------------*/
static function C6A10SE5(aMovPag,nOpcMov) 
lOCAL lRet				:= .t.
Private lMsErroAuto	:= .F.

Begin Transaction

	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aMovPag,nOpcMov)
	
	If lMsErroAuto  
		If __lSX8
			RollBackSX8()
		Endif
		lRet:= .f.
		MostraErro()
		
		DisarmTransaction()
		Break
	ELSE
		If __lSX8
			ConfirmSX8()
		Endif
	EndIf
End Transaction	
	
return lRet
/*------------------------------------------------------------------------
*
* CFINATOK()
* Validação tudook
*
------------------------------------------------------------------------*/
User Function CFINATOK()
/*
_lRet := .T.

If u_CFINALOK() //Linha do GetDados2
_lRet := .T.
Else
_lRet := .F.
EndIf

If _nValTotDeb <> _nValTotCred
_lRet := .F.
msgbox("Os valores de Debito e Credito nao batem. Verifique!!!", "Alerta")
Return(_lRet)
EndIf

*/
Local _lRet 	:= .T.
Local _aErro    := {}
Local _nY

_nValTotDeb		:= 0
_nValTotCre		:= 0
_nValTotRea		:= 0
_nValTotEnc		:= 0
_nValEncarg		:= 0
_nValPrest		:= 0
_nSaldo			:= SZK->ZK_E_SLDPR

AADD(_aErro,{.F.,"Para Contas Do Grupo 3 e 4 É Obrigatório O Centro De Custo"})                 // 1
AADD(_aErro,{.F.,"Para Contas Do Grupo 1 e 2 Nao É Permitido Centro De Custo"})                 // 2
AADD(_aErro,{.F.,"Nao É Permitido Conta Contabil Ou Natureza Em Branco"})						// 3
AADD(_aErro,{.F.,"Nao É Permitido Conta Contabil Em Branco"})									// 4
AADD(_aErro,{.F.,"A Valor Total Prestado Contas R$ "+Alltrim(TRANSFORM(_nValPrest,'@E 999,999.99'))+ chr(10)+chr(13)+;
"É Maior Que O Saldo De Prestacao De Contas R$ "+Alltrim(TRANSFORM(_nSaldo,'@E 999,999.99'))})			// 5
// Linha incluída em 29/08/2013 - SSI. 13/0160 - Erro quando não houver código de Natureza válido
AADD(_aErro,{.F.,"Nao É Permitido Conta Contabil Ou Natureza Em Branco! "+CRLF+"Entre em contato com a TESOURARIA!" })		// 6

For _nII :=1 to Len(oGetDados2:aCols)
	If !oGetDados2:aCols[_nII, 11] //Se nao estiver deletado        PATRICIA FONTANEZI
		
		If !Empty(Alltrim(oGetDados2:aCols[_nII, 1]))
			//Item Contabil grupo 3 e 4 obrigatorio Centro de Custo	DEBITO
			If Substr(oGetDados2:aCols[_nII, 1],1,1) == "3" .or. Substr(oGetDados2:aCols[_nII, 1],1,1) == "4"
				If Empty(oGetDados2:aCols[_nII, 2]) //Centro de Custo
					_lRet := .F.
					_aErro[1][1] := .T.
					//msgbox("Para contas do grupo 3 e 4 é obrigatório o Centro de Custo", "Alerta")
				EndIf
			ElseIf Substr(oGetDados2:aCols[_nII, 1],1,1) == "1" .or. Substr(oGetDados2:aCols[_nII, 1],1,1) == "2"
				If !Empty(oGetDados2:aCols[_nII, 2]) //Centro de Custo
					_lRet := .F.
					_aErro[2][1] := .T.
					//msgbox("Para contas do grupo 1 e 2 nao é permitido Centro de Custo", "Alerta")
				EndIf
			EndIf
			
			// If Alltrim(cUserName) $ GetMV("CI_USEPRES")		// comentado em 29/08/2013 SSI.13/0160 - parâmetro não mais utilizado
			// If Empty(oGetDados2:aCols[_nII, 1]) .or. Empty(oGetDados2:aCols[_nII, 5])		// comentado em 29/08/2013 SSI.13/0160
			If Empty(oGetDados2:aCols[_nII, 5])		// incluído em 29/08/2013 SSI.13/0160
				_lRet := .F.
				//_aErro[3][1] := .T.				// comentado em 29/08/2013 SSI.13/0160
				_aErro[6][1] := .T.					// incluído em 29/08/2013 SSI.13/0160
				//msgbox("Nao é permitido Contao Contabil ou Natureza em Branco", "Alerta")
			EndIf
			// Else					// comentado em 29/08/2013 SSI.13/0160
			If Empty(oGetDados2:aCols[_nII, 1])
				_lRet := .F.
				_aErro[4][1] := .T.
				//msgbox("Nao é permitido Conta Contabil em Branco", "Alerta")
			EndIf
			// EndIf				// comentado em 29/08/2013 SSI.13/0160
		Else
			//Item Contabil grupo 3 e 4 obrigatorio Centro de Custo	CREDITO
			If Substr(oGetDados2:aCols[_nII, 3],1,1) == "3" .or. Substr(oGetDados2:aCols[_nII, 3],1,1) == "4"
				If Empty(oGetDados2:aCols[_nII, 4]) //Centro de Custo
					_lRet := .F.
					_aErro[1][1] := .T.
					//msgbox("Para contas do grupo 3 e 4 é obrigatório o Centro de Custo", "Alerta")
				EndIf
			ElseIf Substr(oGetDados2:aCols[_nII, 3],1,1) == "1" .or. Substr(oGetDados2:aCols[_nII, 3],1,1) == "2"
				If !Empty(oGetDados2:aCols[_nII, 4]) //Centro de Custo
					_lRet := .F.
					_aErro[2][1] := .T.
					//msgbox("Para contas do grupo 1 e 2 nao é permitido Centro de Custo", "Alerta")
				EndIf
			EndIf
			
			/*/ Trecho comentado em 29/08/2013 SSI.13/0160
			//If Alltrim(cUserName) $ GetMV("CI_USEPRES")
			//If Empty(oGetDados2:aCols[_nII, 3])// .or. Empty(oGetDados2:aCols[_nII, 5])
			_lRet := .F.
			_aErro[4][1] := .T.
			//msgbox("Nao é permitido Contao Contabil ou Natureza em Branco", "Alerta")
			//EndIf
			//Else	*/
			If Empty(oGetDados2:aCols[_nII, 3])
				_lRet := .F.
				_aErro[4][1] := .T.
				//msgbox("Nao é permitido Conta Contabil em Branco", "Alerta")
			EndIf
			// EndIf			// comentado em 29/08/2013 SSI.13/0160
		EndIf
		
		If !Empty(oGetDados2:aCols[_nII, 1]) //ZY_ITEM
			_nValTotDeb += oGetDados2:aCols[_nII, 7]
		ElseIf !Empty(oGetDados2:aCols[_nII, 3])	//ZY_ITEMC
			_nValTotCre += oGetDados2:aCols[_nII, 7]
		EndIf
		/*
		If _nValTotDeb > _nSaldo
		_nValTotDeb -= oGetDados2:aCols[_nII, 8]
		EndIf
		*/
		If !Empty(oGetDados2:aCols[_nII, 8]) //ZY_ENCARGO
			_nValEncarg += oGetDados2:aCols[_nII, 8]
		EndIf
		
		If alltrim(oGetDados2:aCols[_nII][3]) $ _nCtaImp
			_nValTotEnc += oGetDados2:aCols[_nII, 7]
		EndIf
		
		_nValTotRea += iif(alltrim(oGetDados2:aCols[_nII][3])$_nCtaImp,oGetDados2:aCols[_nII][7],0)
		
	EndIf
	
Next

_nTotDepD	:= 0 //Debito
_nTotDepC	:= 0 //Credito
For _nXX :=1 to Len(oGetDados2:aCols)
	If !oGetDados2:aCols[_nXX, 11] //Se nao estiver deletado       PATRICIA FONTANEZI
		If !Empty(Alltrim(oGetDados2:aCols[_nXX, 1])) .and. alltrim(oGetDados2:aCols[_nXX, 5]) == "33080104" // "6.08.04"
		//If !Empty(Alltrim(oGetDados2:aCols[_nXX, 1])) .and. alltrim(oGetDados2:aCols[_nXX, 5]) == "6.08.04"
			_nTotDepD += oGetDados2:aCols[_nXX, 7]
		ElseIf !Empty(Alltrim(oGetDados2:aCols[_nXX, 3])) .and. alltrim(oGetDados2:aCols[_nXX, 5]) == "33080104" // "6.08.04"
		//ElseIf !Empty(Alltrim(oGetDados2:aCols[_nXX, 3])) .and. alltrim(oGetDados2:aCols[_nXX, 5]) == "6.08.04"
			_nTotDepC += oGetDados2:aCols[_nXX, 7]
		EndIf
	EndIf
	//Patricia Fontanezi - Validade no campo de competencia
	IF Substr(alltrim(oGetDados2:aCols[_nXX, 5]),1,4) $ "0401|0402" .AND. EMPTY(oGetDados2:aCols[_nXX, 9]) // "6.10|6.11" .AND. EMPTY(oGetDados2:aCols[_nXX, 9])
	//IF Substr(alltrim(oGetDados2:aCols[_nXX, 5]),1,4) $ "6.10|6.11" .AND. EMPTY(oGetDados2:aCols[_nXX, 9])
		MSGINFO("É obrigatório o preenchimento da data de Competência")
		_lRet := .F.
	ENDIF
	
Next _nXX

If _nTotDepD <> _nTotDepC
	_lRet := .F.
	msgbox(OemToAnsi("O Total dos lançamentos da natureza 33080104 não batem!!!"), "Alerta") // 6.08.04 não batem!!!"), "Alerta")
	//msgbox(OemToAnsi("O Total dos lançamentos da natureza 6.08.04 não batem!!!"), "Alerta")
EndIf

//If _nValTotDeb > _nSaldo .or. (_nValTotCred-_nValEncarg) > _nSaldo
If (_nValTotCred-_nValEncarg) > _nSaldo
	_lRet := .F.
	_aErro[5][1] := .T.
	//msgbox("A soma Total dos Rateios informados é maior que o Saldo de Prestacao de Contas", "Alerta")
EndIf

If _nValTotEnc <> _nValEncarg
	_lRet := .F.
	msgbox("O Total Dos Encargos R$ "+Alltrim(TRANSFORM(_nValEncarg,'@E 999,999.99'))+" Não Confere Com Os Encargos Classificados R$ "+Alltrim(TRANSFORM(_nValTotEnc,'@E 999,999.99')), "Alerta")
EndIf

If _nValTotDeb <> _nValTotCred
	_lRet := .F.
	msgbox("Debito E Credito Nao Estao Batidos!!!", "Alerta")
EndIf

_nValPrest := (_nValTotCred-_nValEncarg)

If !_lRet
	If !Empty(_aErro)
		For _nY := 1 to Len(_aErro)
			If _aErro[_nY][1]
				if _nY == 5
					_aErro[_nY][2] := "A Valor Total Prestado Contas R$ "+Alltrim(TRANSFORM(_nValPrest,'@E 999,999.99'))+ chr(10)+chr(13)+;
					"É Maior Que O Saldo De Prestacao De Contas R$ "+Alltrim(TRANSFORM(_nSaldo,'@E 999,999.99'))
				EndIf
				msgbox(_aErro[_nY][2], "Alerta")
			EndIf
		Next _nY
	EndIf
EndIf

_nValTotRea := (_nValTotCred-(_nValTotRea))

onSaldoD:Refresh()
onSaldoC:Refresh()
onSaldoR:Refresh()

Return(_lRet)
/*------------------------------------------------------------------------
*
* CFINALOK()
* Validação linhaok
*
------------------------------------------------------------------------*/
User Function CFINALOK()

Local _lRet 	:= .T.

_nValTotDeb		:= 0
_nValTotCre		:= 0
_nValTotRea		:= 0
_nSaldo			:= SZK->ZK_E_SLDPR

For _nII :=1 to Len(oGetDados2:aCols)
	If !oGetDados2:aCols[_nII, 11] //Se nao estiver deletado
		
		If !Empty(Alltrim(oGetDados2:aCols[_nII, 1]))
			//Item Contabil grupo 3 e 4 obrigatorio Centro de Custo	DEBITO
			If Substr(oGetDados2:aCols[_nII, 1],1,1) == "3" .or. Substr(oGetDados2:aCols[_nII, 1],1,1) == "4"
				If Empty(oGetDados2:aCols[_nII, 2]) //Centro de Custo
					
					If oGetDados2:nAT == _nII
						_lRet := .F.
						msgbox("Para Contas Do Grupo 3 e 4 É Obrigatório O Centro De Custo", "Alerta")
					Else
						_lRet := .T.
					EndIf
					
					Return(_lRet)
				EndIf
			ElseIf Substr(oGetDados2:aCols[_nII, 1],1,1) == "1" .or. Substr(oGetDados2:aCols[_nII, 1],1,1) == "2"
				If !Empty(oGetDados2:aCols[_nII, 2]) //Centro de Custo
					
					If oGetDados2:nAT == _nII
						_lRet := .F.
						msgbox("Para Contas Do Grupo 1 e 2 Nao É Permitido Centro De Custo", "Alerta")
					Else
						_lRet := .T.
					EndIf
					
					Return(_lRet)
				EndIf
			EndIf
			
			// If Alltrim(cUserName) $ GetMV("CI_USEPRES")			// COMENTADO EM 29/08/13 SSI.13/0160
			// If Empty(oGetDados2:aCols[_nII, 1]) .or. Empty(oGetDados2:aCols[_nII, 5])			// COMENTADO EM 29/08/13 SSI.13/0160
			If Empty(oGetDados2:aCols[_nII, 5])			// COMENTADO EM 29/08/13 SSI.13/0160
				
				If oGetDados2:nAT == _nII
					_lRet := .F.
					msgbox("Nao É Permitido Natureza Em Branco! Entre em contato com a TESOURARIA! ", "Alerta")
				Else
					_lRet := .T.
				EndIf
				
				Return(_lRet)
			EndIf
			// Else			// COMENTADO EM 29/08/13 SSI.13/0160
			
			If Empty(oGetDados2:aCols[_nII, 1])
				
				If oGetDados2:nAT == _nII
					_lRet := .F.
					msgbox("Nao É Permitido Conta Contabil Em Branco", "Alerta")
				Else
					_lRet := .T.
				EndIf
				Return(_lRet)
			EndIf
			// EndIf			// COMENTADO EM 29/08/13 SSI.13/0160
		Else
			//Item Contabil grupo 3 e 4 obrigatorio Centro de Custo	CREDITO
			If Substr(oGetDados2:aCols[_nII, 3],1,1) == "3" .or. Substr(oGetDados2:aCols[_nII, 3],1,1) == "4"
				If Empty(oGetDados2:aCols[_nII, 4]) //Centro de Custo
					
					If oGetDados2:nAT == _nII
						_lRet := .F.
						msgbox("Para Contas Do Grupo 3 e 4 É Obrigatório O Centro De Custo", "Alerta")
					Else
						_lRet := .T.
					EndIf
					
					Return(_lRet)
				EndIf
			ElseIf Substr(oGetDados2:aCols[_nII, 3],1,1) == "1" .or. Substr(oGetDados2:aCols[_nII, 3],1,1) == "2"
				If !Empty(oGetDados2:aCols[_nII, 4]) //Centro de Custo
					
					If oGetDados2:nAT == _nII
						_lRet := .F.
						msgbox("Para Contas Do Grupo 1 e 2 Nao É Permitido Centro De Custo", "Alerta")
					Else
						_lRet := .T.
					EndIf
					
					Return(_lRet)
				EndIf
			EndIf
			
			// Conta de Crédito que faz parte do parametro CI_CTAFCC
			If AllTrim(oGetDados2:aCols[_nII, 3]) $ _nCtaImp
				If oGetDados2:aCols[_nII, 8]>0 //Valor de encargos > 0
					
					If oGetDados2:nAT == _nII
						_lRet := .F.
						msgbox("Valores de Encargos só podem ser lançados nas Contas relacionadas à Despesa (Débito)", "Alerta")
					Else
						_lRet := .T.
					EndIf
					
					Return(_lRet)
				EndIf
			EndIf
			
			/*/ Trecho comentado em EM 29/08/13 SSI.13/0160
			//If Alltrim(cUserName) $ GetMV("CI_USEPRES")
			//	If Empty(oGetDados2:aCols[_nII, 3])// .or. Empty(oGetDados2:aCols[_nII, 5])
			
			//	If oGetDados2:nAT == _nII
			_lRet := .F.
			msgbox("Nao É Permitido Contao Contabil Em Branco", "Alerta")
			//msgbox("Nao é permitido Contao Contabil ou Natureza em Branco", "Alerta")
			//	Else
			_lRet := .T.
			//EndIf
			
			Return(_lRet)
			//EndIf
			//Else					// COMENTADO EM 29/08/13 SSI.13/0160   */
			If Empty(oGetDados2:aCols[_nII, 3])
				
				If oGetDados2:nAT == _nII
					_lRet := .F.
					msgbox("Nao É Permitido Conta Contabil Em Branco", "Alerta")
				Else
					_lRet := .T.
				EndIf
				
				Return(_lRet)
			EndIf
			// EndIf				// COMENTADO EM 29/08/13 SSI.13/0160
		EndIf
		
		If !Empty(oGetDados2:aCols[_nII, 1]) //ZY_ITEM
			_nValTotDeb += oGetDados2:aCols[_nII, 7]
		ElseIf !Empty(oGetDados2:aCols[_nII, 3])	//ZY_ITEMC
			_nValTotCre += oGetDados2:aCols[_nII, 7]
		EndIf
		/*
		//If _nValTotDeb > _nSaldo
		_nValTotDeb -= oGetDados2:aCols[_nII, 8]
		//EndIf
		*/
		//_nValTotRea += iif(alltrim(oGetDados2:aCols[_nII][1])$_nCtaImp,oGetDados2:aCols[_nII][7],0)
		_nValTotRea += iif(alltrim(oGetDados2:aCols[_nII][3])$_nCtaImp,oGetDados2:aCols[_nII][7],0)
		
		//If _nValTotDeb > _nSaldo .or. (_nValTotCred - _nValTotRea) > _nSaldo
		If (_nValTotCred - _nValTotRea) > _nSaldo
			If oGetDados2:nAT == _nII
				_lRet := .F.
				//msgbox("A Soma Parcial Dos Rateios Informados É Maior Que O Saldo De Prestacao De Contas", "Alerta")
				
				msgbox("A Soma Parcial Dos Rateios Informados R$ "+Alltrim(TRANSFORM((_nValTotCred - _nValTotRea),'@E 999,999.99'))+ chr(10)+chr(13)+;
				"É Maior Que O Saldo De Prestacao De Contas R$ "+Alltrim(TRANSFORM(_nSaldo,'@E 999,999.99')), "Alerta")
			Else
				_lRet := .T.
			EndIf
			Return(_lRet)
		EndIf
		// PATRICIA FONTANEZI - VALIDACAO PARA DIGITACAO DA COMPETENCIA
		//IF Substr(alltrim(oGetDados2:aCols[_nII, 5]),1,4) $ "0401|0402" .AND. EMPTY(oGetDados2:aCols[_nII, 9]) // "6.10|6.11" .AND. EMPTY(oGetDados2:aCols[_nII, 9])
		IF Substr(alltrim(oGetDados2:aCols[_nII, 5]),1,4) $ "6.10|6.11" .AND. EMPTY(oGetDados2:aCols[_nII, 9])
			MSGINFO("É obrigatório o preenchimento da data de Competência")
			_lRet := .F.
		ENDIF
		
	EndIf
	
Next

//If _nValTotDeb > _nSaldo .or. (_nValTotCred - _nValTotRea) > _nSaldo
If (_nValTotCred - _nValTotRea) > _nSaldo
	_lRet := .F.
	msgbox("A Valor Total Prestado Contas R$ "+Alltrim(TRANSFORM((_nValTotCred - _nValTotRea),'@E 999,999.99'))+ chr(10)+chr(13)+;
	"É Maior Que O Saldo De Prestacao De Contas R$ "+Alltrim(TRANSFORM(_nSaldo,'@E 999,999.99')), "Alerta")
	Return(_lRet)
EndIf

_nValTotRea := (_nValTotCred-(_nValTotRea))
//_nValTotRea := (_nValTotDeb-(_nValTotRea/2))

onSaldoD:Refresh()
onSaldoC:Refresh()
onSaldoR:Refresh()

Return(_lRet)
/*------------------------------------------------------------------------
*
* CFINAFOK()
* Validação de campo
*
------------------------------------------------------------------------*/
User Function CFINAFOK()

Local _lRet 	:= .T.
Local _nI		:= oGetDados2:nAt

If !oGetDados2:aCols[_nI,11]		// Não deletado
	
	If oGetDados2:oBrowse:nColPos == 8			// Coluna valor de encargos
		
		// Conta de Crédito que faz parte do parametro CI_CTAFCC
		If AllTrim(oGetDados2:aCols[_nI, 3]) $ _nCtaImp .And. M->ZY_ENCARGO>0 		//Valor de encargos > 0
			_lRet := .F.
			msgbox("Valores de Encargos só podem ser lançados nas Contas relacionadas à Despesa (Débito)", "Alerta")
			Return(_lRet)
		EndIf
	EndIf
EndIf

Return(_lRet)
/*------------------------------------------------------------------------
*
* C6A10Val()
* Validação
*
------------------------------------------------------------------------*/
User Function C6A10Val()

LOCAL nCont

_nValTotDeb := 0
_nValTotCre := 0
_nValTotRea := 0

oGetDados2:aCols[n][7] := &(ReadVar())

For nCont := 1 To Len(oGetDados2:aCols)
	If !oGetDados2:aCols[nCont][11]
		Do Case
			Case !Empty(oGetDados2:aCols[nCont][1])
				_nValTotDeb += oGetDados2:aCols[nCont][7]
			Case !Empty(oGetDados2:aCols[nCont][3])
				_nValTotCre += oGetDados2:aCols[nCont][7]
		EndCase
		//		_nValTotRea += iif(alltrim(oGetDados2:aCols[nCont][1])$_nCtaImp,oGetDados2:aCols[nCont][7],0)
		_nValTotRea += iif(alltrim(oGetDados2:aCols[nCont][3])$_nCtaImp,oGetDados2:aCols[nCont][7],0)
	EndIf
Next

_nValTotRea := (_nValTotCred-(_nValTotRea))
//_nValTotRea := (_nValTotDeb-(_nValTotRea/2))

If Type("onSaldoD")=="O" .or. Type("onSaldoC")=="O"
	onSaldoD:Refresh()
	onSaldoC:Refresh()
	onSaldoR:Refresh()
Endif

Return .t.
/*------------------------------------------------------------------------
*
* C6A10DEL()
* Validação no delete da linha
*
------------------------------------------------------------------------*/
User Function C6A10DEL()

LOCAL nCont

If oGetDados2:aCols[n][11]     //PATRICIA FONTANEZI
	If !Empty(oGetDados2:aCols[n][1])
		_nValTotDeb += oGetDados2:aCols[n][7]
	ElseIf !Empty(oGetDados2:aCols[n][3])
		_nValTotCre += oGetDados2:aCols[n][7]
	EndIf
Else
	If !Empty(oGetDados2:aCols[n][1])
		_nValTotDeb -= oGetDados2:aCols[n][7]
	ElseIf !Empty(oGetDados2:aCols[n][3])
		_nValTotCre -= oGetDados2:aCols[n][7]
	EndIf
EndIf

If Type("onSaldo")=="O" .or. Type("onSaldoC")=="O"
	onSaldoD:Refresh()
	onSaldoC:Refresh()
	onSaldoR:Refresh()
Endif

Return .t.
/*------------------------------------------------------------------------
*
* C6A10VOK()
* Validação de campo SX3 tabela SZY campos ZY_ITEM/ZY_CC/ZY_ITEMC/ZY_CCC
*
------------------------------------------------------------------------*/
User Function C6A10VOK(_nCampo)

//_nCampo (caracter)
//conteudo:
//1 - campos ZY_ITEM	/ ZY_CC
//2 - campos ZY_ITEMC	/ ZY_CCC

Local _lRet	:= .T.

If _nCampo == "1"
	If !Empty(alltrim(oGetDados2:aCols[n,3])) //ZY_ITEMC
		_lRet	:= .F.
	EndIf
Else
	If !Empty(alltrim(oGetDados2:aCols[n,1])) //ZY_ITEM
		_lRet	:= .F.
	EndIf
EndIf

Return(_lRet)                                                


//Aadd( aButtons, { "Entrada", { || U_C6A10DOC()  },"Documento Entrada","Documento Entrada"}) // A103NFiscal("SF1",0,3)   },"Documento Entrada","Documento Entrada"})

/*------------------------------------------------------------------------
*
* C6A10DOC()
* Documento de entrada
*
------------------------------------------------------------------------*/
User Function C6A10DOC()                                   
Local _aMat			:= {}

PRIVATE l103Auto	:= .F.
PRIVATE aAutoCab	:= {}
PRIVATE aAutoImp    := {}
PRIVATE aAutoItens 	:= {}

PRIVATE cCadastro	:= OemToAnsi("Documento de Entrada")
PRIVATE aBackSD1    := {}
PRIVATE aBackSDE    := {}
Private bBlockSev1         	      
Private bBlockSev2
Private aAutoAFN	:= {}  	  

                                                                             
// Clonar aRotina do CFINA10 para não conflitar com a aRotina do MATA103    

INCLUI := .T.
ALTERA := .F.

_aMat 	:= aClone(aRotina)
aRotina := MenuDef()                              
A103NFiscal("SF1",SF1->(RecNo()),3,.F.)
                     
// Retorna
aRotina := aClone(_aMat)

Return


Static Function MenuDef()
Local 	aRotina3  	:= {	{"Visualizar"			,"NfeDocVin",0,2,0,nil},;	
							{"Alterar"				,"NfeDocVin",0,4,0,nil},;	
							{"Excluir"				,"NFeDocVin",0,5,0,nil}}	

Local 	aRotina4  	:= {	{"Documento de Entrada"	,"NfeDocCob",0,4,0,nil},;	
							{"Documento de Saida"	,"NfsDocCob",0,4,0,nil}}	

Local 	aRotina2  	:= {	{"Vincular"				,aRotina3,0,4,0,nil},;		
							{"Cobertura"			,aRotina4,0,4,0,nil}}		

Local 	lGspInUseM 	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local 	lPyme      	:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)
Private aRotina		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa aRotina para ERP/CRM ou SIGAGSP                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRotina,	{OemToAnsi("Pesquisar")		, "AxPesqui"   , 0 , 1, 0, .F.}) 		
aAdd(aRotina,	{OemToAnsi("Visualizar")	, "A103NFiscal", 0 , 2, 0, nil}) 		
aAdd(aRotina,	{OemToAnsi("Incluir")		, "A103NFiscal", 0 , 3, 0, nil}) 		
aAdd(aRotina,	{OemToAnsi("Classificar")	, "A103NFiscal", 0 , 4, 0, nil}) 		
If !lGspInUseM
	aAdd(aRotina,	{OemToAnsi("Retornar")	, "A103Devol"  , 0 , 3, 0, nil})	
Endif
aAdd(aRotina,	{OemToAnsi("Excluir")		, "A103NFiscal", 3 , 5, 0, nil})		
If !lGspInUseM
	aAdd(aRotina,	{OemToAnsi("Imprimir")	, "A103Impri"  , 0 , 4, 0, nil})	
Endif
aAdd(aRotina,	{OemToAnsi("Legenda")		, "A103Legenda", 0 , 2, 0, .F.})		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada do banco de conhecimento                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lPyme
	Aadd(aRotina,	{"Conhecimento","MsDocument", 0 , 4, 0, nil})	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao da rotina do documento vinculado                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aRotina,		{"Doc.Vinculado"   , aRotina2, 0, 4, 0, nil})		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno do saldo contido no Armazem de Transito              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRotina,		{OemToAnsi("Transito"), 'A103RetTrf' , 0 , 3, 0, nil})	

Return(aRotina)
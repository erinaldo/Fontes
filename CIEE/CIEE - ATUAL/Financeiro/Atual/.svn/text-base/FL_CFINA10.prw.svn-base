#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA10   บ Autor ณ Andy               บ Data ณ  26/05/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Classificaco da Natureza do SE2 Contas a Pagar             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINA10()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local   aArea := GetArea() 
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private aAcho := {}
Private aCpos := {}                        
lAltera:=.T.
aMemos := {}   

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SE2")
aHeader:={}

/*
While !Eof() .And. (x3_arquivo == "SE2")
//	IF X3USO(x3_usado).And. AllTrim(x3_campo)$"E2_NATUREZ/E2_MULTNAT/E2_NATDESC/E2_LD/E2_BANCO/E2_AGEFOR/E2_DVFOR/E2_CTAFOR" 
IF X3USO(x3_usado) //.And. AllTrim(x3_campo) 
		AADD(aAcho, AllTrim(x3_campo))
	Endif
	dbSkip()
EndDo
*/
AADD(aCpos,"E2_NATUREZ")   
AADD(aCpos,"E2_NATDESC") 
//AADD(aCpos,"E2_MULTNAT") 
AADD(aCpos,"E2_MULNATU") 
AADD(aCpos,"E2_LD") 
AADD(aCpos,"E2_BANCO") 
AADD(aCpos,"E2_AGEFOR") 
AADD(aCpos,"E2_DVFOR") 
AADD(aCpos,"E2_CTAFORLD")

AADD(aCpos,"E2_BCOBOR")
AADD(aCpos,"E2_AGBOR")
AADD(aCpos,"E2_CCBOR")
AADD(aCpos,"E2_MODELO")

AADD(aCpos,"E2_XCOMPET")

//AADD(aCpos,"E2_FLUXO")   

dbSelectArea("SE2")
dbSetOrder(1)

cCadastro := "Natureza de Contas a Pagar"
Private aCores    := {}
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"    , 0 , 1},;
				{"Visualizar" ,"U_NatVis"  , 0 , 2},;
				{"Natureza"   ,"U_Nature"   , 0 , 4},;
				{"Legenda"    ,"U_LegNat",0 , 4 }}

Aadd( aCores, { "ALLTRIM(E2_NATUREZ) == '9.99.99' "  											, "BR_VERDE"  	} )
Aadd( aCores, { "ALLTRIM(E2_NATUREZ) <> '9.99.99' .AND. EMPTY(E2_BANCO) .and. EMPTY(E2_LD) .and. EMPTY(E2_NUMAP) .AND. alltrim(E2_TIPO) <> 'FL'"		, "BR_AMARELO"	} )
Aadd( aCores, { "ALLTRIM(E2_NATUREZ) <> '9.99.99' .AND. EMPTY(E2_BCOBOR) .and. EMPTY(E2_NUMAP) .AND. alltrim(E2_TIPO) <> 'FL'"						, "BR_AZUL"		} )
Aadd( aCores, { "ALLTRIM(E2_NATUREZ) <> '9.99.99' .AND. ((alltrim(E2_TIPO) == 'FL') .OR. (!EMPTY(E2_BANCO) .OR. !EMPTY(E2_BCOBOR)) .OR. !EMPTY(E2_LD).OR. !EMPTY(E2_NUMAP)) "	, "BR_VERMELHO"			} )


//Aadd( aCores, { "ALLTRIM(E2_NATUREZ) <> '9.99.99' .AND. alltrim(E2_TIPO) == 'FL' .AND. ((!EMPTY(E2_BANCO) .OR. !EMPTY(E2_BCOBOR)) .OR. !EMPTY(E2_LD).OR. !EMPTY(E2_NUMAP)) "	, "BR_VERMELHO"			} )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a Filtragem                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SE2")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SE2",,,,,2, aCores)

Return               

User Function NatVis()                                              
 AxVisual('SE2',Recno(),2,aAcho,aCpos)
Return
                                                               	
User Function Nature()
	Local aBut050 := {}
	If !Empty(SE2->E2_BAIXA)
		Help(" ",1,"FA050BAIXA")
	Else
		aBut050 := u_F050BUT()
		AxAltera("SE2",Recno(),4,aAcho,aCpos,,,'ExecBlock("SE2SE5",.F.,.F.)',,,aBut050,,,)
	EndIf
Return

User Function SE2SE5()
_aArea:= GetArea()

If !Empty(M->E2_LD) .OR. !Empty(M->E2_BANCO)
	If Empty(M->E2_BCOBOR) .OR. Empty(M->E2_AGBOR) .OR. Empty(M->E2_CCBOR) .OR. Empty(M->E2_MODELO)
		MsgBox(OemToAnsi("Dados bancแrio do Bordero sใo obrigat๓rios!!!!"),"ALERTA")
		Return(.F.)
	EndIf
EndIf

dbSelectArea("SE5")
dbSetOrder(7)
If dbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA, .F.)
  While !EOF() .And. SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
	RecLock("SE5", .F.)
	  SE5->E5_NATUREZ := M->E2_NATUREZ
	msUnLock()
    dbSkip()
  EndDo
EndIf

If M->E2_MULNATU == "1"
	DbSelectArea("SEV")
	DbSetOrder(1)
	If !DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
		MsgBox(OemToAnsi("Multiplas naturezas nao informada!!!"),"ALERTA")
		Return(.F.)
	Else
	//Atualizar tabela de controle de FL
		If alltrim(M->E2_TIPO) == "FL" .and. ALLTRIM(SE2->E2_PEDIDO) == "X"
			_xAreaSE2 := GetArea()
			DbSelectArea("PAB")
			DbSetOrder(1)
			DbGotop()
			If DbSeek(xFilial("PAB")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
				Do While !EOF() .and. PAB->(PAB_FILIAL+PAB_PREFIX+PAB_NUM+PAB_PARCEL+PAB_TIPO+PAB_CLIFOR+PAB_LOJA) == SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
					RecLock("PAB",.F.)
					DbDelete()
					MsUnLock()
			    	PAB->(DbSkip())
				EndDo
			EndIf

			DbSelectArea("SEV")
			DbSetOrder(1)
			If DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
				Do While !EOF() .and. M->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+E2_TIPO+EV_CLIFOR+EV_LOJA)
					RecLock("PAB",.T.)
					PAB_FILIAL	:= xFilial("PAB")
					PAB_PREFIX	:= SEV->EV_PREFIXO
					PAB_NUM		:= SEV->EV_NUM
					PAB_PARCEL	:= SEV->EV_PARCELA
					PAB_TIPO	:= SEV->EV_TIPO
					PAB_CLIFOR	:= SEV->EV_CLIFOR
					PAB_LOJA	:= SEV->EV_LOJA
					PAB_VALOR	:= SEV->EV_VALOR
					PAB_NATUREZ	:= SEV->EV_NATUREZ
					PAB_PERC	:= SEV->EV_PERC
					PAB_RECPAG	:= SEV->EV_RECPAG
					MsUnLock()
					DbSelectArea("SEV")
					SEV->(DbSkip())
				EndDo
			EndIf
			RestArea(_xAreaSE2)
		EndIf
	EndIf

	If alltrim(M->E2_TIPO) == "FL"
		RecLock("SE2",.F.)
		SE2->E2_PEDIDO := ""
		MsUnLock()
	EndIf
Else
	DbSelectArea("SEV")
	DbSetOrder(1)
	If DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
		MsgBox(OemToAnsi("Multiplas naturezas ja informada!!!"),"ALERTA")
		Return(.F.)
	EndIf
EndIf

If Substr(Alltrim(M->E2_NATUREZ),1,4) $ "6.10|6.11"
	If Empty(M->E2_XCOMPET)
		MsgBox(OemToAnsi("Data da Compet๊ncia ้ obrigat๓rio!!!"),"ALERTA")
		Return(.F.)
	EndIf
EndIf

RestArea(_aArea)
Return(.T.)

User Function LegNat

_aLeg := {	{"BR_VERDE"		, "Natureza a Reclassificar"	},;
			{"BR_AMARELO"	, "Dados Bancarios Fornecedor Pendente"	},;
			{"BR_AZUL"		, "Banco Bordero Pendente"		},;
			{"BR_VERMELHO" 	, "Titulo Sem Pendencias"		}}
BrwLegenda(cCadastro, "Legenda", _aLeg)

Return
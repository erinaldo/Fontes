#INCLUDE "rwmake.ch"
#include "_FixSX.ch"
#include "TOPCONN.CH"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บ Autor ณ Andy               บ Data ณ  05/06/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Creditos Nao Identificados                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINA11()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cArq,cInd,cPerg
Local cString := "SZ8"
Local aStru
 
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private aPags := {}
Private _dPar01, _dPar02
Private _cSZ8Ban, _cSZ8Age, _cSZ8Con, _dSZ8Emi, _dSZ8Tip

_cSZ8Ban:=Space(03)
_cSZ8Age:=Space(05)
_cSZ8Con:=Space(10)
_cSZ8Tip:=Space(02)
_dSZ8Emi:=dDataBase
_cSZ8Cta:=Space(10)
dbSelectArea("SZ8")
dbSetOrder(1)

// AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3)
// AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk)
// AxDeleta(cAlias,nReg,nOpc,aAcho,cFunc)


cDelFunc  := "U_ALTSZ8()"
cCadastro := "CNI - Creditos Nao Identificados"
aCores    := {} 

aRotina   := { 	{"Pesquisar"  ,"AxPesqui"     , 0 , 1},;
				{"Visualizar"  ,"AxVisual"    , 0 , 2},;
				{"Incluir"     ,'AxInclui("SZ8",Recno(),3,,"U_SZ8Ini",,"U_SZ8TudOK()")' , 0 , 3},;
				{"Alterar"     ,"U_XALTSZ8"   , 0 , 4},;
				{"Excluir"     ,"U_DELSZ8"	  , 0 , 5},;
				{"Importar"    ,"U_SZ8_IMP"   , 0 , 6},;
				{"Baixar"      ,"U_SZ8_BAIXA" , 0 , 6},;
				{"Identificar" ,"U_SZ8_IDENT" , 0 , 7},;
				{"Imprimir"    ,"U_IMPREGIS"  , 0 , 8},;
				{"Fluxo"       ,"U_SZ8_FLUXO" , 0 , 9},;
				{"Ident.Depo." ,"U_IDENT_DEP" , 0 , 11},;
				{"Legenda"     ,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","Aberto"},{"BR_AZUL","Identificado"},{"BR_AMARELO","Irregularidade"},{"BR_VERMELHO","Conciliado"}})',0 , 10 }}
//				{"Alterar"     ,'AxAltera("SZ8",Recno(),4, , , , ,"U_ALTSZ8()")' , 0 , 4},;

Aadd( aCores, { " Empty(Z8_RDR) .AND. Empty(Z8_IDENT)										"	, "BR_VERDE" 	 	} )
Aadd( aCores, { " !Empty(Z8_IDENT) .AND. Empty(Z8_RDR)										"	, "BR_AZUL" 	 	} )
Aadd( aCores, { " Empty(Z8_IRRDR).AND. Z8_IR<>0												"	, "BR_AMARELO" 	 	} )
Aadd( aCores, { "(!Empty(Z8_RDR) .AND. !Empty(Z8_IRRDR) .AND. Z8_IR<>0).OR. !Empty(Z8_RDR)	"	, "BR_VERMELHO"		} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a Filtragem                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SZ8")
dbSetOrder(1)
/*bFiltraBrw := {|| Nil}
aIndSZ8    := {}
cCond      :=	"Z8_FILIAL <> 'XX'"
bFiltraBrw := {|| FilBrowse("SZ8",@aIndSZ8,@cCond)}
Eval(bFiltraBrw)    */

mBrowse( 6,1,22,75,"SZ8",,,,,2, aCores)   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  10/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZ8Ini()
Local  _aArea := GetArea()

/*-----------------------------------------------------------------------------------------------
Foi retirado a query abaixo pois apos migrarmos de Servidor o sistema apaga os deletados da base
e refaz o campo RECNO com isso estava gravando o numero de registros em duplicidade na base
-----
retirado pelo analista Emerson em 10/10/07
-------------------------------------------------------------------------------------------------*//*
cQuery := " SELECT COUNT(*) AS NREG"
cQuery += " FROM "+RetSQLname('SZ8')+" "
TcQuery cQuery New Alias "REGTMP"

If REGTMP->NREG > 0
	RecLock("SZ8", .F.)
	SZ8->Z8_REGISTR := Right(Str(Year(dDataBase)),2)+RIGHT(StrZero(SZ8->(RECNO()),15),13) //retirado devido a problema relatado acima.
	SZ8->(msUnLock())
EndIf

DbSelectArea("REGTMP")
DbCloseArea("REGTMP")
*/
DbSelectArea("SZ8")
// Estou supondo que a grava็ใo do recno do SZ8 estแ sendo feito por um ๚nico usuแrio
M->Z8_BANCO    := _cSZ8Ban
M->Z8_AGENCIA  := _cSZ8Age
M->Z8_CONTA    := _cSZ8Con
M->Z8_EMISSAO  := _dSZ8Emi
M->Z8_TIPO     := _cSZ8Tip
M->Z8_TIPO_D   := U_GETCPOVAL("Z9_TIPO_D",1,xFilial("SZ9")+_cSZ8Tip,.F.)
M->Z8_CCONT    := U_GETCPOVAL("A6_CONTABI",1,xFilial("SA6")+_cSZ8Ban+_cSZ8Age+_cSZ8Con,.F.)
RestArea(_aArea)          
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  10/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZ8TudOK()
Local  _aArea := GetArea()

/*
Pesquisa o ultimo registro gravado para incrementar um sequencial ao proximo
esta validacao anteriormente estava na funcao SZ8Ini()
Alterado dia 10/10/07 pelo analista emerson
*/

/*
//Alterado pelo analista Emerson dia 17/11/11.
//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
cQuery += "FROM "+RetSQLname('SZ8')+" "
cQuery += "ORDER BY Z8_REGISTR DESC "
TcQuery cQuery New Alias "REGTMP"

M->Z8_REGISTR := Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13)

DbSelectArea("REGTMP")
DbCloseArea("REGTMP")
*/

DbSelectarea("SZ8")
dbSetOrder(1)
If dbSeek(xFilial("SZ8")+M->Z8_BANCO+M->Z8_AGENCIA+M->Z8_CONTA+DTOS(M->Z8_EMISSAO), .F.)
    _cRet := If(SZ8->Z8_FECHA == "S",.F.,.T.)
Else	      
    _cRet:=.T.
EndIf
If !_cRet
	_cMsg := "Possui Registro ja Analisado da Mesma Conta e Data !!!"
	MsgAlert(_cMsg, "Aten็ใo")
Else
    _cSZ8Ban := M->Z8_BANCO
    _cSZ8Age := M->Z8_AGENCIA
    _cSZ8Con := M->Z8_CONTA
    _dSZ8Emi := M->Z8_EMISSAO
    _cSZ8Tip := M->Z8_TIPO
    _cSZ8Cta := M->Z8_CCONT                                                              
EndIf

RestArea(_aArea)
Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  10/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ALTSZ8()
Local  _aArea := GetArea()   
                       

_cRet := If(SZ8->Z8_FECHA == "S",.F.,.T.) //_cRet:=.T. // If(Empty(Z8_RDR),.T.,.F.)

IF _cRet 
	IF altera 
		IF SZ8->Z8_FILIAL == 'XX'
			MsgAlert("Usuแrio sem autoriza็ใo nesse Registro")
			_cRet	:= .F.   
		ENDIF
	ENDIF
ENDIF   

If !_cRet
	_cMsg := "Registro ja Analisado Nao pode ser Alterado, ou Excluido!!!"
	MsgAlert(_cMsg, "Aten็ใo")
EndIf    

RestArea(_aArea)
Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  10/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XALTSZ8()

Local aArea 	:= {}
Local aAreaSZ8 	:= {}
Local _cNaturez := ""

nFez := AxAltera("SZ8",Recno(),4, , , , ,"U_ALTSZ8()")

If nFez==1
	aArea 	:= GetArea()
	aAreaSZ8:= SZ8->(GetArea())

	dbSelectArea("SZF")
	SZF->(dbSetOrder(1))           //ZF_FILIAL+ZF_BANCO+ZF_AGENCIA+ZF_CONTA+DTOS(ZF_EMISSAO)+ZF_REGISTR
	If SZF->(dbSeek(xFilial("SZF")+SZ8->(Z8_BANCO+Z8_AGENCIA+Z8_CONTA+DTOS(Z8_EMISSAO)+Z8_REGISTR)))
		While SZF->(!Eof()).And.(xFilial("SZF")+SZF->(ZF_BANCO+ZF_AGENCIA+ZF_CONTA+DTOS(ZF_EMISSAO)+ZF_REGISTR))==;
		                        (xFilial("SZ8")+SZ8->(Z8_BANCO+Z8_AGENCIA+Z8_CONTA+DTOS(Z8_EMISSAO)+Z8_REGISTR))
		                        
			If Alltrim(SZ8->Z8_RMU)=="R" //Privada
				_cNaturez	:= "1.01.01"
			ElseIf Alltrim(SZ8->Z8_RMU)=="M" //Mista
				_cNaturez	:= "1.01.03"
			ElseIf Alltrim(SZ8->Z8_RMU)=="U" //Publica
				_cNaturez	:= "1.01.02"
			Else
				_cNaturez	:= ""
			EndIf
		                        
			RecLock("SZF", .F.)
			SZF->ZF_RMU		:= SZ8->Z8_RMU
			SZF->ZF_RDR     := SZ8->Z8_RDR
			SZF->ZF_NATUREZ	:= _cNaturez
			SZF->(msUnLock())
			SZF->(dbSkip())
		End
	EndIf
	RestArea(aAreaSZ8)
	RestArea(aArea)

EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBaixa_SZ8 บ Autor ณ Andy               บ Data ณ  28/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Preenche Z8_RDR ou Z8_RDRIR, no Programa CFINA11           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function SZ8_BAIXA()
Local aArea := GetArea() //, aPags := {}
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )
Private cPerg  := "FINA11    "
lRet        := .F.
aPags       := {}

_aPerg := {}
AADD(_aPerg,{cPerg,"01","Tipo               ?","","","mv_ch1","N",01,0,0,"C","","mv_par01","Lancamentos","","","","","Irregularidades","","","","","Outros","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","Conta de           ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"03","Conta ate          ?","","","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"04","Data de            ?","","","mv_ch4","D",08,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"05","Data ate           ?","","","mv_ch5","D",08,0,0,"G","","mv_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AjustaSX1(_aPerg)

If !Pergunte(cPerg, .T.)
	Return
EndIf

_xFilSZ8:= xFilial("SZ8")
_cOrdem := " Z8_FILIAL, Z8_CONTA, Z8_BANCO, Z8_AGENCIA, Z8_EMISSAO, Z8_VALOR"
_cQuery := " SELECT Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_EMISSAO, Z8_TIPO, Z8_DEPOS, Z8_VALOR, Z8_NDOC, Z8_NAGE, Z8_IDENT, Z8_BA, Z8_CI, Z8_RDR, Z8_IR, Z8_IRTIP, Z8_IRRDR, SZ8.R_E_C_N_O_ REGSZ8"
_cQuery += " FROM "

_cQuery += RetSqlName("SZ8")+" SZ8"
_cQuery += " WHERE '"+ _xFilSZ8 +"' = Z8_FILIAL"

_cQuery += " AND    Z8_CONTA   >= '"+mv_par02+"'"
_cQuery += " AND    Z8_CONTA   <= '"+mv_par03+"'"

_cQuery += " AND    Z8_EMISSAO >= '"+DTOS(mv_par04)+"'"
_cQuery += " AND    Z8_EMISSAO <= '"+DTOS(mv_par05)+"'"

If mv_par01 == 1 .Or. mv_par01 == 3
	_cQuery += " AND Z8_RDR = ' '"
ElseIf mv_par01 == 2
	_cQuery += " AND Z8_IR <> 0 AND Z8_IRRDR = ' '"
EndIf

U_EndQuery( @_cQuery,_cOrdem, "SZ8TMP", {"SZ8" },,,.T. )

dbSelectArea("SZ8TMP")
dbGoTop()

While !Eof()
	_cTipoDoc := LEFT(POSICIONE("SZ9",2,xFilial("SZ9")+SZ8TMP->Z8_TIPO,"Z9_TIPO_D"),15)
	_cAgencia := POSICIONE("SZA",1,xFilial("SZA")+SZ8TMP->Z8_NAGE,"ZA_NAGE_D")
	_cIdentif := LEFT(POSICIONE("SZB",1,xFilial("SZB")+SZ8TMP->Z8_IDENT,"ZB_IDENT_D"),10)
	
	aAdd(aPags,{.F.,SZ8TMP->Z8_EMISSAO,SZ8TMP->Z8_TIPO+" - "+_cTipoDoc,SZ8TMP->Z8_DEPOS,SZ8TMP->Z8_VALOR,SZ8TMP->Z8_NDOC,SZ8TMP->Z8_NAGE,_cAgencia,SZ8TMP->Z8_IDENT+" - "+_cIdentif,SZ8TMP->Z8_BA,SZ8TMP->Z8_CI,SZ8TMP->Z8_RDR,SZ8TMP->Z8_IR,SZ8TMP->Z8_IRTIP,SZ8TMP->Z8_IRRDR,SZ8TMP->REGSZ8})
	dbSelectArea("SZ8TMP")
	DbSkip()
Enddo

//                             "Data"            ,"Tipo/Documento"               ,"Depositante"     ,"Valor"                                           ,"Documento        ,"No."             ,"Agencia"         ,"Identificacao"                   ,"B.A."                                             ,"C.I."                                             ,"RDR"              ,"Irregularidade"                                   ,"Tipo Irreg."      ,"RDR Irreg."
// 1                           2                  3                               4                  5                                                  6                  7                  8                  9                                  10                                                  11                                                  12                  13                                                  14                  15
// .F.                        ,SZ8TMP->Z8_EMISSAO,SZ8TMP->Z8_TIPO+" - "+_cTipoDoc,SZ8TMP->Z8_DEPOS  ,SZ8TMP->Z8_VALOR                                  ,SZ8TMP->Z8_NDOC   ,SZ8TMP->Z8_NAGE   ,_cAgencia         ,SZ8TMP->Z8_IDENT+" - "+_cIdentif  ,SZ8TMP->Z8_BA                                      ,SZ8TMP->Z8_CI                                      ,SZ8TMP->Z8_RDR     ,SZ8TMP->Z8_IR                                      ,SZ8TMP->Z8_IRTIP   ,SZ8TMP->Z8_IRRDR   ,SZ8TMP->REGSZ8
// aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3]             ,aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9]                ,Transform(aPags[oLbx1:nAt,10],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,11],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,12],Transform(aPags[oLbx1:nAt,13],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,14],aPags[oLbx1:nAt,15]

dbSelectArea("SZ8TMP")
DbCloseArea()

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 300,778 TITLE "Escolha de qual movimento quer conciliar " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Data","Tipo/Documento","Depositante","Valor","Documento","No.","Agencia","Identificacao","B.A.","C.I.","RDR","Irregularidade","Tipo Irreg.","RDR Irreg." SIZE 345, 85 OF oDlg PIXEL ;
	ON DBLCLICK (U_MARKSZ8())
	
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3],aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9],Transform(aPags[oLbx1:nAt,10],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,11],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,12],Transform(aPags[oLbx1:nAt,13],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,14],aPags[oLbx1:nAt,15] } }
	oLbx1:nFreeze  := 1
	
	DEFINE SBUTTON FROM 94, 264 TYPE 17 ENABLE OF oDlg ACTION U_MarcaSZ8() //BUTT
	DEFINE SBUTTON FROM 94, 292 TYPE 11 ENABLE OF oDlg ACTION (U_RDRSZ8(mv_par01),lRet :=.F.,oDlg:End())
	DEFINE SBUTTON FROM 94, 320 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgInfo("Nใo Haverแ Baixa!","Aten็ใo")
Endif

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  06/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao de Extrato Bancario                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZ8_IMP()

Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )

cPerg	:= "SZ8IMP    "
aBanco	:= {}

aAdd(aBanco,{.F.,"001","Banco do Brasil"	})
aAdd(aBanco,{.F.,"237","Banco Bradesco"		})
aAdd(aBanco,{.F.,"341","Banco Itau"			})
aAdd(aBanco,{.F.,"356","ABN AMRO Real"		})
aAdd(aBanco,{.F.,"104","Caixa Economica"	})
aAdd(aBanco,{.F.,"033","Santander Banespa"	})

pergunte(cperg,.F.)

DEFINE MSDIALOG oDlg FROM  31,58 TO 300,500 TITLE "Qual Banco Deseja Importar o Extrato?" PIXEL
@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Banco","Nome" SIZE 215, 85 OF oDlg PIXEL ON DBLCLICK (U_MARKIMP())
	
oLbx1:SetArray(aBanco)
oLbx1:bLine := { || {If(aBanco[oLbx1:nAt,1],oOk,oNo),aBanco[oLbx1:nAt,2],aBanco[oLbx1:nAt,3] } }
oLbx1:nFreeze  := 1
	
DEFINE SBUTTON FROM 94, 150 TYPE 1  ENABLE OF oDlg ACTION Processa({||  U_ExecImp() },"Processando Registros...")
DEFINE SBUTTON FROM 94, 190 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End())
	
ACTIVATE MSDIALOG oDlg CENTERED

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  06/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao de Extrato Bancario                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ExecImp()

Private lInverte := .F.
Private cMarca

For _nI := 1 to Len(aBanco)
	If aBanco[_nI,1]
		oLbx1:nAt := _nI
	EndIf
Next _nI

Do Case
	Case aBanco[oLbx1:nAt,2] == "001" .and. aBanco[oLbx1:nAt,1]
		If cEmpant == '01' //SP
			cDirect    := "\arq_txt\tesouraria\Importacao\Banco do Brasil\"
			cDirectImp := "\arq_txt\tesouraria\Importacao\Banco do Brasil\Debito\"
		ElseIf cEmpant == '03' //RJ
			cDirect    := "\arq_txtrj\tesouraria\Importacao\Banco do Brasil\"
			cDirectImp := "\arq_txtrj\tesouraria\Importacao\Banco do Brasil\Debito\"
		EndIf
		aDirect    := Directory(cDirect+"*.RET")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	Alltrim(FT_FREADLN())

			If Substr(cBuffer,77,3) <> "001"
				alert("Arquivo nao Pertence ao Banco do Brasil!")
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
				_cID	    := Substr(cBuffer,001,01) // 0-Cabecalho; 1-Detalhes; 9-Rodape
				_cTpSaldo   := Substr(cBuffer,042,01) // 0-Saldo Anterior; 2-Saldo Atual
				_cCategoria := Substr(cBuffer,043,01) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 201 Deposito
				_cTpBlq		:= Substr(cBuffer,046,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
				_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco
			/*|--------------------------------------------------------------------|
			  | Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			  |                      Rodape - 9 (_cID)                             |
			  | registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			  |--------------------------------------------------------------------|*/
				If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "1" 
					FT_FSKIP()
					Loop
				EndIf

				If _cTpBlq == "0911" //Codigo para Lancamentos Bloqueados pelo Banco
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,018,04)
				_cConta  	:=	Substr(cBuffer,030,11)  // Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,30,12)
				_cTipo   	:=	Substr(cBuffer,043,03)
				_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,136,15)),30))  // CNPJ do Depositante
				_cDocument	:=	Substr(cBuffer,75,06)   // Numero do Documento 
				_cEmissao	:=	Substr(cBuffer,081,06)
				_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
				_cValor  	:=	Substr(cBuffer,087,18) 
				_dAntServ	:= DATE() - 1
			   
				
				// 07/03/2013 - Patricia Fontanezi
				IF _cTipo == "213" .AND. _cTpBlq == "0870"
					_cTipo	:= "45"
				ENDIF
															
			 	If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf    
				
			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "001"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "001"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13) //Alterado dia 10/10/07 pelo analista Emerson 
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()				
						ConfirmSX8()
					EndIf
				EndIf
				
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "237" .and. aBanco[oLbx1:nAt,1]
		If cEmpant == '01' //SP
			cDirect    := "\arq_txt\tesouraria\Importacao\Bradesco\" 
			cDirectImp := "\arq_txt\tesouraria\Importacao\Bradesco\Backup\"
		ElseIf cEmpant == '03' //RJ
			cDirect    := "\arq_txtrj\tesouraria\Importacao\Bradesco\" 
			cDirectImp := "\arq_txtrj\tesouraria\Importacao\Bradesco\Backup\"
		EndIf
		aDirect    := Directory(cDirect+"*.RET")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	Alltrim(FT_FREADLN())

			If Substr(cBuffer,77,3) <> "237"
				alert("Arquivo nao Pertence ao Banco Bradesco!")
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
				_cCategoria := Substr(cBuffer,043,1) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 201 Deposito
				_cTipo   	:= Substr(cBuffer,043,3) // Pula Tipo 213 - Transferencia entre CC - Realizado via Movimento Bancario
				_cTpBlq		:= Substr(cBuffer,046,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
				_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco
			/*|--------------------------------------------------------------------|
			  | Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			  |                      Rodape - 9 (_cID)                             |
			  | registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			  |--------------------------------------------------------------------|*/
				If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "1" .or. _cTipo $ "213|205|206"
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,018,04)
				_cConta  	:=	Substr(cBuffer,030,11)  //Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,30,12)
				_cTipo   	:=	Substr(cBuffer,043,03)
				_cDocument	:=	Substr(cBuffer,151,07) // Numero do Documento
				If _cTipo == "214" //Deposito Identificado (dinheiro/ cheque)
					_cNAGE		:= 	Substr(cBuffer,154,04) // Numero da Agencia Colhedora
					_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,106,32)),30)) // Depositante
				Else
					_cNAGE		:= 	""
					_cDeposit	:=	Substr(cBuffer,106,32) // Depositante
				EndIf
				_cEmissao	:=	Substr(cBuffer,081,06)
				_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
				_cValor  	:=	Substr(cBuffer,087,18) 
				_dAntServ	:= DATE() - 1  				
				
				// 07/03/2013 - Patricia Fontanezi
				IF _cTipo == "209" .AND. _cTpBlq == "0051"
					_cTipo	:= "77"
				ENDIF
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf    

			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao
				
				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "237"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "237"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_NAGE    := _cNAGE
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13) //Alterado dia 10/10/07 pelo analista Emerson 
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()				
					EndIf
				EndIf
					
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "341" .and. aBanco[oLbx1:nAt,1]
		If cEmpant == '01' //SP
			cDirect    := "\arq_txt\tesouraria\Importacao\Itau\" 
			cDirectImp := "\arq_txt\tesouraria\Importacao\Itau\Cartao\"
		ElseIf cEmpant == '03' //RJ
			cDirect    := "\arq_txtrj\tesouraria\Importacao\Itau\" 
			cDirectImp := "\arq_txtrj\tesouraria\Importacao\Itau\Debito\"
		EndIf
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
				_cTipo   	:= Substr(cBuffer,107,3) // Pula Tipo 213 - Transferencia entre CC - Realizado via Movimento Bancario
				_cTpBlq		:= Substr(cBuffer,110,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
//				_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco
				_cHist		:= ""
			/*|--------------------------------------------------------------------|
			  | Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			  |                      Rodape - 9 (_cID)                             |
			  | registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			  |--------------------------------------------------------------------|*/
			  
				If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "1" .or. _cTipo $ "213"   //"209"
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,018,04)
				_cConta  	:=	Substr(cBuffer,036,05)  //Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,36,06)
				_cTipo   	:=	Substr(cBuffer,107,03)
				_cDocument	:=	Substr(cBuffer,161,04) // Numero do Documento
				_cNAGE		:= 	""
				_cDeposit	:=	Substr(cBuffer,050,25) // Depositante
				_cEmissao	:=	Substr(cBuffer,081,06)
				_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
				_cValor  	:=	Substr(cBuffer,087,18)
 				_dAntServ	:= DATE() - 1
				
				// 07/03/2013 - Patricia Fontanezi
				IF _cTipo == "202" .AND. _cTpBlq == "0038"
					_cTipo	:= "22"
				ENDIF
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf    
			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "341"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "341"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_NAGE    := _cNAGE
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13) //Alterado dia 10/10/07 pelo analista Emerson 
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()
					EndIf
				EndIf
					
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "356" .and. aBanco[oLbx1:nAt,1]

		If cEmpant == '01' //SP
			cDirect    := "\arq_txt\tesouraria\Importacao\Real ABN\" 
			cDirectImp := "\arq_txt\tesouraria\Importacao\Real ABN\Backup\"
		ElseIf cEmpant == '03' //RJ
			cDirect    := "\arq_txtrj\tesouraria\Importacao\Real ABN\" 
			cDirectImp := "\arq_txtrj\tesouraria\Importacao\Real ABN\Backup\"
		EndIf
		aDirect    := Directory(cDirect+"*.TXT")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	Alltrim(FT_FREADLN())

			If Substr(cBuffer,77,3) <> "356"
				alert("Arquivo nao Pertence ao Banco Real!")
				Return
			EndIf

			If Len(cBuffer)< 200 .or. Len(cBuffer)> 200
				alert("Formato do arquivo Invalido!")
				Return
			EndIf
		//|-----------------------------------------------|
		//| Pula o primeiro registro                      |
		//| Cabecalho                                     |
		//|-----------------------------------------------|
			FT_FSKIP()
			ProcRegua(FT_FLASTREC())
			_lFirst := .T.

			Do While !FT_FEOF()
				IncProc("Processando Leitura do Arquivo Texto...")
				cBuffer 	:=	Alltrim(FT_FREADLN())
				_cID	    := Substr(cBuffer,001,1) // 0-Cabecalho; 1-Detalhes; 9-Rodape
				_cTpSaldo   := Substr(cBuffer,042,1) // 0-Saldo Anterior; 2-Saldo Atual
				_cCategoria := Substr(cBuffer,105,1) // Definicao de Credito/ Debito. D-Debito, C-Credito.
				_cTipo   	:= Substr(cBuffer,043,3) // Pula Tipo 213 - Transferencia entre CC - Realizado via Movimento Bancario
//				_cTpBlq		:= Substr(cBuffer,046,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
				_cHist		:= ""
			//|--------------------------------------------------------------------|
			//| Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			//|                      Rodape - 9 (_cID)                             |
			//| registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			//|--------------------------------------------------------------------|
			  
				If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "D"
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,018,04)
				_cConta  	:=	Substr(cBuffer,023,06)  //OBS: Posicao completa seria Substr(cBuffer,22,07) Nao traz o digito.
				_cTipo   	:=	Substr(cBuffer,043,03)
				_cDocument	:=	Substr(cBuffer,075,06) // Numero do Documento
				_cNAGE		:= 	""
				_cHist		:= Substr(cBuffer,050,25)
				_cDeposit	:= ""
				_cEmissao	:=	Substr(cBuffer,081,06)
				_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
				_cValor  	:=	Substr(cBuffer,087,18)   
				_dAntServ	:= DATE() - 1
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf    

			//|--------------------------------------------------------------------------------|
			//| Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			//| EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			//|--------------------------------------------------------------------------------|
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "356"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "356"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_NAGE    := _cNAGE
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13) //Alterado dia 10/10/07 pelo analista Emerson 
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()
					EndIf
				EndIf
					
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "104" .and. aBanco[oLbx1:nAt,1]
		If cEmpant == '01' //SP
			cDirect    := "\arq_txt\tesouraria\Importacao\Banco CEF\"
			cDirectImp := "\arq_txt\tesouraria\Importacao\Banco CEF\Backup\"
		ElseIf cEmpant == '03' //RJ
			cDirect    := "\arq_txtrj\tesouraria\Importacao\Banco CEF\"
			cDirectImp := "\arq_txtrj\tesouraria\Importacao\Banco CEF\Backup\"
		EndIf
		aDirect    := Directory(cDirect+"*.RET")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	FT_FREADLN()

			If Substr(cBuffer,1,3) <> "104"
				alert("Arquivo nao Pertence ao Banco CEF!")
				Return
			EndIf

			If Len(cBuffer)< 240 .or. Len(cBuffer)> 240
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
				_cID	    := Substr(cBuffer,008,01) // 0-Cabecalho; 1-Cabecalho Lote (saldo anterior); 3-Detalhes; 5-Rodape Lote (saldo atual); 9-Rodape Arquivo
				_cTpLanc    := Substr(cBuffer,169,01) // Definicao do Tipo de Lancamento Credito/ Debito. D-Debito, C-Credito.
				_cHist		:= Substr(cBuffer,177,25) // Historico do lancamento pelo Banco
			/*|--------------------------------------------------------------------|
			  | Pula Cabecalho e Rodape (Arquivo e Lote)                           |
			  | Registros de Debito tambem nao sao importados - D                  |
			  |--------------------------------------------------------------------|*/
				If _cID $ "0|1|5|9" .or. _cTpLanc == "D" 
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,054,04)
				_cConta  	:=	Substr(cBuffer,065,06) // Sem o Digito.
				_cTipo		:=	Substr(cBuffer,170,03) // Codigos de Categoria
				_cEmissao	:=	Substr(cBuffer,143,08)
				_cData 		:=	ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,7,2))
				_cValor  	:=	Substr(cBuffer,151,18)                
   				_dAntServ	:= DATE() - 1
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf      
				
				_cDeposit	:=	""
				_cDocument	:=	""

//				_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,136,15)),30))  // CNPJ do Depositante
				_cDocument	:=	Substr(cBuffer,202,15)   // Numero do Documento 

			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "104"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "104"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13)
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()
					EndIf
				EndIf
				
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "033" .and. aBanco[oLbx1:nAt,1]
		If cEmpant == '01' //SP
			cDirect    := "\arq_txt\tesouraria\Importacao\Banco Santander Banespa\"
			cDirectImp := "\arq_txt\tesouraria\Importacao\Banco Santander Banespa\Backup\"
		ElseIf cEmpant == '03' //RJ
			cDirect    := "\arq_txtrj\tesouraria\Importacao\Banco Santander Banespa\"
			cDirectImp := "\arq_txtrj\tesouraria\Importacao\Banco Santander Banespa\Backup\"
		EndIf
		aDirect    := Directory(cDirect+"*.TXT")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	FT_FREADLN()

			If Substr(cBuffer,1,3) <> "033"
				alert("Arquivo nao Pertence ao Banco Santander Banespa!")
				Return
			EndIf

			If Len(cBuffer)< 240 .or. Len(cBuffer)> 240
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
				_cID	    := Substr(cBuffer,008,01) // 0-Cabecalho; 1-Cabecalho Lote (saldo anterior); 3-Detalhes; 5-Rodape Lote (saldo atual); 9-Rodape Arquivo
				_cTpLanc    := Substr(cBuffer,169,01) // Definicao do Tipo de Lancamento Credito/ Debito. D-Debito, C-Credito.
				_cHist		:= Substr(cBuffer,177,25) // Historico do lancamento pelo Banco
			/*|--------------------------------------------------------------------|
			  | Pula Cabecalho e Rodape (Arquivo e Lote)                           |
			  | Registros de Debito tambem nao sao importados - D                  |
			  |--------------------------------------------------------------------|*/
				If _cID $ "0|1|5|9" .or. _cTpLanc == "D" 
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,054,04)
				_cConta  	:=	Substr(cBuffer,065,06) // Sem o Digito.
				_cTipo		:=	Substr(cBuffer,170,03) // Codigos de Categoria
				_cEmissao	:=	Substr(cBuffer,143,08)
				_cData 		:=	ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,7,2))
				_cValor  	:=	Substr(cBuffer,151,18)
   				_dAntServ	:= DATE() - 1
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf  
				  
				_cDeposit	:=	""
				_cDocument	:=	""

//				_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,136,15)),30))  // CNPJ do Depositante
				_cDocument	:=	Substr(cBuffer,202,15)   // Numero do Documento 

			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "033"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "033"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13)
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()
					EndIf
				EndIf
				
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
EndCase

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	If aBanco[oLbx1:nAt,2] == "341"
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		If cEmpant == '01' //SP
			cDirecCartao:= "\arq_txt\tesouraria\Importacao\Itau\Cartao\" 
		ElseIf cEmpant == '03' //RJ
			cDirecCartao:= "\arq_txtrj\tesouraria\Importacao\Itau\Debito\"
		EndIf
		__copyfile(cDirect+adirect[_nI,1],cDirecCartao+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	ElseIf aBanco[oLbx1:nAt,2] == "237"
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		If cEmpant == '01' //SP
			cDirecCartao:= "\arq_txt\tesouraria\Importacao\Bradesco\Debito\"
		ElseIf cEmpant == '03' //RJ
			cDirecCartao:= "\arq_txtrj\tesouraria\Importacao\Bradesco\Debito\"
		EndIf
		__copyfile(cDirect+adirect[_nI,1],cDirecCartao+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	ElseIf aBanco[oLbx1:nAt,2] == "001"      // PATRICIA FONTANEZI - 01/2013 INCLUSAO DO BANCO DO BRASIL PARA TRATAMENTO
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		If cEmpant == '01' //SP
			cDirecCartao:= "\arq_txt\tesouraria\Importacao\Banco do Brasil\Debito\"  
		ElseIf cEmpant == '03' //RJ
		  	cDirecCartao:= "\arq_txtrj\tesouraria\Importacao\Banco do Brasil\Debito\"			
		EndIf
		__copyfile(cDirect+adirect[_nI,1],cDirecCartao+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	Else
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	EndIf
Next

MsgInfo("Importacao Finalizada com Sucesso!!!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  06/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao de Extrato Bancario                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MARKIMP()
If aBanco[oLbx1:nAt,1]
	aBanco[oLbx1:nAt,1] := .F.
Else
	For _nI := 1 to Len(aBanco)
		aBanco[_nI,1] := .F.	
	Next _nI
	aBanco[oLbx1:nAt,1] := .T.
EndIf
oLbx1:Refresh(.T.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  06/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function SZ8_IDENT()
Local aArea := GetArea() //, aPags := {}
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )
Private cPerg  := "FIN111    "
lRet        := .F.
aPags       := {}

_aPerg := {}
AADD(_aPerg,{cPerg,"01","Conta de           ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"02","Conta ate          ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"03","Data de            ?","","","mv_ch3","D",08,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Data ate           ?","","","mv_ch4","D",08,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AjustaSX1(_aPerg)

If !Pergunte(cPerg, .T.)
	Return
EndIf

_xFilSZ8:= xFilial("SZ8")
_cOrdem := " Z8_FILIAL, Z8_CONTA, Z8_BANCO, Z8_AGENCIA, Z8_EMISSAO, Z8_VALOR"
_cQuery := " SELECT Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_EMISSAO, Z8_TIPO, Z8_DEPOS, Z8_VALOR, Z8_NDOC, Z8_NAGE, Z8_IDENT, Z8_BA, Z8_CI, Z8_RDR, Z8_IR, Z8_IRTIP, Z8_IRRDR, SZ8.R_E_C_N_O_ REGSZ8"
_cQuery += " FROM "
_cQuery += RetSqlName("SZ8")+" SZ8"
_cQuery += " WHERE '"+ _xFilSZ8 +"' = Z8_FILIAL"
_cQuery += " AND    Z8_CONTA   >= '"+mv_par01+"'"
_cQuery += " AND    Z8_CONTA   <= '"+mv_par02+"'"
_cQuery += " AND    Z8_EMISSAO >= '"+DTOS(mv_par03)+"'"
_cQuery += " AND    Z8_EMISSAO <= '"+DTOS(mv_par04)+"'"
_cQuery += " AND    Z8_IDENT    = ''"
U_EndQuery( @_cQuery,_cOrdem, "SZ8TMP", {"SZ8" },,,.T. )

dbSelectArea("SZ8TMP")
dbGoTop()

While !Eof()
	_cTipoDoc := LEFT(POSICIONE("SZ9",2,xFilial("SZ9")+SZ8TMP->Z8_TIPO,"Z9_TIPO_D"),15)
	_cAgencia := POSICIONE("SZA",1,xFilial("SZA")+SZ8TMP->Z8_NAGE,"ZA_NAGE_D")
	_cIdentif := LEFT(POSICIONE("SZB",1,xFilial("SZB")+SZ8TMP->Z8_IDENT,"ZB_IDENT_D"),10)
	
	aAdd(aPags,{.F.,SZ8TMP->Z8_EMISSAO,SZ8TMP->Z8_TIPO+" - "+_cTipoDoc,SZ8TMP->Z8_DEPOS,SZ8TMP->Z8_VALOR,SZ8TMP->Z8_NDOC,SZ8TMP->Z8_NAGE,_cAgencia,SZ8TMP->Z8_IDENT+" - "+_cIdentif,SZ8TMP->Z8_BA,SZ8TMP->Z8_CI,SZ8TMP->Z8_RDR,SZ8TMP->Z8_IR,SZ8TMP->Z8_IRTIP,SZ8TMP->Z8_IRRDR,SZ8TMP->REGSZ8})
	dbSelectArea("SZ8TMP")
	DbSkip()
Enddo

//                             "Data"            ,"Tipo/Documento"               ,"Depositante"     ,"Valor"                                           ,"Documento        ,"No."             ,"Agencia"         ,"Identificacao"                   ,"B.A."                                             ,"C.I."                                             ,"RDR"              ,"Irregularidade"                                   ,"Tipo Irreg."      ,"RDR Irreg."
// 1                           2                  3                               4                  5                                                  6                  7                  8                  9                                  10                                                  11                                                  12                  13                                                  14                  15
// .F.                        ,SZ8TMP->Z8_EMISSAO,SZ8TMP->Z8_TIPO+" - "+_cTipoDoc,SZ8TMP->Z8_DEPOS  ,SZ8TMP->Z8_VALOR                                  ,SZ8TMP->Z8_NDOC   ,SZ8TMP->Z8_NAGE   ,_cAgencia         ,SZ8TMP->Z8_IDENT+" - "+_cIdentif  ,SZ8TMP->Z8_BA                                      ,SZ8TMP->Z8_CI                                      ,SZ8TMP->Z8_RDR     ,SZ8TMP->Z8_IR                                      ,SZ8TMP->Z8_IRTIP   ,SZ8TMP->Z8_IRRDR   ,SZ8TMP->REGSZ8
// aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3]             ,aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9]                ,Transform(aPags[oLbx1:nAt,10],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,11],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,12],Transform(aPags[oLbx1:nAt,13],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,14],aPags[oLbx1:nAt,15]

dbSelectArea("SZ8TMP")
DbCloseArea()

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 300,778 TITLE "Escolha de qual movimento quer conciliar " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Data","Tipo/Documento","Depositante","Valor","Documento","No.","Agencia","Identificacao","B.A.","C.I.","RDR","Irregularidade","Tipo Irreg.","RDR Irreg." SIZE 345, 85 OF oDlg PIXEL ;
	ON DBLCLICK (U_MARKSZ8())
	
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3]             ,aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9]                ,Transform(aPags[oLbx1:nAt,10],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,11],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,12],Transform(aPags[oLbx1:nAt,13],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,14],aPags[oLbx1:nAt,15] } }
	oLbx1:nFreeze  := 1
	
	DEFINE SBUTTON FROM 94, 264 TYPE 17 ENABLE OF oDlg ACTION U_MarcaSZ8() // BUTT
	DEFINE SBUTTON FROM 94, 292 TYPE 11 ENABLE OF oDlg ACTION U_RDRSZ8(9)
	DEFINE SBUTTON FROM 94, 320 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgInfo("Nใo Haverแ Baixa!","Aten็ใo")
Endif

RestArea(aArea)

Return


User Function MARKSZ8()
If aPags[oLbx1:nAt,1]
	aPags[oLbx1:nAt,1] := .F.
Else
	aPags[oLbx1:nAt,1] := .T.
EndIf
oLbx1:Refresh(.T.)
Return

User Function MarcaSZ8
For _nI:=1 to Len(aPags)
	If aPags[_nI,1]
		aPags[_nI,1] := .F.
	Else
		aPags[_nI,1] := .T.
	EndIf
Next _nI
oLbx1:Refresh(.T.)
Return

User Function RDRSZ8(_nPar)
Local   aArea  := GetArea()
Private _xPar  := _nPar   // Alteracao feita por CG em 09/03/07, conforme chamado n. 23174.
Private aAcho  := {}
Private aCpos  := {}
Private _lSair := .T.
//Private _cRDR    := Space(15)
Private _cRDR    := SUBSTR(DTOS(DATE()),3,6) //Alterado pelo analista Emerson dia 08/06/09. Retirado linha anterior, para inicializar o RDR.
Private _cIRRDR  := Space(15)
Private _cRMU    := "R" // Space(01)
Private _cCODID  := Space(02)
aMemos := {}

SZB->(DbSetOrder(3))
If !SZB->(DbSeek(xFilial("SZB")+__CUSERID))
	MsgBox("Login do usuario sem vinculo com a Identificacao de Baixa")
	Return(.T.)
EndIf

If _nPar == 1                    	// Lancamentos
//	AADD(aCpos,"Z8_IDENT")
	AADD(aCpos,"Z8_RMU")
	AADD(aCpos,"Z8_CONV")
	AADD(aCpos,"Z8_BA")	
	AADD(aCpos,"Z8_CI")
	AADD(aCpos,"Z8_IR")             
//	AADD(aCpos,"Z8_RDR")	
	AADD(aCpos,"Z8_OBS")		
	AADD(aCpos,"Z8_UNIDADE")
ElseIf _nPar == 2             		// Irregularidades
	AADD(aCpos,"Z8_IRTIP")
	AADD(aCpos,"Z8_IRRDR")
ElseIf _nPar == 3                   // Outros
//	AADD(aCpos,"Z8_RDR")
	AADD(aCpos,"Z8_IR")
	AADD(aCpos,"Z8_IRTIP")
ElseIf _nPar == 4                   // Fluxo
	AADD(aCpos,"Z8_FLUXO")
	AADD(aCpos,"Z8_RMU")
ElseIf _nPar == 9                   // Identificacao
	AADD(aCpos,"Z8_IDENT")
	AADD(aCpos,"Z8_OBS")
	AADD(aCpos,"Z8_CONV")
	AADD(aCpos,"Z8_UNIDADE")
//	AADD(aCpos,"Z8_BA")
//	AADD(aCpos,"Z8_CI")
//	AADD(aCpos,"Z8_IR")
//	AADD(aCpos,"Z8_IRTIP")
EndIf

DbSelectarea("SZ8")
_nTam  := len(aPags)
_nCont := 1            
_lFaz  := .T.
_lFez  := .F.

While _nCont <= _nTam  // Vai tratar para todos os itens do Acols marcados
	If aPags[_nCont,1]
		_lSair:=.T.
		SZ8->(dbGoto(aPags[_nCont,16]))
		If _nPar == 1
			RecLock("SZ8", .F.)
			SZ8->Z8_RDR     := _cRDR
			SZ8->Z8_IDENT   := POSICIONE("SZB",3,xFilial("SZB")+__CUSERID,"ZB_IDENT")
			SZ8->Z8_IDENT_D := POSICIONE("SZB",3,xFilial("SZB")+__CUSERID,"ZB_IDENT_D")
			If SZ8->Z8_FLUXO == 'S'
 			  SZ8->Z8_CI  := SZ8->Z8_VALOR
 			EndIf  
		ElseIf _nPar == 2
			RecLock("SZ8", .F.)
			SZ8->Z8_IRRDR := _cIRRDR
			msUnLock()
		ElseIf _nPar == 3
   			_nAuxBA:= SZ8->Z8_BA
			_nAuxCI:= SZ8->Z8_CI
			_nAuxIR:= SZ8->Z8_IR
            _cAuxTI:= SZ8->Z8_IRTIP
			RecLock("SZ8", .F.)
  			SZ8->Z8_BA    := 0
			SZ8->Z8_CI    := 0
			SZ8->Z8_IR    := SZ8->Z8_VALOR
            SZ8->Z8_IRTIP := "O"
			msUnLock()    
		ElseIf _nPar == 4
			RecLock("SZ8", .F.)
			SZ8->Z8_FLUXO := "S"    
			SZ8->Z8_RMU   := _cRMU
			msUnLock()
		ElseIf _nPar == 9
			RecLock("SZ8", .F.)
			SZ8->Z8_IDENT := _cCODID
			_cIdentif := LEFT(POSICIONE("SZB",1,xFilial("SZB")+SZ8->Z8_IDENT,"ZB_IDENT_D"),10)
			aPags[_nCont,09] := SZ8->Z8_IDENT+" - "+_cIdentif
			msUnLock()
		EndIf
		RecLock("SZ8", .F.)
		msUnLock()
		
		If _lFaz  
			AxAltera("SZ8",Recno(),4,aAcho,aCpos,,,'ExecBlock("OKSZ8",.F.,.F.)')
		Else
		  _lSair:=.F.
		EndIf
	
		If _nPar == 1
		    If SZ8->Z8_FLUXO == 'S'
              If SZ8->Z8_BA <> 0 .Or. SZ8->Z8_CI <> SZ8->Z8_VALOR                   
	             _cMsg := "Lan็amento considerado no Fluxo como CI !!"
	             MsgAlert(_cMsg, "Aten็ใo")
              EndIf
            EndIf                

			aPags[_nCont,10] := SZ8->Z8_BA
			aPags[_nCont,11] := SZ8->Z8_CI
			aPags[_nCont,12] := SZ8->Z8_RDR
			aPags[_nCont,13] := SZ8->Z8_IR
			_cRDR := SZ8->Z8_RDR

			//Alterado dia 13/04/09 pelo analista Emerson
			//Geracao automatica do Rateio apos a confirmacao da Baixa (item a item)
			//Inicio do Bloco Rateio Automatico
			_nPos	:= At("-", SZ8->Z8_IDENT_D)
			If Alltrim(Substr(SZ8->Z8_IDENT_D,1,_nPos-1)) $"SECOR"
				_cConta	:= "1160211"
			ElseIf Alltrim(Substr(SZ8->Z8_IDENT_D,1,_nPos-1)) $"SPBA"
				_cConta	:= "1160111"
			Else
				_cConta	:= ""
			EndIf

			If !Empty(_cConta) .and. !_lSair
				// Marca o titulo (adiantamento) como conta prestada e
				// o tira do fluxo de caixa.
				RecLock("SZ8",.F.)
				SZ8->Z8_RATEIO  := "S"
				msUnLock()

				If Alltrim(SZ8->Z8_RMU)=="R" //Privada
					_cNaturez	:= "1.01.01"
				ElseIf Alltrim(SZ8->Z8_RMU)=="M" //Mista
					_cNaturez	:= "1.01.03"
				ElseIf Alltrim(SZ8->Z8_RMU)=="U" //Publica
					_cNaturez	:= "1.01.02"
				Else
					_cNaturez	:= ""
				EndIf

				RecLock("SZF", .T.)
				SZF->ZF_FILIAL  := xFilial("SZF")
				SZF->ZF_BANCO   := SZ8->Z8_BANCO
				SZF->ZF_AGENCIA := SZ8->Z8_AGENCIA
				SZF->ZF_CONTA   := SZ8->Z8_CONTA
				SZF->ZF_EMISSAO := SZ8->Z8_EMISSAO
				SZF->ZF_REGISTR := SZ8->Z8_REGISTR
				SZF->ZF_ITEM	:= "01"
				SZF->ZF_VALOR	:= SZ8->Z8_VALOR
				SZF->ZF_CCONTA	:= _cConta
				SZF->ZF_CR		:= "" 
				SZF->ZF_NATUREZ	:= _cNaturez
				SZF->ZF_RMU		:= SZ8->Z8_RMU
				SZF->ZF_DC		:= "C"
				SZF->ZF_RDR     := SZ8->Z8_RDR
				SZF->(msUnLock())
			EndIf
			//Fim do Bloco Rateio Automatico
		ElseIf _nPar == 2
			aPags[_nCont,14] := SZ8->Z8_IRTIP
			aPags[_nCont,15] := SZ8->Z8_IRRDR
			_cIRRDR := SZ8->Z8_IRRDR
		ElseIf _nPar == 3
			aPags[_nCont,10] := SZ8->Z8_BA
			aPags[_nCont,11] := SZ8->Z8_CI
			aPags[_nCont,12] := SZ8->Z8_RDR
			aPags[_nCont,13] := SZ8->Z8_IR
			aPags[_nCont,14] := SZ8->Z8_IRTIP
			aPags[_nCont,15] := SZ8->Z8_IRRDR
		ElseIf _nPar == 4
           	_cRMU := SZ8->Z8_RMU
		ElseIf _nPar == 9
			_cIdentif := LEFT(POSICIONE("SZB",1,xFilial("SZB")+SZ8->Z8_IDENT,"ZB_IDENT_D"),10)
			aPags[_nCont,09] := SZ8->Z8_IDENT+" - "+_cIdentif
			_cCODID := SZ8->Z8_IDENT
		EndIf
		
		If _lSair
			If _nPar == 1
				RecLock("SZ8", .F.)
				SZ8->Z8_RDR := Space(15)
     			SZ8->Z8_CI  := 0
				msUnLock()
				aPags[_nCont,12] := SZ8->Z8_RDR
			ElseIf _nPar == 2
				RecLock("SZ8", .F.)
				SZ8->Z8_IRRDR := Space(15)
				msUnLock()
    			aPags[_nCont,15] := SZ8->Z8_IRRDR
			ElseIf _nPar == 3
				RecLock("SZ8", .F.)     
				SZ8->Z8_RDR   := Space(15)				
				SZ8->Z8_IRRDR := Space(15)
  			    SZ8->Z8_BA    := _nAuxBA
			    SZ8->Z8_CI    := _nAuxCI
			    SZ8->Z8_IR    := _nAuxIR
                SZ8->Z8_IRTIP := _cAuxTI
			    msUnLock()
				aPags[_nCont,12] := SZ8->Z8_RDR
				aPags[_nCont,15] := SZ8->Z8_IRRDR
			ElseIf _nPar == 4
				RecLock("SZ8", .F.)
				SZ8->Z8_FLUXO := Space(1)
				msUnLock()
			ElseIf _nPar == 9
				RecLock("SZ8", .F.)
				SZ8->Z8_IDENT := Space(02)
				msUnLock()
				aPags[_nCont,09] := SZ8->Z8_IDENT
			EndIf
			_cMsg := "Processo Interrompido!!!"
			MsgAlert(_cMsg, "Aten็ใo")
			Exit
		Else
		    If _nPar == 3
				RecLock("SZ8", .F.)     
				SZ8->Z8_IRRDR := SZ8->Z8_RDR
  			    msUnLock()
			EndIf    
		    If _nPar == 4      
		        _lFez := .T.
				RecLock("SZ8", .F.)     
				SZ8->Z8_FLUXO := "S"
  			    msUnLock()
			EndIf    
		EndIf
	EndIf
	_nCont:=_nCont+1
EndDo
If _nPar == 4 .and. !_lSair
  _cMsg := "Processo de Sele็ใo de Fluxo foi Executado!!!"
  MsgAlert(_cMsg, "Aten็ใo")
EndIf
RestArea(aArea)
oLbx1:Refresh(.T.)

Return

User Function SAIRFLUXO
If SZ8->Z8_FLUXO == 'S'
   If M->Z8_BA <> 0 .Or. M->Z8_CI <> M->Z8_VALOR                   
	 _cMsg := "Lan็amento considerado no Fluxo como CI !!"
	 MsgAlert(_cMsg, "Aten็ใo")
   EndIf
EndIf                
_lSair := .F.
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  10/05/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function OKSZ8()
_lSair := .F.
_lRet  := .T.

//If _xPar <> 4        // Alteracao feita por CG em 09/03/07, conforme chamado n. 23174.
If _xPar <> 9
	If Empty(M->Z8_RDR)
		_lSair := .T.
		_lRet  := .F.
		msgbox("Preenchimento do campo RDR e Obrigatorio !!!", "Aten็ใo")
	EndIf

	//A regra abaixo foi acrescentado pelo analista Emerson dia 05/10/09
	//conforme solicitado do usuario para nao permitir que na Baixa o mesmo esqueca de 
	//preencher o campo TIPO DE EMPRESA.
	If Empty(M->Z8_RMU)
		_lSair := .T.
		_lRet  := .F.
		msgbox(OemToAnsi("Preenchimento do campo Tipo de Empresa ้ Obrigatorio !!!"), "Aten็ใo")
	EndIf

EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  10/05/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ImpRegis()
dbSelectArea("SZ8")

Private titulo       := "Impressao do CNI - SECOR"
Private Li           := 60

Private Cabec1       := ""
Private Cabec2       := ""
Private Cabec3       := ""
Private imprime      := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132 //220
Private tamanho      := "M"
Private nomeprog     := StrTran(FunName(), "#", "")
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "IMPSZ8" // Coloque aqui o nome do arquivo usado para impressao em disco
Private AParDef      := {}
Private aOrd         := {}
Private aLinha       := {}
Private nOrdem       := indexord()
Private cAlias       := Alias()
Private cString      := "SZ8"
Private nRegCor      := Recno()

aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1,"",1}

wnrel   := SetPrint(cString,wnrel,,@titulo,cabec1,cabec2,cabec3,.F.,,.T.,Tamanho,,.F.)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|| RegSZ8() },"Impressao do CNI")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()


Return




Static Function RegSZ8()

cCpoFil  := ""
i        := 0
aCampos  := {}
nTotal   := 0
cCond    := ""
nLinIni  := 0
nLinFim  := 0
nTotLin  := 0
lFirst   := .t.
nOrdem   := 0
aQtCols  := {}
nColAtu  := 0
nTamForm := 0
nTotReg  := 0


NomeProg := "IMPSZ8"
nChar    := 15 // Comprimido ou Normal 18
Cabec1   := "Credito Nao Identificado"

aQtCols  := {}

DbSelectArea(cAlias)
AFIELDS(aCampos)
cCpoFil:=""

//PATRICIA FONTANEZI - 06/12/2012
/*If cAlias != "SM2"
	DbSeek(xFilial("SZ8"))
EndIf */

imprime := .T.

Mont_Array("SZ8")

cCpoFil:=Alias()+"->"+PrefixoCpo(Alias())+"_FILIAL"
cCond  :="!Eof()"

nOrdem:=aReturn[8]

aQtCols := U_ContCol( aLinha )
nColAtu := aQtCols[ Len( aQtCols ) ]

nColuna:=0
nColant:=1
nPos   :=1

dbSelectArea("SZ8")
DbGoTo(nRegCor)
While .T.
	
	If lEnd
		@ PROW () + 1,0 PSAY  "INTERROMPIDO PELO USUARIO"
		Exit
	EndIf
	
	If nPos > Len(aLinha)
		EXIT
	EndIf
	
	
	If ( nColAtu <= Limite )
		
		If li > 58
			cabec2 := PoeCabec( aQtCols, aLinha )
			cabec(cabec1,cabec2,cabec3,nomeprog,tamanho,nChar)
			If lFirst
				nLinIni := Li
			EndIf
		EndIf
		
		ImpColuna( aQtCols, aLinha, Li )
		
		Exit
	End
	
	cCampo  := SUBSTR(aLinha[nPos],01,10)
	cTitulo := SUBSTR(aLinha[nPos],11,12)
	cFormat := Trim(SUBSTR(aLinha[nPos],26,45))		// gilson
	nColuna := VAL(SUBSTR(aLinha[nPos],72,3)) 		// gilson
	
	If nColuna <= nColant
		li++
	EndIf
	
	If li > 58
		cabec(cabec1,cabec2,cabec3,nomeprog,tamanho,nChar)
		If lFirst
			nLinIni := Li
		EndIf
	EndIf
	
	@ Li,nColuna PSAY cTitulo
	nCol := nColuna + 14
	If !("S" $ cFormat)
		@ Li,nCol PSAY &cCAMPO	PICTURE cFormat
	Else
		nTamform := Iif(Tamanho == "P",80,Iif(tamanho=="G",220,132))
		@ Li,nCol PSAY Substr(&cCAMPO,1,nTamForm-nCol) // PICT cFormat
		If Len(&cCampo) > nTamForm-nCol
			li++
			@ Li,nCol PSAY Substr(&cCAMPO,nTamForm-nCol+1) // PICT cFormat
		EndIf
	EndIf
	nColant := nColuna
	nPos++
	
End

DbGoTo(nRegCor)

Return



User Function ContCol( aLinha )

Local nI, nTamTit, nTamCpo, nTamPic, vQtCols, nQtCols, cTitulo, cFormat,;
nCampo

nQtCols := 0
vQtCols := {}

AAdd(vQtCols, 0 )
For nI := 1 to ( Len( aLinha ) )
	
	cTitulo := Trim( SubStr( aLinha[ nI ], 11, 12 ) )
	cFormat := Trim( SubStr( aLinha[ nI ], 26, 20 ) )
	nCampo  := Val( Trim( SubStr( aLinha[ nI ], 23, 03 ) ) )
	
	nTamTit := Len( AllTrim( cTitulo ) )  // Tam. Titulo
	nTamCpo := nCampo 						  // Tam. Campo
	nTamPic := Len( AllTrim( cFormat ) )  // Tam. Picture
	
	If ( nTamTit >= nTamCpo .And. nTamTit >= nTamPic )
		nQtCols += nTamTit + 2
		AAdd( vQtCols, nQtCols )
	ElseIf( nTamCpo >= nTamTit .And. nTamCpo >= nTamPic )
		nQtCols += nTamCpo + 2
		AAdd( vQtCols, nQtCols )
	ElseIf( nTamPic >= nTamTit .And. nTamPic >= nTamCpo )
		nQtCols += nTamPic + 2
		AAdd( vQtCols, nQtCols )
	End
	
Next

Return( vQtCols )


User Function SZ8_FLUXO()
Local aArea := GetArea() //, aPags := {}
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )
Private cPerg  := "FIN112    "
lRet        := .F.
aPags       := {}

_aPerg := {}             

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 - Conta de                                    ณ
//ณ mv_par02 - Conta ate                                   ณ
//ณ mv_par03 - Emissao de                                  ณ
//ณ mv_par04 - Emissao ate                                 ณ
//ณ mv_par05 - Identificacao de                            ณ
//ณ mv_par06 - Identificacao ate                           ณ
//ณ mv_par07 - Irregularidade Com/Sem/Todos                ณ
//ณ mv_par08 - Status Aberto/Fechado/Todos                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AADD(_aPerg,{cPerg,"01","Conta de           ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"02","Conta ate          ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"03","Data de            ?","","","mv_ch3","D",08,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Data ate           ?","","","mv_ch4","D",08,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"05","Identificacao de   ?","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","BZB","",""})
AADD(_aPerg,{cPerg,"06","Identificacao ate  ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","BZB","",""})
AADD(_aPerg,{cPerg,"07","Irregularidade     ?","","","mv_ch7","N",01,0,0,"C","","mv_par07","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"08","Status Irregular.  ?","","","mv_ch8","N",01,0,0,"C","","mv_par08","Aberto s/RDR","","","","","Fechado c/RDR","","","","","Todos","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

If !Pergunte(cPerg, .T.)
	Return
EndIf

_xFilSZ8:= xFilial("SZ8")
_cOrdem := " Z8_FILIAL, Z8_CONTA, Z8_BANCO, Z8_AGENCIA, Z8_EMISSAO, Z8_VALOR"
_cQuery := " SELECT Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_EMISSAO, Z8_TIPO, Z8_DEPOS, Z8_VALOR, Z8_NDOC, Z8_NAGE, Z8_IDENT, Z8_BA, Z8_CI, Z8_RDR, Z8_IR, Z8_IRTIP, Z8_IRRDR, SZ8.R_E_C_N_O_ REGSZ8"
_cQuery += " FROM "

_cQuery += RetSqlName("SZ8")+" SZ8"
_cQuery += " WHERE '"+ _xFilSZ8 +"' = Z8_FILIAL"

_cQuery += " AND    Z8_CONTA   >= '"+mv_par01+"'"
_cQuery += " AND    Z8_CONTA   <= '"+mv_par02+"'"
_cQuery += " AND    Z8_EMISSAO >= '"+DTOS(mv_par03)+"'"
_cQuery += " AND    Z8_EMISSAO <= '"+DTOS(mv_par04)+"'"
_cQuery += " AND    Z8_IDENT   >= '"+mv_par05+"'"
_cQuery += " AND    Z8_IDENT   <= '"+mv_par06+"'"
_cQuery += " AND Z8_RDR         = '' "
_cQuery += " AND Z8_FLUXO       = '' "

If mv_par07 == 1
	_cQuery += " AND Z8_IR     <> 0 "
ElseIf mv_par07 == 2
	_cQuery += " AND Z8_IR      = 0 "
EndIf                                                        	
If mv_par08 == 1
	_cQuery += " AND Z8_IRRDR   = '' "
ElseIf mv_par08 == 2
	_cQuery += " AND Z8_IRRDR  <> '' "
EndIf

U_EndQuery( @_cQuery,_cOrdem, "SZ8TMP", {"SZ8" },,,.T. )

dbSelectArea("SZ8TMP")                                                 					
dbGoTop()

While !Eof()
	_cTipoDoc := LEFT(POSICIONE("SZ9",2,xFilial("SZ9")+SZ8TMP->Z8_TIPO,"Z9_TIPO_D"),15)
	_cAgencia := POSICIONE("SZA",1,xFilial("SZA")+SZ8TMP->Z8_NAGE,"ZA_NAGE_D")
	_cIdentif := LEFT(POSICIONE("SZB",1,xFilial("SZB")+SZ8TMP->Z8_IDENT,"ZB_IDENT_D"),10)
	
	aAdd(aPags,{.F.,SZ8TMP->Z8_EMISSAO,SZ8TMP->Z8_TIPO+" - "+_cTipoDoc,SZ8TMP->Z8_DEPOS,SZ8TMP->Z8_VALOR,SZ8TMP->Z8_NDOC,SZ8TMP->Z8_NAGE,_cAgencia,SZ8TMP->Z8_IDENT+" - "+_cIdentif,SZ8TMP->Z8_BA,SZ8TMP->Z8_CI,SZ8TMP->Z8_RDR,SZ8TMP->Z8_IR,SZ8TMP->Z8_IRTIP,SZ8TMP->Z8_IRRDR,SZ8TMP->REGSZ8})
	dbSelectArea("SZ8TMP")
	DbSkip()
Enddo

//                             "Data"            ,"Tipo/Documento"               ,"Depositante"     ,"Valor"                                           ,"Documento        ,"No."             ,"Agencia"         ,"Identificacao"                   ,"B.A."                                             ,"C.I."                                             ,"RDR"              ,"Irregularidade"                                   ,"Tipo Irreg."      ,"RDR Irreg."
// 1                           2                  3                               4                  5                                                  6                  7                  8                  9                                  10                                                  11                                                  12                  13                                                  14                  15
// .F.                        ,SZ8TMP->Z8_EMISSAO,SZ8TMP->Z8_TIPO+" - "+_cTipoDoc,SZ8TMP->Z8_DEPOS  ,SZ8TMP->Z8_VALOR                                  ,SZ8TMP->Z8_NDOC   ,SZ8TMP->Z8_NAGE   ,_cAgencia         ,SZ8TMP->Z8_IDENT+" - "+_cIdentif  ,SZ8TMP->Z8_BA                                      ,SZ8TMP->Z8_CI                                      ,SZ8TMP->Z8_RDR     ,SZ8TMP->Z8_IR                                      ,SZ8TMP->Z8_IRTIP   ,SZ8TMP->Z8_IRRDR   ,SZ8TMP->REGSZ8
// aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3]             ,aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9]                ,Transform(aPags[oLbx1:nAt,10],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,11],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,12],Transform(aPags[oLbx1:nAt,13],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,14],aPags[oLbx1:nAt,15]

dbSelectArea("SZ8TMP")
DbCloseArea()

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 300,778 TITLE "Escolha de qual movimento quer enviar para Fluxo " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Data","Tipo/Documento","Depositante","Valor","Documento","No.","Agencia","Identificacao","B.A.","C.I.","RDR","Irregularidade","Tipo Irreg.","RDR Irreg." SIZE 345, 85 OF oDlg PIXEL ;
	ON DBLCLICK (U_MARKSZ8())
	
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3],aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9],Transform(aPags[oLbx1:nAt,10],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,11],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,12],Transform(aPags[oLbx1:nAt,13],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,14],aPags[oLbx1:nAt,15] } }
	oLbx1:nFreeze  := 1
	
//	DEFINE SBUTTON FROM 94, 292 TYPE 1 ENABLE OF oDlg ACTION U_RDRSZ8(4)
//	DEFINE SBUTTON FROM 94, 320 TYPE 2 ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End())

	DEFINE SBUTTON FROM 94, 264 TYPE 17 ENABLE OF oDlg ACTION U_MarcaSZ8() //BUTT
	DEFINE SBUTTON FROM 94, 292 TYPE 11 ENABLE OF oDlg ACTION U_RDRSZ8(4)
	DEFINE SBUTTON FROM 94, 320 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End())

	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgInfo("Nใo Haverแ Processo de Sele็ใo para Fluxo!","Aten็ใo")
Endif

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIDENT_DEP บ Autor ณ Emerson Natali     บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IDENT_DEP()
Local aArea := GetArea()
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )
lRet        := .F.
aPags       := {}

Private _xlRel	:= .F.

Private cPerg  := "CFINA11DEP"

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt            ,perg spa,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01 ,defspa01,defeng01,cnt01,var02,def02 ,defspa02,defeng02,cnt02,var03,def03 ,defspa03,defeng03,cnt03,var04,def04 ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
AADD(aRegs,{cPerg  ,"01" ,"Data de          ?",""     ,""       ,"mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_PAR01",""    ,""      ,""      ,""   ,""  ,""    ,""      ,""      ,""  ,""   ,""     ,""     ,""      ,""   ,""   ,""    ,""      ,""      ,""   ,""  ,""     ,""      ,""      ,""   ,""   ,"","","",""})
AADD(aRegs,{cPerg  ,"02" ,"Data ate         ?",""     ,""       ,"mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_PAR02",""    ,""      ,""      ,""   ,""  ,""    ,""      ,""      ,""  ,""   ,""     ,""     ,""      ,""   ,""   ,""    ,""      ,""      ,""   ,""  ,""     ,""      ,""      ,""   ,""   ,"","","",""})
AADD(aRegs,{cPerg  ,"03" ,"Conta            ?",""     ,""       ,"mv_ch3","C" ,10 ,00 ,0  ,"G",""   ,"mv_par03",""    ,""      ,""      ,""   ,""  ,""    ,""      ,""      ,""  ,""   ,""     ,""     ,""      ,""   ,""   ,""    ,""      ,""      ,""   ,""  ,""     ,""      ,""      ,""   ,"BZC","","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))


If !Pergunte(cPerg, .T.)
	Return
EndIf

_xFilSZ8:= xFilial("SZ8")
_cOrdem := " Z8_FILIAL, Z8_CONTA, Z8_BANCO, Z8_AGENCIA, Z8_EMISSAO, Z8_VALOR"
_cQuery := " SELECT Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_EMISSAO, Z8_TIPO, Z8_DEPOS, Z8_VALOR, Z8_NDOC, Z8_NAGE, Z8_IDENT, Z8_BA, Z8_CI, Z8_RDR, Z8_IR, Z8_IRTIP, Z8_IRRDR, SZ8.R_E_C_N_O_ REGSZ8"
_cQuery += " FROM "
_cQuery += RetSqlName("SZ8")+" SZ8"
_cQuery += " WHERE '"+ _xFilSZ8 +"' = Z8_FILIAL"
_cQuery += " AND    Z8_RDR     = ' '"
_cQuery += " AND    Z8_IDDEPOS = ' '"  // braco= Nao Identificado Depositante (gerado relatorio)
_cQuery += " AND    Z8_EMISSAO BETWEEN '"+DTOS(mv_PAR01)+"' AND '"+DTOS(mv_PAR02)+"' "
if !Empty(mv_par03)
	_cQuery += " AND    Z8_CONTA   = '"+mv_par03+"'"
EndIf

U_EndQuery( @_cQuery,_cOrdem, "SZ8TMP", {"SZ8" },,,.T. )

dbSelectArea("SZ8TMP")
dbGoTop()

While !Eof()
	_cTipoDoc := LEFT(POSICIONE("SZ9",2,xFilial("SZ9")+SZ8TMP->Z8_TIPO,"Z9_TIPO_D"),15)
	_cAgencia := POSICIONE("SZA",1,xFilial("SZA")+SZ8TMP->Z8_NAGE,"ZA_NAGE_D")
	_cIdentif := LEFT(POSICIONE("SZB",1,xFilial("SZB")+SZ8TMP->Z8_IDENT,"ZB_IDENT_D"),10)
	
	aAdd(aPags,{.F.,SZ8TMP->Z8_EMISSAO,SZ8TMP->Z8_CONTA,SZ8TMP->Z8_TIPO+" - "+_cTipoDoc,SZ8TMP->Z8_DEPOS,SZ8TMP->Z8_VALOR,SZ8TMP->Z8_NDOC,SZ8TMP->Z8_NAGE,_cAgencia,SZ8TMP->Z8_IDENT+" - "+_cIdentif,SZ8TMP->Z8_BA,SZ8TMP->Z8_CI,SZ8TMP->Z8_RDR,SZ8TMP->Z8_IR,SZ8TMP->Z8_IRTIP,SZ8TMP->Z8_IRRDR,SZ8TMP->REGSZ8})
	dbSelectArea("SZ8TMP")
	DbSkip()
Enddo

//                             "Data"            ,"Tipo/Documento"               ,"Depositante"     ,"Valor"                                           ,"Documento        ,"No."             ,"Agencia"         ,"Identificacao"                   ,"B.A."                                             ,"C.I."                                             ,"RDR"              ,"Irregularidade"                                   ,"Tipo Irreg."      ,"RDR Irreg."
// 1                           2                  3                               4                  5                                                  6                  7                  8                  9                                  10                                                  11                                                  12                  13                                                  14                  15
// .F.                        ,SZ8TMP->Z8_EMISSAO,SZ8TMP->Z8_TIPO+" - "+_cTipoDoc,SZ8TMP->Z8_DEPOS  ,SZ8TMP->Z8_VALOR                                  ,SZ8TMP->Z8_NDOC   ,SZ8TMP->Z8_NAGE   ,_cAgencia         ,SZ8TMP->Z8_IDENT+" - "+_cIdentif  ,SZ8TMP->Z8_BA                                      ,SZ8TMP->Z8_CI                                      ,SZ8TMP->Z8_RDR     ,SZ8TMP->Z8_IR                                      ,SZ8TMP->Z8_IRTIP   ,SZ8TMP->Z8_IRRDR   ,SZ8TMP->REGSZ8
// aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3]             ,aPags[oLbx1:nAt,4],Transform(aPags[oLbx1:nAt,5],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9]                ,Transform(aPags[oLbx1:nAt,10],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,11],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,12],Transform(aPags[oLbx1:nAt,13],"@EZ 999,999,999.99"),aPags[oLbx1:nAt,14],aPags[oLbx1:nAt,15]

dbSelectArea("SZ8TMP")
DbCloseArea()

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 300,778 TITLE "Escolha de qual movimento quer conciliar " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Data","Conta","Tipo/Documento","Depositante","Valor","Documento","No.","Agencia","Identificacao","B.A.","C.I.","RDR","Irregularidade","Tipo Irreg.","RDR Irreg." SIZE 345, 85 OF oDlg PIXEL ;
	ON DBLCLICK (U_MARKSZ8())
	
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3],aPags[oLbx1:nAt,4],aPags[oLbx1:nAt,5],Transform(aPags[oLbx1:nAt,6],"@E 999,999,999.99"),aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8],aPags[oLbx1:nAt,9],aPags[oLbx1:nAt,10],Transform(aPags[oLbx1:nAt,11],"@E 999,999,999.99"),Transform(aPags[oLbx1:nAt,12],"@E 999,999,999.99"),aPags[oLbx1:nAt,13],Transform(aPags[oLbx1:nAt,14],"@E 999,999,999.99"),aPags[oLbx1:nAt,15],aPags[oLbx1:nAt,16] } }
	oLbx1:nFreeze  := 1
	
	For _nI:=1 to Len(aPags)
		If aPags[_nI,1]
			aPags[_nI,1] := .F.
		Else
			aPags[_nI,1] := .T.
		EndIf
	Next _nI
	oLbx1:Refresh(.T.)

	DEFINE SBUTTON FROM 94, 264 TYPE 6  ENABLE OF oDlg ACTION (U_IDDEP_REL(aPags)          ,oDlg:End(), iif(_xlRel,u_IDENT_DEP(),_xlRel:=.F.) ) //type 6 = imprimir
	DEFINE SBUTTON FROM 94, 292 TYPE 11 ENABLE OF oDlg ACTION (U_IDDEP_EDT(aPags,oLbx1:nAt)           ) //(U_RDRSZ8(mv_par01),lRet :=.F.,oDlg:End())
	DEFINE SBUTTON FROM 94, 320 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.                  ,oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgInfo("Nใo Haverแ Registros!","Aten็ใo")
Endif

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  10/28/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IDDEP_EDT(aPags,_nPos)

Local cObs := Space(40)

	cObs	:= aPags[_nPos,5] //posicao 5 - depositante

	DEFINE MSDIALOG oDlg1 FROM 0,0 TO 130,382 TITLE "Observacao do Documento" PIXEL
	@ 06,06 TO 46,177 LABEL "Observacao" OF oDlg1 PIXEL
	@ 25, 15 MSGET cObs Valid(!Empty(cObs))  PICTURE "@!" SIZE 150,10 PIXEL OF oDlg1
	DEFINE SBUTTON FROM  050, 150 TYPE  1 ENABLE ACTION (oDLg1:End()) OF oDLg1
	ACTIVATE MSDIALOG oDlg1 CENTER

	_aArea		:= GetArea()
	_aAreaSZ8	:= SZ8->(GetArea())
	DbSelectArea("SZ8")
	DbGoto(aPags[_nPos,17]) //posicao 17 - R_E_C_N_O_
	RecLock("SZ8",.F.)
	SZ8->Z8_DEPOS	:= cObs
	MsUnLock()
	RestArea(_aArea)
	RestArea(_aAreaSZ8)

	aPags[_nPos,5] := cObs

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บ Autor ณ AP6 IDE            บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IDDEP_REL(aPags)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Relatorio Analise Depositante"
Local cPict			:= ""
Local titulo		:= "Relatorio Analise Depositante"
Local nLin			:= 80
Local Cabec1		:= " Banco Agencia Conta      Convenio                  Emissao  Tipo Desc.Tipo            Hist.                     Depos.                                   Valor          Nr.Doc.         Ident. Desc.Ident."
Local Cabec2		:= ""
Local imprime		:= .T.
Local aOrd			:= {}

Private lAbortPrint	:= .F.
Private limite		:= 80
Private tamanho		:= "G"
Private nomeprog	:= "IDDEP_REL"
Private nTipo		:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey	:= 0
Private m_pag		:= 01
Private wnrel		:= "IDDEP_REL"
Private cString		:= "SZ8"

Private _aRel		:= aPags

dbSelectArea("SZ8")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_nRegDep	:= 0

For _nI:=1 to Len(aPags)
	If !aPags[_nI,1]
		_nRegDep++
	EndIf
Next _nI

If _nRegDep = 0
	If MsgYesNo(OemToAnsi("Nao existem Depositantes para analisar! Confirma Baixa?"), "Creditos Nao Identificados")
		wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	Else
		_xlRel	:= .T.
		Return()
//		u_IDENT_DEP()
	EndIf
Else
	_xlRel	:= .F.
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
EndIf


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

For _nI	:= 1 to Len(_aRel)


	If !_aRel[_nI,1]

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif


		_aArea		:= GetArea()
		_aAreaSZ8	:= SZ8->(GetArea())
		DbSelectArea("SZ8")
		DbGoto(_aRel[_nI,17]) //posicao 17 - R_E_C_N_O_

/*
         1         2         3         4         5         6         7         8         9        10        11         12       13        14        15        16        17        18        19        20        21        22
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Banco Agencia Conta      Convenio                  Emissao  Tipo Desc.Tipo(20)        Hist.                     Depos.                                   Valor          Nr.Doc.         Ident. Desc.Ident.
xxx   xxxxx   xxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx xx/xx/xx xxx  xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999,999.99 xxxxxxxxxxxxxxx xx     xxxxxxxxxxxxxxxxxxxx
*/
		@ nLin, 001 PSAY SZ8->Z8_BANCO
		@ nLin, 007 PSAY SZ8->Z8_AGENCIA
		@ nLin, 015 PSAY SZ8->Z8_CONTA
		@ nLin, 026 PSAY SZ8->Z8_CONVEN
		@ nLin, 052 PSAY SZ8->Z8_EMISSAO
		@ nLin, 061 PSAY SZ8->Z8_TIPO
		@ nLin, 066 PSAY POSICIONE("SZ9",2,XFILIAL("SZ9")+SZ8->Z8_TIPO,"SZ9->Z9_TIPO_D")//DESC TIPO
		@ nLin, 087 PSAY SZ8->Z8_HIST
		@ nLin, 113 PSAY SUBSTR(SZ8->Z8_DEPOS,1,40)		//Alterado dia 04/11/11 pelo analista Emerson. Neste dia foi alterado o campo de 40 para 80 posicoes
		@ nLin, 154 PSAY SZ8->Z8_VALOR picture "@E 9,999,999.99"
		@ nLin, 169 PSAY SZ8->Z8_NDOC
		@ nLin, 185 PSAY SZ8->Z8_IDENT
		@ nLin, 192 PSAY SZ8->Z8_IDENT_D

		RestArea(_aArea)
		RestArea(_aAreaSZ8)

		nLin++

	Else
		_aArea		:= GetArea()
		_aAreaSZ8	:= SZ8->(GetArea())
		DbSelectArea("SZ8")
		DbGoto(_aRel[_nI,17]) //posicao 16 - R_E_C_N_O_

		RecLock("SZ8",.F.)
		SZ8->Z8_IDDEPOS		:= "S" // S= Identificado Depositante
		MsUnLock()

		RestArea(_aArea)
		RestArea(_aAreaSZ8)

	EndIf

Next _nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return    


//**----------------------------------------------------
// funcao deleta - PATRICIA FONTANEZI 06/12/12
//**----------------------------------------------------

USER FUNCTION DELSZ8()

Local  _aArea 	:= GetArea()   
Local _cRet		:= .T. 

IF SZ8->Z8_FILIAL == 'XX'
	MsgAlert("Usuแrio sem autoriza็ใo nesse Registro")
	_cRet	:= .F.   
ENDIF


IF _cRet
	DBDELETE()
ENDIF

RestArea(_aArea)

Return(_cRet)

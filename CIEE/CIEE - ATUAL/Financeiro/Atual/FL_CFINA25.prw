#INCLUDE "rwmake.ch"
//#include "_FixSX.ch" //Nao pode colocar este CH pois apresenta erro de AJUSTASX1
#Include "TopConn.ch"
#INCLUDE "DelAlias.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA25   บ Autor ณ Andy               บ Data ณ  29/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Reclassificacao da Natureza do SE5                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINA25()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local   aArea := GetArea()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private aAcho := {}
Private aCpos := {}
Private aCols := {}

lAltera:=.T.
aMemos := {}

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SE5")
aHeader:={}
While !Eof() .And. (x3_arquivo == "SE5")
	IF X3USO(X3_USADO).And. AllTrim(X3_CAMPO)<>"FILIAL" .And. X3_PROPRI=="U" //x3_propri=="C"
		AADD(aAcho, AllTrim(X3_CAMPO))
	Endif
	dbSkip()
EndDo

AADD(aCpos,"E5_NATREC")
AADD(aCpos,"E5_MOTIVO")
AADD(aCpos,"E5_ITEMD")
AADD(aCpos,"E5_CCD")
AADD(aCpos,"E5_BENEF")
AADD(aCpos,"E5_HISTOR")
AADD(aCpos,"E5_DOCUMEN")

dbSelectArea("SE5")
dbSetOrder(1)

//cCadastro := "Natureza de Contas a Receber"
cCadastro := "Mov. Bancaria a Pagar"
aCores    := {}
aRotina   := { 	{"Pesquisar"		 ,"AxPesqui"  , 0 , 1},;
				{"Visualizar"		 ,"U_VisSE5"  , 0 , 2},;
				{"Reclassificacao"   ,"U_NatSE5"  , 0 , 4},;
				{"Legenda"    		 ,'BrwLegenda(cCadastro,"Legenda",{{"BR_AMARELO","Natureza a Reclassificar"},{"BR_VERDE","Natureza Reclassificada"},{"BR_VERMELHO","Natureza Definitiva"},{"BR_AZUL","Movimenta็ใo Cancelada"}})',0 , 4 }}

Aadd( aCores, { "Alltrim(E5_SITUACA) <> 'C' .And. Empty(E5_NATREC) .And. ALLTRIM(E5_NATUREZ) = '6.08.01'"	, "BR_AMARELO" 	})
Aadd( aCores, { "Alltrim(E5_SITUACA) <> 'C' .And. !Empty(E5_NATREC)" 										, "BR_VERDE" 	})
Aadd( aCores, { "Alltrim(E5_SITUACA) <> 'C' .And. ALLTRIM(E5_NATUREZ) <> '6.08.01'"							, "BR_VERMELHO"	})
Aadd( aCores, { "Alltrim(E5_SITUACA) == 'C'" 	                     										, "BR_AZUL"	 	})
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a Filtragem                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SE5")
dbSetOrder(1)

/* alteracao dia 21 e 22/03/07 pelo analista Emerson
Criado rotina de Filtros para trazer somente os titulos a serem Regularizados
*/
bFiltraBrw := {|| Nil}
aIndSe5    := {}
cCond      :=	"E5_MOEDA=='NI' .and. Alltrim(E5_SITUACA) <> 'C' .and. AllTrim(SE5->E5_NATUREZ) == '6.08.01' .and. "+;
				"Empty(E5_NATREC) .and. E5_RECPAG == 'P'"
bFiltraBrw := {|| FilBrowse("SE5",@aIndSe5,@cCond)}
Eval(bFiltraBrw)

mBrowse( 6,1,22,75,"SE5",,,,,2,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA25   บAutor  ณMicrosiga           บ Data ณ  03/22/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VisSE5()
AxVisual('SE5',Recno(),2,aAcho,aCpos)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA25   บAutor  ณMicrosiga           บ Data ณ  03/22/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NatSE5()

aCols := {}

If AllTrim(SE5->E5_SITUACA) == "C"
	_cMsg := "Movimenta็ใo Bancแria Cancelada Nใo permite Reclassifica็ใo!!"
	MsgAlert(_cMsg, "Aten็ใo")
Else
	If AllTrim(SE5->E5_NATUREZ) == "6.08.01"
/* alteracao dia 21 e 22/03/07 pelo analista Emerson
Mudamos o Tipo de Movimentacao (MOEDA) de 'NI' para 'RC'
E realizamos a Contabilizacao do registro
*/
		_lRetAlt := AxAltera("SE5",Recno(),4,aAcho,aCpos,,,'ExecBlock("SairSE5",.F.,.F.)')
		If _lRetAlt == 1 // Alteracao confirmada
			If CFINA25_CTB() // Cria a Contabilizacao do registro alterado
				If AllTrim(SE5->E5_NATREC) == "8.88.88"
					u_CFINA25_1(aCols)
				EndIf
				_cBanco		:= SE5->E5_BANCO
				_cAgenc		:= SE5->E5_AGENCIA
				_cConta		:= SE5->E5_CONTA
				_cDoc		:= SE5->E5_DOCUMEN
				_cBenef		:= SE5->E5_BENEF
				_cItemD		:= SE5->E5_ITEMD
				_cDebito	:= SE5->E5_DEBITO
				_cNatOri	:= SE5->E5_NATUREZ
				_cNatDes	:= SE5->E5_NATREC
				_nValor		:= SE5->E5_VALOR
				_dDtDispo	:= SE5->E5_DTDISPO

				RecLock("SE5",.F.)
				//Tirado linha abaixo. Analista Emerson Natali
				//dia 29/03/2010. Nao existe a necessidade de cancelar o registro original, pois o mesmo
				//deve continuar aparecendo no Extrato. 
				//O novo registro nao aparece no Extrato
//				SE5->E5_SITUACA 	:= "X" 
				SE5->E5_VENCTO		:= DDATABASE
				SE5->E5_MOTIVO 		:= "RECLASSIFICADO MULTIPLAS NATUREZAS"
				MsUnLock()

				/*-----Bloco a baixo e para gerar o registro de Estorno
				//Gera um movimento de Estorno
				RecLock("SE5",.T.)
				SE5->E5_FILIAL 	:= ""
				SE5->E5_DATA 	:= ""
				SE5->E5_MOEDA 	:= ""
				SE5->E5_VALOR	:= ""
				SE5->E5_NATUREZ := ""
				SE5->E5_SITUACA := "E"
				MsUnLock()
				*/
				//Inclui registros de Multi-Natureza
				For _nI := 1 to Len(aCols)
					RecLock("SE5",.T.)
					SE5->E5_FILIAL	:= xFilial("SE5")
					SE5->E5_DATA 	:= _dDtDispo
					SE5->E5_MOEDA 	:= "RC"
					SE5->E5_VALOR	:= aCols[_nI,2] 	//Valor
					SE5->E5_NATUREZ	:= _cNatOri 		//Natureza Origem
					SE5->E5_BANCO	:= _cBanco
					SE5->E5_AGENCIA	:= _cAgenc
					SE5->E5_CONTA	:= _cConta
					SE5->E5_DOCUMEN	:= _cDoc
					SE5->E5_VENCTO	:= DDATABASE
					SE5->E5_RECPAG	:= "P"
					SE5->E5_BENEF	:= _cBenef
					SE5->E5_LA		:= "S"
					SE5->E5_DTDIGIT	:= DDATABASE
					SE5->E5_TIPOLAN	:= "X"
					SE5->E5_ITEMD	:= _cItemD
					SE5->E5_DEBITO	:= _cDebito
					SE5->E5_RATEIO	:= "N"
					SE5->E5_RECONC	:= "x"
					SE5->E5_DTDISPO	:= DDATABASE
					SE5->E5_NATREC	:= aCols[_nI,1] 	//Natureza Destino
					SE5->E5_MODSPB	:= "1"
					SE5->E5_CODORCA	:= "PADRAOPR"
					MsUnLock()
				Next

				If Empty(aCols) 
					RecLock("SE5",.T.)
					SE5->E5_FILIAL	:= xFilial("SE5")
					SE5->E5_DATA 	:= _dDtDispo
					SE5->E5_MOEDA 	:= "RC"
					SE5->E5_VALOR	:= _nValor 		//Valor
					SE5->E5_NATUREZ	:= _cNatOri 	//Natureza Origem
					SE5->E5_BANCO	:= _cBanco
					SE5->E5_AGENCIA	:= _cAgenc
					SE5->E5_CONTA	:= _cConta
					SE5->E5_DOCUMEN	:= _cDoc
					SE5->E5_VENCTO	:= DDATABASE
					SE5->E5_RECPAG	:= "P"
					SE5->E5_BENEF	:= _cBenef
					SE5->E5_LA		:= "S"
					SE5->E5_DTDIGIT	:= DDATABASE
					SE5->E5_TIPOLAN	:= "X"
					SE5->E5_ITEMD	:= _cItemD
					SE5->E5_DEBITO	:= _cDebito
					SE5->E5_RATEIO	:= "N"
					SE5->E5_RECONC	:= "x"
					SE5->E5_DTDISPO	:= DDATABASE
					SE5->E5_NATREC	:= _cNatDes		//Natureza Destino
					SE5->E5_MODSPB	:= "1"
					SE5->E5_CODORCA	:= "PADRAOPR"
					MsUnLock()
				EndIf
			Else
				RecLock("SE5",.F.)
				SE5->E5_ITEMD	:= "1220611"
				SE5->E5_DEBITO	:= "1010112000060100001"
				SE5->E5_NATREC	:= ""
				MsUnLock()
			EndIf
		EndIf
	Else
		_cMsg := "Natureza de Origem Nใo permite Reclassifica็ใo!!"
		MsgAlert(_cMsg, "Aten็ใo")
	EndIf
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA25   บAutor  ณMicrosiga           บ Data ณ  12/16/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SairSE5()
lRet := .T.
//Tirado validacao para conta contabil de Creditos nao Identificados, pois estao existindo casos em que o banco estorno o valor devolvendo o
//dinheiro para a conta
//Alterado dia 22/03/10 - analista Emerson
/*
	If alltrim(M->E5_ITEMD) == "122061"
		MsgAlert("Conta Invalida!!", "Aten็ใo")
		lRet := .F.
	EndIf
*/
	If Empty(M->E5_NATREC)
		MsgAlert("Natureza Invalida!!", "Aten็ใo")
		lRet := .F.
	EndIf
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA25   บAutor  ณMicrosiga           บ Data ณ  03/22/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para realizar a Contabilizacao do Titulo NI que      บฑฑ
ฑฑบ          ณesta sendo regularizado neste momento                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CFINA25_CTB()

Local cOldArea 		:= Alias()
Local nDecs			:= TamSX3('CT2_VALOR')[2]
Local nX			:= 1
Local nBase			:= 1
Local nMaxLanc		:= 99
Local dDataLanc 	:= CTOD("")
Local cLote     	:= space(6)
Local cSubLote  	:= space(3)
Local aCab			:= {}
Local aItem			:= {}
Local aTotItem 		:= {}
Local aAreaSI2		:=	CT2->(GetArea())

Private lMsErroAuto := .F.

SA6->(DbSetOrder(1))
SA6->(DbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))

aCab:={;
{"dDataLanc"	,DDATABASE								,NIL},;
{"cLote"		,Padr("008850",TamSx3("CT2_LOTE")[1])	,NIL},;
{"cSubLote"		,Padr("001"   ,TamSx3("CT2_SBLOTE")[1]),NIL}}

AADD(aItem,{{"CT2_FILIAL"	,xFilial("CT2")				, NIL},;
			{"CT2_LINHA"	,"001"						, NIL},;
			{"CT2_DC"		,"3"              			, NIL},;//1-Debito/ 2-Credito/ 3-PartidaDobrada/ 4-Cont.Hist
			{"CT2_ITEMD"	,SE5->E5_ITEMD 				, NIL},;
			{"CT2_CCD"		,SE5->E5_CCD				, NIL},;
			{"CT2_ITEMC"	,SA6->A6_CONTABI			, NIL},;
			{"CT2_CCC"		,"" 						, NIL},;
			{"CT2_DCD"		,CtbDigCont(SE5->E5_DEBITO)	, NIL},;
			{"CT2_DCC"		,CtbDigCont(SA6->A6_CONTA)	, NIL},;
			{"CT2_VALOR"	,Round(SE5->E5_VALOR,nDecs)	, NIL},;
			{"CT2_HP"		,""  			        	, NIL},;
			{"CT2_HIST"		,TRIM(SE5->E5_DOCUMEN)+" "+TRIM(SE5->E5_BENEF)+" "+(SE5->E5_HISTOR), NIL},;
			{"CT2_DEBITO"	,SE5->E5_DEBITO				, NIL},;
			{"CT2_CREDIT"	,SA6->A6_CONTA				, NIL},;
			{"CT2_TPSALD"	,"9"            			, NIL},;
			{"CT2_ORIGEM"	,"800"+"                                 "+"LP 562/001", NIL},;
			{"CT2_MOEDLC"	,"01"              			, NIL}})

MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aItem,3)

If lMsErroAuto
	DisarmTransaction()
	MostraErro()
	Return .F.
Endif

Return .T.
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFLXM05   º Autor ³ Andy               º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Demonstrativo                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFLXM05()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArq,cInd,cPerg
Local cString := "PAH"
Local aStru
Local cVldAlt := ".T."
Local cVldExc := ".T."

Private aPags := {}
Private _dPar01, _dPar02
Private _cPAHBan, _cPAHAge, _cPAHon

_cPAHBan:=Space(03)
_cPAHAge:=Space(05)
_cPAHCon:=Space(10)

dbSelectArea("PAH")
dbSetOrder(1)

cCadastro := "Demonstrativo"
aCores    := {}

aRotina   := { 	{"Pesquisar"  ,"AxPesqui"												, 0 , 1},;
				{"Visualizar" ,"AxVisual"    											, 0 , 2},;
				{"Imprimir"	  ,"U_IMPDEM"												, 0 , 6}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("PAH")
dbSetOrder(1)

mBrowse( 6,1,22,75,"PAH",,,,,2)

Return


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| IMPDEM     		 | Autor   |  AF Custom           | Data   |    09/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Descricao 	| Relatorio Demonstrativo x Fluxo de Caixa                                       |
+---------------+--------------------------------------------------------------------------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function IMPDEM()
Local 	oReport
Private _lSair
While .T.
	_lSair:= .T.
	If TRepInUse()
		CRIASX1()
		pergunte("CFLXM05XXX",.F.)
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
	If _lSair
		Exit
	EndIf
EndDo
Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| ReportDef()  		 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
Static Function ReportDef()
Local oReport
Local oSection

oReport:= TReport():New("CFLXM05","Demonstrativo Conciliação Bancária x Fluxo de Caixa","CFLXM05XXX",{|oReport| PrintReport(oReport)},"Demonstrativo Fluxo de Caixa")
oReport:SetPortrait(.T.)
oReport:DisableOrientation()
oSection := TRSection():New(oReport,"Demonstrativo Fluxo de Caixa","PAH")

Return oReport

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| PrintReport() 	 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
Static Function PrintReport(oReport)
Local oSection  := oReport:Section(1)
Local cTabPAH	:= RetSqlName('PAH')
Local cQuery	:= ''
Local cAlias	:= ''
Local nX		:= 0
Local nLen		:= 0
Local nFil		:= 0
Local cFil		:= ''
Local _nSldInic	:=0
Local _dDia		:=''

Private _nLinDad	:= 1

//---------------------------------------------------------------------------------
// Define _aDados com as Colunas do Relatório para Tipo Estrutural ou Informativo
//---------------------------------------------------------------------------------


If VAL(MV_PAR02) < 1 .Or. VAL(MV_PAR02) > 12
	MsgStop("Parâmetro de Mês Inválido : "+MV_PAR02+"!")
	_lSair := .F.
	Return
Else
	MV_PAR02:=STRZERO(VAL(MV_PAR02),2)
EndIf


If !Empty(MV_PAR03) 
	
	_cMesPost:= IIf(VAL(MV_PAR02)+1==13,"01",STRZERO(VAL(MV_PAR02)+1))
	_cAnoPost:= IIf(VAL(MV_PAR02)+1==13,STRZERO(VAL(MV_PAR02)+1),STRZERO(VAL(MV_PAR02)))
	
	_dULT := DAY(STOD(_cAnoPost+_cMesPost+"01")-1)
	
	If VAL(MV_PAR03) < 1 .Or. VAL(MV_PAR03) > 31 .Or. VAL(MV_PAR03) > _dULT
		MsgStop("Parâmetro de Dia Ate Inválido : "+MV_PAR04+"!")
		_lSair := .F.
		Return
	EndIf
	
EndIf


//--------------------------------------------------
// Imprimir todos os TRCell() para Tipo Informativo
//--------------------------------------------------
_aMatImp := {}

// ----------------------------------------------
// Origem CFINR017
// ----------------------------------------------
dbSelectArea("PAH")
dbSetOrder(1)  

//Dia para formação do saldo do banco               
_dDia:=CtoD(MV_PAR03+'/'+MV_PAR02+'/'+MV_PAR01)
_dDia++
_dDia:=DataValida(_dDia)
_dDia:=StrZero(Day(_dDia),2)
                                   
_nTam		:=40-Len("CFINR017")
_cChave		:="CFINR017"+Space(_nTam) + MV_PAR01 + MV_PAR02 + _dDia
_cMovimento	:="Saldos Bancos em " + MV_PAR03 +"/" + MV_PAR02 + "/"+MV_PAR01

Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
If dbSeek(xFilial("PAH")+_cChave)                 
	_nSldInic:=PAH_VALOR
	Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento, " ", PAH_VALOR, "CFINR017" }), AADD(_aMatImp,{"I", _cMovimento, " ", PAH_VALOR}) )
Else
	_nSldInic:=0
	Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento, " ", 0, "CFINR017"}), AADD(_aMatImp,{"I", _cMovimento, " ", 0}) )
EndIf
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I",Nil,Nil,Nil,Nil}), AADD(_aMatImp,{"I",Nil,Nil,Nil}) )


// ----------------------------------------------
// Origem CFINR018
// ----------------------------------------------
                                 
cFilPAH:=xFilial("PAH")

cQuery:=" SELECT PAH_FILIAL, PAH_ORIGEM, PAH_DATA, PAH_BANCO, PAH_AGENCI, PAH_CONTA, PAH_TIPO, PAH_VALOR 
cQuery+=" FROM "+cTabPAH
cQuery+=" WHERE PAH_FILIAL	= '"+ cFilPAH + "' "
cQuery+="	AND PAH_ORIGEM 	= 'CFINR018'"
cQuery+="	AND PAH_DATA 	= '" + MV_PAR01 + MV_PAR02 + MV_PAR03 + "' "
cQuery+=" 	AND "+cTabPAH+".D_E_L_E_T_=' ' "
cQuery+=" ORDER BY PAH_TIPO, PAH_BANCO, PAH_AGENCI, PAH_CONTA"

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

//----------------------------------------------------------------------
// Carrega o array 1a. Coluna Comum para Tipo Estrutural e Informativo
//----------------------------------------------------------------------
_nTotal:=0
While (cAlias)->(!Eof())
	_cTipo      := Iif((cAlias)->PAH_TIPO="1", " - Invest Plus", " - FICI DI Federal")
	_cNomeBanco	:= Posicione("SA6",1,xFilial("SA6") + (cAlias)->PAH_BANCO + (cAlias)->PAH_AGENCI + (cAlias)->PAH_CONTA,"A6_NREDUZ")
	_cMovimento	:="Saldo de Aplicação em Fundos - " + AllTrim(_cNomeBanco) + _cTipo 

	Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
	Iif(mv_par04==1, AADD(_aMatImp,{"I",_cMovimento, " ", (cAlias)->PAH_VALOR,"CFINR018"}), AADD(_aMatImp,{"I",_cMovimento, " ", (cAlias)->PAH_VALOR}) )
	
	_nTotal+=(cAlias)->PAH_VALOR
	(cAlias)->(dbSkip())
End

//Soma saldo inicial em bancos           
_nTotal+=_nSldInic

Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I","Total em Bancos", " ", _nTotal, " "}), AADD(_aMatImp,{"I","Total em Bancos", " ", _nTotal}) )
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I",Nil,Nil,Nil,Nil}), AADD(_aMatImp,{"I",Nil,Nil,Nil}) )


(cAlias)->(dbCloseArea())



// ----------------------------------------------
// Convênio Aprendiz - SAEB I
// ----------------------------------------------
_cMovimento	:="Convênio Aprendiz - SAEB I"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )


// ----------------------------------------------
// Convênio Aprendiz - SAEB I
// ----------------------------------------------
_cMovimento	:="Convênio Aprendiz - SAEB II"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )

// ----------------------------------------------
// Origem CFINR026
// ----------------------------------------------
dbSelectArea("PAH")
dbSetOrder(1)  
                                 
_nTam		:=40-Len("CFINR026")
_cChave		:="CFINR026"+Space(_nTam) + MV_PAR01 + MV_PAR02 + MV_PAR03
_cMovimento	:="Compromissos de Valores Creditados até dia " + MV_PAR03 +"/" + MV_PAR02 + "/"+MV_PAR01

Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
If dbSeek(xFilial("PAH")+_cChave)                 
	Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento, " (-) ", PAH_VALOR, "CFINR026"}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
Else
	Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, "CFINR026"}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
EndIf

// ----------------------------------------------
// Convênio SINOP
// ----------------------------------------------
_cMovimento	:="Convênio SINOP"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )

// ----------------------------------------------
// Convênio CAEMA - Aprendiz Empregador
// ----------------------------------------------
_cMovimento	:="Convênio CAEMA - Aprendiz Empregador"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )

// ----------------------------------------------
// Cheques Devolvidos
// ----------------------------------------------
_cMovimento	:="Cheques Devolvidos"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (+) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (+) ", 0}) )

// ----------------------------------------------
// Origem CFINR016 - "Débitos a serem regularizados"
// ----------------------------------------------
dbSelectArea("PAH")
dbSetOrder(1)  
                                 
_nTam		:=40-Len("CFINR016")
_cChave		:="CFINR016"+Space(_nTam) + MV_PAR01 + MV_PAR02 + MV_PAR03
_cMovimento	:="Débitos a serem regularizados" 

Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
If dbSeek(xFilial("PAH")+_cChave)                 
	Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento, " (+) ", PAH_VALOR, "CFINR016"}), AADD(_aMatImp,{"I", _cMovimento, " (+) ", PAH_VALOR}) )
Else
	Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, "CFINR016"}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
EndIf
                                     
// ----------------------------------------------
// Bolsas Auxílio e Cheques a Compensar
// ----------------------------------------------
_cMovimento	:="Bolsas Auxílio e Cheques a Compensar"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
                  
// ----------------------------------------------
// Transitória Débito e Crédito
// ----------------------------------------------
_cMovimento	:="Transitória Débito e Crédito"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
                                 
// ----------------------------------------------
// Diferenças Apuradas do Convênio C.E.F.
// ----------------------------------------------
_cMovimento	:="Diferenças Apuradas do Convênio C.E.F."
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )

// ----------------------------------------------
// IRRF sobre Bolsa Auxílio
// ----------------------------------------------
_cMovimento	:="IRRF sobre Bolsa Auxílio"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
                           
// ----------------------------------------------
// Irregularidades de Processamento B.A. São Paulo (Demonstrativo B.A.)
// ----------------------------------------------
_cMovimento	:="Irregularidades de Processamento B.A. São Paulo (Demonstrativo B.A.)"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
                  
// ----------------------------------------------
// Diferenças Apuradas nos Fechamentos de Bolsa Auxílio São Paulo (SBPA)
// ----------------------------------------------
_cMovimento	:="Diferenças Apuradas nos Fechamentos de Bolsa Auxílio São Paulo (SBPA)"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )

Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I",Nil,Nil,Nil,Nil," "}), AADD(_aMatImp,{"I",Nil,Nil,Nil,Nil}) )
                  
// ----------------------------------------------
// Saldo Banco (Disponibilidades) 
// ----------------------------------------------
_cMovimento	:="Saldo Banco (Disponibilidades)"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
                  
// ----------------------------------------------
// Origem CFLXM03
// ----------------------------------------------
dbSelectArea("PAH")
dbSetOrder(1)  
                                 
_nTam		:=40-Len("CFLXM03")
_cChave		:="CFLXM03"+Space(_nTam) + MV_PAR01 + MV_PAR02 + MV_PAR03
_cMovimento	:="Saldo Fluxo de Caixa " 

Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
If dbSeek(xFilial("PAH")+_cChave)                 
	Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento, " (-) ", PAH_VALOR, "CFLXM03"}), AADD(_aMatImp,{"I", _cMovimento, " (-) ", PAH_VALOR}) )
Else
	Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, "CFLXM03"}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )
EndIf


// ----------------------------------------------
// Ajustes 
// ----------------------------------------------
_cMovimento	:="Ajustes"
Iif(mv_par04==1, AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil}), AADD(_aMatImp,{Nil,Nil,Nil,Nil}) )
Iif(mv_par04==1, AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0, " "}), AADD(_aMatImp,{"I", _cMovimento,  " (-) ", 0}) )


// ----------------------------------------------
// Busca o nome do mes por extenso
// ----------------------------------------------
If Len(_aMatImp) <> 0
	_cMesExt := MesExtenso( MV_PAR02 )
	
	_cTitle:="Demonstrativo Conciliação Bancária x Fluxo de Caixa - " 
	_cTitle+=" " + _cMesExt + " " + MV_PAR01 + " - em R$" + " - Dia Apurado: " + MV_PAR03 +"/" + MV_PAR02 + "/"+MV_PAR01
	oReport:SetTitle(Alltrim(_cTitle))
	
	If mv_par04 == 1
		TRCell():New(oSection,"MOVI"			,"", " "				,/*Picture*/			,70		,/*lPixel*/,{|| _aMatImp[_nLinDad,2]  	})  
		TRCell():New(oSection,"+OU-"			,"", " "				,/*Picture*/			,10		,/*lPixel*/,{|| _aMatImp[_nLinDad,3]  	})  
		TRCell():New(oSection,"VALO"			,"", "Valor"			,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,4]  	},,,"RIGHT")
		TRCell():New(oSection,"TIPO"			,"", "Origem"			,/*Picture*/			,07		,/*lPixel*/,{|| _aMatImp[_nLinDad,5]  	},,,"RIGHT")
	Else
		TRCell():New(oSection,"MOVI"			,"", " "				,/*Picture*/			,70		,/*lPixel*/,{|| _aMatImp[_nLinDad,2]  	})  
		TRCell():New(oSection,"+OU-"			,"", " "				,/*Picture*/			,10		,/*lPixel*/,{|| _aMatImp[_nLinDad,3]  	})  
		TRCell():New(oSection,"VALO"			,"", "Valor"			,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,4]  	},,,"RIGHT")
	EndIf	
	
	oSection:Init()
	nLen:=Len(_aMatImp)
	For nX:=1 to nLen
		_nLinDad:=nX
		oSection:PrintLine()   
		If !Empty(_aMatImp[_nLinDad,1])                                                                                                    
				oReport:Line( oReport:Row(), oSection:Cell(1):ColPos(), oReport:Row(),  oSection:Cell(3):ColPos() + 220 )
		EndIf
	Next nX
	
	
	oSection:Finish()
	
EndIf
_lSair := .F.

Return



/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| CriaSx1()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
Static Function CriaSx1()

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0
Local aRegs		:= {}
Local cPerg		:= "CFLXM05XXX"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Monta array com as perguntas

aAdd(aRegs,{cPerg,"01","Ano      		","","","mv_ch1","C",4,0,0,"G","","MV_PAR01","",			"",	"",	"",	"",	"", "",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Mes     		","","","mv_ch2","C",2,0,0,"G","","MV_PAR02","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Dia      		","","","mv_ch3","C",2,0,0,"G","","MV_PAR03","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Origem      	","","","mv_ch4","C",1,0,0,"C","","MV_PAR04","Sim"		 ,	"",	"",	"",	"", "Não"			,	"",	"",	"", "","","","","","","","","","","","","","","","" ,"","","",""})

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)

#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| CFLXM02     		 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Descricao 	| Relatorio Plano Natureza Financeira CIEE                                       |
+---------------+--------------------------------------------------------------------------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function CFLXM02()
Local 	oReport
Private _lSair
While .T.
	_lSair:= .T.
	If TRepInUse()
		CRIASX1()
		pergunte("CFLXM02XXX",.F.)
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

oReport := TReport():New("CFLXM02","Plano Natureza Financeira","CFLXM02XXX",{|oReport| PrintReport(oReport)},"Plano Natureza Financeira")
oSection := TRSection():New(oReport,"Naturezas","SED")
/////////////
// Células //
/////////////

TRCell():New(oSection,"TIPNAT"			,"", "Tipo"				    ,/*Picture*/	,01				,/*lPixel*/,{|| _aDados[_nLinDad,1]  	})
TRCell():New(oSection,"CODNAT"			,"", "Natureza"				,/*Picture*/	,11				,/*lPixel*/,{|| _aDados[_nLinDad,2]  	})
TRCell():New(oSection,"DESNAT"			,"", ""						,/*Picture*/	,30				,/*lPixel*/,{|| _aDados[_nLinDad,3]  	})
TRCell():New(oSection,"DEPNAT"			,"", "De Para"				,/*Picture*/	,11				,/*lPixel*/,{|| _aDados[_nLinDad,4]  	})
TRCell():New(oSection,"SUPNAT"			,"", "Nat. Totalizadoras"	,/*Picture*/	,11				,/*lPixel*/,{|| _aDados[_nLinDad,5]  	})
TRCell():New(oSection,"FLXNAT"			,"", "Fluxo"				,/*Picture*/	,11				,/*lPixel*/,{|| _aDados[_nLinDad,6]  	})
TRCell():New(oSection,"STANAT"			,"", "Status"				,/*Picture*/	,11				,/*lPixel*/,{|| _aDados[_nLinDad,7]  	})  
TRCell():New(oSection,"CONNAT"			,"", "Condição"				,/*Picture*/	,11				,/*lPixel*/,{|| _aDados[_nLinDad,8]  	})  

///////////////////
// Totalizadores //
///////////////////
//TRFunction():New(oSection:Cell("B2_VATU1"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)

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
Local cTabED	:=RetSqlName('SED')
Local cQuery	:=''
Local cAlias	:=''
Local nX		:=0
Local nLen		:=0
Local nFil		:=0
Local cFil		:=''
Local _cFLXNAT 	:=''
Local _cBLQNAT 	:='' 
Local _cCONNAT 	:=''

Private _nLinDad:=1
Private _aDados	:={}
Private _aChave	:={}

//----------------------------
// Faz o query
//----------------------------

cFil:=xFilial("SED")

cQuery:=" SELECT ED_TIPO, ED_CODIGO, ED_DESCRIC, ED_SUPORC, ED_XFLUXO, ED_SUP, ED_TPMOV, ED_COND, ED_MSBLQL
cQuery+=" FROM "+cTabED
cQuery+=" WHERE ED_FILIAL='"+cFil+"' "
cQuery+="	AND ED_CODIGO 	Between '"+MV_PAR01			+"' And '"+MV_PAR02			+"'"

If mv_par03==1								// 1 == Sintética, 2 == Analítica
	cQuery+="	AND ED_TIPO = '1'"
Else
	If mv_par03==2
		cQuery+="	AND ED_TIPO = '2'"
	EndIf
EndIf

If mv_par04==1                          	// 1 == Ativa, 2 == Inativa
	cQuery+="	AND ED_MSBLQL = '2'"
Else
	If mv_par04==2
		cQuery+="	AND ED_MSBLQL = '1'"
	EndIf
EndIf

If mv_par05==1								// S == Sim, N == Não
	cQuery+="	AND ED_XFLUXO = 'S'"
Else
	If mv_par05==2
		cQuery+="	AND ED_XFLUXO = 'N'"
	EndIf
EndIf
                                         
cQuery+=" 	AND "+cTabED+".D_E_L_E_T_=' ' " 
cQuery+=" ORDER BY ED_FILIAL, ED_CODIGO, ED_SUPORC" 

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

//----------------------------
// Carrega o array
//----------------------------

While (cAlias)->(!Eof())
	                                                                                                                                         
	_cFLXNAT := Iif((cAlias)->ED_XFLUXO=="S","Sim","Não")
	_cBLQNAT := Iif((cAlias)->ED_MSBLQL=="2","Ativa","Inativa") 
    _cCONNAT := Iif(!Empty((cAlias)->ED_COND),Iif((cAlias)->ED_COND=="R","Receita","Despesa")," ")


	Aadd(_aDados,{  Iif((cAlias)->ED_TIPO=="1","S","A"), 	; // "TIPNAT"			,"", "Tipo" 				_aDados[_nLinDad,1]
	U_Trans((cAlias)->ED_CODIGO),							; // "CODNAT"			,"", "Natureza" 			_aDados[_nLinDad,2]
	(cAlias)->ED_DESCRIC		,							; // "DESNAT"			,"", "" 					_aDados[_nLinDad,3]
	(cAlias)->ED_SUPORC			,							; // "DEPNAT"			,"", "De Para"  			_aDados[_nLinDad,4]
								,							; // "SUPNAT"			,"", "Nat. Totalizadoras"	_aDados[_nLinDad,5]	 
	_cFLXNAT 					,							; // "FLXNAT"			,"", "Fluxo"				_aDados[_nLinDad,6]
	_cBLQNAT					,							; // "STANAT"			,"", "Status"				_aDados[_nLinDad,7]	 
	_cCONNAT			        })							; // "CONNAT"			,"", "Condição"				_aDados[_nLinDad,8]
	
	U_De_Para((cAlias)->ED_SUPORC) 	// Procura todos as Naturezas que a atual substituiu (ED_SUPORC).
	U_Superior((cAlias)->ED_CODIGO) // Procura todas as Naturezas que ela representa como sendo natureza superior (ED_SUP)
	(cAlias)->(dbSkip())
	
End
(cAlias)->(dbCloseArea())

//----------------------------
// Faz a impressão
//----------------------------

oSection:Init()
nLen:=Len(_aDados)
For nX:=1 to nLen
	_nLinDad:=nX
	oSection:PrintLine()
Next nX
oSection:Finish()

_lSair := .F.

Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| Trans(_cCodNat)	 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function Trans(_cCodNat)
Local _cRet := ""
_cRet := AllTrim(StrTran(_cCodNat, ".", ""))
_cRet := SubStr(_cRet,1,2)+"."+SubStr(_cRet,3,2)+"."+SubStr(_cRet,5,2)+"."+SubStr(_cRet,7,2)   // Quem Chumbou foi Cristiano 04/06/2013
_cRet := StrTran( _cRet, "..."	, "")
_cRet := StrTran( _cRet, ".."	, "")
_cRet := StrTran( _cRet, ". "	, "")  
If Right(AllTrim(_cRet),1)=="."       
	_cRet := Left(AllTrim(_cRet),Len(AllTrim(_cRet))-1)
EndIf
Return(_cRet)                       

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| De_Para(_cCodNat)	 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function De_Para(_cCodNat)
Local _cCod := Posicione("SED",1,xFilial("SED")+_cCodNat,"ED_SUPORC")
Local _lFirst := .T.
While !Empty(_cCod)
    If _lFirst 
    	_lFirst := .F.
    	_aDados[len(_aDados),4] := _cCod
	Else
		Aadd(_aDados,{ , , , _cCod, , , , }) // , Posicione("SED",1,xFilial("SED")+_cCod,"ED_DESCRIC") 
	EndIf
	_cCod := Posicione("SED",1,xFilial("SED")+_cCod,"ED_SUPORC")
EndDo  
Return
/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| Superior(_cCodNat)	 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function Superior(_cCodNat)        
Local _cSup     :=''
Local cQuerySup	:=''
Local cAlias	:=''
Local cFil		:=''
Local _lFirst   :=.T.
Local cTabED	:=RetSqlName('SED')

//----------------------------
// Faz o query superior
//----------------------------

cFil:=xFilial("SED")

cQuery:=" SELECT ED_TIPO, ED_CODIGO, ED_DESCRIC, ED_SUPORC, ED_XFLUXO, ED_SUP, ED_TPMOV, ED_MSBLQL
cQuery+=" FROM "+cTabED
cQuery+=" WHERE ED_FILIAL = '"+cFil+"' "
cQuery+="	AND ED_SUP =	'"+_cCodNat+"'"
cQuery+=" 	AND "+cTabED+".D_E_L_E_T_=' ' "

TcQuery cQuery New Alias (cAliasSup:=GetNextAlias())

// 1.02 1.03
//----------------------------
// Carrega o array
//----------------------------

While (cAliasSup)->(!Eof())
	                           
	_cSup := Iif((cAliasSup)->ED_TPMOV=="P","+","-")+U_Trans((cAliasSup)->ED_CODIGO)
	If _lFirst
		_aDados [Len(_aDados),5] := _cSup  
		_lFirst := .F.
	Else	            //
		Aadd(_aDados,{  Iif((cAliasSup)->ED_TIPO=="1","S","A"), , , , ; // "TIPNAT"			,"", "Tipo" 				_aDados[_nLinDad,1]
	 					_cSup, , , })									// "SUPNAT"			,"", "Nat. Totalizadoras"	_aDados[_nLinDad,5]
	EndIf
	(cAliasSup)->(dbSkip())
	
End       

(cAliasSup)->(dbCloseArea())

Return
/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| CriaSx1()      	 | Autor   |  AF Custom           | Data   |    05/2013      |
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
Local cPerg		:= "CFLXM02XXX"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Monta array com as perguntas

aTamSX3	:= TAMSX3("ED_CODIGO")
aAdd(aRegs,{cPerg,"01","Codigo de      ","","","mv_ch1","C",aTamSx3[1],0,0,"G","","MV_PAR01","",			"",	"",	"",	"",	"", "",			"",	"", "", "","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegs,{cPerg,"02","Codigo ate     ","","","mv_ch2","C",aTamSx3[1],0,0,"G","","MV_PAR02","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo           ","","","mv_ch3","C",01		  ,0,0,"C","","MV_PAR03","Sintetica",	"",	"",	"",	"", "Analitica"	,	"",	"",	"", "","Ambas","","","","","","","","","","","","","","" ,"","","",""})
aAdd(aRegs,{cPerg,"04","Status         ","","","mv_ch4","C",01		  ,0,0,"C","","MV_PAR04","Ativa"	,	"",	"",	"",	"", "Inativa"	,	"",	"",	"", "","Ambas","","","","","","","","","","","","","","" ,"","","",""})
aAdd(aRegs,{cPerg,"05","Fluxo          ","","","mv_ch5","C",01		  ,0,0,"C","","MV_PAR05","Sim"		,	"",	"",	"",	"", "Não"		,	"",	"",	"", "","Ambas","","","","","","","","","","","","","","" ,"","","",""})

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


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Roteiro  		|       	 		 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/                                   
/*
SED010
	Utilizar 	Campo ED_SUPORC tabela SED para informa Naturezas atuais que substitui a Natureza Inativa;
	Tirar 		conteúdo do Campo ED_SUPORC tabela SED para informa Naturezas Atuais que substitui a Natureza Inativa;
	Ativar 		Campo ED_MSBLQL para 1="SIm" 2 ="Não" para bloqueiar a Natureza  
	Tirar 		conteúdo do Campo ED_SUP tabela SED das Naturezas Superiores; 
	Adotar 		ED_TIPO no Lugar do ED_CLASSE CFINR53, 54, 55     
	Desativar 	uso campo ED_CLASSE
	Ativar 		uso campo ED_TIPO 
	Gerar		SED010_NOVO baseada na Planilha da Tesouraria (Encontrado linhas ocultas)
	Importar	SED010_NOVO para tabela SED010 da Homologção
	Copiar 		SED010 da Produção para diretório DATA em Homologação como SED010 
	Rodar 	 	CFLXM01 para importar ED_FECHA e ED_FECHA_B do SED010 do DATA para SED010 da Homologação 
	Alerta     	A quantidade de naturezas novas, caiu de 1.000 para 500 e o que vai acontecer com as regras em ED_FECHA e ED_FECHA_B? 06/06/13
	Informar    ED_COND para que o Relatório Sintético possa calcular o sentido da Coluna Variação Nominal de acordo com o seu conteúdo "R" ou "D"  
	
Dicionãrio: 
	Label 		ED_TPMOV para "Sinal N Tot", label ED_SUP para "N Tot", label ED_SUPORC para "De Para"
    Ordem 		ED_TPMOV antes do ED_SUP
    Validar 	a existência de ED_SUP e não seja igual a ED_CODIGO, existchav("SED") .and.  M->ED_SUP <> M->ED_CODIGO para Natureza de nível 1
    Validar 	a existência de ED_SUP e que seja igual a ED_CODIGO, existchav("SED") .and.  IIF(Len(AllTrim(M->ED_SUP))==4,.T.,M->ED_SUP<>M->ED_CODIGO) para Natureza de nível 2
    Validar 	a existência de ED_SUPORC para que não seja igual a ED_CODIGO, existchav("SED") .and.  M->ED_SUPORC <> M->ED_CODIGO  
    Criado      ED_NATUREZ sequencia 002 e 003 em SX7010
    Criado      ZZ_NATDEP, atualizadas CFINA52a (cNatDePara:= (cAlias)->ZZ_NATDEP) e CFINA51 (ZZ->ZZ_NATDEP:= _cNatDePara)  
    Criado      Indice NickName(SUPORC) em SED, CFINA51
    Tratado		Se AllTrim(SED->ED_TIPO) == 2 (Analitico) e SED->ED_COND=="D" (Despesa) então _nFator:= -1 e SZZ->ZZ_VALOR := E5_VALOR * _nFator  CFINA51
 	Tratado		ED_COND para aceitar branco ou Pertence("RD"), Receita ou Despesa                                                                                                                  
	
	Regra		A Coluna de Realizado/Realizado para Natureza 00 - Saldo Inicial, do Relatório de 06/13:
				É o Saldo gravado na Tabela SE7 para data de 01/06/13 da Natureza 00;
				Assim, quando a opção de gravar saldo do Relatório de Junho estiver ativado, estaremos gravando o Saldo da data de 01/07/13 da Natureza 00,
				vindo da coluna 07, Realizado/Realizado da linha da Natureza 10 

	Regra		A Coluna de Acumulado/Realizado para Natureza 00 - Saldo Inicial, do Relatório de 06/13:
				É o Saldo gravado na Tabela SE7 para data de 31/12/13 da Natureza 00;
				Assim, quando a opção de gravar saldo do Relatório estiver ativado, estaremos gravando o Saldo da data de 31/12/13 da Natureza 00,
				vindo da coluna 07, Realizado/Realizado da linha da Natureza 10 
				
  
A Fazer
	Não Permitir Naturezas Analíticas com tamanho menor que 8      
    Não Permitir Naturezas Sintéticas com tamanho 6 sem que exista um Sintético tamanho 4
    Não Permitir Naturezas Sintéticas com tamanho 4 sem que exista um Sintético tamanho 2
                                                                                 

*/     

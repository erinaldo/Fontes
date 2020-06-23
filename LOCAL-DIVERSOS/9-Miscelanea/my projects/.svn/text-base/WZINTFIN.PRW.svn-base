#INCLUDE "rwmake.ch"
#include "Topconn.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WZINTFIN บ Autor ณ Lucas Riva Tsuda   บ Data ณ  02/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Integra็ใo RM Fluxus x Protheus                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WZarzur			                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function WZINTFIN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

LOCAL oProcess   
Local cQuery   := ""   
Local cAlias   := "INI"    
Local _aTruque := {}  
Local nX	   := 0
Local cFunc    := "U_WZINTFIN"

PRIVATE oMainWnd   
Private nPort	:= 0//7890  
Private cServer	:= ""//"192.168.0.198"
Private cBanco	:= ""//"ORACLE/RMTESTE"   
Private nConnect:= 0

RpcSetType(3)
RpcSetEnv("01", "01",,,'FIN',, {"SE5","SA6"})  
ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Inicializando ambiente => Empresa/Filial: " +cEmpAnt+"/"+cFilAnt)

nPort   := GetMv("MV_XRMPORT")
cServer	:= Alltrim(GetMv("MV_XRMSRV"))
cBanco  := Alltrim(GetMv("MV_XRMBCO"))

SET DATE FORMAT "dd/mm/yyyy" 

nConnect := TcLink(cBanco, cServer, nPort)

If nConnect <= 0 // Nใo efetuou conexao
	Return
Endif

// Conecta ao outro banco.
TCSetConn(nConnect)

cQuery := "SELECT DISTINCT(A.CODFILIAL) AS FILIALFXCX, A.CODCOLIGADA AS COLIGADAFXCX, B.CODCOLIGADA AS COLIGADACCOLIGADA, B.CODEXTERNO AS EMPRESAPROTHEUS, "
cQuery += "C.CODCOLIGADA AS COLIGADAGFILIAL, C.CODFILIAL AS FILIALGFILIAL, IDINTEGRACAO AS FILIALPROTHEUS " 
cQuery += "FROM FXCX A, GCOLIGADA B, GFILIAL C, FXCXCOMPL D "
cQuery += "WHERE A.CODCOLIGADA IS NOT NULL AND A.CODFILIAL IS NOT NULL AND A.CODCOLIGADA = B.CODCOLIGADA AND A.CODCOLIGADA = C.CODCOLIGADA AND A.CODFILIAL = C.CODFILIAL " 
cQuery += "AND A.CODCOLIGADA = D.CODCOLIGADA AND A.IDXCX = D.IDXCX "
//cQuery += "AND TO_CHAR(A.DATA,'YYYYMMDD') = TO_CHAR(SYSDATE,'YYYYMMDD') " 
cQuery += "AND TO_CHAR(A.DATA,'YYYYMMDD') > '20120731' "
cQuery += "AND TO_CHAR(D.FLAG,'YYYYMMDD') = '19000101' "
cQuery += "AND A.TIPO = 5 "
//cQuery += "AND TO_CHAR(DATA,'YYYYMMDD') = '20120416' "
cQuery += "ORDER BY A.CODCOLIGADA, A.CODFILIAL"
cQuery := ChangeQuery(cQuery)

If Select(cAlias) <> 0
	DbSelectArea(cAlias)
	DBCloseArea(cAlias)
Endif

//Executa a Query no banco de dados
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)   

DbSelectArea(cAlias)
DbGotop()      

//Fa็o este la็o para inserir o conteudo da Query em um array pois preciso limpar o ambiente no proximo la็o (FOR).
While (cAlias)->(!EOF())

	//Array _aTruque
	//1.Filial FXCX
	//2.Coligada FXCX
	//3.Coligada GCOLIGADA
	//4.Empresa Protheus
	//5.Coligada GFILIAL
	//6.Filial GFILIAL
	//7.Filial Protheus

	AADD(_aTruque,{(cAlias)->FILIALFXCX,(cAlias)->COLIGADAFXCX,(cAlias)->COLIGADACCOLIGADA,Alltrim((cAlias)->EMPRESAPROTHEUS),(cAlias)->COLIGADAGFILIAL,(cAlias)->FILIALGFILIAL,Alltrim((cAlias)->FILIALPROTHEUS)})
	(cAlias)->(DbSkip())       
	
EndDo 

For nX := 1 To Len(_aTruque)
                                                                  
	//RpcSetType(3)
	RpcClearEnv()   
	If !Empty(_aTruque[nX][4]) .And. !Empty(_aTruque[nX][7])
  		RpcSetEnv(_aTruque[nX][4],_aTruque[nX][7],,,'FIN',, {"SE5","SA6"})
  		IncSE5(.F.,oProcess,_aTruque[nX][2],_aTruque[nX][1],_aTruque[nX][7])
  		RpcClearEnv()                       
 	EndIf
	
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IncSE5   บ Autor ณ Lucas Riva Tsuda   บ Data ณ  02/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importacao dos recebimentos - RM Fluxus                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WZINTFIN                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function IncSE5(lEnd,oProcess,_xEmp,_xFil,_cFil)

// Variแveis para o Arquivo Temporario
Local aArea		:= GetArea()

// Variaveis da Rotina Automatica
Local aRotAuto 	:= {}
Local aRotCanc 	:= {}
Local aItens 	:= {} 
Local aCanc     := {}
Local nOpc 		:= 4 // receber
Local _cQuery 	:= ""
Local cAlias 	:= "TRB"
Local dDataOld  := dDataBase
Local nPosCol   := 0
Local cCodCol   := "" 
Local nPosId    := 0
Local cCodId    := ""
Local cFunc    := "U_WZINTFIN"

//Variแveis para controle de conexใo
Private nConnect:= 0 // Conexใo aberta pela TcLink()
Private nModulo := 6
Private cModulo := "FIN"
Private nAmbTop := advConnection()

Private INCLUI 	:= .T.

Private lMsErroAuto := .f. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros

Private _cErroAuto	:= ""
Private _cArqAuto 	:= ""

ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Importacao dos recebimentos.") // => Parametros (lEnd/_xEmp/_xFil/_cFil): " +Iif(lEnd,".T.",".F.")+"/"+_xEmp+"/"+_xFil+"/"+_cFil)

nConnect := TcLink(cBanco, cServer, nPort)

If nConnect <= 0 // Nใo efetuou conexao
	//Conout("Erro de conexใo","TCLINK")
	Return
Endif

// Ainda esta no Banco Protheus

// Conecta ao outro banco.
TCSetConn(nConnect)

_cQuery := "SELECT TO_CHAR(A.DATA,'YYYYMMDD') AS DATABAIXA, A.VALOR, A.TIPO, NVL(B.NUMEROCHEQUE,'') NUMEROCHEQUE, A.NUMERODOCUMENTO, TO_CHAR(B.DATAVENCIMENTO,'YYYYMMDD') AS DATAVENCIMENTO, "
_cQuery += "NVL(B.HISTORICO,'') HISTORICO, B.CODCFO, B.VALORJUROS, B.VALORMULTA, B.VALOROP1, B.VALORDESCONTO, B.CODCCUSTO, "
_cQuery += "NVL(B.CODTB1FLX,'') CODTB1FLX, C.NUMBANCO, C.NUMAGENCIA, C.NROCONTA, A.CODCOLIGADA AS CHAVECOL, A.IDXCX AS CHAVEXCX "
_cQuery += "FROM FXCX A, FLAN B, FCXA C, GCOLIGADA D, GFILIAL E, FXCXCOMPL F "  
_cQuery += "WHERE A.CODCOLIGADA = B.CODCOLIGADA AND B.CODCOLIGADA = C.CODCOLIGADA AND C.CODCOLIGADA = D.CODCOLIGADA AND D.CODCOLIGADA = E.CODCOLIGADA "
_cQuery += "AND A.CODCOLIGADA = '"+Alltrim(Str(_xEmp))+"' "    
_cQuery += "AND A.CODCOLIGADA = F.CODCOLIGADA AND A.IDXCX = F.IDXCX "
_cQuery += "AND A.IDXCX = B.IDXCX AND E.CODFILIAL = '"+Alltrim(Str(_xFil))+"' AND B.CODCXA = C.CODCXA "  
//_cQuery += "AND TO_CHAR(A.DATA,'YYYYMMDD') = TO_CHAR(SYSDATE,'YYYYMMDD') " 
_cQuery += "AND TO_CHAR(A.DATA,'YYYYMMDD') > '20120731' "  
_cQuery += "AND TO_CHAR(F.FLAG,'YYYYMMDD') = '19000101' "
_cQuery += "AND A.TIPO = 5 "
//_cQuery += "AND TO_CHAR(DATA,'YYYYMMDD') = '20120416' "
_cQuery += "ORDER BY DATA"
_cQuery := ChangeQuery(_cQuery)

If Select(cAlias) <> 0
	DbSelectArea(cAlias)
	DBCloseArea(cAlias)
Endif

//Executa a Query no banco de dados
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAlias,.T.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento das informacoes via MsExecAuto                			ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DbSelectArea(cAlias)
DbGotop()

ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Preparacao dos dados para MsExecAuto (FINA100)")
While (cAlias)->(!EOF())  
    
    If (cAlias)->TIPO == 5 //Recebimento
		
		aadd(aRotAuto	,{'E5_FILIAL' 	,_cFil								,Nil})//1 
		aadd(aRotAuto	,{'E5_DATA'		,StoD((cAlias)->DATABAIXA)			,Nil})//2
		//aadd(aRotAuto	,{'E5_TIPO' 	,"DP"								,Nil})//3
		aadd(aRotAuto	,{'E5_MOEDA' 	,"01"								,Nil})//4
		aadd(aRotAuto	,{'E5_VALOR'	,(cAlias)->VALOR					,Nil})//7
		aadd(aRotAuto	,{'E5_NATUREZ'	,IIf(!Empty((cAlias)->CODTB1FLX),(cAlias)->CODTB1FLX,Alltrim(GetMv("MV_XNATRM")))		,Nil})//8 
		aadd(aRotAuto	,{'E5_BANCO'	,(cAlias)->NUMBANCO					,Nil})//9 
		aadd(aRotAuto	,{'E5_AGENCIA'	,Substr((cAlias)->NUMAGENCIA,1,5)	,Nil})//10 
		aadd(aRotAuto	,{'E5_CONTA'	,Substr((cAlias)->NROCONTA,1,20)	,Nil})//11  
		aadd(aRotAuto	,{'E5_NUMCHEQ' 	,(cAlias)->NUMEROCHEQUE				,Nil})//12
		aadd(aRotAuto	,{'E5_DOCUMEN' 	,(cAlias)->NUMERODOCUMENTO			,Nil})//13
		aadd(aRotAuto	,{'E5_VENCTO' 	,StoD((cAlias)->DATAVENCIMENTO)		,Nil})//14 
		aadd(aRotAuto	,{'E5_RECPAG' 	,"R"								,Nil})//15 
		aadd(aRotAuto	,{'E5_HISTOR' 	,(cAlias)->HISTORICO				,Nil})//16 
		aadd(aRotAuto	,{'E5_PREFIXO' 	,Alltrim(Str((cAlias)->(CHAVECOL)))	,Nil})//17   
		aadd(aRotAuto	,{'E5_LOTE' 	,Alltrim(Str((cAlias)->(CHAVEXCX)))	,Nil})//17 
		//aadd(aRotAuto	,{'E5_TIPODOC' 	,"VL"								,Nil})//18
		aadd(aRotAuto	,{'E5_CLIFOR' 	,Substr((cAlias)->CODCFO,5,6)		,Nil})//19
		aadd(aRotAuto	,{'E5_LOJA' 	,"01"								,Nil})//20
		aadd(aRotAuto	,{'E5_DTDIGIT' 	,StoD((cAlias)->DATABAIXA)			,Nil})//21
		//aadd(aRotAuto	,{'E5_MOTBX' 	,"NOR"								,Nil})//22
		aadd(aRotAuto	,{'E5_DTDISPO' 	,StoD((cAlias)->DATABAIXA)			,Nil})//23
		aadd(aRotAuto	,{'E5_VLJUROS' 	,(cAlias)->VALORJUROS				,Nil})//24
		aadd(aRotAuto	,{'E5_VLMULTA' 	,(cAlias)->VALORMULTA				,Nil})//25
		aadd(aRotAuto	,{'E5_VLCORRE' 	,(cAlias)->VALOROP1					,Nil})//26
		aadd(aRotAuto	,{'E5_VLDESCO' 	,(cAlias)->VALORDESCONTO			,Nil})//27
		aadd(aRotAuto	,{'E5_RATEIO' 	,"N"								,Nil})//28
		aadd(aRotAuto	,{'E5_CCD'	 	,(cAlias)->CODCCUSTO				,Nil})//29
		
 		aadd(aItens	,aRotAuto)
  		aRotAuto := {}
  		
  	EndIf
	
	dbSelectaRea(cAlias)
	dbSkip()
EndDo 

(cAlias)->(DbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura Conexao com o BD Protheus                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

TCunLink(nConnect)
TCSetConn(nAmbTop) // Restaura conexao ativa para o Protheus
RestArea(aArea)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gravacao do SE5                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//dDataBase := StoD("20120416")
If Len(aItens) > 0

	For nX := 1 to Len(aItens)      
	
	    dDataBase := aItens[nX][2][2]
 	
 		nPosCol	:= Ascan(aItens[nX], { |x| Alltrim(x[1])=="E5_PREFIXO"	} )
		cCodCol := aItens[nX][nPosCol][2]  
		nPosId	:= Ascan(aItens[nX], { |x| Alltrim(x[1])=="E5_LOTE"	} )
		cCodId  := aItens[nX][nPosId][2]
	    
		ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Executando MsExecAuto (FINA100)")
		// Receber
		nOpc := 4
		MSExecAuto({|x,y,z| FINA100(x,y,z)},0,aItens[nX],nOpc)			
		
		If lMsErroAuto
			ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Ocorreu um erro no MsExecAuto (FINA100)")
				
			_cArqAuto 	:= NomeAutoLog()
			//Flega Erro
			//If !_lContinua
			_cErroAuto 	:= MemoRead(_cArqAuto)  
			ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] " + _cErroAuto)
			//Endif
				
			// Flega Importacao - Erro
			//xUpdFlag(cID,"-2",_cErroAuto)
				
			//Mostraerro()
			If !Empty(_cArqAuto)
				Ferase(_cArqAuto)
			Endif
		Else
			// Flega Importa็ใo - Sucesso
			xUpdFlag(cCodCol,cCodId)

		EndIf
			
		lMsErroAuto := .F.
		
	Next nX
		
Endif
    
dDataBase := dDataOld

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xUpdFlag บ Autor ณ Leonardo Soncin    บ Data ณ  05/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza Flag de Importacao do Item no DB Auxiliar         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OASCOMX1                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function xUpdFlag(_cCol,_cId)

Local aArea := GetArea()
Local cSQL	:= ""

nConnect := TcLink(cBanco, cServer, nPort)

If nConnect <= 0 // Nใo efetuou conexao
	//Conout("Erro de conexใo")
	Return
Endif

// Ainda esta no Banco Protheus
// Conecta ao outro banco.
TCSetConn(nConnect)

// Conectado ao outro banco
cSQL := "UPDATE FXCXCOMPL SET FLAG = SYSDATE "
cSQL += " WHERE CODCOLIGADA = " + _cCol + " AND IDXCX = "+_cId+""// AND DATAOP2 IS NULL "                                                                                                                                   

TCSQLExec( cSQL )

TCunLink(nConnect)
TCSetConn(nAmbTop) // Restaura conexao ativa para o Protheus

RestArea(aArea)
Return

#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFINA11  º Autor ³ Leonardo S. Soncin º Data ³  05/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta de Titulos Liberados.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico - CSU                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINA11

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lLock:=.F.

Private cCadastro := "Consulta de Títulos Liberados"
Private cMarca := GetMark()           
Private _aCampos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := menudef()

Private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString 	:= "SE2"
Private aIndexSE2	:= {}
Private cCondicao 	:= ""
PRIVATE bFiltraBrw 	:= {|| Nil}
Private cPerg 		:= PADR("RFIN11",LEN(SX1->X1_GRUPO))

dbSelectArea("SE2")
dbSetOrder(1)

dbSelectArea(cString)

//+----------------------------------------------------------------------------
//| Apresenta o MarkBrowse para o usuario
//+----------------------------------------------------------------------------

CriaSX1()

//+----------------------------------------------------------------------------
//| Monta tela de paramentos para usuario, se cancelar sair
//+----------------------------------------------------------------------------
If !Pergunte(cPerg,.T.)
	Return Nil
Endif

_aCampos  := { 	{"E2_XOKREL"    ,""," "				,""},;
				{"E2_TIPO"      ,"","Tipo"			,""},;
            	{"E2_FILORIG"   ,"","Filial Orig."	,""},;
           		{"E2_NUM"  		,"","No. Titulo"	,PesqPict("SE2","E2_NUM")},;
            	{"E2_FORNECE"  	,"","Fornecedor"	,PesqPict("SE2","E2_FORNECE")},;
            	{"E2_NATUREZ"  	,"","Natureza"		,PesqPict("SE2","E2_NATUREZ")},;
            	{"E2_NOMFOR"    ,"","Nome Forn."	,PesqPict("SE2","E2_NOMFOR")},;
            	{"E2_RSOCIAL"  	,"","Razao Social"	,PesqPict("SE2","E2_RSOCIAL")},;
            	{"E2_TIPOPA"  	,"","Tipo PA?"		,PesqPict("SE2","E2_TIPOPA")},;
            	{"E2_NATURPA"  	,"","Natureza PA"	,PesqPict("SE2","E2_NATURPA")},;
            	{"E2_EMISSAO"  	,"","DT Emissão"	,PesqPict("SE2","E2_EMISSAO")},;
            	{"E2_VENCTO"  	,"","Vencimento"	,PesqPict("SE2","E2_VENCTO")},;
            	{"E2_VENCREA"  	,"","Vencto Real"	,PesqPict("SE2","E2_VENCREA")},;
            	{"E2_VALOR"  	,"","Vlr Titulo"	,PesqPict("SE2","E2_VALOR")},;
            	{"E2_HIST"  	,"","Historico"		,PesqPict("SE2","E2_HIST")},;
            	{"E2_IRRF"  	,"","IRRF"	   		,PesqPict("SE2","E2_IRRF")},;
            	{"E2_ISS"  		,"","ISS"	   		,PesqPict("SE2","E2_ISS")},;
				{"E2_INSS"  	,"","INSS"	   		,PesqPict("SE2","E2_INSS")},;
            	{"E2_PIS"  		,"","PIS"	   		,PesqPict("SE2","E2_PIS")},;
            	{"E2_CSLL" 		,"","CSLL"	   		,PesqPict("SE2","E2_CSLL")},;
            	{"E2_COFINS" 	,"","COFINS"   		,PesqPict("SE2","E2_COFINS")},;
            	{"E2_DECRESC" 	,"","Decrescimo" 	,PesqPict("SE2","E2_DECRESC")},;
            	{"E2_NUMPC" 	,"","No. Pedido"	,PesqPict("SE2","E2_NUMPC")},;
            	{"E2_XCONF01" 	,"","Fiscal"   		,PesqPict("SE2","E2_XCONF01")},;
            	{"E2_XCONF03" 	,"","Contas a Pagar",PesqPict("SE2","E2_XCONF03")},;
            	{"E2_USUALIB" 	,"","Usr Conferencia",PesqPict("SE2","E2_USUALIB")},;
            	{"E2_CODINS" 	,"","Cod Ret INSS"	,PesqPict("SE2","E2_CODINS")},;
            	{"E2_IDDARF" 	,"","ID Darf"		,PesqPict("SE2","E2_IDDARF")},;
            	{"E2_CODISS" 	,"","Cod Aliq ISS"	,PesqPict("SE2","E2_CODISS")} }

cCondicao := 'E2_FILIAL=="'+xFilial("SE2")+'"'
cCondicao += '.And.E2_FORNECE>="'+mv_par03+'".And.E2_FORNECE<="'+mv_par04+'"'
cCondicao += '.And.DTOS(E2_VENCREA)>="'+DtoS(mv_par05)+'".And.DTOS(E2_VENCREA)<="'+DtoS(mv_par06)+'"'
cCondicao += '.And.DTOS(E2_EMISSAO)>="'+DtoS(mv_par07)+'".And.DTOS(E2_EMISSAO)<="'+DtoS(mv_par08)+'"'
cCondicao += '.And.E2_NUM>="'+mv_par01+'".And.E2_NUM<="'+mv_par02+'"'
cCondicao += '.And.E2_XCONF01<>"".AND.E2_XCONF03<>"" '
cCondicao += '.And.E2_SALDO> 0 '
cCondicao += '.And.Empty(E2_XDATREL) ' // CAMPO FLAG 

cMarca := GetMark()
bFiltraBrw 	:= {|| FilBrowse("SE2",@aIndexSE2,@cCondicao) }
Eval(bFiltraBrw)

// desmarca todos os registros filtrados, para que o usuário possa marca-los
SE2->(dbGoTop())
While !SE2->(Eof())
	lLock:=.F.
	If RecLock("SE2",.F.)   
		lLock:=.T.
	Else                                    
		// Se já estiver bloqueado efetua 10 tentativas para bloqueá-lo
		For _nI:=1 to 10
			If RecLock("SE2",.F.)                
				lLock:=.T.
				Exit
			EndIf
		Next _nI                 
	EndIf
	If lLock
		// Se conseguiu bloqueá-lo
		SE2->E2_XOKREL := Space(2) 
		SE2->(MsUnLock())
	EndIf
	SE2->(dbSkip())
End
SE2->(dbGoTop())         

MarkBrow("SE2","E2_XOKREL","!E2_SALDO",_aCampos,,cMarca,,,,,"U_xMarcBox()")
EndFilBrw("SE2",aIndexSE2)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFINA11  º Autor ³ Leonardo S. Soncin º Data ³  05/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta de Titulos Liberados.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico - CSU                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xMarcBox()

Local lLock:=.F.
//cMarca := GetMark()

// Verifica se o registro já está bloqueado, se não estiver bloquea-o
If RecLock("SE2",.F.)   
	lLock:=.T.
Else                                    
	// Se já estiver bloqueado efetua 10 tentativas para bloqueá-lo
	For _nI:=1 to 10
		If RecLock("SE2",.F.)                
			lLock:=.T.
			Exit
		EndIf
	Next _nI                 
EndIf
         
If lLock
	// Se conseguiu bloqueá-lo
	If IsMark("E2_XOKREL",cMarca )
		SE2->E2_XOKREL := Space(2) 
	Else
		SE2->E2_XOKREL := cMarca         
	Endif
	SE2->(MsUnLock())    
Else
	// Se não conseguiu bloqueá-lo
	Aviso("Título em Uso","Este título está em uso por outro usuário!",{"Fechar"},3)
EndIf

Return(lLock)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFIN11GR º Autor ³ Leonardo S. Soncin º Data ³  22/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera Relatorio com os dados marcados.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico - CSU                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFIN11GR

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Títulos Enviados p/ Pagamento"
Local nLin         := 80

Local Cabec1       := "Prf  Numero     Tp   Fornecedor                     Dt.Emissao   Dt.vencto.          Valor     Histórico                                                                                  Num. Relatorio      Dt. Relatorio"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private aDbOrd       := {} 
Private aReg         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFINA11" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFINA11" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SE2"

aOrd := RetOrd('SE2')

aAdd(aReg,{cPerg,"01","Titulo de:          ","mv_ch1","C", 9,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})	//Tatiana Barbosa - OS 3273/10
aAdd(aReg,{cPerg,"03","Fornecedor de:      ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"05","Dt. Vencimento de:  ","mv_ch5","D", 8,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"07","Dt. Emissao de:     ","mv_ch7","D", 8,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})

dbSelectArea("SE2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  22/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
                         
Local nOrdem
Local nTotal := 0
Local lLock:=.F.
Local _cNumRel    
Local cTmp:='cTmp'

dbSelectArea("SX5")
dbSetOrder(1)  			//X5_FILIAL+X5_TABELA+X5_CHAVE
dbSeek(xFilial("SX5")+"ZG"+"01")


IF aReturn[8]==1
	cFiltro:='ORDER BY E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA'
elseif aReturn[8]==2
	cFiltro:='ORDER BY E2_FORNECE,E2_LOJA,E2_PREFIXO,E2_NUM,E2_PARCELA'
elseif aReturn[8]==3
	cFiltro:='ORDER BY E2_VENCREA,E2_FORNECE,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO'
else            
	cFiltro:='ORDER BY E2_EMISSAO,E2_FORNECE,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO'
endif
//DbSelectArea('SE2')

//SE2->( DbSetOrder( aDbOrd[aReturn[8]][2] ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//SE2->( dbGoTop() ) 
cQuery:="SELECT * FROM SE2050 "
cQuery+=" WHERE E2_XOKREL='"+cMarca+"' " 
cQuery+=" AND E2_XDATREL='' "
cQuery+=" AND D_E_L_E_T_='' "+cFiltro 

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
DBSELECTAREA("cTmp")
cTmp->(dbGoTop()) 

While !cTmp->( EOF() ) 
    cPref:=cTmp->E2_PREFIXO
    cNum :=cTmp->E2_NUM
    cParc:=cTmp->E2_PARCELA
    cTipo:=cTmp->E2_TIPO
    cForn:=cTmp->E2_FORNECE
    cLoja:=cTmp->E2_LOJA
	DBSELECTAREA("SE2")	  
	DBSETORDER(1)  
	DBGOTOP()  
	DBSEEK(xFilial("SE2")+cPref+cNum+cParc+cTipo+cForn+cLoja)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
		
  //	If IsMark("E2_XOKREL",cMarca )  .AND. (SE2->E2_XDATREL=='')                      
	
		// Verifica se o registro já está bloqueado, se não estiver bloquea-o
		lLock:=.F.
		If RecLock("SE2",.F.)
			lLock:=.T.
		Else                                    
			// Se já estiver bloqueado efetua 10 tentativas para bloqueá-lo
			For _nI:=1 to 10
				If RecLock("SE2",.F.)
					lLock:=.T.
					Exit
				EndIf
			Next _nI                 
		EndIf
         
 		If lLock

			// Atualiza Flag        
			SE2->E2_XNUMREL := SX5->X5_DESCRI  //Tatiana Barbosa - OS 1188/11 - 10/06/11
			SE2->E2_XDATREL := dDataBase
			SE2->(MsUnLock())
			
			@nLin,001 PSAY SE2->E2_PREFIXO                   
			@nLin,005 PSAY SE2->E2_NUM                    
			@nLin,017 PSAY SE2->E2_TIPO         //12           
			@nLin,021 PSAY SE2->E2_FORNECE+" - "+Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NREDUZ")
			@nLin,055 PSAY SE2->E2_EMISSAO
			@nLin,065 PSAY SE2->E2_VENCREA
			@nLin,075 PSAY SE2->E2_SALDO Picture PesqPict("SE2","E2_SALDO")		
			@nLin,100 PSAY Alltrim(SE2->E2_HIST)
			@nLin,190 PSAY SE2->E2_XNUMREL
			@nLin,210 PSAY SE2->E2_XDATREL
			nTotal += SE2->E2_SALDO
			nLin := nLin + 1 // Avanca a linha de impressao
		Else
			// Se não conseguiu bloqueá-lo
			Aviso("Título em Uso","Este título está em uso por outro usuário!",{"Fechar"},3)
		Endif
		
//	EndIf
	DBSELECTAREA("cTmp")	
	cTmp->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo                                                  

DBCLOSEAREA("cTmp")
//Tatiana Barbosa - OS 1188/11 - 10/06/11
If  lLock
	RecLock("SX5",.F.)
	_cNumRel := VAL(SX5->X5_DESCRI) + 1 
	SX5->X5_DESCRI := PADL(_cNumRel, 6,"0")
	SX5->(MsUnLock())
EndIf
//
                
nLin := nLin + 1 // Avanca a linha de impressao
@nLin,001 PSAY "Total Geral:"
@nLin,070 PSAY nTotal Picture PesqPict("SE2","E2_SALDO")		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CriaSX1  º Autor ³ Leonardo S. Soncin º Data ³  05/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta de Titulos Liberados.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico - CSU                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaSx1()

Local nX := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Titulo de:          ","mv_ch1","C", 9,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})   //Tatiana Barbosa - OS 3273/10
aAdd(aReg,{cPerg,"02","Titulo ate:         ","mv_ch2","C", 9,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})	//Tatiana Barbosa - OS 3273/10
aAdd(aReg,{cPerg,"03","Fornecedor de:      ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"04","Fornecedor ate:     ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"05","Dt. Vencimento de:  ","mv_ch5","D", 8,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"06","Dt. Vencimento ate: ","mv_ch6","D", 8,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"07","Dt. Emissao de:     ","mv_ch7","D", 8,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"08","Dt. Emissao até:    ","mv_ch8","D", 8,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ RetORd   º Autor ³ Sergio Oliveira    º Data ³  Fev/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Reetorna a descricao das ordens selecionadas.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rfina11.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetOrd( pcAlias )

Local aOrdem := {}

SIX->( DbSetOrder(1) )
SIX->( DbSeek("SE21") )  // Titulo

Aadd( aOrdem, SIX->DESCRICAO )
Aadd( aDbOrd, { 1,1 } )

SIX->( DbSeek("SE26") )  // Fornecedor

Aadd( aOrdem, SIX->DESCRICAO )
Aadd( aDbOrd, { 2,6 } )

SIX->( DbSeek("SE23") )  // Vencimento

Aadd( aOrdem, SIX->DESCRICAO )
Aadd( aDbOrd, { 3,3 } )

SIX->( DbSeek("SE25") )  // Emissao

Aadd( aOrdem, SIX->DESCRICAO )
Aadd( aDbOrd, { 4,5 } )

Return( aOrdem )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ Rfin11Rt º Autor ³ Sergio Oliveira    º Data ³  Fev/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exibe o rateio por natureza ref. ao titulo posicionado.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rfina11.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFIN11RT()

Local _xAreaAnt := SE2->( GetArea() )
Local _xAreaSF1 := SF1->( GetArea() )
Local _lCodrat  := .F.
Local _nOpc := 2
// OS 1281-11 - Ajuste para visualização do novo rateio.
DbSelectArea('SF1')
DbSetOrder(2)
If DbSeek( SE2->E2_FILORIG + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM)
	If Empty(SF1->F1_XPRORAT)
		_lCodrat  := .F.
	Else	 
		_lCodrat  := .T.
		_nOpc := 0
	EndIf
EndIf	

If SE2->E2_RATESP == "1"
	U_RFINA06(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_VALOR,_nOpc,,_lCodrat)
Else
	MostraRat()
Endif

MarkBRefresh()
SF1->( RestArea( _xAreaSF1 ) )
SE2->( RestArea( _xAreaAnt ) )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ MostraRatº Autor ³ Sergio Oliveira    º Data ³  Fev/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Exibe as naturezas contidas nos itens da NFE quando o titu-º±±
±±º          ³ lo nao possuir rateios por natureza.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MostraRat()

Local   _aArea  := GetArea()
Local cLinha
Local cEol := Chr(13)+Chr(10)
Private cString := ''

cString := " SELECT D1_NATFULL, ED_DESCRIC, SUM( D1_TOTAL ) AS TOTNAT "
cString += " FROM "+RetSqlName('SD1')+" SD1, "+RetSqlName('SED')+" SED, "+RetSqlName('SF1')+" SF1 "
cString += " WHERE D1_DOC     = '"+SE2->E2_NUM+"' "
cString += " AND   D1_FORNECE = '"+SE2->E2_FORNECE+"' "
cString += " AND   D1_LOJA    = '"+SE2->E2_LOJA+"' "
cString += " AND   SD1.D_E_L_E_T_ = ' ' "
cString += " AND   F1_FILIAL  = D1_FILIAL "
cString += " AND   F1_DOC     = D1_DOC "
cString += " AND   F1_SERIE   = D1_SERIE "
cString += " AND   F1_FORNECE = D1_FORNECE "
cString += " AND   F1_LOJA    = D1_LOJA "
cString += " AND   F1_EMISSAO = '"+DtoS(SE2->E2_EMISSAO)+"' "
cString += " AND   SF1.D_E_L_E_T_ = ' ' "
cString += " AND   ED_FILIAL  = '  ' "
cString += " AND   ED_CODIGO  = D1_NATFULL "
cString += " AND   SED.D_E_L_E_T_ = ' ' "
cString += " GROUP BY D1_NATFULL, ED_DESCRIC "

U_MontaView( cString, 'Workk' )

TcSetField("Workk","TOTNAT","N",14,2)

Workk->( DbGoTop() )

cLinha := PadC("Natureza",TamSX3("D1_NATFULL")[1],"_")+"|"+PadC("Descricao",TamSX3("ED_DESCRIC")[1],"_")+"|     VALOR    "+cEol+cEol

While !Workk->( Eof() )

      cLinha += Workk->D1_NATFULL+" / "+Workk->ED_DESCRIC+" - "+Transform( Workk->TOTNAT, "@E 999,999,999.99" )+cEol

      Workk->( DbSkip() )

EndDo

Aviso("Natureza sem Rateio",cLinha,;
{"&Fechar"},3,"Itens da NFE",,;
"PCOLOCK")
	
RestArea(_aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDEF  º Autor ³Eduardo de Souza    º Data ³12/Jan/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Implementa menu funcional                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menus                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//³    3 - Duplica o registro corrente do Banco de Dados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MenuDef()
Local aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
					{"Vis.Produto","U_RFIN11PROD",0,2} ,;
					{"Cons.Rateio","U_RFIN11RT",0,2} ,;
					{"Gera Relat.","U_RFIN11GR",0,4} }
Return aRotina


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ RFIN11PROD º Autor ³ Tatiana Barbosa  º Data ³  Jun/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ tela de consulta com as seguintes informações relativas ao º±±
±±			 ³ documento de entrada do rateio posicionado.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rfina11.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFIN11PROD()

Local 	_xAreaAnt 	:= SE2->( GetArea() )
Local   _aArea  	:= GetArea()
Local 	cEol 		:= Chr(13)+Chr(10)
Local   aButton   	:= {}
Local   nOpc      	:= 0
Local   Titulo    	:= 'Detalhes dos Produtos'
Local   aSay      	:= {}
Private cString 	:= ''
Private cLinha                                                                                          

cString := " SELECT D1_COD,B1_DESC,D1_NATFULL, ED_DESCRIC, D1_TOTAL AS TOTPROD"
cString += " FROM "+RetSqlName('SD1')+" SD1, "+RetSqlName('SB1')+" SB1, "+RetSqlName('SED')+" SED, "+RetSqlName('SF1')+" SF1 "
cString += " WHERE D1_DOC     = '"+SE2->E2_NUM+"' "
cString += " AND   D1_FORNECE = '"+SE2->E2_FORNECE+"' "
cString += " AND   D1_LOJA    = '"+SE2->E2_LOJA+"' "
cString += " AND   SD1.D_E_L_E_T_ = ' ' "
cString += " AND   F1_FILIAL  = D1_FILIAL "
cString += " AND   F1_DOC     = D1_DOC "
cString += " AND   F1_SERIE   = D1_SERIE "
cString += " AND   F1_FORNECE = D1_FORNECE "
cString += " AND   F1_LOJA    = D1_LOJA "
cString += " AND   F1_EMISSAO = '"+DtoS(SE2->E2_EMISSAO)+"' "
cString += " AND   SF1.D_E_L_E_T_ = ' ' "
cString += " AND   ED_FILIAL  = '  ' "
cString += " AND   ED_CODIGO  = D1_NATFULL "
cString += " AND   SED.D_E_L_E_T_ = ' ' "
cString += " AND   B1_FILIAL  = '  ' "
cString += " AND   B1_COD  = D1_COD "
cString += " AND   SB1.D_E_L_E_T_ = ' ' "
//cString += " GROUP BY D1_NATFULL, ED_DESCRIC "

U_MontaView( cString, 'WorkkI' )

TcSetField("WorkkI","TOTPROD","N",14,2)

WorkkI->( DbGoTop() )

cLinha := PadR("Produto",20," ")+PadR("Descricao",120," ")+PadR("Natureza",TamSX3("D1_NATFULL")[1]," ")+"    "+PadR("Descricao",TamSX3("ED_DESCRIC")[1]," ")+"         "+"VALOR"//+cEol+cEol

aAdd( aSay, cLinha )

While !WorkkI->( Eof() )

//      cLinha += WorkkI->D1_COD+" "+WorkkI->B1_DESC+WorkkI->D1_NATFULL+" - "+WorkkI->ED_DESCRIC+" - "+Transform( WorkkI->TOTPROD, "@E 999,999,999.99" )+cEol
	  cLinha := PadR(WorkkI->D1_COD,20)+PadR(Alltrim(Substr(WorkkI->B1_DESC,1,60)),60, "_")+"        "+PadR(WorkkI->D1_NATFULL,TamSX3("D1_NATFULL")[1]," ")+"    "+PadR(WorkkI->ED_DESCRIC,TamSX3("ED_DESCRIC")[1]," ")+"      "+Transform( WorkkI->TOTPROD, "@E 999,999,999.99" )//+cEol	
	  
	  aAdd( aSay, cLinha )

      WorkkI->( DbSkip() )

EndDo

aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( Titulo, aSay, aButton, , 500, 900 )

//Aviso("Detalhes dos Produtos",cLinha,;
//{"&Fechar"},3,"Itens da NFE",,;
//"PCOLOCK")
	
RestArea(_aArea)

//MarkBRefresh()
SE2->( RestArea( _xAreaAnt ) )

Return

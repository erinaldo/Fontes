#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"

#DEFINE POS_TPAI		1	//Pai
#DEFINE POS_TDES		2	//Filhos
#DEFINE POS_CMPA		3	//Campos de amarracao
#DEFINE POS_PCHV		4	//Controle de posicao dos campos que compoe a chave

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImport    บAutor ณJonas L. Souza Jr    บ Data ณ  02/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa de importacao de tabelas                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ001       บAutor ณPablo Gollan Carrerasบ Data ณ  02/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ[1] Remodelacao no funcionamento do wizard e incl. painel   บฑฑ
ฑฑบ          ณ[2] Reestruturacao de variaveis de controle e referencia    บฑฑ
ฑฑบ          ณ[3] Preparacao das rotinas p/ importar cad. tab. pai x filhaบฑฑ
ฑฑบ          ณ[4] Reformulacao das funcoes de validacao e conversao dados บฑฑ
ฑฑบ          ณ[5] Tratamento p/transferir e visual.autom.arquivo de LOG   บฑฑ
ฑฑบ          ณ[6] Substituicao do SX3 por var. de estrutura das tabelas   บฑฑ
ฑฑบ          ณ    envolvidas na formatacao dos campos por tipo de dados   บฑฑ
ฑฑบ          ณ[7] Registro dos campos obigatorios envolvidos no processo  บฑฑ
ฑฑบ          ณ    para evitar que esta valid. seja feita mais de 1 vez    บฑฑ
ฑฑบ          ณ    por campo.                                              บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ002       บAutor ณPablo Gollan Carrerasบ Data ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ[1] Gravacao do arquivo SC7 na estrutura pai x filho        บฑฑ
ฑฑบ          ณ[2] Inclusao de tratamento para gravacao automatica de      บฑฑ
ฑฑบ          ณ    campos com inicializador padrao e que nao foram declara-บฑฑ
ฑฑบ          ณ    no arquivo de origem. Para evitar erros na inclusao.    บฑฑ
ฑฑบ          ณ[3] Inclusao de tratamento de erro                          บฑฑ
ฑฑบ          ณ[4] Inclusao de recurso de interrupcao de processamento ao  บฑฑ
ฑฑบ          ณ    se detectar um campo obrigatorio vazio                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Import()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nMetGlob
Local nMetParc
Local oRadioArq
Local nRadioArq			:= 1
Local cText				:= ""
Local cFile				:= Replicate(" ",80)
Local cHeader 			:= "Importa็ใo de dados"
Local cDelim			:= AllTrim(SuperGetMV("MV_TPDELI",.F.,';'))
Local nLinCabec			:= 1 										// Padrใo sem linha de cabe็alho
Local cCabec			:= "" 										// String com o cabe็alho do arquivo original, se houver
Local nQtdCab			:= 1 										// String com o cabe็alho do arquivo original, se houver
Local cTipo				:= "1"
Local nPainel			:= 1										//Controlador do sequencial de paineis
Local aTMP				:= {}
Local aLstTPN			:= {} 										//Lista de nomes das tabelas
Local cFile02			:= ""										//Nome do arquivo da tabela temporaria
Local cDrive			:= ""										//Drive do arquivo principal
Local cDir				:= ""										//Diretorio do arquivo principal
Local cArqP				:= ""										//Nome do arquivo principal
Local cExt				:= ""										//Extensao do arquivo principal
Local cTabNome			:= ""                                      	//Descricao da tabela selecionada
Local ni				:= 0										//Contador
Local nIPCOV			:= 1										//Interromper ao encontrar campo obrigatorio vazio

Static oWizard
Static oSay01
						
Private INCLUI			:= .T.
Private ALTERA			:= .F.
Private cNomeUs			:= Upper(AllTrim(UsrRetName(__cUserID)))
Private aAliasPF		:= {}										//Tabelas pai x filho e relacionamento
Private aLstObr			:= {} 										//Lista de campos obrigatorios com a seguinte estrutura para cada elemento : Alias, Campo e Titulo
Private aLstCmpSA 		:= {"A1_COD","A2_COD","A3_COD"}				//Campos com sequencia automatica
Private aLstVirtual		:= {}										//Campos virtuais que devem ser desconsiderados
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLista de tabelas para importacao. Estrutura :       ณ
//ณ[1] Para importacao de tabela unica - CARACTER      ณ
//ณ[2] Para importacao de tabelas pai x filha - ARRAY  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aLstTabP		:= {"SA1",;
								"SB1",;
								"SA2",;
								"SA3",;
								"SE1",;
								"SE2",;
								"SB9",;
								"SD5",;
								{"SN1","SN3"},;
								"SC7"}	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLista de rotinas utilizadas para gravar as importacoes. Para cada  ณ
//ณtabela, deve haver uma rotina associada na mesma posicao.          ณ
//ณA rotina pode ter apenas o seu nome declarado ou pode ser declaradaณ
//ณpor completo, em casos onde o numero de parametros seja variado    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aLstRot			:= {	{"MATA030"	,""}		,;	//SA1
								{"MATA010"	,""}		,;	//SB1
								{"MATA020"	,""}		,;	//SA2
								{"MATA040"	,""}		,;	//SA3
								{"FINA040"	,"FIN040"}	,;	//SE1
								{"FINA050"	,"FIN050"}	,;	//SE2
								{"MATA220"	,""}		,;	//SB9
								{"MATA390"	,"MTA390"}	,;	//SD5
								{"ATFA012"	,"AFA010"}	,;	//SN1 + SN3
								{"MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,aReg,aReg02,3,.F.)","MTA120"}}	//SC7
							
Private cTpArq			:= "Delimitado (*.csv)|*.CSV|Delimitado TXT (*.txt)|*.TXT|"					//Extensoes de arquivos aceitas
Private cMensProc		:= "Processando"															//Mensagem do painel de processamento
Private aEstru01		:= {}																		//Estrutura da tabela principal
Private aEstru02		:= {}																		//Estrutura da tabela secundaria
Private aLstSC7H		:= {"C7_FILIAL","C7_NUM","C7_EMISSAO","C7_FORNECE","C7_LOJA","C7_COND","C7_CONTATO","C7_FILENT","C7_MOEDA","C7_FRETE","C7_DESPESA","C7_SEGURO",;
							"C7_DESC1","C7_DESC2","C7_DESC3","C7_MSG","C7_REAJUST","C7_TXMOEDA"}
Private aLstIniPad		:= {}																		//Inicializador padrao {ALIAS,CAMPO,VALOR}
Private aLstVDes		:= {"NULL","NIL","VOID"}													//Lista de valores a desconsiderar
Private nTamFil			:= IIf(FindFunction("FWSIZEFILIAL"),FWSizeFilial(),2)						//Tamanho da filial

Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .F.
Private lAutoErrNoFile	:= .T.

If Len(aLstRot) # Len(aLstTabP)
	MsgAlert(cNomeUs + ", impossํvel executar a rotina pois existe uma diverg๊ncia entre o n๚mero de elementos da tabelas de importa็ao e as rotinas.")
	Return Nil
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao das relacoes pai x filho  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ATIVO FIXO
aAdd(aAliasPF,Array(4))
aAliasPF[Len(aAliasPF)][POS_TPAI] := "SN1"
aAliasPF[Len(aAliasPF)][POS_TDES] := "SN3"
aAliasPF[Len(aAliasPF)][POS_CMPA] := {{"N1_FILIAL","N3_FILIAL"},{"N1_CBASE","N3_CBASE"},{"N1_ITEM","N3_ITEM"}}
aAliasPF[Len(aAliasPF)][POS_PCHV] := {{0,0},{0,0},{0,0}}
//PEDIDO DE COMPRA
aAdd(aAliasPF,Array(4))
aAliasPF[Len(aAliasPF)][POS_TPAI] := "SC7"
aAliasPF[Len(aAliasPF)][POS_TDES] := "SC7"
aAliasPF[Len(aAliasPF)][POS_CMPA] := {{"C7_FILIAL","C7_FILIAL"},{"C7_NUM","C7_NUM"}}
aAliasPF[Len(aAliasPF)][POS_PCHV] := {{0,0},{0,0}}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao dos nome das tabelas a ser apresentado para selecao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX2")
SX2->(dbSetOrder(1))
For ni := 1 to Len(aLstTabP)
	If SX2->(dbSeek(IIf(ValType(aLstTabP[ni]) == "C",aLstTabP[ni],aLstTabP[ni][1])))
		aAdd(aLstTPN,Upper(AllTrim(SX2->X2_NOME)) + " (" + IIf(ValType(aLstTabP[ni]) == "C",aLstTabP[ni],aLstTabP[ni][1] + "+" + aLstTabP[ni][2]) + ")")
	Endif
Next ni
cTabNome := RetTabN(nRadioArq,aLstTPN)

cText 	:= 	 "Esta rotina tem por objetivo importar registros, atrav้s " + ; 
			 "de um arquivo padrใo CSV (delimitado) , e armazena-los na tabela "+ ; 
			 "correspondente do sistema."+ CRLF + ; 
			 "Os nomes das colunas devem ser os mesmos nomes de campos a serem atualizados."+ CRLF + CRLF + ; 
			 "Ao final da importa็ใo serแ gerado um arquivo de log contendo as "+ ; 
			 "inconsist๊ncias."

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Abertura              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE WIZARD oWizard 	TITLE "Importa็ใo de dados" ;
							HEADER cHeader ; 
							MESSAGE "Apresenta็ใo." ;
							TEXT cText ;
							NEXT { || .T. } ;
							FINISH {|| .T.} PANEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Tabelas de importacao      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Selecione os tabela que deseja importar" ;
							BACK {|| .T. } ;
							NEXT {|| .T. } ;
							FINISH {|| .F. } ;
							PANEL         

	nPainel++	
	oPanel := oWizard:GetPanel(nPainel)
	
	@ 10, 08 GROUP oGrpCon 	TO 130, 280 LABEL "Cadastro a ser importado" OF oPanel PIXEL DESIGN
	
	oRadioArq := tRadMenu():New(20,30,aLstTPN,{|x| IIf(PCount() == 0,nRadioArq,nRadioArq := x)},oPanel,,{|| cTabNome := RetTabN(nRadioArq,aLstTPN)},,,,,,180,10,,,,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Arquivo e Contrato principal ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Selecione o arquivo para importa็ใo." ;
							BACK {|| .T. } ;
							NEXT {|| !Empty(cDelim) .AND. !Empty(cFile) .AND. AllTrim(Upper(cFile02)) # AllTrim(Upper(cFile))} ;
							FINISH {|| .F. } ;
							PANEL         
	
	nPainel++
	oPanel := oWizard:GetPanel(nPainel)
	
	@ 10, 08 GROUP oGrpCon 	TO 40, 280 LABEL "Selecione um arquivo." ; 
							OF oPanel ;
							PIXEL ;
	     					DESIGN

	@ 20, 15 MSGET oArq 	VAR cFile WHEN .F. OF oPanel SIZE 180, 10 PIXEL ;
							MESSAGE "Utilize o botใo ao lado para selecionar" ; 

	DEFINE SBUTTON oButArq 	FROM 21, 200 ;
					 		TYPE 14 ;
					 		ACTION {|| cFile := Upper(cGetFile(cTpArq,,1,IIf(Empty(cDrive),"SERVIDOR\",cDrive + cDir),.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)), ;
					 		RetEstArq(cFile,@cDrive,@cDir,@cArqP,@cExt)} ; 
					 		OF oPanel ;
					 		ENABLE
	
	@ 50, 08 GROUP oGrpCon 	TO 130, 280 LABEL "Informe as configura็๕es do arquivo." ; 
							OF oPanel ;
							PIXEL ;
	     					DESIGN
	     
  	@ 60,20 SAY "Delimitador" OF oPanel SIZE 35,8 PIXEL   
	@ 60,60 MSGET oDelim	VAR cDelim  ;
							PICTURE "@!" ;
							VALID !empty(cDelim) ;
							MESSAGE "Informe um delimitador de campo." ; 
							OF oPanel SIZE 10,8 PIXEL 
                         	
  	@ 80,20 SAY "Tipo" OF oPanel SIZE 35,8 PIXEL   
	@ 80,60 COMBOBOX oTipo  Var cTipo ITEMS {"1=Somente Log","2=Log + Importa็ใo"} 	SIZE 200,010 OF oPanel PIXEL  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Arquivo secundario (tab. filha) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Selecione o arquivo para importa็ใo (TABELA FILHA)" ;
							BACK {|| .T. } ;
							NEXT {|| ValType(aLstTabP[nRadioArq]) # "A" .OR. (!Empty(cDelim) .AND. !Empty(cFile02) .AND. AllTrim(Upper(cFile02)) # AllTrim(Upper(cFile)))} ;
							FINISH {|| .F. } ;
							PANEL         
	
	nPainel++
	oPanel := oWizard:GetPanel(nPainel)
	
	@ 10, 08 GROUP oGrpCon 	TO 40, 280 LABEL "Selecione um arquivo." ; 
							OF oPanel ;
							PIXEL ;
	     					DESIGN

	@ 20, 15 MSGET oArq 	VAR cFile02 WHEN .F. OF oPanel SIZE 180, 10 PIXEL ;
							MESSAGE "Utilize o botใo ao lado para selecionar" ; 

	DEFINE SBUTTON oButArq 	FROM 21, 200 ;
					 		TYPE 14 ;
					 		ACTION {|| cFile02 := Upper(cGetFile(cTpArq,,1,IIf(Empty(cDrive),"SERVIDOR\",cDrive + cDir),.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)), ;
					 		RetEstArq(cFile02,@cDrive,@cDir,@cArqP,@cExt)} ; 
					 		OF oPanel ;
					 		WHEN UsaTabSec(nRadioArq) ;
					 		ENABLE

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Confirmacao  / Processamento          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Confirma็ใo dos dados e inํcio de processamento." ; 
							BACK {|| .T. } ;
							NEXT {|| .T. } ;
							FINISH {|| .F. } ;
							PANEL         
							
	nPainel++
	oPanel := oWizard:GetPanel(nPainel)

	@ 010, 010 SAY "Arquivo" OF oPanel SIZE 140, 8 PIXEL   
	@ 010, 050 SAY Upper(AllTrim(cFile))  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL  
	
	@ 030, 010 SAY  "Delimitador" OF oPanel SIZE 140, 8 PIXEL   
	@ 030, 050 SAY  cDelim  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	

	@ 050, 010 SAY  "Cadastro" OF oPanel SIZE 140, 8 PIXEL   
	@ 050, 050 SAY  cTabNome OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	

	@ 070, 010 SAY  "Tipo Proc.:" OF oPanel SIZE 140, 8 PIXEL   
	@ 070, 050 SAY  Upper(IIf(cTipo == "1","Somente Log","Log+Importa็ใo")) OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	

	@ 090, 010 SAY "Arquivo secundแrio (tab. filha)" OF oPanel SIZE 140, 8 PIXEL   
	@ 090, 090 SAY Upper(AllTrim(cFile02))  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL                                        

  	@ 110, 010 SAY "Interromper o processamento ao encontrar campo obrigat๓rio vazio?" OF oPanel SIZE 200,008 PIXEL   
	@ 120, 010 COMBOBOX oIPCOV Var nIPCOV ITEMS {"1=Sim","2=Nใo"} SIZE 030,010 OF oPanel PIXEL  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Processamento                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Processamento da Importa็ใo." ; 
							BACK {|| .F. } ;
							NEXT {|| .T. } ;
							FINISH {|| .T. } ;
							EXEC {|| CursorWait(), IMPCADPro(oMetGlob,nRadioArq,cFile,cDelim,cTipo,cFile02,nIPCOV), CursorArrow() } ;
							PANEL 
							        
	nPainel++
	oPanel := oWizard:GetPanel(nPainel)

	@ 25, 30 SAY oSay01 VAR cMensProc OF oPanel SIZE 140, 8 PIXEL   
	@ 40, 30 METER oMetGlob 	VAR nMetGlob ;
								TOTAL 100 ;
								SIZE 224,10 OF oPanel PIXEL UPDATE DESIGN ;
								BARCOLOR CLR_BLACK,CLR_WHITE ;
								COLOR CLR_WHITE,CLR_BLACK 
	
ACTIVATE WIZARD oWizard CENTER

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCADPro บAutor  ณJonas L. Souza Jr   บ Data ณ  02/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao do arquivo selecionado                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ01        บAutor ณPablo Gollan Carrerasบ Data ณ  02/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVide cabecalho principal                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPCADPro(oMetGlob,nRadioArq,cFile,cDelim,cTipo,cFile02,nIPCOV)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea				:= GetArea()
Local lFirst			:= .T.
Local cLinha 			:= ""
Local aHeader			:= {}
Local nHdl    			:= 	0
Local cEnvServ			:= GetEnvServer()
Local cIniFile			:= GetADV97()
Local cEnd				:= GetPvProfString(cEnvServ,"StartPath","",cIniFile)   
Local cDtHr 			:= DtoS(dDataBase)+"-"+Substr(time(),1,2)+"-"+Substr(time(),4,2)+"-"+Substr(time(),7,2)
Local cPath				:= "\IMPORT\"
Local cTipoLog			:= "Import_"
Local cNomeLog			:=	cPath + cTipoLog + cDtHr + "_Log.txt"
Local cArq				:=	cEnd + cNomeLog              
Local cLin				:= ""   
Local cCdAlias			:= ""
Local nQtReg			:= 0
Local nQtNOk			:= 0
Local nQtOk				:= 0
Local aLog				:= {}
Local lGrava			:= (cTipo == "2")   
Local cRotina			:= ""
Local nCont				:= 0
Local lProcFilho		:= .F.							//Processar tabela filha?
Local cCdAlias02		:= ""							//Alias para a tabela filha
Local nPos				:= 0		   					//Posicionador
Local nPos02			:= 0							//Posicionador
Local aPosCMP			:= {}							//Posicao de campos
Local nTot02			:= 0							//Totalizador
Local aHeader02			:= {}							//Cabecalho do arquivo referente a tabela filha
Local aDados02			:= {}							//Conteudo do arquivo referente a tabela filha
Local aTMP				:= {}							//Array temporario
Local ni				:= 0							//Contador
Local cFiltro			:= ""							//Filtro de pesquisa
Local aCols02			:= {}							//Array
Local lOk				:= .T.							//Controlador de fluxo
Local nAtu				:= 0							//Registro atual do arquivo de importacao
Local cTMP				:= ""							//Temporaria
Local cDirRem			:= AllTrim(GetClientDir())		//Diretorio do remote
Local lPedComp			:= .F.							//Rotina de pedido de compras?
Local aLstPCProc		:= {}							//Pedidos de compra processados
Local bErro				:= {|| }
Local lErro				:= .F.
Local cErro				:= ""
Local lIPCOV			:= .F.

Default oMetGlob		:= Nil
Default nRadioArq		:= 0 
Default cFile			:= "" 
Default cDelim			:= ""
Default cTipo			:= ""
Default cFile02			:= ""
Default nIPCOV			:= 2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidacao de parametros  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If oMetGlob == Nil .OR. Empty(nRadioArq) .OR. Empty(cFile) .OR. Empty(cDelim) .OR. Empty(cTipo)
	Return Nil
Endif
lIPCOV := (AllTrim(AllToChar(nIPCOV)) == "1")
//Criar diretorio caso seja necessario
MakeDir(cEnd + cPath)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidacao do arquivo para importacao             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !File(cFile) .OR. Empty(cFile)
	ApMsgStop("Problemas com arquivo informado!")
	RestArea(aArea)
	Return Nil
EndIf
cCdAlias 	:= IIf(ValType(aLstTabP[nRadioArq]) == "A",aLstTabP[nRadioArq][1],aLstTabP[nRadioArq])
cRotina		:= aLstRot[nRadioArq][1]
lPedComp 	:= At("MATA120",Upper(cRotina)) > 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlgumas rotinas exigem alguns campos como obrigatorios               ณ
//ณpara rotinas automaticas, embora no dicionario estes nao estejam     ณ
//ณdefinidos como tal. Para estes casos, declarar estes campos          ณ
//ณ"especiais" inicialmente na lista de campos com inicializador padrao ณ
//ณou na lista de campos obrigatorios.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do Case
	Case cCdAlias == "SC7"
		aAdd(aLstIniPad,{"SC7","C7_EMISSAO","dDataBase"})
		aAdd(aLstIniPad,{"SC7","C7_CONTATO","Space(1)"})
		aAdd(aLstIniPad,{"SC7","C7_FILENT","xFilial('" + cCdAlias + "')"})
EndCase
//Carregar campos obrigatorios e inicializadores padrao
SX3Load(cCdAlias)
If lPedComp
	nPos := aScan(aAliasPF,{|x| x[POS_TPAI] == Upper(AllTrim(cCdAlias))})
	lProcFilho := .T.
	cCdAlias02 := cCdAlias
	cFile02 := cFile
	//Carregar campos obrigatorios e inicializadores padrao
	SX3Load(cCdAlias02)
Else
	lProcFilho := IIf((nPos := aScan(aAliasPF,{|x| x[POS_TPAI] == Upper(AllTrim(cCdAlias))})) == 0,.F.,.T.)
	If lProcFilho
		cCdAlias02 := aAliasPF[nPos][POS_TDES]
		//Carregar campos obrigatorios e inicializadores padrao
		SX3Load(cCdAlias02)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValidacao do segundo arquivo para importacao     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !File(cFile02) .OR. Empty(cFile02)
			RestArea(aArea)
			Return Nil
		EndIf	
	Endif
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEstrutura das tabelas envolvidas  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aEstru01 := (cCdAlias)->(dbStruct())
If lProcFilho
	aEstru02 := (cCdAlias02)->(dbStruct())
Endif
Eval({|| cMensProc := OemToAnsi("Iniciando o LOG"),oSay01:Refresh()})
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia LOG    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aLog,Replicate("=",80))
aAdd(aLog,"INICIANDO O LOG - I M P O R T A C A O   D E   D A D O S")
aAdd(aLog,Replicate("-",80))
aAdd(aLog,"DATABASE...........: " + DtoC(dDataBase))
aAdd(aLog,"DATA...............: " + DtoC(Date()))
aAdd(aLog,"HORA...............: " + Time())
aAdd(aLog,"ENVIRONMENT........: " + GetEnvServer())
aAdd(aLog,"PATCH..............: " + GetSrvProfString("StartPath",""))
aAdd(aLog,"ROOT...............: " + GetSrvProfString("RootPath",""))
aAdd(aLog,"VERSรO.............: " + GetVersao())
aAdd(aLog,"MำDULO.............: " + "SIGA" + cModulo)
aAdd(aLog,"EMPRESA / FILIAL...: " + cEmpAnt + "/" + cFilAnt)
aAdd(aLog,"NOME EMPRESA.......: " + Capital(Trim(SM0->M0_NOME)))
aAdd(aLog,"NOME FILIAL........: " + Capital(Trim(SM0->M0_FILIAL)))
aAdd(aLog,"USUมRIO............: " + SubStr(cUsuario,7,15))
aAdd(aLog,"TABELA IMPORT......: " + cCdAlias)
aAdd(aLog,"ARQUIVO IMPORT.....: " + cFile)
aAdd(aLog,"DELIMITADOR........: " + cDelim)
aAdd(aLog,"MODO PROCESSAMENTO.: " + IIf(lGrava,"Atualizacao","Simulacao"))
aAdd(aLog,"ROTINA IMPORTACAO..: " + Upper(cRotina))
aAdd(aLog,Replicate(":",80))
aAdd(aLog,"")
If lProcFilho
	aAdd(aLog,"DADOS DA TABELA FILHA")
	aAdd(aLog,Replicate("-",80))
	aAdd(aLog,"TABELA IMPORT 02...: " + cCdAlias02)
	aAdd(aLog,"ARQUIVO IMPORT 02..: " + cFile02)
	aAdd(aLog,Replicate(":",80))
	aAdd(aLog,"")
Endif
aAdd(aLog,"Import = INICIO - Data " + DtoC(dDataBase)+ " as " + Time())
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso exista tabela filha relacionada, direcionar seu conteudo   ณ
//ณpara variaveis, para processamento posterior                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lProcFilho .OR. lPedComp
	Eval({|| cMensProc := OemToAnsi("Validando o conte๚do do arquivo da tabela filha [" + cCdAlias02 + "]"),oSay01:Refresh()})
	FT_FUSE(cFile02)
	nTot02 := FT_FLASTREC()
	If nTot02 == 0
		ApMsgStop("Nenhum registro foi encontrado no arquivo de importa็ใo para tabela filha (" + cCdAlias02 + ")")
		Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
		RestArea(aArea)
		Return
	Endif
	oMetGlob:SetTotal(nTot02)	
	FT_FGOTOP()
	While !FT_FEOF()
		nAtu++
		oMetGlob:Set(nAtu)
		If Empty(cLinha := LeLinha()) .OR. (!lFirst .AND. cLinha == Replicate(";",Len(aHeader02) - 1))
			FT_FSKIP()
			Loop
		Endif
		Eval({||aCols := Array(0),	aCols := TrataCols(cLinha,cDelim)})
		If lFirst
			aHeader := aClone(aCols)
			lFirst := !lFirst
			If !Empty(cCpos := ImpVldCols(cCdAlias02,aHeader,aEstru02))
				Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
				ApMsgStop("Problemas na estrutura do arquivo, faltam as seguintes colunas : " + CRLF + cCpos)
				RestArea(aArea)
				Return
			EndIf
			//Adicionar os campos com inicializacao padrao que nao estao presentes
			AdCmpIni(cCdAlias02,@aHeader)
			aHeader02 := aClone(aHeader)
		Else
			cMsg := ImpObrigat(cCdAlias02,aCols,aHeader02,,aEstru02)
			If !Empty(cMsg)
				If lIPCOV
					Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
					ApMsgStop("ERRO : " + CRLF + cMsg)
					RestArea(aArea)
					Return
				Else
					AtuLog("NO MOT: CAMPOS OBRIGATORIOS - REGISTRO IGNORADO - " + cMsg,@aLog,nAtu)
					nQtNOk++
					FT_FSKIP()
					Loop
				Endif
			Else
				aAdd(aDados02,aClone(aCols))
			EndIf
		Endif
		FT_FSKIP()
	EndDo
	FT_FUSE()
	aHeader := {}
	lFirst := .T.
	Eval({|| cMensProc := OemToAnsi("Processando arquivo principal e secundแrio [" + cCdAlias + "+" + cCdAlias02 + "]"),oSay01:Refresh()})
Else
	Eval({|| cMensProc := OemToAnsi("Processando arquivo principal [" + cCdAlias + "]"),oSay01:Refresh()})
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLeitura do arquivo principal              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FT_FUSE(cFile)
nTot := FT_FLASTREC()
nAtu := 0
oMetGlob:SetTotal(nTot)
oMetGlob:Set(0)
CursorWait()     
FT_FGOTOP()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento do arquivo principal  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !FT_FEOF()
	nAtu++
	oMetGlob:Set(nAtu)
	cLinha := LeLinha() //FT_FREADLN()
	If Empty(cLinha) .OR. (!lFirst .AND. cLinha == Replicate(";",Len(aHeader) - 1))
		FT_FSKIP()
		Loop
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento de colunas                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCols 	:= {}
	aCols 	:= TrataCols(cLinha,cDelim)
	aCols02	:= {}
	If lFirst
		aHeader := aClone(aCols)
		lFirst := .F.
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida nomes das colunas                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cCpos := ImpVldCols(cCdAlias,aHeader,aEstru01)
		If !Empty(cCpos)
			Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
			ApMsgStop("Problemas na estrutura do arquivo, faltam as seguintes colunas " + CRLF + cCpos)
			RestArea(aArea)
			Return Nil
		EndIf
		//Adicionar os campos com inicializacao padrao
		AdCmpIni(cCdAlias,@aHeader)
		If lProcFilho
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณValida se os campos de relacionamento entre tabelas ณ
			//ณpai x filha estao presentes                         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aPos := Array(Len(aAliasPF[nPos][POS_PCHV]),2)
			aTMP := aAliasPF[nPos][POS_CMPA]
			For ni := 1 to Len(aTMP)                                                         
				aPos[ni][1] := aScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(AllTrim(aTMP[ni][1]))})
				aPos[ni][2] := aScan(aHeader02,{|x| Upper(AllTrim(x)) == Upper(AllTrim(aTMP[ni][2]))})
				If aPos[ni][1] == 0 .OR. aPos[ni][2] == 0
					Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
					ApMsgStop("Os campos obrigatorios de relacionamento entre as tabelas " + aAliasPF[nPos][POS_TPAI] + " e " + aAliasPF[nPos][POS_TDES] + " nใo estใo presentes!")
					RestArea(aArea)
					Return Nil
				Else
					//Armazenar cada posicao dos campos de chave para efetuar posteriormente a busca
					aAliasPF[nPos][POS_PCHV][ni][1] := aPos[ni][1]
					aAliasPF[nPos][POS_PCHV][ni][2] := aPos[ni][2]
				Endif
			Next ni
		EndIf
	Else
		//Caso seja pedido de compra, verificar se o cabecalho jah nao foi inserido, caso tenha sido, desconsiderar
		If lPedComp
			If aScan(aLstPCProc,{|x| AllTrim(x[1]) == aCols[aScan(aHeader,{|x| Upper(AllTrim(x)) == "C7_FILIAL"})] .AND. ;
				AllTrim(x[2]) == aCols[aScan(aHeader,{|x| Upper(AllTrim(x)) == "C7_NUM"})] }) > 0
				
				FT_FSKIP()
				Loop
			Else
				aAdd(aLstPCProc,{AllTrim(aCols[aScan(aHeader,{|x| Upper(AllTrim(x)) == "C7_FILIAL"})]), ;
					AllTrim(aCols[aScan(aHeader,{|x| Upper(AllTrim(x)) == "C7_NUM"})]) })
			Endif
		Endif		
		nQtReg++
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValidacao de campos obrigatorios                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ImpObrigat(cCdAlias,aCols,aHeader,,aEstru01)
		If !Empty(cMsg)
			If lIPCOV
				Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
				ApMsgStop("ERRO : " + CRLF + cMsg)
				RestArea(aArea)
				Return
			Else		
				AtuLog("NO MOT: CAMPOS OBRIGATORIOS - REGISTRO IGNORADO - "+cMsg,@aLog,nAtu)
				nQtNOk++
				FT_FSKIP()
				Loop
			Endif
		EndIf
		If lProcFilho
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณProcurar os itens na tabela filha  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aTMP 	:= aAliasPF[nPos][POS_CMPA]
			lOk		:= .T.
			nPos02	:= 0
			Do While lOk
				cFiltro := "{|x| "
				For ni := 1 to Len(aTMP)
					cFiltro += "AllTrim(x[" + cValtoChar(aAliasPF[nPos][POS_PCHV][ni][2]) + "]) == '" + AllTrim(aCols[aAliasPF[nPos][POS_PCHV][ni][1]]) + "'" + IIf(ni < Len(aTMP)," .AND. ","}")
				Next ni
				If (nPos02 := aScan(aDados02,&(cFiltro),nPos02 + 1)) == 0
					lOk := .F.
				Else
					aAdd(aCols02,aDados02[nPos02])
				EndIf
			EndDo
			If Len(aCols02) == 0
				AtuLog("NO MOT: REG. NAO ENCONTRADO NO ARQ. DA TAB. FILHA (" + aAliasPF[nPos][POS_TDES] + ") - REGISTRO IGNORADO - ",@aLog,nAtu)
				nQtNOk++
				FT_FSKIP()
				Loop				
			Endif
		Endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณChamada de rotina automatica de inclusao                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lGrava
			aRet := {}
			bErro := ErrorBlock({|e| VerErro(e,@lErro,@cErro)})
			Begin Sequence
			If !lProcFilho
				aRet := ImpGrava(cCdAlias,cRotina,aCols,aHeader,,,,FT_FRECNO())
			Else
				aRet := ImpGrava(cCdAlias,cRotina,aCols,aHeader,cCdAlias02,aCols02,aHeader02,FT_FRECNO())
			Endif
			Recover
			End Sequence
			If lErro
				Alert(cErro)
				RestArea(aArea)
			    Return Nil
			Endif
			ErrorBlock(bErro)			
			If aRet[1]
				nQtOk++
				AtuLog("OK MOT:REGISTRO INCLUIDO" + aRet[2],@aLog,nAtu)
			Else
				AtuLog("NO MOT: PROBLEMAS NA GRAVACAO ROTINA AUTOMATICA - " + cRotina + " - " + aRet[2],@aLog,nAtu)
				nQtNOk++
			EndIf
		Else
			nQtOk++
			AtuLog("OK MOT:REGISTRO INCLUIDO",@aLog,nAtu)
		EndIf
	EndIf
	FT_FSKIP()
EndDo
FT_FUSE()
Eval({|| cMensProc := OemToAnsi("Finalizando"),oSay01:Refresh()})
aAdd(aLog, "Import = Total de Registros = "+ Alltrim(Str(nQtReg)))
aAdd(aLog, "Import = Registros Nao importados = "+ Alltrim(Str(nQtNOk)))
aAdd(aLog, "Import = Registros importados = "+ Alltrim(Str(nQtOk)))
aAdd(aLog, "Import = FIM Data "+DtoC(dDataBase)+ " as "+Time() )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFinaliza arquivo de Log                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nHdl := fCreate(cArq)
If nHdl == -1
	Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
	MsgAlert("O arquivo  " + cArq + " nao pode ser criado!","Atencao!")
	fClose(nHdl)
	fErase(cArq)
	RestArea(aArea)
 	Return Nil
EndIf
For nCont := 1 to Len(aLog)
	cLin += aLog[nCont] + CRLF
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		fClose(nHdl)
	    fErase(cArq)
	    cLin:=""
		RestArea(aArea)
	    Return Nil
	EndIf
	cLin:=""
Next nCont
fClose(nHdl)
Eval({|| cMensProc := OemToAnsi("Processo de importa็ใo concluํdo!"),oSay01:Refresh()})
If ApMsgYesNo(cNomeUs + ", deseja visualizar o arquivo de LOG?")
	cTMP := cTipoLog + cDtHr + "_Log.txt"
	//Se o arquivo de log existir localmente, excluir
	If File(cDirRem + cTMP)
		fErase(cDirRem + cTMP)
	Endif
	//Copiar do servidor para a estacao
	If CpyS2T(cArq,cDirRem,.F.)
		ShellExecute("open",cDirRem + cTMP,"","",1)
	Endif
Endif
RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuLog    บAutor  ณJonas L. Souza Jr   บ Data ณ  07/20/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza Array de Log                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuLog(cMsg,aLog,nAtu)

aAdd(aLog," Import = Linha " + StrZero(nAtu,12) + " = " + " LOG = " + cMsg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLeLinha   บAutor  ณJonas L. Souza Jr   บ Data ณ  02/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento de leitura de linha TXT, principalmente para     บฑฑ
ฑฑบ          ณcasos de ultrapassar 1Kb por linha                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LeLinha()

Local cLinhaTmp := ""
Local cLinhaM100 := ""

cLinhaTmp := FT_FReadLN()

If !Empty(cLinhaTmp)
	cIdent:= Substr(cLinhaTmp,1,1)
	If Len(cLinhaTmp) < 1023
		cLinhaM100 := cLinhaTmp
	Else
		cLinAnt := cLinhaTmp
		cLinhaM100 += cLinAnt
		FT_FSkip()
		cLinProx := FT_FReadLN()
		If Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent
			While Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent .and. !Ft_fEof()
				cLinhaM100 += cLinProx
				FT_FSkip()
				cLinProx := FT_FReadLn()
				If Len(cLinProx) < 1023 .and. Substr(cLinProx,1,1) <> cIdent
					cLinhaM100 += cLinProx
				Endif
			Enddo
		Else
			cLinhaM100 += cLinProx
		Endif
	Endif
Endif

Return(cLinhaM100)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrataCols บAutor  ณJonas L. Souza Jr   บ Data ณ  07/20/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna array com as colunas da linha informada             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TrataCols(cLinha,cSep,aEstru)

Local aRet 				:= {}
Local nPosSep			:= 0
Local aCmpNome         	:= ""
						
nPosSep	:= At(cSep,cLinha)
While nPosSep <> 0
	aCmpNome := Upper(AllTrim(SubStr(cLinha,1,nPosSep - 1)))
	aAdd(aRet,aCmpNome)
	cLinha := SubStr(cLinha,nPosSep + 1)
 	nPosSep	:= At(cSep,cLinha)
EndDo
aAdd(aRet,cLinha)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณRetCol    บAutor ณPablo Gollan Carreraบ Data ณ  03/12/10    บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o conteudo formatado de uma dada coluna de acordo   บฑฑ
ฑฑบ          ณcom o seu tipo de dados                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetCol(cCpo,aCols,aHeader,aEstru,cAlias)

Local uRet 				:= ""
Local nPos				:= 0
Local nPos02			:= 0
Local aCmpPZero			:= {"N1_ITEM","N3_TIPO","N3_SEQ"}			//Campos que devem ser preenchidos com zero

If Empty(cCpo) .OR. Len(aCols) == 0 .OR. Len(aHeader) == 0 .OR. Len(aEstru) == 0
	Return uRet
Endif
If (nPos := aScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim(cCpo))})) > 0 .AND. nPos <= Len(aCols)
	If (nPos02 := aScan(aEstru,{|x| Upper(AllTrim(x[1])) == Upper(Alltrim(cCpo))})) > 0
		Do Case
			Case aEstru[nPos02][2] == "D"
				//Caso o campo nao esteja vazio ou nao esteja preenchido com valores que indicam NULO
				If !Empty(aCols[nPos]) .AND. aScan(aLstVDes,{|x| x == Upper(AllTrim(aCols[nPos]))}) == 0
					If At("/",aCols[nPos]) == 0
						uRet := StoD(aCols[nPos])
					Else
						uRet := CtoD(aCols[nPos])
					Endif				
				Else
					uRet := CtoD("")
				Endif
			Case aEstru[nPos02][2] == "N"
				//Caso o campo nao esteja vazio ou nao esteja preenchido com valores que indicam NULO
				If !Empty(aCols[nPos]) .AND. aScan(aLstVDes,{|x| x == Upper(AllTrim(aCols[nPos]))}) == 0
					uRet := GetDtoVal(AllTrim(aCols[nPos]))
				Else
					uRet := 0
				Endif
			Otherwise
				//Caso o campo esteja preenchido com valores que indicam NULO, zerar
				If aScan(aLstVDes,{|x| x == Upper(AllTrim(aCols[nPos]))}) > 0
					aCols[nPos] := ""
				Endif
				//Validar se o campo eh de filial, se for preencher com zeros a esquerda
				If Right(aEstru[nPos02][1],7) == "_FILIAL"
					If SX2Modo(cAlias) == "C"
						uRet := Space(nTamFil)
					Else
						If !Empty(aCols[nPos])
							uRet := PadL(Upper(AllTrim(aCols[nPos])),nTamFil,"0")
						Else
							uRet := Space(nTamFil)
						Endif
					Endif
				Else
					//Verificar se o campo nao esta categorizado para ter seus espacos preenchidos com zero
					If aScan(aCmpPZero,{|x| x = Upper(AllTrim(cCpo))}) == 0
						uRet := PadR(Upper(AllTrim(aCols[nPos])),aEstru[nPos02][3])
					Else
						uRet := PadL(Upper(AllTrim(aCols[nPos])),aEstru[nPos02][3],"0")
					Endif
				Endif
		EndCase
	Else
		If nPos <= Len(aCols)
			If !Empty(aCols[nPos]) .AND. aScan(aLstVDes,{|x| x == Upper(AllTrim(aCols[nPos]))}) == 0
				uRet := Upper(AllTrim(aCols[nPos]))
			Endif
		Endif
	Endif
Endif

Return uRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpVldColsบAutor  ณJonas L. Souza Jr   บ Data ณ  02/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnalise de colunas obrigatorias para cada alias             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ001       บAutor ณPablo Gollan Carrerasบ Data ณ  01/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณUtilizacao da funcao ImpObrigat para validar os campos do   บฑฑ
ฑฑบ          ณcabecalho do arquivo                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpVldCols(cCdAlias,aHeader,aEstru)

Local cRet 				:= ""
Local ni				:= 0

Default aEstru			:= {}

cRet := ImpObrigat(cCdAlias,,aHeader,.T.)
If Empty(cRet) .AND. Len(aEstru) > 0
	//Verificar se no cabecalho existe alguma coluna que nao existe no dicionario de dados
	For ni := 1 to Len(aHeader)
		//Caso o campo seja virtual, nao validar com a estrutura
		If aScan(aLstVirtual,{|x| x == Upper(AllTrim(aHeader[ni]))}) == 0
			If aScan(aEstru,{|x| Upper(AllTrim(x[1])) == Upper(AllTrim(aHeader[ni]))}) == 0
				cRet += "A coluna " + Upper(AllTrim(aHeader[ni])) + " nใo consta no dicionแrio de dados!" + CRLF
			Endif
		Endif
	Next ni
Endif

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpObrigatบAutor  ณJonas L. Souza JR   บ Data ณ  02/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida preenchimento/conteudo de campos obrigatorios        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ001       บAutor ณPablo Gollan Carrerasบ Data ณ  15/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFazer com que a rotina monte a lista de campos obrigatorios บฑฑ
ฑฑบ          ณatraves do dicionario de dados e nao de campos chumbados.   บฑฑ
ฑฑบ          ณ------------------------------------------------------------บฑฑ
ฑฑบ          ณExpansao da funcionalidade que valida conteudo de campos e  บฑฑ
ฑฑบ          ณo campos do cabecalho do arquivo.                           บฑฑ
ฑฑบ          ณ------------------------------------------------------------บฑฑ
ฑฑบ          ณTratamento para ignorar campo vazios que possuam sequencia  บฑฑ
ฑฑบ          ณautomatica.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTotvs                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpObrigat(cCdAlias,aCols,aHeader,lVldHead,aEstru)

Local cRet 				:= ""
Local ni				:= 0
Local cTMP				:= ""

Default aCols			:= {}
Default lVldHead		:= .F.
Default aEstru			:= {}

If Empty(cCdAlias)
	Return cRet
Endif
cCdAlias := AllTrim(Upper(cCdAlias))

If !lVldHead
	//Validar se os campos obrigatorios da tabela nao estao vazios no registros passado
	For ni := 1 to Len(aLstObr)
		If aLstObr[ni][1] == cCdAlias
			//Se o conteudo do campo obrigatorio estiver vazio e o campo nao estiver na lista de campos de sequencia automatica
			cTMP := RetCol(aLstObr[ni][2],aCols,aHeader,aEstru,cCdAlias)
			If Empty(cTMP) .AND. aScan(aLstCmpSA,{|x| AllTrim(Upper(x)) == aLstObr[ni][2]}) == 0
				cRet += "A coluna obrigat๓ria " + aLstObr[ni][2] + " (" + aLstObr[ni][3] + ") estแ vazia!" + CRLF
			Endif
		Endif
	Next ni
Else
	//Validar se os campos obrigatorios da tabela constam no header do arquivo
	For ni := 1 to Len(aLstObr)
		If aLstObr[ni][1] == cCdAlias
			If aScan(aHeader,{|x| Upper(AllTrim(x)) == aLstObr[ni][2]}) == 0
				cRet += "A coluna obrigat๓ria " + aLstObr[ni][2] + " (" + aLstObr[ni][3] + ") nใo consta no cabe็alho do arquivo!" + CRLF
			Endif
		Endif
	Next ni	
Endif

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpGrava  บAutor  ณJonas L. Souza Jr   บ Data ณ  02/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamada da rotina automatica de gravacao                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ01        บAutor ณPablo Gollan Carrerasบ Data ณ  02/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVide cabecalho principal                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpGrava(cCdAlias,cRotina,aCols,aHeader,cCdAlias02,aCols02,aHeader02,nLinProc)

Local nx				:= 0
Local ni				:= 0
Local lOk				:= .F.
Local cMsg				:= ""
Local lGeraNumSeq		:= .F.
Local nPosSA			:= 0
Local cArqErro			:= "ERRO_AUTO.TXT"
Local lTemFil			:= .F.
Local lTemFil02			:= .F.
Local cCpoFil 			:= IIf(SubStr(cCdAlias,1,1) == "S", SubStr(cCdAlias,2,2), cCdAlias) + "_FILIAL"
Local cCpoFil02 		:= ""
Local cFilAlia			:= xFilial(cCdAlias)
Local cFilAlia02		:= ""
Local lProcFilho		:= .F.
Local uTMP				:= Nil
Local cCMPAt			:= ""									//Nome do campo atual
Local aTMP				:= {} 									//Array temporaria
Local cREG				:= ""									//Referencia do registro processado
Local lPedComp			:= At("MATA120",Upper(cRotina)) > 0	//Rotina de pedido de compras?
Local aErro				:= {}
Local nTamItem			:= TamSX3("C7_ITEM")[1]
Local nPosVP			:= 0									//Posicao do valor padrao de campos
Local lGrvVazio			:= .F.									//Gravar mesmo vazio
Local nPosRot			:= 0									//Posicionador para busca de rotina

Private aReg			:= {}
Private aReg02			:= {}
Private cRotAuto		:= ""

Default cCdAlias02		:= ""
Default aCols02			:= {}
Default aHeader02		:= {}
Default nLinProc		:= 0

If !Empty(cCdAlias02) .AND. ValType(aCols02) == "A" .AND. Len(aCols02) # 0 .AND. ValType(aHeader02) == "A" .AND. Len(aHeader02) # 0
	lProcFilho := .T.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta array com os campos do registro                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nx := 1 to Len(aHeader)
	cCMPAt := Upper(Alltrim(aHeader[nx]))
	//Saltar se o campo for virtual
	If aScan(aLstVirtual,{|x| x == cCMPAt}) > 0
		Loop
	Endif
	//Verificar se o campo do header do arquivo existe na estrutura da tabela de destino
	If aScan(aEstru01,{|x| Upper(AllTrim(x[1])) == cCMPAt}) > 0
		uTMP := RetCol(cCMPAt,aCols,aHeader,aEstru01,cCdAlias)
		lGrvVazio := .F.
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se possui campo sequencial informado                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nPosSA == 0 .AND. Empty(uTMP) .AND. (nPosSA := aScan(aLstCmpSA,{|x| AllTrim(Upper(x)) == AllTrim(Upper(aHeader[nx]))})) > 0
			lGeraNumSeq := .T.	
		Else
			//Caso o campo esteja vazio, se tiver, utilizar o inicializador padrao
			If Empty(uTMP)
				If lPedComp
					//Caso seja um pedido de compra, verificar se o campo nao eh de cabecalho, senao saltar
					If aScan(aLstSC7H,{|x| x == Upper(AllTrim(cCMPAt))}) == 0
						Loop
					Endif
				Endif
				If (nPosVP := aScan(aLstIniPad,{|x| x[1] == Upper(AllTrim(cCdAlias)) .AND. x[2] == cCmpAt})) > 0
					lGrvVazio := .T.
					//Se nao utiliza memvar, inicializar o campo
					If At("->",aLstIniPad[nPosVP][3]) == 0
						uTMP := &(aLstIniPad[nPosVP][3])
					Endif
				Endif
			Endif
			//Caso o conteudo do campo definido no arquivo de origem nao seja nulo, adicionar
			If !Empty(uTMP) .OR. lGrvVazio
				//Adicionar ao array que sera passado para rotina automatica
				If !lPedComp
					aAdd(aReg,{cCMPAt,uTMP,Nil})
				Else
					//Caso seja um pedido de compra, verificar se o campo eh de cabecalho ou item
					If aScan(aLstSC7H,{|x| x == Upper(AllTrim(cCMPAt))}) > 0
						aAdd(aReg,{cCMPAt,uTMP,Nil})
					Endif
				Endif
			Endif
		Endif	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se informou filial no arquivo              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lTemFil
			If cCMPAt == cCpoFil
				lTemFil := .T.
		    EndIf
		Endif
	Endif
Next nx
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso seja necessario determinar numero sequencial  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lGeraNumSeq
	//Deve haver um tratamento especial no SC7, que utiliza uma funcao propria para determinar a proxima sequencia
	If cCdAlias == "SC7"
		aAdd(aReg,{"C7_NUM",GetNumSC7(),Nil})	
	Else
		aAdd(aReg,{aLstCmpSA[nPosSA],GetSXENum(cCdAlias),Nil})
	Endif
	ConfirmSX8()
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso o campo de filial nao tenha sido informado, alimentar  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lTemFil .AND. !Empty(cCpoFil)
	aAdd(aReg,{cCpoFil,cFilAlia,Nil})
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessar itens da tabela filho  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lProcFilho
	cCpoFil02 	:= IIf(SubStr(cCdAlias02,1,1) == "S",SubStr(cCdAlias02,2,2),cCdAlias02) + "_FILIAL"
	cFilAlia02	:= xFilial(cCdAlias02)
	//Varrer os registros filhos associados ao pai
	For nx := 1 to Len(aCols02)
		aAdd(aReg02,{})
		aTMP := {}
		//Varrer o header da tabela filha (secundaria)
		For ni := 1 to Len(aHeader02)
			cCMPAt := Upper(Alltrim(aHeader02[ni]))
			lGrvVazio := .F.
			If lPedComp
				//Caso seja um pedido de compra, verificar se o campo eh de cabecalho, se for saltar
				If aScan(aLstSC7H,{|x| x == cCMPAt}) > 0
					Loop
				Endif
			Endif
			//Verificar se o campo do header do arquivo existe na estrutura da tabela de destino
			If aScan(aEstru02,{|x| Upper(AllTrim(x[1])) == cCMPAt}) > 0
				uTMP := RetCol(cCMPAt,aCols02[nx],aHeader02,aEstru02,cCdAlias02)
				//Caso o campo esteja vazio, se tiver, utilizar o inicializador padrao
				If Empty(uTMP)
					If lPedComp
						//Caso seja um pedido de compra, verificar se o campo eh de cabecalho, se for saltar
						If aScan(aLstSC7H,{|x| x == Upper(AllTrim(cCMPAt))}) > 0
							Loop
						Endif
					Endif				
					If (nPosVP := aScan(aLstIniPad,{|x| x[1] == Upper(AllTrim(cCdAlias02)) .AND. x[2] == cCmpAt})) > 0
						lGrvVazio := .T.
						//Se nao utiliza memvar, inicializar o campo
						If At("->",aLstIniPad[nPosVP][3]) == 0						
							uTMP := &(aLstIniPad[nPosVP][3])
						Endif
					Endif
				Endif				
				//Caso o conteudo do campo definido no arquivo de origem nao seja nulo, adicionar
				If !Empty(uTMP) .OR. lGrvVazio
					If lPedComp
						Do Case
							Case cCMPAt == "C7_ITEM"
								uTMP := StrZero(Val(uTMP),nTamItem)
						EndCase
					Endif
					aAdd(aTMP,{cCMPAt,uTMP,Nil})
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณVerifica se informou filial no arquivo              ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				Endif
				If !lTemFil02
					If cCMPAt == cCpoFil02
						lTemFil02 := .T.
				    EndIf
				Endif
			Endif
		Next ni
		If !lTemFil02 .AND. !lPedComp
			aAdd(aTMP,{cCpoFil02,cFilAlia02,Nil})
		Endif
		//Adicionar o array temporario dos campos a sua posicao na lista de registros da tab. secundaria
		aReg02[Len(aReg02)] := aTMP
	Next nx
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChamada da rotina automatica                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cCdAlias)
If At("MSEXECAUTO",Upper(cRotina)) > 0
	cRotAuto := cRotina
Else
	If !lProcFilho
		cRotAuto := "MSExecAuto({|x,y| " + cRotina + "(x,y)},aReg,3)"
	Else
		cRotAuto := "MSExecAuto({|x,y,z| " + cRotina + "(x,y,z)},aReg,aReg02,3)"
	Endif
Endif
cREG := cCdAlias + IIf(lProcFilho,"+" + cCdAlias02,"") + " [RECNO " + cValToChar(nLinProc) + "] "
lMsErroAuto := .F.
//Verificar se a rotina utiliza grupo de perguntas, caso sim, carregar as perguntas
If (nPosRot := aScan(aLstRot,{|x| Upper(AllTrim(x[1])) == Upper(AllTrim(cRotina))})) > 0
	If !Empty(aTail(aLstRot[nPosRot]))
		//Carregar as perguntas da rotina
		Pergunte(aTail(aLstRot[nPosRot]),.F.)
	Endif
Endif
Begin Transaction
&(cRotAuto)
If lMsErroAuto
	aErro := GetAutoGrLog()
	cMsg := cREG + "Erro na grava็ใo do registro" + CRLF + ArrayToStr(aErro,150)
	If InTransaction()
		DisarmTransaction()
	Endif
Else
	lOk := .T.
EndIf
End Transaction

Return {lOk,cMsg}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUsaTabSec บAutor ณPablo Gollan CarrerasบData  ณ  03/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que controla a funcao de selecao de arquivo de origemบฑฑ
ฑฑบ          ณpara importacao da tabela filha.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function UsaTabSec(nRadioArq)

Local lRet             := .F.

If Type("aLstTabP") == "U"
	Return lRet
Else
	If ValType(aLstTabP[nRadioArq]) == "A"
		lRet := !lRet
	Endif
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetTabN   บAutor ณPablo Gollan CarrerasบData  ณ  03/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o nome da tabela selecionada atraves do wizard      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetTabN(nRadioArq,aLstTPN)

Return aLstTPN[nRadioArq]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetEstArq บAutor ณPablo Gollan CarrerasบData  ณ  03/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara a estrutura de diretorio dos arquivos selecionados  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetEstArq(cArq,cDrive,cDir,cArqP,cExt)

If !Empty(cArq)
	cDrive	:= ""
	cDir	:= ""
	cArqP	:= ""
	cExt	:= ""
	SplitPath(cArq,@cDrive,@cDir,@cArqP,@cExt)
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณArrayToStrบAutor  ณPablo Gollan Carreras บ Data ณ  29/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConverte o conteudo de uma array em uma string                บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ArrayToStr(aStr,nTamLin)

Local cResp			:= ""
Local cLinha		:= ""
Local ni			:= 0
Local nx			:= 0
Local nLimite		:= 1

Default nTamLin	:= 0

For ni := 1 to Len(aStr)
	nInicio := 1
	cLinha := RTrim(aStr[ni])
	If Len(cLinha) > nTamLiN
		nLimite := Int(Len(cLinha) / nTamLin) + 1
	Else
		nLimite := 1
	Endif
	If nLimite == 1
		cResp += cLinha + CRLF
	Else
		For nx := 1 to nLimite
			cResp += Substr(cLinha,(1 + (nTamLin * nx)),nTamLin) + CRLF
			nInicio += nTamLin
		Next nx	
	Endif
Next ni

Return cResp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX3Load   บAutor ณPablo Gollan CarrerasบData  ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que carrega a lista de campos obrigatorios e inicia- บฑฑ
ฑฑบ          ณlizadores padrao                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SX3Load(cAlias)

Local aAreaSX3			:= SX3->(GetArea())

If Empty(cAlias)
	Return cRet
Endif
cAlias := Upper(AllTrim(cAlias))
//Verificar se os campos obrigatorios jah nao foram pesquisados
If aScan(aLstObr,{|x| AllTrim(x[1]) == AllTrim(cAlias)}) == 0
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias))
	Do While !SX3->(Eof()) .AND. AllTrim(SX3->X3_ARQUIVO) == cAlias
		If SX3->X3_CONTEXT == "V"
			aAdd(aLstVirtual,Upper(AllTrim(SX3->X3_CAMPO)))
		Else
			//Verificar se o uso do campo eh obrigatorio, mesmo os nao usados
			If ((SubStr(Bin2Str(SX3->X3_OBRIGAT),1,1) == "x") .OR. VerByte(SX3->X3_RESERV,7))
				//Caso nao esteja na lista, adicionar o campo a lista de campos obrigatorios
				If aScan(aLstObr,{|x| AllTrim(x[1]) == AllTrim(SX3->X3_ARQUIVO) .AND. AllTrim(Upper(x[2])) == AllTrim(Upper(SX3->X3_CAMPO))}) == 0
					aAdd(aLstObr,{AllTrim(SX3->X3_ARQUIVO),AllTrim(Upper(SX3->X3_CAMPO)),AllTrim(SX3->X3_TITULO)})
				Endif
			Endif
			//Verificar se o campo possui um inicializador padrao
			If !Empty(SX3->X3_RELACAO) .AND. aScan(aLstIniPad,{|x| x[1] == Upper(AllTrim(cAlias)) .AND. x[2] == AllTrim(SX3->X3_CAMPO)}) == 0
				aAdd(aLstIniPad,{cAlias,AllTrim(SX3->X3_CAMPO),AllTrim(SX3->X3_RELACAO)})
			Endif
		Endif
		SX3->(dbSkip())
	EndDo
Endif
RestArea(aAreaSX3)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAdCmpIni  บAutor ณPablo Gollan CarrerasบData  ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que adiciona ao header campos que possuem inicializa-บฑฑ
ฑฑบ          ณdor padrao, caso eles nao estejam declarados.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AdCmpIni(cAlias,aHeader)

Local ni               := 0
Local nPosVP			:= 0
						
For ni := 1 to Len(aLstIniPad)
	If aLstIniPad[ni][1] == Upper(AllTrim(cAlias))
		If (nPosVP := aScan(aHeader,{|x| Upper(AllTrim(x)) == aLstIniPad[ni][2]})) == 0
			aAdd(aHeader,aLstIniPad[ni][2])
		Endif
	Endif
Next ni

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerErro   บAutor ณPablo Gollan CarrerasบData  ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento de erro                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerErro(e,lErro,cErro)

Local lRet				:= .F.

If e:Gencode > 0  
	If InTransaction()
    	cErro := "Houve um erro no processamento de gravacao : " + CRLF
	Else
     	cErro := "Houve um erro no levantamento de registros : " + CRLF
	Endif
	cErro += "Descri็ใo : " + e:Description + CRLF
	cErro += e:ErrorStack
	lErro := .T.
    lRet := .T.
    Break
EndIf

Return lRet
#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RIMPA080 ºAutor  ³FERNANDO BARRETO    º Data ³  10/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de importacao do cadastro Pedido de Compras          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 27/01/15 - Douglas David - OS 3626/14                   º±±
±±º             ³ Alterações para apresentar a rejeição correta e criação º±±
±±º             ³ de protocolo de importação.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RIMPA081()
Local aBotoes	:= {}
Local aSays		:= {}
Local aPergunt	:= {}
Local nOpcao	:= 0
Local oRegua    := Nil

Public nContLi  := 0

FCadProd() // Chamada do Programa

Return(Nil)
            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FCadProd ºAutor  ³    Eduardo Dias    º Data ³  15/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chama programa de importacao                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FCadProd()

Private cArqTxt := Space(50)
Private oDlgImp, oArqTxt

@ 000, 000 To 200, 318  Dialog oDlgImp  Title "[IMPORTAÇÃO DE PEDIDO DE COMPRAS/VENDAS]"

@ 005, 005 To 040, 158 
@ 010, 010 Say "Esse programa importará os Pedidos de Compras & Vendas "
@ 020, 010 Say "         dos sistemas legados para a base do Protheus "
@ 030, 010 Say "              com base no arquivo .TXT informado"
@ 055, 005 To 085, 158  Title "Escolha o arquivo"
@ 068, 008 Get cArqTxt  Size 130, 08  Object oArqTxt  
@ 068, 140 Button "..." Size 010, 08  Action FBusFil()

oArqTxt:Disable()

@ 087, 093 BmpButton Type 01 Action FConImp()
@ 087, 123 BmpButton Type 02 Action FCanImp()

Activate Dialog oDlgImp Center

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FCanImp  ºAutor  ³    Eduardo Dias    º Data ³  15/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cancela importacao                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FCanImp()

Close(oDlgImp) // Cancela Importacao

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FConImp  ºAutor  ³    Eduardo Dias    º Data ³  15/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Confirma importacao                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FConImp()

// Confirma Importacao
If Empty(cArqTxt)
	MsgStop("Arquivo deve ser informado.")
	Return Nil
EndIf

Processa({|| RIMPA081A()}, "Lendo Arquivo " + cArqTxt + "...")
Close(oDlgImp)

Return Nil
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FBusFil  ºAutor  ³    Eduardo Dias    º Data ³  15/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca arquivo texto                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FBusFil()

// Busca arquivo .TXT
cArqTxt := Upper(cGetFile(" (*.txt) |*.txt|",OemToAnsi("Abrir Arquivo...")))
oArqTxt:Refresh()           

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RIMPA080 ºAutor  ³FERNANDO BARRETO    º Data ³  10/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento da rotina de importacao                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RIMPA081A()
Local i        := 0     // No escopo Local funciona
Local j        := 0
//Local nContLi  := 0
Local nContok  := 0
Local nContokB1:= 0
Local _nTotal  := 0
Local _nSC7    := 0
Local _nSC5    := 0
Local cNome	   := ""   
Local cArqQry
PRIVATE _cCodigoProd:=''
PRIVATE cCodCli:=''           
PRIVATE cCriaPV	:= "S"


If SM0->(M0_CODIGO<>'05'.or. M0_CODFIL<>'03')
	MsgStop("Esta rotina apenas pode ser executada na empresa: 05 (CSU CARDSYSTEM) - filial: 03 (ALPHAVILLE)")
	Return
Endif

nPosicao := 0
nColuna  := 0
nLog     := 0
cLinha   := ""
cMenErro := ""
cItem    := ""
cNumPC   := ""
TmpNumPC := ""
//_cNaturez := "1.1.53"
_cNaturez := ""
aCab      := {}
aItem     := {}
aItens    :={}
uConteudo := Nil
aLayout   := {}
aArquivo  := {}
_nErro    := 0
_nSC7Rej  := 0
_nSC5Rej  := 0


// Parametros utilizados atualmente, verificar se será necessário utilizar ou se terá no arquivo
private _cArea := GetNewPar("MV_XFFAREA","MARK")			// Area de Negocios padrão Ped Vendas

private _cCustPv := GetNewPar("MV_XFFCUST","0701020000")		// Centro de Custos padrão Ped Vendas
private _cNegoPv := GetNewPar("MV_XFFNEGO","0703")		 	// Unidade Negocios padrão Ped Vendas
private _cOperPv := GetNewPar("MV_XFFOPER","999999999")		// Operacao padrão Ped Vendas

private _cCustPc := GetNewPar("CS_XGPCUST","0701020000")		// Centro de Custos padrão Ped Compras
private _cNegoPc := GetNewPar("CS_XGPNEGO","0703")		 	// Unidade Negocios padrão Ped Compras
private _cOperPc := GetNewPar("CS_XGPOPER","999999999")		// Operacao padrão Ped Compras


//Layout do arquivo CSV para importacao

AAdd(aLayOut,{"C6_RESGATE",1,.F.,"Empty(uConteudo)","1-Resgate não informado","C"})
AAdd(aLayOut,{"A1_COD",2,.F.,.F.,"2-Cliente não informado","C"})
AAdd(aLayOut,{"A1_LOJA",3,.F.,.F.,"3-Loja  não informado","C"})
AAdd(aLayOut,{"A1_NOME",4,.F.,"Empty(uConteudo)","4-Nome não informado","C"})
AAdd(aLayOut,{"A1_NREDUZ",5,.F.,"Empty(uConteudo)","5-Nome Fantasia não informado","C"})
AAdd(aLayOut,{"A1_TIPOCLI",6,.F.,"Empty(uConteudo)","6-Tipo de cliente nao informado","C"})
AAdd(aLayOut,{"A1_PESSOA",7,.F.,"Empty(uConteudo)","7-Pessoa nao informado","C"})
AAdd(aLayOut,{"A1_TIPO",8,.F.,"Empty(uConteudo)","8-tipo de cliente nao informado","C"})
AAdd(aLayOut,{"A1_CGC",09,.F.," !xACChkCGC(uConteudo)","9-cnpj nao informado ou invalido ","C"}) // Campo com nome errado
AAdd(aLayOut,{"A1_END",10,.F.,"Empty(uConteudo)","10-endereco nao informado","C"})
AAdd(aLayOut,{"A1_MUN",11,.F.,"Empty(uConteudo)","11-Cod.municipio invalido ou nao informado","C"})
AAdd(aLayOut,{"A1_EST",12,.F.,"Empty(uConteudo)","12-estado nao informado","C"})
AAdd(aLayOut,{"A1_PAIS",13,.F.,"Empty(uConteudo)","13- Pais não informado","C"})
AAdd(aLayOut,{"A1_CEP",14,.F.,"Empty(uConteudo)","14- CEP não informado","C"})
AAdd(aLayOut,{"A1_DDD",15,.F.,.F.,"15- DDD não informado","C"})
AAdd(aLayOut,{"A1_FONE",16,.T.,.F.,"16- FONE não informado","C"})
AAdd(aLayOut,{"A1_EMAIL",17,.F.,.F.,"17- EMAIL não informado","C"})
AAdd(aLayOut,{"A1_NATUREZ",18,.F.,"!Valarq('SED',1,uConteudo)","18- NATUREZA não encontrado ou nao informado","C"})
AAdd(aLayOut,{"B1_DESC",19,.F.,"Empty(uConteudo)","19- descricao do produto não informado","C"})
AAdd(aLayOut,{"B1_COD",20,.F.,"Empty(uConteudo)","20- codigo do produto não informado","C"})
AAdd(aLayOut,{"C6_PESO",21,.F.,"Empty(uConteudo)","21- Peso não informado","N"})
AAdd(aLayOut,{"A1_BAIRRO",22,.F.,"Empty(uConteudo)","22- bairro  não informado","C"})
AAdd(aLayOut,{"C6_PRCVEN",23,.F.,"Empty(uConteudo)","23- preco de venda não informado","N"})
AAdd(aLayOut,{"C6_QUANT",24,.F.,"Empty(uConteudo)","24- quantidade  não informado","N"})
AAdd(aLayOut,{"C6_NUMNF",25,.F.,"","25- numero da nf  não informado","N"})
AAdd(aLayOut,{"C6_SERNF",26,.F.,"","26- serie da nf  não informado","N"})
AAdd(aLayOut,{"C6_ESPNF",27,.T.,,"27- especie não informado","C"})
AAdd(aLayOut,{"C6_LINK",28,.F.,,"28- link não informado","C"})
AAdd(aLayOut,{"C6_TOTAL",29,.F.,"Empty(uConteudo)","29- total do produto não informado","N"})
AAdd(aLayOut,{"C6_ALIQICM",30,.F.,"Empty(uConteudo)","30- Aliquota do icm  não informado","N"})
AAdd(aLayOut,{"C6_VALICM",31,.F.,"Empty(uConteudo)","31- valor do icm  não informado","N"})
AAdd(aLayOut,{"C5_EMISSAO",32,.F.,"Empty(uConteudo)","32- emissao  não informado","D"})
AAdd(aLayOut,{"C7_VALFRE",33,.F.,"Empty(uConteudo)","33- frete não informado","N"}) //OS 1428/13
AAdd(aLayOut,{"C6_TES",34,.F.,"Empty(uConteudo)","34- TES  não informado","C"})
AAdd(aLayOut,{"C6_CST",35,.F.,"Empty(uConteudo)","35- CST  não informado","C"})
AAdd(aLayOut,{"C6_CFOP",36,.F.,"Empty(uConteudo)","36- CFOP não informado","C"})
AAdd(aLayOut,{"C6_NATUREZ",37,.F.,"Empty(uConteudo)","37- NATUREZA  não informado","C"})
AAdd(aLayOut,{"BASE + FRETE",38,.F.,,"38- BASE + FRETE  não informado","C"})
AAdd(aLayOut,{"TOTAL + FRETE",39,.F.,,"39- TOTAL + FRETE  não informado","","C"})
AAdd(aLayOut,{"C6_NUM",40,.F.,,"40- NUMERO DO PEDIDO  não informado","C"})
AAdd(aLayOut,{"C6_DTRESG",41,.F.,,"41- DATA DO RESGATE NAO INFORMADO","","D"})
AAdd(aLayOut,{"A1_CODMUN",42,.F.,"!Valarq('CC2',3,uConteudo)","42- COD.MUNICIPIO não informado ou Invalido","C"})
AAdd(aLayOut,{"C6_POSIPI",43,.F.,"Empty(uConteudo)","43- Posicao do ipi  não informado","C"})
AAdd(aLayOut,{"C7_ITEM",44,.F.,"Empty(uConteudo)","44- Item do PC  não informado","C"})
AAdd(aLayOut,{"C7_UM",45,.F.,"Empty(uConteudo)","45- Unidade de medida  não informado","N"})
AAdd(aLayOut,{"A2_CNPJ",46,.F.,.F.,"46- CNPJ nao informado ou invalido","C"})
AAdd(aLayOut,{"C7_NUM",47,.F.,.F.,"47- Numero do pedido compra  não informado","C"})
AAdd(aLayOut,{"C7_CONDPG",48,.F.," !Valarq('SE4',1,uConteudo) ","48- Condicao de pagto de compras nao existe ou não informado ","C"})
AAdd(aLayOut,{"C5_CONDPG",49,.F.," !Valarq('SE4',1,uConteudo) ","49- Condicao de pagto de vendas nao existe ou  não informado","C"})
AAdd(aLayOut,{"C6_CC",50,.F.,.F.,"!Valarq('CTD',1,uConteudo)","50- Centro de custo invalido ou nao informado"})
AAdd(aLayOut,{"C6_OPERACAO",51,.F.,,"51- Operacao não informado","C"})
AAdd(aLayOut,{"C6_UNIDNEG",52,.F.,"","52- Unidades de negocios  não informado","C"})
AAdd(aLayOut,{"C6_ORG",53,.F.,.F.,"53- Org.  não informado","C"})
AAdd(aLayOut,{"C6_ESTEMI",54,.F.,,"54- Estado de emissao  não informado","C"})
AAdd(aLayOut,{"B1_TIPO",55,.F.,"Empty(uConteudo)","55- Tipo de produto  não informado","C"})
AAdd(aLayOut,{"C6_LOCAL",56,.F.,"Empty(uConteudo)","56- Local  não informado","C"})
AAdd(aLayOut,{"C6_BASIRF",57,.F.,,"57- Base de irf  não informado","N"})
AAdd(aLayOut,{"C6_ALIQIPI",58,.F.,,"58- Aliquota de IPI  não informado","N"})
AAdd(aLayOut,{"C5_FOB",59,.F.,.F.,"59- FOB  não informado","C"})
AAdd(aLayOut,{"C6_ALIQICM",60,.F.,.F.,"60- Aliquota de ICM  não informado","N"})
AAdd(aLayOut,{"C7_COMPENT",61,.F.,.F.,"61- COMPENT  não informado","C"})
AAdd(aLayOut,{"C6_COFINS",62,.F.,.F.,"62- COFINS não informado","N"})
AAdd(aLayOut,{"C6_PIS",63,.F.,.F.,"63- PIS  não informado","N"})
AAdd(aLayOut,{"C6_ORIGPRO",64,.F.,.F.,"64- ORIGEM DO PRODUTO  não informado","C"})
AAdd(aLayOut,{"C6_DESCPOR",65,.F.,"Empty(uConteudo)","65- DESC Portugues não informado","C"})

If !File(cArqTxt) //!File(mv_par01)  - Edu Devido Mudança de Tela
	MsgAlert("Atenção, o arquivo informado não foi localizado.")
	Return()
EndIf

FT_FUse(cArqTxt) //(mv_par01) - Edu Devido Mudança de Tela
FT_FGoTop()
ProcRegua(FT_FLastRec())
FT_FGoTop()

cLinha    := FT_FReadLn()
_cNomeArq := Alltrim(SUBSTR(cLinha,3,20))+"-"+alltrim(Substr(cLinha,41,6))+".txt"   /////  nome do arquivo de LOG
_cNomeProt:= "PROTOCOLO_PROCESSAMENTO.txt"   /////  nome do arquivo de Protocolo

nLog  := FCreate("C:\SIGA\LOG_PEDCOMPRA\"+_cNomeArq)
nLog1 := FCreate("C:\SIGA\LOG_PEDCOMPRA\"+_cNomeProt)

FT_FSkip() //Primeira linha com cabeçalho

While !FT_FEof()
	IncProc("Formatando Arquivo...")
	
	cLinha   := FT_FReadLn()
	nColuna  := 0
	nPosicao := 1
	AAdd(aArquivo,Array(66))
	
	aArquivo[Len(aArquivo),1]    := SUBSTR(cLinha,13,10)  ////  resgate
	aArquivo[Len(aArquivo),2]    := SUBSTR(cLinha,23,06)  ///   codigo do cliente
	aArquivo[Len(aArquivo),3]    := SUBSTR(cLinha,29,02)  ///  	 Loja do cliente
	aArquivo[Len(aArquivo),4]    := SUBSTR(cLinha,31,30)  ///   Nome do cliente
	aArquivo[Len(aArquivo),5]    := SUBSTR(cLinha,61,20)  ///   Nome fantasia
	aArquivo[Len(aArquivo),6]    := SUBSTR(cLinha,81,01)  ///   Tipo de Cliente -
	aArquivo[Len(aArquivo),7]    := SUBSTR(cLinha,82,01)  ///   tipoi de Pessoa
	aArquivo[Len(aArquivo),8]    := SUBSTR(cLinha,83,01)  ///   tipo consumidor/revendedor
	aArquivo[Len(aArquivo),9]    := SUBSTR(cLinha,84,14)  ///   CPF
	aArquivo[Len(aArquivo),10]   := SUBSTR(cLinha,98,100) ///  Endereco completo
	aArquivo[Len(aArquivo),11]   := SUBSTR(cLinha,198,20) ///  Cidade
	aArquivo[Len(aArquivo),12]   := SUBSTR(cLinha,218,02) ///  Estado
	aArquivo[Len(aArquivo),13]   := SUBSTR(cLinha,220,10) ///  Pais
	aArquivo[Len(aArquivo),14]   := SUBSTR(cLinha,230,08) ///  CEP
	aArquivo[Len(aArquivo),15]   := SUBSTR(cLinha,238,05) ///  DDD
	aArquivo[Len(aArquivo),16]   := SUBSTR(cLinha,243,09) ///  Telefone de contato   //OS-2155/12 alteracao para o 9 digito +1 caracter
	aArquivo[Len(aArquivo),17]   := SUBSTR(cLinha,252,80) ///  Email do destinatario
	aArquivo[Len(aArquivo),18]   := SUBSTR(cLinha,332,10) ///  Natureza financeira
	aArquivo[Len(aArquivo),19]   := SUBSTR(cLinha,342,40) ///  Descricao do Produto
	aArquivo[Len(aArquivo),20]   := SUBSTR(cLinha,382,08) ///  Codigo do Produto
	aArquivo[Len(aArquivo),21]   := SUBSTR(cLinha,390,12) ///  Peso
	aArquivo[Len(aArquivo),22]   := SUBSTR(cLinha,402,20) ///  Bairro
	aArquivo[Len(aArquivo),23]   := SUBSTR(cLinha,422,14) ///  Valor unitario
	aArquivo[Len(aArquivo),24]   := SUBSTR(cLinha,436,03) ///  QUANTIDADE
	aArquivo[Len(aArquivo),25]   := SUBSTR(cLinha,439,09) ///  Numero da NF
	aArquivo[Len(aArquivo),26]   := SUBSTR(cLinha,448,03) ///  SERIE da NF
	aArquivo[Len(aArquivo),27]   := SUBSTR(cLinha,457,05) ///  Especie da NF
	aArquivo[Len(aArquivo),28]   := SUBSTR(cLinha,462,48) ///  Link da NF Eletronica
	aArquivo[Len(aArquivo),29]   := SUBSTR(cLinha,510,14) ///  Valor Total sem separador
	aArquivo[Len(aArquivo),30]   := SUBSTR(cLinha,525,02) ///  Aliquota do ICMS
	aArquivo[Len(aArquivo),31]   := SUBSTR(cLinha,529,14) ///  Valor do ICMS
	aArquivo[Len(aArquivo),32]   := SUBSTR(cLinha,543,10) ///  Data de emissao (dd/mm/yyyy)
	aArquivo[Len(aArquivo),33]   := SUBSTR(cLinha,553,14) ///  Valor do Frete
	aArquivo[Len(aArquivo),34]   := SUBSTR(cLinha,567,03) ///  TES
	aArquivo[Len(aArquivo),35]   := SUBSTR(cLinha,570,03) ///  CST
	aArquivo[Len(aArquivo),36]   := SUBSTR(cLinha,573,05) ///  CFOP
	aArquivo[Len(aArquivo),37]   := SUBSTR(cLinha,578,30) ///  Natureza de Operacao
	aArquivo[Len(aArquivo),38]   := SUBSTR(cLinha,608,14) ///  Base de Cálculo + Valor do Frete
	aArquivo[Len(aArquivo),39]   := SUBSTR(cLinha,622,14) ///  Valor Total dos Produtos + Valor do Frete
	aArquivo[Len(aArquivo),40]   := SUBSTR(cLinha,636,16) ///  Número do Pedido de Venda     //OS 3425/16 Ajuste para 16 digitos-Pedido do Fornecedor - Douglas
	aArquivo[Len(aArquivo),41]   := SUBSTR(cLinha,653,10) ///  Data do Resgate (DD/MM/YYYY)
	//	aArquivo[Len(aArquivo),42]    := SUBSTR(cLinha,661,07) ///  Código do IBGE da Cidade do Cliente
	aArquivo[Len(aArquivo),42]   := SUBSTR(cLinha,664,05) ///  Código do IBGE da Cidade do Cliente - ADAPTACAO DE 5 DIGITOS
	aArquivo[Len(aArquivo),43]   := SUBSTR(cLinha,669,08) ///  NCM do Produto
	aArquivo[Len(aArquivo),44]   := SUBSTR(cLinha,677,04) ///  Item do pedido de compra
	aArquivo[Len(aArquivo),45]   := SUBSTR(cLinha,681,02) ///  Unidade de Medida
	aArquivo[Len(aArquivo),46]   := SUBSTR(cLinha,683,14) ///  CNPJ do Fornecedor
	aArquivo[Len(aArquivo),47]   := SUBSTR(cLinha,697,06) ///  Número do Pedido de Compra
	aArquivo[Len(aArquivo),48]   := SUBSTR(cLinha,703,03) ///  Condicao de pagamento pc
	aArquivo[Len(aArquivo),49]   := SUBSTR(cLinha,706,03) ///  Condicao de Pagamento PV
	aArquivo[Len(aArquivo),50]   := SUBSTR(cLinha,709,20) ///  Centro de Custo
	aArquivo[Len(aArquivo),51]   := SUBSTR(cLinha,729,09) ///  Operacao
	aArquivo[Len(aArquivo),52]   := SUBSTR(cLinha,738,09) ///  Unidade de Negocio
	aArquivo[Len(aArquivo),53]   := SUBSTR(cLinha,747,03) ///  ORG (NOVO CAMPO)
	aArquivo[Len(aArquivo),54]   := SUBSTR(cLinha,750,02) ///  Estado de emissao da NF
	aArquivo[Len(aArquivo),55]   := SUBSTR(cLinha,752,02) ///  Tipo de Produto (MP,PA,.)
	aArquivo[Len(aArquivo),56]   := SUBSTR(cLinha,754,02) ///  Armazem Padrao p/Requis.
	aArquivo[Len(aArquivo),57]   := SUBSTR(cLinha,756,14) ///  Base de calculo do IRRF
	aArquivo[Len(aArquivo),58]   := SUBSTR(cLinha,770,15) ///  Alíquota de IPI
	aArquivo[Len(aArquivo),59]   := SUBSTR(cLinha,785,15) ///  FOB
	aArquivo[Len(aArquivo),60]   := SUBSTR(cLinha,800,05) ///  Alíquota de ICMS
	aArquivo[Len(aArquivo),61]   := SUBSTR(cLinha,805,08) ///  Competência do Docto de Entrada
	aArquivo[Len(aArquivo),62]   := SUBSTR(cLinha,813,04) ///  Percentual do cofins
	aArquivo[Len(aArquivo),63]   := SUBSTR(cLinha,817,04) ///  Percentual do PIS
	aArquivo[Len(aArquivo),64]   := SUBSTR(cLinha,821,01) ///  Origem do Produto
	aArquivo[Len(aArquivo),65]   := SUBSTR(cLinha,822,20) ///  Descrição em Portugues
	aArquivo[Len(aArquivo),66]   := SUBSTR(cLinha,842,13) ///  Codigo EAN
	
	FT_FSkip()
EndDo

//Valida a importa o arquivo

ProcRegua(Len(aArquivo)-1)

For i := 1 To Len(aArquivo)-1
	
	IncProc("Importando Pedidos de Compras e Vendas ..."+STR(I))
	
	cMenErro := ""
	_Continua := .T.
	
	For j := 1 To Len(aLayOut)
		uConteudo := aArquivo[i,aLayout[j,2]]
		
		IF Alltrim(uConteudo) != '99'
			Exit    ///// Final de arquivo Texto
		Endif
		
		
		If !Empty(aLayout[j,4]) .and.  &(aLayout[j,4])
			
			cMenErro += " - " + aLayout[j,5] + Chr(13) + Chr(10)
			
		EndIf
	Next j
	
	If !Empty(cMenErro) //////.AND. 1==2
		FWrite(nLog,"LOG Registro: " + STRZERO(I,3) +Chr(13)+Chr(10))         /////  ver aarquivo
		FWrite(nLog,cMenErro+Chr(13)+Chr(10))
		_nErro++
	Else                                                  
		
		IF LEN(alltrim(aArquivo[i] [09]))  > 11 .And. aArquivo[i] [07] == 'F'
			FWrite(nLog,"LOG Registro: " + STRZERO(I,3) +Chr(13)+Chr(10))         /////  ver aarquivo
			FWrite(nLog,"Enviado numero de CPF para pessoa Fisica CPF "+ALLTRIM(aArquivo[i,09])+Chr(13)+Chr(10))
			_Continua := .F.
			_nErro++
		ELSEIF LEN(alltrim(aArquivo[i] [09])) < 12 .And. aArquivo[i] [07] == 'J'
			FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
			FWrite(nLog,"Enviado numero de CNPJ para pessoa Juridica CNPJ "+ALLTRIM(aArquivo[i,09])+Chr(13)+Chr(10))
			_Continua := .F.
			_nErro++
		ENDIF
		
		// *********************************************** CLIENTE ******************************************************
		nContLi++ //CONTADOR PARA ESPECIFICAR A LINHA NO ERROR LOG.
		Dbselectarea("SA1") 
		SA1->(DbGotop())
		Dbsetorder(3)
		IF   _Continua
			cNome	:= Posicione("SA1",3,xFilial("SA1")+aArquivo[i,09],"A1_NOME")
			
			if AllTrim(cNome) == AllTrim(aArquivo[i,04]) //Dbseek(xFilial("SA1")+Alltrim(aArquivo[i,09]))   ////////////////// encontrou o cliente
				_Continua  := Criacli(i,.T.) // Passa com parametro devido ao escopo Local
			else
				_Continua  := Criacli(i,.F.) // Passa com parametro devido ao escopo Local
			endif
			
			IF !_Continua
				//	FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
				nContLi:=cvaltochar(nContLi)
				FWrite(nLog,"Problema na criacao/Alteracao do Cliente CPF: "+ALLTRIM(aArquivo[i,09])+", Linha: "+nContLi+ "do arquivo de importacao." +Chr(13)+Chr(10))
				nContLi:=val(nContLi)
				_Continua := .F.
				_nErro++
			endif
		Endif
		
		// *********************************************** FORNECEDOR ******************************************************
		
		Dbselectarea("SA2")
		Dbsetorder(3)
		IF  _Continua
			cBloq:='1'
			if  Dbseek(xFilial("SA2")+aArquivo[i,46])   
			
				//Verifica se gerar Pedido de Venda para o Fornecedor posicionado
				cCriaPV := SA2->A2_CRIAPV //Posicione("SA2",3,xFilial("SA2")+Alltrim(aArquivo[i,46]),"A2_CRIAPV")
				
				cBloq:=SA2->A2_MSBLQL
				WHILE (cBloq=='1')
					DBSKIP()
					cBloq:=SA2->A2_MSBLQL
				ENDDO
				// NAO E NECESSARIO A ALTERACAO DOS FORNECEDORES
				//	_Continua  := CriaFor(i,.T.)// Passa com parametro devido ao escopo Local
			else
				//nao encontrou o fornecedor alertar com o codigo do cnpj
				ALERT("Fornecedor não encontrado para CNPJ nº: "+aArquivo[i,46])
				_Continua:=.F.
				//	_Continua  := CriaFor(i,.F.)// Passa com parametro devido ao escopo Local
			endif
			
			IF !_Continua
				//FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
				nContLi:=cvaltochar(nContLi)
				FWrite(nLog,"Problema na criacao do Fornecedor CNPJ nº: "+ALLTRIM(aArquivo[i,46])+", Linha: "+nContLi+ " do arquivo de importacao." +Chr(13)+Chr(10))
				nContLi:=val(nContLi)
				_Continua := .F.
				_nErro++
			endif
			
		Endif
		
		// *********************************************** PRODUTO ******************************************************
		
		B1COD := ALLTRIM(aArquivo[i,20]) +SPACE((TamSX3("B1_COD")[1])- LEN(ALLTRIM(aArquivo[i,20])))
		Dbselectarea("SB1")
		Dbsetorder(1)
		IF  _Continua
			
			
			IF  Dbseek(xFilial("SB1")+Alltrim(B1COD)+"G")    ////////////////// encontrou o Produto, cria o Produto
				_Continua  := criaprod(i,.T.)// Passa com parametro devido ao escopo Local
			Else
				_Continua  := criaprod(i,.F.)// Passa com parametro devido ao escopo Local
			endif
			IF !_Continua
				//FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
				nContLi:=cvaltochar(nContLi)
				nContLi:=val(nContLi)
				_Continua := .F.
				_nErro++
			endif
			
		Endif                                           
		
		
		
		// *********************************************** PEDIDO DE COMPRAS ******************************************************
		
		IF _Continua
			
			nContok++
			/*
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±± SELECIONA A OPERACAO CONFORME O ORG ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			*/
			cQuery:="SELECT CTH_CLVL FROM "+RetSqlName('CTH')+" CTH WHERE CTH_X_ORG='"+aArquivo[i,53]+"' AND CTH.D_E_L_E_T_=''"
			U_MontaView(cQuery,"CONS")
			DBSELECTAREA("CONS")
			CONS->(dbGoTop())
			_cOperPc:=CONS->CTH_CLVL
			DBCLOSEAREA("CONS")
			
			Dbselectarea("SC7")
			//Dbsetorder(21)
			cArqNtx  := CriaTrab(NIL,.f.)
			cIndCond :="C7_FILIAL + C7_PRODUTO + C7_X_RESG + C7_CLVL"
			IndRegua("SC7",cArqNtx,cIndCond,,," ")
			DBGOTOP()
			
			cProduto := ALLTRIM(aArquivo[i,20])+"G"+SPACE((TamSX3("B1_COD")[1])- LEN(ALLTRIM(aArquivo[i,20]+"G")))
			IF !empty(aArquivo[i,1]) .and.  Dbseek(xFilial("SC7")+cProduto+aArquivo[i,1]+_cOperPc)
				//	FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
				FWrite(nLog,"Pedido de Compras ja existe, portanto esse item nao foi alterado nem regravado. Resgate numero "+ALLTRIM(aArquivo[i,01])+Chr(13)+Chr(10))
				_Continua := .F.
				//_nErro++ 210116
			else
				_Continua  := PedCom(i)// Passa com parametro devido ao escopo Local
				
				IF !_Continua
					//	FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
					nContLi:=cvaltochar(nContLi)
					nContLi:=val(nContLi)
					_Continua := .F.
					_nErro++
				endif
			endif
			                     
		endif
		                
		DBCLOSEAREA("SC7") // OS 0280/16 - By Douglas David
		
		_nSC7  := nContok
		_nSC7Rej:= _nErro
		
		// *********************************************** PEDIDO DE VENDA ******************************************************
		
		If _Continua 
		
			If cCriaPV == "N" //  cria o pedido de vendas 
				FWrite(nLog,"Conforme condição imposta no A2_CRIAPV do fornecedor (CNPJ: "+aArquivo[i,46]+"), não foi gerado o Pedido de Venda para o resgate. "+aArquivo[i,1]+Chr(13)+Chr(10))
				_Continua	:= .F.
				//_nErro++		    
			Else
			
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±± SELECIONA A OPERACAO CONFORME O ORG ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				cQuery:="SELECT CTH_CLVL FROM "+RetSqlName('CTH')+" CTH WHERE CTH_X_ORG='"+aArquivo[i,53]+"' AND CTH.D_E_L_E_T_=''"
				U_MontaView(cQuery,"CONS")
				DBSELECTAREA("CONS")
				CONS->(dbGoTop())
				_cOperPv:=CONS->CTH_CLVL
				DBCLOSEAREA("CONS")
				
				Dbselectarea("SC5")
				Dbsetorder(8)
	
				IF !empty(aArquivo[i,1]) .and. Dbseek(xFilial("SC5")+aArquivo[i,1]) //////////.and. 1==2  ////  1==2 esta assim para nunca encontrar o pedido
					Dbselectarea("SC6")
					cArqNtx  := CriaTrab(NIL,.f.)
					cIndCond :="C6_FILIAL + C6_PRODUTO + C6_X_RESG + C6_CLVLDB"
					IndRegua("SC6",cArqNtx,cIndCond,,,"")
					DBGOTOP()
					cProduto := ALLTRIM(aArquivo[i,20])+"G"+SPACE((TamSX3("B1_COD")[1])- LEN(ALLTRIM(aArquivo[i,20]+"G")))
					IF !empty(aArquivo[i,1]) .and. Dbseek(xFilial("SC6")+cProduto+aArquivo[i,1]+_cOperPv)        /////  ver aarquivo
						//		FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))
						FWrite(nLog,"Pedido de Vendas ja existe, portanto esse item nao foi alterado nem regravado. Resgate Numero "+ALLTRIM(aArquivo[i,01])+Chr(13)+Chr(10))
						_Continua := .F.
						_nErro++
					Else
						_Continua  := criaped(i)
						IF !_Continua
							nContLi:=cvaltochar(nContLi)
							nContLi:=val(nContLi)
							_Continua := .F.
							_nErro++
						else
							ConOut("LOG Registro do Pedido: " + SC5->C5_NUM )
						endif
					endif
				else
					_Continua  := criaped(i)// Passa com parametro devido ao escopo Local
					IF !_Continua
						nContLi:=cvaltochar(nContLi)
						nContLi:=val(nContLi)
						_Continua := .F.
						_nErro++
					else
						ConOut("LOG Registro do Pedido: " + SC5->C5_NUM )
					endif
				endif
            
            DBCLOSEAREA("SC6")			
			nSC5   := nContok
			_nSC5Rej:= _nErro
			
			endif
			
		    
		    EndIf
		    
	endif
	
Next i

FClose(nLog)

If _nErro > 0
	MsgAlert("Houveram erros na rotina, favor consultar o arquivo de log no caminho C:\SIGA\LOG_PEDCOMPRA\"+DToS(dDataBase)+".LOG")
Else
	MsgAlert("Processamento concluído.")
EndIf

_nTotal:=_nSC7 + _nSC5
_nSC7  := _nSC7 - _nSC7Rej
_nSC5  := _nSC5 - _nSC5Rej

MsgAlert("Quantidade de pedidos total do arquivo importado: "+alltrim(str(_nTotal))+" "+CHR(13)+CHR(10) ) //+;
//"Pedidos de compra gerado com sucesso: "+alltrim(str(_nSC7))+"   Rejeitados: "+alltrim(str(_nSC7Rej))+ " "+CHR(13)+CHR(10)+; //OS 0002/16
//"Pedidos de venda  gerado com sucesso: "+alltrim(str(_nSC5))+"   Rejeitados: "+alltrim(str(_nSC5Rej))+ " ","PROTOCOLO DE PROCESSAMENTO") //OS 0002/16

FWrite(nLog1,"Quantidade de pedidos total do arquivo importado: "+alltrim(str(_nTotal))+" "+CHR(13)+CHR(10) ) //+;
//"Pedidos de compra gerado com sucesso: "+alltrim(str(_nSC7))+"   Rejeitados: "+alltrim(str(_nSC7Rej))+ " "+CHR(13)+CHR(10)+;
//"Pedidos de venda  gerado com sucesso: "+alltrim(str(_nSC5))+"   Rejeitados: "+alltrim(str(_nSC5Rej))+ " ")
FClose(nLog1)

Return(Nil)


Static Function Criacli(i,_Encontrou)

if _Encontrou           /////  Encontrou o cliente nao troca numero A1_FILIAL+A1_CGC
	nOpcAuto := 4
	cCodCli := Posicione("SA1",3,xFilial("SA1")+Alltrim(aArquivo[i,09]),"A1_COD") //SA1->A1_COD
	cLoja   := "01"            
	cContr	:= "2" 
Else
	nOpcAuto := 3
	cCodCli := NextNumero("SA1",1,"A1_COD",.T.)
	cLoja   := "01"
	cContr	:= "2" 	
Endif

aDadoscli := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montando Lay-Out para execucao do processo Automatico              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aDadosCli,{"A1_COD"       ,cCodCli         		,nil})
aadd(aDadosCli,{"A1_LOJA"      ,cLoja            		,nil})
aadd(aDadosCli,{"A1_TIPO"      ,"F"              		,nil})
aadd(aDadosCli,{"A1_PESSOA"    ,"F"             	    ,nil})
aadd(aDadosCli,{"A1_CGC"       ,Alltrim(aArquivo[i,09]),nil})
aadd(aDadosCli,{"A1_INSCR"     ," "						,nil})
aadd(aDadosCli,{"A1_NOME"      ,aArquivo[i,4]			,nil})
aadd(aDadosCli,{"A1_NREDUZ"    ,aArquivo[i,4]			,nil})// Mesmo que o A1_NOME
aadd(aDadosCli,{"A1_END"       ,aArquivo[i,10]			,nil})
aadd(aDadosCli,{"A1_BAIRRO"    ,aArquivo[i,22]			,nil})
aadd(aDadosCli,{"A1_MUN"       ,aArquivo[i,11]			,nil})
aadd(aDadosCli,{"A1_EST"       ,aArquivo[i,12]			,nil})
aadd(aDadosCli,{"A1_CEP"       ,aArquivo[i,14]			,nil})
aadd(aDadosCli,{"A1_PAIS"      ,"105"  			        ,nil})
aadd(aDadosCli,{"A1_CODPAIS"   ,"01058"       			,nil})
aadd(aDadosCli,{"A1_GRPTRIB"   ,"001"       			,nil})  // Grupo de Tributação OS 1770/14
aadd(aDadosCli,{"A1_CONTRIB"   ,cContr 	       			,nil})  // OS 3731/15 - 15/12/15 - Eduardo Dias

dbSelectArea("CC2")
dbSetOrder(1)
If dbSeek(xFilial("CC2")+aArquivo[i,12]+aArquivo[i,42])
	aadd(aDadosCli,{"A1_COD_MUN",aArquivo[i,42] ,nil})
EndIf

aadd(aDadosCli,{"A1_CONTATO"," "           ,nil})
aadd(aDadosCli,{"A1_TEL"    ,aArquivo[i,16],nil})
aadd(aDadosCli,{"A1_EMAIL"  ," "			,nil}) // OS 3866/12 Desconsiderar email do arquivo.
aadd(aDadosCli,{"A1_NATUREZ",_cNaturez     ,nil})
aadd(aDadosCli,{"A1_TPCLI"  ,'N'           ,nil})  // Campo obrigatorio para a CSU

lMSHelpAuto := .t.
lMSErroAuto := .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera cliente automatico                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MsExecAuto({|x,y|Mata030(x,y)},aDadosCli,nOpcAuto)

If lMsErroAuto
	While ( __lSx8 )
		RollBackSx8()
	EndDo
	_cErro:=criatrab(,.f.)
	_cErro:="SC"+strzero(val(substr(_cErro,3,5))-1,5)+"0.log"
	_cMsLog:=alltrim(strtran(memoread(_cErro),"  "," "))
	//	_cMsLog:=strtran(_cMsLog,CHR(13)+CHR(10),CHR(10))
	////_cMsLog:=padr(left(_cMsLog,_nLargLog),_nLargLog)
	
	nLinhas:=MLCount(_cMsLog)
	cBuffer:=""
	cCampo:=""
	nErrLin:=1
	cBuffer:=RTrim(MemoLine(_cMsLog,,nErrLin))
	//Carrega o nome do campo
	While (nErrLin <= nLinhas)
		nErrLin++
		cBuffer:=RTrim(MemoLine(_cMsLog,,nErrLin))
		
		If (cBuffer == "Um ou alguns campos obrigatórios não")
			cCampo:=_cMsLog
			FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
			FWrite(nLog,"Problema na criacao do Pedido de venda "+cCodCli+" / "+ALLTRIM(aArquivo[i,04])+' - Erro - '+cCampo+" "+Chr(13)+Chr(10))
		Endif
		
		If (Upper(SubStr(cBuffer,Len(cBuffer)-7,Len(cBuffer))) == "INVALIDO")
			cCampo:=cBuffer
			FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
			FWrite(nLog,"Problema na criacao do Pedido de venda "+cCodCli+" / "+ALLTRIM(aArquivo[i,04])+' - Erro - '+cCampo+" "+Chr(13)+Chr(10))
			Exit
		EndIf
	EndDo
	
	lRetorno   :=.F.
	_nErro++
	
Else
	While ( __lSx8 )
		ConfirmSX8()
	EndDo
	lRetorno := .T.
EndIf


Return(lRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera Produto automatico                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Criaprod(i,_Encontrou)

if _Encontrou
	nOpcAuto := 4
	_cCodigoProd:=SB1->B1_COD
Else
	nOpcAuto := 3
	_cCodigoProd:=aArquivo[i,20]+"G"
Endif

aIncSB1 := {}
aAdd(aIncSB1,{"B1_COD"      ,_cCodigoProd         ,Nil}) // Codigo
aAdd(aIncSB1,{"B1_CODITE"   ,_cCodigoProd         ,Nil}) // Codigo
aAdd(aIncSB1,{"B1_DESC"     ,aArquivo[i,19]       ,Nil}) // Descricao
aAdd(aIncSB1,{"B1_TIPO"     ,'PA'                 ,Nil}) // Tipo do Produto
aAdd(aIncSB1,{"B1_UM"       ,'UN'			       ,Nil}) //
aAdd(aIncSB1,{"B1_LOCPAD"   ,"01"                 ,Nil}) //
aAdd(aIncSB1,{"B1_PICM"     ,Val(aArquivo[i,30])  ,Nil}) // By Douglas David OS 0949/14
aAdd(aIncSB1,{"B1_IPI"      ,0                    ,Nil}) //
aAdd(aIncSB1,{"B1_POSIPI"   ,aArquivo[i,43]       ,Nil}) //
aAdd(aIncSB1,{"B1_ORIGEM"   ,aArquivo[i,64]       ,Nil}) //
aAdd(aIncSB1,{"B1_MSBLQL"   ,"2"                  ,Nil}) //Inclui Desbloqueado
aAdd(aIncSB1,{"B1_CTAPCO" 	,"3050101"            ,Nil})
aAdd(aIncSB1,{"B1_X_APROV" 	,"400100"             ,Nil})
aAdd(aIncSB1,{"B1_PCOFINS" 	,7.6           		  ,Nil})
aAdd(aIncSB1,{"B1_PPIS" 	,1.65         		  ,Nil})
aAdd(aIncSB1,{"B1_IRRF" 	,"N"          		  ,Nil})
aAdd(aIncSB1,{"B1_TPREG" 	,"1"          		  ,Nil})
aAdd(aIncSB1,{"B1_GARANT" 	,"2"          		  ,Nil})
aAdd(aIncSB1,{"B1_GRTRIB" 	,"001"         		  ,Nil})  // Grupo de Tributação OS 1770/14
aAdd(aIncSB1,{"B1_LOCALIZ" 	,"N"          		  ,Nil})
aAdd(aIncSB1,{"B1_CLASFIS" 	,substr(aArquivo[i,35],2,2)        		  ,Nil})  // Classificação Fiscal OS 0949/14

cTes:=substr(aArquivo[i,35],2,2)
cQuery2:="SELECT ZYZ_TS,ZYZ_TE FROM "+RetSqlName('ZYZ')+" ZYZ WHERE ZYZ_CST='"+cTes+"' AND ZYZ.D_E_L_E_T_=''"

U_MontaView(cQuery2,"CONS2")
DBSELECTAREA("CONS2")
CONS2->(dbGoTop())
_cTS :=ALLTRIM(CONS2->ZYZ_TS)
_cTE :=ALLTRIM(CONS2->ZYZ_TE)
DBCLOSEAREA("CONS2")
aAdd(aIncSB1,{"B1_TE" ,_cTE ,Nil}) //Inclui Tes de entrada com base na amarração
aAdd(aIncSB1,{"B1_TS" ,_cTS ,Nil}) //Inclui Tes de entrada com base na amarração


lMSHelpAuto := .t.
lMSErroAuto := .f.

MSExecAuto({|x,y| mata010(x,y)},aIncSB1,nOpcAuto)

if lMSErroAuto   //deu certo  , se retornar .t. deu erro
	
	_cErro:=criatrab(,.f.)
	_cErro:="SC"+strzero(val(substr(_cErro,3,5))-1,5)+"0.log"
	_cMsLog:=alltrim(strtran(memoread(_cErro),"  "," "))
	
	nLinhas:=MLCount(_cMsLog)
	cBuffer:=""
	cCampo:=""
	nErrLin:=1
	cBuffer:=RTrim(MemoLine(_cMsLog,,nErrLin))
	//Carrega o nome do campo
	While (nErrLin <= nLinhas)
		nErrLin++
		cBuffer:=RTrim(MemoLine(_cMsLog,,nErrLin))
		If (Upper(SubStr(cBuffer,Len(cBuffer)-7,Len(cBuffer))) == "INVALIDO")
			cCampo:=cBuffer
			FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
			FWrite(nLog,"Problema na criacao do Produto "+_cCodigoProd+", Linha: "+"nContLi"+" - Erro - "+cCampo+" "+Chr(13)+Chr(10)) //130415
			//			FWrite(nLog,"Problema na criacao do Produto "+_cCodigoProd+", Linha: "+nContLi+" - Erro - "+cCampo+" "+Chr(13)+Chr(10))
			Exit
		EndIf
		
	EndDo
	
	lRetorno   :=.F.
	_nErro++
	
Else
	lRetorno := .T.
EndIf

Return(	lRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera Pedido de Venda automatico                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Criaped(i)

// Cabecalho do pedido
       
Local _cPedido	:= GETSX8NUM("SC5", "C5_NUM") 
Local cRetErro	:= ""

aCabec   := {}
aPvlNfs  := {}
aBloqueio:= {}
aItens   := {}

cTes:=substr(aArquivo[i,35],2,2)
cQuery2:="SELECT ZYZ_TS, ZYZ_TSF FROM "+RetSqlName('ZYZ')+" ZYZ WHERE ZYZ_CST='"+cTes+"' AND ZYZ.D_E_L_E_T_=''"

U_MontaView(cQuery2,"CONS2")
DBSELECTAREA("CONS2")
CONS2->(dbGoTop())  
If aArquivo[i,12] == "SP"
	_cTES:=ALLTRIM(CONS2->ZYZ_TS)
Else
	_cTES:=ALLTRIM(CONS2->ZYZ_TSF)
EndIF
DBCLOSEAREA("CONS2")  

DBSELECTAREA('SC5')
SC5->(dbSetOrder(1))
SC5->(DbGotop())
While SC5->(Dbseek(xFilial("SC5")+_cPedido))
	_cPedido := GETSX8NUM("SC5", "C5_NUM")
	dbSkip()
EndDo

cCliente	:= Posicione("SA1",3,xFilial("SA1")+Alltrim(aArquivo[i,09]),"A1_COD")
cLoja		:= Posicione("SA1",3,xFilial("SA1")+Alltrim(aArquivo[i,09]),"A1_LOJA")       

If Empty(cCodCli)
	MSGALERT("Cadastrar cliente: " + aArquivo[i,4])
EndIf

aAdd( aCabec, { "C5_NUM"     , _cPedido             , Nil })
aAdd( aCabec, { "C5_TIPO"    , "N"                  , Nil })
aAdd( aCabec, { "C5_CLIENTE" , cCliente		        , Nil })
aAdd( aCabec, { "C5_LOJACLI" , cLoja		        , Nil })
aAdd( aCabec, { "C5_LOJAENT" , cLoja		        , Nil })
aAdd( aCabec, { "C5_CONDPAG" , "030"                , Nil })
aAdd( aCabec, { "C5_PESOL"   ,Val(aArquivo[i,21])	, Nil })
aAdd( aCabec, { "C5_CC"      , _cCustPv             , Nil })
aAdd( aCabec, { "C5_ITEM"    , _cNegoPv             , Nil })
aAdd( aCabec, { "C5_CLVL"    , _cOperPv             , Nil })  // Renato Carlos
aAdd( aCabec, { "C5_AREA"    , _cArea               , Nil })  // Campo Obrigatorio -  Renato Carlos
aAdd( aCabec, { "C5_TIPLIB"  , "1"             	    , Nil })  // Renato Carlos
aAdd( aCabec, { "C5_TPCARGA" , "2"             	    , Nil })  // Renato Carlos
aAdd( aCabec, { "C5_FILIAL"  , xfilial("SC5")		, Nil })  // Renato Carlos
aAdd( aCabec, { "C5_EMISSAO" , CTOD(aArquivo[i,32]) , Nil })  // Renato Carlos
aAdd( aCabec, { "C5_MOEDA"   , 1					, Nil })  // Renato Carlos
aAdd( aCabec, { "C5_LIBEROK" , "S"					, Nil })  // Renato Carlos
aAdd( aCabec, { "C5_TIPOCLI" , "F"					, Nil })  // Renato Carlos
aAdd( aCabec, { "C5_X_RESG"  , aArquivo[i,1]		, Nil })
//aAdd( aCabec, { "C5_FOB"     , aArquivo[i,59], Nil } )
//aAdd( aCabec, { "C5_CC"      , aArquivo[i,50], Nil } )
// Contador dos itens
nx     := 0
// ATENCAO - VARIAVEL CRIADAS POR CAUSA DA QUEBRA NO FATURAMENTO
aNotaFeita := {}

//cProduto := CriaSb1()
aLinha   := {}
// Senao encontrou nenhum valor assume 1

nX++

aAdd( aLinha, { "C6_ITEM"	 , StrZero( nx, 2 )											    , Nil } )
aAdd( aLinha, { "C6_UM"      , aArquivo[i,45] 								   	            , Nil } )
aAdd( aLinha, { "C6_PRODUTO" , _cCodigoProd					    							, Nil } )
aAdd( aLinha, { "C6_QTDVEN"	 , VAL(aArquivo[i,24])											, Nil } )
aAdd( aLinha, { "C6_PRCVEN"	 , noround(VAL(aArquivo[i,23])/100,2)							, Nil } )
aAdd( aLinha, { "C6_PRUNIT"	 , noround(VAL(aArquivo[i,23])/100,2)							, Nil } )
aAdd( aLinha, { "C6_VALOR"	 , NOROUND(VAL(aArquivo[i,23])/100,2) * VAL(aArquivo[i,24])	, Nil } )
aAdd( aLinha, { "C6_CALINSS" , 'N'	            		   									, Nil } )
aAdd( aLinha, { "C6_CCUSTO"  , _cCustPv					    								, Nil } )
aAdd( aLinha, { "C6_ITEMD"   , _cNegoPv														, Nil } )
aAdd( aLinha, { "C6_CLVLDB"  , _cOperPv														, Nil } )
aAdd( aLinha, { "C6_QTDEMP"  , VAL(aArquivo[i,24])    										, Nil } )
aAdd( aLinha, { "C6_ENTREG"  , CTOD(aArquivo[i,32])    										, Nil } )
aAdd( aLinha, { "C6_QTDLIB"  , VAL(aArquivo[i,24])    										, Nil } )
aAdd( aLinha, { "C6_X_RESG"  , aArquivo[i,1]     											, NIL } )
aAdd( aLinha, { "C6_TES"	 , _cTES					    								, Nil } )
aAdd( aLinha, { "C6_LOCAL"   , "01"					            							, Nil } )
//aAdd( aLinha, { "C6_LOCAL"   , aArquivo[i,56]									   			, Nil } )
//aAdd( aLinha, { "C6_RESGATE" , aArquivo[i,01]												, Nil } )
//aAdd( aLinha, { "C6_CST"     , aArquivo[i,35]												, Nil } )
//aAdd( aLinha, { "C6_CF"      , aArquivo[i,36]												, Nil } )
//aAdd( aLinha, { "C6_DTRESG"  , CTOD(aArquivo[i,43])										, Nil } )

aAdd( aItens, aLinha )

lMSErroAuto := .f.
nSaveSX8 := GetSx8Len()

// Inclusao do pedido
//MATA410( aCabec, aItens, 3 )
MVPAR01 := MV_PAR01

MSExecAuto( { |x, y, z| mata410(x, y, z) }, aCabec, aItens, 3 ) //Inclusao
//MostraErro () 

If !lMsErroAuto
	ConfirmSX8()
Else
	RollBackSX8()
EndIf

// Checa erro de rotina automatica
If lMsErroAuto
	If __lSX8
		Rollbacksx8()
	endif                
	//EDU   
   
   	Dbselectarea("SC7")
	cArqNtx  := CriaTrab(NIL,.f.)
	cIndCond :="C7_FILIAL + C7_PRODUTO + C7_X_RESG "
	IndRegua("SC7",cArqNtx,cIndCond,,," ")
	DBGOTOP()    

	cProduto := ALLTRIM(aArquivo[i,20])+"G"+SPACE((TamSX3("B1_COD")[1])- LEN(ALLTRIM(aArquivo[i,20]+"G")))

	IF !empty(aArquivo[i,1]) .and.  Dbseek(xFilial("SC7")+cProduto+aArquivo[i,1] )					
		// Se existir Pedido de Compra para o registro que de Erro na geração do Pedido de Venda, DELETA o pedido de compra
		nPedido	:= SC7->C7_NUM //Posicione("SC7",21,aArquivo[i,01], "C7_NUM") //C7_FILIAL+C7_X_RESG
		RecLock("SC7",.F.)
		SC7->(dbDelete())
		MsUnLock()      		
		FWrite(nLog,"Erro na gravação do Pedido de Venda ref. o resgate "+ ALLTRIM(aArquivo[i,01])+", com isso o Pedido de Compra "+nPedido+" foi deletado."+Chr(13)+Chr(10))
	EndIf         
     
     DBCLOSEAREA("SC7")
	_cErro:=criatrab(,.f.)
	_cErro:="SC"+strzero(val(substr(_cErro,3,5))-1,5)+"0.log"
	_cMsLog:=alltrim(strtran(memoread(_cErro),"  "," "))
	//    _cMsLog:=strtran(_cMsLog,CHR(13)+CHR(10),CHR(10))
	//    _cMsLog:=padr(left(_cMsLog,_nLargLog),_nLargLog)
	nLinhas:=MLCount(_cMsLog)
	cBuffer:=""
	cCampo:=""
	nErrLin:=1
	cBuffer:=RTrim(MemoLine(_cMsLog,,nErrLin))
	cRetErro := MostraErro("C:\siga")  
	
	If !Empty(cRetErro)
		cRetErro := PadR( cRetErro, 67)
		FWrite(nLog,"Problema na criacao do Pedido de venda "+_cPedido+", Resgate: "+ALLTRIM(aArquivo[i,01])+" - Erro - "+cRetErro+" "+Chr(13)+Chr(10))
    EndIf
    
	//Carrega o nome do campo
	While (nErrLin <= nLinhas)
		nErrLin++
		cBuffer:=RTrim(MemoLine(_cMsLog,,nErrLin))
		If (Upper(SubStr(cBuffer,Len(cBuffer)-7,Len(cBuffer))) == "INVALIDO")
			cCampo:=cBuffer
			//xTemp:=AT("-",cBuffer)
			//cCampo:=AllTrim(SubStr(cBuffer,xTemp+1,AT(":",cBuffer)-xTemp-2))
			FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
			FWrite(nLog,"Problema na criacao do Pedido de venda "+_cPedido+", Resgate: "+ALLTRIM(aArquivo[i,01])+" - Erro - "+cCampo+" "+Chr(13)+Chr(10))
			Exit
		EndIf
	EndDo
	
	lRetorno   :=.F.
	_nErro++
Else
	
	If __lSX8
		ConfirmSX8()
	endif
	
	Dbselectarea("SC9")
	Dbsetorder(1)
	IF	Dbseek(xFilial("SC9")+SC5->C5_NUM)
		While !eof() .AND. SC5->C5_NUM == SC9->C9_PEDIDO
			
			If ( SC9->C9_BLCRED $ "01/02/04/05/06/09"  .And. SC9->C9_BLEST $ "02/03" )
				Begin Transaction
				a460Estorna(.T.)
				End Transaction
			endif
			Dbselectarea("SC9")
			Dbskip()
		ENDDO
	ENDIF
	lRetorno := .T.
endif

Return(lRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera Fornecedor automatico - FUNCAO DESABILITA CRIACAO DO FORNECEDOR E REALIZADO APENAS MANUALMENTE                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera Pedido de Compra  automatico                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

STATIC FUNCTION PEDCOM(i)

//-- Preenche cabecalho
Local aCab 	:= {}                               
Local aArea	:= GetArea()

//BUSCA O CODIGO DO FORNECEDOR
DBSELECTAREA('SA2')
Dbseek(xFilial("SA2")+aArquivo[i,46])
cCodFor:=SA2->A2_COD
cLoja:=SA2->A2_LOJA

//Verifica se o numero já nao foi usado e/ou consistencia do SXE/SXF        
_cPedido := GETSX8NUM("SC7", "C7_NUM") //edu          

SC7->(dbSetOrder(1))
SC7->(DbGotop())
While SC7->(Dbseek(xFilial("SC7")+_cPedido))
	_cPedido := GETSX8NUM("SC7", "C7_NUM")
	dbSkip()
EndDo

AAdd(aCab,{"C7_NUM"    , _cPedido   	        ,NIL})
AAdd(aCab,{"C7_EMISSAO", CTOD(aArquivo[i,32])  ,NIL})
AAdd(aCab,{"C7_FORNECE", cCodFor       			,NIL})// FIXO INFORMADO PELA AREA DEMANDANTE
AAdd(aCab,{"C7_LOJA"   , cLoja  				,NIL})// FIXO INFORMADO PELA AREA DEMANDANTE
AAdd(aCab,{"C7_CONTATO", " "            		,NIL})
AAdd(aCab,{"C7_COND"   , SA2->A2_COND     		,NIL})
AAdd(aCab,{"C7_FILENT" , xFilial("SC7")			,NIL})

aItens := {}

nItem := 1
cC7Item := StrZero(nItem,TamSX3("C7_ITEM")[1])

nPreco := noround(VAL(aArquivo[i,23])/100,2)
nQtd := VAL(aArquivo[i,24])
nTotal := nPreco * nQtd
nFrete :=noround(VAL(aArquivo[i,33])/100,2) // OS 1428/13

DBSELECTAREA('SB1')
Dbseek(xFilial("SB1")+_cCodigoProd)

//-- Preenche itens
AAdd(aItens,{;
{"C7_ITEM"		, cC7Item 			,NIL},;
{"C7_PRODUTO"	, _cCodigoProd      ,NIL},;
{"C7_QUANT"  	, nQtd   			,NIL},;
{"C7_PRECO"  	, nPreco 			,NIL},;
{"C7_TOTAL"  	, nTotal 			,NIL},;
{"C7_DATPRF" 	, dDataBase      	,NIL},;
{"C7_FLUXO"  	, "S"         		,NIL},;
{"C7_OBS"    	, " "        		,NIL},;
{"C7_LOCAL" 	, SB1->B1_LOCPAD	,NIL},;
{"C7_CODED" 	, " "       		,NIL},;
{"C7_NUMPR" 	, " "   			,NIL},;
{"C7_CC" 		, _cCustPc          ,NIL},;
{"C7_ITEMCTA" 	, _cNegoPc       	,NIL},;
{"C7_CLVL" 		, _cOperPc      	,NIL},;
{"C7_TES" 		, SB1->B1_TE        ,NIL},;
{"C7_VALFRE" 	, nFrete			,NIL},;  // OS 1428/13
{"C7_X_RESG"    , aArquivo[i,1]     ,NIL},;
{"C7_USER"	    , __cUserId        	,NIL},;
{"C7_X_USRA"    , "GERADO AUTOMAT"	,NIL},;// Definir com o demandante qual será o usuário padrão
{"C7_CONAPRO"	, "L"      	   		,NIL},;
{"C7_X_RESGP"   , aArquivo[i,40]    ,NIL},;// OS 3193/14 Eduardo Dias - Totvs
{"C7_X_NFGP"	, Alltrim(aArquivo[i,25])+Alltrim(aArquivo[i,26])+"SPED" ,NIL}})

nItem	:= 1
lMSErroAuto := .f.

//	MsExecAuto({|v,x,y,z| MATA120(v,x,y,z,a)},1,aCab,aItens,3)
//	MsExecAuto({|v,x,y,z,a| MATA120(v,x,y,z,a)},1,aCab,aItens,3)
MSExecAuto({|v,x,y,z,w,a| MATA120(v,x,y,z,w,a)},1,aCab,aItens,3,.F.,)
//	MostraErro ()

If lMsErroAuto
	//MostraErro ()
	_cErro:=criatrab(,.f.)
	_cErro:="SC"+strzero(val(substr(_cErro,3,5))-1,5)+"ERR0.log"
	_cMsLog:=alltrim(strtran(memoread(_cErro),"  "," "))
	//	_cMsLog:=strtran(_cMsLog,CHR(13)+CHR(10),CHR(10))
	//	_cMsLog:=padr(left(_cMsLog,_nLargLog),_nLargLog)
	
	nLinhas:=MLCount(_cMsLog)
	cBuffer:=""
	cCampo:=""
	nErrLin:=1
	cBuffer:=RTrim(MemoLine(_cMsLog,,nErrLin))
	//Carrega o nome do campo
	While (nErrLin <= nLinhas)
		nErrLin++
		cBuffer:=RTrim(MemoLine(_cMsLog,,nErrLin))
		If (Upper(SubStr(cBuffer,Len(cBuffer)-7,Len(cBuffer))) == "INVALIDO")
			cCampo:=cBuffer
			//xTemp:=AT("-",cBuffer)
			//cCampo:=AllTrim(SubStr(cBuffer,xTemp+1,AT(":",cBuffer)-xTemp-2))
			nContLi:=cvaltochar(nContLi)
			FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
			FWrite(nLog,"Problema na criacao do Pedido de compra "+_cPedido+", Linha: "+nContLi+" - Erro - "+cCampo+" "+Chr(13)+Chr(10))
			
			Exit
		EndIf
	EndDo
	
	lRetorno   :=.F.
	_nErro++ 
	
	RollBackSX8()
	
Else  
	ConfirmSX8()
	lRetorno := .T.
Endif          
      
RestArea(aArea)
RETURN(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xACChkCGC ºAutor  ³Fernando Lima       º Data ³  09/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica a validade do CNPJ/CPF sem exibir mensagem de erro º±±
±±º          ³caso o CNPJ/CPF seja invalido.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xACChkCGC( cCGC )
Local nTam, nCnt, i, j, nSum, nDIG
Local cCPF := ""
Local cDVC := ""
Local cDIG := ""
Local lRet := .F.


nTam := Len( AllTrim( cCGC ) )

cDVC := SubStr( cCGC, 13, 02 )
cCGC := SubStr( cCGC, 01, 12 )

for j := 12 to 13
	nCnt := 1
	nSum := 0
	for i := j to 1 Step -1
		nCnt++
		if nCnt > 9
			nCnt := 2
		endif
		nSum += ( val( substr( cCGC,i,1) ) * nCnt )
	next i
	nDIG := if( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
	cCGC := cCGC + STR( nDIG, 1 )
	cDIG := cDIG + STR( nDIG, 1 )
next j

lRet := cDIG == cDVC

if !lRet
	if nTam < 14
		cDVC := SubStr( cCGC, 10, 2 )
		cCPF := SubStr( cCGC, 01, 9 )
		cDIG := ""
		
		for j := 10 to 11
			nCnt := j
			nSum := 0
			for i:= 1 to len( trim( cCPF ) )
				nSum += ( Val( SubStr( cCPF, i, 1 ) ) * nCnt )
				nCnt--
			next i
			nDIG := if( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
			cCPF := cCPF + STR( nDIG, 1 )
			cDIG := cDIG + STR( nDIG, 1 )
		next j
		
		lRet := cDIG == cDVC
	endif
endif

Return lRet

Static  Function Valarq(_Arq, _Ordem, _Chave)

_Retorno := .F.

Dbselectarea(_arq)
Dbsetorder(_Ordem)
IF dbseek(xFilial(_arq)+_Chave)
	_Retorno := .T.
ENDIF

Return(_Retorno)
                         

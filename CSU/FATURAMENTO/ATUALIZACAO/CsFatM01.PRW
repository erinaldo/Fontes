#include "rwmake.ch"

//=======  DEFINES PARA FUNCAO cGetFile - INICIO =======//
#DEFINE GETF_ONLYSERVER                   0
#DEFINE GETF_OVERWRITEPROMPT              1
#DEFINE GETF_MULTISELECT                  2
#DEFINE GETF_NOCHANGEDIR                  4
#DEFINE GETF_LOCALFLOPPY                  8
#DEFINE GETF_LOCALHARD                   16
#DEFINE GETF_NETWORKDRIVE                32
#DEFINE GETF_SHAREAWARE                  64
#DEFINE GETF_RETDIRECTORY               128
//=======  DEFINES PARA FUNCAO cGetFile - FIM =======//

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSFATM01  บAutor  ณRicardo Luiz da Rocha บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Importacao do arquivo Fullfilment                           บฑฑ
ฑฑบ          ณ  14/09/2004 GNSJC                                            บฑฑ
ฑฑบ          ณ Procedimento para a implantacao:                             บฑฑ
ฑฑบ          ณ -Criacao da tabela SZB (Sx2,Sx3 e Six)                       บฑฑ
ฑฑบ          ณ -Alterar o X3_CBOX E X3_VLDUSER de A1_TPCLI,                 บฑฑ
ฑฑบ          ณ acrescentar U=FullFilment                                    บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑบ          ณ 22/05/06 - Revisao para uso na CSU - Ricardo                 บฑฑ
ฑฑบ          ณ Procedimento para a revisao:                                 บฑฑ
ฑฑบ          ณ -Incluir o campo C5_CSNFF C 6 Posicao: 3 (logo apos o n.     บฑฑ
ฑฑบ          ณ do pedido)                                                   บฑฑ
ฑฑบ          ณ -Incluir o campo C9_CSNFF C 6 Posicao: 5 (logo apos o n.     บฑฑ
ฑฑบ          ณ do item)                                                     บฑฑ
ฑฑบ          ณ (Ambos os campos devem aparecer no browse)                   บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑบ          ณ -Inclusao do ponto de entrada Mta440c9                       บฑฑ
ฑฑบ          ณ -Remocao da rotina SF2460i_1.02.prw                          บฑฑ
ฑฑบ          ณ -Inclusao da rotina SF2460i.prw                              บฑฑ
ฑฑบ          ณ -Inclusao do novo indice para SC5 - 6 -                      บฑฑ
ฑฑบ          ณ C5_FILIAL+C5_CSNFF (Nf p/ Fullfilment)                       บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function CsFatM01()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
private _cPerg:='FatM01',_nHdl:=0,_cTimeIni,_lTemErro:=.f.,_cNumLog,_oDlg1,_dDataLog,_cHoraLog,_nLargLog:=800,;
_nOrdLog,_cLinArq,_vPedidos,_vSc5:={},_vSc6:={},_vSc6a:={},_vSc9:={},_vSc9a:={},_vItens2:={},aHeader:={},aCols:={},_lInclui,;
_nSa1Inc,_nSa1Alt,_nSa1Rej,_nSb1Inc,_nSb1Alt,_nSb1Rej,_nSc5Inc,_nSc5Alt,_nSc5Rej,_vPedImp:={}

private arotina:= MenuDef()
// incluido por Daniel G.Jr.TI1239 em 19/06/07
private _cArea := GetNewPar("MV_XFFAREA","MARK")			// Area de Negocios padrใo
private _cCust := GetNewPar("MV_XFFCUST","0701010000")		// Centro de Custos padrใo
private _cNego := GetNewPar("MV_XFFNEGO","0902")		 	// Unidade Negocios padrใo
private _cOper := GetNewPar("MV_XFFOPER","999999999")		// Operacao padrใo
//-------------------------------------

//AADD(aRotina,{"","",0,3})
//AADD(aRotina,{"","",0,3})
//AADD(aRotina,{"","",0,3})
//AADD(aRotina,{"","",0,3})
//AADD(aRotina,{"","",0,3})
//AADD(aRotina,{"","",0,3})
//AADD(aRotina,{"","",0,3})

private _cNewSc5

ValidPerg(_cPerg)

@ 100,091 To 285,527 Dialog _oDlg1 Title 'Importacao de registros do sistema "FullFilment"'
@ 012,016 Say u__fAjTxt('Esta rotina realizara a importacao de clientes, produtos e pedidos de venda,')
@ 022,016 Say u__fAjTxt('exportados do sistema "FullFilment".')
@ 032,016 Say u__fAjTxt('Caso o processamento seja concluido normalmente, ao termino     ')
@ 042,016 Say u__fAjTxt("o arquivo origem tera sua extensao alterada para .OK            ")

@ 075,020 BmpButton Type 1 Action _fProssegue()
@ 075,090 BmpButton Type 5 Action pergunte(_cPerg,.t.)
@ 075,160 BmpButton Type 2 Action close(_oDlg1)

Activate Dialog _oDlg1 centered

SA1->(RetIndex(alias()))
SB1->(RetIndex(alias()))
SC5->(RetIndex(alias()))
SC6->(RetIndex(alias()))
SZB->(RetIndex(alias()))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fProssegue บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU        	                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fProssegue
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de veriแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SM0->(M0_CODIGO<>'05'.or. M0_CODFIL<>'03')
	MsgBox("Esta rotina apenas pode ser executada na empresa: 05 (CSU CARDSYSTEM) - filial: 03 (ALPHAVILLE)")
	Return
Endif

_vPedImp	:={}
_vPedidos	:={}
_vItens2	:={}     

Pergunte(_cPerg,.f.)

_dDataLog	:=	date()
_nSa1Inc:=_nSa1Alt:=_nSa1Rej:=_nSb1Inc:=_nSb1Alt:=_nSb1Rej:=_nSc5Inc:=_nSc5Alt:=_nSc5Rej:=0
_nOrdLog	:=	0
_nLenOcor	:=	100

CursorWait()

_cDirTxt  	:=	Alltrim(MV_PAR01) // Diretorio
_cNomTxt  	:=	Alltrim(MV_PAR02) // Nome do arquivo
_lExibErro	:=	(MV_PAR03==1) // Exibir erros durante a execucao 1=Sim;2=Nao
_cNatureza	:=	MV_PAR04 // Natureza para o pedido de vendas
_cTes1		:=	MV_PAR05 // TES para o pedido  (icms tributado)
_cTes2		:=	MV_PAR06 // TES para o pedido  (icms nao incidente)
_cTes3		:=	MV_PAR07 // TES para o pedido  (icms outros)
_nTesSIcms	:=	MV_PAR08 // TES quando nao ha icms 1=_cTes2,2=_cTes3
_cLocal		:=	MV_PAR09 // Almoxarifado para o pedido

If Right(_cDirTxt,1)<>"\"
	_cDirTxt	+=	"\"
Endif

_cTeste		:=	MemoRead(_cDirTxt+_cNomTxt)

If Empty(_cNomTxt)
	
	MsgBox('O nome do arquivo de origem nao foi informado')
	CursorArrow()
 
	Return
	
Endif

If (	_nHdl	:=	fopen(_cDirTxt+_cNomTxt,0)	)	==	-1
	MsgBox('Erro na abertura do arquivo texto: '+_cDirTxt+_cNomTxt)
	CursorArrow()
	Return
Endif

_cTimeIni	:=+ DTOC(date())+" "+(_cHoraLog:=TIME())+" h.."

u_RsAguarde({||_fImporta()},'Inicio: '+_cTimeIni)

If _lTemErro
	MsgBox("Erro na importacao","Erro","STOP")
Else
	_cNewName:=_cNomTxt
	_nPosic:=RAT(".",_cNomTxt)
	If _nPosic>0
		_cNewName:=LEFT(_cNewName,_nPosic-1)
	Endif              
	
	_cNewName+=".Ok"
	fErase(_cDirTxt+_cNewName)
	fRename(_cDirTxt+_cNomTxt,_cDirTxt+_cNewName)
	MsgBox("Concluido, Inicio: "+_cTimeIni+"     Fim: "+DTOC(date())+" "+TIME()+" h" ,"Informacao","INFO")
	u_CsFatM1b(_cNumLog)
	
EndIf

CursorArrow()

Close(_oDlg1)

Return                                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fImporta บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fImporta
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
local _cLinha

CursorWait()

// Cria o numero no registro de log
_cNumLog	:= GetSX8Num("SZB","ZB_NUMERO")

ConfirmSX8()
_cLastMens	:= ""

U_RsProcTXT("Preparando os dados para a importacao")
U_RsProcTXT("Iniciando o processo de leitura")

_cQuebral	:=chr(13)+chr(10)

_nTam		:=fSeek(_nHdl,0,2)
_cTam		:='/'+Alltrim(STR(_nTam))
_cHoraIni	:=TIME()
_lTemErro	:=.F.
_nBytesLidos:=_nRegLidos:=0
_cSaldoLinha:=""
_nTamBloco	:=50000 // Largura a ser lida a cada acesso a disco
_nTamBloco	:=Max(_nTamBloco,Len(_cQuebral)+1)
_nTamBloco	:=Min(_nTamBloco,64000)
fSeek(_nHdl,0,0) // Posiciona o ponteiro no inicio do arquivo

_nBytesTrat	:=0
_cMen2:=_cMen3:=_cMen4:=_cMen5:=""
_cSaldoLin	:=""
_vLeitura	:={}

Do while _nBytesLidos < _nTam
	
	_cLinha	:=	""
	
	Do while .T. // Le ate encontrar no minimo uma quebra de linha ou o final do arquivo
	
		_cLido			:=	space(_nTamBloco)
		_nBytesAgora	:=	FREAD(_nHdl,@_cLido,_nTamBloco)
		_cLinha			+=	_cLido
		_nBytesLidos	+=	_nBytesAgora
		
		u_rsproctxt(' Importando: '+tran(_nBytesTrat/_nTam*100," 999.99 %")+'    -    Registros lidos: '+Alltrim(str(_nRegLidos))+_cMen2)
		
		If _nBytesLidos >= _nTam .or. AT(_cQuebral,_cLinha) > 0 .or. Len(_cLinha) > 64000
			exit
		Endif
	Enddo
	
	_cRegistro	:=""
	_cLinha		:=_cSaldoLin+_cLinha
	_cSaldoLin	:=""

	Do While Len(_cLinha) > 0

		_nPosic := at(_cQuebral,_cLinha)
		
		If _nPosic > 0 .or. _nBytesLidos == _nTam
		
			_cRegistro	:= left(_cLinha,_nPosic+len(_cQuebral)-1)
			_cLinha		:= substr(_cLinha,_nPosic+len(_cQuebral))
			
			_fTrataLi1(_cRegistro)
			
			_nBytesTrat	+= len(_cRegistro)
			
			_nRegLidos++
			
			_cMen3		:= "Clientes Incluidos: "+alltrim(str(_nSa1Inc))+" alterados: "+alltrim(str(_nSa1Alt))+" rejeitados: "+alltrim(str(_nSa1Rej))
			_cMen4		:= "Produtos Incluidos: "+alltrim(str(_nSb1Inc))+" alterados: "+alltrim(str(_nSb1Alt))+" rejeitados: "+alltrim(str(_nSb1Rej))
			_cMen5		:= "Pedidos  Incluidos: "+alltrim(str(_nSc5Inc))+" alterados: "+alltrim(str(_nSc5Alt))+" rejeitados: "+alltrim(str(_nSc5Rej))
			
			u_rsproctxt(_cLastMens:=' Lendo: '+tran(_nBytesTrat/_nTam*100," 999.99 %")+'    -    Registros lidos: '+alltrim(str(_nRegLidos))+chr(10)+_cMen2+chr(10)+_cMen3+chr(10)+_cMen4+chr(10)+_cMen5)
			
		Else
		
			_cSaldoLin:=_cLinha
			_cLinha:=""
		Endif
		
	Enddo
	
Enddo

// Ordena o vetor de leitura pela serie + numero da nf
u_rsproctxt("Aguarde, ordenando os dados para importacao")

CursorWait()

aSort(_vLeitura,,,{|_x,_y|substr(_x,327,10)+substr(_x,317,10)<substr(_y,327,10)+substr(_y,317,10)})

_nRegLidos:=0

For _nVezLeit := 1 to Len(_vLeitura)

	_cRegistro	:= _vLeitura[_nVezLeit]
	
	_fTrataLi2(_cRegistro)
	
	_nRegLidos++
	
	_cMen3		:= "Clientes Incluidos: "+alltrim(str(_nSa1Inc))+" alterados: "+alltrim(str(_nSa1Alt))+" rejeitados: "+alltrim(str(_nSa1Rej))
	_cMen4		:= "Produtos Incluidos: "+alltrim(str(_nSb1Inc))+" alterados: "+alltrim(str(_nSb1Alt))+" rejeitados: "+alltrim(str(_nSb1Rej))
	_cMen5		:= "Pedidos  Incluidos: "+alltrim(str(_nSc5Inc))+" alterados: "+alltrim(str(_nSc5Alt))+" rejeitados: "+alltrim(str(_nSc5Rej))
	
	u_rsproctxt(_cLastMens:=' Importando: '+tran(_nVezLeit/len(_vLeitura)*100," 999.99 %")+'    -    Registros lidos: '+alltrim(str(_nRegLidos))+chr(10)+_cMen2+chr(10)+_cMen3+chr(10)+_cMen4+chr(10)+_cMen5)
	
Next

// Importa o ultimo pedido lido
If Len(_vSc5) > 0                             

	// Chamada da rotina de inclusao automatica
	
	_fCallMata410('1')
	
	_nRegLidos++
	
	_cMen3		:= "Clientes Incluidos: "+alltrim(str(_nSa1Inc))+" alterados: "+alltrim(str(_nSa1Alt))+" rejeitados: "+alltrim(str(_nSa1Rej))
	_cMen4		:= "Produtos Incluidos: "+alltrim(str(_nSb1Inc))+" alterados: "+alltrim(str(_nSb1Alt))+" rejeitados: "+alltrim(str(_nSb1Rej))
	_cMen5		:= "Pedidos  Incluidos: "+alltrim(str(_nSc5Inc))+" alterados: "+alltrim(str(_nSc5Alt))+" rejeitados: "+alltrim(str(_nSc5Rej))
	
Endif

// Verificacao de eventuais quebras de sequencia nos pedidos importados
_vSequencias	:= {}

If Len(_vPedImp) > 0

	aSort(_vPedImp)

	_cPedIni:=_cPedFim:=_cPedido:=_vPedImp[1]
	
	For _nVez := 2 to Len(_vPedImp)
	
		If Val(_vPedImp[_nVez])-val(_cPedido) == 1
			_cPedFim	:= _vPedImp[_nVez]
		Else
			aadd(_vSequencias,"De "+_cPedIni+" ate "+_cPedFim)
			_cPedIni:=_cPedFim:=_vPedImp[_nVez]
		Endif                                    
		
		_cPedido:=_vPedImp[_nVez]
		
	Next

	// Adiciona a ultima sequencia
	Aadd(_vSequencias,"De "+_cPedIni+" ate "+_cPedFim)
	
	_fGravaLog("A","SC5",_cLinArq,padr("Sequencias de importacao: ",30))
	
	For _nVez := 1 to Len(_vSequencias)
	
		_fGravaLog("A","SC5",_cLinArq,_vSequencias[_nVez])
		
	Next
	
Endif

MsgBox("Concluido, "+_cLastMens)

fclose(_nHdl)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fTrataLi1 บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                             บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fTrataLi1(_cRegistro)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/* Valores para o tipo de registro no fullfilment
01 Header
02 Detalhe
03 Coleta Simples
04 Reenvio Simples
05 Coleta com Reenvio
06 Envio de Venda
07 VERIFICAR ITLOG
99 Trailler
*/

a	:=	1

If LEFT(_cRegistro,2)$"01/99/03"
Else
	// Entre esses, apenas os que forem nota fiscal
	If Substr(_cRegistro,322,006) <> "000000" .and. !Empty(Substr(_cRegistro,322,006))
		_cRegistro:=strtran(_cRegistro,"'"," ")
		_cRegistro:=strtran(_cRegistro,'"'," ")
		aAdd(_vLeitura,_cRegistro)
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fTrataLi2 บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                             บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fTrataLi2(_cRegistro)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/* Valores para nOpcAuto:
3-Inclui
4-Altera
5-Exclui
*/
Static _lPrim

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.01.05                           ณ
//ณLimpando caracteres estranhos e acentuadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cRegistro	:= RetAcent(_cRegistro,.F.)

If _lPrim == nil
	_lPrim:=.t.
Else
	_lPrim:=.f.
Endif

If _lPrim
	_cLinArq:="001"
Else
	_cLinArq:=soma1(_cLinArq)
Endif

// Tratamento para o cliente

_Cgc:=Substr(_cRegistro,053,14)

If LEFT(_Cgc,3) == "000"
	_Cgc:=padr(substr(_Cgc,4),11)
Endif  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.01.05                              ณ
//ณ                                             ณ
//ณValidar o preenchimento dos seguintes campos:ณ
//ณ1- C๓digo de municํpio                       ณ
//ณ2- Endere็o                                  ณ
//ณ3- Cep                                       ณ
//ณ4- Bairro                                    ณ
//ณ5- Cidade                                    ณ
//ณ6- UF                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lProcessa	:= .T.

_cCodMun	:= Substr(_cRegistro,775,005)//VG - cod. ibge
_cEnd		:= Substr(_cRegistro,067,100)
_cBairro	:= Substr(_cRegistro,167,020)
_cCep		:= Substr(_cRegistro,219,008)
_cMun		:= Substr(_cRegistro,187,020)
_cUF		:= Substr(_cRegistro,207,002)

If Len(alltrim(_Cgc)) < 11

	If lProcessa
		_nSa1Rej++		
	Endif
	_fGravaLog("R","SA1",_cLinArq,"CNPJ ou CGC Invalido ("+_Cgc+")")

ElseIf Empty(Alltrim(_cEnd)) .or. Empty(Alltrim(_cBairro)) .or. Empty(Alltrim(_cCep)) .or. Empty(Alltrim(_cMun)) .or. Empty(Alltrim(_cUF)) .or. Empty(Alltrim(_cCodMun))//VG - 2011.01.05

	If lProcessa
		_nSa1Rej++		
	Endif
	_fGravaLog("R","SA1",_cLinArq,"Informa็๕es de endere็o incompletas: (Endereco: "+_cEnd+", Bairro: "+_cBairro+", CEP: "+_cCep+", Mun: "+_cMun+", UF: "+_cUF+", Cod.Mun.: "+_cCodMun+")")

Else          
    
	dbSelectArea("SX5")
	dbSetOrder(1)
	If !dbSeek(xFilial("SX5")+"12"+_cUF,.F.)//VG - 2011.01.05 - validar o c๓digo da UF
	
		If lProcessa
			_nSa1Rej++		
		Endif
		lProcessa	:= .F.
		_fGravaLog("R","SA1",_cLinArq,"Estado informado invแlido (UF: "+_cUF+")")
		
	Endif
       
	dbSelectArea("CC2")
	dbSetOrder(1)	
	If !dbSeek(xFilial("CC2")+_cUF+_cCodMun,.F.)//VG - 2011.01.05 - validar o c๓digo do municํpio
	
		If lProcessa
			_nSa1Rej++		
		Endif
		lProcessa	:= .F.
		_fGravaLog("R","SA1",_cLinArq,"C๓digo do municํpio invแlido para esse estado (UF: "+_cUF+", Cod. Mun.: "+_cCodMun+")")

	Endif	

	If !_fCgc(_Cgc)     
	
		If lProcessa
			_nSa1Rej++		
		Endif
		lProcessa	:= .F.	
		_fGravaLog("R","SA1",_cLinArq,_cMensCgc:="CNPJ ou CGC Invalido ("+_Cgc+")")
		If _lExibErro
			MsgBox("Atencao: "+_cMensCgc)
		Endif
		
	Endif

	If lProcessa	
		SA1->(dbsetorder(3)) // a1_filial+a1_cgc
		_lInclui:=_lAltera:=.F.
		_vDados:={}
		If SA1->(dbseek(xfilial()+_Cgc,.F.))
	
			_lAltera := .T.
			nOpcAuto := 4
			AADD(_vDados,{"A1_COD" ,SA1->A1_COD,})
			AADD(_vDados,{"A1_LOJA",SA1->A1_LOJA,})
		
		Else
	
			_lInclui := .T.
			aAdd(_vDados,{"A1_NREDUZ",Substr(_cRegistro,023,30),})
		
			nOpcAuto := 3
			aAdd(_vDados,{"A1_COD" ,GetSx8Num("SA1","A1_COD"),})
		
			ConfirmSX8()
			aAdd(_vDados,{"A1_LOJA","01",})
		
		Endif
	
		// Dados que vem do arquivo
		aAdd(_vDados,{"A1_NOME"   ,alltrim(Substr(_cRegistro,023,030)),})
		aAdd(_vDados,{"A1_END"    ,Substr(_cRegistro,067,100),})
		aAdd(_vDados,{"A1_BAIRRO" ,Substr(_cRegistro,167,020),})
		aAdd(_vDados,{"A1_MUN"    ,Substr(_cRegistro,187,020),})
		aAdd(_vDados,{"A1_EST"    ,Substr(_cRegistro,207,002),})
		//aadd(_vDados,{"A1_PAIS"   ,Substr(_cRegistro,209,010),})
		aAdd(_vDados,{"A1_CEP"    ,Substr(_cRegistro,219,008),})
		aAdd(_vDados,{"A1_DDD"    ,alltrim(Substr(_cRegistro,227,031)),})
		aAdd(_vDados,{"A1_CGC"    ,_Cgc,})
		aAdd(_vDados,{"A1_TEL"    ,Substr(_cRegistro,232,009),})
		
		// Valores default para os demais campos
		
		aAdd(_vDados,{"A1_PESSOA"    ,if(len(alltrim(_Cgc))>12,"J","F"),})
		aAdd(_vDados,{"A1_TPCLI"     ,"U",})
		aAdd(_vDados,{"A1_TIPO"      ,"F",})	
		aadd(_vDados,{"A1_PAIS"      ,"105"  ,})	
		aAdd(_vDados,{"A1_CODPAIS"   ,"01058",}) // OS 2701/13 - 10/09/13 - Douglas David
		aAdd(_vDados,{"A1_CONTRIB"   ,"2",}) // OS 3731/15 - 15/12/15 - Eduardo Dias
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVG - 2011.01.05                        ณ
		//ณInclusใo da leitura do campo A1_COD_MUNณ
		//ณno final do layout.                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		aAdd(_vDados,{"A1_EST"    	 ,_cUF,})
		aAdd(_vDados,{"A1_COD_MUN"   ,_cCodMun,})
	
		lMsErroAuto:=.F.
		lMSHelpAuto:=_lExibErro // para mostrar os erros na tela
	
		MSExecAuto({|x,y|Mata030(x,y)},_vDados,nOpcAuto)
	                                     
		ConfirmSX8()
	
		If lMsErroAuto
		
			_cErro	:= CriaTrab(,.f.)
			_cErro	:= "SC"+strzero(val(substr(_cErro,3,5))-1,5)+"0.log"
			//_cMsLog:=strtran(memoread(_cErro),chr(10)," ")
			//_cMsLog:=strtran(_cMsLog,chr(13)," ")
			//_cMsLog:=alltrim(strtran(_cMsLog,"  "," "))
			_cMsLog	:= Alltrim(strtran(memoread(_cErro),"  "," "))
			//_cMsLog:=strtran(_cMsLog,"--","-")
			_cMsLog	:= StrTran(_cMsLog,CHR(13)+CHR(10),CHR(10))
			_cMsLog	:= Padr(left(_cMsLog,_nLargLog),_nLargLog)    
			
			_fGravaLog("R","SA1",_cLinArq,If(_lInclui,"Inclusao ","Alteracao ")+_cMsLog)
			
			_nSa1Rej++
			
			If lMsHelpAuto
				MostraErro()
			Endif
		
			If !SA1->(dbseek(xFilial()+_Cgc,.f.))
			
				// Caso o registro nao seja aceito, inclui apos listar a inconsistencia no log
				_vSa1:=aClone(_vDados)
			
				SA1->(RecLock(alias(),.t.))
			
				For _nVez := 1 to Len(_vSa1)
			
					_xValor := _vSa1[_nVez,2]
				
					If ValType(_xValor) == "N"
						_xValor := Str(_xValor)
					
					ElseIf ValType(_xValor) == "C"
						_xValor := "'"+_xValor+"'"
					
					ElseIf ValType(_xValor) == "D"
						_xValor := DtoC(_xValor)
						_xValor := "CtoD('"+_xValor+"')"
					
					ElseIf ValType(_xValor) == "L"
						_xValor := If(_xValor,".T.",".F.")
					
					ElseIf ValType(_xValor) == "U"
						_xValor := ""
					
					Endif
				
					_cComando := "SA1->"+_vSa1[_nVez][1]+":="+_xValor
					_x:=&_cComando 
				
				Next
			
				SA1->(MsUnlock())
			
			Endif
		
		Else
		
			_fGravaLog(if(_lInclui,"I","A"),"SA1",_cLinArq,SA1->(A1_COD+"-"+A1_LOJA+" "+A1_NOME))
		
			If _lInclui
				_nSa1Inc++
			Else
				_nSa1Alt++
			Endif
		Endif
	Endif
Endif

//VG - 2011.01.05 - Recuperando a variแvel de controle do processamento
lProcessa	:= .T.

// Tratamento para o produto

_Cod:=SubStr(_cRegistro,281,08)+"F"

SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD

_lInclui:=_lAltera:=.F.

_vDados:={}           

If SB1->(dbSeek(xFilial()+_Cod,.f.))
	// O produto existe. Somente inclusoes serao executadas
	_lAltera	:=	.F.
	nOpcAuto	:=	4
Else
	_lInclui	:=	.T.
	nOpcAuto	:=	3
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.01.05                           ณ
//ณValida็ใo da exist๊ncia do campo B1_POSIPIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(Alltrim(SubStr(_cRegistro,779,010))) .and. _lInclui
    
	If lProcessa
		_nSb1Rej++                     		
	Endif

	lProcessa	:= .F.			                                                 

	_cMsLog	:= "O campo B1_POSIPI do produto nใo foi informado!"
	_fGravaLog("R","SB1",_cLinArq,If(_lInclui,"Inclusao ","Alteracao ")+_cMsLog)
		
Endif

If lProcessa
	// Dados que vem do arquivo
	aAdd(_vDados,{"B1_COD",_Cod,})
	aAdd(_vDados,{"B1_DESC",SubStr(_cRegistro,241,040),})

	// Valores default

	aAdd(_vDados,{"B1_TIPO"   	,"PA",})
	aAdd(_vDados,{"B1_UM"     	,"UN",})
	aAdd(_vDados,{"B1_LOCPAD" 	,"01",})
	aAdd(_vDados,{"B1_CTAPCO" 	,"3050101",})
	aAdd(_vDados,{"B1_X_APROV" 	,"400100",})
	aAdd(_vDados,{"B1_ORIGEM" 	,"0",})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVG - 2011.01.05                                ณ
	//ณCarregar o campo B1_POSIPI do final do arquivo.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(_vDados,{"B1_POSIPI",SubStr(_cRegistro,779,010),})

	If _lInclui

		lMsErroAuto := .F.
		lMSHelpAuto := _lExibErro // para mostrar os erros na tela
	
		MSExecAuto({|x,y|Mata010(x,y)},_vDados,nOpcAuto)
  
		If lMsErroAuto              
	
			_cErro	:=	CriaTrab(,.F.)
			_cErro	:=	"SC"+StrZero(Val(SubStr(_cErro,3,5))-1,5)+"0.log"
		
			_cMsLog	:=	Alltrim(StrTran(MemoRead(_cErro),"  "," "))
		
			_cMsLog	:=	StrTran(_cMsLog,CHR(13)+CHR(10),CHR(10))
			_cMsLog	:=	Padr(left(_cMsLog,_nLargLog),_nLargLog)
		
			_fGravaLog("R","SB1",_cLinArq,If(_lInclui,"Inclusao ","Alteracao ")+_cMsLog)
			_nSb1Rej++                     
		
			If lMsHelpAuto
				MostraErro()
			Endif

		Else
	 
			_fGravaLog(if(_lInclui,"I","A"),"SB1",_cLinArq,SB1->(B1_COD+"-"+B1_DESC))
			
			If _lInclui
				_nSb1Inc++
			Else
				_nSb1Alt++
			Endif
		
			// Verifica se ha correspondente em SB2
			SB2->(dbSetOrder(1))
			If SB2->(!dbSeek(xFilial()+SB1->(B1_COD+_cLocal),.F.) .and. RecLock(Alias(),.F.))

				SB2->B2_FILIAL	:=	xFilial("SB2")
				SB2->B2_COD   	:=	SB1->B1_COD
				SB2->B2_LOCAL	:=	_cLocal
				SB2->(MsUnlock())
			
			Endif
		
		Endif
	
	Endif       
	
Endif

_nValIcms	:=	Val(SubStr(_cRegistro,377,014))

// Caso o Icms seja tributado, _cTes1, senao, o default sera
// 2 (isentos) ou 3 (outros) a criterio do usuario
_cTes	:=	_cTes1       

If _nValIcms == 0
	// Nao ha icms
	If _nTesSIcms == 1
		_cTes := _cTes2 // Isento
	Else
		_cTes := _cTes3 // Outros
	Endif               
	
Endif

If SB1->B1_TS <> _cTes

	SB1->(RecLock(alias(),.f.))
	SB1->B1_TS:=_cTes
	SB1->(MsUnlock())
	SB1->(_fGravaLog("A","SB1",_cLinArq,"O produto "+alltrim(B1_COD)+"-"+alltrim(B1_DESC)+" teve seu tipo de saida padrao alterado para "+B1_TS))
	
endif

// Tratamento para os pedidos de venda
_NumFF		:=	SubStr(_cRegistro,322,006)
_SerFF		:=	SubStr(_cRegistro,328,003)		// Acrescentado por Flavio Novaes em 06/06/07.

_Emissao	:=	CTOD(SubStr(_cRegistro,391,010))
_Tipo:="N"

//_Cgc:=Substr(_cRegistro,053,14)
SA1->(dbSetOrder(3)) // a1_filial+a1_cgc

If _NumFF == "000000"

	_fGravaLog( "R", "SC5", _cLinArq, _cErro := "Numero invalido "+_NumFF)
	
	If _lExibErro     	
		MsgBox(_cErro)		
	Endif
	
	_nSc5Rej++
	
Elseif SA1->(!dbSeek(xFilial()+_Cgc,.f.))

	_fGravaLog("R","SC5",_cLinArq,_cErro:="Inclusao nao permitida - Cliente inexistente Cnpj: "+_Cgc)

	If _lExibErro
		MsgBox(_cErro)
	Endif

	_nSc5Rej++
	
Else

	_Cliente := SA1->A1_COD
	_LojaCli := SA1->A1_LOJA
	_TipoCli := "F"
	_CondPag := "001"
	
	SC5->(dbSetOrder(6)) // C5_FILIAL+C5_CSNFF+C5_CSSFF
	_lJatem := SC5->(dbSeek(xFilial()+_NumFF+_SerFF,.F.))	// Acrescentado a Serie por Flavio Novaes em 06/06/07.
	SC5->(dbSetOrder(1))
	
	If _lJatem
	
		_fGravaLog("R","SC5",_cLinArq,_cErro:="Inclusao nao permitida - O pedido ja existe - Numero: "+sc5->c5_num+" Nf Fullfilment: "+_NumFF)		
		_nSc5Rej++                                                                                                                             
		
		If _lExibErro
			MsgBox(_cErro)
		Endif
		
	Else
		
		_nPosPed  := 1 // Posicao do numero do pedido no vetor do cabecalho
		_nPosNFFF := 15 // Posicao do numero da nf p/ fullfilment no vetor de cabe็alho
		
		If Len(_vPedidos) == 0 .or. _vPedidos[Len(_vPedidos)][1][_nPosNfFF][2] <> _NumFF

			If Len(_vSc5)>0
				// Chamada da rotina de inclusao automatica
				_fCallMata410('2')
				_vSc5	:={}
				_vSc6	:={}
				_vItens2:={}
			Endif
			
			_cNewSc5:=GetSXENum("SC5","C5_NUM")
			ConfirmSX8()
			
			Do while SC5->(dbSeek(xFilial()+_cNewSc5,.F.))
				_cNewSc5:=soma1(_cNewSc5)
			EndDo
			
			_vSc5:={{"C5_NUM"    	,_cNewSc5	,},;
					{"C5_CLIENTE"	,_Cliente	,},;
					{"C5_LOJACLI"	,_LojaCli	,},;
					{"C5_LOJAENT"	,_LojaCli	,},;
					{"C5_TIPO"   	,_Tipo		,},;
					{"C5_TIPOCLI"	,_TipoCli	,},;
					{"C5_EMISSAO"	,_Emissao	,},;
					{"C5_NATUREZ"	,_cNatureza ,},;
					{"C5_CONDPAG"	,_CondPag	,},;
					{"C5_TIPLIB"	,"1"		,},;
					{"C5_TPCARGA"	,"2"		,},;
					{"C5_MOEDA"		,1			,},;
					{"C5_FILIAL",xfilial("SC5")	,},;
					{"C5_CLIENT"	,_Cliente	,},;
					{"C5_CSNFF"		,_NumFF		,},;
					{"C5_CSSFF"		,_SerFF		,},;	// Acrescentado por Flavio Novaes em 06/06/07.
					{"C5_AREA"		,_cArea		,},;	// Acrescentado por Daniel G.Jr. TI1239 em 19/06/07
					{"C5_LIBEROK"	,"S"		,},;	// Acrescentado por Daniel G.Jr. TI1239 em 21/06/07
					{"C5_TPFRETE"	,"T"		,},;	// Acrescentado por Daniel Leme em 07/Jun/2013
					{"C5_MENNOTA"	,SuperGetMv("CS_MSGFLLF",,"2 - Terceiros - Cobrar do Operador Logistico. Notas fiscais de premios (saida)")		,}}		// Acrescentado por Daniel Leme em 07/Jun/2013
			
			_cAlias	:=	"SC5"
			SX3->(dbSetOrder(1))
			
			SX3->(dbSeek(_cAlias))
			Do While SX3->(!EOF() .and. X3_ARQUIVO == _cAlias)
				
				//-- Retirado por Daniel Leme em 07/Jun/2013:  !("C5_TPFRETE"$SX3->X3_CAMPO) .and.;
				//-- Retirado por Daniel Leme em 07/Jun/2013:  !("C5_MENNOTA"$SX3->X3_CAMPO) .and.;

				If !("C5_PERINSS"$SX3->X3_CAMPO) .and.;
					!("C5_INCISS"$SX3->X3_CAMPO) .and.;
					!("C5_KITREP"$SX3->X3_CAMPO) .and.;
					!("C5_KM"$SX3->X3_CAMPO) .and.;
					aScan(_vSc5,{|_vAux|Alltrim(_vAux[1]) == Alltrim(SX3->X3_CAMPO)})==0
					aAdd(_vSc5,{ SX3->X3_CAMPO,SC5->(CriaVar( SX3->X3_CAMPO,.F.)),nil})
				Endif
				SX3->(dbSkip(1))
				
			Enddo
			
			aAdd(_vPedidos,{aClone(_vSc5),nil})
			
		Endif 
		
		_cTes := Posicione("SB1",1,xFilial("SB1")+_Cod,"B1_TS")
		
		If Empty(_cTes)
			_cTes:=_cTes1
		Endif
		
		_vSc6a := {}
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial()+_Cod,.F.))		
		aAdd(_vSc6a,{"C6_NUM",_cNewSc5,}) 
		 
		_cItem := StrZero(Len(_vSc6)+1,2)			// incluํdo por Daniel G.Jr.TI1239 em 21/06/07

		aAdd(_vSc6a,{"C6_ITEM"   ,_cItem,})		// alterado por Daniel G.Jr.TI1239 em 21/06/07
		aAdd(_vSc6a,{"C6_PRODUTO",_Cod,})
		aAdd(_vSc6a,{"C6_UM"     ,SB1->B1_UM,})
		_nQuant		:=val(substr(_cRegistro,315,003))
		
		aAdd(_vSc6a,{"C6_QTDVEN" ,_nQuant,})
		_nPrcVen	:=val(substr(_cRegistro,301,014))/100
		_nAliqIcms	:=val(substr(_cRegistro,372,005))/100
		
		aAdd(_vSc6a,{"C6_PRCVEN" 	,_nPrcVen,})
		aAdd(_vSc6a,{"C6_VALOR"  	,val(substr(_cRegistro,338,014))/100,})
		aAdd(_vSc6a,{"C6_ENTREG"    ,_Emissao,})
		aAdd(_vSc6a,{"C6_TES"       ,_cTes,})
		
		_nOrdSa1:=SA1->(IndexOrd())
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial()+_Cliente+_LojaCli,.f.))
		SA1->(dbSetorder(_nOrdSa1))
		
		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xfilial()+_cTes,.F.))
		
		_cCfop:=If(_TipoCli<>"X",iif(SA1->A1_EST==getmv("MV_ESTADO"),SF4->F4_CF,"6"+;
		Subs(SF4->F4_CF,2,LEN(SF4->F4_CF)-1)),"7"+Subs(SF4->F4_CF,2,LEN(SF4->F4_CF)-1))
		aadd(_vSc6a,{"C6_CF"     	,_cCfop		,})
		aadd(_vSc6a,{"C6_QTDLIB" 	,_nQuant	,})
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVG - 2011.01.05                        ณ
		//ณGrava็ใo da quantidade de empenho para ณ
		//ณmanter a integridade do sistema.       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aadd(_vSc6a,{"C6_QTDEMP" 	,_nQuant	,})
		aadd(_vSc6a,{"C6_LOCAL"  	,_cLocal	,})
		aadd(_vSc6a,{"C6_DESCRI"  	,SB1->B1_DESC,})
		aadd(_vSc6a,{"C6_PRUNIT"	,_nPrcVen	,})
		aadd(_vSc6a,{"C6_CLI" 	  	,_Cliente	,})
		aadd(_vSc6a,{"C6_LOJA" 		,_LojaCli	,})
		aadd(_vSc6a,{"C6_CALINSS"	,"N"		,})
		aadd(_vSc6a,{"C6_FILIAL"	,xFilial("SC6"),})
		aadd(_vSc6a,{"C6_CCUSTO"	,_cCust		,})			// Acrescentado por Daniel G.Jr. TI1239 em 19/06/07
		aadd(_vSc6a,{"C6_ITEMD" 	,_cNego		,})			// Acrescentado por Daniel G.Jr. TI1239 em 19/06/07
		aadd(_vSc6a,{"C6_CLVLDB"	,_cOper		,})			// Acrescentado por Daniel G.Jr. TI1239 em 19/06/07
		//aadd(_vSc6a,{"C6_CALIRF","S",})
		
		_cAlias	:=	"SC6"
		SX3->(dbSetOrder(1))
		/*
		sx3->(dbseek(_cAlias))
		do while sx3->(!eof().and.x3_arquivo==_cAlias)
		if ascan(_vSc6,{|_vAux|alltrim(_vAux[1])==alltrim(sx3->x3_campo)})==0
		aadd(_vSc6,{sx3->x3_campo,sc6->(criavar(sx3->x3_campo,.f.)),nil})
		endif
		sx3->(dbskip(1))
		enddo
		*/
		
		aAdd(_vSc6,aClone(_vSc6a))
		// Guarda a aliquota do icms
		aAdd(_vItens2,_nAliqIcms)
                                                   
		//************* acrescentado por Daniel G.Jr.TI1239 em 21/06/07 *************** INICIO ***
		_vSc9a	:=	{}
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial()+_Cod,.F.))
		
		aadd(_vSc9a,{"C9_FILIAL"	,xFilial("SC9"),})
		aadd(_vSc9a,{"C9_PEDIDO" 	,_cNewSc5	,})
		aadd(_vSc9a,{"C9_ITEM"   	,_cItem		,})
		aadd(_vSc9a,{"C9_SEQUEN"	,"01"		,})
		aadd(_vSc9a,{"C9_PRODUTO"	,_Cod		,})
		aadd(_vSc9a,{"C9_QTDLIB" 	,_nQuant	,})
		aadd(_vSc9a,{"C9_PRCVEN" 	,_nPrcVen	,})
//		aadd(_vSc9a,{"C9_PRCVEN"  	,val(substr(_cRegistro,337,014))/100,})
		aadd(_vSc9a,{"C9_DATALIB"	,_Emissao	,})
		aadd(_vSc9a,{"C9_LOCAL"		,_cLocal	,})
		aadd(_vSc9a,{"C9_CLIENTE"	,_Cliente	,})
		aadd(_vSc9a,{"C9_LOJA" 	  	,_LojaCli	,})
		aadd(_vSc9a,{"C9_TPCARGA"	,"2"		,})
		aadd(_vSc9a,{"C9_CSNFF"		,_NumFF		,})
		
		aadd(_vSc9,aClone(_vSc9a))
		//************************************************************************* FIM *********

	Endif
	
Endif


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fGravaLog บAutor  ณMicrosiga           บ Data ณ  12/29/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                             บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fGravaLog(_Ocor,_Alias,_LinArq,_Mens)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
local _nVez,_nLarg:=len(SZB->ZB_MENS)

_nOrdLog++
_Mens := Alltrim(_Mens)

For _nVez:=1 to mlcount(_Mens,_nLarg)

	SZB->(RecLock(alias(),.T.))
	SZB->ZB_FILIAL := xFilial("SZB")
	SZB->ZB_NUMERO := _cNumLog
	SZB->ZB_ORDEM  := StrZero(_nOrdLog,Len(szb->zb_ordem))
	SZB->ZB_ALIASPR:= _Alias
	SZB->ZB_OCOR   := _Ocor
	SZB->ZB_LINARQ := _LinArq
	SZB->ZB_DATA   := _dDataLog
	SZB->ZB_HORA   := _cHoraLog
	SZB->ZB_MENS   := MemoLine(_Mens,_nLarg,_nVez)
	
	SZB->(MsUnlock())
	
Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fCallMata410 บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ acionamento da rotina automatica de inclusao de pedidos        บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fCallMata410(_cdeonde)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial()+_vSc5[2,2]+_vSc5[3,2],.F.))

/*/
lMsErroAuto:=.f.
lMSHelpAuto:=_lExibErro // para mostrar os erros na tela
nOpcAuto:=3
dbselectarea("SC5")  
MsExecAuto({|x,y,z|Mata410(x,y,z)},_vSc5,_vSc6,nOpcAuto)
If lMsErroAuto                
	_cErro:=criatrab(,.f.)
	_cErro:="SC"+strzero(val(substr(_cErro,3,5))-1,5)+"0.log"
	_cMsLog:=alltrim(strtran(memoread(_cErro),"  "," "))
	_cMsLog:=strtran(_cMsLog,CHR(13)+CHR(10),CHR(10))
	_cMsLog:=padr(left(_cMsLog,_nLargLog),_nLargLog)
	_fGravaLog("R","SC5",_cLinArq,if(_lInclui,"Inclusao ","Alteracao ")+_cMsLog)
	_nSc5Rej++
	if lMsHelpAuto
		mostraerro()
	endif
else  
	_fGravaLog(if(_lInclui,"I","A"),"SC5",_cLinArq,sc5->(c5_num))
	if _lInclui
		_nSc5Inc++
	else
		_nSc5Alt++
	endif
endif
/*/

_lInclui := .T.
_lAltera := .F.

If _lInclui
	_nSc5Inc++
Else
	_nSc5Alt++
Endif
                   
_cFil := GetArea()					// Acrescentado por Daniel G.Jr. TI1239 em 19/06/07
dbSelectArea("SC5")					// Acrescentado por Daniel G.Jr. TI1239 em 19/06/07
SC5->(RecLock(alias(),.T.))

For _nVez := 1 to Len(_vSc5)
	_xValor := _vSc5[_nVez,2]

	If ValType(_xValor) == "N"
		_xValor := Str(_xValor)
		
	ElseIf ValType(_xValor) == "C"
		_xValor := "'"+_xValor+"'"
		
	ElseIf ValType(_xValor) == "D"
		_xValor := DtoC(_xValor)
		_xValor := "CtoD('"+_xValor+"')"
		
	ElseIf ValType(_xValor) == "L"
		_xValor := If(_xValor,".T.",".F.")
		
	ElseIf ValType(_xValor) == "U"
		_xValor := ""            
		
	Endif
	
	_cComando := "SC5->"+_vSc5[_nVez][1]+":="+_xValor
	_x	:= &_cComando                                 
	
Next

SC5->(MsUnlock())

aAdd(_vPedImp,SC5->C5_CSNFF)

dbSelectArea("SC6")			// Acrescentado por Daniel G.Jr. TI1239 em 19/06/07

For _nVezC6 := 1 to Len(_vSc6)
	
	SC6->(RecLock(alias(),.T.))
	
	_vItens := aClone(_vSc6[_nVezC6])
	
	For _nVez:=1 to Len(_vItens)
	
		_xValor := _vItens[_nVez,2]
		
		If ValType(_xValor) == "N"
			_xValor := Str(_xValor)
			
		ElseIf ValType(_xValor) == "C"
			_xValor := "'"+_xValor+"'"
			
		ElseIf ValType(_xValor) == "D"
			_xValor := DtoC(_xValor)
			_xValor := "CtoD('"+_xValor+"')"
			
		ElseIf ValType(_xValor) == "L"
			_xValor := If(_xValor,".T.",".F.")
			
		ElseIf ValType(_xValor) == "U"
			_xValor := ""
			
		Endif
		
		_cComando := "SC6->"+_vItens[_nVez][1]+":="+_xValor
		a:=1
		_x:=&_cComando
		a:=1
		
	Next
	
	SC6->(MsUnlock())
	
	// Ajuste da aliquota de icms se for o caso
	_nAliqArq := _vItens2[_nVezC6]*100
	// Verificar se a aliquota de icms informada pelo arquivo combina
	// com a que o sistema utilizara na geracao da nf. Em caso negativo,
	// atualizar SB1
	_nAliqSis := _fIcmAliq(SC6->C6_TES)
	
	If _nAliqArq <> _nAliqSis
	
		If SB1->(dbSeek(xFilial()+SC6->C6_PRODUTO,.F.) .and. B1_PICM <> _nAliqArq .and. RecLock(alias(),.F.))
		
			_fGravaLog("A","SB1",_cLinArq,"A aliquota padrao do ICMS do produto "+SB1->(Alltrim(B1_COD)+" / "+Alltrim(B1_DESC)+" foi alterada de "+Alltrim(Str(B1_PICM)))+" para "+Alltrim(Str(_nAliqArq))+" em funcao da NF "+SC6->(C6_NUM+" item "+C6_ITEM))
			SB1->B1_PICM := _nAliqArq
			SB1->(MsUnlock())
			
		Endif
		
	Endif

Next

//************* acrescentado por Daniel G.Jr.TI1239 em 21/06/07 *************** INICIO ***
dbSelectArea("SC9")
SC9->(dbSetOrder(1))

For _nVezC9 := 1 to Len(_vSc9)
	_vItens := aClone(_vSc9[_nVezC9])
	_cChave := _vItens[1][2]+_vItens[2][2]+_vItens[3][2]+_vItens[4][2]+_vItens[5][2]
	
	If SC9->(dbSeek(_cChave))
		SC9->(RecLock(alias(),.F.))
	Else
		SC9->(RecLock(alias(),.T.))
	EndIf                        
	
	For _nVez := 1 to Len(_vItens)
		_xValor := _vItens[_nVez,2]
		
		If ValType(_xValor) == "N"
			_xValor := Str(_xValor)
			
		ElseIf ValType(_xValor) == "C"
			_xValor := "'"+_xValor+"'"
			
		ElseIf ValType(_xValor)=="D"
			_xValor := DtoC(_xValor)
			_xValor := "CtoD('"+_xValor+"')"
			
		ElseIf ValType(_xValor)=="L"
			_xValor := Iif(_xValor,".T.",".F.")
			
		ElseIf ValType(_xValor) == "U"
			_xValor := ""
			
		Endif
		
		_cComando := "SC9->"+_vItens[_nVez][1]+":="+_xValor
		a:=1
		_x:=&_cComando
		a:=1                 
		
	Next
	SC9->(MsUnlock())
	
Next
//************************************************************************* FIM *********

_fGravaLog(if(_lInclui,"I","A"),"SC5",_cLinArq,SC5->(C5_NUM))

RestArea(_cfil)			// Acrescentado por Daniel G.Jr. TI1239 em 19/06/07

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCsFatM1b  บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do log de importacao                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CsFatM1b(_cLogPar)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
local _cPerg := PADR("FatM1b",LEN(SX1->X1_GRUPO))
nLastKey  := 0
limite    := 80
wnrel:=nomeprog:="CsFatM01"
cDesc1    := "Log de importacao - Fullfilment"
cDesc2    := " "
cDesc3    := " "
cString   := "SA1"
tamanho   := "P"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     := 99
m_pag     := 1
Li        := 0

Cabec1 := ""
Cabec2 := "Ordem  Tabela Ocorrencia Lin Arq Detalhes da ocorrencia"

ValidPerg2(_cPerg)
CursorArrow()     

If _cLogPar == nil
Else
	
	SX1->(dbSetOrder(1))
	If SX1->(dbSeek(Padr(_cPerg,Len(SX1->X1_GRUPO)),.F.) .and. RecLock(alias(),.F.))
		SX1->X1_CNT01 := _cLogPar
	Endif

Endif

wnrel := SetPrint(cString,wnrel,_cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,tamanho)

Pergunte(_cPerg,.F.)

If nLastkey == 27

	Set Filter To
	Return
	
Endif

CursorWait()

RptStatus({|| RptDetail() })

CursorArrow()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRptDetail บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function RptDetail
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
local _nLarg:=47,_cQuebra:=chr(10),_vTexto:={},_cLinha,_nPosic,_nVez

_cLogPar := MV_PAR01
SetDefault(aReturn,cString)

SZB->(dbSetOrder(1))
SZB->(dbSeek(xFilial()+Soma1(_cLogPar),.T.))
SZB->(dbSkip(-1))

If SZB->ZB_NUMERO == _cLogPar
	_nLen := Val(SZB->ZB_ORDEM)
Else
	_nLen := 50
Endif

_nLin := 99
SetRegua(_nLen)

SZB->(dbSeek(xFilial()+_cLogPar,.F.))
cabec1 := _cLogPar+" Data e hora da importacao: "+DtoC(SZB->ZB_DATA)+" as "+SZB->ZB_HORA+" h"

Do while SZB->(!EOF() .and. ZB_NUMERO == _cLogPar)

	IncRegua()
	_fIncrLin()
	
	@ _nLin,0 PSAY SZB->(ZB_ORDEM+"   "+ZB_ALIASPR+"    "+Padr(U_fX3Cbox("ZB_OCOR",ZB_OCOR),10)+" "+ZB_LINARQ+"    ")
	_nCol := pcol()
	
	// Prepara a impressao do detalhe
	_cOrdem := SZB->ZB_ORDEM
	_cDetalhe := ""         
	
	Do while SZB->(!EOF() .and. ZB_NUMERO+ZB_ORDEM == _cLogPar+_cOrdem)
	
		_cDetalhe += Alltrim(SZB->ZB_MENS)
		SZB->(dbSkip(1))
		
	EndDo
	
	_cDetalhe := StrTran(_cDetalhe,chr(13),chr(10))
	_cDetalhe := StrTran(_cDetalhe,chr(10)+chr(10),chr(10))
	_vTexto := {}
	
	Do while (_nPosic := AT(chr(10),_cDetalhe)) > 0
	
		_cLinha:=left(_cDetalhe,_nPosic-1)
		
		If Len(alltrim(_cLinha))>0
		
			For _nVez := 1 to mlcount(_cLinha,_nLarg)
				aAdd(_vTexto,MemoLine(_cLinha,_nLarg,_nVez))
			Next
			
		Endif
		
		_cDetalhe := SubStr(_cDetalhe,_nPosic+1)
		
	EndDo
	
	_cLinha := Alltrim(_cDetalhe)
	
	// Adiciona a ultima linha
	If Len(Alltrim(_cLinha)) > 0
	
		For _nVez := 1 to mlcount(_cLinha,_nLarg)
		
			aAdd(_vTexto,memoline(_cLinha,_nLarg,_nVez))
			
		Next  
		
	Endif
	
	For _nVez := 1 to Len(_vTexto)
	
		@ _nLin,_nCol psay _vTexto[_nVez]
		_fIncrLin()
		
	Next
	
Enddo

Roda(0,"",tamanho)

If aReturn[5] == 1

	Set Printer To
	Commit
	OurSpool(wnrel)
	
Endif   

MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fIncrLin บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fIncrLin(_nIncr)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If _nIncr == nil
 
	_nIncr := 1

Endif

If _nLin > 58

	Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
	_nLin:=li+2
	
Else

	_nLin += _nIncr
	
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fIcmAliq บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fIcmAliq(_cTes)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
LOCAL nPerRet	:=	0                // Percentual de retorno
LOCAL cEstado	:=	GetMV("MV_ESTADO"),tNorte:=GetMV("MV_NORTE")
LOCAL cEstCli	:=	IIF(SC5->C5_TIPO$"DB",SA2->A2_EST,SA1->A1_EST)
LOCAL cInscrCli	:=	IIF(SC5->C5_TIPO$"DB",SA2->A2_INSCR,SA1->A1_INSCR)

If Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_ICM") == "S"

	nPerRet := AliqIcms(SC5->C5_TIPO,;  // Tipo de Operacao
	"S",;  // Tipo de Nota ('E'ntrada/'S'aida)
	SC5->C5_TIPOCLI) // Tipo do Cliente ou Fornecedor
	
EndIf

Return(nPerRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbreOrig  บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AbreOrig()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cDirTxt := MV_PAR01, _cEscopo ,_cTitulo
Public _cFatM01Re                      

_cDirTxt := Alltrim(_cDirTxt)

If LEFT(_cDirTxt,1) <> "\"

	_cDirTxt := "\"+_cDirTxt
	
Endif

If RIGHT(_cDirTxt,1) <> "\"

	_cDirTxt+="\"
	
Endif

If Len(_cDirTxt) == 2

	_cDirTxt := "\"
	
Endif

_cEscopo := "Arquivos do Fullfilment|*.ENV|Todos os Arquivos|*.*|"
_cTitulo := "Selecione o arquivo a ser importado"
_nMascara := 1
_cDirDefault := "Servidor"+_cDirTxt
_nOptions := 0 //GETF_ONLYSERVER+GETF_NOCHANGEDIR
_cFatM01Re := Alltrim(cGetFile(_cEscopo,_cTitulo,_nMascara,_cDirDefault,nil,_nOptions))
_nPosic := RAT("\",_cFatM01Re)

MV_PAR01 := LEFT(_cFatM01Re,_nPosic)
MV_PAR02 := SubStr(_cFatM01Re,_nPosic+1)

Return _cFatM01Re

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fCgc     บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fCgc(cCGC)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
LOCAL nCnt,i,j,cDVC,nSum,nDIG,cDIG:="",cSavAlias,nSavRec,nSavOrd

If cCgc == "00000000000000"
	Return .T.
Endif

nTamanho := Len(AllTrim(cCGC))

cDVC := SubStr(cCGC,13,2)
cCGC := SubStr(cCGC,1,12)

FOR j := 12 TO 13

	nCnt := 1
	nSum := 0
	FOR i := j TO 1 Step -1
		nCnt++
		IF nCnt>9;nCnt:=2;EndIf
		nSum += (Val(SubStr(cCGC,i,1))*nCnt)
	Next i
	nDIG := IIF((nSum%11)<2,0,11-(nSum%11))
	cCGC := cCGC+STR(nDIG,1)
	cDIG := cDIG+STR(nDIG,1)
	
Next j

lRet := IIF(cDIG == cDVC,.T.,.F.)

IF !lRet
	IF nTamanho < 14
		cDVC := SubStr(cCGC,10,2)
		cCPF := SubStr(cCGC,1,9)
		cDIG := ""
		
		FOR j := 10 TO 11
			nCnt := j
			nSum := 0
			For i:= 1 To Len(Trim(cCPF))
				nSum += (Val(SubStr(cCPF,i,1))*nCnt)
				nCnt--
			Next i
			nDIG := IIF((nSum%11)<2,0,11-(nSum%11))
			cCPF := cCPF+STR(nDIG,1)
			cDIG := cDIG+STR(nDIG,1)
		Next j
		
		lRet := IIF(cDIG==cDVC,.T.,.F.)
	EndIF
EndIF        

Return lRet
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VALIDPERG(_cPerg)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
local aRegs := {}         

//   1    2            3                   4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
//+------------------------------------------------------------------------------------------------------------------------------------+
//ฆG    ฆ O  ฆ PERGUNT                 ฆV       ฆT  ฆT ฆDฆPฆ G ฆV ฆV         ฆ D    ฆC ฆV ฆD       ฆC ฆV ฆD ฆC ฆV ฆD ฆC ฆV ฆD ฆC ฆF    ฆ
//ฆ R   ฆ R  ฆ                         ฆ A      ฆ I ฆA ฆEฆRฆ S ฆA ฆ A        ฆ  E   ฆN ฆA ฆ E      ฆN ฆA ฆE ฆN ฆA ฆE ฆN ฆA ฆE ฆN ฆ3    ฆ
//ฆ  U  ฆ D  ฆ                         ฆ  R     ฆ  PฆMAฆCฆEฆ C ฆ Lฆ  R       ฆ   F  ฆ Tฆ Rฆ  F     ฆ TฆR ฆF ฆ TฆR ฆF ฆ TฆR ฆF ฆ Tฆ     ฆ
//ฆ   P ฆ E  ฆ                         ฆ   I    ฆ  OฆNHฆ ฆSฆ   ฆ Iฆ   0      ฆ    0 ฆ 0ฆ 0ฆ   0    ฆ 0ฆ0 ฆ0 ฆ 0ฆ0 ฆ0 ฆ 0ฆ0 ฆ0 ฆ 0ฆ     ฆ
//ฆ    Oฆ M  ฆ                         ฆ    AVL ฆ   ฆ Oฆ ฆEฆ   ฆ Dฆ    1     ฆ    1 ฆ 1ฆ 2ฆ    2   ฆ 2ฆ3 ฆ3 ฆ 3ฆ4 ฆ4 ฆ 4ฆ5 ฆ5 ฆ 5ฆ     ฆ

AADD(aRegs,{_cPerg,"01","Diretorio                    :","mv_ch1","C",60,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Nome do arquivo              :","mv_ch2","C",20,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","","Z@A"})
AADD(aRegs,{_cPerg,"03","Exibir erros durante a exec..:","mv_ch3","N",01,0,0,"C","","mv_par03","Sim"    ,"","","Nao"      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"04","Natureza do pedido           :","mv_ch4","C",10,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","","SED"})
AADD(aRegs,{_cPerg,"05","TES Icms tributado           :","mv_ch5","C",03,0,0,"G","","mv_par05",""    ,"","",""      ,"","","","","","","","","","","SF4"})
AADD(aRegs,{_cPerg,"06","TES Icms Isento/nao tributado:","mv_ch6","C",03,0,0,"G","","mv_par06",""    ,"","",""      ,"","","","","","","","","","","SF4"})
AADD(aRegs,{_cPerg,"07","TES Icms outros              :","mv_ch7","C",03,0,0,"G","","mv_par07",""    ,"","",""      ,"","","","","","","","","","","SF4"})
AADD(aRegs,{_cPerg,"08","TES para quando nao ha ICMS  :","mv_ch8","N",03,0,0,"C","","mv_par08","Isento"    ,"","","Outros"      ,"","","","","","","","","","","SF4"})
AADD(aRegs,{_cPerg,"09","Almoxarifado de saida        :","mv_ch9","C",02,0,0,"G","","mv_par09",""    ,"","",""      ,"","","","","","","","","","",""})

U__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG2 บAutor  ณMicrosiga           บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                             บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VALIDPERG2(_cPerg)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
local aRegs := {}

//   1    2            3                   4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
//+------------------------------------------------------------------------------------------------------------------------------------+
//ฆG    ฆ O  ฆ PERGUNT                 ฆV       ฆT  ฆT ฆDฆPฆ G ฆV ฆV         ฆ D    ฆC ฆV ฆD       ฆC ฆV ฆD ฆC ฆV ฆD ฆC ฆV ฆD ฆC ฆF    ฆ
//ฆ R   ฆ R  ฆ                         ฆ A      ฆ I ฆA ฆEฆRฆ S ฆA ฆ A        ฆ  E   ฆN ฆA ฆ E      ฆN ฆA ฆE ฆN ฆA ฆE ฆN ฆA ฆE ฆN ฆ3    ฆ
//ฆ  U  ฆ D  ฆ                         ฆ  R     ฆ  PฆMAฆCฆEฆ C ฆ Lฆ  R       ฆ   F  ฆ Tฆ Rฆ  F     ฆ TฆR ฆF ฆ TฆR ฆF ฆ TฆR ฆF ฆ Tฆ     ฆ
//ฆ   P ฆ E  ฆ                         ฆ   I    ฆ  OฆNHฆ ฆSฆ   ฆ Iฆ   0      ฆ    0 ฆ 0ฆ 0ฆ   0    ฆ 0ฆ0 ฆ0 ฆ 0ฆ0 ฆ0 ฆ 0ฆ0 ฆ0 ฆ 0ฆ     ฆ
//ฆ    Oฆ M  ฆ                         ฆ    AVL ฆ   ฆ Oฆ ฆEฆ   ฆ Dฆ    1     ฆ    1 ฆ 1ฆ 2ฆ    2   ฆ 2ฆ3 ฆ3 ฆ 3ฆ4 ฆ4 ฆ 4ฆ5 ฆ5 ฆ 5ฆ     ฆ

AADD(aRegs,{_cPerg,"01","Numero do Log         :","mv_ch1","C",06,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})

U__fAtuSx1(Padr(_cPerg,len(sx1->x1_grupo)),aRegs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MenuDEF  บ Autor ณEduardo de Souza    บ Data ณ12/Jan/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Implementa menu funcional                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Menus                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Array contendo as Rotinas a executar do programa      ณ
//ณ ----------- Elementos contidos por dimensao ------------     ณ
//ณ 1. Nome a aparecer no cabecalho                              ณ
//ณ 2. Nome da Rotina associada                                  ณ
//ณ 3. Usado pela rotina                                         ณ
//ณ 4. Tipo de Transao a ser efetuada                          ณ
//ณ    1 - Pesquisa e Posiciona em um Banco de Dados             ณ
//ณ    2 - Simplesmente Mostra os Campos                         ณ
//ณ    3 - Inclui registros no Bancos de Dados                   ณ
//ณ    4 - Altera o registro corrente                            ณ
//ณ    5 - Remove o registro corrente do Banco de Dados          ณ
//ณ    3 - Duplica o registro corrente do Banco de Dados         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function MenuDef()

Local aRotina :=	{{"","",0,3},;		//"Pesquisar"
				 {"","",0,3},; 		//"Visualizar"
				 {"","",0,3},; 	//"Incluir"
				 {"","",0,3},; 	//"Alterar"
				 {"","",0,3}}	//"Excluir"

Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออหออออัออออออออออปฑฑ
ฑฑบPrograma   ณ RetAcent บ Autor ณ Jaime Wikanski            บDataณ04.11.2002บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออสออออฯออออออออออนฑฑ
ฑฑบDescricao  ณ Troca caracteres especificos                                 บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetAcent(_cTexto,lConverte)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local i				:= 0
Local _cTextoDev 	:= ""
Local _carac 		:= ""

for i:=1 to len(_cTexto )
	_carac := substr( _ctexto,i,1 )
	do Case
		Case Asc(_carac) = 224 .Or. Asc(_carac) = 225 .Or. Asc(_carac) = 226 .Or. Asc(_carac) = 227 .Or. Asc(_carac) = 228 .Or. Asc(_carac) = 229
			If lConverte
				_carac	:= "A"
			Else
				_carac	:= "a"
			EndIf
		Case Asc(_carac) = 232 .Or. Asc(_carac) = 233 .Or. Asc(_carac) = 234 .Or. Asc(_carac) = 235
			If lConverte
				_carac	:= "E"
			Else
				_carac	:= "e"
			EndIf
		Case Asc(_carac) = 236 .Or. Asc(_carac) = 237 .Or. Asc(_carac) = 238 .Or. Asc(_carac) = 239
			If lConverte
				_carac	:= "I"
			Else
				_carac	:= "i"
			Endif
		Case Asc(_carac) = 240 .Or. Asc(_carac) = 242 .Or. Asc(_carac) = 243 .Or. Asc(_carac) = 244 .Or. Asc(_carac) = 245 .Or. Asc(_carac) = 246
			If lConverte
				_carac	:= "O"
			Else
				_carac	:= "o"
			EndIf
		Case Asc(_carac) = 249 .Or. Asc(_carac) = 250 .Or. Asc(_carac) = 251 .Or. Asc(_carac) = 252
			If lConverte
				_carac	:= "U"
			Else
				_carac	:= "u"
			EndIf
		Case Asc(_carac) = 231
			If lConverte
				_carac	:= "C"
			Else
				_carac	:= "c"
			EndIf
		Case Asc(_carac) = 241
			If lConverte
				_carac	:= "N"
			Else
				_carac	:= "n"
			EndIf
		Case Asc(_carac) = 253 .Or. Asc(_carac) = 255
			If lConverte
				_carac	:= "Y"
			Else
				_carac	:= "y"
			EndIf
		Case Asc(_carac) = 192 .Or. Asc(_carac) = 193 .Or. Asc(_carac) = 194 .Or. Asc(_carac) = 195 .Or. Asc(_carac) = 196 .Or. Asc(_carac) = 197
			_carac	:= "A"
		Case Asc(_carac) = 200 .Or. Asc(_carac) = 201 .Or. Asc(_carac) = 202 .Or. Asc(_carac) = 203
			_carac	:="E"
		Case Asc(_carac) = 204 .Or. Asc(_carac) = 205 .Or. Asc(_carac) = 206 .Or. Asc(_carac) = 207
			_carac	:= "I"
		Case Asc(_carac) = 210 .Or. Asc(_carac) = 211 .Or. Asc(_carac) = 212 .Or. Asc(_carac) = 213 .Or. Asc(_carac) = 214
			_carac	:= "O"			
		Case Asc(_carac) = 217 .Or. Asc(_carac) = 218 .Or. Asc(_carac) = 219 .Or. Asc(_carac) = 220
			_carac	:= "U"
		Case Asc(_carac) = 199
			_carac	:= "C"
		Case Asc(_carac) = 209
			_carac	:= "N"
		Case Asc(_carac) = 221
			_carac	:= "Y"
	EndCase
	
	_cTextoDev += _carac
	
Next

_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(13)+chr(10),""))
_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(13),""))
_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(10),""))

Return( _cTextoDev )

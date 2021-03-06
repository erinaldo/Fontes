#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"
#DEFINE _EOL CHR(13) + CHR(10)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �cfinm04   � Autor � Andy Pudja         � Data �  15/10/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera SE2 e SE5 quando os registros da conta de consumo     ���
���          � foram gerados DM                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cfinm04()

Private cPerg       := "FINM04    "
Private _dCREDITO   := dDataBase
Private _cHist   	:= " Contas Consumo DM: "

Private _cNATUREZA 	:= "" //Regra

Private _cBANCO    	:= Space(03) // "237"
Private _cAGENCIA	:= Space(05) // "33910"
Private _cCONTA    	:= Space(10) // "86437"

Private _lFezSE5

//��������������������������������������������������������Ŀ
//� mv_par01 - DM de                                       �
//� mv_par02 - DM ate                                      �
//����������������������������������������������������������

_aPerg := {}
AADD(_aPerg,{cPerg,"01","DM de              ?","","","mv_ch1","C",6,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","DM ate             ?","","","mv_ch2","C",6,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AjustaSX1(_aPerg) 
                                                                            
If !Pergunte(cPerg, .T.)
  Return
EndIf


//���������������������������������������������������������������������Ŀ
//� Selecionar as FL da Tabela Z5                                       �
//�����������������������������������������������������������������������

_xFilSZ5:=xFilial("SZ5")
_xFilSZ7:=xFilial("SZ7")

_cOrdem := " Z5_FILIAL, Z7_GRUPO, Z5_PRESTA, Z5_UNIDADE, Z5_LANC, Z5_DOC"
_cQuery := " SELECT Z5_BANCO, Z5_AGENCIA, Z5_CCONTA, Z5_LANC, Z5_DOC, Z7_GRUPO, Z5_PRESTA, Z5_TEL, Z5_MES, Z5_VALOR, Z5_BAIXA, Z5_CONTA ,Z5_UNIDADE, Z5_CR, Z5_FL,Z5_FECHA, SZ5.R_E_C_N_O_ REGSZ5"
_cQuery += " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_FL      >= '" +mv_par01+"'"
_cQuery += " AND    Z5_FL      <= '" +mv_par02+"'"
_cQuery += " AND    Z5_FLUXO   <> 'S'" 
U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ5","SZ7" },,,.T. )

_cE2Pref := "DBA" // Definir             
_cE2Tipo := "DBA" // Definir
_cLojImp := "01"  // Definir
dbSelectArea("QUERY")
dbGoTop() 

_lFezSE5 := .F.

While !Eof()
	
	//����������������������������������������������������������������������Ŀ
	//� Begin Transaction - Faz o controle da transacao. Se algum erro ocor- �
	//� rer no meio do processamento, tudo o que foi processado ate o momen- �
	//� to eh estornado para a situacao anterior ao inicio do processamento. �
	//������������������������������������������������������������������������
	
	Begin Transaction                      
	
	_cBANCO    	:= QUERY->Z5_BANCO
    _cAGENCIA	:= QUERY->Z5_AGENCIA
    _cCONTA    	:= QUERY->Z5_CCONTA
                 
	_cHist      := "Contas Consumo DM: "+QUERY->Z5_FL
	_dCREDITO   := IIF(EMPTY(QUERY->Z5_FECHA),QUERY->Z5_LANC, QUERY->Z5_FECHA)  // Alterado conforme Chamado 11326
	
    _lFezSE5    := .T.    

	//���������������������������������������������������������������������Ŀ
	//� Inclui os registros de movimento bancario.                          �
	//�����������������������������������������������������������������������
    If cEmpAnt=="03"                                                     
	    Do case
	       case AllTrim(QUERY->Z7_GRUPO) $  "A;C" ; _cNATUREZA:="2.09.01"
	       case AllTrim(QUERY->Z7_GRUPO) == "B"   ; _cNATUREZA:="2.10.05"
	       case AllTrim(QUERY->Z7_GRUPO) == "D"   ; _cNATUREZA:="2.08.04"
	       case AllTrim(QUERY->Z7_GRUPO) == "E"   ; _cNATUREZA:="2.08.03"
	       case AllTrim(QUERY->Z7_GRUPO) == "F"   ; _cNATUREZA:="2.08.01"
	       case AllTrim(QUERY->Z7_GRUPO) == "G"   ; _cNATUREZA:="2.10.04"
	       otherwise 
	            _cNATUREZA:=""
	    EndCase
    Else
	    Do case
	       case AllTrim(QUERY->Z7_GRUPO) $  "A;C" ; _cNATUREZA:="02050201" // "2.09.01"
	       case AllTrim(QUERY->Z7_GRUPO) == "B"   ; _cNATUREZA:="02050302" // "2.10.05"
	       case AllTrim(QUERY->Z7_GRUPO) == "D"   ; _cNATUREZA:="02050104" // "2.08.04"
	       case AllTrim(QUERY->Z7_GRUPO) == "E"   ; _cNATUREZA:="02050103" // "2.08.03"
	       case AllTrim(QUERY->Z7_GRUPO) == "F"   ; _cNATUREZA:="02050101" // "2.08.01"
	       case AllTrim(QUERY->Z7_GRUPO) == "G"   ; _cNATUREZA:="02050301" // "2.10.04"
	       otherwise 
	            _cNATUREZA:=""
	    EndCase
    EndIf
    
	SZ5SE5("CC",QUERY->Z5_VALOR,0,0,0, _cHist, _cNATUREZA,QUERY->Z5_FL,QUERY->Z5_PRESTA)
	
	//���������������������������������������������������������������������Ŀ
	//� Fim do controle da transacao. Efetiva o que foi processado.         �
	//�����������������������������������������������������������������������

	dbSelectArea("SZ5")
	dbgoto(QUERY->REGSZ5)
	RecLock("SZ5",.F.)
	   SZ5->Z5_FLUXO:="S"
	msUnLock()    

	End Transaction
	
	dbSelectArea("QUERY")
    dbSkip()

EndDo                                             
                      
If _lFezSE5
   _cMsg := "Gerado o Movimento Bancario atraves da DM, talvez n�o todos" 
   MsgInfo(_cMsg, "Aten��o ")
Else                         
   _cMsg := "N�o foi gerado o Movimento Bancario de nenhum DM" 
   MsgInfo(_cMsg, "Aten��o ")
EndIf   
                                                              
dbSelectArea("QUERY")
dbCloseArea()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SZ5SE2    �Autor  � Andy Pudja         � Data �  28/08/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava titulos em SE2                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SZ5SE2(_cTipo,_nE2Ori,_nE2Liq,_nE2Tar,_nE2Jur,_nE2Mul,_cFL)

_cDescNat := POSICIONE("SED",1,xFilial("SED")+_cNATUREZA,"ED_DESCRIC")

RecLock("SE2", .T.)
SE2->E2_FILIAL  := xFilial("SE2")
SE2->E2_NUM     := _cE2Num
SE2->E2_PREFIXO := _cE2Pref  
SE2->E2_TIPO    := _cTipo
SE2->E2_NATUREZ := _cNATUREZA  

// Cliente generico de importacao.
SE2->E2_FORNECE := "DEBAUT"  
SE2->E2_LOJA    := _cLojImp
SE2->E2_NOMFOR  := "DEBITO AUTOMATICO" 
//
SE2->E2_EMISSAO := _dCREDITO 
SE2->E2_EMIS1   := _dCREDITO 
SE2->E2_VENCTO  := _dCREDITO 
SE2->E2_VENCORI := _dCREDITO 
SE2->E2_VENCREA := DataValida(_dCREDITO) 
SE2->E2_BAIXA   := _dCREDITO 
SE2->E2_MOVIMEN := _dCREDITO 
SE2->E2_VALOR   := _nE2Ori
SE2->E2_HIST    := _cHist
SE2->E2_VLCRUZ  := _nE2Ori
SE2->E2_MOEDA   := 1
//SE2->E2_MULTNAT := "2"
SE2->E2_MULNATU := "2"
SE2->E2_PROJPMS := "2"
SE2->E2_ORIGEM  := "FINA050" 
SE2->E2_OCORREN := xFilial("SE2")
SE2->E2_VALLIQ  := _nE2Liq
SE2->E2_DESCONT := _nE2Tar 
SE2->E2_JUROS   := _nE2Jur
SE2->E2_MULTA   := _nE2Mul   
SE2->E2_PORTADO := _cBANCO
SE2->E2_BCOPAG  := _cBANCO
SE2->E2_FLUXO   := "S"
SE2->E2_DESDOBR := "N"
SE2->E2_FL      := _cFL
SE2->(msUnLock())
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SZ5SE5   �Autor  � Felipe Raposo      � Data �  17/01/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria movimentacao bancaria, de acordo com os valores pas-  ���
���          � sados por parametro.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SZ5SE5(_cTipoDoc, _nValLiq, _nDesc, _nJuros, _nMulta, _cHistor, _cNatSE5, _cFL, _cPresta)

// Verifica se as variaveis foram passadas por parametro.
// Se nao foram, assumir o valor zero.
_nDesc   := IIf(ValType(_nDesc)   == "N", _nDesc,  0)
_nJuros  := IIf(ValType(_nJuros)  == "N", _nJuros, 0)
_nMulta  := IIf(ValType(_nMulta)  == "N", _nMulta, 0)

RecLock("SE5", .T.)
SE5->E5_FILIAL  := xFilial("SE5")
SE5->E5_MOEDA   := "CC"
SE5->E5_TIPODOC := "CC" //_cTipoDoc
SE5->E5_RECPAG  := "P"
SE5->E5_DATA    := _dCREDITO 
SE5->E5_VENCTO  := _dCREDITO 
SE5->E5_NUMERO  := _cFL    // _cE2Num
SE5->E5_PREFIXO := "CC "   // _cE2Pref  
SE5->E5_TIPO    := ""      // _cE2Tipo
SE5->E5_VALOR   := _nValLiq
SE5->E5_VLDESCO := _nDesc
SE5->E5_VLJUROS := _nJuros
SE5->E5_VLMULTA := _nMulta
SE5->E5_NATUREZ := _cNatSE5 // NATUREZA
SE5->E5_BANCO   := _cBANCO
SE5->E5_AGENCIA := _cAGENCIA
SE5->E5_CONTA   := _cCONTA
SE5->E5_HISTOR  := _cHistor
SE5->E5_VLMOED2 := xMoeda(_nValLiq, 1, 2, dDataBase, 2)
SE5->E5_LA      := "N"
SE5->E5_CLIFOR  :=	"DEBAUT" 
SE5->E5_LOJA    := _cLojImp
SE5->E5_DTDIGIT := _dCREDITO 
SE5->E5_MOTBX   := "NOR"
SE5->E5_RECONC  := "x"  // J� reconciliado
SE5->E5_SEQ     := "01"
SE5->E5_DTDISPO := _dCREDITO 
SE5->E5_DOCUMEN := _cFL
SE5->E5_BENEF   := _cPresta
SE5->(msUnLock())
Return

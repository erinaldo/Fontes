#Include "PROTHEUS.Ch"      
#include "TopConn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³CSFISR01()³ Autor ³ Renato Carlos     	³ Data ³ 27.03.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Conferencia Pis Cofins                 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CSFISR01()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºAlteracoes³ OS 3075/16 Inclusão de campos. (Operação,ORG e Cliente)	  º±±
±±º          ³ Douglas David    				                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ Fiscal       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function CSFISR01()

Local _aArea := GetArea()
Local nX     := 1

Private cDirDocs := MsDocPath()            // Diretorio de docs do servidor
Private cTmpTxt  := CriaTrab(Nil,.f.)
Private cCmd     := cDirDocs+"\"+cTmpTxt+".csv"
Private cPerg    := PADR("CSFISEFD",LEN(SX1->X1_GRUPO))
Private _cArquivo := ""

AjustaSx1()

IF Pergunte(cPerg,.T.)
	_cArquivo := cGetFile("", "Informe o Diretorio onde o Relatorio será gravado",,,,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)
	Processa( { || ProcRel() }, 'Processando Relatório.....' )
EndIf


RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ ProcRel  ³ Autor ³ Renato Carlos     	³ Data ³ 27.03.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa o relatorio                              		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ProcRel()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ SIGAFIS      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcRel()

Local _cArqEFD := _cArquivo	
//Local _cArqEFD := "C:\PISCOFINS_"+Dtos(dDatabase)+".CSV"	
Local _cQryEFD := ""
Local _cTmpEFD  := "cTmpEFD"

Private _nRecCnt := 0
Private cLinEFD
Private cLinRat
Private cLinZB8

// Cria a string para o cabecalho
	/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 		INCLUSAO DA COLUNA DESPESAS					±±
±±  	OS:1168/12 FERNANDO BARRETO                 ±±
±±        data: 17/05/2012				        	±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/ 
Private cCabEFD :=	"FILIAL;EMISSAO;DIGITACAO;FORNECE;RSOCIAL;NFISCAL;ESPECIE;SERIE;CFOP;TES;PRODUTO;DESCPROD;UNIDNEG;NATUREZA;DESCNAT;QUANT;PRCUNIT;VALTOT;VALIPI;ICMSRET;FRETE;VALICM;VALBRUT;BASEPIS;BASECOF;"+;
					"ALIQPIS;ALIQCOF;VALPIS;VALCOF;DESPESA;DESCONTO;SEGURO;RATEIO;OPERACAO;CLIENTE/ORG"+CHR(13)+CHR(10)

// Cria o bloco de código para processar os itens do relatorio

Private bLinEFD := {|| cLin1 := @FT_FILIAL+';'+@FT_EMISSAO+';'+@FT_ENTRADA+';'+@FT_CLIEFOR+';'+Alltrim(FDESC("SA2",@FT_CLIEFOR,"A2_NOME"))+';'+@FT_NFISCAL+';'+@FT_ESPECIE+';'+@FT_SERIE+';'+@FT_CFOP+';'+;
								@D1_TES+';'+@FT_PRODUTO+';'+Alltrim(FDESC("SB1",@FT_PRODUTO,"B1_DESC"))+';'+@D1_ITEMCTA+';'+STRTRAN(@D1_NATFULL,";",".")+';'+Alltrim(FDESC("SED",@D1_NATFULL,"ED_DESCRIC"))+';'+;
								Transform(@FT_QUANT,"@E 999,999,999.99")+';'+Transform(@FT_PRCUNIT,"@E 999,999,999.99")+';'+Transform(@VALTOT,"@E 999,999,999.99")+';'+Transform(@FT_IPIOBS,"@E 999,999,999.99")+';'+;
								Transform(@FT_ICMSRET,"@E 999,999,999.99")+';'+Transform(@FT_FRETE,"@E 999,999,999.99")+';'+Transform(@FT_VALICM,"@E 999,999,999.99")+';'+;
								Transform(@FT_VALCONT,"@E 999,999,999.99")+';'+Transform(@FT_BASEPIS,"@E 999,999,999.99")+';'+;
								Transform(@FT_BASECOF,"@E 999,999,999.99")+';'+Transform(@FT_ALIQPIS,"@E 999,999,999.99")+';'+Transform(@FT_ALIQCOF,"@E 999,999,999.99")+';'+;
								Transform(@FT_VALPIS,"@E 999,999,999.99")+';'+Transform(@FT_VALCOF,"@E 999,999,999.99")+';'+Transform(@D1_DESPESA,"@E 999,999,999.99")+';'+;
								Transform(@FT_DESCONT,"@E 999,999,999.99")+';'+	Transform(@F1_SEGURO,"@E 999,999,999.99")+';'+;
								@F1_RATESP+';'+StrZero(Val(@D1_CLVL),9)+';'+@CTH_DESC01+CHR(13)+CHR(10)}    
							 
								
Private bLinRat := {|| cLin2 := ";;;;;;;;;;;;"+@EZ_ITEMCTA+';'+STRTRAN(@EZ_NATUREZ,";",".")+';'+Alltrim(FDESC("SED",@EZ_NATUREZ,"ED_DESCRIC"))+";;;;;;;;"+Transform(@EZ_VALOR,"@E 999,999,999.99")+";;;;;;;;SIM"+CHR(13)+CHR(10)}

Private bLinZB8 := {|| cLin3 := ";;;;;;;;;;;;"+@ZB8_ITDBTO+';'+STRTRAN(@EV_NATUREZ,";",".")+';'+Alltrim(FDESC("SED",@EV_NATUREZ,"ED_DESCRIC"))+";;;;;;;;"+Transform(@VLRAT,"@E 999,999,999.9999")+";;;;;;;;SIM"+CHR(13)+CHR(10)}

// Monta a query para extração dos dados.

_cQryEFD := "SELECT  FT_FILIAL,

_cQryEFD += " CASE WHEN FT_EMISSAO = '' THEN ''  "
_cQryEFD += " ELSE CONVERT(VARCHAR,CAST(FT_EMISSAO AS DATETIME),103) "
_cQryEFD += " END AS FT_EMISSAO,  "

_cQryEFD += " CASE WHEN FT_ENTRADA = '' THEN ''  "
_cQryEFD += " ELSE CONVERT(VARCHAR,CAST(FT_ENTRADA AS DATETIME),103) "
_cQryEFD += " END AS FT_ENTRADA,  "

_cQryEFD += "FT_CLIEFOR,FT_LOJA,FT_NFISCAL,FT_ESPECIE,FT_SERIE,FT_CFOP,"						
_cQryEFD += "FT_PRODUTO,FT_QUANT,FT_PRCUNIT,(FT_QUANT*FT_PRCUNIT) AS VALTOT, FT_IPIOBS,FT_VALICM,FT_FRETE,FT_ICMSRET,FT_VALCONT,FT_BASEPIS,FT_BASECOF,"						
_cQryEFD += "FT_ALIQPIS,FT_ALIQCOF,FT_VALPIS,FT_VALCOF,D1_DESPESA,FT_DESCONT,F1_SEGURO,D1_TES,D1_NATFULL,D1_ITEMCTA,F1_XTABRAT,"

_cQryEFD += "D1_CLVL, CTH_DESC01, "

_cQryEFD += " CASE WHEN F1_RATESP = '1' THEN 'SIM'  "
_cQryEFD += " ELSE 'NAO' "
_cQryEFD += " END AS F1_RATESP  "

_cQryEFD += " FROM "+RetSqlName("SFT")+ " SFT, "+RetSqlName("SD1")+ " SD1, "+RetSqlName("SF1")+ " SF1, "+RetSqlName("CTH")+ " CTH "
_cQryEFD +=" WHERE FT_FILIAL = D1_FILIAL "
_cQryEFD +=" AND FT_CLIEFOR = D1_FORNECE "
_cQryEFD +=" AND FT_LOJA = D1_LOJA " 
_cQryEFD +=" AND FT_NFISCAL = D1_DOC "
_cQryEFD +=" AND FT_SERIE = D1_SERIE "
_cQryEFD +=" AND FT_PRODUTO = D1_COD "
_cQryEFD +=" AND D1_TOTAL=FT_TOTAL "
_cQryEFD +=" AND FT_QUANT=D1_QUANT "
_cQryEFD +=" AND D1_ITEM=FT_ITEM "
_cQryEFD +=" AND FT_FILIAL = F1_FILIAL "
_cQryEFD +=" AND FT_CLIEFOR = F1_FORNECE "
_cQryEFD +=" AND FT_LOJA = F1_LOJA "
_cQryEFD +=" AND FT_NFISCAL = F1_DOC "
_cQryEFD +=" AND FT_SERIE = F1_SERIE "                 
_cQryEFD +=" AND D1_CLVL = CTH_CLVL  "      
_cQryEFD +=" AND (FT_VALCOF!='0' or  FT_VALPIS!='0')  "
_cQryEFD +=" AND D1_NATFULL NOT IN('1.3.45','1.2.45','13.45','1.23.45') "
_cQryEFD += "AND FT_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cQryEFD += "AND FT_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
_cQryEFD += "AND FT_ENTRADA BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' "
_cQryEFD += "AND D1_NATFULL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " 
_cQryEFD += "AND FT_TIPOMOV = 'E' "
_cQryEFD += "AND SFT.D_E_L_E_T_ = '' "
_cQryEFD += "AND SF1.D_E_L_E_T_ = '' " 
_cQryEFD += "AND SD1.D_E_L_E_T_ = '' "
_cQryEFD += "AND CTH.D_E_L_E_T_ = '' "
_cQryEFD += "ORDER BY FT_FILIAL,FT_EMISSAO,FT_ENTRADA,FT_CLIEFOR,FT_NFISCAL"

MemoWrite("C:\PISCOFINS.SQL",_cQryEFD)

// Gera o temporario com os dados da query

_nRecCnt := U_MontaView( _cQryEFD, _cTmpEFD )

TCSetField(_cTmpEFD,"FT_QUANT",  "N", TamSX3("FT_QUANT")[2],2)
TcSetField(_cTmpEFD,"FT_PRCUNIT","N", TamSX3("FT_QUANT")[2],2)
TcSetField(_cTmpEFD,"VALTOT"    ,"N", TamSX3("FT_TOTAL")[2],2)
TcSetField(_cTmpEFD,"FT_IPIOBS","N", TamSX3("FT_VALIPI")[2],2)
TcSetField(_cTmpEFD,"FT_VALICM","N", TamSX3("FT_VALICM")[2],2)
TcSetField(_cTmpEFD,"FT_FRETE","N", TamSX3("FT_FRETE")[2],2)
TcSetField(_cTmpEFD,"FT_ICMSRET","N", TamSX3("FT_ICMSRET")[2],2)
TcSetField(_cTmpEFD,"FT_VALCONT","N", TamSX3("FT_VALCONT")[2],2)
TcSetField(_cTmpEFD,"FT_BASEPIS","N", TamSX3("FT_BASEPIS")[2],2)
TcSetField(_cTmpEFD,"FT_BASECOF","N", TamSX3("FT_BASECOF")[2],2)
TcSetField(_cTmpEFD,"FT_ALIQPIS","N", TamSX3("FT_ALIQPIS")[2],2)
TcSetField(_cTmpEFD,"FT_ALIQCOF","N", TamSX3("FT_ALIQCOF")[2],2)
TcSetField(_cTmpEFD,"FT_VALPIS","N", TamSX3("FT_VALPIS")[2],2)
TcSetField(_cTmpEFD,"FT_VALCOF","N", TamSX3("FT_VALCOF")[2],2)    
//TcSetField(_cTmpEFD,"FT_DESPESA","N", TamSX3("FT_DESPESA")[2],2)
(_cTmpEFD)->( DbGoTop() )

GeraCsv (cCmd,cCabEFD,cLinEFD,cLinRat ,cLinZB8,_cTmpEFD,_cArqEFD,bLinEFD,bLinRat,bLinZB8)
(_cTmpEFD)->( DbCloseArea() )

ALERT("Arquivo gerado com sucesso")

Return	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Geracsv   ºAutor  ³Renato Carlos       º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gera CSV                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10-CSU                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraCsv(cCmd,cCab,cLin1,cLin2,cLin3,_cAlias,cArq,bLin1,bLin2,bLin3)

Local _cNumNF := ""
Local _cQryRat := ""
Local _cQrySEV := ""
Local _cTmpRat := "cTmpRat"
Local _cTmpSEV := "cTmpSEV"
Local _lFirst := .T.
Local _lRat := .F.
Local _cAnoMes := ""
Local _cUltRev := ""
Local _nCntRat := 1

nHdl := fCreate(cCmd)
fWrite(nHdl,cCab,Len(cCab))

DbSelectArea(_cAlias)

ProcRegua(_nRecCnt)

While (_cAlias)->( !EOF() )
	
	IncProc("Processando registros...")
	Eval(bLin1)
			
	_cNumNF  := (_cAlias)->FT_NFISCAL

	/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±		REMOCAO DOS RATEIOS DAS NOTAS FISCAIS		±±
±±  	OS:1579/12 FERNANDO BARRETO                 ±±
±±        data: 26/06/2012				        	±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/   		
/*	If (_cAlias)->F1_RATESP == "SIM" .Or. _lRat
   		   		
	    If !_lFirst 
	    
	    	If _cNumAnt != _cNumNF .And. _lRat 
	    
				 If (_cAlias)->F1_XTABRAT <> '1'
				 
					 _cQryRat := ""
					 _cQryRat += "SELECT EZ_NATUREZ, EZ_VALOR, EZ_ITEMCTA "
					 _cQryRat += " FROM "+RetSqlName("SEZ")+" "
				     _cQryRat += " WHERE EZ_NUM = '"+_cNumAnt+"' "
				     _cQryRat += " AND EZ_CLIFOR = '"+_cFornAnt+"' AND EZ_LOJA = '"+_cLojaAnt+"' "
					 _cQryRat += " AND D_E_L_E_T_ = '' "
					 	
					 U_MontaView( _cQryRat, _cTmpRat )
					 
					 (_cTmpRat)->( DbGoTop() )
					 
					 While (_cTmpRat)->( !EOF() )
					 	Eval(bLin2)
					 	fWrite(nHdl,cLin2,Len(cLin2))
						(_cTmpRat)->(dbSkip())
					 EndDo
					 
					 _lFirst := .T.
			   		 _lRat := .F.
			   		 _cNumAnt := _cNumNF
			   		 _cFornAnt := (_cAlias)->FT_CLIEFOR
				     _cLojaAnt := (_cAlias)->FT_LOJA
			   		 (_cTmpRat)->( DbCloseArea() )
			   		 DbSelectArea(_cAlias)
			   		 
			   		 If _nCntRat >= _nRecCnt 
			   		 	(_cAlias)->(dbSkip())
			   		 	_nCntRat++
			   		 EndIf
			   		 
			   	 Else
			   	 
			   	 	 _cAnoMes	:= U_GetCompetencia((_cAlias)->FT_FILIAL+(_cAlias)->FT_NFISCAL+(_cAlias)->FT_SERIE+(_cAlias)->FT_CLIEFOR+(_cAlias)->FT_LOJA)
					 
					 _cQrySEV := ""
					 _cQrySEV += " SELECT EV_XCODRAT FROM "+RetSqlName("SEV")+" "
					 _cQrySEV += " WHERE EV_NUM = '"+(_cAlias)->FT_NFISCAL+"' "
				     _cQrySEV += " AND EV_CLIFOR = '"+(_cAlias)->FT_CLIEFOR+"' "
					 _cQrySEV += " AND EV_LOJA = '"+(_cAlias)->FT_LOJA+"'  "
					 _cQrySEV += " AND D_E_L_E_T_ = ''
					 _cQrySEV += " GROUP BY EV_XCODRAT
					 
					 U_MontaView( _cQrySEV, _cTmpSEV )
					 
					 (_cTmpSEV)->( DbGoTop() )
					 
					 _cUltRev	:= U_RZB7ULTR((_cTmpSEV)->EV_XCODRAT,_cAnoMes,.T.)
					 (_cTmpSEV)->( DbCloseArea() )
			   	 	 
			   	 	 _cQryRat := ""
					 _cQryRat += "SELECT EV_NATUREZ,EV_VALOR,ZB8_CCDBTO,ZB8_PERCEN,ZB8_ITDBTO,(EV_VALOR*ZB8_PERCEN)/100 AS VLRAT "
					 _cQryRat += " FROM "+RetSqlName("SEV")+" "
				     _cQryRat += " INNER JOIN "+RetSqlName("ZB8")+" ON EV_XCODRAT	= ZB8_CODRAT AND ZB8_ANOMES = '"+_cAnoMes+"' AND ZB8_REVISA = '"+_cUltRev+"' AND ZB8050.D_E_L_E_T_ = '' "
				     _cQryRat += " WHERE EV_NUM = '"+_cNumAnt+"'"
				     _cQryRat += " AND EV_CLIFOR = '"+_cFornAnt+"' AND EV_LOJA = '"+_cLojaAnt+"' "
					 _cQryRat += " AND SEV050.D_E_L_E_T_ = '' "
					 _cQryRat += " GROUP BY EV_NATUREZ,EV_VALOR,ZB8_CCDBTO,ZB8_PERCEN,ZB8_ITDBTO "
					 
					 /*
					 SELECT EV_NATUREZ,EV_VALOR,ZB8_ITDBTO,SUM((EV_VALOR*ZB8_PERCEN)/100) AS VLRAT FROM SEV050
						INNER JOIN ZB8050 ON EV_XCODRAT	= ZB8_CODRAT AND ZB8_ANOMES = '201112' AND ZB8_REVISA = '000' AND ZB8050.D_E_L_E_T_ = ''
						WHERE EV_NUM = '000006562'
						AND EV_CLIFOR = '101161'
						 AND EV_LOJA = '01'
						 AND SEV050.D_E_L_E_T_ = ''
						 GROUP BY EV_NATUREZ,EV_VALOR,ZB8_ITDBTO
					 	*/
					/*U_MontaView( _cQryRat, _cTmpRat )
			   	 
			   	 	(_cTmpRat)->( DbGoTop() )
					 
					 While (_cTmpRat)->( !EOF() )
					 	Eval(bLin3)
					 	fWrite(nHdl,cLin3,Len(cLin3))
						(_cTmpRat)->(dbSkip())
					 EndDo
					 
					 _lFirst := .T.
			   		 _lRat := .F.
			   		 _cNumAnt := _cNumNF
			   		 _cFornAnt := (_cAlias)->FT_CLIEFOR
				     _cLojaAnt := (_cAlias)->FT_LOJA
			   		 (_cTmpRat)->( DbCloseArea() )
			   		 DbSelectArea(_cAlias)
			   		 
			   		 If _nCntRat >= _nRecCnt 
			   		 	(_cAlias)->(dbSkip())
			   		 	_nCntRat++
			   		 EndIf
			   		 			   	 			   	 
			   	 EndIf	 
			Else
		     	fWrite(nHdl,cLin1,Len(cLin1))
		     	_cFornAnt := (_cAlias)->FT_CLIEFOR
				_cLojaAnt := (_cAlias)->FT_LOJA
				_cNumAnt := _cNumNF
				(_cAlias)->(dbSkip())
				_nCntRat++
			EndIf
		  	
		Else
			fWrite(nHdl,cLin1,Len(cLin1))
		   	_cNumAnt := _cNumNF
		   	_cFornAnt := (_cAlias)->FT_CLIEFOR
			_cLojaAnt := (_cAlias)->FT_LOJA
		   	_lFirst := .F.
		   	_lRat := .T.
			//(_cAlias)->(dbSkip())
			If _nCntRat < _nRecCnt 
				(_cAlias)->(dbSkip())
				_nCntRat++
			Else
				_cNumAnt :=	""
				//_nCntRat := 1 
			Endif 
		EndIf 	
	
	Else*/   
		/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	  FIM REMOCAO DOS RATEIOS DAS NOTAS FISCAIS		±±
±±  	OS:1579/12 FERNANDO BARRETO                 ±±
±±        data: 26/06/2012				        	±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/  
	
		fWrite(nHdl,cLin1,Len(cLin1))
		(_cAlias)->(dbSkip())
    	_nCntRat++
  // EndIf  
	
EndDo
fClose(nHdl)
//CpyS2T(cCmd,cArq,.T.)
//COPY TO &(cCmd) VIA "DBFCDX"
__CopyFile(cCmd, cArq)
RETURN



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Nereu Humberto Jr     ³ Data ³16.09.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSx1()


Local aRegs := {}


aAdd(aRegs,{cPerg,'01','Filial De             ?','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0','',"","","",""})
aAdd(aRegs,{cPerg,'02','Filial Ate            ?','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0',"","","","",""})
aAdd(aRegs,{cPerg,'03','Emissao De            ?','','','mv_ch3','D',08,0,0,'G','           ','mv_par03','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','',"","","","",""})
aAdd(aRegs,{cPerg,'04','Emissao Ate           ?','','','mv_ch4','D',08,0,0,'G','           ','mv_par04','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','',"","","","",""})
aAdd(aRegs,{cPerg,'05','Digitacao De          ?','','','mv_ch5','D',08,0,0,'G','           ','mv_par05','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','',"","","","",""})
aAdd(aRegs,{cPerg,'06','Digitacao Ate         ?','','','mv_ch6','D',08,0,0,'G','           ','mv_par06','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','',"","","","",""})
aAdd(aRegs,{cPerg,'07','Natureza De           ?','','','mv_ch7','C',10,0,0,'G','           ','mv_par07','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SED',"","","","",""})
aAdd(aRegs,{cPerg,'08','Natureza Ate          ?','','','mv_ch8','C',10,0,0,'G','           ','mv_par08','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SED',"","","","",""})

U_ValidPerg(cPerg,aRegs)

Return			


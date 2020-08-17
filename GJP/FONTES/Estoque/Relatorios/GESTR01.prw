#include "protheus.ch

/*
{Protheus.doc} GESTR01
Relatorio Análise de Custo Real x Custo Teórico
@class N/A
@from  N/A
@param N/A
@attrib N/A
@protected
@author Alexandre Felicio
@version 11.8
@since 03/12/2014
@return N/A
@sample U_GJPREL() 
@obs N/A
@project 
@menu N/A
@history N/A
*/ 
User Function GESTR01()      
Private _cPerg  := PadR("GJPREL", Len(SX1->X1_GRUPO))           

CriaPerg(_cPerg) 

Processa( {|| ReportDef()  }, "Rel. Custo Real x Custo Teórico" )

Return  


/*
{Protheus.doc} ReportDef 
Seleciona Colunas para o Relatorio
@class N/A
@from  N/A
@param N/A
@attrib N/A
@protected 
@author Alexandre Felicio
@version 11.8
@since 03/12/2014
@return N/A
@sample ReportDef()
@obs N/A
@project 
@menu N/A
@history N/A
*/ 

Static Function ReportDef()
Private oSessao1 := nil
Private oReport
                                                                                                               
SET DATE FORMAT TO "dd/mm/yyyy"
SET CENTURY ON
SET DATE BRITISH

pergunte(_cPerg,.F.) 

//######################
//##Cria Objeto TReport#
//######################
oReport := TReport():New("GJPREL","Rel. Custo Real x Custo Teórico",_cPerg,{|| PrintReport()},"Rel. Custo Real x Custo Teórico")
oReport:lParamPage := .T.
oReport:SetLandscape(.T.) 

//###############
//##Cria Sessao1#
//###############

oSessao1 := TRSection():New(oReport, "Rel. Custo Real x Custo Teórico",,,,,,.T.) 
oSessao1:SetHeaderSection(.T.) //Define que imprime cabeçalho das células na quebra de seção
oSessao1:SetHeaderBreak(.T.)

TRCell():New(oSessao1,"B1COD"  ,'TRB', "Produto"          ,,TamSX3("B1_COD")[1],.F.)
TRCell():New(oSessao1,"B1DESC" ,'TRB', "Descricao"        ,,TamSX3("B1_DESC")[1],.F.)
TRCell():New(oSessao1,"B2CM1"  ,'TRB', "Custo Medio"      ,,TamSX3("B2_CM1")[1],.F.)
TRCell():New(oSessao1,"QTDREQ" ,'TRB', "Consumo - Qtde.Requisicoes",,TamSX3("D2_QUANT")[1],.F.)
TRCell():New(oSessao1,"TOTREQ" ,'TRB', "Consumo - Vlr. Requisicoes",,TamSX3("D2_PRCVEN")[1],.F.) 
TRCell():New(oSessao1,"QTDVEN" ,'TRB', "Consumo - Qtde.Vendas"	 ,,TamSX3("D2_QUANT")[1],.F.)
TRCell():New(oSessao1,"TOTVEN" ,'TRB', "Consumo - Vlr. Vendas"	 ,,TamSX3("D2_PRCVEN")[1],.F.) 
TRCell():New(oSessao1,"DIFAIQ" ,'TRB', "Difer. Qtde. Antes Inventario",,TamSX3("D2_QUANT")[1],.F.)
TRCell():New(oSessao1,"DIFAIV" ,'TRB', "Difer. Valor Antes Inventario",,TamSX3("D2_PRCVEN")[1],.F.)                                         
TRCell():New(oSessao1,"ESTOQQ" ,'TRB', "Qtde. Armazem Secundario"	 ,,TamSX3("D2_QUANT")[1],.F.)
TRCell():New(oSessao1,"ESTOQV" ,'TRB', "Valor Armazem Secundario"	 ,,TamSX3("D2_PRCVEN")[1],.F.) 
TRCell():New(oSessao1,"DIFPIQ" ,'TRB', "Difer. Qtde. Pos Inventario"  ,,TamSX3("D2_QUANT")[1],.F.)
TRCell():New(oSessao1,"DIFPIV" ,'TRB', "Difer. Valor Pos Inventario"  ,,TamSX3("D2_PRCVEN")[1],.F.) 


oBreak	:=	TRBreak():New(oSessao1, ''/*alias com campo para quebra se houver*/, "Totais: ")      
			TRFunction():New(oSessao1:Cell("QTDREQ")	, ""	, "SUM"		, oBreak, ""/*cTitle*/	, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
			TRFunction():New(oSessao1:Cell("TOTREQ")	, ""	, "SUM"		, oBreak, "" /*cTitle*/, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
            
   			TRFunction():New(oSessao1:Cell("QTDVEN")	, ""	, "SUM"		, oBreak, ""/*cTitle*/	, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
			TRFunction():New(oSessao1:Cell("TOTVEN")	, ""	, "SUM"		, oBreak, "" /*cTitle*/, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
            
			TRFunction():New(oSessao1:Cell("DIFAIQ")	, ""	, "SUM"		, oBreak, ""/*cTitle*/	, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
			TRFunction():New(oSessao1:Cell("DIFAIV")	, ""	, "SUM"		, oBreak, "" /*cTitle*/, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
	             
			TRFunction():New(oSessao1:Cell("ESTOQQ")	, ""	, "SUM"		, oBreak, ""/*cTitle*/	, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
			TRFunction():New(oSessao1:Cell("ESTOQV")	, ""	, "SUM"		, oBreak, "" /*cTitle*/, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
            
			TRFunction():New(oSessao1:Cell("DIFPIQ")	, ""	, "SUM"		, oBreak, ""/*cTitle*/	, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)
			TRFunction():New(oSessao1:Cell("DIFPIV")	, ""	, "SUM"		, oBreak, "" /*cTitle*/, "@E 999,999,999.99"/*cPicture*/	, /*uFormula*/		, .F./*lEndSection*/, .F./*lEndReport*/, .F./*lEndPage*/)



oReport:PrintDialog()


Return  

/*
{Protheus.doc} PrintReport 
Realiza Rotina de impressao
@class N/A
@from  N/A
@param N/A
@attrib N/A
@protected 
@author Alexandre Felicio
@version 11.8
@since 01/12/2014
@return N/A
@sample PrintReport(oReport)
@obs N/A
@project 
@menu N/A
@history N/A
*/ 

Static Function PrintReport() 

U_SelDados()///Seleciona Dados para o Relatório

oReport:SetMeter(TRB->(RecCount()))
oSessao1:Init() 

While TRB->(!EOF())

	oReport:IncMeter()  
	
	oReport:Section(1):Cell("B1COD"):SetBlock({||  TRB->PROD  })  
	oReport:Section(1):Cell("B1DESC"):SetBlock({|| TRB->DESC  })  
	oReport:Section(1):Cell("B2CM1"):SetBlock({||  TRB->CUSM  })
	oReport:Section(1):Cell("QTDREQ"):SetBlock({|| TRB->REQQ  })
	oReport:Section(1):Cell("TOTREQ"):SetBlock({|| TRB->REQV  })
    oReport:Section(1):Cell("QTDVEN"):SetBlock({|| TRB->VENQ  })
	oReport:Section(1):Cell("TOTVEN"):SetBlock({|| TRB->VENV  })
    oReport:Section(1):Cell("DIFAIQ"):SetBlock({|| TRB->DIFAIQ  })
	oReport:Section(1):Cell("DIFAIV"):SetBlock({|| TRB->DIFAIV  })
    oReport:Section(1):Cell("ESTOQQ"):SetBlock({|| TRB->ESTQ  })
	oReport:Section(1):Cell("ESTOQV"):SetBlock({|| TRB->ESTV  })
    oReport:Section(1):Cell("DIFPIQ"):SetBlock({|| TRB->DIFPIQ  })
	oReport:Section(1):Cell("DIFPIV"):SetBlock({|| TRB->DIFPIV  })

	oReport:IncMeter()
    oSessao1:PrintLine(.T.)
    
	TRB->(DBSKIP())        
ENDDO  


oSessao1:Finish()

TRB->(DbCloseArea())
TMP1->(DbCloseArea())
TMP2->(DbCloseArea())
TMP3->(DbCloseArea())
TMP4->(DbCloseArea())
                            

Return                       


/*
{Protheus.doc} ValidPerg 
Cria Parametros SX1
@class N/A
@from  N/A
@param N/A
@attrib N/A
@protected 
@author Alexandre Felicio
@version 11.8
@since 30/05/2014
@return N/A
@sample ValidPerg()
@obs N/A
@project 
@menu N/A
@history N/A
*/
Static Function CriaPerg(cPerg)
	PutSX1(_cPerg,"01","Data De.....................:?","","","MV_CH1","D",8,00,0,"G","","" ,"   ","","mv_par01","","","","","","","","","","","","","","","","")  
	PutSX1(_cPerg,"02","Data Ate....................:?","","","MV_CH2","D",8,00,0,"G","","" ,"   ","","mv_par02","","","","","","","","","","","","","","","","")  
	PutSX1(_cPerg,"03","Produto De..................:?","","","MV_CH3","C",TamSX3("B1_COD")[1],00,0,"G","","SB1" ,"   ","","mv_par03","","","","","","","","","","","","","","","","")  
	PutSX1(_cPerg,"04","Produto Ate.................:?","","","MV_CH4","C",TamSX3("B1_COD")[1],00,0,"G","","SB1" ,"   ","","mv_par04","","","","","","","","","","","","","","","","")  
	PutSX1(_cPerg,"05","C. Custo De.................:?","","","MV_CH5","C",TamSX3("CTT_CUSTO")[1],00,0,"G","","CTT" ,"   ","","mv_par05","","","","","","","","","","","","","","","","")  
	PutSX1(_cPerg,"06","C. Custo Ate................:?","","","MV_CH6","C",TamSX3("CTT_CUSTO")[1],00,0,"G","","CTT" ,"   ","","mv_par06","","","","","","","","","","","","","","","","")  
Return  

/*
{Protheus.doc} SelDados 
Seleciona Dados
@class N/A
@from  N/A
@param N/A
@attrib N/A
@protected 
@author Alexandre Felicio
@version 11.8
@since 05/12/2014
@return N/A
@sample SelDados
@obs N/A
@project 
@menu N/A
@history N/A
*/ 
User Function SelDados() 
Local cQuery   := ''
Local _QtdPDV  := 0 
Local _VlrPDV  := 0 
Local _cComp   := 0
Local _nQuant  := 0   
Local aArqTrab	 := {}   
Local cTabAux    := ""
Private aStru       := {}
			
aadd(aArqTrab,{"PROD"   ,  	 TamSX3("B1_COD")[3] , TamSX3("B1_COD")[1]  	,TamSX3("B1_COD")[2]})
aadd(aArqTrab,{"DESC"  ,  	 TamSX3("B1_DESC")[3] , TamSX3("B1_DESC")[1]  	,TamSX3("B1_DESC")[2]})
aadd(aArqTrab,{"CUSM" ,   	 TamSX3("B2_CM1")[3] , TamSX3("B2_CM1")[1]  	,TamSX3("B2_CM1")[2]})
aadd(aArqTrab,{"REQQ" ,   	 TamSX3("C6_QTDVEN")[3]	 ,TamSX3("C6_QTDVEN")[1]	    ,TamSX3("C6_QTDVEN")[2]})
aadd(aArqTrab,{"REQV"  ,  	 TamSX3("B2_CM1")[3] , TamSX3("B2_CM1")[1]  	,TamSX3("B2_CM1")[2]})
aadd(aArqTrab,{"VENQ"    , 	 TamSX3("C6_QTDVEN")[3]	 ,TamSX3("C6_QTDVEN")[1]	    ,TamSX3("C6_QTDVEN")[2]})
aadd(aArqTrab,{"VENV"   , 	 TamSX3("B2_CM1")[3] , TamSX3("B2_CM1")[1]  	,TamSX3("B2_CM1")[2]})
aadd(aArqTrab,{"DIFAIQ"  , 	 TamSX3("C6_QTDVEN")[3]	 ,TamSX3("C6_QTDVEN")[1]	    ,TamSX3("C6_QTDVEN")[2]})
aadd(aArqTrab,{"DIFAIV"    , TamSX3("B2_CM1")[3] , TamSX3("B2_CM1")[1]  	,TamSX3("B2_CM1")[2]})
aadd(aArqTrab,{"ESTQ"  , 	 TamSX3("C6_QTDVEN")[3]	 ,TamSX3("C6_QTDVEN")[1]	    ,TamSX3("C6_QTDVEN")[2]})
aadd(aArqTrab,{"ESTV"    ,   TamSX3("B2_CM1")[3] , TamSX3("B2_CM1")[1]  	,TamSX3("B2_CM1")[2]})
aadd(aArqTrab,{"DIFPIQ"  , 	 TamSX3("C6_QTDVEN")[3]	 ,TamSX3("C6_QTDVEN")[1]	    ,TamSX3("C6_QTDVEN")[2]})
aadd(aArqTrab,{"DIFPIV"    , TamSX3("B2_CM1")[3] , TamSX3("B2_CM1")[1]  	,TamSX3("B2_CM1")[2]})

cTabAux := CriaTrab(aArqTrab, .T.)     
DbCreate(cTabAux, aArqTrab)
cInd := LEFT(cTabAux, 7) + "1"

Iif(Select('TRB') > 0, TRB->(DbCloseArea()),)
DbUseArea(.T., , cTabAux, 'TRB', .F., .F.)
      
IndRegua('TRB', cInd, "PROD")     	
TRB->(DbClearIndex())	
DbSetIndex(cInd + OrdBagExt())


 
//// Registros para a seção Total Consumo Via Requisições
Iif(Select("TMP3") > 0, TMP3->(DbCloseArea()),)
									
cQuery := " select 'GJP' REL,SB1.B1_COD CODIGO,SB1.B1_DESC DESCRICAO, SB2.B2_CM1 CUSTO_MEDIO, SD3.D3_QUANT QTD_REQ , "    
cQuery += " SUM(SD3.D3_QUANT * SB2.B2_CM1) TOT_REQ "
cQuery += " FROM " + RetSqlName("SD3") + " SD3, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB2") + " SB2 "
cQuery += " where SD3.D_E_L_E_T_ = '' " 
cQuery += " and   SB2.D_E_L_E_T_ = '' "
cQuery += " and   SB1.D_E_L_E_T_ = '' "               
cQuery += " and   SB1.B1_FILIAL = '"+ XFilial('SB1') + "'
cQuery += " and   SB2.B2_FILIAL = '"+ XFilial('SB2') + "'
cQuery += " and   SD3.D3_FILIAL = '"+ XFilial('SD3') + "' 
cQuery += " and   SD3.D3_EMISSAO >=	'" + DToS(MV_PAR01) + "'"
cQuery += " and   SD3.D3_EMISSAO <=	'" + DToS(MV_PAR02) + "'"
//cQuery += " and   SB1.B1_COD     >=	'" + MV_PAR03 + "'"
//cQuery += " and   SB1.B1_COD     <=	'" + MV_PAR04 + "'"
cQuery += " and   SB1.B1_COD    = SB2.B2_COD "
cQuery += " and   SB2.B2_FILIAL = SD3.D3_FILIAL "
cQuery += " and   SB2.B2_COD    = SD3.D3_COD "
cQuery += " and   SD3.D3_CF     = 'RE0'  " 
cQuery += " and   SD3.D3_ESTORNO  <> 'S'  " 
cQuery += " and   SD3.D3_LOCAL  = '01'   "
cQuery += " and   SB2.B2_LOCAL  = '01'   "
cQuery += " group by B1_COD,B1_DESC,D3_QUANT,B2_CM1  "	

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP3',.T.,.T.)     


// grava qtde e custo medio , via SD3
// se existir edita, senao cria registro  
While TMP3->(!Eof())
            
		Reclock('TRB',.T.)       
		TRB->PROD	    := TMP3->CODIGO
		TRB->DESC	    := TMP3->DESCRICAO
		TRB->CUSM	    := TMP3->CUSTO_MEDIO
//teste cq
		TRB->REQQ	    := TMP3->QTD_REQ
		TRB->REQV	    := TMP3->TOT_REQ

		TRB->(MsUnlock())            

	TMP3->(DbSkip())        
EndDo      



//// Registros para a seção Total Consumo Via Vendas
Iif(Select("TMP2") > 0, TMP2->(DbCloseArea()),)
											
cQuery := " Select SL2.L2_PRODUTO,SUM(SL2.L2_QUANT) QTDEPDV, Sum(SL2.L2_QUANT * SB2.B2_CM1) CMPDV,SB2.B2_CM1,SB1.B1_DESC     "    
cQuery += " FROM " + RetSqlName("SL1") + " SL1, " + RetSqlName("SL2") + " SL2, " + RetSqlName("SB2") + " SB2, " + RetSqlName("SB1") + " SB1 "
cQuery += " where SL1.D_E_L_E_T_ = '' " 
cQuery += " and   SL2.D_E_L_E_T_ = '' "          
cQuery += " and   SB2.D_E_L_E_T_ = '' "     
cQuery += " and   SB1.D_E_L_E_T_ = '' "
cQuery += " and   SL1.L1_FILIAL = '"+ XFilial('SL1') + "'
cQuery += " and   SL1.L1_EMISSAO >=	'" + DToS(MV_PAR01) + "'"
cQuery += " and   SL1.L1_EMISSAO <=	'" + DToS(MV_PAR02) + "'" 				
cQuery += " and   SB1.B1_COD     >=	'" + MV_PAR03 + "'"
cQuery += " and   SB1.B1_COD     <=	'" + MV_PAR04 + "'"
cQuery += " and   SL1.L1_FILIAL = SL2.L2_FILIAL "
cQuery += " and   SL1.L1_NUM    = SL2.L2_NUM "   
cQuery += " and   SL2.L2_FILIAL     = SB2.B2_FILIAL "
cQuery += " and   SL2.L2_PRODUTO    = SB2.B2_COD "       
//cQuery += " and   SL2.L2_FILIAL     = SB1.B1_FILIAL "
cQuery += " and   SL2.L2_PRODUTO    = SB1.B1_COD "       
cQuery += " and   SB2.B2_LOCAL      = '01'   "           
cQuery += " Group by L2_PRODUTO,L2_QUANT,B2_CM1,B1_DESC "                

		
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP2',.T.,.T.)   

While TMP2->(!Eof())
            
    U_VldStr(TMP2->L2_PRODUTO)//// verifica se tem estrutura e se existir carrega array     
                                          	
	If Len(aStru) > 0
		                                              
		 For nX:=1 To Len(aStru)
			_cComp   := aStru[nX,3]
			_nQuant  := aStru[nX,4]
			
			SB2->(dbSetOrder(1))
			SB2->(dbSeek(xFilial("SB2") + _cComp))
			
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + _cComp))
			 
		    _QtdPDV := (TMP2->QTDEPDV * _nQuant)
//			_VlrPDV := ((TMP2->CMPDV   * _nQuant) * SB2->B2_CM1)                  			
			_VlrPDV := ((TMP2->QTDEPDV * _nQuant) * SB2->B2_CM1)
//			_VlrPDV := ((_QtdPDV   * _nQuant) * SB2->B2_CM1)
						 
			/// grava qtde e custo medio considerando a estrutura  
			/// se existir edita, senao cria registro
	        If TRB->(!DbSeek( _cComp ))
			 	RecLock('TRB', .T.)   
			 	TRB->PROD	    := _cComp
				TRB->DESC	    := SB1->B1_DESC
				TRB->CUSM	    := SB2->B2_CM1	
//testecq
//				TRB->REQQ	    := _QtdPDV //trazer o consumo quantidade requisitado
//				TRB->REQV	    := _VlrPDV //trazer o valor requisitado
				TRB->VENQ	    := _QtdPDV
				TRB->VENV	    := _VlrPDV

				TRB->(MsUnlock())
			Else
				RecLock('TRB', .F.)   
//testecq
//				TRB->REQQ	    := TRB->REQQ + _QtdPDV 
//				TRB->REQV	    := TRB->REQV + _VlrPDV
				TRB->VENQ	    := TRB->VENQ + _QtdPDV
				TRB->VENV	    := TRB->VENV + _VlrPDV

				TRB->(MsUnlock())
			Endif	       
	 
		 Next nX 
		  
/*	else///quando nao tem estrutura 	     
        /// grava qtde e custo medio , via PDV mesmo   
        // se existir edita, senao cria registro
        If TRB->(!DbSeek( TMP2->L2_PRODUTO )) 
		 	RecLock('TRB', .T.)     
		 	TRB->PROD	    := TMP2->L2_PRODUTO 
			TRB->DESC	    := TMP2->B1_DESC
			TRB->CUSM	    := TMP2->B2_CM1			
//testecq
//			TRB->REQQ	    := TMP2->QTDEPDV 
//			TRB->REQV	    := TMP2->CMPDV
			TRB->VENQ	    := TMP2->QTDEPDV 
			TRB->VENV	    := TMP2->CMPDV

			TRB->(MsUnlock())
		Else
			RecLock('TRB', .F.)   
//testecq
//			TRB->REQQ	    := TRB->REQQ + TMP2->QTDEPDV 
//			TRB->REQV	    := TRB->REQV + TMP2->CMPDV
			TRB->VENQ	    := TRB->VENQ + TMP2->QTDEPDV 
			TRB->VENV	    := TRB->VENV + TMP2->CMPDV


			TRB->(MsUnlock())
		Endif	       		            
*/  Endif       



	TMP2->(DbSkip())        
EndDo      


/// laço para SZ2 - Vendas em PDV sem Cupom Fiscal)  - 
/// grava qtde e custo medio considerando a estrutura  
/// se existir edita, senao cria registro
Iif(Select("TMP1") > 0, TMP1->(DbCloseArea()),)
											
cQuery := " Select SZ2.Z2_PRODUTO,SZ2.Z2_QUANT,SUM(SZ2.Z2_QUANT * SB2.B2_CM1) Z2VALOR ,SB2.B2_CM1,SB1.B1_DESC       "    
cQuery += " FROM " + RetSqlName("SZ2") + " SZ2, " + RetSqlName("SB2") + " SB2, " + RetSqlName("SB1") + " SB1 " 
cQuery += " where SB2.D_E_L_E_T_ = '' " 
cQuery += " and   SZ2.D_E_L_E_T_ = '' " 
cQuery += " and   SB1.D_E_L_E_T_ = '' " 
cQuery += " and   SB2.B2_FILIAL = '"+ XFilial('SB2') + "'
cQuery += " and   SB2.B2_FILIAL = SZ2.Z2_FILIAL "
cQuery += " and   SB2.B2_COD    = SZ2.Z2_PRODUTO "   
//cQuery += " and   SZ2.Z2_FILIAL     = SB1.B1_FILIAL "
cQuery += " and   SZ2.Z2_PRODUTO    = SB1.B1_COD "     
cQuery += " and   SZ2.Z2_DATA >=	'" + DToS(MV_PAR01) + "'"
cQuery += " and   SZ2.Z2_DATA <=    '" + DToS(MV_PAR02) + "'" 				
cQuery += " and   SZ2.Z2_PDV  >= 	'" + MV_PAR05 + "'"
cQuery += " and   SZ2.Z2_PDV  <= 	'" + MV_PAR06 + "'"
cQuery += " and   SB1.B1_COD     >=	'" + MV_PAR03 + "'"
cQuery += " and   SB1.B1_COD     <=	'" + MV_PAR04 + "'"
cQuery += " Group by Z2_PRODUTO,Z2_QUANT,B2_CM1,B1_DESC"                
		
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP1',.T.,.T.)   

While TMP1->(!Eof())
            
    U_VldStr(TMP1->Z2_PRODUTO)//// verifica se tem estrutura e se existir carrega array     
                                          	
	If Len(aStru) > 0
		 _QtdPDV := 0 
		 _VlrPDV := 0 
		                                              
		 For nX:=1 To Len(aStru)
			_cComp   := aStru[nX,3]
			_nQuant  := aStru[nX,4]
			
			SB2->(dbSetOrder(1))
//			SB2->(dbSeek(xFilial("SB1") + _cComp)) 
			SB2->(dbSeek(xFilial("SB2") + _cComp)) 
			
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + _cComp))
			 
		    _QtdPDV += (TMP1->Z2_QUANT * _nQuant)
			_VlrPDV += (TMP1->Z2VALOR  * _nQuant) * SB2->B2_CM1                  			
			 
			/// grava qtde e custo medio considerando a estrutura  
			/// se existir edita, senao cria registro
	        If TRB->(!DbSeek( _cComp )) 
			 	RecLock('TRB', .T.)    
			 	TRB->PROD	    := _cComp
				TRB->DESC	    := SB1->B1_DESC
				TRB->CUSM	    := SB2->B2_CM1	
				TRB->VENQ	    := _QtdPDV
				TRB->VENV	    := _VlrPDV
				TRB->(MsUnlock())
			Else
				RecLock('TRB', .F.)   
				TRB->VENQ	    := TRB->VENQ + _QtdPDV 
				TRB->VENV	    := TRB->VENV + _VlrPDV
				TRB->(MsUnlock())
			Endif	       
	 
		 Next nX 
	Endif               
    
	TMP1->(DbSkip())        
EndDo      



/// laço para SB7 - digitacao do inventario
/// grava qtde e custo medio , via SB7 mesmo
/// se existir edita, senao cria registro   
Iif(Select("TMP4") > 0, TMP4->(DbCloseArea()),)
											
cQuery := " Select SB7.B7_COD,SB7.B7_QUANT,SUM(SB7.B7_QUANT * SB2.B2_CM1) B7VALOR ,SB2.B2_CM1,SB1.B1_DESC     "    
cQuery += " FROM " + RetSqlName("SB7") + " SB7, " + RetSqlName("SB2") + " SB2, "  + RetSqlName("SB1") + " SB1 " 
cQuery += " where SB2.D_E_L_E_T_ = '' " 
cQuery += " and   SB7.D_E_L_E_T_ = '' " 
cQuery += " and   SB1.D_E_L_E_T_ = '' " 
cQuery += " and   SB7.B7_FILIAL = '"+ XFilial('SB7') + "'
cQuery += " and   SB2.B2_FILIAL = SB7.B7_FILIAL "
cQuery += " and   SB2.B2_COD    = SB7.B7_COD "  
//cQuery += " and   SB2.B2_FILIAL = SB1.B1_FILIAL "
cQuery += " and   SB2.B2_COD    = SB1.B1_COD "  
cQuery += " and   SB7.B7_DATA   >=	'" + DToS(MV_PAR01) + "'"
cQuery += " and   SB7.B7_DATA   <=  '" + DToS(MV_PAR02) + "'" 				
cQuery += " and   SB1.B1_COD     >=	'" + MV_PAR03 + "'"
cQuery += " and   SB1.B1_COD     <=	'" + MV_PAR04 + "'"
cQuery += " and   SB7.B7_XCC     >=	'" + MV_PAR05 + "'"   //testecq
cQuery += " and   SB7.B7_XCC     <=	'" + MV_PAR06 + "'"   //testecq
cQuery += " and   SB2.B2_LOCAL  <>	'01'"       // testecq
cQuery += " Group by B7_COD,B7_QUANT,B2_CM1,B1_DESC"                
		
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP4',.T.,.T.)        

While TMP4->(!Eof())
            
        If TRB->(!DbSeek( TMP4->B7_COD )) 
		 	RecLock('TRB', .T.)    
		 	TRB->PROD	    := TMP4->B7_COD 
			TRB->DESC	    := TMP4->B1_DESC
			TRB->CUSM	    := TMP4->B2_CM1	
			TRB->ESTQ	    := TMP4->B7_QUANT 
			TRB->ESTV	    := TMP4->B7VALOR
			TRB->(MsUnlock())
		Else
			RecLock('TRB', .F.)   
			TRB->ESTQ	    := TRB->ESTQ + TMP4->B7_QUANT 
			TRB->ESTV	    := TRB->ESTV + TMP4->B7VALOR
			TRB->(MsUnlock())
		Endif	      		     
 
 
	TMP4->(DbSkip())        
EndDo      

/// diferença antes do inventario
/// diferença pos inventario
TRB->(DbGoTop())
While TRB->(!Eof())
                    
    RecLock('TRB', .F.)   
	TRB->DIFAIQ	    := TRB->REQQ - TRB->VENQ
	TRB->DIFAIV	    := TRB->REQV - TRB->VENV
	TRB->DIFPIQ	    := TRB->DIFAIQ - TRB->ESTQ 
	TRB->DIFPIV	    := TRB->DIFAIV - TRB->ESTV	
	TRB->(MsUnlock())

	TRB->(DbSkip())        
EndDo      

TRB->(DbGoTop())

Return

/*
{Protheus.doc} VldStr 
Seleciona Dados
@class N/A
@from  N/A
@param N/A
@attrib N/A
@protected 
@author Alexandre Felicio
@version 11.8
@since 05/12/2014
@return N/A
@sample VldStr
@obs N/A
@project 
@menu N/A
@history N/A
*/ 
User Function VldStr(_B1Cod) 
Local lRet          := .T.    
Local _B1Cod
Local _B1CodC       := '' 
Private nEstru 		:= 0
Private aEstrutura 	:= {}
      
_B1CodC := IIf( !Empty(_B1Cod), _B1Cod ,M->Z2_PRODUTO)

aStru := Estrut(_B1CodC) 

lRet := IIf(Len(aStru) = 0,.F.,.T.) 
     
If !lRet .AND. Empty(_B1Cod)
    MsgAlert("Produto sem estrutura cadastrada!","Vendas PDV" ) 
Endif

return(lRet)


User Function AXGJPREL()

AxCadastro('SZ2','Venda sem cupom', '', '')

Return

#Include 'Protheus.ch'
#include "TopConn.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GJLOJE01
Rotina que gera e estorna ordem de produção
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function GJLOJE01(nOpc)
Local cQry 		:= ""
Local cTab  		:= ""
Local cChaveSD2	:= ""
Local cMsgLog		:= ""
Local cFiltro		:= ""
LOCAL aTexto		:= {}

IF nOpc == 3  //Inclusão do cupom

	cChaveSD2:= xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
	DbSelectArea("SD2")
	DbSetOrder(3)
	If SD2->(DbSeek(cChaveSD2))
		While !SD2->(Eof()) .AND. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)==cChaveSD2	
			//Executa rotina que gera e aponta a ordem de produção
			U_GJ12E01GOP(nOpc,SL1->L1_NUMCFIS,SL1->L1_ESTACAO,cMsgLog)
		SD2->(DbSkip())
		End	
	ENDIF 	
		
ELSEIF nOpc == 5 //Exclusão do cupom

	cTab  	:= GetNextAlias()
	
	BeginSql Alias cTab	
		SELECT SD2.R_E_C_N_O_ AS RECSD2 
				,COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),D2_XLOGOP )),'') AS D2_XLOGOP
		FROM %TABLE:SD2% SD2 
		WHERE D2_FILIAL=%xfilial:SD2%
		AND D2_DOC=%exp:SL1->L1_DOC%
		AND D2_XNFCE=%exp:SL1->L1_NUMCFIS%  
		AND SD2.D_E_L_E_T_=''
	EndSql 
	
	//GETLastQuery()[2]
	(cTab)->(dbSelectArea((cTab)))
	(cTab)->(dbGoTop())
	While (cTab)->(!EOF())	
		DbSelectArea("SD2")
		SD2->(DBGOTO((cTab)->RECSD2))
		IF SD2->(!EOF())		
			aTexto := StrTokArr(ALLTRIM((cTab)->D2_XLOGOP),CRLF,.T.)	
			AEVAL(aTexto,{|x| cMsgLog+=IIF(empty(x),nil,x)+CRLF })				
			//Executa rotina que exclui e estorna apontamento da ordem de produção
			U_GJ12E01GOP(nOpc,SL1->L1_NUMCFIS,SL1->L1_ESTACAO,@cMsgLog)
			RECLOCK("SD2",.F.) 
				SD2->D2_XLOGOP:= cMsgLog
			MSUNLOCK()				
		ENDIF
	(cTab)->(DBSKIP())
	END
	(cTab)->(DBCLOSEAREA())

ELSEIF nOpc == 7 // Reprocessamento

	cTab  	:= GetNextAlias()

	IF MV_PAR05==4
		cFiltro+="% D2_XAUTOP IN ('1','2','4')%"		
	ELSE
		cFiltro+="% D2_XAUTOP ='"+ CVALTOCHAR(MV_PAR05) +"'%"
	ENDIF		
	
	BeginSql Alias cTab	
		SELECT SD2.R_E_C_N_O_ AS RECSD2
				,D2_XNFCE,D2_XAUTOP
				,L1_ESTACAO
				,COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),D2_XLOGOP )),'') AS D2_XLOGOP
		FROM %TABLE:SD2% SD2 
		INNER JOIN %TABLE:SL1% SL1 ON L1_FILIAL=%xfilial:SD2% 
			AND L1_NUMCFIS=D2_XNFCE
			AND L1_DOC=D2_DOC
			AND SL1.D_E_L_E_T_=''
		WHERE D2_FILIAL=%xfilial:SD2%
		AND D2_XNFCE BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		AND D2_EMISSAO BETWEEN %exp:DTOS(MV_PAR03)% AND %exp:DTOS(MV_PAR04)%
		AND %exp:cFiltro%
		AND D2_XNFCE!=''  
		AND SD2.D_E_L_E_T_=''
	EndSql 
	//GETLastQuery()[2]
	(cTab)->(dbSelectArea((cTab)))
	(cTab)->(dbGoTop())
	While (cTab)->(!EOF())	
		cMsgLog:=""
		DbSelectArea("SD2")
		SD2->(DBGOTO((cTab)->RECSD2))
		IF SD2->(!EOF())				
			IF (cTab)->D2_XAUTOP$"1,4"
				aTexto := StrTokArr(ALLTRIM((cTab)->D2_XLOGOP),CRLF,.T.)	
				AEVAL(aTexto,{|x| cMsgLog+=IIF(empty(x),nil,x)+CRLF })				
				//Executa rotina que gera e aponta a ordem de produção
				U_GJ12E01GOP(3,(cTab)->D2_XNFCE,(cTab)->L1_ESTACAO,@cMsgLog)
			ELSEIF (cTab)->D2_XAUTOP == "2"
				aTexto := StrTokArr(ALLTRIM((cTab)->D2_XLOGOP),CRLF,.T.)			
		    	AEVAL(aTexto,{|x| cMsgLog+=IIF(empty(x),nil,x)+CRLF })
		    	DBSELECTAREA("SC2")
		    	SC2->(DbSetOrder(1)) // FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
		    	IF SC2->(DbSeek(xFilial("SC2")+SD2->D2_OP))				    				
					lRetMOP:= U_GJ12E01MOP(3,SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN),@cMsgLog)
					RECLOCK("SD2",.F.)
						SD2->D2_XAUTOP	:= IF(lRetMOP,"3","2") 
						SD2->D2_XLOGOP	:= cMsgLog
					MSUNLOCK()	
				ENDIF					
			ENDIF
		ENDIF
	(cTab)->(DBSKIP())
	END
	(cTab)->(DBCLOSEAREA())	
	
ENDIF

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GJ12E01GOP
Rotina que gera e estorna ordem de produção
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER Function GJ12E01GOP(nOpc,cNumNfce,cEstacao,cMsgLog)
Local aAreaSF2		:= SF2->(GetArea())
Local aAreaSD2		:= SD2->(GetArea())
Local cNumOP			:= "" 
Local aRot650			:= {}
Local lManutOP		:= .T.
Local lRetMOP			:= .T.
Private cLocSec		:= ""
Private lMsHelpAuto 	:= .T.
Private lMsErroAuto 	:= .F.
Private lAutoErrNoFile:= .T.
		
IF nOpc == 3
	
	DBSELECTAREA("SZ3")
	SZ3->(DBSETORDER(1))
	SZ3->(DBSEEK(XFILIAL("SZ3")+cEstacao))
	cLocSec:= SZ3->Z3_LOCSEC
	IF EMPTY(cLocSec)
		cMsgLog += "LJGrvBatch: Filial "+ CFILANT +". Armazém secundário não informado no campo Z3_LOCSEC da estação: "+cEstacao+CRLF
		lManutOP:= .F.							
	ENDIF
	
	//Checa se a TES atulializa estoque
	DBSELECTAREA("SF4")
	SF4->(DBSETORDER(1))		
	If SF4->(DBSEEK(XFILIAL("SF4")+SD2->D2_TES))
		IF SF4->F4_ESTOQUE=="N"
			cMsgLog +=  "LJGrvBatch: Filial "+ CFILANT +". A TES "+SD2->D2_TES+" não atualiza estoque."+CRLF			
			lManutOP:= .F.			
		ENDIF
	ENDIF
		
	//Checa se o produto tem estrutura
	DBSELECTAREA("SG1")
	SG1->(DBSETORDER(1))		
	If !SG1->(DBSEEK(XFILIAL("SG1")+SD2->D2_COD))
		cMsgLog +=  "LJGrvBatch: Filial "+ CFILANT +". Produto sem estrutura."+CRLF		
		lManutOP:= .F.				
	ENDIF
	
	// Adicionado por Felipe Queiroz	
	//Checa se o lançamento da OP é On-Line
	If GetMv("MV_GJPOPON")=="N" .AND. !ISINCALLSTACKS("U_GJLOJM01")
		cMsgLog +=  "LJGrvBatch: Filial "+ CFILANT +". Geração de OP Off-Line."+CRLF		
		lManutOP:= .F.				
	ENDIF
	
ELSEIF nOpc == 5
	IF EMPTY(SD2->D2_OP)
		lManutOP:= .F.	
	ENDIF	
ENDIF

		
lMsErroAuto 	:= .F.

IF lManutOP
	IF nOpc == 3
		Pergunte("MTA650",.F.)
		MV_PAR02 := 2
		MV_PAR03 := cLocSec
		MV_PAR08 := 1
		
		cNumOP:= GetNumSc2()
		ConfirmSX8()	

		aRot650  := {  {'C2_FILIAL'   	, xFilial("SC2")   	, NIL},;
		                {'C2_PRODUTO'  	, SD2->D2_COD  		, NIL},;          
		                {'C2_NUM'      	, cNumOP          	, NIL},;
		                {'C2_LOCAL'    	, SD2->D2_LOCAL		, NIL},;
		                {'C2_QUANT'    	, SD2->D2_QUANT    		, NIL},;          
		                {'C2_ITEM'     	, "01"             	, NIL},;          
		                {'C2_SEQUEN'   	, "001"             	, NIL},;				                
		                {'C2_TPOP'   	, "F"             	, NIL},;
		                {'C2_DATPRI'   	, DATE()		, NIL},;
		                {'C2_DATPRF'   	, DATE() 			, NIL},;
		                {'C2_EMISSAO'  	, SD2->D2_EMISSAO		, NIL},;
		                {'C2_XNFCE'   	, cNumNfce   			, NIL},;
		                {'GERAOPI'   	, "S"   				, NIL},;				                
		                {'AUTEXPLODE' 	, "S"             	, NIL}}
		
		cNumOP:= cNumOP+"01"+"001"                
		                			
	ELSEIF	nOpc == 5

		cNumOP:= TRIM(SD2->D2_OP)
			
    	DBSELECTAREA("SC2")
    	SC2->(DbSetOrder(1)) // FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
    	SC2->(DbSeek(xFilial("SC2")+cNumOP))			
		
		//Estorna apontamento de produção
		lRetMOP:= U_GJ12E01MOP(nOpc,SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN),@cMsgLog)		                

		aRot650  := {  {'C2_FILIAL'   	, SC2->C2_FILIAL   	, NIL},;
		                {'C2_PRODUTO'  	, SC2->C2_PRODUTO  	, NIL},;          
		                {'C2_NUM'      	, SC2->C2_NUM        , NIL},;          
		                {'C2_QUANT'    	, SC2->C2_QUANT		, NIL},;
		                {'C2_ITEM'     	, SC2->C2_ITEM       , NIL},;          
		                {'C2_SEQUEN'   	, SC2->C2_SEQUEN   	, NIL},;
		                {'GERASC'   	, "N"   				, NIL}}		
	
	ENDIF
	
	IF !EMPTY(aRot650)
		MSEXECAUTO({|x,Y| MATA650(x,Y)},aRot650,nOpc)
	
		IF !lMsErroAuto			
			IF nOpc == 3
				cMsgLog += "LJGrvBatch: Filial "+ CFILANT +". Ordem de produção "+cNumOP+" gerada com sucesso." + CRLF
			
				lRetMOP:= U_GJ12E01MOP(nOpc,xfilial("SC2")+cNumOP,@cMsgLog) //SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN)
				 
				RECLOCK("SD2",.F.)
					SD2->D2_XAUTOP	:= IF(lRetMOP,"3","2") 
					SD2->D2_OP			:= cNumOP		//cNumOP+"01"+"001"
					SD2->D2_XNFCE		:= cNumNfce
					SD2->D2_XLOGOP	:= cMsgLog
				MSUNLOCK()		
			ELSEIF nOpc == 5	
				cMsgLog += "LJGrvBatch: Filial "+ CFILANT +". Ordem de produção "+cNumOP+" excluida com sucesso." + CRLF															
			ENDIF					  				    
		ELSE
			cMsgLog += GJ12E01MSG(nOpc,GetAutoGRLog(),SC2->C2_PRODUTO)		
			IF nOpc == 3							
				RollBackSx8()
				RECLOCK("SD2",.F.)
					SD2->D2_XAUTOP	:= "4"
					SD2->D2_XNFCE		:= cNumNfce
					SD2->D2_XLOGOP	:= cMsgLog 
				MSUNLOCK()
			ELSEIF nOpc == 5
				RECLOCK("SD2",.F.)
					SD2->D2_XLOGOP	:= cMsgLog 
				MSUNLOCK()			
			ENDIF
		ENDIF			
	ENDIF
ELSEIF nOpc == 3
	RECLOCK("SD2",.F.)
		SD2->D2_XAUTOP	:= "1"
		SD2->D2_XNFCE		:= cNumNfce
		SD2->D2_XLOGOP	:= cMsgLog
	MSUNLOCK()				
ENDIF

CONOUT(cMsgLog)
		
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GJ12E01MOP
Rotina que gera e estorna apontamento de produção
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function GJ12E01MOP(nOpc,cChaveSC2,cMsgLog)
Local aArea			:= GetArea()
Local cNumOP			:= "" 
Local cTmProd			:= SUPERGETMV("MV_GJPPRD",.T.,"")
Local aRot250			:= {}
Local lRet				:= .T.
PRIVATE __nRecSd3    := 0

lMsErroAuto 	:= .F.

DbSelectArea("SC2")
DbSetOrder(1)
If SC2->(DbSeek(cChaveSC2))
	While !SC2->(Eof()) .AND. SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN)==cChaveSC2
		cNumOP	:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN		
		IF nOpc == 3	// Apontamento de produção			
			aRot250:= {{'D3_OP'   		, cNumOP   			, NIL},;
			           {'D3_TM'  		, cTmProd			, NIL},;
			           {'D3_EMISSAO'  	, SC2->C2_EMISSAO	, NIL},;				
			           {'D3_LOCAL'  	, SB1->B1_LOCPAD	, NIL}}

		ELSEIF	nOpc == 5	// Estorna apontamento de produção	
		
			DBSELECTAREA("SD3")
			SD3->(DBSETORDER(1))
			SD3->(DBSEEK(XFILIAL("SD3")+AVKEY(cNumOP,"D3_OP")+AVKEY(SC2->C2_PRODUTO,"D3_COD")))
			__nRecSd3:= SD3->(RECNO())
			IF SD3->D3_ESTORNO!="S"
				aRot250:={	{'D3_EMISSAO'   	,SD3->D3_EMISSAO   	, NIL},;
							{'D3_TM'   		, SD3->D3_TM   		, NIL},;
							{'D3_COD'  		, SD3->D3_COD			, NIL},;
							{'D3_UM'   		, SD3->D3_UM   		, NIL},;
							{'D3_QUANT'   	, SD3->D3_QUANT   	, NIL},;
							{'D3_OP'   		, SD3->D3_OP   		, NIL},;			          	
				          	{'D3_LOCAL'  		, SD3->D3_LOCAL		, NIL},;
				          	{'D3_DOC'  		, SD3->D3_DOC			, NIL},;
				          	{'D3_NUMSEQ'  	, SD3->D3_NUMSEQ		, NIL},; //{'ABREOP  '  		, "S"			  		, NIL},;
				          	{'INDEX'  			, 3			  			, NIL}}
			ENDIF          			          		           			           		
		ENDIF
		
		IF !EMPTY(aRot250) 
			// MV_PRODAUT esta igual a .F. 
			// MV_REQAUT esta igual a T.
			MSEXECAUTO({|x,Y| Mata250(x,Y)},aRot250,nOpc)
		
			IF !lMsErroAuto
				IF nOpc == 3
					cMsgLog+= "LJGrvBatch: Filial "+ CFILANT +". Apontamento de produção realizado com sucesso." + CRLF
				ELSEIF nOpc == 5
					cMsgLog+= "LJGrvBatch: Filial "+ CFILANT +". Apontamento de produção estornado com sucesso." + CRLF
				ENDIF				    
			ELSE	
				lRet:= .F.
				cMsgLog+= GJ12E01MSG(IIF(nOpc==3,4,6),GetAutoGRLog(),SC2->C2_PRODUTO) + CRLF			
			ENDIF
		ELSEIF nOpc == 3
			lRet:= .F.					
		ENDIF
		
	SC2->(DbSkip())
	End	
ENDIF 

RestArea(aArea)
RETURN lRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GJ12E01MSG
Tratamento da mensagem de erro do execauto
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC Function GJ12E01MSG(nOpc,aBlocoMsg,cProdut)
Local lHelp   := .F.
Local lTabela := .F.
Local lLinInv := .F.
Local lLinItem:= .F.
Local cLinha  := ""
Local aRet    := {}
Local cRet    := ""
Local nI      := 0
local nTotLin	:= LEN(aBlocoMsg)

IF nOpc == 3
	cRet:= "LJGrvBatch: Filial "+ CFILANT +". Não foi possivel gerar a Ordem de produção:" + CRLF
ELSEIF nOpc == 4
	cRet:= "LJGrvBatch: Filial "+ CFILANT +". Não foi possivel encerrar o apontamento de produção:" + CRLF	
ELSEIF nOpc == 5
	cRet:= "LJGrvBatch: Filial "+ CFILANT +". Não foi possivel excluir a Ordem de produção: " + CRLF
ELSEIF nOpc == 6
	cRet:= "LJGrvBatch: Filial "+ CFILANT +". Não foi possivel estornar o apontamento de produção:" + CRLF	
ENDIF	

IF nTotLin <= 10
	For nI := 1 to nTotLin
		cLinha  := UPPER( aBlocoMsg[nI] )
		
		If '<'$cLinha
			cLinha:= StrTran(cLinha,'<','(')
		EndIf

		If '>'$cLinha
			cLinha:= StrTran(cLinha,'>',')')
		EndIf
		
		If '&'$cLinha
			cLinha:= StrTran(cLinha,'&',' ')
		EndIf						
		
		aAdd(aRet,cLinha)
	Next
ELSE
	For nI := 1 to nTotLin
		cLinha  := UPPER( aBlocoMsg[nI] )    
		cLinha  := STRTRAN( cLinha,CHR(13), " " )
		cLinha  := STRTRAN( cLinha,CHR(10), " " )  
		
		lHelp   	:= .F.
		lTabela 	:= .F.
		lLinInv	:= .F.
		lLinItem	:= .F.
			
		If SUBS( cLinha, 1, 4 ) == 'HELP'
			lHelp := .T.
		EndIf
		
		If SUBS( cLinha, 1, 6 ) == 'TABELA'
			lTabela := .T.
		EndIf
	
		If '< -- INVALIDO'$cLinha
			cLinha:= StrTran(cLinha,'< -- INVALIDO','( INVALIDO )')
			lLinInv	:= .T.
		EndIf          
		
		If 'ERRO NO ITEM'$cLinha
			lLinItem:= .T.
		EndIf
			
		If  lHelp .or. lTabela .or. lLinInv .or. lLinItem
			
			If '<'$cLinha
				cLinha:= StrTran(cLinha,'<','(')
			EndIf
	
			If '>'$cLinha
				cLinha:= StrTran(cLinha,'>',')')
			EndIf
			
			If '&'$cLinha
				cLinha:= StrTran(cLinha,'&',' ')
			EndIf						
				
			aAdd(aRet,cLinha)
		EndIf                   
	Next
ENDIF

For nI := 1 to Len(aRet)
	cRet += "LJGrvBatch: Filial "+ CFILANT +". "+ aRet[nI] +CRLF
Next

Return cRet 
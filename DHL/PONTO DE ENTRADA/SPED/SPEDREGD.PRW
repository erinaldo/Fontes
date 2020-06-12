#include "rwmake.ch"
#include "Topconn.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SPEDREGD บAutor  ณTOTVS               บ Data ณ  01/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para manipular arquivo de Trabalho        บฑฑ
ฑฑบ          ณ Usado na gera็ใo do SPED FISCAL (EFD)                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SPEDREGD()
Local	cAlias    := PARAMIXB[1]
Local   aReg0150  := {} //Cadastro do Participante
Local   aReg0200  := {} //Cadastro do Produto
Local	aRegD100  := {}
Local	aRegD110  := {}
Local	aRegD120  := {}
Local	aRegD190  := {}
//Local   nRelac    := 0
Local   nRelac    := "NFST000000000"
Local 	aRetPart  := {}

aWizard:={}

If File("SPEDFIS"+cempant+cfilant+".CFP")
	xMagLeWiz ("SPEDFIS"+cempant+cfilant, @aWizard, .T.)
ElseIf File("SPEDFIS"+cfilant+".CFP")
	xMagLeWiz ("SPEDFIS"+cfilant, @aWizard, .T.)
EndIf
//xWizard ("SPEDFIS"+cfilant, @aWizard, .T.)

If Empty(Len(aWizard))
	Return()
EndIf

Private	dDataDe   := stod(aWizard[1][1])
Private	dDataAte  := stod(aWizard[1][2])
Private cFilDe    :=	aWizard[2][2]
Private cFilAte   :=	aWizard[2][3]
Private	cAliasSFT := "SFT"
//Private cReg1600   :=	aWizard[5][7] //Gerar Registro 1600 (1 - Sim / 2 - Nใo)

DbSelectArea (cAliasSFT)
(cAliasSFT)->(DbSetOrder (2))
cAliasSFT	:=	GetNextAlias()

cFiltro := "% SFT.FT_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND %"

cCampos := "%"
If SFT->(FieldPos("FT_CHVNFE")) > 0
	cCampos += ", SFT.FT_CHVNFE"
Endif
If SFT->(FieldPos("FT_PAUTPIS")) > 0
	cCampos += ", SFT.FT_PAUTPIS"
Endif
If SFT->(FieldPos("FT_PAUTCOF")) > 0
	cCampos += ", SFT.FT_PAUTCOF"
Endif
cCampos += "%"

BeginSql Alias cAliasSFT
	
	COLUMN FT_EMISSAO AS DATE
	COLUMN FT_ENTRADA AS DATE
	COLUMN FT_DTCANC AS DATE
	
	SELECT
	SFT.FT_FILIAL,SFT.FT_TIPOMOV,SFT.FT_SERIE,SFT.FT_NFISCAL,SFT.FT_CLIEFOR,SFT.FT_LOJA,SFT.FT_ITEM,SFT.FT_PRODUTO,
	SFT.FT_ENTRADA,SFT.FT_NRLIVRO,SFT.FT_CFOP,SFT.FT_ESPECIE,SFT.FT_TIPO,SFT.FT_EMISSAO,SFT.FT_DTCANC,SFT.FT_FORMUL,
	SFT.FT_ALIQPIS,SFT.FT_VALPIS,SFT.FT_ALIQCOF,SFT.FT_VALCOF,SFT.FT_VALCONT,SFT.FT_BASEICM,SFT.FT_VALICM,SFT.FT_ISSST,
	SFT.FT_BASERET,SFT.FT_ICMSRET,SFT.FT_VALIPI,SFT.FT_ISENICM,SFT.FT_QUANT,SFT.FT_DESCONT,SFT.FT_TOTAL,SFT.FT_FRETE,
	SFT.FT_SEGURO,SFT.FT_DESPESA,SFT.FT_OUTRICM,SFT.FT_BASEIPI,SFT.FT_ISENIPI,SFT.FT_OUTRIPI,SFT.FT_ICMSCOM,SFT.FT_RECISS,
	SFT.FT_BASEIRR,SFT.FT_ALIQICM,SFT.FT_ALIQIPI,SFT.FT_CTIPI,SFT.FT_POSIPI,SFT.FT_CLASFIS,SFT.FT_PRCUNIT,SFT.FT_CFPS,
	SFT.FT_ESTADO,SFT.FT_CODISS,SFT.FT_ALIQIRR,SFT.FT_VALIRR,SFT.FT_BASEINS,SFT.FT_VALINS,SFT.FT_PDV,SFT.FT_ISSSUB,SFT.FT_CREDST,
	SFT.FT_ISENRET,SFT.FT_OUTRRET,SFT.FT_CONTA,SFT.FT_BASEPIS,SFT.FT_BASECOF,SFT.FT_VALPS3,SFT.FT_VALCF3,SFT.FT_PESO
	%Exp:cCampos%
	FROM
	%Table:SFT% SFT
	WHERE
	SFT.FT_FILIAL=%xFilial:SFT% AND
	SFT.FT_ENTRADA>=%Exp:DToS (dDataDe)% AND
	SFT.FT_ENTRADA<=%Exp:DToS (dDataAte)% AND
	((SFT.FT_CFOP NOT LIKE '000%' AND SFT.FT_CFOP NOT LIKE '999%') OR SFT.FT_TIPO='S') AND
	SFT.FT_ESPECIE in  ('NFST') AND
	%Exp:cFiltro%
	SFT.%NotDel%
	
	ORDER BY
	1,9,4
EndSql

DbSelectArea (cAliasSFT)
(cAliasSFT)->(DbGoTop ())
ProcRegua ((cAliasSFT)->(RecCount ()))
Do While !(cAliasSFT)->(Eof ())
	If Interrupcao(lEnd)
		Exit
	EndIf
	
	//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Tratamento para a Especie de cada documento fiscal ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
	cEspecie		:=	AModNot ((cAliasSFT)->FT_ESPECIE)		//Modelo NF

	If cEspecie$"#07" .And. "S"$(cAliasSFT)->FT_TIPOMOV
		
		IncProc("Documentos de transporte. Dia:"+Dtoc((cAliasSFT)->FT_EMISSAO)+' Doc:'+(cAliasSFT)->FT_NFISCAL)

		cSituaDoc:=	SPEDSitDoc ((cAliasSFT)->FT_TIPO, cAliasSFT)
		If !(cSituaDoc$"02#03")  //Cancelado

			If SA1->(dbSeek(xFilial('SA1')+ (cAliasSFT)->(FT_CLIEFOR + FT_LOJA)))
				aAdd(aRetPart,X_InfPartDoc('SA1'))
			EndIf			

			//REGISTRO D100: NOTA FISCAL DE SERVIวO DE TRANSPORTE (CำDIGO 07)
			aAdd(aRegD100, {})
			nPos	:=	Len (aRegD100)
			aAdd (aRegD100[nPos], "D100")	   			                    	//01 - REG
			aAdd (aRegD100[nPos], "1")	   	 			  		                //02 - IND_OPER
			aAdd (aRegD100[nPos], "0")	   		 			                    //03 - IND_EMIT
			aAdd (aRegD100[nPos], aRetPart[1][1])			  					//04 - COD_PART
			aAdd (aRegD100[nPos], cEspecie)    					             	//05 - COD_MOD
			aAdd (aRegD100[nPos], SPEDSitDoc(,"SFT" ))     						//06 - COD_SIT
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_SERIE+' ')                 	//07 - SERIE
			aAdd (aRegD100[nPos], 0)						                  	//08 - SUBSERIE
			aAdd (aRegD100[nPos], StrZero(Val((cAliasSFT)->FT_NFISCAL),6))	   	//09 - NRO_INI
			aAdd (aRegD100[nPos], "")	  										//10 - CHV_CTE
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_EMISSAO )		                //11 - DT_DOC
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_EMISSAO )		                //12 - DT_A_P
			aAdd (aRegD100[nPos], "")	  										//13 - TP_CT-e
			aAdd (aRegD100[nPos], "")	  										//14 - CHV_CTE_REF
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_VALCONT )	                 	//15 - VL_DOC
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_DESCONT )	                	//16 - VL_DESC
			aAdd (aRegD100[nPos], "2")	   		 			                    //17 - IND_FRT
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_VALCONT )	                	//18 - VL_SERV
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_BASEICM )	                	//19 - VLR BASE ICMS
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_VALICM )	   	            	//20 - VLR ICMS
			aAdd (aRegD100[nPos], (cAliasSFT)->FT_OUTRICM )	   	            	//21 - VL_NT
			aAdd (aRegD100[nPos], "")	  										//22 - COD_INF
			aAdd (aRegD100[nPos], "")	  										//23 - COD_CTA

			//REGISTRO D110: ITENS DO DOCUMENTO - NOTA FISCAL DE SERVIวOS DE TRANSPORTE (CำDIGO 07)
			aAdd(aRegD110, {})
			nPos	:=	Len (aRegD110)
			aAdd (aRegD110[nPos], "D110")   				 //01 - REG
			aAdd (aRegD110[nPos], (cAliasSFT)->FT_ITEM)  	 //02 - NUM_ITEM
			aAdd (aRegD110[nPos], (cAliasSFT)->FT_PRODUTO)   //03 - COD_ITEM
			aAdd (aRegD110[nPos], (cAliasSFT)->FT_VALCONT )  //04 - VL_SERV
			aAdd (aRegD110[nPos], 0 )	   					 //05 - VL_OUT

			//REGISTRO D120: COMPLEMENTO DA NOTA FISCAL DE SERVIวOS DE TRANSPORTE (CำDIGO 07)
			
			cCodMun := SM0->M0_CODMUN
			If Len( cCodMun ) <= 5
				cCodMun := UFCodIBGE(SM0->M0_ESTCOB) + cCodMun
			EndIf

			_aAreaSFT := GetArea()
			DbSelectArea("SD2")
			DbSetOrder(3) //FILIAL+DOC+SERIE
			If DbSeek(xFilial("SD2")+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE)
				cCodMunOri := SD2->D2_XMUNORI
				cCodMunDes := SD2->D2_XMUNDES
			EndIf
			RestArea(_aAreaSFT)

			aAdd(aRegD120, {})
			nPos	:=	Len (aRegD120)
			aAdd (aRegD120[nPos], "D120")   				 //01 - REG
			aAdd (aRegD120[nPos], iif(!Empty(cCodMunOri),cCodMunOri,cCodMun) ) 	 //02 - COD_MUN_ORIG
			aAdd (aRegD120[nPos], iif(!Empty(cCodMunDes),cCodMunDes,cCodMun) )	 //03 - COD_MUN_DEST
			aAdd (aRegD120[nPos], '' ) 						 //04 - VEIC_ID
			aAdd (aRegD120[nPos], '' )	   					 //05 - UF_ID
			
			//REGISTRO D190: REGISTRO ANALอTICO DOS DOCUMENTOS (CำDIGO 07, 08,8B, 09, 10, 11, 26, 27 e 57)
			
			aAdd(aRegD190, {})
			nPos	:=	Len (aRegD190)
			aAdd (aRegD190[nPos], "D190")   				 //01 - REG
			aAdd (aRegD190[nPos], (cAliasSFT)->FT_CLASFIS)	 //02 - CST_ICMS
			aAdd (aRegD190[nPos], (cAliasSFT)->FT_CFOP)		 //03 - CFOP
			aAdd (aRegD190[nPos], (cAliasSFT)->FT_ALIQICM )	 //04 - ALIQ_ICMS
			aAdd (aRegD190[nPos], (cAliasSFT)->FT_VALCONT )	 //05 - VL_OPR
			aAdd (aRegD190[nPos], (cAliasSFT)->FT_BASEICM )	 //06 - VL_BC_ICMS
			aAdd (aRegD190[nPos], (cAliasSFT)->FT_VALICM )	 //07 - VL_ICMS
			aAdd (aRegD190[nPos], (cAliasSFT)->FT_OUTRICM )	 //08 - VL_RED_BC
			aAdd (aRegD190[nPos], '' )	 //09 - COD_OBS
			
		EndIf
		
	EndIf

//	nRelac++
	nRelac := soma1(nRelac)

	_nRecno := TRB->(RECNO())
	TRB->(DBGOTOP())
	TRB->(DBSEEK("0150"))
	_aVerCli := {}
	Do While TRB->(!EOF()) .and. TRB->TRB_TPREG == "0150"
		If ascan(_aVerCli,{|x| x[2] == SUBSTR(TRB->TRB_CONT,7,25)}) == 0
			AADD(_aVerCli,{TRB->(RECNO()),SUBSTR(TRB->TRB_CONT,7,25)}) //		TRB->TRB_CONT
		EndIf
		TRB->(DBSKIP())
	EndDo
   	TRB->(DBGOTO(_nRecno))

	If !Empty(aRetPart)
		_cCliente := aRetPart[1,01]
		If ascan(_aVerCli,{|x| x[2] == _cCliente }) == 0
			//Gera Registro do Participante (Cliente)
			aadd(aReg0150,{"0150",;						//01-Fixo
			               aRetPart[1,01],;				//02-Codigo Participante
			               aRetPart[1,02],;				//03-Nome
			               aRetPart[1,03],;				//04-Codigo Pais
			               aRetPart[1,04],;				//05-CNPJ
			               aRetPart[1,05],;				//06-CPF
			               aRetPart[1,06],;				//07-IE
			               aRetPart[1,07],;				//08-Codigo Municipio
			               aRetPart[1,08],;				//09-Suframa
			               aRetPart[1,09],;				//10-Endere็o
			               aRetPart[1,10],;				//11-Numero
			               aRetPart[1,11],;				//12-Complemento
			               aRetPart[1,12]})				//13-Bairro
		
			GrvRegTrS (cAlias, nRelac, aReg0150) //Cliente
		EndIf
	EndIf
	
    //Verifica e Grava registro 0190 (Unidade de Medida)
	_nRecno := TRB->(RECNO())
	TRB->(DBGOTOP())
	TRB->(DBSEEK("0190"))
	_aVerUnid := {}
	aReg0190  := {}
	Do While TRB->(!EOF()) .and. TRB->TRB_TPREG == "0190"
		If ascan(_aVerUnid,{|x| x[2] == SUBSTR(TRB->TRB_CONT,7,TamSx3("B1_UM")[1]) }) == 0
			AADD(_aVerUnid,{TRB->(RECNO()),SUBSTR(TRB->TRB_CONT,7,TamSx3("B1_UM")[1])}) //		TRB->TRB_CONT
		EndIf
		TRB->(DBSKIP())
	EndDo
   	TRB->(DBGOTO(_nRecno))

	_cUnid := Posicione("SB1",1,xFilial("SB1")+((cAliasSFT)->FT_PRODUTO),"B1_UM")
	_cDesc := Posicione("SAH",1,xFilial("SAH")+_cUnid,"AH_UMRES")
	
	If ascan(_aVerUnid,{|x| x[2] == _cUnid }) == 0
	    //Gera Regitro do Unidade de Medida
		aadd(aReg0190,{"0190",;				//01-Fixo
		               _cUnid,;				//02-Unidade
		               _cDesc})				//03-Descricao
		GrvRegTrS (cAlias, _cUnid, aReg0190)
	EndIf

	//Verifica e Grava registro 0200 (Produto)
	_nRecno := TRB->(RECNO())
	TRB->(DBGOTOP())
	TRB->(DBSEEK("0200"))
	_aVerProd := {}
	Do While TRB->(!EOF()) .and. TRB->TRB_TPREG == "0200"
		If ascan(_aVerProd,{|x| x[2] == SUBSTR(TRB->TRB_CONT,7,TamSx3("B1_COD")[1]) }) == 0
			AADD(_aVerProd,{TRB->(RECNO()),SUBSTR(TRB->TRB_CONT,7,TamSx3("B1_COD")[1])}) //		TRB->TRB_CONT
		EndIf
		TRB->(DBSKIP())
	EndDo
   	TRB->(DBGOTO(_nRecno))

	_cProduto := ((cAliasSFT)->FT_PRODUTO)
	If ascan(_aVerProd,{|x| x[2] == _cProduto }) == 0
	    //Gera Regitro do Produto e Grava o registro 0200 
		aReg0200 := xReg0200(cAlias)
	EndIf
	
	GrvRegTrS (cAlias, nRelac, aRegD100)
	GrvRegTrS (cAlias, nRelac, aRegD110)
	GrvRegTrS (cAlias, nRelac, aRegD120)
	GrvRegTrS (cAlias, nRelac, aRegD190)
	aRegD100:={}
	aRegD110:={}
	aRegD120:={}
	aRegD190:={}

	(cAliasSFT)->(DbSkip ())
Enddo

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSPEDREGD  บAutor  ณMicrosiga           บ Data ณ  07/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function X_InfPartDoc(cAlsSA,dDataDe,dDataAte,cAliasSFT,lCadParti,aHistSA,lHistTab,lExtratTAF)

Local	aA1A2		:=	{}
Local	cA1A2		:=	SubStr (cAlsSA, 3, 1)
Local	cCodMun		:=	""
Local	cCmpCod		:=	""
Local	cCmpLoja	:=	""
Local	cCmpNome	:=	""
Local	cCmpTipo	:=	""
Local	cCmpCgc		:=	""                            
Local	cCmpEst		:=	""
Local	cCmpInsc	:=	""
Local	cCmpCodM	:=	""
Local	cCmpEnd		:=	""
Local	cCmpBairro	:=	""
Local	cCmpCdPais	:=	""
Local	cCmpSuframa	:=	""
Local 	cCmpInscM	:= 	""
Local	cCmpPessoa	:=	""
Local	cContCampo	:=	""
Local cCmpCompl := ""
Local	nX			:=	0
Local	aMod		:= {}
Local	aPart	    := {}
Local	lTop 		:= .F.
Local 	lConcFil	:= SuperGetMv("MV_COFLSPD",.F.,.T.)
Local 	cInscricao	:= "" 
Local	lInscPar	:= SuperGetMv("MV_INSCPAR",.F.,.T.)
Local lCmpCompEx := .F.

Default cAliasSFT	:=	""     
Default lHistTab	:=	SuperGetMv("MV_HISTTAB",,.F.) .And. AliasIndic("AIF")
Default lExtratTAF  := .F.

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lTop 	:= .T.		
	Endif
#ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para quando jah vier por parametro, com isso evitoณ
//ณ  de chamar a funcao novamente                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lHistTab	:=	Iif(aHistSA==Nil,lHistTab,.F.)
aMod		:=	Iif(aHistSA==Nil,aMod,aHistSA)

//Tratamento para utilizar os campos do SELECT quando for TOP ao inves de posicionar a tabela
If lTop .And. !Empty(cAliasSFT)
	cAlsCorr	:=	cAliasSFT
Else
	cAlsCorr	:=	cAlsSA
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampos do cadastro a serem consideradosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
//If cA1A2 <> "1" .OR. ("1"$cA1A2 .AND. (cAlsCorr+"->A"+cA1A2+"_COD" == cAlsCorr+"->CODENT" .OR. EMPTY(&(cAlsCorr+"->CODENT"))))
If cA1A2 == "1"
	cCmpCod		:=	cAlsCorr+"->A"+cA1A2+"_COD"
	cCmpLoja	:=	cAlsCorr+"->A"+cA1A2+"_LOJA"
	cCmpNome	:=	cAlsCorr+"->A"+cA1A2+"_NOME"
	cCmpTipo	:=	cAlsCorr+"->A"+cA1A2+Iif ("2"$cA1A2, "_TIPO", "_PESSOA")
	cCmpCgc		:=	cAlsCorr+"->A"+cA1A2+"_CGC"
	cCmpEst		:=	cAlsCorr+"->A"+cA1A2+"_EST"
	cCmpInsc	:= IIF(cA1A2=="4",cAlsCorr+"->A"+cA1A2+"_INSEST" ,cAlsCorr+"->A"+cA1A2+"_INSCR")
	cCmpCodM	:=	cAlsCorr+"->A"+cA1A2+"_COD_MUN"
	cCmpEnd		:=	cAlsCorr+"->A"+cA1A2+"_END"
	cCmpBairro	:=	cAlsCorr+"->A"+cA1A2+"_BAIRRO"
	cCmpCdPais	:=	Iif(&(cAlsSA)->(FieldPos("A"+cA1A2+"_CODPAIS")) > 0,cAlsCorr+"->A"+cA1A2+"_CODPAIS","")
	cCmpSuframa	:=	Iif(&(cAlsSA)->(FieldPos("A"+cA1A2+"_SUFRAMA")) > 0,cAlsCorr+"->A"+cA1A2+"_SUFRAMA","")
	cCmpInscM	:= 	cAlsCorr+"->A"+cA1A2+"_INSCRM"
	cCmpPessoa	:= 	cAlsCorr+"->A"+cA1A2+"_PESSOA"
	cCmpCompl 	:= cAlsCorr+"->A"+cA1A2+"_COMPLEM"
Else
	cCmpCod		:=	cAlsCorr+"->CODENT"
	cCmpLoja	:=	cAlsCorr+"->LOJENT"
	cCmpNome	:=	cAlsCorr+"->NOMENT"
	cCmpTipo	:=	cAlsCorr+"->PESSENT"
	cCmpCgc		:=	cAlsCorr+"->CGCENT"
	cCmpEst		:=	cAlsCorr+"->ESTENT"
	cCmpInsc	:= 	cAlsCorr+"->INSCRENT"
	cCmpCodM	:=	cAlsCorr+"->COD_MUN_ENT"
	cCmpEnd		:=	cAlsCorr+"->ENDENT"
	cCmpBairro	:=	cAlsCorr+"->BAIRROENT"
	cCmpCdPais	:=	Iif(&(cAlsSA)->(FieldPos("A"+cA1A2+"_CODPAIS")) > 0,cAlsCorr+"->CODPAISENT","")
	cCmpSuframa	:=	Iif(&(cAlsSA)->(FieldPos("A"+cA1A2+"_SUFRAMA")) > 0,cAlsCorr+"->SUFRAMAENT","")
	cCmpInscM	:= 	cAlsCorr+"->INSCRMENT"
	cCmpPessoa	:= 	cAlsCorr+"->PESSENT"
	cCmpCompl 	:=  cAlsCorr+"->COMPLEMENT"
	cAlsSA		:=  cAlsCorr
EndIf

IF	lInscPar
	cInscricao:= RetCmpHist(cCmpInsc,aMod,dDataAte)
EndIf
If cAlsSA == "SA4"

	If lHistTab .And. dDataDe<>Nil
		aMod 	:= MsConHist(cAlsSA,,,dDataDe,,,&(cCmpCod))
	EndIf

	aAdd (aA1A2, "SA4"+Iif(lConcFil,cFilAnt,"")+(cAlsCorr)->A4_COD+cInscricao)						   		//01	-	COD_PART
	
	cContCampo 	:= RetCmpHist(cCmpNome,aMod,dDataAte)														
	aAdd (aA1A2, cContCampo)																			  		//02	-	NOME

	If !Empty(cCmpCdPais)
		cContCampo 	:= RetCmpHist(cCmpCdPais,aMod,dDataAte)
		aAdd (aA1A2, AllTrim(cContCampo))																 	 	//03	-	COD_PAIS
	Else                                                                                                 	
		aAdd (aA1A2, "01058")				  															 		//03	-	COD_PAIS
	EndIf

	aAdd (aA1A2, "")																		  			 		//04	-	CNPJ
	aAdd (aA1A2, "")																			 		 		//05	-	CPF
	aAdd (aA1A2, "")																			 				//06	-	IE
	aAdd (aA1A2, "")																			  				//07	-	COD_MUN
	aAdd (aA1A2, "")																			  		  		//08	-	Inscricao SUFRAMA
	//                                                                                                      	
	If "01058" $ aA1A2[3]
		cContCampo 	:= RetCmpHist(cCmpCgc,aMod,dDataAte)
		If Len(AllTrim(cContCampo))>=14 .And. &(cCmpEst)<>"EX"
			aA1A2[04] :=  SPEDConType(SPEDVldIE(cContCampo,,.F.))									   	   		//04	-	CNPJ

		ElseIf Len(AllTrim(cContCampo))<14 .And. &(cCmpEst)<>"EX"
			aA1A2[05] := SPEDConType(SPEDVldIE(cContCampo,,.F.))											   	//05	-	CPF
		EndIf
		
		aA1A2[06] := SPEDConType(SPEDVldIE((cAlsCorr)->A4_INSEST))											  	//06	-	IE
		
		If SA4->(FieldPos("A4_COD_MUN"))>0
			//Tratamento para o codigo de municipio, se nao possuir o codigo do estado, tenho de colocar
			cContCampo 	:= RetCmpHist(cCmpCodM,aMod,dDataAte)
			If Upper((cAlsCorr)->A4_EST) == "EX"
				aA1A2[07]	:=	"9999999"																  	 	//07	-	COD_MUN
				                                                                                         	
			ElseIf Len(Alltrim(cContCampo))<=5
				aA1A2[07]	:=	UfCodIBGE((cAlsCorr)->A4_EST)+Alltrim(cContCampo)						 		//07	-	COD_MUN
			Else
				aA1A2[07]	:=	Alltrim(cContCampo)														 		//07	-	COD_MUN
			EndIf			
		EndIf
		
		If SA4->(FieldPos("A4_SUFRAMA"))>0
			cContCampo 	:= RetCmpHist(cCmpSuframa,aMod,dDataAte)
			aA1A2[08] := SPEDConType(cContCampo)																//08    -   SUFRAMA
		EndIf
	Else
		aA1A2[07] := "9999999"
	EndIf

	lCmpCompEx := &(cAlsCorr)->(FieldPos("A"+cA1A2+"_COMPLEM")) > 0 

	cContCampo 	:= RetCmpHist(cCmpEnd,aMod,dDataAte)
	aEnd	:=	MyGetEnd(cContCampo,cAlsSA,cAlsCorr)		
	aAdd (aA1A2, SPEDConType(aEnd[1]))											 								//09	-	END
	aAdd (aA1A2, Iif (!Empty(aEnd[2]),aEnd[3],"SN"))	 												  		//10	-	NUM
	aAdd (aA1A2, Iif (!Empty(aEnd[4]) .Or. !lCmpCompEx, SPEDConType(aEnd[4]), &(cCmpCompl))) 	 																		//11	-	COMPL
	cContCampo 	:= RetCmpHist(cCmpBairro,aMod,dDataAte)
	aAdd (aA1A2, SPEDConType(cContCampo))														  				//12	-	BAIRRO

	aAdd (aA1A2, (cAlsCorr)->A4_EST)														  					//13	-	UF
	aAdd (aA1A2, "")																  							//14	-	InscMun
Else

	If lHistTab .And. dDataDe<>Nil
		aMod 	:= MsConHist(cAlsSA,&(cCmpCod),&(cCmpLoja),dDataDe)
	EndIf

	If !lExtratTAF
//		If cA1A2 <> "1" .OR. ("1"$cA1A2 .AND. (cAlsCorr+"->A"+cA1A2+"_COD" == cAlsCorr+"->CODENT" .OR. EMPTY(&(cAlsCorr+"->CODENT"))))
		If cA1A2 == "1"
   			aAdd (aA1A2, cAlsSA+Iif(lConcFil,cFilAnt,"")+&(cCmpCod)+&(cCmpLoja)+cInscricao) 							//01	-	COD_PART
  		Else
  			aAdd (aA1A2, "SA1"+Iif(lConcFil,cFilAnt,"")+&(cCmpCod)+&(cCmpLoja)+cInscricao)
  		EndIf
	Else
		aAdd (aA1A2, cAlsSA+&(cCmpCod))																				//01	-	COD_PART
	EndIf

	cContCampo 	:= RetCmpHist(cCmpNome,aMod,dDataAte)														
	aAdd (aA1A2, cContCampo)        		 																	//02	-	NOME
	
	If !Empty(cCmpCdPais)
		cContCampo 	:= RetCmpHist(cCmpCdPais,aMod,dDataAte)
		aAdd(aA1A2,cContCampo)																					//03	-	COD_PAIS
	Else                                                                                                 	
		aAdd (aA1A2, "01058")				  															 		//03	-	COD_PAIS
	EndIf
	
	//No cadastro do cliente quem determina se o cliente ้ uma pessoa fisica ou juridica
	//seria o campo A1_PESSOA, no caso do Fornecedor seria o campo A2_TIPO.
	cContCampo 	:= RetCmpHist(cCmpCgc,aMod,dDataAte)
	If cAlsSA=="SA1"
		aAdd (aA1A2, IIF(&(cCmpPessoa)=="J" .And. (cAlsCorr)->A1_TIPO <>"X",SPEDConType(SPEDVldIE(cContCampo,,.F.)),""))			//04	-	CNPJ
		aAdd (aA1A2, IIF(&(cCmpPessoa)=="F" .And. (cAlsCorr)->A1_TIPO <>"X",SPEDConType(SPEDVldIE(cContCampo,,.F.)),""))			//05	-	CPF
	Else
		aAdd (aA1A2, IIF(&(cCmpTipo)=="J",SPEDConType(SPEDVldIE(cContCampo,,.F.)),""))	 	  				//04	-	CNPJ
		aAdd (aA1A2, IIF(&(cCmpTipo)=="F",SPEDConType(SPEDVldIE(cContCampo,,.F.)),""))	 	 				//05	-	CPF
	Endif
	
	cContCampo 	:= RetCmpHist(cCmpInsc,aMod,dDataAte)
	aAdd(aA1A2, SPEDConType(SPEDVldIE(cContCampo)))															//06	-	IE
	
	If !"01058"$aA1A2[3] .And. AllTrim(aA1A2[3])<>""
		aAdd (aA1A2, "9999999")																				   	//07	-	COD_MUN
	Else
		//Tratamento para o codigo de municipio, se nao possuir o codigo do estado, tenho de colocar
		cContCampo 	:= RetCmpHist(cCmpCodM,aMod,dDataAte)
		If Len(Alltrim(cContCampo))<=5
			aAdd (aA1A2, UfCodIBGE(&(cCmpEst))+Alltrim(cContCampo))											//07	-	COD_MUN
			//Se possuir, considero como esta, desde que o estado nao seja "EX"
		Else
			aAdd (aA1A2, Iif (Upper(&(cCmpEst)) == "EX","9999999", cContCampo))								//07	-	COD_MUN
		EndIf
	EndIf
	
	cContCampo 	:= RetCmpHist(cCmpSuframa,aMod,dDataAte)
	aAdd (aA1A2,cContCampo)																						//08	-	SUFRAMA

	cContCampo 	:= RetCmpHist(cCmpEnd,aMod,dDataAte)
	
	lCmpCompEx := &(cAlsCorr)->(FieldPos("A"+cA1A2+"_COMPLEM")) > 0 
	
//	aEnd :=	IIF(cA1A2 <> "1" .OR. ("1"$cA1A2 .AND. (cAlsCorr+"->A"+cA1A2+"_COD" == cAlsCorr+"->CODENT" .OR. EMPTY(&(cAlsCorr+"->CODENT")))), MyGetEnd(cContCampo,cAlsSA,cAlsCorr),MyGetEnd(cContCampo,"SA1",cAlsCorr)) 
	aEnd :=	IIF(cA1A2 == "1" , MyGetEnd(cContCampo,cAlsSA,cAlsCorr),MyGetEnd(cContCampo,"SA1",cAlsCorr)) 
	aAdd (aA1A2, SPEDConType(aEnd[1]))										  									//09	-	END
	aAdd (aA1A2, Iif (!Empty(aEnd[2]),aEnd[3],"SN")) 											            	//10	-	NUM
 	aAdd (aA1A2, IIf(!Empty(AllTrim(aEnd[4])) .Or. !lCmpCompEx,SPEDConType(aEnd[4]),&(cCmpCompl)))                                                                         	//11	-	COMPL
 	                               	
	//Ponto de entrada para gerar informacoes do endereco e numero. 
	If lCadParti
	 	aPart := ExecBlock("SPDFIS06", .F., .F., {cAlsSA}) 
		aA1A2[09] := aPart[01]
		aA1A2[10] := aPart[02]
	Endif	
	cContCampo 	:= RetCmpHist(cCmpBairro,aMod,dDataAte)
	aAdd (aA1A2,cContCampo)																						//12	-	BAIRRO

	aAdd (aA1A2, &(cCmpEst))													   					   			//13	-	UF
	aAdd (aA1A2, &(cCmpInscM))																		   			//14	-	InscMun
	
//	If "1"$cA1A2 .AND. (cAlsCorr+"->A"+cA1A2+"_COD" <> cAlsCorr+"->CODENT" .AND. !EMPTY(&(cAlsCorr+"->CODENT")))
	If "1"$cA1A2
		cAlsCorr	:=	"SA1"
	EndIf
	
EndIf
Return (aA1A2)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณMyGetEnd  ณ Autor ณGustavo G. Rueda              ณ Data ณ22.03.2011ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica se o participante e do DF, ou se tem um tipo de endereco ณฑฑ
ฑฑณ          ณ que nao se enquadra na regra padrao de preenchimento de endereco  ณฑฑ
ฑฑณ          ณ por exemplo: Enderecos de Area Rural (essa verific็ใo e feita     ณฑฑ
ฑฑณ          ณ atraves do campo ENDNOT).                                         ณฑฑ
ฑฑณ          ณ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ณฑฑ
ฑฑณ          ณ Endereco (sem numero ou complemento). Caso contrario ira retornar ณฑฑ
ฑฑณ          ณ o padrao do FisGetEnd                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Obs.     ณ Esta funcao so pode ser usada quando ha um posicionamento de      ณฑฑ
ฑฑณ          ณ registro, pois serแ verificado o ENDNOT do registro corrente      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SIGAFIS                                                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MyGetEnd(cEndereco,cAlias,cAlsQry)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}

Default	cAlsQry	:=	""

//Tratamento para quando os campos base estiverem no select
If Empty(cAlsQry)
	cAlsQry	:=	cAlias
EndIf

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlsQry+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlsQry+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco,&(cAlsQry+"->"+cCmpEst))
EndIf

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSPEDREGD  บAutor  ณMicrosiga           บ Data ณ  07/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xReg0200(cAlias)

Local	lHistTab	:=	SuperGetMv("MV_HISTTAB",,.F.) .And. AliasIndic("AIF")
Local	nICMPAD 	:= 	SuperGetMV("MV_ICMPAD",,18)
Local   cAliasSB1	:=	"SB1"
Local	aMod		:=	{}
Local   aReg0200    :=  {} //Cadastro do Produto
Local   xArea       := GetArea()
Local 	aTipo		:=	{ {"ME","00"},;
{"MP","01"},;
{"EM","02"},;
{"PP","03"},;
{"SP","05"},;
{"PI","06"},;
{"PA","04"},;
{"MC","07"},;
{"AI","08"},;
{"MO","09"},;
{"OI","10"} }
Local	nTIpo		:=	0
Local	cTipo		:=	"99"

DbSelectArea(cAliasSB1)
DbSetOrder(1)
DbSeek(xFilial("SB1")+(cAliasSFT)->FT_PRODUTO)

If Found()
	cProd 		:= 	(cAliasSFT)->FT_PRODUTO+xFilial("SB1")
	aProd 		:= 	{"","","","","","","","","","",""}
	cUnid		:=	(cAliasSB1)->B1_UM
	
	nTipo := aScan(aTipo,{|x| x[1]==(cAliasSB1)->B1_TIPO})
	If nTipo > 0
		cTipo := aTipo[nTipo][2]
	EndIf



	aAdd(aReg0200,{})
	nPos	:=	Len (aReg0200)
	aAdd(aReg0200[nPos], "0200")										 						//01 - REG
	aAdd(aReg0200[nPos], cProd)     															//02 - COD_ITEM
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento para pegar a informacao valida do cadastro dentro do prazo de geracao do spedifscalณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lHistTab .And. dDataDe <> NIL
		aMod 	:= MsConHist("SB1","","",dDataDe,,Substr(cProd,1,TamSx3("B1_COD")[1]))
	EndIf
	cContCampo 	:= RetCmpHist(cAliasSB1+"->B1_DESC",aMod,dDataAte,lHistTab)
	
	aAdd (aReg0200[nPos], cContCampo)    						//03 - DESCR_ITEM
	aAdd (aReg0200[nPos], (cAliasSB1)->B1_CODBAR)				//04 - COD_BARRA
	aAdd (aReg0200[nPos], (cAliasSB1)->B1_CODANT)				//05 - COD_ANT_IETM
	aAdd (aReg0200[nPos], (cAliasSB1)->B1_UM)					//06 - UNI_INV
	aAdd (aReg0200[nPos], cTipo)								//07 - TIPO_ITEM
	aAdd (aReg0200[nPos], (cAliasSB1)->B1_POSIPI)				//08 - COD_NCM
	aAdd (aReg0200[nPos], (cAliasSB1)->B1_EX_NCM)				//09 - EX_IPI
	aAdd (aReg0200[nPos], Iif(Empty((cAliasSB1)->B1_CODISS),Left((cAliasSB1)->B1_POSIPI,2),"00" ))//10 - COD_GEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณObtendo o codigo do ISS atraves do cadastro da tabela CDN. Este codigo deverahณ
	//ณ estar conforme LC 116/03                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCodIss := SubStr((cAliasSB1)->B1_CODISS,1,4)
	If AliasIndic("CDN") .And. CDN->(MsSeek(xFilial("CDN")+cCodIss))
		cCodIss := SubStr (CDN->CDN_CODLST, 1, 4)
	EndIf
	aAdd (aReg0200[nPos], StrTran(cCodIss,".",""))				//11 - COD_LST
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento para obter a aliquota interna do produtoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (cAliasSB1)->B1_PICM>0
		nAlqProd	:=	(cAliasSB1)->B1_PICM
	Else
		If GetMv("MV_ESTADO")=="RJ"
			nAlqProd:=	nICMPAD+(cAliasSB1)->B1_FECP
		Else
			nAlqProd:=	nICMPAD
		EndIf
	EndIf
	aAdd(aReg0200[nPos], nAlqProd)						  		//12 - ALIQ_ICM
	
	GrvRegTrS (cAlias, cProd, {aReg0200[nPos]})
EndIf

RestArea(xArea)
		
Return(aReg0200)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSPEDREGD  บAutor  ณMicrosiga           บ Data ณ  03/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



//Function xMagLeWiz (cArqIni, aIniWiz, lSubStr)
Static Function xWizard (cArqIni, aIniWiz, lSubStr)
	Local 		cIni		:=	cArqIni+".CFP"
	Local 		nI			:=	0
	Local 		nJ			:=	0
	Local		lRet		:=	.T.
	Local		nPadR		:=	0
	//
	Default	lSubStr	:=	.F.
	//
	If !File (cIni)
		lRet	:=	.F.
	ElseIf (lRet := (FT_FUse(cIni) > 0))
		FT_FGoTop()
		While ( !FT_FEof() )
			cLinha := FT_FReadLn()
			If ("PAINEL"$cLinha)
				aAdd (aIniWiz, {})
			Else
				aAdd (aIniWiz[Len (aIniWiz)], cLinha)
			EndIf
			FT_FSkip()
		Enddo		
		FT_FUse()	
	Endif
	//
	If (lSubStr)
		For nJ := 1 To Len (aIniWiz)
			For nI := 1 To Len (aIniWiz[nJ])			
				If (SubStr (aIniWiz[nJ][nI], 8, 1)==";")
					nPadR	:=	Val (SubStr (aIniWiz[nJ][nI], 9, 3))
					aIniWiz[nJ][nI]	:=	SubStr (aIniWiz[nJ][nI], 13, nPadR)
				Else
					aIniWiz[nJ][nI]	:=	SubStr (aIniWiz[nJ][nI], 9)
				EndIf
			Next (nI)
		Next (nJ)
	EndIf
Return (lRet)

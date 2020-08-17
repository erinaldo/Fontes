#Include "PROTHEUS.Ch"      
#include "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³          ³ Autor ³ Renato Carlos     	³ Data ³ 21.06.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de apoio ao Razario                       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CSARQAUTO()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ Varios       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alterações³ Correções para atender a OS 3217/15 - Douglas David        ³±±
±±³          ³ Correções para atender a OS 1353/17 - Isamu K.             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function CSARQAUTO(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07)

Local _aArea := GetArea()
Local nX     := 1

Private cDirDocs := MsDocPath()            // Diretorio de docs do servidor
Private cTmpTxt  := CriaTrab(Nil,.f.)
Private cCmd     := cDirDocs+"\"+cTmpTxt+".csv"
Private _dAdmDe  := MV_PAR01
Private _dAdmAte := MV_PAR02
Private _cCCDe   := MV_PAR03
Private _cCCAte  := MV_PAR04
Private _cSit    := MV_PAR05
Private _dDemDe  := MV_PAR06
Private _dDemAte := MV_PAR07
Private _cInSituac := ""

While nX <= Len(_cSit)
		//if SubStr(_cSit,nX,1) <> "*"
			If nX == Len(_cSit)
				_cInSituac += "'"+SubStr(_cSit,nX,1)+"' "
			Else
				_cInSituac += "'"+SubStr(_cSit,nX,1)+"',"
			EndIf	
		//endif
		nX++
EndDo

MemoWrite("\razarios\testeArq.txt","testeArq")

 // Chamada da rotina que cria os arquivos
ProcQry()

RestArea(_aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ ProcQry  ³ Autor ³ Renato Carlos     	³ Data ³ 21.06.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Arquivos de apoio CTT, CTH, CT1, SA2, SA1, SRA 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ProcQry()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ SIGACTB      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcQry()

Local _cArqCTH := "\razarios\CTH.CSV"
Local _cArqCTT := "\razarios\CTT.CSV"
Local _cArqCT1 := "\razarios\CT1.CSV"
Local _cArqSA1 := "\razarios\SA1.CSV"
Local _cArqSA2 := "\razarios\SA2.CSV"
Local _cArqSRA := "\razarios\HC.CSV"
Local _cQryCTT := ""
Local _cQryCTH := ""
Local _cQryCT1 := ""
Local _cQrySA1 := ""
Local _cQrySA2 := ""
Local _cQrySRA := ""
Local cTmpCTT  := "cTmpCTT"
Local cTmpCTH  := "cTmpCTH"
Local cTmpCT1  := "cTmpCT1"
Local cTmpSA1  := "cTmpSA1"
Local cTmpSA2  := "cTmpSA2"
Local cTmpSRA  := "cTmpSRA"
Private nHdl
Private cCabCtt := "C_CUSTO;FILIAL;DESCRICAO;BLOQUEIO"+CHR(13)+CHR(10)
Private cCabCth := "OPERACAO;DESCRICAO;BLOQUEIO;CR_NV2;CLI_CHAVE"+CHR(13)+CHR(10)
Private cCabCt1 := "CONTA;DESCRICAO;CLASSE;BLOQUEIO;CTA_SUPER"+CHR(13)+CHR(10)
Private cCabSa1 := "CODIGO;RAZAO;FANTASIA"+CHR(13)+CHR(10)
Private cCabSa2 := "CODIGO;RAZAO;FANTASIA"+CHR(13)+CHR(10)
/*
Private cCabSRA :=  "RA_FILIAL;RA_CRACHA;RA_MAT;RA_NOME;RA_CATFUNC;RA_CIC;RA_ESTCIVI;RA_MUNICIP;RA_ESTADO;RA_CC;CTT_DESC01;RA_ADMISSA;RA_MOTIADM;RA_CODFUNC;RJ_DESC;"+;
					"RA_GS;RA_HRSMES;RA_SEXO;RA_DEMISSA;RA_DTTRANS;RG_TIPORES;RG_MOTDEM;CTT_CCONTD;RA_ITEMD;RA_CLVLDB;RA_DEXPER;RA_VCTOEXP;RA_VCTEXP2;RA_SITFOLH;"+;
					"RA_NASC;RA_GRINRAI;RA_EQUIPE;RA_RESCRAI;RA_RG"+CHR(13)+CHR(10)
*/					
Private cCabSRA :=	"RA_FILIAL;RA_CRACHA;RA_MAT;RA_NOME;RA_CATFUNC;RA_CIC;RA_ESTCIVI;RA_MUNICIP;RA_ESTADO;RA_CC;CTT_DESC01;RA_ADMISSA;RA_MOTIADM;RA_CODFUNC;"+;
					"RJ_DESC;RA_GS;RA_HRSMES;RA_SEXO;RA_DEMISSA;RA_DTTRANS;RG_TIPORES;RG_MOTDEM;CTT_CCONTD;RA_ITEMD;RA_CLVLDB;RA_DEXPER;RA_VCTOEXP;RA_VCTEXP2;"+;
					"RA_SITFOLH;RA_NASC;RA_GRINRAI;RA_EQUIPE;RA_RESCRAI;RA_RG;RA_TERMTRE"+CHR(13)+CHR(10)




Private cLinCtt 
Private cLinCtH 
Private cLinCt1 
Private cLinSa1 
Private cLinSa2
Private cLinSRA

Private bLinCtt := {|| cLin := @C_CUSTO+';'+@FILIAL+';'+@DESCRICAO+';'+@BLOQUEIO +CHR(13)+CHR(10)}
Private bLinCth := {|| cLin := @OPERACAO+';'+@DESCRICAO+';'+@BLOQUEIO+';'+@CR_NV2+';'+@CLI_CHAVE +CHR(13)+CHR(10)}
Private bLinCt1 := {|| cLin := @CONTA+';'+@DESCRICAO+';'+@CLASSE+';'+@BLOQUEIO+';'+@CTA_SUPER +CHR(13)+CHR(10)}
Private bLinSa1 := {|| cLin := @CODIGO+';'+@RAZAO+';'+@FANTASIA +CHR(13)+CHR(10)}
Private bLinSa2 := {|| cLin := @CODIGO+';'+@RAZAO+';'+@FANTASIA +CHR(13)+CHR(10)}

/*
Private bLinSRA := {|| cLin := @RA_FILIAL+';'+@RA_CRACHA+';'+@RA_MAT+';'+@RA_NOME+';'+@RA_CATFUNC+';'+@RA_CIC+';'+@RA_ESTCIVI+';'+@RA_MUNICIP+';'+;
								@RA_ESTADO+';'+@RA_CC+';'+@CTT_DESC01+';'+@RA_ADMISSA+';'+@RA_MOTIADM+';'+@RA_CODFUNC+';'+@RJ_DESC+';'+@RA_GS+';'+;
								@Alltrim(str(RA_HRSMES))+';'+@RA_SEXO+';'+@RA_DEMISSA+';'+@RA_DTTRANS+';'+@RG_TIPORES+';'+@RG_MOTDEM+';'+@CTT_CCONTD+';'+@RA_ITEMD+';'+;
								@RA_CLVLDB+';'+@Alltrim(str(RA_DEXPER))+';'+@RA_VCTOEXP+';'+@RA_VCTEXP2+';'+@RA_SITFOLH+';'+@RA_NASC+';'+@RA_GRINRAI+';'+@RA_EQUIPE+';'+;
								@RA_RESCRAI+';'+@RA_RG+CHR(13)+CHR(10)}			 
*/


Private bLinSRA := {|| cLin := @RA_FILIAL+';'+@RA_CRACHA+';'+@RA_MAT+';'+@RA_NOME+';'+@RA_CATFUNC+';'+@RA_CIC+';'+@RA_ESTCIVI+';'+@RA_MUNICIP+';'+;
								@RA_ESTADO+';'+@RA_CC+';'+@CTT_DESC01+';'+@RA_ADMISSA+';'+@RA_MOTIADM+';'+@RA_CODFUNC+';'+@RJ_DESC+';'+@RA_GS+';'+;
								@Alltrim(str(RA_HRSMES))+';'+@RA_SEXO+';'+@RA_DEMISSA+';'+@RA_DTTRANS+';'+@RG_TIPORES+';'+@RG_MOTDEM+';'+@CTT_CCONTD+';'+@RA_ITEMD+';'+;
								@RA_CLVLDB+';'+@Alltrim(str(RA_DEXPER))+';'+@RA_VCTOEXP+';'+@RA_VCTEXP2+';'+@RA_SITFOLH+';'+@RA_NASC+';'+@RA_GRINRAI+';'+@RA_EQUIPE+';'+;
								@RA_RESCRAI+';'+@RA_RG+';'+@RA_TERMTRE+CHR(13)+CHR(10)}
								
// Sequencia de querys para montagem dos arquivos

_cQryCTT := " SELECT CTT_CUSTO AS C_CUSTO, "
_cQryCTT += "	   CTT_FIL AS FILIAL,  "
_cQryCTT += "	   CTT_DESC01 AS DESCRICAO, "
_cQryCTT += "	   BLOQUEIO = CASE CTT_BLOQ  WHEN '1' THEN 'Bloqueado' "
_cQryCTT += "						   	   ELSE 'Nao Bloqueado'            "
_cQryCTT += "	   END                                           "
_cQryCTT += " FROM "+RetSqlName("CTT")+"                         "
_cQryCTT += " WHERE D_E_L_E_T_ = ''                              "
_cQryCTT += "ORDER BY C_CUSTO                                    "

U_MontaView( _cQryCTT, cTmpCTT ) //Função customizada para para facilitar a criação do arquivo temporário

_cQryCTH := " SELECT CTH_CLVL AS OPERACAO, "
_cQryCTH +=	"   	 CTH_DESC01 AS DESCRICAO, "
_cQryCTH +=	"  		 BLOQUEIO = CASE CTH_BLOQ  WHEN '1' THEN 'Bloqueado'  "
_cQryCTH +=	"					   	           ELSE 'Nao Bloqueado'           "
_cQryCTH +=	"   	 END,                                           "
_cQryCTH +=	"   	 CTH_CRGNV2 AS CR_NV2,                          "
_cQryCTH +=	"     	 CTH_CLICHV AS CLI_CHAVE                        "
_cQryCTH += " FROM "+RetSqlName("CTH")+"                            "
_cQryCTH += " WHERE D_E_L_E_T_ = ''                                 "
_cQryCTH += " ORDER BY OPERACAO                                     "
                                                                  
U_MontaView( _cQryCTH, cTmpCTH )

_cQryCT1 := " SELECT CT1_CONTA AS CONTA,                            "
_cQryCT1 +=	"  		 CT1_DESC01 AS DESCRICAO,                       "
_cQryCT1 +=	"	     BLOQUEIO = CASE CT1_BLOQ  WHEN '1' THEN 'Bloqueada'  "
_cQryCT1 +=	"						   	   	   ELSE 'Nao Bloqueada'           "
_cQryCT1 +=	"	     END,                                           "

_cQryCT1 +=	"	     CLASSE = CASE CT1_CLASSE  WHEN '1' THEN 'Sintetica'  "
_cQryCT1 +=	"						   	   	   ELSE 'Analitica'           "
_cQryCT1 +=	"	     END,                                           "
_cQryCT1 += "		 CT1_CTASUP AS CTA_SUPER                       "
_cQryCT1 += " FROM "+RetSqlName("CT1")+"                           "
_cQryCT1 += " WHERE D_E_L_E_T_ = ''                                 "
_cQryCT1 += " ORDER BY CONTA                                        "

 U_MontaView( _cQryCT1, cTmpCT1 )
                                                                   
_cQrySA1 := " SELECT A1_COD AS CODIGO,                            "
_cQrySA1 +=	"       A1_NOME AS RAZAO,                             "
_cQrySA1 +=	"       A1_NREDUZ AS FANTASIA                         "
_cQrySA1 += " FROM "+RetSqlName("SA1")+"                         "
_cQrySA1 += " WHERE D_E_L_E_T_ = ''                              "
_cQrySA1 += " ORDER BY CODIGO                                    "

U_MontaView( _cQrySA1, cTmpSA1 )
                                                                
_cQrySA2 :=" SELECT A2_COD AS CODIGO,                           "
_cQrySA2 +="	   	A2_NOME AS RAZAO,                           "
_cQrySA2 +="	   		A2_NREDUZ AS FANTASIA                   "
_cQrySA2 +=" FROM "+RetSqlName("SA2")+"                        "
_cQrySA2 +=" WHERE D_E_L_E_T_ = ''                              "
_cQrySA2 +=" ORDER BY CODIGO                                    "

U_MontaView( _cQrySA2, cTmpSA2 )

_cQrySRA := "SELECT RA_FILIAL,RA_CRACHA,RA_MAT,RA_NOME,RA_CATFUNC,RA_CIC,RA_ESTCIVI,RA_MUNICIP,RA_ESTADO,RA_CC,CTT_DESC01,RA_ADMISSA,RA_MOTIADM,RA_CODFUNC,RJ_DESC,"
_cQrySRA +=	"   RA_GS,RA_HRSMES,RA_SEXO,RA_DEMISSA,RA_DTTRANS,"

_cQrySRA += " CASE WHEN RG_TIPORES IS NULL THEN ''  "
_cQrySRA += " ELSE 	SRG050.RG_TIPORES "
_cQrySRA += " END AS RG_TIPORES,  "
_cQrySRA += " CASE WHEN RG_MOTDEM IS NULL THEN ''   "
_cQrySRA += " ELSE 	SRG050.RG_MOTDEM "
_cQrySRA += " END AS RG_MOTDEM,"

//_cQrySRA +=" RG_TIPORES,RG_MOTDEM, "
_cQrySRA +=	" CTT_CCONTD,RA_ITEMD,RA_CLVLDB,RA_DEXPER,RA_VCTOEXP,RA_VCTEXP2,RA_SITFOLH,RA_NASC,RA_GRINRAI,RA_EQUIPE,RA_RESCRAI,RA_RG, RA_TERMTRE "
	   
_cQrySRA +=" FROM "+RetSqlName("SRA")+"   "
_cQrySRA +=" LEFT JOIN "+RetSqlName("SRG")+" ON RA_FILIAL = RG_FILIAL AND RA_MAT = RG_MAT AND SRG050.D_E_L_E_T_ = '' "
_cQrySRA +=" LEFT JOIN "+RetSqlName("SRJ")+" ON RA_CODFUNC =  RJ_FUNCAO AND SRJ050.D_E_L_E_T_ = '' "
_cQrySRA +=" LEFT JOIN "+RetSqlName("CTT")+" ON RA_CC = CTT_CUSTO AND CTT050.D_E_L_E_T_ = '' "

_cQrySRA +=" WHERE SRA050.D_E_L_E_T_ = '' "
_cQrySRA +=" AND SRA050.RA_ADMISSA BETWEEN '"+Dtos(_dAdmDe)+"' AND '"+Dtos(_dAdmAte)+"' "
_cQrySRA +=" AND SRA050.RA_CC BETWEEN '"+Alltrim(_cCCDe)+"' AND '"+Alltrim(_cCCAte)+"' "
_cQrySRA +=" AND SRA050.RA_SITFOLH IN (" + _cInSituac + ") "

If Substring(Alltrim(_cSit),2,1) $ 'D'
	_cQrySRA +=" AND (SRA050.RA_DEMISSA = '' OR SRA050.RA_DEMISSA >= '"+Dtos(_dDemDe)+"') "
	//_cQrySRA +=" AND (SRA050.RA_DEMISSA = '' OR SRA050.RA_DEMISSA BETWEEN '"+Dtos(_dDemDe)+"' AND '"+Dtos(_dDemAte)+"')  "  ->OS 1353/17
Else
	_cQrySRA +=" AND SRA050.RA_DEMISSA = ''
EndIf

_cQrySRA +=" GROUP BY RA_FILIAL,RA_CRACHA,RA_MAT,RA_NOME,RA_CATFUNC,RA_CIC,RA_ESTCIVI,RA_MUNICIP,RA_ESTADO,RA_CC,CTT_DESC01,RA_ADMISSA,RA_MOTIADM,RA_CODFUNC,RJ_DESC,"
_cQrySRA +="	   RA_GS,RA_HRSMES,RA_SEXO,RA_DEMISSA,RA_DTTRANS,RG_TIPORES,RG_MOTDEM,CTT_CCONTD,RA_ITEMD,RA_CLVLDB,RA_DEXPER,RA_VCTOEXP,RA_VCTEXP2,RA_SITFOLH, "
_cQrySRA +="	   RA_NASC,RA_GRINRAI,RA_EQUIPE,RA_RESCRAI, RA_RG, RA_TERMTRE "
_cQrySRA +=" ORDER BY RA_FILIAL, RA_MAT "

//MemoWrite("C:\HEADCOUNT.SQL",_cQrySRA)

//U_MontaView( _cQrySRA, cTmpSRA )   //desabilitado

dbUseArea( .T., 'TOPCONN', TcGenQry(,,_cQrySRA), cTmpSRA, .T., .F. )  //alterado para funcionar via Schedule - 25/01/2013

(cTmpCTT)->( DbGoTop() )
(cTmpCTH)->( DbGoTop() )
(cTmpCT1)->( DbGoTop() )
(cTmpSA1)->( DbGoTop() )
(cTmpSA2)->( DbGoTop() )
(cTmpSRA)->( DbGoTop() )


// COPIANDO ARQUIVO CTT
DbSelectArea("cTmpCTT")
//cLinCtt := C_CUSTO+';'+FILIAL+';'+DESCRICAO+';'+BLOQUEIO +CHR(13)+CHR(10)
GeraCsv (cCmd,cCabCtt,cLinCtt,cTmpCTT,_cArqCTT,bLinCtt)
cTmpCTT->( DbCloseArea() )

// COPIANDO ARQUIVO CTH

DbSelectArea("cTmpCTH")
//cLinCtH := OPERACAO+';'+DESCRICAO+';'+BLOQUEIO+';'+CR_NV2+';'+CLI_CHAVE +CHR(13)+CHR(10)	
GeraCsv (cCmd,cCabCtH,cLinCth,cTmpCTH,_cArqCTH,bLinCth)
cTmpCTH->( DbCloseArea() )
// COPIANDO ARQUIVO CT1

DbSelectArea("cTmpCT1")
//cLinCt1 := CONTA+';'+DESCRICAO+';'+BLOQUEIO+';'+CTA_SUPER+';'+CLASSE +CHR(13)+CHR(10)	
GeraCsv (cCmd,cCabCt1,cLinCt1,cTmpCT1,_cArqCT1,bLinCt1)
cTmpCT1->( DbCloseArea() )
// COPIANDO ARQUIVO SA1

DbSelectArea("cTmpSA1")
//cLinSa1 := CODIGO+';'+RAZAO+';'+FANTASIA +CHR(13)+CHR(10)	
GeraCsv (cCmd,cCabSa1,cLinSa1,cTmpSA1,_cArqSA1,bLinSa1)
cTmpSA1->( DbCloseArea() )
// COPIANDO ARQUIVO SA2

DbSelectArea("cTmpSA2")
//cLinSa2 := CODIGO+';'+RAZAO+';'+FANTASIA +CHR(13)+CHR(10)	
GeraCsv (cCmd,cCabSa2,cLinSa2,cTmpSA2,_cArqSA2,bLinSa2)
cTmpSA2->( DbCloseArea() )

// COPIANDO ARQUIVO SRA
DbSelectArea("cTmpSRA")
//cLinSa2 := CODIGO+';'+RAZAO+';'+FANTASIA +CHR(13)+CHR(10)	
GeraCsv (cCmd,cCabSRA,cLinSRA,cTmpSRA,_cArqSRA,bLinSRA)
cTmpSRA->( DbCloseArea() )

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

Static Function GeraCsv(cCmd,cCab,cLin,_cAlias,cArq,bLin)

nHdl := fCreate(cCmd)
fWrite(nHdl,cCab,Len(cCab))

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())

While (_cAlias)->( !EOF() )
	
	Eval(bLin)
	fWrite(nHdl,cLin,Len(cLin))
	(_cAlias)->(dbSkip())
	
EndDo
fClose(nHdl)
//CpyS2T(cCmd,cArq,.T.)
//COPY TO &(cCmd) VIA "DBFCDX"
__CopyFile(cCmd, cArq)
RETURN


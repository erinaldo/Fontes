#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSRECMD  º Autor ³ FERNANDO BARRETO   º Data ³  29/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera o arquivo para exportacao do CMD e Gestão de Login.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo da CSU.                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSRECMD()

PREPARE ENVIRONMENT EMPRESA "05" FILIAL "03" MODULO "GPE"
Private _aArea     := GetArea()
Private oGeraTxt
Private oHTML
Private cDirDocs   := MsDocPath()            // Diretorio de docs do servidor
Private cTmpTxt    := CriaTrab(Nil,.f.)
Private cCmd       := cDirDocs+"\"+cTmpTxt+".csv" 
Private lFirstChrg :=  SuperGetMV("CS_CSCMD") 

Geraxls(cCmd)  

RESET ENVIRONMENT
RestArea(_aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ Geraxls  º Autor ³ FERNANDO BARRETO   º Data ³  28/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Geraxls(cCmd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   _dData    := If(Type("dDataBase")=="U",Date(),dDataBase)
Local   DINIAFAS  := cTod("//")
Local   DFIMAFAS  := cTod("//")
Local   cTipoAfas := ""
Local   _cQrySRA  := ""
Local   cTmpSRA   := "cTmpSRA"
Local   _cArq     := "\WFM\CMD\CMD.CSV"
Private lOk       := .F.                                					 
Private cLinSRA
Private cLinAfa
Private bLinSRA
Private bLinAFA
Private bLinMail
Private cCabSRA :=" RA_FILIAL;RA_MAT;FILMAT;RA_NOME;RA_SEXO;RA_NASC;RA_RG;RA_CIC;RA_ADMISSA;RA_MOTIADM;RA_DEMISSA;RG_TIPORES;"+;
  				  " RA_TNOTRAB;RA_EQUIPE;MATSUPER;NOMSUPER;MATCOOR;NOMCORR;MATGEREN;NOMGEREN;RA_ESCALA;RJ_DESC;CTH_DESC01;"+;
  				  " RA_CC;CTT_DESC01;RA_TELEFON;RA_TELEFO2;RA_ENDEREC;RA_COMPLEM;RA_BAIRRO;RA_MUNICIP;RA_CEP;RA_NACIONA;"+;
  				  " DSCNACIO;RA_SITFOLH;RA_XCELULA;RA_XAVAYA;RA_CLVLDB;RA_ITEMD;CTD_DESC01;RA_XULTDIA;RA_XABANDO;RA_TERMTRE;"+;
  				  " RA_CODSEQ;DINIAFAS;DFIMAFAS" +CHR(13)+CHR(10)


bLinSRA := {|| cLin1 :=@RA_FILIAL+';'+@RA_MAT+';'+@RA_CRACHA+';'+@RA_NOME+';'+@RA_SEXO+';'+@RA_NASC+';'+@RA_RG+';'+@RA_CIC+';'+;
					   @RA_ADMISSA+';'+@RA_MOTIADM+';'+@RA_DEMISSA+';'+@RG_TIPORES+';'+Alltrim(FDESC("SR6",@RA_TNOTRAB,"R6_DESC"))+';'+;
					   Alltrim(FDESC("SZM",@RA_EQUIPE,"ZM_DESCR"))+';'+Alltrim(FDESC("SZM",@RA_EQUIPE,"ZM_MSUPER"))+';'+;
					   Alltrim(FDESC("SZM",@RA_EQUIPE,"ZM_NOMES"))+';'+Alltrim(FDESC("SZM",@RA_EQUIPE,"ZM_MCOOR"))+';'+Alltrim(FDESC("SZM",@RA_EQUIPE,"ZM_NOMEC"))+';'+;
					   Alltrim(FDESC("SZM",@RA_EQUIPE,"ZM_MGEREN"))+';'+Alltrim(FDESC("SZM",@RA_EQUIPE,"ZM_NOMEG"))+';'+Alltrim(FDESC("SZX",@RA_ESCALA,"ZX_DESCRIC"))+';'+;
					   Alltrim(FDESC("SRJ",@RA_CODFUNC,"RJ_DESC"))+';'+@CTH_DESC01+';'+@RA_CC+';'+@CTT_DESC01+';'+@RA_TELEFON+';'+@RA_TELEFO2+';'+;
					   @RA_ENDEREC+';'+@RA_COMPLEM+';'+@RA_BAIRRO+';'+@RA_MUNICIP+';'+@RA_CEP+';'+ @RA_NACIONA+';'+; 
					   Alltrim(FDESC("SX5","34"+@RA_NACIONA,"X5_DESCRI"))+';'+@RA_SITFOLH+';'+@RA_XCELULA+';'+@RA_XAVAYA+';'+@RA_CLVLDB+';'+;
					   @RA_ITEMD+';'+@CTD_DESC01+';'+@RA_XULTDIA+';'+@RA_XABANDO+';'+@RA_TERMTRE+';'+@RA_CODSEQ}
					   					   

_cQrySRA := " SELECT SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_CRACHA,SRA.RA_NOME,SRA.RA_RG,SRA.RA_CIC,SRA.RA_SEXO, "
_cQrySRA += " CASE WHEN SRA.RA_NASC = '' "
_cQrySRA += " THEN ''  "
_cQrySRA += " ELSE SUBSTRING(SRA.RA_NASC, 7, 2)+ '/' +SUBSTRING(SRA.RA_NASC, 5, 2)+ '/' +SUBSTRING(SRA.RA_NASC, 1, 4)  "
_cQrySRA += " END AS RA_NASC, "
_cQrySRA += " CASE WHEN SRA.RA_ADMISSA = '' "
_cQrySRA += " THEN ''   "
_cQrySRA += " ELSE SUBSTRING(SRA.RA_ADMISSA, 7, 2)+ '/' +SUBSTRING(SRA.RA_ADMISSA, 5, 2)+ '/' +SUBSTRING(SRA.RA_ADMISSA, 1, 4)  "
_cQrySRA += " END AS RA_ADMISSA, "
_cQrySRA += " SRA.RA_MOTIADM,"
_cQrySRA += " CASE WHEN SRA.RA_DEMISSA = '' "
_cQrySRA += " THEN '' "  
_cQrySRA += " ELSE SUBSTRING(SRA.RA_DEMISSA, 7, 2)+ '/' +SUBSTRING(SRA.RA_DEMISSA, 5, 2)+ '/' +SUBSTRING(SRA.RA_DEMISSA, 1, 4)  "
_cQrySRA += " END AS RA_DEMISSA," 
_cQrySRA += " CASE SRA.RA_SITFOLH " 
_cQrySRA += " WHEN 'F' THEN 'FERIAS' "                   	   
_cQrySRA += " WHEN 'D' THEN 'DEMITIDO' "                     
_cQrySRA += " WHEN 'A' THEN 'AFASTADO' "
_cQrySRA += " ELSE '' "
_cQrySRA += " END AS RA_SITFOLH,"
_cQrySRA += " RG_TIPORES, "
_cQrySRA += " SRA.RA_TNOTRAB,SRA.RA_EQUIPE,SRA.RA_ESCALA,SRA.RA_CODFUNC,SRA.RA_CC,CTT_DESC01,RA_CLVLDB,CTH_DESC01,SRA.RA_ITEMD,CTD_DESC01,SRA.RA_TELEFON,"
_cQrySRA += " SRA.RA_TELEFO2,SRA.RA_ENDEREC,SRA.RA_COMPLEM,"
_cQrySRA += " SRA.RA_BAIRRO,SRA.RA_MUNICIP, SRA.RA_CEP, SRA.RA_NACIONA,SRA.RA_XCELULA,SRA.RA_XAVAYA, "
_cQrySRA += " CASE WHEN SRA.RA_XULTDIA = ''  "
_cQrySRA += " THEN ''"   
_cQrySRA += " ELSE SUBSTRING(SRA.RA_XULTDIA, 7, 2)+ '/' +SUBSTRING(SRA.RA_XULTDIA, 5, 2)+ '/' +SUBSTRING(SRA.RA_XULTDIA, 1, 4)  "
_cQrySRA += " END AS RA_XULTDIA, "  
_cQrySRA += " CASE WHEN SRA.RA_XABANDO = ''   "
_cQrySRA += " THEN ''"  
_cQrySRA += " ELSE SUBSTRING(SRA.RA_XABANDO, 7, 2)+ '/' +SUBSTRING(SRA.RA_XABANDO, 5, 2)+ '/' +SUBSTRING(SRA.RA_XABANDO, 1, 4)  "  
_cQrySRA += " END AS RA_XABANDO, " 
_cQrySRA += " CASE WHEN SRA.RA_TERMTRE = ''      "
_cQrySRA += " THEN ''    "
_cQrySRA += " ELSE SUBSTRING(SRA.RA_TERMTRE, 7, 2)+ '/' +SUBSTRING(SRA.RA_TERMTRE, 5, 2)+ '/' +SUBSTRING(SRA.RA_TERMTRE, 1, 4)  "  
_cQrySRA += " END AS RA_TERMTRE,   "
_cQrySRA += "SRA.RA_CODSEQ "
/*_cQrySRA += " CASE WHEN ZM_FSUPER!='' "
_cQrySRA += " THEN (SELECT A.RA_CODSEQ FROM SRA050 AS A  WHERE A.RA_FILIAL= ZM_FSUPER AND A.RA_MAT=ZM_MSUPER AND A.D_E_L_E_T_='')  "
_cQrySRA += " END AS COD_SUPER, " 
_cQrySRA += " CASE WHEN ZM_FCOOR!='' " 
_cQrySRA += " THEN (SELECT A.RA_CODSEQ FROM SRA050 AS A  WHERE A.RA_FILIAL= ZM_FCOOR AND A.RA_MAT=ZM_MCOOR AND A.D_E_L_E_T_='')  "
_cQrySRA += " END AS COD_COORD,"  
_cQrySRA += " CASE WHEN ZM_FGEREN!=''  "
_cQrySRA += " THEN (SELECT A.RA_CODSEQ FROM SRA050 AS A  WHERE A.RA_FILIAL= ZM_FGEREN AND A.RA_MAT=ZM_MGEREN AND A.D_E_L_E_T_='') " 
_cQrySRA += " END AS COD_GEREN "*/
_cQrySRA += " FROM SRA050 AS SRA  "
_cQrySRA += " LEFT JOIN SZM050 ON ZM_COD = SRA.RA_EQUIPE AND SZM050.D_E_L_E_T_ = ''"  
_cQrySRA += " LEFT JOIN SRG050 ON SRA.RA_FILIAL = RG_FILIAL AND SRA.RA_MAT = RG_MAT AND SRG050.D_E_L_E_T_ = ''"
_cQrySRA += " LEFT JOIN CTT050 ON SRA.RA_CC = CTT_CUSTO AND CTT050.D_E_L_E_T_ = '' "  
_cQrySRA += " LEFT JOIN CTH050 ON SRA.RA_CLVLDB = CTH_CLVL AND CTH050.D_E_L_E_T_ = '' " 
_cQrySRA += " LEFT JOIN CTD050 ON SRA.RA_ITEMD = CTD_ITEM AND CTD050.D_E_L_E_T_ = '' "
_cQrySRA += " WHERE SRA.D_E_L_E_T_ = '' "
If !lFirstChrg
	_cQrySRA +="  AND (SRA.RA_DEMISSA = '' OR SRA.RA_DEMISSA BETWEEN '"+Dtos(_dData-20)+"' AND '"+Dtos(_dData)+"' ) "
EndIf
_cQrySRA += " GROUP BY SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_NOME,SRA.RA_SEXO,SRA.RA_NASC,SRA.RA_RG,SRA.RA_CIC,SRA.RA_ADMISSA, "
_cQrySRA += " SRA.RA_MOTIADM,SRA.RA_DEMISSA,RG_TIPORES,SRA.RA_TNOTRAB,SRA.RA_EQUIPE,SRA.RA_ESCALA,CTH_DESC01,SRA.RA_CC, "
_cQrySRA += " CTT_DESC01,SRA.RA_TELEFON,SRA.RA_TELEFO2,SRA.RA_ENDEREC,SRA.RA_COMPLEM,SRA.RA_BAIRRO,SRA.RA_MUNICIP,SRA.RA_CEP, "
_cQrySRA += " SRA.RA_NACIONA,SRA.RA_SITFOLH,SRA.RA_XCELULA,SRA.RA_XAVAYA,SRA.RA_CLVLDB,SRA.RA_ITEMD,CTD_DESC01,SRA.RA_XULTDIA, "
_cQrySRA += " SRA.RA_XABANDO, SRA.RA_TERMTRE,SRA.RA_CODSEQ,SRA.RA_CRACHA,SRA.RA_CODFUNC,SRA.R_E_C_N_O_,RA_CARGO "
_cQrySRA += " ORDER BY SRA.RA_CIC,SRA.R_E_C_N_O_ DESC "

dbUseArea( .T., 'TOPCONN', TcGenQry(,,_cQrySRA), cTmpSRA, .T., .F. ) 
								
bLinAfa := {|| cLin2 :=	 ChekAfast(_dData,cTmpSRA,dIniAfas,dFimAfas,cTipoAfas)}
								
(cTmpSRA)->( DbGoTop() )							
DbSelectArea("cTmpSRA")
GetXLS (cCmd,cCabSRA,cLinSRA,cLinAfa,cTmpSRA,_cArq,bLinSRA,bLinAfa)
cTmpSRA->( DbCloseArea() )								

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Geracsv   ºAutor  ³  Fernand Barreto   º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gera CSV                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10-CSU                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GetXLS(cCmd,cCab,cLin1,cLin2,_cAlias,cArq,bLin1,bLin2)
Local nTotReg:=0
Local cCPFant:=''
nHdl := fCreate(cCmd)
fWrite(nHdl,cCab,Len(cCab))
DbSelectArea(_cAlias)

While (_cAlias)->( !EOF() )
	if cCPFant != (_cAlias)->RA_CIC  	
		Eval(bLin1)
		Eval(bLin2)  	
		fWrite(nHdl,cLin1+cLin2,Len(cLin1+cLin2))		
	ENDIF
	cCPFant:=(_cAlias)->RA_CIC
	(_cAlias)->(dbSkip())	
EndDo
fClose(nHdl)
__CopyFile(cCmd, cArq)
RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChekAfast ºAutor  ³Fernando Barreto    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Verifica o afastamento se existir                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10-CSU                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChekAfast(_dData,_cAlias,dIniAfas,dFimAfas,cTipoAfas)

Local dIniAfas    := cTod("//")
Local dFimAfas    := cTod("//")
Local dIniFer     := cTod("//")
Local dFimfer     := cTod("//")
Local cLinAfas    := ""
Local cLinAfasRet := ""
Local cQueryAfa   := ""
Local cTmpAfa     := "cTmpAfa"
Local cTpafast    := ""      

fChkAfas((_cAlias)->Ra_Filial,(_cAlias)->Ra_Mat,_dData,@dIniAfas,@dFimAfas,@cTipoAfas)

If !Empty(dIniAfas) 
	If !Empty(dFimAfas)
		cLinAfas    := dTOS(dIniAfas)+Dtos(dFimAfas)
		cLinAfasRet := ';'+SUBSTR(cLinAfas, 7, 2)+'/'+SUBSTR(cLinAfas, 5, 2)+'/'+SUBSTR(cLinAfas, 1, 4)+';'+SUBSTR(cLinAfas, 15, 2)+'/'+SUBSTR(cLinAfas, 13, 2)+'/'+SUBSTR(cLinAfas, 9, 4) + CHR(13)+CHR(10)
	Else
		cLinAfas    := dTOS(dIniAfas)
		cLinAfasRet := ';'+SUBSTR(cLinAfas, 7, 2)+'/'+SUBSTR(cLinAfas, 5, 2)+'/'+SUBSTR(cLinAfas, 1, 4) + CHR(13)+CHR(10)
	EndIf	
Else
	cLinAfas    := ';'+""+';'+""+ CHR(13)+CHR(10)  
	cLinAfasRet := cLinAfas
EndIf

DbSelectArea(_cAlias)

Return(cLinAfasRet)
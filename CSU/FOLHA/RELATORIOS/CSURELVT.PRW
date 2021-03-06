#Include 'rwmake.ch'   
#include "apcfg40.ch"
#Include 'TopConn.ch' 

Static aAcessos
Static aModulos
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSURELVT  �Autor  	�Douglas David	 � Data �  17/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�rio de vale transporte - Tabela ZTB				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/
USER FUNCTION CSURELVT()

Local wnrel:= "CSURELVT"
Local cString  := ""
Local tamanho    := "G"
Local limite     := 132
Local titulo     := "Relatorio Vale Transporte"	
Local cDesc1     := "Este programa tem como objetivo a emissao de  relatorio  contendo  dados"
Local cDesc2     := "referente ao Vale Transporte, de acordo com os parametros informados"
Local cDesc3     := "pelo usuario. "
Local Pg		 := "CSUVT"

PRIVATE oExcelApp
PRIVATE _cData    := dtos(Date())
PRIVATE _cHora    := Time()
PRIVATE _cUsuario := cUserName
PRIVATE cPerg     := PADR("CSURELVT",LEN(SX1->X1_GRUPO))
PRIVATE _nLin     := 0
PRIVATE oPrint, oFont8, oFont10n, oFont8n
Private cFuncao     := " Processa( { || CSUPROGVT() }, 'Processando Relat�rio ...' ) "
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "

Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 } 
Private nomeprog := "CSURELVT"
Private nLastKey
Private cString  := ""
PRIVATE M_PAG	 :=1                


_fCriaSX1()
//�����������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                      �
//� mv_par01   Filial de 					                  �
//� mv_par02   Filial ate                   				  �
//� mv_par03   Matricula de                        			  �
//� mv_par04   Matricula ate			                      �
//� mv_par05   Ano/mes de                                     �    
//� mv_par06   Ano/mes ate                                    �
//� mv_par07   Gera Excel? 1 = SIM / 2 = NAO                  �
//�������������������������������������������������������������

Pergunte(cPerg,.F.)

Define MsDialog MkwDlg Title "Vale Transporte" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 020,015 Say "Relat�rio de Vale Transporte" Size 141,8
@ 030,015 Say "Este programa tem como objetivo a emiss�o de relat�rio"  Size 142,8    
@ 040,015 Say "contendo dados referente ao Vale Transporte, de acordo"  Size 142,8      
@ 050,015 Say "com os parametros informados pelo usuario."  Size 142,8
@ 020,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) )
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSUPROGVT  �Autor  �Douglas David      � Data �  17/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o de impress�o                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CSUPROGVT()

LOCAL _aArea      := GetArea()

IF MV_PAR07 == 1	
	Processa( { || ExpExcel() },'Exportacao para o Excel...' )  
ENDIF
 
oPrint := TmsPrinter():New('Relat�rio de Vale Transporte')


//���������������������������������������������������������������������������������������
//� Criando as Fontes Utilizadas pelo Relatorio.                                        �
//� Parametros do TFont.New(): 1.Nome Fonte (Windows), 3.Tamanho (Pixels), 5.Bold (T/F).�
//���������������������������������������������������������������������������������������
oFont8   := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8n  := TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oPrint:SetPortrait()
MsgRun('Gerando Visualiza��o, Aguarde...',"",{||CursorWait(),_fImprime(),CursorArrow()})
	oPrint:SetPortrait()

IF MV_PAR07 == 2	// Gera Excel = NAO
	oPrint:Preview()
ENDIF

RESTAREA(_aArea)

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fImprime �Autor  �Douglas David � Data �		  17/01/14    ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o de impress�o                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION _fImprime()
Local _aArea	 := GetArea()
Local _cQuery	 := ""
Local _lContinua := .T.
Local _cArqTrab	 := ""
Local _cEstrut	 := {}
Local _cCodUser	 := ""

ZTB->( DbSetOrder(3) )

If MV_PAR07 == 1
	AADD(_cEstrut, {"Filial"        ,"C", 02, 0})
	AADD(_cEstrut, {"Matricula"     ,"C", 06, 0}) 
	AADD(_cEstrut, {"Periodo"       ,"C", 01, 0})
	AADD(_cEstrut, {"Codigo"        ,"C", 02, 0})
	AADD(_cEstrut, {"Desc"   	    ,"C", 25, 0}) 
	AADD(_cEstrut, {"ValeDia"		,"N", 02, 0})
	AADD(_cEstrut, {"VlrVale"       ,"N", 12, 2})
	AADD(_cEstrut, {"TotVale"       ,"N", 12, 2}) 
	AADD(_cEstrut, {"Total"         ,"N", 12, 2})
Else
	AADD(_cEstrut, {"Filial"        ,"C", 02, 0})
	AADD(_cEstrut, {"Matricula"     ,"C", 06, 0}) 
	AADD(_cEstrut, {"Periodo"       ,"C", 01, 0})
	AADD(_cEstrut, {"Codigo"        ,"C", 02, 0})
	AADD(_cEstrut, {"Desc"   	    ,"C", 25, 0}) 
	AADD(_cEstrut, {"ValeDia"		,"N", 02, 0})
	AADD(_cEstrut, {"VlrVale"       ,"N", 12, 2})
	AADD(_cEstrut, {"TotVale"       ,"N", 12, 2}) 
	AADD(_cEstrut, {"Total"         ,"N", 12, 2})
EndIf

_cArqTrab := CriaTrab(_cEstrut,.T.)

//os 1193/14->busca o ultimo cadastro (MAX(ZTB_PERIOD)) + inclusao de Group By by Isamu
_cQuery := "SELECT DISTINCT ZTB_FILIAL, ZTB_MAT,  ZTB_COD, ZTB_DESC, ZTB_QDEDIA, ZTB_VLVALE, MAX(ZTB_PERIOD) AS PERIOD, " 
_cQuery += "(ZTB_QDEDIA * ZTB_VLVALE) AS TOTAL "
_cQuery += "FROM  "+RetSqlName('ZTB')+" ZTB "
_cQuery += "WHERE ZTB_MAT BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
_cQuery += "AND ZTB_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery += "AND ZTB_DATARQ BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
_cQuery += "AND ZTB.D_E_L_E_T_='' " 
_cQuery += "GROUP BY ZTB_FILIAL, ZTB_MAT,  ZTB_COD, ZTB_DESC, ZTB_QDEDIA, ZTB_VLVALE "
_cQuery += "ORDER BY ZTB_FILIAL, ZTB_MAT, ZTB_COD"

MemoWrit('CSURELVT.SQL',_cQuery)
TcQuery _cQuery New Alias 'QRY1'
dbUseArea(.T.,,_cArqTrab,'TRB1')

dbSelectArea('TRB1')
dbSelectArea('QRY1')
dbGoTop()
   WHILE QRY1->(!EOF())
   
	RECLOCK('TRB1',.T.)
	TRB1->Filial		:= QRY1->ZTB_FILIAL
	TRB1->Matricula  	:= QRY1->ZTB_MAT
	TRB1->Codigo		:= QRY1->ZTB_COD
	TRB1->Desc			:= QRY1->ZTB_DESC
	TRB1->ValeDia		:= QRY1->ZTB_QDEDIA
	TRB1->VlrVale		:= QRY1->ZTB_VLVALE
	TRB1->Total         := QRY1->TOTAL
	
	MsUnLock()    
	dbSelectArea('QRY1')
	QRY1->(DbSkip())
ENDDO             

dbSelectArea('TRB1')
dbGoTop()
IF MV_PAR07 == 2	// Gera Excel = NAO
	IF !EOF()
		_fCabec()
		WHILE !EOF()
			//����������������������������Ŀ
			//� Verifica Quebra de Pagina. �
			//������������������������������
			IF _nLin >= 6500
			   	_fRodaPe()
				_fCabec()
				_nLin := 380
			ENDIF
			oPrint:Say(_nLin,0100,Lower(Filial),oFont10)
			oPrint:Say(_nLin,0600,Matricula,oFont10)
			oPrint:Say(_nLin,1400,Codigo,oFont10)
			oPrint:Say(_nLin,2200,Desc ,oFont10)
			oPrint:Say(_nLin,2900,transform(ValeDia,"@E 99"),oFont10,100)  
			oPrint:Say(_nLin,3500,transform(VlrVale,"@E 9,999,999.99"),oFont10,100)  
			oPrint:Say(_nLin,4400,transform(Total,"@E 9,999,999.99"),oFont10,100)
			_nLin+=60
			dbSkip()   
				ENDDO

		_fRodaPe()
	ENDIF
//ELSE	// Gera Excel = SIM                                              
//	Processa( { || ExpExcel() },'Exportacao para o Excel...' )
ENDIF
//��������������������������������Ŀ
//� Fecha os Arquivos Temporarios. �
//����������������������������������
dbSelectArea('QRY1')
dbCloseArea()
dbSelectArea('TRB1')
dbCloseArea()
//�������������������������������Ŀ
//� Exclui o Arquivo de Trabalho. �
//���������������������������������
fErase(_cArqTrab+GetDbExtension())
RESTAREA(_aArea)

RETURN
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fCabec   �Autor  �Douglas David 		 � Data �  17/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para impress�o do cabe�alho                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _fCabec()
Local _cBitMap1	:=GetSrvProfString("StartPath","")+"lgrl"+SM0->M0_CODIGO+".BMP"  
//���������������Ŀ
//�Inicia a pagina�
//�����������������
oPrint:StartPage()
_nLin:=380
//����������������������Ŀ
//�Impress�o do cabe�alho�                 	
//������������������������
oPrint:Box(030,030,180,4850)	//box
oPrint:SayBitMap(040,0100,_cBitMap1,100,060) //logo da empresa
oPrint:Say(100,2425,oPrint:cDocument,oFont14N) //titulo 
oPrint:Say(100,100, _cUsuario, oFont8n)
oPrint:Say(100,300, "  /  Programa: CSURELVT", oFont8n)
oPrint:Say(130,100, "Hora...:", oFont8n) 
oPrint:Say(130,180, _cHora, oFont8n)
oPrint:Say(130,300, " /  Empresa: CSU", oFont8n)  
oPrint:Say(100,4500, "P�gina:", oFont8n) 
oPrint:Say(100,4700,str(oPrint:nPage,3),oFont8n)
oPrint:Say(130,4500, "Emiss�o:", oFont8n)   
oPrint:Say(130,4700, _cData, oFont8n)

oPrint:Say(200,0100,"Filial",oFont10) 
oPrint:Say(200,0500,"|",oFont10)
oPrint:Say(200,0600,"Matricula",oFont10)  
oPrint:Say(200,1100,"|",oFont10)
oPrint:Say(200,1400,"Codigo Meio Transp.",oFont10) 
oPrint:Say(200,2100,"|",oFont10)
oPrint:Say(200,2200,"Descri��o Meio Transp.",oFont10)
oPrint:Say(200,2800,"|",oFont10)
oPrint:Say(200,2900,"Qt. Vale Dia",oFont10) 
oPrint:Say(200,3400,"|",oFont10)
oPrint:Say(200,3500,"Valor Unit.",oFont10)      
oPrint:Say(200,3890,"|",oFont10)
oPrint:Say(200,4400,"Total",oFont10)
OPrint:Line(260,030,260,4850)
RETURN                                    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fRodape  �Autor  �Douglas David       � Data �  17/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para impress�o do rodape                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _fRodaPe()     
oPrint:EndPage()
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ExpExcel  �Autor  �Douglas David       � Data �  17/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Exporta os dados para o excel.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8-CSU                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ExpExcel()

Local nCnt := 0
Local wnrel:= "CSURELVT"
Local aCabExcel :={}
Local aItensExcel :={}


IF Select("CONS")>0
	CONS->(dbCloseArea())
Endif

cCONS :="SELECT DISTINCT ZTB_FILIAL, ZTB_MAT,  ZTB_COD, ZTB_DESC, ZTB_QDEDIA, ZTB_VLVALE,  "
cCONS +="(ZTB_QDEDIA * ZTB_VLVALE) AS TOTAL "
cCONS +="FROM  "+RetSqlName('ZTB')+" ZTB "                            	
cCONS +="WHERE ZTB_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cCONS +="AND ZTB_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cCONS +="AND ZTB_DATARQ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cCONS +="AND ZTB.D_E_L_E_T_='' "
cCONS +="ORDER BY ZTB_FILIAL, ZTB_MAT, ZTB_COD"

nCnt:= U_MontaView(cCons,"CONS")
DBSELECTAREA("CONS")
CONS->(dbGoTop())
ProcRegua(nCnt)                           	

WHILE !CONS->(eof())
	IncProc("Processando..."+CONS->ZTB_FILIAL+"-"+CONS->ZTB_MAT)
	cFil    := CONS->ZTB_FILIAL
	cMat	:= CONS->ZTB_MAT 
	cCod 	:= CONS->ZTB_COD
	cDesc	:= CONS->ZTB_DESC
	cQdedia := CONS->ZTB_QDEDIA                   
	cVlvale := CONS->ZTB_VLVALE  
	cTotal  := CONS->TOTAL
			                                                                                      
	AADD(aItensExcel,{cFil,cMat,cCod,cDesc,cQdedia,cVlvale,cTotal,})
	
	DBSKIP()
ENDDO
//CRIA CABECALHO
AADD(aCabExcel, {"Filial" ,"C", 02, 0})
AADD(aCabExcel, {"Matricula" ,"C", 06, 0}) 
AADD(aCabExcel, {"Codigo Meio Transp." ,"C", 02, 0})
AADD(aCabExcel, {"Descri��o Meio Transp." ,"C", 25, 0}) 
AADD(aCabExcel, {"Qt. Vale Dia" ,"C", 02, 0})
AADD(aCabExcel, {"Valor Unit." ,"C", 12, 2})
AADD(aCabExcel, {"Total" ,"C", 12, 2})

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
{||DlgToExcel({{"GETDADOS", "RELAT�RIO DE VALE TRANSPORTE", aCabExcel,aItensExcel}})})
return


If aReturn[5]== 1
	SET Print TO
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()

If !ApOleClient("MsExcel")
	MsgStop(OemToAnsi("MsExcel n�o instalado"))
	Return
Endif

Return nil  
return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fCriaSx1 �Autor  �Douglas David �       Data �  17/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para criacao das perguntas.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8- CSU                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _fCriaSx1()
SX1->(DbSetOrder(1))
If !SX1->(DbSeek(cPerg+"01",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Filial de:"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""	
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SM0"
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"02",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Filial ate:"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SM0"
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"03",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Matr�cula de:"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		:= "SRA"
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"04",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Matr�cula ate:"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		:= "SRA"
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"05",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Ano/mes de:"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()
EndIf 
If !SX1->(DbSeek(cPerg+"06",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Ano/mes ate:"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"07",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Gerar Excel ?"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "1"
	SX1->X1_TAMANHO := 01
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_DEF01   := "Sim"
	SX1->X1_DEF02   := "N�o"
	SX1->X1_F3		 := ""
	MsUnLock()
EndIf
RETURN                                                                                                                             	
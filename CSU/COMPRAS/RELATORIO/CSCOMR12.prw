#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSCOMR12  �Autor  � Renato Carlos      � Data �  Jun/2010   ���
�������������������������������������������������������������������������͹��
���Desc.     � RELATORIO DE PEDIDOS PENDENTES DE ELIMINACAO RESIDUO       ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU -                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSCOMR12()

Private nOpca       := 0
Private cCadastro   := "Geracao de Planilha com Pedidos Pendentes de Elimina��o de Res�duos"
Private aRegs := {}, aSays := {}, aButtons := {}
Private oExcelApp, cLin
Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cPerg       := PADR("CSCMR12",LEN(SX1->X1_GRUPO))
Private cFuncao     := " Processa( { || RCOMR12() }, 'Processando o Relatorio...' ) "
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
Private lSair       := .f.
Private wXP         := 0
Private oExcelApp

aAdd(aRegs,{cPerg,"01","Per�odo Elim. De        ","","","mv_ch1","D",08,0,0,"G","            ","mv_par01","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","","",""})
aAdd(aRegs,{cPerg,"02","Per�odo Elim. Ate       ","","","mv_ch2","D",08,0,0,"G","            ","mv_par02","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","","",""})
//aAdd(aRegs,{cPerg,"03","Numero de Periodos:     ","","","mv_ch3","N",05,0,0,"G","            ","mv_par03","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","","@E 9,999",""})
aAdd(aRegs,{cPerg,"03","Data para Refer�ncia    ","","","mv_ch3","D",08,0,0,"G","            ","mv_par03","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","","",""})
aAdd(aRegs,{cPerg,"04","Pedido De               ","","","mv_ch4","C",06,0,0,"G","            ","mv_par04","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SC7","","","","",""})
aAdd(aRegs,{cPerg,"05","Pedido Ate              ","","","mv_ch5","C",06,0,0,"G","            ","mv_par05","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SC7","","","","",""})
aAdd(aRegs,{cPerg,"06","Fornecedor De           ","","","mv_ch6","C",06,0,0,"G","            ","mv_par06","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
aAdd(aRegs,{cPerg,"07","Fornecedor Ate          ","","","mv_ch7","C",06,0,0,"G","            ","mv_par07","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
AADD(aRegs,{cPerg,"08","Utiliza Regra 6 Meses ? ","","","mv_ch8","N",01,0,0,"C",""            ,"mv_par08","Sim","","","","","N�o","","","","","","","","","","","","","","","","","","","","","","","",""})

nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")

U_ValidPerg( cPerg, aRegs )

If SX1->( DbSetOrder(1), DbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+'03') )
	SX1->( RecLock('SX1',.f.) )
	SX1->X1_CNT01 := Dtoc( Date() )
	SX1->( MsUnLock() )
EndIf

//                     10        20        30        40          10        20        30        40        10        20        30        40           10        20        30        40
//             123456789.123456789.123456789.123456789.  123456789.123456789.123456789.123456789.  123456789.123456789.123456789.123456789. 123456789.123456789.123456789.123456789.
aHelpP01 := { "Selecionar o per�odo inicial de elimina"," cao - Trar� os pedidos com emissao   " ," nesse per�odo" } // Portuga
aHelpP02 := { "Selecionar o per�odo final de eliminaca"," o - Trar� os pedidos com emissao     " ," nesse per�odo" } // Portuga
aHelpP03 := { "Informe aqui a data para refer�ncia p/ "," o ponto de partida - Essa data sera  " ,"a data base para o crit�rio de usado "," at� 6 meses  "} // Portuga
aHelpP04 := { "Informar o numero do pedido inicial   " } // Portuga
aHelpP05 := { "Informar o numero do pedido final     " }// Portuga
aHelpP06 := { "Informar o c�digo do fornecedor inicial"}// Portuga
aHelpP07 := { "Informar o c�digo do fornecedor final  "} // Portuga
aHelpP08 := { "Se N�o, desprezar� a data de refer�ncia"," e trar� todos os pedidos do per�odo  " ," informado que n�o foram utilizados totalmente"} // Portuga

For wXP := 1 To Len( aRegs )
	PutHelp("P."+Alltrim(cPerg)+StrZero(wXP,2)+".",&("aHelpP"+StrZero(wXP,2)),{},{},.T.)
Next

Pergunte(cPerg,.f.)

If nHdl = -1
	Aviso("EXCEL","Nao esta sendo possivel acessar o diretorio de arquivos temporarios de sua estacao.",;
	{"&Fechar"},3,"Geracao de Arquivo Excel",,;
	"PCOLOCK")
	Return
Endif

Define MsDialog MkwDlg Title "Rel Pedidos Pendentes de Elimina��o" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "Listagem dos Pedidos conforme os par�metros" Size 141,8
@ 045,015 Say "do usu�rio.: "  Size 142,8
@ 020,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) )
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCOMR12  �Autor  � Renato Carlos      � Data �  Jun/2010   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processamento do relatorio.                                ���
�������������������������������������������������������������������������͹��
���Uso       � RCOMR12                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RCOMR12()

Local _cSelect    := ""
Local c_Query     := ""
Local nCntQuery   := 0
Local dDtaNFE     := ""
Local cNumNFE     := ""
Local cLin        := ""
Private nHdl 	  := ''
//Private cEOL := CHR(13)+CHR(10), cLin := ''


_cSelect += "SELECT  "

_cSelect += " C1.C1_USER AS SOLICIT,   "   
_cSelect += " C7.C7_USER AS USERPED,           "
_cSelect += " C7.C7_NUM AS NUMERO,           "
_cSelect += " C7.C7_ITEM AS ITEM,           "
_cSelect += " C7.C7_FORNECE AS COD_FOR,      "
_cSelect += " A2.A2_NOME AS FORNECE,     "
_cSelect += " C7.C7_TOTAL AS TOTAL,     "
_cSelect += " C7.C7_PRECO AS VALOR,          "
_cSelect += " (C7.C7_PRECO * C7.C7_QUJE) AS UTILIZA,          "
_cSelect += " C7.C7_QUANT AS QUANT,      "
_cSelect += " C7.C7_EMISSAO AS EMISSAO,      "
_cSelect += " C7.C7_CONAPRO AS PEDSTATUS,      "
_cSelect += " (C7.C7_TOTAL - (C7.C7_PRECO * C7.C7_QUJE)) AS SALDO      "

_cSelect += " FROM "+RetSqlName("SC7")+" AS C7               "
_cSelect += " LEFT JOIN "+RetSqlName("SC1")+" AS C1 ON C7.C7_NUM = C1.C1_PEDIDO     "
_cSelect += "						AND C7.C7_NUMSC = C1.C1_NUM     "
_cSelect += "						AND C7.C7_ITEMSC = C1.C1_ITEM   "
_cSelect += " 						AND C1.D_E_L_E_T_ = ''                                    "

_cSelect += " LEFT JOIN "+RetSqlName("SA2")+" AS A2 ON C7.C7_FORNECE = A2.A2_COD " 
_cSelect += "						AND C7.C7_LOJA = A2.A2_LOJA   "
_cSelect += " 						AND A2.D_E_L_E_T_ = ''                                    "

_cSelect += " WHERE C7.C7_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
_cSelect += " AND C7.C7_NUM BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'      "
_cSelect += " AND C7.C7_FORNECE BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'      " 
_cSelect += " AND C7.C7_RESIDUO = ''                                   "
_cSelect += " AND C7.C7_ENCER = ''                                    "
_cSelect += " AND C7.D_E_L_E_T_ = ''                                    "
_cSelect += " AND C7.C7_QUANT <> C7.C7_QUJE                                 "
_cSelect += " ORDER BY C7.C7_NUM, C7.C7_ITEM  "

nCntView := U_MontaView(_cSelect,'Work')

Work->( DbGoTop() )

/*
�������������������������������������������������������Ŀ
� Gerar o cabecalho do arquivo HTML + os Estilos CSS    �
���������������������������������������������������������
*/

Rctbr01b()

ProcRegua( nCntView )

While !Work->( Eof() )
	
	IncProc()
           
    c_Query     := ""
    c_Query     += " SELECT TOP 1 D1_EMISSAO, D1_DOC "
    c_Query     += " FROM "+RetSqlName("SD1")+"  " 
    c_Query     += " WHERE D1_PEDIDO = '"+Work->NUMERO+"' "
    c_Query     += " AND D1_ITEMPC = '"+Work->ITEM+"' "
	c_Query     += " AND D_E_L_E_T_ = ''                   "
	c_Query     += " ORDER BY D1_EMISSAO DESC              "

	nCntQuery := U_MontaView( c_Query, 'Work2' )
	
	DbSelectArea('Work2')		
	Work2->( DbGoTop() )
	
	If nCntQuery > 0
		cNumNFE := 	Work2->D1_DOC
		dDtaNFE := 	Work2->D1_EMISSAO
	EndIf
	
	If MV_PAR08 == 1
		If !Empty(dDtaNFE)
			If (MV_PAR03-180) < STOD(dDtaNFE)  //Verifica se a Nota tem mais que 6 meses da data informada no parametro
				DbSelectArea('Work')
				Work->( DbSkip() )
	   			cNumNFE := 	""
				dDtaNFE := 	""
	   			Loop
			EndIf
		EndIf
	EndIf    

	DbSelectArea('Work')
	
	cLin += "<td class=xl3431556 style='border-left:none'>"+Work->NUMERO+"</td> "
	cLin += "<td class=xl3431556 style='border-left:none'>"+Work->ITEM+"</td> "
  	cLin += "<td class=xl3331556 style='border-left:none'>"+DTOC(STOD(Work->EMISSAO))+"</td> "
	cLin += "<td class=xl3431556 style='border-left:none'>"+Work->COD_FOR+"</td> "
	cLin += "<td class=xl3431556 style='border-left:none'>"+Work->FORNECE+"</td> "
	cTmp := StrTran( Transform(Work->TOTAL,"@E 999,999,999.99"),".","" )
	cTmp := StrTran( cTmp,",","" )
    cLin += "<td class=xl3331556 style='border-left:none'>"+Transform( Val(cTmp)/100,"@E 999,999,999.99" )+"</td> "
    cTmp := StrTran( Transform(Work->UTILIZA,"@E 999,999,999.99"),".","" )
	cTmp := StrTran( cTmp,",","" )
    cLin += "<td class=xl3331556 style='border-left:none'>"+Transform( Val(cTmp)/100,"@E 999,999,999.99" )+"</td> "
    cTmp := StrTran( Transform(Work->SALDO,"@E 999,999,999.99"),".","" )
	cTmp := StrTran( cTmp,",","" )
    cLin += "<td class=xl3331556 style='border-left:none'>"+Transform( Val(cTmp)/100,"@E 999,999,999.99" )+"</td> "
 	If !Empty(Work->SOLICIT)
 	 	cLin += "<td class=xl3431556 style='border-left:none'>"+UsrFullName(Work->SOLICIT)+"</td> "
    Else
    	cLin += "<td class=xl3431556 style='border-left:none'>"+UsrFullName(Work->USERPED)+"</td> "
    EndIf
   	cLin += "<td class=xl3431556 style='border-left:none'>"+DTOC(STOD(dDtaNFE))+"</td> "
   	cLin += "<td class=xl3431556 style='border-left:none'>"+cNumNFE+"</td> "
	cLin += "<td class=xl3431556 style='border-left:none'>"+U_CSVLDAPROV(Work->NUMERO,Work->PEDSTATUS)+"</td> " // Fun��o criada para verificar o status da aprova��o
		
	// Grava linha a linha no arquivo XLS
	xAddToFile( cLin, cCmd )
	
	cLin := " 	  <tr height=17 style='height:12.75pt'> "
	cLin += " 	  <td height=17 class=xl2531556 style='height:12.75pt'></td> "
	
	cNumNFE := 	""
	dDtaNFE := 	""
	Work->( DbSkip() )
	Work2->(DbCloseArea())
EndDo

/*
�������������������������������������������������������Ŀ
� Finalizar a gravacao do Excel                         �
���������������������������������������������������������
*/

cLin += " </table> "
cLin += " </div> "
cLin += " </body> "
cLin += " </html> "

xAddToFile( cLin, cCmd )

CpyS2T(cDirDocs+"\"+cArquivo+".xls",cTempPath,.T.)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".xls")
oExcelApp:SetVisible(.T.)

Ferase( cDirDocs+"\"+cArquivo+".xls" )

Work->(DbCloseArea())

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAddToFile�Autor  � Sergio Oliveira    � Data �  Set/2007   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona a linha de log ao fim de um arquivo.               ���
�������������������������������������������������������������������������͹��
���Uso       � Rctbr01.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

*/

Static Function xAddToFile( cLog, cToFile )

Local nHdl  := -1
Local cBuff := cLog

If File( cToFile )
	
	nHdl := FOpen( cToFile, 1 )
	
	If nHdl >= 0
		
		FSeek( nHdl, 0, 2 )
		
	EndIf
	
Else
	
	nHdl := FCreate( cToFile )
	
EndIf

If nHdl >= 0
	
	FWrite( nHdl,  cBuff, Len( cBuff ) )
	
EndIf

FClose( nHdl )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Rctbr01b�Autor  � Sergio Oliveira    � Data �  Set/2007   ���
�������������������������������������������������������������������������͹��
���Desc.     �             ���
�������������������������������������������������������������������������͹��
���Uso       � Rctbr01.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

*/
Static Function Rctbr01b()

Local cGrvBuff := ''

cGrvBuff += ' <html xmlns:v="urn:schemas-microsoft-com:vml" ' '
cGrvBuff += ' xmlns:o="urn:schemas-microsoft-com:office:office" '
cGrvBuff += ' xmlns:x="urn:schemas-microsoft-com:office:excel" '
cGrvBuff += ' xmlns="http://www.w3.org/TR/REC-html40"> '
cGrvBuff += ' <head> '
cGrvBuff += ' <meta http-equiv=Content-Type content="text/html; charset=windows-1252"> '
cGrvBuff += ' <meta name=ProgId content=Excel.Sheet> '
cGrvBuff += ' <meta name=Generator content="Microsoft Excel 11"> '
cGrvBuff += ' <link rel=File-List href="sc356290_arquivos/filelist.xml"> '
cGrvBuff += ' <style> '
cGrvBuff += ' v\:* {behavior:url(#default#VML);} '
cGrvBuff += ' o\:* {behavior:url(#default#VML);} '
cGrvBuff += ' x\:* {behavior:url(#default#VML);} '
cGrvBuff += ' .shape {behavior:url(#default#VML);} '
cGrvBuff += ' </style> '
cGrvBuff += ' <style id="Pedidos  BackLog1_31556_Styles"> '
cGrvBuff += ' <!--table '
cGrvBuff += ' 	{mso-displayed-decimal-separator:"\,"; '
cGrvBuff += ' 	mso-displayed-thousand-separator:"\.";} '
cGrvBuff += ' .xl1531556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:400; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial; '
cGrvBuff += ' 	mso-generic-font-family:auto; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:General; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' .xl2231556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:700; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial, sans-serif; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:General; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '
cGrvBuff += ' .xl2331556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:700; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial, sans-serif; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:"Short Date"; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' .xl2431556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:400; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial; '
cGrvBuff += ' 	mso-generic-font-family:auto; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;}  '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl2531556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl2631556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl2731556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl2831556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:right; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; ' '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl2931556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl3031556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl3131556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3231556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"d\/mmm"; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom;  '
cGrvBuff += ' 			border:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 		.xl3331556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"d\/mmm"; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3431556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 		.xl3531556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:general; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3631556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 			text-align:right; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 		.xl3731556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:700; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial, sans-serif; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:middle; '
cGrvBuff += ' 			border-top:1.0pt solid windowtext; '
cGrvBuff += ' 			border-right:.5pt solid windowtext; '
cGrvBuff += ' 			border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 			border-left:1.0pt solid windowtext; '
cGrvBuff += ' 			background:#99CCFF; '
cGrvBuff += ' 			mso-pattern:auto none; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 			.xl3831556 '
cGrvBuff += ' 				{padding:0px; '
cGrvBuff += ' 				mso-ignore:padding; '
cGrvBuff += ' 				color:windowtext; '
cGrvBuff += ' 				font-size:10.0pt; '
cGrvBuff += ' 				font-weight:700; '
cGrvBuff += ' 				font-style:normal; '
cGrvBuff += ' 				text-decoration:none; '
cGrvBuff += ' 				font-family:Arial, sans-serif; '
cGrvBuff += ' 				mso-font-charset:0; '
cGrvBuff += ' 				mso-number-format:General; '
cGrvBuff += ' 				text-align:center; '
cGrvBuff += ' 				vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '
cGrvBuff += ' 				.xl3931556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 				.xl4031556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '
cGrvBuff += ' 				.xl4131556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:General; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:1.0pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' .xl4231556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 		text-align:center; '
cGrvBuff += ' 		vertical-align:middle; '
cGrvBuff += ' 		border-top:1.0pt solid windowtext; '
cGrvBuff += ' 		border-right:.5pt solid windowtext; '
cGrvBuff += ' 		border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 		border-left:.5pt solid windowtext; '
cGrvBuff += ' 		background:#99CCFF; '
cGrvBuff += ' 		mso-pattern:auto none; '
cGrvBuff += ' 		white-space:normal;} '
cGrvBuff += ' 	.xl4331556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border-top:none; '
cGrvBuff += ' 		border-right:.5pt solid silver; '
cGrvBuff += ' 		border-bottom:.5pt solid silver; '
cGrvBuff += ' 		border-left:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl4431556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:18.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl4531556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0_\)\;_\(* \\\(\#\,\#\#0\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl4631556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl4731556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"0\.0%"; '
cGrvBuff += ' 		text-align:right; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	--> '
cGrvBuff += ' 	</style> '
cGrvBuff += ' 	</head> '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += " 	<body> "
cGrvBuff += " 	<table x:str border=0 cellpadding=0 cellspacing=0 width=1171 style='border-collapse: "
cGrvBuff += " 	 collapse;table-layout:fixed;width:880pt'> "
cGrvBuff += " 	 <col class=xl2531556 width=26 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 950;width:20pt'> "
cGrvBuff += " 	 <col width=90 span=2 style='mso-width-source:userset;mso-width-alt:3291; "
cGrvBuff += " 	 width:68pt'> "
cGrvBuff += " 	 <col width=306 style='mso-width-source:userset;mso-width-alt:11190;width:230pt'> "
cGrvBuff += " 	 <col width=80 style='mso-width-source:userset;mso-width-alt:2925;width:60pt'> "
cGrvBuff += " 	 <col width=92 style='mso-width-source:userset;mso-width-alt:3364;width:69pt'> "
cGrvBuff += " 	 <col class=xl2631556 width=95 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 3474;width:71pt'> "
cGrvBuff += " 	 <col class=xl2431556 width=95 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 3474;width:71pt'> "
cGrvBuff += " 	 <col width=89 style='mso-width-source:userset;mso-width-alt:3254;width:67pt'> "
cGrvBuff += " 	 <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'> "
cGrvBuff += " 	 <col class=xl2431556 width=95 span=2 style='mso-width-source:userset; "
cGrvBuff += " 	 mso-width-alt:3474;width:71pt'> "

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += " 	 <tr height=17 style='height:12.75pt'> "
cGrvBuff += " 	  <td height=17 class=xl2531556 width=26 style='height:12.75pt;width:20pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=90 style='width:68pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=90 style='width:68pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=306 style='width:230pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=80 style='width:60pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=92 style='width:69pt'></td> "
cGrvBuff += " 	  <td class=xl2631556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=89 style='width:67pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=18 style='width:14pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=31 style='height:23.25pt'> "
cGrvBuff += " 	  <td height=31 class=xl2531556 style='height:23.25pt'></td> "

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += " 	  <td class=xl4431556 colspan=3>Rela��o Pedidos Pendentes de Eliminacao</td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=20 style='mso-height-source:userset;height:15.0pt'> "
cGrvBuff += " 	  <td height=20 class=xl2531556 style='height:15.0pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=18 style='height:13.5pt'> "
cGrvBuff += " 	  <td height=18 class=xl2531556 style='height:13.5pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr class=xl2231556 height=44 style='mso-height-source:userset;height:33.0pt'> "
cGrvBuff += " 	  <td height=44 class=xl2531556 style='height:33.0pt'></td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Numero</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Item</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Emissao</td> " 
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Cod Fornece</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Fornecedor</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Total Pedido</td> " 
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Utilizado</td> " 
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Saldo</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Solicitante</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Ult. Utiliza��o</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Num. NF</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Status</td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	  <tr height=17 style='height:12.75pt'> "
cGrvBuff += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "

xAddToFile( cGrvBuff, cCmd )

Return

#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include 'TopConn.ch'
#Define _cEnter Chr(13) + Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±			                                                               ±±
±± Funcao: RCOMBASE 	Autor: Tatiana A. Barbosa	Data: 18/10/10	       ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±						  												   ±±
±±	Descricao: Relatorio com dados conforme tela de Base Line de Compras   ±± 
±±					 		OS 2621/10									   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 																		   ±±
±±			Alteracoes: 											 	   ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±															  			   ±±
±±				Uso:  CSU 	                                               ±±
±±												  						   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RCOMBASE()

If !ApOleClient("MsExcel")
	Aviso("100 EXCEL","O MS Excel não encontra-se instalado nesta estação.",;
					{"&Fechar"},3,"Excel não Instalado",,;
					"PCOLOCK")
	Return
Endif

Private nOpca       := 0
Private cCadastro   := "Relatório de Saving por Pedido"
Private aRegs := {}, aSays := {}, aButtons := {}
Private oExcelApp, cLin
Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cPerg       := PADR("RCOMR4",LEN(SX1->X1_GRUPO))
Private cFuncao     := " Processa( { || CursorWait(), RCOMBASEA(), CursorArrow() }, 'Efetuando os Filtros, Aguarde...' ) "
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
Private lSair       := .f.

aAdd(aRegs,{cPerg,"01","Data de Emissao De....:","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data de Emissao Ate...:","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Pedido(Branco = Todos):","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")

U_ValidPerg( cPerg, aRegs )

Pergunte(cPerg,.f.)

If nHdl = -1
	Aviso("EXCEL","Nao esta sendo possivel acessar o diretorio de arquivos temporarios de sua estacao.",;
					{"&Fechar"},3,"Geracao de Arquivo Excel",,;
					"PCOLOCK")
	Return
Endif

Define MsDialog MkwDlg Title "Relatório de Saving por Pedido" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "Esta rotina tem como objetivo gerar um arquivo no formato" Size 141,8
@ 045,015 Say "excel dos Pedidos de Compras com seus respectivos"         Size 142,8
@ 055,015 Say "Savings.   Base Line e Racional. " 						  Size 143,8
@ 020,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) ) 
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: RCOMBASEA 	Autor: Tatiana A. Barbosa	Data: 18/10/10	       ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: Processamento do Relatório								   ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RCOMBASEA()

Local cSelect,cQuery2, cLin := ""
Local cEol := Chr(13)+Chr(10)
Local aStru
Local _cGrpComp := ""

SB1->( DbSetOrder(1) )

ChkFile('ZA7')

cSelect := " SELECT C7_X_CAPEX,C7_USER,C7_NUM, A2_NOME,C7_FORNECE,C7_LOJA, C7_COND, E4_DESCRI, SUM(C7_TOTAL) AS TOTPED, SUM( C7_VLDESC ) AS SAVING"
cSelect += " FROM "+RetSqlName('SC7') + " AS SC7, " +RetSqlName('SA2') + " AS SA2, " +RetSqlName('SE4') + " AS SE4 "
cSelect += " WHERE C7_FILIAL  =  '"+xFilial('SC7')+"' "
If !Empty( MV_PAR03 )
    cSelect += " AND C7_NUM = '"+MV_PAR03+"' "
EndIf
cSelect += " AND   C7_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
cSelect += " AND   SC7.D_E_L_E_T_ = ' ' "
cSelect += " AND   A2_FILIAL  =  '"+xFilial('SA2')+"' "
cSelect += " AND   A2_COD  =  C7_FORNECE " 
cSelect += " AND   A2_LOJA  =  C7_LOJA "   
cSelect += " AND   E4_CODIGO  =  C7_COND "   
cSelect += " AND   SA2.D_E_L_E_T_ = ' ' "
cSelect += " AND   SE4.D_E_L_E_T_ = ' ' "
cSelect += " GROUP BY C7_X_CAPEX,C7_USER,C7_NUM, A2_NOME,C7_FORNECE,C7_LOJA,C7_COND,E4_DESCRI"

nCntView := U_MontaView( cSelect, 'Work' )

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Efetuar a compatibilizacao de campos Data e Numericos ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
  
TcSetField( 'Work', "TOTPED"    , "N", 14,02 )
TcSetField( 'Work', "SAVING"    , "N", 14,02 )

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Gerar o cabecalho do arquivo HTML + os Estilos CCS    ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

RCOMBASEB()

DbSelectArea( 'Work' )
DbGoTop()
ProcRegua( nCntView )

While Work->(!Eof())
	
		cQuery2 := " SELECT TOP 1 C7_PRODUTO "
		cQuery2 += " FROM "+RetSqlName('SC7')+" "
		cQuery2 += " WHERE C7_NUM = '"+Work->C7_NUM+"' "
		cQuery2 += " AND   D_E_L_E_T_ = ' ' "
		cQuery2 += " GROUP BY C7_PRODUTO "
		U_MontaView( cQuery2, 'WorkIII' )
		WorkIII->( DbGoTop() )	
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca o grupo de compras - OS 2988/10                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !WorkIII->( Eof() )
		If (SB1->(dbSeek(xFilial('SB1')+WorkIII->C7_PRODUTO)))
   		_cGrpComp := SB1->B1_GRUPCOM
   		EndIf
   	EndIf	
	
	
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Obter a ultima sequencia da digitacao do Saving:      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
  
    cSelect := " SELECT MAX(R_E_C_N_O_) AS REG FROM "+RetSqlName('ZA7')
    cSelect += " WHERE ZA7_FILIAL = '"+xFilial('ZA7')+"' "
    cSelect += " AND   ZA7_PEDIDO = '"+Work->C7_NUM+"' "
    cSelect += " AND   D_E_L_E_T_ = ' ' "
    
    U_MontaView( cSelect, 'WorkII' )
    
    WorkII->( DbGoTop() )
    
    If WorkII->REG > 0
    
        ZA7->( DbGoTo( WorkII->REG ) )
        
  	    cLin += "<td class=xl3431556 style='border-left:none'>"+Work->C7_NUM+"</td> "
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_FORNECE)+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_LOJA)+"</td> "// OS 0927/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->A2_NOME)+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+UsrFullName(Work->C7_USER)+"</td>"// OS 2899/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_X_CAPEX)+"</td> "//0875-11
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cGrpComp)+"</td> "// OS 2899/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_COND)+"</td> "// OS 2326/11
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->E4_DESCRI)+"</td> "// OS 2326/11
        cLin += "<td class=xl3331556 style='border-left:none'>"+Transform(ZA7->ZA7_BASELI, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+Transform(Work->TOTPED, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Transform(ZA7->ZA7_BASELI-Work->TOTPED, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+Transform(ZA7->ZA7_RACION, "@E 999,999,999.99")+"</td>"
        cLin += "<td class=xl3531556 style='border-left:none'>"+ZA7->ZA7_CLASSI+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+ZA7->ZA7_DESCRI+"</td> </tr>  "// OS 2899/10
     

    Else
       
  	    cLin += "<td class=xl3431556 style='border-left:none'>"+Work->C7_NUM+"</td> "
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_FORNECE)+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_LOJA)+"</td> "// OS 0927/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->A2_NOME)+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+UsrFullName(Work->C7_USER)+"</td>"
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_X_CAPEX)+"</td> "//0875-11
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cGrpComp)+"</td> "// OS 2899/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_COND)+"</td> "// OS 2326/11
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->E4_DESCRI)+"</td> "// OS 2326/11
        cLin += "<td class=xl3331556 style='border-left:none'>"+Transform(0, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+Transform(Work->TOTPED, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Transform(WORK->SAVING, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+Transform(0, "@E 999,999,999.99")+"</td></tr> "

    EndIf

    // Grava linha a linha no arquivo XLS

    RCOMBASEC( cLin, cCmd )

    cLin := " 	  <tr height=17 style='height:12.75pt'> "
    cLin += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "

	IncProc('Gerando Excel....')

	Work->(DbSkip())
	_cGrpComp := ""
EndDo

// finaliza gravacao do arquivo excel

cLin += " </table> "
cLin += " </div> "
cLin += " </body> "
cLin += " </html> "

// Grava linha a linha no arquivo XLS

RCOMBASEC( cLin, cCmd )

CpyS2T(cDirDocs+"\"+cArquivo+".xls",cTempPath,.T.)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".xls")
oExcelApp:SetVisible(.T.)

If Select( 'WorkII' ) > 0
	WorkII->( DbCloseArea() )
EndIf

If Select( 'WorkIII' ) > 0
	WorkIII->( DbCloseArea() )
EndIf
Ferase( cDirDocs+"\"+cArquivo+".xls" )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: RCOMBASEC 	Autor: Tatiana A. Barbosa	Data: 18/10/10	       ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: Adiciona a linha de log ao fim de um arquivo.			   ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RCOMBASEC( cLog, cToFile )

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

Static Function RCOMBASEB()

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd )
 
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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd )

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

RCOMBASEC( cGrvBuff, cCmd )

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd )

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd )

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd )

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd )

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd ) 

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

RCOMBASEC( cGrvBuff, cCmd ) 

cGrvBuff += " 	  <td class=xl4431556 colspan=3>Relatório de Saving por Pedido</td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=20 style='mso-height-source:userset;height:15.0pt'> "
cGrvBuff += " 	  <td height=20 class=xl2531556 style='height:15.0pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=18 style='height:13.5pt'> "
cGrvBuff += " 	  <td height=18 class=xl2531556 style='height:13.5pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr class=xl2231556 height=44 style='mso-height-source:userset;height:33.0pt'> "
cGrvBuff += " 	  <td height=44 class=xl2531556 style='height:33.0pt'></td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Nº do Pedido</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Fornecedor</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Loja</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>R Social</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Comprador</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Origem</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Grupo Compras</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Cond.Pagto.</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Desc.Cond.Pagto.</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Base Line</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Valor</td> "
cGrvBuff += " 	  <td class=xl4031556 style='border-left:none'>Savings</td> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Racional Base Line<br> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Classificacao<br> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Justificativa<br> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	  <tr height=17 style='height:12.75pt'> "
cGrvBuff += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "

RCOMBASEC( cGrvBuff, cCmd ) 

Return  

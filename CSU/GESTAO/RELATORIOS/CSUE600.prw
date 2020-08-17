#include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ FERA001  ³ Autor ³ Microsiga               ³ Data ³ 08/07/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exportacao de contratos para excel.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ Gestao de contratos - CSU                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.  ³  Data  ³ Bops ³ Manutencao Efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                  

User Function CSUE600()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea     := GetArea()
Local aSay      := {}
Local aButton   := {}
Local nOpc      := 0
Local cPerg	    := "CSE600"
Local cTitulo   := "Exportação de Contratos para Excel - Gestão de Contratos"
Local cDesc1    := "Esta rotina tem como objetivo realizar a exportação das "
Local cDesc2    := "informações dos contratos existentes no sistema para  "
Local cDesc3    := "arquivo excel (.xls), conforme parâmetros informados "
Local cDesc4    := "pelo usuário."   
Local nQtdReg   := 0  // qtde de registros na tabela auxiliar     
Local aAllUsr   := {} // vetor com todos os usuarios e detalhes
Local aList     := {} // vetor para pesquisa dos usuarios 
Local nMaxPar   := 0  // maximo de parcelas 
Local aVetCont	:= {} // vetor com dados alguns dados somados por contrato
Local aCompete	:= {} // vetor com as competencias dos contrados   
Local aVlrComp	:= {} // vetor com valores das competencias

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                          ³
//³ Mv_Par01           // Contrato de                             ³
//³ Mv_Par02           // Contrato ate                            ³
//³ Mv_Par03           // Data inicio de                          ³
//³ Mv_Par04           // Data inicio ate                         ³
//³ Mv_Par05           // Data fim de                             ³
//³ Mv_Par06           // Data fim ate                            ³
//³ Mv_Par07           // Fornecedor de                           ³
//³ Mv_Par08           // Fornecedor ate                          ³
//³ Mv_Par09           // Loja Fornec. de                         ³
//³ Mv_Par10           // Loja Fornec. ate                        ³
//³ Mv_Par11           // Cliente de                              ³
//³ Mv_Par12           // Cliente ate                             ³
//³ Mv_Par13           // Loja Cliente de                         ³
//³ Mv_Par14           // Loja Cliente ate                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSx1(cPerg)
Pergunte(cPerg,.F.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando array com descricao do programa para adicionar no FormBatch.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando array com botoes do FormBatch.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg)			}}) //Parametros
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}}) //OK
aAdd( aButton, { 2, .T., {|| nOpc := 2, FechaBatch()	}}) //Cancelar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que ativa o FormBatch.                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1 // cancelou a rotina
	RestArea( aArea )
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta tabela auxiliar.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgRun("Filtrando registros, aguarde ...",,{|| CriaTRB(@nQtdReg,@nMaxPar,@aVetCont,@aCompete,@aVlrComp) })  

If nQtdReg == 0
	MsgAlert( "Não existem registros para gerar a exportação. Verifique os parâmetros" , "ATENÇÃO" )
	TRB->( dbCloseArea() )
	RestArea( aArea )
	return
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta vetor com usuarios.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgRun("Ajustando vetor de usuários, aguarde ...",,{|| MontaVet(@aAllUsr,@aList) })  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. Gera planilha de contratos em excel.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| GeraPlan(aList,nMaxPar,aVetCont,aCompete,aVlrComp) }, "Aguarde...","Gerando exportação para excel.", .T. )

If Select("TRB") > 0
	TRB->( dbCloseArea() )
endif
RestArea( aArea )
Return               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³GeraPlan  ³ Autor ³Microsiga                ³ Data ³ 10/07/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera planilha de contratos em excel.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraPlan(aList,nMaxPar,aVetCont,aCompete,aVlrComp)

Local nPos     := 0
Local nI       := 0 
Local nY	   := 0
Local nReajus  := 0  // valor do reajuste
Local dtRevis  := CtoD("  /  /  ") //data revisao
Local cSolici  := "" //solicitante
Local cGestor  := "" //gestor
Local cGerTec  := "" //gestor tecnico cad. de aprovadores
Local cGerPro  := "" //gestor procurement cad. de aprovadores
Local cTpCont  := "" //Tipo do contrato
Local cContra  := "" //numero contrato  
Local cRevisa  := "" //revisao do contrato
Local cCodPla  := "" //codigo do planilha
Local cCronog  := "" //codigo do cronograma 
Local nPar     := 0
Local nQtdMed  := 0  //Quantidade de medicoes
Local nVlrMed  := 0  //Valor das medicoes
Local nSldCont := 0  //saldo do contrato
Local nPerComp := 0  //percentual comprometido do contrato
Local nNaoMed  := 0  //qtd de meses nao medidos

Local cPath   	:= "C:\"	// Parametro que indica qual o diretorio de gravacao sera exportado.
Local lRet		:= .F.		// Retorno da funcao
Local cArqPesq 	:= ""		// Nome do arquivo que foi gerado
Local nHandle	:= 0		// Indicador de arquivo de exportacao aberto

Local cCabec    := "" 
Local cHtml     := "" 
Local cRodap    := "" 

Local lLoop		:= .F.
	
cPath := cGetFile("","Local para gravacäo...",1,,.F.,GETF_LOCALHARD+GETF_RETDIRECTORY ) //"Local para gravação..."

If Empty(cPath)
	MsgAlert( "Diretório não Informado! Não foi possível gravar o arquivo!" , "ATENÇÃO" )
	Return
EndIf

cArqPesq := cPath + "Contratos" + ".xls"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria um arquivo do tipo *.xls	                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := FCREATE(cArqPesq, 0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o arquivo pode ser criado, caso contrario um alerta sera exibido      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FERROR() != 0
	Alert("Não foi possível abrir ou criar o arquivo.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contador da barra de progresso                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua( Len(aVetCont) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta html para gerar arquivo .xls                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCabec += '	<html xmlns:o="urn:schemas-microsoft-com:office:office"										' + CHR(13) + CHR(10)
cCabec += '	xmlns:x="urn:schemas-microsoft-com:office:excel"											' + CHR(13) + CHR(10)
cCabec += '	xmlns="http://www.w3.org/TR/REC-html40">													' + CHR(13) + CHR(10)
cCabec += '	<head>																						' + CHR(13) + CHR(10)
cCabec += '	<meta http-equiv=Content-Type content="text/html; charset=windows-1252">					' + CHR(13) + CHR(10)
cCabec += '	<meta name=ProgId content=Excel.Sheet>										' + CHR(13) + CHR(10)
cCabec += '	<meta name=Generator content="Microsoft Excel 11">								' + CHR(13) + CHR(10)
cCabec += '	<link rel=File-List href="Base2_arquivos/filelist.xml">								' + CHR(13) + CHR(10)
cCabec += '	<link rel=Edit-Time-Data href="Base2_arquivos/editdata.mso">							' + CHR(13) + CHR(10)
cCabec += '	<link rel=OLE-Object-Data href="Base2_arquivos/oledata.mso">							' + CHR(13) + CHR(10)
cCabec += '	<!--[if gte mso 9]><xml>											' + CHR(13) + CHR(10)
cCabec += '	 <o:DocumentProperties>												' + CHR(13) + CHR(10)
cCabec += '	  <o:Author>CS08433</o:Author>											' + CHR(13) + CHR(10)
cCabec += '	  <o:LastAuthor>darlan.maciel</o:LastAuthor>									' + CHR(13) + CHR(10)
cCabec += '	  <o:LastPrinted>2008-06-30T12:42:18Z</o:LastPrinted>								' + CHR(13) + CHR(10)
cCabec += '	  <o:Created>2008-06-30T12:30:37Z</o:Created>									' + CHR(13) + CHR(10)
cCabec += '	  <o:LastSaved>2008-07-08T19:10:56Z</o:LastSaved>								' + CHR(13) + CHR(10)
cCabec += '	  <o:Company>CSU CARDSYSTEM S/A</o:Company>									' + CHR(13) + CHR(10)
cCabec += '	  <o:Version>11.9999</o:Version>										' + CHR(13) + CHR(10)
cCabec += '	 </o:DocumentProperties>											' + CHR(13) + CHR(10)
cCabec += '	</xml><![endif]-->												' + CHR(13) + CHR(10)
cCabec += '	<style>														' + CHR(13) + CHR(10)
cCabec += '	<!--table													' + CHR(13) + CHR(10)
cCabec += '		{mso-displayed-decimal-separator:"\,";									' + CHR(13) + CHR(10)
cCabec += '		mso-displayed-thousand-separator:"\.";}									' + CHR(13) + CHR(10)
cCabec += '	@page														' + CHR(13) + CHR(10)
cCabec += '		{margin:.98in .79in .98in .79in;									' + CHR(13) + CHR(10)
cCabec += '		mso-header-margin:.49in;										' + CHR(13) + CHR(10)
cCabec += '		mso-footer-margin:.49in;										' + CHR(13) + CHR(10)
cCabec += '		mso-page-orientation:landscape;}									' + CHR(13) + CHR(10)
cCabec += '	tr														' + CHR(13) + CHR(10)
cCabec += '		{mso-height-source:auto;}										' + CHR(13) + CHR(10)
cCabec += '	col														' + CHR(13) + CHR(10)
cCabec += '		{mso-width-source:auto;}										' + CHR(13) + CHR(10)
cCabec += '	br														' + CHR(13) + CHR(10)
cCabec += '		{mso-data-placement:same-cell;}										' + CHR(13) + CHR(10)
cCabec += '	.style0														' + CHR(13) + CHR(10)
cCabec += '		{mso-number-format:General;										' + CHR(13) + CHR(10)
cCabec += '		text-align:general;											' + CHR(13) + CHR(10)
cCabec += '		vertical-align:bottom;											' + CHR(13) + CHR(10)
cCabec += '		white-space:nowrap;											' + CHR(13) + CHR(10)
cCabec += '		mso-rotate:0;												' + CHR(13) + CHR(10)
cCabec += '		mso-background-source:auto;										' + CHR(13) + CHR(10)
cCabec += '		mso-pattern:auto;											' + CHR(13) + CHR(10)
cCabec += '		color:windowtext;											' + CHR(13) + CHR(10)
cCabec += '		font-size:10.0pt;											' + CHR(13) + CHR(10)
cCabec += '		font-weight:400;											' + CHR(13) + CHR(10)
cCabec += '		font-style:normal;											' + CHR(13) + CHR(10)
cCabec += '		text-decoration:none;											' + CHR(13) + CHR(10)
cCabec += '		font-family:Arial;											' + CHR(13) + CHR(10)
cCabec += '		mso-generic-font-family:auto;										' + CHR(13) + CHR(10)
cCabec += '		mso-font-charset:0;											' + CHR(13) + CHR(10)
cCabec += '		border:none;												' + CHR(13) + CHR(10)
cCabec += '		mso-protection:locked visible;										' + CHR(13) + CHR(10)
cCabec += '		mso-style-name:Normal;											' + CHR(13) + CHR(10)
cCabec += '		mso-style-id:0;}											' + CHR(13) + CHR(10)
cCabec += '	td														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		padding-top:1px;											' + CHR(13) + CHR(10)
cCabec += '		padding-right:1px;											' + CHR(13) + CHR(10)
cCabec += '		padding-left:1px;											' + CHR(13) + CHR(10)
cCabec += '		mso-ignore:padding;											' + CHR(13) + CHR(10)
cCabec += '		color:windowtext;											' + CHR(13) + CHR(10)
cCabec += '		font-size:10.0pt;											' + CHR(13) + CHR(10)
cCabec += '		font-weight:400;											' + CHR(13) + CHR(10)
cCabec += '		font-style:normal;											' + CHR(13) + CHR(10)
cCabec += '		text-decoration:none;											' + CHR(13) + CHR(10)
cCabec += '		font-family:Arial;											' + CHR(13) + CHR(10)
cCabec += '		mso-generic-font-family:auto;										' + CHR(13) + CHR(10)
cCabec += '		mso-font-charset:0;											' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:General;										' + CHR(13) + CHR(10)
cCabec += '		text-align:general;											' + CHR(13) + CHR(10)
cCabec += '		vertical-align:bottom;											' + CHR(13) + CHR(10)
cCabec += '		border:none;												' + CHR(13) + CHR(10)
cCabec += '		mso-background-source:auto;										' + CHR(13) + CHR(10)
cCabec += '		mso-pattern:auto;											' + CHR(13) + CHR(10)
cCabec += '		mso-protection:locked visible;										' + CHR(13) + CHR(10)
cCabec += '		white-space:nowrap;											' + CHR(13) + CHR(10)
cCabec += '		mso-rotate:0;}												' + CHR(13) + CHR(10)
cCabec += '	.xl24														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		color:#333300;												' + CHR(13) + CHR(10)
cCabec += '		font-weight:700;											' + CHR(13) + CHR(10)
cCabec += '		font-family:Arial, sans-serif;										' + CHR(13) + CHR(10)
cCabec += '		mso-font-charset:0;											' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:"\@";}										' + CHR(13) + CHR(10)
cCabec += '	.xl25														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:"\@";}										' + CHR(13) + CHR(10)
cCabec += '	.xl26														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		color:#333300;												' + CHR(13) + CHR(10)
cCabec += '		font-weight:700;											' + CHR(13) + CHR(10)
cCabec += '		font-family:Arial, sans-serif;										' + CHR(13) + CHR(10)
cCabec += '		mso-font-charset:0;											' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:"\@";											' + CHR(13) + CHR(10)
cCabec += '		text-align:center;											' + CHR(13) + CHR(10)
cCabec += '		vertical-align:middle;											' + CHR(13) + CHR(10)
cCabec += '		border:.5pt solid windowtext;										' + CHR(13) + CHR(10)
cCabec += '		background:silver;											' + CHR(13) + CHR(10)
cCabec += '		mso-pattern:auto none;}											' + CHR(13) + CHR(10)
cCabec += '	.xl27														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:Standard;										' + CHR(13) + CHR(10)
cCabec += '		text-align:right;}											' + CHR(13) + CHR(10)
cCabec += '	.xl28														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:"\0022R$ \0022\#\,\#\#0\.00";}							' + CHR(13) + CHR(10)
cCabec += '	.xl29														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:Percent;}										' + CHR(13) + CHR(10)
cCabec += '	.xl30														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:"Short Date";}									' + CHR(13) + CHR(10)
cCabec += '	.xl31														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		color:#333300;												' + CHR(13) + CHR(10)
cCabec += '		font-weight:700;											' + CHR(13) + CHR(10)
cCabec += '		font-family:Arial, sans-serif;										' + CHR(13) + CHR(10)
cCabec += '		mso-font-charset:0;											' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:"\@";											' + CHR(13) + CHR(10)
cCabec += '		text-align:121;												' + CHR(13) + CHR(10)
cCabec += '		vertical-align:middle;											' + CHR(13) + CHR(10)
cCabec += '		border:.5pt solid windowtext;										' + CHR(13) + CHR(10)
cCabec += '		background:silver;											' + CHR(13) + CHR(10)
cCabec += '		mso-pattern:auto none;}											' + CHR(13) + CHR(10)
cCabec += '	.xl32														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:"\#\,\#\#0";}										' + CHR(13) + CHR(10)
cCabec += '	.xl33														' + CHR(13) + CHR(10)
cCabec += '		{mso-style-parent:style0;										' + CHR(13) + CHR(10)
cCabec += '		mso-number-format:"\#\,\#\#0";										' + CHR(13) + CHR(10)
cCabec += '		text-align:right;}											' + CHR(13) + CHR(10)
cCabec += '	-->														' + CHR(13) + CHR(10)
cCabec += '	</style>													' + CHR(13) + CHR(10)
cCabec += '	<!--[if gte mso 9]><xml>											' + CHR(13) + CHR(10)
cCabec += '	 <x:ExcelWorkbook>												' + CHR(13) + CHR(10)
cCabec += '	  <x:ExcelWorksheets>												' + CHR(13) + CHR(10)
cCabec += '	   <x:ExcelWorksheet>												' + CHR(13) + CHR(10)
cCabec += '	    <x:Name>Plan1</x:Name>											' + CHR(13) + CHR(10)
cCabec += '	    <x:WorksheetOptions>											' + CHR(13) + CHR(10)
cCabec += '	     <x:Print>													' + CHR(13) + CHR(10)
cCabec += '	      <x:ValidPrinterInfo/>											' + CHR(13) + CHR(10)
cCabec += '	      <x:Scale>29</x:Scale>											' + CHR(13) + CHR(10)
cCabec += '	      <x:HorizontalResolution>600</x:HorizontalResolution>							' + CHR(13) + CHR(10)
cCabec += '	      <x:VerticalResolution>600</x:VerticalResolution>								' + CHR(13) + CHR(10)
cCabec += '	     </x:Print>													' + CHR(13) + CHR(10)
cCabec += '	     <x:PageBreakZoom>60</x:PageBreakZoom>									' + CHR(13) + CHR(10)
cCabec += '	     <x:Selected/>												' + CHR(13) + CHR(10)
cCabec += '	     <x:Panes>													' + CHR(13) + CHR(10)
cCabec += '	      <x:Pane>													' + CHR(13) + CHR(10)
cCabec += '	       <x:Number>3</x:Number>											' + CHR(13) + CHR(10)
cCabec += '	       <x:ActiveRow>11</x:ActiveRow>										' + CHR(13) + CHR(10)
cCabec += '	       <x:ActiveCol>24</x:ActiveCol>										' + CHR(13) + CHR(10)
cCabec += '	      </x:Pane>													' + CHR(13) + CHR(10)
cCabec += '	     </x:Panes>													' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectContents>False</x:ProtectContents>								' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectObjects>False</x:ProtectObjects>									' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectScenarios>False</x:ProtectScenarios>								' + CHR(13) + CHR(10)
cCabec += '	    </x:WorksheetOptions>											' + CHR(13) + CHR(10)
cCabec += '	   </x:ExcelWorksheet>												' + CHR(13) + CHR(10)
cCabec += '	   <x:ExcelWorksheet>												' + CHR(13) + CHR(10)
cCabec += '	    <x:Name>Plan2</x:Name>											' + CHR(13) + CHR(10)
cCabec += '	    <x:WorksheetOptions>											' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectContents>False</x:ProtectContents>								' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectObjects>False</x:ProtectObjects>									' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectScenarios>False</x:ProtectScenarios>								' + CHR(13) + CHR(10)
cCabec += '	    </x:WorksheetOptions>											' + CHR(13) + CHR(10)
cCabec += '	   </x:ExcelWorksheet>												' + CHR(13) + CHR(10)
cCabec += '	   <x:ExcelWorksheet>												' + CHR(13) + CHR(10)
cCabec += '	    <x:Name>Plan3</x:Name>											' + CHR(13) + CHR(10)
cCabec += '	    <x:WorksheetOptions>											' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectContents>False</x:ProtectContents>								' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectObjects>False</x:ProtectObjects>									' + CHR(13) + CHR(10)
cCabec += '	     <x:ProtectScenarios>False</x:ProtectScenarios>								' + CHR(13) + CHR(10)
cCabec += '	    </x:WorksheetOptions>											' + CHR(13) + CHR(10)
cCabec += '	   </x:ExcelWorksheet>												' + CHR(13) + CHR(10)
cCabec += '	  </x:ExcelWorksheets>												' + CHR(13) + CHR(10)
cCabec += '	  <x:WindowHeight>9345</x:WindowHeight>										' + CHR(13) + CHR(10)
cCabec += '	  <x:WindowWidth>15180</x:WindowWidth>										' + CHR(13) + CHR(10)
cCabec += '	  <x:WindowTopX>120</x:WindowTopX>										' + CHR(13) + CHR(10)
cCabec += '	  <x:WindowTopY>60</x:WindowTopY>										' + CHR(13) + CHR(10)
cCabec += '	  <x:ProtectStructure>False</x:ProtectStructure>								' + CHR(13) + CHR(10)
cCabec += '	  <x:ProtectWindows>False</x:ProtectWindows>									' + CHR(13) + CHR(10)
cCabec += '	 </x:ExcelWorkbook>												' + CHR(13) + CHR(10)
cCabec += '	 <x:ExcelName>													' + CHR(13) + CHR(10)
cCabec += '	  <x:Name>Print_Area</x:Name>											' + CHR(13) + CHR(10)
cCabec += '	  <x:SheetIndex>1</x:SheetIndex>										' + CHR(13) + CHR(10)
cCabec += '	  <x:Formula>=Plan1!$A$1:$AB$56</x:Formula>									' + CHR(13) + CHR(10)
cCabec += '	 </x:ExcelName>													' + CHR(13) + CHR(10)
cCabec += '	</xml><![endif]-->												' + CHR(13) + CHR(10)
cCabec += '	</head>														' + CHR(13) + CHR(10)
cCabec += '	<body link=blue vlink=purple class=xl25>									' + CHR(13) + CHR(10)
cCabec += '	<table x:str border=0 cellpadding=0 cellspacing=0 width=5243 style="border-collapse:collapse;table-layout:fixed;width:3937pt">		' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=113 style="mso-width-source:userset;mso-width-alt:4132; width:85pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=191 style="mso-width-source:userset;mso-width-alt:6985; width:143pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=284 style="mso-width-source:userset;mso-width-alt:10386; width:213pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=113 style="mso-width-source:userset;mso-width-alt:4132; width:85pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=284 style="mso-width-source:userset;mso-width-alt:10386; width:213pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=40 style="mso-width-source:userset;mso-width-alt:1462; width:30pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=118 style="mso-width-source:userset;mso-width-alt:4315; width:89pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=141 span=2 style="mso-width-source:userset;mso-width-alt:5156;width:106pt">		' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=59 style="mso-width-source:userset;mso-width-alt:2157; width:44pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=141 span=2 style="mso-width-source:userset;mso-width-alt:5156;width:106pt">		' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=71 style="mso-width-source:userset;mso-width-alt:2596; width:53pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=284 style="mso-width-source:userset;mso-width-alt:10386; width:213pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=238 span=2 style="mso-width-source:userset;mso-width-alt:8704;width:179pt">		' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=377 span=2 style="mso-width-source:userset;mso-width-alt:13787;width:283pt">		' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=424 style="mso-width-source:userset;mso-width-alt:15506; width:318pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=150 style="mso-width-source:userset;mso-width-alt:5485; width:113pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=141 span=4 style="mso-width-source:userset;mso-width-alt:5156;width:106pt">		' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=284 style="mso-width-source:userset;mso-width-alt:10386; width:213pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=69 style="mso-width-source:userset;mso-width-alt:2523; width:52pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=191 style="mso-width-source:userset;mso-width-alt:6985; width:143pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=69 style="mso-width-source:userset;mso-width-alt:2523; width:52pt">			' + CHR(13) + CHR(10)
cCabec += '	 <col class=xl25 width=141 style="mso-width-source:userset;mso-width-alt:5156; width:106pt">			' + CHR(13) + CHR(10)

cCabec += '	 <tr class=xl24 height=52 style="mso-height-source:userset;height:39.0pt">					' + CHR(13) + CHR(10)
cCabec += '	  <td height=52 class=xl26 width=113 style="height:39.0pt;width:85pt">Nº Contrato</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=191 style="border-left:none;width:143pt">Solicitante Contrato</td>			' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=284 style="border-left:none;width:213pt">Fornecedor</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=113 style="border-left:none;width:85pt">Produto</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=284 style="border-left:none;width:213pt">Descrição Produto</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=40 style="border-left:none;width:30pt">Unid.</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=118 style="border-left:none;width:89pt">Quantidade</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Valor Unit</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Vlr Total Contrato</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Base Line</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Saving</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl31 width=59 style="border-left:none;width:44pt">Nº Planilha</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl31 width=59 style="border-left:none;width:44pt">Qtd. Medida</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Valor Medido</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Saldo Contrato Vlr</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl31 width=71 style="border-left:none;width:53pt">% Comp. Contrato</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=284 style="border-left:none;width:213pt">Cliente</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=238 style="border-left:none;width:179pt">Gestor Tecnico</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=238 style="border-left:none;width:179pt">Gestor Procurement</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=377 style="border-left:none;width:283pt">Unid Negocio CSU</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=377 style="border-left:none;width:283pt">Departamento</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=424 style="border-left:none;width:318pt">Operação(cliente)</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=150 style="border-left:none;width:113pt">Vigência</td>					' + CHR(13) + CHR(10)
                                                                                           
//For nI := 1 to nMaxPar 
//	cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Saldo Parcela ' + AllTrim(Str(nI)) + '</td>				' + CHR(13) + CHR(10)
//Next nI

For nI := 1 to Len(aCompete)
	cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Saldo em ' + AllTrim( aCompete[nI][1] ) + '</td>				' + CHR(13) + CHR(10)
Next nI

cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Reajuste</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=284 style="border-left:none;width:213pt">Tipo de Contrato</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl31 width=69 style="border-left:none;width:52pt">Data Revisão</td>					' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=191 style="border-left:none;width:143pt">Responsavel(Gestor)</td>			' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl31 width=69 style="border-left:none;width:52pt">Situação</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl31 width=69 style="border-left:none;width:52pt">Nº meses não medidos</td>				' + CHR(13) + CHR(10)
cCabec += '	  <td class=xl26 width=141 style="border-left:none;width:106pt">Saldos não medidos</td>				' + CHR(13) + CHR(10)
cCabec += '	 </tr>														' + CHR(13) + CHR(10)

DbSelectArea("TRB")
While TRB->( !EOF() )

	nReajus := TRB->CN9_REAJS
	cGerTec := Upper(RetField("SAK",1,xFilial("SAK") + TRB->CNB_X_GTEC ,"SAK->AK_NOME")) 
	cGerPro := Upper(RetField("SAK",1,xFilial("SAK") + TRB->CNB_X_GPRO ,"SAK->AK_NOME"))
	cTpCont := TRB->CN9_TPCTO
	cDesTp  := RetField("CN1",1,xFilial("CN1") + TRB->CN9_TPCTO,"CN1->CN1_DESCRI")
	dtRevis := TRB->CN9_DTREV
	cContra := TRB->CN9_NUMERO
	cRevisa := TRB->CN9_REVISA
	cCodPla := TRB->CNA_NUMERO
	cCronog := TRB->CNA_CRONOG

	If TRB->CN9_SITUAC == "01"
	   cSituac := "Cancelado"
	ElseIf TRB->CN9_SITUAC == "02"
	   cSituac := "Elaboracao"
	ElseIf TRB->CN9_SITUAC == "03"
	   cSituac := "Emitido"
	ElseIf TRB->CN9_SITUAC == "04"
	   cSituac := "Aprovacao"
	ElseIf TRB->CN9_SITUAC == "05"
	   cSituac := "Vigente"
	ElseIf TRB->CN9_SITUAC == "06"
	   cSituac := "Paralisa"
	ElseIf TRB->CN9_SITUAC == "07"
	   cSituac := "Sol. Finalizacao"
	ElseIf TRB->CN9_SITUAC == "08"
	   cSituac := "Finalizado"
	ElseIf TRB->CN9_SITUAC == "09"
	   cSituac := "Revisao"
	ElseIf TRB->CN9_SITUAC == "10"
	   cSituac := "Revisado"
    Else 
       cSituac := " "
	Endif
    nPar    := 0

	//aList{ID,Nome,Nome completo}
	nPos := aScan(aList,{|x|AllTrim(Upper(x[2])) == alltrim(Upper(TRB->CN9_X_SOLI))})
	cSolici := Iif( nPos <> 0 , Upper( aList[nPos][3] ) , "" )

	nPos := aScan(aList,{|x|AllTrim(Upper(x[2])) == alltrim(Upper(TRB->CN9_X_GECN))})
	cGestor := Iif( nPos <> 0 , Upper( aList[nPos][3] ) , "" )

	lLoop := .F.

	While TRB->( !EOF() ) .And. cContra+cTpCont+cCodPla+cCronog == TRB->CN9_NUMERO+TRB->CN9_TPCTO+TRB->CNA_NUMERO+TRB->CNA_CRONOG
	    
		If lLoop
			TRB->( DbSkip() )
			IncProc()
			Loop
		EndIf                                                                                       
		
	    //aVetCont{Contrato,revisao,planilha,qtdmed,vlrmed,sldcontra,percomp,qtdnaomedida}
	    nPos := aScan(aVetCont,{|x| x[1]+x[2]+x[3] == TRB->(CN9_NUMERO+CN9_REVISA+CND_NUMERO) })
	    cPlanilha:= aVetCont[nPos][3]
	    nQtdMed  := aVetCont[nPos][4]
	    nVlrMed  := aVetCont[nPos][5]
        nSldCont := TRB->CNA_SALDO
	    nPerComp := aVetCont[nPos][7]
	    nNaoMed  := aVetCont[nPos][8]
	    
		cHtml += '	 <tr height=17 style="height:12.75pt">												' + CHR(13) + CHR(10)
		cHtml += '	  <td height=17 class=xl25 style="height:12.75pt">' + cContra + '</td>				' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + cSolici + '</td>										' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + TRB->A2_NOME + '</td>									' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + TRB->CNB_PRODUT + '</td>										' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + TRB->CNB_DESCRI + '</td>								' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + TRB->CNB_UM + '</td>									' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl27 x:num="0" x:fmla="=VALUE('+Str(TRB->CNB_QUANT)+')">0</td>	 		' + Chr(13) + Chr(10)
		cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(TRB->CNB_VLUNIT)+')">0</td>	 		' + Chr(13) + Chr(10)
		cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(TRB->CNB_VLTOT)+')">0</td>	 		' + Chr(13) + Chr(10)
		
		//---->  BASE LINE e SAVING ajustado em 31/10/2011 OS2850-11 Jose Maria
		cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(TRB->CNB_X_BSLI)+')">0</td>	 		' + Chr(13) + Chr(10)
		cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(TRB->(CNB_X_BSLI-CNB_VLUNIT))+')">0</td>	 		' + Chr(13) + Chr(10)
		
		cHtml += '	  <td class=xl25>' + cPlanilha + '</td>										' + CHR(13) + CHR(10)

		//cHtml += '	  <td class=xl33 x:num="0" x:fmla="=VALUE('+Str(TRB->CNB_QTDMED)+')">0</td>			' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl33 x:num="0" x:fmla="=VALUE('+Str(nQtdMed)+')">0</td>			' + CHR(13) + CHR(10)

		//cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(TRB->CNE_VLTOT)+')">0</td>			' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(nVlrMed)+')">0</td>			' + CHR(13) + CHR(10)
		
		//cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(TRB->CNA_SALDO)+')">0</td>			' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(nSldCont)+')">0</td>			' + CHR(13) + CHR(10)
				
		//cHtml += '	  <td class=xl29 x:num="0" x:fmla="=VALUE('+Str(TRB->CNE_PERC)+')">0</td>			' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl29 x:num="0" x:fmla="=VALUE('+AllTrim(str(nPerComp/100))+')">0</td>			' + CHR(13) + CHR(10)

		cHtml += '	  <td class=xl25>' + TRB->A1_NOME + '</td>									' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + cGerTec + '</td>										' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + cGerPro + '</td>										' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + TRB->CTD_DESC01 + '</td>								' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + TRB->CTT_DESC01 + '</td>								' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + TRB->CNB_X_OPCL + '</td>								' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + DtoC(TRB->CN9_DTINIC) + ' - ' + DtoC(TRB->CN9_DTFIM) + '</td>	' + CHR(13) + CHR(10)

		/*
        While TRB->( !EOF() ) .And. cContra+cTpCont+cCodPla+cCronog == TRB->CN9_NUMERO+TRB->CN9_TPCTO+TRB->CNA_NUMERO+TRB->CNA_CRONOG
			IncProc()
			cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+AllTrim(Str(TRB->CNF_SALDO))+')">0</td>		' + CHR(13) + CHR(10)
			nPar++
			TRB->( DbSkip() )
		EndDo

		If nPar < nMaxPar
			For nI := nPar+1 to nMaxPar
				cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(0)+')">0</td>				' + CHR(13) + CHR(10)			
			Next nI
		EndIf
		*/

		//aVlrComp{ CONTRATO, REVISAO , ARRAY  }
		nPos := aScan(aVlrComp,{|x| x[1]+x[2] == cContra + cRevisa })
		For nI := 1 to Len( aVlrComp[nPos][3] )
			cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+AllTrim(Str( aVlrComp[nPos][3][nI][2] ))+')">0</td>		' + CHR(13) + CHR(10)		
		Next nI


		cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(nReajus)+')">0</td>			' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + cDesTp + '</td>								' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl30>' + DtoC(dtRevis) + '</td>		' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + cGestor + '</td>										' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl25>' + cSituac + '</td>										' + CHR(13) + CHR(10)
		
		//cHtml += '	  <td class=xl32 x:num="0" x:fmla="=VALUE('+Str(TRB->CNB_SLDMED)+')">0</td>			' + CHR(13) + CHR(10)
		cHtml += '	  <td class=xl32 x:num="0" x:fmla="=VALUE('+Str(nNaoMed)+')">0</td>			' + CHR(13) + CHR(10)

		cHtml += '	  <td class=xl28 x:num="0" x:fmla="=VALUE('+Str(nSldCont)+')">0</td>			' + CHR(13) + CHR(10)
		
		cHtml += '	 </tr>									 											' + CHR(13) + CHR(10)
		
		TRB->( DbSkip() )
		IncProc()
		
		// ja imprimiu o contrato e habilita o lLoop para nao imprimir repedito
		If cContra == TRB->CN9_NUMERO
			lLoop := .T.
		EndIf
		
	EndDo
EndDo

cRodap += '	 <![if supportMisalignedColumns]>										' + CHR(13) + CHR(10)
cRodap += '	 <tr height=0 style="display:none">										' + CHR(13) + CHR(10)
cRodap += '	  <td width=113 style="width:85pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=191 style="width:143pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=284 style="width:213pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=113 style="width:85pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=284 style="width:213pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=40 style="width:30pt"></td>										' + CHR(13) + CHR(10)
cRodap += '	  <td width=118 style="width:89pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=59 style="width:44pt"></td>										' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=71 style="width:53pt"></td>										' + CHR(13) + CHR(10)
cRodap += '	  <td width=284 style="width:213pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=238 style="width:179pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=238 style="width:179pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=377 style="width:283pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=377 style="width:283pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=424 style="width:318pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=150 style="width:113pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=284 style="width:213pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=69 style="width:52pt"></td>										' + CHR(13) + CHR(10)
cRodap += '	  <td width=191 style="width:143pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	  <td width=69 style="width:52pt"></td>										' + CHR(13) + CHR(10)
cRodap += '	  <td width=141 style="width:106pt"></td>									' + CHR(13) + CHR(10)
cRodap += '	 </tr>														' + CHR(13) + CHR(10)
cRodap += '	 <![endif]>													' + CHR(13) + CHR(10)
cRodap += '	</table>													' + CHR(13) + CHR(10)
cRodap += '	</body>														' + CHR(13) + CHR(10)
cRodap += '	</html>														' + CHR(13) + CHR(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se foi possivel gravar o arquivo, caso nao seja possivel um mensagem     ³
//³de alerta será exibida na tela   			                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If(FWRITE(nHandle, cCabec+cHtml+cRodap) == 0)
	MsgAlert("Não foi possível gravar o arquivo!")  
EndIf
				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha o arquivo gravado                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FCLOSE(nHandle)
				
MsgInfo("O arquivo foi gerado no diretório ") //"O arquivo foi gerado no diretório "

If GPR010Word() > 0
	oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open( cArqPesq )
	oExcelApp:SetVisible(.T.)
	//WinExec("excel.exe "+cArqPesq)
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CriaTRB   ³ Autor ³Microsiga                ³ Data ³ 10/07/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para criar arquivo temporario.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaTRB(nQtdReg,nMaxPar,aVetCont,aCompete,aVlrComp)

Local cQuery	:= "" 
Local aTam		:= {} 
Local nPos		:= 0      
Local cContra	:= ""
Local cRevisa	:= ""
Local nQtdMed	:= 0
Local nVlrMed	:= 0
Local nSldCont	:= 0
Local nPerComp  := 0
Local nNaoMed	:= 0     
Local aVlrPar	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta TABELA AUXILIAR                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT "
	cQuery += "CN9_NUMERO,CN9_SITUAC,CN9_REVISA,CN9_DTINIC,CN9_DTFIM,CN9_TPCTO,CN9_DTREV,CN9_X_GECN,CN9_REAJS,CN9_X_SOLI,CNA_NUMERO,CNA_FORNEC,CNA_LJFORN,CNA_CRONOG,CNA_SALDO, "
	cQuery += "A2_NOME,CNB_PRODUT,CNB_DESCRI,CNB_UM,CNB_QUANT,CNB_VLUNIT,CNB_X_BSLI,CNB_VLTOT,CNB_QTDMED,CNB_SLDMED,CNB_X_CLI,CNB_X_LOJA,CNB_X_GTEC,CNB_X_GPRO, "
	cQuery += "CNB_X_UNID,CNB_X_CC,CNB_X_OPCL,CNB_X_GCOM,A1_NOME,CTD_DESC01,CTT_DESC01,ISNULL(CND_NUMMED,'') CND_NUMMED,ISNULL(CND_COMPET,'') CND_COMPET, CND_NUMERO, "
	cQuery += "ISNULL(CNE_PRODUT,'') CNE_PRODUT,ISNULL(CNE_QTDSOL,0) CNE_QTDSOL,ISNULL(CNE_QTAMED,0) CNE_QTAMED,ISNULL(CNE_QUANT,0) CNE_QUANT, "
	cQuery += "ISNULL(CNE_PERC,0) CNE_PERC,ISNULL(CNE_VLTOT,0) CNE_VLTOT,CNF_FILIAL,CNF_NUMERO,CNF_CONTRA,CNF_PARCEL,CNF_COMPET,CNF_VLPREV,CNF_SALDO,CNF_PRUMED,CNF_MAXPAR  "

cQuery += "FROM " + RetSqlName("CN9") + " CN9 "
	cQuery += "JOIN " + RetSqlName("CNA") + " CNA ON "
		cQuery += "CNA.D_E_L_E_T_ = ' ' "
		cQuery += "AND CN9.CN9_FILIAL = CNA.CNA_FILIAL " 
		cQuery += "AND CN9.CN9_NUMERO = CNA.CNA_CONTRA " 
		cQuery += "AND CN9.CN9_REVISA = CNA.CNA_REVISA "

	cQuery += "JOIN " + RetSqlName("SA2") + " SA2 ON "
		cQuery += "SA2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CNA.CNA_FORNEC = SA2.A2_COD "
		cQuery += "AND CNA.CNA_LJFORN = SA2.A2_LOJA "

	cQuery += "JOIN " + RetSqlName("CNB") + " CNB ON "
		cQuery += "CNB.D_E_L_E_T_ = ' ' "
		cQuery += "AND CN9.CN9_FILIAL = CNB.CNB_FILIAL "
		cQuery += "AND CN9.CN9_NUMERO = CNB.CNB_CONTRA "
		cQuery += "AND CNA.CNA_NUMERO = CNB.CNB_NUMERO "
		cQuery += "AND CN9.CN9_REVISA = CNB.CNB_REVISA "

	cQuery += "JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += "SA1.D_E_L_E_T_ = ' ' "
		cQuery += "AND CNB.CNB_X_CLI  = SA1.A1_COD "
		cQuery += "AND CNB.CNB_X_LOJA = SA1.A1_LOJA "

	cQuery += "JOIN " + RetSqlName("CTD") + " CTD ON "
		cQuery += "CTD.D_E_L_E_T_ = ' ' "
		cQuery += "AND CNB.CNB_X_UNID = CTD.CTD_ITEM "

	cQuery += "JOIN " + RetSqlName("CTT") + " CTT ON "
		cQuery += "CTT.D_E_L_E_T_ = ' ' "
		cQuery += "AND CNB.CNB_X_CC = CTT.CTT_CUSTO "

	cQuery += "JOIN " + RetSqlName("CNF") + " CNF ON "
		cQuery += "CNF.D_E_L_E_T_ = ' ' "
		cQuery += "AND CN9.CN9_FILIAL = CNF.CNF_FILIAL "
		cQuery += "AND CN9.CN9_NUMERO = CNF.CNF_CONTRA "
		cQuery += "AND CNA.CNA_CRONOG = CNF.CNF_NUMERO "
		cQuery += "AND CN9.CN9_REVISA = CNF.CNF_REVISA "

	cQuery += "LEFT OUTER JOIN " + RetSqlName("CND") + " CND ON "
		cQuery += "CND.D_E_L_E_T_ = ' ' "
		cQuery += "AND CN9.CN9_FILIAL = CND.CND_FILIAL "
		cQuery += "AND CN9.CN9_NUMERO = CND.CND_CONTRA "
		cQuery += "AND CNA.CNA_NUMERO = CND.CND_NUMERO "
		cQuery += "AND CN9.CN9_REVISA = CND.CND_REVISA "
		cQuery += "AND CNF.CNF_COMPET = CND.CND_COMPET "
		cQuery += "AND CNA.CNA_FORNEC = CND.CND_FORNEC "
		cQuery += "AND CNA.CNA_LJFORN = CND.CND_LJFORN "

	cQuery += "LEFT OUTER JOIN " + RetSqlName("CNE") + " CNE ON "
		cQuery += "CNE.D_E_L_E_T_ = ' ' "
		cQuery += "AND CN9.CN9_FILIAL = CNE.CNE_FILIAL "
		cQuery += "AND CN9.CN9_NUMERO = CNE.CNE_CONTRA " 
		cQuery += "AND CNA.CNA_NUMERO = CNE.CNE_NUMERO "
		cQuery += "AND CND.CND_NUMMED = CNE.CNE_NUMMED "
		cQuery += "AND CN9.CN9_REVISA = CNE.CNE_REVISA "
		cQuery += "AND CNB.CNB_PRODUT = CNE.CNE_PRODUT "

cQuery += "WHERE  "
	cQuery += "CN9.D_E_L_E_T_ <> '*' "
	cQuery += "AND CN9.CN9_FILIAL = '" + xFilial("CN9") + "' "
	cQuery += "AND CN9.CN9_NUMERO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += "AND CN9.CN9_DTINIC BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	cQuery += "AND CN9.CN9_DTFIM BETWEEN '" + DtoS(mv_par05) + "' AND '" + DtoS(mv_par06) + "' "
	cQuery += "AND CNA.CNA_FORNEC BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'  "
	cQuery += "AND CNA.CNA_LJFORN BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' "
	cQuery += "AND CNB.CNB_X_CLI BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' "
	cQuery += "AND CNB.CNB_X_LOJA BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "' "
	cQuery += "AND CN9.CN9_REVATU = ' ' "
	
cQuery += "ORDER BY  "
	cQuery += "CN9.CN9_NUMERO,CN9.CN9_TPCTO,CNA.CNA_NUMERO,CNA.CNA_CRONOG,CNF.CNF_PARCEL "

If Select("TRB") > 0
	TRB->( dbCloseArea() )
endif
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

aTam := TamSx3("CN9_DTINIC")
TCSetField( "TRB", "CN9_DTINIC" , "D" , aTam[1] , aTam[2] )
aTam := TamSx3("CN9_DTFIM")
TCSetField( "TRB", "CN9_DTFIM"  , "D" , aTam[1] , aTam[2] )
aTam := TamSx3("CN9_DTREV")
TCSetField( "TRB", "CN9_DTREV"  , "D" , aTam[1] , aTam[2] )
aTam := TamSx3("CN9_REAJS")
TCSetField( "TRB", "CN9_REAJS"  , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNA_SALDO")
TCSetField( "TRB", "CNA_SALDO"  , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNB_QUANT")
TCSetField( "TRB", "CNB_QUANT"  , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNB_VLUNIT")
TCSetField( "TRB", "CNB_VLUNIT" , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNB_VLTOT")
TCSetField( "TRB", "CNB_VLTOT"  , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNB_X_BSLI")
TCSetField( "TRB", "CNB_X_BSLI"  , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNB_QTDMED")
TCSetField( "TRB", "CNB_QTDMED" , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNB_SLDMED")
TCSetField( "TRB", "CNB_SLDMED" , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNE_QTDSOL")
TCSetField( "TRB", "CNE_QTDSOL" , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNE_QTAMED")
TCSetField( "TRB", "CNE_QTAMED" , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNE_QUANT")
TCSetField( "TRB", "CNE_QUANT"  , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNE_PERC")
TCSetField( "TRB", "CNE_PERC"   , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNE_VLTOT")
TCSetField( "TRB", "CNE_VLTOT"  , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNF_VLPREV")
TCSetField( "TRB", "CNF_VLPREV" , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNF_SALDO")
TCSetField( "TRB", "CNF_SALDO"  , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNF_PRUMED")
TCSetField( "TRB", "CNF_PRUMED" , "N" , aTam[1] , aTam[2] )
aTam := TamSx3("CNF_MAXPAR")
TCSetField( "TRB", "CNF_MAXPAR" , "N" , aTam[1] , aTam[2] )

nQtdReg := 0
TRB->( dbGoTop() )
TRB->( dbEval( { || nQtdReg++ },, { || !EOF() } ) )
TRB->( dbGoTop() )

//--------------------------------------------
// se tiver registro na consulta prepara vetor 
// com os vencimentos das parcelas
//--------------------------------------------
If nQtdReg > 0
	cQuery := "SELECT "
		cQuery += "DISTINCT CNF_COMPET,SUBSTRING(CNF_COMPET,4,4) AS ANO,SUBSTRING(CNF_COMPET,1,2) AS MES "
	
	cQuery += "FROM " + RetSqlName("CN9") + " CN9 "
		cQuery += "JOIN " + RetSqlName("CNA") + " CNA ON "
			cQuery += "CNA.D_E_L_E_T_ = ' ' "
			cQuery += "AND CN9.CN9_FILIAL = CNA.CNA_FILIAL " 
			cQuery += "AND CN9.CN9_NUMERO = CNA.CNA_CONTRA " 
			cQuery += "AND CN9.CN9_REVISA = CNA.CNA_REVISA "
	
		cQuery += "JOIN " + RetSqlName("CNB") + " CNB ON "
			cQuery += "CNB.D_E_L_E_T_ = ' ' "
			cQuery += "AND CN9.CN9_FILIAL = CNB.CNB_FILIAL "
			cQuery += "AND CN9.CN9_NUMERO = CNB.CNB_CONTRA "
			cQuery += "AND CNA.CNA_NUMERO = CNB.CNB_NUMERO "
			cQuery += "AND CN9.CN9_REVISA = CNB.CNB_REVISA "
	
		cQuery += "JOIN " + RetSqlName("CNF") + " CNF ON "
			cQuery += "CNF.D_E_L_E_T_ = ' ' "
			cQuery += "AND CN9.CN9_FILIAL = CNF.CNF_FILIAL "
			cQuery += "AND CN9.CN9_NUMERO = CNF.CNF_CONTRA "
			cQuery += "AND CNA.CNA_CRONOG = CNF.CNF_NUMERO "
			cQuery += "AND CN9.CN9_REVISA = CNF.CNF_REVISA "
	
	cQuery += "WHERE  "
		cQuery += "CN9.D_E_L_E_T_ <> '*' "
		cQuery += "AND CN9.CN9_FILIAL = '" + xFilial("CN9") + "' "
		cQuery += "AND CN9.CN9_NUMERO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQuery += "AND CN9.CN9_DTINIC BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		cQuery += "AND CN9.CN9_DTFIM BETWEEN '" + DtoS(mv_par05) + "' AND '" + DtoS(mv_par06) + "' "
		cQuery += "AND CNA.CNA_FORNEC BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'  "
		cQuery += "AND CNA.CNA_LJFORN BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' "
		cQuery += "AND CNB.CNB_X_CLI BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' "
		cQuery += "AND CNB.CNB_X_LOJA BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "' "
		cQuery += "AND CN9.CN9_REVATU = ' ' "
		
	cQuery += "ORDER BY ANO,MES  "
	
	If Select("TMP1") > 0
		TMP1->( dbCloseArea() )
	endif  
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP1",.T.,.T.)
	TMP1->( dbGoTop() )

	While TMP1->( !EOF() )
		aAdd(aCompete,{ TMP1->MES + '/' + TMP1->ANO , 0 }) // competencia , valor
		TMP1->( DbSkip() )
	End

	If Select("TMP1") > 0
		TMP1->( dbCloseArea() )
	endif  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta vetor com campos somados por contrato e valor das parcelas.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While TRB->( !Eof() )
		cContra  := TRB->CN9_NUMERO
		cRevisa  := TRB->CN9_REVISA
		nQtdMed  := 0  // qtd medicoes
		nVlrMed  := 0  // valor das medicoes
		nSldCont := 0  // saldo contrato
		nPerComp := 0  // percentual comprometido do contrato
		nNaoMed  := 0  // qtd de meses nao medidos
		aVlrPar  := aClone(aCompete) //clona vetor                                      
		cPlanilha:= "9x9y9z"

		While TRB->( !Eof() ) .And. cContra+cRevisa == TRB->(CN9_NUMERO+CN9_REVISA)
		
		    If cPlanilha <> TRB->CND_NUMERO
		       cPlanilha := TRB->CND_NUMERO
	 	       nQtdMed  := 0  // qtd medicoes
		       nVlrMed  := 0  // valor das medicoes
		       nSldCont := 0  // saldo contrato
		       nPerComp := 0  // percentual comprometido do contrato
		       nNaoMed  := 0  // qtd de meses nao medidos
		    Endif

		    If cPlanilha == TRB->CND_NUMERO
			   If !Empty( TRB->CND_NUMMED )
				  nQtdMed++      
				  nVlrMed  += TRB->CNE_VLTOT
				  nSldCont += TRB->CNF_SALDO
				  nPerComp += TRB->CNE_PERC
			   Else
				  nNaoMed++
				  nSldCont += TRB->CNF_SALDO
			   EndIf
			                               
		    Endif	   
            
            // { COMPETENCIA, VALOR }
			nPos := aScan( aVlrPar ,{|x| AllTrim(x[1]) == AllTrim(TRB->CNF_COMPET) })
			aVlrPar[nPos][2] := TRB->CNF_SALDO
		    //Endif 
		    
			TRB->( DbSkip() )				                
			
			If cPlanilha <> TRB->CND_NUMERO .OR. cContra+cRevisa <> TRB->(CN9_NUMERO+CN9_REVISA) .OR. TRB->(Eof())
               // vetor com valores dos contratos
		       aAdd(aVetCont,{ cContra,;			// 1 - numero do contrato
						cRevisa,;			// 2 - revisao
						cPlanilha,;			// 3 - Qtd medicoes 
						nQtdMed,;			// 4 - Qtd medicoes 
						nVlrMed,;			// 5 - Valor das medicoes 
						nSldCont,;			// 6 - Valor do saldo do contrato
						nPerComp,;			// 7 - Percentual comprometido do contrato
						nNaoMed})			// 8 - Qtd de meses nao medidos
			Endif
			

		EndDo

		// vetor com valores das parcels
		aAdd(aVlrComp,{ cContra,;			// 1 - numero do contrato
						cRevisa,;			// 2 - revisao
						aVlrPar})			// 3 - array com valores das competencias

	EndDo

	TRB->( dbGoTop() )

EndIf

/*
If nQtdReg > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ verifica qual eh o numero maximo de parcelas                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT MAX(CNF_MAXPAR) CNF_MAXPAR "
	cQuery += "FROM " + RetSqlName("CN9") + " CN9 "
		cQuery += "JOIN " + RetSqlName("CNA") + " CNA ON "
			cQuery += "CNA.D_E_L_E_T_ = ' ' "
			cQuery += "AND CN9.CN9_FILIAL = CNA.CNA_FILIAL " 
			cQuery += "AND CN9.CN9_NUMERO = CNA.CNA_CONTRA " 
			cQuery += "AND CN9.CN9_REVISA = CNA.CNA_REVISA "
	
		cQuery += "JOIN " + RetSqlName("CNB") + " CNB ON "
			cQuery += "CNB.D_E_L_E_T_ = ' ' "
			cQuery += "AND CN9.CN9_FILIAL = CNB.CNB_FILIAL "
			cQuery += "AND CN9.CN9_NUMERO = CNB.CNB_CONTRA "
			cQuery += "AND CNA.CNA_NUMERO = CNB.CNB_NUMERO "
			cQuery += "AND CN9.CN9_REVISA = CNB.CNB_REVISA "
	
		cQuery += "JOIN " + RetSqlName("CNF") + " CNF ON "
			cQuery += "CNF.D_E_L_E_T_ = ' ' "
			cQuery += "AND CN9.CN9_FILIAL = CNF.CNF_FILIAL "
			cQuery += "AND CN9.CN9_NUMERO = CNF.CNF_CONTRA "
			cQuery += "AND CNA.CNA_CRONOG = CNF.CNF_NUMERO "
	
	cQuery += "WHERE  "
		cQuery += "CN9.D_E_L_E_T_ <> '*' "
		cQuery += "AND CN9.CN9_FILIAL = '" + xFilial("CN9") + "' "
		cQuery += "AND CN9.CN9_NUMERO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQuery += "AND CN9.CN9_DTINIC BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		cQuery += "AND CN9.CN9_DTFIM BETWEEN '" + DtoS(mv_par05) + "' AND '" + DtoS(mv_par06) + "' "
		cQuery += "AND CNA.CNA_FORNEC BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'  "
		cQuery += "AND CNA.CNA_LJFORN BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' "
		cQuery += "AND CNB.CNB_X_CLI BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' "
		cQuery += "AND CNB.CNB_X_LOJA BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "' "
	
	If Select("TMP") > 0
		TMP->( dbCloseArea() )
	endif
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.) 
	
	nMaxPar := TMP->CNF_MAXPAR    
	TMP->( dbCloseArea() )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta vetor com campos somados por contrato.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While TRB->( !Eof() )
		cContra  := TRB->CN9_NUMERO
		cRevisa  := TRB->CN9_REVISA
		nQtdMed  := 0  // qtd medicoes
		nVlrMed  := 0  // valor das medicoes
		nSldCont := 0  // saldo contrato
		nPerComp := 0  // percentual comprometido do contrato
		nNaoMed  := 0  // qtd de meses nao medidos

		While TRB->( !Eof() ) .And. cContra+cRevisa == TRB->(CN9_NUMERO+CN9_REVISA)
			If !Empty( TRB->CND_NUMMED )
				nQtdMed++      
				nVlrMed  += TRB->CNE_VLTOT
				nSldCont += TRB->CNF_SALDO
				nPerComp += TRB->CNE_PERC
			Else
				nNaoMed++
				nSldCont += TRB->CNF_SALDO
			EndIf
			TRB->( DbSkip() )		
		EndDo

		aAdd(aVetCont,{ cContra,;			// 1 - numero do contrato
						cRevisa,;			// 2 - revisao
						nQtdMed,;			// 3 - Qtd medicoes 
						nVlrMed,;			// 4 - Valor das medicoes 
						nSldCont,;			// 5 - Valor do saldo do contrato
						nPerComp,;			// 6 - Percentual comprometido do contrato
						nNaoMed})			// 7 - Qtd de meses nao medidos
	EndDo
	TRB->( dbGoTop() )

EndIf
*/

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MontaVet  ³ Autor ³Microsiga                ³ Data ³ 10/07/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para montar vetor com usuarios do sistema.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaVet(aAllUsr,aList)

Local nI := 0

aAllUsr := AllUsers() //vetor com todos os usuarios
For nI := 1 to Len(aAllUsr)
    //                 ID               Nome          Nome completo
	aAdd(aList,{aAllUsr[nI][1][1],aAllUsr[nI][1][2],aAllUsr[nI][1][4]})
Next 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³AjustaSx1 ³ Autor ³Microsiga                ³ Data ³ 12/12/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta perguntas no SX1.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSx1(cPerg)

Local aArea   := GetArea()
Local aHelp	  := {}

cPerg   := PADR(cPerg,6)

aAdd(aHelp,{"Informe o contrato de/ate."})
aAdd(aHelp,{"Informe a data inicial de/ate."})
aAdd(aHelp,{"Informe a data final de/ate."})
aAdd(aHelp,{"Informe o fornecedor de/ate."})
aAdd(aHelp,{"Informe a loja fornecedor de/ate."})
aAdd(aHelp,{"Informe o cliente de/ate"})       
aAdd(aHelp,{"Informe a loja do cliente de/ate."})

PutSx1(cPerg, "01" ,"Contrato de"		,""	,""	,"mv_ch1"	,"C" ,15 ,0 ,0 ,"G" ,""				,"CN9"	,"","","mv_par01" ,"","","","","","","","","","","","","","","","",aHelp[1],aHelp[1],aHelp[1])
PutSx1(cPerg, "02" ,"Contrato ate" 		,""	,""	,"mv_ch2"	,"C" ,15 ,0 ,0 ,"G" ,"NaoVazio()"	,"CN9" 	,"","","mv_par02" ,"","","","","","","","","","","","","","","","",aHelp[1],aHelp[1],aHelp[1])
PutSx1(cPerg, "03" ,"Data inicio de"	,""	,""	,"mv_ch3"	,"D" ,08 ,0 ,0 ,"G" ,"NaoVazio()"	,"" 	,"","","mv_par03" ,"","","","","","","","","","","","","","","","",aHelp[2],aHelp[2],aHelp[2])
PutSx1(cPerg, "04" ,"Data inicio ate"	,""	,""	,"mv_ch4"	,"D" ,08 ,0 ,0 ,"G" ,"NaoVazio()"	,"" 	,"","","mv_par04" ,"","","","","","","","","","","","","","","","",aHelp[2],aHelp[2],aHelp[2])
PutSx1(cPerg, "05" ,"Data fim de"		,""	,""	,"mv_ch5"	,"D" ,08 ,0 ,0 ,"G" ,"NaoVazio()"	,"" 	,"","","mv_par05" ,"","","","","","","","","","","","","","","","",aHelp[3],aHelp[3],aHelp[3])
PutSx1(cPerg, "06" ,"Data fim ate"		,""	,""	,"mv_ch6"	,"D" ,08 ,0 ,0 ,"G" ,"NaoVazio()"	,""		,"","","mv_par06" ,"","","","","","","","","","","","","","","","",aHelp[3],aHelp[3],aHelp[3])
PutSx1(cPerg, "07" ,"Fornecedor de"		,""	,""	,"mv_ch7"	,"C" ,06 ,0 ,0 ,"G" ,""				,"SA2" 	,"","","mv_par07" ,"","","","","","","","","","","","","","","","",aHelp[4],aHelp[4],aHelp[4])
PutSx1(cPerg, "08" ,"Fornecedor ate"	,""	,""	,"mv_ch8"	,"C" ,06 ,0 ,0 ,"G" ,"NaoVazio()"	,"SA2" 	,"","","mv_par08" ,"","","","","","","","","","","","","","","","",aHelp[4],aHelp[4],aHelp[4])
PutSx1(cPerg, "09" ,"Loja fornec. de"	,""	,""	,"mv_ch9"	,"C" ,02 ,0 ,0 ,"G" ,""				,""  	,"","","mv_par09" ,"","","","","","","","","","","","","","","","",aHelp[5],aHelp[5],aHelp[5])
PutSx1(cPerg, "10" ,"Loja fornec. ate"	,""	,""	,"mv_ch10"	,"C" ,02 ,0 ,0 ,"G" ,"NaoVazio()"	,""  	,"","","mv_par10" ,"","","","","","","","","","","","","","","","",aHelp[5],aHelp[5],aHelp[5])
PutSx1(cPerg, "11" ,"Cliente de" 		,""	,""	,"mv_ch11"	,"C" ,06 ,0 ,0 ,"G" ,""				,"SA1" 	,"","","mv_par11" ,"","","","","","","","","","","","","","","","",aHelp[6],aHelp[6],aHelp[6])
PutSx1(cPerg, "12" ,"Cliente ate" 		,""	,""	,"mv_ch12"	,"C" ,06 ,0 ,0 ,"G" ,"NaoVazio()"	,"SA1" 	,"","","mv_par12" ,"","","","","","","","","","","","","","","","",aHelp[6],aHelp[6],aHelp[7])
PutSx1(cPerg, "13" ,"Loja cliente de"	,""	,""	,"mv_ch13"	,"C" ,02 ,0 ,0 ,"G" ,""				,""  	,"","","mv_par13" ,"","","","","","","","","","","","","","","","",aHelp[7],aHelp[7],aHelp[7])
PutSx1(cPerg, "14" ,"Loja cliente ate"	,""	,""	,"mv_ch14"	,"C" ,02 ,0 ,0 ,"G" ,"NaoVazio()"	,""  	,"","","mv_par14" ,"","","","","","","","","","","","","","","","",aHelp[7],aHelp[7],aHelp[7])

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPR010WordºAutor  ³Marcelo Kotaki      º Data ³  11/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para avaliar se existe o software de edicao da       º±±
±±º          ³pesquisa exportada esta instalada na maquina do usuario     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SIGAGPR                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GPR010Word()

Local oWord						// Objeto
Local cEditor:= "Excel"			// Software para edicao
Local nRet   := 0				// Retorno da funcao

CursorWait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica via API se o software de edicao esta instalado na maquina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWord := OLE_CreateLink(cEditor)
If oWord <> "-1"
	nRet := 1 // Existe Word
Endif
oWord := OLE_CloseLink(oWord)

CursorArrow()

Return( nRet )        

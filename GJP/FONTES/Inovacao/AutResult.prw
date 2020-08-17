#include "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#INCLUDE "topconn.ch"   
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
//#INCLUDE "COVERAGE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} AutResult
Rotina que converte dados de tabelas para arquivo de texto

@param cPath, Caracter, Define o caminho onde o arquivo será salvo
@param aTables, Array, Define as tabelas que serão geradas
@param aFilCpos, Array, Define os campos da tabelas
@param aCondicao, Array, Define as condições das tabelas

@author Denis R. de Oliveira
@since 16/06/2016
@version 1.0
/*/
//-------------------------------------------------------------------
User Function AutResult( cPath, aTables, aFilCpos, aCondicao )

Local aArquivo	:=	{}
Local aVetCab		:=	{}
Local aVetCmp		:=	{}
Local aFiltro		:=	{}

Local cFilCpos	:= ""

Local nI	:=	0
Local nJ	:=	0
Local nX	:=	0
Local nGerado	:= 0

Local cCodEmp 	:= FWArrFilAtu()[1]
Local lAutomato	:= .F.

Default aTables 	:= {}
Default aFilCpos	:= {}
Default aCondicao	:= {}
Default cPath		:= ""

//Recebo se a função é executada por tela
lAutomato := Iif (IsBlind(),.T.,.F.)

//Caso a rotina esteja sendo chamada por interface
If !lAutomato

	aArquivo := MontaTela()
	
	For nJ := 1 To Len(aArquivo[1])
		
		Aadd(aTables  , aArquivo[1][nJ][1])
		Aadd(aFilCpos , aArquivo[1][nJ][2])
		Aadd(aCondicao, aArquivo[1][nJ][3])
		
		Iif (!Empty(aArquivo[1][nJ][3]), Aadd(aFiltro,1), Aadd(aFiltro,0) )
	
	Next
	
	//Recebo a informação se já foi gerado arquivo
	If !Empty(aArquivo[1])
		nGerado := aArquivo[1][1][4]
	EndIf
	
//Caso esteja sendo chamada dentro de um fonte	
Else

	For nJ := 1 To Len(aCondicao)
		Iif (!Empty(aCondicao[nJ]), Aadd(aFiltro,1), Aadd(aFiltro,0) )
	Next

EndIf

//Laço com as tabelas que serão geradas
For nX := 1 To Len(aTables)

	//Monto o caminho e nome do arquivo (Tabela + Empresa + Extensão)
	If lAutomato
		cArquivo := cPath + aTables[nX] + cCodEmp + "0" + ".csv"
	Else
		cArquivo := aArquivo[2] + aTables[nX] + cCodEmp + "0" + ".csv"
	EndIf		
	
	//Chamo a função que gera o cabeçalho
	If Empty(aFilCpos[nX])
	
		aVetCab := Cabec(aTables[nX])
		
		//Monto string com os campos que serão utilizados na pesquisa
		For nI:= 1 to Len(aVetCab)
			cFilCpos += aVetCab[nI] + Iif(nI < Len(aVetCab),",","")
		Next
		aFilCpos[nX] := cFilCpos
		
		//Limpo a variável
		cFilCpos := ""
	
	Else
	
		cFilCpos := aFilCpos[nX]
		aVetCab := StrTokArr(cFilCpos, ",;")
				
	EndIf	

	//Chamo a função que gera os campos
	aVetCmp := Fields(aFiltro[nX], aTables[nX], aFilCpos[nX], aCondicao[nX] )
	
	//Gera o arquivo
	xArrToTxt(aVetCab, aVetCmp, cArquivo)

	
Next

//Verifico se rotina esteja sendo chamada por interface e se a geração do arquivo já foi executado
If !lAutomato .And. nGerado == 1
	//Chamo a própria rotina novamente, possibilitando que o usuário gere outro arquivo
	If MsgYesNo("Deseja gerar um novo processo ou tabela?", "Gerar Arquivo")
		U_AutResult()
	EndIf
EndIf

Return 
//-------------------------------------------------------------------
/*/{Protheus.doc} MontaTela
Função que monta tela da rotina

@author Denis R. de Oliveira
@since 16/06/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function MontaTela()

Local aQuery	:= {}
Local aRadio	:= {"Processo","Tabela"}
Local aCombo1	:= {"","1=Todos os Campos","2=Filtrar por Campos"}
Local aCombo2	:= {""}

Local cEdit1	:= Space(006)
Local cEdit2	:= Space(3000)
Local cEdit3	:= Space(3000)
Local cEdit4	:= Space(3000)

Local oTButton1, oTButton2

Local cPath	:= ""
Local nX		:= 0
Local aModelos := {}
Local aArquivo := {}
Local bProcura :=	{|| cPath := cGetFile('Arquivo *|*.*|Arquivo JPG|*.Jpg','Diretorio',0,'C:\',.T.,,.F.)}  

//Local cDirRead	:=  GetSrvProfString("ROOTPATH","") + "\modelos_processo\"

Local cDirRead	:=  /*GetSrvProfString("ROOTPATH","") + */"\modelos_processo\"

Private oDlg
Private nRadio	:= 1 
Private cCombo1	:= ""
Private cCombo2	:= ""
Private oSay1, oSay2, oSay3, oSay4, oSay5, oSay6
Private oTGet1, oTGet2, oTGet3, oTGet4
Private oCombo1, oCombo2

//-- Array com todos os modelos de processo encontrados no diretório
aModelos := Directory( cDirRead + "*.TXT" )

//-- Monto o combo de processo de acordo com os modelos existentes
If !Empty(aModelos)
	For nX := 1 To Len(aModelos)
		AADD( aCombo2, SUBSTR(aModelos[nX][1], 1, AT(".", aModelos[nX][1]) - 1) )
	Next
EndIf

//-- Defino a tela
DEFINE DIALOG oDlg TITLE "Geração de Arquivo" FROM 0,0 TO 415,1100 PIXEL
 
 	//RadioButton
 	oRadio := TRadMenu():New (06,07,aRadio,,oDlg:Refresh(),,,,,,,,100,12,,,,,.T.)     
 	oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}	
 	oRadio:bChange := {|a,b| HabltRadi(nRadio, cCombo1)}

	//Grupo "Processos"	
   oGroup2	:= TGroup():New(19,04,49,549,'Gerar por Processo',oDlg,,,.T.)
   
   oSay5	:= TSay():New( 31,12,{||'Processo: '},oDlg,,/*oFont*/,,,,.T.,CLR_BLACK,CLR_WHITE,46,08)
   oCombo2	:= TComboBox():New(30,62,{|u|If(PCount()>0,cCombo2:=u,cCombo2)},aCombo2,90,12,oDlg,,,,,,.T.,,,,,,,,,'cCombo2')
   oCombo2:bChange := {|a,b| HabltCbo(2,cCombo2)}
   oCombo2:SetFocus()
 
   //Grupo "Tabelas"	
   oGroup1	:= TGroup():New(52,04,140,549,'Gerar por Tabela',oDlg,,,.T.)
   
   oSay1	:= TSay():New( 64,12,{||'Tabela (From): '},oDlg,,/*oFont*/,,,,.T.,CLR_BLACK,CLR_WHITE,28,08)
   oTGet1	:= TGet():New( 62,62,{|u| If(PCount()==0, cEdit1, cEdit1:= u)},oGroup1,015,008,"@!",,0,,,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,,.F.,,,,,,)
      
   oSay2	:= TSay():New( 80,12,{||'Tipo de Consulta: '},oDlg,,/*oFont*/,,,,.T.,CLR_BLACK,CLR_WHITE,46,08)
   oCombo1	:= TComboBox():New(80,62,{|u| If(PCount()>0,cCombo1:=u,cCombo1)},aCombo1,65,12,oDlg,,,,,,.T.,,,,{||.F.},,,,,'cCombo1')
   oCombo1:bChange := {|a,b,c| HabltCbo(1,cCombo1,cEdit1)}
   
   oSay3	:= TSay():New( 98,12,{||'Filtro (Select): '},oDlg,,/*oFont*/,,,,.T.,CLR_BLACK,CLR_WHITE,46,08)
   oTGet2	:= TGet():New( 98,62,{|u| If(PCount()==0, cEdit2, cEdit2:= u)},oGroup1,478,008,"@!",,0,,,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,,.F.,,,,,,)
   
   oSay4	:= TSay():New( 116,12,{||'Condição (Where): '},oDlg,,/*oFont*/,,,,.T.,CLR_BLACK,CLR_WHITE,46,08)  
   oTGet3	:= TGet():New( 116,62,{|u| If(PCount()==0, cEdit3, cEdit3:= u)},oGroup1,478,008,"@!",,0,,,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,,.F.,,,,,,)
	
	//Grupo "Caminho"
	oGroup3	:= TGroup():New(143,04,177,549,'Caminho do Arquivo',oDlg,,,.T.)
	
	oSay6	:= TSay():New( 158,12,{||'Salvar em: '},oDlg,,/*oFont*/,,,,.T.,CLR_BLACK,CLR_WHITE,35,08)
	oTButton1	:= TButton():New( 158, 148, "...",oDlg,bProcura,15,10,,,.F.,.T.,.F.,,.F.,,,.F. )  
	oTGet4	:= TGet():New( 158,45,{|u| If(PCount()==0, cPath, cPath:= u)},oGroup2,100,008,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,,,,,)

	//Botões  
	oTButton2	:= TButton():New( 185, 488, "Gerar Arquivo",oDlg,{|a,b,c,d,e,f,g,h,i|aQuery := ValidGer(nRadio,cDirRead,cCombo1,cCombo2,cEdit1,cEdit2,cEdit3,cEdit4,cPath)}, 60,15,,,.F.,.T.,.F.,,.F.,,,.F. )   


ACTIVATE DIALOG oDlg CENTERED


//-- Monto o array arquivo
AADD(aArquivo, aQuery)
AADD(aArquivo, cPath)


Return(aArquivo)
//------------------------------------------------------------------------------------
/*/{Protheus.doc} ValidGer
Função que valida as informações da tela antes de gerar o arquivo

@param nRadio, Número, Opção do Radio Button
@param cDirRead, Caracter, Diretório dos arquivos modelos 
@param cCombo1, Caracter, Conteúdo do Combo1
@param cCombo2, Caracter, Conteúdo do Combo2
@param cEdit1, Caracter, Conteúdo do campo cEdit1
@param cEdit2, Caracter, Conteúdo do campo cEdit2
@param cEdit3, Caracter, Conteúdo do campo cEdit3
@param cEdit4, Caracter, Conteúdo do campo cEdit4
@param cPath, Caracter, Caminho que o arquivo será gerado

@author Denis R. de Oliveira
@since 16/06/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------
Static Function ValidGer(nRadio,cDirRead,cCombo1,cCombo2,cEdit1,cEdit2,cEdit3,cEdit4,cPath)

Local aQuery	:= {}

Default nRadio	:= 1
Default cDirRead	:= ""
Default cCombo1	:= ""
Default cCombo2	:= ""
Default cEdit1	:= ""
Default cEdit2	:= ""
Default cEdit3	:= ""
Default cEdit4	:= ""
Default cPath		:= ""

//Se o tipo de geração do arquivo for igual a 1=Processo
If nRadio == 1
	
	If Empty(cCombo2)
		MsgAlert("Favor informe o processo!","Alerta")
		oCombo2:SetFocus()
	ElseIf Empty(cPath)
		MsgAlert("Favor informe o caminho que o arquivo será gerado!","Alerta")
		oTGet4:SetFocus()
	Else
		aQuery := MontaQry(nRadio,cDirRead,cCombo1,cCombo2,cEdit1,cEdit2,cEdit3,cEdit4)
		AADD(aQuery[1], 1)
		oDlg:End()
	EndIf

Else
	
	If Empty(cEdit1)
		MsgAlert("Favor informe a tabela que será gerada!","Alerta")
		oTGet1:SetFocus()
	ElseIf Empty(cCombo1)
		MsgAlert("Favor informe o tipo de consulta!","Alerta")
		oCombo1:SetFocus()
	ElseIf cCombo1 == "2" .And. Empty(cEdit2)
		MsgAlert("Favor informe os campos do filtro!","Alerta")
		oTGet2:SetFocus()
	ElseIf Empty(cPath)
		MsgAlert("Favor informe o caminho que o arquivo será gerado!","Alerta")
		oTGet4:SetFocus()
	Else
		aQuery := MontaQry(nRadio,cDirRead,cCombo1,cCombo2,cEdit1,cEdit2,cEdit3,cEdit4)
		AADD(aQuery[1], 1)
		oDlg:End()
	EndIf

EndIF


Return(aQuery)
//------------------------------------------------------------------------------------
/*/{Protheus.doc} HabltRadi
Função responsável por habilitar e desabilitar campos na tela através do radio button

@param nRadio, Número, Opção do Radio Button
@param cCombo, Caracter, Conteúdo do combo

@author Denis R. de Oliveira
@since 16/06/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------
Static Function HabltRadi(nRadio,cCombo)

Default nRadio	:= 1
Default cCombo	:= ""

//Se o tipo de geração do arquivo for igual a 2=Tabela
If nRadio == 2

	//Habilito tabela
	oCombo1:bWhen	:= {|| .T. }
	
	oTGet1:bWhen	:= {|| .T. }
	oTGet3:bWhen	:= {|| .T. } 
	
	//Se o tipo de filtro for igual a 2=Filtrar por Campos
	If cCombo == "2"
		oTGet2:bWhen	:= {|| .T. } 	
	EndIF
	
	//Desabilito processo
	oCombo2:bWhen	:= {|| .F. }
	
	//Focus	
	oTGet1:SetFocus()

//Se o tipo de geração do arquivo for igual a 1=Processo
Else

 	//Habilito processo
	oCombo2:bWhen	:= {|| .T. }
	
	//Desabilito tabela
	oCombo1:bWhen	:= {|| .F. }
	
	oTGet1:bWhen	:= {|| .F. }
	oTGet2:bWhen	:= {|| .F. }
	oTGet3:bWhen	:= {|| .F. }
	
	//Focus	
	oCombo2:SetFocus()
	
EndIf

//Refresh na Tela
oDlg:Refresh()


Return 
//------------------------------------------------------------------------------------
/*/{Protheus.doc} HabltCbo
Função responsável por habilitar e desabilitar campos na tela através dos combo box

@param nRadio, Número, Opção do Radio Button
@param cCombo, Caracter, Conteúdo do combo
@param cConteud, Caracter, Conteúdo do campo

@author Denis R. de Oliveira
@since 16/06/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------
Static Function HabltCbo(nChamada,cCombo,cConteud)

Default nChamada	:= "1"
Default cCombo	:= "1"
Default cConteud	:= ""

If nChamada == 1
	//Se o tipo de filtro for igual a 2=Filtrar por Campos
	If cCombo == "2"
	
		oTGet2:bWhen	:= {|| .T. } 
		
		//Focus	
		If Empty(cConteud)
			oTGet1:SetFocus()
		Else
			oTGet2:SetFocus()
		EndIF		
	
	Else
	
		oTGet2:bWhen	:= {|| .F. }
		
		//Focus		
		If Empty(cConteud)
			oTGet1:SetFocus()
		Else
			oTGet3:SetFocus()
		EndIF
		
		
	EndIf
	
Else

	//Focus		
	If Empty(cCombo)
		oCombo2:SetFocus()
	Else
		oTGet4:SetFocus()
	EndIF
	
EndIf

//Refresh na Tela
oDlg:Refresh()


Return 
//-------------------------------------------------------------------
/*/{Protheus.doc} MontaQry
Função que monta query através das informações fornecidas pelo usuário

@param nRadio, Número, Opção do Radio Button
@param cDirRead, Caracter, Diretório dos arquivos modelos 
@param cCombo1, Caracter, Conteúdo do Combo1
@param cCombo2, Caracter, Conteúdo do Combo2
@param cEdit1, Caracter, Conteúdo do campo cEdit1
@param cEdit2, Caracter, Conteúdo do campo cEdit2
@param cEdit3, Caracter, Conteúdo do campo cEdit3
@param cEdit4, Caracter, Conteúdo do campo cEdit4

@author Denis R. de Oliveira
@since 16/06/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function MontaQry(nRadio,cDirRead,cCombo1,cCombo2,cEdit1,cEdit2,cEdit3,cEdit4)

Local aTabela		:= {} 
Local aFilCpos	:= {} 
Local aCondicao	:= {}
Local aArqModel 	:= {}

Local cArquivo	:= ""
Local cArqModel	:= ""

Local nX	:= 0
Local nY	:= 0

Local aQuery	:= {}
Local aQryTab	:= Array(3)

Default nRadio := 0
Default cDirRead := ""
Default cCombo1 := ""
Default cCombo2 := ""
Default cEdit1 := ""
Default cEdit2 := ""
Default cEdit3 := ""
Default cEdit4 := ""


//-- Tipo de Geração do Arquivo informado
If nRadio == 1 //Processo

	//-- Arquivo modelo
	cArquivo := cDirRead + cCombo2 + ".txt"
	
	//-- Transformo o arquivo texto em array
	cArqModel := ReadTxt(cArquivo)
		
	//-- Transformo o arquivo texto em array
	aArqModel := StrTokArr2(FwCutOff(AllTrim(cArqModel)), ";", .T.)
				
	//-- Monto o array de query
	For nY	:= 1 To Len(aArqModel)
		
		aQryTab[1] := Alltrim(aArqModel[nY])
		aQryTab[2] := Alltrim(aArqModel[nY+1])
		aQryTab[3] := Alltrim(aArqModel[nY+2])
			
		//Implemento o contador
		nY := nY+2
			
		//Adiciono a query da tabela no array de querys
		AADD(aQuery, aClone(aQryTab))
		
	Next
	
Else //Tabela

	//Recebo a tabela informada
	AADD(aTabela, {Alltrim(cEdit1)})
	
	//Se foi selecionada a opção "2=Filtrar por Campos", recebo o filtro informado
	If cCombo1 == "2"
		AADD(aFilCpos, Alltrim(cEdit2))
	EndIf

	//Recebo a condição informada
	Iif(!Empty(cEdit3), AADD(aCondicao, Alltrim(cEdit3)), cEdit3)

EndIf

//-- Laço no array de tabelas
For nX := 1 To Len(aTabela)

	//-- Se foi informada tabela na posição do array
	If !Empty(aTabela[nX][1])
		
		//Recebo a tabela posicionada no array
		aQryTab[1] := aTabela[nX][1]
		
		//Se existe filtro de campos
		If !Empty(aFilCpos)
			aQryTab[2] := aFilCpos[nX]
		EndIf	
		
		//Se existe condição
		If !Empty(aCondicao)
		
			//Se o tipo da geração do arquivo (2-Tabela)
			If nRadio == 2
				aQryTab[3] := aCondicao[nX]
			EndIf
		
		EndIf
	
		//Adiciono a query da tabela no array de querys
		AADD(aQuery, aClone(aQryTab))
		
		//Limpo as variáveis / arrays	
		aQryTab := Array(3)
			
	
	EndIf	

Next


Return(aQuery)
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*/{Protheus.doc} Cabec()
Função que gera um array com o cabeçalho da tabela

@Param cTabela, Tabela que será transformada em arquivo texto/csv
@return aRetCab, Retorna um array com o nome dos campos da tabela

@author Denis R. de Oliveira
@since 06/06/2016
@version 1.0
/*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
Static Function Cabec(cTabela)

Local aRetCab	:= {}

Default cTabela	:= ""

//Abro e posiciono na tabela SX3
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cTabela + "01")
	
//Monto array com o nome dos campos da tabela, ignorando memo e virtual
While (X3_ARQUIVO == cTabela .AND. X3_TIPO <> "M" .AND. X3_CONTEXT <> "V")
					
	AADD(aRetCab, Alltrim(X3_CAMPO))
		
	DbSkip()
	
EndDo  


Return(aRetCab)
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*/{Protheus.doc} Fields()
Função que gera um array com os campos da tabela

@Param nFiltro, Número, Se existe condição nessa tabela
@Param cTabela, Tabela que será transformada em arquivo texto/csv
@Param cFiltro, Caracter, Campos da tabela
@Param cCondicao, Caracter, Condição aplicada na tabela

@return aRetCmp, Retorna um array com os campos da tabela

@author: Rafael Santana - SQA Fiscal
@since: 10/11/2015
@version 1.0

@author: Denis R. de Oliveira
@since: 06/06/2016
@version 1.1
/*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
Static Function Fields(nFiltro, cTabela, cFiltro, cCondicao)

Local cAliasCpo	:= ""
Local cFilia	:= ""
Local cQuery	:= ""
Local aRetCmp := {}
Local aCampos := {}
Local nCont   := 0
Local oError
Local cAliasAux	:= GetNextAlias()
Local cCodEmp 	:= FWArrFilAtu()[1]

Private lErr	:= .F.

oError	  	:= ErrorBlock( { |oError| TratError(oError,@lErr,cTabela) } )

Default nFiltro	:= 0
Default cTabela	:= ""
Default cFiltro	:= ""
Default cCondicao	:= ""

//Monto a alias da tabela
If( At('S',cTabela) == 1) 
	cAliasCpo := SUBSTR(cTabela,2,2)
Else
	cAliasCpo := SUBSTR(cTabela,1,3)
EndIf

//Recebo a filial corrente
cFilia := xFilial(cTabela)

//Monto a tabela a ser utilizada (Alias + Empresa)
cTabela := cTabela + cCodEmp + "0" 

//Verifico se a tabela existe no banco, caso contrario eu abro
If ! TCCanOpen( cTabela )

	DbSelectArea(cTabela)

EndIf

//Busco o conteúdo dos campos da tabela
cQuery	:= "SELECT " + cFiltro + " "
cQuery += "FROM  " + RetSqlName(cTabela) + " " + cTabela + " " 
cQuery += "WHERE" 

//Caso exista condição, adiciono na query
If nFiltro == 1
	cQuery += " " + cCondicao + " AND"
EndIf

//Filtro pela filial corrente 
cQuery += " " + cAliasCpo + "_FILIAL = '" + cFilia + "' AND" 

//Filtro os campos deletados
cQuery += " " + cTabela + ".D_E_L_E_T_ = '' " 	

//Ajusto a query de acordo com o banco utilizado
cQuery := ChangeQuery(cQuery)

//Abro a área de trabalho com controle de execução
Begin Sequence

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)

End Sequence


//Verifico se existe algum erro na execução da query
If !lErr

	//Seto o tamanho do array de campos
	aCampos	:= Array(Fcount())

	//Monto o array com conteúdo da tabela
	While (cAliasAux)->(!EOF())
	
		//Monto o registro tabela   
		For nCont := 1 To Fcount()
			aCampos[nCont] := FieldGet(nCont)
		Next
	
		//Adiciono o registro tabela no array  
		Aadd(aRetCmp,aClone(aCampos))

		(cAliasAux)->(DbSkip())

	Enddo

	//Fecho a área de trabalho
	(cAliasAux)->(DbCloseArea())

EndIf


Return(aRetCmp)
//-------------------------------------------------------------------
/*/{Protheus.doc} TratError
Efetua tratamento de error na query

@param	oError, Objeto, Objeto que carrega erro
@param	lErr, Lógico, Define se foi encontrado erro
@Param cTabela, Caracter, Tabela que será transformada em arquivo texto/csv

@author Denis R. de Oliveira
@since 16/06/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function TratError(oError, lErr, cTabela)

Local cErr  := oError:Description
Local cError	:= ""
Local lAutomato := .F.

Default lErr	:= .F.
Default cTabela	:= ""

//Recebo se a função é executada por tela
lAutomato := Iif (IsBlind(),.T.,.F.)

//Recebo o erro
cError := "Não foi possível gerar o arquivo: " + cTabela + CRLF + CRLF + "Favor verifique o erro abaixo: "  + CRLF + cErr

//Tratamento para erro na query
If !lErr
	
	If !lAutomato
		
		MsgAlert(cError, "Erro na geração do arquivo")
	
	Else
	
		ConOut(cError)
	
	EndIf	

EndIf

//Variavel de controle de erro, recebe verdadeiro
lErr	:= .T.

Return(Nil)
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*/{Protheus.doc} xArrToTxt
Função que exporta o array de cabeçalho e campos para arquivo texto

@param aVetCab, Array com os dados do cabeçalho
@param aVetCmp, Array com os dados dos campos
@param cArquivo, String com o caminho e nome do arquivo

@return cTextoAux, Retorna a string com o conteúdo do arquivo

@author Denis R. de Oliveira
@since 06/06/2016
@version 1.1
/*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
Static Function xArrToTxt(aVetCab, aVetCmp, cArquivo)

Local cTextoAux	:= ""
Local cEspac		:= ""
Local nLinha	:= 0
Local nI		:= 0 
Local lQuebr	:= .F.

Default aVetCab   := {}
Default aVetCmp   := {}
Default cArquivo  := ""

 
//Imprimo o cabeçalho
If Len(aVetCab) > 0

	//Percorrendo o Array de Cabeçalho
	For nLinha := 1 To Len(aVetCab)
		cTextoAux += cEspac + Alltrim(aVetCab[nLinha]) + ";"
	Next        
	cTextoAux += CRLF

EndIf
     
//Imprimo o conteúdo dos campos
If Len(aVetCmp) > 0

	//Percorrendo o Array de Campos
	For nLinha := 1 To Len(aVetCmp)
		
		aCampos := aVetCmp[nLinha] 
		
		//Percorrendo o Array
       For nI := 1 To Len(aCampos)
       	xImprArray(aCampos[nI], @cTextoAux, lQuebr, nLinha)
       Next

		cTextoAux += CRLF

	Next        

EndIf

//Se não tiver em branco, gera o arquivo
If !Empty(cArquivo)
	MemoWrite(cArquivo, cTextoAux)
EndIf


Return cTextoAux
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*/{Protheus.doc} xImprArray()
Rotina que imprime o conteúdo do campo no arquivo de texto

@param cContCmp, String com o conteúdo do campo que será impresso
@param cTextoAux, String com o conteúdo do arquivo que será gerado
@param lQuebr, Define a quebra de linha do arquivo

@author Denis R. de Oliveira
@since 06/06/2016
@version 1.0
/*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
Static Function xImprArray(cContCmp, cTextoAux, lQuebr)
    
Local cEspac := ""

Default cContCmp   := ""
Default cTextoAux  := ""
Default lQuebr	:= .F.

//Imprimo o conteúdo, de acordo com o tipo do conteúdo do campo
//Se o tipo for caractere/memo
If ValType(cContCmp) == "C"
 	cTextoAux += cEspac + AllTrim(StrTran(cContCmp, ";", " |")) + ";"       

//Se o tipo for numérico
ElseIf ValType(cContCmp) == "N"
	cTextoAux += cEspac + cValToChar(cContCmp) + ";"
     
//Se o tipo for Data
ElseIf ValType(cContCmp) == "D"
	cTextoAux += cEspac + DTOC(cContCmp) + ";"
             
//Se o tipo for Lógico
ElseIf ValType(cContCmp) == "L"
	cTextoAux += cEspac + cValToChar(cContCmp) + ";"
	     
EndIf
    
    
Return
//-----------------------------------------------------------------
/*/{Protheus.doc} ReadTxt
Leio arquivo txt e retorno as informações numa string

@param cArqTxt, Caracter, Caminho do arquivo de texto

@author Denis R. de Oliveira
@since 23/06/2016
@version 1.0
/*/
//-----------------------------------------------------------------
Static Function ReadTxt(cArqTxt)

Local nHandle    := 0
Local nTamArq    := 0
Local cArqReturn := ""
Local xBuffer    := ""

Default cArqTxt	:= ""

If !Empty(cArqTxt)

	//Leitura do arquivo txt
	nHandle :=	FOpen(cArqTxt)
	nTamArq :=	FSeek(nHandle,0,2)
	xBuffer := Space(nTamArq)
	
	FSeek(nHandle,0,0)
	FRead(nHandle,@xBuffer,nTamArq)
	FClose(nHandle)
	
	//Gravo as informações do txt numa string
	cArqReturn := xBuffer

EndIf


Return(cArqReturn)

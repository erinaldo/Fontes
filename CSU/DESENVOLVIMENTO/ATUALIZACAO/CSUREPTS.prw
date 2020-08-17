#INCLUDE "PROTHEUS.CH"

User Function CSUREPTS()

Local nOpc      := 0
Local cCadastro := "Replace campo TES"
Local aSay      := {}
Local aButton   := {}

aAdd( aSay, "O objetivo desta rotina e efetuar a leitura, em um arquivo texto do tipo .csv" )
aAdd( aSay, "os dados das notas fiscais de sa�da que devem ter o conte�do do campo TES alterado." )

aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	Processa( {|| Import() }, "Processando..." )
Endif

Return


STATIC FUNCTION Import()

Local cBuffer   := ""
Local cFileOpen := ""
Local cTitulo1  := "Selecione o arquivo"
Local cExtens   := "Arquivo CSV | *.csv"
Local aLinha    := {}
Local aDados    := {}
Local _lFez     := .T.

cFileOpen := cGetFile(cExtens,cTitulo1,,,.T.)

If !File(cFileOpen)
   	MsgAlert("Arquivo: " + cFileOpen + " n�o localizado", cCadastro)
   	Return
Endif

FT_FUSE(cFileOpen)
FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While !FT_FEOF()
   	IncProc()

	cBuffer := FT_FREADLN()
    aLinha := ImpArr(cBuffer)
	aAdd(aDados,{aLinha[1],aLinha[2],aLinha[3],aLinha[4],aLinha[5],aLinha[6],aLinha[7]})
   	FT_FSKIP()
EndDo

FT_FUSE()

GravaDados(aDados)

If _lFez
	MsgInfo("Replace Finalizado")
EndIf

Return



Static Function ImpArr(cString)
             
Local aRet    := {}
Local nProc
Local cDelim  := ";"
    
//��������������������������������������������������������������Ŀ
//� Atribui valores default aos parametros                       �
//����������������������������������������������������������������
Default cString := ""
   
//��������������������������������������������������������������Ŀ
//� Adiciona um delimitador ao final da string - pos while       �
//����������������������������������������������������������������
cString += if( len(cString)==0, "", cDelim )
   
//��������������������������������������������������������������Ŀ
//� - Procura a posicao do delimitador                           �
//� - Adiciona a matriz o elemento delimitado                    �
//� - Elimina da string o elemento acima                         �
//����������������������������������������������������������������
Do While ! Empty( cString )
	If ! ( nProc := at( cDelim, cString ) ) == 0
		aAdd( aRet, SubStr( cString, 1, nProc - 1 ) )
		cString := SubStr( cString, nProc + Len( cDelim ) )
	Endif
EndDo

Return(aRet)

Static Function GravaDados(aDados)

Local _cQuery := ""
Local _cMens  := ""

For nX := 1 to Len(aDados)
	_cQuery := "SELECT SD2.R_E_C_N_O_ AS RECNO FROM " + RetSqlName("SD2") + " SD2 WHERE "
	_cQuery += "SD2.D2_FILIAL = '" + aDados[nX,1] + "' AND "
	_cQuery += "SD2.D2_DOC = '" + aDados[nX,2] + "' AND "
	_cQuery += "SD2.D2_EMISSAO = '" + Dtos(Ctod(aDados[nX,3])) + "' AND "
	_cQuery += "SD2.D2_COD = '" + aDados[nX,4] + "' AND "
	_cQuery += "SD2.D2_TES = '" + aDados[nX,6] + "' AND "
	_cQuery += "SD2.D_E_L_E_T_ = ' '"
	
	U_MontaView(_cQuery,"TRAB")
	TRAB->(dbGotop())
	If TRAB->(EOF())
		_cMens += "NF "+aDados[nX,2]+" FILIAL "+aDados[nX,1]+" N�O ALTERADA"+Chr(10)+Chr(13)
	Else
		Begin Transaction
			dbSelectArea("SD2")
			dbGoTo(TRAB->RECNO)
			RecLock("SD2",.F.)
			  	SD2->D2_TES := aDados[nX,7]
			MsUnlock()
		End Transaction
	EndIf
	TRAB->(dbCloseArea())
Next nX                  

If _cMens <> ""
	MsgInfo(_cMens)
EndIf

Return              
#Include "rwmake.ch"
#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma       ณLIB_DIVER บAutor  ณ Adilson Silva      บ Data ณ 28/04/2006  บฑฑ
ฑฑฬอออออออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.          ณ Funcoes Diversas.                                          บฑฑ
ฑฑบ               ณ                                                            บฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ fSomaDia      ณ Funcao para Somar Dias a Uma Data.                         บฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศอออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TemBenef บAutor  ณ Adilson Silva      บ Data ณ 28/04/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Informar Campos Virtuais de Relacionamentos    บฑฑ
ฑฑบ          ณ do Cadastro de Funcionarios.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function TemBenef( xAlias, xCondicao )

 Local cRet := "N"
 Local nAliasOrd, nAliasRec, cPrefix, cChave, nOrder
 Local cRetOrder, cWhile

 DEFAULT xAlias    := "@"
 DEFAULT xCondicao := "@"
 
 If xAlias + xCondicao == "@@"
    Return( cRet )
 EndIf
 
 nAliasOrd := ( xAlias )->( IndexOrd() )
 nAliasRec := ( xAlias )->( Recno() )

 cPrefix   := If( Left(xAlias,1)=="S",Right(xAlias,2),xAlias+"_" )
 cRetOrder := cPrefix + "_FILIAL+" + cPrefix + "_MAT"
 nOrder    := RetOrder( xAlias, cRetOrder )
 nOrder    := If( nOrder==0,1,nOrder )
 cWhile    := xAlias + "->(" + cRetOrder + ")"
 cChave    := "SRA->(RA_FILIAL+RA_MAT)"
 xCondicao := If( xCondicao#"@",xAlias + "->" + xCondicao,xCondicao )
 
 If ( xAlias )->(FieldPos( cPrefix + "_MAT" )) > 0
    ( xAlias )->(dbSetOrder( nOrder ))
   
    If ( xAlias )->(dbSeek( &( cChave ) ))
       Do While !( xAlias )->(Eof()) .And. &( cWhile )  == &( cChave )
          If xCondicao == "@"
             cRet := "S"
          Else
             If &( xCondicao )
                cRet := "S"
             EndIf
          EndIf
          
          ( xAlias )->( dbSkip() )
       EndDo
    EndIf
 EndIf

 ( xAlias )->(dbSetOrder( nAliasOrd ))
 ( xAlias )->(dbGoTo( nAliasRec ))

Return( cRet )

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณfSelectWordณ Autor ณ Adilson Silva        ณ Data ณ 01/02/07 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Selecao de Modelos na Emissao dos Relatorios via Word.     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ															  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function fSelectWord()

Local aOld := GETAREA()
Local nX   := 0 
Local lRet := .T.
Local cRet := ""
Local oOk  := LoadBitmap( GetResources(), "Enable" )
Local oNo  := LoadBitmap( GetResources(), "LBNO" )

Local oSelect

Local l1Elem      := .T.
Local nElemRet    := 1
Local lMultSelect := .F.

Local aArquivos   := {}
Local aDirect     := {}
Local cDirect     := GETMV( "MV_DIRWORD" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se ha XML a processar                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aDirect := Directory( cDirect + "*.DOT" )
For nX := 1 To Len( aDirect )
	Aadd( aArquivos, {.F., aDirect[nX,1]} )
Next nX

If Len( aArquivos ) == 0
   Aviso("ATENCAO", "NAO FOI ENCONTRADO NENHUM ARQUIVO NO DIRETORIO INDICADO NO PARAMETRO MV_DIRWORD", {"Ok"})
   Return( .F. )
EndIf

SETAPILHA()
DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Selecao Arquivos" ) FROM 026,043 TO 273,482 PIXEL OF oMainWnd
    
	@ 15,00 LISTBOX oSelect FIELDS HEADER " ", OemtoAnsi( "Sele็ใo de Arquivos" ) OF oDlg PIXEL SIZE 217,093;
	ON CHANGE (nPesq:=oSelect:nAt) ON DBLCLICK (aArquivos:=RspTrocaMarca(oSelect:nAt,aArquivos,l1Elem,nElemRet,lMultSelect,"M"), oSelect:Refresh(.f.))
	oSelect:SetArray(aArquivos)
  	oSelect:bLine := { ||{	If(aArquivos[oSelect:nAt,1],oOk,oNo),;
  							aArquivos[oSelect:nAt,2] }}
	oSelect:nFreeze := 1  							  							

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| lRet:= .T., oDlg:End()  },{|| lRet:=.F. ,oDlg:End()} )
SetaPilha()

DeleteObject(oOk)
DeleteObject(oNo)

If !lRet
   Aviso("ATENCAO","NENHUM ARQUIVO SELECIONADO",{"Sair"})
   Return( .F. )
EndIf

Aeval( aArquivos,{|x| cRet := If(x[1],x[2],cRet)} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLimpa o parametro para a Carga do Novo Arquivo                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SX1->(dbSeek( "GPWORD" + "25" , .T. )) 
   RecLock("SX1",.F.,.T.)
   SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
   mv_par25 := cRet
   MsUnLock()
EndIf	

RESTAREA( aOld )

Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FSQLIN   บAutor  ณ Adilson Silva      บ Data ณ  04/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Montar a Selecao da Clausula IN do SQL.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fSqlIN( cTexto, nStep )

 Local cRet := ""
 Local i
 
 cTexto := Rtrim( cTexto )

 If Len( cTexto ) > 0
    For i := 1 To Len( cTexto ) Step nStep
        cRet += "'" + SubStr( cTexto, i, nStep ) + "'"
        
        If i + nStep <= Len( cTexto )
           cRet += ","
        EndIf
    Next
 EndIf

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfZapTable บAutor  ณ Adilson Silva      บ Data ณ 10/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Limpar Base de Dados.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fZapTable( cAlias )

 Local lRet := .F.

 If Ma280Flock( cAlias )
    OpenIndX(cAlias,.F.)
     Zap
    dbCloseArea()
    ChkFile(cAlias,.F.)
    lRet := .T.
 EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlDeleteบAutor  ณMicrosiga           บ Data ณ  08/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fSqlDelete( aItens )
                                  
 Local cTxt   := ""
 Local lAS400 := TcSrvType() == "AS/400"
 //Local cBanco := TCGetDB()

 Local cAnd, nX

 DEFAULT aItens := {}
 
 If Len( aItens ) > 0
    For nX := 1 To Len( aItens )
        cAnd := If(nX==Len( aItens ),""," AND")
        If lAS400
           cTxt += " " + aItens[nX] + ".@DELETED@ <> '*'" + cAnd
        Else
           cTxt += " " + aItens[nX] + ".D_E_L_E_T_ <> '*'" + cAnd
        EndIf
    Next
 Else
    If lAS400
       cTxt += " @DELETED@ <> '*'"
    Else
       cTxt += " D_E_L_E_T_ <> '*'"
    EndIf
 EndIf

Return( cTxt )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlDeleteบAutor  ณMicrosiga           บ Data ณ  08/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fSqlFunction( cString )
                                  
 Local cBanco   := TCGetDB()
 Local aTroca   := {}
 Local nX

 DEFAULT cString := ""

 Aadd(aTroca,{ "ISNULL"		,	"NVL"		})
 Aadd(aTroca,{ "SUBSTRING"	,	"SUBSTR"	})
 
 cString  := Upper(Alltrim( cString ))
 
 For nX := 1 To Len( aTroca )
     If cBanco == "ORACLE"
        cString := " " + StrTran(cString,aTroca[nX,1],aTroca[nX,2])
     EndIf
 Next

Return( cString )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlDeleteบAutor  ณMicrosiga           บ Data ณ  08/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fDropTable( cTabela )

 Local cRet   := ""

 If TCGetDB() == "ORACLE"
    //cRet := "IF EXISTS(SELECT * FROM MSysObjects WHERE name = '" + cTabela + "') Then"
    //cRet += " DROP TABLE " + cTabela + " PURGE"
    //cRet += " End If"
    cRet := " DROP TABLE " + cTabela + " PURGE"
 Else
    cRet := "IF EXISTS(SELECT * FROM SysObjects WHERE name = '" + cTabela + "')"
    cRet += "   DROP TABLE " + cTabela
 EndIf

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlDeleteบAutor  ณMicrosiga           บ Data ณ  08/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fExistTable( cTabela )

 Local aOldAtu := GETAREA()
 Local cQuery  := ""
 Local lRet

 If TCGetDB() == "ORACLE"
    //cQuery := "SELECT COUNT(*) AS WT_COUNT FROM MSysObjects WHERE name = '" + cTabela + "'"
    cQuery := "SELECT COUNT(*) AS WT_COUNT FROM User_Tables WHERE table_name = '" + cTabela + "'"
 Else
    cQuery := "SELECT COUNT(*) AS WT_COUNT FROM SysObjects WHERE name = '" + cTabela + "'"
 EndIf
 dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "WEXIST", .T., .T.)
 lRet := WEXIST->WT_COUNT > 0
 WEXIST->(dbCloseArea())

 RESTAREA( aOldAtu )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlDeleteบAutor  ณMicrosiga           บ Data ณ  08/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fSelectInto( cTabela, lTipo, xAlias, aOrder )

 Local cRet   := ""
 Local nX
 
 DEFAULT aOrder := {}
 DEFAULT xAlias := "TMP" + Right(Str(Seconds(),6),3)

 If TCGetDB() == "ORACLE"
    If lTipo
       cRet := "CREATE TABLE " + cTabela + " AS SELECT * FROM ( "
    Else
       cRet := " ) " + xAlias
    EndIf
 Else
    If lTipo
       cRet := "SELECT * INTO " + cTabela + " FROM ( "
    Else
       cRet := " ) " + xAlias
    EndIf
 EndIf
 
 If Len( aOrder ) > 0
    cRet += " ORDER BY "
    For nX := 1 To Len( aOrder )
        cRet += xAlias + "." + aOrder[nX]
        If nX < Len( aOrder )
           cRet += ","
        EndIf
    Next
 EndIf

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlDeleteบAutor  ณMicrosiga           บ Data ณ  08/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fDropTemp( uTabela )

 Local cQuery, nX
 
 If ValType( uTabela ) == "C"
    U_fDropTable( uTabela )
 ElseIf ValType( uTabela ) == "A" .And. Len( uTabela ) > 0
    For nX := 1 To Len( uTabela )
        cQuery := U_fDropTable( uTabela[nX] )
        TcSqlExec( cQuery )
    Next
 EndIf    

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlDeleteบAutor  ณMicrosiga           บ Data ณ  08/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fLastReg( nSkip )

 Local nReg := 0
 
 DEFAULT nSkip := 20
 
 dbGoTop()
 Do While !Eof()
    dbSkip( nSkip )
    If !Eof()
       nReg := Recno()
    EndIf
 EndDo
 dbGoTop()

Return( nReg )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fMtaInss บAutor  ณ Adilson Silva      บ Data ณ 15/01/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a Tabela do INSS - SRX                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fMtaInss( aINSSTab, dDtRef )

 Local aOldAtu := GETAREA()
 Local aOldSrx := SRX->(GETAREA())
 Local cChave  := ""
 
 DEFAULT aINSSTab := {}
 DEFAULT dDtRef   := dDataBase
 
 dbSelectArea( "SRX" )
 dbSetOrder( 1 )
 
 aINSSTab := {0,0,0,0,0,0,0,0,0,0,0,0}

 cChave := xFilial( "SRX" ) + "08" + MesAno( dDtRef ) + "1"
 If dbSeek( cChave )
    aINSSTab[01] := Val(SubStr(SRX->RX_TXT,01,12))			// Limite 1
    aINSSTab[02] := Val(SubStr(SRX->RX_TXT,13,12))			// Limite 2
    aINSSTab[03] := Val(SubStr(SRX->RX_TXT,25,12))			// Limite 3
    aINSSTab[05] := Val(SubStr(SRX->RX_TXT,37,07))			// Perc Desconto 1
    aINSSTab[06] := Val(SubStr(SRX->RX_TXT,44,07))	 		// Perc Desconto 2
    aINSSTab[07] := Val(SubStr(SRX->RX_TXT,51,07))	  		// Perc Desconto 3
    cChave := xFilial( "SRX" ) + "08" + MesAno( dDtRef ) + "2"
    If dbSeek( cChave )
       aINSSTab[09] := Val(SubStr(SRX->RX_TXT,01,07))		// Perc Deducao IR 1
       aINSSTab[10] := Val(SubStr(SRX->RX_TXT,08,07))		// Perc Deducao IR 2
       aINSSTab[11] := Val(SubStr(SRX->RX_TXT,15,07))		// Perc Deducao IR 3
       aINSSTab[04] := Val(SubStr(SRX->RX_TXT,22,12))		// Limite 4
       aINSSTab[08] := Val(SubStr(SRX->RX_TXT,34,07))		// Perc Desconto 4
       aINSSTab[12] := Val(SubStr(SRX->RX_TXT,41,07))		// Perc Deducao IR 4
    EndIf
 Else
    cChave := xFilial( "SRX" ) + "08" + Space( 06 ) + "1"
    If dbSeek( cChave )
       aINSSTab[01] := Val(SubStr(SRX->RX_TXT,01,12))			// Limite 1
       aINSSTab[02] := Val(SubStr(SRX->RX_TXT,13,12))			// Limite 2
       aINSSTab[03] := Val(SubStr(SRX->RX_TXT,25,12))			// Limite 3
       aINSSTab[05] := Val(SubStr(SRX->RX_TXT,37,07))			// Perc Desconto 1
       aINSSTab[06] := Val(SubStr(SRX->RX_TXT,44,07))	 		// Perc Desconto 2
       aINSSTab[07] := Val(SubStr(SRX->RX_TXT,51,07))	  		// Perc Desconto 3
       cChave := xFilial( "SRX" ) + "08" + Space( 06 ) + "2"
       If dbSeek( cChave )
          aINSSTab[09] := Val(SubStr(SRX->RX_TXT,01,07))		// Perc Deducao IR 1
          aINSSTab[10] := Val(SubStr(SRX->RX_TXT,08,07))		// Perc Deducao IR 2
          aINSSTab[11] := Val(SubStr(SRX->RX_TXT,15,07))		// Perc Deducao IR 3
          aINSSTab[04] := Val(SubStr(SRX->RX_TXT,22,12))		// Limite 4
          aINSSTab[08] := Val(SubStr(SRX->RX_TXT,34,07))		// Perc Desconto 4
          aINSSTab[12] := Val(SubStr(SRX->RX_TXT,41,07))		// Perc Deducao IR 4
       EndIf
    Else
       Return( .F. )
    EndIf
 EndIf

 RESTAREA( aOldSrx )
 RESTAREA( aOldAtu )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fMtaInss บAutor  ณ Adilson Silva      บ Data ณ 15/01/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a Tabela do INSS - SRX                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fMtaIrrf( aIRTab, dDtRef, cTipo )

 Local aOldAtu := GETAREA()
 Local aOldSrx := SRX->(GETAREA())
 Local cChave  := ""
 Local aTemp   := {}
 
 DEFAULT aIRTab := {}
 DEFAULT dDtRef := dDataBase
 DEFAULT cTipo  := "FOL"
 
 dbSelectArea( "SRX" )
 dbSetOrder( 1 )
 
 aIRTab := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

 If cTipo == "FOL"
    cChave := xFilial( "SRX" ) + "09" + MesAno( dDtRef ) + "1"
    If dbSeek( cChave )
       aIRTab[01] := Val(SubStr(SRX->RX_TXT,01,12))			// Isento
       aIRTab[02] := Val(SubStr(SRX->RX_TXT,13,12))			// Rendimento 1
       aIRTab[03] := Val(SubStr(SRX->RX_TXT,25,06))			// Aliquota 1
       aIRTab[04] := Val(SubStr(SRX->RX_TXT,31,12))			// Deduzir 1
       aIRTab[05] := Val(SubStr(SRX->RX_TXT,43,12))			// Rendimento 2
       cChave := xFilial( "SRX" ) + "09" + MesAno( dDtRef ) + "2"
       If dbSeek( cChave )
          aIRTab[06] := Val(SubStr(SRX->RX_TXT,01,06))	 	// Aliquota 2
          aIRTab[07] := Val(SubStr(SRX->RX_TXT,07,12))	 	// Deduzir 2
          aIRTab[08] := Val(SubStr(SRX->RX_TXT,19,12))		// Rendimento 3
          aIRTab[09] := Val(SubStr(SRX->RX_TXT,31,06))		// Aliquota 3
          aIRTab[10] := Val(SubStr(SRX->RX_TXT,37,12))		// Deduzir 3
          cChave := xFilial( "SRX" ) + "09" + MesAno( dDtRef ) + "3"
          If dbSeek( cChave )
             aIRTab[11] := Val(SubStr(SRX->RX_TXT,01,12))		// Deducao p/ Dependente
             aIRTab[12] := Val(SubStr(SRX->RX_TXT,13,02))		// Limite Dependentes
             aIRTab[13] := Val(SubStr(SRX->RX_TXT,15,11))		// Retencao Minima
             aIRTab[14] := Val(SubStr(SRX->RX_TXT,26,12))		// Rendimento 4
             aIRTab[15] := Val(SubStr(SRX->RX_TXT,38,06))		// Aliquota 4
             aIRTab[16] := Val(SubStr(SRX->RX_TXT,44,12))		// Deduzir 4
          EndIf
       EndIf
    Else
       cChave := xFilial( "SRX" ) + "09" + Space( 06 ) + "1"
       If dbSeek( cChave )
          aIRTab[01] := Val(SubStr(SRX->RX_TXT,01,12))		// Isento
          aIRTab[02] := Val(SubStr(SRX->RX_TXT,13,12))		// Rendimento 1
          aIRTab[03] := Val(SubStr(SRX->RX_TXT,25,06))		// Aliquota 1
          aIRTab[04] := Val(SubStr(SRX->RX_TXT,31,12))		// Deduzir 1
          aIRTab[05] := Val(SubStr(SRX->RX_TXT,43,12))		// Rendimento 2
          cChave := xFilial( "SRX" ) + "09" + Space( 06 ) + "2"
          If dbSeek( cChave )
             aIRTab[06] := Val(SubStr(SRX->RX_TXT,01,06))	 	// Aliquota 2
             aIRTab[07] := Val(SubStr(SRX->RX_TXT,07,12))	 	// Deduzir 2
             aIRTab[08] := Val(SubStr(SRX->RX_TXT,19,12))		// Rendimento 3
             aIRTab[09] := Val(SubStr(SRX->RX_TXT,31,06))		// Aliquota 3
             aIRTab[10] := Val(SubStr(SRX->RX_TXT,37,12))		// Deduzir 3
             cChave := xFilial( "SRX" ) + "09" + Space( 06 ) + "3"
             If dbSeek( cChave )
                aIRTab[11] := Val(SubStr(SRX->RX_TXT,01,12))	// Deducao p/ Dependente
                aIRTab[12] := Val(SubStr(SRX->RX_TXT,13,02))	// Limite Dependentes
                aIRTab[13] := Val(SubStr(SRX->RX_TXT,15,11))	// Retencao Minima
                aIRTab[14] := Val(SubStr(SRX->RX_TXT,26,12))	// Rendimento 4
                aIRTab[15] := Val(SubStr(SRX->RX_TXT,38,06))	// Aliquota 4
                aIRTab[16] := Val(SubStr(SRX->RX_TXT,44,12))	// Deduzir 4
             EndIf
          EndIf
       Else
          Return( .F. )
       EndIf
    EndIf
 Else
    fCarrTab( aTemp, "S034", dDataBase )
    If Len( aTemp ) > 0
       aIRTab[01] := aTemp[1,06+1]		// Isento
       aIRTab[02] := aTemp[1,07+1]		// Rendimento 1
       aIRTab[03] := aTemp[1,08+1]		// Aliquota 1
       aIRTab[04] := aTemp[1,09+1]		// Deduzir 1
       aIRTab[05] := aTemp[1,10+1]		// Rendimento 2
       aIRTab[06] := aTemp[1,11+1]	 	// Aliquota 2
       aIRTab[07] := aTemp[1,12+1]	 	// Deduzir 2
       aIRTab[08] := aTemp[1,13+1]		// Rendimento 3
       aIRTab[09] := aTemp[1,14+1]		// Aliquota 3
       aIRTab[10] := aTemp[1,15+1]		// Deduzir 3
       aIRTab[11] := aTemp[1,19+1]		// Deducao p/ Dependente
       aIRTab[12] := aTemp[1,20+1]		// Limite Dependentes
       aIRTab[13] := aTemp[1,21+1]		// Retencao Minima
       aIRTab[14] := aTemp[1,16+1]		// Rendimento 4
       aIRTab[15] := aTemp[1,17+1]		// Aliquota 4
       aIRTab[16] := aTemp[1,18+1]		// Deduzir 4
    Else
       Return( .F. )
    EndIf
 EndIf
 
 RESTAREA( aOldSrx )
 RESTAREA( aOldAtu )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fIRCalc  บAutor  ณMicrosiga           บ Data ณ  01/22/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fIRCalc( nBaseCalc, nDepend, aIRTab, nValIrrf, nValDepen )

 DEFAULT nBaseCalc := 0
 DEFAULT nDepend   := 0
 DEFAULT aIRTab    := {}
 DEFAULT nValIrrf  := 0
 DEFAULT nValDepen := 0

 // Deduz Dependentes
 If nDepend > 0
    nValDepen := Round( nDepend * aIRTab[11],2 )
    nBaseCalc := nBaseCalc - nValDepen
 EndIf
      
 // Calculo do Imposto de Renda
 If nBaseCalc <= aIRTab[01]
    nValIrrf := 0
 ElseIf nBaseCalc > aIRTab[01] .And. nBaseCalc <= aIRTab[02]
    nValIrrf := Round( nBaseCalc * (aIRTab[03]/100),2 )
    nValIrrf := nValIrrf - aIRTab[04]
 ElseIf nBaseCalc > aIRTab[02] .And. nBaseCalc <= aIRTab[05]
    nValIrrf := Round( nBaseCalc * (aIRTab[06]/100),2 )
    nValIrrf := nValIrrf - aIRTab[07]
 ElseIf nBaseCalc > aIRTab[05] .And. nBaseCalc <= aIRTab[08]
    nValIrrf := Round( nBaseCalc * (aIRTab[09]/100),2 )
    nValIrrf := nValIrrf - aIRTab[10]
 ElseIf nBaseCalc > aIRTab[08] .And. nBaseCalc <= aIRTab[14]
    nValIrrf := Round( nBaseCalc * (aIRTab[15]/100),2 )
    nValIrrf := nValIrrf - aIRTab[16]
 EndIf
 // Verifica Valor Minimo do IR
 nValIrrf := If( nValIrrf < aIRTab[13],0,nValIrrf )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfX2CompartบAutor  ณ Adilson Silva      บ Data ณ 13/02/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Tipo do Acesso das Tabelas do Sistema.           บฑฑ
ฑฑบ          ณ Exclusivo ou Compartilhado.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fX2Compart( cTab )

 Local lRet    := .T.
 Local aOldAtu := GETAREA()
 Local aOldSx2 := SX2->(GETAREA())
 
 DEFAULT cTab  := "SRA"
 
 SX2->(dbSetOrder( 1 ))
 If SX2->(dbSeek( cTab ))
    If SX2->X2_MODO == "C"
       lRet := .T.
    Else
       lRet := .F.
    EndIf
 EndIf

 RESTAREA( aOldSx2 )
 RESTAREA( aOldAtu )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fIdCalc  บAutor  ณMicrosiga           บ Data ณ  02/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fIdCalc( xId, xFilial )
 
 Local aOldAtu    := GETAREA()
 Local aOldSrv    := SRV->(GETAREA())
 Local lRvCompart := U_fX2Compart( "SRV" ) 
 Local cRet       := ""
 
 DEFAULT xFilial  := Space( 02 )
 DEFAULT xId      := Space( 03 )
 
 xFilial := If(lRvCompart,Space( 02 ),xFilial)

 SRV->(dbSetOrder( 2 ))
 If SRV->(dbSeek( xFilial + xId ))
    cRet := SRV->RV_COD
 EndIf

 RESTAREA( aOldSrv )
 RESTAREA( aOldAtu )

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVerFeriasบAutor  ณMicrosiga           บ Data ณ  05/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna se o funcionario esta em ferias em um determinado  บฑฑ
ฑฑบ          ณ periodo e qual este periodo.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cFil   -> Filial do Funcionario.                           บฑฑ
ฑฑบ          ณ cMat   -> Matricula do Funcionario.                        บฑฑ
ฑฑบ          ณ cPer   -> Periodo AAAAMM/Data a Ser Pesquisado.            บฑฑ
ฑฑบ          ณ dDtIni -> Variavel Passada por Referencia para Retorno     บฑฑ
ฑฑบ          ณ           do Inicio das Ferias - @dDtIni.                  บฑฑ
ฑฑบ          ณ dDtFim -> Variavel Passada por Referencia para Retorno     บฑฑ
ฑฑบ          ณ           do Termino das Ferias - @dDtFim.                 บฑฑ
ฑฑบ          ณ dDtBas -> Variavel Passada por Referencia para Retorno     บฑฑ
ฑฑบ          ณ           da Data Base das Ferias Calculadas no Periodo.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ U_fVerFerias( cFil, cMat, cPer, @dDtIni, @dDtFim, @dDtBas )บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Verdadeiro ou Falso.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fVerFerias( cFil, cMat, uPer, dDtIni, dDtFim, dDtBas )

 Local lRet    := .F.
 Local aOldAtu := GETAREA()
 Local aOldSrh := SRH->(GETAREA())

 DEFAULT cFil   := SRA->RA_FILIAL
 DEFAULT cMat   := SRA->RA_MAT
 DEFAULT uPer   := MesAno( dDataBase )
 DEFAULT dDtIni := Ctod("")
 DEFAULT dDtFim := Ctod("")
 DEFAULT dDtBas := Ctod("")
 
 If ValType( uPer ) == "D"
    uPer := MesAno( uPer )
 EndIf
 
 dbSelectArea( "SRH" )
 dbSetOrder( 1 )
 dbSeek( cFil + cMat )
 Do While !Eof() .And. SRH->(RH_FILIAL + RH_MAT) == cFil + cMat
    If MesAno( SRH->RH_DATAINI ) == uPer .Or. ;
       MesAno( SRH->RH_DATAFIM ) == uPer
       
       dDtIni := SRH->RH_DATAINI
       dDtFim := SRH->RH_DATAFIM
       dDtBas := SRH->RH_DATABAS
       
       lRet := .T.
       Exit
    EndIf
    
    dbSkip()
 EndDo

 RESTAREA( aOldSrh )
 RESTAREA( aOldAtu )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfChkGrava บAutor  ณ Adilson Silva      บ Data ณ 17/07/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se o fGeraVerba Devera' Efetivar o Lancamento no  บฑฑ
ฑฑบ          ณ aPd ( Para Aceitar Lancamento Manual).                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fChkGrava( xPd, xTipo )

 Local lRet := .T.
 
 DEFAULT xPd   := "@@@"
 DEFAULT xTipo := "V"
 
 // Verifica se o Lancamento Foi Realizado Manualmente
 If Abs(fBuscaPd( xPd, xTipo )) > 0
    If aPd[fLocaliaPd(xPd),7] $ "IAG"
       lRet := .F.
    EndIf
 EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlFiltroบAutor  ณ Adilson Silva      บ Data ณ 29/07/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Converte o Filtro de Usuario para Expressao em SQL para    บฑฑ
ฑฑบ          ณ uso na SELECT.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fSqlFiltro( cVar )

cVar := StrTran(Upper(cVar),".AND."," AND ")
cVar := StrTran(cVar,".OR."," OR ")
cVar := StrTran(cVar,"=="," = ")
cVar := StrTran(cVar,'"',"'")
cVar := StrTran(cVar,'$'," IN ")
cVar := StrTran(cVar,'ALLTRIM(',"LTRIM(")

Return( cVar )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlFiltroบAutor  ณ Adilson Silva      บ Data ณ 29/07/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Converte o Filtro de Usuario para Expressao em SQL para    บฑฑ
ฑฑบ          ณ uso na SELECT.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fX3Box( cVar, cConteudo )

 Local nAt    := 0
 Local aOpcao := {}
 Local cRet   := Len( cConteudo )
 Local nLen   := Len( (cConteudo += "=") )
 Local nX
 
 cVar := Alltrim( cVar )
 Do While .T.
    If ( nAt := At(";",cVar) ) > 0
       Aadd(aOpcao,SubStr(cVar,1,nAt-1))
       cVar := SubStr(cVar,nAt+1,Len(cVar)-nAt+1)
    Else
       Aadd(aOpcao,cVar)
       Exit
    EndIf
 EndDo
 
 For nX := 1 To Len( aOpcao )
     If Left(aOpcao[nX],nLen) == cConteudo
        cRet := SubStr(aOpcao[nX],nLen+1,Len(aOpcao[nX])-nLen+1)
        cRet := Alltrim(Upper( cRet ))
        Exit
     EndIf
 Next nX

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fRetAvos บAutor  ณ Adilson Silva      บ Data ณ 30/03/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os Avos Conforme o Periodo Informado.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fRetAvos( dDtDe, dDtAte, cStrAfas, nAvos, nTotAvos )

 Local aAfast     := {}
 Local cTipAfast  := ""
 Local nMes, nAno

 Local cPerIni
 Local cPerFim
 Local dPerIni
 Local dPerFim
 Local cTemp
 Local lProcess
 
 DEFAULT dDtDe    := dDataBase
 DEFAULT dDtAte   := dDataBase
 DEFAULT cStrAfas := "OP"

 // Reinicializa as Variaveis de Retorno
 nAvos    := 0
 nTotAvos := 0

 // Determina a Data de Inicio Conforme a Admissao do Funcionario e Valida as Datas Informadas
 dDtDe := If( dDtDe < SRA->RA_ADMISSA, SRA->RA_ADMISSA, dDtDe )
 If MesAno( dDtDe ) > MesAno( dDtAte )
    Return
 EndIf

 cPerIni := MesAno( dDtDe )
 cPerFim := MesAno( dDtAte )
 dPerIni := Stod( cPerIni + "01" )
 dPerFim := Stod( cPerFim + StrZero(f_UltDia(Stod( cPerFim + "01" )),2) )
 
 // Apura Afastamentos
 fRetAfas( dPerIni, dPerFim, cTipAfast, , , @aAfast, .F. )
 If Len( aAfast ) > 0
    // Define uma Data de Retorno Caso Nao Haja Previsao
    Aeval(aAfast,{|x| x[4]:=If(Empty(x[4]),dDtAte+60,x[4])})
    // Verifica Afastamentos Pagos pela Empresa para Considerar os Avos de Direito no Mes
    // Afastamentos Definidos Pela Variavel cStrAfas
    Aeval(aAfast,{|x| x[3]:=If(x[5]$"OP",x[3]+15,x[3])})
 EndIf

 // Calcula Avos de Direito
 cTemp    := cPerIni
 Do While cTemp <= cPerFim
    lProcess := .T.

    // Verifica Admissao
    If MesAno( SRA->RA_ADMISSA ) > cTemp
       lProcess := .F.
    ElseIf MesAno( SRA->RA_ADMISSA ) == cTemp
       If f_UltDia(Stod( cTemp + "01" )) - Day( SRA->RA_ADMISSA ) + 1 < 15
          lProcess := .F.
       EndIf
    EndIf
      
    // Verifica Demissao
    If lProcess .And. !Empty( SRA->RA_DEMISSA )
       If MesAno( SRA->RA_DEMISSA ) < cTemp
          lProcess := .F.
       ElseIf MesAno( SRA->RA_DEMISSA ) == cTemp
          If Day( SRA->RA_DEMISSA ) < 15
             lProcess := .F.
          EndIf
       EndIf
    EndIf
             
    If lProcess
       If ( nPos := Ascan(aAfast,{|x| cTemp >= MesAno( x[3] ) .And. cTemp <= MesAno( x[4] )}) ) > 0
          If aAfast[nPos,5] $ cStrAfas
             If MesAno( aAfast[nPos,3] ) == cTemp
                If Day( aAfast[nPos,3] ) -1 < 15
                   lProcess := .F.
                EndIf
             ElseIf MesAno( aAfast[nPos,4] ) == cTemp
                If f_UltDia( aAfast[nPos,4] ) - Day( aAfast[nPos,4] ) < 15
                   lProcess := .F.
                EndIf
             Else
                lProcess := .F.
             EndIf
          EndIf
       EndIf
    EndIf
       
    // Incrementa Avos
    nAvos    += If(lProcess,1,0)
    nTotAvos ++
    
    // Cancela o Processamento ao Atingir 12 Avos
    If nTotAvos >= 12
       Exit
    EndIf
      
    // Incrementa Mes e Ano
    nMes := Val(Right(cTemp,2))
    nAno := Val(Left(cTemp,4))
    nMes++
    nAno += If( nMes == 13,1,0 )
    nMes := If( nMes == 13,1,nMes )
    cTemp := StrZero(nAno,4) + StrZero(nMes,2)

 EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fAcNome  บAutor  ณ Adilson Silva      บ Data ณ 05/10/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta o Nome dos Funcionarios para 30 Digitos.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fAcNome( cNome, nTamanho )

Local aAuxiliar  := {}
Local cSvNome    := ""
Local cPrimNome  := ""
Local cUltNome   := ""
Local nPos
Local nX
              
DEFAULT cNome    := ""
DEFAULT nTamanho := 30

cNome   := Upper(Alltrim( cNome ))
cSvNome := cNome

If Len( cNome ) > nTamanho
   If ( nPos := At(" ",cNome) ) > 0
      cPrimNome := SubStr(cNome,1,nPos-1)
      cNome     := SubStr(cNome,nPos+1,Len(cNome)-nPos)
   EndIf
   
   If ( nPos := Rat(" ",cNome) ) > 0
      cUltNome := SubStr(cNome,nPos+1,Len(cNome)-nPos)
      cNome    := SubStr(cNome,1,nPos-1)
   EndIf

   If !Empty( cPrimNome ) .And. !Empty( cUltNome )
      Do While Len(Alltrim( cNome )) > 0
         nPos := At(" ",cNome)
         If nPos == 0
            If Len( cNome ) > 2 .And. !( cNome $ "DAS/DOS" )
               Aadd(aAuxiliar,cNome)
            EndIf
            cNome := ""
         Else
            If Len( SubStr(cNome,1,nPos-1) ) > 2 .And. !( SubStr(cNome,1,nPos-1) $ "DAS/DOS" )
               Aadd(aAuxiliar,SubStr(cNome,1,nPos-1))
            EndIf
            cNome := SubStr(cNome,nPos+1,Len(cNome)-nPos)
         EndIf
      EndDo

      // Redefine o Nome
      cNome := cPrimNome + " "
      Aeval(aAuxiliar,{|x| cNome += x + " "})
      cNome += cUltNome

      // Acerta Abreviaturas do Nome
      If Len(Alltrim(cNome)) > nTamanho
         For nX := 1 To Len( aAuxiliar )
             aAuxiliar[nX] := SubStr(aAuxiliar[nX],1,1)
    
             cNome := cPrimNome + " "
             Aeval(aAuxiliar,{|x| cNome += x + " "})
             cNome += cUltNome

             If Len(Alltrim( cNome )) <= nTamanho
                Exit
             EndIf 
         Next nX
      EndIf
   Else
      cNome := cSvNome
   EndIf
EndIf

Return( cNome )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImportDataบAutor  ณMicrosiga           บ Data ณ  10/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
/*
User Function fDePara( uVar, nTipo, lRet )

 Local aTemp    := {}
 Local cTexto   := ""
 Local nPos     := 0
 Local cArqOpen := ""
 
 Local nX, nAt
 Local cTemp
 Local lCont
 
 DEFAULT nTipo := 999
 DEFAULT uVar  := ""
 DEFAULT lRet  := .T.
 
 uVar := Alltrim( uVar )
 
 If nTipo <> 999 .And. nTipo <= Len( aDePara )
    lCont   := .T.
    If aDePara[nTipo,3]
       cArqOpen := cPath + aDePara[nTipo,1]
       If File( cArqOpen )
          cTexto := MemoRead( cArqOpen )
          aTemp  := StrToArray( cTexto, Chr(13)+Chr(10) )
          For nX := 1 To Len( aTemp )
              // Correcao do De-Para do Uniorg_Cgc
              If "UNIORG_CGC" $ Upper( cArqOpen )
                 If SubStr(aTemp[nX],11,2) == "CC"
                    aTemp[nX] := Stuff(aTemp[nX],11,2,"Z2")
                 EndIf
              EndIf
              // Correcao do De-Para do Uniorg_Depto
              If "UNIORG_DEPTO" $ Upper( cArqOpen )
                 If SubStr(aTemp[nX],12,2) == "CC"
                    aTemp[nX] := Stuff(aTemp[nX],12,2,"Z2")
                 EndIf
              EndIf
              
              If ( nAt := At("=",aTemp[nX]) ) > 0
                 Aadd(aDePara[nTipo,2],{ SubStr(aTemp[nX],1,nAt-1), SubStr(aTemp[nX],nAt+1,Len(aTemp[nX])-nAt) })
              EndIf
          Next nX
          aDePara[nTipo,3] := .F.
       Else
          lCont := .F.          
       EndIf
    EndIf
 
    If lCont 
       If ( nPos := Ascan(aDePara[nTipo,2],{|x| x[1]==uVar}) ) > 0
          uVar := aDePara[nTipo,2][nPos,2]
       Else
          If nTipo == 15 .Or. nTipo == 16
             uVar := ""
          EndIf
          lRet := .F.
       EndIf
    EndIf
 EndIf

Return( uVar )
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTimeToEndบAutor  ณ Adilson Silva      บ Data ณ 23/06/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Projeta Tempo Restante no Processamento.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fTimeToEnd( cTipo, nTotal )

// Declara as Variaveis Publicas
If Type( "__nTempoIni" ) == "U"
   Public __nTempoIni  := Seconds()
   Public __nTempoFim  := Seconds()
   Public __nReg2Proc  := 0
   Public __nTempoProc := 0 
   Public __nContador  := 0
   Public __cTextRet   := ""
EndIf

DEFAULT cTipo  := ""
DEFAULT nTotal := 0

// Verifica se eh Para Reiniciar as Variaveis
If cTipo == "INI"
   __nTempoIni  := Seconds()
   __nReg2Proc  := 0
   __nTempoProc := 0 
   __nContador  := 0
   __cTextRet   := ""
Else
   // Incrementa o Contador
   __nContador++
   
   __nTempoFim  := Seconds()
   __nReg2Proc  := (nTotal - __nContador)
   __nTempoProc := __nTempoFim - __nTempoIni
   __nTempoProc := __nTempoProc * __nReg2Proc
   If ( ( __nReg2Proc % 150 ) == 0 .And. __nTempoProc > 0 ) .Or. __nContador == nTotal
      __cTextRet   := "Final em " + SecsToTime( __nTempoProc )
   EndIf
   __nTempoIni  := Seconds()
EndIf   

Return( __cTextRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTimeToEndบAutor  ณ Adilson Silva      บ Data ณ 23/06/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Projeta Tempo Restante no Processamento.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fDelSx1( __cPerg, __cOrdem )

 Local aOldAtu := GETAREA()
 Local aOldSx1 := SX1->( GETAREA() )

 __cPerg := PadR( __cPerg,Len( SX1->X1_GRUPO ) )

 dbSelectArea( "SX1" )
 dbSetOrder( 1 )
 dbSeek( __cPerg + __cOrdem )
 Do While !Eof() .And. SX1->X1_GRUPO == __cPerg
    RecLock("SX1",.F.)
     dbDelete()
    MsUnlock()
    
    dbSkip()
 EndDo

 RESTAREA( aOldSx1 )
 RESTAREA( aOldAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGrvSrc  บAutor  ณ Adilson Silva      บ Data ณ 22/11/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava Lancamentos no SRC.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fGrvSrc( cVarFil, cVarMat, cVarPd, nVarValor, nVarHora, cVarCC, cVarSem )

 Local aOldAtu := GETAREA()
 Local aOldSrc := SRC->(GETAREA())

 DEFAULT cVarFil   := "@@@"
 DEFAULT cVarMat   := "@@@"
 DEFAULT cVarPd    := "@@@"
 DEFAULT nVarValor := 0
 DEFAULT nVarHora  := 0
 DEFAULT cVarCC    := SRA->RA_CC
 DEFAULT cVarSem   := Space( 02 )

 SRV->(dbSetOrder( 1 ))
 SRV->(dbSeek( xFilial( "SRV" ) + cVarPd ))

 dbSelectArea( "SRC" )
 dbSetOrder( 1 )	// RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ

 If !dbSeek( cVarFil + cVarMat + cVarPd + cVarCc + cVarSem )
    RecLock("SRC",.T.)
    SRC->RC_FILIAL := cVarFil
    SRC->RC_MAT    := cVarMat
    SRC->RC_PD     := cVarPd
    SRC->RC_CC     := cVarCc
    SRC->RC_SEMANA := cVarSem
 Else
    RecLock("SRC",.F.)
 EndIf
  SRC->RC_TIPO1 := SRV->RV_TIPO
  SRC->RC_HORAS := nVarHora
  SRC->RC_VALOR := nVarValor
  SRC->RC_TIPO2 := "C"
 MsUnlock() 
 
 RESTAREA( aOldSrc )
 RESTAREA( aOldAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ PrintJust  ณ Autor ณ Marcelo Iuspa       ณ Data ณ 01/12/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Imprime string alinhada a direita ou no centro             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณCliente   ณ PRIMOR / Atibaia Alimentos                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProjeto   ณ PCP024                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PrintJust(oPrint, oFont, cTexto, nLinha, nColIni, nColFim, nTipo, nCor)

Local nLoop
Local aFontWidth := {}
Local nSizeLabel := 0
Local nColuna    := Nil

Default nColIni  := 0
Default nTipo    := 0
Default nCor     := 0

oPrint:GetFontWidths( oFont, aFontWidth)

For nLoop := 1 to Len(cTexto)
    nSizeLabel += aFontWidth[Asc(Substr(cTexto, nLoop, 1))]
Next    

If nTipo == 0
   nColuna := nColIni + ((nColFim - nColIni) / 2) - (nSizeLabel / 2)
ElseIf nTipo == 1       
   nColuna := nColFim - nSizeLabel
Else
   nColuna := nColIni
Endif   

PosPrint(oPrint, nLinha, nColuna, cTexto, oFont, nCor)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ  PosPrint  ณ Autor ณ Marcelo Iuspa       ณ Data ณ 11/11/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Fun็ใo encapsulada para metodo Say da classe TmsPrinter    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณCliente   ณ PRIMOR / Atibaia Alimentos                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Tratamento para margem esquerda e superior no uso dos      ณฑฑ
ฑฑณ          ณ m้todos Say, Line e Box da classe TmsPrinter               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PosPrint(oPrint, nLinha, nColuna, cTexto, oFont, nCor, lBox, lMargin, lColunaFinal)
Local nMargemEsquerda  :=  10
Local nMargemSuperior  :=   0
Local nRowMultiplic    :=   1
Local nColMultiplic    :=   1

// Local oFontDef         := TFont():New("Arial"      , 9,  8,.T.,.F.,5,.T.,5,.T.,.F.)

Default lBox         := .F.
Default lMargin      := .T.
Default lColunaFinal := .F.

If !lMargin
   nMargemEsquerda  :=   0
   nMargemSuperior  :=   0
   nRowMultiplic    :=   1
   nColMultiplic    :=   1
Endif

If ValType(cTexto) + ValType(oFont) == "NN"
   If lBox
      oPrint:Box((nLinha + nMargemSuperior) * nRowMultiplic, (nColuna + nMargemEsquerda) * nColMultiplic , ;
                 (cTexto + nMargemSuperior) * nRowMultiplic, (oFont   + nMargemEsquerda) * nColMultiplic)
   Else
      oPrint:Line((nLinha + nMargemSuperior) * nRowMultiplic, (nColuna + nMargemEsquerda) * nColMultiplic, (cTexto + nMargemSuperior) * nRowMultiplic, (oFont + nMargemEsquerda) * nColMultiplic)     
      //oPrint:Say((nLinha + nMargemSuperior) * nRowMultiplic, (nColuna + nMargemEsquerda) * nColMultiplic, AllTrim(Str(nLinha)) + " / " + Alltrim(Str(nColuna)), oFontDef)
   Endif
Else
   If nColuna < 0  // Em relacao ao Centro
      nColuna := (nPageWidth / 2) + nColuna
   Endif

   If lColunaFinal
      PrintJust(oPrint, oFont, cTexto, nLinha, 0, nColuna, 1, nCor)
   Else            
      oPrint:Say((nLinha + nMargemSuperior) * nRowMultiplic, (nColuna + nMargemEsquerda) * nColMultiplic, cTexto, oFont,, nCor)
   Endif
Endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSepTexto บAutor  ณ Adilson Silva      บ Data ณ 24/11/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fracionar Textos em Varias Linhas.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fSepTexto( cTexto, nLimite, aDetalhe )

 Local cDetalhe := ""
 Local aRet     := {}
 Local aTemp    := StrToArray( cTexto, Chr(13)+Chr(10) )
 Local nAt, nX
 
 aDetalhe := {}
 For nX := 1 To Len( aTemp )
     cTexto := aTemp[nX]
     Do While Len( cTexto ) > 0
        If ( nAt := At(" ",cTexto) ) > 0
           cDetalhe += SubStr(cTexto,1,nAt-1) + " "
           cTexto := SubStr(cTexto,nAt+1,Len(cTexto)-nAt)
        Else
           If Len( cTexto ) > nLimite
              cDetalhe += Left( cTexto, nLimite )
              cTexto := SubStr( cTexto, nLimite+1, Len(cTexto)-nLimite )
           Else
              cDetalhe += cTexto
              cTexto := ""
           EndIf
        EndIf
         
        If Len( cDetalhe ) >= nLimite .Or. Len(  cTexto ) == 0
           Aadd(aDetalhe,cDetalhe)
           cDetalhe := ""
        EndIf
     EndDo
 Next nX
 
 aRet := Aclone( aDetalhe )

Return( aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTLGPER10  บAutor  ณMicrosiga           บ Data ณ  11/30/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function _fExistTab( cTabela )

 Local aOldSx2 := SX2->(GETAREA())
 Local lRet    := .F.

 If SX2->(dbSeek( cTabela ))
    lRet := .T.
 EndIf

 RESTAREA( aOldSx2 )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAsrGETMV บAutor  ณ Adilson Silva      บ Data ณ 27/12/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca os Parametros do SX6                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fAsrGETMV( cParam, c_Fil )

 Local aOldAtu := GETAREA()
 Local aOldSx6 := SX6->(GETAREA())
 Local cCmpFil := PadR(FWCompany() + FWUnitBusiness(),FWSizeFilial())
 Local lFound  := .F.
 Local uRet    := ""
 
 SX6->(dbSetOrder( 1 ))
 If SX6->(dbSeek( c_Fil + cParam ))
    lFound  := .T.
 ElseIf SX6->(dbSeek( cCmpFil + cParam ))
    lFound  := .T.
 ElseIf SX6->(dbSeek( Space(FWSizeFilial()) + cParam ))
    lFound  := .T.
 EndIf

 If lFound
    If SX6->X6_TIPO == "N"
       uRet := Val(Alltrim(SX6->X6_CONTEUD))
    ElseIf SX6->X6_TIPO == "D"
       uRet := Ctod(Alltrim(SX6->X6_CONTEUD))
    ElseIf SX6->X6_TIPO == "L"
       uRet := ".F."
       If "T" $ SX6->X6_CONTEUD
          uRet := ".T."
       EndIf
    ElseIf SX6->X6_TIPO == "A"
       uRet := &( SX6->X6_CONTEUD )
    Else
       uRet := Alltrim(SX6->X6_CONTEUD)
    EndIf
 EndIf
 
 RESTAREA( aOldSx6 )
 RESTAREA( aOldAtu )

Return( uRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLocEntregaบAutor  ณ Adilson Silva     บ Data ณ 24/05/2012  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Compoe os Campos que Determinam os Locais de Entrega dos   บฑฑ
ฑฑบ          ณ Beneficios.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fLocEntrega( cEntrSra, cEntrCtt, cTipoPed )

 Local aVtLocEnt := U_fAsrGETMV( "GP_VTLOCEN", "" )		//GETMV( "GP_VTLOCEN",,'{"RA_LOCENT","CTT_LOCENT"}' )
 Local aVrLocEnt := U_fAsrGETMV( "GP_VRLOCEN", "" )		//GETMV( "GP_VRLOCEN",,'{"RA_LOCENT","CTT_LOCENT"}' )
 Local aVaLocEnt := U_fAsrGETMV( "GP_VALOCEN", "" )		//GETMV( "GP_VALOCEN",,'{"RA_LOCENT","CTT_LOCENT"}' )
 Local aLocEntr  := {}
 Local lRet      := .T.
 Local nPos

 cEntrSra := "@@"
 cEntrCtt := "@@"
 
 If ValType( aVtLocEnt ) <> "A"
    aVtLocEnt := &( aVtLocEnt )
 EndIf
 If ValType( aVrLocEnt ) <> "A"
    aVrLocEnt := &( aVrLocEnt )
 EndIf
 If ValType( aVaLocEnt ) <> "A"
    aVaLocEnt := &( aVaLocEnt )
 EndIf
 
 // Determina o Beneficio
 If cTipoPed == "VT" .And. !Empty( aVtLocEnt )
    aLocEntr := Aclone( aVtLocEnt )		// &aVtLocEnt
 ElseIf cTipoPed == "VR" .And. !Empty( aVrLocEnt )
    aLocEntr := Aclone( aVrLocEnt )		// &aVrLocEnt
 ElseIf cTipoPed == "VA" .And. !Empty( aVaLocEnt )
    aLocEntr := Aclone( aVaLocEnt )		// &aVaLocEnt
 EndIf

 // Determina o Nome dos Campos dos Locais de Entrega
 If ( nPos := Ascan(aLocEntr,{|x| "RA_"$x}) ) > 0
    cEntrSra := aLocEntr[nPos]
 EndIf
 If ( nPos := Ascan(aLocEntr,{|x| "CTT_"$x}) ) > 0
    cEntrCtt := aLocEntr[nPos]
 EndIf

 // Valida o Campo do Cadastro de Funcionarios
 If lRet .And. ( cEntrSra == "@@" .Or. !U_fExistSx3( cEntrSra ) )
    lRet := .F.
 EndIf
 // Valida o Campo do Cadastro de Centros de Custo
 If lRet .And. ( cEntrCtt == "@@" .Or. !U_fExistSx3( cEntrCtt ) )
    lRet := .F.
 EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fExistSx3  บAutor  ณ Adilson Silva    บ Data ณ 24/05/2012  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar a Existencia de Campos nas Tabelas a Partir do SX3 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fExistSx3( cVar )

 Local aOldAtu := GETAREA()
 Local aOldSx3 := SX3->(GETAREA())
 Local lRet    := .T.

 DEFAULT cVar := ""
 
 dbSelectArea( "SX3" )
 dbSetOrder( 2 )
 
 If Empty( cVar ) .Or. !dbSeek( cVar )
    lRet := .F.
 EndIf
 
 RESTAREA( aOldSx3 )
 RESTAREA( aOldAtu )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDPISA2  บAutor  ณMicrosiga           บ Data ณ  03/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GPETcLk( nCon, lRotAuto, cBanco, cServer, cPorta )

DEFAULT lRotAuto := .F.
DEFAULT cBanco   := ""
DEFAULT cServer  := ""
DEFAULT cPorta   := ""

If ValType(nCon) == 'U'
   nCon := TCLink(cBanco,cServer,Val(cPorta))
   If (nCon < 0) .And. !lRotAuto //--So mostra a tela se nao for chamada automaticamente
      MsgAlert('Falha Conexao TOPCONN 1 - Erro: '+Str(nCon,10,0)) //
   EndIf
Else
   If !Empty(cTMSTCLK) .And. (nCon > 0)
      TCUnLink(nCon)
   EndIf
EndIf

Return( nCon )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fTabelas บAutor  ณ Adilson Silva      บ Data ณ 28/11/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carga de Array com as Tabelas Multi Empresas.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fTabelas( aEmpresas, aLista )

 Local aOldAtu := GETAREA()

 Local cArqSx2, cIndSx2
 Local nX, nY
 
 For nX := 1 To Len( aEmpresas )
     If aEmpresas[nX,1] == cEmpAnt
        For nY := 1 To Len( aLista )
            Aadd(aEmpresas[nX,2],RetSqlName(aLista[nY]))
        Next nY
     Else
        cArqSx2 := "SX2" + aEmpresas[nX,1] + "0"
        cIndSx2 := cArqSx2
         
        // Pesquisa o Nome das Tabelas das Outras Empresas
        SX2->(DbCloseArea())
        dbUseArea( .T.,, cArqSx2, "SX2", If(.F. .OR. .T., !.F., NIL), .F. )
        If RetIndExt()!=".CDX"
           SX2->(dbSetIndex( cIndSx2 ))
        Else
           SX2->(DbSetOrder(1))
        EndIf
        For nY := 1 To Len( aLista )
            SX2->(dbSeek( aLista[nY] ))
            If MsFile( Alltrim(SX2->X2_ARQUIVO) )
               Aadd(aEmpresas[nX,2],Alltrim(SX2->X2_ARQUIVO))
            EndIf
        Next nY
        SX2->(DbCloseArea())
        dbSelectArea( "SX2" )
     EndIf
 Next nX
 
 RESTAREA( aOldAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGetPath บAutor  ณMicrosiga           บ Data ณ 01/12/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fUPath()

 Local aOldAtu := GETAREA()
 Local aDados  := {}
 Local aEstrut := {}
 Local nX
 
 aEstrut :=  { "XB_ALIAS" , "XB_TIPO" , "XB_SEQ" , "XB_COLUNA" , "XB_DESCRI"           , "XB_DESCSPA"          , "XB_DESCENG"          , "XB_CONTEM"    }
 Aadd(aDados,{ "U_PATH"   , "1"       , "01"     , "RE"        , "Selecione o arquivo" , "Selecione o arquivo" , "Selecione o arquivo" , "SX5"          })
 Aadd(aDados,{ "U_PATH"   , "2"       , "01"     , "01"        , "                   " , "                   " , "                   " , "U_fGetPath()" })
 Aadd(aDados,{ "U_PATH"   , "5"       , "01"     , "  "        , "                   " , "                   " , "                   " , "U_fGetArq()"  })
 
 dbSelectArea( "SXB" )
 If !dbSeek( aDados[1,1] + aDados[1,2] + aDados[1,3] + aDados[1,4] )
    For nX := 1 To Len( aDados )
        RecLock("SXB",.T.)
         SXB->XB_ALIAS   := aDados[nX,1]
         SXB->XB_TIPO    := aDados[nX,2]
         SXB->XB_SEQ     := aDados[nX,3]
         SXB->XB_COLUNA  := aDados[nX,4]
         SXB->XB_DESCRI  := aDados[nX,5]
         SXB->XB_DESCSPA := aDados[nX,6]
         SXB->XB_DESCENG := aDados[nX,7]
         SXB->XB_CONTEM  := aDados[nX,8]
        MsUnLock()
    Next nX
 EndIf
 
 RESTAREA( aOldAtu )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGetPath บAutor  ณMicrosiga           บ Data ณ 01/12/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fGetPath()

 Local cType := "*.*"
 
 If Type( "c_PathRet" ) == "U"
    Public c_PathRet := ""
 EndIf

 c_PathRet := cGetFile( cType, "Sele็ใo de Pasta", 0, ,.T., GETF_RETDIRECTORY+GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE )
 
Return( !Empty( c_PathRet ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGetArq  บAutor  ณMicrosiga           บ Data ณ 01/12/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fGetArq()
Return( c_PathRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAsrTabRccบAutor  ณ Adilson Silva      บ Data ณ 29/01/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carga das Tabelas do RCC Filtrando a Filial de Referencia. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fAsrTabRcc( aTab, cTab, dDtRef, cFilRef )

 Local nX      := 0
 Local aTmpTab := {}
 
 DEFAULT cTab    := ""
 DEFAULT dDtRef  := dDataBase
 DEFAULT cFilRef := xFilial()
 
 aTab := {}

 // Carrega a Tabela Selecionada
 fCarrTab( aTmpTab, cTab, dDtRef )
 If Len( aTmpTab ) > 0
    Aeval(aTmpTab,{|x| If(x[2]==cFilRef,Aadd(aTab,x),Nil)})
    If Len( aTab ) == 0
       cFilRef := Space( FWSizeFilial() )
       Aeval(aTmpTab,{|x| If(x[2]==cFilRef,Aadd(aTab,x),Nil)})
    EndIf
 EndIf

Return( aTab )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IncMeter บAutor  ณMicrosiga           บ Data ณ 15/02/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Incrementa Objeto oMeter                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IncMeter( oMeter, oText, nCount, cText )
 
 DEFAULT cText := ""
 
 If !Empty( cText )
    oText:SetText( cText )
 EndIf
 Eval( {|| oMeter:Set(nCount), SysRefresh() } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณfRetPerPontoบAutor  ณ Adilson Silva    บ Data ณ  20/06/2013  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Periodo de Apontamento Conforme Data de Referenciaบฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fRetPerPonto( dDtRef, dIni, dFim )
 
 Local cPonMes := GETMV( "MV_PAPONTA" )
 Local cMesAtu := MesAno( dDtRef )
 Local cMesAnt := MesAno( U_fSubMes(dDtRef) )
 Local nDiaDe  := 0
 Local nDiaAte := 0
 Local lMesAnt := .T.
 
 If Len( cPonMes ) == 16 .Or. Len( cPonMes ) == 17
    nDiaDe  := Val(SubStr(cPonMes,7,2))
    nDiaAte := Val(Right(cPonMes,2))
 Else
    nDiaDe  := Val(Left(cPonMes,2))
    nDiaAte := Val(Right(cPonMes,2))
 EndIf
                                                          `
 If nDiaDe == 1
    nDiaAte := f_UltDia( dDtRef )
    cMesAnt := cMesAtu
    lMesAnt := .F.
 EndIf
 
 dIni := Stod( cMesAnt + StrZero(nDiaDe,2) )
 dFim := Stod( cMesAtu + StrZero(nDiaAte,2) )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fMakeXls บAutor  ณ Adilson Silva      บ Data ณ 18/07/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao de Planilha para Integracao com Excel no Formato   บฑฑ
ฑฑบ          ณ CSV.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fMakeXls( aXlsCabec, aXlsDetail )

 Local cPath    := AllTrim( GetTempPath() )
 Local cNomeArq := CriaTrab(,.F.) + ".csv"
 Local cEol     := Chr(13)+Chr(10)
 Local cSep     := ";"
 Local nX, nY
 Local cLin, cTemp
 Local nHdl

 If !ApOleClient( 'MsExcel' )
    MsgAlert( 'MsExcel nao instalado' )
    Return
 EndIf
 
 cPath    := cPath + If(Right(cPath,1) <> "\","\","")
 cNomeArq := cPath + cNomeArq
 nHdl     := fCreate( cNomeArq )
 If nHdl == -1
    Aviso("ATENCAO","Nใo foi possํvel criar o arquivo temporแrio para integrar com o Excel",{"Sair"})
    Return
 EndIf
 
 // Monta o Cabecalho
 cLin := ""
 For nX := 1 To Len( aXlsCabec )
     cLin += aXlsCabec[nX] + cSep
 Next nX
 cLin += cEol
 fWrite(nHdl,cLin,Len(cLin))

 // Monta os Itens
 For nX := 1 To Len( aXlsDetail )
     cLin := ""
     For nY := 1 To Len( aXlsDetail[nX] )
         cTemp := ""
         If ValType( aXlsDetail[nX,nY] ) == "D"
            cTemp := Dtoc( aXlsDetail[nX,nY] )
         ElseIf ValType( aXlsDetail[nX,nY] ) == "N"
            cTemp := Transform( aXlsDetail[nX,nY],'@E 999,999,999.99' )
         ElseIf ValType( aXlsDetail[nX,nY] ) == "C"
            If U_fNumeros( Alltrim(aXlsDetail[nX,nY]) )
               cTemp := '="' + Alltrim(aXlsDetail[nX,nY]) + '"'
            Else
               cTemp := Alltrim(aXlsDetail[nX,nY])
            EndIf
         EndIf
         cLin += cTemp + cSep
     Next nY
     cLin += cEol
     fWrite(nHdl,cLin,Len(cLin))
 Next nX
 fClose( nHdl )
  
 // Abre o Excel com o Arquivo Gerado
 oExcelApp := MsExcel():New()
 oExcelApp:WorkBooks:Open( cNomeArq ) // Abre uma planilha
 oExcelApp:SetVisible(.T.)
 oExcelApp:Destroy()

Return

User Function fNumeros( cTexto )

 Local lRet := .T.
 Local nX
 
 For nX := 1 To Len( cTexto )
     If Asc(SubStr(cTexto,nX,1)) < 48 .Or. Asc(SubStr(cTexto,nX,1)) > 57
        lRet := .F.
        Exit
     EndIf
 Next nX

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTamCusto บAutor  ณ Adilson Silva      บ Data ณ 06/03/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Tamanho do Campo Centro de Custo.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fTamCusto()

 Local aOldAtu := GETAREA()
 Local aOldSx3 := SX3->(GETAREA())
 Local nRet    := 9
 
 SX3->(dbSetOrder( 2 ))
 If SX3->(dbSeek( "RA_CC" ))
    nRet := SX3->X3_TAMANHO
 EndIf
 
 RESTAREA( aOldSx3 )
 RESTAREA( aOldAtu )

Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMontaSal บAutor  ณMicrosiga           บ Data ณ  03/24/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Array com o Historico Salarial do Funcionario.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fMontaSal( c_Fil, c_Mat, cPeriodo, aSalarios, lMesAtu )

 Local aOldAtu := GETAREA()
 Local nRet    := 0
 Local nPos, nX
 
 DEFAULT aSalarios := {}
 aSalarios := {}
 
 dbSelectArea( "SR3" )
 dbSetOrder( 1 )
 dbSeek( c_Fil + c_Mat )
 Do While !Eof() .And. SR3->(R3_FILIAL + R3_MAT) == c_Fil + c_Mat
    Aadd(aSalarios,{MesAno(SR3->R3_DATA), SR3->R3_VALOR})
    
    dbSkip()
 EndDo
 
 If lMesAtu
    For nX := 1 To Len( aSalarios )
        If cPeriodo >= aSalarios[nX,1]
           nRet := aSalarios[nX,2]
           Exit
        EndIf
    Next nX
 EndIf
 
 RESTAREA( aOldAtu )

Return( nRet )


#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Rcoma09  ºAutor  ³ Sergio Oliveira    º Data ³  Mar/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa responsavel por cadastrar a amarracao de Condicao º±±
±±º          ³ de Pagamentos x TES.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU.                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Rcoma09()

If !AliasInDic("ZA5",.t.)
	Return
EndIf
If Select('ZA5') == 0
	ChkFile('ZA5')
EndIf

cCadastro := 'Manutencao de Condição de Pagamento x TES'
aRotina := {  { "Pesquisar" ,"AxPesqui" , 0 , 1 } , ;
{ "Visualizar","U_Rcoma09a(2,cCadastro)", 0 , 2 } , ;
{ "Incluir"   ,"U_Rcoma09a(3,cCadastro)", 0 , 3 } , ;
{ "Altera"    ,"U_Rcoma09a(4,cCadastro)", 0 , 4 } , ;
{ "Excluir"   ,"U_Rcoma09a(5,cCadastro)", 0 , 5 } }

ZA5->( DbSetOrder(1) )

mBrowse(,,,,"ZA5")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Rcoma09a ºAutor  ³Sergio Oliveira     º Data ³ Mar/2009    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento do Programa.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcoma09.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Rcoma09a(nOpcx, cCadastro)

Local aArea   := GetArea()
Local cCampos := 'ZA5_CODIGO/ZA5_DESCRI'
Private cCodigo := IIF( Inclui, CriaVar('ZA5_CODIGO') , ZA5->ZA5_CODIGO )
Private cDescri := IIF( Inclui, CriaVar('ZA5_DESCRI') , ZA5->ZA5_DESCRI )
Private xOpcx   := nOpcx

cTitulo := cCadastro

SX3->( DbSetOrder(1), DbSeek('ZA5') )

aHeader := {}
aGets   := {}
nUsado  := 0

While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == "ZA5"
	
	If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And.!Trim(SX3->X3_CAMPO)$cCampos
		nUsado := nUsado + 1
		Aadd( aGets, AllTrim(SX3->X3_CAMPO) )
		AADD(aHeader,{TRIM(SX3->X3_TITULO),SX3->X3_CAMPO,;
		SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
	Endif
	
	SX3->( DbSkip() )
	
EndDo

aCols := {}

If !Inclui
	
	ZA5->( DbSetOrder(1), DbSeek(xFilial('ZA5')+cCodigo) )
	
	While !ZA5->( Eof() ) .And. ZA5->( ZA5_FILIAL+ZA5_CODIGO ) == xFilial('ZA5')+cCodigo
		
		Aadd(aCols, Array(nUsado+1))
		For nQ :=1 To nUsado
			aCols[Len(aCols),nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
		Next
		aCols[Len(aCols),nUsado + 1] := .F.
		ZA5->( DbSkip() )
		
	EndDo
	
EndIf

If Len(aCols) == 0
	AADD(aCols,Array(nUsado+1))
	For nQ := 1 To nUsado
		aCols[Len(aCols),nQ] := CriaVar(aHeader[nQ][2])
	Next
	aCols[Len(aCols),nUsado+1] := .F.
EndIf

aColsDel := aClone( aCols )
aGets    := Array(0)
cLinhaOk := ".t."
cTudoOk  := ".t."
aR       := {}
aC       := {}
aCGD:={45,05,160,360}
aTELA:={125,0,450,730}

//+--------------------------------------------------------------+
//¦ Chamada da Modelo2                                           ¦
//+--------------------------------------------------------------+
                                                            
AADD(aC,{"cCodigo"  ,{16,10} , "Codigo"    ,"@!","U_Rcoma09d()",Nil,IIF(Inclui, .t., .f.)})
AADD(aC,{"cDescri"  ,{16,75} , "Descrição" ,"@!",".t.",Nil,IIF(Inclui, .t., .f.)})

If Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,999,aTELA)
	Rcoma09b(nOpcx)
EndIf

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ Rcoma09b ºAutor  ³Sergio Oliveira     º Data ³ Abr/2008    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua as Atualizacoes.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcoma09.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Rcoma09b(nOpcx)

Local cBusca, xp, xk, cExec

ZA5->( DbSetOrder(1) )

If nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx == 5
	
	cExec := " UPDATE "+RetSqlName("ZA5")+" SET D_E_L_E_T_ = '*' "
	cExec += " WHERE ZA5_FILIAL = '"+xFilial('ZA5')+"' "
	cExec += " AND   ZA5_CODIGO = '"+cCodigo+"' "
	cExec += " AND   D_E_L_E_T_ = ' ' "
	
	TcSqlExec( cExec )
	
	If nOpcx <> 5
		For xp := 1 To Len(aCols)
			If !aCols[xp][Len(aHeader)+1]
				RecLock("ZA5",.t.)
				For xk := 1 To Len(aHeader)
					Field->&(aHeader[xk][2]) := aCols[xp][xk]
				Next
				ZA5->ZA5_CODIGO := cCodigo
				ZA5->ZA5_DESCRI := cDescri
				MsUnlock()
			Endif
		Next
	EndIf
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ Rcoma09d ºAutor  ³Sergio Oliveira     º Data ³ Mar/2009    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se o codigo de processo ja existe.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcoma09.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Rcoma09d()

Local lRet := .t.

If xOpcx == 3
	If ZA5->( DbSetOrder(1), DbSeek( xFilial('ZA5')+cCodigo ) )
		Aviso("JA EXISTE","O codigo de processo ja existe!",;
		{"&Fechar"},3,"Informação já Existente",,;
		"PCOLOCK")	    
		lRet := .f.
	EndIf
EndIf

Return( lRet )
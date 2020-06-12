#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCFGA01
Rotina de Carga de Dados
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CCFGA01()
Local Titulo      := 'INTERFACE DE CARGA DE DADOS'
Local _cVar       := ""
Private _cMsgLOG  := ""
Private aRegErr   := {}
Private cArq      := ""
Private _nHandTXT := 0

IF Len(_aRot := CCFG01ROT()) == 0
	Return()
ENDIF

IF !MsgYesNo("Confirma processamento ?")
	MsgStop("Processo abortado!")
	Return nil
ENDIF

SZD->(dbSetOrder(1))
SZD->(dbSeek(XFilial("SZD")+_aRot[1]))

Processa( { || CCFG01ATU(cArq) }, Titulo , 'Atualizando...', .F. )

If Len( aRegErr ) > 0
	CCFG01IMP(aRegErr,SZD->ZD_TABCAB)
Else
	ApMsgInfo( 'Processo terminado.', 'ATENวรO' )
EndIf

Return()     
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCFG01ATU บAutor  ณ Totvs	  	       บ Data ณ30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Carga de Dados			                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ADELCO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/     
Static Function CCFG01ATU(cArq)
Local _cArea   := GetArea()
Local cBuffer  := ''
Local nHandle  := -1
Local nBtLidos := 0
Local nCt      := 0
Local nCnt     := 0
Local _aDados  := {}
Local nVlr3    := 0

FT_FUSE(cArq)
nCnt := FT_FLASTREC()
FT_FGOTOP()

IF Len(_aCampos := CCFG01CPO(SZD->ZD_TABCAB,SZD->ZD_TABDET,SZD->ZD_EXECAUT=="1")) == 0
	RestArea(_cArea)
	Return()
ELSE
	
	CCFG01TXT(.t.)
	
	_cIndice := Alltrim(SZD->ZD_CHAVE)
	_aChave  := {}
	
	_nPos  := At("+",_cIndice)
	While !Empty(_cIndice) .And. _nPos > 0
		IF aScan(_aCampos, {|x| x[1] == Alltrim(Subs(_cIndice,1,_nPos-1))} ) == 0
			Aviso("ID Obrigat๓rio","O campo "+Alltrim(Subs(_cIndice,1,_nPos-1))+" deve ser enviado no arquivo. Verifique!",{"Sair"},2)
			FT_FUSE()
			RestArea(_cArea)
			Return()
		ENDIF
		Aadd(_aChave,Alltrim(Subs(_cIndice,1,_nPos-1)))
		_cIndice := Subs(_cIndice,_nPos+1,Len(_cIndice)-_nPos)
		_nPos  := At("+",_cIndice)
		If _nPos=0 .And. !Empty(_cIndice)
			_nPos := Len(_cIndice)+1
		Endif
		//Skip()
	Enddo
	
	IF !Empty(_cIndice)
		IF aScan(_aCampos,{|x| x[1] == Alltrim(_cIndice)}) == 0
			Aviso("ID Obrigat๓rio","O campo "+Alltrim(_cIndice)+" deve ser enviado no arquivo. Verifique!",{"Sair"},2)
			FT_FUSE()
			RestArea(_cArea)
			Return()
		ENDIF
		Aadd(_aChave,Alltrim(_cIndice))
	ENDIF
	
	ProcRegua(nCnt)
	While !FT_FEof()
		
		_cLine := FT_FREADLN()
		
		IncProc("Carregando arquivo. Aguarde...")
		
		aadd(_aDados,Array(Len(_aCampos)))
		_nCol := 1
		_nPos := At(";",_cLine)
		While !Empty(_cLine) .And. _nPos > 0
			_aDados[Len(_aDados),aScan(_aCampos, {|x| x[3] == _nCol } )] := Subs(_cLine,1,_nPos-1)
			_cLine := Subs(_cLine,_nPos+1,Len(_cLine)-_nPos)
			_nCol++
			_nPos:=At(";",_cLine)
			If _nPos = 0 .And. !Empty(_cLine)
				_nPos:=Len(_cLine)+1
			Endif
		Enddo
		IF !Empty(_cLine) .or. _nCol <= Len(_aCampos)
			_aDados[Len(_aDados),aScan(_aCampos, {|x| x[3] == _nCol } )] := Alltrim(_cLine)
		ENDIF
		nCt++
		FT_FSKIP()
	Enddo
	FT_FUSE()
	
	// reinicia regua
	ProcRegua(nCnt)
	
	_cCampo  := ""
	_cCodAnt := ""
	_cCodAtu := ""
	aLinha   := {}
	aCab     := {}
	aItens   := {}
	
	For x := 1 to Len(_aDados)
		IncProc("Gerando informa็๕es. Aguarde...")
		
		IF !Empty(SZD->ZD_TABDET)
			_cCodAtu := ""
			For _xx := 1 to Len(_aChave)
				_cCodAtu += _aDados[x,aScan(_aCampos, {|x| x[1] == _aChave[_xx] } )]
			Next
			
			IF _cCodAnt <> "" .and. _cCodAnt <> _cCodAtu
				IF !CCFG01INC(aCab,aItens,x-1)
					Return()
				ENDIF
				aCab   := {}
				aItens := {}
			ENDIF
		ELSE
			aCab   := {}
			aItens := {}
		ENDIF
		
		For y := 1 to Len(_aCampos)
			SX3->(dbSetOrder(2))
			SX3->(dbGoTop())
			SX3->(dbSeek(_aCampos[y,1]))
			IF SX3->X3_TIPO$("M")
			  _cCampo := _aDados[x,y]    
			ELSEIF SX3->X3_TIPO$("C")
				//				_cCampo := _aDados[x,y]
				_cCampo := PADR(_aDados[x,y],TamSx3(_aCampos[y,1])[1],' ')    // PADR incluido por Ana
			ELSEIF SX3->X3_TIPO == "N"
				IF Type(_aDados[x,y]) <> "N"
					Aviso("Tipo Invแlido","O campo "+Alltrim(SX3->X3_CAMPO)+" da linha "+Alltrim(Str(x))+" estแ com tipo incorreto."+Chr(13)+Chr(10)+"O processo serแ abortado",{"Sair"},2)
					RestArea(_cArea)
					Return()
				ENDIF
				_cCampo := Val(_aDados[x,y])
			ELSEIF SX3->X3_TIPO == "D"
				_cCampo := Stod(_aDados[x,y])
			ENDIF
			IF SX3->X3_CONTEXT == "V" .AND. SX3->X3_TIPO <> "M"
				Loop
			ENDIF
			
			IF !Empty(SZD->ZD_TABDET)
				IF SZD->ZD_TABCAB == SX3->X3_ARQUIVO
					IF Ascan(aCab,{|x| Alltrim(x[1]) == Alltrim(_aCampos[y,1]) }) == 0 // .and. _aCampos[y,1]$SZD->ZD_CHAVE
						aadd( aCab, {_aCampos[y,1],_cCampo, NIL} )
					ENDIF
					IF SZD->(ZD_TABCAB==ZD_TABDET) .and. !_aCampos[y,1]$SZD->ZD_CHAVE
						aadd( aLinha, {_aCampos[y,1],_cCampo, NIL} )
					ENDIF
				ELSE
					aadd( aLinha, {_aCampos[y,1],_cCampo, NIL} )
				ENDIF
			ELSE
				IF TRIM(_aCampos[y,1]) == "CNB_PRODUT"
					aadd( aCab, {_aCampos[y,1],_cCampo, NIL} )
					aadd( aCab, {"CNB_DESCRI", POSICIONE("SB1",1,XFILIAL("SB1")+ TRIM(_cCampo),"B1_DESC") , NIL} )
					aadd( aCab, {"CNB_UM", POSICIONE("SB1",1,XFILIAL("SB1")+ TRIM(_cCampo),"B1_UM") , NIL} )
				ELSE
					aadd( aCab, {_aCampos[y,1],_cCampo, NIL} )
				ENDIF	
			ENDIF
			If Alltrim(_aCampos[y,1]) == "N3_VORIG1"
				nVlr3 := _cCampo
			Endif
		Next
		
		//Campo obrigat๓rio nใo constava no layout, por este motivo feito tratamento para inserir no cabe็alho.
		IF Ascan(aCab,{|x| Alltrim(x[1]) == Alltrim("N3_VORIG3")}) == 0 .And. SZD->ZD_TABCAB == "SN1"
			If nVlr3 > 0
				nVlr3 := nVlr3 / 0.8287  //Conversใo do Valor 1 para Valor 3
			Endif
			aadd( aCab, {"N3_VORIG3",nVlr3, NIL} )
			aadd( aLinha, {"N3_VORIG3",nVlr3, NIL} )
		ENDIF
		
		If SZD->ZD_TABCAB == "SN2"
			aadd( aCab, {"N2_SEQ","", NIL} )
			aadd( aLinha, {"N2_SEQ","", NIL} )
		Endif
		
		IF !Empty(SZD->ZD_TABDET)
			
			aadd(aItens,aLinha)
			aLinha := {}
			
			_cCodAnt := ""
			For _xx := 1 to Len(_aChave)
				_cCodAnt += _aDados[x,aScan(_aCampos, {|x| x[1] == _aChave[_xx] } )]
			Next
			
		ELSE
			// Processa rotina automatica
			IF !CCFG01INC(aCab,aItens,x)
				Return()
			ENDIF
		ENDIF
		
	Next
	
	// Processa rotina automatica
	IF !Empty(SZD->ZD_TABDET) .and. Len(aCab) > 0
		IF !CCFG01INC(aCab,aItens,x-1)
			Return()
		ENDIF
	ENDIF
	
	CCFG01TXT(.f.)
	
ENDIF

RestArea(_cArea)
Return()
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCFG01INC บAutor  ณ Totvs	  	       บ Data ณ03/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Carga de Dados                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ADELCO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function CCFG01INC(aCab,aItens,_nLinha)
Local _cArea           := GetArea()
Local _lRet            := .T.
Local _cBkpFil         := cFilAnt  //Salva valor original da cFilAnt     
Local cFornece		   := ""
Local cLoja			   := ""    
Local _cProduto		   := ""
Local lDisarm	 	   := .F.
local cChave			:= ""
local nPosCTA				:= ""
Private INCLUI         := .T.
Private lMsErroAuto    := .F.
Private lMsHelpAuto    := .T.
Private lAutoErrNoFile := .T.

_lExecAuto := SZD->ZD_EXECAUT=="1"

// Troca de variaveis do execauto dos movimentos contแbeis
IF Alltrim(SZD->ZD_ROTINA) == "CTBA102"
	IF (_nPos := aScan(aCab,{|x| Alltrim(x[1]) == "CT2_DATA"})) > 0
		aCab[_nPos][1] := "DDATALANC"
	ENDIF
	IF (_nPos := aScan(aCab,{|x| Alltrim(x[1]) == "CT2_LOTE"})) > 0
		aCab[_nPos][1] := "CLOTE"
	ENDIF
	IF (_nPos := aScan(aCab,{|x| Alltrim(x[1]) == "CT2_SBLOTE"})) > 0
		aCab[_nPos][1] := "CSUBLOTE"
	ENDIF
	IF (_nPos := aScan(aCab,{|x| Alltrim(x[1]) == "CT2_DOC"})) > 0
		aCab[_nPos][1] := "CDOC"
	ENDIF
ENDIF

Begin Transaction

If ( _nPosFil := Ascan(aCab,{|x| "_FILIAL" $ x[1] }) ) > 0 .and. !Empty(aCab[_nPosFil,2])
	_aAreaSM0 := SM0->(GetArea())
	_lFilOK := SM0->(MsSeek(cEmpAnt+Alltrim(aCab[_nPosFil,2])))
	IF !_lFilOK // Verifica se jogo de empresas ้ vแlido
		MsgStop("Empresa/Filial "+Alltrim(aCab[_nPosFil,2])+" invแlida. Verifique!","Empresa/Filial")
		_lRet := .F.
	ELSE
		cFilAnt := aCab[_nPosFil,2] //Substitui cFilAnt pela filial do Arquivo
	ENDIF
	
Endif

IF _lRet // Processa
	
	IF Len(aItens) > 0 // rotinas com cabe็alho e item
		IF Alltrim(Upper(SZD->ZD_ROTINA)) == "MATA120"
			&(Alltrim(SZD->ZD_ROTINA)+"(1,aCab,aItens,3)")
		ELSE
			&(Alltrim(SZD->ZD_ROTINA)+"(aCab,aItens,3)")
		ENDIF
	ELSE
		IF _lExecAuto

			_cChave  := ""
			
			_nPos := At("+",_cIndice)
			While !Empty(_cIndice) .And. _nPos > 0
				IF !("FILIAL"$Alltrim(Subs(_cIndice,1,_nPos-1)))
					If ValType(aCab[aScan(aCab,{|x| Upper(AllTrim(x[1])) == Upper(Subs(_cIndice,1,_nPos-1))}),2]	) == "D"
						_cChave += Dtos(aCab[aScan(aCab,{|x| Upper(AllTrim(x[1])) == Upper(Subs(_cIndice,1,_nPos-1))}),2])  //Tratamento para data no Indice.
					Else
						_cChave += aCab[aScan(aCab,{|x| Upper(AllTrim(x[1])) == Upper(Subs(_cIndice,1,_nPos-1))}),2]
					Endif
				ENDIF
				_cIndice := Subs(_cIndice,_nPos+1,Len(_cIndice)-_nPos)
				_nPos := At("+",_cIndice)
				If _nPos = 0 .And. !Empty(_cIndice)
					_nPos := Len(_cIndice)+1
				Endif
			Enddo
			
			IF !Empty(_cIndice)
				_cChave := aCab[aScan(aCab,{|x| Upper(AllTrim(x[1])) == Upper(Alltrim(_cIndice))}),2]
			ENDIF		
		
		
			DBSELECTAREA(SZD->ZD_TABCAB)
			(SZD->ZD_TABCAB)->(DBSETORDER(1))		
			IF (SZD->ZD_TABCAB)->(dbSeek(XFilial(SZD->ZD_TABCAB)+_cChave))
				&(Alltrim(SZD->ZD_ROTINA)+"(aCab,4)")			
			ELSE
				&(Alltrim(SZD->ZD_ROTINA)+"(aCab,3)")
			ENDIF
			
		ELSE
			
			(SZD->ZD_TABCAB)->(dbSetOrder(1))
			_cIndice := (SZD->ZD_TABCAB)->(IndexKey())
			If SZD->ZD_TABCAB == "SND" .Or. SZD->ZD_TABCAB == "CT2"  .Or. SZD->ZD_TABCAB == "SC7" //	Ana, para a tabela SND o campo ND_SEQUENC nao pode constar na chave de busca,
				//pois este campo ้ gerado pelo sistema na inclusใo do registros
				//CT2: No indice do SIX possui DTOS e precisa ser lido sem o DTOS.
				_cIndice := Alltrim(SZD->ZD_CHAVE)
			Endif
			_cChave  := ""
			_cFilial := ""
			
			_nPos := At("+",_cIndice)
			While !Empty(_cIndice) .And. _nPos > 0
				IF !("FILIAL"$Alltrim(Subs(_cIndice,1,_nPos-1)))
					If ValType(aCab[aScan(aCab,{|x| Upper(AllTrim(x[1])) == Upper(Subs(_cIndice,1,_nPos-1))}),2]	) == "D"
						_cChave += Dtos(aCab[aScan(aCab,{|x| Upper(AllTrim(x[1])) == Upper(Subs(_cIndice,1,_nPos-1))}),2])  //Tratamento para data no Indice.
					Else
						_cChave += aCab[aScan(aCab,{|x| Upper(AllTrim(x[1])) == Upper(Subs(_cIndice,1,_nPos-1))}),2]
					Endif
				ELSE
					_cFilial := Subs(_cIndice,1,_nPos-1)
				ENDIF
				_cIndice := Subs(_cIndice,_nPos+1,Len(_cIndice)-_nPos)
				_nPos := At("+",_cIndice)
				If _nPos = 0 .And. !Empty(_cIndice)
					_nPos := Len(_cIndice)+1
				Endif
			Enddo
			IF !Empty(_cIndice)
				_cChave := aCab[aScan(aCab,{|x| Upper(AllTrim(x[1])) == Upper(Alltrim(_cIndice))}),2]
			ENDIF
			
			IF (SZD->ZD_TABCAB)->(dbSeek(XFilial(SZD->ZD_TABCAB)+_cChave))
				DisarmTransaction()
				aAdd( aRegErr, {StrZero(_nLinha,5), {"Registro jแ cadastrado na base de dados"} } )
				Break
			ELSE
				RecLock(SZD->ZD_TABCAB,.T.)
				&((SZD->ZD_TABCAB)->(FieldName(1))) := XFilial(SZD->ZD_TABCAB)
				For i := 1 to Len(aCab)
					If 	(((SZD->ZD_TABCAB)+"->"+aCab[i,1]) == "SND->ND_SEQUENC" ) .Or. (((SZD->ZD_TABCAB)+"->"+aCab[i,1]) == "SN2->N2_SEQ" )    //Ana: Este campo ้ gerado pela fun็ใo NextSNDSeq
						If SZD->ZD_TABCAB == "SND"
							cSequencia:=NextSNDSEQ(SND->ND_CBASE,SND->ND_ITEM)
						ElseIf 	SZD->ZD_TABCAB == "SN2"
							cSequencia:=Substr(NextSNDSEQ(SN2->N2_CBASE,SN2->N2_ITEM),4,3)
						Endif
						aCab[i,2] := cSequencia    
						
					ElseIf (((SZD->ZD_TABCAB)+"->"+aCab[i,1]) == "SAD->AD_FORNECE" ) .Or. (((SZD->ZD_TABCAB)+"->"+aCab[i,1]) == "SC7->C7_FORNECE" ) 
						cFornece := aCab[i,2]
					ElseIf (((SZD->ZD_TABCAB)+"->"+aCab[i,1]) == "SAD->AD_LOJA" ) .Or.  (((SZD->ZD_TABCAB)+"->"+aCab[i,1]) == "SC7->C7_LOJA" )
						cLoja := aCab[i,2]									
					ElseIf (((SZD->ZD_TABCAB)+"->"+aCab[i,1]) == "SAD->AD_GRUPO" )   
						cGrupo := aCab[i,2]
					ElseIf (((SZD->ZD_TABCAB)+"->"+aCab[i,1]) == "SC7->C7_PRODUTO" )   
						_cProduto := aCab[i,2]	
					Endif
					
					&((SZD->ZD_TABCAB)+"->"+aCab[i,1]) := IIF("_FILIAL" $ aCab[i,1],XFilial(SZD->ZD_TABCAB),aCab[i,2]) // aCab[i,2]					
				Next                                                                                                               
				
				SBM->(dbSetOrder(1))   
				SA2->(dbSetOrder(1))
				SB1->(dbSetOrder(1))
				If SZD->ZD_TABCAB == "SAD" .And. !(SBM->(dbSeek(XFilial("SBM")+cGrupo)))		
					lDisarm := .T.
					aAdd( aRegErr, {StrZero(_nLinha,5), {"Grupo de Produtos invalido"} } )
				Endif	
				If  (SZD->ZD_TABCAB == "SAD" .Or. SZD->ZD_TABCAB == "SC7") .And. !(SA2->(dbSeek(XFilial("SA2")+cFornece+cLoja))  )
					aAdd( aRegErr, {StrZero(_nLinha,5), {"Fornecedor/Loja Invแlidos"} } )  
					lDisarm := .T.
				Endif	
				If  SZD->ZD_TABCAB == "SC7"  .And. !(SB1->(dbSeek(XFilial("SB1")+_cProduto))  )
					aAdd( aRegErr, {StrZero(_nLinha,5), {"Produto Invแlido"} } )  
					lDisarm := .T.
				Endif	
				
				If lDisarm	    
					DisarmTransaction()	
					Break   
				Else
					(SZD->ZD_TABCAB)->(msUnlock())
				Endif		

			ENDIF
			
		ENDIF
	ENDIF
	
	IF _lExecAuto
		If lMsErroAuto
			If (__lSX8)
				RollBackSX8()
			EndIf
			
			DisarmTransaction()
			
			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := CCFG01LOG( aLogErr, "" )
			aAdd( aRegErr, {StrZero(_nLinha,5), aLogErr2 } )
			
			// Alimenta LOG
			//_cMsgLOG += IIF(Empty(_cMsgLOG),"",CRLF+CRLF)
			//_cMsgLOG += StrZero(_nLinha,5)+Space(3)
			FWrite(_nHandTXT, StrZero(_nLinha,5)+Space(3))
			For nI := 1 To Len( aLogErr2 )
				//_cMsgLOG += IIF(nI==1,"",Space(8))+aLogErr2[nI]+CRLF
				FWrite(_nHandTXT,IIF(nI==1,"",Space(8))+aLogErr2[nI]+CRLF)
			Next
			
			Break
		Else
			
			If (__lSX8)
				ConfirmSX8()
			EndIf
			
		EndIf
	ENDIF
ENDIF

End Transaction

cFilAnt := _cBkpFil
RestArea(_cArea)
Return(_lRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCFG01IMP บAutor  ณ Totvs	  	       บ Data ณ03/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Carga de Dados                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ADELCO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function CCFG01IMP(aRegErr,_cAlias)
// Variaveis de Impressao
Private cDesc1    := 'Atualiza็ใo '+Alltrim(GetAdvFVal("SX2","X2_NOME",_cAlias,1,""))
Private cDesc2    := ''
Private cDesc3    := ''
Private Cabec1      := ''
Private Cabec2      := ''
Private aOrd        := {}
Private Titulo      := 'RELATORIO DE INCONSISTENCIAS'
Private aMeses      := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ''
Private Limite      := 132
Private Tamanho     := 'M'
Private NomeProg    := 'CCFG01IMP'
Private nTipo       := 18
Private aReturn     := { 'Zebrado', 1, 'Administracao', 2, 1, 1, '', 1}
Private nLastKey    := 0
Private Cbcont      := 00
Private m_pag       := 01
Private wnrel       := 'CCFG01IMP'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint( _cAlias, NomeProg,, @Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, .F., Tamanho,, .F. )

If nLastKey == 27
	Return NIL
EndIf

SetDefault( aReturn, _cAlias )

If nLastKey == 27
	Return NIL
EndIf

RptStatus( { || CCFG01RUN( aRegErr ) }, Titulo )

Return NIL
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCFG01RUN บAutor  ณ Totvs	  	       บ Data ณ03/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Carga de Dados                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ADELCO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function CCFG01RUN( aRegErr )
Local nI := 0
Local nJ := 0

SetPrc( 80, 1 )

For nI := 1 To Len( aRegErr )
	
	Cabec1 := 'Linha  Erro'
	
	If PRow() > 55
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
	Endif
	
	@ PRow()+1, 0 PSay ''
	@ PRow(),000 PSay aRegErr[nI][1]
	
	nPrxCol := 7
	
	For nJ := 1 To Len( aRegErr[nI][2] )
		
		If PRow() > 56
			Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
		Endif
		
		If nJ > 1
			@PRow()+1, 0 PSay ''
		EndIf
		
		@PRow(), nPrxCol PSay aRegErr[nI][2][nJ]
	Next
	@PRow()+1, 0 PSay ''
Next

If PRow() <> 80
	Roda( cbcont, cbtxt, Tamanho )
EndIf

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool( wnrel )
Endif

MS_FLUSH()

Return NIL
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCFG01CPO บAutor  ณ Totvs	  	       บ Data ณ03/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Carga de Dados                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ADELCO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function CCFG01CPO(_cAliasH,_cAliasD,_lExecAuto)
Local _aRet  := {}
Local _cMens := ""

_cLine := FT_FREADLN()
IF "๏ปฟ"$_cLine
	_cLine:= strtran(_cLine,"๏ปฟ","")
Endif

IF "ÿþA"$_cLine
	_cLine:= strtran(_cLine,"ÿþA","")
Endif

_nPos  := At(";",_cLine)
SX3->(dbSetOrder(2))
While !Empty(_cLine)  .And. _nPos > 0
	
	SX3->(dbGoTop())
	IF SX3->(dbSeek(Alltrim(Upper(Subs(_cLine,1,_nPos-1))))) .and. Alltrim(SX3->X3_CAMPO) == Alltrim(Upper(Subs(_cLine,1,_nPos-1)))
		IF !(SX3->X3_ARQUIVO$_cAliasH) .and. !(SX3->X3_ARQUIVO$_cAliasD)
			_cMens += Alltrim(SX3->X3_CAMPO)+Chr(13)+Chr(10)
		ELSE
			Aadd(_aRet,{Alltrim(SX3->X3_CAMPO),SX3->X3_ORDEM,Len(_aRet)+1})
		ENDIF
	ELSE
		_cMens += Alltrim(Subs(_cLine,1,_nPos-1))+Chr(13)+Chr(10)
	ENDIF
	_cLine := Subs(_cLine,_nPos+1,Len(_cLine)-_nPos)
	_nPos  := At(";",_cLine)
	If _nPos = 0 .And. !Empty(_cLine)
		_nPos := Len(_cLine)+1
	Endif
	//Skip()
Enddo
IF !Empty(_cLine)
	SX3->(dbGoTop())
	IF SX3->(dbSeek(Alltrim(_cLine))) .and. Alltrim(SX3->X3_CAMPO) == Alltrim(Upper(_cLine))
		IF !(SX3->X3_ARQUIVO$_cAliasH) .and. !(SX3->X3_ARQUIVO$_cAliasD)
			_cMens += Alltrim(SX3->X3_CAMPO)+Chr(13)+Chr(10)
		ELSE
			Aadd(_aRet,{Alltrim(SX3->X3_CAMPO),SX3->X3_ORDEM,Len(_aRet)+1})
		ENDIF
	ELSE
		//Os campos abaixo nใo estใo no layout porem sใo necessarios.
		If _cAliasH == "SN1"
			SX3->(dbSeek(Alltrim("N3_VORIG3"))) .and. Alltrim(SX3->X3_CAMPO) == Alltrim(Upper("N3_VORIG3"))
			Aadd(_aRet,{Alltrim(SX3->X3_CAMPO),SX3->X3_ORDEM,Len(_aRet)+1})
		Endif
		If _cAliasH == "SN2"
			SX3->(dbSeek(Alltrim("N2_SEQ"))) .and. Alltrim(SX3->X3_CAMPO) == Alltrim(Upper("N2_SEQ"))
			Aadd(_aRet,{Alltrim(SX3->X3_CAMPO),SX3->X3_ORDEM,Len(_aRet)+1})
		Endif
		
		_cMens += Alltrim(_cLine)+Chr(13)+Chr(10)
	ENDIF
ENDIF

// ordena campos conforme dicionario
ASORT(_aRet,,, { |x, y| x[2] < y[2] })

IF !Empty(_cMens)
	Aviso("Campos Invแlidos","Os campos abaixo nใo existem no dicionแrio de dados ou nใo pertencem ao cadastro selecionado."+Chr(13)+Chr(10)+_cMens,{"Sair"},3)
	_aRet := {}
ELSE
	// Alias do Header
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(_cAliasH))
	While !SX3->(Eof()) .and. SX3->X3_ARQUIVO == _cAliasH
		IF X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. X3OBRIGAT(Alltrim(SX3->X3_CAMPO)) .and. IIF(_lExecAuto,.f.,!Empty(SX3->X3_RELACAO)) .and. aScan(_aRet, {|x| x[1] == Alltrim(SX3->X3_CAMPO)}) == 0
			_cMens += Alltrim(SX3->X3_CAMPO)+Chr(13)+Chr(10)
		ENDIF
		SX3->(dbSkip())
	Enddo
	
	// Alias do Detail, quando existir
	IF !Empty(_cAliasD)
		SX3->(dbGoTop())
		SX3->(dbSetOrder(1))
		SX3->(dbSeek(_cAliasD))
		While !SX3->(Eof()) .and. SX3->X3_ARQUIVO == _cAliasD
			IF X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .and. X3OBRIGAT(Alltrim(SX3->X3_CAMPO)) .and. IIF(_lExecAuto,.f.,!Empty(SX3->X3_RELACAO)) .and. aScan(_aRet, {|x| x[1] == Alltrim(SX3->X3_CAMPO)} ) == 0
				_cMens += Alltrim(SX3->X3_CAMPO)+Chr(13)+Chr(10)
			ENDIF
			SX3->(dbSkip())
		Enddo
	ENDIF
	
	IF !Empty(_cMens)
		Aviso("Campos Obrigat๓rios","Os campos abaixo sใo obrigat๓rios e nใo foram localizados no arquivo."+Chr(13)+Chr(10)+_cMens,{"Sair"},3)
		_aRet := {}
	ENDIF
ENDIF

FT_FSKIP()
Return(_aRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCFG01LOG บAutor  ณ Totvs	  	       บ Data ณ03/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Carga de Dados                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ADELCO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function CCFG01LOG( aErr, cLit )
Local lHelp   := .F.
Local lTabela := .F.
Local cLinha  := ""
Local aRet    := {}
Local nI      := 0

For nI := 1 to LEN( aErr)
	cLinha  := UPPER( aErr[nI] )
	cLinha  := STRTRAN( cLinha,CHR(13), " " )
	cLinha  := STRTRAN( cLinha,CHR(10), " " )
	
	If SUBS( cLinha, 1, 4 ) == 'HELP' .Or. SUBS( cLinha, 1, 7 ) == 'ATENวรO' //Aten็ใo
		lHelp := .T.
	EndIf
	
	If SUBS( cLinha, 1, 6 ) == 'TABELA'
		lHelp   := .F.
		lTabela := .T.
	EndIf
	
	If  lHelp .or. ( lTabela .AND. '< -- INVALIDO' $  cLinha )
		aAdd( aRet,  cLinha )
	EndIf
	
Next

Return aRet
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCFG01ROT บAutor  ณ Totvs	  	       บ Data ณ03/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Carga de Dados                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ADELCO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function CCFG01ROT()
Local cExt      := "Arquivo CSV | *.CSV"
Local cPath     := "Selecione diret๓rio"
Local _aRotinas := {}
Local _aRet     := ""
Local nOpc      := 0

SZD->(dbSetOrder(1))
SZD->(dbGoTop())

While !SZD->(Eof()) .and. SZD->ZD_FILIAL == XFilial("SZD")
	Aadd(_aRotinas,{SZD->ZD_ROTINA,IIF(SZD->ZD_EXECAUT=="1","Sim","Nใo"),SZD->ZD_DESC})
	SZD->(dbSkip())
Enddo

IF Len(_aRotinas) == 0
	ApMsgInfo( 'Nใo existem rotinas cadastradas para carga de dados.', 'ATENวรO' )
	Return({})
ELSE
	DEFINE MSDIALOG oDlg TITLE "Selecione a Rotina" From 001,001 To 020,070 OF oMainWnd
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_BOTTOM
	
	DEFINE SBUTTON FROM 004,200 TYPE 1 ACTION (_aRet := {_aRotinas[oQual:nAt,1],_aRotinas[oQual:nAt,2]},nOpc := 1,oDlg:End()) ENABLE OF oPanel
	DEFINE SBUTTON FROM 004,240 TYPE 2 ACTION (oDlg:End()) ENABLE OF oPanel PIXEL
	
	@ .5,.80 LISTBOX oQual VAR _cVar Fields HEADER OemToAnsi("Rotina"),OemToAnsi("ExecAuto"),OemToAnsi("Descri็ใo") SIZE 130,42  NOSCROLL
	oQual:SetArray(_aRotinas)
	oQual:bLine := { || {_aRotinas[oQual:nAT,1],_aRotinas[oQual:nAT,2],_aRotinas[oQual:nAT,3]}}
	
	oQual:Align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlg CENTERED
ENDIF

If nOpc <> 1
	Return({})
EndIf

IF Empty(cArq:=cGetFile(cExt,cExt))
	MsgStop("Arquivo nใo informado. Verifique!")
	Return({})
ENDIF

IF At(Space(1),Alltrim(cArq)) <> 0
	Alert("Nome do arquivo invแlido. Retire os espa็os do nome do arquivo/diret๓rio!")
	Return({})
ENDIF

IF !File(cArq)
	Alert("O arquivo informado nใo existe. Verifique!")
	Return({})
ENDIF

Return(_aRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCFG01TXT บAutor  ณ Totvs	  	       บ Data ณ03/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Carga de Dados                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ADELCO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function CCFG01TXT(_lCabec)
Local _cDir    := "C:\TEMP\"
Local _cFile   := "carga"+Dtos(Date())+StrTran(Time(),":","")+".log"
Local _cMsgLOG := ""

IF _lCabec
	IF !lIsDir( _cDir )
		//Cria diretorio
		IF !MontaDir( _cDir ) // Verifica se criou o diretorio
			Count("CARGA --> Erro na cria็ใo do diretorio "+_cDir+". Consulte ADM do Sistema!")
			Return()
		ENDIF
	ENDIF
	
	_nHandTXT := FCreate(_cDir + _cFile)
	
	If _nHandTXT == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema")
		Return
	EndIf
	
	_cMsgLOG += Replicate( "-", 128 ) + CRLF
	_cMsgLOG += Replicate( " ", 128 ) + CRLF
	_cMsgLOG += "LOG DE IMPORTACAO "+Alltrim(SZD->ZD_DESC) + CRLF
	_cMsgLOG += Replicate( " ", 128 ) + CRLF
	_cMsgLOG += Replicate( "-", 128 ) + CRLF
	_cMsgLOG += CRLF
	_cMsgLOG += " Dados Ambiente" + CRLF
	_cMsgLOG += " --------------------"  + CRLF
	_cMsgLOG += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
	_cMsgLOG += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
	_cMsgLOG += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
	_cMsgLOG += " DataBase...........: " + DtoC( dDataBase )  + CRLF
	_cMsgLOG += " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
	_cMsgLOG += " Usuario TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
	_cMsgLOG += Replicate( "-", 128 ) + CRLF
	_cMsgLOG += CRLF
	_cMsgLOG += 'Linha   Erro'
	
	FWrite(_nHandTXT, _cMsgLOG)
ELSE
	IF Len( aRegErr ) == 0
		_cMsgLOG += CRLF
		_cMsgLOG += " *** Nใo foram encontradas inconsist๊ncias *** "
		_cMsgLOG += CRLF
	ENDIF
	_cMsgLOG += CRLF
	_cMsgLOG += Replicate( "-", 128 ) + CRLF
	_cMsgLOG += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
	_cMsgLOG += Replicate( "-", 128 ) + CRLF
	
	FWrite(_nHandTXT, _cMsgLOG)
	
	FClose(_nHandTXT)
	
	//	MemoWrite( _cDir+_cFile, _cMsgLOG )
ENDIF

Return()
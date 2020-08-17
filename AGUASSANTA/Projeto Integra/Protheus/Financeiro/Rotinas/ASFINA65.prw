#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'                  
#INCLUDE 'TOPCONN.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA65()

Tela estilo MarkBrowse para seleção dos registros para aglutinação dos titulos de PCC gerados pela baixa
@param		cQuery - Query com os titulos a serem selecionados
@return		Expressão complementando a query
@author 	Zema
@since 		25/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function ASFINA65()
LOCAL nX			:= 0
PRIVATE aRotina 	:= {}
PRIVATE cCADASTRO	:= "Titulos a Aglutinar"
PRIVATE cMark		:= GetMark()
PRIVATE aFields		:= {}
PRIVATE cArq		:= ""
PRIVATE bOpc1 		:= {|| MarcaTud()}
PRIVATE bOpc2 		:= {|| MarcaIte()}
PRIVATE cQry		:= cQuery
PRIVATE lConfirma	:= .F.

PRIVATE aRegAgl		:= {}
PRIVATE oDlg

AADD( aRotina, { "Confirmar"	,"U_FINA65C" 	, 0, 1} )

//-----------------------------------------------------------------------
// Gera arquivo temporario 
//-----------------------------------------------------------------------
Processa({|| MontaTrb()},"Selecionando titulos...", "", .F.)


DbSelectArea("TRMARK")
DbGotop()
MarkBrow( 'TRMARK', 'E5_OK',,aFields,, cMark ,"Eval(bOpc1)"   ,,,,"Eval(bOpc2)")
	
//-----------------------------------------------------------------------
// Apaga a tabela temporária
//-----------------------------------------------------------------------
DbSelectArea("TRMARK")
DbCloseArea() 
MsErase(cArq+GetDBExtension(),,"DBFCDX")

IF !lConfirma
	cQry := "AND SE5.E5_DATA = '' "	
ENDIF
RETURN(cQry)


//-----------------------------------------------------------------------
/*/{Protheus.doc} MontaTRB

Monta arquivo temporario de acordo com os parametros selecionados

@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		25/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MontaTRB()
//-----------------------------------------------------------------------
// Declaracao de Variaveis
//-----------------------------------------------------------------------
LOCAL aStru		:= {}
LOCAL aCampos	:= {}
LOCAL nX          
LOCAL bCampo
LOCAL nREGSE5	:= 0

//-----------------------------------------------------------------------
// Monta TRB com registros da query
//-----------------------------------------------------------------------
IF SELECT("TRBA") > 0
	TRBA->( dbCloseArea() )
ENDIF    

cQry := ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry), "TRBA" ,.F.,.T.)

ProcRegua(0)

//-----------------------------------------------------------------------
// Cria arquivo temporario
//-----------------------------------------------------------------------
aStru	:= {}
aFields	:= {}
aCampos	:= {}

//-----------------------------------------------------------------------
// Para criar a estrutura temporaria
//-----------------------------------------------------------------------
AADD(aStru,	{"E5_OK"	, "C", TAMSX3("E5_OK")[01]	, 0	})
AADD(aStru,	{"SE5REG"	, "N", 10					, 0	})
	
//-----------------------------------------------------------------------
// Lista das colunas do MarkBrowse
//-----------------------------------------------------------------------
AADD(aFields,	{"E5_OK", "", ""})

dbSelectArea("SX3")
DbSetOrder(1)
DbGoTop()
dbSeek("SE5")
While !Eof().And.(SX3->x3_arquivo=="SE5")
	If 			Alltrim(SX3->x3_campo)=="E5_FILIAL" ;
		.OR. 	Alltrim(SX3->x3_campo)=="E5_OK" ;
		.OR. 	Alltrim(SX3->x3_visual)=="V" 
		dbSelectArea("SX3")
		dbSkip()
		Loop
	Endif
	If (X3USO(SX3->x3_usado) .AND. ALLTRIM(UPPER(SX3->x3_browse)) == 'S')
		// para criar a estrutura temporaria
		AADD(aStru,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_tamanho, SX3->x3_decimal})
		
		// lista das colunas do MarkBrowse
		AADD(aFields,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_titulo, SX3->X3_picture, SX3->x3_tamanho, SX3->x3_decimal })
		
		// lista das campos para popular no MarkBrowse
		AADD( aCampos, "TRMARK->"+ALLTRIM(SX3->x3_campo) + " := " + "SE5->"+ALLTRIM(SX3->x3_campo) )
	Endif

	dbSelectArea("SX3")
	dbSkip()
Enddo

//-----------------------------------------------------------------------
// Cria a tabela temporária
//-----------------------------------------------------------------------
IF SELECT("TRMARK") > 0
	DBSELECTAREA("TRMARK")
	DBCLOSEAREA()
ENDIF
cArq	:=	"T_"+Criatrab(,.F.)
MsCreate(cArq,aStru,"DBFCDX") // atribui a tabela temporária ao alias TRB
dbUseArea(.T.,"DBFCDX",cArq,"TRMARK",.T.,.F.)// alimenta a tabela temporária

//-----------------------------------------------------------------------
// Popula a tabela temporária
//-----------------------------------------------------------------------
DbSelectArea("TRBA")
DbGoTop()
DO WHILE !EOF()
	nREGSE5 := TRBA->RECSE5
	
	DbSelectArea("SE5")
	DbGoTo( nREGSE5 )

	DBSELECTAREA("TRMARK")
	RECLOCK("TRMARK",.T.)
	FOR nX := 1 TO LEN( aCampos )
		bCampo := aCampos[nX]
		&bCampo
	NEXT
	TRMARK->E5_OK 	:= cMark
	TRMARK->SE5REG 	:= nREGSE5	                
	AADD(aRegAgl,ALLTRIM(STR(nREGSE5)))	
	MSUNLOCK()
	
	DbSelectArea("TRBA")
	DbSkip()
ENDDO
TRBA->( DbCloseArea() )
RETURN 

//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaTud

Marca ou desmarca todos os itens do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		25/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaTud()

	DbSelectArea("TRMARK")
	DbGoTop()
	DO WHILE !EOF()
		MarcaIte()
		TRMARK->( DbSkip() )
	ENDDO

RETURN
//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaIte

Marca ou desmarca o item do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		25/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaIte()
Local nPos := 0

	IF IsMark("E5_OK",cMark )
		RecLock("TRMARK",.F.)
		TRMARK->E5_OK := ""
		TRMARK->( MsUnLock() )
		nPos := ASCAN(aRegAgl,ALLTRIM(STR(TRMARK->SE5REG)))
		IF nPos > 0  
			ADEL(aRegAgl,nPos)
		ENDIF
	ELSE
		RecLock("TRMARK",.F.)
		TRMARK->E5_OK := cMark
 		TRMARK->( MsUnLock() )         
		nPos := ASCAN(aRegAgl,ALLTRIM(STR(TRMARK->SE5REG)))
		IF nPos == 0 		
			AADD(aRegAgl,ALLTRIM(STR(TRMARK->SE5REG)))
		ENDIF
	ENDIF
RETURN
//-----------------------------------------------------------------------
/*/{Protheus.doc} FINA65C

Seleciona os itens marcados

@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		25/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FINA65C
Local oMark := GetMarkBrow()
Local lSel  := .F.
Local cQryY := ""
cQry := ""
IF LEN(aRegAgl) > 0
	FOR nX := 1 TO LEN(aRegAgl)
		
		IF aRegAgl[nX] <> NIL 
		
			cQryY += aRegAgl[nX]
			cQryY += ","
			lSel := .T.
		endif	
	NEXT

	IF SUBSTR(cQryY,LEN(cQryY),1)==","
		cQryY := SUBSTR(cQryY,1,LEN(cQryY)-1)
	ENDIF
		
	cQryY+= ") "
ENDIF
IF lSel
	cQry := " AND SE5.R_E_C_N_O_ IN("+cQryY
ELSE
	cQry := "AND SE5.E5_DATA = '' "
ENDIF
oMark:Obrowse:Hide()
CloseBrowse()

lConfirma := .T.

RETURN

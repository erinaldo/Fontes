#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'                  
#INCLUDE 'TOPCONN.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA66()

Tela estilo MarkBrowse para sele��o dos registros a serem aglutinados do PCC - gerados pela emissao
@param		cQuery - Query com os titulos a serem selecionados
@return		Express�o complementando a query
@author 	Zema
@since 		17/08/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function ASFINA66()
LOCAL nX			:= 0
PRIVATE aRotina 	:= {}
PRIVATE cCADASTRO	:= "Titulos a Aglutinar"
PRIVATE cMark		:= GetMark()
PRIVATE aFields		:= {}
PRIVATE cArq		:= ""
PRIVATE bOpc1 		:= {|| MarcaTud()}
PRIVATE bOpc2 		:= {|| MarcaIte()}
PRIVATE cQry		:= cQuery
PRIVATE lConfirma   := .F.

PRIVATE aRegAgl		:= {}
PRIVATE oDlg

AADD( aRotina, { "Confirmar"	,"U_FINA66C" 	, 0, 1} )

//-----------------------------------------------------------------------
// Gera arquivo temporario 
//-----------------------------------------------------------------------
Processa({|| MontaTrb()},"Selecionando titulos...", "", .F.)


DbSelectArea("TRMARK")
DbGotop()
MarkBrow( 'TRMARK', 'E2_OK',,aFields,, cMark ,"Eval(bOpc1)"   ,,,,"Eval(bOpc2)")
	
//-----------------------------------------------------------------------
// Apaga a tabela tempor�ria
//-----------------------------------------------------------------------
DbSelectArea("TRMARK")
DbCloseArea() 
MsErase(cArq+GetDBExtension(),,"DBFCDX")


IF !lConfirma
	cQry := "AND SE2.E2_TIPO = '' "
ENDIF

RETURN(cQry)


//-----------------------------------------------------------------------
/*/{Protheus.doc} MontaTRB

Monta arquivo temporario de acordo com os parametros selecionados

@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		17/08/2017
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
LOCAL nREGSE2	:= 0

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
AADD(aStru,	{"E2_OK"	, "C", TAMSX3("E2_OK")[01]	, 0	})
AADD(aStru,	{"SE2REG"	, "N", 10					, 0	})
	
//-----------------------------------------------------------------------
// Lista das colunas do MarkBrowse
//-----------------------------------------------------------------------
AADD(aFields,	{"E2_OK", "", ""})

dbSelectArea("SX3")
DbSetOrder(1)
DbGoTop()
dbSeek("SE2")
While !Eof().And.(SX3->x3_arquivo=="SE2")
	If 			Alltrim(SX3->x3_campo)=="E2_FILIAL" ;
		.OR. 	Alltrim(SX3->x3_campo)=="E2_OK" ;
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
		AADD( aCampos, "TRMARK->"+ALLTRIM(SX3->x3_campo) + " := " + "SE2->"+ALLTRIM(SX3->x3_campo) )
	Endif

	dbSelectArea("SX3")
	dbSkip()
Enddo

//-----------------------------------------------------------------------
// Cria a tabela tempor�ria
//-----------------------------------------------------------------------
IF SELECT("TRMARK") > 0
	DBSELECTAREA("TRMARK")
	DBCLOSEAREA()
ENDIF
cArq	:=	"T_"+Criatrab(,.F.)
MsCreate(cArq,aStru,"DBFCDX") // atribui a tabela tempor�ria ao alias TRB
dbUseArea(.T.,"DBFCDX",cArq,"TRMARK",.T.,.F.)// alimenta a tabela tempor�ria

//-----------------------------------------------------------------------
// Popula a tabela tempor�ria
//-----------------------------------------------------------------------
DbSelectArea("TRBA")
DbGoTop()
DO WHILE !EOF()
	nREGSE2 := TRBA->RECSE2
	
	DbSelectArea("SE2")
	DbGoTo( nREGSE2 )

	DBSELECTAREA("TRMARK")
	RECLOCK("TRMARK",.T.)
	FOR nX := 1 TO LEN( aCampos )
		bCampo := aCampos[nX]
		&bCampo
	NEXT
	TRMARK->E2_OK 	:= cMark
	TRMARK->SE2REG 	:= nREGSE2	                
	AADD(aRegAgl,ALLTRIM(STR(nREGSE2)))	
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
@since 		17/08/2017
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
@since 		17/08/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaIte()
Local nPos := 0

	IF IsMark("E2_OK",cMark )
		RecLock("TRMARK",.F.)
		TRMARK->E2_OK := ""
		TRMARK->( MsUnLock() )
		nPos := ASCAN(aRegAgl,ALLTRIM(STR(TRMARK->SE2REG)))
		IF nPos > 0  
			ADEL(aRegAgl,nPos)
		ENDIF
	ELSE
		RecLock("TRMARK",.F.)
		TRMARK->E2_OK := cMark
 		TRMARK->( MsUnLock() )         
		nPos := ASCAN(aRegAgl,ALLTRIM(STR(TRMARK->SE2REG)))
		IF nPos == 0 		
			AADD(aRegAgl,ALLTRIM(STR(TRMARK->SE2REG)))
		ENDIF
	ENDIF
RETURN
//-----------------------------------------------------------------------
/*/{Protheus.doc} FINA66C

Seleciona os itens marcados

@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		17/08/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FINA66C
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
	cQry := " AND SE2.R_E_C_N_O_ IN("+cQryY
ELSE
	cQry := "AND SE2.E2_TIPO = '' "
ENDIF
oMark:Obrowse:Hide()
CloseBrowse()

lConfirma := .T.

RETURN

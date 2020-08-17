
/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡Æo    ³fOpen_Word³ Autor ³ Marinaldo de Jesus    ³ Data ³06/05/2000³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡Æo ³Selecionaro os Arquivos do Word.                            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
User Function fOpen_Conv()

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= "*.DBF"												
Local cNewPathArq	:= If(Empty(mv_par01),cGetFile( cTipo , "Selecione o arquivo *.DBF" ),mv_par01)									

IF !Empty( cNewPathArq )
	IF Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( "DBF" ) )	
		Aviso( "Arquivo Selecionado" , cNewPathArq , { "Ok" } )								
    Else
    	MsgAlert( "Arquivo Invalido " )															
    	Return
    EndIF
Else
    Aviso("Cancelada a Selecao!","Voce cancelou  a selecao do arquivo." ,{ "Ok" } )													
    Return
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Limpa o parametro para a Carga do Novo Arquivo                         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dbSelectArea("SX1")
IF lAchou := ( SX1->( dbSeek( cPerg + "01" , .T. ) ) )
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
	mv_par01 := cNewPathArq
	MsUnLock()
EndIF	
dbSelectArea( cSvAlias )

Return( .T. )


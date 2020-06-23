#define Confirma 1
#define Redigita 2
#define Abandona 3

#include "rwmake.ch"
#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FIMPCAD  ³ Autor ³ Reginaldo             ³ Data ³ 09.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastramento de Lay-Out para Importacao de Tabelas        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER Function IMPCAD()

Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2
Local nPosLbx 	:= 0.00
Local oPesq		:= NIL
Local oDlg		:= NIL
Local oLbx		:= NIL

Local oPesq, cPesq := Space(3)

aLbx := {}

aTabelas := {}
    
DbSelectArea('SX2')
DbGotop()
While  !eof()
    aAdd(aTabelas,{SX2->X2_CHAVE,SX2->X2_NOME})
    DbSkip()
EndDo
    
_aCabTab := {'Chave','Descricao'}

DEFINE MSDIALOG oDlg From 001,001 To 310,520 TITLE OEMTOANSI("Importação de Arquivos") pixel

oLbx := RDListBox( 1.7, .4, 245, 105, aTabelas, _aCabTab)
		
oLbx:SetArray(aTabelas)
oLbx:bLine := { || {aTabelas[oLbx:nAt,1],atabelas[oLbx:nAt,2]}}


@ 5.0,05 SAY OemToAnsi('Pesquisar') SIZE 100, 15 OF oDlg PIXEL 
@ 2.5,30 MSGET oPesq  VAR cPesq  SIZE 18,10 OF oDlg PIXEL PICTURE "@!" ;
					VALID (nPosArq:=If( !Empty(cPesq) , ASCAN(aTabelas,{ |x| AllTrim(cPesq) $ x[1] }),oLbx:nAt),If(nPosArq#0,oLbx:nAt:=nPosArq,MsgStop(OemtoAnsi("Arquivo nao encontrado"))),oLbx:Refresh(),If(nPosArq#0,nArq:=nPosArq,),(nPosArq#0))
@ 1.9,060 BUTTON "&LayOut" SIZE 40,15 pixel ACTION ( lOk := .T., U_IMPMANUT(aTabelas[oLbx:nAt][1],Recno(),4) )
@ 1.9,110 BUTTON "&De-Para" SIZE 40,15 pixel ACTION ( lOk := .T., U_IMPDEPARA(aTabelas[oLbx:nAt][1],Recno(),4) )
@ 1.9,160 BUTTON "&importar" SIZE 40,15 pixel ACTION ( lOk := .T., U_IMPARQTXT() )
@ 1.9,210 BUTTON "&Sair" SIZE 40,15 pixel ACTION ( lOk := .F., oDlg:End() )
		
ACTIVATE MSDIALOG oDlg CENTERED 

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ManutCad  ³ Autor ³ Reginaldo             ³ Data ³ 09.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de (Manutencao Lay-out Conf. Arquivos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ImpManut(cAlias,nReg,nOpcx)

nOpcAuto := 4

Private aRotina := {{ "Alterar"	, "U_MANUTIMP"	, 0 , 4 },; //"Alterar"
						}
		
		aRotSetOpc( "SX2" , NIL , nOpcAuto , .F. )
		nPos := aScan( aRotina , { |x| x[4] == nOpcAuto } )
		IF ( nPos == 0 )
			Break
		EndIF
		dbSelectArea( "SX2" )
		bBlock	:= &( "{ |a,b,c,d,e,f,g| " + aRotina[ nPos , 2 ] + "(a,b,c,d,e,f,g) }" )
		uRet	:= Eval( bBlock , cAlias , SX2->( Recno() ) , nPos )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ManutCad  ³ Autor ³ Reginaldo             ³ Data ³ 09.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de (Manutencao Lay-out Conf. Arquivos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User  Function ManutIMP(cAlias,nReg,nOpcx)

Local cSaveMenuh,nCnt,GetList:={}

Local aSaveArea := GetArea()
Local aObjCoords	:= {}   
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
DbSeek(cAlias)
cNome  := SX2->X2_NOME

altera := .t.
Private xAlias    := cAlias
Private aAC      := {"Abandona","Confirma"}
Private aColsRec := {}   //--Array que contem o Recno() dos registros da aCols
Private cArquivo :=	"ARQ"+xAlias+".TXT"
While .T.

    nCnt := 0

    If fChkArqTxt(@nCnt) // verifica se existe arquivo texto com configuracao
    else 				 // se nao existir monta dicionario padrao SX3 
	    DbSelectArea("SX3")
        DbSetOrder(1)
	    DbSeek(xAlias)
	    While X3_arquivo = xAlias .and. ! eof()
          If SX3->X3_CONTEXT = "V"
             DbSkip()
             Loop
          EndIF
             
	      nCnt ++     
	      DbSkip()
	    EndDo
    EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a entrada de dados do arquivo                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aTELA[0][0],aGETS[0],aHeader[0],Continua:=.F.,nUsado:=0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o cabecalho                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    ImpaHead(1) // Monta Cabecalho
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona ponteiro do arquivo cabeca e inicializa variaveis  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpcA := 0

    PRIVATE aCOLS[nCnt][nUsado+1]
	nCnt   :=0
	nUsado :=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerar o array aCols com os campos                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    GeraaCols(nOpcx,cArquivo,1)

   DbSelectArea(cAlias)
   
	nOpca := 0

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Monta as Dimensoes dos Objetos         					   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

aAdvSize		:= MsAdvSize()
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

SetaPilha()
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Manutencao Lay-Out" ) FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL	//"Valores por Verba"

		@ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO ( aObjSize[1,3] - 3 ),( ( aObjSize[1,4]/100*20 - 2 ) ) LABEL OemToAnsi("Alias") OF oDlg PIXEL		
		oGroup:oFont:= oFont
		@ aObjSize[1,1] , ( aObjSize[1,4]/100*20 ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),aObjSize[1,4] LABEL OemToAnsi("Descricao") OF oDlg PIXEL				// "Nome:"
		oGroup:oFont:= oFont

		@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( aObjSize[1,2] + 5 )				SAY OemToAnsi( cAlias)	SIZE 050,10 OF oDlg PIXEL FONT oFont
		@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( ( aObjSize[1,4]/100*20 ) + 5 )	SAY OemToAnsi(cNome) 	SIZE 146,10 OF oDlg PIXEL FONT oFont

      oGet := MSGetDados():New(32,0,301.5,634,nOpcx,"u_ManutLinOk","u_ManutTudOk","",If(nOpcx=4.Or.nOpcx=5,Nil,.T.),,1)

   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca:=If(nOpcx=5,2,1),If(oGet:TudoOk(),oDlg:End(),nOpca:=0)},{||oDlg:End()})

SetaPilha()

    //--Se nao for Exclusao
   IF nOpcA == Confirma .And. nOpcx # 5
       Begin Transaction
                //--Gravacao
                GravaManut()

       End Transaction
    Endif

	Exit

EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da janela                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RestArea(aSaveArea)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpHead³ Autor ³ Reginaldo                 ³ Data ³ 23/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Criar os Arrays Aheader e aCols dos  arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpaHead(nTipo)

If nTipo = 1

    AADD(aHeader,{ "Habilitado","XX_HABILI","!",;
			1,0, "      ",;
			"Usado? ","C","XXX" } )

     AADD(aHeader,{ "Nome Campo","XX_CAMPO ","@!",;
			10,0, "      ",;
			"Usado? ","C","XXX" } )

    AADD(aHeader,{ "Tipo Campo","XX_TIPO  ","!",;
			1,0, "       ",;
			"Usado? ","C","XXX" } )

    AADD(aHeader,{ "Decimal Campo","XX_DECIMAL","9",;
			1,0, "       ",;
			"Usado? ","C","XXX" } )
 
    AADD(aHeader,{ "Campo Chave","XX_CHAVE","!",;
			1,0, "       ",;
			"Usado? ","C","XXX" } )

    AADD(aHeader,{ "Pos. Inicial","XX_VALID","9999",;
			4,0, "       ",;
			"Usado? ","C","XXX" } )

    AADD(aHeader,{ "Pos. Final","XX_USADO","9999",;
			4,0, "       ",;
			"Usado? ","C","XXX" } )

    AADD(aHeader,{ "Formula  ","XX_FORMULA","@!",;
			160,0, "      ",;
			"Usado? ","C","XXX" } )

    nUsado += 8

Else

    AADD(aHeader,{ "Codigo De","XX_CODDE","",;
			10,0, "      ",;
			"Usado? ","C","XXX" } )

     AADD(aHeader,{ "Codigo Para","XX_CODPA ","@!",;
			10,0, "      ",;
			"Usado? ","C","XXX" } )
        nUsado += 2
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraaCols ³ Autor ³ Reginaldo                ³ Data ³ 23/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Criar os Arrays Aheader e aCols dos  Arquivos          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GeraaCols(nOpcx,cArq,nTipo)

Local nHandle

nCnt := 0

If File(cArq)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo texto informado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHandle := fOpen( cArq ,64)
	
	If Ferror() # 0 .or. nHandle < 0
		Help(" ",1,"A210NOPEN")
		Return( Nil )
	Endif
	
	TXT := fReadStr( nHandle,256 )
	nBytes := (At( CHR(13)+CHR(10),TXT )) + 1
	
	aFile   := Directory( cArq )
	nSize   := aFile[1,2]
	nLinhas := Int(nSize/nBytes)
	
	fSeek( nHandle,0,0 )
	
	For nCount := 1 To nLinhas
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Lˆ cada linha do arquivo texto ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TXT := fReadStr( nHandle,nBytes )
		
		If nTipo = 1
			nCnt++
		Else
			If Substr(TXT,1,3) == cTab_dep
				nCnt++
			Else
				aAdd(aTab_dep,(TXT))
			EndIf
		EndIF
		nUsado := 0
		
		For nx := 1 to Len(aHeader)
			
			If nTipo = 1
				nUsado ++
				
				If nx = 1
					aCOLS[nCnt][nUsado] := Substr(txt,1,1)
				ElseIf nx = 2
					aCOLS[nCnt][nUsado] := Substr(txt,2,10)
				ElseIf nx = 3
					aCOLS[nCnt][nUsado] := Substr(txt,12,1)
				ElseIf nx = 4
					aCOLS[nCnt][nUsado] := Substr(txt,13,1)
				ElseIf nx = 5
					aCOLS[nCNt][nUsado] := Substr(txt,14,1)
				ElseIf nx = 6
					aCOLS[nCnt][nUsado] := Substr(txt,15,4)
				ElseIf nx = 7
					aCOLS[nCnt][nUsado] := Substr(txt,19,4)
				ElseIf nx = 8
					aCOLS[nCnt][nUsado] := Substr(txt,23,160)
				EndIf
				aCOLS[nCnt][nUsado+1] := .F.
				
			Else
				
				If  Substr(TXT,1,3) == cTab_dep
					nUsado ++
					
					If nx = 1
						aCOLS[nCnt][nUsado] := Substr(txt,4,10)
					ElseIf nx = 2
						aCOLS[nCnt][nUsado] := Substr(txt,14,10)
					EndIf
					aCOLS[nCnt][nUsado+1] := .F.
					
				EndIF
				
			EndIf
			
		Next
		
		
	Next
	
	fClose(nHandle)
	
	If nCnt = 0
		nCnt ++
		nUsado := 0
		
		For nx  := 1 to Len(aHeader)
			nUsado ++
			If nx = 1
				aCOLS[nCnt][nUsado] := "0000000001"
			ElseIf nx = 2
				aCOLS[nCnt][nUsado] :=  "9999999999"
			EndIf
		Next
		aCOLS[nCnt][nUsado+1] := .F.
	EndIf
	
Else
	
	If nTipo = 1
		
		SIX->(Dbseek(xAlias))
		
		nSeq := 0
		
		DbSelectArea("SX3")
		If DbSeek(xAlias)
			
			While X3_ARQUIVO = xAlias .and. !eof()
				
				If SX3->X3_CONTEXT = "V"
					DbSkip()
					Loop
				EndIF
				nCnt++
				nUsado  := 0
				nSeq += SX3->X3_TAMANHO
				
				cCampo_ := SX3->X3_CAMPO
				
				If Upper(Alltrim(cCampo_)) $ Upper(SIX->CHAVE)
					cIndi_ := "S"
				Else
					cIndi_ := "N"
				EndIF
				
				For nx  := 1 to Len(aHeader)
					
					nUsado ++
					
					If nx = 1
						aCOLS[nCnt][nUsado] := "S"
					ElseIf nx = 2
						aCOLS[nCnt][nUsado] := x3_campo
					ElseIf nx = 3
						aCOLS[nCnt][nUsado] := x3_tipo
					ElseIf nx = 4
						aCOLS[nCnt][nUsado] := StrZero(x3_decimal,1)
					ElseIf nx = 5
						aCOLS[nCnt][nUsado] := cIndi_
					ElseIf nx = 6
						aCOLS[nCnt][nUsado] := Strzero(nSeq - sx3->x3_tamanho +1,4)
					ElseIf nx = 7
						aCOLS[nCnt][nUsado] := Strzero(nSeq,4)
					ElseIf nx = 8
						aCOLS[nCnt][nUsado] := Space(160)
					EndIf
					
				Next
				aCOLS[nCnt][nUsado+1] := .F.
				
				DbSkip()
				
			EndDo
			
		EndIF
		
	Else
		
		nCnt ++
		nUsado := 0
		
		For nx  := 1 to Len(aHeader)
			nUsado ++
			If nx = 1
				aCOLS[nCnt][nUsado] := "0000000001"
			ElseIf nx = 2
				aCOLS[nCnt][nUsado] :=  "9999999999"
			EndIf
		Next
		
	EndIf
	aCOLS[nCnt][nUsado+1] := .F.
	
EndIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³                   ROTINAS DE CRITICA DE CAMPOS                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaManut³ Autor ³ Reginaldo             ³ Data ³ 06.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava no arquivo TXT                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static  Function GravaManut()

Local ny:=0,nMaxArray:=Len(aHeader)

nHandle  := MSFCREATE(cArquivo)

If FERROR() # 0 .Or. nHandle < 0
	Help("",1,"GPM600HAND")
	FClose(nHandle)
	Return Nil
EndIf


For n:=1 TO Len(aCols)


    //--Verifica se Nao esta Deletado no aCols
    xConteudo := ""
    If aCols[n,nUsado+1] = .F.
	    For ny := 1 To nMaxArray
    	    xConteudo += aCols[n,ny]
	    Next ny
		FWrite( nHandle,xConteudo+chr(13)+chr(10))
    EndIf

Next n

FClose(nHandle)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ManutLinOk³ Autor ³ J. Ricardo            ³ Data ³ 06.08.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Critica linha digitada                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
user Function ManutLinOk(o)

Local nx,lRet := .T.           
Local cCampo 

If aCols[n,nUsado+1]  = .F.
    
    If aCols[n,1] == "N" 
       SIX->(Dbseek(SX2->X2_CHAVE))
       If Alltrim(aCols[n,2])  $ SIX->CHAVE
           MsgAlert('Este Campo nao pode estar desabilitado, porque faz parte do indice')
           lRet  := .f.
       EndIf    
    ElseIf !aCols[n,1] $ "SN" // verifica se o campo habilitado está com S ou N
        MsgAlert('Informar S ou N para o Campo: Habilitado')
        lRet  := .f.
    EndIf
    cCampo := allTrim(aCols[n,2])
    If  FieldPos( cCampo  ) = 0
        MsgAlert('O Campo Informado nao existe no Dicionario de Dados')
        lRet  := .f.
    EndIf
        
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ManutTudOk³ Autor ³ Reginaldo           ³ Data ³ 15.02/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function ManutTudOk(o)
Local lRetorna  := .T.
Continua := .F.
Return lRetorna


User Function ImpArqTxt

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpArqTxt   ³ Autor ³ R.H. - Reginaldo      ³ Data ³ 24.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao dos Cadastro do Recursos Humanos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Local cArquivo
Local nOpca := 0
Local aRegs	:={}

Local aSays:={ }, aButtons:= { } //<== arrays locais de preferencia
Private lAbortPrint := .F.
cCadastro := OemToAnsi("Importacao de Cadastros") 

Aadd(aRegs,{"GPECAD","01","Arquivo        ?","","","mv_cha","C",030,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPECAD","02","Alias do Arquivo?","","","mv_chb","C",003,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPECAD","03","Formato Cpo. Data  ?","","","mv_chc","N",01,0,0,"C","","mv_par03","dd/mm/aaaa","","","","","ddmmaaaa","","","","","aaaammdd","","","",""})

ValidPerg(aRegs,"GPECAD")

Pergunte("GPECAD",.F.)

AADD(aSays,OemToAnsi("Este programa importa arquivos de lancamentos") )   

AADD(aButtons, { 5,.T.,{|| Pergunte("GPECAD",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

IF nOpca == 1
		Processa({|lEnd| GPProcessa(),"Importacao de cadastros"})
Endif

Return( Nil )

Static Function GPProcessa()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento	                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArqTXT   := alltrim(mv_par01)
cAlias    := UPPER(mv_par02)
cArqConf  := "ARQ"+cAlias+".TXT"

_aStru := {}
_aTab  := {}

fAbreArq(cArqConf)

fAbreTab("ARQDEP.TXT")

fImpCadas()

Static Function fImpCadas()

Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2
Local cFilSRV := xFilial("SRV")
Private aTotais := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando as Perguntas 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArquivo := ALLTRIM(mv_par01)
nForData := mv_par03

If ! File(cArquivo)
    Help(" ",1,"A210NOPEN")
	 Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo texto informado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := fOpen( cArquivo ,68)
If Ferror() #0 .or. nHandle < 0
    Help(" ",1,"A210NOPEN")
    Return( Nil )
Endif


TXT := fReadStr( nHandle,3054 )
nBytes := (At( CHR(13)+CHR(10),TXT )) + 1
aFile   := Directory( cArquivo )
nSize   := aFile[1,2]
nLinhas := Int(nSize/nBytes)

fSeek( nHandle,0,0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Regua de processamento de registros              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SIX")
If DbSeek(cAlias)
   cIndChave := ALLTRIM(SIX->CHAVE)
Else
   Alert('nao sera possivel importar o arquivo, pois nao existe indice na Tabela')
   Return
EndIf   

aChave := {}
cIndice := ""
for n := 1 to Len(cIndChave)
    If Substr(cIndChave,n,1) <> "+"
       cIndice += substr(cIndChave,n,1)
    Else
       aAdd(aChave,{cIndice,''})
       cIndice := ""
    EndIF
NEXT       

aAdd(aChave,{cIndice,''})

/*
IF cAlias == "SRB"
   if ma280flock("SRB")
      zap             
      DbClearInd()
      RetIndex("SRB") 
      DbReIndex()
   EndIF
EndIF      
*/
nTotGrav := 0
nValor   := nHoras := 0
cAnoMes := ""
 
ProcRegua(nLinhas)
dbSelectArea(cAlias)
For nCount := 1 To nLinhas

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Move Regua Processamento	                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncProc("Importando Registros ")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Lˆ cada linha do arquivo texto ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    TXT := fReadStr( nHandle,nBytes )

    // verifica se existe campo chave para gravacao
    For nChave := 1 to len(_aStru)

       cCampo  :=  _aStru[nChave,1]
       
       If ( nPosChave := Ascan(aChave,{ |x| cCampo $ x[1] })  ) > 0
          nPosIni := val(_aStru[nChave,5])
          nPosFim := Val(_aStru[nChave,6])
          cTXT    := Substr(TXT,nPosIni,nPosFim-nPosIni+1)
          cFuncao_ := alltrim(_aStru[nChave,7] )

          If !empty(cFuncao_)
             cTxt := &cFuncao_
          EndIf

          aChave[nPosChave,2] := cTxt
          
       EndIF
       
    Next       

    cChave := ""
    For n := 1 To len(aChave)
        cChave += aChave[n,2]
    Next    
    
    dbSelectArea(cAlias)
    dbSetOrder(1)
    // Se a tabela a ser importada for a ficha financeira, verifica se ja existe o evento para o mes e ano e acrescenta a sequencia
    If cAlias == "SRD"

       cSeq := " "
       cChave := Substr(cChave,1,17)
       If dbseek(cChave)     
	       nSeq := 0
           While SRD->(RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD) == cChave .and. !eof()
                 nSeq := val(SRD->RD_SEQ)
                 DbSkip()
           EndDo      
           cSeq := Str(nSeq+=1,1)
           cChave := cChave+"  "+cSeq
	    EndIf  
    
    ElseIf cAlias == "SRB"
       cSeq := "01"
       cChave := Substr(cChave,1,8)
       If dbseek(cChave)     
	       nSeq := 0
           While SRB->(RB_FILIAL+RB_MAT) == cChave .and. !eof()
                 nSeq := val(SRB->RB_COD)
                 DbSkip()
           EndDo      
           cSeq := StrzERO(nSeq+1,2)
           cChave := cChave+cSeq
	    EndIf  
        
    EndIf

//    If cAlias == "SRD" .and. Empty(Left(cChave,2))
//       Loop
//    EndIf   

    nTotGrav ++
    
    // Se a Tabela for de Dependentes, nao testa se ja existe, pois nao existe indice para a sequencia dos dependentes.
    IF cAlias == "SRB" 
       
	   RecLock( cAlias,.T. )    
    
    Else

	    If dbseek(cChave)
        	   RecLock( cAlias,.F. )
	    Else   
        	   RecLock( cAlias,.T. )
       ENDIF

    EndIf
    //Grava Os Campo na Tabela
    nTotCpo  := len(_aStru)
    For nCampo := 1 to nTotCpo

       //_aStru[n,1] = CAMPO              01/10
       //_aStru[n,2] = TIPO               11/01
       //_aStru[n,3] = DECIMAL            12/01
       //_aStru[n,4] = CHAVE DE INDICE ?  13/01
       //_aStru[n,5] = POSICAO INICIAL    14/04
       //_aStru[n,6] = POSICAO final      18/04       
       //_aStru[n,7] = FORMULA            22/60

          cCampo    :=  _aStru[nCampo,1]
          nPosIni   := val(_aStru[nCampo,5])
          nPosFim   := Val(_aStru[nCampo,6])
          cFuncao_  := alltrim(_aStru[nCampo,7] )
          
          IF _aStru[nCampo,2] == "N"

             cTxt :=  Substr(TXT,nPosIni,nPosFim-nPosIni+1)
             cTxt := StrTran(cTxt,",",".")
             cTxt := Val(cTxt)

          ElseIf _aStru[nCampo,2] == "D"
             
             cTxt := Substr(TXT,nPosIni,nPosFim-nPosIni+1)
             If nForData = 1 // DD/MM/AAAA
                cTxt := Ctod(ctxt)
             ElseIf nForData = 2 // ddmmaaaa
                cTxt :=  Ctod(Substr(cTxt,1,2)+"/"+Substr(cTxt,3,2)+"/"+alltrim(Substr(ctxt,5,4)))
             ElseIf  nForData = 3   // AAAAMMDD
                cTxt := Stod(cTxt)    
             EndIf
          
          Else
          
             cTxt :=  Substr(TXT,nPosIni,nPosFim-nPosIni+1)
          
          EndIf   

          If !empty(cFuncao_)
             cTxt := &cFuncao_
          EndIf

          IF "RD_PD" $ cCampo
             cPd := cTxt
             cTipoCod := PosSrv(cPd,cFilSRV,'RV_TIPOCOD')
          ElseIf "RD_DATARQ" $ cCampo 
             cAnoMes := cTxt
          ElseIf "RD_VALOR" $ cCampo 
             nValor  := cTxt
          ElseIf "RD_HORAS" $ cCampo 
             nHoras  := cTxt
          EndIF
          
          If "RD_SEQ" $ cCampo
              If !Empty(cSeq)
                RD_SEQ := cSeq
              EndIf  
          ElseIf "RB_COD" $ cCampo
              If !Empty(cSeq)
                RB_COD := cSeq
              EndIf  
          Else
              &cCampo := cTXT
          EndIf        
 		  
 		  If cAlias == "SRD"  .and. nCampo == nTotCpo // se for o ultimo campo da tabela SRD, carrega o array com os totais
			 
				If ( nPosTot := Ascan(aTotais, { |x| x[1] == cAnomes .and. x[2] == cPd })) > 0
					     If  cTipoCod == "1"
					        aTotais[nPosTot,3] += nHoras
					        aTotais[nPosTot,4] += nValor
					     ElseIf  cTipoCod == "2"  
					        aTotais[nPosTot,5] += nHoras
		    		        aTotais[nPosTot,6] += nValor
					     Else
					        aTotais[nPosTot,7] += nValor
					     EndIf
				Else
					     aAdd(aTotais,{cAnoMes,cPd,If (cTipoCod = "1",nHoras,0),If (cTipoCod = "1",nValor,0),If (cTipoCod = "2",nHoras,0),;
					                   If (cTipoCod = "2",nValor,0),If (!cTipoCod $ "1-2",nValor,0)} )
				EndIf                   
		    
		    EndIF

     Next nCampo 
     MsUnlock()

Next nCount

fclose(nHandle)

If cAlias == "SRD"
   fImprime()
EndIF
   

Return
    

STATIC FUNCTION fAbreArq(cArq)

Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando as Perguntas 									 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArquivo    := cArq
private nLinhas

If ! File(cArquivo)
    Help(" ",1,"A210NOPEN")
	 Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo texto informado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := fOpen( cArquivo ,64)
If Ferror() #0 .or. nHandle < 0
    Help(" ",1,"A210NOPEN")
    Return( Nil )
Endif

TXT := fReadStr( nHandle,256 )
nBytes := (At( CHR(13)+CHR(10),TXT )) + 1

aFile   := Directory( cArquivo )
nSize   := aFile[1,2]
nLinhas := Int(nSize/nBytes)

fSeek( nHandle,0,0 )


For nCount := 1 To nLinhas
    

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Lˆ cada linha do arquivo texto ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    TXT := fReadStr( nHandle,nBytes )

    If SUBSTR(TXT,1,10) = "S"
     
       aAdd(_aStru,{ALLTRIM(Substr(TXT,2,10)),substr(TXT,12,1),SUBSTR(TXT,13,3),SUBSTR(TXT,14,1),;
                    SUBSTR(TXT,15,4),SUBSTR(TXT,19,4),ALLTRIM(SUBSTR(TXT,23,160))})

       //_aStru[n,1] = CAMPO              01/10
       //_aStru[n,2] = TIPO               11/01
       //_aStru[n,3] = DECIMAL            12/01
       //_aStru[n,4] = CHAVE DE INDICE ?  13/01
       //_aStru[n,5] = POSICAO INICIAL    14/04
       //_aStru[n,6] = POSICAO final      18/04       
       //_aStru[n,7] = FORMULA            22/60
       
    Endif

Next nCount

fclose(nHandle)

Return

STATIC FUNCTION fAbreTab(cTabela)

Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando as Perguntas 									 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArquivo   := cTabela
private nLinhas

If ! File(cArquivo)
    Help(" ",1,"A210NOPEN")
	 Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo texto informado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := fOpen( cArquivo ,64)
If Ferror() #0 .or. nHandle < 0
    Help(" ",1,"A210NOPEN")
    Return( Nil )
Endif

TXT := fReadStr( nHandle,256 )
nBytes := (At( CHR(13)+CHR(10),TXT )) + 1

aFile   := Directory( cArquivo )
nSize   := aFile[1,2]
nLinhas := Int(nSize/nBytes)

fSeek( nHandle,0,0 )

ProcRegua(nLinhas)
For nCount := 1 To nLinhas
    
    IncProc("Carregando Tabela De-Para ")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Lˆ cada linha do arquivo texto ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    TXT := fReadStr( nHandle,nBytes )

    // TABELA,CODIGO DE,CODIGO PARA 
    aAdd(_aTab,{ALLTRIM(Substr(TXT,1,3)),ALLTRIM(substr(TXT,4,10)),ALLTRIM(substr(TXT,14,10))})

 
Next nCount

fclose(nHandle)

Return


Return


Static Function fChkArqTxt(nCnt)


Local nHandle
Local lret := .f.

If File(cArquivo)	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo texto informado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHandle := fOpen( cArquivo ,64)

	If Ferror() # 0 .or. nHandle < 0
	    Help(" ",1,"A210NOPEN")
	    Return( Nil )
	Endif

	TXT := fReadStr( nHandle,256 )
	nBytes := (At( CHR(13)+CHR(10),TXT )) + 1

	aFile   := Directory( cArquivo )
	nSize   := aFile[1,2]
	nLinhas := Int(nSize/nBytes)

	nCnt := nLinhas

	fClose(nHandle)

	lret := .T.    

EndIf
    
Return(lRet)

Static function fDepara(cTab,cTxt)

If ( nPosTab := Ascan(_aTab,{ |X| x[1] == cTab .and. x[2] == cTxt }) ) > 0
      cTxt := _aTab[nPosTab,3]
Else
   If cTab == "FIL"
      cTXT := "  "
   EndIf   
EndIf

Return(cTxt)      


/// Manutenção Arquivo Depara

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ManutCad  ³ Autor ³ Reginaldo             ³ Data ³ 09.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de (Manutencao Lay-out Conf. Arquivos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ImpDepara(cAlias,nReg,nOpcx)

Local oPesq,cPesq := Space(3)

nOpcAuto := 4

DEFINE MSDIALOG oDlg1 From 001,001 To 50,250 TITLE OEMTOANSI("Importação de Arquivos") pixel


@ 5.0,05 SAY OemToAnsi('TABELA') SIZE 100, 15 OF oDlg1 PIXEL 
@ 2.5,30 MSGET oPesq  VAR cPesq  SIZE 18,10 OF oDlg1 PIXEL PICTURE "@!"   Valid( lRet := !Empty(cPesq),oPesq:Refresh(),lRet)
@ 1.9,060 BUTTON "&Manutencao" SIZE 40,15 pixel ACTION ( lOk := .T., U_GeraTabDep(cPesq),oDlg1:end() )

ACTIVATE MSDIALOG oDlg1 CENTERED 

Return 

USer Function GeraTabDep(cPesq)

Private cTab_Dep := cPesq

Private aRotina := {{ "Alterar"	, "U_MANUTDEP"	, 0 , 4 },; //"Alterar"
						}
		
		aRotSetOpc( "SX2" , NIL , nOpcAuto , .F. )
		nPos := aScan( aRotina , { |x| x[4] == nOpcAuto } )
		IF ( nPos == 0 )
			Break
		EndIF
		dbSelectArea( "SX2" )
		bBlock	:= &( "{ |a,b,c,d,e,f,g| " + aRotina[ nPos , 2 ] + "(a,b,c,d,e,f,g) }" )
		uRet	:= Eval( bBlock , 'SX2' , SX2->( Recno() ) , nPos )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ManutCad  ³ Autor ³ Reginaldo             ³ Data ³ 09.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de (Manutencao Lay-out Conf. Arquivos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User  Function ManutDep(cAlias,nReg,nOpcx)

Local cSaveMenuh,nCnt,GetList:={}

Local aSaveArea := GetArea()        
Local aObjCoords	:= {}   
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}

altera := .t.
Private xAlias    := cAlias
Private aAC      := {"Abandona","Confirma"}
Private aColsRec := {}   //--Array que contem o Recno() dos registros da aCols
Private cArqDep :=	"ARQDEP.TXT"
While .T.

    nCnt := 0

    fChkArqDep(@nCnt) // verifica se existe arquivo texto com configuracao

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a entrada de dados do arquivo                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aTELA[0][0],aGETS[0],aHeader[0],Continua:=.F.,nUsado:=0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o cabecalho                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   ImpaHead(2) // Monta Cabecalho
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona ponteiro do arquivo cabeca e inicializa variaveis  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpcA := 0

   PRIVATE aCOLS[nCnt][nUsado+1]
	Private aTab_Dep := {}
	nCnt   :=0
	nUsado :=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerar o array aCols com os campos                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    GeraaCols(nOpcx,cArqDep,2)

   DbSelectArea(cAlias)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Monta as Dimensoes dos Objetos         					   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

aAdvSize		:= MsAdvSize()
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

	nOpca := 0
SetaPilha()
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Manutenção Tabela De-Para" ) FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL	//"Valores por Verba"

		@ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO ( aObjSize[1,3] - 3 ),( ( aObjSize[1,4]/100*20 - 2 ) ) LABEL OemToAnsi("Tabela") OF oDlg PIXEL		
		oGroup:oFont:= oFont

		@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( aObjSize[1,2] + 5 )				SAY OemToAnsi( cTab_Dep)	SIZE 050,10 OF oDlg PIXEL FONT oFont

   oGet := MSGetDados():New(32,0,301.5,634,nOpcx,"U_LINOKTAB","U_TUDOOKTAB","",If(nOpcx=4.Or.nOpcx=5,Nil,.T.),,1)

   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca:=If(nOpcx=5,2,1),If(oGet:TudoOk(),oDlg:End(),nOpca:=0)},{||oDlg:End()})
SetaPilha()
    //--Se nao for Exclusao
   IF nOpcA == Confirma .And. nOpcx # 5
       Begin Transaction
                //--Gravacao
                GravaTabDep()
       End Transaction
    Endif

	Exit

EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da janela                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RestArea(aSaveArea)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³                   ROTINAS DE CRITICA DE CAMPOS                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaTabDep³ Autor ³ Reginaldo           ³ Data ³ 06.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava no arquivo de Depara                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static  Function GravaTabDep()

Local ny:=0,nMaxArray:=Len(aHeader)

nHandle  := MSFCREATE(cArqDep)

If FERROR() # 0 .Or. nHandle < 0
	Help("",1,"GPM600HAND")
	FClose(nHandle)
	Return Nil
EndIf

For n := 1 To Len(aTab_dep)

		FWrite( nHandle,aTab_dep[n])

Next

For n:=1 TO Len(aCols)


    //--Verifica se Nao esta Deletado no aCols
    xConteudo := cTab_Dep
    If aCols[n,3] = .F.
	    For ny := 1 To nMaxArray
    	    xConteudo += aCols[n,ny]
	    Next ny
		FWrite( nHandle,xConteudo+chr(13)+chr(10))
    EndIf

Next n

FClose(nHandle)


Return

Static Function fChkArqDep(nCnt)


Local nHandle
Local lret := .f.

If File(cArqDep)	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo texto informado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHandle := fOpen( cArqDep ,64)

	If Ferror() # 0 .or. nHandle < 0
	    Help(" ",1,"A210NOPEN")
	    Return( Nil )
	Endif

	TXT := fReadStr( nHandle,256 )
	nBytes := (At( CHR(13)+CHR(10),TXT )) + 1

	aFile   := Directory( cArqDep )
	nSize   := aFile[1,2]
	nLinhas := Int(nSize/nBytes)
	fSeek( nHandle,0,0 )
	nCnt := 0
	
   For n := 1 To nLinhas
     		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	     	//³ Lˆ cada linha do arquivo texto ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    	TXT := fReadStr( nHandle,nBytes )
          If Substr(TXT,1,3) == cTab_Dep
              nCnt ++
          EndIf
   Next           

	fClose(nHandle)

	lret := .T.    
   If nCnt = 0
      nCnt := 1
   EndIf   
Else
   nCnt := 1
EndIf
    
Return(lRet)

User function LinOkTab

Return .t.

User Function TudoOkTab

Return .t.

Static Function fImprime()

Local cDesc1  := "Log de Importacao da ficha financeira"
Local cDesc2  := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := "SX1"                 // alias do arquivo principal (Base)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn := {"Zebrado", 1,"Administra‡„o", 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private NomeProg:= "IMPARQFF"
Private aLinha  := { },nLastKey := 0
Private Titulo
Private AT_PRG   := "GPEM001"
Private wCabec0  := 2
Private wCabec1  := " ANO/MES  VERBA                               PROVENTOS                      DESCONTOS                BASES "
Private wCabec2  := "                                         HORAS         VALOR            HORAS         VALOR                 "

Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"


cTit   := " Importacao Ficha Financeira"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="IMPARQFF"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,,cTit,cDesc1,cDesc2,cDesc3,.F.,,,nTamanho)
Titulo := " Log de Importacao da Ficha Financeira "

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| GR210Imp(@lEnd,wnRel,cString)},titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MGPEM001  ºAutor  ³Reginaldo           º Data ³  09/28/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. :   |Importacao de Tarefas do PR                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Calculo da Folha                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GR210Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Impr(" * Arquivo Importado: " + MV_PAR01)
Impr(" * Total de Registros Lidos:" + Str(nLinhas))
Impr(" * Total de Registros Gravados:" + Str(nTotGrav))
//If nLinhas <> nTotGrav
//  Impr(" * Gerado arquivo com Log dos Registros que nao foram Importados, verificar em: " + MV_PAR02) 
//EndIf
Impr("")

aSort(aTotais,,,{ |x,y| x[1]+x[2] < y[1]+y[2] } )
nHrsProv := nTotProv := nHrsDesc := nTotDesc := nBases := 0
For nLinLog := 1 to len(aTotais)
	
    Impr(aTotais[nLinLog,1]+"  "+aTotais[nLinLog,2]+"  " + PosSrv(aTotais[nLinlog,2],SRA->RA_FILIAL,"RV_DESC") + "  "+ Transform(aTotais[nLinLog,3],'@r 9,999,999.99')+"  " + Transform(aTotais[nLinLog,4],'@r 9,999,999.99')+"   "+Transform(aTotais[nLinLog,5],'@r 9,999,999.99');
       +"   "+Transform(aTotais[nLinLog,6],'@r 9,999,999.99') + "  " +Transform(aTotais[nLinLog,7],'@r 9,999,999.99'))
       nHrsProv += aTotais[nLinLog,3]
       nTotProv += aTotais[nLinLog,4]
       nHrsDesc += aTotais[nLinLog,5]
       nTotDesc += aTotais[nLinLog,6]
       nBases   += aTotais[nLinLog,7]
       
    If nLinLog + 1 <= Len(aTotais)
       If aTotais[nLinLog,1] <> aTotais[nLinLog+1,1]
            IMPR("")
		    Impr(Space(6)+"  "+Space(3)+"  " + Space(20) + "  "+ Transform(nHrsProv,'@r 9,999,999.99')+"  " + Transform(nTotProv,'@r 9,999,999.99')+"   "+Transform(nHrsDesc,'@r 9,999,999.99');
			       +"   "+Transform(nTotDesc,'@r 9,999,999.99') + "  " +Transform(nbases,'@r 999,999,999.99'))
		    nHrsProv := nTotProv := nHrsDesc := nTotDesc := nBases := 0
            Impr("","P")
       EndIf
    EndIf      
          
Next    

Impr("")
Impr(Space(6)+"  "+Space(3)+"  " + Space(20) + "  "+ Transform(nHrsProv,'@r 9,999,999.99')+"  " + Transform(nTotProv,'@r 9,999,999.99')+"   "+Transform(nHrsDesc,'@r 9,999,999.99');
	+"   "+Transform(nTotDesc,'@r 9,999,999.99') + "  " +Transform(nbases,'@r 999,999,999.99'))

Impr("")
Impr("")
Impr("Os dados acimas foram conferidos e validados pelo usuario: _____________________________________________")
Impr("                                                     data: _____/_____/_______")


Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()
    
Return


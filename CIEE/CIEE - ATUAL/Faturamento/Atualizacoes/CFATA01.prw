#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFATA01 º Autor ³ Daniel G.Jr.TI1239º Data ³  Abril/2013    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Tela de Alteração de dados do SC5                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFATA01()

Local oGet1, oGet2, oGet3, oGet4, oGet5, oGet6
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6
Local oButton1, oButton2
Local oDlg
Private cGet1 := SC5->C5_TRANSP
Private cGet2 := SC5->C5_MENNOTA
Private cGet3 := SC5->C5_ESPECI1
Private cGet4 := SC5->C5_VOLUME1
Private cGet5 := SC5->C5_PESOL
Private cGet6 := SC5->C5_PBRUTO
/*
TRANSPORTADORA - C5_TRANSP
MENSAGEM       - C5_MENNOTA
ESPECIE        - C5_ESPECI1
VOLUME         - C5_VOLUME1
PESO LIQUIDO   - C5_PESOL
PESO BRUTO     - C5_PBRUTO
*/

DEFINE MSDIALOG oDlg TITLE "ALTERA DADOS DO PV" FROM 000, 000  TO 280, 500 COLORS 0, 16777215 PIXEL

@ 010, 015 SAY oSay1 PROMPT "Transportadora: " 	SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 025, 015 SAY oSay3 PROMPT "Especie:" 			SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 040, 015 SAY oSay4 PROMPT "Volume:" 			SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 055, 015 SAY oSay5 PROMPT "Peso Liquido:" 	SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 070, 015 SAY oSay6 PROMPT "Peso Bruto:" 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 085, 015 SAY oSay2 PROMPT "Mens.p/Nota: " 	SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 009, 057 MSGET oGet1 VAR cGet1 SIZE 045, 009 F3 "SA4" OF oDlg COLORS 0, 16777215 PIXEL
@ 024, 057 MSGET oGet3 VAR cGet3 SIZE 045, 009 OF oDlg COLORS 0, 16777215 PIXEL
@ 039, 057 MSGET oGet4 VAR cGet4 SIZE 045, 009 OF oDlg COLORS 0, 16777215 PIXEL
@ 054, 057 MSGET oGet5 VAR cGet5 SIZE 045, 009 OF oDlg COLORS 0, 16777215 PIXEL
@ 069, 057 MSGET oGet6 VAR cGet6 SIZE 045, 009 OF oDlg COLORS 0, 16777215 PIXEL
@ 084, 057 MSGET oGet2 VAR cGet2 SIZE 190, 009 OF oDlg COLORS 0, 16777215 PIXEL
@ 110, 080 BUTTON oButton1 PROMPT "Confirma" 	SIZE 035, 010 OF oDlg PIXEL ACTION (GravaPV(), oDlg:End())
@ 110, 140 BUTTON oButton2 PROMPT "Cancela" 	SIZE 035, 010 OF oDlg PIXEL ACTION (oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function GravaPV()

RecLock("SC5",.F.)
SC5->C5_TRANSP 	:= cGet1 
SC5->C5_MENNOTA	:= cGet2 
SC5->C5_ESPECI1	:= cGet3 
SC5->C5_VOLUME1	:= cGet4
SC5->C5_PESOL	:= cGet5 
SC5->C5_PBRUTO	:= cGet6
SC5->(MsUnLock())

Return

#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRS02     º Autor ³ AP5 IDE            º Data ³  27/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importar dados para o BudGet 2004 das planilhas fornecidas º±±
±±º          ³ pelo Sr. Fausto   em Novembro/2003                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IMERYS BRASIL                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSUCRS01()
Local cArquivo := ''
Local aArea    := SM0->( GetArea() )
Local cTipo    := "Arquivos DBF (*.dbf)    | *.DBF |"

If !MsgYesNo( "Alterar dados do cadastro de funcionario? " )
	Return(nil)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTipo += "Todos os arquivos (*.*) | *.*    "
cArquivo := cGetFile( cTipo, OemtoAnsi("Importa arquivo" ),,)

If Len( cArquivo ) == 0
	Return( nil )
EndIf

Processa( {|lEnd| ImpPlaBu( cArquivo, @lEnd )},"Alterar dados do cadastro de funcionario? ", "", .t. )

RestArea( aArea )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ImpPla    º Autor ³ CRISTIAN           º Data ³  27/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Importar dados da planilha para o BudGet                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpPlaBu( cArquivo, lEnd )

Local xAlias   := Criatrab(.f.,.f.)
Local _cFilial := Space(02)
Local _cClVal  := Space(20)
Local _cUnNeg  := Space(09)
Local _CCusto  := Space(09)

SRA->(dbSetOrder(1))

dbUseArea( .t., 'DBFCDX', cArquivo, xAlias, .t., .f. )
dbSelectArea( xAlias )

ProcRegua( (xAlias)->( RecCount() ) )
(xAlias)->( dbGoTop() )

While (xAlias)->( !Eof() )
	IncProc("Atualizando cadastro funcionarios !!!! ")
	
	_cUpDate := " BEGIN TRAN "
	_cUpDate += "UPDATE "+RetSqlName("SRA")+Chr(13)
	_cUpDate += "SET RA_ITEMD = '"+(xAlias)->UNNEG+"', RA_CLVLDB = '"+(xAlias)->OPERA+"'"+Chr(13)
	_cUpDate += "WHERE RA_FILIAL = '"+(xAlias)->FILIAL+"'"+Chr(13)
	_cUpDate += "AND RA_CC = '"+(xAlias)->CCUSTO+"'"+Chr(13)
	_cUpDate += "AND ( RA_ITEMD = ' ' OR RA_CLVLDB = ' ')"+Chr(13)
	_cUpDate += "AND RA_SITFOLH = 'D'"+Chr(13)
	_cUpDate += "AND D_E_L_E_T_ <> '*'"+Chr(13)
	_cUpDate += " COMMIT TRAN"
	TCSQLExec(_cUpDate)
	
	(xAlias)->( dbSkip() )
EndDo

(xAlias)->( dbCloseArea() )


MsgAlert( "Finalizado ajuste da base de dados. Atualizado:" )


Return

#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMMRDE  บAutor  ณMicrosiga           บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rerversao do desmembramento da snotas fiscais de entrada   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RCOMMRDE()

Local nOpc       := 0
Local _cCadastro := "REVERSAO DO DESMEMBRAMENTO DE NOTAS"
Local _aSay      := {}
Local _aButton   := {}

Private _cPerg    := "RCOMMDES01"

Pergunte(_cPerg,.F.)

aAdd( _aSay, "Este programa tem como objetivo reverter o desmembramento das notas fiscais" )
aAdd( _aSay, "conforme o rateio lanวado para elas," )
aAdd( _aSay, "com vistas เ apura็ใo do PIS/COFINS." )

aAdd( _aButton, { 5,.T.,{|| Pergunte(_cPerg,.T.)}})
aAdd( _aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( _aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( _cCadastro, _aSay, _aButton )

If nOpc == 1
	Processa( {|| ProcRDes() }, _cCadastro, "Processando..." )
Endif

Return                 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcRDes  บAutor  ณMicrosiga           บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da reversao do desmembramento                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCOMMRDE                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcRDes()

Local _cQuery  := ""
Local nTotRegs := 0


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSelecao dos registros conforme parametros informados.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery := "SELECT * FROM " + RetSqlName("SZW") + " SZW, " + RetSqlName("SF1") + " SF1, "
_cQuery += "(SELECT DISTINCT EZ_NOTA FROM SEZ050 SEZ WHERE SEZ.D_E_L_E_T_ = '') SEZ WHERE "
_cQuery += "SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND "
_cQuery += "SF1.F1_DOC = SZW.ZW_DOC AND "
_cQuery += "SF1.F1_SERIE = SZW.ZW_SERIE AND "
_cQuery += "SF1.F1_FORNECE = SZW.ZW_FORNECE AND "
_cQuery += "SF1.F1_LOJA = SZW.ZW_LOJA AND "
_cQuery += "SF1.D_E_L_E_T_ = ' ' AND "
_cQuery += "SF1.F1_XDESMEM = 'X' AND "
_cQuery += "(SF1.F1_XTABRAT = '1' OR "
_cQuery += "SZW.ZW_DOC+SZW.ZW_SERIE+SZW.ZW_FORNECE+SZW.ZW_LOJA = SEZ.EZ_NOTA) AND "
_cQuery += "SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND "
_cQuery += "SZW.ZW_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' AND "
_cQuery += "SZW.D_E_L_E_T_ = ' '"

U_MontaView( _cQuery, "SZWTMP" )
SZWTMP->(dbGoTop())
SZWTMP->( dbEval( { || nTotRegs++ },,{ || !Eof() } ) )
SZWTMP->(dbGoTop())

If SZWTMP->(EOF())
	Aviso("Aten็ใo!!!","Nใo hแ registros para esta sele็ใo.",{"Ok"},1,"Reversใo do Desmembramento")
	SZWTMP->(dbCloseArea())
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeletar fisicamente os itens da Nota Fiscal demembradaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
U_DES002("X")      

dbSelectArea("SD1")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGravar o SD1 original a partir da tabela SZWณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua(nTotRegs)
While !SZWTMP->(Eof())
	RecLock("SD1",.T.)
		For nx:=1 to SZW->(FCount())
			FieldPut(nx,SZWTMP->&("ZW"+( Subs(FieldName(nX),3,8) )))
		Next
	MsUnlock()
	SZWTMP->(dbSkip())
EndDo
SZWTMP->(dbCloseArea())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeletar fisicamente a copia no SZW       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery := "DELETE " + RetSqlName("SZW") + " FROM " + RetSqlName("SZW") + " SZW, " + RetSqlName("SF1") + " SF1, "
_cQuery += "(SELECT DISTINCT EZ_NOTA FROM SEZ050 SEZ WHERE SEZ.D_E_L_E_T_ = '') SEZ WHERE "
_cQuery += "SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND "
_cQuery += "SF1.F1_DOC = SZW.ZW_DOC AND "
_cQuery += "SF1.F1_SERIE = SZW.ZW_SERIE AND "
_cQuery += "SF1.F1_FORNECE = SZW.ZW_FORNECE AND "
_cQuery += "SF1.F1_LOJA = SZW.ZW_LOJA AND "
_cQuery += "SF1.D_E_L_E_T_ = ' ' AND "
_cQuery += "SF1.F1_XDESMEM = 'X' AND "
_cQuery += "(SF1.F1_XTABRAT = '1' OR "
_cQuery += "SZW.ZW_DOC+SZW.ZW_SERIE+SZW.ZW_FORNECE+SZW.ZW_LOJA = SEZ.EZ_NOTA) AND "
_cQuery += "SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND "
_cQuery += "SZW.ZW_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' AND "
_cQuery += "SZW.D_E_L_E_T_ = ' '"

TcSqlExec( _cQuery )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDesmarcar Flag de Desmembramento no SF1        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery := "UPDATE " + RetSqlName('SF1')+ " SET F1_XDESMEM = ' ' WHERE "
_cQuery += "F1_FILIAL = '" + xFilial("SF1") + "' AND "
_cQuery += "F1_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' AND "
_cQuery += "F1_XDESMEM = 'X' AND "
_cQuery += "D_E_L_E_T_ = ''"

TcSqlExec(_cQuery)

Return
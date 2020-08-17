#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMMDES  บAutor  ณMicrosiga           บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDESMEMBRAMENTO DE NOTAS FISCAIS DE ENTRADA POR UN.NEGOCIO   บฑฑ
ฑฑบ          ณCONFORME OS RATEIOS EFETUADOS.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RCOMMDES()

Local nOpc       := 0
Local _cCadastro := "DESMEMBRAMENTO DE NOTAS"
Local _aSay      := {}
Local _aButton   := {}

Private _cPerg    := "RCOMMDES01"

CriaPerg()
Pergunte(_cPerg,.F.)
//Parametros de perguntas
//+-------------------------------------------------------+
//| mv_par01 - Emissao de      ? 99/99/99                 |
//| mv_par02 - Emissao ate     ? 99/99/99                 |
//+-------------------------------------------------------+

aAdd( _aSay, "Este programa tem como objetivo desmembrar as notas fiscais" )
aAdd( _aSay, "conforme o rateio lanวado para elas," )
aAdd( _aSay, "com vistas เ apura็ใo do PIS/COFINS." )

aAdd( _aButton, { 5,.T.,{|| Pergunte(_cPerg,.T.)}})
aAdd( _aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( _aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( _cCadastro, _aSay, _aButton )

If nOpc == 1
	Processa( {|| ProcDes() }, _cCadastro, "Processando..." )
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcDes   บAutor  ณMicrosiga           บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da rotina                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCOMMDES                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcDes()

Local cAnoMes := ""
Local cUltRev := ""
Local _aUnNeg := {}                           
Local _aNota  := {}
Local _cQuery  := ""
Local nTotRegs := 0             

Private _aFields := {}


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAgrupamento por Un. Negocio do rateio montado pela ZB8 (Novo) ou SEZ (Antigo).ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery := "SELECT F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_EMISSAO,F1_XTABRAT FROM " + RetSqlName("SF1") + " SF1, " + RetSqlName("SEZ") + " SEZ WHERE "
_cQuery += "SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND "
_cQuery += "SF1.F1_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' AND "
_cQuery += "SF1.D_E_L_E_T_ = ' ' AND "
_cQuery += "(SF1.F1_DOC+SF1.F1_SERIE+SF1.F1_FORNECE+SF1.F1_LOJA = SEZ.EZ_NOTA OR "
_cQuery += "SF1.F1_XTABRAT = '1') AND "
_cQuery += "SF1.F1_XDESMEM = ' ' "
_cQuery += "GROUP BY F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_EMISSAO,F1_XTABRAT "
_cQuery += "ORDER BY F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA"

U_MontaView( _cQuery, "SF1TMP" )
SF1TMP->(dbGoTop())
SF1TMP->( dbEval( { || nTotRegs++ },,{ || !Eof() } ) )
SF1TMP->(dbGoTop())

If SF1TMP->(EOF())
	Aviso("Aten็ใo!!!","Nใo hแ registros para esta sele็ใo.",{"Ok"},1,"Desmembramento de Notas")
	SF1TMP->(dbCloseArea())
	Return
EndIf

Begin Transaction

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCopia o SD1 para o SZWณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DES001()

ProcRegua(nTotRegs)
While !SF1TMP->(EOF())
	IncProc("Selecionando notas com os seus rateios")
	
	If SF1TMP->F1_XTABRAT == "1"
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณForma de rateio com base na tabela ZB8ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SEV")
		dbSetOrder(3) //EV_FILIAL+EV_NOTA
		If dbSeek(xFilial("SEV") + SF1TMP->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
			cAnoMes	:= SUBSTR(SF1TMP->F1_EMISSAO,1,6)
			cUltRev	:= U_RZB7ULTR(SEV->EV_XCODRAT,cAnoMes,.T.)
	        
			_cQuery := "SELECT DISTINCT ZB8_ITDBTO, SUM(ZB8_PERCEN) PERC FROM " + RetSqlName("ZB8") + " ZB8 WHERE "
			_cQuery += "ZB8.ZB8_FILIAL = '" + xFilial("ZB8") + "' AND "
			_cQuery += "ZB8.ZB8_CODRAT = '" + SEV->EV_XCODRAT + "' AND "
			_cQuery += "ZB8.ZB8_ANOMES = '" + cAnoMes + "' AND "
			_cQuery += "ZB8.ZB8_REVISA = '" + cUltRev + "' AND "
			_cQuery += "ZB8.D_E_L_E_T_ = ' ' "
			_cQuery += "GROUP BY ZB8.ZB8_ITDBTO"		
			
			U_MontaView( _cQuery, "ZB8UN" )
			ZB8UN->(dbGoTop())
	
			While !ZB8UN->(EOF())
				aAdd(_aUnNeg,{ZB8UN->ZB8_ITDBTO,ZB8UN->PERC})
				ZB8UN->(dbSkip())
			EndDo
			ZB8UN->(dbCloseArea())
			aAdd(_aNota,{SEV->EV_NOTA,_aUnNeg})
		EndIf
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณForma de rateio com base na tabela SEZณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cQuery := "SELECT DISTINCT EZ_ITEMCTA, ROUND(SUM(EZ_PERC),2) PERC FROM " + RetSqlName("SEZ") + " SEZ WHERE "
		_cQuery += "SEZ.EZ_FILIAL = '" + xFilial("SEZ") + "' AND "
		_cQuery += "SEZ.EZ_NOTA = '" + SF1TMP->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) + "' AND "
		_cQuery += "SEZ.D_E_L_E_T_ = ' ' "
		_cQuery += "GROUP BY SEZ.EZ_ITEMCTA"
		
		U_MontaView( _cQuery, "EZ" )
		EZ->(dbGoTop())
	
		While !EZ->(EOF())
			aAdd(_aUnNeg,{EZ->EZ_ITEMCTA,EZ->PERC})
			EZ->(dbSkip())
		EndDo
		EZ->(dbCloseArea())
		aAdd(_aNota,{SF1TMP->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),_aUnNeg})
	EndIf
	_aUnNeg := {}
	SF1TMP->(dbSkip())
EndDo
SF1TMP->(dbCloseArea())

ProcRegua(Len(_aNota))
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeleta fisicamente os itens da nota (SD1)                      ณ
//ณA delecao tem que ser fisica pois como a inclusao eh realizada ณ
//ณatraves de um 'Imput' direto na tabela nao ha a possibilidade  ณ
//ณde haver dois registros com o mesmo X2_UNIQ, mesmo que         ณ
//ณum deles esteja deletado logicamente.                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
U_DES002(" ")
		
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera os campos da SD1 com base no SX3.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
GrFields("SD1")
		
For nX := 1 to Len(_aNota)
	IncProc("Desmembrando...")
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEfetua a gravacao dos novos itens da nota com base no rateioณ
	//ณconforme tabela ZB8.                                        ณ
	//ณOs itens sao gravados na SD1 agrupando-se por Un. Negocio   ณ
	//ณque eh o nivel em que devem conter as diferenciacoes do TES ณ
	//ณcumulativo ou nao cumulativo.                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DES003(Left(_aNota[nX,1],9),Substr(_aNota[nX,1],10,3),Substr(_aNota[nX,1],13,6),Right(_aNota[nX,1],2),_aNota[nX,2])
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMarca Flag de Desmembramentoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQuery := "UPDATE " + RetSqlName('SF1')+ " SET F1_XDESMEM = 'X' WHERE "
	_cQuery += "F1_FILIAL = '" + xFilial("SF1") + "' AND "
	_cQuery += "F1_DOC = '" + Left(_aNota[nX,1],9) + "' AND "
	_cQuery += "F1_SERIE = '" + Substr(_aNota[nX,1],10,3) + "' AND "
	_cQuery += "F1_FORNECE = '" + Substr(_aNota[nX,1],13,6) + "' AND "
	_cQuery += "F1_LOJA = '" + Right(_aNota[nX,1],2) + "' AND "
	_cQuery += "D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
Next nX

End Transaction

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDES001    บAutor  ณMicrosiga           บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava os itens da SD1 na tabela SZW para posteior          บฑฑ
ฑฑบ          ณ visualizacao ou reversao do desmembramento                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ProcDes                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DES001()

Local _cQuery := ""

_cQuery := "SELECT * FROM " + RetSqlName("SD1") + " SD1, " + RetSqlName("SF1") + " SF1, "
_cQuery += "(SELECT DISTINCT EZ_NOTA FROM SEZ050 SEZ WHERE SEZ.D_E_L_E_T_ = '') SEZ WHERE "
_cQuery += "SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND "
_cQuery += "SF1.F1_DOC = SD1.D1_DOC AND "
_cQuery += "SF1.F1_SERIE = SD1.D1_SERIE AND "
_cQuery += "SF1.F1_FORNECE = SD1.D1_FORNECE AND "
_cQuery += "SF1.F1_LOJA = SD1.D1_LOJA AND "
_cQuery += "SF1.D_E_L_E_T_ = ' ' AND "
_cQuery += "SF1.F1_XDESMEM = ' ' AND "
_cQuery += "(SF1.F1_XTABRAT = '1' OR "
_cQuery += "SD1.D1_DOC+SD1.D1_SERIE+SD1.D1_FORNECE+SD1.D1_LOJA = SEZ.EZ_NOTA) AND "
_cQuery += "SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
_cQuery += "SD1.D1_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' AND "
_cQuery += "SD1.D_E_L_E_T_ = ' '"

U_MontaView( _cQuery, "SD1TMP" )
SD1TMP->(dbGoTop())

dbSelectArea("SZW")
While !SD1TMP->(Eof())
	RecLock("SZW",.T.)
		For nx:=1 to SZW->(FCount())
			FieldPut(nx,SD1TMP->&("D1"+( Subs(FieldName(nX),3,8) )))
		Next
	MsUnlock()
	SD1TMP->(dbSkip())
EndDo
SD1TMP->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDES002    บAutor  ณMicrosiga           บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa a delecao fisica dos itens da nota                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ProcDes                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DES002(_cFlag)

Local _cQuery := ""

_cQuery := "DELETE " + RetSqlName("SD1") + " FROM "+ RetSqlName("SD1") + " SD1, " + RetSqlName("SF1") + " SF1, "
_cQuery += "(SELECT DISTINCT EZ_NOTA FROM SEZ050 SEZ WHERE SEZ.D_E_L_E_T_ = '') SEZ WHERE "
_cQuery += "SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND "
_cQuery += "SF1.F1_DOC = SD1.D1_DOC AND "
_cQuery += "SF1.F1_SERIE = SD1.D1_SERIE AND "
_cQuery += "SF1.F1_FORNECE = SD1.D1_FORNECE AND "
_cQuery += "SF1.F1_LOJA = SD1.D1_LOJA AND "
_cQuery += "SF1.D_E_L_E_T_ = ' ' AND "
_cQuery += "SF1.F1_XDESMEM = '" + _cFlag + "' AND "
_cQuery += "(SF1.F1_XTABRAT = '1' OR "
_cQuery += "SD1.D1_DOC+SD1.D1_SERIE+SD1.D1_FORNECE+SD1.D1_LOJA = SEZ.EZ_NOTA) AND "
_cQuery += "SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
_cQuery += "SD1.D1_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' AND "
_cQuery += "SD1.D_E_L_E_T_ = ' '"

TcSqlExec( _cQuery )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDES003    บAutor  ณMicrosiga           บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao dos novos itens da nota fiscal                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ProcDes                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DES003(_cNota,_cSerie,_cFornec,_cLoja,_aUnNeg)

Local _cQuery     := ""
Local _cItem      := Replicate("0",TamSx3("D1_ITEM")[1]) 
Local _nVar       := 0
Local _cOperCum   := GetMv("MV_XOPRCUM")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณO vetor _aCampos contem os campos que terao o conteudo          ณ
//ณsubstituido conforme o percentual apurado no array _aNota[x][2].ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aCampos    := {	"D1_QUANT","D1_TOTAL","D1_VALIPI","D1_VALICM","D1_CUSTO","D1_QTSEGUM","D1_ICMSRET","D1_BRICMS","D1_VALDESC","D1_BASEIPI",;
						"D1_BASIMP1","D1_BASIMP2","D1_BASIMP3","D1_BASIMP4","D1_BASIMP5","D1_BASIMP6","D1_VALIMP1","D1_VALIMP2","D1_VALIMP3",;
						"D1_VALIMP4","D1_VALIMP5","D1_VALIMP6","D1_BASEICM","D1_ICMSCOM","D1_BASEIRR","D1_VALIRR","D1_BASEISS","D1_VALISS",;
						"D1_BASEINS","D1_VALINS","D1_DESCICM","D1_BASEPS3","D1_VALPS3","D1_BASECF3","D1_VALCF3","D1_ABATISS","D1_ABATMAT",;
						"D1_ICMSDIF","D1_ABATINS" }


_cQuery := "SELECT * FROM " + RetSqlName("SZW") + " SZW WHERE "
_cQuery += "SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND "
_cQuery += "SZW.ZW_DOC = '" + _cNota + "' AND "
_cQuery += "SZW.ZW_SERIE = '" + _cSerie + "' AND "
_cQuery += "SZW.ZW_FORNECE = '" + _cFornec + "' AND "
_cQuery += "SZW.ZW_LOJA = '" + _cLoja + "' AND "
_cQuery += "SZW.D_E_L_E_T_ = ' ' "
_cQuery += "ORDER BY ZW_ITEM"


U_MontaView( _cQuery, "SZWTMP" )
SZWTMP->(dbGoTop())

While !SZWTMP->(EOF())
	For nW := 1 to Len(_aUnNeg)
		For nY:= 1 to Len(_aFields)
			If nY == 1
				cCpoOri := _aFields[nY]
				cCpoDes := "'" + &("ZW_"+Substr(_aFields[nY],4,7)) + "'"
			Else
				cCpoOri := cCpoOri + "," + _aFields[nY]
				If _aFields[nY] == "D1_ITEM"
					_cItem  := Soma1(_cItem)
					cCpoDes := cCpoDes + "," + "'" + _cItem + "'"
				ElseIf _aFields[nY] == "D1_NATFULL"
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณVerifica a TES correta conforme campos da Naturezaณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					_cTesNaoCum := Posicione("SED",1,xFilial("SED")+ZW_NATFULL,"ED_XTESNC")
					_cTesCum    := Posicione("SED",1,xFilial("SED")+ZW_NATFULL,"ED_XTESC")
					If !Empty(_cTesNaoCum) .And. !Empty(_cTesCum)
						If Left(_aUnNeg[nW,1],2) $ _cOperCum
							_cTes := _cTesCum
						Else
							_cTes := _cTesNaoCum
						EndIf
					Else
						_cTes := ZW_TES
					EndIf
					cCpoDes := cCpoDes + "," + "'" + ZW_NATFULL + "'"
				ElseIf _aFields[nY] == "D1_TES"
					cCpoDes := cCpoDes + "," + "'" + _cTes + "'"
				ElseIf aScan(_aCampos,{|x| x == Alltrim(_aFields[nY])}) > 0
					_nVar := &("ZW_" + Substr(_aFields[nY],4,7)) * (_aUnNeg[nW,2]/100)
					cCpoDes := cCpoDes + "," + AllTrim(Str(_nVar))
				Else
					If ValType(&("ZW_"+Substr(_aFields[nY],4,7))) == "N"
						cCpoDes := cCpoDes + "," + AllTrim(Str(&("ZW_"+Substr(_aFields[nY],4,7))))
					Else
						cCpoDes := cCpoDes + "," + "'" + &("ZW_"+Substr(_aFields[nY],4,7)) + "'"
					EndIf
				EndIf
			EndIf
		Next nY	
		cCpoOri := cCpoOri + "," + "R_E_C_N_O_"
		cCpoDes := cCpoDes + "," + "(select max(R_E_C_N_O_)+1 from " + RetSqlName("SD1") +")"

		_cQuery := "INSERT INTO "+RetSQLName("SD1")+" "
		_cQuery += "("+ cCpoOri +") "
		_cQuery += "VALUES "
		_cQuery += "("+ cCpoDes+ ") "
		
		TCSqlExec(_cQuery)
	Next nW	
	SZWTMP->(dbSkip())
EndDo
SZWTMP->(dbCloseArea())

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrFields  บAutor  ณMicrosiga           บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera os campos da SD1 conforme dicionario SX3.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ProcDes                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrFields(cAlias)

_aFields := {}
dbSelectArea("SX3")
dbSetOrder(1)
If dbSeek(cAlias, .F.)
	Do While !Eof() .And. SX3->X3_ARQUIVO == cAlias
		If X3_CONTEXT <> "V" 
			aAdd(_aFields,AllTrim(SX3->X3_CAMPO))
		EndIf
		dbSkip()
	EndDo
EndIf

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIAPERG บ Autor ณ Microsiga          บ Data ณ  Abr/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria SX1                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCOMMDES                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
aAdd(aRegs,{_cPerg,"01","Emissao de    ?","","","mv_ch1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"02","Emissao ate   ?","","","mv_ch2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
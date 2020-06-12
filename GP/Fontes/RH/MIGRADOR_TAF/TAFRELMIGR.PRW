#INCLUDE "TOTVS.CH"
#INCLUDE "REPORT.CH"

/*/{Protheus.doc} TafRelMig
Relatório de Erros de Inconsistências no processo de
Migração.
@type  Static Function
@author Diego Santos
@since 25-10-2018
@version 1.0
@param param, param_type, param_descr
@return return, return_type, return_description
/*/
Function TafRelMigr( oPanel, aErros )

Local oReport
Local lProcessa := .T.

If !TRepInUse()
    Alert("A impressão em TREPORT deverá estar habilitada. Favor verificar o parâmetro MV_TREPORT.")
    lProcessa := .F.
EndIf

If lProcessa
    oReport:=ReportDef( aErros )
    oReport:PrintDialog()
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportDef
Instacia a classe TReport e monta a section 

@author Diego Santos
@since 19/08/2018/
@version 1.0 

@aParam

@return Nil
/*/
//-------------------------------------------------------------------

Static Function ReportDef( aErros )

Local oReport   

oReport 	:= TReport():New("TAFRELMIGR", "Relatório de inconsistências de migração TAF", "TAFRELMIGR", {|oReport| PrintReport(@oReport, aErros)},"Inconsistências de Migração TAF",.T.,,,,,,,,,.T.)
oSection    := TRSection():New(oReport,"Relatório de inconsistências de migração",{""},{""})
    
oReport:SetDevice(4) //Impressão em Tabela Excel

TRCell():New(oSection,"FILREG"   ,	"", "Filial do Registro", /*Picture*/,TamSx3("V2I_FILREG")[1]   ,	/*lPixel*/, { || cFilReg        }  ) // -> Filial do Registro
TRCell():New(oSection,"EVENTO"   ,	"", "Evento E-Social"   , /*Picture*/,006                       ,	/*lPixel*/, { || cEvento        }  ) // -> Código do Evento
TRCell():New(oSection,"CHAVE"    ,	"", "Chave TAF x TSS"   , /*Picture*/,055                       ,	/*lPixel*/, { || cChave         }  ) // -> Evento
TRCell():New(oSection,"CODERR"   ,	"", "Código do Erro"    , /*Picture*/,006                       ,	/*lPixel*/, { || cCodErr        }  ) // -> Código do Erro
TRCell():New(oSection,"DESCERR"  ,	"", "Descrição do Erro" , /*Picture*/,255                       ,	/*lPixel*/, { || cDescErr       }  ) // -> Descrição do Erro
TRCell():New(oSection,"TABTAF"   ,	"", "Tabela TAF"        , /*Picture*/,003                       ,	/*lPixel*/, { || cTabTAF        }  ) // -> Tabela TAF

Return oReport

//-------------------------------------------------------------------
/*/{Protheus.doc} PrintReport
Rotina para realizar a impressao do relatório.

@author Diego Santos
@since 19/08/2018/
@version 1.0 

@aParam

@return Nil
/*/
//-------------------------------------------------------------------

Static Function PrintReport( oReport, aErros )

Local cQry      := ""
Local cAlsQry   := GetNextAlias()
Local aArea     := GetArea()

Local nY

cQry += "SELECT V2I.R_E_C_N_O_ AS RECV2I "
cQry += "FROM " + RetSqlName("V2I") + " V2I "
cQry += "WHERE "
cQry += "V2I.V2I_FILIAL		= '"+ xFilial('V2I') + "' AND "
cQry += "V2I.V2I_CODERR		<> ' ' AND "
cQry += "V2I.D_E_L_E_T_     =  ' ' "
cQry += "ORDER BY V2I.V2I_FILIAL, V2I.V2I_FILREG, V2I.V2I_EVENTO, V2I.V2I_ID, V2I.V2I_VERSAO "

oReport:SetTitle("Inconsistências de Migração")

oReport:Section(1):SetHeaderSection(.T.)

DBUseArea(.T.,"TopConn",TCGenQry(,,cQry),cAlsQry)

oReport:SetMeter((cAlsQry)->(RecCount()) + Len(aErros))

oReport:Section(1):Init()
oReport:IncMeter()

oReport:SkipLine()


For nY := 1 To Len(aErros)

    cFilReg     := aErros[nY][1]
    cEvento     := aErros[nY][2]
    cChave      := aErros[nY][3]
    cCodErr     := aErros[nY][4]
    cDescErr    := aErros[nY][5]
    cTabTAF     := aErros[nY][6]

Next nY

While (cAlsQry)->(!Eof())

    V2I->(DbGoTo( (cAlsQry)->RECV2I ) )
    
    cFilReg     := V2I->V2I_FILREG
    cEvento     := V2I->V2I_EVENTO
    cChave      := AllTrim(StrTran(V2I->V2I_EVENTO, "-", "")) + AllTrim(V2I->V2I_ID) + AllTrim(V2I->V2I_VERSAO)
    cCodErr     := V2I->V2I_CODERR
    cDescErr    := V2I->V2I_OBS
    cTabTAF     := V2I->V2I_TABTAF

    oReport:Section(1):PrintLine()

    (cAlsQry)->(DbSkip())

End

(cAlsQry)->(DbCloseArea())

RestArea(aArea)

Return
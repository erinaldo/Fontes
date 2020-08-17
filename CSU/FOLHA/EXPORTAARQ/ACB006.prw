User Function ACB006()
Local cSql

// salvar os planos anteriores
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_ASMANT = RA_ASMEDIC "
cSql += " WHERE D_E_L_E_T_ = ' ' "
TCSqlExec( cSql )


Return nil
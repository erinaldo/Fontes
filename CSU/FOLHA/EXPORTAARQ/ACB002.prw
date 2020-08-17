User Function ACB002()
Local cSql

// replace no RA_MEDMAT com ' '
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_MEDMAT = ' ' "
TCSqlExec( cSql )

// salvar os planos anteriores
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_ASMANT = RA_ASMEDIC "
cSql += " WHERE D_E_L_E_T_ = ' ' "
TCSqlExec( cSql )

// Trocar o plano 01 por 27
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_ASMEDIC = '27' "
cSql += " WHERE RA_ASMEDIC = '01' "
cSql += " AND D_E_L_E_T_ = ' ' "
TCSqlExec( cSql )

// Trocar o plano 02 por 28
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_ASMEDIC = '28' "
cSql += " WHERE RA_ASMEDIC = '02' "
cSql += " AND D_E_L_E_T_ = ' ' "
TCSqlExec( cSql )

// Trocar o plano 03 por 29
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_ASMEDIC = '29' "
cSql += " WHERE RA_ASMEDIC = '03' "
cSql += " AND D_E_L_E_T_ = ' ' "
TCSqlExec( cSql )

// Trocar o plano 22 por 30
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_ASMEDIC = '30' "
cSql += " WHERE RA_ASMEDIC = '22' "
cSql += " AND D_E_L_E_T_ = ' ' "
TCSqlExec( cSql )

// Trocar o plano 23 por 31
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_ASMEDIC = '31' "
cSql += " WHERE RA_ASMEDIC = '23' "
cSql += " AND D_E_L_E_T_ = ' ' "
TCSqlExec( cSql )

// Trocar o plano 24 por 32
cSql := "UPDATE " + RetSqlName("SRA") + " SET "
cSql += " RA_ASMEDIC = '32' "
cSql += " WHERE RA_ASMEDIC = '24' "
cSql += " AND D_E_L_E_T_ = ' ' "
TCSqlExec( cSql )

Return nil
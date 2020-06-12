#Include 'Protheus.ch'

User Function CTA030TOK()

Local lRet	:= .T.

lRet := U_CCTBE04() //Chamada para inclusão automatica do SETOR - Entidade 05

Return(lRet)


User Function CSUHISTBX()

// ExecBlock CSUHISTBX
// Data: OUT./2004  - SEA
// Objetivo: Gerar o historico para gravação no campo de origem do lançamento contabil, 
// de onde vem a informação de qual area de negocio pertence o lançamento (CT2->CT2_ORIGEM)
// Ponto de Disparo: Lançamento Padrão 530/531/532  
// Cliente: CSU

_cArea	:= Alias()
_HistBX := " "
_LPSEQ	:= " "
_CodArea:= " "

_LPSEQ	:= CT5->CT5_SEQUEN
_LPLAN	:= CT5->CT5_LANPAD

IF U_CSUVLRCR()
//IF SE2->E2_MULTNAT == "1"
	sez->(dbsetorder(1)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
	seZ->(dbseek(xfilial()+se2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),.f.))
	_CodArea:=SEZ->EZ_EMPR
	_HistBX := _LPLAN+"-"+_LPSEQ+" FIN "+CHR(1)+_cPublEmpC
ELSE
   _HistBX := _LPLAN+"-"+_LPSEQ+" FIN "+CHR(1)

   if empty(se2->e2_csukey)
      _HistBX += SE2->E2_CODAREA
   else
      _vAmbSe2:=se2->(getarea())
      se2->(dbsetorder(1))
      se2->(dbseek(rtrim(e2_csukey),.f.))
      _HistBX+=SE2->E2_CODAREA
      se2->(restarea(_vAmbSe2))
   endif   
endif

DbSelectArea(_cArea)

Return _HistBX

*---------------------------------------------------------------------
User Function E2CodArea()
*---------------------------------------------------------------------
local _cCodArea:=se2->e2_codarea,_vAmbSe2

if !empty(se2->e2_csukey)
   _vAmbSe2:=se2->(getarea())
   se2->(dbsetorder(1))
   se2->(dbseek(rtrim(e2_csukey),.f.))
   _cCodArea:=SE2->E2_CODAREA
   se2->(restarea(_vAmbSe2))
endif

Return _cCodArea
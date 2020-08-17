User Function CSUVLRCR()

// ExecBlock CSUVLRCT5
// Data: OUT./2004  - SEA
// Objetivo: Checar se o titulo a ser contabilizado foi rateado ou não
// Ponto de Disparo: Lançamento Padrão 530/531/532  
// Cliente: CSU
// IF(SE2->E2_MULTNAT=="1",u_fRatBaixa(se2->E2_VALLIQ,'530'),0)

local _lReturn:=.f.,_vAmbSe2

//ALERT("OPA")

if se2->e2_multnat=="1"
   _lReturn:=.t.
else
   if !empty(se2->e2_csukey)
      _vAmbSe2:=se2->(getarea())
      if se2->(dbseek(e2_csukey,.f.).and.e2_multnat=="1")
         _lReturn:=.t.
      endif
      se2->(restarea(_vAmbSe2))
   endif
endif         
         
Return _lReturn
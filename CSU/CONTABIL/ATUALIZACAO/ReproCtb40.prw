#include "rwmake.ch"
#include "tbiconn.ch"

*---------------------------------------------------------------------------------------------------------------
User Function CsCtbM40(_cOperP)
* Controle dos parametros para a reprocessamento automatica
* Ricardo Luiz da Rocha - Dts Consulting - 28/02/2005 GNSJC
*---------------------------------------------------------------------------------------------------------------
private _cPergDiu:=PADR("CTBM4D",LEN(SX1->X1_GRUPO)),;
        _cPergNot:=PADR("CTBM4N",LEN(SX1->X1_GRUPO)),;
        _cLogUsu:="CsCtbm40.Lo1",;
        _cLogAdm:="CsCtbm40.Lo2",;
        _cAmbiente:="PRODUCAO",;
        _dDatDIni,_dDatDFim,_cHoraD,_cStatusD,;
        _dDatNIni,_dDatNFim,_cHoraN,_cStatusN,;
        _cQuebral:=chr(13)+chr(10),;
        _cOper:=_cOperP

//memowrit("csctbm07.lo3",memoread("csctbm07.lo3")+" Valtype('cUsuario') = "+valtype('cUsuario')+_cQuebral)

if valtype(_cOper)=="A"
   _cOper:=_cOper[1]
   if type('cUsuario')=="U"
      cUsuario:="      WorkFlow"
   endif
endif   

if _cOper<>nil

   _cOper:=lower(alltrim(_cOper))
   _lContinua:=.t.

      // Reprocessamento de saldo empresa 02
      PREPARE ENVIRONMENT EMPRESA "04" FILIAL "01"    
      _fAtuLog("Usu","Colhendo parametros para a reprocessamento - "+_cOper)
      pergunte(if(_cOper=="diurno",_cPergDiu,_cPergNot),.f.)
      if mv_par04<>1 // inativo
         _fAtuLog("Usu","A rotina nao esta ativa - "+_cOper)
         _fAtuLog("Adm","A rotina nao esta ativa - "+_cOper)
         return
      endif   
      sx1->(dbsetorder(1))

      if sx1->(Dbseek("CTB190"+"02",.f.).and.Reclock(alias(),.F.))
         SX1->X1_CNT01:="'"+dtoc(mv_par01)+"'"
		 sx1->(MsUnlock())
	     if sx1->(Dbseek("CTB190"+"03",.f.).and.Reclock(alias(),.F.))

            SX1->X1_CNT01:="'"+dtoc(mv_par02)+"'"
            sx1->(MsUnlock())
            dbselectarea("SM0")
            set filter to m0_codigo $ "04"
            SetHideInd(.T.)
            _fAtuLog("Usu","Iniciando a reprcessamento - "+_cOper)
            ctba190(.t.)
            _fAtuLog("Usu","Reprocessamento  concluida" +_cEmpresa+" - "+_cOper)
      
       endif
   endif
   return
Endif

if sm0->m0_codigo<>"04"

   msgbox("Esta rotina apenas podera ser executada da empresa 04 (TeleSystem/Matriz)")
   return
endif

validpD(_cPergDiu)
validpN(_cPergNot)
validwf()

_fColhepar()

@ 100,091 To 350,520 Dialog _oBase Title OemToAnsi("Reprocessamento automatica - Administracao")
          
// Diurno----------------------------------------------
@ 005,005 to 095,100 title "Diurno"
  
@ 015,010 say "Periodo de: "
@ 015,045 get _dDatDIni size 035,010 when .f.

@ 030,010 say "Periodo ate: "
@ 030,045 get _dDatDFim size 035,010 when .f.

@ 045,010 say "Horario : "     
@ 045,045 get _cHoraD size 035,010 when .f.

@ 060,010 say "Status : "     
@ 060,045 get _cStatusD size 035,010 when .f.

@ 080,010 say "Alterar -> "
@ 075,045 bmpbutton type 5 action(_fAltPar("Dia"))

// Noturno----------------------------------------------
_nColuna:=110
@ 005,005+_nColuna to 095,100+_nColuna title "Noturno"

@ 015,010+_nColuna say "Periodo de: "
@ 015,045+_nColuna get _dDatNIni size 035,010 when .f.

@ 030,010+_nColuna say "Periodo ate: "
@ 030,045+_nColuna get _dDatNFim size 035,010 when .f.

@ 045,010+_nColuna say "Horario : "
@ 045,045+_nColuna get _cHoraN size 035,010 when .f.

@ 060,010+_nColuna say "Status : "     
@ 060,045+_nColuna get _cStatusN size 035,010 when .f.

@ 080,010+_nColuna say "Alterar -> "
@ 075,045+_nColuna bmpbutton type 5 action(_fAltPar("Noite"))
                                   
@ 110,010 say "Eventos"
@ 105,040 BmpButton Type 15 Action _fViewLog("Usu")

@ 110,080 say "Eventos Adm" object _oLabAdm
@ 105,115 BmpButton Type 15 Action _fViewLog("Adm") object _oButAdm

PswOrder(1)
PswSeek(__cUserId)
_vDatuser:= PswRet(1)
if ascan(_vDatUser[1][10],"000000")==0 // Se o usuario nao pertence ao grupo de administradores, oculta o log de administrador
   _oLabAdm:lVisible:=.f.
   _oButAdm:lVisible:=.f.
endif   

@ 105,180 BmpButton Type 1 Action close(_oBase)

Activate Dialog _oBase centered

Return

*--------------------------------------------------------------------------------
Static Function _fViewLog(_cLog)
*--------------------------------------------------------------------------------
local _oFont:=TFont():New( "Courier New",,nHeight:=15,,lBold:=.f.,,,,,lUnderLine:=.f.)

_cLog:=lower(alltrim(_cLog))
_cArq:=if(_cLog=="usu",_cLogUsu,_cLogAdm)
@ 0,0 to 480,776 dialog _oLog title "Exibicao do Log "+if(_cLog=="usu","Usuario","Administrador")
_cLog:=memoread(_cArq)
@ 5,5 get _cLog memo size 382,215 object _oGetLog
@ 225,280 bmpbutton type 1 action(close(_oLog))
_oGetLog:lReadOnly:=.t.
_oGetLog:oFont:=_oFont                                                                                                                                                                     			
activate dialog _oLog centered
return

*--------------------------------------------------------------------------------
Static Function _fAltPar(_cDN)
*--------------------------------------------------------------------------------
_cDn:=lower(alltrim(_cDN))
if _cDn=="dia"
   if pergunte(_cPergDiu,.t.)
      if _dDatDIni<>mv_par01.or.;
         _dDatDFim<>mv_par02.or.;
         _cHoraD<>mv_par03.or.;
         _cStatusD=="Ativo".and.mv_par04<>1
         
         _fAtuLog("adm","Atualizacao de parametros (Diurno) "+_cQuebral+;
                  "Antes : Periodo de: "+;
                  dtoc(_dDatDIni)+" ate: "+;
                  dtoc(_dDatDFim)+" horario: "+_cHoraD+" Status: "+_cStatusD+_cQuebral+;
                  "Depois: Periodo de: "+;
                  dtoc(mv_par01)+" ate: "+;
                  dtoc(mv_par02)+" horario: "+mv_par03+" Status: "+if(mv_par04==1,"Ativo","Inativo"))
                        
         _fAtuPar("Dia",mv_par03)
      endif   
   endif
elseif _cDn=="noite"
   if pergunte(_cPergNot,.t.)
      if _dDatNIni<>mv_par01.or.;
         _dDatNFim<>mv_par02.or.;
         _cHoraN<>mv_par03.or.;
         _cStatusN=="Ativo".and.mv_par04<>1
         
         _fAtuLog("adm","Atualizacao de parametros (Noturno) "+_cQuebral+;
                  "Antes : Periodo de: "+;
                  dtoc(_dDatNIni)+" ate: "+;
                  dtoc(_dDatNFim)+" horario: "+_cHoraN+_cQuebral+;
                  "Depois: Periodo de: "+;
                  dtoc(mv_par01)+" ate: "+;
                  dtoc(mv_par02)+" horario: "+mv_par03+" Status: "+if(mv_par04==1,"Ativo","Inativo"))
                        
         _fAtuPar("Noite",mv_par03)      
      endif   
   endif        
endif       

_fColhePar()
return

*--------------------------------------------------------------------------------
Static Function _fAtuPar(_cDn,_cHora)
*--------------------------------------------------------------------------------
// Atualiza os parametros de data e hora no scheduler, conforme o conteudo atual em SX1
_cDn:=lower(alltrim(_cDN))

dbusearea(.t.,,"SXM040","SXM",.T.,.F.)
do while sxm->(!eof())
   if alltrim(sxm->xm_codigo)==if(_cDn=="dia","CTBM40DIA","CTBM40NOITE")
      sxm->(reclock(alias(),.f.))
      
      sxm->XM_HRINI  :=_cHora
      sxm->XM_HRFIM  :=_cHora
      sxm->XM_DTPROX :=date()+if(left(time(),5)>_cHora,1,0)
      sxm->XM_HRPROX :=_cHora
      
      sxm->(msunlock())
      exit
   endif   
      
   sxm->(dbskip(1))
enddo 

sxm->(dbclosearea())

*--------------------------------------------------------------------------------
USER FUNCTION INITSTELE()
*--------------------------------------------------------------------------------
Local aParams := {'04','01'}  //Coloque aqui o código da empresa e filial.
WFScheduler(aParams)

Return .T.

*--------------------------------------------------------------------------------
Static Function _fColhePar()
*--------------------------------------------------------------------------------
// Atualiza os parametros de data e hora conforme o conteudo atual em SX1 e SXM

pergunte(_cPergDiu,.f.)
_dDatDIni:=mv_par01
_dDatDFim:=mv_par02
_cStatusD:=if(mv_par04==1,"Ativo","Inativo")

pergunte(_cPergNot,.f.)
_dDatNIni:=mv_par01
_dDatNFim:=mv_par02
_cStatusN:=if(mv_par04==1,"Ativo","Inativo")

dbusearea(.t.,,"SXM040","SXM",.T.,.F.)
do while sxm->(!eof())
   if alltrim(sxm->xm_codigo)=="CTBM40DIA"
      _cHoraD:=sxm->xm_hrini
   elseif alltrim(sxm->xm_codigo)=="CTBM40NOITE"
      _cHoraN:=sxm->xm_hrini
   endif
   sxm->(dbskip(1))
enddo
sxm->(dbclosearea())

return

*--------------------------------------------------------------------------------
Static Function ValidWf()
*--------------------------------------------------------------------------------
local _lTemDia:=_lTemnoite:=.f.
// Cria os processos automatizados no schedule do sistema caso nao existam
dbusearea(.t.,,"SXM040","SXM",.T.,.F.)
do while sxm->(!eof())
   if alltrim(sxm->xm_codigo)=="CTBM40DIA"
      _lTemDia:=.t.
   elseif alltrim(sxm->xm_codigo)=="CTBM40NOITE"
      _lTemNoite:=.t.
   endif
   sxm->(dbskip(1))
enddo               

if !_lTemDia
   
   sxm->(reclock(alias(),.t.))
   sxm->XM_FILIAL :=""
   sxm->XM_CODIGO :="CTBM40DIA"
   sxm->XM_NOME   :="CsCtbm40 Diurno" 
   sxm->XM_DESCR  :="Reprocessamento  automatica - Diurno"
   sxm->XM_TIPO   :=1
   sxm->XM_DTINI  :=ctod('01/03/2005')
   sxm->XM_HRINI  :="12:30"
   sxm->XM_DTFIM  :=ctod('31/12/2009')
   sxm->XM_HRFIM  :="12:30"
   sxm->XM_INTERV :="00:00"
   sxm->XM_SEMANA :=""
   sxm->XM_MENSAL :=""
   sxm->XM_DTPROX :=date()+if(left(time(),5)>"12:30",1,0)
   sxm->XM_HRPROX :="12:30"
   sxm->XM_AMBIENT:=upper(_cAmbiente)
   sxm->XM_ACAO   :="u_CsCtbm40('Diurno')"
   sxm->xm_ativo  :="T"
   sxm->xm_timeout:="F"
   
   sxm->(msunlock())
endif

if !_lTemNoite
   
   sxm->(reclock(alias(),.t.))
   sxm->XM_FILIAL :=""
   sxm->XM_CODIGO :="CTBM40NOITE"
   sxm->XM_NOME   :="CsCtbm40 Noturno" 
   sxm->XM_DESCR  :="Reprocessamento  automatica - Noturno"
   sxm->XM_TIPO   :=1
   sxm->XM_DTINI  :=ctod('01/03/2005')
   sxm->XM_HRINI  :="00:30"
   sxm->XM_DTFIM  :=ctod('31/12/2009')
   sxm->XM_HRFIM  :="00:30"
   sxm->XM_INTERV :="00:30"
   sxm->XM_SEMANA :=""
   sxm->XM_MENSAL :=""
   sxm->XM_DTPROX :=date()+1
   sxm->XM_HRPROX :="00:30"
   sxm->XM_AMBIENT:=upper(_cAmbiente)
   sxm->XM_ACAO   :="u_CsCtbm40('Noturno')"
   sxm->xm_ativo  :="T"
   sxm->xm_timeout:="F"
   
   sxm->(msunlock())
endif 
sxm->(dbclosearea())
return

*--------------------------------------------------------------------------------
Static Function _fAtuLog(_cLog,_cOcor)
*--------------------------------------------------------------------------------
local _cArq,_cTextAtu,_cNovoTexto,_cCab
_cLog:=lower(alltrim(_cLog))
_cArq:=if(_cLog=="usu",_cLogUsu,_cLogAdm)
_cTextAtu:=memoread(_cArq)

if _cLog=="adm"
   _cNovoTexto:="*-----"+alltrim(substr(cUsuario,7,15))+" em "+dtoc(date())+" as "+time()+" h "
   _cNovoTexto:=padr(_cNovoTexto,79,"-")+"*"
   _cGrava:=_cNovoTexto+_cQuebral+_cOcor+_cQuebral+_cTextAtu
else
   _cNovoTexto:=alltrim(substr(cUsuario,7,15))+" "+dtoc(date())+" "+time()+" h : "
   _cGrava:=_cNovoTexto+_cOcor+_cQuebral+_cTextAtu
endif   
if len(_cGrava)>65535
   _cGrava:=left(_cGrava,65535)
endif
memowrit(_cArq,_cGrava)

return   

*--------------------------------------------------------------------------------
Static Function ValidPD(_cPerg)
*--------------------------------------------------------------------------------

local aRegs := {}
          *   1    2            3                   4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
          *+------------------------------------------------------------------------------------------------------------------------------------+
          *¦G    ¦ O  ¦ PERGUNT                 ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
          *¦ R   ¦ R  ¦                         ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
          *¦  U  ¦ D  ¦                         ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
          *¦   P ¦ E  ¦                         ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
          *¦    O¦ M  ¦                         ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
AADD(aRegs,{_cPerg,"01","Periodo de            :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Periodo ate           :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"03","Horario               :","mv_ch3","C",05,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"04","Status da rotina      :","mv_ch4","N",05,0,0,"C","","mv_par04","Ativo"    ,"","","Inativo"      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return

*--------------------------------------------------------------------------------
Static Function ValidPN(_cPerg)
*--------------------------------------------------------------------------------

local aRegs := {}
          *   1    2            3                   4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
          *+------------------------------------------------------------------------------------------------------------------------------------+
          *¦G    ¦ O  ¦ PERGUNT                 ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
          *¦ R   ¦ R  ¦                         ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
          *¦  U  ¦ D  ¦                         ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
          *¦   P ¦ E  ¦                         ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
          *¦    O¦ M  ¦                         ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
AADD(aRegs,{_cPerg,"01","Periodo de            :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Periodo ate           :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"03","Horario               :","mv_ch3","C",05,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"04","Status da rotina      :","mv_ch4","N",05,0,0,"C","","mv_par04","Ativo"    ,"","","Inativo"      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return
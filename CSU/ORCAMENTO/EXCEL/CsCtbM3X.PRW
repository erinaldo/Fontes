#include "rwmake.ch"
*---------------------------------------------------------------------------------------------------------------
User Function CsCtbM3X()
* Geracao da base de dados e planilha-resumo de contas contabeis x centros de custo
* Ricardo Luiz da Rocha - Dts Consulting - 01/01/2004 GNSJC
* Alterado: 01/02/2004 - Enviado 02/02/04  
* Alterado: 04/02/2004 - Enviado 04/02/04 
* Alterado: 20/05/2004 - Enviado 20/05/04 
*---------------------------------------------------------------------------------------------------------------
_cDefReproc:="S" // Define o flag "permite reprocessamento" no nascimento do registro


dbselectarea("SZK")
_cParAdm:="_fParAdm()"
_cParUsr:="pergunte(_cPergUsr)"
_cGeraTot:="_fGeraTot()"
_cGeraPlan:="_fGeraPlan()"

u__fCloseDb("_Locked") // 04/02/2004

Private cCadastro := posicione("SX2",1,alias(),"x2_nome")
Private        aRotina := menudef()
Private        cDelFunc := ".T."
Private        cString := "SZK"

        //{ {"Pesquisar","AxPesqui",0,1} ,;
        //     {"Visualizar","AxVisual",0,2} ,;
        //     {"Alterar","AxAltera",0,4} ,;
        //     {"Param ADM","u_CsCtbm4a(_cParAdm)",0,3} ,;
        //     {"Param Usuario","u_CsCtbm4a(_cParUsr)",0,3} ,;
        //     {"Totalizacao","u_CsCtbm4a(_cGeraTot)",0,3} ,;
        //     {"Gera a planilha","u_CsCtbm4a(_cGeraPlan)",0,4},;
        //     {"Permissao reproc","u_CsCtbm4c()",0,4},;             
        //     {"Relat diferencas","u_CsCtbm4b()",0,4}},;

Private _cPathSrv,_cPath:="\Planilha\",_cQuebral:=chr(13)+chr(10),;
        _nTpConta,_cContaIni,_cContaFim,_cContaRan,_nTpCCust,_cCCustIni,_cCCustFim,_cCCustRan,_lSoMarcada,_lSoMarcCC,_cParAdm,;
        _cAno,_cMesIni,_cMesFim,_cParUsr,_dDataAnt,;
        _cArqDest,_cArqOri,_nHdl,_cSepara:=";",_cCustoGer:="*Geral*",;
        _lDel2Rep

_cUsrAdm:=getmv("MV_CSADMPL")
_cPergAdm:=PADR('CtbAdm',LEN(SX1->X1_GRUPO))
validperg1(_cPergAdm)

_cPergUsr:= PADR('CtbUsr',LEN(SX1->X1_GRUPO))
validperg2(_cPergUsr)

u_CriaMv("","C","mv_CsSrvPa","\\CSUSPDES8\MICROSIGA$\Ap_data\Planilha\",;
         'Path para a pasta AP7 no servidor. Criado automaticamente pela rotina '+procname())
_cPathSrv:=getmv("MV_CSSRVPA")

u_CriaMv("","C","mv_CsAdmPl","Administrador#K000361 (Marcio Tadeu - Dts)#S002784 (Carlos)",;
         'Usuario(s) que tera(ao) acesso aos parametros de escopo de contas e centros de custo para a geracao da planilha. Criado pela rotina '+procname())

if !file(_cPath+"CsCtbM01.lck")
   dbcreate(_cPath+"CsCtbM01.lck",{{"_Usuario","C",30,0}})
endif
dbusearea(.t.,,_cPath+"CsCtbM01.lck","_Locked",.f.,.f.)
if upper(alias())<>"_LOCKED"
   msgbox("A rotina solicitada esta em uso por ["+alltrim(memoread(_cPath+"CsCtbM01.Usr"))+"], nao foi possivel iniciar em modo exclusivo. Por favor tente novamente mais tarde.")
   return
endif
memowrit(_cPath+"CsCtbM01.Usr",PswRet(1)[1,4])
mBrowse( ,,,,cString)
ferase(_cPath+"CsCtbM01.Usr")
u__fCloseDb("_Locked")

cursorarrow()
return
*---------------------------------------------------------------------------------------------------------------
user function CsCtbM4a(_cRotina)
*---------------------------------------------------------------------------------------------------------------
return _x:=&_cRotina                                

*---------------------------------------------------------------------------------------------------------------
static function _fParAdm() 
*---------------------------------------------------------------------------------------------------------------
if lower(alltrim(substr(cUsuario,7,15)))$lower(_cUsrAdm)
   Pergunte(_cPergAdm,.t.)
else
   msgbox("Os parametros solicitados somente podem ser alterados pelo Administrador ou usuario responsavel por esta rotina")
endif
return   

*---------------------------------------------------------------------------------------------------------------
static function _fGeraTot() 
*---------------------------------------------------------------------------------------------------------------
if !msgyesno("Iniciar a rotina de totalizacao ?")
   return
endif   
_cTimeIni:="Inicio: "+dtoc(date())+" as "+time()+" h,"+chr(13)
_vNewRec:={}
cursorwait()
_lContinua:=.t.
msaguarde({||_fInicio()},"Iniciando o processo de exportacao...")

processa({||_fExporta()},"Aguarde, atualizando dados...")
msgbox("Processamento concluido, "+chr(13)+_cTimeIni+"Final.: "+dtoc(date())+" as "+time()+" h")
return

*--------------------------------------------------------------------------------------------------------------------
static function _fInicio()
*--------------------------------------------------------------------------------------------------------------------
msproctxt("Colhendo o conteudo dos parametros")
pergunte(_cPergAdm,.f.)
_nTpConta :=mv_par01 //Contas contabeis 1=De/Ate;2=Contidas
_cContaIni:=mv_par02 //Conta contabil de
_cContaFim:=mv_par03 //Conta contabil ate
_cContaRan:=mv_par04 //Contida em
_nTpCCust :=mv_par05 //Centros de custo 1=De/Ate;2=Contidos
_cCCustIni:=mv_par06 //Centro de custo de
_cCCustFim:=mv_par07 //Centro de custo ate
_cCCustRan:=mv_par08 //Contido em
_lSoMarcada:=(mv_par09==2) // 1=Todas;2=Marc como Sim
_lSoMarcCC :=(mv_par10==2) // 1=Todos;2=Marc como Sim
_lDel2Rep  :=(mv_par11==1) // 1=Sim;2=Nao

pergunte(_cPergUsr,.f.)
_cAno   :=strzero(mv_par01,4) // Ano
_cMesIni:=strzero(mv_par02,2) // Mes de
_cMesFim:=strzero(mv_par03,2) // Mes ate

return

*--------------------------------------------------------------------------------------------------------------------
static function _fExporta()
*--------------------------------------------------------------------------------------------------------------------
_vGrupoCC:={}
// Local reservado para a funcao que ira colher os grupos de centros de custo
// em cadastro apropriado
aadd(_vGrupoCC,{"50200*",{"50200","50200.1","50200.2","50200.3"}})
aadd(_vGrupoCC,{"50411*",{"50410","50411","50412","50412.1"}})
aadd(_vGrupoCC,{"50415*",{"50415","50416","50417","50418"}})
aadd(_vGrupoCC,{"5045100*",{"5045100","5045150","5045160"}})
aadd(_vGrupoCC,{"50930*",{"50930","50930.1","50930.2","50930.3"}})   
aadd(_vGrupoCC,{"51500*",{"51500"}})

_dDataIni:=ctod("01/"+_cMesIni+"/"+_cAno)
_dDataFim:=ctod("27/"+_cMesFim+"/"+_cAno)
_dDataFim:=lastday(_dDataFim)

SZK->(dbsetorder(1)) // ZK_FILIAL+ZK_ano+ZK_mes+ZK_conta+ZK_CUSTO
_cFiltro:="ZK_reproc=='S'"
SZK->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
_nJafoi:=1
if _lDel2Rep
   procregua(500)
   SZK->(dbseek(xfilial()+_cAno+_cMesIni,.t.))
   _dDataAktu:=ctod("")
   do while SZK->(!eof().and.xfilial()==ZK_filial.and.ZK_ano==_cAno.and.ZK_mes<=_cMesFim)
//      _cRegistros:=" Registros: "+alltrim(str(_nJafoi++))
      _cRegistros:=" Reg.: "+alltrim(str(_nJafoi++))
      incproc("Eliminando: "+ZK_ano+"/"+ZK_mes+"-"+alltrim(ZK_conta)+"-"+alltrim(ZK_CUSTO)+_cRegistros)
      if SZK->ZK_reproc=="S"
         do while SZK->(!reclock(alias(),.f.))
         enddo
         SZK->(dbdelete())
         SZK->(msunlock())
         SZK->(dbskip(1))
      endif   
   enddo 
else                     
   // Caso nao se va apagar os registros, zerar os valores
   SZK->(dbseek(xfilial()+_cAno+_cMesIni,.t.))
   _dDataAtu:=ctod("")
   do while SZK->(!eof().and.xfilial()==ZK_filial.and.ZK_ano==_cAno.and.ZK_mes<=_cMesFim)
      _cRegistros:=" Reg.: "+alltrim(str(_nJafoi++))
      incproc("Zerando saldos: "+ZK_ano+"/"+ZK_mes+"-"+alltrim(ZK_conta)+"-"+alltrim(ZK_CUSTO)+_cRegistros)
      if SZK->ZK_reproc=="S"
         do while SZK->(!reclock(alias(),.f.))
         enddo
         SZK->ZK_sldant :=0
         SZK->ZK_totdeb :=0
         SZK->ZK_totcred:=0
         SZK->ZK_sldfim :=0      
         SZK->(msunlock())
         SZK->(dbskip(1))
      endif   
   enddo
endif
SZK->(dbclearfil())                       
SZK->(retindex("SZK"))
procregua(_dDataFim-_dDataIni)
ct2->(dbsetorder(1)) // CT2_FILIAL+ DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
ct2->(dbseek(xfilial()+dtos(_dDataIni),.t.))
_dDataAtu:=_dDataIni
_cDtHrProc:=left(dtoc(date()),6)+strzero(year(date()),4)+" "+time()+" h"
incproc("Fase 1 - "+dtoc(ct2->ct2_data))

do while ct2->(!eof().and.ct2_data<=_dDataFim)
   _lReproc:=.f.
   if _dDataAtu<>ct2->ct2_data
      incproc("Fase 1 - Lancamentos contabeis em: "+dtoc(ct2->ct2_data))
      _dDataAtu:=ct2->ct2_data
   endif   
   // Verifica se o lancamento enquadra-se no escopo de contas contabeis x centros de custo solicitados
   // Valores para CT2_DC:
   // 1=Debito;2=Credito;3=Partida Dobrada;4=Cont.Hist;5=Rateio;6=Lcto Padrao
   _vDebito:={}
   _vCredito:={}
   _nValor:=ct2->ct2_valor
   
   if ct2->ct2_dc=="1"
      _vDebito:=ct2->({ct2_debito,ct2_ccd,_nValor,_fMaskCta(ct2_debito),_fGrupoCC(ct2_ccd)})
   endif   
   if ct2->ct2_dc=="2"
      _vCredito:=ct2->({ct2_credit,ct2_ccc,_nValor,_fMaskCta(ct2_credit),_fGrupoCC(ct2_ccc)})
   endif   
   if ct2->ct2_dc=="3"
      _vDebito :=ct2->({ct2_debito,ct2_ccd,_nValor,_fMaskCta(ct2_debito),_fGrupoCC(ct2_ccd)})
      _vCredito:=ct2->({ct2_credit,ct2_ccc,_nValor,_fMaskCta(ct2_credit),_fGrupoCC(ct2_ccc)})
   endif   

   if len(_vDebito)>0.and._fValido("Conta",_vDebito[1]).and._fValido("CCusto",_vDebito[2])
   else
      _vDebito:={}
   endif   
   if len(_vCredito)>0.and._fValido("Conta",_vCredito[1] ).and._fValido("CCusto",_vCredito[2])
   else
      _vCredito:={}
   endif   
   _lNewRec:=.f.          
   if len(_vDebito)>0.or.len(_vCredito)>0
      _cAno:=strzero(year(ct2->ct2_data),4)
      _cMes:=strzero(month(ct2->ct2_data),2)
      _dDataAnt:=_fDataAnt(_cAno,_cMes)
      if len(_vDebito)>0
         if SZK->(!dbseek(xfilial()+_cAno+_cMes+padr(_vDebito[4],len(ZK_conta))+padr(_vDebito[5],len(ZK_custo)),.f.))
            _lReproc:=.t.
            CT1->(dbseek(xfilial()+_vDebito[1],.f.))
            SZK->(reclock(alias(),.t.))
            aadd(_vNewRec,SZK->(recno()))
            SZK->ZK_filial:=xfilial("SZK")
            SZK->ZK_ano     :=_cAno
            SZK->ZK_mes     :=_cMes
            SZK->ZK_conta   :=_vDebito[4]
            SZK->ZK_classe  :=ct1->ct1_classe
            SZK->ZK_custo   :=_vDebito[5]
            SZK->ZK_contaD  :=ct1->ct1_desc01
            SZK->ZK_custoD  :=posicione("CTT",1,xfilial("CTT")+_vDebito[2],"ctt_desc01")
            //SZK->ZK_sldant  :=SZK->(_fSaldoAnt(ZK_conta,ZK_custo,_dDataAnt))
            SZK->ZK_reproc:=_cDefReproc      //mtdo
//            SZK->ZK_reproc:="S"      //mtdo
            SZK->ZK_loginc:=substr(cUsuario,7,15)+" "+_cDtHrProc
         else
            _lReproc:=(SZK->ZK_reproc=="S")
            _lNewRec:=(ascan(_vNewRec,SZK->(recno()))>0)
            if _lReproc.or._lNewRec
               SZK->(reclock(alias(),.f.))
               if _lReproc
                  SZK->ZK_logAlt:=substr(cUsuario,7,15)+" "+_cDtHrProc
               endif   
            endif   
         endif
         if _lReproc.or._lNewRec
            SZK->ZK_totdeb +=_vDebito[3]
            SZK->(msunlock())
         endif   
      endif   
      if len(_vCredito)>0
         if SZK->(!dbseek(xfilial()+_cAno+_cMes+padr(_vCredito[4],len(ZK_conta))+padr(_vCredito[5],len(ZK_custo)),.f.))
            _lReproc:=.t.
            CT1->(dbseek(xfilial()+_vCredito[1],.f.))
            SZK->(reclock(alias(),.t.))
            aadd(_vNewRec,SZK->(recno()))
            SZK->ZK_filial:=xfilial("SZK")
            SZK->ZK_ano   :=_cAno
            SZK->ZK_mes   :=_cMes
            SZK->ZK_conta :=_vCredito[4]
            SZK->ZK_classe:=ct1->ct1_classe
            SZK->ZK_custo :=_vCredito[5]
            SZK->ZK_contaD:=ct1->ct1_desc01
            SZK->ZK_custoD:=posicione("CTT",1,xfilial("CTT")+_vCredito[2],"ctt_desc01")
            //SZK->ZK_sldant:=SZK->(_fSaldoAnt(ZK_conta,ZK_custo,_dDataAnt))
            SZK->ZK_reproc:=_cDefReproc //mtdo
//            SZK->ZK_reproc:="S"      //mtdo            
            SZK->ZK_loginc:=substr(cUsuario,7,15)+" "+_cDtHrProc
         else
            _lReproc:=(SZK->ZK_reproc=="S")
            _lNewRec:=(ascan(_vNewRec,SZK->(recno()))>0)
            if _lReproc.or._lNewRec
               SZK->(reclock(alias(),.f.))
               if _lReproc
                  SZK->ZK_logAlt:=substr(cUsuario,7,15)+" "+_cDtHrProc
               endif   
            endif
         endif
         if _lReproc.or._lNewRec
            SZK->ZK_totcred+=_vCredito[3]
            SZK->(msunlock())
         endif   
      endif
   endif   
   ct2->(dbskip(1))
enddo
// Cria um vetor contendo as contas validas de acordo com os parametros solicitados
_vContas:={}
procregua(1)
incproc()

procregua(ct1->(lastrec()))
if _nTpConta==1 // De/ate
   ct1->(dbseek(xfilial()+_cContaIni,.t.))
else // Contidos
   ct1->(dbgotop())
endif
do while ct1->(!eof().and.ct1_filial==xfilial().and.if(_nTpConta==1,ct1_conta<=_cContaFim,.t.))
   incproc("Fase 2 - Conta: "+ct1->(ct1_conta+left(ct1->ct1_desc01,13)))

   if _fValido("Conta",ct1->ct1_conta)
      _cMaskCta:=_fMaskCta(ct1->ct1_conta)
      if ascan(_vContas,{|_vAux|_vAux[1]==_cMaskCta})==0
         aadd(_vContas,{_cMaskCta,ct1->ct1_conta})
      endif
   endif
   ct1->(dbskip(1))
enddo

procregua(1)
incproc("Iniciando a fase 3")
// Cria os registros faltantes (contas sinteticas e contas+centros de custo para os quais
// nao houveram lancamentos no periodo
ctt->(dbsetorder(1))
procregua(ctt->(lastrec()*(ctt->(lastrec())*3)))
if _nTpCCust==1 // De/ate
   ctt->(dbseek(xfilial()+_cCCustIni,.t.))
else // Contidos
   ctt->(dbgotop())
endif   
_vMeses:={_cMesAdic:=_cMesIni}
do while .t.
   _cMesAdic:=soma1(_cMesAdic)
   if _cMesAdic>"12".or._cMesAdic>_cMesFim
      exit
   endif
   aadd(_vMeses,_cMesAdic)
enddo   

_nRefRegua:=0
do while ctt->(!eof().and.ctt_filial==xfilial().and.if(_nTpCCust==1,ctt_custo<=_cCCustFim,.t.))
   _cMens:="Fase 3 - C. custo: "+left(ctt->ctt_custo,10)
   incproc(_cMens)
   _lValido:=(ctt->ctt_classe=="2") // Considera apenas centros de custo analiticos
   if _lValido//.and._nTpCCust==2 // Range contidos
      if !_fValido("CCusto",ctt->ctt_custo)
         _lValido:=.f.
      endif
   endif
   if _lValido
      _nRefRegua++
      for _nVezMes:=1 to len(_vMeses)
         _cMesAdic:=_vMeses[_nVezMes]
         _dDataAnt:=_fDataAnt(_cAno,_cMesAdic)
         for _nVez:=1 to len(_vContas)
             incproc(_cMens+" Conta: "+alltrim(_vContas[_nVez,1]))
             if SZK->(!dbseek(xfilial()+_cAno+_cMesAdic+padr(_vContas[_nVez,1],len(ZK_conta))+padr(_cCustoGrp:=_fGrupoCC(ctt->ctt_custo),len(ZK_custo)),.f.).and.reclock(alias(),.t.))
                aadd(_vNewRec,SZK->(recno()))
                SZK->ZK_filial:=xfilial("SZK")
                SZK->ZK_conta  :=_vContas[_nVez][1]
                SZK->ZK_custo:=_cCustoGrp
                ct1->(dbseek(xfilial("CT1")+_vContas[_nVez,2],.f.))
                SZK->ZK_contaD  :=CT1->ct1_desc01
                SZK->ZK_classe  :=ct1->ct1_classe
                SZK->ZK_custoD  :=ctt->ctt_desc01
                SZK->ZK_ano:=_cAno
                SZK->ZK_mes:=_cMesAdic
                SZK->ZK_loginc:=substr(cUsuario,7,15)+" "+_cDtHrProc
                SZK->ZK_reproc:=_cDefReproc //mtdo
//	            SZK->ZK_reproc:="S"      //mtdo
                //SZK->ZK_sldant:=SZK->(_fSaldoAnt(ZK_conta,ZK_custo,_dDataAnt))
                SZK->(msunlock())
             endif
         next
      next
   endif
   ctt->(dbskip(1))
enddo
memowrit("CsCtbM01.ref",alltrim(str(_nRefRegua*len(_vContas))))

procregua(len(_vMeses)*len(_vContas))
// Carrega os saldos gerais das contas

for _nVezMes:=1 to len(_vMeses)
    _cMesAdic:=_vMeses[_nVezMes]
    _dDataSld:=lastday(ctod("27/"+_cMesAdic+"/"+_cAno))
    for _nVez:=1 to len(_vContas)
        incproc("Fase 4 - Saldos totais das contas: "+_vContas[_nVez][1])
        if SZK->(!dbseek(xfilial()+_cAno+_cMesAdic+padr(_vContas[_nVez][1],len(ZK_conta))+padr(_cCustoGer,len(ZK_custo)),.f.))
           if SZK->(reclock(alias(),.t.))
              aadd(_vNewRec,SZK->(recno()))
              SZK->ZK_filial:=xfilial("SZK")
              SZK->ZK_conta  :=_vContas[_nVez][1]
              SZK->ZK_custo:=_cCustoGer
              ct1->(dbseek(xfilial("CT1")+_vContas[_nVez][2],.f.))
              SZK->ZK_contaD  :=CT1->ct1_desc01
              SZK->ZK_classe  :=ct1->ct1_classe
              SZK->ZK_custoD  :="Saldo total"
              SZK->ZK_ano:=_cAno
              SZK->ZK_mes:=_cMesAdic
              SZK->ZK_loginc:=substr(cUsuario,7,15)+" "+_cDtHrProc
              SZK->ZK_reproc:=_cDefReproc //mtdo   
//              SZK->ZK_reproc:="S"      //mtdo              
              //SZK->ZK_sldfim:=SZK->(_fSaldoAnt(ZK_conta,ZK_custo,_dDataSld))
              // Passa a considerar o saldo de movimentacao da conta
              _vReturn:=SZK->(_fMovimGCta(ZK_conta,_cMesAdic,_cAno))
              SZK->ZK_totdeb :=_vReturn[1]
              SZK->ZK_totcred:=_vReturn[2]
              SZK->(msunlock())
           endif
        else
           _lReproc:=(SZK->ZK_reproc=="S")
           _lNewRec:=(ascan(_vNewRec,SZK->(recno()))>0)
           if _lReproc.or._lNewRec
              SZK->(reclock(alias(),.f.))
              _vReturn:=SZK->(_fMovimGCta(ZK_conta,_cMesAdic,_cAno))
              SZK->ZK_totdeb :=_vReturn[1]
              SZK->ZK_totcred:=_vReturn[2]
              //SZK->ZK_sldfim:=SZK->(_fSaldoAnt(ZK_conta,ZK_custo,_dDataSld))
              if _lReproc
                 SZK->ZK_logAlt:=substr(cUsuario,7,15)+" "+_cDtHrProc
              endif
              SZK->(msunlock())
           endif
           
        endif
    next
next

// Recalcula o nivel das contas, o saldo final de movimentacoes
SZK->(dbsetorder(2)) // ZK_FILIAL+ZK_ANO+ZK_MES+ZK_CUSTO+ZK_CONTA
SZK->(dbseek(xfilial()+_cAno+soma1(_cMesFim),.t.))
SZK->(dbskip(-1))
procregua(1)
incproc()
procregua(SZK->(lastrec()))
_nNivel:=0
_cCentroCOld:=""
_nSALDOANT:=_nTOTDEB:=_nTOTCRED:=0
do while SZK->(!bof().and.ZK_ano==_cAno.and.ZK_mes>=_cMesIni)
   if SZK->ZK_custo<>_cCentroCOld
      _vAnaliticas:={}
      _cCentroCOld:=SZK->ZK_custo
   endif      
   incproc(" Fase 5 - Saldos / Sinteticas: "+SZK->ZK_conta)
   _nLenConta:=len(alltrim(SZK->ZK_conta))
   if SZK->ZK_classe<>"2"
      _nNivel++
   else
     _nNivel:=0
   endif 
   _lReproc:=(SZK->ZK_reproc=="S")
   _lNewRec:=(ascan(_vNewRec,SZK->(recno()))>0)

   if _lReproc.or._lNewRec
      SZK->(reclock(alias(),.f.))
       SZK->ZK_Nivel:=_nNivel    
       /*if _cCustoGer$SZK->ZK_custo
         
          SZK->ZK_sldfim:=SZK->(_fSaldoAnt(ZK_conta,ZK_custo,lastday(ctod("27/"+ZK_mes+"/"+ZK_ano))))
       else
          //_dDataAnt:=SZK->(_fDataAnt(ZK_ano,ZK_mes))
          //SZK->ZK_sldant:=SZK->(_fSaldoAnt(ZK_conta,ZK_custo,_dDataAnt))
       endif   */
      if _lReproc
         SZK->ZK_logAlt:=substr(cUsuario,7,15)+" "+_cDtHrProc
      endif
   endif
   
   if SZK->ZK_classe<>"2"
      for _nVezAna:=1 to len(_vAnaliticas)
          // prevencao contra possiveis contas analiticas que nao possuam sintetica correspondente
          if left(_vAnaliticas[_nVezAna][1],_nLenConta)==alltrim(SZK->ZK_conta)
             _nSaldoAnt+=_vAnaliticas[_nVezAna][2]
             _nTotDeb  +=_vAnaliticas[_nVezAna][3]
             _nTotCred +=_vAnaliticas[_nVezAna][4]
           endif
      next
      if _cCustoGer$SZK->ZK_custo
      elseif _lReproc.or._lNewRec
         //SZK->ZK_sldant:=_nSaldoAnt
         SZK->ZK_totdeb  :=_nTotDeb
         SZK->ZK_totcred :=_nTotCred
      endif
      _nSALDOANT:=_nTOTDEB:=_nTOTCRED:=0
   endif

   if SZK->ZK_classe=="2"
      SZK->(aadd(_vAnaliticas,{ZK_conta,ZK_sldant,ZK_totdeb,ZK_totcred}))
   endif
   if _lReproc.or._lNewRec
      /*if _cCustoGer$SZK->ZK_custo
         // Rever
         SZK->ZK_sldfim:=SZK->(_fSaldoAnt(ZK_conta,ZK_custo,lastday(ctod("27/"+ZK_mes+"/"+ZK_ano))))
      else
         //SZK->(ZK_sldfim:=ZK_sldant-ZK_totdeb+ZK_totcred)
      
      endif   */
      SZK->(ZK_sldfim:=ZK_totcred-ZK_totdeb)
      SZK->(msunlock())
   endif
   SZK->(dbskip(-1))
enddo            

procregua(1)
incproc()
return

*--------------------------------------------------------------------------------------------------------------------
static function _fDataAnt(_cAnoDt,_cMesDt)
*--------------------------------------------------------------------------------------------------------------------
local _dReturn
if _cMesDt=="01"
   _dReturn:=ctod("31/12/"+strzero(val(_cAnoDt)-1,4))
else
   _dReturn:=ctod("25/"+strzero(val(_cMesDt)-1,2)+"/"+_cAnoDt)
   _dReturn:=lastday(_dReturn)
endif
     
return _dReturn

*--------------------------------------------------------------------------------------------------------------------
static function _fGeraPlan()
*--------------------------------------------------------------------------------------------------------------------
_lContinua:=.t.
if !pergunte(_cPergUsr,.t.)
   return
endif   
_cAno   :=strzero(mv_par01,4) // Ano
_cMesIni:=strzero(mv_par02,2) // Mes de
_cMesFim:=strzero(mv_par03,2) // Mes ate
msaguarde({||_fIniPlan()},"Preparando a geracao da planilha")
if _lContinua
   processa({||_fGeraPla1()},"Gerando as planilhas")

//   _cComando:="start "+_cPathSrv+_cPath+_cArqDest
   _cComando:="start "+_cPathSrv+_cArqDest
   memowrit("c:\CsCtbM01.bat",_cComando)
   commit
   winexec("c:\CsCtbM01.bat")
else
   msgbox("Nao foi possivel gerar a planilha")   
endif   
return

*--------------------------------------------------------------------------------------------------------------------
static function _fIniPlan()
*--------------------------------------------------------------------------------------------------------------------
_cArqDest:=u__fMesLit(val(_cMesIni))+"_"+_cAno+".xls"
_lConfirma:=.f.
if _lConfirma.and.file(_cPathSrv+_cArqDest).and.!msgyesno("O arquivo "+_cArqDest+" ja existe, deseja substitui-lo ?")
   _lContinua:=.f.
   return
endif
_cArqOri:="CsCtbM01.xls"
msproctxt("Verificando o arquivo principal")
if !file(_cPathSrv+_cArqOri)
   msgbox("O arquivo-matriz ("+_cPathSrv+_cArqOri+" nao foi encontrado, nao e possivel continuar")
   _lContinua:=.f.
   return
endif   
// Copia a planilha original para a nova, que sera gerada agora...
msproctxt("Preparando a nova planilha...")
__CopyFile(_cPathSrv+_cArqOri,_cPathSrv+_cArqDest )
commit
if !file(_cPathSrv+_cArqDest)
   msgbox("Nao foi possivel criar o novo arquivo "+_cPathSrv+_cArqDest+", nao e possivel continuar")
   _lContinua:=.f.
   return
endif   
msproctxt("Limpeza do ultimo processamento")
// Elimina arquivos da ultima exportacao
_vDirectory:=directory(_cPathSrv+"*.csv")
for _nVez:=1 to len(_vDirectory)
    msproctxt("Eliminando ultimo processamento: "+_cPathSrv+_vDirectory[_nVez,1])
    ferase(_cPathSrv+_vDirectory[_nVez,1])
next
_vDirectory:=directory(_cPathSrv+"*.csv")
if len(_vDirectory)>0
   msgbox("Nao foi eliminar os arquivos *.Csv da ultima exportacao, nao e possivel continuar")
   _lContinua:=.f.
endif   
SZK->(retindex(alias()))
return 
*--------------------------------------------------------------------------------------------------------------------
static function _fGeraPla1()
*--------------------------------------------------------------------------------------------------------------------

_vTmp:={Alltrim(substr(cUsuario,7,15))+" - "+alltrim(PswRet(1)[1,4])+" em "+dtoc(date())+" as "+time()+" h"}
aadd(_vTmp,_cAno)
aadd(_vTmp,_cMesIni)
aadd(_vTmp,_cMesFim)
aadd(_vTmp,"cTotal")

SZK->(dbsetorder(4)) // ZK_FILIAL+ZK_CUSTO+ZK_CONTA+ZK_ANO+ZK_MES
_cFiltro:="ZK_filial=='"+xfilial("SZK")+"'.and.ZK_ano=='"+_cAno+"'.and."
_cFiltro+="ZK_mes>='"+_cMesIni+"'.and.ZK_mes<='"+_cMesFim+"'"

SZK->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
procregua(2)
incproc("Filtrando registros")
//SZK->(dbeval({||_nRegua++}))
_nRegua:=max(1500,val(memoread("CsCtbM01.ref"))*(val(_cMesFim)-val(_cMesIni)))
incproc()
procregua(_nRegua)
SZK->(dbgotop())
_cCcustAtu:=_cContaAtu:=""

_vLinha:={,}
for _nVez:=1 to 12
    aadd(_vLinha,capital(u__fMesLit(_nVez)))
next    
_cLinMes:=_fGeraLin(_vLinha)
_nHdl:=0
_vLinTot :={"Totais",,0,0,0,0,0,0,0,0,0,0,0,0}
_vLinGer:={}
_nPosicGer:=1
do while SZK->(!eof())
   if _cCustoGer$SZK->ZK_custo
   else
      SZK->(incproc(ZK_custo+" / "+ZK_conta+" "+ZK_ano+"-"+ZK_mes))
      if _cCCustAtu<>SZK->ZK_custo
         if _nHdl<>0
            _fGravaLin(_fGeraLin(_vLinha))
            _fGravaLin(_fGeraLin(_vLinTot))
            _fGravaLin("Fechar")
         endif
         _cCCustAtu:=SZK->ZK_custo
         _cArq:="c"+strtran(strtran(alltrim(SZK->ZK_custo),".","_"),"*","")
         aadd(_vTmp,_cArq)
         _cArq+=".Csv"
         if (_nHdl:=fcreate(_cPathSrv+_cArq,0))==-1
            msgbox('Erro na criacao do arquivo de exportacao: '+_cPathSrv+_cArq)
            return
         endif
         _fGravaLin(_fGeralin({"Centro de custo "+SZK->(alltrim(strtran(ZK_custo,"*",""))+" - "+alltrim(ZK_custod))}))
         _fGravaLin()
         _fGravaLin(_cLinMes)
         _cContaAtu:=""
         _vLinha:={}
         _vLinTot:={"Totais",,0,0,0,0,0,0,0,0,0,0,0,0}
      endif
      if _cContaAtu<>SZK->ZK_conta
         if len(_vLinha)>0
            _fGravaLin(_fGeraLin(_vLinha))
         endif
         _cContaAtu:=SZK->ZK_conta
         _vLinha:=SZK->({space(2-ZK_Nivel)+alltrim(if(ZK_classe<>"2",upper(ZK_contaD),capital(ZK_contaD))),alltrim(ZK_conta),0,0,0,0,0,0,0,0,0,0,0,0})
         if (_nPosicGer:=ascan(_vLinGer,{|_vAux|alltrim(_vAux[2])==alltrim(_vLinha[2])}))==0
            aadd(_vLinGer,aclone(_vLinha))
            _nPosicGer:=len(_vLinGer)
         endif
      endif
      _nPosic:=val(SZK->ZK_mes)
      if _nPosic>=1.and._nPosic<=12
         // Inverter o sinal das contas
         _vLinha[_nPosic+2]:=SZK->ZK_sldfim*-1
         _vLinGer[_nPosicGer][_nPosic+2]+=SZK->ZK_sldfim*-1
         if SZK->ZK_classe=="2"
            // Inverter o sinal das contas
            _vLinTot[_nPosic+2]+=(SZK->ZK_sldfim*-1)
         endif
      endif
   endif
   SZK->(dbskip(1))
enddo
incproc("Finalizando a exportacao")
// Grava a ultima linha do arquivo do ultimo centro de custo
_fGravaLin(_fGeraLin(_vLinha))
_fGravaLin(_fGeraLin(_vLinTot))
_fGravaLin("Fechar")
procregua(1)
incproc()


// Grava o arquivo cTotal.csv
_cArq:="cTotal.csv"
if (_nHdl:=fcreate(_cPathSrv+_cArq,0))==-1
   msgbox('Erro na criacao do arquivo de exportacao: '+_cPathSrv+_cArq)
   return
endif
procregua(len(_vLinGer))
_fGravalin("Total dos Centros de custo")
_fGravalin()
_fGravalin(_cLinMes)
_vLinTot:={"Totais",,0,0,0,0,0,0,0,0,0,0,0,0}
for _nVez:=1 to len(_vLinGer)
    incproc("Totais "+_vLinger[_nVez][1])
    _fGravalin(_fGeraLin(_vLinger[_nVez]))
    if left(_vLinGer[_nVez][1],2)=="  ".and.substr(_vLinGer[_nVez][1],3,1)<>" "
       for _nVez1:=3 to 14
           _vLinTot[_nVez1]+=_vLinger[_nVez][_nVez1]
       next
    endif
next
_fGravalin(_fGeraLin(_vLinTot))
_fGravaLin("Fechar")
                     
// Grava o arquivo Tmp.csv, que comandara a importacao
_cArq:="Tmp.Csv"
if (_nHdl:=fcreate(_cPathSrv+_cArq,0))==-1
   msgbox('Erro na criacao do arquivo de exportacao: '+_cPathSrv+_cArq)
   return
endif

procregua(len(_vTmp))
for _nVez:=1 to len(_vTmp)
    incproc("Controle de importacao "+_vTmp[_nVez])
    _fGravalin(alltrim(_vTmp[_nVez]))
next
_fGravaLin("Fechar")
SZK->(retindex(alias()))
return

*--------------------------------------------------------------------------------------------------------------------
static function _fGeraLin(_vLinha)
*--------------------------------------------------------------------------------------------------------------------
local _cReturn:="",_nVez,_xConteudo
for _nVez:=1 to len(_vLinha)
    _xConteudo:=_vLinha[_nVez]
    if valtype(_xConteudo)=="N"
       _xConteudo:=strtran(alltrim(str(_xConteudo)),".",",")
       // Adaptacao para o office 97
       _xConteudo:=strtran(_xConteudo,",",".")
    elseif valtype(_xConteudo)=="D"
        _xConteudo:=dtos(_xConteudo)
        _xConteudo:=right(_xConteudo,2)+"/"+substr(_xConteudo,5,2)+"/"+left(_xConteudo,4)
    elseif valtype(_xConteudo)=="U"
        _xConteudo:=""
    endif
    _cReturn+=_xConteudo+_cSepara
next    
_cReturn:=left(_cReturn,len(_cReturn)-1)+_cQuebral
return _cReturn    

*--------------------------------------------------------------------------------------------------------------------
static function _fGravaLin(_cLinha)
*--------------------------------------------------------------------------------------------------------------------
local _lFechar:=(lower(alltrim(_cLinha))=="fechar")
static _cGrava
if _cGrava==nil
   _cGrava:=""
endif   
if _cLinha==nil
   _cLinha:=""
endif   
if right(_cLinha,len(_cQuebral))<>_cQuebral
   _cLinha+=_cQuebral
endif   
if _lFechar.or.len(_cGrava)+len(_cLinha)>64000
   if fwrite(_nHdl,_cGrava)<>len(_cGrava)
      msgbox("Erro de gravacao do conteudo temporario")
   endif   
   if !_lFechar
      if fwrite(_nHdl,_cLinha)<>len(_cLinha)
         msgbox("Erro de gravacao da linha atual")
      endif   
   else
      fclose(_nHdl)
   endif
   _cGrava:=""   
else
   _cGrava+=_cLinha
endif
return _cLinha

*--------------------------------------------------------------------------------------------------------------------
Static Function _fValido(_cCtaCus,_cNumero)
* Retorna logico se a conta ou centro de custo mencionado em _cNumero estiver no escopo solicitado nos parametros
*--------------------------------------------------------------------------------------------------------------------
local _lReturn:=.f.
_cCtaCus:=alltrim(lower(_cCtaCus))
if _cCtaCus=="conta"
   if _lSoMarcada.and.(posicione("CT1",1,xfilial("CT1")+padr(_cNumero,len(ct1->ct1_conta)),"ct1_flagpl")<>"S")
   else
      if _nTpConta==1 // De/ate
         if _cNumero>=alltrim(_cContaIni).and._cNumero<=alltrim(_cContaFim)
            _lReturn:=.t.
         endif
      else // Range Contidas
         if alltrim(_cNumero)$_cContaRan
            _lReturn:=.t.
         endif   
      endif   
   endif   
elseif _cCtaCus=="ccusto"

   if _lSoMarcCC.and.(posicione("CTT",1,xfilial("CTT")+padr(_cNumero,len(ctt->ctt_custo)),"ctt_flagpl")<>"S")
   else
      if _nTpCCust==1 // De/ate
         if _cNumero>=alltrim(_cCCustIni).and._cNumero<=alltrim(_cCCustFim)
            _lReturn:=.t.
         endif
      else // Range Contidos
         if alltrim(_cNumero)$_cCCustRan
            _lReturn:=.t.
         endif
      endif
   endif
endif 

return _lReturn

*--------------------------------------------------------------------------------------------------------------------
Static Function _fMaskCta(_cConta)
* Retorna a conta com mascara "?" substituindo o 3o digito, se houver
*--------------------------------------------------------------------------------------------------------------------
local _cReturn:=_cConta,_nLen:=len(_cConta)
if len(alltrim(_cConta))>=3
   _cReturn:=left(_cConta,2)+"?"+substr(_cConta,4)
endif
// Tratamento especial para a conta 30?110101
if alltrim(_cReturn)=="30?110101"
   _cReturn:="30?010199"
endif
return padr(_cReturn,_nLen)
*--------------------------------------------------------------------------------------------------------------------
Static Function _fSaldoAnt(_cConta,_cCentroC,_dData)
* Retorna o saldo do grupo de contas x grupo de centros de custo, se for o caso
*--------------------------------------------------------------------------------------------------------------------
local _nReturn:=0,_cMaskCta,_nPosic,_nVez
static _vGrupoCta
/* Layout de _vGrupoCta:
   _vGrupoCta[n][1]    = Conta com a mascara (?)
   _vGrupoCta[n][2][1] = 1a conta do grupo
   _vGrupoCta[n][2][2] = 2a conta do grupo
   _vGrupoCta[n][2][N] = Na conta do grupo
*/

if _vGrupoCta==nil
   _vGrupoCta:={}
   _vAmbCt1:=ct1->(getarea())

   if _nTpConta==1 // De/ate
      ct1->(dbseek(xfilial()+_cContaIni,.t.))
   else // Contidos
      ct1->(dbgotop())
   endif
   do while ct1->(!eof().and.ct1_filial==xfilial().and.if(_nTpConta==1,ct1_conta<=_cContaFim,.t.))
      _cMaskCta:=_fMaskCta(ct1->ct1_conta)
      if (_nPosic:=ascan(_vGrupoCta,{|_vAux|_vAux[1]==_cMaskCta}))==0
         aadd(_vGrupoCta,{_cMaskCta,{}})
         _nPosic:=len(_vGrupoCta)
      endif
      aadd(_vGrupoCta[_nPosic][2],ct1->ct1_conta)
      ct1->(dbskip(1))
   enddo
   ct1->(restarea(_vAmbCt1))
endif

if !(_cCustoGer$_cCentroC).and.right(alltrim(_cCentroC),1)=="*" // Grupo de centros de custo
   if (_nPosicK:=ascan(_vGrupoCC,{|_vAux|alltrim(_vAux[1])==alltrim(_cCentroC)}))==0
      msgbox("Erro na localizacao do grupo de centros de custo")
   else
      for _nVezCC:=1 to len(_vGrupoCC[_nPosicK][2])
          _cCentroCG:=_vGrupoCC[_nPosicK][2][_nVezCC]
          if "?" $_cConta // Colher o saldo do grupo de contas
             if (_nPosicX:=ascan(_vGrupoCta,{|_vAux|_vAux[1]==_cConta}))==0
                msgbox("Erro na localizacao da conta (2): "+_cConta)
             else
                for _nVez:=1 to len(_vGrupoCta[_nPosicX][2])
                    _nReturn+=_fSaldoSim(_vGrupoCta[_nPosicX][2][_nVez],_cCentroCG,_dData)
                next
             endif
          else
            _nReturn+=_fSaldoSim(_cConta,_cCentroCG,_dData)
          endif
       next
    endif
else
   if "?" $_cConta // Colher o saldo do grupo de contas
      if (_nPosicK:=ascan(_vGrupoCta,{|_vAux|_vAux[1]==_cConta}))==0
         msgbox("Erro na localizacao da conta: "+_cConta)
      else
         for _nVez:=1 to len(_vGrupoCta[_nPosicK][2])
             _nReturn+=_fSaldoSim(_vGrupoCta[_nPosicK][2][_nVez],_cCentroC,_dData)
         next
      endif
   else
     _nReturn:=_fSaldoSim(_cConta,_cCentroC,_dData)
   endif
endif

return _nReturn

*--------------------------------------------------------------------------------------------------------------------
Static Function _fGrupoCC(_cCusto)
* Retorna o codigo do grupo ou do centro de custo, conforme o caso
*--------------------------------------------------------------------------------------------------------------------
local _nPosic:=0,_cReturn:=_cCusto,_nVez,_nVez1
for _nVez:=1 to len(_vGrupoCC)
    for _nVez1:=1 to len(_vGrupoCC[_nVez][2])
        if alltrim(_vGrupoCC[_nVez][2][_nVez1])==alltrim(_cCusto)
           _nPosic:=_nVez
           exit
        endif
    next
next                           
if _nPosic>0
   _cReturn:=_vGrupoCC[_nPosic][1]
endif

/*    
if (_nPosic:=ascan(_vGrupoCC,{|_vAux|ascan(_vAux[2],alltrim(_cCusto))}))>0
   _cReturn:=_vGrupoCC[_nPosic][1]
endif
*/
return _cReturn

*--------------------------------------------------------------------------------------------------------------------
Static Function _fSaldoSim(_cConta,_cCentroC,_dData)
* Retorna o saldo final para a conta contabil x centro de custo na data solicitada (moeda 1)
*--------------------------------------------------------------------------------------------------------------------
local _nReturn:=0

/*
local _nReturn:=0,_cKey:=ct3->(xfilial()+"01"+"1"+padr(alltrim(_cConta),len(ct3_conta))+padr(alltrim(_cCentroC),len(ct3_custo))+dtos(_dData)),;
                  _cKey1:=ct3->(xfilial()+"01"+"1"+padr(alltrim(_cConta),len(ct3_conta))+padr(alltrim(_cCentroC),len(ct3_custo)))
ct3->(dbsetorder(1)) // CT3_FILIAL+CT3_MOEDA+CT3_TPSALD+CT3_conta+CT3_CUSTO+ DTOS(CT3_DATA)
if ct3->(dbseek(_cKey,.f.))
   // Localizou o saldo na data exata
   _nReturn:=ct3->(CT3_ATUCRD-CT3_ATUDEB)
else   
   ct3->(dbseek(_cKey,.t.))
   // Nao achou na data exata, tenta localizar a data imediatamente anterior
   ct3->(dbskip(-1))
   if ct3->(CT3_FILIAL+CT3_MOEDA+CT3_TPSALD+CT3_conta+CT3_CUSTO)==_cKey1
      _nReturn:=ct3->(CT3_ATUCRD-CT3_ATUDEB)   
   endif
endif      
return _nReturn
*/
_cConta:=padr(_cConta,len(ct1->ct1_conta))
_cCCentroC:=padr(_cCentroC,len(ctt->ctt_custo))

if "*geral*"$lower(_cCentroC)
   _nReturn:=SaldoCt7(_cConta,_dData,"01","1")[1]
else
   _nReturn:=SaldoCT3(_cConta,_cCentroC,_dData,"01","1")[1]   
endif                     

return _nReturn           

*--------------------------------------------------------------------------------------------------------------------
Static Function _fMovimGCta(_cConta,_cMes,_cAno)
* Retorna o saldo do grupo de contas x grupo de centros de custo, se for o caso
*--------------------------------------------------------------------------------------------------------------------
local _nReturn:=0,_cMaskCta,_nPosic,_nVez,_vReturn:={0,0}
static _vGrupoCta
/* Layout de _vGrupoCta:
   _vGrupoCta[n][1]    = Conta com a mascara (?)
   _vGrupoCta[n][2][1] = 1a conta do grupo
   _vGrupoCta[n][2][2] = 2a conta do grupo
   _vGrupoCta[n][2][N] = Na conta do grupo
*/

if _vGrupoCta==nil
   _vGrupoCta:={}
   _vAmbCt1:=ct1->(getarea())

   if _nTpConta==1 // De/ate
      ct1->(dbseek(xfilial()+_cContaIni,.t.))
   else // Contidos
      ct1->(dbgotop())
   endif
   do while ct1->(!eof().and.ct1_filial==xfilial().and.if(_nTpConta==1,ct1_conta<=_cContaFim,.t.))
      _cMaskCta:=_fMaskCta(ct1->ct1_conta)
      if (_nPosic:=ascan(_vGrupoCta,{|_vAux|_vAux[1]==_cMaskCta}))==0
         aadd(_vGrupoCta,{_cMaskCta,{}})
         _nPosic:=len(_vGrupoCta)
      endif
      aadd(_vGrupoCta[_nPosic][2],ct1->ct1_conta)
      ct1->(dbskip(1))
   enddo
   ct1->(restarea(_vAmbCt1))
endif

if (_nPosicK:=ascan(_vGrupoCta,{|_vAux|_vAux[1]==_cConta}))==0
   msgbox("Erro na localizacao da conta: "+_cConta)
else
   for _nVez:=1 to len(_vGrupoCta[_nPosicK][2])
       _vReturn1:=_fMovimCta(_vGrupoCta[_nPosicK][2][_nVez],_cMes,_cAno)
       _vReturn[1]+=_vReturn1[1]
       _vReturn[2]+=_vReturn1[2]
   next
endif

return _vReturn

*--------------------------------------------------------------------------------------------------------------------
Static Function _fMovimCta(_cConta,_cMes,_cAno)
* Retorna o saldo de movimentacoes da conta no mes/ano solicitado
* Retorno:
* _vReturn[1] = Total de debitos      
* _vReturn[2] = Total de creditos
*--------------------------------------------------------------------------------------------------------------------
local _cDataIni:=dtos(ctod("01/"+_cMes+"/"+_cAno)),;
      _cDataFim:=dtos(lastday(ctod("27/"+_cMes+"/"+_cAno))),;
      _vAmbCt7:=ct7->(getarea()),_vReturn:={0,0},_cChave

ct7->(dbsetorder(1)) // CT7_FILIAL+CT7_MOEDA+CT7_TPSALD+CT7_CONTA+ DTOS(CT7_DATA)
_cChave:=ct7->(xfilial()+"011"+padr(_cConta,len(ct7_conta)))
ct7->(dbseek(_cChave+_cDataIni,.t.))
do while ct7->(!eof().and._cChave==CT7_FILIAL+CT7_MOEDA+CT7_TPSALD+CT7_CONTA.and.;
                dtos(ct7_data)<=_cDataFim)     
   _vReturn[1]+=ct7->ct7_debito
   _vReturn[2]+=ct7->ct7_credito
   ct7->(dbskip(1))
enddo         
ct7->(restarea(_vAmbCt7))
return _vReturn
      
*--------------------------------------------------------------------------------------------------------------------
user Function CsCtbM4b()
*--------------------------------------------------------------------------------------------------------------------
local _cPerg   :=PADR("CtbMr1",LEN(SX1->X1_GRUPO))

private areturn

tamanho := "M" 
wnrel   :=nomeprog:="CsCtbM01"
limite  := 132
titulo  := "Apuracao de diferencas na planilha"
Cabec1  :=""
Cabec2  :="Conta/Centro de custo     Descricao                       Saldo final do periodo      Diferenca   Periodo"
cDesc1  := Titulo
cDesc2  := ""
cDesc3  := ""
cString := "SZK"
aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey:= 0
li      := 99
m_pag   :=1
lAbortPrint:=.f.
_cPictVal  :="@er 999,999,999.99"

validperg4(_cPerg)
pergunte(_cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)
If nLastKey == 27
   Return
Endif
ferase("relato\"+wnrel+".##r")
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif
                                                              
RptStatus({|lAbortPrint|_ImpRel()},titulo)

retindex("SZK")

*--------------------------------------------------------------------------
Static function _ImpRel()
*--------------------------------------------------------------------------
_cAno    :=strzero(mv_par01,4)
_cMesIni :=strzero(mv_par02,2)
_cMesFim :=strzero(mv_par03,2)
_lSodif  :=(mv_par04==2)
_lSuspeitos:=(mv_par05==1)
_dDataIni:=ctod("01/"+_cMesIni+"/"+_cAno)
_dDataFim:=lastday(ctod("27/"+_cMesFim+"/"+_cAno))
Cabec1+="Ano: "+_cAno+" - Mes de "+_cMesIni+" ate "+_cMesFim+" - Exibir: "+if(_lSodif,"Diferencas","Tudo")+;
        " - Listar lanctos suspeitos: "+if(_lSuspeitos,"Sim","Nao")
// Percorre SZK considerando a soma dos saldos por centro de custo de cada conta,
// e comparando com o total geral. Se uma diferenca for encontrada,
// pesquisa os lancamentos em CT2 para a mesma conta cujo centro de custo
// nao foi gerado para o periodo solicitado.
setregua(SZK->(lastrec()))
SZK->(dbsetorder(1)) // ZK_FILIAL+ZK_ANO+ZK_MES+ZK_CONTA+ZK_CUSTO
SZK->(dbseek(xfilial()+_cAno+_cMesIni,.t.))
_cContaAtu:=_cDescConta:=""
_nNivel:=_nSaldoGer:=_nSaldoCC:=0
_lGerouTmp:=_lDiferenca:=.f.
_vResConta:={}
_cPeriodo:=""
do while SZK->(!eof().and.ZK_filial+ZK_ano==xfilial()+_cAno.and.ZK_mes<=_cMesFim)
   incregua()
   if SZK->ZK_classe<>"2"
      SZK->(dbskip(1))
      loop
   endif   
   if SZK->ZK_conta<>_cContaAtu
      if len(_vResConta)>0
         if !_lSodif.or._nSaldoGer<>_nSaldoCC
            _lDiferenca:=if(_lDiferenca,.t.,_nSaldoGer==_nSaldoCC)
            _fIncrLin(2)
            @ li,0 PSAY _cContaAtu+"   "+_cDescConta+"   "+tran(_nSaldoGer,_cPictVal)+" "+tran(_nSaldoGer-_nSaldoCC,_cPictVal)+"   "+_cPeriodo
            _fIncrLin()
            for _nVez:=1 to len(_vResConta)
                if (_cCustoGer$_vResConta[_nVez][1])==.f.
                   _fIncrLin()
                   @ li,04 PSAY _vResConta[_nVez][1]+" "+_vResConta[_nVez][2]+" "+tran(_vResConta[_nVez][3],_cPictVal)+" "+tran(_nSaldoGer-_vResConta[_nVez][3],_cPictVal)
                endif
             next   
             _fIncrLin(2)
             @ li,05 PSAY padr("Somatoria dos saldos por centro de custo:",61)+tran(_nSaldoCC,_cPictVal)
             _fIncrLin(2)
         endif
         if _lSuspeitos.and._nSaldoGer<>_nSaldoCC
            // Verifica, em CT2, quais lancamentos para o periodo figuram em centros de custo ausentes ou distintos do vetor atual
            if !_lGerouTmp
               _lGerouTmp:=.t.
               _vStruct:={{"_Data","D",8,0},;
                          {"_Lote","C",6,0},;
                          {"_SLote","C",3,0},;
                          {"_Doc","C",6,0},;
                          {"_Linha","C",3,0},;
                          {"_DC","C",1,0},;
                          {"_Conta","C",20,0},;
                          {"_MaskCta","C",20,0},;
                          {"_Custo","C",20,0},;
                          {"_Valor","N",17,2}}
                dbcreate(_cNomArq:=criatrab(,.f.),_vStruct)
                dbusearea(.t.,,_cNomArq,"CtbM01Tmp",.t.,.f.)
                CtbM01Tmp->(IndRegua(alias(),_cNomArq,"_MaskCta+_Custo"))
                ct2->(dbsetorder(1)) //CT2_FILIAL+ DTOS(CT2_DATA)+...
                ct2->(dbseek(xfilial()+dtos(_dDataIni),.t.))
                do while ct2->(!eof().and.ct2->ct2_data<=_dDataFim)
                   if ct2->ct2_dc$"13"
                      CtbM01Tmp->(reclock(alias(),.t.))
                      CtbM01Tmp->_Data   :=ct2->ct2_data
                      CtbM01Tmp->_Lote   :=ct2->ct2_Lote
                      CtbM01Tmp->_SLote  :=ct2->ct2_SBLote
                      CtbM01Tmp->_Doc    :=ct2->ct2_doc
                      CtbM01Tmp->_Linha  :=ct2->ct2_linha
                      CtbM01Tmp->_Valor  :=ct2->ct2_valor
                      CtbM01Tmp->_DC     :="D"
                      CtbM01Tmp->_Conta  :=ct2->ct2_debito
                      CtbM01Tmp->_MaskCta:=_fMaskCta(ct2->ct2_debito)
                      CtbM01Tmp->_Custo  :=ct2->ct2_ccd
                      CtbM01Tmp->(msunlock())
                   endif   
                   if ct2->ct2_dc$"23"
                      CtbM01Tmp->(reclock(alias(),.t.))
                      CtbM01Tmp->_Data   :=ct2->ct2_data
                      CtbM01Tmp->_Lote   :=ct2->ct2_Lote
                      CtbM01Tmp->_SLote  :=ct2->ct2_SBLote
                      CtbM01Tmp->_Doc    :=ct2->ct2_doc
                      CtbM01Tmp->_Linha  :=ct2->ct2_linha
                      CtbM01Tmp->_Valor  :=ct2->ct2_valor
                      CtbM01Tmp->_DC     :="C"
                      CtbM01Tmp->_Conta  :=ct2->ct2_credito
                      CtbM01Tmp->_MaskCta:=_fMaskCta(ct2->ct2_credito)
                      CtbM01Tmp->_Custo  :=ct2->ct2_ccc
                      CtbM01Tmp->(msunlock())
                   endif   
                   ct2->(dbskip(1))
                enddo   
            endif
            _nValSusp:=0
            CtbM01Tmp->(dbseek(padr(_cContaAtu,len(_Conta)),.f.))
            @ li,09 PSAY "        Suspeitos:   Data   Lote   SubLote Documento Linha DC   Centro de custo               Valor"
            _fIncrLin()
            do while CtbM01Tmp->(!eof().and.alltrim(_MaskCta)==alltrim(_cContaAtu))
               if ascan(_vResConta,{|_vAux|alltrim(_vAux[1])==alltrim(CtbM01Tmp->_Custo)})==0
                  // Se chegou aqui, o lancamento e para um centro de custo vazio ou que nao figurou na planilha
                  _fIncrLin()
                  @ li,7 PSAY CtbM01Tmp->(_Conta+" "+dtoc(_Data)+" "+_Lote+" "+_SLote+"     "+_Doc+"    "+_Linha+"   "+_Dc+"    "+_Custo+" "+tran(_Valor,_cPictVal))
                  _nValSusp+=CtbM01Tmp->(_Valor*if(_Dc=="D",-1,1))
                endif
                CtbM01Tmp->(dbskip(1))
            enddo
            _fIncrLin()
            if _nValSusp==0
               @ li,17 PSAY "Nenhum lancamento suspeito foi identificado"
            else   
               @ li,22 PSAY padr("Saldo de lancamentos suspeitos:",72)+tran(_nValSusp,_cPictVal)
            endif   
            _fIncrLin()
         endif   
      endif   
      _vResConta :={}
      _cContaAtu :=SZK->ZK_conta
      _cDescConta:=SZK->ZK_contad
      _cPeriodo  :=SZK->(ZK_mes+"/"+ZK_ano)
      _nNivel    :=SZK->ZK_nivel
      _nSaldoGer :=_nSaldoCC:=0
   endif
   
   if _cCustoGer$SZK->ZK_custo
      SZK->(aadd(_vResConta,{ZK_custo,ZK_custoD,ZK_sldfim}))
      _nSaldoGer+=SZK->ZK_sldfim
   else
      _nSaldoCC +=SZK->ZK_sldfim
      if SZK->ZK_sldfim<>0
         SZK->(aadd(_vResConta,{ZK_custo,ZK_custoD,ZK_sldfim}))
      endif   
   endif   
   
   SZK->(dbskip(1))
enddo   
if _lGerouTmp
   CtbM01Tmp->(dbclosearea())
endif                   
roda(0,"",tamanho)

setregua(1)
incregua()                 

if aReturn[5]=1
   Set Printer To
   dbCommitAll()
   OurSpool(WnRel)
endif

return                         

*--------------------------------------------------------------------------
Static function _fIncrLin(_nIncr)
*--------------------------------------------------------------------------
if _nIncr==nil
   _nIncr:=1
endif
li+=_nIncr
if Li > 61
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
endif
return li

*---------------------------------------------------------------------------------------------------------------
user function CsCtbM4c()
* Alteracao do flag de reprocessamento
*---------------------------------------------------------------------------------------------------------------
_cPerg3:=PADR("CtbFla",LEN(SX1->X1_GRUPO))
validperg3(_cPerg3)
if pergunte(_cPerg3)
   _cAno :=strzero(mv_par01,4)
   _cMes :=strzero(mv_par02,2)
   _cReproc:=if(mv_par03==1,"S","N")
   msaguarde({||_fAltFlag()},"Alterando permissoes de reprocessamento")
   msgbox("Processamento concluido")
endif
*--------------------------------------------------------------------------------------------------------------------
Static Function _fAltFlag()
*--------------------------------------------------------------------------------------------------------------------
SZK->(dbseek(xfilial()+_cAno+_cMes,.t.))
do while SZK->(!eof().and.xfilial()==ZK_filial.and.ZK_ano==_cAno.and.ZK_mes==_cMes)
   msproctxt("Alterando: "+ZK_ano+"/"+ZK_mes+"-"+alltrim(ZK_conta)+"-"+alltrim(ZK_CUSTO))
   do while SZK->(!reclock(alias(),.f.))
   enddo
   SZK->ZK_reproc :=_cReproc
   SZK->(msunlock())
   SZK->(dbskip(1))
enddo
return

*--------------------------------------------------------------------------------------------------------------------
Static Function VALIDPERG1(_cPerg)
* Parametros para o Administrador
*--------------------------------------------------------------------------------------------------------------------
_cPerg:=PADR(_cPerg,len(sx1->x1_grupo))
aRegs := {}
             *   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
             *+---------------------------------------------------------------------------------------------------------------------------------+
             *¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
             *¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
             *¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
             *¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
             *¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
   AADD(aRegs,{_cPerg,"01","Contas contabeis   :","mv_ch1","N",01,0,0,"C","","mv_par01","De/Ate","","","Contidas"      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"02","Conta contabil de  :","mv_ch2","C",20,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","","CT1"})
   AADD(aRegs,{_cPerg,"03","Conta contabil ate :","mv_ch3","C",20,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","","CT1"})
   AADD(aRegs,{_cPerg,"04","Contida em         :","mv_ch4","C",60,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"05","Centros de custo   :","mv_ch5","N",01,0,0,"C","","mv_par05","De/Ate","","","Contidos","","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"06","Centro de custo de :","mv_ch6","C",20,0,0,"G","","mv_par06",""    ,"","",""      ,"","","","","","","","","","","CTT"})
   AADD(aRegs,{_cPerg,"07","Centro de custo ate:","mv_ch7","C",20,0,0,"G","","mv_par07",""    ,"","",""      ,"","","","","","","","","","","CTT"})
   AADD(aRegs,{_cPerg,"08","Contido em         :","mv_ch8","C",60,0,0,"G","","mv_par08",""    ,"","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"09","Considerar contas  :","mv_ch9","N",01,0,0,"C","","mv_par09","Todas","","",'Marc como "Sim"',"","","","","","","","","","",""})   
   AADD(aRegs,{_cPerg,"10","Centros de custo   :","mv_chA","N",01,0,0,"C","","mv_par10","Todos","","",'Marc como "Sim"',"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"11","Apagar registros reproc  :","mv_chB","N",01,0,0,"C","","mv_par11","Sim","","","Nao","","","","","","","","","","",""})
   
u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return

*--------------------------------------------------------------------------------------------------------------------
Static Function VALIDPERG2(_cPerg)
* Parametros para o Usuario
*--------------------------------------------------------------------------------------------------------------------
_cPerg:=PADR(_cPerg,len(sx1->x1_grupo))
aRegs := {}
             *   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
             *+---------------------------------------------------------------------------------------------------------------------------------+
             *¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
             *¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
             *¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
             *¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
             *¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
   AADD(aRegs,{_cPerg,"01","Ano                      :","mv_ch1","N",04,0,0,"G","","mv_par01","","","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"02","Mes de                   :","mv_ch2","N",02,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"03","Mes ate                  :","mv_ch3","N",02,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})   
u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
*--------------------------------------------------------------------------------------------------------------------
Static Function VALIDPERG3(_cPerg)
* Parametros para o Usuario
*--------------------------------------------------------------------------------------------------------------------
_cPerg:=PADR(_cPerg,len(sx1->x1_grupo))
aRegs := {}
             *   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
             *+---------------------------------------------------------------------------------------------------------------------------------+
             *¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
             *¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
             *¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
             *¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
             *¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
   AADD(aRegs,{_cPerg,"01","Ano                      :","mv_ch1","N",04,0,0,"G","","mv_par01","","","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"02","Mes                      :","mv_ch2","N",02,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"03","Alterar para       :","mv_ch3","N",01,0,0,"C","","mv_par03","Sim","","","Nao","","","","","","","","","","",""})
u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
*--------------------------------------------------------------------------------------------------------------------
Static Function VALIDPERG4(_cPerg)
* Parametros para o relatorio de apuracao de diferencas
*--------------------------------------------------------------------------------------------------------------------
_cPerg:=PADR(_cPerg,len(sx1->x1_grupo))
aRegs := {}
             *   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
             *+---------------------------------------------------------------------------------------------------------------------------------+
             *¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
             *¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
             *¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
             *¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
             *¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
   AADD(aRegs,{_cPerg,"01","Ano                      :","mv_ch1","N",04,0,0,"G","","mv_par01","","","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"02","Mes de                   :","mv_ch2","N",02,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"03","Mes ate                  :","mv_ch3","N",02,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})   
   AADD(aRegs,{_cPerg,"04","Exibir                   :","mv_ch4","N",01,0,0,"C","","mv_par04","Tudo","","","Somente diferencas","","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"05","Listar lanctos suspeitos :","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","Nao","","","","","","","","","","",""})
u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDEF  º Autor ³Eduardo de Souza    º Data ³12/Jan/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Implementa menu funcional                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menus                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//³    3 - Duplica o registro corrente do Banco de Dados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MenuDef()
Local aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Param ADM","u_CsCtbm4a(_cParAdm)",0,3} ,;
             {"Param Usuario","u_CsCtbm4a(_cParUsr)",0,3} ,;
             {"Totalizacao","u_CsCtbm4a(_cGeraTot)",0,3} ,;
             {"Gera a planilha","u_CsCtbm4a(_cGeraPlan)",0,4},;
             {"Permissao reproc","u_CsCtbm4c()",0,4},;             
             {"Relat diferencas","u_CsCtbm4b()",0,4}}
Return aRotina

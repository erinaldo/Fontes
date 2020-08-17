#include "rwmake.ch"

*-------------------------------------------------------------------------------------------------------------
user function CsGpeM08()
* Exportacao do arquivo Unimed (inclusoes/exclusoes)
* Ricardo Luiz da Rocha 06/04/2005 GNSJC
* Procedimento para a implantacao: 
*    -Criacao do diretorio "Unimed" sob "ap_data"
*    -Inclusao e compilacao deste fonte, disponibilizacao no menu do usuario
*    -Criacao dos campos RA_CSUNIIN,RB_CSUNIIN,RA_CSUNIEX,RB_CSUNIEX  C 1, "V"isualizar
*    -Criacao do campo RA_CSDTCAS D 8 - Data de casamento - Logo após o estado civil
*-------------------------------------------------------------------------------------------------------------
private _cErroStru,_lTemErro:=.f.,_cPerg:='GpeM08',_nHdl:=0,_cSepCampo,_cTimeIni,_vLog:={},;
        _cMascCpf:="@R 999.999.999-99",_cMascVal:="@er 999,999.99",;
        _cCodEmpUP:='00004255',; // Codigo da empresa na Unimed Paulistana
        _cCodEmPUS:='0333' // Codigo na Unimed Singular
        
validperg(_cPerg)
pergunte(_cPerg,.f.)

@ 100,091 To 315,580 Dialog oBase Title OemToAnsi("Exportacao de registros para inclusao /exclusao na Unimed")
@ 012,016 Say u__fAjTxt('Esta rotina realizara a exportacao do arquivo para a Unimed, contendo')
@ 022,016 Say u__fAjTxt('dados para a inclusao e/ou exclusao de titulares e seus dependentes do plano Csu.')
@ 032,016 Say u__fAjTxt('O escopo de registros a exportar sera definido pelos parametros, bem ')
@ 042,016 Say u__fAjTxt("como o diretorio e nome do arquivo de destino. A exportacao ainda ")
@ 052,016 Say u__fAjTxt("estara restrita aos funcionarios da empresa corrente, ("+alltrim(sm0->m0_nome)+").")

@ 090,020 BmpButton Type 1 Action _fProssegue()
@ 090,090 BmpButton Type 5 Action _fPar()
@ 090,160 BmpButton Type 2 Action _fSair()

Activate Dialog oBase centered

sra->(dbclearfil())
sra->(retindex(alias()))
srb->(retindex(alias()))

Return

*-------------------------------------------------------------------------------------------------------------
static Function _fProssegue
*-------------------------------------------------------------------------------------------------------------
cursorwait()

_cDirTxt  :=alltrim(mv_par01) // Diretorio
_lTodos   :=(mv_par02==2) // 1=Nao exportados;2=Todos
_dDataIni :=mv_par03 // Admitidos / Demitidos de
_dDataFim :=mv_par04 // Admitidos / Demitidos ate
_cFiliIni:=mv_par05 // Filial de
_cFiliFim:=mv_par06 // Filial ate
_cFilDesp:=alltrim(mv_par07)

if right(_cDirTxt,1)<>"\"
   _cDirTxt+="\"
endif

_cNomTxt  :="UP"+substr(_cCodEmpUP,5)+_fDataExt(date())
_cSeq:='001'
do while file(_cDirTxt+_cNomTxt+"."+_cSeq)
   _cSeq:=soma1(_cSeq)
enddo
_cNomTxt+="."+_cSeq

if empty(_cNomTxt)
   msgbox('O nome do arquivo de destino nao foi informado')
   cursorarrow()
   return
endif
if file(_cDirTxt+_cNomTxt).and.!msgyesno("O arquivo "+_cDirTxt+_cNomTxt+" ja existe, deseja substitui-lo ?")
   cursorarrow()
   return
endif
if (_nHdl:=fcreate(_cDirTxt+_cNomTxt,0))==-1
   msgbox('Erro na criacao do arquivo texto: '+_cDirTxt+_cNomTxt)
   cursorarrow()
   return
endif
_cTimeIni:=+dtoc(date())+" "+time()+" h"
_vItens:={}

u_RsAguarde({||_fExporta()},'Inicio: '+_cTimeIni)

if _lTemErro
   MsgBox("Erro na exportacao","Erro","STOP")
Else
   MsgBox("Concluido, Inicio: "+_cTimeIni+"     Fim: "+dtoc(date())+" "+time()+" h" ,"Informacao","INFO")
EndIf
cursorarrow()
if len(_vLog)>0
   _fImpLog()
endif       

_fSair()

return
*------------------------------------------------------------------------------
static function _fExporta
*------------------------------------------------------------------------------
cursorwait()

u_rsproctxt("Preparando os dados para a exportacao")
_cQuebral:=chr(13)+chr(10)
_cHoraIni:=time()
_lTemErro:=.f.
_nRegGrav:=0

_cFiltro:="ra_filial>='"+_cFiliIni+"'.and.ra_filial<='"+_cFiliFim+"'"
_cFiltro+=".and.(dtos(ra_admissa)>='"+dtos(_dDataIni)+"'.and.dtos(ra_admissa)<='"+dtos(_dDataFim)+"'"
_cFiltro+=".or.(dtos(ra_demissa)>='"+dtos(_dDataIni)+"'.and.dtos(ra_demissa)<='"+dtos(_dDataFim)+"'))"

srb->(dbsetorder(1))
sra->(indregua(alias(),criatrab(,.f.),_cOrdem:=indexkey(),,_cFiltro))
sra->(dbgotop())
_nFuncIn:=_nDepIn:=_nFuncEx:=_nDepEx:=0
_cMen1:=_cMen2:=_cMen3:=_cMen4:=""
_nSeqU02:=_nSeqU03:=0
_nSeqUniq:=1
_lGravouCab:=.f.

do while sra->(!eof())
   _cFilial:=sra->ra_filial
   _cMen1:="Filial: "+_cFilial+" - Titular: "+sra->ra_nome
   
   if _cFilial$_cFilDesp.and.!empty(_cFilial) // Despreza o registro
      _cMens1:="Ignorar registros da filial "+_cFilial+" - "+sra->ra_nome
   else
      // Determina o plano do usuario
      _cPlano:=upper(alltrim(posicione("SRX",1,xfilial("SRX")+"22  "+sra->ra_asmedic,"rx_txt")))
      _cCodPlan:=""
      if "MASTER"$_cPlano.or."ADM M"$_cPlano
         _cCodPlan:="7002"
         _cPlano:="Master"
      elseif "PLENO"$_cPlano.or."ADM P"$_cPlano
         _cCodPlan:="7001"
         _cPlano:="Pleno"
      elseif "BASICO"$_cPlano.or."ADM B"$_cPlano
         _cCodPlan:="7000"
         _cPlano:="Basico"
      endif   
      
      if !empty(_cCodPlan)

         _cChapa:=sra->ra_mat
         _cNome:=sra->ra_nome
         _cCcusto:=sra->ra_cc
         _cDescCC:=posicione("CTT",1,xfilial("CTT")+sra->ra_cc,"ctt_desc01")
         _cTitDep:="Titular   "
         _cAdmissa:=dtoc(sra->ra_admissa)
         _cDataEnf:=_fDataExt(sra->ra_csdtcas) // data do casamento
         _dVencExp:=sra->ra_admissa+89

         _cMen2:=""
         _cMen3:="Titulares exportados (Inclusoes): "+alltrim(str(_nFuncIn))+"  Dependentes: "+alltrim(str(_nDepIn))
         _cMen4:="Titulares exportados (Exclusoes): "+alltrim(str(_nFuncEx))+"  Dependentes: "+alltrim(str(_nDepEx))

         _lInclui:=_lExclui:=.f.
         if sra->ra_sitfolh<>'D'
            if _lTodos.or.empty(sra->ra_csuniin)
               _lInclui:=.t.
            endif
         else
            if _lTodos.or.empty(sra->ra_csuniex)
               _lExclui:=.t.
            endif
         endif

         // Caso o funcionario esteja no contrato de experiencia, e seja caso de inclusao,
         // esta somente ocorrera se o mes de expiracao do prazo de experiencia for igual ou
         // anterior ao corrente.
         if _lInclui
            _cNivel:=alltrim(posicione("SRJ",1,xfilial("SRJ")+sra->ra_codfunc,'rj_nivel'))
            if _cNivel$"O#OC"
               _dVencExp:=sra->ra_admissa+89
               if left(dtos(_dVencExp),6)>left(dtos(ddatabase),6)
                  _lInclui:=.f.
               endif
            endif
         endif

         if _lInclui.and._lExclui
            // despreza o registro
            _lInclui:=_lExclui:=.f.
         endif

         if _lInclui.or._lExclui
            // Caso a data de nascimento nao esteja informada, rejeita o registro
            if empty(sra->ra_nasc)
               aadd(_vLog,_cFilial+" "+_cChapa+" "+padr(_cNome,49)+" "+_cCcusto+" "+left(_cDescCC,37)+" "+_cTitDep+" "+left(_cFuncao,36)+" "+_cAdmissa+" "+dtoc(_dVencExp)+" "+dtoc(sra->ra_demissa)+" "+dtoc(sra->ra_nasc)+" "+padr(_cPlano,6)+" "+'(Rejeicao)')
               _lInclui:=_lExclui:=.f.
            endif
         endif   

         if _lExclui
            _lInclui:=.f.
         endif

         if _lInclui.or._lExclui
            if !_lGravouCab
               _lGravouCab:=.t.
               // Gravacao do Registro U01 Identificador da empresa
               _fGravaCab()
            endif

            _cFuncao:=posicione("SRJ",1,xfilial("SRJ")+sra->ra_codfunc,"rj_desc")
            aadd(_vLog,_cFilial+" "+_cChapa+" "+padr(_cNome,49)+" "+_cCcusto+" "+left(_cDescCC,37)+" "+_cTitDep+" "+left(_cFuncao,36)+" "+_cAdmissa+" "+dtoc(_dVencExp)+" "+dtoc(sra->ra_demissa)+" "+dtoc(sra->ra_nasc)+" "+padr(_cPlano,6)+" "+if(_lExclui,'(Exclusao)','(Inclusao)'))
            // Criacao do registro do funcionario

            _cCampo001:=strzero(_nSeqUniq++,6)
            _cCampo002:='U02'
            _nSeqU02++
            _cCampo003:=if(_lExclui,'E','I')
            _cCampo004:=_cCodEmpUP
            _cCampo005:='000'+sra->ra_cic
            _cCampo006:=space(20)
            _cCampo007:=space(10)
            _cCampo008:='00'
            _cCampo009:=space(1)
            _cCampo010:=padr(_fLimpa(sra->ra_nome),30)
            _cCampo011:='0'
            _cCampo012:=sra->ra_sexo
            _cCampo013:='00'
            _cCampo014:=_fDataExt(sra->ra_nasc)                     

            _cEstCivil:=sra->ra_estcivi
            if _cEstCivil=="S"
               _cEstCivil:="0"
            elseif _cEstCivil=="C"
               _cEstCivil:="1"
            elseif _cEstCivil=="Q"
               _cEstCivil:="2"
            else
               _cEstCivil:="6"
            endif

            _cCampo015:=_cEstCivil
            if _cEstCivil=='1'.and.empty(_cDataEnf)
               _cDataEnf:='11111111'
            endif   
               
            _cCampo016:=_cDataEnf
            _cCampo017:=space(20)
            _cCampo018:=space(10)
            _cCampo019:=space(05)
            _cCampo020:=space(20)
            _cCampo021:='00000'
            _cCampo022:=padl(alltrim(sra->ra_codfunc),8,'0')
            _cCampo023:=_fDataExt(sra->ra_admissa)
            _cCampo024:=_fDataExt(sra->ra_admissa)
            
            _cCampo025:=_fDataExt(ddatabase)

            if _lInclui
               _cCampo026:=space(len(_fDataExt(sra->ra_demissa)))
            else
               _cCampo026:=_fDataExt(sra->ra_demissa)
            endif

            _cGravar:=""
            for _nVez:=1 to 26
                _cComando:="_cGravar+=_cCampo"+strzero(_nVez,3)
                _x:=&_cComando
            next
            fwrite(_nHdl,_cGravar+_cQuebral)
            
            // Registro U03 - Plano do usuario
            _cCampo001:=strzero(_nSeqUniq++,6)
            _cCampo002:='U03'
            _nSeqU03++
            _cCampo003:=if(_lExclui,'E','I')
            _cCampo004:=_cCodEmpUP
            _cCampo005:='000'+sra->ra_cic
            _cCampo006:='00'
            _cCampo007:='000000'+_cCodPlan
            _cCampo008:=_fDataExt(sra->ra_admissa)
            
            if _lExclui
               _cCampo009:=_fDataExt(sra->ra_demissa)
            else
               _cCampo009:=space(8)
            endif
            _cCampo010:=space(2)

            _cGravar:=""
            for _nVez:=1 to 10
                _cComando:="_cGravar+=_cCampo"+strzero(_nVez,3)
                _x:=&_cComando
            next
            fwrite(_nHdl,_cGravar+_cQuebral)
            
         endif
         _cMen2:=chr(255)
         // Dados dos dependentes
         _lTemDep:=.f.
         srb->(dbseek(sra->(ra_filial+ra_mat),.f.))
         do while srb->(!eof().and.rb_filial+rb_mat==sra->(ra_filial+ra_mat))
            _cMen2:="Dependente: "+srb->rb_nome
            _lIncluiDep:=_lExcluiDep:=.f.
         
            if sra->ra_sitfolh<>'D'
               if _lTodos.or.empty(srb->rb_csuniin)
                  if srb->rb_assimed=="S"
                     _lIncluiDep:=.t.
                  endif   
               endif
            else
              if _lTodos.or.empty(srb->rb_csuniex)
                 _lExcluiDep:=.t.
               endif
            endif
      
            if _lExcluiDep
               _lIncluiDep:=.f.
            endif   
            
            if _lIncluiDep.or._lExcluiDep            
               // Caso a data de nascimento nao esteja informada, rejeita o registro
               if empty(srb->rb_dtnasc)
                  aadd(_vLog,_cFilial+" "+_cChapa+" "+padr(_cNome,49)+" "+_cCcusto+" "+left(_cDescCC,37)+" "+_cTitDep+" "+left(_cFuncao,36)+" "+_cAdmissa+" "+space(len(dtoc(_dVencExp)+" "+dtoc(sra->ra_demissa)))+" "+dtoc(srb->rb_dtnasc)+" "+padr(_cPlano,6)+" "+'(Rejeicao)')
                  _lIncluiDep:=_lExcluiDep:=.f.
               endif
            endif
         
            if _lIncluiDep.or._lExcluiDep
               if !_lGravouCab
                  _lGravouCab:=.t.
                  // Gravacao do Registro U01 Identificador da empresa
                  _fGravaCab()
               endif

               _lTemDep:=.t.
               _cChapa:=srb->rb_mat
               _cNome:=srb->rb_nome
               _cTitDep:="Dependente"
               _cAdmissa:=space(len(dtoc(sra->ra_admissa)))
               _cCcusto:=space(len(_cCCusto))
               _cDescCC:=space(len(_cDescCC))
               _cFuncao:=padr(u_fX3cBox("RB_GRAUPAR",srb->rb_graupar),len(srj->rj_desc))

               aadd(_vLog,_cFilial+" "+_cChapa+" "+padr(_cNome,49)+" "+_cCcusto+" "+left(_cDescCC,37)+" "+_cTitDep+" "+left(_cFuncao,36)+" "+_cAdmissa+" "+space(len(dtoc(_dVencExp)+" "+dtoc(sra->ra_demissa)))+" "+dtoc(srb->rb_dtnasc)+" "+padr(_cPlano,6)+" "+if(_lExclui,'(Exclusao)','(Inclusao)'))

               _cCampo001:=strzero(_nSeqUniq++,6)
               _cCampo002:='U02'
               _nSeqU02++
               _cCampo003:=if(_lExclui,'E','I')
               _cCampo004:=_cCodEmpUP
               _cCampo005:='000'+sra->ra_cic
               _cCampo006:=space(20)
               _cCampo007:=space(10)
               _cCampo008:=srb->rb_cod
               _cCampo009:=space(1)
               _cCampo010:=padr(_fLimpa(srb->rb_nome),30)
               _cCampo011:='1'
               _cCampo012:=srb->rb_sexo
               
               _cCampo013:=srb->rb_graupar

               if _cCampo013=='C'
                  _cCampo013:='01'
               elseif _cCampo013=='F'
                  _cCampo013:='10'
               elseif _cCampo013=='O'
                  _cCampo013:='70'
               endif
                
               _cCampo014:=_fDataExt(srb->rb_dtnasc)

               if srb->rb_graupar=="C"
                  _cEstCivil:="1"
               else
                 _cEstCivil:="0"
               endif

               if _cEstCivil=='1'.and.empty(_cDataEnf)
                  _cDataEnf:='11111111'
               endif   
      
               _cCampo015:=_cEstCivil
               _cCampo016:=_cDataEnf
               _cCampo017:=space(20)
               _cCampo018:=space(10)
               _cCampo019:=space(05)
               _cCampo020:=space(20)
               _cCampo021:='00000'
               _cCampo022:=space(8)
               _cCampo023:=_fDataExt(sra->ra_admissa)
               _cCampo024:=_fDataExt(sra->ra_admissa)
               _cCampo025:=_fDataExt(ddatabase)
               
               if _lIncluiDep
                  _cCampo026:=space(len(_fDataExt(sra->ra_demissa)))
               else
                  _cCampo026:=_fDataExt(sra->ra_demissa)
               endif

               _cGravar:=""
               for _nVez:=1 to 26
                   _cComando:="_cGravar+=_cCampo"+strzero(_nVez,3)
                   _x:=&_cComando
               next
               
               fwrite(_nHdl,_cGravar+_cQuebral)
               
               // Registro U03 - Plano do usuario
               _cCampo001:=strzero(_nSeqUniq++,6)
               _cCampo002:='U03'
               _nSeqU03++
               _cCampo003:=if(_lExclui,'E','I')
               _cCampo004:=_cCodEmpUP
               _cCampo005:='000'+sra->ra_cic
               _cCampo006:='00'
               _cCampo007:='000000'+_cCodPlan
               _cCampo008:=_fDataExt(sra->ra_admissa)
            
               if _lExclui
                  _cCampo009:=_fDataExt(sra->ra_demissa)
               else
                  _cCampo009:=space(8)
               endif
               _cCampo010:=space(2)

               _cGravar:=""
               for _nVez:=1 to 9
                   _cComando:="_cGravar+=_cCampo"+strzero(_nVez,3)
                   _x:=&_cComando
               next
               fwrite(_nHdl,_cGravar+_cQuebral)
               
               do while srb->(!reclock(alias(),.f.))
               enddo
               if _lIncluiDep
                  srb->rb_csuniin:="X"
                  _nDepin++
               endif
               if _lExcluiDep
                  srb->rb_csuniex:="X"
                  _nDepEx++
               endif
               srb->(msunlock())
            endif

            u_rsproctxt(_cMen1+_cQuebral+_cMen2+_cQuebral+_cMen3+_cQuebral+_cMen4)

            srb->(dbskip(1))
         enddo
         if _lTemDep
            aadd(_vLog," ")
         endif
         do while sra->(!reclock(alias(),.f.))
         enddo
         if _lInclui
            sra->ra_csuniin:="X"
            _nFuncIn++
         endif
         if _lExclui
            sra->ra_csuniex:="X"
            _nFuncEx++
         endif
         sra->(msunlock())
      endif
   endif
   sra->(dbskip(1))
   u_rsproctxt(_cMen1+_cQuebral+_cMen2+_cQuebral+_cMen3+_cQuebral+_cMen4)   
enddo    

if _lGravouCab
   _cCampo001:=strzero(_nSeqUniq++,6)
   _cCampo002:='U09'
   _cCampo003:=strzero(_nSeqU02,6)
   _cCampo004:=strzero(_nSeqU03,6)
   _cCampo005:='000000'
   _cCampo006:=strzero(_nFuncIn+_nDepIn,6)
   _cCampo007:=strzero(_nFuncEx+_nDepEx,6)
   _cCampo008:='000000'
   _cGravar:=""
   for _nVez:=1 to 8
       _cComando:="_cGravar+=_cCampo"+strzero(_nVez,3)
       _x:=&_cComando
   next
               
   fwrite(_nHdl,_cGravar)
   aadd(_vLog,"")
   aadd(_vLog,"Totais  - Inclusoes  -  Funcionarios  - "+str(_nFuncIn)+"  Dependentes  - "+str(_nDepIn))
   aadd(_vLog,"          Exclusoes  -  Funcionarios  - "+str(_nFuncEx)+"  Dependentes  - "+str(_nDepEx))
endif

fclose(_nHdl)
return

*-------------------------------------------------------------------------
static function _fLimpa(_cLimpar)
*-------------------------------------------------------------------------
local _vTrocar:={",",".","-","/","_"},_nVez,_vTrocar2:={{"Ç","C"},;
                                                        {"Ã","A"},;
                                                        {"É","E"},;
                                                        {"Ú","U"},;
                                                        {"Ê","E"},;
                                                        {"Ú","U"},;
                                                        {"Á","A"},;
                                                        {"Ô","O"},;
                                                        {"Í","I"},;
                                                        {"Â","A"},;
                                                        {"Ú","U"}},;
      _cCaractEsp,_cCaractPad,_nPosic
_cLimpar:=upper(alltrim(_cLimpar))
for _nVez:=1 to len(_vTrocar)
   _cLimpar:=strtran(_cLimpar,_vTrocar[_nVez]," ")
next
_cLimpar:=upper(alltrim(_cLimpar))
do while at("  ",_cLimpar)>0
   _cLimpar:=strtran(_cLimpar,"  "," ")
enddo

for _nVez:=1 to len(_cLimpar)
    _cCaractEsp:=substr(_cLimpar,_nVez,1)
    if (_nPosic:=ascan(_vTrocar2,{|_vAux|_vAux[1]==_cCaractEsp}))>0
       _cCaractPad:=_vTrocar2[_nPosic][2]
       _cLimpar:=strtran(_cLimpar,_cCaractEsp,_cCaractPad)
    endif
next

return _cLimpar      

*-------------------------------------------------------------------------
static function _fDataExt(_dData)
*-------------------------------------------------------------------------
local _cReturn:=dtos(_dData)
_cReturn:=right(_cReturn,2)+substr(_cReturn,5,2)+left(_cReturn,4)
return _cReturn                                

*-------------------------------------------------------------------------
static function _fImpLog()
*-------------------------------------------------------------------------

nLastKey  :=0
limite    :=220
wnrel     :=nomeprog:="CsGpeM08"
cDesc1    :="Log de exportacao - Inclusoes e exclusoes no plano Unimed"
cDesc2    :=" "
cDesc3    :=" "
cString   :="SRA"
tamanho   := "G"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     :=99
m_pag     :=1
Li        :=0
Cabec1:="Fl Matric Nome                                              Centro de custo      Descricao                             Tit/Dep    Funcao / Grau de parentesco          Admissao Carencia Demissao  Nascto  Plano   Inc/Exc"
Cabec2:=""   
cursorarrow()
wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
if nLastkey==27
   set filter to
   return
endif
cursorwait()

RptStatus({|| RptDetail() })
cursorarrow()
*-------------------------------------------
Static function rptdetail
*-------------------------------------------
setdefault(aReturn,cString)
setregua(len(_vLog))
_nLin:=99
_cUltimo:=_vLog[1]
for _nVez:=1 to len(_vLog)
    incregua()
    if _nLin>58
       Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
       _nLin:=li+1
    endif
    @ _nLin++,0 PSAY _vLog[_nVez]
next

roda(0,"",tamanho)

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return

return

*--------------------------------------------------------------------------
static function _fGravaCab
*--------------------------------------------------------------------------
_lGravouCab:=.t.
// Gravacao do Registro U01 Identificador da empresa
_cCampo001:=strzero(_nSeqUniq++,6)
_cCampo002:='U01'
_cCampo003:=_cCodEmpUS // Codigo na Unimed singular
_cCampo004:=_cCodEmpUP // Codigo da empresa na Unimed Paulistana
_cCampo005:=padr(sm0->m0_nomecom,40)
_cCampo006:=sm0->m0_cgc
_cCampo007:='1' // Identificacao por CPF
_cCampo008:='02B'
_cCampo009:=_fDataExt(date())
_cCampo010:=space(12)

_cGravar:=""
for _nVez:=1 to 10
   _cComando:="_cGravar+=_cCampo"+strzero(_nVez,3)
   _x:=&_cComando
next
fwrite(_nHdl,_cGravar+_cQuebral)

return

*-------------------------------------------------------------
// Funcoes para controle de fluxo do programa
*-------------------------------------------------------------

static function _fPar
pergunte(_cPerg,.t.)
return

static function _fSair
//close(oBase)
return

*--------------------------------------------------------------------------------
Static Function VALIDPERG(_cPerg)
*--------------------------------------------------------------------------------

local aRegs := {}
          *   1    2            3                   4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
          *+------------------------------------------------------------------------------------------------------------------------------------+
          *¦G    ¦ O  ¦ PERGUNT                 ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
          *¦ R   ¦ R  ¦                         ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
          *¦  U  ¦ D  ¦                         ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
          *¦   P ¦ E  ¦                         ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
          *¦    O¦ M  ¦                         ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
AADD(aRegs,{_cPerg,"01","Diretorio                    :","mv_ch1","C",30,0,0,"G","","mv_par01",""    ,"C:\Unimed","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Registros a exportar         :","mv_ch2","N",01,0,0,"C","","mv_par02","Nao exportados"    ,"","","Todos"      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"03","Admitidos / Demitidos de     :","mv_ch3","D",08,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"04","Admitidos / Demitidos ate    :","mv_ch4","D",08,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"05","Filial de                    :","mv_ch5","C",02,0,0,"G","","mv_par05",""    ,"","",""      ,"","","","","","","","","","","SM0"})
AADD(aRegs,{_cPerg,"06","Filial ate                   :","mv_ch6","C",02,0,0,"G","","mv_par06",""    ,"","",""      ,"","","","","","","","","","","SM0"})
AADD(aRegs,{_cPerg,"07","Nao incluir filial(ais)      :","mv_ch7","C",30,0,0,"G","","mv_par07",""    ,"","",""      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return

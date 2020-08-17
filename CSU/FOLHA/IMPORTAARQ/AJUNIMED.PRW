#include "rwmake.ch"

*-------------------------------------------------------------------------------------------------------------
user function AjUnimed()
* Comparacao e ajuste da base de dados Unimed x Csu
* Ricardo Luiz da Rocha 18/05/2005 GNSJC
* Procedimento para a implantacao: 
*    -Copia do arquivo UNIMED.DBF em \sigaadv
*    -Inclusao e compilacao deste fonte em ambiente paralelo SISTEMAS
* Repassar com o usuario as regras definidas na funcao fMenPlano()
* Backup da tabela SRB da empresa envolvida
* Tabelas do sistema envolvidas: SRA,SRB,SRJ,SQ3
*-------------------------------------------------------------------------------------------------------------
private _cPerg:='AjUnim',_vLog:={},_oDlg,;
_cDetFun:="sra->('Filial: '+ra_filial+' Matricula: '+ra_mat+' Nome: '+ra_nome+' CPF: '+ra_cic+' Admissao: '+dtoc(ra_admissa)+' Demissao: '+dtoc(ra_demissa)+' Cargo: '+ra_cargo+' - '+posicione('SQ3',1,xfilial('SQ3')+ra_cargo,'left(Q3_DESCSUM,30)')+' Funcao: '+ra_codfunc+' - '+posicione('SRJ',1,xfilial('SRJ')+ra_codfunc,'left(rj_desc,40)')+' Nascimento: '+dtoc(ra_nasc))",;
_cDetDep:="srb->('Filial: '+rb_filial+' Matricula: '+rb_mat+' Sequencia: '+rb_cod+' Nome: '+rb_nome+' Parentesco: '+u_fX3CBox('RB_GRAUPAR',RB_GRAUPAR))"
_vExcluir:={}
dbusearea(.t.,,"excluir",,.t.,.f.)
do while excluir->(!eof())
   excluir->(aadd(_vExcluir,filial_+matric_))
   excluir->(dbskip(1))
enddo   
excluir->(dbclosearea())
validperg(_cPerg)

@ 100,091 To 310,530 Dialog _oDlg Title OemToAnsi("Comparacao e ajuste da base de dados Unimed x Csu")
@ 005,160 Say u__fAjTxt('OS 1066/05')

@ 020,010 Button 'Compara/atualiza' size 90,15 Action _fCompara()
@ 045,010 Button 'Gera planilha dependentes' size 90,15 Action _fGeraDep()
@ 070,010 Button 'Importa planilha dependentes' size 90,15 Action _fImpDep()
@ 085,120 bmpbutton type 5 action _fPar()    
@ 085,160 bmpbutton type 2 action _fSair()    

Activate Dialog _oDlg centered
sra->(retindex(alias()))
srb->(retindex(alias()))
Return

*-------------------------------------------------------------------------------------------------------------
static Function _fCompara
*-------------------------------------------------------------------------------------------------------------
_nLenOcor:=40
cursorwait()
pergunte(_cPerg,.f.)
_dAdmiIni  :=mv_par01 // Data de admissao de
_dAdmiFim  :=mv_par02 // Data de admissao ate
_cFiliIni  :=mv_par03 // Filial de
_cFiliFim  :=mv_par04 // Filial ate
_lAtualiza :=(mv_par05==1) // Atualiza automaticamente 1=Sim;2=Nao
_lSortLog  :=(mv_par06==1) // Agrupar Log
_lMostraCertos:=(mv_par07==1)
_vLog:={}
dbusearea(.t.,,"unimed",,.t.,.f.)
_nCerto:=_nErrado:=_nCorrigiu:=_nNCorrigiu:=0
u_RsAguarde({||_fComp1()},'Fase 1 - Unimed x Microsiga')
u_RsAguarde({||_fComp2()},'Fase 2 - Microsiga x Unimed')

aadd(_vLog,"")
aadd(_vLog,"Registros Corretos: "+alltrim(str(_nCerto))+" Incorretos: "+alltrim(str(_nErrado))+;
           " Corrigidos: "+alltrim(str(_nCorrigiu))+" Nao corrigidos: "+alltrim(str(_nNCorrigiu)))

_fImpLog()

unimed->(dbclosearea())
_fSair()

return

*------------------------------------------------------------------------------
static function _fcomp1()
* Verifica se o funcionario no plano unimed estao com a situacao correta no
* sistema microsiga.
*------------------------------------------------------------------------------
sra->(retindex())
srb->(retindex())
srx->(dbsetorder(1))
if srx->(dbseek("  22            22       ",.f.).and.reclock(alias(),.f.))
   srx->rx_txt:="UNIMED DIF PL X MST  "+substr(srx->rx_txt,21)
   srx->(msunlock())
endif

unimed->(dbclearind())
_cFiltro:="RA_FILIAL>='"+_cFiliIni+"'.and.RA_FILIAL<='"+_cFiliFim+"'"
_cFiltro+=".and.dtos(RA_admissa)>='"+dtos(_dAdmiIni)+"'.and.dtos(RA_ADMISSA)<='"+dtos(_dAdmiFim)+"'"
_cOrdem:="RA_CIC+dtos(ra_admissa)"
sra->(IndRegua(alias(),CriaTrab(,.F.),_cOrdem,,_cFiltro))

_cFiltro:="cpf_>0.and.empresa==4275"
_cOrdem:='cpf+strzero(sequencia_,10)+sit+dtos(data_excl)'
unimed->(IndRegua(alias(),CriaTrab(,.F.),_cOrdem,,_cFiltro))
_cUltUnim:="/"+alltrim(str(unimed->(lastrec())))
unimed->(dbgotop())
_nJafoi:=0
do while unimed->(!eof())

   _cCpf:=unimed->cpf
   _cSeq:=unimed->(strzero(sequencia_,2))
   do while unimed->(!eof().and.cpf==_cCpf.and.strzero(sequencia_,2)==_cSeq)
      unimed->(dbskip(1))
   enddo
   unimed->(dbskip(-1))
   // Esta e a ultima ocorrencia do mesmo cpf e sequencia no arquivo
   _dDataExcl:=unimed->data_excl
   _lAtivoU:=upper(alltrim(unimed->sit))=="ATIVO"
   // Agora, localizar no sistema microsiga o registro correspondente
   // a ultima ocorrencia pelo CPF+data de admissao
   _cCpfUnimed:=substr(unimed->cpf,4)
   _cDetUnimed:="unimed->(' Situacao: '+sit+' Nome: '+nome+' Sequencia: '+strzero(sequencia_,2)+' - '+parentesco+' Nascimento: '+dtoc(data_nasc)+' Cpf: '+cpf+' Plano: '+alltrim(str(plano)))"
   u_RsProctxt("Registro na Unimed: "+alltrim(str(_nJafoi++))+_cUltUnim+chr(13)+chr(10)+&_cDetUnimed)

   _cMens:=_cMensPlano:=""
   sra->(dbseek(_cCpfUnimed,.f.))
   do while sra->(!eof().and.ra_cic==_cCpfUnimed)
      sra->(dbskip(1))
   enddo
   sra->(dbskip(-1))

   _lAchou:=(sra->ra_cic==_cCpfUnimed)

   _cPlano:=upper(posicione("SRX",1,xFilial("SRX")+"22"+xFilial("SRA")+sra->ra_asmedic,'SUBS(SRX->RX_TXT,1,20)'))
   if alltrim(_cPlano)=="DIFER PL X MASTER".or.alltrim(_cPlano)=="DIF PLENO X MASTER"
      _cPlano+=" UNIMED"
   endif
   if empty(_cPlano)
      _cPlano:=upper(posicione("SRX",1,xFilial("SRX")+"22"+"  "+sra->ra_asmedic,'SUBS(SRX->RX_TXT,1,20)'))
   endif
   _lAtivoS:=.f.

   if empty(sra->ra_demissa).and.ascan(_vExcluir,sra->(ra_filial+ra_mat))==0 // se estiver demitido, ou pertencer a lista de exclusoes, desprezar a informacao
      if _lAchou
         _lAtivoS:=sra->(empty(ra_demissa)).and."UNIMED"$_cPlano
  
         if (_lFunc:=(unimed->sequencia_==0))

            if _lAtivoU.and._lAtivoS
               _cMens:="Certo  - Ativo Unimed e Microsiga "+&_cDetfun
               _cMensPlano:=_fMenPlano(_cPlano,unimed->plano)
               _nCerto++
               /*
               if sra->ra_nasc<>unimed->data_nasc
                  _nErrado++
                  aadd(_vLog,_cMens)
                  _cMens:="Errado - Ativo Unimed e Microsiga, mas a data de nascimento nao confere. Data Unimed: "+dtoc(unimed->data_nasc)+' Data microsiga: '+dtoc(sra->ra_nasc)+' '+&_cDetfun
               endif   
               */
            elseif _lAtivoU.and.!_lAtivoS
               if empty(sra->ra_asmedic).or.sra->ra_asmedic=="17"
                  if _lAtualiza
                     do while sra->(!reclock(alias(),.f.))
                     enddo
                     sra->ra_asmedic:="01"
                     sra->(msunlock())
                     _cMens:="Corrigido ..Ativo Unimed e agora tambem Microsiga (Plano01) "+' '+&_cDetFun
                     _nCorrigiu++
                  else
                     _cMens:="Nao corrigido - Ativo Unimed e Inativo microsiga: "+&_cDetFun
                     _nNCorrigiu++
                  endif
               else
                  _cMens:="Errado - Ativo   Unimed e inativo Microsiga "+&_cDetfun
                  _nErrado++
               endif
            elseif !_lAtivoU.and._lAtivoS
               _cMens:="Errado - Inativo Unimed e Ativo Microsiga "+&_cDetfun
               _nErrado++
            elseif !_lAtivoU.and.!_lAtivoS
               _cMens:="Certo  - Inativo Unimed e Microsiga "+&_cDetfun
               _nCerto++
            endif

         else
            // tratamento para os dependentes. SRA esta posicionado
            // Primeiro localiza o dependente, considera o nome e a data de nascimento
            srb->(dbseek(sra->(ra_filial+ra_mat),.f.))
            _lAchouDep:=.f.
            do while srb->(!eof().and.rb_filial+rb_mat==sra->(ra_filial+ra_mat))
               _cNomeS:=_fLimpa(srb->rb_nome)
               _cNomeU:=_fLimpa(unimed->nome)
               if _fCompNom(_cNomeS,_cNomeU)
                  _lAchouDep:=.t.
                  exit
               endif
               srb->(dbskip(1))
            enddo
         
            if _lAchouDep  
               _lAtivoDep:=(srb->RB_ASSIMED=="S".and._lAtivoS)
               if _lAtivoU.and._lAtivoDep
                  _cMens:="Certo  - Ativo Unimed e Microsiga "+&_cDetDep
                  _nCerto++
                  /*if unimed->data_nasc<>srb->rb_dtnasc
                     if _lAtualiza
                        do while srb->(!reclock(alias(),.f.))
                        enddo
                        srb->rb_dtnasc:=unimed->data_nasc
                        srb->(msunlock())
                        _cMens:="Corrigido - Data de nascimento Unimed e agora tambem Microsiga "+dtoc(unimed->data_nasc)+' '+&_cDetDep
                        _nCorrigiu++
                     else
                        _cMens:="Nao corrigido - Data de nascimento Unimed: "+dtoc(unimed->data_nasc)+' microsiga: '+dtoc(srb->rb_dtnasc)+' '+&_cDetDep
                        _nNCorrigiu++
                     endif   
                 endif
                       */
                 if empty(srb->rb_dtnasc)
                    _cMens:="Errado: Data de nascimento em branco "+&_cDetDep
                 endif
               elseif _lAtivoU.and.!_lAtivoDep
                  if _lAtualiza
                  //   do while srb->(!reclock(alias(),.f.))
                  //   enddo
                  //   srb->rb_assimed:="S"
                   //  srb->(msunlock())
                   //  _cMens:="Corrigido -."+alltrim(str(unimed->(recno())))+" Ativo Unimed e agora tambem Microsiga "+&_cDetDep
                    // _nCorrigiu++
                  else
                     _cMens:="Nao corrigido -."+alltrim(str(unimed->(recno())))+" Ativo Unimed e inativo Microsiga "+&_cDetDep
                     _nNCorrigiu++
                  endif
               elseif !_lAtivoU.and._lAtivoDep
                  if _lAtualiza
                     do while srb->(!reclock(alias(),.f.))
                     enddo
                     srb->rb_assimed:="N"
                     srb->(msunlock())
                     _cMens:="Corrigido - ... recunimed = "+alltrim(str(unimed->(recno())))+" Inativo Unimed e agora tambem Microsiga "+&_cDetDep
                     _nCorrigiu++
                  else
                     _cMens:="Nao corrigido - Inativo Unimed e Ativo Microsiga "+&_cDetDep
                     _nNCorrigiu++
                  endif
               elseif !_lAtivoU.and.!_lAtivoDep
                  _cMens:="Certo  - Inativo Unimed e Microsiga "+&_cDetDep
                  _nCerto++
               endif   
            endif
         endif

      else
        if _lAtivoU
           _cMens:="Errado - Ativo Unimed e nao encontrado Microsiga "+&_cDetUnimed
           _nErrado++
        else
           _cMens:="Certo  - Inativo Unimed e nao encontrado Microsiga "+&_cDetUnimed
           _nCerto++
        endif
      endif
   endif
   
   if !empty(_cMens)
      aadd(_vLog,_cMens)
   endif
   if !empty(_cMensPlano)
      aadd(_vLog,_cMensPlano)
   endif
   unimed->(dbskip(1))
enddo

*------------------------------------------------------------------------------
static function _fcomp2()
* Verifica se os funcionarios e dependentes ativos microsiga como Unimed 
* constam no arquivo fornecido pela Unimed
*------------------------------------------------------------------------------
sra->(retindex())
srb->(retindex())
unimed->(dbclearind())

_cFiltro:="RA_FILIAL>='"+_cFiliIni+"'.and.RA_FILIAL<='"+_cFiliFim+"'"
_cFiltro+=".and.dtos(RA_admissa)>='"+dtos(_dAdmiIni)+"'.and.dtos(RA_ADMISSA)<='"+dtos(_dAdmiFim)+"'"
_cOrdem:=sra->(indexkey())
sra->(IndRegua(alias(),CriaTrab(,.F.),_cOrdem,,_cFiltro))

_cFiltro:="cpf_>0.and.empresa==4275"
_cOrdem:='cpf+strzero(sequencia_,10)+sit+dtos(data_excl)'
unimed->(IndRegua(alias(),CriaTrab(,.F.),_cOrdem,,_cFiltro))

//_cDetFun:="sra->('Filial: '+ra_filial+' Matricula: '+ra_mat+' Nome: '+ra_nome+' CPF: '+ra_cic+' Admissao: '+dtoc(ra_admissa)+' Demissao: '+dtoc(ra_demissa)+' Cargo: '+ra_cargo+' - '+posicione('SQ3',1,xfilial('SQ3')+sra->ra_cargo,'left(Q3_DESCSUM,30)')+' Funcao: '+sra->ra_codfunc+' - '+posicione('SRJ',1,xfilial('SRJ')+sra->ra_codfunc,'left(rj_desc,40)')+' Nascimento: '+dtoc(sra->ra_nasc))"
//_cDetDep:="srb->('Filial: '+rb_filial+' Matricula: '+rb_mat+' Sequencia: '+rb_cod+' Nome: '+rb_nome+' Parentesco: '+u_fX3CBox('RB_GRAUPAR',RB_GRAUPAR))"

_cUltSiga:="/"+alltrim(str(sra->(lastrec())))

sra->(dbgotop())
_nJafoi:=0
do while sra->(!eof())
   u_RsProctxt("Registro microsiga: "+alltrim(str(_nJafoi++))+_cUltSiga+chr(13)+chr(10)+&_cDetFun)
   _cMens:=""
   if !empty(sra->ra_cic).and.empty(sra->ra_demissao).and.ascan(_vExcluir,sra->(ra_filial+ra_mat))==0 // Se nao possuir cpf, estiver demitido ou constar na lista de exclusoes, desprezar a informacao
      _cPlano:=upper(posicione("SRX",1,xFilial("SRX")+"22"+xFilial("SRA")+sra->ra_asmedic,'SUBS(SRX->RX_TXT,1,20)'))

      if alltrim(_cPlano)=="DIFER PL X MASTER"
         _cPlano+=" UNIMED"
      endif
      if empty(_cPlano)
         _cPlano:=upper(posicione("SRX",1,xFilial("SRX")+"22"+"  "+sra->ra_asmedic,'SUBS(SRX->RX_TXT,1,20)'))
      endif

      if (_lAtivoS:=sra->(empty(ra_demissa)).and."UNIMED"$_cPlano)
         _cCpfSiga:="000"+sra->ra_cic
         
         if unimed->(!dbseek(_cCpfSiga,.f.))
            _cMens:="Errado - Ativo microsiga e nao localizado .y. Unimed "+&_cDetfun
            aadd(_vLog,_cMens)
            _nErrado++
         else
            if unimed->sequencia_>0
               // Mesmo tendo localizado o CPF em Unimed, o registro pode nao ser do titular
               _cMens:="Errado - Ativo microsiga e nao localizado .z. Unimed "+&_cDetfun
               aadd(_vLog,_cMens)
               _nErrado++
            endif   
                     
            // Achou o CPF em Unimed, agora verificar os dependentes DESTE funcionario posicionado em SRA
            srb->(dbseek(sra->(ra_filial+ra_mat),.f.))

            do while srb->(!eof().and.rb_filial+rb_mat==sra->(ra_filial+ra_mat))
            
               if srb->rb_assimed=="S"
                  _lAchouDep:=.f.           

                  unimed->(dbseek(_cCpfSiga,.f.))
                  do while unimed->(!eof().and.cpf==_cCpfSiga)
                     _cNomeS:=_fLimpa(srb->rb_nome)
                     _cNomeU:=_fLimpa(unimed->nome)
                     if _fCompNom(_cNomeS,_cNomeU)
                        _lAchouDep:=.t.
                        exit
                     endif
                     unimed->(dbskip(1))
                  enddo
                  if !_lAchouDep
                     _cMens:="Errado - Ativo microsiga e nao localizado .x. Unimed "+&_cDetDep
                     aadd(_vLog,_cMens)
                     _nErrado++
                  endif
               endif
               srb->(dbskip(1))
            enddo
         endif
      endif
   endif
   sra->(dbskip(1))
enddo

return                        

*-------------------------------------------------------------------------
static function _fImpLog()
*-------------------------------------------------------------------------

nLastKey  :=0
limite    :=220
wnrel     :=nomeprog:="AjUnimed"
cDesc1    :="Log de comparacao e correcao - Unimed x microsiga"
cDesc2    :=" "
cDesc3    :=" "
cString   :="SRA"
tamanho   := "G"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
//aReturn   := { "Zebrado", 1,"Administracao",2, 1,"UnimedRic",'',0 }
_nLin     :=99
m_pag     :=1
Li        :=0
Cabec1:=""
Cabec2:=""   

wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
if nLastkey==27
   set filter to
   return
endif
if _lSortLog
   asort(_vLog)  
endif

RptStatus({|| RptDetail() })
cursorarrow()
*-------------------------------------------
Static function rptdetail
*-------------------------------------------
setdefault(aReturn,cString)
setregua(len(_vLog))
_nLin:=99
for _nVez:=1 to len(_vLog)
    incregua()
    if _nLin>=58
       Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
       _nLin:=li+2
    endif
    if !_lMostraCertos.and."certo"$lower(left(_vLog[_nVez],10))
    else
       _cLinha:=_vLog[_nVez]
       do while at("  ",_cLinha)>0
          _cLinha:=strtran(_cLinha,"  "," ")
       enddo
       _nLinhas:=mlcount(_cLinha,220)
       for _nVezLinha:=1 to _nLinhas
          @ _nLin++,0 PSAY memoline(_cLinha,220,_nVezLinha)
       next
       if _nLinhas>1
          _nLin++
       endif
    endif
next

roda(0,"",tamanho)

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return

*--------------------------------------------------------------------------------------
static function _fMenPlano(_cPlanoS,_nPlanoU)                 
* Valores unimed: 7000 = Basico
*                 7001 = Pleno
*                 7002 = Master
*--------------------------------------------------------------------------------------
local _cReturn:=""
_cPlanoS:=upper(alltrim(_cPlanoS))
if _nPlanoU==7000
   if "BASICO"$_cPlanoS.or.alltrim(_cPlanoS)=="UNIMED ESTAG ADM B"
      _cReturn:="Certo  - Plano Unimed 7000 (Basico) - Plano microsiga: "+_cPlanoS+&_cDetFun
   else
      _cReturn:="Errado - Plano Unimed 7000 (Basico) - Plano microsiga: "+_cPlanoS+&_cDetFun
   endif
elseif _nPlanoU==7001      
   if "PLENO"$_cPlanoS.or.alltrim(_cPlanoS)=="UNIMED ESTAG ADM P"
      _cReturn:="Certo  - Plano Unimed 7001 (Pleno) - Plano microsiga: "+_cPlanoS+&_cDetFun
   else
      _cReturn:="Errado - Plano Unimed 7001 (Pleno) - Plano microsiga: "+_cPlanoS+&_cDetFun
   endif
elseif _nPlanoU==7002
   if "MASTER"$_cPlanoS.or.alltrim(_cPlanoS)=="UNIMED ESTAG ADM M"
      _cReturn:="Certo  - Plano Unimed 7002 (Master) - Plano microsiga: "+_cPlanoS+&_cDetFun
   else
      _cReturn:="Errado - Plano Unimed 7002 (Master) - Plano microsiga: "+_cPlanoS+&_cDetFun
   endif
endif   

return _cReturn

*-------------------------------------------------------------
// Funcoes para controle de fluxo do programa
*-------------------------------------------------------------

static function _fPar
pergunte(_cPerg,.t.)
return

static function _fSair
//close(_oDlg)
return

*--------------------------------------------------------------------------------
Static Function _fLimpa(_cNome)
*--------------------------------------------------------------------------------
local _nVez,_cLido,_cReturn:="",_cPermit:=" ABCDEFGHIJKLMNOPQRSTUVWXYZ"
_cNome:=alltrim(upper(_cNome))
_cNome:=strtran(_cNome,"  "," ")

for _nVez:=1 to len(_cNome)
    _cLido:=substr(_cNome,_nVez,1)
    if _cLido$_cPermit
       _cReturn+=_cLido
    endif
next

return _cReturn
      
*-------------------------------------------------------------------------------------------------------------
static Function _fGeraDep
* Apenas os registros que, partindo da base unimed localizem o funcionario correspondente microsiga
* serao considerados
*-------------------------------------------------------------------------------------------------------------
cursorwait()
pergunte(_cPerg,.f.)
_dAdmiIni  :=mv_par01 // Data de admissao de
_dAdmiFim  :=mv_par02 // Data de admissao ate
_cFiliIni  :=mv_par03 // Filial de
_cFiliFim  :=mv_par04 // Filial ate
_lAtualiza :=(mv_par05==1) // Atualiza automaticamente 1=Sim;2=Nao
_lSortLog  :=(mv_par06==1) // Agrupar Log
_lMostraCertos:=(mv_par07==1)
_vLog:={}
dbusearea(.t.,,"unimed",,.t.,.f.)

_vStruct:={{"Filial","C",2,0},;
              {"Matricula","C",6,0},;
              {"CPF","C",14,0},;
              {"Titular","C",50,0},;
              {"U_DepNom","C",50,0},;
              {"U_DepSeq","N",2,0},;
              {"u_dtnasc","D",8,0},;
              {"u_incluir","C",1,0},;
              {"S_DepNom","C",50,0},;
              {"S_DepSeq","N",2,0},;
              {"S_dtnasc","D",8,0},;
              {"S_asmedic","C",1,0}}

dbcreate("plandep",_vStruct)
dbusearea(.t.,,"plandep",,.t.,.f.)              
              
u_RsAguarde({||_fGerade1()},'Gerando a planilha de dependentes')

unimed->(dbclosearea())
plandep->(dbclosearea())

_fSair()

return

*--------------------------------------------------------------------------------
Static Function _fCompNom(_cNome1,_cNome2)
* retorna verdadeiro para nomes onde o primeiro e ultimo nome batem,
* ou a diferenca nao seja mais que 2 caracteres
*--------------------------------------------------------------------------------
local _lReturn:=.f.,_nVez,_nLen,_nDiferentes:=0

if _cNome1==_cNome2
   return .t.
endif

_cPreNome1:=alltrim(left(_cNome1,at(' ',_cNome1)))
_cSobNome1:=alltrim(substr(_cNome1,rat(' ',_cNome1)))

_cPreNome2:=alltrim(left(_cNome2,at(' ',_cNome2)))
_cSobNome2:=alltrim(substr(_cNome2,rat(' ',_cNome2)))
if _cPreNome1==_cPreNome2.and._cSobNome1==_cSobNome2
   _lReturn:=.t.
else
  // Conta quantos caracteres estao diferentes                                                   
  _cNome1:=_cPreNome1+_cSobNome1
  _cNome2:=_cPreNome2+_cSobNome2
  _nLen:=max(len(_cNome1),len(_cNome2))
  _cNome1:=padr(_cNome1,_nLen)
  _cNome2:=padr(_cNome2,_nLen)
  for _nVez:=1 to _nLen
      if substr(_cNome1,_nVez,1)<>substr(_cNome2,_nVez,1)
         _nDiferentes++
      endif
  next
  if _nDiferentes<=2
     _lReturn:=.t.
  endif
endif

return _lReturn

*------------------------------------------------------------------------------
static function _fGeraDe1()
* gravacao dos registros da planilha
*------------------------------------------------------------------------------

sra->(retindex())
srb->(retindex())
unimed->(dbclearind())
_cFiltro:="RA_FILIAL>='"+_cFiliIni+"'.and.RA_FILIAL<='"+_cFiliFim+"'"
_cFiltro+=".and.dtos(RA_admissa)>='"+dtos(_dAdmiIni)+"'.and.dtos(RA_ADMISSA)<='"+dtos(_dAdmiFim)+"'"
_cOrdem:="RA_CIC+dtos(ra_admissa)"
sra->(IndRegua(alias(),CriaTrab(,.F.),_cOrdem,,_cFiltro))

_cFiltro:='cpf_>0'
_cOrdem:='cpf+strzero(sequencia_,10)+sit+dtos(data_excl)'                   
unimed->(IndRegua(alias(),CriaTrab(,.F.),_cOrdem,,_cFiltro))                                     
_cUltUnim:="/"+alltrim(str(unimed->(lastrec())))
unimed->(dbgotop())
_nJafoi:=0
do while unimed->(!eof())
    
    do while unimed->(!eof().and.sequencia_<>0)
       u_RsProcTxt("Nome na Unimed: "+unimed->nome+chr(13)+alltrim(str(_nJafoi++))+_cUltUnim)
       unimed->(dbskip(1))
    enddo   
   _cCpf:=unimed->cpf
   _lAtivoU:=.f.
   _cTitular:=""
   do while unimed->(!eof().and.cpf==_cCpf.and.sequencia_==0)
      _lAtivoU:=upper(alltrim(unimed->sit))=="ATIVO"
      _cTitular:=upper(alltrim(unimed->nome))
      u_RsProcTxt("Nome na Unimed: "+unimed->nome+chr(13)+alltrim(str(_nJafoi++))+_cUltUnim)
      unimed->(dbskip(1))
   enddo
   if !_lAtivoU
      u_RsProcTxt("Nome na Unimed: "+unimed->nome+chr(13)+alltrim(str(_nJafoi++))+_cUltUnim)
      unimed->(dbskip(1))
   else   
      _vRecUni:={}
      do while unimed->(!eof().and.cpf==_cCpf)
         _cSeq:=unimed->(strzero(sequencia_,2))
         // O registro atual e de dependente, cujo titular esta ativo      
         do while unimed->(!eof().and.cpf==_cCpf.and.strzero(sequencia_,2)==_cSeq)
            u_RsProcTxt("Nome na Unimed: "+unimed->nome+chr(13)+alltrim(str(_nJafoi++))+_cUltUnim)
            unimed->(dbskip(1))
         enddo
         _nJafoi--
         unimed->(dbskip(-1))

         // Esta e a ultima ocorrencia do mesmo cpf e sequencia no arquivo
         if (_lAtivoU:=upper(alltrim(unimed->sit))=="ATIVO")
            unimed->(aadd(_vRecUni,{nome,sequencia_,data_nasc}))
         endif   
         u_RsProcTxt("Nome na Unimed: "+unimed->nome+chr(13)+alltrim(str(_nJafoi++))+_cUltUnim)
         unimed->(dbskip(1))
      enddo
      // Agora, criar os registros correspondentes microsiga
      _cCpfUnimed:=substr(_cCpf,4)
      sra->(dbseek(_cCpfUnimed,.f.))
      do while sra->(!eof().and.ra_cic==_cCpfUnimed)
         sra->(dbskip(1))
      enddo
      sra->(dbskip(-1))

      if (_lAchou:=(sra->ra_cic==_cCpfUnimed))
         _cPlano:=upper(posicione("SRX",1,xFilial("SRX")+"22"+xFilial("SRA")+sra->ra_asmedic,'SUBS(SRX->RX_TXT,1,20)'))

         if alltrim(_cPlano)=="DIFER PL X MASTER"
            _cPlano+=" UNIMED"
         endif

         if empty(_cPlano)
            _cPlano:=upper(posicione("SRX",1,xFilial("SRX")+"22"+"  "+sra->ra_asmedic,'SUBS(SRX->RX_TXT,1,20)'))
         endif
         _lAtivoS:=sra->(empty(ra_demissa)).and."UNIMED"$_cPlano
         
         if _lAtivoS
      
            _vRecSiga:={}
            srb->(dbseek(sra->(ra_filial+ra_mat)))
            do while srb->(!eof().and.rb_filial+rb_mat==sra->(ra_filial+ra_mat))
               srb->(aadd(_vRecSiga,{rb_nome,val(rb_cod),rb_dtnasc,rb_assimed}))
               srb->(dbskip(1))
            enddo

            // Ambos os vetores estao prontos, agora, preenche eventuais linhas faltantes entre um e outro
            _nLenMax:=max(len(_vRecUni),len(_vRecSiga))
            for _nVez:=1 to _nLenMax
                if len(_vRecUni)<_nVez
                   aadd(_vRecUni,{'',0,ctod('')})
                endif   
                if len(_vRecSiga)<_nVez
                   aadd(_vRecSiga,{'',0,ctod(''),' '})
                endif   
            next
                          
            for _nVez:=1 to _nLenMax
               plandep->(reclock(alias(),.t.))
               plandep->Filial   :=sra->ra_filial
               plandep->Matricula:=sra->ra_mat
               plandep->CPF      :=sra->ra_cic
               plandep->Titular  :=sra->ra_nome
               plandep->U_DepNom :=_vRecUni[_nVez][1]
               plandep->U_DepSeq :=_vRecUni[_nVez][2]
               plandep->u_dtnasc :=_vRecUni[_nVez][3]
               plandep->u_incluir:=' '
               plandep->S_DepNom :=_vRecSiga[_nVez][1]
               plandep->S_DepSeq :=_vRecSiga[_nVez][2]
               plandep->S_dtnasc :=_vRecSiga[_nVez][3]
               plandep->S_asmedic:=_vRecSiga[_nVez][4]

               Plandep->(msunlock())
            next   
            _lSepara:=.t.
            if _lSepara
               // Cria o separador
               plandep->(reclock(alias(),.t.))
            
               plandep->Filial   :=repl("-",len(plandep->filial))
               plandep->Matricula:=repl("-",len(plandep->matricula))
               plandep->CPF      :=repl("-",len(plandep->cpf))
               plandep->Titular  :=repl("-",len(plandep->titular))
               plandep->U_DepNom :=repl("-",len(plandep->u_depnom))
               //plandep->U_DepSeq :=0
               //plandep->u_dtnasc :=ctod('')  
               plandep->u_incluir:=repl("-",len(plandep->u_incluir))
               plandep->S_DepNom :=repl("-",len(plandep->s_depnom))
               //plandep->S_DepSeq :=
               //plandep->S_dtnasc :=
               plandep->S_asmedic:=repl("-",len(plandep->s_asmedic))
               Plandep->(msunlock())
            endif   
         endif
      endif
   endif      
enddo      
msgbox("Concluido")   

*--------------------------------------------------------------------------------
Static Function VALIDPERG(_cPerg)
*--------------------------------------------------------------------------------

local aRegs := {}
          *   1    2            3                   4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
          *+--------------------------------------------------------------------------------------------------------------------------------------------+
          *¦G    ¦ O  ¦ PERGUNT                         ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
          *¦ R   ¦ R  ¦                                 ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
          *¦  U  ¦ D  ¦                                 ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
          *¦   P ¦ E  ¦                                 ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
          *¦    O¦ M  ¦                                 ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
AADD(aRegs,{_cPerg,"01","Data de admissao de          :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Data de admissao ate         :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"03","Filial de                    :","mv_ch3","C",02,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"04","Filial ate                   :","mv_ch4","C",02,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"05","Corrigir se possivel         :","mv_ch5","N",01,0,0,"C","","mv_par05","Sim"    ,"","","Nao"      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"06","Agrupar Log por ocorrencia   :","mv_ch6","N",01,0,0,"C","","mv_par06","Sim"    ,"","","Nao"      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"07","Exibir corretos no log       :","mv_ch7","N",01,0,0,"C","","mv_par07","Sim"    ,"","","Nao"      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return

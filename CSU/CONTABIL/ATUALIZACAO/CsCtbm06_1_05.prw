#include "rwmake.ch"
             
*-------------------------------------------------------------------------------------------------------------
user function CsCtbM06()
* Distribuicao de lancamentos contabeis
* Ricardo Luiz da Rocha 30/09/2004 GNSJC
*
* Procedimento para implantacao da versao revista:
* -Remocao do campo CT2_CSKEYO nas empresas 02,03,04 e 09
* -Criacao dos campos CT2_CSKEY1 (C - 19) 
*                     CT2_CSKEY2 (C - 09) 
*                     CT2_CSKEY3 (C - 40) 
*                     nas mesmas empresas de destino
* -Criacao do indice complementar:
*   CT2_FILIAL+CT2_CSKEY1+CT2_DC+CT2_DEBITO+CT2_CREDIT+CT2_CCD+CT2_CCC+CT2_CSKEY3
*   Chave para referencia da distribuicao de lancamentos contabeis
* 28/09/2005 - Ricardo - Retirar o recurso de sintetizacao - OS 3046/05
*-------------------------------------------------------------------------------------------------------------
private _cPerg:=PADR("CtbM06",LEN(SX1->X1_GRUPO)),_vDestino,_cQuebral:=chr(13)+chr(10),;
        _nIndNum:=16,; // Numero do indice para referencia da distribuicao
        _cMen1:=_cMen2:=" ",_cFiltroLp:="508/510/509/515/520/527/530/531/620/635/801/802/803/805/806/807/810/811/812/814/815/816/820/825/830",_lExecutou
_cMen2:=" "
validperg(_cPerg)
pergunte(_cPerg,.f.)

@ 100,091 To 285,527 Dialog oBase Title OemToAnsi("Distribuicao de lancamentos contabeis")
@ 012,016 Say u__fAjTxt('Esta rotina realizara a distribuicao de lancamentos contabeis')
@ 022,016 Say u__fAjTxt('da empresa 05 para 02, 03, 04, 07 e 09')
    
@ 075,020 BmpButton Type 1 Action _fProssegue()
@ 075,090 BmpButton Type 5 Action _fPar()
@ 075,160 BmpButton Type 2 Action _fSair()
Activate Dialog oBase centered
ct2->(retindex(alias()))
Return

*-------------------------------------------------------------------------------------------------------------
static Function _fProssegue
*-------------------------------------------------------------------------------------------------------------
if sm0->m0_codigo<>"05"
   msgbox("Esta rotina apenas pode ser executada a partir da empresa 05 (Csu Cardsystem)")
   return
endif   

_dDataIni :=mv_par01
_dDataFim :=mv_par02

_cTimeIni:=+dtoc(date())+" "+time()+" h"

u_RsAguarde({||_fDistribui()},'Inicio: '+_cTimeIni)
_fSair()

return
*------------------------------------------------------------------------------
static function _fDistribui()
*------------------------------------------------------------------------------
cursorwait()

_vDestino:={"02",;
            "03",;
            "04",;
            "07",;
            "09"}             

// Abertura dos arquivos
_lContinua:=.t.
_lExecutou:=.f.
for _nVez:=1 to len(_vDestino)
    _cEmp:=_vDestino[_nVez]+"0"
    _cCt2:="CT2"+_cEmp
    _cSx2:="SX2"+_cEmp
    _cSx3:="SX3"+_cEmp
    _cSix:="SIX"+_cEmp
    u_Rsproctxt("Abrindo as tabelas de destino: "+_cCt2)    
    sx2->(dbclosearea())
    sx3->(dbclosearea())
    six->(dbclosearea())

    dbusearea(.T.,"DBFCDX",_cSx2,"SX2",.T.,.F.)
    dbsetindex(_cSx2)
    
    dbusearea(.T.,"DBFCDX",_cSx3,"SX3",.T.,.F.)
    dbsetindex(_cSx3)
    
    dbusearea(.T.,"DBFCDX",_cSix,"SIX",.T.,.F.)
    dbsetindex(_cSix)

    chkfile("CT2",.f.,_cCt2)

    //chkfile("CT2",.t.,_cCt2)
    if alias()<>_cCt2
       msgbox("Falha na abertura de "+_cCt2)
       _lContinua:=.f.
    endif

    //_cOrdem:="ct2_cskey1+ct2_dc+ct2_debito+ct2_credit+ct2_ccd+ct2_ccc"

    //IndRegua(alias(),_cArqInd:=criatrab(,.f.),_cOrdem,,_cFiltro:=nil)
    
next

sx2->(dbclosearea())
sx3->(dbclosearea())
six->(dbclosearea())

_cEmp:="050"
_cSx2:="SX2"+_cEmp
_cSx3:="SX3"+_cEmp
_cSix:="SIX"+_cEmp

dbusearea(.T.,"DBFCDX",_cSx2,"SX2",.T.,.F.)
dbsetindex(_cSx2)

dbusearea(.T.,"DBFCDX",_cSx3,"SX3",.T.,.F.)
dbsetindex(_cSx3)

dbusearea(.T.,"DBFCDX",_cSix,"SIX",.T.,.F.)
dbsetindex(_cSix)

if !_lContinua
   _fFechaDest()
   return
endif                                         

/*
// Primeiro elimina eventuais lancamentos existentes nos destinos no periodo solicitado

for _nVez:=1 to len(_vDestino)
    _cEmp:=_vDestino[_nVez]+"0"
    _cCt2:="CT2"+_cEmp
    u_RsProctxt(_cMen1:="Eliminando lancamentos existentes no destino: "+_cEmp)
    dbselectarea(_cCt2)
    if alias()<>_cCt2
       msgbox("Falha na eliminacao de registros existentes em: "+_cCt2)
       _lContinua:=.f.
       exit
    endif
    _cFilDest:="01"
    dbseek(_cFilDest+dtos(_dDataIni),.t.)

    _nRecDel:=0
    do while !eof().and.ct2_data<=_dDataFim
       _cMen2:="Data: "+dtoc((alias())->ct2_data)+" excluidos: "+alltrim(str(++_nRecDel))
       u_Rsproctxt(_cMen1+chr(10)+_cMen2)
       reclock(_cCt2,.f.)
       dbdelete()
       msunlock()
       dbskip()
    enddo
next

if !_lContinua
   _fFechaDest()
   return
endif
*/
_vLog:={}
ct2->(dbsetorder(1)) // CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
_cFiltro:="dtos(ct2_data)>='"+dtos(_dDataIni)+"'.and.dtos(ct2_data)<='"+dtos(_dDataFim)+"'.and.ct2_csudc<>'S'"
_cFiltro+=".and.Ct2_lp<='999'"
ct2->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
ct2->(dbgotop())
_nLidos:=_nDistribuidos:=_nSintetizados:=0
_vCamposOrig:=ct2->(dbstruct())
_vHistAglut:={}
do while ct2->(!eof())
   _cKeyAtu:=ct2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC)
   _vRefDoc:={}
   _cCtaHist:=ct2->(ct2_credit+ct2_ccc)
   do while ct2->(!eof().and.CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC==_cKeyAtu)
      if ct2->ct2_dc$"12"
         _cCtaHist:=ct2->(ct2_credit+ct2_ccc)
      endif   
      _cFilDest:="01"
      _nLidos++
      _cDestino:=substr(ct2->ct2_origem,at(chr(1),ct2->ct2_origem)+1,2)
      _cCt2:="CT2"+_cDestino+"0"
      if ascan(_vDestino,_cDestino)==0
         // Destino invalido, o lancamento nao sera distribuido
         aadd(_vLog,"Destino invalido: ["+_cDestino+"] Filial: ["+ct2->(ct2_filial+"] Data: ["+dtoc(ct2_data)+"] Lote:["+ct2_lote+"] SubLote: ["+ct2_sblote+"] Documento: ["+ct2_doc+"] Linha: ["+ct2_linha+"] Origem: ["+ct2_origem+"]"))
      else
         // Se chegou aqui, o registro devera ser distribuido
         // Verificar se deve ser criado um novo registro ou incrementar um existente
         Dbselectarea(_cCt2)
         if alias()<>_cCt2
            msgbox("Falha na distribuicao do lancamento "+ct2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA))
            _lContinua:=.f.
            exit
         endif
         dbsetorder(_nIndNum) // ct2_filial+ct2_cskey1+ct2_dc+ct2_debito+ct2_credit+ct2_ccd+ct2_ccc
         _cChave:=ct2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+ct2_dc+ct2_debito+ct2_credit+ct2_ccd+ct2_ccc)+u_CalcOrig(ct2->ct2_origem)
         _cOrigem:=u_CalcOrig(ct2->ct2_origem)

         _cKeyHist:=_cOrigem+ct2->ct2_dc+_cCtaHist+_cDestino+ct2->ct2_seqhis
         _lSintetiza:=.t. 
         
         
         // As linhas abaixo "desligam" o recurso de sintetizacao
         _lSintetiza:=.f.
         _vHistAglut:={}
         
         if _lSintetiza.and.ct2->ct2_lp$_cFiltroLp.and.ct2->ct2_dc=="2".and.dbseek(_cFilDest+_cChave,.f.)
            // Aqui, incrementa no registro pre-existente
            _nDistribuidos++
            _nSintetizados++
            if ct2->ct2_valor<>0
               _nValor:=ct2->ct2_valor

               reclock(_cCt2,.f.)
               _cComando:=alias()+"->ct2_valor+=_nValor"
               _x:=&_cComando

               msunlock()

            endif
         elseif ascan(_vHistAglut,_cKeyHist)==0
            // Aqui, cria um novo registro no CT2 da empresa de destino
            dbsetorder(1)
            _SbLote:="001"
            if (_nPosic:=ascan(_vRefDoc,{|_vAux|_vAux[1]==_cDestino}))==0
               // Calcula um novo numero de documento
               _cDoc:="000001"
               
               if dbseek(_cFilDest+ct2->(DTOS(CT2_DATA)+CT2_LOTE)+_SbLote,.f.)
                  dbseek(_cFilDest+ct2->(DTOS(CT2_DATA)+CT2_LOTE)+soma1(_SbLote),.t.)
                  dbskip(-1)
                  _cRegOrig:="ct2->(_cFilDest+dtos(ct2_data)+CT2_LOTE+_SBLOTE)"
                  _cRegOrig:=&_cRegOrig
                  _cRegDest:=alias()+"->(ct2_filial+DTOS(CT2_DATA)+CT2_LOTE)+ct2_SbLote"
                  _cRegDest:=&_cRegDest
                  _nLocaliz:=0
                  do while !bof().and._cRegOrig<>_cRegDest
                     u_RsProcTxt("Localizando documento para a Origem: "+ct2->ct2_filial+substr(_cRegOrig,3)+" "+alltrim(str(++_nLocaliz)))
                     dbskip(-1)
                     _cRegOrig:="ct2->(_cFilDest+dtos(ct2_data)+CT2_LOTE+_SBLOTE)"
                     _cRegOrig:=&_cRegOrig
                     _cRegDest:=alias()+"->(ct2_filial+DTOS(CT2_DATA)+CT2_LOTE+ct2_SbLote)"
                     _cRegDest:=&_cRegDest
                  enddo

                  if _cRegOrig<>_cRegDest
                     _lContinua:=.f.
                     msgbox("Falha na localizacao do ultimo documento. Origem: "+ct2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA))
                     exit
                  else
                     _cDoc:=alias()+"->ct2_doc"
                     _cDoc:=&_cDoc
                     _cDoc:=soma1(_cDoc)
                  endif
               else
                  _cDoc:="000001"
               endif
               aadd(_vRefDoc,{_cDestino,_cDoc,"001"})
               _nPosic:=len(_vRefDoc)
            endif
            _cDoc:=_vRefDoc[_nPosic][2]
            _Linha:=_vRefDoc[_nPosic][3]
            _vRefDoc[_nPosic][3]:=soma1(_Linha)
            _nDistribuidos++

            reclock(_cCt2,.t.)
            _lExecutou:=.t.
            for _nVezCpo:=1 to fcount()
                _cCampo:=fieldname(_nVezCpo)
                if ascan(_vCamposOrig,{|_vAux|alltrim(upper(_vAux[1]))==alltrim(_cCampo)})>0
                   _cComando:=_cCt2+"->"+_cCampo+":=ct2->"+_cCampo
                   _x:=&_cComando
                endif
             next
             // Tratamento especial para os campos abaixo

             _cComando:=_cCt2+"->ct2_filial:=_cFilDest"
             _x:=&_cComando

             _cComando:=_cCt2+"->ct2_sblote:='"+_sbLote+"'"
             _x:=&_cComando

             _cComando:=_cCt2+"->ct2_doc:=_cDoc"
             _x:=&_cComando

             _cComando:=_cCt2+"->ct2_linha:='"+_Linha+"'"
             _x:=&_cComando

             /*
             _cComando:=_cCt2+"->ct2_sequen:='"+_Sequen+"'"
             _x:=&_cComando

             _cComando:=_cCt2+"->ct2_seqlan:='"+_SeqLan+"'"
             _x:=&_cComando
             */
             _cComando:=_cCt2+"->ct2_empori:='"+_cDestino+"'"
             _x:=&_cComando
    
             _cComando:=_cCt2+"->ct2_filori:=_cFilDest"
             _x:=&_cComando
          
             _cComando:=_cCt2+"->ct2_cskey1:=ct2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE)"
             _x:=&_cComando

             _cComando:=_cCt2+"->ct2_cskey2:=ct2->(CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC)"
             _x:=&_cComando

             _cComando:=_cCt2+"->ct2_cskey3:=_cOrigem"
             _x:=&_cComando

             msunlock()
          endif
          // Atualiza o flag em CT2 origem
          _vAmbAtu:=getarea()
          ct2->(reclock(alias(),.f.))
          ct2->ct2_csudc:="S"
          ct2->ct2_cskey3:=u_CalcOrigem(ct2->ct2_origem)
          ct2->(msunlock())
          restarea(_vAmbAtu)

          // Caso tenha sido historico relativo a Credito, armazena a linha para evitar duplicidade na hipotese de ter sido aglutinado
          if ct2->ct2_dc=="4".and.!empty(_cCtaHist).and.ct2->ct2_lp$_cFiltroLp
             aadd(_vHistAglut,_cKeyHist)
          endif

      endif
      _cMen1:="Distribuindo lancamentos de: "+dtoc(ct2->ct2_data)
      _cMen2:="Lidos.......: "+alltrim(str(_nLidos))+_cQuebral+;
              "Distribuidos: "+alltrim(str(_nDistribuidos))+_cQuebral+;
              "Sintetizados:   "+alltrim(str(_nSintetizados))
      _cMen3:=ct2->(dtoc(ct2_data)+" Lote: "+ct2_lote+" Sublote: "+ct2_sblote+" Doc: "+ct2_doc+" Linha: "+ct2_linha) 

      u_RsProcTxt(_cMen1+chr(10)+_cMen2+chr(10)+_cMen3)

      ct2->(dbskip(1))
   enddo
   if !_lContinua
      exit
   endif
enddo

if _lContinua
   if _lExecutou
     // u_Ctbm06a(_dDataIni,_dDataFim)
   endif   
   msgbox("Concluido em: "+dtoc(date())+" "+time()+" h"+chr(10)+_cMen2)
else
   msgbox("Termino anormal "+dtoc(date())+" "+time()+" h"+chr(10)+_cMen2)
endif

_fFechaDest()

if len(_vLog)>0
   _fImpLog()
endif

return

*-------------------------------------------------------------
// Funcoes para controle de fluxo do programa
*-------------------------------------------------------------

static function _fPar
pergunte(_cPerg,.t.)
return

static function _fSair
    close(oBase)
return
*--------------------------------------------------------------------------------
user Function CalcOrig(_cOrigem)
*--------------------------------------------------------------------------------
local _cSepar:=chr(4)

_cOrigem:=substr(_cOrigem,at(_cSepar,_cOrigem)+1)
_cOrigem:=left(_cOrigem,rat(_cSepar,_cOrigem)-1)

return _cOrigem

*--------------------------------------------------------------------------------
Static Function _fFechaDest()
*--------------------------------------------------------------------------------

for _nVez:=1 to len(_vDestino)
    u__fCloseDb("CT2"+_vDestino[_nVez]+"0")
next

*--------------------------------------------------------------------------------
User Function CtbM06a(_dDataIni,_dDataFim)
*--------------------------------------------------------------------------------
_nLidos:=0
_nAtualizados:=0
for _nVezDest:=1 to len(_vDestino)
    _cDestino:=_vDestino[_nVezDest]
    u_RsProcTxt(_cMen1:="Ordenando dados para o destino "+_cDestino)
    _cCt2:="CT2"+_cDestino+"0"
    Dbselectarea(_cCt2)
    dbsetorder(1) // CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
    _cFiltro:="dtos(ct2_data)>='"+dtos(_dDataIni)+"'.and.dtos(ct2_data)<='"+dtos(_dDataFim)+"'"
    _cFiltro+=".and.Ct2_lp$'508/509/510/515/520/527/530/531/620/635/801/802/803/804/805/806/807/810/811/812/814/815/816/820/825/830'"
    IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro)
    dbgotop()
    _cCond1:=alias()+"->(!eof())"
    do while &_cCond1
       _vA:={}
       _vB:={}
       _cCond2:=alias()+"->(ct2_dc<>'1'.and.!eof())"
       do while &_cCond2
          u_RsProcTxt(_cMen1+chr(10)+"Localizando o primeiro debito")
          dbskip(1)
          _nLidos++
       enddo
    
       _cUltima:=ct2_credit
       _lCredito:=.f.
       _cDocOrig:=(alias())->ct2_cskey3
       _cMen2a:="Documento original: "+alltrim(_cDocOrig)
       do while !eof().and.ct2_cskey3==_cDocOrig
       
          if ct2_dc=="1"
             _lCredito:=.f.
          elseif ct2_dc=="2"
             _lCredito:=.t.
          elseif ct2_dc=="3"
             do while !eof().and.ct2_dc$"34"
                u_RsProcTxt(_cMen1+chr(10)+_cMen2a+chr(10)+"Desprezando partidas dobradas")
                _nLidos++
                dbskip(1)
             enddo
             loop
          endif
             
          /* Comentar esta linha forca com que os creditos constem sempre ao final de cada documento
          if (ct2_dc=="2".and.ct2_credit<>_cUltima)
             // Mudou a conta de debito, atualizar o vetor
             for _nVezb:=1 to len(_vB)
                 aadd(_vA,_vB[_nVezB])
             next
             _vB:={}
          endif
          */
          
          if _lCredito
             //_vLinha:={}
             //for _nVezL:=1 to fcount()
             //    aadd(_vLinha,fieldget(_nVezL))
             //next    
             aadd(_vB,recno())
          else
             //_vLinha:={}
             //for _nVezL:=1 to fcount()
             //    aadd(_vLinha,fieldget(_nVezL))
             //next    
             aadd(_vA,recno())
          endif
                 
          _nLidos++
          dbskip()
          u_RsProcTxt(_cMen1+chr(10)+_cMen2a+chr(10)+"Lidos: "+alltrim(str(_nLidos))+chr(10)+"Atualizados: "+alltrim(str(_nAtualizados)))
       enddo
       if len(_vB)>0
          for _nVezb:=1 to len(_vB)
              aadd(_vA,_vB[_nVezB])
          next
          _vB:={}
       endif
       // Agora, todas as linhas do lancamento encontram-se em _vA, ja na ordem correta
       _nRecCt2:=recno()
       for _nVezA:=1 to len(_vA)
           dbgoto(_vA[_nVezA])
           if _nVezA==1
              _cLinha:=ct2_linha
           else
              _cLinha:=soma1(_cLinha)
           endif
           reclock(alias(),.f.)
           (alias())->ct2_linha:=_cLinha
           _nAtualizados++
           msunlock()
           u_RsProcTxt(_cMen1+chr(10)+_cMen2a+chr(10)+"Lidos: "+alltrim(str(_nLidos))+chr(10)+"Atualizados: "+alltrim(str(_nAtualizados)))
       next
       dbgoto(_nRecCt2)
   enddo
   _cComando:=_cCt2+"->(dbclosearea())"
   _x:=&_cComando
next

*-------------------------------------------------------------------------
static function _fImpLog()
*-------------------------------------------------------------------------

nLastKey  :=0
limite    :=220
wnrel     :=nomeprog:="CsCtbM06"
cDesc1    :="Registros contabeis nao distribuidos"
cDesc2    :=" "
cDesc3    :=" "
cString   :="CT2"
tamanho   := "G"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     :=99
m_pag     :=1
Li        :=0
          
Cabec1:="Detalhes dos registros inconsistentes"
Cabec2:=""   
cursorarrow()
wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
if nLastkey==27
   set filter to
   return
endif
cursorwait()
asort(_vLog)
RptStatus({|| RptDetail()})
cursorarrow()
*-------------------------------------------
Static function rptdetail
*-------------------------------------------
setdefault(aReturn,cString)
setregua(len(_vLog))
_nLin:=99
for _nVez:=1 to len(_vLog)
    incregua()
    if _nLin>58
       Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
       _nLin:=li+2
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
AADD(aRegs,{_cPerg,"01","Periodo de            :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Periodo ate           :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return

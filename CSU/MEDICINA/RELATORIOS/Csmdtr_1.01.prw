#include "rwmake.ch"

*--------------------------------------------------------------------------------------
user function CsMdtR01()
* Adaptacao de MdtR475 para a Csu (Rel. PCMSO)
* Ricardo Luiz da Rocha 06/06/2004 GNSJC
*--------------------------------------------------------------------------------------

nLastKey  :=0
limite    :=220
wnrel     :=nomeprog:="CsMdtR01"
cDesc1    :="Resumo PCMSO"
cDesc2    :="Este relatorio exibe o resumo dos exames realizados em funcionarios "
cDesc3    :="por centro de custo e natureza, e e restrito pelas respectivas datas de resultado"
cString   :="SRA"
tamanho   := "G"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     :=99
m_pag     :=1
Li        :=0           
cPerg     :=PADR("MdtR01",LEN(SX1->X1_GRUPO))
Cabec1:="Setor                                                        Natureza         Exames    Resultados  Representatividade    Exames para"
Cabec2:="                                                                            realizados  anormais                          o ano seguinte"
validperg(cPerg)
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
if nLastkey==27
   set filter to
   return
endif

setdefault(aReturn,cString)

if nLastkey==27
   set filter to
   return
endif
pergunte(cPerg,.f.)
_dDtReIni:=mv_par01 // Data do resultado de
_dDtReFim:=mv_par02 // Data do resultado ate 
_nOrigem :=mv_par03 // Origem do exame   1=Assistencial;2=Ocupacional;3=Ambos
_cFiliIni:=mv_par04 // Filial de
_cFiliFim:=mv_par05 // Filial ate
_cCcusIni:=mv_par06 // Centro de custo de
_cCcusFim:=mv_par07 // Centro de custo ate
_cNomeRes:=mv_par08 // Medico responsavel 
_cCrmRes :=mv_par09 // Numero no CRM

titulo:=cDesc1+"  -  periodo de "+dtoc(_dDtReIni)+" a "+dtoc(_dDtReFim)

cursorwait()
_vCCusto:={}
processa({||_fPrepara1(),"Aguarde, preparando dados - Fase 1"})
_vDados:={}
processa({||_fPrepara2(),"Aguarde, preparando dados - Fase 2"})
cursorarrow()
RptStatus({||RptDetail()})

*------------------------------------------------------------------------------
Static function _fPrepara1()
* Totaliza o numero de funcionarios nao-demitidos por CC
* conforme os parametros
*------------------------------------------------------------------------------
procregua(sra->(lastrec()))
sra->(dbsetorder(2)) // RA_FILIAL+RA_CC+RA_MAT
_cFiltro:="ra_filial>='"+_cFiliIni+"'.and.ra_filial<='"+_cFiliFim+"'"
_cFiltro+=".and.ra_sitfolh<>'D'.and.ra_catfunc=='M'" // Considerar apenas mensalistas nao demitidos
_cFiltro+=".and.ra_cc>='"+_cCCusIni+"'.and.ra_cc<='"+_cCCusFim+"'"
sra->(indregua(alias(),criatrab(,.f.),_cOrdem:="ra_cc",,_cFiltro))
sra->(dbgotop())
_cUltimoCC:=sra->ra_cc
_nAtivos:=0
do while sra->(!eof())
   if sra->ra_cc<>_cUltimoCC
      aadd(_vCCusto,{_cUltimoCC,_nAtivos})
      _nAtivos:=1
      _cUltimoCC:=sra->ra_cc
   else
      _nAtivos++
   endif
   sra->(incproc(ra_cc+left(ra_nome,20)))
   sra->(dbskip(1))
enddo
procregua(1)
incproc()   
sra->(dbclearfil())
sra->(retindex(alias()))
return

*------------------------------------------------------------------------------
Static function _fPrepara2()
* Totaliza o numero de exames por CC+Natureza
* conforme os parametros
*------------------------------------------------------------------------------
_vStruct:=tm5->(dbstruct())
_nPosic:=ascan(_vStruct,{|_vAux|alltrim(_vAux[1])=="TM5_CC"})
_vStruct[_nPosic][3]:=20
dbcreate(_cNomTmp:=criatrab(,.f.),_vStruct)
dbusearea(.t.,,_cNomTmp,"Mdtr01Tmp",.t.,.f.)
/*
_cFiltro:="tm5_filial>='"+_cFiliIni+"'.and.tm5_filial<='"+_cFiliFim+"'"
//_cFiltro+=".and.tm5_cc>='"+_cCCusIni+"'.and.tm5_cc<='"+_cCCusFim+"'"
if _nOrigem<>3
   _cFiltro+=".and.tm5_origex=='"+str(_nOrigem,1)+"'"
endif   
*/
_cFiltro:=nil
MdtR01Tmp->(indregua(alias(),_cNomTmp,_cOrdem:="tm5_cc+tm5_natexa",,_cFiltro))

procregua(tm5->(lastrec()))
_cFiltro:="tm5_filial>='"+_cFiliIni+"'.and.tm5_filial<='"+_cFiliFim+"'"
//_cFiltro+=".and.tm5_cc>='"+_cCCusIni+"'.and.tm5_cc<='"+_cCCusFim+"'"
_cFiltro+=".and.dtos(tm5_dtresu)>='"+dtos(_dDtReIni)+"'.and.dtos(tm5_dtresu)<='"+dtos(_dDtReFim)+"'"
if _nOrigem<>3
   _cFiltro+=".and.tm5_origex=='"+str(_nOrigem,1)+"'"
endif   
tm5->(indregua(alias(),criatrab(,.f.),_cOrdem:="tm5_cc+tm5_natexa",,_cFiltro))
tm5->(dbgotop())
do while tm5->(!eof())
   _cCCAtu:=posicione("SRA",1,tm5->(tm5_filial+tm5_mat),"ra_cc")

   if _cCCAtu>=_cCCusIni.and._cCCAtu<=_cCCusFim
      Mdtr01Tmp->(reclock(alias(),.t.))
      for _nVez:=1 to tm5->(fcount())
          _cCampo:=tm5->(fieldname(_nVez))
          _cComando:="Mdtr01Tmp->"+_cCampo+":=tm5->"+_cCampo
          _x:=&_cComando
      next    
      Mdtr01Tmp->tm5_cc:=_cCCAtu
      Mdtr01Tmp->(msunlock())
   endif
   incproc("Selecionando Centros de custo")   
   tm5->(dbskip(1))
enddo   
     
_vNatDes:={}
aadd(_vNatDes,u_fX3Cbox("TM5_NATEXA","1"))
aadd(_vNatDes,u_fX3Cbox("TM5_NATEXA","2"))
aadd(_vNatDes,u_fX3Cbox("TM5_NATEXA","3"))
aadd(_vNatDes,u_fX3Cbox("TM5_NATEXA","4"))
aadd(_vNatDes,u_fX3Cbox("TM5_NATEXA","5"))
aadd(_vNatDes,"Nat Invalida")
procregua(MdtR01Tmp->(lastrec()))
MdtR01Tmp->(dbgotop())
do while Mdtr01Tmp->(!eof())
   _cUltimoCC:=Mdtr01Tmp->tm5_cc
   _cCCLit:=_cUltimoCC+" "+posicione("CTT",1,xfilial("CTT")+_cUltimoCC,"ctt_desc01")
   _vAdiciona:={}
   /* Layout de _vAdiciona:
    _vAdiciona[n][1] = Literal do centro de custo (posicao 1) ou espaco correspondente (demais posicoes)
    _vAdiciona[n][2] = Quantidade total de exames realizados para o cc+natureza
    _vAdiciona[n][3] = Quantidade total de exames anormais
    _vAdiciona[n][4] = Quantidade total de funcionarios ativos no cc (posicao 2) e 0 (demais posicoes)
   */
   for _nVez:=1 to 6
       if _nVez==2
          _nAtivosCC:=ascan(_vCCusto,{|_vAux|alltrim(_vAux[1])==alltrim(_cUltimoCC)})
          if _nAtivosCC>0
             _nAtivosCC:=_vCCusto[_nAtivosCC][2]
          endif
       else
          _nAtivosCC:=0
       endif
       aadd(_vAdiciona,{if(_nVez==1,_cCCLit,space(len(_cCCLit)))+padr(_vNatDes[_nVez],16),0,0,_nAtivosCC})
   next
   do while Mdtr01Tmp->(!eof().and.tm5_cc==_cUltimoCC)
      _nNatureza:=val(_cNatureza:=Mdtr01Tmp->tm5_natexa)
      if _nNatureza>0.and._nNatureza<6
      else
         _nNatureza:=6
      endif

      _cNatDesc:=_vNatDes[_nNatureza]
      _nNormais:=_nAnormais:=0
      do while Mdtr01Tmp->(!eof().and.tm5_cc==_cUltimoCC.and.tm5_natexa==_cNatureza)
         if Mdtr01Tmp->tm5_indres=="1"
            _nNormais++
         else
            _nAnormais++
         endif
         Mdtr01Tmp->(incproc(tm5_cc+" - "+_cNatDesc))
         Mdtr01Tmp->(dbskip(1))
      enddo
      _vAdiciona[_nNatureza][2]:=_nNormais+_nAnormais
      _vAdiciona[_nNatureza][3]:=_nAnormais
   enddo
   for _nVez:=1 to len(_vAdiciona)
       // So adiciona se nao for natureza invalida, ou se nela houverem dados
       if _nVez==6.and._vAdiciona[_nVez][2]+_vAdiciona[_nVez][3]+_vAdiciona[_nVez][4]==0
       else
          aadd(_vDados,_vAdiciona[_nVez][1]+"   "+str(_vAdiciona[_nVez][2],4)+"      "+str(_vAdiciona[_nVez][3],4)+"            "+tran(_vAdiciona[_nVez][3]/_vAdiciona[_nVez][2]*100,"@er 999.99 %")+"            "+str(_vAdiciona[_nVez][4],4))
       endif   
   next
   aadd(_vDados,"")
enddo

procregua(1)
incproc()
tm5->(retindex(alias()))
//dbselectarea("MDTR01TMP")
//COPY TO RICARDO
MdtR01Tmp->(dbclosearea())
return

*-------------------------------------------
Static function rptdetail
*-------------------------------------------
setregua(len(_vDados))
_nLin:=99
_cUltimo:=_vDados[1]
for _nVez:=1 to len(_vDados)
    incregua()
    if _nLin>58
       Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
       _nLin:=li+2
    endif
    if _nVez==1
       _nLin+=3
       @ _nLin,0 PSAY "Responsavel.: "+_cNomeRes+" CRM: "+_cCrmRes
       _nLin+=2
       @ _nLin,0 PSAY "Assinatura..: "+repl("_",len(alltrim(_cNomeRes)))
       _nLin+=3
    endif
    @ _nLin++,0 PSAY _vDados[_nVez]
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
AADD(aRegs,{_cPerg,"01","Data do resultado de  :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Data do resultado ate :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"03","Origem do exame       :","mv_ch3","N",01,0,0,"C","","mv_par03","Assistencial"    ,"","","Ocupacional"      ,"","","Ambos","","","","","","","",""})
AADD(aRegs,{_cPerg,"04","Filial de             :","mv_ch4","C",02,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","","SM0"})
AADD(aRegs,{_cPerg,"05","Filial ate            :","mv_ch5","C",02,0,0,"G","","mv_par05",""    ,"","",""      ,"","","","","","","","","","","SM0"})
AADD(aRegs,{_cPerg,"06","Centro de custo de    :","mv_ch6","C",20,0,0,"G","","mv_par06",""    ,"","",""      ,"","","","","","","","","","","CTT"})
AADD(aRegs,{_cPerg,"07","Centro de custo ate   :","mv_ch7","C",20,0,0,"G","","mv_par07",""    ,"","",""      ,"","","","","","","","","","","CTT"})
AADD(aRegs,{_cPerg,"08","Medico responsavel    :","mv_ch8","C",50,0,0,"G","","mv_par08",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"09","Numero no CRM         :","mv_ch9","C",06,0,0,"G","","mv_par09",""    ,"","",""      ,"","","","","","","","","","",""})
u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return


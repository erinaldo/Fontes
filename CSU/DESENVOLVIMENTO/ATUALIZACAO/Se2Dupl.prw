#include "rwmake.ch"
*---------------------------------------------------------------------------------------------------------------
User Function Se2Dupl()
* Verifica e corrige duplicacoes em SE2 e derivacoes em SE5/SEA/SEF
* Ricardo Luiz da Rocha - Dts Consulting - 13/07/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
msaguarde({||_fVerifica()},"Aguarde, verificando/corrigindo duplicacoes")
se2->(retindex(alias()))
se5->(retindex(alias()))
sea->(retindex(alias()))
sef->(retindex(alias()))

return
*---------------------------------------------------------------------------------------------------------------
static function _fVerifica()
*---------------------------------------------------------------------------------------------------------------

_cOrdem:="e5_filial+e5_prefixo+e5_numero+e5_parcela+e5_tipo+e5_clifor+e5_loja"
_cFiltro:="e5_recpag=='P'"
se5->(indregua(alias(),criatrab(,.f.),_cOrdem,,_cFiltro))

_cOrdem:="ea_filial+ea_prefixo+ea_num+ea_parcela+ea_tipo+ea_fornece+ea_loja"
_cFiltro:="ea_cart=='P'"
sea->(indregua(alias(),criatrab(,.f.),_cOrdem,,_cFiltro))

_cOrdem:="ef_filial+ef_prefixo+ef_titulo+ef_parcela+ef_tipo+ef_fornece+ef_loja"
_cFiltro:=nil
sef->(indregua(alias(),criatrab(,.f.),_cOrdem,,_cFiltro))

_vLog:={}
_vDuplic:={{},{}}
_nPerc:=_nDuplic:=0
se2->(dbsetorder(1)) //e2_filial+e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja
se2->(dbgotop())
_cChave:="se2->(e2_filial+e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)"
_cAnt:="estenaotemmesmo..."
_vOrig:={}
do while se2->(!eof())
   msproctxt("Lidos: "+alltrim(str(_nperc++))+' / '+alltrim(str(se2->(lastrec())))+;
             '   Duplicados: '+alltrim(str(_nDuplic)))
   if &_cChave==_cAnt
   
      _nDuplic++
      if len(_vDuplic)==0.or.ascan(_vDuplic[2],{|_vAux|_vAux[1]==_cAnt})==0
         se2->(dbskip(-1))
         aadd(_vOrig,se2->(recno()))
         se2->(dbskip(1))
         aadd(_vDuplic[1],se2->(recno()))
         aadd(_vDuplic[2],{_cAnt,se2->e2_baixa,se2->e2_valor})
      endif
   endif
   _cAnt:=&_cChave
   se2->(dbskip(1))
enddo

// As duplicacoes foram separadas, preparar a correcao alterando-se a parcela
if len(_vDuplic)>0
   for _nVez:=1 to len(_vDuplic[2])
       _cChave:=_cNovaChave:=_vDuplic[2][_nVez][1]
       _cParcela:=substr(_cChave,12,1)
       do while se2->(dbseek(_cNovaChave,.f.))
          _cChave1:=left(_cChave,11)
          _cParcela:=soma1(_cParcela)
          _cChave2:=substr(_cChave,13)
          _cNovaChave:=_cChave1+_cParcela+_cChave2
       enddo
    
       // Corrige SE2
       se2->(dbgoto(_vDuplic[1][_nVez]))
       se2->(reclock(alias(),.f.))
       _cParcAnt:=se2->e2_parcela
       se2->e2_parcela:=_cParcela
       se2->(msunlock())
       aadd(_vLog,"SE2   "+str(_vOrig[_nVez],7)+"  "+str(se2->(recno()),7)+" "+_vDuplic[2][_nVez][1]+"     "+_cParcAnt+"       "+_cParcela)


       // Corrige SE5
       _vSe5:={}
       if se5->(dbseek(_cChave,.f.))
          do while se5->(!eof().and.e5_filial+e5_prefixo+e5_numero+e5_parcela+e5_tipo+e5_clifor+e5_loja==_cChave)
             if se5->e5_data==_vDuplic[2][_nVez][2] 
                if se5->e5_valor==_vDuplic[2][_nVez][3]
                   aadd(_vSe5,se5->(recno()))
                   aadd(_vLog,"SE5   "+space(7)+"  "+str(se5->(recno()),7)+" "+_vDuplic[2][_nVez][1]+"     "+_cParcAnt+"       "+_cParcela)
                endif
             endif
             se5->(dbskip(1))
          enddo
       endif

       for _nVezSe5:=1 to len(_vSe5)
           se5->(dbgoto(_nVezSe5))
           se5->(reclock(alias(),.f.))
           _cParcAnt:=se5->e5_parcela
           se5->e5_parcela:=_cParcela
           se5->(msunlock())
       next
                
       // Corrige SEA
       _vSea:={}
       if sea->(dbseek(_cChave,.f.))
          do while sea->(!eof().and.ea_filial+ea_prefixo+ea_num+ea_parcela+ea_tipo+ea_fornece+ea_loja==_cChave)
             if sea->ea_databor==_vDuplic[2][_nVez][2] 
                aadd(_vSea,sea->(recno()))
                aadd(_vLog,"SEA   "+space(7)+"  "+str(sea->(recno()),7)+" "+_vDuplic[2][_nVez][1]+"     "+_cParcAnt+"       "+_cParcela)
             endif
             sea->(dbskip(1))
          enddo
       endif
       
       for _nVezSea:=1 to len(_vSea)
           sea->(dbgoto(_nVezSea))
           sea->(reclock(alias(),.f.))
           _cParcAnt:=sea->ea_parcela
           sea->ea_parcela:=_cParcela
           sea->(msunlock())
       next
    
       // Corrige SEF
       _vSef:={}
       if sef->(dbseek(_cChave,.f.))
          do while sef->(!eof().and.ef_filial+ef_prefixo+ef_titulo+ef_parcela+ef_tipo+ef_fornece+ef_loja==_cChave)
             if sef->ef_data==_vDuplic[2][_nVez][2]
                if sef->ef_valor==_vDuplic[2][_nVez][3]
                   aadd(_vSea,sef->(recno()))
                   aadd(_vLog,"SEF   "+space(7)+"  "+str(sef->(recno()),7)+" "+_vDuplic[2][_nVez][1]+"     "+_cParcAnt+"       "+_cParcela)
                endif
             endif
             sef->(dbskip(1))
          enddo
       endif    

       for _nVezSef:=1 to len(_vSef)
           sef->(dbgoto(_nVezSef))
           sef->(reclock(alias(),.f.))
           _cParcAnt:=sef->ef_parcela
           sef->ef_parcela:=_cParcela
           sef->(msunlock())
       next         
       
   next
endif   

if len(_vLog)>0

   aReturn := { "Zebrado",;      // Tipo do formulario
                        1,;      // Numero de vias
          "Administracao",; // Destinatario
                        1,;      // Formato 1-Comprimido  2-Normal
                        1,;      // Midia  1-Disco  2-Impressora
               'Se2Dupl',;      // Porta ou arquivo (1-LPT1...)
                        "",;      // Expressao do filtro
                         1 }      // Ordem (Numero do indice)                                                                        
                         
   cString:=alias()                      
   wnrel:=nomeprog:="Se2Dupl" 
   Titulo:='Ajustes em SE2 / SE5 / SEA / SEF'

   cabec1:=" Tabela  Registro Registro Chave do titulo       Parcela  Parcela"
   cabec2:="         Original Duplic.                        Original Alterada"

   cperg:=''
   cdesc1:=cdesc2:=cdesc3:=''
   tamanho:='M'
   
   WnRel := SetPrint( cString, WnRel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F. , "", .T., Tamanho, "", .F. )         
   
   SetDefault( aReturn, cString )
   RptStatus({||_fImprime()},Titulo)
endif

*-----------------------------------------------------------------------------*
static Function _fImprime
*-----------------------------------------------------------------------------*
li:=99
m_pag:=1
SetRegua(len(_vLog))
for _nVez:=1 to len(_vLog)
    incregua()
    if li>58
       Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
       li++
    endif

    @ li++,02 PSAY _vLog[_nVez]
next              

roda(0,"",tamanho)

if aReturn[5]=1
   Set Device To Screen
   Set Printer To
   dbCommitAll()
   OurSpool( WnRel )
endif   

return
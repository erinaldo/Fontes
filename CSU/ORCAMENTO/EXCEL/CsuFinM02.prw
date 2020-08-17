#include "rwmake.ch"
/*
*---------------------------------------------------------------------------------------------------------------
* Geracao da planilha com dados de titulos do contas a pagar (SE2) e rateios especificos da Csu (SZ6)
* Ricardo Luiz da Rocha - Dts Consulting - 19/07/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
*/
User Function CsFinM02()
private _cPerg:=PADR("FinM02",LEN(SX1->X1_GRUPO)),_cPath:="\",_cPathSrv:=getmv("MV_CSSRVPA")
//_cPathSrv:=strtran(_cPathSrv,"Planilha","CsFinM02")                                    

@ 100,091 To 250,580 Dialog oBase Title OemToAnsi("Exportacao de registros financeiros para planilha")
@ 012,016 Say u__fAjTxt('Esta rotina realizara a exportacao de titulos financeiros (Contas a pagar)')
@ 022,016 Say u__fAjTxt('e seus respectivos rateios quando existentes, com base nos parametros informados')

@ 040,020 BmpButton Type 1 Action (_fProssegue(),close(oBase))
@ 040,090 BmpButton Type 5 Action (_fPar())
@ 040,160 BmpButton Type 2 Action close(oBase)
Activate Dialog oBase centered

se2->(retindex(alias()))
sz6->(retindex(alias()))

Return

static function _fPar()
validperg(_cPerg)
pergunte(_cPerg,.t.)
return

static function _fProssegue
pergunte(_cPerg,.f.)

_dEmisIni:=mv_par01
_dEmisFim:=mv_par02
_dVencIni:=mv_par03
_dVencFim:=mv_par04

se2->(dbsetorder(1))

_cFiltro:="e2_filial=='"+xfilial("SE2")+"'"
_cFiltro+=".and.dtos(e2_emissao)>='"+dtos(_dEmisIni)+"'.and.dtos(e2_emissao)<='"+dtos(_dEmisFim)+"'"
_cFiltro+=".and.dtos(e2_vencto )>='"+dtos(_dVencIni)+"'.and.dtos(e2_vencto )<='"+dtos(_dVencFim)+"'"

_vStruct:={{"_Emissao","D",8,0},;
           {"_Vencto ","D",8,0},;
           {"_Fornec ","C",55,0},;
           {"_Prefixo","C",03,0},;
           {"_Numero ","C",06,0},;
           {"_Parcela","C",01,0},;
           {"_Tipo   ","C",03,0},;
           {"_CodNat ","C",10,0},;
           {"_DescNat","C",30,0},;
           {"_Valor  ","N",17,2},;
           {"_CentroC","C",20,2}}

dbcreate(_cPath+(_cNomTrb:=criatrab(,.f.)+".xls"),_vStruct)
dbusearea(.t.,,_cPath+_cNomTrb,"FinM02Tmp",.t.,.f.)

se2->(indregua(alias(),criatrab(,.f.),_cOrdem:=indexkey(),,_cFiltro))
msaguarde({||_fGeraPlan()},"Gerando a planilha")
return

*---------------------------------------------------------------------------------------------------------------
static function _fGeraplan
*---------------------------------------------------------------------------------------------------------------
sz6->(dbsetorder(1))
se2->(dbgotop())
_nExp:=0
do while se2->(!eof())
   sa2->(dbseek(xfilial()+se2->(e2_fornece+e2_loja),.f.))
   if se2->(e2_ratcsu=="S".and.alltrim(e2_ccusto)=="5.99.99.9")
      sz6->(dbseek(_cChaveSz6:=xfilial()+se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja),.f.))
      do while sz6->(!eof().and.Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA==_cChaveSz6)
         FinM02Tmp->(reclock(alias(),.t.))

         FinM02Tmp->_Emissao:=se2->e2_emissao
         FinM02Tmp->_Vencto :=se2->e2_vencto
         FinM02Tmp->_Fornec :=sa2->a2_nome+" ("+sz6->(z6_fornece+"-"+z6_loja)+")"
         FinM02Tmp->_Prefixo:=sz6->z6_prefixo
         FinM02Tmp->_Numero :=sz6->z6_numero
         FinM02Tmp->_Parcela:=sz6->z6_parcela
         FinM02Tmp->_Tipo   :=sz6->z6_tipo
         FinM02Tmp->_CodNat :=sz6->z6_naturez
         FinM02Tmp->_DescNat:=posicione("SED",1,xfilial("SED")+sz6->z6_naturez,"ed_descric")
         FinM02Tmp->_Valor  :=sz6->z6_valor
         FinM02Tmp->_CentroC:=sz6->z6_cc

         FinM02Tmp->(msunlock())
         sz6->(dbskip(1))
         _nExp++
      enddo
   else

      FinM02Tmp->(reclock(alias(),.t.))

      FinM02Tmp->_Emissao:=se2->e2_emissao
      FinM02Tmp->_Vencto :=se2->e2_vencto
      FinM02Tmp->_Fornec :=sa2->a2_nome+" ("+se2->(e2_fornece+"/"+e2_loja)+")"
      FinM02Tmp->_Prefixo:=se2->e2_prefixo
      FinM02Tmp->_Numero :=se2->e2_num
      FinM02Tmp->_Parcela:=se2->e2_parcela
      FinM02Tmp->_Tipo   :=se2->e2_tipo
      FinM02Tmp->_CodNat :=se2->e2_naturez
      FinM02Tmp->_DescNat:=posicione("SED",1,xfilial("SED")+se2->e2_naturez,"ed_descric")
      FinM02Tmp->_Valor  :=se2->e2_valor
      FinM02Tmp->_CentroC:=se2->e2_ccusto

      FinM02Tmp->(msunlock())
      _nExp++
   endif
   msproctxt("Registros exportados: "+alltrim(str(_nExp)))

   se2->(dbskip(1))
enddo

if file("CsFinM02.ini")
   _cPathSrv:=memoread("CsFinM02.ini")
   _cPathSrv:=strtran(_cPathSrv,chr(10),"")
   _cPathSrv:=strtran(_cPathSrv,chr(13),"")
endif

FinM02Tmp->(dbclosearea())
IF FILE(_cPath+_cNomTrb)
	COPY FILE (_cPath+_cNomTrb) TO (_cPathSrv+_cNomTrb)
	FERASE(_cPath+_cNomTrb)
	_cComando := "START "+_cPathSrv+_cNomTrb
	MEMOWRIT("C:\CsFinM02.bat",_cComando)
	COMMIT
	WINEXEC("C:\CsFinM02.bat")
ENDIF
RETURN
                          
Static Function VALIDPERG(_cPerg)
_cPerg:=PADR(_cPerg,len(sx1->x1_grupo))
aRegs := {}
             *   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
             *+---------------------------------------------------------------------------------------------------------------------------------+
             *¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
             *¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
             *¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
             *¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
             *¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
   AADD(aRegs,{_cPerg,"01","Emissao de               :","mv_ch1","D",08,0,0,"G","","mv_par01","","","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"02","Emissao ate              :","mv_ch2","D",08,0,0,"G","","mv_par01","","","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"03","Vencimento de            :","mv_ch3","D",08,0,0,"G","","mv_par01","","","",""      ,"","","","","","","","","","",""})
   AADD(aRegs,{_cPerg,"04","Vencimento ate           :","mv_ch4","D",08,0,0,"G","","mv_par01","","","",""      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)

Return
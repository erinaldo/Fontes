
*------------------------------------------------------------------
User Function Fa040Grv
* Ponto de entrada apos a gravacao de todos os dados do titulo a receber, e antes
* da contabilizacao
* Ricardo Luiz da Rocha - 26/10/2005 GNSJC
*------------------------------------------------------------------

_aAreaE1 := SE1->(GetArea())

_nRecPrin:=0
_cKey1:=_cKey2:=_cParcela:=''

_cCodArea:=SE1->E1_CODAREA
		
_nRecPrin:=se1->(recno())
_cKey1:=se1->(e1_filial+e1_prefixo+e1_num+e1_parcela)
_cKey2:=se1->(e1_cliente+e1_loja+dtos(e1_emissao))
_cParcela:=se1->e1_parcela

// Caso haja titulos de impostos derivados desta parcela, atualiza
se1->(dbsetorder(1))
se1->(dbseek(_cKey1))
do while se1->(!eof().and.e1_filial+e1_prefixo+e1_num+e1_parcela==_cKey1)
   if se1->(e1_cliente+e1_loja+dtos(e1_emissao))==_cKey2
      if se1->(recno())<>_nRecPrin
         if se1->(reclock(alias(),.f.))
            se1->e1_codarea:=_cCodArea
            se1->(msunlock())
         endif
      endif
   endif
   se1->(dbskip(1))
enddo      
     
SE1->(RestArea(_aAreaE1))

Return

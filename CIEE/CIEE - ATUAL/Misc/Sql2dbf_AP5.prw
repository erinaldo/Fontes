#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/12/00

User Function Sql2dbf()        // incluido pelo assistente de conversao do AP5 IDE em 11/12/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CAREA,_NREC,_CALIAS,_ALIASOK,NREC,NCOP")
SetPrvt("ASTRU,I,_CAMPO,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un눯o    쿞QL2DBF   � Autor � AVERAGE-MJBARROS      � Data � 29/06/98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri눯o 쿒eracao de DBFs a partir de Tabelas em Banco de Dados       낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       쿒enerico                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
_cArea  := Select()
_nRec   := RecNo()
_cAlias := Space(3)
_AliasOk:=.F.

@ 0,0 TO 250,400 DIALOG oDlg TITLE "Importacao de Tabelas de Banco de Dados p/ DBF"

@30,35 TO 80,130
                        
@50,40 SAY "Arquivo..:"
@50,80 GET _cAlias PICTURE "!!!" Valid AliasValid()// Substituido pelo assistente de conversao do AP5 IDE em 11/12/00 ==> @50,80 GET _cAlias PICTURE "!!!" Valid Execute(AliasValid)

@ 35,150 BMPBUTTON TYPE 01 ACTION GeraDbf()// Substituido pelo assistente de conversao do AP5 IDE em 11/12/00 ==> @ 35,150 BMPBUTTON TYPE 01 ACTION Execute(GeraDbf)
@ 65,150 BMPBUTTON TYPE 02 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg  CENTERED
*----------------------------------------------------------------------------

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 11/12/00

// Substituido pelo assistente de conversao do AP5 IDE em 11/12/00 ==> Function AliasValid
Static Function AliasValid()
*----------------------------------------------------------------------------
If ! Empty(Select(_cAlias))
   _AliasOk:=.T.
Else
   MsgStop("Tabela nao encontrada ou nao esta aberta !","Aviso de Erro")
   _AliasOk:=.F.
Endif
Return _AliasOk
*----------------------------------------------------------------------------
// Substituido pelo assistente de conversao do AP5 IDE em 11/12/00 ==> Function GeraDbf
Static Function GeraDbf()
*----------------------------------------------------------------------------
If ! _AliasOk
     MsgStop("Informar alias do Arquivo","Aviso de Erro")
     Return
Endif

DbSelectarea(_cAlias)
DbGotop()
nrec:=LastRec()
ncop:=0
astru:=dbstruct()
DbCreate(_cAlias,astru)
Use (_cAlias) new alias newdbf shared
Processa({|lend| copiadbf()},"Gerando "+_cAlias+".dbf")// Substituido pelo assistente de conversao do AP5 IDE em 11/12/00 ==> Processa({|lend| execute(copiadbf)},"Gerando "+_cAlias+".dbf")
newdbf->(DbCloseArea())

MsgInfo(trim(str(nrec,7,0))+" registros lidos, "+alltrim(str(ncop,7,0))+" copiados ")

// Substituido pelo assistente de conversao do AP5 IDE em 11/12/00 ==> Function copiadbf
Static Function copiadbf()

ProcRegua(nrec)
DbSelectarea(_cAlias)

Do While ! Eof()
  ncop:=ncop+1
  IncProc('Copiando registro '+alltrim(str(ncop,7,0))+' de '+trim(str(nrec,7,0)) )
  newdbf->(DbAppend())
  For i:=1 to Len(astru)
      _campo:=FieldGet(i)
      newdbf->(FieldPut(i,_campo))
  Next
  DbSkip()
Enddo

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 11/12/00


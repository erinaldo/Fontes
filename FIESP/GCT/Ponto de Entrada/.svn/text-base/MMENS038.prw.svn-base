#include 'rwmake.ch'
#include 'tbiconn.ch'
#INCLUDE 'ap5Mail.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MMENS     ºAutor  ³TOTVS                º Data ³14/02/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mensagens padrao para M-Mensager                           º±±
±±ºDesc.     ³ 038 - AVISO DE VENCIMENTO DE CONTRATO                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MMENS038()

//{(cArqTrb)->CN9_NUMERO,(cArqTrb)->CN9_REVISA,(cArqTrb)->CN9_DTINIC,(cArqTrb)->CN9_DTFIM,(cArqTrb)->CN9_FILIAL}

a_Var := Paramixb[1]
c_Ret := Paramixb[2]

_xGetArea := GetArea()
_cRev 	  := iif(a_Var[2]==Nil,"",a_Var[2])

DbSelectArea("CN9")
DbSetOrder(1)
If DbSeek(a_Var[5]+a_Var[1]+_cRev)

	_cObj := MSMM("CN9->CODOBJ")
	
	c_Ret := '<HTML>'
	c_Ret += '<b>Aviso de vencimento do Contrato: </b><p></p>'
	c_Ret += '<b>Contrato\Revisão: </b>'+ a_Var[1]+'/'+ _cRev+'<P></P>'
	c_Ret += '<b>Filial:</b>'+ a_Var[5]+'<P></P>'
	c_Ret += '<b>Data de Inicio:</b>'+ DTOC(a_Var[3])+'<P></P>'
	c_Ret += '<b>Data de Termino:</b>'+ DTOC(a_Var[4])+'<P></P>'
	c_Ret += '<b>Fornecedor:</b>'+CN9->CN9_XFORNE+'-'+CN9->CN9_XLOJA+'/'+CN9->CN9_XNOMEF+'<P></P>'
	c_Ret += '<b>Objeto:</b><P>'+_cObj+'</P>'
	c_Ret += '</HTML>'

EndIf

RestArea(_xGetArea)

Return(c_Ret)
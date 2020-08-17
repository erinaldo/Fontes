#include "protheus.ch"     

/*                                          
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณCT030GRI    บAutor  ณMicrosiga           บ Data ณ  25/03/04    บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณObjetivo: Replicar as informacoes do centro de custo incluidas,บฑฑ
ฑฑบ          ณalteradas ou excluidas nas empresa 02 para as empresas 03,04 e บฑฑ
ฑฑบ			 ณ09                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

User Function CT030GRI()

Local _aVariaveis  :={}
Local _aEmpresas   :={"01","03","04","09","90"}   // Para quais empresas serao copiadas as informacoes
Local _aArea       :=GetArea()
Local _nNumEmp     :=Len(_aEmpresas)
Local _cEmprAutor  :=GetNewPar("MV_EMPRMAE","05")    // Empresa escolhida como empresa mae para cadastramentos

If (Ascan(_aEmpresas,cEmpAnt) = 0) .And. (cEmpAnt # _cEmprAutor) // Verifica se a Empresa atual esta autorizada fazer inclus๕es 
	Return .t.
Endif 

DbSelectArea("CTT")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega Variaveis de Memoria                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_nFCount :=FCount()

For i:=1 to _nFCount
	AADD(_aVariaveis,{FieldName(i),FieldGet(i)})
Next

For x:=1 To _nNumEmp
	_cEmpresa :="CTT"+_aEmpresas[x]+"0"
	
	DBUSEAREA(.T.,"TOPCONN",_cEmpresa,_cEmpresa,.T.)
	TcCanOpen(_cEmpresa,_cEmpresa+"1")
	ORDLISTADD(_cEmpresa+"1")
	nPos := Ascan(_aVariaveis, {|aVal|aVal[1] == "CTT_CUSTO"})
	
	If MsSeek(xFilial("CTT")+_aVariaveis[nPos,2])
		MsgAlert("O Centro de custo "+_aVariaveis[nPos,2]+" ja existe no cadastro de centro de custo da empresa "+_aEmpresas[x]+". Contate o administrador.","ATENวรO")
    Else
		_nItens :=Len(_aVariaveis)
		Reclock(_cEmpresa,.T.)
		FOR i := 1 TO _nItens
			if ascan(_aVariaveis,{|_vAux|_vAux[1]==FieldName(i)}) # 0
				&(_aVariaveis[i,1]) := _aVariaveis[i,2]
			Endif
		NEXT i
		MsUnlock()
	Endif
	DbCloseArea()
Next

RestArea(_aArea)
Return(.T.)

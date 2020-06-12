#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"        
              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CPRJR03   ºAutor  ³Fabio Zanchim       º Data ³  04/2014    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Grafico da SSI                      			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CPRJR03()

Local nX	:=0          
Local nLinIt:=0
Local cD	:=''
Local cM	:=''
Local cA	:=''
Local cText	:=''
Local cDesc	:=''
Local aMsg	:={}
Local aRet	:={}
Local aDados:= {}
Local cArquivo:=''
                 
Local oFont12  := TFont():New("Arial",12,12,,.F.,,,,.F.,.F.)
Local oFont12N := TFont():New("Arial",12,12,,.T.,,,,.F.,.F.)                                                           
Local oFont14  := TFont():New("Arial",14,14,,.F.,,,,.F.,.F.)
Local oFont14N := TFont():New("Arial",14,14,,.T.,,,,.F.,.F.)                                                           
Local oFont16  := TFont():New("Arial",16,16,,.F.,,,,.F.,.F.)
Local oFont16N := TFont():New("Arial",16,16,,.T.,,,,.F.,.F.)                                                           
Local oFont18  := TFont():New("Arial",18,18,,.F.,,,,.F.,.F.)
Local oFont18N := TFont():New("Arial",18,18,,.T.,,,,.F.,.F.)
Local oFont20N := TFont():New("Arial",20,20,,.T.,,,,.F.,.F.)

//Private oBrush := TBrush():New(,CLR_HGRAY ,,)
Private oBrush2 := TBrush():New(,CLR_BLACK ,,)
Private _oImpres

If IsInCallStack('u_CPRJA01') .Or. IsInCallStack('u_CPRJW01b')	
	cArquivo:=SZP->ZP_NRSSI+'_protheus'
	If File("\ssi_imagens\"+cArquivo+".pdf")	
		fErase("\ssi_imagens\"+cArquivo+".pdf")//apaga p/ nao dar msg de 'sobrepor arquivo existente'
	EndIf

	_oImpres := FWMSPrinter():New(cArquivo, IMP_PDF, .T., "\ssi_imagens\",.T.,,,,.T.,,,.F.)
	_oImpres:lServer := .T. 
	_oImpres:CPRINTER:="PDF"	
	_oImpres:cPathPDF := "\ssi_imagens\"
	_oImpres:SetPortrait()	
	_oImpres:SetPaperSize(DMPAPER_A4)//A4	
Else
	aDados := {{1, "SSI", Space(Len(SZP->ZP_NRSSI)),"", "", "SZP", "", 90, .T.}}
	
	If !ParamBox(aDados, "Informe a SSI", @aRet)  
		Return
	EndIF
	dbselectArea('SZP')
	dbSetORder(1)
	dbSeek(xFilial('SZP')+MV_PAR01)
	cArquivo:=SZP->ZP_NRSSI+'_protheus'	
	
	_oImpres := FWMSPrinter():New(cArquivo, IMP_PDF, .T., /*cPathInServer*/,.T.,,,,,,,.F.)//abre
	_oImpres:Setup()			     
EndIf

_oImpres:SetMargin(60,0,0,0)

_oImpres:StartPage()

_oImpres:Box(080,160,280,2000)//BOX SOLICITACAO DE SERVICO A INFORMATICA
_oImpres:SayBitmap(100,200,"Logo50Anosciee.png",250,190)
_oImpres:SayBitmap(100,1670,"LogoDesenvSistemas.png",220,160)

_oImpres:Say (240 ,650, 'Solicitação de Serviço à Informática', oFont20N)
_oImpres:Box(280,160,522,2000)//BOX DOS 3 QUADROS                        
_oImpres:Say (340,1600, 'SSI n°', oFont14N)
_oImpres:Box(280,1750,340,1999)//BOX SSI N°
_oImpres:Say (330,1780, SZP->ZP_NRSSI, oFont16N)

_oImpres:Line(440, 470, 440, 540)//hor cima
_oImpres:Line(440, 470, 490, 470) //vert esq
_oImpres:Line(490, 470, 490, 540)//hor baixo
_oImpres:Line(440, 540, 490, 540) //vert dir
_oImpres:Say (475 ,560, 'Alterações', oFont14N)
If SZP->ZP_TPIDENT == "1"
	_oImpres:Say (480 ,485, 'X', oFont18N)
EndIf

_oImpres:Line(440, 900, 440, 970)//hor cima
_oImpres:Line(440, 900, 490, 900) //vert esq
_oImpres:Line(490, 900, 490, 970)//hor baixo
_oImpres:Line(440, 970, 490, 970) //vert dir
_oImpres:Say (475 ,990, 'Novo Desenvolvimento', oFont14N)
If SZP->ZP_TPIDENT == "2"
	_oImpres:Say (480 ,915, 'X', oFont18N)
EndIf

_oImpres:Line(440, 1440, 440, 1510)//hor cima
_oImpres:Line(440, 1440, 490, 1440) //vert esq
_oImpres:Line(490, 1440, 490, 1510)//hor baixo
_oImpres:Line(440, 1510, 490, 1510) //vert dir
_oImpres:Say (475 ,1530, 'Emergencial', oFont14N)
If SZP->ZP_TPIDENT == "3"
	_oImpres:Say (480 ,1455, 'X', oFont18N)
EndIf

_oImpres:Box(520,160,690,500)//CR            
_oImpres:FillRect( {522,163,570,497 }, oBrush2)
_oImpres:Say (555 ,200, 'CR', oFont14N, , CLR_WHITE )
_oImpres:Say (615 ,200, SZP->ZP_CR, oFont16N)

_oImpres:Box(520,498,690,1000)//AREA
_oImpres:FillRect( {522,503,570,997 }, oBrush2)       
_oImpres:Say (555 ,540, 'ÁREA', oFont14N, , CLR_WHITE )
_oImpres:Say (615 ,540, Alltrim(SZP->ZP_CRDESCR), oFont16N)

_oImpres:Box(520,1000,690,1680)//SOLICITANTE  
_oImpres:FillRect( {522,1003,570,1677 }, oBrush2)
_oImpres:Say (555 ,1040, 'SOLICITANTE', oFont14N, , CLR_WHITE )
_oImpres:Say (615 ,1040, SZP->ZP_SOLICIT, oFont16N)

_oImpres:Box(520,1680,690,1999)//DATA RECEB.
_oImpres:FillRect( {522,1683,570,1997 }, oBrush2)
_oImpres:Say (555 ,1720, 'DATA', oFont14N, , CLR_WHITE )
_oImpres:Say (615 ,1720, Dtoc(SZP->ZP_EMISSAO), oFont16N )

_oImpres:Box(690,160,1840,2000)//Box Desc do Serviço
_oImpres:FillRect( {691,163,740,1997 }, oBrush2)
_oImpres:Say (735,200, 'Objetivo da Solicitação de Serviço à Informática', oFont14N, , CLR_WHITE )
cText:=Alltrim(SZP->ZP_SERVICO)
nLinIt:=800
If Len(cText) > 110 .Or. (CHR(13)+CHR(10))$cText
	aMsg:=GetMsgArray(cText,110)
	For nX:=1 to Len(aMsg)
		_oImpres:Say(nLinIt,200,aMsg[nX], oFont14 )
		nLinIt+=40
	Next nX
Else
	_oImpres:Say(nLinIt,200,cText,oFont14)
	nLinIt+=40
EndIf                            


_oImpres:Box(1840,160,2540,2000)//Box segunda area grande
_oImpres:FillRect( {1842,163,1890,1997 }, oBrush2)
_oImpres:Say (1885,200, 'Lista dos programas ou página Web', oFont14N, , CLR_WHITE )
cText:=Alltrim(SZP->ZP_LISTALT)  
nLinIt:=1950
If Len(cText) > 110 .Or. (CHR(13)+CHR(10))$cText
	aMsg:=GetMsgArray(cText,110)
	For nX:=1 to Len(aMsg)
		_oImpres:Say(nLinIt,200,aMsg[nX], oFont14 )
		nLinIt+=40
	Next nX
Else
	_oImpres:Say(nLinIt,200,cText,oFont14)
	nLinIt+=40
EndIf   
                                                                                 
_oImpres:Box(2540,160,2870,2000)//Box final 1
_oImpres:FillRect( {2542,163,2600,1997 }, oBrush2)//Quadro pintado (com cabeçalhos do quadro final)
_oImpres:Box(2870,160,2930,2000)//Box final 2
_oImpres:FillRect( {2873,163,2930,1997 }, oBrush2)//Ultimo quadro pintado (final do relatorio)
_oImpres:Say(2910,1640, 'Rev. 4'	, oFont14N, , CLR_WHITE )

_oImpres:Say(2580,480, 'Aprovações Técnicas'	, oFont14N, , CLR_WHITE )
_oImpres:Say(2580,1100,'Data Prevista'			, oFont14N, , CLR_WHITE )
_oImpres:Say(2580,1560,'Aceite do Encerramento'	, oFont14N, , CLR_WHITE )
_oImpres:Line(2600,620,2870,620)  //vet              
_oImpres:Say(2725,200,"Joaquim d'Oliveira Neto", oFont14)
_oImpres:Say(2855,180,'Gestor de Sistemas', oFont14N)
_oImpres:Line(2600,1080,2870,1080)//vet            
_oImpres:Say(2725,720,SZP->ZP_ANALIST, oFont14)
_oImpres:Say(2855,640,'Analista de Sistemas', oFont14N)
_oImpres:Line(2600,1540,2870,1540) //vet           
_oImpres:FillRect( {2710,1080,2760,1540 }, oBrush2)//Quadro da Data de Conclusão                
_oImpres:Say(2740,1120,'Data de Conclusão', oFont14N, , CLR_WHITE )            

//Dt Prevista 
cD:=StrZero(Day(SZP->ZP_DTPREV),2)
cM:=StrZero(Month(SZP->ZP_DTPREV),2)
cA:=StrZero(Year(SZP->ZP_DTPREV),4)                 
_oImpres:Say(2685,1100,'______ / ______ / ________', oFont14N)
_oImpres:Say(2681,1115,   cD+'          '+cM+'        '+cA, oFont16)

cD:='';cM:='';cA:=''
If !Empty(SZP->ZP_ACEITE)                                                    
	cD:=StrZero(Day(SZP->ZP_ACEITE),2)
	cM:=StrZero(Month(SZP->ZP_ACEITE),2)
	cA:=StrZero(Year(SZP->ZP_ACEITE),4)                 
EndIF
_oImpres:Say(2685,1560,'______ / ______ / ________', oFont14N)//Aceite
_oImpres:Say(2681,1575,   cD+'          '+cM+'        '+cA, oFont16)

cD:='';cM:='';cA:=''
If !Empty(SZP->ZP_CONCLUS)
	cD:=StrZero(Day(SZP->ZP_CONCLUS),2)
	cM:=StrZero(Month(SZP->ZP_CONCLUS),2)
	cA:=StrZero(Year(SZP->ZP_CONCLUS),4)                 
EndIF
_oImpres:Say(2855,1100,'______ / ______ / ________', oFont14N)//Dt Conclusao
_oImpres:Say(2851,1115,   cD+'          '+cM+'        '+cA, oFont16)
If !Empty(SZP->ZP_IDAPROV)
	iF 'EMAIL1'$SZP->ZP_IDAPROV
		cDesc:='Solicitante:'
	ElseIf 'EMAIL2'$SZP->ZP_IDAPROV
		cDesc:='Superior:'
	ElseIf 'EMAIL3'$SZP->ZP_IDAPROV
		cDesc:='Gerente:'
	EndIf
	_oImpres:Say(2740,1560,cDesc, oFont12)
	_oImpres:Say(2780,1560,SZP->&(ZP_IDAPROV), oFont12)
EndIf
_oImpres:Say(2855,1560,'Gestor / Responsável', oFont14N)

_oImpres:EndPage()
_oImpres:Preview(AllTrim(GetProfString(GetPrinterSession(),"DEFAULT","",.T.)))

FreeObj(_oImpres)//Libera o objeto

Return

/*----------------------------------------------------------------------------
*
* GetMsgArray()
* Quebra o texto respeitando a palavra
*
----------------------------------------------------------------------------*/
Static Function GetMsgArray(_cConteudo,_nLimiteLinha)
Local nX:=0
Local _p:=1
Local nPos:=0
Local aMsg:={}
Local aMsgFim:={}
Local nPRef:=1
Local cString:=_cConteudo

//Primeiro laço: Verifica se existe instrução ((CRH(13)+CHR(10))) para quebrar o texto em varias linhas                      
While .T.
	IF (CHR(13)+CHR(10))$cString 
		nPos:=At((CHR(13)+CHR(10)),cString)
		If nPos>0        
	    	Aadd(aMsgFim,Substr(cString,1,nPos-1))
			//Aadd(aMsgFim," ")//é o ENTER (a linha em branco na impressao)
	    	nPRef:=nPos+Len((CHR(13)+CHR(10)))  
	    	cString:=Substr(cString,nPRef,Len(cString))
	    Else                                      
	    	Aadd(aMsgFim,cString)
	    	Exit
	    EndIf
	 Else
		Aadd(aMsgFim,cString)		 	
		Exit
	 EndIf    
End
                 
//Segundo laço: quebra o texto em linhas se ultrapassar o tamnho (_nLimiteLinha)
For nX:=1 to Len(aMsgFim)  
	_cConteudo:=aMsgFim[nX]
	If Len(alltrim(_cConteudo))<=_nLimiteLinha
		AAdd(aMsg, alltrim(_cConteudo))
		Loop
	EndIF
	_p:=1   
	While _p<>0
		If Len(_cConteudo)<=_nLimiteLinha
			AAdd(aMsg, _cConteudo)
			Exit
		EndIF
		_p:=Rat(" ",Substr(_cConteudo,1,_nLimiteLinha))
		If _p<>0
			AAdd(aMsg, substr(_cConteudo,1,_p))
			_cConteudo:=substr(_cConteudo,_p+1,Len(_cConteudo))
		Else
			AAdd(aMsg, _cConteudo)
			Exit
		EndIf
	EndDo
Next nX                              
Return(aMsg)
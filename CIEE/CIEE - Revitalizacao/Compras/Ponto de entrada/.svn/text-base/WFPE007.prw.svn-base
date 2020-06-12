#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} WFPE007
Ponto de entrada para customizar a mensagem de processamento do workflow por link
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function WFPE007()
LOCAL cHTML 		:= ""
LOCAL lSuccess 	:= ParamIXB[1] 
LOCAL cMessage 	:= ParamIXB[2] 
LOCAL cProcesso 	:= ParamIXB[3]
Local lMsgPad		:= .T.

IF lSuccess                                                             
	// Registro SCR posicioando de acordo com o processo
	IF SCR->(!FOUND()) .OR. LEFT(cProcesso,8) == TRIM(SCR->CR_XWFID)
		lMsgPad:= .F.  		
		cHTML+= '<table width="100%" height="23" border="0" vspace="0" hspace="0" cellspacing="0" cellpadding="0">'+CRLF
		cHTML+= '  <tr>'+CRLF
		cHTML+= '    <td bgcolor="#FFFFFF" rowspan="2" style="font-size: 8pt">'+CRLF
		cHTML+= '	  <p align="left">'+CRLF
		cHTML+= '	  <img src="http://www.ciee.org.br/portal/media/img50anos/logo_50anos_png.png" width="230" height="80" ></p>'+CRLF
		cHTML+= '    </td>'+CRLF
		cHTML+= '    <td width="30%" bgcolor="#014282" style="font-size: 8pt" height="20">'+CRLF
		cHTML+= '	  <p align="right">'+CRLF
		cHTML+= '      <font face="Arial" size="4" color="#FFFFFF"><span style="background-color: #014282">Workflow Protheus</span></font></p>'+CRLF
		cHTML+= '    </td>'+CRLF
		cHTML+= '  </tr>'+CRLF
		cHTML+= '  <tr>'+CRLF
		cHTML+= '    <td width="100%" bgcolor="#FFFFFF" style="font-size: 8pt">&nbsp;</td>'+CRLF
		cHTML+= '  </tr>'+CRLF
		cHTML+= '</table>'+CRLF
		cHTML+= '<br>'+CRLF
		cHTML+= '<br>'+CRLF
		cHTML+= '<table border="0" cellpadding="0" cellspacing="0" width="100%">'+CRLF
		cHTML+= '	<tbody>'+CRLF
		cHTML+= '    <tr>'+CRLF
		cHTML+= '      <td bgcolor="#000000">'+CRLF
		cHTML+= '		<img src="../../../../LOGO.gif" height="1" width="1"></td>'+CRLF
		cHTML+= '    </tr>'+CRLF
		cHTML+= '  </tbody>'+CRLF
		cHTML+= '</table>'+CRLF                              
		
		IF SCR->CR_TIPO == "RC"
			IF SCR->CR_STATUS == "04"
				cHTML+= '<p align="left">'+cMessage+': Revisão de contrato reprovado com sucesso.</p>'+CRLF
			ELSE
				cHTML+= '<p align="left">'+cMessage+': Revisão de contrato aprovado com sucesso.</p>'+CRLF
			ENDIF			
		ELSE
			cHTML += '<p align="left">'+cMessage+'</p>'+CRLF
		ENDIF					
	ENDIF
ENDIF
	
if lMsgPad                                       
	cHTML+= '<table width="100%" height="23" border="0" vspace="0" hspace="0" cellspacing="0" cellpadding="0">'+CRLF
	cHTML+= '  <tr>'+CRLF
	cHTML+= '    <td bgcolor="#FFFFFF" rowspan="2" style="font-size: 8pt">'+CRLF
	cHTML+= '	  <p align="left">'+CRLF
	cHTML+= '	  <img src="http://www.ciee.org.br/portal/media/img50anos/logo_50anos_png.png" width="230" height="80" ></p>'+CRLF
	cHTML+= '    </td>'+CRLF
	cHTML+= '    <td width="30%" bgcolor="#014282" style="font-size: 8pt" height="20">'+CRLF
	cHTML+= '	  <p align="right">'+CRLF
	cHTML+= '      <font face="Arial" size="4" color="#FFFFFF"><span style="background-color: #014282">Workflow Protheus</span></font></p>'+CRLF
	cHTML+= '    </td>'+CRLF
	cHTML+= '  </tr>'+CRLF
	cHTML+= '  <tr>'+CRLF
	cHTML+= '    <td width="100%" bgcolor="#FFFFFF" style="font-size: 8pt">&nbsp;</td>'+CRLF
	cHTML+= '  </tr>'+CRLF
	cHTML+= '</table>'+CRLF
	cHTML+= '<br>'+CRLF
	cHTML+= '<br>'+CRLF
	cHTML+= '<table border="0" cellpadding="0" cellspacing="0" width="100%">'+CRLF
	cHTML+= '	<tbody>'+CRLF
	cHTML+= '    <tr>'+CRLF
	cHTML+= '      <td bgcolor="#000000">'+CRLF
	cHTML+= '		<img src="../../../../LOGO.gif" height="1" width="1"></td>'+CRLF
	cHTML+= '    </tr>'+CRLF
	cHTML+= '  </tbody>'+CRLF
	cHTML+= '</table>'+CRLF
	   
	cHTML += '<p align="left">'+cMessage+'</p>'+CRLF
ENDIF

RETURN cHTML


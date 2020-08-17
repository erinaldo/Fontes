#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSBUSCPD  บAutor  ณ Renato Carlos      บ Data ณ  Mai/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para ler arquivo texto fornecido pelo rh          บฑฑ
ฑฑบ          ณ e buscar registros na SRD                                  บฑฑ
ฑฑบ          ณ Arquivo trarแ o CPF data e valor.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
  
User Function CSBUSCPD()

	Processa({|| ProcArq()},"Processando SRD...")
	MsgAlert("Arquivo Gerado com Sucesso!","Aten็ใo")

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณpROCaRQ  บAutor  ณ Renato Carlos      บ Data ณ  Mai/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para ler arquivo texto fornecido pelo rh          บฑฑ
ฑฑบ          ณ e buscar registros na SRD                                  บฑฑ
ฑฑบ          ณ Arquivo trarแ o CPF data e valor.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
Static Function ProcArq()

Local aLog			:= {}
Local cType     	:= "Arquivo Texto (*.TXT) |*.txt|"
Local cBuffer 		:= ''
Local cItem         := "00"
Local cErroLog 		:= ""
Local cFileLog 		:= Criatrab(,.F.)+".LOG"
Local c_Cpf         := ""
Local n_Vlr         := 0
Local c_DtArq	    := ""
Local nX			:= 0
Local c_Query       := ""
Local cArq		 := "C:\MICROSIGA\" +"CORRETOS" +StrTran(Time(),":", "")+".txt"
Local cArq2		 := "C:\MICROSIGA\" +"DTARQERROR" +StrTran(Time(),":", "")+".txt"
Local cArq3		 := "C:\MICROSIGA\" +"NAOENCONTRADOS" +StrTran(Time(),":", "")+".txt"
Local nXLog			:= 0
Local nLin			:= 0
Local nHdl
Local nHdl1
Private n_Cot     := FCreate( cArq ,1 )
Private n_CotErr     := FCreate( cArq2 ,1 )
Private n_CotNA     := FCreate( cArq3 ,1 )

Fclose( n_Cot )
n_Cot := Fopen( cArq ,2 )

Fclose( n_CotErr )
n_CotErr := Fopen( cArq2 ,2 )

Fclose( n_CotNA )
n_CotNA := Fopen( cArq3 ,2 )

If n_Cot < 0
   Alert('O Path especificado nao existe.','Erro no Arquivo','Info')
   Fclose( n_Cot )
   Return
EndIf

If n_CotErr < 0
   Alert('O Path especificado nao existe.','Erro no Arquivo','Info')
   Fclose( n_CotErr )
   Return
EndIf

If n_CotNA < 0
   Alert('O Path especificado nao existe.','Erro no Arquivo','Info')
   Fclose( n_CotNA )
   Return
EndIf

DbSelectArea("SRA")
DbSetOrder(20)

DbSelectArea("SRD")
DbSetOrder(1)

cTXTFile := cGetFile( cType, 'Selecione o Arquivo Texto para Importa็ใo', 0,, .T. )

if empty(cTXTFile)
  Return
Endif

Fclose( nHdl )  
nHdl 	 := fOpen(cTxtFile)
FT_FUSE(cTxtFile)
                      
// Pula linha para ignorar o cabecalho.
//FT_FSKIP()
                                       
// Verifica se o arquivo possui alguma inconsist๊ncia.

ProcRegua(9000)

While !FT_FEOF()
		
	cBuffer 	:= FT_FREADLN()
	/*
	c_Cpf		:= PADL(Alltrim(Substr(cBuffer,01,11)),11,"0") //Cpf	
	c_DtArq		:= PADL(Substr(cBuffer,13,7),6)		// Data Arq
	n_Vlr       := Val(Substr(cBuffer,19,26)) //Valor
	*/
	c_Cpf		:= PADL(Alltrim(Substr(cBuffer,01,11)),11,"0") //Cpf	
	n_Vlr       := Val(Substr(cBuffer,13,10)) //Valor
	
	IncProc("Processando o Arquivo " + c_Cpf +"/"+c_DtArq+ "...")
	
	If SRA->(DbSeek(c_Cpf))
		While !SRA->(EOF()) .AND. SRA->RA_CIC == c_Cpf
			If SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
				While SRD->RD_MAT == SRA->RA_MAT
					If SRD->RD_VALOR == n_Vlr
				    	c_Reg := SRD->RD_FILIAL+";"+SRD->RD_MAT+";"+SRA->RA_CIC+";"+SRD->RD_DATARQ+";"+SRD->RD_PD+";"+Transform(SRD->RD_VALOR, X3PICTURE("RD_VALOR"))+CHR(13)+CHR(10)
						FWrite( n_Cot, c_Reg )
					EndIf
					SRD->(DbSkip())	
				EndDo
			EndIf
		SRA->(DbSkip())		
		EndDo	
	EndIf 
	c_Reg := ""
	FT_FSKIP()
	
	
	/*
	If SRA->(DbSeek(c_Cpf))

		While !SRA->(EOF()) .AND. SRA->RA_CIC == c_Cpf 	
				
			If SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT))	
				
				If SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+c_DtArq))
				
					While SRD->RD_MAT == SRA->RA_MAT .AND. SRD->RD_DATARQ == c_DtArq  
				        
				    	If SRD->RD_VALOR == n_Vlr
						
							c_Reg := SRD->RD_FILIAL+";"+SRD->RD_MAT+";"+SRA->RA_CIC+";"+SRD->RD_DATARQ+";"+SRD->RD_PD+";"+Transform(SRD->RD_VALOR, X3PICTURE("RD_VALOR"))+CHR(13)+CHR(10)
				
							FWrite( n_Cot, c_Reg )
						Else
							c_Reg := SRD->RD_FILIAL+";"+SRD->RD_MAT+";"+SRA->RA_CIC+";"+SRD->RD_DATARQ+";"+SRD->RD_PD+";"+Transform(SRD->RD_VALOR, X3PICTURE("RD_VALOR"))+CHR(13)+CHR(10)
					       	FWrite( n_CotErr, c_Reg )
					    EndIf   	
							
					SRD->(DbSkip())			
					EndDo
				Else
					While SRD->RD_MAT == SRA->RA_MAT
						If SRD->RD_VALOR == n_Vlr
					       	c_Reg := SRD->RD_FILIAL+";"+SRD->RD_MAT+";"+SRA->RA_CIC+";"+SRD->RD_DATARQ+";"+SRD->RD_PD+";"+Transform(SRD->RD_VALOR, X3PICTURE("RD_VALOR"))+CHR(13)+CHR(10)
					       	FWrite( n_CotErr, c_Reg )
					    EndIf
				     	SRD->(DbSkip())
				    EndDo
				       
				EndIf
			Else
				c_Reg := SRA->RA_FILIAL+";"+SRA->RA_MAT+";"+c_Cpf+";"+c_DtArq+";"+Transform(n_Vlr, X3PICTURE("RD_VALOR"))+CHR(13)+CHR(10)
				FWrite( n_CotNA, c_Reg )
			EndIf		       		
		SRA->(DbSkip())		
	    EndDo
	EndIf	
	c_Reg := ""
	c_Query := ""	
	FT_FSKIP()

*/
EndDo    

fClose(n_Cot)
fClose(n_CotErr)
fClose(n_CotNA)
fClose(nHdl)

Return                                              


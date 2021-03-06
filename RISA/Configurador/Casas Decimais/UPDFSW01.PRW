#INCLUDE "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � UPDFSW01 �Autor  � DLeme                 �Data  � 20.Abr.12���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza��es Modal Aquaviario                              ���
�������������������������������������������������������������������������Ĵ��
���Projeto   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Bardella                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UPDFSW01()
Local aRet      := {{},{},{},{},{},{},{},{}}

//����������������������������������������������������������������������Ŀ
//� ESTRUTURA DO ARRAY aRET:                                             �
//����������������������������������������������������������������������Ĵ
//� aRet[01] - Array com os dados SX2                                    �
//� aRet[02] - Array com os dados SIX                                    �
//� aRet[03] - Array com os dados SX3                                    �
//� aRet[04] - Array com os dados SX5                                    �
//� aRet[05] - Array com os dados SX7                                    �
//� aRet[06] - Array com os dados SXA                                    �
//� aRet[07] - Array com os dados SXB                                    �
//� aRet[08] - Array com os dados SX6                                    �
//������������������������������������������������������������������������

aRet[3] := TMSAtuSX3()

Return(aRet)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TMSAtuSX3 � Autor � DLeme      � Data � 20.Mar.11���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna os dados para atualizacao do SX3                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function TMSAtuSX3()

Local aSX3      := {}
Local aCpos,nI
Local aArea := GetArea()

//�����������������������������������Ŀ
//�VERIFICA AS PROPRIEDADES DOS CAMPOS�
//�������������������������������������
dbSelectArea("SX3")
SX3->(DbSetOrder(2))

//--------------------------------------------------------------
//aCpos := RetCpos()
aCpos := {}
nDecimais := 3      
nTam      := 13

nHandle := FT_FUse("campos_quant.ini")

If nHandle = -1
	return
endif

// Posiciona na primeria linha
FT_FGoTop()

// Retorna o n�mero de linhas do arquivo
nLast := FT_FLastRec()
//primeira linha (quantidade, casas)
cLine  := FT_FReadLn()
nDecimais := val(substr(cLine,at("|",cLine)+1,10))      
nTam      := val(substr(cLine,1,at("|",cLine)-1))
FT_FSKIP()

While !FT_FEOF()
	cLine  := FT_FReadLn()
	aAdd(aCpos,cLine)		
	// Pula para pr�xima linha
	FT_FSKIP()
End
// Fecha o Arquivo

FT_FUSE()

DbSelectArea("SX3")
DbSetOrder(2) //X3_CAMPO
For nI := 1 To Len(aCpos)
	//-- Somente atualiza se o campo existir e a qtde de decimais for Menor que a definida
		DbSeek(aCpos[nI])
		cPicture := "@E " + Repl("9",Min(18,X3_TAMANHO+nDecimais-X3_DECIMAL)-nDecimais-1)+"."+Repl("9",nDecimais)

		Aadd(aSX3,{X3_ARQUIVO,;		//Arquivo
					X3_ORDEM,;		//Ordem
					X3_CAMPO,;		//Campo
					X3_TIPO,;		//Tipo
					nTam,;          //Min(18,X3_TAMANHO+nDecimais-X3_DECIMAL),;                   //Tamanho
					nDecimais,;		//Decimal                               
					X3_TITULO,;		//Titulo
					X3_TITSPA,;		//Titulo SPA
					X3_TITENG,;		//Titulo ENG
					X3_DESCRIC,;	//Descricao
					X3_DESCSPA,;	//Descricao SPA
					X3_DESCENG,;	//Descricao ENG
					cPicture,;  	//Picture
					X3_VALID,;					//VALID
					X3_USADO,;	//USADO
					X3_RELACAO,;				//RELACAO
					X3_F3,;					//F3
					X3_NIVEL,;						//NIVEL
					X3_RESERV,;	//RESERV
					X3_CHECK,;					//CHECK
					X3_TRIGGER,;					//TRIGGER
					X3_PROPRI,;					//PROPRI
					X3_BROWSE,;					//BROWSE
					X3_VISUAL,;					//VISUAL
					X3_CONTEXT,;					//CONTEXT
					X3_OBRIGAT,;					//OBRIGAT
					X3_VLDUSER,;//VLDUSER
					X3_CBOX,;	//CBOX
					X3_CBOXSPA,;	//CBOX SPA
					X3_CBOXENG,;	//CBOX ENG
					X3_PICTVAR,;					//PICTVAR
					X3_WHEN,;//WHEN
					X3_INIBRW,;					//INIBRW
					X3_GRPSXG,;					//SXG
					X3_FOLDER,;					//FOLDER
					X3_PYME})					//PYME
Next nI
RestArea(aArea)
			
Return(aSX3)

User Function FSW01Des()
Local aRet := {}

//����������������������������������������������������������������������Ŀ
//� ESTRUTURA DO ARRAY aRET:                                             �
//����������������������������������������������������������������������Ĵ
//� aRet[01] - (C) Nome da Function                                      �
//� aRet[02] - (C) Descritivo do Update                                  �
//� aRet[03] - (L) Situacao para determinar se o Update ja foi executado �
//� aRet[04] - (C) Projeto L�gico                                        �
//������������������������������������������������������������������������
AAdd( aRet, 'UPDFSW01')
AAdd( aRet, 'Decimais QTDE' )
AAdd( aRet, .F. )
AAdd( aRet, 'GENESIS' )

Return( aRet )
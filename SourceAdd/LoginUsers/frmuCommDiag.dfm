�
 TFRMCOMMDIAG 0�  TPF0TfrmCommDiagfrmCommDiagLeft[Top BorderIconsbiSystemMenubiHelp BorderStylebsSingleCaptionCommunication DiagnosticsClientHeight�ClientWidthUColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenterScaledOnCreate
FormCreate	OnDestroyFormDestroy
OnKeyPressFormKeyPressPixelsPerInch`
TextHeight TPageControlpgcDiagnosticsLeft Top WidthUHeight�
ActivePagetabDBConnectionAlignalClientTabOrder  	TTabSheettabDBConnectionCaptionDB Connection TLabellblDBResultsLeftTop� Width&HeightCaption	&Results:FocusControlmemDBResults  TMemomemDBResultsLeftTopWidthDHeightReadOnly	
ScrollBarsssBothTabOrderWordWrap  	TGroupBoxgbDatabaseInfoLeftToprWidthDHeightsCaption Database InformationTabOrder TLabellblDatabaseLeftTopWidth1HeightCaption
&Database:FocusControledtDatabase  TLabellblUsernameLeftTop6Width8HeightCaption&User Name:FocusControledtUsername  TLabellblPasswordLeftTopTWidth1HeightCaption
&Password:FocusControledtPassword  TButtonbtnSelDBLeftTopWidthHeightHintSelect databaseCaption...TabOrderOnClickbtnSelDBClick  TEditedtUsernameLeft[Top6Width� Height	MaxLength� TabOrder  TEditedtPasswordLeft[TopTWidth� Height	MaxLength PasswordChar*TabOrder  TEditedtDatabaseLeft[TopWidth� HeightParentShowHintShowHint	TabOrder OnChangeedtDatabaseChange   	TGroupBoxgbDBServerInfoLeftTopWidthBHeightgCaption Server InformationTabOrder  TLabellblServerNameLeftTop0WidthAHeightCaption&Server Name:FocusControl
cbDBServer  TLabellblProtocolLeft� Top0WidthUHeightCaption&Network Protocol:FocusControl
cbProtocol  	TComboBox
cbProtocolLeft� TopBWidthgHeightStylecsDropDownList
ItemHeightTabOrderItems.StringsTCP/IPNetBEUISPX   TRadioButtonrbLocalServerLeft$TopWidthkHeightCaption&Local ServerTabOrder OnClickrbLocalServerClick  TRadioButtonrbRemoteServerLeft� TopWidthtHeightCaptionR&emote ServerTabOrderOnClickrbRemoteServerClick  	TComboBox
cbDBServerLeftTopBWidth� Height
ItemHeightTabOrderOnClickcbDBServerClick    	TTabSheettabTCPIPCaptionTCP/IP TLabellblWinSockResultsLeftTopZWidth=HeightAutoSizeCaption	&Results:FocusControlmemTCPIPResults  TMemomemTCPIPResultsLeftToplWidthBHeightReadOnly	
ScrollBarsssBothTabOrderWordWrap  	TGroupBoxgbTCPIPServerInfoLeftTopWidth=HeightICaption Server InformationTabOrder  TLabellblWinsockServerLeftTopWidth+HeightAutoSizeCaption&Host:FocusControlcbTCPIPServer  TLabel
lblServiceLeft� TopWidthCHeightAutoSizeCaption	&Service:FocusControl	cbService  	TComboBox	cbServiceLeft� Top$WidthOHeightStylecsDropDownList
ItemHeightTabOrderItems.Strings21ftp3050gds_dbping   	TComboBoxcbTCPIPServerLeftTop%Width� Height
ItemHeight TabOrder     	TTabSheet
tabNetBEUICaptionNetBEUI TLabellblNetBeuiResultsLeftTopNWidth7HeightAutoSizeCaption	&Results:FocusControlmemNetBeuiResults  TMemomemNetBeuiResultsLeftTop`WidthBHeight!ReadOnly	
ScrollBarsssBothTabOrderWordWrap  	TGroupBoxgbNetBEUIServerInfoLeftTopWidth=Height=Caption Server InformationTabOrder  TLabellblNetBEUIServerLeftTopWidthAHeightCaption&Server Name:FocusControlcbNetBEUIServer  	TComboBoxcbNetBEUIServerLeftyTopWidth� Height
ItemHeight TabOrder     	TTabSheettabSPXCaptionSPX TLabellblSPXResultsLeftTopNWidth1HeightAutoSizeCaption	&Results:FocusControlmemSPXResults  	TGroupBoxgbNovellServerInfoLeftTopWidth=Height=Caption Server InformationTabOrder  TLabellblSPXServerLeftTopWidthAHeightCaption&Server Name:FocusControlcbSPXServer  	TComboBoxcbSPXServerLeftyTopWidth� Height
ItemHeight TabOrder    TMemomemSPXResultsLeftTop`WidthBHeight!ReadOnly	
ScrollBarsssBothTabOrderWordWrap    TPanelpnlButtonBarLeft Top�WidthUHeight%AlignalBottomTabOrder TButtonbtnTestLeft� TopWidthKHeightCaption&TestDefault	TabOrder OnClickbtnTestClick  TButton	btnCancelLeftTopWidthKHeightCaption&CancelTabOrderOnClickbtnCancelClick    
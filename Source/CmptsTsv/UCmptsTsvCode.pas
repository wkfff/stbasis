unit UCmptsTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, Graphics, UCmptsTsvData, UMainUnited, Classes, UCmptsTsvDm,
     dialogs, Controls, tsvHint, db, SysUtils, stdctrls, comctrls, dbctrls,
     typinfo, dsgnintf, tsvDesignCore, tsvInterpreterCore, IBDatabase;

// Internal

procedure DeInitAll;
procedure AddToListDesignPaletteHandles;
procedure ClearListDesignPaletteHandles;
procedure AddToListDesignPropertyTranslateHandles;
procedure ClearListDesignPropertyTranslateHandles;
procedure AddToListDesignPropertyRemoveHandles;
procedure ClearListDesignPropertyRemoveHandles;
procedure AddToListDesignPropertyEditorHandles;
procedure ClearListDesignPropertyEditorHandles;
procedure AddToListDesignComponentEditorHandles;
procedure ClearListDesignComponentEditorHandles;
procedure AddToListDesignCodeTemplateHandles;
procedure ClearListDesignCodeTemplateHandles;
procedure AddToListDesignFormTemplateHandles;
procedure ClearListDesignFormTemplateHandles;
procedure AddToListInterpreterConstHandles;
procedure ClearListInterpreterConstHandles;
procedure AddToListInterpreterClassHandles;
procedure ClearListInterpreterClassHandles;
procedure AddToListInterpreterFunHandles;
procedure ClearListInterpreterFunHandles;
procedure AddToListInterpreterEventHandles;
procedure ClearListInterpreterEventHandles;
procedure AddToListInterpreterVarHandles;
procedure ClearListInterpreterVarHandles;


procedure ForcedNotification(AForm: TCustomForm; APersistent: TPersistent; Operation: TOperation);stdcall;

// Export
procedure InitAll_; stdcall;
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
procedure GetInfoComponentsLibrary_(P: PInfoComponentsLibrary);stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;

// Import


implementation

uses UComponents, extctrls, buttons, toolwin, Menus, ActnList,
     checklst,dbgrids,tsvDbGrid,mask,Imglist,grids,Contnrs,ComObj,

     Chart, DBChart, series, TeEngine,

     VirtualTrees, VirtualDBTree,

     DBTables, dbclient, mconnect,

     IBTable,IBStoredProc,IBUpdateSQL,

     tsvStrEdit, ZnEditors, ZnOverride, PictEdit,
     tsvOtherEdit, tsvMenuEdit, tsvTreeEdit, tsvCollectionEdit,
     tsvFilterEdit,tsvMaskEdit,tsvListEdit,tsvImageListEdit,
     tsvListBox,tsvStorage,tsvAngleLabel,tsvGradient,tsvHintEx,
     tsvHtmlControls,tsvEntry,tsvVirtualDbTree,tsvStrings,
     tsvRTFStream,

     IBDBReg, IBCustomDataSet, IBQuery,
     LightColorPropertyEditor,
     FR_Class,FR_reg,FR_View,FR_PTabl,

     tsvXMLDoc, 

     IdHttp, IdMultipartFormData,

     AbZipper,

     daADCompReg, daADCompClient, daADPhysManager, 

     tsvInterpreterSystem, tsvInterpreterWindows, tsvInterpreterClasses,
     tsvInterpreterSysUtils, tsvInterpreterControls,
     tsvInterpreterGraphics, tsvInterpreterForms, tsvInterpreterGrids, tsvInterpreterMenus,
     tsvInterpreterComCtrls, tsvInterpreterContnrs, tsvInterpreterDialogs, tsvInterpreterExtCtrls,
     tsvInterpreterStdCtrls, tsvInterpreterCheckList,
     tsvInterpreterDb, tsvInterpreterDbCtrls, tsvInterpreterDbGirds, tsvInterpreterComObj,
     tsvInterpreterFastReport, tsvInterpreterRx, tsvInterpreterIB,
     tsvInterpreterStbasis, tsvInterpreterVirtualTree, tsvInterpreterXml,
     tsvInterpreterIndy, tsvInterpreterAbbrevia, tsvInterpreterAnyDac,
     tsvInterpreterRTFStream,

     tsvSecurity;

//******************* Internal ************************

procedure InitAll_; stdcall;
begin
 try
  dm:=Tdm.Create(nil);

  ListDesignPaletteHandles:=TList.Create;
  AddToListDesignPaletteHandles;

  ListDesignPropertyTranslateHandles:=TList.Create;
  AddToListDesignPropertyTranslateHandles;

  ListDesignPropertyRemoveHandles:=TList.Create;
  AddToListDesignPropertyRemoveHandles;

  ListDesignPropertyEditorHandles:=TList.Create;
  AddToListDesignPropertyEditorHandles;
  
  ListDesignComponentEditorHandles:=TList.Create;
  AddToListDesignComponentEditorHandles;

  ListDesignCodeTemplateHandles:=TList.Create;
  AddToListDesignCodeTemplateHandles;

  ListDesignFormTemplateHandles:=TList.Create;
  AddToListDesignFormTemplateHandles;

  ListInterpreterConstHandles:=TList.Create;
  AddToListInterpreterConstHandles;

  ListInterpreterClassHandles:=TList.Create;
  AddToListInterpreterClassHandles;

  ListInterpreterFunHandles:=TList.Create;
  AddToListInterpreterFunHandles;

  ListInterpreterEventHandles:=TList.Create;
  AddToListInterpreterEventHandles;

  ListInterpreterVarHandles:=TList.Create;
  AddToListInterpreterVarHandles;

  RegisterClass(TiTabSheet);
  RegisterClass(TiToolButton);
  RegisterClass(TiMenuItem);

  isInitAll:=true;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

type
  THackADPhysManager=class(TADPhysManager)
  end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;

  if Assigned(ADPhysManagerObj) then
    THackADPhysManager(ADPhysManagerObj).Close(false);

  UnRegisterClass(TiTabSheet);
  UnRegisterClass(TiToolButton);
  UnRegisterClass(TiMenuItem);

  ClearListDesignComponentEditorHandles;
  ListDesignComponentEditorHandles.Free;

  ClearListDesignPropertyEditorHandles;
  ListDesignPropertyEditorHandles.Free;

  ClearListDesignPropertyRemoveHandles;
  ListDesignPropertyRemoveHandles.Free;

  ClearListDesignPaletteHandles;
  ListDesignPaletteHandles.Free;

  ClearListDesignPropertyTranslateHandles;
  ListDesignPropertyTranslateHandles.Free;

  ClearListDesignCodeTemplateHandles;
  ListDesignCodeTemplateHandles.Free;

  ClearListDesignFormTemplateHandles;
  ListDesignFormTemplateHandles.Free;

  ClearListInterpreterConstHandles;
  ListInterpreterConstHandles.Free;

  ClearListInterpreterClassHandles;
  ListInterpreterClassHandles.Free;

  ClearListInterpreterFunHandles;
  ListInterpreterFunHandles.Free;

  ClearListInterpreterEventHandles;
  ListInterpreterEventHandles.Free;

  ClearListInterpreterVarHandles;
  ListInterpreterVarHandles.Free;

  dm.Free;

  FreeAndNil(fmMenuEditor);
  FreeAndNil(fmTreeEditor);
  FreeAndNil(fmCollectionEditor);


 except
//  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure ClearListDesignComponentEditorHandles;
var
  i: Integer;
begin
  for i:=0 to ListDesignComponentEditorHandles.Count-1 do begin
    _FreeDesignComponentEditor(THandle(ListDesignComponentEditorHandles.Items[i]));
  end;
  ListDesignComponentEditorHandles.Clear;
end;

procedure AddToListDesignComponentEditorHandles;

   function CreateDesignComponentEditorLocal(ComponentClass: TComponentClass;
                                             ComponentEditor: TComponentEditorClass): THandle;
   var
     TCDCE: TCreateDesignComponentEditor;
   begin
     FillChar(TCDCE,SizeOf(TCreateDesignComponentEditor),0);
     TCDCE.ComponentClass:=ComponentClass;
     TCDCE.ComponentEditor:=ComponentEditor;
     Result:=_CreateDesignComponentEditor(@TCDCE);
     ListDesignComponentEditorHandles.Add(Pointer(Result));
   end;

begin
  CreateDesignComponentEditorLocal(TMemo,TStringListEditor);
  CreateDesignComponentEditorLocal(TListBox,TStringListEditor);
  CreateDesignComponentEditorLocal(TComboBox,TStringListEditor);
  CreateDesignComponentEditorLocal(TRadioGroup,TStringListEditor);
  CreateDesignComponentEditorLocal(TCheckListBox,TStringListEditor);
  CreateDesignComponentEditorLocal(TRichEdit,TStringListEditor);
  CreateDesignComponentEditorLocal(TTabControl,TStringListEditor);
  CreateDesignComponentEditorLocal(TMaskEdit,TMaskEditor);
  CreateDesignComponentEditorLocal(TToolBar,TToolBarEditor);
  CreateDesignComponentEditorLocal(TImageList,TImageListEditor);

  CreateDesignComponentEditorLocal(TImage, TGraphicsEditor);
  CreateDesignComponentEditorLocal(TPageControl, TPageControlEditor);
  CreateDesignComponentEditorLocal(TMainMenu, TMenuItemEditor);
  CreateDesignComponentEditorLocal(TPopupMenu, TMenuItemEditor);
  CreateDesignComponentEditorLocal(TTreeView, TTreeNodeEditor);
  CreateDesignComponentEditorLocal(TListView, TListItemEditor);
  CreateDesignComponentEditorLocal(TStatusBar, TCollectionEditor);
  CreateDesignComponentEditorLocal(TCoolBar, TCollectionEditor);
  CreateDesignComponentEditorLocal(TDBGrid, TCollectionEditor);

  CreateDesignComponentEditorLocal(TNewDBGrid, TCollectionEditor);
  CreateDesignComponentEditorLocal(TtsvListBox, TCollectionEditor);
  CreateDesignComponentEditorLocal(TtsvStorage, TtsvStorageEditor);

  CreateDesignComponentEditorLocal(TIBDatabase, TIBDatabaseEditor);
  CreateDesignComponentEditorLocal(TIBTransaction, TIBTransactionEditor);


  CreateDesignComponentEditorLocal(TfrReport, TfrRepEditor);
  CreateDesignComponentEditorLocal(TfrPrintTable, TfrPrintTblEditor);

  CreateDesignComponentEditorLocal(TInterface, TInterfaceEditor);

  CreateDesignComponentEditorLocal(TtsvHtmlLabel, THtmlElementEditor);
  CreateDesignComponentEditorLocal(TtsvHtmlPage, THtmlElementEditor);
  CreateDesignComponentEditorLocal(TtsvHtmlFrame, THtmlElementEditor);
  
end;

procedure ClearListDesignPropertyEditorHandles;
var
  i: Integer;
begin
  for i:=0 to ListDesignPropertyEditorHandles.Count-1 do begin
    _FreeDesignPropertyEditor(THandle(ListDesignPropertyEditorHandles.Items[i]));
  end;
  ListDesignPropertyEditorHandles.Clear;
end;

procedure AddToListDesignPropertyEditorHandles;

   function CreateDesignPropertyEditorLocal(PropertyType: PTypeInfo;
                                            ComponentClass: TClass;
                                            PropertyName: PChar;
                                            EditorClass: TPropertyEditorClass): THandle;
   var
     TCDPE: TCreateDesignPropertyEditor;
   begin
     FillChar(TCDPE,SizeOf(TCreateDesignPropertyEditor),0);
     TCDPE.PropertyType:=PropertyType;
     TCDPE.ComponentClass:=ComponentClass;
     TCDPE.PropertyName:=PropertyName;
     TCDPE.EditorClass:=EditorClass;
     Result:=_CreateDesignPropertyEditor(@TCDPE);
     ListDesignPropertyEditorHandles.Add(Pointer(Result));
   end;

begin
  CreateDesignPropertyEditorLocal(TypeInfo(TComponent), TPersistent, '', TExtendedComponentProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(Variant), nil, '', TExtendedVariantProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(TStrings),nil,'',TStringListProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(String),TControl,'Hint',THintProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TCaption),TLabel,'Caption',THintProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(TAlign), TControl, 'Align', TAlignProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TAlignment), nil, '', TAlignmentProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TBevelCut), nil, '', TBevelCutProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TBevelShape), TBevel, 'Shape', TBevelShapeProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TBevelStyle), TBevel, 'Style', TBevelStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TBitBtnKind), TBitBtn, 'Kind', TBitBtnKindProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TBorderStyle), nil, '', TBorderStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TButtonLayout), nil, 'Layout', TButtonLayoutProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TCheckBoxState), nil, 'State', TCheckBoxStateProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TComboBoxStyle), TCustomComboBox, 'Style', TComboBoxStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TDefaultMonitor), TCustomForm, 'DefaultMonitor', TDefaultMonitorProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TEdgeStyle), TToolWindow, '', TEdgeStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TEditCharCase), nil, 'CharCase', TEditCharCaseProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TFormBorderStyle), TCustomForm, 'BorderStyle', TFormBorderStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TFormStyle), TCustomForm, 'FormStyle', TFormStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TLeftRight), TCheckBox, 'Alignment', TLeftRightCheckBoxProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TLeftRight), TRadioButton, 'Alignment', TLeftRightRadioButtonProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TListBoxStyle), TCustomListBox, 'Style', TListBoxStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TModalResult), nil, '', TZnModalResultProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TPanelBevel), nil, '', TBevelCutProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TPopupAlignment), TPopupMenu, 'Alignment', TPopupAlignmentProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TPosition), TCustomForm, 'Position', TPositionProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TScrollBarKind), nil, 'Kind', TScrollBarKindProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TScrollStyle), nil, 'ScrollBars', TScrollStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TShapeType), TShape, 'Shape', TShapeTypeProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TStatusPanelBevel), TStatusPanel, 'Bevel', TStatusPanelBevelProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TTabPosition), TCustomTabControl, 'TabPosition', TTabPositionProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TTextLayout), nil, 'Layout', TTextLayoutProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TViewStyle), TCustomListView, 'ViewStyle', TViewStyleProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TWindowState), TCustomForm, 'WindowState', TWindowStateProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(TImageIndex), nil, '', TImageIndexProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(Boolean), nil, '', TExtendedBoolProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(TPicture), nil, '', TPictProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TGraphic), nil, '', TGraphicPropertyEditor);

  CreateDesignPropertyEditorLocal(TypeInfo(TFileName), nil, 'FileName', TFilenameProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(string), TAnimate, 'FileName', TFilenameProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(TMenuItem), TMainMenu, 'Items', TMenuItemProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TMenuItem), TPopupMenu, 'Items', TMenuItemProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TTreeNodes), nil, '', TTreeNodeProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TListItems), nil, '', TListItemProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TCollection), nil, '', TCollectionProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(string), TCommonDialog, 'Filter', TFilterProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(string), TMaskEdit, 'EditMask', TMaskProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(TIBFileName), TIBDatabase, 'DatabaseName', TIBFileNameProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(string), TIBTable, 'TableName', TIBTableNameProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(string), TIBTable, 'IndexName', TIBIndexNameProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(string), TIBTable, 'IndexFieldNames', TIBIndexFieldNamesProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(string), TIBStoredProc, 'StoredProcName', TIBStoredProcNameProperty);


  CreateDesignPropertyEditorLocal(TypeInfo(TColor), TPersistent, '', TLightColorProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(string), TInterface, 'InterfaceName', TInterfaceNameProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(TNotifyEvent),nil,nil,TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TCloseEvent),nil,nil,TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TCloseQueryEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(THelpEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TShortCutEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TDockDropEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TDockOverEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TGetSiteInfoEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TKeyEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TKeyPressEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TMouseWheelEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TMouseWheelUpDownEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TUnDockEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TCanResizeEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TConstrainedResizeEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TContextPopupEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TDragDropEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TDragOverEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TEndDragEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TMouseEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TMouseMoveEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TStartDockEvent),nil,nil, TExtendedMethodProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(TProgressEvent),nil,nil, TExtendedMethodProperty);
  CreateDesignPropertyEditorLocal(TypeInfo(TDetailEvent),nil,nil, TExtendedMethodProperty);
  
  CreateDesignPropertyEditorLocal(TypeInfo(TtsvVirtualNodeOnGetImageIndexEvent),nil,nil, TExtendedMethodProperty);

  CreateDesignPropertyEditorLocal(TypeInfo(String), TADManager,'ConnectionDefFileName', TADConnectionDefFileNameProp);
  CreateDesignPropertyEditorLocal(TypeInfo(String), TADConnection, 'ConnectionDefName', TADConnectionDefNameProp);
  CreateDesignPropertyEditorLocal(TypeInfo(String), TADConnection,'DriverName', TADDriverNameProp);
  CreateDesignPropertyEditorLocal(TypeInfo(String), TADRdbmsDataSet,'ConnectionName', TADConnectionNameProp);
  CreateDesignPropertyEditorLocal(TypeInfo(String), TADTable, 'TableName', TADTableNameProp);


end;

procedure ClearListDesignPropertyRemoveHandles;
var
  i: Integer;
begin
  for i:=0 to ListDesignPropertyRemoveHandles.Count-1 do begin
    _FreeDesignPropertyRemove(THandle(ListDesignPropertyRemoveHandles.Items[i]));
  end;
  ListDesignPropertyRemoveHandles.Clear;
end;

procedure AddToListDesignPropertyRemoveHandles;

   function CreateDesignPropertyRemoveLocal(Name: PChar; Cls: TPersistentClass=nil): THandle;
   var
     TCDPR: TCreateDesignPropertyRemove;
   begin
     FillChar(TCDPR,SizeOf(TCreateDesignPropertyRemove),0);
     TCDPR.Name:=Name;
     TCDPR.Cls:=Cls;
     Result:=_CreateDesignPropertyRemove(@TCDPR);
     ListDesignPropertyRemoveHandles.Add(Pointer(Result));
   end;

begin
  // Properties

  CreateDesignPropertyRemoveLocal('BiDiMode');
  CreateDesignPropertyRemoveLocal('OwnerDraw');
  CreateDesignPropertyRemoveLocal('ParentBiDiMode');
  CreateDesignPropertyRemoveLocal('HelpContext');
  CreateDesignPropertyRemoveLocal('TrackButton');
  CreateDesignPropertyRemoveLocal('AllowGrayed');
  CreateDesignPropertyRemoveLocal('LargeChange');
  CreateDesignPropertyRemoveLocal('SmallChange');
  CreateDesignPropertyRemoveLocal('HelpFile');
  CreateDesignPropertyRemoveLocal('ThumbSize');
  CreateDesignPropertyRemoveLocal('ObjectMenuItem');
  CreateDesignPropertyRemoveLocal('OldCreateOrder');
  CreateDesignPropertyRemoveLocal('ImeMode');
  CreateDesignPropertyRemoveLocal('ImeName');
  CreateDesignPropertyRemoveLocal('OEMConvert');
  CreateDesignPropertyRemoveLocal('ScrollOpposite');
  CreateDesignPropertyRemoveLocal('ThumbnLenght');
  CreateDesignPropertyRemoveLocal('CalAlignment');
  CreateDesignPropertyRemoveLocal('CalColors');
  CreateDesignPropertyRemoveLocal('BackColor');
  CreateDesignPropertyRemoveLocal('MonthBackColor');
  CreateDesignPropertyRemoveLocal('TextColor');
  CreateDesignPropertyRemoveLocal('TitleBackColor');
  CreateDesignPropertyRemoveLocal('TrailingTextColor');
  CreateDesignPropertyRemoveLocal('ToolTips');
  CreateDesignPropertyRemoveLocal('AllocBy');
  CreateDesignPropertyRemoveLocal('FlatScrollBars');
  CreateDesignPropertyRemoveLocal('OwnerData');
  CreateDesignPropertyRemoveLocal('DragScroll');
  CreateDesignPropertyRemoveLocal('AutoVerbMenu');
  CreateDesignPropertyRemoveLocal('ThumbLength');
  CreateDesignPropertyRemoveLocal('SizeGrip');
  CreateDesignPropertyRemoveLocal('AutoHotKeys');
  CreateDesignPropertyRemoveLocal('AutoLineReduction');
  CreateDesignPropertyRemoveLocal('ShareImages');
  CreateDesignPropertyRemoveLocal('ofNoDereferenceLinks');
  CreateDesignPropertyRemoveLocal('ofEnableIncludeNotify');
  CreateDesignPropertyRemoveLocal('fdNoFaceSel');
  CreateDesignPropertyRemoveLocal('fdNoSimulations');
  CreateDesignPropertyRemoveLocal('fdScalableOnly');
  CreateDesignPropertyRemoveLocal('cdSolidColor');
  CreateDesignPropertyRemoveLocal('cdAnyColor');
  CreateDesignPropertyRemoveLocal('Collate');
  CreateDesignPropertyRemoveLocal('StoreDefs');
  CreateDesignPropertyRemoveLocal('UniDirectional');
  CreateDesignPropertyRemoveLocal('FixedBackground');
  CreateDesignPropertyRemoveLocal('Indeterminate');
  CreateDesignPropertyRemoveLocal('DOMVendor');

  // Events

  CreateDesignPropertyRemoveLocal('OnDragDrop');
  CreateDesignPropertyRemoveLocal('OnDragOver');
  CreateDesignPropertyRemoveLocal('OnEndDock');
  CreateDesignPropertyRemoveLocal('OnEndDrag');
  CreateDesignPropertyRemoveLocal('OnStartDock');
  CreateDesignPropertyRemoveLocal('OnStartDrag');
  CreateDesignPropertyRemoveLocal('OnCanResize');
  CreateDesignPropertyRemoveLocal('OnConstrainedResize');
  CreateDesignPropertyRemoveLocal('OnDockDrop');
  CreateDesignPropertyRemoveLocal('OnDockOver');
  CreateDesignPropertyRemoveLocal('OnGetSiteInfo');
  CreateDesignPropertyRemoveLocal('OnMouseWheel');
  CreateDesignPropertyRemoveLocal('OnMouseWheelDown');
  CreateDesignPropertyRemoveLocal('OnMouseWheelUp');
  CreateDesignPropertyRemoveLocal('OnUnDock');
  CreateDesignPropertyRemoveLocal('OnMeasureItem');
  CreateDesignPropertyRemoveLocal('OnTopLeftChanged');
  CreateDesignPropertyRemoveLocal('OnBandDrag');
  CreateDesignPropertyRemoveLocal('OnBandInfo');
  CreateDesignPropertyRemoveLocal('OnBandMove');
  CreateDesignPropertyRemoveLocal('OnBandPaint');
  CreateDesignPropertyRemoveLocal('OnResizeRequest');
  CreateDesignPropertyRemoveLocal('OnAdvancedCustomDraw');
  CreateDesignPropertyRemoveLocal('OnAdvancedCustomDrawItem');
  CreateDesignPropertyRemoveLocal('OnAdvancedCustomDrawSubItem');
  CreateDesignPropertyRemoveLocal('OnCustomDraw');
  CreateDesignPropertyRemoveLocal('OnCustomDrawItem');
  CreateDesignPropertyRemoveLocal('OnCustomDrawSubItem');
  CreateDesignPropertyRemoveLocal('OnNotify');
  CreateDesignPropertyRemoveLocal('OnDrawColumnCell');
  CreateDesignPropertyRemoveLocal('OnDrawDataCell');
  CreateDesignPropertyRemoveLocal('BeforeAction');
  CreateDesignPropertyRemoveLocal('OnAdvancedDrawItem');

end;

procedure ClearListDesignPropertyTranslateHandles;
var
  i: Integer;
begin
  for i:=0 to ListDesignPropertyTranslateHandles.Count-1 do begin
    _FreeDesignPropertyTranslate(THandle(ListDesignPropertyTranslateHandles.Items[i]));
  end;
  ListDesignPropertyTranslateHandles.Clear;
end;

procedure AddToListDesignPropertyTranslateHandles;

   function CreateDesignPropertyTranslateLocal(Real, Translate: PChar; Cls: TPersistentClass=nil): THandle;
   var
     TCDPT: TCreateDesignPropertyTranslate;
   begin
     FillChar(TCDPT,SizeOf(TCreateDesignPropertyTranslate),0);
     TCDPT.Real:=Real;
     TCDPT.Translate:=Translate;
     TCDPT.Cls:=Cls;
     Result:=_CreateDesignPropertyTranslate(@TCDPT);
     ListDesignPropertyTranslateHandles.Add(Pointer(Result));
   end;

begin
  CreateDesignPropertyTranslateLocal('Action','��������');
  CreateDesignPropertyTranslateLocal('Align','��������');
  CreateDesignPropertyTranslateLocal('Anchors','�����');
  CreateDesignPropertyTranslateLocal('AutoSize','����������');
  CreateDesignPropertyTranslateLocal('Caption','���������');
  CreateDesignPropertyTranslateLocal('ClientHeight','���������� ������');
  CreateDesignPropertyTranslateLocal('ClientWidth','���������� ������');
  CreateDesignPropertyTranslateLocal('Color','����');
  CreateDesignPropertyTranslateLocal('Constraints','�����������');
  CreateDesignPropertyTranslateLocal('Cursor','������');
  CreateDesignPropertyTranslateLocal('DragCursor','������ ��� ��������������');
  CreateDesignPropertyTranslateLocal('DragKind','����� ��������������');
  CreateDesignPropertyTranslateLocal('DragMode','����� ��������������');
  CreateDesignPropertyTranslateLocal('Enabled','�������');
  CreateDesignPropertyTranslateLocal('Font','�����');
  CreateDesignPropertyTranslateLocal('Height','������');
  CreateDesignPropertyTranslateLocal('Hint','���������');
  CreateDesignPropertyTranslateLocal('Left','�����');
  CreateDesignPropertyTranslateLocal('Name','���');
  CreateDesignPropertyTranslateLocal('ParentColor','����������� ����');
  CreateDesignPropertyTranslateLocal('ParentShowHint','����������� ��������� ���������');
  CreateDesignPropertyTranslateLocal('PopupMenu','����������� ����');
  CreateDesignPropertyTranslateLocal('ShowHint','���������� ���������');
  CreateDesignPropertyTranslateLocal('Text','�����');
  CreateDesignPropertyTranslateLocal('Top','������');
  CreateDesignPropertyTranslateLocal('Visible','���������');
  CreateDesignPropertyTranslateLocal('Width','������');
  CreateDesignPropertyTranslateLocal('BevelEdges','���� ����������');
  CreateDesignPropertyTranslateLocal('BevelInner','���������� ����������');
  CreateDesignPropertyTranslateLocal('BevelKind','����� ����������');
  CreateDesignPropertyTranslateLocal('BevelWidth','������ ����������');
  CreateDesignPropertyTranslateLocal('BorderWidth','������ �������');
  CreateDesignPropertyTranslateLocal('Brush','�����');
  CreateDesignPropertyTranslateLocal('Pen','�����');
  CreateDesignPropertyTranslateLocal('Ctl3D','3D ����������');
  CreateDesignPropertyTranslateLocal('DockSite','����� ��������');
  CreateDesignPropertyTranslateLocal('ParentCtl3D','����������� 3D ����������');
  CreateDesignPropertyTranslateLocal('TabOrder','������� ��������');
  CreateDesignPropertyTranslateLocal('TabStop','��������� ��� ��������');
  CreateDesignPropertyTranslateLocal('UseDockManager','������������ �������� ��������');
  CreateDesignPropertyTranslateLocal('Alignment','������������');
  CreateDesignPropertyTranslateLocal('FullRepaint','������ �����������');
  CreateDesignPropertyTranslateLocal('FocusControl','������������ ������');
  CreateDesignPropertyTranslateLocal('Layout','������');
  CreateDesignPropertyTranslateLocal('ShowAccelChar','���������� ������������� ��� &');
  CreateDesignPropertyTranslateLocal('WordWrap','������� ���� �� ������ ������');
  CreateDesignPropertyTranslateLocal('AutoSelect','���������');
  CreateDesignPropertyTranslateLocal('BorderStyle','����� �������');
  CreateDesignPropertyTranslateLocal('CharCase','�������');
  CreateDesignPropertyTranslateLocal('HideSelection','��������� ���������');
  CreateDesignPropertyTranslateLocal('MaxLength','����.�����');
  CreateDesignPropertyTranslateLocal('PasswordChar','����� ������');
  CreateDesignPropertyTranslateLocal('ReadOnly','������ ������');
  CreateDesignPropertyTranslateLocal('AutoMerge','�����������');
  CreateDesignPropertyTranslateLocal('Images','������ ��������');
  CreateDesignPropertyTranslateLocal('Items','��������');
  CreateDesignPropertyTranslateLocal('AutoPopup','������������');
  CreateDesignPropertyTranslateLocal('MenuAnimation','�������� ����');
  CreateDesignPropertyTranslateLocal('Lines','�����');
  CreateDesignPropertyTranslateLocal('ScrollBars','������ �������������');
  CreateDesignPropertyTranslateLocal('WantReturns','������� �������');
  CreateDesignPropertyTranslateLocal('WantTabs','���������');
  CreateDesignPropertyTranslateLocal('Cancel','������');
  CreateDesignPropertyTranslateLocal('Default','�� ���������');
  CreateDesignPropertyTranslateLocal('ModalResult','��������� �����������');
  CreateDesignPropertyTranslateLocal('Checked','�������');
  CreateDesignPropertyTranslateLocal('State','������');
  CreateDesignPropertyTranslateLocal('Columns','�������');
  CreateDesignPropertyTranslateLocal('ExtendedSelect','����������� ���������');
  CreateDesignPropertyTranslateLocal('IntegralHeight','������������ ������');
  CreateDesignPropertyTranslateLocal('ItemHeight','������ ��������');
  CreateDesignPropertyTranslateLocal('ItemIndex','������ ��������');
  CreateDesignPropertyTranslateLocal('MultiSelect','���������������');
  CreateDesignPropertyTranslateLocal('Sorted','����������');
  CreateDesignPropertyTranslateLocal('TabWidth','������ ��������');
  CreateDesignPropertyTranslateLocal('TopIndex','������� ������');
  CreateDesignPropertyTranslateLocal('fsBold','������');
  CreateDesignPropertyTranslateLocal('fsItalic','������');
  CreateDesignPropertyTranslateLocal('fsUnderline','������������');
  CreateDesignPropertyTranslateLocal('fsStrikeOut','�������������');
  CreateDesignPropertyTranslateLocal('DropDownCount','���������� ���������� ���������');
  CreateDesignPropertyTranslateLocal('Kind','�����');
  CreateDesignPropertyTranslateLocal('Max','��������.');
  CreateDesignPropertyTranslateLocal('Min','�������.');
  CreateDesignPropertyTranslateLocal('PageSize','������ ��������');
  CreateDesignPropertyTranslateLocal('Position','�������');
  CreateDesignPropertyTranslateLocal('Actions','��������');
  CreateDesignPropertyTranslateLocal('MaxHeight','����.������');
  CreateDesignPropertyTranslateLocal('MaxWidth','����.������');
  CreateDesignPropertyTranslateLocal('MinHeight','���.������');
  CreateDesignPropertyTranslateLocal('MinWidth','���.������');
  CreateDesignPropertyTranslateLocal('ActiveControl','�������� ������');
  CreateDesignPropertyTranslateLocal('AutoScroll','�������������');
  CreateDesignPropertyTranslateLocal('BorderIcons','������ �������');
  CreateDesignPropertyTranslateLocal('biSystemMenu','��������� ������');
  CreateDesignPropertyTranslateLocal('biMinimize','������ ��������');
  CreateDesignPropertyTranslateLocal('biMaximize','������ ����������');
  CreateDesignPropertyTranslateLocal('biHelp','������ ������');
  CreateDesignPropertyTranslateLocal('DefaultMonitor','������� �� ���������');
  CreateDesignPropertyTranslateLocal('FormStyle','����� �����');
  CreateDesignPropertyTranslateLocal('HorzScrollBar','�������������� ������');
  CreateDesignPropertyTranslateLocal('VertScrollBar','������������ ������');
  CreateDesignPropertyTranslateLocal('ButtonSize','������ ������');
  CreateDesignPropertyTranslateLocal('Increment','����������');
  CreateDesignPropertyTranslateLocal('Margin','������');
  CreateDesignPropertyTranslateLocal('Range','�������');
  CreateDesignPropertyTranslateLocal('Size','������');
  CreateDesignPropertyTranslateLocal('Smooth','���������');
  CreateDesignPropertyTranslateLocal('Style','�����');
  CreateDesignPropertyTranslateLocal('Tracking','�����������');
  CreateDesignPropertyTranslateLocal('Icon','������');
  CreateDesignPropertyTranslateLocal('Bitmap','������� �����������');
  CreateDesignPropertyTranslateLocal('KeyPreview','����������� ������� ������');
  CreateDesignPropertyTranslateLocal('Menu','����');
  CreateDesignPropertyTranslateLocal('ParentFont','����������� �����');
  CreateDesignPropertyTranslateLocal('PixelsPerInch','���������� �������� �� ����');
  CreateDesignPropertyTranslateLocal('PrintScale','������� ��� ������');
  CreateDesignPropertyTranslateLocal('Scaled','���������������');
  CreateDesignPropertyTranslateLocal('Tag','��������');
  CreateDesignPropertyTranslateLocal('WindowMenu','���� ����');
  CreateDesignPropertyTranslateLocal('WindowState','������ ����');
  CreateDesignPropertyTranslateLocal('Charset','���������');
  CreateDesignPropertyTranslateLocal('Pitch','���');
  CreateDesignPropertyTranslateLocal('akLeft','�����');
  CreateDesignPropertyTranslateLocal('akTop','������');
  CreateDesignPropertyTranslateLocal('akRight','������');
  CreateDesignPropertyTranslateLocal('akBottom','�����');
  CreateDesignPropertyTranslateLocal('GroupIndex','������ �����������');
  CreateDesignPropertyTranslateLocal('Transparent','������������');
  CreateDesignPropertyTranslateLocal('AllowAllUp','������ �����');
  CreateDesignPropertyTranslateLocal('Flat','����');
  CreateDesignPropertyTranslateLocal('Down','��������');
  CreateDesignPropertyTranslateLocal('beLeft','�����');
  CreateDesignPropertyTranslateLocal('beTop','������');
  CreateDesignPropertyTranslateLocal('beRight','������');
  CreateDesignPropertyTranslateLocal('beBottom','�����');
  CreateDesignPropertyTranslateLocal('EditMask','����� ��������������');
  CreateDesignPropertyTranslateLocal('BevelOuter','������� ����������');
  CreateDesignPropertyTranslateLocal('DefaultColorColor','���� �� ���������');
  CreateDesignPropertyTranslateLocal('NoneColorColor','���� �������� ���');
  CreateDesignPropertyTranslateLocal('Selected','����������');
  CreateDesignPropertyTranslateLocal('Glyph','������� �����������');
  CreateDesignPropertyTranslateLocal('NumGlyphs','���������� �����������');
  CreateDesignPropertyTranslateLocal('Spacing','����������');
  CreateDesignPropertyTranslateLocal('cbStandardColors','����������� �����');
  CreateDesignPropertyTranslateLocal('cbExtendedColors','����������� �����');
  CreateDesignPropertyTranslateLocal('cbSystemColors','��������� �����');
  CreateDesignPropertyTranslateLocal('cbIncludeNone','������� ��� �����');
  CreateDesignPropertyTranslateLocal('cbIncludeDefault','������� ����� �� ���������');
  CreateDesignPropertyTranslateLocal('cbCustomColor','���������� �����');
  CreateDesignPropertyTranslateLocal('cbPrettyNames','����������� �����');

  CreateDesignPropertyTranslateLocal('ColCount','���������� �������');
  CreateDesignPropertyTranslateLocal('DefaultColWidth','������ ������� �� ���������');
  CreateDesignPropertyTranslateLocal('DefaultDrawing','����������� �� ���������');
  CreateDesignPropertyTranslateLocal('DefaultRowHeight','������ ������ �� ���������');
  CreateDesignPropertyTranslateLocal('FixedColor','������������� ����');
  CreateDesignPropertyTranslateLocal('FixedCols','���������� ����. �������');
  CreateDesignPropertyTranslateLocal('FixedRows','���������� ����. �����');
  CreateDesignPropertyTranslateLocal('GridLineWidth','������ ����� �����');
  CreateDesignPropertyTranslateLocal('RowCount','���������� �����');
  CreateDesignPropertyTranslateLocal('Options','���������');
  CreateDesignPropertyTranslateLocal('goFixedVertLine','����.������������ �����');
  CreateDesignPropertyTranslateLocal('goFixedHorzLine','����.�������������� �����');
  CreateDesignPropertyTranslateLocal('goVertLine','������������ �����');
  CreateDesignPropertyTranslateLocal('goHorzLine','�������������� �����');
  CreateDesignPropertyTranslateLocal('goRangeSelect','������������� ���������');
  CreateDesignPropertyTranslateLocal('goDrawFocusSelect','�������� ����� ����������');
  CreateDesignPropertyTranslateLocal('goRowSizing','�������� ������ ������');
  CreateDesignPropertyTranslateLocal('goColSizing','�������� ������ �������');
  CreateDesignPropertyTranslateLocal('goRowMoving','����������� ������');
  CreateDesignPropertyTranslateLocal('goColMoving','����������� �������');
  CreateDesignPropertyTranslateLocal('goEditing','��������������');
  CreateDesignPropertyTranslateLocal('goTabs','���������');
  CreateDesignPropertyTranslateLocal('goRowSelect','�������� ������');
  CreateDesignPropertyTranslateLocal('goAlwaysShowEditor','������ ���������� ��������');
  CreateDesignPropertyTranslateLocal('goThumbTracking','�����������');
  CreateDesignPropertyTranslateLocal('Center','���������');
  CreateDesignPropertyTranslateLocal('IncrementalDisplay','��������������� �������');
  CreateDesignPropertyTranslateLocal('Picture','�����������');
  CreateDesignPropertyTranslateLocal('Stretch','�����������');
  CreateDesignPropertyTranslateLocal('Shape','������');
  CreateDesignPropertyTranslateLocal('Mode','�����');
  CreateDesignPropertyTranslateLocal('AutoSnap','�������');
  CreateDesignPropertyTranslateLocal('Beveled','�����������');
  CreateDesignPropertyTranslateLocal('MinSize','����������� ������');
  CreateDesignPropertyTranslateLocal('ResizeStyle','����� ������������');
  CreateDesignPropertyTranslateLocal('AutoDock','������������');
  CreateDesignPropertyTranslateLocal('AutoDrag','������������������');
  CreateDesignPropertyTranslateLocal('RowSize','������ ������');
  CreateDesignPropertyTranslateLocal('RowSnap','��� ������');
  CreateDesignPropertyTranslateLocal('HotTrack','���������');
  CreateDesignPropertyTranslateLocal('MultiLine','�����������');
  CreateDesignPropertyTranslateLocal('RaggedRight','���������� ������');

  CreateDesignPropertyTranslateLocal('TabHeight','������ ��������');
  CreateDesignPropertyTranslateLocal('TabIndex','������ ��������');
  CreateDesignPropertyTranslateLocal('TabPosition','������� ��������');
  CreateDesignPropertyTranslateLocal('Tabs','��������');
  CreateDesignPropertyTranslateLocal('ActivePage','�������� ��������');
  CreateDesignPropertyTranslateLocal('HideScrollBars','������ �������');
  CreateDesignPropertyTranslateLocal('PlainText','������ �����');
  CreateDesignPropertyTranslateLocal('Frequency','�������');
  CreateDesignPropertyTranslateLocal('LineSize','������ �����');
  CreateDesignPropertyTranslateLocal('Orientation','����������');
  CreateDesignPropertyTranslateLocal('SelEnd','����� ���������');
  CreateDesignPropertyTranslateLocal('SelStart','������ ���������');
  CreateDesignPropertyTranslateLocal('SliderVisible','���������� ������');
  CreateDesignPropertyTranslateLocal('TickMarks','����������� �����');
  CreateDesignPropertyTranslateLocal('TickStyle','����� �����');
  CreateDesignPropertyTranslateLocal('AlignButton','�������� ������');
  CreateDesignPropertyTranslateLocal('ArrowKeys','������������ �������');
  CreateDesignPropertyTranslateLocal('Associate','����������');
  CreateDesignPropertyTranslateLocal('Wrap','�������');
  CreateDesignPropertyTranslateLocal('Thousands','������');
  CreateDesignPropertyTranslateLocal('HotKey','������� �������');
  CreateDesignPropertyTranslateLocal('Modifiers','������������');
  CreateDesignPropertyTranslateLocal('hkShift','Shift');
  CreateDesignPropertyTranslateLocal('hkCtrl','Ctrl');
  CreateDesignPropertyTranslateLocal('hkAlt','Alt');
  CreateDesignPropertyTranslateLocal('hkExt','Ext');
  CreateDesignPropertyTranslateLocal('InvalidKeys','����������� �������');
  CreateDesignPropertyTranslateLocal('hcNone','���');
  CreateDesignPropertyTranslateLocal('hcShift','Shift');
  CreateDesignPropertyTranslateLocal('hcCtrl','Ctrl');
  CreateDesignPropertyTranslateLocal('hcAlt','Alt');
  CreateDesignPropertyTranslateLocal('hcShiftCtrl','ShiftCtrl');
  CreateDesignPropertyTranslateLocal('hcShiftAlt','ShiftAlt');
  CreateDesignPropertyTranslateLocal('hcCtrlAlt','CtrlAlt');
  CreateDesignPropertyTranslateLocal('hcShiftCtrlAlt','ShiftCtrlAlt');
  CreateDesignPropertyTranslateLocal('Active','��������');
  CreateDesignPropertyTranslateLocal('CommonAVI','��������� AVI');
  CreateDesignPropertyTranslateLocal('FileName','��� �����');
  CreateDesignPropertyTranslateLocal('Repetitions','����������');
  CreateDesignPropertyTranslateLocal('StartFrame','������ ����');
  CreateDesignPropertyTranslateLocal('StopFrame','���� ���� ');
  CreateDesignPropertyTranslateLocal('Timers','�������');
  CreateDesignPropertyTranslateLocal('Date','����');
  CreateDesignPropertyTranslateLocal('DateFormat','������ ����');
  CreateDesignPropertyTranslateLocal('DateMode','����� ����');
  CreateDesignPropertyTranslateLocal('MaxDate','������������ ����');
  CreateDesignPropertyTranslateLocal('MinDate','����������� ����');
  CreateDesignPropertyTranslateLocal('ParseInput','��������� ����');
  CreateDesignPropertyTranslateLocal('ShowCheckBox','���������� ������');
  CreateDesignPropertyTranslateLocal('Time','�����');
  CreateDesignPropertyTranslateLocal('FirstDayOfWeek','������ ���� ������');
  CreateDesignPropertyTranslateLocal('MaxSelectRange','����������� ���������� ����������');
  CreateDesignPropertyTranslateLocal('ShowToday','���������� �������');
  CreateDesignPropertyTranslateLocal('ShowTodayCircle','���������� ������� � �����');
  CreateDesignPropertyTranslateLocal('WeekNumbers','������ ������');
  CreateDesignPropertyTranslateLocal('AutoExpand','�������������');
  CreateDesignPropertyTranslateLocal('ChangeDelay','�������� ���������');
  CreateDesignPropertyTranslateLocal('Indent','������');
  CreateDesignPropertyTranslateLocal('RightClickSelect','�������� ������ ������� ����');
  CreateDesignPropertyTranslateLocal('RowSelect','�������� ������');
  CreateDesignPropertyTranslateLocal('ShowButtons','���������� ������');
  CreateDesignPropertyTranslateLocal('ShowLines','���������� �����');
  CreateDesignPropertyTranslateLocal('ShowRoot','���������� ������');
  CreateDesignPropertyTranslateLocal('SortType','��� ����������');
  CreateDesignPropertyTranslateLocal('StateImages','��������� ������ ��������');
  CreateDesignPropertyTranslateLocal('Checkboxes','������');
  CreateDesignPropertyTranslateLocal('ColumnClick','������� �� �������');
  CreateDesignPropertyTranslateLocal('FullDrag','������ ��������������');
  CreateDesignPropertyTranslateLocal('GridLines','����� �����');
  CreateDesignPropertyTranslateLocal('HotTrackStyles','����� ���������');
  CreateDesignPropertyTranslateLocal('htHandPoint','�����');
  CreateDesignPropertyTranslateLocal('htUnderlineCold','��������������');
  CreateDesignPropertyTranslateLocal('htUnderlineHot','�������������');
  CreateDesignPropertyTranslateLocal('HoverTime','����� ������������ ���������');
  CreateDesignPropertyTranslateLocal('IconOptions','��������� ����');
  CreateDesignPropertyTranslateLocal('Arrangement','����������');
  CreateDesignPropertyTranslateLocal('AutoArrange','��������������');
  CreateDesignPropertyTranslateLocal('WrapText','������� ������� � ������');
  CreateDesignPropertyTranslateLocal('LargeImages','������ �������� ��� ������� ������');
  CreateDesignPropertyTranslateLocal('ShowColumnHeaders','���������� ��������� �������');
  CreateDesignPropertyTranslateLocal('ShowWorkAreas','���������� ������� �������');
  CreateDesignPropertyTranslateLocal('SmallImages','������ �������� ��� ��������� ������');
  CreateDesignPropertyTranslateLocal('ViewStyle','����� ������');
  CreateDesignPropertyTranslateLocal('AutoHint','�������������');
  CreateDesignPropertyTranslateLocal('Panels','������');
  CreateDesignPropertyTranslateLocal('SimplePanel','������� ������');
  CreateDesignPropertyTranslateLocal('SimpleText','������� �����');
  CreateDesignPropertyTranslateLocal('SizeGrid','������ �����');
  CreateDesignPropertyTranslateLocal('UseSystemFont','������������ ��������� �����');
  CreateDesignPropertyTranslateLocal('ButtonHeight','������ �����');
  CreateDesignPropertyTranslateLocal('ButtonWidth','������ ������');
  CreateDesignPropertyTranslateLocal('DisabledImages','������ ����������� ��������');
  CreateDesignPropertyTranslateLocal('EdgeBorders','���� �������');
  CreateDesignPropertyTranslateLocal('ebLeft','�����');
  CreateDesignPropertyTranslateLocal('ebTop','�������');
  CreateDesignPropertyTranslateLocal('ebRight','������');
  CreateDesignPropertyTranslateLocal('ebBottom','������');
  CreateDesignPropertyTranslateLocal('EdgeInner','���������� ����');
  CreateDesignPropertyTranslateLocal('EdgeOuter','������� ����');
  CreateDesignPropertyTranslateLocal('HotImages','������ ������� ��������');
  CreateDesignPropertyTranslateLocal('List','������');
  CreateDesignPropertyTranslateLocal('ShowCaptions','���������� ���������');
  CreateDesignPropertyTranslateLocal('Wrapable','������������');
  CreateDesignPropertyTranslateLocal('BandBorderStyle','����� ������� ������');
  CreateDesignPropertyTranslateLocal('BandMaximize','������������ ������');
  CreateDesignPropertyTranslateLocal('Bands','������');
  CreateDesignPropertyTranslateLocal('FixedOrder','������������� �������');
  CreateDesignPropertyTranslateLocal('FixedSize','������������� ������');
  CreateDesignPropertyTranslateLocal('ShowText','���������� �����');
  CreateDesignPropertyTranslateLocal('Vertical','�����������');
  CreateDesignPropertyTranslateLocal('Control','������');
  CreateDesignPropertyTranslateLocal('AutoEnable','�������������');
  CreateDesignPropertyTranslateLocal('AutoOpen','������������');
  CreateDesignPropertyTranslateLocal('AutoRewind','�������������');
  CreateDesignPropertyTranslateLocal('ColoredButtons','������� ������');
  CreateDesignPropertyTranslateLocal('btPlay','���������������');
  CreateDesignPropertyTranslateLocal('btPause','�����');
  CreateDesignPropertyTranslateLocal('btStop','����');
  CreateDesignPropertyTranslateLocal('btNext','������');
  CreateDesignPropertyTranslateLocal('btPrev','����������');
  CreateDesignPropertyTranslateLocal('btStep','���');
  CreateDesignPropertyTranslateLocal('btBack','�����');
  CreateDesignPropertyTranslateLocal('btRecord','������');
  CreateDesignPropertyTranslateLocal('btEject','�������');
  CreateDesignPropertyTranslateLocal('DeviceType','��� ����������');
  CreateDesignPropertyTranslateLocal('Display','�������');
  CreateDesignPropertyTranslateLocal('EnabledButtons','���������� ������');
  CreateDesignPropertyTranslateLocal('Shareable','�����');
  CreateDesignPropertyTranslateLocal('VisibleButtons','������� ������');
  CreateDesignPropertyTranslateLocal('AllowActiveDoc','������ �������������� ��������');
  CreateDesignPropertyTranslateLocal('AllowInPlace','������ ������');
  CreateDesignPropertyTranslateLocal('AutoActivate','�������������������');
  CreateDesignPropertyTranslateLocal('CopyOnSave','���������� ��� ����������');
  CreateDesignPropertyTranslateLocal('Iconic','���������');
  CreateDesignPropertyTranslateLocal('OldStreamFormat','������ ��������� ������');
  CreateDesignPropertyTranslateLocal('SizeMode','����� ��������� ��������');
  CreateDesignPropertyTranslateLocal('DataSet','����� ������');
  CreateDesignPropertyTranslateLocal('DataSource','�������� ������');
  CreateDesignPropertyTranslateLocal('EndDate','�������� ����');
  CreateDesignPropertyTranslateLocal('TitleFont','����� ��������');
  CreateDesignPropertyTranslateLocal('dgEditing','��������������');
  CreateDesignPropertyTranslateLocal('dgAlwaysShowEditor','������ ���������� ��������');
  CreateDesignPropertyTranslateLocal('dgTitles','��������');
  CreateDesignPropertyTranslateLocal('dgIndicator','���������');
  CreateDesignPropertyTranslateLocal('dgColumnResize','�������� ������� �������');
  CreateDesignPropertyTranslateLocal('dgColLines','����� �� ��������');
  CreateDesignPropertyTranslateLocal('dgRowLines','����� �� �������');
  CreateDesignPropertyTranslateLocal('dgTabs','������ �� TAB');
  CreateDesignPropertyTranslateLocal('dgRowSelect','�������� ������');
  CreateDesignPropertyTranslateLocal('dgAlwaysShowSelection','������ ���������� ���������');
  CreateDesignPropertyTranslateLocal('dgConfirmDelete','������ ��� ��������');
  CreateDesignPropertyTranslateLocal('dgCancelOnExit','������ ��� ������');
  CreateDesignPropertyTranslateLocal('dgMultiSelect','���������������');
  CreateDesignPropertyTranslateLocal('ConfirmDelete','������������ ��������');
  CreateDesignPropertyTranslateLocal('Hints','���������');
  CreateDesignPropertyTranslateLocal('DataField','���� ������');
  CreateDesignPropertyTranslateLocal('AutoDisplay','�����������');
  CreateDesignPropertyTranslateLocal('QuickDraw','������� �����������');
  CreateDesignPropertyTranslateLocal('ValueChecked','�������� ����������');
  CreateDesignPropertyTranslateLocal('ValueUnchecked','�������� �� ����������');
  CreateDesignPropertyTranslateLocal('Values','��������');
  CreateDesignPropertyTranslateLocal('CellSelected','���������� ������');
  CreateDesignPropertyTranslateLocal('RowHeight','������ ������');
  CreateDesignPropertyTranslateLocal('RowSelected','�������� ������');
  CreateDesignPropertyTranslateLocal('RowSizing','���������� ������ ������');
  CreateDesignPropertyTranslateLocal('SelectedCells','���������� ������');
  CreateDesignPropertyTranslateLocal('TitleCellMouseDown','����� ��� ������� ������� ����');
  CreateDesignPropertyTranslateLocal('maLeftToRight','����� �������');
  CreateDesignPropertyTranslateLocal('maRightToLeft','������ ������');
  CreateDesignPropertyTranslateLocal('maTopToBottom','������ ����');
  CreateDesignPropertyTranslateLocal('maBottomToTop','����� �����');
  CreateDesignPropertyTranslateLocal('maNone','���');
  CreateDesignPropertyTranslateLocal('BkColor','���� ������� �����');
  CreateDesignPropertyTranslateLocal('BlendColor','���� ��������� �����');
  CreateDesignPropertyTranslateLocal('DrawingStyle','����� ���������');
  CreateDesignPropertyTranslateLocal('ImageType','��� ��������');
  CreateDesignPropertyTranslateLocal('Masked','�����');
  CreateDesignPropertyTranslateLocal('Interval','��������');
  CreateDesignPropertyTranslateLocal('ofReadOnly','���������� ������ "������ ������"');
  CreateDesignPropertyTranslateLocal('ofOverwritePrompt','�������� ������ ��� ����������');
  CreateDesignPropertyTranslateLocal('ofHideReadOnly','������ ������ "������ ������"');
  CreateDesignPropertyTranslateLocal('ofNoChangeDir','�� �������� ����������');
  CreateDesignPropertyTranslateLocal('ofShowHelp','���������� ������');
  CreateDesignPropertyTranslateLocal('ofNoValidate','���������� �������� �� �������� �������');
  CreateDesignPropertyTranslateLocal('ofAllowMultiSelect','��������� �����������');
  CreateDesignPropertyTranslateLocal('ofExtensionDifferent','���������� ������ ���������');
  CreateDesignPropertyTranslateLocal('ofPathMustExist','��������� ���� �� ����� ����');
  CreateDesignPropertyTranslateLocal('ofCreatePrompt','��������� ���� �� ����� ����');
  CreateDesignPropertyTranslateLocal('ofShareAware','��������� �������� ����� ������������ ���������');
  CreateDesignPropertyTranslateLocal('ofNoReadOnlyReturn','��������� ����� "������ ��� ������"');
  CreateDesignPropertyTranslateLocal('ofNoTestFileCreate','��������� ���� ������ �� �������� �����');
  CreateDesignPropertyTranslateLocal('ofNoNetworkButton','������������ ������ ����');
  CreateDesignPropertyTranslateLocal('ofNoLongNames','�� ������������ ������� �����');
  CreateDesignPropertyTranslateLocal('ofOldStyleDialog','������ ����� �������');
  CreateDesignPropertyTranslateLocal('ofEnableSizing','�������� ��������� ��������');
  CreateDesignPropertyTranslateLocal('ofFileMustExist','�������� �� ������������� �����');
  CreateDesignPropertyTranslateLocal('DefaultExt','���������� �� ���������');
  CreateDesignPropertyTranslateLocal('Filter','������');
  CreateDesignPropertyTranslateLocal('FilterIndex','������ �������');
  CreateDesignPropertyTranslateLocal('InitialDir','������� ���������� ��� ��������');
  CreateDesignPropertyTranslateLocal('Title','��������');
  CreateDesignPropertyTranslateLocal('fdAnsiOnly','���������� ������ ������ �������������� Windows-���������');
  CreateDesignPropertyTranslateLocal('fdTrueTypeOnly','���������� ������ TrueType ������');
  CreateDesignPropertyTranslateLocal('fdEffects','���������� �������');
  CreateDesignPropertyTranslateLocal('fdFixedPitchOnly','���������� ������ FixedPitch ������');
  CreateDesignPropertyTranslateLocal('fdForceFontExist','��������� ���� �� ����� �����');
  CreateDesignPropertyTranslateLocal('fdNoOEMFonts','�� ���������� OEM ������');
  CreateDesignPropertyTranslateLocal('fdNoSizeSel','�� ���������� �������� ��������');
  CreateDesignPropertyTranslateLocal('fdNoStyleSel','�� ���������� ����� ���������');
  CreateDesignPropertyTranslateLocal('fdNoVectorFonts','�� ���������� ��������� ������');
  CreateDesignPropertyTranslateLocal('fdShowHelp','���������� ������');
  CreateDesignPropertyTranslateLocal('fdWysiwyg','���������� ������ �������� � ������');
  CreateDesignPropertyTranslateLocal('fdLimitSize','����������� �������');
  CreateDesignPropertyTranslateLocal('fdApplyButton','������ ���������');
  CreateDesignPropertyTranslateLocal('Device','����������');
  CreateDesignPropertyTranslateLocal('MaxFontSize','����.������ ������');
  CreateDesignPropertyTranslateLocal('MinFontSize','���.������ ������');

  CreateDesignPropertyTranslateLocal('cdFullOpen','��������� ���������');
  CreateDesignPropertyTranslateLocal('cdPreventFullOpen','��������� ����� �������������� ������');
  CreateDesignPropertyTranslateLocal('cdShowHelp','���������� ������');
  CreateDesignPropertyTranslateLocal('CustomColors','���������� �����');
  CreateDesignPropertyTranslateLocal('poPrintToFile','������ � ����');
  CreateDesignPropertyTranslateLocal('poPageNums','���������� �������');
  CreateDesignPropertyTranslateLocal('poSelection','���������');
  CreateDesignPropertyTranslateLocal('poWarning','��������������');
  CreateDesignPropertyTranslateLocal('poHelp','������');
  CreateDesignPropertyTranslateLocal('poDisablePrintToFile','��������� ������ � ����');
  CreateDesignPropertyTranslateLocal('Copies','�����');
  CreateDesignPropertyTranslateLocal('FromPage','�� ��������');
  CreateDesignPropertyTranslateLocal('MaxPage','����.�������');
  CreateDesignPropertyTranslateLocal('MinPage','���.�������');
  CreateDesignPropertyTranslateLocal('PrintRange','������� ������');
  CreateDesignPropertyTranslateLocal('PrintToFile','������ � ����');
  CreateDesignPropertyTranslateLocal('ToPage','�� ��������');
  CreateDesignPropertyTranslateLocal('frDown','����');
  CreateDesignPropertyTranslateLocal('frFindNext','������ �����');
  CreateDesignPropertyTranslateLocal('frHideMatchCase','������ �������� �� �������');
  CreateDesignPropertyTranslateLocal('frHideWholeWord','������ �������� ���� �������');
  CreateDesignPropertyTranslateLocal('frHideUpDown','������ �����-����');
  CreateDesignPropertyTranslateLocal('frMatchCase','�������� �� �������');
  CreateDesignPropertyTranslateLocal('frDisableMatchCase','��������� �������� �� �������');
  CreateDesignPropertyTranslateLocal('frDisableUpDown','��������� �������� �����-����');
  CreateDesignPropertyTranslateLocal('frDisableWholeWord','��������� �������� ���� �������');
  CreateDesignPropertyTranslateLocal('frReplace','������ ������');
  CreateDesignPropertyTranslateLocal('frReplaceAll','������ �������� ���');
  CreateDesignPropertyTranslateLocal('frWholeWord','�������� ���� �������');
  CreateDesignPropertyTranslateLocal('frShowHelp','���������� ������');
  CreateDesignPropertyTranslateLocal('FindText','������� �����');
  CreateDesignPropertyTranslateLocal('ReplaceText','����� ������');
  CreateDesignPropertyTranslateLocal('AutoEdit','������������������');
  CreateDesignPropertyTranslateLocal('nbFirst','� ������');
  CreateDesignPropertyTranslateLocal('nbPrior','����������');
  CreateDesignPropertyTranslateLocal('nbNext','���������');
  CreateDesignPropertyTranslateLocal('nbLast','� �����');
  CreateDesignPropertyTranslateLocal('nbInsert','��������');
  CreateDesignPropertyTranslateLocal('nbDelete','�������');
  CreateDesignPropertyTranslateLocal('nbEdit','�������������');
  CreateDesignPropertyTranslateLocal('nbPost','���������');
  CreateDesignPropertyTranslateLocal('nbCancel','��������');
  CreateDesignPropertyTranslateLocal('nbRefresh','��������');
  CreateDesignPropertyTranslateLocal('AutoCalcFields','���� ����������� ����');
  CreateDesignPropertyTranslateLocal('BufferChunks','���������������� �����');
  CreateDesignPropertyTranslateLocal('CachedUpdates','��������� � ����');
  CreateDesignPropertyTranslateLocal('Database','���� ������');
  CreateDesignPropertyTranslateLocal('DefaultIndex','������ �� ���������');
  CreateDesignPropertyTranslateLocal('FieldDefs','���� �� ���������');
  CreateDesignPropertyTranslateLocal('Filtered','�������������');
  CreateDesignPropertyTranslateLocal('ForcedRefresh','������� ����������');
  CreateDesignPropertyTranslateLocal('IndexDefs','������� �� ���������');
  CreateDesignPropertyTranslateLocal('IndexFieldNames','����� ����� ��������');
  CreateDesignPropertyTranslateLocal('IndexName','��� �������');
  CreateDesignPropertyTranslateLocal('MasterSource','������� ��������');
  CreateDesignPropertyTranslateLocal('MasterFields','������� ����');
  CreateDesignPropertyTranslateLocal('ObjectView','������������� �������');
  CreateDesignPropertyTranslateLocal('TableName','��� �������');
  CreateDesignPropertyTranslateLocal('TableTypes','���� ������');
  CreateDesignPropertyTranslateLocal('ttSystem','���������');
  CreateDesignPropertyTranslateLocal('ttView','�������������');
  CreateDesignPropertyTranslateLocal('Transaction','����������');
  CreateDesignPropertyTranslateLocal('UpdateObject','������ ���������');

  CreateDesignPropertyTranslateLocal('ParamsCheck','�������� ����������');
  CreateDesignPropertyTranslateLocal('ParamCheck','�������� ���������');
  CreateDesignPropertyTranslateLocal('Params','���������');
  CreateDesignPropertyTranslateLocal('SQL','SQL');
  CreateDesignPropertyTranslateLocal('StoredProcName','��� �������� ���������');
  CreateDesignPropertyTranslateLocal('Connected','���������');
  CreateDesignPropertyTranslateLocal('DatabaseName','��� ���� ������');
  CreateDesignPropertyTranslateLocal('DefaultTransaction','���������� �� ���������');
  CreateDesignPropertyTranslateLocal('IdleTimer','������ ��������');
  CreateDesignPropertyTranslateLocal('LoginPrompt','������ ����������');
  CreateDesignPropertyTranslateLocal('SQLDialect','SQL �������');
  CreateDesignPropertyTranslateLocal('TraceFlags','����� �����������');
  CreateDesignPropertyTranslateLocal('tfQPrepare','����������');
  CreateDesignPropertyTranslateLocal('tfQExecute','������');
  CreateDesignPropertyTranslateLocal('tfQFetch','�������');
  CreateDesignPropertyTranslateLocal('tfError','������');
  CreateDesignPropertyTranslateLocal('tfStmt','��� SQL');
  CreateDesignPropertyTranslateLocal('tfConnect','����������');
  CreateDesignPropertyTranslateLocal('tfTransact','����������');
  CreateDesignPropertyTranslateLocal('tfBlob','��������');
  CreateDesignPropertyTranslateLocal('tfService','������');
  CreateDesignPropertyTranslateLocal('tfMisc','Misc');
  CreateDesignPropertyTranslateLocal('DefaultAction','�������� �� ���������');
  CreateDesignPropertyTranslateLocal('DefaultDatabase','���� ������ �� ���������');
  CreateDesignPropertyTranslateLocal('DeleteSQL','SQL ��� ��������');
  CreateDesignPropertyTranslateLocal('InsertSQL','SQL ��� �������');
  CreateDesignPropertyTranslateLocal('ModifySQL','SQL ��� ���������');
  CreateDesignPropertyTranslateLocal('RefreshSQL','SQL ��� ����������');
  CreateDesignPropertyTranslateLocal('SelectSQL','SQL ��� �������');
  CreateDesignPropertyTranslateLocal('GoToFirstRecordOnExecute','���������� �� ������ ������ ��� �������');
  CreateDesignPropertyTranslateLocal('Events','�������');
  CreateDesignPropertyTranslateLocal('Registered','��������������');
  CreateDesignPropertyTranslateLocal('Break','�������');
  CreateDesignPropertyTranslateLocal('ImageIndex','������ ��������');
  CreateDesignPropertyTranslateLocal('RadioItem','���������� �����');
  CreateDesignPropertyTranslateLocal('ShortCut','������� �������');
  CreateDesignPropertyTranslateLocal('SubMenuImages','������ �������� ��� ����� ����');
  CreateDesignPropertyTranslateLocal('Bevel','����� �������');
  CreateDesignPropertyTranslateLocal('HorizontalOnly','������ �������������');
  CreateDesignPropertyTranslateLocal('ParentBitmap','����������� ��������');
  CreateDesignPropertyTranslateLocal('ButtonStyle','����� ������');
  CreateDesignPropertyTranslateLocal('DropDownRows','���������� ���������� �����');
  CreateDesignPropertyTranslateLocal('Expanded','�����������');
  CreateDesignPropertyTranslateLocal('FieldName','��� ����');
  CreateDesignPropertyTranslateLocal('PickList','���������� ������');
  CreateDesignPropertyTranslateLocal('FieldNames','������ �����');
  CreateDesignPropertyTranslateLocal('FieldValues','������ ��������');

  CreateDesignPropertyTranslateLocal('ixPrimary','�������');
  CreateDesignPropertyTranslateLocal('ixUnique','����������');
  CreateDesignPropertyTranslateLocal('ixDescending','��������');
  CreateDesignPropertyTranslateLocal('ixCaseInsensitive','� ��������� �� �������');
  CreateDesignPropertyTranslateLocal('ixExpression','�����������');
  CreateDesignPropertyTranslateLocal('ixNonMaintained','�� �����������');
  CreateDesignPropertyTranslateLocal('CaseInsFields','���� � ��������� �� �������');
  CreateDesignPropertyTranslateLocal('DescFields','���� � �������� �����������');
  CreateDesignPropertyTranslateLocal('Expression','���������');
  CreateDesignPropertyTranslateLocal('Fields','����');
  CreateDesignPropertyTranslateLocal('GroupingLevel','������� �����������');
  CreateDesignPropertyTranslateLocal('Source','��������');
  CreateDesignPropertyTranslateLocal('CustomConstraint','������ �����������');
  CreateDesignPropertyTranslateLocal('ErrorMessage','��������� ��� ������');
  CreateDesignPropertyTranslateLocal('FromDictionary','�������� �� �����������');
  CreateDesignPropertyTranslateLocal('ImportedConstraint','������������� �����������');
  CreateDesignPropertyTranslateLocal('Attributes','���������');
  CreateDesignPropertyTranslateLocal('faHiddenCol','������� �������');
  CreateDesignPropertyTranslateLocal('faReadOnly','������ ������');
  CreateDesignPropertyTranslateLocal('faRequired','���������');
  CreateDesignPropertyTranslateLocal('faLink','���������');
  CreateDesignPropertyTranslateLocal('faUnNamed','��� �����');
  CreateDesignPropertyTranslateLocal('faFixed','�������������');
  CreateDesignPropertyTranslateLocal('ChildDefs','�������� ���������');
  CreateDesignPropertyTranslateLocal('DataType','��� ������');
  CreateDesignPropertyTranslateLocal('Precision','��������');
  CreateDesignPropertyTranslateLocal('ParamType','��� ���������');
  CreateDesignPropertyTranslateLocal('Value','��������');
  CreateDesignPropertyTranslateLocal('DropDownMenu','���������� ����');
  CreateDesignPropertyTranslateLocal('Grouped','�����������');
  CreateDesignPropertyTranslateLocal('Marked','����������');
  CreateDesignPropertyTranslateLocal('MenuItem','������� ����');

  CreateDesignPropertyTranslateLocal('Highlighted','���������');
  CreateDesignPropertyTranslateLocal('PageIndex','������ ��������');
  CreateDesignPropertyTranslateLocal('TabVisible','����� ��������');
  CreateDesignPropertyTranslateLocal('ExecProcName','��� ����������� ���������');
  CreateDesignPropertyTranslateLocal('ExecProcParams','��������� ����������� ���������');
  CreateDesignPropertyTranslateLocal('InterfaceName','��� ����������');
  CreateDesignPropertyTranslateLocal('ReturnData','����� ������������ ������');
  CreateDesignPropertyTranslateLocal('Condition','�������');
  CreateDesignPropertyTranslateLocal('Visual','���������� ���������');
  CreateDesignPropertyTranslateLocal('Locate','������� �� �������');
  CreateDesignPropertyTranslateLocal('ParamName','��� ���������');
  CreateDesignPropertyTranslateLocal('Type','���');

  // Events

  CreateDesignPropertyTranslateLocal('OnChanging','�� ����� ���������');
  CreateDesignPropertyTranslateLocal('OnChange','��� ���������');
  CreateDesignPropertyTranslateLocal('OnPopup','��� ��������');
  CreateDesignPropertyTranslateLocal('OnExecute','��� �������');
  CreateDesignPropertyTranslateLocal('OnUpdate','��� ���������');
  CreateDesignPropertyTranslateLocal('OnClick','��� ����� �����');
  CreateDesignPropertyTranslateLocal('OnContextPopup','��� ������ �����');
  CreateDesignPropertyTranslateLocal('OnDblClick','��� ������� �����');
  CreateDesignPropertyTranslateLocal('OnMouseDown','��� ������� ������ ����');
  CreateDesignPropertyTranslateLocal('OnMouseMove','��� �������� ����');
  CreateDesignPropertyTranslateLocal('OnMouseUp','��� ���������� ������ ����');
  CreateDesignPropertyTranslateLocal('OnActivate','��� �����������');
  CreateDesignPropertyTranslateLocal('OnClose','��� ��������');
  CreateDesignPropertyTranslateLocal('OnCloseQuery','��� �������� � ��������');
  CreateDesignPropertyTranslateLocal('OnCreate','��� ��������');
  CreateDesignPropertyTranslateLocal('OnDeactivate','��� �������������');
  CreateDesignPropertyTranslateLocal('OnDestroy','��� �����������');
  CreateDesignPropertyTranslateLocal('OnHelp','��� ������ ������');
  CreateDesignPropertyTranslateLocal('OnHide','��� �������');
  CreateDesignPropertyTranslateLocal('OnKeyDown','��� ������� �������');
  CreateDesignPropertyTranslateLocal('OnKeyPress','��� ����������� �������');
  CreateDesignPropertyTranslateLocal('OnKeyUp','��� ���������� �������');
  CreateDesignPropertyTranslateLocal('OnPaint','��� ���������');
  CreateDesignPropertyTranslateLocal('OnResize','��� ��������� ��������');
  CreateDesignPropertyTranslateLocal('OnShortCut','��� ������� ������� �������');
  CreateDesignPropertyTranslateLocal('OnShow','��� ������');
  CreateDesignPropertyTranslateLocal('OnEnter','��� ����� ������');
  CreateDesignPropertyTranslateLocal('OnExit','��� ������ ������');
  CreateDesignPropertyTranslateLocal('OnDrawIntem','��� ��������� ��������');
  CreateDesignPropertyTranslateLocal('OnDropDown','��� ���������');
  CreateDesignPropertyTranslateLocal('OnScroll','��� ���������');
  CreateDesignPropertyTranslateLocal('OnColumnMoved','����� ����������� �������');
  CreateDesignPropertyTranslateLocal('OnDrawCell','��� ��������� ������');
  CreateDesignPropertyTranslateLocal('OnGetEditMask','��� ��������� �����');
  CreateDesignPropertyTranslateLocal('OnGetEditText','��� ��������� ������');
  CreateDesignPropertyTranslateLocal('OnRowMoved','����� ����������� �����');
  CreateDesignPropertyTranslateLocal('OnSelectCell','��� ������ ������');
  CreateDesignPropertyTranslateLocal('OnSetEditText','��� ������� ������');
  CreateDesignPropertyTranslateLocal('OnProgress','��� ���������');
  CreateDesignPropertyTranslateLocal('OnClickCheck','��� ����� � �������');
  CreateDesignPropertyTranslateLocal('OnMoved','����� �����������');
  CreateDesignPropertyTranslateLocal('On�hanging','��� ���������');
  CreateDesignPropertyTranslateLocal('On�hangingEx','��� ����������� ���������');
  CreateDesignPropertyTranslateLocal('OnDrawTab','��� ��������� ��������');
  CreateDesignPropertyTranslateLocal('OnGetImageIndex','��� ��������� ������� ��������');
  CreateDesignPropertyTranslateLocal('OnProtectChange','��� ���������� ���������');
  CreateDesignPropertyTranslateLocal('OnSaveClipboard','��� ���������� � �����');
  CreateDesignPropertyTranslateLocal('OnOpen','��� ��������');
  CreateDesignPropertyTranslateLocal('OnCloseUp','��� �������� �����');
  CreateDesignPropertyTranslateLocal('OnStart','��� ������');
  CreateDesignPropertyTranslateLocal('OnStop','��� ���������');
  CreateDesignPropertyTranslateLocal('OnUserInput','��� ����� ������������');
  CreateDesignPropertyTranslateLocal('OnGetMonthInfo','��� ��������� ���������� � ������');
  CreateDesignPropertyTranslateLocal('OnCollapsed','����� ������������');
  CreateDesignPropertyTranslateLocal('OnCompare','��� ���������');
  CreateDesignPropertyTranslateLocal('OnDeletion','��� ��������');
  CreateDesignPropertyTranslateLocal('OnEdited','����� ��������������');
  CreateDesignPropertyTranslateLocal('OnEditing','��� ��������������');
  CreateDesignPropertyTranslateLocal('OnExpanded','����� ��������������');
  CreateDesignPropertyTranslateLocal('OnExpanding','��� ��������������');
  CreateDesignPropertyTranslateLocal('OnGetSelectedIndex','��� ��������� ����������� ������� ��������');
  CreateDesignPropertyTranslateLocal('OnTimer','��� ������������ �������');
  CreateDesignPropertyTranslateLocal('OnPostClick','��� ������� �� ������');
  CreateDesignPropertyTranslateLocal('OnObjectMove','��� �������� �������');
  CreateDesignPropertyTranslateLocal('OnCanClose','��� ����������� �������');
  CreateDesignPropertyTranslateLocal('OnFolderChange','��� ��������� ����������');
  CreateDesignPropertyTranslateLocal('OnIncludeItem','��� ��������� ��������');
  CreateDesignPropertyTranslateLocal('OnSelectionChange','��� ��������� ���������');
  CreateDesignPropertyTranslateLocal('OnTypeChange','��� ��������� ����');
  CreateDesignPropertyTranslateLocal('OnApply','��� ����������');
  CreateDesignPropertyTranslateLocal('OnFind','��� ������');
  CreateDesignPropertyTranslateLocal('OnReplace','��� ������');
  CreateDesignPropertyTranslateLocal('OnDataChange','��� ��������� ������');
  CreateDesignPropertyTranslateLocal('OnStateChange','��� ��������� �������');
  CreateDesignPropertyTranslateLocal('OnUpdateData','��� ��������� ������');
  CreateDesignPropertyTranslateLocal('OnCellClick','��� ����� �� ������');
  CreateDesignPropertyTranslateLocal('OnColEnter','��� ����� �� �������');
  CreateDesignPropertyTranslateLocal('OnColExit','��� ������ � �������');
  CreateDesignPropertyTranslateLocal('OnEditButtonClick','��� ����� �� ������ ��������������');
  CreateDesignPropertyTranslateLocal('OnTitleClick','��� ����� �� ��������');
  CreateDesignPropertyTranslateLocal('OnDrawItem','��� ��������� ��������');

  CreateDesignPropertyTranslateLocal('AfterCancel','����� ������');
  CreateDesignPropertyTranslateLocal('AfterClose','����� ��������');
  CreateDesignPropertyTranslateLocal('AfterDatabaseDisconnect','����� ������������ �� ����');
  CreateDesignPropertyTranslateLocal('AfterDelete','����� ��������');
  CreateDesignPropertyTranslateLocal('AfterEdit','����� ��������������');
  CreateDesignPropertyTranslateLocal('AfterInsert','����� �������');
  CreateDesignPropertyTranslateLocal('AfterOpen','����� ��������');
  CreateDesignPropertyTranslateLocal('AfterPost','����� ����������');
  CreateDesignPropertyTranslateLocal('AfterRefresh','����� ����������');
  CreateDesignPropertyTranslateLocal('AfterScroll','����� ���������');
  CreateDesignPropertyTranslateLocal('AfterTransactionEnd','����� ��������� ����������');
  CreateDesignPropertyTranslateLocal('BeforeCancel','����� �������');
  CreateDesignPropertyTranslateLocal('BeforeClose','����� ���������');
  CreateDesignPropertyTranslateLocal('BeforeDatabaseDisconnect','����� ������������� �� ����');
  CreateDesignPropertyTranslateLocal('BeforeDelete','����� ���������');
  CreateDesignPropertyTranslateLocal('BeforeEdit','����� ���������������');
  CreateDesignPropertyTranslateLocal('BeforeInsert','����� ��������');
  CreateDesignPropertyTranslateLocal('BeforeOpen','����� ���������');
  CreateDesignPropertyTranslateLocal('BeforePost','����� �����������');
  CreateDesignPropertyTranslateLocal('BeforeRefresh','����� �����������');
  CreateDesignPropertyTranslateLocal('BeforeScroll','����� ����������');
  CreateDesignPropertyTranslateLocal('BeforeTransactionEnd','����� ���������� ����������');
  CreateDesignPropertyTranslateLocal('DatabaseFree','����� ������������ ����');
  CreateDesignPropertyTranslateLocal('TransactionFree','����� ������������ ����������');
  CreateDesignPropertyTranslateLocal('OnCalcFields','��� ���������� �����');
  CreateDesignPropertyTranslateLocal('OnDeleteError','��� ������ ��������');
  CreateDesignPropertyTranslateLocal('OnEditError','��� ������ ��������������');
  CreateDesignPropertyTranslateLocal('OnFilterRecord','��� ������������ �������');
  CreateDesignPropertyTranslateLocal('OnNewRecord','��� ����� ������');
  CreateDesignPropertyTranslateLocal('OnPostError','��� ������ ����������');
  CreateDesignPropertyTranslateLocal('OnUpdateError','��� ������ ���������');
  CreateDesignPropertyTranslateLocal('OnUpdateRecord','��� ��������� ������');
  CreateDesignPropertyTranslateLocal('AfterConnect','����� ����������');
  CreateDesignPropertyTranslateLocal('AfterDisconnect','����� ������������');
  CreateDesignPropertyTranslateLocal('BeforeDisconnect','����� �������������');
  CreateDesignPropertyTranslateLocal('BeforeConnect','����� �����������');
  CreateDesignPropertyTranslateLocal('OnDialectDowngradeWarning','��� �������� ��������');
  CreateDesignPropertyTranslateLocal('OnIdleTimer','��� ������������ ���������� �������');
  CreateDesignPropertyTranslateLocal('OnLogin','��� ���������� � ����������');
  CreateDesignPropertyTranslateLocal('OnSQLChanging','�� ����� ��������� SQL');
  CreateDesignPropertyTranslateLocal('OnSQL','��� SQL');
  CreateDesignPropertyTranslateLocal('OnEventAlert','��� ������������ �������');
end;

procedure ClearListDesignPaletteHandles;
var
  i: Integer;
begin
  for i:=0 to ListDesignPaletteHandles.Count-1 do begin
    _FreeDesignPalette(THandle(ListDesignPaletteHandles.Items[i]));
  end;
  ListDesignPaletteHandles.Clear;
end;

procedure AddToListDesignPaletteHandles;

   function CreateDesignPaletteButtonLocal(DesignPaletteHandle: THandle;
                                           Hint: PChar;
                                           Cls: TPersistentClass;
                                           ImageIndex: Integer; IL: TImageList=nil;
                                           UseForInterfaces: TSetTypeInterface=[ttiNone,ttiRBook,ttiReport,ttiWizard,
                                                                                ttiJournal,ttiService,ttiDocument]): THandle;
   var
     TCDPB: TCreateDesignPaletteButton;
     Image: TBitmap;
   begin
     Image:=nil;
     try
      Image:=TBitmap.Create;
      FillChar(TCDPB,SizeOf(TCreateDesignPaletteButton),0);
      TCDPB.Hint:=Hint;
      TCDPB.Cls:=Cls;
      TCDPB.UseForInterfaces:=UseForInterfaces;
      if ImageIndex<>-1 then begin
       if IL<>nil then begin
        IL.GetBitmap(ImageIndex,Image);
        TCDPB.Bitmap:=Image;
       end; 
      end; 
      Result:=_CreateDesignPaletteButton(DesignPaletteHandle,@TCDPB);
     finally
      Image.Free;
     end; 
   end;

   function CreateDesignPaletteLocal(Name, Hint: PChar): THandle;
   var
     TCDP: TCreateDesignPalette;
   begin
     FillChar(TCDP,SizeOf(TCreateDesignPalette),0);
     TCDP.Name:=Name;
     TCDP.Hint:=Hint;
     Result:=_CreateDesignPalette(@TCDP);
     ListDesignPaletteHandles.Add(Pointer(Result));
   end;


var
  DPH: THandle;
begin
  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameStandart,ConstDesignPaletteHintStandart);
  CreateDesignPaletteButtonLocal(DPH,'������� ����',TiMainMenu,0,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'����������� ����',TiPopupMenu,1,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�����',TiLabel,2,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'���� �����',TiEdit,3,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������������� ���� �����',TiMemo,4,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������',TiButton,5,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������',TiCheckBox,6,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�������������',TiRadioButton,7,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������',TiListBox,8,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'���������� ������',TiComboBox,9,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'���������',TiScrollBar,10,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������',TiGroupBox,11,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ��������������',TiRadioGroup,12,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������',TiPanel,13,dm.ILStandart);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameAdditional,ConstDesignPaletteHintAdditional);
  CreateDesignPaletteButtonLocal(DPH,'������ � ���������',TiBitBtn,15,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������� ������',TiSpeedButton,16,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� � ������',TiMaskEdit,17,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'����� �� ��������',TiStringGrid,18,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�������� �����',TiDrawGrid,19,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiImage,20,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������',TiShape,21,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'����������',TiBevel,22,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�������������� ����',TiScrollBox,23,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ � �������',TiCheckListBox,24,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiSplitter,25,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'��������� �����',TiStaticText,26,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������� ���',TiControlBar,27,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������� ����������',TiApplicationEvents,28,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������',TiChart,80,dm.ILStandart);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameWin32,ConstDesignPaletteHintWin32);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiTabControl,29,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiPageControl,30,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ��������',TiImageList,31,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'����������� ���� �����',TiRichEdit,32,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiTrackBar,33,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiProgressBar,34,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�����-����',TiUpDown,35,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������� �������',TiHotKey,36,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiAnimate,37,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� ���� � �������',TiDateTimePicker,38,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiMonthCalendar,39,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������',TiTreeView,40,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'����������� ������',TiListView,41,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ �������',TiStatusBar,42,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ������������',TiToolBar,43,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ������',TiCoolBar,44,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ���������',TiPageScroller,45,dm.ILStandart);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameSystem,ConstDesignPaletteHintSystem);
  CreateDesignPaletteButtonLocal(DPH,'������',TiTimer,46,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'���� ��� ���������',TiPaintBox,47,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'����� �������������',TiMediaPlayer,48,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'OLE ���������',TiOleContainer,49,dm.ILStandart);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameDialogs,ConstDesignPaletteHintDialogs);
  CreateDesignPaletteButtonLocal(DPH,'������ ��������',TiOpenDialog,58,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ����������',TiSaveDialog,64,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ �������� ��������',TiOpenPictureDialog,59,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ���������� ��������',TiSavePictureDialog,65,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ������ ������',TiFontDialog,57,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ������ �����',TiColorDialog,60,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ������ ��������',TiPrintDialog,61,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ��������� ��������',TiPrinterSetupDialog,62,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ������',TiFindDialog,56,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������ ������',TiReplaceDialog,63,dm.ILStandart);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameDataControls,ConstDesignPaletteHintDataControls);
  CreateDesignPaletteButtonLocal(DPH,'�������� ������',TiDataSource,54,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'����� ������ �������',TiClientDataSet,79,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'������������� ������',TiDBGrid,55,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ���������',TiDBNavigator,76,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� �����',TiDBText,66,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ���� �����',TiDBEdit,70,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ������������� ���� �����',TiDBMemo,75,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ��������',TiDBImage,71,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ������',TiDBListBox,72,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ���������� ������',TiDBComboBox,68,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ������',TiDBCheckBox,67,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ������ ��������������',TiDBRadioGroup,77,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ����������� ���� �����',TiDBRichEdit,78,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ������',TiDBChart,81,dm.ILStandart);
  CreateDesignPaletteButtonLocal(DPH,'�� ������',TiVirtualDBTree,40,dm.ILStandart);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameInterBase,ConstDesignPaletteHintInterBase);
  CreateDesignPaletteButtonLocal(DPH,'�������',TiIBTable,0,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'������',TiIBQuery,1,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'�������� ���������',TiIBStoredProc,2,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'���� ������',TiIBDatabase,3,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'����������',TiIBTransaction,4,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'����������� SQL',TiIBUpdateSql,5,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'����� ������',TiIBDataSet,6,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'SQL',TiIBSQL,7,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'���������� � ����',TiIBDataBaseInfo,8,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'������� SQL',TiIBSqlMonitor,9,dm.ILInterbase);
  CreateDesignPaletteButtonLocal(DPH,'�������',TiIBEvents,10,dm.ILInterbase);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameAnyDac,ConstDesignPaletteHintAnyDac);
  CreateDesignPaletteButtonLocal(DPH,'����������',TiADConnection,1,dm.ILAnyDac);
  CreateDesignPaletteButtonLocal(DPH,'������',TiADQuery,2,dm.ILAnyDac);
  CreateDesignPaletteButtonLocal(DPH,'�������',TiADTable,3,dm.ILAnyDac);
  
  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameInterface,ConstDesignPaletteHintInterface);
  CreateDesignPaletteButtonLocal(DPH,'��������� �����������',TiRBookInterface,0,dm.ILStbasis);
  CreateDesignPaletteButtonLocal(DPH,'��������� ������',TiReportInterface,1,dm.ILStbasis);
  CreateDesignPaletteButtonLocal(DPH,'��������� ���������',TiDocumentInterface,2,dm.ILStbasis);
  CreateDesignPaletteButtonLocal(DPH,'��������� �������',TiJournalInterface,3,dm.ILStbasis);
  CreateDesignPaletteButtonLocal(DPH,'��������� �������',TiServiceInterface,4,dm.ILStbasis);
  CreateDesignPaletteButtonLocal(DPH,'��������� ���������',TiWizardInterface,5,dm.ILStbasis);
  CreateDesignPaletteButtonLocal(DPH,'����������� ���������',TiNoneInterface,6,dm.ILStbasis);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameHtml,ConstDesignPaletteHintHtml);
  CreateDesignPaletteButtonLocal(DPH,'�������� Html',TiTsvHtmlPage,0,dm.ilTsvHtml,[ttiHelp]);
  CreateDesignPaletteButtonLocal(DPH,'����� Html',TitsvHtmlFrame,1,dm.ilTsvHtml,[ttiHelp]);
  CreateDesignPaletteButtonLocal(DPH,'����� Html',TiTsvHtmlLabel,2,dm.ilTsvHtml,[ttiHelp]);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameTsv,ConstDesignPaletteHintTsv);
  CreateDesignPaletteButtonLocal(DPH,'���������� ������ ������',TiTsvColorBox,0,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'����������� ������������� ������',TiTsvDBGrid,1,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'����������� ������',TiTsvListBox,2,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'���������',TiTsvStorage,3,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'�������������� �����',TiTsvAngelLabel,4,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'����������� �������',TiTsvGradient,5,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'����������� ���������',TiTsvHintEx,6,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'XML ��������',TitsvXMLDocument,7,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'������',TitsvStringList,8,dm.ILTsv);
  CreateDesignPaletteButtonLocal(DPH,'����� ������ � ������',TitsvMemoryData,18,dm.ILRx);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameFastReport,ConstDesignPaletteHintFastReport);
  CreateDesignPaletteButtonLocal(DPH,'�����',TifrReport,0,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'����������� �����',TifrCompositeReport,1,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'����� ������',TifrDBDataset,2,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'����� ���������������� ������',TifrUserDataset,3,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'������� � �����',TifrTextExport,4,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'������� � RTF',TifrRtfExport,5,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'������� � CSV',TifrCSVExport,6,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'������� � HTML',TifrHTMExport,7,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'��������������� ��������',TifrPreview,8,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'������ �������',TifrPrintTable,9,dm.ILFastReport,[ttiReport]);
  CreateDesignPaletteButtonLocal(DPH,'������ �����',TifrPrintGrid,10,dm.ILFastReport,[ttiReport]);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameRx,ConstDesignPaletteHintRx);
  CreateDesignPaletteButtonLocal(DPH,'���� � �������',TiComboEdit,0,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� ��� �����',TiFilenameEdit,1,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� ����������',TiDirectoryEdit,2,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� ����',TiDateEdit,3,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� �����',TiRxCalcEdit,4,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� �����',TiCurrencyEdit,5,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'����� ������',TiFontComboBox,6,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'����� �����',TiColorComboBox,7,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'�����',TiRxLabel,8,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'����������� ������������� ���� �����',TiRxRichEdit,9,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'����',TiRxClock,10,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'��������',TiAnimatedImage,11,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'�����',TiRxDrawGrid,12,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'������� ������',TiRxSpeedButton,13,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'GIF ��������',TiRxGifAnimator,14,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'�����������',TiRxCalculator,15,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'������ ��������',TiRxTimerList,16,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'������� ��������',TiRxFolderMonitor,17,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'����� ������ � ������',TiRxMemoryData,18,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'����� ������ ������',TiRxDBGrid,19,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'������ ��������� ������ ������',TiRxDBLookupList,20,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���������� ������ ��������� ������ ������',TiRxDBLookupCombo,21,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���� ��������� ������ ������',TiRxLookupEdit,22,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� ���� � ����� ������',TiDBDateEdit,23,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���� ����� ����� � ����� ������',TiRxDBCalcEdit,24,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���������� ���� ����� ������',TiRxDBComboEdit,25,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'����������� ������������� ���� ����� ������',TiRxDBRichEdit,26,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'��������� �����',TiDBStatusLabel,27,dm.ILRx);
  CreateDesignPaletteButtonLocal(DPH,'���������� ������ ����� ������',TiRxDbComboBox,28,dm.ILRx);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameIndy,ConstDesignPaletteHintIndy);
  CreateDesignPaletteButtonLocal(DPH,'������ Http',TiIdHttp,0,dm.ILIndy);

  DPH:=CreateDesignPaletteLocal(ConstDesignPaletteNameAbbrevia,ConstDesignPaletteHintAbbrevia);
  CreateDesignPaletteButtonLocal(DPH,'��������� Zip',TiAbZipper,0,dm.ILAbbrevia);

end;

procedure ClearListDesignCodeTemplateHandles;
var
  i: Integer;
begin
  for i:=0 to ListDesignCodeTemplateHandles.Count-1 do begin
    _FreeDesignCodeTemplate(THandle(ListDesignCodeTemplateHandles.Items[i]));
  end;
  ListDesignCodeTemplateHandles.Clear;
end;

function GetDesignCodeProc(DesignCodeTemplateHandle: THandle): PChar;stdcall;
begin
  Result:=nil;
  if DesignCodeTemplateHandle=hCodeTemplateViewInterface then Result:=ConstDCTViewInterfaceCode;
end;

procedure AddToListDesignCodeTemplateHandles;

   function CreateDesignCodeTemplateLocal(Name, Hint: PChar): THandle;
   var
     TCDCT: TCreateDesignCodeTemplate;
   begin
     FillChar(TCDCT,SizeOf(TCDCT),0);
     TCDCT.Name:=Name;
     TCDCT.Hint:=Hint;
     TCDCT.GetCodeProc:=GetDesignCodeProc;
     Result:=_CreateDesignCodeTemplate(@TCDCT);
     ListDesignCodeTemplateHandles.Add(Pointer(Result));
   end;

begin
  hCodeTemplateViewInterface:=CreateDesignCodeTemplateLocal(ConstDCTViewInterfaceName,ConstDCTViewInterfaceHint);
end;

procedure ClearListDesignFormTemplateHandles;
var
  i: Integer;
begin
  for i:=0 to ListDesignFormTemplateHandles.Count-1 do begin
    _FreeDesignFormTemplate(THandle(ListDesignFormTemplateHandles.Items[i]));
  end;
  ListDesignFormTemplateHandles.Clear;
end;

function GetDesignFormProc(DesignFormTemplateHandle: THandle): PChar;stdcall;
begin
  Result:=nil;
  if DesignFormTemplateHandle=hFormTemplateViewInterface then Result:=ConstDFTViewInterfaceForm;
end;

procedure AddToListDesignFormTemplateHandles;

   function CreateDesignFormTemplateLocal(Name, Hint: PChar): THandle;
   var
     TCDFT: TCreateDesignFormTemplate;
   begin
     FillChar(TCDFT,SizeOf(TCDFT),0);
     TCDFT.Name:=Name;
     TCDFT.Hint:=Hint;
     TCDFT.GetFormProc:=GetDesignFormProc;
     Result:=_CreateDesignFormTemplate(@TCDFT);
     ListDesignFormTemplateHandles.Add(Pointer(Result));
   end;

begin
  hFormTemplateViewInterface:=CreateDesignFormTemplateLocal(ConstDFTViewInterfaceName,ConstDFTViewInterfaceHint);
end;

procedure ClearListInterpreterConstHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterpreterConstHandles.Count-1 do begin
    _FreeInterpreterConst(THandle(ListInterpreterConstHandles.Items[i]));
  end;
  ListInterpreterConstHandles.Clear;
end;

procedure AddToListInterpreterConstHandles;

   function CreateInterpreterConstLocal(Identifer: PChar; Value: Variant;
                                        PInfo: Pointer=nil; 
                                        TypeCreate: TTypeCreate=tcLast;
                                        Hint: PChar=nil): THandle;
   var
     TCIC: TCreateInterpreterConst;
   begin
     FillChar(TCIC,SizeOf(TCreateInterpreterConst),0);
     TCIC.Identifer:=Identifer;
     TCIC.Value:=Value;
     TCIC.Hint:=Hint;
     TCIC.TypeInfo:=PInfo;
     TCIC.TypeCreate:=TypeCreate;
     Result:=_CreateInterpreterConst(@TCIC);
     if Result<>INTERPRETERCONST_INVALID_HANDLE then
      ListInterpreterConstHandles.Add(Pointer(Result));
   end;

begin
  // System
  CreateInterpreterConstLocal('Null',Null);
  CreateInterpreterConstLocal('Unassigned',Unassigned);
  CreateInterpreterConstLocal('varEmpty',varEmpty);
  CreateInterpreterConstLocal('varNull',varNull);
  CreateInterpreterConstLocal('varSmallint',varSmallint);
  CreateInterpreterConstLocal('varInteger',varInteger);
  CreateInterpreterConstLocal('varSingle',varSingle);
  CreateInterpreterConstLocal('varDouble',varDouble);
  CreateInterpreterConstLocal('varCurrency',varCurrency);
  CreateInterpreterConstLocal('varDate',varDate);
  CreateInterpreterConstLocal('varOleStr',varOleStr);
  CreateInterpreterConstLocal('varDispatch',varDispatch);
  CreateInterpreterConstLocal('varError',varError);
  CreateInterpreterConstLocal('varBoolean',varBoolean);
  CreateInterpreterConstLocal('varVariant',varVariant);
  CreateInterpreterConstLocal('varUnknown',varUnknown);
  CreateInterpreterConstLocal('varByte',varByte);
  CreateInterpreterConstLocal('varStrArg',varStrArg);
  CreateInterpreterConstLocal('varString',varString);
  CreateInterpreterConstLocal('varAny',varAny);
  CreateInterpreterConstLocal('varTypeMask',varTypeMask);
  CreateInterpreterConstLocal('varArray',varArray);
  CreateInterpreterConstLocal('varByRef',varByRef);

  // SysUtils

  CreateInterpreterConstLocal('fmOpenRead', Integer(fmOpenRead));
  CreateInterpreterConstLocal('fmOpenWrite', Integer(fmOpenWrite));
  CreateInterpreterConstLocal('fmOpenReadWrite', Integer(fmOpenReadWrite));
  CreateInterpreterConstLocal('fmShareCompat', Integer(fmShareCompat));
  CreateInterpreterConstLocal('fmShareExclusive', Integer(fmShareExclusive));
  CreateInterpreterConstLocal('fmShareDenyWrite', Integer(fmShareDenyWrite));
  CreateInterpreterConstLocal('fmShareDenyRead', Integer(fmShareDenyRead));
  CreateInterpreterConstLocal('fmShareDenyNone', Integer(fmShareDenyNone));
  CreateInterpreterConstLocal('faReadOnly', Integer(faReadOnly));
  CreateInterpreterConstLocal('faHidden', Integer(faHidden));
  CreateInterpreterConstLocal('faSysFile', Integer(faSysFile));
  CreateInterpreterConstLocal('faVolumeID', Integer(faVolumeID));
  CreateInterpreterConstLocal('faDirectory', Integer(faDirectory));
  CreateInterpreterConstLocal('faArchive', Integer(faArchive));
  CreateInterpreterConstLocal('faAnyFile', Integer(faAnyFile));
  CreateInterpreterConstLocal('DecimalSeparator', DecimalSeparator);

  // Classes

  CreateInterpreterConstLocal('taLeftJustify', Integer(taLeftJustify),TypeInfo(TAlignment));
  CreateInterpreterConstLocal('taRightJustify', Integer(taRightJustify),TypeInfo(TAlignment));
  CreateInterpreterConstLocal('taCenter', Integer(taCenter),TypeInfo(TAlignment));
  CreateInterpreterConstLocal('ssShift', Integer(ssShift),TypeInfo(TShiftState));
  CreateInterpreterConstLocal('ssAlt', Integer(ssAlt),TypeInfo(TShiftState));
  CreateInterpreterConstLocal('ssCtrl', Integer(ssCtrl),TypeInfo(TShiftState));
  CreateInterpreterConstLocal('ssLeft', Integer(ssLeft),TypeInfo(TShiftState));
  CreateInterpreterConstLocal('ssRight', Integer(ssRight),TypeInfo(TShiftState));
  CreateInterpreterConstLocal('ssMiddle', Integer(ssMiddle),TypeInfo(TShiftState));
  CreateInterpreterConstLocal('ssDouble', Integer(ssDouble),TypeInfo(TShiftState));
  CreateInterpreterConstLocal('dupIgnore', Integer(dupIgnore),TypeInfo(TDuplicates));
  CreateInterpreterConstLocal('dupAccept', Integer(dupAccept),TypeInfo(TDuplicates));
  CreateInterpreterConstLocal('dupError', Integer(dupError),TypeInfo(TDuplicates));
  CreateInterpreterConstLocal('csLoading', Integer(csLoading),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csReading', Integer(csReading),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csWriting', Integer(csWriting),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csDestroying', Integer(csDestroying),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csDesigning', Integer(csDesigning),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csAncestor', Integer(csAncestor),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csUpdating', Integer(csUpdating),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csFixups', Integer(csFixups),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csInheritable', Integer(csInheritable),TypeInfo(TComponentState));
  CreateInterpreterConstLocal('csCheckPropAvail', Integer(csCheckPropAvail),TypeInfo(TComponentState));

  // Windows
  
  CreateInterpreterConstLocal('MB_OK', $00000000);
  CreateInterpreterConstLocal('MB_OKCANCEL', $00000001);
  CreateInterpreterConstLocal('MB_ABORTRETRYIGNORE', $00000002);
  CreateInterpreterConstLocal('MB_YESNOCANCEL', $00000003);
  CreateInterpreterConstLocal('MB_YESNO', $00000004);
  CreateInterpreterConstLocal('MB_RETRYCANCEL', $00000005);
  CreateInterpreterConstLocal('MB_ICONHAND', $00000010);
  CreateInterpreterConstLocal('MB_ICONQUESTION', $00000020);
  CreateInterpreterConstLocal('MB_ICONEXCLAMATION', $00000030);
  CreateInterpreterConstLocal('MB_ICONASTERISK', $00000040);
  CreateInterpreterConstLocal('MB_USERICON', $00000080);
  CreateInterpreterConstLocal('MB_ICONWARNING',  MB_ICONEXCLAMATION);
  CreateInterpreterConstLocal('MB_ICONERROR', MB_ICONHAND);
  CreateInterpreterConstLocal('MB_ICONINFORMATION', MB_ICONASTERISK);
  CreateInterpreterConstLocal('MB_ICONSTOP', MB_ICONHAND);
  CreateInterpreterConstLocal('MB_DEFBUTTON1', $00000000);
  CreateInterpreterConstLocal('MB_DEFBUTTON2', $00000100);
  CreateInterpreterConstLocal('MB_DEFBUTTON3', $00000200);
  CreateInterpreterConstLocal('MB_DEFBUTTON4', $00000300);
  CreateInterpreterConstLocal('MB_APPLMODAL', $00000000);
  CreateInterpreterConstLocal('MB_SYSTEMMODAL', $00001000);
  CreateInterpreterConstLocal('MB_TASKMODAL', $00002000);
  CreateInterpreterConstLocal('MB_HELP', $00004000);
  CreateInterpreterConstLocal('MB_NOFOCUS', $00008000);
  CreateInterpreterConstLocal('MB_SETFOREGROUND', $00010000);
  CreateInterpreterConstLocal('MB_DEFAULT_DESKTOP_ONLY', $00020000);
  CreateInterpreterConstLocal('MB_TOPMOST', $00040000);
  CreateInterpreterConstLocal('MB_RIGHT', $00080000);
  CreateInterpreterConstLocal('MB_RTLREADING', $00100000);
  CreateInterpreterConstLocal('MB_SERVICE_NOTIFICATION', $00200000);
  CreateInterpreterConstLocal('MB_SERVICE_NOTIFICATION_NT3X', $00040000);
  CreateInterpreterConstLocal('MB_TYPEMASK', $0000000F);
  CreateInterpreterConstLocal('MB_ICONMASK', $000000F0);
  CreateInterpreterConstLocal('MB_DEFMASK', $00000F00);
  CreateInterpreterConstLocal('MB_MODEMASK', $00003000);
  CreateInterpreterConstLocal('MB_MISCMASK', $0000C000);
  CreateInterpreterConstLocal('VK_LBUTTON', VK_LBUTTON);
  CreateInterpreterConstLocal('VK_RBUTTON', VK_RBUTTON);
  CreateInterpreterConstLocal('VK_CANCEL', VK_CANCEL);
  CreateInterpreterConstLocal('VK_MBUTTON', VK_MBUTTON);
  CreateInterpreterConstLocal('VK_BACK', VK_BACK);
  CreateInterpreterConstLocal('VK_TAB', VK_TAB);
  CreateInterpreterConstLocal('VK_CLEAR', VK_CLEAR);
  CreateInterpreterConstLocal('VK_RETURN', VK_RETURN);
  CreateInterpreterConstLocal('VK_SHIFT', VK_SHIFT);
  CreateInterpreterConstLocal('VK_CONTROL', VK_CONTROL);
  CreateInterpreterConstLocal('VK_MENU', VK_MENU);
  CreateInterpreterConstLocal('VK_PAUSE', VK_PAUSE);
  CreateInterpreterConstLocal('VK_CAPITAL', VK_CAPITAL);
  CreateInterpreterConstLocal('VK_KANA', VK_KANA);
  CreateInterpreterConstLocal('VK_HANGUL', VK_HANGUL);
  CreateInterpreterConstLocal('VK_JUNJA', VK_JUNJA);
  CreateInterpreterConstLocal('VK_FINAL', VK_FINAL);
  CreateInterpreterConstLocal('VK_HANJA', VK_HANJA);
  CreateInterpreterConstLocal('VK_KANJI', VK_KANJI);
  CreateInterpreterConstLocal('VK_CONVERT', VK_CONVERT);
  CreateInterpreterConstLocal('VK_NONCONVERT', VK_NONCONVERT);
  CreateInterpreterConstLocal('VK_ACCEPT', VK_ACCEPT);
  CreateInterpreterConstLocal('VK_MODECHANGE', VK_MODECHANGE);
  CreateInterpreterConstLocal('VK_ESCAPE', VK_ESCAPE);
  CreateInterpreterConstLocal('VK_SPACE', VK_SPACE);
  CreateInterpreterConstLocal('VK_PRIOR', VK_PRIOR);
  CreateInterpreterConstLocal('VK_NEXT', VK_NEXT);
  CreateInterpreterConstLocal('VK_END', VK_END);
  CreateInterpreterConstLocal('VK_HOME', VK_HOME);
  CreateInterpreterConstLocal('VK_LEFT', VK_LEFT);
  CreateInterpreterConstLocal('VK_UP', VK_UP);
  CreateInterpreterConstLocal('VK_RIGHT', VK_RIGHT);
  CreateInterpreterConstLocal('VK_DOWN', VK_DOWN);
  CreateInterpreterConstLocal('VK_SELECT', VK_SELECT);
  CreateInterpreterConstLocal('VK_PRINT', VK_PRINT);
  CreateInterpreterConstLocal('VK_EXECUTE', VK_EXECUTE);
  CreateInterpreterConstLocal('VK_SNAPSHOT', VK_SNAPSHOT);
  CreateInterpreterConstLocal('VK_INSERT', VK_INSERT);
  CreateInterpreterConstLocal('VK_DELETE', VK_DELETE);
  CreateInterpreterConstLocal('VK_HELP', VK_HELP);
  CreateInterpreterConstLocal('VK_LWIN', VK_LWIN);
  CreateInterpreterConstLocal('VK_RWIN', VK_RWIN);
  CreateInterpreterConstLocal('VK_APPS', VK_APPS);
  CreateInterpreterConstLocal('VK_NUMPAD0', VK_NUMPAD0);
  CreateInterpreterConstLocal('VK_NUMPAD1', VK_NUMPAD1);
  CreateInterpreterConstLocal('VK_NUMPAD2', VK_NUMPAD2);
  CreateInterpreterConstLocal('VK_NUMPAD3', VK_NUMPAD3);
  CreateInterpreterConstLocal('VK_NUMPAD4', VK_NUMPAD4);
  CreateInterpreterConstLocal('VK_NUMPAD5', VK_NUMPAD5);
  CreateInterpreterConstLocal('VK_NUMPAD6', VK_NUMPAD6);
  CreateInterpreterConstLocal('VK_NUMPAD7', VK_NUMPAD7);
  CreateInterpreterConstLocal('VK_NUMPAD8', VK_NUMPAD8);
  CreateInterpreterConstLocal('VK_NUMPAD9', VK_NUMPAD9);
  CreateInterpreterConstLocal('VK_MULTIPLY', VK_MULTIPLY);
  CreateInterpreterConstLocal('VK_ADD', VK_ADD);
  CreateInterpreterConstLocal('VK_SEPARATOR', VK_SEPARATOR);
  CreateInterpreterConstLocal('VK_SUBTRACT', VK_SUBTRACT);
  CreateInterpreterConstLocal('VK_DECIMAL', VK_DECIMAL);
  CreateInterpreterConstLocal('VK_DIVIDE', VK_DIVIDE);
  CreateInterpreterConstLocal('VK_F1', VK_F1);
  CreateInterpreterConstLocal('VK_F2', VK_F2);
  CreateInterpreterConstLocal('VK_F3', VK_F3);
  CreateInterpreterConstLocal('VK_F4', VK_F4);
  CreateInterpreterConstLocal('VK_F5', VK_F5);
  CreateInterpreterConstLocal('VK_F6', VK_F6);
  CreateInterpreterConstLocal('VK_F7', VK_F7);
  CreateInterpreterConstLocal('VK_F8', VK_F8);
  CreateInterpreterConstLocal('VK_F9', VK_F9);
  CreateInterpreterConstLocal('VK_F10', VK_F10);
  CreateInterpreterConstLocal('VK_F11', VK_F11);
  CreateInterpreterConstLocal('VK_F12', VK_F12);
  CreateInterpreterConstLocal('VK_F13', VK_F13);
  CreateInterpreterConstLocal('VK_F14', VK_F14);
  CreateInterpreterConstLocal('VK_F15', VK_F15);
  CreateInterpreterConstLocal('VK_F16', VK_F16);
  CreateInterpreterConstLocal('VK_F17', VK_F17);
  CreateInterpreterConstLocal('VK_F18', VK_F18);
  CreateInterpreterConstLocal('VK_F19', VK_F19);
  CreateInterpreterConstLocal('VK_F20', VK_F20);
  CreateInterpreterConstLocal('VK_F21', VK_F21);
  CreateInterpreterConstLocal('VK_F22', VK_F22);
  CreateInterpreterConstLocal('VK_F23', VK_F23);
  CreateInterpreterConstLocal('VK_F24', VK_F24);
  CreateInterpreterConstLocal('VK_NUMLOCK', VK_NUMLOCK);
  CreateInterpreterConstLocal('VK_SCROLL', VK_SCROLL);
  CreateInterpreterConstLocal('VK_LSHIFT', VK_LSHIFT);
  CreateInterpreterConstLocal('VK_RSHIFT', VK_RSHIFT);
  CreateInterpreterConstLocal('VK_LCONTROL', VK_LCONTROL);
  CreateInterpreterConstLocal('VK_RCONTROL', VK_RCONTROL);
  CreateInterpreterConstLocal('VK_LMENU', VK_LMENU);
  CreateInterpreterConstLocal('VK_RMENU', VK_RMENU);
  CreateInterpreterConstLocal('VK_PROCESSKEY', VK_PROCESSKEY);
  CreateInterpreterConstLocal('VK_ATTN', VK_ATTN);
  CreateInterpreterConstLocal('VK_CRSEL', VK_CRSEL);
  CreateInterpreterConstLocal('VK_EXSEL', VK_EXSEL);
  CreateInterpreterConstLocal('VK_EREOF', VK_EREOF);
  CreateInterpreterConstLocal('VK_PLAY', VK_PLAY);
  CreateInterpreterConstLocal('VK_ZOOM', VK_ZOOM);
  CreateInterpreterConstLocal('VK_NONAME', VK_NONAME);
  CreateInterpreterConstLocal('VK_PA1', VK_PA1);
  CreateInterpreterConstLocal('VK_OEM_CLEAR', VK_OEM_CLEAR);

  // Graphics
  CreateInterpreterConstLocal('clScrollBar', Integer(clScrollBar),TypeInfo(TColor));
  CreateInterpreterConstLocal('clBackground', Integer(clBackground),TypeInfo(TColor));
  CreateInterpreterConstLocal('clActiveCaption', Integer(clActiveCaption),TypeInfo(TColor));
  CreateInterpreterConstLocal('clInactiveCaption', Integer(clInactiveCaption),TypeInfo(TColor));
  CreateInterpreterConstLocal('clMenu', Integer(clMenu),TypeInfo(TColor));
  CreateInterpreterConstLocal('clWindow', Integer(clWindow),TypeInfo(TColor));
  CreateInterpreterConstLocal('clWindowFrame', Integer(clWindowFrame),TypeInfo(TColor));
  CreateInterpreterConstLocal('clMenuText', Integer(clMenuText),TypeInfo(TColor));
  CreateInterpreterConstLocal('clWindowText', Integer(clWindowText),TypeInfo(TColor));
  CreateInterpreterConstLocal('clCaptionText', Integer(clCaptionText),TypeInfo(TColor));
  CreateInterpreterConstLocal('clActiveBorder', Integer(clActiveBorder),TypeInfo(TColor));
  CreateInterpreterConstLocal('clInactiveBorder', Integer(clInactiveBorder),TypeInfo(TColor));
  CreateInterpreterConstLocal('clAppWorkSpace', Integer(clAppWorkSpace),TypeInfo(TColor));
  CreateInterpreterConstLocal('clHighlight', Integer(clHighlight),TypeInfo(TColor));
  CreateInterpreterConstLocal('clHighlightText', Integer(clHighlightText),TypeInfo(TColor));
  CreateInterpreterConstLocal('clBtnFace', Integer(clBtnFace),TypeInfo(TColor));
  CreateInterpreterConstLocal('clBtnShadow', Integer(clBtnShadow),TypeInfo(TColor));
  CreateInterpreterConstLocal('clGrayText', Integer(clGrayText),TypeInfo(TColor));
  CreateInterpreterConstLocal('clBtnText', Integer(clBtnText),TypeInfo(TColor));
  CreateInterpreterConstLocal('clInactiveCaptionText', Integer(clInactiveCaptionText),TypeInfo(TColor));
  CreateInterpreterConstLocal('clBtnHighlight', Integer(clBtnHighlight),TypeInfo(TColor));
  CreateInterpreterConstLocal('cl3DDkShadow', Integer(cl3DDkShadow),TypeInfo(TColor));
  CreateInterpreterConstLocal('cl3DLight', Integer(cl3DLight),TypeInfo(TColor));
  CreateInterpreterConstLocal('clInfoText', Integer(clInfoText),TypeInfo(TColor));
  CreateInterpreterConstLocal('clInfoBk', Integer(clInfoBk),TypeInfo(TColor));
  CreateInterpreterConstLocal('clBlack', Integer(clBlack),TypeInfo(TColor));
  CreateInterpreterConstLocal('clMaroon', Integer(clMaroon),TypeInfo(TColor));
  CreateInterpreterConstLocal('clGreen', Integer(clGreen),TypeInfo(TColor));
  CreateInterpreterConstLocal('clOlive', Integer(clOlive),TypeInfo(TColor));
  CreateInterpreterConstLocal('clNavy', Integer(clNavy),TypeInfo(TColor));
  CreateInterpreterConstLocal('clPurple', Integer(clPurple),TypeInfo(TColor));
  CreateInterpreterConstLocal('clTeal', Integer(clTeal),TypeInfo(TColor));
  CreateInterpreterConstLocal('clGray', Integer(clGray),TypeInfo(TColor));
  CreateInterpreterConstLocal('clSilver', Integer(clSilver),TypeInfo(TColor));
  CreateInterpreterConstLocal('clRed', Integer(clRed),TypeInfo(TColor));
  CreateInterpreterConstLocal('clLime', Integer(clLime),TypeInfo(TColor));
  CreateInterpreterConstLocal('clYellow', Integer(clYellow),TypeInfo(TColor));
  CreateInterpreterConstLocal('clBlue', Integer(clBlue),TypeInfo(TColor));
  CreateInterpreterConstLocal('clFuchsia', Integer(clFuchsia),TypeInfo(TColor));
  CreateInterpreterConstLocal('clAqua', Integer(clAqua),TypeInfo(TColor));
  CreateInterpreterConstLocal('clLtGray', Integer(clLtGray),TypeInfo(TColor));
  CreateInterpreterConstLocal('clDkGray', Integer(clDkGray),TypeInfo(TColor));
  CreateInterpreterConstLocal('clWhite', Integer(clWhite),TypeInfo(TColor));
  CreateInterpreterConstLocal('clNone', Integer(clNone),TypeInfo(TColor));
  CreateInterpreterConstLocal('clDefault', Integer(clDefault),TypeInfo(TColor));
  CreateInterpreterConstLocal('fsBold', Integer(fsBold),TypeInfo(TFontStyle));
  CreateInterpreterConstLocal('fsItalic', Integer(fsItalic),TypeInfo(TFontStyle));
  CreateInterpreterConstLocal('fsUnderline', Integer(fsUnderline),TypeInfo(TFontStyle));
  CreateInterpreterConstLocal('fsStrikeOut', Integer(fsStrikeOut),TypeInfo(TFontStyle));
  CreateInterpreterConstLocal('fpDefault', Integer(fpDefault),TypeInfo(TFontPitch));
  CreateInterpreterConstLocal('fpVariable', Integer(fpVariable),TypeInfo(TFontPitch));
  CreateInterpreterConstLocal('fpFixed', Integer(fpFixed),TypeInfo(TFontPitch));
  CreateInterpreterConstLocal('psSolid', Integer(psSolid),TypeInfo(TPenStyle));
  CreateInterpreterConstLocal('psDash', Integer(psDash),TypeInfo(TPenStyle));
  CreateInterpreterConstLocal('psDot', Integer(psDot),TypeInfo(TPenStyle));
  CreateInterpreterConstLocal('psDashDot', Integer(psDashDot),TypeInfo(TPenStyle));
  CreateInterpreterConstLocal('psDashDotDot', Integer(psDashDotDot),TypeInfo(TPenStyle));
  CreateInterpreterConstLocal('psClear', Integer(psClear),TypeInfo(TPenStyle));
  CreateInterpreterConstLocal('psInsideFrame', Integer(psInsideFrame),TypeInfo(TPenStyle));
  CreateInterpreterConstLocal('pmBlack', Integer(pmBlack),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmWhite', Integer(pmWhite),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmNop', Integer(pmNop),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmNot', Integer(pmNot),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmCopy', Integer(pmCopy),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmNotCopy', Integer(pmNotCopy),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmMergePenNot', Integer(pmMergePenNot),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmMaskPenNot', Integer(pmMaskPenNot),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmMergeNotPen', Integer(pmMergeNotPen),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmMaskNotPen', Integer(pmMaskNotPen),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmMerge', Integer(pmMerge),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmNotMerge', Integer(pmNotMerge),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmMask', Integer(pmMask),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmNotMask', Integer(pmNotMask),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmXor', Integer(pmXor),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('pmNotXor', Integer(pmNotXor),TypeInfo(TPenMode));
  CreateInterpreterConstLocal('bsSolid', Integer(bsSolid),TypeInfo(TBrushStyle));
  CreateInterpreterConstLocal('bsClear', Integer(bsClear),TypeInfo(TBrushStyle));
  CreateInterpreterConstLocal('bsHorizontal', Integer(bsHorizontal),TypeInfo(TBrushStyle));
  CreateInterpreterConstLocal('bsVertical', Integer(bsVertical),TypeInfo(TBrushStyle));
  CreateInterpreterConstLocal('bsFDiagonal', Integer(bsFDiagonal),TypeInfo(TBrushStyle));
  CreateInterpreterConstLocal('bsBDiagonal', Integer(bsBDiagonal),TypeInfo(TBrushStyle));
  CreateInterpreterConstLocal('bsCross', Integer(bsCross),TypeInfo(TBrushStyle));
  CreateInterpreterConstLocal('bsDiagCross', Integer(bsDiagCross),TypeInfo(TBrushStyle));
  CreateInterpreterConstLocal('fsSurface', Integer(fsSurface),TypeInfo(TFillStyle));
  CreateInterpreterConstLocal('fsBorder', Integer(fsBorder),TypeInfo(TFillStyle));
  CreateInterpreterConstLocal('fmAlternate', Integer(fmAlternate),TypeInfo(TFillMode));
  CreateInterpreterConstLocal('fmWinding', Integer(fmWinding),TypeInfo(TFillMode));
  CreateInterpreterConstLocal('csHandleValid', Integer(csHandleValid),TypeInfo(TCanvasStates));
  CreateInterpreterConstLocal('csFontValid', Integer(csFontValid),TypeInfo(TCanvasStates));
  CreateInterpreterConstLocal('csPenValid', Integer(csPenValid),TypeInfo(TCanvasStates));
  CreateInterpreterConstLocal('csBrushValid', Integer(csBrushValid),TypeInfo(TCanvasStates));
  CreateInterpreterConstLocal('psStarting', Integer(psStarting),TypeInfo(TProgressStage));
  CreateInterpreterConstLocal('psRunning', Integer(psRunning),TypeInfo(TProgressStage));
  CreateInterpreterConstLocal('psEnding', Integer(psEnding),TypeInfo(TProgressStage));
  CreateInterpreterConstLocal('bmDIB', Integer(bmDIB),TypeInfo(TBitmapHandleType));
  CreateInterpreterConstLocal('bmDDB', Integer(bmDDB),TypeInfo(TBitmapHandleType));
  CreateInterpreterConstLocal('pfDevice', Integer(pfDevice),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('pf1bit', Integer(pf1bit),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('pf4bit', Integer(pf4bit),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('pf8bit', Integer(pf8bit),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('pf15bit', Integer(pf15bit),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('pf16bit', Integer(pf16bit),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('pf24bit', Integer(pf24bit),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('pf32bit', Integer(pf32bit),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('pfCustom', Integer(pfCustom),TypeInfo(TPixelFormat));
  CreateInterpreterConstLocal('tmAuto', Integer(tmAuto),TypeInfo(TTransparentMode));
  CreateInterpreterConstLocal('tmFixed', Integer(tmFixed),TypeInfo(TTransparentMode));

  // Controls

  CreateInterpreterConstLocal('dmDragEnter', Integer(dmDragEnter),TypeInfo(TDragMessage));
  CreateInterpreterConstLocal('dmDragLeave', Integer(dmDragLeave),TypeInfo(TDragMessage));
  CreateInterpreterConstLocal('dmDragMove', Integer(dmDragMove),TypeInfo(TDragMessage));
  CreateInterpreterConstLocal('dmDragDrop', Integer(dmDragDrop),TypeInfo(TDragMessage));
  CreateInterpreterConstLocal('dmDragCancel', Integer(dmDragCancel),TypeInfo(TDragMessage));
  CreateInterpreterConstLocal('dmFindTarget', Integer(dmFindTarget),TypeInfo(TDragMessage));
  CreateInterpreterConstLocal('alNone', Integer(alNone),TypeInfo(TAlign));
  CreateInterpreterConstLocal('alTop', Integer(alTop),TypeInfo(TAlign));
  CreateInterpreterConstLocal('alBottom', Integer(alBottom),TypeInfo(TAlign));
  CreateInterpreterConstLocal('alLeft', Integer(alLeft),TypeInfo(TAlign));
  CreateInterpreterConstLocal('alRight', Integer(alRight),TypeInfo(TAlign));
  CreateInterpreterConstLocal('alClient', Integer(alClient),TypeInfo(TAlign));
  CreateInterpreterConstLocal('csLButtonDown', Integer(csLButtonDown),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csClicked', Integer(csClicked),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csPalette', Integer(csPalette),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csReadingState', Integer(csReadingState),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csAlignmentNeeded', Integer(csAlignmentNeeded),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csFocusing', Integer(csFocusing),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csCreating', Integer(csCreating),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csPaintCopy', Integer(csPaintCopy),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csAcceptsControls', Integer(csAcceptsControls),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csCaptureMouse', Integer(csCaptureMouse),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csDesignInteractive', Integer(csDesignInteractive),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csClickEvents', Integer(csClickEvents),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csFramed', Integer(csFramed),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csSetCaption', Integer(csSetCaption),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csOpaque', Integer(csOpaque),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csDoubleClicks', Integer(csDoubleClicks),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csFixedWidth', Integer(csFixedWidth),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csFixedHeight', Integer(csFixedHeight),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csNoDesignVisible', Integer(csNoDesignVisible),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csReplicatable', Integer(csReplicatable),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csNoStdEvents', Integer(csNoStdEvents),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csDisplayDragImage', Integer(csDisplayDragImage),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csReflector', Integer(csReflector),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csActionClient', Integer(csActionClient),TypeInfo(TControlState));
  CreateInterpreterConstLocal('csMenuEvents', Integer(csMenuEvents),TypeInfo(TControlState));
  CreateInterpreterConstLocal('mbLeft', Integer(mbLeft),TypeInfo(TMouseButton));
  CreateInterpreterConstLocal('mbRight', Integer(mbRight),TypeInfo(TMouseButton));
  CreateInterpreterConstLocal('mbMiddle', Integer(mbMiddle),TypeInfo(TMouseButton));
  CreateInterpreterConstLocal('dmManual', Integer(dmManual),TypeInfo(TDragMode));
  CreateInterpreterConstLocal('dmAutomatic', Integer(dmAutomatic),TypeInfo(TDragMode));
  CreateInterpreterConstLocal('dsDragEnter', Integer(dsDragEnter),TypeInfo(TDragState));
  CreateInterpreterConstLocal('dsDragLeave', Integer(dsDragLeave),TypeInfo(TDragState));
  CreateInterpreterConstLocal('dsDragMove', Integer(dsDragMove),TypeInfo(TDragState));
  CreateInterpreterConstLocal('sfLeft', Integer(sfLeft),TypeInfo(TScalingFlags));
  CreateInterpreterConstLocal('sfTop', Integer(sfTop),TypeInfo(TScalingFlags));
  CreateInterpreterConstLocal('sfWidth', Integer(sfWidth),TypeInfo(TScalingFlags));
  CreateInterpreterConstLocal('sfHeight', Integer(sfHeight),TypeInfo(TScalingFlags));
  CreateInterpreterConstLocal('sfFont', Integer(sfFont),TypeInfo(TScalingFlags));
  CreateInterpreterConstLocal('imDisable', Integer(imDisable),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imClose', Integer(imClose),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imOpen', Integer(imOpen),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imDontCare', Integer(imDontCare),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imSAlpha', Integer(imSAlpha),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imAlpha', Integer(imAlpha),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imHira', Integer(imHira),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imSKata', Integer(imSKata),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imKata', Integer(imKata),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imChinese', Integer(imChinese),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imSHanguel', Integer(imSHanguel),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('imHanguel', Integer(imHanguel),TypeInfo(TImeMode));
  CreateInterpreterConstLocal('dsFocus', Integer(dsFocus),TypeInfo(TDrawingStyle));
  CreateInterpreterConstLocal('dsSelected', Integer(dsSelected),TypeInfo(TDrawingStyle));
  CreateInterpreterConstLocal('dsNormal', Integer(dsNormal),TypeInfo(TDrawingStyle));
  CreateInterpreterConstLocal('dsTransparent', Integer(dsTransparent),TypeInfo(TDrawingStyle));
  CreateInterpreterConstLocal('itImage', Integer(itImage),TypeInfo(TImageType));
  CreateInterpreterConstLocal('itMask', Integer(itMask),TypeInfo(TImageType));
  CreateInterpreterConstLocal('rtBitmap', Integer(rtBitmap),TypeInfo(TResType));
  CreateInterpreterConstLocal('rtCursor', Integer(rtCursor),TypeInfo(TResType));
  CreateInterpreterConstLocal('rtIcon', Integer(rtIcon),TypeInfo(TResType));
  CreateInterpreterConstLocal('lrDefaultColor', Integer(lrDefaultColor),TypeInfo(TLoadResource));
  CreateInterpreterConstLocal('lrDefaultSize', Integer(lrDefaultSize),TypeInfo(TLoadResource));
  CreateInterpreterConstLocal('lrFromFile', Integer(lrFromFile),TypeInfo(TLoadResource));
  CreateInterpreterConstLocal('lrMap3DColors', Integer(lrMap3DColors),TypeInfo(TLoadResource));
  CreateInterpreterConstLocal('lrTransparent', Integer(lrTransparent),TypeInfo(TLoadResource));
  CreateInterpreterConstLocal('lrMonoChrome', Integer(lrMonoChrome),TypeInfo(TLoadResource));
  CreateInterpreterConstLocal('crDefault', Integer(crDefault),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crNone', Integer(crNone),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crArrow', Integer(crArrow),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crCross', Integer(crCross),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crIBeam', Integer(crIBeam),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crSize', Integer(crSize),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crSizeNESW', Integer(crSizeNESW),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crSizeNS', Integer(crSizeNS),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crSizeNWSE', Integer(crSizeNWSE),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crSizeWE', Integer(crSizeWE),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crUpArrow', Integer(crUpArrow),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crHourGlass', Integer(crHourGlass),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crDrag', Integer(crDrag),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crNoDrop', Integer(crNoDrop),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crHSplit', Integer(crHSplit),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crVSplit', Integer(crVSplit),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crMultiDrag', Integer(crMultiDrag),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crSQLWait', Integer(crSQLWait),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crNo', Integer(crNo),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crAppStart', Integer(crAppStart),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crHelp', Integer(crHelp),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crHandPoint', Integer(crHandPoint),TypeInfo(TCursor));
  CreateInterpreterConstLocal('crSizeAll', Integer(crSizeAll),TypeInfo(TCursor));

  // StdCtrls

  CreateInterpreterConstLocal('tlTop', tlTop,TypeInfo(TTextLayout));
  CreateInterpreterConstLocal('tlCenter', tlCenter,TypeInfo(TTextLayout));
  CreateInterpreterConstLocal('tlBottom', tlBottom,TypeInfo(TTextLayout));
  CreateInterpreterConstLocal('ecNormal', ecNormal,TypeInfo(TEditCharCase));
  CreateInterpreterConstLocal('ecUpperCase', ecUpperCase,TypeInfo(TEditCharCase));
  CreateInterpreterConstLocal('ecLowerCase', ecLowerCase,TypeInfo(TEditCharCase));
  CreateInterpreterConstLocal('ssNone', ssNone,TypeInfo(TScrollStyle));
  CreateInterpreterConstLocal('ssHorizontal', ssHorizontal,TypeInfo(TScrollStyle));
  CreateInterpreterConstLocal('ssVertical', ssVertical,TypeInfo(TScrollStyle));
  CreateInterpreterConstLocal('ssBoth', ssBoth,TypeInfo(TScrollStyle));
  CreateInterpreterConstLocal('csDropDown', csDropDown,TypeInfo(TComboBoxStyle));
  CreateInterpreterConstLocal('csSimple', csSimple,TypeInfo(TComboBoxStyle));
  CreateInterpreterConstLocal('csDropDownList', csDropDownList,TypeInfo(TComboBoxStyle));
  CreateInterpreterConstLocal('csOwnerDrawFixed', csOwnerDrawFixed,TypeInfo(TComboBoxStyle));
  CreateInterpreterConstLocal('csOwnerDrawVariable', csOwnerDrawVariable,TypeInfo(TComboBoxStyle));
  CreateInterpreterConstLocal('odSelected', odSelected,TypeInfo(TOwnerDrawState));
  CreateInterpreterConstLocal('odGrayed', odGrayed,TypeInfo(TOwnerDrawState));
  CreateInterpreterConstLocal('odDisabled', odDisabled,TypeInfo(TOwnerDrawState));
  CreateInterpreterConstLocal('odChecked', odChecked,TypeInfo(TOwnerDrawState));
  CreateInterpreterConstLocal('odFocused', odFocused,TypeInfo(TOwnerDrawState));
  CreateInterpreterConstLocal('cbUnchecked', cbUnchecked,TypeInfo(TCheckBoxState));
  CreateInterpreterConstLocal('cbChecked', cbChecked,TypeInfo(TCheckBoxState));
  CreateInterpreterConstLocal('cbGrayed', cbGrayed,TypeInfo(TCheckBoxState));
  CreateInterpreterConstLocal('lbStandard', lbStandard,TypeInfo(TListBoxStyle));
  CreateInterpreterConstLocal('lbOwnerDrawFixed', lbOwnerDrawFixed,TypeInfo(TListBoxStyle));
  CreateInterpreterConstLocal('lbOwnerDrawVariable', lbOwnerDrawVariable,TypeInfo(TListBoxStyle));
  CreateInterpreterConstLocal('scLineUp', scLineUp,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('scLineDown', scLineDown,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('scPageUp', scPageUp,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('scPageDown', scPageDown,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('scPosition', scPosition,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('scTrack', scTrack,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('scTop', scTop,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('scBottom', scBottom,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('scEndScroll', scEndScroll,TypeInfo(TScrollCode));
  CreateInterpreterConstLocal('sbsNone', sbsNone,TypeInfo(TStaticBorderStyle));
  CreateInterpreterConstLocal('sbsSingle', sbsSingle,TypeInfo(TStaticBorderStyle));
  CreateInterpreterConstLocal('sbsSunken', sbsSunken,TypeInfo(TStaticBorderStyle));

  // ComCtrls

  CreateInterpreterConstLocal('tpTop', tpTop,TypeInfo(TTabPosition));
  CreateInterpreterConstLocal('tpBottom', tpBottom,TypeInfo(TTabPosition));
  CreateInterpreterConstLocal('psText', psText,TypeInfo(TStatusPanelStyle));
  CreateInterpreterConstLocal('psOwnerDraw', psOwnerDraw,TypeInfo(TStatusPanelStyle));
  CreateInterpreterConstLocal('pbNone', pbNone,TypeInfo(TStatusPanelBevel));
  CreateInterpreterConstLocal('pbLowered', pbLowered,TypeInfo(TStatusPanelBevel));
  CreateInterpreterConstLocal('pbRaised', pbRaised,TypeInfo(TStatusPanelBevel));
  CreateInterpreterConstLocal('hsText', hsText,TypeInfo(THeaderSectionStyle));
  CreateInterpreterConstLocal('hsOwnerDraw', hsOwnerDraw,TypeInfo(THeaderSectionStyle));
  CreateInterpreterConstLocal('tsTrackBegin', tsTrackBegin,TypeInfo(TSectionTrackState));
  CreateInterpreterConstLocal('tsTrackMove', tsTrackMove,TypeInfo(TSectionTrackState));
  CreateInterpreterConstLocal('tsTrackEnd', tsTrackEnd,TypeInfo(TSectionTrackState));
  CreateInterpreterConstLocal('nsCut', nsCut,TypeInfo(TNodeState));
  CreateInterpreterConstLocal('nsDropHilited', nsDropHilited,TypeInfo(TNodeState));
  CreateInterpreterConstLocal('nsFocused', nsFocused,TypeInfo(TNodeState));
  CreateInterpreterConstLocal('nsSelected', nsSelected,TypeInfo(TNodeState));
  CreateInterpreterConstLocal('nsExpanded', nsExpanded,TypeInfo(TNodeState));
  CreateInterpreterConstLocal('naAdd', naAdd,TypeInfo(TNodeAttachMode));
  CreateInterpreterConstLocal('naAddFirst', naAddFirst,TypeInfo(TNodeAttachMode));
  CreateInterpreterConstLocal('naAddChild', naAddChild,TypeInfo(TNodeAttachMode));
  CreateInterpreterConstLocal('naAddChildFirst', naAddChildFirst,TypeInfo(TNodeAttachMode));
  CreateInterpreterConstLocal('naInsert', naInsert,TypeInfo(TNodeAttachMode));
  CreateInterpreterConstLocal('taAddFirst', taAddFirst,TypeInfo(TAddMode));
  CreateInterpreterConstLocal('taAdd', taAdd,TypeInfo(TAddMode));
  CreateInterpreterConstLocal('taInsert', taInsert,TypeInfo(TAddMode));
  CreateInterpreterConstLocal('htAbove', htAbove,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htBelow', htBelow,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htNowhere', htNowhere,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htOnItem', htOnItem,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htOnButton', htOnButton,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htOnIcon', htOnIcon,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htOnIndent', htOnIndent,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htOnLabel', htOnLabel,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htOnRight', htOnRight,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htOnStateIcon', htOnStateIcon,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htToLeft', htToLeft,TypeInfo(THitTest));
  CreateInterpreterConstLocal('htToRight', htToRight,TypeInfo(THitTest));
  CreateInterpreterConstLocal('stNone', stNone,TypeInfo(TSortType));
  CreateInterpreterConstLocal('stData', stData,TypeInfo(TSortType));
  CreateInterpreterConstLocal('stText', stText,TypeInfo(TSortType));
  CreateInterpreterConstLocal('stBoth', stBoth,TypeInfo(TSortType));
  CreateInterpreterConstLocal('trHorizontal', trHorizontal,TypeInfo(TTrackBarOrientation));
  CreateInterpreterConstLocal('trVertical', trVertical,TypeInfo(TTrackBarOrientation));
  CreateInterpreterConstLocal('tmBottomRight', tmBottomRight,TypeInfo(TTickMark));
  CreateInterpreterConstLocal('tmTopLeft', tmTopLeft,TypeInfo(TTickMark));
  CreateInterpreterConstLocal('tmBoth', tmBoth,TypeInfo(TTickMark));
  CreateInterpreterConstLocal('tsNone', tsNone,TypeInfo(TTickStyle));
  CreateInterpreterConstLocal('tsAuto', tsAuto,TypeInfo(TTickStyle));
  CreateInterpreterConstLocal('tsManual', tsManual,TypeInfo(TTickStyle));
  CreateInterpreterConstLocal('atSelected', atSelected,TypeInfo(TAttributeType));
  CreateInterpreterConstLocal('atDefaultText', atDefaultText,TypeInfo(TAttributeType));
  CreateInterpreterConstLocal('caBold', caBold,TypeInfo(TConsistentAttribute));
  CreateInterpreterConstLocal('caColor', caColor,TypeInfo(TConsistentAttribute));
  CreateInterpreterConstLocal('caFace', caFace,TypeInfo(TConsistentAttribute));
  CreateInterpreterConstLocal('caItalic', caItalic,TypeInfo(TConsistentAttribute));
  CreateInterpreterConstLocal('caSize', caSize,TypeInfo(TConsistentAttribute));
  CreateInterpreterConstLocal('caStrikeOut', caStrikeOut,TypeInfo(TConsistentAttribute));
  CreateInterpreterConstLocal('caUnderline', caUnderline,TypeInfo(TConsistentAttribute));
  CreateInterpreterConstLocal('caProtected', caProtected,TypeInfo(TConsistentAttribute));
  CreateInterpreterConstLocal('nsNone', nsNone,TypeInfo(TNumberingStyle));
  CreateInterpreterConstLocal('nsBullet', nsBullet,TypeInfo(TNumberingStyle));
  CreateInterpreterConstLocal('stWholeWord', stWholeWord,TypeInfo(TSearchType));
  CreateInterpreterConstLocal('stMatchCase', stMatchCase,TypeInfo(TSearchType));
  CreateInterpreterConstLocal('udLeft', udLeft,TypeInfo(TUDAlignButton));
  CreateInterpreterConstLocal('udRight', udRight,TypeInfo(TUDAlignButton));
  CreateInterpreterConstLocal('udHorizontal', udHorizontal,TypeInfo(TUDOrientation));
  CreateInterpreterConstLocal('udVertical', udVertical,TypeInfo(TUDOrientation));
  CreateInterpreterConstLocal('btNext', btNext,TypeInfo(TUDBtnType));
  CreateInterpreterConstLocal('btPrev', btPrev,TypeInfo(TUDBtnType));
  CreateInterpreterConstLocal('hkShift', hkShift,TypeInfo(THKModifier));
  CreateInterpreterConstLocal('hkCtrl', hkCtrl,TypeInfo(THKModifier));
  CreateInterpreterConstLocal('hkAlt', hkAlt,TypeInfo(THKModifier));
  CreateInterpreterConstLocal('hkExt', hkExt,TypeInfo(THKModifier));
  CreateInterpreterConstLocal('hcNone', hcNone,TypeInfo(THKInvalidKey));
  CreateInterpreterConstLocal('hcShift', hcShift,TypeInfo(THKInvalidKey));
  CreateInterpreterConstLocal('hcCtrl', hcCtrl,TypeInfo(THKInvalidKey));
  CreateInterpreterConstLocal('hcAlt', hcAlt,TypeInfo(THKInvalidKey));
  CreateInterpreterConstLocal('hcShiftCtrl', hcShiftCtrl,TypeInfo(THKInvalidKey));
  CreateInterpreterConstLocal('hcShiftAlt', hcShiftAlt,TypeInfo(THKInvalidKey));
  CreateInterpreterConstLocal('hcCtrlAlt', hcCtrlAlt,TypeInfo(THKInvalidKey));
  CreateInterpreterConstLocal('hcShiftCtrlAlt', hcShiftCtrlAlt,TypeInfo(THKInvalidKey));
  CreateInterpreterConstLocal('drBounds', drBounds,TypeInfo(TDisplayCode));
  CreateInterpreterConstLocal('drIcon', drIcon,TypeInfo(TDisplayCode));
  CreateInterpreterConstLocal('drLabel', drLabel,TypeInfo(TDisplayCode));
  CreateInterpreterConstLocal('drSelectBounds', drSelectBounds,TypeInfo(TDisplayCode));
  CreateInterpreterConstLocal('iaTop', iaTop,TypeInfo(TIconArrangement));
  CreateInterpreterConstLocal('iaLeft', iaLeft,TypeInfo(TIconArrangement));
  CreateInterpreterConstLocal('arAlignBottom', arAlignBottom,TypeInfo(TListArrangement));
  CreateInterpreterConstLocal('arAlignLeft', arAlignLeft,TypeInfo(TListArrangement));
  CreateInterpreterConstLocal('arAlignRight', arAlignRight,TypeInfo(TListArrangement));
  CreateInterpreterConstLocal('arAlignTop', arAlignTop,TypeInfo(TListArrangement));
  CreateInterpreterConstLocal('arDefault', arDefault,TypeInfo(TListArrangement));
  CreateInterpreterConstLocal('arSnapToGrid', arSnapToGrid,TypeInfo(TListArrangement));
  CreateInterpreterConstLocal('vsIcon', vsIcon,TypeInfo(TViewStyle));
  CreateInterpreterConstLocal('vsSmallIcon', vsSmallIcon,TypeInfo(TViewStyle));
  CreateInterpreterConstLocal('vsList', vsList,TypeInfo(TViewStyle));
  CreateInterpreterConstLocal('vsReport', vsReport,TypeInfo(TViewStyle));
  CreateInterpreterConstLocal('isNone', isNone,TypeInfo(TItemState));
  CreateInterpreterConstLocal('isCut', isCut,TypeInfo(TItemState));
  CreateInterpreterConstLocal('isDropHilited', isDropHilited,TypeInfo(TItemState));
  CreateInterpreterConstLocal('isFocused', isFocused,TypeInfo(TItemState));
  CreateInterpreterConstLocal('isSelected', isSelected,TypeInfo(TItemState));
  CreateInterpreterConstLocal('ctText', ctText,TypeInfo(TItemChange));
  CreateInterpreterConstLocal('ctImage', ctImage,TypeInfo(TItemChange));
  CreateInterpreterConstLocal('ctState', ctState,TypeInfo(TItemChange));
  CreateInterpreterConstLocal('sdLeft', sdLeft,TypeInfo(TSearchDirection));
  CreateInterpreterConstLocal('sdRight', sdRight,TypeInfo(TSearchDirection));
  CreateInterpreterConstLocal('sdAbove', sdAbove,TypeInfo(TSearchDirection));
  CreateInterpreterConstLocal('sdBelow', sdBelow,TypeInfo(TSearchDirection));
  CreateInterpreterConstLocal('sdAll', sdAll,TypeInfo(TSearchDirection));
  CreateInterpreterConstLocal('aviNone', aviNone,TypeInfo(TCommonAVI));
  CreateInterpreterConstLocal('aviFindFolder', aviFindFolder,TypeInfo(TCommonAVI));
  CreateInterpreterConstLocal('aviFindFile', aviFindFile,TypeInfo(TCommonAVI));
  CreateInterpreterConstLocal('aviFindComputer', aviFindComputer,TypeInfo(TCommonAVI));
  CreateInterpreterConstLocal('aviCopyFiles', aviCopyFiles,TypeInfo(TCommonAVI));
  CreateInterpreterConstLocal('aviCopyFile', aviCopyFile,TypeInfo(TCommonAVI));
  CreateInterpreterConstLocal('aviRecycleFile', aviRecycleFile,TypeInfo(TCommonAVI));
  CreateInterpreterConstLocal('aviEmptyRecycle', aviEmptyRecycle,TypeInfo(TCommonAVI));
  CreateInterpreterConstLocal('aviDeleteFile', aviDeleteFile,TypeInfo(TCommonAVI));

  // Extctrls

  CreateInterpreterConstLocal('stRectangle', stRectangle,TypeInfo(TShapeType));
  CreateInterpreterConstLocal('stSquare', stSquare,TypeInfo(TShapeType));
  CreateInterpreterConstLocal('stRoundRect', stRoundRect,TypeInfo(TShapeType));
  CreateInterpreterConstLocal('stRoundSquare', stRoundSquare,TypeInfo(TShapeType));
  CreateInterpreterConstLocal('stEllipse', stEllipse,TypeInfo(TShapeType));
  CreateInterpreterConstLocal('stCircle', stCircle,TypeInfo(TShapeType));
  CreateInterpreterConstLocal('bsLowered', bsLowered,TypeInfo(TBevelStyle));
  CreateInterpreterConstLocal('bsRaised', bsRaised,TypeInfo(TBevelStyle));
  CreateInterpreterConstLocal('bsBox', bsBox,TypeInfo(TBevelShape));
  CreateInterpreterConstLocal('bsFrame', bsFrame,TypeInfo(TBevelShape));
  CreateInterpreterConstLocal('bsTopLine', bsTopLine,TypeInfo(TBevelShape));
  CreateInterpreterConstLocal('bsBottomLine', bsBottomLine,TypeInfo(TBevelShape));
  CreateInterpreterConstLocal('bsLeftLine', bsLeftLine,TypeInfo(TBevelShape));
  CreateInterpreterConstLocal('bsRightLine', bsRightLine,TypeInfo(TBevelShape));
  CreateInterpreterConstLocal('bvNone', bvNone,TypeInfo(TBevelCut));
  CreateInterpreterConstLocal('bvLowered', bvLowered,TypeInfo(TBevelCut));
  CreateInterpreterConstLocal('bvRaised', bvRaised,TypeInfo(TBevelCut));

  // Forms

  CreateInterpreterConstLocal('sbHorizontal', Integer(Forms.sbHorizontal),TypeInfo(TScrollBarKind));
  CreateInterpreterConstLocal('sbVertical', Integer(Forms.sbVertical),TypeInfo(TScrollBarKind));
  CreateInterpreterConstLocal('bsNone', Integer(Forms.bsNone),TypeInfo(TFormBorderStyle));
  CreateInterpreterConstLocal('bsSingle', Integer(Forms.bsSingle),TypeInfo(TFormBorderStyle));
  CreateInterpreterConstLocal('bsSizeable', Integer(Forms.bsSizeable),TypeInfo(TFormBorderStyle));
  CreateInterpreterConstLocal('bsDialog', Integer(Forms.bsDialog),TypeInfo(TFormBorderStyle));
  CreateInterpreterConstLocal('bsToolWindow', Integer(Forms.bsToolWindow),TypeInfo(TFormBorderStyle));
  CreateInterpreterConstLocal('bsSizeToolWin', Integer(Forms.bsSizeToolWin),TypeInfo(TFormBorderStyle));
  CreateInterpreterConstLocal('wsNormal', Integer(Forms.wsNormal),TypeInfo(TWindowState));
  CreateInterpreterConstLocal('wsMinimized', Integer(Forms.wsMinimized),TypeInfo(TWindowState));
  CreateInterpreterConstLocal('wsMaximized', Integer(Forms.wsMaximized),TypeInfo(TWindowState));
  CreateInterpreterConstLocal('fsNormal', Integer(Forms.fsNormal),TypeInfo(TFormStyle));
  CreateInterpreterConstLocal('fsMDIChild', Integer(Forms.fsMDIChild),TypeInfo(TFormStyle));
  CreateInterpreterConstLocal('fsMDIForm', Integer(Forms.fsMDIForm),TypeInfo(TFormStyle));
  CreateInterpreterConstLocal('fsStayOnTop', Integer(Forms.fsStayOnTop),TypeInfo(TFormStyle));
  CreateInterpreterConstLocal('biSystemMenu', Integer(Forms.biSystemMenu),TypeInfo(TBorderIcon));
  CreateInterpreterConstLocal('biMinimize', Integer(Forms.biMinimize),TypeInfo(TBorderIcon));
  CreateInterpreterConstLocal('biMaximize', Integer(Forms.biMaximize),TypeInfo(TBorderIcon));
  CreateInterpreterConstLocal('biHelp', Integer(Forms.biHelp),TypeInfo(TBorderIcon));
  CreateInterpreterConstLocal('poDesigned', Integer(Forms.poDesigned),TypeInfo(TPosition));
  CreateInterpreterConstLocal('poDefault', Integer(Forms.poDefault),TypeInfo(TPosition));
  CreateInterpreterConstLocal('poDefaultPosOnly', Integer(Forms.poDefaultPosOnly),TypeInfo(TPosition));
  CreateInterpreterConstLocal('poDefaultSizeOnly', Integer(Forms.poDefaultSizeOnly),TypeInfo(TPosition));
  CreateInterpreterConstLocal('poScreenCenter', Integer(Forms.poScreenCenter),TypeInfo(TPosition));
  CreateInterpreterConstLocal('poNone', Integer(Forms.poNone),TypeInfo(TPosition));
  CreateInterpreterConstLocal('poProportional', Integer(Forms.poProportional),TypeInfo(TPosition));
  CreateInterpreterConstLocal('poPrintToFit', Integer(Forms.poPrintToFit),TypeInfo(TPosition));
  CreateInterpreterConstLocal('saIgnore', Integer(Forms.saIgnore),TypeInfo(TShowAction));
  CreateInterpreterConstLocal('saRestore', Integer(Forms.saRestore),TypeInfo(TShowAction));
  CreateInterpreterConstLocal('saMinimize', Integer(Forms.saMinimize),TypeInfo(TShowAction));
  CreateInterpreterConstLocal('saMaximize', Integer(Forms.saMaximize),TypeInfo(TShowAction));
  CreateInterpreterConstLocal('tbHorizontal', Integer(Forms.tbHorizontal),TypeInfo(TTileMode));
  CreateInterpreterConstLocal('tbVertical', Integer(Forms.tbVertical),TypeInfo(TTileMode));
  CreateInterpreterConstLocal('caNone', Integer(Forms.caNone),TypeInfo(TCloseAction));
  CreateInterpreterConstLocal('caHide', Integer(Forms.caHide),TypeInfo(TCloseAction));
  CreateInterpreterConstLocal('caFree', Integer(Forms.caFree),TypeInfo(TCloseAction));
  CreateInterpreterConstLocal('caMinimize', Integer(Forms.caMinimize),TypeInfo(TCloseAction));
  CreateInterpreterConstLocal('fsCreating', Integer(Forms.fsCreating),TypeInfo(TFormState));
  CreateInterpreterConstLocal('fsVisible', Integer(Forms.fsVisible),TypeInfo(TFormState));
  CreateInterpreterConstLocal('fsShowing', Integer(Forms.fsShowing),TypeInfo(TFormState));
  CreateInterpreterConstLocal('fsModal', Integer(Forms.fsModal),TypeInfo(TFormState));
  CreateInterpreterConstLocal('fsCreatedMDIChild', Integer(Forms.fsCreatedMDIChild),TypeInfo(TFormState));
  CreateInterpreterConstLocal('fsActivated', Integer(Forms.fsActivated),TypeInfo(TFormState));
  CreateInterpreterConstLocal('tmShow', Integer(Forms.tmShow),TypeInfo(TTimerMode));
  CreateInterpreterConstLocal('tmHide', Integer(Forms.tmHide),TypeInfo(TTimerMode));

  // Dialogs

  CreateInterpreterConstLocal('ofReadOnly', Integer(ofReadOnly),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofOverwritePrompt', Integer(ofOverwritePrompt),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofHideReadOnly', Integer(ofHideReadOnly),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofNoChangeDir', Integer(ofNoChangeDir),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofShowHelp', Integer(ofShowHelp),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofNoValidate', Integer(ofNoValidate),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofAllowMultiSelect', Integer(ofAllowMultiSelect),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofExtensionDifferent', Integer(ofExtensionDifferent),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofPathMustExist', Integer(ofPathMustExist),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofFileMustExist', Integer(ofFileMustExist),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofCreatePrompt', Integer(ofCreatePrompt),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofShareAware', Integer(ofShareAware),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofNoReadOnlyReturn', Integer(ofNoReadOnlyReturn),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofNoTestFileCreate', Integer(ofNoTestFileCreate),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofNoNetworkButton', Integer(ofNoNetworkButton),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofNoLongNames', Integer(ofNoLongNames),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofOldStyleDialog', Integer(ofOldStyleDialog),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('ofNoDereferenceLinks', Integer(ofNoDereferenceLinks),TypeInfo(TOpenOption));
  CreateInterpreterConstLocal('fsEdit', Integer(fsEdit),TypeInfo(TFileEditStyle));
  CreateInterpreterConstLocal('fsComboBox', Integer(fsComboBox),TypeInfo(TFileEditStyle));
  CreateInterpreterConstLocal('cdFullOpen', Integer(cdFullOpen),TypeInfo(TColorDialogOption));
  CreateInterpreterConstLocal('cdPreventFullOpen', Integer(cdPreventFullOpen),TypeInfo(TColorDialogOption));
  CreateInterpreterConstLocal('cdShowHelp', Integer(cdShowHelp),TypeInfo(TColorDialogOption));
  CreateInterpreterConstLocal('cdSolidColor', Integer(cdSolidColor),TypeInfo(TColorDialogOption));
  CreateInterpreterConstLocal('cdAnyColor', Integer(cdAnyColor),TypeInfo(TColorDialogOption));
  CreateInterpreterConstLocal('fdAnsiOnly', Integer(fdAnsiOnly),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdTrueTypeOnly', Integer(fdTrueTypeOnly),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdEffects', Integer(fdEffects),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdFixedPitchOnly', Integer(fdFixedPitchOnly),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdForceFontExist', Integer(fdForceFontExist),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdNoFaceSel', Integer(fdNoFaceSel),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdNoOEMFonts', Integer(fdNoOEMFonts),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdNoSimulations', Integer(fdNoSimulations),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdNoSizeSel', Integer(fdNoSizeSel),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdNoStyleSel', Integer(fdNoStyleSel),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdNoVectorFonts', Integer(fdNoVectorFonts),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdShowHelp', Integer(fdShowHelp),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdWysiwyg', Integer(fdWysiwyg),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdLimitSize', Integer(fdLimitSize),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdScalableOnly', Integer(fdScalableOnly),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdApplyButton', Integer(fdApplyButton),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdScreen', Integer(fdScreen),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdPrinter', Integer(fdPrinter),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('fdBoth', Integer(fdBoth),TypeInfo(TFontDialogOption));
  CreateInterpreterConstLocal('prAllPages', Integer(prAllPages),TypeInfo(TPrintRange));
  CreateInterpreterConstLocal('prSelection', Integer(prSelection),TypeInfo(TPrintRange));
  CreateInterpreterConstLocal('prPageNums', Integer(prPageNums),TypeInfo(TPrintRange));
  CreateInterpreterConstLocal('poPrintToFile', Integer(poPrintToFile),TypeInfo(TPrintDialogOption));
  CreateInterpreterConstLocal('poPageNums', Integer(poPageNums),TypeInfo(TPrintDialogOption));
  CreateInterpreterConstLocal('poSelection', Integer(poSelection),TypeInfo(TPrintDialogOption));
  CreateInterpreterConstLocal('poWarning', Integer(poWarning),TypeInfo(TPrintDialogOption));
  CreateInterpreterConstLocal('poHelp', Integer(poHelp),TypeInfo(TPrintDialogOption));
  CreateInterpreterConstLocal('poDisablePrintToFile', Integer(poDisablePrintToFile),TypeInfo(TPrintDialogOption));
  CreateInterpreterConstLocal('frDown', Integer(frDown),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frFindNext', Integer(frFindNext),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frHideMatchCase', Integer(frHideMatchCase),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frHideWholeWord', Integer(frHideWholeWord),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frHideUpDown', Integer(frHideUpDown),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frMatchCase', Integer(frMatchCase),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frDisableMatchCase', Integer(frDisableMatchCase),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frDisableUpDown', Integer(frDisableUpDown),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frDisableWholeWord', Integer(frDisableWholeWord),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frReplace', Integer(frReplace),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frReplaceAll', Integer(frReplaceAll),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frWholeWord', Integer(frWholeWord),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('frShowHelp', Integer(frShowHelp),TypeInfo(TFindOption));
  CreateInterpreterConstLocal('mtWarning', Integer(mtWarning),TypeInfo(TMsgDlgType));
  CreateInterpreterConstLocal('mtError', Integer(mtError),TypeInfo(TMsgDlgType));
  CreateInterpreterConstLocal('mtInformation', Integer(mtInformation),TypeInfo(TMsgDlgType));
  CreateInterpreterConstLocal('mtConfirmation', Integer(mtConfirmation),TypeInfo(TMsgDlgType));
  CreateInterpreterConstLocal('mtCustom', Integer(mtCustom),TypeInfo(TMsgDlgType));
  CreateInterpreterConstLocal('mbYes', Integer(mbYes),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbNo', Integer(mbNo),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbOK', Integer(mbOK),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbCancel', Integer(mbCancel),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbAbort', Integer(mbAbort),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbRetry', Integer(mbRetry),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbIgnore', Integer(mbIgnore),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbAll', Integer(mbAll),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbNoToAll', Integer(mbNoToAll),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbYesToAll', Integer(mbYesToAll),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mbHelp', Integer(mbHelp),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrNone', Integer(mrNone),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrOk', Integer(mrOk),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrCancel', Integer(mrCancel),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrAbort', Integer(mrAbort),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrRetry', Integer(mrRetry),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrIgnore', Integer(mrIgnore),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrYes', Integer(mrYes),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrNo', Integer(mrNo),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrAll', Integer(mrAll),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrNoToAll', Integer(mrNoToAll),TypeInfo(TMsgDlgBtn));
  CreateInterpreterConstLocal('mrYesToAll', Integer(mrYesToAll),TypeInfo(TMsgDlgBtn));

  // Grids

  CreateInterpreterConstLocal('gsNormal', gsNormal,TypeInfo(TGridState));
  CreateInterpreterConstLocal('gsSelecting', gsSelecting,TypeInfo(TGridState));
  CreateInterpreterConstLocal('gsRowSizing', gsRowSizing,TypeInfo(TGridState));
  CreateInterpreterConstLocal('gsColSizing', gsColSizing,TypeInfo(TGridState));
  CreateInterpreterConstLocal('gsRowMoving', gsRowMoving,TypeInfo(TGridState));
  CreateInterpreterConstLocal('gsColMoving', gsColMoving,TypeInfo(TGridState));
  CreateInterpreterConstLocal('goFixedVertLine', goFixedVertLine,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goFixedHorzLine', goFixedHorzLine,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goVertLine', goVertLine,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goHorzLine', goHorzLine,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goRangeSelect', goRangeSelect,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goDrawFocusSelected', goDrawFocusSelected,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goRowSizing', goRowSizing,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goColSizing', goColSizing,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goRowMoving', goRowMoving,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goColMoving', goColMoving,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goEditing', goEditing,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goTabs', goTabs,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goRowSelect', goRowSelect,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goAlwaysShowEditor', goAlwaysShowEditor,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('goThumbTracking', goThumbTracking,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('gdSelected', gdSelected,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('gdFocused', gdFocused,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('gdFixed', gdFixed,TypeInfo(TGridOption));
  CreateInterpreterConstLocal('sdLeft', sdLeft,TypeInfo(TGridScrollDirection));
  CreateInterpreterConstLocal('sdRight', sdRight,TypeInfo(TGridScrollDirection));
  CreateInterpreterConstLocal('sdUp', sdUp,TypeInfo(TGridScrollDirection));
  CreateInterpreterConstLocal('sdDown', sdDown,TypeInfo(TGridScrollDirection));

  // Db

  CreateInterpreterConstLocal('dsInactive', dsInactive,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsBrowse', dsBrowse,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsEdit', dsEdit,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsInsert', dsInsert,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsSetKey', dsSetKey,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsCalcFields', dsCalcFields,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsFilter', dsFilter,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsNewValue', dsNewValue,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsOldValue', dsOldValue,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('dsCurValue', dsCurValue,TypeInfo(TDataSetState));
  CreateInterpreterConstLocal('deFieldChange', deFieldChange,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deRecordChange', deRecordChange,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deDataSetChange', deDataSetChange,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deDataSetScroll', deDataSetScroll,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deLayoutChange', deLayoutChange,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deUpdateRecord', deUpdateRecord,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deUpdateState', deUpdateState,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deCheckBrowseMode', deCheckBrowseMode,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('dePropertyChange', dePropertyChange,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deFieldListChange', deFieldListChange,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('deFocusControl', deFocusControl,TypeInfo(TDataEvent));
  CreateInterpreterConstLocal('usUnmodified', usUnmodified,TypeInfo(TUpdateStatus));
  CreateInterpreterConstLocal('usModified', usModified,TypeInfo(TUpdateStatus));
  CreateInterpreterConstLocal('usInserted', usInserted,TypeInfo(TUpdateStatus));
  CreateInterpreterConstLocal('usDeleted', usDeleted,TypeInfo(TUpdateStatus));
  CreateInterpreterConstLocal('ftUnknown', ftUnknown,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftString', ftString,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftSmallint', ftSmallint,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftInteger', ftInteger,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftWord', ftWord,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftBoolean', ftBoolean,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftFloat', ftFloat,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftCurrency', ftCurrency,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftBCD', ftBCD,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftDate', ftDate,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftTime', ftTime,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftDateTime', ftDateTime,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftBytes', ftBytes,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftVarBytes', ftVarBytes,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftAutoInc', ftAutoInc,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftBlob', ftBlob,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftMemo', ftMemo,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftGraphic', ftGraphic,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftFmtMemo', ftFmtMemo,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftParadoxOle', ftParadoxOle,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftDBaseOle', ftDBaseOle,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftTypedBinary', ftTypedBinary,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('ftCursor', ftCursor,TypeInfo(TFieldType));
  CreateInterpreterConstLocal('fkData', fkData,TypeInfo(TFieldKind));
  CreateInterpreterConstLocal('fkCalculated', fkCalculated,TypeInfo(TFieldKind));
  CreateInterpreterConstLocal('fkLookup', fkLookup,TypeInfo(TFieldKind));
  CreateInterpreterConstLocal('fkInternalCalc', fkInternalCalc,TypeInfo(TFieldKind));
  CreateInterpreterConstLocal('ixPrimary', ixPrimary,TypeInfo(TIndexOption));
  CreateInterpreterConstLocal('ixUnique', ixUnique,TypeInfo(TIndexOption));
  CreateInterpreterConstLocal('ixDescending', ixDescending,TypeInfo(TIndexOption));
  CreateInterpreterConstLocal('ixCaseInsensitive', ixCaseInsensitive,TypeInfo(TIndexOption));
  CreateInterpreterConstLocal('ixExpression', ixExpression,TypeInfo(TIndexOption));
  CreateInterpreterConstLocal('bfCurrent', bfCurrent,TypeInfo(TBookmarkFlag));
  CreateInterpreterConstLocal('bfBOF', bfBOF,TypeInfo(TBookmarkFlag));
  CreateInterpreterConstLocal('bfEOF', bfEOF,TypeInfo(TBookmarkFlag));
  CreateInterpreterConstLocal('bfInserted', bfInserted,TypeInfo(TBookmarkFlag));
  CreateInterpreterConstLocal('gmCurrent', gmCurrent,TypeInfo(TGetMode));
  CreateInterpreterConstLocal('gmNext', gmNext,TypeInfo(TGetMode));
  CreateInterpreterConstLocal('gmPrior', gmPrior,TypeInfo(TGetMode));
  CreateInterpreterConstLocal('grOK', grOK,TypeInfo(TGetResult));
  CreateInterpreterConstLocal('grBOF', grBOF,TypeInfo(TGetResult));
  CreateInterpreterConstLocal('grEOF', grEOF,TypeInfo(TGetResult));
  CreateInterpreterConstLocal('grError', grError,TypeInfo(TGetResult));
  CreateInterpreterConstLocal('rmExact', rmExact,TypeInfo(TResyncMode));
  CreateInterpreterConstLocal('rmCenter', rmCenter,TypeInfo(TResyncMode));
  CreateInterpreterConstLocal('daFail', daFail,TypeInfo(TDataAction));
  CreateInterpreterConstLocal('daAbort', daAbort,TypeInfo(TDataAction));
  CreateInterpreterConstLocal('daRetry', daRetry,TypeInfo(TDataAction));
  CreateInterpreterConstLocal('ukModify', ukModify,TypeInfo(TUpdateKind));
  CreateInterpreterConstLocal('ukInsert', ukInsert,TypeInfo(TUpdateKind));
  CreateInterpreterConstLocal('ukDelete', ukDelete,TypeInfo(TUpdateKind));
  CreateInterpreterConstLocal('bmRead', bmRead,TypeInfo(TBlobStreamMode));
  CreateInterpreterConstLocal('bmWrite', bmWrite,TypeInfo(TBlobStreamMode));
  CreateInterpreterConstLocal('bmReadWrite', bmReadWrite,TypeInfo(TBlobStreamMode));
  CreateInterpreterConstLocal('loCaseInsensitive', loCaseInsensitive,TypeInfo(TLocateOption));
  CreateInterpreterConstLocal('loPartialKey', loPartialKey,TypeInfo(TLocateOption));
  CreateInterpreterConstLocal('foCaseInsensitive', foCaseInsensitive,TypeInfo(TFilterOption));
  CreateInterpreterConstLocal('foNoPartialCompare', foNoPartialCompare,TypeInfo(TFilterOption));
  CreateInterpreterConstLocal('dfBinary', dfBinary,TypeInfo(TDataPacketFormat));
  CreateInterpreterConstLocal('dfXML', dfXML,TypeInfo(TDataPacketFormat));

  // DbTables
  
  CreateInterpreterConstLocal('cfmVirtual', cfmVirtual,TypeInfo(TConfigModes));
  CreateInterpreterConstLocal('cfmPersistent', cfmPersistent,TypeInfo(TConfigModes));
  CreateInterpreterConstLocal('cfmSession', cfmSession,TypeInfo(TConfigModes));
  CreateInterpreterConstLocal('dbOpen', dbOpen,TypeInfo(TDatabaseEvent));
  CreateInterpreterConstLocal('dbClose', dbClose,TypeInfo(TDatabaseEvent));
  CreateInterpreterConstLocal('dbAdd', dbAdd,TypeInfo(TDatabaseEvent));
  CreateInterpreterConstLocal('dbRemove', dbRemove,TypeInfo(TDatabaseEvent));
  CreateInterpreterConstLocal('dbAddAlias', dbAddAlias,TypeInfo(TDatabaseEvent));
  CreateInterpreterConstLocal('dbDeleteAlias', dbDeleteAlias,TypeInfo(TDatabaseEvent));
  CreateInterpreterConstLocal('dbAddDriver', dbAddDriver,TypeInfo(TDatabaseEvent));
  CreateInterpreterConstLocal('dbDeleteDriver', dbDeleteDriver,TypeInfo(TDatabaseEvent));
  CreateInterpreterConstLocal('tfQPrepare', tfQPrepare,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfQExecute', tfQExecute,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfError', tfError,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfStmt', tfStmt,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfConnect', tfConnect,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfTransact', tfTransact,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfBlob', tfBlob,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfMisc', tfMisc,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfVendor', tfVendor,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfDataIn', tfDataIn,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tfDataOut', tfDataOut,TypeInfo(TTraceFlag));
  CreateInterpreterConstLocal('tiDirtyRead', tiDirtyRead,TypeInfo(TTransIsolation));
  CreateInterpreterConstLocal('tiReadCommitted', tiReadCommitted,TypeInfo(TTransIsolation));
  CreateInterpreterConstLocal('tiRepeatableRead', tiRepeatableRead,TypeInfo(TTransIsolation));
  CreateInterpreterConstLocal('rnDbase', rnDbase,TypeInfo(TRecNoStatus));
  CreateInterpreterConstLocal('rnParadox', rnParadox,TypeInfo(TRecNoStatus));
  CreateInterpreterConstLocal('rnNotSupported', rnNotSupported,TypeInfo(TRecNoStatus));
  CreateInterpreterConstLocal('uaFail', uaFail,TypeInfo(TUpdateAction));
  CreateInterpreterConstLocal('uaAbort', uaAbort,TypeInfo(TUpdateAction));
  CreateInterpreterConstLocal('uaSkip', uaSkip,TypeInfo(TUpdateAction));
  CreateInterpreterConstLocal('uaRetry', uaRetry,TypeInfo(TUpdateAction));
  CreateInterpreterConstLocal('uaApplied', uaApplied,TypeInfo(TUpdateAction));
  CreateInterpreterConstLocal('rtModified', rtModified,TypeInfo(TUpdateRecordTypes));
  CreateInterpreterConstLocal('rtInserted', rtInserted,TypeInfo(TUpdateRecordTypes));
  CreateInterpreterConstLocal('rtDeleted', rtDeleted,TypeInfo(TUpdateRecordTypes));
  CreateInterpreterConstLocal('rtUnmodified', rtUnmodified,TypeInfo(TUpdateRecordTypes));
  CreateInterpreterConstLocal('kiLookup', kiLookup,TypeInfo(TKeyIndex));
  CreateInterpreterConstLocal('kiRangeStart', kiRangeStart,TypeInfo(TKeyIndex));
  CreateInterpreterConstLocal('kiRangeEnd', kiRangeEnd,TypeInfo(TKeyIndex));
  CreateInterpreterConstLocal('kiCurRangeStart', kiCurRangeStart,TypeInfo(TKeyIndex));
  CreateInterpreterConstLocal('kiCurRangeEnd', kiCurRangeEnd,TypeInfo(TKeyIndex));
  CreateInterpreterConstLocal('kiSave', kiSave,TypeInfo(TKeyIndex));
  CreateInterpreterConstLocal('upWhereAll', upWhereAll,TypeInfo(TUpdateMode));
  CreateInterpreterConstLocal('upWhereChanged', upWhereChanged,TypeInfo(TUpdateMode));
  CreateInterpreterConstLocal('upWhereKeyOnly', upWhereKeyOnly,TypeInfo(TUpdateMode));
  CreateInterpreterConstLocal('batAppend', batAppend,TypeInfo(TBatchMode));
  CreateInterpreterConstLocal('batUpdate', batUpdate,TypeInfo(TBatchMode));
  CreateInterpreterConstLocal('batAppendUpdate', batAppendUpdate,TypeInfo(TBatchMode));
  CreateInterpreterConstLocal('batDelete', batDelete,TypeInfo(TBatchMode));
  CreateInterpreterConstLocal('batCopy', batCopy,TypeInfo(TBatchMode));
  CreateInterpreterConstLocal('ttDefault', ttDefault,TypeInfo(TTableType));
  CreateInterpreterConstLocal('ttParadox', ttParadox,TypeInfo(TTableType));
  CreateInterpreterConstLocal('ttDBase', ttDBase,TypeInfo(TTableType));
  CreateInterpreterConstLocal('ttASCII', ttASCII,TypeInfo(TTableType));
  CreateInterpreterConstLocal('ltReadLock', ltReadLock,TypeInfo(TLockType));
  CreateInterpreterConstLocal('ltWriteLock', ltWriteLock,TypeInfo(TLockType));
  CreateInterpreterConstLocal('ptUnknown', ptUnknown,TypeInfo(TParamType));
  CreateInterpreterConstLocal('ptInput', ptInput,TypeInfo(TParamType));
  CreateInterpreterConstLocal('ptOutput', ptOutput,TypeInfo(TParamType));
  CreateInterpreterConstLocal('ptInputOutput', ptInputOutput,TypeInfo(TParamType));
  CreateInterpreterConstLocal('ptResult', ptResult,TypeInfo(TParamType));
  CreateInterpreterConstLocal('pbByName', pbByName,TypeInfo(TParamBindMode));
  CreateInterpreterConstLocal('pbByNumber', pbByNumber,TypeInfo(TParamBindMode));

  // DbGrids

  CreateInterpreterConstLocal('cvColor', cvColor,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvWidth', cvWidth,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvFont', cvFont,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvAlignment', cvAlignment,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvReadOnly', cvReadOnly,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvTitleColor', cvTitleColor,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvTitleCaption', cvTitleCaption,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvTitleAlignment', cvTitleAlignment,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvTitleFont', cvTitleFont,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvImeMode', cvImeMode,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cvImeName', cvImeName,TypeInfo(TColumnValue));
  CreateInterpreterConstLocal('cbsAuto', cbsAuto,TypeInfo(TColumnButtonStyle));
  CreateInterpreterConstLocal('cbsEllipsis', cbsEllipsis,TypeInfo(TColumnButtonStyle));
  CreateInterpreterConstLocal('cbsNone', cbsNone,TypeInfo(TColumnButtonStyle));
  CreateInterpreterConstLocal('csDefault', csDefault,TypeInfo(TDBGridColumnsState));
  CreateInterpreterConstLocal('csCustomized', csCustomized,TypeInfo(TDBGridColumnsState));
  CreateInterpreterConstLocal('dgEditing', dgEditing,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgAlwaysShowEditor', dgAlwaysShowEditor,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgTitles', dgTitles,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgIndicator', dgIndicator,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgColumnResize', dgColumnResize,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgColLines', dgColLines,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgRowLines', dgRowLines,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgTabs', dgTabs,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgRowSelect', dgRowSelect,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgAlwaysShowSelection', dgAlwaysShowSelection,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgConfirmDelete', dgConfirmDelete,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgCancelOnExit', dgCancelOnExit,TypeInfo(TDBGridOption));
  CreateInterpreterConstLocal('dgMultiSelect', dgMultiSelect,TypeInfo(TDBGridOption));

  // stbasis
  CreateInterpreterConstLocal('tliInformation', tliInformation,TypeInfo(TTypeLogItem),tcFirst);
  CreateInterpreterConstLocal('tliWarning', tliWarning,TypeInfo(TTypeLogItem),tcFirst);
  CreateInterpreterConstLocal('tliError', tliError,TypeInfo(TTypeLogItem),tcFirst);
  CreateInterpreterConstLocal('tliConfirmation', tliConfirmation,TypeInfo(TTypeLogItem),tcFirst);

  CreateInterpreterConstLocal('tviMdiChild',tviMdiChild,TypeInfo(TTypeViewInterface),tcFirst);
  CreateInterpreterConstLocal('tvibvModal',tvibvModal,TypeInfo(TTypeViewInterface),tcFirst);
  CreateInterpreterConstLocal('tviOnlyData',tviOnlyData,TypeInfo(TTypeViewInterface),tcFirst);

  CreateInterpreterConstLocal('tepQuarter',tepQuarter,TypeInfo(TTypeEnterPeriod),tcFirst);
  CreateInterpreterConstLocal('tepMonth',tepMonth,TypeInfo(TTypeEnterPeriod),tcFirst);
  CreateInterpreterConstLocal('tepDay',tepDay,TypeInfo(TTypeEnterPeriod),tcFirst);
  CreateInterpreterConstLocal('tepInterval',tepInterval,TypeInfo(TTypeEnterPeriod),tcFirst);
  CreateInterpreterConstLocal('tepYear',tepYear,TypeInfo(TTypeEnterPeriod),tcFirst);

  // Virtual Db Tree

  CreateInterpreterConstLocal('ikNormal',ikNormal,TypeInfo(TVTImageKind),tcFirst);
  CreateInterpreterConstLocal('ikSelected',ikSelected,TypeInfo(TVTImageKind),tcFirst);
  CreateInterpreterConstLocal('ikState',ikState,TypeInfo(TVTImageKind),tcFirst);
  CreateInterpreterConstLocal('ikOverlay',ikOverlay,TypeInfo(TVTImageKind),tcFirst);

  CreateInterpreterConstLocal('csUncheckedNormal',csUncheckedNormal,TypeInfo(TCheckState),tcFirst);
  CreateInterpreterConstLocal('csUncheckedPressed',csUncheckedPressed,TypeInfo(TCheckState),tcFirst);
  CreateInterpreterConstLocal('csCheckedNormal',csCheckedNormal,TypeInfo(TCheckState),tcFirst);
  CreateInterpreterConstLocal('csCheckedPressed',csCheckedPressed,TypeInfo(TCheckState),tcFirst);
  CreateInterpreterConstLocal('csMixedNormal',csMixedNormal,TypeInfo(TCheckState),tcFirst);
  CreateInterpreterConstLocal('csMixedPressed',csMixedPressed,TypeInfo(TCheckState),tcFirst);

end;

procedure ClearListInterpreterClassHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterpreterClassHandles.Count-1 do begin
    _FreeInterpreterClass(THandle(ListInterpreterClassHandles.Items[i]));
  end;
  ListInterpreterClassHandles.Clear;
end;

function CreateInterpreterClassLocal(ClassType: TClass; Hint: PChar=nil): THandle;
var
  TCICL: TCreateInterpreterClass;
begin
  FillChar(TCICL,SizeOf(TCreateInterpreterClass),0);
  TCICL.ClassType:=ClassType;
  TCICL.Hint:=Hint;
  Result:=_CreateInterpreterClass(@TCICL);
  if Result<>INTERPRETERCLASS_INVALID_HANDLE then
   ListInterpreterClassHandles.Add(Pointer(Result));
end;

function CreateInterpreterClassMethodLocal(hClass: THandle;
                                          Identifer: PChar;
                                          Proc: TInterpreterReadProc;
                                          ProcParams: TArrOfInterpreterProcParam;
                                          ProcResultType: PInterpreterProcParam;
                                          Hint: PChar=nil): THandle;
var
  TCICM: TCreateInterpreterClassMethod;
  i: Integer;
begin
  FillChar(TCICM,SizeOf(TCreateInterpreterClassMethod),0);
  TCICM.Identifer:=Identifer;
  TCICM.Proc:=Proc;
  for i:=Low(ProcParams) to High(ProcParams) do begin
   SetLength(TCICM.ProcParams,Length(TCICM.ProcParams)+1);
   TCICM.ProcParams[Length(TCICM.ProcParams)-1].ParamText:=ProcParams[i].ParamText;
   TCICM.ProcParams[Length(TCICM.ProcParams)-1].ParamType:=ProcParams[i].ParamType;
  end;
  if ProcResultType<>nil then
   TCICM.ProcResultType:=ProcResultType^;
  TCICM.Hint:=Hint;
  Result:=_CreateInterpreterClassMethod(hClass,@TCICM);
end;

function CreateInterpreterClassPropertyLocal(hClass: THandle;
                                            Identifer: PChar;
                                            ReadProc: TInterpreterReadProc;
                                            ReadProcParams: TArrOfInterpreterProcParam;
                                            ReadProcResultType: PInterpreterProcParam;
                                            WriteProc: TInterpreterWriteProc;
                                            WriteProcParams: TArrOfInterpreterProcParam;
                                            isIndexProperty: Boolean=false;
                                            Hint: PChar=nil): THandle;
var
  TCICP: TCreateInterpreterClassProperty;
  i: Integer;
begin
  FillChar(TCICP,SizeOf(TCreateInterpreterClassProperty),0);
  TCICP.Identifer:=Identifer;
  TCICP.ReadProc:=ReadProc;
  for i:=Low(ReadProcParams) to High(ReadProcParams) do begin
   SetLength(TCICP.ReadProcParams,Length(TCICP.ReadProcParams)+1);
   TCICP.ReadProcParams[Length(TCICP.ReadProcParams)-1].ParamText:=ReadProcParams[i].ParamText;
   TCICP.ReadProcParams[Length(TCICP.ReadProcParams)-1].ParamType:=ReadProcParams[i].ParamType;
  end;
  if ReadProcResultType<>nil then
   TCICP.ReadProcResultType:=ReadProcResultType^;
  TCICP.WriteProc:=WriteProc;
  for i:=Low(WriteProcParams) to High(WriteProcParams) do begin
   SetLength(TCICP.WriteProcParams,Length(TCICP.WriteProcParams)+1);
   TCICP.WriteProcParams[Length(TCICP.WriteProcParams)-1].ParamText:=WriteProcParams[i].ParamText;
   TCICP.WriteProcParams[Length(TCICP.WriteProcParams)-1].ParamType:=WriteProcParams[i].ParamType;
  end;
  TCICP.isIndexProperty:=isIndexProperty;
  TCICP.Hint:=Hint;
  Result:=_CreateInterpreterClassProperty(hClass,@TCICP);
end;


procedure GetDesignPaletteProc(Owner: Pointer; PGDP: PGetDesignPalette); stdcall;
var
  i: Integer;
  h: THandle;
begin
  if not isValidPointer(PGDP) then exit;
  for i:=Low(PGDP.Buttons) to High(PGDP.Buttons) do begin
    h:=CreateInterpreterClassLocal(PGDP.Buttons[i].Cls,PGDP.Buttons[i].Hint);
    CreateInterpreterClassMethodLocal(h,'Create',TComponent_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  end;
end;

procedure AddToListInterpreterClassHandles;

var
  h: Thandle;
begin
  // System

  h:=CreateInterpreterClassLocal(TObject);
  CreateInterpreterClassMethodLocal(h,'ClassType',TObject_ClassType,nil,PP('TClass',varClass));
  CreateInterpreterClassMethodLocal(h,'ClassName',TObject_ClassName,nil,PP('String',varString));
  CreateInterpreterClassMethodLocal(h,'ClassNameIs',TObject_ClassNameIs,ArrPP(['const Name: string',varString]),PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'ClassParent',TObject_ClassParent,nil,PP('TClass',varClass));
  CreateInterpreterClassMethodLocal(h,'ClassInfo',TObject_ClassParent,nil,PP('Pointer',varPointer));
  CreateInterpreterClassMethodLocal(h,'InstanceSize',TObject_InstanceSize,nil,PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'InheritsFrom',TObject_InheritsFrom,ArrPP(['AClass: TClass',varClass]),PP('Boolean',varBoolean));

  // SysUtils

  h:=CreateInterpreterClassLocal(Exception);
  CreateInterpreterClassMethodLocal(h,'Create',Exception_Create,ArrPP(['Msg: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'CreateRes',Exception_CreateRes,ArrPP(['Ident: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'CreateHelp',Exception_CreateHelp,
                                    ArrPP(['Msg: string',varString,'AHelpContext: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'CreateResHelp',Exception_CreateResHelp,
                                    ArrPP(['Ident: Integer',varInteger,'AHelpContext: Integer',varInteger]),nil);
  CreateInterpreterClassPropertyLocal(h,'HelpContext',Exception_Read_HelpContext,nil,PP('Integer',varInteger),
                                      Exception_Write_HelpContext,ArrPP(['Value: Integer',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'Message',Exception_Read_Message,nil,PP('String',varString),
                                      Exception_Write_Message,ArrPP(['Value: string',varString]));

  CreateInterpreterClassLocal(EAbort);
  CreateInterpreterClassLocal(EOutOfMemory);
  CreateInterpreterClassLocal(EInOutError);
  CreateInterpreterClassLocal(EIntError);
  CreateInterpreterClassLocal(EDivByZero);
  CreateInterpreterClassLocal(ERangeError);
  CreateInterpreterClassLocal(EIntOverflow);
  CreateInterpreterClassLocal(EMathError);
  CreateInterpreterClassLocal(EInvalidOp);
  CreateInterpreterClassLocal(EZeroDivide);
  CreateInterpreterClassLocal(EOverflow);
  CreateInterpreterClassLocal(EUnderflow);
  CreateInterpreterClassLocal(EInvalidPointer);
  CreateInterpreterClassLocal(EInvalidCast);
  CreateInterpreterClassLocal(EConvertError);
  CreateInterpreterClassLocal(EAccessViolation);
  CreateInterpreterClassLocal(EPrivilege);
  CreateInterpreterClassLocal(EStackOverflow);
  CreateInterpreterClassLocal(EControlC);
  CreateInterpreterClassLocal(EVariantError);
  CreateInterpreterClassLocal(EPropReadOnly);
  CreateInterpreterClassLocal(EPropWriteOnly);
  CreateInterpreterClassLocal(EExternalException);
  CreateInterpreterClassLocal(EAssertionFailed);
  CreateInterpreterClassLocal(EAbstractError);
  CreateInterpreterClassLocal(EIntfCastError);
  CreateInterpreterClassLocal(EInvalidContainer);
  CreateInterpreterClassLocal(EInvalidInsert);
  CreateInterpreterClassLocal(EPackageError);
  CreateInterpreterClassLocal(EWin32Error);

  // Classes

  h:=CreateInterpreterClassLocal(TList);
  CreateInterpreterClassMethodLocal(h,'Create',TList_Create,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Add',TList_Add,ArrPP(['Item: Pointer',varPointer]),nil);
  CreateInterpreterClassMethodLocal(h,'Clear',TList_Clear,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Delete',TList_Delete,ArrPP(['Index: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'Exchange',TList_Exchange,ArrPP(['Index1: Integer',varInteger,'Index2: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'Expand',TList_Expand,nil,PP('TList',varObject));
  CreateInterpreterClassMethodLocal(h,'First',TList_First,nil,PP('Pointer',varPointer));
  CreateInterpreterClassMethodLocal(h,'IndexOf',TList_IndexOf,ArrPP(['Item: Pointer',varPointer]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'Insert',TList_Insert,ArrPP(['Index: Integer',varInteger,'Item: Pointer',varPointer]),nil);
  CreateInterpreterClassMethodLocal(h,'Last',TList_Last,nil,PP('Pointer',varInteger));
  CreateInterpreterClassMethodLocal(h,'Move',TList_Move,ArrPP(['CurIndex: Integer',varInteger,'NewIndex: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'Remove',TList_Remove,ArrPP(['Item: Pointer',varPointer]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'Pack',TList_Pack,nil,nil);

  h:=CreateInterpreterClassLocal(TPersistent);
  CreateInterpreterClassMethodLocal(h,'Assign',TPersistent_Assign,ArrPP(['Source: TPersistent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'GetNamePath',TPersistent_GetNamePath,nil,PP('String',varString));

  h:=CreateInterpreterClassLocal(TCollectionItem);
  CreateInterpreterClassMethodLocal(h,'Create',TCollectionItem_Create,ArrPP(['Collection: TCollection',varObject]),nil);
  CreateInterpreterClassPropertyLocal(h,'Collection',TCollectionItem_Read_Collection,nil,PP('TCollection',varObject),
                                      TCollectionItem_Write_Collection,ArrPP(['Value: TCollection',varObject]));
  CreateInterpreterClassPropertyLocal(h,'ID',TCollectionItem_Read_ID,nil,PP('Integer',varInteger),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'Index',TCollectionItem_Read_Index,nil,PP('Integer',varInteger),
                                      TCollectionItem_Write_Index,ArrPP(['Value: Integer',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'DisplayName',TCollectionItem_Read_DisplayName,nil,PP('String',varString),
                                      TCollectionItem_Write_DisplayName,ArrPP(['Value: String',varString]));

  h:=CreateInterpreterClassLocal(TCollection);
  CreateInterpreterClassMethodLocal(h,'Create',TCollection_Create,ArrPP(['ItemClass: TCollectionItemClass',varClass]),nil);
  CreateInterpreterClassMethodLocal(h,'Add',TCollection_Add,nil,PP('TCollectionItem',varObject));
  CreateInterpreterClassMethodLocal(h,'Assign',TCollection_Assign,ArrPP(['Source: TPersistent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'BeginUpdate',TCollection_BeginUpdate,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Clear',TCollection_Clear,nil,nil);
  CreateInterpreterClassMethodLocal(h,'EndUpdate',TCollection_EndUpdate,nil,nil);
  CreateInterpreterClassMethodLocal(h,'FindItemID',TCollection_FindItemID,ArrPP(['ID: Integer',varInteger]),PP('TCollectionItem',varObject));
  CreateInterpreterClassPropertyLocal(h,'Count',TCollection_Read_Count,nil,PP('Integer',varInteger),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'ItemClass',TCollection_Read_ItemClass,nil,PP('TCollectionItemClass',varClass),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'Items',TCollection_Read_Items,ArrPP(['Index: Integer',varInteger]),PP('TCollectionItem',varObject),
                                      TCollection_Write_Items,ArrPP(['Index: Integer',varInteger,'Value: TCollectionItem',varObject]),true);

  h:=CreateInterpreterClassLocal(TStrings);
  CreateInterpreterClassMethodLocal(h,'Add',TStrings_Add,ArrPP(['const S: string',varString]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'AddObject',TStrings_AddObject,ArrPP(['const S: string',varString,'AObject: TObject',varObject]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'Append',TStrings_Append,ArrPP(['const S: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'AddStrings',TStrings_AddStrings,ArrPP(['Strings: TStrings',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Assign',TStrings_Assign,ArrPP(['Source: TPersistent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'BeginUpdate',TStrings_BeginUpdate,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Clear',TStrings_Clear,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Delete',TStrings_Delete,ArrPP(['Index: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'EndUpdate',TStrings_EndUpdate,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Equals',TStrings_Equals,ArrPP(['Strings: TStrings',varObject]),PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'Exchange',TStrings_Exchange,ArrPP(['Index1: Integer',varInteger,'Index2: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'IndexOf',TStrings_IndexOf,ArrPP(['const S: string',varString]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'IndexOfName',TStrings_IndexOfName,ArrPP(['const Name: string',varString]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'IndexOfObject',TStrings_IndexOfObject,ArrPP(['AObject: TObject',varObject]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'Insert',TStrings_Insert,ArrPP(['Index: Integer',varInteger,'const S: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'InsertObject',TStrings_InsertObject,ArrPP(['Index: Integer',varInteger,'const S: string',varString,'AObject: TObject',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromFile',TStrings_LoadFromFile,ArrPP(['const FileName: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromStream',TStrings_LoadFromStream,ArrPP(['Stream: TStream',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToFile',TStrings_SaveToFile,ArrPP(['const FileName: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToStream',TStrings_SaveToStream,ArrPP(['Stream: TStream',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Move',TStrings_Move,ArrPP(['CurIndex: Integer',varInteger,'NewIndex: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToFile',TStrings_SaveToFile,ArrPP(['const FileName: string',varString]),nil);
  CreateInterpreterClassPropertyLocal(h,'Capacity',TStrings_Read_Capacity,nil,PP('Integer',varInteger),
                                      TStrings_Write_Capacity,ArrPP(['Value: Integer',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'CommaText',TStrings_Read_CommaText,nil,PP('String',varString),
                                      TStrings_Write_CommaText,ArrPP(['Value: string',varString]));
  CreateInterpreterClassPropertyLocal(h,'Count',TStrings_Read_Count,nil,PP('Integer',varInteger),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'Names',TStrings_Read_Names,ArrPP(['Index: Integer',varInteger]),PP('String',varString),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'Values',TStrings_Read_Values,ArrPP(['const Name: string',varString]),PP('String',varString),
                                      TStrings_Write_Values,ArrPP(['const Name: string',varString,'const Value: string',varString]),true);
  CreateInterpreterClassPropertyLocal(h,'Objects',TStrings_Read_Objects,ArrPP(['Index: Integer',varInteger]),PP('TObject',varObject),
                                      TStrings_Write_Objects,ArrPP(['Index: Integer',varInteger,'AObject: TObject',varObject]),true);
  CreateInterpreterClassPropertyLocal(h,'Strings',TStrings_Read_Strings,ArrPP(['Index: Integer',varInteger]),PP('String',varString),
                                      TStrings_Write_Strings,ArrPP(['Index: Integer',varInteger,'const S: string',varString]),true);
  CreateInterpreterClassPropertyLocal(h,'Text',TStrings_Read_Text,nil,PP('String',varString),
                                      TStrings_Write_Text,ArrPP(['Value: string',varString]));

  h:=CreateInterpreterClassLocal(TStringList);
  CreateInterpreterClassMethodLocal(h,'Create',TStringList_Create,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Add',TStringList_Add,ArrPP(['const S: string',varString]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'Clear',TStringList_Clear,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Delete',TStringList_Delete,ArrPP(['Index: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'Exchange',TStringList_Exchange,ArrPP(['Index1: Integer',varInteger,'Index2: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'Find',TStringList_Find,ArrPP(['const S: string',varString,'var Index: Integer',varByRef]),PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'IndexOf',TStringList_IndexOf,ArrPP(['const S: string',varString]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'Insert',TStringList_Insert,ArrPP(['Index: Integer',varInteger,'const S: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'Sort',TStringList_Sort,nil,nil);
  CreateInterpreterClassPropertyLocal(h,'Duplicates',TStringList_Read_Duplicates,nil,PP('TDuplicates',varInteger),
                                      TStringList_Write_Duplicates,ArrPP(['Value: TDuplicates',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'Sorted',TStringList_Read_Sorted,nil,PP('Boolean',varBoolean),
                                      TStringList_Write_Sorted,ArrPP(['Value: Boolean',varBoolean]));

  h:=CreateInterpreterClassLocal(TStream);
  CreateInterpreterClassMethodLocal(h,'Read',TStream_Read,ArrPP(['var Buffer',varByRef,'Count: Longint',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'Write',TStream_Write,ArrPP(['const Buffer',varEmpty,'Count: Longint',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'Seek',TStream_Seek,ArrPP(['Offset: Longint',varInteger,'Origin: Word',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'ReadBuffer',TStream_ReadBuffer,ArrPP(['var Buffer',varByRef,'Count: Longint',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'WriteBuffer',TStream_WriteBuffer,ArrPP(['const Buffer',varEmpty,'Count: Longint',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'CopyFrom',TStream_CopyFrom,ArrPP(['Source: TStream',varObject,'Count: Longint',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'ReadComponent',TStream_ReadComponent,ArrPP(['Instance: TComponent',varObject]),PP('TComponent',varObject));
  CreateInterpreterClassMethodLocal(h,'ReadComponentRes',TStream_ReadComponentRes,ArrPP(['Instance: TComponent',varObject]),PP('TComponent',varObject));
  CreateInterpreterClassMethodLocal(h,'WriteComponent',TStream_WriteComponent,ArrPP(['Instance: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'WriteComponentRes',TStream_WriteComponentRes,ArrPP(['const ResName: string',varString,'Instance: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'WriteDescendent',TStream_WriteDescendent,ArrPP(['Instance: TComponent',varObject,'Ancestor: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'WriteDescendentRes',TStream_WriteDescendentRes,ArrPP(['const ResName: string',varString,'Instance: TComponent',varObject,'Ancestor: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'ReadResHeader',TStream_ReadResHeader,nil,nil);
  CreateInterpreterClassPropertyLocal(h,'Position',TStream_Read_Position,nil,PP('Longint',varInteger),
                                      TStream_Write_Position,ArrPP(['Value: Longint',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'Size',TStream_Read_Size,nil,PP('Longint',varInteger),
                                      TStream_Write_Size,ArrPP(['Value: Longint',varInteger]));

  h:=CreateInterpreterClassLocal(TFileStream);
  CreateInterpreterClassMethodLocal(h,'Create',TFileStream_Create,ArrPP(['FileName: string',varString,'Mode: Word',varInteger]),nil);

  h:=CreateInterpreterClassLocal(TMemoryStream);
  CreateInterpreterClassMethodLocal(h,'Create',TMemoryStream_Create,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Clear',TMemoryStream_Clear,nil,nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromFile',TMemoryStream_LoadFromFile,ArrPP(['const FileName: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToFile',TMemoryStream_SaveToFile,ArrPP(['const FileName: string',varString]),nil);

  h:=CreateInterpreterClassLocal(TStringStream);
  CreateInterpreterClassMethodLocal(h,'Create',TStringStream_Create,ArrPP(['AString: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'Read',TStringStream_Read,ArrPP(['var Buffer',varByRef,'Count: Longint',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'ReadString',TStringStream_ReadString,ArrPP(['Count: Longint',varInteger]),PP('String',varString));
  CreateInterpreterClassMethodLocal(h,'Seek',TStringStream_Seek,ArrPP(['Offset: Longint',varInteger,'Origin: Word',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'Write',TStringStream_Write,ArrPP(['const Buffer',varEmpty,'Count: Longint',varInteger]),PP('Longint',varInteger));
  CreateInterpreterClassMethodLocal(h,'WriteString',TStringStream_WriteString,ArrPP(['const AString: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'DataString',TStringStream_Read_DataString,nil,PP('String',varString));

  h:=CreateInterpreterClassLocal(TComponent);
  CreateInterpreterClassMethodLocal(h,'Create',TComponent_Create,ArrPP(['AOwner: TComponent',varObject]),PP('TComponent',varObject));
  CreateInterpreterClassMethodLocal(h,'DestroyComponents',TComponent_DestroyComponents,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Destroying',TComponent_Destroying,nil,nil);
  CreateInterpreterClassMethodLocal(h,'FindComponent',TComponent_FindComponent,ArrPP(['const AName: string',varString]),PP('TComponent',varObject));
  CreateInterpreterClassMethodLocal(h,'FreeNotification',TComponent_FreeNotification,ArrPP(['AComponent: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'FreeOnRelease',TComponent_FreeOnRelease,nil,nil);
  CreateInterpreterClassMethodLocal(h,'GetParentComponent',TComponent_GetParentComponent,nil,PP('TComponent',varObject));
  CreateInterpreterClassMethodLocal(h,'HasParent',TComponent_HasParent,nil,PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'InsertComponent',TComponent_InsertComponent,ArrPP(['AComponent: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'RemoveComponent',TComponent_RemoveComponent,ArrPP(['AComponent: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'SafeCallException',TComponent_SafeCallException,ArrPP(['ExceptObject: TObject',varObject,'ExceptAddr: Pointer',varPointer]),PP('Integer',varInteger));
  CreateInterpreterClassPropertyLocal(h,'Components',TComponent_Read_Components,ArrPP(['AIndex: Integer',varInteger]),PP('TComponent',varObject),nil,nil,true);
  CreateInterpreterClassPropertyLocal(h,'ComponentCount',TComponent_Read_ComponentCount,nil,PP('Integer',varInteger),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'ComponentIndex',TComponent_Read_ComponentIndex,nil,PP('Integer',varInteger),
                                      TComponent_Write_ComponentIndex,ArrPP(['Value: Integer',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'DesignInfo',TComponent_Read_DesignInfo,nil,PP('Longint',varInteger),
                                      TComponent_Write_DesignInfo,ArrPP(['Value: Longint',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'Owner',TComponent_Read_Owner,nil,PP('TComponent',varObject),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'VCLComObject',TComponent_Read_VCLComObject,nil,PP('Pointer',varPointer),
                                      TComponent_Write_VCLComObject,ArrPP(['Value: Pointer',varPointer]));

  // Controls

  h:=CreateInterpreterClassLocal(TControl);
  CreateInterpreterClassMethodLocal(h,'Create',TControl_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'BringToFront',TControl_BringToFront,nil,nil);
  CreateInterpreterClassMethodLocal(h,'SendToBack',TControl_SendToBack,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Update',TControl_Update,nil,nil);


  h:=CreateInterpreterClassLocal(TWinControl);
  CreateInterpreterClassMethodLocal(h,'SetFocus',TWinControl_SetFocus,nil,nil);
  CreateInterpreterClassLocal(TGraphicControl);
  CreateInterpreterClassLocal(TCustomControl);
  CreateInterpreterClassLocal(TCustomImageList);

  // Graphics

  h:=CreateInterpreterClassLocal(TFont);
  CreateInterpreterClassMethodLocal(h,'Create',TFont_Create,nil,nil);
  CreateInterpreterClassPropertyLocal(h,'Color',TFont_Read_Color,nil,PP('Color',varInteger),TFont_Write_Color,ArrPP(['Value: TColor',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'Name',TFont_Read_Name,nil,PP('Name',varString),TFont_Write_Name,ArrPP(['Value: String',varString]));
  CreateInterpreterClassPropertyLocal(h,'Size',TFont_Read_Size,nil,PP('Size',varInteger),TFont_Write_Size,ArrPP(['Value: Integer',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'Style',TFont_Read_Style,nil,PP('Style',varInteger),TFont_Write_Style,ArrPP(['Value: TFontStyle',varInteger]));

  CreateInterpreterClassLocal(TPen);
  CreateInterpreterClassLocal(TBrush);
  CreateInterpreterClassLocal(TCanvas);
  CreateInterpreterClassLocal(TGraphic);
  CreateInterpreterClassLocal(TPicture);
  CreateInterpreterClassLocal(TMetafile);
  CreateInterpreterClassLocal(TBitmap);
  CreateInterpreterClassLocal(TIcon);

  // Forms

  CreateInterpreterClassLocal(TControlScrollBar);
  CreateInterpreterClassLocal(TScrollingWinControl);
  CreateInterpreterClassLocal(TScrollBox);
  h:=CreateInterpreterClassLocal(TCustomForm);
  CreateInterpreterClassMethodLocal(h,'Close',TCustomForm_Close,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Show',TCustomForm_Show,nil,nil);
  CreateInterpreterClassMethodLocal(h,'ShowModal',TCustomForm_ShowModal,nil,PP('Integer',varInteger));

  h:=CreateInterpreterClassLocal(TForm);
  CreateInterpreterClassMethodLocal(h,'Create',TForm_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'CreateNew',TForm_CreateNew,ArrPP(['AOwner: TComponent',varObject]),nil);

  CreateInterpreterClassLocal(TDataModule);
  h:=CreateInterpreterClassLocal(TScreen);
  CreateInterpreterClassPropertyLocal(h,'Cursor',TScreen_Read_Cursor,nil,PP('TCursor',varInteger),
                                      TScreen_Write_Cursor,ArrPP(['Value: TCursor',varInteger]),false,'������');
  h:=CreateInterpreterClassLocal(TApplication);
  CreateInterpreterClassMethodLocal(h,'ProcessMessages',TApplication_ProcessMessages,nil,nil);

  // Dialogs

  CreateInterpreterClassLocal(TCommonDialog);
  h:=CreateInterpreterClassLocal(TOpenDialog);
  CreateInterpreterClassMethodLocal(h,'Create',TOpenDialog_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Execute',TOpenDialog_Execute,nil,PP('Boolean',varBoolean));
  h:=CreateInterpreterClassLocal(TSaveDialog);
  CreateInterpreterClassMethodLocal(h,'Create',TSaveDialog_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Execute',TSaveDialog_Execute,nil,PP('Boolean',varBoolean));
  h:=CreateInterpreterClassLocal(TColorDialog);
  CreateInterpreterClassMethodLocal(h,'Create',TColorDialog_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Execute',TColorDialog_Execute,nil,PP('Boolean',varBoolean));
  h:=CreateInterpreterClassLocal(TFontDialog);
  CreateInterpreterClassMethodLocal(h,'Create',TFontDialog_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Execute',TFontDialog_Execute,nil,PP('Boolean',varBoolean));
  h:=CreateInterpreterClassLocal(TPrinterSetupDialog);
  CreateInterpreterClassMethodLocal(h,'Create',TPrinterSetupDialog_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Execute',TPrinterSetupDialog_Execute,nil,PP('Boolean',varBoolean));
  h:=CreateInterpreterClassLocal(TPrintDialog);
  CreateInterpreterClassMethodLocal(h,'Create',TPrintDialog_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Execute',TPrintDialog_Execute,nil,PP('Boolean',varBoolean));
  h:=CreateInterpreterClassLocal(TFindDialog);
  CreateInterpreterClassMethodLocal(h,'Create',TFindDialog_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Execute',TFindDialog_Execute,nil,PP('Boolean',varBoolean));
  h:=CreateInterpreterClassLocal(TReplaceDialog);
  CreateInterpreterClassMethodLocal(h,'Create',TReplaceDialog_Create,ArrPP(['AOwner: TComponent',varObject]),nil);

  // ExtCtrls

  CreateInterpreterClassLocal(TShape);
  CreateInterpreterClassLocal(TPaintBox);
  CreateInterpreterClassLocal(TImage);
  CreateInterpreterClassLocal(TBevel);
  CreateInterpreterClassLocal(TTimer);
  CreateInterpreterClassLocal(TPanel);
  CreateInterpreterClassLocal(TPage);
  CreateInterpreterClassLocal(TNotebook);
  CreateInterpreterClassLocal(THeader);
  CreateInterpreterClassLocal(TRadioGroup);
  CreateInterpreterClassLocal(TSplitter);

  // Contnrs

  CreateInterpreterClassLocal(TObjectList);
  CreateInterpreterClassLocal(TComponentList);
  CreateInterpreterClassLocal(TClassList);
  CreateInterpreterClassLocal(TOrderedList);
  CreateInterpreterClassLocal(TObjectStack);
  CreateInterpreterClassLocal(TObjectQueue);

  // ComCtrls

  CreateInterpreterClassLocal(TTabControl);
  CreateInterpreterClassLocal(TTabSheet);
  CreateInterpreterClassLocal(TPageControl);
  CreateInterpreterClassLocal(TStatusPanel);
  CreateInterpreterClassLocal(TStatusPanels);
  CreateInterpreterClassLocal(TStatusBar);
  CreateInterpreterClassLocal(THeaderSection);
  CreateInterpreterClassLocal(THeaderSections);
  CreateInterpreterClassLocal(THeaderControl);
  CreateInterpreterClassLocal(TTreeNode);
  CreateInterpreterClassLocal(TTreeNodes);
  CreateInterpreterClassLocal(TCustomTreeView);
  CreateInterpreterClassLocal(TTreeView);
  CreateInterpreterClassLocal(TTrackBar);
  CreateInterpreterClassLocal(TProgressBar);
  CreateInterpreterClassLocal(TTextAttributes);
  CreateInterpreterClassLocal(TParaAttributes);
  CreateInterpreterClassLocal(TCustomRichEdit);
  CreateInterpreterClassLocal(TRichEdit);
  CreateInterpreterClassLocal(TUpDown);
  CreateInterpreterClassLocal(THotKey);
  CreateInterpreterClassLocal(TListColumn);
  CreateInterpreterClassLocal(TListColumns);
  CreateInterpreterClassLocal(TListItem);
  CreateInterpreterClassLocal(TListItems);
  CreateInterpreterClassLocal(TCustomListView);
  CreateInterpreterClassLocal(TListView);
  CreateInterpreterClassLocal(TAnimate);

  // Grids

  CreateInterpreterClassLocal(TInplaceEdit);
  CreateInterpreterClassLocal(TCustomGrid);
  CreateInterpreterClassLocal(TDrawGrid);
  CreateInterpreterClassLocal(TStringGrid);

  // Menus

  CreateInterpreterClassLocal(TMenuItem);
  CreateInterpreterClassLocal(TMenu);
  CreateInterpreterClassLocal(TMainMenu);
  CreateInterpreterClassLocal(TPopupMenu);

  // StdCtrls

  CreateInterpreterClassLocal(TGroupBox);
  CreateInterpreterClassLocal(TCustomLabel);
  CreateInterpreterClassLocal(TLabel);
  CreateInterpreterClassLocal(TCustomEdit);
  CreateInterpreterClassLocal(TEdit);
  CreateInterpreterClassLocal(TCustomMemo);
  CreateInterpreterClassLocal(TMemo);
  CreateInterpreterClassLocal(TCustomComboBox);
  CreateInterpreterClassLocal(TComboBox);
  CreateInterpreterClassLocal(TButton);
  CreateInterpreterClassLocal(TCustomCheckBox);
  CreateInterpreterClassLocal(TCheckBox);
  CreateInterpreterClassLocal(TRadioButton);
  CreateInterpreterClassLocal(TCustomListBox);
  CreateInterpreterClassLocal(TListBox);
  CreateInterpreterClassLocal(TScrollBar);
  CreateInterpreterClassLocal(TCustomStaticText);
  CreateInterpreterClassLocal(TStaticText);

  // Db

  CreateInterpreterClassLocal(TFieldDef);
  CreateInterpreterClassLocal(TFieldDefs);
  h:=CreateInterpreterClassLocal(TField);
  CreateInterpreterClassPropertyLocal(h,'Value',TField_Read_Value,nil,PP('Variant',varVariant),
                                      TField_Write_Value,ArrPP(['Value: Variant',varVariant]));
  CreateInterpreterClassPropertyLocal(h,'AsString',TField_Read_AsString,nil,PP('String',varString),
                                      TField_Write_AsString,ArrPP(['Value: string',varString]));
  CreateInterpreterClassPropertyLocal(h,'AsBoolean',TField_Read_AsBoolean,nil,PP('Boolean',varBoolean),
                                      TField_Write_AsBoolean,ArrPP(['Value: Boolean',varBoolean]));
  CreateInterpreterClassPropertyLocal(h,'AsCurrency',TField_Read_AsCurrency,nil,PP('Currency',varCurrency),
                                      TField_Write_AsCurrency,ArrPP(['Value: Currency',varCurrency]));
  CreateInterpreterClassPropertyLocal(h,'AsDateTime',TField_Read_AsDateTime,nil,PP('TDateTime',varDate),
                                      TField_Write_AsDateTime,ArrPP(['Value: TDateTime',varDate]));
  CreateInterpreterClassPropertyLocal(h,'AsFloat',TField_Read_AsFloat,nil,PP('Float',varDouble),
                                      TField_Write_AsFloat,ArrPP(['Value: Float',varDouble]));
  CreateInterpreterClassPropertyLocal(h,'AsInteger',TField_Read_AsInteger,nil,PP('Integer',varInteger),
                                      TField_Write_AsInteger,ArrPP(['Value: Integer',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'AsVariant',TField_Read_AsVariant,nil,PP('Variant',varVariant),
                                      TField_Write_AsVariant,ArrPP(['Value: Variant',varVariant]));


  CreateInterpreterClassLocal(TStringField);
  CreateInterpreterClassLocal(TNumericField);
  CreateInterpreterClassLocal(TIntegerField);
  CreateInterpreterClassLocal(TSmallintField);
  CreateInterpreterClassLocal(TWordField);
  CreateInterpreterClassLocal(TAutoIncField);
  CreateInterpreterClassLocal(TFloatField);
  CreateInterpreterClassLocal(TCurrencyField);
  CreateInterpreterClassLocal(TBooleanField);
  CreateInterpreterClassLocal(TDateTimeField);
  CreateInterpreterClassLocal(TDateField);
  CreateInterpreterClassLocal(TTimeField);
  CreateInterpreterClassLocal(TBinaryField);
  CreateInterpreterClassLocal(TBytesField);
  CreateInterpreterClassLocal(TVarBytesField);
  CreateInterpreterClassLocal(TBCDField);

  h:=CreateInterpreterClassLocal(TBlobField);
  CreateInterpreterClassMethodLocal(h,'LoadFromStream',TBlobField_LoadFromStream,ArrPP(['Stream: TStream',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromFile',TBlobField_LoadFromFile,ArrPP(['const FileName: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToStream',TBlobField_SaveToStream,ArrPP(['Stream: TStream',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToFile',TBlobField_SaveToFile,ArrPP(['const FileName: string',varString]),nil);

  CreateInterpreterClassLocal(TMemoField);
  CreateInterpreterClassLocal(TGraphicField);
  CreateInterpreterClassLocal(TIndexDef);
  CreateInterpreterClassLocal(TIndexDefs);
  CreateInterpreterClassLocal(TDataLink);
  CreateInterpreterClassLocal(TDataSource);
  CreateInterpreterClassLocal(TCheckConstraint);
  CreateInterpreterClassLocal(TCheckConstraints);

  h:=CreateInterpreterClassLocal(TParams);
  CreateInterpreterClassMethodLocal(h,'ParamByName',TParams_ParamByName,ArrPP(['const Value: string',varString]),PP('TParam',varObject));

  h:=CreateInterpreterClassLocal(TDataSet);
  CreateInterpreterClassMethodLocal(h,'Append',TDataSet_Append,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Post',TDataSet_Post,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Cancel',TDataSet_Cancel,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Insert',TDataSet_Insert,nil,nil);
  CreateInterpreterClassMethodLocal(h,'First',TDataSet_First,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Next',TDataSet_Next,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Last',TDataSet_Last,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Prior',TDataSet_Prior,nil,nil);
  CreateInterpreterClassMethodLocal(h,'IsEmpty',TDataSet_IsEmpty,nil,PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'FieldByName',TDataSet_FieldByName,ArrPP(['const FieldName: string',varString]),PP('TField',varObject));
  CreateInterpreterClassMethodLocal(h,'Locate',TDataSet_Locate,ArrPP(['const KeyFields: string',varString,'const KeyValues: Variant',varVariant,'Options: TLocateOptions',varSet]),PP('Boolean',varBoolean));
  CreateInterpreterClassPropertyLocal(h,'EOF',TDataSet_Read_EOF,nil,PP('Boolean',varBoolean),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'BOF',TDataSet_Read_BOF,nil,PP('Boolean',varBoolean),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'RecordCount',TDataSet_Read_RecordCount,nil,PP('Integer',varInteger),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'FieldCount',TDataSet_Read_FieldCount,nil,PP('Integer',varInteger),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'Fields',TDataSet_Read_Fields,ArrPP(['Index: Integer',varInteger]),PP('TFields',varObject),nil,nil,true);


  h:=CreateInterpreterClassLocal(TClientDataSet);
  CreateInterpreterClassMethodLocal(h,'CreateDataSet',TClientDataSet_CreateDataSet,nil,nil);
  CreateInterpreterClassMethodLocal(h,'EmptyDataSet',TClientDataSet_EmptyDataSet,nil,nil);
  CreateInterpreterClassMethodLocal(h,'SaveToFile',TClientDataSet_SaveToFile,ArrPP(['const FileName: string',varString,'Format: TDataPacketFormat=dfBinary',varInteger]),nil);

  
  // DbCtrls

  CreateInterpreterClassLocal(TDBEdit);
  CreateInterpreterClassLocal(TDBText);
  CreateInterpreterClassLocal(TDBCheckBox);
  CreateInterpreterClassLocal(TDBComboBox);
  CreateInterpreterClassLocal(TDBListBox);
  CreateInterpreterClassLocal(TDBRadioGroup);
  CreateInterpreterClassLocal(TDBMemo);
  CreateInterpreterClassLocal(TDBImage);
  CreateInterpreterClassLocal(TDBNavigator);
  CreateInterpreterClassLocal(TDBLookupListBox);
  CreateInterpreterClassLocal(TDBLookupComboBox);
  CreateInterpreterClassLocal(TDBRichEdit);

  // DbGrids

  CreateInterpreterClassLocal(TColumnTitle);
  CreateInterpreterClassLocal(TColumn);
  CreateInterpreterClassLocal(TDBGridColumns);
  CreateInterpreterClassLocal(TBookmarkList);
  CreateInterpreterClassLocal(TCustomDBGrid);
  CreateInterpreterClassLocal(TDBGrid);


  // FastReport

  h:=CreateInterpreterClassLocal(TfrReport);
  CreateInterpreterClassMethodLocal(h,'Create',TfrReport_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'GetVariableValue',TfrReport_GetVariableValue,ArrPP(['const s: String',varString,'var v: Variant',varByRef]),nil);
  CreateInterpreterClassMethodLocal(h,'OnGetParsFunction',TfrReport_OnGetParsFunction,
                                    ArrPP(['const name: String',varString,'p1: Variant',varVariant,'p2: Variant',varVariant,
                                           'p3: Variant',varVariant,'var val: Variant',varByRef]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromDB',TfrReport_LoadFromDB,ArrPP(['Table: TDataSet',varObject,'DocN: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToDB',TfrReport_SaveToDB,ArrPP(['Table: TDataSet',varObject,'DocN: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToBlobField',TfrReport_SaveToBlobField,ArrPP(['Blob: TField',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromBlobField',TfrReport_LoadFromBlobField,ArrPP(['Blob: TField',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromResourceName',TfrReport_LoadFromResourceName,ArrPP(['Instance: THandle',varInteger,'const ResName: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromResourceID',TfrReport_LoadFromResourceID,ArrPP(['Instance: THandle',varInteger,'ResID: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadTemplate',TfrReport_LoadTemplate,ArrPP(['fname: String',varString,'comm: TStrings',varObject,'Bmp: TBitmap',varObject,'Load: Boolean',varBoolean]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveTemplate',TfrReport_SaveTemplate,ArrPP(['fname: String',varString,'comm: TStrings',varObject,'Bmp: TBitmap',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadPreparedReport',TfrReport_LoadPreparedReport,ArrPP(['FName: String',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'SavePreparedReport',TfrReport_SavePreparedReport,ArrPP(['FName: String',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'DesignReport',TfrReport_DesignReport,nil,PP('TModalResult',varInteger));
  CreateInterpreterClassMethodLocal(h,'PrepareReport',TfrReport_PrepareReport,nil,PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'ExportTo',TfrReport_ExportTo,ArrPP(['Filter: TfrExportFilter',varObject,'FileName: String',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'ShowReport',TfrReport_ShowReport,nil,nil);
  CreateInterpreterClassMethodLocal(h,'ShowPreparedReport',TfrReport_ShowPreparedReport,nil,nil);
  CreateInterpreterClassMethodLocal(h,'PrintPreparedReportDlg',TfrReport_PrintPreparedReportDlg,nil,nil);
  CreateInterpreterClassMethodLocal(h,'ChangePrinter',TfrReport_ChangePrinter,ArrPP(['OldIndex: Integer',varInteger,'NewIndex: Integer',varInteger]),PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'EditPreparedReport',TfrReport_EditPreparedReport,ArrPP(['PageIndex: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'PrintPreparedReport',TfrReport_PrintPreparedReport,ArrPP(['PageNumbers: String',varString,'Copies: Integer',varInteger,'Collate: Boolean',varBoolean,'PrintPages: TfrPrintPages',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Terminated',TfrReport_Terminated,nil,nil);


  // IB
  h:=CreateInterpreterClassLocal(TIBDatabase);
  CreateInterpreterClassMethodLocal(h,'AddTransaction',TIBDatabase_AddTransaction,ArrPP(['TR: TIBTransaction',varObject]),PP('Integer',varInteger));

  h:=CreateInterpreterClassLocal(TIBTransaction);
  CreateInterpreterClassMethodLocal(h,'AddDatabase',TIBTransaction_AddDatabase,ArrPP(['db: TIBDatabase',varObject]),PP('Integer',varInteger));
  CreateInterpreterClassMethodLocal(h,'Commit',TIBTransaction_Commit,nil,nil);

  h:=CreateInterpreterClassLocal(TIBCustomDataSet);
  CreateInterpreterClassMethodLocal(h,'FetchAll',TIBCustomDataSet_FetchAll,nil,nil);

  h:=CreateInterpreterClassLocal(TIBDataSet);
  CreateInterpreterClassMethodLocal(h,'ExecSQL',TIBDataSet_ExecSQL,nil,nil);

  h:=CreateInterpreterClassLocal(TIBQuery);
  CreateInterpreterClassMethodLocal(h,'ExecSQL',TIBQuery_ExecSQL,nil,nil);

  // CheckListBox

  h:=CreateInterpreterClassLocal(TCheckListBox);
  CreateInterpreterClassPropertyLocal(h,'Checked',TCheckListBox_Read_Checked,ArrPP(['Index: Integer',varInteger]),PP('Boolean',varBoolean),
                                      TCheckListBox_Write_Checked,ArrPP(['Index: Integer',varInteger,'Checked: Boolean',varBoolean]),true);


  // Stbasis

  h:=CreateInterpreterClassLocal(TInterface);
  CreateInterpreterClassMethodLocal(h,'View',TInterface_View,nil,PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'Refresh',TInterface_Refresh,nil,PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'Close',TInterface_Close,nil,PP('Boolean',varBoolean));
  CreateInterpreterClassMethodLocal(h,'ExecProc',TInterface_ExecProc,nil,PP('Boolean',varBoolean));

  // VirtualDbTree

  h:=CreateInterpreterClassLocal(TtsvVirtualDbNode);
  CreateInterpreterClassPropertyLocal(h,'Index',TtsvVirtualDbNode_Read_Index,nil,PP('Cardinal',varInteger),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'ChildCount',TtsvVirtualDbNode_Read_ChildCount,nil,PP('Cardinal',varInteger),nil,nil);
  CreateInterpreterClassPropertyLocal(h,'CheckState',TtsvVirtualDbNode_Read_CheckState,nil,PP('TCheckState',varInteger),
                                                     TtsvVirtualDbNode_Write_CheckState,ArrPP(['Value: TCheckState',varInteger]));
  CreateInterpreterClassPropertyLocal(h,'ID',TtsvVirtualDbNode_Read_GetID,nil,PP('Variant',varVariant),nil,nil);

  h:=CreateInterpreterClassLocal(TtsvVirtualDbTree);
  CreateInterpreterClassMethodLocal(h,'Create',TtsvVirtualDbTree_Create,ArrPP(['AOwner: TComponent',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'GetFirst',TtsvVirtualDbTree_GetFirst,nil,PP('TtsvVirtualDbNode',varObject));
  CreateInterpreterClassMethodLocal(h,'GetNext',TtsvVirtualDbTree_GetNext,ArrPP(['Node: TtsvVirtualDbNode',varObject]),PP('TtsvVirtualDbNode',varObject));
  CreateInterpreterClassPropertyLocal(h,'TotalCount',TtsvVirtualDbTree_Read_TotalCount,nil,PP('Cardinal',varInteger),nil,nil);

  //  XML
  
  h:=CreateInterpreterClassLocal(TtsvXMLDocument);
  CreateInterpreterClassMethodLocal(h,'LoadFromStream',TXMLDocument_LoadFromStream,ArrPP(['Stream: TStream',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'LoadFromFile',TXMLDocument_LoadFromFile,ArrPP(['const FileName: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToStream',TXMLDocument_SaveToStream,ArrPP(['Stream: TStream',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToFile',TXMLDocument_SaveToFile,ArrPP(['const FileName: string',varString]),nil);


  h:=CreateInterpreterClassLocal(TtsvRTFStream);
  CreateInterpreterClassMethodLocal(h,'Create',TtsvRTFStream_Create,nil,nil);
  CreateInterpreterClassMethodLocal(h,'SaveToStream',TtsvRTFStream_SaveToStream,ArrPP(['Stream: TStream',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'SaveToFile',TtsvRTFStream_SaveToFile,ArrPP(['const FileName: String',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'Clear',TtsvRTFStream_Clear,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Open',TtsvRTFStream_Open,nil,nil);
  CreateInterpreterClassMethodLocal(h,'Close',TtsvRTFStream_Close,nil,nil);
  CreateInterpreterClassMethodLocal(h,'CreateString',TtsvRTFStream_CreateString,ArrPP(['S: String',varString,'Font',varObject,'NewLine',varBoolean]),nil);

  // Indy

  h:=CreateInterpreterClassLocal(TIdMultiPartFormDataStream);
  CreateInterpreterClassMethodLocal(h,'Create',TIdMultiPartFormDataStream_Create,nil,PP('TIdMultiPartFormDataStream',varObject));
  CreateInterpreterClassMethodLocal(h,'AddFormField',TIdMultiPartFormDataStream_AddFormField,ArrPP(['AFieldName: string',varString,'AFieldValue: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'AddFile',TIdMultiPartFormDataStream_AddFile,ArrPP(['AFieldName: string',varString,'AFileName: string',varString,'AContentType: string',varString]),nil);
  CreateInterpreterClassMethodLocal(h,'AddStreamAsFile',TIdMultiPartFormDataStream_AddStreamAsFile,ArrPP(['AFieldName: string',varString,'AFileName: string',varString,'AContentType: string',varString,'AStream: TStream',varObject]),nil);

  h:=CreateInterpreterClassLocal(TIdHttp);
  CreateInterpreterClassMethodLocal(h,'Post',TIdHttp_Post,ArrPP(['AURL: string',varString,'Source: TIdMultiPartFormDataStream',varObject]),PP('String',varString));

  // Abbrevia

  h:=CreateInterpreterClassLocal(TAbZipper);
  CreateInterpreterClassMethodLocal(h,'AddFiles',TAbZipper_AddFiles,ArrPP(['FileMask: string',varString,'SearchAttr: Integer',varInteger]),nil);
  CreateInterpreterClassMethodLocal(h,'AddFromStream',TAbZipper_AddFromStream,ArrPP(['NewName: string',varString,'FromStream: TStream',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'AddFromStrings',TAbZipper_AddFromStrings,ArrPP(['Strings: TStrings',varObject]),nil);
  CreateInterpreterClassMethodLocal(h,'Save',TAbZipper_Save,nil,nil);

  // AnyDac
  h:=CreateInterpreterClassLocal(TADQuery);
  CreateInterpreterClassMethodLocal(h,'ExecSQL',TADQuery_ExecSQL,nil,nil);


  _GetDesignPalettes(nil,GetDesignPaletteProc);
end;

procedure ClearListInterpreterFunHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterpreterFunHandles.Count-1 do begin
    _FreeInterpreterFun(THandle(ListInterpreterFunHandles.Items[i]));
  end;
  ListInterpreterFunHandles.Clear;
end;

procedure AddToListInterpreterFunHandles;

   function CreateInterpreterFunLocal(Identifer: PChar;
                                      Proc: TInterpreterReadProc;
                                      ProcParams: TArrOfInterpreterProcParam;
                                      ProcResultType: PInterpreterProcParam;
                                      Hint: PChar=nil): THandle;
   var
     TCIF: TCreateInterpreterFun;
     i: Integer;
   begin
     FillChar(TCIF,SizeOf(TCIF),0);
     TCIF.Identifer:=Identifer;
     TCIF.Proc:=Proc;
     for i:=Low(ProcParams) to High(ProcParams) do begin
      SetLength(TCIF.ProcParams,Length(TCIF.ProcParams)+1);
      TCIF.ProcParams[Length(TCIF.ProcParams)-1].ParamText:=ProcParams[i].ParamText;
      TCIF.ProcParams[Length(TCIF.ProcParams)-1].ParamType:=ProcParams[i].ParamType;
     end;
     if ProcResultType<>nil then
      TCIF.ProcResultType:=ProcResultType^;
     TCIF.Hint:=Hint;
     Result:=_CreateInterpreterFun(@TCIF);
     if Result<>INTERPRETERFUN_INVALID_HANDLE then
      ListInterpreterFunHandles.Add(Pointer(Result));
   end;

begin
  // System

  CreateInterpreterFunLocal('Inc',System_Inc,ArrPP(['var X',varByRef,'N: Longint',varInteger]),nil);
  CreateInterpreterFunLocal('Dec',System_Dec,ArrPP(['var X',varByRef,'N: Longint',varInteger]),nil);
  CreateInterpreterFunLocal('Move',System_Move,ArrPP(['const Source',varUnknown,'var Dest',varUnknown,'Count: Integer',varInteger]),nil);
  CreateInterpreterFunLocal('Random',System_Random,ArrPP(['Range: Integer',varInteger]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('Randomize',System_Randomize,nil,nil);
  CreateInterpreterFunLocal('RandomRange',System_RandomRange,ArrPP(['const AFrom: Integer',varInteger,'const ATo: Integer',varInteger]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('UpCase',System_UpCase,ArrPP(['Ch: Char',varString]),PP('Char',varString));
  CreateInterpreterFunLocal('VarType',System_VarType,ArrPP(['const V: Variant',varVariant]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('VarIsEmpty',System_VarIsEmpty,ArrPP(['const V: Variant',varVariant]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('VarIsNull',System_VarIsNull,ArrPP(['const V: Variant',varVariant]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('VarToStr',System_VarToStr,ArrPP(['const V: Variant',varVariant]),PP('string',varString));
  CreateInterpreterFunLocal('VarFromDateTime',System_VarFromDateTime,ArrPP(['DateTime: TDateTime',varDate]),PP('Variant',varVariant));
  CreateInterpreterFunLocal('VarToDateTime',System_VarToDateTime,ArrPP(['const V: Variant',varVariant]),PP('TDateTime',varDate));
  CreateInterpreterFunLocal('Ord',System_Ord,ArrPP(['const A: Variant',varVariant]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('Chr',System_Chr,ArrPP(['X: Byte',varByte]),PP('Char',varString));
  CreateInterpreterFunLocal('Abs',System_Abs,ArrPP(['X',varUnknown]),PP('',varUnknown));
  CreateInterpreterFunLocal('Length',System_Length,ArrPP(['S',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('Copy',System_Copy,ArrPP(['S',varString,'Index: Integer',varInteger,'Count: Integer',varInteger]),PP('String',varString));
  CreateInterpreterFunLocal('Round',System_Round,ArrPP(['Value: Extended',varDouble]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('Trunc',System_Trunc,ArrPP(['Value: Extended',varDouble]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('Pos',System_Pos,ArrPP(['Substr: string',varString,'S: string',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('Delete',System_Delete,ArrPP(['var S: string',varByRef,'Index: Integer',varInteger,'Count: Integer',varInteger]),nil);
  CreateInterpreterFunLocal('Insert',System_Insert,ArrPP(['Source: string',varString,'var S: string',varByRef,'Index: Integer',varInteger]),nil);
  CreateInterpreterFunLocal('Sqr',System_Sqr,ArrPP(['X: Extended',varDouble]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('Sqrt',System_Sqrt,ArrPP(['X: Extended',varDouble]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('Exp',System_Exp,ArrPP(['X: Extended',varDouble]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('Ln',System_Ln,ArrPP(['X: Extended',varDouble]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('Sin',System_Sin,ArrPP(['X: Extended',varDouble]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('Cos',System_Cos,ArrPP(['X: Extended',varDouble]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('Tan',System_Tan,ArrPP(['X: Extended',varDouble]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('ArcTan',System_ArcTan,ArrPP(['X: Extended',varDouble]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('SetLength',System_SetLength,ArrPP(['var s: ShortString',varByRef,'newLength: Integer',varInteger]),nil);
  CreateInterpreterFunLocal('SizeOf',System_SizeOf,ArrPP(['X',varUnknown]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('Assigned',System_Assigned,ArrPP(['P',varUnknown]),PP('Boolean',varBoolean));

  CreateInterpreterFunLocal('VarArrayCreate',System_VarArrayCreate,ArrPP(['const Bounds: array of Integer',varArray,'VarType: Integer',varInteger]),PP('Variant',varVariant));
  CreateInterpreterFunLocal('VarArrayOf',System_VarArrayOf,ArrPP(['const Values: array of Variant',varArray]),PP('Variant',varVariant));
  CreateInterpreterFunLocal('VarClear',System_VarClear,ArrPP(['var V: Variant',varVariant]),nil);

  // Windows

  CreateInterpreterFunLocal('GetLastError',Windows_GetLastError,nil,PP('DWORD',varInteger));
  CreateInterpreterFunLocal('Sleep',Windows_Sleep,ArrPP(['dwMilliseconds: DWORD',varInteger]),nil);

  // SysUtils
  CreateInterpreterFunLocal('AllocMem',SysUtils_AllocMem,ArrPP(['Size: Cardinal',varInteger]),PP('Pointer',varPointer));
  CreateInterpreterFunLocal('NewStr',SysUtils_NewStr,ArrPP(['const S: string',varString]),PP('PString',varPointer));
  CreateInterpreterFunLocal('DisposeStr',SysUtils_DisposeStr,ArrPP(['P: PString',varPointer]),nil);
  CreateInterpreterFunLocal('AssignStr',SysUtils_AssignStr,ArrPP(['var P: PString',varByRef,'const S: string',varString]),nil);
  CreateInterpreterFunLocal('AppendStr',SysUtils_AppendStr,ArrPP(['var Dest: string',varByRef,'const S: string',varString]),nil);
  CreateInterpreterFunLocal('UpperCase',SysUtils_UpperCase,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('LowerCase',SysUtils_LowerCase,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('CompareStr',SysUtils_CompareStr,ArrPP(['const S1: string',varString,'const S2: string',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('CompareMem',SysUtils_CompareMem,ArrPP(['P1: Pointer',varPointer,'P2: Pointer',varPointer,'Length: Integer',varInteger]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('CompareText',SysUtils_CompareText,ArrPP(['const S1: string',varString,'const S2: string',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('AnsiUpperCase',SysUtils_AnsiUpperCase,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('AnsiLowerCase',SysUtils_AnsiLowerCase,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('AnsiSameText',SysUtils_AnsiSameText,ArrPP(['const S1: string',varString,'const S2: string',varString]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('AnsiCompareStr',SysUtils_AnsiCompareStr,ArrPP(['const S1: string',varString,'const S2: string',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('AnsiCompareText',SysUtils_AnsiCompareText,ArrPP(['const S1: string',varString,'const S2: string',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('AnsiStrComp',SysUtils_AnsiStrComp,ArrPP(['S1: PChar',varString,'S2: PChar',varString]),PP('Integer',varInteger));
{  CreateInterpreterFunLocal('AnsiStrIComp',SysUtils_AnsiStrIComp,ArrPP(['S1: PChar',varString,'S2: PChar',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('AnsiStrLComp',SysUtils_AnsiStrLComp,ArrPP(['S1: PChar',varString,'S2: PChar',varString,'MaxLen: Cardinal',varInteger]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('AnsiStrLIComp',SysUtils_AnsiStrLIComp,ArrPP(['S1: PChar',varString,'S2: PChar',varString,'MaxLen: Cardinal',varInteger]),PP('Integer',varInteger));}
  CreateInterpreterFunLocal('AnsiStrLower',SysUtils_AnsiStrLower,ArrPP(['Str: PChar',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('AnsiStrUpper',SysUtils_AnsiStrUpper,ArrPP(['Str: PChar',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('AnsiLastChar',SysUtils_AnsiLastChar,ArrPP(['const S: string',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('AnsiStrLastChar',SysUtils_AnsiStrLastChar,ArrPP(['P: PChar',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('Trim',SysUtils_Trim,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('TrimLeft',SysUtils_TrimLeft,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('TrimRight',SysUtils_TrimRight,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('QuotedStr',SysUtils_QuotedStr,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('AnsiQuotedStr',SysUtils_AnsiQuotedStr,ArrPP(['const S: string',varString,'Quote: Char',varString]),PP('string',varString));
  CreateInterpreterFunLocal('AnsiExtractQuotedStr',SysUtils_AnsiExtractQuotedStr,ArrPP(['var Src: PChar',varByRef,'Quote: Char',varString]),PP('string',varString));
  CreateInterpreterFunLocal('AdjustLineBreaks',SysUtils_AdjustLineBreaks,ArrPP(['const S: string',varString]),PP('string',varString));
  CreateInterpreterFunLocal('IsValidIdent',SysUtils_IsValidIdent,ArrPP(['const Ident: string',varString]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('IntToStr',SysUtils_IntToStr,ArrPP(['Value: Integer',varInteger]),PP('string',varString));
  CreateInterpreterFunLocal('IntToHex',SysUtils_IntToHex,ArrPP(['Value: Integer',varInteger,'Digits: Integer',varInteger]),PP('string',varString));
  CreateInterpreterFunLocal('StrToInt',SysUtils_StrToInt,ArrPP(['const S: string',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('StrToIntDef',SysUtils_StrToIntDef,ArrPP(['const S: string',varString,'Default: Integer',varInteger]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('TryStrToInt',SysUtils_TryStrToInt,ArrPP(['const S: string',varString,'out Value: Integer',varByRef]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('TryStrToDate',SysUtils_TryStrToDate,ArrPP(['const S: string',varString,'out Value: TDateTime',varByRef]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('LoadStr',SysUtils_LoadStr,ArrPP(['Ident: Integer',varInteger]),PP('string',varString));
  CreateInterpreterFunLocal('StrLen',SysUtils_StrLen,ArrPP(['Str: PChar',varString]),PP('Cardinal',varInteger));
  CreateInterpreterFunLocal('StrEnd',SysUtils_StrEnd,ArrPP(['Str: PChar',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrMove',SysUtils_StrMove,ArrPP(['Dest: PChar',varString,'Source',varString,'Count: Cardinal',varInteger]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrCopy',SysUtils_StrCopy,ArrPP(['Dest: PChar',varString,'Source',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrCat',SysUtils_StrCat,ArrPP(['Dest: PChar',varString,'Source',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrComp',SysUtils_StrComp,ArrPP(['Str1: PChar',varString,'Str2',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('StrScan',SysUtils_StrScan,ArrPP(['Str: PChar',varString,'Chr: Char',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrPos',SysUtils_StrPos,ArrPP(['Str1: PChar',varString,'Str2',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrUpper',SysUtils_StrUpper,ArrPP(['Str: PChar',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrLower',SysUtils_StrLower,ArrPP(['Str: PChar',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrAlloc',SysUtils_StrAlloc,ArrPP(['Size: Cardinal',varInteger]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrBufSize',SysUtils_StrBufSize,ArrPP(['Str: PChar',varString]),PP('Cardinal',varInteger));
  CreateInterpreterFunLocal('StrNew',SysUtils_StrNew,ArrPP(['Str: PChar',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('StrDispose',SysUtils_StrDispose,ArrPP(['Str: PChar',varString]),nil);
  CreateInterpreterFunLocal('FloatToStr',SysUtils_FloatToStr,ArrPP(['Value: Extended',varDouble]),PP('string',varString));
  CreateInterpreterFunLocal('CurrToStr',SysUtils_CurrToStr,ArrPP(['Value: Currency',varCurrency]),PP('string',varString));
  CreateInterpreterFunLocal('StrToFloat',SysUtils_StrToFloat,ArrPP(['const S: string',varString]),PP('Extended',varDouble));
  CreateInterpreterFunLocal('StrToCurr',SysUtils_StrToCurr,ArrPP(['const S: string',varString]),PP('Currency',varCurrency));
  CreateInterpreterFunLocal('EncodeDate',SysUtils_EncodeDate,ArrPP(['Year: Word',varInteger,'Month: Word',varInteger,'Day: Word',varInteger]),PP('TDateTime',varDate));
  CreateInterpreterFunLocal('EncodeTime',SysUtils_EncodeTime,ArrPP(['Hour: Word',varInteger,'Min: Word',varInteger,'Sec: Word',varInteger,'MSec: Word',varInteger]),PP('TDateTime',varDate));
  CreateInterpreterFunLocal('DecodeDate',SysUtils_DecodeDate,ArrPP(['Date: TDateTime',varDate,'Year: Word',varByRef,'Month: Word',varByref,'Day: Word',varByRef]),nil);
  CreateInterpreterFunLocal('DecodeTime',SysUtils_DecodeTime,ArrPP(['Time: TDateTime',varDate,'Hour: Word',varByRef,'Min: Word',varByref,'Sec: Word',varByRef,'MSec: Word',varByRef]),nil);
  CreateInterpreterFunLocal('DayOfWeek',SysUtils_DayOfWeek,ArrPP(['Date: TDateTime',varDate]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('Date',SysUtils_Date,nil,PP('TDateTime',varDate));
  CreateInterpreterFunLocal('Time',SysUtils_Time,nil,PP('TDateTime',varDate));
  CreateInterpreterFunLocal('Now',SysUtils_Now,nil,PP('TDateTime',varDate));
  CreateInterpreterFunLocal('IncMonth',SysUtils_IncMonth,ArrPP(['const Date: TDateTime',varDate,'NumberOfMonths: Integer',varInteger]),PP('TDateTime',varDate));
  CreateInterpreterFunLocal('IsLeapYear',SysUtils_IsLeapYear,ArrPP(['Year: Word',varInteger]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('DateToStr',SysUtils_DateToStr,ArrPP(['Date: TDateTime',varDate]),PP('string',varString));
  CreateInterpreterFunLocal('TimeToStr',SysUtils_TimeToStr,ArrPP(['Time: TDateTime',varDate]),PP('string',varString));
  CreateInterpreterFunLocal('DateTimeToStr',SysUtils_DateTimeToStr,ArrPP(['DateTime: TDateTime',varDate]),PP('string',varString));
  CreateInterpreterFunLocal('StrToDate',SysUtils_StrToDate,ArrPP(['const S: string',varString]),PP('TDateTime',varDate));
  CreateInterpreterFunLocal('StrToTime',SysUtils_StrToTime,ArrPP(['const S: string',varString]),PP('TDateTime',varDate));
  CreateInterpreterFunLocal('StrToDateTime',SysUtils_StrToDateTime,ArrPP(['const S: string',varString]),PP('TDateTime',varDate));
  CreateInterpreterFunLocal('FormatDateTime',SysUtils_FormatDateTime,ArrPP(['const Format: string',varString,'DateTime: TDateTime',varString]),PP('string',varString));
  CreateInterpreterFunLocal('DateTimeToString',SysUtils_DateTimeToString,ArrPP(['var Result: string',varByref,'const Format: string',varString,'DateTime: TDateTime',varDate]),nil);
  CreateInterpreterFunLocal('SysErrorMessage',SysUtils_SysErrorMessage,ArrPP(['ErrorCode: Integer',varInteger]),PP('string',varString));
  CreateInterpreterFunLocal('ShowException',SysUtils_ShowException,ArrPP(['ExceptObject: TObject',varObject,'ExceptAddr: Pointer',varPointer]),nil);
  CreateInterpreterFunLocal('Abort',SysUtils_Abort,nil,nil);
  CreateInterpreterFunLocal('OutOfMemoryError',SysUtils_OutOfMemoryError,nil,nil);
  CreateInterpreterFunLocal('Beep',SysUtils_Beep,nil,nil);
  CreateInterpreterFunLocal('AnsiPos',SysUtils_AnsiPos,ArrPP(['const Substr: string',varString,'const S: string',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('AnsiStrPos',SysUtils_AnsiStrPos,ArrPP(['Str: PChar',varString,'SubStr: PChar',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('AnsiStrScan',SysUtils_AnsiStrScan,ArrPP(['Str: PChar',varString,'Chr: Char',varString]),PP('PChar',varString));
  CreateInterpreterFunLocal('RaiseLastWin32Error',SysUtils_RaiseLastWin32Error,nil,nil);
  CreateInterpreterFunLocal('Win32Check',SysUtils_Win32Check,ArrPP(['RetVal: BOOL',varBoolean]),PP('BOOL',varBoolean));
  CreateInterpreterFunLocal('ExtractFileName',SysUtils_ExtractFileName,ArrPP(['const FileName: string',varString]),PP('String',varString));
  CreateInterpreterFunLocal('ExtractFileExt',SysUtils_ExtractFileExt,ArrPP(['const FileName: string',varString]),PP('String',varString));
  CreateInterpreterFunLocal('ChangeFileExt',SysUtils_ChangeFileExt,ArrPP(['const FileName: string',varString,'const Extension: string',varString]),PP('String',varString));
  CreateInterpreterFunLocal('DeleteFile',SysUtils_DeleteFile,ArrPP(['const FileName: string',varString]),PP('Boolean',varBoolean));
  CreateInterpreterFunLocal('RenameFile',SysUtils_RenameFile,ArrPP(['const OldName: string',varString,'const NewName: string',varString]),PP('Boolean',varBoolean));

  // Dialogs

  CreateInterpreterFunLocal('CreateMessageDialog',Dialogs_CreateMessageDialog,ArrPP(['const Msg: string',varString,'DlgType: TMsgDlgType',varInteger,'Buttons: TMsgDlgButtons',varSet]),PP('TForm',varObject));
  CreateInterpreterFunLocal('MessageDlg',Dialogs_MessageDlg,ArrPP(['const Msg: string',varString,'DlgType: TMsgDlgType',varInteger,'Buttons: TMsgDlgButtons',varSet,'HelpCtx: Longint',varInteger]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('MessageDlg',Dialogs_MessageDlgPos,ArrPP(['const Msg: string',varString,'DlgType: TMsgDlgType',varInteger,'Buttons: TMsgDlgButtons',varSet,'HelpCtx: Longint',varInteger,'X: Integer',varInteger,'Y: Integer',varInteger]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('MessageDlgPosHelp',Dialogs_MessageDlgPosHelp,ArrPP(['const Msg: string',varString,'DlgType: TMsgDlgType',varInteger,'Buttons: TMsgDlgButtons',varSet,'HelpCtx: Longint',varInteger,'X: Integer',varInteger,'Y: Integer',varInteger,'const HelpFileName: string',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('ShowMessage',Dialogs_ShowMessage,ArrPP(['const Msg: string',varString]),nil);
  CreateInterpreterFunLocal('ShowMessagePos',Dialogs_ShowMessagePos,ArrPP(['const Msg: string',varString,'X: Integer',varInteger,'Y: Integer',varInteger]),nil);
  CreateInterpreterFunLocal('InputBox',Dialogs_InputBox,ArrPP(['const ACaption: string',varString,'const APrompt: string',varString,'const ADefault: string',varString]),PP('String',varString));
  CreateInterpreterFunLocal('InputQuery',Dialogs_InputQuery,ArrPP(['const ACaption: string',varString,'const APrompt: string',varString,'var Value: string',varByRef]),PP('String',varBoolean));


  // ComObj

  CreateInterpreterFunLocal('CreateOleObject',ComObj_CreateOleObject,ArrPP(['const ClassName: string',varString]),PP('Variant',varVariant));
  CreateInterpreterFunLocal('GetActiveOleObject',ComObj_GetActiveOleObject,ArrPP(['const ClassName: string',varString]),PP('Variant',varVariant));
  CreateInterpreterFunLocal('OleError',ComObj_OleError,ArrPP(['ErrorCode: HResult',varInteger]),nil);
  CreateInterpreterFunLocal('OleCheck',ComObj_OleCheck,ArrPP(['Result: HResult',varInteger]),nil);

  // Stbasis

  CreateInterpreterFunLocal('ShowErrorEx',stbasis_ShowErrorEx,ArrPP(['Mess: String',varString]),PP('Integer',varInteger),'������� ������� ��������� �� ������');
  CreateInterpreterFunLocal('ShowErrorTest1',stbasis_ShowErrorEx,ArrPP(['Mess: String',varString]),PP('Integer',varInteger),'������� ������� ��������� �� ������');
  CreateInterpreterFunLocal('ShowWarningEx',stbasis_ShowWarningEx,ArrPP(['Mess: String',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('ShowInfoEx',stbasis_ShowInfoEx,ArrPP(['Mess: String',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('ShowQuestionEx',stbasis_ShowQuestionEx,ArrPP(['Mess: String',varString]),PP('Integer',varInteger));
  CreateInterpreterFunLocal('DeleteWarningEx',stbasis_DeleteWarningEx,ArrPP(['Mess: String',varString]),PP('Integer',varInteger));

  CreateInterpreterFunLocal('CreateLogItem',stbasis_CreateLogItem,ArrPP(['Text: String',varString,'TypeLogItem: TTypeLogItem',varInteger]),nil);
  CreateInterpreterFunLocal('SetSplashStatus',stbasis_SetSplashStatus,ArrPP(['Status: String',varString]),nil);

  CreateInterpreterFunLocal('CreateProgressBar',stbasis_CreateProgressBar,ArrPP(['Min: Integer',varInteger,'Max: Integer',varInteger,'Hint: String',varString,'Color: TColor',varInteger]),PP('THandle',varInteger),'������� �������� ��������-����');
  CreateInterpreterFunLocal('FreeProgressBar',stbasis_FreeProgressBar,ArrPP(['ProgressBarHandle: THandle',varInteger]),PP('Boolean',varBoolean),'������� ����������� ��������-����');
  CreateInterpreterFunLocal('SetProgressBarStatus',stbasis_SetProgressBarStatus,ArrPP(['ProgressBarHandle: THandle',varInteger,'Progress: Integer',varInteger,'Max: Integer',varInteger,'Hint: String',varString]),nil,'��������� ������� ���������� ��������-����');

  CreateInterpreterFunLocal('Iff',stbasis_Iff,ArrPP(['isTrue: Boolean',varBoolean,'TrueValue: Variant',varVariant,'FalseValue: Variant',varVariant]),PP('Variant',varVariant));
  CreateInterpreterFunLocal('RepeatStr',stbasis_RepeatStr,ArrPP(['const S: String',varString,'const Count: Integer',varInteger]),PP('String',varString));
  CreateInterpreterFunLocal('StrBetween',stbasis_StrBetween,ArrPP(['InStr: String',varString,'S1: String',varString,'S2: String',varString]),PP('String',varString));

  CreateInterpreterFunLocal('isExistsParam',stbasis_isExistsParam,ArrPP(['Section: string',varString,'Param: string',varString]),PP('Boolean',varBoolean),'������� �������� ���������');
  CreateInterpreterFunLocal('WriteParam',stbasis_WriteParam,ArrPP(['const Section: string',varString,'Param: string',varString,'Value: Variant',varVariant]),nil,'��������� ������ ���������');
  CreateInterpreterFunLocal('ReadParam',stbasis_ReadParam,ArrPP(['const Section: string',varString,'Param: string',varString,'Default: Variant',varVariant]),PP('Variant',varVariant),'������� ������ ���������');
  CreateInterpreterFunLocal('ClearParams',stbasis_ClearParams,nil,nil,'��������� ������� ���� ����������');
  CreateInterpreterFunLocal('SaveParams',stbasis_SaveParams,nil,nil,'��������� ������ ���� ���������� � ����');
  CreateInterpreterFunLocal('EraseParams',stbasis_EraseParams,ArrPP(['const Section: string',varString]),PP('Boolean',varBoolean),'������� �������� ������ ����������');

  CreateInterpreterFunLocal('GetDateTimeFromServer',stbasis_GetDateTimeFromServer,nil,PP('TDateTime',varDate),'������� ��������� ���� � ������� � �������');
  CreateInterpreterFunLocal('ViewEnterPeriod',stbasis_ViewEnterPeriod,ArrPP(['var DateBegin: TDateTime',varByRef,'var DateEnd: TDateTime',varByRef,'TypePeriod: TTypeEnterPeriod',varInteger,'LoadAndSave: Boolean',varBoolean]),PP('Boolean',varBoolean),'������� ��������� ���� � ���� ������ �������');
  CreateInterpreterFunLocal('GetGenId',stbasis_GetGenId,ArrPP(['DB: TIBDatabase',varObject,'TableName: String',varString,'Increment: Integer',varInteger]),PP('Integer',varInteger),'������� ��������� ����������� ��');
  CreateInterpreterFunLocal('GetUserId',stbasis_GetUserId,nil,PP('Integer',varInteger),'������� ��������� �� �������� ������������');
  CreateInterpreterFunLocal('GetUniqueId',stbasis_GetUniqueId,nil,PP('String',varString),'������� ��������� ����������� ��');
  CreateInterpreterFunLocal('ChangeString',stbasis_ChangeString,ArrPP(['S: string',varString,'Old: string',varString,'New: string',varString]),PP('String',varString),'������� ������ ��������� � ������');
  CreateInterpreterFunLocal('FillWordsByString',stbasis_FillWordsByString,ArrPP(['S: string',varString,'Str: TStringList',varObject]),nil,'������� ���������� ���� �� ������');
  CreateInterpreterFunLocal('GetTempDir',stbasis_GetTempDir,nil,PP('String',varString),'������� ��������� ��������� ����������');
  CreateInterpreterFunLocal('ExecSQL',stbasis_ExecSql,ArrPP(['DB: TIBDatabase',varObject,'SQL: String',varString]),nil,'������� ���������� �������� � ������������ ��');
  CreateInterpreterFunLocal('CopyFile',stbasis_CopyFile,ArrPP(['const FromFileName: string',varString,'const ToFileName: string',varString]),PP('Boolean',varBoolean));

end;

procedure ClearListInterpreterEventHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterpreterEventHandles.Count-1 do begin
    _FreeInterpreterEvent(THandle(ListInterpreterEventHandles.Items[i]));
  end;
  ListInterpreterEventHandles.Clear;
end;

procedure AddToListInterpreterEventHandles;

   function CreateInterpreterEventLocal(Identifer: PChar;
                                        EventClass: TEventClass;
                                        EventProc: Pointer;
                                        Hint: PChar=nil): THandle;
   var
     TGIE: TCreateInterpreterEvent;
   begin
     FillChar(TGIE,SizeOf(TGIE),0);
     TGIE.Identifer:=Identifer;
     TGIE.EventClass:=EventClass;
     TGIE.EventProc:=EventProc;
     TGIE.Hint:=Hint;
     Result:=_CreateInterpreterEvent(@TGIE);
     if Result<>INTERPRETEREVENT_INVALID_HANDLE then
      ListInterpreterEventHandles.Add(Pointer(Result));
   end;

begin
  // Classes

  CreateInterpreterEventLocal('TNotifyEvent',TClassesEvent,@TClassesEvent.NotifyEvent);
  CreateInterpreterEventLocal('THelpEvent',TClassesEvent,@TClassesEvent.HelpEvent);

  // Controls

  CreateInterpreterEventLocal('TMouseEvent', TControlsEvent, @TControlsEvent.MouseEvent);
  CreateInterpreterEventLocal('TMouseMoveEvent', TControlsEvent, @TControlsEvent.MouseMoveEvent);
  CreateInterpreterEventLocal('TKeyEvent', TControlsEvent, @TControlsEvent.KeyEvent);
  CreateInterpreterEventLocal('TKeyPressEvent', TControlsEvent, @TControlsEvent.KeyPressEvent);
  CreateInterpreterEventLocal('TDragOverEvent', TControlsEvent, @TControlsEvent.DragOverEvent);
  CreateInterpreterEventLocal('TDragDropEvent', TControlsEvent, @TControlsEvent.DragDropEvent);
  CreateInterpreterEventLocal('TStartDragEvent', TControlsEvent, @TControlsEvent.StartDragEvent);
  CreateInterpreterEventLocal('TEndDragEvent', TControlsEvent, @TControlsEvent.EndDragEvent);
  CreateInterpreterEventLocal('TDockDropEvent', TControlsEvent, @TControlsEvent.DockDropEvent);
  CreateInterpreterEventLocal('TDockOverEvent', TControlsEvent, @TControlsEvent.DockOverEvent);
  CreateInterpreterEventLocal('TUnDockEvent', TControlsEvent, @TControlsEvent.UnDockEvent);
  CreateInterpreterEventLocal('TStartDockEvent', TControlsEvent, @TControlsEvent.StartDockEvent);
  CreateInterpreterEventLocal('TCanResizeEvent', TControlsEvent, @TControlsEvent.CanResizeEvent);
  CreateInterpreterEventLocal('TConstrainedResizeEvent', TControlsEvent, @TControlsEvent.ConstrainedResizeEvent);

  // Forms

  CreateInterpreterEventLocal('TCloseEvent', TFormsEvent, @TFormsEvent.CloseEvent);
  CreateInterpreterEventLocal('TCloseQueryEvent', TFormsEvent, @TFormsEvent.CloseQueryEvent);
  CreateInterpreterEventLocal('TExceptionEvent', TFormsEvent, @TFormsEvent.ExceptionEvent);
  CreateInterpreterEventLocal('TIdleEvent', TFormsEvent, @TFormsEvent.IdleEvent);

  // FastReport

 // CreateInterpreterEventLocal('TProgressEvent', TFastReportsEvent, @TFastReportsEvent.ProgressEvent);
  CreateInterpreterEventLocal('TDetailEvent', TFastReportsEvent, @TFastReportsEvent.DetailEvent);

  // VirtualDbTree
  CreateInterpreterEventLocal('TtsvVirtualNodeOnGetImageIndexEvent', TtsvVirtualDbTreesEvent, @TtsvVirtualDbTreesEvent.GetImageIndexEvent);

end;

procedure ClearListInterpreterVarHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterpreterVarHandles.Count-1 do begin
    _FreeInterpreterVar(THandle(ListInterpreterVarHandles.Items[i]));
  end;
  ListInterpreterVarHandles.Clear;
end;

procedure AddToListInterpreterVarHandles;

   function CreateInterpreterVarLocal(Identifer: PChar; Value: Variant; TypeValue: Variant;
                                      TypeText: PChar=nil; Hint: PChar=nil; TypeCreate: TTypeCreate=tcFirst): THandle;
   var
     TCIV: TCreateInterpreterVar;
   begin
     FillChar(TCIV,SizeOf(TCreateInterpreterVar),0);
     TCIV.Identifer:=Identifer;
     TCIV.Value:=Value;
     TCIV.TypeValue:=TypeValue;
     TCIV.TypeText:=TypeText;
     TCIV.Hint:=Hint;
     TCIV.TypeCreate:=TypeCreate; 
     Result:=_CreateInterpreterVar(@TCIV);
     if Result<>INTERPRETERVAR_INVALID_HANDLE then
      ListInterpreterVarHandles.Add(Pointer(Result));
   end;
   
begin
  // Forms
  CreateInterpreterVarLocal(ConstApplicationName,O2V(Application),C2V(TApplication),'TApplication','����������');
  CreateInterpreterVarLocal(ConstScreenName,O2V(Screen),C2V(TScreen),'TScreen','�����');

  // StBasis
  CreateInterpreterVarLocal(ConstMainDataBaseName,O2V(IBDB),C2V(TIBDatabase),'TIBDatabase','������� ���� ������');
  CreateInterpreterVarLocal(ConstMainTransactionName,O2V(IBT),C2V(TIBTransaction),'TIBTransaction','������� ����������');

end;

procedure ForcedNotification(AForm: TCustomForm; APersistent: TPersistent; Operation: TOperation);stdcall;
begin
  if fmMenuEditor<>nil then fmMenuEditor.ForcedNotification(AForm,APersistent,Operation);
  if fmTreeEditor<>nil then fmTreeEditor.ForcedNotification(AForm,APersistent,Operation);
  if fmCollectionEditor<>nil then fmCollectionEditor.ForcedNotification(AForm,APersistent,Operation);
  if fmListEditor<>nil then fmListEditor.ForcedNotification(AForm,APersistent,Operation);
end;

//********************* end of Internal *****************


//********************* Export *************************

procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
begin
  if not isValidPointer(P) then exit;
  P.Hint:=LibraryHint;
  P.TypeLib:=MainTypeLib;
  P.Programmers:=LibraryProgrammers;

  FSecurity.LoadDb;
  P.StopLoad:=not FSecurity.Check([sctInclination,sctRunCount]);
  P.Condition:=PChar(FSecurity.Condition);
  FSecurity.DecRunCount;
  FSecurity.SaveDb;
end;

procedure GetInfoComponentsLibrary_(P: PInfoComponentsLibrary);stdcall;
begin
  if not isValidPointer(P) then exit;
  P.ForcedNotification:=ForcedNotification;
end;

procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
  IBDB:=IBDbase;
  IBT:=IBTran;
  IBDBSec:=IBDBSecurity;
end;

procedure RefreshLibrary_;stdcall;
begin
 try
  Screen.Cursor:=crHourGlass;
  try

    ClearListInterpreterVarHandles;
    AddToListInterpreterVarHandles;

    ClearListInterpreterEventHandles;
    AddToListInterpreterEventHandles;

    ClearListInterpreterFunHandles;
    AddToListInterpreterFunHandles;

    ClearListInterpreterClassHandles;
    AddToListInterpreterClassHandles;

    ClearListInterpreterConstHandles;
    AddToListInterpreterConstHandles;

    ClearListDesignPaletteHandles;
    AddToListDesignPaletteHandles;

    ClearListDesignPropertyTranslateHandles;
    AddToListDesignPropertyTranslateHandles;

    ClearListDesignPropertyRemoveHandles;
    AddToListDesignPropertyRemoveHandles;

    ClearListDesignPropertyEditorHandles;
    AddToListDesignPropertyEditorHandles;

    ClearListDesignComponentEditorHandles;
    AddToListDesignComponentEditorHandles;

    ClearListDesignCodeTemplateHandles;
    AddToListDesignCodeTemplateHandles;

    ClearListDesignFormTemplateHandles;
    AddToListDesignFormTemplateHandles;

  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//**************** end of Export *************************

end.

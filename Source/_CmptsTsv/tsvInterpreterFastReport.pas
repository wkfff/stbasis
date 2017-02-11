unit tsvInterpreterFastReport;

interface

uses UMainUnited, tsvInterpreterCore;

type
  TFastReportsEvent = class(TEvent)
  public
    procedure ProgressEvent(n: Integer);
    procedure DetailEvent(const ParName: String; var ParValue: Variant);

  end;

 { TfrObject }
procedure TfrObject_Create(var Value: Variant; Args: TArguments);
procedure TfrObject_Read_Prop(var Value: Variant; Args: TArguments);
procedure TfrObject_Write_Prop(const Value: Variant; Args: TArguments);

  { TfrControl }
procedure TfrControl_Create(var Value: Variant; Args: TArguments);
procedure TfrControl_Read_Control(var Value: Variant; Args: TArguments);

  { TfrNonVisualControl }
procedure TfrNonVisualControl_Create(var Value: Variant; Args: TArguments);

  { TfrMemoView }
procedure TfrMemoView_Create(var Value: Variant; Args: TArguments);
procedure TfrMemoView_Read_Font(var Value: Variant; Args: TArguments);
procedure TfrMemoView_Write_Font(const Value: Variant; Args: TArguments);

  { TfrBandView }
procedure TfrBandView_Create(var Value: Variant; Args: TArguments);
procedure TfrBandView_GetClipRgn(var Value: Variant; Args: TArguments);
procedure TfrBandView_Read_BandType(var Value: Variant; Args: TArguments);
procedure TfrBandView_Write_BandType(const Value: Variant; Args: TArguments);
procedure TfrBandView_Read_DataSet(var Value: Variant; Args: TArguments);
procedure TfrBandView_Write_DataSet(const Value: Variant; Args: TArguments);
procedure TfrBandView_Read_GroupCondition(var Value: Variant; Args: TArguments);
procedure TfrBandView_Write_GroupCondition(const Value: Variant; Args: TArguments);

  { TfrSubReportView }
procedure TfrSubReportView_Create(var Value: Variant; Args: TArguments);

  { TfrPictureView }
procedure TfrPictureView_Create(var Value: Variant; Args: TArguments);

  { TfrLineView }
procedure TfrLineView_Create(var Value: Variant; Args: TArguments);
procedure TfrLineView_GetClipRgn(var Value: Variant; Args: TArguments);

  { TfrBand }
procedure TfrBand_Create(var Value: Variant; Args: TArguments);

  { TfrPage }
procedure TfrPage_Create(var Value: Variant; Args: TArguments);
procedure TfrPage_ChangePaper(var Value: Variant; Args: TArguments);
procedure TfrPage_ShowBandByType(var Value: Variant; Args: TArguments);

  { TfrPages }
procedure TfrPages_Create(var Value: Variant; Args: TArguments);
procedure TfrPages_Read_Pages(var Value: Variant; Args: TArguments);
procedure TfrPages_Read_Count(var Value: Variant; Args: TArguments);

  { TfrEMFPages }
procedure TfrEMFPages_Create(var Value: Variant; Args: TArguments);
procedure TfrEMFPages_Read_Count(var Value: Variant; Args: TArguments);

  { TfrDataDictionary }
procedure TfrDataDictionary_Create(var Value: Variant; Args: TArguments);
procedure TfrDataDictionary_Read_Value(var Value: Variant; Args: TArguments);
procedure TfrDataDictionary_Read_RealDataSetName(var Value: Variant; Args: TArguments);
procedure TfrDataDictionary_Read_RealDataSourceName(var Value: Variant; Args: TArguments);
procedure TfrDataDictionary_Read_RealFieldName(var Value: Variant; Args: TArguments);
procedure TfrDataDictionary_Read_AliasName(var Value: Variant; Args: TArguments);

  { TfrReport }
procedure TfrReport_Create(var Value: Variant; Args: TArguments);
procedure TfrReport_GetVariableValue(var Value: Variant; Args: TArguments);
procedure TfrReport_OnGetParsFunction(var Value: Variant; Args: TArguments);
procedure TfrReport_LoadFromDB(var Value: Variant; Args: TArguments);
procedure TfrReport_SaveToDB(var Value: Variant; Args: TArguments);
procedure TfrReport_SaveToBlobField(var Value: Variant; Args: TArguments);
procedure TfrReport_LoadFromBlobField(var Value: Variant; Args: TArguments);
procedure TfrReport_LoadFromResourceName(var Value: Variant; Args: TArguments);
procedure TfrReport_LoadFromResourceID(var Value: Variant; Args: TArguments);
procedure TfrReport_LoadTemplate(var Value: Variant; Args: TArguments);
procedure TfrReport_SaveTemplate(var Value: Variant; Args: TArguments);
procedure TfrReport_LoadPreparedReport(var Value: Variant; Args: TArguments);
procedure TfrReport_SavePreparedReport(var Value: Variant; Args: TArguments);
procedure TfrReport_DesignReport(var Value: Variant; Args: TArguments);
procedure TfrReport_PrepareReport(var Value: Variant; Args: TArguments);
procedure TfrReport_ExportTo(var Value: Variant; Args: TArguments);
procedure TfrReport_ShowReport(var Value: Variant; Args: TArguments);
procedure TfrReport_ShowPreparedReport(var Value: Variant; Args: TArguments);
procedure TfrReport_PrintPreparedReportDlg(var Value: Variant; Args: TArguments);
procedure TfrReport_ChangePrinter(var Value: Variant; Args: TArguments);
procedure TfrReport_EditPreparedReport(var Value: Variant; Args: TArguments);
procedure TfrReport_PrintPreparedReport(var Value: Variant; Args: TArguments);
procedure TfrReport_Read_Pages(var Value: Variant; Args: TArguments);
procedure TfrReport_Read_EMFPages(var Value: Variant; Args: TArguments);
procedure TfrReport_Write_EMFPages(const Value: Variant; Args: TArguments);
procedure TfrReport_Read_Dictionary(var Value: Variant; Args: TArguments);
procedure TfrReport_Write_Dictionary(const Value: Variant; Args: TArguments);
procedure TfrReport_Terminated(var Value: Variant; Args: TArguments);

  { TfrCompositeReport }
procedure TfrCompositeReport_Create(var Value: Variant; Args: TArguments);

  { TfrDataManager }
procedure TfrDataManager_PrepareDataSet(var Value: Variant; Args: TArguments);

  { TfrExportFilter }
procedure TfrExportFilter_Create(var Value: Variant; Args: TArguments);

  { TfrCompressor }
procedure TfrCompressor_Create(var Value: Variant; Args: TArguments);

  { TfrInstalledFunctions }
procedure TfrInstalledFunctions_Create(var Value: Variant; Args: TArguments);

  { TfrLocale }
procedure TfrLocale_Create(var Value: Variant; Args: TArguments);
procedure TfrLocale_Read_LocalizedPropertyNames(var Value: Variant; Args: TArguments);
procedure TfrLocale_Write_LocalizedPropertyNames(const Value: Variant; Args: TArguments);

  { TfrGlobals }
procedure TfrGlobals_Create(var Value: Variant; Args: TArguments);


procedure FastReport_frCreateObject(var Value: Variant; Args: TArguments);
procedure FastReport_frRegisterObject(var Value: Variant; Args: TArguments);
procedure FastReport_frRegisterControl(var Value: Variant; Args: TArguments);
procedure FastReport_frUnRegisterObject(var Value: Variant; Args: TArguments);
procedure FastReport_frRegisterExportFilter(var Value: Variant; Args: TArguments);
procedure FastReport_frUnRegisterExportFilter(var Value: Variant; Args: TArguments);
procedure FastReport_frRegisterFunctionLibrary(var Value: Variant; Args: TArguments);
procedure FastReport_frUnRegisterFunctionLibrary(var Value: Variant; Args: TArguments);
procedure FastReport_frAddFunctionDesc(var Value: Variant; Args: TArguments);
procedure FastReport_GetDefaultDataSet(var Value: Variant; Args: TArguments);
procedure FastReport_frLocale(var Value: Variant; Args: TArguments);

implementation

uses Windows, FR_CLASS, Classes, Graphics, db, FR_DSet, FR_View, FR_DBRel;


{ TFastReportsEvent }

procedure TFastReportsEvent.ProgressEvent(n: Integer);
begin
  CallFunction([n]);
end;

procedure TFastReportsEvent.DetailEvent(const ParName: String; var ParValue: Variant);
begin
  CallFunction( [ParName, ParValue]);
  ParValue:=Args.Values[1];
end;


  { TfrObject }

{ constructor Create }
procedure TfrObject_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrObject.Create);
end;

{ property Read Prop[String]: Variant }
procedure TfrObject_Read_Prop(var Value: Variant; Args: TArguments);
begin
  Value := TfrObject(Args.Obj).Prop[Args.Values[0]];
end;

{ property Write Prop[String]: Variant }
procedure TfrObject_Write_Prop(const Value: Variant; Args: TArguments);
begin
  TfrObject(Args.Obj).Prop[Args.Values[0]] := Value;
end;


  { TfrControl }

{ constructor Create }
procedure TfrControl_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrControl.Create);
end;

{ property Read Control: TControl }
procedure TfrControl_Read_Control(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrControl(Args.Obj).Control);
end;

  { TfrNonVisualControl }

{ constructor Create }
procedure TfrNonVisualControl_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrNonVisualControl.Create);
end;

  { TfrStretcheable }

  { TfrMemoView }

{ constructor Create }
procedure TfrMemoView_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrMemoView.Create);
end;

{ property Read Font: TFont }
procedure TfrMemoView_Read_Font(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrMemoView(Args.Obj).Font);
end;

{ property Write Font(Value: TFont) }
procedure TfrMemoView_Write_Font(const Value: Variant; Args: TArguments);
begin
  TfrMemoView(Args.Obj).Font := V2O(Value) as TFont;
end;

  { TfrBandView }

{ constructor Create }
procedure TfrBandView_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrBandView.Create);
end;

{  function GetClipRgn(rt: TfrRgnType): HRGN; }
procedure TfrBandView_GetClipRgn(var Value: Variant; Args: TArguments);
begin
  Value := Integer(TfrBandView(Args.Obj).GetClipRgn(Args.Values[0]));
end;

{ property Read BandType: TfrBandType }
procedure TfrBandView_Read_BandType(var Value: Variant; Args: TArguments);
begin
  Value := TfrBandView(Args.Obj).BandType;
end;

{ property Write BandType(Value: TfrBandType) }
procedure TfrBandView_Write_BandType(const Value: Variant; Args: TArguments);
begin
  TfrBandView(Args.Obj).BandType := Value;
end;

{ property Read DataSet: String }
procedure TfrBandView_Read_DataSet(var Value: Variant; Args: TArguments);
begin
  Value := TfrBandView(Args.Obj).DataSet;
end;

{ property Write DataSet(Value: String) }
procedure TfrBandView_Write_DataSet(const Value: Variant; Args: TArguments);
begin
  TfrBandView(Args.Obj).DataSet := Value;
end;

{ property Read GroupCondition: String }
procedure TfrBandView_Read_GroupCondition(var Value: Variant; Args: TArguments);
begin
  Value := TfrBandView(Args.Obj).GroupCondition;
end;

{ property Write GroupCondition(Value: String) }
procedure TfrBandView_Write_GroupCondition(const Value: Variant; Args: TArguments);
begin
  TfrBandView(Args.Obj).GroupCondition := Value;
end;

  { TfrSubReportView }

{ constructor Create }
procedure TfrSubReportView_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrSubReportView.Create);
end;

  { TfrPictureView }

{ constructor Create }
procedure TfrPictureView_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrPictureView.Create);
end;

  { TfrLineView }

{ constructor Create }
procedure TfrLineView_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrLineView.Create);
end;

{  function GetClipRgn(rt: TfrRgnType): HRGN; }
procedure TfrLineView_GetClipRgn(var Value: Variant; Args: TArguments);
begin
  Value := Integer(TfrLineView(Args.Obj).GetClipRgn(Args.Values[0]));
end;

  { TfrBand }

{ constructor Create(ATyp: TfrBandType; AParent: TfrPage) }
procedure TfrBand_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrBand.Create(Args.Values[0], V2O(Args.Values[1]) as TfrPage));
end;

  { TfrPage }

{ constructor Create(ASize: Integer; AWidth: Integer; AHeight: Integer; ABin: Integer; AOr: TPrinterOrientation) }
procedure TfrPage_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrPage.Create(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3], Args.Values[4]));
end;

{  procedure ChangePaper(ASize, AWidth, AHeight, ABin: Integer; AOr: TPrinterOrientation); }
procedure TfrPage_ChangePaper(var Value: Variant; Args: TArguments);
begin
  TfrPage(Args.Obj).ChangePaper(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3], Args.Values[4]);
end;

{  procedure ShowBandByType(bt: TfrBandType); }
procedure TfrPage_ShowBandByType(var Value: Variant; Args: TArguments);
begin
  TfrPage(Args.Obj).ShowBandByType(Args.Values[0]);
end;

  { TfrPages }

{ constructor Create(AParent: TfrReport) }
procedure TfrPages_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrPages.Create(V2O(Args.Values[0]) as TfrReport));
end;

{ property Read Pages[Integer]: TfrPage }
procedure TfrPages_Read_Pages(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrPages(Args.Obj).Pages[Args.Values[0]]);
end;

{ property Read Count: Integer }
procedure TfrPages_Read_Count(var Value: Variant; Args: TArguments);
begin
  Value := TfrPages(Args.Obj).Count;
end;

  { TfrEMFPages }

{ constructor Create(AParent: TfrReport) }
procedure TfrEMFPages_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrEMFPages.Create(V2O(Args.Values[0]) as TfrReport));
end;

{ property Read Count: Integer }
procedure TfrEMFPages_Read_Count(var Value: Variant; Args: TArguments);
begin
  Value := TfrEMFPages(Args.Obj).Count;
end;

  { TfrDataDictionary }

{ constructor Create }
procedure TfrDataDictionary_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrDataDictionary.Create);
end;

{ property Read Value[String]: Variant }
procedure TfrDataDictionary_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TfrDataDictionary(Args.Obj).Value[Args.Values[0]];
end;

{ property Read RealDataSetName[String]: String }
procedure TfrDataDictionary_Read_RealDataSetName(var Value: Variant; Args: TArguments);
begin
  Value := TfrDataDictionary(Args.Obj).RealDataSetName[Args.Values[0]];
end;

{ property Read RealDataSourceName[String]: String }
procedure TfrDataDictionary_Read_RealDataSourceName(var Value: Variant; Args: TArguments);
begin
  Value := TfrDataDictionary(Args.Obj).RealDataSourceName[Args.Values[0]];
end;

{ property Read RealFieldName[String]: String }
procedure TfrDataDictionary_Read_RealFieldName(var Value: Variant; Args: TArguments);
begin
  Value := TfrDataDictionary(Args.Obj).RealFieldName[Args.Values[0]];
end;

{ property Read AliasName[String]: String }
procedure TfrDataDictionary_Read_AliasName(var Value: Variant; Args: TArguments);
begin
  Value := TfrDataDictionary(Args.Obj).AliasName[Args.Values[0]];
end;

  { TfrReport }

{ constructor Create(AOwner: TComponent) }
procedure TfrReport_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrReport.Create(V2O(Args.Values[0]) as TComponent));
end;

{  procedure GetVariableValue(const s: String; var v: Variant); }
procedure TfrReport_GetVariableValue(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).GetVariableValue(Args.Values[0], Args.Values[1]);
end;

{  procedure OnGetParsFunction(const name: String; p1, p2, p3: Variant; var val: Variant); }
procedure TfrReport_OnGetParsFunction(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).OnGetParsFunction(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3], Args.Values[4]);
end;

{  procedure LoadFromDB(Table: TIB_DataSet; DocN: Integer); }
procedure TfrReport_LoadFromDB(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).LoadFromDB(TDataSet(V2O(Args.Values[0])), Args.Values[1]);
end;

{  procedure SaveToDB(Table: TIB_DataSet; DocN: Integer); }
procedure TfrReport_SaveToDB(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).SaveToDB(TDataSet(V2O(Args.Values[0])), Args.Values[1]);
end;

{  procedure SaveToBlobField(Blob: TField); }
procedure TfrReport_SaveToBlobField(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).SaveToBlobField(TField(V2O(Args.Values[0])));
end;

{  procedure LoadFromBlobField(Blob: TField); }
procedure TfrReport_LoadFromBlobField(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).LoadFromBlobField(TField(V2O(Args.Values[0])));
end;

{  procedure LoadFromResourceName(Instance: THandle; const ResName: string); }
procedure TfrReport_LoadFromResourceName(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).LoadFromResourceName(Args.Values[0], Args.Values[1]);
end;

{  procedure LoadFromResourceID(Instance: THandle; ResID: Integer); }
procedure TfrReport_LoadFromResourceID(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).LoadFromResourceID(Args.Values[0], Args.Values[1]);
end;

{  procedure LoadTemplate(fname: String; comm: TStrings; Bmp: TBitmap; Load: Boolean); }
procedure TfrReport_LoadTemplate(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).LoadTemplate(Args.Values[0], TStrings(V2O(Args.Values[1])), TBitmap(V2O(Args.Values[2])), Args.Values[3]);
end;

{  procedure SaveTemplate(fname: String; comm: TStrings; Bmp: TBitmap); }
procedure TfrReport_SaveTemplate(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).SaveTemplate(Args.Values[0], TStrings(V2O(Args.Values[1])), TBitmap(V2O(Args.Values[2])));
end;

{  procedure LoadPreparedReport(FName: String); }
procedure TfrReport_LoadPreparedReport(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).LoadPreparedReport(Args.Values[0]);
end;

{  procedure SavePreparedReport(FName: String); }
procedure TfrReport_SavePreparedReport(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).SavePreparedReport(Args.Values[0]);
end;

{  function DesignReport: TModalResult; }
procedure TfrReport_DesignReport(var Value: Variant; Args: TArguments);
begin
  Value:=TfrReport(Args.Obj).DesignReport;
end;

{  function PrepareReport: Boolean; }
procedure TfrReport_PrepareReport(var Value: Variant; Args: TArguments);
begin
  Value:=TfrReport(Args.Obj).PrepareReport;
end;

{  procedure ExportTo(Filter: TfrExportFilter; FileName: String); }
procedure TfrReport_ExportTo(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).ExportTo(TfrExportFilter(V2O(Args.Values[0])),Args.Values[1]);
end;

{  procedure ShowReport; }
procedure TfrReport_ShowReport(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).ShowReport;
end;

{  procedure ShowPreparedReport; }
procedure TfrReport_ShowPreparedReport(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).ShowPreparedReport;
end;

{  procedure PrintPreparedReportDlg; }
procedure TfrReport_PrintPreparedReportDlg(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).PrintPreparedReportDlg;
end;

{  function ChangePrinter(OldIndex, NewIndex: Integer): Boolean; }
procedure TfrReport_ChangePrinter(var Value: Variant; Args: TArguments);
begin
  Value:=TfrReport(Args.Obj).ChangePrinter(Args.Values[0],Args.Values[1]);
end;

{  procedure EditPreparedReport(PageIndex: Integer); }
procedure TfrReport_EditPreparedReport(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).EditPreparedReport(Args.Values[0]);
end;

{  procedure PrintPreparedReport(PageNumbers: String; Copies: Integer; Collate: Boolean; PrintPages: TfrPrintPages); }
procedure TfrReport_PrintPreparedReport(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).PrintPreparedReport(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

{ property Read Pages: TfrPages }
procedure TfrReport_Read_Pages(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrReport(Args.Obj).Pages);
end;

{ property Read EMFPages: TfrEMFPages }
procedure TfrReport_Read_EMFPages(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrReport(Args.Obj).EMFPages);
end;

{ property Write EMFPages(Value: TfrEMFPages) }
procedure TfrReport_Write_EMFPages(const Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).EMFPages := V2O(Value) as TfrEMFPages;
end;

{ property Read Dictionary: TfrDataDictionary }
procedure TfrReport_Read_Dictionary(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrReport(Args.Obj).Dictionary);
end;

{ property Write Dictionary(Value: TfrDataDictionary) }
procedure TfrReport_Write_Dictionary(const Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).Dictionary := V2O(Value) as TfrDataDictionary;
end;

{ variable Read Terminated: Boolean }
procedure TfrReport_Terminated(var Value: Variant; Args: TArguments);
begin
  TfrReport(Args.Obj).Terminated:=true;
end;


  { TfrCompositeReport }

{ constructor Create(AOwner: TComponent) }
procedure TfrCompositeReport_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrCompositeReport.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TfrDataManager }

{  procedure PrepareDataSet(ds: TfrTDataSet); }
procedure TfrDataManager_PrepareDataSet(var Value: Variant; Args: TArguments);
begin
  TfrDataManager(Args.Obj).PrepareDataSet(TfrTDataSet(V2O(Args.Values[0])));
end;

  { TfrExportFilter }

{ constructor Create(AOwner: TComponent) }
procedure TfrExportFilter_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrExportFilter.Create(V2O(Args.Values[0]) as TComponent));
end;


  { TfrCompressor }

{ constructor Create }
procedure TfrCompressor_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrCompressor.Create);
end;

  { TfrInstalledFunctions }

{ constructor Create }
procedure TfrInstalledFunctions_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrInstalledFunctions.Create);
end;

  { TfrLocale }

{ constructor Create }
procedure TfrLocale_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrLocale.Create);
end;

{ property Read LocalizedPropertyNames: Boolean }
procedure TfrLocale_Read_LocalizedPropertyNames(var Value: Variant; Args: TArguments);
begin
  Value := TfrLocale(Args.Obj).LocalizedPropertyNames;
end;

{ property Write LocalizedPropertyNames(Value: Boolean) }
procedure TfrLocale_Write_LocalizedPropertyNames(const Value: Variant; Args: TArguments);
begin
  TfrLocale(Args.Obj).LocalizedPropertyNames := Value;
end;

  { TfrGlobals }

{ constructor Create }
procedure TfrGlobals_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TfrGlobals.Create);
end;

{ function frCreateObject(Typ: Byte; const ClassName: String): TfrView; }
procedure FastReport_frCreateObject(var Value: Variant; Args: TArguments);
begin
  Value := O2V(frCreateObject(Args.Values[0], Args.Values[1]));
end;

{ procedure frRegisterObject(ClassRef: TClass; ButtonBmp: TBitmap; const ButtonHint: String); }
procedure FastReport_frRegisterObject(var Value: Variant; Args: TArguments);
begin
  frRegisterObject(V2C(Args.Values[0]), V2O(Args.Values[1]) as TBitmap, Args.Values[2]);
end;

{ procedure frRegisterControl(ClassRef: TClass; ButtonBmp: TBitmap; const ButtonHint: String); }
procedure FastReport_frRegisterControl(var Value: Variant; Args: TArguments);
begin
  frRegisterControl(V2C(Args.Values[0]), V2O(Args.Values[1]) as TBitmap, Args.Values[2]);
end;

{ procedure frUnRegisterObject(ClassRef: TClass); }
procedure FastReport_frUnRegisterObject(var Value: Variant; Args: TArguments);
begin
  frUnRegisterObject(V2C(Args.Values[0]));
end;

{ procedure frRegisterExportFilter(Filter: TfrExportFilter; const FilterDesc, FilterExt: String); }
procedure FastReport_frRegisterExportFilter(var Value: Variant; Args: TArguments);
begin
  frRegisterExportFilter(V2O(Args.Values[0]) as TfrExportFilter, Args.Values[1], Args.Values[2]);
end;

{ procedure frUnRegisterExportFilter(Filter: TfrExportFilter); }
procedure FastReport_frUnRegisterExportFilter(var Value: Variant; Args: TArguments);
begin
  frUnRegisterExportFilter(V2O(Args.Values[0]) as TfrExportFilter);
end;

{ procedure frRegisterFunctionLibrary(ClassRef: TClass); }
procedure FastReport_frRegisterFunctionLibrary(var Value: Variant; Args: TArguments);
begin
  frRegisterFunctionLibrary(V2C(Args.Values[0]));
end;

{ procedure frUnRegisterFunctionLibrary(ClassRef: TClass); }
procedure FastReport_frUnRegisterFunctionLibrary(var Value: Variant; Args: TArguments);
begin
  frUnRegisterFunctionLibrary(V2C(Args.Values[0]));
end;

{ procedure frAddFunctionDesc(FuncLibrary: TfrFunctionLibrary; FuncName, Category, Description: String); }
procedure FastReport_frAddFunctionDesc(var Value: Variant; Args: TArguments);
begin
  frAddFunctionDesc(V2O(Args.Values[0]) as TfrFunctionLibrary, Args.Values[1], Args.Values[2], Args.Values[3]);
end;

{ function GetDefaultDataSet: TfrTDataSet; }
procedure FastReport_GetDefaultDataSet(var Value: Variant; Args: TArguments);
begin
  Value := O2V(GetDefaultDataSet);
end;

{ function frLocale: TfrLocale; }
procedure FastReport_frLocale(var Value: Variant; Args: TArguments);
begin
  Value := O2V(frLocale);
end;

(*

procedure RegisterFastReportAdapter(FastReportAdapter: TFastReportAdapter);
begin
  with FastReportAdapter do
  begin
   { TfrObject }
    AddClass('FR_CLASS', TfrObject, 'TfrObject');
    AddGet(TfrObject, 'Create', TfrObject_Create, 0, [0], varEmpty);
    {  procedure DefineProperties; }
    AddDGet(TfrObject, 'DefineProperties', @TfrObject.DefineProperties, 0, [0], varEmpty, [ccFastCall], varEmpty);
    AddIGet(TfrObject, 'Prop', TfrObject_Read_Prop, 1, [0], varEmpty);
    AddISet(TfrObject, 'Prop', TfrObject_Write_Prop, 0, [1], varEmpty);
    AddIGet(TfrObject, 'PropRec', TfrObject_Read_PropRec, 1, [0], varEmpty);
   { TfrView }
    AddClass('FR_CLASS', TfrView, 'TfrView');
    AddGet(TfrView, 'Create', TfrView_Create, 0, [0], varEmpty);
    {  procedure Assign(From: TfrView); }
    AddDGet(TfrView, 'Assign', @TfrView.Assign, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    {  procedure CalcGaps; }
    AddDGet(TfrView, 'CalcGaps', @TfrView.CalcGaps, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  procedure RestoreCoord; }
    AddDGet(TfrView, 'RestoreCoord', @TfrView.RestoreCoord, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  procedure Draw(Canvas: TCanvas); }
    AddDGet(TfrView, 'Draw', @TfrView.Draw, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    {  procedure StreamOut(Stream: TStream); }
    AddDGet(TfrView, 'StreamOut', @TfrView.StreamOut, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    {  procedure ExportData; }
    AddDGet(TfrView, 'ExportData', @TfrView.ExportData, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrView, 'LoadFromStream', @TfrView.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrView, 'SaveToStream', @TfrView.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    {  procedure Resized; }
    AddDGet(TfrView, 'Resized', @TfrView.Resized, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  procedure DefinePopupMenu(Popup: TPopupMenu); }
    AddDGet(TfrView, 'DefinePopupMenu', @TfrView.DefinePopupMenu, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    AddGet(TfrView, 'GetClipRgn', TfrView_GetClipRgn, 1, [varEmpty], varEmpty);
    {  procedure CreateUniqueName; }
    AddDGet(TfrView, 'CreateUniqueName', @TfrView.CreateUniqueName, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  procedure SetBounds(Left, Top, Width, Height: Integer); }
    AddDGet(TfrView, 'SetBounds', @TfrView.SetBounds, 4, [varInteger, varInteger, varInteger, varInteger], varEmpty, [ccFastCall], varEmpty);
    {  procedure DefineProperties; }
    AddDGet(TfrView, 'DefineProperties', @TfrView.DefineProperties, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  procedure ShowEditor; }
    AddDGet(TfrView, 'ShowEditor', @TfrView.ShowEditor, 0, [0], varEmpty, [ccFastCall], varEmpty);
   { TfrControl }
    AddClass('FR_CLASS', TfrControl, 'TfrControl');
    AddGet(TfrControl, 'Create', TfrControl_Create, 0, [0], varEmpty);
    {  procedure DefineProperties; }
    AddDGet(TfrControl, 'DefineProperties', @TfrControl.DefineProperties, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  procedure PlaceControl(Form: TForm); }
    AddDGet(TfrControl, 'PlaceControl', @TfrControl.PlaceControl, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    {  procedure Draw(Canvas: TCanvas); }
    AddDGet(TfrControl, 'Draw', @TfrControl.Draw, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    {  procedure DefinePopupMenu(Popup: TPopupMenu); }
    AddDGet(TfrControl, 'DefinePopupMenu', @TfrControl.DefinePopupMenu, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
    AddGet(TfrControl, 'Control', TfrControl_Read_Control, 0, [0], varObject);
   { TfrNonVisualControl }
    AddClass('FR_CLASS', TfrNonVisualControl, 'TfrNonVisualControl');
    AddGet(TfrNonVisualControl, 'Create', TfrNonVisualControl_Create, 0, [0], varObject);
    {  procedure DefineProperties; }
    AddDGet(TfrNonVisualControl, 'DefineProperties', @TfrNonVisualControl.DefineProperties, 0, [0], varEmpty, [ccFastCall], varObject);
    {  procedure PlaceControl(Form: TForm); }
    AddDGet(TfrNonVisualControl, 'PlaceControl', @TfrNonVisualControl.PlaceControl, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure Draw(Canvas: TCanvas); }
    AddDGet(TfrNonVisualControl, 'Draw', @TfrNonVisualControl.Draw, 1, [varObject], varEmpty, [ccFastCall], varObject);
   { TfrStretcheable }
    AddClass('FR_CLASS', TfrStretcheable, 'TfrStretcheable');
   { TfrMemoView }
    AddClass('FR_CLASS', TfrMemoView, 'TfrMemoView');
    AddGet(TfrMemoView, 'Create', TfrMemoView_Create, 0, [0], varObject);
    {  procedure Draw(Canvas: TCanvas); }
    AddDGet(TfrMemoView, 'Draw', @TfrMemoView.Draw, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure StreamOut(Stream: TStream); }
    AddDGet(TfrMemoView, 'StreamOut', @TfrMemoView.StreamOut, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure ExportData; }
    AddDGet(TfrMemoView, 'ExportData', @TfrMemoView.ExportData, 0, [0], varEmpty, [ccFastCall], varObject);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrMemoView, 'LoadFromStream', @TfrMemoView.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrMemoView, 'SaveToStream', @TfrMemoView.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure DefinePopupMenu(Popup: TPopupMenu); }
    AddDGet(TfrMemoView, 'DefinePopupMenu', @TfrMemoView.DefinePopupMenu, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure DefineProperties; }
    AddDGet(TfrMemoView, 'DefineProperties', @TfrMemoView.DefineProperties, 0, [0], varEmpty, [ccFastCall], varObject);
    {  procedure ShowEditor; }
    AddDGet(TfrMemoView, 'ShowEditor', @TfrMemoView.ShowEditor, 0, [0], varEmpty, [ccFastCall], varObject);
    AddGet(TfrMemoView, 'Font', TfrMemoView_Read_Font, 0, [0], varObject);
    AddSet(TfrMemoView, 'Font', TfrMemoView_Write_Font, 0, [varObject]);
   { TfrBandView }
    AddClass('FR_CLASS', TfrBandView, 'TfrBandView');
    AddGet(TfrBandView, 'Create', TfrBandView_Create, 0, [0], varObject);
    {  procedure Draw(Canvas: TCanvas); }
    AddDGet(TfrBandView, 'Draw', @TfrBandView.Draw, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrBandView, 'LoadFromStream', @TfrBandView.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrBandView, 'SaveToStream', @TfrBandView.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure DefinePopupMenu(Popup: TPopupMenu); }
    AddDGet(TfrBandView, 'DefinePopupMenu', @TfrBandView.DefinePopupMenu, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure DefineProperties; }
    AddDGet(TfrBandView, 'DefineProperties', @TfrBandView.DefineProperties, 0, [0], varEmpty, [ccFastCall], varObject);
    AddGet(TfrBandView, 'GetClipRgn', TfrBandView_GetClipRgn, 1, [varEmpty], varEmpty);
    AddGet(TfrBandView, 'BandType', TfrBandView_Read_BandType, 0, [0], varEmpty);
    AddSet(TfrBandView, 'BandType', TfrBandView_Write_BandType, 0, [varEmpty]);
    AddGet(TfrBandView, 'DataSet', TfrBandView_Read_DataSet, 0, [0], varString);
    AddSet(TfrBandView, 'DataSet', TfrBandView_Write_DataSet, 0, [varString]);
    AddGet(TfrBandView, 'GroupCondition', TfrBandView_Read_GroupCondition, 0, [0], varString);
    AddSet(TfrBandView, 'GroupCondition', TfrBandView_Write_GroupCondition, 0, [varString]);
   { TfrSubReportView }
    AddClass('FR_CLASS', TfrSubReportView, 'TfrSubReportView');
    AddGet(TfrSubReportView, 'Create', TfrSubReportView_Create, 0, [0], varString);
    {  procedure Draw(Canvas: TCanvas); }
    AddDGet(TfrSubReportView, 'Draw', @TfrSubReportView.Draw, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrSubReportView, 'LoadFromStream', @TfrSubReportView.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrSubReportView, 'SaveToStream', @TfrSubReportView.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure DefinePopupMenu(Popup: TPopupMenu); }
    AddDGet(TfrSubReportView, 'DefinePopupMenu', @TfrSubReportView.DefinePopupMenu, 1, [varObject], varEmpty, [ccFastCall], varString);
   { TfrPictureView }
    AddClass('FR_CLASS', TfrPictureView, 'TfrPictureView');
    AddGet(TfrPictureView, 'Create', TfrPictureView_Create, 0, [0], varString);
    {  procedure Draw(Canvas: TCanvas); }
    AddDGet(TfrPictureView, 'Draw', @TfrPictureView.Draw, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrPictureView, 'LoadFromStream', @TfrPictureView.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrPictureView, 'SaveToStream', @TfrPictureView.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure DefinePopupMenu(Popup: TPopupMenu); }
    AddDGet(TfrPictureView, 'DefinePopupMenu', @TfrPictureView.DefinePopupMenu, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure DefineProperties; }
    AddDGet(TfrPictureView, 'DefineProperties', @TfrPictureView.DefineProperties, 0, [0], varEmpty, [ccFastCall], varString);
    {  procedure ShowEditor; }
    AddDGet(TfrPictureView, 'ShowEditor', @TfrPictureView.ShowEditor, 0, [0], varEmpty, [ccFastCall], varString);
   { TfrLineView }
    AddClass('FR_CLASS', TfrLineView, 'TfrLineView');
    AddGet(TfrLineView, 'Create', TfrLineView_Create, 0, [0], varString);
    {  procedure Draw(Canvas: TCanvas); }
    AddDGet(TfrLineView, 'Draw', @TfrLineView.Draw, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  function CalcHeight: Integer; }
    AddDGet(TfrLineView, 'CalcHeight', @TfrLineView.CalcHeight, 0, [0], varInteger, [ccFastCall], varInteger);
    {  function MinHeight: Integer; }
    AddDGet(TfrLineView, 'MinHeight', @TfrLineView.MinHeight, 0, [0], varInteger, [ccFastCall], varInteger);
    {  function LostSpace: Integer; }
    AddDGet(TfrLineView, 'LostSpace', @TfrLineView.LostSpace, 0, [0], varInteger, [ccFastCall], varInteger);
    AddGet(TfrLineView, 'GetClipRgn', TfrLineView_GetClipRgn, 1, [varEmpty], varEmpty);
    {  procedure DefineProperties; }
    AddDGet(TfrLineView, 'DefineProperties', @TfrLineView.DefineProperties, 0, [0], varEmpty, [ccFastCall], varEmpty);
   { TfrBand }
    AddClass('FR_CLASS', TfrBand, 'TfrBand');
    AddGet(TfrBand, 'Create', TfrBand_Create, 2, [varEmpty, varObject], varEmpty);
   { TfrPage }
    AddClass('FR_CLASS', TfrPage, 'TfrPage');
    AddGet(TfrPage, 'Create', TfrPage_Create, 5, [varInteger, varInteger, varInteger, varInteger, varEmpty], varEmpty);
    {  procedure DefineProperties; }
    AddDGet(TfrPage, 'DefineProperties', @TfrPage.DefineProperties, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  procedure CreateUniqueName; }
    AddDGet(TfrPage, 'CreateUniqueName', @TfrPage.CreateUniqueName, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  function TopMargin: Integer; }
    AddDGet(TfrPage, 'TopMargin', @TfrPage.TopMargin, 0, [0], varInteger, [ccFastCall], varInteger);
    {  function BottomMargin: Integer; }
    AddDGet(TfrPage, 'BottomMargin', @TfrPage.BottomMargin, 0, [0], varInteger, [ccFastCall], varInteger);
    {  function LeftMargin: Integer; }
    AddDGet(TfrPage, 'LeftMargin', @TfrPage.LeftMargin, 0, [0], varInteger, [ccFastCall], varInteger);
    {  function RightMargin: Integer; }
    AddDGet(TfrPage, 'RightMargin', @TfrPage.RightMargin, 0, [0], varInteger, [ccFastCall], varInteger);
    {  procedure Clear; }
    AddDGet(TfrPage, 'Clear', @TfrPage.Clear, 0, [0], varEmpty, [ccFastCall], varInteger);
    {  procedure Delete(Index: Integer); }
    AddDGet(TfrPage, 'Delete', @TfrPage.Delete, 1, [varInteger], varEmpty, [ccFastCall], varInteger);
    {  function FindObjectByID(ID: Integer): Integer; }
    AddDGet(TfrPage, 'FindObjectByID', @TfrPage.FindObjectByID, 1, [varInteger], varInteger, [ccFastCall], varInteger);
    {  function FindObject(Name: String): TfrView; }
    AddDGet(TfrPage, 'FindObject', @TfrPage.FindObject, 1, [varString], varObject, [ccFastCall], varObject);
    AddGet(TfrPage, 'ChangePaper', TfrPage_ChangePaper, 5, [varInteger, varInteger, varInteger, varInteger, varEmpty], varObject);
    {  procedure ShowBandByName(s: String); }
    AddDGet(TfrPage, 'ShowBandByName', @TfrPage.ShowBandByName, 1, [varString], varEmpty, [ccFastCall], varObject);
    AddGet(TfrPage, 'ShowBandByType', TfrPage_ShowBandByType, 1, [varEmpty], varObject);
    {  procedure NewPage; }
    AddDGet(TfrPage, 'NewPage', @TfrPage.NewPage, 0, [0], varEmpty, [ccFastCall], varObject);
    {  procedure NewColumn(Band: TfrBand); }
    AddDGet(TfrPage, 'NewColumn', @TfrPage.NewColumn, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure ScriptEditor(Sender: TObject); }
    AddDGet(TfrPage, 'ScriptEditor', @TfrPage.ScriptEditor, 1, [varObject], varEmpty, [ccFastCall], varObject);
   { TfrPages }
    AddClass('FR_CLASS', TfrPages, 'TfrPages');
    AddGet(TfrPages, 'Create', TfrPages_Create, 1, [varObject], varObject);
    {  procedure Clear; }
    AddDGet(TfrPages, 'Clear', @TfrPages.Clear, 0, [0], varEmpty, [ccFastCall], varObject);
    {  procedure Add; }
    AddDGet(TfrPages, 'Add', @TfrPages.Add, 0, [0], varEmpty, [ccFastCall], varObject);
    {  procedure Delete(Index: Integer); }
    AddDGet(TfrPages, 'Delete', @TfrPages.Delete, 1, [varInteger], varEmpty, [ccFastCall], varObject);
    {  procedure Move(OldIndex, NewIndex: Integer); }
    AddDGet(TfrPages, 'Move', @TfrPages.Move, 2, [varInteger, varInteger], varEmpty, [ccFastCall], varObject);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrPages, 'LoadFromStream', @TfrPages.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrPages, 'SaveToStream', @TfrPages.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varObject);
    AddIGet(TfrPages, 'Pages', TfrPages_Read_Pages, 1, [0], varObject);
    AddIDGet(TfrPages, TfrPages_Read_Pages, 1, [0], varObject);
    AddGet(TfrPages, 'Count', TfrPages_Read_Count, 0, [0], varInteger);
   { TfrEMFPages }
    AddClass('FR_CLASS', TfrEMFPages, 'TfrEMFPages');
    AddGet(TfrEMFPages, 'Create', TfrEMFPages_Create, 1, [varObject], varInteger);
    {  procedure Clear; }
    AddDGet(TfrEMFPages, 'Clear', @TfrEMFPages.Clear, 0, [0], varEmpty, [ccFastCall], varInteger);
    AddGet(TfrEMFPages, 'Draw', TfrEMFPages_Draw, 3, [varInteger, varObject, varEmpty], varInteger);
    {  procedure Add(APage: TfrPage); }
    AddDGet(TfrEMFPages, 'Add', @TfrEMFPages.Add, 1, [varObject], varEmpty, [ccFastCall], varInteger);
    {  procedure AddFrom(Report: TfrReport); }
    AddDGet(TfrEMFPages, 'AddFrom', @TfrEMFPages.AddFrom, 1, [varObject], varEmpty, [ccFastCall], varInteger);
    {  procedure Insert(Index: Integer; APage: TfrPage); }
    AddDGet(TfrEMFPages, 'Insert', @TfrEMFPages.Insert, 2, [varInteger, varObject], varEmpty, [ccFastCall], varInteger);
    {  procedure Delete(Index: Integer); }
    AddDGet(TfrEMFPages, 'Delete', @TfrEMFPages.Delete, 1, [varInteger], varEmpty, [ccFastCall], varInteger);
    {  procedure LoadFromStream(AStream: TStream); }
    AddDGet(TfrEMFPages, 'LoadFromStream', @TfrEMFPages.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varInteger);
    {  procedure SaveToStream(AStream: TStream); }
    AddDGet(TfrEMFPages, 'SaveToStream', @TfrEMFPages.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varInteger);
    AddGet(TfrEMFPages, 'DoClick', TfrEMFPages_DoClick, 4, [varInteger, varEmpty, varBoolean, varEmpty or varByRef], varBoolean);
    AddIGet(TfrEMFPages, 'Pages', TfrEMFPages_Read_Pages, 1, [0], varEmpty);
    AddIDGet(TfrEMFPages, TfrEMFPages_Read_Pages, 1, [0], varEmpty);
    AddGet(TfrEMFPages, 'Count', TfrEMFPages_Read_Count, 0, [0], varInteger);
   { TfrDataDictionary }
    AddClass('FR_CLASS', TfrDataDictionary, 'TfrDataDictionary');
    AddGet(TfrDataDictionary, 'Create', TfrDataDictionary_Create, 0, [0], varInteger);
    {  procedure Clear; }
    AddDGet(TfrDataDictionary, 'Clear', @TfrDataDictionary.Clear, 0, [0], varEmpty, [ccFastCall], varInteger);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrDataDictionary, 'LoadFromStream', @TfrDataDictionary.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varInteger);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrDataDictionary, 'SaveToStream', @TfrDataDictionary.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varInteger);
    {  procedure LoadFromFile(FName: String); }
    AddDGet(TfrDataDictionary, 'LoadFromFile', @TfrDataDictionary.LoadFromFile, 1, [varString], varEmpty, [ccFastCall], varInteger);
    {  procedure SaveToFile(FName: String); }
    AddDGet(TfrDataDictionary, 'SaveToFile', @TfrDataDictionary.SaveToFile, 1, [varString], varEmpty, [ccFastCall], varInteger);
    {  procedure ExtractFieldName(ComplexName: String; var DSName, FieldName: String); }
    AddDGet(TfrDataDictionary, 'ExtractFieldName', @TfrDataDictionary.ExtractFieldName, 3, [varString, varString or varByRef, varString or varByRef], varEmpty, [ccFastCall], varInteger);
    {  function IsVariable(VarName: String): Boolean; }
    AddDGet(TfrDataDictionary, 'IsVariable', @TfrDataDictionary.IsVariable, 1, [varString], varBoolean, [ccFastCall], varBoolean);
    {  function DatasetEnabled(DatasetName: String): Boolean; }
    AddDGet(TfrDataDictionary, 'DatasetEnabled', @TfrDataDictionary.DatasetEnabled, 1, [varString], varBoolean, [ccFastCall], varBoolean);
    {  procedure GetDatasetList(List: TStrings); }
    AddDGet(TfrDataDictionary, 'GetDatasetList', @TfrDataDictionary.GetDatasetList, 1, [varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure GetFieldList(DSName: String; List: TStrings); }
    AddDGet(TfrDataDictionary, 'GetFieldList', @TfrDataDictionary.GetFieldList, 2, [varString, varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure GetBandDatasourceList(List: TStrings); }
    AddDGet(TfrDataDictionary, 'GetBandDatasourceList', @TfrDataDictionary.GetBandDatasourceList, 1, [varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure GetCategoryList(List: TStrings); }
    AddDGet(TfrDataDictionary, 'GetCategoryList', @TfrDataDictionary.GetCategoryList, 1, [varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure GetVariablesList(Category: String; List: TStrings); }
    AddDGet(TfrDataDictionary, 'GetVariablesList', @TfrDataDictionary.GetVariablesList, 2, [varString, varObject], varEmpty, [ccFastCall], varBoolean);
    AddIGet(TfrDataDictionary, 'Value', TfrDataDictionary_Read_Value, 1, [0], varEmpty);
    AddIGet(TfrDataDictionary, 'RealDataSetName', TfrDataDictionary_Read_RealDataSetName, 1, [0], varString);
    AddIGet(TfrDataDictionary, 'RealDataSourceName', TfrDataDictionary_Read_RealDataSourceName, 1, [0], varString);
    AddIGet(TfrDataDictionary, 'RealFieldName', TfrDataDictionary_Read_RealFieldName, 1, [0], varString);
    AddIGet(TfrDataDictionary, 'AliasName', TfrDataDictionary_Read_AliasName, 1, [0], varString);
   { TfrReport }
    AddClass('FR_CLASS', TfrReport, 'TfrReport');
    AddGet(TfrReport, 'Create', TfrReport_Create, 1, [varObject], varString);
    {  procedure Clear; }
    AddDGet(TfrReport, 'Clear', @TfrReport.Clear, 0, [0], varEmpty, [ccFastCall], varString);
    {  procedure InternalOnEnterRect(Memo: TStringList; View: TfrView); }
    AddDGet(TfrReport, 'InternalOnEnterRect', @TfrReport.InternalOnEnterRect, 2, [varObject, varObject], varEmpty, [ccFastCall], varString);
    {  procedure InternalOnExportData(View: TfrView); }
    AddDGet(TfrReport, 'InternalOnExportData', @TfrReport.InternalOnExportData, 1, [varObject], varEmpty, [ccFastCall], varString);
    AddGet(TfrReport, 'InternalOnExportText', TfrReport_InternalOnExportText, 6, [varEmpty, varInteger, varInteger, varString, varInteger, varObject], varString);
    {  procedure InternalOnGetValue(ParName: String; var ParValue: String); }
    AddDGet(TfrReport, 'InternalOnGetValue', @TfrReport.InternalOnGetValue, 2, [varString, varString or varByRef], varEmpty, [ccFastCall], varString);
    {  procedure InternalOnProgress(Percent: Integer); }
    AddDGet(TfrReport, 'InternalOnProgress', @TfrReport.InternalOnProgress, 1, [varInteger], varEmpty, [ccFastCall], varString);
    {  procedure InternalOnBeginColumn(Band: TfrBand); }
    AddDGet(TfrReport, 'InternalOnBeginColumn', @TfrReport.InternalOnBeginColumn, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure InternalOnPrintColumn(ColNo: Integer; var ColWidth: Integer); }
    AddDGet(TfrReport, 'InternalOnPrintColumn', @TfrReport.InternalOnPrintColumn, 2, [varInteger, varInteger or varByRef], varEmpty, [ccFastCall], varString);
    {  procedure FillQueryParams; }
    AddDGet(TfrReport, 'FillQueryParams', @TfrReport.FillQueryParams, 0, [0], varEmpty, [ccFastCall], varString);
    AddGet(TfrReport, 'GetVariableValue', TfrReport_GetVariableValue, 2, [varString, varEmpty or varByRef], varString);
    AddGet(TfrReport, 'GetVariableV', TfrReport_GetVariableV, 2, [varString, varEmpty or varByRef], varString);
    AddGet(TfrReport, 'OnGetParsFunction', TfrReport_OnGetParsFunction, 5, [varString, varEmpty, varEmpty, varEmpty, varEmpty or varByRef], varString);
    {  function FindObject(Name: String): TfrView; }
    AddDGet(TfrReport, 'FindObject', @TfrReport.FindObject, 1, [varString], varObject, [ccFastCall], varObject);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrReport, 'LoadFromStream', @TfrReport.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrReport, 'SaveToStream', @TfrReport.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varObject);
    {  function LoadFromFile(FName: String): Boolean; }
    AddDGet(TfrReport, 'LoadFromFile', @TfrReport.LoadFromFile, 1, [varString], varBoolean, [ccFastCall], varBoolean);
    {  procedure SaveToFile(FName: String); }
    AddDGet(TfrReport, 'SaveToFile', @TfrReport.SaveToFile, 1, [varString], varEmpty, [ccFastCall], varBoolean);
    AddGet(TfrReport, 'LoadFromDB', TfrReport_LoadFromDB, 2, [varEmpty, varInteger], varBoolean);
    AddGet(TfrReport, 'SaveToDB', TfrReport_SaveToDB, 2, [varEmpty, varInteger], varBoolean);
    AddGet(TfrReport, 'SaveToBlobField', TfrReport_SaveToBlobField, 1, [varEmpty], varBoolean);
    AddGet(TfrReport, 'LoadFromBlobField', TfrReport_LoadFromBlobField, 1, [varEmpty], varBoolean);
    {  procedure LoadFromDB(Table: TDataSet; DocN: Integer); }
    AddDGet(TfrReport, 'LoadFromDB', @TfrReport.LoadFromDB, 2, [varObject, varInteger], varEmpty, [ccFastCall], varBoolean);
    {  procedure SaveToDB(Table: TDataSet; DocN: Integer); }
    AddDGet(TfrReport, 'SaveToDB', @TfrReport.SaveToDB, 2, [varObject, varInteger], varEmpty, [ccFastCall], varBoolean);
    {  procedure SaveToBlobField(Blob: TField); }
    AddDGet(TfrReport, 'SaveToBlobField', @TfrReport.SaveToBlobField, 1, [varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure LoadFromBlobField(Blob: TField); }
    AddDGet(TfrReport, 'LoadFromBlobField', @TfrReport.LoadFromBlobField, 1, [varObject], varEmpty, [ccFastCall], varBoolean);
    AddGet(TfrReport, 'LoadFromResourceName', TfrReport_LoadFromResourceName, 2, [varEmpty, varString], varBoolean);
    AddGet(TfrReport, 'LoadFromResourceID', TfrReport_LoadFromResourceID, 2, [varEmpty, varInteger], varBoolean);
    {  procedure LoadTemplate(fname: String; comm: TStrings; Bmp: TBitmap; Load: Boolean); }
    AddDGet(TfrReport, 'LoadTemplate', @TfrReport.LoadTemplate, 4, [varString, varObject, varObject, varBoolean], varEmpty, [ccFastCall], varBoolean);
    {  procedure SaveTemplate(fname: String; comm: TStrings; Bmp: TBitmap); }
    AddDGet(TfrReport, 'SaveTemplate', @TfrReport.SaveTemplate, 3, [varString, varObject, varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure LoadPreparedReport(FName: String); }
    AddDGet(TfrReport, 'LoadPreparedReport', @TfrReport.LoadPreparedReport, 1, [varString], varEmpty, [ccFastCall], varBoolean);
    {  procedure SavePreparedReport(FName: String); }
    AddDGet(TfrReport, 'SavePreparedReport', @TfrReport.SavePreparedReport, 1, [varString], varEmpty, [ccFastCall], varBoolean);
    {  function DesignReport: TModalResult; }
    AddDGet(TfrReport, 'DesignReport', @TfrReport.DesignReport, 0, [0], varEmpty, [ccFastCall], varEmpty);
    {  function PrepareReport: Boolean; }
    AddDGet(TfrReport, 'PrepareReport', @TfrReport.PrepareReport, 0, [0], varBoolean, [ccFastCall], varBoolean);
    {  procedure ExportTo(Filter: TfrExportFilter; FileName: String); }
    AddDGet(TfrReport, 'ExportTo', @TfrReport.ExportTo, 2, [varObject, varString], varEmpty, [ccFastCall], varBoolean);
    {  procedure ShowReport; }
    AddDGet(TfrReport, 'ShowReport', @TfrReport.ShowReport, 0, [0], varEmpty, [ccFastCall], varBoolean);
    {  procedure ShowPreparedReport; }
    AddDGet(TfrReport, 'ShowPreparedReport', @TfrReport.ShowPreparedReport, 0, [0], varEmpty, [ccFastCall], varBoolean);
    {  procedure PrintPreparedReportDlg; }
    AddDGet(TfrReport, 'PrintPreparedReportDlg', @TfrReport.PrintPreparedReportDlg, 0, [0], varEmpty, [ccFastCall], varBoolean);
    AddGet(TfrReport, 'PrintPreparedReport', TfrReport_PrintPreparedReport, 4, [varString, varInteger, varBoolean, varEmpty], varBoolean);
    {  function ChangePrinter(OldIndex, NewIndex: Integer): Boolean; }
    AddDGet(TfrReport, 'ChangePrinter', @TfrReport.ChangePrinter, 2, [varInteger, varInteger], varBoolean, [ccFastCall], varBoolean);
    {  procedure EditPreparedReport(PageIndex: Integer); }
    AddDGet(TfrReport, 'EditPreparedReport', @TfrReport.EditPreparedReport, 1, [varInteger], varEmpty, [ccFastCall], varBoolean);
    AddGet(TfrReport, 'Pages', TfrReport_Read_Pages, 0, [0], varObject);
    AddGet(TfrReport, 'EMFPages', TfrReport_Read_EMFPages, 0, [0], varObject);
    AddSet(TfrReport, 'EMFPages', TfrReport_Write_EMFPages, 0, [varObject]);
    AddGet(TfrReport, 'Dictionary', TfrReport_Read_Dictionary, 0, [0], varObject);
    AddSet(TfrReport, 'Dictionary', TfrReport_Write_Dictionary, 0, [varObject]);
    AddGet(TfrReport, 'Dataset', TfrReport_Read_Dataset, 0, [0], varEmpty);
    AddSet(TfrReport, 'Dataset', TfrReport_Write_Dataset, 0, [varEmpty]);
    AddGet(TfrReport, 'DefaultCopies', TfrReport_Read_DefaultCopies, 0, [0], varInteger);
    AddSet(TfrReport, 'DefaultCopies', TfrReport_Write_DefaultCopies, 0, [varInteger]);
    AddGet(TfrReport, 'DefaultCollate', TfrReport_Read_DefaultCollate, 0, [0], varBoolean);
    AddSet(TfrReport, 'DefaultCollate', TfrReport_Write_DefaultCollate, 0, [varBoolean]);
    AddGet(TfrReport, 'GrayedButtons', TfrReport_Read_GrayedButtons, 0, [0], varBoolean);
    AddSet(TfrReport, 'GrayedButtons', TfrReport_Write_GrayedButtons, 0, [varBoolean]);
    AddGet(TfrReport, 'InitialZoom', TfrReport_Read_InitialZoom, 0, [0], varEmpty);
    AddSet(TfrReport, 'InitialZoom', TfrReport_Write_InitialZoom, 0, [varEmpty]);
    AddGet(TfrReport, 'MDIPreview', TfrReport_Read_MDIPreview, 0, [0], varBoolean);
    AddSet(TfrReport, 'MDIPreview', TfrReport_Write_MDIPreview, 0, [varBoolean]);
    AddGet(TfrReport, 'ModalPreview', TfrReport_Read_ModalPreview, 0, [0], varBoolean);
    AddSet(TfrReport, 'ModalPreview', TfrReport_Write_ModalPreview, 0, [varBoolean]);
    AddGet(TfrReport, 'ModifyPrepared', TfrReport_Read_ModifyPrepared, 0, [0], varBoolean);
    AddSet(TfrReport, 'ModifyPrepared', TfrReport_Write_ModifyPrepared, 0, [varBoolean]);
    AddGet(TfrReport, 'Preview', TfrReport_Read_Preview, 0, [0], varEmpty);
    AddSet(TfrReport, 'Preview', TfrReport_Write_Preview, 0, [varEmpty]);
    AddGet(TfrReport, 'PreviewButtons', TfrReport_Read_PreviewButtons, 0, [0], varEmpty);
    AddSet(TfrReport, 'PreviewButtons', TfrReport_Write_PreviewButtons, 0, [varEmpty]);
    AddGet(TfrReport, 'PrintIfEmpty', TfrReport_Read_PrintIfEmpty, 0, [0], varBoolean);
    AddSet(TfrReport, 'PrintIfEmpty', TfrReport_Write_PrintIfEmpty, 0, [varBoolean]);
    AddGet(TfrReport, 'ReportType', TfrReport_Read_ReportType, 0, [0], varEmpty);
    AddSet(TfrReport, 'ReportType', TfrReport_Write_ReportType, 0, [varEmpty]);
    AddGet(TfrReport, 'ShowPrintDialog', TfrReport_Read_ShowPrintDialog, 0, [0], varBoolean);
    AddSet(TfrReport, 'ShowPrintDialog', TfrReport_Write_ShowPrintDialog, 0, [varBoolean]);
    AddGet(TfrReport, 'ShowProgress', TfrReport_Read_ShowProgress, 0, [0], varBoolean);
    AddSet(TfrReport, 'ShowProgress', TfrReport_Write_ShowProgress, 0, [varBoolean]);
    AddGet(TfrReport, 'StoreInDFM', TfrReport_Read_StoreInDFM, 0, [0], varBoolean);
    AddSet(TfrReport, 'StoreInDFM', TfrReport_Write_StoreInDFM, 0, [varBoolean]);
    AddGet(TfrReport, 'Title', TfrReport_Read_Title, 0, [0], varString);
    AddSet(TfrReport, 'Title', TfrReport_Write_Title, 0, [varString]);
   { TfrCompositeReport }
    AddClass('FR_CLASS', TfrCompositeReport, 'TfrCompositeReport');
    AddGet(TfrCompositeReport, 'Create', TfrCompositeReport_Create, 1, [varObject], varString);
   { TfrReportDesigner }
    AddClass('FR_CLASS', TfrReportDesigner, 'TfrReportDesigner');
    AddGet(TfrReportDesigner, 'CreateDesigner', TfrReportDesigner_CreateDesigner, 1, [varBoolean], varString);
    {  procedure BeforeChange; }
    AddDGet(TfrReportDesigner, 'BeforeChange', @TfrReportDesigner.BeforeChange, 0, [0], varEmpty, [ccFastCall], varString);
    {  procedure AfterChange; }
    AddDGet(TfrReportDesigner, 'AfterChange', @TfrReportDesigner.AfterChange, 0, [0], varEmpty, [ccFastCall], varString);
    {  procedure RedrawPage; }
    AddDGet(TfrReportDesigner, 'RedrawPage', @TfrReportDesigner.RedrawPage, 0, [0], varEmpty, [ccFastCall], varString);
    {  procedure SelectObject(ObjName: String); }
    AddDGet(TfrReportDesigner, 'SelectObject', @TfrReportDesigner.SelectObject, 1, [varString], varEmpty, [ccFastCall], varString);
    {  function InsertDBField: String; }
    AddDGet(TfrReportDesigner, 'InsertDBField', @TfrReportDesigner.InsertDBField, 0, [0], varString, [ccFastCall], varString);
    {  function InsertExpression: String; }
    AddDGet(TfrReportDesigner, 'InsertExpression', @TfrReportDesigner.InsertExpression, 0, [0], varString, [ccFastCall], varString);
    AddGet(TfrReportDesigner, 'Modified', TfrReportDesigner_Read_Modified, 0, [0], varBoolean);
    AddSet(TfrReportDesigner, 'Modified', TfrReportDesigner_Write_Modified, 0, [varBoolean]);
   { TfrDataManager }
    AddClass('FR_CLASS', TfrDataManager, 'TfrDataManager');
    {  procedure Clear; }
    AddDGet(TfrDataManager, 'Clear', @TfrDataManager.Clear, 0, [0], varEmpty, [ccFastCall], varBoolean);
    {  procedure LoadFromStream(Stream: TStream); }
    AddDGet(TfrDataManager, 'LoadFromStream', @TfrDataManager.LoadFromStream, 1, [varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure SaveToStream(Stream: TStream); }
    AddDGet(TfrDataManager, 'SaveToStream', @TfrDataManager.SaveToStream, 1, [varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure BeforePreparing; }
    AddDGet(TfrDataManager, 'BeforePreparing', @TfrDataManager.BeforePreparing, 0, [0], varEmpty, [ccFastCall], varBoolean);
    {  procedure AfterPreparing; }
    AddDGet(TfrDataManager, 'AfterPreparing', @TfrDataManager.AfterPreparing, 0, [0], varEmpty, [ccFastCall], varBoolean);
    AddGet(TfrDataManager, 'PrepareDataSet', TfrDataManager_PrepareDataSet, 1, [varEmpty], varBoolean);
    {  function ShowParamsDialog: Boolean; }
    AddDGet(TfrDataManager, 'ShowParamsDialog', @TfrDataManager.ShowParamsDialog, 0, [0], varBoolean, [ccFastCall], varBoolean);
    {  procedure AfterParamsDialog; }
    AddDGet(TfrDataManager, 'AfterParamsDialog', @TfrDataManager.AfterParamsDialog, 0, [0], varEmpty, [ccFastCall], varBoolean);
   { TfrObjEditorForm }
    AddClass('FR_CLASS', TfrObjEditorForm, 'TfrObjEditorForm');
    {  function ShowEditor(View: TfrView): TModalResult; }
    AddDGet(TfrObjEditorForm, 'ShowEditor', @TfrObjEditorForm.ShowEditor, 1, [varObject], varEmpty, [ccFastCall], varEmpty);
   { TfrExportFilter }
    AddClass('FR_CLASS', TfrExportFilter, 'TfrExportFilter');
    AddGet(TfrExportFilter, 'Create', TfrExportFilter_Create, 1, [varObject], varEmpty);
    {  function ShowModal: Word; }
    AddDGet(TfrExportFilter, 'ShowModal', @TfrExportFilter.ShowModal, 0, [0], varSmallint, [ccFastCall], varSmallInt);
    {  procedure OnBeginDoc; }
    AddDGet(TfrExportFilter, 'OnBeginDoc', @TfrExportFilter.OnBeginDoc, 0, [0], varEmpty, [ccFastCall], varSmallInt);
    {  procedure OnEndDoc; }
    AddDGet(TfrExportFilter, 'OnEndDoc', @TfrExportFilter.OnEndDoc, 0, [0], varEmpty, [ccFastCall], varSmallInt);
    {  procedure OnBeginPage; }
    AddDGet(TfrExportFilter, 'OnBeginPage', @TfrExportFilter.OnBeginPage, 0, [0], varEmpty, [ccFastCall], varSmallInt);
    {  procedure OnEndPage; }
    AddDGet(TfrExportFilter, 'OnEndPage', @TfrExportFilter.OnEndPage, 0, [0], varEmpty, [ccFastCall], varSmallInt);
    {  procedure OnData(x, y: Integer; View: TfrView); }
    AddDGet(TfrExportFilter, 'OnData', @TfrExportFilter.OnData, 3, [varInteger, varInteger, varObject], varEmpty, [ccFastCall], varSmallInt);
    AddGet(TfrExportFilter, 'OnText', TfrExportFilter_OnText, 6, [varEmpty, varInteger, varInteger, varString, varInteger, varObject], varSmallInt);
    AddGet(TfrExportFilter, 'Default', TfrExportFilter_Read_Default, 0, [0], varBoolean);
    AddSet(TfrExportFilter, 'Default', TfrExportFilter_Write_Default, 0, [varBoolean]);
    AddGet(TfrExportFilter, 'ShowDialog', TfrExportFilter_Read_ShowDialog, 0, [0], varBoolean);
    AddSet(TfrExportFilter, 'ShowDialog', TfrExportFilter_Write_ShowDialog, 0, [varBoolean]);
   { TfrFunctionLibrary }
    AddClass('FR_CLASS', TfrFunctionLibrary, 'TfrFunctionLibrary');
    AddGet(TfrFunctionLibrary, 'Create', TfrFunctionLibrary_Create, 0, [0], varBoolean);
    AddGet(TfrFunctionLibrary, 'OnFunction', TfrFunctionLibrary_OnFunction, 5, [varString, varEmpty, varEmpty, varEmpty, varEmpty or varByRef], varBoolean);
    AddGet(TfrFunctionLibrary, 'DoFunction', TfrFunctionLibrary_DoFunction, 5, [varInteger, varEmpty, varEmpty, varEmpty, varEmpty or varByRef], varBoolean);
    {  procedure AddFunctionDesc(FuncName, Category, Description: String); }
    AddDGet(TfrFunctionLibrary, 'AddFunctionDesc', @TfrFunctionLibrary.AddFunctionDesc, 3, [varString, varString, varString], varEmpty, [ccFastCall], varBoolean);
   { TfrCompressor }
    AddClass('FR_CLASS', TfrCompressor, 'TfrCompressor');
    AddGet(TfrCompressor, 'Create', TfrCompressor_Create, 0, [0], varBoolean);
    {  procedure Compress(StreamIn, StreamOut: TStream); }
    AddDGet(TfrCompressor, 'Compress', @TfrCompressor.Compress, 2, [varObject, varObject], varEmpty, [ccFastCall], varBoolean);
    {  procedure DeCompress(StreamIn, StreamOut: TStream); }
    AddDGet(TfrCompressor, 'DeCompress', @TfrCompressor.DeCompress, 2, [varObject, varObject], varEmpty, [ccFastCall], varBoolean);
   { TfrInstalledFunctions }
    AddClass('FR_CLASS', TfrInstalledFunctions, 'TfrInstalledFunctions');
    AddGet(TfrInstalledFunctions, 'Create', TfrInstalledFunctions_Create, 0, [0], varBoolean);
    {  procedure Add(FunctionLibrary: TfrFunctionLibrary; FuncName, Category, Description: String); }
    AddDGet(TfrInstalledFunctions, 'Add', @TfrInstalledFunctions.Add, 4, [varObject, varString, varString, varString], varEmpty, [ccFastCall], varBoolean);
    {  function GetFunctionDesc(FuncName: String): String; }
    AddDGet(TfrInstalledFunctions, 'GetFunctionDesc', @TfrInstalledFunctions.GetFunctionDesc, 1, [varString], varString, [ccFastCall], varString);
    {  procedure GetCategoryList(List: TStrings); }
    AddDGet(TfrInstalledFunctions, 'GetCategoryList', @TfrInstalledFunctions.GetCategoryList, 1, [varObject], varEmpty, [ccFastCall], varString);
    {  procedure GetFunctionList(Category: String; List: TStrings); }
    AddDGet(TfrInstalledFunctions, 'GetFunctionList', @TfrInstalledFunctions.GetFunctionList, 2, [varString, varObject], varEmpty, [ccFastCall], varString);
   { TfrLocale }
    AddClass('FR_CLASS', TfrLocale, 'TfrLocale');
    AddGet(TfrLocale, 'Create', TfrLocale_Create, 0, [0], varString);
    {  function LoadBmp(ID: String): HBitmap; }
    AddDGet(TfrLocale, 'LoadBmp', @TfrLocale.LoadBmp, 1, [varString], varEmpty, [ccFastCall], varEmpty);
    {  function LoadStr(ID: Integer): String; }
    AddDGet(TfrLocale, 'LoadStr', @TfrLocale.LoadStr, 1, [varInteger], varString, [ccFastCall], varString);
    {  procedure LoadDll(Name: String); }
    AddDGet(TfrLocale, 'LoadDll', @TfrLocale.LoadDll, 1, [varString], varEmpty, [ccFastCall], varString);
    {  procedure UnloadDll; }
    AddDGet(TfrLocale, 'UnloadDll', @TfrLocale.UnloadDll, 0, [0], varEmpty, [ccFastCall], varString);
    AddGet(TfrLocale, 'LocalizedPropertyNames', TfrLocale_Read_LocalizedPropertyNames, 0, [0], varBoolean);
    AddSet(TfrLocale, 'LocalizedPropertyNames', TfrLocale_Write_LocalizedPropertyNames, 0, [varBoolean]);
   { TfrGlobals }
    AddClass('FR_CLASS', TfrGlobals, 'TfrGlobals');
    AddGet(TfrGlobals, 'Create', TfrGlobals_Create, 0, [0], varBoolean);
    {  procedure Localize; }
    AddDGet(TfrGlobals, 'Localize', @TfrGlobals.Localize, 0, [0], varEmpty, [ccFastCall], varBoolean);
    AddFun('FR_CLASS', 'frCreateObject', TfrGlobalsFastReport_frCreateObject, 2, [varEmpty, varString], varObject);
    AddFun('FR_CLASS', 'frRegisterObject', TfrGlobalsFastReport_frRegisterObject, 3, [varEmpty, varObject, varString], varObject);
    AddFun('FR_CLASS', 'frRegisterControl', TfrGlobalsFastReport_frRegisterControl, 3, [varEmpty, varObject, varString], varObject);
    AddFun('FR_CLASS', 'frUnRegisterObject', TfrGlobalsFastReport_frUnRegisterObject, 1, [varEmpty], varObject);
    AddFun('FR_CLASS', 'frRegisterExportFilter', TfrGlobalsFastReport_frRegisterExportFilter, 3, [varObject, varString, varString], varObject);
    AddFun('FR_CLASS', 'frUnRegisterExportFilter', TfrGlobalsFastReport_frUnRegisterExportFilter, 1, [varObject], varObject);
    AddFun('FR_CLASS', 'frRegisterFunctionLibrary', TfrGlobalsFastReport_frRegisterFunctionLibrary, 1, [varEmpty], varObject);
    AddFun('FR_CLASS', 'frUnRegisterFunctionLibrary', TfrGlobalsFastReport_frUnRegisterFunctionLibrary, 1, [varEmpty], varObject);
    AddFun('FR_CLASS', 'frRegisterTool', TfrGlobalsFastReport_frRegisterTool, 3, [varString, varObject, varEmpty], varObject);
    AddFun('FR_CLASS', 'frAddFunctionDesc', TfrGlobalsFastReport_frAddFunctionDesc, 4, [varObject, varString, varString, varString], varObject);
    AddFun('FR_CLASS', 'GetDefaultDataSet', TfrGlobalsFastReport_GetDefaultDataSet, 0, [0], varEmpty);
    AddFun('FR_CLASS', 'frLocale', TfrGlobalsFastReport_frLocale, 0, [0], varObject);
  end;    { with }
end;    { RegisterFastReportAdapter }
*)

end.

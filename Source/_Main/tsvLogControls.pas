unit tsvLogControls;

interface

uses Windows, Classes, controls, Graphics, extctrls, tabs, Messages, imglist,
     menus, clipbrd;

type
  TtsvLogs=class;
  TtsvLogsItem=class;
  TtsvLogItem=class;

  TtsvLogItemCaption=class(TCollectionItem)
  private
    FAlignment: TAlignment;
    FCaption: String;
    FBrush: TBrush;
    FFont: TFont;
    FPen: TPen;
    FWidth: Integer;
    FAutoWidth: Boolean;
    FVisible: Boolean;
    FData: Pointer;
    procedure SetCaption(Value: string);
    procedure SetBrush(Value: TBrush);
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetAlignment(Value: TAlignment);
    procedure SetWidth(Value: Integer);
    procedure SetAutoWidth(Value: Boolean);
    procedure SetVisible(Value: Boolean);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
    property Data: Pointer read FData write FData;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property AutoWidth: Boolean read FAutoWidth write SetAutoWidth;
    property Caption: String read FCaption write SetCaption;
    property Brush: TBrush read FBrush write SetBrush;
    property Font: TFont read FFont write SetFont;
    property Pen: TPen read FPen write SetPen;
    property Width: Integer read FWidth write SetWidth;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TtsvLogItemCaptionClass=class of TtsvLogItemCaption;

  TtsvLogItemCaptions=class(Tcollection)
  private
    FLogItem: TtsvLogItem;
    function GetLogItemCaption(Index: Integer): TtsvLogItemCaption;
    procedure SetLogItemCaption(Index: Integer; Value: TtsvLogItemCaption);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TtsvLogItem; tsvLogItemCaptionClass: TtsvLogItemCaptionClass);
    destructor Destroy; override;
    function  Add: TtsvLogItemCaption;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TtsvLogItemCaption;
    property Items[Index: Integer]: TtsvLogItemCaption read GetLogItemCaption write SetLogItemCaption;
  end;

  TtsvLogItem=class(TCollectionItem)
  private
    FAlignment: TAlignment;
    FCaption: String;
    FBrush: TBrush;
    FFont: TFont;
    FPen: TPen;
    FImageIndex: TImageIndex;
    FSelected: Boolean;
    FCaptions: TtsvLogItemCaptions;
    FMaxRow: Integer;
    FVisible: Boolean;
    FData: Pointer;
    procedure SetCaption(Value: string);
    procedure SetBrush(Value: TBrush);
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetAlignment(Value: TAlignment);
    function GetSelected: Boolean;
    procedure SetSelected(Value: Boolean);
    procedure SetMaxRow(Value: Integer);
    procedure SetVisible(Value: Boolean);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
    property Data: Pointer read FData write FData;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property Caption: String read FCaption write SetCaption;
    property Captions: TtsvLogItemCaptions read FCaptions;
    property Brush: TBrush read FBrush write SetBrush;
    property Font: TFont read FFont write SetFont;
    property Pen: TPen read FPen write SetPen;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex;
    property Selected: Boolean read GetSelected write SetSelected;
    property MaxRow: Integer read FMaxRow write SetMaxRow;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TtsvLogItemClass=class of TtsvLogItem;

  TtsvLogItems=class(TCollection)
  private
    isUpdated: Boolean;
    FLogsItem: TtsvLogsItem;
    function GetLogItem(Index: Integer): TtsvLogItem;
    procedure SetLogItem(Index: Integer; Value: TtsvLogItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TtsvLogsItem; tsvLogItemClass: TtsvLogItemClass);
    destructor Destroy; override;
    function  Add: TtsvLogItem;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure EndUpdate; override;
    function Insert(Index: Integer): TtsvLogItem;
    property Items[Index: Integer]: TtsvLogItem read GetLogItem write SetLogItem;
  end;

  TtsvLogsItem=class(TCollectionItem)
  private
    FLog: TCustomControl;
    FLogItems: TtsvLogItems;
    FItemIndex: Integer;
    FHideSelection: Boolean;
    FMultiSelect: Boolean;
    FHint: String;
    FData: Pointer;
    function GetCaption: String;
    procedure SetCaption(Value: string);
    procedure SetItemIndex(Value: Integer);
    function isValidIndex(Index: Integer): Boolean;
    procedure SetHideSelection(Value: Boolean);
    procedure SetMultiSelect(Value: Boolean);
    procedure SetHint(Value: string);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
    procedure InvalidateLast;
    procedure Invalidate;
    procedure UpdateScrollRange;
    function SelCount: Integer;
    procedure SaveToStreamAsText(Stream: TStream; const OnlySelected: Boolean);
    procedure SaveToFileAsText(FileName: string);
    procedure CopyToClipboard;
    property Items: TtsvLogItems read FLogItems;
    property Data: Pointer read FData write FData;
  published
    property Caption: String read GetCaption write SetCaption;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property HideSelection: Boolean read FHideSelection write SetHideSelection;
    property Hint: String read FHint write SetHint;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect; 
  end;

  TtsvLogsItemClass=class of TtsvLogsItem;

  TtsvLogsItems=class(TCollection)
  private
    isUpdated: Boolean;
    FLogs: TtsvLogs;
    FTabSet: TTabSet;
    FOldIndex: Integer;
    function GetLogsItem(Index: Integer): TtsvLogsItem;
    procedure SetLogsItem(Index: Integer; Value: TtsvLogsItem);
    procedure TabSetOnChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    function isValidIndex(Index: Integer): Boolean;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TtsvLogs; tsvLogsItemClass: TtsvLogsItemClass);
    destructor Destroy; override;
    function  Add: TtsvLogsItem;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure EndUpdate; override;
    function Insert(Index: Integer): TtsvLogsItem;
    property Items[Index: Integer]: TtsvLogsItem read GetLogsItem write SetLogsItem;
  end;

  TOnLogTabChange=procedure (Sender: TObject; NewTab: Integer)of object;

  TtsvLogs=class(TCustomControl)
  private
    FImages: TCustomImageList;
    FItems: TTsvLogsItems;
    FLogPopupMenu: TPopupMenu;
    FLogKeyDown: TKeyEvent;
    FLogDblClick: TNotifyEvent;
    FLogTabChange: TOnLogTabChange;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    procedure SetImages(Value: TCustomImageList);
    function GetNewHeigth: Integer;
    procedure SetLogPopupMenu(Value: TPopupMenu);
    procedure SetLogKeyDown(Value: TKeyEvent);
    procedure SetLogDblClick(Value: TNotifyEvent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure GetTabOrderList(List: TList); override;
    procedure SetFocus; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;

    property Items: TTsvLogsItems read FItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property Images: TCustomImageList read FImages write SetImages;
    property LogPopupMenu: TPopupMenu read FLogPopupMenu write SetLogPopupMenu;
    property LogKeyDown: TKeyEvent read FLogKeyDown write SetLogKeyDown;
    property LogDblClick: TNotifyEvent read FLogDblClick write SetLogDblClick;
    property LogTabChange: TOnLogTabChange read FLogTabChange write FLogTabChange;
    property Font;
  end;

implementation

uses Forms, SysUtils;

const
  ConstRowHeight=16;

type
  TtsvLogTabSet=class(TTabSet)
  private
    FLogs: TtsvLogs;
    OldItem: Integer;
  public
    constructor CreateAsLogs(Logs: TtsvLogs; AOwner: TComponent);
    destructor Destroy; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  end;

  TtsvLog=class(TCustomPanel)
  private
    FLogsItem: TtsvLogsItem;
    FTopRow: Integer;
    FLogs: TtsvLogs;
    FCurrentSelected: Boolean;
    procedure ModifyScrollBar(ScrollCode: Integer);
    procedure UpdateScrollRange;
    procedure MoveTop(NewTop: Integer);
    function VisibleRowCount(TopRow: Integer): Integer;
    function GetRowHeigth(Index: Integer): Integer;
    function YToRow(Y: Integer): Integer;
    function MoveCurrent(NewCur: Integer; Scroll, UnSelect: Boolean): Boolean;
    function GetVisibleRowTop(Index: Integer): Integer;
    procedure InvalidateItem(Index: Integer);
    function GetItemRect(Index: Integer): TRect;
    procedure DrawItem(Index: Integer);
    procedure UnSelectAll;
    procedure InvalidateSelection;
    procedure InvalidateBottom(Index: Integer);
  public
    procedure Paint;override;
    constructor CreateAsLogsItem(AOwner: TComponent; LogsItem: TtsvLogsItem);
    destructor Destroy;override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd;override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                      X, Y: Integer); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMMouseWheel(var Message: TWMMouseWheel);message WM_MOUSEWHEEL;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;

    property PopupMenu;

  end;

{ TtsvLogTabSet }

constructor TtsvLogTabSet.CreateAsLogs(Logs: TtsvLogs; AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogs:=Logs;
  ShowHint:=true;
end;

destructor TtsvLogTabSet.Destroy;
begin
  inherited;
end;

procedure TtsvLogTabSet.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TtsvLogTabSet.CMHintShow(var Message: TMessage);
begin
  inherited;
end;

procedure TtsvLogTabSet.CMMouseEnter(var Message: TMessage);
begin
  inherited;
end;

procedure TtsvLogTabSet.CMMouseLeave(var Message: TMessage);
begin
  OldItem:=-1;
  Application.CancelHint;
  Hint:='';
  inherited;
end;

procedure TtsvLogTabSet.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  item: Integer;
begin
  inherited MouseMove(Shift,X,Y);
  GetCursorPos(pt);
  pt:=ScreenToClient(pt);
  item:=ItemAtPos(pt);
  if (item<>-1)and (Item<>OldItem) then begin
    Hint:=FLogs.Items.Items[item].Hint;
    Application.ActivateHint(pt);
  end else begin
    if Item=-1 then begin
     Application.CancelHint;
     Hint:='';
    end; 
  end;
  OldItem:=Item;
end;

{ TtsvLogItemCaption }

constructor TtsvLogItemCaption.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FBrush:=TBrush.Create;
  FFont:=TFont.Create;
  FPen:=TPen.Create;
  FVisible:=true;
end;

destructor TtsvLogItemCaption.Destroy;
begin
  FPen.Free;
  FFont.Free;
  FBrush.Free;
  inherited;
end;

procedure TtsvLogItemCaption.SetCaption(Value: string);
begin
  if FCaption<>Value then begin
    FCaption:=Value;
    with TtsvLog(TtsvLogItems(TtsvLogItemCaptions(Collection).FLogItem.Collection).FLogsItem.FLog) do begin
      InvalidateItem(TtsvLogItemCaptions(Collection).FLogItem.Index);
    end;       
  end;
end;

procedure TtsvLogItemCaption.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TtsvLogItemCaption.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TtsvLogItemCaption.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TtsvLogItemCaption.SetAlignment(Value: TAlignment);
begin
  if FAlignment<>Value then begin
    FAlignment:=Value;
    with TtsvLog(TtsvLogItems(TtsvLogItemCaptions(Collection).FLogItem.Collection).FLogsItem.FLog) do begin
      InvalidateItem(TtsvLogItemCaptions(Collection).FLogItem.Index);
    end;       
  end;  
end;

procedure TtsvLogItemCaption.SetWidth(Value: Integer);
begin
  if FWidth<>Value then begin
    FWidth:=Value;
    with TtsvLog(TtsvLogItems(TtsvLogItemCaptions(Collection).FLogItem.Collection).FLogsItem.FLog) do begin
      InvalidateItem(TtsvLogItemCaptions(Collection).FLogItem.Index);
    end;       
  end;  
end;

procedure TtsvLogItemCaption.SetAutoWidth(Value: Boolean);
begin
  if FAutoWidth<>Value then begin
    FAutoWidth:=Value;
    with TtsvLog(TtsvLogItems(TtsvLogItemCaptions(Collection).FLogItem.Collection).FLogsItem.FLog) do begin
      InvalidateItem(TtsvLogItemCaptions(Collection).FLogItem.Index);
    end;       
  end;  
end;

procedure TtsvLogItemCaption.SetVisible(Value: Boolean);
begin
  if FVisible<>Value then begin
    FVisible:=Value;
    with TtsvLog(TtsvLogItems(TtsvLogItemCaptions(Collection).FLogItem.Collection).FLogsItem.FLog) do begin
      InvalidateItem(TtsvLogItemCaptions(Collection).FLogItem.Index);
    end;       
  end;
end;

{ TtsvLogItemCaptions }

constructor TtsvLogItemCaptions.Create(AOwner: TtsvLogItem; tsvLogItemCaptionClass: TtsvLogItemCaptionClass);
begin
  inherited Create(tsvLogItemCaptionClass);
  FLogItem:= AOwner;
end;

destructor TtsvLogItemCaptions.Destroy;
begin
  inherited;
end;

function TtsvLogItemCaptions.GetLogItemCaption(Index: Integer): TtsvLogItemCaption;
begin
  Result := TtsvLogItemCaption(inherited Items[Index]);
end;

procedure TtsvLogItemCaptions.SetLogItemCaption(Index: Integer; Value: TtsvLogItemCaption);
begin
  Items[Index].Assign(Value);
end;

function TtsvLogItemCaptions.GetOwner: TPersistent;
begin
  Result := FLogItem;
end;

procedure TtsvLogItemCaptions.Update(Item: TCollectionItem);
begin
  inherited;
end;

function TtsvLogItemCaptions.Add: TtsvLogItemCaption;
begin
  Result := TtsvLogItemCaption(inherited Add);
end;

procedure TtsvLogItemCaptions.Assign(Source: TPersistent);
begin
  if Source is TtsvLogItem then begin
  end else
   inherited Assign(Source);
end;

procedure TtsvLogItemCaptions.Clear;
begin
  inherited Clear;
end;

procedure TtsvLogItemCaptions.Delete(Index: Integer);
begin
  Inherited Delete(Index);
end;

function TtsvLogItemCaptions.Insert(Index: Integer): TtsvLogItemCaption;
begin
  Result:=TtsvLogItemCaption(Inherited Insert(Index));
end;


{ TtsvLogItem }

constructor TtsvLogItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FBrush:=TBrush.Create;
  FFont:=TFont.Create;
  FPen:=TPen.Create;
  FImageIndex:=-1;
  FMaxRow:=3;
  FCaptions:=TtsvLogItemCaptions.Create(Self,TtsvLogItemCaption);
  FVisible:=true;
end;

destructor TtsvLogItem.Destroy;
begin
  FCaptions.Free;
  FPen.Free;
  FFont.Free;
  FBrush.Free;
  inherited;
end;

procedure TtsvLogItem.SetCaption(Value: string);
begin
  if FCaption<>Value then
    FCaption:=Value;
end;

procedure TtsvLogItem.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TtsvLogItem.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TtsvLogItem.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TtsvLogItem.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex<>Value then
    FImageIndex:=Value;
end;

procedure TtsvLogItem.SetAlignment(Value: TAlignment);
begin
  if FAlignment<>Value then
    FAlignment:=Value;
end;

function TtsvLogItem.GetSelected: Boolean;
begin
  Result:=FSelected or (TtsvLogItems(Collection).FLogsItem.ItemIndex=Index);
end;

procedure TtsvLogItem.SetSelected(Value: Boolean);
begin
  if FSelected<>Value then
    FSelected:=Value;
end;

procedure TtsvLogItem.SetMaxRow(Value: Integer);
begin
  if FMaxRow<>Value then
    FMaxRow:=Value;
end;

procedure TtsvLogItem.SetVisible(Value: Boolean);
begin
  if FVisible<>Value then begin
   FVisible:=Value;
   TtsvLog(TtsvLogItems(Collection).FLogsItem.FLog).InvalidateBottom(Index);
   TtsvLog(TtsvLogItems(Collection).FLogsItem.FLog).UpdateScrollRange;
  end; 
end;

{ TtsvLogItems }

constructor TtsvLogItems.Create(AOwner: TtsvLogsItem; tsvLogItemClass: TtsvLogItemClass);
begin
  inherited Create(tsvLogItemClass);
  FLogsItem:= AOwner;
end;

destructor TtsvLogItems.Destroy;
begin
  inherited;
end;

function TtsvLogItems.GetLogItem(Index: Integer): TtsvLogItem;
begin
  Result := TtsvLogItem(inherited Items[Index]);
end;

procedure TtsvLogItems.SetLogItem(Index: Integer; Value: TtsvLogItem);
begin
  Items[Index].Assign(Value);
end;

function TtsvLogItems.GetOwner: TPersistent;
begin
  Result := FLogsItem;
end;

procedure TtsvLogItems.Update(Item: TCollectionItem);
begin
  inherited;
end;

function TtsvLogItems.Add: TtsvLogItem;
begin
  Result := TtsvLogItem(inherited Add);
  if FLogsItem.ItemIndex<>-1 then FLogsItem.ItemIndex:=FLogsItem.ItemIndex+1;
  if not isUpdated then begin
   TtsvLog(FLogsItem.FLog).InvalidateItem(Result.Index);
   TtsvLog(FLogsItem.FLog).UpdateScrollRange;
  end; 
end;

procedure TtsvLogItems.Assign(Source: TPersistent);
begin
  if Source is TtsvLogItems then begin
  end else
   inherited Assign(Source);
end;

procedure TtsvLogItems.Clear;
begin
  inherited Clear;
  FLogsItem.ItemIndex:=-1;
  if not isUpdated then begin
   TtsvLog(FLogsItem.FLog).UpdateScrollRange;
  end; 
end;

procedure TtsvLogItems.BeginUpdate;
begin
  inherited;
  isUpdated:=true;
end;

procedure TtsvLogItems.Delete(Index: Integer);
begin
  Inherited Delete(Index);
  if Index=FLogsItem.ItemIndex then FLogsItem.ItemIndex:=-1;
  if count<=FLogsItem.ItemIndex then FLogsItem.ItemIndex:=-1;
  if not isUpdated then begin
   TtsvLog(FLogsItem.FLog).InvalidateBottom(Index);
   TtsvLog(FLogsItem.FLog).UpdateScrollRange;
  end; 
end;

procedure TtsvLogItems.EndUpdate;
begin
  isUpdated:=false; 
  inherited;
  TtsvLog(FLogsItem.FLog).Invalidate;
  TtsvLog(FLogsItem.FLog).UpdateScrollRange;
end;

function TtsvLogItems.Insert(Index: Integer): TtsvLogItem;
begin
  Result:=TtsvLogItem(Inherited Insert(Index));
  if FLogsItem.ItemIndex<>-1 then FLogsItem.ItemIndex:=FLogsItem.ItemIndex+1;
  if not isUpdated then begin
   TtsvLog(FLogsItem.FLog).InvalidateBottom(Index);
   TtsvLog(FLogsItem.FLog).UpdateScrollRange;
  end; 
end;

{ TtsvLogsItem }

constructor TtsvLogsItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  TtsvLogsItems(Collection).FTabSet.Tabs.Add('');
  FLogItems:=TtsvLogItems.Create(Self,TtsvLogItem);
  FLog:=TtsvLog.CreateAsLogsItem(nil,Self);
  FLog.Align:=alClient;
  FLog.Parent:=TtsvLogsItems(Collection).FLogs;
  FLog.Visible:=false;
  TtsvLog(FLog).PopupMenu:=TtsvLogsItems(Collection).FLogs.FLogPopupMenu;
  TtsvLog(FLog).OnKeyDown:=TtsvLogsItems(Collection).FLogs.FLogKeyDown;
  TtsvLog(FLog).OnDblClick:=TtsvLogsItems(Collection).FLogs.FLogDblClick;

  FItemIndex:=-1;
  FHideSelection:=false;
end;

destructor TtsvLogsItem.Destroy;
begin
  FLog.Free;
  FLogItems.Free;
  TtsvLogsItems(Collection).FTabSet.Tabs.Delete(Index);
  inherited;
end;

function TtsvLogsItem.GetCaption: String;
begin
  Result:=TtsvLogsItems(Collection).FTabSet.Tabs.Strings[Index];
end;

procedure TtsvLogsItem.SetCaption(Value: string);
begin
  TtsvLogsItems(Collection).FTabSet.Tabs.Strings[Index]:=Value;
  TtsvLog(FLog).Caption:=Value;
end;

function TtsvLogsItem.isValidIndex(Index: Integer): Boolean;
begin
  Result:=(Index<FLogItems.Count) and (Index>-2);
end;

procedure TtsvLogsItem.SetItemIndex(Value: Integer);
begin
  if FItemIndex<>Value then
   if isValidIndex(Value) then
     FItemIndex:=Value;
end;

procedure TtsvLogsItem.Invalidate;
begin
  FLog.Invalidate;
end;

procedure TtsvLogsItem.InvalidateLast;
begin
  if Items.Count>0 then
   TtsvLog(FLog).InvalidateItem(Items.Count-1);
end;

procedure TtsvLogsItem.UpdateScrollRange;
begin
  TtsvLog(FLog).UpdateScrollRange;
end;

procedure TtsvLogsItem.SetHideSelection(Value: Boolean);
begin
 if FHideSelection<>Value then
   FHideSelection:=Value;
end;

procedure TtsvLogsItem.SetMultiSelect(Value: Boolean);
begin
  if FMultiSelect<>Value then begin
    FMultiSelect:=Value;
  end;
end;

function TtsvLogsItem.SelCount: Integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to FLogItems.Count-1 do begin
    Result:=Result+Ord(FLogItems.Items[I].Selected);
  end;
end;

procedure TtsvLogsItem.SaveToStreamAsText(Stream: TStream; const OnlySelected: Boolean);
var
  j: Integer;
  logitem: TtsvLogItem;
  lic: TtsvLogItemCaption;
  S: string;
Const
  TabConst=#9;
  ReturnConst=#13#10;

  procedure SetStringS;
  var
    x: Integer;
  begin
    if logitem.Captions.Count>0 then begin
      for x:=0 to logitem.Captions.Count-1 do begin
       lic:=logitem.Captions.Items[x];
       S:=S+TabConst+lic.Caption;
      end;
    end else begin
      S:=logitem.Caption;
    end;
  end;

begin
    for j:=0 to FLogItems.Count-1 do begin
      logitem:=FLogItems.Items[j];
      S:='';
      if not OnlySelected then SetStringS
      else if logitem.Selected then SetStringS;
      if S<>'' then begin
       S:=S+ReturnConst;
       Stream.Write(Pointer(S)^,Length(S));
      end;
    end;
end;

procedure TtsvLogsItem.SaveToFileAsText(FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmCreate);
    SaveToStreamAsText(fs,false);
  finally
    fs.Free;
  end;
end;

procedure TtsvLogsItem.CopyToClipboard;
var
  CopyText: string;
  ms: TMemoryStream;
begin
  ms:=TMemoryStream.Create;
  try
    SaveToStreamAsText(ms,true);
    SetLength(CopyText,ms.Size);
    Move(ms.Memory^,Pointer(CopyText)^,ms.Size);
    Clipboard.AsText:=CopyText;
  finally
    ms.Free;
  end; 
end;

procedure TtsvLogsItem.SetHint(Value: string);
begin
 if FHint<Value then begin
   FHint:=Value;
 end;
end;


{ TtsvLogsItems }

constructor TtsvLogsItems.Create(AOwner: TtsvLogs; tsvLogsItemClass: TtsvLogsItemClass);
begin
  inherited Create(tsvLogsItemClass);
  FLogs:= AOwner;
  FTabSet:=TtsvLogTabSet.CreateAsLogs(FLogs,nil);
  FTabSet.Parent:=FLogs;
  FTabSet.Align:=alBottom;
  FTabSet.OnChange:=TabSetOnChange;
  FTabSet.TabStop:=false;
  FTabSet.PopupMenu:=AOwner.LogPopupMenu;
end;

destructor TtsvLogsItems.Destroy;
begin
  inherited Destroy;
  FTabSet.Free;
end;

function TtsvLogsItems.isValidIndex(Index: Integer): Boolean;
begin
  Result:=(Index<Count) and (Index>-1);
end;

procedure TtsvLogsItems.TabSetOnChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
var
  LastFocused: Boolean;
begin
  LastFocused:=false;
  if isValidIndex(FOldIndex) then begin
    LastFocused:=TtsvLogsItem(Items[FOldIndex]).FLog.Focused;
    TtsvLogsItem(Items[FOldIndex]).FLog.Visible:=false;
  end;   
  if isValidIndex(NewTab) then begin
    TtsvLogsItem(Items[NewTab]).FLog.Visible:=true;
    if LastFocused then
     TtsvLogsItem(Items[NewTab]).FLog.SetFocus;
    TtsvLog(TtsvLogsItem(Items[NewTab]).FLog).UpdateScrollRange;
  end;
  if Assigned(FLogs.FLogTabChange) then
   FLogs.FLogTabChange(Sender,NewTab);
  FOldIndex:=NewTab;
end;

function TtsvLogsItems.GetLogsItem(Index: Integer): TtsvLogsItem;
begin
  Result := TtsvLogsItem(inherited Items[Index]);
end;

procedure TtsvLogsItems.SetLogsItem(Index: Integer; Value: TtsvLogsItem);
begin
  Items[Index].Assign(Value);
end;

function TtsvLogsItems.GetOwner: TPersistent;
begin
  Result := FLogs;
end;

procedure TtsvLogsItems.Update(Item: TCollectionItem);
begin
  if (FLogs = nil) or (csLoading in FLogs.ComponentState) then Exit;
end;

function TtsvLogsItems.Add: TtsvLogsItem;
begin
  Result := TtsvLogsItem(inherited Add);
end;

procedure TtsvLogsItems.Assign(Source: TPersistent);
begin
end;

procedure TtsvLogsItems.BeginUpdate;
begin
  isUpdated:=true;
  FTabSet.Tabs.BeginUpdate;
  inherited;
end;

procedure TtsvLogsItems.Clear;
begin
  inherited Clear;
end;

procedure TtsvLogsItems.Delete(Index: Integer);
var
  isChange: Boolean;
begin
  Inherited Delete(Index);
  if not isUpdated then begin
    FLogs.ItemIndex:=Count-1;
    isChange:=true;
    TabSetOnChange(FLogs,FLogs.ItemIndex,isChange);
  end;
end;

procedure TtsvLogsItems.EndUpdate;
begin
  FTabSet.Tabs.EndUpdate;
  inherited;
  isUpdated:=false;
end;

function TtsvLogsItems.Insert(Index: Integer): TtsvLogsItem;
begin
  Result:=TtsvLogsItem(Inherited Insert(Index));
end;


{ TtsvLogs }

constructor TtsvLogs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BevelOuter:=bvNone;
  TabStop:=true;
  FItems:=TTsvLogsItems.Create(Self,TtsvLogsItem);
end;

destructor TtsvLogs.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TtsvLogs.Paint;
begin
  inherited;
end;

procedure TtsvLogs.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style + WS_TABSTOP;
    WindowClass.style := CS_DBLCLKS;
  end;
end;

procedure TtsvLogs.SetFocus;
begin
  inherited;
  if ItemIndex<>-1 then begin
    FItems.Items[ItemIndex].FLog.SetFocus;
  end;
end;

procedure TtsvLogs.GetTabOrderList(List: TList);
begin
  if ItemIndex<>-1 then begin
    List.Add(FItems.Items[ItemIndex].FLog);
  end;
end;

function TtsvLogs.GetItemIndex: Integer;
begin
  Result:=FItems.FTabSet.TabIndex;
end;

procedure TtsvLogs.SetItemIndex(Value: Integer);
begin
  if FItems.FTabSet.TabIndex<>Value then begin
    FItems.FTabSet.TabIndex:=Value;
  end;
end;

procedure TtsvLogs.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TtsvLogs.SetLogPopupMenu(Value: TPopupMenu);
var
  i: Integer;
begin
  FLogPopupMenu:=Value;
  FItems.FTabSet.PopupMenu:=Value;
  for i:=0 to FItems.Count-1 do begin
    TtsvLog(FItems.Items[i].FLog).PopupMenu:=Value;
  end;
end;

procedure TtsvLogs.Notification(AComponent: TComponent; Operation: TOperation);
var
  i: Integer;
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then begin
    if AComponent = Images then Images := nil;
    if AComponent = PopupMenu then begin
      PopupMenu:=nil;
      for i:=0 to FItems.Count-1 do
        TtsvLog(FItems.Items[i].FLog).PopupMenu:=nil;
    end;
  end;
end;

function TtsvLogs.GetNewHeigth: Integer;
begin
  Result:=ConstRowHeight;
  if Images<>nil then begin
    Result:=Images.Height;
  end;
end;

procedure TtsvLogs.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

procedure TtsvLogs.WMGetDlgCode(var Message: TWMGetDlgCode); 
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TtsvLogs.SetLogKeyDown(Value: TKeyEvent);
var
  i: integer;
begin
  FLogKeyDown:=Value;
  for i:=0 to FItems.Count-1 do
    TtsvLog(FItems.Items[i].FLog).OnKeyDown:=Value;
end;

procedure TtsvLogs.SetLogDblClick(Value: TNotifyEvent);
var
  i: integer;
begin
  FLogDblClick:=Value;
  for i:=0 to FItems.Count-1 do
    TtsvLog(FItems.Items[i].FLog).OnDblClick:=Value;
end;

{ TtsvLog }

constructor TtsvLog.CreateAsLogsItem(AOwner: TComponent; LogsItem: TtsvLogsItem);
const
   PropListStyle = [csCaptureMouse,csOpaque,csDoubleClicks];
begin
  Inherited Create(AOwner);
  if NewStyleControls then
    ControlStyle := PropListStyle else
    ControlStyle := PropListStyle + [csFramed];
  FLogsItem:=LogsItem;
  FLogs:=TtsvLogsItems(FLogsItem.Collection).FLogs;
  BevelOuter:=bvNone;
  BorderStyle:=bsSingle;
  FullRepaint:=false;
  Color:=clWindow;
  FCurrentSelected:=true;
  FTopRow:=0;
end;

destructor TtsvLog.Destroy;
begin
  Inherited;
end;

procedure TtsvLog.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := Style + WS_VSCROLL;
  end;
end;

procedure TtsvLog.CreateWnd;
begin
  inherited;
  ShowScrollBar(Handle, SB_BOTH, False);
end;

procedure TtsvLog.WMVScroll(var Msg: TWMVScroll);
begin
  ModifyScrollBar(Msg.ScrollCode);
end;

procedure TtsvLog.ModifyScrollBar(ScrollCode: Integer);
var
  NewPos, MaxPos: Integer;
  si: TScrollInfo;
begin

  NewPos := FTopRow;

  with si do
  begin
    cbSize := SizeOf(TScrollInfo);
    fMask := SIF_ALL;
    GetScrollInfo(Handle, SB_VERT, si);
    MaxPos := nMax - Integer(nPage) + 1;

    case ScrollCode of
      SB_LINEUP: Dec(NewPos);
      SB_LINEDOWN: Inc(NewPos);
      SB_PAGEUP: Dec(NewPos, nPage);
      SB_PAGEDOWN: Inc(NewPos, nPage);
      SB_THUMBPOSITION, SB_THUMBTRACK: NewPos := nTrackPos;
      SB_TOP: NewPos := nMin;
      SB_BOTTOM: NewPos := MaxPos;
      else Exit;
    end;

    MoveTop(NewPos);
  end;
end;

{ Return mimimum of two signed integers }
function EMax(A, B: Integer): Integer;
asm
{     ->EAX     A
        EDX     B
      <-EAX     Min(A, B) }

        CMP     EAX,EDX
        JGE     @@Exit
        MOV     EAX,EDX
  @@Exit:
end;

procedure TtsvLog.UpdateScrollRange;
var
  si: TScrollInfo;
  diVisibleCount, diCurrentPos: Integer;
begin

  if not HandleAllocated or not Showing then Exit;
  try
    with si do begin
      cbSize := SizeOf(TScrollInfo);
      fMask := SIF_RANGE + SIF_PAGE + SIF_POS;
      nMin := 0;
      diVisibleCount := VisibleRowCount(FTopRow);
      diCurrentPos := FTopRow;

      if FLogsItem.FLogItems.Count<=diVisibleCount then begin
       if diVisibleCount>FLogsItem.FLogItems.Count then begin
        nPage := 0;
        nMax := 0;
       end else begin
        nPage := 0;
        nMax := 0;
       end; 
      end else begin
       nPage := diVisibleCount;
       nMax := FLogsItem.FLogItems.Count-1;
      end;

      if diCurrentPos + diVisibleCount > FLogsItem.FLogItems.Count then
        diCurrentPos := EMax(0,FLogsItem.FLogItems.Count-diVisibleCount);

      nPos := diCurrentPos;
      SetScrollInfo(Handle, SB_VERT, si, True);

      MoveTop(diCurrentPos);
    end;
   finally

   end; 
end;

procedure TtsvLog.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Canvas.Font := Font;
  Invalidate;
  UpdateScrollRange;
end;

procedure TtsvLog.WMSize(var Msg: TWMSize);
begin
  inherited;
  InvalidateBottom(FTopRow);
  UpdateScrollRange;
end;

function TtsvLog.GetVisibleRowTop(Index: Integer): Integer;
var
  i: Integer;
  rh: Integer;
begin
  Result:=0;
  rh:=0;
  for i:=Index downto 0 do begin
   if i<=FLogsItem.FLogItems.Count-1 then begin
    rh:=rh+GetRowHeigth(i);
    if rh>ClientHeight then begin
      Result:=i+1;
      exit;
    end;
   end else begin
    rh:=rh+GetRowHeigth(i-1);
   end;
  end;
end;

procedure TtsvLog.InvalidateSelection;
begin
//  if FLogsItem.ItemIndex<0 then exit;
{  if FLogsItem.ItemIndex-1>=0 then InvalidateItem(FLogsItem.ItemIndex-1);
  if FLogsItem.ItemIndex>=0 then InvalidateItem(FLogsItem.ItemIndex);
  if FLogsItem.ItemIndex+1<=FLogsItem.FLogItems.Count-1 then InvalidateItem(FLogsItem.ItemIndex+1);}
end;

function TtsvLog.MoveCurrent(NewCur: Integer; Scroll, UnSelect: Boolean): Boolean;
var
  NewTop,VertCount: Integer;
begin
  result:=false;
  if NewCur < 0 then NewCur := 0;
  if NewCur >= FLogsItem.FLogItems.Count then NewCur := FLogsItem.FLogItems.Count - 1;
  if NewCur = FLogsItem.ItemIndex then exit;

  if UnSelect then UnSelectAll;

  InvalidateSelection;

  if FLogsItem.ItemIndex>-1 then
    InvalidateItem(FLogsItem.ItemIndex);
  FLogsItem.ItemIndex:=NewCur;
  InvalidateItem(FLogsItem.ItemIndex);

  InvalidateSelection;

  if Scroll then begin
    NewTop:=FTopRow;
//    NewTop:=GetVisibleRowTop(NewCur);
    VertCount := VisibleRowCount(FTopRow);
    if NewCur < NewTop then NewTop := NewCur;
    if NewCur >= NewTop + VertCount then NewTop := NewCur - VertCount + 1;

    MoveTop(NewTop);
  end;

  Result:=true;
end;

procedure TtsvLog.MoveTop(NewTop: Integer);
var
  ShiftY: Integer;
  ScrollArea: TRect;
  ViewCount: Integer;
  i: Integer;
//  MaxRows: Integer;
begin
  if NewTop < 0 then NewTop := 0;
  ViewCount:=VisibleRowCount(FTopRow);
  if (NewTop+ViewCount)>FLogsItem.FLogItems.Count then
    NewTop:=FLogsItem.FLogItems.Count-ViewCount;
  if NewTop = FTopRow then Exit;

  ShiftY:=0;
  if (FTopRow - NewTop)<0 then begin
    for i:=FTopRow to NewTop do begin
      ShiftY:=ShiftY-GetRowHeigth(i);
    end;
  end else begin
    for i:=FTopRow downto NewTop do begin
      ShiftY:=ShiftY+GetRowHeigth(i);
    end;
  end;
  
  FTopRow := NewTop;
  ScrollArea := ClientRect;
  SetScrollPos(Handle, SB_VERT, NewTop, True);
{  MaxRows:=0;
  for i:=FTopRow to ViewCount-1 do
    MaxRows:=MaxRows+GetRowHeigth(i);

{  if Abs(ShiftY) >= MaxRows then
    InvalidateRect(Handle, @ScrollArea, True)
  else}
   InvalidateRect(Handle, @ScrollArea, True);
   ScrollWindowEx(Handle, 0, ShiftY,
      @ScrollArea, @ScrollArea, 0, nil, SW_INVALIDATE);    
end;

function TtsvLog.VisibleRowCount(TopRow: Integer): Integer;
var
  hCur,i,incr: Integer;
begin
  Result:=0;
  hCur:=0;
  incr:=0;
  for i:=TopRow to FLogsItem.FLogItems.Count-1 do begin
    hCur:=hCur+GetRowHeigth(i);
    inc(incr);
    if hCur>ClientHeight then begin
      Result:=incr-1;
      exit;
    end else
     if i=FLogsItem.FLogItems.Count-1 then begin
       Result:=incr;
     end;
  end;
end;

function TtsvLog.GetRowHeigth(Index: Integer): Integer;
var
  str: TStringList;
  i: Integer;
  lic: TtsvLogItemCaption;
  maxH,curH: Integer;
  newCount: Integer;
begin
  Result:=FLogs.GetNewHeigth;
  if FLogsItem.FLogItems.Count=0 then exit;
  str:=TStringList.Create;
  try
    if FLogsItem.FLogItems.Items[Index].Captions.Count=0 then begin
      str.Text:=FLogsItem.FLogItems.Items[Index].Caption;
      newCount:=str.Count;
      if newCount>FLogsItem.FLogItems.Items[Index].MaxRow then
        newCount:=FLogsItem.FLogItems.Items[Index].MaxRow;
      Result:=Canvas.TextHeight('H')*newCount+2;
    end else begin
      maxH:=0;
      for i:=0 to FLogsItem.FLogItems.Items[Index].Captions.Count-1 do begin
        lic:=FLogsItem.FLogItems.Items[Index].Captions.Items[i];
        str.Text:=lic.Caption;
        newCount:=str.Count;
        if newCount>FLogsItem.FLogItems.Items[Index].MaxRow then
          newCount:=FLogsItem.FLogItems.Items[Index].MaxRow;
        curH:=Canvas.TextHeight('H')*newCount+2;
        if curH>maxH then
         maxh:=curH;
      end;
      Result:=maxH;
    end;
    if Result<FLogs.GetNewHeigth then
      Result:=FLogs.GetNewHeigth;
  finally
    str.Free;
  end;
end;

procedure TtsvLog.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  InvalidateItem(FLogsItem.ItemIndex);
end;

procedure TtsvLog.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  InvalidateItem(FLogsItem.ItemIndex);
end;

procedure TtsvLog.CMExit(var Message: TCMExit);
begin
  inherited;
//  Invalidate;
//  InvalidateItem(FLogsItem.ItemIndex);
end;

procedure TtsvLog.CMEnter(var Message: TCMEnter);
begin
  inherited;
  //InvalidateItem(FLogsItem.ItemIndex);
//  Invalidate;
end;

procedure TtsvLog.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TtsvLog.KeyDown(var Key: Word; Shift: TShiftState);
var
  PageHeight, NewCurrent: Integer;
begin
   inherited KeyDown(Key, Shift);
   NewCurrent := FLogsItem.ItemIndex;
   case Key of
    VK_LEFT: begin
      if ssAlt in Shift then
       TtsvLogsItems(FLogsItem.Collection).FTabSet.SelectNext(false);
    end;
    VK_RIGHT: begin
      if ssAlt in Shift then
       TtsvLogsItems(FLogsItem.Collection).FTabSet.SelectNext(true); 
    end;
    VK_UP: Dec(NewCurrent);
    VK_DOWN: Inc(NewCurrent);
    VK_NEXT: begin
      PageHeight := VisibleRowCount(FTopRow);
      Inc(NewCurrent, PageHeight);
    end;
    VK_PRIOR: begin
      NewCurrent:=GetVisibleRowTop(NewCurrent);
    end;
    VK_HOME: NewCurrent:=0;
    VK_END: NewCurrent:=FLogsItem.FLogItems.Count-1;
    else Exit;
   end;
   MoveCurrent(NewCurrent,true,true);
end;

procedure TtsvLog.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
end;

function TtsvLog.YToRow(Y: Integer): Integer;
var
  i: Integer;
  rh: Integer;
begin
  Result :=-1;
  rh:=0;
  for i:=FTopRow to FLogsItem.FLogItems.Count-1 do begin
    rh:=rh+GetRowHeigth(i);
    if rh>Y then begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TtsvLog.InvalidateItem(Index: Integer);
var
  Rect: TRect;
begin
  if (Index<0)or(Index>FLogsItem.FLogItems.Count-1) then exit;
  Rect:=GetItemRect(Index);
  InvalidateRect(Handle, @Rect, True);
  DrawItem(Index);
end;

procedure TtsvLog.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  FCurr: Integer;
begin
  if not (csDesigning in ComponentState) and
    (CanFocus or (GetParentForm(Self) = nil)) then
       SetFocus;

  if ssDouble in Shift then DblClick
  else begin
    FCurr:=YToRow(Y);
    if FCurr=-1 then exit;
    if FLogsItem.MultiSelect then begin
     if ssCtrl in Shift then begin
       FLogsItem.FLogItems.Items[FCurr].Selected:=not FLogsItem.FLogItems.Items[FCurr].Selected;
       MoveCurrent(FCurr,false,false);
       InvalidateItem(FCurr);
     end else begin
      MoveCurrent(FCurr,false,Button=mbLeft);
     end;
    end else begin
      MoveCurrent(FCurr,false,false);
    end;
  end;
  inherited;
end;

procedure TtsvLog.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  FCurr: Integer;
begin
  if ssLeft in Shift then begin
   FCurr:=YToRow(Y);
   if FCurr<>-1 then
    MoveCurrent(FCurr,false,true);
  end; 
  inherited;
end;

procedure TtsvLog.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

procedure TtsvLog.WMMouseWheel(var Message: TWMMouseWheel);
var
  NewCurrent: Integer;
begin
  NewCurrent := FLogsItem.ItemIndex;
  with Message do begin
    if WheelDelta<0 then
      Inc(NewCurrent)
    else Dec(NewCurrent);
    Result:=1;
  end;
  MoveCurrent(NewCurrent,true,false);
end;

function TtsvLog.GetItemRect(Index: Integer): TRect;
var
  ItemRect: TRect;
  i: Integer;
  rh: Integer;
begin
  FillChar(Result,SizeOf(Result),0);
  if (Index<0)or(Index>FLogsItem.FLogItems.Count-1) then exit;
  ItemRect.Left:=GetClientRect.Left;
  ItemRect.Right:=GetClientRect.Right;
  if Index<FTopRow then begin

  end else begin
    ItemRect.Bottom:=0;
    for i:=FTopRow to Index do begin
      rh:=GetRowHeigth(i);
      ItemRect.Top:=ItemRect.Bottom;
      ItemRect.Bottom:=ItemRect.Top+rh;
    end;
  end;
  Result:=ItemRect;
end;

procedure TtsvLog.UnSelectAll;
var
  i: Integer;
  isSel: Boolean;
begin
  for i:=0 to FLogsItem.FLogItems.Count-1 do begin
    isSel:=FLogsItem.FLogItems.Items[I].Selected;
    FLogsItem.FLogItems.Items[I].Selected:=false;
    if isSel then InvalidateItem(I);
  end;
end;

procedure TtsvLog.InvalidateBottom(Index: Integer);

  procedure InvalidateLocal;
  var
    Rct,InRect: TRect;
  begin
    if FLogsItem.FLogItems.Count>0 then begin
     Rct:=GetItemRect(FLogsItem.FLogItems.Count-1);
     InRect:=Rect(Rct.Left,Rct.Bottom,Rct.Right,ClientHeight-Rct.Bottom);
    end else begin
     InRect:=ClientRect;
    end;
    InvalidateRect(Handle, @InRect, True)
  end;

var
  i,ViewCount: Integer;
begin
  if (Index<0) or (Index>FLogsItem.FLogItems.Count-1) then begin
    InvalidateLocal;
  end else begin
   ViewCount:=VisibleRowCount(FTopRow);
   for i:=FTopRow to ViewCount-1 do begin
    if i>=Index then
      InvalidateItem(i);
   end;
   InvalidateLocal;
  end; 
end;

procedure TtsvLog.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  Msg.Result := 1;
end;

procedure TtsvLog.DrawItem(Index: Integer);
var
  Rect: TRect;
  isFocused: Boolean;
  isCurrent: Boolean;
  CurLogItem: TtsvLogItem;

    function PrepearString(NewRect: TRect; S: String): String;
    var
     dx: Integer;
     j: Integer;
    const
     Pref='...';
    begin
     dx:=NewRect.Right-NewRect.Left;
     Result:='';
     if (dx)<Canvas.TextWidth(S) then begin
       for j:=Length(S) downto 1 do begin
         Result:=Copy(S,1,j);
         if dx>Canvas.TextWidth(Result+Pref) then begin
           Result:=Result+Pref;
           exit;
         end;
       end;
       for j:=Length(Pref) downto 1 do begin
         Result:=Copy(Pref,1,j);
         if dx>Canvas.TextWidth(Result) then begin
           break;
         end;
       end;
     end else Result:=S;
    end;

    procedure DrawString(Flags: DWord; str: TStringList; Alignment: TAlignment);
    var
      RtDraw: TRect;
      dy: Integer;
      S: string;
      i,newCount: Integer;
      OldRect: TRect;
    begin
      OldRect:=Rect;
      case Alignment of
        taLeftJustify: Inc(Rect.Left,2);
        taRightJustify: Dec(Rect.Right,2);
      end; 
      Move(Rect,RtDraw,SizeOf(TRect));
      newCount:=str.Count;
      if newCount>FLogsItem.FLogItems.Items[Index].MaxRow then
         newCount:=FLogsItem.FLogItems.Items[Index].MaxRow;
      if newCount>0 then
       dy:=(Rect.Bottom-Rect.Top)div newCount
      else dy:=Rect.Bottom-Rect.Top;
      RtDraw.Top:=Rect.Top;
      RtDraw.Bottom:=RtDraw.Top+dy;
      for i:=0 to newCount-1 do begin
        S:=PrepearString(OldRect,str.Strings[i]);
        DrawText(Canvas.Handle, PChar(S), Length(S), RtDraw, Flags);
        RtDraw.Top:=RtDraw.Bottom;
        RtDraw.Bottom:=RtDraw.Top+dy;
      end;
    end;

    function GetMaxWidth(S: string): Integer;
    var
      str: TStringList;
      i,newCount: Integer;
      maxRes: Integer;
    begin
      str:=TStringList.Create;
      try
       Result:=0;
       str.Text:=S;
       newCount:=str.Count;
       if newCount>FLogsItem.FLogItems.Items[Index].MaxRow then
         newCount:=FLogsItem.FLogItems.Items[Index].MaxRow;
       for i:=0 to newCount-1 do begin
         maxRes:=Canvas.TextWidth(str.Strings[i]);
         if maxRes>Result then
           Result:=maxRes;
       end;
      finally
       str.Free;
      end; 
    end;

    procedure DrawSelection(FocusExists: Boolean);
    begin
     if not FLogsItem.FLogItems.Items[Index].Selected then
       Canvas.FillRect(Rect);

     if not isCurrent then
      if FLogsItem.FLogItems.Items[Index].Selected and FocusExists then begin
       Canvas.Brush.Color := clHighlight;
       Canvas.Font.Color := clHighlightText;
       Canvas.FillRect(Rect);
      end else
       if FLogsItem.FLogItems.Items[Index].Selected and
         not FLogsItem.HideSelection then begin
         Canvas.Brush.Color := clBtnFace;
         Canvas.FillRect(Rect);
       end;

      if isCurrent then begin
        if {FLogsItem.FLogItems.Items[Index].Selected and }FocusExists then begin
         Canvas.Brush.Color := clHighlight;
         Canvas.Font.Color := clHighlightText;
         Canvas.FillRect(Rect);
        end else
          if FLogsItem.FLogItems.Items[Index].Selected and
             not FLogsItem.HideSelection then begin
             Canvas.Brush.Color := clBtnFace;
             Canvas.FillRect(Rect);
          end;
      end;
    end;

    procedure DrawImages;
    var
     xImage,yImage: Integer;
    begin
     if FLogs.FImages<>nil then begin
       xImage:=Rect.Left+2;
       yImage:=Rect.Top+(Rect.Bottom-Rect.Top) div 2 - FLogs.FImages.Height div 2;
       FLogs.FImages.Draw(Canvas,xImage,yImage,CurLogItem.ImageIndex,true);
       Inc(Rect.Left,xImage+FLogs.FImages.Width+2);
     end;
    end;

var
    OldBrush: TBrush;
    OldFont: TFont;
    OldPen: TPen;
    Flags: Dword;
    i: Integer;
    str: TStringList;
    lic: TtsvLogItemCaption;
    OldRect,RectFocus: TRect;
begin
    Rect:=GetItemRect(Index);
    isFocused:=Focused;
    isCurrent:=FLogsItem.ItemIndex=Index;

    OldBrush:=TBrush.Create;
    OldFont:=TFont.Create;
    OldPen:=TPen.Create;
    str:=TStringList.Create;
    try
     CurLogItem:=FLogsItem.FLogItems.Items[Index];

     OldBrush.Assign(Canvas.Brush);
     OldFont.Assign(Canvas.Font);
     OldPen.Assign(Canvas.Pen);

     Canvas.Brush.Assign(CurLogItem.Brush);
     Canvas.Font.Assign(CurLogItem.Font);
     Canvas.Pen.Assign(CurLogItem.Pen);

     DrawImages;

     RectFocus:=Rect;

     OldRect:=Rect;

     if FLogsItem.FLogItems.Items[Index].Captions.Count=0 then begin

      DrawSelection(isFocused);

      Flags := DrawTextBiDiModeFlags(DT_VCENTER or DT_NOPREFIX);

      Canvas.Brush.Style:=bsClear;
      str.Text:=CurLogItem.Caption;
      case CurLogItem.Alignment of
        taLeftJustify:  Flags := DrawTextBiDiModeFlags(DT_VCENTER or DT_NOPREFIX or DT_LEFT or DT_SINGLELINE);
        taRightJustify: Flags := DrawTextBiDiModeFlags(DT_VCENTER or DT_NOPREFIX or DT_RIGHT or DT_SINGLELINE);
        taCenter:       Flags := DrawTextBiDiModeFlags(DT_VCENTER or DT_NOPREFIX or DT_CENTER or DT_SINGLELINE);
      end;
      DrawString(Flags,str,CurLogItem.Alignment);

      if isCurrent and isFocused then begin
        Canvas.DrawFocusRect(RectFocus);
      end;

     end else begin
       for i:=0 to FLogsItem.FLogItems.Items[Index].Captions.Count-1 do begin
          lic:=FLogsItem.FLogItems.Items[Index].Captions.Items[i];

          if lic.Visible then begin
           Canvas.Brush.Assign(lic.Brush);
           Canvas.Font.Assign(lic.Font);
           Canvas.Pen.Assign(lic.Pen);

           if i=FLogsItem.FLogItems.Items[Index].Captions.Count-1 then
            Rect.Right:=OldRect.Right
           else begin
            if lic.AutoWidth then
             Rect.Right:=Rect.Left+GetMaxWidth(lic.Caption)+4
            else
             Rect.Right:=Rect.Left+lic.Width;
           end;

          end; 

           DrawSelection(isFocused);

           Flags := DrawTextBiDiModeFlags(DT_VCENTER or DT_NOPREFIX);

           Canvas.Brush.Style:=bsClear;
           str.Text:=lic.Caption;
           case lic.Alignment of
            taLeftJustify:  Flags := DrawTextBiDiModeFlags(DT_VCENTER or DT_NOPREFIX or DT_LEFT or DT_SINGLELINE);
            taRightJustify: Flags := DrawTextBiDiModeFlags(DT_VCENTER or DT_NOPREFIX or DT_RIGHT or DT_SINGLELINE);
            taCenter:       Flags := DrawTextBiDiModeFlags(DT_VCENTER or DT_NOPREFIX or DT_CENTER or DT_SINGLELINE);
           end;
           if lic.Visible then
            DrawString(Flags,str,lic.Alignment);
           Rect.Left:=Rect.Right;
       end;

       if isCurrent and isFocused then begin
         Canvas.DrawFocusRect(RectFocus);
       end;
     end;

    finally
     str.Free;
     Canvas.Brush.Assign(OldBrush);
     Canvas.Font.Assign(OldFont);
     Canvas.Pen.Assign(OldPen);
     OldPen.Free;
     OldFont.Free;
     OldBrush.Free;
    end;
end;


procedure TtsvLog.Paint;
var
  Rect: TRect;
  i: Integer;
  ViewCount,incr: Integer;
begin
  Rect:=Canvas.ClipRect;
  Brush.Color:=clWindow;
  Canvas.FillRect(Rect);
  ViewCount:=VisibleRowCount(FTopRow);
  incr:=0;
  for i:=FTopRow to FLogsItem.FLogItems.Count-1 do begin
    inc(incr);
    DrawItem(i);
    if incr>ViewCount then break;
  end;
end;


end.

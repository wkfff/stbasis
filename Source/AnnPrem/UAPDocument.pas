unit UAPDocument;

interface

uses Windows, Classes, ActiveX;

type
  TAPDocument=class(TComponent)
  private
    FOleObject: IOleObject;
    FStorage: IStorage;
    FLockBytes: ILockBytes;
    FDocumentName: string;
    FOleClass: string;

    procedure CheckObject;
    procedure DestroyObject;
    procedure InitObject;
    function GetOleObject: Variant;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Run: Boolean;
    procedure DoVerb(Verb: Integer);
    procedure DoVerbDefault(Visible: Boolean=true);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);

    property OleObject: Variant read GetOleObject;
    property OleClass: String read FOleClass write FOleClass; 

  published

    property DocumentName: String read FDocumentName write FDocumentName;

  end;

implementation

uses SysUtils, comobj, OleConst, Forms;

const
  DataFormatCount = 2;
  StreamSignature = $434F4442; {'BDOC'}

type
  TStreamHeader = record
    case Integer of
      0: ( { New }
        Signature: Integer;
        DrawAspect: Integer;
        DataSize: Integer);
      1: ( { Old }
        PartRect: TSmallRect);
  end;

constructor TAPDocument.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TAPDocument.Destroy;
begin
  inherited Destroy;
end;

procedure TAPDocument.CheckObject;
begin
  if FOleObject = nil then
    raise EOleError.Create('������ �� ������ ������');
end;

procedure TAPDocument.DestroyObject;
begin
  if FOleObject <> nil then
  begin
    FOleObject.Close(OLECLOSE_NOSAVE);
  end;
  FOleObject := nil;
  FStorage := nil;
  FLockBytes := nil;
end;

procedure TAPDocument.InitObject;
begin
  FOleObject.SetHostNames(PWideChar(WideString(Application.Title)),PWideChar(WideString('')));
end;

procedure TAPDocument.LoadFromStream(Stream: TStream);
var
  DataHandle: HGlobal;
  Buffer: Pointer;
  DataSize: LongInt;
  Header: TStreamHeader;
begin
  DestroyObject;
  Stream.ReadBuffer(Header, SizeOf(Header));
  if (Header.Signature <> StreamSignature) then begin
//    raise EOleError.CreateRes(@SInvalidStreamFormat);
    DataSize:=Stream.Size;
  end else
    DataSize:=Header.DataSize;
  DataHandle := GlobalAlloc(GMEM_MOVEABLE, DataSize);
  if DataHandle = 0 then OutOfMemoryError;
  try
    Buffer := GlobalLock(DataHandle);
    try
      Stream.Read(Buffer^, DataSize);
    finally
      GlobalUnlock(DataHandle);
    end;
    OleCheck(CreateILockBytesOnHGlobal(DataHandle, True, FLockBytes));
    DataHandle := 0;
    OleCheck(StgOpenStorageOnILockBytes(FLockBytes, nil, STGM_READWRITE or STGM_SHARE_EXCLUSIVE, nil, 0, FStorage));
    OleCheck(OleLoad(FStorage, IOleObject, nil, FOleObject));
    InitObject;
  except
    if DataHandle <> 0 then GlobalFree(DataHandle);
    DestroyObject;
    raise;
  end;
end;

procedure TAPDocument.LoadFromFile(const FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmOpenRead);
    LoadFromStream(fs);
  finally
    fs.Free;
  end; 
end;

function TAPDocument.GetOleObject: Variant;
var
  obj: TObject;
begin
  CheckObject;
  obj:=nil;
  if FOleObject.QueryInterface(IDispatch,obj)=S_OK then
    Result := Variant(FOleObject as IDispatch)
  else Result:=Variant(FOleObject as IUnknown);
end;

function TAPDocument.Run: Boolean;
begin
  CheckObject;
  Result:=OleRun(FOleObject)=S_OK;
end;

procedure TAPDocument.DoVerb(Verb: Integer);
var
  R: TRect;
begin
  CheckObject;
  OleCheck(FOleObject.DoVerb(Verb, nil, nil, 0, 0, R));
end;

procedure TAPDocument.DoVerbDefault(Visible: Boolean=true);
begin
  if Visible then
    DoVerb(OLEIVERB_SHOW)
  else DoVerb(OLEIVERB_HIDE);
end;


end.

unit UEditRBMenu;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ExtDlgs, clipbrd, ComCtrls, IBTable;

type
  TfmEditRBMenu = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbParent: TLabel;
    edParent: TEdit;
    bibParent: TButton;
    lbHint: TLabel;
    meHint: TMemo;
    OD: TOpenPictureDialog;
    SD: TSavePictureDialog;
    grbImage: TGroupBox;
    srlbxImage: TScrollBox;
    imImage: TImage;
    bibImageLoad: TButton;
    bibImageSave: TButton;
    bibImageCopy: TButton;
    bibImagePaste: TButton;
    chbImageStretch: TCheckBox;
    bibImageClear: TButton;
    lbShortCut: TLabel;
    htShortCut: THotKey;
    chbChangeFlag: TCheckBox;
    lbInterface: TLabel;
    edInterface: TEdit;
    bibInterface: TButton;
    lbSort: TLabel;
    edSort: TEdit;
    udSort: TUpDown;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibParentClick(Sender: TObject);
    procedure edParentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibImageLoadClick(Sender: TObject);
    procedure bibImageSaveClick(Sender: TObject);
    procedure bibImageCopyClick(Sender: TObject);
    procedure bibImagePasteClick(Sender: TObject);
    procedure bibImageClearClick(Sender: TObject);
    procedure chbImageStretchClick(Sender: TObject);
    procedure imImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure bibInterfaceClick(Sender: TObject);
    procedure htShortCutEnter(Sender: TObject);
    procedure edInterfaceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chbChangeFlagClick(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
  private
    PointClicked: TPoint;
    FoldPosX, FoldPosY: Integer;
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    procedure LoadFromIni; override;
    procedure SaveToIni; override;
  public
    oldmenu_id: Integer;
    ParentMenuId: Integer;
    interface_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBMenu: TfmEditRBMenu;

implementation

uses UDesignTsvCode, UDesignTsvData, UMainUnited, URBMenu, tsvPicture, menus;

{$R *.DFM}

var
  AData: THandle;
  APalette: HPALETTE;


procedure TfmEditRBMenu.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBMenu.AddToRBooks: Boolean;
var
  tb: TIBTable;
  id: string;
  ms: TMemoryStream;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  tb:=TIBTable.Create(nil);
  ms:=TMemoryStream.Create;
  try
    tb.Database:=IBDB;
    tb.Transaction:=ibtran;
    tb.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbMenu,1));
    tb.TableName:=AnsiUpperCase(tbMenu);
    tb.Filter:=' menu_id='+id;
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Append;
    tb.FieldByName('menu_id').AsString:=id;
    tb.FieldByName('name').AsString:=Trim(edName.Text);
    tb.FieldByName('hint').Value:=Iff(Trim(meHint.Lines.Text)<>'',Trim(meHint.Lines.Text),Null);
    tb.FieldByName('interface_id').Value:=Iff(Trim(edInterface.Text)<>'',interface_id,Null);
    tb.FieldByName('shortcut').AsInteger:=Integer(htShortCut.HotKey);
    tb.FieldByName('parent_id').Value:=Iff(Trim(edParent.Text)<>'',ParentMenuId,Null);
    tb.FieldByName('changeflag').AsInteger:=Integer(chbChangeFlag.Checked);
    tb.FieldByName('sortvalue').AsInteger:=udSort.Position;

    TTsvPicture(imImage.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('image')).LoadFromStream(ms);
    tb.Post;
    
    tb.Transaction.Commit;
    oldmenu_id:=strtoint(id);

    Result:=true;
  finally
    ms.Free;
    tb.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBMenu.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBMenu.UpdateRBooks: Boolean;
var
  tb: TIBTable;
  id: string;
  ms: TMemoryStream;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  tb:=TIBTable.Create(nil);
  ms:=TMemoryStream.Create;
  try
    tb.Database:=IBDB;
    tb.Transaction:=ibtran;
    tb.Transaction.Active:=true;
    id:=inttostr(oldmenu_id);
    tb.TableName:=AnsiUpperCase(tbMenu);
    tb.Filter:=' menu_id='+id;
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Locate('menu_id',id,[LocaseInsensitive]);
    tb.Edit;
    tb.FieldByName('menu_id').AsString:=id;
    tb.FieldByName('name').AsString:=Trim(edName.Text);
    tb.FieldByName('hint').Value:=Iff(Trim(meHint.Lines.Text)<>'',Trim(meHint.Lines.Text),Null);
    tb.FieldByName('interface_id').Value:=Iff(Trim(edInterface.Text)<>'',interface_id,Null);
    tb.FieldByName('shortcut').AsInteger:=Integer(htShortCut.HotKey);
    tb.FieldByName('parent_id').Value:=Iff(Trim(edParent.Text)<>'',ParentMenuId,Null);
    tb.FieldByName('changeflag').AsInteger:=Integer(chbChangeFlag.Checked);
    tb.FieldByName('sortvalue').AsInteger:=udSort.Position;

    TTsvPicture(imImage.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('image')).LoadFromStream(ms);
    tb.Post;

    tb.Transaction.Commit;

    Result:=true;
  finally
    ms.Free;
    tb.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBMenu.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBMenu.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBMenu.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBMenu.FormCreate(Sender: TObject);
begin
  inherited;
  imImage.Cursor:=crImageMove;
  
  Screen.Cursors[crImageMove] := LoadCursor(HINSTANCE,CursorMove);
  Screen.Cursors[crImageDown] := LoadCursor(HINSTANCE,CursorDown);

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edParent.MaxLength:=DomainNameLength;
  edInterface.MaxLength:=DomainNameLength;
  meHint.MaxLength:=DomainNoteLength;

  chbImageStretchClick(nil);
  
  LoadFromIni;
end;

procedure TfmEditRBMenu.bibParentClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='menu_id';
  TPRBI.Locate.KeyValues:=ParentMenuId;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkMenu,@TPRBI) then begin
   ChangeFlag:=true;
   ParentMenuId:=GetFirstValueFromParamRBookInterface(@TPRBI,'menu_id');
   edParent.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBMenu.edParentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edParent.Text)=Length(edParent.SelText) then begin
      edParent.Text:='';
      ParentMenuId:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

procedure TfmEditRBMenu.bibImageLoadClick(Sender: TObject);
begin
  if not Od.Execute then exit;
  imImage.Picture.LoadFromFile(od.FileName);
  chbImageStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBMenu.bibImageSaveClick(Sender: TObject);
begin
  if not Sd.Execute then exit;
  imImage.Picture.SaveToFile(sd.FileName);
  chbImageStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBMenu.bibImageCopyClick(Sender: TObject);
begin
  imImage.Picture.SaveToClipboardFormat(CF_PICTURE,AData,APalette);
end;

procedure TfmEditRBMenu.bibImagePasteClick(Sender: TObject);
begin
  imImage.Picture.LoadFromClipBoardFormat(CF_PICTURE,AData,0);
  chbImageStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBMenu.bibImageClearClick(Sender: TObject);
begin
  imImage.Picture.Assign(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBMenu.chbImageStretchClick(Sender: TObject);
begin
  imImage.AutoSize:=not chbImageStretch.Checked;
  imImage.Stretch:=chbImageStretch.Checked;
  if imImage.Stretch then begin
   srlbxImage.HorzScrollBar.Range:=0;
   srlbxImage.VertScrollBar.Range:=0;
   imImage.Align:=alClient;
  end else begin
   imImage.Align:=alNone;
   if (imImage.Picture.Height>srlbxImage.Height-4)or
      (imImage.Picture.Width>srlbxImage.Width-4) then begin
    imImage.Height:=imImage.Picture.Height;
    imImage.Width:=imImage.Picture.Width;
   end else begin
    imImage.AutoSize:=false;
    imImage.Height:=srlbxImage.Height-4;
    imImage.Width:=srlbxImage.Width-4;
   end;
   srlbxImage.HorzScrollBar.Range:=imImage.Width;
   srlbxImage.VertScrollBar.Range:=imImage.Height;
  end;
end;

procedure TfmEditRBMenu.imImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetCursor(Screen.Cursors[crImageDown]);
  PointClicked:=imImage.ClientToScreen(Point(X,Y));
  FoldPosX:=(imImage.Parent as TScrollBox).HorzScrollBar.Position;
  FoldPosY:=(imImage.Parent as TScrollBox).VertScrollBar.Position;
end;

procedure TfmEditRBMenu.imImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
 CurPoint: TPoint;
begin
  if (imImage.Parent is TScrollBox) and (ssLeft in Shift) then begin
   CurPoint:=imImage.ClientToScreen(Point(X,Y));
   (imImage.Parent as TScrollBox).HorzScrollBar.Position:=FOldPosX-CurPoint.X+PointClicked.X;
   (imImage.Parent as TScrollBox).VertScrollBar.Position:=FOldPosY-CurPoint.Y+PointClicked.Y;
  end;
end;

procedure TfmEditRBMenu.imImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  imImage.Cursor:=crImageMove;
end;

procedure TfmEditRBMenu.FormDestroy(Sender: TObject);
begin
  inherited;
  DestroyCursor(Screen.Cursors[crImageMove]);
  DestroyCursor(Screen.Cursors[crImageDown]);
  Screen.Cursors[crImageMove] := 0;
  Screen.Cursors[crImageDown] := 0;

  SaveToIni;
end;

procedure TfmEditRBMenu.bibInterfaceClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='interface_id';
  TPRBI.Locate.KeyValues:=interface_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkInterface,@TPRBI) then begin
   ChangeFlag:=true;
   interface_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'interface_id');
   edInterface.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBMenu.LoadFromIni;
begin
  chbImageStretch.Checked:=ReadParam(ClassName,'chbImageStretch.Checked',chbImageStretch.Checked);
end;

procedure TfmEditRBMenu.SaveToIni;
begin
  WriteParam(ClassName,'chbImageStretch.Checked',chbImageStretch.Checked);
end;


procedure TfmEditRBMenu.htShortCutEnter(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBMenu.edInterfaceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure ClearInterface;
  begin
    if Length(edInterface.Text)=Length(edInterface.SelText) then begin
      edInterface.Text:='';
      interface_id:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearInterface;
  end;
end;

procedure TfmEditRBMenu.chbChangeFlagClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBMenu.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;

end;

end.

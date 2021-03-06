unit URBViewPlace;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBViewPlace = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName,isFindNote: Boolean;
    FindName,FindNote: String;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBViewPlace: TfmRBViewPlace;

implementation

uses UMainUnited, UInvalidTsvCode, UInvalidTsvDM, UInvalidTsvData, UEditRBViewPlace;

{$R *.DFM}

procedure TfmRBViewPlace.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkViewPlace;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Наименование';
  cl.Width:=200;

  cl:=Grid.Columns.Add;
  cl.FieldName:='note';
  cl.Title.Caption:='Примечание';
  cl.Width:=100;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBViewPlace.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBViewPlace:=nil;
end;

function TfmRBViewPlace.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkViewPlace+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBViewPlace.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindName or isFindNote);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBViewPlace.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('viewplace_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('viewplace_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBViewPlace.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBViewPlace.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindNote:=ReadParam(ClassName,'note',FindNote);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBViewPlace.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'note',FindNote);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBViewPlace.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBViewPlace.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBViewPlace;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBViewPlace.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('viewplace_id',fm.oldviewplace_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBViewPlace.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBViewPlace;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBViewPlace.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.meNote.Lines.Text:=Mainqr.fieldByName('note').AsString;
    fm.oldviewplace_id:=MainQr.FieldByName('viewplace_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('viewplace_id',fm.oldviewplace_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBViewPlace.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     qr.Database:=IBDB;
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbViewPlace+' where viewplace_id='+
          Mainqr.FieldByName('viewplace_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveQuery(false);
     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('место осмотра <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBViewPlace.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBViewPlace;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBViewPlace.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.meNote.Lines.Text:=Mainqr.fieldByName('note').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBViewPlace.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBViewPlace;
  filstr: string;
begin
 fm:=TfmEditRBViewPlace.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindNote)<>'' then fm.meNote.Lines.Text:=FindNote;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);
    FindNote:=Trim(fm.meNote.Lines.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBViewPlace.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindNote:=Trim(FindNote)<>'';

    if isFindName or isFindNote then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindNote then begin
        addstr2:=' Upper(note) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNote+'%'))+' ';
     end;

     if isFindName and isFindNote then
      and1:=' and ';

     Result:=wherestr+addstr1+and1+addstr2;
end;


end.

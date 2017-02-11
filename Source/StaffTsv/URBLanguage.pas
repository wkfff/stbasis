unit URBLanguage;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBLanguage = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName: Boolean;
    FindName: String;
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
  fmRBLanguage: TfmRBLanguage;

implementation

uses UMainUnited, UStaffTsvCode, UStaffTsvDM, UStaffTsvData, UEditRBLanguage;

{$R *.DFM}

procedure TfmRBLanguage.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
  inherited;
  try
   Caption:=NameRbkLanguage;
   Mainqr.Database:=IBDB;
   IBTran.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTran);
   cl:=Grid.Columns.Add;
   cl.FieldName:='name';
   cl.Title.Caption:='����������� ����';
   cl.Width:=250;
   LoadFromIni;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end; 
end;

procedure TfmRBLanguage.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBLanguage:=nil;
end;

function TfmRBLanguage.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkLanguage+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBLanguage.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLanguage.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('language_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('language_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLanguage.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBLanguage.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
 {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLanguage.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLanguage.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBLanguage.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBLanguage;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBLanguage.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('language_id',fm.oldlanguage_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBLanguage.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBLanguage;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBLanguage.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.oldlanguage_id:=MainQr.FieldByName('language_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('language_id',fm.oldlanguage_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBLanguage.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbLanguage+' where language_id='+
          Mainqr.FieldByName('language_id').asString;
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
  but:=DeleteWarningEx('����������� ���� <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBLanguage.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBLanguage;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBLanguage.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBLanguage.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBLanguage;
  filstr: string;
begin
 fm:=TfmEditRBLanguage.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBLanguage.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';

    if isFindName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
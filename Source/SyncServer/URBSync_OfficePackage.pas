unit URBSync_OfficePackage;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBSync_OfficePackage = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindOffice,isFindPackage: Boolean;
    FindOffice,FindPackage: String;
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
  fmRBSync_OfficePackage: TfmRBSync_OfficePackage;

implementation

uses UMainUnited, USyncServerCode, USyncServerDM, USyncServerData, UEditRBSync_OfficePackage;

{$R *.DFM}

procedure TfmRBSync_OfficePackage.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkSync_OfficePackage;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  
  cl:=Grid.Columns.Add;
  cl.FieldName:='office_name';
  cl.Title.Caption:='����';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='package_name';
  cl.Title.Caption:='�����';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='priority';
  cl.Title.Caption:='���������';
  cl.Width:=50;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_OfficePackage.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBSync_OfficePackage:=nil;
end;

function TfmRBSync_OfficePackage.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkSync_OfficePackage+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBSync_OfficePackage.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindOffice or isFindPackage);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_OfficePackage.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('office_name') then fn:='so.name';
   if UpperCase(fn)=UpperCase('package_name') then fn:='sp.name';
   id2:=MainQr.fieldByName('sync_office_id').asString;
   id1:=MainQr.fieldByName('sync_package_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('sync_office_id;sync_package_id',VarArrayOf([id2,id1]),[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_OfficePackage.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBSync_OfficePackage.LoadFromIni;
begin
 inherited;
 try
    FindOffice:=ReadParam(ClassName,'office',FindOffice);
    FindPackage:=ReadParam(ClassName,'package',FindPackage);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_OfficePackage.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'office',FindOffice);
    WriteParam(ClassName,'package',FindPackage);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_OfficePackage.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBSync_OfficePackage.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBSync_OfficePackage;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBSync_OfficePackage.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
      ViewCount;
      MainQr.Locate('sync_office_id;sync_package_id',VarArrayOf([fm.oldoffice_id,fm.oldpackage_id]),[LocaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_OfficePackage.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBSync_OfficePackage;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBSync_OfficePackage.Create(nil);
  try
    fm.fmParent:=Self;
    fm.edOffice.Text:=Mainqr.fieldByName('office_name').AsString;
    fm.office_id:=Mainqr.fieldByName('sync_office_id').AsInteger;
    fm.oldoffice_id:=fm.office_id;
    fm.edPackage.Text:=Mainqr.fieldByName('package_name').AsString;
    fm.package_id:=Mainqr.fieldByName('sync_package_id').AsInteger;
    fm.oldpackage_id:=fm.package_id;
    fm.edPriority.Text:=Mainqr.fieldByName('priority').AsString;
    fm.cmbDirection.ItemIndex:=Mainqr.fieldByName('direction').AsInteger;

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
       MainQr.Locate('sync_office_id;sync_package_id',VarArrayOf([fm.oldoffice_id,fm.oldpackage_id]),[LocaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_OfficePackage.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbSync_OfficePackage+
           ' where sync_office_id='+Mainqr.FieldByName('sync_office_id').asString+
           ' and sync_package_id='+Mainqr.FieldByName('sync_package_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;

     ViewCount;

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
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('����� <'+Mainqr.FieldByName('package_name').AsString+
                       '> � ����� '+'<'+Mainqr.FieldByName('office_name').AsString+'>'+'?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBSync_OfficePackage.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBSync_OfficePackage;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBSync_OfficePackage.Create(nil);
  try
    fm.edOffice.Text:=Mainqr.fieldByName('office_name').AsString;
    fm.office_id:=Mainqr.fieldByName('sync_office_id').AsInteger;
    fm.oldoffice_id:=fm.office_id;
    fm.edPackage.Text:=Mainqr.fieldByName('package_name').AsString;
    fm.package_id:=Mainqr.fieldByName('sync_package_id').AsInteger;
    fm.oldpackage_id:=fm.package_id;
    fm.edPriority.Text:=Mainqr.fieldByName('priority').AsString;
    fm.cmbDirection.ItemIndex:=Mainqr.fieldByName('direction').AsInteger;
    fm.TypeEditRBook:=terbView;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_OfficePackage.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBSync_OfficePackage;
  filstr: string;
begin
 fm:=TfmEditRBSync_OfficePackage.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edOffice.ReadOnly:=false;
  fm.edOffice.Color:=clWindow;

  fm.edPackage.ReadOnly:=false;
  fm.edPackage.Color:=clWindow;

  if Trim(FindOffice)<>'' then fm.edOffice.Text:=FindOffice;
  if Trim(FindPackage)<>'' then fm.edPackage.Text:=FindPackage;

  fm.edPriority.Enabled:=false;
  fm.edPriority.Color:=clBtnFace;
  fm.lbPriority.Enabled:=false;

  fm.cmbDirection.Enabled:=false;
  fm.cmbDirection.Color:=clBtnFace;
  fm.lbDirection.Enabled:=false;
  
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindOffice:=Trim(fm.edOffice.Text);
    FindPackage:=Trim(fm.edPackage.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBSync_OfficePackage.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindOffice:=Trim(FindOffice)<>'';
    isFindPackage:=Trim(FindPackage)<>'';

    if isFindOffice or isFindPackage then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindOffice then begin
        addstr1:=' Upper(so.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOffice+'%'))+' ';
     end;

     if isFindPackage then begin
        addstr2:=' Upper(sp.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPackage+'%'))+' ';
     end;

     if (isFindOffice and isFindPackage) then
      and1:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;

end.

unit URBPlant;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBPlant = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindJuristAddress,isFindPostAddress,isFindBank,
    isFindInn,isFindAccount,isFindSmallName,isFindFullName,
    isFindContactPeople,isFindPhone,isFindOkonh,isFindOkpo: Boolean;
    FindJuristAddress,FindPostAddress,FindBank,
    FindInn,FindAccount,FindSmallName,FindFullName,
    FindContactPeople,FindPhone,FindOkonh,FindOkpo: string;
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
  fmRBPlant: TfmRBPlant;

implementation

uses UMainUnited, UStaffTsvCode, UStaffTsvDM, UStaffTsvData, UEditRBPlant;

{$R *.DFM}

procedure TfmRBPlant.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkPlant;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  
  cl:=Grid.Columns.Add;
  cl.FieldName:='inn';
  cl.Title.Caption:='���';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='smallname';
  cl.Title.Caption:='������� ������������';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='fullname';
  cl.Title.Caption:='������ ������������';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='account';
  cl.Title.Caption:='��������� ����';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='juristaddress';
  cl.Title.Caption:='����������� �����';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='postaddress';
  cl.Title.Caption:='�������� �����';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='bankname';
  cl.Title.Caption:='����';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='okonh';
  cl.Title.Caption:='�����';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='okpo';
  cl.Title.Caption:='����';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='contactpeople';
  cl.Title.Caption:='���������� ����';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='phone';
  cl.Title.Caption:='��������';
  cl.Width:=100;

//  DefLastOrderStr:=' order by smallname,inn';
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlant.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPlant:=nil;
end;

function TfmRBPlant.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPlant+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBPlant.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindJuristAddress or isFindPostAddress or isFindBank or
                  isFindInn or isFindAccount or isFindSmallName or isFindFullName or
                  isFindContactPeople or isFindPhone or isFindOkonh or isFindOkpo);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlant.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('plant_id').asString;
   if UpperCase(fn)=UpperCase('bankname') then fn:='b.name';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('plant_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlant.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBPlant.LoadFromIni;
begin
 inherited;
 try
    FindJuristAddress:=ReadParam(ClassName,'JuristAddress',FindJuristAddress);
    FindPostAddress:=ReadParam(ClassName,'PostAddress',FindPostAddress);
    FindBank:=ReadParam(ClassName,'Bank',FindBank);
    FindInn:=ReadParam(ClassName,'Inn',FindInn);
    FindAccount:=ReadParam(ClassName,'Account',FindAccount);
    FindSmallName:=ReadParam(ClassName,'SmallName',FindSmallName);
    FindFullName:=ReadParam(ClassName,'FullName',FindFullName);
    FindContactPeople:=ReadParam(ClassName,'ContactPeople',FindContactPeople);
    FindPhone:=ReadParam(ClassName,'Phone',FindPhone);
    FindOkonh:=ReadParam(ClassName,'Okonh',FindOkonh);
    FindOkpo:=ReadParam(ClassName,'Okpo',FindOkpo);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlant.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'JuristAddress',FindJuristAddress);
    WriteParam(ClassName,'PostAddress',FindPostAddress);
    WriteParam(ClassName,'Bank',FindBank);
    WriteParam(ClassName,'Inn',FindInn);
    WriteParam(ClassName,'Account',FindAccount);
    WriteParam(ClassName,'SmallName',FindSmallName);
    WriteParam(ClassName,'FullName',FindFullName);
    WriteParam(ClassName,'ContactPeople',FindContactPeople);
    WriteParam(ClassName,'Phone',FindPhone);
    WriteParam(ClassName,'Okonh',FindOkonh);
    WriteParam(ClassName,'Okpo',FindOkpo);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlant.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBPlant.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPlant;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBPlant.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    fm.bibAddAccount.Enabled:=false;
    if fm.ShowModal=mrok then begin
      ActiveQuery(false);
      MainQr.Locate('plant_id',fm.oldplant_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPlant.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPlant;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPlant.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edJuristAddress.Text:=Mainqr.fieldByName('juristaddress').AsString;
    fm.edPostAddress.Text:=Mainqr.fieldByName('postaddress').AsString;
    fm.edBank.Text:=Mainqr.fieldByName('bankname').AsString;
    fm.bank_id:=Mainqr.fieldByName('bank_id').AsInteger;
    fm.edInn.Text:=Mainqr.fieldByName('inn').AsString;
    fm.edAccount.Text:=Mainqr.fieldByName('account').AsString;
    fm.edSmallName.Text:=Mainqr.fieldByName('smallname').AsString;
    fm.edFullName.Text:=Mainqr.fieldByName('fullname').AsString;
    fm.edOkonh.Text:=Mainqr.fieldByName('okonh').AsString;
    fm.edOkpo.Text:=Mainqr.fieldByName('okpo').AsString;
    fm.edContactPeople.Text:=Mainqr.fieldByName('contactpeople').AsString;
    fm.edPhone.Text:=Mainqr.fieldByName('phone').AsString;
    fm.oldplant_id:=MainQr.FieldByName('plant_id').AsInteger;

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
      ActiveQuery(false);
      MainQr.Locate('plant_id',fm.oldplant_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPlant.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbPlant+' where plant_id='+
          Mainqr.FieldByName('plant_id').asString;
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
  but:=DeleteWarningEx('���������� <'+Mainqr.FieldByName('smallname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBPlant.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPlant;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPlant.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edJuristAddress.Text:=Mainqr.fieldByName('juristaddress').AsString;
    fm.edPostAddress.Text:=Mainqr.fieldByName('postaddress').AsString;
    fm.edBank.Text:=Mainqr.fieldByName('bankname').AsString;
    fm.bank_id:=Mainqr.fieldByName('bank_id').AsInteger;
    fm.edInn.Text:=Mainqr.fieldByName('inn').AsString;
    fm.edAccount.Text:=Mainqr.fieldByName('account').AsString;
    fm.edSmallName.Text:=Mainqr.fieldByName('smallname').AsString;
    fm.edFullName.Text:=Mainqr.fieldByName('fullname').AsString;
    fm.edOkonh.Text:=Mainqr.fieldByName('okonh').AsString;
    fm.edOkpo.Text:=Mainqr.fieldByName('okpo').AsString;
    fm.edContactPeople.Text:=Mainqr.fieldByName('contactpeople').AsString;
    fm.edPhone.Text:=Mainqr.fieldByName('phone').AsString;

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPlant.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPlant;
  filstr: string;
begin
 fm:=TfmEditRBPlant.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edBank.ReadOnly:=false;
  fm.edBank.Color:=clWindow;

  if Trim(FindJuristAddress)<>'' then fm.edJuristAddress.Text:=FindJuristAddress;
  if Trim(FindPostAddress)<>'' then fm.edPostAddress.Text:=FindPostAddress;
  if Trim(FindBank)<>'' then fm.edBank.Text:=FindBank;
  if Trim(FindInn)<>'' then fm.edInn.Text:=FindInn;
  if Trim(FindAccount)<>'' then fm.edAccount.Text:=FindAccount;
  if Trim(FindSmallName)<>'' then fm.edSmallName.Text:=FindSmallName;
  if Trim(FindFullName)<>'' then fm.edFullName.Text:=FindFullName;
  if Trim(FindContactPeople)<>'' then fm.edContactPeople.Text:=FindContactPeople;
  if Trim(FindPhone)<>'' then fm.edPhone.Text:=FindPhone;
  if Trim(FindOkonh)<>'' then fm.edOkonh.Text:=FindOkonh;
  if Trim(FindOkpo)<>'' then fm.edOkpo.Text:=FindOkpo;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindJuristAddress:=fm.edJuristAddress.Text;
    FindPostAddress:=fm.edPostAddress.Text;
    FindBank:=fm.edBank.Text;
    FindInn:=fm.edInn.Text;
    FindAccount:=fm.edAccount.Text;
    FindSmallName:=fm.edSmallName.Text;
    FindFullName:=fm.edFullName.Text;
    FindContactPeople:=fm.edContactPeople.Text;
    FindPhone:=fm.edPhone.Text;
    FindOkonh:=fm.edOkonh.Text;
    FindOkpo:=fm.edOkpo.Text;

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBPlant.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,
  addstr6,addstr7,addstr8,addstr9,addstr10,addstr11: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9,and10: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindJuristAddress:=Trim(FindJuristAddress)<>'';
    isFindPostAddress:=Trim(FindPostAddress)<>'';
    isFindBank:=Trim(FindBank)<>'';
    isFindInn:=Trim(FindInn)<>'';
    isFindAccount:=Trim(FindAccount)<>'';
    isFindSmallName:=Trim(FindSmallName)<>'';
    isFindFullName:=Trim(FindFullName)<>'';
    isFindContactPeople:=Trim(FindContactPeople)<>'';
    isFindPhone:=Trim(FindPhone)<>'';
    isFindOkonh:=Trim(FindOkonh)<>'';
    isFindOkpo:=Trim(FindOkpo)<>'';

    if isFindJuristAddress or isFindPostAddress or isFindBank or
                  isFindInn or isFindAccount or isFindSmallName or isFindFullName or
                  isFindContactPeople or isFindPhone or isFindOkonh or isFindOkpo then
    begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindJuristAddress then begin
        addstr1:=' Upper(juristaddress) like '+AnsiUpperCase(QuotedStr(FilInSide+FindJuristAddress+'%'))+' ';
     end;

     if isFindPostAddress then begin
        addstr2:=' Upper(postaddress) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPostAddress+'%'))+' ';
     end;

     if isFindBank then begin
        addstr3:=' Upper(b.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindBank+'%'))+' ';
     end;

     if isFindInn then begin
        addstr4:=' Upper(inn) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInn+'%'))+' ';
     end;

     if isFindAccount then begin
        addstr5:=' Upper(account) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAccount+'%'))+' ';
     end;

     if isFindSmallName then begin
        addstr6:=' Upper(smallname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSmallName+'%'))+' ';
     end;

     if isFindFullName then begin
        addstr7:=' Upper(fullname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFullName+'%'))+' ';
     end;

     if isFindContactPeople then begin
        addstr8:=' Upper(contactpeople) like '+AnsiUpperCase(QuotedStr(FilInSide+FindContactPeople+'%'))+' ';
     end;

     if isFindPhone then begin
        addstr9:=' Upper(phone) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPhone+'%'))+' ';
     end;

     if isFindOkonh then begin
        addstr10:=' Upper(okonh) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOkonh+'%'))+' ';
     end;

     if isFindOkpo then begin
        addstr11:=' Upper(okpo) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOkpo+'%'))+' ';
     end;


     if (isFindJuristAddress and isFindPostAddress)or
        (isFindJuristAddress and isFindBank)or
        (isFindJuristAddress and isFindInn)or
        (isFindJuristAddress and isFindAccount)or
        (isFindJuristAddress and isFindSmallName)or
        (isFindJuristAddress and isFindFullName)or
        (isFindJuristAddress and isFindContactPeople)or
        (isFindJuristAddress and isFindPhone)or
        (isFindJuristAddress and isFindOkonh)or
        (isFindJuristAddress and isFindOkpo)
        then and1:=' and ';

     if (isFindPostAddress and isFindBank)or
        (isFindPostAddress and isFindInn)or
        (isFindPostAddress and isFindAccount)or
        (isFindPostAddress and isFindSmallName)or
        (isFindPostAddress and isFindFullName)or
        (isFindPostAddress and isFindContactPeople)or
        (isFindPostAddress and isFindPhone)or
        (isFindPostAddress and isFindOkonh)or
        (isFindPostAddress and isFindOkpo)
        then and2:=' and ';

     if (isFindBank and isFindInn)or
        (isFindBank and isFindAccount)or
        (isFindBank and isFindSmallName)or
        (isFindBank and isFindFullName)or
        (isFindBank and isFindContactPeople)or
        (isFindBank and isFindPhone)or
        (isFindBank and isFindOkonh)or
        (isFindBank and isFindOkpo)
        then and3:=' and ';

     if (isFindInn and isFindAccount)or
        (isFindInn and isFindSmallName)or
        (isFindInn and isFindFullName)or
        (isFindInn and isFindContactPeople)or
        (isFindInn and isFindPhone)or
        (isFindInn and isFindOkonh)or
        (isFindInn and isFindOkpo)
        then and4:=' and ';

     if (isFindAccount and isFindSmallName)or
        (isFindAccount and isFindFullName)or
        (isFindAccount and isFindContactPeople)or
        (isFindAccount and isFindPhone)or
        (isFindAccount and isFindOkonh)or
        (isFindAccount and isFindOkpo)
        then and5:=' and ';

     if (isFindSmallName and isFindFullName)or
        (isFindSmallName and isFindContactPeople)or
        (isFindSmallName and isFindPhone)or
        (isFindSmallName and isFindOkonh)or
        (isFindSmallName and isFindOkpo)
        then and6:=' and ';

     if (isFindFullName and isFindContactPeople)or
        (isFindFullName and isFindPhone)or
        (isFindFullName and isFindOkonh)or
        (isFindFullName and isFindOkpo)
        then and7:=' and ';

     if (isFindContactPeople and isFindPhone)or
        (isFindContactPeople and isFindOkonh)or
        (isFindContactPeople and isFindOkpo)
        then and8:=' and ';

     if (isFindPhone and isFindOkonh)or
        (isFindPhone and isFindOkpo)
        then and9:=' and ';

     if (isFindOkonh and isFindOkpo)
        then and10:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5+and5+
                      addstr6+and6+
                      addstr7+and7+
                      addstr8+and8+
                      addstr9+and9+
                      addstr10+and10+
                      addstr11;
end;


end.

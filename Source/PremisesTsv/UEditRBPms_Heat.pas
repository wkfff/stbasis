unit UEditRBPms_Heat;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_Heat = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNote: TLabel;
    edNote: TEdit;
    lbSortNumber: TLabel;
    edSort: TEdit;
    udSort: TUpDown;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edSortChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_Heat_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_Heat: TfmEditRBPms_Heat;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Heat;

{$R *.DFM}

procedure TfmEditRBPms_Heat.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Heat.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbPms_Heat,1));
    sqls:='Insert into '+tbPms_Heat+
          ' (Pms_Heat_id,name,sortnumber,note) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+inttostr(udSort.Position)+
          ','+QuotedStr(Trim(edNote.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Heat_id:=strtoint(id);

    TfmRBPms_Heat(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Heat(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Heat(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_Heat_id').AsInteger:=oldPms_Heat_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
      Post;
    end;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBPms_Heat.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Heat.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldPms_Heat_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_Heat+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', note='+QuotedStr(Trim(edNote.text))+
          ', sortnumber='+inttostr(udSort.Position)+
          ' where Pms_Heat_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Heat(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Heat(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Heat(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Heat_id').AsInteger:=oldPms_Heat_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
      Post;
    end;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBPms_Heat.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Heat.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNote.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNote.Caption]));
    edNote.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Heat.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Heat.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainShortNameLength;
  edNote.MaxLength:=DomainNoteLength;
  edSort.MaxLength:=3;
end;

procedure TfmEditRBPms_Heat.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Heat.edSortChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.

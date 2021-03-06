unit UEditRBAP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, IBDatabase, StdCtrls, ExtCtrls, ComCtrls, IBQuery, IB,
  tsvComCtrls, tsvStdCtrls, tsvInterbase;

type
  TfmEditRBAP = class(TfmEditRB)
    lbName: TLabel;
    lbFullName: TLabel;
    lbPriority: TLabel;
    edName: TEdit;
    edFullName: TEdit;
    edPriority: TEdit;
    udPriority: TUpDown;
    lbVariant: TLabel;
    meVariant: TMemo;
    lbLink: TLabel;
    edLink: TEdit;
    lbExport: TLabel;
    edExport: TEdit;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edNameExit(Sender: TObject);
  private
    FParentForm: TForm;
    FOldFieldKeyValue: Variant;
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function GetAddSql: String; virtual;
    procedure CacheUpdate; virtual;
    function GetUpdateSql: String; virtual;
  public
    procedure InitAdd; virtual;
    procedure InitUpdate; virtual;
    procedure InitView; virtual;
    procedure InitFilter; virtual;
    procedure DoneFilter; virtual;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;

    property ParentForm: TForm read FParentForm write FParentForm;
    property OldFieldKeyValue: Variant read FOldFieldKeyValue write FOldFieldKeyValue;
  end;

  TfmEditRBAPClass = class of TfmEditRBAP;

var
  fmEditRBAP: TfmEditRBAP;

implementation

uses UMainUnited, UAnnPremData, URBAP;

{$R *.DFM}

procedure TfmEditRBAP.InitAdd;
var
  i: Integer; 
begin
  TypeEditRBook:=terbAdd;
  udPriority.Position:=GetFirstValueBySQL(IBDB,
                                          Format('SELECT MAX(PRIORITY) AS PRIORITY FROM %s',[TfmRBAP(ParentForm).TableName]),
                                          'PRIORITY')+1;
  with TfmRBAP(ParentForm) do begin
    for i:=0 to Length(FEdit)-1 do begin
      if AnsiSameText(FEdit[i].FieldName,'NAME') then
        edName.Text:=FEdit[i].FieldValue;
      if AnsiSameText(FEdit[i].FieldName,'FULLNAME') then
        edFullName.Text:=FEdit[i].FieldValue;
      if AnsiSameText(FEdit[i].FieldName,'VARIANT') then
        meVariant.Lines.Text:=FEdit[i].FieldValue;
    end;
  end;
end;

procedure TfmEditRBAP.InitUpdate;
begin
  TypeEditRBook:=terbChange;
  with TfmRBAP(ParentForm) do begin
    edName.Text:=Mainqr.fieldByName('NAME').AsString;
    edFullName.Text:=Mainqr.fieldByName('FULLNAME').AsString;
    meVariant.Lines.Text:=Mainqr.fieldByName('VARIANT').AsString;
    udPriority.Position:=Mainqr.fieldByName('PRIORITY').AsInteger;
    OldFieldKeyValue:=Mainqr.FieldByName(FieldKeyName).AsInteger;
    edLink.Text:=Mainqr.fieldByName('LINK').AsString;
    edExport.Text:=Mainqr.fieldByName('EXPORT').AsString;
  end;
end;

procedure TfmEditRBAP.InitView;
begin
  TypeEditRBook:=terbView;
  with TfmRBAP(ParentForm) do begin
    edName.Text:=Mainqr.fieldByName('NAME').AsString;
    edFullName.Text:=Mainqr.fieldByName('FULLNAME').AsString;
    meVariant.Lines.Text:=Mainqr.fieldByName('VARIANT').AsString;
    udPriority.Position:=Mainqr.fieldByName('PRIORITY').AsInteger;
    OldFieldKeyValue:=Mainqr.FieldByName(FieldKeyName).AsInteger;
    edLink.Text:=Mainqr.fieldByName('LINK').AsString;
    edExport.Text:=Mainqr.fieldByName('EXPORT').AsString;
  end;
end;

procedure TfmEditRBAP.InitFilter;
begin
  TypeEditRBook:=terbFilter;
  with TfmRBAP(ParentForm) do begin
    lbPriority.Enabled:=false;
    edPriority.Enabled:=false;
    edPriority.Color:=clBtnFace;
    udPriority.Enabled:=false;
    lbLink.Enabled:=false;
    edLink.Enabled:=false;
    edLink.Color:=clBtnFace;
    lbExport.Enabled:=false;
    edExport.Enabled:=false;
    edExport.Color:=clBtnFace;
    edName.Text:=Filters.Items[IndexFindName].Value;
    edFullName.Text:=Filters.Items[IndexFindFullName].Value;
    meVariant.Lines.Text:=Filters.Items[IndexFindVariant].Value;
    cbInString.Checked:=Filters.FilterInside;
  end;
end;

procedure TfmEditRBAP.DoneFilter;
begin
  with TfmRBAP(ParentForm) do begin
    Filters.Items[IndexFindName].Value:=Trim(edName.Text);
    Filters.Items[IndexFindName].Enabled:=Trim(edName.Text)<>'';
    Filters.Items[IndexFindFullName].Value:=Trim(edFullName.Text);
    Filters.Items[IndexFindFullName].Enabled:=Trim(edFullName.Text)<>'';
    Filters.Items[IndexFindVariant].Value:=Trim(meVariant.Lines.Text);
    Filters.Items[IndexFindVariant].Enabled:=Trim(meVariant.Lines.Text)<>'';
    Filters.FilterInside:=cbInString.Checked;
  end;
end;

procedure TfmEditRBAP.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAP.GetAddSql: String;
begin
  Result:='INSERT INTO '+TfmRBAP(ParentForm).TableName+
          ' ('+TfmRBAP(ParentForm).FieldKeyName+',NAME,FULLNAME,VARIANT,PRIORITY,LINK,EXPORT) VALUES '+
          ' ('+inttostr(FOldFieldKeyValue)+
          ','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(edFullName.Text))+
          ','+QuotedStr(Trim(meVariant.Lines.Text))+
          ','+inttostr(udPriority.Position)+
          ','+Iff(Trim(edLink.Text)<>'',QuotedStr(Trim(edLink.text)),'NULL')+
          ','+Iff(edExport.Text<>'',Trim(edExport.text),'NULL')+
          ')';
end;

procedure TfmEditRBAP.CacheUpdate;
begin
  with TfmRBAP(ParentForm) do begin
    MainQr.FieldByName(FieldKeyName).Value:=FOldFieldKeyValue;
    MainQr.FieldByName('NAME').AsString:=Trim(edName.Text);
    MainQr.FieldByName('FULLNAME').AsString:=Trim(edFullName.Text);
    MainQr.FieldByName('VARIANT').AsString:=Trim(meVariant.Lines.Text);
    MainQr.FieldByName('PRIORITY').AsInteger:=udPriority.Position;
    MainQr.FieldByName('LINK').AsString:=Trim(edLink.Text);
    MainQr.FieldByName('EXPORT').AsString:=edExport.Text;
  end;
end;

function TfmEditRBAP.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    FOldFieldKeyValue:=Integer(GetGenId(IBDB,TfmRBAP(ParentForm).TableName,1));
    sqls:=GetAddSql;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBAP(ParentForm).IBUpd.InsertSQL.Clear;
    TfmRBAP(ParentForm).IBUpd.InsertSQL.Add(sqls);

    with TfmRBAP(ParentForm).MainQr do begin
      Insert;
      CacheUpdate;
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

procedure TfmEditRBAP.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAP.GetUpdateSql: String; 
begin
  Result:='UPDATE '+TfmRBAP(ParentForm).TableName+
          ' SET NAME='+QuotedStr(Trim(edName.text))+
          ', FULLNAME='+QuotedStr(Trim(edFullName.text))+
          ', VARIANT='+QuotedStr(Trim(meVariant.Lines.text))+
          ', LINK='+Iff(Trim(edLink.Text)<>'',QuotedStr(Trim(edLink.text)),'NULL')+
          ', EXPORT='+Iff(Trim(edExport.Text)<>'',QuotedStr(Trim(edExport.text)),'NULL')+
          ', PRIORITY='+inttostr(udPriority.Position)+
          ' WHERE '+TfmRBAP(ParentForm).FieldKeyName+'='+VarToStr(FOldFieldKeyValue);
end;

function TfmEditRBAP.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:=GetUpdateSql;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBAP(ParentForm).IBUpd.ModifySQL.Clear;
    TfmRBAP(ParentForm).IBUpd.ModifySQL.Add(sqls);

    with TfmRBAP(ParentForm).MainQr do begin
      Edit;
      CacheUpdate;
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

procedure TfmEditRBAP.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBAP.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edFullName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFullName.Caption]));
    edFullName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBAP.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBAP.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edFullName.MaxLength:=DomainNoteLength;
  meVariant.MaxLength:=DomainVariant;
  edLink.MaxLength:=DomainNoteLength;
  edExport.MaxLength:=DomainNoteLength;
  edPriority.MaxLength:=3;
end;

procedure TfmEditRBAP.edNameExit(Sender: TObject);
begin
  if TypeEditRBook=terbAdd then begin
    if Trim(edFullName.Text)='' then begin
      edFullName.Text:=edName.Text;
      ChangeFlag:=true;
    end;
    if Trim(meVariant.Lines.Text)='' then begin
      meVariant.Lines.Text:=edName.Text;
      ChangeFlag:=true;
    end;
  end;  
end;

end.

unit UEditRBPayment;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, ExtDlgs, IBTable, clipbrd;

type
  TfmEditRBPayment = class(TfmEditRB)
    lbCard: TLabel;
    lbPurpose: TLabel;
    edCard: TEdit;
    btCard: TBitBtn;
    edPurpose: TEdit;
    btPurpose: TBitBtn;
    lbDateTime: TLabel;
    dtpDate: TDateTimePicker;
    dtpTime: TDateTimePicker;
    lbHowMuch: TLabel;
    edHowMuch: TEdit;
    lbNote: TLabel;
    meNote: TMemo;
    lbLimit: TLabel;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure htShortCutEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btCardClick(Sender: TObject);
    procedure btPurposeClick(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edHowMuchChange(Sender: TObject);
    procedure edHowMuchKeyPress(Sender: TObject; var Key: Char);
  private
  protected
    procedure LoadFromIni; override;
    procedure SaveToIni; override;
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldpayment_id: Integer;
    purpose_id: Integer;
    card_id: Integer;
    card_nominal: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    function GetLimitByCard: Integer;
  end;

var
  fmEditRBPayment: TfmEditRBPayment;

implementation

uses UPaymentCode, UPaymentData, UMainUnited, URBPayment;

{$R *.DFM}

procedure TfmEditRBPayment.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPayment.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbPayment,1));
    sqls:='Insert into '+tbPayment+
          ' (payment_id,card_id,purpose_id,date_payment,how_much,note) values '+
          ' ('+id+
          ','+Inttostr(card_id)+
          ','+inttostr(purpose_id)+
          ','+QuotedStr(DateToStr(dtpDate.Date)+' '+TimeToStr(dtpTime.Time))+
          ','+QuotedStr(ChangeChar(edHowMuch.Text,',','.'))+
          ','+iff(Trim(meNote.Lines.Text)<>'',QuotedStr(Trim(meNote.Lines.Text)),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldpayment_id:=strtoint(id);

    TfmRBPayment(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPayment(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPayment(fmParent).MainQr do begin
      Insert;
      FieldByName('payment_id').AsInteger:=oldpayment_id;
      FieldByName('card_id').AsInteger:=card_id;
      FieldByName('purpose_id').AsInteger:=purpose_id;
      FieldByName('date_payment').AsString:=DateToStr(dtpDate.Date)+' '+TimeToStr(dtpTime.Time);
      FieldByName('num_card').AsString:=edCard.Text;
      FieldByName('purpose_name').AsString:=edPurpose.Text;
      FieldByName('how_much').Value:=ChangeChar(edHowMuch.Text,',','.');
      FieldByName('note').Value:=iff(Trim(meNote.Lines.Text)<>'',QuotedStr(Trim(meNote.Lines.Text)),Null);
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

procedure TfmEditRBPayment.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPayment.UpdateRBooks: Boolean;
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

    id:=inttostr(oldpayment_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPayment+
          ' set card_id='+inttostr(card_id)+
          ', purpose_id='+inttostr(purpose_id)+
          ', date_payment='+QuotedStr(DateToStr(dtpDate.Date)+' '+TimeToStr(dtpTime.Time))+
          ', how_much='+QuotedStr(ChangeChar(edHowMuch.Text,',','.'))+
          ', note='+iff(Trim(meNote.Lines.Text)<>'',QuotedStr(Trim(meNote.Lines.Text)),'null')+
          ' where payment_id='+id;

    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPayment(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPayment(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPayment(fmParent).MainQr do begin
      Edit;
      FieldByName('payment_id').AsInteger:=oldpayment_id;
      FieldByName('card_id').AsInteger:=card_id;
      FieldByName('purpose_id').AsInteger:=purpose_id;
      FieldByName('date_payment').AsString:=DateToStr(dtpDate.Date)+' '+TimeToStr(dtpTime.Time);
      FieldByName('num_card').AsString:=edCard.Text;
      FieldByName('purpose_name').AsString:=edPurpose.Text;
      FieldByName('how_much').Value:=ChangeChar(edHowMuch.Text,',','.');
      FieldByName('note').Value:=iff(Trim(meNote.Lines.Text)<>'',QuotedStr(Trim(meNote.Lines.Text)),Null);
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

procedure TfmEditRBPayment.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPayment.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edCard.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCard.Caption]));
    btCard.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPurpose.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPurpose.Caption]));
    btPurpose.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPayment.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPayment.FormCreate(Sender: TObject);
var
  dt: TDateTime;
begin
  inherited;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edCard.MaxLength:=50;
  edPurpose.MaxLength:=150;
  meNote.MaxLength:=DomainNoteLength;
  edHowMuch.MaxLength:=DomainNameMoney;
  dt:=_GetDateTimeFromServer;
  dtpDate.Date:=dt;
  dtpTime.Time:=dt;

  LoadFromIni;
end;

procedure TfmEditRBPayment.htShortCutEnter(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPayment.FormDestroy(Sender: TObject);
begin
  inherited;

  SaveToIni;
end;

procedure TfmEditRBPayment.LoadFromIni;
begin
end;

procedure TfmEditRBPayment.SaveToIni;
begin
end;

procedure TfmEditRBPayment.btCardClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='card_id';
  TPRBI.Locate.KeyValues:=card_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCard,@TPRBI) then begin
   ChangeFlag:=true;
   card_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'card_id');
   card_nominal:=GetFirstValueFromParamRBookInterface(@TPRBI,'nominal');
   edCard.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'num_card');
   lbLimit.Caption:=Format('�������: %d',[card_nominal-GetLimitByCard]);
  end;
end;

procedure TfmEditRBPayment.btPurposeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='purpose_id';
  TPRBI.Locate.KeyValues:=purpose_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPurpose,@TPRBI) then begin
   ChangeFlag:=true;
   purpose_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'purpose_id');
   edPurpose.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   edHowMuch.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'amount');
  end;
end;

procedure TfmEditRBPayment.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPayment.edHowMuchChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPayment.edHowMuchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key in [',','.',DecimalSeparator] then Key:=DecimalSeparator;
end;

function TfmEditRBPayment.GetLimitByCard: Integer;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=0; 
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Select sum(how_much) from payment where card_id='+inttostr(card_id);

    qr.SQL.Add(sqls);
    qr.Open;

    if not VarIsEmpty(qr.Fields[0].Value) then
      Result:=qr.Fields[0].AsInteger;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

end.
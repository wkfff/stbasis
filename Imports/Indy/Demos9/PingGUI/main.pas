unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  IdIcmpClient, IdBaseComponent, IdComponent, IdRawBase, IdRawClient,
  ExtCtrls;

type
  TfrmPing = class(TForm)
    lstReplies: TListBox;
    ICMP: TIdIcmpClient;
    Panel1: TPanel;
    btnPing: TButton;
    edtHost: TEdit;
    procedure btnPingClick(Sender: TObject);
    procedure ICMPReply(const ReplyStatus: TReplyStatus);
  private
  public
  end;

var
  frmPing: TfrmPing;

implementation
{$R *.DFM}

procedure TfrmPing.btnPingClick(Sender: TObject);
var
  i: integer;
begin
  btnPing.Enabled := False; try
    ICMP.Host := edtHost.Text;
    for i := 1 to 4 do begin
      ICMP.Ping;
      Application.ProcessMessages;
      Sleep(1000);
    end;
  finally btnPing.Enabled := True; end;
end;

procedure TfrmPing.ICMPReply(const ReplyStatus: TReplyStatus);
var
  sTime: string;
begin
  // TODO: check for error on ping reply (ReplyStatus.MsgType?)
  if (ReplyStatus.MsRoundTripTime = 0) then
    sTime := '<1'
  else
    sTime := '=';

  lstReplies.Items.Add(Format('%d bytes from %s: icmp_seq=%d ttl=%d time%s%d ms',
    [ReplyStatus.BytesReceived,
    ReplyStatus.FromIpAddress,
    ReplyStatus.SequenceId,
    ReplyStatus.TimeToLive,
    sTime,
    ReplyStatus.MsRoundTripTime]));
end;

end.
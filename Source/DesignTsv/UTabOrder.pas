unit UTabOrder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst, tsvDesignForm;

type
  TfmTabOrders = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    pnTabOrder: TPanel;
    gbTabOrder: TGroupBox;
    pnList: TPanel;
    pnListR: TPanel;
    btUp: TBitBtn;
    btDown: TBitBtn;
    Panel1: TPanel;
    clbList: TCheckListBox;
    Panel4: TPanel;
    chbViewComponent: TCheckBox;
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure clbListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure clbListClick(Sender: TObject);
    procedure clbListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure clbListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure clbListEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure clbListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    ptCur: TPoint;
    LocalDSB: TDesignScrollBox;
    function GetSelectedIndex: Integer;
  public
    procedure InitTabOrder(wt: TWinControl; DSB: TDesignScrollBox);
    procedure BackUpTabOrder;
  end;

implementation

uses ELDsgnr;

{$R *.DFM}

procedure TfmTabOrders.InitTabOrder(wt: TWinControl; DSB: TDesignScrollBox);
var
  List: TList;
  i: Integer;
  ct: TControl;
  str: string;
  newi: Integer;
begin
  if DSB=nil then exit;
  LocalDSB:=DSB;
  List:=TList.Create;
  try
    wt.GetTabOrderList(List);
    clbList.Items.Clear;
    newi:=0;
    for i:=0 to List.Count-1 do begin
     ct:=List.Items[i];
     if not (ct is TDesignComponentEx) and not (ct is TBoundLabel) then
      if ct.Parent=wt then
       if Trim(ct.Name)<>'' then begin
        str:=ct.Name+': '+ct.Classname;
        clbList.Items.AddObject(str,ct);
        if ct is TWinControl then begin
         clbList.Checked[newi]:=TWinControl(ct).TabStop;
        end;
        inc(newi);
       end;
    end;
    if clbList.Items.Count<>0 then
     clbList.ItemIndex:=0;
  finally
   List.Free;
  end;
end;

function TfmTabOrders.GetSelectedIndex: Integer;
var
  I: Integer;
begin
 result:=-1;
  for i:=0 to clbList.Items.Count-1 do begin
    if clbList.Selected[i] then begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TfmTabOrders.btUpClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if Index>0 then begin
   clbList.Items.Move(Index,Index-1);
   clbList.ItemIndex:=Index-1;
  end;
  clbList.SetFocus;
end;

procedure TfmTabOrders.btDownClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if (Index<>-1)and(Index<>clbList.Items.Count-1) then begin
   clbList.Items.Move(Index,Index+1);
   clbList.ItemIndex:=Index+1;
  end;
  clbList.SetFocus;
end;

procedure TfmTabOrders.BackUpTabOrder;
var
  i: Integer;
  ct: TControl;
begin
    for i:=0 to clbList.Items.Count-1 do begin
     ct:=TControl(clbList.Items.Objects[i]);
     if ct is TWinControl then begin
       TWinControl(ct).TabOrder:=i;
       TWinControl(ct).TabStop:=clbList.Checked[i];
     end;
    end;
end;

procedure TfmTabOrders.clbListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  tmps: string;
  x,y: Integer;
begin
  with clbList.Canvas do begin
    Brush.Style:=bsSolid;
    Brush.Color:=clWindow;
    Pen.Style:=psClear;
    FillRect(rect);
    tmps:=clbList.Items.Strings[Index];
    if State=[odSelected,odFocused] then begin
      Brush.Style:=bsSolid;
      Brush.Color:=clHighlight;
      Font.Color:=clHighlightText;
  //    FillRect(rect);
      Brush.Style:=bsClear;
      x:=rect.Left+2;
      y:=rect.Top;
      TextOut(x,y,tmps);
    end else begin
      Brush.Style:=bsSolid;
      Brush.Color:=clWindow;
      Font.Color:=clWindowText;
//      FillRect(rect);
      if PtInRect(rect,ptCur) then begin
       DrawFocusRect(rect);
      end;
      Brush.Style:=bsClear;
      x:=rect.Left+2;
      y:=rect.Top;
      TextOut(x,y,tmps);
    end;
  end;
end;

procedure TfmTabOrders.clbListClick(Sender: TObject);
var
  ct: TControl;
  doi: TDesignObjInsp;
begin
  if not chbViewComponent.Checked then exit;
  if clbList.Items.Count>0 then begin
    if clbList.ItemIndex<>-1 then begin
      ct:=TControl(clbList.Items.Objects[clbList.ItemIndex]);
      if LocalDSB<>nil then begin
        doi:=LocalDSB.DesignObjInsp;
        if doi<>nil then begin
           doi.SetObject(ct,true);
           clbList.SetFocus;
        end;   
      end;
    end;
  end;
end;

procedure TfmTabOrders.clbListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  val: Integer;
begin
   if (Shift=[ssLeft]) then begin
    val:=clbList.ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val=clbList.ItemIndex then begin
       clbList.BeginDrag(true);
     end;
    end;
   end;
end;

procedure TfmTabOrders.clbListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  val: Integer;
begin
  Accept:=false;
  if Sender=Source then begin
    val:=clbList.ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val<>clbList.ItemIndex then begin
       ptCur:=Point(X,Y);
       Accept:=true;
     end;
    end;
  end;
end;

procedure TfmTabOrders.clbListEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
 val: Integer;
begin
  exit;
  val:=clbList.ItemAtPos(Point(X,Y),true);
  if val<>-1 then begin
    clbList.Items.Move(clbList.ItemIndex,val);
    clbList.ItemIndex:=val;
  end;
end;

procedure TfmTabOrders.clbListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
 val: Integer;
begin
  val:=clbList.ItemAtPos(Point(X,Y),true);
  if val<>-1 then begin
    if val<>clbList.ItemIndex then begin
     if clbList.ItemIndex=-1 then exit;
     clbList.Items.Move(clbList.ItemIndex,val);
     clbList.ItemIndex:=val;
    end;
  end;
end;

procedure TfmTabOrders.FormShow(Sender: TObject);
begin
  clbList.SetFocus;
end;

procedure TfmTabOrders.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Hint:='';
end;

end.

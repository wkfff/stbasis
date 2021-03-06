unit tsvCmdLine;

interface

uses Classes;

type

  TtsvCmdLine=class(TObject)
  private
    function GetFileName: String;
  public
    function ParamExists(const Param: String): Boolean;
    function ValueByParam(const Param: String; Index: Integer=0): String;

    property FileName: String read GetFileName;
  end;

implementation

uses SysUtils;

const
  SwitchChars=['/','-'];

{ TtsvCmdLine }

function TtsvCmdLine.ParamExists(const Param: String): Boolean;
begin
  Result:=FindCmdLineSwitch(Param,SwitchChars,true);
end;

function TtsvCmdLine.ValueByParam(const Param: String; Index: Integer=0): String;
var
  i: Integer;
  ParamExists: Boolean;
  S: string;
  Chars: TSysCharSet;
  Incr: Integer;
begin
  ParamExists:=false;
  Chars:=SwitchChars;
  Incr:=1;
  for i:=1 to ParamCount do begin
    S:=ParamStr(i);
    if (Chars = []) or (S[1] in Chars) then begin
      if (AnsiCompareText(Copy(S, 2, Maxint), Param) = 0) then begin
        ParamExists:=True;
      end;
    end else begin
      if ParamExists then begin
        if Incr=(Index+1) then begin
          Result:=S;
          exit;
        end;  
        Inc(Incr);
      end;
    end;  
  end;
end;

function TtsvCmdLine.GetFileName: String;
begin
  Result:=ParamStr(0);
end;

end.

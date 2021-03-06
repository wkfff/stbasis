unit tsvInterpreterAbbrevia;

interface

uses Classes,
     AbZipper,
     tsvInterpreterCore;

{ TAbZipper }

procedure TAbZipper_AddFiles(var Value: Variant; Args: TArguments);
procedure TAbZipper_AddFromStream(var Value: Variant; Args: TArguments);
procedure TAbZipper_AddFromStrings(var Value: Variant; Args: TArguments);
procedure TAbZipper_Save(var Value: Variant; Args: TArguments);

implementation

// procedure AddFiles(const FileMask : string; SearchAttr : Integer);
procedure TAbZipper_AddFiles(var Value: Variant; Args: TArguments);
begin
  TAbZipper(Args.Obj).AddFiles(Args.Values[0],Args.Values[1]);
end;

//procedure AddFromStream(const NewName : string; FromStream : TStream);
procedure TAbZipper_AddFromStream(var Value: Variant; Args: TArguments);
begin
  TAbZipper(Args.Obj).AddFromStream(Args.Values[0],V2O(Args.Values[1]) as TStream);
end;

// procedure AddFromStrings(Strings: TStrings);
procedure TAbZipper_AddFromStrings(var Value: Variant; Args: TArguments);
begin
  TAbZipper(Args.Obj).AddFromStrings(V2O(Args.Values[0]) as TStrings);
end;

//procedure Save;
procedure TAbZipper_Save(var Value: Variant; Args: TArguments);
begin
  TAbZipper(Args.Obj).FileName:='';
end;

end.

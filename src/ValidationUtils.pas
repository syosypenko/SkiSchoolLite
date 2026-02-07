unit ValidationUtils;

interface

uses
  System.SysUtils;

type
  TValidationUtils = class(TObject)
  public
    class function IsValidEmail(const AEmail: string): Boolean; static;
    class function IsValidPhoneNumber(const APhone: string): Boolean; static;
    class function IsRequiredField(const AField: string): Boolean; static;
    class function IsValidDateRange(AStartDate, AEndDate: TDate): Boolean; static;
  end;

implementation

class function TValidationUtils.IsValidEmail(const AEmail: string): Boolean;
var
  AtPos: Integer;
begin
  Result := False;
  if Trim(AEmail) = '' then
    Exit;

  AtPos := Pos('@', AEmail);
  if (AtPos > 1) and (AtPos < Length(AEmail)) then
  begin
    if Pos('.', Copy(AEmail, AtPos + 1, Length(AEmail))) > 0 then
      Result := True;
  end;
end;

class function TValidationUtils.IsValidPhoneNumber(const APhone: string): Boolean;
var
  I: Integer;
  DigitCount: Integer;
begin
  Result := False;
  if Trim(APhone) = '' then
    Exit;

  DigitCount := 0;
  for I := 1 to Length(APhone) do
  begin
    if APhone[I] in ['0'..'9'] then
      Inc(DigitCount)
    else if not (APhone[I] in [' ', '-', '(', ')', '+', '.']) then
      Exit;
  end;

  Result := DigitCount >= 7;
end;

class function TValidationUtils.IsRequiredField(const AField: string): Boolean;
begin
  Result := Trim(AField) <> '';
end;

class function TValidationUtils.IsValidDateRange(AStartDate, AEndDate: TDate): Boolean;
begin
  Result := (AStartDate > 0) and (AEndDate > 0) and (AStartDate <= AEndDate);
end;

end.

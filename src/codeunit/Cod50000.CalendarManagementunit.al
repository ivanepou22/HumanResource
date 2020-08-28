codeunit 50000 "Calendar Management unit"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    procedure CheckDateStatusHalfDay(CalendarCode: Code[10]; TargetDate: Date; VAR Description: Text[50]): Boolean
    var
        myInt: Integer;

        BaseCalChange: Record "Base Calendar Change";
    begin
        BaseCalChange.RESET;
        BaseCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FINDSET THEN
            REPEAT
                CASE BaseCalChange."Recurring System" OF
                    BaseCalChange."Recurring System"::" ":
                        IF TargetDate = BaseCalChange.Date THEN BEGIN
                            Description := BaseCalChange.Description;
                            //EXIT(BaseCalChange.HalfDay);
                        END;
                    BaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = BaseCalChange.Day THEN BEGIN
                            Description := BaseCalChange.Description;
                            //EXIT(BaseCalChange.HalfDay);
                        END;
                    BaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(BaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(BaseCalChange.Date, 1))
                        THEN BEGIN
                            Description := BaseCalChange.Description;
                            //EXIT(BaseCalChange.HalfDay);
                        END;
                END;
            UNTIL BaseCalChange.NEXT = 0;
        Description := '';
    end;


    //
    procedure CheckDateStatus(CalendarCode: Code[10]; TargetDate: Date; VAR Description: Text[50]): Boolean
    var
        myInt: Integer;
        BaseCalChange: Record "Base Calendar Change";
    begin
        BaseCalChange.RESET;
        BaseCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FINDSET THEN
            REPEAT
                CASE BaseCalChange."Recurring System" OF
                    BaseCalChange."Recurring System"::" ":
                        IF TargetDate = BaseCalChange.Date THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = BaseCalChange.Day THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(BaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(BaseCalChange.Date, 1))
                        THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                END;
            UNTIL BaseCalChange.NEXT = 0;
        Description := '';
    end;
}
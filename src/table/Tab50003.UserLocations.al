table 50003 "User Locations"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "User ID"; Code[30])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Location Code"; Code[30])
        {
            TableRelation = Location.Code;
        }
        field(3; "Location Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Location.Name WHERE(Code = FIELD("Location Code")));
        }

    }

    keys
    {
        key(PK; "User ID", "Location Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
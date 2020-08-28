table 50010 "File Upload"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = IF (Type = CONST(Employee)) Employee ELSE
            IF (Type = FILTER(= 0)) Employee ELSE
            IF (Type = CONST(Applicant)) Applicant;
        }
        field(2; "Misc. Article Code"; Code[10])
        {
            NotBlank = true;
            TableRelation = "Misc. Article";
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                MiscArticle.GET("Misc. Article Code");
                Description := MiscArticle.Description;
            end;
        }
        field(3; "Line No."; Integer) { }
        field(4; Description; Text[50]) { }
        field(5; "From Date"; Date) { }
        field(6; "To Date"; Date) { }
        field(7; "In Use"; Boolean) { }
        field(8; Comment; Boolean) { }
        field(9; "Serial No."; Text[30]) { }
        field(10; Type; Option)
        {
            OptionMembers = " ",Employee,Applicant;
        }
    }

    keys
    {
        key(PK; "Employee No.", "Misc. Article Code", "Line No.", Type)
        {
            Clustered = true;
        }
        key(SK; "Line No.")
        {

        }
    }

    var

        MiscArticle: Record "Misc. Article";

    trigger OnInsert()
    var
        MiscArticleInfo: Record "File Upload";
    begin
        //MiscArticleInfo.SETCURRENTKEY("Line No.");
        IF MiscArticleInfo.FINDLAST THEN
            "Line No." := MiscArticleInfo."Line No." + 1
        ELSE
            "Line No." := 1;
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
table 50004 "Vacancy Request"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job No."; Code[30])
        {
            TableRelation = "Employment Contract".Code;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                EmploymentContract.GET("Job No.");
                VALIDATE("Job Name", EmploymentContract.Description);
            end;
        }
        field(2; "Job Name"; Text[150])
        {
            Editable = false;
        }
        field(3; "Job Description"; Text[250])
        {

        }
        field(4; "Job Responsibilities"; Text[250]) { }
        field(5; "Job Responsibilities 1"; Text[250]) { }
        field(6; "Job Responsibilities 2"; Text[250]) { }
        field(7; "Job Responsibilities 3"; Text[250]) { }
        field(8; "Job Responsibilities 4"; Text[250]) { }
        field(9; "Job Responsibilities 5"; Text[250]) { }
        field(10; "Job Qualifications"; Text[150]) { }
        field(11; "Job Qualifications 2"; Text[150]) { }
        field(12; "Job Qualifications 3"; Text[150]) { }
        field(13; "Job Qualifications 4"; Text[150]) { }
        field(14; "Job Skills"; Text[150]) { }
        field(15; "Job Skills 1"; Text[150]) { }
        field(16; "Job Skills 2"; Text[150]) { }
        field(17; "Job Skills 3"; Text[150]) { }
        field(18; "Job Skills 4"; Text[150]) { }
        field(19; "Job Skills 5"; Text[150]) { }
        field(20; "Request Date"; Date) { }
        field(21; "Last Date Modified"; Date) { }
        field(22; "Created By"; Code[30]) { }
        field(23; "Modified By"; Code[30]) { }
        field(24; "Expected Start Date"; Date) { }
        field(25; "Vadlid From Date"; Date) { }
        field(26; "Valid To Date"; Date) { }
        field(27; "Req No."; Code[30])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Req No." = '' THEN BEGIN
                    HumanResSetup.GET;
                    HumanResSetup.TESTFIELD("Vacancy Nos.");
                    NoSeriesMgt.InitSeries(HumanResSetup."Vacancy Nos.", xRec."No. Series", 0D, "Req No.", "No. Series");
                END;
            end;
        }
        field(28; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(29; "Vacancy Status"; Option)
        {
            OptionMembers = Application,Submit,Rejected,Approved,"Pending Approval";
        }
    }

    keys
    {
        key(PK; "Req No.")
        {
            Clustered = true;
        }
    }

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmploymentContract: Record "Employment Contract";
        Vacancy: Record "Vacancy Request";

    trigger OnInsert()
    begin
        "Created By" := USERID;
        "Last Date Modified" := TODAY;
        IF "Req No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Vacancy Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Vacancy Nos.", xRec."No. Series", 0D, "Req No.", "No. Series");
        END;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
        "Modified By" := USERID;
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
        "Last Date Modified" := TODAY;
        "Modified By" := USERID;
    end;

    //=====================
    procedure AssignEdit(OldVacancy: Record "Vacancy Request"): Boolean
    var
        myInt: Integer;
    begin
        WITH Vacancy DO BEGIN
            Vacancy := Rec;
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Vacancy Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Vacancy Nos.", OldVacancy."No. Series", "No. Series") THEN BEGIN
                HumanResSetup.GET;
                HumanResSetup.TESTFIELD("Vacancy Nos.");
                NoSeriesMgt.SetSeries("Req No.");
                Rec := Vacancy;
                EXIT(TRUE);
            END;
        END;
    end;
}
//In place of Human Resource Comment Line table
table 50001 "Employee Comment Line"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Table Name"; Option)
        {
            OptionMembers = Employee,"Alternative Address","Employee Qualification","Employee Relative","Employee Absence","Misc. Article Information","Confidential Information",EmployeeDonors,Applicant;
        }
        field(2; "No."; Code[20])
        {
            TableRelation = IF ("Table Name" = CONST(Employee)) Employee."No." ELSE
            IF ("Table Name" = CONST("Alternative Address")) "Alternative Address"."Employee No." ELSE
            IF ("Table Name" = CONST("Employee Qualification")) "Employee Qualification"."Employee No." ELSE
            IF ("Table Name" = CONST("Misc. Article Information")) "Misc. Article Information"."Employee No." ELSE
            IF ("Table Name" = CONST("Confidential Information")) "Confidential Information"."Employee No." ELSE
            IF ("Table Name" = CONST("Employee Absence")) "Employee Absence"."Employee No." ELSE
            IF ("Table Name" = CONST("Employee Relative")) "Employee Relative"."Employee No.";// ELSE IF ("Table Name"=CONST(Applicant)) Applicant."No.";

            trigger OnValidate()
            var
                myInt: Integer;
                Applicant: Record Applicant;
            begin
                // August 2018 HR Modification//
                IF Type = Type::Training THEN BEGIN
                    Employee.RESET;
                    Employee.SETRANGE(Employee."No.", "No.");
                    IF Employee.FINDFIRST THEN BEGIN
                        "Employee Name" := Employee."Last Name" + '' + Employee."Middle Name" + ' ' + Employee."First Name";
                    END;
                END;

                //Applicant's Name

                IF "Table Name" = "Table Name"::Applicant THEN BEGIN
                    Applicant.RESET;
                    Applicant.SETRANGE(Applicant."No.", "No.");
                    IF Applicant.FINDFIRST THEN BEGIN
                        "Applicant Name" := Applicant."Full Name";
                    END;
                END;
                // August 2018 HR Modification//

                /* IF (("Table Name" = "Table Name"::Employee) AND ("ED Type" = "ED Type"::Overtime) AND (Type = Type::Overtime)) THEN BEGIN
                     Employee.RESET;
                     Employee.SETRANGE(Employee."No.", "No.");
                     IF Employee.FINDFIRST THEN BEGIN
                         IF Employee."Statistics Group Code" = 'FARM' THEN BEGIN
                             "Earning Code" := 'OVERTIMEFM';
                             "Employee Name" := Employee."Last Name" + '' + Employee."Middle Name" + ' ' + Employee."First Name";
                         END ELSE
                             IF Employee."Statistics Group Code" = 'FINANCE' THEN BEGIN
                                 "Earning Code" := 'OVERTIMEFA';
                                 "Employee Name" := Employee."Last Name" + '' + Employee."Middle Name" + ' ' + Employee."First Name";
                             END ELSE
                                 IF Employee."Statistics Group Code" = 'PRODUCTION' THEN BEGIN
                                     "Earning Code" := 'OVERTIMEPR';
                                     "Employee Name" := Employee."Last Name" + '' + Employee."Middle Name" + ' ' + Employee."First Name";
                                 END ELSE
                                     IF Employee."Statistics Group Code" = 'SALES' THEN BEGIN
                                         "Earning Code" := 'OVERTIMESM';
                                         "Employee Name" := Employee."Last Name" + '' + Employee."Middle Name" + ' ' + Employee."First Name";
                                     END ELSE
                                         IF Employee."Statistics Group Code" = 'SUPPLY' THEN BEGIN
                                             "Earning Code" := 'OVERTIMESC';
                                             "Employee Name" := Employee."Last Name" + '' + Employee."Middle Name" + ' ' + Employee."First Name";
                                         END;
                     END;
                 END;*/
            end;
        }
        field(3; "Table Line No."; Integer) { }
        field(4; "Alternative Address Code"; Code[10])
        {
            TableRelation = IF ("Table Name" = CONST("Alternative Address")) "Alternative Address".Code WHERE("Employee No." = FIELD("No."));
        }
        field(6; "Line No."; Integer) { }
        field(7; Date; Date) { }
        field(8; Code; Code[10]) { }
        field(9; Comment; Text[80]) { }
        field(10; Type; Option)
        {
            OptionMembers = " ",Employee,Discipline,Training,Appraisal,"Job Title",distributionpayroll,Overtime,Grievance,Separation,Letter,interview,Course;
        }
        field(11; Attachment; BLOB) { }
        field(12; "Has Attachment"; Boolean)
        {
            Editable = false;
        }
        field(13; Extension; Text[10]) { }
        field(14; "Disciplinary Description"; Text[250]) { }
        field(15; "Disciplinary Reason"; Code[20])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Discipline));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Confidential.Reset();
                Confidential.SetRange(Confidential.Code, "Disciplinary Reason");
                Confidential.SetRange(Confidential.Type, Confidential.Type::Discipline);
                if Confidential.FindFirst() then
                    "Disciplinary Description" := Confidential.Description;
            end;
        }
        field(16; "Separation Reason Code"; Code[20])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Separation));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Confidential.GET(Confidential.Type::Separation, "Separation Reason Code");
                "Separation Description" := Confidential.Description;
            end;
        }
        field(17; "Separation Description"; Text[250]) { }
        field(18; "Shortcut Dimension 1 Code"; Code[20]) { }
        field(19; "Shortcut Dimension 2 Code"; Code[20]) { }
        field(20; "Shortcut Dimension 3 Code"; Code[20]) { }
        field(21; "Shortcut Dimension 4 Code"; Code[20]) { }
        field(22; "Shortcut Dimension 5 Code"; Code[20]) { }
        field(23; "Shortcut Dimension 6 Code"; Code[20]) { }
        field(24; "Shortcut Dimension 7 Code"; Code[20]) { }
        field(25; "Shortcut Dimension 8 Code"; Code[20]) { }
        field(26; "Dimension Set ID"; Integer)
        {
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(27; "Applicant Name"; Text[150]) { }
        field(28; "Interview Date"; Date) { }
        field(29; "Interview From Time"; Time) { }
        field(30; "Interview To Time"; Time) { }
        field(31; "Interview Status"; Option)
        {
            OptionMembers = Inprogress,Taken,Cancelled;
        }
        field(32; Action; Text[250]) { }
        field(33; "Employee Job title"; Code[20])
        {
            TableRelation = "Employment Contract".Code;
        }
        field(34; "Promotion Type"; Option)
        {
            OptionMembers = " ",Promotion,Demotion;
        }
        field(35; Reason; Text[250]) { }
        field(36; "Action No."; Integer) { }
        field(37; "Training Code"; Code[20])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Training));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF Confidential.GET(Confidential.Type::Training, "Training Code") THEN
                    VALIDATE("Institution Code", Confidential."Institution Code");

                IF ("Line No." <> 0) THEN
                    MODIFY;
            end;
        }
        field(38; "Institution Code"; Code[10])
        {
            TableRelation = Union.Code;
        }
        field(39; Fee; Decimal) { }
        field(40; "Rating Code"; Code[20])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Appraisal));
        }
        field(41; "Action Status"; Option)
        {
            OptionMembers = " ",Taken,"In Progress","Not Taken";
        }
        field(42; "Action By"; Code[20])
        {
            TableRelation = "Employment Contract".Code;
        }
        field(43; "Training Type"; Option)
        {
            OptionMembers = External,Internal;
        }
        field(44; "Training Start Date"; Date) { }
        field(45; "Training End Date"; Date) { }
        field(46; Institution; Text[80]) { }
        field(47; "Action 2"; Option)
        {
            OptionMembers = " ","First Warning","Second Warning","Final Warning",Hearing,Dismissal;
        }
        field(48; "Employee Name"; Text[250]) { }
        field(49; "No2."; Code[20])
        {
            TableRelation = Resource."No.";
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                // August 2018 HR Modification//
                "No." := "No2.";

                IF Type = Type::Training THEN BEGIN
                    Resource1.RESET;
                    Resource1.SETRANGE(Resource1."No.", "No2.");
                    IF Resource1.FINDFIRST THEN BEGIN
                        "Employee Name" := Resource1.Name;
                    END;
                END;
                // August 2018 HR Modification//
            end;
        }
        field(50; "Donor Code"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(false));
        }
        field(51; "Salary Amount"; Decimal) { }
        field(52; "Basic Salary Amount"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                HRSetup.GET;
                IF ("Basic Salary Amount" <> xRec."Basic Salary Amount") THEN BEGIN
                    //public holiday hours
                    "Holiday Amount" := ("Basic Salary Amount" / 26 / 8 * "Holiday No. of days" * HRSetup."Holiday Rate");
                    "Overtime Amounts" := "Holiday Amount" + "NonHoliday Amount";

                    //Normal day hours
                    "NonHoliday Amount" := ("Basic Salary Amount" / 26 / 8 * "Nonholiday No. of days" * HRSetup."NonHoliday Rate");
                    "Overtime Amounts" := "Holiday Amount" + "NonHoliday Amount";

                END;
            end;
        }
        field(53; "Holiday Amount"; Decimal) { }
        field(54; "NonHoliday Amount"; Decimal) { }
        field(55; "Overtime Amounts"; Decimal) { }
        field(56; "ED Type"; Option)
        {
            OptionMembers = " ",Loan,Interest,Advance,Overtime,Absenteeism,DistributionPayroll;
        }
        field(57; "Earning Code"; Code[30])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Earning), "ED Type" = CONST(Overtime));
        }
        field(58; "Holiday No. of days"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
                ASL001: Label 'Holiday Rate can not Zero in the HRSetup Table';
            begin
                HRSetup.GET;
                IF ((HRSetup."Holiday Rate") <> 0.0) THEN BEGIN
                    IF "Holiday No. of days" <> xRec."Holiday No. of days" THEN BEGIN
                        //2
                        "Holiday Amount" := ("Basic Salary Amount" / 26 / 8 * "Holiday No. of days" * HRSetup."Holiday Rate");
                        "Overtime Amounts" := "Holiday Amount" + "NonHoliday Amount";
                    END;
                END ELSE
                    ERROR(ASL001);
            end;
        }
        field(59; "Nonholiday No. of days"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
                ASL002: Label 'Nonholiday Rate Can not be Zero in the HRSetup Table';
            begin
                HRSetup.GET;
                IF ((HRSetup."NonHoliday Rate") <> 0.0) THEN BEGIN
                    IF "Nonholiday No. of days" <> xRec."Nonholiday No. of days" THEN BEGIN
                        //1.5
                        "NonHoliday Amount" := ("Basic Salary Amount" / 26 / 8 * "Nonholiday No. of days" * HRSetup."NonHoliday Rate");
                        "Overtime Amounts" := "Holiday Amount" + "NonHoliday Amount";
                    END;
                END ELSE
                    ERROR(ASL002);
            end;
        }
        field(60; "Transfered To Payroll"; Boolean) { }
        field(61; "Training Status"; Option)
        {
            OptionMembers = " ",Planned,Taken;
        }
        field(62; "Grievance Description"; Text[250]) { }
        field(63; "Separation Description 2"; Text[250]) { }
        field(64; "Bank Code"; Code[30])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST("Employee Bank"));
        }
        field(65; "Bank Name"; Text[150]) { }
        field(66; "From Date"; Date) { }
        field(67; "To Date"; Date) { }
        field(68; "Loan Description"; Text[250]) { }
        field(69; "Loan Status"; Option)
        {
            OptionMembers = " ",Active,Inactive;

        }
        field(70; "User ID"; Code[30]) { }
        field(71; "Last Date Modified"; Date) { }
        field(72; "Payroll Group"; Code[30])
        {
            TableRelation = "Employee Statistics Group";
            trigger OnValidate()
            var
                Confidential1: Record Confidential;
            begin
                //Geting the the overtime earning
                Confidential1.Reset();
                Confidential1.SetRange(Confidential1.Type, Confidential1.Type::Earning);
                Confidential1.SetRange(Confidential1."ED Type", Confidential1."ED Type"::Overtime);
                Confidential1.SetRange(Confidential1."Payroll Group", "Payroll Group");
                IF Confidential1.FindFirst() THEN begin
                    Message('Hello');
                    "Earning Code" := Confidential1.Code;
                end;

            end;
        }
        field(73; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(PK; "Table Name", "No.", "Table Line No.", "Alternative Address Code", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        DimMgt: Codeunit DimensionManagement;
        Confidential: Record Confidential;
        Employee: Record Employee;
        Employee1: Record Employee;
        UserSetup1: Record "User Setup";
        Resource1: Record Resource;
        HRSetup: Record "Human Resources Setup";
    //Applicant   Record Applicant

    trigger OnInsert()
    begin
        "Transfered To Payroll" := false;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
        "Transfered To Payroll" := false;
    end;

    //---------------------------------------
    procedure SetUpNewLine()
    var
        myInt: Integer;
        HumanResCommentLine: Record "Employee Comment Line";
    begin
        HumanResCommentLine := Rec;
        HumanResCommentLine.SETRECFILTER;
        HumanResCommentLine.SETRANGE("Line No.");
        HumanResCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT HumanResCommentLine.FINDFIRST THEN
            Date := WORKDATE;
    end;
    //---------------------------------------

    //-------------------------------------
    procedure ShowShortcutDimCode(VAR ShortcutDimCode: ARRAY[8] OF Code[20])
    var
        myInt: Integer;
    begin

        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
    //-------------------------------------

    //---------------------------------------
    procedure UpdateEmployeeJobTitle()
    var
        myInt: Integer;
        HumResCommLine: Record "Employee Comment Line";
    begin

        HumResCommLine.RESET;
        HumResCommLine.SETCURRENTKEY(Date);
        HumResCommLine.SETRANGE(HumResCommLine."Table Name", HumResCommLine."Table Name"::Employee);
        HumResCommLine.SETRANGE(HumResCommLine."No.", "No.");
        HumResCommLine.SETRANGE(HumResCommLine.Type, HumResCommLine.Type::"Job Title");
        IF HumResCommLine.FINDLAST THEN BEGIN
            IF Employee.GET("No.") THEN BEGIN
                IF ((Rec.Date - HumResCommLine.Date) > 0) THEN
                    Employee."Emplymt. Contract Code" := "Employee Job title"
                ELSE
                    Employee."Emplymt. Contract Code" := HumResCommLine."Employee Job title";
                Employee.MODIFY;
            END;
        END;
    end;
    //---------------------------------------

}
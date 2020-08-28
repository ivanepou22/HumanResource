table 50002 "Applicant"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[30])
        {
            NotBlank = true;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Applicant Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                VALIDATE("Full Name", ("Last Name" + ' ' + "Middle Name" + ' ' + "First Name"));
                VALIDATE("Search Name", (("Last Name" + ' ' + "Middle Name" + ' ' + "First Name" + ' ' + Initials)));
            end;
        }
        field(3; "Middle Name"; Text[30])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                VALIDATE("Full Name", ("Last Name" + ' ' + "Middle Name" + ' ' + "First Name"));
                VALIDATE("Search Name", (("Last Name" + ' ' + "Middle Name" + ' ' + "First Name" + ' ' + Initials)));
            end;
        }
        field(4; "Last Name"; Text[30])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                VALIDATE("Full Name", ("Last Name" + ' ' + "Middle Name" + ' ' + "First Name"));
                VALIDATE("Search Name", (("Last Name" + ' ' + "Middle Name" + ' ' + "First Name" + ' ' + Initials)));
            end;
        }
        field(5; Initials; Text[30])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                VALIDATE("Search Name", (("Last Name" + ' ' + "Middle Name" + ' ' + "First Name" + ' ' + Initials)));
            end;
        }
        field(7; "Search Name"; Code[250])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Search Name" = '' THEN
                    "Search Name" := SetSearchNameToFullnameAndInitials;
            end;
        }
        field(8; Address; Text[50]) { }
        field(9; "Address 2"; Text[50]) { }
        field(10; City; Text[30])
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            //==========================
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(11; "Post Code"; Code[20])
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(12; County; Text[30]) { }
        field(13; "Phone No."; Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(14; "Mobile Phone No."; Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(15; "E-Mail"; Text[80])
        {
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                myInt: Integer;
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(16; "Alt. Address Code"; Code[10])
        {
            TableRelation = "Alternative Address".Code WHERE("Employee No." = FIELD("No."));
        }
        field(17; "Alt. Address Start Date"; Date) { }
        field(18; "Alt. Address End Date"; Date) { }
        field(19; Picture; BLOB)
        {
            Subtype = Bitmap;
        }
        field(20; "Birth Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Age := (TODAY - "Birth Date") / 365;
            end;
        }
        field(21; "Social Security No."; Text[30])
        {

        }
        field(24; Gender; Option)
        {
            OptionMembers = " ",Female,Male;
        }
        field(25; "Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(26; "Full Name"; Text[100]) { }
        field(27; Tribe; Code[20])
        {
            TableRelation = Union.Code WHERE(Type = FILTER("Employee Tribe"));
        }
        field(28; Religion; Code[20])
        {
            TableRelation = Union.Code WHERE(Type = FILTER("Employee Religion"));
        }
        field(29; Village; Text[50]) { }
        field(30; District; Text[50]) { }
        field(31; Nationality; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(32; "No. Series"; Code[20])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(33; "Application Method"; Option)
        {
            OptionMembers = Manual,"Apply to Oldest";
        }
        field(34; "Registration Date"; Date) { }
        field(35; "ID No./Passport No."; Code[20]) { }
        field(36; "Tax Identification No. (TIN)"; Text[50]) { }
        field(37; Age; Decimal)
        {
            Editable = false;
        }
        field(38; "Fathers Name"; Text[50]) { }
        field(39; "Mothers Name"; Text[50]) { }
        field(40; "Last Date Modified"; Date)
        {
            Editable = false;
        }
        field(41; "Last Modified Date Time"; DateTime)
        {
            Editable = false;
        }
        field(42; Status; Option)
        {
            OptionMembers = Application,Declined,Inprogress,Interview,Appointed;
        }
        field(43; "Statistics Group Code"; Code[10])
        {
            TableRelation = "Employee Statistics Group";
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("Statistics Group Code" <> xRec."Statistics Group Code") THEN BEGIN
                    IF EmployeeStatisticsGroup.GET(xRec."Statistics Group Code") THEN BEGIN
                        EmployeeDeductions.RESET;
                        EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", EmployeeStatisticsGroup."Special Deduction Code");
                        EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", "No.");
                        IF EmployeeDeductions.FINDFIRST THEN
                            EmployeeDeductions.DELETE;
                    END;
                END;
            end;
        }
        field(44; "Basic Pay Type"; Option)
        {
            OptionMembers = Fixed,"Resource Units";
        }
        field(45; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionClass = '1,1,1';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(46; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,1,2';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(47; "Major Location"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST("Employee Location"));
        }
        field(48; "Employee No."; Code[30])
        {
            TableRelation = "No. Series".Code;
        }
        field(49; "Job No."; Code[30])
        {
            Editable = false;
        }
        field(50; "Job Name"; Text[100])
        {
            Editable = false;
        }
        field(51; "Vacancy Code"; Code[30])
        {
            TableRelation = "Vacancy Request"."Req No." WHERE("Vacancy Status" = CONST(Approved));
            trigger OnValidate()
            var
                myInt: Integer;
                Vacancy: Record "Vacancy Request";
            begin
                Vacancy.GET("Vacancy Code");
                VALIDATE("Job No.", Vacancy."Job No.");
                VALIDATE("Job Name", Vacancy."Job Name");
            end;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

        PostCode: Record "Post Code";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Res: Record Resource;
        AlternativeAddr: Record "Alternative Address";
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record "Employee Relative";
        EmployeeAbsence: Record "Employee Absence";
        MiscArticleInformation: Record "Misc. Article Information";
        ConfidentialInformation: Record "Earning And Dedcution";
        HumanResComment: Record "Employee Comment Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        EmployeeResUpdate: Codeunit "Employee/Resource Update";
        EmployeeSalespersonUpdate: Codeunit "Employee/Salesperson Update";
        DimMgt: Codeunit DimensionManagement;
        EmployeeCategory: Record "Employment Contract";
        EmployeeStatisticsGroup: Record "Employee Statistics Group";
        EmployeeDeductions: Record "Earning And Dedcution";
        Applicant: Record Applicant;
        Employee: Record Employee;
        NoSeriesLines: Record "No. Series Line";

    trigger OnInsert()
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Date Modified" := TODAY;
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Applicant Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Applicant Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        UpdateSearchName;
        "Registration Date" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Date Modified" := TODAY;
        UpdateSearchName;
    end;

    trigger OnDelete()
    begin
        AlternativeAddr.SETRANGE("Employee No.", "No.");
        AlternativeAddr.DELETEALL;
    end;

    trigger OnRename()
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Date Modified" := TODAY;
        UpdateSearchName;
    end;

    local procedure UpdateSearchName()
    var
        myInt: Integer;
        PrevSearchName: Code[250];
    begin
        PrevSearchName := xRec.FullName + ' ' + xRec.Initials;
        IF ((("First Name" <> xRec."First Name") OR ("Middle Name" <> xRec."Middle Name") OR ("Last Name" <> xRec."Last Name") OR
             (Initials <> xRec.Initials)) AND ("Search Name" = PrevSearchName))
        THEN
            "Search Name" := SetSearchNameToFullnameAndInitials;
    end;

    local procedure SetSearchNameToFullnameAndInitials(): Code[250]
    var
        myInt: Integer;
    begin

        EXIT(FullName + ' ' + Initials);
    end;

    procedure FullName(): Text[100]
    var
        myInt: Integer;
    begin

        IF "Middle Name" = '' THEN
            EXIT("First Name" + ' ' + "Last Name");

        EXIT("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");

    end;

    procedure AssignEdit(OldApplicant: Record Applicant): Boolean
    var
        myInt: Integer;
    begin
        WITH Applicant DO BEGIN
            Applicant := Rec;
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Applicant Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Applicant Nos.", OldApplicant."No. Series", "No. Series") THEN BEGIN
                HumanResSetup.GET;
                HumanResSetup.TESTFIELD("Applicant Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := Applicant;
                EXIT(TRUE);
            END;
        END;
    end;

    procedure UpdateApplicantAsEmployee(BaseUnitOfMeasureCode: Code[10])
    var
        Resource: Record Resource;
        ResourceUnitOfMeasure: Record "Resource Unit of Measure";
        ApplicantNumber: Code[30];
        ApplicantTab: Record Applicant;
    begin
        IF "No." <> '' THEN BEGIN
            CLEAR(EmployeeStatisticsGroup);
            IF "Statistics Group Code" <> '' THEN BEGIN
                IF NOT EmployeeStatisticsGroup.GET("Statistics Group Code") THEN
                    CLEAR(EmployeeStatisticsGroup);

                IF "Basic Pay Type" <> EmployeeStatisticsGroup."Basic Pay Type" THEN BEGIN
                    VALIDATE("Basic Pay Type", EmployeeStatisticsGroup."Basic Pay Type");
                END;
            END;

            IF NOT Employee.GET("No.") THEN BEGIN
                ApplicantNumber := "No.";
                NoSeriesLines.RESET;
                NoSeriesLines.SETRANGE(NoSeriesLines."Series Code", "Employee No.");
                IF NoSeriesLines.FINDFIRST THEN BEGIN
                    "No." := INCSTR(NoSeriesLines."Last No. Used");
                    NoSeriesLines."Last No. Used" := "No.";
                    NoSeriesLines.MODIFY;
                END;
                Employee.INIT;
                Employee."No." := "No.";
                Employee."First Name" := "First Name";
                Employee."Middle Name" := "Middle Name";
                Employee."Last Name" := "Last Name";
                Employee."Full Name" := "Last Name" + ' ' + "Middle Name" + ' ' + "First Name";
                Employee.Initials := Initials;
                Employee."Global Dimension 1 Code" := "Global Dimension 1 Code";
                Employee."Search Name" := "Search Name";
                Employee.City := City;
                Employee."Post Code" := "Post Code";
                Employee."Address 2" := "Address 2";
                Employee.County := County;
                Employee."Phone No." := "Phone No.";
                Employee."Alt. Address Code" := "Alt. Address Code";
                Employee."Alt. Address Start Date" := "Alt. Address Start Date";
                Employee."Alt. Address End Date" := "Alt. Address End Date";
                Employee."Birth Date" := "Birth Date";
                Employee."Mobile Phone No." := "Mobile Phone No.";
                Employee."E-Mail" := "E-Mail";
                Employee."Alt. Address Code" := "Alt. Address Code";
                Employee.Address := Address;
                Employee."Social Security No." := "Social Security No.";
                Employee.Gender := Gender;
                Employee."Country/Region Code" := "Country/Region Code";
                Employee.Status := Employee.Status::Inactive;
                Employee."Status 1" := Employee."Status 1"::Probation;
                Employee."Payroll Status" := Employee."Payroll Status"::Inactive;
                //Employee."Country/Region Code" := "Country/Region Code";	
                Employee."Full Name" := "Full Name";
                Employee.Tribe := Tribe;
                Employee.Village := Village;
                Employee.District := District;
                Employee.Nationality := Nationality;
                Employee."National ID No. (NIN)" := "ID No./Passport No.";
                Employee."Tax Identification No. (TIN)" := "Tax Identification No. (TIN)";
                Employee."Statistics Group Code" := "Statistics Group Code";
                Employee."Basic Pay Type" := "Basic Pay Type";
                Employee."Global Dimension 2 Code" := "Global Dimension 2 Code";
                //Employee."Global Dimension 2 Code" := "Global Dimension 2 Code";	
                Employee."Major Location" := "Major Location";
                Employee.INSERT;
                ChangeApplicationStatus(ApplicantNumber);
                MESSAGE('Employee Number: %1 has been Created Successfully', "No.");
            END ELSE BEGIN
                Employee."Full Name" := "Last Name" + ' ' + "Middle Name" + ' ' + "First Name";
                Employee."Global Dimension 1 Code" := "Global Dimension 1 Code";
                Employee.MODIFY;
            END;
            IF BaseUnitOfMeasureCode = '' THEN BEGIN
                IF EmployeeStatisticsGroup."Base Unit of Measure" <> '' THEN
                    BaseUnitOfMeasureCode := EmployeeStatisticsGroup."Base Unit of Measure";
            END;
        END;

    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        myInt: Integer;
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Applicant, "No.", FieldNumber, ShortcutDimCode);
        MODIFY;
    end;

    procedure ChangeApplicationStatus(NoFilter: Code[30])
    var
        myInt: Integer;
    begin
        Applicant.RESET;
        Applicant.SETFILTER("No.", NoFilter);
        IF Applicant.FINDFIRST THEN BEGIN
            Applicant.Status := Applicant.Status::Appointed;
            Applicant.MODIFY;
        END;
    end;
}
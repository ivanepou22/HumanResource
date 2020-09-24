/*
Adroit HRM V1.0.0 - (c)Copyright Adroit Solutions Ltd. 2020.
This object includes confidential information and intellectual property of Adroit Solutions Ltd,
and is protected by local and international copyright and Trade Secret laws and agreements.
-------------------------------------------------------------------------------------------------------------
Change Log
------------------------------------------------------------------------------------------------------------
DATE       | Author               | Version | Description
------------------------------------------------------------------------------------------------------------
25-06-2020 | IVAN EPOU            | V1.0.0  | Version Completed
promescent.com - Lasts longer
*/
tableextension 50000 "EmployeeExt" extends Employee
{
    fields
    {
        // Add changes to table fields here
        field(50001; Nationality; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(50002; "ID No./Passport No."; Code[20]) { }
        field(50003; "Basic Pay Type"; Option)
        {
            OptionMembers = Fixed,"Resource Units";
        }
        field(50004; "Bank Account No.2"; Code[25]) { }
        field(50005; Bank; Code[20])
        {
            TableRelation = Confidential.Code where(Type = const("Employee Bank"));
            trigger OnValidate()
            var
                myInt: Integer;
                EmpBankAccount: Record Confidential;
            begin
                EmpBankAccount.RESET;
                EmpBankAccount.SETRANGE(EmpBankAccount.Code, Bank);
                IF EmpBankAccount.FINDFIRST THEN BEGIN
                    "Bank Name" := EmpBankAccount.Description;
                    "Bank Code" := EmpBankAccount."Bank Code";
                    "Bank Branch No." := EmpBankAccount."Bank Branch No.";
                END;
            end;
        }
        field(50006; "Staff category"; Option)
        {
            OptionMembers = ,Support,Programme;
        }
        field(50007; "Annual Leave Days B/F"; Integer) { }
        field(50008; "Annual Leave Days Taken"; Decimal)
        {
            Editable = false;
            fieldClass = Flowfield;
            CalcFormula = Sum ("Employee Absence"."Actual Leave Days" where("Employee No." = field("No."), "Absence Type" = const(Leave), "Leave Type" = const("Annual Leave"), "Leave Status" = const(History)));
        }
        field(50009; "Annual Leave Days (Current)"; Integer)
        {
        }
        field(50010; "Annual Leave Days Available"; Integer)
        {
            Editable = false;
        }
        field(50011; "Maternity Leave Days Taken"; Decimal)
        {
            Editable = false;
            fieldClass = Flowfield;
            CalcFormula = Sum ("Employee Absence"."Actual Leave Days" where("Employee No." = field("No."), "Absence Type" = const(Leave), "Leave Type" = const("Maternity Leave"), "From Date" = field("Leave From Date Filter"), "To Date" = field("Leave To Date Filter"), "Leave Status" = const(History)));
        }
        field(50012; "Maternity Leave Days"; Integer) { }
        field(50013; "Maternity Leave Days Available"; Integer)
        {
            Editable = false;
        }
        field(50014; "Paternity Leave Days"; Integer) { }
        field(50015; "Paternity Leave Days Taken"; Decimal)
        {
            Editable = false;
            fieldClass = Flowfield;
            CalcFormula = Sum ("Employee Absence"."Actual Leave Days" where("Employee No." = field("No."), "Absence Type" = const(Leave), "Leave Type" = const("Paternity Leave"), "From Date" = field("Leave From Date Filter"), "To Date" = field("Leave To Date Filter"), "Leave Status" = const(History)));
        }
        field(50016; "Paternity Leave Days Available"; Integer)
        {
            Editable = false;
        }
        field(50017; "Sick Days"; Integer) { }
        field(50018; "Sick Days Taken"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Employee Absence"."Actual Leave Days" WHERE("Employee No." = FIELD("No."), "Absence Type" = CONST(Leave), "Leave Type" = CONST("Sick Leave"), "From Date" = field("Leave From Date Filter"), "To Date" = field("Leave To Date Filter"), "Leave Status" = const(History)));
        }
        field(50019; "Sick Days Available"; Integer)
        {
            Editable = false;
        }
        field(50020; "Study Leave Days"; Integer) { }
        field(50021; "Study Leave Days Taken"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Employee Absence"."Actual Leave Days" WHERE("Employee No." = FIELD("No."), "Absence Type" = CONST(Leave), "Leave Type" = CONST("Study Leave"), "From Date" = FIELD("Leave From Date Filter"), "To Date" = FIELD("Leave To Date Filter"), "Leave Status" = CONST(History)));
        }
        field(50022; "Basic Salary"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
            begin
                if (Rec."Basic Salary" <> xRec."Basic Salary") then begin
                    UserSetup.RESET;
                    UserSetup.SETRANGE(UserSetup."User ID", USERID);
                    IF UserSetup.FINDFIRST THEN BEGIN
                        IF ((UserSetup."Finance Administrator" = FALSE)) THEN BEGIN
                            ERROR('You do not have Permissions to perform this Action. Contact Your Systems Administrator');
                        END ELSE BEGIN
                            IF ("Currency Code" = '') THEN BEGIN
                                VALIDATE("Exchange Rate", 1);
                                MODIFY;
                            END;
                            IF ("Exchange Rate" <> 0) AND ("Basic Salary" <> 0) THEN BEGIN
                                VALIDATE("Basic Salary (LCY)", ("Exchange Rate" * "Basic Salary"));
                                MODIFY;
                            END;
                        END;
                    END;
                END;
                VALIDATE("Full Name", ("Last Name" + ' ' + "Middle Name" + ' ' + "First Name"));
                VALIDATE("Account Title", ("First Name" + ' ' + "Middle Name" + ' ' + "Last Name"));
            end;
        }
        field(50023; "Basic Salary (LCY)"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
            begin
                IF (Rec."Basic Salary (LCY)" <> xRec."Basic Salary (LCY)") THEN BEGIN
                    UserSetup.RESET;
                    UserSetup.SETRANGE(UserSetup."User ID", USERID);
                    IF UserSetup.FINDFIRST THEN BEGIN
                        IF ((UserSetup."Finance Administrator" = FALSE)) THEN
                            ERROR('You do not have Permissions to perform this Action. Contact Your Systems Administrator');
                    END;
                END;
                VALIDATE("Full Name", ("Last Name" + ' ' + "Middle Name" + ' ' + "First Name"));
                VALIDATE("Account Title", ("First Name" + ' ' + "Middle Name" + ' ' + "Last Name"));
            end;
        }
        field(50024; "Payroll Status"; Option)
        {
            OptionMembers = Active,Suspended,Inactive,Terminated;

            trigger OnValidate()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
            begin
                IF (Rec."Payroll Status" <> xRec."Payroll Status") THEN BEGIN
                    UserSetup.RESET;
                    UserSetup.SETRANGE(UserSetup."User ID", USERID);
                    IF UserSetup.FINDFIRST THEN BEGIN
                        IF ((UserSetup."HR Administrator" = FALSE) AND (UserSetup."Finance Administrator" = FALSE)) THEN
                            ERROR('You do not have Permissions to perform this Action. Contact Your Systems Administrator');
                    END;
                END;
            end;
        }
        field(50025; "Currency Code"; Code[10])
        {
            TableRelation = Currency.Code;
        }
        field(50026; "Compassionate Leave Days"; Integer) { }
        field(50027; "Compassionate Leave Days Taken"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Employee Absence"."Actual Leave Days" WHERE("Employee No." = FIELD("No."), "Absence Type" = CONST(Leave), "Leave Type" = CONST("Compassionate Leave"), "From Date" = FIELD("Leave From Date Filter"), "To Date" = FIELD("Leave To Date Filter"), "Leave Status" = CONST(History)));
        }
        field(50028; "Compassionate Leave Available"; Integer)
        {
            Editable = false;
        }
        field(50029; "Leave From Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50030; "Leave To Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50031; "Study Leave Days Available"; Integer)
        {
            Editable = false;
        }
        field(50032; "Leave Without Pay Days"; Integer) { }
        field(50033; "Leave Without Pay Days Taken"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Employee Absence"."Actual Leave Days" WHERE("Employee No." = FIELD("No."), "Absence Type" = CONST(Leave), "Leave Type" = CONST("Leave Without Pay"), "From Date" = FIELD("Leave From Date Filter"), "To Date" = FIELD("Leave To Date Filter"), "Leave Status" = CONST(History)));
        }
        field(50034; "Leave Without Pay Available"; Integer)
        {
            Editable = false;
        }
        field(50035; "Full Name"; Text[150])
        {

        }
        field(50036; Tribe2; Code[20])
        {
            TableRelation = Union.Code WHERE(Type = FILTER("Employee Tribe"));
        }
        field(50037; Religion2; Code[20])
        {
            TableRelation = Union.Code WHERE(Type = FILTER("Employee Religion"));
        }
        field(50038; "Dimension Set ID"; Integer)
        {
            //TableRelation = "Dimension Set Entry";
        }
        field(50039; Department; Code[20]) { }
        field(50040; "Major Location"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST("Employee Location"));
        }
        field(50041; "Exchange Rate"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("Currency Code" = '') AND ("Exchange Rate" > 1) THEN
                    ERROR(ASLT0003);
                TESTFIELD("Basic Salary");
                IF ("Exchange Rate" <> 0) AND ("Basic Salary" <> 0) THEN BEGIN
                    VALIDATE("Basic Salary (LCY)", ("Exchange Rate" * "Basic Salary"));
                    MODIFY;
                END;
            end;
        }
        field(50042; "National ID No. (NIN)"; Text[30]) { }
        field(50043; "Contract Renewal Start Date"; Date) { }
        field(50044; "Contract Renl. Formula"; DateFormula)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("Contract Renewal Start Date" <> 0D) AND (FORMAT("Contract Renl. Formula") <> '') THEN BEGIN
                    "Employment End Date" := CALCDATE("Contract Renl. Formula", "Contract Renewal Start Date") - 1;
                END ELSE BEGIN
                    CLEAR("Employment End Date");
                END;
            end;
        }
        field(50045; "Employment End Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "No. Days Remaining" := "Employment End Date" - TODAY;
            end;
        }
        field(50046; "Probation Date Formula"; DateFormula)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("Employment Date" <> 0D) AND (FORMAT("Probation Date Formula") <> '') THEN BEGIN
                    "Probation End Date" := CALCDATE("Probation Date Formula", "Employment Date");
                END ELSE BEGIN
                    CLEAR("Probation End Date");
                END;
            end;
        }
        field(50047; "Probation End Date"; Date) { }
        field(50048; "No. Days Remaining"; Integer)
        {

        }
        field(50049; "Reason For Disc.1"; Text[200]) { }
        field(50050; "Action For Disc. 1"; Text[200]) { }
        field(50055; "Action Date 1"; Date) { }
        field(50056; "Reason For Disc. 2"; Text[200]) { }
        field(50057; "Action For Disc. 2"; Text[200]) { }
        field(50058; "Action Date 2"; Date) { }
        field(50059; "Reason For Disc. 3"; Text[200]) { }
        field(50065; "Action For Disc. 3"; Text[200]) { }
        field(50066; "Action Date 3"; Date) { }
        field(50067; Village; Text[50]) { }
        field(50068; Tribe; Text[50]) { }
        field(50069; "Religious Affliation"; Text[50]) { }
        field(50070; District; Text[50]) { }
        field(50085; "Cause of Inactivation"; Text[50]) { }
        field(50086; "Reason For Termination"; Text[50]) { }
        field(50087; "Include in Special Deduction"; Boolean)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF EmployeeStatisticsGroup.GET("Statistics Group Code") THEN BEGIN
                    EmployeeDeductions.RESET;
                    EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", EmployeeStatisticsGroup."Special Deduction Code");
                    EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", "No.");
                    IF EmployeeDeductions.FINDFIRST THEN
                        EmployeeDeductions.DELETE;
                END;
            end;
        }
        field(50088; "Type of Exit"; Text[50]) { }
        field(50089; "Extended Probation Formula"; DateFormula)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF Employee.GET("No.") THEN BEGIN
                    CASE "Probation Status" OF
                        "Probation Status"::Extended:
                            BEGIN
                                IF ("Employment Date" <> 0D) AND (FORMAT("Extended Probation Formula") <> '') AND ("Probation End Date" <> 0D) THEN BEGIN
                                    "Probation End Date" := CALCDATE("Extended Probation Formula", "Probation End Date");
                                END ELSE BEGIN
                                    ERROR('One of the following fields is missing. Make sure these fields have been filled in: Employment Date, Probation End Date, Extended Probation Formula.');
                                END;
                            END;
                    END;
                END;
            end;
        }
        field(50090; "Mid Probation Formula"; DateFormula)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("Employment Date" <> 0D) AND (FORMAT("Mid Probation Formula") <> '') THEN BEGIN
                    "Mid Probation End Date" := CALCDATE("Mid Probation Formula", "Employment Date");
                END ELSE BEGIN
                    CLEAR("Mid Probation End Date");
                END;
            end;
        }
        field(50100; "Mid Probation End Date"; Date)
        {
            Editable = false;
        }
        field(50105; "Probation Status"; Option)
        {
            OptionMembers = Confirmation,"Non-confirmation",Extended;
            trigger Onvalidate()
            var
                myInt: Integer;
            begin
                ChangeProbationStatus;
            end;
        }
        field(50106; "Tax Identification No. (TIN)"; Text[50]) { }
        field(50107; "Account Title"; Text[50]) { }
        field(50108; "Bank Name"; Text[50]) { }
        field(50109; "Bank Code"; Code[20])
        {
            trigger Onvalidate()
            var
                myInt: Integer;
                BankAccount: Record "Bank Account";
            begin
                BankAccount.RESET;
                BankAccount.SETRANGE(BankAccount."No.", "Bank Code");
                IF BankAccount.FINDFIRST THEN BEGIN
                    "Bank Name" := BankAccount.Name;
                    "Bank Branch No." := BankAccount."Bank Branch No.";
                    "Bank Account No." := BankAccount."Bank Account No.";
                END;

            end;
        }
        field(50110; "Payment Method"; Option)
        {
            OptionMembers = Bank,"Mobile Money";
        }
        field(50115; "MoMo Number"; Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(50116; "MoMo Name"; Text[30]) { }
        field(50117; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(50118; "Contract Type"; Option)
        {
            OptionMembers = ,"Open Contract","Contract Period";
        }
        field(50119; "Separation Reason"; Code[30])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Separation));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF Confidential.GET(Confidential.Type::Separation, "Separation Reason") THEN BEGIN
                    VALIDATE("Separation Description", Confidential.Description);
                END ELSE
                    VALIDATE("Separation Description", '');
            end;
        }
        field(50120; "Separation Description"; Text[100]) { }
        field(50123; "Status 1"; Option)
        {
            OptionMembers = Active,Inactive,Terminated,Probation,"Non Confirmation",Dismissal,Resignation;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF (Rec."Status 1" <> xRec."Status 1") THEN BEGIN
                    UserSetup.RESET;
                    UserSetup.SETRANGE(UserSetup."User ID", USERID);
                    IF UserSetup.FINDFIRST THEN BEGIN
                        IF ((UserSetup."HR Administrator" = FALSE) AND (UserSetup."Finance Administrator" = FALSE)) THEN BEGIN
                            ERROR('You do not have Permissions to perform this Action. Contact Your Systems Administrator');
                        END ELSE BEGIN
                            IF ("Status 1" = "Status 1"::Active) then begin
                                "Payroll Status" := "Payroll Status"::Active;
                                Status := Status::Active;
                                Modify();
                            end;
                            IF ("Status 1" = "Status 1"::Inactive) OR ("Status 1" = "Status 1"::Dismissal) OR ("Status 1" = "Status 1"::Resignation) then begin
                                "Payroll Status" := "Payroll Status"::Inactive;
                                Status := Status::Inactive;
                                Modify();
                            end;

                            if ("Status 1" = "Status 1"::Terminated) then begin
                                "Payroll Status" := "Payroll Status"::Terminated;
                                Status := Status::Inactive;
                            end;
                        END;
                    END;
                END;
            end;
        }
        field(50125; "Inactive From Date"; Date) { }
        field(50126; "Inactive To Date"; Date) { }
        field(50127; "Tax Percentage"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
    }

    var
        myInt: Integer;
        Employee: Record Employee;
        EmployeeQualification: Record "Employee Qualification";
        Confidential: Record Confidential;
        DimMgt: Codeunit DimensionManagement;
        EmployeeCategory: Record "Employment Contract";
        EmployeeDeductions: Record "Earning And Dedcution";
        UserSetup: Record "User Setup";
        EmployeeStatisticsGroup: Record "Employee Statistics Group";
        ASLT0001: Label 'None of the following dimensions can be empty for the employee %1. Please fill in the missing dimension(s) on the Employee Card';
        ASLT0002: Label 'Employee dimensions cannot be empty. Please fill in the specified dimensions Cost Center Code, Department Code and Staff Code  on the Employee Card for employee %1';
        ASLT0003: Label 'Exchange Rate cannot be greater than 1 when there is no currency code';
        ASLT0004: label 'Do you want the special deduction included for this employee?';
        ASLT0005: Label 'Employee(s) exist(s) that have reached a retirement age';

    //triggers
    trigger OnInsert()
    var
        myInt: Integer;
    begin
        UpdateEmployeeAsResource('');
    end;

    trigger OnModify()
    var
        myInt: Integer;
        EmployeeQualification: Record "Employee Qualification";
    begin
        if ("First Name" <> xRec."First Name") or
        ("Middle Name" <> xRec."Middle Name") or
        ("Last Name" <> xRec."Last Name") then begin
            VALIDATE("Full Name", ("Last Name" + ' ' + "Middle Name" + ' ' + "First Name"));
            VALIDATE("Account Title", ("First Name" + ' ' + "Middle Name" + ' ' + "Last Name"));
        end;

        UpdateEmployeeAsResource('');
    end;

    //end triggers

    //Functions
    procedure UpdateEmployeeAsResource(BaseUnitOfMeasureCode: Code[10])
    var
        //Variables here
        Resource: Record Resource;
        ResourceUnitOfMeasure: Record "Resource Unit of Measure";
    begin
        IF "No." <> '' THEN BEGIN
            CLEAR(EmployeeStatisticsGroup);
            IF "Statistics Group Code" <> '' THEN BEGIN
                IF NOT EmployeeStatisticsGroup.GET("Statistics Group Code") THEN
                    CLEAR(EmployeeStatisticsGroup);

                IF "Basic Pay Type" <> EmployeeStatisticsGroup."Basic Pay Type" THEN BEGIN
                    //IF CONFIRM('Do you want to update the Basic Pay Type to the Type for the selected Group',FALSE) THEN
                    VALIDATE("Basic Pay Type", EmployeeStatisticsGroup."Basic Pay Type");
                END;
            END;

            IF NOT Resource.GET("No.") THEN BEGIN
                Resource.INIT;
                Resource."No." := "No.";
                Resource.Name := "Last Name" + ' ' + "Middle Name" + ' ' + "First Name";
                Resource.Type := Resource.Type::Person;
                Resource."Global Dimension 1 Code" := "Global Dimension 1 Code";
                Resource.VALIDATE("Resource Group No.", "Statistics Group Code");
                IF "Statistics Group Code" <> '' THEN
                    Resource.VALIDATE("Gen. Prod. Posting Group", "Statistics Group Code");
                Resource.INSERT;
            END ELSE BEGIN
                Resource.Name := "Last Name" + ' ' + "Middle Name" + ' ' + "First Name";
                Resource."Global Dimension 1 Code" := "Global Dimension 1 Code";
                IF "Statistics Group Code" <> '' THEN BEGIN
                    Resource.VALIDATE("Gen. Prod. Posting Group", "Statistics Group Code");
                    Resource.VALIDATE("Resource Group No.", "Statistics Group Code");
                END;
                Resource.MODIFY;
            END;

            IF BaseUnitOfMeasureCode = '' THEN BEGIN
                IF EmployeeStatisticsGroup."Base Unit of Measure" <> '' THEN
                    BaseUnitOfMeasureCode := EmployeeStatisticsGroup."Base Unit of Measure";
            END;

            IF BaseUnitOfMeasureCode <> '' THEN BEGIN
                IF NOT ResourceUnitOfMeasure.GET("No.", BaseUnitOfMeasureCode) THEN BEGIN
                    ResourceUnitOfMeasure.INIT;
                    ResourceUnitOfMeasure.VALIDATE("Resource No.", "No.");
                    ResourceUnitOfMeasure.VALIDATE(Code, BaseUnitOfMeasureCode);
                    ResourceUnitOfMeasure.INSERT(TRUE);
                END;
                Resource.VALIDATE("Base Unit of Measure", BaseUnitOfMeasureCode);
                Resource.MODIFY;
            END;
        END;

    end;

    //--------------------------------------------
    procedure LookupShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        myInt: Integer;
    begin

        ///TESTFIELD("Check Printed",FALSE);
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

    end;
    //--------------------------------------------

    //-------------------------------------------
    procedure InsertEmployeeDimensions(ShortcutDim1: Code[20];
       ShortcutDim2: Code[20];
       ShortcutDim3: Code[20];
       ShortcutDim4: Code[20];
       ShortcutDim5: Code[20];
       ShortcutDim6: Code[20];
       ShortcutDim7: Code[20];
       ShortcutDim8: Code[20])
    var
        myInt: Integer;
        EmployeeDimension: Record "Employee Comment Line";
        LineNo: Integer;
    begin
        EmployeeDimension.RESET;
        EmployeeDimension.SETRANGE(EmployeeDimension."Table Name", EmployeeDimension."Table Name"::Employee);
        EmployeeDimension.SETRANGE(EmployeeDimension."No.", "No.");
        EmployeeDimension.SETRANGE("Table Line No.", 5200);
        EmployeeDimension.SETRANGE("Alternative Address Code", '');
        EmployeeDimension.SETRANGE("Line No.", 10000);
        EmployeeDimension.SETRANGE(Type, EmployeeDimension.Type::Employee);
        IF EmployeeDimension.FINDFIRST THEN BEGIN
            EmployeeDimension."Shortcut Dimension 1 Code" := ShortcutDim1;
            EmployeeDimension."Shortcut Dimension 2 Code" := ShortcutDim2;
            EmployeeDimension."Shortcut Dimension 3 Code" := ShortcutDim3;
            EmployeeDimension."Shortcut Dimension 4 Code" := ShortcutDim4;
            EmployeeDimension."Shortcut Dimension 5 Code" := ShortcutDim5;
            EmployeeDimension."Shortcut Dimension 6 Code" := ShortcutDim6;
            EmployeeDimension."Shortcut Dimension 7 Code" := ShortcutDim7;
            EmployeeDimension."Shortcut Dimension 8 Code" := ShortcutDim8;
            EmployeeDimension.MODIFY;
        END ELSE BEGIN
            EmployeeDimension.INIT;
            EmployeeDimension."Table Name" := EmployeeDimension."Table Name"::Employee;
            EmployeeDimension."No." := "No.";
            EmployeeDimension."Table Line No." := 5200;
            EmployeeDimension."Alternative Address Code" := '';
            EmployeeDimension."Line No." := 10000;
            EmployeeDimension.Type := EmployeeDimension.Type::Employee;
            EmployeeDimension."Shortcut Dimension 1 Code" := ShortcutDim1;
            EmployeeDimension."Shortcut Dimension 2 Code" := ShortcutDim2;
            EmployeeDimension."Shortcut Dimension 3 Code" := ShortcutDim3;
            EmployeeDimension."Shortcut Dimension 4 Code" := ShortcutDim4;
            EmployeeDimension."Shortcut Dimension 5 Code" := ShortcutDim5;
            EmployeeDimension."Shortcut Dimension 6 Code" := ShortcutDim6;
            EmployeeDimension."Shortcut Dimension 7 Code" := ShortcutDim7;
            EmployeeDimension."Shortcut Dimension 8 Code" := ShortcutDim8;
            EmployeeDimension.INSERT(TRUE);
        END;
    end;
    //-------------------------------------------

    //--------------------------------------------
    procedure ShowShortcutDimCode(VAR ShortcutDimCode: ARRAY[8] OF Code[20])
    var
        myInt: Integer;
    begin

        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);

    end;
    //--------------------------------------------
    //---------------------------------------
    procedure TestEmployeeDimensions()
    var
        myInt: Integer;
        EmployeeDimension: Record "Employee Comment Line";
    begin
        // EmployeeDimension.RESET;
        // EmployeeDimension.SETRANGE(EmployeeDimension."Table Name", EmployeeDimension."Table Name"::Employee);
        // EmployeeDimension.SETRANGE(EmployeeDimension."No.", "No.");
        // EmployeeDimension.SETRANGE("Table Line No.", 5200);
        // EmployeeDimension.SETRANGE("Alternative Address Code", '');
        // EmployeeDimension.SETRANGE("Line No.", 10000);
        // EmployeeDimension.SETRANGE(Type, EmployeeDimension.Type::Employee);
        // IF EmployeeDimension.FINDFIRST THEN BEGIN
        //     IF (EmployeeDimension."Shortcut Dimension 3 Code" = '') OR (EmployeeDimension."Shortcut Dimension 4 Code" = '') THEN
        //         ERROR(ASLT0001, EmployeeDimension."No.");
        // END ELSE BEGIN
        //     ERROR(ASLT0002, EmployeeDimension."No.");
        // END;
    end;
    //---------------------------------------

    //----------------------------
    procedure ValidateShortcutDimensionCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        myInt: Integer;
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;
    //----------------------------

    //------------------------------------
    procedure GetRetirees()
    var
        myInt: Integer;
        X: Integer;
        EmployeeRecord: Record Employee;
        EmployeeRetirement: Report "Employee Retirement";
    begin
        X := 0;

        EmployeeRecord.RESET;
        EmployeeRecord.SETFILTER("No.", '<>%1', '');
        EmployeeRecord.SETFILTER("Birth Date", '<>%1', 0D);
        IF EmployeeRecord.FINDFIRST THEN
            REPEAT
                IF (((TODAY - EmployeeRecord."Birth Date") / 365) >= 65) THEN BEGIN
                    X := X + 1;
                END;
            UNTIL EmployeeRecord.NEXT = 0;

        IF (X >= 1) THEN BEGIN
            IF CONFIRM(ASLT0005 + '. No. of Employees: ' + FORMAT(X) + '. Do you want to view the retirement report?') THEN BEGIN
                EmployeeRetirement.RUN;
            END;
        END ELSE BEGIN
            //MESSAGE('Sorry!!! ' + FORMAT(X));
        END;
    end;
    //-----------------------------------------------

    //--------------------------------------------
    procedure ChangeProbationStatus()
    var
        myInt: Integer;
    begin
        IF Employee.GET("No.") THEN BEGIN
            CASE "Probation Status" OF
                "Probation Status"::Confirmation:
                    BEGIN
                        Status := Status::Active;
                    END;
                "Probation Status"::"Non-confirmation":
                    BEGIN
                        Status := Status::Inactive;
                    END;
                "Probation Status"::Extended:
                    BEGIN
                        IF ("Employment Date" <> 0D) AND (FORMAT("Extended Probation Formula") <> '') AND ("Probation End Date" <> 0D) THEN BEGIN
                            "Probation End Date" := CALCDATE("Extended Probation Formula", "Probation End Date");
                        END ELSE BEGIN
                            ERROR('One of the following fields is missing. Make sure these fields have been filled in: Employment Date, Probation End Date, Extended Probation Formula.');
                        END;
                    END;
            END;
        END;
    end;
    //-----------------------------------------------
}
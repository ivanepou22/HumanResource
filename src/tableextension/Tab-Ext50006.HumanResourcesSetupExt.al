tableextension 50006 "Human Resources Setup Ext" extends "Human Resources Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50005; "Test Leave Appln. before"; Boolean) { }
        field(50006; "Leave Appln. before Formula"; DateFormula) { }
        field(50007; "Max No. of People On Leave"; Integer) { }
        field(50008; "Current Leave Period"; Integer) { }
        field(50009; "Public Holidays"; Text[250]) { }
        field(50010; "HR Calendar"; Code[20])
        {
            TableRelation = "Base Calendar".Code;
        }
        field(50011; "Annual Leave Absence Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(50012; "Maternity Leave Absence Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(50013; "Paternity Leave Absence Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(50014; "Study Leave Absence Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(50015; "Sick Leave Absence Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(50016; "Count NW Days In Leave Period"; Boolean) { }
        field(50017; "Income Tax Payable Acc. Type"; Option)
        {
            OptionMembers = "G/L Account",Vendor;
        }
        field(50018; "Income Tax Payable Acc. No."; Code[20])
        {
            TableRelation = IF ("Income Tax Payable Acc. Type" = CONST("G/L Account")) "G/L Account"."No." ELSE
            IF ("Income Tax Payable Acc. Type" = CONST(Vendor)) Vendor."No.";
        }
        field(50019; "Income Tax Expense Acc. No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50020; "Income Tax Range Table Code"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST("Range Table"));
        }
        field(50021; "Last Payroll Processing Date"; Date) { }
        field(50022; "Next Payroll Processing Date"; Date) { }
        field(50023; "Payroll Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(50024; "Payroll Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payroll Journal Template Name"));
        }
        field(50025; "Basic Salary Expense Acc. No."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50026; "Payments Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(50027; "Payments Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payments Journal Template Name"));
        }
        field(50028; "Salaries Payable Account Type"; Option)
        {
            OptionMembers = "G/L Account",Vendor;
        }
        field(50029; "Salaries Payable Account No."; Code[20])
        {
            TableRelation = IF ("Salaries Payable Account Type" = CONST("G/L Account")) "G/L Account"."No." ELSE
            IF ("Salaries Payable Account Type" = CONST(Vendor)) Vendor."No.";
        }
        field(50030; "Basic Pay Expense Posting Type"; Option)
        {
            OptionMembers = Individual,Block;
        }
        field(50031; "Tax Payable Posting Type"; Option)
        {
            OptionMembers = Individual,Block;
        }
        field(50032; "Net Pay Payable Posting Type"; Option)
        {
            OptionMembers = Individual,Block;
        }
        field(50033; "Payroll Processing Frequency"; Option)
        {
            OptionMembers = Monthly,Weekly,"Bi-Weekly";
        }
        field(50034; "Full Time Employees Stats. Grp"; Code[10])
        {
            TableRelation = "Employee Statistics Group".Code;
        }
        field(50035; "Show Only F.Time on Emp. List"; Boolean) { }
        field(50036; "Contract Employees Stats. Grp"; Code[10])
        {
            TableRelation = "Employee Statistics Group".Code;
        }
        field(50040; "Compassionate Leave Abs. Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(50050; "Leave Without Pay Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(50060; "Loan Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50061; "Advance Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50065; "Loan Interest Doc. Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50070; "Farm Employees Stats. Grp"; Code[10])
        {
            TableRelation = "Employee Statistics Group".Code;
        }
        field(50080; "Local Tax Payable Acc. Type"; Option)
        {
            OptionMembers = "G/L Account",Vendor;
        }
        field(50085; "Local Tax Payable Acc. No."; Code[20])
        {
            TableRelation = IF ("Local Tax Payable Acc. Type" = CONST("G/L Account")) "G/L Account"."No." ELSE
            IF ("Local Tax Payable Acc. Type" = CONST(Vendor)) Vendor."No.";
        }
        field(50090; "Local Tax Expense Acc. No."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50095; "Local Tax Range Table Code"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST("Range Table"));
        }
        field(50100; "Integrate with Financials"; Boolean) { }
        field(50110; "Retirement Threshold(Years)"; Integer) { }
        field(50111; "Holiday Rate"; Decimal) { }
        field(50112; "NonHoliday Rate"; Decimal) { }
        field(50113; "Applicant Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50114; "Vacancy Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
    }

    var
        myInt: Integer;
        HumanResUnitOfMeasure: Record "Human Resource Unit of Measure";
        EmployeeAbsence: Record "Employee Absence";
        ASLT0001: Label 'Are you sure you would like to Initialize all leave days? This will reset all leave entitlements for the current year for all employees';
        ASLT0002: Label ' You can initialize leave days only once in a year';


    //---------------------------------------
    procedure InitializeLeaveDays()
    var
        myInt: Integer;
        JobTitles: Record "Employment Contract";
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
    begin
        IF CONFIRM(ASLT0001, FALSE) THEN BEGIN
            JobTitles.RESET;
            IF JobTitles.FINDSET THEN BEGIN
                REPEAT
                    Employee.RESET;
                    Employee.SETRANGE(Employee."Emplymt. Contract Code", JobTitles.Code);
                    Employee.SETRANGE(Status, Employee.Status::Active);
                    IF Employee.FINDSET THEN BEGIN
                        REPEAT
                            EmployeeAbsence.RESET;
                            EmployeeAbsence.SETCURRENTKEY("Employee No.", "Absence Type", "Leave Type", "Leave Status", "From Date", "To Date");
                            EmployeeAbsence.SETRANGE(EmployeeAbsence."Employee No.", Employee."No.");
                            EmployeeAbsence.SETRANGE(EmployeeAbsence."Absence Type", EmployeeAbsence."Absence Type"::Leave);
                            EmployeeAbsence.SETRANGE(EmployeeAbsence."Leave Type", EmployeeAbsence."Leave Type"::"Annual Leave");
                            EmployeeAbsence.SETRANGE(EmployeeAbsence."Leave Status", EmployeeAbsence."Leave Status"::History);
                            EmployeeAbsence.SETFILTER(EmployeeAbsence."From Date", STRSUBSTNO('%1..', DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3) - 1)));
                            EmployeeAbsence.SETFILTER(EmployeeAbsence."To Date", STRSUBSTNO('..%1', CALCDATE('-1D', DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)))));
                            IF EmployeeAbsence.FINDFIRST THEN BEGIN
                                EmployeeAbsence.CALCSUMS("Actual Leave Days");
                                IF "Current Leave Period" <> DATE2DMY(WORKDATE, 3) THEN BEGIN
                                    IF (JobTitles."Annual Leave Days C/F" <> 0) THEN BEGIN
                                        Employee."Annual Leave Days B/F" := JobTitles."Annual Leave Days C/F";
                                    END ELSE BEGIN
                                        CASE JobTitles."Carry Forward Annual Leave" OF
                                            JobTitles."Carry Forward Annual Leave"::Never:
                                                Employee."Annual Leave Days B/F" := 0;//No Carry Forward
                                            JobTitles."Carry Forward Annual Leave"::"1 Year":
                                                Employee."Annual Leave Days B/F" := JobTitles."Annual Leave Days" - EmployeeAbsence."Actual Leave Days";//Carry Forward Balance
                                            JobTitles."Carry Forward Annual Leave"::Always:
                                                Employee."Annual Leave Days B/F" += EmployeeAbsence."Actual Leave Days";//Add Balance to Carry Forward
                                        END;
                                    END;
                                END;
                            END ELSE
                                IF "Current Leave Period" > 0 THEN BEGIN//Only do this if Leave had been initialized. i.e not done for the first initalization
                                                                        //There will be no leaves taken for first initialization
                                                                        //But Leave days B/F must only be set manually
                                    IF "Current Leave Period" = DATE2DMY(WORKDATE, 3) THEN BEGIN
                                        IF (JobTitles."Annual Leave Days C/F" <> 0) THEN BEGIN
                                            Employee."Annual Leave Days B/F" := JobTitles."Annual Leave Days C/F";
                                        END ELSE BEGIN
                                            CASE JobTitles."Carry Forward Annual Leave" OF
                                                JobTitles."Carry Forward Annual Leave"::Never:
                                                    Employee."Annual Leave Days B/F" := 0;//No Carry Forward
                                                JobTitles."Carry Forward Annual Leave"::"1 Year":
                                                    Employee."Annual Leave Days B/F" := JobTitles."Annual Leave Days";//No Leave Taken In Previous Year. Carry Forward Entitled Leave Days
                                                JobTitles."Carry Forward Annual Leave"::Always:
                                                    Employee."Annual Leave Days B/F" += EmployeeAbsence."Actual Leave Days";//No Leave Taken In Previous Year. Add Entitledment to B/F
                                            END;
                                        END;
                                    END;
                                END;
                            Employee."Annual Leave Days (Current)" := JobTitles."Annual Leave Days";
                            IF Employee.Gender = Employee.Gender::Female THEN
                                Employee."Maternity Leave Days" := JobTitles."Maternity Leave Days"
                            ELSE
                                Employee."Maternity Leave Days" := 0;

                            IF Employee.Gender = Employee.Gender::Male THEN
                                Employee."Paternity Leave Days" := JobTitles."Paternity Leave Days"
                            ELSE
                                Employee."Paternity Leave Days" := 0;

                            Employee."Sick Days" := JobTitles."Sick Days";
                            Employee."Study Leave Days" := JobTitles."Study Leave Days";
                            Employee."Compassionate Leave Days" := JobTitles."Compassionate Leave Days";
                            Employee."Leave Without Pay Days" := JobTitles."Leave Without Pay Days";
                            Employee.MODIFY;
                        UNTIL Employee.NEXT = 0;
                    END;
                UNTIL JobTitles.NEXT = 0;
            END;
            "Current Leave Period" := DATE2DMY(WORKDATE, 3);
            MODIFY;
        END;
    end;
    //---------------------------------------

    //--------------------------------------
    procedure CloseLeaveRecords()
    var
        myInt: Integer;
        Employee: Record Employee;
        EmployeeCategory: Record "Employment Contract";
    begin
        Employee.RESET;
        IF Employee.FIND('-') THEN
            REPEAT
                Employee.TESTFIELD(Employee."Emplymt. Contract Code");
                Employee.SETRANGE(Status, Employee.Status::Active);
                IF EmployeeCategory.GET(Employee."Emplymt. Contract Code") THEN BEGIN
                    //Annual Leave
                    CASE EmployeeCategory."Carry Forward Annual Leave" OF
                        EmployeeCategory."Carry Forward Annual Leave"::Never:
                            Employee."Annual Leave Days B/F" := 0;
                        EmployeeCategory."Carry Forward Annual Leave"::"1 Year":
                            BEGIN
                                IF Employee."Annual Leave Days Available" > EmployeeCategory."Annual Leave Days" THEN
                                    Employee."Annual Leave Days B/F" := EmployeeCategory."Annual Leave Days"
                                ELSE
                                    Employee."Annual Leave Days B/F" := Employee."Annual Leave Days Available";
                            END;
                        EmployeeCategory."Carry Forward Annual Leave"::Always:
                            Employee."Annual Leave Days B/F" := Employee."Annual Leave Days Available";
                    END;

                    Employee."Annual Leave Days Taken" := 0;
                    Employee."Annual Leave Days (Current)" := EmployeeCategory."Annual Leave Days";
                    Employee."Annual Leave Days Available" := (Employee."Annual Leave Days B/F" + Employee."Annual Leave Days (Current)");

                    Employee.TESTFIELD(Employee.Gender);
                    IF Employee.Gender = Employee.Gender::Female THEN BEGIN
                        //Maternity Leave
                        Employee."Maternity Leave Days" := EmployeeCategory."Maternity Leave Days";
                        Employee."Maternity Leave Days Taken" := 0;
                        Employee."Maternity Leave Days Available" := Employee."Maternity Leave Days";

                        //Paternity
                        Employee."Paternity Leave Days" := 0;
                        Employee."Paternity Leave Days Taken" := 0;
                        Employee."Paternity Leave Days Available" := 0;
                    END ELSE BEGIN
                        //Maternity Leave
                        Employee."Maternity Leave Days" := 0;
                        Employee."Maternity Leave Days Taken" := 0;
                        Employee."Maternity Leave Days Available" := 0;

                        //Paternity
                        Employee."Paternity Leave Days" := EmployeeCategory."Paternity Leave Days";
                        Employee."Paternity Leave Days Taken" := 0;
                        Employee."Paternity Leave Days Available" := Employee."Paternity Leave Days";
                    END;

                    //Sick
                    Employee."Sick Days" := EmployeeCategory."Sick Days";
                    Employee."Sick Days Taken" := 0;
                    Employee."Sick Days Available" := Employee."Sick Days";

                    //Study
                    Employee."Study Leave Days" := EmployeeCategory."Study Leave Days";
                    Employee."Study Leave Days Taken" := 0;
                    Employee."Study Leave Days Available" := Employee."Study Leave Days";

                    //Compassionate
                    //Employee."Compassionate Leave Days" :

                    Employee.MODIFY;
                END ELSE
                    ERROR(STRSUBSTNO(Employee."Emplymt. Contract Code", Employee."No."));
            UNTIL Employee.NEXT = 0;
    end;
    //--------------------------------------
}
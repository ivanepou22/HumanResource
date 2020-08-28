
//In place of confidential information table

table 50000 "Earning And Dedcution"
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee."No.";
        }
        field(2; "Confidential Code"; Code[10])
        {
            TableRelation = IF (Type = CONST(Earning)) Confidential.Code WHERE(Type = CONST(Earning)) ELSE
            IF (Type = CONST(Deduction)) Confidential.Code WHERE(Type = CONST(Deduction)) ELSE
            IF (Type = CONST(" ")) Confidential.Code WHERE(Type = CONST(" "));

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF Confidential.GET("Confidential Code") THEN BEGIN
                    Description := Confidential.Description;
                    Type := Confidential.Type;
                    IF (Confidential.Type = Confidential.Type::Earning) OR (Confidential.Type = Confidential.Type::Deduction) THEN BEGIN
                        "Amount Basis" := Confidential."Amount Basis";
                        "Fixed Amount" := Confidential."Default Fixed Amount";
                        Percentage := Confidential.Percentage;
                        Recurrence := Confidential.Recurrence;
                        "Has Employer Component" := Confidential."Has Employer Component";
                        "Employer Amount Basis" := Confidential."Employer Amount Basis";
                        "Employer Fixed Amount" := Confidential."Default Employer Fixed Amount";
                        "Employer Percentage" := Confidential."Employer Percentage";
                        "Threshold Balance" := Confidential."Default Threshold Balance";
                        "Fixed Rate" := Confidential."Default Fixed Rate";
                        VALIDATE("Payroll Code", Confidential."Payroll Group");
                        VALIDATE("Parent Code2", Confidential."Parent Code2");
                        VALIDATE("ED Type", Confidential."ED Type");
                    END;
                END;
            end;
        }
        field(3; "Line No."; Integer)
        {
            NotBlank = true;
        }
        field(4; Description; Text[50])
        {

        }
        field(5; Comment; Boolean)
        {

        }
        field(6; Type; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Min (Confidential.Type WHERE(Code = FIELD("Confidential Code")));
            OptionMembers = " ",Earning,Deduction;
        }
        field(7; "Amount Basis"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Min (Confidential."Amount Basis" WHERE(Code = FIELD("Confidential Code")));
            OptionMembers = "Fixed Amount","Percentage of Basic Pay","Percentage of Gross Pay","Percentage of Taxable Pay","Income Tax Amount","Range Table";
        }
        field(8; "Fixed Amount"; Decimal)
        {

        }
        field(9; "Has Employer Component"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Min (Confidential."Has Employer Component" WHERE(Code = FIELD("Confidential Code")));
        }
        field(10; "Employer Amount Basis"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Min (Confidential."Employer Amount Basis" WHERE(Code = FIELD("Confidential Code")));
            OptionMembers = "Fixed Amount","Percentage of Basic Pay","Percentage of Gross Pay","Percentage of Taxable Pay","Income Tax Amount","Range Table";
        }
        field(11; "Employer Fixed Amount"; Decimal)
        {

        }
        field(12; Recurrence; Option)
        {
            OptionMembers = Never,Always,"On Balance";
        }
        field(13; "Opening Balance"; Decimal)
        {

        }
        field(14; "Current Balance"; Decimal)
        {

        }
        field(15; "Threshold Balance"; Decimal)
        {

        }
        field(16; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Approved,Rejected,Active,Suspended,Cancelled;
        }
        field(17; Percentage; Decimal)
        {

        }
        field(18; "Employer Percentage"; Decimal)
        {

        }

        field(19; "System Created"; Boolean)
        {

        }
        field(20; "Date Created"; Date)
        {

        }
        field(21; "Created By"; Code[50])
        {

        }
        field(22; "Last Modified By"; Code[50])
        {

        }
        field(23; "Date Last Modified"; Date)
        {

        }
        field(24; "ED Type"; Option)
        {
            OptionMembers = " ",Loan,Interest,Advance,Overtime,Absenteeism;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("ED Type" = "ED Type"::Overtime) THEN BEGIN
                    IF Employee.GET("Employee No.") THEN BEGIN
                        IF (Employee."Basic Salary (LCY)" <> 0) THEN BEGIN
                            // Calculate Overtime's Fixed Rate
                            Employee.TESTFIELD(Employee."Statistics Group Code");
                            EmployeePayrollGroup.GET(Employee."Statistics Group Code");
                            IF (EmployeePayrollGroup."Next Payroll Processing Date" <> 0D) THEN BEGIN
                                CurrentMonthMidDate := '15' + '/' + FORMAT(DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 2))
                                                         + '/' + FORMAT(DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 3));
                                PreviousMonthMidDate := '15' + '/' + FORMAT(DATE2DMY(EmployeePayrollGroup."Last Payroll Processing Date", 2))
                                                         + '/' + FORMAT(DATE2DMY(EmployeePayrollGroup."Last Payroll Processing Date", 3));

                                EVALUATE(CurrentDate, CurrentMonthMidDate);
                                EVALUATE(PreviousDate, PreviousMonthMidDate);
                                MonthDays := CurrentDate - PreviousDate;
                                //MonthDays := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 1);
                                "Fixed Rate" := (Employee."Basic Salary (LCY)" / (MonthDays * 8));
                            END;
                        END;
                    END;
                END;

                IF ("ED Type" = "ED Type"::Absenteeism) THEN BEGIN
                    IF Employee.GET("Employee No.") THEN BEGIN
                        IF (Employee."Basic Salary (LCY)" <> 0) THEN BEGIN
                            // Calculate Overtime's Fixed Rate
                            Employee.TESTFIELD(Employee."Statistics Group Code");
                            EmployeePayrollGroup.GET(Employee."Statistics Group Code");
                            IF (EmployeePayrollGroup."Next Payroll Processing Date" <> 0D) THEN BEGIN
                                CurrentMonthMidDate := '15' + '/' + FORMAT(DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 2))
                                                         + '/' + FORMAT(DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 3));
                                PreviousMonthMidDate := '15' + '/' + FORMAT(DATE2DMY(EmployeePayrollGroup."Last Payroll Processing Date", 2))
                                                         + '/' + FORMAT(DATE2DMY(EmployeePayrollGroup."Last Payroll Processing Date", 3));

                                EVALUATE(CurrentDate, CurrentMonthMidDate);
                                EVALUATE(PreviousDate, PreviousMonthMidDate);
                                MonthDays := CurrentDate - PreviousDate;
                                //MonthDays := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 1);
                                "Fixed Rate" := (Employee."Basic Salary (LCY)" / (MonthDays));
                            END;
                        END;
                    END;
                END;
            end;
        }
        field(25; "Fixed Rate"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("ED Type" = "ED Type"::Absenteeism) THEN BEGIN
                    IF ("Fixed Amount" <> 0) THEN BEGIN
                        IF CONFIRM(ASLT00001, FALSE) THEN
                            IF ("Fixed Rate" <> 0) AND ("Fixed Quantity" <> 0) THEN
                                "Fixed Amount" := "Fixed Rate" * "Fixed Quantity";

                    END ELSE BEGIN
                        IF ("Fixed Rate" <> 0) AND ("Fixed Quantity" <> 0) THEN
                            "Fixed Amount" := "Fixed Rate" * "Fixed Quantity";
                    END;
                    IF ("Line No." <> 0) THEN
                        MODIFY;
                END;
            end;
        }
        field(26; "Fixed Quantity"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("ED Type" = "ED Type"::Absenteeism) THEN BEGIN
                    IF ("Fixed Amount" <> 0) THEN BEGIN
                        IF CONFIRM(ASLT00001, FALSE) THEN
                            IF ("Fixed Rate" <> 0) AND ("Fixed Quantity" <> 0) THEN
                                "Fixed Amount" := "Fixed Rate" * "Fixed Quantity";

                    END ELSE BEGIN
                        IF ("Fixed Rate" <> 0) AND ("Fixed Quantity" <> 0) THEN
                            "Fixed Amount" := "Fixed Rate" * "Fixed Quantity";
                    END;
                    IF ("Line No." <> 0) THEN
                        MODIFY;
                END;
            end;
        }
        field(27; "Week Day Hours"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "ED Type" = "ED Type"::Overtime THEN BEGIN
                    "Fixed Amount" := "Fixed Rate" * ((1.5 * "Week Day Hours") + (2 * "Weekend / Public Holiday Hours"));
                END;
            end;
        }
        field(28; "Weekend / Public Holiday Hours"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "ED Type" = "ED Type"::Overtime THEN BEGIN
                    "Fixed Amount" := "Fixed Rate" * ((1.5 * "Week Day Hours") + (2 * "Weekend / Public Holiday Hours"));
                END;
            end;
        }
        field(29; "Employee Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
        }
        field(30; "Payroll Code"; Code[30])
        {

        }
        field(31; "Parent Code2"; Code[30])
        {
            TableRelation = Confidential.Code WHERE(Parent = FILTER(true));
        }
    }


    keys
    {
        key(PK; "Employee No.", "Confidential Code", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        Confidential: Record Confidential;
        Employee: Record Employee;
        EmployeePayrollGroup: Record "Employee Statistics Group";
        MonthDays: Decimal;
        CurrentMonth: Text;
        PreviousMonth: Text;
        CurrentMonthMidDate: Text;
        PreviousMonthMidDate: Text;
        CurrentDate: Date;
        PreviousDate: Date;
        Text000: Label 'You can not delete confidential information if there are comments associated with it.';
        ASLT00001: Label 'Are you sure you want to change Fixed Amount?';

    trigger OnInsert()
    begin
        "Date Created" := TODAY;
        "Created By" := USERID;
        "Last Modified By" := USERID;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := USERID;
        "Date Last Modified" := TODAY;
    end;

    trigger OnDelete()
    begin
        IF Comment THEN
            ERROR(Text000);
    end;

    trigger OnRename()
    begin

    end;

}
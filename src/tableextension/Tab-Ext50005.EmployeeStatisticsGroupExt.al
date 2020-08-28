tableextension 50005 "EmployeeStatisticsGroupExt" extends "Employee Statistics Group"
{
    fields
    {
        // Add changes to table fields here
        field(50005; Code2; Code[10])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF NOT GenProductPostingGroup.GET(Code) THEN BEGIN
                    GenProductPostingGroup.INIT;
                    GenProductPostingGroup.VALIDATE(Code, Code);
                    GenProductPostingGroup.Description := Code;
                    GenProductPostingGroup.INSERT(TRUE);
                END;

                IF NOT GenPostingSetup.GET('', Code) THEN BEGIN
                    GenPostingSetup.INIT;
                    GenPostingSetup."Gen. Bus. Posting Group" := '';
                    GenPostingSetup."Gen. Prod. Posting Group" := Code;
                    GenPostingSetup.INSERT(TRUE);
                END;

                UpdateResourceGroup;
            end;
        }
        field(50010; "Basic Pay Type"; Option)
        {
            OptionMembers = Fixed,"Resource Units";
        }
        field(50020; "Last Payroll Processing Date"; Date) { }
        field(50021; "Next Payroll Processing Date"; Date) { }
        field(50022; "Current Payroll Period Status"; Option)
        {
            OptionMembers = Open,Closed;
            Editable = false;
        }
        field(50023; "Auto Process Payroll"; Boolean) { }
        field(50024; "Payroll Processing Frequency"; Option)
        {
            OptionMembers = Monthly,Weekly,"Bi-Weekly";
            Editable = false;
        }
        field(50030; "Autopost Payroll Journal"; Boolean) { }
        field(50031; "Payroll Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(50032; "Payroll Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payroll Journal Template Name"));
        }
        field(50040; "Basic Salary Expence Acc. No."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50041; "Payments Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(50042; "Payments Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payments Journal Template Name"));
        }
        field(50043; "Salaries Payable Acc. Type"; Option)
        {
            OptionMembers = "G/L Account",Vendor;
        }
        field(50044; "Salaries Payable Acc. No."; Code[20])
        {
            TableRelation = IF ("Salaries Payable Acc. Type" = CONST("G/L Account")) "G/L Account"."No." ELSE
            IF ("Salaries Payable Acc. Type" = CONST(Vendor)) Vendor."No.";
        }
        field(50046; "Basic Pay Expense Posting Type"; Option)
        {
            OptionMembers = Individual,Block;
        }
        field(50047; "Tax Payable Posting Type"; Option)
        {
            OptionMembers = Individual,Block;
        }
        field(50048; "Net Pay Payable Posting Type"; Option)
        {
            OptionMembers = Individual,Block;
        }
        field(50049; "Advance Salary Deduction Code"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Deduction), "ED Type" = CONST(Advance));
        }
        field(50050; "Advance Salary G/L Account"; Code[10])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50051; "Employee Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50052; "Base Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure".Code;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF xRec."Base Unit of Measure" <> "Base Unit of Measure" THEN BEGIN
                    Employees.RESET;
                    Employees.SETRANGE("Statistics Group Code", Code);
                    IF NOT CONFIRM(ASLT001, FALSE) THEN
                        Employees.SETFILTER(Employees."Statistics Group Code", '');
                    IF Employees.FINDSET THEN BEGIN
                        REPEAT
                            Employees.UpdateEmployeeAsResource("Base Unit of Measure");
                            Employees.MODIFY;
                        UNTIL Employees.NEXT = 0;
                    END;
                END;
            end;
        }
        field(50060; "Loan Deduction Code"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Deduction), "ED Type" = CONST(Loan));
        }
        field(50065; "Loan G/L Account"; Code[10])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50066; "Interest Deduction Code"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Deduction), "ED Type" = CONST(Interest));
        }
        field(50067; "Loan Interest Income A/C"; Code[10])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50070; "Special Deduction Code"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST(Deduction));
        }
    }

    var
        myInt: Integer;
        Employees: Record Employee;

        SpecialDeductionCodes: array[20] of Code[10];
        ResourceGroup: Record "Resource Group";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        GenPostingSetup: Record "General Posting Setup";
        ASLT00001: Label 'You cannot modify the next Payroll Processing Date';
        ASLT001: label 'You have changed the Base Unit of Measure, Do you want to update all employees in this group?';

    //Table Triggers
    trigger OnInsert()
    var
        myInt: Integer;
    begin
        if Code <> '' then
            Code2 := Code;

        UpdateResourceGroup;
    end;

    trigger OnRename()
    var
        myInt: Integer;
    begin
        if ResourceGroup.GET(xRec.Code) then
            ResourceGroup.RENAME(Code)
        else
            UpdateResourceGroup;
    end;

    //-----------------------FUNCTIONS-------------------------------------
    //UpdateResourceGroup
    procedure UpdateResourceGroup()
    var
        myInt: Integer;
    begin
        IF Code <> '' THEN BEGIN
            IF NOT ResourceGroup.GET(Code) THEN BEGIN
                ResourceGroup.INIT;
                ResourceGroup."No." := Code;
                ResourceGroup.Name := COPYSTR(Description, 1, MAXSTRLEN(ResourceGroup.Name));
                ResourceGroup.INSERT;
            END ELSE BEGIN
                ResourceGroup.Name := COPYSTR(Description, 1, MAXSTRLEN(ResourceGroup.Name));
                ResourceGroup.MODIFY;
            END;
        END;
    end;

    //PreparePayroll
    procedure PreparePayroll()
    var
        myInt: Integer;
        Employee: Record Employee;
        Confidential: Record Confidential;
        EmployeeDeductions: Record "Earning And Dedcution";
        EmployeeDeductions1: Record "Earning And Dedcution";
        EmployeeDeductions2: Record "Earning And Dedcution";
        EmployeeDeductions3: Record "Earning And Dedcution";
        EmployeeDeductions4: Record "Earning And Dedcution";
        LoanHeader: Record "Sales Header";
        LoanLine: Record "Sales Line";
        AdvanceHeader: Record "Sales Header";
        AdvanceLine: Record "Sales Line";
        PayrollGroup: Record "Employee Statistics Group";
        Month: Integer;
        Year: Integer;
        Period: Code[10];
        LineNo: Integer;
        LineNo2: Integer;
        LineNo3: Integer;
        LineNo4: Integer;
        I: Integer;
        J: Integer;
    begin
        TESTFIELD("Loan Deduction Code");
        TESTFIELD("Loan G/L Account");
        TESTFIELD("Interest Deduction Code");
        TESTFIELD("Loan Interest Income A/C");
        TESTFIELD("Advance Salary G/L Account");
        TESTFIELD("Advance Salary Deduction Code");

        PayrollGroup.RESET;
        PayrollGroup.SETFILTER(PayrollGroup.Code, '<>%1', '');
        PayrollGroup.SETFILTER(PayrollGroup."Special Deduction Code", '<>%1', '');
        IF PayrollGroup.FINDFIRST THEN BEGIN
            I := 1;
            REPEAT
                SpecialDeductionCodes[I] := PayrollGroup."Special Deduction Code";
                I += 1;
            UNTIL PayrollGroup.NEXT = 0;
        END;

        Employee.RESET;
        Employee.SETFILTER("No.", '<>%1', '');
        Employee.SETFILTER(Employee."Statistics Group Code", Code);
        IF Employee.FINDFIRST THEN
            REPEAT
                Confidential.RESET;
                Confidential.SETFILTER("ED Type", '=%1 | =%2', Confidential."ED Type"::" ", Confidential."ED Type"::Overtime);
                Confidential.SETFILTER(Code, '<>%1 & <>%2 & <>%3 & <>%4 & <>%5 & <>%6 & <>%7 & <>%8 & <>%9 & <>%10',
                                      SpecialDeductionCodes[1], SpecialDeductionCodes[2], SpecialDeductionCodes[3], SpecialDeductionCodes[4],
                                      SpecialDeductionCodes[5], SpecialDeductionCodes[6], SpecialDeductionCodes[7], SpecialDeductionCodes[8],
                                      SpecialDeductionCodes[9], SpecialDeductionCodes[10]);
                IF Confidential.FINDFIRST THEN
                    REPEAT
                        LineNo += 1000;
                        EmployeeDeductions1.RESET;
                        EmployeeDeductions1.SETRANGE("Employee No.", Employee."No.");
                        EmployeeDeductions1.SETRANGE("Confidential Code", "Special Deduction Code");
                        IF NOT EmployeeDeductions1.FINDFIRST THEN BEGIN
                            IF Employee."Include in Special Deduction" THEN BEGIN
                                EmployeeDeductions1.INIT;
                                EmployeeDeductions1.VALIDATE("Employee No.", Employee."No.");
                                EmployeeDeductions1.VALIDATE("Confidential Code", "Special Deduction Code");
                                EmployeeDeductions1."Line No." := LineNo;
                                EmployeeDeductions1."System Created" := TRUE;
                                EmployeeDeductions1.INSERT(TRUE);
                            END;
                        END;

                        COMMIT;

                        EmployeeDeductions1.RESET;
                        EmployeeDeductions1.SETRANGE("Employee No.", Employee."No.");
                        EmployeeDeductions1.SETRANGE("Confidential Code", Confidential.Code);
                        IF NOT EmployeeDeductions1.FINDFIRST THEN BEGIN
                            // Code to apply recurring earning / deduction to one payroll group
                            IF (Confidential.Recurrence = Confidential.Recurrence::Always) AND (Confidential."Recurrence Payroll Group Code" <> '') THEN BEGIN
                                IF (Confidential."Recurrence Payroll Group Code" = Code) THEN BEGIN
                                    EmployeeDeductions1.INIT;
                                    EmployeeDeductions1.VALIDATE("Employee No.", Employee."No.");
                                    EmployeeDeductions1.VALIDATE("Confidential Code", Confidential.Code);
                                    EmployeeDeductions1."Line No." := LineNo;
                                    EmployeeDeductions1."System Created" := TRUE;
                                    EmployeeDeductions1.INSERT(TRUE);
                                END;
                            END ELSE
                                IF (Confidential.Recurrence = Confidential.Recurrence::Always) AND (Confidential."Recurrence Payroll Group Code" = '') THEN BEGIN
                                    EmployeeDeductions1.INIT;
                                    EmployeeDeductions1.VALIDATE("Employee No.", Employee."No.");
                                    EmployeeDeductions1.VALIDATE("Confidential Code", Confidential.Code);
                                    EmployeeDeductions1."Line No." := LineNo;
                                    EmployeeDeductions1."System Created" := TRUE;
                                    EmployeeDeductions1.INSERT(TRUE);
                                END ELSE
                                    IF ((Confidential.Recurrence = Confidential.Recurrence::Never) OR (Confidential.Recurrence = Confidential.Recurrence::"On Balance")) THEN BEGIN
                                        EmployeeDeductions1.INIT;
                                        EmployeeDeductions1.VALIDATE("Employee No.", Employee."No.");
                                        EmployeeDeductions1.VALIDATE("Confidential Code", Confidential.Code);
                                        EmployeeDeductions1."Line No." := LineNo;
                                        EmployeeDeductions1."System Created" := TRUE;
                                        EmployeeDeductions1.INSERT(TRUE);
                                    END;
                        END;
                        /*
                                                LoanHeader.RESET;
                                                LoanHeader.SETRANGE("Document Type", LoanHeader."Document Type"::Loan);
                                                LoanHeader.SETFILTER("No.", '<>%1', '');
                                                LoanHeader.SETRANGE(Posted, TRUE);
                                                LoanHeader.SETRANGE("Employee No.", Employee."No.");
                                                IF LoanHeader.FINDFIRST THEN BEGIN
                                                    IF ("Next Payroll Processing Date" <> 0D) THEN BEGIN
                                                        Month := DATE2DMY("Next Payroll Processing Date", 2);
                                                        Year := DATE2DMY("Next Payroll Processing Date", 3);
                                                        Period := FORMAT(Month) + '-' + FORMAT(Year);
                                                    END;
                                                    LoanLine.RESET;
                                                    LoanLine.SETRANGE("Document Type", LoanLine."Document Type"::Loan);
                                                    LoanLine.SETRANGE("Document No.", LoanHeader."No.");
                                                    LoanLine.SETRANGE(Posted, TRUE);
                                                    LoanLine.SETRANGE("Transfered To Payroll", FALSE);
                                                    LoanLine.SETRANGE(Period, Period);
                                                    IF LoanLine.FINDFIRST THEN BEGIN
                                                        EmployeeDeductions.RESET;
                                                        EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", Employee."No.");
                                                        EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", "Loan Deduction Code");
                                                        EmployeeDeductions.SETRANGE("Fixed Amount", LoanLine.Repayment);
                                                        EmployeeDeductions.SETRANGE("ED Type", EmployeeDeductions."ED Type"::Loan);
                                                        IF NOT EmployeeDeductions.FINDFIRST THEN BEGIN
                                                            LineNo += 1000;
                                                            EmployeeDeductions.INIT;
                                                            EmployeeDeductions.VALIDATE("Employee No.", Employee."No.");
                                                            EmployeeDeductions.VALIDATE("Confidential Code", "Loan Deduction Code");
                                                            EmployeeDeductions."Line No." := LineNo;
                                                            EmployeeDeductions.VALIDATE("Fixed Amount", LoanLine.Repayment);
                                                            EmployeeDeductions."System Created" := TRUE;
                                                            EmployeeDeductions.INSERT(TRUE);
                                                            IF (LoanLine.Interest <> 0) THEN BEGIN
                                                                EmployeeDeductions2.RESET;
                                                                EmployeeDeductions2.SETRANGE(EmployeeDeductions2."Employee No.", Employee."No.");
                                                                EmployeeDeductions2.SETRANGE(EmployeeDeductions2."Confidential Code", "Interest Deduction Code");
                                                                EmployeeDeductions2.SETFILTER("Line No.", '<>%1', 0);
                                                                IF EmployeeDeductions2.FINDLAST THEN
                                                                    LineNo := EmployeeDeductions2."Line No." + 1000;
                                                                EmployeeDeductions.INIT;
                                                                EmployeeDeductions.VALIDATE("Employee No.", Employee."No.");
                                                                EmployeeDeductions.VALIDATE("Confidential Code", "Interest Deduction Code");
                                                                EmployeeDeductions."Line No." := LineNo;
                                                                EmployeeDeductions.VALIDATE("Fixed Amount", LoanLine.Interest);
                                                                EmployeeDeductions."System Created" := TRUE;
                                                                EmployeeDeductions.INSERT(TRUE);
                                                                LineNo += 1000;
                                                            END;
                                                            LoanLine."Transfered To Payroll" := TRUE;
                                                            LoanLine.MODIFY;
                                                        END;
                                                    END
                                                END;
                                                
                        AdvanceHeader.RESET;
                        AdvanceHeader.SETRANGE("Document Type", AdvanceHeader."Document Type"::Advance);
                        AdvanceHeader.SETFILTER("No.", '<>%1', '');
                        AdvanceHeader.SETRANGE(Posted, TRUE);
                        AdvanceHeader.SETRANGE("Employee No.", Employee."No.");
                        if AdvanceHeader.FINDFIRST then begin
                            IF ("Next Payroll Processing Date" <> 0D) then begin
                                Month := DATE2DMY("Next Payroll Processing Date", 2);
                                Year := DATE2DMY("Next Payroll Processing Date", 3);
                                Period := FORMAT(Month) + '-' + FORMAT(Year);
                            end;
                            AdvanceLine.RESET;
                            AdvanceLine.SETRANGE("Document Type", AdvanceLine."Document Type"::Advance);
                            AdvanceLine.SETRANGE("Document No.", AdvanceHeader."No.");
                            AdvanceLine.SETRANGE(Posted, TRUE);
                            AdvanceLine.SETRANGE("Transfered To Payroll", FALSE);
                            AdvanceLine.SETRANGE(Period, Period);
                            IF AdvanceLine.FINDFIRST THEN BEGIN
                                EmployeeDeductions.RESET;
                                EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", Employee."No.");
                                EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", "Advance Salary Deduction Code");
                                EmployeeDeductions.SETRANGE("Fixed Amount", AdvanceLine.Repayment);
                                EmployeeDeductions.SETRANGE("ED Type", EmployeeDeductions."ED Type"::Advance);
                                IF NOT EmployeeDeductions.FINDFIRST THEN BEGIN
                                    //LineNo3 += 1000;
                                    EmployeeDeductions.INIT;
                                    EmployeeDeductions.VALIDATE("Employee No.", Employee."No.");
                                    EmployeeDeductions.VALIDATE("Confidential Code", "Advance Salary Deduction Code");
                                    EmployeeDeductions."Line No." := LineNo;
                                    EmployeeDeductions.VALIDATE("Fixed Amount", AdvanceLine.Repayment);
                                    EmployeeDeductions."System Created" := TRUE;
                                    EmployeeDeductions.INSERT(TRUE);
                                    AdvanceLine."Transfered To Payroll" := TRUE;
                                    AdvanceLine.MODIFY;
                                END;
                            END;
                        END;
                        */
                        COMMIT;
                    UNTIL Confidential.NEXT = 0;
            UNTIL Employee.NEXT = 0;
        UpdateZeroEDs;
    end;

    //UpdateZeroEDs()
    procedure UpdateZeroEDs()

    var
        myInt: Integer;
        Employee: Record Employee;
        Confidential: Record Confidential;
        EmployeeDeductions: Record "Earning And Dedcution";
        EmployeeDeductions1: Record "Earning And Dedcution";
        EmployeeDeductions2: Record "Earning And Dedcution";
        EmployeeDeductions3: Record "Earning And Dedcution";
        EmployeeDeductions4: Record "Earning And Dedcution";
        LoanHeader: Record "Sales Header";
        LoanLine: Record "Sales Line";
        AdvanceHeader: Record "Sales Header";
        AdvanceLine: Record "Sales Line";
        PayrollGroup: Record "Employee Statistics Group";
        Month: Integer;
        Year: Integer;
        Period: Code[10];
        LineNo: Integer;
        LineNo2: Integer;
        LineNo3: Integer;
        LineNo4: Integer;
    begin
        TESTFIELD("Loan Deduction Code");
        TESTFIELD("Loan G/L Account");
        TESTFIELD("Interest Deduction Code");
        TESTFIELD("Loan Interest Income A/C");
        TESTFIELD("Advance Salary G/L Account");
        TESTFIELD("Advance Salary Deduction Code");
        Employee.RESET;
        Employee.SETFILTER("No.", '<>%1', '');
        Employee.SETFILTER(Employee."Statistics Group Code", Code);
        IF Employee.FINDFIRST THEN
            REPEAT
                Confidential.RESET;
                Confidential.SETFILTER("ED Type", '=%1 | =%2 | =%3', Confidential."ED Type"::Advance, Confidential."ED Type"::Loan,
                                      Confidential."ED Type"::Interest);
                IF Confidential.FINDFIRST THEN
                    REPEAT
                        LineNo += 1000;
                        EmployeeDeductions1.RESET;
                        EmployeeDeductions1.SETRANGE("Employee No.", Employee."No.");
                        EmployeeDeductions1.SETRANGE("Confidential Code", Confidential.Code);
                        EmployeeDeductions1.SETFILTER("Fixed Amount", '>0');
                        //EmployeeDeductions1.SETFILTER("ED Type", '<>%1 & <>%2 & <>%2', EmployeeDeductions1."ED Type"::Loan, EmployeeDeductions1."ED Type"::Interest,
                        //                              EmployeeDeductions1."ED Type"::Advance);
                        IF NOT EmployeeDeductions1.FINDFIRST THEN BEGIN
                            //LineNo2 += 1000;
                            EmployeeDeductions1.INIT;
                            EmployeeDeductions1.VALIDATE("Employee No.", Employee."No.");
                            EmployeeDeductions1.VALIDATE("Confidential Code", Confidential.Code);
                            EmployeeDeductions1."Line No." := LineNo;
                            EmployeeDeductions1."System Created" := TRUE;
                            EmployeeDeductions1.INSERT(TRUE);
                        END;
                        COMMIT;
                    UNTIL Confidential.NEXT = 0;
            UNTIL Employee.NEXT = 0;
    end;

    //ResetPayroll
    procedure ResetPayroll()
    var
        myInt: Integer;
        Employee: Record Employee;
        Confidential: Record Confidential;
        EmployeeDeductions: Record "Earning And Dedcution";
        EmployeeDeductions1: Record "Earning And Dedcution";
        EmployeeDeductions2: Record "Earning And Dedcution";
        EmployeeDeductions3: Record "Earning And Dedcution";
        EmployeeDeductions4: Record "Earning And Dedcution";
        LoanHeader: Record "Sales Header";
        LoanLine: Record "Sales Line";
        AdvanceHeader: Record "Sales Header";
        AdvanceLine: Record "Sales Line";
        PayrollGroup: Record "Employee Statistics Group";
        Month: Integer;
        Year: Integer;
        Period: Code[10];
        LineNo: Integer;
        LineNo2: Integer;
        LineNo3: Integer;
        LineNo4: Integer;
    begin
        TESTFIELD("Loan Deduction Code");
        TESTFIELD("Loan G/L Account");
        TESTFIELD("Interest Deduction Code");
        TESTFIELD("Loan Interest Income A/C");
        TESTFIELD("Advance Salary G/L Account");
        TESTFIELD("Advance Salary Deduction Code");
        Employee.RESET;
        Employee.SETFILTER("No.", '<>%1', '');
        Employee.SETFILTER(Employee."Statistics Group Code", Code);
        IF Employee.FINDFIRST THEN
            REPEAT
                Confidential.RESET;
                Confidential.SETFILTER("ED Type", '=%1 | =%2 | =%3 | =%4 | =%5', Confidential."ED Type"::" ", Confidential."ED Type"::Loan,
                                       Confidential."ED Type"::Interest, Confidential."ED Type"::Advance, Confidential."ED Type"::Overtime);
                Confidential.SETRANGE(Type, Confidential.Type::Earning, Confidential.Type::Deduction);
                IF Confidential.FINDFIRST THEN
                    REPEAT
                        LineNo2 += 1000;
                        EmployeeDeductions1.RESET;
                        EmployeeDeductions1.SETRANGE("Employee No.", Employee."No.");
                        EmployeeDeductions1.SETRANGE("Confidential Code", Confidential.Code);
                        //EmployeeDeductions1.SETFILTER("ED Type", '<>%1 & <>%2 & <>%3', EmployeeDeductions1."ED Type"::Loan, EmployeeDeductions1."ED Type"::Interest,
                        //                               EmployeeDeductions1."ED Type"::Advance );
                        EmployeeDeductions1.SetRange("Fixed Amount", 0);
                        EmployeeDeductions1.SetRange(EmployeeDeductions1."Has Employer Component", FALSE);
                        EmployeeDeductions1.SetRange(EmployeeDeductions1."Employer Fixed Amount", 0);
                        EmployeeDeductions1.SetRange(EmployeeDeductions1."Opening Balance", 0);
                        EmployeeDeductions1.SetRange(EmployeeDeductions1."Current Balance", 0);
                        EmployeeDeductions1.SetRange(EmployeeDeductions1.Percentage, 0);
                        EmployeeDeductions1.SetRange(EmployeeDeductions1."Employer Percentage", 0);
                        if EmployeeDeductions1.FindSet then
                            EmployeeDeductions1.DeleteAll;
                    until Confidential.NEXT = 0;
            until Employee.NEXT = 0;
    end;
}
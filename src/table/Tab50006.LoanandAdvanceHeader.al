table 50006 "Loan and Advance Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,Loan,Advance;
        }
        field(3; "No."; Code[20]) { }
        field(20; "Posting Date"; Date) { }
        field(22; "Posting Description"; Text[50]) { }
        field(23; "External Document No."; Code[35])
        {

        }
        field(107; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50040; "Suspension Duration"; Integer) { }
        field(50200; "Bank Name"; Text[50]) { }
        field(50210; "Received By"; Code[50])
        {
            TableRelation = "User Setup";

        }
        field(50220; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan and Advance Lines"."Fee Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(50230; "Received To"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                BankAccount: Record "Bank Account";
            begin
                IF BankAccount.GET("Received To") THEN
                    "Bank Name" := BankAccount.Name;
            end;
        }
        field(50240; "Receipt Posted"; Boolean) { }
        field(33; "Currency Factor"; Decimal) { }
        field(50250; "Receipt Date"; Date) { }
        field(50260; "Printed Receipt Copies"; Integer) { }
        field(50270; "Pay From"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50280; Reference; Code[35]) { }
        field(50285; "Being Payment For"; Text[250]) { }
        field(50300; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF EmployeeRec.GET("Employee No.") THEN BEGIN
                    HumanResourceCommentLine.RESET;
                    HumanResourceCommentLine.SETRANGE(HumanResourceCommentLine."No.", "Employee No.");
                    HumanResourceCommentLine.SETRANGE(HumanResourceCommentLine."Loan Status", HumanResourceCommentLine."Loan Status"::Active);
                    IF HumanResourceCommentLine.FINDFIRST THEN BEGIN
                        ERROR('You have a Loan you can not request for a loan or an advance');
                    END ELSE BEGIN
                        "Basic Salary" := EmployeeRec."Basic Salary (LCY)";
                        IF (Currency = '') THEN
                            VALIDATE(Currency, EmployeeRec."Currency Code");
                    END;
                END;
            end;
        }
        field(50301; "Employee Name"; Text[250])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Min (Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
        }
        field(50302; "Interest Rate"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF (Principal <> 0) AND (Installments <> 0) THEN BEGIN
                    IF ("Loan Type" = "Loan Type"::Reducing) THEN
                        CreateLoanLinesReducingBalance
                    ELSE
                        IF ("Loan Type" = "Loan Type"::Linear) THEN
                            CreateLoanLinesLinear;
                END;
            end;
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(false));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(false));
        }

        field(40; "Sell-to Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(50303; Principal; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
                CurrencyDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                IF Principal > ("Basic Salary" / 2) THEN
                    ERROR('You are only allowed to request upto a half of your basic salary');
                // Update currency factor

                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                IF Currency = '' THEN
                    "Principal (LCY)" := Principal
                ELSE
                    "Principal (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          Principal, "Currency Factor"));

                // Update currency factor
                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                /*{
                IF Currency = '' THEN
                                    "Total Interest (LCY)" := "Total Interest"
                                ELSE
                                    "Total Interest (LCY)" := ROUND(
                                        CurrExchRate.ExchangeAmtFCYToLCY(
                                          "Creation Date", Currency,
                                          "Total Interest", "Currency Factor"));
                }
                */
                IF Currency = '' THEN
                    "Installment Amount (LCY)" := "Installment Amount"
                ELSE
                    "Installment Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          "Installment Amount", "Currency Factor"));


                IF (Principal <> 0) AND (Installments <> 0) THEN BEGIN
                    VALIDATE("Installment Amount", Principal / Installments);
                    IF ("Loan Type" = "Loan Type"::Reducing) THEN
                        CreateLoanLinesReducingBalance
                    ELSE
                        IF ("Loan Type" = "Loan Type"::Linear) THEN
                            CreateLoanLinesLinear;
                END;

            end;
        }
        field(50304; "Principal (LCY)"; Decimal)
        {
            Editable = false;

        }
        field(50305; "Creation Date"; Date)
        {
            trigger OnValidate()
            var
                CurrencyDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                IF Currency = '' THEN
                    "Principal (LCY)" := Principal
                ELSE
                    "Principal (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          Principal, "Currency Factor"));

                // Update currency factor
                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                /*{
                IF Currency = '' THEN
                                    "Total Interest (LCY)" := "Total Interest"
                                ELSE
                                    "Total Interest (LCY)" := ROUND(
                                        CurrExchRate.ExchangeAmtFCYToLCY(
                                          "Creation Date", Currency,
                                          "Total Interest", "Currency Factor"));
                }*/

                IF Currency = '' THEN
                    "Installment Amount (LCY)" := "Installment Amount"
                ELSE
                    "Installment Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          "Installment Amount", "Currency Factor"));

                IF (Principal <> 0) AND (Installments <> 0) THEN BEGIN
                    VALIDATE("Installment Amount", Principal / Installments);
                    IF ("Loan Type" = "Loan Type"::Reducing) THEN
                        CreateLoanLinesReducingBalance
                    ELSE
                        IF ("Loan Type" = "Loan Type"::Linear) THEN
                            CreateLoanLinesLinear;
                END;

            end;
        }
        field(50307; "Start Period Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF ("Start Period Date" <> 0D) THEN BEGIN
                    StartPeriodMonth := DATE2DMY("Start Period Date", 2);
                    StartPeriodYear := DATE2DMY("Start Period Date", 3);
                    VALIDATE("Start Period", (FORMAT(StartPeriodMonth) + '-' + FORMAT(StartPeriodYear)));
                END;
            end;
        }
        field(50308; "Start Period"; Code[10])
        {
            Editable = false;
            trigger OnValidate()
            var
                myInt: Integer;
                CurrencyDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                IF (Principal <> 0) AND (Installments <> 0) THEN BEGIN
                    IF ("Loan Type" = "Loan Type"::Reducing) THEN
                        CreateLoanLinesReducingBalance
                    ELSE
                        IF ("Loan Type" = "Loan Type"::Linear) THEN
                            CreateLoanLinesLinear;
                    ;
                END;
            end;
        }
        field(50309; Installments; Integer)
        {
            trigger OnValidate()
            var
                myInt: Integer;
                CurrencyDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                IF Currency = '' THEN
                    "Installment Amount (LCY)" := "Installment Amount"
                ELSE
                    "Installment Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          "Installment Amount", "Currency Factor"));

                IF (Principal <> 0) AND (Installments <> 0) THEN BEGIN
                    VALIDATE("Installment Amount", Principal / Installments);
                    IF ("Loan Type" = "Loan Type"::Reducing) THEN
                        CreateLoanLinesReducingBalance
                    ELSE
                        IF ("Loan Type" = "Loan Type"::Linear) THEN
                            CreateLoanLinesLinear;
                END;
            end;
        }
        field(50310; "Installment Amount"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            var
                myInt: Integer;
                CurrencyDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                // Update currency factor
                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                IF Currency = '' THEN
                    "Installment Amount (LCY)" := "Installment Amount"
                ELSE
                    "Installment Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          "Installment Amount", "Currency Factor"));
            end;
        }
        field(50311; "Installment Amount (LCY)"; Decimal)
        {
            Editable = false;
        }
        field(50315; "Issuing Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
            trigger OnValidate()
            var
                myInt: Integer;
                CurrencyDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                IF Bank.GET("Issuing Bank Account") THEN
                    IF (Currency = '') THEN
                        VALIDATE(Currency, Bank."Currency Code");

                // Update currency factor
                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                IF Currency = '' THEN
                    "Principal (LCY)" := Principal
                ELSE
                    "Principal (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          Principal, "Currency Factor"));

                // Update currency factor
                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                /*{
                IF Currency = '' THEN
                                    "Total Interest (LCY)" := "Total Interest"
                                ELSE
                                    "Total Interest (LCY)" := ROUND(
                                        CurrExchRate.ExchangeAmtFCYToLCY(
                                          "Creation Date", Currency,
                                          "Total Interest", "Currency Factor"));
                }
                */
                IF Currency = '' THEN
                    "Installment Amount (LCY)" := "Installment Amount"
                ELSE
                    "Installment Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          "Installment Amount", "Currency Factor"));

            end;
        }
        field(50316; "Paid To Employee"; Boolean)
        {
            Editable = false;
        }
        field(50317; "Repaid Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan and Advance Lines".Repayment WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Loan Cleared" = CONST(true)));
        }
        field(50318; "Remaining Loan / Advance Debt"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan and Advance Lines".Repayment WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Loan Cleared" = CONST(false)));
        }
        field(50319; "Repaid Advance Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan and Advance Lines".Repayment WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Advance Cleared" = CONST(false)));
        }
        field(50320; "Total Interest"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan and Advance Lines".Interest WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
            trigger OnValidate()
            var
                myInt: Integer;
                CurrencyDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                // Update currency factor
                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                /*{
                IF Currency = '' THEN
                                    "Total Interest (LCY)" := "Total Interest"
                                ELSE
                                    "Total Interest (LCY)" := ROUND(
                                        CurrExchRate.ExchangeAmtFCYToLCY(
                                          "Creation Date", Currency,
                                          "Total Interest", "Currency Factor"));
                }*/
                IF Currency = '' THEN
                    "Installment Amount (LCY)" := "Installment Amount"
                ELSE
                    "Installment Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Creation Date", Currency,
                          "Installment Amount", "Currency Factor"));

            end;
        }
        field(50321; "Total Interest (LCY)"; Decimal)
        {
            Editable = false;
        }
        field(50322; "Remaining Interest Debt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan and Advance Lines".Interest WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Interest Cleared" = CONST(false)));
        }
        field(50330; "Interest Paid"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan and Advance Lines".Interest WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Interest Cleared" = CONST(true)));
            trigger OnValidate()
            var
                myInt: Integer;
                CurrencyDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                // Update currency factor
                IF Currency <> '' THEN BEGIN
                    IF "Creation Date" <> 0D THEN
                        CurrencyDate := "Creation Date"
                    ELSE
                        CurrencyDate := WORKDATE;

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, Currency);
                END ELSE
                    "Currency Factor" := 0;
                // Update currency factor

                /*{
                IF Currency = '' THEN
                                    "Interest Paid (LCY)" := "Interest Paid"
                                ELSE
                                    "Interest Paid (LCY)" := ROUND(
                                        CurrExchRate.ExchangeAmtFCYToLCY(
                                          "Creation Date", Currency,
                                          "Interest Paid", "Currency Factor"));
                }*/
            end;
        }
        field(50331; "Interest Paid (LCY)"; Decimal)
        {
            Editable = false;
        }
        field(50340; "Last Suspension Date"; Decimal) { }
        field(50341; "Last Suspension Duration"; Integer) { }
        field(50342; Posted; Boolean)
        {
            Editable = false;
        }
        field(50350; Currency; Code[10])
        {
            Editable = false;
            TableRelation = Currency.Code;
        }
        field(50500; "Loan Type"; Option)
        {
            OptionMembers = Linear,Reducing;
        }
        field(50700; "Booking Receipts"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Bank Account Ledger Entry".Amount WHERE("Booking No." = FIELD("No.")));
        }
        field(50701; "Booking Collections Amount"; Decimal)
        {
            //FieldClass = FlowField;
            //CalcFormula = Sum ("Sales Invoice Line"."Amount Including VAT" WHERE("Sell-to Customer No."=FIELD("Sell-to Customer No."),"Booking No."=FIELD("No.")));
        }
        field(50705; "Booking Collections Quantity"; Decimal)
        {
            //FieldClass = FlowField;
            //CalcFormula = Sum ("Sales Shipment Line".Quantity WHERE("Booking No."=FIELD("No."),"Sell-to Customer No."=FIELD("Sell-to Customer No.")));
        }
        field(50800; "Booking No."; Code[20])
        {
            //TableRelation = "Sales Header".No. WHERE ("Document Type"=FILTER(Quote),"Sell-to Customer No."=FIELD("Sell-to Customer No."));
        }
        field(50900; Transferred; Boolean) { }
        field(50940; "Allowed For Posting"; Boolean) { }
        field(50960; "Paid To / By"; Text[30]) { }
        field(51000; "Receipt Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan and Advance Lines"."Receipt Line Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(51060; "Journal Template Name"; Code[10]) { }
        field(51070; "Journal Batch Name"; Code[10]) { }
        field(51080; "Applied Invoices"; Code[250]) { }
        field(55000; "Dimension Set ID"; Integer) { }
        field(55001; "Created By"; Code[100]) { }
        field(55002; "Basic Salary"; Decimal) { }
        field(55003; "Truck No."; Code[30]) { }
        field(55004; "Serial No."; Code[30]) { }
        field(55005; "User ID"; Code[50])
        {
            TableRelation = "User Setup";

        }
    }

    keys
    {
        key(PK; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    var
        I: Decimal;
        J: Integer;
        P: Decimal;
        R: Decimal;
        T: Decimal;
        Amount: Integer;
        StartPeriodMonth: Integer;
        StartPeriodYear: Integer;
        MonthPeriod: Integer;
        YearPeriod: Integer;
        EmployeePayrollGroup: Record "Employee Statistics Group";
        GenJnlBatch: Record "Gen. Journal Batch";
        SalesLine2: Record "Loan and Advance Lines";
        EmployeeDeductions: Record "Earning And Dedcution";
        EmployeeRec: Record Employee;
        Bank: Record "Bank Account";
        HRSetup: Record "Human Resources Setup";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        HumanResourceCommentLine: Record "Employee Comment Line";
        CratesNumber: Decimal;
        UnitOfMeasure: Code[30];
        SalesLinesLocation: Code[30];
        ItemNumber: Code[30];
        SalesLine1: Record "Loan and Advance Lines";
        LineNumber: Integer;
        SalesLineNumber: Integer;
        SelectNoSeriesAllowed: Boolean;
        InsertMode: Boolean;
        ASLT0001: label 'Installments should be greater than zero';
        ASLT0002: label 'Start Period End Date should have a value';
        ASLT0003: label 'Employee %1 does not exist';
        ASLT0004: label 'Issuing Bank Account should have a value for the Loan document %1';
        ASLT0005: label 'Employee No. cannot be empty in the loan document %1';
        ASLT0006: label 'Employee Payroll Group %1 does not exist for Employee %2';
        ASLT0007: label 'Please ensure that the loan is posted first before transfering the lines to payroll';
        ASLT0008: label 'Loan deduction already exists';
        ASLT0009: label 'Suspension Duration should be equal to or greater than 1';
        ASLT0010: label 'Issuing Bank Account should have for the Advance document %1';
        ASLT0011: label 'Employee No. cannot be empty in the Advance document %1';
        ASLT0012: label 'Please ensure that the advance is posted first before transfering the lines to payroll';
        ASLT0013: label 'The Advance %1 already exists in the approval workflow';
        ASLT0014: label 'The Loan %1 already exists in the approval workflow';
        ASLT0015: label 'External Document No. cannot be empty in the loan document %1';
        ASLT0016: label 'External Document No. cannot be empty in the advance document %1';
        ASLT0017: label 'You are not allowed to delete a booking / quote';
        ASLT0018: label 'The Loan does not exist in a journal. First send it for approval before posting';
        ASLT0019: label 'The Loan and its Interest are not yet fully approved';
        ASLT0020: label 'The Advance does not exist in a journal. First send it for approval before posting';
        ASLT0021: label 'User Setup does not exist for %1';
        ASLT0022: label 'You cannot delete a booking with Posted Entries';
        Text051: Label 'This %1 already Exits';



    trigger OnInsert()
    var
        Employee: Record Employee;
    begin
        InitInsert;
        InsertMode := TRUE;

        //employee number.
        IF ("Document Type" = "Document Type"::Loan) OR ("Document Type" = "Document Type"::Advance) THEN BEGIN
            Employee.RESET;
            Employee.SETRANGE(Employee."User ID", USERID);
            IF Employee.FINDFIRST THEN
                VALIDATE("Employee No.", Employee."No.")
            ELSE
                ERROR('Please Assigned a user to an employee. Contact Your systems Administrator');
        END;

        "Created By" := USERID;
    end;

    procedure InitInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        END;
        InitRecord;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        SalesLine: Record "Loan and Advance Lines";
    begin
        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE("Document No.", "No.");
        SalesLine.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

    //--------------------------------------------------------
    procedure InitRecord()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.GET;
        HRSetup.GET;
    end;

    procedure SetAllowSelectNoSeries()
    var
        myInt: Integer;
    begin
        SelectNoSeriesAllowed := TRUE;
    end;

    local procedure TestNoSeries()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.GET;
        HRSetup.GET;

        CASE "Document Type" OF
            "Document Type"::Quote:
                SalesSetup.TESTFIELD("Quote Nos.");
            "Document Type"::Order:
                SalesSetup.TESTFIELD("Order Nos.");
            "Document Type"::Invoice:
                BEGIN
                    SalesSetup.TESTFIELD("Invoice Nos.");
                    SalesSetup.TESTFIELD("Posted Invoice Nos.");
                END;
            "Document Type"::"Return Order":
                SalesSetup.TESTFIELD("Return Order Nos.");
            "Document Type"::"Credit Memo":
                BEGIN
                    SalesSetup.TESTFIELD("Credit Memo Nos.");
                    SalesSetup.TESTFIELD("Posted Credit Memo Nos.");
                END;
            "Document Type"::"Blanket Order":
                SalesSetup.TESTFIELD("Blanket Order Nos.");
            //ERROR(ASLT0021,USERID);
            "Document Type"::Loan:
                HRSetup.TESTFIELD("Loan Nos.");
            "Document Type"::Advance:
                HRSetup.TESTFIELD("Advance Nos.");
        // V1.0.0
        END;
    end;

    local procedure GetNoSeriesCode(): Code[20]
    var
        NoSeriesCode: Code[20];
        UserSetup: Record "User Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        CASE "Document Type" OF
            "Document Type"::Quote:
                NoSeriesCode := SalesSetup."Quote Nos.";
            "Document Type"::Order:
                NoSeriesCode := SalesSetup."Order Nos.";
            "Document Type"::Invoice:
                NoSeriesCode := SalesSetup."Invoice Nos.";
            "Document Type"::"Return Order":
                NoSeriesCode := SalesSetup."Return Order Nos.";
            "Document Type"::"Credit Memo":
                NoSeriesCode := SalesSetup."Credit Memo Nos.";
            "Document Type"::"Blanket Order":
                NoSeriesCode := SalesSetup."Blanket Order Nos.";

            "Document Type"::Loan:
                EXIT(HRSetup."Loan Nos.");
            "Document Type"::Advance:
                EXIT(HRSetup."Advance Nos.");
        // V1.0.0
        END;
        EXIT(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, SelectNoSeriesAllowed, "No. Series"));
    end;

    procedure AssistEdit(OldLoanHeader: Record "Loan and Advance Header"): Boolean
    var
        HRSetup: Record "Human Resources Setup";
        LoanHeader: Record "Loan and Advance Header";
        LoanHeader1: Record "Loan and Advance Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        WITH LoanHeader DO BEGIN
            COPY(Rec);
            LoanHeader.GET;
            TestNoSeries;
            IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldLoanHeader."No. Series", "No. Series") THEN BEGIN

                NoSeriesMgt.SetSeries("No.");
                IF LoanHeader1.GET("Document Type", "No.") THEN
                    ERROR(Text051, LOWERCASE(FORMAT("Document Type")), "No.");
                Rec := LoanHeader;
                EXIT(TRUE);
            END;
        END;
        /*
        with LoanHeader do begin
            LoanHeader := rec;
            HRSetup.Get;
            HRSetup.TestField("Loan Nos.");
            if NoSeriesMgt.SelectSeries(HRSetup."Loan Nos.", OldLoanHeader."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                Rec := LoanHeader;
                exit(true);
            end;
        end;*/
    end;

    procedure AssistEditAdvance(OldAdvanceHeader: Record "Loan and Advance Header"): Boolean
    var
        HRSetup: Record "Human Resources Setup";
        AdvanceHeader: Record "Loan and Advance Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        with AdvanceHeader do begin
            AdvanceHeader := rec;
            HRSetup.Get;
            HRSetup.TestField("Loan Nos.");
            if NoSeriesMgt.SelectSeries(HRSetup."Advance Nos.", OldAdvanceHeader."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                Rec := AdvanceHeader;
                exit(true);
            end;
        end;
    end;

    procedure CreateReceiptLines(PreassignedDoc: Code[20])
    var
        RemainingAmountToApply: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ReceiptLines: Record "Loan and Advance Lines";
        LineNo: Integer;
        ContinueGeneration: Boolean;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        InvoiceDocNo: Code[20];
    begin
        ReceiptLines.RESET;
        ReceiptLines.SETRANGE("Document Type", "Document Type");
        ReceiptLines.SETRANGE("Document No.", "No.");
        IF ReceiptLines.FINDSET THEN
            ReceiptLines.DELETEALL;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Sell-to Customer No.", "Sell-to Customer No.");
        CustLedgerEntry.SETFILTER(CustLedgerEntry.Amount, '>0');
        CustLedgerEntry.SETFILTER(CustLedgerEntry."Remaining Amount", '<>0');
        SalesInvoiceHeader.RESET;
        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Order No.", PreassignedDoc);
        IF SalesInvoiceHeader.FINDFIRST THEN
            CustLedgerEntry.SETRANGE(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
        IF CustLedgerEntry.FINDSET THEN BEGIN
            SalesInvoiceLine.RESET;
            SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
            IF SalesInvoiceLine.FINDFIRST THEN
                REPEAT
                    LineNo += 10000;
                    CLEAR(ReceiptLines);
                    ReceiptLines.INIT;
                    ReceiptLines."Document Type" := "Document Type";
                    ReceiptLines.VALIDATE("Document No.", "No.");
                    ReceiptLines.VALIDATE("Line No.", LineNo);
                    ReceiptLines."Sell-to Customer No." := "Sell-to Customer No.";
                    ReceiptLines."Fee Amount" := SalesInvoiceLine."Line Amount";
                    ReceiptLines.Description := SalesInvoiceLine.Description;
                    ReceiptLines."Ledger Entry No." := CustLedgerEntry."Entry No.";
                    ReceiptLines."Shortcut Dimension 1 Code" := SalesInvoiceLine."Shortcut Dimension 1 Code";
                    ReceiptLines."Shortcut Dimension 2 Code" := SalesInvoiceLine."Shortcut Dimension 2 Code";
                    ReceiptLines.INSERT;
                UNTIL (SalesInvoiceLine.NEXT = 0);
        END;
    end;


    //------------------------------------------------------
    procedure PostReceipt(Print: Boolean)
    var
        myInt: Integer;
    begin

    end;

    //-----------------------------------------------------
    procedure CreateLoanLinesReducingBalance()
    var
        RemainingAmountToApply: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ReceiptLines: Record "Loan and Advance Lines";
        LineNo: Integer;
        ContinueGeneration: Boolean;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InvoiceDocNo: Code[20];
        Position: Integer;
    begin
        TESTFIELD(Posted, FALSE);
        IF (Installments <= 0) THEN
            ERROR(ASLT0001);
        IF ("Start Period Date" = 0D) THEN
            ERROR(ASLT0002);
        J := Installments;

        IF (Currency <> '') THEN BEGIN
            P := "Principal (LCY)";
        END ELSE BEGIN
            P := Principal;
        END;

        P := Principal;

        Position := STRPOS("Start Period", '-');
        IF (Position = 2) THEN BEGIN
            EVALUATE(MonthPeriod, COPYSTR("Start Period", 1, 1));
            EVALUATE(YearPeriod, COPYSTR("Start Period", 3, MAXSTRLEN("Start Period")));
        END ELSE
            IF (Position = 3) THEN BEGIN
                EVALUATE(MonthPeriod, COPYSTR("Start Period", 1, 2));
                EVALUATE(YearPeriod, COPYSTR("Start Period", 4, MAXSTRLEN("Start Period")));
            END;
        ReceiptLines.RESET;
        ReceiptLines.SETRANGE("Document Type", "Document Type");
        ReceiptLines.SETRANGE("Document No.", "No.");
        IF ReceiptLines.FINDSET THEN
            ReceiptLines.DELETEALL;
        REPEAT
            IF (MonthPeriod > 12) THEN BEGIN
                MonthPeriod := 1;
                YearPeriod := YearPeriod + 1;
            END;
            LineNo += 10000;
            CLEAR(ReceiptLines);
            ReceiptLines.INIT;
            ReceiptLines."Document Type" := "Document Type";
            ReceiptLines.VALIDATE("Document No.", "No.");
            ReceiptLines.VALIDATE("Line No.", LineNo);
            ReceiptLines.Created := "Creation Date";
            ReceiptLines."Employee No." := "Employee No.";
            IF ("Installment Amount (LCY)" <> 0) THEN BEGIN
                ReceiptLines."Remaining Debt" := P - "Installment Amount (LCY)";
                ReceiptLines.Repayment := "Installment Amount (LCY)";
            END ELSE BEGIN
                ReceiptLines."Remaining Debt" := P - "Installment Amount";
                ReceiptLines.Repayment := "Installment Amount";
            END;

            ReceiptLines.Period := FORMAT(MonthPeriod) + '-' + FORMAT(YearPeriod);
            ReceiptLines.Interest := (P / Installments) * ("Interest Rate" / 100) * (Installments / 12);
            ReceiptLines.INSERT;
            J -= 1;
            IF ("Installment Amount (LCY)" <> 0) THEN
                P -= "Installment Amount (LCY)"
            ELSE
                P -= "Installment Amount";
            MonthPeriod += 1;
        UNTIL (J = 0);

    end;

    //----------------------------------------------------------
    procedure CreateLoanLinesLinear()
    var
        RemainingAmountToApply: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ReceiptLines: Record "Loan and Advance Lines";
        LineNo: Integer;
        ContinueGeneration: Boolean;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InvoiceDocNo: Code[20];
        Position: Integer;
        P1: Decimal;
    begin
        TESTFIELD(Posted, FALSE);
        IF (Installments <= 0) THEN
            ERROR(ASLT0001);
        IF ("Start Period Date" = 0D) THEN
            ERROR(ASLT0002);
        J := Installments;
        IF (Currency <> '') THEN BEGIN
            P := "Principal (LCY)";
            P1 := "Principal (LCY)";
        END ELSE BEGIN
            P := Principal;
            P1 := Principal;
        END;

        Position := STRPOS("Start Period", '-');
        IF (Position = 2) THEN BEGIN
            EVALUATE(MonthPeriod, COPYSTR("Start Period", 1, 1));
            EVALUATE(YearPeriod, COPYSTR("Start Period", 3, MAXSTRLEN("Start Period")));
        END ELSE
            IF (Position = 3) THEN BEGIN
                EVALUATE(MonthPeriod, COPYSTR("Start Period", 1, 2));
                EVALUATE(YearPeriod, COPYSTR("Start Period", 4, MAXSTRLEN("Start Period")));
            END;
        ReceiptLines.RESET;
        ReceiptLines.SETRANGE("Document Type", "Document Type");
        ReceiptLines.SETRANGE("Document No.", "No.");
        IF ReceiptLines.FINDSET THEN
            ReceiptLines.DELETEALL;
        REPEAT
            IF (MonthPeriod > 12) THEN BEGIN
                MonthPeriod := 1;
                YearPeriod := YearPeriod + 1;
            END;
            LineNo += 10000;
            CLEAR(ReceiptLines);
            ReceiptLines.INIT;
            ReceiptLines."Document Type" := "Document Type";
            ReceiptLines.VALIDATE("Document No.", "No.");
            ReceiptLines.VALIDATE("Line No.", LineNo);
            ReceiptLines.Created := "Creation Date";
            ReceiptLines."Employee No." := "Employee No.";
            IF ("Installment Amount (LCY)" <> 0) THEN BEGIN
                ReceiptLines."Remaining Debt" := P1 - "Installment Amount (LCY)";
                ReceiptLines.Repayment := "Installment Amount (LCY)";
            END ELSE BEGIN
                ReceiptLines."Remaining Debt" := P1 - "Installment Amount";
                ReceiptLines.Repayment := "Installment Amount";
            END;

            ReceiptLines.Period := FORMAT(MonthPeriod) + '-' + FORMAT(YearPeriod);
            ReceiptLines.Interest := (P * ("Interest Rate" / 100)) / (Installments);
            ReceiptLines.INSERT;
            J -= 1;
            IF ("Installment Amount (LCY)" <> 0) THEN
                P1 -= "Installment Amount (LCY)"
            ELSE
                P1 -= "Installment Amount";
            MonthPeriod += 1;
        UNTIL (J = 0);
    end;


    //---------------------------------------------------------------------------
    procedure PostLoanDiscarded()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        Employee: Record Employee;
        EmployeeDimension: Record "Employee Comment Line";
        PostJnLBatch: Codeunit "Gen. Jnl.-Post Batch";
        Deductions: Record Confidential;
        SalesLine2: Record "Loan and Advance Lines";
        LineNo: Integer;
        ShortcutDim1: Code[20];
        ShortcutDim2: Code[20];
        ShortcutDim3: Code[20];
        ShortcutDim4: Code[20];
        ShortcutDim5: Code[20];
        ShortcutDim6: Code[20];
        ShortcutDim7: Code[20];
        ShortcutDim8: Code[20];
    begin
        TESTFIELD("Document Type", "Document Type"::Loan);
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'LOAN');
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
        IF NOT GenJournalLine.FINDFIRST THEN
            ERROR(ASLT0018);
        HRSetup.GET;
        IF Posted THEN
            EXIT;
        IF "Issuing Bank Account" = '' THEN
            ERROR(ASLT0004, "No.");

        IF "Employee No." = '' THEN
            ERROR(ASLT0005, "No.");

        IF NOT Employee.GET("Employee No.") THEN
            ERROR(ASLT0003, "Employee No.");

        IF NOT EmployeePayrollGroup.GET(Employee."Statistics Group Code") THEN
            ERROR(ASLT0006, Employee."Statistics Group Code", Employee."No.");

        EmployeePayrollGroup.TESTFIELD("Loan G/L Account");
        EmployeePayrollGroup.TESTFIELD("Loan Deduction Code");

        /*{
        GenJournalLine.RESET;
                GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
                GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'LOAN');
                GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
                IF GenJournalLine.FINDFIRST THEN BEGIN
                    GenJournalLine.TransferJournalToVoucher(GenJournalLine);
                    COMMIT;
                    PostJnLBatch.RUN(GenJournalLine);
                END;
        }*/

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'INTEREST');
        GenJournalLine.SETRANGE(GenJournalLine."Loan No.", "No.");
        IF GenJournalLine.FINDFIRST THEN
            PostJnLBatch.RUN(GenJournalLine);

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'LOAN');
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
        IF NOT GenJournalLine.FINDFIRST THEN BEGIN
            GenJournalLine2.RESET;
            GenJournalLine2.SETRANGE(GenJournalLine2."Journal Template Name", 'GENERAL');
            GenJournalLine2.SETRANGE(GenJournalLine2."Journal Batch Name", 'INTEREST');
            GenJournalLine2.SETRANGE(GenJournalLine2."Loan No.", "No.");
            IF NOT GenJournalLine2.FINDFIRST THEN BEGIN
                SalesLine2.RESET;
                SalesLine2.SETRANGE("Document Type", "Document Type");
                SalesLine2.SETRANGE("Document No.", "No.");
                SalesLine2.SETRANGE(Posted, FALSE);
                SalesLine2.SETRANGE("Transfered To Payroll", FALSE);
                IF SalesLine2.FINDFIRST THEN
                    REPEAT
                        SalesLine2.Posted := TRUE;
                        SalesLine2.MODIFY;
                    UNTIL SalesLine2.NEXT = 0;
                Posted := TRUE;
                "Paid To Employee" := TRUE;
                MODIFY;
            END ELSE
                ERROR(ASLT0019);
        END;

    end;

    //--------------------------------------------------------------------
    procedure TransferLoanToPayroll()
    var
        myInt: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        Employee: Record Employee;
        EmployeeDimension: Record "Employee Comment Line";
        PostJnLBatch: Codeunit "Gen. Jnl.-Post Batch";
        Deductions: Record Confidential;
        SalesLine2: Record "Loan and Advance Lines";
        LineNo: Integer;
        Period: Code[10];
        Month: Integer;
        Year: Integer;
        Pos: Integer;
    begin
        IF "Issuing Bank Account" = '' THEN
            ERROR(ASLT0004, "No.");

        IF "Employee No." = '' THEN
            ERROR(ASLT0005, "No.");

        IF NOT Employee.GET("Employee No.") THEN
            ERROR(ASLT0003, "Employee No.");

        Employee.TESTFIELD("Statistics Group Code");
        IF NOT EmployeePayrollGroup.GET(Employee."Statistics Group Code") THEN
            ERROR(ASLT0006, Employee."Statistics Group Code", Employee."No.");

        EmployeePayrollGroup.TESTFIELD("Loan G/L Account");
        EmployeePayrollGroup.TESTFIELD("Loan Deduction Code");
        EmployeePayrollGroup.TESTFIELD("Interest Deduction Code");

        IF Posted THEN BEGIN
            IF (EmployeePayrollGroup."Next Payroll Processing Date" <> 0D) THEN BEGIN
                Month := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 2);
                Year := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 3);
                Period := FORMAT(Month) + '-' + FORMAT(Year);
            END;
            SalesLine2.RESET;
            SalesLine2.SETRANGE("Document Type", "Document Type");
            SalesLine2.SETRANGE("Document No.", "No.");
            SalesLine2.SETRANGE(Posted, TRUE);
            SalesLine2.SETRANGE("Transfered To Payroll", FALSE);
            //SalesLine2.SETRANGE(Period, Period);
            IF SalesLine2.FINDFIRST THEN BEGIN
                EmployeeDeductions.RESET;
                EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", Employee."No.");
                EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", EmployeePayrollGroup."Loan Deduction Code");
                EmployeeDeductions.SETRANGE("Fixed Amount", SalesLine2.Repayment);
                IF EmployeeDeductions.FINDFIRST THEN BEGIN
                    ERROR(ASLT0008);
                END ELSE BEGIN
                    LineNo := 1000;
                    EmployeeDeductions.INIT;
                    EmployeeDeductions.VALIDATE("Employee No.", Employee."No.");
                    EmployeeDeductions.VALIDATE("Confidential Code", EmployeePayrollGroup."Loan Deduction Code");
                    EmployeeDeductions."Line No." := LineNo;
                    EmployeeDeductions.VALIDATE("Fixed Amount", SalesLine2.Repayment);
                    EmployeeDeductions."System Created" := TRUE;
                    EmployeeDeductions.INSERT(TRUE);
                    LineNo += 1000;
                    IF (SalesLine2.Interest <> 0) THEN BEGIN
                        EmployeeDeductions.INIT;
                        EmployeeDeductions.VALIDATE("Employee No.", Employee."No.");
                        EmployeeDeductions.VALIDATE("Confidential Code", EmployeePayrollGroup."Interest Deduction Code");
                        EmployeeDeductions."Line No." := LineNo;
                        EmployeeDeductions.VALIDATE("Fixed Amount", SalesLine2.Interest);
                        EmployeeDeductions."System Created" := TRUE;
                        EmployeeDeductions.INSERT(TRUE);
                    END;
                    SalesLine2."Transfered To Payroll" := TRUE;
                    SalesLine2.MODIFY;
                END;
            END;
        END ELSE
            ERROR(ASLT0007);
        Message('Loan %1 for period %2 successfully Transfered to the Current Payroll !!', "No.", SalesLine2.Period);
    end;


    //------------------------------------------------------------
    procedure LookupShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        myInt: Integer;
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //---------------------------------------------------------
    procedure PostponeLoanPeriod()
    var

        Employee: Record Employee;
        RemainingAmountToApply: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ReceiptLines: Record "Loan and Advance Lines";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        LoanLineRec: Record "Loan and Advance Lines";
        SalesCommentLine: Record "Voucher And Receipt";
        InvoiceDocNo: Code[20];
        PD: Code[10];
        MonthInt: Integer;
        YearInt: Integer;
        Pos: Integer;
        LineNo: Integer;
        M: Integer;
        Y: Integer;
        ContinueGeneration: Boolean;
    begin

        TESTFIELD("Document Type", "Document Type"::Loan);
        IF "Employee No." = '' THEN
            ERROR(ASLT0005, "No.");

        IF NOT Employee.GET("Employee No.") THEN
            ERROR(ASLT0003, "Employee No.");

        Employee.TESTFIELD("Statistics Group Code");
        IF NOT EmployeePayrollGroup.GET(Employee."Statistics Group Code") THEN
            ERROR(ASLT0006, Employee."Statistics Group Code", Employee."No.");

        EmployeePayrollGroup.TESTFIELD("Loan G/L Account");
        EmployeePayrollGroup.TESTFIELD("Loan Deduction Code");
        EmployeePayrollGroup.TESTFIELD("Interest Deduction Code");

        IF (Installments <= 0) THEN
            ERROR(ASLT0001);
        IF ("Start Period Date" = 0D) THEN
            ERROR(ASLT0002);
        IF ("Suspension Duration" <= 0) THEN
            ERROR(ASLT0009);
        J := "Suspension Duration";

        IF (EmployeePayrollGroup."Next Payroll Processing Date" <> 0D) THEN BEGIN
            M := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 2);
            Y := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 3);
            PD := FORMAT(M) + '-' + FORMAT(Y);
        END;

        ReceiptLines.RESET;
        ReceiptLines.SETRANGE("Document Type", "Document Type");
        ReceiptLines.SETRANGE("Document No.", "No.");
        ReceiptLines.SETFILTER(Period, '>=%1', PD);
        ReceiptLines.SETRANGE(Posted, TRUE);
        ReceiptLines.SETRANGE("Loan Cleared", FALSE);
        IF ReceiptLines.FINDFIRST THEN BEGIN
            M += J;
            // Use the first loan line to look for all the other lines and change their periods
            LoanLineRec.RESET;
            LoanLineRec.SETRANGE("Document Type", "Document Type");
            LoanLineRec.SETRANGE("Document No.", "No.");
            LoanLineRec.SETFILTER("Line No.", '>=%1', ReceiptLines."Line No.");
            IF LoanLineRec.FINDFIRST THEN
                REPEAT
                    IF (M > 12) THEN BEGIN
                        M := 1;
                        Y := Y + 1;
                    END;
                    LoanLineRec.Period := FORMAT(M) + '-' + FORMAT(Y);
                    LoanLineRec."Transfered To Payroll" := FALSE;
                    LoanLineRec.MODIFY;
                    M += 1;
                UNTIL (LoanLineRec.NEXT = 0);
        END;
        EmployeeDeductions.RESET;
        EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", "Employee No.");
        EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", EmployeePayrollGroup."Loan Deduction Code");
        IF EmployeeDeductions.FINDFIRST THEN BEGIN
            EmployeeDeductions."Fixed Amount" := 0;
            EmployeeDeductions.MODIFY;
        END;
        EmployeeDeductions.RESET;
        EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", "Employee No.");
        EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", EmployeePayrollGroup."Interest Deduction Code");
        IF EmployeeDeductions.FINDFIRST THEN BEGIN
            EmployeeDeductions."Fixed Amount" := 0;
            EmployeeDeductions.MODIFY;
        END

    end;

    //----------------------------------------------------
    procedure ShowShortcutDimCode(VAR ShortcutDimCode: ARRAY[8] OF Code[20])
    var
        myInt: Integer;
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //----------------------------------------------------
    procedure PostAdvanceDiscarded()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        Employee: Record Employee;
        EmployeeDimension: Record "Employee Comment Line";
        PostJnLBatch: Codeunit "Gen. Jnl.-Post Batch";
        Deductions: Record Confidential;
        AdvanceLine: Record "Loan and Advance Lines";
        LineNo: Integer;
        ShortcutDim1: Code[20];
        ShortcutDim2: Code[20];
        ShortcutDim3: Code[20];
        ShortcutDim4: Code[20];
        ShortcutDim5: Code[20];
        ShortcutDim6: Code[20];
        ShortcutDim7: Code[20];
        ShortcutDim8: Code[20];
    begin
        TESTFIELD("Document Type", "Document Type"::Advance);
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'ADVANCE');
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
        IF NOT GenJournalLine.FINDFIRST THEN
            ERROR(ASLT0020);

        HRSetup.GET;
        IF Posted THEN
            EXIT;
        IF "Issuing Bank Account" = '' THEN
            ERROR(ASLT0010, "No.");

        IF "Employee No." = '' THEN
            ERROR(ASLT0011, "No.");

        IF NOT Employee.GET("Employee No.") THEN
            ERROR(ASLT0003, "Employee No.");

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'ADVANCE');
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
        IF GenJournalLine.FINDFIRST THEN BEGIN
            GenJournalLine.TransferJournalToVoucher(GenJournalLine);
            PostJnLBatch.RUN(GenJournalLine);
        END;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'ADVANCE');
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
        IF NOT GenJournalLine.FINDFIRST THEN BEGIN
            AdvanceLine.RESET;
            AdvanceLine.SETRANGE("Document Type", "Document Type");
            AdvanceLine.SETRANGE("Document No.", "No.");
            AdvanceLine.SETRANGE(Posted, FALSE);
            AdvanceLine.SETRANGE("Transfered To Payroll", FALSE);
            IF AdvanceLine.FINDFIRST THEN
                REPEAT
                    AdvanceLine.Posted := TRUE;
                    AdvanceLine.MODIFY;
                UNTIL AdvanceLine.NEXT = 0;
            Posted := TRUE;
            "Paid To Employee" := TRUE;
            MODIFY;
        END;
    end;

    //------------------------------------------------------------
    procedure TransferAdvanceToPayroll()
    var
        Employee: Record Employee;
        AdvanceLine: Record "Loan and Advance Lines";
        LineNo: Integer;
        Period: Code[10];
        Month: Integer;
        Year: Integer;
    begin
        TESTFIELD("Document Type", "Document Type"::Advance);
        IF "Issuing Bank Account" = '' THEN
            ERROR(ASLT0010, "No.");

        IF "Employee No." = '' THEN
            ERROR(ASLT0011, "No.");

        IF NOT Employee.GET("Employee No.") THEN
            ERROR(ASLT0003, "Employee No.");

        Employee.TESTFIELD("Statistics Group Code");
        IF NOT EmployeePayrollGroup.GET(Employee."Statistics Group Code") THEN
            ERROR(ASLT0006, Employee."Statistics Group Code", Employee."No.");

        EmployeePayrollGroup.TESTFIELD("Advance Salary G/L Account");
        EmployeePayrollGroup.TESTFIELD("Advance Salary Deduction Code");

        IF Posted THEN BEGIN
            IF (EmployeePayrollGroup."Next Payroll Processing Date" <> 0D) THEN BEGIN
                Month := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 2);
                Year := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 3);
                Period := FORMAT(Month) + '-' + FORMAT(Year);
            END;
            AdvanceLine.RESET;
            AdvanceLine.SETRANGE("Document Type", "Document Type");
            AdvanceLine.SETRANGE("Document No.", "No.");
            AdvanceLine.SETRANGE(Posted, TRUE);
            AdvanceLine.SETRANGE("Transfered To Payroll", FALSE);
            //AdvanceLine.SETRANGE(Period, Period);
            IF AdvanceLine.FINDFIRST THEN BEGIN
                EmployeeDeductions.RESET;
                EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", Employee."No.");
                EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", EmployeePayrollGroup."Advance Salary Deduction Code");
                EmployeeDeductions.SETRANGE("Fixed Amount", AdvanceLine.Repayment);
                IF EmployeeDeductions.FINDFIRST THEN BEGIN
                    ERROR(ASLT0008);
                END ELSE BEGIN
                    LineNo := 1000;
                    EmployeeDeductions.INIT;
                    EmployeeDeductions.VALIDATE("Employee No.", Employee."No.");
                    EmployeeDeductions.VALIDATE("Confidential Code", EmployeePayrollGroup."Advance Salary Deduction Code");
                    EmployeeDeductions."Line No." := LineNo;
                    EmployeeDeductions.VALIDATE("Fixed Amount", AdvanceLine.Repayment);
                    EmployeeDeductions."System Created" := TRUE;
                    EmployeeDeductions.INSERT(TRUE);
                    AdvanceLine."Transfered To Payroll" := TRUE;
                    AdvanceLine.MODIFY;
                END;
            END;
        END ELSE
            ERROR(ASLT0007);

        Message('Advance %1 for period %2 successfully Transfered to the Current Payroll', "No.", AdvanceLine.Period);
    end;


    //--------------------------------------------------------------------------
    procedure PostponeAdvancePeriod()
    var
        Employee: Record Employee;
        RemainingAmountToApply: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        AdvanceLines: Record "Loan and Advance Lines";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        AdvanceLine: Record "Loan and Advance Lines";
        InvoiceDocNo: Code[20];
        PD: Code[10];
        M: Integer;
        Y: Integer;
        MonthInt: Integer;
        YearInt: Integer;
        LineNo: Integer;
        ContinueGeneration: Boolean;
    begin
        TESTFIELD("Document Type", "Document Type"::Advance);
        IF "Employee No." = '' THEN
            ERROR(ASLT0011, "No.");

        IF NOT Employee.GET("Employee No.") THEN
            ERROR(ASLT0003, "Employee No.");

        Employee.TESTFIELD("Statistics Group Code");
        IF NOT EmployeePayrollGroup.GET(Employee."Statistics Group Code") THEN
            ERROR(ASLT0006, Employee."Statistics Group Code", Employee."No.");

        EmployeePayrollGroup.TESTFIELD("Advance Salary G/L Account");
        EmployeePayrollGroup.TESTFIELD("Advance Salary Deduction Code");

        IF (Installments <= 0) THEN
            ERROR(ASLT0001);
        IF ("Start Period Date" = 0D) THEN
            ERROR(ASLT0002);
        IF ("Suspension Duration" <= 0) THEN
            ERROR(ASLT0009);
        J := "Suspension Duration";
        M := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 2);
        Y := DATE2DMY(EmployeePayrollGroup."Next Payroll Processing Date", 3);
        PD := FORMAT(M) + '-' + FORMAT(Y);

        AdvanceLines.RESET;
        AdvanceLines.SETRANGE("Document Type", "Document Type");
        AdvanceLines.SETRANGE("Document No.", "No.");
        AdvanceLines.SETFILTER(Period, '>=%1', PD);
        AdvanceLines.SETRANGE(Posted, TRUE);
        AdvanceLines.SETRANGE("Advance Cleared", FALSE);
        IF AdvanceLines.FINDFIRST THEN BEGIN
            M += J;
            // Use the first advance line to look for all the other lines and change their periods
            AdvanceLine.RESET;
            AdvanceLine.SETRANGE("Document Type", "Document Type");
            AdvanceLine.SETRANGE("Document No.", "No.");
            AdvanceLine.SETFILTER("Line No.", '>=%1', AdvanceLines."Line No.");
            IF AdvanceLine.FINDFIRST THEN
                REPEAT
                    IF (M > 12) THEN BEGIN
                        M := 1;
                        Y := Y + 1;
                    END;
                    AdvanceLine.Period := FORMAT(M) + '-' + FORMAT(Y);
                    AdvanceLine."Transfered To Payroll" := FALSE;
                    AdvanceLine.MODIFY;
                    M += 1;
                UNTIL (AdvanceLine.NEXT = 0);
        END;
        EmployeeDeductions.RESET;
        EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", "Employee No.");
        EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", EmployeePayrollGroup."Advance Salary Deduction Code");
        IF EmployeeDeductions.FINDFIRST THEN BEGIN
            EmployeeDeductions."Fixed Amount" := 0;
            EmployeeDeductions.MODIFY;
        END;

    end;

    //-------------------------------------------------------------
    procedure PostLoan()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        Employee: Record Employee;
        EmployeeDimension: Record "Employee Comment Line";
        PostJnLBatch: Codeunit "Gen. Jnl.-Post Batch";
        Deductions: Record Confidential;
        LoanLine: Record "Loan and Advance Lines";
        SalesCommentLine: Record "Voucher And Receipt";
        LineNo: Integer;
        LoanLineNo: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        InterestLineNo: Integer;
        ShortcutDim1: Code[20];
        ShortcutDim2: Code[20];
        ShortcutDim3: Code[20];
        ShortcutDim4: Code[20];
        ShortcutDim5: Code[20];
        ShortcutDim6: Code[20];
        ShortcutDim7: Code[20];
        ShortcutDim8: Code[20];
        LoanDocNo: Code[20];
        InterestDocNo: Code[20];
    begin

        HRSetup.GET;
        IF Posted THEN
            EXIT;
        IF "Issuing Bank Account" = '' THEN
            ERROR(ASLT0004, "No.");

        IF "Employee No." = '' THEN
            ERROR(ASLT0005, "No.");

        IF "External Document No." = '' THEN
            ERROR(ASLT0015, "No.");

        IF NOT Employee.GET("Employee No.") THEN
            ERROR(ASLT0003, "Employee No.");

        Employee.TESTFIELD("Statistics Group Code");
        Employee.TestEmployeeDimensions;
        EmployeeDimension.RESET;
        EmployeeDimension.SETRANGE(EmployeeDimension."Table Name", EmployeeDimension."Table Name"::Employee);
        EmployeeDimension.SETRANGE(EmployeeDimension."No.", "Employee No.");
        EmployeeDimension.SETRANGE("Table Line No.", 5200);
        EmployeeDimension.SETRANGE("Alternative Address Code", '');
        EmployeeDimension.SETRANGE("Line No.", 10000);
        EmployeeDimension.SETRANGE(Type, EmployeeDimension.Type::Employee);
        IF EmployeeDimension.FINDFIRST THEN BEGIN
            ShortcutDim1 := EmployeeDimension."Shortcut Dimension 1 Code";
            ShortcutDim2 := EmployeeDimension."Shortcut Dimension 2 Code";
            ShortcutDim3 := EmployeeDimension."Shortcut Dimension 3 Code";
            ShortcutDim4 := EmployeeDimension."Shortcut Dimension 4 Code";
            ShortcutDim5 := EmployeeDimension."Shortcut Dimension 5 Code";
            ShortcutDim6 := EmployeeDimension."Shortcut Dimension 6 Code";
            ShortcutDim7 := EmployeeDimension."Shortcut Dimension 7 Code";
            ShortcutDim8 := EmployeeDimension."Shortcut Dimension 8 Code";
        END;

        IF NOT EmployeePayrollGroup.GET(Employee."Statistics Group Code") THEN
            ERROR(ASLT0006, Employee."Statistics Group Code", Employee."No.");

        EmployeePayrollGroup.TESTFIELD("Loan G/L Account");
        EmployeePayrollGroup.TESTFIELD("Loan Deduction Code");

        IF NOT GenJnlBatch.GET('PAYMENT', 'LOAN') THEN BEGIN
            GenJnlBatch.INIT;
            GenJnlBatch.VALIDATE("Journal Template Name", 'PAYMENT');
            GenJnlBatch.Name := 'LOAN';
            GenJnlBatch.Description := 'Loan';
            GenJnlBatch.INSERT(TRUE);
        END;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'LOAN');
        IF GenJournalLine.FINDLAST THEN
            LoanLineNo := GenJournalLine."Line No." + 10000
        ELSE
            LoanLineNo := 10000;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'LOAN');
        GenJournalLine.SETRANGE(GenJournalLine."Loan No.", "No.");
        IF GenJournalLine.FINDFIRST THEN
            ERROR(ASLT0014, "No.");

        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'PAYMENT';
        GenJournalLine."Journal Batch Name" := 'LOAN';
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
        GenJournalLine."Document No." := "No.";
        LoanDocNo := "No.";
        GenJournalLine."Loan No." := "No.";
        GenJournalLine."Line No." := LoanLineNo;
        GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine.VALIDATE(GenJournalLine."Account No.", EmployeePayrollGroup."Loan G/L Account");
        GenJournalLine.VALIDATE("Posting Date", "Creation Date");
        GenJournalLine.Description := COPYSTR("Employee Name", 1, 50);
        GenJournalLine.VALIDATE(Amount, Principal);
        GenJournalLine.VALIDATE("Currency Code", Currency);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
        GenJournalLine.VALIDATE("Bal. Account No.", "Issuing Bank Account");
        //GenJournalLine.VALIDATE("Bal. Gen. Posting Type", GenJournalLine."Bal. Gen. Posting Type"::Purchase);
        //IF "Ext. Document No." <> '' THEN
        GenJournalLine."External Document No." := "External Document No.";
        CALCFIELDS("Employee Name");
        GenJournalLine."Paid To/Received From" := "Employee Name";
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ShortcutDim1);
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ShortcutDim2);
        GenJournalLine.ValidateShortcutDimCode(3, ShortcutDim3);
        GenJournalLine.ValidateShortcutDimCode(4, ShortcutDim4);
        GenJournalLine.ValidateShortcutDimCode(5, ShortcutDim5);
        GenJournalLine.ValidateShortcutDimCode(6, ShortcutDim6);
        GenJournalLine.ValidateShortcutDimCode(7, ShortcutDim7);
        GenJournalLine.ValidateShortcutDimCode(8, ShortcutDim8);
        GenJournalLine.INSERT(TRUE);
        //Send Loan Entry for Approval
        GenJournalLine2.RESET;
        GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENT');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'LOAN');
        GenJournalLine2.SETRANGE("Document No.", LoanDocNo);
        IF GenJournalLine2.FINDFIRST THEN BEGIN
            GenJournalLine2.TransferJournalToVoucher(GenJournalLine2);
            PostJnLBatch.RUN(GenJournalLine2);
        END;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'INTEREST');
        IF GenJournalLine.FINDLAST THEN
            InterestLineNo := GenJournalLine."Line No." + 10000
        ELSE
            InterestLineNo := 10000;

        IF ("Interest Rate" <> 0) THEN BEGIN
            EmployeePayrollGroup.TESTFIELD("Interest Deduction Code");
            Deductions.GET(Deductions.Type::Deduction, EmployeePayrollGroup."Interest Deduction Code");
            Deductions.TESTFIELD("Account No.");
            IF NOT GenJnlBatch.GET('GENERAL', 'INTEREST') THEN BEGIN
                GenJnlBatch.INIT;
                GenJnlBatch.VALIDATE("Journal Template Name", 'GENERAL');
                GenJnlBatch.Name := 'INTEREST';
                GenJnlBatch.Description := 'Loan Interest';
                GenJnlBatch.INSERT(TRUE);
            END;

            SalesLine2.RESET;
            SalesLine2.SETRANGE("Document Type", "Document Type");
            SalesLine2.SETRANGE("Document No.", "No.");
            SalesLine2.SETRANGE(Posted, FALSE);
            SalesLine2.SETRANGE("Transfered To Payroll", FALSE);
            IF SalesLine2.FINDFIRST THEN
                REPEAT
                    InterestLineNo += 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'INTEREST';
                    GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                    GenJournalLine."Document No." := NoSeriesMgt.GetNextNo(HRSetup."Loan Interest Doc. Nos.", TODAY, TRUE);
                    InterestDocNo := GenJournalLine."Document No.";
                    GenJournalLine."Line No." := InterestLineNo;
                    GenJournalLine."Loan No." := "No.";
                    //GenJournalLine."Gen. Posting Type"         := GenJournalLine."Gen. Posting Type"::Sale;
                    GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.", Deductions."Account No.");
                    GenJournalLine.VALIDATE("Posting Date", "Creation Date");
                    GenJournalLine.Description := COPYSTR("Employee Name", 1, 50);
                    GenJournalLine.VALIDATE(Amount, SalesLine2.Interest);
                    GenJournalLine.VALIDATE("Currency Code", Currency);
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Bal. Account No.", EmployeePayrollGroup."Loan Interest Income A/C");
                    GenJournalLine.VALIDATE("Bal. Gen. Posting Type", GenJournalLine."Bal. Gen. Posting Type"::Sale);
                    //IF "Ext. Document No." <> '' THEN
                    //  GenJournalLine."External Document No." := "Ext. Document No.";
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ShortcutDim1);
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ShortcutDim2);
                    GenJournalLine.ValidateShortcutDimCode(3, ShortcutDim3);
                    GenJournalLine.ValidateShortcutDimCode(4, ShortcutDim4);
                    GenJournalLine.ValidateShortcutDimCode(5, ShortcutDim5);
                    GenJournalLine.ValidateShortcutDimCode(6, ShortcutDim6);
                    GenJournalLine.ValidateShortcutDimCode(7, ShortcutDim7);
                    GenJournalLine.ValidateShortcutDimCode(8, ShortcutDim8);
                    GenJournalLine.INSERT(TRUE);
                    // Send Interest Journal Entry for approval
                    GenJournalLine2.RESET;
                    GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
                    GenJournalLine2.SETRANGE("Journal Batch Name", 'INTEREST');
                    GenJournalLine2.SETRANGE("Document No.", InterestDocNo);
                    IF GenJournalLine2.FINDFIRST THEN BEGIN
                        GenJournalLine2.TransferJournalToVoucher(GenJournalLine2);
                        PostJnLBatch.RUN(GenJournalLine2);
                    END;
                UNTIL SalesLine2.NEXT = 0;
        END;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'LOAN');
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
        IF NOT GenJournalLine.FINDFIRST THEN BEGIN
            LoanLine.RESET;
            LoanLine.SETRANGE("Document Type", "Document Type");
            LoanLine.SETRANGE("Document No.", "No.");
            LoanLine.SETRANGE(Posted, FALSE);
            LoanLine.SETRANGE("Transfered To Payroll", FALSE);
            IF LoanLine.FINDFIRST THEN
                REPEAT
                    LoanLine.Posted := TRUE;
                    LoanLine.MODIFY;
                UNTIL LoanLine.NEXT = 0;
            Posted := TRUE;
            "Paid To Employee" := TRUE;
            MODIFY;
            COMMIT;
            SalesCommentLine.UpdatePostedVoucher("No.", 'LOAN', "Creation Date");
        END;
        Message('Loan %1 successfully posted to the General Ledder', "No.");

    end;


    //-----------------------------------------------------------
    procedure PostAdvance()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        GenJournalLine3: Record "Gen. Journal Line";
        Employee: Record Employee;
        EmployeeDimension: Record "Employee Comment Line";
        PostJnLBatch: Codeunit "Gen. Jnl.-Post Batch";
        Deductions: Record Confidential;
        AdvanceLine: Record "Loan and Advance Lines";
        SalesCommentLine: Record "Voucher And Receipt";
        LineNo: Integer;
        AdvanceDocNo: Code[20];
        ShortcutDim1: Code[20];
        ShortcutDim2: Code[20];
        ShortcutDim3: Code[20];
        ShortcutDim4: Code[20];
        ShortcutDim5: Code[20];
        ShortcutDim6: Code[20];
        ShortcutDim7: Code[20];
        ShortcutDim8: Code[20];
    begin

        TESTFIELD("Document Type", "Document Type"::Advance);
        HRSetup.GET;
        IF Posted THEN
            EXIT;
        IF "Issuing Bank Account" = '' THEN
            ERROR(ASLT0010, "No.");

        IF "External Document No." = '' THEN
            ERROR(ASLT0016, "No.");

        IF "Employee No." = '' THEN
            ERROR(ASLT0011, "No.");

        IF NOT Employee.GET("Employee No.") THEN
            ERROR(ASLT0003, "Employee No.");

        Employee.TESTFIELD("Statistics Group Code");
        //Employee.TestEmployeeDimensions;
        EmployeeDimension.RESET;
        EmployeeDimension.SETRANGE(EmployeeDimension."Table Name", EmployeeDimension."Table Name"::Employee);
        EmployeeDimension.SETRANGE(EmployeeDimension."No.", "Employee No.");
        EmployeeDimension.SETRANGE("Table Line No.", 5200);
        EmployeeDimension.SETRANGE("Alternative Address Code", '');
        EmployeeDimension.SETRANGE("Line No.", 10000);
        EmployeeDimension.SETRANGE(Type, EmployeeDimension.Type::Employee);
        IF EmployeeDimension.FINDFIRST THEN BEGIN
            ShortcutDim1 := EmployeeDimension."Shortcut Dimension 1 Code";
            ShortcutDim2 := EmployeeDimension."Shortcut Dimension 2 Code";
            ShortcutDim3 := EmployeeDimension."Shortcut Dimension 3 Code";
            ShortcutDim4 := EmployeeDimension."Shortcut Dimension 4 Code";
            ShortcutDim5 := EmployeeDimension."Shortcut Dimension 5 Code";
            ShortcutDim6 := EmployeeDimension."Shortcut Dimension 6 Code";
            ShortcutDim7 := EmployeeDimension."Shortcut Dimension 7 Code";
            ShortcutDim8 := EmployeeDimension."Shortcut Dimension 8 Code";
        END;

        IF NOT EmployeePayrollGroup.GET(Employee."Statistics Group Code") THEN
            ERROR(ASLT0006, Employee."Statistics Group Code", Employee."No.");

        EmployeePayrollGroup.TESTFIELD("Advance Salary G/L Account");
        EmployeePayrollGroup.TESTFIELD("Advance Salary Deduction Code");

        IF NOT GenJnlBatch.GET('PAYMENT', 'ADVANCE') THEN BEGIN
            GenJnlBatch.INIT;
            GenJnlBatch.VALIDATE("Journal Template Name", 'PAYMENT');
            GenJnlBatch.Name := 'ADVANCE';
            GenJnlBatch.Description := 'Salary Advance';
            GenJnlBatch.INSERT(TRUE);
        END;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'ADVANCE');
        IF GenJournalLine.FINDLAST THEN
            LineNo := GenJournalLine."Line No." + 10000
        ELSE
            LineNo := 10000;

        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'PAYMENT';
        GenJournalLine."Journal Batch Name" := 'ADVANCE';
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
        GenJournalLine."Document No." := "No.";
        AdvanceDocNo := "No.";
        GenJournalLine."Loan No." := "No.";
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine.VALIDATE(GenJournalLine."Account No.", EmployeePayrollGroup."Advance Salary G/L Account");
        GenJournalLine.VALIDATE("Posting Date", "Creation Date");
        GenJournalLine.Description := COPYSTR("Employee Name", 1, 50);
        GenJournalLine.VALIDATE(Amount, Principal);
        GenJournalLine.VALIDATE("Currency Code", Currency);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
        GenJournalLine.VALIDATE("Bal. Account No.", "Issuing Bank Account");
        //GenJournalLine.VALIDATE("Bal. Gen. Posting Type", GenJournalLine."Bal. Gen. Posting Type"::Purchase);
        //IF "Ext. Document No." <> '' THEN
        //  GenJournalLine."External Document No." := "Ext. Document No.";
        GenJournalLine."External Document No." := "External Document No.";
        CALCFIELDS("Employee Name");
        GenJournalLine."Paid To/Received From" := "Employee Name";
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ShortcutDim1);
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ShortcutDim2);
        GenJournalLine.ValidateShortcutDimCode(3, ShortcutDim3);
        GenJournalLine.ValidateShortcutDimCode(4, ShortcutDim4);
        GenJournalLine.ValidateShortcutDimCode(5, ShortcutDim5);
        GenJournalLine.ValidateShortcutDimCode(6, ShortcutDim6);
        GenJournalLine.ValidateShortcutDimCode(7, ShortcutDim7);
        GenJournalLine.ValidateShortcutDimCode(8, ShortcutDim8);
        GenJournalLine.INSERT(TRUE);

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'ADVANCE');
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
        IF GenJournalLine.FINDFIRST THEN BEGIN
            GenJournalLine.TransferJournalToVoucher(GenJournalLine);
            PostJnLBatch.RUN(GenJournalLine);
        END;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'PAYMENT');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'ADVANCE');
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", "No.");
        IF NOT GenJournalLine.FINDFIRST THEN BEGIN
            AdvanceLine.RESET;
            AdvanceLine.SETRANGE("Document Type", "Document Type");
            AdvanceLine.SETRANGE("Document No.", "No.");
            AdvanceLine.SETRANGE(Posted, FALSE);
            AdvanceLine.SETRANGE("Transfered To Payroll", FALSE);
            IF AdvanceLine.FINDFIRST THEN
                REPEAT
                    AdvanceLine.Posted := TRUE;
                    AdvanceLine.MODIFY;
                UNTIL AdvanceLine.NEXT = 0;
            Posted := TRUE;
            "Paid To Employee" := TRUE;
            MODIFY;
            COMMIT;
            SalesCommentLine.UpdatePostedVoucher("No.", 'ADVANCE', "Creation Date");
        END;
        Message('Advance %1 successfully Posted into the General Ledger !!', "No.");
    end;

    //------------------------------------------------------------
    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR
                                                          ShortcutDimCode: Code[20])
    var
        myInt: Integer;
        OldDimSetID: Integer;
        DimMgt: Codeunit DimensionManagement;
    begin

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;

        // IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        //     MODIFY;
        //     IF SalesLinesExist THEN
        //         UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        // END;
    end;

    //----------------------------------------------------------

    procedure SalesLinesExist(): Boolean
    var
        myInt: Integer;
        SalesLine: Record "Loan and Advance Lines";
    begin

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE("Document No.", "No.");
        EXIT(SalesLine.FINDFIRST);
    end;

    //---------------------------------------------------------------
    procedure ValidateShortcutDimensionCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        myInt: Integer;
    begin

        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;


    //----------------------------------------------------------
    procedure CopyPostedSalesInvoice(PostedInvNo: Code[20])
    var
        myInt: Integer;
        DocType: Option Quote,"Blanket Order",Order,Invoice,"Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo";
        DocNo: Code[20];
        PostedInvoice: Record "Sales Invoice Header";
        SalesSetup: Record "Sales & Receivables Setup";
    begin

        SalesSetup.GET;
        PostedInvoice.RESET;
        PostedInvoice.SETRANGE("No.", PostedInvNo);
        IF PostedInvoice.FINDFIRST THEN BEGIN
            CopyDocMgt.SetProperties(
              TRUE, FALSE, FALSE, FALSE, FALSE, SalesSetup."Exact Cost Reversing Mandatory", FALSE);
            //CopyDocMgt.CopySalesDoc(DocType::"Posted Invoice", PostedInvoice."No.");
        END;
    end;
}
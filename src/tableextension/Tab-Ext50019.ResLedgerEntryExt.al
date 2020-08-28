tableextension 50019 "Res. Ledger Entry Ext" extends "Res. Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50005; "Entry Type Payroll"; Option)
        {
            OptionMembers = Usage,Sale,"Pending Payroll Item","Payroll Period","Payroll Entry";
        }
        field(50010; "Payroll Entry Type"; Option)
        {
            OptionMembers = " ","Basic Pay",Earning,Deduction,"Income Tax","Net Salary Payable","Net Salary Paid","Local Service Tax";
        }
        field(50011; "Taxable/Pre-Tax Deductible"; Boolean) { }
        field(50012; "ED Code"; Code[10]) { }
        field(50013; "Employee Statistics Group"; Code[10])
        {
            TableRelation = "Employee Statistics Group".Code;
        }
        field(50015; "Currency Code"; Code[10])
        {
            TableRelation = Currency.Code;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    "Currency Factor" := CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                VALIDATE(Amount);
                VALIDATE("Employer Amount");
            end;
        }
        field(50016; "Currency Factor"; Decimal) { }
        field(50020; Amount; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE
                    "Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", Amount, "Currency Factor"));

            end;
        }
        field(50021; "Amount (LCY)"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Currency Code" = '' THEN
                    Amount := "Amount (LCY)"
                ELSE
                    Amount := ROUND(CurrExchRate.ExchangeAmtLCYToFCY("Posting Date", "Currency Code", "Amount (LCY)", "Currency Factor"));

            end;
        }
        field(50022; "Employer Amount"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Currency Code" = '' THEN
                    "Employer Amount (LCY)" := "Employer Amount"
                ELSE
                    "Employer Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code",

                                                                                   "Employer Amount", "Currency Factor"));

            end;
        }
        field(50023; "Employer Amount (LCY)"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Currency Code" = '' THEN
                    "Employer Amount" := "Employer Amount (LCY)"
                ELSE
                    "Employer Amount" :=
                        ROUND(CurrExchRate.ExchangeAmtLCYToFCY("Posting Date", "Currency Code", "Employer Amount (LCY)", "Currency Factor"));

            end;
        }
        field(50024; "Period Closed"; Boolean) { }
        field(50030; "Payroll Item Type"; Option)
        {
            OptionMembers = " ",Earning,Deduction;
        }
        field(50031; "Posted To Payroll"; Boolean)
        {
            Editable = false;
        }
        field(50040; "Employee Bank Account No."; Code[25])
        {
            FieldClass = FlowField;
            CalcFormula = Min (Employee."Bank Account No." WHERE("No." = FIELD("Resource No.")));
        }
        field(50050; "Major Location"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Min (Employee."Major Location" WHERE("No." = FIELD("Resource No.")));
        }
        field(50060; "Shortcut Dimension 03"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50061; "Shortcut Dimension 04"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(50062; "Shortcut Dimension 05"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(50063; "Shortcut Dimension 06"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(50064; "Shortcut Dimension 07"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(50065; "Shortcut Dimension 08"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        field(50066; "Parent Code"; Code[20])
        {
            TableRelation = Confidential.Code WHERE(Parent = FILTER(true));
        }
    }

    var
        myInt: Integer;
        CurrExchRate: Record "Currency Exchange Rate";
}
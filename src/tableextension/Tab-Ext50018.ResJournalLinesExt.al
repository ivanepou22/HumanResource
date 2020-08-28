tableextension 50018 "Res. Journal Lines Ext" extends "Res. Journal Line"
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
        field(50040; "Payroll Item ED Code"; Code[10]) { }
        field(50050; "Shortcut Dimension 3 Code"; Code[20])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50051; "Shortcut Dimension 4 Code"; Code[20])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(50052; "Shortcut Dimension 5 Code"; Code[20])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(50053; "Shortcut Dimension 6 Code"; Code[20])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(50054; "Shortcut Dimension 7 Code"; Code[20])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(50055; "Shortcut Dimension 8 Code"; Code[20])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
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
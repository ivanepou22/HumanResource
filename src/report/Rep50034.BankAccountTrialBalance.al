report 50034 "Bank Account Trial Balance"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'BankAccountTrialBalance.rdlc';

    dataset
    {
        dataitem(BankAccount; "Bank Account")
        {
            RequestFilterFields = "No.", "Date Filter";
            Column(Company_Name; CompanyInfo.Name) { }
            Column(Company_Address; CompanyInfo.Address) { }
            Column(Company_PhoneNo; CompanyInfo."Phone No.") { }
            Column(Company_Picture; CompanyInfo.Picture) { }
            Column(Company_Email; CompanyInfo."E-Mail") { }
            Column(Company_HomePage; CompanyInfo."Home Page") { }
            column(BankAccount_No; BankAccount."No.") { }
            column(BankAccount_Name; BankAccount.Name) { }
            column(BankAccount_Currency; BankAccount."Currency Code") { }
            column(ClosingBalanceAmount; ClosingBalanceAmount) { }
            column(ClosingBalanceAmountLCY; ClosingBalanceAmountLCY) { }
            column(OpeningBalanceAmount; OpeningBalanceAmount) { }
            column(OpeningBalanceAmountLCY; OpeningBalanceAmountLCY) { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                ClosingBalanceAmount := 0;
                OpeningBalanceAmount := 0;

                //Getting opening Bank Account Balances
                if DateFilterItem <> '' then begin
                    if GetRangeMin("Date Filter") <> 0D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                        CalcFields("Balance at Date");
                        CalcFields("Balance at Date (LCY)");
                        OpeningBalanceAmount := "Balance at Date";
                        OpeningBalanceAmountLCY := "Balance at Date (LCY)";
                        SetFilter("Date Filter", DateFilterItem);
                    end;
                end;

                //Getting the Closing Bank Account Balances
                if DateFilterItem <> '' then begin
                    if GetRangeMin("Date Filter") <> 0D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter"));
                        CalcFields("Balance at Date");
                        CalcFields("Balance at Date (LCY)");
                        ClosingBalanceAmount := "Balance at Date";
                        ClosingBalanceAmountLCY := "Balance at Date (LCY)";
                        SetFilter("Date Filter", DateFilterItem);
                    end;
                end;

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        OpeningBalanceAmount: Decimal;
        ClosingBalanceAmount: Decimal;

        OpeningBalanceAmountLCY: Decimal;
        ClosingBalanceAmountLCY: Decimal;
        ReportDate: Date;
        LocationFilter: Text[150];
        DateFilterItem: Text[150];

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        DateFilterItem := BankAccount.GETFILTER("Date Filter");
        EVALUATE(ReportDate, DateFilterItem);

        if DateFilterItem = '' then
            Error('Date Filter Can not be Empty');
    end;

}
report 50026 "Standard Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StandardTrialBalance.rdlc';
    AdditionalSearchTerms = 'year closing,close accounting period,close fiscal year';
    ApplicationArea = Basic, Suite;
    Caption = 'Standard Trial Balance';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            RequestFilterFields = "Date Filter";
            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_Address_2; CompanyInfo."Address 2") { }
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_Phone_No_; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_E_Mail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            Column(No_BalanceSheet; GLAccount."No.") { }
            Column(Name_BalanceSheet; GLAccount.Name) { }
            Column(DebitBalance; DebitBalance) { }
            Column(CreditBalance; CreditBalance) { }
            Column(EndingDate; EndingDate) { }

            trigger OnPreDataItem()
            begin
                //GLAccount.SETRANGE("Date Filter", 0D, EndingDate);
            end;

            trigger OnAfterGetRecord()
            begin
                DebitBalance := 0;
                CreditBalance := 0;
                IF (GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Balance Sheet") THEN BEGIN
                    CALCFIELDS("Balance at Date");
                    IF "Balance at Date" > 0 THEN BEGIN
                        DebitBalance := "Balance at Date";
                        CreditBalance := 0;
                    END ELSE BEGIN
                        DebitBalance := 0;
                        CreditBalance := -"Balance at Date";
                    END;
                END ELSE BEGIN
                    CALCFIELDS("Net Change");
                    IF "Net Change" > 0 THEN BEGIN
                        DebitBalance := "Net Change";
                        CreditBalance := 0;
                    END ELSE BEGIN
                        DebitBalance := 0;
                        CreditBalance := -"Net Change";
                    END;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(Options)
                {

                }
            }
        }

        actions
        {

        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        EndingDate := GLAccount.GetFilter("Date Filter");
    end;

    var

        DebitBalance: Decimal;
        CreditBalance: Decimal;
        TotalDebitBalance: Decimal;
        TotalCreditBalance: Decimal;
        EndingDate: Text[50];
        StartingDate: Date;
        DebitChange: Decimal;
        CreditChange: Decimal;
        TotalDebitChange: Decimal;
        TotalCreditChange: Decimal;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        Debit: Decimal;
        Credit: Decimal;
        GLobalGLAccount: Record "G/L Account";
        CompanyInfo: Record "Company Information";
}


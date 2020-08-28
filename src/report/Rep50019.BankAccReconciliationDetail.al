report 50019 "Bank Acc Reconciliation Detail"
{
    Caption = 'Bank Account Reconciliation Detailed Report';
    DefaultLayout = RDLC;
    RDLCLayout = './BankAccReconciliationDetailed.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_Address_2; CompanyInfo."Address 2") { }
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_Phone_No_; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_E_Mail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            Column(BankAccountNo_BankAccReconciliation; "Bank Acc. Reconciliation"."Bank Account No.") { }
            Column(StatementNo_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement No.") { }
            Column(StatementEndingBalance_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement Ending Balance") { }
            Column(StatementDate; "Bank Acc. Reconciliation"."Statement Date") { }
            Column(BalanceLastStatement_BankAccReconciliation; "Bank Acc. Reconciliation"."Balance Last Statement") { }
            Column(BankStatement_BankAccReconciliation; "Bank Acc. Reconciliation"."Bank Statement") { }
            Column(TotalBalanceonBankAccount_BankAccReconciliation; "Bank Acc. Reconciliation"."Total Balance on Bank Account") { }
            Column(TotalAppliedAmount_BankAccReconciliation; "Bank Acc. Reconciliation"."Total Applied Amount") { }
            Column(TotalTransactionAmount_BankAccReconciliation; "Bank Acc. Reconciliation"."Total Transaction Amount") { }
            Column(StatementType_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement Type") { }
            Column(PreviousUnclearedDifference_BankAccReconciliation; "Bank Acc. Reconciliation"."Previous Uncleared Difference") { }
            Column(Print; Print) { }
            Column(CheckPrinting; CheckPrinting) { }
            Column(DepositPrinting; DepositPrinting) { }
            Column(DifferencePrinting; DifferencePrinting) { }
            Column(OutstandingCheckPrinting; OutstandingCheckPrinting) { }
            Column(OutstandingDepositPrinting; OutstandingDepositPrinting) { }
            Column(CashBookBalance; CashBookBalance) { }
            Column(CashBookBalanceLCY; CashBookBalanceLCY) { }
            Column(UnpresentedCheques; UnpresentedCheques) { }
            Column(UncreditedCheques; UncreditedCheques) { }
            Column(UnreconciledDirectCredits; UnreconciledDirectCredits) { }
            Column(UnreconciledOtherDebits; UnreconciledOtherDebits) { }
            Column(PreviousUnclearedDifference; PreviousUnclearedDifference) { }
            Column(ErrorMessage1; ErrorMessage1) { }
            Column(BeginningBalance; BeginningBalance) { }
            Column(Receipts; Receipts) { }
            Column(Disbursements; Disbursements) { }
            Column(BankAccountNumber; BankAccountNumber) { }
            Column(BankAccountNumber1; BankAccountNumber1) { }
            Column(BankAccountName; BankAccountName) { }

            //Checks
            dataitem(Checks; "Bank Account Ledger Entry")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                Column(PostingDate_Checks; Checks."Posting Date") { }
                Column(DocumentNo_Checks; Checks."Document No.") { }
                Column(ExternalDocumentNo_Checks; Checks."External Document No.") { }
                Column(Description_Checks; Checks.Description) { }
                Column(Amount_Checks; Checks.Amount) { }
                Column(RemainingAmount_Checks; Checks."Remaining Amount") { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    Checks.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                    Checks.SETRANGE("Statement Status", Checks."Statement Status"::"Bank Acc. Entry Applied", Checks."Statement Status"::Closed);
                    //Checks.SETRANGE(Reversed, FALSE);
                    Checks.SETFILTER(Amount, '<%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin

                    IF NOT CheckPrinting THEN
                        CurrReport.SKIP;

                    //IF (Checks."Posting Date" = DMY2DATE(1,1,1)) THEN
                    //  CurrReport.SKIP;
                    IF NOT Checks.IsApplied THEN
                        CurrReport.SKIP;
                end;
            }

            //Deposits
            dataitem(Deposits; "Bank Account Ledger Entry")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");

                Column(PostingDate_Deposits; Deposits."Posting Date") { }
                Column(DocumentNo_Deposits; Deposits."Document No.") { }
                Column(ExternalDocumentNo_Deposits; Deposits."External Document No.") { }
                Column(Description_Deposits; Deposits.Description) { }
                Column(Amount_Deposits; Deposits.Amount) { }
                Column(RemainingAmount_Deposits; Deposits."Remaining Amount") { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    Deposits.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                    Deposits.SETRANGE("Statement Status", Deposits."Statement Status"::"Bank Acc. Entry Applied", Deposits."Statement Status"::Closed);
                    //Deposits.SETRANGE(Reversed, FALSE);
                    Deposits.SETFILTER(Amount, '>%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT DepositPrinting THEN
                        CurrReport.SKIP;

                    //IF (Deposits."Posting Date" = DMY2DATE(1,1,1)) THEN
                    //  CurrReport.SKIP;

                    IF NOT Deposits.IsApplied THEN
                        CurrReport.SKIP;
                end;
            }

            //PositiveDifferences
            dataitem(PositiveDifferences; "Bank Acc. Reconciliation Line")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");

                Column(TransactionDate_PositiveDifferences; PositiveDifferences."Transaction Date") { }
                Column(DocumentNo_PositiveDifferences; PositiveDifferences."Document No.") { }
                Column(Description_PositiveDifferences; PositiveDifferences.Description) { }
                Column(StatementAmount_PositiveDifferences; PositiveDifferences."Statement Amount") { }
                Column(AppliedAmount_PositiveDifferences; PositiveDifferences."Applied Amount") { }
                Column(Difference_PositiveDifferences; PositiveDifferences.Difference) { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    PositiveDifferences.SETRANGE(Type, PositiveDifferences.Type::Difference);
                    PositiveDifferences.SETRANGE("Statement Type 2", PositiveDifferences."Statement Type 2"::"Bank Reconciliation");
                    PositiveDifferences.SETFILTER("Statement Amount", '>%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT DifferencePrinting THEN
                        CurrReport.SKIP;

                    //IF (PositiveDifferences."Transaction Date" = DMY2DATE(1,1,1)) THEN
                    //  CurrReport.SKIP;
                end;
            }

            //NegativeDifferences
            dataitem(NegativeDifferences; "Bank Acc. Reconciliation Line")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");
                Column(TransactionDate_NegativeDifferences; NegativeDifferences."Transaction Date") { }
                Column(DocumentNo_NegativeDifferences; NegativeDifferences."Document No.") { }
                Column(Description_NegativeDifferences; NegativeDifferences.Description) { }
                Column(StatementAmount_NegativeDifferences; NegativeDifferences."Statement Amount") { }
                Column(AppliedAmount_NegativeDifferences; NegativeDifferences."Applied Amount") { }
                Column(Difference_NegativeDifferences; NegativeDifferences.Difference) { }

                trigger OnPreDataItem()
                begin
                    NegativeDifferences.SETRANGE(Type, NegativeDifferences.Type::Difference);
                    NegativeDifferences.SETRANGE("Statement Type 2", NegativeDifferences."Statement Type 2"::"Bank Reconciliation");
                    NegativeDifferences.SETFILTER("Statement Amount", '<%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT DifferencePrinting THEN
                        CurrReport.SKIP;

                    //IF (NegativeDifferences."Transaction Date" = DMY2DATE(1,1,1)) THEN
                    //  CurrReport.SKIP;
                end;
            }

            //OutstandingChecks
            dataitem(OutstandingChecks; "Bank Account Ledger Entry")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                Column(PostingDate_OutstandingChecks; OutstandingChecks."Posting Date") { }
                Column(DocumentNo_OutstandingChecks; OutstandingChecks."Document No.") { }
                Column(ExternalDocumentNo_OutstandingChecks; OutstandingChecks."External Document No.") { }
                Column(Description_OutstandingChecks; OutstandingChecks.Description) { }
                Column(Amount_OutstandingChecks; OutstandingChecks.Amount) { }
                Column(RemainingAmount_OutstandingChecks; OutstandingChecks."Remaining Amount") { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    OutstandingChecks.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                    OutstandingChecks.SETRANGE("Statement Status", OutstandingChecks."Statement Status"::Open);
                    OutstandingChecks.SETRANGE(Reversed, FALSE);
                    OutstandingChecks.SETFILTER(Amount, '<%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT OutstandingCheckPrinting THEN
                        CurrReport.SKIP;

                    //IF (OutstandingChecks."Posting Date" = DMY2DATE(1,1,1)) THEN
                    //  CurrReport.SKIP;
                    IF OutstandingChecks.IsApplied THEN
                        CurrReport.SKIP;
                end;
            }

            //OutstandingDeposits
            dataitem(OutstandingDeposits; "Bank Account Ledger Entry")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");

                Column(PostingDate_OutstandingDeposits; OutstandingDeposits."Posting Date") { }
                Column(DocumentNo_OutstandingDeposits; OutstandingDeposits."Document No.") { }
                Column(ExternalDocumentNo_OutstandingDeposits; OutstandingDeposits."External Document No.") { }
                Column(Description_OutstandingDeposits; OutstandingDeposits.Description) { }
                Column(Amount_OutstandingDeposits; OutstandingDeposits.Amount) { }
                Column(RemainingAmount_OutstandingDeposits; OutstandingDeposits."Remaining Amount") { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    OutstandingDeposits.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                    OutstandingDeposits.SETRANGE("Statement Status", OutstandingDeposits."Statement Status"::Open);
                    OutstandingDeposits.SETRANGE(Reversed, FALSE);
                    OutstandingDeposits.SETFILTER(Amount, '>%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT OutstandingDepositPrinting THEN
                        CurrReport.SKIP;

                    //IF (OutstandingDeposits."Posting Date" = DMY2DATE(1,1,1)) THEN
                    //  CurrReport.SKIP;

                    IF OutstandingDeposits.IsApplied THEN
                        CurrReport.SKIP;
                end;
            }

            //Bank Acc. Reconciliation Line
            dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");

                Column(BankAccountNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Bank Account No.") { }
                Column(StatementNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Statement No.") { }
                Column(StatementLineNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Statement Line No.") { }
                Column(DocumentNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Document No.") { }
                Column(TransactionDate_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Transaction Date") { }
                Column(Description_BankAccReconciliationLine; "Bank Acc. Reconciliation Line".Description) { }
                Column(StatementAmount_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Statement Amount") { }
                Column(Difference_BankAccReconciliationLine; "Bank Acc. Reconciliation Line".Difference) { }
                Column(AppliedAmount_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Applied Amount") { }
                Column(ExternalDocumentNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."External Document No.") { }
                Column(ExternalDocNo; ExternalDocNo) { }
            }

            //OutstandingChecksDeposits
            dataitem(OutstandingChecksDeposits; "Bank Account Ledger Entry")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                Column(ExternalDocumentNo_OutstandingChecksDeposits; OutstandingChecksDeposits."External Document No.") { }
                Column(PostingDate_OutstandingChecksDeposits; OutstandingChecksDeposits."Posting Date") { }
                Column(DocumentNo_OutstandingChecksDeposits; OutstandingChecksDeposits."Document No.") { }
                Column(Description_OutstandingChecksDeposits; OutstandingChecksDeposits.Description) { }
                Column(Amount_OutstandingChecksDeposits; OutstandingChecksDeposits.Amount) { }
                Column(RemainingAmount_OutstandingChecksDeposits; OutstandingChecksDeposits."Remaining Amount") { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    OutstandingChecksDeposits.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                    OutstandingChecksDeposits.SETRANGE("Statement Status", OutstandingChecksDeposits."Statement Status"::Open);
                    OutstandingChecksDeposits.SETRANGE(Reversed, FALSE);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT OutstandingCheckPrinting THEN
                        CurrReport.SKIP;

                    //IF (OutstandingChecks."Posting Date" = DMY2DATE(1,1,1)) THEN
                    //  CurrReport.SKIP;

                    IF OutstandingChecks.IsApplied THEN
                        CurrReport.SKIP;
                end;
            }


            //OnPreDataItem
            trigger OnPreDataItem()
            var
                BankAccount5: Record "Bank Account";
            begin

                IF (BankAccountNumber <> '') THEN BEGIN
                    IF BankAccount3.GET(BankAccountNumber) THEN
                        BankAccountName := BankAccount3.Name;
                    BankAccountNumber1 := BankAccount3."Bank Account No.";
                    "Bank Acc. Reconciliation".SETRANGE("Bank Acc. Reconciliation"."Bank Account No.", BankAccountNumber);
                END;
                IF (StatementNumber <> '') THEN
                    "Bank Acc. Reconciliation".SETRANGE("Bank Acc. Reconciliation"."Statement No.", StatementNumber);

                CashBookBalance := 0;
                CashBookBalanceLCY := 0;
                UnpresentedCheques := 0;
                UncreditedCheques := 0;
                UnreconciledDirectCredits := 0;
                UnreconciledOtherDebits := 0;
                PreviousUnclearedDifference := 0;
                //Getting Bank Account Name
                BankAccount3.RESET;
                BankAccount3.SETRANGE(BankAccount3."No.", "Bank Acc. Reconciliation"."Bank Account No.");
                IF BankAccount3.FINDFIRST THEN BEGIN
                    BankAccountName := BankAccount3.Name;
                    //Getting Bank Account Name
                END;

                //Getting the bank account No for a bank
                BankAccount5.RESET;
                BankAccount5.SETRANGE(BankAccount5."No.", "Bank Acc. Reconciliation"."Bank Account No.");
                IF BankAccount5.FINDFIRST THEN
                    BankAccountNumber1 := BankAccount5."Bank Account No.";

                //Getting the bank account No for a bank
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                IF BankAccount.GET("Bank Acc. Reconciliation"."Bank Account No.") THEN BEGIN
                    BankAccount.SETRANGE("Date Filter", "Bank Acc. Reconciliation"."Statement Date");
                    BankAccount.CALCFIELDS("Balance at Date", "Balance at Date (LCY)");
                    CashBookBalance := BankAccount."Balance at Date";
                    CashBookBalanceLCY := BankAccount."Balance at Date (LCY)";
                END;

                // Calculate the beginning bank balance for the month
                IF BankAccount2.GET("Bank Acc. Reconciliation"."Bank Account No.") THEN BEGIN
                    BankAccount2.SETRANGE("Date Filter", CALCDATE('-CM - 1D', "Bank Acc. Reconciliation"."Statement Date"));
                    BankAccount2.CALCFIELDS("Balance at Date", "Balance at Date (LCY)");
                    BeginningBalance := BankAccount2."Balance at Date";
                END;
                // Calculate the Receipts and Disbursements (Payments) within the period of reconciliation [1st of the month to end of the month]
                IF BankAccount2.GET("Bank Acc. Reconciliation"."Bank Account No.") THEN BEGIN
                    BankAccount2.SETRANGE("Date Filter", CALCDATE('-CM', "Bank Acc. Reconciliation"."Statement Date"),
                                          "Bank Acc. Reconciliation"."Statement Date");
                    BankAccount2.CALCFIELDS("Debit Amount", "Credit Amount");
                    Receipts := BankAccount2."Debit Amount";
                    Disbursements := -BankAccount2."Credit Amount";
                END;

                ReconciliationLine2.RESET;
                ReconciliationLine2.SETRANGE("Statement Type 2", ReconciliationLine2."Statement Type 2"::"Posted Bank Reconciliation");
                ReconciliationLine2.SETRANGE(ReconciliationLine2."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                ReconciliationLine2.SETFILTER(ReconciliationLine2."Statement No.", '<>%1', "Bank Acc. Reconciliation"."Statement No.");
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Type, ReconciliationLine2.Type::Difference);
                ReconciliationLine2.SETFILTER(ReconciliationLine2."Transaction Date", '<=%1', "Bank Acc. Reconciliation"."Statement Date");
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Cleared, FALSE);
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Clear, FALSE);
                IF ReconciliationLine2.FINDFIRST THEN
                    REPEAT
                        PreviousUnclearedDifferences1 += ReconciliationLine2."Statement Amount";
                    UNTIL ReconciliationLine2.NEXT = 0;

                ReconciliationLine2.RESET;
                ReconciliationLine2.SETRANGE("Statement Type 2", ReconciliationLine2."Statement Type 2"::"Posted Bank Reconciliation");
                ReconciliationLine2.SETRANGE(ReconciliationLine2."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                ReconciliationLine2.SETFILTER(ReconciliationLine2."Statement No.", '<>%1', "Bank Acc. Reconciliation"."Statement No.");
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Type, ReconciliationLine2.Type::Difference);
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Cleared, TRUE);
                ReconciliationLine2.SETFILTER(ReconciliationLine2."Cleared Date", '<=%1', "Bank Acc. Reconciliation"."Statement Date");
                IF ReconciliationLine2.FINDFIRST THEN
                    REPEAT
                        PreviousUnclearedDifferences2 += ReconciliationLine2."Statement Amount";
                    UNTIL ReconciliationLine2.NEXT = 0;
                PreviousUnclearedDifference := PreviousUnclearedDifferences1 + PreviousUnclearedDifferences2;

                DepositCheck.RESET;
                DepositCheck.SETRANGE(DepositCheck."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                DepositCheck.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                DepositCheck.SETRANGE("Statement Status", DepositCheck."Statement Status"::Open);
                DepositCheck.SETRANGE(Reversed, FALSE);
                IF DepositCheck.FINDFIRST THEN
                    REPEAT
                        IF (DepositCheck.Amount < 0) THEN
                            UnpresentedCheques += DepositCheck.Amount
                        ELSE
                            IF (DepositCheck.Amount > 0) THEN
                                UncreditedCheques += DepositCheck.Amount;
                    UNTIL DepositCheck.NEXT = 0;

                PositiveNegativeDifference.RESET;
                PositiveNegativeDifference.SETRANGE("Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                PositiveNegativeDifference.SETRANGE("Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                PositiveNegativeDifference.SETRANGE(Type, PositiveNegativeDifference.Type::Difference);
                PositiveNegativeDifference.SETRANGE("Statement Type 2", PositiveNegativeDifference."Statement Type 2"::"Bank Reconciliation");
                IF PositiveNegativeDifference.FINDFIRST THEN
                    REPEAT
                        IF (PositiveNegativeDifference."Statement Amount" < 0) THEN
                            UnreconciledDirectCredits += PositiveNegativeDifference."Statement Amount"
                        ELSE
                            IF (PositiveNegativeDifference."Statement Amount" > 0) THEN
                                UnreconciledOtherDebits += PositiveNegativeDifference."Statement Amount";
                    UNTIL PositiveNegativeDifference.NEXT = 0;

                EndingBalance := (("Bank Acc. Reconciliation"."Statement Ending Balance" + UnpresentedCheques + UncreditedCheques) -
                                  (UnreconciledDirectCredits + UnreconciledOtherDebits) -
                                 (PreviousUnclearedDifferences1 + PreviousUnclearedDifferences2));

                IF ((EndingBalance - CashBookBalance) <> 0) THEN
                    ErrorMessage1 := ASLT0001 + ' ' + FORMAT(EndingBalance - CashBookBalance)
                //"Bank Acc. Reconciliation".CALCFIELDS("Bank Acc. Reconciliation"."Previous Uncleared Difference");

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
        Print: Boolean;
        CheckPrinting: Boolean;
        DepositPrinting: Boolean;
        DifferencePrinting: Boolean;
        OutstandingCheckPrinting: Boolean;
        OutstandingDepositPrinting: Boolean;
        BankAccount: Record "Bank Account";
        BankAccount2: Record "Bank Account";
        BeginningBalance: Decimal;
        Receipts: Decimal;
        Disbursements: Decimal;
        DepositCheck: Record "Bank Account Ledger Entry";
        PositiveNegativeDifference: Record "Bank Acc. Reconciliation Line";
        ReconciliationLine1: Record "Bank Acc. Reconciliation Line";
        ReconciliationLine2: Record "Bank Acc. Reconciliation Line";
        CashBookBalance: Decimal;
        CashBookBalanceLCY: Decimal;
        ReconciledDirectCredits: Decimal;
        ReconciledDirectDebits: Decimal;
        ReconciledOtherDebits: Decimal;
        EndingGLBalance: Decimal;
        Difference: Decimal;
        UnpresentedCheques: Decimal;
        UncreditedCheques: Decimal;
        UnreconciledDirectCredits: Decimal;
        UnreconciledOtherDebits: Decimal;
        EndingBalance: Decimal;
        UnclearedDifferences: Decimal;
        BankAccountNumber: Code[20];
        StatementNumber: Code[20];
        PostedBankAccountReconciliation: Record "Bank Acc. Reconciliation";
        PreviousUnclearedDifference: Decimal;
        PreviousUnclearedDifferences1: Decimal;
        PreviousUnclearedDifferences2: Decimal;
        ErrorMessage1: Text[250];
        BankAccountName: Text[50];
        BankAccount3: Record "Bank Account";
        ExternalDocNo: Code[20];
        BankAccountNumber1: Code[30];
        ASLT0001: Label 'The reconciliation cannot post because there is a difference of';

    //triggers
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        OutstandingCheckPrinting := TRUE;
    end;

    //functions
    procedure SetDefaults(BankAccountNo: Code[20]; StatementNo: Code[20])
    begin
        IF (BankAccountNo <> '') THEN
            BankAccountNumber := BankAccountNo;
        IF (StatementNo <> '') THEN
            StatementNumber := StatementNo;
    end;
}
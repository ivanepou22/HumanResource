report 50021 "Posted Bank Acc Recon Detail"
{
    Caption = 'Bank Account Reconciliation Detail';
    DefaultLayout = RDLC;
    RDLCLayout = './PostedBankAccReconciliationDetailed.rdlc';
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
            Column(PostedUnclearedDifference_BankAccReconciliation; "Bank Acc. Reconciliation"."Posted Uncleared Difference") { }
            Column(PostedUncreditedDesposits_BankAccReconciliation; "Bank Acc. Reconciliation"."Posted Uncredited Desposits") { }
            column(Posted_Prev__Uncleared_Diff_; "Posted Prev. Uncleared Diff." - "Posted Uncleared Difference") { }
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
            Column(BeginningBalance; BeginningBalance) { }
            Column(Receipts; Receipts) { }
            Column(Disbursements; Disbursements) { }
            Column(BankAccountName; BankAccountName) { }
            Column(BankAccountNo; "BankAccountNo.") { }

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
                begin
                    Checks.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                    Checks.SETRANGE(Status, Checks.Status::"Closed by Current Stmt.");
                    //Checks.SETRANGE(Reversed, FALSE);
                    Checks.SETFILTER(Amount, '<%1', 0);
                end;

                trigger OnAfterGetRecord()
                begin
                    IF NOT CheckPrinting THEN
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
                    Deposits.SETRANGE(Status, Deposits.Status::"Closed by Current Stmt.");
                    //Deposits.SETRANGE(Reversed, FALSE);
                    Deposits.SETFILTER(Amount, '>%1', 0);
                end;

                trigger OnAfterGetRecord()
                begin
                    IF NOT DepositPrinting THEN
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
                    PositiveDifferences.SETRANGE("Statement Type", PositiveDifferences."Statement Type"::"Payment Application");
                    PositiveDifferences.SETFILTER("Statement Amount", '>%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT DifferencePrinting THEN
                        CurrReport.SKIP;
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
                var
                    myInt: Integer;
                begin
                    NegativeDifferences.SETRANGE(Type, NegativeDifferences.Type::Difference);
                    NegativeDifferences.SETRANGE("Statement Type", NegativeDifferences."Statement Type"::"Payment Application");
                    NegativeDifferences.SETFILTER("Statement Amount", '<%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT DifferencePrinting THEN
                        CurrReport.SKIP;
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
                    //OutstandingChecks.SETRANGE(Status, OutstandingChecks.Status::Open, OutstandingChecks.Status::"Closed by Future Stmt.");
                    OutstandingChecks.SETFILTER("Open-to Date", '>%1', StatementDate);
                    OutstandingChecks.SETRANGE(Reversed, FALSE);
                    OutstandingChecks.SETFILTER(Amount, '<>%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT OutstandingCheckPrinting THEN
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
                    //OutstandingDeposits.SETRANGE(Status, OutstandingDeposits.Status::Open, OutstandingDeposits.Status::"Closed by Future Stmt.");
                    OutstandingDeposits.SETFILTER("Open-to Date", '>%1', StatementDate);
                    OutstandingDeposits.SETRANGE(Reversed, FALSE);
                    OutstandingDeposits.SETFILTER(Amount, '>%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT OutstandingDepositPrinting THEN
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
                Column(ExternalDocNo; ExternalDocNo) { }

                //Bank Account Ledger Entry
                // dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
                // {
                //     DataItemLinkReference = "Bank Acc. Reconciliation Line";
                //     DataItemLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No."), "Statement Line No." = FIELD("Statement Line No.");
                //     Column(ExternalDocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."External Document No.") { }
                // }


                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    "Bank Acc. Reconciliation Line".SetRange("Statement Type 2", "Bank Acc. Reconciliation Line"."Statement Type 2"::"Bank Reconciliation");
                end;
            }

            //OutstandingCheckReal
            dataitem(OutstandingCheckReal; "Bank Account Ledger Entry")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                Column(ExternalDocumentNo_OutstandingCheckReal; OutstandingCheckReal."External Document No.") { }
                Column(PostingDate_OutstandingCheckReal; OutstandingCheckReal."Posting Date") { }
                Column(DocumentNo_OutstandingCheckReal; OutstandingCheckReal."Document No.") { }
                Column(Description_OutstandingCheckReal; OutstandingCheckReal.Description) { }
                Column(Amount_OutstandingCheckReal; OutstandingCheckReal.Amount) { }
                Column(RemainingAmount_OutstandingCheckReal; OutstandingCheckReal."Remaining Amount") { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    OutstandingCheckReal.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                    //OutstandingChecks.SETRANGE(Status, OutstandingChecks.Status::Open, OutstandingChecks.Status::"Closed by Future Stmt.");
                    OutstandingCheckReal.SETFILTER("Open-to Date", '>%1', StatementDate);
                    OutstandingCheckReal.SETRANGE(Reversed, FALSE);
                    OutstandingCheckReal.SETFILTER(Amount, '<%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT OutstandingCheckPrinting THEN
                        CurrReport.SKIP;
                end;
            }

            //Uncredited checks
            dataitem(UnCreditedChecks; "Bank Account Ledger Entry")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                Column(ExternalDocumentNo_UnCreditedChecks; UnCreditedChecks."External Document No.") { }
                Column(PostingDate_UnCreditedChecks; UnCreditedChecks."Posting Date") { }
                Column(DocumentNo_UnCreditedChecks; UnCreditedChecks."Document No.") { }
                Column(Description_UnCreditedChecks; UnCreditedChecks.Description) { }
                Column(Amount_UnCreditedChecks; UnCreditedChecks.Amount) { }
                Column(RemainingAmount_UnCreditedChecks; UnCreditedChecks."Remaining Amount") { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    UnCreditedChecks.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                    UnCreditedChecks.SETFILTER("Open-to Date", '>%1', StatementDate);
                    UnCreditedChecks.SETRANGE(Reversed, FALSE);
                    UnCreditedChecks.SETFILTER(Amount, '>%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF NOT OutstandingCheckPrinting THEN
                        CurrReport.SKIP;
                end;
            }

            //=============================================================
            //Bank Acc. Reconciliation Line
            dataitem(PrevDifferenceUncleared; "Bank Acc. Reconciliation Line")
            {
                DataItemLinkReference = "Bank Acc. Reconciliation";
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");

                Column(BankAccountNo_PrevDifferenceUncleared; PrevDifferenceUncleared."Bank Account No.") { }
                Column(StatementNo_PrevDifferenceUncleared; PrevDifferenceUncleared."Statement No.") { }
                Column(StatementLineNo_PrevDifferenceUncleared; PrevDifferenceUncleared."Statement Line No.") { }
                Column(DocumentNo_PrevDifferenceUncleared; PrevDifferenceUncleared."Document No.") { }
                Column(TransactionDate_PrevDifferenceUncleared; PrevDifferenceUncleared."Transaction Date") { }
                Column(Description_PrevDifferenceUncleared; PrevDifferenceUncleared.Description) { }
                Column(StatementAmount_PrevDifferenceUncleared; PrevDifferenceUncleared."Statement Amount") { }
                Column(Difference_PrevDifferenceUncleared; PrevDifferenceUncleared.Difference) { }
                Column(AppliedAmount_PrevDifferenceUncleared; PrevDifferenceUncleared."Applied Amount") { }

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    PrevDifferenceUncleared.SetRange("Statement Type", PrevDifferenceUncleared."Statement Type"::"Payment Application");
                    PrevDifferenceUncleared.SetFilter("Transaction Date", '<%1', "Bank Acc. Reconciliation"."Statement Date");
                    PrevDifferenceUncleared.SetRange(Type, PrevDifferenceUncleared.Type::Difference);
                    PrevDifferenceUncleared.SetRange(PrevDifferenceUncleared.Cleared, false);
                    PrevDifferenceUncleared.SetFilter(PrevDifferenceUncleared."Statement No.", '<>%1', "Bank Acc. Reconciliation"."Statement No.");
                end;
            }
            //=============================================================

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF (BankAccountNumber <> '') THEN BEGIN
                    IF BankAccount3.GET(BankAccountNumber) THEN
                        BankAccountName := BankAccount3.Name;
                    "BankAccountNo." := BankAccount3."Bank Account No.";
                    "Bank Acc. Reconciliation".SETRANGE("Bank Acc. Reconciliation"."Bank Account No.", BankAccountNumber);
                END;
                IF (StatementNumber <> '') THEN
                    "Bank Acc. Reconciliation".SETRANGE("Bank Acc. Reconciliation"."Statement No.", StatementNumber);

                CashBookBalance := 0.00;
                CashBookBalanceLCY := 0.00;
                UnpresentedCheques := 0.00;
                UncreditedCheques := 0;
                UnreconciledDirectCredits := 0.00;
                UnreconciledOtherDebits := 0.00;
                PreviousUnclearedDifference := 0.00;
                PreviousUnclearedDifferences1 := 0.00;
                PreviousUnclearedDifferences2 := 0.00;
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
                ReconciliationLine2.SETRANGE("Statement Type", ReconciliationLine2."Statement Type"::"Payment Application");
                ReconciliationLine2.SETRANGE(ReconciliationLine2."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                ReconciliationLine2.SETFILTER(ReconciliationLine2."Statement No.", '<>%1', "Bank Acc. Reconciliation"."Statement No.");
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Type, ReconciliationLine2.Type::Difference);
                ReconciliationLine2.SETFILTER(ReconciliationLine2."Transaction Date", '<=%1', "Bank Acc. Reconciliation"."Statement Date");
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Cleared, FALSE);
                IF ReconciliationLine2.FINDFIRST THEN
                    REPEAT
                        PreviousUnclearedDifferences1 += ReconciliationLine2."Statement Amount";
                    UNTIL ReconciliationLine2.NEXT = 0;

                ReconciliationLine2.RESET;
                ReconciliationLine2.SETRANGE("Statement Type", ReconciliationLine2."Statement Type"::"Payment Application");
                ReconciliationLine2.SETRANGE(ReconciliationLine2."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                ReconciliationLine2.SETFILTER(ReconciliationLine2."Statement No.", '<>%1', "Bank Acc. Reconciliation"."Statement No.");
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Type, ReconciliationLine2.Type::Difference);
                ReconciliationLine2.SETRANGE(ReconciliationLine2.Cleared, TRUE);
                ReconciliationLine2.SETFILTER(ReconciliationLine2."Cleared Date", '<%1', "Bank Acc. Reconciliation"."Statement Date");
                IF ReconciliationLine2.FINDFIRST THEN
                    REPEAT
                        PreviousUnclearedDifferences2 += ReconciliationLine2."Statement Amount";
                    UNTIL ReconciliationLine2.NEXT = 0;
                PreviousUnclearedDifference := PreviousUnclearedDifferences1 + PreviousUnclearedDifferences2;

                DepositCheck.RESET;
                DepositCheck.SETRANGE(DepositCheck."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                DepositCheck.SETFILTER("Posting Date", '..%1', "Bank Acc. Reconciliation"."Statement Date");
                DepositCheck.SETRANGE(Status, DepositCheck.Status::Open, DepositCheck.Status::"Closed by Future Stmt.");
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
                PositiveNegativeDifference.SETRANGE("Statement Type", PositiveNegativeDifference."Statement Type"::"Payment Application");
                IF PositiveNegativeDifference.FINDFIRST THEN
                    REPEAT
                        IF (PositiveNegativeDifference."Statement Amount" < 0) THEN
                            UnreconciledDirectCredits += PositiveNegativeDifference."Statement Amount"
                        ELSE
                            IF (PositiveNegativeDifference."Statement Amount" > 0) THEN
                                UnreconciledOtherDebits += PositiveNegativeDifference."Statement Amount";
                    UNTIL PositiveNegativeDifference.NEXT = 0;

                StatementDate := "Bank Acc. Reconciliation"."Statement Date";
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
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        BankReconLines2: Record "Bank Acc. Reconciliation Line";
        PositiveNegativeDifference: Record "Bank Acc. Reconciliation Line";
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
        PreviousUnclearedDifference: Decimal;
        PreviousUnclearedDifferences1: Decimal;
        PreviousUnclearedDifferences2: Decimal;
        StatementDate: Date;
        BankAccountName: Text[50];
        BankAccount3: Record "Bank Account";
        ExternalDocNo: Code[20];
        "BankAccountNo.": Code[30];

    //Triggers
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
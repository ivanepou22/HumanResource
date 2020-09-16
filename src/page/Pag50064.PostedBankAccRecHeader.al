page 50064 "Posted Bank Acc Rec. Header"
{
    PageType = Document;
    Caption = 'Posted Bank Account Reconciliation';
    SourceTable = "Bank Acc. Reconciliation";
    SourceTableView = WHERE("Statement Type" = CONST("Payment Application"));
    DelayedInsert = false;
    Editable = false;
    SaveValues = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                Field("Statement No."; "Statement No.")
                {
                    ApplicationArea = All;
                }
                Field("Statement Date"; "Statement Date")
                {
                    ApplicationArea = All;
                }
                Field("Balance as per Cash Book"; CashBookBalance)
                {
                    ApplicationArea = All;
                }
                Field("Balance as per Cash Book (LCY)"; CashBookBalanceLCY)
                {
                    ApplicationArea = All;
                }
                Field("Balance Last Statement"; "Balance Last Statement")
                {
                    ApplicationArea = All;
                }
                Field("Statement Ending Balance"; "Statement Ending Balance")
                {
                    ApplicationArea = All;
                }
                Field("Outstanding Amount"; OutstandingAmount)
                {
                    ApplicationArea = All;
                }
                Field("Positive/Negative Differences"; PositiveNegativeDifferences)
                {
                    ApplicationArea = All;
                }
                field("Previous Uncleared Difference"; "Previous Uncleared Difference" - PositiveNegativeDifferences)
                {
                    ApplicationArea = All;
                }

                Field("Ending Balance"; EndingBalance)
                {
                    ApplicationArea = All;
                }
            }
            group(Control4)
            {
                ShowCaption = false;
                grid("Bank")
                {
                    ShowCaption = false;
                    group("Statement Lines")
                    {
                        ShowCaption = false;
                        part("Bank Statement Lines"; "Posted Bank Acc. Rec. Lines")
                        {
                            Caption = 'Bank Statement Lines';
                            ApplicationArea = basic, suite;
                            SubPageLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");
                        }

                        field("Unpresented Payments"; "Posted Unpresented Payments")
                        {
                            ApplicationArea = All;
                        }
                        field("Uncredited Deposits"; "Posted Uncredited Desposits")
                        {
                            ApplicationArea = All;
                        }
                    }

                    group("Bank Ledger Entries")
                    {
                        ShowCaption = false;
                        part("Bank Account Ledger Entries"; "Apply Bank Acc. Ledger Entries")
                        {
                            Caption = 'Bank Account Ledger Entries';
                            ApplicationArea = basic, suite;
                            SubPageLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");
                        }

                        field("Previous Uncleared Differences"; "Posted Prev. Uncleared Diff.")
                        {
                            ApplicationArea = All;
                        }
                        Field("Uncleared Differences"; "Posted Uncleared Difference")
                        {
                            ApplicationArea = All;
                        }
                    }
                }

            }
        }

        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action("Posted Bank Acc. Recon Summary Report")
            {
                ApplicationArea = All;
                Caption = 'Bank Account Reconciliation Summary Report';
                Image = Report2;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PostedBankReconSummary: Report "Posted Bank Acc Recon Summary";
                begin
                    Clear(PostedBankReconSummary);
                    PostedBankReconSummary.SetDefaults("Bank Account No.", "Statement No.");
                    PostedBankReconSummary.Run();
                end;
            }

            action("Posted Bank Acc. Recon Detail Report")
            {
                ApplicationArea = All;
                Caption = 'Bank Account Reconciliation Detailed Report';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PostedBankReconDetail: Report "Posted Bank Acc Recon Detail";
                begin
                    Clear(PostedBankReconDetail);
                    PostedBankReconDetail.SetDefaults("Bank Account No.", "Statement No.");
                    PostedBankReconDetail.Run();
                end;
            }
        }
    }

    var
        SuggestBankAccStatement: Report "Suggest Bank Acc. Recon. Lines";
        TransferToGLJnl: Report "Trans. Bank Rec. to Gen. Jnl.";
        ReportPrint: Codeunit "Test Report-Print";
        OutstandingChecks: Decimal;
        OutstandingDeposits: Decimal;
        OutstandingAmount: Decimal;
        PositiveNegativeDifferences: Decimal;
        CashBookBalance: Decimal;
        CashBookBalanceLCY: Decimal;
        EndingBalance: Decimal;
        PostedBankAccountReconciliation: Record "Bank Acc. Reconciliation";
        PreviousUnclearedDifferences1: Decimal;
        PreviousUnclearedDifferences2: Decimal;
        ReconciliationLine1: Record "Bank Acc. Reconciliation Line";
        ReconciliationLine2: Record "Bank Acc. Reconciliation Line";

    //Procedures
    trigger OnModifyRecord(): Boolean
    begin
        CalcOutstandingAmounts();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalcOutstandingAmounts();
    end;
    //Functions
    procedure CalcOutstandingAmounts()
    var
        CashBook: Record "Bank Account Ledger Entry";
        ReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccount: Record "Bank Account";
    begin
        OutstandingChecks := 0;
        OutstandingDeposits := 0;
        OutstandingAmount := 0;
        PositiveNegativeDifferences := 0;
        EndingBalance := 0;
        CashBookBalance := 0;
        CashBookBalanceLCY := 0;
        PreviousUnclearedDifferences1 := 0;
        PreviousUnclearedDifferences2 := 0;
        IF BankAccount.GET("Bank Account No.") THEN BEGIN
            BankAccount.SETRANGE("Date Filter", "Statement Date");
            BankAccount.CALCFIELDS("Balance at Date", "Balance at Date (LCY)");
            CashBookBalance := BankAccount."Balance at Date";
            CashBookBalanceLCY := BankAccount."Balance at Date (LCY)";
        END;
        CashBook.RESET;
        CashBook.SETRANGE(CashBook."Bank Account No.", "Bank Account No.");
        CashBook.SETFILTER("Posting Date", '..%1', "Statement Date");
        CashBook.SETFILTER(CashBook."Open-to Date", '>%1', "Statement Date");
        //CashBook.SETRANGE(Status, CashBook.Status::Open, CashBook.Status::"Closed by Future Stmt.");
        //CashBook.SETRANGE(Reversed, FALSE);
        IF CashBook.FINDFIRST THEN
            REPEAT
                IF (CashBook.Amount < 0) THEN
                    OutstandingChecks += CashBook.Amount
                ELSE
                    IF (CashBook.Amount > 0) THEN
                        OutstandingDeposits += CashBook.Amount;
                OutstandingAmount += CashBook.Amount;
            UNTIL CashBook.NEXT = 0;

        ReconciliationLine2.RESET;
        ReconciliationLine2.SETRANGE("Statement Type", ReconciliationLine2."Statement Type"::"Payment Application");
        ReconciliationLine2.SETRANGE(ReconciliationLine2."Bank Account No.", "Bank Account No.");
        ReconciliationLine2.SETFILTER(ReconciliationLine2."Statement No.", '<>%1', "Statement No.");
        ReconciliationLine2.SETRANGE(ReconciliationLine2.Type, ReconciliationLine2.Type::Difference);
        ReconciliationLine2.SETFILTER(ReconciliationLine2."Transaction Date", '<=%1', "Statement Date");
        ReconciliationLine2.SETRANGE(ReconciliationLine2.Cleared, FALSE);
        IF ReconciliationLine2.FINDFIRST THEN
            REPEAT
                PreviousUnclearedDifferences1 += ReconciliationLine2."Statement Amount";
            UNTIL ReconciliationLine2.NEXT = 0;

        ReconciliationLine2.RESET;
        ReconciliationLine2.SETRANGE("Statement Type", ReconciliationLine2."Statement Type"::"Payment Application");
        ReconciliationLine2.SETRANGE(ReconciliationLine2."Bank Account No.", "Bank Account No.");
        ReconciliationLine2.SETFILTER(ReconciliationLine2."Statement No.", '<>%1', "Statement No.");
        ReconciliationLine2.SETRANGE(ReconciliationLine2.Type, ReconciliationLine2.Type::Difference);
        ReconciliationLine2.SETRANGE(ReconciliationLine2.Cleared, TRUE);
        ReconciliationLine2.SETFILTER(ReconciliationLine2."Cleared Date", '<%1', "Statement Date");
        IF ReconciliationLine2.FINDFIRST THEN
            REPEAT
                PreviousUnclearedDifferences2 += ReconciliationLine2."Statement Amount";
            UNTIL ReconciliationLine2.NEXT = 0;

        ReconciliationLine.RESET;
        ReconciliationLine.SETRANGE("Statement Type", ReconciliationLine."Statement Type"::"Payment Application");
        ReconciliationLine.SETRANGE(ReconciliationLine."Bank Account No.", "Bank Account No.");
        ReconciliationLine.SETRANGE(ReconciliationLine."Statement No.", "Statement No.");
        ReconciliationLine.SETRANGE(ReconciliationLine.Type, ReconciliationLine.Type::Difference);
        IF ReconciliationLine.FINDFIRST THEN
            REPEAT
                PositiveNegativeDifferences += ReconciliationLine.Difference;
            UNTIL ReconciliationLine.NEXT = 0;
        CALCFIELDS("Previous Uncleared Difference");
        EndingBalance := "Statement Ending Balance" + OutstandingAmount - PositiveNegativeDifferences
                          - (PreviousUnclearedDifferences1 + PreviousUnclearedDifferences2);
    end;
}
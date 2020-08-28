pageextension 50058 "Bank Acc. Reconciliation Ext" extends "Bank Acc. Reconciliation" //379
{
    layout
    {
        // Add changes to page layout here
        addafter(StatementDate)
        {
            Field("Balance as per Cash Book"; CashBookBalance) { }
            Field("Baance as per Cash Book (LCY)"; CashBookBalanceLCY) { }
        }

        addafter(StatementEndingBalance)
        {
            Field("Outstanding Amount"; OutstandingAmount) { }
            Field("Positive/Negative Differences"; PositiveNegativeDifferences) { }
            Field("Ending Balance"; EndingBalance) { }
        }

        addafter(Control8)
        {
            group(control100)
            {
                Caption = 'Clear Difference';
                part(DifferenceLine; "Bank Acc. Recon. Diff")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Difference Bank Statement Lines';
                    SubPageLink = "Bank Account No." = FIELD("Bank Account No."),
                                  Cleared = const(false);
                }
                part(ClearDiffBankLedgerEntries; "Apply Bank Acc. Ledger Entry")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account Ledger Entries';
                    SubPageLink = "Bank Account No." = field("Bank Account No."),
                                  Open = const(true),
                                  "Statement Status" = filter(Open | "Bank Acc. Entry Applied" | "Check Entry Applied"),
                                  Reversed = filter(false);
                }
            }
        }


    }

    actions
    {
        // Add changes to page actions here
        modify(ImportBankStatement)
        {
            Visible = false;
            Enabled = false;
        }

        addfirst("Ba&nk")
        {
            action("Import Bank Statement")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Bank Statement';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Import electronic bank statements from your bank to populate with data about actual bank transactions.';
                RunObject = xmlport "Import Bank Acc. Stmnt Lines";
            }
        }

        modify(Post)
        {
            Visible = false;
            Enabled = false;
        }
        modify(PostAndPrint)
        {
            Visible = false;
            Enabled = false;
        }

        addafter("&Test Report")
        {
            action("P&ost")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Codeunit "Bank Acc ReconPost YesNo";
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
            }
        }

        addafter("Ba&nk")
        {
            group(Print)
            {

                action("Clear Difference")
                {
                    ApplicationArea = All;
                    Caption = 'Clear Difference';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = CopyLedgerToBudget;
                    trigger OnAction()
                    var
                        ClearDifference: Codeunit "Customize Events";
                    begin
                        if Confirm('Are you sure you want to clear differences', true) then begin
                            ClearDifference.ClearPreviousDifferences("Statement No.", "Bank Account No.", "Statement Date");
                        end;
                    end;
                }
                action("Bank Acc. Reconciliation Detailed Report")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Acc. Reconciliation Detailed Report';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Reconcile;
                    trigger OnAction()
                    var
                        BankAccountReconciliationTest: Report "Bank Acc Reconciliation Detail";
                    begin
                        CLEAR(BankAccountReconciliationTest);
                        BankAccountReconciliationTest.SetDefaults("Bank Account No.", "Statement No.");
                        BankAccountReconciliationTest.RUN;
                    end;
                }

                action("Bank Acc. Reconciliation Summary Report")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Acc. Reconciliation Summary Report';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Receipt;
                    trigger OnAction()
                    var
                        BankAccountReconciliationTest: Report "Bank Acc Reconciliation Report";

                    begin
                        CLEAR(BankAccountReconciliationTest);
                        BankAccountReconciliationTest.SetDefaults("Bank Account No.", "Statement No.");
                        BankAccountReconciliationTest.RUN;
                    end;
                }

                action("Difference")
                {
                    ApplicationArea = All;
                    Caption = 'Difference';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = DistributionGroup;
                    RunObject = page "Bank Acc. Recon. Diff";
                    RunPageLink = "Bank Account No." = field("Bank Account No.");
                }
            }

        }

        addafter(RemoveMatch)
        {
            action(MatchDiffManually)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Match Diff Manually';
                Image = CheckRulesSyntax;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Manually match selected lines in both panes to link each bank statement line to one or more related bank account ledger entries.';

                trigger OnAction()
                var
                    TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                    TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                    MatchBankRecLines: Codeunit "Customize Events";
                begin
                    CurrPage.DifferenceLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                    CurrPage.ClearDiffBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                    MatchBankRecLines.MatchManually(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);
                end;
            }

            action(RemoveDiffMatch)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Remove Difference Match';
                Image = RemoveContacts;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Remove selection of matched bank statement lines.';

                trigger OnAction()
                var
                    TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                    TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                    MatchBankRecLines: Codeunit "Customize Events";
                begin
                    CurrPage.DifferenceLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                    CurrPage.ClearDiffBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                    MatchBankRecLines.RemoveMatch(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);
                end;
            }
        }

    }

    var
        CashBookBalance: Decimal;
        CashBookBalanceLCY: Decimal;
        OutstandingChecks: Decimal;
        OutstandingDeposits: Decimal;
        OutstandingAmount: Decimal;
        PositiveNegativeDifferences: Decimal;
        NegativeDifferences: Decimal;
        EndingBalance: Decimal;
        PreviousUnclearedDifferences1: Decimal;
        PreviousUnclearedDifferences2: Decimal;


}
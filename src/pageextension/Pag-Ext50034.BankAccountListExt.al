pageextension 50034 "Bank Account List Ext" extends "Bank Account List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Search Name")
        {
            Field(Balance; Balance)
            {
                ApplicationArea = All;
            }
            Field("Balance (LCY)"; "Balance (LCY)")
            {
                ApplicationArea = All;
            }
            Field("Balance at Date"; "Balance at Date")
            {
                ApplicationArea = All;
            }
            Field("Balance at Date (LCY)"; "Balance at Date (LCY)")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Detail Trial Balance")
        {
            action("Petty Cash book")
            {
                ApplicationArea = All;
                Caption = 'Petty Cash Book';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                trigger OnAction()
                var
                    BankAccount: Record "Bank Account";
                    BankPettyCash: Report "Bank Acc. - Detail Petty Cash";
                begin
                    BankAccount.RESET;
                    BankAccount.SETRANGE(BankAccount."No.", Rec."No.");
                    BankPettyCash.SETTABLEVIEW(BankAccount);
                    BankPettyCash.RUN;
                end;
            }
            action("Bank Account Trial Balance")
            {
                ApplicationArea = All;
                Caption = 'Bank Account Trial Balance';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = TransmitElectronicDoc;
                trigger OnAction()
                var
                    BankAccTrialBalance: Report "Bank Account Trial Balance";
                begin
                    BankAccTrialBalance.Run();
                end;
            }

            action(PostedBankAccountReconciliation)
            {
                ApplicationArea = All;
                Caption = 'Posted Bank Account Reconciliations';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = BankAccountRec;
                RunObject = Page "Posted Bank Acc. Rec. List";
                RunPageView = SORTING("Bank Account No.");
                RunPageLink = "Bank Account No." = FIELD("No.");
            }

            action(Differences)
            {
                ApplicationArea = All;
                Caption = 'Posted Bank Account Reconciliation Differences';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = BankAccountStatement;
                RunObject = page "Bank Acc. Recon. Diff";
                RunPageView = sorting("Bank Account No.");
                RunPageLink = "Bank Account No." = field("No.");
            }

        }

    }

    var
        myInt: Integer;
}
pageextension 50035 "Bank Account Card Ext" extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
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
        }
    }

    var
        myInt: Integer;
}
tableextension 50050 "BankAcc ReconciliationLine Ext" extends "Bank Acc. Reconciliation Line" //274
{
    fields
    {
        // Add changes to table fields here
        field(50000; Clear; Boolean) { }
        field(50005; "Statement Type 2"; Option)
        {
            Caption = 'Statement Type';
            OptionCaption = 'Bank Reconciliation,Payment Application';
            OptionMembers = "Bank Reconciliation","Payment Application","Posted Bank Reconciliation";
        }
        field(50010; "Cleared Date"; Date) { }
        field(50020; Cleared; Boolean) { }
        field(50030; "Applied Entry"; Integer)
        {
            TableRelation = "Bank Account Ledger Entry"."Entry No." WHERE("Bank Account No." = FIELD("Bank Account No."), Open = CONST(true), Reversed = CONST(false));

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                BankAccountReconciliationPost.UpdateBankAccountLedgerEntry(Rec);
            end;
        }
        field(50031; "Reconcile Line"; Boolean) { }
        field(50032; "External Document No."; Code[30]) { }
        field(50033; "Transaction No."; Integer) { }
        field(50935; "Diff Closing Statement Number"; Code[30])
        {
            Editable = false;
        }
        field(50936; "Difference Closing Date"; Date)
        {
            Editable = false;
        }
    }

    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccountReconciliationPost: Codeunit "Post Bank Acc. Reconciliation";
        SetBanReconNum: Codeunit "Check Entry Set Recon.-No.";
        BankAccledgerEntry: Record "Bank Account Ledger Entry";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        MatchBankRecLines: Codeunit "Match Bank Rec. Lines";

    procedure Match()
    var
        myInt: Integer;
    begin
        BankAccledgerEntry.RESET;
        BankAccledgerEntry.SETRANGE(BankAccledgerEntry."Posting Date", Rec."Transaction Date");
        BankAccledgerEntry.SETRANGE(BankAccledgerEntry."Document No.", Rec."Document No.");
        BankAccledgerEntry.SETRANGE(BankAccledgerEntry.Amount, Rec."Statement Amount");
        BankAccledgerEntry.SETRANGE(BankAccledgerEntry."Transaction No.", Rec."Transaction No."); //Filter using the transaction no.
        IF BankAccledgerEntry.FINDFIRST THEN BEGIN
            //MatchBankRecLines.MatchManually(BankAccReconLine,BankAccledgerEntry);
            //MakeAmatch(BankAccReconLine,BankAccLedgEntry);
            BankAccReconLine.RESET;
            BankAccReconLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
            BankAccReconLine.SETRANGE("Statement No.", Rec."Statement No.");
            BankAccReconLine.SETRANGE("Statement Line No.", Rec."Statement Line No.");
            IF BankAccReconLine.FINDFIRST THEN BEGIN
                /*{ BankAccReconLine.VALIDATE("Applied Amount", BankAccReconLine."Statement Amount");
                           BankAccReconLine.VALIDATE(Difference, 0);
                           BankAccReconLine.VALIDATE("Applied Entries", 1);
                           BankAccReconLine.MODIFY;}*/

                //Changing the status of the Bank Acc. Ledger Lines
                BankAccledgerEntry."Statement Status" := BankAccledgerEntry."Statement Status"::"Bank Acc. Entry Applied";
                BankAccledgerEntry."Statement No." := BankAccReconLine."Statement No.";
                BankAccledgerEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
                BankAccledgerEntry.MODIFY;

            END;
        END;
    end;

    procedure RemoveMatch()
    var
        myInt: Integer;
    begin
        BankAccledgerEntry.RESET;
        BankAccledgerEntry.SETRANGE(BankAccledgerEntry."Posting Date", Rec."Transaction Date");
        BankAccledgerEntry.SETRANGE(BankAccledgerEntry."Document No.", Rec."Document No.");
        BankAccledgerEntry.SETRANGE(BankAccledgerEntry.Amount, Rec."Statement Amount");
        BankAccledgerEntry.SETRANGE(BankAccledgerEntry."Transaction No.", Rec."Transaction No."); //filter basing on the transaction no.
        IF BankAccledgerEntry.FINDFIRST THEN BEGIN
            //MatchBankRecLines.RemoveMatch(BankAccReconLine,BankAccledgerEntry);
            BankAccReconLine.RESET;
            BankAccReconLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
            BankAccReconLine.SETRANGE("Statement No.", Rec."Statement No.");
            BankAccReconLine.SETRANGE("Statement Line No.", Rec."Statement Line No.");
            IF BankAccReconLine.FINDFIRST THEN BEGIN

                //Changing the status of the Bank Acc. Ledger Lines
                BankAccledgerEntry."Statement Status" := BankAccledgerEntry."Statement Status"::Open;
                BankAccledgerEntry."Statement No." := '';
                BankAccledgerEntry."Statement Line No." := 0;
                BankAccledgerEntry.MODIFY;

            END;
        END;
    end;
}
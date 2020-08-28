tableextension 50048 "Bank Account Ext" extends "Bank Account" //270
{
    fields
    {
        // Add changes to table fields here
    }

    var
        BankAccountReconcilation: Record "Bank Acc. Reconciliation";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccountStatementLine: Record "Bank Account Statement Line";
        BankAccountReconciliationLine: Record "Bank Acc. Reconciliation Line";

    procedure ClearPreviousDifference(BankAccountReconciliation: Record "Bank Acc. Reconciliation")
    begin
        // Look for all previous (uncleared) differences of the current bank that are not yet cleared up to the statement date
        BankAccountReconciliationLine.RESET;
        BankAccountReconciliationLine.SETRANGE(BankAccountReconciliationLine."Bank Account No.", BankAccountReconciliation."Bank Account No.");
        BankAccountReconciliationLine.SETRANGE(BankAccountReconciliationLine.Type, BankAccountReconciliationLine.Type::Difference);
        BankAccountReconciliationLine.SETRANGE(BankAccountReconciliationLine.Cleared, FALSE);
        BankAccountReconciliationLine.SETRANGE(BankAccountReconciliationLine.Clear, TRUE);
        BankAccountReconciliationLine.SETFILTER(BankAccountReconciliationLine."Applied Entry", '<>%1', 0);
        BankAccountReconciliationLine.SETFILTER(BankAccountReconciliationLine."Transaction Date", '..%1', BankAccountReconciliation."Statement Date");
        BankAccountReconciliationLine.SETFILTER(BankAccountReconciliationLine."Statement No.", '<>%1', BankAccountReconciliation."Statement No.");
        IF BankAccountReconciliationLine.FINDFIRST THEN
            REPEAT
                // Look for the corresponding Bank Ledger Entry that is being cleared / reconciled by this previous difference
                IF BankAccountLedgerEntry.GET(BankAccountReconciliationLine."Applied Entry") THEN BEGIN
                    // Close the Bank Account Leger Entry
                    BankAccountLedgerEntry.Open := FALSE;
                    BankAccountLedgerEntry."Statement No." := BankAccountReconcilation."Statement No.";
                    BankAccountLedgerEntry."Statement Status" := BankAccountLedgerEntry."Statement Status"::Closed;
                    BankAccountLedgerEntry."Remaining Amount" := BankAccountLedgerEntry."Remaining Amount" - BankAccountReconciliationLine.Difference;
                    BankAccountLedgerEntry.Status := BankAccountLedgerEntry.Status::"Closed by Current Stmt.";
                    BankAccountLedgerEntry."Open-to Date" := BankAccountReconciliation."Statement Date";
                    BankAccountLedgerEntry.MODIFY;
                    // Clear the previous uncleared difference
                    BankAccountReconciliationLine.Cleared := TRUE;
                    BankAccountReconciliationLine."Cleared Date" := BankAccountReconciliation."Statement Date";
                    BankAccountReconciliationLine."Applied Amount" := BankAccountReconciliationLine.Difference;
                    BankAccountReconciliationLine."Applied Entries" += 1;
                    BankAccountReconciliationLine.MODIFY;
                END;
            UNTIL BankAccountReconciliationLine.NEXT = 0;
    end;
}
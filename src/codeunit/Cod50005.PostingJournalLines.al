codeunit 50005 "PostingJournalLines"
{

    //Posting into the General Ledger Entry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnBeforeInsertGLEntry', '', true, true)]
    procedure ModifyPostGLAcc(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean)
    begin

        GLEntry."Paid To/Received From" := GenJournalLine."Paid To/Received From";
        GLEntry."Approved by" := GenJournalLine."Approved by";
        GLEntry."Requested by" := GenJournalLine."Requested by";
        GLEntry."GL Name" := GenJournalLine."GL Name";
        GLEntry."Authorised by" := GenJournalLine."Authorised by";
        GLEntry."Reviewed by" := GenJournalLine."Reviewed by";
        GLEntry."Prepared by" := GenJournalLine."Prepared by";

    end;

    //POsting to the BankAccountLedgerEntry Table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeBankAccLedgEntryInsert', '', True, True)]
    local procedure ModifyPostBankAcc(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    begin
        BankAccountLedgerEntry."Authorised by" := GenJournalLine."Authorised by";
        BankAccountLedgerEntry."Reviewed by" := GenJournalLine."Reviewed by";
        BankAccountLedgerEntry."Paid To/Received From" := GenJournalLine."Paid To/Received From";
        BankAccountLedgerEntry."Requested by" := GenJournalLine."Requested by";
        BankAccountLedgerEntry."GL Name" := GenJournalLine."GL Name";
        BankAccountLedgerEntry."Approved by" := GenJournalLine."Approved by";
        BankAccountLedgerEntry."Prepared by" := GenJournalLine."Prepared by";
    end;

    //Posting the Transfer Reason in the Transfer shipment header.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', true, true)]
    local procedure PostTransferReasonShipmt(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    begin
        TransShptHeader."Transfer Reason" := TransHeader."Transfer Reason";
    end;


    //Posting the Transfer Reason in the Transfer shipment header.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', true, true)]
    local procedure PostTransferReasonRecpt(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."Transfer Reason" := TransferHeader."Transfer Reason";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptLine', '', true, true)]
    local procedure PostShipmentLines(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    begin
        //var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean
        TransShptLine."Transfer Reason" := TransLine."Transfer Reason";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', true, true)]
    local procedure PostReceiptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    begin
        TransRcptLine."Transfer Reason" := TransLine."Transfer Reason";
    end;

}
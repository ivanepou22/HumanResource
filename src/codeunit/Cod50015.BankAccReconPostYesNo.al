codeunit 50015 "Bank Acc ReconPost YesNo"
{
    TableNo = "Bank Acc. Reconciliation";

    trigger OnRun()
    begin

        // V1.0.0
        CopyFlowData();
        // V1.0.0

        if BankAccReconPostYesNo(Rec) then;
    end;

    var
        PostReconciliationQst: Label 'Do you want to post the Reconciliation?';
        PostPaymentsOnlyQst: Label 'Do you want to post the payments?';
        PostPaymentsAndReconcileQst: Label 'Do you want to post the payments and reconcile the bank account?';

    procedure BankAccReconPostYesNo(var BankAccReconciliation: Record "Bank Acc. Reconciliation"): Boolean
    var
        BankAccRecon: Record "Bank Acc. Reconciliation";
        Question: Text;
    begin
        BankAccRecon.Copy(BankAccReconciliation);

        if BankAccRecon."Statement Type" = BankAccRecon."Statement Type"::"Payment Application" then
            if BankAccRecon."Post Payments Only" then
                Question := PostPaymentsOnlyQst
            else
                Question := PostPaymentsAndReconcileQst
        else
            Question := PostReconciliationQst;

        if not Confirm(Question, false) then
            exit(false);

        CODEUNIT.Run(CODEUNIT::"Post Bank Acc. Reconciliation", BankAccRecon);
        BankAccReconciliation := BankAccRecon;
        exit(true);
    end;
}


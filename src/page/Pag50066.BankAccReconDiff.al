page 50066 "Bank Acc. Recon. Diff"
{
    Caption = 'Bank Account Reconciliation Difference';
    PageType = ListPart;
    SourceTable = "Bank Acc. Reconciliation Line";
    Editable = false;
    SourceTableView = where(Type = filter(Difference), "Statement Type" = filter("Payment Application"));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Statement No."; "Statement No.")
                {
                    ApplicationArea = All;
                }
                field("Statement Line No."; "Statement Line No.")
                {
                    ApplicationArea = All;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Statement Amount"; "Statement Amount")
                {
                    ApplicationArea = All;
                }
                field("Applied Amount"; "Applied Amount")
                {
                    ApplicationArea = All;
                }
                field(Cleared; Cleared)
                {
                    ApplicationArea = All;
                }

                field(Difference; Difference)
                {
                    ApplicationArea = All;
                }



            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

    var

    procedure GetSelectedRecords(var TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary)
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        CurrPage.SetSelectionFilter(BankAccReconciliationLine);
        if BankAccReconciliationLine.FindSet then
            repeat
                TempBankAccReconciliationLine := BankAccReconciliationLine;
                TempBankAccReconciliationLine.Insert();
            until BankAccReconciliationLine.Next = 0;
    end;
}
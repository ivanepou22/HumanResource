tableextension 50049 "Bank Acc. Reconciliation Ext" extends "Bank Acc. Reconciliation" //273
{
    fields
    {
        field(50000; "Unpresented Payments"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Bank Account Ledger Entry"."Remaining Amount" WHERE("Bank Account No." = FIELD("Bank Account No."), Open = CONST(true), Positive = CONST(false), "Statement Status" = CONST(Open)));
        }
        field(50005; "Uncredited Desposits"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Bank Account Ledger Entry"."Remaining Amount" WHERE("Bank Account No." = FIELD("Bank Account No."), Open = CONST(true), Positive = CONST(true), "Statement Status" = CONST(Open)));
        }
        field(50010; "Previous Uncleared Difference"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Bank Acc. Reconciliation Line".Difference WHERE("Bank Account No." = FIELD("Bank Account No."), Type = FILTER(Difference), "Transaction Date" = FIELD("Date Filter"), Cleared = FILTER(false)));
        }
        field(50015; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50020; "Posted Unpresented Payments"; Decimal)
        {

        }
        field(50025; "Posted Uncredited Desposits"; Decimal)
        {

        }
        field(50030; "Posted Prev. Uncleared Diff."; Decimal)
        {

        }
        field(50040; "Posted Uncleared Difference"; Decimal)
        {

        }
        field(50050; "Balance To Reconcile"; Decimal)
        {

        }

        field(50055; "Statement Type 2"; Option)
        {
            Caption = 'Statement Type';
            OptionCaption = 'Bank Reconciliation,Payment Application';
            OptionMembers = "Bank Reconciliation","Payment Application","Posted Bank Reconciliation";
        }
    }

    keys
    {
        key(key1; "Statement Type 2")
        {

        }
    }

    var
        myInt: Integer;

    procedure CopyFlowData()
    var
        myInt: Integer;
    begin
        CALCFIELDS("Uncredited Desposits");
        CALCFIELDS("Unpresented Payments");
        CALCFIELDS("Previous Uncleared Difference");
        "Posted Uncredited Desposits" := "Uncredited Desposits";
        "Posted Unpresented Payments" := "Unpresented Payments";
        "Posted Prev. Uncleared Diff." := "Previous Uncleared Difference";
        MODIFY;
    end;
}
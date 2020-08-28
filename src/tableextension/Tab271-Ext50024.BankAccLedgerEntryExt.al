tableextension 50024 "Bank Acc. Ledger Entry Ext" extends "Bank Account Ledger Entry" //271
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Statement Status 2"; Option)
        {
            Caption = 'Statement Status 2';
            OptionCaption = 'Open,Bank Acc. Entry Applied,Check Entry Applied,Closed';
            OptionMembers = Open,"Bank Acc. Entry Applied","Check Entry Applied",Closed,"Bank Acc. Entry Applied Temp";
        }
        field(50500; "Authorised by"; Text[100]) { }
        field(50510; "Paid To/Received From"; Text[50]) { }
        field(50520; "Requested by"; Text[100]) { }
        field(50525; "Reviewed by"; Text[100]) { }
        field(50540; "Approved by"; Code[100])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50541; "GL Name"; Text[100]) { }
        field(50545; "Prepared by"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50800; "Booking No."; Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FILTER(Quote));
        }
        field(50900; "Loan Transaction Type"; Option)
        {
            OptionMembers = " ","Loan Receipt","Loan Repayment","Interest Payment";
        }
        field(50910; Status; Option) //Bank Reconciliation.
        {
            OptionMembers = Open,"Closed by Future Stmt.","Closed by Current Stmt.";
        }
        field(50920; "Open-to Date"; Date) { } //Bank Reconciliation.
        field(50925; "Difference Statement No."; Code[50])
        {
            TableRelation = "Bank Account Statement"."Statement No." where("Bank Account No." = field("Bank Account No."));
        }
        field(50930; "Diff Statement Line No."; Integer)
        {
            TableRelation = "Bank Account Statement Line"."Statement Line No." where("Statement No." = field("Difference Statement No."), Type = filter(Difference), Cleared = const(false));
        }
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
        myInt: Integer;
}
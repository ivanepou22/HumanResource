pageextension 50011 "Bank Acc. Ledger Entries Ext" extends "Bank Account Ledger Entries"
{
    Editable = true;
    layout
    {
        // Add changes to page layout here
        addafter("Amount (LCY)")
        {
            field("Authorised by"; "Authorised by")
            {
                ApplicationArea = All;
            }
            field("Paid To/Received From"; "Paid To/Received From")
            {
                ApplicationArea = All;
            }
            field("Requested by"; "Requested by")
            {
                ApplicationArea = All;
            }
            field("Reviewed by"; "Reviewed by")
            {
                ApplicationArea = All;
            }
            field("Approved by"; "Approved by")
            {
                ApplicationArea = All;
            }
            field("Prepared by"; "Prepared by")
            {
                ApplicationArea = All;
            }
            field("Statement No."; "Statement No.")
            {
                ApplicationArea = All;
                Editable = true;
            }

            field("Statement Line No."; "Statement Line No.")
            {
                ApplicationArea = All;
                Editable = true;
            }



        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 50009 "General Ledger Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field("System-Created Entry"; "System-Created Entry")
            {
                ApplicationArea = All;
            }

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

            field("Branch Code"; "Branch Code")
            {
                ApplicationArea = All;
            }
        }

        addafter("System-Created Entry")
        {

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 50010 "General Journal Ext" extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bal. Account No.")
        {
            field("FA Posting Type"; "FA Posting Type")
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
            field("Authorised by"; "Authorised by")
            {
                ApplicationArea = All;
            }
            field("Approved by"; "Approved by")
            {
                ApplicationArea = All;
            }
            field("Reviewed by"; "Reviewed by")
            {
                ApplicationArea = All;
            }
            field("GL Name"; "GL Name")
            {
                ApplicationArea = All;

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
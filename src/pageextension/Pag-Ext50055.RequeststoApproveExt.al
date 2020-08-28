pageextension 50055 "Requests to Approve Ext" extends "Requests to Approve"
{
    layout
    {
        // Add changes to page layout here
        addafter(Details)
        {
            field("Document No."; "Document No.")
            {
                ApplicationArea = All;
            }
        }

        addafter("Sender ID")
        {
            field("Approver ID"; "Approver ID")
            {
                ApplicationArea = All;
            }

            field("Approval Code"; "Approval Code")
            {
                ApplicationArea = All;
            }
            field("Date-Time Sent for Approval"; "Date-Time Sent for Approval")
            {
                ApplicationArea = All;
            }

            field("Last Date-Time Modified"; "Last Date-Time Modified")
            {
                ApplicationArea = All;
            }

            field("Last Modified By User ID"; "Last Modified By User ID")
            {
                ApplicationArea = All;
            }
        }
        modify(ToApprove)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
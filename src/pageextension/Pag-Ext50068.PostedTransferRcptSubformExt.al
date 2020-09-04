pageextension 50068 "PostedTransferRcpt.Subform Ext" extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {

            field("Transfer Reason"; "Transfer Reason")
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
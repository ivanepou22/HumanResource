pageextension 50067 "Transfer Order Subform Ext" extends "Transfer Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Quantity Received")
        {
            field("Transfer Reason"; "Transfer Reason")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

    }

    var
        myInt: Integer;
}
pageextension 50082 "Posted Sales Shipment Ext" extends "Posted Sales Shipment"
{
    layout
    {
        // Add changes to page layout here
        addafter("Order No.")
        {
            field("User ID"; "User ID")
            {
                Caption = ' User ID';
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
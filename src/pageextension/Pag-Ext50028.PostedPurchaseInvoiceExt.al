pageextension 50028 "Posted PurchaseInvoice Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        modify("Quote No.")
        {
            Caption = 'Request No.';
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
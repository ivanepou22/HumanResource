pageextension 50022 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Posting Group")
        {
            field("Vendor Type"; "Vendor Type")
            {
                ApplicationArea = All;
                Importance = Promoted;
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
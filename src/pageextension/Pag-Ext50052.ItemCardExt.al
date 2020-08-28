pageextension 50052 "Item Card Ext" extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Date Modified")
        {
            field("No. 2"; "No. 2")
            {
                ApplicationArea = All;
                Caption = 'Spare Part No.';
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
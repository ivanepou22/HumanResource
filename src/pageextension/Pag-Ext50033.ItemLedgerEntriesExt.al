pageextension 50033 "Item Ledger Entries Ext" extends "Item Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Open)
        {
            field("Source No."; "Source No.")
            {
                ApplicationArea = All;
            }
            field("Source Type"; "Source Type")
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
pageextension 50081 "Item Analy ViewBudgEntries Ext" extends "Item Analy. View Budg. Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("Source Type"; "Source Type")
            {
                ApplicationArea = All;
            }
            field("Source No."; "Source No.")
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
pageextension 50032 "Finished Production Order Ext" extends "Finished Production Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Date Modified")
        {
            field("Work Shift"; "Work Shift")
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
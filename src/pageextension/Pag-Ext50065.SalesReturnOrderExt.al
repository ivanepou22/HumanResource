pageextension 50065 "Sales Return Order Ext" extends "Sales Return Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Applies-to ID")
        {
            field("Branch Code"; "Branch Code")
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
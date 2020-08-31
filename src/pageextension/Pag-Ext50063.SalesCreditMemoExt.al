pageextension 50063 "Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
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
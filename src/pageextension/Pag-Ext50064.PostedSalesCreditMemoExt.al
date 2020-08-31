pageextension 50064 "Posted Sales Credit Memo Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Branch Code"; "Branch Code")
            {
                ApplicationArea = All;
                Importance = Standard;
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
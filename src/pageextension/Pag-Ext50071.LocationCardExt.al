pageextension 50071 "Location Card Ext" extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Use As In-Transit")
        {
            field("Include in report"; "Include in report")
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
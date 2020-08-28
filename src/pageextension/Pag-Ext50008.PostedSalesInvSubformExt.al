pageextension 50008 "Posted Sales Inv. Subform Ext" extends "Posted Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Line Amount")
        {
            field("Location Code"; "Location Code")
            {
                ApplicationArea = All;
            }
            field("Employee No."; "Resource No.")
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
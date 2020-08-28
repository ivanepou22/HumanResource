pageextension 50007 "Sales Invoice Subform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
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
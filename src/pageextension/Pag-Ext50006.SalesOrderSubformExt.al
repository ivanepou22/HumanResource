pageextension 50006 "Sales Order Subform Ext" extends "Sales Order Subform"
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
        addafter("Line Amount")
        {
            field("Amount Including VAT"; "Amount Including VAT")
            {
                ApplicationArea = All;
            }
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {
                ApplicationArea = All;
            }

        }
        modify("Unit Price")
        {
            Editable = true;
            Enabled = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
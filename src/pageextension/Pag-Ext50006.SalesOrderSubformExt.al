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
        modify(Description)
        {
            Editable = EditDescription;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        EditDescription: Boolean;

    trigger OnAfterGetRecord()
    var
    begin
        if Rec.Type = Rec.Type::Item then
            EditDescription := false
        else
            EditDescription := true;
    end;
}
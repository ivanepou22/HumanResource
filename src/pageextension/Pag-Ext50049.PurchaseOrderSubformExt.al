pageextension 50049 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Expected Receipt Date")
        {

            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("VAT ProdPosting Group"; "VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'VAT Prod Posting Group';
            }
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }

            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Depreciation Book Code"; "Depreciation Book Code")
            {
                ApplicationArea = All;
            }

        }
        modify("Unit Cost (LCY)")
        {
            Editable = false;
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
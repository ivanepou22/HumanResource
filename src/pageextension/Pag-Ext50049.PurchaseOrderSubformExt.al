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

            field("Buy-from Vendor No."; "Buy-from Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Pay-to Vendor No."; "Pay-to Vendor No.")
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
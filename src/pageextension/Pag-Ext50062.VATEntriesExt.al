pageextension 50062 "VAT Entries Ext" extends "VAT Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bill-to/Pay-to No.")
        {
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = All;
            }
            field("Vendor Name"; "Vendor Name")
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
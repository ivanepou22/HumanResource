pageextension 50059 "Sales Cr. Memo Subform Ext" extends "Sales Cr. Memo Subform" //96
{
    layout
    {
        // Add changes to page layout here
        addafter("Qty. Assigned")
        {
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }

            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
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
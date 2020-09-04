pageextension 50069 "PostedSales InvoiceLinesExt" extends "Posted Sales Invoice Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field("Resource No."; "Resource No.")
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
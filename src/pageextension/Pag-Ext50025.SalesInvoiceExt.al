pageextension 50025 "Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer Name")
        {
            field("Branch Code"; "Branch Code")
            {
                ApplicationArea = All;

            }

        }


        addafter("Posting Description")
        {
            field("Truck No."; "Truck No.")
            {
                ApplicationArea = All;
            }

            field("Seal No."; "Seal No")
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
        ASL00001: Label 'You are not allowed to Create a direct Sales invoice please contact your Systems Administrator';
        SalesSetup: Record "Sales & Receivables Setup";

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //Avoid the direct creation of invoices
        SalesSetup.GET;
        IF SalesSetup."Allow Direct Invoicing" = FALSE THEN
            ERROR(ASL00001);
    end;
}
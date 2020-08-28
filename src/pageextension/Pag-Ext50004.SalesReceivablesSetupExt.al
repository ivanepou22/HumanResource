pageextension 50004 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Payment-Invoice App. Mandatory"; "Payment-Invoice App. Mandatory")
            {
                ApplicationArea = All;
            }

            field("Allow Direct Invoicing"; "Allow Direct Invoicing")
            {
                ApplicationArea = All;
            }

            field(" Use User Location"; "Use User Location")
            {
                ApplicationArea = All;
            }
            field("POS Counter Nos."; "POS Counter Nos.")
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
pageextension 50005 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
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
            field("Allow Direct Invoices"; "Allow Direct Invoices")
            {
                ApplicationArea = All;
            }

            field("Default Vendor"; "Default Vendor")
            {
                ApplicationArea = All;
            }
            field("Payment Requisition Nos."; "Payment Requisition Nos.")
            {
                ApplicationArea = All;
            }
            field("Payment Requistion Journal"; "Payment Requistion Journal")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("Use User Location"; "Use User Location")
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
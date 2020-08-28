pageextension 50048 "Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        ASL00001: Label 'You are not allowed to Create a direct Purchase invoice please contact your Systems Administrator';
    begin
        //Avoiding the direct creation of a purchase invoice
        PurchaseSetup.GET;
        IF PurchaseSetup."Allow Direct Invoices" = FALSE THEN
            ERROR(ASL00001);
    end;
}
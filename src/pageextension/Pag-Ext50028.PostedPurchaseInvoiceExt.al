pageextension 50028 "Posted PurchaseInvoice Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        modify("Quote No.")
        {
            Caption = 'Request No.';
        }
    }
    actions
    {
        modify(Print)
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Print")
        {
            action("_Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print!';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = true;

                trigger OnAction()

                var
                    PurchaseInvHeader: Record "Purch. Inv. Header";
                    PostedPurchInv: Report "Purchase Invoice - Print";
                begin
                    PurchaseInvHeader.Reset();
                    PurchaseInvHeader.SetRange(PurchaseInvHeader."No.", Rec."No.");
                    PurchaseInvHeader.SetRange(PurchaseInvHeader."Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                    PostedPurchInv.SetTableView(PurchaseInvHeader);
                    PostedPurchInv.Run();
                end;
            }
        }
    }
}
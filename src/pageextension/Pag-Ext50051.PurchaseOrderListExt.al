pageextension 50051 "Purchase Order List Ext" extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify(Print)
        {
            Visible = false;
            Enabled = false;
        }
        // Add changes to page actions here
        addfirst(Action9)
        {
            action("Print Order")
            {
                ApplicationArea = Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseInvHeader: Record "Purchase Header";
                    PurchaseOrderPrint: Report "Purchase Order - Print";
                begin
                    PurchaseInvHeader.RESET;
                    PurchaseInvHeader.SETRANGE(PurchaseInvHeader."No.", Rec."No.");
                    PurchaseInvHeader.SetRange(PurchaseInvHeader."Document Type", Rec."Document Type");
                    PurchaseInvHeader.SetRange(PurchaseInvHeader."Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                    PurchaseOrderPrint.SETTABLEVIEW(PurchaseInvHeader);
                    PurchaseOrderPrint.RUN;
                end;
            }
            action("Purchase Order Summary")
            {
                ApplicationArea = suite;
                Caption = 'Purchase Order Summary';
                Ellipsis = true;
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = report "Purchase Order Summary";
            }
        }
    }

    var
        myInt: Integer;
}
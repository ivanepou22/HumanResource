pageextension 50026 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer Name")
        {
            field("Branch Code"; "Branch Code")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("Truck No."; "Truck No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Seal No"; "Seal No")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addfirst(processing)
        {
            action("Print Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                //Visible = NOT IsOfficeAddin;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    PostedSalesInvoicePrint: Report "Sales - Invoice Print";
                begin
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE(SalesInvHeader."No.", Rec."No.");
                    SalesInvHeader.SetRange(SalesInvHeader."Bill-to Customer No.", Rec."Bill-to Customer No.");
                    PostedSalesInvoicePrint.SETTABLEVIEW(SalesInvHeader);
                    PostedSalesInvoicePrint.RUN;
                end;
            }
        }

        modify(Print)
        {
            Visible = false;
            Enabled = false;
        }
    }

    var
        myInt: Integer;
}
pageextension 50075 "Purchase Order Archive Ext" extends "Purchase Order Archive"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("USER ID"; "USER ID")
            {
                ApplicationArea = All;
            }
            field("User Name"; "User Name")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("Approver Id"; "Approver Id")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Approver Name"; "Approver Name")
            {
                ApplicationArea = All;
                Visible = false;
            }


        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Print)
        {
            Visible = false;
        }

        addafter(Print)
        {
            action(PrintArchived)
            {
                ApplicationArea = Suite;
                Caption = 'Print';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Print;
                ToolTip = 'Print the information in the window. A print request window opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchArchiveHeader: Record "Purchase Header Archive";
                    PurchArchivePrint: Report "PurchaseOrderArchived Print";
                begin
                    //DocPrint.PrintPurchHeaderArch(Rec);
                    PurchArchiveHeader.Reset();
                    PurchArchiveHeader.SetRange(PurchArchiveHeader."Document Type", PurchArchiveHeader."Document Type"::Order);
                    PurchArchiveHeader.SetRange(PurchArchiveHeader."No.", Rec."No.");
                    PurchArchiveHeader.SetRange(PurchArchiveHeader."Doc. No. Occurrence", Rec."Doc. No. Occurrence");
                    PurchArchiveHeader.SetRange(PurchArchiveHeader."Version No.", Rec."Version No.");
                    PurchArchiveHeader.SetRange(PurchArchiveHeader."Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                    PurchArchivePrint.SetTableView(PurchArchiveHeader);
                    PurchArchivePrint.Run();
                end;
            }
        }

    }

    var
        myInt: Integer;
}
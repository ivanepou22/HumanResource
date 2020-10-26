pageextension 50076 "Item Journal Ext" extends "Item Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit Cost")
        {
            field("Qty Requested"; "Qty Requested")
            {
                ApplicationArea = All;

            }

            field("Equipment/Vehicle No"; "Equipment/Vehicle No")
            {
                ApplicationArea = All;
            }
            field("Equipment/Vehicle Name"; "Equipment/Vehicle Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("User ID"; "User ID")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Requested By"; "Requested By")
            {
                ApplicationArea = All;
            }
            field("Authorized By"; "Authorized By")
            {
                ApplicationArea = All;
            }
            field("Issued By"; "Issued By")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action("Fuel Issue Form")
            {
                ApplicationArea = All;
                Caption = 'Print Fuel Issue Form';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Print;
                trigger OnAction()
                var
                    ItemJurnalLine: Record "Item Journal Line";
                    FuelIssueForm: Report "Fuel Issue Form";
                begin
                    ItemJurnalLine.Reset();
                    ItemJurnalLine.SetRange(ItemJurnalLine."Journal Template Name", Rec."Journal Template Name");
                    ItemJurnalLine.SetRange(ItemJurnalLine."Journal Batch Name", Rec."Journal Batch Name");
                    ItemJurnalLine.SetRange(ItemJurnalLine."Document No.", Rec."Document No.");
                    FuelIssueForm.SetTableView(ItemJurnalLine);
                    FuelIssueForm.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}
pageextension 50072 "Item List Ext" extends "Item List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Inventory - Sales Statistics")
        {
            action("Item Availabity By location2")
            {
                //ApplicationArea = Suite;
                ApplicationArea = Planning;
                Promoted = true;
                PromotedCategory = "Report";
                Caption = 'Item Availability By Location';
                Image = "Report";
                RunObject = Report "Item Availability By Location";
                ToolTip = 'Item Availability By Location';
            }

            action("Item Stock Card")
            {
                ApplicationArea = Planning;
                Promoted = true;
                PromotedCategory = "Report";
                Caption = 'Item Stock Card';
                Image = Card;
                ToolTip = 'Item Stock Card';
                trigger OnAction()
                var
                    Item: Record Item;
                    ItemStockcard: Report "Item Stock Card";
                begin
                    Item.Reset();
                    Item.SetRange(Item."No.", Rec."No.");
                    Item.SetRange(Item."Item Category Code", Rec."Item Category Code");
                    ItemStockcard.SetTableView(Item);
                    ItemStockcard.Run();
                end;
            }

            action(ItemMovement)
            {
                ApplicationArea = Planning;
                Promoted = true;
                PromotedCategory = "Report";
                Caption = 'Item Movement';
                Image = Card;
                ToolTip = 'Item Movement Including Inbound and Outbound Transactions';
                RunObject = report "Item Movement";
            }
        }
    }

    var
        myInt: Integer;
}
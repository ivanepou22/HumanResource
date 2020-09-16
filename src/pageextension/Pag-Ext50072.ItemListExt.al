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
        }
    }

    var
        myInt: Integer;
}
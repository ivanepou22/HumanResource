tableextension 50031 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Resource No."; Code[50])
        {
            TableRelation = Resource."No." WHERE(Type = FILTER(Person));
        }
        //Pos modification.
        field(50000; Coded; Boolean) { }
        field(50010; "Line Profit"; Decimal) { }
        field(50015; "Line Deduction"; Decimal) { }
        field(50065; "Sales Unit Price"; Decimal) { }
        field(50075; "Sub Total"; Decimal) { }
        field(60010; "Receipt Posted"; Boolean) { }
        field(60020; "Document Type Pos"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"POS Count";
        }
        field(65010; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(65020; Drawer; Code[20])
        {
            TableRelation = "Voucher And Receipt"."No." WHERE("Document Type" = FILTER(Drawer), User = FIELD("User ID"));
        }
        field(65030; "Denomination Quantity"; Decimal) { }
        field(65040; "Denomination Amount"; Decimal) { }
        field(65050; "Total Amount"; Decimal) { }
        field(65060; "Posted Invoice No."; Code[20])
        {
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(65090; "Anticipated Profit"; Decimal) { }
        field(65100; "Sale Time"; Time) { }
        field(65200; "Available Quantities"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD(UPPERLIMIT("No.")), "Location Code" = FIELD("Location Code")));
        }
    }

    var
        myInt: Integer;
}
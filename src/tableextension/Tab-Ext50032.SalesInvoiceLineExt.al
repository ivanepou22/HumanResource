tableextension 50032 "Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Resource No."; Code[50])
        {
            TableRelation = Resource."No." WHERE(Type = FILTER(Person));
        }
        field(50800; "Booking No."; Code[30])
        {

        }
        field(50010; "Line Profit"; Decimal)
        {

        }
        field(50015; "Line Deduction"; Decimal)
        {

        }
        field(50065; "Sales Unit Price"; Decimal)
        {

        }
        field(50075; "Sub Total"; Decimal)
        {

        }
        field(65100; "Sale Time"; Time)
        {

        }
        field(65200; "Available Quantities"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Item No." = FIELD(UPPERLIMIT("No.")), "Location Code" = FIELD("Location Code")));
        }
    }

    var
        myInt: Integer;
}
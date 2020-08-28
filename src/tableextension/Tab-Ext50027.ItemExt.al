tableextension 50027 "ItemExt" extends Item
{

    fields
    {
        // Add changes to table fields here
        field(50000; "Inventory Value"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
            "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"),
            "Lot No." = FIELD("Lot No. Filter"), "Serial No." = FIELD("Serial No. Filter"), "Posting Date" = FIELD("Date Filter")));
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Vendor Item No.")
        {
        }
    }

    var
        myInt: Integer;
}
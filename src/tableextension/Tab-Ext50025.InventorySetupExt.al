tableextension 50025 "InventorySetupExt" extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Journal Template Name"; Code[10]) { }
        field(50010; "Journal Batch Name"; Code[10]) { }
    }

    var
        myInt: Integer;
}
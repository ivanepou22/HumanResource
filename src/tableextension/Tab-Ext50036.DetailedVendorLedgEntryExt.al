tableextension 50036 "DetailedVendor LedgEntryExt" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Contract Purch. Agreement No."; Code[20]) { }
        field(50010; "Certificate No."; Code[20]) { }
        field(50020; "LPA No."; Code[20]) { }
        field(50030; "WHT Amount"; Decimal) { }
    }

    var
        myInt: Integer;
}
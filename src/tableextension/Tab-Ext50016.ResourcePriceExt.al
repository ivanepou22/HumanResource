tableextension 50016 "Resource Price Ext" extends "Resource Price"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Contract Limit"; Decimal) { }
        field(50001; "Unit Cost"; Decimal) { }
    }

    var
        myInt: Integer;
}
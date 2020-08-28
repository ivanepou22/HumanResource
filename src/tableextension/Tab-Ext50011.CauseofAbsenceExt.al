tableextension 50011 "Cause of Absence Ext" extends "Cause of Absence"
{
    fields
    {
        // Add changes to table fields here
        field(50010; "Deduct from Pay"; Boolean) { }
        field(50011; "Deduction Unit Amount"; Decimal) { }
    }

    var
        myInt: Integer;
}
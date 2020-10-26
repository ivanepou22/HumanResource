tableextension 50059 "Gen. Journal Batch Ext" extends "Gen. Journal Batch"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Batch User"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }

    var
        myInt: Integer;
}
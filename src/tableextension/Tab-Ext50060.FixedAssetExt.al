tableextension 50060 "Fixed Asset Ext" extends "Fixed Asset"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Tag Number"; Code[150])
        {
        }
    }

    var
        myInt: Integer;
}
tableextension 50055 "Transfer Receipt Line Ext" extends "Transfer Receipt Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transfer Reason"; Code[50])
        {
            Editable = false;
        }
    }

    var
        myInt: Integer;
}
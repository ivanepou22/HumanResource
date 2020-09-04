tableextension 50056 "Transfer Shipment Line Ext" extends "Transfer Shipment Line"
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
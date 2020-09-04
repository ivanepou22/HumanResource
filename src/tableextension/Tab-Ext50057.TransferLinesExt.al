tableextension 50057 "Transfer Lines Ext" extends "Transfer Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transfer Reason"; Code[50])
        {
            TableRelation = "Reason Code".Code;
        }
    }
    
    var
        myInt: Integer;
}
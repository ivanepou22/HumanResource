tableextension 50044 "Transfer Header Ext" extends "Transfer Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transfer Reason"; Code[20])
        {
            TableRelation = Confidential.Code where(Type = const("Transfer Reason"));
        }

    }

    var
        myInt: Integer;
}
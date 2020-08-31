tableextension 50054 "Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
{
    fields
    {
        // Add changes to table fields here
        field(50030; "Branch Code"; Code[50])
        {
            TableRelation = Confidential.Code where(Type = const(Branch));

        }
    }

    var
        myInt: Integer;
}
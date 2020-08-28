tableextension 50040 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here
        field(50030; "Branch Code"; Code[50])
        {
            TableRelation = Confidential.Code where(Type = const(Branch));
        }
        field(50033; "Truck No."; Code[30])
        {

        }
        field(50034; "Seal No"; Code[30])
        {

        }
    }

    var
        myInt: Integer;
}
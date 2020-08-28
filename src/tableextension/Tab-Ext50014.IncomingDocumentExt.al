tableextension 50014 "Incoming Document Ext" extends "Incoming Document"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Category; Code[20]) { }
        field(50001; "Employee No."; Code[20])
        {

        }
    }

    var
        myInt: Integer;
}
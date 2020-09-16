tableextension 50058 "Location Ext" extends Location
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Include in report"; Boolean)
        {
        }
    }

    var
        myInt: Integer;
}
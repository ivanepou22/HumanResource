tableextension 50043 "Production Order Ext" extends "Production Order"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Work Shift"; Option)
        {
            OptionMembers = "","Day Shift","Night Shift";
            NotBlank = true;
        }
    }

    var
        myInt: Integer;
}
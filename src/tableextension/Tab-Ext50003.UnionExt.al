tableextension 50003 "UnionExt" extends Union
{
    fields
    {
        // Add changes to table fields here
        field(50000; Type; Option)
        {
            OptionMembers = " ","Employee Tribe","Employee Religion";
        }
    }

    var
        myInt: Integer;
}
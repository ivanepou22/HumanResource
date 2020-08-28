tableextension 50009 "QualificationExt" extends Qualification
{
    fields
    {
        // Add changes to table fields here
        field(50000; Type; Option)
        {
            OptionMembers = " ",Professional,Academic,Skills;
        }
    }

    var
        myInt: Integer;
}
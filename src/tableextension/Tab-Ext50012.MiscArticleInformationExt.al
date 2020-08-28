tableextension 50012 "Misc. Article Information Ext" extends "Misc. Article Information"
{
    fields
    {
        // Add changes to table fields here
        field(50010; Type; Option)
        {
            OptionMembers = " ",Employee,Applicant;
        }
    }

    var
        myInt: Integer;
}
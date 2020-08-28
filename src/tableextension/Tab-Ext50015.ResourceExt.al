tableextension 50015 "ResourceExt" extends Resource
{
    fields
    {
        // Add changes to table fields here
        field(50000; "User Id"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
    }

    var
        myInt: Integer;
}
pageextension 50015 "QualificationsExt" extends Qualifications
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field(Type; Type)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
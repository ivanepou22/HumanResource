tableextension 50010 "EmployeeQualificationExt" extends "Employee Qualification"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Qualification Type"; Option)
        {
            OptionMembers = " ",Professional,Academic,Skills;
        }
    }

    var
        myInt: Integer;
}
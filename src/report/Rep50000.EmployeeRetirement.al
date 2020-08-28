report 50000 "Employee Retirement"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'EmployeeRetirement.rdlc';

    dataset
    {
        dataitem(DimensionSetEntry; "Dimension Set Entry")
        {
            column(Dimension_Value_Name; DimensionSetEntry."Dimension Value Name")
            {

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
}
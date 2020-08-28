page 50058 "Employee Overtime Earning"
{
    Caption = 'Employee Overtime Earnings';
    PageType = List;
    SourceTable = "Earning And Dedcution";
    SourceTableView = where(Type = filter(Earning), "ED Type" = filter(Overtime), "Fixed Amount" = filter(> 0));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }

                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Confidential Code"; "Confidential Code")
                {
                    ApplicationArea = All;
                    Caption = 'Earning Code';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Fixed Amount"; "Fixed Amount")
                {
                    ApplicationArea = All;
                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 50008 "Employee Religion"
{
    Caption = 'Employee Religion';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Union;
    SourceTableView = WHERE(Type = FILTER("Employee Religion"));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field(Code; Code)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Type := Type::"Employee Religion";
                    end;
                }
                Field(Name; Name)
                {
                    ApplicationArea = All;
                }
                Field(Type; Type)
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
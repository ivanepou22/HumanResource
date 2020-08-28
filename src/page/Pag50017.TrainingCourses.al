page 50017 "Training Courses"
{
    Caption = 'Training Courses';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;
    SourceTable = Confidential;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Institution Code"; "Institution Code")
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

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin

        Type := Type::Course;
    end;
}
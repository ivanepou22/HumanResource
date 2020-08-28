page 50057 "Transfer Reasons"
{
    Caption = 'Transfer Reasons';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Confidential;
    SourceTableView = where(Type = const("Transfer Reason"));

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
    begin
        Type := Type::"Transfer Reason";
    end;
}
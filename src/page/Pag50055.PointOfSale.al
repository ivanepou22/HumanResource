page 50055 "Point Of Sale"
{
    PageType = RoleCenter;
    Caption = 'Point Sales RoleCenter';

    layout
    {
        area(RoleCenter)
        {

            part("Trailing Sales Order"; "Trailing Sales Orders Chart")
            {
                ApplicationArea = Basic, Suite;
            }
            // part("Help And Chart Wrapper"; "Help And Chart Wrapper")
            // {
            //     ApplicationArea = Basic, Suite;
            // }
        }
    }

    actions
    {
        area(Creation)
        {
        }
        area(Processing)
        {
        }
        area(Reporting)
        {
        }
        area(Embedding)
        {
        }
        area(Sections)
        {
            group(POS)
            {
                action("Point Of Sale")
                {
                    RunPageMode = Create;
                    Caption = 'Point Of Sales';
                    ToolTip = '';
                    Image = Position;
                    RunObject = Report "Create POS";
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

}
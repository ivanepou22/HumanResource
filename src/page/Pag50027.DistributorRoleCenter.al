page 50027 "Distributor Role Center"
{
    PageType = RoleCenter;
    Caption = 'Distributor Role Center';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Distributor HeadLines")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Activities; "Distributor Activities")
            {

                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Sales Orders")
            {
                RunPageMode = Create;
                Caption = 'Sales Order';
                ToolTip = 'Creating Sales Order';
                Image = New;
                RunObject = page "Distributor Sales Order";
                ApplicationArea = Basic, Suite;
            }
        }
        area(Processing)
        {
            group(New)
            {
                action("Sales Order")
                {
                    RunPageMode = Create;
                    Caption = 'Sales Order';
                    ToolTip = 'Creating Sales Order';
                    Image = New;
                    RunObject = page "Distributor Sales Order";
                    ApplicationArea = Basic, Suite;
                }
            }


        }

        area(Embedding)
        {
            action("Sales Orders List - Open")
            {
                Caption = 'Open orders';
                RunObject = page "Dist Sales Order List";
                RunPageView = where(status = filter(open));
                ApplicationArea = Basic, Suite;
            }

            action("Sales Orders List - Pending")
            {
                Caption = 'Orders Pending Approval';
                RunObject = page "Dist Sales Order List";
                RunPageView = where(Status = FILTER("Pending Approval"));
                ApplicationArea = Basic, Suite;
            }

            action("Sales Orders List - Prepayment")
            {
                Caption = 'Orders Pending Prepayment';
                RunObject = page "Dist Sales Order List";
                RunPageView = where(Status = FILTER("Pending Prepayment"));
                ApplicationArea = Basic, Suite;
            }

            action("Sales Orders List - Released")
            {
                Caption = 'Released Orders';
                RunObject = page "Dist Sales Order List";
                RunPageView = where(Status = FILTER(Released));
                ApplicationArea = Basic, Suite;
            }

        }
        area(Sections)
        {
            group("My Sales Orders")
            {
                Caption = 'Sales Orders';
                Image = Sales;

                action("Orders List")
                {
                    Caption = 'Sales Orders';
                    ToolTip = 'Sales Orders';
                    RunObject = Page "Dist Sales Order List";
                    ApplicationArea = Basic, Suite;

                }


            }
        }
    }

}
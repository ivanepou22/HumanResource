page 50034 "User Location"
{
    Caption = 'User Location';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "User Locations";
    // DelayedInsert = true;
    // MultipleNewLines = true;
    // LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                Field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                Field("Location Name"; "Location Name")
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
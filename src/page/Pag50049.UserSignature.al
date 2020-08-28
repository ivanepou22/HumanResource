page 50049 "User Signature"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "User Signature";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("User Id"; "User Id")
                {
                    ApplicationArea = All;

                }
                field("User Name"; "User Name")
                {
                    ApplicationArea = All;
                }
                field(Signature; Signature)
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        User: Record User;
    begin

    end;

    var
        myInt: Integer;
}
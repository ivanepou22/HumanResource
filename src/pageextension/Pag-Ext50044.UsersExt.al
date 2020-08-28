pageextension 50044 "UsersExt" extends Users
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addfirst(navigation)
        {
            action("Signature")
            {
                ApplicationArea = All;
                Caption = 'Signature';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "User Signature";
                RunPageLink = "User Id" = field("User Name");
                Image = Signature;
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
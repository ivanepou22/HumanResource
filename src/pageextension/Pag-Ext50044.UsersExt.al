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
            }
        }
        addafter("Permission Set by User Group")
        {
            action("User Permissions")
            {
                ApplicationArea = All;
                Caption = 'User Permissions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Permission;
                RunObject = report UserPermissions;
            }
        }
    }

    var
        myInt: Integer;
}
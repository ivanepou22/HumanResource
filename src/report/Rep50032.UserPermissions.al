report 50032 "UserPermissions"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'UserPermissions.rdlc';
    dataset
    {
        dataitem("Access Control"; "Access Control")
        {
            Column(Company_Name; CompanyInfo.Name) { }
            Column(Company_Address; CompanyInfo.Address) { }
            Column(Company_PhoneNo; CompanyInfo."Phone No.") { }
            Column(Company_Picture; CompanyInfo.Picture) { }
            Column(Company_Email; CompanyInfo."E-Mail") { }
            Column(Company_HomePage; CompanyInfo."Home Page") { }
            Column(UserName_AccessControl; "Access Control"."User Name") { }
            Column(UserName; UserName) { }
            Column(RoleID_AccessControl; "Access Control"."Role ID") { }
            Column(RoleName_AccessControl; "Access Control"."Role Name") { }
            Column(UserStatus; UserStatus) { }

            trigger OnAfterGetRecord()
            begin
                User.RESET;
                User.SETRANGE("User Name", "Access Control"."User Name");
                IF User.FINDFIRST THEN BEGIN
                    UserName := User."Full Name";
                    UserStatus := User.State;
                END;
            end;
        }
    }

    var
        UserName: Text[100];
        User: Record User;
        CompanyInfo: Record "Company Information";
        UserStatus: Option Enabled,Disabled;

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;
}
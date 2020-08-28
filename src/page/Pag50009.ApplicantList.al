page 50009 "Applicant List"
{
    Caption = 'Applicant List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Applicant;
    CardPageId = "Applicant Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                Field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                }
                Field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = All;
                }
                Field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                }
                Field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                Field(Status; Status)
                {
                    ApplicationArea = All;
                }
                Field(Initials; Initials)
                {
                    ApplicationArea = All;
                }
                Field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
                Field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                Field("Mobile Phone No."; "Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                Field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                Field("ID No./Passport No."; "ID No./Passport No.")
                {
                    ApplicationArea = All;
                }
                Field("Registration Date"; "Registration Date")
                {
                    ApplicationArea = All;
                }
                Field("Birth Date"; "Birth Date")
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
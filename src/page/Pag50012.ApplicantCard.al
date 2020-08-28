page 50012 "Applicant Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Applicant;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Field("No."; "No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        myInt: Integer;
                    begin
                        IF AssignEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
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
                Field(Initials; Initials)
                {
                    ApplicationArea = All;
                }
                Field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
                Field("Birth Date"; "Birth Date")
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
                Field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                }
                Field("Last Modified Date Time"; "Last Modified Date Time")
                {
                    ApplicationArea = All;
                }
                Field("Tax Identification No. (TIN)"; "Tax Identification No. (TIN)")
                {
                    ApplicationArea = All;
                }
                Field(Nationality; Nationality)
                {
                    ApplicationArea = All;
                }
                Field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                Field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                Field("Application Method"; "Application Method")
                {
                    ApplicationArea = All;
                }
                Field("Social Security No."; "Social Security No.")
                {
                    ApplicationArea = All;
                }
                Field(Status; Status)
                {
                    ApplicationArea = All;
                }
                group("Job Information")
                {

                    Field("Vacancy Code"; "Vacancy Code")
                    {
                        ApplicationArea = All;
                    }
                    Field("Job No."; "Job No.")
                    {
                        ApplicationArea = All;
                    }
                    Field("Job Name"; "Job Name")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group("Address & Contacts")
            {

                Field(Address; Address)
                {
                    ApplicationArea = All;
                }
                Field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                }
                Field(City; City)
                {
                    ApplicationArea = All;
                }
                Field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                }
                Field(County; County)
                {
                    ApplicationArea = All;
                }
                Field("Alt. Address Code"; "Alt. Address Code")
                {
                    ApplicationArea = All;
                }
                Field("Alt. Address Start Date"; "Alt. Address Start Date")
                {
                    ApplicationArea = All;
                }
                Field("Alt. Address End Date"; "Alt. Address End Date")
                {
                    ApplicationArea = All;
                }
                Field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                Field(Village; Village)
                {
                    ApplicationArea = All;
                }
                Field(District; District)
                {
                    ApplicationArea = All;
                }
                group("Contact Information")
                {
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
                }
            }
            group("Personal Information")
            {

                Field(Religion; Religion)
                {
                    ApplicationArea = All;
                }
                Field(Tribe; Tribe)
                {
                    ApplicationArea = All;
                }
                Field("Fathers Name"; "Fathers Name")
                {
                    ApplicationArea = All;
                }
                Field("Mothers Name"; "Mothers Name")
                {
                    ApplicationArea = All;
                }
            }
            group(Administration)
            {
                Field("Statistics Group Code"; "Statistics Group Code")
                {
                    ApplicationArea = All;
                }
                Field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                Field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                Field("Major Location"; "Major Location")
                {
                    ApplicationArea = All;
                }
                Field("Employee No."; "Employee No.")
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
            group(Files)
            {
                action("CV Attachment")
                {
                    ApplicationArea = All;
                    Caption = 'CV Attachment';
                    Image = Filed;
                    RunObject = page "File Uploads";
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunPageLink = "Employee No." = FIELD("No."), Type = CONST(Applicant);

                    trigger OnAction()
                    begin

                    end;
                }
            }

            group(Application)
            {
                action("Decline Application")
                {
                    ApplicationArea = All;
                    Caption = 'Decline Application';
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    Image = Reject;

                    trigger OnAction()
                    var
                        TXT001: Label 'You Cannot Decline Application %1';
                        TXT002: Label 'Are You Sure You Want to Decline This Application ?';
                        TXT003: Label 'Application %1 has been Declined.';
                    begin
                        IF (Status = Status::Declined) OR (Status = Status::Appointed) THEN BEGIN
                            MESSAGE(TXT001, "No.");
                        END ELSE BEGIN
                            IF CONFIRM(TXT002, TRUE) THEN BEGIN
                                VALIDATE(Status, Status::Declined);
                                MESSAGE(TXT003, "No.");
                            END;
                        END;
                    end;
                }
                action("Approve For Interviews")
                {
                    ApplicationArea = All;
                    Caption = 'Approve For Interviews';
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    Image = Approve;

                    trigger OnAction()
                    var
                        TXT004: Label 'You Cannot Approve Application %1 for interviews';
                        TXT005: Label 'Are You Sure You Want to Approve This Application for Interviews ?';
                        TXT006: Label 'Application %1 has been Approved For Interviews.';
                    begin
                        IF (Status = Status::Declined) OR (Status = Status::Appointed) THEN BEGIN
                            MESSAGE(TXT004, "No.");
                        END ELSE BEGIN
                            IF CONFIRM(TXT005, TRUE) THEN BEGIN
                                VALIDATE(Status, Status::Interview);
                                MESSAGE(TXT006, "No.");
                            END;
                        END;
                    end;
                }
                action("Set Interviews")
                {
                    ApplicationArea = All;
                    Caption = 'Set Interviews';
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    Image = SetupList;
                    RunObject = page "Set Interviews";
                    RunPageView = WHERE("Table Name" = CONST(Applicant));
                    RunPageLink = "No." = field("No.");
                    trigger OnAction()
                    begin

                    end;
                }
                action("Make Employee")
                {
                    ApplicationArea = All;
                    Caption = 'Make Employee';
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    Image = Users;

                    trigger OnAction()
                    var
                        TXT007: Label 'Are You Sure You Want To Make Applicant An Employee?';
                    begin
                        TESTFIELD(Status, Status::Interview);
                        IF CONFIRM(TXT007, TRUE) THEN BEGIN
                            UpdateApplicantAsEmployee('');
                        END;
                    end;
                }
            }
        }
    }

    var
        Filter: Text;
        SetInterviews: Boolean;


    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        SetInterviews := FALSE;
        IF Status = Status::Interview THEN
            SetInterviews := TRUE
        ELSE
            SetInterviews := FALSE;
    end;
}
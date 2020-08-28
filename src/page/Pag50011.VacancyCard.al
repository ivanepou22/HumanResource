page 50011 "Vacancy Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Vacancy Request";

    layout
    {
        area(Content)
        {
            group(General)
            {

                Field("Req No."; "Req No.")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit();
                    begin
                        IF AssignEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                Field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                }
                Field("Job Name"; "Job Name")
                {
                    ApplicationArea = All;
                }
                Field("Job Description"; "Job Description")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;

                }
                Field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                }
                Field("Expected Start Date"; "Expected Start Date")
                {
                    ApplicationArea = All;
                }
                Field("Vadlid From Date"; "Vadlid From Date")
                {
                    ApplicationArea = All;
                }
                Field("Valid To Date"; "Valid To Date")
                {
                    ApplicationArea = All;
                }
                Field("Vacancy Status"; "Vacancy Status")
                {
                    ApplicationArea = All;
                }
            }
            group(Qualifications)
            {

                Field("Job Qualifications"; "Job Qualifications")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Qualifications 2"; "Job Qualifications 2")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Qualifications 3"; "Job Qualifications 3")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Qualifications 4"; "Job Qualifications 4")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
            group(Skills)
            {
                Field("Job Skills"; "Job Skills")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Skills 1"; "Job Skills 1")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Skills 2"; "Job Skills 2")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Skills 3"; "Job Skills 3")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Skills 4"; "Job Skills 4")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Skills 5"; "Job Skills 5")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
            group(Responsibilities)
            {
                Field("Job Responsibilities"; "Job Responsibilities")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Responsibilities 1"; "Job Responsibilities 1")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Responsibilities 2"; "Job Responsibilities 2")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Responsibilities 3"; "Job Responsibilities 3")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Responsibilities 4"; "Job Responsibilities 4")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                Field("Job Responsibilities 5"; "Job Responsibilities 5")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ApplicationStage;

                trigger OnAction();
                begin
                    IF CONFIRM(ASL001, TRUE) THEN BEGIN
                        VALIDATE("Vacancy Status", "Vacancy Status"::"Pending Approval");
                        MESSAGE(ASL002, "Req No.");
                    END;
                    UpdateStage;
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ApprovalStage AND CurrUserIsApprover OR CurrUserIsApprover1;

                trigger OnAction();
                begin
                    IF CONFIRM(ASL003, TRUE) THEN BEGIN
                        TESTFIELD("Vacancy Status", "Vacancy Status"::"Pending Approval");
                        VALIDATE("Vacancy Status", "Vacancy Status"::Approved);
                        MESSAGE(ASL004, "Req No.");
                    END;
                    UpdateStage;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ApprovalStage AND CurrUserIsApprover OR CurrUserIsApprover1;

                trigger OnAction();
                begin
                    IF CONFIRM(ASL005, TRUE) THEN BEGIN
                        TESTFIELD("Vacancy Status", "Vacancy Status"::"Pending Approval");
                        VALIDATE("Vacancy Status", "Vacancy Status"::Rejected);
                        MESSAGE(ASL006, "Req No.");
                    END;
                    UpdateStage;
                end;
            }
        }
    }

    var
        ApplicationStage: Boolean;
        ApprovalStage: Boolean;
        UserSetup: Record "User Setup";
        CurrUserIsApprover: Boolean;
        CurrUserIsApprover1: Boolean;
        EditPage: Boolean;
        ASL001: Label 'Are You Sure You Want To Submit This Request ?';
        ASL002: Label 'Request %1 has been Submitted Successfully';
        ASL003: Label 'Are You Sure You Want To Approve This Request ?';
        ASL004: Label 'Request %1 has been Approved Successfully';
        ASL005: Label 'Are You Sure You Want To Reject This Request ?';
        ASL006: Label 'Request %1 has been Rejected Successfully';

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CurrUserIsApprover := FALSE;
        CurrUserIsApprover1 := FALSE;
        IF UserSetup.GET(USERID) THEN BEGIN
            CurrUserIsApprover := UserSetup."Finance Administrator";
            CurrUserIsApprover1 := UserSetup."HR Administrator";
        END;

        EditPage := FALSE;
        IF ("Vacancy Status" = "Vacancy Status"::Application) OR ("Vacancy Status" = "Vacancy Status"::Rejected) THEN BEGIN
            EditPage := TRUE;
        END ELSE
            EditPage := FALSE;
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        UpdateStage;
    end;

    procedure UpdateStage()
    var
        myInt: Integer;
    begin
        ApplicationStage := FALSE;
        ApprovalStage := FALSE;
        IF ("Vacancy Status" = "Vacancy Status"::Application) OR ("Vacancy Status" = "Vacancy Status"::Rejected) THEN
            ApplicationStage := TRUE
        ELSE
            IF "Vacancy Status" = "Vacancy Status"::"Pending Approval" THEN
                ApprovalStage := TRUE;
    end;
}
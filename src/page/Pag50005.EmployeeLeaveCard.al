page 50005 "Employee Leave Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Employee Absence";
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                Field("Leave Type"; "Leave Type")
                {
                    ApplicationArea = All;
                }
                Field("Requested From Date"; "Requested From Date")
                {
                    ApplicationArea = All;
                }
                Field("Requested To Date"; "Requested To Date")
                {
                    ApplicationArea = All;
                }
                Field(Description; Description)
                {
                    ApplicationArea = All;
                }
                Field("Leave Status"; "Leave Status")
                {
                    ApplicationArea = All;
                }
                Field("Days to be Taken"; "Days to be Taken")
                {
                    ApplicationArea = All;
                }
                Field("Leave Entitlement"; "Leave Entitlement")
                {
                    ApplicationArea = All;
                }
                Field("Leave Days Available"; "Leave Days Available")
                {
                    ApplicationArea = All;
                }
                Field("Leave Balance"; "Leave Balance")
                {
                    ApplicationArea = All;
                }
            }

            group(Approval)
            {
                Field("Approved From Date"; "Approved From Date")
                {
                    ApplicationArea = All;
                }
                Field("Approved To Date"; "Approved To Date")
                {
                    ApplicationArea = All;
                }
                Field("Approved Leave Days2"; "Approved Leave Days2")
                {
                    ApplicationArea = All;
                }
            }

            group(Actual)
            {
                Field("From Date"; "From Date")
                {
                    ApplicationArea = All;
                }
                Field("To Date"; "To Date")
                {
                    ApplicationArea = All;
                }
                Field("Actual Leave Days"; "Actual Leave Days")
                {
                    ApplicationArea = All;
                }
            }
        }

        area(FactBoxes)
        {
            part("Employee Leave Factbox"; "Employee Leave FactBox")
            {
                ApplicationArea = All;
                Caption = 'Employee Leave FactBox';
                SubPageLink = "No." = field("Employee No.");
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
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
                Visible = ApplicationStage;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SubmitLeaveApplication;
                    UpdateStage;
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Visible = ApprovalStage AND CurrUserIsApprover;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ApproveLeaveApplication;
                    UpdateStage;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Visible = ApprovalStage AND CurrUserIsApprover;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RejectLeaveApplication;
                    UpdateStage;
                end;
            }
            action(Cancel)
            {
                ApplicationArea = All;
                Visible = (ApprovalStage OR PostApprovalStage) AND CurrUserIsApprover;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CancelLeave;
                    UpdateStage;
                end;
            }
            action(Commit)
            {
                ApplicationArea = All;
                Visible = PostApprovalStage AND CurrUserIsApprover;
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CommitLeave;
                    UpdateStage;
                end;
            }

            action("Commit Directly")
            {
                ApplicationArea = All;
                Visible = CurrUserIsApprover;
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CommitLeaveDirectly;
                    UpdateStage;
                end;
            }
        }
    }

    var
        ApplicationStage: Boolean;
        ApprovalStage: Boolean;
        PostApprovalStage: Boolean;
        UserSetup: Record "User Setup";
        CurrUserIsApprover: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CurrUserIsApprover := FALSE;
        IF UserSetup.GET(USERID) THEN BEGIN
            CurrUserIsApprover := UserSetup."Leave Administrator";
        END;
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        UpdateStage;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        "Absence Type" := "Absence Type"::Leave;
    end;

    procedure UpdateStage()
    var
        myInt: Integer;
    begin
        ApplicationStage := FALSE;
        ApprovalStage := FALSE;
        PostApprovalStage := FALSE;
        IF ("Leave Status" = "Leave Status"::Application) OR ("Leave Status" = "Leave Status"::Cancelled) OR
          ("Leave Status" = "Leave Status"::Rejected) THEN
            ApplicationStage := TRUE
        ELSE
            IF "Leave Status" = "Leave Status"::"Pending Approval" THEN
                ApprovalStage := TRUE
            ELSE
                IF "Leave Status" = "Leave Status"::Approved THEN
                    PostApprovalStage := TRUE;
    end;
}
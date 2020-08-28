page 50018 "Earnings & Deductions"
{
    Caption = 'Earnings OR Deductions';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Earning And Dedcution";
    AutoSplitKey = true;
    DataCaptionFields = "Employee No.";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field("Confidential Code"; "Confidential Code")
                {
                    ApplicationArea = All;
                }
                Field(Description; Description)
                {
                    ApplicationArea = All;
                }
                Field("Payroll Code"; "Payroll Code")
                {
                    ApplicationArea = All;
                }
                Field("Parent Code"; "Parent Code2")
                {
                    ApplicationArea = All;
                }
                Field("Amount Basis"; "Amount Basis")
                {
                    ApplicationArea = All;
                }
                Field("Fixed Amount"; "Fixed Amount")
                {
                    ApplicationArea = All;
                }
                Field(Percentage; Percentage)
                {
                    ApplicationArea = All;
                }
                Field("Has Employer Component"; "Has Employer Component")
                {
                    ApplicationArea = All;
                }
                Field("Employer Amount Basis"; "Employer Amount Basis")
                {
                    ApplicationArea = All;
                }
                Field("Fixed Rate"; "Fixed Rate")
                {
                    ApplicationArea = All;
                }
                Field("Fixed Quantity"; "Fixed Quantity")
                {
                    ApplicationArea = All;
                }
                Field("Employer Fixed Amount"; "Employer Fixed Amount")
                {
                    ApplicationArea = All;
                }
                Field("Employer Percentage"; "Employer Percentage")
                {
                    ApplicationArea = All;
                }
                Field(Recurrence; Recurrence)
                {
                    ApplicationArea = All;
                }
                Field("Opening Balance"; "Opening Balance")
                {
                    ApplicationArea = All;
                }
                Field("Current Balance"; "Current Balance")
                {
                    ApplicationArea = All;
                }
                Field("Threshold Balance"; "Threshold Balance")
                {
                    ApplicationArea = All;
                }
                Field("ED Type"; "ED Type")
                {
                    ApplicationArea = All;
                }
                Field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                Field("Employee Name"; "Employee Name")
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

    trigger OnOpenPage()
    begin
        FILTERGROUP(3);
        IF GETFILTER(Type) = 'Earning' THEN BEGIN
            EarnigsView := TRUE;
            DeductionView := FALSE;
        END ELSE
            IF GETFILTER(Type) = 'Deduction' THEN BEGIN
                EarnigsView := FALSE;
                ;
                DeductionView := TRUE;
            END;

        FILTERGROUP(0);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        IF EarnigsView THEN
            Type := Type::Earning
        ELSE
            IF DeductionView THEN
                Type := Type::Deduction;
    end;

    var
        EarnigsView: Boolean;
        DeductionView: Boolean;
}
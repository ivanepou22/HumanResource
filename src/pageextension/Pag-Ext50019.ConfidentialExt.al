pageextension 50019 "Confidential Ext" extends Confidential
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            Field("Payroll Group"; "Payroll Group")
            {
                ApplicationArea = All;
                Visible = EarnigsView;
                Enabled = EarnigsView;
                Editable = EarnigsView;
            }
            Field(Parent; Parent)
            {
                ApplicationArea = All;
                Visible = EarnigsView;
                Enabled = EarnigsView;
                Editable = EarnigsView;
            }
            Field("Parent Code2"; "Parent Code2")
            {
                ApplicationArea = All;
                Caption = 'Parent Code';
                Visible = EarnigsView;
                Enabled = EarnigsView;
                Editable = EarnigsView;
            }
            Field(Taxable; Taxable)
            {
                ApplicationArea = All;
                Visible = EarnigsView;
                Enabled = EarnigsView;
                Editable = EarnigsView;
            }
            Field("Pre-Tax Deductible"; "Pre-Tax Deductible")
            {
                ApplicationArea = All;
                Visible = DeductionView;
                Editable = DeductionView;
                Enabled = DeductionView;
            }
            Field("Pre-SSF Deductible"; "Pre-SSF Deductible")
            {
                ApplicationArea = All;
                Visible = DeductionView;
                Editable = DeductionView;
                Enabled = DeductionView;
            }
            Field("Inc. In SS Cont. Calculation"; "Inc. In SS Cont. Calculation")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field("Is SS Contribution"; "Is SS Contribution")
            {
                ApplicationArea = All;
                Visible = DeductionView;
                Editable = DeductionView;
                Enabled = DeductionView;
            }
            Field("Account Type"; "Account Type")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field("Account No."; "Account No.")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field("Expense Account No."; "Expense Account No.")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field(Recurrence; Recurrence)
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;

                trigger OnValidate();
                begin
                    HasBalance := (Recurrence = Recurrence::"On Balance");
                end;
            }
            Field("Recurrence Payroll Group Code"; "Recurrence Payroll Group Code")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field("Increasing Balance"; "Increasing Balance")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = HasBalance;
            }
            Field("Amount Basis"; "Amount Basis")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;

                trigger Onvalidate()
                var
                    myInt: Integer;
                begin
                    HasRangeTable := ("Amount Basis" = "Amount Basis"::"Range Table");
                end;
            }
            Field("Range Table Basis"; "Range Table Basis")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = HasRangeTable;
            }
            Field("Range Table Code"; "Range Table Code")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field(Percentage; Percentage)
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
            }
            Field("Has Employer Component"; "Has Employer Component")
            {
                ApplicationArea = All;
                Visible = DeductionView;
                Enabled = DeductionView;
                Editable = DeductionView;

                trigger OnValidate();
                begin
                    HasEmployerComponent := "Has Employer Component";
                end;

            }
            Field("Employer Amount Basis"; "Employer Amount Basis")
            {
                ApplicationArea = All;
                Visible = DeductionView;
                Enabled = DeductionView;
                Editable = HasEmployerComponent;
            }
            Field("Employer Range Table Basis"; "Employer Range Table Basis")
            {
                ApplicationArea = All;
                Visible = DeductionView;
                Enabled = DeductionView;
                Editable = HasEmployerComponent;
            }
            Field("Employer Percentage"; "Employer Percentage")
            {
                ApplicationArea = All;
                Visible = DeductionView;
                Enabled = DeductionView;
                Editable = HasEmployerComponent;
            }
            Field("Default Fixed Amount"; "Default Fixed Amount")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
            }
            Field("Default Employer Fixed Amount"; "Default Employer Fixed Amount")
            {
                ApplicationArea = All;
                Visible = DeductionView;
                Enabled = DeductionView;
                Editable = HasEmployerComponent;
            }
            Field("Default Threshold Balance"; "Default Threshold Balance")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = HasBalance;
            }
            Field("Threshold Action"; "Threshold Action")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = HasBalance;
            }
            Field("Minimum Amount"; "Minimum Amount")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field("Maximum Amount"; "Maximum Amount")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field("Use Min/Max If Out of Range"; "Use Min/Max If Out of Range")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Enabled = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field("Cumml. Process Range Table"; "Cumml. Process Range Table")
            {
                ApplicationArea = All;
                Visible = RangeTableView;
                Enabled = RangeTableView;
                Editable = RangeTableView;
            }
            Field("From Amount"; "From Amount")
            {
                ApplicationArea = All;
                Visible = RangeTableLineView;
                Enabled = RangeTableLineView;
                Editable = RangeTableLineView;
            }
            Field("To Amount"; "To Amount")
            {
                ApplicationArea = All;
                Visible = RangeTableLineView;
                Enabled = RangeTableLineView;
                Editable = RangeTableLineView;
            }
            Field(Basis; Basis)
            {
                ApplicationArea = All;
                Visible = RangeTableLineView;
                Enabled = RangeTableLineView;
                Editable = RangeTableLineView;
            }
            Field("Fixed Amount"; "Fixed Amount")
            {
                ApplicationArea = All;
                Visible = RangeTableLineView;
                Enabled = RangeTableLineView;
                Editable = RangeTableLineView;
            }
            Field("Range Percentage"; "Range Percentage")
            {
                ApplicationArea = All;
                Visible = RangeTableLineView;
                Enabled = RangeTableLineView;
                Editable = RangeTableLineView;
            }
            Field("Min. Amount"; "Min. Amount")
            {
                ApplicationArea = All;
                Visible = RangeTableLineView;
                Enabled = RangeTableLineView;
                Editable = RangeTableLineView;
            }
            Field("Max. Amount"; "Max. Amount")
            {
                ApplicationArea = All;
                Visible = RangeTableLineView;
                Enabled = RangeTableLineView;
                Editable = RangeTableLineView;
            }
            Field("Include on Report"; "Include on Report")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
            }
            Field("Payments Journal Template Name"; "Payments Journal Template Name")
            {
                ApplicationArea = All;
                Visible = false;
            }
            Field("Payments Journal Batch Name"; "Payments Journal Batch Name")
            {
                ApplicationArea = All;
                Visible = false;
            }
            Field("ED Type"; "ED Type")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
            }
            Field("Default Fixed Rate"; "Default Fixed Rate")
            {
                ApplicationArea = All;
                Visible = EarnigsView OR DeductionView;
                Editable = EarnigsView OR DeductionView;
            }
            Field("Saturday Half Day"; "Saturday Half Day")
            {
                ApplicationArea = All;
                Visible = LocationView;
                Enabled = LocationView;
                Editable = LocationView;
            }
            Field("Bank Branch No."; "Bank Branch No.")
            {
                ApplicationArea = All;
                Visible = BanksView;
            }
            Field("Bank Code"; "Bank Code")
            {
                ApplicationArea = All;
                Visible = BanksView;
            }
            Field("Bank Name"; "Bank Name")
            {
                ApplicationArea = All;
                Visible = BanksView;
            }
            field("Customer No."; "Customer No.")
            {
                ApplicationArea = All;
                Visible = not LocationView and not BanksView and not RangeTableLineView and not RangeTableView and
                not EarnigsView and not DeductionView;
            }
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = All;
                Visible = not LocationView and not BanksView and not RangeTableLineView and not RangeTableView and
                not EarnigsView and not DeductionView;
            }
            field(Type; Type)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(Navigation)
        {
            action("Range Table Lines")
            {
                ApplicationArea = All;
                Caption = 'View Range Table Lines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = RangeTableView;
                Image = Ranges;
                RunObject = page Confidential;
                RunPageView = WHERE(Type = CONST("Range Table Line"));
                RunPageLink = "Parent Code" = FIELD(Code);

                trigger OnAction()
                begin

                end;
            }

            group(Reports)
            {
                action("Bank Payment Detail")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Payment Detail';
                    Visible = EarnigsView OR DeductionView;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    Image = Payment;
                    trigger OnAction()
                    begin

                    end;
                }
                action(Payslip)
                {
                    ApplicationArea = All;
                    Caption = 'Payslip';
                    Promoted = true;
                    Visible = EarnigsView OR DeductionView;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    Image = Receipt;
                    trigger OnAction()
                    begin

                    end;
                }
                action("SSF Details")
                {
                    ApplicationArea = All;
                    Caption = 'SSF Details';
                    Visible = EarnigsView OR DeductionView;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    Image = ViewDetails;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Tax Detail")
                {
                    ApplicationArea = All;
                    Caption = 'Tax Detail';
                    Visible = EarnigsView OR DeductionView;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    Image = TaxDetail;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Tax Differences")
                {
                    ApplicationArea = All;
                    Caption = 'Tax Differences';
                    Visible = EarnigsView OR DeductionView;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    Image = TaxPayment;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Payroll Report")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Report';
                    Visible = EarnigsView OR DeductionView;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    Image = PayrollStatistics;
                    trigger OnAction()
                    begin

                    end;
                }
            }
        }

    }

    var
        EarnigsView: Boolean;
        DeductionView: Boolean;
        BranchView: Boolean;
        HasEmployerComponent: Boolean;
        HasBalance: Boolean;
        HasRangeTable: Boolean;
        RangeTableView: Boolean;
        RangeTableLineView: Boolean;
        RangeTableLines: Record Confidential;
        ParentCode: Code[10];
        BanksView: Boolean;
        LocationView: Boolean;
        AppraisalView: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
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
            END else
                if GetFilter(Type) = 'Branch' then begin
                    BranchView := true;
                end ELSE
                    IF GETFILTER(Type) = 'Range Table' THEN BEGIN
                        RangeTableView := TRUE;
                    END ELSE
                        IF GETFILTER(Type) = 'Range Table Line' THEN BEGIN
                            RangeTableLineView := TRUE;
                        END ELSE
                            IF GETFILTER(Type) = 'Employee Bank' THEN BEGIN
                                BanksView := TRUE;
                            END ELSE
                                IF GETFILTER(Type) = 'Employee Location' THEN BEGIN
                                    LocationView := TRUE;
                                END ELSE
                                    IF GETFILTER(Type) = 'Appraisal' THEN BEGIN
                                        AppraisalView := TRUE;
                                    END;

        FILTERGROUP(0);
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        HasEmployerComponent := "Has Employer Component";
        HasBalance := (Recurrence = Recurrence::"On Balance");
        HasRangeTable := ("Amount Basis" = "Amount Basis"::"Range Table");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin

        IF EarnigsView THEN
            Type := Type::Earning
        ELSE
            IF DeductionView THEN
                Type := Type::Deduction
            ELSE
                IF RangeTableView THEN
                    Type := Type::"Range Table"
                ELSE
                    IF BanksView THEN
                        Type := Type::"Employee Bank"
                    else
                        if BranchView then
                            Type := Type::Branch
                        ELSE
                            IF LocationView THEN
                                Type := Type::"Employee Location"
                            ELSE
                                IF RangeTableLineView THEN BEGIN
                                    Type := Type::"Range Table Line";

                                    ParentCode := GETFILTER("Parent Code");
                                    RangeTableLines.RESET;
                                    RangeTableLines.SETRANGE(RangeTableLines.Type, RangeTableLines.Type::"Range Table Line");
                                    RangeTableLines.SETRANGE(RangeTableLines."Parent Code", ParentCode);
                                    IF RangeTableLines.FIND('+') THEN BEGIN
                                        "Line Number" := RangeTableLines."Line Number" + 1;
                                        Code := RangeTableLines."Parent Code" + '-' + FORMAT("Line Number");
                                        "Parent Code" := RangeTableLines."Parent Code";
                                    END ELSE BEGIN
                                        "Line Number" := 1;
                                        Code := ParentCode + '-1';
                                        "Parent Code" := ParentCode
                                    END;
                                END;
    end;
}
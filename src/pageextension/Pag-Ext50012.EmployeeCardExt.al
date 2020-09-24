pageextension 50012 "Employee Card Ext" extends "Employee Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Name")
        {
            field("Full Name"; "Full Name")
            {
                Importance = Promoted;
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("Status 1"; "Status 1")
            {
                Caption = 'Status';
                ApplicationArea = All;
            }

        }
        addafter("SWIFT Code")
        {
            field("Account Title"; "Account Title")
            {
                Importance = Promoted;
                ApplicationArea = All;
            }
            field("Bank Name"; "Bank Name")
            {
                ApplicationArea = All;
            }
            field("Bank Code"; "Bank Code")
            {
                ApplicationArea = All;
            }
            group("Mobile Money Information")
            {
                Visible = "Payment Method" = "Payment Method"::"Mobile Money";
                field("MoMo Number"; "MoMo Number")
                {
                    ApplicationArea = All;
                }
                field("MoMo Name"; "MoMo Name")
                {
                    ApplicationArea = All;
                }


            }
        }
        addafter("Employee Posting Group")
        {
            field("Payment Method"; "Payment Method")
            {
                ApplicationArea = All;
            }

        }
        addafter("Employment Date")
        {
            field("Contract Type"; "Contract Type")
            {
                ApplicationArea = All;
            }
            field("Contract Renewal Start Date"; "Contract Renewal Start Date")
            {
                ApplicationArea = All;
            }
            field("Contract Renl. Formula"; "Contract Renl. Formula")
            {
                ApplicationArea = All;
            }
            field("Employment End Date"; "Employment End Date")
            {
                ApplicationArea = All;
            }

        }

        addafter("Termination Date")
        {
            field("Separation Reason"; "Separation Reason")
            {
                ApplicationArea = All;
            }
            field("Separation Description"; "Separation Description")
            {
                ApplicationArea = All;
            }


            field("No. Days Remaining"; "No. Days Remaining")
            {
                ApplicationArea = All;
            }
            field("Probation Date Formula"; "Probation Date Formula")
            {
                ApplicationArea = All;
            }
            field("Probation End Date"; "Probation End Date")
            {
                ApplicationArea = All;
            }

            field("Probation Status"; "Probation Status")
            {
                ApplicationArea = All;
            }
            field("Inactive From Date"; "Inactive From Date")
            {
                ApplicationArea = All;
            }
            field("Inactive To Date"; "Inactive To Date")
            {
                ApplicationArea = All;
            }

        }

        addafter("Resource No.")
        {
            field("User ID"; "User ID")
            {
                ApplicationArea = All;
            }
        }

        addafter("Social Security No.")
        {
            field("National ID No. (NIN)"; "National ID No. (NIN)")
            {
                ApplicationArea = All;
            }

        }

        addafter(Administration)
        {
            group(Leave)
            {
                Field("Annual Leave Days B/F"; "Annual Leave Days B/F")
                {
                    Editable = CurrUserIsLeaveAdmin;
                    ApplicationArea = All;
                }
                Field("Annual Leave Days (Current)"; "Annual Leave Days (Current)")
                {
                    Editable = CurrUserIsLeaveAdmin;
                    ApplicationArea = All;
                }
                Field("Annual Leave Days Taken"; "Annual Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Annual Leave Days Available"; "Annual Leave Days B/F" + "Annual Leave Days (Current)" - "Annual Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Maternity Leave Days"; "Maternity Leave Days")
                {
                    ApplicationArea = All;
                    Editable = CurrUserIsLeaveAdmin;
                }
                Field("Maternity Leave Days Taken"; "Maternity Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Maternity Leave Days Available"; "Maternity Leave Days" - "Maternity Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Paternity Leave Days"; "Paternity Leave Days")
                {
                    Editable = CurrUserIsLeaveAdmin;
                    ApplicationArea = All;
                }
                Field("Paternity Leave Days Taken"; "Paternity Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Paternity Leave Days Available"; "Paternity Leave Days" - "Paternity Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Leave Without Pay Days"; "Leave Without Pay Days")
                {
                    Editable = CurrUserIsLeaveAdmin;
                    ApplicationArea = All;
                }
                Field("Leave Without Pay Days Taken"; "Leave Without Pay Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Leave Without Pay Days Available"; "Leave Without Pay Days" - "Leave Without Pay Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Sick Days"; "Sick Days")
                {
                    Editable = CurrUserIsLeaveAdmin;
                    ApplicationArea = All;
                }
                Field("Sick Days Taken"; "Sick Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Sick Days Available"; "Sick Days" - "Sick Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Study Leave Days"; "Study Leave Days")
                {
                    Editable = CurrUserIsLeaveAdmin;
                    ApplicationArea = All;
                }
                Field("Study Leave Days Taken"; "Study Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Study Leave Days Available"; "Study Leave Days" - "Study Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Compassionate Leave Days"; "Compassionate Leave Days")
                {
                    Editable = CurrUserIsLeaveAdmin;
                    ApplicationArea = All;
                }
                Field("Compassionate Leave Days Taken"; "Compassionate Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                Field("Compasionate Leave Days Available"; "Compassionate Leave Days" - "Compassionate Leave Days Taken")
                {
                    ApplicationArea = All;
                }
            }
        }

        addafter(Personal)
        {
            group(Payroll)
            {
                Visible = ViewBasicSalary;
                field("Payroll Group Code"; "Statistics Group Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Include in Special Deduction"; "Include in Special Deduction")
                {
                    ApplicationArea = All;
                }

                field("Basic Pay Type"; "Basic Pay Type")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Visible = ViewBasicSalary;
                }
                field("Basic Salary"; "Basic Salary")
                {
                    ApplicationArea = All;
                    Visible = ViewBasicSalary;
                }
                field("Exchange Rate"; "Exchange Rate")
                {
                    ApplicationArea = All;
                    Visible = ViewBasicSalary;
                }
                field("Basic Salary (LCY)"; "Basic Salary (LCY)")
                {
                    ApplicationArea = All;
                    Visible = ViewBasicSalary;
                }
                field("Tax Percentage"; "Tax Percentage")
                {
                    ApplicationArea = All;
                    Visible = ViewBasicSalary;
                }

                field(Bank; Bank)
                {
                    ApplicationArea = All;
                }
                field("Payroll Status"; "Payroll Status")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tax Identification No. (TIN)"; "Tax Identification No. (TIN)")
                {
                    ApplicationArea = All;
                }
            }
        }

        addafter(Payments)
        {
            group("Employee Dimensions")
            {
                Field("Major Location"; "Major Location")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                Field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                Field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                Field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                Field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    ApplicationArea = All;
                    Importance = Additional;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                Field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    ApplicationArea = All;
                    Importance = Additional;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                Field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    ApplicationArea = All;
                    Importance = Additional;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                Field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    ApplicationArea = All;
                    Importance = Additional;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                Field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    ApplicationArea = All;
                    Importance = Additional;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
        }

        modify(Status)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Ledger E&ntries")
        {
            action(Earnings)
            {
                ApplicationArea = All;
                ToolTip = 'Capture Employee Earnings';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CoupledUnitOfMeasure;
                RunObject = page "Earnings & Deductions";
                RunPageView = WHERE(Type = CONST(Earning));
                RunPageLink = "Employee No." = FIELD("No."), "Payroll Code" = FIELD("Statistics Group Code");
                trigger OnAction()
                begin

                end;
            }

            action(Deductions)
            {
                ApplicationArea = All;
                ToolTip = 'Capture Employee Deductions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = InteractionTemplateSetup;
                RunObject = page "Earnings & Deductions";
                RunPageView = WHERE(Type = CONST(Deduction));
                RunPageLink = "Employee No." = FIELD("No.");
                trigger OnAction()
                begin

                end;
            }
        }
        addfirst(navigation)
        {
            action(Discipline)
            {
                ApplicationArea = All;
                Caption = 'Discipline';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Versions;
                RunObject = page "Discipline Sheet";
                RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No."), Type = CONST(Discipline);
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
        CurrUserIsLeaveAdmin: Boolean;
        ViewBasicSalary: Boolean;
        UserSetup: Record "User Setup";
        UserSetup1: Record "User Setup";
        FixedBasicPay: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        IsMobileMoney: Boolean;
        IsBank: Boolean;

    //=========================
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        // ASL HRM 1.0.0
        IF UserSetup.GET(UPPERCASE(USERID)) THEN
            CurrUserIsLeaveAdmin := UserSetup."Leave Administrator"
        ELSE
            CurrUserIsLeaveAdmin := FALSE;

        //Allowing user to view basic salary
        UserSetup1.Reset();
        UserSetup1.SetRange(UserSetup1."User ID", UserId);
        if UserSetup1.FindFirst() then begin
            if (UserSetup1."Finance Administrator" = true or UserSetup1."HR Administrator" = true) then
                ViewBasicSalary := true
            else
                ViewBasicSalary := false;
        end;


        FixedBasicPay := ("Basic Pay Type" = "Basic Pay Type"::Fixed);

        SETRANGE("Leave From Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
        SETRANGE("Leave To Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
        // ASL HRM 1.0.0
    end;

    //========================
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    //=======================
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        CLEAR(ShortcutDimCode);
    end;

    //=====================
    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        InsertEmployeeDimensions("Global Dimension 1 Code", "Global Dimension 2 Code", ShortcutDimCode[3],
        ShortcutDimCode[4], ShortcutDimCode[5], ShortcutDimCode[6], ShortcutDimCode[7], ShortcutDimCode[8]);
    end;

    //=======================
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
    begin
        InsertEmployeeDimensions("Global Dimension 1 Code", "Global Dimension 2 Code", ShortcutDimCode[3], ShortcutDimCode[4], ShortcutDimCode[5],
                                  ShortcutDimCode[6], ShortcutDimCode[7], ShortcutDimCode[8]);

    end;
}
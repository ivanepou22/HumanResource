codeunit 50004 "Modify Employee Card"
{
    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterValidateEvent', 'First Name', true, true)]
    /// <summary> 
    /// Description for OnAfterValidateFirstName.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnAfterValidateFirstName(var Rec: Record Employee)
    begin
        Rec.VALIDATE(Rec."Full Name", (Rec."Last Name" + ' ' + Rec."Middle Name" + ' ' + Rec."First Name"));
        Rec.VALIDATE(Rec."Account Title", (Rec."First Name" + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name"));
    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterValidateEvent', 'Middle Name', true, true)]
    /// <summary> 
    /// Description for OnAfterValidateMiddleName.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnAfterValidateMiddleName(var Rec: Record Employee)
    begin
        Rec.VALIDATE(Rec."Full Name", (Rec."Last Name" + ' ' + Rec."Middle Name" + ' ' + Rec."First Name"));
        Rec.VALIDATE(Rec."Account Title", (Rec."First Name" + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name"));
    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterValidateEvent', 'Last Name', true, true)]
    /// <summary> 
    /// Description for OnAfterValidateLastName.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnAfterValidateLastName(var Rec: Record Employee)
    begin
        Rec.VALIDATE(Rec."Full Name", (Rec."Last Name" + ' ' + Rec."Middle Name" + ' ' + Rec."First Name"));
        Rec.VALIDATE(Rec."Account Title", (Rec."First Name" + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name"));
    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterValidateEvent', 'Statistics Group Code', true, true)]
    /// <summary> 
    /// Description for OnAfterValidateStatisticsGroup.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    /// <param name="xRec">Parameter of type Record Employee.</param>
    local procedure OnAfterValidateStatisticsGroup(var Rec: Record Employee; var xRec: Record Employee)
    var
        EmployeeStatisticsGroup: Record "Employee Statistics Group";
        EmployeeDeductions: Record "Confidential Information";
        ASLT0004: Label 'Do you want the special deduction included for this employee?';
    begin
        IF (Rec."Statistics Group Code" <> xRec."Statistics Group Code") THEN BEGIN
            IF EmployeeStatisticsGroup.GET(xRec."Statistics Group Code") THEN BEGIN
                EmployeeDeductions.RESET;
                EmployeeDeductions.SETRANGE(EmployeeDeductions."Confidential Code", EmployeeStatisticsGroup."Special Deduction Code");
                EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", Rec."No.");
                IF EmployeeDeductions.FINDFIRST THEN
                    EmployeeDeductions.DELETE;
            END;
        END;

        IF CONFIRM(ASLT0004, TRUE) THEN BEGIN
            Rec."Include in Special Deduction" := TRUE;
            Rec.MODIFY;
        END ELSE BEGIN
            Rec."Include in Special Deduction" := FALSE;
            Rec.MODIFY;
        END;

    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterValidateEvent', 'Employment Date', true, true)]
    /// <summary> 
    /// Description for OnAfterValidateEmploymentDate.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnAfterValidateEmploymentDate(var Rec: Record Employee)
    begin
        IF (Rec."Employment Date" <> 0D) AND (FORMAT(Rec."Probation Date Formula") <> '') THEN
            Rec."Probation End Date" := CALCDATE(Rec."Probation Date Formula", Rec."Employment Date");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterValidateEvent', 'Termination Date', true, true)]
    /// <summary> 
    /// Description for OnAfterValidateTerminationDate.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnAfterValidateTerminationDate(var Rec: Record Employee)
    begin
        IF Rec."Termination Date" <> 0D THEN BEGIN
            Rec.VALIDATE(Rec."Status 1", Rec."Status 1"::Inactive);
            Rec.VALIDATE(Rec."Payroll Status", Rec."Payroll Status"::Inactive);
        END ELSE BEGIN
            Rec.VALIDATE(Rec."Status 1", Rec."Status 1"::Active);
            Rec.VALIDATE(Rec."Payroll Status", Rec."Payroll Status"::Active);
        END;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnOpenPageEvent', '', true, true)]
    /// <summary> 
    /// Description for OnOpenEmployeeCard.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnOpenEmployeeCard(var Rec: Record Employee)
    var

    begin
        // ASL HRM 1.0.0
        IF UserSetup.GET(UPPERCASE(USERID)) THEN
            CurrUserIsLeaveAdmin := UserSetup."Leave Administrator"
        ELSE
            CurrUserIsLeaveAdmin := FALSE;


        FixedBasicPay := (Rec."Basic Pay Type" = Rec."Basic Pay Type"::Fixed);

        Rec.SETRANGE(Rec."Leave From Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
        Rec.SETRANGE(Rec."Leave To Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
        // ASL HRM 1.0.0
    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterGetRecordEvent', '', true, true)]
    /// <summary> 
    /// Description for OnAfterGetRecordEventEmployeeCard.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnAfterGetRecordEventEmployeeCard(var Rec: Record Employee)
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnNewRecordEvent', '', true, true)]
    /// <summary> 
    /// Description for OnNewRecordEventEmployeeCard.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnNewRecordEventEmployeeCard(var Rec: Record Employee)
    begin
        Clear(ShortcutDimCode);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnModifyRecordEvent', '', true, true)]
    /// <summary> 
    /// Description for OnModifyRecordEventEmployeeCard.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnModifyRecordEventEmployeeCard(var Rec: Record Employee)
    begin
        Rec.InsertEmployeeDimensions(Rec."Global Dimension 1 Code", Rec."Global Dimension 2 Code", ShortcutDimCode[3], ShortcutDimCode[4], ShortcutDimCode[5],
                          ShortcutDimCode[6], ShortcutDimCode[7], ShortcutDimCode[8]);

    end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnQueryClosePageEvent', '', true, true)]
    /// <summary> 
    /// Description for OnQueryCloseEmployeeCard.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    local procedure OnQueryCloseEmployeeCard(var Rec: Record Employee)
    begin
        Rec.InsertEmployeeDimensions(Rec."Global Dimension 1 Code", Rec."Global Dimension 2 Code", ShortcutDimCode[3], ShortcutDimCode[4], ShortcutDimCode[5],
                          ShortcutDimCode[6], ShortcutDimCode[7], ShortcutDimCode[8]);

    end;

    // [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterValidateEvent', 'Global Dimension 1 Code', true, true)]
    // /// <summary> 
    // /// Description for OnbeforevalidateGlobalDmin1.
    // /// </summary>
    // local procedure OnbeforevalidateGlobalDmin1()
    // var
    //     Employee: Record Employee;

    // begin
    //     Employee.ValidateShortcutDimCode(1, Employee."Global Dimension 1 Code");
    // end;

    [EventSubscriber(ObjectType::Page, Page::"Employee Card", 'OnAfterValidateEvent', 'Emplymt. Contract Code', true, true)]
    /// <summary> 
    /// Description for OnAfterValidateContractCode.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    /// <param name="xRec">Parameter of type Record Employee.</param>
    local procedure OnAfterValidateContractCode(var Rec: Record Employee; var xRec: Record Employee)
    var
        JobTitle: Record "Employment Contract";
    begin
        if Rec."Emplymt. Contract Code" <> xRec."Emplymt. Contract Code" then begin
            JobTitle.Reset();
            JobTitle.SetRange(JobTitle.Code, Rec."Emplymt. Contract Code");
            if JobTitle.FindFirst() then
                Rec.Validate(Rec."Job Title", JobTitle.Description);
        end;
    end;

    //Human Resources Setup OnOpen Event
    [EventSubscriber(ObjectType::Page, Page::"Human Resources Setup", 'OnOpenPageEvent', '', true, true)]
    /// <summary> 
    /// Description for OnOpenHumanResourcesSetUp.
    /// </summary>
    local procedure OnOpenHumanResourcesSetUp()
    begin
        IF UserSetup.GET(UPPERCASE(USERID)) THEN
            CurrUserIsLeaveAdmin := UserSetup."Leave Administrator"
        ELSE
            CurrUserIsLeaveAdmin := FALSE;
    end;

    //teve
    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnBeforeValidateEvent', 'Buy-from Vendor No.', false, false)]
    /// <summary> 
    /// Description for OnBeforeValidateBuyFrom.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Purchase Header".</param>
    procedure OnBeforeValidateBuyFrom(var Rec: Record "Purchase Header")
    begin
        // V1.0.0 HideValidationDialog 
        IF (Rec."Document Type" = Rec."Document Type"::Quote) THEN
            HideValidationDialog := TRUE;
        // V1.0.0 HideValidationDialog
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    /// <summary> 
    /// Description for OnAfterValidateBuyFrom.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Purchase Header".</param>
    procedure OnAfterValidateBuyFrom(var Rec: Record "Purchase Header")
    begin
        // V1.0.0 Posting Description
        Rec.SetPostingDescription;
        // V1.0.0 Posting Description
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterValidateEvent', 'Vendor Invoice No.', false, false)]
    /// <summary> 
    /// Description for OnAfterValidateVendorInvNo.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Purchase Header".</param>
    procedure OnAfterValidateVendorInvNo(var Rec: Record "Purchase Header")
    begin
        // V1.0.0 Posting Description
        Rec.SetPostingDescription;
        // V1.0.0 Posting Description
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterValidateEvent', 'Buy-from Vendor Name', false, false)]
    /// <summary> 
    /// Description for OnAfterValidateBuyFromName.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Purchase Header".</param>
    procedure OnAfterValidateBuyFromName(var Rec: Record "Purchase Header")
    begin
        // V1.0.0 Posting Description
        Rec.SetPostingDescription;
        // V1.0.0 Posting Description
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterValidateEvent', 'Posting Date', false, false)]
    /// <summary> 
    /// Description for OnAfterValidatePostingDate.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Purchase Header".</param>
    local procedure OnAfterValidatePostingDate(var Rec: Record "Purchase Header")
    var
        PurchaseLine: Record "purchase line";
    begin
        //V1.0.0
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", Rec."Document Type");
        PurchaseLine.SETRANGE(PurchaseLine."Document No.", Rec."No.");
        IF PurchaseLine.FINDFIRST THEN
            REPEAT
                PurchaseLine."Posting Date" := Rec."Posting Date";
                PurchaseLine.MODIFY;
            UNTIL PurchaseLine.NEXT = 0;
        //V1.0.0 
    end;


    //
    var
        FixedBasicPay: Boolean;
        CurrUserIsLeaveAdmin: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        UserSetup: Record "User Setup";
        IsMobileMoney: Boolean;
        IsBank: Boolean;
        HideValidationDialog: Boolean;
}
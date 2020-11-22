codeunit 50001 "System Customizations Collect"
{
    //Payment Journal Get the value for GL Name Field
    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnAfterValidateEvent', 'Account No.', true, true)]
    procedure modifyGlName(var Rec: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Reset();
        GLAccount.SetRange("No.", Rec."Account No.");
        if GLAccount.FindFirst() then
            rec."GL Name" := GLAccount.Name;
        Rec."Prepared by" := UserId;
    end;

    //General Journal Get the value for GL Name Field
    [EventSubscriber(ObjectType::Page, Page::"General Journal", 'OnAfterValidateEvent', 'Account No.', true, true)]
    procedure modifyGeneralJournal(var Rec: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Reset();
        GLAccount.SetRange("No.", Rec."Account No.");
        if GLAccount.FindFirst() then
            rec."GL Name" := GLAccount.Name;
        Rec."Prepared by" := UserId;
    end;

    //Cash Receipt Journal Get the value for GL Name Field
    [EventSubscriber(ObjectType::Page, Page::"Cash Receipt Journal", 'OnAfterValidateEvent', 'Account No.', true, true)]
    procedure modifyCashReceiptJournal(var Rec: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Reset();
        GLAccount.SetRange("No.", Rec."Account No.");
        if GLAccount.FindFirst() then
            rec."GL Name" := GLAccount.Name;
        Rec."Prepared by" := UserId;
    end;

    //Modifying the GL Name Field when the line is modified
    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnModifyRecordEvent', '', true, true)]
    local procedure ModifyOnEdit(var Rec: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        if Rec."Account No." <> '' then begin
            GLAccount.Reset();
            GLAccount.SetRange("No.", Rec."Account No.");
            if GLAccount.FindFirst() then
                rec."GL Name" := GLAccount.Name;
        end;
        Rec."Prepared by" := UserId;
    end;

    //

    //Posting into the General Ledger Entry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnBeforeInsertGLEntry', '', true, true)]
    procedure ModifyPostGLAcc(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean)
    begin

        GLEntry."Paid To/Received From" := GenJournalLine."Paid To/Received From";
        GLEntry."Approved by" := GenJournalLine."Approved by";
        GLEntry."Requested by" := GenJournalLine."Requested by";
        GLEntry."GL Name" := GenJournalLine."GL Name";
        GLEntry."Authorised by" := GenJournalLine."Authorised by";
        GLEntry."Reviewed by" := GenJournalLine."Reviewed by";
        GLEntry."Prepared by" := GenJournalLine."Prepared by";

    end;

    //POsting to the BankAccountLedgerEntry Table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeBankAccLedgEntryInsert', '', True, True)]
    local procedure ModifyPostBankAcc(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    begin
        BankAccountLedgerEntry."Authorised by" := GenJournalLine."Authorised by";
        BankAccountLedgerEntry."Reviewed by" := GenJournalLine."Reviewed by";
        BankAccountLedgerEntry."Paid To/Received From" := GenJournalLine."Paid To/Received From";
        BankAccountLedgerEntry."Requested by" := GenJournalLine."Requested by";
        BankAccountLedgerEntry."GL Name" := GenJournalLine."GL Name";
        BankAccountLedgerEntry."Approved by" := GenJournalLine."Approved by";
        BankAccountLedgerEntry."Prepared by" := GenJournalLine."Prepared by";
    end;

    //Posting the Transfer Reason in the Transfer shipment header.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', true, true)]
    local procedure PostTransferReasonShipmt(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    begin
        TransShptHeader."Transfer Reason" := TransHeader."Transfer Reason";
    end;


    //Posting the Transfer Reason in the Transfer shipment header.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', true, true)]
    local procedure PostTransferReasonRecpt(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."Transfer Reason" := TransferHeader."Transfer Reason";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptLine', '', true, true)]
    local procedure PostShipmentLines(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    begin
        //var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean
        TransShptLine."Transfer Reason" := TransLine."Transfer Reason";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', true, true)]
    local procedure PostReceiptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    begin
        TransRcptLine."Transfer Reason" := TransLine."Transfer Reason";
    end;


    //check for customer with distribution price group and compare balance due and credit limit DISTI
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    local procedure OnBeforeValidateEventSellToCustomerNo(var Rec: Record "Sales Header")
    var
        cust: Record Customer;
        ASL001: Label 'You cannot perfom this action on customer %1  %2 because its Outstanding balance is greater than the Credit limit';
        ASL002: Label 'VAT Registration Number Can not be empty for %1 - %2';
    begin
        cust.get(Rec."Sell-to Customer No.");
        Cust.CALCFIELDS("Outstanding Orders (LCY)");
        Cust.CALCFIELDS("Balance Due (LCY)");
        IF ((Rec."Document Type" = Rec."Document Type"::Invoice) OR (Rec."Document Type" = Rec."Document Type"::Order)) THEN BEGIN

            //Evaluating for Over Credit limit scenarios
            IF Cust."Allow Sale Beyond Credit limit" <> TRUE THEN BEGIN
                IF Cust."Customer Price Group" = 'DISTR' THEN BEGIN
                    IF Cust."Credit Limit (LCY)" <> 0 THEN BEGIN
                        IF ((Cust."Balance Due (LCY)") > Cust."Credit Limit (LCY)") THEN
                            ERROR(ASL001, Cust."No.", Cust.Name);
                    END;
                END;
            END;

            //Check for Mandatory VAT Registration Number
            if cust."TIN Mandatory" = true then begin
                if cust."VAT Registration No." = '' then begin
                    Error(ASL002, cust."No.", cust.Name);
                end;
            end;
        END;
    end;
    //check for customer with distribution price group and compare balance due and credit limit

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    local procedure OnAfterValidateEventBuyFromVendorNo(var Rec: Record "Purchase Header")
    var
        Vendor: Record Vendor;
        ASL001: Label 'VAT Registration Number Can not be empty for %1 - %2';
    begin
        Vendor.Get(Rec."Buy-from Vendor No.");
        if Vendor."TIN Mandatory" = true then begin
            if Vendor."VAT Registration No." = '' then begin
                Error(ASL001, Vendor."No.", Vendor.Name);
            end;
        end;
    end;



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

    var
        FixedBasicPay: Boolean;
        CurrUserIsLeaveAdmin: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        UserSetup: Record "User Setup";
        IsMobileMoney: Boolean;
        IsBank: Boolean;
        HideValidationDialog: Boolean;

}
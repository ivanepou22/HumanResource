codeunit 50002 "Customize Events"
{
    Permissions = TableData "Bank Account Ledger Entry" = rm,
                tabledata "Bank Account Statement Line" = rm,
                  TableData "Check Ledger Entry" = rm;

    var
        CheckLedgEntry: Record "Check Ledger Entry";

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnBeforeActionEvent', 'SendApprovalRequest', true, true)]
    local procedure OnBeforeActionSendRequest(var Rec: Record Customer)
    begin
        Rec.TestField("Customer Posting Group");
        Rec.TestField("Customer Price Group");
        Rec.TestField("Payment Terms Code");
        Rec.TestField("No.");
        Rec.TestField(Name);
    end;

    //UnApply customer entries
    procedure UnApplyCustLedgEntryPOS(CustLedgEntryNo: Integer;
           CustLedgEntryDocNo: Code[20])
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ApplicationEntryNo: Integer;
        UnapplyCustomerEntries: Codeunit "CustEntry-Apply Posted Entries";
        NoApplicationEntryErr: Label 'Cust. Ledger Entry No. %1 does not have an application entry.';
    begin
        UnapplyCustomerEntries.CheckReversal(CustLedgEntryNo);
        ApplicationEntryNo := UnapplyCustomerEntries.FindLastApplEntry(CustLedgEntryNo);
        IF ApplicationEntryNo = 0 THEN
            ERROR(NoApplicationEntryErr, CustLedgEntryNo);
        DtldCustLedgEntry.GET(ApplicationEntryNo);
        UnApplyCustomerPOS(DtldCustLedgEntry, CustLedgEntryDocNo);
    end;

    /// <summary> 
    /// Description for UnApplyCustomerPOS.
    /// </summary>
    /// <param name="DtldCustLedgEntry">Parameter of type Record "Detailed Cust. Ledg. Entry".</param>
    /// <param name="CustLedgEntryDocNo">Parameter of type Code[20].</param>
    procedure UnApplyCustomerPOS(DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; CustLedgEntryDocNo: Code[20])
    var
        UnapplyCustomerEntries: Codeunit "CustEntry-Apply Posted Entries";
    begin
        WITH DtldCustLedgEntry DO BEGIN
            TESTFIELD("Entry Type", "Entry Type"::Application);
            TESTFIELD(Unapplied, FALSE);
            // Do an automated unapplication
            UnapplyCustomerEntries.PostUnApplyCustomer(DtldCustLedgEntry, CustLedgEntryDocNo, DtldCustLedgEntry."Posting Date");

        END;
    end;

    procedure Updatedimenions()
    var
        myInt: Integer;
        employee: Record Employee;
        employeeDimensions: Record "Employee Comment Line";
    begin
        employee.Reset();
        employee.SetRange(employee."Status 1", employee."Status 1"::Active);
        employee.SetRange(employee."Payroll Status", employee."Payroll Status");
        if employee.FindFirst() then
            repeat
                employeeDimensions.Reset();
                employeeDimensions.SetRange(employeeDimensions."No.", employee."No.");
                if employeeDimensions.FindFirst() then begin
                    employeeDimensions."Shortcut Dimension 1 Code" := employee."Global Dimension 1 Code";
                    employeeDimensions."Shortcut Dimension 2 Code" := employee."Global Dimension 2 Code";
                    employeeDimensions.Modify();
                    Message(employee."No.");
                end;
            until employee.Next() = 0;

    end;

    //Making TIN mandatory on Customers.
    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnNewRecordEvent', '', true, true)]
    local procedure MandatoryVATRegistrationNo(var Rec: Record Customer)
    begin
        //.TestField("VAT Registration No.");
    end;

    //Making TIN mandatory on Vendors.
    [EventSubscriber(ObjectType::Page, Page::"Vendor Card", 'OnInsertRecordEvent', '', true, true)]
    local procedure MandatoryVATRegistrationNoVendor(var Rec: Record Vendor)
    begin
        Message('Hello');
        // Rec.TestField("VAT Registration No.");
    end;


    //Matching the difference with Bank account ledger entries.
    procedure MatchManually(var SelectedBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var SelectedBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        Relation: Option "One-to-One","One-to-Many";
    begin
        if SelectedBankAccReconciliationLine.FindFirst then begin
            BankAccReconciliationLine.get(
                SelectedBankAccReconciliationLine."Statement Type",
                  SelectedBankAccReconciliationLine."Bank Account No.",
                  SelectedBankAccReconciliationLine."Statement No.",
                  SelectedBankAccReconciliationLine."Statement Line No."
            );

            if SelectedBankAccountLedgerEntry.FindSet() then begin
                repeat
                    BankAccountLedgerEntry.Get(SelectedBankAccountLedgerEntry."Entry No.");
                    RemoveApplication(BankAccountLedgerEntry);
                    ApplyEntries(BankAccReconciliationLine, BankAccountLedgerEntry, Relation::"One-to-Many");
                until SelectedBankAccountLedgerEntry.Next() = 0;
            end;
        end;
    end;

    procedure RemoveMatch(var SelectedBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var SelectedBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";

    begin
        if SelectedBankAccReconciliationLine.FindSet then
            repeat
                BankAccReconciliationLine.Get(
                  SelectedBankAccReconciliationLine."Statement Type",
                  SelectedBankAccReconciliationLine."Bank Account No.",
                  SelectedBankAccReconciliationLine."Statement No.",
                  SelectedBankAccReconciliationLine."Statement Line No.");
                BankAccountLedgerEntry.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
                BankAccountLedgerEntry.SetRange("Statement No.", BankAccReconciliationLine."Statement No.");
                BankAccountLedgerEntry.SetRange("Statement Line No.", BankAccReconciliationLine."Statement Line No.");
                BankAccountLedgerEntry.SetRange(Open, true);
                BankAccountLedgerEntry.SetRange("Statement Status", BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied");
                if BankAccountLedgerEntry.FindSet then
                    repeat
                        RemoveApplication(BankAccountLedgerEntry);
                    until BankAccountLedgerEntry.Next = 0;
            until SelectedBankAccReconciliationLine.Next = 0;

        if SelectedBankAccountLedgerEntry.FindSet then
            repeat
                BankAccountLedgerEntry.Get(SelectedBankAccountLedgerEntry."Entry No.");
                RemoveApplication(BankAccountLedgerEntry);
            until SelectedBankAccountLedgerEntry.Next = 0;
    end;


    //


    procedure ApplyEntries(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var BankAccLedgEntry: Record "Bank Account Ledger Entry"; Relation: Option "One-to-One","One-to-Many"): Boolean
    begin

        BankAccLedgEntry.LockTable();
        CheckLedgEntry.LockTable();
        BankAccReconLine.LockTable();
        BankAccReconLine.Find;

        if BankAccLedgEntry.IsApplied then
            exit(false);

        if (Relation = Relation::"One-to-One") and (BankAccReconLine."Applied Entries" > 0) then
            exit(false);

        BankAccReconLine.TestField(Type, BankAccReconLine.Type::Difference);
        BankAccReconLine."Ready for Application" := true;
        SetReconNo(BankAccLedgEntry, BankAccReconLine);
        BankAccReconLine."Applied Amount" += BankAccLedgEntry."Remaining Amount";
        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
        BankAccReconLine.Validate("Statement Amount");
        //ModifyBankAccReconLine(BankAccReconLine);
        exit(true);
    end;

    procedure RemoveApplication(var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccLedgEntry.LockTable();
        CheckLedgEntry.LockTable();
        BankAccReconLine.LockTable();

        if not BankAccReconLine.Get(
             BankAccReconLine."Statement Type"::"Payment Application",
             BankAccLedgEntry."Bank Account No.",
             BankAccLedgEntry."Statement No.", BankAccLedgEntry."Statement Line No.")
        then
            exit;

        BankAccReconLine.TestField("Statement Type", BankAccReconLine."Statement Type"::"Payment Application");
        BankAccReconLine.TestField(Type, BankAccReconLine.Type::Difference);
        RemoveReconNo(BankAccLedgEntry, BankAccReconLine, true);

        BankAccReconLine."Applied Amount" -= BankAccLedgEntry."Remaining Amount";
        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" - 1;
        BankAccReconLine.Validate("Statement Amount");
        //ModifyBankAccReconLine(BankAccReconLine);
    end;

    local procedure ModifyBankAccReconLine(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        BankAccReconciliationLine.Modify();
    end;

    procedure SetReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line")
    begin
        BankAccLedgEntry.TestField(Open, true);
        BankAccLedgEntry.TestField("Statement Status", BankAccLedgEntry."Statement Status"::Open);
        BankAccLedgEntry.TestField("Statement No.", '');
        BankAccLedgEntry.TestField("Statement Line No.", 0);
        BankAccLedgEntry.TestField("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry."Statement Status" :=
          BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
        BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
        BankAccLedgEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
        BankAccLedgEntry."Difference Statement No." := BankAccReconLine."Statement No.";
        BankAccLedgEntry."Diff Statement Line No." := BankAccReconLine."Statement Line No.";
        BankAccLedgEntry.Modify();

        CheckLedgEntry.Reset();
        CheckLedgEntry.SetCurrentKey("Bank Account Ledger Entry No.");
        CheckLedgEntry.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SetRange(Open, true);
        if CheckLedgEntry.Find('-') then
            repeat
                CheckLedgEntry.TestField("Statement Status", CheckLedgEntry."Statement Status"::Open);
                CheckLedgEntry.TestField("Statement No.", '');
                CheckLedgEntry.TestField("Statement Line No.", 0);
                CheckLedgEntry."Statement Status" :=
                  CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.Modify();
            until CheckLedgEntry.Next = 0;
    end;

    procedure RemoveReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; Test: Boolean)
    begin
        BankAccLedgEntry.TestField(Open, true);
        if Test then begin
            BankAccLedgEntry.TestField(
              "Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
            BankAccLedgEntry.TestField("Statement No.", BankAccReconLine."Statement No.");
            BankAccLedgEntry.TestField("Statement Line No.", BankAccReconLine."Statement Line No.");
        end;
        BankAccLedgEntry.TestField("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Open;
        BankAccLedgEntry."Statement No." := '';
        BankAccLedgEntry."Statement Line No." := 0;
        BankAccLedgEntry."Difference Statement No." := '';
        BankAccLedgEntry."Diff Statement Line No." := 0;
        BankAccLedgEntry.Modify();

        CheckLedgEntry.Reset();
        CheckLedgEntry.SetCurrentKey("Bank Account Ledger Entry No.");
        CheckLedgEntry.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SetRange(Open, true);
        if CheckLedgEntry.Find('-') then
            repeat
                if Test then begin
                    CheckLedgEntry.TestField(
                      "Statement Status", CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                    CheckLedgEntry.TestField("Statement No.", '');
                    CheckLedgEntry.TestField("Statement Line No.", 0);
                end;
                CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Open;
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.Modify();
            until CheckLedgEntry.Next = 0;
    end;

    //Clearing Bank Statement Difference.
    procedure ClearPreviousDifferences(
        var
        CurrStatementNo: Code[30];
        CurrStatementBankAccount: Code[30];
        CurrStatementDate: Date
    )
    var
        BankAccountReconciliationLines: Record "Bank Acc. Reconciliation Line";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccStatementLine: Record "Bank Account Statement Line";
        ASL001: Label 'Difference Cleared Successfully';
    begin
        BankAccountLedgerEntry.Reset();
        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Bank Account No.", CurrStatementBankAccount);
        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry.Open, true);
        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Statement Status", BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied");
        BankAccountLedgerEntry.SetFilter(BankAccountLedgerEntry."Posting Date", '..%1', CurrStatementDate);
        BankAccountLedgerEntry.SetFilter(BankAccountLedgerEntry."Difference Statement No.", '<>%1', '');
        BankAccountLedgerEntry.SetFilter(BankAccountLedgerEntry."Diff Statement Line No.", '<>%1', 0);
        if BankAccountLedgerEntry.FindFirst() then begin
            repeat
                BankAccountLedgerEntry.Open := false;
                BankAccountLedgerEntry."Statement Status" := BankAccountLedgerEntry."Statement Status"::Closed;
                BankAccountLedgerEntry.Status := BankAccountLedgerEntry.Status::"Closed by Current Stmt.";
                BankAccountLedgerEntry."Open-to Date" := CurrStatementDate;
                BankAccountLedgerEntry."Diff Closing Statement Number" := CurrStatementNo;
                BankAccountLedgerEntry."Difference Closing Date" := CurrStatementDate;
                BankAccountLedgerEntry.Modify();

                BankAccountReconciliationLines.Reset();
                BankAccountReconciliationLines.SetRange(BankAccountReconciliationLines."Statement No.", BankAccountLedgerEntry."Difference Statement No.");
                BankAccountReconciliationLines.SetRange(BankAccountReconciliationLines."Statement Line No.", BankAccountLedgerEntry."Diff Statement Line No.");
                if BankAccountReconciliationLines.FindFirst() then begin
                    BankAccountReconciliationLines.Cleared := true;
                    BankAccountReconciliationLines.Clear := true;
                    BankAccountReconciliationLines."Cleared Date" := CurrStatementDate;
                    BankAccountReconciliationLines."Diff Closing Statement Number" := CurrStatementNo;
                    BankAccountReconciliationLines."Difference Closing Date" := CurrStatementDate;
                    BankAccountReconciliationLines.Modify();
                end;
                //TCSa804203241063634
                BankAccStatementLine.Reset();
                BankAccStatementLine.SetRange(BankAccStatementLine."Bank Account No.", CurrStatementBankAccount);
                BankAccStatementLine.SetRange(BankAccStatementLine."Statement No.", BankAccountLedgerEntry."Difference Statement No.");
                BankAccStatementLine.SetRange(BankAccStatementLine."Statement Line No.", BankAccountLedgerEntry."Diff Statement Line No.");
                if BankAccStatementLine.FindFirst() then begin
                    BankAccStatementLine.Clear := true;
                    BankAccStatementLine.Cleared := true;
                    BankAccStatementLine."Cleared Date" := CurrStatementDate;
                    BankAccStatementLine."Diff Closing Statement Number" := CurrStatementNo;
                    BankAccStatementLine."Difference Closing Date" := CurrStatementDate;
                    BankAccStatementLine.Modify();
                end;
            until BankAccountLedgerEntry.Next() = 0;
            Message(ASL001);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Return Order", 'OnBeforeActionEvent', 'Post', true, true)]
    local procedure CheckforSalesPersion(var Rec: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        Rec.TestField("Salesperson Code");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Return Order", 'OnBeforeActionEvent', 'Preview Posting', true, true)]
    local procedure CheckforSalesPersion2(var Rec: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        Rec.TestField("Salesperson Code");
    end;
}
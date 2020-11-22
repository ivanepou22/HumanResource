codeunit 50013 "PayrollJnlPost Line"
{
    Permissions = TableData "Res. Ledger Entry" = imd,
                  TableData "Resource Register" = imd,
                  TableData "Time Sheet Line" = m,
                  TableData "Time Sheet Detail" = m;
    TableNo = "Res. Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;
        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ResJnlLine: Record "Res. Journal Line";
        ResLedgEntry: Record "Payroll Journal Lines";
        Res: Record Resource;
        ResReg: Record "Resource Register";
        GenPostingSetup: Record "General Posting Setup";
        ResUOM: Record "Resource Unit of Measure";
        ResJnlCheckLine: Codeunit "Res. Jnl.-Check Line";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;

    procedure RunWithCheck(var ResJnlLine2: Record "Res. Journal Line")
    begin
        ResJnlLine.Copy(ResJnlLine2);
        Code;
        ResJnlLine2 := ResJnlLine;
    end;

    local procedure "Code"()
    var
        IsHandled: Boolean;
    begin
        OnBeforePostResJnlLine(ResJnlLine);

        with ResJnlLine do begin
            if EmptyLine then
                exit;

            ResJnlCheckLine.RunCheck(ResJnlLine);

            if NextEntryNo = 0 then begin
                ResLedgEntry.LockTable();
                NextEntryNo := ResLedgEntry.GetLastEntryNo() + 1;
            end;

            if "Document Date" = 0D then
                "Document Date" := "Posting Date";

            if ResReg."No." = 0 then begin
                ResReg.LockTable();
                if (not ResReg.FindLast) or (ResReg."To Entry No." <> 0) then begin
                    ResReg.Init();
                    ResReg."No." := ResReg."No." + 1;
                    ResReg."From Entry No." := NextEntryNo;
                    ResReg."To Entry No." := NextEntryNo;
                    ResReg."Creation Date" := Today;
                    ResReg."Creation Time" := Time;
                    ResReg."Source Code" := "Source Code";
                    ResReg."Journal Batch Name" := "Journal Batch Name";
                    ResReg."User ID" := UserId;
                    ResReg.Insert();
                end;
            end;
            ResReg."To Entry No." := NextEntryNo;
            ResReg.Modify();

            Res.Get("Resource No.");
            Res.CheckResourcePrivacyBlocked(true);

            IsHandled := false;
            OnBeforeCheckResourceBlocked(Res, IsHandled);
            if not IsHandled then
                Res.TestField(Blocked, false);

            IsHandled := false;
            OnBeforeGenPostingSetupGet(ResJnlLine, IsHandled);
            if not IsHandled then
                if (GenPostingSetup."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") or
                    (GenPostingSetup."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group")
                then
                    GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");

            "Resource Group No." := Res."Resource Group No.";

            //ResLedgEntry.Init();
            //ResLedgEntry.CopyFromResJnlLine(ResJnlLine);
            if ("Entry Type Payroll" = "Entry Type Payroll"::"Payroll Entry") then begin
                ResLedgEntry.Init();
                ResLedgEntry."Entry Type" := "Entry Type";
                ResLedgEntry."Entry Type Payroll" := "Entry Type Payroll";
                ResLedgEntry."Document No." := "Document No.";
                ResLedgEntry."External Document No." := "External Document No.";
                ResLedgEntry."Order Type" := "Order Type";
                ResLedgEntry."Order No." := "Order No.";
                ResLedgEntry."Order Line No." := "Order Line No.";
                ResLedgEntry."Posting Date" := "Posting Date";
                ResLedgEntry."Document Date" := "Document Date";
                ResLedgEntry."Resource No." := "Resource No.";
                ResLedgEntry."Resource Group No." := "Resource Group No.";
                ResLedgEntry.Description := Description;
                ResLedgEntry."Work Type Code" := "Work Type Code";
                ResLedgEntry."Job No." := "Job No.";
                ResLedgEntry."Unit of Measure Code" := "Unit of Measure Code";
                ResLedgEntry.Quantity := Quantity;
                ResLedgEntry."Direct Unit Cost" := "Direct Unit Cost";
                ResLedgEntry."Unit Cost" := "Unit Cost";
                ResLedgEntry."Total Cost" := "Total Cost";
                ResLedgEntry."Unit Price" := "Unit Price";
                ResLedgEntry."Total Price" := "Total Price";
                ResLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                ResLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                ResLedgEntry."Dimension Set ID" := "Dimension Set ID";
                ResLedgEntry."Source Code" := "Source Code";
                ResLedgEntry."Journal Batch Name" := "Journal Batch Name";
                ResLedgEntry."Reason Code" := "Reason Code";
                ResLedgEntry."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                ResLedgEntry."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                ResLedgEntry."No. Series" := "Posting No. Series";
                ResLedgEntry."Source Type" := "Source Type";
                ResLedgEntry."Source No." := "Source No.";
                ResLedgEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                ResLedgEntry."Payroll Entry Type" := "Payroll Entry Type";
                ResLedgEntry."Taxable/Pre-Tax Deductible" := "Taxable/Pre-Tax Deductible";
                ResLedgEntry."ED Code" := "ED Code";
                ResLedgEntry."Employee Statistics Group" := "Employee Statistics Group";
                ResLedgEntry."Currency Code" := "Currency Code";
                ResLedgEntry."Currency Factor" := "Currency Factor";
                ResLedgEntry.Amount := Amount;
                ResLedgEntry."Parent Code" := "Parent Code";
                ResLedgEntry."Amount (LCY)" := "Amount (LCY)";
                ResLedgEntry."Employer Amount" := "Employer Amount";
                ResLedgEntry."Employer Amount (LCY)" := "Employer Amount (LCY)";
                ResLedgEntry."Period Closed" := "Period Closed";
                ResLedgEntry."Payroll Item Type" := "Payroll Item Type";
                ResLedgEntry."Shortcut Dimension 03" := "Shortcut Dimension 3 Code";
                ResLedgEntry."Shortcut Dimension 04" := "Shortcut Dimension 4 Code";
                ResLedgEntry."Shortcut Dimension 05" := "Shortcut Dimension 5 Code";
                ResLedgEntry."Shortcut Dimension 06" := "Shortcut Dimension 6 Code";
                ResLedgEntry."Shortcut Dimension 07" := "Shortcut Dimension 7 Code";
                ResLedgEntry."Shortcut Dimension 08" := "Shortcut Dimension 8 Code";
            end else begin // ASL HRM 1.0.0
                ResLedgEntry.Init();
                ResLedgEntry."Entry Type" := "Entry Type";
                ResLedgEntry."Entry Type Payroll" := "Entry Type Payroll";
                ResLedgEntry."Document No." := "Document No.";
                ResLedgEntry."External Document No." := "External Document No.";
                ResLedgEntry."Order Type" := "Order Type";
                ResLedgEntry."Order No." := "Order No.";
                ResLedgEntry."Order Line No." := "Order Line No.";
                ResLedgEntry."Posting Date" := "Posting Date";
                ResLedgEntry."Document Date" := "Document Date";
                ResLedgEntry."Resource No." := "Resource No.";
                ResLedgEntry."Resource Group No." := "Resource Group No.";
                ResLedgEntry.Description := Description;
                ResLedgEntry."Work Type Code" := "Work Type Code";
                ResLedgEntry."Job No." := "Job No.";
                ResLedgEntry."Unit of Measure Code" := "Unit of Measure Code";
                ResLedgEntry.Quantity := Quantity;
                ResLedgEntry."Direct Unit Cost" := "Direct Unit Cost";
                ResLedgEntry."Unit Cost" := "Unit Cost";
                ResLedgEntry."Total Cost" := "Total Cost";
                ResLedgEntry."Unit Price" := "Unit Price";
                ResLedgEntry."Total Price" := "Total Price";
                ResLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                ResLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                ResLedgEntry."Dimension Set ID" := "Dimension Set ID";
                ResLedgEntry."Source Code" := "Source Code";
                ResLedgEntry."Journal Batch Name" := "Journal Batch Name";
                ResLedgEntry."Reason Code" := "Reason Code";
                ResLedgEntry."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                ResLedgEntry."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                ResLedgEntry."No. Series" := "Posting No. Series";
                ResLedgEntry."Source Type" := "Source Type";
                ResLedgEntry."Source No." := "Source No.";
                ResLedgEntry."Parent Code" := "Parent Code";
                ResLedgEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                ResLedgEntry."Shortcut Dimension 03" := "Shortcut Dimension 3 Code";
                ResLedgEntry."Shortcut Dimension 04" := "Shortcut Dimension 4 Code";
                ResLedgEntry."Shortcut Dimension 05" := "Shortcut Dimension 5 Code";
                ResLedgEntry."Shortcut Dimension 06" := "Shortcut Dimension 6 Code";
                ResLedgEntry."Shortcut Dimension 07" := "Shortcut Dimension 7 Code";
                ResLedgEntry."Shortcut Dimension 08" := "Shortcut Dimension 8 Code";
            end;

            IF ("Entry Type Payroll" = "Entry Type Payroll"::"Pending Payroll Item") then begin
                ResLedgEntry."Payroll Entry Type" := "Payroll Entry Type";
                ResLedgEntry."ED Code" := "ED Code";
            end;

            GetGLSetup;
            ResLedgEntry."Total Cost" := Round(ResLedgEntry."Total Cost");
            ResLedgEntry."Total Price" := Round(ResLedgEntry."Total Price");
            if ResLedgEntry."Entry Type Payroll" = ResLedgEntry."Entry Type Payroll"::Sale then begin
                ResLedgEntry.Quantity := -ResLedgEntry.Quantity;
                ResLedgEntry."Total Cost" := -ResLedgEntry."Total Cost";
                ResLedgEntry."Total Price" := -ResLedgEntry."Total Price";
            end;
            ResLedgEntry."Direct Unit Cost" := Round(ResLedgEntry."Direct Unit Cost", GLSetup."Unit-Amount Rounding Precision");
            ResLedgEntry."User ID" := UserId;
            ResLedgEntry."Entry No." := NextEntryNo;
            ResUOM.Get(ResLedgEntry."Resource No.", ResLedgEntry."Unit of Measure Code");
            if ResUOM."Related to Base Unit of Meas." then
                ResLedgEntry."Quantity (Base)" := ResLedgEntry.Quantity * ResLedgEntry."Qty. per Unit of Measure";

            if ResLedgEntry."Entry Type Payroll" = ResLedgEntry."Entry Type Payroll"::Usage then begin
                PostTimeSheetDetail(ResJnlLine, ResLedgEntry."Quantity (Base)");
                ResLedgEntry.Chargeable := IsChargable(ResJnlLine, ResLedgEntry.Chargeable);
            end;

            OnBeforeResLedgEntryInsert(ResLedgEntry, ResJnlLine);

            ResLedgEntry.Insert(true);

            NextEntryNo := NextEntryNo + 1;
        end;

        OnAfterPostResJnlLine(ResJnlLine);
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get();
        GLSetupRead := true;
    end;

    local procedure PostTimeSheetDetail(ResJnlLine2: Record "Res. Journal Line"; QtyToPost: Decimal)
    var
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetDetail: Record "Time Sheet Detail";
        TimeSheetMgt: Codeunit "Time Sheet Management";
    begin
        with ResJnlLine2 do
            if "Time Sheet No." <> '' then begin
                TimeSheetDetail.Get("Time Sheet No.", "Time Sheet Line No.", "Time Sheet Date");
                TimeSheetDetail."Posted Quantity" += QtyToPost;
                TimeSheetDetail.Posted := TimeSheetDetail.Quantity = TimeSheetDetail."Posted Quantity";
                TimeSheetDetail.Modify();
                TimeSheetLine.Get("Time Sheet No.", "Time Sheet Line No.");
                TimeSheetMgt.CreateTSPostingEntry(TimeSheetDetail, Quantity, "Posting Date", "Document No.", TimeSheetLine.Description);

                TimeSheetDetail.SetRange("Time Sheet No.", "Time Sheet No.");
                TimeSheetDetail.SetRange("Time Sheet Line No.", "Time Sheet Line No.");
                TimeSheetDetail.SetRange(Posted, false);
                if TimeSheetDetail.IsEmpty then begin
                    TimeSheetLine.Posted := true;
                    TimeSheetLine.Modify();
                end;
            end;
    end;

    local procedure IsChargable(ResJournalLine: Record "Res. Journal Line"; Chargeable: Boolean): Boolean
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        if ResJournalLine."Time Sheet No." <> '' then begin
            TimeSheetLine.Get(ResJournalLine."Time Sheet No.", ResJournalLine."Time Sheet Line No.");
            exit(TimeSheetLine.Chargeable);
        end;
        exit(Chargeable);
    end;

    procedure InsertPayrollPeriod(DateofPosting: Date; StatisticsGroup: Code[10]; VAR ResourceLedgerEntry: Record "Payroll Journal Lines")
    var
        EntryNumber: Integer;
    begin
        ResourceLedgerEntry.RESET;
        IF ResourceLedgerEntry.FINDLAST THEN
            EntryNumber := ResourceLedgerEntry."Entry No." + 1
        ELSE
            EntryNumber := 1;
        ResourceLedgerEntry.INIT;
        ResourceLedgerEntry."Entry No." := EntryNumber;
        ResourceLedgerEntry."Entry Type Payroll" := ResourceLedgerEntry."Entry Type Payroll"::"Payroll Period";
        ResourceLedgerEntry."Employee Statistics Group" := StatisticsGroup;
        ResourceLedgerEntry."Posting Date" := DateofPosting;
        ResourceLedgerEntry.INSERT;
    end;

    procedure ModifyPayrollPeriod(VAR ResourceLedgerEntry: Record "Payroll Journal Lines")
    var
        myInt: Integer;
    begin
        ResourceLedgerEntry."Period Closed" := false;
        ResourceLedgerEntry.MODIFY;
    end;

    procedure ReopenLastClosedPayrollPeriod(PayrollDate: Date)
    var
        ResourceLedgerEntry: Record "Payroll Journal Lines";
    begin
        ResourceLedgerEntry.RESET;
        ResourceLedgerEntry.SETRANGE(ResourceLedgerEntry."Entry Type Payroll", ResourceLedgerEntry."Entry Type Payroll"::"Payroll Period");
        ResourceLedgerEntry.SETRANGE(ResourceLedgerEntry."Posting Date", PayrollDate);
        IF ResourceLedgerEntry.FIND('-') THEN BEGIN
            ResourceLedgerEntry.DELETE;
        END;

        ResourceLedgerEntry.RESET;
        ResourceLedgerEntry.SETRANGE(ResourceLedgerEntry."Entry Type Payroll", ResourceLedgerEntry."Entry Type Payroll"::"Payroll Entry");
        ResourceLedgerEntry.SETRANGE(ResourceLedgerEntry."Posting Date", PayrollDate);
        IF ResourceLedgerEntry.FIND('-') THEN BEGIN
            ResourceLedgerEntry.DELETEALL;
        END;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckResourceBlocked(Resource: Record Resource; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostResJnlLine(var ResJournalLine: Record "Res. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostResJnlLine(var ResJournalLine: Record "Res. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGenPostingSetupGet(var ResJournalLine: Record "Res. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeResLedgEntryInsert(var ResLedgerEntry: Record "Payroll Journal Lines"; ResJournalLine: Record "Res. Journal Line")
    begin
    end;
}


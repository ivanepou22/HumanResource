codeunit 50003 "Mandatory Invoice Application"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCode', '', true, true)]
    procedure MandatoryApplication(var GenJnlLine: Record "Gen. Journal Line")
    var
        Customer: Record Customer;
        Balancing: Boolean;
        IsTransactionConsistent: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        ApplyToCustomerLedgerEntries: Record "Cust. Ledger Entry";
        TotalAmountToApply: Decimal;
        UnAppliedAmount: Decimal;
        Vendor: Record Vendor;
        ApplyToVendorLedgerEntries: Record "Vendor Ledger Entry";
    begin
        //----------- ASL V1.0.0 Check for Mandatory Application of Receipts and Payments-----------------
        SalesSetup.GET;
        PurchSetup.GET;
        IF (SalesSetup."Payment-Invoice App. Mandatory") THEN BEGIN
            IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) OR (GenJnlLine."Document Type" = GenJnlLine."Document Type"::" ")) THEN
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) OR (GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Customer) THEN BEGIN
                    IF Customer.GET(GenJnlLine."Account No.") OR Customer.GET(GenJnlLine."Bal. Account No.") THEN BEGIN
                        TotalAmountToApply := 0;
                        ApplyToCustomerLedgerEntries.RESET;
                        ApplyToCustomerLedgerEntries.SETCURRENTKEY("Customer No.", "Document No.", "Applies-to Doc. Type",
                                                                   "Applies-to Doc. No.", "Applies-to ID");
                        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) THEN
                            ApplyToCustomerLedgerEntries.SETRANGE(ApplyToCustomerLedgerEntries."Customer No.", GenJnlLine."Account No.")
                        ELSE
                            IF (GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Customer) THEN
                                ApplyToCustomerLedgerEntries.SETRANGE(ApplyToCustomerLedgerEntries."Customer No.", GenJnlLine."Bal. Account No.");
                        IF (GenJnlLine."Applies-to Doc. No." <> '') OR (GenJnlLine."Applies-to ID" <> '') THEN BEGIN
                            IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                                ApplyToCustomerLedgerEntries.SETRANGE(ApplyToCustomerLedgerEntries."Document No.", GenJnlLine."Applies-to Doc. No.");
                                IF ApplyToCustomerLedgerEntries.FIND('-') THEN BEGIN
                                    ApplyToCustomerLedgerEntries.CALCFIELDS(ApplyToCustomerLedgerEntries.Amount);
                                    TotalAmountToApply := ApplyToCustomerLedgerEntries.Amount;
                                END;
                            END ELSE
                                IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                                    ApplyToCustomerLedgerEntries.SETRANGE(ApplyToCustomerLedgerEntries."Applies-to ID", GenJnlLine."Applies-to ID");
                                    IF ApplyToCustomerLedgerEntries.FIND('-') THEN BEGIN
                                        ApplyToCustomerLedgerEntries.CALCSUMS(ApplyToCustomerLedgerEntries."Amount to Apply");
                                        TotalAmountToApply := ApplyToCustomerLedgerEntries."Amount to Apply";
                                    END;
                                END;
                        END;
                        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) THEN
                            UnAppliedAmount := (GenJnlLine.Amount + TotalAmountToApply)
                        ELSE
                            IF (GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Customer) THEN
                                UnAppliedAmount := (-GenJnlLine.Amount + TotalAmountToApply);

                        IF UnAppliedAmount < 0 THEN
                            ERROR('You must apply the whole amount in journal line Batch %1 Document No. %2. Unapplied Amount: %3',
                                GenJnlLine."Journal Batch Name", GenJnlLine."Document No.", UnAppliedAmount);
                    END;
                END;
        END;

        IF (PurchSetup."Payment-Invoice App. Mandatory") THEN BEGIN
            IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) OR (GenJnlLine."Document Type" = GenJnlLine."Document Type"::" ")) THEN
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) OR (GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Vendor) THEN BEGIN
                    IF Vendor.GET(GenJnlLine."Account No.") OR Vendor.GET(GenJnlLine."Bal. Account No.") THEN BEGIN
                        TotalAmountToApply := 0;
                        ApplyToVendorLedgerEntries.RESET;
                        ApplyToVendorLedgerEntries.SETCURRENTKEY("Vendor No.", "Document No.", "Applies-to Doc. Type",
                                                                    "Applies-to Doc. No.", "Applies-to ID");
                        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) THEN
                            ApplyToVendorLedgerEntries.SETRANGE(ApplyToVendorLedgerEntries."Vendor No.", GenJnlLine."Account No.")
                        ELSE
                            IF (GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Vendor) THEN
                                ApplyToVendorLedgerEntries.SETRANGE(ApplyToVendorLedgerEntries."Vendor No.", GenJnlLine."Bal. Account No.");
                        IF (GenJnlLine."Applies-to Doc. No." <> '') OR (GenJnlLine."Applies-to ID" <> '') THEN BEGIN
                            IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                                ApplyToVendorLedgerEntries.SETRANGE(ApplyToVendorLedgerEntries."Document No.", GenJnlLine."Applies-to Doc. No.");
                                IF ApplyToVendorLedgerEntries.FIND('-') THEN BEGIN
                                    ApplyToVendorLedgerEntries.CALCFIELDS(ApplyToVendorLedgerEntries.Amount);
                                    TotalAmountToApply := ApplyToVendorLedgerEntries.Amount;
                                END;
                            END ELSE
                                IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                                    ApplyToVendorLedgerEntries.SETRANGE(ApplyToVendorLedgerEntries."Applies-to ID", GenJnlLine."Applies-to ID");
                                    IF ApplyToVendorLedgerEntries.FIND('-') THEN BEGIN
                                        ApplyToVendorLedgerEntries.CALCSUMS(ApplyToVendorLedgerEntries."Amount to Apply");
                                        TotalAmountToApply := ApplyToVendorLedgerEntries."Amount to Apply";
                                    END;
                                END;
                        END;
                        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) THEN
                            UnAppliedAmount := (GenJnlLine.Amount + TotalAmountToApply)
                        ELSE
                            IF (GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Vendor) THEN
                                UnAppliedAmount := (-GenJnlLine.Amount + TotalAmountToApply);

                        IF UnAppliedAmount > 0 THEN
                            ERROR('You must apply the whole amount in journal line Batch %1 Document No. %2. Unapplied Amount: %3',
                                GenJnlLine."Journal Batch Name", GenJnlLine."Document No.", UnAppliedAmount);
                    END;
                END;
        END;
        //----------- ASL V1.0.0 Check for Mandatory Application of Receipts and Payments-----------------
    end;

    //POsting custom fields

}

tableextension 50037 "Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        // Add changes to table fields here
    }

    var
        ItemJournalLineTemp: Record "Item Journal Line";

    procedure TransferJournalToInventory(ItemJnlLine: Record "Item Journal Line")
    var
        Store: Record "Voucher And Receipt";
        Store1: Record "Voucher And Receipt";
        Store2: Record "Voucher And Receipt";
        Store3: Record "Voucher And Receipt";
        LineNo: Integer;
    begin
        Store3.RESET;
        Store3.SETRANGE(Store3."Document Type", Store3."Document Type"::"Store Voucher");
        Store3.SETRANGE(Store3."Journal Template Name", ItemJnlLine."Journal Template Name");
        Store3.SETRANGE(Store3."Journal Batch Name", ItemJnlLine."Journal Batch Name");
        Store3.SETRANGE(Store3."No.", ItemJnlLine."Document No.");
        IF Store3.FINDSET THEN
            REPEAT
                Store3.DELETEALL;
            UNTIL Store3.NEXT = 0;

        Store2.RESET;
        Store2.SETRANGE(Store2."Document Type", Store2."Document Type"::"Store Voucher");
        Store2.SETRANGE(Store2."Journal Template Name", ItemJnlLine."Journal Template Name");
        Store2.SETRANGE(Store2."Journal Batch Name", ItemJnlLine."Journal Batch Name");
        Store2.SETRANGE(Store2."No.", ItemJnlLine."Document No.");
        IF NOT Store2.FINDFIRST THEN BEGIN
            RESET;
            SETRANGE("Journal Template Name", ItemJnlLine."Journal Template Name");
            SETRANGE("Journal Batch Name", ItemJnlLine."Journal Batch Name");
            SETRANGE("Document No.", ItemJnlLine."Document No.");
            IF FINDFIRST THEN
                REPEAT
                    Store1.RESET;
                    Store1.SETFILTER("No.", '=%1', ItemJnlLine."Document No.");
                    Store1.SETFILTER("Line No.", '<>%1', 0);
                    IF Store1.FINDLAST THEN
                        LineNo := Store1."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    Store.INIT;
                    Store.VALIDATE(Store."Document Type", Store."Document Type"::"Store Voucher");
                    Store.VALIDATE(Store."No.", "Document No.");
                    Store.VALIDATE(Store."Journal Template Name", "Journal Template Name");
                    Store.VALIDATE(Store."Journal Batch Name", "Journal Batch Name");
                    Store.VALIDATE(Store."Item Journal Template Name", "Journal Template Name");
                    Store.VALIDATE(Store."Item Journal Batch Name", "Journal Batch Name");
                    Store.VALIDATE(Store."Document Line No.", 0);
                    Store.VALIDATE(Store."Line No.", LineNo);
                    Store.VALIDATE(Store.Date, WORKDATE);
                    Store.VALIDATE(Store.Item, "Item No.");
                    Store.VALIDATE(Store.Code, '');
                    Store.VALIDATE(Store.Comment, '');
                    Store.VALIDATE(Store."Posting Date", "Posting Date");
                    Store.VALIDATE(Store."Document Date", "Document Date");
                    Store.VALIDATE(Store."External Doc. No.", "External Document No.");
                    Store.VALIDATE(Store.Description, Description);
                    Store.VALIDATE(Store."Unit of Measure Code", "Unit of Measure Code");
                    Store.VALIDATE(Store.Branch, "Location Code");
                    Store.VALIDATE(Store."Item Quantity", Quantity);
                    Store.VALIDATE(Store."Unit Cost", "Unit Cost");
                    Store.VALIDATE(Store.Amount, Amount);
                    Store.VALIDATE(Store."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    Store.VALIDATE(Store."Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    Store.VALIDATE(Store."Journal Batch Name", "Journal Batch Name");
                    Store.VALIDATE(Store.User, USERID);
                    Store.VALIDATE(Store."To Post", TRUE);
                    Store.INSERT(TRUE);
                UNTIL NEXT = 0;
        END;
    end;

    procedure SetReceiptToPosted(JournalDocumentNo: Code[20])
    var
        ReceiptHeader: Record "Voucher And Receipt";
    begin
        ReceiptHeader.RESET;
        ReceiptHeader.SETRANGE("Document Type", ReceiptHeader."Document Type"::"Store Voucher");
        ReceiptHeader.SETRANGE("No.", JournalDocumentNo);
        ReceiptHeader.SETRANGE(ReceiptHeader.Posted, FALSE);
        IF ReceiptHeader.FINDFIRST THEN BEGIN
            ReceiptHeader.Posted := TRUE;
            ReceiptHeader.MODIFY;
        END;
    end;

    procedure SetItemJournalToPosted()
    var
        ItemVoucher: Record "Voucher And Receipt";
    begin
        ItemVoucher.RESET;
        ItemVoucher.SETRANGE("Document Type", ItemVoucher."Document Type"::"Store Voucher");
        ItemVoucher.SETRANGE("No.", "Document No.");
        IF ItemVoucher.FINDFIRST THEN
            REPEAT
                ItemVoucher.Posted := TRUE;
                ItemVoucher.MODIFY;
            UNTIL ItemVoucher.NEXT = 0;
    end;

    procedure InsertStoreVoucher()
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalLineCopy: Record "Item Journal Line";
        ItemJournalLineTemp: Record "Item Journal Line";
        Count: Integer;
        Count2: Integer;
        DocumentNoMin: Code[20];
        DocumentNoMax: Code[20];
    begin
        ItemJournalLineCopy.RESET;
        ItemJournalLineCopy.COPY(Rec);
        ItemJournalLineCopy.COPYFILTERS(Rec);
        Count := ItemJournalLineCopy.COUNT;
        Count2 := ItemJournalLineCopy.COUNT;
        ItemJournalLineTemp.INIT;
        REPEAT
            IF (Count = Count2) THEN
                DocumentNoMax := ItemJournalLineCopy."Document No.";
            IF (Count = 1) THEN
                DocumentNoMin := ItemJournalLineCopy."Document No.";

            ItemJournalLine.TransferJournalToInventory(ItemJournalLineCopy);
            ItemJournalLineTemp.TRANSFERFIELDS(ItemJournalLineCopy, TRUE);
            ItemJournalLineTemp.INSERT;
            Count -= 1;
        UNTIL (ItemJournalLineCopy.NEXT = 0) OR (Count = 0);
        COMMIT;
    end;

    procedure ChangeStoreVoucherStatus(Print: Boolean)
    var
        StoreVoucher: Record "Voucher And Receipt";
        ItemIssueVoucher: Report "Inventory Issue Note";
    begin
        StoreVoucher.RESET;
        StoreVoucher.SETRANGE("Document Type", StoreVoucher."Document Type"::"Store Voucher");
        StoreVoucher.SETRANGE("To Post", TRUE);
        IF StoreVoucher.FINDFIRST THEN
            REPEAT
                StoreVoucher.Posted := TRUE;
                StoreVoucher."To Post" := FALSE;
                StoreVoucher.MODIFY;
                IF Print THEN BEGIN
                    ItemIssueVoucher.SetDocumentNo(StoreVoucher."No.");
                    ItemIssueVoucher.USEREQUESTPAGE(FALSE);
                    ItemIssueVoucher.RUN;
                END;
            UNTIL StoreVoucher.NEXT = 0;
    end;
}
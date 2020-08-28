tableextension 50034 "Purchase Header Ext" extends "Purchase Header"
{

    fields
    {
        field(50000; "Contract Purch. Agreement No."; Code[20])
        {
        }
        field(50001; "Raw Milk"; Boolean)
        {
        }
        field(50002; "Warm Milk"; Boolean)
        {
        }
        field(50003; "Making Adjustments"; Boolean)
        {
        }
        field(50010; "Certificate No."; Code[20])
        {
        }
        field(50020; "LPA No."; Code[20])
        {
        }
        field(50030; "Order Type"; Option)
        {
            OptionMembers = Order,"Contract Purchase Agreement","Local Purchase Agreement";
        }
        field(50036; "WHT Exempt"; Boolean)
        {
            trigger OnValidate()
            var
                PurchaseLines: Record "Purchase Line";
            begin
                // IF CONFIRM(ASLT0001) THEN BEGIN
                //     PurchaseLines.RESET;
                //     PurchaseLines.SETRANGE(PurchaseLines."Document Type", "Document Type");
                //     PurchaseLines.SETRANGE(PurchaseLines."Document No.", "No.");
                //     IF PurchaseLines.FINDFIRST THEN
                //         REPEAT
                //             PurchaseLines.VALIDATE(PurchaseLines."WHT Exempt");
                //             PurchaseLines.MODIFY;
                //         UNTIL PurchaseLines.NEXT = 0;
                // END;
            end;
        }
        field(50037; "WHT Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum ("Purchase Line"."WHT Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "WHT Exempt" = CONST(false)));
        }
        field(50040; "Invoiced Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum ("Detailed Vendor Ledg. Entry".Amount WHERE("Document Type" = CONST(Invoice), "Contract Purch. Agreement No." = FIELD("No.")));
            Editable = false;
        }
        field(50050; "Paid Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Vendor Ledg. Entry".Amount WHERE("Document Type" = CONST(Payment), "Contract Purch. Agreement No." = FIELD("No.")));
        }
        field(50060; "Commited Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum ("Purchase Line"."Amount Including VAT" WHERE("Order Type" = CONST("Local Purchase Agreement"), "CPA No." = FIELD("No.")));
        }
        field(50070; "Uninvoiced Amount"; Decimal)
        {
        }
        field(50100; "Purchase Vendor No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF ("Purchase Vendor No." <> '') THEN IF VendorRecord.GET("Purchase Vendor No.") THEN VALIDATE("Purchase Vendor Name", VendorRecord.Name);
                // Validate("Buy-from Vendor No.", "Purchase Vendor No.");
                // Validate("Buy-from Vendor Name", "Purchase Vendor Name");
            end;
        }
        field(50110; "Purchase Vendor Name"; Text[50])
        {
        }
        field(50810; "Description"; Text[50])
        {
        }
        field(50820; "Vehicle Nos."; Code[20])
        {
            TableRelation = "Fixed Asset";
        }
        field(50830; "Resource No."; Code[20])
        {
            TableRelation = Resource WHERE(Type = CONST(Person));
        }
        field(50840; "Last Trip Number"; Code[20])
        {
        }
        field(50850; "Last Milage Reading"; Decimal)
        {
        }
        field(50860; "Created By"; Code[20])
        {
        }
        field(50870; "Date Created"; Date)
        {
        }
        field(50880; "Last Date Modified"; Date)
        {
        }
        field(50890; "Last Modified By"; Code[20])
        {
        }
        field(50900; "Fleet Status"; Option)
        {
            OptionMembers = Open,Posted;
        }
        field(50910; "Authorising Officer"; Text[30])
        {
        }
        field(50920; "Authorised"; Boolean)
        {
        }
        field(50921; "Fleet"; Boolean)
        {
        }
        field(50922; "Requisition Type"; Option)
        {
            OptionMembers = " ",Service,Stores,Advance,Contract,Item;
        }
        field(50940; "WHT Taxable Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Purchase Line"."WHT Taxable Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(50950; "Reference No."; Code[20])
        {
        }
        field(50960; "Vehicle No."; Code[20])
        {
        }
        field(50965; "USER ID"; Code[30])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(50966; "User Name"; text[55])
        {
            FieldClass = FlowField;
            CalcFormula = lookup (User."Full Name" where("User Name" = field("USER ID")));
            Editable = false;
        }
        field(50967; "Approver Id"; Code[30])
        {
            Editable = false;
        }
        field(50968; "Approver Name"; Text[100])
        {
            Editable = false;
        }
        field(50969; "Recipient Name"; text[100])
        {
        }
        field(50970; "Transfered To Journals"; Boolean)
        {
            Editable = false;
        }
        field(50971; "Responsible User"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(50972; "Working Description"; Text[250])
        {
        }
    }
    var
        VendorRecord: Record Vendor;
        ReportDisplayVAT: Decimal;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchSetup: Record "Purchases & Payables Setup";
        ASLT0001: Label 'You have changed W.H.T Exempt, Do you want to update W.H.T for all lines?';
        ASLT0002: Label 'Item Requisition must be Negative Adjmt. for issuing out items or Positive Adjmt. for store receipts';
        ASLT0003: Label 'The Item (Stores) Requisition must first be approved before printing';
    //=======================Triggers
    trigger OnInsert()
    begin
        InsertDefaultVendorOnQuote;
        SetHideValidationForQuote();
        Validate("USER ID", UserId);
    end;
    //--------------------------
    trigger OnModify()
    var
        myInt: Integer;
    begin
        Validate(Status);
    end;
    //--------------------
    trigger OnDelete()
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SETRANGE("Requisition Type", "Requisition Type");
    end;
    //=======================
    procedure CheckBudget(PrintErrors: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        GLAccount: Record "G/L Account";
        GLBudgetEntry: Record "G/L Budget Entry";
        GLEntry: Record "G/L Entry";
        ReleasedBudgetAmount: Decimal;
        CommittedAmount: Decimal;
        EncumberedAmount: Decimal;
        BalanceAtDate: Decimal;
        BalAfter: Decimal;
        PurchaseCommitmentQuery: Query "Commitments Encumberances";
        PurchaseEncumberanceQuery: Query "Commitments Encumberances";
        GLAccountBalanceQuery: Query "GL Budget Amount22";
        ErrorNo: Integer;
    begin
        /*PurchLine2.RESET;
              PurchLine2.SETRANGE(PurchLine2."Document Type", "Document Type");
              PurchLine2.SETRANGE(PurchLine2."Document No.", "No.");
              IF PurchLine2.FINDFIRST THEN
                  REPEAT
                      PurchLine2.VALIDATE(PurchLine2."Posting Date", "Posting Date");
                      PurchLine2.MODIFY;
                  UNTIL PurchLine2.NEXT = 0;
              ReleasedBudgetAmount := 0;
              CommittedAmount := 0;
              EncumberedAmount := 0;
              BalanceAtDate := 0;
              ErrorNo := 0;
              PurchaseLine.RESET;
              PurchaseLine.SETRANGE(PurchaseLine."Document Type", "Document Type");
              PurchaseLine.SETRANGE(PurchaseLine."Document No.", "No.");
              IF PurchaseLine.FIND('-') THEN BEGIN
                  REPEAT
                     /* //Check budget
                      GLSetup.GET;
                      IF GLSetup."G/L Budget Check" THEN BEGIN
                          //PurchaseLine.VALIDATE(PurchaseLine."Gen. Prod. Posting Group");

                          GLAccount.RESET;
                          IF GLSetup."G/L Accounts Filter" <> '' THEN
                              GLAccount.SETFILTER(GLAccount."No.", STRSUBSTNO('%1&%2', GLSetup."G/L Accounts Filter", PurchaseLine."G/L Account"))
                          ELSE
                              GLAccount.SETFILTER(GLAccount."No.", STRSUBSTNO('%1', PurchaseLine."G/L Account"));
                          //GLAccount.SETFILTER(GLAccount."Date Filter",'..'+FORMAT("Posting Date"));
                          IF GLAccount.FINDFIRST THEN BEGIN //Accounts included in budget check
                                                            // Check for account in G/L Budget Entry and compare the dimensions found with the dimensions on the purchase line

                              GLBudgetEntry.RESET;
                              GLBudgetEntry.SETRANGE(GLBudgetEntry."G/L Account No.", PurchaseLine."G/L Account");
                              GLBudgetEntry.SETFILTER(GLBudgetEntry.Date, '..%1', "Posting Date");
                              GLBudgetEntry.SETRANGE(GLBudgetEntry."Dimension Set ID", PurchaseLine."Dimension Set ID");
                              GLBudgetEntry.SETRANGE(GLBudgetEntry.Status, GLBudgetEntry.Status::Posted);
                              GLBudgetEntry.SETRANGE(GLBudgetEntry.Open, TRUE);
                              IF GLBudgetEntry.FINDFIRST THEN
                                  REPEAT
                                      // Get Released Budgeted Amount
                                      IF (GLBudgetEntry."Entry Type" = GLBudgetEntry."Entry Type"::Released) THEN
                                          ReleasedBudgetAmount += GLBudgetEntry.Amount;
                                  UNTIL GLBudgetEntry.NEXT = 0;
                              // Get Committed Amount from the purchase lines


                              PurchaseCommitmentQuery.SETRANGE(PurchaseCommitmentQuery.No, PurchaseLine."G/L Account");
                              PurchaseCommitmentQuery.SETRANGE(PurchaseCommitmentQuery.Document_Type, PurchaseCommitmentQuery.Document_Type::Quote);
                              PurchaseCommitmentQuery.SETFILTER(PurchaseCommitmentQuery.Posting_Date, '<=%1', PurchaseLine."Posting Date");
                              PurchaseCommitmentQuery.SETFILTER(PurchaseCommitmentQuery.Document_No, '<>%1', "No.");
                              PurchaseCommitmentQuery.OPEN;
                              WHILE PurchaseCommitmentQuery.READ DO BEGIN
                                  CommittedAmount := PurchaseCommitmentQuery.Amount;
                              END;
                              PurchaseCommitmentQuery.CLOSE;

                              PurchaseEncumberanceQuery.SETRANGE(PurchaseEncumberanceQuery.No, PurchaseLine."G/L Account");
                              PurchaseEncumberanceQuery.SETRANGE(PurchaseEncumberanceQuery.Document_Type, PurchaseEncumberanceQuery.Document_Type::Order);
                              PurchaseEncumberanceQuery.SETFILTER(PurchaseEncumberanceQuery.Posting_Date, '<=%1', PurchaseLine."Posting Date");
                              PurchaseEncumberanceQuery.SETFILTER(PurchaseEncumberanceQuery.Document_No, '<>%1', "No.");
                              PurchaseEncumberanceQuery.OPEN;
                              WHILE PurchaseEncumberanceQuery.READ DO BEGIN
                                  EncumberedAmount := PurchaseEncumberanceQuery.Amount;
                              END;
                              PurchaseEncumberanceQuery.CLOSE;

                              PurchLine.RESET;
                              PurchLine.SETRANGE("G/L Account", PurchaseLine."G/L Account");
                              PurchLine.SETFILTER("Date Filter", '%1..%2', 0D, PurchaseLine."Posting Date");
                              IF PurchLine.FINDSET THEN BEGIN
                                  PurchLine.CALCFIELDS("Balance at Date");
                                  BalanceAtDate := PurchLine."Balance at Date";
                              END;
                {
                ERROR('Release:' + FORMAT(ReleasedBudgetAmount) + ' Commitment:' + FORMAT(CommittedAmount) +
                      ' Encumberance:' + FORMAT(EncumberedAmount) + ' BalanceAtDate:' + FORMAT(BalanceAtDate) +
                      ' PurchaseLineAmount:' + FORMAT(PurchaseLine."Amount Including VAT"));
                }
                BalAfter := ((ReleasedBudgetAmount - (CommittedAmount + EncumberedAmount + BalanceAtDate)) - (PurchaseLine."Amount Including VAT"));
                  IF BalAfter < 0 THEN BEGIN
                      IF (GLSetup."Exceed Budget Action" = GLSetup."Exceed Budget Action"::"Error-Prevent Data Entry") THEN
                          ERROR(STRSUBSTNO(ASLB10001, PurchaseLine."Line No.", PurchaseLine.Type, PurchaseLine."No.", PurchaseLine."G/L Account",
                              ABS(BalAfter)))
                      ELSE
                          IF (GLSetup."Exceed Budget Action" = GLSetup."Exceed Budget Action"::"Warning-Allow Data Entry") THEN
                              MESSAGE(STRSUBSTNO(ASLB10001, PurchaseLine."Line No.", PurchaseLine.Type, PurchaseLine."No.", PurchaseLine."G/L Account",
                                  ABS(BalAfter)));
                      ErrorNo += 1;
                  END
              END;
          END;
          UNTIL PurchaseLine.NEXT = 0;
          IF PrintErrors THEN
            MESSAGE(ASLB10002, ErrorNo);
        PurchaseLine.MODIFYALL(PurchaseLine.Status,Status);

          END;  */
        //----------------------------------------------------------------------------------------------
    end;
    //===========================================
    procedure ConvertToAdvanceRequisition()
    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        AdvanceRequisitionLine: Record "Purchase Line";
        AdvanceRequisitionJournal: Record "Gen. Journal Line";
        AdvanceRequisitionJournal2: Record "Gen. Journal Line";
        AdvanceRequisitionJournal3: Record "Gen. Journal Line";
        AdvanceRequisitionJournal4: Record "Gen. Journal Line";
        AdvanceRequisitionJournalBatch: Record "Gen. Journal Batch";
        AdvanceRequisitionJournalBatch1: Record "Gen. Journal Batch";
        PaymentJournal: Page "Payment Journal";
        AdvanceRequisition: Record "Purchase Header";
        GenJournalMgt: Codeunit GenJnlManagement;
        NoSeries: Record "No. Series";
        NoSeriesLines: Record "No. Series Line";
        SeriesNo: Code[20];
        LineNo: Integer;
        DocumentNo: Code[20];
        DocumentNo1: Code[20];
        LineCount: Integer;
        ASLTXT0001: Label 'Are you sure you want to transfer this Cash Requisition to the Journal ?';
        ASLTXT0002: Label 'Advance Payment Journal %1 created successfully';
        ASLTXT0003: Label 'No Advance Payment Journal was created';
        ASLTXT0004: Label 'The Advance Payment Journal already exists';
        ASLTXT0005: Label 'The Cash requisitions accept on Type G/L Account or Fixed Asset not  %1 ';
    begin
        LineCount := 0;
        LineNo := 0;
        IF CONFIRM(ASLTXT0001, FALSE) THEN BEGIN
            TESTFIELD("Document Type", "Document Type"::Quote);
            TESTFIELD(Status, Status::Released);
            TestField("Assigned User ID");
            PurchaseSetup.GET;
            PurchaseSetup.TESTFIELD(PurchaseSetup."Payment Requisition Nos.");
            AdvanceRequisitionLine.RESET;
            AdvanceRequisitionLine.SETRANGE(AdvanceRequisitionLine."Document Type", "Document Type");
            AdvanceRequisitionLine.SETRANGE(AdvanceRequisitionLine."Document No.", "No.");
            IF AdvanceRequisitionLine.FINDFIRST THEN BEGIN
                AdvanceRequisitionLine.TestField(AdvanceRequisitionLine."Payment Requistion Journal");
                REPEAT
                    //start
                    if ((AdvanceRequisitionLine.Type = AdvanceRequisitionLine.Type::"G/L Account") or (AdvanceRequisitionLine.Type = AdvanceRequisitionLine.Type::"Fixed Asset")) then begin
                        AdvanceRequisitionLine.TESTFIELD(AdvanceRequisitionLine."No.");
                        AdvanceRequisitionLine.TESTFIELD(AdvanceRequisitionLine."Bal. Account Type", AdvanceRequisitionLine."Bal. Account Type"::"Bank Account");
                        AdvanceRequisitionLine.TESTFIELD(AdvanceRequisitionLine."Bal. Account No.");
                        AdvanceRequisitionLine.TESTFIELD(AdvanceRequisitionLine.Amount);
                        AdvanceRequisitionLine.TestField(AdvanceRequisitionLine."Transfered To Journal", false);
                        AdvanceRequisitionJournal.RESET;
                        AdvanceRequisitionJournal.SETRANGE(AdvanceRequisitionJournal."Journal Template Name", 'PAYMENT');
                        AdvanceRequisitionJournal.SETRANGE(AdvanceRequisitionJournal."Journal Batch Name", AdvanceRequisitionLine."Payment Requistion Journal");
                        AdvanceRequisitionJournal.SETRANGE(AdvanceRequisitionJournal."Line No.", AdvanceRequisitionLine."Line No.");
                        AdvanceRequisitionJournal.SETRANGE(AdvanceRequisitionJournal."Requisition No.", "No.");
                        AdvanceRequisitionJournal.SETRANGE(AdvanceRequisitionJournal."Posting Date", "Posting Date");
                        IF NOT AdvanceRequisitionJournal.FINDFIRST THEN BEGIN
                            AdvanceRequisitionJournal.INIT;
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Journal Template Name", 'PAYMENT');
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Journal Batch Name", AdvanceRequisitionLine."Payment Requistion Journal");

                            //Line Number and document number.
                            AdvanceRequisitionJournal3.Reset();
                            AdvanceRequisitionJournal3.SetRange(AdvanceRequisitionJournal3."Journal Template Name", 'PAYMENT');
                            AdvanceRequisitionJournal3.SetRange(AdvanceRequisitionJournal3."Journal Batch Name", AdvanceRequisitionLine."Payment Requistion Journal");
                            if AdvanceRequisitionJournal3.FindLast() then begin
                                AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Line No.", AdvanceRequisitionLine."Line No." + AdvanceRequisitionJournal3."Line No.");
                            end;
                            //Document number.
                            AdvanceRequisitionJournal4.Reset();
                            AdvanceRequisitionJournal4.SetRange(AdvanceRequisitionJournal4."Journal Template Name", 'PAYMENT');
                            AdvanceRequisitionJournal4.SetRange(AdvanceRequisitionJournal4."Journal Batch Name", AdvanceRequisitionLine."Payment Requistion Journal");
                            if AdvanceRequisitionJournal4.FindLast() then begin
                                DocumentNo1 := IncStr(AdvanceRequisitionJournal4."Document No.");
                                AdvanceRequisitionJournal.Validate(AdvanceRequisitionJournal."Document No.", DocumentNo1);
                            end else begin

                                AdvanceRequisitionJournalBatch.Reset();
                                AdvanceRequisitionJournalBatch.SetRange(AdvanceRequisitionJournalBatch."Journal Template Name", 'PAYMENT');
                                AdvanceRequisitionJournalBatch.SetRange(AdvanceRequisitionJournalBatch.Name, AdvanceRequisitionLine."Payment Requistion Journal");
                                if AdvanceRequisitionJournalBatch.FindFirst() then begin
                                    if AdvanceRequisitionJournalBatch."No. Series" <> '' then begin
                                        //DocumentNo := NoSeriesMgt.GetNextNo(AdvanceRequisitionJournalBatch."No. Series", WORKDATE, TRUE);
                                        NoSeries.Reset();
                                        NoSeries.SetRange(NoSeries.Code, AdvanceRequisitionJournalBatch."No. Series");
                                        if NoSeries.FindFirst() then begin
                                            NoSeriesLines.Reset();
                                            NoSeriesLines.SetRange(NoSeriesLines."Series Code", NoSeries.Code);
                                            if NoSeriesLines.FindFirst() then DocumentNo := IncStr(NoSeriesLines."Last No. Used");
                                        end;
                                        AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Line No.", AdvanceRequisitionLine."Line No.");
                                        AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Document No.", DocumentNo);
                                    end
                                    else begin
                                        //DocumentNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Payment Requisition Nos.", WORKDATE, TRUE);
                                        NoSeries.Reset();
                                        NoSeries.SetRange(NoSeries.Code, PurchaseSetup."Payment Requisition Nos.");
                                        if NoSeries.FindFirst() then begin
                                            NoSeriesLines.Reset();
                                            NoSeriesLines.SetRange(NoSeriesLines."Series Code", NoSeries.Code);
                                            if NoSeriesLines.FindFirst() then DocumentNo := IncStr(NoSeriesLines."Last No. Used");
                                        end;
                                        AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Line No.", AdvanceRequisitionLine."Line No.");
                                        AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Document No.", DocumentNo);
                                    end;
                                end;
                            end;
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Document Type", AdvanceRequisitionJournal."Document Type"::Payment);
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Posting Date", AdvanceRequisitionLine."Posting Date");

                            if (AdvanceRequisitionLine.Type = AdvanceRequisitionLine.Type::"G/L Account") then
                                AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Account Type", AdvanceRequisitionJournal."Account Type"::"G/L Account");
                            if (AdvanceRequisitionLine.Type = AdvanceRequisitionLine.Type::"Fixed Asset") then
                                AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Account Type", AdvanceRequisitionJournal."Account Type"::"Fixed Asset");

                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Account No.", AdvanceRequisitionLine."No.");
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal.Amount, AdvanceRequisitionLine.Amount);
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Requisition No.", "No.");
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."External Document No.", "No.");
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal.Description, AdvanceRequisitionLine.Description);
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Bal. Account Type", AdvanceRequisitionLine."Bal. Account Type");
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Bal. Account No.", AdvanceRequisitionLine."Bal. Account No.");
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Dimension Set ID", AdvanceRequisitionLine."Dimension Set ID");
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Shortcut Dimension 1 Code", AdvanceRequisitionLine."Shortcut Dimension 1 Code");
                            AdvanceRequisitionJournal.VALIDATE(AdvanceRequisitionJournal."Shortcut Dimension 2 Code", AdvanceRequisitionLine."Shortcut Dimension 2 Code");
                            AdvanceRequisitionJournal.INSERT;
                            LineCount += 1;
                            DocumentNo := IncStr(DocumentNo);
                        END;
                        AdvanceRequisitionLine."Transfered To Journal" := true;
                        AdvanceRequisitionLine.Modify();
                        AdvanceRequisition.Reset();
                        AdvanceRequisition.SetRange(AdvanceRequisition."Document Type", AdvanceRequisitionLine."Document Type");
                        AdvanceRequisition.SetRange(AdvanceRequisition."No.", AdvanceRequisitionLine."Document No.");
                        if AdvanceRequisition.FindFirst() then begin
                            AdvanceRequisition."Transfered To Journals" := true;
                            AdvanceRequisition.Modify();
                        end;

                    end else begin
                        Error(ASLTXT0005, AdvanceRequisitionLine.Type);
                    end;
                UNTIL AdvanceRequisitionLine.NEXT = 0;
                IF (LineCount >= 1) THEN
                    MESSAGE(ASLTXT0002, DocumentNo)
                ELSE
                    MESSAGE(ASLTXT0003);
            END;

            //Open the journal page
            if Confirm('Cash Requisition has been transfered to the Journals, would you like to open the Journals', true) then begin
                Clear(PaymentJournal);
                AdvanceRequisitionJournalBatch1.Reset();
                AdvanceRequisitionJournalBatch1.SetRange(AdvanceRequisitionJournalBatch1."Journal Template Name", 'PAYMENT');
                AdvanceRequisitionJournalBatch1.SetRange(AdvanceRequisitionJournalBatch1.Name, AdvanceRequisitionLine."Payment Requistion Journal");
                if AdvanceRequisitionJournalBatch1.FindFirst() then begin
                    GenJournalMgt.TemplateSelectionFromBatch(AdvanceRequisitionJournalBatch1);
                end;
            end;
        END;
    end;

    //===========================================
    procedure InsertDefaultVendorOnQuote()
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        IF "Document Type" = "Document Type"::Quote THEN BEGIN
            PurchSetup.GET;
            PurchSetup.TESTFIELD(PurchSetup."Default Vendor");
            VALIDATE("Buy-from Vendor No.", PurchSetup."Default Vendor");
        END;
    end;
    //========================================
    procedure ChangeVendor(): Boolean
    var
        PageNo: Integer;
    begin
        PageNo := 50019;
        SetHideValidationDialog(TRUE);
        MODIFY;
        COMMIT;
        PAGE.RUN(PageNo, Rec);
        EXIT(TRUE);
    end;
    //===============================
    procedure ChangeVendorContractCertLPO(): Boolean
    var
        NewVendor: Code[20];
        VendorInsert: Page "Insert Vendor";
    begin
        SetHideValidationDialog(TRUE);
        "Order Type" := "Order Type"::"Local Purchase Agreement";
        MODIFY;
        COMMIT;
        VendorInsert.SETRECORD(Rec);
        VendorInsert.IsContractCertLPO(TRUE);
        VendorInsert.RUN();
        //PAGE.RUN(50040,Rec);
        EXIT(TRUE);
    end;

    local procedure SetHideValidationForQuote()
    var
        myInt: Integer;
    begin
        IF ("Document Type" = "Document Type"::Quote) THEN SetHideValidationDialog(TRUE);
    end;

    procedure SetPostingDescription()
    var
        myInt: Integer;
    begin
        PurchSetup.GET;
        IF PurchSetup."Posting Description" = PurchSetup."Posting Description"::"Vendor Name" THEN "Posting Description" := "Buy-from Vendor Name";
        IF PurchSetup."Posting Description" = PurchSetup."Posting Description"::"Vendor Invoice and Name" THEN BEGIN
            IF "Vendor Invoice No." = '' THEN
                "Posting Description" := "Buy-from Vendor Name"
            ELSE
                "Posting Description" := COPYSTR("Vendor Invoice No." + '-' + "Buy-from Vendor Name", 1, MAXSTRLEN(Rec."Posting Description"));
        END;
    end;

    procedure CalcDisplayVAT(): Decimal
    var
        VATPurchaseLine: Record "Purchase Line";
        DisplayVATAmount: Decimal;
    begin
        //Display VAT Amount
        DisplayVATAmount := 0;
        VATPurchaseLine.RESET;
        VATPurchaseLine.SETRANGE(VATPurchaseLine."Document Type", "Document Type");
        VATPurchaseLine.SETRANGE(VATPurchaseLine."Document No.", "No.");
        VATPurchaseLine.SETFILTER(VATPurchaseLine."VAT. %", '>0');
        IF VATPurchaseLine.FINDFIRST THEN
            REPEAT
                IF "Prices Including VAT" THEN
                    DisplayVATAmount += ((VATPurchaseLine."VAT. %" * VATPurchaseLine.Amount) / (100 + VATPurchaseLine."VAT. %"))
                ELSE
                    DisplayVATAmount += (VATPurchaseLine.Amount * VATPurchaseLine."VAT. %" * 0.01);
            //EXIT(DisplayVATAmount);
            UNTIL VATPurchaseLine.NEXT = 0;
        EXIT(DisplayVATAmount);
        ReportDisplayVAT := DisplayVATAmount;
    end;

    procedure CalAmountExclVAT(): Decimal
    var
        PurchaseLine: Record "Purchase Line";
        AmountExclVAT: Decimal;
    begin
        //Display VAT Amount
        AmountExclVAT := 0;
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", "Document Type");
        PurchaseLine.SETRANGE(PurchaseLine."Document No.", "No.");
        PurchaseLine.SETFILTER(PurchaseLine."Unit Cost Excl. VAT", '>0');
        //IF PurchaseLine.FINDFIRST THEN BEGIN
        IF PurchaseLine.FIND('-') THEN
            REPEAT
                IF "Prices Including VAT" THEN
                    AmountExclVAT += (PurchaseLine."Unit Cost Excl. VAT" * PurchaseLine.Quantity)
                ELSE
                    AmountExclVAT += (PurchaseLine.Amount);
            //EXIT(AmountExclVAT);
            UNTIL PurchaseLine.NEXT = 0;
        EXIT(AmountExclVAT);
    end;

    procedure ConvertToItemRequisition()
    var
        InventorySetup: Record "Inventory Setup";
        ItemRequisitionLine: Record "Purchase Line";
        ItemJournal: Record "Item Journal Line";
        ItemJournal2: Record "Item Journal Line";
        DocumentNo: Code[20];
        LineCount: Integer;
        ASLTXT0001: Label 'Are you sure you want to convert to an Item Requisition?';
        ASLTXT0002: Label 'Item Requisition Journal %1 created successfully';
        ASLTXT0003: Label 'No Item Requsition Journal was created';
        ASLTXT0004: Label 'Item Requisition already exists';
    begin
        LineCount := 0;
        IF CONFIRM(ASLTXT0001, FALSE) THEN BEGIN
            TESTFIELD("Document Type", "Document Type"::Quote);
            TESTFIELD(Status, Status::Released);
            InventorySetup.GET;
            InventorySetup.TESTFIELD(InventorySetup."Journal Template Name");
            InventorySetup.TESTFIELD(InventorySetup."Journal Batch Name");
            ItemRequisitionLine.RESET;
            ItemRequisitionLine.SETRANGE(ItemRequisitionLine."Document Type", "Document Type");
            ItemRequisitionLine.SETRANGE(ItemRequisitionLine."Document No.", "No.");
            IF ItemRequisitionLine.FINDFIRST THEN BEGIN
                DocumentNo := "No.";
                ItemJournal.RESET;
                ItemJournal.SETRANGE(ItemJournal."Journal Template Name", InventorySetup."Journal Template Name");
                ItemJournal.SETRANGE(ItemJournal."Journal Batch Name", InventorySetup."Journal Batch Name");
                IF ItemJournal.FINDSET THEN ItemJournal.DELETEALL;
                REPEAT
                    ItemRequisitionLine.TESTFIELD(ItemRequisitionLine."Shortcut Dimension 1 Code");
                    ItemRequisitionLine.TESTFIELD(ItemRequisitionLine."Shortcut Dimension 2 Code");
                    ItemRequisitionLine.TESTFIELD(ItemRequisitionLine."Item No.");
                    ItemRequisitionLine.TESTFIELD(ItemRequisitionLine."Item Location Code");
                    ItemRequisitionLine.TESTFIELD(ItemRequisitionLine."Item Quantity");
                    IF (ItemRequisitionLine."Item Entry Type" <> ItemRequisitionLine."Item Entry Type"::"Negative Adjmt.") THEN IF (ItemRequisitionLine."Item Entry Type" <> ItemRequisitionLine."Item Entry Type"::"Positive Adjmt.") THEN ERROR(ASLT0002);
                    ItemJournal.RESET;
                    ItemJournal.SETRANGE(ItemJournal."Journal Template Name", InventorySetup."Journal Template Name");
                    ItemJournal.SETRANGE(ItemJournal."Journal Batch Name", InventorySetup."Journal Batch Name");
                    ItemJournal.SETRANGE(ItemJournal."Line No.", ItemRequisitionLine."Line No.");
                    ItemJournal.SETRANGE(ItemJournal."Document No.", "No.");
                    ItemJournal.SETRANGE(ItemJournal."Posting Date", "Posting Date");
                    IF NOT ItemJournal.FINDFIRST THEN BEGIN
                        ItemJournal.INIT;
                        ItemJournal.VALIDATE(ItemJournal."Journal Template Name", InventorySetup."Journal Template Name");
                        ItemJournal.VALIDATE(ItemJournal."Journal Batch Name", InventorySetup."Journal Batch Name");
                        ItemJournal.VALIDATE(ItemJournal."Line No.", ItemRequisitionLine."Line No.");
                        ItemJournal.VALIDATE(ItemJournal."Entry Type", ItemRequisitionLine."Item Entry Type");
                        ItemJournal.VALIDATE(ItemJournal."Document No.", "No.");
                        ItemJournal.VALIDATE(ItemJournal."Posting Date", "Posting Date");
                        ItemJournal.VALIDATE(ItemJournal."Document Date", "Document Date");
                        ItemJournal.VALIDATE(ItemJournal."Item No.", ItemRequisitionLine."Item No.");
                        ItemJournal.VALIDATE(ItemJournal."Location Code", ItemRequisitionLine."Location Code");
                        ItemJournal.VALIDATE(ItemJournal."Unit of Measure Code", ItemRequisitionLine."Item Unit of Measure Code");
                        ItemJournal.VALIDATE(ItemJournal.Quantity, ItemRequisitionLine.Quantity);
                        ItemJournal.VALIDATE(ItemJournal.Description, ItemRequisitionLine.Description);
                        ItemJournal.VALIDATE(ItemJournal."Dimension Set ID", ItemRequisitionLine."Dimension Set ID");
                        ItemJournal.VALIDATE(ItemJournal."Shortcut Dimension 1 Code", ItemRequisitionLine."Shortcut Dimension 1 Code");
                        ItemJournal.VALIDATE(ItemJournal."Shortcut Dimension 2 Code", ItemRequisitionLine."Shortcut Dimension 2 Code");
                        ItemJournal.INSERT;
                        LineCount += 1;
                    END;
                UNTIL ItemRequisitionLine.NEXT = 0;
                IF (LineCount >= 1) THEN
                    MESSAGE(ASLTXT0002, DocumentNo)
                ELSE
                    MESSAGE(ASLTXT0003);
            END;
        END;
    end;

    procedure PrintItemRequisitionVoucher()
    var
        ItemJournal: Record "Item Journal Line";
        InventorySetup: Record "Inventory Setup";
        StoreVoucher: Report "Inventory Issue Note";
    begin
        IF (Status <> Status::Released) THEN ERROR(ASLT0003);
        InventorySetup.GET;
        ItemJournal.RESET;
        ItemJournal.SETRANGE(ItemJournal."Journal Template Name", InventorySetup."Journal Template Name");
        ItemJournal.SETRANGE(ItemJournal."Journal Batch Name", InventorySetup."Journal Batch Name");
        ItemJournal.SETRANGE(ItemJournal."Document No.", "No.");
        IF ItemJournal.FINDFIRST THEN BEGIN
            ItemJournal.InsertStoreVoucher();
            StoreVoucher.SetDocumentNo(ItemJournal."Document No.");
            StoreVoucher.RUN;
        END;
    end;

    procedure PostItemRequisitionVoucher()
    var
        ItemJournal: Record "Item Journal Line";
        InventorySetup: Record "Inventory Setup";
        StoreVoucher: Report "Inventory Issue Note";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        InventorySetup.GET;
        ItemJournal.RESET;
        ItemJournal.SETRANGE(ItemJournal."Journal Template Name", InventorySetup."Journal Template Name");
        ItemJournal.SETRANGE(ItemJournal."Journal Batch Name", InventorySetup."Journal Batch Name");
        ItemJournal.SETRANGE(ItemJournal."Document No.", "No.");
        IF ItemJournal.FINDSET THEN BEGIN
            ItemJournal.InsertStoreVoucher();
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournal);
            ItemJournal.ChangeStoreVoucherStatus(FALSE);
            ArchiveManagement.StorePurchDocument(Rec, FALSE);
            DELETE;
        END;
    end;

    local procedure TestNoSeriesLpo(): Boolean
    var
    begin
        PurchSetup.GET;
        CASE "Document Type" OF
            "Document Type"::Quote:
                IF "Requisition Type" = "Requisition Type"::Service THEN
                    PurchSetup.TESTFIELD(PurchSetup."Service Requisition Nos.")
                ELSE
                    IF "Requisition Type" = "Requisition Type"::Advance THEN
                        PurchSetup.TESTFIELD(PurchSetup."Advanced Requistion Nos.")
                    ELSE
                        IF "Requisition Type" = "Requisition Type"::Stores THEN
                            PurchSetup.TESTFIELD(PurchSetup."Stores Requisition Nos.")
                        ELSE
                            IF "Requisition Type" = "Requisition Type"::Contract THEN
                                PurchSetup.TESTFIELD(PurchSetup."Contract Requisition Nos.")
                            ELSE //Diferent Requisitions Nos.
                                PurchSetup.TESTFIELD("Quote Nos.");
            "Document Type"::Order:
                BEGIN
                    // V1.0.0 Contract Management
                    IF "Order Type" = "Order Type"::"Contract Purchase Agreement" THEN
                        PurchSetup.TESTFIELD("Contract Purch. Agrreement Nos")
                    ELSE
                        IF "Order Type" = "Order Type"::"Local Purchase Agreement" THEN
                            PurchSetup.TESTFIELD("Local Purchase Agreement Nos")
                        ELSE // V1.0.0 Contract Management
                            PurchSetup.TESTFIELD("Order Nos.");
                END;
            "Document Type"::Invoice:
                BEGIN
                    PurchSetup.TESTFIELD("Invoice Nos.");
                    PurchSetup.TESTFIELD("Posted Invoice Nos.");
                END;
            "Document Type"::"Return Order":
                PurchSetup.TESTFIELD("Return Order Nos.");
            "Document Type"::"Credit Memo":
                BEGIN
                    PurchSetup.TESTFIELD("Credit Memo Nos.");
                    PurchSetup.TESTFIELD("Posted Credit Memo Nos.");
                END;
            "Document Type"::"Blanket Order":
                PurchSetup.TESTFIELD("Blanket Order Nos.");
        END;
    end;

    local procedure GetNoSeriesCodeLpo(): Code[10]
    var
        myInt: Integer;
    begin
        CASE "Document Type" OF
            "Document Type"::Quote: //Use Different No Series for the Different Requisition Types
                IF "Requisition Type" = "Requisition Type"::Service THEN
                    EXIT(PurchSetup."Service Requisition Nos.")
                ELSE
                    IF "Requisition Type" = "Requisition Type"::Stores THEN
                        EXIT(PurchSetup."Stores Requisition Nos.")
                    ELSE
                        IF "Requisition Type" = "Requisition Type"::Advance THEN
                            EXIT(PurchSetup."Advanced Requistion Nos.")
                        ELSE
                            IF "Requisition Type" = "Requisition Type"::Contract THEN
                                EXIT(PurchSetup."Contract Requisition Nos.")
                            //Use Different No Series for the Different Requisition Types
                            ELSE //Purchase Requsitions Nos
                                EXIT(PurchSetup."Quote Nos.");
            "Document Type"::Order:
                BEGIN
                    // V1.0.0 Contract Management
                    IF "Order Type" = "Order Type"::"Contract Purchase Agreement" THEN
                        EXIT(PurchSetup."Contract Purch. Agrreement Nos")
                    ELSE
                        IF "Order Type" = "Order Type"::"Local Purchase Agreement" THEN
                            EXIT(PurchSetup."Local Purchase Agreement Nos")
                        ELSE // V1.0.0 Contract Management
                            EXIT(PurchSetup."Order Nos.");
                END;
            "Document Type"::Invoice:
                EXIT(PurchSetup."Invoice Nos.");
            "Document Type"::"Return Order":
                EXIT(PurchSetup."Return Order Nos.");
            "Document Type"::"Credit Memo":
                EXIT(PurchSetup."Credit Memo Nos.");
            "Document Type"::"Blanket Order":
                EXIT(PurchSetup."Blanket Order Nos.");
        END;
    end;
}

page 50020 "Advance Purchase Req Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Quote), "Requisition Type" = CONST(Advance));
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Field(Type; Type)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        NoOnAfterValidate;
                        IF xRec."No." <> '' THEN
                            RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("No."; "No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

                        IF xRec."No." <> '' THEN
                            RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field(Description; Description)
                {
                    ApplicationArea = All;
                }
                Field("Cross-Reference No."; "Cross-Reference No.")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CrossReferenceNoOnAfterValidat;
                        NoOnAfterValidate;
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        CrossReferenceNoLookUp;
                        InsertExtendedText(FALSE);
                        NoOnAfterValidate;
                    end;
                }
                Field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field(Nonstock; Nonstock)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    BlankZero = true;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;

                }
                Field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Unit Cost"; "Direct Unit Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Indirect Cost %"; "Indirect Cost %")
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                    BlankZero = true;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Unit Price (LCY)"; "Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Line Discount %"; "Line Discount %")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Payment Requistion Journal"; "Payment Requistion Journal")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = All;
                }

                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = All;

                }

                Field("Line Discount Amount"; "Line Discount Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                Field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Qty. to Assign"; "Qty. to Assign")
                {
                    ApplicationArea = All;
                    Visible = false;
                    BlankZero = true;
                    trigger OnDrillDown()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdateForm(FALSE);
                    end;
                }
                Field("Qty. Assigned"; "Qty. Assigned")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Visible = false;
                    trigger OnDrillDown()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdateForm(FALSE);
                    end;
                }
                Field("Prod. Order No."; "Prod. Order No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Blanket Order No."; "Blanket Order No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Transfered To Journal"; "Transfered To Journal")
                {
                    ApplicationArea = All;
                }
                Field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                Field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                Field(Control300; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    Visible = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                Field(Control302; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    Visible = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                Field(Control304; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    Visible = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                Field(Control306; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    Visible = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                Field(Control308; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    Visible = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                Field(Control310; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    Visible = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }

                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }

                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }


            }
            group(Control43)
            {
                ShowCaption = false;
                group(Control37)
                {
                    ShowCaption = false;
                    Field("Invoice Discount Amount"; TotalPurchaseLine."Inv. Discount Amount")
                    {
                        ApplicationArea = Suite;
                        Editable = InvDiscAmountEditable;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        trigger OnValidate()
                        var
                            PurchaseHeader: Record "Purchase Header";
                        begin
                            PurchaseHeader.GET("Document Type", "Document No.");
                            PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalPurchaseLine."Inv. Discount Amount", PurchaseHeader);
                            CurrPage.UPDATE(FALSE);
                        end;
                    }
                    Field("Invoice Discount %"; PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec))
                    {
                        ApplicationArea = Suite;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }

                    Field(RefreshTotals; RefreshMessageText)
                    {
                        ApplicationArea = Suite;
                        Editable = false;
                        ShowCaption = false;
                        DrillDown = true;
                        trigger OnDrillDown()
                        var
                            myInt: Integer;
                        begin
                            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
                            CurrPage.UPDATE(FALSE);
                        end;
                    }
                }

                group(Control19)
                {
                    ShowCaption = false;
                    Field("Total Amount Excl. VAT"; TotalPurchaseLine.Amount)
                    {
                        ApplicationArea = Suite;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(PurchHeader."Currency Code");
                        Editable = false;
                        DrillDown = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                    Field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Suite;
                        Editable = false;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(PurchHeader."Currency Code");
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                    Field("Total Amount Incl. VAT"; TotalPurchaseLine."Amount Including VAT")
                    {
                        ApplicationArea = Suite;
                        Editable = false;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(PurchHeader."Currency Code");
                        StyleExpr = TotalAmountStyle;
                    }

                }
            }
        }
        // area(Factboxes)
        // {

        // }
    }

    actions
    {
        area(Processing)
        {
            group(Functions)
            {
                action("E&xplode BOM")
                {
                    ApplicationArea = All;
                    Caption = 'E&xplode BOM';
                    AccessByPermission = TableData "BOM Component" = R;
                    Image = ExplodeBOM;
                    trigger OnAction()
                    begin
                        ExplodeBOM;
                    end;
                }

                action("Insert &Ext. Texts")
                {
                    ApplicationArea = All;
                    Caption = 'Insert &Ext. Texts';
                    AccessByPermission = TableData "Extended Text Header" = R;
                    Image = Text;
                    trigger OnAction()
                    begin
                        InsertExtendedText(TRUE);
                    end;
                }
            }

            group(Lines)
            {
                group("Item Availability")
                {
                    action("Event")
                    {
                        ApplicationArea = All;
                        Caption = 'Event';
                        Image = "Event";
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action("Period")
                    {
                        ApplicationArea = All;
                        Caption = 'Period';
                        Image = Period;
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByPeriod);
                        end;
                    }

                    action("Variant")
                    {
                        ApplicationArea = All;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = All;
                        Caption = 'Location';
                        AccessByPermission = TableData Location = R;
                        Image = Warehouse;
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = All;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }

                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    AccessByPermission = TableData Dimension = R;
                    ShortcutKey = 'Shift+Ctrl+D';
                    Image = Dimensions;
                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }

                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    trigger OnAction()
                    begin
                        ShowLineComments;
                    end;
                }

                action("Item Charge &Assignment")
                {
                    ApplicationArea = All;
                    Caption = 'Item Charge &Assignment';
                    AccessByPermission = TableData "Item Charge" = R;
                    Image = ItemCosts;
                    trigger OnAction()
                    begin
                        ItemChargeAssgnt;
                    end;
                }

                action("Item &Tracking Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Item &Tracking Lines';
                    ShortcutKey = 'Shift+Ctrl+I';
                    Image = ItemTrackingLines;
                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
            }
        }
    }

    var
        TotalPurchaseHeader: Record "Purchase Header";
        TotalPurchaseLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        DocumentTotals: Codeunit "Document Totals";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array[8] of Code[20];
        UpdateAllowedVar: Boolean;
        VATAmount: Decimal;
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        Text000: Label 'Unable to run this function while in View mode.';
    //=============================Triggers=============================
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        InitType;
        CLEAR(ShortcutDimCode);
        "Requisition Type" := "Requisition Type"::Advance;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        "Requisition Type" := "Requisition Type"::Advance;
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        //SETRANGE("Requisition Type","Requisition Type");
        "Requisition Type" := "Requisition Type"::Advance;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
            COMMIT;
            IF NOT ReservePurchLine.DeleteLineConfirm(Rec) THEN
                EXIT(FALSE);
            ReservePurchLine.DeleteLine(Rec);
        END;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        IF PurchHeader.GET("Document Type", "Document No.") THEN;
        DocumentTotals.PurchaseUpdateTotalsControls(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);
    end;
    //=================================End Triggers============================
    procedure ApproveCalcInvDisc()
    var
        myInt: Integer;
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)", Rec);
    end;
    //=================================
    local procedure CalcInvDisc()
    var
        myInt: Integer;
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount", Rec);
    end;

    //============================
    local procedure ExplodeBOM()
    var
        myInt: Integer;
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM", Rec);
    end;

    //========================
    local procedure InsertExtendedText(Unconditionally: Boolean)
    var
        myInt: Integer;
    begin
        IF TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertPurchExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    end;

    //================================
    local procedure ItemChargeAssgnt()
    var
        myInt: Integer;
    begin
        ShowItemChargeAssgnt;
    end;

    //==============================
    local procedure OpenItemTrackingLines()
    var
        myInt: Integer;
    begin
        OpenItemTrackingLines;
    end;
    //===========================
    procedure UpdateForm(SetSaveRecord: Boolean)
    var
        myInt: Integer;
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    //========================
    procedure SetUpdateAllowed(UpdateAllowed: Boolean)
    var
        myInt: Integer;
    begin

        UpdateAllowedVar := UpdateAllowed;
    end;

    //=============
    local procedure UpdateAllowed(): Boolean
    var
        myInt: Integer;
    begin
        IF UpdateAllowedVar = FALSE THEN BEGIN
            MESSAGE(Text000);
            EXIT(FALSE);
        END;
        EXIT(TRUE);
    end;
    //===================
    local procedure ShowPrices()
    var
        PurchHeader: Record "Purchase Header";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
    begin
        PurchHeader.GET("Document Type", "Document No.");
        CLEAR(PurchPriceCalcMgt);
        PurchPriceCalcMgt.GetPurchLinePrice(PurchHeader, Rec);
    end;

    //===========================
    local procedure ShowLineDisc()
    var
        PurchHeader: Record "Purchase Header";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
    begin
        PurchHeader.GET("Document Type", "Document No.");
        CLEAR(PurchPriceCalcMgt);
        PurchPriceCalcMgt.GetPurchLineLineDisc(PurchHeader, Rec);
    end;

    //==================================

    local procedure ShowLineComments()
    var
        myInt: Integer;
    begin
        ShowLineComments;
    end;

    //======================
    local procedure NoOnAfterValidate()
    var
        myInt: Integer;
    begin
        InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    end;

    //=============================
    local procedure CrossReferenceNoOnAfterValidat()
    var
        myInt: Integer;
    begin
        InsertExtendedText(FALSE);
    end;

    //===============================
    local procedure RedistributeTotalsOnAfterValidate()
    var
        myInt: Integer;
    begin
        CurrPage.SAVERECORD;
        PurchHeader.GET("Document Type", "Document No.");
        IF DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchHeader) THEN
            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
        CurrPage.UPDATE;
    end;
}
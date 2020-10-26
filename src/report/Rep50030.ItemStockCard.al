report 50030 "Item Stock Card"
{
    DefaultLayout = RDLC;
    RDLCLayout = './InventoryTransactionDetail.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Inventory - Transaction Detail';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", Description, "Assembly BOM", "Inventory Posting Group", "Shelf No.", "Statistics Group", "Date Filter";
            column(PeriodItemDateFilter; StrSubstNo(Text000, ItemDateFilter))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(TableCaptionItemFilter; StrSubstNo('%1: %2', TableCaption, ItemFilter))
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(No_Item; "No.")
            {
            }
            column(InventoryTransDetailCaption; InventoryTransDetailCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemLedgEntryPostDateCaption; ItemLedgEntryPostDateCaptionLbl)
            {
            }
            column(ItemLedgEntryEntryTypCaption; ItemLedgEntryEntryTypCaptionLbl)
            {
            }
            column(IncreasesQtyCaption; IncreasesQtyCaptionLbl)
            {
            }
            column(DecreasesQtyCaption; DecreasesQtyCaptionLbl)
            {
            }
            column(ItemOnHandCaption; ItemOnHandCaptionLbl)
            {
            }
            dataitem(PageCounter; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(Description_Item; Item.Description)
                {
                }
                column(StartOnHand; StartOnHand)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(RecordNo; RecordNo)
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = FIELD("No."), "Variant Code" = FIELD("Variant Filter"), "Posting Date" = FIELD("Date Filter"), "Location Code" = FIELD("Location Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Item;
                    DataItemTableView = SORTING("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                    column(StartOnHandQuantity; StartOnHand + Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(PostingDate_ItemLedgEntry; Format("Posting Date"))
                    {
                    }
                    column(EntryType_ItemLedgEntry; "Entry Type")
                    {
                    }
                    column(DocumentNo_PItemLedgEntry; "Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_ItemLedgEntry; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(IncreasesQty; IncreasesQty)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(DecreasesQty; DecreasesQty)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(ItemOnHand; ItemOnHand)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(EntryNo_ItemLedgerEntry; "Entry No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_ItemLedgerEntry; Quantity)
                    {
                    }
                    column(ItemDescriptionControl32; Item.Description)
                    {
                    }
                    column(ContinuedCaption; ContinuedCaptionLbl)
                    {
                    }
                    column(VendorOrCustomername; VendorOrCustomername)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VendorOrCustomername := '';
                        ItemOnHand := ItemOnHand + Quantity;
                        Clear(IncreasesQty);
                        Clear(DecreasesQty);
                        if Quantity > 0 then
                            IncreasesQty := Quantity
                        else
                            DecreasesQty := Abs(Quantity);


                        if "Entry Type" = "Entry Type"::Purchase then begin
                            if "Document Type" = "Document Type"::"Purchase Credit Memo" then begin
                                PurchaseCreditMemoHeader.Reset();
                                PurchaseCreditMemoHeader.SetRange(PurchaseCreditMemoHeader."No.", "Document No.");
                                if PurchaseCreditMemoHeader.FindFirst() then begin
                                    VendorOrCustomername := PurchaseCreditMemoHeader."Buy-from Vendor Name";
                                end;
                            end else begin
                                PurchaseRecptHeader.Reset();
                                PurchaseRecptHeader.SetRange(PurchaseRecptHeader."No.", "Document No.");
                                if PurchaseRecptHeader.FindFirst() then
                                    VendorOrCustomername := PurchaseRecptHeader."Buy-from Vendor Name";
                            end;
                        end else
                            if "Entry Type" = "Entry Type"::Sale then begin
                                if "Document Type" = "Document Type"::"Sales Credit Memo" then begin
                                    SalesCreditMemoHeader.Reset();
                                    SalesCreditMemoHeader.SetRange(SalesCreditMemoHeader."No.", "Document No.");
                                    if SalesCreditMemoHeader.FindFirst() then begin
                                        VendorOrCustomername := SalesCreditMemoHeader."Sell-to Customer Name";
                                    end;
                                end else begin
                                    SalesShipmentHeader.Reset();
                                    SalesShipmentHeader.SetRange(SalesShipmentHeader."No.", "Document No.");
                                    if SalesShipmentHeader.FindFirst() then
                                        VendorOrCustomername := SalesShipmentHeader."Sell-to Customer Name";
                                end;
                            end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(Quantity);
                        Clear(IncreasesQty);
                        Clear(DecreasesQty);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                StartOnHand := 0;
                if ItemDateFilter <> '' then
                    if GetRangeMin("Date Filter") > 00000101D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                        CalcFields("Net Change");
                        StartOnHand := "Net Change";
                        SetFilter("Date Filter", ItemDateFilter);
                    end;
                ItemOnHand := StartOnHand;

                if PrintOnlyOnePerPage then
                    RecordNo := RecordNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                RecordNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Item';
                        ToolTip = 'Specifies if you want each item transaction detail to be printed on a separate page.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ItemFilter := Item.GetFilters;
        ItemDateFilter := Item.GetFilter("Date Filter");
    end;

    var
        Text000: Label 'Period: %1';
        ItemFilter: Text;
        ItemDateFilter: Text[30];
        ItemOnHand: Decimal;
        StartOnHand: Decimal;
        IncreasesQty: Decimal;
        DecreasesQty: Decimal;
        PrintOnlyOnePerPage: Boolean;
        RecordNo: Integer;
        InventoryTransDetailCaptionLbl: Label 'Inventory - Transaction Detail';
        CurrReportPageNoCaptionLbl: Label 'Page';
        ItemLedgEntryPostDateCaptionLbl: Label 'Posting Date';
        ItemLedgEntryEntryTypCaptionLbl: Label 'Entry Type';
        IncreasesQtyCaptionLbl: Label 'Increases';
        DecreasesQtyCaptionLbl: Label 'Decreases';
        ItemOnHandCaptionLbl: Label 'Inventory';
        ContinuedCaptionLbl: Label 'Continued';
        VendorOrCustomername: Text[150];
        PurchaseRecptHeader: Record "Purch. Rcpt. Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesCreditMemoHeader: Record "Sales Cr.Memo Header";
        PurchaseCreditMemoHeader: Record "Purch. Cr. Memo Hdr.";

    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
    end;
}


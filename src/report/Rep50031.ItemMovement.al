report 50031 "Item Movement"
{
    Caption = 'Item Movement';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ItemMovement.rdlc';
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Date Filter", "Location Filter";
            Column(Company_Name; CompanyInfo.Name) { }
            Column(Company_Address; CompanyInfo.Address) { }
            Column(Company_PhoneNo; CompanyInfo."Phone No.") { }
            Column(Company_Picture; CompanyInfo.Picture) { }
            Column(Company_Email; CompanyInfo."E-Mail") { }
            Column(Company_HomePage; CompanyInfo."Home Page") { }
            Column(No_Item; Item."No.") { }
            Column(Description_Item; Item.Description) { }
            Column(Description2_Item; Item."Description 2") { }
            Column(BaseUnitofMeasure_Item; Item."Base Unit of Measure") { }
            Column(ReportDate; ReportDate) { }
            Column(Inventory_Item; Item.Inventory) { }
            Column(StartingInventory; StartingInventory) { }
            Column(DateFilterItem; DateFilterItem) { }
            Column(CurrentInventory; CurrentInventory) { }
            Column(ReceivedInventory; ReceivedInventory) { }
            Column(SalesReturnInventory; SalesReturnInventory) { }
            Column(IssuedInventory; IssuedInventory) { }
            Column(LocationFilter; LocationFilter) { }
            Column(TransShipDamageInventory; TransShipDamageInventory) { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                CurrReport.CREATETOTALS(StartingInventory);
            end;

            trigger OnAfterGetRecord()
            begin
                StartingInventory := 0;
                CurrentInventory := 0;
                //ReceivedInventory := 0;
                IF DateFilterItem <> '' THEN
                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        CALCFIELDS("Inventory Value");
                        StartingInventory := "Inventory Value";
                        SETFILTER("Date Filter", DateFilterItem);
                    END;

                IF DateFilterItem <> '' THEN
                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter"));
                        CALCFIELDS("Inventory Value");
                        CurrentInventory := "Inventory Value";
                        SETFILTER("Date Filter", DateFilterItem);
                    END;
                // {
                // --------------------------Inbound--------------------------------------------		
                // PostiveInventory Decimal
                // PurchReceiptInventory Decimal
                // TransReceiptInventory Decimal
                // SalesReturnInventory Decimal
                // ProdOutputInventory Decimal
                // SalesCreditMemoInventory	
                // ------------------------------------------------------------------------------
                // }

                //Initialization
                PostiveInventory := 0;
                PurchReceiptInventory := 0;
                TransReceiptInventory := 0;
                SalesReturnInventory := 0;
                ProdOutputInventory := 0;
                SalesCreditMemoInventory := 0;

                //Postive Adjustment
                ItemLedger4.RESET;
                ItemLedger4.SETRANGE(ItemLedger4."Item No.", Item."No.");
                ItemLedger4.SETRANGE(ItemLedger4."Location Code", LocationFilter);
                ItemLedger4.SETRANGE(ItemLedger4."Posting Date", ReportDate);
                ItemLedger4.SETRANGE("Entry Type", ItemLedger4."Entry Type"::"Positive Adjmt.");
                IF ItemLedger4.FINDFIRST THEN
                    REPEAT
                        PostiveInventory += ItemLedger4.Quantity;
                    UNTIL ItemLedger4.NEXT = 0;

                //TransReceiptInventory
                ItemLedger.RESET;
                ItemLedger.SETRANGE(ItemLedger."Item No.", Item."No.");
                ItemLedger.SETRANGE(ItemLedger."Location Code", LocationFilter);
                ItemLedger.SETRANGE(ItemLedger."Posting Date", ReportDate);
                ItemLedger.SETRANGE("Entry Type", ItemLedger."Entry Type"::Transfer);
                ItemLedger.SETRANGE("Document Type", ItemLedger."Document Type"::"Transfer Receipt");
                IF ItemLedger.FINDSET THEN
                    REPEAT
                        TransReceiptInventory += ItemLedger.Quantity;
                    UNTIL ItemLedger.NEXT = 0;

                //PurchReceiptInventory
                ItemLedger1.RESET;
                ItemLedger1.SETRANGE(ItemLedger1."Item No.", Item."No.");
                ItemLedger1.SETRANGE(ItemLedger1."Location Code", LocationFilter);
                ItemLedger1.SETRANGE(ItemLedger1."Posting Date", ReportDate);
                ItemLedger1.SETRANGE("Entry Type", ItemLedger1."Entry Type"::Purchase);
                ItemLedger1.SETRANGE("Document Type", ItemLedger1."Document Type"::"Purchase Receipt");
                IF ItemLedger1.FINDFIRST THEN
                    REPEAT
                        PurchReceiptInventory += ItemLedger1.Quantity;
                    UNTIL ItemLedger1.NEXT = 0;

                //SalesCreditMemoInventory
                ItemLedger2.RESET;
                ItemLedger2.SETRANGE(ItemLedger2."Item No.", Item."No.");
                ItemLedger2.SETRANGE(ItemLedger2."Location Code", LocationFilter);
                ItemLedger2.SETRANGE(ItemLedger2."Posting Date", ReportDate);
                ItemLedger2.SETRANGE("Entry Type", ItemLedger2."Entry Type"::Sale);
                ItemLedger2.SETRANGE("Document Type", ItemLedger2."Document Type"::"Sales Credit Memo");
                IF ItemLedger2.FINDFIRST THEN
                    REPEAT
                        SalesCreditMemoInventory += ItemLedger2.Quantity;
                    UNTIL ItemLedger2.NEXT = 0;

                //SalesReturnInventory

                ItemLedger5.RESET;
                ItemLedger5.SETRANGE(ItemLedger5."Item No.", Item."No.");
                ItemLedger5.SETRANGE(ItemLedger5."Location Code", LocationFilter);
                ItemLedger5.SETRANGE(ItemLedger5."Posting Date", ReportDate);
                ItemLedger5.SETRANGE(ItemLedger5."Entry Type", ItemLedger5."Entry Type"::Sale);
                ItemLedger5.SETRANGE("Document Type", ItemLedger5."Document Type"::"Sales Return Receipt");
                IF ItemLedger5.FINDFIRST THEN
                    REPEAT
                        SalesReturnInventory += ItemLedger5.Quantity;
                    UNTIL ItemLedger5.NEXT = 0;


                //ProdOutputInventory
                ItemLedger3.RESET;
                ItemLedger3.SETRANGE(ItemLedger3."Item No.", Item."No.");
                ItemLedger3.SETRANGE(ItemLedger3."Location Code", LocationFilter);
                ItemLedger3.SETRANGE(ItemLedger3."Posting Date", ReportDate);
                ItemLedger3.SETRANGE(ItemLedger3."Entry Type", ItemLedger3."Entry Type"::Output);
                IF ItemLedger3.FINDFIRST THEN
                    REPEAT
                        ProdOutputInventory += ItemLedger3.Quantity;
                    UNTIL ItemLedger3.NEXT = 0;

                ReceivedInventory := (SalesCreditMemoInventory +
                                      PostiveInventory +
                                      PurchReceiptInventory +
                                      TransReceiptInventory +
                                      ProdOutputInventory);


                // ------------------------OutBound-----------------------------------------------
                // SalesShipInventory	Decimal		
                // ConsumptionInventory	Decimal		
                // NegativeInventory	Decimal		
                // TransShipmentInventory	Decimal		
                // PurcReturnInventory	Decimal		
                // PurcCreditMemoInventory	Decimal
                // TransShipDamageInventory		


                //Initializing Values
                SalesShipInventory := 0;
                ConsumptionInventory := 0;
                NegativeInventory := 0;
                TransShipmentInventory := 0;
                PurcReturnInventory := 0;
                PurcCreditMemoInventory := 0;
                TransShipDamageInventory := 0;

                //SalesShipInventory
                ItemLedger11.RESET;
                ItemLedger11.SETRANGE(ItemLedger11."Item No.", Item."No.");
                ItemLedger11.SETRANGE(ItemLedger11."Location Code", LocationFilter);
                ItemLedger11.SETRANGE(ItemLedger11."Posting Date", ReportDate);
                ItemLedger11.SETRANGE(ItemLedger11."Entry Type", ItemLedger11."Entry Type"::Sale);
                ItemLedger11.SETRANGE(ItemLedger11."Document Type", ItemLedger11."Document Type"::"Sales Shipment");
                IF ItemLedger11.FINDFIRST THEN
                    REPEAT
                        SalesShipInventory += ItemLedger11.Quantity;
                    UNTIL ItemLedger11.NEXT = 0;

                //NegativeInventory	Decimal	
                ItemLedger12.RESET;
                ItemLedger12.SETRANGE(ItemLedger12."Item No.", Item."No.");
                ItemLedger12.SETRANGE(ItemLedger12."Location Code", LocationFilter);
                ItemLedger12.SETRANGE(ItemLedger12."Posting Date", ReportDate);
                ItemLedger12.SETRANGE(ItemLedger12."Entry Type", ItemLedger12."Entry Type"::"Negative Adjmt.");
                IF ItemLedger12.FINDFIRST THEN
                    REPEAT
                        NegativeInventory += ItemLedger12.Quantity;
                    UNTIL ItemLedger12.NEXT = 0;

                //TransShipmentInventory
                TransferShipmentLine.Reset();
                TransferShipmentLine.SetRange(TransferShipmentLine."Item No.", Item."No.");
                TransferShipmentLine.SetRange(TransferShipmentLine."Transfer-from Code", LocationFilter);
                TransferShipmentLine.SetRange(TransferShipmentLine."Shipment Date", ReportDate);
                TransferShipmentLine.SetFilter(TransferShipmentLine."Transfer Reason", '%1', '');
                if TransferShipmentLine.FindFirst() then begin
                    repeat
                        TransShipmentInventory += TransferShipmentLine.Quantity;
                    until TransferShipmentLine.Next() = 0;
                end;

                //TransShipDamageInventory
                TransferShipDamageLine.Reset();
                TransferShipDamageLine.SetRange(TransferShipDamageLine."Item No.", Item."No.");
                TransferShipDamageLine.SetRange(TransferShipDamageLine."Transfer-from Code", LocationFilter);
                TransferShipDamageLine.SetRange(TransferShipDamageLine."Shipment Date", ReportDate);
                TransferShipDamageLine.SetFilter(TransferShipDamageLine."Transfer Reason", '<>%1', '');
                if TransferShipDamageLine.FindFirst() then begin
                    repeat
                        TransShipDamageInventory += TransferShipDamageLine.Quantity;
                    until TransferShipDamageLine.Next() = 0;
                end;

                //ConsumptionInventory
                ItemLedger14.RESET;
                ItemLedger14.SETRANGE(ItemLedger14."Item No.", Item."No.");
                ItemLedger14.SETRANGE(ItemLedger14."Location Code", LocationFilter);
                ItemLedger14.SETRANGE(ItemLedger14."Posting Date", ReportDate);
                ItemLedger14.SETRANGE(ItemLedger14."Entry Type", ItemLedger14."Entry Type"::Consumption);
                IF ItemLedger14.FINDFIRST THEN
                    REPEAT
                        ConsumptionInventory += ItemLedger14.Quantity;
                    UNTIL ItemLedger14.NEXT = 0;

                //PurcReturnInventory
                ItemLedger15.RESET;
                ItemLedger15.SETRANGE(ItemLedger15."Item No.", Item."No.");
                ItemLedger15.SETRANGE(ItemLedger15."Location Code", LocationFilter);
                ItemLedger15.SETRANGE(ItemLedger15."Posting Date", ReportDate);
                ItemLedger15.SETRANGE(ItemLedger15."Entry Type", ItemLedger15."Entry Type"::Purchase);
                ItemLedger15.SETRANGE(ItemLedger15."Document Type", ItemLedger15."Document Type"::"Purchase Return Shipment");
                IF ItemLedger15.FINDFIRST THEN
                    REPEAT
                        PurcReturnInventory += ItemLedger15.Quantity;
                    UNTIL ItemLedger15.NEXT = 0;

                //PurcCreditMemoInventory
                ItemLedger16.RESET;
                ItemLedger16.SETRANGE(ItemLedger16."Item No.", Item."No.");
                ItemLedger16.SETRANGE(ItemLedger16."Location Code", LocationFilter);
                ItemLedger16.SETRANGE(ItemLedger16."Posting Date", ReportDate);
                ItemLedger16.SETRANGE(ItemLedger16."Entry Type", ItemLedger16."Entry Type"::Purchase);
                ItemLedger16.SETRANGE(ItemLedger16."Document Type", ItemLedger16."Document Type"::"Purchase Credit Memo");
                IF ItemLedger16.FINDFIRST THEN
                    REPEAT
                        PurcCreditMemoInventory += ItemLedger16.Quantity;
                    UNTIL ItemLedger16.NEXT = 0;

                //Total Inventory Issued
                IssuedInventory := (SalesShipInventory +
                                    ConsumptionInventory +
                                    NegativeInventory +
                                    TransShipmentInventory +
                                    PurcReturnInventory +
                                    PurcCreditMemoInventory);
                Message('%1, %2, %3, %4, %5, %6', SalesShipInventory,
                                    ConsumptionInventory,
                                    NegativeInventory,
                                    TransShipmentInventory,
                                    PurcReturnInventory,
                                    PurcCreditMemoInventory);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        ReportDate: Date;
        LocationFilter: Text[150];
        DateFilterItem: Text[150];
        StartingInventory: Decimal;
        ItemLedger: Record "Item Ledger Entry";
        CurrentInventory: Decimal;
        ReceivedInventory: Decimal;
        IssuedInventory: Decimal;
        //--------------------------Inbound---------------------------------------------	Integer
        PostiveInventory: Decimal;
        PurchReceiptInventory: Decimal;
        TransReceiptInventory: Decimal;
        SalesReturnInventory: Decimal;
        SalesCreditMemoInventory: Decimal;
        ProdOutputInventory: Decimal;
        ItemLedger1: Record "Item Ledger Entry";
        ItemLedger2: Record "Item Ledger Entry";
        ItemLedger3: Record "Item Ledger Entry";
        ItemLedger4: Record "Item Ledger Entry";
        ItemLedger5: Record "Item Ledger Entry";
        ItemLedger6: Record "Item Ledger Entry";
        //------------------------OutBound-----------------------------------------------	Integer
        SalesShipInventory: Decimal;
        ConsumptionInventory: Decimal;
        NegativeInventory: Decimal;
        TransShipmentInventory: Decimal;
        TransShipDamageInventory: Decimal;
        PurcReturnInventory: Decimal;
        PurcCreditMemoInventory: Decimal;
        ItemLedger11: Record "Item Ledger Entry";
        ItemLedger12: Record "Item Ledger Entry";
        ItemLedger13: Record "Item Ledger Entry";
        ItemLedger14: Record "Item Ledger Entry";
        ItemLedger15: Record "Item Ledger Entry";
        ItemLedger16: Record "Item Ledger Entry";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferShipDamageHeader: Record "Transfer Shipment Header";
        TransferShipDamageLine: Record "Transfer Shipment Line";

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        LocationFilter := Item.GETFILTER("Location Filter");
        DateFilterItem := Item.GETFILTER("Date Filter");
        EVALUATE(ReportDate, DateFilterItem);
        if (LocationFilter = '') then
            Error('Location Filter Can not be Empty');

        if DateFilterItem = '' then
            Error('Date Filter Can not be Empty');

    end;
}
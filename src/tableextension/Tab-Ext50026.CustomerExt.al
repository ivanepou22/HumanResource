tableextension 50026 "CustomerExt" extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Allow Sale Beyond Credit limit"; Boolean) { }
        field(50010; "TIN Mandatory"; Boolean) { }
    }

    var
        myInt: Integer;

    procedure CreatePOSHeader(LocationCode: Code[10]; Drawer: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesPOS: Page "Sales Order POS";
        OrderNo: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("Document Type Pos", '<>%1', SalesHeader."Document Type Pos"::Receipt);
        SalesHeader.SetFilter(Drawer, '<>%1', '');
        SalesHeader.SETFILTER("No.", '<>%1', '');
        SalesHeader.SETRANGE("User ID", USERID);
        IF SalesHeader.FINDFIRST THEN BEGIN
            SalesHeader.VALIDATE(SalesHeader."Posting Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader."Document Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader."Shipment Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader."Due Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader.Drawer, Drawer);
            SalesHeader.VALIDATE(SalesHeader."Location Code", LocationCode);
            SalesHeader.MODIFY;
            CLEAR(SalesPOS);
            SalesPOS.SETTABLEVIEW(SalesHeader);
            SalesPOS.EDITABLE := TRUE;
            Message('Your Welcome to Point Of Sale');
            SalesPOS.Run()
        END ELSE BEGIN
            CLEAR(SalesHeader);
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            SalesHeader."Document Type Pos" := SalesHeader."Document Type Pos"::Order;
            SalesHeader.VALIDATE("Document Date", WORKDATE);
            SalesHeader.Validate(SalesHeader."Posting Date", WorkDate());
            SalesHeader.Validate(SalesHeader."Shipment Date", WorkDate());
            SalesHeader.Validate(SalesHeader."Due Date", WorkDate());
            SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", "No.");
            SalesHeader.SetHideValidationDialog(TRUE);
            SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.", "No.");
            SalesHeader.VALIDATE(SalesHeader."VAT Bus. Posting Group", "VAT Bus. Posting Group");
            SalesHeader.VALIDATE(SalesHeader."User ID", USERID);
            SalesHeader.VALIDATE(SalesHeader.Drawer, Drawer);
            OrderNo := SalesHeader."No.";
            SalesHeader.INSERT(TRUE);
            CLEAR(SalesPOS);
            SalesHeader2.RESET;
            SalesHeader2.SETRANGE("Document Type", SalesHeader2."Document Type"::Order);
            SalesHeader2.SETRANGE("No.", OrderNo);
            IF SalesHeader2.FINDFIRST THEN BEGIN
                SalesHeader2.VALIDATE(SalesHeader2."Location Code", LocationCode);
                SalesHeader2.MODIFY;
                SalesPOS.SETTABLEVIEW(SalesHeader2);
                SalesPOS.EDITABLE := TRUE;
                Message('Your Welcome to Point Of Sale');
                SalesPOS.Run();
            END;
        END;
    end;

    procedure CreatPOSHeaderwhole(LocationCode: Code[10];
       Drawer: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesPOSwhole: Page "Sales Order POSwholesales";
        UserSetup: Record "User Setup";
        OrderNo: Code[20];
    begin
        UserSetup.GET(USERID);
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETFILTER("No.", '<>%1', '');
        SalesHeader.SETRANGE("User ID", USERID);
        IF SalesHeader.FINDFIRST THEN BEGIN
            SalesHeader.VALIDATE(SalesHeader."Posting Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader."Document Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader."Shipment Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader."Due Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader.Drawer, Drawer);
            SalesHeader.VALIDATE(SalesHeader."Location Code", LocationCode);
            SalesHeader.MODIFY;
            CLEAR(SalesPOSwhole);
            SalesPOSwhole.SETTABLEVIEW(SalesHeader);
            SalesPOSwhole.EDITABLE := TRUE;
            SalesPOSwhole.RUN;
        END ELSE BEGIN
            CLEAR(SalesHeader);
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            SalesHeader.VALIDATE("No.", UserSetup."Sales Order Nos.");
            SalesHeader.VALIDATE("Document Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader."Posting Date", WORKDATE);
            SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", "No.");
            SalesHeader.SetHideValidationDialog(TRUE);
            SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.", "No.");
            SalesHeader.VALIDATE(SalesHeader."VAT Bus. Posting Group", "VAT Bus. Posting Group");
            SalesHeader.VALIDATE(SalesHeader."User ID", USERID);
            SalesHeader.VALIDATE(SalesHeader.Drawer, Drawer);
            OrderNo := SalesHeader."No.";
            SalesHeader.INSERT(TRUE);
            CLEAR(SalesPOSwhole);
            SalesHeader2.RESET;
            SalesHeader2.SETRANGE("Document Type", SalesHeader2."Document Type"::Order);
            SalesHeader2.SETRANGE("No.", OrderNo);
            IF SalesHeader2.FINDFIRST THEN BEGIN
                SalesHeader2.VALIDATE(SalesHeader2."Location Code", LocationCode);
                SalesHeader2.MODIFY;
                SalesPOSwhole.SETTABLEVIEW(SalesHeader2);
                SalesPOSwhole.EDITABLE := TRUE;
                SalesPOSwhole.RUN;
            END;
        END;
    end;
}
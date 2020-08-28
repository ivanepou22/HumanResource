tableextension 50004 "UserSetupExt" extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50010; "Leave Administrator"; Boolean) { }
        field(50011; "HR Administrator"; Boolean) { }
        field(50012; "Finance Administrator"; Boolean) { }
        field(50013; "Restrict Sales Invoicing"; Boolean)
        {
            InitValue = true;
        }
        field(50014; "Restrict Sales Shipment"; Boolean)
        {
            InitValue = true;
        }
        field(50015; "Restrict Purchase Invoicing"; Boolean)
        {
            InitValue = true;
        }
        field(50016; "Restrict Purchase Shipment"; Boolean)
        {
            InitValue = true;
        }
        //Point of Sales Modification.
        field(50018; "Location Code"; Code[10])
        {
            TableRelation = Location.Code;
        }
        field(50019; "Sell-to Customer No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(50020; "Opening Balance"; Decimal) { }
        field(50030; "Collections (Cash Receipts)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum ("Detailed Cust. Ledg. Entry".Amount WHERE("User ID" = FIELD("User ID"), "Posting Date" = FIELD("Date Filter"), "Document Type" = FILTER(Payment), "Entry Type" = FILTER("Initial Entry")));
        }
        field(50035; "Current Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry".Amount WHERE("User ID" = FIELD("User ID"), "Posting Date" = FIELD("Date Filter"), "Entry Type" = FILTER("Initial Entry")));
        }
        field(50040; "Closing Balance"; Decimal) { }
        field(50048; Refunds; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry".Amount WHERE("User ID" = FIELD("User ID"), "Posting Date" = FIELD("Date Filter"), "Document Type" = FILTER("Credit Memo"), "Entry Type" = FILTER("Initial Entry")));
        }
        field(50050; "Sales Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50060; "Receipt Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50065; "Receipt Journal Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50070; "Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template" WHERE(Type = CONST("Cash Receipts"));
        }
        field(50080; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(50090; "Receiving Bank"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50100; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50110; "Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(50120; "Expense Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template" WHERE(Type = CONST(Payments));
        }
        field(50130; "Expense Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Expense Template Name"));
        }
        field(50140; "Expense Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50150; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50160; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50170; "Dimension Set ID"; Integer)
        {
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50180; "Custom Sales Authorizer"; Boolean) { }
        field(50190; "Custom authorizer Password"; Text[30]) { }
    }

    var
        myInt: Integer;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1', "User ID"),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;
}
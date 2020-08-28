table 50007 "Loan and Advance Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,Loan,Advance;
        }
        field(3; "Document No."; Code[20])
        {
            TableRelation = "Loan and Advance Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Line No."; Integer) { }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(false));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(false));
        }

        field(40; "Sell-to Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(50; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50100; "Resource No."; Code[50])
        {
            TableRelation = Resource."No." WHERE(Type = FILTER(Person));
        }
        field(50200; "Receipt Line Amount"; Decimal) { }
        field(50210; "Ledger Entry No."; Integer) { }
        field(50220; "Fee Item"; Code[20]) { }
        field(50240; "Fee Amount"; Decimal) { }
        field(50300; "Employee No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Min ("Loan and Advance Header"."Employee No." WHERE("Document Type" = FIELD("Document Type"), "No." = FIELD("Document No.")));
        }
        field(50310; Period; Code[10])
        {
            Editable = false;
        }
        field(50320; Created; Date)
        {
            Editable = false;
        }
        field(50330; Interest; Decimal)
        {
            Editable = false;
        }
        field(50331; Repayment; Decimal)
        {
            Editable = false;
        }
        field(50335; "Remaining Debt"; Decimal)
        {
            Editable = false;
        }
        field(50340; Posted; Boolean)
        {
            Editable = false;
        }
        field(50345; "Transfered To Payroll"; Boolean)
        {
            Editable = false;
        }
        field(50346; "Interest Cleared"; Boolean)
        {
            Editable = false;
        }
        field(50347; "Loan Cleared"; Boolean)
        {
            Editable = false;
        }
        field(50350; "Advance Cleared"; Boolean)
        {
            Editable = false;
        }
        field(50800; "Booking No."; Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FILTER(Quote));
        }
        field(50830; "Ledge Entry No."; Integer) { }
        field(50840; "Applies-to Code"; Code[20]) { }
        field(50850; "Slip No."; Code[20]) { }
        field(50860; "Receipt Description"; Text[50]) { }
        field(50870; "Payment Method"; Text[50]) { }
        field(50880; "Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Constituent;
        }
        field(50885; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
        }
        field(50890; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Account Type" = CONST(Customer)) Customer ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(50900; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Constituent;
        }
        field(50910; "Bal. Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Account Type" = CONST(Customer)) Customer ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(55000; "Dimension ID"; Integer)
        {

        }
    }

    keys
    {
        key(PK; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        ShortcutDimCode: array[8] of Code[20];
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure ShowShortcutDimCode()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}
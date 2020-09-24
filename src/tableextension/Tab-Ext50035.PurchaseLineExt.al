tableextension 50035 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Status; Option)
        {
            OptionMembers = Open,Released,"Pending Approval","Pending prepayment";
        }
        field(50001; "G/L Account"; Code[10]) { }
        field(50010; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,3';
        }
        field(50020; "Order Type"; Option)
        {
            OptionMembers = Order,"Contract Purchase Agreement","Local Purchase Agreement";
        }
        field(50025; "Shortcut Dimension 4 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,4';
        }
        field(50030; "WHT Exempt"; Boolean)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                //UpdateVATAmounts;
            end;
        }
        field(50031; "WHT Amount"; Decimal)
        {
            Editable = false;
        }
        field(50034; "WHT Taxable Amount"; Decimal) { }
        field(50035; "Shortcut Dimension 5 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,5';
        }
        field(50040; "Shortcut Dimension 6 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,6';
        }
        field(50050; "Shortcut Dimension 7 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,7';
        }
        field(50060; "Shortcut Dimension 8 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,8';
        }
        field(50070; "Posting Date"; Date) { }
        field(50075; "CPA No."; Code[20]) { }
        field(50080; "Balance at Date"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry".Amount WHERE("G/L Account No." = FIELD("G/L Account"), "Dimension Set ID" = FIELD("Dimension Set ID"), "Posting Date" = FIELD("Date Filter")));
        }
        field(50090; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50100; "Item Journal Template Name"; Code[10])
        {
            TableRelation = "Item Journal Template";
        }
        field(50110; "Item No."; Code[20])
        {
            TableRelation = Item;
            trigger OnValidate()
            var
                ProdOrderLine: Record "Prod. Order Line";
                ProdOrderComp: Record "Prod. Order Component";
                ItemRecord: Record Item;
                ItemNo: Code[20];
                Item: Record Item;
            begin
                ItemNo := "Item No.";
                VALIDATE("No.", "Item No.");
                "Item No." := ItemNo;
                IF ItemRecord.GET("Item No.") THEN
                    "Item Unit of Measure Code" := Item."Base Unit of Measure";
                "Item Entry Type" := "Item Entry Type"::"Negative Adjmt.";
            end;
        }
        field(50120; "Item Entry Type"; Option)
        {
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output,,"Assembly Consumption","Assembly Output";
        }
        field(50130; "Item Source No."; Code[20])
        {
            Editable = false;
        }
        field(50140; "Item Location Code"; Code[10])
        {
            TableRelation = item;
        }
        field(50150; "Inventory Posting Group"; Code[10])
        {
            Editable = false;
            TableRelation = "Inventory Posting Group";
        }
        field(50160; "Source Posting Group"; Code[10])
        {
            Editable = false;
            TableRelation = "Inventory Posting Group";
        }
        field(50170; "Item Quantity"; Decimal)
        {
            trigger OnValidate()
            begin
                VALIDATE(Quantity, "Item Quantity");
            end;
        }
        field(50180; "Item Invoiced Quantity"; Decimal)
        {
            Editable = false;
        }
        field(50190; "Item Unit Amount"; Decimal) { }
        field(50200; "Item Unit Cost"; Decimal) { }
        field(50210; "Item Amount"; Decimal) { }
        field(50220; "Item Applies-to Entry"; Integer) { }
        field(50250; "Item Source Type"; Option)
        {
            OptionMembers = " ",Customer,Vendor,Item;
            Editable = false;
        }
        field(50260; "Item Journal Batch Name"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Item Journal Template Name"));
        }
        field(50270; "Item External Document No."; Code[35]) { }
        field(50280; "Item Unit of Measure Code"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(50640; "Driver No."; Code[20])
        {
            TableRelation = Resource WHERE(Type = CONST(Person));
        }
        field(50650; "Fleet Status"; Option)
        {
            OptionMembers = Open,Posted;
        }
        field(50660; "Authorising Officer"; Text[30]) { }
        field(50670; Authorised; Boolean) { }
        field(50680; "Start Mileage Reading"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF MvmttLine.FIND('+') THEN BEGIN
                    MvmttLine.SETRANGE("Document No.", "Document No.");
                    IF (MvmttLine.COUNT > 0) AND ("Line No." = 0) THEN BEGIN
                        IF "Start Mileage Reading" <> MvmttLine."End Mileage Reading" THEN BEGIN
                            "Start Mileage Reading" := MvmttLine."End Mileage Reading";
                            MESSAGE('The Start Mileage must be the same as the previous End Mileage');
                        END;
                    END;

                    IF (MvmttLine.COUNT > 1) AND ("Line No." > 10000) THEN BEGIN
                        MvmttLine."Document No." := "Document No.";
                        MvmttLine."Line No." := "Line No." - 10000;
                        //MvmttLine."Document Type" := MvmttLine."Document Type"::;
                        MvmttLine.FIND;
                        IF "Start Mileage Reading" <> MvmttLine."End Mileage Reading" THEN BEGIN
                            "Start Mileage Reading" := MvmttLine."End Mileage Reading";
                            MESSAGE('The Start Mileage must be the same as the previous End Mileage');
                        END ELSE
                            EXIT;
                    END;
                END;
            end;
        }
        field(50690; "End Mileage Reading"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "End Mileage Reading" < "Start Mileage Reading" THEN
                    ERROR('The End Milage Reading cannot be less than the Start Milage Reading on the trip ');
            end;
        }
        field(50700; "Trip Purpose"; Option)
        {
            OptionMembers = Official,"Un-Official";
        }
        field(50710; "Departure Point"; Code[10])
        {
            TableRelation = Location;
        }
        field(50720; "Destination Point"; Code[10])
        {
            TableRelation = Location;
        }
        field(50730; "Trip Type"; Option)
        {
            OptionMembers = "Within Station","Out Station";
        }
        field(50740; "Invoice/Voucher No."; Code[20])
        {
            TableRelation = "Voucher And Receipt" WHERE("Document Type" = CONST("Fleet Voucher"));
        }
        field(50750; "Departure Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                MvmttLine.SETRANGE("Document No.", "Document No.");
                IF MvmttLine.FIND('+') THEN BEGIN
                    IF (MvmttLine.COUNT > 0) AND ("Line No." = 0) THEN BEGIN
                        IF "Departure Date" < MvmttLine."Return Date" THEN
                            ERROR('The departure time can not be earlier than the previous return time')
                        ELSE
                            EXIT;
                    END;

                    IF (MvmttLine.COUNT > 1) AND ("Line No." > 10000) THEN BEGIN
                        MvmttLine."Document No." := "Document No.";
                        MvmttLine."Line No." := "Line No." - 10000;
                        //MvmttLine."Document Type" := MvmttLine."Document Type"::"13";
                        MvmttLine.FIND;
                        IF "Departure Date" < MvmttLine."Return Date" THEN
                            ERROR('The departure time can not be earlier than the previous return time')
                        ELSE
                            EXIT;
                    END;
                END;
            end;
        }
        field(50760; "Return Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Return Date" < "Departure Date" THEN
                    ERROR('The Return time cannot be earlier than the Depart Time');
            end;
        }
        field(50770; "Departure Time"; Time)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                //IF MvmttLine.FIND('-') THEN BEGIN
                MvmttLine.SETRANGE("Document No.", "Document No.");
                IF MvmttLine.FIND('+') THEN BEGIN
                    IF (MvmttLine.COUNT > 0) AND ("Line No." = 0) THEN BEGIN
                        IF "Departure Date" < MvmttLine."Return Date" THEN
                            ERROR('The departure time can not be earlier than the previous return time')
                        ELSE
                            EXIT;
                    END;

                    IF (MvmttLine.COUNT > 1) AND ("Line No." > 10000) THEN BEGIN
                        MvmttLine."Document No." := "Document No.";
                        MvmttLine."Line No." := "Line No." - 10000;
                        //MvmttLine."Document Type" := MvmttLine."Document Type"::"13";
                        MvmttLine.FIND;
                        IF "Departure Date" < MvmttLine."Return Date" THEN
                            ERROR('The departure time can not be earlier than the previous return time')
                        ELSE
                            EXIT;
                    END;
                END;
            end;
        }
        field(50780; "Return Time"; Time)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Return Date" < "Departure Date" THEN
                    ERROR('The Return time cannot be earlier than the Depart Time');
            end;
        }
        field(50790; "Trip No."; Code[20])
        {
            Editable = false;
        }
        field(50800; "No. of Litres	"; Integer) { }
        field(50810; "Service Requist"; Option)
        {
            OptionMembers = Fuel,"Repair & Maintenance",Wash,"Tyre Replacement";
        }
        field(50820; "Recharge Option"; Option)
        {
            OptionMembers = Card,Order;
        }
        field(50830; Fleet; Boolean) { }
        field(50900; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50910; "Bal. Account No."; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false)) ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(50920; "Requisition Type"; Option)
        {
            OptionMembers = " ",Service,Stores,Advance,Contract,Item;
        }
        field(50925; "VAT. %"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF (("Unit Cost Excl. VAT" <> 0) AND ("VAT. %" <> 0)) THEN
                    VALIDATE("Direct Unit Cost", ("Unit Cost Excl. VAT" * ("VAT. %" + 100) / 100))
                ELSE
                    IF (("Unit Cost Excl. VAT" <> 0) AND ("VAT. %" = 0)) THEN
                        VALIDATE("Direct Unit Cost", "Unit Cost Excl. VAT");

                IF (("Direct Unit Cost" <> 0) AND ("VAT. %" <> 0) AND ("Unit Cost Excl. VAT" = 0)) THEN
                    "Unit Cost Excl. VAT" := (("Direct Unit Cost" * 100) / (100 + "VAT. %"));

                "WHT Taxable Amount" := ((("Direct Unit Cost" * 100) / (100 + "VAT. %")) * Quantity);
            end;
        }
        field(50930; "Unit Cost Excl. VAT"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF (("Unit Cost Excl. VAT" <> 0) AND ("VAT. %" <> 0)) THEN
                    VALIDATE("Direct Unit Cost", ("Unit Cost Excl. VAT" * ("VAT. %" + 100) / 100))
                ELSE
                    IF (("Unit Cost Excl. VAT" <> 0) AND ("VAT. %" = 0)) THEN
                        VALIDATE("Direct Unit Cost", "Unit Cost Excl. VAT");

                "WHT Taxable Amount" := ("Unit Cost Excl. VAT" * Quantity);
            end;
        }
        field(50940; "Transfered To Journal"; Boolean)
        {
            // Editable = false;
        }

        field(50950; "Payment Requistion Journal"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Template Type" = CONST(Payments));
        }
        field(50955; "Item Vendor No."; Code[30])
        {
            Editable = false;
        }
    }


    var
        MvmtHeader: Record "Purchase Header";
        MvmttLine: Record "Purchase Line";
        Vehicle: Record "Fixed Asset";
}
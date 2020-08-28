tableextension 50052 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
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
            Editable = false;
        }
        field(50040; "Invoiced Amount"; Decimal)
        {
            Editable = false;
        }
        field(50050; "Paid Amount"; Decimal)
        {
            Editable = false;
        }
        field(50060; "Commited Amount"; Decimal)
        {
            Editable = false;
        }
        field(50070; "Uninvoiced Amount"; Decimal)
        {
        }
        field(50100; "Purchase Vendor No."; Code[20])
        {
            TableRelation = Vendor;
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
            Editable = false;
        }
        field(50950; "Reference No."; Code[20])
        {
        }
        field(50960; "Vehicle No."; Code[20])
        {
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
        myInt: Integer;
}
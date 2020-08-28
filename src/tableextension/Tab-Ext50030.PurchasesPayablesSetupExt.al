tableextension 50030 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {

        field(50000; "Contract Purch. Agrreement Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50010; "Local Purchase Agreement Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50015; "Payment-Invoice App. Mandatory"; Boolean) { }
        field(50020; "Default Vendor"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50030; "Payment Requistion Journal"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Template Type" = CONST(Payments));
        }
        field(50040; "Payment Requisition Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50050; "Advance Accountability Journal"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Template Type" = CONST(Payments));
        }
        field(50060; "Advance Accountability Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50070; "Stores Requisition Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50075; "Advanced Requistion Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50080; "Service Requisition Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50085; "Contract Requisition Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50086; "Item Requisition Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50090; "Posting Description"; Option)
        {
            OptionMembers = Default,"Vendor Name","Vendor Invoice and Name","Vendor Document Line";
        }
        field(50100; "WHT Tax Payable Account"; Code[10])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50110; "WHT Deduction Policy"; Option)
        {
            OptionMembers = "First Payment","Last Payment",Prorated;
        }
        field(50120; "WHT Min. Qualifying Amount"; Decimal) { }
        field(50130; "WHT Percentage"; Decimal)
        {
            MinValue = 0;
            MaxValue = 100;
        }
        field(50140; "Tax Authority Vendor Account"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50141; "Allow Direct Invoices"; Boolean)
        {

        }

        field(50142; "Use User Location"; Boolean)
        {

        }
    }

    var
        myInt: Integer;
}
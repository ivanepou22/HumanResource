tableextension 50051 "BankAccount Statement Line Ext" extends "Bank Account Statement Line" //276
{
    fields
    {
        field(50000; Clear; Boolean) { }
        field(50010; "Cleared Date"; Date) { }
        field(50020; Cleared; Boolean) { }
        field(50030; "Applied Entry"; Integer)
        {
            TableRelation = "Bank Account Ledger Entry"."Entry No." WHERE("Bank Account No." = FIELD("Bank Account No."), Open = CONST(true));
        }
        field(50935; "Diff Closing Statement Number"; Code[30])
        {
            Editable = false;
        }
        field(50936; "Difference Closing Date"; Date)
        {
            Editable = false;
        }
    }

}
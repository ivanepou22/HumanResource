pageextension 50083 "Purchase Journal Ext" extends "Purchase Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        JournalBatch: Record "Gen. Journal Batch";
        ASL001: Label 'Your not Allow to Access %1 Journal. Please Contact Your Administrator.';

    trigger OnOpenPage()
    begin
        JournalBatch.Reset();
        JournalBatch.SetRange(JournalBatch.Name, Rec."Journal Batch Name");
        if JournalBatch.FindFirst() then begin
            if JournalBatch."Batch User" <> '' then begin
                if JournalBatch."Batch User" <> UserId then begin
                    Error(ASL001, JournalBatch.Name);
                end;
            end;
        end;
    end;
}
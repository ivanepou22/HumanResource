codeunit 50001 "Modify Jornals"
{
    //Payment Journal Get the value for GL Name Field
    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnAfterValidateEvent', 'Account No.', true, true)]
    procedure modifyGlName(var Rec: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Reset();
        GLAccount.SetRange("No.", Rec."Account No.");
        if GLAccount.FindFirst() then
            rec."GL Name" := GLAccount.Name;
        Rec."Prepared by" := UserId;
    end;

    //General Journal Get the value for GL Name Field
    [EventSubscriber(ObjectType::Page, Page::"General Journal", 'OnAfterValidateEvent', 'Account No.', true, true)]
    procedure modifyGeneralJournal(var Rec: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Reset();
        GLAccount.SetRange("No.", Rec."Account No.");
        if GLAccount.FindFirst() then
            rec."GL Name" := GLAccount.Name;
        Rec."Prepared by" := UserId;
    end;

    //Cash Receipt Journal Get the value for GL Name Field
    [EventSubscriber(ObjectType::Page, Page::"Cash Receipt Journal", 'OnAfterValidateEvent', 'Account No.', true, true)]
    procedure modifyCashReceiptJournal(var Rec: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Reset();
        GLAccount.SetRange("No.", Rec."Account No.");
        if GLAccount.FindFirst() then
            rec."GL Name" := GLAccount.Name;
        Rec."Prepared by" := UserId;
    end;

    //Modifying the GL Name Field when the line is modified
    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnModifyRecordEvent', '', true, true)]
    local procedure ModifyOnEdit(var Rec: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        if Rec."Account No." <> '' then begin
            GLAccount.Reset();
            GLAccount.SetRange("No.", Rec."Account No.");
            if GLAccount.FindFirst() then
                rec."GL Name" := GLAccount.Name;
        end;
        Rec."Prepared by" := UserId;
    end;

    //

}
pageextension 50018 "IncomingDoc Attach FactBox Ext" extends "Incoming Doc. Attach. FactBox"
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
        myInt: Integer;

    procedure LoadDataFromEmployeeRecord("Employee No.": Code[20]; Category: Code[20])
    var
        myInt: Integer;
        IncomingDocument: Record "Incoming Document";
    begin
        DELETEALL;
        IncomingDocument.SETRANGE("Employee No.", "Employee No.");
        IF Category <> '' THEN
            IncomingDocument.SETRANGE(Category, Category);
        IF IncomingDocument.FINDSET THEN
            REPEAT
                InsertFromEmployeeIncomingDoc(IncomingDocument, Rec);
            UNTIL IncomingDocument.NEXT = 0;
        CurrPage.UPDATE(FALSE);
    end;
}
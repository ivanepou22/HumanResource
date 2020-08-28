page 50014 "File Uploads"
{
    Caption = 'File Uploads';
    PageType = List;
    SourceTable = "File Upload";
    DataCaptionFields = "Employee No.";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                Field("Misc. Article Code"; "Misc. Article Code")
                {
                    ApplicationArea = All;
                }
                Field(Description; Description)
                {
                    ApplicationArea = All;
                }
                Field("Serial No."; "Serial No.")
                {
                    ApplicationArea = All;
                }
                Field("From Date"; "From Date")
                {
                    ApplicationArea = All;
                }
                Field("To Date"; "To Date")
                {
                    ApplicationArea = All;
                }
                Field("In Use"; "In Use")
                {
                    ApplicationArea = All;
                }
                Field(Comment; Comment)
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Attach File")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = Attach;

                trigger OnAction();
                var
                    IncomingDocumentAttachment: Record "Incoming Document Attachment";
                    IncomingDocument: Record "Incoming Document";

                begin
                    IF IncomingDocumentAttachment.Import THEN
                        IF IncomingDocument.GET(IncomingDocumentAttachment."Incoming Document Entry No.") THEN
                            REPEAT
                                IncomingDocument."Employee No." := "Employee No.";
                                IncomingDocument.Category := "Misc. Article Code";
                                IncomingDocument.MODIFY;
                            UNTIL IncomingDocument.NEXT = 0;
                end;
            }
        }
    }
    var
        IncomingDocuments: Record "Incoming Document";
        MainRecordRef: RecordRef;
        StyleExpressionTxt: Text;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin

        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromEmployeeRecord("Employee No.", "Misc. Article Code");
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin

    end;
}
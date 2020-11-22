codeunit 50010 "TransferOrderPost (Yes/No)"
{
    TableNo = "Transfer Header";

    trigger OnRun()
    begin
        TransHeader.Copy(Rec);
        Code;
        Rec := TransHeader;
    end;

    var
        Text000: Label '&Ship,&Receive';
        TransHeader: Record "Transfer Header";
        UserLocations: Record "User Locations";

    local procedure "Code"()
    var
        TransLine: Record "Transfer Line";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        DefaultNumber: Integer;
        Selection: Option " ",Shipment,Receipt;
        IsHandled: Boolean;
    begin
        OnBeforePost(TransHeader, IsHandled);
        if IsHandled then
            exit;

        with TransHeader do begin
            TransLine.SetRange("Document No.", "No.");
            if TransLine.Find('-') then
                repeat
                    if (TransLine."Quantity Shipped" < TransLine.Quantity) and
                       (DefaultNumber = 0)
                    then
                        DefaultNumber := 1;
                    if (TransLine."Quantity Received" < TransLine.Quantity) and
                       (DefaultNumber = 0)
                    then
                        DefaultNumber := 2;
                until (TransLine.Next = 0) or (DefaultNumber > 0);
            if "Direct Transfer" then begin
                TransferPostShipment.Run(TransHeader);
                TransferPostReceipt.Run(TransHeader);
            end else begin
                if DefaultNumber = 0 then
                    DefaultNumber := 1;
                Selection := StrMenu(Text000, DefaultNumber);
                case Selection of
                    0:
                        exit;
                    Selection::Shipment:
                        begin
                            //Check for the location assigned to the user
                            UserLocations.RESET;
                            UserLocations.SETRANGE(UserLocations."User ID", USERID);
                            UserLocations.SETRANGE(UserLocations."Location Code", TransHeader."Transfer-from Code");
                            IF UserLocations.FINDFIRST THEN BEGIN
                                TransferPostShipment.Run(TransHeader);
                            END ELSE
                                ERROR('Your not allowed to Perform this action. Contact your systems Administrator');
                        end;
                    Selection::Receipt:
                        begin
                            //Check for the location assigned to the user
                            UserLocations.RESET;
                            UserLocations.SETRANGE(UserLocations."User ID", USERID);
                            UserLocations.SETRANGE(UserLocations."Location Code", TransHeader."Transfer-to Code");
                            IF UserLocations.FINDFIRST THEN BEGIN
                                TransferPostReceipt.Run(TransHeader);
                            END ELSE
                                ERROR('Your not allowed to Perform this action. Contact your systems Administrator');
                        end;
                end;
            end;
        end;

        OnAfterPost(TransHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var TransHeader: Record "Transfer Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePost(var TransHeader: Record "Transfer Header"; var IsHandled: Boolean)
    begin
    end;
}


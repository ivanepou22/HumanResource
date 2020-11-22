codeunit 50008 "Sales-Post Modified"
{
    EventSubscriberInstance = Manual;
    TableNo = "Sales Header";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Find then
            Error(NothingToPostErr);

        SalesHeader.Copy(Rec);
        Code(SalesHeader, false);
        Rec := SalesHeader;
    end;

    var
        ShipInvoiceQst: Label '&Ship,&Invoice,Ship &and Invoice';
        PostConfirmQst: Label 'Do you want to post the %1?', Comment = '%1 = Document Type';
        ReceiveInvoiceQst: Label '&Receive,&Invoice,Receive &and Invoice';
        NothingToPostErr: Label 'There is nothing to post.';

    [Scope('OnPrem')]
    procedure PostAndSend(var SalesHeader: Record "Sales Header")
    var
        SalesHeaderToPost: Record "Sales Header";
    begin
        SalesHeaderToPost.Copy(SalesHeader);
        Code(SalesHeaderToPost, true);
        SalesHeader := SalesHeaderToPost;
    end;

    local procedure "Code"(var SalesHeader: Record "Sales Header"; PostAndSend: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPostViaJobQueue: Codeunit "Sales Post via Job Queue";
        HideDialog: Boolean;
        IsHandled: Boolean;
        DefaultOption: Integer;
    begin
        HideDialog := false;
        IsHandled := false;
        DefaultOption := 3;
        OnBeforeConfirmSalesPost(SalesHeader, HideDialog, IsHandled, DefaultOption, PostAndSend);
        if IsHandled then
            exit;

        if not HideDialog then
            if not ConfirmPost(SalesHeader, DefaultOption) then
                exit;

        OnAfterConfirmPost(SalesHeader);

        SalesSetup.Get();
        if SalesSetup."Post with Job Queue" and not PostAndSend then
            SalesPostViaJobQueue.EnqueueSalesDoc(SalesHeader)
        else
            CODEUNIT.Run(CODEUNIT::"Sales-Post", SalesHeader);

        OnAfterPost(SalesHeader);
    end;

    local procedure ConfirmPost(var SalesHeader: Record "Sales Header"; DefaultOption: Integer): Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
        Selection: Integer;
        SalesLines: Record "Sales Line";
        saleSetup: Record "Sales & Receivables Setup";
        UserLocations: Record "User Locations";
        ASL001: Label 'You can Not Perform this action. Contact Your System Administrator to Assign you to this Location.';
    begin
        if DefaultOption > 3 then
            DefaultOption := 3;
        if DefaultOption <= 0 then
            DefaultOption := 1;

        with SalesHeader do begin
            case "Document Type" of
                "Document Type"::Order:
                    begin
                        Selection := StrMenu(ShipInvoiceQst, DefaultOption);

                        //Using location Regulators
                        //Ship and invoice
                        saleSetup.Get();
                        if saleSetup."Use User Location" = true then begin
                            IF Selection = 3 THEN BEGIN
                                SalesLines.RESET;
                                SalesLines.SETRANGE(SalesLines."Document Type", SalesLines."Document Type"::Order);
                                SalesLines.SETRANGE(SalesLines."Document No.", SalesHeader."No.");
                                IF SalesLines.FINDFIRST THEN BEGIN
                                    UserLocations.RESET;
                                    UserLocations.SETRANGE(UserLocations."User ID", USERID);
                                    UserLocations.SETRANGE(UserLocations."Location Code", SalesLines."Location Code");
                                    IF UserLocations.FINDFIRST THEN BEGIN
                                        //Selection := STRMENU(ShipInvoiceQst,3);
                                    END ELSE
                                        ERROR(ASL001);
                                END;
                            END;
                        end;
                        //end Ship and invoice

                        //Shipment

                        if saleSetup."Use User Location" = true then begin
                            IF Selection IN [1, 3] THEN BEGIN
                                SalesLines.RESET;
                                SalesLines.SETRANGE(SalesLines."Document Type", SalesLines."Document Type"::Order);
                                SalesLines.SETRANGE(SalesLines."Document No.", SalesHeader."No.");
                                IF SalesLines.FINDFIRST THEN
                                    REPEAT
                                        UserLocations.RESET;
                                        UserLocations.SETRANGE(UserLocations."User ID", USERID);
                                        UserLocations.SETRANGE(UserLocations."Location Code", SalesLines."Location Code");
                                        IF UserLocations.FINDFIRST THEN BEGIN
                                            Ship := Selection IN [1, 3];
                                        END ELSE
                                            ERROR(ASL001);
                                    UNTIL SalesLines.NEXT = 0;
                            END;
                        end else
                            Ship := Selection in [1, 3];
                        //end Shipment
                        Invoice := Selection in [2, 3];
                        if Selection = 0 then
                            exit(false);
                    end;
                "Document Type"::"Return Order":
                    begin
                        Selection := StrMenu(ReceiveInvoiceQst, DefaultOption);
                        if Selection = 0 then
                            exit(false);
                        Receive := Selection in [1, 3];
                        Invoice := Selection in [2, 3];
                    end
                else
                    if not ConfirmManagement.GetResponseOrDefault(
                         StrSubstNo(PostConfirmQst, LowerCase(Format("Document Type"))), true)
                    then
                        exit(false);
            end;
            "Print Posted Documents" := false;
        end;
        exit(true);
    end;

    procedure Preview(var SalesHeader: Record "Sales Header")
    var
        SalesPostYesNo: Codeunit "Sales-Post Modified";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
    begin
        BindSubscription(SalesPostYesNo);
        GenJnlPostPreview.Preview(SalesPostYesNo, SalesHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterConfirmPost(var SalesHeader: Record "Sales Header")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 19, 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
    begin
        with SalesHeader do begin
            Copy(RecVar);
            Receive := "Document Type" = "Document Type"::"Return Order";
            Ship := "Document Type" = "Document Type"::Order;
            Invoice := true;
        end;

        OnRunPreviewOnAfterSetPostingFlags(SalesHeader);

        SalesPost.SetPreviewMode(true);
        Result := SalesPost.Run(SalesHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunPreviewOnAfterSetPostingFlags(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    begin
    end;
}


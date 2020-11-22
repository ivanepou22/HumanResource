codeunit 50009 "Purch.-Post Modified"
{
    EventSubscriberInstance = Manual;
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if not Find then
            Error(NothingToPostErr);

        PurchaseHeader.Copy(Rec);
        Code(PurchaseHeader);
        Rec := PurchaseHeader;
    end;

    var
        ReceiveInvoiceQst: Label '&Receive,&Invoice,Receive &and Invoice';
        PostConfirmQst: Label 'Do you want to post the %1?', Comment = '%1 = Document Type';
        ShipInvoiceQst: Label '&Ship,&Invoice,Ship &and Invoice';
        NothingToPostErr: Label 'There is nothing to post.';

    local procedure "Code"(var PurchaseHeader: Record "Purchase Header")
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchPostViaJobQueue: Codeunit "Purchase Post via Job Queue";
        HideDialog: Boolean;
        IsHandled: Boolean;
        DefaultOption: Integer;
    begin
        HideDialog := false;
        IsHandled := false;
        DefaultOption := 3;
        OnBeforeConfirmPost(PurchaseHeader, HideDialog, IsHandled, DefaultOption);
        if IsHandled then
            exit;

        if not HideDialog then
            if not ConfirmPost(PurchaseHeader, DefaultOption) then
                exit;

        OnAfterConfirmPost(PurchaseHeader);

        PurchSetup.Get();
        if PurchSetup."Post with Job Queue" then
            PurchPostViaJobQueue.EnqueuePurchDoc(PurchaseHeader)
        else begin
            OnBeforeRunPurchPost(PurchaseHeader);
            CODEUNIT.Run(CODEUNIT::"Purch.-Post", PurchaseHeader);
        end;

        OnAfterPost(PurchaseHeader);
    end;

    local procedure ConfirmPost(var PurchaseHeader: Record "Purchase Header"; DefaultOption: Integer): Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
        Selection: Integer;
        PurchaseLines: Record "Purchase Line";
        PurchaseSetup: Record "Purchases & Payables Setup";
        UserLocations: Record "User Locations";
        ASL001: Label 'You can Not Perform this action. Contact Your System Administrator to Assign you to this Location.';

    begin
        if DefaultOption > 3 then
            DefaultOption := 3;
        if DefaultOption <= 0 then
            DefaultOption := 1;

        with PurchaseHeader do begin
            case "Document Type" of
                "Document Type"::Order:
                    begin
                        Selection := StrMenu(ReceiveInvoiceQst, DefaultOption);
                        //Receive&Invoice
                        PurchaseSetup.Get();
                        if PurchaseSetup."Use User Location" = true then begin

                            IF Selection = 3 THEN BEGIN
                                PurchaseLines.RESET;
                                PurchaseLines.SETRANGE(PurchaseLines."Document Type", PurchaseLines."Document Type"::Order);
                                PurchaseLines.SETRANGE(PurchaseLines."Document No.", PurchaseHeader."No.");
                                IF PurchaseLines.FINDFIRST THEN BEGIN
                                    UserLocations.RESET;
                                    UserLocations.SETRANGE(UserLocations."User ID", USERID);
                                    UserLocations.SETRANGE(UserLocations."Location Code", PurchaseLines."Location Code");
                                    IF UserLocations.FINDFIRST THEN BEGIN
                                        //Selection := STRMENU(ShipInvoiceQst,3);
                                    END ELSE
                                        ERROR(ASL001);
                                END;
                            END;
                        end;
                        //End Receive&Invoice

                        if Selection = 0 then
                            exit(false);


                        //Receive
                        if PurchaseSetup."Use User Location" = true then begin
                            IF Selection IN [1, 3] THEN BEGIN
                                PurchaseLines.RESET;
                                PurchaseLines.SETRANGE(PurchaseLines."Document Type", PurchaseLines."Document Type"::Order);
                                PurchaseLines.SETRANGE(PurchaseLines."Document No.", PurchaseHeader."No.");
                                IF PurchaseLines.FINDFIRST THEN
                                    REPEAT
                                        UserLocations.RESET;
                                        UserLocations.SETRANGE(UserLocations."User ID", USERID);
                                        UserLocations.SETRANGE(UserLocations."Location Code", PurchaseLines."Location Code");
                                        IF UserLocations.FINDFIRST THEN BEGIN
                                            Receive := Selection in [1, 3];
                                        END ELSE
                                            ERROR(ASL001);
                                    UNTIL PurchaseLines.NEXT = 0;
                            END;
                        end else
                            Receive := Selection in [1, 3];
                        //End Receive

                        Invoice := Selection in [2, 3];
                    end;
                "Document Type"::"Return Order":
                    begin
                        Selection := StrMenu(ShipInvoiceQst, DefaultOption);
                        if Selection = 0 then
                            exit(false);
                        Ship := Selection in [1, 3];
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

    procedure Preview(var PurchaseHeader: Record "Purchase Header")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        PurchPostYesNo: Codeunit "Purch.-Post Modified";
    begin
        BindSubscription(PurchPostYesNo);
        GenJnlPostPreview.Preview(PurchPostYesNo, PurchaseHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterConfirmPost(PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 19, 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        with PurchaseHeader do begin
            Copy(RecVar);
            Ship := "Document Type" = "Document Type"::"Return Order";
            Receive := "Document Type" = "Document Type"::Order;
            Invoice := true;
        end;
        OnRunPreviewOnBeforePurchPostRun(PurchaseHeader);
        PurchPost.SetPreviewMode(true);
        Result := PurchPost.Run(PurchaseHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunPurchPost(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunPreviewOnBeforePurchPostRun(var PurchaseHeader: Record "Purchase Header")
    begin
    end;
}


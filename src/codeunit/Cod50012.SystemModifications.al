codeunit 50012 "System Modifications"
{

    //check for customer with distribution price group and compare balance due and credit limit DISTI
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    local procedure OnBeforeValidateEventSellToCustomerNo(var Rec: Record "Sales Header")
    var
        cust: Record Customer;
        ASL001: Label 'You cannot perfom this action on customer %1  %2 because its Outstanding balance is greater than the Credit limit';
        ASL002: Label 'VAT Registration Number Can not be empty for %1 - %2';
    begin
        cust.get(Rec."Sell-to Customer No.");
        Cust.CALCFIELDS("Outstanding Orders (LCY)");
        Cust.CALCFIELDS("Balance Due (LCY)");
        IF ((Rec."Document Type" = Rec."Document Type"::Invoice) OR (Rec."Document Type" = Rec."Document Type"::Order)) THEN BEGIN

            //Evaluating for Over Credit limit scenarios
            IF Cust."Allow Sale Beyond Credit limit" <> TRUE THEN BEGIN
                IF Cust."Customer Price Group" = 'DISTR' THEN BEGIN
                    IF Cust."Credit Limit (LCY)" <> 0 THEN BEGIN
                        IF ((Cust."Balance Due (LCY)") > Cust."Credit Limit (LCY)") THEN
                            ERROR(ASL001, Cust."No.", Cust.Name);
                    END;
                END;
            END;

            //Check for Mandatory VAT Registration Number
            if cust."TIN Mandatory" = true then begin
                if cust."VAT Registration No." = '' then begin
                    Error(ASL002, cust."No.", cust.Name);
                end;
            end;
        END;
    end;
    //check for customer with distribution price group and compare balance due and credit limit

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    local procedure OnAfterValidateEventBuyFromVendorNo(var Rec: Record "Purchase Header")
    var
        Vendor: Record Vendor;
        ASL001: Label 'VAT Registration Number Can not be empty for %1 - %2';
    begin
        Vendor.Get(Rec."Buy-from Vendor No.");
        if Vendor."TIN Mandatory" = true then begin
            if Vendor."VAT Registration No." = '' then begin
                Error(ASL001, Vendor."No.", Vendor.Name);
            end;
        end;
    end;
}
codeunit 50012 "System Modifications"
{

    //check for customer with distribution price group and compare balance due and credit limit DISTI
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    local procedure OnBeforeValidateEventSellToCustomerNo(var Rec: Record "Sales Header")
    var
        cust: Record Customer;
        ASL001: Label 'You cannot perfom this action on customer %1  %2 because its Outstanding balance is greater than the Credit limit';
    begin
        cust.get(Rec."Sell-to Customer No.");
        Cust.CALCFIELDS("Outstanding Orders (LCY)");
        Cust.CALCFIELDS("Balance Due (LCY)");
        IF ((Rec."Document Type" = Rec."Document Type"::Invoice) OR (Rec."Document Type" = Rec."Document Type"::Order)) THEN BEGIN
            IF Cust."Allow Sale Beyond Credit limit" <> TRUE THEN BEGIN
                IF Cust."Customer Price Group" = 'DISTR' THEN BEGIN
                    IF Cust."Credit Limit (LCY)" <> 0 THEN BEGIN
                        IF ((Cust."Balance Due (LCY)") > Cust."Credit Limit (LCY)") THEN
                            ERROR(ASL001, Cust."No.", Cust.Name);
                    END;
                END;
            END;
        END;
    end;
    //check for customer with distribution price group and compare balance due and credit limit
}
pageextension 50017 "User Setup Ext" extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(PhoneNo)
        {
            Field("Leave Administrator"; "Leave Administrator")
            {
                ApplicationArea = All;
            }
            Field("HR Administrator"; "HR Administrator")
            {
                ApplicationArea = All;
            }
            Field("Finance Administrator"; "Finance Administrator")
            {
                ApplicationArea = All;
            }
            field("Restrict Sales Invoicing"; "Restrict Sales Invoicing")
            {
                ApplicationArea = All;
            }
            field("Restrict Sales Shipment"; "Restrict Sales Shipment")
            {
                ApplicationArea = All;
            }
            field("Restrict Purchase Invoicing"; "Restrict Purchase Invoicing")
            {
                ApplicationArea = All;
            }
            field("Restrict Purchase Shipment"; "Restrict Purchase Shipment")
            {
                ApplicationArea = All;
            }

            //Point of sales field modifications
            Field("Location Code"; "Location Code")
            {
                //ApplicationArea = All;
            }
            Field("Sell-to Customer No."; "Sell-to Customer No.")
            {
                //ApplicationArea = All;
            }
            Field("Sales Order Nos."; "Sales Order Nos.")
            {
                //ApplicationArea = All;
            }
            Field("Receipt Nos."; "Receipt Nos.")
            {
                //ApplicationArea = All;
            }
            Field("Journal Template Name"; "Journal Template Name")
            {
                //ApplicationArea = All;
            }
            Field("Journal Batch Name"; "Journal Batch Name")
            {
                //ApplicationArea = All;
            }
            Field("Receipt Journal Nos."; "Receipt Journal Nos.")
            {
                //ApplicationArea = All;
            }
            Field("Receiving Bank"; "Receiving Bank")
            {
                //ApplicationArea = All;
            }
            Field("Custom authorizer Password"; "Custom authorizer Password")
            {
                //ApplicationArea = All;
            }
            Field("Expense Nos."; "Expense Nos.")
            {
                //ApplicationArea = All;
            }
            Field("Expense Template Name"; "Expense Template Name")
            {
                //ApplicationArea = All;
            }
            Field("Custom Sales Authorizer"; "Custom Sales Authorizer")
            {
                //ApplicationArea = All;
            }
            Field("Expense Batch Name"; "Expense Batch Name")
            {
                //ApplicationArea = All;
            }
            Field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
            {
                //ApplicationArea = All;
            }
            Field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
            {
                //ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
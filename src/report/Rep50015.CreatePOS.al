report 50015 "Create POS"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Field(User; USERID)
                    {
                        ApplicationArea = All;
                        TableRelation = "User Setup"."User ID";
                    }
                    Field(Drawer; Drawer)
                    {
                        ApplicationArea = All;
                        trigger OnLookup(VAR Text: Text): Boolean
                        var
                            DrawerRec: Record "Voucher And Receipt";
                            DrawerList: Page Drawers;
                        begin

                            DrawerRec.RESET;
                            DrawerRec.SETRANGE("Document Type", DrawerRec."Document Type"::Drawer);
                            DrawerRec.SETRANGE(User, USERID);
                            IF DrawerRec.FINDFIRST THEN BEGIN
                                //CLEAR(DrawerList);
                                DrawerList.SETTABLEVIEW(DrawerRec);
                                DrawerList.LOOKUPMODE := TRUE;
                                IF DrawerList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    DrawerList.GETRECORD(DrawerRec);
                                    Drawer := DrawerRec."No.";
                                END;
                            END;
                        end;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        UserSetup: Record "User Setup";
        CustomerRec: Record Customer;
        Drawer: Code[20];

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD(UserSetup."Location Code");
        UserSetup.TESTFIELD(UserSetup."Sell-to Customer No.");
        IF CustomerRec.GET(UserSetup."Sell-to Customer No.") THEN
            CustomerRec.CreatePOSHeader(UserSetup."Location Code", Drawer);
    end;
}
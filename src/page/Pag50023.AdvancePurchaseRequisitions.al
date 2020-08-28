page 50023 "Advance Purchase Requisitions"
{
    Caption = 'Advance Purchase Requisitions';
    PageType = List;
    UsageCategory = Lists;
    CardPageId = "Advance Purchase Requisition";
    ApplicationArea = All;
    SourceTable = "Purchase Header";
    Editable = false;
    SourceTableView = WHERE("Document Type" = CONST(Quote), "Requisition Type" = CONST(Advance));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                Field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Order Address Code"; "Order Address Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Vendor Authorization No."; "Vendor Authorization No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Buy-from Post Code"; "Buy-from Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                Field("Buy-from Country/Region Code"; "Buy-from Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Buy-from Contact"; "Buy-from Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Pay-to Name"; "Pay-to Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Pay-to Post Code"; "Pay-to Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Pay-to Country/Region Code"; "Pay-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Pay-to Contact"; "Pay-to Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }


                Field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(1);
                    end;
                }
                Field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(1);
                    end;
                }
                Field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = All;
                }
                Field("Assigned User ID"; "Assigned User ID")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                Field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Campaign No."; "Campaign No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("User ID"; "USER ID")
                {
                    ApplicationArea = All;
                }

                field("User Name"; "User Name")
                {
                    ApplicationArea = All;
                }

                Field(Status; Status)
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
                Visible = false;
                ApplicationArea = All;
            }
            part("Vendor Details FactBox"; "Vendor Details FactBox")
            {
                Visible = true;
                SubPageLink = "No." = FIELD("Buy-from Vendor No."), "Date Filter" = FIELD("Date Filter");
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;

            }

            systempart(Notes; Notes)
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Quote")
            {
                action(Statistics)
                {
                    ApplicationArea = All;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortcutKey = F7;
                    trigger OnAction();
                    begin
                        CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Purchase Statistics", Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Image = ViewComments;
                    RunObject = page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No."), "Document Line No." = CONST(0);
                    trigger OnAction()
                    begin

                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    AccessByPermission = TableData Dimension = R;
                    Image = Dimensions;
                    ShortcutKey = 'Shift+Ctrl+D';
                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }

                action(Approvals)
                {
                    ApplicationArea = All;
                    Image = Approvals;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Purchase Header", "Document Type", "No.");
                        ApprovalEntries.RUN;
                    end;
                }

            }
        }

        area(Processing)
        {
            group(Conversion)
            {
                group("Convert to")
                {
                    action(Payment)
                    {
                        ApplicationArea = All;
                        Caption = '&Transfer To Journals';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Payment;
                        trigger OnAction()
                        begin
                            ConvertToAdvanceRequisition();
                        end;
                    }
                }

                action(Print)
                {
                    ApplicationArea = All;
                    Caption = '&Print';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Print;
                    Ellipsis = true;
                    trigger OnAction()
                    var
                        PurchaseInvHeader: Record "Purchase Header";
                        PurchaseRequistion: Report "Purchase - Requisition";
                    begin
                        PurchaseInvHeader.RESET;
                        PurchaseInvHeader.SETRANGE(PurchaseInvHeader."No.", Rec."No.");
                        PurchaseInvHeader.SetRange(PurchaseInvHeader."Document Type", Rec."Document Type");
                        PurchaseRequistion.SETTABLEVIEW(PurchaseInvHeader);
                        PurchaseRequistion.RUN;
                    end;
                }
                action("Advance Accountability")
                {
                    ApplicationArea = All;
                    Caption = '&Accountability';
                    Image = Allocate;
                    //RunObject = Page "Advance Accountability";
                    //RunPageLink = Document Type=FILTER(Advance Accountability),No.=FIELD(No.),Document Line No.=CONST(0);
                    trigger OnAction()
                    begin

                    end;
                }

                action("Posted Advance Accountability")
                {
                    ApplicationArea = All;
                    Caption = '&Posted Accountability';
                    Image = Account;
                    //RunObject = Page "Advance Accountability";
                    //RunPageLink = Document Type=FILTER(Posted Accountability),No.=FIELD(No.);
                    trigger OnAction()
                    begin

                    end;
                }

                group(Releases)
                {
                    action(Release)
                    {
                        ApplicationArea = All;
                        Caption = 'Re&lease';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = ReleaseDoc;
                        ShortcutKey = 'CTRL+F9';
                        trigger OnAction()
                        var
                            ReleasePurchDoc: Codeunit "Release Purchase Document";
                        begin
                            ReleasePurchDoc.PerformManualRelease(Rec);
                        end;
                    }

                    action(Reopen)
                    {
                        ApplicationArea = All;
                        Caption = 'Re&open';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = ReOpen;
                        trigger OnAction()
                        var
                            ReleasePurchDoc: Codeunit "Release Purchase Document";
                        begin
                            ReleasePurchDoc.PerformManualReopen(Rec);
                        end;
                    }
                }

                group("Request Approval")
                {
                    action(SendApprovalRequest)
                    {
                        ApplicationArea = All;
                        Caption = 'Send A&pproval Request';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            //---------------------------ASL BUDGET V1.0.0----------------------------
                            //CheckBudget(FALSE);
                            //---------------------------ASL BUDGET V1.0.0----------------------------
                            IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                        end;
                    }
                    action(CancelApprovalRequest)
                    {
                        ApplicationArea = All;
                        Caption = 'Cancel Approval Re&quest';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Cancel;
                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                        end;
                    }
                }
            }
        }
        area(Reporting)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Requistion Summary Aging';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Report;
                Ellipsis = true;
                //RunObject = Report "Requisition Summary Aging";
                trigger OnAction()
                begin

                end;
            }
        }
    }
    var

        DimMgt: Codeunit DimensionManagement;
        DocPrint: Codeunit "Document-Print";
        OpenApprovalEntriesExist: Boolean;
        DocumentNo: Code[20];

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        SetSecurityFilterOnRespCenter;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
    end;
}
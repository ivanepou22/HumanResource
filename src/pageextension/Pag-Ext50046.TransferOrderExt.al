pageextension 50046 "Transfer Order Ext" extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Assigned User ID")
        {
            field("Transfer Reason"; "Transfer Reason")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            Visible = false;
            Enabled = false;
        }
        addfirst("P&osting")
        {
            action("Post Transfer")
            {
                ApplicationArea = Location;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    CODEUNIT.Run(CODEUNIT::"TransferOrderPost (Yes/No)", Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}
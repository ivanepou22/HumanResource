pageextension 50047 "Transfer Orders Ext" extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
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
        modify(Post)
        {
            Visible = false;
            Enabled = false;
        }
    }

    var
        myInt: Integer;
}
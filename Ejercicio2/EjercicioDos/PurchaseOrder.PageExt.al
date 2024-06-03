pageextension 70590 PurchaseOrderCaja extends "Purchase Order Subform"
{
    layout
    {
        addbefore(Description)
        {
            field(EsCajaLinea; Rec.EsCajaLinea)
            {
                ApplicationArea = all;
                ToolTip = '';
                Editable = false;

            }
            field(NoProductoCajaLinea; Rec.NoProductoCajaLinea)
            {
                ApplicationArea = all;
                ToolTip = '';
                Editable = false;


            }
            field(LinePrincipal; Rec.LinePrincipal)
            {
                ApplicationArea = all;
                ToolTip = '';
                Editable = false;


            }

        }
    }

}
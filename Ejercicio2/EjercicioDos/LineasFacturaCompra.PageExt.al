pageextension 70845 LineasFacturaCompra extends "Posted Purchase Invoice Lines"
{

    layout
    {
        addlast(content)
        {
            field(LineaPrincipal; Rec.LineaPrincipal)
            {
                ApplicationArea = All;
                ToolTip = '';
                Editable = false;
            }


        }

    }


}
pageextension 70864 LineasAlbaranCompra extends "Posted Purchase Receipt Lines"
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
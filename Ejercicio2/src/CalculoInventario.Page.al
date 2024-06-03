page 70600 "Calcular Inventario"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Calculo Inventario";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Producto; Rec.Producto)
                {

                }
                field(Nombre; Rec.Nombre)
                {

                }
                field(Almacen; Rec.Almacen)
                {

                }
                field(Ubicacion; Rec.Ubicacion)
                {

                }
                field(Cantidad; Rec.Cantidad)
                {


                }
                field(Lote; Rec.Lote)
                {

                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Generar informe")
            {
                Promoted = true;
                ApplicationArea = All;
                Image = Report;
                Tooltip = 'Calcular inventario';
                PromotedCategory = Process;
                RunObject = report 70580;

            }
        }
    }


}
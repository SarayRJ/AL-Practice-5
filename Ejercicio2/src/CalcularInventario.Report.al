report 70580 "Informe de inventario"
{

    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //Sólo de procesamiento, no tiene un diseño.
    ProcessingOnly = true;


    //Comienza la definición del conjunto de datos para el reporte
    dataset
    //Define un elemento de datos llamado "Item" que representa los artículos del Inventario
    {
        dataitem(Item; Item)
        {
            //Especifica que el campo No. se utilizará como filtro de solicitud para este elemento de datos
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }
            //Este disparador se ejecuta después de obtener un registro, en este caso, después de obtener los articulos.
            trigger OnAfterGetRecord()
            var
                CalculoInventario: Record "Calculo Inventario";
                Almacenes: Record Location;
                RecItem: Record Item;
                MovProducto: Record "Item Ledger Entry";
                RecUbicaciones: Record "Bin Content";

            begin
                RecItem.Init();
                MovProducto.Init();
                RecItem.Get("No.");
                MovProducto.SetFilter("Item No.", "No.");
                MovProducto.SetFilter(Open, 'true');
                MovProducto.SetFilter("Remaining Quantity", '>0');
                if MovProducto.FindSet() then begin
                    repeat
                        RecUbicaciones.SetFilter("Item No.", "No.");
                        RecUbicaciones.SetFilter("Lot No. Filter", MovProducto."Lot No.");

                        if RecUbicaciones.FindSet() then begin
                            CalculoInventario.SetFilter(Producto, "No.");
                            CalculoInventario.SetFilter(Lote, MovProducto."Lot No.");
                            CalculoInventario.SetFilter(Ubicacion, RecUbicaciones."Location Code");

                            RecUbicaciones.CalcFields("Quantity (Base)");

                            if CalculoInventario.FindFirst() then begin
                                if RecUbicaciones."Quantity (Base)" > 0 then begin
                                    CalculoInventario.Cantidad += RecUbicaciones."Quantity (Base)";
                                    CalculoInventario.Modify(true);
                                end;



                            end else begin
                                CalculoInventario.Ubicacion := RecUbicaciones."Location Code";
                                CalculoInventario.Cantidad := RecUbicaciones."Quantity (Base)";
                                CalculoInventario.Lote := RecUbicaciones."Lot No. Filter";
                                CalculoInventario."No." := NoIncremento;
                                CalculoInventario.Insert(true);
                                NoIncremento += 1;
                            end;





                        end;


                    until MovProducto.Next() = 0;
                end
                /*DEL ITEM A TRAVES DE LOS MOVIMIENTOS BUSCAR LA UBICACION, 
                  FILTRANDO PRIMERO POR EL N ITEM, SI ENCUENTRA EL ITEM FILTRA POR MOVIMIENTO, QUE TIENE QUE ESTAR ABIERTO Y QUE TENGA CANTIDAD PENDIENTE, 
                  SI ENCEUNTRA SE FILTRA POR LA UBICACION FILTRANDO NUMERO de item, y de lote
                  SI ENCUENTRA, FILTRA POR MI TABLA DE CLACULO INVENTARIO CON NUMERO LOTE Y UBICACION.
                  SI ENCEUNTRA SE HACE UN CALCFIELD D LA CANTIDAD BASE DE LA UBICACION SI ES MAYOR A 0 SE VA SUMANDO LA CANTIDAD DE LA UBICACION A LA CANTIDAD DE MI CALCINVENTARIO,
                  SINO SE QUEDA LA CANTIDAD PENDIENTE DEL MOVIMIENTO ITEMLEDGERNETRY.REMAININGQUANTITY""", 
                  FUERA DEL IF PONEMOS EL CALCINV.MODIFY" , SINO ENCUENTRA NADA CCREA LOS DATOS (METE LAS COSAS CADA UNA EN SUS ITIO)((TODO LO QUE TENGA UBICACION))*/
                /*
                                //Asignamos el número y la descripción del artículo al registro "Calculo Inventario"
                                CalculoInventario.Producto := "No.";
                                CalculoInventario.Nombre := Description;

                                //Obtenemos el registro del artículo y calculamos los campos, especialmente los relacionados con el inventario.
                                RecItem.Get("No.");
                                RecItem.CalcFields(RecItem.Inventory);


                                //Si el inventario del artículo es mayor que 0
                                if RecItem.Inventory > 0 then begin
                                    //Busca ubicaciones de almacenamiento
                                    if Almacenes.FindSet() then begin
                                        //Iniciamos bucle
                                        repeat
                                            //que me muestre el item No. que sea igual al No. de mi tabla
                                            MovProducto.SetFilter("Item No.", "No.");
                                            //Establecemos un filtro en el registro de movimientos de productos. Este filtro se aplica al campo "Location Code" del registro MovProducto y se configura para que sea igual al código
                                            //de la ubicación actualmente seleccionadaen el conjunto de registros de ubicaciones('almacenes'), específicamente al campo "Code" de ese registro de ubicación.
                                            //FILTRA LOS MOVPROD PARA QUE SOLO SE INCLUYAN AQUELLOS QUE CORRESPONDEN A LA UBICACION SELECCIONADA EN EL PROCESO DE ITERACION SOBRE LAS UBICACIONES DE ALMACENAMIENTO.
                                            MovProducto.SetFilter("Location Code", Almacenes.Code);
                                            //Si encuentra los registros de la tabla que cumple con los filtros establecidos en los movimientos
                                            if MovProducto.Findset() then begin
                                                repeat
                                                    //Establecemos los filtros para buscar registros de CalculoInventario para el articulo, la ubicacion y el lote
                                                    CalculoInventario.SetFilter(Producto, "No.");
                                                    CalculoInventario.SetFilter(Almacen, MovProducto."Location Code");
                                                    CalculoInventario.SetFilter(Lote, MovProducto."Lot No.");
                                                    //Si encontramos un registro de CalculoInventario
                                                    if CalculoInventario.FindFirst() then begin
                                                        //Modificamos la cantidad
                                                        //Aumentamos la cantidad del inventario en CalculoInventario al agregar la cantidad del producto que se ha encontrado en el registro de movimiento de producto.
                                                        //+= Agrega el calor del lado derecho al valor existente del lado izquierdo y luego asigna el resultado a la variable del lado izquierdo. 
                                                        CalculoInventario.Cantidad += MovProducto.Quantity;
                                                        CalculoInventario.Modify(true);
                                                    end else begin
                                                        //Si no se encuentra creamos un nuevo registro
                                                        CalculoInventario.Almacen := MovProducto."Location Code";
                                                        CalculoInventario.Cantidad := MovProducto.Quantity;
                                                        CalculoInventario.Lote := MovProducto."Lot No.";
                                                        CalculoInventario."No." := NoIncremento;
                                                        CalculoInventario.Insert(true);
                                                        NoIncremento += 1;
                                                    end;
                                                until MovProducto.Next() = 0;


                                            end;



                                        until Almacenes.Next() = 0;


                                    end;

                                end;




                            end;




                            trigger OnPreDataItem()
                            var
                                CalculoInventario: Record "Calculo Inventario";
                            begin
                                CalculoInventario.DeleteAll();

                            end;

                        }

                */
            end;


        }
    }
    var
        NoIncremento: Integer;



}
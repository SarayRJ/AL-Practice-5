codeunit 70564 AddBox
{
    //Evento que se suscribe cuando se valida el campo No. en la página Purchase Order Subform.
    [EventSubscriber(ObjectType::Page, Page::"Purchase Order Subform", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure AddBoxAfterAddItem(var Rec: Record "Purchase Line")
    var
        RecItem: Record Item;
        AddLine: Record "Purchase Line";


    begin

        //Inicializamos los registros
        RecItem.Init();
        //Verificamos si el registro existe
        if RecItem.Get(Rec."No.") then begin
            //Comprobamos si el tipo de la línea de compra es un artículo
            if Rec.Type = Rec.Type::Item then begin
                //Verifica si el producto tiene un número de caja asociado
                if RecItem.NoProductoCaja <> '' then begin
                    //Inicializamos la línea de compra
                    AddLine.INIT();
                    //Obtenemos el artículo asociado al número de caja
                    if RecItem.Get(RecItem.NoProductoCaja) then begin
                        //Asignamos los valores a la línea de compra
                        AddLine."Document No." := Rec."Document No.";
                        AddLine."Line No." := Rec."Line No." + 1;
                        AddLine.Type := Rec.Type::Item;
                        AddLine."Document Type" := Rec."Document Type";
                        AddLine."No." := RecItem."No.";
                        AddLine.Validate("No.");
                        AddLine.LinePrincipal := Rec."Line No.";
                        AddLine.EsCajaLinea := true;
                        //La insertamos en la tabla
                        AddLine.INSERT(true);
                    end;
                end;
            end;
        end;
    end;


    //Evento que se suscribe cuando se valida el campo Quantity en la página Purchase Order Subform.
    [EventSubscriber(ObjectType::Page, Page::"Purchase Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure CalcQuantityBoxes(var Rec: Record "Purchase Line")
    var
        RecItem: Record Item;
        LineaCaja: Record "Purchase Line";

    begin
        RecItem.INIT();
        LineaCaja.INIT();
        //Obtenemos el producto asociado a la línea de compra
        RecItem.Get(Rec."No.");
        //Verificamos que el campo de cantidad de la línea de compra sea diferente de 0
        if Rec.Quantity <> 0 then begin
            //Filtramos las líneas de compra asociadas al documento y línea principal
            LineaCaja.SetFilter("Document No.", Rec."Document No.");
            LineaCaja.SetFilter("Document Type", '%1', Rec."Document Type");
            LineaCaja.SetFilter("LinePrincipal", '%1', Rec."Line No.");
            //Si encontramos la primera línea de caja asociada
            if LineaCaja.Findfirst() then begin
                //Calculamos la cantidad de cajas basándonos en la cantidad del artículo y la cantidad por cajas.
                LineaCaja.Quantity := Rec.Quantity * RecItem.CantidadCaja;
                //Modificamos la línea de compra en la que se encuentra la caja
                LineaCaja.Modify(true);
            end;

        end;


    end;


    //Evento que se suscribe antes de eliminar una línea de compra
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnDeleteOnBeforeTestStatusOpen', '', false, false)]
    local procedure DeleteLines(var PurchaseLine: Record "Purchase Line")
    var
        //obtener la linea asociada
        LineaPrincipal: Record "Purchase Line";


    begin
        LineaPrincipal.INIT();
        //Si la línea de compra no es una caja
        if PurchaseLine.EsCajaLinea = false then begin
            //Filtramos las líneas de compra asociadas al documento y línea principal
            LineaPrincipal.SetFilter("Document No.", PurchaseLine."Document No.");
            LineaPrincipal.SetFilter("Document Type", '%1', PurchaseLine."Document Type");
            LineaPrincipal.SetFilter("LinePrincipal", '%1', PurchaseLine."Line No.");
            //Si la encontramos, se elimina
            if LineaPrincipal.FindFirst() then
                LineaPrincipal.DELETE();

        end;

    end;



    //Evento que se suscribe después de eliminar todas las líneas de compra
    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnDeleteOnAfterPurchLineDeleteAll', '', false, false)]
    local procedure ErrorBox(var PurchaseLine: Record "Purchase Line")
    begin
        //Si la línea de compra que quiero eliminar es una caja, se muestra un mensaje de error
        if PurchaseLine.EsCajaLinea then
            Error('No se puede eliminar una caja, elimine primero el producto relacionado');
    end;

}

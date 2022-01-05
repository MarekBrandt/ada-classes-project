package body bufor is

   task body Bakery is
      Storage_Capacity: constant Integer := 30;
      type Storage_type is array (Product_Type) of Integer;
      Storage: Storage_type
	:= (0, 0, 0, 0, 0);
      Assembly_Content: array(Assembly_Type, Product_Type) of Integer
	:= ((0, 0, 0, 2, 1),
	    (0, 0, 0, 1, 0),
	    (0, 0, 0, 2, 1));
      Max_Assembly_Content: array(Product_Type) of Integer;
      Assembly_Number: array(Assembly_Type) of Integer
	:= (1, 1, 1);
      In_Storage: Integer := 0;
      Counter: Integer := 0;

      procedure Setup_Variables is
      begin
         for W in Product_Type loop
            Max_Assembly_Content(W) := 0;
            for Z in Assembly_Type loop
               if Assembly_Content(Z, W) > Max_Assembly_Content(W) then
                  Max_Assembly_Content(W) := Assembly_Content(Z, W);
               end if;
            end loop;
         end loop;
      end Setup_Variables;

      function Can_Accept(Product: Product_Type) return Boolean is
         Free: Integer;		--  free room in the storage
         -- how many products are for production of arbitrary assembly
         Lacking: array(Product_Type) of Integer;
         -- how much room is needed in storage to produce arbitrary assembly
         Lacking_room: Integer;
         MP: Boolean;			--  can accept
      begin
         if In_Storage >= Storage_Capacity then
            return False;
         end if;
         -- There is free room in the storage
         Free := Storage_Capacity - In_Storage;
         MP := True;
         for W in Product_Type loop
            if Storage(W) < Max_Assembly_Content(W) then
               MP := False;
            end if;
         end loop;
         if MP then
            return True;		--  storage has products for arbitrary
            --  assembly
         end if;
         if Integer'Max(0, Max_Assembly_Content(Product) - Storage(Product)) > 0 then
            -- exactly this product lacks
            return True;
         end if;
         Lacking_room := 1;			--  insert current product
         for W in Product_Type loop
            Lacking(W) := Integer'Max(0, Max_Assembly_Content(W) - Storage(W));
            Lacking_room := Lacking_room + Lacking(W);
         end loop;
         if Free >= Lacking_room then
            -- there is enough room in storage for arbitrary assembly
            return True;
         else
            -- no room for this product
            return False;
         end if;
      end Can_Accept;

      function Can_Deliver(Assembly: Assembly_Type) return Boolean is
      begin
         for W in Product_Type loop
            if Storage(W) < Assembly_Content(Assembly, W) then
               return False;
            end if;
         end loop;
         return True;
      end Can_Deliver;

      procedure Storage_Contents is
      begin
         for W in Product_Type loop
            Put_Line("Storage contents: " & Integer'Image(Storage(W)) & " "
                     & Product_Name(W));
         end loop;
      end Storage_Contents;
   subtype Number_Of_Products_In_Production is Integer range 1 .. 6;
   package Random_Number_Of_Products is new Ada.Numerics.Discrete_Random(Number_Of_Products_In_Production);
   G1: Random_Number_Of_Products.Generator;
   Nb_Of_Products: Number_Of_Products_In_Production;
   begin
      Put_Line("Bakery started");
      Setup_Variables;
      loop
         select
            accept Take(Product: in Product_Type; Number: in Integer) do
               Nb_Of_Products := Random_Number_Of_Products.Random(G1);
               if Can_Accept(Product) then
                  Put_Line("Accepted product " & Product_Name(Product) & " number " &
                             Integer'Image(Number) & " ilosc: " & Integer'Image(Nb_Of_Products));
                  Storage(Product) := Storage(Product) + Nb_Of_Products;
                  In_Storage := In_Storage + Nb_Of_Products;
               else
                  if(Counter < 5) then
                     Put_Line("Rejected product " & Product_Name(Product) & " number " &
                                Integer'Image(Number) & " ilosc: " & Integer'Image(Nb_Of_Products));
                     Counter := Counter + 1;
                  else
                     Put_Line("The bakery has been set on fire by hostile bakery Zimny Jan."&
                                " All ingredients are gone"); 
                     Storage := (0,0,0,0,0);
                     In_Storage := 0;
                  end if;
               end if; 
            end Take;
         or
            accept Deliver(Assembly: in Assembly_Type; Number: out Integer) do
               if Can_Deliver(Assembly) then
                  Put_Line("Delivered assembly " & Assembly_Name(Assembly) & " number " &
                             Integer'Image(Assembly_Number(Assembly)));
                  for W in Product_Type loop
                     Storage(W) := Storage(W) - Assembly_Content(Assembly, W);
                     In_Storage := In_Storage - Assembly_Content(Assembly, W);
                  end loop;
                  Number := Assembly_Number(Assembly);
                  Assembly_Number(Assembly) := Assembly_Number(Assembly) + 1;
               else
                  Put_Line("Lacking products for assembly " & Assembly_Name(Assembly));
                  Number := 0;
               end if;
            end Deliver;
         end select;
         Storage_Contents;
      end loop;
   end Bakery;

end bufor;

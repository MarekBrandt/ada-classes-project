package body producent is

   task body Producer is
      subtype Production_Time_Range is Integer range 3 .. 6;
      package Random_Production is new
	Ada.Numerics.Discrete_Random(Production_Time_Range);
      G: Random_Production.Generator;	--  generator liczb losowych
      Product_Type_Number: Integer;
      Product_Number: Integer;
      Production: Integer;
   begin
      accept Start(Product: in Product_Type; Production_Time: in Integer) do
         Random_Production.Reset(G);	--  start random number generator
         Product_Number := 1;
         Product_Type_Number := Product;
         Production := Production_Time;
      end Start;
      Put_Line("Started producer of " & Product_Name(Product_Type_Number));
      loop
         delay Duration(Random_Production.Random(G)); --  symuluj produkcję
         Put_Line("Produced product " & Product_Name(Product_Type_Number)
		    & " number "  & Integer'Image(Product_Number));
         -- Accept for storage
         B.Take(Product_Type_Number, Product_Number);
         Product_Number := Product_Number + 1;
      end loop;
   end Producer;

end producent;

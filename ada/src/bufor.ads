with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 
with Ada.Numerics.Discrete_Random;

package bufor is

   Number_Of_Products: constant Integer := 5;
   Number_Of_Assemblies: constant Integer := 3;
   Number_Of_Consumers: constant Integer := 2;
   subtype Product_Type is Integer range 1 .. Number_Of_Products;
   subtype Assembly_Type is Integer range 1 .. Number_Of_Assemblies;
   
   Product_Name: constant array (Product_Type) of String(1 .. 19)
     := ("Maka pszenna       ", "Maka wieloziarnista", "Slonecznik         ", "Drozdze            ", "Sol                ");
   Assembly_Name: constant array (Assembly_Type) of String(1 .. 20)
     := ("Chleb koscierski    ", "Chleb wieloziarnisty", "Kajzerka            ");
   package Random_Assembly is new
     Ada.Numerics.Discrete_Random(Assembly_Type);
   type My_Str is new String(1 ..256);
   
   -- In the Bakery, products are assemblied into an assembly
   task type Bakery is
      -- Accept a product to the storage provided there is a room for it
      entry Take(Product: in Product_Type; Number: in Integer);
      -- Deliver an assembly provided there are enough products for it
      entry Deliver(Assembly: in Assembly_Type; Number: out Integer);
   end Bakery;

   B: Bakery;

end bufor;

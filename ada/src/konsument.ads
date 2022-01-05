with bufor; use bufor;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 
with Ada.Numerics.Discrete_Random;
package konsument is
   subtype Consumer_Type is Integer range 1 .. Number_Of_Consumers;
   -- Consumer gets an arbitrary assembly of several products from the bakery
   task type Consumer is
      -- Give the Consumer an identity
      entry Start(Consumer_Number: in Consumer_Type;
		    Consumption_Time: in Integer);
   end Consumer;

end konsument;

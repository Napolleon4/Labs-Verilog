

module Lab_3(
input clk ,
input SwOut,
output DB1,
output DB2 
);


Debouncer_1(.Input(SwOut),.clk(clk),.Output(DB1));
Debouncer_2(.Input(SwOut),.clk(clk),.Output(DB2));



endmodule 





module Debouncer_1(
input Input,
input clk,
output reg Output);

reg [3:0] shft;

always @(posedge clk)
		begin
			shft[0] <= Input;
			shft[3:1] <= shft[2:0];
		
			if ((shft[0] == shft[1]) & (shft[0] == shft[2]) & (shft[0] == shft[3]))
				Output <= shft[0];
			else
				Output <= Output;
		end

endmodule 





module Debouncer_2(
input Input,
input clk,
output reg Output
);

reg [1:0] Count;

always @(posedge clk)
	begin
		if (Count == 3)
			begin
			if (Input == Output)
				begin
						Output <= Output;
					Count <= Count;
				end
			else
				begin
				Output <= ~Output;
					Count <=  0;
				
				end
			
			end
		else
			begin
				if (Count != 3)
					Count <= Count + 1;
				else
					Count <= Count;
			end
			
	end



endmodule

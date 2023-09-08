
module Lab_7(Clock, Sel1, RnW1, Sel2, RnW2, Sel3, RnW3, Sel4, RnW4, DioExt,);

	input Clock;  
	input Sel1, Sel2, Sel3, Sel4;  
	input RnW1, RnW2, RnW3, RnW4;  
	inout [7:0] DioExt;
	tri  [7:0] Dbus;  

	
	Reg8bit R1(Clock, Sel1, RnW1, Dbus);  
	Reg8bit R2(Clock, Sel2, RnW2, Dbus); 
	Reg8bit R3(Clock, Sel3, RnW3, Dbus);
	
	Accumulator Acc(Clock, Sel4, RnW4, Dbus);
	

	
	assign Dbus[7:0]   = ((RnW1|RnW2|RnW3) == 1'b0) ?  DioExt[7:0] : 8'bZ; 
	assign DioExt[7:0] = ((RnW1|RnW2|RnW3) == 1'b1) ?  Dbus[7:0]   : 8'bZ; 

endmodule 



module Accumulator(Clk, Sel, RnW, Dio); 
	input Clk;
	input Sel;
	input RnW;
	inout [7:0]Dio;
	reg   [7:0]FFstore;
	
	
	wire Rst;
	assign Rst = Sel & RnW; 
	
	always @(posedge Clk) 
		if (RnW == 1'b1 && Sel == 1'b1) 
		    FFstore[7:0] <= FFstore[7:0] + Dio[7:0]; 
		else if (Rst)
		    FFstore[7:0] <= 8'b0;
		else
		    FFstore[7:0] <= FFstore[7:0];
		
	assign Dio[7:0] = (Sel == 1'b1 && RnW == 1'b0) ? FFstore[7:0] : 8'bZ; 
endmodule



module Reg8bit(Clk, Sel, RnW, Dio); 
	input Clk;
	input Sel;
	input RnW;
	inout [7:0]Dio;
	reg   [7:0]FFstore;

	always @(posedge Clk) 
	  if (RnW == 1'b0 && Sel == 1'b1) begin 

	    FFstore[7:0] <= Dio[7:0]; 
	end 
	  else  begin 
	    FFstore[7:0] <= FFstore[7:0]; 
	end 
	
	assign Dio[7:0] = (Sel == 1'b1 && RnW == 1'b1) ? FFstore[7:0] : 8'bZ; 
endmodule





module Lab_5 (Clk, Send, PDin, PDout, PDready, SDout, SClk );

	input Clk, Send;
	input [7:0]PDin;
	output [7:0]PDout;
	output PDready;
	output SDout;
	output SClk;
	wire Clk2;
	
	wire SData ; 
	
	assign  SDout = SData ; 
	assign SClk = Clk2;
	
Transmitter TM (.clk(Clk),.Send(Send),.PDin(PDin[7:0]),.SCout(Clk2),.SDout(SData));
Receiver    RC (.SCin(Clk2), .SDin(SData),   .PDout(PDout[7:0]), .PDready(PDready) );
endmodule


module Transmitter(clk, Send, PDin, SCout, SDout);

  input clk;
  input Send;
  input [7:0] PDin;
  output SCout, SDout;
  reg [8:0] SR;
  reg stored_Send;
  wire Enable;
  reg parity;

  always @(posedge clk) begin
    stored_Send <= Send;
  end  
  
  
  assign Enable = Send && ~stored_Send;

  always @(posedge clk or posedge Enable) begin
    if (Enable) begin
      SR[7:0] <= PDin[7:0];
      SR[8] <= 1'b1;
    end else begin
      SR[8:1] <= SR[7:0];
      SR[0] <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (SR[7:0] & 1) begin
      parity <= 1;
       SR[0] <= parity;
    end else begin
      parity <= 0;
          SR[0] <= parity;
    end
  end

  assign SDout = SR[8] ;
  assign SCout = clk;


endmodule


module Receiver(
  input wire SCin,
  input wire SDin,
  output wire [7:0] PDout,
  output wire PDready,
  output wire ParErr
);

  reg [7:0] PDout_reg;
  reg PDready_reg;
  reg [2:0] state;
  reg parity;

  always @(posedge SCin) begin
    case (state)
      0: begin  
        if (SDin == 1'b0) begin
          state <= 1; 
         PDout_reg <= 8'b0;
        end
      end
    
      1: begin  
        if (SDin == 1'b1) begin
           PDout_reg <= {PDout_reg[6:0], SDin};  
          state <= 2;  
        end else begin
          state <= 0;  
        end
      end
      2: begin        state <= 0;
        PDready_reg <= 1'b1;  
        parity <= (PDout_reg & 1) ^ SDin;
      end
    endcase
  end
  
  assign PDout = PDout_reg;
  assign PDready = PDready_reg;
  assign ParErr = parity;

endmodule


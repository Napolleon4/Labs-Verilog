module Lab_2(
    input nReset,
    input Clock,
    input Enable,
    output [3:0] Co1,
    output [3:0] Co10,
    output [3:0] Co100
);

wire [1:0] next;

Counter Counter1(
    .nRst(nReset),
    .clk(Clock),
    .CntEn(Enable),
    .Cout(Co1),
    .NextEn(next[0])
);

Counter Counter2(
    .nRst(nReset),
    .clk(Clock),
    .CntEn(next[0]),
    .Cout(Co10),
    .NextEn(next[1])
);

Counter Counter3(
    .nRst(nReset),
    .clk(Clock),
    .CntEn(next[1]),
    .Cout(Co100),
    .NextEn()
);

endmodule




module Counter(input nRst,
input clk,  
input CntEn,
output reg [3:0] Cout,
output   NextEn

); 




always @(posedge clk , negedge nRst)

begin 
  
  if(!nRst) 
    begin 
   
    Cout<= 0 ;  
    end 
 
   
     else 
   begin 
     
       if (CntEn)
        begin 
       
        if(Cout == 4'd9)
        
        begin 
       
          Cout<=0;
        
        end 
        
        
         else
           begin
          Cout<= Cout+1;
          
           end 
    
       end     
    
     
   end         


end 

   assign NextEn = (Cout==4'd9) ? 1 : 0 ;    

endmodule 




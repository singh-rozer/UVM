module clk_gen(
input clk,rst, 
input [16:0] baud, 
output tx_clk);
 reg tclk; // to store state of a clock
 int txmax; //txmax = clk/baud
 int txcount;

 always@(posedge clk) begin
  if(rst) txmax <= 0;
  else begin
   case(baud) 4800: txmax <= 'd10416;
              9600: txmax <= 'd5208;
              14400: txmax <= 'd3472;
              19200: txmax <= 'd2604;
              38400: txmax <= 'd1302;
              57600: txmax <= 'd868;
              default: txmax <= 'd5208;
   endcase
  end
 end
 //tx_clk generation
 always@(posedge clk) begin
 if(rst) begin
  tclk <= 0;
  txcount <= 0;
 end
 else if(txcount == txmax/2) begin 
  tclk <= ~ tclk; 
  txcount <= 0; 
 end
 else if(txcount < txmax/2) txcount <= txcount+1;
 end

 assign tx_clk = tclk;
 
endmodule

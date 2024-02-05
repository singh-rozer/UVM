module apb_ram(
input presetn,
input pclk,
input psel,
input penable,
input pwrite,
input [31:0] paddr, pwdata,
output reg [31:0] prdata,
output reg pready,
output reg pslverr
);

reg [31:0] mem [32];

typedef enum {idle = 0, setup = 1, access = 2, transfer = 3} state_type;

state_type state;

always@(posedge pclk)
begin
if(!presetn) begin
state <= idle;
pready <= 0;
pslverr <= 0;
prdata <= 0;

for(int i = 0; i<32;i++) begin
mem[i] <= 0;
end
end
else
case(state)
idle: state <= setup;
setup: if(psel) state <= access;
access: begin
	if(penable && pwrite && paddr < 32)begin
	mem[paddr] <= pwdata;
	pslverr <= 0;
	pready <= 1;
	state <= transfer;
	end
	else if(penable && pwrite && paddr >= 32)begin
	pslverr <= 1;
	pready <= 1;
	state <= transfer;
	end
	else if(penable && !pwrite && paddr < 32)begin
	prdata <= mem[paddr];
	pslverr <= 0;
	pready <= 1;
	state <= transfer;
	end
	else if(penable && !pwrite && paddr >= 32)begin
	pslverr <= 1;
	pready <= 1;
	prdata <= 'bx;
	state <= transfer;
	end
	end
transfer:begin
	state <= setup;
	pready <= 0;
	pslverr <= 0;
	end
default: state <= idle;
endcase
end

initial begin
$monitor("%0t :: VALUE AT %0d is %0d",$time,paddr,mem[paddr]);
end

endmodule

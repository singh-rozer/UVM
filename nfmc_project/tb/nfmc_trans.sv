class nfmc_trans extends uvm_sequence_item;

bit [7:0] DIO;
bit CLE;
bit ALE;
bit WE_n;
bit RE_n;
bit CE_n;
bit R_nB;
bit CLK;
bit RES;
bit BF_sel;
bit [10:0] BF_ad;
rand bit [7:0] BF_din;
bit [7:0] BF_dou;
bit BF_we;
rand bit [15:0] RWA;
bit PErr;
bit EErr;
bit RErr;
rand bit [2:0] nfc_cmd;
bit nfc_strt;
bit nfc_done;
//bit [15:0] address;
bit [7:0] temp_data_recv[$];
bit [7:0] temp_data_send[$];
rand mode op;
rand bit [10:0] data_itr;
//rand time delay_par_rst; 
rand int delay_par_rst; 

constraint addr_val {RWA == 'h1234;}
constraint cmd_val {nfc_cmd inside {'b011,'b101,'b100,'b001,'b010};}
constraint delay_val {delay_par_rst == 400;}

`uvm_object_utils_begin(nfmc_trans)
`uvm_field_int( DIO,UVM_ALL_ON);
`uvm_field_int( CLE,UVM_ALL_ON);
`uvm_field_int( ALE,UVM_ALL_ON);
`uvm_field_int( WE_n,UVM_ALL_ON);
`uvm_field_int( RE_n,UVM_ALL_ON);
`uvm_field_int( CE_n,UVM_ALL_ON);
`uvm_field_int( R_nB,UVM_ALL_ON);
`uvm_field_int( CLK,UVM_ALL_ON);
`uvm_field_int( RES,UVM_ALL_ON);
`uvm_field_int( BF_sel,UVM_ALL_ON);
`uvm_field_int( BF_ad,UVM_ALL_ON);
`uvm_field_int( BF_din,UVM_ALL_ON);
`uvm_field_int( BF_dou,UVM_ALL_ON);
`uvm_field_int( BF_we,UVM_ALL_ON);
`uvm_field_int( RWA,UVM_ALL_ON);
`uvm_field_int( PErr,UVM_ALL_ON);
`uvm_field_int( EErr,UVM_ALL_ON);
`uvm_field_int( RErr,UVM_ALL_ON);
`uvm_field_int( nfc_cmd,UVM_ALL_ON);
`uvm_field_int( nfc_strt,UVM_ALL_ON);
`uvm_field_int( nfc_done,UVM_ALL_ON);
//`uvm_field_int( address,UVM_ALL_ON);
`uvm_field_enum( mode,op,UVM_ALL_ON);
`uvm_field_int( data_itr,UVM_ALL_ON);
`uvm_object_utils_end


function new(string name="nfmc_trans");
super.new(name);
endfunction

endclass


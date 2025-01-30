`include "uvm_macros.svh"
 import uvm_pkg::*;
 
typedef enum  bit[3:0]{ rand_baud_1_stop =0, rand_length_1_stop=1, length5wp=2, length6wp=3, length7wp=4, length8wp=5, length5wop=6, length6wop=7, length7wop=8, length8wop=9, rand_baud_2_stop=10, rand_length_2_stop=11} oper_mode;

class uart_config extends uvm_object;
`uvm_object_utils(uart_config)

function new(input string path = "uart_config");
 super.new(path);
endfunction

uvm_active_passive_enum is_active = UVM_ACTIVE;

endclass
//
class transaction extends uvm_sequence_item;
`uvm_object_utils(transaction)
 logic tx_start, rx_start, rst;
 rand logic [7:0] tx_data;
 rand logic [16:0] baud;
 rand logic [3:0] length;
 rand logic parity_type, parity_en;
 logic stop2;
 logic tx_done,rx_done, tx_err,rx_err;
 logic [7:0] rx_out;
 oper_mode oper;
 
function new(input string path = "transaction");
 super.new(path);
endfunction

constraint baud_c { baud inside{4800,9600,14400,19200,38400,57600};}
constraint length_c { length inside{5,6,7,8};}
endclass

//rand_baud_1
class rand_baud_1 extends uvm_sequence#(transaction);
 `uvm_object_utils(rand_baud_1)
 
 transaction tr;
 
 function new(input string path = "rand_baud_1");
  super.new(path);
 endfunction
 
 virtual task body();

  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd8;
  tr.parity_en = 1'b1;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = rand_baud_1_stop;
  finish_item(tr);

 endtask
endclass

//rand_length_1_stop
class rand_length_1 extends uvm_sequence#(transaction);
 `uvm_object_utils(rand_length_1)
 
 transaction tr;
 
 function new(input string path = "rand_length_1");
  super.new(path);
 endfunction
 
 virtual task body();

  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.parity_en = 1'b1;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = rand_length_1_stop;
  finish_item(tr);

 endtask
endclass

//length5wp
class len5wp extends uvm_sequence#(transaction);
 `uvm_object_utils(len5wp)
 
 transaction tr;
 
 function new(input string path = "len5wp");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd5;
  tr.tx_data   = {3'b000, tr.tx_data[7:3]};
  tr.parity_en = 1'b1;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = length5wp;
  finish_item(tr);
 endtask
endclass

//len6wp
class len6wp extends uvm_sequence#(transaction);
 `uvm_object_utils(len6wp)
 
 transaction tr;
 
 function new(input string path = "len6wp");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd6;
  tr.tx_data   = {2'b00, tr.tx_data[7:2]};
  tr.parity_en = 1'b1;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = length6wp;
  finish_item(tr);
 endtask
endclass

//len7wp
class len7wp extends uvm_sequence#(transaction);
 `uvm_object_utils(len7wp)
 
 transaction tr;
 
 function new(input string path = "len6wp");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd7;
  tr.tx_data   = {1'b0, tr.tx_data[7:1]};
  tr.parity_en = 1'b1;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = length7wp;
  finish_item(tr);
 endtask
endclass

//len8wp
class len8wp extends uvm_sequence#(transaction);
 `uvm_object_utils(len8wp)
 
 transaction tr;
 
 function new(input string path = "len8wp");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd8;
  tr.parity_en = 1'b1;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = length8wp;
  finish_item(tr);
 endtask
endclass  

//len5wop
class len5wop extends uvm_sequence#(transaction);
 `uvm_object_utils(len5wop)
 
 transaction tr;
 
 function new(input string path = "len5wop");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd5;
  tr.tx_data   = {3'b000, tr.tx_data[7:3]};
  tr.parity_en = 1'b0;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = length5wop;
  finish_item(tr);
 endtask
endclass

//len6wop
//len6wp
class len6wop extends uvm_sequence#(transaction);
 `uvm_object_utils(len6wop)
 
 transaction tr;
 
 function new(input string path = "len6wop");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd6;
  tr.tx_data   = {2'b00, tr.tx_data[7:2]};
  tr.parity_en = 1'b0;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = length6wop;
  finish_item(tr);
 endtask
endclass

//len7wop
class len7wop extends uvm_sequence#(transaction);
 `uvm_object_utils(len7wop)
 
 transaction tr;
 
 function new(input string path = "len7wop");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd7;
  tr.tx_data   = {1'b0, tr.tx_data[7:1]};
  tr.parity_en = 1'b0;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = length7wop;
  finish_item(tr);
 endtask
endclass


//len6wp
class len8wop extends uvm_sequence#(transaction);
 `uvm_object_utils(len8wop)
 
 transaction tr;
 
 function new(input string path = "len8wop");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd8;
  tr.parity_en = 1'b0;
  tr.stop2 = 1'b0;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = length8wop;
  finish_item(tr);
 endtask
endclass

//rand_baud_2
class rand_baud_2 extends uvm_sequence#(transaction);
 `uvm_object_utils(rand_baud_2)
 
 transaction tr;
 
 function new(input string path = "rand_baud_2");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.length = 4'd8;
  tr.parity_en = 1'b1;
  tr.stop2 = 1'b1;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = rand_baud_2_stop;
  finish_item(tr);
 endtask
endclass

//rand_length_2
class rand_length_2 extends uvm_sequence#(transaction);
 `uvm_object_utils(rand_length_2)
 
 transaction tr;
 
 function new(input string path = "rand_length_2");
  super.new(path);
 endfunction
 
 virtual task body();
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.parity_en = 1'b1;
  tr.stop2 = 1'b1;
  tr.tx_start = 1'b1;
  tr.rx_start = 1'b1;
  tr.rst = 1'b0;
  tr.oper = rand_length_2_stop;
  finish_item(tr);
 endtask
endclass

//driver
class driver extends uvm_driver#(transaction);
 `uvm_component_utils(driver)
 
 transaction tr;
 virtual uart_if uif;
 
 function new(input string path = "driver", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr = transaction::type_id::create("tr");
  if(!uvm_config_db#(virtual uart_if)::get(this,"","uif",uif))
   `uvm_error("DRV","Unable to access interface");
 endfunction
 
 task reset_dut();
 repeat(5)
  begin
  uif.rst <= 1'b1;
  uif.tx_start <= 0;
  uif.rx_start <= 0;
  uif.tx_data <= 0;
  uif.baud <= 0;
  uif.length <= 0;
  uif.parity_type <= 0;
  uif.parity_en <= 0;
  uif.stop2 <=0;
  `uvm_info("DRV","Reset initiated",UVM_NONE);
  @(posedge uif.clk);
  end
 endtask
 
 task drive();
 reset_dut();
 forever begin
  seq_item_port.get_next_item(tr);
  uif.rst <= 1'b0;
  uif.tx_start <= 1'b1;
  uif.rx_start <= 1'b1;
  uif.tx_data <= tr.tx_data;
  uif.baud <= tr.baud;
  uif.length <= tr.length;
  uif.parity_type <= tr.parity_type;
  uif.parity_en <= tr.parity_en;
  uif.stop2 <= tr.stop2;
  `uvm_info("DRV", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d", tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data), UVM_NONE);
  @(posedge uif.clk);
  @(posedge uif.tx_done);
  @(negedge uif.rx_done);
  seq_item_port.item_done();
 end
 endtask
 
 virtual task run_phase(uvm_phase phase);
  drive();
 endtask
endclass

//mon
class monitor extends uvm_monitor;
 `uvm_component_utils(monitor)
 
 transaction tr;
 virtual uart_if uif;
 uvm_analysis_port#(transaction) send;
 
 function new(input string path = "monitor", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr = transaction::type_id::create("tr");
  send = new("write",this);
  if(!uvm_config_db#(virtual uart_if)::get(this,"","uif",uif))
   `uvm_error("DRV","Unable to access interface");
 endfunction
 
 virtual task run_phase(uvm_phase phase);
  forever begin
  @(posedge uif.clk);
  if(uif.rst)
  begin
   `uvm_info("MON","System reset",UVM_NONE);
   tr.rst = 1'b1;
   send.write(tr);
   end
   else
   begin
   @(posedge uif.tx_done);
   tr.rst = 1'b0;
   tr.tx_start = uif.tx_start;
   tr.rx_start = uif.rx_start;
   tr.tx_data = uif.tx_data;
   tr.baud = uif.baud;
   tr.length = uif.length;
   tr.parity_type = uif.parity_type;
   tr.parity_en = uif.parity_en;
   tr.stop2 = uif.stop2;
   @(negedge uif.rx_done);
   tr.rx_out = uif.rx_out;
   `uvm_info("MON", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d RX_DATA:%0d", tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data, tr.rx_out), UVM_NONE);
   send.write(tr);
   end
   end
 endtask
endclass

//sco
class sco extends uvm_scoreboard;
 `uvm_component_utils(sco)
 
 uvm_analysis_imp#(transaction,sco) recv;
 
 function new(input string path = "sco", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  recv = new("read",this);
 endfunction
 
 virtual function void write(transaction tr);
  `uvm_info("SCO", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d RX_DATA:%0d", tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data, tr.rx_out), UVM_NONE);
    if(tr.rst == 1'b1)
      `uvm_info("SCO", "System Reset", UVM_NONE)
    else if(tr.tx_data == tr.rx_out)
      `uvm_info("SCO", "Test Passed", UVM_NONE)
    else
      `uvm_info("SCO", "Test Failed", UVM_NONE)
   endfunction
endclass

//agent
class agent extends uvm_agent;
 `uvm_component_utils(agent)
 
 driver d;
 monitor m;
 uvm_sequencer#(transaction) seqr;
 uart_config cfg;
 
 function new(input string path = "agent", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  cfg =  uart_config::type_id::create("cfg"); 
  m = monitor::type_id::create("m",this);
  if(cfg.is_active == UVM_ACTIVE)
   begin   
   d = driver::type_id::create("d",this);
   seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
   end
  endfunction
 
 virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  d.seq_item_port.connect(seqr.seq_item_export);
 endfunction
endclass

//env
class env extends uvm_env;
 `uvm_component_utils(env)
 
 agent a;
 sco s;
 
 function new(input string path = "env", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  s = sco::type_id::create("s",this);
  a = agent::type_id::create("a",this);
 endfunction
 
 virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
   a.m.send.connect(s.recv);
 endfunction
endclass 

//test
class test extends uvm_test;
 `uvm_component_utils(test)
 
 env e;
 rand_baud_1 rbaud1;
 rand_length_1 rlen1;
 len5wp l5wp;
 len6wp l6wp;
 len7wp l7wp;
 len8wp l8wp;
 len5wop l5wop;
 len6wop l6wop;
 len7wop l7wop;
 len8wop l8wop;
 rand_baud_2 rbaud2;
 rand_length_2 rlen2;
 
 function new(input string path = "test", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e = env::type_id::create("e",this);
  rbaud1 = rand_baud_1::type_id::create("rbaud1");
  rbaud2 = rand_baud_2::type_id::create("rbaud2");
  rlen1 = rand_length_1::type_id::create("rlen1");
  rlen2 = rand_length_2::type_id::create("rlen2");
  l5wp = len5wp::type_id::create("l5wp");
  l6wp = len6wp::type_id::create("l6wp");
  l7wp = len7wp::type_id::create("l7wp");
  l8wp = len8wp::type_id::create("l8wp");
  l5wop = len5wop::type_id::create("l5wop");
  l6wop = len6wop::type_id::create("l6wop");
  l7wop = len7wop::type_id::create("l7wop");
  l8wop = len8wop::type_id::create("l8wop");
 endfunction
 
 virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  rbaud1.start(e.a.seqr);
  #20;
  phase.drop_objection(this);
 endtask
endclass

//tb
module uart_tb();

uart_if uif();

uart_top dut (.clk(uif.clk), .rst(uif.rst), .tx_start(uif.tx_start), .rx_start(uif.rx_start), .tx_data(uif.tx_data), .baud(uif.baud), .length(uif.length), .parity_type(uif.parity_type), .parity_en(uif.parity_en),.stop2(uif.stop2),.tx_done(uif.tx_done), .rx_done(uif.rx_done), .tx_err(uif.tx_err), .rx_err(uif.rx_err), .rx_out(uif.rx_out));
  
  initial begin
    uif.clk <= 0;
  end
 
  always #10 uif.clk <= ~uif.clk;
  
  initial begin
    uvm_config_db#(virtual uart_if)::set(null, "*", "uif", uif);
    run_test("test");
   end
   
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end  
endmodule

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit [1:0] {readd = 0, writed = 1, rstdut = 2} oper_mode;
//trans
class transaction extends uvm_sequence_item;
 
 oper_mode op;
 logic wr;
 randc bit [7:0] addr;
 rand bit [7:0] din;
 logic [7:0] datard;
 logic done;
 
 constraint addr_c { addr <= 10;}
 
 function new(input string path ="transaction");
  super.new(path);
 endfunction
 
 `uvm_object_utils_begin(transaction)
 `uvm_field_int(wr,UVM_DEFAULT)
 `uvm_field_int(addr,UVM_DEFAULT)
 `uvm_field_int(din,UVM_DEFAULT)
 `uvm_field_int(datard,UVM_DEFAULT)
 `uvm_field_int(done,UVM_DEFAULT)
 `uvm_field_enum(oper_mode,op,UVM_DEFAULT)
 `uvm_object_utils_end
 
endclass

//write
class write_data extends uvm_sequence#(transaction);
 `uvm_object_utils(write_data)
 
 transaction tr;
 
 function new(input string path ="write_data");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat (5) begin
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.op = writed;
  `uvm_info("WD",$sformatf("MODE:Write addr=%0d, data=%0d",tr.addr,tr.din),UVM_NONE);
  finish_item(tr); 
 end 
 endtask
endclass

//read
class read_data extends uvm_sequence#(transaction);
 `uvm_object_utils(read_data)
 
 transaction tr;
 
 function new(input string path ="read_data");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat (5) begin
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.op = readd;
  `uvm_info("RD",$sformatf("MODE:Read addr=%0d",tr.addr),UVM_NONE);
  finish_item(tr); 
 end 
 endtask
endclass

//reset
class reset extends uvm_sequence#(transaction);
 `uvm_object_utils(reset)
 
 transaction tr;
 
 function new(input string path ="reset");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat (5) begin
  tr = transaction::type_id::create("tr");
  start_item(tr);
  assert(tr.randomize);
  tr.op = rstdut;
  `uvm_info("RSTDUT","MODE:RESET",UVM_NONE);
  finish_item(tr); 
 end 
 endtask
endclass

//driver
class driver extends uvm_driver#(transaction);
 `uvm_component_utils(driver)
 
 transaction tr;
 virtual i2c_i vif;
 
 function new(input string path = "driver", uvm_component c);
  super.new(path,c); 
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr = transaction::type_id::create("tr");
  if(!uvm_config_db#(virtual i2c_i)::get(this,"","vif",vif))
   `uvm_error("DRV","Unable to access interface");
 endfunction
 
 task reset_dut();
 begin
   vif.rst <= 1'b1;
   vif.addr <= 0;
   vif.din <= 0;
   vif.wr <= 0;
   `uvm_info("DRV","System reset",UVM_NONE);
   @(posedge vif.clk);
  end
 endtask
 
 task write_d();
 begin
  vif.rst <= 0;
  vif.wr <= 1;
  vif.din <= tr.din;
  vif.addr <= tr.addr;
  `uvm_info("DRV",$sformatf("WRITE addr=%0d, data=%0d",vif.addr,vif.din),UVM_NONE);
  @(posedge vif.done);
  end
 endtask
 
 task read_d();
  vif.rst <= 0;
  vif.wr <= 0;
  vif.din <= 0;
  vif.addr <= tr.addr;
  `uvm_info("DRV",$sformatf("READ addr=%0d",vif.addr),UVM_NONE);
  @(posedge vif.done);
 endtask 
 
 virtual task run_phase(uvm_phase phase);
 forever begin
  seq_item_port.get_next_item(tr);
  if(tr.op == rstdut)
  begin
  reset_dut();
  end
  else if(tr.op == writed)
  begin
    write_d();
  end
  else if(tr.op == readd)
  begin
  read_d();
  end
  seq_item_port.item_done();
 end
 endtask
endclass 

//mon
class monitor extends uvm_monitor;
 `uvm_component_utils(monitor)
 
 transaction tr; 
 virtual i2c_i vif;
 uvm_analysis_port#(transaction) send;
 
 function new(input string path = "monitor", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr = transaction::type_id::create("tr");
  send = new("write",this); 
  if(!uvm_config_db#(virtual i2c_i)::get(this,"","vif",vif))
   `uvm_error("MON","Unable to access interface");
 endfunction
 
 virtual task run_phase(uvm_phase phase);
  forever begin
  @(posedge vif.clk)
  if(vif.rst)
  begin
   tr.op = rstdut;
   `uvm_info("MON","System reset detected",UVM_NONE);
   send.write(tr);
   end 
   else begin
   if(vif.wr)
   begin
    @(posedge vif.done);
    tr.op = writed;
    tr.addr = vif.addr;
    tr.din = vif.din;
    tr.wr = 1;
    `uvm_info("MON",$sformatf("MODE:Write addr=%0d,din=%0d",tr.addr,tr.din),UVM_NONE);
    send.write(tr);
   end 
   else
   begin
    tr.wr = 0;
    tr.op = readd;
    tr.addr = vif.addr;
    tr.din = vif.din;
     @(posedge vif.done);
    tr.datard = vif.datard;
    `uvm_info("MON",$sformatf("MODE:Write addr=%0d,datard=%0d,done=%od",tr.addr,tr.datard,tr.done),UVM_NONE);
    send.write(tr);
   end 
   end
  end
 endtask
endclass

//sco
class sco extends uvm_scoreboard;
 `uvm_component_utils(sco)
 
 transaction tr;
 uvm_analysis_imp#(transaction,sco) recv;
 bit[7:0] arr[128] = '{default:0};
 bit [7:0]temp=0; 
 
 function new(input string path = "sco", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr = transaction::type_id::create("tr"); 
    recv = new("read",this); 
 endfunction
 
 virtual function void write(transaction tr);
   if(tr.op == rstdut)
    `uvm_info("SCO","System reset detected",UVM_NONE)
   else if(tr.op == writed)
    begin
    arr[tr.addr] = tr.din;
    `uvm_info("SCO",$sformatf("Write : addr=%0d, din=%0d, arr=%0d",tr.addr,tr.din,arr[tr.addr]),UVM_NONE);
    end 
    else if(tr.op == readd)
    begin
    temp = arr[tr.addr];
    if(tr.datard == temp)
    `uvm_info("SCO",$sformatf("DATA MATCHED : addr=%0d, datard=%0d, temp=%0d",tr.addr,tr.datard,temp),UVM_NONE)
    else
    `uvm_info("SCO",$sformatf("TEST FAILED : addr=%0d, datard=%0d temp=%0d",tr.addr,tr.datard,temp), UVM_NONE)
    end 
        $display("----------------------------------------------------------------");
 endfunction
endclass

//agent
class agent extends uvm_agent;
 `uvm_component_utils(agent)
 
 driver d; 
 monitor m;
 uvm_sequencer#(transaction) seqr;
 
 function new(input string path = "agent", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  d = driver::type_id::create("d",this);
  m = monitor::type_id::create("m",this);
  seqr = uvm_sequencer#(transaction)::type_id::create("seqr",this);
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
  a = agent::type_id::create("a",this);
  s = sco::type_id::create("s",this);
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
 reset r;
 write_data wd;
 read_data rd;
  
 function new(input string path = "test", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e = env::type_id::create("e",this);
  r = reset::type_id::create("r");
  wd = write_data::type_id::create("wd");
  rd = read_data::type_id::create("rd");
 endfunction      
 
 virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
   r.start(e.a.seqr);
   wd.start(e.a.seqr);
   rd.start(e.a.seqr);
  phase.drop_objection(this);
 endtask
endclass

//tb
module tb();

i2c_i vif();

i2c_mem dut (.clk(vif.clk), .rst(vif.rst), .wr(vif.wr), .addr(vif.addr), .din(vif.din), .datard(vif.datard), .done(vif.done));
  
  initial begin
    vif.clk <= 0;
  end
 
  always #10 vif.clk <= ~vif.clk;
  
  initial begin
    uvm_config_db#(virtual i2c_i)::set(null, "*", "vif", vif);
    run_test("test");
   end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
   
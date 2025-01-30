`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit[2:0]{readd=0, writed=1, rstdut=2, writeerr=3, readerr=4} oper_mode;
//config
class spi_config extends uvm_object;
 `uvm_object_utils(spi_config)
 
 function new(input string path = "spi_config");
  super.new(path);
 endfunction
 
 uvm_active_passive_enum is_active=UVM_ACTIVE;
endclass

//trans
class transaction extends uvm_sequence_item;
 
 rand oper_mode op;
 logic rst;
 logic wr;
 randc logic [7:0] addr;
 rand logic [7:0] din;
 logic done;
 logic err;
 logic [7:0] dout;
 
 function new(input string path = "transaction");
  super.new(path);
 endfunction
 
 constraint addr_c { addr <= 10;}
 constraint addr_err_c {addr > 31;}
 
 
 `uvm_object_utils_begin(transaction)
 `uvm_field_int(rst,UVM_DEFAULT)
 `uvm_field_int(wr,UVM_DEFAULT)
 `uvm_field_int(addr,UVM_DEFAULT)
 `uvm_field_int(din,UVM_DEFAULT)
 `uvm_field_int(done,UVM_DEFAULT)
 `uvm_field_int(err,UVM_DEFAULT)
 `uvm_field_int(dout,UVM_DEFAULT)
 `uvm_field_enum(oper_mode,op,UVM_DEFAULT)
 `uvm_object_utils_end
endclass

//write_data
class write_data extends uvm_sequence#(transaction);
 `uvm_object_utils(write_data)
 
 transaction tr;
 
 function new(input string path = "write_data");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat(15) begin
  tr = transaction::type_id::create("tr");
  tr.addr_c.constraint_mode(1);
  tr.addr_err_c.constraint_mode(0);
  start_item(tr);
  assert(tr.randomize);
  tr.op = writed;
  finish_item(tr);
 end 
 endtask
endclass

//write_err
class write_err extends uvm_sequence#(transaction);
 `uvm_object_utils(write_err)
 
 transaction tr;
 
 function new(input string path = "write_err");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat(15) begin
  tr = transaction::type_id::create("tr");
  tr.addr_c.constraint_mode(0);
  tr.addr_err_c.constraint_mode(1);
  start_item(tr);
  assert(tr.randomize);
  tr.op = writeerr;
  finish_item(tr);
 end 
 endtask
endclass

//read_data
class read_data extends uvm_sequence#(transaction);
 `uvm_object_utils(read_data)
 
 transaction tr;
 
 function new(input string path = "read_data");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat(15) begin
  tr = transaction::type_id::create("tr");
  tr.addr_c.constraint_mode(1);
  tr.addr_err_c.constraint_mode(0);
  start_item(tr);
  assert(tr.randomize);
  tr.op = readd;
  finish_item(tr);
 end 
 endtask
endclass

//read_err
class read_err extends uvm_sequence#(transaction);
 `uvm_object_utils(read_err)
 
 transaction tr;
 
 function new(input string path = "read_err");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat(15) begin
  tr = transaction::type_id::create("tr");
  tr.addr_c.constraint_mode(0);
  tr.addr_err_c.constraint_mode(1);
  start_item(tr);
  assert(tr.randomize);
  tr.op = readerr;
  finish_item(tr);
 end 
 endtask
endclass

//reset
class reset extends uvm_sequence#(transaction);
 `uvm_object_utils(reset)
 
 transaction tr;
 
 function new(input string path = "reset");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat(15) begin
  tr = transaction::type_id::create("tr");
  tr.addr_c.constraint_mode(1);
  tr.addr_err_c.constraint_mode(0);
  start_item(tr);
  assert(tr.randomize);
  tr.rst = 1'b1;
  tr.op = rstdut;
  finish_item(tr);
 end 
 endtask
endclass

//write_read
class write_read extends uvm_sequence#(transaction);
 `uvm_object_utils(write_read)
 
 transaction tr;
 
 function new(input string path = "write_read");
  super.new(path);
 endfunction
 
 virtual task body();
 repeat(10) begin
  tr = transaction::type_id::create("tr");
  tr.addr_c.constraint_mode(1);
  tr.addr_err_c.constraint_mode(0);
  start_item(tr);
  assert(tr.randomize);
  tr.op = writed;
  finish_item(tr);
 end 
  repeat(10) begin
  tr = transaction::type_id::create("tr");
  tr.addr_c.constraint_mode(1);
  tr.addr_err_c.constraint_mode(0);
  start_item(tr);
  assert(tr.randomize);
  tr.op = readd;
  finish_item(tr);
 end 
 endtask
endclass

//drv
class drv extends uvm_driver#(transaction);
 `uvm_component_utils(drv)
 
 transaction tr;
 virtual spi_i sip;
 
 function new(input string path = "drv", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr = transaction::type_id::create("tr");
  if(!uvm_config_db#(virtual spi_i)::get(this,"","sip",sip))
   `uvm_error("DRV","Unable to access interface");
 endfunction
 
 task reset_dut();
  repeat(5) begin
  tr.rst <= 1'b1;
  tr.wr <= 1'b0;
  tr.din <= 0;
  tr.addr <= 0;
  @(posedge sip.clk);
  end
 endtask
 
 task drive();
 reset_dut();
 forever begin
  seq_item_port.get_next_item(tr);
  if(tr.op == rstdut)
  begin
   sip.rst <= 1'b1;
   @(posedge sip.clk);
  end
  else if(tr.op == writed)
     begin
     sip.rst <= 1'b0;
     sip.wr <= 1'b1;
     sip.addr <= tr.addr;
     sip.din <= tr.din;
     `uvm_info("DRV", $sformatf("mode : Write addr:%0d din:%0d", sip.addr, sip.din), UVM_NONE);
     @(posedge sip.clk);
     @(posedge sip.done);
     end 
  else if(tr.op == readd)
     begin
     sip.rst <= 1'b0;
     sip.wr <= 1'b0;
     sip.addr <= tr.addr;
     sip.din <= tr.din;
     `uvm_info("DRV", $sformatf("mode : Read addr:%0d din:%0d",sip.addr,sip.din), UVM_NONE);
     @(posedge sip.clk);
     @(posedge sip.done); 
     end 
   seq_item_port.item_done();
  end 
  endtask
  
  virtual task run_phase(uvm_phase phase);
   drive();
  endtask
endclass

//mon 
class mon extends uvm_monitor;
 `uvm_component_utils(mon)
 
 uvm_analysis_port#(transaction) send;
 transaction tr;
 virtual spi_i sip;
 
 function new(input string path = "mon", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr = transaction::type_id::create("tr");
  send = new("write",this);
  if(!uvm_config_db#(virtual spi_i)::get(this,"","sip",sip))
   `uvm_error("DRV","Unable to access interface");
 endfunction
 
 virtual task run_phase(uvm_phase phase);
 forever begin
  @(posedge sip.clk)
  if(sip.rst)
  begin
   tr.op = rstdut;
   `uvm_info("MON","System reset:Start of simulation",UVM_NONE);
   send.write(tr);
   end
   else if(sip.rst == 0 && sip.wr == 1)
    begin
    @(posedge sip.done);
    tr.din = sip.din; 
    tr.addr = sip.addr;
    tr.err = sip.err;
    tr.op = writed;
    `uvm_info("MON", $sformatf("DATA WRITE addr:%0d data:%0d err:%0d",tr.addr,tr.din,tr.err), UVM_NONE);
    send.write(tr); 
    end
   else if(sip.rst == 0 && sip.wr == 0)
    begin
    @(posedge sip.done); 
    tr.addr = sip.addr;
    tr.err = sip.err;
    tr.dout = sip.dout;
    tr.op = readd;
    `uvm_info("MON", $sformatf("DATA READ addr:%0d data:%0d err:%0d",tr.addr,tr.dout,tr.err), UVM_NONE);
    send.write(tr); 
    end
   end
  endtask
 endclass
 
//sco
class sco extends uvm_scoreboard;
 `uvm_component_utils(sco)
 
 transaction tr;
 uvm_analysis_imp#(transaction,sco) recv;
 bit [7:0]arr[32] ='{default:0};
 bit[7:0] addr =0;
 bit[7:0] datard =0;
  
 function new(input string path = "sco", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr = transaction::type_id::create("tr");
  recv = new("recv",this);
 endfunction
 
 virtual function void write(transaction tr);
    if(tr.op == rstdut)
              begin
                `uvm_info("SCO", "SYSTEM RESET DETECTED", UVM_NONE);
              end  
    else if (tr.op == writed)
      begin
        if(tr.err == 1'b1)
                begin
                  `uvm_info("SCO", "SLV ERROR during WRITE OP", UVM_NONE);
                end
              else
                begin
                arr[tr.addr] = tr.din;
                  `uvm_info("SCO", $sformatf("DATA WRITE OP  addr:%0d, wdata:%0d arr_wr:%0d",tr.addr,tr.din,  arr[tr.addr]), UVM_NONE);
                end
      end
    else if (tr.op == readd)
      begin
          if(tr.err == 1'b1)
                begin
                  `uvm_info("SCO", "SLV ERROR during READ OP", UVM_NONE);
                end
              else 
                begin
                  datard = arr[tr.addr];
                  if (datard == tr.dout)
                    `uvm_info("SCO", $sformatf("DATA MATCHED : addr:%0d, rdata:%0d",tr.addr,tr.dout), UVM_NONE)
                         else
                     `uvm_info("SCO",$sformatf("TEST FAILED : addr:%0d, rdata:%0d data_rd_arr:%0d",tr.addr,tr.dout,datard), UVM_NONE) 
                end
 
      end
      endfunction
endclass

//agent
class agent extends uvm_agent;
 `uvm_component_utils(agent)
 
 drv d;
 mon m;
 uvm_sequencer#(transaction) seqr;
 spi_config cfg;
 
 function new(input string path = "agent", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  cfg = spi_config::type_id::create("cfg");
  m = mon::type_id::create("m",this);
  if(is_active == UVM_ACTIVE)
   d = drv::type_id::create("d",this);
   seqr = uvm_sequencer#(transaction)::type_id::create("seqr",this);
 endfunction
 
 virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(is_active == UVM_ACTIVE)
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
 write_data wdata;
 write_err werr;
 read_data rdata;
 read_err rerr;
 reset r;
 write_read wr;
 
 function new(input string path = "test", uvm_component c);
  super.new(path,c);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e = env::type_id::create("e",this);
  wdata = write_data::type_id::create("wdata");
  werr = write_err::type_id::create("werr");
  rdata = read_data::type_id::create("rdata");
  rerr = read_err::type_id::create("rerr");
  r = reset::type_id::create("r");
  wr = write_read::type_id::create("wr");
 endfunction
 
 virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  wr.start(e.a.seqr);
  #20;
  phase.drop_objection(this);
 endtask
endclass

//tb
module tb;

spi_i sip();

top dut (.wr(sip.wr), .clk(sip.clk), .rst(sip.rst), .addr(sip.addr), .din(sip.din), .dout(sip.dout), .done(sip.done), .err(sip.err));
  
  initial begin
    sip.clk <= 0;
  end
 
  always #10 sip.clk <= ~sip.clk;
 
  
  
  initial begin
    uvm_config_db#(virtual spi_i)::set(null, "*", "sip", sip);
    run_test("test");
   end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
  
endmodule 
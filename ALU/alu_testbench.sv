`include "uvm_macros.svh"
import uvm_pkg::*;

class alu_transaction extends uvm_sequence_item;
  
  rand bit [31:0] operand_a;
  rand bit [31:0] operand_b;
  rand bit [3:0] alu_control;
  bit [31:0] result;
  bit zero_flag;
  
  `uvm_object_utils_begin(alu_transaction)
  `uvm_field_int(operand_a,UVM_DEFAULT)
  `uvm_field_int(operand_b,UVM_DEFAULT)
  `uvm_field_int(alu_control,UVM_DEFAULT)
  `uvm_field_int(result,UVM_DEFAULT)
  `uvm_field_int(zero_flag,UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new(input string path = "alu_transaction");
    super.new(path);;
  endfunction
  
  constraint valid_ops {
        alu_control inside {[4'b0000:4'b1001]};
    }
  

endclass

/////////////////////////////////////////////////////////////////////////////

class alu_sequence extends uvm_sequence#(alu_transaction);
  `uvm_object_utils(alu_sequence)
  
  function new(input string path = "alu_sequence");
    super.new(path);
  endfunction
  
  virtual task body();
    alu_transaction tr = alu_transaction::type_id::create("tr");
    repeat(20) begin
      start_item(tr);
      assert(tr.randomize());
      `uvm_info("SEQ",$sformatf("Data sent to driver operand_a:%0h, operand_b:%0h, alu_control:%0b",tr.operand_a,tr.operand_b,tr.alu_control),UVM_NONE);
      finish_item(tr);
    end
  endtask
endclass

///////////////////////////////////////////////////////////////////////////////

class driver extends uvm_driver#(alu_transaction);
  `uvm_component_utils(driver)
  
  alu_transaction tr;
  virtual alu_if aif;
  
  function new(input string path = "driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = alu_transaction::type_id::create("tr");
    if(!uvm_config_db#(virtual alu_if)::get(this,"","aif",aif))
      `uvm_error("DRV","Unable to access interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(tr);
      aif.operand_a <= tr.operand_a;
      aif.operand_b <= tr.operand_b;
      aif.alu_control <= tr.alu_control;
      `uvm_info("DRV",$sformatf("Data sent to interface is operand_a = %0h, operand_b = %0h, alu_control = %0b",tr.operand_a,tr.operand_b,tr.alu_control),UVM_NONE);
      seq_item_port.item_done();
      #10;
      end
  endtask
endclass

///////////////////////////////////////////////////////////////////////////////

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  alu_transaction tr;
  uvm_analysis_port#(alu_transaction) send;
  virtual alu_if aif;
  
  function new(input string path = "monitor", uvm_component parent = null);
    super.new(path,parent);
    send = new("send",this);
    alu_cov = new();
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = alu_transaction::type_id::create("tr");
    if(!uvm_config_db#(virtual alu_if)::get(this,"","aif",aif))
      `uvm_error("MON","Unable to access interface");
  endfunction
  
    covergroup alu_cov;
    option.per_instance = 1;
    coverpoint tr.operand_a{
      bins low = {[0:32'h80000000]};
      bins high = {[32'h80000001:$]};
    }
    coverpoint tr.operand_b{
      bins low = {[0:32'h80000000]};
      bins high = {[32'h80000001:$]};
    }
    coverpoint tr.alu_control{
      bins add_op = {4'b0010};
      bins sub_op = {4'b0110};
      bins and_op = {4'b0000};
      bins or_op  = {4'b0001};
      bins xor_op = {4'b0010};
      bins sll_op = {4'b0100};
      bins srl_op = {4'b0101};
      bins sra_op = {4'b0111};
      bins slt_op = {4'b1000};
      bins sltu_op = {4'b1001};
    }
  endgroup
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      #10;
      tr.operand_a = aif.operand_a;
      tr.operand_b = aif.operand_b;
      tr.alu_control = aif.alu_control;
      tr.result = aif.result;
      tr.zero_flag = aif.zero_flag;
      `uvm_info("MON",$sformatf("Data received from DUT operand_a = %0h, operand_b = %0h, alu_control = %0b, result = %0h, zero_flag = %0b",tr.operand_a,tr.operand_b,tr.alu_control,tr.result,tr.zero_flag),UVM_NONE);
       // assertion 1. zero_flag should match result == 0
      if (tr.result == 0) begin
        zero_flag_assert: assert (tr.zero_flag == 1)
         else $error("Assertion failed in alu_if: zero_flag should be 1 when result == 0 at time %0t", $time);
        if (tr.zero_flag == 1)
           $display("Assertion passed: zero_flag == 1 when result == 0 at time %0t", $time);
      end
      // assertion 2. alu_control should be within valid range
      assert (tr.alu_control <= 4'd9)
        else $fatal("Assertion failed in alu_if: Invalid alu_control=%0b at time %0t", tr.alu_control, $time);     
      alu_cov.sample();
      send.write(tr);
    end
  endtask
endclass
                                            
////////////////////////////////////////////////////////////////////////////////
                                            
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard);
  
  alu_transaction txn;
  uvm_analysis_imp#(alu_transaction,scoreboard) recv;
  
  function new(input string path = "scoreboard", uvm_component parent = null);
    super.new(path,parent);
    recv = new("recv",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    txn = alu_transaction::type_id::create("tr");
  endfunction
  
    logic [31:0] expected_result;
    logic        expected_zero;
  
  function string state_to_str(input logic [3:0] state);
    case (state)
            4'b0000: return "AND";
            4'b0001: return "OR";
            4'b0010: return "ADD";
            4'b0011: return "XOR";
            4'b0110: return "SUB";
            4'b0100: return "SLL";
            4'b0101: return "SRL";
            4'b0111: return "SRA";
            4'b1000: return "SLT";
            4'b1001: return "SLTU";
        default: return "U"; // undefined
    endcase
  endfunction
  
  virtual function void write(input alu_transaction t);
    txn = t;
    `uvm_info("SCO",$sformatf("Data received from monitorn operand_a = %0h, operand_b = %0h, alu_control= %0b-%s, result = %0h, zero_flag = %0b",txn.operand_a, txn.operand_b,txn.alu_control,state_to_str(txn.alu_control), txn.result, txn.zero_flag),UVM_NONE);


        // Compute expected result based on alu_control
    case (txn.alu_control)
            4'b0000: expected_result = txn.operand_a & txn.operand_b; // AND
            4'b0001: expected_result = txn.operand_a | txn.operand_b; // OR
            4'b0010: expected_result = txn.operand_a + txn.operand_b; // ADD
            4'b0011: expected_result = txn.operand_a ^ txn.operand_b; // XOR
            4'b0110: expected_result = txn.operand_a - txn.operand_b; // SUB
            4'b0100: expected_result = txn.operand_a << txn.operand_b[4:0]; // SLL
            4'b0101: expected_result = txn.operand_a >> txn.operand_b[4:0]; // SRL
            4'b0111: expected_result = $signed(txn.operand_a) >>> txn.operand_b[4:0]; // SRA
            4'b1000: expected_result = ($signed(txn.operand_a) < $signed(txn.operand_b)) ? 32'd1 : 32'd0; // SLT
            4'b1001: expected_result = (txn.operand_a < txn.operand_b) ? 32'd1 : 32'd0; // SLTU
            default: expected_result = 32'd0;
        endcase

        expected_zero = (expected_result == 32'd0);
    
    // Compare DUT outputs via interface
    if (txn.result == expected_result)
      begin
        `uvm_info("SCO","Got the expected result",UVM_NONE);
      end 
    else
      begin
        `uvm_error("ALU_MISMATCH", $sformatf("Result mismatch: control=%0b A=%0h B=%0h | DUT=%0h, REF=%0h",txn.alu_control, txn.operand_a, txn.operand_b, txn.result, expected_result))
        end

    if (txn.zero_flag == expected_zero)
      begin
        `uvm_info("SCO","Got the expected zero_flag",UVM_NONE);
      end
    else
      begin
      `uvm_error("ZERO_FLAG", $sformatf("Zero flag mismatch: result=%0h | DUT=%0b, REF=%0b",txn.result, txn.zero_flag, expected_zero))
        end
    $display("----------------------------------------------------------------");
    endfunction
endclass
                                            
/////////////////////////////////////////////////////////////////////////////////
                                            
class agent extends uvm_agent;
  `uvm_component_utils(agent);
  
  driver drv;
  monitor mon;
  uvm_sequencer#(alu_transaction) seqr;
  
  function new(input string path = "agent", uvm_component c);
    super.new(path,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = driver::type_id::create("drv",this);
    mon = monitor::type_id::create("mon",this);
    seqr = uvm_sequencer#(alu_transaction)::type_id::create("seqr",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
                                            
/////////////////////////////////////////////////////////////////////////////////////
                                            
class env extends uvm_env;
  `uvm_component_utils(env);
  
  scoreboard sco;
  agent a;
  
  function new(input string path = "env", uvm_component c);
    super.new(path,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sco = scoreboard::type_id::create("sco",this);
    a = agent::type_id::create("a",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.mon.send.connect(sco.recv);
  endfunction
endclass
                                            
//////////////////////////////////////////////////////////////////////////////////
  
  
class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  alu_sequence alu_seq;
  
  function new(input string path ="test", uvm_component c);
    super.new(path,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e",this);
    alu_seq = alu_sequence::type_id::create("alu_seq");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    alu_seq.start(e.a.seqr);
    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this,10);
  endtask
endclass
                                            

/////////////////////////////////////////////////////////////////////////////////
                                            
module alu_tb();
  
  alu_if aif();
  alu dut (aif.operand_a,aif.operand_b,aif.alu_control,aif.result,aif.zero_flag);
    
   initial begin
$dumpfile("dump.vcd");
$dumpvars;
end
  
initial begin
  aif.operand_a   = 32'd0;
  aif.operand_b   = 32'd0;
  aif.alu_control = 4'd0;
  uvm_config_db#(virtual alu_if)::set(null,"*","aif",aif);
  run_test("test");
  #50 $finish;
end 
endmodule

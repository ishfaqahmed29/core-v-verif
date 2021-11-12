// Copyright 2021 Datum Technology Corporation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
// with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
//                                        https://solderpad.org/licenses/SHL-2.1/
// Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVML_DRV_SV__
`define __UVML_DRV_SV__


class uvma_i2c_m_drv #(
   type REQ = uvm_sequence_item,
   type RSP = uvm_sequence_item
) extends uvm_driver #(
   .REQ(REQ),
   .RSP(RSP)
);
   
   `uvm_component_utils_begin(uvma_i2c_m_drv)
   
   virtual uvma_i2c_m_intf vif;

   // Constraints
   
   extern function new(string name="uvma_i2c_m_drv", uvm_component parent=null);
   extern function build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
   extern task reset();
   extern task drive_to_dut();
   extern task start_condition();
   extern task stop_condition();
   extern task addr_frame();
   extern task rd_wr_bit();
   extern task ack_nak_bit();

endclass : uvma_i2c_m_drv


function uvma_i2c_m_drv::new(string name="uvma_i2c_m_drv", uvm_component parent=null);
   super.new(name, parent);
endfunction : new

   // Methods
function uvma_i2c_m_drv::build_phase(uvm_phase phase);
   super.build_phase(phase);
      if (uvm_config_db#(virtual uvma_i2c_m_intf)::get(this, "", "vif", vif)) begin
         `uvm_fatal("NOVIF", {"Must set virtual interface for : ", get_full_name(), ".vif"})
      end
endfunction
   
task uvma_i2c_m_drv::run_phase(uvm_phase phase);
   fork
      reset();
      drive_to_dut();
   join_none
endfunction

task uvma_i2c_m_drv::reset(uvm_sequence_item seq_item);
   forever begin
      @(negedge vif.rst);
   end
endtask

task uvma_i2c_m_drv::drive_to_dut(uvm_sequence_item seq_item);
   forever begin
      seq_item_port.get_next_item(req);
      start_condition(req);
      stop_condition(req);
      seq_item_port.item_done();
   end
endtask

task uvma_i2c_m_drv::start_condition(uvm_sequence_item seq_item);
   forever begin
      @(posedge vif.clk);
   end
endtask

task uvma_i2c_m_drv::stop_condition(uvm_sequence_item seq_item);
   
endtask

task uvma_i2c_m_drv::addr_frame(uvm_sequence_item seq_item);
   forever begin
      @(posedge vif.clk);
      
   end
endtask

task uvma_i2c_m_drv::rd_wr_bit(uvm_sequence_item seq_item);
   
endtask

task uvma_i2c_m_drv::ack_nak_bit(uvm_sequence_item seq_item);
   
endtask


`endif // __UVML_DRV_SV__

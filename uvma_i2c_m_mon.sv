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

	/* I2C signals
	input  logic                      scl_i,
	output logic                      scl_o,
	output logic                      scl_oe,
	input  logic                      sda_i,
	output logic                      sda_o,
	output logic                      sda_oe
   */


`ifndef __UVML_MON_SV__
`define __UVML_MON_SV__


class uvml_mon_i2c_m extends uvm_monitor;
   
   `uvm_component_utils_begin(uvml_mon_i2c_m)
   
   virtual uvml_intf_i2c_m vif;
   //unsigned int pkts;

   uvm_analysis_port #(seq_item) mon_analysis_port;

   uvml_seq_item_i2c_m mon_txn;

   // Constraints
   
   extern function new(string name="uvml_mon_i2c_m", uvm_component parent=null);
   
   // Methods
   function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       if (uvm_config_db#(virtual uvml_intf_i2c_m)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"Must set virtual interface for : ", get_full_name(), ".vif"})
        end
        mon_analysis_port = new("mon_analysis_port", this);
        mon_txn = uvml_seq_item_i2c_m::type_id::create("mon_txn");
   endfunction

   virtual task run_phase(uvm_phase phase);
       forever begin
         @(posedge vif.clk);
         // start condition & bit, sda -> high to low, scl -> high to low
         if (vif.scl_oe = 1'b1 && vif.sda_oe = 1'b1) begin
            //   addr frame
            for (int i=0; i<8; ++i) begin
               mon_txn.sda_o[i] = vif.sda_o[i]; 
            end
         end
            //   r/w bit
         mon_txn.sda_o = vif.sda_o;
         @(posedge vif.clk);
            //   ack bit
            vif.sda_oe = 1'b0;
            mon_txn.sda_o = vif.sda_o;
            //   data frame
            for (int i=0; i<8; ++i) begin
               mon_txn.sda_o[i] = vif.sda_o[i];
            end
         @(posedge vif.clk);
            //   nak bit
            vif.sda_oe = 1'b1;
            mon_txn.sda_o = vif.sda_o;
         @(posedge vif.clk);
            //   stop condition & bit, scl -> low to high, sda -> low to high
            if (!(vif.scl_oe = 1'b1 && vif.sda_oe = 1'b0)) begin
               `uvm_error(get_type_name(), "Failed to detect STOP condition! ")
            end
         `uvm_info(get_type_name(), "Read Register test ", UVM_LOW)            
         //   read non-existing to check nak
         @(posedge vif.clk)
         if (condition) begin
               //   start-bit
               //   r/w bit
               //   ack bit
               //   data frame
               //   ack bit
               //   stop-bit
         end
         `uvm_info()
         //   write reg when vif.sda_i = 0
         @(posedge vif.clk);
         if (condition) begin
               pass
               //   start-bit
               //   ack bit
               //   data frame
               //   ack bit
               //   stop-bit
         end
         `uvm_info()
         //   write non-existing to check nak
         @(posedge vif.clk);
         if (condition) begin
               pass
               //   start-bit
               //   ack bit
               //   data frame
               //   ack bit
               //   stop-bit
         end
         `uvm_info()
         //   read N of M registers, M>=N
         @(posedge vif.clk);
         if (condition) begin
               pass
               //   start-bit
               //   ack bit
               //   data frame
               //   ack bit
               //   stop-bit
         end
         `uvm_info()
           //   read N of M registers, M<N  (nak)
         @(posedge vif.clk);
         if (condition) begin
               pass
               //   start-bit
               //   ack bit
               //   data frame
               //   ack bit
               //   stop-bit
         end
         `uvm_info()
         //   write N of M registers, M>=N
         @(posedge vif.clk);
         if (condition) begin
               pass
               //   start-bit
               //   ack bit
               //   data frame
               //   ack bit
               //   stop-bit
         end
         `uvm_info()
         //   write N of M registers, M<N  (nak)
         @(posedge vif.clk);
         if (condition) begin
               pass
               //   start-bit
               //   ack bit
               //   data frame
               //   ack bit
               //   stop-bit
         end
         `uvm_info()
         //   END OF DATA TRANSFER
         mon_analysis_port.write(seq_item);
       end
   endtask
   
endclass : uvml_mon_i2c_m


function uvml_mon_i2c_m::new(string name="uvml_mon_i2c_m", uvm_component parent=null);
   super.new(name, parent);
endfunction : new


`endif // __UVML_MON_SV__

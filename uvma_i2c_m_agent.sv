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


`ifndef __UVML_AGENT_SV__
`define __UVML_AGENT_SV__


class uvml_agent_i2c_m extends uvm_agent;
   
   `uvm_component_utils(uvml_agent_i2c_m)

   uvml_mon_i2c_m    mon;
   uvml_drv_i2c_m    drv;
   uvml_sqr_i2c_m    sqr;
      
   // Constraints

   // Methods

   extern function new(string name="uvml_agent_i2c_m", uvm_component parent=null);
   extern function build_phase(uvm_phase phase);
   extern function connect_phase(uvm_phase phase);

endclass : uvml_agent_i2c_m


function uvma_i2c_m_agent::new(string name="uvml_agent_i2c_m", uvm_component parent=null);
   super.new(name, parent);
endfunction : new

function uvma_i2c_m_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if (get_is_active()) begin
      sqr = uvml_sqr_i2c_m::type_id::create("sqr", this);
      drv = uvml_drv_i2c_m::type_id::create("drv", this);
   end
   mon = uvml_mon_i2c_m::type_id::create("mon", this);
endfunction

function uvma_i2c_m_agent::connect_phase(uvm_phase phase);
   if (!get_is_active()) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
   end
endfunction

`endif // __UVML_AGENT_SV__

//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_master_agent
//
//------------------------------------------------------------------------------

class ubus_master_agent extends uvm_agent;

  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  protected int master_id;

  ubus_master_driver driver;
  ubus_master_sequencer sequencer;
  ubus_master_monitor monitor;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_master_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(master_id, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = ubus_master_monitor::type_id::create("monitor", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ubus_master_sequencer::type_id::create("sequencer", this);
      driver = ubus_master_driver::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect_phase
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : ubus_master_agent



//----------------------------------------------------------------------
//   Copyright 2007-2009 Cadence Design Systems, Inc.
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

class virtual_seq extends uvm_reg_sequence;
  
  reg_sys_xa0 model;

  `uvm_object_utils(virtual_seq)    

  function new(string name="virtual_seq");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e status;
    uvm_reg_data_t data;

    `ifdef UVM_OBJECTIONS_SVH
      // Raising one uvm_test_done objection
      uvm_test_done.raise_objection(this);
    `endif

    if (model == null && !$cast(model,super.model))
        `uvm_fatal("mem_init_from_file_seq",
            {"Must specify register model of type 'reg_sys_xa0'",
             "by assigning member 'model' before starting sequence"})

    uvm_report_info(get_type_name(), 
    $psprintf("%s body starting...", get_full_name()), UVM_LOW);

    void'(model.xbus_rf.addr_reg.randomize());
    void'(model.xbus_rf.config_reg.randomize());

    model.xbus_rf.addr_reg.update(status, .parent(this));
    model.xbus_rf.config_reg.update(status, .parent(this));

    model.xbus_rf.config_reg.mirror(status, UVM_CHECK, .parent(this));
    model.xbus_rf.addr_reg.read(status, data, .parent(this));

    `uvm_info(get_type_name(), 
      $psprintf("%s body ending...", get_sequence_path()), UVM_LOW);
    `ifdef UVM_OBJECTIONS_SVH
      // Dropping the objection
      uvm_test_done.drop_objection(this);
    `endif
  endtask

endclass : virtual_seq
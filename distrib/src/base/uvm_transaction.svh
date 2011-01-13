//
//-----------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------

typedef class uvm_event;
typedef class uvm_event_pool;
typedef class uvm_component;
    
//------------------------------------------------------------------------------
//
// CLASS: uvm_transaction
//
// The uvm_transaction class is the root base class for UVM transactions.
// Inheriting all the methods of uvm_object, uvm_transaction adds a timing and
// recording interface.
//
//------------------------------------------------------------------------------
    
virtual class uvm_transaction extends uvm_object;

  // Function: new
  //
  // Creates a new transaction object. The name is the instance name of the
  // transaction. If not supplied, then the object is unnamed.
  
  extern function new (string name="", uvm_component initiator=null);


  // Function: accept_tr
  //
  // Calling ~accept_tr~ indicates that the transaction has been accepted for
  // processing by a consumer component, such as an uvm_driver. With some
  // protocols, the transaction may not be started immediately after it is
  // accepted. For example, a bus driver may have to wait for a bus grant
  // before starting the transaction.
  //
  // This function performs the following actions:
  //
  // - The transaction's internal accept time is set to the current simulation
  //   time, or to accept_time if provided and non-zero. The ~accept_time~ may be
  //   any time, past or future.
  //
  // - The transaction's internal accept event is triggered. Any processes
  //   waiting on the this event will resume in the next delta cycle. 
  //
  // - The <do_accept_tr> method is called to allow for any post-accept
  //   action in derived classes.

  extern function void accept_tr (time accept_time=0);

  
  // Function: do_accept_tr
  //
  // This user-definable callback is called by <accept_tr> just before the accept
  // event is triggered. Implementations should call ~super.do_accept_tr~ to
  // ensure correct operation.

  extern virtual protected function void do_accept_tr ();


  // Function: begin_tr
  //
  // This function indicates that the transaction has been started and is not
  // the child of another transaction. Generally, a consumer component begins
  // execution of the transactions it receives. 
  //
  // This function performs the following actions:
  //
  // - The transaction's internal start time is set to the current simulation
  //   time, or to begin_time if provided and non-zero. The begin_time may be
  //   any time, past or future, but should not be less than the accept time.
  //
  // - If recording is enabled, then a new database-transaction is started with
  //   the same begin time as above. The record method inherited from <uvm_object>
  //   is then called, which records the current property values to this new
  //   transaction.
  //
  // - The <do_begin_tr> method is called to allow for any post-begin action in
  //   derived classes.
  //
  // - The transaction's internal begin event is triggered. Any processes
  //   waiting on this event will resume in the next delta cycle. 
  //
  // The return value is a transaction handle, which is valid (non-zero) only if
  // recording is enabled. The meaning of the handle is implementation specific.


  extern function integer begin_tr (time begin_time=0);

  
  // Function: begin_child_tr
  //
  // This function indicates that the transaction has been started as a child of
  // a parent transaction given by parent_handle. Generally, a consumer
  // component begins execution of the transactions it receives.
  //
  // The parent handle is obtained by a previous call to begin_tr or
  // begin_child_tr. If the parent_handle is invalid (=0), then this function
  // behaves the same as <begin_tr>. 
  //
  // This function performs the following actions:
  //
  // - The transaction's internal start time is set to the current simulation
  //   time, or to begin_time if provided and non-zero. The begin_time may be
  //   any time, past or future, but should not be less than the accept time.
  //
  // - If recording is enabled, then a new database-transaction is started with
  //   the same begin time as above. The record method inherited from <uvm_object>
  //   is then called, which records the current property values to this new
  //   transaction. Finally, the newly started transaction is linked to the
  //   parent transaction given by parent_handle.
  //
  // - The <do_begin_tr> method is called to allow for any post-begin
  //   action in derived classes.
  //
  // - The transaction's internal begin event is triggered. Any processes
  //   waiting on this event will resume in the next delta cycle. 
  //
  // The return value is a transaction handle, which is valid (non-zero) only if
  // recording is enabled. The meaning of the handle is implementation specific.

  extern function integer begin_child_tr (time begin_time=0, 
                                          integer parent_handle=0);


  // Function: do_begin_tr
  //
  // This user-definable callback is called by <begin_tr> and <begin_child_tr> just
  // before the begin event is triggered. Implementations should call
  // ~super.do_begin_tr~ to ensure correct operation.

  extern virtual protected function void do_begin_tr ();


  // Function: end_tr
  //
  // This function indicates that the transaction execution has ended.
  // Generally, a consumer component ends execution of the transactions it
  // receives. 
  //
  // This function performs the following actions:
  //
  // - The transaction's internal end time is set to the current simulation
  //   time, or to ~end_time~ if provided and non-zero. The ~end_time~ may be any
  //   time, past or future, but should not be less than the begin time.
  //
  // - If recording is enabled and a database-transaction is currently active,
  //   then the record method inherited from uvm_object is called, which records
  //   the final property values. The transaction is then ended. If ~free_handle~
  //   is set, the transaction is released and can no longer be linked to (if
  //   supported by the implementation).
  //
  // - The <do_end_tr> method is called to allow for any post-end
  //   action in derived classes.
  //
  // - The transaction's internal end event is triggered. Any processes waiting
  //   on this event will resume in the next delta cycle. 

  extern function void end_tr (time end_time=0, bit free_handle=1);


  // Function: do_end_tr
  //
  // This user-definable callback is called by <end_tr> just before the end event
  // is triggered. Implementations should call ~super.do_end_tr~ to ensure correct
  // operation.

  extern virtual protected function void do_end_tr ();


  // Function: get_tr_handle
  //
  // Returns the handle associated with the transaction, as set by a previous
  // call to <begin_child_tr> or <begin_tr> with transaction recording enabled.

  extern function integer get_tr_handle ();

  
  // Function: disable_recording
  //
  // Turns off recording for the transaction stream. This method does not
  // effect a <uvm_component>'s recording streams.

  extern function void disable_recording ();


  // Function: enable_recording
  //
  // Turns on recording to the stream specified by stream, whose interpretation
  // is implementation specific.
  //
  // If transaction recording is on, then a call to record is made when the
  // transaction is started and when it is ended.

  extern function void enable_recording (string stream);


  // Function: is_recording_enabled
  //
  // Returns 1 if recording is currently on, 0 otherwise.

  extern function bit is_recording_enabled();

  
  // Function: is_active
  //
  // Returns 1 if the transaction has been started but has not yet been ended.
  // Returns 0 if the transaction has not been started.

  extern function bit is_active ();


  // Function: get_event_pool
  //
  // Returns the event pool associated with this transaction. 
  //
  // By default, the event pool contains the events: begin, accept, and end.
  // Events can also be added by derivative objects. An event pool is a
  // specialization of an <uvm_pool #(T)>, e.g. a ~uvm_pool#(uvm_event)~.

  extern function uvm_event_pool get_event_pool ();


  // Function: set_initiator
  //
  // Sets initiator as the initiator of this transaction. 
  //
  // The initiator can be the component that produces the transaction. It can
  // also be the component that started the transaction. This or any other
  // usage is up to the transaction designer.

  extern function void set_initiator (uvm_component initiator);

  
  // Function: get_initiator
  //
  // Returns the component that produced or started the transaction, as set by
  // a previous call to set_initiator.

  extern function uvm_component get_initiator ();


  // Function: get_accept_time

  extern function time   get_accept_time    ();

  // Function: get_begin_time

  extern function time   get_begin_time     ();

  // Function: get_end_time
  //
  // Returns the time at which this transaction was accepted, begun, or ended, 
  // as by a previous call to <accept_tr>, <begin_tr>, <begin_child_tr>, or <end_tr>.

  extern function time   get_end_time       ();


  // Function: set_transaction_id
  //
  // Sets this transaction's numeric identifier to id. If not set via this
  // method, the transaction ID defaults to -1. 
  //
  // When using sequences to generate stimulus, the transaction ID is used along
  // with the sequence ID to route responses in sequencers and to correlate
  // responses to requests.

  extern function void set_transaction_id(integer id);


  // Function: get_transaction_id
  //
  // Returns this transaction's numeric identifier, which is -1 if not set
  // explicitly by ~set_transaction_id~.
  //
  // When using a <uvm_sequence #(REQ,RSP)> to generate stimulus, the transaction 
  // ID is used along
  // with the sequence ID to route responses in sequencers and to correlate
  // responses to requests.

  extern function integer get_transaction_id();

       
  // Variable: events
  //
  // The event pool instance for this transaction.

  const uvm_event_pool events = new;

  // Variable: begin_event
  //
  // The event that is triggered when transaction recording for this transaction
  // begins.

  uvm_event begin_event;

  // Variable: end_event
  //
  // The event that is triggered when transaction recording for this transaction
  // ends.
  
  uvm_event end_event;

  //----------------------------------------------------------------------------
  //
  // Internal methods properties; do not use directly
  //
  //----------------------------------------------------------------------------

  //Override data control methods for internal properties
  extern virtual function void do_print  (uvm_printer printer);
  extern virtual function void do_record (uvm_recorder recorder);
  extern virtual function void do_copy   (uvm_object rhs);


  extern protected function integer m_begin_tr (time    begin_time=0, 
                                                integer parent_handle=0,
                                                bit     has_parent=0);

  local integer m_transaction_id = -1;

  local time    begin_time=-1;
  local time    end_time=-1;
  local time    accept_time=-1;

  local uvm_component initiator;
  local integer       stream_handle;
  local integer       tr_handle;      
  local bit           record_enable = 0;

endclass


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------


// new
// ---

function uvm_transaction::new (string name="", 
                               uvm_component initiator = null);

  super.new(name);
  this.initiator = initiator;
  m_transaction_id = -1;
  begin_event = events.get("begin");
  end_event = events.get("end");

endfunction // uvm_transaction


// set_transaction_id
function void uvm_transaction::set_transaction_id(integer id);
    m_transaction_id = id;
endfunction

// get_transaction_id
function integer uvm_transaction::get_transaction_id();
    return (m_transaction_id);
endfunction

// set_initiator
// ------------

function void uvm_transaction::set_initiator(uvm_component initiator);
  this.initiator = initiator;
endfunction

// get_initiator
// ------------

function uvm_component uvm_transaction::get_initiator();
  return initiator;
endfunction

// get_event_pool
// --------------

function uvm_event_pool uvm_transaction::get_event_pool();
  return events;
endfunction


// is_active
// ---------

function bit uvm_transaction::is_active();
  return (tr_handle != 0);
endfunction


// get_begin_time
// --------------

function time uvm_transaction::get_begin_time ();
  return begin_time;
endfunction


// get_end_time
// ------------

function time uvm_transaction::get_end_time ();
  return end_time;
endfunction


// get_accept_time
// ---------------

function time uvm_transaction::get_accept_time ();
  return accept_time;
endfunction


// do_accept_tr
// -------------

function void uvm_transaction::do_accept_tr();
  return;
endfunction


// do_begin_tr
// ------------

function void uvm_transaction::do_begin_tr();
  return;
endfunction


// do_end_tr
// ----------

function void uvm_transaction::do_end_tr();
  return;
endfunction

// do_print
// --------

function void uvm_transaction::do_print (uvm_printer printer);
  string str;
  uvm_component tmp_initiator; //work around $swrite bug
  super.do_print(printer);
  if(accept_time != -1)
    printer.print_time("accept_time", accept_time);
  if(begin_time != -1)
    printer.print_time("begin_time", begin_time);
  if(end_time != -1)
    printer.print_time("end_time", end_time);
  if(initiator != null) begin
    tmp_initiator = initiator;
    $swrite(str,"@%0d", tmp_initiator.get_inst_id());
    printer.print_generic("initiator", initiator.get_type_name(), -1, str);
  end
endfunction

function void uvm_transaction::do_copy (uvm_object rhs);
  uvm_transaction txn;
  super.do_copy(rhs);
  if(rhs == null) return;
  if(!$cast(txn, rhs) ) return;

  accept_time = txn.accept_time;
  begin_time = txn.begin_time;
  end_time = txn.end_time;
  initiator = txn.initiator;
  stream_handle = txn.stream_handle;
  tr_handle = txn.tr_handle;
  record_enable = txn.record_enable;
endfunction  

// do_record
// ---------

function void uvm_transaction::do_record (uvm_recorder recorder);
  string s;
  super.do_record(recorder);
  if(accept_time != -1) 
     recorder.record_field("accept_time", accept_time, $bits(accept_time), UVM_TIME);
  if(initiator != null) begin
    uvm_recursion_policy_enum p = recorder.policy;
    recorder.policy = UVM_REFERENCE;
    recorder.record_object("initiator", initiator);
    recorder.policy = p;
  end
endfunction

// get_tr_handle
// ---------

function integer uvm_transaction::get_tr_handle ();
  return tr_handle;
endfunction


// disable_recording
// -----------------

function void uvm_transaction::disable_recording ();
  record_enable = 0;
endfunction


// enable_recording
// ----------------

function void uvm_transaction::enable_recording (string stream);
  string scope;
  int lastdot;
  for(lastdot=stream.len()-1; lastdot>0; --lastdot)
    if(stream[lastdot] == ".") break;

  if(lastdot) begin
    scope = stream.substr(0, lastdot-1);
    stream = stream.substr(lastdot+1, stream.len()-1);
  end
  this.stream_handle = uvm_create_fiber(stream, "TVM", scope);
  record_enable = 1;
endfunction


// is_recording_enabled
// --------------------

function bit uvm_transaction::is_recording_enabled ();
  return record_enable;
endfunction


// accept_tr
// ---------

function void uvm_transaction::accept_tr (time accept_time = 0);
  uvm_event e;

  if(accept_time != 0)
    this.accept_time = accept_time;
  else
    this.accept_time = $time;

  do_accept_tr();
  e = events.get("accept");

  if(e!=null) 
    e.trigger();
endfunction

// begin_tr
// -----------

function integer uvm_transaction::begin_tr (time begin_time=0); 
  return m_begin_tr(begin_time, 0, 0);
endfunction

// begin_child_tr
// --------------

//Use a parent handle of zero to link to the parent after begin
function integer uvm_transaction::begin_child_tr (time begin_time=0,
                                                  integer parent_handle=0); 
  return m_begin_tr(begin_time, parent_handle, 1);
endfunction

// m_begin_tr
// -----------

function integer uvm_transaction::m_begin_tr (time begin_time=0, 
                                              integer parent_handle=0, 
                                              bit has_parent=0);
  if(begin_time != 0)
    this.begin_time = begin_time;
  else
    this.begin_time = $time;
   
  // May want to establish predecessor/successor relation 
  // (don't free handle until then)
  if(record_enable) begin 

    if(uvm_check_handle_kind("Transaction", tr_handle)==1)
      end_tr(); 

    if(!has_parent)
      tr_handle = uvm_begin_transaction("Begin_No_Parent, Link", 
                    stream_handle, get_type_name(),"","",begin_time);
    else begin
      tr_handle = uvm_begin_transaction("Begin_End, Link", 
                    stream_handle, get_type_name(),"","",begin_time);
      if(parent_handle)
        uvm_link_transaction(parent_handle, tr_handle, "child");
    end

    uvm_default_recorder.tr_handle = tr_handle;
    record(uvm_default_recorder);

    if(uvm_check_handle_kind("Transaction", tr_handle)!=1)
      $display("tr handle %0d not valid!",tr_handle);

  end
  else 
    tr_handle = 0;

  do_begin_tr(); //execute callback before event trigger

  begin_event.trigger();
 
  return tr_handle;
endfunction


// end_tr
// ------

function void uvm_transaction::end_tr (time end_time=0, bit free_handle=1);

  if(end_time != 0)
    this.end_time = end_time;
  else
    this.end_time = $time;

  do_end_tr(); // Callback prior to actual ending of transaction

  if(is_active()) begin
    uvm_default_recorder.tr_handle = tr_handle;
    record(uvm_default_recorder);
  
    uvm_end_transaction(tr_handle,end_time);

    if(free_handle && uvm_check_handle_kind("Transaction", tr_handle)==1) 
    begin  
      uvm_free_transaction_handle(tr_handle);
    end
    tr_handle = 0;
  end

  end_event.trigger();
endfunction



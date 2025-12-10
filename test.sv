class test extends uvm_test;
    `uvm_component_utils(test)
    env env_handle;
    seq seq_handle;

    function new(string name="test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_handle=env::type_id::create("env_handle",this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq_handle=seq::type_id::create("seq_handle",this);
        seq_handle.start(env_handle.agent_handle.seqr_handle);
        #2;
        phase.drop_objection(this);
    endtask
endclass
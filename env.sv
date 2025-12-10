class env extends uvm_env;
    `uvm_component_utils(env)
    agent agent_handle;
    scoreboard scb_handle;

    function new(string name="env",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_handle= agent::type_id::create("agent_handle",this);
        scb_handle= scoreboard::type_id::create("scb_handle",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent_handle.monitor_handle.moni.connect(scb_handle.scb);
    endfunction

endclass
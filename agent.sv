class agent extends uvm_agent;
    `uvm_component_utils(agent)
    driver driver_handle;
    seqr seqr_handle;
    monitor monitor_handle;

    function new(string name="agent",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver_handle=driver::type_id::create("driver_handle",this);
        seqr_handle=seqr::type_id::create("seqr_handle",this);
        monitor_handle=monitor::type_id::create("monitor_handle",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver_handle.seq_item_port.connect(seqr_handle.seq_item_export);
    endfunction

endclass
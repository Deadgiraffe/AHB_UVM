class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    virtual ahb_intf vif;
    uvm_analysis_port #(seqItem) moni;
    seqItem req,temp;

    function new(string name="monitor", uvm_component parent=null);
        super.new(name,parent);
        moni=new("moni",this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual ahb_intf)::get(this,"","vif",vif)) begin
            `uvm_fatal("MONITOR","CONFIG_DB Error")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info("MONITOR","Start of Monitor",UVM_NONE)
        @(posedge vif.reset);
        forever begin
            req=seqItem::type_id::create("req");

            wait(vif.HSELx);
            @(posedge vif.clk);
            wait(vif.HTRANS && vif.HREADY);
            req.HADDR=vif.HADDR;
            
            `uvm_info("MONITOR", $sformatf("%0t Received transaction: Addr=%0h ", $time, req.HADDR), UVM_NONE)
            temp=seqItem::type_id::create("temp");
            temp.copy(req);
            fork begin
                data_phase(temp);
            end join_none
            
        end
    endtask

    task data_phase(seqItem temp);
        wait(vif.HREADY);
        @(posedge vif.clk);
        if(vif.HWRITE) begin
            temp.HWDATA=vif.HWDATA;
            temp.HWRITE=vif.HWRITE;
            `uvm_info("MONITOR", $sformatf("%0t Received transaction: Addr=%0h Data=%0h", $time, temp.HADDR, temp.HWDATA), UVM_NONE)
        end
        else begin
            temp.HWDATA=vif.HRDATA;
            temp.HWRITE=vif.HWRITE;
            `uvm_info("MONITOR", $sformatf("%0t Received transaction: Addr=%0h Data=%0h", $time, temp.HADDR, temp.HWDATA), UVM_NONE)
        end

        moni.write(temp);
    endtask
endclass
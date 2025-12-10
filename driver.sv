class driver extends uvm_driver #(seqItem);
    virtual ahb_intf vif;
    bit flag;
    seqItem temp;
    seqItem queue[$];
    int i=0;
    int j=0;
    `uvm_component_utils(driver)

    function new(string name="driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual ahb_intf)::get(this,"","vif",vif)) begin
            `uvm_fatal("DRIVER","CONFIG_DB Error")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            req.print();
            check_reset();
            perform_transaction(req);
            if(queue.size())
                perform_transaction(queue.pop_front());
            seq_item_port.item_done();
        end
        `uvm_info("DRIVER","End of Driver",UVM_NONE)
    endtask

    task check_reset();
        if(!vif.reset) begin
            vif.HSELx<=1'b0;
            vif.HADDR<=32'b0;
            vif.HWRITE<=1'b0;
            vif.HSIZE<=3'b0;
            vif.HTRANS<=2'b0;
            vif.HBURST<=2'b0;
            vif.HWDATA<=32'b0;
            wait(vif.reset);
        end
    endtask

    task perform_transaction(seqItem req);
        // Send Addr and control signals
        
        if(!i) begin
            vif.HSELx<=1'b1;
            vif.HTRANS<=2'b00;
            vif.HWRITE<=1'bx;
            i++; 
            @(posedge vif.clk);
        end
        if(!req.HWRITE && !j) begin
            @(posedge vif.clk);
            vif.HSELx<=1'b0;
            j++;
            @(posedge vif.clk);
        end

        begin : addr
        do begin 
            //@(posedge vif.clk);
            vif.HSELx<=1'b1;
            vif.HADDR<=req.HADDR;
            vif.HWRITE<=req.HWRITE;
            vif.HSIZE<=req.HSIZE;
            vif.HTRANS<=req.HTRANS;
            vif.HBURST<=req.HBURST;
            @(posedge vif.clk);
        end while(!vif.HREADY);
        end

        fork begin
            do begin
                if(vif.HRESP) begin
                    vif.HTRANS<=2'b0;
                    flag=1'b1;
                end
                if(vif.HWRITE)
                    vif.HWDATA<=req.HWDATA;
                @(posedge vif.clk);
            end while(!vif.HREADY);
            if(!flag)
                disable retry;
        end
        join_none
        fork begin
            temp=seqItem::type_id::create("temp");
            temp.copy(req);
            begin : retry
                wait(flag);
                if(flag==1'b1) begin
                    disable addr;
                    queue.push_front(req);
                    perform_transaction(temp); 
                end
                flag=1'b0;
            end
        end
        join_none  
    endtask
    
endclass




class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_analysis_imp#(seqItem,scoreboard) scb;
    bit[31:0] arr[int];

    function new(string name="scoreboard",uvm_component parent=null);
        super.new(name,parent);
        scb=new("scb",this);
    endfunction

    function void write(seqItem trans);
        `uvm_info("SCOREBOARD","Start of Scoreboard",UVM_NONE)
        if(trans.HWRITE==1'b1) begin
            arr[trans.HADDR]=trans.HWDATA;
        end
        else check_transaction(trans);
        `uvm_info("SCOREBOARD",$sformatf("arr= %p",arr),UVM_NONE)
    endfunction

    function void check_transaction(seqItem trans);
        if(arr.exists(trans.HADDR)) begin
            if(trans.HWDATA==arr[trans.HADDR])
                `uvm_info("SUCCESSFUL",$sformatf("Comparison Successful for Addr=%0p",trans.HADDR), UVM_NONE)
            else
                `uvm_error("Error Data",$sformatf("Comparison UNSuccessful for Addr=%0p, Sent Data=%0p, Received Data=%0p",trans.HADDR,arr[trans.HADDR],trans.HWDATA))
        end 
        else begin
            `uvm_error("Error Addr",$sformatf("Received Addr=%0p Not sent",trans.HADDR))
        end
    endfunction

endclass
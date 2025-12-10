`include "uvm_macros.svh"
import uvm_pkg::*;
import pkg::*;

module top;
    logic clk,reset;
    ahb_intf intf(clk, reset);
    //AHB_slave ahb_slave(intf.DUT);
    ahb_slave ahb_slave(
        .hclk(intf.clk),
        .hresetn(intf.reset),
        .hsel(intf.HSELx),
        .haddr(intf.HADDR),
        .hwrite(intf.HWRITE),
        .hsize(intf.HSIZE),
        .hburst(intf.HBURST),
        .hprot(intf.HPROT),
        .htrans(intf.HTRANS),
        .hmastlock(intf.HMASTLOCK),
        .hwdata(intf.HWDATA),

        .hready(intf.HREADY),
        .hresp(intf.HRESP),
        .hrdata(intf.HRDATA)
    );
    
    initial begin
        clk=1'b0;
        forever #1 clk=~clk;
    end

    initial begin
        run_test("test");
    end

    initial begin
        reset=1'b0;
        #10;
        @(posedge clk)
        reset=1'b1;
    end

    initial begin
        uvm_config_db#(virtual ahb_intf)::set(null,"*driver_handle","vif",intf);
        uvm_config_db#(virtual ahb_intf)::set(null,"*monitor_handle","vif",intf);
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule
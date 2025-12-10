interface ahb_intf(input logic clk,reset);
    // From Master to Arbiter
    logic HBUSREQx, HLOCKx;

    //From Arbiter to Master
    logic HGRANT;

    //Global Arbiter Signals
    logic HMASTLOCK=1'b1;
    logic[3:0] HMASTER;

    // From Master to Slave
    logic HWRITE;
    logic[2:0] HSIZE;
    logic[3:0] HPROT=4'b0000;

    //Global Master Signals(to Slave & Arbiter)
    logic[1:0] HTRANS;
    logic[2:0] HBURST;

    //Global Master Signal
    logic[31:0] HADDR;
    logic[31:0] HWDATA;

    //Global Slave Signals(to Master & Arbiter)
    logic HRESP, HREADY;
    //logic[1:0] HRESP;

    //Slave to Arbiter
    logic[15:0] HSPLITx;

    //Slave to Master    
    logic[31:0] HRDATA;

    //Decoder to Slave
    logic HSELx=1'b1;

    // modport DUT(input clk, reset, HSELx, HADDR, HWRITE, HSIZE, HTRANS, ready_in, HWDATA,
    //             output HREADY, HRESP, HRDATA);

endinterface
`include "uvm_macros.svh"
import uvm_pkg::*;
class seqItem extends uvm_sequence_item;
    //typedef baseMasterSeqItem trans;
    rand logic HBUSREQx;
    rand logic HLOCKx;
    rand logic[1:0] HTRANS;
    rand logic[31:0] HADDR;
    rand logic HWRITE;
    rand logic[2:0] HSIZE;
    rand logic[2:0] HBURST;
    rand logic[3:0] HPROT;
    rand logic[31:0] HWDATA;
    int prev_addr;
    `uvm_object_utils_begin(seqItem)
        `uvm_field_int(HBUSREQx,UVM_ALL_ON)
        `uvm_field_int(HLOCKx,UVM_ALL_ON)
        `uvm_field_int(HTRANS,UVM_ALL_ON)
        `uvm_field_int(HADDR,UVM_ALL_ON)
        `uvm_field_int(HWRITE,UVM_ALL_ON)
        `uvm_field_int(HSIZE,UVM_ALL_ON)
        `uvm_field_int(HBURST,UVM_ALL_ON)
        `uvm_field_int(HPROT,UVM_ALL_ON)
        `uvm_field_int(HWDATA,UVM_ALL_ON)
    `uvm_object_utils_end

    
    constraint c{
        HBURST==3'b011 -> HADDR==prev_addr+8;
    }
    constraint m{
        HWDATA<=8;
    }

    function void post_randomize();
        prev_addr=HADDR;
    endfunction

    function new(string name="seqItem");
        super.new(name);
    endfunction

endclass
class addr_boundary_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(addr_boundary_seq)

  function new(string name="addr_boundary_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    start_item(req);
    req.randomize() with {
      HADDR  == 32'h3FFC; // boundary
      HWRITE == 1;
      HTRANS == 2'b10;
      HBURST == 3'b011;
    };
    finish_item(req);

    repeat(3) begin
      start_item(req);
      req.randomize() with {
        HTRANS == 2'b11;
        HWRITE == 1;
      };
      finish_item(req);
    end
  endtask
endclass

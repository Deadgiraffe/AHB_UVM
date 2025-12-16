class hready_stall_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(hready_stall_seq)

  function new(string name="hready_stall_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    repeat(5) begin
      start_item(req);
      req.randomize() with {
        HWRITE == 1;
        HTRANS == 2'b10;
      };
      finish_item(req);
    end
  endtask
endclass

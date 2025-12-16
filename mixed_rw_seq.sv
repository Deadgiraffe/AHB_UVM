class mixed_rw_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(mixed_rw_seq)

  function new(string name="mixed_rw_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    repeat(8) begin
      start_item(req);
      req.randomize() with {
        HADDR  inside {[32'h300 : 32'h330]};
        HWRITE dist {1:=50, 0:=50};
        HTRANS dist {2'b10:=30, 2'b11:=70};
      };
      finish_item(req);
    end
  endtask
endclass

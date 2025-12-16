class burst_fuzz_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(burst_fuzz_seq)

  function new(string name="burst_fuzz_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    repeat(20) begin
      start_item(req);
      req.randomize() with {
        HBURST inside {3'b000,3'b001,3'b010,3'b011,3'b111};
        HTRANS inside {2'b10,2'b11};
        HWRITE dist {1:=60, 0:=40};
      };
      finish_item(req);
    end
  endtask
endclass

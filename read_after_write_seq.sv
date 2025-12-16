class raw_dependency_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(raw_dependency_seq)

  function new(string name="raw_dependency_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    // Write
    start_item(req);
    req.randomize() with {
      HADDR  == 32'h500;
      HWRITE == 1;
      HTRANS == 2'b10;
    };
    finish_item(req);

    // Read same addr
    start_item(req);
    req.randomize() with {
      HADDR  == 32'h500;
      HWRITE == 0;
      HTRANS == 2'b10;
    };
    finish_item(req);
  endtask
endclass

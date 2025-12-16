class illegal_transfer_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(illegal_transfer_seq)

  function new(string name="illegal_transfer_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    start_item(req);
    req.randomize() with {
      HTRANS == 2'b01; // BUSY (often mishandled)
      HWRITE == 1;
    };
    finish_item(req);
  endtask
endclass

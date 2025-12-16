class reset_mid_transfer_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(reset_mid_transfer_seq)

  function new(string name="reset_mid_transfer_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    // Start write burst
    start_item(req);
    req.c.constraint_mode(0);
    req.randomize() with {
      HADDR  == 32'h100;
      HWRITE == 1;
      HTRANS == 2'b10;
      HBURST == 3'b011;
    };
    finish_item(req);

    // Continue burst
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

class retry_storm_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(retry_storm_seq)

  function new(string name="retry_storm_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    repeat(15) begin
      start_item(req);
      req.randomize() with {
        HWRITE == 1;
        HTRANS == 2'b10;
      };
      finish_item(req);
    end
  endtask
endclass

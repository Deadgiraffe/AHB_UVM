class retry_stress_seq extends uvm_sequence #(seqItem);
  `uvm_object_utils(retry_stress_seq)

  function new(string name="retry_stress_seq");
    super.new(name);
  endfunction

  task body();
    req = seqItem::type_id::create("req");

    repeat(10) begin
      start_item(req);
      req.randomize() with {
        HADDR inside {[32'h200 : 32'h240]};
        HWRITE == 1;
        HTRANS == 2'b10;
        HBURST == 3'b000;
      };
      finish_item(req);
    end
  endtask
endclass

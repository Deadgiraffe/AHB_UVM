class seq extends uvm_sequence #(seqItem);
    `uvm_object_utils(seq)
    function new(string name="seq");
        super.new(name);
    endfunction

    task body;
        req=seqItem::type_id::create("req");
        `uvm_info("SEQUENCE","Start of Sequence",UVM_NONE)
        begin
            start_item(req);
            req.c.constraint_mode(0);
            if(!req.randomize() with {HADDR==32'h0;HBURST==3'b011; HTRANS==2'b10; HWRITE==1'b1; HSIZE==3'b0;}) begin
                `uvm_fatal("SEQUENCE","RF")
            end
            else begin
                req.print();
            end
            finish_item(req);
            repeat(3) begin
                start_item(req);
                req.c.constraint_mode(1);
                if(!req.randomize() with {HBURST==3'b011; HTRANS==2'b11; HWRITE==1'b1; HSIZE==3'b0;}) begin
                    `uvm_fatal("SEQUENCE","RF")
                end
                else begin
                    req.print();
                end
                finish_item(req);
            end

            //read
            start_item(req);
            req.m.constraint_mode(0);
            req.c.constraint_mode(0);
            if(!req.randomize() with {HADDR==32'h0;HBURST==3'b011; HTRANS==2'b10; HWRITE==1'b0; HSIZE==3'b0;}) begin
                `uvm_fatal("SEQUENCE","RF")
            end
            else begin
                req.print();
            end
            finish_item(req);
            repeat(3) begin
                start_item(req);
                req.m.constraint_mode(0);
                req.c.constraint_mode(1);
                if(!req.randomize() with {HBURST==3'b011; HTRANS==2'b11; HWRITE==1'b0; HSIZE==3'b0;}) begin
                    `uvm_fatal("SEQUENCE","RF")
                end
                else begin
                    req.print();
                end
                finish_item(req);
            end
            `uvm_info("SEQUENCE","End of Sequence",UVM_NONE)
            
        end
    endtask


endclass
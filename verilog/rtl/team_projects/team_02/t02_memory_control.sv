module t02_memory_control
(
    input logic CLK, nRST, dmmRen, dmmWen, imemRen, busy_o,
    input logic [31:0] imemaddr, dmmaddr, dmmstore, ramload,
    output logic i_ready, d_ready, Ren, Wen, 
    output logic [31:0] ramaddr, ramstore, imemload, dmmload
);
logic [31:0] prev_dmmaddr, prev_dmmstore, prev_imemload;
logic d_wait, i_wait;

always_ff@(posedge CLK, negedge nRST) begin
    if(!nRST) begin
        prev_dmmaddr <= 32'b0;
        prev_dmmstore <= 32'b0;
        prev_imemload <= 32'b0;
    end
    else begin
        prev_dmmaddr <= dmmaddr; 
        prev_dmmstore <= dmmstore;
        prev_imemload <= imemload; 
    end
end
always_comb begin
    ramaddr = 0; 
    Ren = 0; 
    Wen = 0;
    ramstore = 0;
    imemload = 0; 
    dmmload = 0;
    i_wait = 1;
    d_wait = 1;

    

    if(dmmRen) begin
        ramaddr = prev_dmmaddr;
        Ren = dmmRen;
        dmmload = ramload;
        d_wait = busy_o;
    end
    else if (dmmWen) begin
        ramaddr = prev_dmmaddr; 
        Wen = dmmWen; 
        ramstore = prev_dmmstore;
        d_wait = busy_o;
    end
    else if(imemRen) begin
        ramaddr = imemaddr;
        Ren = imemRen; 
        imemload = ramload;
        i_wait = busy_o;
    end
    else begin
        Ren = 0;
        Wen = 0; 
    end

    if(i_wait) begin
        imemload = prev_imemload;
    end
end
assign i_ready = imemRen & ~i_wait; 
assign d_ready = (dmmRen | dmmWen) & ~d_wait;

endmodule


module t03_pc(
    input logic en, i_request, 
    output logic [31:0] pc_out,
    output logic [31:0] pc_add_out,
    input logic [31:0] generated_immediate,
    input logic branch_decision,
    input logic [31:0] pc_write_value,
    input logic pc_add_write_value,
    input logic in_en,
    input logic auipc_in,
    input logic clock,
    input logic reset
);

reg [31:0] current_pc;
logic [31:0] next_pc;
logic [31:0] pc_add_4;
logic [31:0] pc_add_immediate;

always_comb begin
    pc_add_immediate = (pc_add_write_value ? pc_write_value : current_pc) + generated_immediate; //pc_add_immediate is true for AUIPC and JALR
    pc_add_4 = (current_pc + 4); //next instruction location
end

assign pc_add_out = auipc_in ? pc_add_immediate : pc_add_4; //AUIPC decision


always_comb begin
    next_pc = current_pc;
    if(in_en && i_request) begin //if PC is enabled
        next_pc = branch_decision ? pc_add_immediate : pc_add_4; //if branch or jump, then branch, else next instruction
    end
end

always_ff @(posedge clock, posedge reset) begin
    if(reset) begin
        current_pc <= 32'h0;// h33000000; //placeholder constant for initialization
    end
    else if (en) begin
        current_pc <= next_pc;
    end

end
assign pc_out = current_pc;

endmodule
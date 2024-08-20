module t03_pc (
	en,
	i_request,
	pc_out,
	pc_add_out,
	generated_immediate,
	branch_decision,
	pc_write_value,
	pc_add_write_value,
	in_en,
	auipc_in,
	clock,
	reset
);
	reg _sv2v_0;
	input wire en;
	input wire i_request;
	output wire [31:0] pc_out;
	output wire [31:0] pc_add_out;
	input wire [31:0] generated_immediate;
	input wire branch_decision;
	input wire [31:0] pc_write_value;
	input wire pc_add_write_value;
	input wire in_en;
	input wire auipc_in;
	input wire clock;
	input wire reset;
	reg [31:0] current_pc;
	reg [31:0] next_pc;
	reg [31:0] pc_add_4;
	reg [31:0] pc_add_immediate;
	always @(*) begin
		if (_sv2v_0)
			;
		pc_add_immediate = (pc_add_write_value ? pc_write_value : current_pc) + generated_immediate;
		pc_add_4 = current_pc + 4;
	end
	assign pc_add_out = (auipc_in ? pc_add_immediate : pc_add_4);
	always @(*) begin
		if (_sv2v_0)
			;
		next_pc = current_pc;
		if (in_en && i_request)
			next_pc = (branch_decision ? pc_add_immediate : pc_add_4);
	end
	always @(posedge clock or posedge reset)
		if (reset)
			current_pc <= 32'h00000000;
		else if (en)
			current_pc <= next_pc;
	assign pc_out = current_pc;
	initial _sv2v_0 = 0;
endmodule

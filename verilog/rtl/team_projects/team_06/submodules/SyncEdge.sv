/* 
  Module Name: SyncEdge
  Module Function/Purpose: Synchronizer and Edge Detector for each of the four button inputs
  Module Inputs: button input (1 bit), clk, reset
  Module Outputs: direction(on or off)

  Best Commenting Practices (to make debugging easier):
    1) Explain what each block of logic does.
    2) Explain what each input and output represents and what its values represent.

  Best Coding Practices (to make debugging easier):
    1) Assign outputs using always_ff blocks whenever possible.
    2) Use enable variables for blocks that can be used to change game modes.

*/ 
module syncEdge(
    input logic clk, nreset, 
    input logic but,
    output logic direction
);
    logic out1;
    sync sync1 (.in(but), .clk(clk), .nrst(nreset), .out(out1));
    edgeDetect eD1 (.D(out1), .clk(clk), .nrst(nreset), .edg(direction));
endmodule

module sync(
        input logic in, 
        input logic clk, nrst,
        output logic out
    );
        logic Q, Q1, Q_n, Q1_n;

        always_comb begin
            Q_n = in;
            Q1_n = Q; 
        end
        
        always_ff @(posedge clk, negedge nrst) begin
            if (~nrst)begin
                Q <= 1'b0;
                Q1 <= 1'b0;
            end else begin
                Q <= Q_n;
                Q1 <= Q1_n;
            end
        end
        
        always_comb begin
            out = Q1;
        end
endmodule 

module edgeDetect(
    input logic D,
    input logic clk, nrst,
    output logic edg
);
    logic Q1, Q2, Q1_n, Q2_n;

    always_comb begin
            Q1_n = D;
            Q2_n = Q1; 
        end
        
        always_ff @(posedge clk, negedge nrst) begin
            if (~nrst)begin
                Q1 <= 1'b0;
                Q2 <= 1'b0;
            end else begin
                Q1 <= Q1_n;
                Q2 <= Q2_n;
            end
        end
        
        always_comb begin
            edg = Q1 & ~Q2;
        end
endmodule


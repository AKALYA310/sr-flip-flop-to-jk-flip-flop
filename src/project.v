

`default_nettype none

module tt_um_sr flip flop to jk flip flop (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IO inputs
    output wire [7:0] uio_out,  // IO outputs
    output wire [7:0] uio_oe,   // IO direction
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // J and K inputs
    wire J = ui_in[0];
    wire K = ui_in[1];

    // Flip-flop output
    reg Q;

    // JK Flip-Flop Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= 1'b0;
        else begin
            case ({J, K})
                2'b00: Q <= Q;      // Hold
                2'b01: Q <= 1'b0;   // Reset
                2'b10: Q <= 1'b1;   // Set
                2'b11: Q <= ~Q;     // Toggle
            endcase
        end
    end

    // Output assignments
    assign uo_out[0] = Q;
    assign uo_out[1] = ~Q;

    // Remaining outputs unused
    assign uo_out[7:2] = 6'b0;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Prevent warnings for unused signals
    wire _unused = &{ena, uio_in, ui_in[7:2], 1'b0};

endmodule

`default_nettype wire

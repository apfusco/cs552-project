/*
* Logic for detecting when to stall in the pipelined processor. 
*/
module stall(
        // outputs
        ex_mem_stall,
        err,
        // inputs
        ex_mem_mem_en,
        ex_mem_mem_wr,
        ex_mem_Rd,
        id_ex_Rs,
        id_ex_Rt,
        id_ex_has_Rt);

    output      ex_mem_stall;
    output      err;

    input       ex_mem_mem_en;
    input       ex_mem_mem_wr;
    input [2:0] ex_mem_Rd;
    input [2:0] id_ex_Rs;
    input [2:0] id_ex_Rt;
    input       id_ex_has_Rt;

    assign err = 1'b0;
    //assign err = (^{ex_mem_mem_en,
    //                ex_mem_mem_wr,
    //                ex_mem_Rd,
    //                id_ex_Rs,
    //                id_ex_Rt,
    //                id_ex_has_Rt
    //                } === 1'bX) ? 1'b1 : 1'b0;

    wire ex_mem_mem_rd;

    assign ex_mem_mem_rd = ~ex_mem_mem_wr;

    // TODO: add logic for determining if Rs/Rt exist or not
    // could accomplish this using the opcode as an input...
        // ex branches have no Rt, and jumps has nether Rs nor Rt
    
    // stall if there is a mem read and either one of the operands in the curr
    // instruction rely upon the prior insruction's result from a read
        // d/e_mem_rd & (d/e_Rt == f/d_Rs | d/e_Rt == f/d_Rt)
    assign ex_mem_stall = ex_mem_mem_en & ex_mem_mem_rd & (
        ~|(ex_mem_Rd ^ id_ex_Rs) | (
            ~|(ex_mem_Rd ^ id_ex_Rt) & id_ex_has_Rt));

endmodule

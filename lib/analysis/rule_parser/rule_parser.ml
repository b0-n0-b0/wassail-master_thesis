open Core
open Helpers
let debug_print (fidx : Int32.t) (instr : unit Instr.t) : unit =
  Printf.printf "Processing instruction in function %d: %s\n"
    fidx (Instr.to_string instr);
  flush stdout

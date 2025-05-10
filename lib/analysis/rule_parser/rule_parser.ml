open Core
open Helpers
let debug_print (fidx : int32) (instr : unit Instr.t) : unit =
  Printf.printf "Processing instruction in function %d: %s\n"
    fid (Instr.to_string instr);
  flush stdout

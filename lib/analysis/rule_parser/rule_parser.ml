open Core
open Helpers

(* for now we suppose to have a parsed rule structure *)
let rec flatten_instrs (instrs : unit Instr.t list) : unit Instr.t list =
  List.concat_map instrs ~f:(fun instr ->
    match instr with
    | Control c -> begin
        match c.instr with
        | Block (_bt, _, inner_instrs) ->
            instr :: flatten_instrs inner_instrs
        | Loop (_bt, _, inner_instrs) ->
            instr :: flatten_instrs inner_instrs
        | If (_bt, _, then_instrs, else_instrs) ->
            instr :: (flatten_instrs then_instrs @ flatten_instrs else_instrs)
        | _ ->
            [instr]
      end
    | _ ->
        [instr]
  )
;;

(** applies the specified rule  *)
let search_specific_instruction (wasm_mod : Wasm_module.t) (rules : string) : unit = 
  List.iter wasm_mod.funcs ~f:(fun func ->
    let rules_array = String.split_on_chars rules [','] in
    List.iteri rules_array  ~f:(fun ridx rule -> 
      (* Printf.printf "__________rule %d__________\n" ridx; *)
      let flat_instrs = flatten_instrs func.code.body in
      List.iteri flat_instrs ~f:(fun idx instr ->
        if String.equal (Instr.to_mnemonic instr) rule then
            Printf.printf "%d|%d,%d\n" ridx (Option.value_exn (Int32.to_int func.idx) - Option.value_exn (Int32.to_int wasm_mod.nfuncimports)) idx
        )  
    )

  )
;;

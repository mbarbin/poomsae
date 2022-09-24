open! Core

let%expect_test "names" =
  let module Row = struct
    type t =
      { number : int
      ; name : string
      ; movements : int
      }
  end
  in
  let columns =
    Ascii_table.Column.
      [ create_attr ~align:Right "Number" (fun (t : Row.t) -> [], Int.to_string t.number)
      ; create_attr "Name" (fun (t : Row.t) -> [], t.name)
      ; create_attr ~align:Right "# Movements" (fun (t : Row.t) ->
          [], Int.to_string t.movements)
      ]
  in
  let rows =
    List.mapi Poomse.all ~f:(fun i t ->
      { Row.number = i + 1
      ; name = Poomse.name t
      ; movements = List.length (Poomse.movements t)
      })
  in
  Ascii_table.to_string columns rows |> print_endline;
  [%expect
    {|
    ┌────────┬──────────────────┬─────────────┐
    │ Number │ Name             │ # Movements │
    ├────────┼──────────────────┼─────────────┤
    │      1 │ TAE GEUG IL JANG │          16 │
    └────────┴──────────────────┴─────────────┘ |}]
;;

let%expect_test "displacement_returns_to_origin" =
  (* We test that the function is capable of returning (Error _). The
     case (Ok ()) is tested as part of each poomse analysis in their
     respective files. *)
  let poomse =
    Poomse.create
      ~name:"BOGUS"
      [ { direction = North
        ; position = Ap_Seugui { front_foot = Left }
        ; technique = Block (Maki { hand = Left; level = Ale })
        }
      ; { direction = North
        ; position = Ap_Koubi_Seugui { front_foot = Right }
        ; technique = Block (Maki { hand = Left; level = Ale })
        }
      ; { direction = West
        ; position = Ap_Seugui { front_foot = Left }
        ; technique = Block (Maki { hand = Left; level = Ale })
        }
      ]
  in
  print_s [%sexp (Poomse.displacement_returns_to_origin poomse : unit Or_error.t)];
  [%expect
    {|
    (Error
     ("Poomse displacement does not return to origin" BOGUS
      ((displacement
        ((north ((ap_seugui 1) (ap_koubi_seugui 1)))
         (west ((ap_seugui 1) (ap_koubi_seugui 0)))
         (east ((ap_seugui 0) (ap_koubi_seugui 0)))
         (south ((ap_seugui 0) (ap_koubi_seugui 0)))))))) |}]
;;

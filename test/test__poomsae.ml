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
    List.mapi Poomsae.all ~f:(fun i t ->
      { Row.number = i + 1
      ; name = Poomsae.name t
      ; movements = List.length (Poomsae.movements t)
      })
  in
  Ascii_table.to_string columns rows |> print_endline;
  [%expect
    {|
    ┌────────┬─────────────────────┬─────────────┐
    │ Number │ Name                │ # Movements │
    ├────────┼─────────────────────┼─────────────┤
    │      1 │ TAE GEUG IL JANG    │          16 │
    │      2 │ TAE GEUG YI JANG    │          18 │
    │      3 │ TAE GEUG SAM JANG   │          20 │
    │      4 │ TAE GEUG SA JANG    │          17 │
    │      5 │ TAE GEUG OH JANG    │          20 │
    │      6 │ TAE GEUG YOUK JANG  │          21 │
    │      7 │ TAE GEUG TCHIL JANG │          11 │
    │      8 │ TAE GEUG PAL JANG   │           0 │
    └────────┴─────────────────────┴─────────────┘ |}]
;;

let%expect_test "displacement_returns_to_origin" =
  (* We test that the function is capable of returning (Error _). The
     case (Ok ()) is tested as part of each poomsae analysis in their
     respective files. *)
  let poomsae =
    Poomsae.create
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
  print_s [%sexp (Poomsae.displacement_returns_to_origin poomsae : unit Or_error.t)];
  [%expect
    {|
    (Error
     ("Poomsae displacement does not return to origin" BOGUS
      ((displacement
        ((north
          ((ap_seugui 1) (ap_koubi_seugui 1) (dwitt_koubi 0)
           (wen_or_oren_seugui 0) (dwitt_koa 0) (beum_seugui 0)))
         (west
          ((ap_seugui 1) (ap_koubi_seugui 0) (dwitt_koubi 0)
           (wen_or_oren_seugui 0) (dwitt_koa 0) (beum_seugui 0)))
         (east
          ((ap_seugui 0) (ap_koubi_seugui 0) (dwitt_koubi 0)
           (wen_or_oren_seugui 0) (dwitt_koa 0) (beum_seugui 0)))
         (south
          ((ap_seugui 0) (ap_koubi_seugui 0) (dwitt_koubi 0)
           (wen_or_oren_seugui 0) (dwitt_koa 0) (beum_seugui 0)))))))) |}]
;;

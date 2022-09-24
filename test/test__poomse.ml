open! Core

let%expect_test "names" =
  let module Row = struct
    type t =
      { number : int
      ; name : string
      }
  end
  in
  let columns =
    Ascii_table.Column.
      [ create_attr ~align:Right "Number" (fun (t : Row.t) -> [], Int.to_string t.number)
      ; create_attr "Name" (fun (t : Row.t) -> [], t.name)
      ]
  in
  let rows =
    List.mapi Poomse.all ~f:(fun i t -> { Row.number = i + 1; name = Poomse.name t })
  in
  Ascii_table.to_string columns rows |> print_endline;
  [%expect
    {|
    ┌────────┬──────────────────┐
    │ Number │ Name             │
    ├────────┼──────────────────┤
    │      1 │ TAE GEUG IL JANG │
    └────────┴──────────────────┘ |}]
;;

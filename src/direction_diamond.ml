open! Base

module T = struct
  type 'a t =
    { north : 'a
    ; west : 'a
    ; east : 'a
    ; south : 'a
    }
  [@@deriving equal, compare, enumerate, fields, hash, sexp_of]

  let map t ~f =
    let f field = f (Field.get field t) in
    Fields.map ~north:f ~west:f ~east:f ~south:f
  ;;
end

include T

let singleton a = { north = a; west = a; east = a; south = a }

include Applicative.Make (struct
    type nonrec 'a t = 'a t

    let return = singleton

    let apply f x =
      { north = f.north x.north
      ; west = f.west x.west
      ; east = f.east x.east
      ; south = f.south x.south
      }
    ;;

    let map = `Custom map
  end)

include Container.Make (struct
    type nonrec 'a t = 'a t

    let length = `Custom (fun _ -> 4)

    let fold t ~init ~f =
      let f acc field = f acc (Field.get field t) in
      Fields.fold ~init ~north:f ~west:f ~east:f ~south:f
    ;;

    let iter =
      `Custom
        (fun t ~f ->
          let f field = f (Field.get field t) in
          Fields.iter ~north:f ~west:f ~east:f ~south:f)
    ;;
  end)

let field : Direction.t -> _ = function
  | North -> Fields.north
  | West -> Fields.west
  | East -> Fields.east
  | South -> Fields.south
;;

let get t direction = Field.get (field direction) t

let map_direction t ~f =
  let f (direction : Direction.t) field = f direction (Field.get field t) in
  Fields.map ~north:(f North) ~west:(f West) ~east:(f East) ~south:(f South)
;;

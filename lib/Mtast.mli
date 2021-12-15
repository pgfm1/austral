(** The monomorphic AST. *)
open Identifier
open Common
open Escape
open MonoType

(** Represents a module where all types and functions have been monomorphized. *)
type mono_module = MonoModule of module_name * mtyped_decl list

(** Declarations in a monomorphic module. *)
and mtyped_decl =
  | MConstant of identifier * mono_ty * mexpr
  | MRecord of identifier * mtyped_slot list
  | MUnion of identifier * mtyped_case list
  | MFunction of identifier * mvalue_parameter list * mono_ty * mstmt
  | MForeignFunction of identifier * mvalue_parameter list * mono_ty * string

(** Monomorphic statements. *)
and mstmt =
  | MSkip
  | MLet of identifier * mono_ty * mexpr * mstmt
  | MDestructure of (identifier * mono_ty) list * mexpr * mstmt
  | MAssign of mtyped_lvalue * mexpr
  | MIf of mexpr * mstmt * mstmt
  | MCase of mexpr * mtyped_when list
  | MWhile of mexpr * mstmt
  | MFor of identifier * mexpr * mexpr * mstmt
  | MBorrow of {
      original: identifier;
      rename: identifier;
      region: identifier;
      orig_type: mono_ty;
      ref_type: mono_ty;
      body: mstmt;
      mode: borrowing_mode
    }
  | MBlock of mstmt * mstmt
  | MDiscarding of mexpr
  | MReturn of mexpr

(** Monomorphic expressions. *)
and mexpr =
  | MNilConstant
  | MBoolConstant of bool
  | MIntConstant of string
  | MFloatConstant of string
  | MStringConstant of escaped_string
  | MVariable of qident * mono_ty
  | MArithmetic of arithmetic_operator * mexpr * mexpr
  | MConcreteFuncall of qident * mexpr list * mono_ty
  | MGenericFuncall of mono_id * mexpr list * mono_ty
  | MCast of mexpr * mono_ty
  | MComparison of comparison_operator * mexpr * mexpr
  | MConjunction of mexpr * mexpr
  | MDisjunction of mexpr * mexpr
  | MNegation of mexpr
  | MIfExpression of mexpr * mexpr * mexpr
  | MRecordConstructor of mono_ty * (identifier * mexpr) list
  | MUnionConstructor of mono_ty * identifier * (identifier * mexpr) list
  | MTypeAliasConstructor of mono_ty * mexpr
  | MPath of {
      head: mexpr;
      elems: mtyped_path_elem list;
      ty: mono_ty
    }
  | MEmbed of mono_ty * string * mexpr list
  | MDeref of mexpr
  | MTypecast of mexpr * mono_ty
  | MSizeOf of mono_ty

and mtyped_when =
  MTypedWhen of identifier * mvalue_parameter list * mstmt

and mtyped_path_elem =
  | MSlotAccessor of identifier * mono_ty
  | MPointerSlotAccessor of identifier * mono_ty
  | MArrayIndex of mexpr * mono_ty

and mtyped_lvalue =
  MTypedLValue of identifier * mtyped_path_elem list

and mvalue_parameter =
  MValueParameter of identifier * mono_ty

and mtyped_slot =
  MTypedSlot of identifier * mono_ty

and mtyped_case =
  MTypedCase of identifier * mtyped_slot list
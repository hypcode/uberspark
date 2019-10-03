type usbinformat_section_info_t = {
  f_type : int;
  f_prot : int;
  f_size : int;
  f_aligned_at : int;
  f_pad_to : int;
  f_addr_start : int;
  f_addr_file : int;
  f_reserved : int;
}
type target_def_t = {
  mutable f_platform : string;
  mutable f_arch : string;
  mutable f_cpu : string;
}
type section_info_t = {
  f_name : string;
  f_subsection_list : string list;
  usbinformat : usbinformat_section_info_t;
}
type uobjcoll_sentineltypes_t = { s_type : string; s_type_id : string; }
type uobjcoll_exitcallee_t = {
  s_retvaldecl : string;
  s_fname : string;
  s_fparamdecl : string;
  s_fparamdwords : int;
}

(* TBA: basedefs *)
val binary_uobj_publicmethod_max_length : int ref
val binary_uobj_max_publicmethods : int ref
val binary_uobj_namespace_max_length : int ref
val binary_uobj_max_intrauobjcoll_callees : int ref
val binary_uobj_max_interuobjcoll_callees : int ref

(* TBA: basedefs *)
val def_USBINFORMAT_SECTION_TYPE_PADDING : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ : int
val def_USBINFORMAT_SECTION_TYPE_UOBJCOLL_ENTRYSENTINEL : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_RESUMESENTINEL : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_CALLEESENTINEL : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_EXITCALLEESENTINEL : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_HDR : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_RODATA : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACKTOS : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACKTOS : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA : int

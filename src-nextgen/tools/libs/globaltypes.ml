(*
	uberSpark global type definitions
	author: amit vasudevan (amitvasudevan@acm.org)
*)


		(* from usbinformat.h *)
		type usbinformat_section_info_t =
			{
				f_type         : int;			
				f_prot         : int;			
				f_size         : int;
        f_aligned_at   : int;
	      f_pad_to       : int;
				f_addr_start   : int;
				f_addr_file    : int;
        f_reserved     : int; 
			};;


		(* local type definitions *)
		type target_def_t = 
			{
				mutable f_platform: string;
				mutable f_arch : string;
				mutable f_cpu : string;
			};;
		

		type section_info_t = 
			{
				f_name: string;
				f_subsection_list : string list;
				usbinformat : usbinformat_section_info_t;
			};;

			


		type uobjcoll_sentineltypes_t = 
			{
				s_type: string;
				s_type_id : string;
			};;

		type uobjcoll_exitcallee_t = 
			{
				s_retvaldecl : string;
				s_fname: string;
				s_fparamdecl: string;
				s_fparamdwords : int;
			};;
				

	(* TBA: basedefs *)
	let binary_uobj_publicmethod_max_length = ref 128;;
	let binary_uobj_max_publicmethods = ref 16;;
	let binary_uobj_namespace_max_length = ref 256;;
	let binary_uobj_max_intrauobjcoll_callees = ref 16;;
	let binary_uobj_max_interuobjcoll_callees = ref 16;;


	(*TBA: basedefs *)
	(*--------------------------------------------------------------------------*)
	(* usbinformat.h constant defs; c.f. include/usbinformat.h for binary definitions *)
	(*--------------------------------------------------------------------------*)
	let def_USBINFORMAT_SECTION_TYPE_PADDING = 0x0;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ =	0x1;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJCOLL_ENTRYSENTINEL = 0x2;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_RESUMESENTINEL = 0x3;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_CALLEESENTINEL = 0x4;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_EXITCALLEESENTINEL = 0x5;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_HDR =	0x6;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE = 0x7;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA = 0x8;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_RODATA = 0x9;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK = 0xa;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK = 0xb;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACKTOS = 0xc;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACKTOS = 0xd;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA = 0xe;;

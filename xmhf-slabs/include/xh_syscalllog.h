/*
 * @XMHF_LICENSE_HEADER_START@
 *
 * eXtensible, Modular Hypervisor Framework (XMHF)
 * Copyright (c) 2009-2012 Carnegie Mellon University
 * Copyright (c) 2010-2012 VDG Inc.
 * All Rights Reserved.
 *
 * Developed by: XMHF Team
 *               Carnegie Mellon University / CyLab
 *               VDG Inc.
 *               http://xmhf.org
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the names of Carnegie Mellon or VDG Inc, nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 * THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * @XMHF_LICENSE_HEADER_END@
 */


/*
 *
 *  syscalllog hypapp slab decls.
 *
 *  author: amit vasudevan (amitvasudevan@acm.org)
 */

#ifndef __XH_SYSCALLLOG_H__
#define __XH_SYSCALLLOG_H__

#define SYSCALLLOG_REGISTER     			0xF0


#ifndef __ASSEMBLY__


extern __attribute__((section(".data"))) bool sl_activated;
extern __attribute__((section(".data"))) bool _sl_registered;

extern __attribute__((section(".data"))) u8 _sl_pagebuffer[PAGE_SIZE_4K];
extern __attribute__((section(".data"))) u8 _sl_syscalldigest[SHA_DIGEST_LENGTH];
extern __attribute__((section(".data"))) u64 shadow_sysenter_rip;



void sysclog_hcbhypercall(u32 cpuindex, u32 guest_slab_index);
void sysclog_hcbinit(u32 cpuindex);
u32 sysclog_hcbinsntrap(u32 cpuindex, u32 guest_slab_index, u32 insntype);
void sysclog_hcbmemfault(u32 cpuindex, u32 guest_slab_index);
void sysclog_hcbshutdown(u32 cpuindex, u32 guest_slab_index);

//void sysclog_register(u32 cpuindex, u32 guest_slab_index, u64 gpa);
void sysclog_register(u32 cpuindex, u32 guest_slab_index, u32 syscall_page_paddr, u32 syscall_shadowpage_paddr);
void sysclog_loginfo(u32 cpuindex, u32 guest_slab_index, u64 gpa, u64 gva, u64 errorcode);








#endif	//__ASSEMBLY__

#endif //__XH_SYSCALLLOG_H__

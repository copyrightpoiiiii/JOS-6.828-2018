// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;

	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if (! ( (err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
		panic("Neither the fault is a write nor COW page. \n");

	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	if(sys_page_alloc(sys_getenvid(),(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
		panic("pgfault error:page allocation\n");
	addr = ROUNDDOWN(addr,PGSIZE);
	memcpy((void *)PFTEMP,(const void*)addr,PGSIZE);
	if(sys_page_map(sys_getenvid(),(void *)PFTEMP,sys_getenvid(),addr,PTE_P|PTE_W|PTE_U)<0)
		panic("pgfault error:page map file\n");
	if(sys_page_unmap(sys_getenvid(),(void *)PFTEMP)<0)
		panic("pgfault error:page unmap error\n");

	//panic("pgfault not implemented");
}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.

	pte_t *pte;
	uint32_t va = pn * PGSIZE;

	if (uvpt[pn] & PTE_SHARE) {
		if((r = sys_page_map(thisenv->env_id, (void *) va, envid, (void * )va, uvpt[pn] & PTE_SYSCALL)) <0 ) 
			return r;
	}
	else if ( (uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
		if ((r = sys_page_map(thisenv->env_id, (void *) va, envid, (void *) va, PTE_P|PTE_U|PTE_COW)) < 0)
			return r;
		if ((r = sys_page_map(thisenv->env_id, (void *)va, thisenv->env_id, (void *)va, PTE_P|PTE_U|PTE_COW)) < 0)
			return r;
	}
	else {
		if((r = sys_page_map(thisenv->env_id, (void *) va, envid, (void * )va, PTE_P|PTE_U)) <0 ) 
			return r;
	}


	//panic("duppage not implemented");
	return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	
	envid_t envid;
	int r;
	set_pgfault_handler(pgfault);
	envid = sys_exofork();
	if(envid<0)
		panic("sys_exofork fail\n");
	else if(envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(int i=PGNUM(UTEXT);i<PGNUM(USTACKTOP);i++)
		if((uvpd[i>>10]&PTE_P)&&(uvpt[i]&PTE_P)){
			if((r = duppage(envid,i))<0)
				return r;
		}
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
        return r;
	extern void _pgfault_upcall(void);
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
		return r;
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	
	return envid;
	//panic("fork not implemented");
}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}

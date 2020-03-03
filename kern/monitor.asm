
obj/kern/monitor.o：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
   6:	68 00 00 00 00       	push   $0x0
   b:	68 1e 00 00 00       	push   $0x1e
  10:	68 23 00 00 00       	push   $0x23
  15:	e8 fc ff ff ff       	call   16 <mon_help+0x16>
  1a:	83 c4 0c             	add    $0xc,%esp
  1d:	68 00 00 00 00       	push   $0x0
  22:	68 2c 00 00 00       	push   $0x2c
  27:	68 23 00 00 00       	push   $0x23
  2c:	e8 fc ff ff ff       	call   2d <mon_help+0x2d>
	return 0;
}
  31:	b8 00 00 00 00       	mov    $0x0,%eax
  36:	c9                   	leave  
  37:	c3                   	ret    

00000038 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
  38:	55                   	push   %ebp
  39:	89 e5                	mov    %esp,%ebp
  3b:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
  3e:	68 35 00 00 00       	push   $0x35
  43:	e8 fc ff ff ff       	call   44 <mon_kerninfo+0xc>
	cprintf("  _start                  %08x (phys)\n", _start);
  48:	83 c4 08             	add    $0x8,%esp
  4b:	68 00 00 00 00       	push   $0x0
  50:	68 28 00 00 00       	push   $0x28
  55:	e8 fc ff ff ff       	call   56 <mon_kerninfo+0x1e>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
  5a:	83 c4 0c             	add    $0xc,%esp
  5d:	68 00 00 00 10       	push   $0x10000000
  62:	68 00 00 00 00       	push   $0x0
  67:	68 50 00 00 00       	push   $0x50
  6c:	e8 fc ff ff ff       	call   6d <mon_kerninfo+0x35>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
  71:	83 c4 0c             	add    $0xc,%esp
  74:	68 00 00 00 10       	push   $0x10000000
  79:	68 00 00 00 00       	push   $0x0
  7e:	68 74 00 00 00       	push   $0x74
  83:	e8 fc ff ff ff       	call   84 <mon_kerninfo+0x4c>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
  88:	83 c4 0c             	add    $0xc,%esp
  8b:	68 00 00 00 10       	push   $0x10000000
  90:	68 00 00 00 00       	push   $0x0
  95:	68 98 00 00 00       	push   $0x98
  9a:	e8 fc ff ff ff       	call   9b <mon_kerninfo+0x63>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
  9f:	83 c4 0c             	add    $0xc,%esp
  a2:	68 00 00 00 10       	push   $0x10000000
  a7:	68 00 00 00 00       	push   $0x0
  ac:	68 bc 00 00 00       	push   $0xbc
  b1:	e8 fc ff ff ff       	call   b2 <mon_kerninfo+0x7a>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
  b6:	b8 ff 03 00 00       	mov    $0x3ff,%eax
  bb:	2d 00 00 00 00       	sub    $0x0,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
  c0:	83 c4 08             	add    $0x8,%esp
  c3:	25 00 fc ff ff       	and    $0xfffffc00,%eax
  c8:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  ce:	85 c0                	test   %eax,%eax
  d0:	0f 48 c2             	cmovs  %edx,%eax
  d3:	c1 f8 0a             	sar    $0xa,%eax
  d6:	50                   	push   %eax
  d7:	68 e0 00 00 00       	push   $0xe0
  dc:	e8 fc ff ff ff       	call   dd <mon_kerninfo+0xa5>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
  e1:	b8 00 00 00 00       	mov    $0x0,%eax
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	83 ec 08             	sub    $0x8,%esp
	// Your code here.

	int x = 1, y = 3, z = 4;
	cprintf("x %d, y %x, z %d\n", x, y, z);
  ee:	6a 04                	push   $0x4
  f0:	6a 03                	push   $0x3
  f2:	6a 01                	push   $0x1
  f4:	68 4e 00 00 00       	push   $0x4e
  f9:	e8 fc ff ff ff       	call   fa <mon_backtrace+0x12>

	return 0;
}
  fe:	b8 00 00 00 00       	mov    $0x0,%eax
 103:	c9                   	leave  
 104:	c3                   	ret    

00000105 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	57                   	push   %edi
 109:	56                   	push   %esi
 10a:	53                   	push   %ebx
 10b:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
 10e:	68 0c 01 00 00       	push   $0x10c
 113:	e8 fc ff ff ff       	call   114 <monitor+0xf>
	cprintf("Type 'help' for a list of commands.\n");
 118:	c7 04 24 30 01 00 00 	movl   $0x130,(%esp)
 11f:	e8 fc ff ff ff       	call   120 <monitor+0x1b>
 124:	83 c4 10             	add    $0x10,%esp


	while (1) {
		buf = readline("K> ");
 127:	83 ec 0c             	sub    $0xc,%esp
 12a:	68 60 00 00 00       	push   $0x60
 12f:	e8 fc ff ff ff       	call   130 <monitor+0x2b>
 134:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
 136:	83 c4 10             	add    $0x10,%esp
 139:	85 c0                	test   %eax,%eax
 13b:	74 ea                	je     127 <monitor+0x22>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
 13d:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
 144:	be 00 00 00 00       	mov    $0x0,%esi
 149:	eb 0a                	jmp    155 <monitor+0x50>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
 14b:	c6 03 00             	movb   $0x0,(%ebx)
 14e:	89 f7                	mov    %esi,%edi
 150:	8d 5b 01             	lea    0x1(%ebx),%ebx
 153:	89 fe                	mov    %edi,%esi
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
 155:	0f b6 03             	movzbl (%ebx),%eax
 158:	84 c0                	test   %al,%al
 15a:	74 63                	je     1bf <monitor+0xba>
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	0f be c0             	movsbl %al,%eax
 162:	50                   	push   %eax
 163:	68 64 00 00 00       	push   $0x64
 168:	e8 fc ff ff ff       	call   169 <monitor+0x64>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	75 d7                	jne    14b <monitor+0x46>
			*buf++ = 0;
		if (*buf == 0)
 174:	80 3b 00             	cmpb   $0x0,(%ebx)
 177:	74 46                	je     1bf <monitor+0xba>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
 179:	83 fe 0f             	cmp    $0xf,%esi
 17c:	75 14                	jne    192 <monitor+0x8d>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
 17e:	83 ec 08             	sub    $0x8,%esp
 181:	6a 10                	push   $0x10
 183:	68 69 00 00 00       	push   $0x69
 188:	e8 fc ff ff ff       	call   189 <monitor+0x84>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	eb 95                	jmp    127 <monitor+0x22>
			return 0;
		}
		argv[argc++] = buf;
 192:	8d 7e 01             	lea    0x1(%esi),%edi
 195:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
 199:	eb 03                	jmp    19e <monitor+0x99>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
 19b:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
 19e:	0f b6 03             	movzbl (%ebx),%eax
 1a1:	84 c0                	test   %al,%al
 1a3:	74 ae                	je     153 <monitor+0x4e>
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	0f be c0             	movsbl %al,%eax
 1ab:	50                   	push   %eax
 1ac:	68 64 00 00 00       	push   $0x64
 1b1:	e8 fc ff ff ff       	call   1b2 <monitor+0xad>
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	85 c0                	test   %eax,%eax
 1bb:	74 de                	je     19b <monitor+0x96>
 1bd:	eb 94                	jmp    153 <monitor+0x4e>
			buf++;
	}
	argv[argc] = 0;
 1bf:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
 1c6:	00 

	// Lookup and invoke the command
	if (argc == 0)
 1c7:	85 f6                	test   %esi,%esi
 1c9:	0f 84 58 ff ff ff    	je     127 <monitor+0x22>
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
 1cf:	83 ec 08             	sub    $0x8,%esp
 1d2:	68 1e 00 00 00       	push   $0x1e
 1d7:	ff 75 a8             	pushl  -0x58(%ebp)
 1da:	e8 fc ff ff ff       	call   1db <monitor+0xd6>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	85 c0                	test   %eax,%eax
 1e4:	74 1e                	je     204 <monitor+0xff>
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	68 2c 00 00 00       	push   $0x2c
 1ee:	ff 75 a8             	pushl  -0x58(%ebp)
 1f1:	e8 fc ff ff ff       	call   1f2 <monitor+0xed>
 1f6:	83 c4 10             	add    $0x10,%esp
 1f9:	85 c0                	test   %eax,%eax
 1fb:	75 2f                	jne    22c <monitor+0x127>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
 1fd:	b8 01 00 00 00       	mov    $0x1,%eax
 202:	eb 05                	jmp    209 <monitor+0x104>
		if (strcmp(argv[0], commands[i].name) == 0)
 204:	b8 00 00 00 00       	mov    $0x0,%eax
			return commands[i].func(argc, argv, tf);
 209:	83 ec 04             	sub    $0x4,%esp
 20c:	8d 14 00             	lea    (%eax,%eax,1),%edx
 20f:	01 d0                	add    %edx,%eax
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	8d 4d a8             	lea    -0x58(%ebp),%ecx
 217:	51                   	push   %ecx
 218:	56                   	push   %esi
 219:	ff 14 85 08 00 00 00 	call   *0x8(,%eax,4)


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
 220:	83 c4 10             	add    $0x10,%esp
 223:	85 c0                	test   %eax,%eax
 225:	78 1d                	js     244 <monitor+0x13f>
 227:	e9 fb fe ff ff       	jmp    127 <monitor+0x22>
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
 22c:	83 ec 08             	sub    $0x8,%esp
 22f:	ff 75 a8             	pushl  -0x58(%ebp)
 232:	68 86 00 00 00       	push   $0x86
 237:	e8 fc ff ff ff       	call   238 <monitor+0x133>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	e9 e3 fe ff ff       	jmp    127 <monitor+0x22>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
 244:	8d 65 f4             	lea    -0xc(%ebp),%esp
 247:	5b                   	pop    %ebx
 248:	5e                   	pop    %esi
 249:	5f                   	pop    %edi
 24a:	5d                   	pop    %ebp
 24b:	c3                   	ret  